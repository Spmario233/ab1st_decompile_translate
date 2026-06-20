/********************************************************
*														*
*				セーブ／ロード画面						*
*														*
*********************************************************/
#inc_start

	// 壁紙
	#property	$sys_sl_bg0 : str

	// セーブ／ロードボタン[固定]
	#property	$sys_sl_page_cbtn : strlist[6]

	// セーブ／ロードページボタン[１～１００]
	#property	$sys_sl_page : strlist[20]

	// セーブ／ロードボタン下地
	#property	$sys_sl_data0 : str

	// コメント下地
	#property	$sys_sl_com0 : str

	// ロックボタン
	#property	$sys_sl_lock0 : str

	// 入れ替えボタン
	#property	$sys_sl_change0 : str

	// New／Next／巻数表示
	#property	$sys_sl_mark : strlist[2]

	// 削除ボタン
	#property	$sys_sl_del0 : str

	// セーブ番号
	#property	$sys_sl_num0 : str

#inc_end



#z00

// セーブ／ロード画面初期化
gosub #SLPageInit


#z01


// 全体のモード設定記憶
$sys_mode_prev = $sys_mode



// セーブ画面
if (@ex.F[$sys_sa_mode] == @On)	{
	@ex.F[$sys_sa_mode] = @Off
	$sys_mode = $sys_sa_mode
}
// ロード画面
elseif (@ex.F[$sys_lo_mode] == @On)	{
	@ex.F[$sys_lo_mode] = @Off
	$sys_mode = $sys_lo_mode
}


// ページ切り替え
#sa_page_change

// セーブ／ロードデータ取得
gosub #SAPageState


// オブジェクトの初期化
gosub #ObjInit00

// セーブ画面表示決定音
//@SysVoice(@VoDefLavel, 02)


// セーブ／ロード画面構築
gosub #ObjConstruct



// セーブ／ロード画面表示
gosub #ObjDisp



#z03




//
// セーブ／ロード画面実行
//

gosub #SLPagePut

// ページ切り替え
if (@SysSLPageChange == @On)	{
	goto #sa_page_change
}

// 初期化
$break_switch = @Off

// 現在のページ番号を記憶
@SysSLLastPage = @SysSLPage

// データ制御をノーマルに
@SLDataState = @DataNormal

// copy/change元初期化
@DataStateCnt = @Off

// 項目切り替え
if ((@ex.F[$sys_sa_mode] == @On) || (@ex.F[$sys_lo_mode] == @On))	{
	//セーブ／ ロード
	@se_play(001)
	@SysSLPageChange = @On
	goto #z01
}
elseif (@ex.F[$sys_cf_mode] == @On)	{
	// コンフィグ
	@se_play(001)
	jump(_sys_menu_cf01, 00)
}

// タイトルメニュー判定[ボタン状態初期化]
if (@TM_STATE == @On)	{
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn04].patno = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn05].patno = 0
	@f.obj[@ObjSysTMenu00].@cd[_ObjSysTMenuBtn00].init
}


// 初期化
$break_switch = @Off

// モード初期化
$sys_mode = $no_mode

// セーブ／ロード画面非表示
gosub #ObjErase

// システムコール解放
$excall_free



return


/********************************************************
*セーブ／ロード画面初期化                               *
*********************************************************/
#SLPageInit

	// 既読スキップＯＦＦ
	syscom.set_read_skip_onoff_flag(@Off)

	// ページ切り替え判定を初期化
	@SysSLPageChange = @Off

	// 前回開いたページを設定
	@SysSLPage = @SysSLLastPage
	@SysSLPage_prev = @SysSLPage

	@SysSLhelpDisp = @Off

	// 通常状態
	@SLDataState   = @DataNormal
	@SysSLPageCng  = @Init
	@SysSLPageCSpd = @Init

return


/********************************************************
*セーブデータ取得                                       *
*********************************************************/
#SAPageState

	// 最新のデータのページ数
	@SysSLPage_new = syscom.get_save_new_no(0, 1000) / 10

	// ページタブを取得
	    if (@SysSLPage <  20) {@SysSLPageTab = 0}
	elseif (@SysSLPage <  40) {@SysSLPageTab = 1}
	elseif (@SysSLPage <  60) {@SysSLPageTab = 2}
	elseif (@SysSLPage <  80) {@SysSLPageTab = 3}
	elseif (@SysSLPage < 100) {@SysSLPageTab = 4}

	if (@SysSLPage < 100)	{
		// 通常セーブ画面
		@SysSLPage_state = @SLPage_normal
	}
	elseif (@SysSLPage == 100)	{
		// オートセーブ画面
		@SysSLPage_state = @SLPage_auto
	}
	elseif (@SysSLPage == 101)	{
		// クイックセーブ画面
		@SysSLPage_state = @SLPage_quick
	}

	// コンフィグ画面から切り替えた場合
	if ($sys_mode_prev == $sys_cf_mode)	{
		@SysSLPageChange = @On
//		system.debug_messagebox_ok(届いた)
	}

	// コンフィグ画面から切り替えた場合
	if ($sys_mode_prev == $sys_cf_mode)	{
		@SysSLPageChange = @On
//		system.debug_messagebox_ok(届いた)
	}

return


/********************************************************
*オブジェクトの初期化                                   *
*********************************************************/
#ObjInit00

	// コンフィグ画面のオブジェクトを初期化
	@ex.f.obj[@ObjSysCF00].init
	@ex.f.obj[@ObjSysCF01].init
	@ex.f.obj[@ObjSysCF02].init
	@ex.f.obj[@ObjSysCF03].init
	@ex.f.obj[@ObjSysCF04].init
	@ex.f.obj[@ObjSysCF05].init

	// 下地
	@ex.f.obj[@ObjSysSL00].init
	@ex.f.obj[@ObjSysSL00].disp = @On
	@ex.f.obj[@ObjSysSL00].@cd.resize(20)

	// メニューボタン
	@ex.f.obj[@ObjSysSL01].init
	@ex.f.obj[@ObjSysSL01].disp = @On
	@ex.f.obj[@ObjSysSL01].layer = 10
	@ex.f.obj[@ObjSysSL01].@cd.resize(20)

	// セーブ／ロードページ
	@ex.f.obj[@ObjSysSL02].init
	@ex.f.obj[@ObjSysSL02].disp = @On
	@ex.f.obj[@ObjSysSL02].layer = 10
	@ex.f.obj[@ObjSysSL02].@cd.resize(200)

	// セーブ／ロードボタン
	@ex.f.obj[@ObjSysSL03].init
	@ex.f.obj[@ObjSysSL03].disp = @On
	@ex.f.obj[@ObjSysSL03].layer = 10
	@ex.f.obj[@ObjSysSL03].@cd.resize(200)

	// 確認メッセージ
	@ex.f.obj[@ObjSysSL04].init
	@ex.f.obj[@ObjSysSL04].disp = @On
	@ex.f.obj[@ObjSysSL04].layer = 100
	@ex.f.obj[@ObjSysSL04].@cd.resize(10)

	for ($_L[0] = 0, $_L[0] < 11, $_L[0] += 1){
		@SysSLDataDisp[+$_L[0]] = @Init
	}

	// セーブ／ロード画面表示
	if (@SysSLPageChange == @Off)	{
		@ex.f.obj[@ObjSysSL00].tr = 0
		@ex.f.obj[@ObjSysSL01].tr = 0
		@ex.f.obj[@ObjSysSL02].tr = 0
		@ex.f.obj[@ObjSysSL03].tr = 0
//		system.debug_messagebox_ok(通った)
	}

	frame

return


