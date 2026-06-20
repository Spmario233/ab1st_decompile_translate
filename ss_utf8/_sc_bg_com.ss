/********************************************************
*														*
*				背景／イベントＣＧ表示					*
*														*
*********************************************************/
#z00

command $bg_disp(property $dummy : int)
{

	// @fade重複トリガーを解除
	$fade_dup = @Off

	// 演出用の背景カウントを初期化
	$bg_disp_cnt = @Init

	// 背景ブラー判定
	if ($bg_blur[0] == @On)	{
		K[0] = "bl_"
	}
	elseif (($bg_blur[0] == @Off) || ($bg_name[0].left(2) == "EV"))	{
		K[0] = ""
	}
	// 背景／イベントＣＧ表示[統合]
	if (($bg_type == _type_bg) || ($bg_type == _type_cg1))	{
		@b.obj[@OBJ_BG01].create(K[0] + $bg_name[0])
		@b.obj[@OBJ_BG01].layer = -10000
		@b.obj[@OBJ_BG01].disp = @On
//		@b.obj[@OBJ_BG01].wipe_copy = @On
	}
	// イベントＣＧ表示[分割] CG2
	else	{
		@b.obj[@OBJ_BG01].init
		@b.obj[@OBJ_BG01].layer = -10000
		@b.obj[@OBJ_BG01].disp = @On
		@b.obj[@OBJ_BG01].@cd.resize(2)
		
		// CGモードでもここと同じ処理をしていますので変更の際は鈴木までお願い致します
		// "evmh_01_"0101
		K[0] = $bg_name[0].left(8) + "base___00"	// ※AB!仕様
		K[1] = $bg_name[0].left(8) + "face"
		// evmh_01_"01"01
		K[2] = $bg_name[0].mid(8, 2)  L[2] = K[2].tonum
		// evmh_01_01"01"
		K[3] = $bg_name[0].mid(10, 2) L[3] = K[3].tonum
		// CG生成
		K[0] += math.tostr(L[2]-1)
		// base
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].create(K[0])
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].layer = -10000
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].disp = @On
//		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].patno = L[2] -1
//		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].wipe_copy = @On
		// face
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].create(K[1])
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].layer = -10000
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].disp = @On
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].patno = L[3] -1
//		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].wipe_copy = @On
	}

	// 背景／イベントＣＧ判定
	if ($bg_name[0].left(2) == "EV")	{
		$disp = _disp_ev
	}
	else	{
		$disp = _disp_bg
	}

	// bg_set初期化
	for (L[0] = 1, L[0] < @bg_maxnum, L[0] += 1)	{
		@f.obj[@OBJ_BG01+L[0]].wipe_copy = @Off
	}

	// バストショット表示情報取得
	$bs_disp_info(0)
	// バストショット表示情報初期化
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_name_info[0+L[0]] = ""
		$bs_name_info_prev[0+L[0]] = ""
	}

	// 表示
	if ($fade_wmnd == @Off)	{
		close
	}
	$wipe($bg_wipe[0])

	// CGテーブル by となぴょん
	if ($bg_name[0].left(2) == "EV" || $bg_name[0].left(2) == "BG")	{
//		@T_ＣＧ見た($bg_name[0])
	}
	if ($bg_name[0].left(2) == "EV")	{
		@CGDB登録($bg_name[0])
	}

}


/********************************************************
*														*
*				背景／イベントＣＧセット				*
*														*
*********************************************************/
#z01

