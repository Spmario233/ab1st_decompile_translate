/********************************************************
*														*
*					システムメニュー					*
*														*
*********************************************************/
// 右クリック
#define		@ObjSysMenu00				 0		// excall.obj
#define		_ObjSysMenuBg01				 0		// 下地
#define		_ObjSysMenuBg02				 1		// 下地
#define		_ObjSysMenuBg03				 2		// 下地
#define		_ObjSysMenuBg04				 3		// 下地
#define		_ObjSysMenuSkip01			 4		// 一度読んだ文章を飛ばす
#define		_ObjSysMenuSkip02			 5		// 一度読んだ文章を飛ばす
#define		_ObjSysMenuASkip01			 6		// 自動早送り
#define		_ObjSysMenuASkip02			 7		// 自動早送り
#define		_ObjSysMenuAutoCheck01		 8		// オートモードチェック
#define		_ObjSysMenuAutoCheck02		 9		// オートモードチェック
#define		_ObjSysMenuSave01			10		// セーブ
#define		_ObjSysMenuSave02			11		// セーブ
#define		_ObjSysMenuLoad01			12		// ロード
#define		_ObjSysMenuLoad02			13		// ロード
#define		_ObjSysMenuConfig01			14		// 環境設定
#define		_ObjSysMenuConfig02			15		// 環境設定
#define		_ObjSysMenuSel01			16		// 前の選択肢に戻る
#define		_ObjSysMenuSel02			17		// 前の選択肢に戻る
#define		_ObjSysMenuTitle01			18		// タイトルに戻る
#define		_ObjSysMenuTitle02			19		// タイトルに戻る
#define		_ObjSysMenuEnd01			20		// ゲームを終了する
#define		_ObjSysMenuEnd02			21		// ゲームを終了する

#define		_ObjSysMenuSkip_selbg		22		// 一度読んだ文章を飛ばす
#define		_ObjSysMenuAutoCheck_selbg	23		// オートモードチェック
#define		_ObjSysMenuSave_selbg		24		// セーブ
#define		_ObjSysMenuLoad_selbg		25		// ロード
#define		_ObjSysMenuConfig_selbg		26		// 環境設定
#define		_ObjSysMenuSel_selbg		27		// 前の選択肢に戻る
/*
#define		_ObjSysMenuMWipe			13		// メニュー表示の高速化
#define		_ObjSysMenuCheck			14		// ＮＯ
#define		_ObjSysMenuBtnArea01		15		// システムメニューボタンの当たり判定用下地
#define		_ObjSysMenuBtnArea02		16		// システムメニューボタンの当たり判定用下地
#define		_ObjSysMenuSkipMov01		17		// 一度読んだ文章を飛ばすＯＦＦ
#define		_ObjSysMenuSkipMov02		18		// 一度読んだ文章を飛ばすＯＮ
#define		_ObjSysMenuASkipMov01		19		// 自動早送りＯＦＦ
#define		_ObjSysMenuASkipMov02		20		// 自動早送りＯＮ
#define		_ObjSysMenuAutoCheckMov01	21		// オートモードチェックＯＦＦ
#define		_ObjSysMenuAutoCheckMov02	22		// オートモードチェックＯＮ
#define		_ObjSysMenuSaveMov			23		// セーブ
#define		_ObjSysMenuLoadMov			24		// ロード
#define		_ObjSysMenuConfigMov		25		// 環境設定
#define		_ObjSysMenuSelMov			26		// 前の選択肢に戻る
#define		_ObjSysMenuTitleMov			27		// タイトルに戻る
#define		_ObjSysMenuEndMov			28		// ゲームを終了する
#define		_ObjSysMenuPlayTimeBg		29		// プレイ時間下地
#define		_ObjSysMenuPlayTimeNum01	30		// プレイ時間数字[X0 day 00:00:00]
#define		_ObjSysMenuPlayTimeNum02	31		// プレイ時間数字[0X day 00:00:00]
#define		_ObjSysMenuPlayTimeNum03	32		// プレイ時間数字[00 day X0:00:00]
#define		_ObjSysMenuPlayTimeNum04	33		// プレイ時間数字[00 day 0X:00:00]
#define		_ObjSysMenuPlayTimeNum05	34		// プレイ時間数字[00 day 00:X0:00]
#define		_ObjSysMenuPlayTimeNum06	35		// プレイ時間数字[00 day 00:0X:00]
#define		_ObjSysMenuPlayTimeNum07	36		// プレイ時間数字[00 day 00:00:X0]
#define		_ObjSysMenuPlayTimeNum08	37		// プレイ時間数字[00 day 00:00:0X]
#define		_ObjSysMenuBgmTitleDisp		38		// ＢＧＭタイトル
#define		_ObjSysMenuBtnHelp			39		// 項目ヘルプ
*/



// 確認ボタン
#define		@ObjSysMenu01				 1		// excall.obj
#define		_ObjSysMenuConBg00			 0		// 前の選択肢に戻りますか？／タイトルメニューに戻りますか？／ゲームを終了しますか？／回想メニューに戻りますか？下地
#define		_ObjSysMenuConYes			 1		// ＹＥＳ
#define		_ObjSysMenuConNo			 2		// ＮＯ
#define		_ObjSysMenuConCheck			 3		// 次回以降この確認を行わない
#define		_ObjSysMenuConFilter		 4		// フィルター

//#define		@SMCdState[						// +2…前の選択肢 +9…タイトルメニュー +10…ゲームを終了 +11…回想メニュー
//#define		@SMCdStateReady				$sm_cd_state_ready	// 次回以降この確認を行わない

#define		@SADisoHeip					G[1503]
#define		@LODisoHeip					G[1504]
#define		@CFDisoHeip					G[1505]

#define		@SkipState					$skipstate
#define		@ASkipState					$askipstate
#define		@AutoState					$autostate
#define		@WindowState				$windowstate
#define		@SelState					$selstate
#define		@SaveState					$savestate
#define		@LoadState					$loadstate

#define		@SkipStartReady				$skip_start_ready
#define		@AutoStartReady				$auto_start_ready

#define		@HelpDispState				$help_disp_state
#define		@HelpDispStatePrev			$help_disp_state_prev

// システムメニュー状態取得
#macro		@GetSysMenuState(@Skip, @ASkip, @Auto, @Window, @Sel, @Save, @Load)
			@Skip   = syscom.check_read_skip_enable
			@ASkip  = syscom.check_auto_skip_enable
			@Auto   = syscom.check_auto_mode_enable
			@Window = syscom.check_hide_mwnd_enable
			@Sel    = syscom.check_return_to_sel_enable
			@Save   = syscom.check_save_enable
			@Load   = syscom.check_load_enable

#property	$sm_cd_state_ready : int
#property	$skipstate         : int
#property	$askipstate        : int
#property	$autostate         : int
#property	$windowstate       : int
#property	$selstate          : int
#property	$savestate         : int
#property	$loadstate         : int

#property	$skip_start_ready : int
#property	$auto_start_ready : int

#property	$help_disp_state      : int
#property	$help_disp_state_prev : int
