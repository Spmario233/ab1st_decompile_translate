//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 変数ルール
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
/*
A[0000] - A[0999]：汎用。予備
A[1000] - A[1999]：システム
	A[1000] - A[1099]：背景
	A[1100] - A[1299]：バストショット
	A[1300] - A[1399]：イベントＣＧ

B[0000] - B[0999]：汎用。予備
B[1000] - B[1999]：システム
	B[1000] - B[1099]：背景
	B[1100] - B[1299]：バストショット
	B[1300] - B[1399]：イベントＣＧ

C[0000] - C[0999]：汎用。予備
C[1000] - C[1999]：システム
	C[1700] - C[1999]：マウス制御関連

D[0000] - D[0999]：汎用。予備
D[1000] - D[1999]：システム

E[0000] - E[0999]：汎用。予備
E[1000] - E[1999]：システム
	E[1000] - E[1099]：タイトルメニュー／システムメニュー
	E[1100] - E[1199]：オートモード
	E[1200] - E[1299]：時短再生
	E[1300] - E[1399]：セーブ／ロード
	E[1400] - E[1599]：環境設定

F[0000] - F[0999]：シナリオ関連フラグ
F[1000] - F[1999]：システム

G[0000] - G[0099]：シナリオ関連フラグ
G[0100] - G[0999]：汎用。予備
G[1000] - G[1799]：システム
	G[1000] - G[1099]：クイックセーブ／ロード
	G[1100] - G[1250]：セーブ／ロード
	G[1300] - G[1400]：環境設定
	G[1500] - G[1529]：タイトルメニュー
	G[1530] - G[1559]：システムメニュー
	G[1560] - G[1590]：エクストラ
	G[1800] - G[1999]：選択肢関連フラグ（G.bit2[14400] - G.bit2[15999]）。選択肢個数１０。選択肢総数１００

S[0000] - S[0999]：汎用。予備
S[1000] - S[1999]：システム
	S[1000] - S[1099]：タイトルメニュー／システムメニュー
	S[1100] - S[1199]：オートモード
	S[1200] - S[1299]：時短再生
	S[1300] - S[1399]：セーブ／ロード
	S[1400] - S[1499]：環境設定
	S[1500] - S[1549]：背景
	S[1550] - S[1599]：バストショット
	S[1600] - S[1649]：イベントＣＧ
*/


// ---------------------------------------------------------------
// デバック
// ---------------------------------------------------------------
#define		@DEBUG_SCENEJUMP
			if (@開発用フラグ == @On)	{
				// スクリプト初期化
				@SetGameScriptData(@AngelBeats!)
			}

#macro		@DEBUG(@str)
				system.debug_messagebox_ok(@str)

// ---------------------------------------------------------------
// システム
// ---------------------------------------------------------------
#command	$excall_ready
#command	$excall_free

#replace	@ex			excall					// 
#replace	@ex.f.obj	excall.front.object		// ex.f.obj[0]
#replace	@ex.b.obj	excall.back.object		// ex.b.obj[0]
#replace	@f.obj		front.object			// f.obj[0]
#replace	@b.obj		back.object				// b.obj[0]
#replace	@cd			child					// ex.f.obj[0].@cd[0]
#replace	@ex.F		excall.F				// @ex.F[0]
#replace	@f.mwnd		front.mwnd
#replace	@obj		object

#replace	@f.effect	front.effect
#replace	@b.effect	back.effect

// ローカルフラグ
#define		@Sys_lc		20
#property	$sys_smlc    : intlist[@Sys_lc]		// システム用lc
#property	$sys_smmlc   : intlist[@Sys_lc]		// システムメニュー用lc
#property	$sys_forlc   : intlist[@Sys_lc]		// for分lc
#property	$sys_addlc   : intlist[@Sys_lc]		// 演算用lc
#property	$sys_cntlc   : intlist[@Sys_lc]		// カウント用lc
#property	$sys_forlc0  : int
#property	$sys_forlc1  : int
#property	$sys_forlc2  : int
#property	$sys_forlc3  : int
#property	$sys_forlc4  : int
#property	$sys_forlc5  : int
#property	$sys_forlc6  : int
#property	$sys_forlc7  : int
#property	$sys_forlc8  : int
#property	$sys_forlc9  : int
#property	$sys_forlc10 : int
#property	$sys_forlc11 : int
#property	$sys_forlc12 : int
#property	$sys_forlc13 : int
#property	$sys_forlc14 : int
#property	$sys_forlc15 : int
#property	$sys_forlc16 : int
#property	$sys_forlc17 : int
#property	$sys_forlc18 : int
#property	$sys_forlc19 : int
#property	$sys_smlc0   : int
#property	$sys_smlc1   : int
#property	$sys_smlc2   : int
#property	$sys_smlc3   : int
#property	$sys_smlc4   : int
#property	$sys_smlc5   : int
#property	$sys_smlc6   : int
#property	$sys_smlc7   : int
#property	$sys_smlc8   : int
#property	$sys_smlc9   : int
#property	$sys_smlc10  : int
#property	$sys_smlc11  : int
#property	$sys_smlc12  : int
#property	$sys_smlc13  : int
#property	$sys_smlc14  : int
#property	$sys_smlc15  : int
#property	$sys_smlc16  : int
#property	$sys_smlc17  : int
#property	$sys_smlc18  : int
#property	$sys_smlc19  : int


// システムモード
#property	$sys_mode        : int
#property	$sys_mode_prev   : int
#property	$no_mode         : int
#property	$sys_sm_mode     : int
#property	$sys_sa_mode     : int
#property	$sys_lo_mode     : int
#property	$sys_cf_mode     : int
#property	$sys_mode_return : int
#property	$sys_conf        : int // メッセージウィンドウボタンからの確認下地
#define		$no_mode        0
#define		$sys_sm_mode	1
#define		$sys_sa_mode	2
#define		$sys_lo_mode	3
#define		$sys_cf_mode	4

// 
#property	$break_switch    : int


// システムメニューワイプ
#macro		@SysMenuWipe(@label, @Wipe(0), @Mod(2))
			farcall(_sys_menu_wipe, @label, @Wipe, @Mod)

// セーブワイプ
#macro		@SysConSAWipe(@label, @Wipe(0), @Mod(2))
			farcall(_sys_con_sa_wipe, @label, @Wipe, @Mod)

// ロードワイプ
#macro		@SysConLOWipe(@label, @Wipe(0), @Mod(2))
			farcall(_sys_con_lo_wipe, @label, @Wipe, @Mod)

// 環境設定ワイプ
#macro		@SysConCFWipe(@label, @Wipe(0), @Mod(2))
			farcall(_sys_con_cf_wipe, @label, @Wipe, @Mod)

// セーブオブジェクト初期化
#macro		@SysObjSAInit(@Dummy(0))
			@ex.f.obj[@ObjSysSA00].init
			@ex.f.obj[@ObjSysSA01].init
			@ex.f.obj[@ObjSysSA02].init
			@ex.f.obj[@ObjSysSA03].init
			@ex.f.obj[@ObjSysSA04].init
			@ex.f.obj[@ObjSysSA05].init
			@ex.f.obj[@ObjSysSA06].init
			@ex.f.obj[@ObjSysSA07].init
			@ex.f.obj[@ObjSysSA08].init
			@ex.f.obj[@ObjSysSA09].init
			@ex.f.obj[@ObjSysSA10].init
			@ex.f.obj[@ObjSysSA11].init
			@ex.f.obj[@ObjSysSA12].init
			@ex.f.obj[@ObjSysSA13].init
			@ex.f.obj[@ObjSysSA14].init
			@ex.f.obj[@ObjSysSA15].init
			@ex.f.obj[@ObjSysSA16].init
			@ex.f.obj[@ObjSysSA17].init
			@ex.f.obj[@ObjSysSA18].init

// ロードオブジェクト初期化
#macro		@SysObjLOInit(@Dummy(0))
			@ex.f.obj[@ObjSysLO00].init
			@ex.f.obj[@ObjSysLO01].init
			@ex.f.obj[@ObjSysLO02].init
			@ex.f.obj[@ObjSysLO03].init
			@ex.f.obj[@ObjSysLO04].init
			@ex.f.obj[@ObjSysLO05].init
			@ex.f.obj[@ObjSysLO06].init
			@ex.f.obj[@ObjSysLO07].init
			@ex.f.obj[@ObjSysLO08].init
			@ex.f.obj[@ObjSysLO09].init
			@ex.f.obj[@ObjSysLO10].init
			@ex.f.obj[@ObjSysLO11].init
			@ex.f.obj[@ObjSysLO12].init
			@ex.f.obj[@ObjSysLO13].init
			@ex.f.obj[@ObjSysLO14].init
			@ex.f.obj[@ObjSysLO15].init
			@ex.f.obj[@ObjSysLO16].init
			@ex.f.obj[@ObjSysLO17].init
			@ex.f.obj[@ObjSysLO18].init

// 環境設定オブジェクト初期化
#macro		@SysObjCFInit(@Dummy(0))
			@ex.f.obj[@ObjSysCF00].init
			@ex.f.obj[@ObjSysCF01].init
			@ex.f.obj[@ObjSysCF02].init
			@ex.f.obj[@ObjSysCF03].init



#define		@WipeIn0		0
#define		@WipeIn1		1
#define		@WipeIn2		2
#define		@WipeIn3		3
#define		@WipeIn4		4
#define		@WipeOut0		5
#define		@WipeOut1		6
#define		@WipeOut2		7
#define		@WipeOut3		8
#define		@WipeOut4		9

