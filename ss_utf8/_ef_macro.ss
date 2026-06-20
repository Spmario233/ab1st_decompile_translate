//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_macro.ss
//	@author		Kazuya Takahashi
//	@note		演出マクロ置き場
//
//-----------------------------------------------------------------------------------------------

#inc_start
	
	#define		<EF_BF_MAX>					6
	#define		<OMV_OBJ_START_INDEX>		(@OBJ_EF_SCREEN20)
	#define		<OMV_OBJ_END_INDEX>			(@OBJ_EF_SCREEN30)
	
	#define		<EF_ANGEL_COPY_OBJ_NO1>		(@OBJ_EF_SCREEN25)
	#define		<EF_ANGEL_COPY_OBJ_NO2>		(@OBJ_EF_SCREEN26)
	
	#define		<EF_OBJ_LAYER>				100000
	
	#property	$bg_name_cutin_disp
	#property	$once_bg_name_cutin_disp
	
	#property	$recollect_bg_stack : str
	#property	$recollect_bs_stack : strlist[6]
	#property	$recollect_bs_posx_stack : intlist[6]
	
	#property	$bgm_stack : str
	
	#property	$bg_name_start_time
	
#inc_end

#z00

//-----------------------------------------------------------------
// オブジェクトの子供作成
//-----------------------------------------------------------------
command $$set_child_object(property $obj : object, property $num)
{
	$obj.disp = 1
	$obj.child.resize($num)
}

//-----------------------------------------------------------------
// g00の存在を判定する
//-----------------------------------------------------------------
command $$is_exist_g00(property $filename : str) : int
{
	return (system.check_file_exist("g00\\" + $filename + ".g00"))
}

//-----------------------------------------------------------------
// center_posを画像中心に設定する
//-----------------------------------------------------------------
command $$set_image_center(property $obj : object)
{
	$obj.set_center($obj.get_size_x / 2, $obj.get_size_y / 2)
}

//-----------------------------------------------------------------
// 拡縮イベントを設定する
//-----------------------------------------------------------------
command $$set_scale_eve(property $obj : object, property $src, property $dst, property $time, property $interep)
{
	$obj.set_scale($src, $src)
	$obj.scale_x_eve.set($dst, $time, 0, $interep)
	$obj.scale_y_eve.set($dst, $time, 0, $interep)
}

//-----------------------------------------------------------------
// 背景の位置自動設定
//-----------------------------------------------------------------
command $$ef_bg_set_autopos(property $filename : str) : str
{
	property $pos_x
	property $pos_y
	
	switch( $filename ) {
	case("ep01_bg035")	$pos_y = -59
	case("ep04_bg028")	$pos_y = -70
	}
	
	@bg_set($filename, 1, $pos_x, $pos_y)
}

//-----------------------------------------------------------------
// 背景の移動(相対)
//-----------------------------------------------------------------
command $$ef_bg_move(property $add_x, property $add_y, property $time, property $interep)
{
	property $i
	property $bg_x
	property $bg_y
	
	$bg_x = front.object[@OBJ_BG01].x
	$bg_y = front.object[@OBJ_BG01].y

	if( $add_x != 0 ) { front.object[@OBJ_BG01].x_eve.set($bg_x + $add_x, $time, 0, $interep) }
	if( $add_y != 0 ) { front.object[@OBJ_BG01].y_eve.set($bg_y + $add_y, $time, 0, $interep) }
}

//-----------------------------------------------------------------
// 背景、バストショットの移動(相対)
//-----------------------------------------------------------------
command $$ef_bgs_move(property $add_x, property $add_y, property $time, property $interep)
{
	property $i
	property $chr_min
	property $chr_max
	property $chr_x
	property $chr_y
	property $emo_index
	
	$$ef_bg_move($add_x, $add_y, $time, $interep)
	
	$chr_min = $$get_bs_obj_index(ot)
	$chr_max = $$get_bs_obj_index(k4)
	
	for( $i = $chr_min, $i < $chr_max, $i += 1 )
	{
		if( front.object[$i].disp )
		{
			$chr_x = front.object[$i].x
			$chr_y = front.object[$i].y
			if( $add_x != 0 ) { front.object[$i].x_eve.set($chr_x + $add_x, $time, 0, $interep) }
			if( $add_y != 0 ) { front.object[$i].y_eve.set($chr_y + $add_y, $time, 0, $interep) }
			
			// エモーションオブジェクト
			$emo_index = $i + 70
			if( front.object[$emo_index].disp )
			{
				$chr_x = front.object[$emo_index].x
				$chr_y = front.object[$emo_index].y
				if( $add_x != 0 ) { front.object[$emo_index].x_eve.set($chr_x + $add_x, $time, 0, $interep) }
				if( $add_y != 0 ) { front.object[$emo_index].y_eve.set($chr_y + $add_y, $time, 0, $interep) }
			}
		}
	}
}

//-----------------------------------------------------------------
// バストショット表情変更
//-----------------------------------------------------------------
command $$ef_change_bs(property name1 : str, property name2 : str, property name3 : str, property name4 : str, property name5 : str, property name6 : str)
{
	property $i
	property $j
	property $ef_bf_name : strlist[<EF_BF_MAX>]
	property $ef_bs_name : strlist[<EF_BF_MAX>]
	property $char_id : str
	
	$ef_bf_name[0] = name1
	$ef_bf_name[1] = name2
	$ef_bf_name[2] = name3
	$ef_bf_name[3] = name4
	$ef_bf_name[4] = name5
	$ef_bf_name[5] = name6
	
	for( $i = 0, $i < <EF_BF_MAX>, $i += 1 )
	{
		K[0] = $bs_name[$i]
		if( $i == 0 && $bs_exist_decide[$i] == -1 ) {
			K[0] = $cha_name_prev[$i]
		}
		
		if( K[0].search("nothing") != -1 ) {
			$ef_bs_name[$i] = "nothing"
		} else {
			$ef_bs_name[$i] = K[0]
		}
	}
	
	for( $i = 0, $i < <EF_BF_MAX>, $i += 1 )
	{
		if( $ef_bf_name[$i].search("nothing") != -1 ) {
			break
		}
		
		if( $ef_bf_name[$i].search("bs") == 0 ) {
			$char_id = $ef_bf_name[$i].mid(4, 2)
		} else {
			$char_id = $ef_bf_name[$i].mid(0, 2)
		}
		
		for( $j = 0, $j < <EF_BF_MAX>, $j += 1 )
		{
			K[0] = $bs_name[$j]
			if( $j == 0 && $bs_exist_decide[$j] == -1 ) {
				K[0] = $cha_name_prev[$j]
			}
			
			if( K[0].search("nothing") != -1 ) {
				continue
			}
			
			if( K[0].search($char_id) != -1 )
			{
				$ef_bs_name[$j] = $ef_bf_name[$i]
				
				if( $ef_bf_name[$i].search("bs") == -1 )
				{
					$ef_bs_name[$j] = K[0].left(4) + $ef_bf_name[$i]
				}
				
				break
			}
		}
		
		if( $j == <EF_BF_MAX> )
		{
;			system.debug_messagebox_ok("指定キャラクターが立っていません：" + $char_id + "\n左から" + math.tostr($i + 1) + "番目に表示します")
			
			$ef_bs_name[$i] = $ef_bf_name[$i]
		}
	}
	
	@bs($ef_bs_name[0], $ef_bs_name[1], $ef_bs_name[2], $ef_bs_name[3], $ef_bs_name[4], $ef_bs_name[5])
}

