/********************************************************
*														*
*				タイトルメニュー（体験版）				*
*														*
*********************************************************/
#z00


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

	// タイトルメニュー表示
	gosub #SysMenuDisp

	// タイトルメニュー実行
	gosub #SysMenuPut

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

	// 白
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].create(bg_siro, @On)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].layer = 100
	// key
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].create(sys_logo01, @On, 0, 0)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].layer = 100
	// 空
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].create(sys_tm_bg01, @Off)
	// キャラクター
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].create(sys_tm_bg02, @Off)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].layer = 100
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02w].create_movie(sys_tm_bg02, @Off, ready_only = @On)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02w].layer = 100
	// Angel Beats! Trial
//	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].create(sys_logo02, @On, 39, 60)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].create(sys_logo02, @On, 0, 0)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].layer = 100

	// todo 修正
	L[10] = -300

	// Operation Start
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].create(sys_tm_btn01, @On, 0+L[10], 258)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].layer = 100
	// Continue
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].create(sys_tm_btn02, @On, 0+L[10], 335)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].layer = 100
	if (syscom.get_save_exist(1020) == @Off)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].patno = @FORBID
	}
	// Load
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].create(sys_tm_btn03, @On, 0+L[10], 408)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].layer = 100
	if (syscom.get_save_new_no == -1)	{
		@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].patno = @FORBID
	}
	// Config
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].create(sys_tm_btn04, @On, 0+L[10], 481)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].layer = 100
	// Extra
//	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].create(sys_tm_btn06, @On, 0, 0)
//	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].tr = 0
//	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].layer = 100
	// Exit
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].create(sys_tm_btn06, @On, 0+L[10], 556)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr = 0
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].layer = 100

	// Particle01
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].create_weather(sys_tm_ef01, @On)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].blend = 1
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf04].set_weather_param_type_A(
		cnt = 2,
		move_time_x = 0,
		move_time_y = -7000,
		pat_mode = 0,
		pat_no_1 = 0,
		sin_time_x = 2000,
		sin_power_x = 0
		)
	// Particle02
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].create_weather(sys_tm_ef01, @On)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].blend = 1
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf03].set_weather_param_type_A(
		cnt = 4,
		move_time_x = 0,
		move_time_y = -11000,
		pat_mode = 0,
		pat_no_1 = 0,
		sin_time_x = 2000,
		sin_power_x = 0,
		scale_x = 700,
		scale_y = 700
		)

	// Particle03
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].create_weather(sys_tm_ef01, @On)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].blend = 1
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf02].set_weather_param_type_A(
		cnt = 10,
		move_time_x = 0,
		move_time_y = -15000,
		pat_mode = 0,
		pat_no_1 = 0,
		sin_time_x = 3000,
		sin_power_x = 0,
		scale_x = 500,
		scale_y = 500
		)

	// Particle04
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].create_weather(sys_tm_ef01, @On)
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].blend = 1
	@b.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuEf01].set_weather_param_type_A(
		cnt = 30,
		move_time_x = 0,
		move_time_y = -20000,
		pat_mode = 0,
		pat_no_1 = 0,
		sin_time_x = 4000,
		sin_power_x = 0,
		scale_x = 200,
		scale_y = 200
		)


	disp

return


/********************************************************
*タイトルメニュー表示                                   *
*********************************************************/
#SysMenuDisp

	@bgm_play(m102)
	counter[0].start

	wipe(0, 2000, key_skip = 1)		// todo key_skip = 0にすること！！！

	L[0] = counter[0].wait_key(4000)
	if (L[0] == @On)	{
		$menu_build
		return
	}

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuFade00].tr_eve.set(0, 2000, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].disp = @On
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].y_eve.set(-630, 19000, 0, 2)

	L[0] = counter[0].wait_key(10000)
	if (L[0] == @On)	{
		$menu_build
		return
	}

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuSysBg00].tr_eve.set(0, 2000, 0, 0)

	L[0] = counter[0].wait_key(23950)
	if (L[0] == @On)	{
		$menu_build
		return
	}

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02w].disp = @On
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02w].resume_movie
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02w].wait_movie

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].disp = @On

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr_eve.set(255,  500, 0, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr_eve.set(255, 500,   0, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr_eve.set(255, 500,  50, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr_eve.set(255, 500, 100, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr_eve.set(255, 500, 150, 0)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr_eve.set(255, 500, 200, 0)

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].x_eve.set(0, 500,   0, 2)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].x_eve.set(0, 500,  50, 2)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].x_eve.set(0, 500, 100, 2)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].x_eve.set(0, 500, 150, 2)
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].x_eve.set(0, 500, 200, 2)


	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg06].tr_eve.wait


return


/********************************************************
*タイトルメニュー実行                                   *
*********************************************************/
#SysMenuPut

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

		@if_(@Off, @Off,                                 0, @ObjSysTMenu00, _ObjSysTMenuBtn01)
		@if_(@On,  (syscom.get_save_exist(1020) == @On), 1, @ObjSysTMenu00, _ObjSysTMenuBtn02)
		@if_(@On,  (syscom.get_save_new_no != -1),       2, @ObjSysTMenu00, _ObjSysTMenuBtn03)
		@if_(@Off, @Off,                                 3, @ObjSysTMenu00, _ObjSysTMenuBtn04)
//		@if_(@Off, @Off,                                 4, @ObjSysTMenu00, _ObjSysTMenuBtn05)
		@if_(@Off, @Off,                                 5, @ObjSysTMenu00, _ObjSysTMenuBtn06)

		// マウスボタン入力判定
		$MsBtnInputDecide

		// 状態セット
		@MsStateSet(0, 10)

		// マウスボタン状態
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].patno = $obj_btn_state[0]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].patno = $obj_btn_state[1]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].patno = $obj_btn_state[2]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = $obj_btn_state[3]
//		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].patno = $obj_btn_state[4]
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].patno = $obj_btn_state[5]
		if (syscom.get_save_exist(1020) == @Off)	{
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].patno = @FORBID
		}
		if ((syscom.get_save_new_no == -1) && (syscom.get_quick_save_new_no == -1))	{
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].patno = @FORBID
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
					@fade(bg_siro, 4)
					@timewaitkey(1000)
					break
				case (1)
					// Continue
					@se_play(003)
					@bgm_stop(3000)
					@fade(bg_kuro, 4)
					@timewaitkey(1000)
					@TM_STATE = @Off
					syscom.end_load(@Off, @Off, @Off)
				case (2)
					// Load
					@se_play(001)
					excall.alloc
					@ex.F[$sys_lo_mode] = @On
					farcall(_sys_menu_sl01)
					goto #MenuSel00
				case (3)
					// Config
					@se_play(001)
					excall.alloc
					@ex.F[$sys_cf_mode] = @On
					farcall(_sys_menu_cf01)
					goto #MenuSel00
				case (4)
					// Extra
				case (5)
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

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02w].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg02].disp = @On

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].y_eve.end
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].y = -630
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg01].disp = @On

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBg03].tr = 255

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].tr = 255
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].tr = 255

	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn01].x = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn02].x = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn03].x = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].x = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn06].x = 0

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
