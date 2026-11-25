# 引擎文本排版逻辑说明（修改参考）

本文整理 `SiglusEngine_CHS_RECOMPILE.exe` 中"文本排版"这条链路的原始逻辑，
以及 `SiglusMovieFF` 现在挂在上面的补丁，供以后再次修改时参考。

* 被测 exe：1.1.141.3（`SiglusEngine_CHS_RECOMPILE.exe`）
* 映像基址：0x400000（实测加载基址 0x320000，ASLR）
* 文中地址：**VA**（如 `0x5ee4b0`）。**RVA = VA − 0x400000**；补丁代码里用的是 RVA + 实际基址。
* exe 由 `import_strings.py` 重新生成后地址可能整体变化，所以所有补丁都先做字节签名校验，
  不匹配就整段跳过（宁可失效，不写坏）。

---

## 1. 调用链总览

一次消息排版大致经过这些函数：

| VA | RVA | 作用 | 备注 |
| --- | --- | --- | --- |
| `0x65b390` | `0x25b390` | 文本解析：从字符串对象取出下一个"单元" | 结果放 `[ebp-0x448]`；`0x0A`=换行符，`0x07`=注音标记 |
| `0x5ee4b0` | `0x1ee4b0` | **主排版循环**（本文件重点） | 逐字量宽 → 判溢出 → 换行或落字 |
| `0x563140` | `0x163140` | 字宽表 getter，首次调用时构造 64KB 表 | 返回 `0xad1950` |
| `0x5ee0e0` | `0x1ee0e0` | 禁则判定 `bool IsKinsoku(wchar cx)` | 该字能否留在行尾（不能做行首） |
| `0x5ef0a0` | `0x1ef0a0` | 结束当前行：提交行记录、重置笔位 | 内部用 `[esi+0x18]` 算本行字数 |
| `0x5ebfd0` | `0x1ebfd0` | 创建字形对象（颜色/字体/字号） | "落字"分支调用 |
| `0x5efb60` | `0x1efb60` | 行记录 / 文本块写出 | 循环尾部调用 |

关系：主循环每个字调用一次宽度表 getter；溢出时调用禁则判定；换行时调用 `0x5ef0a0`；
决定保留时调用 `0x5ebfd0` 生成字形。

---

## 2. 排版对象字段（`esi` = this）

| 偏移 | 含义 | 证据 |
| --- | --- | --- |
| `+0x0c` | 行首 x（行内坐标） | `0x5ef14b` 用它算字数 |
| `+0x18` | **一个字符的标称宽度**（也是悬挂额度的单位） | `0x5ef14f` `idiv dword ptr [esi+0x18]`；`0x5ee6fd` 上限计算 |
| `+0x24` / `+0x28` | 默认字号 id / 颜色 id | `0x5ee82e` / `0x5ee862` |
| `+0xe0` / `+0xe4` | 行起点 x（模式 B / 模式 A） | `0x5ee6e9`、`0x5ef119` |
| `+0xf0` | 全角字宽（当前字体） | `0x5ee692` |
| `+0xf4` | 笔位 x（行内相对） | `0x5ee6d3` |
| `+0x12c` / `+0x130` | 右边界（模式 B / 模式 A） | `0x5ee6f1`、`0x5ee71a` |
| `+0xfc` / `+0x100` / `+0x104` | 颜色 / 字体 / 字号 id | `0x5ee7fd` 起 |
| `+0x170`..`+0x178` | 注音（ruby）状态 | `0x5ee63c` |
| `+0x1a5` | 行内标记位 | `0x5ee65e` |
| `+0x1ac` | 行对象数组（vector） | `0x5ee516` |

全局"模式"开关：`[0xae1abc] + 0x1487c`。
等于 1 走 **模式 A**（`+0xe4`/`+0x130`），否则走 **模式 B**（`+0xe0`/`+0x12c`）。
两条分支的逻辑完全对称，只是字段不同——补丁两处都要挂。

---

## 3. 主排版循环（0x5ee4b0）

### 3.1 外层：按行处理

