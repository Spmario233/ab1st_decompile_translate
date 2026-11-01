// ===============================================================
// 汉化版添加：游戏内歌词显示（每帧处理）
// ===============================================================
// 歌词数据来自 dat\crowsong.csv 生成的 crowsong.dbs（数据库编号 3）。
// 列：0=开始时间(毫秒) 1=结束时间(毫秒) 2=中文歌词 3=日文歌词
// 时间轴是“曲内位置”，因此直接用 bgm.get_play_pos 换算成毫秒来比对。
//
// 关于 tr：object 的 tr 是「不透明度」，255 = 完全不透明，0 = 完全透明
// （参见 _ef_macro.ss 的 $$ef_mini_cutin_show：tr = 0 后 tr_eve 到 255 就是淡入）
// ===============================================================

//---------------------------------------------------------------
// 对外：开始 / 停止 / 读档恢复
//---------------------------------------------------------------
// 置 @播放歌词 = 1，并把逐帧处理挂到 frame_action_ch[@歌词FA频道]
// 重复调用是安全的（会强制重新初始化并重置频道）
command $$lyrics_start()
{
	@播放歌词 = 1
	@歌词状态 = 0						// 让逐帧处理重新初始化
	frame_action_ch[@歌词FA频道].end
	frame_action_ch[@歌词FA频道].start_real(-1, "$$lyrics_tick")
}

// 只把标志清零，逐帧处理负责淡出和复位；
// 逐帧处理本身不停止，之后再把 @播放歌词 置 1 仍然有效
command $$lyrics_stop()
{
	@播放歌词 = 0
}

// 读档 / 快速读档 /「返回上一个选项」/「返回标题」之后调用（_sys_com_loaf.ss）
// 存档只保存场景位置、f[] 变量、对象等，不保存 frame action，
// 所以读档后必须重新 start；@播放歌词 会随存档恢复，只在读档前正在显示时才恢复
command $$lyrics_resume()
{
	if (@播放歌词 == 1 && @显示歌词 == 1) {
		$$lyrics_start					// 内部会重置 @歌词状态 并重挂 frame action
	}
}

//---------------------------------------------------------------
// 每帧处理
//---------------------------------------------------------------
command $$lyrics_tick(property $fa : frameaction)
{
	property $now : int
	property $pos : int
	property $line : int

	$now = $fa.counter.get

	//---------- 1. @播放歌词 = 0：0.1 秒淡出，然后复位 ----------
	if (@播放歌词 == 0 ||  @显示歌词 == 0) {
		if (@歌词状态 == 1) {
			if (@歌词目标 != 0) {
				@歌词目标 = 0
				@歌词起始不透明 = @歌词不透明度
				@歌词淡开始 = $now
				@歌词淡时长 = @歌词停止时长
			}
			$$lyrics_update_tr($now)
			if (@歌词不透明度 <= 0) {
				$$lyrics_reset()
			}
		}
		return
	}

	//---------- 2. @播放歌词 = 1 且尚未初始化：读取歌曲并建立显示对象 ----------
	if (@歌词状态 == 0) {
		$$lyrics_begin()
		if (@歌词状态 == 0) {
			return						// 当前 BGM 没有对应歌词
		}
	}

	//---------- 3. 取「曲内位置」，换算成毫秒 ----------
	// get_play_pos 的单位是采样；引擎统一按 44100Hz 播放，
	// 1 毫秒 = 44.1 采样，所以 毫秒 = 采样 * 10 / 441（整除，误差 < 1ms）
	$pos = bgm.get_play_pos * 10 / 441

	// 循环播放：正常情况下 get_play_pos 本身就是曲内位置（循环后会回到循环点），
	// 但如果引擎给的是累计位置（超过曲长），这里等价地折回曲内位置。
	if (@歌词曲长 > @歌词循环点) {
		if ($pos > @歌词曲长) {
			$pos = @歌词循环点 + ($pos - @歌词曲长) % (@歌词曲长 - @歌词循环点)
		}
	}

	// BGM 已经停止：按“没有当前行”处理（淡出后停在隐藏状态）
	if (bgm.check == 0) {
		$pos = -1
	}

	//---------- 4. 用当前位置在数据库里找当前行 ----------
	$line = $$lyrics_find_line($pos)

	//---------- 5. 换行：上一句先淡出，下一句再淡入 ----------
	if ($line != @歌词行号) {
		@歌词行号 = $line
		if ($line >= 0) {
			$$lyrics_set_text($line)
			@歌词目标 = 255			// 255 = 完全不透明
			@歌词起始不透明 = 0		// 每句都从全透明开始淡入
			@歌词淡时长 = @歌词淡入时长
		}
		else {
			@歌词目标 = 0			// 0 = 完全透明
			@歌词起始不透明 = @歌词不透明度	// 从当前不透明度淡出
			@歌词淡时长 = @歌词淡出时长
		}
		@歌词淡开始 = $now
	}
	else {
		// 同一句显示期间：到本句结束前的 @歌词淡出时长 就开始淡出，
		// 这样在句与句的边界上能完整看到「上一句淡出 → 下一句淡入」
		if ($line >= 0) {
			if (@歌词目标 != 0) {
				if ($pos >= database[@歌词数据库].get_num($line, 1) - @歌词淡出时长) {
					@歌词目标 = 0
					@歌词起始不透明 = @歌词不透明度
					@歌词淡开始 = $now
					@歌词淡时长 = @歌词淡出时长
				}
			}
		}
	}

	$$lyrics_update_tr($now)
}

