/********************************************************
*														*
*						日付変更						*
*														*
*********************************************************/
#z00

	// @day_change(@days(@days), @real_world(0), @bg_name(random))


	// 一時的に特定コマンドの機能を使用不可にする
	@sys_com_disable(@On, @On, @On, @On, @On, @Off, @Off)

	// ■日付切り替えセーブ
	$Save_point_state = savepoint

	// 本編中のフェード初期化
	@f.obj[@OBJ_BGXX].init

	// 日付準備
	@b.obj[@OBJ_BG01].init
	@b.obj[@OBJ_BG01].disp = @On
	@b.obj[@OBJ_BG01].layer = 1000
	@b.obj[@OBJ_BG01].@cd.resize(11)

	// 下地
	@b.obj[@OBJ_BG01].@cd[0].create(sys_day_bg00, @On, 0, 0)
	@b.obj[@OBJ_BG01].@cd[0].layer = -100
	@b.obj[@OBJ_BG01].@cd[0].patno = L[1]

	// 背景指定
	if (L[1] == 0)	{
		switch (L[0])	{
			case (1)  K[0] = "ep01_bg040"
			case (2)  K[0] = "ep01_bg040"
			case (3)  K[0] = "ep10_bg013"
			case (4)  K[0] = "ep07_bg040"
			case (5)  K[0] = "ep07_bg001"
			case (6)  K[0] = "ep04_bg007"
			case (7)  K[0] = "ep03_bg015"
			case (8)  K[0] = "ep01_bg040"
			case (9)  K[0] = "ep10_bg013"
			case (10) K[0] = "ep07_bg040"
			case (11) K[0] = "ep07_bg001"
			case (12) K[0] = "ep04_bg007"
			case (13) K[0] = "ep03_bg015"
			case (14) K[0] = "ep01_bg040"
			case (15) K[0] = "ep10_bg013"
			case (16) K[0] = "ep07_bg040"
			case (17) K[0] = "ep07_bg001"
			case (18) K[0] = "ep04_bg007"
			case (19) K[0] = "ep03_bg015"
			case (20) K[0] = "ep01_bg040"
			case (21) K[0] = "ep10_bg013"
			case (22) K[0] = "ep07_bg040"
			case (23) K[0] = "ep07_bg001"
			case (24) K[0] = "ep04_bg007"
			case (25) K[0] = "ep03_bg015"
			case (26) K[0] = "ep01_bg040"
			case (27) K[0] = "ep10_bg013"
			case (28) K[0] = "ep07_bg040"
			case (29) K[0] = "ep07_bg001"
			case (30) K[0] = "ep04_bg007"
		}
		// 背景[左下]
		@b.obj[@OBJ_BG01].@cd[1].create(K[0], @On, 50, 300)
		@b.obj[@OBJ_BG01].@cd[1].layer = -150
		@b.obj[@OBJ_BG01].@cd[1].set_scale(500, 500)
		@b.obj[@OBJ_BG01].@cd[1].x_eve.set(-50, 6000, 0, 0)

		// 背景[右上]
		@b.obj[@OBJ_BG01].@cd[2].create(K[0], @On, 600, 0)
		@b.obj[@OBJ_BG01].@cd[2].layer = -150
		@b.obj[@OBJ_BG01].@cd[2].set_scale(500, 500)
		@b.obj[@OBJ_BG01].@cd[2].x_eve.set(700, 6000, 0, 0)
	}

	// DAYS
	@b.obj[@OBJ_BG01].@cd[3].create(sys_day_days00, @On, 692, 387)
	@b.obj[@OBJ_BG01].@cd[3].layer = 100
	@b.obj[@OBJ_BG01].@cd[3].patno = L[1]

	// [Angel Beats!-1st beat-]
	@b.obj[@OBJ_BG01].@cd[4].create(sys_day_tt00, @On, 534, 427)
	@b.obj[@OBJ_BG01].@cd[4].layer = 100
	@b.obj[@OBJ_BG01].@cd[4].patno = L[1]

	// 死後の世界
	if (L[1] == 0)	{
		K[11] = "sys_day_num01"
	}
	// 生前の世界
	else	{
		K[11] = "sys_day_num02"
	}

	// 日数 X0
	@b.obj[@OBJ_BG01].@cd[5].create_number(K[11], @On, 490, 275+30)
	@b.obj[@OBJ_BG01].@cd[5].set_number_param(1, 1, 0, 1, 0, 11)
	@b.obj[@OBJ_BG01].@cd[5].layer = 100
	@b.obj[@OBJ_BG01].@cd[5].tr = 0
	// 日数 0X
	@b.obj[@OBJ_BG01].@cd[6].create_number(K[11], @On, 490+95, 275+30)
	@b.obj[@OBJ_BG01].@cd[6].set_number_param(1, 1, 0, 1, 0, 11)
	@b.obj[@OBJ_BG01].@cd[6].layer = 100
	@b.obj[@OBJ_BG01].@cd[6].tr = 0

//	system.debug_messagebox_ok(K[11])
	K[11] = math.tostr(L[0])
	if (K[11].cnt == 1)	{
		// 01～09
		@b.obj[@OBJ_BG01].@cd[5].set_number(0)
		@b.obj[@OBJ_BG01].@cd[6].set_number(L[0])
	}
	else	{
		// 10～
		K[12] = K[11].left(1)
		@b.obj[@OBJ_BG01].@cd[5].set_number(K[12].tonum)
		K[12] = K[11].right(1)
		@b.obj[@OBJ_BG01].@cd[6].set_number(K[12].tonum)
	}

	// 死後の世界
	if (L[1] == 0)	{
		@b.obj[@OBJ_BG01].@cd[5].tr_eve.set(255, 1000,  800, 0)
		@b.obj[@OBJ_BG01].@cd[6].tr_eve.set(255, 1000, 1000, 0)
		@b.obj[@OBJ_BG01].@cd[5].y_eve.set(275, 1000,  800, 2)
		@b.obj[@OBJ_BG01].@cd[6].y_eve.set(275, 1000, 1000, 2)
		L[10] = 3
	}
	// 生前の世界
	else	{
		@b.obj[@OBJ_BG01].@cd[5].tr = 255
		@b.obj[@OBJ_BG01].@cd[6].tr = 255
		@b.obj[@OBJ_BG01].@cd[5].y = 275
		@b.obj[@OBJ_BG01].@cd[6].y = 275
		L[10] = 99
	}

	// 表示
	$wipe(L[10])

	L[0] = timewait_key(3500)

	if (L[0] == @On)	{
		// スキップ対策用キャプチャー処理
		@f.obj[@OBJ_BG01].@cd[5].all_eve.end
		@f.obj[@OBJ_BG01].@cd[6].all_eve.end
		disp
	}

	// 日付ごとにセーブ※生前の世界の日付表示では無効に
	if (($Save_point_state == @Off) && (@EsAutoSave == @On) && (L[1] == 0))	{
		capture
		$sys_day_save
		capture_free
		L[20] = @On
	}


	// 使用不可にしていた特定コマンドの機能を使用可にする
	@sys_com_enable

	$fade_dup = @Off
	@fade(bg_kuro, 3)

	// オートセーブしました
	if (L[20] == @On)	{
		L[20] = @Off
		$auto_save_disp
	}

	@timewaitkey(1000)

	// デバッグ
	$_K[20] = math.tostr_zero(@days, 2)
	system.debug_write_log("〓〓〓〓〓" + $_K[20] + "日目" + "〓〓〓〓〓")

return


