# -*- coding: utf-8 -*-
"""
SiglusEngine exe 汉化译文导入脚本

用法:
    python import_strings.py <exe路径> <译文文件路径> [新exe输出路径]

译文文件由 export_strings.py 生成，格式为每组三行:
    # CAP: 容量上限 N 字符, 出现 M 次
    原文(对照)
    译文(由您填写; 留空表示不修改)

导入规则:
    1. 从原文 exe 重新扫描字符串并记录每个文本的所有偏移与槽位容量。
    2. 对每条译文, 校验 UTF-16LE 编码后的字节长度(含 2 字节空终止符)
       不超过该文本在任意偏移处的槽位容量。
    3. 超长的译文会被跳过并打印警告, 其余正常写回。
    4. 生成新的 exe 文件（默认在 exe 同级目录, 文件名加 .patched 后缀）。

注意:
    同一文本若在 exe 中出现多次, 会全部替换为同一条译文。
"""

import sys
import struct


# ---------------------------------------------------------------------------
# PE 解析 (与 export_strings.py 一致)
# ---------------------------------------------------------------------------
def parse_pe(data):
    if data[:2] != b'MZ':
        raise ValueError('不是有效的 PE 文件（缺少 MZ 头）')
    pe_off = struct.unpack_from('<I', data, 0x3C)[0]
    if data[pe_off:pe_off + 4] != b'PE\x00\x00':
        raise ValueError('PE 头无效')
    num_sections = struct.unpack_from('<H', data, pe_off + 6)[0]
    opt_size = struct.unpack_from('<H', data, pe_off + 20)[0]
    sec_start = pe_off + 24 + opt_size
    image_base = struct.unpack_from('<I', data, pe_off + 24 + 28)[0]
    sections = []
    for i in range(num_sections):
        off = sec_start + i * 40
        name = data[off:off + 8].rstrip(b'\x00').decode('ascii', 'replace')
        vsize, vaddr, raw_size, raw_ptr = struct.unpack_from('<IIII', data, off + 8)
        sections.append((name, raw_ptr, raw_size, image_base + vaddr, vsize))
    return sections


def find_section(sections, name):
    for n, ro, rs, va, vs in sections:
        if n == name:
            return (ro, rs, va, vs)
    return None


def _allowed(c):
    if c == 0x00A6:  # ¦ 字体表标记，排除
        return False
    # 拉丁-1 补充里只保留 × ÷（真实日文偶尔用到），其余（¨ © § ¬ 等）都是资源/表垃圾
    if 0x00A0 <= c <= 0x00FF and c not in (0x00D7, 0x00F7):
        return False
    return (
        0x3000 <= c <= 0x303F or 0x3040 <= c <= 0x30FF or 0x31F0 <= c <= 0x31FF
        or 0x4E00 <= c <= 0x9FFF or 0xFF01 <= c <= 0xFF60 or 0xFF61 <= c <= 0xFF9F
        or 0xFFE0 <= c <= 0xFFEE or 0x20 <= c <= 0x7E or 0x2018 <= c <= 0x201D
        or 0x2190 <= c <= 0x21FF or 0x2500 <= c <= 0x257F or 0x25A0 <= c <= 0x25FF
        or 0x2600 <= c <= 0x26FF or 0x2100 <= c <= 0x214F
        or 0x2010 <= c <= 0x2015 or 0xFE30 <= c <= 0xFE4F or c in (0x000A, 0x000D, 0x0009)
        or c in (0x00D7, 0x00F7)  # × ÷（真实日文偶尔用到）
    )


def _is_text_str(s, offset=0):
    """
    判定一个 UTF-16LE 字符串是否为真实的日文界面文本。

    日文文本经常使用全角 ASCII 字符（ＡＢＣ、０１２、％、（）、：等），
    因此除假名外，也接受含汉字或全角 ASCII 的字符串；
    同时排除字体表/字符集罗列、字节交换 ASCII 等二进制数据。

    注: 纯汉字文本（如「環境設定」「再生」）是真实日文 UI 菜单项；
        offset 用于在“字节交换垃圾”与“真实汉字短词”之间做位置区分。
    """
    chars = [ord(ch) for ch in s]
    if not (2 <= len(s) <= 300):
        return False
    if not all(_allowed(c) for c in chars):
        return False
    kana = sum(1 for c in chars if 0x3040 <= c <= 0x30FF or 0x31F0 <= c <= 0x31FF or 0xFF61 <= c <= 0xFF9F)
    cjk = sum(1 for c in chars if 0x4E00 <= c <= 0x9FFF)
    fw = sum(1 for c in chars if 0xFF01 <= c <= 0xFF5E)   # 全角 ASCII
    # 字符集罗列型（例如 ＡＢＣ…Ｚ、！”＃…～ 这种连续的全角符号/字母）
    if len(s) >= 6:
        symbols = sum(1 for c in chars if (0xFF01 <= c <= 0xFF5E) or c in (0xFFE5, 0x2018, 0x2019, 0x201C, 0x201D))
        if symbols >= len(chars) * 0.9:
            return False
    if kana > 0:
        return True
    if cjk == 0 and fw == 0:
        return False
    # 无假名：检测是否为字节交换 ASCII 产生的伪汉字（如 湩/瑩/慍）
    cjk_chars = [c for c in chars if 0x4E00 <= c <= 0x9FFF]
    byteswap_garbage = False
    if cjk_chars:
        byteswap_garbage = all(0x20 <= c & 0xFF <= 0x7E and 0x20 <= (c >> 8) & 0xFF <= 0x7E for c in cjk_chars)
    if byteswap_garbage and not fw:
        # 仅在早期“菜单词”区接受极短的纯汉字（如 全体），其余按垃圾排除
        return 0x64DA00 <= offset < 0x64E000 and len(s) <= 4
    return True


