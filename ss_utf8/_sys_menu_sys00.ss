/********************************************************
*														*
*					システムメニュー					*
*														*
*********************************************************/
#z00

// @MRActionState	0…クイックメニュー、1…ウィンドウ消去、2…セーブ画面、3…ロード画面、4…コンフィグ画面

// タイトルメニュー中は禁止
if (@TM_STATE != 0)	{
	return
}

// ウィンドウ消去以外はＳＥ再生
if (@MRActionState != 1)	{
	@se_play(001)
}

// 右クリックをウィンドウ消去に割り当てている場合、マップ画面ではクイックメニューを表示するようにする
if ((@MRActionState == 1) && (@マップ選択 == 2))	{	// if ((@MRActionState == 1) && (@マップ選択 == @On))	{	■2015.07.07修正
	goto #z01
}

// セーブが禁止されていない場合
if (syscom.get_save_enable_flag() == @On)	{
	if (@MRActionState == 2)	{
		// システムコール準備
		$excall_ready
		goto #z02
	}
}
// ロードが禁止されていない場合
if (syscom.get_load_enable_flag() == @On)	{
	if (@MRActionState == 3)	{
		// システムコール準備
		$excall_ready
		goto #z02
	}
}
// コンフィグ表示
if (@MRActionState == 4)	{
	// システムコール準備
	$excall_ready
	goto #z02
}
// メッセージウィンドウ消去
elseif (@MRActionState == 1)	{
	syscom.set_hide_mwnd_onoff_flag(@On)
	return
}

// ---------------------------------------------
// システムメニュー
// ---------------------------------------------
#z01

// システムコール準備
$excall_ready


// システムメニュー状態取得
gosub #SysMenuState

// オブジェクトの初期化
gosub #ObjInit00

// システムメニューデータ構築
gosub #ObjConstruct

// システムメニュー表示
gosub #ObjDisp


//
// システムメニュー実行
//
gosub #SysMenuPut


// システムメニュー非表示
gosub #ObjErase

#z02

    if (@MRActionState == 2) {@ex.F[$sys_sa_mode] = @On}	// セーブ画面
elseif (@MRActionState == 3) {@ex.F[$sys_lo_mode] = @On}	// ロード画面
elseif (@MRActionState == 4) {@ex.F[$sys_cf_mode] = @On}	// コンフィグ画面

// メニュー切り替え判定
    if (@ex.F[$sys_sa_mode] == @On)	{jump(_sys_menu_sl01, 00)}
elseif (@ex.F[$sys_lo_mode] == @On)	{jump(_sys_menu_sl01, 00)}
elseif (@ex.F[$sys_cf_mode] == @On)	{jump(_sys_menu_cf01, 01)}




// システムコール解放
$excall_free

return


/********************************************************
*システムメニュー状態取得                               *
*********************************************************/
#SysMenuState

	// モード設定
	$sys_mode_prev = $sys_mode
	$sys_mode = $sys_sm_mode

	// 既読スキップＯＦＦ
	syscom.set_read_skip_onoff_flag(@Off)

	// システムメニュー状態取得
	@GetSysMenuState(@SkipState, @ASkipState, @AutoState, @WindowState, @SelState, @SaveState, @LoadState)

	// オートモード状態取得
	@GetSysAMState(@AmCheckState,@TTimeState,@STimeState)

	$btn_state_switch[0] = @StateOff
	$btn_state_switch[1] = @StateOff
	$btn_state_switch[2] = @StateOff
	$btn_state_switch[3] = @StateOff
	$btn_state_switch[4] = @StateOff
	$btn_state_switch[5] = @StateOff
	$btn_state_switch[6] = @StateOff

	// 確認ダイアログ
	@CdStateReady = @Off

	// スキップフラグ
	@SkipStartReady = @Off

	@HelpDispState = -1
	@HelpDispStatePrev = -1

return


