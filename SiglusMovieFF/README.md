# SiglusMovieFF — 把 Siglus 引擎的视频播放换成 FFmpeg

用 FFmpeg + Direct3D9 + DirectSound 替换 SiglusEngine 原有的 **MCI** 与 **Windows Media Player(ActiveX)**
两条视频播放路径。不需要注入器：**游戏主程序启动时自己从游戏目录加载本 DLL**。

---

## 1. 为什么用「劫持 MCI」这个切入点

静态分析 `SiglusEngine_CHS_RECOMPILE.exe` 得到的事实（详见
`../SiglusEngine_movie_analysis.md`）：

* 引擎的全部视频播放最终都走 `WINMM!mciSendStringW`，命令字符串是明文可读的：
  `open "%s" type %s alias SiglusMCIMovie wait` / `window ... handle <hwnd>` /
  `put ... destination at ...` / `play ...` / `status ... mode wait` / `close ...`。
* 是否走 MCI 由 `C_mov` 的一个状态位决定；另一条路是 `AtlAxWinLic140` 宿主 +
  `{6BF52A52-394A-11d3-B153-00C04F79FAA6}`(Windows Media Player) 的 `IDispatch` 调用。
* 播放窗口、尺寸、音量、启停时序全部由引擎负责，并通过上述命令交给播放器。

因此只要**完整实现这一小套 MCI 命令语义**，引擎的其余逻辑（脚本命令 `mov.play_wait`、
窗口管理、音量、`C_mov` 状态机）一行都不用改。

## 2. 安装：让主程序自动加载 DLL

```bat
patch_game.bat <游戏目录>\SiglusEngine.exe
```

它只做一件事：给 EXE 的导入表**加一条指向 `SiglusMovieFF.dll` 的导入**。之后 Windows
加载器在启动时就会从游戏目录加载我们的 DLL —— 不需要启动器、不需要注入、不改其他文件。
首次运行会在旁边留 `<exe>.preimport` 备份；`patch_game.bat <exe> --revert` 可还原。

需要和 EXE 同级放置：

```
SiglusEngine.exe          <- 运行 patch_game.bat 打上导入
SiglusMovieFF.dll         <- 本模块
avcodec-61.dll  avformat-61.dll  avutil-59.dll
swscale-8.dll   swresample-5.dll
```

### 备选：完全不动 EXE

`DllInjector.exe <DLL> <EXE>` 把 DLL 注入目标进程，行为等价，适合不想改 EXE 的场合。

### 不启动游戏的自测

```bat
FakeMovieHost.exe "<游戏>\mov\OP00.wmv" 20
```

会自动建窗口、按引擎完全相同的命令序列播放 20 秒，并打印 mode/position/length。

## 3. 组成

| 文件 | 说明 |
|---|---|
| `SiglusMovieFF.dll` | 代理 DLL。导出 `Smf_mciSendStringW` / `Smf_mciGetErrorStringW` / `SmfInjectionHook` / `SmfImportAnchor`，加载后在后台线程改写宿主 IAT + winmm 导出 |
| FFmpeg DLL ×5 | **win32 LGPL 共享版**（无第三方依赖，可随包分发） |
| `DllInjector.exe` | 备选注入器 |
| `FakeMovieHost.exe` | 独立测试宿主 |
| `patch_game.bat` + `tools\patch_add_import.py` | 给 EXE 加导入（脚本内有详细注释说明 PE 层面的三个坑） |

运行时在 DLL 所在目录生成 `SiglusMovieFF.log`（共享读，游戏运行中也能看）。
放一个空文件 `SiglusMovieFF.debug` 可打开 debug 级日志。

## 4. 功能与语义对照

| MCI 命令 | 实现 |
|---|---|
| `open "<path>" type <dev> alias <A>` | `avformat_open_input` + 建解码器；`type` 记录为设备号(avivideo=1, mpegvideo=2, …)，与原引擎的 switch 对应 |
| `window <A> handle <hwnd>` | 在该 HWND 上建 D3D9 呈现链（失败则退回 GDI `StretchDIBits`），并子类化窗口过程 |
| `put <A> destination at x y w h` | 记录目标矩形，按原始宽高比信箱式居中缩放 |
| `play <A>` | 启动解码/呈现/音频三个线程 |
| `setaudio <A> left/right volume to n` | 0–1000 映射为 0–1 增益 |
| `status <A> mode` | 返回 `playing` / `paused` / `stopped` / `not ready`，与原引擎字符串表逐字一致 |
| `status <A> position` / `length` / `window` / `ready`、`info width/height/filename` | 均实现 |
| `seek <A> to N` | `avformat_seek_file` + 刷新解码器与队列（串行号使旧帧失效） |
| `pause` / `resume` / `stop` / `close` | 实现；`stop`/`close` 会 join 线程并释放 |

