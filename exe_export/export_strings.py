# -*- coding: utf-8 -*-
"""
SiglusEngine exe 日文文本导出脚本 (v2: 不合并重复文本, 每条带偏移标识)

用法:
    python export_strings.py <exe路径> [输出文本路径]

功能:
    扫描 exe 的 .rdata 段以及 .rsrc 段中的对话框资源，提取真实的日文界面文本
    （含假名，或为纯汉字/全角 ASCII 菜单词），导出为文本文件。
    每条文本(每个出现位置)单独一行，不再合并重复文本，可分别翻译。

导出文件格式 (每条三行):
    #@<偏移>|<区域>|<附加信息>|cap <容量上限>
    原文(对照, 换行写作 \\n)
    译文(留空, 由您手动填写)

    例如:
        #@0x64D900|rdata|cap 39
        \\n\\n[ サポート情報 ]\\nこのメッセージは Ctrl+C でコピーできます。

        #@0x831376|rsrc|id=124|cap 12
        ムービーの再生方法の設定

区域说明:
    rdata = 普通文本池(.rdata), 译文可短于原文(补0)。
    rsrc  = 对话框资源(DLGTEMPLATE), 译文将重新序列化模板(不等长安全)。
            id= 表示所属对话框资源 ID。

筛选规则 (供参考/自行调整):
    1. 字符串以 UTF-16LE 空字符结尾, 长度 2~300。
    2. 字符白名单: 假名/CJK汉字/全角ASCII/ASCII/常用日文标点(※〜→等)/×÷。
    3. 至少包含假名, 或包含汉字/全角 ASCII。
    4. 排除: 字节交换 ASCII 伪汉字、字符集罗列(ＡＢＣ…Ｚ等)。
    5. 扫描区域: .rdata 0x64D900~0x681500, .rsrc 0x82FEC0~0x834800。
"""

import sys
import struct

try:
    import dlgtemplate
except ImportError:
    sys.path.insert(0, __file__ and __file__.rsplit('\\', 1)[0])
    import dlgtemplate


