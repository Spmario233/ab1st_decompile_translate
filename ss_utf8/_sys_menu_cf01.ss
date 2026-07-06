/********************************************************
*														*
*						環境設定						*
*														*
*********************************************************/
#z00

// タイトルメニューから飛んできた場合
if (@TM_STATE == @On)	{
	// システムコマンドメニューを禁止
	syscom.set_syscom_menu_disable
}


// 環境設定初期化
gosub #CFPageInit


// ページ切り替え
#cf_page_change

// 環境設定データ取得
gosub #CFPageState

// オブジェクトの初期化
gosub #ObjInit00

// 環境設定構築
gosub #ObjConstruct

// 環境設定表示
gosub #ObjDisp



//
// 環境設定実行
//

gosub #CFMenuPut


// ページ切り替え
if (@SysCFPageChange == @On)	{
	goto #cf_page_change
}

// 初期化
$break_switch = @Off

// 初期化
pcmch[15].set_volume(syscom.get_pcm_volume)

// 項目切り替え
if ((@ex.F[$sys_sa_mode] == @On) || (@ex.F[$sys_lo_mode] == @On))	{
	//セーブ／ ロード
	@se_play(001)
	jump(_sys_menu_sl01, 00)
}

// タイトルメニュー判定[ボタン状態初期化]
if (@TM_STATE == @On)	{
	if ((syscom.get_save_new_no == -1) && (syscom.get_quick_save_new_no == -1))	{
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = @FORBID
	}
	else	{
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = 0
	}
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn00].init
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].patno = 0
}


// モード初期化
$sys_mode = $no_mode

// 環境設定非表示
gosub #ObjErase

// システムコール解放
$excall_free

return


/********************************************************
*環境設定初期化                                          *
*********************************************************/
#CFPageInit

	// ページ切り替え判定を初期化
	@SysCFPageChange = @Off

	// 既読スキップＯＦＦ
	syscom.set_read_skip_onoff_flag(@Off)

	// モード設定
	$sys_mode_prev = $sys_mode

	// 環境設定項目初期化
//	@SysCFPage = @Init
//	@SysCFLastPage = @Init
//	@SysCFPagePrev = @Init
	@SysCFPageCSpd = @Init

	if (@ex.F[$sys_cf_mode] == @On)	{
		@ex.F[$sys_cf_mode] = @Off
		$sys_mode = $sys_cf_mode
	}

return


/********************************************************
*環境設定データ取得                                      *
*********************************************************/
#CFPageState


	// セーブ／ロード画面から切り替えた場合
	if (($sys_mode_prev == $sys_sa_mode) || ($sys_mode_prev == $sys_lo_mode))	{
		@SysCFPageChange = @On
	}

	// 画面モード状態取得
	@GetWindowState(@WWSizeState)
	// 演出状態取得
	@GetDispState(@BgFadeState, @BsFadeState, @EvFadeState, @MeFadeState, @EmDispState)
	// メッセージスキップ状態取得
	@GetMsgSkipState(@MsgSkipState)
	// ＢＧＭ・音声状態取得
	@GetMusicState(@AllChkState, @AllVolState, @BgmChkState, @BgmVolState, @VoiceChkState, @VoiceTChkState, @VoiceVolState, @BFadeChk01State, @BFadeVolState, @SeChkState, @SeVolState, @SysChkState, @SysVolState, @MovChkState, @MovVolState)
	// オートモード状態取得
	@GetSysAMState(@AmCheckState,@TTimeState,@STimeState)

	// キャラクター音声 ＯＮ／ＯＦＦ
	@GetCVoiceState(@CVState01, @CVState02, @CVState03, @CVState04, @CVState05, @CVState06, @CVState07, @CVState08, @CVState09, @CVState10, @CVState11, @CVState12, @CVState13, @CVState14, @CVState15, @CVState16, @CVState17, @CVState18, @CVState19, @CVState20, @CVState21, @CVState22)
	// キャラクター音声 ボリューム
	@GetCVoiceVolState(@CVVolState01, @CVVolState02, @CVVolState03, @CVVolState04, @CVVolState05, @CVVolState06, @CVVolState07, @CVVolState08, @CVVolState09, @CVVolState10, @CVVolState11, @CVVolState12, @CVVolState13, @CVVolState14, @CVVolState15, @CVVolState16, @CVVolState17, @CVVolState18, @CVVolState19, @CVVolState20, @CVVolState21, @CVVolState22)

	// メッセージスピード状態取得
	@GetMSState(@MSChkState, @MSState)
	// 現在の使用フォント取得
	@GetUseFont(@UseFontState)

	// ＭＳＧウィンドウ状態取得
	@GetWindowBgState(@WBState01, @WBState02, @WBState03, @WBState04)
	// その他の設定
	@GetEtcSetingState(@EsState[0], @EsState[1], @EsState[2], @EsState[3], @EsState[4], @EsState[5], @EsState[6], @EsState[7], @EsState[8], @EsState[9], @EsState[10])
	// 時短再生状態取得
	@GetSysTCState(@TCChkState01,@TCChkState02,@TCChkState03,@TCSpdState)

	// カウンター初期化
	counter[@CNoLSW].reset
	counter[@CNoRSW].reset
	counter[@CNoLCtrl].reset
	counter[@CNoRCtrl].reset
	counter[@CNoMSP01].reset
	counter[@CNoMSP02].reset
	counter[@CNoBgmTest].reset

	// メッセージスピードゲージ初期化初回動作不能処理
	@MSP_TOUCH_STATE01 = @INIT
    @MSP_TOUCH_STATE02 = @INIT
	@MSP_TOUCH_STATE03 = @INIT

	// サンプルテキスト一時停止フラグ初期化
	@MS_POSE_TEST_STATE  = @Off
	@MS_POSE_DELAY_STATE = @Off

return


/********************************************************
*オブジェクトの初期化                                   *
*********************************************************/
#ObjInit00

	@ex.f.obj[@ObjSysSL00].init
	@ex.f.obj[@ObjSysSL01].init
	@ex.f.obj[@ObjSysSL02].init
	@ex.f.obj[@ObjSysSL03].init
	@ex.f.obj[@ObjSysSL04].init

	// 壁紙
	@ex.f.obj[@ObjSysCF00].init
	@ex.f.obj[@ObjSysCF00].disp = @On
	@ex.f.obj[@ObjSysCF00].@cd.resize(10)

	// メニューボタン
	@ex.f.obj[@ObjSysCF01].init
	@ex.f.obj[@ObjSysCF01].disp = @On
	@ex.f.obj[@ObjSysCF01].layer = 600
	@ex.f.obj[@ObjSysCF01].@cd.resize(10)

	// システム
	@ex.f.obj[@ObjSysCF02].init
	@ex.f.obj[@ObjSysCF02].disp = @On
	@ex.f.obj[@ObjSysCF02].layer = 500
	@ex.f.obj[@ObjSysCF02].@cd.resize(200)

	// テキスト
	@ex.f.obj[@ObjSysCF03].init
	@ex.f.obj[@ObjSysCF03].disp = @On
	@ex.f.obj[@ObjSysCF03].layer = 500
	@ex.f.obj[@ObjSysCF03].@cd.resize(200)

	// サウンド
	@ex.f.obj[@ObjSysCF04].init
	@ex.f.obj[@ObjSysCF04].disp = @On
	@ex.f.obj[@ObjSysCF04].layer = 500
	@ex.f.obj[@ObjSysCF04].@cd.resize(200)

	// 確認メッセージ
	@ex.f.obj[@ObjSysCF05].init
	@ex.f.obj[@ObjSysCF05].disp = @On
	@ex.f.obj[@ObjSysCF05].layer = 100
	@ex.f.obj[@ObjSysCF05].@cd.resize(10)

	// コンフィグ画面表示
	if (@SysCFPageChange == @Off)	{
		@ex.f.obj[@ObjSysCF00].tr = 0
		@ex.f.obj[@ObjSysCF02].tr = 0
		@ex.f.obj[@ObjSysCF03].tr = 0
		@ex.f.obj[@ObjSysCF04].tr = 0
	}

	frame

return