/********************************************************
*セーブ／ロード画面構築                                 *
*********************************************************/
#ObjConstruct

	// 現ページデータ詳細情報取得
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1){
		@SysSLPageExist[+$_L[0]] = (@SysSLPage*10) + $_L[0]
		@SysSLDataExist[+$_L[0]] = syscom.get_save_exist((@SysSLPage*10) + $_L[0])
	}

	// 下部メニューボタン----------------------------------------------------------------------------------------------------
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn07].create(sys_sm_page01,             @On,   30, 648)				// ゲームを終了
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn08].create(sys_sm_page02,             @On,  233, 648)				// タイトルに戻る
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn09].create(sys_sm_page03,             @On,  438, 648)				// セーブ
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn10].create(sys_sm_page04,             @On,  641, 648)				// ロード
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn11].create(sys_sm_page05,             @On,  844, 648)				// コンフィグ
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn12].create(sys_sm_page06,             @On, 1047, 648)				// ゲームに戻る
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfo00].create(sys_sl_page_info00,        @On,   30, 605)				// ページの説明
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum01].create(sys_sl_page_info_num00, @On,   83, 616)				// ページの説明[数値X00]
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum02].create(sys_sl_page_info_num00, @On,   94, 616)				// ページの説明[数値X00]
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum03].create(sys_sl_page_info_num00, @On,  105, 616)				// ページの説明[数値X00]

	// ページ説明状態
	gosub #SLPageInfo

	// セーブデータ----------------------------------------------------------------------------------------------------------
	if ($sys_mode == $sys_sa_mode)	{

		// 下部メニューのセーブボタン
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn09].patno = @Operate

		// 壁紙
		$sys_sl_bg0 = sys_sa_bg00

		// セーブページボタン[固定]
		$sys_sl_page_cbtn[0] = "sys_sa_page_cbtn01"		// ↑
		$sys_sl_page_cbtn[1] = "sys_sa_page_cbtn02"		// ↓
		$sys_sl_page_cbtn[2] = "sys_sa_page000"			// NEW
		$sys_sl_page_cbtn[3] = "sys_sa_page101"			// Auto
		$sys_sl_page_cbtn[4] = "sys_sa_page102"			// Quick
		$sys_sl_page_cbtn[5] = "sys_sa_helpbtn00"		// help

		// セーブページボタン[１～１００]
		if (@SysSLPage_state == @SLPage_normal)	{
			L[1] = @SysSLPageTab * 20
			for (L[0] = 0, L[0] < 20, L[0] += 1)	{
				$sys_sl_page[L[0]]  = "sys_sa_page" + math.tostr_zero(L[0]+L[1]+1, 3)		// ※注意
			}
		}
		// オートセーブ／クイックセーブ
		else	{
			L[1] = @SysSLPageTab_Prev * 20
			for (L[0] = 0, L[0] < 20, L[0] += 1)	{
				$sys_sl_page[L[0]]  = "sys_sa_page" + math.tostr_zero(L[0]+L[1]+1, 3)		// ※注意
			}
		}

		$sys_sl_data0    = "sys_sa_data01"				// セーブボタン下地
		$sys_sl_com0     = "sys_sa_data02"				// コメント下地
		$sys_sl_lock0    = "sys_sa_lockbtn00"			// ロックボタン
		$sys_sl_change0  = "sys_sa_sbtn01"				// 入れ替えボタン
		$sys_sl_mark[0]  = "sys_sa_mark01"				// New／Nextマーク
		$sys_sl_mark[1]  = "sys_sa_mark02"				// 巻数マーク
		$sys_sl_del0     = "sys_sa_sbtn02"				// 削除ボタン
		$sys_sl_num0     = "sys_sa_num00"				// セーブ番号

	}
	// ロードデータ----------------------------------------------------------------------------------------------------------
	else	{

		// 下部メニューのロードボタン
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn10].patno = @Operate

		// 壁紙
		$sys_sl_bg0 = sys_lo_bg00

		// ロードページボタン[固定]
		$sys_sl_page_cbtn[0] = "sys_lo_page_cbtn01"		// ↑
		$sys_sl_page_cbtn[1] = "sys_lo_page_cbtn02"		// ↓
		$sys_sl_page_cbtn[2] = "sys_lo_page000"			// NEW
		$sys_sl_page_cbtn[3] = "sys_lo_page101"			// Auto
		$sys_sl_page_cbtn[4] = "sys_lo_page102"			// Quick
		$sys_sl_page_cbtn[5] = "sys_lo_helpbtn00"		// help

		// 通常ロードページボタン[１～１００]
		if (@SysSLPage_state == @SLPage_normal)	{
			L[1] = @SysSLPageTab * 20
			for (L[0] = 0, L[0] < 20, L[0] += 1)	{
				$sys_sl_page[L[0]]  = "sys_lo_page" + math.tostr_zero(L[0]+L[1]+1, 3)		// ※注意
			}
		}
		// オートセーブ／クイックセーブ
		else	{
			L[1] = @SysSLPageTab_Prev * 20
			for (L[0] = 0, L[0] < 20, L[0] += 1)	{
				$sys_sl_page[L[0]]  = "sys_lo_page" + math.tostr_zero(L[0]+L[1]+1, 3)		// ※注意
			}
		}

		$sys_sl_data0    = "sys_lo_data01"				// セーブボタン下地
		$sys_sl_com0     = "sys_lo_data02"				// コメント下地
		$sys_sl_lock0    = "sys_lo_lockbtn00"			// ロックボタン
		$sys_sl_change0  = "sys_lo_sbtn01"				// 入れ替えボタン
		$sys_sl_mark[0]  = "sys_lo_mark01"				// New／Nextマーク
		$sys_sl_mark[1]  = "sys_lo_mark02"				// 巻数マーク
		$sys_sl_del0     = "sys_lo_sbtn02"				// 削除ボタン
		$sys_sl_num0     = "sys_lo_num00"				// セーブ番号
	}

	// 壁紙
	@ex.f.obj[@ObjSysSL00].@cd[_ObjSysSLBg00].create($sys_sl_bg0, @On, 0, 0)

	// セーブ／ロードページ
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn01].create($sys_sl_page_cbtn[0], @On,  297,  27)				// ↑
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn02].create($sys_sl_page_cbtn[1], @On,  334,  27)				// ↓
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn03].create($sys_sl_page_cbtn[2], @On,  371,  27)				// NEW
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn04].create($sys_sl_page_cbtn[3], @On, 1176,  27)				// Auto
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn05].create($sys_sl_page_cbtn[4], @On, 1213,  27)				// Quick
	@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn06].create($sys_sl_page_cbtn[5], @On, 1217, 605)				// Help
	// 現在のページ設定
	    if (@SysSLPage_state == @SLPage_auto)  {@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn04].patno = @Operate}
	elseif (@SysSLPage_state == @SLPage_quick) {@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn05].patno = @Operate}

	// ページボタン
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage001].create($sys_sl_page[0],  @On,  436, 27)					// ページ001 / 021 / 041 / 061 / 081
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage002].create($sys_sl_page[1],  @On,  473, 27)					// ページ002 / 022 / 042 / 062 / 082
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage003].create($sys_sl_page[2],  @On,  510, 27)					// ページ003 / 023 / 043 / 063 / 083
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage004].create($sys_sl_page[3],  @On,  547, 27)					// ページ004 / 024 / 044 / 064 / 084
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage005].create($sys_sl_page[4],  @On,  584, 27)					// ページ005 / 025 / 045 / 065 / 085
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage006].create($sys_sl_page[5],  @On,  621, 27)					// ページ006 / 026 / 046 / 066 / 086
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage007].create($sys_sl_page[6],  @On,  658, 27)					// ページ007 / 027 / 047 / 067 / 087
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage008].create($sys_sl_page[7],  @On,  695, 27)					// ページ008 / 028 / 048 / 068 / 088
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage009].create($sys_sl_page[8],  @On,  732, 27)					// ページ009 / 029 / 049 / 069 / 089
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage010].create($sys_sl_page[9],  @On,  769, 27)					// ページ010 / 030 / 050 / 070 / 090
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage011].create($sys_sl_page[10], @On,  806, 27)					// ページ011 / 031 / 051 / 071 / 091
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage012].create($sys_sl_page[11], @On,  843, 27)					// ページ012 / 032 / 052 / 072 / 092
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage013].create($sys_sl_page[12], @On,  880, 27)					// ページ013 / 033 / 053 / 073 / 093
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage014].create($sys_sl_page[13], @On,  917, 27)					// ページ014 / 034 / 054 / 074 / 094
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage015].create($sys_sl_page[14], @On,  954, 27)					// ページ015 / 035 / 055 / 075 / 095
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage016].create($sys_sl_page[15], @On,  991, 27)					// ページ016 / 036 / 056 / 076 / 096
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage017].create($sys_sl_page[16], @On, 1028, 27)					// ページ017 / 037 / 057 / 077 / 097
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage018].create($sys_sl_page[17], @On, 1065, 27)					// ページ018 / 038 / 058 / 078 / 098
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage019].create($sys_sl_page[18], @On, 1102, 27)					// ページ019 / 039 / 059 / 079 / 099
	@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage020].create($sys_sl_page[19], @On, 1139, 27)					// ページ020 / 040 / 060 / 080 / 100
	// 現在のページの判定
	if (@SysSLPage_state == @SLPage_normal)	{
		    if (@SysSLPage < 20) {$_L[0] =  0}
		elseif (@SysSLPage < 40) {$_L[0] = 20}
		elseif (@SysSLPage < 60) {$_L[0] = 40}
		elseif (@SysSLPage < 80) {$_L[0] = 60}
		else                     {$_L[0] = 80}
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage001+(@SysSLPage - $_L[0])].patno = @Operate
	}

	// セーブ／ロードボタン下地
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg01].create($sys_sl_data0, @On,   30,  65)						// ボタン01
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg02].create($sys_sl_data0, @On,  276,  65)						// ボタン02
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg03].create($sys_sl_data0, @On,  522,  65)						// ボタン03
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg04].create($sys_sl_data0, @On,  768,  65)						// ボタン04
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg05].create($sys_sl_data0, @On, 1014,  65)						// ボタン05
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg06].create($sys_sl_data0, @On,   30, 335)						// ボタン06
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg07].create($sys_sl_data0, @On,  276, 335)						// ボタン07
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg08].create($sys_sl_data0, @On,  522, 335)						// ボタン08
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg09].create($sys_sl_data0, @On,  768, 335)						// ボタン09
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg10].create($sys_sl_data0, @On, 1014, 335)						// ボタン10

	// コメント下地
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg01].create($sys_sl_com0, @On,   42, 277)						// コメント01
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg02].create($sys_sl_com0, @On,  288, 277)						// コメント02
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg03].create($sys_sl_com0, @On,  534, 277)						// コメント03
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg04].create($sys_sl_com0, @On,  780, 277)						// コメント04
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg05].create($sys_sl_com0, @On, 1026, 277)						// コメント05
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg06].create($sys_sl_com0, @On,   42, 548)						// コメント06
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg07].create($sys_sl_com0, @On,  288, 548)						// コメント07
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg08].create($sys_sl_com0, @On,  534, 548)						// コメント08
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg09].create($sys_sl_com0, @On,  780, 548)						// コメント09
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg10].create($sys_sl_com0, @On, 1026, 548)						// コメント10

	// データが存在しているか判定
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		@GetSaveDate($_L[0], $_L[0]+(@SysSLPage*10))
		if (@SLDateChk00[+$_L[0]] == @On)	{
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg01+$_L[0]].patno = 4
		}
	}
	// データをロックしているか判定
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		if (@SysSLDataLock[+$_L[0]+(@SysSLPage*10)] == @On)	{
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg01+$_L[0]].patno = 8
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg01+$_L[0]].patno = 4
		}
	}

	// ロックボタン
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn01].create($sys_sl_lock0, @On,   33, 300)					// ロック01
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn02].create($sys_sl_lock0, @On,  279, 300)					// ロック02
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn03].create($sys_sl_lock0, @On,  525, 300)					// ロック03
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn04].create($sys_sl_lock0, @On,  771, 300)					// ロック04
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn05].create($sys_sl_lock0, @On, 1017, 300)					// ロック05
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn06].create($sys_sl_lock0, @On,   33, 570)					// ロック06
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn07].create($sys_sl_lock0, @On,  279, 570)					// ロック07
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn08].create($sys_sl_lock0, @On,  525, 570)					// ロック08
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn09].create($sys_sl_lock0, @On,  771, 570)					// ロック09
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn10].create($sys_sl_lock0, @On, 1017, 570)					// ロック10
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		if (@SysSLPage >= 100)	{
			// オートセーブ／クイックセーブはロック不可
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn01+$_L[0]].init
		}
		elseif (@SysSLDataLock[+$_L[0]+(@SysSLPage*10)] == @On)	{
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn01+$_L[0]].patno = @Operate
		}
	}

	// 入れ替えボタン
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn01].create($sys_sl_change0, @On,  112, 300)					// 入れ替え01
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn02].create($sys_sl_change0, @On,  358, 300)					// 入れ替え02
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn03].create($sys_sl_change0, @On,  604, 300)					// 入れ替え03
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn04].create($sys_sl_change0, @On,  850, 300)					// 入れ替え04
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn05].create($sys_sl_change0, @On, 1096, 300)					// 入れ替え05
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn06].create($sys_sl_change0, @On,  112, 570)					// 入れ替え06
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn07].create($sys_sl_change0, @On,  358, 570)					// 入れ替え07
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn08].create($sys_sl_change0, @On,  604, 570)					// 入れ替え08
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn09].create($sys_sl_change0, @On,  850, 570)					// 入れ替え09
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn10].create($sys_sl_change0, @On, 1096, 570)					// 入れ替え10
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		if (@SysSLPage >= 100)	{
//			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn01+$_L[0]].init
		}
	}

	// セーブタイトル／リアル時間読み込み
	@GetSaveDate(0, 0+(@SysSLPage*10)) @RenewalRTime(0, 0+(@SysSLPage*10))
	@GetSaveDate(1, 1+(@SysSLPage*10)) @RenewalRTime(1, 1+(@SysSLPage*10))
	@GetSaveDate(2, 2+(@SysSLPage*10)) @RenewalRTime(2, 2+(@SysSLPage*10))
	@GetSaveDate(3, 3+(@SysSLPage*10)) @RenewalRTime(3, 3+(@SysSLPage*10))
	@GetSaveDate(4, 4+(@SysSLPage*10)) @RenewalRTime(4, 4+(@SysSLPage*10))
	@GetSaveDate(5, 5+(@SysSLPage*10)) @RenewalRTime(5, 5+(@SysSLPage*10))
	@GetSaveDate(6, 6+(@SysSLPage*10)) @RenewalRTime(6, 6+(@SysSLPage*10))
	@GetSaveDate(7, 7+(@SysSLPage*10)) @RenewalRTime(7, 7+(@SysSLPage*10))
	@GetSaveDate(8, 8+(@SysSLPage*10)) @RenewalRTime(8, 8+(@SysSLPage*10))
	@GetSaveDate(9, 9+(@SysSLPage*10)) @RenewalRTime(9, 9+(@SysSLPage*10))

	// リアル時間
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		// 存在しない場合は表示しない
		if (@SLDateChk00[+$_L[0]] == @OFF) {
			@RTimeDateA00[+$_L[0]] = ""
		}
	}
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime01].create_string(@RTimeDateA01, @On,   84,  70)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime02].create_string(@RTimeDateA02, @On,  330,  70)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime03].create_string(@RTimeDateA03, @On,  576,  70)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime04].create_string(@RTimeDateA04, @On,  822,  70)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime05].create_string(@RTimeDateA05, @On, 1068,  70)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime06].create_string(@RTimeDateA06, @On,   84, 340)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime07].create_string(@RTimeDateA07, @On,  330, 340)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime08].create_string(@RTimeDateA08, @On,  576, 340)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime09].create_string(@RTimeDateA09, @On,  822, 340)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime10].create_string(@RTimeDateA10, @On, 1068, 340)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime01].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime02].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime03].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime04].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime05].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime06].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime07].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime08].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime09].set_string_param(15, 0, 0, 0, 0, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime10].set_string_param(15, 0, 0, 0, 0, 1, 0)

	// セーブサムネイル
	if (@SLDateChk00[+0] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb01].create_save_thumb(0+(@SysSLPage*10), @On,   30,  91)}
	if (@SLDateChk00[+1] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb02].create_save_thumb(1+(@SysSLPage*10), @On,  276,  91)}
	if (@SLDateChk00[+2] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb03].create_save_thumb(2+(@SysSLPage*10), @On,  522,  91)}
	if (@SLDateChk00[+3] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb04].create_save_thumb(3+(@SysSLPage*10), @On,  768,  91)}
	if (@SLDateChk00[+4] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb05].create_save_thumb(4+(@SysSLPage*10), @On, 1014,  91)}
	if (@SLDateChk00[+5] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb06].create_save_thumb(5+(@SysSLPage*10), @On,   30, 361)}
	if (@SLDateChk00[+6] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb07].create_save_thumb(6+(@SysSLPage*10), @On,  276, 361)}
	if (@SLDateChk00[+7] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb08].create_save_thumb(7+(@SysSLPage*10), @On,  522, 361)}
	if (@SLDateChk00[+8] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb09].create_save_thumb(8+(@SysSLPage*10), @On,  768, 361)}
	if (@SLDateChk00[+9] == @On){@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb10].create_save_thumb(9+(@SysSLPage*10), @On, 1014, 361)}

	// セーブタイトル
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		// 存在しない場合は表示しない
		if (@SLDateChk00[+$_L[0]] == @OFF) {
			@SLSTitleA00[+$_L[0]] = ""
		}
	}
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle01].create_string(@SLSTitleA01, @On,   43, 232)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle02].create_string(@SLSTitleA02, @On,  289, 232)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle03].create_string(@SLSTitleA03, @On,  535, 232)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle04].create_string(@SLSTitleA04, @On,  781, 232)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle05].create_string(@SLSTitleA05, @On, 1027, 232)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle06].create_string(@SLSTitleA06, @On,   43, 502)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle07].create_string(@SLSTitleA07, @On,  289, 502)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle08].create_string(@SLSTitleA08, @On,  535, 502)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle09].create_string(@SLSTitleA09, @On,  781, 502)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle10].create_string(@SLSTitleA10, @On, 1027, 502)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle01].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle02].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle03].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle04].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle05].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle06].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle07].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle08].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle09].set_string_param(16, 0, 0, 0, 100, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle10].set_string_param(16, 0, 0, 0, 100, 1, 0)

	// セーブテキスト
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		// 存在しない場合は表示しない
		if (@SLDateChk00[+$_L[0]] == @OFF) {
			@SLGameTextData00[+$_L[0]] = ""
		}
	}
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText01].create_string(@SLGameTextData01, @On,   43, 259)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText02].create_string(@SLGameTextData02, @On,  289, 259)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText03].create_string(@SLGameTextData03, @On,  535, 259)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText04].create_string(@SLGameTextData04, @On,  781, 259)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText05].create_string(@SLGameTextData05, @On, 1027, 259)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText06].create_string(@SLGameTextData06, @On,   43, 529)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText07].create_string(@SLGameTextData07, @On,  289, 529)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText08].create_string(@SLGameTextData08, @On,  535, 529)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText09].create_string(@SLGameTextData09, @On,  781, 529)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText10].create_string(@SLGameTextData10, @On, 1027, 529)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText01].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText02].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText03].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText04].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText05].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText06].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText07].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText08].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText09].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText10].set_string_param(12, 0, 0, 0, 101, 1, 0)

	// セーブコメント読み込み
	@GetSLComData(0+(@SysSLPage*10), @SLComDataS01)
	@GetSLComData(1+(@SysSLPage*10), @SLComDataS02)
	@GetSLComData(2+(@SysSLPage*10), @SLComDataS03)
	@GetSLComData(3+(@SysSLPage*10), @SLComDataS04)
	@GetSLComData(4+(@SysSLPage*10), @SLComDataS05)
	@GetSLComData(5+(@SysSLPage*10), @SLComDataS06)
	@GetSLComData(6+(@SysSLPage*10), @SLComDataS07)
	@GetSLComData(7+(@SysSLPage*10), @SLComDataS08)
	@GetSLComData(8+(@SysSLPage*10), @SLComDataS09)
	@GetSLComData(9+(@SysSLPage*10), @SLComDataS10)
	// コメントが無い場合は、指定のコメントを挿入
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		// 存在しない場合は表示しない
		if (@SLComDataS00[+$_L[0]] == "") {
			@SLComDataS00[+$_L[0]] = " クリックでコメントを入力できます"
		}
	}
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText01].create_string(@SLComDataS01.left_len(34), @On,   48, 281)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText02].create_string(@SLComDataS02.left_len(34), @On,  294, 281)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText03].create_string(@SLComDataS03.left_len(34), @On,  540, 281)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText04].create_string(@SLComDataS04.left_len(34), @On,  786, 281)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText05].create_string(@SLComDataS05.left_len(34), @On, 1032, 281)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText06].create_string(@SLComDataS06.left_len(34), @On,   48, 552)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText07].create_string(@SLComDataS07.left_len(34), @On,  294, 552)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText08].create_string(@SLComDataS08.left_len(34), @On,  540, 552)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText09].create_string(@SLComDataS09.left_len(34), @On,  786, 552)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText10].create_string(@SLComDataS10.left_len(34), @On, 1032, 552)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText01].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText02].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText03].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText04].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText05].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText06].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText07].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText08].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText09].set_string_param(12, 0, 0, 0, 101, 1, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText10].set_string_param(12, 0, 0, 0, 101, 1, 0)

	// 巻数表示	todo 後で処理
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		if (@SLDateChk00[+$_L[0]] == @On) {
			switch (syscom.get_save_append_dir($_L[0]+(@SysSLPage*10)))	{
				case ("1st_beat") L[20+$_L[0]] = 0 //@debug("1st")
				case ("2nd_beat") L[20+$_L[0]] = 1 //@debug("2nd")
				case ("3rd_beat") L[20+$_L[0]] = 2 //@debug("3rd")
				case ("4th_beat") L[20+$_L[0]] = 3 //@debug("4th")
				case ("5th_beat") L[20+$_L[0]] = 4 //@debug("5th")
				case ("6th_beat") L[20+$_L[0]] = 5 //@debug("6th")
				default           L[20+$_L[0]] = 0
			}
		}
	}
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark01].create($sys_sl_mark[1], @SLDateChk01,  206, 305)		// 巻数表示01
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark02].create($sys_sl_mark[1], @SLDateChk02,  452, 305)		// 巻数表示02
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark03].create($sys_sl_mark[1], @SLDateChk03,  698, 305)		// 巻数表示03
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark04].create($sys_sl_mark[1], @SLDateChk04,  944, 305)		// 巻数表示04
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark05].create($sys_sl_mark[1], @SLDateChk05, 1190, 305)		// 巻数表示05
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark06].create($sys_sl_mark[1], @SLDateChk06,  206, 575)		// 巻数表示06
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark07].create($sys_sl_mark[1], @SLDateChk07,  452, 575)		// 巻数表示07
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark08].create($sys_sl_mark[1], @SLDateChk08,  698, 575)		// 巻数表示08
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark09].create($sys_sl_mark[1], @SLDateChk09,  944, 575)		// 巻数表示09
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark10].create($sys_sl_mark[1], @SLDateChk10, 1190, 575)		// 巻数表示10
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark01].patno = L[20]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark02].patno = L[21]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark03].patno = L[22]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark04].patno = L[23]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark05].patno = L[24]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark06].patno = L[25]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark07].patno = L[26]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark08].patno = L[27]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark09].patno = L[28]
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark10].patno = L[29]

	// 削除ボタン
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn01].create($sys_sl_del0, @On,  242,  66)					// 削除01
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn02].create($sys_sl_del0, @On,  488,  66)					// 削除02
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn03].create($sys_sl_del0, @On,  734,  66)					// 削除03
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn04].create($sys_sl_del0, @On,  980,  66)					// 削除04
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn05].create($sys_sl_del0, @On, 1226,  66)					// 削除05
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn06].create($sys_sl_del0, @On,  242, 336)					// 削除06
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn07].create($sys_sl_del0, @On,  488, 336)					// 削除07
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn08].create($sys_sl_del0, @On,  734, 336)					// 削除08
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn09].create($sys_sl_del0, @On,  980, 336)					// 削除09
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn10].create($sys_sl_del0, @On, 1226, 336)					// 削除10


	// セーブ番号
	for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
		// 上段座標修正
		if ($_L[0] < 5)	{
			$_L[1] = $_L[0]
			$_L[2] = 0
		}
		// 下段座標修正
		else	{
			$_L[1] = $_L[0] - 5
			$_L[2] = 270
		}
		// 通常セーブ
		if (@SysSLPage_state == @SLPage_normal)	{
			// セーブ番号ＡＸＸ
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01A+$_L[0]].create($sys_sl_num0, @On, 36 + (246 * $_L[1]), 71 + $_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01A+$_L[0]].patno = @SysSLPage / 10
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01A+$_L[0]].layer = 1
			// セーブ番号ＸＢＸ
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01B+$_L[0]].create($sys_sl_num0, @On, 48 + (246 * $_L[1]), 71 + $_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01B+$_L[0]].patno = @SysSLPage % 10
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01B+$_L[0]].layer = 1
			// セーブ番号ＸＸＣ
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01C+$_L[0]].create($sys_sl_num0, @On, 60 + (246 * $_L[1]), 71 + $_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01C+$_L[0]].patno = $_L[0]
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01C+$_L[0]].layer = 1
		}
		// オートセーブ／クイックセーブ
		else	{
			// セーブ番号ＡＸＸ
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01A+$_L[0]].create($sys_sl_num0, @On, 36 + (246 * $_L[1]), 71 + $_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01A+$_L[0]].patno = 0
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01A+$_L[0]].layer = 1
			// セーブ番号ＸＢＸ
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01B+$_L[0]].create($sys_sl_num0, @On, 48 + (246 * $_L[1]), 71 + $_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01B+$_L[0]].patno = 0
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01B+$_L[0]].layer = 1
			// セーブ番号ＸＸＣ
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01C+$_L[0]].create($sys_sl_num0, @On, 60 + (246 * $_L[1]), 71 + $_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01C+$_L[0]].patno = $_L[0]
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLNnm01C+$_L[0]].layer = 1
		}
	}


	// Newマーク
	gosub #GetDataInfo

	// Nextマーク
