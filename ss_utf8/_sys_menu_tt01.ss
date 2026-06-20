/********************************************************
*														*
*				タイトルメニュー（製品版）				*
*														*
*********************************************************/
#z00

#inc_start

	#property	$clear_cnt : int
	#property	$1st_title_bgname : str

	#property	$btn_x : intlist[9]
	#property	$btn_y : intlist[9]

	#property	$btn_name : strlist[9]

	#property	$pt_move_x : intlist[4]
	#property	$pt_move_y : intlist[4]

	#property	$pt_name : str
	#property	$pt_number : int

#inc_end


	// システムコマンドメニューを禁止
	syscom.set_syscom_menu_disable

	// 一時的に早送りを禁止する（Ctrl キーを含む）
	script.set_ctrl_skip_disable

	// タイトルメニュー判定
	@TM_STATE = @On

	// オブジェクトの初期化
	gosub #ObjInit00

	// タイトルニューデータ構築
	gosub #ObjConstruct1

	if (@１巻クリアした == @Off)	{
		@bgm_play(m102)
	}
	else	{
		@bgm_play(m202)
	}

	// Extraからの復帰の場合
	if (@TM_EXTRA == @Off)	{
		// タイトルメニュー表示
		if (@１巻クリアした == @Off)	{
			gosub #SysMenuDisp01
		}
		else	{
			gosub #SysMenuDisp02
		}
	}
	else	{
		gosub #SysMenuDisp03
	}

	// タイトルメニュー実行
	@TM_EXTRA = @Off
	gosub #SysMenuPut

	if (@TM_EXTRA == @On)	{
		goto #z00
	}

	// タイトルメニュー判定
	@TM_STATE = @Off

	// タイトルメニューワイプ
//	gosub #ObjErase

	// 早送りの禁止を解除する（Ctrl キーを含む）
	script.set_ctrl_skip_enable

	// システムコマンドメニューの禁止を解除
	syscom.set_syscom_menu_enable


return


/********************************************************
*オブジェクトの初期化                                   *
*********************************************************/
#ObjInit00

	@b.obj[@ObjSysTMenu00].init
	@b.obj[@ObjSysTMenu00].disp = @On
	@b.obj[@ObjSysTMenu00].@cd.resize(50)

return