#define		DrowSkipCount			C[0]
#define		DrowSkipCountPreview	C[1]
#define		DrowSkipCountNew		C[2]
#define		DrowSkipTimes			C[3]

// 早送り初期化＆設定[ワイプ]
#macro			@DrawSkipInit(@Times(1))
				DrowSkipCount = @Init
				DrowSkipCountPreview = @Init
				DrowSkipCountNew = @Init
				DrowSkipTimes = @Times

// 早送り開始[ワイプ]
#macro			@DrawSkip(@Times(3))				// n(@Times)倍速
				DrowSkipCountPreview = DrowSkipCount
				DrowSkipCountNew = DrowSkipCountPreview * DrowSkipTimes
				if ((input.decide.on_down_up == @On) || (input.cancel.on_down_up == @On))	{
					input.clear
					DrowSkipTimes = @Times
				}
				DrowSkipCount = DrowSkipCountNew

// クイックセーブ
#command	$sys_quick_save_btn

// クイックロード
#command	$sys_quick_load_btn

// ---------------------------------------------------------------
// 独自汎用フラグ
// ---------------------------------------------------------------
#property	$_L : intlist[30]
#property	$_K : strlist[30]


// ---------------------------------------------------------------
// 認証
// ---------------------------------------------------------------
#define		@初回起動		G[800]
#define		@初回起動設定	G[801]
#define		@アルエット開始	G[802]
#define		@初期設定		$first_gameset
#property	$first_gameset : int

// スクリプト初期設定
#macro		@ゆめいろアルエット！	0
#macro		@AngelBeats!			0
#define		@OBJ_DAYS				270
#property	$days_create : int
#macro		@SetGameScriptData(@TITLE_NUM)
			if (@初期設定 == @Off)	{
				$sys_set_gsd
//				farcall("_sys_set_gsd", @TITLE_NUM)
				@初期設定 = @On
			}


#command	$sys_set_gsd


// ---------------------------------------------------------------
// マウスフラグ関連
// ---------------------------------------------------------------

// フラグスイッチ
#define		@ON				1
#define		@OFF			0
#define		@FORBID			4
#define		@Operate		4
#define		@ＯＮ			1
#define		@ＯＦＦ			0
#define		@見た			1
#define		@見てない		0
#define		@既読			1
#define		@未読			0
#define		@INIT			0
#define		@Def			0
#define		@Fast			1
#define		@Inst			2
#define		@StateOff		0
#define		@StateOn		5
#define		@Empty			0

// マウス
#define		@MX				mouse.pos_x
#define		@MY				mouse.pos_y
#define		@ML				$ml
#define		@MR				$mr
#define		@MX_PREV		$mx_prev
#define		@MY_PREV		$my_prev

// マウスボタン
#define		@MC_UP			0
#define		@MC_DOWN		1
#define		@MC_UD			2

// マウスボタン入力判定
#define		@前マウスチェック		$mschk_prev
#define		@マウス状態				$ms_state
#define		@前マウス状態			$ms_state_prev
#define		@ボタン状態				$msbtn_state
#define		@メニュー選択			$msbtn_result
#define		@何も当たっていない		774
#define		@初期					-1
#define		@通常					0
#define		@選択不可				1
#define		@当たっている			2
#define		@押している				3
#define		@再生中					4
#define		@未決定					0
#define		@決定					1
#define		@MSCHK					$mschk
#define		@MSCHK_PREV				$mschk_prev
#define		@MS_STATE				$ms_state
#define		@MS_STATE_CONF			$ms_state_conf
#define		@MS_STATE_CONF_PREV		$ms_state_conf_prev
#define		@MS_STATE_PREV			$ms_state_prev
#define		@MSBTN_STATE			$msbtn_state
#define		@MSBTN_RESULT			$msbtn_result
#define		@MSBTN_NONE				774
#define		@MSBTN_INIT				-1
#define		@MSBTN_NORMAL			0
#define		@MSBTN_OFF				1
#define		@MSBTN_TOUCH			2
#define		@MSBTN_PUSH				3
#define		@MSBTN_DISP				4
#define		@MSBTN_CHK				4
#define		@MSWHL_STATE			$mswhl_state

#define		@DECIDE					1
#define		@ObjBtnState[			$obj_btn_state[

#define		@TypeDF					0
#define		@TypeSM					1
#define		@TypeSL					2
#define		@TypeCF					3
#define		@TypeSC					4
#define		@TypeOP					5
#define		@TypeEX					6

// マウスチェック
#macro		@MouseBtnInit(@MsCheck(774),@MsCheckPreview(774),@MsState(-1),@MsStatePreview(-1),@MsBtnState(0),@MenuSel(0))
			input.clear
			@MSCHK              = @MsCheck			// @何も当たっていない
			@MSCHK_PREV         = @MsCheckPreview	// @マウスチェック
			@MS_STATE           = @MsState			// @初期
			@MS_STATE_CONF      = @MsState			// @初期
			@MS_STATE_CONF_PREV = @MsState			// @初期
			@MS_STATE_PREV      = @MsStatePreview	// @初期
			@MSBTN_STATE        = @MsBtnState		// @通常
			@MSBTN_RESULT       = @MenuSel			// @未決定

// マウス状態セット
#macro		@MsStateSet(@SFlag,@EFlag)
			for ($sys_smlc[0] = @SFlag, $sys_smlc[0] <= @EFlag, $sys_smlc[0] += 1)	{
				@ObjBtnState[+$sys_smlc[0]] = @MSBTN_NORMAL
			}
			if (@MSCHK != @MSBTN_NONE)	{
				@ObjBtnState[+@MSCHK] = @MSBTN_STATE
			}

// マウスカーソル判定 []
#macro		@if_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_OBJ_CHILD_POSRECT(@Obj, @ObjCD)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}

// マウスカーソル判定 [] - pixel
#macro		@if_Pixel_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD, @COL_R, @COL_G, @COL_B)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_OBJ_CHILD_PIXGET(@Obj, @ObjCD, @MX, @MY, @COL_R, @COL_G, @COL_B)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}


// マウスカーソル判定 [修正座標]
#macro		@if_rep_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_OBJ_CHILD_POSRECT_REP(@Obj, @ObjCD)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}

// マウスカーソル判定 [excall]
#macro		@exif_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_EX_OBJ_CHILD_POSRECT(@Obj, @ObjCD)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}

// マウスカーソル判定 [excall] - Clip	スライダー用
#macro		@exif_Clip_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj01, @ObjCD01, @Obj02, @ObjCD02)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_EX_OBJ_CHILD_CLIP_POSRECT(@Obj01, @ObjCD01, @Obj02, @ObjCD02)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}







// マウスカーソル判定 [excall] - pixel
#macro		@exif_Pixel_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD, @COL_R, @COL_G, @COL_B)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_EX_OBJ_CHILD_PIXGET(@Obj, @ObjCD, @MX, @MY, @COL_R, @COL_G, @COL_B)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}

// マウスカーソル判定 [excall] - pixel cut_pos
#macro		@exif_Pixel_cut_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD, @COL_R, @COL_G, @COL_B, @CUT_NO)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_EX_OBJ_CHILD_PIXGET_CUT(@Obj, @ObjCD, @MX, @MY, @COL_R, @COL_G, @COL_B, @CUT_NO)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}




// マウスカーソル判定_セーブボタン [excall]
#macro		@exif_slbtn_(@DataNo, @MSCHK_NUM, @Obj, @ObjCD)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_EX_OBJ_CHILD_POSRECT(@Obj, @ObjCD)	{
					if ((@SysSLDataExist[+@DataNo] < @On) && ((@DataStateCnt == @Off) && (@SLDataState == @DataCopy)))	{
						// コピー元にデータが無い場合
					}
					elseif ((@SysSLDataExist[+@DataNo] < @On) && (@SLDataState == @DataDelete))	{
						// 削除元にデータが無い場合
					}
					elseif ((@SysSLPageExist[+@DataNo] == @StateData01) && ((@DataStateCnt == @On) && (@SLDataState == @DataCopy)))	{
						// コピー元とコピー先が同じ場合
					}
					elseif ((@SysSLPageExist[+@DataNo] == @StateData01) && ((@DataStateCnt == @On) && (@SLDataState == @DataChange)))	{
						// 入れ替え元と入れ替え先が同じ場合
					}
					elseif (@SysSLDataLock[+@DataNo+(@SysSLPage*10)] == @On)	{
						// データがロックされてる場合
						@SysSLLockState[+@DataNo] = @On
						if (($sys_mode == $sys_lo_mode) && (@MSCHK_NUM >= 39) && (@MSCHK_NUM <= 48) && (@SLDataState == @DataNormal))	{
							// ロック中にもロード（2012/02/21）
							@MSCHK = @MSCHK_NUM
						}
					}
					elseif (($sys_mode == $sys_lo_mode) && (@SLDataState == @DataNormal) && (@MSCHK_NUM < 50))	{	// @MSCHK_NUM注意 loadと連携
						if (@SysSLDataExist[+@DataNo] != @Off)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}

				}
			}
