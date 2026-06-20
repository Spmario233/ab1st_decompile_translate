#z00

	// 切り替え前のショートカットメニューの矩形禁止範囲を解除
//	if (@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].child.get_size > 0)	{
//		@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].@cd[_ObjSysSCAutobg01].click_disable = @Off
//		@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].@cd[_ObjSysSCHelpbg01].click_disable = @Off
//		@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].@cd[_ObjSysSCMsgbg01].click_disable = @Off
//		@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].@cd[_ObjSysSCVolbg01].click_disable = @Off
//	}
//
//	$get_mwnd_no = L[0]
//	set_mwnd($get_mwnd_no)
//
//	// メッセージウィンドウ
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].init
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].disp = @On
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].order = -1	// 注意
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].@cd.resize(80)
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].f.resize(15)
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].x = @MWND_REP_X
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].y = @MWND_REP_Y
//	@f.mwnd[$get_mwnd_no].@obj[@ObjSysSC00].layer = -1000
//
//	// 0:Auto/Skip表示中 1:クイック／スキップ表示
//	@f.mwnd[$get_mwnd_no].@obj[1].init
//	@f.mwnd[$get_mwnd_no].@obj[1].disp = @On
//	@f.mwnd[$get_mwnd_no].@obj[1].order = 2
//	@f.mwnd[$get_mwnd_no].@obj[1].layer = 10000
//	@f.mwnd[$get_mwnd_no].@obj[1].@cd.resize(3)
////	@f.mwnd[$get_mwnd_no].@obj[1].@cd[0].create(sys_as_disp00, @On, 904, 44)
////	@f.mwnd[$get_mwnd_no].@obj[1].@cd[0].frame_action.start(-1, "$sys_auto_skip_disp")
//
	@f.mwnd[$get_mwnd_no].@obj[5].create(sys_mw_info00, @On, 0, 10)
	@f.mwnd[$get_mwnd_no].@obj[5].tr = 0
	@f.mwnd[$get_mwnd_no].@obj[5].layer = 10000

	frame



return




command $sys_auto_skip_disp(property $fa : frameaction, property $obj : object)
{

	L[0] = syscom.get_read_skip_onoff_flag
	L[1] = syscom.get_auto_mode_onoff_flag

	$obj.disp = @On

	if (L[0] == @On && (L[1] == @Off))	{
		$obj.patno = 0
	}
	elseif ((L[1] == @On) && (L[0] == @Off))	{
		$obj.patno = 1
	}
	elseif ((L[0] == @On) && (L[1] == @On))	{
		$obj.patno = 2
	}
	else	{
		$obj.disp = @Off
	}


}

//---------------------------------------------------------------------------------------------------------


// ウィンドウ揺れ判定
command	$waku_shake(property $shake : int)
{
	switch ($shake)	{
		// 無し
		case (0)
		// 縦／弱
		case (1) @QUAKE_UD(100, 1, 1, 50, 1)
		// 横／弱
		case (2) @QUAKE_LR(100, 1, 1, 50, 1)
		// 拡縮／弱
		case (3) @QUAKE_ZOOM(100, 1, 1, 30, 640,500,1)
		// 縦／強
		case (4) @QUAKE_UD(100, 2, 1, 75, 1)
		// 横／強
		case (5) @QUAKE_LR(100, 2, 1, 75, 1)
		// 拡縮／強
		case (6) @QUAKE_ZOOM(100, 2, 1, 50, 640,500,1)
	}
}






