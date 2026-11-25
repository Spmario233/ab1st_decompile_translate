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
SiglusMovieFF.resources.txt <- 原版资源清单（缺文件时启动报错）
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

运行时只在**游戏文件夹存在 `SiglusDebugger3.dll`** 时，才在 DLL 所在目录追加写
`SiglusMovieFF.log`（共享读，游戏运行中也能看）；没有这个标记文件时完全不产生日志，
详见第 11 节。放一个空文件 `SiglusMovieFF.debug` 可打开 debug 级日志（同样只在日志
启用时有效）。

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

## 9. Editbox 字体 hook（1.1.1）

Siglus 的 editbox（存档备注框等）走的是标准 Win32 `Edit` 控件。引擎在
`C_elm_editbox::create` 里直接调用 `CreateFontW`，字体名硬编码为
`"ＭＳ ゴシック"`，然后 `WM_SETFONT` 给 EDIT 控件；`set_focus` 只是
`SetFocus`，不会重新选字体。Gameexe 的 `#CONFIG.FONT.NAME`（本作是
`KaiGenSP`）只用于引擎自己的文本渲染器，所以备注框会显示成 MS Gothic。

本 DLL 在 `installHooks()` 里做两层处理：

1. 把宿主 EXE 的 IAT 槽 `GDI32.dll!CreateFontW` 改成 `Smf_CreateFontW`。
   包装函数只替换字体名：

```text
ＭＳ ゴシック  ->  KaiGenSP
```

2. 再 hook `USER32.dll!SendMessageW`，在 `WM_SETFONT` 时读取 HFONT 的实际
   LOGFONT。如果字体不是经 `CreateFontW` 创建的（例如 `CreateFontIndirectW`、
   或在 hook 安装前就创建好），这里会再做一次兜底替换，并记录 EDIT 控件最终拿到的
   字体：

```text
WM_SETFONT Edit: face=KaiGenSP height=15 weight=0
```

匹配时同时接受全角日文名和 ASCII `MS Gothic`，其他参数（高度、字重、字符集、
quality）原样传递，因此不会影响字号和游戏正文。

### 验证

1. 正常启动游戏，进入存档/读档画面，点某个存档的备注栏。
2. 查看 DLL 同目录的 `SiglusMovieFF.log`（需要游戏目录下存在
   `SiglusDebugger3.dll`，见第 11 节），应出现：

```text
IAT GDI32.dll!CreateFontW: ... -> ...
CreateFontW hook installed (editbox face -> KaiGenSP)
IAT USER32.dll!SendMessageW: ... -> ...
SendMessageW hook installed (WM_SETFONT observer/fallback)
CreateFontW: editbox face -> KaiGenSP (height=15 weight=0 charset=1 caller=... rva=0x1CAE2F)
WM_SETFONT Edit: face=KaiGenSP height=15 weight=0
```

启动时引擎会为 `#EDITBOX.CNT` 个 editbox 预创建字体（本作 12 个），日志里可能先出现
若干 `height=0` 的替换；进入存档备注后还会出现 `height=15` 的那一次，属正常。
如果 `WM_SETFONT Edit` 行显示 `face=MS Gothic`，说明 EDIT 拿到的仍是旧 HFONT，
本 hook 会紧跟一条 `MS Gothic -> KaiGenSP` 并替换；如果显示 `face=KaiGenSP`，说明
字体已经是 KaiGenSP，剩下的差异只可能来自字号/字重/抗锯齿或周围 UI 的不同字体。

3. 备注框里的文字应变成 `KaiGenSP`（和周围 UI 一致），不再是 MS Gothic。

> **重要**：DLL 只有在宿主 EXE 的导入表里有 `SiglusMovieFF.dll` 时才会加载。
> `SiglusEngine.exe` 已经由 `patch_game.bat` 打上导入；`SiglusEngine_CHS_RECOMPILE.exe`
> 默认没有。要测 RECOMPILE 版，请先对它执行 `patch_game.bat`（或
> `DllInjector.exe SiglusMovieFF.dll SiglusEngine_CHS_RECOMPILE.exe`），否则日志里
> 根本不会有本次运行的会话。

### 排错

* 没有 `CreateFontW hook installed`：当前 EXE 的导入表里没有
  `GDI32.dll!CreateFontW`，或 DLL 加载得太晚。先确认日志里的 host module 和
  IAT 行。
* 有 `hook installed` 但没有 `editbox face -> KaiGenSP`：引擎实际传入的字体名
  不是这两个字符串之一。把 `isEditboxFace()` 里的匹配改成实际值，或在包装函数里
  临时打印 `pszFaceName` 的码点。
* 字体没有变化但日志显示替换成功：确认 `dat\font02_chs.ttf` 已由
  `#FONT_FILE` 加载；如果字体没加载，GDI 会回退到默认字体。
* 这个 hook 只改宿主 EXE 的 IAT。如果将来 editbox 改由另一个模块创建，需要把
  那个模块的 `CreateFontW` IAT 也纳入。

## 10. 启动时游戏资源完整性检查（1.2.0）