/********************************************************
*タイトルニューデータ構築                               *
*********************************************************/
#ObjConstruct1

	// todo とりあえず構築

	// クリア判定
	$clear_cnt = @ユイルートクリアした + @岩沢ルートクリアした + @松下ルートクリアした

	// 光の玉の移動設定
	$pt_move_y[0] = 7000
	$pt_move_y[1] = 11000
	$pt_move_y[2] = 15000
	$pt_move_y[3] = 20000
	$pt_name = sys_tm_ef01

	// 未クリア
	if (@エンディングを見た == @Off)	{
		$1st_title_bgname = sys_tm_1st_bg01
		$btn_x[0] =   0 $btn_y[0] =   0			// Angel Beats!
		$btn_x[1] = 491 $btn_y[1] = 390	+   0	// Operation Start
		$btn_x[2] =   0 $btn_y[2] =   0			// Next Beat
		$btn_x[3] = 491 $btn_y[3] = 390 +  48	// Continue
		$btn_x[4] = 491 $btn_y[4] = 390 +  96	// Load
		$btn_x[5] = 491 $btn_y[5] = 390 + 144	// Config
		$btn_x[7] = 491 $btn_y[7] = 390 + 192	// Exit
		$pt_number = 10
	}
	// バッドを含むエンディングを１つ以上見た
	elseif (@エンディングを見た == @On)	{
		// ０人クリア
		if ($clear_cnt == 0)	{
			$1st_title_bgname = sys_tm_1st_bg01
			$btn_x[0] =   0 $btn_y[0] =   0			// Angel Beats!
			$btn_x[1] = 491 $btn_y[1] = 367	+   0	// Operation Start
			$btn_x[2] =   0 $btn_y[2] =   0			// Next Beat
			$btn_x[3] = 491 $btn_y[3] = 367 +  50	// Continue
			$btn_x[4] = 491 $btn_y[4] = 367 + 100	// Load
			$btn_x[5] = 491 $btn_y[5] = 367 + 150	// Config
			$btn_x[6] = 491 $btn_y[6] = 367 + 200	// Extra
			$btn_x[7] = 491 $btn_y[7] = 367 + 250	// Exit
		}
		// １人クリア
		elseif ($clear_cnt < 3)	{
			$1st_title_bgname = sys_tm_1st_bg02
			$btn_x[0] =   0 $btn_y[0] =   0			// Angel Beats!
			$btn_x[1] = 491 $btn_y[1] = 367 +   0	// Operation Start
			$btn_x[2] =   0 $btn_y[2] =   0			// Next Beat
			$btn_x[3] = 491 $btn_y[3] = 367 +  50	// Continue
			$btn_x[4] = 491 $btn_y[4] = 367 + 100	// Load
			$btn_x[5] = 491 $btn_y[5] = 367 + 150	// Config
			$btn_x[6] = 491 $btn_y[6] = 367 + 200	// Extra
			$btn_x[7] = 491 $btn_y[7] = 367 + 250	// Exit
			$pt_number = 20
		}
		// ３人クリア
		else	{
			$1st_title_bgname = sys_tm_1st_bg03
			$btn_x[0] =   0 $btn_y[0] = -27			// Angel Beats!
			$btn_x[1] = 491 $btn_y[1] = 367 -  50	// Operation Start
			$btn_x[2] = 491 $btn_y[2] = 367 +   0	// Next Beat
			$btn_x[3] = 491 $btn_y[3] = 367 +  50	// Continue
			$btn_x[4] = 491 $btn_y[4] = 367 + 100	// Load
			$btn_x[5] = 491 $btn_y[5] = 367 + 150	// Config
			$btn_x[6] = 491 $btn_y[6] = 367 + 200	// Extra
			$btn_x[7] = 491 $btn_y[7] = 367 + 250	// Exit

			// 光の玉の移動設定
			$pt_move_y[0] = -7000
			$pt_move_y[1] = -11000
			$pt_move_y[2] = -15000
			$pt_move_y[3] = -20000
			$pt_name = sys_tm_ef02
			$pt_number = 60
		}
	}

	// １巻クリア
	if (@１巻クリアした == @On)	{
		$1st_title_bgname = evsp_1401
		$btn_x[0] =    0 $btn_y[0] =   0		// Angel Beats!
		$btn_x[1] =   43 $btn_y[1] = 654		// Operation Start
		$btn_x[2] =  345 $btn_y[2] = 654		// Next Beat
		$btn_x[3] =  541 $btn_y[3] = 654		// Continue
		$btn_x[4] =  724 $btn_y[4] = 654		// Load
		$btn_x[5] =  842 $btn_y[5] = 654		// Config
		$btn_x[6] =  987 $btn_y[6] = 654		// Extra
		$btn_x[7] = 1119 $btn_y[7] = 654		// Exit

		$btn_name[0] = sys_tm_1st_btn11
		$btn_name[1] = sys_tm_1st_btn12
		$btn_name[2] = sys_tm_1st_btn13
		$btn_name[3] = sys_tm_1st_btn14
		$btn_name[4] = sys_tm_1st_btn15
		$btn_name[5] = sys_tm_1st_btn16
		$btn_name[6] = sys_tm_1st_btn17
		L[0] = 1
	}
	else	{
		$btn_name[0] = sys_tm_1st_btn01
		$btn_name[1] = sys_tm_1st_btn02
		$btn_name[2] = sys_tm_1st_btn03
		$btn_name[3] = sys_tm_1st_btn04
		$btn_name[4] = sys_tm_1st_btn05
		$btn_name[5] = sys_tm_1st_btn06
		$btn_name[6] = sys_tm_1st_btn07
		L[0] = 0
	}

	if (@１巻クリアした == @Off)	{

		// 白地
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].create(bg_siro, @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].layer = 100

		// key
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].create(sys_logo01, @On, 0, 0)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].layer = 150

		// 白フェード
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].create(bg_siro, @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].tr = 0
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].layer = 500

		// 背景
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].create($1st_title_bgname, @On, 0, 0)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].set_scale(1300, 1300)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].set_center_rep(640, 360)
	}
	else	{

		// 背景
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].create($1st_title_bgname, @On, 0, 0)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].tr = 0

		// 背景アニメ
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg04].create_movie(sys_tm_1st_bg04, @Off, 0, 0, ready_only = @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg04].layer = -100
	}

	// Angel Beats!
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].create(sys_tm_1st_logo01, @On, $btn_x[0], $btn_y[0])
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].layer = 300
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].patno = L[0]

	// key/VisualArt's
	if (@１巻クリアした == @Off)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].create(sys_tm_1st_logo02, @On, 0, 0)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr = 0
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].layer = 100
	}

	// Angel Beats!
	if (@１巻クリアした == @On)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].layer = 50
