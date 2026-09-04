# -*- coding: utf-8 -*-
"""简单的音乐播放器模块：读取“注释歌曲”目录下的 MP3 文件并播放。"""

import io
import os
import random
import time
from pathlib import Path

# 隐藏 pygame 启动时在控制台输出的版本提示
os.environ.setdefault("PYGAME_HIDE_SUPPORT_PROMPT", "1")

import tkinter as tk
from tkinter import ttk
from tkinter import font as tkfont
from PIL import Image, ImageTk

try:
    import pygame
    from mutagen.mp3 import MP3
    AUDIO_DEPS_READY = True
except Exception:
    pygame = None
    MP3 = None
    AUDIO_DEPS_READY = False

MUSIC_FOLDER_NAME = "注释歌曲"
ORDER_SEQUENTIAL = "顺序播放"
ORDER_LIST_LOOP = "列表循环"
ORDER_RANDOM = "随机播放"
ORDER_MODES = (ORDER_SEQUENTIAL, ORDER_LIST_LOOP, ORDER_RANDOM)


def _format_time(ms):
    """把毫秒格式化为 m:ss 或 h:mm:ss。"""
    try:
        ms = int(ms)
    except (TypeError, ValueError):
        ms = 0
    if ms < 0:
        ms = 0

    total_seconds = ms // 1000
    seconds = total_seconds % 60
    minutes = (total_seconds // 60) % 60
    hours = total_seconds // 3600
    if hours:
        return f"{hours}:{minutes:02d}:{seconds:02d}"
    return f"{minutes}:{seconds:02d}"


def load_music_playlist(base_dir):
    """返回当前目录下“注释歌曲”文件夹中的所有 mp3 文件。"""
    music_dir = Path(base_dir) / MUSIC_FOLDER_NAME
    if not music_dir.is_dir():
        return []

    files = []
    for pattern in ("*.mp3", "*.MP3"):
        files.extend(music_dir.glob(pattern))
    # 去重后按文件名排序
    unique = {}
    for path in files:
        if path.is_file():
            unique[str(path)] = path
    return [unique[k] for k in sorted(unique, key=lambda x: Path(x).name.lower())]


def _read_mp3_info(path):
    """读取 MP3 时长和第一张内嵌封面。返回 (时长秒, 封面数据 bytes 或 None)。"""
    if MP3 is None:
        return 0.0, None

    try:
        audio = MP3(path)
        length = float(getattr(audio.info, "length", 0.0))
        cover = None
        if audio.tags is not None:
            for tag in audio.tags.getall("APIC"):
                if getattr(tag, "data", None):
                    cover = bytes(tag.data)
                    break
        return length, cover
    except Exception:
        return 0.0, None


class MusicPlayer:
    """音乐播放选项卡的界面和播放控制。"""

    def __init__(self, parent, root, scale, base_dir):
        self.root = root
        self.scale = scale
        self.base_dir = Path(base_dir)

        self.playlist = load_music_playlist(self.base_dir)
        self.current_index = -1
        self.playing = False
        self.paused = False
        self.order = ORDER_LIST_LOOP

        # 以下三个变量用于在 pygame 上维护一个较准确的播放进度。
        self._length_ms = 0
        self._base_pos_ms = 0
        self._play_start_time = time.monotonic()
        self._paused_pos_ms = 0

        self.cover_photo = None
        self.audio_ready = False

        self._build_ui(parent)

        if AUDIO_DEPS_READY:
            try:
                # 增大音频缓冲，减少播放时出现断断续续的情况。
                pygame.mixer.pre_init(44100, -16, 2, 4096)
                pygame.mixer.init()
                self.audio_ready = True
                self.status_label.config(text=f"已加载 {len(self.playlist)} 首歌曲")
            except Exception:
                try:
                    pygame.mixer.init()
                    self.audio_ready = True
                    self.status_label.config(text=f"已加载 {len(self.playlist)} 首歌曲")
                except Exception as e:
                    self.audio_ready = False
                    self.status_label.config(text=f"音频设备初始化失败：{e}")
        else:
            self.status_label.config(text="缺少 pygame 或 mutagen，无法播放音频")

        self.root.after(500, self._poll)

    def _build_ui(self, parent):
        margin = round(10 * self.scale)
        cover_size = round(200 * self.scale)

        parent_bg = parent.winfo_toplevel().cget("bg")
        outer = tk.Frame(parent, bg=parent_bg)
        outer.pack(fill=tk.BOTH, expand=True, padx=margin, pady=margin)

        # 上方区域：左侧封面 + 右侧控制区。
        top = tk.Frame(outer, bg=outer.cget("bg"))
        top.pack(fill=tk.X)

        # 左侧：复制“启动游戏”页左上角图片的位置和大小。
        left = tk.Frame(top, bg=top.cget("bg"))
        left.pack(side=tk.LEFT, fill=tk.Y)

        self.cover_frame = tk.Frame(
            left,
            width=cover_size,
            height=cover_size,
            bg=top.cget("bg"),
            highlightthickness=1,
            highlightbackground="#c0c0c0",
        )
        self.cover_frame.pack_propagate(False)
        self.cover_frame.pack(anchor="n")

        self.cover_label = tk.Label(
            self.cover_frame,
            text="无封面",
            bg=top.cget("bg"),
            fg="#808080",
        )
        self.cover_label.pack(expand=True)

        # 下方：与“启动游戏”选项卡等宽的歌曲选择框。
        self.list_frame = tk.Frame(outer, bg=outer.cget("bg"))
        self.list_frame.pack(fill=tk.BOTH, expand=True, pady=(2 * margin, 0))

        self.listbox = tk.Listbox(
            self.list_frame,
            selectmode=tk.SINGLE,
            exportselection=False,
            activestyle="none",
        )
        scrollbar = tk.Scrollbar(
            self.list_frame,
            orient=tk.VERTICAL,
            command=self.listbox.yview,
        )
        self.listbox.config(yscrollcommand=scrollbar.set)
        self.listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        for path in self.playlist:
            self.listbox.insert(tk.END, path.stem)

        self.listbox.bind("<Double-Button-1>", self._on_list_double_click)
        self.listbox.bind("<Return>", self._on_list_double_click)

        # 右上方：播放控制区域。
        right = tk.Frame(top, bg=top.cget("bg"))
        right.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(margin, 0))

        self.title_label = tk.Label(
            right,
            text="未播放",
            font=(tkfont.nametofont("TkDefaultFont").actual("family"), 12),
            bg=right.cget("bg"),
            anchor="center",
        )
        self.title_label.pack(fill=tk.X, pady=(0, margin))

        controls = tk.Frame(right, bg=right.cget("bg"))
        controls.pack(anchor=tk.CENTER)

        self.prev_btn = tk.Button(
            controls,
            text="上一首",
            width=10,
            command=self.previous,
        )
        self.prev_btn.pack(side=tk.LEFT, padx=2)

        self.play_btn = tk.Button(
            controls,
            text="播放",
            width=10,
            command=self.play_pause,
        )
        self.play_btn.pack(side=tk.LEFT, padx=2)

        self.next_btn = tk.Button(
            controls,
            text="下一首",
            width=10,
            command=self.next,
        )
        self.next_btn.pack(side=tk.LEFT, padx=2)

        self.stop_btn = tk.Button(
            controls,
            text="停止",
            width=10,
            command=self.stop,
        )
        self.stop_btn.pack(side=tk.LEFT, padx=2)

        # 进度条区域。
        progress_frame = tk.Frame(right, bg=right.cget("bg"))
        progress_frame.pack(fill=tk.X, pady=(margin, 0))

        self.cur_time_label = tk.Label(
            progress_frame,
            text="0:00",
            width=6,
            bg=progress_frame.cget("bg"),
        )
        self.cur_time_label.pack(side=tk.LEFT)

        self.progress_var = tk.DoubleVar(value=0)
        self.progress_scale = tk.Scale(
            progress_frame,
            from_=0,
            to=100,
            orient=tk.HORIZONTAL,
            showvalue=0,
            variable=self.progress_var,
            command=self._on_seek,
            bg=progress_frame.cget("bg"),
            highlightthickness=0,
            bd=1,
        )
        self.progress_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=4)

        self.total_time_label = tk.Label(
            progress_frame,
            text="0:00",
            width=6,
            bg=progress_frame.cget("bg"),
        )
        self.total_time_label.pack(side=tk.LEFT)

        # 播放顺序选择。
        order_frame = tk.Frame(right, bg=right.cget("bg"))
        order_frame.pack(fill=tk.X, pady=(margin, 0))

        tk.Label(
            order_frame,
            text="播放顺序：",
            bg=order_frame.cget("bg"),
        ).pack(side=tk.LEFT)

        self.order_var = tk.StringVar(value=self.order)
        self.order_combo = ttk.Combobox(
            order_frame,
            textvariable=self.order_var,
            values=ORDER_MODES,
            state="readonly",
            width=10,
        )
        self.order_combo.pack(side=tk.LEFT, padx=4)
        self.order_combo.bind("<<ComboboxSelected>>", self._on_order_change)

        self.status_label = tk.Label(
            right,
            text="",
            bg=right.cget("bg"),
            anchor="w",
            wraplength=round(360 * self.scale),
        )
        self.status_label.pack(fill=tk.X, pady=(margin, 0))

    def _on_list_double_click(self, event=None):
        selection = self.listbox.curselection()
        if selection:
            self.play_index(selection[0])

    def _on_order_change(self, event=None):
        self.order = self.order_var.get()
        #self.status_label.config(text=f"播放顺序：{self.order}")

    def _current_track_name(self):
        if self.current_index < 0 or self.current_index >= len(self.playlist):
            return ""
        return self.playlist[self.current_index].stem

    def _load_cover(self):
        if self.current_index < 0:
            if self.cover_photo is not None:
                self.cover_photo = None
                self.cover_label.config(image="", text="无封面")
            return

        if not AUDIO_DEPS_READY or MP3 is None:
            self.cover_label.config(image="", text="无封面")
            return

        _, cover_bytes = _read_mp3_info(self.playlist[self.current_index])
        if not cover_bytes:
            self.cover_photo = None
            self.cover_label.config(image="", text="无封面")
            return

        try:
            image = Image.open(io.BytesIO(cover_bytes))
            image.thumbnail((round(200 * self.scale), round(200 * self.scale)))
            self.cover_photo = ImageTk.PhotoImage(image)
            self.cover_label.config(image=self.cover_photo, text="")
        except Exception:
            self.cover_photo = None
            self.cover_label.config(image="", text="无封面")

    def _load_track(self, index, autoplay=True):
        if not self.playlist:
            return
        if index < 0 or index >= len(self.playlist):
            return

        if not self.audio_ready:
            self.status_label.config(text="音频组件不可用，无法播放")
            return

        path = self.playlist[index]
        try:
            pygame.mixer.music.stop()
            pygame.mixer.music.load(str(path))
            length, _ = _read_mp3_info(path)
            self._length_ms = round(length * 1000)
        except Exception as e:
            self.status_label.config(text=f"加载失败：{e}")
            return

        self.current_index = index
        self.playing = False
        self.paused = False
        self._base_pos_ms = 0
        self._paused_pos_ms = 0

        self.listbox.selection_clear(0, tk.END)
        self.listbox.selection_set(index)
        self.listbox.see(index)

        self._load_cover()
        self.title_label.config(text=path.stem)
        self.total_time_label.config(text=_format_time(self._length_ms))
        self._update_progress_view(0)

        if autoplay:
            self._start_playback(0)
        else:
            self.play_btn.config(text="播放")
            self.status_label.config(text=f"已选择：{path.stem}")

    def _start_playback(self, from_ms):
        self._base_pos_ms = int(from_ms)
        self._play_start_time = time.monotonic()
        self.playing = True
        self.paused = False
        try:
            if self._base_pos_ms <= 0:
                pygame.mixer.music.play()
            else:
                pygame.mixer.music.play(start=self._base_pos_ms / 1000.0)
        except Exception as e:
            self.playing = False
            self.status_label.config(text=f"播放失败：{e}")
            return
        self.play_btn.config(text="暂停")
        self.status_label.config(text=f"正在播放：{self._current_track_name()}")

    def play_index(self, index):
        self._load_track(index, autoplay=True)

    def play_pause(self):
        if not self.playlist:
            return
        if not self.audio_ready:
            return

        if self.current_index < 0:
            self.play_index(0)
            return

        if self.playing and not self.paused:
            # 正在播放 -> 暂停
            self._paused_pos_ms = self.get_position_ms()
            try:
                pygame.mixer.music.pause()
            except Exception:
                pass
            self.paused = True
            self.play_btn.config(text="播放")
            self.status_label.config(text=f"已暂停：{self._current_track_name()}")
        elif self.playing and self.paused:
            # 暂停 -> 继续
            try:
                pygame.mixer.music.unpause()
            except Exception:
                pass
            self._base_pos_ms = self._paused_pos_ms
            self._play_start_time = time.monotonic()
            self.playing = True
            self.paused = False
            self.play_btn.config(text="暂停")
            self.status_label.config(text=f"正在播放：{self._current_track_name()}")
        else:
            # 未播放/已停止 -> 从头或当前位置开始
            self._start_playback(self._paused_pos_ms if self._paused_pos_ms else 0)

    def stop(self):
        if not self.audio_ready:
            return
        try:
            pygame.mixer.music.stop()
        except Exception:
            pass
        self.playing = False
        self.paused = False
        self._base_pos_ms = 0
        self._paused_pos_ms = 0
        self.play_btn.config(text="播放")
        if self.current_index >= 0:
            self._update_progress_view(0)

    def next(self):
        if self.playlist:
            self.play_index((self.current_index + 1) % len(self.playlist))

    def previous(self):
        if self.playlist:
            # 播放超过 3 秒时，切上一首先回到本曲开头。
            if self.current_index >= 0 and self.get_position_ms() > 3000:
                self._start_playback(0)
            else:
                self.play_index((self.current_index - 1) % len(self.playlist))

    def get_position_ms(self):
        if not self.playing:
            return self._paused_pos_ms if self.paused else 0
        if self.paused:
            return self._paused_pos_ms
        elapsed = (time.monotonic() - self._play_start_time) * 1000
        return min(self._base_pos_ms + elapsed, self._length_ms)

    def _update_progress_view(self, pos_ms):
        self.cur_time_label.config(text=_format_time(pos_ms))
        self.total_time_label.config(text=_format_time(self._length_ms))
        if self._length_ms > 0:
            percent = min(100.0, max(0.0, pos_ms / self._length_ms * 100.0))
        else:
            percent = 0
        # 使用变量更新进度条：程序自动更新不会触发 command，避免误判为用户拖动进度条。
        self.progress_var.set(percent)

    def _on_seek(self, value):
        if not self.audio_ready or self.current_index < 0:
            return
        if self._length_ms <= 0:
            return

        try:
            percent = float(value)
        except (TypeError, ValueError):
            return

        target_ms = int(self._length_ms * percent / 100.0)
        if self.playing and self.paused:
            # 暂停状态下拖动进度条：更新位置，下次继续从该处播放。
            self._paused_pos_ms = target_ms
            try:
                if target_ms <= 0:
                    pygame.mixer.music.play()
                else:
                    pygame.mixer.music.play(start=target_ms / 1000.0)
                pygame.mixer.music.pause()
            except Exception:
                pass
        elif self.playing:
            self._base_pos_ms = target_ms
            self._play_start_time = time.monotonic()
            try:
                if target_ms <= 0:
                    pygame.mixer.music.play()
                else:
                    pygame.mixer.music.play(start=target_ms / 1000.0)
            except Exception:
                pass
        else:
            # 未播放时拖动进度条：仅记录位置。
            self._paused_pos_ms = target_ms
        self._update_progress_view(target_ms)

    def _on_track_end(self):
        if not self.playlist:
            return

        current = self.current_index
        if self.order == ORDER_SEQUENTIAL:
            if current < len(self.playlist) - 1:
                self.play_index(current + 1)
            else:
                self.stop()
        elif self.order == ORDER_LIST_LOOP:
            self.play_index((current + 1) % len(self.playlist))
        else:  # 随机播放
            if len(self.playlist) <= 1:
                self.play_index(0)
            else:
                candidates = [i for i in range(len(self.playlist)) if i != current]
                self.play_index(random.choice(candidates))

    def _poll(self):
        if self.current_index >= 0 and self.audio_ready:
            # 暂停时 get_busy() 也可能为 False，因此只在“正在播放且未暂停”时判断是否播完。
            if self.playing and not self.paused and not pygame.mixer.music.get_busy():
                self._on_track_end()
            elif self.playing or self.paused:
                self._update_progress_view(self.get_position_ms())

        self.root.after(500, self._poll)

    def destroy(self):
        if self.audio_ready:
            try:
                pygame.mixer.music.stop()
                pygame.mixer.quit()
            except Exception:
                pass
