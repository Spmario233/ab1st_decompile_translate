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
    扫描区域与导出脚本一致: .rdata 0x64D900~0x681500, .rsrc 0x82FEC0~0x834800。
"""

import sys
import struct


# ---------------------------------------------------------------------------
# PE 解析
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
    if c == 0x00A6:
        return False
    if 0x00A0 <= c <= 0x00FF and c not in (0x00D7, 0x00F7):
        return False
    return (
        0x2000 <= c <= 0x206F or 0x2200 <= c <= 0x22FF or 0x3000 <= c <= 0x303F or 0x3040 <= c <= 0x30FF
        or 0x31F0 <= c <= 0x31FF or 0x4E00 <= c <= 0x9FFF or 0xFF01 <= c <= 0xFF60
        or 0xFF61 <= c <= 0xFF9F or 0xFFE0 <= c <= 0xFFEE or 0x20 <= c <= 0x7E
        or 0x2190 <= c <= 0x21FF or 0x2500 <= c <= 0x257F or 0x25A0 <= c <= 0x25FF
        or 0x2600 <= c <= 0x26FF or 0xFE30 <= c <= 0xFE4F or c in (0x000A, 0x000D, 0x0009)
        or c in (0x00D7, 0x00F7)
    )


def _has_kana(s):
    return any(0x3040 <= ord(c) <= 0x30FF or 0x31F0 <= ord(c) <= 0x31FF or 0xFF61 <= ord(c) <= 0xFF9F for c in s)


def _is_charset_roster(s):
    chars = [ord(c) for c in s]
    if len(s) < 6:
        return False
    symbols = sum(1 for c in chars if (0xFF01 <= c <= 0xFF5E) or c in (0xFFE5, 0x2018, 0x2019, 0x201C, 0x201D))
    return symbols >= len(chars) * 0.9


def _is_byteswap_garbage(s):
    cjk = [ord(c) for c in s if 0x4E00 <= ord(c) <= 0x9FFF]
    if not cjk:
        return False
    return all(0x20 <= c & 0xFF <= 0x7E and 0x20 <= (c >> 8) & 0xFF <= 0x7E for c in cjk)


def _is_text_str(s, offset=0):
    chars = [ord(ch) for ch in s]
    if not (2 <= len(s) <= 300):
        return False
    if not all(_allowed(c) for c in chars):
        return False
    if _is_charset_roster(s):
        return False
    kana = sum(1 for c in chars if 0x3040 <= c <= 0x30FF or 0x31F0 <= c <= 0x31FF or 0xFF61 <= c <= 0xFF9F)
    cjk = sum(1 for c in chars if 0x4E00 <= c <= 0x9FFF)
    fw = sum(1 for c in chars if 0xFF01 <= c <= 0xFF5E)
    if kana > 0:
        return True
    if cjk == 0 and fw == 0:
        return False
    if _is_byteswap_garbage(s) and fw == 0:
        return 0x64DA00 <= offset < 0x64E000 and len(s) <= 4
    return True


def _is_english_control(s):
    for w in ('msctls', 'Sys', 'Static', 'IDC', 'New', 'OK', 'Screen', 'Close',
              'Display', 'Reset', 'Cancel', 'MCI', 'Button', 'Edit', 'ComboBox',
              'ListBox', 'ScrollBar', 'TrackBar', 'UpDown', 'Progress', 'TabControl'):
        if w in s:
            return True
    return False


def _good_start(s):
    c = ord(s[0])
    if not ((0x3040 <= c <= 0x30FF) or (0xFF61 <= c <= 0xFF9F) or (0x4E00 <= c <= 0x9FFF)
            or (0xFF01 <= c <= 0xFF5E) or (0x3000 <= c <= 0x303F) or (0x2600 <= c <= 0x26FF)
            or (0x2500 <= c <= 0x257F) or (0x25A0 <= c <= 0x25FF)):
        return False
    for ch in s[:3]:
        cc = ord(ch)
        if (0xE000 <= cc <= 0xF8FF) or cc < 0x20 or cc == 0xFFFF or cc in (0x0060, 0x00A6):
            return False
    return True


def _slide_candidate_ok(ss):
    if len(ss) < 6:
        return False
    kana = sum(1 for c in ss if 0x3040 <= ord(c) <= 0x30FF or 0xFF61 <= ord(c) <= 0xFF9F)
    return kana >= 2


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

    regions = [
        ('rdata', 0x64D900, 0x681500),
        ('rsrc', 0x82FEC0, 0x834800),
    ]

    entries = {}
    for rname, rstart, rend in regions:
        i = rstart
        while i < rend - 1:
            c = data[i] | (data[i + 1] << 8)
            if c == 0:
                i += 2
                continue
            if rname == 'rsrc' and c == 0xFFFF and i + 3 < rend:
                c1 = data[i + 2] | (data[i + 3] << 8)
                if c1 in (0x0080, 0x0082):
                    i += 4
                    continue
            if (0x20 <= c < 0xD800) or (0xE000 <= c < 0xFFFE) or c in (0x000A, 0x000D, 0x0009):
                s, term = _read_utf16(data, i, rend)
                if s is None:
                    break
                ok = _is_text_str(s, offset=i)
                if rname == 'rsrc' and _is_english_control(s):
                    ok = False
                if not ok:
                    # 合并串被拒时, 在串内滑动重扫找回被夹住的真实文本
                    if _has_kana(s):
                        best = None
                        for j in range(i + 2, term - 1, 2):
                            ss, tt = _read_utf16(data, j, rend)
                            if ss is None or tt is None:
                                break
                            s_ok = _is_text_str(ss, offset=j) and _good_start(ss) and _slide_candidate_ok(ss)
                            if rname == 'rsrc' and _is_english_control(ss):
                                s_ok = False
                            if s_ok and (best is None or len(ss) > len(best[2])):
                                best = (j, tt, ss)
                        if best:
                            j, tt, ss = best
                            k = tt
                            while k < rend and data[k] == 0:
                                k += 1
                            cap_chars = (k - j) // 2 - 1
                            if cap_chars < len(ss):
                                cap_chars = len(ss)
                            entries.setdefault(ss, []).append((j, cap_chars))
                            i = tt
                        else:
                            i = term
                    else:
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
        new_bytes = trans.encode('utf-16-le') + b'\x00\x00'
        ok = all(len(new_bytes) <= (cap * 2 + 2) for _, cap in occs)
        if not ok:
            min_cap = min(cap for _, cap in occs)
            skipped.append((orig, trans, min_cap, len(trans)))
            continue
        for off, cap in occs:
            data[off:off + len(new_bytes)] = new_bytes
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
        print(f'  [超长] 容量{cap} < 译文长度{ln}: {orig[:30]} -> {trans[:30]}')
    if len(skipped) > 30:
        print(f'  ... 其余 {len(skipped) - 30} 条略')
    print(f'未在exe中找到原文: {len(not_found)} 条')
    for orig, trans in not_found[:10]:
        print(f'  [未找到] {orig[:40]!r}')

    if replaced == 0 and not skipped:
        print('没有写入任何译文，未生成新文件。')
        return

    with open(out_path, 'wb') as f:
        f.write(data)
    print(f'已生成 -> {out_path}')


if __name__ == '__main__':
    main()