//		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].create(sys_tm_1st_btn10, @On, 0, 0)
//		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr = 0
//		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].layer = 50
	}

	// Operation Start
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].create($btn_name[0], @On, $btn_x[1], $btn_y[1])
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].layer = 210
	// Next beat
	if ($clear_cnt >= 3)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].create($btn_name[1], @On, $btn_x[2], $btn_y[2])
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr = 0
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].layer = 210
	}
	// Continue
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].create($btn_name[2], @On, $btn_x[3], $btn_y[3])
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].layer = 210
	if (syscom.get_save_exist(1020) == @Off)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].patno = @FORBID
	}
	// Load
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].create($btn_name[3], @On, $btn_x[4], $btn_y[4])
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].layer = 210
	if ((syscom.get_save_new_no == -1) && (syscom.get_quick_save_new_no == -1))	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = @FORBID
	}
	// Config
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].create($btn_name[4], @On, $btn_x[5], $btn_y[5])
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].layer = 210
	// Extra
	if (@エンディングを見た == @On)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].create($btn_name[5], @On, $btn_x[6], $btn_y[6])
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr = 0
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].layer = 210
	}
	// Exit
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].create($btn_name[6], @On, $btn_x[7], $btn_y[7])
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].layer = 210

	// １～２人クリア：光の玉↓
	// ３人　　クリア：光の玉↑

	if (@１巻クリアした == @Off)	{

		// Particle01
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].create_weather($pt_name, @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].layer = 200
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].blend = 1
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].set_weather_param_type_A(
			cnt = 2,
			move_time_x = 0,
			move_time_y = $pt_move_y[0],
			pat_mode = 0,
			pat_no_1 = 0,
			sin_time_x = 2000,
			sin_power_x = 0
			)
		// Particle02
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].create_weather($pt_name, @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].layer = 200
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].blend = 1
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].set_weather_param_type_A(
			cnt = 4,
			move_time_x = 0,
			move_time_y = $pt_move_y[1],
			pat_mode = 0,
			pat_no_1 = 0,
			sin_time_x = 2000,
			sin_power_x = 0,
			scale_x = 700,
			scale_y = 700
			)

		// Particle03
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].create_weather($pt_name, @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].layer = 200
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].blend = 1
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].set_weather_param_type_A(
			cnt = 10,
			move_time_x = 0,
			move_time_y = $pt_move_y[2],
			pat_mode = 0,
			pat_no_1 = 0,
			sin_time_x = 3000,
			sin_power_x = 0,
			scale_x = 500,
			scale_y = 500
			)

		// Particle04
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].create_weather($pt_name, @On)
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].layer = 200
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].blend = 1
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].set_weather_param_type_A(
			cnt = $pt_number,
			move_time_x = 0,
			move_time_y = $pt_move_y[3],
			pat_mode = 0,
			pat_no_1 = 0,
			sin_time_x = 4000,
			sin_power_x = 0,
			scale_x = 200,
			scale_y = 200
			)
	}

	disp



return


