#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 lyrics 文件夹里已经调整好格式的 .lrc 批量转换成 dat 文件夹里的 .csv。

生成的 csv 用于 siglus-ssu 生成 .dbs 数据库，再由 __chs_lyrics.ss 在游戏内读取。
转换命令示例：

    siglus-ssu -d --c dat\\crowsong.csv binary\\1st_beat\\dat\\crowsong.dbs

lrc 支持两种写法（可混用）：

    1) 每行两个时间戳：[开始时间][结束时间]歌词
         例：[00:25.550][00:31.000]背後にはシャッターの壁
    2) 每行一个时间戳（只给开始时间）：
         例：[00:25.550]背後にはシャッターの壁
       结束时间自动取下一句的开始时间；最后一句取 [length:] 指定的总时长。

其他约定：
    - 支持 [ti:]（标题）、[ar:]（艺术家）、[length:mm:ss.mmm]（音频总长）、
      [offset:+/-毫秒]（整体平移，正数表示歌词提前）。
    - “//” 或 “#” 开头的行视为注释；[xx:...] 形式的普通标签会被忽略。
    - 同一时间戳下的两行歌词视为一组：含假名的一行当日文，另一行当中文；
      无法判断时按出现顺序（前日文、后中文）。
    - 数据库列：0=开始时间(毫秒) 1=结束时间(毫秒) 2=中文歌词 3=日文歌词。