command $bg_disp_set(property $dummy : int)
{
	// 背景表示判定
	$$bg_exist_decide
	// 背景情報取得
	$$bg_info
	// 表示準備
	$$bg_wipe_ready
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景表示判定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//#bg_exist_decide
#z02

command $$bg_exist_decide
{

	// 背景表示最大数
	for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
		$bg_exist_decide[0+L[0]] = $bg_name[0+L[0]].search("nothing")
	}
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景情報取得
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//#bg_info
#z03

command $$bg_info
{

	// 背景表示最大数
	for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
		// 背景判定
		if ($bg_name[0+L[0]].left(2) == "BG")	{
			// 背景
			$disp = _disp_bg
		}
		else	{
			// イベントＣＧ
			$disp = _disp_ev
		}
	}
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 表示準備
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//#bg_wipe_ready
#z04

command $$bg_wipe_ready
{

	// @fade重複トリガーを解除
	$fade_dup = @Off

	for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
		if ($bg_exist_decide[0+L[0]] != 0)	{
			// 背景ブラー判定
			if ($bg_blur[0+L[0]] == @On)	{
				K[0] = "bl_"
			}
			elseif (($bg_blur[0+L[0]] == @Off) || ($bg_name[0+L[0]].left(2) == "EV"))	{
				K[0] = ""
			}
			// 背景／イベントＣＧ表示[統合]
			if (($bg_type == _type_bg) || ($bg_type == _type_cg1))	{
				@b.obj[@OBJ_BG01+L[0]].create(K[0] + $bg_name[0+L[0]])
			}
			// イベントＣＧ表示[分割] CG2
			else	{
				@b.obj[@OBJ_BG01+L[0]].init
				@b.obj[@OBJ_BG01+L[0]].disp = @On
				@b.obj[@OBJ_BG01+L[0]].@cd.resize(2)
				// "evmh_01_"0101
				K[10] = $bg_name[0].left(8) + "base"
				K[11] = $bg_name[0].left(8) + "face"
				// evmh_01_"01"01
				K[12] = $bg_name[0].mid(8, 2)  L[12] = K[12].tonum
				// evmh_01_01"01"
				K[13] = $bg_name[0].mid(10, 2) L[13] = K[13].tonum
				// base
				@b.obj[@OBJ_BG01+L[0]].@cd[_ObjBgBase00].create(K[10])
				@b.obj[@OBJ_BG01+L[0]].@cd[_ObjBgBase00].disp = @On
				@b.obj[@OBJ_BG01+L[0]].@cd[_ObjBgBase00].patno = L[12] -1
				// face
				@b.obj[@OBJ_BG01+L[0]].@cd[_ObjBgFace00].create(K[11])
				@b.obj[@OBJ_BG01+L[0]].@cd[_ObjBgFace00].disp = @On
				@b.obj[@OBJ_BG01+L[0]].@cd[_ObjBgFace00].patno = L[13] -1
			}
			@b.obj[@OBJ_BG01+L[0]].x = $bg_posx_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].y = $bg_posy_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].tr = $bg_tr_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].layer = -10000
			@b.obj[@OBJ_BG01+L[0]].scale_x = $bg_scale_x_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].scale_y = $bg_scale_y_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].center_rep_x = $bg_center_rep_x_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].center_rep_y = $bg_center_rep_y_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].rotate_z = $bg_rotate_z_prev[0+L[0]]
			@b.obj[@OBJ_BG01+L[0]].disp = @On
//			@b.obj[@OBJ_BG01+L[0]].wipe_copy = @On

			if ($bg_type != _type_bg)	{
				// バストショット表示情報取得
				$bs_disp_info(0)
				// バストショット表示情報初期化
				for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
					$bs_name_info[0+L[0]] = ""
					$bs_name_info_prev[0+L[0]] = ""
				}
			}

			// CGテーブル by となぴょん 2013.04.03追加
			if ($bg_name[0+L[0]].left(2) == "EV" || $bg_name[0+L[0]].left(2) == "BG")	{
//				@T_ＣＧ見た($bg_name[0+L[0]])
			}
			if ($bg_name[0+L[0]].left(2) == "EV")	{
				@CGDB登録($bg_name[0+L[0]])
			}
		}
	}
}


/********************************************************
*														*
*			背景／イベントＣＧ表示（複数キャラ用）		*
*														*
*********************************************************/
command $bg_disp_sp(property $dummy : int)
{

	if (($bg_blur[0] == @Off) || ($bg_name[0].left(2) == "CG") || ($bg_name[0].left(2) == "EV"))	{
		K[0] = ""
	}
	// イベントＣＧ表示[分割] CG2
	@b.obj[@OBJ_BG01].init
	@b.obj[@OBJ_BG01].disp = @On
	@b.obj[@OBJ_BG01].layer = -10000
	@b.obj[@OBJ_BG01].@cd.resize(10)

	K[0] = $bg_name[0] + "_base"
	K[1] = $bg_name[0] + "_face01"
	K[2] = $bg_name[0] + "_face02"
	K[3] = $bg_name[0] + "_face03"

	// base
	@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].create(K[0])
	@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].layer = -10000
	@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].disp = @On
	@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].patno = $bg_base[0] -1
	@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].wipe_copy = @On