//-----------------------------------------------------------------
// バストショット名、距離の切り落とし
//-----------------------------------------------------------------
command $$ef_chop_bsname_range(property $bs_name : str) : str
{
	if( $bs_name.search("bs") == 0 ) {
		$bs_name = $bs_name.mid(4, $bs_name.cnt)
	}
	
	return ($bs_name)
}

//-----------------------------------------------------------------
// 回想用背景スタック
//-----------------------------------------------------------------
command $$ef_recollect_stack_push
{
	property $i
	
	$recollect_bg_stack = $bg_name[0]
	
	for( $i = 0, $i < 6, $i += 1 )
	{
		$recollect_bs_stack[$i] = $bs_name[$i]
		$recollect_bs_posx_stack[$i] = $bs_posx_next[$i]
	}
}

command $$ef_recollect_stack_pop
{
	property $i
	
	@bg_set($recollect_bg_stack)
	
	$recollect_bg_stack = ""
	
	for( $i = 0, $i < 6, $i += 1 )
	{
		if( $recollect_bs_stack[$i].search("nothing") == -1 )
		{
			@bs_set(-1, $recollect_bs_stack[$i], $recollect_bs_posx_stack[$i])
			
			$recollect_bs_stack[$i] = "nothing"
			$recollect_bs_posx_stack[$i] = 0
		}
	}
}

//-----------------------------------------------------------------
// BGMスタック
//-----------------------------------------------------------------
command $$ef_bgm_stack_push
{
	$bgm_stack = bgm.get_regist_name
}

command $$ef_bgm_stack_pop : str
{
	property $filename : str
	
	$filename = $bgm_stack
	$bgm_stack = ""
	
	return ($filename)
}

//-----------------------------------------------------------------
// 演出用OMVの作成
//-----------------------------------------------------------------
command $$ef_create_omv(property $stage : stage, property $filename : str, property $index, property $pos_x, property $pos_y, property $scale)
{
	$$ef_create_omv_core($stage.object[$$ef_get_omv_index($index)], $filename, 0, $pos_x, $pos_y, $scale)
}

command $$ef_create_omv_loop(property $stage : stage, property $filename : str, property $index, property $pos_x, property $pos_y, property $scale)
{
	$$ef_create_omv_core($stage.object[$$ef_get_omv_index($index)], $filename, 1, $pos_x, $pos_y, $scale)
}

command $$ef_create_omv_core(property $obj : object, property $filename : str, property $loop, property $pos_x, property $pos_y, property $scale)
{
	if( $loop ) {
		$obj.create_movie_loop($filename, 1, ready_only = 1)
	} else {
		$obj.create_movie($filename, 1, ready_only = 1)
	}
	$obj.set_scale($scale, $scale)
	$obj.set_pos($pos_x, $pos_y)
	$obj.layer = -30
	$obj.resume_movie
}

//-----------------------------------------------------------------
// 演出用OMVオブジェクトインデックスの取得
//-----------------------------------------------------------------
command $$ef_get_omv_index(property $index) : int
{
	return (<OMV_OBJ_START_INDEX> + $index)
}

//-----------------------------------------------------------------
// エモーションオブジェクトのインデックスを取得
//-----------------------------------------------------------------
command $$ef_get_emo_index(property $chr : str) : int
{
	return($$get_bs_obj_index($chr) + 70)
}

//-----------------------------------------------------------------
// CG4(knハンドソニック用に特化)
//-----------------------------------------------------------------
command $$ef_cg4(property $name : str)
{
	property $obj_index
	// property $base_patno  : str
	property $body_patno  : str
	property $face1_patno : str
	property $face2_patno : str
	
	// $base_patno = $name.mid(8, 1)
	$body_patno = $name.mid(9, 1)
	$face1_patno = $name.mid(11, 2)
	$face2_patno = $name.mid(13, 2)
	
	$obj_index = $$ef_get_omv_index(0)
	
	back.object[L[0]].init
	$$set_child_object(back.object[L[0]], 4)
	
	// back.object[L[0]].child[0].create($name.left(8) + "base",  1, 0, 0, $base_patno.tonum)
	back.object[L[0]].child[1].create($name.left(8) + "body",  1, 0, 0, $body_patno.tonum)
	if( $body_patno.tonum > 4 )
	{
		back.object[L[0]].child[2].create($name.left(8) + "face1", 1, 0, 0, $face1_patno.tonum)
		back.object[L[0]].child[3].create($name.left(8) + "face2", 1, 0, 0, $face2_patno.tonum)
	}
	else
	{
		back.object[L[0]].child[2].create($name.left(8) + "face1", 1, 0, 0, $face1_patno.tonum - 1)
		back.object[L[0]].child[3].create($name.left(8) + "face2", 1, 0, 0, $face2_patno.tonum - 1)
	}
}

//-----------------------------------------------------------------
// CG4(evcm_18)
//-----------------------------------------------------------------
command $$ef_get_cg1801_name(property $name : str) : str
{
	property $index
	property $pat : str
	property $diff
	
	if( @歯が飛んでまともに話せない ) { $index = 2 }
	elseif( @一度殴られて歯が飛んだ ) { $index = 1 }
	
	$pat = $name.right(1)
	$diff = $pat.tonum + $index
	
	return ($name.left($name.cnt - 1) + math.tostr($diff))
}

//-----------------------------------------------------------------
// ミニカットイン
//-----------------------------------------------------------------
command $$ef_mini_cutin_show(property $obj : object, property $filename : str)
{
	$obj.create($filename, 1, @screen_center_x, @screen_center_y)
	$obj.tr = 0
	$obj.tr_eve.set(255, 750, 0, 2)
	$obj.y_eve.set(@screen_center_y - 70, 750, 0, 2)
	
;	$obj.child.resize($obj.child.get_size + 1)
;	$obj.child[$obj.child.get_size - 1].blend = 1
;	$obj.child[$obj.child.get_size - 1].create(ef_sss_logo, 1, $obj.child[1].x - 400, $obj.child[1].y, 1)
;	$obj.child[$obj.child.get_size - 1].x_eve.set($obj.child[1].x + 400, 750, 300, 0)
}

command $$ef_mini_cutin_hide(property $obj : object)
{
	$obj.y_eve.set(@screen_center_y - 140, 750, 0, 2)
}