/********************************************************
*環境設定構築                                           *
*********************************************************/
#ObjConstruct

	// 壁紙------------------------------------------------------------------------------------------------------------

	// メニューボタン--------------------------------------------------------------------------------------------------
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn01].create(sys_cf_page01, @On,  788, 26)							// システム
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn02].create(sys_cf_page02, @On,  942, 26)							// テキスト
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn03].create(sys_cf_page03, @On, 1096, 26)							// サウンド
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn01+@SysCFPage].patno = @Operate

	// 下部メニューボタン----------------------------------------------------------------------------------------------
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn04].create(sys_sm_page01, @On,   30, 648)						// ゲームを終了
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn05].create(sys_sm_page02, @On,  233, 648)						// タイトルに戻る
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn06].create(sys_sm_page03, @On,  438, 648)						// セーブ
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn07].create(sys_sm_page04, @On,  641, 648)						// ロード
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn08].create(sys_sm_page05, @On,  844, 648)						// コンフィグ
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn09].create(sys_sm_page06, @On, 1047, 648)						// ゲームに戻る
	@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn08].patno = @Operate

	// システム--------------------------------------------------------------------------------------------------------
	if (@SysCFPage == 0)	{

		// 下地
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFSysBg00].create(sys_cf_bg01, @On, 0, 0)
		// 画面モード
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow01].create(sys_cf_btn01, @On, 224, 99)					// 標準ウィンドウ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow02].create(sys_cf_btn02, @On, 349, 99)					// フルスクリーン
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow03].create(sys_cf_btn03, @On, 474, 99)					// 詳細設定
		    if (@WWSizeState == @Off)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow01].patno = @Operate}
		elseif (@WWSizeState == @On)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow02].patno = @Operate}
		// 現在地表示
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation01].create(sys_cf_btn04, @On, 349, 156)					// 表示する
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation02].create(sys_cf_btn05, @On, 474, 156)					// 表示しない
		    if (@SpotDispState == @On)  {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation01].patno = @Operate}
		elseif (@SpotDispState == @Off) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation02].patno = @Operate}
		// キャラクター演出
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBsFadeMode01].create(sys_cf_btn06, @On, 349, 248)				// 通常
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBsFadeMode03].create(sys_cf_btn07, @On, 474, 248)				// 瞬時
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBsFadeMode01+@BsFadeState].patno = @Operate
		// 背景演出
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBgFadeMode01].create(sys_cf_btn06, @On, 349, 282)				// 通常
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBgFadeMode03].create(sys_cf_btn07, @On, 474, 282)				// 瞬時
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBgFadeMode01+@BgFadeState].patno = @Operate
		// イベントＣＧ演出
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFEvFadeMode01].create(sys_cf_btn06, @On, 349, 316)				// 通常
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFEvFadeMode03].create(sys_cf_btn07, @On, 474, 316)				// 瞬時
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFEvFadeMode01+@EvFadeState].patno = @Operate
		// メッセージウィンドウ演出
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMwFadeMode01].create(sys_cf_btn06, @On, 349, 350)				// 通常
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMwFadeMode03].create(sys_cf_btn07, @On, 474, 350)				// 瞬時
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMwFadeMode01+@MwFadeState].patno = @Operate
		// システムメニュー演出
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMeFadeMode01].create(sys_cf_btn06, @On, 349, 384)				// 通常
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMeFadeMode03].create(sys_cf_btn07, @On, 474, 384)				// 瞬時
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMeFadeMode01+@MeFadeState].patno = @Operate
		// エモーション表示
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn01].create(sys_cf_btn08, @On, 349, 418)					// ＯＮ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn02].create(sys_cf_btn09, @On, 474, 418)					// ＯＦＦ
		    if (@EmDispState == @On)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn01].patno = @Operate}
		elseif (@EmDispState == @Off)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn02].patno = @Operate}
		// メッセージスキップ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn01].create(sys_cf_btn10, @On, 349, 475)				// 既読のみ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn02].create(sys_cf_btn11, @On, 474, 475)				// 未読も含む
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn01+@MsgSkipState].patno = @Operate
		// オートセーブ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn01].create(sys_cf_btn12, @On, 349, 532)					// 有効
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn02].create(sys_cf_btn13, @On, 474, 532)					// 無効
		    if (@EsAutoSave == @On)		{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn01].patno = @Operate}
		elseif (@EsAutoSave == @Off)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn02].patno = @Operate}
		// 実績システム（仮）※リリースモードでは表示
		if( @trial_check())	{
		}
		else	{
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn01].create(sys_cf_btn04, @On, 349, 589)					// 有効
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn02].create(sys_cf_btn05, @On, 474, 589)					// 無効
			    if (@実績獲得表示する == @On)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn01].patno = @Operate}
			elseif (@実績獲得表示する == @Off)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn02].patno = @Operate}
		}
		// 右クリック動作
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn01].create(sys_cf_btn14, @On,  720, 131)				// クイックメニュー
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn02].create(sys_cf_btn15, @On,  869, 131)				// ウィンドウ消去
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn03].create(sys_cf_btn16, @On, 1018, 131)				// セーブ画面
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn04].create(sys_cf_btn17, @On,  720, 161)				// ロード画面
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn05].create(sys_cf_btn18, @On,  869, 161)				// Config画面
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn01+@MRActionState].patno = @Operate
		// 確認メッセージ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn01].create(sys_cf_btn19, @On, 709, 254)					// セーブ／ロード
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn02].create(sys_cf_btn20, @On, 937, 254)					// クイックセーブ／クイックロード
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn03].create(sys_cf_btn21, @On, 709, 286)					// 上書きセーブ
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn04].create(sys_cf_btn22, @On, 937, 286)					// 前の選択肢に戻る
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn05].create(sys_cf_btn23, @On, 709, 318)					// セーブデータの入れ替え
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn06].create(sys_cf_btn24, @On, 937, 318)					// タイトルに戻る
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn07].create(sys_cf_btn25, @On, 709, 350)					// セーブデータの削除
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn08].create(sys_cf_btn26, @On, 937, 350)					// ゲームを終了する
		for ($_L[0] = 0, $_L[0] < 8, $_L[0] += 1)	{
			if (@CDState[+$_L[0]] == @On) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn01+$_L[0]].patno = @Operate}
		}
		// その他の設定
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk01].create(sys_cf_chk01, @On, 709, 442)					// マウスホイールボタンの…
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk02].create(sys_cf_chk02, @On, 709, 477)					// 本プログラムの動作を…
		if (@EsState[3]  == @On) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk01].patno = @Operate}
		if (@EsState[0]  == @On) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk02].patno = @Operate}
		// ムービー設定
		@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMovSetBtn00].create(sys_cf_btn27, @On, 1073, 532)

	}
	// テキスト--------------------------------------------------------------------------------------------------------
	elseif (@SysCFPage == 1)	{

		// 下地
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBg00].create(sys_cf_bg02, @On, 0, 0)
		// フォント
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn01].create(sys_cf_btn28, @On, 220, 99)						// フォントＡ
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn02].create(sys_cf_btn29, @On, 320, 99)						// フォントＢ
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn03].create(sys_cf_btn30, @On, 420, 99)						// フォント設定
		@UseFontState = syscom.get_font_name
		    if (@UseFontState == @FontA) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn01].patno =  @Operate}
		elseif (@UseFontState == @FontB) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn02].patno =  @Operate}
		else                             {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn03].patno += @Operate}
		// ノーウェイト
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk01].create(sys_cf_chk03, @On, 78, 153)
		if (@MSChkState == @On) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk01].patno = @StateOn}
		// メッセージ速度
		@MSP_SET = math.timetable(@MSState, 0, 255, [0, 100, 0])
		@MSP_SET = @MSP_SET + @S_CTL_BAR_MS_STPOS
		@MSP_SET_PREV = @MSState
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01].create(sys_cf_bar01, @On, 284, 160-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl01].create(sys_cf_ctl01, @On, @MSP_SET, 151)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].create(sys_cf_bar01, @On, 284, 160-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl01].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_bottom = 720
		// 初期設定に戻す
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn04].create(sys_cf_btn31, @On, 450, 99)
		// ウィンドウ背景[赤]
		@WB_R_SET = @WBState01 + @S_CTL_BAR_MWBG_STPOS01
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02].create(sys_cf_bar02, @On, 284, 262-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl02].create(sys_cf_ctl01, @On, @WB_R_SET, 253)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].create(sys_cf_bar02, @On, 284, 262-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl02].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_bottom = 720
		// ウィンドウ背景[緑]
		@WB_G_SET = @WBState02 + @S_CTL_BAR_MWBG_STPOS02
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03].create(sys_cf_bar03, @On, 284, 307-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl03].create(sys_cf_ctl01, @On, @WB_G_SET, 298)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].create(sys_cf_bar03, @On, 284, 307-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl03].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_bottom = 720
		// ウィンドウ背景[青]
		@WB_B_SET = @WBState03 + @S_CTL_BAR_MWBG_STPOS03
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04].create(sys_cf_bar04, @On, 284, 352-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl04].create(sys_cf_ctl01, @On, @WB_B_SET, 343)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].create(sys_cf_bar04, @On, 284, 352-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl04].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_bottom = 720
		// ウィンドウ背景[透過度]
		@WB_TR_SET = (255 - @WBState04) + @S_CTL_BAR_MWBG_STPOS04
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05].create(sys_cf_bar05, @On, 284, 397-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl05].create(sys_cf_ctl01, @On, @WB_TR_SET, 388)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].create(sys_cf_bar05, @On, 284, 397-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl05].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_bottom = 720
		// サンプルテキスト背景
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].create(sys_cf_msfilter00, @On, 124, 444)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_r = syscom.get_filter_color_r
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_g = syscom.get_filter_color_g
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_b = syscom.get_filter_color_b
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].tr          = syscom.get_filter_color_a
		// サンプルテキスト
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].create_string("这里是文本框显示速度的演示文本。", @On, 440, 500)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].set_string_param(26, 0, 0, 0, 0, 1, -1)
		// 初期設定に戻す
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn05].create(sys_cf_btn31, @On, 450, 212)
		// オートモードチェック
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk02].create(sys_cf_chk04, @On, 709, 149)
		if (@AmCheckState == @On) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk02].patno += @Operate}
		// 文字時間スクロール
		L[0] = ((@TTimeState / 5) * 2) + @S_CTL_BAR_TTIME_STPOS
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06].create(sys_cf_bar06, @On,  948, 307-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06].create(sys_cf_ctl01, @On, L[0], 297)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].create(sys_cf_bar06, @On, 948, 307-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_bottom = 720
		// 最小時間スクロール
		L[0] = ((@STimeState / 50) * 2) + @S_CTL_BAR_STIME_STPOS
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07].create(sys_cf_bar06, @On,  948, 352-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07].create(sys_cf_ctl01, @On, L[0], 342)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].create(sys_cf_bar06, @On, 948, 352-1)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].patno = 4
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_use = @On
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_left = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_top = 0
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07].x
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_bottom = 720
		// 文字時間数値
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum01].create(sys_cf_num00, @On, 790, 301)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum02].create(sys_cf_num00, @On, 814, 301)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum03].create(sys_cf_num00, @On, 834, 301)
		// 最小時間数値
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum04].create(sys_cf_num00, @On, 810, 346)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum05].create(sys_cf_num00, @On, 834, 346)
		// 待ち時間数値
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum07].create(sys_cf_num00, @On,  950, 391)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum08].create(sys_cf_num00, @On,  970, 391)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum09].create(sys_cf_num00, @On,  994, 391)
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum10].create(sys_cf_num00, @On, 1014, 391)
		// 初期設定に戻す
		@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn06].create(sys_cf_btn31, @On, 1073, 99)

		// オートモード時間構築
		@TTIME_SET = @TTimeState
		@STIME_SET = @STimeState
		@WTIME_SET = (10 * @TTIME_SET) + @STIME_SET
		$AMNumset

	}
	// サウンド--------------------------------------------------------------------------------------------------------
	elseif (@SysCFPage == 2)	{

		// 下地
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndBg00].create(sys_cf_bg03, @On, 0, 0)
		// 全体
		L[0] = @AllVolState + @S_CTL_BAR_VOL_ALL_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk01 ].create(sys_cf_chk05, @On,   78, 147)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01 ].create(sys_cf_bar01, @On,  265, 161-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl01 ].create(sys_cf_ctl01, @On, L[0], 152)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].create(sys_cf_bar01, @On,  265, 161-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl01].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_bottom = 720
		if (@AllChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk01].patno = @Operate}
		// ＢＧＭ
		L[0] = @BgmVolState + @S_CTL_BAR_VOL_BGM_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk02 ].create(sys_cf_chk06, @On,   78, 192)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02 ].create(sys_cf_bar01, @On,  265, 206-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl02 ].create(sys_cf_ctl01, @On, L[0], 197)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].create(sys_cf_bar01, @On,  265, 206-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl02].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_bottom = 720
		if (@BgmChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk02].patno = @Operate}
		// ＢＧＭフェード
		L[0] = @BFadeVolState + @S_CTL_BAR_VOL_BFADE_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk03 ].create(sys_cf_chk07, @On,   78, 237)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03 ].create(sys_cf_bar01, @On,  265, 251-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl03 ].create(sys_cf_ctl01, @On, L[0], 242)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].create(sys_cf_bar01, @On,  265, 251-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl03].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_bottom = 720
		if (@BFadeChk01State == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk03].patno = @Operate}
		// 音声
		L[0] = @VoiceVolState + @S_CTL_BAR_VOL_VOICE_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk04 ].create(sys_cf_chk08, @On,   78, 282)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04 ].create(sys_cf_bar01, @On,  265, 296-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl04 ].create(sys_cf_ctl01, @On, L[0], 287)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].create(sys_cf_bar01, @On,  265, 296-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl04].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_bottom = 720
		if (@VoiceChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk04].patno = @Operate}
		// 効果音
		L[0] = @SeVolState + @S_CTL_BAR_VOL_SE_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk05 ].create(sys_cf_chk09, @On,   78, 327)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05 ].create(sys_cf_bar01, @On,  265, 341-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl05 ].create(sys_cf_ctl01, @On, L[0], 332)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].create(sys_cf_bar01, @On,  265, 341-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl05].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_bottom = 720
		if (@SeChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk05].patno = @Operate}
		// システム音
		L[0] = @SysVolState + @S_CTL_BAR_VOL_SYS_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk06 ].create(sys_cf_chk10, @On,   78, 372)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06 ].create(sys_cf_bar01, @On,  265, 386-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl06 ].create(sys_cf_ctl01, @On, L[0], 377)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].create(sys_cf_bar01, @On,  265, 386-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl06].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_bottom = 720
		if (@SysChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk06].patno = @Operate}
		// ムービー
		L[0] = @MovVolState + @S_CTL_BAR_VOL_MOV_STPOS
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk07 ].create(sys_cf_chk11, @On,   78, 417)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07 ].create(sys_cf_bar01, @On,  265, 431-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl07 ].create(sys_cf_ctl01, @On, L[0], 422)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].create(sys_cf_bar01, @On,  265, 431-1)
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl07].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_bottom = 720
		if (@MovChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk07].patno = @Operate}
		// 初期設定に戻す
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn01].create(sys_cf_btn31, @On, 450, 99)
		// ボリュームテスト再生ボタン
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn02].create(sys_cf_btn32, @On, 573, 152)				// 全体
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn03].create(sys_cf_btn32, @On, 573, 197)				// ＢＧＭ
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn04].create(sys_cf_btn32, @On, 573, 242)				// ＢＧＭフェード
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn05].create(sys_cf_btn32, @On, 573, 287)				// 音声
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn06].create(sys_cf_btn32, @On, 573, 332)				// 効果音
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn07].create(sys_cf_btn32, @On, 573, 377)				// システム音
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn08].create(sys_cf_btn32, @On, 573, 422)				// ムービー

		// 音声の再生（声の再生中に次の文章に進んでも再生を続ける）
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn09].create(sys_cf_chk12, @On, 99, 536)
		if (@EsState[4] == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn09].patno = @Operate}

		// キャラクター別音声[ボタン]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn01].create(sys_cf_cvbtn01, @On,   698, 152)			// キャラ０１[音無]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn02].create(sys_cf_cvbtn02, @On,   786, 152)			// キャラ０２[ゆり]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn03].create(sys_cf_cvbtn03, @On,   874, 152)			// キャラ０３[天使]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn04].create(sys_cf_cvbtn04, @On,   962, 152)			// キャラ０４[日向]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn05].create(sys_cf_cvbtn05, @On,  1050, 152)			// キャラ０５[ユイ]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn06].create(sys_cf_cvbtn06, @On,  1138, 152)			// キャラ０６[岩沢]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn07].create(sys_cf_cvbtn07, @On,   698, 257)			// キャラ０７[松下]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn08].create(sys_cf_cvbtn08, @On,   786, 257)			// キャラ０８[野田]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn09].create(sys_cf_cvbtn09, @On,   874, 257)			// キャラ０９[高松]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn10].create(sys_cf_cvbtn10, @On,   962, 257)			// キャラ１０[大山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn11].create(sys_cf_cvbtn11, @On,  1050, 257)			// キャラ１１[藤巻]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn12].create(sys_cf_cvbtn12, @On,  1138, 257)			// キャラ１２[ＴＫ]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn13].create(sys_cf_cvbtn13, @On,   698, 362)			// キャラ１３[椎名]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn14].create(sys_cf_cvbtn14, @On,   786, 362)			// キャラ１４[遊佐]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn15].create(sys_cf_cvbtn15, @On,   874, 362)			// キャラ１５[ひさ子]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn16].create(sys_cf_cvbtn16, @On,   962, 362)			// キャラ１６[関根]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn17].create(sys_cf_cvbtn17, @On,  1050, 362)			// キャラ１７[入江]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn18].create(sys_cf_cvbtn18, @On,  1138, 362)			// キャラ１８[チャー]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn19].create(sys_cf_cvbtn19, @On,   698, 467)			// キャラ１９[竹山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn20].create(sys_cf_cvbtn20, @On,   786, 467)			// キャラ２０[直井]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn21].create(sys_cf_cvbtn21, @On,   874, 467)			// キャラ２１[その他・男]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn22].create(sys_cf_cvbtn22, @On,   962, 467)			// キャラ２２[その他・女]
		for ($_L[0] = 0, $_L[0] < 22, $_L[0] += 1)	{
			if (@CVState[+$_L[0]] == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn01+$_L[0]].patno += @Operate}
		}
		// かなでの名前処理
		if (@かなでの音声ボタン変更 == @On)	{
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn03].patno += 8
		}

		// キャラクター別音声[テスト再生ボタン]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay01].create(sys_cf_cvbtn00, @On,  756, 156)			// キャラ０１[音無]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay02].create(sys_cf_cvbtn00, @On,  844, 156)			// キャラ０２[ゆり]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay03].create(sys_cf_cvbtn00, @On,  932, 156)			// キャラ０３[天使]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay04].create(sys_cf_cvbtn00, @On, 1020, 156)			// キャラ０４[日向]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay05].create(sys_cf_cvbtn00, @On, 1108, 156)			// キャラ０５[ユイ]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay06].create(sys_cf_cvbtn00, @On, 1196, 156)			// キャラ０６[岩沢]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay07].create(sys_cf_cvbtn00, @On,  756, 261)			// キャラ０７[松下]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay08].create(sys_cf_cvbtn00, @On,  844, 261)			// キャラ０８[野田]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay09].create(sys_cf_cvbtn00, @On,  932, 261)			// キャラ０９[高松]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay10].create(sys_cf_cvbtn00, @On, 1020, 261)			// キャラ１０[大山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay11].create(sys_cf_cvbtn00, @On, 1108, 261)			// キャラ１１[藤巻]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay12].create(sys_cf_cvbtn00, @On, 1196, 261)			// キャラ１２[ＴＫ]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay13].create(sys_cf_cvbtn00, @On,  756, 366)			// キャラ１３[椎名]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay14].create(sys_cf_cvbtn00, @On,  844, 366)			// キャラ１４[遊佐]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay15].create(sys_cf_cvbtn00, @On,  932, 366)			// キャラ１５[ひさ子]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay16].create(sys_cf_cvbtn00, @On, 1020, 366)			// キャラ１６[関根]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay17].create(sys_cf_cvbtn00, @On, 1108, 366)			// キャラ１７[入江]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay18].create(sys_cf_cvbtn00, @On, 1196, 366)			// キャラ１８[チャー]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay19].create(sys_cf_cvbtn00, @On,  756, 471)			// キャラ１９[竹山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay20].create(sys_cf_cvbtn00, @On,  844, 471)			// キャラ２０[直井]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay21].create(sys_cf_cvbtn00, @On,  932, 471)			// キャラ２１[その他・男]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay22].create(sys_cf_cvbtn00, @On, 1020, 471)			// キャラ２２[その他・女]

		// キャラクター別音声[ボリュームバー]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01].create(sys_cf_bar07,  @On,  701, 240-1)				// キャラ０１[音無]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02].create(sys_cf_bar07,  @On,  789, 240-1)				// キャラ０２[ゆり]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03].create(sys_cf_bar07,  @On,  877, 240-1)				// キャラ０３[天使]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04].create(sys_cf_bar07,  @On,  965, 240-1)				// キャラ０４[日向]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05].create(sys_cf_bar07,  @On, 1053, 240-1)				// キャラ０５[ユイ]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06].create(sys_cf_bar07,  @On, 1141, 240-1)				// キャラ０６[岩沢]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07].create(sys_cf_bar07,  @On,  701, 345-1)				// キャラ０７[松下]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08].create(sys_cf_bar07,  @On,  789, 345-1)				// キャラ０８[野田]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09].create(sys_cf_bar07,  @On,  877, 345-1)				// キャラ０９[高松]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10].create(sys_cf_bar07,  @On,  965, 345-1)				// キャラ１０[大山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11].create(sys_cf_bar07,  @On, 1053, 345-1)				// キャラ１１[藤巻]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12].create(sys_cf_bar07,  @On, 1141, 345-1)				// キャラ１２[ＴＫ]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13].create(sys_cf_bar07,  @On,  701, 450-1)				// キャラ１３[椎名]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14].create(sys_cf_bar07,  @On,  789, 450-1)				// キャラ１４[遊佐]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15].create(sys_cf_bar07,  @On,  877, 450-1)				// キャラ１５[ひさ子]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16].create(sys_cf_bar07,  @On,  965, 450-1)				// キャラ１６[関根]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17].create(sys_cf_bar07,  @On, 1053, 450-1)				// キャラ１７[入江]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18].create(sys_cf_bar07,  @On, 1141, 450-1)				// キャラ１８[チャー]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19].create(sys_cf_bar07,  @On,  701, 555-1)				// キャラ１９[竹山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20].create(sys_cf_bar07,  @On,  789, 555-1)				// キャラ２０[直井]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21].create(sys_cf_bar07,  @On,  877, 555-1)				// キャラ２１[その他・男]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22].create(sys_cf_bar07,  @On,  965, 555-1)				// キャラ２２[その他・女]

		// キャラクター別音声[ボリュームＣＴＬ]
		L[0]  = ((@CVVolState01 + 1) / 4) + @S_CTL_BAR_CV01_STPOS
		L[1]  = ((@CVVolState02 + 1) / 4) + @S_CTL_BAR_CV02_STPOS
		L[2]  = ((@CVVolState03 + 1) / 4) + @S_CTL_BAR_CV03_STPOS
		L[3]  = ((@CVVolState04 + 1) / 4) + @S_CTL_BAR_CV04_STPOS
		L[4]  = ((@CVVolState05 + 1) / 4) + @S_CTL_BAR_CV05_STPOS
		L[5]  = ((@CVVolState06 + 1) / 4) + @S_CTL_BAR_CV06_STPOS
		L[6]  = ((@CVVolState07 + 1) / 4) + @S_CTL_BAR_CV07_STPOS
		L[7]  = ((@CVVolState08 + 1) / 4) + @S_CTL_BAR_CV08_STPOS
		L[8]  = ((@CVVolState09 + 1) / 4) + @S_CTL_BAR_CV09_STPOS
		L[9]  = ((@CVVolState10 + 1) / 4) + @S_CTL_BAR_CV10_STPOS
		L[10] = ((@CVVolState11 + 1) / 4) + @S_CTL_BAR_CV11_STPOS
		L[11] = ((@CVVolState12 + 1) / 4) + @S_CTL_BAR_CV12_STPOS
		L[12] = ((@CVVolState13 + 1) / 4) + @S_CTL_BAR_CV13_STPOS
		L[13] = ((@CVVolState14 + 1) / 4) + @S_CTL_BAR_CV14_STPOS
		L[14] = ((@CVVolState15 + 1) / 4) + @S_CTL_BAR_CV15_STPOS
		L[15] = ((@CVVolState16 + 1) / 4) + @S_CTL_BAR_CV16_STPOS
		L[16] = ((@CVVolState17 + 1) / 4) + @S_CTL_BAR_CV17_STPOS
		L[17] = ((@CVVolState18 + 1) / 4) + @S_CTL_BAR_CV18_STPOS
		L[18] = ((@CVVolState19 + 1) / 4) + @S_CTL_BAR_CV19_STPOS
		L[19] = ((@CVVolState20 + 1) / 4) + @S_CTL_BAR_CV20_STPOS
		L[20] = ((@CVVolState21 + 1) / 4) + @S_CTL_BAR_CV21_STPOS
		L[21] = ((@CVVolState22 + 1) / 4) + @S_CTL_BAR_CV22_STPOS

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl01].create(sys_cf_ctl02, @On, L[0],  235)				// キャラ０１[音無]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl02].create(sys_cf_ctl02, @On, L[1],  235)				// キャラ０２[ゆり]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl03].create(sys_cf_ctl02, @On, L[2],  235)				// キャラ０３[天使]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl04].create(sys_cf_ctl02, @On, L[3],  235)				// キャラ０４[日向]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl05].create(sys_cf_ctl02, @On, L[4],  235)				// キャラ０５[ユイ]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl06].create(sys_cf_ctl02, @On, L[5],  235)				// キャラ０６[岩沢]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl07].create(sys_cf_ctl02, @On, L[6],  340)				// キャラ０７[松下]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl08].create(sys_cf_ctl02, @On, L[7],  340)				// キャラ０８[野田]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl09].create(sys_cf_ctl02, @On, L[8],  340)				// キャラ０９[高松]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl10].create(sys_cf_ctl02, @On, L[9],  340)				// キャラ１０[大山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl11].create(sys_cf_ctl02, @On, L[10], 340)				// キャラ１１[藤巻]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl12].create(sys_cf_ctl02, @On, L[11], 340)				// キャラ１２[ＴＫ]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl13].create(sys_cf_ctl02, @On, L[12], 445)				// キャラ１３[椎名]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl14].create(sys_cf_ctl02, @On, L[13], 445)				// キャラ１４[遊佐]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl15].create(sys_cf_ctl02, @On, L[14], 445)				// キャラ１５[ひさ子]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl16].create(sys_cf_ctl02, @On, L[15], 445)				// キャラ１６[関根]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl17].create(sys_cf_ctl02, @On, L[16], 445)				// キャラ１７[入江]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl18].create(sys_cf_ctl02, @On, L[17], 445)				// キャラ１８[チャー]

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl19].create(sys_cf_ctl02, @On, L[18], 550)				// キャラ１９[竹山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl20].create(sys_cf_ctl02, @On, L[19], 550)				// キャラ２０[直井]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl21].create(sys_cf_ctl02, @On, L[20], 550)				// キャラ２１[その他・男]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl22].create(sys_cf_ctl02, @On, L[21], 550)				// キャラ２２[その他・女]

		// キャラクター別音声[ボリュームバー]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].create(sys_cf_bar07,  @On,  701, 240-1)			// キャラ０１[音無]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl01].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].create(sys_cf_bar07,  @On,  789, 240-1)			// キャラ０２[ゆり]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl02].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].create(sys_cf_bar07,  @On,  877, 240-1)			// キャラ０３[天使]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl03].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].create(sys_cf_bar07,  @On,  965, 240-1)			// キャラ０４[日向]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl04].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].create(sys_cf_bar07,  @On, 1053, 240-1)			// キャラ０５[ユイ]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl05].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].create(sys_cf_bar07,  @On, 1141, 240-1)			// キャラ０６[岩沢]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl06].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].create(sys_cf_bar07,  @On,  701, 345-1)			// キャラ０７[松下]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl07].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].create(sys_cf_bar07,  @On,  789, 345-1)			// キャラ０８[野田]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl08].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].create(sys_cf_bar07,  @On,  877, 345-1)			// キャラ０９[高松]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl09].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].create(sys_cf_bar07,  @On,  965, 345-1)			// キャラ１０[大山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl10].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].create(sys_cf_bar07,  @On, 1053, 345-1)			// キャラ１１[藤巻]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl11].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].create(sys_cf_bar07,  @On, 1141, 345-1)			// キャラ１２[ＴＫ]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl12].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].create(sys_cf_bar07,  @On,  701, 450-1)			// キャラ１３[椎名]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl13].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].create(sys_cf_bar07,  @On,  789, 450-1)			// キャラ１４[遊佐]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl14].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].create(sys_cf_bar07,  @On,  877, 450-1)			// キャラ１５[ひさ子]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl15].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].create(sys_cf_bar07,  @On,  965, 450-1)			// キャラ１６[関根]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl16].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].create(sys_cf_bar07,  @On, 1053, 450-1)			// キャラ１７[入江]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl17].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].create(sys_cf_bar07,  @On, 1141, 450-1)			// キャラ１８[チャー]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl18].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].create(sys_cf_bar07,  @On,  701, 555-1)			// キャラ１９[竹山]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl19].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].create(sys_cf_bar07,  @On,  789, 555-1)			// キャラ２０[直井]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl20].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].create(sys_cf_bar07,  @On,  877, 555-1)			// キャラ２１[その他・男]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl21].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_bottom = 720

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].create(sys_cf_bar07,  @On,  965, 555-1)			// キャラ２２[その他・女]
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].patno = 4
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_use = @On
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_left = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_top = 0
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl22].x
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_bottom = 720

		// キャラクター音声の再生
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn10].create(sys_cf_btn33, @On, 1073, 499)				// 全てＯＮ
		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn11].create(sys_cf_btn34, @On, 1073, 533)				// 全てＯＦＦ

		@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn12].create(sys_cf_btn31, @On, 1073, 99)				// 初期設定に戻す
	}

	frame


