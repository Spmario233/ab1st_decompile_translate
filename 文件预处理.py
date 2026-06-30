#此文件用于对原始的.ss格式文件进行预处理，生成对照注释文本并给日文添加双引号，简化直接编辑源码工作流的流程。
#该处理文件不会考虑名称中包含非ASCII字符的神秘变量（如各种ruby标记），遇到此类变量请手动处理。

from pathlib import Path
import re

INPUT_DIR = Path("ss_utf8")
OUTPUT_DIR = Path("ss_new")

OUTPUT_DIR.mkdir(exist_ok=True)

def should_copy_line(line: str) -> bool:
    """
    判断是否直接复制整行
    """

    content = line.rstrip("\r\n")

    # 空行
    if content == "":
        return True

    stripped = content.lstrip(" \t")

    # 仅空格/Tab
    if stripped == "":
        return True

    first = stripped[0]

    # @ / 开头
    if first in ("@", "/", ";"):
        return True

    # ASCII半角字符且不是K
    if ord(first) < 128 and first != "K":
        return True

    return False


def split_segments(text: str):
    """
    按①~⑤规则切分
    返回 [(segment, need_quote), ...]
    """

    result = []
    i = 0
    n = len(text)

    while i < n:

        # ④ 注释 //
        if text.startswith("//", i):
            result.append((text[i:], "注释"))
            break

        # ④ 注释 ;
        if text[i] == ";":
            result.append((text[i:], "注释"))
            break

        # ① KOE(...)
        if text.startswith("KOE(", i):
            end = text.find(")", i + 4)
            if end != -1:
                result.append((text[i:end + 1], "语音标识符"))
                i = end + 1
                continue

        # ② 【...】
        if text[i] == "【":
            end = text.find("】", i + 1)
            if end != -1:
                result.append((text[i:end + 1], "说话人"))
                i = end + 1
                continue

        # ③ "..."
        if text[i] == '"':
            end = text.find('"', i + 1)
            if end != -1:
                result.append((text[i:end + 1], "字符串"))
                i = end + 1
                continue

        # ⑤ 普通字符串
        start = i
        isAscii = (ord(text[i]) < 128)


        while i < n:
            if text.startswith("//", i):
                break

            if text[i] == ";":
                break

            if text.startswith("KOE(", i):
                break

            if text[i] == "【":
                break

            if text[i] == '"':
                break

            
            if (ord(text[i]) < 128) != isAscii:
                break

            i += 1
        
        if isAscii:
            result.append((text[start:i], "其他控制符"))
        else:
            result.append((text[start:i], "普通文本"))

    return result


def process_line(line: str) -> str:
    """
    处理单行
    """

    newline = ""

    if line.endswith("\r\n"):
        newline = "\r\n"
        content = line[:-2]
    elif line.endswith("\n"):
        newline = "\n"
        content = line[:-1]
    else:
        content = line

    if should_copy_line(line):
        return line

    segments = split_segments(content)

    output_parts = []
    endings = []
    ending = False

    for seg, need_quote in segments:
        if need_quote == "普通文本":
            if ending == False:
                ending = True
                endings.append(" //")
            output_parts.append(f'"{seg}"')
        else:
            output_parts.append(seg)
        
        if ending == True and need_quote != "注释":
            endings.append(seg)

    return "".join(output_parts) + "".join(endings) + newline


def process_file(src: Path, dst: Path):
    with open(src, "r", encoding="utf-8") as f:
        lines = f.readlines()

    with open(dst, "w", encoding="utf-8", newline="") as f:
        for line in lines:
            newline = process_line(line)
            #print(newline)
            f.write(newline)


def main():
    for file in INPUT_DIR.iterdir():
        if not file.is_file():
            continue

        if file.name.startswith("_"):
            continue

        if file.suffix.lower() != ".ss":
            continue

        dst = OUTPUT_DIR / file.name

        print(f"Processing: {file.name}")
        process_file(file, dst)

    print("Done.")


if __name__ == "__main__":
    main()