//-----------------------------------------------------------------
// ギルドトラップ(レーザー)
//-----------------------------------------------------------------
command $$ef_create_guild_trap_laser(property $obj : object, property $type)
{
	property $child_num
	
	switch( $type ) {
	case(0)		$child_num = 1
	case(1)		$child_num = 2
	case(2)		$child_num = 4
	}
	
	$$set_child_object($obj, $child_num)
	$obj.set_center(@SCREEN_CENTER_X, @SCREEN_CENTER_Y)
	$obj.set_pos(0, -100)
	$obj.layer = -30
	$obj.wipe_copy = 1
	
	switch( $type ) {
	case(0)					// 1本
		$$ef_create_guild_trap_laser_core($obj.child[0], 0, 0)
		
	case(1)					// 2本
		$$ef_create_guild_trap_laser_core($obj.child[0], 0, -120)
		$$ef_create_guild_trap_laser_core($obj.child[1], 0, 120)
		
	case(2)					// X
		$$ef_create_guild_trap_laser_core($obj.child[0], 150, 0)
		$$ef_create_guild_trap_laser_core($obj.child[1], -150, 0)
		$$ef_create_guild_trap_laser_core($obj.child[2], 0, -200)
		$$ef_create_guild_trap_laser_core($obj.child[3], 0, 200)
	}
}

command $$ef_create_guild_trap_laser_core(property $obj : object, property $rot, property $add_y)
{
	$obj.create_movie_loop(ef_gtrap_laser00, 1, ready_only = 1)
	$obj.set_center($obj.get_size_x / 2, $obj.get_size_y / 2)
	$obj.set_pos(@SCREEN_CENTER_X, @SCREEN_CENTER_Y + $add_y)
	$obj.rotate_z = $rot
	$obj.resume_movie
}

//-----------------------------------------------------------------
// ハンマートラップ用eve
//-----------------------------------------------------------------
command $$ef_trap_rot_eve(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get % 4000
	
	$obj.rotate_z = math.timetable(l[0], 0, 0, [0, 1000, -20, 2], 
												[1000, 2000, 0, 1],
												[2000, 3000, 20, 2],
												[3000, 4000, 0, 1])
}

//-----------------------------------------------------------------
// 天使ディレイの発動
//-----------------------------------------------------------------
command $$ef_angel_delay_start
{
	property $obj_index
	
	$obj_index = $$get_bs_obj_index(bs1_kn0101)
	
	if( front.object[$obj_index].disp == 0 )
	{
		return
	}
	
	property $kn_x
	property $kn_y
	
	$kn_x = front.object[$obj_index].x
	$kn_y = front.object[$obj_index].y
	
	$$ef_angel_set_object(front.object[<EF_ANGEL_COPY_OBJ_NO1>], $obj_index, 255, 255, 255, 128)
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].tr = 0
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].x_eve.turn($kn_x + 6, $kn_x - 6, 1000, 0, 2)
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].tr_eve.set(24, 500, 0, 2)
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].scale_x_eve.turn(1010, 1000, 3000, 0, 0)
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].scale_y_eve.turn(1010, 1000, 3000, 0, 0)
	
	$$ef_angel_set_object(front.object[<EF_ANGEL_COPY_OBJ_NO2>], $obj_index, 255, 255, 255, 128)
	front.object[<EF_ANGEL_COPY_OBJ_NO2>].tr = 0
	front.object[<EF_ANGEL_COPY_OBJ_NO2>].y_eve.turn($kn_y + 6, $kn_y - 6, 1000, 0, 2)
	front.object[<EF_ANGEL_COPY_OBJ_NO2>].tr_eve.set(36, 500, 0, 2)
}

//-----------------------------------------------------------------
// 天使ディレイで避ける
//-----------------------------------------------------------------
command $$ef_angel_delay_avoid(property $ef_name : str, property $add_pos)
{
	property $obj_index
	
	$obj_index = $$get_bs_obj_index($ef_name)
	
	if( front.object[$obj_index].disp == 0 ) {
		return
	}
	
	if( $ef_name.search("bs") == -1 )
	{
		$ef_name = "bs2_" + $ef_name
	}
	
	property $i
	property $kn_x
	property $kn_y
	property $omv_name : strlist[2]
	property $omv_y
	property $diff_no : str
	
	$kn_x = front.object[$obj_index].x
	$kn_y = front.object[$obj_index].y
	$diff_no = "0"
	
	if( $cha_name_prev[0].mid(4, 1) == "a") {
		$diff_no = "1"
	}
	
	switch( $cha_name_prev[0].mid(0, 4) + $cha_name_prev[0].mid(6, 2) ) {
	case("bs1_01")	$omv_name[0] = "ef_gs_bs1_dl" + $diff_no + "1"
					$omv_name[1] = "ef_gs_bs1_dl02"
	case("bs1_03")	$omv_name[0] = "ef_gs_bs1_dl" + $diff_no + "3"
					$omv_name[1] = "ef_gs_bs1_dl04"
	case("bs1_09")	$omv_name[0] = "ef_gs_bs1_dl" + $diff_no + "5"
					$omv_name[1] = "ef_gs_bs1_dl06"
	case("bs1_12")	$omv_name[0] = "ef_gs_bs1_dl" + $diff_no + "7"
					$omv_name[1] = "ef_gs_bs1_dl08"
	case("bs2_01")	$omv_name[0] = "ef_gs_bs2_dl" + $diff_no + "1"
					$omv_name[1] = "ef_gs_bs2_dl02"
	case("bs2_03")	$omv_name[0] = "ef_gs_bs2_dl" + $diff_no + "3"
					$omv_name[1] = "ef_gs_bs2_dl04"
	case("bs2_09")	$omv_name[0] = "ef_gs_bs2_dl" + $diff_no + "5"
					$omv_name[1] = "ef_gs_bs2_dl06"
	case("bs2_12")	$omv_name[0] = "ef_gs_bs2_dl" + $diff_no + "7"
					$omv_name[1] = "ef_gs_bs2_dl08"
	}
	
	switch( $cha_name_prev[0].mid(2, 1) ) {
	case("1")	$omv_y = -79
	case("2")	$omv_y = -79
	}
	
	for( $i = 0, $i < 2, $i += 1 )
	{
		L[0] = $$ef_get_omv_index($i)
		
		$$ef_create_omv(front, $omv_name[$i], $i, 0, 0, 1000)
		
		front.object[L[0]].x = $kn_x
		front.object[L[0]].y = $omv_y
		front.object[L[0]].center_x = front.object[L[0]].get_size_x / 2
		front.object[L[0]].layer = 1000 + $i
		front.object[L[0]].blend = 1
		front.object[L[0]].wipe_copy = 1
		
		if( $omv_name[$i] == "ef_gs_bs2_dl08" ) {
			front.object[L[0]].y += 50
		}
	}
	
	// 残像
	$$ef_angel_set_object(front.object[<EF_ANGEL_COPY_OBJ_NO1>], $obj_index, 0, 0, 0, 0)
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].tr = 150
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].layer = -1
	front.object[<EF_ANGEL_COPY_OBJ_NO1>].x_eve.set($kn_x + $add_pos, 750, 0, 2)

	$$ef_angel_set_object(front.object[<EF_ANGEL_COPY_OBJ_NO2>], $obj_index, 0, 0, 0, 0)
	front.object[<EF_ANGEL_COPY_OBJ_NO2>].tr = 50
	front.object[<EF_ANGEL_COPY_OBJ_NO2>].layer = -2
	front.object[<EF_ANGEL_COPY_OBJ_NO2>].x_eve.set($kn_x + $add_pos, 1000, 0, 2)
}

