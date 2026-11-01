// ---------------------------------------------------------------
// 汉化版添加：游戏内歌词显示（第一行日文、第二行中文）
// ---------------------------------------------------------------
// 用法：
//   场景里调用 @歌词开始  即开始显示当前 BGM 的歌词；
//   调用 @歌词停止        则 0.1 秒淡出并复位所有变量；
//   也可以直接给 @播放歌词 赋 1/0，但逐帧处理必须先由 @歌词开始 挂上。
//
// 注意：逐帧处理挂在 frame action 上，存档不会保存它；
//       读档/快速读档/返回上一个选项/返回标题后，由 _sys_com_loaf.ss 调用
//       @歌词读档恢复 重新挂上。

// ---- 歌曲 ID / 对应的数据库编号（新歌在 switch 里追加即可） ----
#define @CrowSongINDEX 0
#define @CrowSongDB 3

#define @AlchemyINDEX 1
#define @AlchemyDB 4

#define @MySongINDEX 2
#define @MySongDB 5

// ---- 逐帧处理使用的 frame action 频道 ----
// 本作已用 0-4、11-14，声音系统占 9-15，这里取 20
#define @歌词FA频道 20

// ---- 显示对象 / 坐标 / 字号 ----
// #OBJECT.CNT = 310。_extra_mode.ss 用 @OBJ_TAB_BUTTONS(291) + 1..11 占掉了 292-302
//（300 是那边的 @OBJ_FOR_FADE，别用），所以 303-309 才是真正空闲的
#define @歌词对象 303
#define @歌词层 10000			// 高于消息窗口(1000)与角色(100)，低于淡入淡出层(100000)和菜单(1000000)
#define @歌词X 16
#define @歌词Y 16
#define @歌词行高 28
#define @歌词字号 20
#define @歌词前缀 "♪  "		// 每行歌词前面加一个♪和一个全角空格

// ---- 描边 / 阴影 ----
// 和 _ex_achievement_main.ss 的 $start_effect 一样，用 set_string_param 的第 7 个参数控制：
//   0 = 无、1 = 阴影、2 = 描边、3 = 描边 + 阴影（取值与 #CONFIG.FONT.SHADOW 一致）
// 第 5 个参数是文字颜色，取 Gameexe.ini 的 #COLOR_TABLE 编号：0 = 白（文字色）
#define @歌词装饰 2				// 3 = 描边 + 阴影
#define @歌词文字色 0

// ---- 淡入 / 淡出时长（毫秒） ----
#define @歌词淡入时长 200
#define @歌词淡出时长 200
#define @歌词停止时长 100

// ---- 每首歌的曲长 / 循环点（毫秒，用于把“曲内位置”换算到循环之后） ----
// 取自 Gameexe.ini 的 #BGM 表（表里的单位是采样，÷44.1 即毫秒）：
//   #BGM.000 = "CrowSong","CrowSong",00000000,05525973,01846726
//   结束位置 5525973 采样 = 125305 毫秒，循环位置 1846726 采样 = 41875 毫秒
#define @CrowSong曲长 125305
#define @CrowSong循环点 41875

#define @Alchemy曲长 97313
#define @Alchemy循环点 15860

#define @MySong曲长 165670
#define @MySong循环点 12592

// ---- 对外接口 ----
#macro @歌词开始 $$lyrics_start
#macro @歌词停止 $$lyrics_stop

// 读档 / 快速读档 /「返回上一个选项」/「返回标题」之后由 _sys_com_loaf.ss 调用，
// 用来把被存档丢弃的逐帧处理重新挂上（@播放歌词 是存档内的 f[] 变量，会随存档恢复）
#macro @歌词读档恢复 $$lyrics_resume

#command $$lyrics_start
#command $$lyrics_stop
#command $$lyrics_resume

// 逐帧回调本身也登记成全局命令（和 _sc_sys02.inc 里的 $msg_btn_watch 一样），
// 这样 frame_action 的调用目标在任何场景里都能按名字解析
#command $$lyrics_tick(frameaction)