/********************************************************
*タイトルメニュー表示（１巻未クリア）                   *
*********************************************************/
#SysMenuDisp01

	counter[0].start

	wipe(0, 3000, key_skip = 1)

	L[0] = counter[0].wait_key(8000)
	if (L[0] == @On)	{
		$menu_build
		return
	}

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].tr_eve.set(255, 3000, 0, 0)

	L[0] = counter[0].wait_key(11500)
	if (L[0] == @On)	{
		$menu_build
		return
	}

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].tr_eve.set(0, 3000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].scale_x_eve.set(1000, 11000, 0, 2)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].scale_y_eve.set(1000, 11000, 0, 2)

	L[0] = counter[0].wait_key(23950)
	if (L[0] == @On)	{
		$menu_build
		return
	}

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].tr_eve.set(255, 500,   0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr_eve.set(255, 500,   0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].layer = 400

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr_eve.set(255, 500,   0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr_eve.set(255, 500,  50, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr_eve.set(255, 500, 100, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr_eve.set(255, 500, 150, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].tr_eve.set(255, 500, 200, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr_eve.set(255, 500, 250, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].tr_eve.set(255, 500, 300, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].layer = 400
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].layer = 400

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].tr_eve.wait





return


/********************************************************
*タイトルメニュー表示（１巻クリア）                     *
*********************************************************/
#SysMenuDisp02

	counter[0].start

	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg04].disp = @On
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg04].resume_movie

	wipe(0, 0)

	counter[0].wait(2000)

	L[0] = counter[0].wait_key(15000)
	if (L[0] == @On)	{
		$menu_build
		return
	}

//	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].tr_eve.set(0, 2000, 0, 0)
//	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].tr_eve.set(0, 2000, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].tr_eve.set(255,   500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].tr_eve.set(255,  1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr_eve.set(255,  1000, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].tr_eve.set(255, 1000, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenubtn07].tr_eve.wait

return


/********************************************************
*タイトルメニュー表示（Extraから復帰）                  *
*********************************************************/
#SysMenuDisp03

	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].init
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].init
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg04].init
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].init


	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].set_scale(1000, 1000)

	if (@１巻クリアした == @On)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].tr_eve.set(255,  500, 0, 0)
	}

	wipe(0, 2000, key_skip = 1)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].tr_eve.set(255,  500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].tr_eve.set(255,  500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr_eve.set(255,  500, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr_eve.set(255, 500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr_eve.set(255, 500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr_eve.set(255, 500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr_eve.set(255, 500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].tr_eve.set(255, 500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr_eve.set(255, 500, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].tr_eve.set(255, 500, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenubtn07].tr_eve.wait

return


/********************************************************
*タイトルメニュー実行                                   *
*********************************************************/
#SysMenuPut

	// 念の為再ビルド
	$menu_build

	#MenuSel00

	// マウス初期化
	//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
	@MouseBtnInit
	while (1)	{ // 0

		// デバック
//		@ex.f.obj[@ObjSysSL03].@cd[149].set_string(math.tostr(@SLDataState))

		@MSCHK_PREV = @MSCHK
		@MSCHK = @MSBTN_NONE
		@MS_STATE_PREV = @MS_STATE

		// 初期化処理（キーが放されていたら状態を初期化する）
		if (input.decide.is_up == @On)	{
			@MS_STATE = @MSBTN_INIT
			@S_CTL_BAR_ACTIVE      = @Off
			@S_CTL_BAR_CTLACTIVE   = @Off
			@S_CTL_BAR_CTLPOS_PREV = @Init
		}

		@if_(@Off, @Off,                                                                   0, @ObjSysTMenu00, _ObjSysTMenuBtn01)	// Operation Start
		@if_(@Off, @Off,                                                                   1, @ObjSysTMenu00, _ObjSysTMenuBtn02)	// Next Beat
		@if_(@On,  (syscom.get_save_exist(1020) == @On),                                   2, @ObjSysTMenu00, _ObjSysTMenuBtn03)	// Continue
		@if_(@On,  (syscom.get_save_new_no != -1) || (syscom.get_quick_save_new_no != -1), 3, @ObjSysTMenu00, _ObjSysTMenuBtn04)	// Load
		@if_(@Off, @Off,                                                                   4, @ObjSysTMenu00, _ObjSysTMenuBtn05)	// Config
		@if_(@Off, @Off,                                                                   5, @ObjSysTMenu00, _ObjSysTMenuBtn06)	// Extra
		@if_(@Off, @Off,                                                                   6, @ObjSysTMenu00, _ObjSysTMenuBtn07)	// Exit

		// マウスボタン入力判定
		$MsBtnInputDecide

		// 状態セット
		@MsStateSet(0, 10)

		// マウスボタン状態
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].patno = $obj_btn_state[0]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].patno = $obj_btn_state[1]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].patno = $obj_btn_state[2]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = $obj_btn_state[3]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].patno = $obj_btn_state[4]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].patno = $obj_btn_state[5]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].patno = $obj_btn_state[6]
		if (syscom.get_save_exist(1020) == @Off)	{
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].patno = @FORBID
		}
		if ((syscom.get_save_new_no == -1) && (syscom.get_quick_save_new_no == -1))	{
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = @FORBID
		}

		// todo 仮処理
		if (@１巻クリアした == @Off)	{
			for (L[0] = 0, L[0] < 8, L[0] += 1)	{
				if ($obj_btn_state[L[0]] > 0)	{
					@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn00].create(sys_tm_1st_btn00, @On, 0, $btn_y[1+L[0]]-3)
					@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn00].layer = 10
					break
				}
				else	{
					@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn00].init
				}
			}
		}

		// 状態表示
		input.next
		disp

		// 結果
		if (@MSBTN_RESULT == @DECIDE)	{
			@MSBTN_RESULT = @INIT
			switch (@MSCHK)	{
				case (0)
					// Operation Start
					@se_play(004)
					@bgm_stop(3000)
					@fade(bg_siro, 5)
					@timewaitkey(2000)
					break
				case (1)
					// Next Beat
					@se_play(004)
					@bgm_stop(3000)
					@fade(bg_siro, 5)
					@force_fade(bg_kuro, 5)
					@timewaitkey(2000)
					$next_beat = @On
					break
				case (2)
					// Continue
					@se_play(003)
					@bgm_stop(3000)
					@fade(bg_kuro, 4)
					@timewaitkey(1000)
					@TM_STATE = @Off
					syscom.end_load(@Off, @Off, @Off)
				case (3)
					// Load
					@se_play(001)
					excall.alloc
					@ex.F[$sys_lo_mode] = @On
					farcall(_sys_menu_sl01)
					goto #MenuSel00
				case (4)
					// Config
					@se_play(001)
					excall.alloc
					@ex.F[$sys_cf_mode] = @On
					farcall(_sys_menu_cf01)
					goto #MenuSel00
				case (5)
					// Extra
					@se_play(001)
					$TmFade(bg_kuro)
					@TM_EXTRA = @On
					farcall(_extra_mode)
					return
				case (6)
					// Exit
					@se_play(003)
					@bgm_stop(3000)
					@fade(bg_kuro, 4)
					@timewaitkey(1000)
					owari
			}
		}
	}