def _read_utf16(data, start, rend):
    buf = []
    i = start
    while i + 1 < rend:
        c = data[i] | (data[i + 1] << 8)
        if c == 0:
            return ''.join(buf), i + 2
        buf.append(chr(c))
        i += 2
    return None, None


def scan_strings(data, sections):
    """返回 {text: [(offset, cap_chars), ...]} ，text 为原文。"""
    rdata = find_section(sections, '.rdata')
    if rdata is None:
        raise ValueError('未找到 .rdata 段')

    RDATA_TEXT_START = 0x64D900
    RDATA_TEXT_END = 0x681500
    regions = [('rdata', RDATA_TEXT_START, RDATA_TEXT_END)]

    entries = {}
    for rname, rstart, rend in regions:
        i = rstart
        while i < rend - 1:
            c = data[i] | (data[i + 1] << 8)
            if c == 0:
                i += 2
                continue
            if (0x20 <= c < 0xD800) or (0xE000 <= c < 0xFFFE) or c in (0x000A, 0x000D, 0x0009):
                s, term = _read_utf16(data, i, rend)
                if s is None:
                    break
                if not _is_text_str(s, offset=i):
                    i = term
                    continue
                k = term
                while k < rend and data[k] == 0:
                    k += 1
                cap_chars = (k - i) // 2 - 1
                if cap_chars < len(s):
                    cap_chars = len(s)
                entries.setdefault(s, []).append((i, cap_chars))
                i = term
            else:
                i += 2
    return entries


def _unesc(text):
    return (text.replace('\\\\', '\x00BSLASH\x00')
                .replace('\\n', '\n').replace('\\r', '\r').replace('\\t', '\t')
                .replace('\x00BSLASH\x00', '\\'))


def parse_translation_file(path):
    """返回 [(original, translation), ...]，original 为还原后的原文。"""
    with open(path, 'r', encoding='utf-8-sig') as f:
        raw_lines = f.read().split('\n')
    pairs = []
    i = 0
    while i < len(raw_lines):
        line = raw_lines[i].rstrip('\r')
        if line.startswith('# CAP:'):
            # 其后两行: 原文 / 译文
            if i + 2 < len(raw_lines):
                orig = _unesc(raw_lines[i + 1].rstrip('\r'))
                trans = _unesc(raw_lines[i + 2].rstrip('\r'))
                pairs.append((orig, trans))
                i += 3
            else:
                i += 1
        elif line.startswith('#') or line.strip() == '':
            i += 1
        else:
            # 非标准行: 尝试按 原文/译文 两行一组继续读取
            if i + 1 < len(raw_lines):
                orig = _unesc(line)
                trans = _unesc(raw_lines[i + 1].rstrip('\r'))
                pairs.append((orig, trans))
                i += 2
            else:
                i += 1
    return pairs


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    exe_path = sys.argv[1]
    trans_path = sys.argv[2]
    out_path = sys.argv[3] if len(sys.argv) > 3 else exe_path + '.patched.exe'

    with open(exe_path, 'rb') as f:
        data = bytearray(f.read())

    sections = parse_pe(data)
    scan = scan_strings(data, sections)

    pairs = parse_translation_file(trans_path)
    print(f'译文文件共 {len(pairs)} 条记录')

    replaced = 0
    skipped = []
    unchanged = 0
    not_found = []

    for orig, trans in pairs:
        if not trans:
            unchanged += 1
            continue
        if orig not in scan:
            not_found.append((orig, trans))
            continue
        occs = scan[orig]
        # 校验在所有出现位置都能容纳
        new_bytes = trans.encode('utf-16-le') + b'\x00\x00'
        ok = all(len(new_bytes) <= (cap * 2 + 2) for _, cap in occs)
        if not ok:
            min_cap = min(cap for _, cap in occs)
            skipped.append((orig, trans, min_cap, len(trans)))
            continue
        for off, cap in occs:
            # 写回并清零其余部分（保持空终止符与对齐）
            data[off:off + len(new_bytes)] = new_bytes
            # 将原来位置剩余字节清零
            clear_from = off + len(new_bytes)
            clear_to = off + (cap * 2 + 2)
            if clear_to > clear_from:
                for j in range(clear_from, min(clear_to, len(data))):
                    data[j] = 0
        replaced += 1

    print(f'成功替换: {replaced} 条')
    print(f'译文留空(未修改): {unchanged} 条')
    print(f'超长被跳过: {len(skipped)} 条')
    for orig, trans, cap, ln in skipped[:30]:
        print(f'  [超长] 容量{cap} < 译文长度{ln}: {orig} -> {trans}')
    if len(skipped) > 30:
        print(f'  ... 其余 {len(skipped) - 30} 条略')
    print(f'未在exe中找到原文: {len(not_found)} 条')
    for orig, trans in not_found[:10]:
        print(f'  [未找到] {orig!r}')

    if replaced == 0 and not skipped:
        print('没有写入任何译文，未生成新文件。')
        return

    with open(out_path, 'wb') as f:
        f.write(data)
    print(f'已生成 -> {out_path}')


if __name__ == '__main__':
    main()