return


/********************************************************
*環境設定表示                                           *
/********************************************************/
#ObjDisp

	// コンフィグ画面を開いた場合
	if (@SysCFPageChange == @Off)	{
		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 壁紙
		@ex.f.obj[@ObjSysCF00].tr_eve.set(255, L[20], 0, 0)
		// メニューボタン
		@ex.f.obj[@ObjSysCF01].tr_eve.set(255, L[20], 0, 0)
		// システム
		@ex.f.obj[@ObjSysCF02].tr_eve.set(255, L[20], 0, 0)
		// テキスト
		@ex.f.obj[@ObjSysCF03].tr_eve.set(255, L[20], 0, 0)
		// サウンド
		@ex.f.obj[@ObjSysCF04].tr_eve.set(255, L[20], 0, 0)

		@ex.f.obj[@ObjSysCF00].tr_eve.wait
	}

	// ページ切り替え判定を初期化
	@SysCFPageChange = @Off



return


/********************************************************
*環境設定非表示                                         *
/********************************************************/
#ObjErase

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 500
		case (@Fast) L[20] = 500/2
		case (@Inst) L[20] = 0
	}

	// 壁紙
	@ex.f.obj[@ObjSysCF00].tr_eve.set(0, L[20], 0, 0)

	// メニューボタン
	@ex.f.obj[@ObjSysCF01].tr_eve.set(0, L[20], 0, 0)

	// システム
	@ex.f.obj[@ObjSysCF02].tr_eve.set(0, L[20], 0, 0)

	// テキスト
	@ex.f.obj[@ObjSysCF03].tr_eve.set(0, L[20], 0, 0)

	// サウンド
	@ex.f.obj[@ObjSysCF04].tr_eve.set(0, L[20], 0, 0)

	@ex.f.obj[@ObjSysCF04].tr_eve.wait

return