* 解码：`avcodec`，`thread_count=0` 让 FFmpeg 自行协商（**不能**对 wmv3 强制 `FF_THREAD_FRAME`）。
* 音视频同步：以 DirectSound 播放游标为主时钟；无音轨时用 QPC 墙钟（暂停/续播会重基准）。
* 音频：48 kHz 立体声 PCM16，0.5 s 环形次级缓冲，`swresample` 重采样；
  **所有 DirectSound 调用只发生在 feeder 线程**。
* 视频：1280×720 的 BGRA 纹理 + 一个 triangle strip，`PRESENT_INTERVAL_IMMEDIATE`。

## 5. 自测结果

* `FakeMovieHost.exe` + `mov\OP00.wmv`（WMV3 1280×720 29.97fps + WMA v2，178.5 s）：
  **连续 8–10 次运行 0 崩溃**，完整片长 185.4 s 正常播完并干净退出。
* **主程序自动加载**（导入表方式，无注入器）：`SiglusEngine.exe` 正常进入标题菜单，
  `DllMain` → 延后初始化线程 → 钩子安装全部执行，IAT 被改写为我们的实现：
  ```
  mciSendStringW      IAT@0x00E775F0 -> 0x6345C860  SiglusMovieFF.dll+0xC860
  mciGetErrorStringW  IAT@0x00E775F4 -> 0x6345C850  SiglusMovieFF.dll+0xC850
  title = Angel Beats! -1st beat- 标题菜单 / scene=_sys_menu_tt01(381)
  ```

**尚未完成的验证**：游戏内实际播放出画面。该引擎的开场影片（`OP00`）不在标题画面播放，
而位于第 3 天 / 第 27 天的剧情中（`00_AB03a_day03.ss`、`00_AB20a_day27.ss` 里的
`$$play_movie(op00, …)`）。我尝试了自动按键/点击驱动，被其标题菜单挡住，未能推进到该事件。
测试用的场景包与脚本已**全部还原并校验哈希一致**，没有留下改动。

## 6. 给 EXE 加导入时踩到的三个坑（记录备查）

1. **不能"远远地"追加一个描述符**。导入描述符数组以全零描述符结尾，加载器会把两个描述符之间的
   所有内容都当成描述符读。若把新描述符放远、再把目录 `Size` 改大去覆盖中间的空隙，加载器就会
   去加载名字是垃圾的 DLL —— 实际报错是 `由于找不到 ?RegQueryValueExW.DLL…`。
   正确做法：把**整个描述符数组**（原有 + 新增 + terminator）搬到空闲的文件支撑区，
   再让导入目录指向副本。
2. **结构必须放在有文件数据支撑的 RVA**。导入表是加载器在 `.data` 的 BSS 被清零**之前**
   从文件镜像解析的，所以结构可以放在 BSS 之外任何有 raw 支撑的地方；放在会被清零的区域会失效。
   本项目用的是 `.data` 里一段 4035 字节的全零区（RVA `0x6BF040..0x6C0003`，已确认无重定位、
   无代码引用）。
3. **DLL 必须真的导出被导入的那个符号**，否则加载器报
   `无法定位程序输入点 … 于动态链接库 <exe> 上`。本项目从 DLL 导出一个空的
   `SmfImportAnchor` 专门用来满足这一点。

另外，通过导入表加载时 `DllMain` 处于**加载器锁**内、且宿主 CRT 尚未初始化完成，
所以 DLL 把自己的初始化放到独立线程里、并延时到加载结束之后再改写 IAT。

## 7. 重新构建

```bat
build.bat
```

需要 Visual Studio 的 x86 工具链（`vswhere` 能找到即可）和
`third_party\ffmpeg`（win32 LGPL 共享版的 `include` + `lib`）。
FFmpeg 开发包来源：`kusaanko/FFmpeg-Auto-Build` 的 `win32_win32_<date>.zip`
（内含 `ffmpeg_git_lgpl_master_shared`，即 LGPL 共享版；已确认其 DLL 仅依赖系统库）。

## 8. 已知限制

* 只实现了引擎实际用到的 MCI 命令子集；`mciSendCommandW`（消息式 API）没有实现
  —— 静态分析确认该引擎只导入字符串式 API。
* `.omv`（预索引 Theora）仍由引擎自带的 OMV 播放器处理，本 DLL 不介入；
  只有 `.wmv` / `.mpg` / `.avi` 这类原始视频文件会经过 MCI。
* FFmpeg 为 LGPL 共享构建。既然整个补丁按 GPL 发布，请注意 FFmpeg 的 LGPL 条款与
  GPL 的兼容性要求（保留其许可声明与源码获取方式）。