command $$ef_angel_set_object(property $obj : object, property $obj_index, property $add_r, property $add_g, property $add_b, property $rate)
{
	$obj.create_copy_from(front.object[$obj_index])
	$obj.color_add_r = $add_r
	$obj.color_add_g = $add_g
	$obj.color_add_b = $add_b
	$obj.color_rate  = $rate
}

//-----------------------------------------------------------------
// 天使ディストーション
//-----------------------------------------------------------------
command $$ef_angel_guard
{
	property $bs_file : str
	property $bs_range : str
	property $bs_direction : str
	property $src_obj_index
	property $bs_center_x
	property $bs_center_y
	property $bs_x
	property $bs_y
	property $omv_file1 : str
	property $omv_file2 : str
	property $i
	property $index
	property $diff_no
	
	$diff_no = 01
	if( front.object[$$get_bs_obj_index(kn)].disp ) {
		$src_obj_index = $$get_bs_obj_index(kn)
		if( @ＮＰＣ制服_ボロボロ == @かなで服装 ) {
			$diff_no = 03
		}
	}
	if( front.object[$$get_bs_obj_index(a1)].disp ) {
		$src_obj_index = $$get_bs_obj_index(a1)
		$diff_no = 10
	}
	if( front.object[$$get_bs_obj_index(a2)].disp ) {
		$src_obj_index = $$get_bs_obj_index(a2)
		$diff_no = 10
	}
	
	$bs_file = front.object[$src_obj_index].child[0].get_file_name
	$bs_x = front.object[$src_obj_index].x
	$bs_y = front.object[$src_obj_index].y
	
	$bs_range = $bs_file.mid(2, 1)
	$bs_direction = $bs_file.mid(9, 1)
	
	if( $bs_direction.tonum < 9 )
	{
		$omv_file1 = "ef_gs_bs" + $bs_range + "_dt" + math.tostr_zero($diff_no, 2)
		$omv_file2 = "ef_gs_bs" + $bs_range + "_dt02"
		
		switch( $bs_range ) {
		case("1")	$bs_center_x = 257	$bs_center_y = 112		// bs1_0101
		case("2")	$bs_center_x = 347	$bs_center_y = 219		// bs2_0101
		}
	}
	else
	{
		if( $diff_no == 10 ) { $diff_no += 2 }
		else { $diff_no += 4 }
		
		$omv_file1 = "ef_gs_bs" + $bs_range + "_dt" + math.tostr_zero($diff_no, 2)
		$omv_file2 = "ef_gs_bs" + $bs_range + "_dt06"
		
		switch( $bs_range ) {
		case("1")	$bs_center_x = 286	$bs_center_y = 98		// bs1_0109
		case("2")	$bs_center_x = 427	$bs_center_y = 201		// bs2_0109
		}
	}
	
	$$ef_create_omv(front, $omv_file1, 0, $bs_x, $bs_y, 1000)
	$$ef_create_omv(front, $omv_file2, 1, $bs_x, $bs_y, 1000)
	front.object[$$ef_get_omv_index(1)].blend = 1
	
	for( $i = 0, $i < 2, $i += 1 )
	{
		$index = $$ef_get_omv_index($i)
		
		front.object[$index].set_center($bs_center_x - (front.object[$src_obj_index].child[0].get_size_x - front.object[$index].get_size_x) / 2, $bs_center_y)
		front.object[$index].layer = 1000
		front.object[$index].set_movie_auto_free(1)
		front.object[$index].tonecurve_no = $bg_time_set
	}
}

//-----------------------------------------------------------------
// キャッキャウフフ
//-----------------------------------------------------------------
#inc_start
	#property	$kyakya_level				// 現在のレベル
	#property	$kyakya_level_cap			// レベルキャップ
	#define		<KYAKYA_LEVEL_MAX>		6	// エフェクト最大レベル
#inc_end

command $$add_kyakya_level
{
	$kyakya_level += 1
}

command $$add_kyakya_level_cap
{
	$kyakya_level_cap += 1
	if( $kyakya_level_cap > <KYAKYA_LEVEL_MAX> ) {
		$kyakya_level_cap = <KYAKYA_LEVEL_MAX>
	}
}

command $$get_kyakya_level : int
{
	property $cap
	
//	$cap = $kyakya_level_cap
	$cap = <KYAKYA_LEVEL_MAX>
	
	if( $kyakya_level > $cap )
	{
		return ($cap)
	}
	
	return ($kyakya_level)
}

command $$kyakya_ufufu
{
	property $i
	property $no : intlist[5]
	
	for( $i = 0, $i < 5, $i += 1 ) {
		$no[$i] = $$ef_get_omv_index($i)
	}
	
	property $level
	property $back_filter_tr
	property $front_filter_tr
	property $omv_tr
	property $omv_color_rate
	
	$level = $$get_kyakya_level
	
	$back_filter_tr  = math.limit(0, (128 / <KYAKYA_LEVEL_MAX>) * $level, 128)
	$front_filter_tr = math.limit(0, (100 / <KYAKYA_LEVEL_MAX>) * $level, 100)
	$omv_tr          = math.limit(0, (255 / <KYAKYA_LEVEL_MAX>) * ($level + 1), 255)
	$omv_color_rate  = math.limit(0, (255 / <KYAKYA_LEVEL_MAX>) * (<KYAKYA_LEVEL_MAX> - $level), 255)
	
	
	back.object[$no[0]].create("ef_hn_" + $bg_name[0], 1)
	back.object[$no[0]].set_scale(1200, 1200)
	back.object[$no[0]].set_center_rep(800, 450)
	back.object[$no[0]].wipe_copy = 1
	
	$$ef_create_omv_loop(back, ef_hn_ku03, 1, 0, 0, 2000)
	back.object[$no[1]].wipe_copy = 1
	back.object[$no[1]].blend = 1
	back.object[$no[1]].color_r = 255
	back.object[$no[1]].color_g = 255
	back.object[$no[1]].color_b = 255

	$$ef_create_omv_loop(back, ef_hn_ku02, 2, 0, 0, 2000)
	back.object[$no[2]].wipe_copy = 1
	back.object[$no[2]].blend = 1
	back.object[$no[2]].layer = 1000
	back.object[$no[2]].color_r = 255
	back.object[$no[2]].color_g = 255
	back.object[$no[2]].color_b = 255
	
	back.object[$no[3]].create(ef_hn_ku01, 1)
	back.object[$no[3]].wipe_copy = 1
	back.object[$no[3]].blend = 4
	back.object[$no[3]].layer = 1100
	back.object[$no[3]].tr = 100
	
	back.object[$no[4]].create(ef_hn_ku01, 1)
	back.object[$no[4]].wipe_copy = 1
	back.object[$no[4]].blend = 4
	back.object[$no[4]].layer = 0
	back.object[$no[4]].tr = 100
	
	back.object[$no[1]].color_rate = $omv_color_rate
	back.object[$no[2]].color_rate = $omv_color_rate
	
	back.object[$no[1]].tr = $omv_tr
	back.object[$no[2]].tr = $omv_tr
	back.object[$no[3]].tr = $front_filter_tr
	back.object[$no[4]].tr = $back_filter_tr
}