```asm
005ee4b0  push ebx ...
005ee4db  mov eax, [0xab5040]        ; 栈保护
005ee4f1  mov eax, ecx              ; this
005ee4f3  mov [ebp-0x450], eax
005ee4f9  mov edx, [ebx+8]          ; 文本对象
005ee505  mov [ebp-0x474], ecx
005ee50b  mov edx, [edx+0x10]       ; 文本长度
005ee50e  test edx, edx
005ee510  je  0x5eeeab              ; 空文本直接返回
005ee516  lea esi, [eax+0x1ac]      ; 行对象数组
005ee530  mov [ebp-0x444], eax      ; 数组 size
005ee536  lea edi, [eax+edx]        ; 需要预留的行数
```

随后分配/扩容行数组，然后进入"逐单元"循环：

```asm
005ee58c  mov ecx, [ebp-0x454]      ; 文本对象
005ee594  cmp dword ptr [ecx+0x14], 7
005ee598  jbe 0x5ee59c
005ee59a  mov esi, [ecx]            ; std::wstring SSO 判断
...
005ee5f8  call 0x65b390             ; 解析出一个单元
005ee606  mov [ebp-0x448], ecx      ; 单元码
```

### 3.2 控制码

| 单元值 | 处理 |
| --- | --- |
| `0x0A` | 显式换行：`call 0x5ef0a0`（结束本行），然后回到循环开头重新解析（`0x5ee611`） |
| `0x07` | 注音标记：清零 `+0x170..+0x178`，置位 `+0x1a5`，再 `call 0x5ef0a0`（`0x5ee62d`） |
| 其它 | 普通字符，进入下面的量宽/换行流程 |

### 3.3 量宽与换行判定

```asm
; --- 取字宽 ---
005ee688  test eax, eax
005ee68a  je   0x5ee69a            ; 需要查宽度表
005ee68c  mov  esi, [ebp-0x450]
005ee692  mov  eax, [esi+0xf0]     ; 全角字宽
005ee698  jmp  0x5ee6cd
005ee69a  call 0x563140            ; 宽度表 getter  -> eax = 0xad1950
005ee6a5  mov  esi, [ebp-0x450]
005ee6ab  movzx ecx, dx            ; 字符码
005ee6ae  mov  edx, [esi+0xf0]
005ee6b4  cmp  byte ptr [eax+ecx], 1   ; 表项 == 1 ？半角
005ee6b8  mov  eax, edx
005ee6c0  mov  [ebp-0x464], edx
005ee6c6  jne  0x5ee6d3
005ee6c8  cdq
005ee6c9  sub  eax, edx
005ee6cb  sar  eax, 1              ; 半角 = 全角 / 2
005ee6cd  mov  [ebp-0x464], eax    ; 本字步进
005ee6d3  mov  edx, [esi+0xf4]     ; 当前笔位
005ee6d9  add  edx, eax            ; 新笔位 = 笔位 + 步进

; --- 模式选择 ---
005ee6db  mov  eax, [0xae1abc]
005ee6e0  cmp  dword ptr [eax+0x1487c], 1
005ee6e7  jne  0x5ee712            ; -> 模式 B

; --- 模式 A：上限 = 右边界 + 一个字 ---
005ee6e9  mov  eax, [esi+0xe4]     ; 行起点
005ee6ef  add  eax, edx            ; 绝对新位置
005ee6f1  mov  edx, [esi+0x130]    ; 右边界
005ee6f7  mov  [ebp-0x444], eax    ; 保存新位置
005ee6fd  mov  eax, [esi+0x18]     ; 一个字宽
005ee700  add  eax, edx            ; 上限
005ee702  cmp  [ebp-0x444], eax
005ee708  jg   0x5ee744            ; 超过上限 -> 直接换行（不看禁则）
005ee70a  cmp  [ebp-0x444], edx
005ee710  jmp  0x5ee739            ; 跳过模式 B 的代码
005ee739  jle  0x5ee781            ; 没超右边界 -> 落字
005ee73b  call 0x5ee0e0            ; 否则问禁则
005ee740  test al, al
005ee742  jne  0x5ee781            ; 禁则字 -> 悬挂，落字
005ee744  ...                      ; 否则换行
```

