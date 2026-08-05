# -*- coding: utf-8 -*-
"""
DLGTEMPLATE (对话框模板) 与 .rsrc 资源表处理模块。

用于对 exe 中的 Windows 对话框资源(DLGTEMPLATEEX)进行:
  - 解析: 提取各控件文本
  - 重新序列化: 译文不等长时重新计算 DWORD 对齐, 安全替换
  - 资源表更新: 修改某对话框资源后, 更新该资源 Size 与后续所有资源 data_rva
  - 数据搬移: 在 .rsrc 段内移动后续数据

适用于 SiglusEngine_CHS_RECOMPILE.exe。
"""

import struct


def parse_pe_sections(data):
    """返回 [(name, raw_ptr, raw_size, rva, vsize), ...]"""
    if data[:2] != b'MZ':
        raise ValueError('不是有效的 PE 文件')
    pe_off = struct.unpack_from('<I', data, 0x3C)[0]
    num_sec = struct.unpack_from('<H', data, pe_off + 6)[0]
    opt_size = struct.unpack_from('<H', data, pe_off + 20)[0]
    sec_start = pe_off + 24 + opt_size
    sections = []
    for i in range(num_sec):
        off = sec_start + i * 40
        name = data[off:off + 8].rstrip(b'\x00').decode('ascii', 'replace')
        vsize, vaddr, rsize, rptr = struct.unpack_from('<IIII', data, off + 8)
        sections.append((name, rptr, rsize, vaddr, vsize))
    return sections


def rva_to_raw(data, sections, rva):
    for name, rptr, rsize, vaddr, vsize in sections:
        if vaddr <= rva < vaddr + max(vsize, rsize):
            return rptr + (rva - vaddr)
    return None


def raw_to_rva(data, sections, raw):
    for name, rptr, rsize, vaddr, vsize in sections:
        if rptr <= raw < rptr + rsize:
            return vaddr + (raw - rptr)
    return None


# ---------------------------------------------------------------------------
# .rsrc 资源表
# ---------------------------------------------------------------------------
def iter_resource_entries(data, sections):
    """遍历 .rsrc 资源目录, 产出 (type, id, lang, data_rva, size)。
    同时返回所有 data entry 在文件中的位置(用于后续更新)。"""
    rsrc = None
    for name, rptr, rsize, vaddr, vsize in sections:
        if name == '.rsrc':
            rsrc = (rptr, rsize, vaddr, vsize)
            break
    if rsrc is None:
        return [], [], rsrc
    RSRC_RAW, RSRC_SIZE, RSRC_RVA, RSRC_VSIZE = rsrc

    entries = []          # [(type, id, lang, data_rva, size)]
    entry_locs = []       # [(type, id, lang, data_entry_file_off)]
    def parse_dir(off_in_rsrc, type_name, res_id, lang_chain):
        raw = RSRC_RAW + off_in_rsrc
        numNamed, numId = struct.unpack_from('<HH', data, raw + 12)
        total = numNamed + numId
        for i in range(total):
            entry = raw + 16 + i * 8
            name, off = struct.unpack_from('<II', data, entry)
            nm = name & 0x7FFFFFFF
            if off & 0x80000000:
                parse_dir(off & 0x7FFFFFFF, type_name, nm, lang_chain)
            else:
                eraw = RSRC_RAW + off
                data_rva, size = struct.unpack_from('<II', data, eraw)
                # 语言 = 当前目录名(第二级) 或 第三级
                lang = nm if type_name is not None else res_id
                entries.append((type_name, res_id, lang, data_rva, size))
                entry_locs.append((type_name, res_id, lang, eraw))

    base = RSRC_RAW
    numNamed, numId = struct.unpack_from('<HH', data, base + 12)
    for i in range(numNamed + numId):
        entry = base + 16 + i * 8
        name, off = struct.unpack_from('<II', data, entry)
        nm = name & 0x7FFFFFFF
        if off & 0x80000000:
            parse_dir(off & 0x7FFFFFFF, nm, 0, [])
    return entries, entry_locs, rsrc


def get_dlg_resources(data, sections):
    """返回 {raw_off: (res_id, data_rva, size)}, 仅 RT_DIALOG。"""
    entries, _, _ = iter_resource_entries(data, sections)
    result = {}
    for typ, rid, lang, data_rva, size in entries:
        if typ == 5:  # RT_DIALOG
            raw = rva_to_raw(data, sections, data_rva)
            if raw is not None:
                result[raw] = (rid, lang, data_rva, size)
    return result