command $$kyakya_ufufu_end
{
	property $i
	
	for( $i = 1, $i < 5, $i += 1 ) {
		front.object[$$ef_get_omv_index($i)].wipe_copy = 0
	}
}

//-----------------------------------------------------------------
// 直井過去『…死んだのはお前だ』
//-----------------------------------------------------------------
command $$ef_rec_na01(property $type, property $msg : str, property $koe_no, property $chara_no, property $namae : str)
{
	property $obj_index1
	property $obj_index2
	property $pat_no1
	property $pat_no2
	
	$obj_index1 = $$ef_get_omv_index(0)
	$obj_index2 = $$ef_get_omv_index(1)
	
	if( $type )
	{
		$pat_no1 = 3
		$pat_no2 = 2
	}
	else
	{
		$pat_no1 = 1
		$pat_no2 = 0
	}
	
	back.object[$obj_index1].create(ef_rec_na01, 1, 0, 0, $pat_no1)
	back.object[$obj_index1].wipe_copy = 1
	@wipe(250)
	@timewaitkey(750)
	
	if( $type ) {
		msgbk.go_next_msg					// メッセージを１つ進める
	}
	
	if( $chara_no != - 1 )
	{
		KOE($koe_no, $chara_no)
		msgbk.add_koe($koe_no, $chara_no)	// 声を設定
		msgbk.add_namae($namae)				// 名前を設定
	}
	
	msgbk.add_msg($msg)					// メッセージを設定
	if( $type == 0 ) {
		msgbk.go_next_msg					// メッセージを１つ進める
	}
	
	back.object[$obj_index2].create(ef_rec_na01, 1, @screen_center_x, @screen_center_y, $pat_no2)
	$$set_image_center(back.object[$obj_index2])
	back.object[$obj_index2].set_scale(1200, 1200)
	back.object[$obj_index2].bright = 255
	back.object[$obj_index2].bright_eve.set(0, 1000, 0, 1)
	back.object[$obj_index2].scale_x_eve.set(1000, 1000, 0, 0)
	back.object[$obj_index2].scale_y_eve.set(1000, 1000, 0, 0)
	@wipe(2)
	
	front.object[$obj_index1].wipe_copy = 0
	
	if( $type ) { @timewaitkey(3000) }
	else		{ koe_wait_key }
	
	front.object[$obj_index2].scale_x_eve.set(0, 2000, 0, 1)
	front.object[$obj_index2].scale_y_eve.set(0, 2000, 0, 1)
	front.object[$obj_index2].tr_eve.set(0, 1000, 0, 2)
	
	if( $type ) { @fade(bg_kuro, 3) }
	else		{ @fade(bg_siro, 3) }
}

//-----------------------------------------------------------------
// 音無称号
//-----------------------------------------------------------------
command $$ef_otonashi_title(property $type) : int
{
	if( $$ef_otonashi_syougou_start(front.object[<OMV_OBJ_END_INDEX> - 2], $type) == -1 )
	{
		return		// 不正な値
	}
	
	$$ef_otonashi_title_bg
	close
	@pcmch_play(0, se_fanfare)
	@pcmch_wait_key(0)
	
	@pcmch_stop(0, 2000)
	$$ef_otonashi_syougou_end(front.object[<OMV_OBJ_END_INDEX> - 2])
	$$ef_otonashi_title_bg_end
	@timewaitkey(2000)
	
;	$wipe_wait = 1
;	@wipe(0)
}

command $$ef_otonashi_syougou_start(property $obj : object, property $type) : int
{
	property $str : str
	property $i
	property $str_cnt
	property $str_line
	property $work_cnt
	property $line_str : strlist[1]
	
	switch( $type ) {
	case(@ただのエロ少年と呼ぶ)			$str = "ただのエロ少年にレベルアップした！"
	case(@エロ侍と呼ぶ)					$str = "エロ侍にクラスチェンジした！"
	case(@エロエロ団ナンバー１と呼ぶ)	$str = "エロエロ団を結成した！"
	case(@ユリブサイクと呼ぶ)			$str = "日向がユリブサイクを習得した！"
	case(@アメリカンエロドッグと呼ぶ)	$str = "アメリカンエロドッグに進化した！"
	case(@ゼウスと呼ぶ)					$str = "ゼウスにクラスチェンジした！　もう、誰にも彼は止められない…"
	case(@日向markⅡと呼ぶ)				$str = "日向markⅡにレベルアップした！"
	case(@糞虫と呼ぶ)					$str = "糞虫に降格した！"
	case(@量産型日向と呼ぶ)				$str = "量産型日向にレベルアップした！"
	case(999)							$str = "エロいのは重々承知だが、十字架を背負って暮らして行く決心をした！"
	default		return(-1)
	}
	
	$obj.init
	$$set_child_object($obj, 5)
	$obj.set_pos(@SCREEN_CENTER_X - 1, @SCREEN_CENTER_Y)
	$obj.layer = <EF_OBJ_LAYER>
	
	$obj.set_scale(5000, 5000)
	$obj.scale_x_eve.set(1000, 1200, 0, 1)
	$obj.scale_y_eve.set(1000, 1200, 0, 1)
	$obj.color_r = 255
	$obj.color_g = 255
	$obj.color_b = 255
	$obj.color_rate = 255
	$obj.color_rate_eve.set(0, 2000, 0, 1)
	
	$obj.y_rep.resize(2)
	$obj.y_rep[0] = -75
//	$obj.y_rep_eve[0].set(-75, 1000, 0, 0)
	
	$obj.tr_rep.resize(2)
//	$obj.tr_rep[0] = 0
//	$obj.tr_rep_eve[0].set(255, 1000, 0, 0)
	
	// 背景
	$obj.child[0].create(ef_syougou_bg, 1, 0, 0, 2)
	$obj.child[1].create(ef_syougou_bg, 1, 0, 0, 3)
	$obj.child[2].create(ef_syougou_bg, 1, -640, 0, 0)
	$obj.child[3].create(ef_syougou_bg, 1,  640, 0, 1)
	
	$obj.child[2].x_eve.set(0, 2000, 0, 2)
	$obj.child[2].x_rep.resize(1)
	$obj.child[3].x_eve.set(0, 2000, 0, 2)
	$obj.child[3].x_rep.resize(1)
	
	for( $i = 1, $i < 4, $i += 1 )
	{
		$obj.child[$i].color_r = 255
		$obj.child[$i].color_g = 255
		$obj.child[$i].color_b = 255
		$obj.child[$i].color_rate_eve.turn(0, 160, 750, 0, 2)
	}
	
	// 文字
	$str_cnt  = $str.cnt
	$str_line = 1
	$work_cnt = 0
	for( $i = 0, $i < $str_cnt, $i += 1 )
	{
		if( $i < $str_cnt - 1 )
		{
			// 改行コード
			if( $str.mid($i, 1) == "#" && $str.mid($i + 1, 1) == "D" )
			{
				L[1] = $work_cnt
				$work_cnt = $i - $work_cnt
				if( $str_line > 1 ) { L[1] += 2 }
				
				$line_str[$line_str.get_size - 1] = $str.mid(L[1], $work_cnt)
				$line_str.resize($line_str.get_size + 1)
				
				$str_line += 1
			}
		}
	}
	
	if( $str_line == 1 ) {
		$line_str[0] = $str
	} else {
		L[1] = $work_cnt
		$work_cnt = $i - $work_cnt
		if( $str_line > 1 ) { L[1] += 2 }
		$line_str[$line_str.get_size - 1] = $str.mid(L[1], $work_cnt)
	}
	
	$$set_child_object($obj.child[4], $str_line)
	
	for( $i = 0, $i < $str_line, $i += 1 )
	{
		$obj.child[4].child[$i].create_string("", 1, $obj.get_size_x / 2, 8 + 24 * $i)
		$obj.child[4].child[$i].set_center($obj.get_size_x / 2, $obj.get_size_y / 2)
		$obj.child[4].child[$i].set_string_param(24, 0, 0, 0, 0, 1, -1, 1)
		
		$obj.child[4].child[$i].set_string($line_str[$i])
		
		$obj.child[4].child[$i].x -= ($line_str[$i].cnt / 2) * 24
		if( ($line_str[$i].cnt % 2) ) { $obj.child[4].child[$i].x -= 12 }
		$obj.child[4].child[$i].y -= ($str_line - 1) * 12
	}
}