/*
// マウスカーソル判定_ショートカット []
#macro		@if_sc_(@MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD, @MSX1, @MSX2, @MSY1,@MSY2)
			if ((system.check_active && (@MSCHK == @MSBTN_NONE)) && (((@MX >= @MSX1) && (@MX <= @MSX2)) && ((@MY >= @MSY1) && (@MY <= @MSY2))))	{
				@IF_OBJ_CHILD_POSRECT(@Obj, @ObjCD)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}
*/
// マウスカーソル判定_ショートカット [mwnd]
#macro		@if_sc_(@MwndNum, @MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD, @REP_X, @REP_Y, @MSX1, @MSX2, @MSY1,@MSY2)
			if ((system.check_active && (@MSCHK == @MSBTN_NONE)) && (((@MX >= @MSX1) && (@MX <= @MSX2)) && ((@MY >= @MSY1) && (@MY <= @MSY2))))	{
				@IF_MWND_OBJ_CHILD_POSRECT(@MwndNum, @Obj, @ObjCD, @REP_X, @REP_Y)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}

// マウスカーソル判定_ショートカット [mwnd] - pixel
#macro		@exif_sc_pixel_(@MwndNum, @MsCR, @MsDecide, @MSCHK_NUM, @Obj, @ObjCD, @COL_R, @COL_G, @COL_B, @CUT_NO)
			if ((system.check_active) && (@MSCHK == @MSBTN_NONE) && ((@MX >= 0) && (@MX <= 1280)))	{
				@IF_MWND_OBJ_CHILD_PIXGET(@MwndNum, @Obj, @ObjCD, @MX, @MY, @COL_R, @COL_G, @COL_B, @CUT_NO)	{
					if (@MsCR != @Off )	{
						if (@MsDecide)	{
							@MSCHK = @MSCHK_NUM
						}
					}
					else	{
						@MSCHK = @MSCHK_NUM
					}
				}
			}



// todo @MsBtnInputDecide をユーザーコマンド化