模式 B（`0x5ee712`）是同一套逻辑，只是把 `+0xe4`/`+0x130` 换成 `+0xe0`/`+0x12c`。

### 3.4 换行之后

```asm
005ee744  mov ecx, esi
005ee746  call 0x5ef0a0            ; 提交本行、笔位归零
005ee74b  cmp  [ebp-0x44c], 0
005ee752  jne  0x5ee781
005ee754  mov  eax, [ebp-0x448]
005ee75a  cmp  eax, 0x20           ; 半角空格
005ee75d  je   0x5ee770
005ee75f  cmp  eax, 0x3000         ; 全角空格
005ee764  jne  0x5ee781
005ee770  mov  esi, [ebp-0x468]    ; 回到解析位置，跳过这个空格
005ee776  mov  ecx, [ebp-0x454]
005ee77c  jmp  0x5ee5a2
005ee781  ...                      ; 落字分支（生成字形）
```

要点：**换行时当前字符不会被丢弃**，`0x5ee781` 会把它放到新行（只有空格会被吞掉）。

### 3.5 落字分支（0x5ee781）

依次取颜色/字体/字号 id（`+0xfc`、`+0x100`、`+0x104`，缺省回落到 `+0x24`/`+0x28`），
再 `call 0x5ebfd0` 创建字形、`0x5efb60` 写入行记录。这部分与换行无关，改换行逻辑时不用碰。

---

## 4. 字宽表（0xad1950）

### 4.1 构造（0x563178）

```asm
00563178  push 0xad1940 ; call 0x75f8f2   ; 一次性初始化（多线程只构造一次）
0056318c  cmp  dword ptr [0xad1940], -1
0056318c  jne  0x563165                  ; 别人建好了，直接返回
0056318f  xor  esi, esi
00563193  push esi                       ; wchar_t
00563194  push 8
00563196  lea  eax, [ebp-0xc]
00563199  push eax
0056319a  lea  eax, [ebp-0x10]
0056319d  push eax
0056319e  call 0x76df5e                 ; CRT：按当前 ANSI 代码页转多字节
005631a6  cmp  dword ptr [ebp-0x10], 2  ; 转换长度 == 2 ？
005631aa  sete al
005631ad  inc  al                       ; 2 字节 -> 2（全角），否则 -> 1（半角）
005631af  mov  byte ptr [esi+0xad1950], al
005631b5  inc  esi
005631b6  cmp  esi, 0x10000
005631bc  jl   0x563193
```

**语义**：表项 2 = 全角，1 = 半角；半角在 `0x5ee6c8` 里除以 2 得到步进。
**问题**：判定依据是"在 ANSI 代码页（简体中文 = CP936）下能否编成 2 字节"。
CP936 编不出的日文符号（`・` `♪` `〜` 等）会落到 1，被当半角。

### 4.2 getter（0x563140）

```asm
00563150  mov  eax, fs:[0x2c]     ; CRT 线程数据（必须在该 CRT 线程上调用）
00563158  mov  eax, [0xad1940]
0056315d  cmp  eax, [ecx+4]
00563163  jg   0x563178           ; 未构造 -> 构造
00563168  mov  eax, 0xad1950      ; 返回表地址
```

表地址固定为 `0xad1950`，长度 0x10000 字节。

---

## 5. 禁则函数 IsKinsoku（0x5ee0e0）

```asm
005ee0e0  mov  edx, 0x3002        ; 「。」
005ee0e5  movzx eax, cx
005ee0e8  cmp  cx, dx
005ee0eb  je   0x5ee4a5          ; -> return true
...
005ee499  mov  ecx, 0xff6e
005ee49e  cmp  ax, cx
005ee4a1  sete al                ; 最后一个字符单独判断
005ee4a4  ret
005ee4a5  mov  al, 1
005ee4a7  ret
```

即一串线性比较，命中返回 1。收录的字符（按出现顺序）：

```
。 、 ！ ？ ： ； 」 』 ） 】 ｝ ］ 〉 》 ” ’ 〟
～ ー … ‥ ・ ． ， ゛ ゜
ぁ ぃ ぅ ぇ ぉ っ ゃ ゅ ょ ゎ
ァ ィ ゥ ェ ォ ッ ャ ュ ョ ヮ ヵ ヶ
ﾞ ﾟ ｡ ､
! ? : ; ｣ ) ] > } ' "
ｰ ･ . , ｧ ｨ ｩ ｪ ｫ ｯ ｬ ｭ ｮ
```