command $$ef_otonashi_syougou_end(property $obj : object)
{
	$obj.y_rep_eve[1].set(-75, 1000, 0, 0)
	$obj.tr_rep_eve[1].set(  0, 1000, 0, 0)
	$obj.child[2].x_rep_eve[0].set( 1280, 5000, 0, 0)
	$obj.child[3].x_rep_eve[0].set(-1280, 5000, 0, 0)
}

command $$ef_otonashi_title_bg
{
	L[1] = 12
	
	$$set_child_object(front.object[@OBJ_EF_SCREEN29], L[1])
	
	front.object[@OBJ_EF_SCREEN29].layer = 0
	front.object[@OBJ_EF_SCREEN29].tr = 96
	front.object[@OBJ_EF_SCREEN29].color_r = 255
	front.object[@OBJ_EF_SCREEN29].color_g = 255
	front.object[@OBJ_EF_SCREEN29].color_b = 255
	front.object[@OBJ_EF_SCREEN29].color_rate = 0
	front.object[@OBJ_EF_SCREEN29].color_rate_eve.turn(0, 192, 1250, 0, 0)
	front.object[@OBJ_EF_SCREEN29].tr_eve.turn(96, 192, 1250, 0, 0)
	front.object[@OBJ_EF_SCREEN29].set_pos(0, -50)
	
	for( L[0] = 0, L[0] < L[1], L[0] += 1 )
	{
		front.object[@OBJ_EF_SCREEN29].child[L[0]].create(ef_syougou_filter, 1)
		front.object[@OBJ_EF_SCREEN29].child[L[0]].set_pos(@screen_center_x, @screen_center_y)
		front.object[@OBJ_EF_SCREEN29].child[L[0]].scale_x = 0
		front.object[@OBJ_EF_SCREEN29].child[L[0]].scale_y = 0
		front.object[@OBJ_EF_SCREEN29].child[L[0]].scale_x_eve.set(1000, 500, L[0] % 3 * 50, 2)
		front.object[@OBJ_EF_SCREEN29].child[L[0]].scale_y_eve.set(1000, 500, L[0] % 3 * 50, 2)
		front.object[@OBJ_EF_SCREEN29].child[L[0]].rotate_z = 3600 / L[1] * L[0]
		front.object[@OBJ_EF_SCREEN29].child[L[0]].rotate_z_eve.set(3600 + 3600 / L[1] * L[0], 30000, 0, 0)
	}
}

command $$ef_otonashi_title_bg_end
{
	L[1] = front.object[@OBJ_EF_SCREEN29].child.get_size
	
	for( L[0] = 0, L[0] < L[1], L[0] += 1 )
	{
		front.object[@OBJ_EF_SCREEN29].child[L[0]].scale_x_eve.set(0, 500, 0, 2)
		front.object[@OBJ_EF_SCREEN29].child[L[0]].scale_y_eve.set(0, 500, 0, 2)
	}
}

//-----------------------------------------------------------------
// ワイプ時間の取得
//-----------------------------------------------------------------
command $$ef_get_wipe_time(property $wipe_no) : int
{
	switch( $wipe_no ) {		// 暫定処理
	case(0)		L[0] = 250
	case(1)		L[0] = 100
	case(2)		L[0] = 500
	case(3)		L[0] = 1000
	case(4)		L[0] = 1500
	case(5)		L[0] = 2000
	case(20)	L[0] = 500
	case(21)	L[0] = 1000
	case(22)	L[0] = 1500
	case(23)	L[0] = 2000
	case(24)	L[0] = 500
	case(25)	L[0] = 1000
	case(26)	L[0] = 1500
	case(27)	L[0] = 2000
	case(30)	L[0] = 500
	case(31)	L[0] = 1000
	case(32)	L[0] = 1500
	case(33)	L[0] = 2000
	case(34)	L[0] = 500
	case(35)	L[0] = 1000
	case(36)	L[0] = 1500
	case(37)	L[0] = 2000
	case(140)	L[0] = 500
	case(141)	L[0] = 1000
	case(142)	L[0] = 1500
	case(143)	L[0] = 2000
	case(144)	L[0] = 500
	case(145)	L[0] = 1000
	case(146)	L[0] = 1500
	case(147)	L[0] = 2000
	case(150)	L[0] = 500
	case(151)	L[0] = 1000
	case(152)	L[0] = 1500
	case(153)	L[0] = 2000
	case(154)	L[0] = 500
	case(155)	L[0] = 1000
	case(156)	L[0] = 1500
	case(157)	L[0] = 2000
	}
	
	return (L[0])
}

//-----------------------------------------------------------------
// 背景名の表示の有効/無効設定
//-----------------------------------------------------------------
command $$ef_bg_name_set_enabled(property $flag)
{
	$bg_name_cutin_disp = $flag
}

//-----------------------------------------------------------------
// 背景名表示イベントの発行
//-----------------------------------------------------------------
command $$ef_bg_name_cutin_event
{
	$once_bg_name_cutin_disp = 1
}

//-----------------------------------------------------------------
// 背景名の表示
//-----------------------------------------------------------------
command $$ef_bg_name_cutin_before
{
	if( front.object[<OMV_OBJ_END_INDEX>].wipe_copy )
	{
		front.object[<OMV_OBJ_END_INDEX>].tr_eve.set(0, 300, 0, 0)
	}
}