// マウスボタン入力判定
#macro		@MsBtnInputDecide(@Type, @Num(0))
			if ((@Type == @TypeDF) || (@Type == @TypeSM) || (@Type == @TypeSL) || (@Type == @TypeCF) || (@Type == @TypeSC) || (@Type == @TypeOP) || (@Type == @TypeEX))	{
				// マウスボタン入力判定
				if (input.decide.is_up == @On)	{
					if (@MSCHK != @MSBTN_NONE){
						if (@MSCHK != @MSCHK_PREV)	{
							if (@MSWHL_STATE == @Init)	{
								@se_play(000)
							}
						}
						@MSBTN_STATE = @MSBTN_TOUCH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				elseif (input.decide.is_down == @On)	{
/*
					// フリック判定
					if ((@MSCHK >= 2) && (@MSCHK <= 3))	{
						$sys_flick_init
					}
					else	{
						$sys_flick_decide
					}
*/
					if (@MS_STATE_PREV != @MSBTN_INIT)	{
						if ((@MSCHK == @MS_STATE_PREV) && (@MSCHK != @MSBTN_NONE))	{
							if (@MSCHK != @MSCHK_PREV)	{
								@se_play(000)
							}
							@MSBTN_STATE = @MSBTN_PUSH
							if (@Type == @TypeCF)	{
								// システムページ
								if (@SysCFPage == 0)	{
									// 画面モード
									if ((@MSCHK >= 2) && (@MSCHK <= 3))	{
										@MSBTN_RESULT = @DECIDE
										@MS_STATE = @MSBTN_INIT
									}
									// 演出速度／メッセージスキップ／オートセーブ／分岐でオートモード／分岐でスキップモード
									elseif ((@MSCHK >= 5) && (@MSCHK <= 26))	{
										@MSBTN_RESULT = @DECIDE
										@MS_STATE = @MSBTN_INIT
									}
									// メッセージスキップ
//									elseif ((@MSCHK >= 19) && (@MSCHK <= 20))	{
//										@MSBTN_RESULT = @DECIDE
//										@MS_STATE = @MSBTN_INIT
//									}
									// 右クリック動作
									elseif ((@MSCHK >= 27) && (@MSCHK <= 32))	{
										@MSBTN_RESULT = @DECIDE
										@MS_STATE = @MSBTN_INIT
									}
								}
								// サウンドページ
								else	{
									// ＢＧＭタイトル／システム音声
									if ((@MSCHK >= 53) && (@MSCHK <= 57))	{
										@MSBTN_RESULT = @DECIDE
										@MS_STATE = @MSBTN_INIT
									}
									// キャラクター音声
//									if ((@MSCHK >= 48) && (@MSCHK <= 49))	{
//										@MSBTN_RESULT = @DECIDE
//										@MS_STATE = @MSBTN_INIT
//									}
								}
							}
						}
						else	{
							@MSBTN_STATE = @MSBTN_NORMAL
							if ((@Type == @TypeCF) && (@S_CTL_BAR_CTLACTIVE == @On))	{
								// Ｃｔｒｌ
								@MSBTN_STATE = @MSBTN_PUSH
							}
						}
					}
					else	{
						@MSBTN_STATE = @MSBTN_PUSH
						@MS_STATE = @MSCHK
					}
				}
				if (input.cancel.on_down_up == @On)	{
					input.clear
					switch (@Type)	{
						case (@TypeOP)
							input.clear
							if ($sys_mode == $sys_sa_mode)	{
//								@ex.f.obj[@ObjSysSAOP00].scale_x_eve.set(0, 250, 0, 2)
//								@ex.f.obj[@ObjSysSAOP00].scale_y_eve.set(0, 250, 0, 2)
							}
							elseif ($sys_mode == $sys_lo_mode)	{
//								@ex.f.obj[@ObjSysLOOP00].scale_x_eve.set(0, 250, 0, 2)
//								@ex.f.obj[@ObjSysLOOP00].scale_y_eve.set(0, 250, 0, 2)
							}
							$break_switch = @On
						case (@TypeSC)
							// 右クリック無効
							// タイトルメニューに限りSettingを開く
//							$setting_disp
						case (@TypeDF)
							// 汎用
							if (@Num == 0)	{
								$break_switch = @On
							}
							elseif (@Num == 1)	{
								// セーブ／ロード確認キャンセル
								// ＳＥ
								@se_play(002)
								input.clear
/*
								if ($sys_mode == $sys_sa_mode)	{
									@ex.f.obj[@ObjSysSAConf00].@cd[_ObjSysSASAddBg00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysSAConf00].@cd[_ObjSysSASAddChk00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysSAConf00].@cd[_ObjSysSASAddYes00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysSAConf00].@cd[_ObjSysSASAddNo00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysSAConf00].scale_x_eve.set(1500, 250, 0, 2)
									@ex.f.obj[@ObjSysSAConf00].scale_y_eve.set(1500, 250, 0, 2)
								}
								elseif ($sys_mode == $sys_lo_mode)	{
									@ex.f.obj[@ObjSysLOConf00].@cd[_ObjSysLOLAddBg00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysLOConf00].@cd[_ObjSysLOLAddChk00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysLOConf00].@cd[_ObjSysLOLAddYes00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysLOConf00].@cd[_ObjSysLOLAddNo00].tr_eve.set(0, 250, 0, 2)
									@ex.f.obj[@ObjSysLOConf00].scale_x_eve.set(1500, 250, 0, 2)
									@ex.f.obj[@ObjSysLOConf00].scale_y_eve.set(1500, 250, 0, 2)
								}
								return(1)
*/
							}
						case (@TypeSM)
							// システムメニュー
							@ex.F[$sys_sm_mode] = @Off
							@ex.F[$sys_sa_mode] = @Off
							@ex.F[$sys_lo_mode] = @Off
							@ex.F[$sys_cf_mode] = @Off
							$break_switch = @On
						case (@TypeSL)
							// ヘルプ項目
							if (@SysSLhelpDisp == @On)	{
								@SysSLhelpDisp = @Off
								if ($sys_mode == $sys_sa_mode)	{
//									@ex.f.obj[@ObjSysSA01].@cd[_ObjSysSAHelp00].disp = @Off
								}
								elseif ($sys_mode == $sys_lo_mode)	{
//									@ex.f.obj[@ObjSysLO01].@cd[_ObjSysLOHelp00].disp = @Off
								}
								goto ##MenuSel00
							}
							// セーブ／ロード
							if (@SLDataState == @DataNormal)	{
								// システムメニューに復帰
								@SysSLDate00 = -1
								@ex.F[$sys_sm_mode] = @Off
								@ex.F[$sys_sa_mode] = @Off
								@ex.F[$sys_lo_mode] = @Off
								@ex.F[$sys_cf_mode] = @Off
								$break_switch = @On
							}
							else	{
								// コピー／入れ替え／削除キャンセル
								@DataStateCnt = @OFF
								@SLDataState  = @DataNormal
								goto ##MenuSel00
							}
						case (@TypeCF)
//							if (@SysCFhelpDisp == @On)	{
//								@SysCFhelpDisp = @Off
//								@ex.f.obj[@ObjSysCF01].@cd[_ObjSysCFHelp00].disp = @Off
//								goto ##MenuSel00
//							}
							// システムメニューに復帰
							@SysSLDate00 = -1
							@ex.F[$sys_sm_mode] = @Off
							@ex.F[$sys_sa_mode] = @Off
							@ex.F[$sys_lo_mode] = @Off
							@ex.F[$sys_cf_mode] = @Off
							$break_switch = @On
						case (@TypeEX)
							// ヘルプ表示中
							if (@ExtraHelpDsip == @On)	{
								@MSBTN_RESULT = @DECIDE
								@MSCHK = @Num
							}
							else	{
								$break_switch = @On
							}
					}
				}
				elseif (input.decide.on_down_up == @On)	{
					if (@MS_STATE_PREV != @MSBTN_INIT){
						if ((@MSCHK == @MS_STATE_PREV) && (@MSCHK != @MSBTN_NONE))	{
							@MSBTN_STATE = @MSBTN_TOUCH
							@MSBTN_RESULT = @DECIDE
							// フリック初期化
//							$sys_flick_init
						}
						else{
							@MSBTN_STATE = @MSBTN_NORMAL
							// フリック動作
//							$sys_flick_move(@Type)
						}
						@MS_STATE = @MSBTN_INIT
					}
					if (@Type == @TypeCF)	{
						@S_CTL_LBTN_ACTIVE = @Off
						@S_CTL_RBTN_ACTIVE = @Off
					}
					input.clear
				}
			}


// マウスボタン入力判定ＳＣ
#macro		@MsBtnInputDecideSC(@Type(0))
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
				if (@MS_STATE != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE) && (@MSCHK != @MSBTN_NONE))	{
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
//				@MSBTN_RESULT = @DECIDE
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

//#command    $sys_menu_disp

//#command	$sys_flick_decide
//#command	$sys_flick_move(int)
//#command	$sys_flick_init

#property	$ml                 : int
#property	$mr                 : int
#property	$mx_prev            : int
#property	$my_prev            : int
#property	$mschk              : int
#property	$mschk_prev         : int
#property	$ms_state           : int
#property	$ms_state_conf      : int
#property	$ms_state_prev      : int
#property	$ms_state_conf_prev : int
#property	$msbtn_state        : int
#property	$msbtn_result       : int
#property	$mswhl_state        : int
#property	$obj_btn_state      : intlist[500]
#property	$btn_state_switch   : intlist[500]

#property	$flick_state        : int
#property	$flick_mov_x        : int
#property	$flick_mov_y        : int

#property	$flick_add_x        : int
#property	$flick_add_y        : int

#property	$flick_decide       : int


// ---------------------------------------------------------------
// システムボイス
// ---------------------------------------------------------------
#macro		@SYS_VOICE_SET(@Buf)
			input.clear
			if (<@SVState> != 6)	{
				counter[0].start
				while (1)	{
					C[0] = counter[0].get
					A[0] = @PCMSTOPCHECK(@Buf)
					disp
					if ((input.decide.is_down == <@ON>) || (input.cancel.is_down == <@ON>) || (A[0] == 0))	{
						break
					}
				}
			}
			elseif (<@SVState> == 6)	{
				@TIMEWAITKEY(250)
			}


// ---------------------------------------------------------------
// 	タイトルメニュー
// ---------------------------------------------------------------
#define		@ObjSysTMenu00				290
#define		_ObjSysTMenuFade00			  0
#define		_ObjSysTMenuFade01			  1
#define		_ObjSysTMenuSysBg00			  2
#define		_ObjSysTMenuBg01			  3
#define		_ObjSysTMenuBg02			  4
#define		_ObjSysTMenuBg03			  5
#define		_ObjSysTMenuBg04			  6
#define		_ObjSysTMenuBg05			  7
#define		_ObjSysTMenuBg06			  8
#define		_ObjSysTMenuBg01w			  9
#define		_ObjSysTMenuBg02w			 10
#define		_ObjSysTMenuBg03w			 11
#define		_ObjSysTMenuBg04w			 12
#define		_ObjSysTMenuBg05w			 13
#define		_ObjSysTMenuBg06w			 14
#define		_ObjSysTMenuEf01			 15
#define		_ObjSysTMenuEf02			 16
#define		_ObjSysTMenuEf03			 17
#define		_ObjSysTMenuEf04			 18
#define		_ObjSysTMenuBtn00			 19		// ボタンエフェクト
#define		_ObjSysTMenuBtn01			 20		// Operation Start
#define		_ObjSysTMenuBtn02			 21		// Continue
#define		_ObjSysTMenuBtn03			 22		// Load
#define		_ObjSysTMenuBtn04			 23		// Config
#define		_ObjSysTMenuBtn05			 24		// Extra
#define		_ObjSysTMenuBtn06			 25		// Exit
#define		_ObjSysTMenuBtn07			 26		// 
#define		_ObjSysTMenuBtn08			 27		// 
#define		_ObjSysTMenuBtn09			 28		// 
// クイックセーブ／ロード
#define		_ObjSysQDataBg00			  0		// 下地
#define		_ObjSysQDataBtn01			  1		// Yes
#define		_ObjSysQDataBtn02			  2		// No
#define		_ObjSysQDataChk00			  3		// Check
#define		_ObjSysQDataFilter00		  4		// フィルター

#define		@TM_STATE					$tm_state
#define		@TM_CONF					G[1500]	// ロゴ表示判定
#define		@CH_FTIME					G[1501]	// ２週目初回用フラグ
#define		@TM_BG_CHA					M[1999]
#define		@TM_EXTRA					$tm_extra

#property	$tm_state : int
#property	$next_beat : int
#property	$tm_extra : int

// ---------------------------------------------------------------
// 時短再生設定
// ---------------------------------------------------------------
#define		@ObjSysTCSet				2		// excall.obj
// 下地
#define		_ObjSysTCBg00				0
// スライダーバー
#define		_ObjSysTCBar00				1
#define		_ObjSysTCCtl00				2
#define		_ObjSysTCCtl01				3
// 倍速表示
#define		_ObjSysTCSpd00				4
// 文章を普通に読み進めて…
#define		_ObjSysTCChk01				5
// オートモード中に…
#define		_ObjSysTCChk02				6
// 音声のリプレイ時にに…
#define		_ObjSysTCChk03				7
// 初期設定
#define		_ObjSysTCBtn01				8
// テスト再生
#define		_ObjSysTCBtn02				9
#define		@TCChkState01				$tcchkstate01
#define		@TCChkState02				$tcchkstate02
#define		@TCChkState03				$tcchkstate03
#define		@TCSpdState					$tcspdstate
#define		@TCChkDefState01			$tcchkdefstate01
#define		@TCChkDefState02			$tcchkdefstate02
#define		@TCChkDefState03			$tcchkdefstate03
#define		@TCSpdDefState				$tcspddefstate
#define		@TCSpdData					$tcspddata

#property	$tcchkstate01    : int
#property	$tcchkstate02    : int
#property	$tcchkstate03    : int
#property	$tcspdstate      : int
#property	$tcchkdefstate01 : int
#property	$tcchkdefstate02 : int
#property	$tcchkdefstate03 : int
#property	$tcspddefstate   : int
#property	$tcspddata       : int
/****************************************************************
*		 スライダーの座標は毎ゲームごとに設定すること 			*
*		 番号は基本的に固定だが、毎回必ず確認すること 			*
*****************************************************************/
// スライダーバー
#define		@S_CTR_BAR_POS_DEFULT02				  10
// 時短再生
#define		@S_CTL_BAR_TCSPD_STPOS				 758-4
#define		@S_CTL_BAR_TCSPD_EDPOS				 960-6
#define		@S_CTL_BAR_TC						$s_ctl_bar_tc
#define		@S_CTL_BAR_POS_TC					$s_ctl_bar_pos_tc
//#define		@S_CTR_BAR_TCSPD_POS01				557		// 等速
//#define		@S_CTR_BAR_TCSPD_POS02				518		// １．２５倍速
//#define		@S_CTR_BAR_TCSPD_POS03				479		// １．５倍速
//#define		@S_CTR_BAR_TCSPD_POS04				440		// １．７５倍速
//#define		@S_CTR_BAR_TCSPD_POS05				401		// ２倍速
//#define		@S_CTR_BAR_TCSPD_POS06				362		// ２．２５倍速
//#define		@S_CTR_BAR_TCSPD_POS07				323		// ２．５倍速
//#define		@S_CTR_BAR_TCSPD_POS08				284		// ２．７５倍速
//#define		@S_CTR_BAR_TCSPD_POS09				245		// ３倍速
#define		@TCSPD_CLR_SETPOS					$tcspd_clr_setpos
#define		@TCSPD_SET							$tcspd_set
#property	$tcspd_clr_setpos : int
#property	$tcspd_set        : int
#property	$s_ctl_bar_tc     : int
#property	$s_ctl_bar_pos_tc : int

// 時短再生状態取得
#macro		@GetSysTCState(@TCChk01, @TCChk02, @TCChk03, @TCSpd)
			@TCChk01 = syscom.get_jitan_normal_onoff
			@TCChk02 = syscom.get_jitan_auto_mode_onoff
			@TCChk03 = syscom.get_jitan_koe_replay_onoff
			@TCSpd   = syscom.get_jitan_speed
// 時短再生初期状態取得
#macro		@GetSysTCDefState(@TCChk01, @TCChk02, @TCChk03, @TCSpd)
			@TCChk01 = @OFF
			@TCChk02 = @OFF
			@TCChk03 = @OFF
			@TCSpd   = 100
// 時短再生初期状態設定
#define		@SetSysTCStateDefault
			syscom.set_jitan_speed_default
			syscom.set_jitan_normal_onoff_default
			syscom.set_jitan_auto_mode_onoff_default
			syscom.set_jitan_koe_replay_onoff_default
			@GetSysTCState(@TCChkState01,@TCChkState02,@TCChkState03,@TCSpdState)

// 時短再生ＣＴＬ初期座標指定
#macro		@SetTCSpdData(@Data)
			    if((@Data >= 100) && (@Data < 113)){@TCSPD_SET = 0 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS01 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 113) && (@Data < 138)){@TCSPD_SET = 1 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS02 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 138) && (@Data < 163)){@TCSPD_SET = 2 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS03 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 163) && (@Data < 188)){@TCSPD_SET = 3 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS04 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 188) && (@Data < 203)){@TCSPD_SET = 4 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS05 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 203) && (@Data < 228)){@TCSPD_SET = 5 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS06 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 228) && (@Data < 253)){@TCSPD_SET = 6 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS07 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 253) && (@Data < 278)){@TCSPD_SET = 7 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS08 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 278)                 ){@TCSPD_SET = 8 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS09 - (@S_CTR_BAR_POS_DEFULT02 / 2)}

