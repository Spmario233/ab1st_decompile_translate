#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""检查 ss_utf8 目录下的 *.ss 文件。

规则：
- 如果某一行包含“@创建注释”，且下一行既不包含“@创建注释”也不包含“@清除注释”，
  则在终端输出警告，包含文件名、行号和行内容。
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
SS_DIR = BASE_DIR / "ss_utf8"
CREATE_MARK = "@创建注释"
CLEAR_MARK = "@清除注释"


def main() -> int:
    if not SS_DIR.is_dir():
        print(f"错误：找不到目录 {SS_DIR}", file=sys.stderr)
        return 1

    files = sorted(SS_DIR.glob("*.ss"))
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
            if CREATE_MARK not in line:
                continue

            line_no = i + 1
            content = line.rstrip("\r\n")

            if i + 1 < len(lines):
                next_line = lines[i + 1]
                if CREATE_MARK in next_line or CLEAR_MARK in next_line:
                    continue
                warnings.append((file_path.name, line_no, content))
            else:
                # 如果“@创建注释”出现在文件最后一行，同样视为缺少下一行清理标记
                warnings.append((file_path.name, line_no, f"{content}（文件末尾，无下一行）"))

    if warnings:
        for file_name, line_no, content in warnings:
            print(f"警告：{file_name} 第 {line_no} 行：{content}")
        print(f"\n检查完成，共发现 {len(warnings)} 处问题。")
        return 1

    print("检查完成，未发现问题。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
