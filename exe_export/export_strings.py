# -*- coding: utf-8 -*-
"""
SiglusEngine exe 日文文本导出脚本

用法:
    python export_strings.py <exe路径> [输出文本路径]

功能:
    扫描 exe 的 .rdata / .rsrc 段，提取以 UTF-16LE 空字符(00 00)结尾的、
    包含假名（平假名/片假名）的真实日文界面字符串，导出为文本文件。

输出格式:
    每一条文本占用两行：
        第一行: 原文（对照用）
        第二行: 译文（留空，由您手动翻译）
    注释行（以 # 开头）不会参与导入，其中标注了该条文本允许的最大字符数。
    若字符串内部含有换行符 \n，在导出时会转义为 \\n，导入时会自动还原。

导入时约束:
    译文(UTF-16LE)长度 + 2 字节空终止符 必须不超过原文所在槽位的大小。
    超过槽位的译文无法写回（会覆盖相邻字符串），导入脚本会报错跳过。
"""

import sys
import struct
import re


# ---------------------------------------------------------------------------
# 1. PE 结构解析
# ---------------------------------------------------------------------------
def parse_pe(data):
    """返回 (machine, sections) ，sections 为 [(name, raw_off, raw_size, va, vsize), ...]"""
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


# ---------------------------------------------------------------------------
# 2. 字符串判定
# ---------------------------------------------------------------------------
def _allowed(c):
    if c == 0x00A6:  # ¦ 字体表标记，排除
        return False
    # 拉丁-1 补充里只保留 × ÷（真实日文偶尔用到），其余（¨ © § ¬ 等）都是资源/表垃圾
    if 0x00A0 <= c <= 0x00FF and c not in (0x00D7, 0x00F7):
        return False
    return (
        0x3000 <= c <= 0x303F or        # CJK 标点 / 全角空格
        0x3040 <= c <= 0x30FF or        # 平假名 / 片假名
        0x31F0 <= c <= 0x31FF or        # 片假名语音扩展
        0x4E00 <= c <= 0x9FFF or        # CJK 统一汉字
        0xFF01 <= c <= 0xFF60 or        # 全角形式
        0xFF61 <= c <= 0xFF9F or        # 半角片假名
        0xFFE0 <= c <= 0xFFEE or        # 全角符号
        0x20 <= c <= 0x7E or            # ASCII
        0x2018 <= c <= 0x201D or        # 引号
        0x2190 <= c <= 0x21FF or        # 箭头
        0x2500 <= c <= 0x257F or        # 制表符
        0x25A0 <= c <= 0x25FF or        # 几何形状
        0x2600 <= c <= 0x26FF or        # 杂项符号
        0x2100 <= c <= 0x214F or        # 字母式符号
        0x2010 <= c <= 0x2015 or        # 破折号
        0xFE30 <= c <= 0xFE4F or        # CJK 兼容形式
        c in (0x000A, 0x000D, 0x0009) or  # 换行 / 回车 / 制表
        c in (0x00D7, 0x00F7)           # × ÷（真实日文偶尔用到）
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


# ---------------------------------------------------------------------------
# 3. 主流程
# ---------------------------------------------------------------------------
def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    exe_path = sys.argv[1]
    out_path = sys.argv[2] if len(sys.argv) > 2 else exe_path + '.strings.txt'

    with open(exe_path, 'rb') as f:
        data = f.read()

    sections = parse_pe(data)
    rdata = find_section(sections, '.rdata')
    rsrc = find_section(sections, '.rsrc')
    if rdata is None:
        raise ValueError('未找到 .rdata 段')

    # 文本区域：.rdata 中 0x64D900 ~ 0x681500（0x681500 之后为字体表等二进制数据）。
    # 注意: 这些偏移量是针对 SiglusEngine_CHS_RECOMPILE.exe 的实测值。
    # .rsrc 段内的对话框资源多为已翻译的中文或字节交换乱码, 不在此处提取。
    RDATA_TEXT_START = 0x64D900
    RDATA_TEXT_END = 0x681500
    regions = [('rdata', RDATA_TEXT_START, RDATA_TEXT_END)]

    # 收集所有字符串（记录每处的偏移，用于导入时回写全部相同文本的位置）
    # entries: {text: [(section, offset, term_offset, capacity_chars), ...]}
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
                # 槽位容量：从字符串起点到其后的第一个非零字节
                k = term
                while k < rend and data[k] == 0:
                    k += 1
                cap_chars = (k - i) // 2 - 1
                if cap_chars < len(s):
                    cap_chars = len(s)  # 保险：至少保证原文长度
                entries.setdefault(s, []).append((rname, i, term, cap_chars))
                i = term
            else:
                i += 2

    print(f'共发现 {sum(len(v) for v in entries.values())} 处日文文本, 去重后 {len(entries)} 条')

    def esc(text):
        return text.replace('\\', '\\\\').replace('\n', '\\n').replace('\r', '\\r').replace('\t', '\\t')

    lines = []
    lines.append('# SiglusEngine 日文文本导出文件')
    lines.append('# 每组由三行构成:')
    lines.append('#   第1行  以 # CAP: 开头, 标注容量上限与出现次数')
    lines.append('#   第2行  原文(对照)')
    lines.append('#   第3行  译文(请填写, 可留空)')
    lines.append('# 其余以 # 开头的行均为注释, 不会被导入。')
    lines.append('# 换行符写作 \\n，导入时会自动还原为真正的换行。')
    lines.append('# 译文不能超过该条文本的槽位容量，超长将无法写回 exe。')
    lines.append('')
    for text in sorted(entries.keys()):
        occ = entries[text]
        min_cap = min(o[3] for o in occ)
        lines.append(f'# CAP: 容量上限 {min_cap} 字符, 出现 {len(occ)} 次')
        lines.append(esc(text))
        lines.append('')

    with open(out_path, 'w', encoding='utf-8-sig', newline='\n') as f:
        f.write('\n'.join(lines))
        f.write('\n')

    print(f'已导出 -> {out_path}')
    print(f'文件顶部注释说明了格式；请在两行一组的第二行填写译文。')


if __name__ == '__main__':
    main()