// 時短再生ＣＴＬ座標指定
#macro		@GetTCSpdData(@Data)
			    if((@Data <= 265)                 ){@TCSPD_SET = 8 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS09 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 266) && (@Data < 304)){@TCSPD_SET = 7 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS08 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 304) && (@Data < 343)){@TCSPD_SET = 6 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS07 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 343) && (@Data < 382)){@TCSPD_SET = 5 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS06 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 382) && (@Data < 421)){@TCSPD_SET = 4 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS05 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 421) && (@Data < 460)){@TCSPD_SET = 3 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS04 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 460) && (@Data < 499)){@TCSPD_SET = 2 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS03 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 499) && (@Data < 538)){@TCSPD_SET = 1 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS02 - (@S_CTR_BAR_POS_DEFULT02 / 2)}
			elseif((@Data >= 538)                 ){@TCSPD_SET = 0 @TCSPD_CLR_SETPOS = @S_CTR_BAR_TCSPD_POS01 - (@S_CTR_BAR_POS_DEFULT02 / 2)}

// 時短再生倍速設定
#macro		@SetTCSpd(@Data)
			    if(@TCSPD_SET == 0){@Data = 100}
			elseif(@TCSPD_SET == 1){@Data = 125}
			elseif(@TCSPD_SET == 2){@Data = 150}
			elseif(@TCSPD_SET == 3){@Data = 175}
			elseif(@TCSPD_SET == 4){@Data = 200}
			elseif(@TCSPD_SET == 5){@Data = 225}
			elseif(@TCSPD_SET == 6){@Data = 250}
			elseif(@TCSPD_SET == 7){@Data = 275}
			elseif(@TCSPD_SET == 8){@Data = 300}


// ---------------------------------------------------------------
// エクストラ
// ---------------------------------------------------------------
#define		@ObjSysExBgBack						291
#define		@ObjSysExGallery					292
#define		@ObjSysExGalleryThumb				293
#define		@ObjSysExCharacter					294
#define		@ObjSysExMode						295
#define		@ObjSysExCgDisp						296
#define		@ObjSysExHelp						297

#define		@ExtraMode							$extra_mode
#define		@leave								-1
#define		@GalleryMode						0
#define		@CharacterMode						1
#define		@GalleryPage						$gallery_page
#define		@GalleryPagePrev					$gallery_page_prev
#define		@CharacterPage						$charater_page
#define		@CharacterPagePrev					$charater_page_prev

#define		@CgDispNo							$cg_disp_no
#define		@CgScroll							$cg_Scroll

#define		@CharacterDsip						$charater_disp
#define		@CharacterDsipPrev					$charater_disp_prev

#define		@CmMenuClear						$cm_menu_clear

#define		@BgmPlayNo							$bgm_play_no
#define		@BgmPlayNoPrev						$bgm_play_no_prev
#define		@BgmListDisp						$bgm_list_disp
#define		@ExtraHelpDsip						$extra_help_dsip
#define		@GalleryThNo						$gallery_th_no
#define		@ThListDisp							$th_List_disp
#define		@ThNoNow							$th_no_now
#define		@シーン回想中						G[1560]
#define		@シーン回想中_GalleryPage			G[1561]
#define		@BgmPlayNoGF						G[1562]
#define		@GalleryHelpAutoDisp				G[1563]
#define		@CharacterHelpAutoDisp				G[1564]
#define		@CgDispHelpAutoDisp					G[1565]

// CG見た枚数（内部管理用）
#define		@CgWatchCnt							G[1570]

// CG見たフラグを立てる
//#command	$T_SetCgDisp(str)
//#macro		@T_ＣＧ見た(@name)					$T_SetCgDisp(@name)

/****************************************************************
*		 スライダーの座標は毎ゲームごとに設定すること 			*
*		 番号は基本的に固定だが、毎回必ず確認すること 			*
*****************************************************************/
// スライダーバー
#define		@S_CTR_BAR_POS_DEFULT05				  6
// エクストラＢＧＭボリューム
#define		@S_CTL_BAR_EXSPD_STPOS				 60
#define		@S_CTL_BAR_EXSPD_EDPOS				194
//134
// 背景リスト格納
#define		@BgList00							$bg_list
// キャラクターリスト
#define		@ChaList00							$bs_list
#define		@ChaListPrev00						$bs_list_prev
// キャラクターパターンリスト格納
#define		@ChaPatList00						$cha_pat_list
#define		@ChaPatListPrev00					$cha_pat_list_prev
// キャラクター服装パターンリスト格納
#define		@DressPatList00						$dress_pat_list
#define		@DressPatListPrev00					$dress_pat_list_prev
#define		@DressPatData00						$dress_pat_data
#define		@DressPatDataPrev00					$dress_pat_data_prev
// キャラクター表情パターンリスト格納
#define		@FacePatList00						$face_pat_list
#define		@FacePatListPrev00					$face_pat_list_prev
#define		@FacePatData00						$face_pat_data
#define		@FacePatDataPrev00					$face_pat_data_prev
// キャラクター距離パターンリスト格納
#define		@DisPatList00						$dis_pat_list
#define		@DisPatListPrev00					$dis_pat_list_prev
// 千尋パターン
#define		@CHList01							 0
#define		@CHList02							 1
#define		@CHList03							 2
#define		@CHList04							 3
#define		@CHList05							 4
#define		@CHList06							 5
#define		@CHList07							 6
#define		@CHPatList01						 0
#define		@CHPatList02						 1
#define		@CHPatList03						 2
#define		@CHPatList04						 3
#define		@CHPatList05						 4
#define		@CHPatList06						 5
#define		@CHPatList07						 6
#define		@CHDressList01						 0
#define		@CHDressList02						 1
#define		@CHDressList03						 2
#define		@CHDressList04						 3
#define		@CHDressList05						 4
#define		@CHDressList06						 5
#define		@CHDressList07						 6
#define		@CHFaceList01						 0
#define		@CHFaceList02						 1
#define		@CHFaceList03						 2
#define		@CHFaceList04						 3
#define		@CHFaceList05						 4
#define		@CHFaceList06						 5
#define		@CHFaceList07						 6
// 咲乃パターン
#define		@SKList01							 7
#define		@SKList02							 8
#define		@SKList03							 9
#define		@SKPatList01						 7
#define		@SKPatList02						 8
#define		@SKPatList03						 9
#define		@SKDressList01						 7
#define		@SKDressList02						 8
#define		@SKDressList03						 9
#define		@SKFaceList01						 7
#define		@SKFaceList02						 8
#define		@SKFaceList03						 9
// 澪パターン
#define		@MOList01							10
#define		@MOList02							11
#define		@MOList03							12
#define		@MOList04							13
#define		@MOList05							14
#define		@MOList06							15
#define		@MOList07							16
#define		@MOList08							17
#define		@MOList09							18
#define		@MOPatList01						10
#define		@MOPatList02						11
#define		@MOPatList03						12
#define		@MOPatList04						13
#define		@MOPatList05						14
#define		@MOPatList06						15
#define		@MOPatList07						16
#define		@MOPatList08						17
#define		@MOPatList09						18
#define		@MODressList01						10
#define		@MODressList02						11
#define		@MODressList03						12
#define		@MODressList04						13
#define		@MODressList05						14
#define		@MODressList06						15
#define		@MODressList07						16
#define		@MODressList08						17
#define		@MODressList09						18
#define		@MOFaceList01						10
#define		@MOFaceList02						11
#define		@MOFaceList03						12
#define		@MOFaceList04						13
#define		@MOFaceList05						14
#define		@MOFaceList06						15
#define		@MOFaceList07						16
#define		@MOFaceList08						17
#define		@MOFaceList09						18
// 夏穂パターン
#define		@KHList01							19
#define		@KHList02							20
#define		@KHList03							21
#define		@KHPatList01						19
#define		@KHPatList02						20
#define		@KHPatList03						21
#define		@KHDressList01						19
#define		@KHDressList02						20
#define		@KHDressList03						21
#define		@KHFaceList01						19
#define		@KHFaceList02						20
#define		@KHFaceList03						21
// 亜季パターン
#define		@AKList01							22
#define		@AKList02							23
#define		@AKList03							24
#define		@AKPatList01						22
#define		@AKPatList02						23
#define		@AKPatList03						24
#define		@AKDressList01						22
#define		@AKDressList02						23
#define		@AKDressList03						24
#define		@AKFaceList01						22
#define		@AKFaceList02						23
#define		@AKFaceList03						24
// 友恵パターン
#define		@TMList01							25
#define		@TMList02							26
#define		@TMPatList01						25
#define		@TMPatList02						26
#define		@TMDressList01						25
#define		@TMDressList02						26
#define		@TMFaceList01						25
#define		@TMFaceList02						26
// 春樹パターン
#define		@HRList01							27
#define		@HRPatList01						27
#define		@HRDressList01						27
#define		@HRFaceList01						27
// 将孝パターン
#define		@MSList01							28
#define		@MSList02							29
#define		@MSPatList01						28
#define		@MSPatList02						29
#define		@MSDressList01						28
#define		@MSDressList02						29
#define		@MSFaceList01						28
#define		@MSFaceList02						29
// コペルニクス１
#define		@CPList01							30
#define		@CPPatList01						30
#define		@CPDressList01						30
#define		@CPFaceList01						30
// コペルニクス１
#define		@CPList02							31
#define		@CPPatList02						31
#define		@CPDressList02						31
#define		@CPFaceList02						31
// 重治
#define		@SGList01							32
#define		@SGPatList01						32
#define		@SGDressList01						32
#define		@SGFaceList01						32
// アトランティス１
#define		@ATList01							33
#define		@ATPatList01						33
#define		@ATDressList01						33
#define		@ATFaceList01						33
// アトランティス２
#define		@ATList02							34
#define		@ATPatList02						34
#define		@ATDressList02						34
#define		@ATFaceList02						34
// 立ち絵無し
#define		@NOList01							35
#define		@NOPatList01						35
#define		@NODressList01						35
#define		@NOFaceList01						35