对应码位：`0x3002 0x3001 0xFF01 0xFF1F 0xFF1A 0xFF1B 0x300D 0x300F 0xFF09 0x3011
0xFF5D 0xFF3D 0x3009 0x300B 0x201D 0x2019 0x301F 0xFF5E 0x30FC 0x2026 0x2025 0x30FB
0xFF0E 0xFF0C 0x309B 0x309C 0x3041 0x3043 0x3045 0x3047 0x3049 0x3063 0x3083 0x3085
0x3087 0x308E 0x30A1 0x30A3 0x30A5 0x30A7 0x30A9 0x30C3 0x30E3 0x30E5 0x30E7 0x30EE
0x30F5 0x30F6 0xFF9E 0xFF9F 0xFF61 0xFF64 0x21 0x3F 0x3A 0x3B 0xFF63 0x29 0x5D 0x3E
0x7D 0x27 0x22 0xFF70 0xFF65 0x2E 0x2C 0xFF67 0xFF68 0xFF69 0xFF6A 0xFF6B 0xFF6F 0xFF6C
0xFF6D 0xFF6E`

注意 `。` 也在表里：引擎原本允许"行尾悬挂一个禁则字"，但上限是 `[esi+0x18]`（一个字），
所以 `。」` 两个禁则字连写时第二个必然溢出——这就是最初那个 bug。

---

## 6. 现有补丁（textfix.cpp）

### 6.1 挂接点一览

| 目标 | 方式 | 作用 |
| --- | --- | --- |
| `0x5ee6fd`（模式 A） | 5 字节 `E9` 跳到代码洞 | 重写"溢出上限"判断 |
| `0x5ee720`（模式 B） | 6 字节 `E9` + `NOP` | 同上 |
| `0x5ee69a` | 5 字节 `E8` 改为 call 到 `WidthThunk` | 首次取表后修正宽度表 |

代码洞：`VirtualAlloc(0x10000000, 4096, PAGE_EXECUTE_READWRITE)`，
两个 thunk 顺序排布（A 在前，B 紧跟），预计总长 < 0x200 字节。

### 6.2 代码洞 A（模式 A）

```asm
; 入口：edx = 右边界, ecx = 当前字, [ebp-0x444] = 新位置, esi = 排版对象, ebp = 引擎栈帧
; （模式 A 入口时 eax 还是字宽；模式 B 的新位置还在 eax 里，所以要先自己存一次）
mov  eax, [esi+0x18]            ; 一个字宽
add  eax, edx                   ; 上限 = 右边界 + 1 字
cmp  [ebp-0x444], eax
jg   overflow
cmp  [ebp-0x444], edx           ; 没超右边界？
jle  continue                   ; -> 0x5ee781
jmp  0x5ee73b                   ; -> 禁则判定

overflow:
cmp  cx, 0x300D                 ; 」 ？
je   continue                   ; 收尾符号 -> 悬挂
... （kClosing 列表，逐个 cmp cx, imm16 / je continue）
jmp  0x5ee744                   ; -> 换行

continue:
jmp  0x5ee781
```

模式 B 的洞在入口多一条 `mov [ebp-0x444], eax`（那边新位置还在 eax 里），其余相同。

### 6.3 收尾符号集合（kClosing）

`」』）】〕｝］〉》”’〟` + 半角/ASCII `) ] } > " '`，共 19 个码位，
见 `textfix.cpp` 的 `kClosing[]`。**这些字符不受"右边界外最多一个字"的限制**，
避免右引号被挤到下一行单独成行。

### 6.4 宽度表修正

首次调用 getter 时（`WidthThunk` 里，UI 线程）：

1. 取到 `0xad1950`；
2. 遍历 `g_promote`（初始化时用 `WideCharToMultiByte(932, ...)` 预计算的"CP932 下为 2 字节"的码位，约 9218 个）；
3. 把表里为 1 的项改成 2（实测命中 1968 个）；
4. `InterlockedCompareExchange` 保证只做一次。

