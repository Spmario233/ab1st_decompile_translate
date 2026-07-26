#实时汇率更新工具，在汉化版游戏启动前先行启动，用于实时更新游戏内日元换算后的金额
#汇率数据来源：ExchangeRate.fun API（https://api.exchangerate.fun/）
#本工具仅提供参考汇率。
#编译该python文件为exe文件时，请手动将const.py导入到siglus-ssu的库目录内

import csv
import os
import sys
import time
from pathlib import Path
import requests
from siglus_ssu import dbs

if getattr(sys, "frozen", False):
    BASE_DIR = Path(sys.executable).parent
else:
    BASE_DIR = Path(__file__).parent

os.chdir(BASE_DIR)

API_URL = "https://open.er-api.com/v6/latest/JPY"

CSV_FILE = BASE_DIR / "dbs" / "jpyrate.csv"
DBS_FILE = BASE_DIR / "dbs" / "jpyrate.dbs"

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

def get_rate():
    """获取10000日元对应人民币（四舍五入）"""

    print("正在从ExchangeRate.fun (https://api.exchangerate.fun/)获取最新的日元汇率……")

    for attempt in range(1, MAX_RETRY + 1):
        try:
            print(f"正在获取汇率（第 {attempt}/{MAX_RETRY} 次）...")

            response = requests.get(API_URL, timeout=1000)
            response.raise_for_status()

            data = response.json()

            rate = data["rates"]["CNY"]

            amount = round(10000 * rate)

            print(f"当前汇率：1 JPY = {rate:.8f} CNY")
            print(f"10000 JPY = {amount} CNY")

            return amount

        except Exception as e:
            print(f"获取失败：{e}")

            if attempt < MAX_RETRY:
                print(f"{RETRY_INTERVAL} 秒后重试...\n")
                time.sleep(RETRY_INTERVAL)

    raise RuntimeError("连续多次获取汇率失败。")


def modify_csv(value):
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
    compile_dbs(CSV_FILE, DBS_FILE)
    print("DBS已生成。")


def main():
    try:
        amount = get_rate()
        modify_csv(amount)
        build_dbs()
        print("\n全部完成。")

    except Exception as e:
        print("\n发生错误：")
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    main()