//	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark12].create($sys_sl_mark[0], @On, 0, 0)

	// ヘルプ画面
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLHelp00].create(sys_sl_page_info_bg00, @Off, 0, 0)
	@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLHelp00].layer = 5000

	//入れ替え元マーク表示
	gosub #DataChangeMark


return


/********************************************************
*ページ説明状態                                         *
*********************************************************/
#SLPageInfo

	// データ入れ替え中
	if (@SLDataState == @DataChange)	{
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum01].disp = @Off
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum02].disp = @Off
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum03].disp = @Off
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfo00].patno = 3
	}
	else	{
		// 通常セーブ画面
		if (@SysSLPage_state == @SLPage_normal)	{
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfo00].patno = 0
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum01].disp = @On
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum02].disp = @On
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum03].disp = @On
			$_L[0] = @SysSLPage + 1
			// 001～009
			if ($_L[0] < 10)	{
				@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum03].patno = $_L[0]
			}
			// 010～099
			elseif ($_L[0] < 100)	{
				$_K[0] = math.tostr($_L[0])
				$_K[1] = $_K[0].left(1)
				$_K[2] = $_K[0].right(1)
				@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum02].patno = $_K[1].tonum
				@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum03].patno = $_K[2].tonum
			}
			// 100
			else	{
				@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum01].patno = 1
			}
		}
		// オートセーブ／クイックセーブ
		else	{
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum01].disp = @Off
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum02].disp = @Off
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfoNum03].disp = @Off
			// オートセーブ
			if (@SysSLPage_state == @SLPage_auto)	{
				@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfo00].patno = 1
			}
			// クイックセーブ
			else	{
				@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLInfo00].patno = 2
			}
		}
	}

return


/********************************************************
*セーブ／ロード画面表示                                 *
*********************************************************/
#ObjDisp

	// セーブ／ロード画面を開いた場合
	if (@SysSLPageChange == @Off)	{
		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 下地
		@ex.f.obj[@ObjSysSL00].tr_eve.set(255, L[20], 0, 0)
		// メニューボタン
		@ex.f.obj[@ObjSysSL01].tr_eve.set(255, L[20], 0, 0)
		// セーブ／ロードページ
		@ex.f.obj[@ObjSysSL02].tr_eve.set(255, L[20], 0, 0)
		// セーブ／ロードボタン
		@ex.f.obj[@ObjSysSL03].tr_eve.set(255, L[20], 0, 0)

		@ex.f.obj[@ObjSysSL00].tr_eve.wait
	}

	// ページ切り替え判定を初期化
	@SysSLPageChange = @Off

return



/********************************************************
*セーブ／ロード画面非表示                               *
*********************************************************/
#ObjErase

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 下地
	@ex.f.obj[@ObjSysSL00].tr_eve.set(0, L[20], 0, 0)
	// メニューボタン
	@ex.f.obj[@ObjSysSL01].tr_eve.set(0, L[20], 0, 0)
	// セーブ／ロードページ
	@ex.f.obj[@ObjSysSL02].tr_eve.set(0, L[20], 0, 0)
	// セーブ／ロードボタン
	@ex.f.obj[@ObjSysSL03].tr_eve.set(0, L[20], 0, 0)
	// 確認メッセージ
	@ex.f.obj[@ObjSysSL04].tr_eve.set(0, L[20], 0, 0)

	@ex.f.obj[@ObjSysSL00].tr_eve.wait

return


