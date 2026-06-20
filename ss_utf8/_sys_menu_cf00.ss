/********************************************************
*														*
*			環境設定[メッセージウィンドウ]				*
*														*
*********************************************************/
#z00

	// システムコール準備
	$excall_ready

	// ＢＧＭタイトル制御excall01
//	$bgm_title_control1_excall

	@ex.F[$sys_cf_mode] = @On

	// 現在のＢＧＭタイトル表示状態を記憶
//	@EsBgmDetailDispPrev = @EsBgmDetailDisp

	@se_play(001)

	jump(_sys_menu_cf01, 00)

