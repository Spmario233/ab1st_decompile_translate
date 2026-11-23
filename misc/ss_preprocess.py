# -*- coding: utf-8 -*-
"""
Siglus 场景脚本预处理：
  1) 把「未被双引号包围的剧情文字」（语句级全角字符串 token）加上双引号；
  2) 在行尾以注释形式贴出该行的原有日文文本，便于对照翻译；
  3) 不破坏 .inc 中定义的各种非 ASCII 名称（@变量、宏、#replace、#define、#command ...）。

设计依据：SiglusManual_cn.txt 与 siglus-ssu manual_cn.md 中的 SiglusSS 语言规范：
 - 全角/双字节字符序列本身就是一个 VAL_STR（字符串）token，双引号字符串也是 VAL_STR，
   因此把裸文本包进双引号不改变 token 序列（编译产物应逐字节一致）。
 - 替换(置换)发生在词法分析之前，所以 @女生徒と呼ぶ 这类含非 ASCII 的名称必须先被识别为
   「名称 token」，绝不能加引号，否则替换失效 —— 这正是旧版脚本编译失败的原因。
 - 全角序列不可能包含 半角双引号 / 反斜杠 / 半角 yen 符号，因此包裹时永远不需要转义。

用法:
  python ss_preprocess.py [--src ss_utf8] [--dst ss_pre] [--report preprocess_report.txt]
                          [--include-99] [--dry-run] [--verbose]
"""
import argparse
import collections
import pathlib
import re
import sys

# ---------------------------------------------------------------- 字符判定
ZEN_CACHE = {}


def is_zen(ch):
    """Windows CP932 双字节字符（规范中的「全角/双字节裸字符串」字符）。"""
    v = ZEN_CACHE.get(ch)
    if v is None:
        try:
            v = len(ch.encode("cp932")) == 2
        except UnicodeEncodeError:
            v = False
        ZEN_CACHE[ch] = v
    return v


# ---------------------------------------------------------------- 名字提取
DECL_RE = re.compile(r"#(replace|define_s|define|macro|property|command)")
IGNORED_LINE_START = ("//", ";")


def name_from_decl(line):
    """按规范提取 #replace/#define/#define_s/#macro/#property/#command 的名字。"""
    s = line.lstrip()
    m = DECL_RE.match(s)
    if not m:
        return None
    kind, rest = m.group(1), s[m.end():].lstrip(" \t")
    if not rest:
        return None
    if kind == "define_s":          # 名字遇到 TAB 或换行结束（可含空格）
        nm = rest.split("\t")[0]
    elif kind == "command":         # 空格 ( : TAB 换行
        nm = re.split(r"[ \t(:\n]", rest)[0]
    elif kind == "property":        # 空格 : TAB 换行
        nm = re.split(r"[ \t:\n]", rest)[0]
    elif kind == "macro":           # 宏名必须以 @ 开头
        nm = re.split(r"[ \t(\n]", rest)[0]
    else:                           # replace / define：空格 TAB 换行
        nm = re.split(r"[ \t\n]", rest)[0]
    return nm or None


def strip_comments_for_decl(text):
    """把块注释整块去掉（只用于收集 #replace/#define 名字，避免注释里的假声明）。"""
    out = []
    in_block = False
    for line in text.splitlines():
        if in_block:
            if "*/" in line:
                line = line[line.index("*/") + 2:]
                in_block = False
            else:
                continue
        if "/*" in line:
            head, _, tail = line.partition("/*")
            if "*/" in tail:
                line = head + tail.split("*/", 1)[1]
            else:
                line = head
                in_block = True
        out.append(line)
    return "\n".join(out)


def collect_inc_names(src_dir):
    names = set()
    for f in sorted(src_dir.iterdir()):
        if f.suffix.lower() != ".inc":
            continue
        text = strip_comments_for_decl(f.read_text(encoding="utf-8-sig"))
        for line in text.splitlines():
            if line.lstrip().startswith(IGNORED_LINE_START):
                continue
            nm = name_from_decl(line)
            if nm:
                names.add(nm)
    return names


def collect_scene_names(text):
    names = set()
    for line in strip_comments_for_decl(text).splitlines():
        if line.lstrip().startswith(IGNORED_LINE_START):
            continue
        nm = name_from_decl(line)
        if nm:
            names.add(nm)
    return names