/********************************************************
*環境設定実行                                           *
*********************************************************/
#CFMenuPut

	#MenuSel00

	// マウス初期化
	//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
	@MouseBtnInit
	while (1)	{ // 0

		@MSCHK_PREV = @MSCHK
		@MSCHK = @MSBTN_NONE
		@MS_STATE_PREV = @MS_STATE
		@MSWHL_STATE = @Init

		// 初期化処理（キーが放されていたら状態を初期化する）
		if (input.decide.is_up == @On)	{
			@MS_STATE = @MSBTN_INIT
			@S_CTL_BAR_ACTIVE      = @Off
			@S_CTL_BAR_CTLACTIVE   = @Off
			@S_CTL_BAR_CTLPOS_PREV = @Init
		}

		@exif_(@On,  @SysCFPage != 0,                                 0, @ObjSysCF01, _ObjSysCFBtn01)						// システムボタン
		@exif_(@On,  @SysCFPage != 1,                                 1, @ObjSysCF01, _ObjSysCFBtn02)						// テキストボタン
		@exif_(@On,  @SysCFPage != 2,                                 2, @ObjSysCF01, _ObjSysCFBtn03)						// サウンドボタン
		@exif_(@Off, @Off,                                            3, @ObjSysCF01, _ObjSysCFBtn04)						// ゲームを終了
		@exif_(@Off, @Off,                                            4, @ObjSysCF01, _ObjSysCFBtn05)						// タイトルに戻る
		@exif_(@On,  (@TM_STATE == @Off) && (check_savepoint == @On), 5, @ObjSysCF01, _ObjSysCFBtn06)						// セーブ
		@exif_(@Off, @Off,                                            6, @ObjSysCF01, _ObjSysCFBtn07)						// ロード
		                                                             														// コンフィグ
		@exif_(@Off, @Off,                                            8, @ObjSysCF01, _ObjSysCFBtn09)						// ゲームに戻る

		// システム--------------------------------------------------------------------------------------------------------
		if (@SysCFPage == 0)	{

			// 画面モード
			@exif_(@On,  @WWSizeState != @Off,    9, @ObjSysCF02, _ObjSysCFWindow01)			// 標準ウィンドウ
			@exif_(@On,  @WWSizeState != @On,    10, @ObjSysCF02, _ObjSysCFWindow02)			// フルスクリーン
			@exif_(@Off, @Off,                   11, @ObjSysCF02, _ObjSysCFWindow03)			// フルスクリーン
			// 現在地表示
			@exif_(@On,  @SpotDispState != @On,  12, @ObjSysCF02, _ObjSysCFLocation01)			// 表示する
			@exif_(@On,  @SpotDispState != @Off, 13, @ObjSysCF02, _ObjSysCFLocation02)			// 表示しない
			// 演出速度[キャラクター]
			@exif_(@On,  @BsFadeState != @Def,   14, @ObjSysCF02, _ObjSysCFBsFadeMode01)		// 通常
			@exif_(@On,  @BsFadeState != @Inst,  15, @ObjSysCF02, _ObjSysCFBsFadeMode03)		// 瞬時
			// 演出速度[背景]
			@exif_(@On,  @BgFadeState != @Def,   16, @ObjSysCF02, _ObjSysCFBgFadeMode01)		// 通常
			@exif_(@On,  @BgFadeState != @Inst,  17, @ObjSysCF02, _ObjSysCFBgFadeMode03)		// 瞬時
			// 演出速度[イベントＣＧ]
			@exif_(@On,  @EvFadeState != @Def,   18, @ObjSysCF02, _ObjSysCFEvFadeMode01)		// 通常
			@exif_(@On,  @EvFadeState != @Inst,  19, @ObjSysCF02, _ObjSysCFEvFadeMode03)		// 瞬時
			// 演出速度[メッセージウィンドウ]
			@exif_(@On,  @MwFadeState != @Def,   20, @ObjSysCF02, _ObjSysCFMwFadeMode01)		// 通常
			@exif_(@On,  @MwFadeState != @Inst,  21, @ObjSysCF02, _ObjSysCFMwFadeMode03)		// 瞬時
			// 演出速度[システムメニュー]
			@exif_(@On,  @MeFadeState != @Def,   22, @ObjSysCF02, _ObjSysCFMeFadeMode01)		// 通常
			@exif_(@On,  @MeFadeState != @Inst,  23, @ObjSysCF02, _ObjSysCFMeFadeMode03)		// 瞬時
			// エモーション表示
			@exif_(@On,  @EmDispState != @On,    24, @ObjSysCF02, _ObjSysCFDSBtn01)				// ＯＮ
			@exif_(@On,  @EmDispState != @Off,   25, @ObjSysCF02, _ObjSysCFDSBtn02)				// ＯＦＦ
			// メッセージスキップ
			@exif_(@On,  @MsgSkipState != @Off,  26, @ObjSysCF02, _ObjSysCFMSSkipBtn01)			// 既読のみ
			@exif_(@On,  @MsgSkipState != @on,   27, @ObjSysCF02, _ObjSysCFMSSkipBtn02)			// 未読も含む
			// オートセーブ
			@exif_(@On,  @EsAutoSave != @On,     28, @ObjSysCF02, _ObjSysCFASaveBtn01)			// 使用する
			@exif_(@On,  @EsAutoSave != @Off,    29, @ObjSysCF02, _ObjSysCFASaveBtn02)			// 使用しない
			// 実績システム（仮）
			@exif_(@On,  @実績獲得表示する != @On,  46, @ObjSysCF02, _ObjSysCFResultBtn01)		// 表示する		// 番号注意
			@exif_(@On,  @実績獲得表示する != @Off, 47, @ObjSysCF02, _ObjSysCFResultBtn02)		// 表示しない	// 
			// 右クリック動作
			@exif_(@On,  @MRActionState != 0,    30, @ObjSysCF02, _ObjSysCFRClickBtn01)			// クイックメニュー
			@exif_(@On,  @MRActionState != 1,    31, @ObjSysCF02, _ObjSysCFRClickBtn02)			// ウィンドウ消去
			@exif_(@On,  @MRActionState != 2,    32, @ObjSysCF02, _ObjSysCFRClickBtn03)			// セーブ画面
			@exif_(@On,  @MRActionState != 3,    33, @ObjSysCF02, _ObjSysCFRClickBtn04)			// ロード画面
			@exif_(@On,  @MRActionState != 4,    34, @ObjSysCF02, _ObjSysCFRClickBtn05)			// Config画面
			// 確認メッセージ
			@exif_(@Off, @Off,                   35, @ObjSysCF02, _ObjSysCFConDLBtn01)			// セーブ／ロード
			@exif_(@Off, @Off,                   36, @ObjSysCF02, _ObjSysCFConDLBtn02)			// クイックセーブ／クイックロード
			@exif_(@Off, @Off,                   37, @ObjSysCF02, _ObjSysCFConDLBtn03)			// 上書きセーブ
			@exif_(@Off, @Off,                   38, @ObjSysCF02, _ObjSysCFConDLBtn04)			// 前の選択肢に戻る
			@exif_(@Off, @Off,                   39, @ObjSysCF02, _ObjSysCFConDLBtn05)			// セーブデータの入れ替え
			@exif_(@Off, @Off,                   40, @ObjSysCF02, _ObjSysCFConDLBtn06)			// タイトルに戻る
			@exif_(@Off, @Off,                   41, @ObjSysCF02, _ObjSysCFConDLBtn07)			// セーブデータの削除
			@exif_(@Off, @Off,                   42, @ObjSysCF02, _ObjSysCFConDLBtn08)			// ゲームを終了する
			// その他の設定
			@exif_(@Off, @Off,                   43, @ObjSysCF02, _ObjSysCFESChk01)				// マウスホイールボタンの…
			@exif_(@Off, @Off,                   44, @ObjSysCF02, _ObjSysCFESChk02)				// 本プログラムの動作を…
			// ムービー設定
			@exif_(@Off, @Off,                   45, @ObjSysCF02, _ObjSysCFMovSetBtn00)

		}
		// テキスト--------------------------------------------------------------------------------------------------------
		elseif (@SysCFPage == 1)	{

			// フォント
			@exif_(@On,  @UseFontState != @FontA,  9, @ObjSysCF03, _ObjSysCFTtBtn01)
			@exif_(@On,  @UseFontState != @FontB, 10, @ObjSysCF03, _ObjSysCFTtBtn02)
			@exif_(@Off, @Off,                    11, @ObjSysCF03, _ObjSysCFTtBtn03)
			// ノーウェイト
			@exif_(@Off, @Off,                    12, @ObjSysCF03, _ObjSysCFTtChk01)
			// メッセージ速度
			@exif_(@Off, @Off,                    13, @ObjSysCF03, _ObjSysCFTtCtl01)
			@exif_Clip_(@Off, @Off,               14, @ObjSysCF03, _ObjSysCFTtBar01e, @ObjSysCF03, _ObjSysCFTtCtl01)
			@exif_(@Off, @Off,                    15, @ObjSysCF03, _ObjSysCFTtBar01)
			// 初期設定に戻す
			@exif_(@Off, @Off,                    16, @ObjSysCF03, _ObjSysCFTtBtn04)
			// ウィンドウ背景[赤]
			@exif_(@Off, @Off,                    17, @ObjSysCF03, _ObjSysCFTtCtl02)
			@exif_Clip_(@Off, @Off,               18, @ObjSysCF03, _ObjSysCFTtBar02e, @ObjSysCF03, _ObjSysCFTtCtl02)
			@exif_(@Off, @Off,                    19, @ObjSysCF03, _ObjSysCFTtBar02)
			// ウィンドウ背景[緑]
			@exif_(@Off, @Off,                    20, @ObjSysCF03, _ObjSysCFTtCtl03)
			@exif_Clip_(@Off, @Off,               21, @ObjSysCF03, _ObjSysCFTtBar03e, @ObjSysCF03, _ObjSysCFTtCtl03)
			@exif_(@Off, @Off,                    22, @ObjSysCF03, _ObjSysCFTtBar03)
			// ウィンドウ背景[青]
			@exif_(@Off, @Off,                    23, @ObjSysCF03, _ObjSysCFTtCtl04)
			@exif_Clip_(@Off, @Off,               24, @ObjSysCF03, _ObjSysCFTtBar04e, @ObjSysCF03, _ObjSysCFTtCtl04)
			@exif_(@Off, @Off,                    25, @ObjSysCF03, _ObjSysCFTtBar04)
			// ウィンドウ背景[透過度]
			@exif_(@Off, @Off,                    26, @ObjSysCF03, _ObjSysCFTtCtl05)
			@exif_Clip_(@Off, @Off,               27, @ObjSysCF03, _ObjSysCFTtBar05e, @ObjSysCF03, _ObjSysCFTtCtl05)
			@exif_(@Off, @Off,                    28, @ObjSysCF03, _ObjSysCFTtBar05)
			// 初期設定に戻す
			@exif_(@Off, @Off,                    29, @ObjSysCF03, _ObjSysCFTtBtn05)
			// オートモードチェック
			@exif_(@Off, @Off,                    30, @ObjSysCF03, _ObjSysCFTtChk02)
			// 文字時間スクロール
			@exif_(@Off, @Off,                    31, @ObjSysCF03, _ObjSysCFTtCtl06)
			@exif_Clip_(@Off, @Off,               32, @ObjSysCF03, _ObjSysCFTtBar06e, @ObjSysCF03, _ObjSysCFTtCtl06)
			@exif_(@Off, @Off,                    33, @ObjSysCF03, _ObjSysCFTtBar06)
			// 最小時間スクロール
			@exif_(@Off, @Off,                    34, @ObjSysCF03, _ObjSysCFTtCtl07)
			@exif_Clip_(@Off, @Off,               35, @ObjSysCF03, _ObjSysCFTtBar07e, @ObjSysCF03, _ObjSysCFTtCtl07)
			@exif_(@Off, @Off,                    36, @ObjSysCF03, _ObjSysCFTtBar07)
			// 初期設定に戻す
			@exif_(@Off, @Off,                    37, @ObjSysCF03, _ObjSysCFTtBtn06)

			// フォント状態の監視
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].set_string_param(26, 0, 0, 0, 0, 1, -1)

		}
		// サウンド--------------------------------------------------------------------------------------------------------
		elseif (@SysCFPage == 2)	{

			// 音量設定[全体]
			@exif_(@Off, @Off,       9, @ObjSysCF04, _ObjSysCFSndVolChk01)
			@exif_(@Off, @Off,      10, @ObjSysCF04, _ObjSysCFSndVolCtl01)
			@exif_Clip_(@Off, @Off, 11, @ObjSysCF04, _ObjSysCFSndVolBar01e, @ObjSysCF04, _ObjSysCFSndVolCtl01)
			@exif_(@Off, @Off,      12, @ObjSysCF04, _ObjSysCFSndVolBar01)
			// 音量設定[ＢＧＭ]
			@exif_(@Off, @Off,      13, @ObjSysCF04, _ObjSysCFSndVolChk02)
			@exif_(@Off, @Off,      14, @ObjSysCF04, _ObjSysCFSndVolCtl02)
			@exif_Clip_(@Off, @Off, 15, @ObjSysCF04, _ObjSysCFSndVolBar02e, @ObjSysCF04, _ObjSysCFSndVolCtl02)
			@exif_(@Off, @Off,      16, @ObjSysCF04, _ObjSysCFSndVolBar02)
			// 音量設定[ＢＧＭフェード]
			@exif_(@Off, @Off,      17, @ObjSysCF04, _ObjSysCFSndVolChk03)
			@exif_(@Off, @Off,      18, @ObjSysCF04, _ObjSysCFSndVolCtl03)
			@exif_Clip_(@Off, @Off, 19, @ObjSysCF04, _ObjSysCFSndVolBar03e, @ObjSysCF04, _ObjSysCFSndVolCtl03)
			@exif_(@Off, @Off,      20, @ObjSysCF04, _ObjSysCFSndVolBar03)
			// 音量設定[音声]
			@exif_(@Off, @Off,      21, @ObjSysCF04, _ObjSysCFSndVolChk04)
			@exif_(@Off, @Off,      22, @ObjSysCF04, _ObjSysCFSndVolCtl04)
			@exif_Clip_(@Off, @Off, 23, @ObjSysCF04, _ObjSysCFSndVolBar04e, @ObjSysCF04, _ObjSysCFSndVolCtl04)
			@exif_(@Off, @Off,      24, @ObjSysCF04, _ObjSysCFSndVolBar04)
			// 音量設定[効果音]
			@exif_(@Off, @Off,      25, @ObjSysCF04, _ObjSysCFSndVolChk05)
			@exif_(@Off, @Off,      26, @ObjSysCF04, _ObjSysCFSndVolCtl05)
			@exif_Clip_(@Off, @Off, 27, @ObjSysCF04, _ObjSysCFSndVolBar05e, @ObjSysCF04, _ObjSysCFSndVolCtl05)
			@exif_(@Off, @Off,      28, @ObjSysCF04, _ObjSysCFSndVolBar05)
			// 音量設定[システム音]
			@exif_(@Off, @Off,      29, @ObjSysCF04, _ObjSysCFSndVolChk06)
			@exif_(@Off, @Off,      30, @ObjSysCF04, _ObjSysCFSndVolCtl06)
			@exif_Clip_(@Off, @Off, 31, @ObjSysCF04, _ObjSysCFSndVolBar06e, @ObjSysCF04, _ObjSysCFSndVolCtl06)
			@exif_(@Off, @Off,      32, @ObjSysCF04, _ObjSysCFSndVolBar06)
			// 音量設定[ムービー]
			@exif_(@Off, @Off,      33, @ObjSysCF04, _ObjSysCFSndVolChk07)
			@exif_(@Off, @Off,      34, @ObjSysCF04, _ObjSysCFSndVolCtl07)
			@exif_Clip_(@Off, @Off, 35, @ObjSysCF04, _ObjSysCFSndVolBar07e, @ObjSysCF04, _ObjSysCFSndVolCtl07)
			@exif_(@Off, @Off,      36, @ObjSysCF04, _ObjSysCFSndVolBar07)
			// 初期設定
			@exif_(@Off, @Off,      37, @ObjSysCF04, _ObjSysCFSndVolBtn01)
			// ボリュームテスト再生ボタン
			@exif_(@Off, @Off,      38, @ObjSysCF04, _ObjSysCFSndVolBtn02)				// 全体
			@exif_(@Off, @Off,      39, @ObjSysCF04, _ObjSysCFSndVolBtn03)				// ＢＧＭ
			@exif_(@Off, @Off,      40, @ObjSysCF04, _ObjSysCFSndVolBtn04)				// ＢＧＭフェード
			@exif_(@Off, @Off,      41, @ObjSysCF04, _ObjSysCFSndVolBtn05)				// 音声
			@exif_(@Off, @Off,      42, @ObjSysCF04, _ObjSysCFSndVolBtn06)				// 効果音
			@exif_(@Off, @Off,      43, @ObjSysCF04, _ObjSysCFSndVolBtn07)				// システム音
			@exif_(@Off, @Off,      44, @ObjSysCF04, _ObjSysCFSndVolBtn08)				// ムービー
			// 音声の再生（声の再生中に次の文章に進んでも再生を続ける）
			@exif_(@Off, @Off,      45, @ObjSysCF04, _ObjSysCFSndVolBtn09)
			// キャラクター別音声[テスト再生ボタン]
			@exif_(@Off, @Off,      46, @ObjSysCF04, _ObjSysCFSndCVTestPlay01)			// キャラ０１[音無]
			@exif_(@Off, @Off,      47, @ObjSysCF04, _ObjSysCFSndCVTestPlay02)			// キャラ０２[ゆり]
			@exif_(@Off, @Off,      48, @ObjSysCF04, _ObjSysCFSndCVTestPlay03)			// キャラ０３[天使]
			@exif_(@Off, @Off,      49, @ObjSysCF04, _ObjSysCFSndCVTestPlay04)			// キャラ０４[日向]
			@exif_(@Off, @Off,      50, @ObjSysCF04, _ObjSysCFSndCVTestPlay05)			// キャラ０５[ユイ]
			@exif_(@Off, @Off,      51, @ObjSysCF04, _ObjSysCFSndCVTestPlay06)			// キャラ０６[岩沢]
			@exif_(@Off, @Off,      52, @ObjSysCF04, _ObjSysCFSndCVTestPlay07)			// キャラ０７[松下]
			@exif_(@Off, @Off,      53, @ObjSysCF04, _ObjSysCFSndCVTestPlay08)			// キャラ０８[野田]
			@exif_(@Off, @Off,      54, @ObjSysCF04, _ObjSysCFSndCVTestPlay09)			// キャラ０９[高松]
			@exif_(@Off, @Off,      55, @ObjSysCF04, _ObjSysCFSndCVTestPlay10)			// キャラ１０[大山]
			@exif_(@Off, @Off,      56, @ObjSysCF04, _ObjSysCFSndCVTestPlay11)			// キャラ１１[藤巻]
			@exif_(@Off, @Off,      57, @ObjSysCF04, _ObjSysCFSndCVTestPlay12)			// キャラ１２[ＴＫ]
			@exif_(@Off, @Off,      58, @ObjSysCF04, _ObjSysCFSndCVTestPlay13)			// キャラ１３[椎名]
			@exif_(@Off, @Off,      59, @ObjSysCF04, _ObjSysCFSndCVTestPlay14)			// キャラ１４[遊佐]
			@exif_(@Off, @Off,      60, @ObjSysCF04, _ObjSysCFSndCVTestPlay15)			// キャラ１５[ひさ子]
			@exif_(@Off, @Off,      61, @ObjSysCF04, _ObjSysCFSndCVTestPlay16)			// キャラ１６[関根]
			@exif_(@Off, @Off,      62, @ObjSysCF04, _ObjSysCFSndCVTestPlay17)			// キャラ１７[入江]
			@exif_(@Off, @Off,      63, @ObjSysCF04, _ObjSysCFSndCVTestPlay18)			// キャラ１８[チャー]
			@exif_(@Off, @Off,      64, @ObjSysCF04, _ObjSysCFSndCVTestPlay19)			// キャラ１９[竹山]
			@exif_(@Off, @Off,      65, @ObjSysCF04, _ObjSysCFSndCVTestPlay20)			// キャラ２０[直井]
			@exif_(@Off, @Off,      66, @ObjSysCF04, _ObjSysCFSndCVTestPlay21)			// キャラ２１[その他・男]
			@exif_(@Off, @Off,      67, @ObjSysCF04, _ObjSysCFSndCVTestPlay22)			// キャラ２２[その他・女]
			// キャラクター別音声[ボタン]
			@exif_(@Off, @Off,      68, @ObjSysCF04, _ObjSysCFSndCVBtn01)				// キャラ０１[音無]
			@exif_(@Off, @Off,      69, @ObjSysCF04, _ObjSysCFSndCVBtn02)				// キャラ０２[ゆり]
			@exif_(@Off, @Off,      70, @ObjSysCF04, _ObjSysCFSndCVBtn03)				// キャラ０３[天使]
			@exif_(@Off, @Off,      71, @ObjSysCF04, _ObjSysCFSndCVBtn04)				// キャラ０４[日向]
			@exif_(@Off, @Off,      72, @ObjSysCF04, _ObjSysCFSndCVBtn05)				// キャラ０５[ユイ]
			@exif_(@Off, @Off,      73, @ObjSysCF04, _ObjSysCFSndCVBtn06)				// キャラ０６[岩沢]
			@exif_(@Off, @Off,      74, @ObjSysCF04, _ObjSysCFSndCVBtn07)				// キャラ０７[松下]
			@exif_(@Off, @Off,      75, @ObjSysCF04, _ObjSysCFSndCVBtn08)				// キャラ０８[野田]
			@exif_(@Off, @Off,      76, @ObjSysCF04, _ObjSysCFSndCVBtn09)				// キャラ０９[高松]
			@exif_(@Off, @Off,      77, @ObjSysCF04, _ObjSysCFSndCVBtn10)				// キャラ１０[大山]
			@exif_(@Off, @Off,      78, @ObjSysCF04, _ObjSysCFSndCVBtn11)				// キャラ１１[藤巻]
			@exif_(@Off, @Off,      79, @ObjSysCF04, _ObjSysCFSndCVBtn12)				// キャラ１２[ＴＫ]
			@exif_(@Off, @Off,      80, @ObjSysCF04, _ObjSysCFSndCVBtn13)				// キャラ１３[椎名]
			@exif_(@Off, @Off,      81, @ObjSysCF04, _ObjSysCFSndCVBtn14)				// キャラ１４[遊佐]
			@exif_(@Off, @Off,      82, @ObjSysCF04, _ObjSysCFSndCVBtn15)				// キャラ１５[ひさ子]
			@exif_(@Off, @Off,      83, @ObjSysCF04, _ObjSysCFSndCVBtn16)				// キャラ１６[関根]
			@exif_(@Off, @Off,      84, @ObjSysCF04, _ObjSysCFSndCVBtn17)				// キャラ１７[入江]
			@exif_(@Off, @Off,      85, @ObjSysCF04, _ObjSysCFSndCVBtn18)				// キャラ１８[チャー]
			@exif_(@Off, @Off,      86, @ObjSysCF04, _ObjSysCFSndCVBtn19)				// キャラ１９[竹山]
			@exif_(@Off, @Off,      87, @ObjSysCF04, _ObjSysCFSndCVBtn20)				// キャラ２０[直井]
			@exif_(@Off, @Off,      88, @ObjSysCF04, _ObjSysCFSndCVBtn21)				// キャラ２１[その他・男]
			@exif_(@Off, @Off,      89, @ObjSysCF04, _ObjSysCFSndCVBtn22)				// キャラ２２[その他・女]
			// キャラクター別音声[ボリュームＣＴＬ]
			@exif_(@Off, @Off,      90, @ObjSysCF04, _ObjSysCFSndCVCtrl01)				// キャラ０１[音無]
			@exif_(@Off, @Off,      91, @ObjSysCF04, _ObjSysCFSndCVCtrl02)				// キャラ０２[ゆり]
			@exif_(@Off, @Off,      92, @ObjSysCF04, _ObjSysCFSndCVCtrl03)				// キャラ０３[天使]
			@exif_(@Off, @Off,      93, @ObjSysCF04, _ObjSysCFSndCVCtrl04)				// キャラ０４[日向]
			@exif_(@Off, @Off,      94, @ObjSysCF04, _ObjSysCFSndCVCtrl05)				// キャラ０５[ユイ]
			@exif_(@Off, @Off,      95, @ObjSysCF04, _ObjSysCFSndCVCtrl06)				// キャラ０６[岩沢]
			@exif_(@Off, @Off,      96, @ObjSysCF04, _ObjSysCFSndCVCtrl07)				// キャラ０７[松下]
			@exif_(@Off, @Off,      97, @ObjSysCF04, _ObjSysCFSndCVCtrl08)				// キャラ０８[野田]
			@exif_(@Off, @Off,      98, @ObjSysCF04, _ObjSysCFSndCVCtrl09)				// キャラ０９[高松]
			@exif_(@Off, @Off,      99, @ObjSysCF04, _ObjSysCFSndCVCtrl10)				// キャラ１０[大山]
			@exif_(@Off, @Off,     100, @ObjSysCF04, _ObjSysCFSndCVCtrl11)				// キャラ１１[藤巻]
			@exif_(@Off, @Off,     101, @ObjSysCF04, _ObjSysCFSndCVCtrl12)				// キャラ１２[ＴＫ]
			@exif_(@Off, @Off,     102, @ObjSysCF04, _ObjSysCFSndCVCtrl13)				// キャラ１３[椎名]
			@exif_(@Off, @Off,     103, @ObjSysCF04, _ObjSysCFSndCVCtrl14)				// キャラ１４[遊佐]
			@exif_(@Off, @Off,     104, @ObjSysCF04, _ObjSysCFSndCVCtrl15)				// キャラ１５[ひさ子]
			@exif_(@Off, @Off,     105, @ObjSysCF04, _ObjSysCFSndCVCtrl16)				// キャラ１６[関根]
			@exif_(@Off, @Off,     106, @ObjSysCF04, _ObjSysCFSndCVCtrl17)				// キャラ１７[入江]
			@exif_(@Off, @Off,     107, @ObjSysCF04, _ObjSysCFSndCVCtrl18)				// キャラ１８[チャー]
			@exif_(@Off, @Off,     108, @ObjSysCF04, _ObjSysCFSndCVCtrl19)				// キャラ１９[竹山]
			@exif_(@Off, @Off,     109, @ObjSysCF04, _ObjSysCFSndCVCtrl20)				// キャラ２０[直井]
			@exif_(@Off, @Off,     110, @ObjSysCF04, _ObjSysCFSndCVCtrl21)				// キャラ２１[その他・男]
			@exif_(@Off, @Off,     111, @ObjSysCF04, _ObjSysCFSndCVCtrl22)				// キャラ２２[その他・女]
			// キャラクター別音声[ボリュームバー] - Clip
			@exif_Clip_(@Off, @Off, 112, @ObjSysCF04, _ObjSysCFSndCVBar01e, @ObjSysCF04, _ObjSysCFSndCVCtrl01)				// キャラ０１[音無]
			@exif_Clip_(@Off, @Off, 113, @ObjSysCF04, _ObjSysCFSndCVBar02e, @ObjSysCF04, _ObjSysCFSndCVCtrl02)				// キャラ０２[ゆり]
			@exif_Clip_(@Off, @Off, 114, @ObjSysCF04, _ObjSysCFSndCVBar03e, @ObjSysCF04, _ObjSysCFSndCVCtrl03)				// キャラ０３[天使]
			@exif_Clip_(@Off, @Off, 115, @ObjSysCF04, _ObjSysCFSndCVBar04e, @ObjSysCF04, _ObjSysCFSndCVCtrl04)				// キャラ０４[日向]
			@exif_Clip_(@Off, @Off, 116, @ObjSysCF04, _ObjSysCFSndCVBar05e, @ObjSysCF04, _ObjSysCFSndCVCtrl05)				// キャラ０５[ユイ]
			@exif_Clip_(@Off, @Off, 117, @ObjSysCF04, _ObjSysCFSndCVBar06e, @ObjSysCF04, _ObjSysCFSndCVCtrl06)				// キャラ０６[岩沢]
			@exif_Clip_(@Off, @Off, 118, @ObjSysCF04, _ObjSysCFSndCVBar07e, @ObjSysCF04, _ObjSysCFSndCVCtrl07)				// キャラ０７[松下]
			@exif_Clip_(@Off, @Off, 119, @ObjSysCF04, _ObjSysCFSndCVBar08e, @ObjSysCF04, _ObjSysCFSndCVCtrl08)				// キャラ０８[野田]
			@exif_Clip_(@Off, @Off, 120, @ObjSysCF04, _ObjSysCFSndCVBar09e, @ObjSysCF04, _ObjSysCFSndCVCtrl09)				// キャラ０９[高松]
			@exif_Clip_(@Off, @Off, 121, @ObjSysCF04, _ObjSysCFSndCVBar10e, @ObjSysCF04, _ObjSysCFSndCVCtrl10)				// キャラ１０[大山]
			@exif_Clip_(@Off, @Off, 122, @ObjSysCF04, _ObjSysCFSndCVBar11e, @ObjSysCF04, _ObjSysCFSndCVCtrl11)				// キャラ１１[藤巻]
			@exif_Clip_(@Off, @Off, 123, @ObjSysCF04, _ObjSysCFSndCVBar12e, @ObjSysCF04, _ObjSysCFSndCVCtrl12)				// キャラ１２[ＴＫ]
			@exif_Clip_(@Off, @Off, 124, @ObjSysCF04, _ObjSysCFSndCVBar13e, @ObjSysCF04, _ObjSysCFSndCVCtrl13)				// キャラ１３[椎名]
			@exif_Clip_(@Off, @Off, 125, @ObjSysCF04, _ObjSysCFSndCVBar14e, @ObjSysCF04, _ObjSysCFSndCVCtrl14)				// キャラ１４[遊佐]
			@exif_Clip_(@Off, @Off, 126, @ObjSysCF04, _ObjSysCFSndCVBar15e, @ObjSysCF04, _ObjSysCFSndCVCtrl15)				// キャラ１５[ひさ子]
			@exif_Clip_(@Off, @Off, 127, @ObjSysCF04, _ObjSysCFSndCVBar16e, @ObjSysCF04, _ObjSysCFSndCVCtrl16)				// キャラ１６[関根]
			@exif_Clip_(@Off, @Off, 128, @ObjSysCF04, _ObjSysCFSndCVBar17e, @ObjSysCF04, _ObjSysCFSndCVCtrl17)				// キャラ１７[入江]
			@exif_Clip_(@Off, @Off, 129, @ObjSysCF04, _ObjSysCFSndCVBar18e, @ObjSysCF04, _ObjSysCFSndCVCtrl18)				// キャラ１８[チャー]
			@exif_Clip_(@Off, @Off, 130, @ObjSysCF04, _ObjSysCFSndCVBar19e, @ObjSysCF04, _ObjSysCFSndCVCtrl19)				// キャラ１９[竹山]
			@exif_Clip_(@Off, @Off, 131, @ObjSysCF04, _ObjSysCFSndCVBar20e, @ObjSysCF04, _ObjSysCFSndCVCtrl20)				// キャラ２０[直井]
			@exif_Clip_(@Off, @Off, 132, @ObjSysCF04, _ObjSysCFSndCVBar21e, @ObjSysCF04, _ObjSysCFSndCVCtrl21)				// キャラ２１[その他・男]
			@exif_Clip_(@Off, @Off, 133, @ObjSysCF04, _ObjSysCFSndCVBar22e, @ObjSysCF04, _ObjSysCFSndCVCtrl22)				// キャラ２２[その他・女]
			// キャラクター別音声[ボリュームバー]
			@exif_(@Off, @Off, 134, @ObjSysCF04, _ObjSysCFSndCVBar01)				// キャラ０１[音無]
			@exif_(@Off, @Off, 135, @ObjSysCF04, _ObjSysCFSndCVBar02)				// キャラ０２[ゆり]
			@exif_(@Off, @Off, 136, @ObjSysCF04, _ObjSysCFSndCVBar03)				// キャラ０３[天使]
			@exif_(@Off, @Off, 137, @ObjSysCF04, _ObjSysCFSndCVBar04)				// キャラ０４[日向]
			@exif_(@Off, @Off, 138, @ObjSysCF04, _ObjSysCFSndCVBar05)				// キャラ０５[ユイ]
			@exif_(@Off, @Off, 139, @ObjSysCF04, _ObjSysCFSndCVBar06)				// キャラ０６[岩沢]
			@exif_(@Off, @Off, 140, @ObjSysCF04, _ObjSysCFSndCVBar07)				// キャラ０７[松下]
			@exif_(@Off, @Off, 141, @ObjSysCF04, _ObjSysCFSndCVBar08)				// キャラ０８[野田]
			@exif_(@Off, @Off, 142, @ObjSysCF04, _ObjSysCFSndCVBar09)				// キャラ０９[高松]
			@exif_(@Off, @Off, 143, @ObjSysCF04, _ObjSysCFSndCVBar10)				// キャラ１０[大山]
			@exif_(@Off, @Off, 144, @ObjSysCF04, _ObjSysCFSndCVBar11)				// キャラ１１[藤巻]
			@exif_(@Off, @Off, 145, @ObjSysCF04, _ObjSysCFSndCVBar12)				// キャラ１２[ＴＫ]
			@exif_(@Off, @Off, 146, @ObjSysCF04, _ObjSysCFSndCVBar13)				// キャラ１３[椎名]
			@exif_(@Off, @Off, 147, @ObjSysCF04, _ObjSysCFSndCVBar14)				// キャラ１４[遊佐]
			@exif_(@Off, @Off, 148, @ObjSysCF04, _ObjSysCFSndCVBar15)				// キャラ１５[ひさ子]
			@exif_(@Off, @Off, 149, @ObjSysCF04, _ObjSysCFSndCVBar16)				// キャラ１６[関根]
			@exif_(@Off, @Off, 150, @ObjSysCF04, _ObjSysCFSndCVBar17)				// キャラ１７[入江]
			@exif_(@Off, @Off, 151, @ObjSysCF04, _ObjSysCFSndCVBar18)				// キャラ１８[チャー]
			@exif_(@Off, @Off, 152, @ObjSysCF04, _ObjSysCFSndCVBar19)				// キャラ１９[竹山]
			@exif_(@Off, @Off, 153, @ObjSysCF04, _ObjSysCFSndCVBar20)				// キャラ２０[直井]
			@exif_(@Off, @Off, 154, @ObjSysCF04, _ObjSysCFSndCVBar21)				// キャラ２１[その他・男]
			@exif_(@Off, @Off, 155, @ObjSysCF04, _ObjSysCFSndCVBar22)				// キャラ２２[その他・女]
			// キャラクター音声の再生
			@exif_(@Off, @Off, 156, @ObjSysCF04, _ObjSysCFSndVolBtn10)				// 全てＯＮ
			@exif_(@Off, @Off, 157, @ObjSysCF04, _ObjSysCFSndVolBtn11)				// 全てＯＦＦ
			// 初期設定に戻す
			@exif_(@Off, @Off, 158, @ObjSysCF04, _ObjSysCFSndVolBtn12)

		}

		// Ｃｔｌ専用処理
		if (@S_CTL_BAR_CTLACTIVE == @On)	{
			@MSCHK = @S_CTL_BAR_CTLSTATE
		}

		// マウスボタン入力判定
		$MsBtnInputDecide
		if ($break_switch == @On)	{
			// 右クリックによりゲームに戻る
			@se_play(002)
			break
		}

		// ＡＬＴ＋ＥＮＴＥＲで画面モード変更対策
		@GetWindowState(@WWSizeState)

		// 状態セット
		@MsStateSet(0, 180)

		// マウスボタン状態
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn01].patno = $obj_btn_state[0]				// システムボタン
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn02].patno = $obj_btn_state[1]				// テキストボタン
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn03].patno = $obj_btn_state[2]				// サウンドボタン
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn04].patno = $obj_btn_state[3]				// ゲームを終了
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn05].patno = $obj_btn_state[4]				// タイトルに戻る
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn06].patno = $obj_btn_state[5]				// セーブ
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn07].patno = $obj_btn_state[6]				// ロード
        @ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn08].patno = @Operate            				// コンフィグ
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn09].patno = $obj_btn_state[8]				// ゲームに戻る

		// コンフィグボタン設定
		@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFBtn01+@SysCFPage].patno = @Operate

		// システムページ
		if (@SysCFPage == 0)	{
			// 画面モード
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow01].patno = $obj_btn_state[9] 		// ウィンドウ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow02].patno = $obj_btn_state[10]		// フルスクリーン
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow03].patno = $obj_btn_state[11]		// 詳細設定
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow01+@WWSizeState].patno = @Operate
			// 現在地表示
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation01].patno = @ObjBtnState[12]		// 表示する
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation02].patno = @ObjBtnState[13]		// 表示しない
			    if (@SpotDispState == @On)  {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation01].patno = @Operate}
			elseif (@SpotDispState == @Off) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFLocation02].patno = @Operate}
			// 演出速度[キャラクター]
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBsFadeMode01].patno = @ObjBtnState[14]		// 通常
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBsFadeMode03].patno = @ObjBtnState[15]		// 瞬時
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBsFadeMode01+@BsFadeState].patno = @Operate
			// 演出速度[背景]
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBgFadeMode01].patno = @ObjBtnState[16]		// 通常
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBgFadeMode03].patno = @ObjBtnState[17]		// 瞬時
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFBgFadeMode01+@BgFadeState].patno = @Operate
			// 演出速度[イベントＣＧ]
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFEvFadeMode01].patno = @ObjBtnState[18]		// 通常
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFEvFadeMode03].patno = @ObjBtnState[19]		// 瞬時
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFEvFadeMode01+@EvFadeState].patno = @Operate
			// 演出速度[メッセージウィンドウ]
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMwFadeMode01].patno = @ObjBtnState[20]		// 通常
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMwFadeMode03].patno = @ObjBtnState[21]		// 瞬時
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMwFadeMode01+@MwFadeState].patno = @Operate
			// 演出速度[システムメニュー]
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMeFadeMode01].patno = @ObjBtnState[22]		// 通常
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMeFadeMode03].patno = @ObjBtnState[23]		// 瞬時
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMeFadeMode01+@MeFadeState].patno = @Operate
			// エモーション表示
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn01].patno = @ObjBtnState[24]			// ＯＮ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn02].patno = @ObjBtnState[25]			// ＯＦＦ
			    if (@EmDispState == @On)  {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn01].patno = @Operate}
			elseif (@EmDispState == @Off) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFDSBtn02].patno = @Operate}
			// メッセージスキップ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn01].patno = @ObjBtnState[26]		// 既読のみ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn02].patno = @ObjBtnState[27]		// 未読も含む
			    if (@MsgSkipState == @Off)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn01].patno = @Operate}
			elseif (@MsgSkipState == @On)	{@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMSSkipBtn02].patno = @Operate}
			// オートセーブ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn01].patno = @ObjBtnState[28]		// 使用する
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn02].patno = @ObjBtnState[29]		// 使用しない
			    if (@EsAutoSave == @On)  {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn01].patno = @Operate}
			elseif (@EsAutoSave == @Off) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFASaveBtn02].patno = @Operate}
			// 実績システム（仮）
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn01].patno = @ObjBtnState[46]		// 表示する		// 番号注意
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn02].patno = @ObjBtnState[47]		// 表示しない	// 
			    if (@実績獲得表示する == @On)  {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn01].patno = @Operate}
			elseif (@実績獲得表示する == @Off) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFResultBtn02].patno = @Operate}
			// 右クリック動作
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn01].patno = @ObjBtnState[30]		// クイックメニュー
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn02].patno = @ObjBtnState[31]		// ウィンドウ消去
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn03].patno = @ObjBtnState[32]		// セーブ画面
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn04].patno = @ObjBtnState[33]		// ロード画面
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn05].patno = @ObjBtnState[34]		// Config画面
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFRClickBtn01+@MRActionState].patno = @Operate
			// 確認ダイアログ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn01].patno = @ObjBtnState[35]		// セーブ／ロード
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn02].patno = @ObjBtnState[36]		// クイックセーブ／クイックロード
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn03].patno = @ObjBtnState[37]		// 上書きセーブ
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn04].patno = @ObjBtnState[38]		// 前の選択肢に戻る
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn05].patno = @ObjBtnState[39]		// セーブデータの入れ替え
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn06].patno = @ObjBtnState[40]		// タイトルに戻る
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn07].patno = @ObjBtnState[41]		// セーブデータの削除
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn08].patno = @ObjBtnState[42]		// ゲームを終了する
			for ($_L[0] = 0, $_L[0] < 8, $_L[0] += 1)	{
				if (@CdState[+$_L[0]] == @On) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFConDLBtn01+$_L[0]].patno += @Operate}
			}
			// その他の設定
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk01].patno = @ObjBtnState[43]			// マウスホイールボタンの…
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk02].patno = @ObjBtnState[44]			// 本プログラムの動作を…
			if (@EsState[+3]  == @On) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk01].patno += @Operate}
			if (@EsState[+0]  == @On) {@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFESChk02].patno += @Operate}
			// ムービー設定
			@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFMovSetBtn00].patno = @ObjBtnState[45]
		}
		// テキストページ
		elseif (@SysCFPage == 1)	{
			// フォント
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn01].patno = @ObjBtnState[9]			// フォントＡ
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn02].patno = @ObjBtnState[10]			// フォントＢ
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn03].patno = @ObjBtnState[11]			// その他のフォント
			@UseFontState = syscom.get_font_name
			    if (@UseFontState == @FontA) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn01].patno =  @Operate}
			elseif (@UseFontState == @FontB) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn02].patno =  @Operate}
			else                             {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn03].patno += @Operate}
			// ノーウェイト
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk01].patno = @ObjBtnState[12]
			if (@MSChkState == @On) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk01].patno += @Operate}
			// メッセージ速度
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl01 ].patno = @ObjBtnState[13]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].patno = @ObjBtnState[14] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01 ].patno = @ObjBtnState[15]
			// 初期設定に戻す
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn04 ].patno = @ObjBtnState[16]
			// ウィンドウ背景[赤]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl02 ].patno = @ObjBtnState[17]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].patno = @ObjBtnState[18] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02 ].patno = @ObjBtnState[19]
			// ウィンドウ背景[緑]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl03 ].patno = @ObjBtnState[20]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].patno = @ObjBtnState[21] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03 ].patno = @ObjBtnState[22]
			// ウィンドウ背景[青]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl04 ].patno = @ObjBtnState[23]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].patno = @ObjBtnState[24] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04 ].patno = @ObjBtnState[25]
			// ウィンドウ背景[透過度]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl05 ].patno = @ObjBtnState[26]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].patno = @ObjBtnState[27] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05 ].patno = @ObjBtnState[28]
			// 初期設定に戻す
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn05 ].patno = @ObjBtnState[29]
			// オートモードチェック
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk02 ].patno = @ObjBtnState[30]
			if (@AmCheckState == @On) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtChk02].patno += @Operate}
			// オートモード[文字時間]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06 ].patno = @ObjBtnState[31]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].patno = @ObjBtnState[32] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06 ].patno = @ObjBtnState[33]
			// オートモード[最小時間]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07 ].patno = @ObjBtnState[34]
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].patno = @ObjBtnState[35] + 4	// ※注意
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07 ].patno = @ObjBtnState[36]
			// 初期設定に戻す
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBtn06 ].patno = @ObjBtnState[37]
		}
		// サウンドページ
		elseif (@SysCFPage == 2)	{
			// 音量設定[全体]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk01 ].patno = @ObjBtnState[9]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl01 ].patno = @ObjBtnState[10]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].patno = @ObjBtnState[11] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01 ].patno = @ObjBtnState[12]
			if (@AllChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk01].patno += @Operate}
			// 音量設定[ＢＧＭ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk02 ].patno = @ObjBtnState[13]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl02 ].patno = @ObjBtnState[14]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].patno = @ObjBtnState[15] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02 ].patno = @ObjBtnState[16]
			if (@BgmChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk02].patno += @Operate}
			// 音量設定[ＢＧＭフェード]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk03 ].patno = @ObjBtnState[17]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl03 ].patno = @ObjBtnState[18]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].patno = @ObjBtnState[19] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03 ].patno = @ObjBtnState[20]
			if (@BFadeChk01State == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk03].patno += @Operate}
			// 音量設定[音声]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk04 ].patno = @ObjBtnState[21]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl04 ].patno = @ObjBtnState[22]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].patno = @ObjBtnState[23] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04 ].patno = @ObjBtnState[24]
			if (@VoiceChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk04].patno += @Operate}
			// 音量設定[効果音]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk05 ].patno = @ObjBtnState[25]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl05 ].patno = @ObjBtnState[26]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].patno = @ObjBtnState[27] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05 ].patno = @ObjBtnState[28]
			if (@SeChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk05].patno += @Operate}
			// 音量設定[システム]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk06 ].patno = @ObjBtnState[29]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl06 ].patno = @ObjBtnState[30]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].patno = @ObjBtnState[31] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06 ].patno = @ObjBtnState[32]
			if (@SysChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk06].patno += @Operate}
			// 音量設定[ムービー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk07 ].patno = @ObjBtnState[33]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl07 ].patno = @ObjBtnState[34]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].patno = @ObjBtnState[35] + 4 // ※注意
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07 ].patno = @ObjBtnState[36]
			if (@MovChkState == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolChk07].patno += @Operate}
			// 初期設定に戻す
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn01].patno = @ObjBtnState[37]
			// ボリュームテスト再生ボタン
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn02].patno = @ObjBtnState[38]		// 全体
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn03].patno = @ObjBtnState[39]		// ＢＧＭ
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn04].patno = @ObjBtnState[40]		// ＢＧＭフェード
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn05].patno = @ObjBtnState[41]		// 音声
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn06].patno = @ObjBtnState[42]		// 効果音
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn07].patno = @ObjBtnState[43]		// システム音
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn08].patno = @ObjBtnState[44]		// ムービー
			// 音声の再生（声の再生中に次の文章に進んでも再生を続ける）
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn09].patno = @ObjBtnState[45]
			if (@EsState[4] == @On)	{@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn09].patno += @Operate}

			// キャラクター別音声[テスト再生ボタン]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay01].patno = @ObjBtnState[46]	// キャラ０１[音無]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay02].patno = @ObjBtnState[47]	// キャラ０２[ゆり]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay03].patno = @ObjBtnState[48]	// キャラ０３[天使]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay04].patno = @ObjBtnState[49]	// キャラ０４[日向]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay05].patno = @ObjBtnState[50]	// キャラ０５[ユイ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay06].patno = @ObjBtnState[51]	// キャラ０６[岩沢]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay07].patno = @ObjBtnState[52]	// キャラ０７[松下]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay08].patno = @ObjBtnState[53]	// キャラ０８[野田]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay09].patno = @ObjBtnState[54]	// キャラ０９[高松]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay10].patno = @ObjBtnState[55]	// キャラ１０[大山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay11].patno = @ObjBtnState[56]	// キャラ１１[藤巻]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay12].patno = @ObjBtnState[57]	// キャラ１２[ＴＫ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay13].patno = @ObjBtnState[58]	// キャラ１３[椎名]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay14].patno = @ObjBtnState[59]	// キャラ１４[遊佐]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay15].patno = @ObjBtnState[60]	// キャラ１５[ひさ子]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay16].patno = @ObjBtnState[61]	// キャラ１６[関根]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay17].patno = @ObjBtnState[62]	// キャラ１７[入江]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay18].patno = @ObjBtnState[63]	// キャラ１８[チャー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay19].patno = @ObjBtnState[64]	// キャラ１９[竹山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay20].patno = @ObjBtnState[65]	// キャラ２０[直井]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay21].patno = @ObjBtnState[66]	// キャラ２１[その他・男]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVTestPlay22].patno = @ObjBtnState[67]	// キャラ２２[その他・女]
			// キャラクター別音声[ボタン]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn01].patno = @ObjBtnState[68]		// キャラ０１[音無]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn02].patno = @ObjBtnState[69]		// キャラ０２[ゆり]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn03].patno = @ObjBtnState[70]		// キャラ０３[天使]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn04].patno = @ObjBtnState[71]		// キャラ０４[日向]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn05].patno = @ObjBtnState[72]		// キャラ０５[ユイ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn06].patno = @ObjBtnState[73]		// キャラ０６[岩沢]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn07].patno = @ObjBtnState[74]		// キャラ０７[松下]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn08].patno = @ObjBtnState[75]		// キャラ０８[野田]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn09].patno = @ObjBtnState[76]		// キャラ０９[高松]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn10].patno = @ObjBtnState[77]		// キャラ１０[大山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn11].patno = @ObjBtnState[78]		// キャラ１１[藤巻]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn12].patno = @ObjBtnState[79]		// キャラ１２[ＴＫ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn13].patno = @ObjBtnState[80]		// キャラ１３[椎名]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn14].patno = @ObjBtnState[81]		// キャラ１４[遊佐]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn15].patno = @ObjBtnState[82]		// キャラ１５[ひさ子]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn16].patno = @ObjBtnState[83]		// キャラ１６[関根]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn17].patno = @ObjBtnState[84]		// キャラ１７[入江]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn18].patno = @ObjBtnState[85]		// キャラ１８[チャー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn19].patno = @ObjBtnState[86]		// キャラ１９[竹山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn20].patno = @ObjBtnState[87]		// キャラ２０[直井]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn21].patno = @ObjBtnState[88]		// キャラ２１[その他・男]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn22].patno = @ObjBtnState[89]		// キャラ２２[その他・女]
			for ($_L[0] = 0, $_L[0] < 22, $_L[0] += 1)	{
				if (@CVState[+$_L[0]] == @On) {@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn01+$_L[0]].patno += @Operate}
			}
			// かなでの名前処理
			if (@かなでの音声ボタン変更 == @On)	{
				@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBtn03].patno += 8
			}

			// キャラクター別音声[ボリュームＣＴＬ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl01].patno = @ObjBtnState[90]		// キャラ０１[音無]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl02].patno = @ObjBtnState[91]		// キャラ０２[ゆり]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl03].patno = @ObjBtnState[92]		// キャラ０３[天使]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl04].patno = @ObjBtnState[93]		// キャラ０４[日向]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl05].patno = @ObjBtnState[94]		// キャラ０５[ユイ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl06].patno = @ObjBtnState[95]		// キャラ０６[岩沢]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl07].patno = @ObjBtnState[96]		// キャラ０７[松下]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl08].patno = @ObjBtnState[97]		// キャラ０８[野田]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl09].patno = @ObjBtnState[98]		// キャラ０９[高松]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl10].patno = @ObjBtnState[99]		// キャラ１０[大山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl11].patno = @ObjBtnState[100]		// キャラ１１[藤巻]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl12].patno = @ObjBtnState[101]		// キャラ１２[ＴＫ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl13].patno = @ObjBtnState[102]		// キャラ１３[椎名]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl14].patno = @ObjBtnState[103]		// キャラ１４[遊佐]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl15].patno = @ObjBtnState[104]		// キャラ１５[ひさ子]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl16].patno = @ObjBtnState[105]		// キャラ１６[関根]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl17].patno = @ObjBtnState[106]		// キャラ１７[入江]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl18].patno = @ObjBtnState[107]		// キャラ１８[チャー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl19].patno = @ObjBtnState[108]		// キャラ１９[竹山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl20].patno = @ObjBtnState[109]		// キャラ２０[直井]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl21].patno = @ObjBtnState[110]		// キャラ２１[その他・男]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl22].patno = @ObjBtnState[111]		// キャラ２２[その他・女]
			// キャラクター別音声[ボリュームバー] - Clip
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].patno = @ObjBtnState[112] + 4	// キャラ０１[音無]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].patno = @ObjBtnState[113] + 4	// キャラ０２[ゆり]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].patno = @ObjBtnState[114] + 4	// キャラ０３[天使]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].patno = @ObjBtnState[115] + 4	// キャラ０４[日向]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].patno = @ObjBtnState[116] + 4	// キャラ０５[ユイ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].patno = @ObjBtnState[117] + 4	// キャラ０６[岩沢]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].patno = @ObjBtnState[118] + 4	// キャラ０７[松下]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].patno = @ObjBtnState[119] + 4	// キャラ０８[野田]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].patno = @ObjBtnState[120] + 4	// キャラ０９[高松]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].patno = @ObjBtnState[121] + 4	// キャラ１０[大山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].patno = @ObjBtnState[122] + 4	// キャラ１１[藤巻]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].patno = @ObjBtnState[123] + 4	// キャラ１２[ＴＫ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].patno = @ObjBtnState[124] + 4	// キャラ１３[椎名]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].patno = @ObjBtnState[125] + 4	// キャラ１４[遊佐]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].patno = @ObjBtnState[126] + 4	// キャラ１５[ひさ子]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].patno = @ObjBtnState[127] + 4	// キャラ１６[関根]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].patno = @ObjBtnState[128] + 4	// キャラ１７[入江]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].patno = @ObjBtnState[129] + 4	// キャラ１８[チャー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].patno = @ObjBtnState[130] + 4	// キャラ１９[竹山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].patno = @ObjBtnState[131] + 4	// キャラ２０[直井]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].patno = @ObjBtnState[132] + 4	// キャラ２１[その他・男]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].patno = @ObjBtnState[133] + 4	// キャラ２２[その他・女]
			// キャラクター別音声[ボリュームバー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01].patno = @ObjBtnState[134]		// キャラ０１[音無]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02].patno = @ObjBtnState[135]		// キャラ０２[ゆり]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03].patno = @ObjBtnState[136]		// キャラ０３[天使]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04].patno = @ObjBtnState[137]		// キャラ０４[日向]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05].patno = @ObjBtnState[138]		// キャラ０５[ユイ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06].patno = @ObjBtnState[139]		// キャラ０６[岩沢]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07].patno = @ObjBtnState[140]		// キャラ０７[松下]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08].patno = @ObjBtnState[141]		// キャラ０８[野田]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09].patno = @ObjBtnState[142]		// キャラ０９[高松]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10].patno = @ObjBtnState[143]		// キャラ１０[大山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11].patno = @ObjBtnState[144]		// キャラ１１[藤巻]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12].patno = @ObjBtnState[145]		// キャラ１２[ＴＫ]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13].patno = @ObjBtnState[146]		// キャラ１３[椎名]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14].patno = @ObjBtnState[147]		// キャラ１４[遊佐]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15].patno = @ObjBtnState[148]		// キャラ１５[ひさ子]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16].patno = @ObjBtnState[149]		// キャラ１６[関根]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17].patno = @ObjBtnState[150]		// キャラ１７[入江]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18].patno = @ObjBtnState[151]		// キャラ１８[チャー]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19].patno = @ObjBtnState[152]		// キャラ１９[竹山]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20].patno = @ObjBtnState[153]		// キャラ２０[直井]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21].patno = @ObjBtnState[154]		// キャラ２１[その他・男]
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22].patno = @ObjBtnState[155]		// キャラ２２[その他・女]
			// キャラクター音声の再生
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn10].patno = @ObjBtnState[156]		// 全てＯＮ
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn11].patno = @ObjBtnState[157]		// 全てＯＦＦ
			// 初期設定に戻す
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBtn12].patno = @ObjBtnState[158]
		}

		// マウスホイール
		if (mouse.wheel > 0)	{
			@MSWHL_STATE = 1 @MSCHK = 178
			@MSBTN_RESULT = @DECIDE
		}
		elseif (mouse.wheel < 0)	{
			@MSWHL_STATE = -1 @MSCHK = 179
			@MSBTN_RESULT = @DECIDE
		}

		// --------------------------------------------------------------------------------------------------
		// スライダー処理
		// --------------------------------------------------------------------------------------------------


		// テキスト速度
		if ((@SysCFPage == 1) && (@MSCHK >= 13) && (@MSCHK <= 15))	{
			@MSP_SET_PREV = @MSP_SET
			@MSP_CTL_BAR_SET_PREV = @MSP_CTL_BAR_SET
			$TTSlideBar(0, @MSCHK)
			@MSP_SET = math.timetable(@MSP_CTL_BAR_SET, 0, 100, [0, 255, 0])	// 遅(100) <----> 速(0)
			syscom.set_message_speed(@MSP_SET)
			@MSState = @MSP_SET
			// マウスヒットにおけるテキスト再表示設定
			if (@MSP_TOUCH_STATE01 == @Off)	{
				@MSP_SET_PREV = @MSP_SET
				@MSP_TOUCH_STATE01 = @On
			}
			// 初回ヒットでの初期化は無視
			if (@MSP_TOUCH_STATE02 == @Off)	{
				@MSP_TOUCH_STATE02 = @On
			}
			// スピードが変更された場合
			elseif ((@MSP_CTL_BAR_SET_PREV != @MSP_CTL_BAR_SET) && (@MSP_TOUCH_STATE01 == @On)){
				counter[@CNoMSP01].reset
				counter[@CNoMSP02].reset
				@MSP_TOUCH_STATE03 = @Off
			}
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl01].x
		}

		// ウィンドウ背景[赤]
		elseif ((@SysCFPage == 1) && (@MSCHK >= 17) && (@MSCHK <= 19))	{
			$TTSlideBar(1, @MSCHK)
			@WBState01 = @WB_R_SET
			syscom.set_filter_color_r(@WBState01)
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_r = syscom.get_filter_color_r
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl02].x
		}
		// ウィンドウ背景[緑]
		elseif ((@SysCFPage == 1) && (@MSCHK >= 20) && (@MSCHK <= 22))	{
			$TTSlideBar(2, @MSCHK)
			@WBState02 = @WB_G_SET
			syscom.set_filter_color_g(@WBState02)
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_g = syscom.get_filter_color_g
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl03].x
		}
		// ウィンドウ背景[青]
		elseif ((@SysCFPage == 1) && (@MSCHK >= 23) && (@MSCHK <= 25))	{
			$TTSlideBar(3, @MSCHK)
			@WBState03 = @WB_B_SET
			syscom.set_filter_color_b(@WBState03)
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_b = syscom.get_filter_color_b
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl04].x
		}
		// ウィンドウ背景[透過度]
		elseif ((@SysCFPage == 1) && (@MSCHK >= 26) && (@MSCHK <= 28))	{
			$TTSlideBar(4, @MSCHK)
			@WBState04 = @WB_TR_SET
			syscom.set_filter_color_a(255-@WBState04)	// 不透過度ではなく透過度
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].tr = syscom.get_filter_color_a
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl05].x
		}
		// オートモード[文字時間]
		elseif ((@SysCFPage == 1) && (@MSCHK >= 31) && (@MSCHK <= 33))	{
			$TTSlideBar(5, @MSCHK)
			@S_CTL_BAR_SET = ((@S_CTL_BAR_SET * 25) / 10)
			@TTIME_SET = @S_CTL_BAR_SET
			@S_CTL_BAR_SET %= 10
			syscom.set_auto_mode_moji_wait(@TTIME_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06].x
		}
		// オートモード[最小時間]
		elseif ((@SysCFPage == 1) && (@MSCHK >= 34) && (@MSCHK <= 36))	{
			$TTSlideBar(6, @MSCHK)
			@STIME_SET = (@S_CTL_BAR_SET * 25)
			syscom.set_auto_mode_min_wait(@STIME_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07].x
		}
		// 音量設定[全体]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 10) && (@MSCHK <= 12))	{
			$TTSlideBar(7, @MSCHK)
			syscom.set_all_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl01].x
		}
		// 音量設定[ＢＧＭ]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 14) && (@MSCHK <= 16))	{
			$TTSlideBar(8, @MSCHK)
			syscom.set_bgm_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl02].x
		}
		// 音量設定[ＢＧＭフェード]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 18) && (@MSCHK <= 20))	{
			$TTSlideBar(9, @MSCHK)
			syscom.set_bgmfade_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl03].x
		}
		// 音量設定[音声]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 22) && (@MSCHK <= 24))	{
			$TTSlideBar(10, @MSCHK)
			syscom.set_koe_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl04].x
		}
		// 音量設定[効果音]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 26) && (@MSCHK <= 28))	{
			$TTSlideBar(11, @MSCHK)
			syscom.set_pcm_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl05].x
		}
		// 音量設定[システム]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 30) && (@MSCHK <= 32))	{
			$TTSlideBar(12, @MSCHK)
			syscom.set_se_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl06].x
		}
		// 音量設定[ムービー]
		elseif ((@SysCFPage == 2) && (@MSCHK >= 34) && (@MSCHK <= 36))	{
			$TTSlideBar(13, @MSCHK)
			syscom.set_mov_volume(@S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl07].x
		}
		// キャラ０１[音無]
		elseif ((@SysCFPage == 2) && (@MSCHK == 90) || (@MSCHK == 112) || (@MSCHK == 134))	{
			$TTSlideBar(14, @MSCHK)
			syscom.set_charakoe_volume(001, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl01].x
		}
		// キャラ０２[ゆり]
		elseif ((@SysCFPage == 2) && (@MSCHK == 91) || (@MSCHK == 113) || (@MSCHK == 135))	{
			$TTSlideBar(15, @MSCHK)
			syscom.set_charakoe_volume(002, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl02].x
		}
		// キャラ０３[天使]
		elseif ((@SysCFPage == 2) && (@MSCHK == 92) || (@MSCHK == 114) || (@MSCHK == 136))	{
			$TTSlideBar(16, @MSCHK)
			syscom.set_charakoe_volume(003, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl03].x
		}
		// キャラ０４[日向]
		elseif ((@SysCFPage == 2) && (@MSCHK == 93) || (@MSCHK == 115) || (@MSCHK == 137))	{
			$TTSlideBar(17, @MSCHK)
			syscom.set_charakoe_volume(004, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl04].x
		}
		// キャラ０５[ユイ]
		elseif ((@SysCFPage == 2) && (@MSCHK == 94) || (@MSCHK == 116) || (@MSCHK == 138))	{
			$TTSlideBar(18, @MSCHK)
			syscom.set_charakoe_volume(005, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl05].x
		}
		// キャラ０６[岩沢]
		elseif ((@SysCFPage == 2) && (@MSCHK == 95) || (@MSCHK == 117) || (@MSCHK == 139))	{
			$TTSlideBar(19, @MSCHK)
			syscom.set_charakoe_volume(006, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl06].x
		}
		// キャラ０７[松下]
		elseif ((@SysCFPage == 2) && (@MSCHK == 96) || (@MSCHK == 118) || (@MSCHK == 140))	{
			$TTSlideBar(20, @MSCHK)
			syscom.set_charakoe_volume(007, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl07].x
		}
		// キャラ０８[野田]
		elseif ((@SysCFPage == 2) && (@MSCHK == 97) || (@MSCHK == 119) || (@MSCHK == 141))	{
			$TTSlideBar(21, @MSCHK)
			syscom.set_charakoe_volume(008, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl08].x
		}
		// キャラ０９[高松]
		elseif ((@SysCFPage == 2) && (@MSCHK == 98) || (@MSCHK == 120) || (@MSCHK == 142))	{
			$TTSlideBar(22, @MSCHK)
			syscom.set_charakoe_volume(009, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl09].x
		}
		// キャラ１０[大山]
		elseif ((@SysCFPage == 2) && (@MSCHK == 99) || (@MSCHK == 121) || (@MSCHK == 143))	{
			$TTSlideBar(23, @MSCHK)
			syscom.set_charakoe_volume(010, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl10].x
		}
		// キャラ１１[藤巻]
		elseif ((@SysCFPage == 2) && (@MSCHK == 100) || (@MSCHK == 122) || (@MSCHK == 144))	{
			$TTSlideBar(24, @MSCHK)
			syscom.set_charakoe_volume(011, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl11].x
		}
		// キャラ１２[ＴＫ]
		elseif ((@SysCFPage == 2) && (@MSCHK == 101) || (@MSCHK == 123) || (@MSCHK == 145))	{
			$TTSlideBar(25, @MSCHK)
			syscom.set_charakoe_volume(012, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl12].x
		}
		// キャラ１３[椎名]
		elseif ((@SysCFPage == 2) && (@MSCHK == 102) || (@MSCHK == 124) || (@MSCHK == 146))	{
			$TTSlideBar(26, @MSCHK)
			syscom.set_charakoe_volume(013, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl13].x
		}
		// キャラ１４[遊佐]
		elseif ((@SysCFPage == 2) && (@MSCHK == 103) || (@MSCHK == 125) || (@MSCHK == 147))	{
			$TTSlideBar(27, @MSCHK)
			syscom.set_charakoe_volume(014, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl14].x
		}
		// キャラ１５[ひさ子]
		elseif ((@SysCFPage == 2) && (@MSCHK == 104) || (@MSCHK == 126) || (@MSCHK == 148))	{
			$TTSlideBar(28, @MSCHK)
			syscom.set_charakoe_volume(015, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl15].x
		}
		// キャラ１６[関根]
		elseif ((@SysCFPage == 2) && (@MSCHK == 105) || (@MSCHK == 127) || (@MSCHK == 149))	{
			$TTSlideBar(29, @MSCHK)
			syscom.set_charakoe_volume(016, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl16].x
		}
		// キャラ１７[入江]
		elseif ((@SysCFPage == 2) && (@MSCHK == 106) || (@MSCHK == 128) || (@MSCHK == 150))	{
			$TTSlideBar(30, @MSCHK)
			syscom.set_charakoe_volume(017, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl17].x
		}
		// キャラ１８[チャー]
		elseif ((@SysCFPage == 2) && (@MSCHK == 107) || (@MSCHK == 129) || (@MSCHK == 151))	{
			$TTSlideBar(31, @MSCHK)
			syscom.set_charakoe_volume(018, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl18].x
		}
		// キャラ１９[竹山]
		elseif ((@SysCFPage == 2) && (@MSCHK == 108) || (@MSCHK == 130) || (@MSCHK == 152))	{
			$TTSlideBar(32, @MSCHK)
			syscom.set_charakoe_volume(019, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl19].x
		}
		// キャラ２０[直井]
		elseif ((@SysCFPage == 2) && (@MSCHK == 109) || (@MSCHK == 131) || (@MSCHK == 153))	{
			$TTSlideBar(33, @MSCHK)
			syscom.set_charakoe_volume(020, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl20].x
		}
		// キャラ２１[その他・男]
		elseif ((@SysCFPage == 2) && (@MSCHK == 110) || (@MSCHK == 132) || (@MSCHK == 154))	{
			$TTSlideBar(34, @MSCHK)
			syscom.set_charakoe_volume(021, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl21].x
		}
		// キャラ２２[その他・女]
		elseif ((@SysCFPage == 2) && (@MSCHK == 111) || (@MSCHK == 133) || (@MSCHK == 155))	{
			$TTSlideBar(35, @MSCHK)
			syscom.set_charakoe_volume(022, @S_CTL_BAR_SET)
			// スライダーバー有効範囲設定
			@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl22].x
		}

		// 待ち時間 = ( 表示した文字数 × 文字時間 ) ＋ 最小時間
		@WTIME_SET = (10 * @TTIME_SET) + @STIME_SET

		// 文字時間セット
		$AMNumset


		// サンプルテキスト表示
		if (@MSChkState == @Off)	{	// 文字数：16、フォントサイズ：26
			// テキストを表示開始
			if ((counter[@CNoMSP01].check_active == 0) && (counter[@CNoMSP01].get == 0) && (@MSP_TOUCH_STATE03 == @Off))	{
				counter[@CNoMSP01].start_frame_real(0, 16, @MSState * 26)	// ウェイト
			}
			// 全て表示が終了したら300㍉秒ウェイトする
			if ((counter[@CNoMSP01].get >= 16) && (@MSP_TOUCH_STATE03 == @Off))	{
				counter[@CNoMSP02].start_real
				@MSP_TOUCH_STATE03 = @ON
			}
			// 1000㍉秒経過したら１文字目から再表示
			if (counter[@CNoMSP02].get >= 1000)	{
				@MSP_TOUCH_STATE03 = @Off
				counter[@CNoMSP01].reset
				counter[@CNoMSP02].reset
			}
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_use    = @On
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_left   = 440
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_top    = 500
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_right  = 440 + (26 * counter[@CNoMSP01].get)
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_bottom = 720
		}
		elseif (@MSChkState == @On)	{
			counter[@CNoMSP01].reset
			counter[@CNoMSP02].reset
			@MSP_TOUCH_STATE01 = @Off
			@MSP_TOUCH_STATE02 = @Off
			@MSP_TOUCH_STATE03 = @Off
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_use    = @On
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_left   = 0
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_top    = 0
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_right  = 1280
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_bottom = 720
		}
		// 最速の場合の時の処理（チラツキ防止）
		if (@MSState == 0)	{
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_use    = @On
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_left   = 0
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_top    = 0
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_right  = 1280
			@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsg00].clip_bottom = 720
		}

		// 状態表示
		input.next
		disp

		// 結果
		if (@MSBTN_RESULT == @DECIDE)	{
			@MSBTN_RESULT = @INIT
			// マウスホイールでページ切り替え
			if (@MSCHK >= 178 && @MSCHK <= 179)	{
//				@se_play(001)
				@SysCFPagePrev = @SysCFPage
				@SysCFPage = @SysCFPagePrev + @MSWHL_STATE
				if (@SysCFPage > 2)	{
					@SysCFPage = 0
				}
				elseif (@SysCFPage < 0)	{
					@SysCFPage = 2
				}
				// 開いた項目を記憶
				@SysCFLastPage = @SysCFPage
				@SysCFPageCSpd = @On
				// ページ切り替え判定
				@SysCFPageChange = @On
				break
			}
			switch (@MSCHK)	{
				case (0)
					// システムボタン
					@se_play(001)
					@SysCFPagePrev = @SysCFPage
					@SysCFPage = 0
					// ページ切り替え判定
					@SysCFPageChange = @On
					break
				case (1)
					// テキストボタン
					@se_play(001)
					@SysCFPagePrev = @SysCFPage
					@SysCFPage = 1
					// ページ切り替え判定
					@SysCFPageChange = @On
					break
				case (2)
					// サウンドボタン
					@se_play(001)
					@SysCFPagePrev = @SysCFPage
					@SysCFPage = 2
					// ページ切り替え判定
					@SysCFPageChange = @On
					break
				case (3)
					// ゲームを終了
					$sys_return_cf(0)
					goto #MenuSel00
				case (4)
					// タイトルに戻る
					$sys_return_cf(1)
					goto #MenuSel00
				case (5)
					// セーブ
					@ex.F[$sys_sa_mode] = @On
					break
				case (6)
					// ロード
					@ex.F[$sys_lo_mode] = @On
					break
				case (7)
					// コンフィグ
				case (8)
					// ゲームに戻る
					break
			}
			// システム
			if (@SysCFPage == 0)	{
				@se_play(001)
				switch (@MSCHK)	{
					case (9)
						// 画面モード[ウィンドウ]
						@WWSizeStatePrev = @WWSizeState
						@WWSizeState = @Off
						@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow02].patno = @Init
						syscom.set_window_mode(@WWSizeState)
					case (10)
						// 画面モード[フルスクリーン]
						@WWSizeStatePrev = @WWSizeState
						@WWSizeState = @On
						@ex.f.obj[@ObjSysCF02].@cd[_ObjSysCFWindow01].patno = @Init
						syscom.set_window_mode(@WWSizeState)
					case (11)
						// 画面モード[詳細設定]
						syscom.call_config_window_mode_menu
					case (12)
						// 現在地表示[表示する]
						@SpotDispState = @On
					case (13)
						// 現在地表示[表示しない]
						@SpotDispState = @Off
					case (14)
						// 演出速度[キャラクター] - 通常
						@BsFadeState = @Def
					case (15)
						// 演出速度[キャラクター] - 瞬時
						@BsFadeState = @Inst
					case (16)
						// 演出速度[背景] - 通常
						@BgFadeState = @Def
					case (17)
						// 演出速度[背景] - 瞬時
						@BgFadeState = @Inst
					case (18)
						// 演出速度[イベントＣＧ] - 通常
						@EvFadeState = @Def
					case (19)
						// 演出速度[イベントＣＧ] - 瞬時
						@EvFadeState = @Inst
					case (20)
						// 演出速度[メッセージウィンドウ] - 通常
						@MwFadeState = @Def
						syscom.set_no_mwnd_anime_onoff(@Off)
					case (21)
						// 演出速度[メッセージウィンドウ] - 瞬時
						@MwFadeState = @Inst
						syscom.set_no_mwnd_anime_onoff(@On)
					case (22)
						// 演出速度[システムメニュー] - 通常
						@MeFadeState = @Def
					case (23)
						// 演出速度[システムメニュー] - 瞬時
						@MeFadeState = @Inst
					case (24)
						// エモーション表示[ＯＮ]
						@EmDispState = @On
					case (25)
						// エモーション表示[ＯＦＦ]
						@EmDispState = @Off
					case (26)
						// メッセージスキップ[既読のみ]
						@MsgSkipState = @Off
						syscom.set_skip_unread_message_onoff(@MsgSkipState)
					case (27)
						// メッセージスキップ[未読も含む]
						@MsgSkipState = @On
						syscom.set_skip_unread_message_onoff(@MsgSkipState)
					case (28)
						// オートセーブ[使用する]
						@EsAutoSave = @On
					case (29)
						// オートセーブ[使用しない]
						@EsAutoSave = @Off
					case (46)
						// 実績システム（仮）[表示する]		※番号注意
						@実績獲得表示する = @On
					case (47)
						// 実績システム（仮）[表示しない]	※番号注意
						@実績獲得表示する = @Off
					case (30)
						// 右クリック動作[クイックメニュー]
						@MRActionState = 0
					case (31)
						// 右クリック動作[ウィンドウ消去]
						@MRActionState = 1
					case (32)
						// 右クリック動作[セーブ画面]
						@MRActionState = 2
					case (33)
						// 右クリック動作[ロード画面]
						@MRActionState = 3
					case (34)
						// 右クリック動作[Config画面]
						@MRActionState = 4
					case (35)
						// 確認ダイアログ[セーブ／ロード]
						    if (@CdState[+0] == @Off) {@CdState[+0] = @On}
					    elseif (@CdState[+0] == @On ) {@CdState[+0] = @Off}
					case (36)
						// 確認ダイアログ[クイックセーブ／クイックロード]
						    if (@CdState[+1] == @Off) {@CdState[+1] = @On}
					    elseif (@CdState[+1] == @On ) {@CdState[+1] = @Off}
					case (37)
						// 確認ダイアログ[上書きセーブ]
						    if (@CdState[+2] == @Off) {@CdState[+2] = @On}
					    elseif (@CdState[+2] == @On ) {@CdState[+2] = @Off}
					case (38)
						// 確認ダイアログ[前の選択肢に戻る]
						    if (@CdState[+3] == @Off) {@CdState[+3] = @On}
					    elseif (@CdState[+3] == @On ) {@CdState[+3] = @Off}
					case (39)
						// 確認ダイアログ[セーブデータの入れ替え]
						    if (@CdState[+4] == @Off) {@CdState[+4] = @On}
					    elseif (@CdState[+4] == @On ) {@CdState[+4] = @Off}
					case (40)
						// 確認ダイアログ[タイトルに戻る]
						    if (@CdState[+5] == @Off) {@CdState[+5] = @On}
					    elseif (@CdState[+5] == @On ) {@CdState[+5] = @Off}
					case (41)
						// 確認ダイアログ[セーブデータの削除]
						    if (@CdState[+6] == @Off) {@CdState[+6] = @On}
					    elseif (@CdState[+6] == @On ) {@CdState[+6] = @Off}
					case (42)
						// 確認ダイアログ[ゲームを終了する]
						    if (@CdState[+7] == @Off) {@CdState[+7] = @On}
					    elseif (@CdState[+7] == @On ) {@CdState[+7] = @Off}
					case (43)
						// その他の設定[マウスホイールボタンの…]
						    if (@EsState[+3] == @Off) {@EsState[+3] = @On}
						elseif (@EsState[+3] == @On ) {@EsState[+3] = @Off}
						syscom.set_wheel_next_message_onoff(@EsState[+3])
					case (44)
						// その他の設定[本プログラムの動作を…]
						    if (@EsState[+0] == @Off) {@EsState[+0] = @On}
						elseif (@EsState[+0] == @On ) {@EsState[+0] = @Off}
						syscom.set_sleep_onoff(@EsState[+0])
					case (45)
						// ムービー設定
						syscom.call_config_movie_menu
				}
			}
			// テキスト
			elseif (@SysCFPage == 1)	{
				switch (@MSCHK){
					case (9)
						// フォントＡ
						@se_play(001)
						@UseFontState = @FontA
						syscom.set_font_name(@UseFontState)
					case (10)
						// フォントＢ
						@se_play(001)
						@UseFontState = @FontB
						syscom.set_font_name(@UseFontState)
					case (11)
						// その他のフォント
						@se_play(001)
						syscom.call_config_font_menu
					case (12)
						// ノーウェイト
						@se_play(001)
						    if (@MSChkState == @Off) {@MSChkState = @On}
						elseif (@MSChkState == @On ) {@MSChkState = @Off}
						syscom.set_message_nowait(@MSChkState)
					case (16)
						// 初期設定に戻す[文字速度]
						@se_play(001)
						@GetMSInitState(@MSChkState, @MSState)
						@MSP_SET = math.timetable(@MSState, 0, 255, [0,100, 0])
						@MSP_SET = @MSP_SET + @S_CTL_BAR_MS_STPOS
						@MSP_SET_PREV = @MSP_SET
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl01].x = @MSP_SET
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar01e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl01].x
						syscom.set_message_speed(@MSState)
						syscom.set_message_nowait(@MSChkState)
						@SetUseFontDefault
					case (29)
						// 初期設定に戻す[ウィンドウ背景]
						@se_play(001)
						syscom.set_filter_color_r_default
						syscom.set_filter_color_g_default
						syscom.set_filter_color_b_default
						syscom.set_filter_color_a_default
						@GetWindowBgState(@WBState01, @WBState02, @WBState03, @WBState04)
						@WB_R_SET  = @WBState01 + @S_CTL_BAR_MWBG_STPOS01
						@WB_G_SET  = @WBState02 + @S_CTL_BAR_MWBG_STPOS02
						@WB_B_SET  = @WBState03 + @S_CTL_BAR_MWBG_STPOS03
						@WB_TR_SET = (255 - @WBState04) + @S_CTL_BAR_MWBG_STPOS04
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl02].x = @WB_R_SET
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl03].x = @WB_G_SET
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl04].x = @WB_B_SET
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl05].x = @WB_TR_SET
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_r = syscom.get_filter_color_r
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_g = syscom.get_filter_color_g
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].color_add_b = syscom.get_filter_color_b
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtMsgBg00].tr          = syscom.get_filter_color_a
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar02e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl02].x
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar03e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl03].x
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar04e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl04].x
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar05e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl05].x
					case (30)
						// オートモードチェック
						@se_play(001)
						    if (@AMCheckState == @Off) {@AMCheckState = @On}
						elseif (@AMCheckState == @On ) {@AMCheckState = @Off}
						@AutoStartReady = @AMCheckState
						syscom.set_auto_mode_onoff_flag(@AMCheckState)
					case (37)
						// 初期設定に戻す[オートモード]
						@se_play(001)
						$AMNumInit
						// オートモード状態取得
						@GetSysAMState(@AMCheckState,@TTimeState,@STimeState)
						// 文字時間スクロール
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06].x = ((@TTimeState / 5) * 2) + @S_CTL_BAR_TTIME_STPOS
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar06e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06].x
						// 最小時間スクロール
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07].x = ((@STimeState / 50) * 2) + @S_CTL_BAR_STIME_STPOS
						@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtBar07e].clip_right = @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07].x
					case (@S_CTL_BAR_CTLSTATE)
						// Ｃｔｌ
						@S_CTL_BAR_ACTIVE      = @Off
						@S_CTL_BAR_CTLACTIVE   = @Off
						@S_CTL_BAR_CTLPOS_PREV = @Init
					case (@S_CTL_BAR_BARSTATE)
						// ＢＥＲ
				}
			}
			// サウンド
			elseif (@SysCFPage == 2)	{
				switch (@MSCHK){
					case (9)
						// 音量設定[全体]
						@se_play(001)
						    if (@AllChkState == @Off) {@AllChkState = @On}
						elseif (@AllChkState == @On ) {@AllChkState = @Off}
						syscom.set_all_onoff(@AllChkState)
					case (13)
						// 音量設定[ＢＧＭ]
						@se_play(001)
						    if (@BgmChkState == @Off) {@BgmChkState = @On}
						elseif (@BgmChkState == @On ) {@BgmChkState = @Off}
						syscom.set_bgm_onoff(@BgmChkState)
					case (17)
						// 音量設定[ＢＧＭフェード]
						@se_play(001)
						    if (@BFadeChk01State == @Off) {@BFadeChk01State = @On}
						elseif (@BFadeChk01State == @On ) {@BFadeChk01State = @Off}
						syscom.set_bgmfade_onoff(@BFadeChk01State)
					case (21)
						// 音量設定[音声]
						@se_play(001)
						    if (@VoiceChkState == @Off) {@VoiceChkState = @On}
						elseif (@VoiceChkState == @On ) {@VoiceChkState = @Off}
						syscom.set_koe_onoff(@VoiceChkState)
					case (25)
						// 音量設定[効果音]
						@se_play(001)
						    if (@SeChkState == @Off) {@SeChkState = @On}
						elseif (@SeChkState == @On ) {@SeChkState = @Off}
						syscom.set_pcm_onoff(@SeChkState)
					case (29)
						// 音量設定[システム音]
						@se_play(001)
						    if (@SysChkState == @Off) {@SysChkState = @On}
						elseif (@SysChkState == @On ) {@SysChkState = @Off}
						syscom.set_se_onoff(@SysChkState)
					case (33)
						// 音量設定[ムービー]
						@se_play(001)
						    if (@MovChkState == @Off) {@MovChkState = @On}
						elseif (@MovChkState == @On ) {@MovChkState = @Off}
						syscom.set_mov_onoff(@MovChkState)
					case (37)
						// 初期設定に戻す[音量設定]
						@se_play(001)
						@SetMusicStateDefault
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl01].x = @AllVolState   + @S_CTL_BAR_VOL_ALL_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl02].x = @BgmVolState   + @S_CTL_BAR_VOL_BGM_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl03].x = @BFadeVolState + @S_CTL_BAR_VOL_BFADE_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl04].x = @VoiceVolState + @S_CTL_BAR_VOL_VOICE_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl05].x = @SEVolState    + @S_CTL_BAR_VOL_SE_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl06].x = @SysVolState   + @S_CTL_BAR_VOL_SYS_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl07].x = @MovVolState   + @S_CTL_BAR_VOL_MOV_STPOS
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar01e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl01].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar02e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl02].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar03e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl03].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar04e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl04].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar05e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl05].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar06e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl06].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolBar07e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndVolCtl07].x
					case (38)
						// ボリュームテスト再生ボタン[全体]
						syscom.set_sound_volume(31, syscom.get_all_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (39)
						// ボリュームテスト再生ボタン[ＢＧＭ]
						syscom.set_sound_volume(31, syscom.get_bgm_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (40)
						// ボリュームテスト再生ボタン[ＢＧＭフェード]
						syscom.set_sound_volume(31, syscom.get_bgmfade_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (41)
						// ボリュームテスト再生ボタン[音声]
						syscom.set_sound_volume(31, syscom.get_koe_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (42)
						// ボリュームテスト再生ボタン[効果音]
						syscom.set_sound_volume(31, syscom.get_pcm_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (43)
						// ボリュームテスト再生ボタン[システム音]
						syscom.set_sound_volume(31, syscom.get_se_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (44)
						// ボリュームテスト再生ボタン[ムービー]
						syscom.set_sound_volume(31, syscom.get_mov_volume)
						pcmch[15].play(MN_SS_SE12, volume_type = 31)
					case (45)
						// 音声の再生（声の再生中に次の文章に進んでも再生を続ける）
						@se_play(001)
						    if (@EsState[4] == @On)  {@EsState[4] = @Off}
						elseif (@EsState[4] == @Off) {@EsState[4] = @On}
						syscom.set_koe_dont_stop_onoff(@EsState[4])
					case (156)
						// キャラクター音声の再生[全てＯＮ]
						@se_play(001)
						for (L[0] = 0, L[0] < 22, L[0] += 1)	{
							@CVState[L[0]]  = @On
						}
						@SetCVoiceStateAll(@On)
					case (157)
						// キャラクター音声の再生[全てＯＦＦ]
						@se_play(001)
						for (L[0] = 0, L[0] < 22, L[0] += 1)	{
							@CVState[L[0]]  = @Off
						}
						@SetCVoiceStateAll(@Off)
					case (158)
						// 初期設定に戻す[キャラクター別音声]
						@se_play(001)
						@SetCVoiceStateDefault
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl01].x = @S_CTL_BAR_CV01_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl02].x = @S_CTL_BAR_CV02_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl03].x = @S_CTL_BAR_CV03_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl04].x = @S_CTL_BAR_CV04_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl05].x = @S_CTL_BAR_CV05_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl06].x = @S_CTL_BAR_CV06_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl07].x = @S_CTL_BAR_CV07_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl08].x = @S_CTL_BAR_CV08_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl09].x = @S_CTL_BAR_CV09_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl10].x = @S_CTL_BAR_CV10_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl11].x = @S_CTL_BAR_CV11_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl12].x = @S_CTL_BAR_CV12_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl13].x = @S_CTL_BAR_CV13_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl14].x = @S_CTL_BAR_CV14_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl15].x = @S_CTL_BAR_CV15_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl16].x = @S_CTL_BAR_CV16_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl17].x = @S_CTL_BAR_CV17_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl18].x = @S_CTL_BAR_CV18_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl19].x = @S_CTL_BAR_CV19_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl20].x = @S_CTL_BAR_CV20_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl21].x = @S_CTL_BAR_CV21_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl22].x = @S_CTL_BAR_CV22_EDPOS - 10
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar01e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl01].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar02e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl02].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar03e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl03].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar04e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl04].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar05e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl05].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar06e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl06].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar07e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl07].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar08e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl08].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar09e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl09].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar10e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl10].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar11e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl11].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar12e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl12].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar13e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl13].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar14e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl14].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar15e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl15].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar16e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl16].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar17e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl17].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar18e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl18].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar19e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl19].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar20e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl20].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar21e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl21].x
						@ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVBar22e].clip_right = @ex.f.obj[@ObjSysCF04].@cd[_ObjSysCFSndCVCtrl22].x
					case (@S_CTL_BAR_CTLSTATE)
						// Ｃｔｌ
						@S_CTL_BAR_ACTIVE      = @Off
						@S_CTL_BAR_CTLACTIVE   = @Off
						@S_CTL_BAR_CTLPOS_PREV = @Init
					case (@S_CTL_BAR_BARSTATE)
						// ＢＥＲ

				}
				// キャラクター別音声[テスト再生ボタン]
				if (@MSCHK >= 46 && @MSCHK <= 67)	{
					$CvTestplay(@MSCHK)
				}
				// キャラクター別音声[ボタン]
				if (@MSCHK >= 68 && @MSCHK <= 89)	{
					@se_play(001)
					    if (@CVState[@MSCHK-68] == @On)  {@CVState[@MSCHK-68] = @Off}
					elseif (@CVState[@MSCHK-68] == @Off) {@CVState[@MSCHK-68] = @On}
					syscom.set_charakoe_onoff((@MSCHK-68)+1, @CVState[@MSCHK-68])	// ※001から
				}
			}
		}
	} // 0

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
				// システム／テキスト／サウンドボタン
				if (@MSCHK >= 0 && @MSCHK <= 2)	{
					@MSBTN_RESULT = @DECIDE
					@MS_STATE = @MSBTN_INIT
				}
				// システム[画面モード／現在地表示／表示速度はプッシュで決定]
				elseif ((@SysCFPage == 0) && ((@MSCHK >= 9 && @MSCHK <= 34) || (@MSCHK >= 46 && @MSCHK <= 47)))	{
					@MSBTN_RESULT = @DECIDE
					@MS_STATE = @MSBTN_INIT
				}
				// テキスト[フォントＡ・Ｂ]
				elseif ((@SysCFPage == 1) && (@MSCHK >= 9 && @MSCHK <= 10))	{
					@MSBTN_RESULT = @DECIDE
					@MS_STATE = @MSBTN_INIT
				}
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
// スライダー処理
// ----------------------------------------------------------------------------------------
command $TTSlideBar(property $Slider_num : int, property $ctl_num : int)
{

	switch ($Slider_num)	{
		case (0)
			// メッセージ速度
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl01
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_MS_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_MS_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(13)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (1)
			// ウィンドウ背景[赤]
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl02
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_MWBG_STPOS01
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_MWBG_EDPOS01 - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(17)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (2)
			// ウィンドウ背景[緑]
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl03
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_MWBG_STPOS02
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_MWBG_EDPOS02 - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(20)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (3)
			// ウィンドウ背景[青]
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl04
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_MWBG_STPOS03
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_MWBG_EDPOS03 - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(23)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (4)
			// ウィンドウ背景[透過度]
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl05
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_MWBG_STPOS04
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_MWBG_EDPOS04 - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(26)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (5)
			// オートモード[文字時間]
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl06
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_TTIME_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_TTIME_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(31)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (6)
			// オートモード[最小時間]
			@S_CTL_BAR_OBJNUM(@ObjSysCF03)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFTtCtl07
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_STIME_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_STIME_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(34)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (7)
			// 音量設定[全体]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl01
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_ALL_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_ALL_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(10)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (8)
			// 音量設定[ＢＧＭ]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl02
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_BGM_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_BGM_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(14)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (9)
			// 音量設定[ＢＧＭフェード]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl03
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_BFADE_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_BFADE_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(18)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (10)
			// 音量設定[音声]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl04
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_VOICE_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_VOICE_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(22)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (11)
			// 音量設定[効果音]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl05
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_SE_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_SE_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(26)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (12)
			// 音量設定[システム]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl06
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_SYS_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_SYS_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(30)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (13)
			// 音量設定[ムービー]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndVolCtl07
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_VOL_MOV_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_VOL_MOV_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(34)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (14)
			// キャラ０１[音無]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl01
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV01_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV01_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(90)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (15)
			// キャラ０２[ゆり]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl02
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV02_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV02_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(91)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (16)
			// キャラ０３[天使]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl03
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV03_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV03_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(92)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (17)
			// キャラ０４[日向]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl04
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV04_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV04_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(93)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (18)
			// キャラ０５[ユイ]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl05
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV05_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV05_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(94)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (19)
			// キャラ０６[岩沢]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl06
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV06_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV06_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(95)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (20)
			// キャラ０７[松下]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl07
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV07_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV07_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(96)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (21)
			// キャラ０８[野田]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl08
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV08_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV08_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(97)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (22)
			// キャラ０９[高松]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl09
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV09_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV09_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(98)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (23)
			// キャラ１０[大山]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl10
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV10_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV10_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(99)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (24)
			// キャラ１１[藤巻]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl11
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV11_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV11_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(100)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (25)
			// キャラ１２[ＴＫ]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl12
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV12_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV12_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(101)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (26)
			// キャラ１３[椎名]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl13
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV13_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV13_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(102)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (27)
			// キャラ１４[遊佐]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl14
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV14_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV14_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(103)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (28)
			// キャラ１５[ひさ子]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl15
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV15_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV15_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(104)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (29)
			// キャラ１６[関根]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl16
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV16_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV16_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(105)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (30)
			// キャラ１７[入江]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl17
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV17_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV17_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(106)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (31)
			// キャラ１８[チャー]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl18
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV18_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV18_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(107)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (32)
			// キャラ１９[竹山]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl19
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV19_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV19_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(108)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (33)
			// キャラ２０[直井]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl20
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV20_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV20_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(109)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (34)
			// キャラ２１[その他・男]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl21
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV21_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV21_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(110)
			@S_CTL_BAR_BARNUM($ctl_num)
		case (35)
			// キャラ２２[その他・女]
			@S_CTL_BAR_OBJNUM(@ObjSysCF04)
			@S_CTR_BAR_POS_DEFULT00 = 10
			@S_CTL_BAR       = _ObjSysCFSndCVCtrl22
			@S_CTL_BAR_POS   = @ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x
			@S_CTL_BAR_STPOS = @S_CTL_BAR_CV22_STPOS
			@S_CTL_BAR_EDPOS = @S_CTL_BAR_CV22_EDPOS - @S_CTR_BAR_POS_DEFULT00
			@S_CTL_BAR_CTLNUM(111)
			@S_CTL_BAR_BARNUM($ctl_num)
	}
	// Ｃｔｌ
	if (@ObjBtnState[+@S_CTL_BAR_CTLSTATE] == @MSBTN_PUSH)	{
		if (@S_CTL_BAR_ACTIVE == @Off)	{
			@S_CTL_BAR_CTLACTIVE = @On
			@S_CTL_BAR_CTLPOS_PREV = @S_CTL_BAR_POS
			@S_CTL_BAR_ACTIVE = @On
			@MX_PREV = @MX
		}
		elseif (@S_CTL_BAR_ACTIVE == @On)	{
			if (@MX_PREV != @MX)	{
				if ((@S_CTL_BAR_CTLPOS >= @S_CTL_BAR_STPOS) || (@S_CTL_BAR_CTLPOS <= @S_CTL_BAR_EDPOS))	{
					@S_CTL_BAR_CTLPOS = @S_CTL_BAR_CTLPOS_PREV - (@MX_PREV-@MX)
					@ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x = @S_CTL_BAR_CTLPOS
					if (@S_CTL_BAR_CTLPOS >= @S_CTL_BAR_EDPOS)	{
						@ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x = @S_CTL_BAR_EDPOS
						@S_CTL_BAR_CTLPOS = @S_CTL_BAR_EDPOS
					}
					elseif(@S_CTL_BAR_CTLPOS <= @S_CTL_BAR_STPOS)	{
						@ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x = @S_CTL_BAR_STPOS
						@S_CTL_BAR_CTLPOS = @S_CTL_BAR_STPOS
					}
					@S_CTL_BAR_POS = @S_CTL_BAR_CTLPOS
				}
				if (@MX_PREV == @MX)	{
					@S_CTL_BAR_ACTIVE = @Off
				}
			}
		}
	}
	// ＢＡＲ
	elseif (@ObjBtnState[+@S_CTL_BAR_BARSTATE] == @MSBTN_PUSH)	{
		@MX_PREV = @MX
		if (@MX_PREV < (@S_CTL_BAR_STPOS + (@S_CTR_BAR_POS_DEFULT00 / 2)))	{
			@ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x = @S_CTL_BAR_STPOS
		}
		elseif (@MX_PREV > (@S_CTL_BAR_EDPOS + (@S_CTR_BAR_POS_DEFULT00 / 2)))	{
			@ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x = @S_CTL_BAR_EDPOS
		}
		else	{
			@ex.f.obj[@S_CTL_BAR_OBJSTATE].@cd[@S_CTL_BAR].x = @MX_PREV - (@S_CTR_BAR_POS_DEFULT00 / 2)
		}
		@MS_STATE = @MSBTN_INIT
		if (@MX_PREV == @MX)	{
			@S_CTL_BAR_ACTIVE = @Off
		}
	}

	//
	// 結果
	//

	// メッセージ速度
	if ($Slider_num == 0)	{
		@MSP_CTL_BAR_SET = @S_CTL_BAR_POS - @S_CTL_BAR_STPOS
	}
	// ウィンドウ背景[赤]
	elseif ($Slider_num == 1)	{
		@WB_R_SET = @S_CTL_BAR_POS - @S_CTL_BAR_STPOS
	}
	// ウィンドウ背景[緑]
	elseif ($Slider_num == 2)	{
		@WB_G_SET = @S_CTL_BAR_POS - @S_CTL_BAR_STPOS
	}
	// ウィンドウ背景[青]
	elseif ($Slider_num == 3)	{
		@WB_B_SET = @S_CTL_BAR_POS - @S_CTL_BAR_STPOS
	}
	// ウィンドウ背景[透過度]
	elseif ($Slider_num == 4)	{
		@WB_TR_SET = @S_CTL_BAR_POS - @S_CTL_BAR_STPOS
	}
	// オートモード[文字時間／最小時間] ／ 音量設定
	elseif ($Slider_num >= 5 && $Slider_num <= 13)	{
		@S_CTL_BAR_SET = @S_CTL_BAR_POS - @S_CTL_BAR_STPOS
	}
	// キャラクター別音声
	else	{
		@S_CTL_BAR_SET = (@S_CTL_BAR_POS - @S_CTL_BAR_STPOS) * 4
	}

}