/********************************************************
*ＮＥＷデータ情報取得／設定                             *
*********************************************************/
#GetDataInfo

	//
	// 現ページデータ詳細情報取得
	//

	// 通常セーブ／オートセーブ画面
	if (@SysSLPage < 100 || @SysSLPage == 100)	{
		for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1){
			@SysSLPageExist[+$_L[0]] = (@SysSLPage*10) + $_L[0]
			@SysSLDataExist[+$_L[0]] = syscom.get_save_exist((@SysSLPage*10) + $_L[0])
			// ＮＥＷ
			if (@SysSLPage < 100 && @SysSLPageExist[+$_L[0]] == syscom.get_save_new_no(0, 1000))	{
				// todo 後で書き直すかも
				switch ($_L[0])	{
					case (0) $_L[10] = 246*0 $_L[11] =   0
					case (1) $_L[10] = 246*1 $_L[11] =   0
					case (2) $_L[10] = 246*2 $_L[11] =   0
					case (3) $_L[10] = 246*3 $_L[11] =   0
					case (4) $_L[10] = 246*4 $_L[11] =   0
					case (5) $_L[10] = 246*0 $_L[11] = 270
					case (6) $_L[10] = 246*1 $_L[11] = 270
					case (7) $_L[10] = 246*2 $_L[11] = 270
					case (8) $_L[10] = 246*3 $_L[11] = 270
					case (9) $_L[10] = 246*4 $_L[11] = 270
				}
				@SysSLPage_new = syscom.get_save_new_no(0, 1000) / 10
				@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark11].create($sys_sl_mark[0], @On, 35+$_L[10], 95+$_L[11])
				@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark11].layer = 1000
			}
			elseif (@SysSLPage == 100) {
				// todo 後で書き直すかも
				if (syscom.get_save_new_no(1000, 10) != -1)	{
					$_L[20] = syscom.get_save_new_no(1000, 10) - 1000
					switch ($_L[20])	{
						case (0) $_L[10] = 246*0 $_L[11] =   0
						case (1) $_L[10] = 246*1 $_L[11] =   0
						case (2) $_L[10] = 246*2 $_L[11] =   0
						case (3) $_L[10] = 246*3 $_L[11] =   0
						case (4) $_L[10] = 246*4 $_L[11] =   0
						case (5) $_L[10] = 246*0 $_L[11] = 270
						case (6) $_L[10] = 246*1 $_L[11] = 270
						case (7) $_L[10] = 246*2 $_L[11] = 270
						case (8) $_L[10] = 246*3 $_L[11] = 270
						case (9) $_L[10] = 246*4 $_L[11] = 270
					}
					@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark11].create($sys_sl_mark[0], @On, 35+$_L[10], 95+$_L[11])
					@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark11].layer = 1000
				}
			}
		}
	}
	// クイックセーブ画面
	else	{
		if (syscom.get_quick_save_new_no != -1)	{
			switch (syscom.get_quick_save_new_no)	{
				case (0) $_L[10] = 246*0 $_L[11] =   0
				case (1) $_L[10] = 246*1 $_L[11] =   0
				case (2) $_L[10] = 246*2 $_L[11] =   0
				case (3) $_L[10] = 246*3 $_L[11] =   0
				case (4) $_L[10] = 246*4 $_L[11] =   0
				case (5) $_L[10] = 246*0 $_L[11] = 270
				case (6) $_L[10] = 246*1 $_L[11] = 270
				case (7) $_L[10] = 246*2 $_L[11] = 270
				case (8) $_L[10] = 246*3 $_L[11] = 270
				case (9) $_L[10] = 246*4 $_L[11] = 270
			}
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark11].create($sys_sl_mark[0], @On, 35+$_L[10], 95+$_L[11])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark11].layer = 1000
		}
	}


return


/********************************************************
*セーブ実行                                             *
*********************************************************/
#DataSavePut

	// todo 修正
	$_L[20] = $_L[10]

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 確認ダイアログ
	if ((@CdState[+0] == @On) || ((@CdState[+2] == @On) && (@SysSLDataExist[+@SysSLDate00] != @Off)))	{

		// システム音
		@se_play(001)

		// セーブ確認下地
		@ex.f.obj[@ObjSysSL04].tr = 0
		@ex.f.obj[@ObjSysSL04].layer = 1000
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].create(sys_sa_setbtn_bg00, @On,    0, 295)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].create(sys_sa_chk00,      @On, 1095, 343)
		// セーブ／上書き
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].patno = $_L[20]


		// 表示
		@ex.f.obj[@ObjSysSL04].tr_eve.set(255, L[20], 0, 2)

		@CdStateReady = @Off

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

			//
			// マウスカーソル判定
			//

			@exif_(@Off, @Off, 0, @ObjSysSL04, _ObjSysSLConfBtn01)
			@exif_(@Off, @Off, 1, @ObjSysSL04, _ObjSysSLConfBtn02)
			@exif_(@Off, @Off, 2, @ObjSysSL04, _ObjSysSLConfChk00)

			// マウスボタン入力判定
			$MsBtnInputDecide
			if ($break_switch == @On)	{
				@se_play(002)
				$break_switch = @Off
				@MSCHK = 1
				break
			}

			// 状態セット
			@MsStateSet(0, 3)

			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].patno = $obj_btn_state[0]	// ＹＥＳ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].patno = $obj_btn_state[1]	// ＮＯ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno = $obj_btn_state[2]	// 確認ダイアログチェック
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno += @MSBTN_CHK
			}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 0)	{
					// ＹＥＳ
					break
				}
				elseif (@MSCHK == 1)	{
					// ＮＯ
					@se_play(002)
					break
				}
				elseif (@MSCHK == 2)	{
					@se_play(001)
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}

		}
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 0
	}

	// セーブ実行
	if (@MSCHK == 0 && $break_switch == @Off)	{

		// 確認ダイアログ消去
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].tr = 0
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].tr = 0
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].tr = 0
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].tr = 0

		@se_play(001)

		// セーブ
		L[0] = syscom.save(@SysSLDate00 + (@SysSLPage*10), @Off, @Off)

		// セーブ中
		gosub(0) #DataStateInfo

		// デバック
//		L[10] = syscom.get_save_year(@SysSLDate00 + (@SysSLPage*10))
//		system.debug_messagebox_ok(L[10])

		// セーブ可能な場合
		if (L[0] == @On)	{

			// todo 後で書き直すかも
			switch (@SysSLDate00)	{
				case (0) $_L[0] = 246*0 $_L[1] =   0
				case (1) $_L[0] = 246*1 $_L[1] =   0
				case (2) $_L[0] = 246*2 $_L[1] =   0
				case (3) $_L[0] = 246*3 $_L[1] =   0
				case (4) $_L[0] = 246*4 $_L[1] =   0
				case (5) $_L[0] = 246*0 $_L[1] = 270
				case (6) $_L[0] = 246*1 $_L[1] = 270
				case (7) $_L[0] = 246*2 $_L[1] = 270
				case (8) $_L[0] = 246*3 $_L[1] = 270
				case (9) $_L[0] = 246*4 $_L[1] = 270
			}

			@StateData01 = @SysSLDate00 + (@SysSLPage * 10)

			@GetSaveDate(@SysSLDate00, @SysSLDate00+(@SysSLPage*10))

			// リアル時間
			@RenewalRTime(@SysSLDate00, @SysSLDate00+(@SysSLPage*10))
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime01+@SysSLDate00].create_string(@RTimeDateA00[+@SysSLDate00], @On, 84+$_L[0], 70+$_L[1])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLRtime01+@SysSLDate00].set_string_param(15, 0, 0, 0, 0, 1, 0)

			// セーブタイトル
			@GetSaveDate(@SysSLDate00, @SysSLDate00+(@SysSLPage*10))
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle01+@SysSLDate00].create_string(@SLSTitleA00[+@SysSLDate00], @On, 43+$_L[0], 232+$_L[1])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLTitle01+@SysSLDate00].set_string_param(16, 0, 0, 0, 100, 1, 0)

			// ゲームテキスト
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText01+@SysSLDate00].create_string(@SLGameTextData00[+@SysSLDate00], @On, 43+$_L[0], 259+$_L[1])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLGameText01+@SysSLDate00].set_string_param(12, 0, 0, 0, 101, 1, 0)

			// サムネイル
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLThumb01+@SysSLDate00].create_save_thumb(@SysSLDate00+(@SysSLPage*10), @On, 30+$_L[0], 91+$_L[1])

			// 巻数表示
			switch (syscom.get_save_append_dir(@SysSLDate00+(@SysSLPage*10)))	{
				case ("1st_beat") L[29] = 0 //@debug("1st")
				case ("2nd_beat") L[29] = 1 //@debug("2nd")
				case ("3rd_beat") L[29] = 2 //@debug("3rd")
				case ("4th_beat") L[29] = 3 //@debug("4th")
				case ("5th_beat") L[29] = 4 //@debug("5th")
				case ("6th_beat") L[29] = 5 //@debug("6th")
				default           L[29] = 0
			}
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark01+@SysSLDate00].create($sys_sl_mark[1], @On, 206+$_L[0], 305+$_L[1])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark01+@SysSLDate00].patno = L[29]

			// コメント削除
			@SLComDataS00[+@SysSLDate00] = ""
			@SLComData00[+@SysSLDate00]  = ""
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText01+@SysSLDate00].create_string(@SLComDataS00[+@SysSLDate00], @On, 355, 118 + (55 * @SysSLDate00))
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText01+@SysSLDate00].set_string_param(15, 0, 0, 0, 204, 1, 0)
			syscom.set_save_comment(@StateData01, @SLComData00[+@SysSLDate00])

			// ＮＥＷデータ情報取得／設定
			gosub #GetDataInfo

			// セーブしました
			gosub(1) #DataStateInfo

//			@timewaitkey(L[20])

		}
		// セーブ不可能な場合
		else	{
			// todo 修正
			system.debug_messagebox_ok("セーブできてないよ")
		}
	}
	// セーブキャンセル
	else	{
		// 確認ダイアログ消去
		@ex.f.obj[@ObjSysSL04].tr_eve.set(0, L[20], 0, 2)
		@timewaitkey(L[20])
	}

	// 確認ダイアログの設定
	switch ($_L[20])	{
		case (0) $_L[11] = 0	// セーブ／ロード
		case (1) $_L[11] = 2	// 上書き確認
	}
	if (@CdStateReady == @On ) {@CdState[+$_L[11]] = @Off}

	$break_switch = @Off

return


/********************************************************
*ロード実行                                             *
*********************************************************/
#DataLoadPut

	// 確認ダイアログ
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 確認ダイアログ
	if (@CdState[+0] == @On)	{

		// システム音
		@se_play(001)

		// セーブ確認下地
		@ex.f.obj[@ObjSysSL04].tr = 0
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].create(sys_lo_setbtn_bg00, @On,    0, 295)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].create(sys_lo_setbtn01,   @On,  659, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].create(sys_lo_setbtn02,   @On,  854, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].create(sys_lo_chk00,      @On, 1095, 343)
		// セーブ／上書き
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].patno = $_L[10]

		// todo 修正
		$_L[20] = $_L[10]

		// 表示
		@ex.f.obj[@ObjSysSL04].tr_eve.set(255, L[20], 0, 2)

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

			@exif_(@Off, @Off, 0, @ObjSysSL04, _ObjSysSLConfBtn01)
			@exif_(@Off, @Off, 1, @ObjSysSL04, _ObjSysSLConfBtn02)
			@exif_(@Off, @Off, 2, @ObjSysSL04, _ObjSysSLConfChk00)

			// マウスボタン入力判定
			$MsBtnInputDecide
			if ($break_switch == @On)	{
				@se_play(002)
				$break_switch = @Off
				@MSCHK = 1
				break
			}

			// 状態セット
			@MsStateSet(0, 3)

			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].patno = $obj_btn_state[0]	// ＹＥＳ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].patno = $obj_btn_state[1]	// ＮＯ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno = $obj_btn_state[2]	// 確認ダイアログチェック
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno += @MSBTN_CHK
			}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 0)	{
					// ＹＥＳ
					break
				}
				elseif (@MSCHK == 1)	{
					// ＮＯ
					break
				}
				elseif (@MSCHK == 2)	{
						@se_play(001)
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}

		}
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 0
	}

	// 確認ダイアログの設定
	switch ($_L[20])	{
		case (0) $_L[11] = 0	// セーブ／ロード
		case (1) $_L[11] = 2	// 上書き確認
	}
	if (@CdStateReady == @On ) {@CdState[+$_L[11]] = @Off}

	// ロード実行
	if (@MSCHK == 0)	{
		@se_play(001)
		syscom.load(@SysSLDate00 + (@SysSLPage*10), @Off, @Off, @On)
	}
	// ロードキャンセル
	else	{
		@se_play(002)
	}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysSL04].tr_eve.set(0, L[20], 0, 2)
	@timewaitkey(L[20])

return


/********************************************************
*削除実行                                               *
*********************************************************/
#DataDelPut

	// 確認ダイアログ
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 読み込みデータ
	if ($sys_mode == $sys_sa_mode)	{
		K[0] = sys_sa_setbtn_bg00
		K[1] = sys_sa_setbtn01
		K[2] = sys_sa_setbtn02
		K[3] = sys_sa_chk00
	}
	else	{
		K[0] = sys_lo_setbtn_bg00
		K[1] = sys_lo_setbtn01
		K[2] = sys_lo_setbtn02
		K[3] = sys_lo_chk00
	}

	// 確認ダイアログ
	if (@CdState[+6] == @On)	{

		// システム音
		@se_play(001)

		// 削除確認下地
		@ex.f.obj[@ObjSysSL04].tr = 0
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].create(K[0],  @On,    0, 295)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].create(K[1], @On,  659, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].create(K[2], @On,  854, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].create(K[3], @On, 1095, 343)

		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].patno = $_L[10]

		// todo 修正
		$_L[20] = $_L[10]

		// 表示
		@ex.f.obj[@ObjSysSL04].tr_eve.set(255, L[20], 0, 2)

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

			@exif_(@Off, @Off, 0, @ObjSysSL04, _ObjSysSLConfBtn01)
			@exif_(@Off, @Off, 1, @ObjSysSL04, _ObjSysSLConfBtn02)
			@exif_(@Off, @Off, 2, @ObjSysSL04, _ObjSysSLConfChk00)

			// マウスボタン入力判定
			$MsBtnInputDecide
			if ($break_switch == @On)	{
				$break_switch = @Off
				@MSCHK = 1
				break
			}

			// 状態セット
			@MsStateSet(0, 3)

			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].patno = $obj_btn_state[0]	// ＹＥＳ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].patno = $obj_btn_state[1]	// ＮＯ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno = $obj_btn_state[2]	// 確認ダイアログチェック
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno += @MSBTN_CHK
			}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 0)	{
					// ＹＥＳ
					break
				}
				elseif (@MSCHK == 1)	{
					// ＮＯ
					break
				}
				elseif (@MSCHK == 2)	{
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}

		}
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 0
	}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].tr = 0
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].tr = 0
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].tr = 0
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].tr = 0
//	@ex.f.obj[@ObjSysSL04].tr = 0

	// 削除実行
	if (@MSCHK == 0)	{
		@se_play(001)
		syscom.delete_save(@SysSLDate00 + (@SysSLPage*10))
		// ＮＥＷデータ情報取得／設定 
		gosub #GetDataInfo

		// 削除しました
		gosub(3) #DataStateInfo

	}
	// 削除キャンセル
	else	{
		@se_play(002)
	}

	// 確認ダイアログの設定
	switch ($_L[20])	{
		case (0) $_L[11] = 0	// セーブ／ロード
		case (1) $_L[11] = 2	// 上書き確認
		case (2) $_L[11] = 4	// 入れ替え確認
		case (3) $_L[11] = 6	// 削除確認
	}
	if (@CdStateReady == @On ) {@CdState[+$_L[11]] = @Off}

	// 確認ダイアログ消去