汉化补丁可能被放进一个只有补丁文件（`Scene.pck.recompile`、`Gameexe.dat.recompile`、
EXE、DLL）而没有原版资源（`bgm`/`dat`/`g00`/`gan`/`koe`/`mov`/`wav`）的文件夹。
引擎自己的缺文件处理不会中止游戏，而是进入无限弹窗。

本 DLL 在 `DllMain(DLL_PROCESS_ATTACH)` 里、宿主进入 `WinMain` 之前做一次检查：

1. 只对 `SiglusEngine*.exe` 宿主生效（`FakeMovieHost.exe` 等测试宿主跳过）。
2. 从宿主 EXE 目录（找不到时回退到 DLL 目录）读取
   `SiglusMovieFF.resources.txt`。
3. 清单第一行是 `# count=N`；条目逐行列出相对宿主目录的文件。
   清单为空、count 不匹配、清单缺失或任一文件不存在，都会弹出一个错误框，
   列出前 12 个缺失文件，然后 `TerminateProcess` 结束游戏。
4. 全部存在则静默通过（`OutputDebugString` 有一条 `resource check passed`）。

### 生成清单

清单来自原版游戏目录，排除 `Scene.pck` 和 `gameexe.dat`：

```bat
python tools\make_resource_manifest.py "C:\Program Files (x86)\Key\AngelBeats!\1st_beat" assets\SiglusMovieFF.resources.txt
```

本作原始目录生成 3178 个文件。`build.bat` 会把
`assets\SiglusMovieFF.resources.txt` 复制到 `dist`。发布时 DLL 和这个清单必须
放在同一个补丁目录（通常就是游戏 EXE 所在目录）。

### 注意

* 检查是**只查存在性**，不校验大小/哈希；它只负责阻止“补丁目录没有原版资源”
  导致的无限弹窗。
* 清单里的路径相对宿主 EXE 目录，使用 `/` 分隔；运行时自动转成 `\`。
* 如果以后原版资源有增删，重新运行上面的命令生成清单。

## 11. 日志开关：只有存在 SiglusDebugger3.dll 时才写日志（1.3.0）

发布用的补丁不应该在玩家机器上留下调试痕迹，所以日志改为**默认完全关闭**：

* `SmfLogInit` 在宿主进程启动后检查**宿主 EXE 所在目录**（即游戏文件夹，不是当前
  工作目录）下是否存在 `SiglusDebugger3.dll`。
* 存在：照旧在 DLL 所在目录追加写 `SiglusMovieFF.log`，内容和格式与以前一致。
* 不存在：
  * 不创建 `SiglusMovieFF.log`；
  * 不打开、不追加、不改写已经存在的 `SiglusMovieFF.log`（旧日志原样保留）；
  * `SmfLog` 直接返回，连 `OutputDebugString` 也不输出；
  * `SIGLUSMF_MEMLOG=1` 时原本会写的 `memcpy_last.log` 同样不生成。

只按**存在性**判断，不加载、不校验内容；放一个空文件也有效。调试时把它放到游戏
EXE 旁边，发布时删掉或改名（本仓库的游戏目录里用的是 `SiglusDebugger3.dll.xxx`）。
`FakeMovieHost.exe` 自测也遵守同一规则：标记文件要放在 `FakeMovieHost.exe` 旁边才会
生成日志。

> 检查只在日志初始化时做一次。游戏运行期间新建/删除 `SiglusDebugger3.dll` 不会让
> 当前会话的日志中途开启或关闭。

## 12. 字体设置窗口的高 DPI 布局修复（1.4.0）

在 200% 缩放的 Windows 11 上打开「字体设置」时，文字会比控件框大一圈：列表行贴在一起、
说明文字压到下一行、按钮只剩「恢复初始设」。原因是这个窗口（`cfg_wnd_solo_font`）混用了
两套尺寸：

* 对话框本体是 DLU 模板，`MS Shell Dlg 2` 8pt 在 192 DPI 下把外框乘到 919x680；
* 子控件是引擎自己 `CreateWindowExW` 建的，尺寸写死成 96 DPI 的像素值（行高 16px、
  按钮 80x24 / 102x24）；
* 但控件字体是 9pt，192 DPI 下渲染成 24px。

于是 24px 的字塞进 16px 的行。Windows 10 的 100% 下字体只有 12px，正好放进 16px，
所以问题只在非 100% 缩放时暴露。

修复放在 DLL 里，不改 EXE：

* 复用已有的 `patchIatSlot`，追加 hook 宿主 IAT 的 `user32!CreateWindowExW`；
* 发现父窗口是标题含「字体 / フォント / Font」的 `#32770` 时，Subclass 该对话框，
  投递一条 `WM_APP` 消息，等引擎把所有子控件建完后做一次几何快照；
* 按快照重排：行高 = 字号 + 6、样例行 = 字号 + 12、按钮 = 字号 + 16 并按文字宽度重算、
  按钮贴右下、状态栏留在底部、列表按剩余空间收缩，列表项行高改为字号 + 4；
* 之后 `WM_SIZE`/`WM_SHOWWINDOW` 都从同一份快照重算，不会越排越乱；
* DPI < 144（100% / 125%）直接返回，保持原样。

