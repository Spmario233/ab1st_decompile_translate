# -*- coding: utf-8 -*-
"""
SiglusEngine exe 汉化译文导入脚本 (v2)

用法:
    python import_strings.py <exe路径> <译文文件路径> [新exe输出路径]

译文文件由 export_strings.py (v2) 生成, 格式为每条三行:
    #@<偏移>|<区域>|...|cap <容量上限>
    原文(对照)
    译文(由您填写; 留空表示不修改)

导入规则:
    1. rdata(普通文本池): 按偏移直接替换。译文可短于原文(不足补0), 不可超长。
    2. rsrc(对话框资源): 按 资源id|item序号|字段 定位, 修改 DLGTEMPLATE 中
       对应控件文本, 重新序列化整个对话框模板(重新计算 DWORD 对齐),
       然后更新 .rsrc 资源表(该资源 Size 与后续所有资源 data_rva)并搬移数据。
       译文长度不限(可不等长), 安全。
    3. 生成新的 exe 文件。
"""

import sys
import struct

try:
    import dlgtemplate
except ImportError:
    sys.path.insert(0, __file__ and __file__.rsplit('\\', 1)[0])
    import dlgtemplate


# ---------------------------------------------------------------------------
# PE / 资源表
# ---------------------------------------------------------------------------
def parse_pe(data):
    if data[:2] != b'MZ':
        raise ValueError('不是有效的 PE 文件')
    pe_off = struct.unpack_from('<I', data, 0x3C)[0]
    num_sec = struct.unpack_from('<H', data, pe_off + 6)[0]
    opt_size = struct.unpack_from('<H', data, pe_off + 20)[0]
    sec_start = pe_off + 24 + opt_size
    image_base = struct.unpack_from('<I', data, pe_off + 24 + 28)[0]
    sections = []
    for i in range(num_sec):
        off = sec_start + i * 40
        name = data[off:off + 8].rstrip(b'\x00').decode('ascii', 'replace')
        vsize, vaddr, raw_size, raw_ptr = struct.unpack_from('<IIII', data, off + 8)
        # 与 dlgtemplate 一致: 第4项为 RVA (vaddr)
        sections.append((name, raw_ptr, raw_size, vaddr, vsize))
    return sections


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
# 译文文件解析
# ---------------------------------------------------------------------------
def _unesc(text):
    return (text.replace('\\\\', '\x00BSLASH\x00')
                .replace('\\n', '\n').replace('\\r', '\r').replace('\\t', '\t')
                .replace('\x00BSLASH\x00', '\\'))


def parse_translation_file(path):
    """返回 [(header_dict, original, translation), ...]
    header_dict = {'off': int, 'region': str, 'extra': str, 'cap': int}
    """
    with open(path, 'r', encoding='utf-8-sig') as f:
        raw_lines = f.read().split('\n')
    out = []
    i = 0
    while i < len(raw_lines):
        line = raw_lines[i].rstrip('\r')
        if line.startswith('#@'):
            if i + 2 < len(raw_lines):
                hdr = line[2:]
                parts = hdr.split('|')
                off = int(parts[0], 16)
                region = parts[1] if len(parts) > 1 else 'rdata'
                extra = ''
                cap = None
                for p in parts[2:]:
                    if p.startswith('cap '):
                        cap = int(p[4:])
                    elif p:
                        extra = (extra + '|' + p) if extra else p
                orig = _unesc(raw_lines[i + 1].rstrip('\r'))
                trans = _unesc(raw_lines[i + 2].rstrip('\r'))
                out.append(({'off': off, 'region': region, 'extra': extra, 'cap': cap}, orig, trans))
                i += 3
            else:
                i += 1
        elif line.startswith('#') or line.strip() == '':
            i += 1
        else:
            if i + 1 < len(raw_lines):
                orig = _unesc(line)
                trans = _unesc(raw_lines[i + 1].rstrip('\r'))
                out.append(({'off': None, 'region': 'rdata', 'extra': '', 'cap': None}, orig, trans))
                i += 2
            else:
                i += 1
    return out


# ---------------------------------------------------------------------------
# rdata 替换
# ---------------------------------------------------------------------------
def replace_rdata(data, off, orig, trans):
    """rdata 文本: 按偏移替换, 译文可短于原文(补0), 不可超长。"""
    cap = len(orig)  # 至少等长; 若有更大空间(到下一非零)可略放宽, 但保守用原文长
    new_bytes = trans.encode('utf-16-le') + b'\x00\x00'
    if len(new_bytes) > cap * 2 + 2:
        return False, f'译文超长: {orig[:20]} -> {trans[:20]} ({len(trans)}>={len(orig)})'
    data[off:off + len(new_bytes)] = new_bytes
    for j in range(off + len(new_bytes), off + cap * 2 + 2):
        if j < len(data):
            data[j] = 0
    return True, ''


# ---------------------------------------------------------------------------
# rsrc 替换 (重新序列化 + 更新资源表)
# ---------------------------------------------------------------------------
def build_rsrc_index(data, sections):
    """返回 {raw_off: (rid, lang, data_rva, size)}"""
    return dlgtemplate.get_dlg_resources(data, sections)