等价于"日文版的判定规则"，纯中文/GBK 字符本来就 2，不受影响；ASCII 和半角片假名本来是 1，
CP932 下也是 1，不会被误改。

---

## 7. 修改指南

### 7.1 想改悬挂上限（例如从 1 个字改成 2 个字）

在代码洞里 `add eax, edx` 之前插一条 `add eax, eax`（`03 C0`）即可让上限变成 N 个字。
注意上限越大，行尾越容易冲进消息框留白。

### 7.2 想改"免检"的收尾符号

改 `textfix.cpp` 的 `kClosing[]`，重新编译即可。每个码位对应 11 字节（`cmp cx,imm16` + `je rel32`），
代码洞容量 4096 字节，目前两个洞合计约 0x210 字节。

### 7.3 想改禁则字符集

引擎原函数是一串立即数比较，最稳的改法是**在 `0x5ee0e0` 入口挂一个 thunk**：
先调用原函数，再对自己的表做补充判断。不要直接改立即数（会改变指令长度）。

### 7.4 换 exe 版本后

1. 按 `README` 里的方法重新定位 `0x5ee4b0` 这个函数（搜索 `E8 ?? ?? ?? ??` + `cmp byte ptr [eax+ecx],1` 的特征）；
2. 更新 `textfix.cpp` 顶部的 RVA 常量；
3. 确认签名（`kGuard` 数组）仍然匹配，否则补丁会静默跳过；
4. 重新验证：`ReadProcessMemory` 读回挂接点应当是 `E9`，代码洞反汇编应与 §6.2 一致。

---

## 8. 调试手段（本次用到的）

### 8.1 决策探针

在代码洞入口插入一段保存现场的调用：

```asm
pushad
push [ebp-0x444]     ; 新位置
push edx             ; 右边界
push [esi+0x18]      ; 字宽
push ecx             ; 当前字
call TfLogDecision
add  esp, 16
popad
```

日志形如 `ch=U+300D cw=26 right=780 newx=858 over=78`，能直接看出每个字是"落下、悬挂还是换行"。
验证完记得删掉（正式版没有这段）。

### 8.2 读内存 + 反汇编

`ReadProcessMemory` 读 `base+RVA` 与代码洞地址，用 capstone 反汇编核对。

### 8.3 视觉验证

截图 → 裁剪消息框 → 对比修复前后。本项目测试脚本在
`ss_utf8/00_AB01a_day00.ss` 第 15、16 行（改完要跑 `compile_scene.bat` 重编 `Scene.pck.recompile`）。

---

## 9. 实测数据（192 DPI，默认字号）

| 量 | 值 |
| --- | --- |
| 右边界 `right` | 780 |
| 字宽 `[esi+0x18]` | 26 |
| 一行容量 | 30 个全角字 |
| 半角步进 | 13 |
| `。` / `」` / `？` 的步进 | 26 |

一次典型的判定序列（`「あ×12，あ×14？?…」`）：

```
？ newx=754 over=-26   -> 正常落下
？ newx=780 over=0     -> 正好压线
？ newx=806 over=26    -> 上限内，禁则 -> 悬挂
？ newx=832 over=52    -> 超上限，非收尾 -> 换行
」 （新行）
```

---

## 10. 风险与注意事项

* **只改代码、不改数据**：宽度表的修正是在表构造之后整体改一次，之后没有任何额外开销。
* **代码洞必须在 UI 线程执行**：getter 会访问 `fs:[0x2c]` 的 CRT 线程数据，所以表修正放在
  `WidthThunk`（引擎自己调用 getter 的那一刻），而不是我们自己的初始化线程。
* **不要逐帧做重活**：补丁只增加了"每字一次跳转"，没有循环、没有分配。
* **rel32 距离**：代码洞固定在 0x10000000，与主程序（0x320000）和 DLL 都在 ±2GB 内；
  若将来 DLL 被加载到 0x80000000 以上，需要重新选洞地址，代码里有 `rel32Fits` 检查。
* **签名优先**：所有写入前都先比对原始字节；不匹配就跳过并记日志，不会破坏 exe。