# ---------------------------------------------------------------------------
# 字符串判定
# ---------------------------------------------------------------------------
def _allowed(c):
    if c == 0x00A6:
        return False
    if 0x00A0 <= c <= 0x00FF and c not in (0x00D7, 0x00F7):
        return False
    return (
        0x2000 <= c <= 0x206F or 0x2200 <= c <= 0x22FF or 0x3000 <= c <= 0x303F
        or 0x3040 <= c <= 0x30FF or 0x31F0 <= c <= 0x31FF or 0x4E00 <= c <= 0x9FFF
        or 0xFF01 <= c <= 0xFF60 or 0xFF61 <= c <= 0xFF9F or 0xFFE0 <= c <= 0xFFEE
        or 0x20 <= c <= 0x7E or 0x2190 <= c <= 0x21FF or 0x2500 <= c <= 0x257F
        or 0x25A0 <= c <= 0x25FF or 0x2600 <= c <= 0x26FF or 0xFE30 <= c <= 0xFE4F
        or c in (0x000A, 0x000D, 0x0009) or c in (0x00D7, 0x00F7)
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


# ---------------------------------------------------------------------------
# 扫描
# ---------------------------------------------------------------------------
def scan_plain(data, rstart, rend, region):
    """扫描 .rdata 文本池(空终止 UTF-16 串)。返回 [(offset, text, cap_chars), ...]"""
    out = []
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
            if _is_text_str(s, offset=i):
                k = term
                while k < rend and data[k] == 0:
                    k += 1
                cap = (k - i) // 2 - 1
                if cap < len(s):
                    cap = len(s)
                out.append((i, s, cap))
                i = term
            else:
                # 合并串被拒时滑动重扫
                if _has_kana(s):
                    best = None
                    for j in range(i + 2, term - 1, 2):
                        ss, tt = _read_utf16(data, j, rend)
                        if ss is None or tt is None:
                            break
                        if _is_text_str(ss, offset=j) and _good_start(ss) and _slide_candidate_ok(ss):
                            if best is None or len(ss) > len(best[2]):
                                best = (j, tt, ss)
                    if best:
                        j, tt, ss = best
                        k = tt
                        while k < rend and data[k] == 0:
                            k += 1
                        cap = (k - j) // 2 - 1
                        if cap < len(ss):
                            cap = len(ss)
                        out.append((j, ss, cap))
                        i = tt
                    else:
                        i = term
                else:
                    i = term
        else:
            i += 2
    return out


def scan_dlg_texts(data, raw_off, dlg_size):
    """解析一个 DLGTEMPLATE 资源, 返回其控件文本 [(字段偏移, 文本, 是class还是title)]"""
    dlg, st = dlgtemplate.parse_dlg(data, raw_off)
    if st != 'OK':
        return [], None
    # 收集控件文本: class 或 title 字段中, 值为字符串的部分
    texts = []
    for it in dlg['items']:
        for field in ('clazz', 'title'):
            part = it[field]
            if isinstance(part, tuple) and part[0] == 'str':
                # 需要计算该文本的偏移: 从 item 起始偏移字段
                texts.append((it['start'], field, part[1]))
    return texts, dlg


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    exe_path = sys.argv[1]
    out_path = sys.argv[2] if len(sys.argv) > 2 else exe_path + '.strings.txt'

    with open(exe_path, 'rb') as f:
        data = f.read()

    sections = dlgtemplate.parse_pe_sections(data)
    dlgs = dlgtemplate.get_dlg_resources(data, sections)

    # 收集所有条目: (offset, text, region, cap, extra)
    entries = []

    # 1. rdata 文本池
    for off, s, cap in scan_plain(data, 0x64D900, 0x681500, 'rdata'):
        entries.append((off, s, 'rdata', cap, ''))

    # 2. rsrc 对话框控件文本 (只导日文 lang=1041)
    for raw_off, (rid, lang, drva, size) in sorted(dlgs.items()):
        if lang != 1041:  # 只导日文(1041)
            continue
        # 排除明显是图片/图标的对话框(它们无文本或文本为系统类名)
        if size > 0x3000:
            continue
        dlg, st = dlgtemplate.parse_dlg(data, raw_off)
        if st != 'OK':
            continue
        # 对话框窗口标题 (header 的 title 字段, 用 f=htitle 标识)
        ht = dlg['header_parts'][2]
        if isinstance(ht, tuple) and ht[0] == 'str' and ht[1]:
            s = ht[1]
            if 2 <= len(s) <= 300 and _is_text_str(s, offset=raw_off):
                entries.append((raw_off, s, 'rsrc', len(s), f'id={rid}|f=htitle'))
        # 用 (item 序号, 字段) 精确定位每个控件文本; 导入时按此重新定位
        for idx, it in enumerate(dlg['items']):
            for field in ('clazz', 'title'):
                part = it[field]
                if isinstance(part, tuple) and part[0] == 'str' and part[1]:
                    s = part[1]
                    if 2 <= len(s) <= 300 and _is_text_str(s, offset=raw_off):
                        if _is_english_control(s):
                            continue
                        entries.append((raw_off, s, 'rsrc', len(s), f'id={rid}|item={idx}|f={field}'))

    # 排序: 按偏移
    entries.sort(key=lambda e: e[0])

    def esc(text):
        return text.replace('\\', '\\\\').replace('\n', '\\n').replace('\r', '\\r').replace('\t', '\\t')

    lines = []
    lines.append('# SiglusEngine 日文文本导出文件 (v2)')
    lines.append('# 每条(每个出现位置)为三行:')
    lines.append('#   第1行  #@偏移|区域|附加信息|cap 容量上限')
    lines.append('#   第2行  原文(对照)')
    lines.append('#   第3行  译文(请填写, 可留空)')
    lines.append('# 同一文本出现在多处时, 会作为多条分别导出, 可分别翻译。')
    lines.append('# rdata 译文可短于原文(不足自动补0); rsrc(对话框)译文不等长也可安全替换。')
    lines.append('# 换行符写作 \\n，导入时自动还原。')
    lines.append('')
    for off, s, region, cap, extra in entries:
        extra_str = ('|' + extra) if extra else ''
        lines.append(f'#@{off:#x}|{region}{extra_str}|cap {cap}')
        lines.append(esc(s))
        lines.append('')

    with open(out_path, 'w', encoding='utf-8-sig', newline='\n') as f:
        f.write('\n'.join(lines))
        f.write('\n')

    print(f'共导出 {len(entries)} 条文本(每条一个出现位置)')
    print(f'已导出 -> {out_path}')
    print('文件顶部注释说明了格式与筛选规则；请在第3行填写译文。')


if __name__ == '__main__':
    main()