//	@ex.f.obj[@ObjSysSL04].tr_eve.set(0, L[20], 0, 2)
//	@timewaitkey(L[20])

return(@MSCHK)


/********************************************************
*入れ替え実行                                           *
*********************************************************/
#DataChangePut

	// 確認ダイアログ
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 読み込みデータ
	if ($sys_mode == $sys_sa_mode)	{
		K[0] = sys_sa_setbtn_bg00
		K[1] = sys_sa_setbtn01
		K[2] = sys_sa_setbtn02
		K[3] = sys_sa_chk00
	}
	else	{
		K[0] = sys_lo_setbtn_bg00
		K[1] = sys_lo_setbtn01
		K[2] = sys_lo_setbtn02
		K[3] = sys_lo_chk00
	}

	// 確認ダイアログ
	if (@CdState[+4] == @On)	{

		// システム音
		@se_play(001)

		// 削除確認下地
		@ex.f.obj[@ObjSysSL04].tr = 0
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].create(K[0],  @On,    0, 295)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].create(K[1], @On,  659, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].create(K[2], @On,  854, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].create(K[3], @On, 1095, 343)

		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].patno = $_L[10]

		// todo 修正
		$_L[20] = $_L[10]

		// 表示
		@ex.f.obj[@ObjSysSL04].tr_eve.set(255, L[20], 0, 2)

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

			@exif_(@Off, @Off, 0, @ObjSysSL04, _ObjSysSLConfBtn01)
			@exif_(@Off, @Off, 1, @ObjSysSL04, _ObjSysSLConfBtn02)
			@exif_(@Off, @Off, 2, @ObjSysSL04, _ObjSysSLConfChk00)

			// マウスボタン入力判定
			$MsBtnInputDecide
			if ($break_switch == @On)	{
				@se_play(002)
				$break_switch = @Off
				@MSCHK = 1
				break
			}

			// 状態セット
			@MsStateSet(0, 3)

			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].patno = $obj_btn_state[0]	// ＹＥＳ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].patno = $obj_btn_state[1]	// ＮＯ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno = $obj_btn_state[2]	// 確認ダイアログチェック
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno += @MSBTN_CHK
			}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 0)	{
					// ＹＥＳ
					break
				}
				elseif (@MSCHK == 1)	{
					// ＮＯ
					break
				}
				elseif (@MSCHK == 2)	{
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}

		}
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 0
	}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].tr = 0
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].tr = 0
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].tr = 0
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].tr = 0
//	@ex.f.obj[@ObjSysSL04].tr = 0

	// 入れ替え実行
	if (@MSCHK == 0)	{
		@se_play(001)
		@StateData02 = @SysSLDate00 + (@SysSLPage * 10)
		syscom.change_save(@StateData01, @StateData02)
		// ＮＥＷデータ情報取得／設定
		gosub #GetDataInfo

		// 入れ替えしました
		gosub(2) #DataStateInfo

	}
	// 入れ替えキャンセル
	else	{
		@se_play(002)
	}

	// 確認ダイアログの設定
	switch ($_L[20])	{
		case (0) $_L[11] = 0	// セーブ／ロード
		case (1) $_L[11] = 2	// 上書き確認
		case (2) $_L[11] = 4	// 入れ替え確認
		case (3) $_L[11] = 6	// 削除確認
	}
	if (@CdStateReady == @On ) {@CdState[+$_L[11]] = @Off}

	// 確認ダイアログ消去
//	@ex.f.obj[@ObjSysSL04].tr_eve.set(0, L[20], 0, 2)
//	@timewaitkey(L[20])

return(@MSCHK)


/********************************************************
*セーブコメント                                          *
*********************************************************/
#SaveComPut

	// データ番号を取得
	@StateData01 = @SysSLDate00 + (@SysSLPage * 10)

	switch (@SysSLDate00)	{
		case (0) $_L[1] = 246*0 $_L[2] =   0 $_L[3] = 0
		case (1) $_L[1] = 246*1 $_L[2] =   0 $_L[3] = 0
		case (2) $_L[1] = 246*2 $_L[2] =   0 $_L[3] = 0
		case (3) $_L[1] = 246*3 $_L[2] =   0 $_L[3] = 0
		case (4) $_L[1] = 246*4 $_L[2] =   0 $_L[3] = 0
		case (5) $_L[1] = 246*0 $_L[2] = 270 $_L[3] = 1
		case (6) $_L[1] = 246*1 $_L[2] = 270 $_L[3] = 1
		case (7) $_L[1] = 246*2 $_L[2] = 270 $_L[3] = 1
		case (8) $_L[1] = 246*3 $_L[2] = 270 $_L[3] = 1
		case (9) $_L[1] = 246*4 $_L[2] = 270 $_L[3] = 1
	}

//	editbox[0].create($x, $y, $w, $h, $moji_size)  

	// エディットボックスを作成する
	editbox[0].create(43+$_L[1], 278+$_L[2]+$_L[3], 213, 17, 15) 
	editbox[0].set_text(syscom.get_save_comment(@StateData01))
	editbox[0].set_focus

	// マウス初期化
	//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
	@MouseBtnInit
	while (1)	{ // 0

		@MSCHK_PREV = @MSCHK
		@MSCHK = @MSBTN_NONE

		// エディットボックス範囲外設定
		if (((@MX >= 43+$_L[1]) && (@MX <= 278+$_L[1])) && ((@MY >= 213+$_L[2]+$_L[3])) && (@MY <= 213+17+$_L[2]))	{
		}
		else	{
			// 右クリック／右クリック
			if ((input.cancel.on_down_up == @On) || (input.decide.on_down_up == @On))	{
				input.clear
				break
			}
		}

		// Enter
		if (editbox[0].check_decided == @On)	{
			@se_play(001)
			// コメントを反映
			@SLComData00[+@SysSLDate00]  = editbox[0].get_text
			@SLComDataS00[+@SysSLDate00] = @SLComData00[+@SysSLDate00].left_len(34)
			// コメント
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText01+@SysSLDate00].create_string(@SLComDataS00[+@SysSLDate00], @On, 48+$_L[1], 282+$_L[2])
			@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComText01+@SysSLDate00].set_string_param(12, 0, 0, 0, 101, 1, 0)
			syscom.set_save_comment(@StateData01, @SLComData00[+@SysSLDate00])
			break
		}
		// ESC
		elseif (editbox[0].check_canceled == @On)	{
			@se_play(002)
			input.clear
			break
		}

		disp

	}

	// エディットボックスを破壊／初期化
	editbox[0].destroy
	editbox[0].clear_input

return


/********************************************************
*セーブ中／セーブ完了／入れ替え完了／削除完了           *	todo 修正
*********************************************************/
#DataStateInfo

	// 0…セーブ中、1…セーブしました、2…入れ替えしました、3…削除しました
	switch (L[0])	{
		case (0)
			K[0] = sys_sa_info01
			L[1] = 504 L[2] = 295 L[10] = 0
		case (1)
			K[0] = sys_sa_info01
			L[1] = 504 L[2] = 295 L[10] = 1
		case (2)
			if ($sys_mode == $sys_sa_mode) {K[0] = sys_sa_info02}
			else                           {K[0] = sys_lo_info00}
			L[1] = 433 L[2] = 295  L[10] = 0
		case (3)
			if ($sys_mode == $sys_sa_mode) {K[0] = sys_sa_info02}
			else                           {K[0] = sys_lo_info00}
			L[1] = 433 L[2] = 295  L[10] = 1
	}

	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLStateInfo].create(K[0], @On, L[1], L[2])
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLStateInfo].layer = 1000
	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLStateInfo].patno = L[10]

	@timewaitkey(500)

	@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLStateInfo].init


return



/********************************************************
*入れ替え元マーク表示                                   *	todo 修正
*********************************************************/
#DataChangeMark

	// 入れ替え元表示
	if (@DataStateCnt == @On)	{
		for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
			if (@SysSLPageExist[+$_L[0]] == @StateData01)	{
				switch ($_L[0])	{
					case (0) $_L[1] = 246*0 $_L[2] =   0
					case (1) $_L[1] = 246*1 $_L[2] =   0
					case (2) $_L[1] = 246*2 $_L[2] =   0
					case (3) $_L[1] = 246*3 $_L[2] =   0
					case (4) $_L[1] = 246*4 $_L[2] =   0
					case (5) $_L[1] = 246*0 $_L[2] = 270
					case (6) $_L[1] = 246*1 $_L[2] = 270
					case (7) $_L[1] = 246*2 $_L[2] = 270
					case (8) $_L[1] = 246*3 $_L[2] = 270
					case (9) $_L[1] = 246*4 $_L[2] = 270
				}
				@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark13].create(sys_sa_chkmark00, @On, 228+$_L[1],  95+$_L[2])
				@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark13].layer = 1000
				@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark13].frame_action.start(-1, "$sys_change_mark")
			}
		}
	}
	else	{
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLMark13].init
	}

return


/********************************************************
*セーブ／ロード画面実行                                 *
*********************************************************/
#SLPagePut

