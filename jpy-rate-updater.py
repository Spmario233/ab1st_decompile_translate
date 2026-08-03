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
from datetime import datetime

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

custom_rate_var = None
custom_rate_entry = None

program_running = False

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
    """获取10000日元对应的人民币价值（四舍五入）"""

    print("正在联网获取当日最新日元汇率... 数据来源：ExchangeRate.fun (https://api.exchangerate.fun/)")

    for attempt in range(1, MAX_RETRY + 1):
        try:
            print(f"正在连接API获取数据（第 {attempt} 次尝试获取）...")

            response = requests.get(API_URL, timeout=1000)
            response.raise_for_status()

            data = response.json()

            rate = data["rates"]["CNY"]

            amount = round(10000 * rate)

            print(f"当前汇率：1 日元 = {rate:.8f} 人民币")
            #print(f"10000 JPY = {amount} CNY")

            return amount

        except Exception as e:
            print(f"获取失败：{e}")

            if attempt < MAX_RETRY:
                print(f"{RETRY_INTERVAL} 秒后重试...\n")
                time.sleep(RETRY_INTERVAL)

    raise RuntimeError("错误：无法获取在线汇率。请检查网络连接。")

def boot_loading_csv():
    if not CSV_FILE.exists():
        raise FileNotFoundError(f"错误：找不到 {CSV_FILE}")
    
    with CSV_FILE.open("r", encoding="utf-8-sig", newline="") as f:
        rows = list(csv.reader(f))

    if len(rows) < 5:
        raise RuntimeError("错误：CSV文件不足5行。")

    if len(rows[4]) < 3:
        raise RuntimeError("错误：CSV文件列数不足3列。")

    old_date = rows[4][1]
    old = rows[4][2]

    print(f"本地当前保存的汇率为：10000 日元 = { old } 人民币, 更新时间: { old_date }")

def modify_csv(value):
    print("汇率已经获取成功。正在将汇率写入本地csv文件...")
    """修改第五行第三列"""

    if not CSV_FILE.exists():
        raise FileNotFoundError(f"错误：找不到 {CSV_FILE}")

    with CSV_FILE.open("r", encoding="utf-8-sig", newline="") as f:
        rows = list(csv.reader(f))

    if len(rows) < 5:
        raise RuntimeError("错误：CSV文件不足5行。")
    
    if len(rows[4]) < 3:
        raise RuntimeError("错误：CSV文件列数不足3列。")

    old = rows[4][2]
    rows[4][2] = str(value)

    today_str = datetime.now().strftime('%Y-%m-%d')
    rows[4][1] = today_str

    with CSV_FILE.open("w", encoding="utf-8-sig", newline="") as f:
        csv.writer(f).writerows(rows)

    print(f"CSV已更新: {old} -> {value}, 更新时间: {today_str}")


def build_dbs():
    print("正在调用siglus-ssu, 生成游戏内dbs数据库...")
    compile_dbs(CSV_FILE, DBS_FILE)
    print("游戏内dbs数据已生成。")

def launch_siglus():
    """启动 SiglusEngine.exe 后立即返回"""
    print("正在启动游戏...")
    
    if not SIGLUS_ENGINE.exists():
        print(f"启动游戏时错误：未找到 {SIGLUS_ENGINE}")
        return

    subprocess.Popen(
        [str(SIGLUS_ENGINE)],
        cwd=str(BASE_DIR)
    )



def update_and_launch(use_custom, custom_value):
    global program_running
    if program_running:
        return
    program_running = True
    print("开始获取最新汇率，并写入到游戏内...")
    try:
        if use_custom:
            value = custom_value.strip()
            try:
                amount = int(value)
                print(f"使用自定义汇率：10000 日元 = {amount} 人民币")
            except ValueError:
                print("自定义汇率输入无效，将使用在线汇率")
                amount = get_rate()
        else:
            amount = get_rate()

        modify_csv(amount)
        build_dbs()


    except Exception as e:
        print("\n更新汇率时发生错误:")
        print(e)

    launch_siglus()
    program_running = False


def direct_launch():
    global program_running
    if program_running:
        return
    program_running = True
    launch_siglus()
    program_running = False

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
    use_custom = custom_rate_var.get()
    value = custom_rate_entry.get()
    threading.Thread(
        target=update_and_launch,
        args=(use_custom,value),
        daemon=True
    ).start()


def run_direct():
    threading.Thread(
        target=direct_launch,
        daemon=True
    ).start()


def create_gui():

    global custom_rate_var
    global custom_rate_entry

    root = tk.Tk()
    root.title("Angel Beats! -1st beat- 简体中文重编译汉化版启动器")
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
        img.thumbnail((240, 240))
        icon = ImageTk.PhotoImage(img)
        img_label = tk.Label(top,image=icon)
        img_label.image = icon
        img_label.pack(side=tk.LEFT)
    # 右侧按钮
    btn_frame = tk.Frame(top)
    btn_frame.pack(
        side=tk.RIGHT,
        padx=10
    )

    btn1 = tk.Button(
        btn_frame,
        text="更新汇率并启动游戏",
        width=100,
        height=2,
        command=run_update
    )
    btn1.pack(
        pady=10
    )

    btn2 = tk.Button(
        btn_frame,
        text="直接启动游戏",
        width=100,
        height=2,
        command=run_direct
    )
    btn2.pack(
        pady=10
    )

    # 自定义汇率区域

    custom_frame = tk.Frame(btn_frame)

    custom_frame.pack(
        pady=20
    )

    custom_rate_var = tk.BooleanVar()


    custom_check = tk.Checkbutton(
        custom_frame,
        text="使用自定义汇率（输入10000日元的兑换金额）",
        variable=custom_rate_var
    )

    custom_check.pack(
        side=tk.LEFT
    )



    custom_rate_entry = tk.Entry(
        custom_frame,
        width=76
    )

    custom_rate_entry.pack(
        side=tk.LEFT
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

    boot()

    root.mainloop()

def boot():
    print("Angel Beats! -1st -beat- 简体中文重编译汉化版")
    print("Originally translated by 死了没法儿忍汉化组, 2020-2021")
    print("==========================================================")
    try:
        boot_loading_csv()
    except Exception as e:
        print("本地文件丢失！请检查 1st_beat\\dat\\jpyrate.csv 是否存在！")
        print(e)

if __name__ == "__main__":
    create_gui()