// 表示フラグ
#define		@BSListDisp							$bs_list_disp
#define		@BSListDisp[						$bs_list_disp[
#define		@CHListDisp[						$bs_list_disp[0+	//  0 -  6
#define		@SKListDisp[						$bs_list_disp[7+	//  7 -  9
#define		@MOListDisp[						$bs_list_disp[10+	// 10 - 18
#define		@KHListDisp[						$bs_list_disp[19+	// 19 - 21
#define		@AKListDisp[						$bs_list_disp[22+	// 22 - 24
#define		@TMListDisp[						$bs_list_disp[25+	// 25 - 26
#define		@HRListDisp[						$bs_list_disp[27+	// 27
#define		@MSListDisp[						$bs_list_disp[28+	// 28 - 29
#define		@CPListDisp[						$bs_list_disp[30+	// 30- 31
#define		@SGListDisp[						$bs_list_disp[32+	// 32
#define		@ATListDisp[						$bs_list_disp[33+	// 33 - 34
#define		@NOListDisp[						$bs_list_disp[35+	// 35

#property	$get_cg_flag  : intlist[100]	// 旧B[200]
#property	$set_cg_max   : intlist[100]	// 旧B[300]
#property	$get_cg_max   : intlist[100]	// 旧B[400]
#property	$set_cg_flag  : intlist[100]	// 旧B[500]

#property	$extra_mode         : int
#property	$gallery_page       : int
#property	$gallery_page_prev  : int
#property	$charater_page      : int
#property	$charater_page_prev : int
#property	$charater_disp      : int
#property	$charater_disp_prev : int
#property	$bgm_play_no        : int
#property	$bgm_play_no_prev   : int
#property	$bgm_list_disp      : int
#property	$extra_help_dsip    : int


#property	$gallery_th_no : int
#property	$th_List_disp  : int
#property	$thcg_posx     : intlist[20]
#property	$thcg_posy     : intlist[20]
#property	$th_no_now     : int
#property	$cg_disp_no    : int
#property	$cg_Scroll     : int
#property	$cm_menu_clear : int

#property	$bg_list             : int
#property	$bs_list             : int
#property	$bs_list_prev        : int
#property	$cha_pat_list        : int
#property	$cha_pat_list_prev   : int
#property	$dress_pat_list      : int
#property	$dress_pat_list_prev : int
#property	$dress_pat_data      : str
#property	$dress_pat_data_prev : str
#property	$face_pat_list       : int
#property	$face_pat_list_prev  : int
#property	$face_pat_data       : str
#property	$face_pat_data_prev  : str
#property	$dis_pat_list        : int
#property	$dis_pat_list_prev   : int

#property	$bs_list_disp : intlist[36]

#property	$ch_list_disp   : intlist[7]
#property	$sk_list_disp   : intlist[3]
#property	$mo_list_disp   : intlist[9]
#property	$kh_list_disp   : intlist[3]
#property	$ak_list_disp   : intlist[3]
#property	$tm_list_disp   : intlist[2]
#property	$hr_list_disp   : intlist[1]
#property	$ms_list_disp	: intlist[2]
#property	$cp_list_disp   : intlist[2]
#property	$sg_list_disp   : intlist[1]
#property	$at_list_disp   : intlist[2]


// Character閲覧情報取得
#define		@GetChaDispInfo
			@BSListDisp.init
			if (@千尋１週目クリア == @On)	{@BSListDisp.clear( 0,  6, @On)}
			if (@咲乃クリア       == @On)	{@BSListDisp.clear( 7,  9, @On)}
			if (@澪クリア         == @On)	{@BSListDisp.clear(10, 18, @On)}
			if (@夏穂クリア       == @On)	{@BSListDisp.clear(19, 21, @On) @BSListDisp.clear(30, 31, @On) @BSListDisp.clear(32, 32, @On) @BSListDisp.clear(33, 34, @On)}
			if (@亜季クリア       == @On)	{@BSListDisp.clear(22, 24, @On)}
			if (@千尋２週目クリア == @On)	{@BSListDisp.clear(25, 26, @On)@BSListDisp.clear(27, 27, @On) @BSListDisp.clear(28, 29, @On)}
			@BSListDisp.clear(35, 35, @On)




// ＣＧ情報フラグ初期化
#macro		@CgFlagInit(@StFlag,@EdFlag)
			for (L[0] = @StFlag, L[0] <= @EdFlag, L[0] += 1)	{
				$get_cg_flag[0+L[0]] = @Init
				$set_cg_max[0+L[0]]  = @Init
				$get_cg_max[0+L[0]]  = @Init
				$set_cg_flag[0+L[0]] = @Init
			}

// ＣＧ取得チェック
#macro		@GetCgInfo(@Num,@Name)
			L[0] = cgtable.get_look_by_name(@Name)
			IF(L[0] == @On)	{
				// ＣＧを取得しているのでサムネイル表示フラグをＯＮにする
				$get_cg_flag[0+@Num] = @On
			}
			// ＣＧの最大枚数（分母）
			$set_cg_max[0+@Num] += 1
			// 取得したＣＧの枚数（分子）
			$get_cg_max[0+@Num] += L[0]

// ＣＧ差分取得チェック
#macro		@GetTCgInfo(@Num,@Name)
			L[0] = cgtable.get_look_by_name(@Name)
			if (L[0] = @On)	{
				// この名前の差分を取得している場合、フラグをＯＮにする
				$set_cg_flag[0+@Num] = @On
			}

// 回想シーン終了処理
#macro		@SceneEnd(@No)
			if (@シーン回想中 == @On)	{
				@bgm_stop(2000)
				// ＢＧＭ音タイトル表示中の場合
//				@f.obj[@SysBTDisp].tr_eve.set(0, 200, 0, 0)
				@fade(bg_kuro)
				@TM_CONF = @On
				@PCM_STOP @PCMCH_STOP_ALL
				syscom.return_to_menu(@Off, @Off, @Off)
			}
			else	{
				@シーン見たフラグ(@No) = @On
			}


// ---------------------------------------------------------------
// ムービー再生
// ---------------------------------------------------------------
#property	$ed_chihiro02_skip : int
#property	$omv_play : int

#property	$movie_fade_in : int

#define		@MovieFadeIn	$movie_fade_in
#define		@omv_ch		15

#define		@OBJ_OMV	270
#macro		@OMV_WIPE_COPY(@SWITCH)
			@f.obj[@OBJ_OMV].wipe_copy = @SWITCH

// @OBJ_OMV使用 @OBJ_BGXXは任意にINIT
#macro		@OMV_READY(@MOV, @BGM, @AUTO_FREE(1))
			// システム音を消去
			@se_stop
			// ムービー中判定フラグＯＮ
			$omv_play = @On
			if (@AUTO_FREE == @On)	{
				@f.obj[@OBJ_OMV].create_movie(@MOV, @Off, ready_only = @On, real_time = @On)
			}
			else	{
				@f.obj[@OBJ_OMV].create_movie(@MOV, @Off, ready_only = @On, real_time = @On, auto_free = @Off)
			}
			pcmch[@omv_ch].ready(bgm_name = @BGM, loop = @Off, volume_type = 4)	// 音量をムービーに割り当て

#define		@OMV_BGM_START
			pcmch[@omv_ch].resume

#macro		@OMV_BGM_VOLUME(@NUM)
			// 環境設定のムービーボリューム値をMAXとして補完値を求める
			L[0] = math.timetable(@NUM, 0, 0, [0, syscom.get_mov_volume, 255])
			pcmch[@omv_ch].set_volume(L[0])

#define		@OMV_BGM_VOLUME_UP
			frame_action.start(1500, "$omv_volume_up", pcmch[@omv_ch].get_volume)

#command	$omv_volume_up(frameaction, int)

