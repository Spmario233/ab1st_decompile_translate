# -*- coding: utf-8 -*-
"""
SiglusEngine exe 日文文本导出脚本

用法:
    python export_strings.py <exe路径> [输出文本路径]

功能:
    扫描 exe 的 .rdata 段以及 .rsrc 段中的对话框资源，提取以 UTF-16LE
    空字符(00 00)结尾的、真实的日文界面字符串（含假名，或为纯汉字/全角 ASCII 菜单词），
    导出为文本文件。

导出筛选规则（重要，供参考/自行调整）:
    1. 字符串以 UTF-16LE 空字符结尾，长度 2~300。
    2. 字符白名单:
       - 假名(平假名/片假名/半角片假名)、CJK 汉字、CJK 标点
       - 全角 ASCII(ＡＢＣ、０１２、％、（）等)、全角符号(￥、…)
       - ASCII 可打印字符(字母数字、空格、%、括号等)
       - 通用标点(※、〜、～ 等)、箭头(→←↑↓)、制表符/几何/杂项符号
       - 换行 \n、回车 \r、制表 \t
       - 拉丁-1 的 × ÷
    3. 至少包含假名，或包含汉字/全角 ASCII（用于纯汉字菜单词如「環境設定」「再生」）。
    4. 排除: 字节交换 ASCII 伪汉字(如 湩/瑩/慍)、字符集罗列(ＡＢＣ…Ｚ 等)。
    5. 扫描区域:
       - .rdata 段 0x64D900 ~ 0x681500（主文本池）
       - .rsrc 段 0x82FEC0 ~ 0x834800（日文对话框资源；该区之后为英文/西语/中文资源，
         非日文, 不导出）

输出格式:
    每一条文本对应三行:
        # CAP: 容量上限 N 字符, 出现 M 次
        原文(对照, 换行写作 \\n)
        译文(留空, 由您手动填写)
    导入时以 # CAP: 行为条目起点。

注意:
    - 若某条译文长度(UTF-16 字符数)超过该条文本的槽位容量, 导入脚本会跳过并提示。
    - 容量上限 = 原文所在槽位可容纳的最大字符数（含末尾空终止符）。
"""

import sys
import struct


# ---------------------------------------------------------------------------
# 1. PE 结构解析
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


# ---------------------------------------------------------------------------
# 2. 字符串判定
# ---------------------------------------------------------------------------
def _allowed(c):
    if c == 0x00A6:  # ¦ 字体表标记
        return False
    # 拉丁-1 补充里只保留 × ÷，其余（¨ © § ¬ 等）为资源/表垃圾
    if 0x00A0 <= c <= 0x00FF and c not in (0x00D7, 0x00F7):
        return False
    return (
        0x2000 <= c <= 0x206F or        # 通用标点（含 ※ 0x203B、… 等）
        0x2200 <= c <= 0x22FF or        # 数学运算符（含 ≪ 0x226A、≫ 0x226B 等日文强调括号）
        0x3000 <= c <= 0x303F or        # CJK 标点 / 全角空格
        0x3040 <= c <= 0x30FF or        # 平假名 / 片假名
        0x31F0 <= c <= 0x31FF or        # 片假名语音扩展
        0x4E00 <= c <= 0x9FFF or        # CJK 统一汉字
        0xFF01 <= c <= 0xFF60 or        # 全角形式
        0xFF61 <= c <= 0xFF9F or        # 半角片假名
        0xFFE0 <= c <= 0xFFEE or        # 全角符号
        0x20 <= c <= 0x7E or            # ASCII
        0x2190 <= c <= 0x21FF or        # 箭头
        0x2500 <= c <= 0x257F or        # 制表符
        0x25A0 <= c <= 0x25FF or        # 几何形状
        0x2600 <= c <= 0x26FF or        # 杂项符号
        0xFE30 <= c <= 0xFE4F or        # CJK 兼容形式
        c in (0x000A, 0x000D, 0x0009) or  # 换行 / 回车 / 制表
        c in (0x00D7, 0x00F7)           # × ÷
    )


def _has_kana(s):
    return any(0x3040 <= ord(c) <= 0x30FF or 0x31F0 <= ord(c) <= 0x31FF or 0xFF61 <= ord(c) <= 0xFF9F for c in s)


def _has_cjk(s):
    return any(0x4E00 <= ord(c) <= 0x9FFF for c in s)