/********************************************************
*オブジェクトの初期化                                   *
*********************************************************/
#ObjInit00

	@ex.f.obj[@ObjSysMenu00].init
	@ex.f.obj[@ObjSysMenu00].layer = 1000
	@ex.f.obj[@ObjSysMenu00].disp = @On
	@ex.f.obj[@ObjSysMenu00].@cd.resize(50)

	@ex.f.obj[@ObjSysMenu01].init
	@ex.f.obj[@ObjSysMenu01].layer = 1100
	@ex.f.obj[@ObjSysMenu01].disp = @On
	@ex.f.obj[@ObjSysMenu01].@cd.resize(5)

	@ex.f.obj[@ObjSysMenu01].f.resize(6)

return


/********************************************************
*システムメニューデータ構築                             *
*********************************************************/
#ObjConstruct

	if (@AutoStartReady == @On)	{
		$btn_state_switch[2] = @StateOn
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].patno = @StateOn
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].patno = @StateOn
	}

	// システムメニューデータ
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuBg01       ].create(sys_qm_bg00,  @On)		// システムメニュー背景
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01     ].create(sys_qm_btn01, @On)		// ＳＫＩＰボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01      ].create(sys_qm_btn02, @On)		// ＢＡＣＫボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].create(sys_qm_btn03, @On)		// ＡＵＴＯボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01   ].create(sys_qm_btn04, @On)		// ＣＯＮＦＩＧボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01     ].create(sys_qm_btn05, @On)		// ＬＯＡＤボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].create(sys_qm_btn06, @On)		// ＳＡＶＥボタン

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02     ].create(sys_qm_btn01b, @Off)	// ＳＫＩＰボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02      ].create(sys_qm_btn02b, @Off)	// ＢＡＣＫボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].create(sys_qm_btn03b, @Off)	// ＡＵＴＯボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02   ].create(sys_qm_btn04b, @Off)	// ＣＯＮＦＩＧボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02     ].create(sys_qm_btn05b, @Off)	// ＬＯＡＤボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02     ].create(sys_qm_btn06b, @Off)	// ＳＡＶＥボタン

	// ＡＵＴＯボタン状態
	if (syscom.get_auto_mode_onoff_flag == @On)	{
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].patno += @StateOn
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].patno += @StateOn
	}
	// ＳＡＶＥボタン状態
	if (check_savepoint == @Off)	{
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].patno = 4
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].patno = 4
	}

	// 選択範囲用
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip_selbg     ].create(sys_qm_selbtn00, @On)	// ＳＫＩＰボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel_selbg      ].create(sys_qm_selbtn00, @On)	// ＢＡＣＫボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck_selbg].create(sys_qm_selbtn00, @On)	// ＡＵＴＯボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig_selbg   ].create(sys_qm_selbtn00, @On)	// ＣＯＮＦＩＧボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad_selbg     ].create(sys_qm_selbtn00, @On)	// ＬＯＡＤボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave_selbg     ].create(sys_qm_selbtn00, @On)	// ＳＡＶＥボタン
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip_selbg     ].tr = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel_selbg      ].tr = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck_selbg].tr = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig_selbg   ].tr = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad_selbg     ].tr = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave_selbg     ].tr = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip_selbg     ].Patno = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel_selbg      ].Patno = 1
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck_selbg].Patno = 2
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig_selbg   ].Patno = 3
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad_selbg     ].Patno = 4
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave_selbg     ].Patno = 5

	// スキップ状態
	if (@SkipState == @Off)	{
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01].patno = @Forbid
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02].patno = @Forbid
	}

	// 選択肢状態
	if ((@SelState == @Off) || (@シーン回想中 == @On))	{
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01].patno = @Forbid
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02].patno = @Forbid
	}

	// 回想中
	if (@シーン回想中 == @On)	{
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].patno = @Forbid
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].patno = @Forbid
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01].patno = @Forbid
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02].patno = @Forbid
	}

//	@ex.f.obj[@ObjSysMenu00].tr = 0

return