#macro		@OMV_START(@BGM_DELAY(0), @OBJ_BG)
			@f.obj[@OBJ_OMV].disp = @On
			@f.obj[@OBJ_BG].init
			counter[0].start
			@f.obj[@OBJ_OMV].resume_movie
			if (@BGM_DELAY == 0)	{
				pcmch[@omv_ch].resume
			}
			else	{
				pcmch[@omv_ch].resume(delay = @BGM_DELAY)
			}

#macro		@OMV_END(@FLAG, @OMV_TIME, @BGM_FADE(0))
			if (@FLAG == @Off)	{
				timewait(@OMV_TIME)
//				@f.obj[@OBJ_OMV].wait_movie
			}
			else	{
				//@f.obj[@OBJ_OMV].wait_movie
				L[0] = timewait_key(@OMV_TIME)
				if (L[0] != 0)	{
					pcmch[@omv_ch].stop(@BGM_FADE)
					@fade(005, bg_kuro)
					$ed_chihiro02_skip = @On
				}
			}
			// 一時的にメッセージバックＯＦＦを解除する
			script.set_msg_back_enable
			// ムービー中判定フラグＯＦＦ
			$omv_play = @Off



#macro		@OMV_READY_BGM(@MOV, @BGM, @AUTO_FREE(1), @BGM_LOOP(0))
			// システム音を消去
			@se_stop
			// 「ウィンドウを消す」の設定を不可に
			syscom.set_hide_mwnd_enable_flag(0)
			// 一時的にメッセージバックに入るのを禁止する
			script.set_msg_back_disable
			// システムコマンドメニューを禁止
			syscom.set_syscom_menu_disable
			// ショートカット機能を禁止
			script.set_shortcut_disable
			// 一時的にマウスカーソルを非表示にする
			script.set_mouse_disp_off
			// 一時的に早送りを禁止する（Ctrl キーを含む）
			script.set_ctrl_skip_disable
			// ムービー中判定フラグＯＮ
			$omv_play = @On
			if (@AUTO_FREE == @On)	{
				@f.obj[@OBJ_OMV].create_movie(@MOV, @Off, ready_only = @On, real_time = @On)
			}
			else	{
				@f.obj[@OBJ_OMV].create_movie(@MOV, @Off, ready_only = @On, real_time = @On, auto_free = @Off)
			}
			bgm.ready(@BGM, loop = @BGM_LOOP)

#macro		@OMV_START_BGM(@BGM_DELAY(0), @OBJ_BG)
			@f.obj[@OBJ_OMV].disp = @On
			@f.obj[@OBJ_BG].init
			@f.obj[@OBJ_OMV].resume_movie
			if (@BGM_DELAY == 0)	{
				bgm.resume
			}
			else	{
				bgm.resume(delay = @BGM_DELAY)
			}

#macro		@OMV_END_BGM(@FLAG, @OMV_TIME, @BGM_FADE(0))
			if (@FLAG == @Off)	{
				@f.obj[@OBJ_OMV].wait_movie
			}
			else	{
				//@f.obj[@OBJ_OMV].wait_movie
				L[0] = timewait_key(@OMV_TIME)
				if (L[0] != 0)	{
//					$ed_chihiro02_skip = @On
					bgm.stop(@BGM_FADE)
					@fade(005, bg_kuro)
				}
			}
			if ((@咲乃フラグ == 4) && (@七不思議_咲乃 == @On))	{
				// 「ウィンドウを消す」の設定を可に
				syscom.set_hide_mwnd_enable_flag(1)
				// システムコマンドメニュー禁止を解除
				syscom.set_syscom_menu_enable
				// ショートカット機能禁止を解除
				script.set_shortcut_enable
				// 一時的にマウスカーソル非表示を解除
				script.set_mouse_disp_on
				// 一時的に早送り禁止を解除（Ctrl キーを含む）
				script.set_ctrl_skip_enable
			}
			// 一時的にメッセージバックＯＦＦを解除する
			script.set_msg_back_enable
			// ムービー中判定フラグＯＦＦ
			$omv_play = @Off


// ---------------------------------------------------------------
// システム音声
// ---------------------------------------------------------------
#macro		@SysVoice(@VoLavel, @VoiceNo, @BCall(0))
			// 本編中の音声が再生されてない場合のみシステム音声を再生
			$sys_koe_check = koe_check
			// ブランドコールはランダム
			@BrandCall = @BCall
			if ($sys_koe_check == @Off)	{
				@se_stop
				farcall("_sys_com_sysvoice", @VoLavel, @VoiceNo)
			}

#define		@VoTCLavel		00
#define		@VoDefLavel		01
#define		@BrandCall		$brand_call

#property	$sys_koe_check
#property	$brand_call


// ---------------------------------------------------------------
// ウィンドウ変更
// ---------------------------------------------------------------
#macro		@通常ウィンドウ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw01a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw01a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 0

#macro		@通常ウィンドウ＿顔グラ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw02a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw02a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 1

#macro		@大声ウィンドウ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw03a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw03a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 2

#macro		@大声ウィンドウ＿顔グラ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw04a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw04a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 3

#macro		@ひそひそウィンドウ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw05a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw05a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 4

#macro		@ひそひそウィンドウ＿顔グラ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw06a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw06a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 5

#macro		@加工ウィンドウ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw07a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw07a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 6

#macro		@加工ウィンドウ＿顔グラ(@Shake(0))
			// 吹き出し枠と下地のみ変更
			@f.mwnd[0].set_waku_file("_mw08a")	// 新コマンド
			@f.mwnd[0].set_filter_file("_mw08a_b")
//			farcall("_sys_com_mwnd", 00, 0)
			// 揺れ判定
			$waku_shake(@Shake)
			$waku_num = 7

#property	$get_mwnd_no : int
#property	$waku_num : int

#command	$waku_shake(int) : int

#define		@メッセージウィンドウ初期化
			farcall("_sys_com_mwnd", 00, 0)


// ---------------------------------------------------------------
// 曲名表示
// ---------------------------------------------------------------
#define		@SysBTDisp			230
#define		@ＢＧＭタイトル制御	$bgm_title_control


// ---------------------------------------------------------------
// 選択関連
// ---------------------------------------------------------------
//#define		@選択					F.bit8[1999]
#define		@SelColorNumBar01		000				// 未選択色	Gameexe.iniで設定
#define		@SelColorNumBar02		010				// 既選択色	Gameexe.iniで設定
#define		@SelAnswer01			G.bit2[$selFlag[0]] = @On
#define		@SelAnswer02			G.bit2[$selFlag[1]] = @On
#define		@SelAnswer03			G.bit2[$selFlag[2]] = @On
#define		@SelAnswer04			G.bit2[$selFlag[3]] = @On
#define		@SelAnswer05			G.bit2[$selFlag[4]] = @On
#define		@SelAnswer06			G.bit2[$selFlag[5]] = @On
#define		@SelColor0				$SelColor[0]
#define		@SelColor1				$SelColor[1]
#define		@SelColor2				$SelColor[2]
#define		@SelColor3				$SelColor[3]
#define		@SelColor4				$SelColor[4]
#define		@SelColor5				$SelColor[5]

// 選択カラー制御
#macro		@SelNumber(@No)		// G.bit2[14400]から使用 G[1800]
			if (@回想中 == @Off){
				$Save_point_state = savepoint
			}
			// 前の選択肢に戻るで戻ってきてない場合はセーブする
//			if (($Save_point_state == @Off) && (@EsAutoSave == @On))	{
//				capture
//				$sys_seL_save
//				capture_free	// 必須
//			}
			// スキップモード解除
			if (@EsSelSkipReset == @On)	{syscom.set_read_skip_onoff_flag(@Off)}
			// オートモード解除
			if (@EsSelAutoReset == @On)	{@AutoStartReady = @Off syscom.set_auto_mode_onoff_flag(@Off)}
			$SelNumBarFlag = @No
			$selFlag[0] = $SelNumBarFlag * 10 + 14400
			$selFlag[1] = $SelNumBarFlag * 10 + 14401
			$selFlag[2] = $SelNumBarFlag * 10 + 14402
			$selFlag[3] = $SelNumBarFlag * 10 + 14403
			$selFlag[4] = $SelNumBarFlag * 10 + 14404
			$selFlag[5] = $SelNumBarFlag * 10 + 14405
			if (G.bit2[$selFlag[0]] == @On)	{ $SelColor[0] = @SelColorNumBar02 } else { $SelColor[0] = @SelColorNumBar01}
			if (G.bit2[$selFlag[1]] == @On)	{ $SelColor[1] = @SelColorNumBar02 } else { $SelColor[1] = @SelColorNumBar01}
			if (G.bit2[$selFlag[2]] == @On)	{ $SelColor[2] = @SelColorNumBar02 } else { $SelColor[2] = @SelColorNumBar01}
			if (G.bit2[$selFlag[3]] == @On)	{ $SelColor[3] = @SelColorNumBar02 } else { $SelColor[3] = @SelColorNumBar01}
			if (G.bit2[$selFlag[4]] == @On)	{ $SelColor[4] = @SelColorNumBar02 } else { $SelColor[4] = @SelColorNumBar01}
			if (G.bit2[$selFlag[5]] == @On)	{ $SelColor[5] = @SelColorNumBar02 } else { $SelColor[5] = @SelColorNumBar01}

#macro		@SelCall
			capture = farcall("_sys_com_sel", 01), 
			sel_start_call_scn = "_sys_com_sel",
			sel_start_call_z_no = 0

#define		@オートセーブ制御
			$auto_save_control