//---------------------------------------------------------------
// 初始化：读当前 BGM 的注册名 → 歌曲 ID → 数据库 / 循环参数
//---------------------------------------------------------------
command $$lyrics_begin()
{
	property $name : str

	@歌词状态 = 0
	@歌词数据库 = -1
	@歌词歌曲ID = -1
	@歌词行数 = 0
	@歌词行号 = -1
	@歌词不透明度 = 0
	@歌词目标 = 0
	@歌词起始不透明 = 0
	@歌词淡时长 = @歌词淡出时长

	if (bgm.check == 0) {
		return
	}

	// 1) 读取当前正在播放的歌曲 ID
	$name = bgm.get_regist_name
	switch ($name.lower) {
		case ("crowsong")
			@歌词歌曲ID = @CrowSongINDEX
	}

	// 2) 按歌曲 ID 确认要读取的数据库和循环参数
	switch (@歌词歌曲ID) {
		case (@CrowSongINDEX)
			@歌词数据库 = @CrowSongDB
			@歌词曲长 = @CrowSong曲长
			@歌词循环点 = @CrowSong循环点
		case (@AlchemyIndex)
			@歌词数据库 = @AlchemyDB
			@歌词曲长 = @Alchemy曲长
			@歌词循环点 = @Alchemy循环点
	}

	if (@歌词数据库 < 0) {
		return
	}

	// 3) 统计歌词行数（数据库条目号从 0 开始连续）
	while (database[@歌词数据库].check_item(@歌词行数)) {
		@歌词行数 += 1
	}
	if (@歌词行数 == 0) {
		return
	}

	// 4) 在屏幕左上角建立一个空白对象，里面放两行文字
	front.object[@歌词对象].init
	front.object[@歌词对象].wipe_copy = 1
	front.object[@歌词对象].disp = 1
	front.object[@歌词对象].layer = @歌词层
	front.object[@歌词对象].tr = 0				// 先完全透明，等第一句淡入
	front.object[@歌词对象].set_pos(0, 0)
	front.object[@歌词对象].child.resize(2)

	// 注意：resize 出来的只是空槽，必须当帧就 create 出来，
	// 否则这些空 child 活不过这一帧，下一帧再访问 child[1] 就会「範囲外」
	front.object[@歌词对象].child[0].create_string("", 1, @歌词X, @歌词Y)
	front.object[@歌词对象].child[0].set_string_param(@歌词字号, 0, 0, 0, @歌词文字色, 0, @歌词装饰)
	front.object[@歌词对象].child[0].layer = @歌词层 + 1
	front.object[@歌词对象].child[1].create_string("", 1, @歌词X, @歌词Y + @歌词行高)
	front.object[@歌词对象].child[1].set_string_param(@歌词字号, 0, 0, 0, @歌词文字色, 0, @歌词装饰)
	front.object[@歌词对象].child[1].layer = @歌词层 + 1

	@歌词状态 = 1
}