//	if (@主人公半透明状態 == @Off)	{
//		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].patno += 50
//	}


	// face01-09
	for (L[0] = 0, L[0] < 3, L[0] += 1)	{
		if ($bg_face[0+L[0]] != -9999)	{
			@b.obj[@OBJ_BG01].@cd[_ObjBgFace00+L[0]].create(K[1+L[0]])
			@b.obj[@OBJ_BG01].@cd[_ObjBgFace00+L[0]].layer = -10000
			@b.obj[@OBJ_BG01].@cd[_ObjBgFace00+L[0]].disp = @On
			@b.obj[@OBJ_BG01].@cd[_ObjBgFace00+L[0]].patno = $bg_face[0+L[0]] -1
			@b.obj[@OBJ_BG01].@cd[_ObjBgFace00+L[0]].wipe_copy = @On
//			if (@主人公半透明状態 == @Off)	{
//				@b.obj[@OBJ_BG01].@cd[_ObjBgFace00+L[0]].patno += 100
//			}
		}
	}

	// 背景／イベントＣＧ判定
	if ($bg_name[0].left(2) == "CG" || ($bg_name[0].left(2) == "EV"))	{
		$disp = _disp_ev
	}
	else	{
		$disp = _disp_bg
	}

	// bg_set初期化
	for (L[0] = 1, L[0] < @bg_maxnum, L[0] += 1)	{
		@f.obj[@OBJ_BG01+L[0]].wipe_copy = @Off
	}

	// 表示
	if ($fade_wmnd == @Off)	{
		close
	}
	$wipe($bg_wipe[0])

	if ($bg_name[0].left(2) == "CG")	{
		K[0] = math.tostr_zero($bg_base[0], 2)
		K[1] = math.tostr_zero($bg_face[0], 3)
		K[2] = math.tostr_zero($bg_face[1], 3)
		K[3] = math.tostr_zero($bg_face[2], 3)
//		@T_ＣＧ見た($bg_name[0] + "_" + K[0] + "_" + K[1] + "_" + K[2] + "_" + K[3])
		@CGDB登録($bg_name[0] + "_" + K[0] + "_" + K[1] + "_" + K[2] + "_" + K[3])
	}


}




//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景／イベントＣＧ表示
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_disp_in(property $bg_name0 : str, property $bg_wipe0 : int, property $wipe_wait0 : int, property $sys_wipe0 : int, property $fade_wmnd0 : int)
{

	$bg_name[0] = $bg_name0
	$bg_wipe[0] = $bg_wipe0
	$wipe_wait  = $wipe_wait0
	$sys_wipe   = $sys_wipe0
	$fade_wmnd  = $fade_wmnd0
	
	$$ef_bg_name_cutin_before	// k-takahashi 背景名表示追加
	
	$bg_disp(0)
	
	$$ef_bg_name_cutin			// k-takahashi 背景名表示追加
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景／イベントＣＧ表示[メッセージウィンドウワイプ]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_all_disp_in(property $bg_name0 : str, property $bg_wipe0 : int, property $wipe_wait0 : int, property $sys_wipe0 : int, property $fade_wmnd0 : int)
{

	$bg_name[0] = $bg_name0
	$bg_wipe[0] = $bg_wipe0
	$wipe_wait  = $wipe_wait0
	$sys_wipe   = $sys_wipe0
	$fade_wmnd  = $fade_wmnd0
	$bg_disp(0)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景／イベントＣＧ表示ＳＰ
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_disp_sp_in(property $bg_name0   : str,
                       property $bg_wipe0   : int,
                       property $wipe_wait0 : int,
                       property $sys_wipe0  : int,
                       property $fade_wmnd0 : int,
                       property $bg_base01  : int,
                       property $bg_face01  : int,
                       property $bg_face02  : int,
                       property $bg_face03  : int
                       )
{
	$bg_name[0] = $bg_name0
	$bg_wipe[0] = $bg_wipe0
	$wipe_wait  = $wipe_wait0
	$sys_wipe   = $sys_wipe0
	$fade_wmnd  = $fade_wmnd0

	$bg_base[0] = $bg_base01
	$bg_face[0] = $bg_face01
	$bg_face[1] = $bg_face02
	$bg_face[2] = $bg_face03
	$bg_disp_sp(0)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景／イベントＣＧ表示ＳＰ[メッセージウィンドウワイプ]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_all_disp_sp_in(property $bg_name0   : str,
                           property $bg_wipe0   : int,
                           property $wipe_wait0 : int,
                           property $sys_wipe0  : int,
                           property $fade_wmnd0 : int,
                           property $bg_base01  : int,
                           property $bg_face01  : int,
                           property $bg_face02  : int,
                           property $bg_face03  : int
                           )
{
	$bg_name[0] = $bg_name0
	$bg_wipe[0] = $bg_wipe0
	$wipe_wait  = $wipe_wait0
	$sys_wipe   = $sys_wipe0
	$fade_wmnd  = $fade_wmnd0

	$bg_base[0] = $bg_base01
	$bg_face[0] = $bg_face01
	$bg_face[1] = $bg_face02
	$bg_face[2] = $bg_face03
	$bg_disp_sp(0)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景／システム表示
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_bg_disp_in(property $bg_name0 : str, property $bg_wipe0 : int, property $wipe_wait0 : int, property $sys_wipe0 : int)
{

	$bg_name[0] = $bg_name0
	$bg_wipe[0] = $bg_wipe0
	$wipe_wait  = $wipe_wait0
	$sys_wipe   = $sys_wipe0
	$bg_disp(0)
}