// ----------------------------------------------------------------------------------------
// オートモード初期化処理
// ----------------------------------------------------------------------------------------
command $AMNumInit
{

	@GetSysAMDefState(@CheckDefState,@TTimeDefState,@STimeDefState)

	@AMCheckState = @Off
	@TTIME_SET  = @TTimeDefState
	@STIME_SET  = @STimeDefState
	@WTIME_SET  = (10 * @TTIME_SET) + @STIME_SET
	syscom.set_auto_mode_onoff_flag(@AMCheckState)
	syscom.set_auto_mode_moji_wait(@TTIME_SET)
	syscom.set_auto_mode_min_wait(@STIME_SET)
	$AMNumset
	L[0] = ((@TTimeState / 5) * 2) + @S_CTL_BAR_TTIME_STPOS
	@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl06].x = L[0]
	L[0] = ((@STimeState / 50) * 2) + @S_CTL_BAR_STIME_STPOS
	@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtCtl07].x = L[0]

}


// ----------------------------------------------------------------------------------------
// オートモード時間構築
// ----------------------------------------------------------------------------------------
command $AMNumset
{

	// 文字時間セット
	@NUM_ABSTRACT01(@TTIME_SET / 10, L[0], L[1], L[2])
	@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum01].patno = 0
	if (L[1] < 0) {L[1] = 0} @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum02].patno = L[1]
	if (L[2] < 0) {L[2] = 0} @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum03].patno = L[2]
	// 最小時間セット
	@NUM_ABSTRACT02(@STIME_SET / 10, L[0], L[1], L[2], L[3])	// L[0]不要
	if (L[1] < 0) {L[1] = 0} @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum04].patno = L[1]
	if (L[2] < 0) {L[2] = 0} @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum05].patno = L[2]
	// 待ち時間セット
	@NUM_ABSTRACT03(@WTIME_SET, L[0], L[1], L[2], L[3], L[4])
	    if (L[0] == 0) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum07].patno = -1}
	elseif (L[0] != 0) {@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum07].patno = 1}
	if (L[1] < 0) {L[1] = 0} @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum08].patno = L[1]
	if (L[2] < 0) {L[2] = 0} @ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum09].patno = L[2]
	@ex.f.obj[@ObjSysCF03].@cd[_ObjSysCFTtANum10].patno = 0

}