command $$ef_bg_name_cutin
{
	if( @SpotDispState == 0 ) {
		return
	}
	
	if( $bg_name_cutin_disp == 1 ) {
		return
	}
	
	front.object[<OMV_OBJ_END_INDEX>].wipe_copy = 0
	
	if( $once_bg_name_cutin_disp ) {
		$$ef_bg_name_cutin_core(front.object[<OMV_OBJ_END_INDEX>])
	}
	
	$once_bg_name_cutin_disp = 0
}

command $$ef_bg_name_cutin_core(property $obj : object)
{
	property $size
	property $patno
	
	$patno = $$get_bg_name_cutin_pat($bg_name[0])
	if( $patno == -1 ) {
		return
	}
	
	$obj.init
	$obj.create(ef_bg_name_cutin, 1, 0, 0, $patno)
	$obj.layer = <EF_OBJ_LAYER>
	$obj.wipe_copy = 1
	
	$size = $obj.get_size_x
	
	$obj.set_pos(-$size, 57)
	$obj.tr_rep.resize(2)
	$obj.tr_rep[0] = 0
	
	$obj.x_eve.set(0, 800, $bg_name_start_time, 2)
	$obj.tr_rep_eve[0].set(255, 800, $bg_name_start_time, 0)
	$obj.tr_rep_eve[1].set(0, 800, $bg_name_start_time + 4000, 2)
	
	$bg_name_start_time = 0
}

command $$set_bg_name_start_time(property $time)
{
	$bg_name_start_time = $time
}

command $$get_bg_name_cutin_pat(property $bg_name : str)
{
	property $no
	
	switch( $bg_name ) {
	case("ep01_bg053")	$no = 1			// 戦線本部
	case("ep01_bg057")	$no = 1
	case("ep04_bg003")	$no = 1
	case("ep01_bg046")	$no = 1
	case("ep01_bg048")	$no = 1
	case("ep88_bg003")	$no = 1
	case("ep01_bg077")	$no = 1
	case("ep09_bg004")	$no = 1
	case("ep03_bg004")	$no = 1
	
	case("ep04_bg024")	$no = 2			// 学園屋上
	case("ep04_bg025")	$no = 2
	case("ep04_bg026")	$no = 2
	case("ep04_bg027")	$no = 2
	case("ep04_bg023")	$no = 2
	case("ep88_bg002")	$no = 2
	case("ep01_bg066")	$no = 2
	case("ep01_bg067")	$no = 2
	case("ep01_bg068")	$no = 2
	case("ep01_bg073")	$no = 2
	case("ep01_bg074")	$no = 2
	case("ep01_bg075")	$no = 2
	case("ep07_bg024")	$no = 2
	case("ep07_bg025")	$no = 2
	case("ep07_bg026")	$no = 2
	
	case("ep09_bg002")	$no = 3			// 教員棟
	case("ep03_bg001")	$no = 3
	case("ep09_bg002")	$no = 3
	
	case("ep01_bg039")	$no = 4			// 第二連絡橋
	case("ep04_bg021")	$no = 4
	case("ep07_bg035")	$no = 4
	case("ep01_bg072")	$no = 4
	case("ep01_bg084")	$no = 4
	case("ep01_bg085")	$no = 4
	case("ep01_bg086")	$no = 4
	case("ep01_bg092")	$no = 4
	case("ep01_bg093")	$no = 4
	case("ep01_bg094")	$no = 4
	case("ep01_bg095")	$no = 4
	case("ep01_bg096")	$no = 4
	case("ep01_bg097")	$no = 4
	case("ep08_bg006")	$no = 4
	case("ep08_bg007")	$no = 4
	case("ep08_bg008")	$no = 4
	
	case("ep01_bg082")	$no = 5			// 大食堂
	case("ep06_bg015")	$no = 5
	case("ep88_bg020")	$no = 5
	case("ep05_bg047")	$no = 5
	
	case("ep99_bg001")	$no = 6			// 学生寮
	case("ep99_bg002")	$no = 6
	case("ep99_bg003")	$no = 6
	case("ep10_bg013")	$no = 6
	
	case("ep04_bg022")	$no = 7			// 第２連絡橋 橋の下
	case("ep03_bg006")	$no = 7
	case("ep07_bg038")	$no = 7
	
	case("ep04_bg009")	$no = 8			// 森の中
	case("ep04_bg008")	$no = 8
	
	case("ep88_bg024")	$no = 9			// 体育館
	case("ep05_bg028")	$no = 9
	case("ep09_bg022")	$no = 9
	case("ep02_bg005")	$no = 9
	case("ep03_bg029")	$no = 9
	case("ep03_bg047")	$no = 9
	case("ep05_bg029")	$no = 9
	case("ep05_bg030")	$no = 9
	case("ep09_bg023")	$no = 9
	case("ep88_bg012")	$no = 9
	case("ep02_bg006")	$no = 9
	case("ep02_bg007")	$no = 9
	case("ep02_bg008")	$no = 9
	case("ep02_bg009")	$no = 9
	case("ep08_bg015")	$no = 9
	case("ep08_bg016")	$no = 9
	case("ep11_bg016")	$no = 9
	case("ep03_bg030")	$no = 9
	case("ep03_bg038")	$no = 9
	case("ep03_bg039")	$no = 9
	case("ep03_bg040")	$no = 9
	case("ep03_bg041")	$no = 9
	case("ep03_bg042")	$no = 9
	case("ep03_bg043")	$no = 9
	case("ep03_bg044")	$no = 9
	case("ep03_bg049")	$no = 9
	
	case("ep88_bg023")	$no = 10		// 大階段
	case("ep01_bg070")	$no = 10
	case("ep01_bg008")	$no = 10
	case("ep01_bg020")	$no = 10
	case("ep01_bg021")	$no = 10
	
	case("ep03_bg018")	$no = 11		// 運動場
	case("ep04_bg029")	$no = 11
	case("ep88_bg010")	$no = 11
	case("ep01_bg065")	$no = 11
	case("ep07_bg045")	$no = 11
	case("ep07_bg046")	$no = 11
	case("ep07_bg047")	$no = 11
	case("ep07_bg048")	$no = 11
	case("ep88_bg015")	$no = 11
	case("ep01_bg013")	$no = 11
	case("ep01_bg022")	$no = 11
	case("ep01_bg023")	$no = 11
	case("ep01_bg024")	$no = 11
	case("ep01_bg025")	$no = 11
	case("ep01_bg026")	$no = 11
	case("ep01_bg027")	$no = 11
	case("ep03_bg048")	$no = 11
	
	case("ep88_bg025")	$no = 12		// 大浴場
	
	case("ep11_bg003")	$no = 13		// 学習棟渡り廊下
	
	case("ep02_bg015")	$no = 14		// ギルド連絡通路B1
	case("ep02_bg017")	$no = 15		// ギルド連絡通路B3	
	case("ep02_bg021")	$no = 16		// ギルド連絡通路B6
	case("ep02_bg031")	$no = 17		// ギルド連絡通路B8
	case("ep88_bg060")	$no = 17
	case("ep02_bg032")	$no = 18		// ギルド連絡通路B9
	case("ep02_bg040")	$no = 19		// ギルド連絡通路B15
	case("ep02_bg047")	$no = 20		// ギルド連絡通路B17
	case("ep02_bg057")	$no = 21		// ギルド最深部
	
	case("ep08_bg020")	$no = 22		// ギルド連絡通路B4
	
	default				$no = -1
//	default				system.debug_messagebox_ok($bg_name + "：背景名表示用の文字パターンがありません")		$no = -1
	}
	
	return ($no)
}