/********************************************************
*システムメニュー表示                                   *
*********************************************************/
#ObjDisp

	//
	// ※メニューサークルの矩形が(250, 258)なので、それに収まるように処理
	//

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 0 L[22] = 50 L[23] = 100 L[24] = 150 L[25] = 200 L[26] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0     L[21] = 0 L[22] =  0 L[23] =   0 L[24] =   0 L[25] =   0 L[26] =   0
	}

	$_L[0] = @Init
	$_L[1] = @Init

	// マウスのＸ座標を取得
	if ((@MX > 150) && (@MX < 1120))	{
		$_L[0] = @MX
	}
	elseif (@MX <= 150)	{
		$_L[0] = 150
	}
	elseif (@MX >= 1120)	{
		$_L[0] = 1120
	}
	// マウスのＹ座標を取得
	if (@MY > 150 && @MY < 570)	{
		$_L[1] = @MY
	}
	elseif (@MY <= 150)	{
		$_L[1] = 150
	}
	elseif (@MY >= 570)	{
		$_L[1] = 570
	}

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01     ].set_pos( -49+$_L[0], -129+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01      ].set_pos(  30+$_L[0],  -84+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].set_pos(  30+$_L[0],    4+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01   ].set_pos( -49+$_L[0],   49+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01     ].set_pos(-127+$_L[0],    4+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].set_pos(-127+$_L[0],  -84+$_L[1])

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02     ].set_pos( -49+$_L[0], -129+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02      ].set_pos(  30+$_L[0],  -84+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].set_pos(  30+$_L[0],    4+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02   ].set_pos( -49+$_L[0],   49+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02     ].set_pos(-127+$_L[0],    4+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02     ].set_pos(-127+$_L[0],  -84+$_L[1])

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip_selbg     ].set_pos( -49+$_L[0], -129+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel_selbg      ].set_pos(  30+$_L[0],  -84+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck_selbg].set_pos(  30+$_L[0],    4+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig_selbg   ].set_pos( -49+$_L[0],   49+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad_selbg     ].set_pos(-127+$_L[0],    4+$_L[1])
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave_selbg     ].set_pos(-127+$_L[0],  -84+$_L[1])

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuBg01].tr = 0

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01     ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01      ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01   ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01     ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].tr = 0

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02     ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02      ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02   ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02     ].tr = 0
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02     ].tr = 0


	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuBg01].tr_eve.set(255, L[20], L[21], 2)

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01     ].tr_eve.set(255, L[20], L[21], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01      ].tr_eve.set(255, L[20], L[22], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].tr_eve.set(255, L[20], L[23], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01   ].tr_eve.set(255, L[20], L[24], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01     ].tr_eve.set(255, L[20], L[25], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].tr_eve.set(255, L[20], L[26], 2)

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02     ].tr_eve.set(255, L[20], L[21], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02      ].tr_eve.set(255, L[20], L[22], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].tr_eve.set(255, L[20], L[23], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02   ].tr_eve.set(255, L[20], L[24], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02     ].tr_eve.set(255, L[20], L[25], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02     ].tr_eve.set(255, L[20], L[26], 2)

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].tr_eve.wait



return


/********************************************************
*システムメニュー非表示                                 *
*********************************************************/
#ObjErase

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250    L[21] = 0 L[22] = 50 L[23] = 100 L[24] = 150 L[25] = 200 L[26] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0      L[21] = 0 L[22] =  0 L[23] =   0 L[24] =   0 L[25] =   0 L[26] =   0
	}

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01     ].tr_eve.set(0, L[20], L[21], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01      ].tr_eve.set(0, L[20], L[21], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].tr_eve.set(0, L[20], L[22], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01   ].tr_eve.set(0, L[20], L[23], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01     ].tr_eve.set(0, L[20], L[24], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].tr_eve.set(0, L[20], L[25], 2)

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02     ].tr_eve.set(0, L[20], L[21], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02      ].tr_eve.set(0, L[20], L[21], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].tr_eve.set(0, L[20], L[22], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02   ].tr_eve.set(0, L[20], L[23], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02     ].tr_eve.set(0, L[20], L[24], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02     ].tr_eve.set(0, L[20], L[25], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuBg0102     ].tr_eve.set(0, L[20], L[26], 2)

	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuBg01].tr_eve.set(0, L[20], L[26], 2)
	@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuBg01].tr_eve.wait


	// モード初期化
	$sys_mode = $no_mode

	// 既読スキップＯＮ
	if ($btn_state_switch[0] == @StateOn)	{
		syscom.set_read_skip_onoff_flag(@On)
	}
	// 既読フラグＯＦＦ
	@SkipStartReady = @Off
	$btn_state_switch[0]  = @Off

	// オートモードＯＮ
	if ($btn_state_switch[2] == @StateOn)	{
		syscom.set_auto_mode_onoff_flag(@On)
	}
	else	{
		syscom.set_auto_mode_onoff_flag(@Off)
	}

	// システム音声消去
