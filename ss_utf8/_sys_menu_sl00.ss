/********************************************************
*														*
*			セーブ／ロード[メッセージウィンドウ]		*
*														*
*********************************************************/
#z00

	// タイトルメニュー中は禁止
	if (@TM_STATE != 0)	{
		return
	}

	if (@シーン回想中 == @On)	{
		return
	}

	// システムコール準備
	$excall_ready

	@ex.F[$sys_sa_mode] = @On

	@se_play(001)

	jump(_sys_menu_sl01, 00)



#z01

	if (@シーン回想中 == @On)	{
		return
	}

	// システムコール準備
	$excall_ready

	@ex.F[$sys_lo_mode] = @On

	@se_play(001)

	jump(_sys_menu_sl01, 00)



