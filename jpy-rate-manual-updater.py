#手动汇率更新工具，在汉化版游戏启动前先行启动，用于手动更新游戏内日元换算后的金额

import csv
import os
import sys
import time
from pathlib import Path
from siglus_ssu import dbs
import subprocess

if getattr(sys, "frozen", False):
    BASE_DIR = Path(sys.executable).parent
else:
    BASE_DIR = Path(__file__).parent

os.chdir(BASE_DIR)


CSV_FILE = BASE_DIR / "dat" / "jpyrate.csv"
DBS_FILE = BASE_DIR / "dat" / "jpyrate.dbs"
SIGLUS_ENGINE = BASE_DIR / "SiglusEngine_CHS_RECOMPILE.exe"

MAX_RETRY = 3
RETRY_INTERVAL = 2  # 秒

def compile_dbs(csv_file, dbs_file,
                m_type=1,
                shuffle_seed=1):

    dbs.reset_msvcrt_rand(shuffle_seed)

    dbs.create_one_dbs_from_csv(
        str(csv_file),
        str(dbs_file),
        m_type=m_type,
    )



def modify_csv(value):
    print("正在将汇率写入本地csv文件...")
    """修改第五行第三列"""

    if not CSV_FILE.exists():
        raise FileNotFoundError(f"找不到 {CSV_FILE}")

    with CSV_FILE.open("r", encoding="utf-8-sig", newline="") as f:
        rows = list(csv.reader(f))

    if len(rows) < 5:
        raise RuntimeError("CSV不足5行。")

    if len(rows[4]) < 3:
        raise RuntimeError("CSV第五行不足3列。")

    old = rows[4][2]
    rows[4][2] = str(value)

    with CSV_FILE.open("w", encoding="utf-8-sig", newline="") as f:
        csv.writer(f).writerows(rows)

    print(f"CSV已更新：{old} -> {value}")


def build_dbs():
    print("正在调用siglus-ssu生成dbs文件...")
    compile_dbs(CSV_FILE, DBS_FILE)
    print("DBS已生成。")

def launch_siglus():
    """启动 SiglusEngine.exe 后立即返回"""
    print("正在启动游戏...")
    
    if not SIGLUS_ENGINE.exists():
        print(f"启动游戏时错误：未找到 {SIGLUS_ENGINE}")
        error_handle()

    time.sleep(2)

    subprocess.Popen(
        [str(SIGLUS_ENGINE)],
        cwd=str(BASE_DIR)
    )

def error_handle():
    print("按任意键继续...")
    input()

def input_amount():
    amount = input("请输入想要设置的汇率（10000日元可兑换的人民币金额，仅保留整数）:")
    return int(amount)

def main():
    try:
        amount = input_amount()
        modify_csv(amount)
        build_dbs()
        print("\n汇率更新完成，即将启动游戏...")

    except Exception as e:
        print("\n汇率设置过程中发生错误，即将直接启动游戏：")
        print(e)
        error_handle()

    launch_siglus()
    sys.exit(0)


if __name__ == "__main__":
    main()