#property	$auto_save_control
#command	$sys_seL_save : int
#command	$sys_day_save : int
#property	$SelNumBarFlag : int	// @SelNumBarFlag00
#property	$SelFlag : intlist[6]	// @SelFlag01-06
#property	$SelColor : intlist[6]
#property	$Save_point_state : int


// ---------------------------------------------------------------
// オブジェクト矩形判定
// ---------------------------------------------------------------
// 親
#macro		@IF_OBJ_POSRECT(@BUF)
			$obj_rect_x01 = @f.obj[@BUF].x
			$obj_rect_y01 = @f.obj[@BUF].y
			$obj_rect_x02 = @f.obj[@BUF].get_size_x
			$obj_rect_y02 = @f.obj[@BUF].get_size_y
			if (((@MX >= $obj_rect_x01) && (@MX < $obj_rect_x01 + $obj_rect_x02)) && 
			    ((@MY >= $obj_rect_y01) && (@MY < $obj_rect_y01 + $obj_rect_y02)))
// 子
#macro		@IF_OBJ_CHILD_POSRECT(@BUF,@C_CNT)
			$objcd_rect_x01 = @f.obj[@BUF].@cd[@C_CNT].x
			$objcd_rect_y01 = @f.obj[@BUF].@cd[@C_CNT].y
			$objcd_rect_x02 = @f.obj[@BUF].@cd[@C_CNT].get_size_x
			$objcd_rect_y02 = @f.obj[@BUF].@cd[@C_CNT].get_size_y
			if (((@MX >= $objcd_rect_x01) && (@MX < $objcd_rect_x01 + $objcd_rect_x02)) && 
			    ((@MY >= $objcd_rect_y01) && (@MY < $objcd_rect_y01 + $objcd_rect_y02)))

// 子[excall] - pixel
#macro		@IF_OBJ_CHILD_PIXGET(@BUF, @C_CNT, @MX, @MY, @COL_R, @COL_G, @COL_B)
			L[0] =  @f.obj[@BUF].@cd[@C_CNT].get_pixel_color_r(@MX - @f.obj[@BUF].@cd[@C_CNT].x, @MY - @f.obj[@BUF].@cd[@C_CNT].y)
			L[1] =  @f.obj[@BUF].@cd[@C_CNT].get_pixel_color_g(@MX - @f.obj[@BUF].@cd[@C_CNT].x, @MY - @f.obj[@BUF].@cd[@C_CNT].y)
			L[2] =  @f.obj[@BUF].@cd[@C_CNT].get_pixel_color_b(@MX - @f.obj[@BUF].@cd[@C_CNT].x, @MY - @f.obj[@BUF].@cd[@C_CNT].y)
			if ((L[0] == @COL_R) && (L[1] == @COL_G) && (L[2] == @COL_B))

// 子[修正座標]
#macro		@IF_OBJ_CHILD_POSRECT_REP(@BUF,@C_CNT)
			$objcd_rect_x01 = @f.obj[@BUF].@cd[@C_CNT].x + @f.obj[@BUF].x
			$objcd_rect_y01 = @f.obj[@BUF].@cd[@C_CNT].y + @f.obj[@BUF].y
			$objcd_rect_x02 = @f.obj[@BUF].@cd[@C_CNT].get_size_x
			$objcd_rect_y02 = @f.obj[@BUF].@cd[@C_CNT].get_size_y
			if (((@MX >= $objcd_rect_x01) && (@MX < $objcd_rect_x01 + $objcd_rect_x02)) && 
			    ((@MY >= $objcd_rect_y01) && (@MY < $objcd_rect_y01 + $objcd_rect_y02)))

// 親[excall]
#macro		@IF_EX_OBJ_POSRECT(@BUF)
			$obj_rect_x01 = @ex.f.obj[@BUF].x
			$obj_rect_y01 = @ex.f.obj[@BUF].y
			$obj_rect_x02 = @ex.f.obj[@BUF].get_size_x
			$obj_rect_y02 = @ex.f.obj[@BUF].get_size_y
			if (((@MX >= $obj_rect_x01) && (@MX < $obj_rect_x01 + $obj_rect_x02)) && 
			    ((@MY >= $obj_rect_y01) && (@MY < $obj_rect_y01 + $obj_rect_y02)))
// 子[excall]
#macro		@IF_EX_OBJ_CHILD_POSRECT(@BUF,@C_CNT)
			$objcd_rect_x01 = @ex.f.obj[@BUF].@cd[@C_CNT].x
			$objcd_rect_y01 = @ex.f.obj[@BUF].@cd[@C_CNT].y
			$objcd_rect_x02 = @ex.f.obj[@BUF].@cd[@C_CNT].get_size_x
			$objcd_rect_y02 = @ex.f.obj[@BUF].@cd[@C_CNT].get_size_y
			if (((@MX >= $objcd_rect_x01) && (@MX < $objcd_rect_x01 + $objcd_rect_x02)) && 
			    ((@MY >= $objcd_rect_y01) && (@MY < $objcd_rect_y01 + $objcd_rect_y02)))

// 子[excall] - Clip	スライダー用
#macro		@IF_EX_OBJ_CHILD_CLIP_POSRECT(@BUF01,@C_CNT01,@BUF02,@C_CNT02)
			$objcd_rect_x01 = @ex.f.obj[@BUF01].@cd[@C_CNT01].x
			$objcd_rect_y01 = @ex.f.obj[@BUF01].@cd[@C_CNT01].y
			$objcd_rect_x02 = @ex.f.obj[@BUF02].@cd[@C_CNT02].x		// 注意
			$objcd_rect_y02 = @ex.f.obj[@BUF01].@cd[@C_CNT01].get_size_y
			if (((@MX >= $objcd_rect_x01) && (@MX < $objcd_rect_x02)) && 
			    ((@MY >= $objcd_rect_y01) && (@MY < $objcd_rect_y01 + $objcd_rect_y02)))







// 子[excall] - pixel
#macro		@IF_EX_OBJ_CHILD_PIXGET(@BUF, @C_CNT, @MX, @MY, @COL_R, @COL_G, @COL_B)
			L[0] =  @ex.f.obj[@BUF].@cd[@C_CNT].get_pixel_color_r(@MX, @MY)
			L[1] =  @ex.f.obj[@BUF].@cd[@C_CNT].get_pixel_color_g(@MX, @MY)
			L[2] =  @ex.f.obj[@BUF].@cd[@C_CNT].get_pixel_color_b(@MX, @MY)
			if ((L[0] == @COL_R) && (L[1] == @COL_G) && (L[2] == @COL_B))

// 子[excall] - pixel cut_pos
#macro		@IF_EX_OBJ_CHILD_PIXGET_CUT(@BUF, @C_CNT, @MX, @MY, @COL_R, @COL_G, @COL_B, @CUT_NO)
			L[0] =  @ex.f.obj[@BUF].@cd[@C_CNT].get_pixel_color_r(@MX - @ex.f.obj[@BUF].@cd[@C_CNT].x, @MY - @ex.f.obj[@BUF].@cd[@C_CNT].y, @CUT_NO)
			L[1] =  @ex.f.obj[@BUF].@cd[@C_CNT].get_pixel_color_g(@MX - @ex.f.obj[@BUF].@cd[@C_CNT].x, @MY - @ex.f.obj[@BUF].@cd[@C_CNT].y, @CUT_NO)
			L[2] =  @ex.f.obj[@BUF].@cd[@C_CNT].get_pixel_color_b(@MX - @ex.f.obj[@BUF].@cd[@C_CNT].x, @MY - @ex.f.obj[@BUF].@cd[@C_CNT].y, @CUT_NO)
			if ((L[0] == @COL_R) && (L[1] == @COL_G) && (L[2] == @COL_B))

// 子[mwnd]
#macro		@IF_MWND_OBJ_CHILD_POSRECT(@MWND_NUM, @BUF,@C_CNT, @REP_X, @REP_Y)
			$objcd_rect_x01 = @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].x + @REP_X
			$objcd_rect_y01 = @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].y + @REP_Y
			$objcd_rect_x02 = @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].get_size_x
			$objcd_rect_y02 = @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].get_size_y
			if (((@MX >= $objcd_rect_x01) && (@MX < $objcd_rect_x01 + $objcd_rect_x02)) && 
			    ((@MY >= $objcd_rect_y01) && (@MY < $objcd_rect_y01 + $objcd_rect_y02)))

// 子[mwnd] - pixel
#macro		@IF_MWND_OBJ_CHILD_PIXGET(@MWND_NUM, @BUF, @C_CNT, @MX, @MY, @COL_R, @COL_G, @COL_B, @CUT_NO)
			L[0] =  @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].get_pixel_color_r(@MX, @MY, @CUT_NO)
			L[1] =  @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].get_pixel_color_g(@MX, @MY, @CUT_NO)
			L[2] =  @f.mwnd[@MWND_NUM].@obj[@BUF].@cd[@C_CNT].get_pixel_color_b(@MX, @MY, @CUT_NO)
			if ((L[0] == @COL_R) && (L[1] == @COL_G) && (L[2] == @COL_B))




#property	$obj_rect_x01 : int
#property	$obj_rect_y01 : int
#property	$obj_rect_x02 : int
#property	$obj_rect_y02 : int

#property	$objcd_rect_x01 : int
#property	$objcd_rect_y01 : int
#property	$objcd_rect_x02 : int
#property	$objcd_rect_y02 : int

#property	$obj_rect_pixel : int


//#command $sc_am_disp(frameaction)



