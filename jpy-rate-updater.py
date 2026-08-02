#实时汇率更新工具，在汉化版游戏启动前先行启动，用于实时更新游戏内日元换算后的金额
#汇率数据来源：ExchangeRate.fun API（https://api.exchangerate.fun/）
#本工具仅提供参考汇率。

import csv
import os
import sys
import time
from pathlib import Path
import requests
from siglus_ssu import dbs
import subprocess

import tkinter as tk
from tkinter import scrolledtext
from PIL import Image, ImageTk
import threading
import io

if getattr(sys, "frozen", False):
    BASE_DIR = Path(sys.executable).parent
else:
    BASE_DIR = Path(__file__).parent

os.chdir(BASE_DIR)

API_URL = "https://open.er-api.com/v6/latest/JPY"

CSV_FILE = BASE_DIR / "1st_beat" / "dat" / "jpyrate.csv"
DBS_FILE = BASE_DIR / "1st_beat" / "dat" / "jpyrate.dbs"
SIGLUS_ENGINE = BASE_DIR / "1st_beat" / "SiglusEngine_CHS_RECOMPILE.exe"

def resource_path(relative_path):
    if hasattr(sys, "_MEIPASS"):
        return Path(sys._MEIPASS) / relative_path

    return Path(__file__).parent / relative_path

ICON_FILE = resource_path("icon.png")

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

    print("正在从ExchangeRate.fun (https://api.exchangerate.fun/)获取最新的日元汇率...")

    for attempt in range(1, MAX_RETRY + 1):
        try:
            print(f"正在获取汇率（第 {attempt} 次）...")

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

    raise RuntimeError("错误：无法获取在线汇率。请检查网络连接。")


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

    time.sleep(2)

    subprocess.Popen(
        [str(SIGLUS_ENGINE)],
        cwd=str(BASE_DIR)
    )



def update_and_launch():
    try:
        amount = get_rate()
        modify_csv(amount)
        build_dbs()

        print("\n汇率更新完成，即将启动游戏...")

    except Exception as e:
        print("\n汇率换算过程中发生错误，即将直接启动游戏：")
        print(e)

    launch_siglus()


def direct_launch():
    launch_siglus()

class RedirectOutput(io.StringIO):
    def __init__(self, textbox):
        self.textbox = textbox

    def write(self, text):
        self.textbox.after(
            0,
            self._write,
            text
        )

    def _write(self, text):
        self.textbox.insert(
            tk.END,
            text
        )
        self.textbox.see(tk.END)

    def flush(self):
        pass


def run_update():
    threading.Thread(
        target=update_and_launch,
        daemon=True
    ).start()


def run_direct():
    threading.Thread(
        target=direct_launch,
        daemon=True
    ).start()


def create_gui():

    root = tk.Tk()

    root.title("Angel Beats! -1st beat- 汉化启动器")
    root.geometry("700x450")
    root.iconbitmap(
        resource_path("jpyrate.ico")
    )

    # ===== 顶部区域 =====

    top = tk.Frame(root)
    top.pack(
        fill=tk.X,
        padx=10,
        pady=10
    )

    # 左侧图片

    if ICON_FILE.exists():

        img = Image.open(ICON_FILE)

        img.thumbnail(
            (160, 160)
        )

        icon = ImageTk.PhotoImage(img)

        img_label = tk.Label(
            top,
            image=icon
        )

        img_label.image = icon

        img_label.pack(
            side=tk.LEFT
        )


    # 右侧按钮

    btn_frame = tk.Frame(top)

    btn_frame.pack(
        side=tk.RIGHT,
        padx=10
    )


    btn1 = tk.Button(
        btn_frame,
        text="更新汇率并启动游戏",
        width=140,
        height=4,
        command=run_update
    )

    btn1.pack(
        pady=5
    )


    btn2 = tk.Button(
        btn_frame,
        text="直接启动游戏",
        width=140,
        height=4,
        command=run_direct
    )

    btn2.pack(
        pady=5
    )


    # ===== 输出窗口 =====

    output = scrolledtext.ScrolledText(
        root,
        height=18
    )

    output.pack(
        fill=tk.BOTH,
        expand=True,
        padx=10,
        pady=10
    )


    # 重定向 print

    sys.stdout = RedirectOutput(output)
    sys.stderr = RedirectOutput(output)


    root.mainloop()


if __name__ == "__main__":
    create_gui()