def _has_fw(s):
    return any(0xFF01 <= ord(c) <= 0xFF5E for c in s)


def _is_charset_roster(s):
    """全角 ASCII 连续罗列（如 ＡＢＣ…Ｚ、！”＃…～），多为字体表。"""
    chars = [ord(c) for c in s]
    if len(s) < 6:
        return False
    symbols = sum(1 for c in chars if (0xFF01 <= c <= 0xFF5E) or c in (0xFFE5, 0x2018, 0x2019, 0x201C, 0x201D))
    return symbols >= len(chars) * 0.9


def _is_byteswap_garbage(s):
    """字节交换 ASCII 产生的伪汉字（如 湩/瑩/慍）: 所有汉字的高低字节都是 ASCII 可打印。"""
    cjk = [ord(c) for c in s if 0x4E00 <= ord(c) <= 0x9FFF]
    if not cjk:
        return False
    return all(0x20 <= c & 0xFF <= 0x7E and 0x20 <= (c >> 8) & 0xFF <= 0x7E for c in cjk)


def _is_text_str(s, offset=0):
    """
    判定一个 UTF-16LE 字符串是否为真实的日文界面文本。
    日文文本常用全角 ASCII（ＡＢＣ、０１２、％、（）、：等），因此也接受。
    """
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
    # 无假名：字节交换伪汉字只在早期“菜单词”区(0x64DA00-0x64E000)接受极短词
    if _is_byteswap_garbage(s) and fw == 0:
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


def _is_english_control(s):
    """对话框里的英文控件/系统类名，不是日文，排除。"""
    for w in ('msctls', 'Sys', 'Static', 'IDC', 'New', 'OK', 'Screen', 'Close',
              'Display', 'Reset', 'Cancel', 'MCI', 'Button', 'Edit', 'ComboBox',
              'ListBox', 'ScrollBar', 'TrackBar', 'UpDown', 'Progress', 'TabControl'):
        if w in s:
            return True
    return False


def _good_start(s):
    """滑动重扫时判断候选起点是否像真实文本的起始。"""
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
    """滑动重扫候选必须足够长且含足够假名，避免碎片。"""
    if len(ss) < 6:
        return False
    kana = sum(1 for c in ss if 0x3040 <= ord(c) <= 0x30FF or 0xFF61 <= ord(c) <= 0xFF9F)
    return kana >= 2


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
    if rdata is None:
        raise ValueError('未找到 .rdata 段')

    # 文本区域（针对 SiglusEngine_CHS_RECOMPILE.exe 实测）:
    #   .rdata 主文本池: 0x64D900 ~ 0x681500
    #   .rsrc 日文对话框: 0x82FEC0 ~ 0x834800 (其后为英文/西语/中文资源, 不导出)
    regions = [
        ('rdata', 0x64D900, 0x681500),
        ('rsrc', 0x82FEC0, 0x834800),
    ]

    # entries: {text: [(section, offset, term_offset, capacity_chars), ...]}
    entries = {}
    for rname, rstart, rend in regions:
        i = rstart
        while i < rend - 1:
            c = data[i] | (data[i + 1] << 8)
            if c == 0:
                i += 2
                continue
            # .rsrc 对话框资源: 跳过 DLGTEMPLATE 的 0xFFFF 0x0080/0x0082 前缀
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
                    # 合并串(数据前缀+真实文本)被拒时, 在串内滑动重扫,
                    # 找回被夹住的真实文本(它们以假名/汉字开头, 有代码引用)
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
                            entries.setdefault(ss, []).append((rname, j, tt, cap_chars))
                            i = tt
                        else:
                            i = term
                    else:
                        i = term
                    continue
                # 槽位容量: 从字符串起点到其后的第一个非零字节
                k = term
                while k < rend and data[k] == 0:
                    k += 1
                cap_chars = (k - i) // 2 - 1
                if cap_chars < len(s):
                    cap_chars = len(s)  # 保险: 至少保证原文长度
                entries.setdefault(s, []).append((rname, i, term, cap_chars))
                i = term
            else:
                i += 2

    total_occ = sum(len(v) for v in entries.values())
    print(f'共发现 {total_occ} 处日文文本, 去重后 {len(entries)} 条')

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
    print('文件顶部注释说明了格式与筛选规则；请在两行一组的第三行填写译文。')


if __name__ == '__main__':
    main()