//	@se_stop


return


/********************************************************
*システムメニュー実行                                   *
*********************************************************/
#SysMenuPut

	#MenuSel00

	// マウス初期化
	//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
	@MouseBtnInit
	while (1)	{ // 0

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

		// マウスカーソル判定
		@exif_Pixel_cut_(@On,   @SkipState  == @On,            0, @ObjSysMenu00, _ObjSysMenuSkip_selbg,      1, 0, 0, 0)	// ＳＫＩＰ
		@exif_Pixel_cut_(@On,   @SelState   == @On,            1, @ObjSysMenu00, _ObjSysMenuSel_selbg,       0, 1, 0, 1)	// ＢＡＣＫ
		@exif_Pixel_cut_(@On,   @AutoState  == @On,            2, @ObjSysMenu00, _ObjSysMenuAutoCheck_selbg, 0, 0, 1, 2)	// ＡＵＴＯ
		@exif_Pixel_cut_(@Off,  @Off,                          3, @ObjSysMenu00, _ObjSysMenuConfig_selbg,    2, 0, 0, 3)	// ＣＯＮＦＩＧ
		@exif_Pixel_cut_(@Off,  @Off,                          4, @ObjSysMenu00, _ObjSysMenuLoad_selbg,      0, 2, 0, 4)	// ＬＯＡＤ
		@exif_Pixel_cut_(@On,  (check_savepoint == @On),       5, @ObjSysMenu00, _ObjSysMenuSave_selbg,      0, 0, 2, 5)	// ＳＡＶＥ

		// マウスボタン入力判定
		$MsBtnInputDecide
		if ($break_switch == @On)	{
			$break_switch = @Off
			break
		}

		// 状態セット
		@MsStateSet(0, 5)

		// マウスボタン状態
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01     ].patno = $obj_btn_state[0]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01      ].patno = $obj_btn_state[1]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].patno = $obj_btn_state[2]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01   ].patno = $obj_btn_state[3]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01     ].patno = $obj_btn_state[4]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01     ].patno = $obj_btn_state[5]

		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02     ].patno = $obj_btn_state[0]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02      ].patno = $obj_btn_state[1]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].patno = $obj_btn_state[2]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02   ].patno = $obj_btn_state[3]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02     ].patno = $obj_btn_state[4]
		@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02     ].patno = $obj_btn_state[5]


		// ＳＫＩＰボタン状態
		if ($btn_state_switch[0] == @StateOn)	{
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01].patno += @StateOn
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02].patno += @StateOn
		}
		// ＡＵＴＯボタン状態
		if (($btn_state_switch[2] == @StateOn) || (@AutoStartReady == @On))	{
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].patno += @StateOn
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].patno += @StateOn
		}
		// ＳＡＶＥボタン状態※セーブポイントが立っていない場合
		if (check_savepoint == @Off)	{
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].patno = 4
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].patno = 4
		}

		// 使用禁止判定
		if (@SkipState == @Off) {
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02].patno = @Forbid
		}
		if (@AutoState == @Off) {
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].patno = @Forbid
		}
		if (@SelState  == @Off) {
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02].patno = @Forbid
		}

		// 回想中
		if (@シーン回想中 == @On)	{
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01].patno = @Forbid
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02].patno = @Forbid
		}

		//
		// ボタンアニメ処理
		//

		// ＳＫＩＰ
		if ($obj_btn_state[0] > 0)	{
			if (@ex.f.obj[@ObjSysMenu01].f[0] == @Off)	{
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01].frame_action.start(-1, "$Menu_btn_disp", 1, 0, 1)
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02].frame_action.start(-1, "$Menu_btn_disp", 0, 1, 0)
				@ex.f.obj[@ObjSysMenu01].f[0] = @On
			}
		}
		else	{
			@ex.f.obj[@ObjSysMenu01].f[0] = @Off
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip01].disp = @On
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSkip02].disp = @Off
		}
		// ＢＡＣＫ
		if ($obj_btn_state[1] > 0)	{
			if (@ex.f.obj[@ObjSysMenu01].f[1] == @Off)	{
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01].frame_action.start(-1, "$Menu_btn_disp", 1, 0, 1)
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02].frame_action.start(-1, "$Menu_btn_disp", 0, 1, 0)
				@ex.f.obj[@ObjSysMenu01].f[1] = @On
			}
		}
		else	{
			@ex.f.obj[@ObjSysMenu01].f[1] = @Off
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel01].disp = @On
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSel02].disp = @Off
		}
		// ＡＵＴＯ
		if ($obj_btn_state[2] > 0 || $obj_btn_state[2] >= @StateOn)	{
			if (@ex.f.obj[@ObjSysMenu01].f[2] == @Off)	{
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].frame_action.start(-1, "$Menu_btn_disp", 1, 0, 1)
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].frame_action.start(-1, "$Menu_btn_disp", 0, 1, 0)
				@ex.f.obj[@ObjSysMenu01].f[2] = @On
			}
		}
		else	{
			@ex.f.obj[@ObjSysMenu01].f[2] = @Off
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck01].disp = @On
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuAutoCheck02].disp = @Off
		}
		// ＣＯＮＦＩＧ
		if ($obj_btn_state[3] > 0)	{
			if (@ex.f.obj[@ObjSysMenu01].f[3] == @Off)	{
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01].frame_action.start(-1, "$Menu_btn_disp", 1, 0, 1)
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02].frame_action.start(-1, "$Menu_btn_disp", 0, 1, 0)
				@ex.f.obj[@ObjSysMenu01].f[3] = @On
			}
		}
		else	{
			@ex.f.obj[@ObjSysMenu01].f[3] = @Off
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig01].disp = @On
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuConfig02].disp = @Off
		}
		// ＬＯＡＤ
		if ($obj_btn_state[4] > 0)	{
			if (@ex.f.obj[@ObjSysMenu01].f[4] == @Off)	{
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01].frame_action.start(-1, "$Menu_btn_disp", 1, 0, 1)
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02].frame_action.start(-1, "$Menu_btn_disp", 0, 1, 0)
				@ex.f.obj[@ObjSysMenu01].f[4] = @On
			}
		}
		else	{
			@ex.f.obj[@ObjSysMenu01].f[4] = @Off
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad01].disp = @On
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuLoad02].disp = @Off
		}
		// ＳＡＶＥ
		if ($obj_btn_state[5] > 0)	{
			if (@ex.f.obj[@ObjSysMenu01].f[5] == @Off)	{
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].frame_action.start(-1, "$Menu_btn_disp", 1, 0, 1)
				@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].frame_action.start(-1, "$Menu_btn_disp", 0, 1, 0)
				@ex.f.obj[@ObjSysMenu01].f[5] = @On
			}
		}
		else	{
			@ex.f.obj[@ObjSysMenu01].f[5] = @Off
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].frame_action.end
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave01].disp = @On
			@ex.f.obj[@ObjSysMenu00].@cd[_ObjSysMenuSave02].disp = @Off
		}


		// 状態表示
		input.next
		disp

		// 結果
		if (@MSBTN_RESULT == @DECIDE)	{
			@MSBTN_RESULT = @INIT
			@se_play(001)
			switch (@MSCHK)	{
				case (0)
					// ＳＫＩＰ
					if ($btn_state_switch[0] == @StateOff)	{
						// 既読スキップＯＮ
						$btn_state_switch[0] = @StateOn
						@SkipStartReady = @On
					}
					elseif ($btn_state_switch[0] == @StateOn)	{
						// 既読スキップＯＦＦ
						$btn_state_switch[0] = @StateOff
						@SkipStartReady = @Off
					}
				case (1)
					// ＢＡＣＫ
					if (@CdState[+3] == @On)	{
						gosub (2) #ConDisp
					}
					else	{
						syscom.return_to_sel(@Off, @On, @On)
					}
				case (2)
					// ＡＵＴＯ
					if (($btn_state_switch[2] == @StateOff) || (@AutoStartReady == @Off))	{
					// オートモードＯＮ
					$btn_state_switch[2] = @StateOn
					@AutoStartReady = @On
					}
					elseif (($btn_state_switch[2] == @StateOn) || (@AutoStartReady == @On))	{
						// オートモードＯＦＦ
						$btn_state_switch[2] = @StateOff
						@AutoStartReady = @Off
					}
				case (3)
					// ＣＯＮＦＩＧ
					@ex.F[$sys_cf_mode] = @On
					break
				case (4)
					// ＬＯＡＤ
					@ex.F[$sys_lo_mode] = @On
					break
				case (5)
					// ＳＡＶＥ
					@ex.F[$sys_sa_mode] = @On
					break
			}
		}
	} // 0