### 验证（192 DPI 实测）

| 控件 | 修复前 | 修复后 |
| --- | --- | --- |
| 选项行（复选框 / 说明） | 456x16，字 24px，行间重叠 | 865x30，字 24px，行距 8px |
| 「恢复初始设置」按钮 | 102x24，文字 144px 被裁 | 204x40，完整显示 |
| 「关闭」按钮 | 80x24 | 160x40 |
| 单选组 | 挤在左侧并被右边界裁掉 | 重新排成一行，全部可见 |
| 列表项行高 | 24（与字号相同） | 28 |

勾选/取消「显示非等宽字体」重建列表（16 -> 59 项）后布局不变；关闭再打开、切换字体
A/B 也都正常。

### 限制

* 只修正窗口创建之后的几何，不触碰 EXE 和引擎逻辑；窗口仍保留 `window.ini` 里的尺寸。
* 如果以后换了引擎版本、对话框标题不再匹配，这段逻辑会安静地什么都不做（不会误伤
  其他对话框）。
* 100% 缩放下走的是引擎原本的布局，与旧版本行为一致。
## 13. 自动换行与字形宽度修复（1.5.3）

> 引擎排版逻辑的完整梳理（函数地图、字段表、循环流程、调试方法、修改指南）见
> [`docs/text-layout.md`](docs/text-layout.md)。

两处问题都在引擎的排版代码里，和翻译文本本身无关。实现见 `textfix.cpp`：
用字节签名定位、原地改代码，全部通过校验才动手，找不到就安静跳过。

### 13.1 行尾连续标点被拆开

引擎的换行逻辑（`0x5ee6xx`）在放下一个字之前先判断会不会超出行宽，超了就调用
禁则判定决定这个字能不能留在本行。但它在禁则判定之前还有一道硬性上限：
`新位置 > 右边界 + 一个字宽` 时直接换行，也就是「右边界外最多只能多出一个字」。
于是行尾出现 `。」` 这种连续禁则字符时，第二个字必定被挤到下一行。

修复：保留引擎原本的「右边界外最多一个字」不变，只额外放开收尾符号——在代码洞里
重建这段判断：

```
新位置 > 右边界 + 1 字宽：
    当前字是收尾符号？ -> 继续悬挂
    否则               -> 换行
新位置 <= 右边界        -> 继续排
否则                    -> 禁则判定（能悬挂就留在本行）
```

挂接点在 `0x1ee6fd` 和 `0x1ee720`（横排与另一模式各一处），判断完再跳回引擎原来的
「换行 / 继续 / 禁则」三个出口。

| 行尾情况 | 结果 |
| --- | --- |
| `这是结尾。」` | `。` 用掉「一个字」的额度悬挂，`」` 作为收尾符号继续悬挂，整句留在同一行 |
| `这是结尾？?？」` | 前两个 `？` 中只有一个悬挂，第二个 `？` 触顶换行，`」` 跟着 `？` 到下一行，不会单独成行 |
| 没有收尾符号 | 与引擎原版完全一致（右边界外最多一个字） |

收尾符号取自引擎自己的禁则表：`」』）】〕｝］〉》”’〟` 以及半角/ASCII 的 `) ] } > " '`。

### 13.2 `・` `♪` 被当成半角

引擎用一张 64K 的 `char -> 1/2` 表决定字形宽度（半角=1、全角=2）。这张表是
**逐字符转 ANSI 代码页、按字节数**生成的：2 字节 → 全角，否则 → 半角。
日文版在 CP932 下 `・`(0x8145)、`♪`(0x81F4) 都是 2 字节，所以正常；
而 CP936（GBK）根本编码不了这两个字符，转换失败就落到「半角」，于是它们只占半个字宽，
和后一个字叠在一起，行宽计算也跟着偏短。

修复：等表建好之后，把「CP932 能编成 2 字节、但当前表里是 1」的项改成 2。
这样正好等价于日文版的判定规则；纯中文/GBK 字符本来就是 2，不受影响。
实际命中 1968 个字符（`・` `♪` `〜` `〟` 以及一批日文符号与 GBK 没有的汉字）。

实现上把宽度表 getter 的调用点（`0x1ee69a`）改成自己的 thunk：首次调用时修正表，
之后只多一次函数调用，**没有逐帧开销**。

### 13.3 验证

测试剧本 `00_AB01a_day00.ss` 的前两行（`「あ…。」` 与 `「あ・あ♪…」`）：

| 用例 | 修复前 | 修复后 |
| --- | --- | --- |
| `。」` 在行尾 | `。` 留行尾、`」` 单独掉到下一行 | `。」` 一起悬挂在行尾 |
| `・` `♪` | 按半角排版，压在相邻字上 | 按全角排版，间距均匀，行宽计算正确 |

### 13.4 限制

* 补丁按固定 RVA + 字节签名定位；换引擎版本或换 exe 构建后签名不匹配会自动跳过，
  不会写坏文件。
* 行尾悬挂不设次数上限：理论上整行都是标点时会一路悬挂。正常文本不会出现。
* 宽度表修正只影响非 ASCII 字符的“表里为 1”的项，ASCII 和半角片假名保持半角。