# ---------------------------------------------------------------------------
# DLGTEMPLATEEX 解析 / 序列化
# ---------------------------------------------------------------------------
def parse_dlg(data, start):
    """
    解析 DLGTEMPLATEEX。
    返回 (dict, 'OK') 或 (None, 错误信息)。
    dict: {cDlg, header_parts, items, end}
    item: {helpID, exStyle, style, x,y,cx,cy, id, clazz, title, creation}
    clazz/title: None 表示 0xFFFF+类型(预定义); 字符串表示显式类名/文本。
    """
    pos = start
    def r16():
        nonlocal pos
        if pos + 2 > len(data): raise Exception('OOB16')
        v = data[pos] | (data[pos+1] << 8); pos += 2; return v
    def r32():
        nonlocal pos
        if pos + 4 > len(data): raise Exception('OOB32')
        v = data[pos] | (data[pos+1]<<8) | (data[pos+2]<<16) | (data[pos+3]<<24); pos += 4; return v
    def align4():
        nonlocal pos
        pos = (pos + 3) & ~3
    try:
        dlgVer = r16(); sig = r16()
        if not (dlgVer == 1 and sig == 0xFFFF):
            return None, 'not DLGTEMPLATEEX'
        helpID = r32(); exStyle = r32(); style = r32()
        cDlg = r16(); x, y, cx, cy = r16(), r16(), r16(), r16()
        header_parts = []
        def read_str_or_type():
            m = r16()
            if m == 0xFFFF:
                t = r16(); return (0xFFFF, t)
            elif m != 0:
                # m 是字符串的第一个字符
                s = [chr(m)]
                str_start = pos - 2
                while True:
                    cc = r16()
                    if cc == 0: break
                    s.append(chr(cc))
                str_end = pos
                # 游戏模板: 字符串后不 DWORD 对齐, 直接下一个字段
                return ('str', ''.join(s), str_start, str_end)
            else:
                return (0, None)
        header_parts.append(read_str_or_type())  # menu
        header_parts.append(read_str_or_type())  # class
        header_parts.append(read_str_or_type())  # title
        # DS_SETFONT (0x40): title 后是字体定义, 结构在游戏的不同对话框中不一致
        # (有的有 weight/italic/charset 字段, 有的没有)。为保证逐字节保真,
        # 将 font 区域整体按原始字节保存, encode 时原样写回。
        font = None
        if style & 0x00000040:
            fs = pos
            # 扫描到 typeface 字符串结束(不 DWORD 对齐)
            tf_chars = []
            while True:
                if pos + 2 > len(data):
                    raise Exception('OOB font')
                cc = r16()
                if cc == 0:
                    break
                tf_chars.append(chr(cc))
            font = {'raw_start': fs, 'raw_end': pos,
                    'raw_bytes': bytes(data[fs:pos])}
        items = []
        # 记录每个 item 前是否已对齐(用于确认模板的 item 边界规则)
        item_starts = []
        for _ in range(cDlg):
            align4()
            item_start = pos
            i_help = r32(); i_ex = r32(); i_sty = r32()
            ix, iy, icx, icy = r16(), r16(), r16(), r16()
            i_id = r32()
            clazz = read_str_or_type()
            title = read_str_or_type()
            creation = r16()
            items.append({
                'helpID': i_help, 'exStyle': i_ex, 'style': i_sty,
                'x': ix, 'y': iy, 'cx': icx, 'cy': icy, 'id': i_id,
                'clazz': clazz, 'title': title, 'creation': creation,
                'start': item_start,
            })
        return {
            'help': helpID, 'exStyle': exStyle, 'style': style,
            'cDlg': cDlg, 'x': x, 'y': y, 'cx': cx, 'cy': cy,
            'header_parts': header_parts, 'font': font, 'items': items,
            'start': start, 'end': pos,
        }, 'OK'
    except Exception as e:
        return None, f'ERR {e}'


def encode_dlg(dlg):
    """将解析出的 DLGTEMPLATE 重新序列化(重新计算 DWORD 对齐)。"""
    out = bytearray()
    def w16(v): out.extend(struct.pack('<H', v))
    def w32(v): out.extend(struct.pack('<I', v))
    def align4_out():
        while len(out) % 4:
            out.append(0)
    w16(1); w16(0xFFFF)
    w32(dlg['help']); w32(dlg['exStyle']); w32(dlg['style'])
    w16(dlg['cDlg']); w16(dlg['x']); w16(dlg['y']); w16(dlg['cx']); w16(dlg['cy'])
    def write_str_or_type(part):
        if isinstance(part, tuple) and len(part) == 4:
            marker, val = part[0], part[1]
        else:
            marker, val = part[0], part[1]
        if marker == 0:
            w16(0)
        elif marker == 0xFFFF:
            w16(0xFFFF); w16(val)
        else:  # 'str'
            out.extend(val.encode('utf-16-le'))
            w16(0)
            # 游戏模板: 字符串后不 DWORD 对齐, 直接下一个字段
    for part in dlg['header_parts']:
        write_str_or_type(part)
    if dlg.get('font') is not None:
        # 原样写回 font 原始字节(含 pointSize/weight/italic/charset/typeface 混合结构)
        out.extend(dlg['font']['raw_bytes'])
    for it in dlg['items']:
        align4_out()
        w32(it['helpID']); w32(it['exStyle']); w32(it['style'])
        w16(it['x']); w16(it['y']); w16(it['cx']); w16(it['cy'])
        w32(it['id'])
        write_str_or_type(it['clazz'])
        write_str_or_type(it['title'])
        w16(it['creation'])
    return bytes(out)