return


/********************************************************
*前の選択肢／タイトル／ゲーム終了／回想確認             *
*********************************************************/
#ConDisp

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 確認ダイアログ
	if (@CdState[+3] == @On)	{	// todo 修正

		// 確認ダイアログ
		@ex.f.obj[@ObjSysMenu01].tr = 0
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConBg00 ].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConYes  ].create(sys_sa_setbtn01,    @On,  659, 310)
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConNo   ].create(sys_sa_setbtn02,    @On,  854, 310)
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConCheck].create(sys_sa_chk00,       @On, 1095, 343)
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConFilter].create(bg_kuro,           @On,    0,   0)

		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConBg00].patno = L[0]
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConFilter].tr = 150
		@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConFilter].layer = -1



		// 確認ダイアログ表示
		@ex.f.obj[@ObjSysMenu01].tr_eve.set(255, L[20], 0, 2)

		if (@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConBg00].patno == 2)	{
			// 前の選択肢に戻る
		}
		elseif (@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConBg00].patno == 3)	{
			// タイトルメニューに戻る
		}
		elseif (@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConBg00].patno == 4)	{
			// ゲームを終了する
		}
	//	elseif (@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConBg00].patno == 3)	{
	//		// 回想メニューに戻る
	//	}


		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{ // 0

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

			//
			// マウスカーソル判定
			//

			@exif_(@Off, @Off, 0, @ObjSysMenu01, _ObjSysMenuConYes)
			@exif_(@Off, @Off, 1, @ObjSysMenu01, _ObjSysMenuConNo)
			@exif_(@Off, @Off, 2, @ObjSysMenu01, _ObjSysMenuConCheck)

			// マウスボタン入力判定
			$MsBtnInputDecide
	//		@MsBtnInputDecide(@TypeDF, 0)
			if ($break_switch == @On)	{
				$break_switch = @Off
				break
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConYes  ].patno = $obj_btn_state[0]
			@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConNo   ].patno = $obj_btn_state[1]
			@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConCheck].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {@ex.f.obj[@ObjSysMenu01].@cd[_ObjSysMenuConCheck].patno = $obj_btn_state[2] + @MSBTN_CHK}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 0)	{
					// ＹＥＳ
					L[1] = @On
					break
				}
				elseif (@MSCHK == 1)	{
					// ＮＯ
					@se_play(001)
					L[1] = @Off
					break
				}
				elseif (@MSCHK == 2)	{
	     			@se_play(001)
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
		} // 0
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 0
	}

	// 確認ダイアログの設定
	switch (L[0])	{
		case (2) L[2] =  3	// Undo
//		case (1) L[2] =  5	// Title
//		case (2) L[2] =  7	// Quit
//		case (3) L[2] =  9	// Extra
	}
	if (@CdStateReady == @On ) {@CdState[+L[2]] = @Off}

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0
	}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysMenu01].tr_eve.set(0, L[20], 0, 2)
	@ex.f.obj[@ObjSysMenu01].tr_eve.wait

	if (L[1] == @On)	{
		@se_play(003)
		@koe_stop
		@PCM_STOP @PCMCH_STOP_ALL
		@bgm_stop(2000)
		// Undo
		@ex.f.obj[@ObjSysMenu01].create(bg_kuro, @On, 0, 0)
		@ex.f.obj[@ObjSysMenu01].tr = 0
		@ex.f.obj[@ObjSysMenu01].layer = 10000
		@ex.f.obj[@ObjSysMenu01].tr_eve.set(255, L[21], 0, 0)
		@ex.f.obj[@ObjSysMenu01].tr_eve.wait_key
		@se_wait_key
		syscom.return_to_sel(@Off, @Off, @Off)
//		switch (L[0])	{
//			case (0)
//				// Undo
//				@ex.f.obj[@ObjSysMenu01].create(bg_kuro, @On, 0, 0)
//				@ex.f.obj[@ObjSysMenu01].tr = 0
//				@ex.f.obj[@ObjSysMenu01].layer = 10000
//				@ex.f.obj[@ObjSysMenu01].tr_eve.set(255, L[21], 0, 0)
//				@ex.f.obj[@ObjSysMenu01].tr_eve.wait_key
//				@se_wait_key
//				syscom.return_to_sel(@Off, @Off, @Off)
//			case (1)
//				// Title
//				@TM_CONF = @On
//				@ex.f.obj[@ObjSysMenu01].create(bg_kuro, @On, 0, 0)
//				@ex.f.obj[@ObjSysMenu01].tr = 0
//				@ex.f.obj[@ObjSysMenu01].layer = 10000
//				@ex.f.obj[@ObjSysMenu01].tr_eve.set(255, L[21], 0, 0)
//				@ex.f.obj[@ObjSysMenu01].tr_eve.wait_key
//				@se_wait_key
//				syscom.return_to_menu(@Off, @Off, @Off)
//			case (2)
//				// Quit
//				@ex.f.obj[@OBJ_BG07].create(bg_kuro, @On, 0, 0)
//				@ex.f.obj[@OBJ_BG07].tr = 0
//				@ex.f.obj[@OBJ_BG07].layer = 1000001
//				@ex.f.obj[@OBJ_BG07].tr_eve.set(255, L[21], 0, 0)
//				@ex.f.obj[@OBJ_BG07].tr_eve.wait_key
//				@se_wait_key
//				syscom.end_game(@Off)
//			case (3)
//				// Extra
//				@ex.f.obj[@ObjSysMenu01].create(bg_kuro, @On, 0, 0)
//				@ex.f.obj[@ObjSysMenu01].tr = 0
//				@ex.f.obj[@ObjSysMenu01].layer = 10000
//				@ex.f.obj[@ObjSysMenu01].tr_eve.set(255, 1000, 0, 0)
//				@ex.f.obj[@ObjSysMenu01].tr_eve.wait_key
//				@se_wait_key
//				syscom.return_to_menu(@Off, @Off, @Off)
//		}
	}


return


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
		@ex.F[$sys_sm_mode] = @Off
		@ex.F[$sys_sa_mode] = @Off
		@ex.F[$sys_lo_mode] = @Off
		@ex.F[$sys_cf_mode] = @Off
		$break_switch = @On
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


// ----------------------------------------------------------------------------------------
// クイックメニューボタンアニメ
// ----------------------------------------------------------------------------------------
command $Menu_btn_disp(
	property $fa : frameaction,
	property $obj : object,
	property $disp00,
	property $disp01,
	property $disp02)

{
	L[0] = $fa.counter.get % 800
	L[1] = math.timetable(L[0], 0, $disp00, [0, 400, $disp01], [400, 800, $disp02])
	$obj.disp = L[1]
}