/*
//	デバック
	@ex.f.obj[@ObjSysSL03].@cd[149].create_string(math.tostr(@SLDataState), @On)
	@ex.f.obj[@ObjSysSL03].@cd[149].set_string_param(20, 0, 0, 0, 0, 0, 0)
	@ex.f.obj[@ObjSysSL03].@cd[149].layer = 1000
*/

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

		if (@SysSLhelpDisp == @Off)	{

			// 下部メニューボタン
			@exif_(@Off, @Off,             0, @ObjSysSL01, _ObjSysSLSBtn07)							// ゲームを終了
			@exif_(@Off, @Off,             1, @ObjSysSL01, _ObjSysSLSBtn08)							// タイトルに戻る
			if ($sys_mode != $sys_sa_mode)	{
				@exif_(@On,  (@TM_STATE == @Off) && (check_savepoint == @On), 2, @ObjSysSL01, _ObjSysSLSBtn09)		// セーブ
			}
			else	{
				@exif_(@Off, @Off,         3, @ObjSysSL01, _ObjSysSLSBtn10)							// ロード
			}
			@exif_(@Off, @Off,             4, @ObjSysSL01, _ObjSysSLSBtn11)							// コンフィグ
			@exif_(@Off, @Off,             5, @ObjSysSL01, _ObjSysSLSBtn12)							// ゲームに戻る

			// セーブ／ロードページ
			@exif_(@Off, @Off,                                 6, @ObjSysSL01, _ObjSysSLSBtn01)		// ↑
			@exif_(@Off, @Off,                                 7, @ObjSysSL01, _ObjSysSLSBtn02)		// ↓
			@exif_(@Off, @Off,                                 8, @ObjSysSL01, _ObjSysSLSBtn03)		// New
			@exif_(@On,  (@SysSLPage_state != @SLPage_auto),   9, @ObjSysSL01, _ObjSysSLSBtn04)		// Auto
			@exif_(@On,  (@SysSLPage_state != @SLPage_quick), 10, @ObjSysSL01, _ObjSysSLSBtn05)		// Quick
			@exif_(@Off, @Off,                                11, @ObjSysSL01, _ObjSysSLSBtn06)		// Help

			// todo : 現在のページ判定
			    if (@SysSLPage <  20) {$_L[0] =  0}
			elseif (@SysSLPage <  40) {$_L[0] = 20}
			elseif (@SysSLPage <  60) {$_L[0] = 40}
			elseif (@SysSLPage <  80) {$_L[0] = 60}
			elseif (@SysSLPage < 100) {$_L[0] = 80}
			@exif_(@On, @SysSLPage !=  0+$_L[0], 12, @ObjSysSL02, _ObjSysSLPage001)					// ページ001 / 021 / 041 / 061 / 081
			@exif_(@On, @SysSLPage !=  1+$_L[0], 13, @ObjSysSL02, _ObjSysSLPage002)					// ページ002 / 022 / 042 / 062 / 082
			@exif_(@On, @SysSLPage !=  2+$_L[0], 14, @ObjSysSL02, _ObjSysSLPage003)					// ページ003 / 023 / 043 / 063 / 083
			@exif_(@On, @SysSLPage !=  3+$_L[0], 15, @ObjSysSL02, _ObjSysSLPage004)					// ページ004 / 024 / 044 / 064 / 084
			@exif_(@On, @SysSLPage !=  4+$_L[0], 16, @ObjSysSL02, _ObjSysSLPage005)					// ページ005 / 025 / 045 / 065 / 085
			@exif_(@On, @SysSLPage !=  5+$_L[0], 17, @ObjSysSL02, _ObjSysSLPage006)					// ページ006 / 026 / 046 / 066 / 086
			@exif_(@On, @SysSLPage !=  6+$_L[0], 18, @ObjSysSL02, _ObjSysSLPage007)					// ページ007 / 027 / 047 / 067 / 087
			@exif_(@On, @SysSLPage !=  7+$_L[0], 19, @ObjSysSL02, _ObjSysSLPage008)					// ページ008 / 028 / 048 / 068 / 088
			@exif_(@On, @SysSLPage !=  8+$_L[0], 20, @ObjSysSL02, _ObjSysSLPage009)					// ページ009 / 029 / 049 / 069 / 089
			@exif_(@On, @SysSLPage !=  9+$_L[0], 21, @ObjSysSL02, _ObjSysSLPage010)					// ページ010 / 030 / 050 / 070 / 090
			@exif_(@On, @SysSLPage != 10+$_L[0], 22, @ObjSysSL02, _ObjSysSLPage011)					// ページ011 / 031 / 051 / 071 / 091
			@exif_(@On, @SysSLPage != 11+$_L[0], 23, @ObjSysSL02, _ObjSysSLPage012)					// ページ012 / 032 / 052 / 072 / 092
			@exif_(@On, @SysSLPage != 12+$_L[0], 24, @ObjSysSL02, _ObjSysSLPage013)					// ページ013 / 033 / 053 / 073 / 093
			@exif_(@On, @SysSLPage != 13+$_L[0], 25, @ObjSysSL02, _ObjSysSLPage014)					// ページ014 / 034 / 054 / 074 / 094
			@exif_(@On, @SysSLPage != 14+$_L[0], 26, @ObjSysSL02, _ObjSysSLPage015)					// ページ015 / 035 / 055 / 075 / 095
			@exif_(@On, @SysSLPage != 15+$_L[0], 27, @ObjSysSL02, _ObjSysSLPage016)					// ページ016 / 036 / 056 / 076 / 096
			@exif_(@On, @SysSLPage != 16+$_L[0], 28, @ObjSysSL02, _ObjSysSLPage017)					// ページ017 / 037 / 057 / 077 / 097
			@exif_(@On, @SysSLPage != 17+$_L[0], 29, @ObjSysSL02, _ObjSysSLPage018)					// ページ018 / 038 / 058 / 078 / 098
			@exif_(@On, @SysSLPage != 18+$_L[0], 30, @ObjSysSL02, _ObjSysSLPage019)					// ページ019 / 039 / 059 / 079 / 099
			@exif_(@On, @SysSLPage != 19+$_L[0], 31, @ObjSysSL02, _ObjSysSLPage020)					// ページ020 / 040 / 060 / 080 / 100

			// コメントボタン
			@exif_(@On, (@SLDateChk00[+0] == @On) && (@DataStateCnt == @Off), 32, @ObjSysSL03, _ObjSysSLComBg01)				// コメント01
			@exif_(@On, (@SLDateChk00[+1] == @On) && (@DataStateCnt == @Off), 33, @ObjSysSL03, _ObjSysSLComBg02)				// コメント02
			@exif_(@On, (@SLDateChk00[+2] == @On) && (@DataStateCnt == @Off), 34, @ObjSysSL03, _ObjSysSLComBg03)				// コメント03
			@exif_(@On, (@SLDateChk00[+3] == @On) && (@DataStateCnt == @Off), 35, @ObjSysSL03, _ObjSysSLComBg04)				// コメント04
			@exif_(@On, (@SLDateChk00[+4] == @On) && (@DataStateCnt == @Off), 36, @ObjSysSL03, _ObjSysSLComBg05)				// コメント05
			@exif_(@On, (@SLDateChk00[+5] == @On) && (@DataStateCnt == @Off), 37, @ObjSysSL03, _ObjSysSLComBg06)				// コメント06
			@exif_(@On, (@SLDateChk00[+6] == @On) && (@DataStateCnt == @Off), 38, @ObjSysSL03, _ObjSysSLComBg07)				// コメント07
			@exif_(@On, (@SLDateChk00[+7] == @On) && (@DataStateCnt == @Off), 39, @ObjSysSL03, _ObjSysSLComBg08)				// コメント08
			@exif_(@On, (@SLDateChk00[+8] == @On) && (@DataStateCnt == @Off), 40, @ObjSysSL03, _ObjSysSLComBg09)				// コメント09
			@exif_(@On, (@SLDateChk00[+9] == @On) && (@DataStateCnt == @Off), 41, @ObjSysSL03, _ObjSysSLComBg10)				// コメント10

			// ロックボタン
			@exif_(@On, (@SLDateChk00[+0] == @On) && (@DataStateCnt == @Off), 42, @ObjSysSL03, _ObjSysSLLockBtn01)				// ロック01
			@exif_(@On, (@SLDateChk00[+1] == @On) && (@DataStateCnt == @Off), 43, @ObjSysSL03, _ObjSysSLLockBtn02)				// ロック02
			@exif_(@On, (@SLDateChk00[+2] == @On) && (@DataStateCnt == @Off), 44, @ObjSysSL03, _ObjSysSLLockBtn03)				// ロック03
			@exif_(@On, (@SLDateChk00[+3] == @On) && (@DataStateCnt == @Off), 45, @ObjSysSL03, _ObjSysSLLockBtn04)				// ロック04
			@exif_(@On, (@SLDateChk00[+4] == @On) && (@DataStateCnt == @Off), 46, @ObjSysSL03, _ObjSysSLLockBtn05)				// ロック05
			@exif_(@On, (@SLDateChk00[+5] == @On) && (@DataStateCnt == @Off), 47, @ObjSysSL03, _ObjSysSLLockBtn06)				// ロック06
			@exif_(@On, (@SLDateChk00[+6] == @On) && (@DataStateCnt == @Off), 48, @ObjSysSL03, _ObjSysSLLockBtn07)				// ロック07
			@exif_(@On, (@SLDateChk00[+7] == @On) && (@DataStateCnt == @Off), 49, @ObjSysSL03, _ObjSysSLLockBtn08)				// ロック08
			@exif_(@On, (@SLDateChk00[+8] == @On) && (@DataStateCnt == @Off), 50, @ObjSysSL03, _ObjSysSLLockBtn09)				// ロック09
			@exif_(@On, (@SLDateChk00[+9] == @On) && (@DataStateCnt == @Off), 51, @ObjSysSL03, _ObjSysSLLockBtn10)				// ロック10

			// 入れ替えボタン
			if (@DataStateCnt == @Off)	{
				// 通常状態
				@exif_(@On, (@SysSLDataLock[+0+(@SysSLPage*10)] == @Off), 52, @ObjSysSL03, _ObjSysSLCngBtn01)											// 入れ替え01
				@exif_(@On, (@SysSLDataLock[+1+(@SysSLPage*10)] == @Off), 53, @ObjSysSL03, _ObjSysSLCngBtn02)											// 入れ替え02
				@exif_(@On, (@SysSLDataLock[+2+(@SysSLPage*10)] == @Off), 54, @ObjSysSL03, _ObjSysSLCngBtn03)											// 入れ替え03
				@exif_(@On, (@SysSLDataLock[+3+(@SysSLPage*10)] == @Off), 55, @ObjSysSL03, _ObjSysSLCngBtn04)											// 入れ替え04
				@exif_(@On, (@SysSLDataLock[+4+(@SysSLPage*10)] == @Off), 56, @ObjSysSL03, _ObjSysSLCngBtn05)											// 入れ替え05
				@exif_(@On, (@SysSLDataLock[+5+(@SysSLPage*10)] == @Off), 57, @ObjSysSL03, _ObjSysSLCngBtn06)											// 入れ替え06
				@exif_(@On, (@SysSLDataLock[+6+(@SysSLPage*10)] == @Off), 58, @ObjSysSL03, _ObjSysSLCngBtn07)											// 入れ替え07
				@exif_(@On, (@SysSLDataLock[+7+(@SysSLPage*10)] == @Off), 59, @ObjSysSL03, _ObjSysSLCngBtn08)											// 入れ替え08
				@exif_(@On, (@SysSLDataLock[+8+(@SysSLPage*10)] == @Off), 60, @ObjSysSL03, _ObjSysSLCngBtn09)											// 入れ替え09
				@exif_(@On, (@SysSLDataLock[+9+(@SysSLPage*10)] == @Off), 61, @ObjSysSL03, _ObjSysSLCngBtn10)											// 入れ替え10
			}
			else	{
				// 入れ替え状態
			}

			// 削除ボタン
			if (@DataStateCnt == @Off)	{
				@exif_(@On, ((@SysSLDataLock[+0+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+0] == @On)), 62, @ObjSysSL03, _ObjSysSLDelBtn01)					// 削除01
				@exif_(@On, ((@SysSLDataLock[+1+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+1] == @On)), 63, @ObjSysSL03, _ObjSysSLDelBtn02)					// 削除02
				@exif_(@On, ((@SysSLDataLock[+2+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+2] == @On)), 64, @ObjSysSL03, _ObjSysSLDelBtn03)					// 削除03
				@exif_(@On, ((@SysSLDataLock[+3+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+3] == @On)), 65, @ObjSysSL03, _ObjSysSLDelBtn04)					// 削除04
				@exif_(@On, ((@SysSLDataLock[+4+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+4] == @On)), 66, @ObjSysSL03, _ObjSysSLDelBtn05)					// 削除05
				@exif_(@On, ((@SysSLDataLock[+5+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+5] == @On)), 67, @ObjSysSL03, _ObjSysSLDelBtn06)					// 削除06
				@exif_(@On, ((@SysSLDataLock[+6+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+6] == @On)), 68, @ObjSysSL03, _ObjSysSLDelBtn07)					// 削除07
				@exif_(@On, ((@SysSLDataLock[+7+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+7] == @On)), 69, @ObjSysSL03, _ObjSysSLDelBtn08)					// 削除08
				@exif_(@On, ((@SysSLDataLock[+8+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+8] == @On)), 70, @ObjSysSL03, _ObjSysSLDelBtn09)					// 削除09
				@exif_(@On, ((@SysSLDataLock[+9+(@SysSLPage*10)] == @Off)) && ((@SLDateChk00[+9] == @On)), 71, @ObjSysSL03, _ObjSysSLDelBtn10)					// 削除10
			}
			else	{
				// 入れ替え状態
			}

			// セーブ／ロードボタン
			if ($sys_mode == $sys_sa_mode)	{
				// セーブ
				if (@DataStateCnt == @Off)	{
					// 通常状態
					@exif_(@On, (@SysSLDataLock[+0+(@SysSLPage*10)] == @Off), 72, @ObjSysSL03, _ObjSysSLDataBg01)						// ボタン01
					@exif_(@On, (@SysSLDataLock[+1+(@SysSLPage*10)] == @Off), 73, @ObjSysSL03, _ObjSysSLDataBg02)						// ボタン02
					@exif_(@On, (@SysSLDataLock[+2+(@SysSLPage*10)] == @Off), 74, @ObjSysSL03, _ObjSysSLDataBg03)						// ボタン03
					@exif_(@On, (@SysSLDataLock[+3+(@SysSLPage*10)] == @Off), 75, @ObjSysSL03, _ObjSysSLDataBg04)						// ボタン04
					@exif_(@On, (@SysSLDataLock[+4+(@SysSLPage*10)] == @Off), 76, @ObjSysSL03, _ObjSysSLDataBg05)						// ボタン05
					@exif_(@On, (@SysSLDataLock[+5+(@SysSLPage*10)] == @Off), 77, @ObjSysSL03, _ObjSysSLDataBg06)						// ボタン06
					@exif_(@On, (@SysSLDataLock[+6+(@SysSLPage*10)] == @Off), 78, @ObjSysSL03, _ObjSysSLDataBg07)						// ボタン07
					@exif_(@On, (@SysSLDataLock[+7+(@SysSLPage*10)] == @Off), 79, @ObjSysSL03, _ObjSysSLDataBg08)						// ボタン08
					@exif_(@On, (@SysSLDataLock[+8+(@SysSLPage*10)] == @Off), 80, @ObjSysSL03, _ObjSysSLDataBg09)						// ボタン09
					@exif_(@On, (@SysSLDataLock[+9+(@SysSLPage*10)] == @Off), 81, @ObjSysSL03, _ObjSysSLDataBg10)						// ボタン10
				}
				else	{
					// 入れ替え状態
					@exif_(@On, (@SysSLDataLock[+0+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+0] != @StateData01), 72, @ObjSysSL03, _ObjSysSLDataBg01)						// ボタン01
					@exif_(@On, (@SysSLDataLock[+1+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+1] != @StateData01), 73, @ObjSysSL03, _ObjSysSLDataBg02)						// ボタン02
					@exif_(@On, (@SysSLDataLock[+2+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+2] != @StateData01), 74, @ObjSysSL03, _ObjSysSLDataBg03)						// ボタン03
					@exif_(@On, (@SysSLDataLock[+3+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+3] != @StateData01), 75, @ObjSysSL03, _ObjSysSLDataBg04)						// ボタン04
					@exif_(@On, (@SysSLDataLock[+4+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+4] != @StateData01), 76, @ObjSysSL03, _ObjSysSLDataBg05)						// ボタン05
					@exif_(@On, (@SysSLDataLock[+5+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+5] != @StateData01), 77, @ObjSysSL03, _ObjSysSLDataBg06)						// ボタン06
					@exif_(@On, (@SysSLDataLock[+6+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+6] != @StateData01), 78, @ObjSysSL03, _ObjSysSLDataBg07)						// ボタン07
					@exif_(@On, (@SysSLDataLock[+7+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+7] != @StateData01), 79, @ObjSysSL03, _ObjSysSLDataBg08)						// ボタン08
					@exif_(@On, (@SysSLDataLock[+8+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+8] != @StateData01), 80, @ObjSysSL03, _ObjSysSLDataBg09)						// ボタン09
					@exif_(@On, (@SysSLDataLock[+9+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+9] != @StateData01), 81, @ObjSysSL03, _ObjSysSLDataBg10)
				}
			}
			else	{
				// ロード
				if (@DataStateCnt == @Off)	{
					// 通常状態
					@exif_(@On, (@SLDateChk00[+0] == @On) || (@DataStateCnt == @On), 72, @ObjSysSL03, _ObjSysSLDataBg01)				// ボタン01
					@exif_(@On, (@SLDateChk00[+1] == @On) || (@DataStateCnt == @On), 73, @ObjSysSL03, _ObjSysSLDataBg02)				// ボタン02
					@exif_(@On, (@SLDateChk00[+2] == @On) || (@DataStateCnt == @On), 74, @ObjSysSL03, _ObjSysSLDataBg03)				// ボタン03
					@exif_(@On, (@SLDateChk00[+3] == @On) || (@DataStateCnt == @On), 75, @ObjSysSL03, _ObjSysSLDataBg04)				// ボタン04
					@exif_(@On, (@SLDateChk00[+4] == @On) || (@DataStateCnt == @On), 76, @ObjSysSL03, _ObjSysSLDataBg05)				// ボタン05
					@exif_(@On, (@SLDateChk00[+5] == @On) || (@DataStateCnt == @On), 77, @ObjSysSL03, _ObjSysSLDataBg06)				// ボタン06
					@exif_(@On, (@SLDateChk00[+6] == @On) || (@DataStateCnt == @On), 78, @ObjSysSL03, _ObjSysSLDataBg07)				// ボタン07
					@exif_(@On, (@SLDateChk00[+7] == @On) || (@DataStateCnt == @On), 79, @ObjSysSL03, _ObjSysSLDataBg08)				// ボタン08
					@exif_(@On, (@SLDateChk00[+8] == @On) || (@DataStateCnt == @On), 80, @ObjSysSL03, _ObjSysSLDataBg09)				// ボタン09
					@exif_(@On, (@SLDateChk00[+9] == @On) || (@DataStateCnt == @On), 81, @ObjSysSL03, _ObjSysSLDataBg10)				// ボタン10
				}
				else	{
					// 入れ替え状態
					@exif_(@On, (@SysSLDataLock[+0+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+0] != @StateData01), 72, @ObjSysSL03, _ObjSysSLDataBg01)						// ボタン01
					@exif_(@On, (@SysSLDataLock[+1+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+1] != @StateData01), 73, @ObjSysSL03, _ObjSysSLDataBg02)						// ボタン02
					@exif_(@On, (@SysSLDataLock[+2+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+2] != @StateData01), 74, @ObjSysSL03, _ObjSysSLDataBg03)						// ボタン03
					@exif_(@On, (@SysSLDataLock[+3+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+3] != @StateData01), 75, @ObjSysSL03, _ObjSysSLDataBg04)						// ボタン04
					@exif_(@On, (@SysSLDataLock[+4+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+4] != @StateData01), 76, @ObjSysSL03, _ObjSysSLDataBg05)						// ボタン05
					@exif_(@On, (@SysSLDataLock[+5+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+5] != @StateData01), 77, @ObjSysSL03, _ObjSysSLDataBg06)						// ボタン06
					@exif_(@On, (@SysSLDataLock[+6+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+6] != @StateData01), 78, @ObjSysSL03, _ObjSysSLDataBg07)						// ボタン07
					@exif_(@On, (@SysSLDataLock[+7+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+7] != @StateData01), 79, @ObjSysSL03, _ObjSysSLDataBg08)						// ボタン08
					@exif_(@On, (@SysSLDataLock[+8+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+8] != @StateData01), 80, @ObjSysSL03, _ObjSysSLDataBg09)						// ボタン09
					@exif_(@On, (@SysSLDataLock[+9+(@SysSLPage*10)] == @Off) && (@SysSLPageExist[+9] != @StateData01), 81, @ObjSysSL03, _ObjSysSLDataBg10)						// ボタン10
				}
			}
		}
		else	{
			// ヘルプ表示
			@exif_(@Off, @Off, 100, @ObjSysSL03, _ObjSysSLHelp00)

		}


		// マウスホイール
		if (mouse.wheel > 0)	{
			@MSWHL_STATE = 1 @MSCHK = 148
			@MSBTN_RESULT = @DECIDE
		}
		elseif (mouse.wheel < 0)	{
			@MSWHL_STATE = -1 @MSCHK = 149
			@MSBTN_RESULT = @DECIDE
		}

		// Ｃｔｌ専用処理
		if (@S_CTL_BAR_CTLACTIVE == @On)	{
			@MSCHK = @S_CTL_BAR_CTLSTATE
		}

		// マウスボタン入力判定
		$MsBtnInputDecide
		if ($break_switch == @On)	{
			@se_play(002)
			if (@SLDataState == @DataNormal)	{
				// 右クリックによりゲームに戻る
				if (@SysSLhelpDisp == @Off)	{
					$break_switch = @Off
					break
				}
				else	{
					// ヘルプ表示消去
					@MSBTN_RESULT = @DECIDE
					@MSCHK = 100
					$break_switch = @Off
				}
			}
			else	{
				// データ入れ替えをキャンセル
				$break_switch = @Off
				@SLDataState = @DataNormal
				@DataStateCnt = @Off
				// ページ説明状態
				gosub #SLPageInfo
				gosub #DataChangeMark
			}
		}

		// 状態セット
		@MsStateSet(0, 150)

		// マウスボタン状態
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn07].patno = $obj_btn_state[0]				// ゲームを終了
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn08].patno = $obj_btn_state[1]				// タイトルに戻る
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn09].patno = $obj_btn_state[2]				// セーブ
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn10].patno = $obj_btn_state[3]				// ロード
        @ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn11].patno = $obj_btn_state[4]   			// コンフィグ
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn12].patno = $obj_btn_state[5]				// ゲームに戻る
		if ($sys_mode == $sys_sa_mode)	{
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn09].patno = @Operate
		}
		else	{
			@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn10].patno = @Operate
		}

		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn01].patno = $obj_btn_state[6]				// ↑
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn02].patno = $obj_btn_state[7]				// ↓
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn03].patno = $obj_btn_state[8]				// New
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn04].patno = $obj_btn_state[9]				// Auto
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn05].patno = $obj_btn_state[10]				// Quick
		@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn06].patno = $obj_btn_state[11]				// Help
		// 現在のページ設定
		    if (@SysSLPage_state == @SLPage_auto)  {@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn04].patno = @Operate}
		elseif (@SysSLPage_state == @SLPage_quick) {@ex.f.obj[@ObjSysSL01].@cd[_ObjSysSLSBtn05].patno = @Operate}


		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage001].patno = $obj_btn_state[12]				// ページ001 / 021 / 041 / 061 / 081
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage002].patno = $obj_btn_state[13]				// ページ002 / 022 / 042 / 062 / 082
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage003].patno = $obj_btn_state[14]				// ページ003 / 023 / 043 / 063 / 083
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage004].patno = $obj_btn_state[15]				// ページ004 / 024 / 044 / 064 / 084
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage005].patno = $obj_btn_state[16]				// ページ005 / 025 / 045 / 065 / 085
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage006].patno = $obj_btn_state[17]				// ページ006 / 026 / 046 / 066 / 086
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage007].patno = $obj_btn_state[18]				// ページ007 / 027 / 047 / 067 / 087
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage008].patno = $obj_btn_state[19]				// ページ008 / 028 / 048 / 068 / 088
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage009].patno = $obj_btn_state[20]				// ページ009 / 029 / 049 / 069 / 089
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage010].patno = $obj_btn_state[21]				// ページ010 / 030 / 050 / 070 / 090
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage011].patno = $obj_btn_state[22]				// ページ011 / 031 / 051 / 071 / 091
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage012].patno = $obj_btn_state[23]				// ページ012 / 032 / 052 / 072 / 092
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage013].patno = $obj_btn_state[24]				// ページ013 / 033 / 053 / 073 / 093
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage014].patno = $obj_btn_state[25]				// ページ014 / 034 / 054 / 074 / 094
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage015].patno = $obj_btn_state[26]				// ページ015 / 035 / 055 / 075 / 095
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage016].patno = $obj_btn_state[27]				// ページ016 / 036 / 056 / 076 / 096
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage017].patno = $obj_btn_state[28]				// ページ017 / 037 / 057 / 077 / 097
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage018].patno = $obj_btn_state[29]				// ページ018 / 038 / 058 / 078 / 098
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage019].patno = $obj_btn_state[30]				// ページ019 / 039 / 059 / 079 / 099
		@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage020].patno = $obj_btn_state[31]				// ページ020 / 040 / 060 / 080 / 100

		// todo : ページのページ判定
		if (@SysSLPage <  100)	{
			    if (@SysSLPage <   20) {$_L[0] =  0}
			elseif (@SysSLPage <   40) {$_L[0] = 20}
			elseif (@SysSLPage <   60) {$_L[0] = 40}
			elseif (@SysSLPage <   80) {$_L[0] = 60}
			elseif (@SysSLPage <  100) {$_L[0] = 80}
			@ex.f.obj[@ObjSysSL02].@cd[_ObjSysSLPage001+(@SysSLPage - $_L[0])].patno = @Operate
		}

		// コメント下地
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg01].patno = $obj_btn_state[32]				// コメント01
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg02].patno = $obj_btn_state[33]				// コメント02
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg03].patno = $obj_btn_state[34]				// コメント03
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg04].patno = $obj_btn_state[35]				// コメント04
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg05].patno = $obj_btn_state[36]				// コメント05
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg06].patno = $obj_btn_state[37]				// コメント06
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg07].patno = $obj_btn_state[38]				// コメント07
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg08].patno = $obj_btn_state[39]				// コメント08
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg09].patno = $obj_btn_state[40]				// コメント09
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLComBg10].patno = $obj_btn_state[41]				// コメント10

		// ロックボタン
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn01].patno = $obj_btn_state[42]			// ロック01
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn02].patno = $obj_btn_state[43]			// ロック02
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn03].patno = $obj_btn_state[44]			// ロック03
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn04].patno = $obj_btn_state[45]			// ロック04
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn05].patno = $obj_btn_state[46]			// ロック05
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn06].patno = $obj_btn_state[47]			// ロック06
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn07].patno = $obj_btn_state[48]			// ロック07
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn08].patno = $obj_btn_state[49]			// ロック08
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn09].patno = $obj_btn_state[50]			// ロック09
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn10].patno = $obj_btn_state[51]			// ロック10
		for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
			if (@SysSLDataLock[+$_L[0]+(@SysSLPage*10)] == @On)	{
				@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLLockBtn01+$_L[0]].patno += @Operate
			}
		}

		// 入れ替えボタン
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn01].patno = $obj_btn_state[52]			// 入れ替え01
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn02].patno = $obj_btn_state[53]			// 入れ替え02
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn03].patno = $obj_btn_state[54]			// 入れ替え03
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn04].patno = $obj_btn_state[55]			// 入れ替え04
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn05].patno = $obj_btn_state[56]			// 入れ替え05
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn06].patno = $obj_btn_state[57]			// 入れ替え06
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn07].patno = $obj_btn_state[58]			// 入れ替え07
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn08].patno = $obj_btn_state[59]			// 入れ替え08
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn09].patno = $obj_btn_state[60]			// 入れ替え09
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLCngBtn10].patno = $obj_btn_state[61]			// 入れ替え10

		// 削除ボタン
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn01].patno = $obj_btn_state[62]			// 削除01
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn02].patno = $obj_btn_state[63]			// 削除02
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn03].patno = $obj_btn_state[64]			// 削除03
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn04].patno = $obj_btn_state[65]			// 削除04
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn05].patno = $obj_btn_state[66]			// 削除05
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn06].patno = $obj_btn_state[67]			// 削除06
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn07].patno = $obj_btn_state[68]			// 削除07
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn08].patno = $obj_btn_state[69]			// 削除08
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn09].patno = $obj_btn_state[70]			// 削除09
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDelBtn10].patno = $obj_btn_state[71]			// 削除10

		// セーブ／ロードボタン
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg01].patno = $obj_btn_state[72]			// ボタン01
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg02].patno = $obj_btn_state[73]			// ボタン02
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg03].patno = $obj_btn_state[74]			// ボタン03
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg04].patno = $obj_btn_state[75]			// ボタン04
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg05].patno = $obj_btn_state[76]			// ボタン05
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg06].patno = $obj_btn_state[77]			// ボタン06
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg07].patno = $obj_btn_state[78]			// ボタン07
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg08].patno = $obj_btn_state[79]			// ボタン08
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg09].patno = $obj_btn_state[80]			// ボタン09
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg10].patno = $obj_btn_state[81]			// ボタン10
		for ($_L[0] = 0, $_L[0] < 10, $_L[0] += 1)	{
			if (@SLDateChk00[+$_L[0]] == @On) {@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg01+$_L[0]].patno += 4}
			if ($sys_mode == $sys_sa_mode)	{
				if (@SysSLDataLock[+$_L[0]++(@SysSLPage*10)] == @On) {@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLDataBg01+$_L[0]].patno = 0}
			}
		}

		// ヘルプ表示
		@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLHelp00].patno = $obj_btn_state[150]

		// 状態表示
		input.next
		disp

		// 結果
		if (@MSBTN_RESULT == @DECIDE)	{
			@MSBTN_RESULT = @INIT
			// マウスホイールでページ切り替え
			if (@MSCHK >= 148 && @MSCHK <= 149)	{
				@SysSLPage_prev = @SysSLPage
				@SysSLPage = @SysSLPage_prev + @MSWHL_STATE
				    if (@SysSLPage > 99) {@SysSLPage = 0}
				elseif (@SysSLPage < 0)  {@SysSLPage = 99}
				// 開いたページを記憶
				@SysSLLastPage = @SysSLPage
				@SysSLPageCng  = @On
				// ページ切り替え判定
				@SysSLPageChange = @On
				break
			}
			switch (@MSCHK)	{
				case (0)
					// ゲームを終了
					$sys_return_sl(0)
					goto #MenuSel00
				case (1)
					// タイトルに戻る
					$sys_return_sl(1)
					goto #MenuSel00
				case (2)
					// セーブ
					@ex.F[$sys_sa_mode] = @On
					break
				case (3)
					// ロード
					@ex.F[$sys_lo_mode] = @On
					break
				case (4)
					// コンフィグ
					@ex.F[$sys_cf_mode] = @On
					break
				case (5)
					// ゲームに戻る
					break
				case (6)
					// ↑
					@se_play(001)
					@SysSLPage_prev = @SysSLPage
					@SysSLPage -= 20
					if (@SysSLPage < 0) {@SysSLPage = 80 + @SysSLPage_prev}
					// 開いたページを記憶
					@SysSLLastPage = @SysSLPage
					@SysSLPageCng  = @On
					// ページ切り替え判定
					@SysSLPageChange = @On
					break
				case (7)
					// ↓
					@se_play(001)
					@SysSLPage_prev = @SysSLPage
					@SysSLPage += 20
					if (@SysSLPage > 99) {@SysSLPage = 0 + (@SysSLPage_prev - 80)}
					// 開いたページを記憶
					@SysSLLastPage = @SysSLPage
					@SysSLPageCng  = @On
					// ページ切り替え判定
					@SysSLPageChange = @On
					break
				case (8)
					// New
					if ((syscom.get_save_new_no(0, 1000) != -1) && (@SysSLPage_new != @SysSLPage))	{
						@SysSLPage_prev = @SysSLPage
						@SysSLPage = @SysSLPage_new
						// 開いたページを記憶
						@SysSLLastPage = @SysSLPage
						@SysSLPageCng  = @On
						// ページ切り替え判定
						@SysSLPageChange = @On
						break
					}
				case (9)
					// Auto
					@se_play(001)
					@SysSLPageTab_Prev = @SysSLPageTab
					@SysSLPage_prev = @SysSLPage
					@SysSLPage = 100
					@SysSLPage_state = @SLPage_auto
					// 開いたページを記憶
					@SysSLLastPage = @SysSLPage
					@SysSLPageCng  = @On
					// ページ切り替え判定
					@SysSLPageChange = @On
					break
				case (10)
					// Quick
					@SysSLPageTab_Prev = @SysSLPageTab
					@se_play(001)
					@SysSLPage_prev = @SysSLPage
					@SysSLPage = 101
					@SysSLPage_state = @SLPage_quick
					// 開いたページを記憶
					@SysSLLastPage = @SysSLPage
					@SysSLPageCng  = @On
					// ページ切り替え判定
					@SysSLPageChange = @On
					break
				case (11)
					// Help
					@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLHelp00].disp = @On
					@SysSLhelpDisp = @On
					goto #MenuSel00
			}
			// ページを切り替え
			if ((@MSCHK >= 12) && (@MSCHK <= 31))	{
				@SysSLPage_prev = @SysSLPage
				switch (@SysSLPageTab)	{
					case (0) L[0] =  0
					case (1) L[0] = 20
					case (2) L[0] = 40
					case (3) L[0] = 60
					case (4) L[0] = 80
				}
				@SysSLPage = L[0] + (@MSCHK - 12)
				// 開いたページを記憶
				@SysSLLastPage = @SysSLPage
				@SysSLPageCng  = @On
				// ページ切り替え判定
				@SysSLPageChange = @On
				break
			}
			// セーブコメントボタン
			elseif ((@MSCHK >= 32) && (@MSCHK <= 41))	{
				@SysSLDate00 = @MSCHK - 32
				gosub #SaveComPut
				goto #MenuSel00
			}
			// データロック
			elseif ((@MSCHK >= 42) && (@MSCHK <= 51))	{
				@se_play(001)
				@SysSLDate00 = @MSCHK - 42
				// データ番号を取得
				@StateData01 = @SysSLDate00 + (@SysSLPage * 10)
				// データをロック／解除
				if (@SysSLDataLock[+@StateData01] == @Off)	{
					@SysSLDataLock[+@StateData01] = @On
				}
				else	{
					@SysSLDataLock[+@StateData01] = @Off
				}
				goto #MenuSel00
			}
			// データ入れ替え
			elseif ((@MSCHK >= 52) && (@MSCHK <= 61))	{
				@se_play(001)
				@SLDataState = @DataChange
				@DataStateCnt = @On
				@StateData01  = (@MSCHK - 52) + (@SysSLPage * 10)
				gosub #DataChangeMark
				// ページ説明状態
				gosub #SLPageInfo
				goto #MenuSel00
			}
			// データ削除
			elseif ((@MSCHK >= 62) && (@MSCHK <= 71))	{
				@SysSLDate00 = @MSCHK - 62
				if (@CdState[+6] == @On)	{
					// 削除確認
					$_L[10] = 3
				}
				L[0] = gosub($_L[10]) #DataDelPut
				// ページ切り替え判定
				if (L[0] == 0)	{
					@SysSLPageChange = @On
					break
				}
				goto #MenuSel00
			}
			// セーブ／ロードボタン
			elseif ((@MSCHK >= 72) && (@MSCHK <= 81))	{
				// セーブ／ロード
				if (@SLDataState == @DataNormal)	{
					// セーブ画面
					if ($sys_mode == $sys_sa_mode)	{
						// 通常セーブ
						if (@SLDataState == @DataNormal)	{
							@SysSLDate00 = @MSCHK - 72
							$_L[10] = 0	// todo 修正
							// セーブ確認
							if ((@CdState[+0] == @On) && (@SysSLDataExist[+@SysSLDate00] == @Off))	{
								// セーブ確認
								$_L[10] = 0
							}
							elseif ((@CdState[+2] == @On) && (@SysSLDataExist[+@SysSLDate00] != @Off))	{
								// 上書き確認
								$_L[10] = 1
							}
							gosub($_L[10]) #DataSavePut
							goto #MenuSel00
						}
					}
					// ロード画面
					else	{
						// 通常ロード
						if (@SLDataState == @DataNormal)	{
							@SysSLDate00 = @MSCHK - 72
							if (@CdState[+0] == @On)	{
								// ロード確認
								$_L[10] = 0
							}
							gosub($_L[10]) #DataLoadPut
							goto #MenuSel00
						}
					}
				}
				// データ入れ替え
				else	{
					@SysSLDate00 = @MSCHK -72
					if (@CdState[+4] == @On)	{
						// 入れ替え確認
						$_L[10] = 2
					}
					L[0] = gosub($_L[10]) #DataChangePut
					@SLDataState  = @DataNormal
					@DataStateCnt = @Off
					// ページ切り替え判定
					if (L[0] == 0)	{
						@SysSLPageChange = @On
						break
					}
					// ページ説明状態
					gosub #SLPageInfo
					gosub #DataChangeMark
					goto #MenuSel00
				}
			}
			elseif (@MSCHK == 100)	{
//				if (@SysSLhelpDisp == @Off)	{
//					@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLHelp00].disp = @On
//					@SysSLhelpDisp = @On
//				}
//				else	{
					@ex.f.obj[@ObjSysSL03].@cd[_ObjSysSLHelp00].disp = @Off
					@SysSLhelpDisp = @Off
//				}
			}
		}
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
// タイトルメニューに戻る／ゲームを終了する	todo 修正
// ----------------------------------------------------------------------------------------
command $sys_return_sl(property $game_state : int)
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
		case (@Def ) L[20] = 250    L[21] = 1000
		case (@Fast) L[20] = 250/2  L[21] = 1000/2
		case (@Inst) L[20] = 0      L[21] = 0
	}

	// 確認ダイアログ
	if (@CdState[+L[1]] == @On)	{

		// システム音
		@se_play(001)

		// 削除確認下地	todo 仮
		@ex.f.obj[@ObjSysSL04].tr = 0
		@ex.f.obj[@ObjSysSL04].layer = 1000
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].create(sys_sa_chk00,      @On, 1095, 343)
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfFilter00].create(bg_kuro,        @On,    0,   0)

		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBg00].patno = L[0]
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfFilter00].tr = 150
		@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfFilter00].layer = -1


		// 表示
		@ex.f.obj[@ObjSysSL04].tr_eve.set(255, L[20], 0, 2)

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

			@exif_(@Off, @Off, 0, @ObjSysSL04, _ObjSysSLConfBtn01)
			@exif_(@Off, @Off, 1, @ObjSysSL04, _ObjSysSLConfBtn02)
			@exif_(@Off, @Off, 2, @ObjSysSL04, _ObjSysSLConfChk00)

			// マウスボタン入力判定
			$MsBtnInputDecide
			if ($break_switch == @On)	{
				@se_play(002)
				$break_switch = @Off
				@MSCHK = 1
				break
			}

			// 状態セット
			@MsStateSet(0, 3)

			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn01].patno = $obj_btn_state[0]	// ＹＥＳ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfBtn02].patno = $obj_btn_state[1]	// ＮＯ
			@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno = $obj_btn_state[2]	// 確認ダイアログチェック
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysSL04].@cd[_ObjSysSLConfChk00].patno += @MSBTN_CHK
			}

			// 状態表示
			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				if (@MSCHK == 0)	{
					// ＹＥＳ
					break
				}
				elseif (@MSCHK == 1)	{
					// ＮＯ
					break
				}
				elseif (@MSCHK == 2)	{
					@se_play(001)
	     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
					elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}

		}
	}
	// 確認ダイアログ無し
	else	{
		@MSCHK = 0
	}

	// 確認ダイアログの設定
	switch ($game_state)	{
		case (0) $_L[11] = 7	// ゲームを終了する
		case (1) $_L[11] = 5	// タイトルメニューに戻る
	}
	if (@CdStateReady == @On ) {@CdState[+$_L[11]] = @Off}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysSL04].tr_eve.set(0, L[20], 0, 2)

	// 実行
	if (@MSCHK == 0)	{
		// ゲームを終了する
		@bgm_stop(2000)
		@se_play(003)
		@ex.f.obj[@ObjSysSL05].create(bg_kuro, @On, 0, 0)
		@ex.f.obj[@ObjSysSL05].tr = 0
		@ex.f.obj[@ObjSysSL05].layer = 1000001
		@ex.f.obj[@ObjSysSL05].tr_eve.set(255, L[21], 0, 0)
		@ex.f.obj[@ObjSysSL05].tr_eve.wait_key
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


// ----------------------------------------------------------------------------------------
// 入れ替え元表示マークアニメ	todo 修正
// ----------------------------------------------------------------------------------------
command $sys_change_mark(
	property $fa  : frameaction,
	property $obj : object
)
{
	L[0] = $fa.counter.get % 1000
	L[1] = math.timetable(L[0], 0, 0, [0, 1000, 35, 0])
	$obj.patno = L[1]

}