//---------------------------------------------------------------
// 查找当前位置对应的歌词行号（找不到返回 -1）
//---------------------------------------------------------------
command $$lyrics_find_line(property $pos : int) : int
{
	property $i : int
	property $line : int

	$i = 0
	$line = -1
	while ($i < @歌词行数) {
		if ($pos >= database[@歌词数据库].get_num($i, 0)) {
			if ($pos < database[@歌词数据库].get_num($i, 1)) {
				$line = $i
			}
		}
		$i += 1
	}
	return($line)
}

//---------------------------------------------------------------
// 把第 $line 行的歌词写进对象（第一行日文、第二行中文）
// 描边 / 阴影由 set_string_param 的第 7 个参数 @歌词装饰 指定
//---------------------------------------------------------------
command $$lyrics_set_text(property $line : int)
{
	property $jp : str
	property $cn : str

	$jp = database[@歌词数据库].get_str($line, 3)
	$cn = database[@歌词数据库].get_str($line, 2)

	if ($jp.len > 0) {
		$jp = @歌词前缀 + $jp
	}
	if ($cn.len > 0) {
		$cn = @歌词前缀 + $cn
	}

	// 第一行：日文
	front.object[@歌词对象].child[0].create_string($jp, 1, @歌词X, @歌词Y)
	front.object[@歌词对象].child[0].set_string_param(@歌词字号, 0, 0, 0, @歌词文字色, 0, @歌词装饰)
	front.object[@歌词对象].child[0].layer = @歌词层 + 1

	// 第二行：中文
	front.object[@歌词对象].child[1].create_string($cn, 1, @歌词X, @歌词Y + @歌词行高)
	front.object[@歌词对象].child[1].set_string_param(@歌词字号, 0, 0, 0, @歌词文字色, 0, @歌词装饰)
	front.object[@歌词对象].child[1].layer = @歌词层 + 1
}

//---------------------------------------------------------------
// 按 @歌词淡开始 / @歌词起始不透明 / @歌词目标 / @歌词淡时长 更新不透明度
// tr：255 = 完全不透明，0 = 完全透明
//---------------------------------------------------------------
command $$lyrics_update_tr(property $now : int)
{
	property $t : int

	$t = $now - @歌词淡开始
	if ($t < 0) {
		$t = 0
	}
	@歌词不透明度 = math.timetable($t, 0, @歌词起始不透明, [0, @歌词淡时长, @歌词目标, 0])
	front.object[@歌词对象].tr = @歌词不透明度
}

//---------------------------------------------------------------
// 复位所有变量并隐藏对象
//---------------------------------------------------------------
command $$lyrics_reset()
{
	front.object[@歌词对象].tr = 0
	front.object[@歌词对象].disp = 0

	@歌词状态 = 0
	@歌词行号 = -1
	@歌词行数 = 0
	@歌词数据库 = -1
	@歌词歌曲ID = -1
	@歌词曲长 = 0
	@歌词循环点 = 0
	@歌词不透明度 = 0
	@歌词目标 = 0
	@歌词起始不透明 = 0
	@歌词淡开始 = 0
	@歌词淡时长 = @歌词淡出时长
}

#z00