// ----------------------------------------------------------------------------------------
// キャラクター別音声[テスト再生ボタン]
// ----------------------------------------------------------------------------------------
command $CvTestplay(property $cha_num : int)
{
	switch ($cha_num)	{
		case (46)
			// KOE(150006146,020)【@音無＿声必要】「よし、じゃあ一緒に行こうぜ」R
			@exkoe_sample(150006146,020)
		case (47)
			// KOE(020000172,002)【@ゆり】「あたしは死んだ世界戦線のリーダーなのよ？」R
			@exkoe_sample(020000172,002)
		case (48)
			// KOE(010000078,001)【@天使】「スリーエスの人たちでこんな素直な人は初めてだわ…」R
			@exkoe_sample(010000078,001)
		case (49)
			// KOE(100000280,010)【@日向】「新入りの面倒を見るのも俺の仕事さ」R
			@exkoe_sample(100000280,010)
		case (50)
			// KOE(030100044,003)【ユイ】「これはどうも、こちらこそ初めまして。ユイっていいます！」R
			@exkoe_sample(030100044,003)
		case (51)
			// KOE(040000099,004)【岩沢】「よう、記憶ナシ男。呑気に見学かい？」R
			@exkoe_sample(040000099,004)
		case (52)
			// KOE(150001821,015)【松下】「おお、音無、どうした。また稽古をつけてほしいのか？」R
			@exkoe_sample(150001821,015)
		case (53)
			// KOE(110000013,011)【@野田】「お前か…なんの用だ」R
			@exkoe_sample(110000013,011)
		case (54)
			// KOE(001204744,012)【高松】「私の着やせするタイプのこの肉体が負けるなんて…」R
			@exkoe_sample(001204744,012)
		case (55)
			// KOE(000300512,014)【大山】「すごいよ、音無くん！」R
			@exkoe_sample(000300512,014)
		case (56)
			// KOE(000200930,013)【藤巻】「けっ、こいつがイケメンだってか？　微妙すぎるぜ」R
			@exkoe_sample(000200930,013)
		case (57)
			// KOE(000200864,016)【ＴＫ】「カモンレッツダーンス！」R
			@exkoe_sample(000200864,016)
		case (58)
			// KOE(000200170,009)【椎名】「あさはかなり…」R
			@exkoe_sample(000200170,009)
		case (59)
			// KOE(000400870,008)【遊佐】「時間です。本部までお願いします」R
			@exkoe_sample(000400870,008)
		case (60)
			// KOE(050000113,005)【ひさ子】「そろそろ練習に戻る。じゃあな」R
			@exkoe_sample(050000113,005)
		case (61)
			// KOE(040001733,006)【関根】「あたしは大人だからな。炭酸でしゅわっと言わせるぜっ」R
			@exkoe_sample(040001733,006)
		case (62)
			// KOE(040000534,007)【入江】「音無さんですか。あたしは入江です。よろしくお願いします」R
			@exkoe_sample(040000534,007)
		case (63)
			// KOE(000303579,018)【チャー】「さっきから気になってたが、お前、見ねぇ顔だな」R
			@exkoe_sample(000303579,018)
		case (64)
			// KOE(000401233,017)【竹山】「…僕のことはクライストとお呼び下さい」R
			@exkoe_sample(000401233,017)
		case (65)
			// KOE(001003012,019)【直井】「生徒会、副会長の直井です」R
			@exkoe_sample(001003012,019)
		case (66)
			// KOE(001802148,022)【斉藤】「もしかしたら…あんたなら、いけるかもしれねぇ…」R
			@exkoe_sample(001802148,022)
		case (67)
			// KOE(000601326,051)【女生徒】「んーこれは何か、怪しい匂いがしますな～」
			@exkoe_sample(000601326,051)		//20150421追加：あまの
			//system.debug_messagebox_ok("モブ音声収録後に選別予定")
	}
}