return


// ----------------------------------------------------------------------------------------
// タイトルメニュー演出終了後の構築
// ----------------------------------------------------------------------------------------
command $menu_build
{

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg04].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].init

//	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].tr = 0
//	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].all_eve.end
//	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade01].tr = 0
//	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].tr = 0

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr = 255

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].all_eve.end
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].set_scale(1000, 1000)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn07].tr = 255



}


// ----------------------------------------------------------------------------------------
// フェード
// ----------------------------------------------------------------------------------------
command $TmFade(property $color : str)
{

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].create($color, @On)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].layer = 1000
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].tr = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].tr_eve.set(255, 1000, 0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].tr_eve.wait_key
}


// ----------------------------------------------------------------------------------------
// マウスボタン入力判定
// ----------------------------------------------------------------------------------------
command $MsBtnInputDecide
{
	// マウスボタン入力判定
	if (input.decide.is_up == @On)	{
		if (@MSCHK != @MSBTN_NONE){
			if (@MSCHK != @MSCHK_PREV)	{
				@se_play(000)
			}
			@MSBTN_STATE = @MSBTN_TOUCH
		}
		else	{
			@MSBTN_STATE = @MSBTN_NORMAL
		}
	}
	elseif (input.decide.is_down == @On)	{
		if (@MS_STATE_PREV != @MSBTN_INIT)	{
			if ((@MSCHK == @MS_STATE_PREV) && (@MSCHK != @MSBTN_NONE))	{
				if (@MSCHK != @MSCHK_PREV)	{
					@se_play(000)
				}
				@MSBTN_STATE = @MSBTN_PUSH
			}
			else	{
				@MSBTN_STATE = @MSBTN_NORMAL
			}
		}
		else	{
			@MSBTN_STATE = @MSBTN_PUSH
			@MS_STATE = @MSCHK
		}
	}
	if (input.cancel.on_down_up == @On)	{
		input.clear
//		$break_switch = @On
	}
	elseif (input.decide.on_down_up == @On)	{
		if (@MS_STATE_PREV != @MSBTN_INIT){
			if ((@MSCHK == @MS_STATE_PREV) && (@MSCHK != @MSBTN_NONE))	{
				@MSBTN_STATE = @MSBTN_TOUCH
				@MSBTN_RESULT = @DECIDE
			}
			else{
				@MSBTN_STATE = @MSBTN_NORMAL
			}
			@MS_STATE = @MSBTN_INIT
		}
		input.clear
	}
}