"""

import re
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
LYRICS_DIR = BASE_DIR / "lyrics"
DAT_DIR = BASE_DIR / "dat"

# [mm:ss.xxx] / [mm:ss:xxx]
TS_RE = re.compile(r"\[(\d{1,3}):(\d{1,2})[.:](\d{1,3})\]")
TAG_RE = re.compile(r"^\[([a-zA-Z_]+):(.*)\]$")
# 假名（平假名 + 片假名 + 长音符）
KANA_RE = re.compile(r"[\u3040-\u30ff\u31f0-\u31ff]")

CSV_HEADER_COLS = ["开始时间", "结束时间", "中文歌词", "日文歌词"]


class LyricLine:
    __slots__ = ("start", "end", "text")

    def __init__(self, start, end, text):
        self.start = start
        self.end = end
        self.text = text


def parse_time(match) -> int:
    """把正则匹配到的时间转成毫秒。"""
    minute, second, frac = match.group(1), match.group(2), match.group(3)
    # 兼容 [xx:xx.5] / [xx:xx.55] / [xx:xx.555]
    frac_ms = int((frac + "000")[:3])
    return int(minute) * 60000 + int(second) * 1000 + frac_ms


def format_time(ms: int) -> str:
    return "%02d:%02d.%03d" % (ms // 60000, ms % 60000 // 1000, ms % 1000)


def read_lrc(path: Path):
    """解析 lrc，返回 (标签字典, 行列表, 警告列表)。"""
    tags = {}
    lines = []
    warnings = []
    offset = 0

    for lineno, raw in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        text = raw.strip()
        if not text or text.startswith("//") or text.startswith("#"):
            continue

        # 单一标签行，例如 [ti:Crow Song]
        tag = TAG_RE.match(text)
        if tag and not TS_RE.match(text):
            key = tag.group(1).lower()
            value = tag.group(2).strip()
            tags[key] = value
            if key == "length":
                m = TS_RE.search("[" + value + "]")
                if m:
                    tags["length_ms"] = parse_time(m)
                else:
                    warnings.append("第 %d 行：[length:] 格式无法识别：%s" % (lineno, value))
            elif key == "offset":
                try:
                    offset = int(value)
                except ValueError:
                    warnings.append("第 %d 行：[offset:] 不是整数：%s" % (lineno, value))
            continue

        stamps = list(TS_RE.finditer(text))
        if not stamps:
            warnings.append("第 %d 行：没有时间戳，已跳过：%s" % (lineno, text))
            continue

        start = parse_time(stamps[0])
        end = parse_time(stamps[1]) if len(stamps) >= 2 else None
        body = text[stamps[-1].end():]
        if not body:
            warnings.append("第 %d 行：歌词为空，已跳过" % lineno)
            continue
        lines.append(LyricLine(start, end, body))

    if offset:
        for line in lines:
            line.start -= offset
            if line.end is not None:
                line.end -= offset

    return tags, lines, warnings


def clamp_text(text: str) -> str:
    """数据库用逗号分隔字段，正文里的半角逗号换成全角，避免切错列。"""
    return text.replace(",", "，").replace("\r", " ").replace("\n", " ").strip()


def group_lines(lines, warnings):
    """把同一时间戳的多行合成一组（日文 / 中文）。"""
    groups = []
    for line in lines:
        if groups and groups[-1]["start"] == line.start:
            groups[-1]["texts"].append(line)
        else:
            groups.append({"start": line.start, "end": line.end, "texts": [line]})

    result = []
    for g in groups:
        texts = g["texts"]
        if len(texts) > 2:
            warnings.append("%s 有 %d 行同时间戳歌词，只取前两行"
                            % (format_time(g["start"]), len(texts)))
            texts = texts[:2]

        jp = cn = None
        if len(texts) == 2:
            a, b = texts
            a_kana, b_kana = bool(KANA_RE.search(a.text)), bool(KANA_RE.search(b.text))
            if a_kana and not b_kana:
                jp, cn = a, b
            elif b_kana and not a_kana:
                jp, cn = b, a
            else:
                jp, cn = a, b          # 无法判断时按顺序
        else:
            only = texts[0]
            if KANA_RE.search(only.text):
                jp = only
            else:
                cn = only

        result.append({
            "start": g["start"],
            "end": g["end"],
            "jp": clamp_text(jp.text) if jp else "",
            "cn": clamp_text(cn.text) if cn else "",
        })
    return result


def build_rows(groups, tags, warnings):
    """补齐结束时间，返回 (rows, 警告列表)。"""
    length = tags.get("length_ms")
    rows = []
    for i, g in enumerate(groups):
        end = g["end"]
        if end is None or end <= g["start"]:
            if i + 1 < len(groups):
                end = groups[i + 1]["start"]
            elif length and length > g["start"]:
                end = length
            else:
                end = g["start"] + 5000
                warnings.append("%s 是最后一句且没有结束时间，暂用 +5000ms"
                                % format_time(g["start"]))
        rows.append((g["start"], end, g["cn"], g["jp"]))
    return rows


def write_csv(path: Path, title: str, rows):
    labels = ["★%s歌词" % title] + CSV_HEADER_COLS
    out = [
        ",".join(labels),
        "#DATANO,0,1,2,3",
        "#DATATYPE,V,V,S,S",
        ",,,,",
    ]
    for idx, (start, end, cn, jp) in enumerate(rows):
        out.append("%d,%d,%d,%s,%s" % (idx, start, end, cn, jp))
    data = "\r\n".join(out) + "\r\n"
    path.write_bytes(data.encode("utf-8-sig"))


def convert(path: Path, out_dir: Path) -> bool:
    tags, lines, warnings = read_lrc(path)
    if not lines:
        print("跳过 %s：没有解析到歌词" % path.name)
        return False

    groups = group_lines(lines, warnings)
    rows = build_rows(groups, tags, warnings)
    title = tags.get("ti") or path.stem

    out_path = out_dir / (path.stem + ".csv")
    write_csv(out_path, title, rows)

    print("%s -> %s" % (path.name, out_path.relative_to(BASE_DIR) if out_path.is_relative_to(BASE_DIR) else out_path))
    print("    标题：%s    行数：%d    %s ~ %s（%s ~ %s）"
          % (title, len(rows), format_time(rows[0][0]), format_time(rows[-1][1]),
             rows[0][0], rows[-1][1]))
    for w in warnings:
        print("    警告：" + w)
    return True


def main(argv) -> int:
    out_dir = DAT_DIR
    args = []
    for a in argv:
        if a in ("-h", "--help"):
            print(__doc__)
            return 0
        elif a.startswith("--out="):
            out_dir = Path(a.split("=", 1)[1]).resolve()
        elif a.startswith("--lyrics="):
            args.append(Path(a.split("=", 1)[1]).resolve())
        else:
            args.append(Path(a))

    out_dir.mkdir(parents=True, exist_ok=True)
    if args:
        files = args
    else:
        if not LYRICS_DIR.is_dir():
            print("错误：找不到目录 %s" % LYRICS_DIR, file=sys.stderr)
            return 1
        files = sorted(LYRICS_DIR.glob("*.lrc"))
        if not files:
            print("错误：%s 里没有 .lrc 文件" % LYRICS_DIR, file=sys.stderr)
            return 1

    print("开始转换 %d 个 lrc ..." % len(files))
    done = 0
    for f in files:
        if not f.is_file():
            print("错误：找不到文件 %s" % f, file=sys.stderr)
            continue
        if convert(f, out_dir):
            done += 1
    print("完成：成功 %d / %d" % (done, len(files)))
    return 0 if done == len(files) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