# ---------------------------------------------------------------- 词法
IDENT_START = set("_$@abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
IDENT_CONT = IDENT_START | set("0123456789")
DELIMS = set(".,:()[]{}【】")
OPS = set("+-*/%&|^~<>=!")

WS, COMMENT, STRING, CHAR, NAME, NAMETAG, LABEL, IDENT, NUM, DELIM, OP, ZEN, OTHER = (
    "WS", "COMMENT", "STRING", "CHAR", "NAME", "NAMETAG", "LABEL", "IDENT", "NUM",
    "DELIM", "OP", "ZEN", "OTHER",
)


class Tok:
    __slots__ = ("k", "v", "start", "end", "depth", "callee", "prev", "next")

    def __init__(self, k, v, start, end):
        self.k, self.v, self.start, self.end = k, v, start, end
        self.depth = 0
        self.callee = None
        self.prev = None
        self.next = None

    def __repr__(self):
        return "Tok(%s,%r)" % (self.k, self.v)


class Lexer:
    def __init__(self, names):
        self.buckets = collections.defaultdict(list)
        for n in names:
            self.buckets[n[0]].append(n)
        for k in self.buckets:
            self.buckets[k].sort(key=len, reverse=True)

    def match_name(self, line, i):
        lst = self.buckets.get(line[i])
        if not lst:
            return None
        for n in lst:
            if line.startswith(n, i):
                return n
        return None

    def lex(self, line):
        toks = []
        i, n = 0, len(line)
        while i < n:
            ch = line[i]
            if ch in " \t":
                j = i
                while j < n and line[j] in " \t":
                    j += 1
                toks.append(Tok(WS, line[i:j], i, j))
                i = j
                continue
            if line.startswith("//", i) or ch == ";":
                toks.append(Tok(COMMENT, line[i:], i, n))
                break
            if line.startswith("/*", i):
                j = line.find("*/", i + 2)
                if j < 0:
                    toks.append(Tok(COMMENT, line[i:], i, n))
                    break
                toks.append(Tok(COMMENT, line[i:j + 2], i, j + 2))
                i = j + 2
                continue
            if ch == '"':
                j = i + 1
                while j < n:
                    c = line[j]
                    if c == "\\" and j + 1 < n:
                        j += 2
                        continue
                    if c == '"':
                        break
                    j += 1
                end = j + 1 if j < n else n
                toks.append(Tok(STRING, line[i:end], i, end))
                i = end
                continue
            if ch == "'":
                j = i + 1
                while j < n:
                    c = line[j]
                    if c == "\\" and j + 1 < n:
                        j += 2
                        continue
                    if c == "'":
                        break
                    j += 1
                end = j + 1 if j < n else n
                toks.append(Tok(CHAR, line[i:end], i, end))
                i = end
                continue
            nm = self.match_name(line, i)
            if nm:
                toks.append(Tok(NAME, nm, i, i + len(nm)))
                i += len(nm)
                continue
            if ch == "【":
                j = line.find("】", i + 1)
                if j >= 0:
                    toks.append(Tok(NAMETAG, line[i:j + 1], i, j + 1))
                    i = j + 1
                    continue
            if ch == "#":
                j = i + 1
                while j < n and line[j].isascii() and (line[j].isalnum() or line[j] == "_"):
                    j += 1
                toks.append(Tok(LABEL, line[i:j], i, j))
                i = j
                continue
            if ch.isascii() and ch in IDENT_START:
                j = i + 1
                while j < n and line[j].isascii() and line[j] in IDENT_CONT:
                    j += 1
                toks.append(Tok(IDENT, line[i:j], i, j))
                i = j
                continue
            if ch.isascii() and ch.isdigit():
                j = i + 1
                while j < n and line[j].isascii() and (line[j].isalnum() or line[j] == "_"):
                    j += 1
                toks.append(Tok(NUM, line[i:j], i, j))
                i = j
                continue
            if ch in DELIMS:
                toks.append(Tok(DELIM, ch, i, i + 1))
                i += 1
                continue
            if ch in OPS:
                j = i + 1
                while j < n and j - i < 3 and line[j] in OPS:
                    j += 1
                toks.append(Tok(OP, line[i:j], i, j))
                i = j
                continue
            if is_zen(ch):
                j = i + 1
                while j < n and is_zen(line[j]) and line[j] not in "【】":
                    if self.match_name(line, j):
                        break
                    j += 1
                toks.append(Tok(ZEN, line[i:j], i, j))
                i = j
                continue
            j = i + 1
            while j < n:
                c = line[j]
                if c.isascii() and (c in IDENT_START or c in DELIMS or c in OPS or c.isdigit() or c == "#"):
                    break
                if c in '"\'': 
                    break
                if is_zen(c):
                    break
                j += 1
            toks.append(Tok(OTHER, line[i:j], i, j))
            i = j
        return toks


# ---------------------------------------------------------------- 变换
# 选项列表（SELBTN）里以裸文本出现的选项也属于剧情文字，同样加引号。
SEL_CALLS = {"SELBTN"}


class Preprocessor:
    def __init__(self, names, verbose=None):
        self.lexer = Lexer(names)
        self.verbose = verbose

    @staticmethod
    def _standalone_arg(prev, nxt):
        return (
            prev is not None and prev.k == DELIM and prev.v in "(,"
            and nxt is not None and nxt.k == DELIM and nxt.v in ",)"
        )

    def process_text(self, text, stats):
        lines = text.splitlines(keepends=True)

        # ---- 第一遍：词法分析 + 跨行的括号深度 / 调用栈 / 前后 token
        parsed = []          # 每行: None(不改动) 或 token 列表
        flat = []            # 全文件的「有效 token」序列
        depth = 0
        in_block = False
        stack = []           # [(callee, line_idx)]
        last_sig = None
        for lineno, raw in enumerate(lines):
            body = raw.rstrip("\r\n")
            stripped = body.lstrip()
            if in_block:
                parsed.append(None)
                if "*/" in body:
                    in_block = False
                continue
            if not stripped:
                parsed.append(None)
                continue
            if stripped.startswith("/*"):
                parsed.append(None)
                if "*/" not in stripped:
                    in_block = True
                continue
            if stripped.startswith("#"):
                # 预处理指令 / 标签：整行不动（其中可能有 #replace/#define 的名字）
                if name_from_decl(stripped):
                    stats["directive"] += 1
                parsed.append(None)
                continue

            toks = self.lexer.lex(body)
            d = depth
            for t in toks:
                t.depth = d
                if t.k == DELIM and t.v in "([":
                    if t.v == "(":
                        callee = last_sig.v if (last_sig is not None and last_sig.k in (IDENT, NAME)) else None
                        stack.append((callee, lineno))
                    else:
                        stack.append((None, lineno))
                    d += 1
                elif t.k == DELIM and t.v in ")]":
                    if stack:
                        stack.pop()
                    d -= 1
                else:
                    t.callee = stack[-1][0] if stack else None
                if t.k not in (WS, COMMENT):
                    last_sig = t
                    flat.append(t)
            depth = d
            parsed.append(toks)

        # 前后相邻的有效 token
        for i, t in enumerate(flat):
            t.prev = flat[i - 1] if i > 0 else None
            t.next = flat[i + 1] if i + 1 < len(flat) else None

        # ---- 第二遍：决定哪些 token 加引号并改写
        out = []
        for lineno, raw in enumerate(lines):
            body = raw.rstrip("\r\n")
            eol = raw[len(body):]
            toks = parsed[lineno]
            if toks is None:
                out.append(raw)
                continue
            stripped = body.lstrip()

            quote = []
            for t in toks:
                if t.k != ZEN:
                    continue
                if t.depth == 0:
                    quote.append(t)
                elif self._standalone_arg(t.prev, t.next):
                    if t.callee in SEL_CALLS:
                        quote.append(t)
                    else:
                        stats["skipped_arg"] += 1
                        if self.verbose is not None:
                            self.verbose.append((lineno + 1, t.callee, stripped[:110]))
                else:
                    stats["skipped_nonstandalone"] += 1
                    if self.verbose is not None:
                        self.verbose.append((lineno + 1, "nonstandalone", stripped[:110]))

            if not quote:
                out.append(raw)
                continue

            cmt = next((t for t in toks if t.k == COMMENT), None)
            cmt_start = cmt.start if cmt is not None else len(body)

            pieces = []
            pos = 0
            for t in quote:
                pieces.append(body[pos:t.start])
                pieces.append('"' + t.v + '"')
                pos = t.end
            pieces.append(body[pos:cmt_start])
            code = "".join(pieces).rstrip()

            original = body[quote[0].start:cmt_start].rstrip()
            stats["lines_changed"] += 1
            stats["tokens_quoted"] += len(quote)

            if cmt is not None:
                after = body[cmt_start:].rstrip()
                if after[2:].strip() == original.strip():
                    # 行尾已经有内容相同的对照注释，不再重复
                    stats["already_annotated"] += 1
                    out.append(code + " " + after + eol)
                else:
                    out.append(code + " //" + original + "\t" + after + eol)
            else:
                out.append(code + " //" + original + eol)
        return "".join(out)


# ---------------------------------------------------------------- 目标文件
def build_targets(src, include_99=False):
    """剧情脚本 = 从 00_AB01a_day00.ss 到 44_バッドエンド.ss 的那批 .ss。"""
    ref = None
    new_dir = src.parent / "ss_new"
    if new_dir.is_dir():
        ref = {f.name for f in new_dir.iterdir() if f.suffix.lower() == ".ss"}
    out = []
    for f in sorted(src.iterdir()):
        if f.suffix.lower() != ".ss":
            continue
        if f.name.startswith("_"):
            continue
        if ref is not None and f.name not in ref:
            continue
        if f.name.startswith("99_") and not include_99:
            continue
        out.append(f.name)
    return out


def main(argv=None):
    here = pathlib.Path(__file__).resolve().parent
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", default=str(here / "ss_utf8"))
    ap.add_argument("--dst", default=str(here / "ss_pre"))
    ap.add_argument("--report", default=str(here / "preprocess_report.txt"))
    ap.add_argument("--include-99", action="store_true")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args(argv)

    src = pathlib.Path(args.src)
    dst = pathlib.Path(args.dst)
    if not src.is_dir():
        sys.exit("source dir not found: %s" % src)

    inc_names = collect_inc_names(src)
    print("inc names: %d (non-ascii: %d)" % (
        len(inc_names), sum(1 for n in inc_names if any(ord(c) > 127 for c in n))))

    targets = build_targets(src, args.include_99)
    print("target files: %d" % len(targets))

    dst.mkdir(exist_ok=True)
    total = collections.Counter()
    report = []
    skipped_all = []
    for name in targets:
        text = (src / name).read_text(encoding="utf-8-sig")
        names = inc_names | collect_scene_names(text)
        verbose = []   # 始终收集，便于写入报告
        pp = Preprocessor(names, verbose)
        stats = collections.Counter()
        new = pp.process_text(text, stats)
        total.update(stats)
        report.append((name, stats["lines_changed"], stats["tokens_quoted"]))
        for ln, callee, s in verbose:
            skipped_all.append((name, ln, callee, s))
        if not args.dry_run:
            with open(dst / name, "wb") as f:
                f.write(new.encode("utf-8"))
        print("  %-32s changed=%-6d quoted=%-6d skipped=%d" % (
            name, stats["lines_changed"], stats["tokens_quoted"],
            stats["skipped_arg"] + stats["skipped_nonstandalone"]))

    print("TOTAL lines changed: %d, tokens quoted: %d, skipped zen: %d" % (
        total["lines_changed"], total["tokens_quoted"],
        total["skipped_arg"] + total["skipped_nonstandalone"]))
    with open(args.report, "w", encoding="utf-8") as f:
        f.write("# siglus 剧本预处理报告\n")
        f.write("范围: 00_AB01a_day00.ss .. 44_バッドエンド.ss 的剧情脚本（不含 99_* 与 _ 开头的系统脚本）\n")
        f.write("target files: %d\n" % len(targets))
        f.write("lines changed: %d\n" % total["lines_changed"])
        f.write("tokens quoted: %d\n" % total["tokens_quoted"])
        f.write("skipped zen tokens (inside call args, left untouched): %d\n"
                % (total["skipped_arg"] + total["skipped_nonstandalone"]))
        f.write("\nfile\tlines_changed\ttokens_quoted\n")
        for name, a, b in report:
            f.write("%s\t%d\t%d\n" % (name, a, b))
        if skipped_all:
            f.write("\n# 未加引号的全角 token（调用参数内的非选项文本，保持原样）\n")
            for name, ln, callee, s in skipped_all:
                f.write("%s:%d\t%s\t%s\n" % (name, ln, callee, s))


if __name__ == "__main__":
    main()