def apply_rsrc_translations(data, sections, dlg_translations):
    """
    按 (rid, item_idx, field) 原位替换对话框资源中的文本。

    策略: 在原始 DLGTEMPLATEEX 模板的精确字节位置替换字符串, 译文填充到
    与原文字节数相同(不足用零宽空格 U+200B 补齐, 不占显示宽度), 从而保持
    模板布局完全不变, 不触发重新对齐, 避免 Windows/游戏解析错位。

    译文不能超过原字段字节数(超长则报错跳过)。
    """
    errors = []

    # 原位替换: 每个要修改的字符串字段, 在原始模板的精确字节位置替换文本。
    # 译文填充到与原文字节数相同(用零宽空格 U+200B, 不占显示宽度),
    # 从而保持 DLGTEMPLATEEX 模板布局完全不变, 不触发重新对齐。
    modified_dlgs = {}  # raw_off -> set()
    for raw_off, texts in dlg_translations.items():
        dlg, st = dlgtemplate.parse_dlg(data, raw_off)
        if st != 'OK':
            errors.append(f'解析对话框 {raw_off:#x} 失败: {st}')
            continue
        for item_idx, field_map in texts.items():
            for field, newval in field_map.items():
                if newval is None:
                    continue
                if item_idx == -1:
                    # 对话框窗口标题 (header title)
                    if field == 'htitle':
                        part = dlg['header_parts'][2]
                    else:
                        continue
                elif item_idx < len(dlg['items']):
                    it = dlg['items'][item_idx]
                    part = it[field]
                else:
                    errors.append(f'对话框 {raw_off:#x} item{item_idx} 越界')
                    continue
                if not (isinstance(part, tuple) and len(part) == 4 and part[0] == 'str'):
                    errors.append(f'对话框 {raw_off:#x} item{item_idx} {field} 不是可替换文本')
                    continue
                str_start, str_end = part[2], part[3]
                orig_len = str_end - str_start  # 原文字节数(含null终止符)
                # 译文编码为 UTF-16LE
                body = newval.encode('utf-16-le')
                if len(body) + 2 > orig_len:
                    # 译文超长: 无法原位替换
                    errors.append(f'对话框 {raw_off:#x} item{item_idx} {field} 译文超长'
                                  f'({len(body) + 2} > {orig_len}字节)')
                    continue
                # 不足部分用零宽空格(U+200B)填充在 null 之前, 保持 null 在字段末尾
                while len(body) + 2 < orig_len:
                    body += '\u200b'.encode('utf-16-le')
                new_b = body + b'\x00\x00'
                data[str_start:str_end] = new_b
                modified_dlgs.setdefault(raw_off, set()).add((item_idx, field))


    if errors:
        return False, errors

    # 原位替换不改变任何资源的大小或偏移, 无需更新资源表。
    return True, errors


def rva_to_raw_from(data, sections, rva):
    for name, rptr, rsize, vaddr, vsize in sections:
        if vaddr <= rva < vaddr + max(vsize, rsize):
            return rptr + (rva - vaddr)
    return None


# ---------------------------------------------------------------------------
# 主流程
# ---------------------------------------------------------------------------
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

    pairs = parse_translation_file(trans_path)
    print(f'译文文件共 {len(pairs)} 条记录')

    replaced = 0
    unchanged = 0
    not_found = []
    too_long = []
    rsrc_trans = {}  # raw_off -> {item_idx: {field: newval}}
    rsrc_entries = []  # 记录 rsrc 条目的 id/item/f 用于定位

    # 先收集 rsrc 翻译, 再统一处理
    for hdr, orig, trans in pairs:
        if not trans:
            unchanged += 1
            continue
        if hdr['region'] == 'rsrc':
            # extra 格式: id=X|item=Y|f=Z (或 id=X|f=htitle 表示对话框窗口标题)
            extra = hdr['extra']
            import re
            m_id = re.search(r'id=(\d+)', extra)
            m_item = re.search(r'item=(\d+)', extra)
            m_f = re.search(r'f=(\w+)', extra)
            if not (m_id and m_f):
                not_found.append((orig, trans))
                continue
            rid = int(m_id.group(1))
            item_idx = int(m_item.group(1)) if m_item else -1
            field = m_f.group(1)
            # 找到该 id 的对话框 raw_off
            raw_off = None
            for r_off, (r_id, lang, drva, size) in dlgtemplate.get_dlg_resources(data, sections).items():
                if r_id == rid:
                    raw_off = r_off
                    break
            if raw_off is None:
                not_found.append((orig, trans))
                continue
            rsrc_trans.setdefault(raw_off, {}).setdefault(item_idx, {})[field] = trans
            rsrc_entries.append((raw_off, item_idx, field, orig, trans))
        else:
            # rdata
            off = hdr['off']
            if off is None:
                not_found.append((orig, trans))
                continue
            ok, err = replace_rdata(data, off, orig, trans)
            if ok:
                replaced += 1
            else:
                too_long.append((orig, trans))

    # 处理 rsrc 对话框
    if rsrc_trans:
        ok, errs = apply_rsrc_translations(data, sections, rsrc_trans)
        if ok:
            replaced += sum(len(v) for v in rsrc_trans.values())
        else:
            print('rsrc 处理错误:')
            for e in errs:
                print('  ', e)
            sys.exit(1)

    print(f'成功替换: {replaced} 条')
    print(f'译文留空(未修改): {unchanged} 条')
    print(f'超长被跳过: {len(too_long)} 条')
    for orig, trans in too_long[:20]:
        print(f'  [超长] {orig[:30]} -> {trans[:30]}')
    print(f'未找到: {len(not_found)} 条')

    if replaced == 0 and not too_long:
        print('没有写入任何译文，未生成新文件。')
        return

    with open(out_path, 'wb') as f:
        f.write(data)
    print(f'已生成 -> {out_path}')


if __name__ == '__main__':
    main()
