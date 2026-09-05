#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""检查 ss_utf8 目录下指定范围内的 *.ss 剧情文本。

范围：
- 只处理从 00_AB01a_day00.ss 到 44_バッドエンド.ss（含首尾）的文件。

规则：
1. 如果某一行包含“@创建注释”，且下一行既不包含“@创建注释”也不包含“@清除注释”，
   则在终端输出警告，包含文件名、行号和行内容。
2. 检查所有被英文双引号包裹的字符串。若其中出现 CODES_NEED_TO_CHECK 中的字符，
   并且该字符后面没有紧接半角空格，则输出同样格式的警告。
"""

import re
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
SS_DIR = BASE_DIR / "ss_utf8"
CREATE_MARK = "@创建注释"
CLEAR_MARK = "@清除注释"
CODES_NEED_TO_CHECK = "・♪"
HALF_WIDTH_SPACE = " "

# 只检测这个文件名范围内的剧情文本
START_FILE = "00_AB01a_day00.ss"
END_FILE = "44_バッドエンド.ss"


def has_code_without_following_space(line: str) -> bool:
    """检查一行中是否有双引号字符串里的待检字符后缺少半角空格。"""
    # 查找所有由英文双引号包裹的字符串；此处按简单的 "([^"]*)" 规则匹配
    for match in re.finditer(r'"([^"]*)"', line):
        text = match.group(1)
        for i, ch in enumerate(text):
            if ch not in CODES_NEED_TO_CHECK:
                continue
            # 若该字符是字符串最后一个字符，也算作后面没有半角空格
            if i + 1 >= len(text) or text[i + 1] != HALF_WIDTH_SPACE:
                return True
    return False


def main() -> int:
    if not SS_DIR.is_dir():
        print(f"错误：找不到目录 {SS_DIR}", file=sys.stderr)
        return 1

    # 只选取指定范围内的剧情文本文件
    print("开始进行文本文件自检...")
    files = sorted(
        file_path
        for file_path in SS_DIR.glob("*.ss")
        if START_FILE <= file_path.name <= END_FILE
    )
    warnings = []

    for file_path in files:
        try:
            # 以文本方式读取，使用 utf-8-sig 可兼容带 BOM 的 UTF-8 文件
            with open(file_path, "r", encoding="utf-8-sig") as f:
                lines = f.readlines()
        except UnicodeDecodeError as exc:
            print(f"警告：无法以 UTF-8 读取 {file_path.name}：{exc}", file=sys.stderr)
            continue

        for i, line in enumerate(lines):
            line_no = i + 1
            content = line.rstrip("\r\n")

            # 原有检查：@创建注释 后必须紧跟 @创建注释 或 @清除注释
            if CREATE_MARK in line:
                if i + 1 < len(lines):
                    next_line = lines[i + 1]
                    if CREATE_MARK not in next_line and CLEAR_MARK not in next_line:
                        warnings.append((file_path.name, line_no, content))
                else:
                    # 如果“@创建注释”出现在文件最后一行，同样视为缺少下一行清理标记
                    warnings.append((file_path.name, line_no, f"{content}（文件末尾，无下一行）"))

            # 新增检查：双引号字符串中的待检字符后必须紧跟半角空格
            if has_code_without_following_space(line):
                warnings.append((file_path.name, line_no, content))

    if warnings:
        for file_name, line_no, content in warnings:
            print(f"警告：{file_name} 第 {line_no} 行：{content}")
        print(f"\n检查完成，共发现 {len(warnings)} 处问题。")
        return 1

    print("检查完成，未发现问题。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