#inc_start
	
	#define		<OP_BGM_NAME>				HeartilySong
	
#inc_end

//---------------------------------------------------------------------------
//	ムービー再生
//---------------------------------------------------------------------------
command $$play_movie(property $filename : str, property $flag) : int
{
	@set_title("")
	
	@bgm_stop
	@pcm_stop
	@pcmch_stop_all
	
	$$user_control_disabled

	if( $flag )
	{
		mov.play_wait_key($filename)
	}
	else
	{
		mov.play_wait($filename)
	}

	bgmtable.set_listen_by_name(<OP_BGM_NAME>, 1)
	
	$$user_control_enabled

	return (1)
}

command $$user_control_enabled
{
	syscom.set_syscom_menu_enable			// システムコマンドを許可する
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを許可する
	script.set_mouse_disp_on				// マウスカーソルを表示する
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_shortcut_enable				// ショートカットを許可する
	script.set_ctrl_skip_enable				// 早送りを許可する
}

command $$user_control_disabled
{
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	script.set_mouse_disp_off				// マウスカーソルを非表示にする
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	script.set_ctrl_skip_disable			// 早送りを禁止する
}

//---------------------------------------------------------------------------
//	体験版告知
//---------------------------------------------------------------------------
command $$trial_end
{
	$$user_control_disabled
	
	syscom.set_syscom_menu_disable
	script.set_ctrl_skip_disable

	@force_fade(bg_siro, 2)
	bgm.play(<OP_BGM_NAME>, start_pos=4650000, fade_in_time=1000, loop=1)
;	@bgm_play(<OP_BGM_NAME>)
	@timewaitkey(1000)

	back.object[0].create(trial_end, 1)
	wipe(0, 2000)
	@timewaitkey(12000)
	
	back.object[0].create(trial_end, 1, 0, 0, 1)
	wipe(0, 750)
	@timewaitkey(10500)

	@bgm_stop(5000)
	@force_fade(bg_siro, 5)
	@timewaitkey(1000)
	@force_fade(bg_kuro, 3)
	@timewaitkey(1000)

	script.set_ctrl_skip_enable
	$$user_control_enabled
}

//---------------------------------------------------------------------------
//	evcm_41
//---------------------------------------------------------------------------
command $$evcm41_disp(property $dummy : int, property $disp_type)
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
	
/*	// 背景／イベントＣＧ表示[統合]
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
		// "evmh_01_"0101
		K[0] = $bg_name[0].left(8) + "base"
		K[1] = $bg_name[0].left(8) + "face"
		// evmh_01_"01"01
		K[2] = $bg_name[0].mid(8, 2)  L[2] = K[2].tonum
		// evmh_01_01"01"
		K[3] = $bg_name[0].mid(10, 2) L[3] = K[3].tonum
		// base
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].create(K[0])
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].layer = -10000
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].disp = @On
		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].patno = L[2] -1
//		@b.obj[@OBJ_BG01].@cd[_ObjBgBase00].wipe_copy = @On
		// face
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].create(K[1])
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].layer = -10000
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].disp = @On
		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].patno = L[3] -1
//		@b.obj[@OBJ_BG01].@cd[_ObjBgFace00].wipe_copy = @On
	}
*/
	
	// evcm_41処理
	$$set_child_object(@b.obj[@OBJ_BG01], 2)
	@b.obj[@OBJ_BG01].child[0].create(K[0] + $bg_name[0], 1)
	@b.obj[@OBJ_BG01].child[1].create(K[0] + $bg_name[0], 1, 0, 0, 1)
	@b.obj[@OBJ_BG01].y = $$get_cm41_pos(@b.obj[@OBJ_BG01], $disp_type)
	
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

	// CGテーブル by となぴょん
	if ($bg_name[0].left(2) == "EV" || $bg_name[0].left(2) == "BG")	{
//		@T_ＣＧ見た($bg_name[0])
	}
	if ($bg_name[0].left(2) == "EV")	{
		@CGDB登録($bg_name[0])
	}

}

command $$evcm41_scroll(property $obj : object, property $disp_type, property $time, property $interep)
{
	$obj.y_eve.set($$get_cm41_pos($obj, $disp_type), $time, 0, $interep)
}

command $$get_cm41_pos(property $obj : object, property $disp_type) : int
{
	property $pos_y
	
	switch( $disp_type ) {
	case(@CM41_DISP_TYPE_TOP)			$pos_y = 0
	case(@CM41_DISP_TYPE_BOTTOM)		$pos_y = -($obj.child[1].get_size_y - @screen_height)
	case(@CM41_DISP_TYPE_CENTER)		$pos_y = -($obj.child[1].get_size_y - @screen_height) / 2
	case(@CM41_DISP_TYPE_HALF_TOP)		$pos_y = -($obj.child[1].get_size_y - @screen_height) / 4
	case(@CM41_DISP_TYPE_HALF_BOTTOM)	$pos_y = -($obj.child[1].get_size_y - @screen_height) / 4 * 3
	default								$pos_y = 0
	}
	
	return ($pos_y)
}


//-----------------------------------------------------------------
// ランダムフラッシュを設定する
//-----------------------------------------------------------------
command $$create_filter_random_flash(property $tr_min, property $tr_max, property $time_min, property $time_max)
{
	property $obj_index

	$obj_index = $$ef_get_omv_index(5)
	
	back.object[$obj_index].create_rect(0, 0, @SCREEN_WIDTH, @SCREEN_HEIGHT, 255, 255, 255, 255, 1)
	back.object[$obj_index].wipe_copy = 1

	$$fa_flicker_set(back.object[$obj_index], 100, $tr_min, $tr_max, $time_min, $time_max)
	back.object[$obj_index].frame_action.start(-1, "$$fa_flicker")
	
	back.object[$obj_index].layer = 120
}

command $$fa_flicker_set(property $obj : object, property $frequency,
						 property $tr_min, property $tr_max, property $time_min, property $time_max)
{
	$obj.tr = $tr_min

	$obj.f.resize(6)
	$obj.f[0] = 0			// flicker_flag
	$obj.f[1] = $frequency
	$obj.f[2] = $tr_min
	$obj.f[3] = $tr_max
	$obj.f[4] = $time_min
	$obj.f[5] = $time_max
}

command $$fa_flicker(property $fa : frameaction, property $obj : object)
{
	if( math.rand(0, 999) < $obj.f[1] )
	{
		if( $obj.f[0] )
		{
			$obj.tr = $obj.f[2]
		}
		else
		{
			$obj.tr_eve.set($obj.f[3], math.rand($obj.f[4], $obj.f[5]), 0, 0)
		}

		$obj.f[0] = $$reverse_flag($obj.f[0])
	}
}

command $$reverse_flag(property $flag) : int
{
	return (math.abs($flag - 1))
}