// ----------------------------------------------------------------------------------------
// タイトルメニューに戻る／ゲームを終了する	todo 修正
// ----------------------------------------------------------------------------------------
command $sys_return_cf(property $game_state : int)
{

	// ゲームを終了する
	if ($game_state == 0)	{
		L[0] = 4
		L[1] = 7
	}
	// タイトルメニューに戻る
	else	{
		L[0] = 3
		L[1] = 5
	}

	// 確認ダイアログ
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0
	}

	// 確認ダイアログ
	if (@CdState[+L[1]] == @On)	{

		// システム音
		@se_play(001)

		// 削除確認下地	todo 仮
		@ex.f.obj[@ObjSysCF05].tr = 0
		@ex.f.obj[@ObjSysCF05].layer = 1000
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfChk00].create(sys_sa_chk00,      @On, 1095, 343)
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfFilter00].create(bg_kuro,        @On,    0,   0)

		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfBg00].patno = L[0]
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfFilter00].tr = 150
		@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfFilter00].layer = -1

		// 表示
		@ex.f.obj[@ObjSysCF05].tr_eve.set(255, L[20], 0, 2)

		@CdStateReady = @Off

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

			@exif_(@Off, @Off, 200, @ObjSysCF05, _ObjSysCFConfBtn01)
			@exif_(@Off, @Off, 201, @ObjSysCF05, _ObjSysCFConfBtn02)
			@exif_(@Off, @Off, 202, @ObjSysCF05, _ObjSysCFConfChk00)

			// マウスボタン入力判定
			$MsBtnInputDecide
			if ($break_switch == @On)	{
				@se_play(002)
				@MSCHK = 201
				$break_switch = @Off
				break
			}

			// 状態セット
			@MsStateSet(200, 203)

			@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfBtn01].patno = $obj_btn_state[200]	// ＹＥＳ
			@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfBtn02].patno = $obj_btn_state[201]	// ＮＯ
			@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfChk00].patno = $obj_btn_state[202]	// 確認ダイアログチェック
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysCF05].@cd[_ObjSysCFConfChk00].patno += @MSBTN_CHK
			}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 200)	{
					// ＹＥＳ
					break
				}
				elseif (@MSCHK == 201)	{
					// ＮＯ
					break
				}
				elseif (@MSCHK == 202)	{
					@se_play(001)
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}

		}
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 200
	}

	// 確認ダイアログの設定
	switch ($game_state)	{
		case (0) $_L[11] = 7	// ゲームを終了する
		case (1) $_L[11] = 5	// タイトルメニューに戻る
	}
	if (@CdStateReady == @On ) {@CdState[+$_L[11]] = @Off}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysCF05].tr_eve.set(0, L[20], 0, 2)

	// 実行
	if (@MSCHK == 200)	{
		// ゲームを終了する
		@bgm_stop(2000)
		@se_play(003)
		@ex.f.obj[@ObjSysCF06].create(bg_kuro, @On, 0, 0)
		@ex.f.obj[@ObjSysCF06].tr = 0
		@ex.f.obj[@ObjSysCF06].layer = 1000001
		@ex.f.obj[@ObjSysCF06].tr_eve.set(255, L[21], 0, 0)
		@ex.f.obj[@ObjSysCF06].tr_eve.wait_key
		if ($game_state == 0)	{
			@timewaitkey(1000)
			syscom.end_game(@Off)
		}
		// タイトルメニューに戻る
		else	{
			syscom.return_to_menu(@Off, @Off, @Off)
		}
	}
	// キャンセル
	else	{
		@se_play(002)
	}

	@timewaitkey(L[20])

	

}




