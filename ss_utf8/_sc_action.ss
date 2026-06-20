/********************************************************
*														*
*			バストショットアクションセット				*
*														*
*********************************************************/
#z00

/*
#inc_start

	#define		$$bs_cha_num			L[0]
	#define		$$bs_action				K[0]
	#define		$$bs_maxnum				L[1]
	#define		$$bs_bkft				L[2]
	#define		$$bs_action_num			L[3]
	#define		$$bs_action_time		L[4]
	#define		$$bs_action_end_time	L[5]

#inc_end
*/

command $bs_action_set0(property $$bs_cha_num         : int,
                        property $$bs_action          : str,
                        property $$bs_maxnum          : int,
                        property $$bs_bkft            : int,
                        property $$bs_action_num      : int,
                        property $$bs_action_time     : int,
                        property $$bs_action_end_time : int)
{


	// アクション指定無し
	if ($$bs_action == "")	{
		return
	}

	$bs_action[$$bs_maxnum]          = $$bs_action
	$bs_action_time[$$bs_maxnum]     = $$bs_action_time
	$bs_action_end_time[$$bs_maxnum] = $$bs_action_end_time

	// back/front
	if	($$bs_bkft == 0)	{
		// back
		@b.obj[$$bs_cha_num].x_rep.resize(3)
		@b.obj[$$bs_cha_num].y_rep.resize(3)
		@b.obj[$$bs_cha_num].frame_action_ch.resize(4)
		@b.obj[$$bs_cha_num].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                            $bs_action_posx_next[$$bs_maxnum],
		                                                            $bs_action_posy_next[$$bs_maxnum],
		                                                            $bs_action_tr_next[$$bs_maxnum],
		                                                            $chara_tr_prev[$$bs_cha_num],
		                                                            $bs_action_scale_x_next[$$bs_maxnum],
		                                                            $bs_action_scale_y_next[$$bs_maxnum],
		                                                            $chara_scale_x_prev[$$bs_cha_num],
		                                                            $chara_scale_y_prev[$$bs_cha_num],
		                                                            $bs_action_rotate_z_next[$$bs_maxnum],
		                                                            $chara_rotate_z_prev[$$bs_cha_num],
		                                                            $bs_action_time[$$bs_maxnum],
		                                                            $bs_action[$$bs_maxnum],
		                                                            $bs_action_posx[$$bs_maxnum],
		                                                            $bs_action_posy[$$bs_maxnum],
		                                                            $bs_action_mod[$$bs_maxnum])

		// エモーション01
		@b.obj[$$bs_cha_num+@OBJ_EMO01].x_rep.resize(3)
		@b.obj[$$bs_cha_num+@OBJ_EMO01].y_rep.resize(3)
		@b.obj[$$bs_cha_num+@OBJ_EMO01].frame_action_ch.resize(4)
		@b.obj[$$bs_cha_num+@OBJ_EMO01].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                                            $bs_action_posx_next[$$bs_maxnum],
		                                                                            $bs_action_posy_next[$$bs_maxnum],
		                                                                            $bs_action_tr_next[$$bs_maxnum],
		                                                                            $chara_tr_prev[$$bs_cha_num],
		                                                                            $bs_action_scale_x_next[$$bs_maxnum],
		                                                                            $bs_action_scale_y_next[$$bs_maxnum],
		                                                                            $chara_scale_x_prev[$$bs_cha_num],
		                                                                            $chara_scale_y_prev[$$bs_cha_num],
		                                                                            $bs_action_rotate_z_next[$$bs_maxnum],
		                                                                            $chara_rotate_z_prev[$$bs_cha_num],
		                                                                            $bs_action_time[$$bs_maxnum],
		                                                                            $bs_action[$$bs_maxnum],
		                                                                            $bs_action_posx[$$bs_maxnum],
		                                                                            $bs_action_posy[$$bs_maxnum],
		                                                                            $bs_action_mod[$$bs_maxnum])
		// エモーション02
		@b.obj[$$bs_cha_num+@OBJ_EMO02].x_rep.resize(3)
		@b.obj[$$bs_cha_num+@OBJ_EMO02].y_rep.resize(3)
		@b.obj[$$bs_cha_num+@OBJ_EMO02].frame_action_ch.resize(4)
		@b.obj[$$bs_cha_num+@OBJ_EMO02].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                                            $bs_action_posx_next[$$bs_maxnum],
		                                                                            $bs_action_posy_next[$$bs_maxnum],
		                                                                            $bs_action_tr_next[$$bs_maxnum],
		                                                                            $chara_tr_prev[$$bs_cha_num],
		                                                                            $bs_action_scale_x_next[$$bs_maxnum],
		                                                                            $bs_action_scale_y_next[$$bs_maxnum],
		                                                                            $chara_scale_x_prev[$$bs_cha_num],
		                                                                            $chara_scale_y_prev[$$bs_cha_num],
		                                                                            $bs_action_rotate_z_next[$$bs_maxnum],
		                                                                            $chara_rotate_z_prev[$$bs_cha_num],
		                                                                            $bs_action_time[$$bs_maxnum],
		                                                                            $bs_action[$$bs_maxnum],
		                                                                            $bs_action_posx[$$bs_maxnum],
		                                                                            $bs_action_posy[$$bs_maxnum],
		                                                                            $bs_action_mod[$$bs_maxnum])
/*
		// エモーション03
		@b.obj[$$bs_cha_num+@OBJ_EMO03].x_rep.resize(3)
		@b.obj[$$bs_cha_num+@OBJ_EMO03].y_rep.resize(3)
		@b.obj[$$bs_cha_num+@OBJ_EMO03].frame_action_ch.resize(4)
		@b.obj[$$bs_cha_num+@OBJ_EMO03].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                                            $bs_action_posx_next[$$bs_maxnum],
		                                                                            $bs_action_posy_next[$$bs_maxnum],
		                                                                            $bs_action_tr_next[$$bs_maxnum],
		                                                                            $chara_tr_prev[$$bs_cha_num],
		                                                                            $bs_action_scale_x_next[$$bs_maxnum],
		                                                                            $bs_action_scale_y_next[$$bs_maxnum],
		                                                                            $chara_scale_x_prev[$$bs_cha_num],
		                                                                            $chara_scale_y_prev[$$bs_cha_num],
		                                                                            $bs_action_rotate_z_next[$$bs_maxnum],
		                                                                            $chara_rotate_z_prev[$$bs_cha_num],
		                                                                            $bs_action_time[$$bs_maxnum],
		                                                                            $bs_action[$$bs_maxnum],
		                                                                            $bs_action_posx[$$bs_maxnum],
		                                                                            $bs_action_posy[$$bs_maxnum],
		                                                                            $bs_action_mod[$$bs_maxnum])
*/
	}
	else{
		// front
		@f.obj[$$bs_cha_num].x_rep.resize(3)
		@f.obj[$$bs_cha_num].y_rep.resize(3)
		@f.obj[$$bs_cha_num].frame_action_ch.resize(4)
		@f.obj[$$bs_cha_num].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                            $bs_action_posx_next[$$bs_maxnum],
		                                                            $bs_action_posy_next[$$bs_maxnum],
		                                                            $bs_action_tr_next[$$bs_maxnum],
		                                                            $chara_tr_prev[$$bs_cha_num],
		                                                            $bs_action_scale_x_next[$$bs_maxnum],
		                                                            $bs_action_scale_y_next[$$bs_maxnum],
		                                                            $chara_scale_x_prev[$$bs_cha_num],
		                                                            $chara_scale_y_prev[$$bs_cha_num],
		                                                            $bs_action_rotate_z_next[$$bs_maxnum],
		                                                            $chara_rotate_z_prev[$$bs_cha_num],
		                                                            $bs_action_time[$$bs_maxnum],
		                                                            $bs_action[$$bs_maxnum],
		                                                            $bs_action_posx[$$bs_maxnum],
		                                                            $bs_action_posy[$$bs_maxnum],
		                                                            $bs_action_mod[$$bs_maxnum])
		// エモーション01
		@f.obj[$$bs_cha_num+@OBJ_EMO01].x_rep.resize(3)
		@f.obj[$$bs_cha_num+@OBJ_EMO01].y_rep.resize(3)
		@f.obj[$$bs_cha_num+@OBJ_EMO01].frame_action_ch.resize(4)
		@f.obj[$$bs_cha_num+@OBJ_EMO01].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                                             $bs_action_posx_next[$$bs_maxnum],
		                                                                             $bs_action_posy_next[$$bs_maxnum],
		                                                                             $bs_action_tr_next[$$bs_maxnum],
		                                                                             $chara_tr_prev[$$bs_cha_num],
		                                                                             $bs_action_scale_x_next[$$bs_maxnum],
		                                                                             $bs_action_scale_y_next[$$bs_maxnum],
		                                                                             $chara_scale_x_prev[$$bs_cha_num],
		                                                                             $chara_scale_y_prev[$$bs_cha_num],
		                                                                             $bs_action_rotate_z_next[$$bs_maxnum],
		                                                                             $chara_rotate_z_prev[$$bs_cha_num],
		                                                                             $bs_action_time[$$bs_maxnum],
		                                                                             $bs_action[$$bs_maxnum],
		                                                                             $bs_action_posx[$$bs_maxnum],
		                                                                             $bs_action_posy[$$bs_maxnum],
		                                                                             $bs_action_mod[$$bs_maxnum])
		// エモーション02
		@f.obj[$$bs_cha_num+@OBJ_EMO02].x_rep.resize(3)
		@f.obj[$$bs_cha_num+@OBJ_EMO02].y_rep.resize(3)
		@f.obj[$$bs_cha_num+@OBJ_EMO02].frame_action_ch.resize(4)
		@f.obj[$$bs_cha_num+@OBJ_EMO02].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                                             $bs_action_posx_next[$$bs_maxnum],
		                                                                             $bs_action_posy_next[$$bs_maxnum],
		                                                                             $bs_action_tr_next[$$bs_maxnum],
		                                                                             $chara_tr_prev[$$bs_cha_num],
		                                                                             $bs_action_scale_x_next[$$bs_maxnum],
		                                                                             $bs_action_scale_y_next[$$bs_maxnum],
		                                                                             $chara_scale_x_prev[$$bs_cha_num],
		                                                                             $chara_scale_y_prev[$$bs_cha_num],
		                                                                             $bs_action_rotate_z_next[$$bs_maxnum],
		                                                                             $chara_rotate_z_prev[$$bs_cha_num],
		                                                                             $bs_action_time[$$bs_maxnum],
		                                                                             $bs_action[$$bs_maxnum],
		                                                                             $bs_action_posx[$$bs_maxnum],
		                                                                             $bs_action_posy[$$bs_maxnum],
		                                                                             $bs_action_mod[$$bs_maxnum])
/*
		// エモーション03
		@f.obj[$$bs_cha_num+@OBJ_EMO03].x_rep.resize(3)
		@f.obj[$$bs_cha_num+@OBJ_EMO03].y_rep.resize(3)
		@f.obj[$$bs_cha_num+@OBJ_EMO03].frame_action_ch.resize(4)
		@f.obj[$$bs_cha_num+@OBJ_EMO03].frame_action_ch[$$bs_action_num].start($bs_action_end_time[$$bs_maxnum], "$bs_action_start",
		                                                                             $bs_action_posx_next[$$bs_maxnum],
		                                                                             $bs_action_posy_next[$$bs_maxnum],
		                                                                             $bs_action_tr_next[$$bs_maxnum],
		                                                                             $chara_tr_prev[$$bs_cha_num],
		                                                                             $bs_action_scale_x_next[$$bs_maxnum],
		                                                                             $bs_action_scale_y_next[$$bs_maxnum],
		                                                                             $chara_scale_x_prev[$$bs_cha_num],
		                                                                             $chara_scale_y_prev[$$bs_cha_num],
		                                                                             $bs_action_rotate_z_next[$$bs_maxnum],
		                                                                             $chara_rotate_z_prev[$$bs_cha_num],
		                                                                             $bs_action_time[$$bs_maxnum],
		                                                                             $bs_action[$$bs_maxnum],
		                                                                             $bs_action_posx[$$bs_maxnum],
		                                                                             $bs_action_posy[$$bs_maxnum],
		                                                                             $bs_action_mod[$$bs_maxnum])
*/
	}

}

/********************************************************
*														*
*				背景／イベントＣＧ準備					*
*														*
*********************************************************/
command $bg_set(property $bg_name0 : str,
                property $wait     : int,
                property $pos_x    : int,
                property $pos_y    : int,
                property $tr       : int,
                property $patno    : int,
                property $scale_x  : int,
                property $scale_y  : int,
                property $rotate   : int,
                property $center_x : int,
                property $center_y : int) : int
{
	switch ($bg_disp_cnt)	{
		case (0) $bg_name[0] = $bg_name0 $bg_name[1] = "nothing" $bg_name[2] = "nothing" $bg_name[3] = "nothing" $bg_name[4] = "nothing" $bg_name[5] = "nothing" $bg_name[6] = "nothing" $bg_name[7] = "nothing" $bg_name[8] = "nothing"
		case (1) $bg_name[1] = $bg_name0
		case (2) $bg_name[2] = $bg_name0
		case (3) $bg_name[3] = $bg_name0
		case (4) $bg_name[4] = $bg_name0
		case (5) $bg_name[5] = $bg_name0
		case (6) $bg_name[6] = $bg_name0
		case (7) $bg_name[7] = $bg_name0
		case (8) $bg_name[8] = $bg_name0


	}
//	if ($bg_blur[$bg_disp_cnt] == @On)	{
//		$bg_name[$bg_disp_cnt] = "b_" + $bg_name0
//	}
	$wipe_wait = $wait
	$bg_posx_prev[$bg_disp_cnt] = $pos_x
	$bg_posy_prev[$bg_disp_cnt] = $pos_y
	$bg_tr_prev[$bg_disp_cnt] = $tr
	$bg_patno_prev[$bg_disp_cnt] = $patno
	$bg_scale_x_prev[$bg_disp_cnt] = $scale_x * 10
	$bg_scale_y_prev[$bg_disp_cnt] = $scale_y * 10
	$bg_center_rep_x_prev[$bg_disp_cnt] = $center_x
	$bg_center_rep_y_prev[$bg_disp_cnt] = $center_y
	$bg_rotate_z_prev[$bg_disp_cnt] = $rotate * 10
	$disp = _disp_bg
	$bg_disp_cnt += 1
	$bg_set_ready = @On

	// CGテーブル by となぴょん 2013.04.04追加
	for (L[0] = 0, L[0] < 9, L[0] += 1)	{
		if ($bg_name[0+L[0]].left(2) == "EV" || $bg_name[0+L[0]].left(2) == "BG")	{
//			@T_ＣＧ見た($bg_name[0+L[0]])
		}
		if ($bg_name[0+L[0]].left(2) == "EV")	{
			@CGDB登録($bg_name[0+L[0]])
		}
	}
	
	$$ef_bg_name_cutin	// k-takahashi 背景名表示追加
}


/********************************************************
*														*
*		背景／イベントＣＧアクションセット[座標]		*
*														*
*********************************************************/
command $bg_pos_event(property $bg_num    : int,
                      property $time      : int,
                      property $pos_x     : int,
                      property $pos_y     : int,
                      property $pos_delay : int,
                      property $speed_mod : int) : int
{
	$bg_posx_next[$bg_num] = $pos_x
	$bg_posy_next[$bg_num] = $pos_y
	$bg_action_time[$bg_num] = $time
	$bg_action_time_delay[$bg_num] = $pos_delay
	$bg_action_speed_mod[$bg_num] = $speed_mod
	$bg_action_end_time[$bg_num] = $bg_action_time[$bg_num]
	$bg_action_end_time[$bg_num] += $pos_delay

	// ※
	@b.obj[@OBJ_BG01+$bg_num].create_copy_from(@f.obj[@OBJ_BG01+$bg_num])

	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch[0].start($bg_action_end_time[$bg_num], "$bg_action_start01",
	                                                        $bg_posx_prev[$bg_num],
	                                                        $bg_posy_prev[$bg_num],
	                                                        $bg_posx_next[$bg_num],
	                                                        $bg_posy_next[$bg_num],
	                                                        $bg_action_time[$bg_num],
	                                                        $bg_action_time_delay[$bg_num],
	                                                        $bg_action_speed_mod[$bg_num])

	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch[0].start($bg_action_end_time[$bg_num], "$bg_action_start01",
	                                                         $bg_posx_prev[$bg_num],
	                                                         $bg_posy_prev[$bg_num],
	                                                         $bg_posx_next[$bg_num],
	                                                         $bg_posy_next[$bg_num],
	                                                         $bg_action_time[$bg_num],
	                                                         $bg_action_time_delay[$bg_num],
	                                                         $bg_action_speed_mod[$bg_num])


}

/********************************************************
*														*
*	背景／イベントＣＧアクションセット[不透明度]		*
*														*
*********************************************************/
command $bg_tr_event(property $bg_num    : int,
                     property $time      : int,
                     property $tr        : int,
                     property $tr_delay  : int,
                     property $speed_mod : int) : int
{
	$bg_tr_next[$bg_num] = $tr
	$bg_action_time[$bg_num] = $time
	$bg_action_time_delay[$bg_num] = $tr_delay
	$bg_action_speed_mod[$bg_num] = $speed_mod
	$bg_action_end_time[$bg_num] = $bg_action_time[$bg_num]
	$bg_action_end_time[$bg_num] += $tr_delay

	// ※
	@b.obj[@OBJ_BG01+$bg_num].create_copy_from(@f.obj[@OBJ_BG01+$bg_num])

	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch[1].start($bg_action_end_time[$bg_num], "$bg_action_start02",
	                                                        $bg_tr_prev[$bg_num],
	                                                        $bg_tr_next[$bg_num],
	                                                        $bg_action_time[$bg_num],
	                                                        $bg_action_time_delay[$bg_num],
	                                                        $bg_action_speed_mod[$bg_num])

	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch[1].start($bg_action_end_time[$bg_num], "$bg_action_start02",
	                                                         $bg_tr_prev[$bg_num],
	                                                         $bg_tr_next[$bg_num],
	                                                         $bg_action_time[$bg_num],
	                                                         $bg_action_time_delay[$bg_num],
	                                                         $bg_action_speed_mod[$bg_num])
}

/********************************************************
*														*
*	背景／イベントＣＧアクションセット[拡大／縮小]		*
*														*
*********************************************************/
command $bg_sc_event(property $bg_num      : int,
                     property $time        : int,
                     property $scale_x     : int,
                     property $scale_y     : int,
                     property $scale_delay : int,
                     property $speed_mod   : int) : int
{
	$bg_scale_x_next[$bg_num] = $scale_x * 10
	$bg_scale_y_next[$bg_num] = $scale_y * 10
	$bg_action_time[$bg_num] = $time
	$bg_action_time_delay[$bg_num] = $scale_delay
	$bg_action_speed_mod[$bg_num] = $speed_mod
	$bg_action_end_time[$bg_num] = $bg_action_time[$bg_num]
	$bg_action_end_time[$bg_num] += $scale_delay

	// ※
	@b.obj[@OBJ_BG01+$bg_num].create_copy_from(@f.obj[@OBJ_BG01+$bg_num])

	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch[2].start($bg_action_end_time[$bg_num], "$bg_action_start03",
	                                                        $bg_scale_x_prev[$bg_num],
	                                                        $bg_scale_y_prev[$bg_num],
	                                                        $bg_scale_x_next[$bg_num],
	                                                        $bg_scale_y_next[$bg_num],
	                                                        $bg_action_time[$bg_num],
	                                                        $bg_action_time_delay[$bg_num],
	                                                        $bg_action_speed_mod[$bg_num])

	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch[2].start($bg_action_end_time[$bg_num], "$bg_action_start03",
	                                                         $bg_scale_x_prev[$bg_num],
	                                                         $bg_scale_y_prev[$bg_num],
	                                                         $bg_scale_x_next[$bg_num],
	                                                         $bg_scale_y_next[$bg_num],
	                                                         $bg_action_time[$bg_num],
	                                                         $bg_action_time_delay[$bg_num],
	                                                         $bg_action_speed_mod[$bg_num])
}

/********************************************************
*														*
*		背景／イベントＣＧアクションセット[回転]		*
*														*
*********************************************************/
command $bg_ro_event(property $bg_num      : int,
                     property $time        : int,
                     property $rotate_loop : int,
                     property $rotate_z    : int,
                     property $scale_delay : int,
                     property $speed_mod   : int) : int
{
	$bg_rotate_z_next[$bg_num] = $rotate_z * 10
	$bg_rotate_loop[$bg_num] = $rotate_loop
	$bg_action_time[$bg_num] = $time
	$bg_action_time_delay[$bg_num] = $scale_delay
	$bg_action_speed_mod[$bg_num] = $speed_mod
	if ($rotate_loop == @On)	{
		// 回転ループ
		$bg_action_end_time[$bg_num] = -1
	}
	else	{
		// 回転単発
		$bg_action_end_time[$bg_num] = $bg_action_time[$bg_num]
		$bg_action_end_time[$bg_num] += $bg_action_time_delay[$bg_num]
	}

	// ※
	@b.obj[@OBJ_BG01+$bg_num].create_copy_from(@f.obj[@OBJ_BG01+$bg_num])

	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@b.obj[@OBJ_BG01+$bg_num].frame_action_ch[3].start($bg_action_end_time[$bg_num], "$bg_action_start04",
	                                                        $bg_rotate_loop[$bg_num],
	                                                        $bg_rotate_z_prev[$bg_num],
	                                                        $bg_rotate_z_next[$bg_num],
	                                                        $bg_action_time[$bg_num],
	                                                        $bg_action_time_delay[$bg_num],
	                                                        $bg_action_speed_mod[$bg_num])

	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch.resize(4)
	@f.obj[@OBJ_BG01+$bg_num].frame_action_ch[3].start($bg_action_end_time[$bg_num], "$bg_action_start04",
	                                                         $bg_rotate_loop[$bg_num],
	                                                         $bg_rotate_z_prev[$bg_num],
	                                                         $bg_rotate_z_next[$bg_num],
	                                                         $bg_action_time[$bg_num],
	                                                         $bg_action_time_delay[$bg_num],
	                                                         $bg_action_speed_mod[$bg_num])
}

/********************************************************
*														*
*		背景／イベントＣＧアクションセット[パターン]	*
*														*
*********************************************************/
command $bg_pat_event(property $bg_num      : int,
                      property $time        : int,
                      property $patno       : int,
                      property $patno_delay : int,
                      property $speed_mod   : int) : int

{
	$bg_patno_next[$bg_num] = $patno
	$bg_action_time[$bg_num] = $time
	$bg_action_end_time[$bg_num] = $bg_action_time[$bg_num]

	// ※
	@b.obj[@OBJ_BG01+$bg_num].create_copy_from(@f.obj[@OBJ_BG01+$bg_num])

	@b.obj[@OBJ_BGXX+$bg_num].frame_action_ch.resize(5)
	@b.obj[@OBJ_BGXX+$bg_num].frame_action_ch[4].start($bg_action_end_time[$bg_num], "$bg_action_start05",
	                                                        $bg_patno_prev[$bg_num],
	                                                        $bg_patno_next[$bg_num],
	                                                        $bg_action_time[$bg_num],
	                                                        $bg_action_time_delay[$bg_num],
	                                                        $bg_action_speed_mod[$bg_num])


	@f.obj[@OBJ_BGXX+$bg_num].frame_action_ch.resize(5)
	@f.obj[@OBJ_BGXX+$bg_num].frame_action_ch[4].start($bg_action_end_time[$bg_num], "$bg_action_start05",
	                                                         $bg_patno_prev[$bg_num],
	                                                         $bg_patno_next[$bg_num],
	                                                         $bg_action_time[$bg_num],
	                                                         $bg_action_time_delay[$bg_num],
	                                                         $bg_action_speed_mod[$bg_num])
}

/********************************************************
*														*
*				背景スクロール[上から下へ]				*
*														*
*********************************************************/
command $bg_pan_ud(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
//	$bs_name[0] = "nothing"
	@BG_SET($bg_name, @Off, 0, 180, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, 0, -180, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[下へ上へ]				*
*														*
*********************************************************/
command $bg_pan_du(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, 0, -180, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, 0, 180, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[左から右へ]				*
*														*
*********************************************************/
command $bg_pan_lr(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, 300, -150, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, -300, -150, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[右から左へ]				*
*														*
*********************************************************/
command $bg_pan_rl(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, -300, -150, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, 300, -150, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[左上から右下へ]			*
*														*
*********************************************************/
command $bg_pan_udlr(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, 300, 180, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, -300, -180, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[右下から左上へ]			*
*														*
*********************************************************/
command $bg_pan_durl(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, -300, -180, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, 300, 180, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[右上から左下へ]			*
*														*
*********************************************************/
command $bg_pan_udrl(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, -300, 180, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, 300, -180, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[左下から右上へ]			*
*														*
*********************************************************/
command $bg_pan_dulr(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, 300, -180, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, -300, 180, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[ズームアップ]			*
*														*
*********************************************************/
command $bg_pan_zu(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, 0, 0, 255, 0, 100, 100)
	@WIPE($sel)
	@BG_SC_EVENT(0, $sr_time, 150, 150, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[ズームダウン]			*
*														*
*********************************************************/
command $bg_pan_zd(
	property $sel       : int,
	property $bg_name   : str,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, 0, 0, 255, 0, 150, 150)
	@WIPE($sel)
	@BG_SC_EVENT(0, $sr_time, 100, 100, 0, $speed_mod)
}

/********************************************************
*														*
*				背景スクロール[指定]					*
*														*
*********************************************************/
command $bg_pan(
	property $bg_name   : str,
	property $sel       : int,
	property $st_posx   : int,
	property $ed_posx   : int,
	property $st_posy   : int,
	property $ed_posy   : int,
	property $st_zoom   : int,
	property $ed_zoom   : int,
	property $sr_time   : int,
	property $speed_mod : int) : int
{
	@BG_SET($bg_name, @Off, $st_posx, $st_posy, 255, 0, $st_zoom, $st_zoom)
	@WIPE($sel)
	@BG_POS_EVENT(0, $sr_time, $ed_posx, $ed_posy, 0, $speed_mod)
	@BG_SC_EVENT(0, $sr_time, $ed_zoom, $ed_zoom, 0, $speed_mod)


}















//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■背景／イベントＣＧフレームアクション[座標]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_action_start01(
	property $fa  : frameaction,
	property $obj : object,
	property $obj_x_prev,
	property $obj_y_prev,
	property $obj_x_next,
	property $obj_y_next,
	property $obj_time,
	property $obj_time_dealy,
	property $obj_speed_mod)
{

	L[0] = $fa.counter.get
	$obj.x = math.timetable(L[0], $obj_time_dealy, $obj_x_prev, [0, $obj_time, $obj_x_next, $obj_speed_mod])
	if ($obj_y_next != -999999)	{
		$obj.y = math.timetable(L[0], $obj_time_dealy, $obj_y_prev, [0, $obj_time, $obj_y_next, $obj_speed_mod])
	}
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■背景／イベントＣＧフレームアクション[不透明度]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_action_start02(
	property $fa  : frameaction,
	property $obj : object,
	property $obj_tr_prev,
	property $obj_tr_next,
	property $obj_time,
	property $obj_time_dealy,
	property $obj_speed_mod)
{

	L[0] = $fa.counter.get
	$obj.tr = math.timetable(L[0], $obj_time_dealy, $obj_tr_prev, [0, $obj_time, $obj_tr_next, $obj_speed_mod])
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■背景／イベントＣＧフレームアクション[座標]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_action_start03(
	property $fa  : frameaction,
	property $obj : object,
	property $obj_scale_x_prev,
	property $obj_scale_y_prev,
	property $obj_scale_x_next,
	property $obj_scale_y_next,
	property $obj_time,
	property $obj_time_dealy,
	property $obj_speed_mod)
{

	L[0] = $fa.counter.get
	$obj.scale_x = math.timetable(L[0], $obj_time_dealy, $obj_scale_x_prev, [0, $obj_time, $obj_scale_x_next, $obj_speed_mod])
	if ($obj_scale_y_next != -999999)	{
		$obj.scale_y = math.timetable(L[0], $obj_time_dealy, $obj_scale_y_prev, [0, $obj_time, $obj_scale_y_next, $obj_speed_mod])
	}
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■背景／イベントＣＧフレームアクション[回転]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_action_start04(
	property $fa  : frameaction,
	property $obj : object,
	property $obj_ro_loop,
	property $obj_ro_prev,
	property $obj_ro_next,
	property $obj_time,
	property $obj_time_dealy,
	property $obj_speed_mod)
{

	if ($obj_ro_loop == @On)	{
		// 回転ループ
		L[0] = $fa.counter.get % $obj_time
	}
	else{
		// 回転単発
		L[0] = $fa.counter.get
	}
	$obj.rotate_z = math.timetable(L[0], $obj_time_dealy, $obj_ro_prev, [0, $obj_time, $obj_ro_next, $obj_speed_mod])
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■背景／イベントＣＧフレームアクション[パターン]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bg_action_start05(
	property $fa  : frameaction,
	property $obj : object,
	property $obj_patno_prev,
	property $obj_patno_next,
	property $obj_time,
	property $obj_time_dealy,
	property $obj_speed_mod)
{
	L[0] = $fa.counter.get
	$obj.patno = math.timetable(L[0], $obj_time_dealy, $obj_patno_prev, [0, $obj_time, $obj_patno_next, $obj_speed_mod])
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■バストショットフレームアクション
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $bs_action_start(
	property $fa  : frameaction,
	property $obj : object,
	property $obj_x,
	property $obj_y,
	property $obj_tr_prev,
	property $obj_tr_next,
	property $obj_scale_x_next,
	property $obj_scale_y_next,
	property $obj_scale_x_prev,
	property $obj_scale_y_prev,
	property $obj_rotate_z_next,
	property $obj_rotate_z_prev,
	property $obj_time,
	property $obj_action : str,
	property $obj_x_now,
	property $obj_y_now,
	property $obj_at_mod)
{

	L[0] = $fa.counter.get
	switch ($obj_action)	{
		case("a0")
			// 頷き
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 0])
		case("b0")
			// お辞儀
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 0])
		case ("c0")
			// プルプル（怒り、震えetc）
			L[0] = $fa.counter.get % $obj_time
			$obj.x_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 4) * 1, 0 + ($obj_x / 2)],
			                                           [($obj_time / 4) * 1, ($obj_time / 4) * 2, 0               ],
			                                           [($obj_time / 4) * 2, ($obj_time / 4) * 3, 0 - ($obj_x / 2)],
			                                           [($obj_time / 4) * 3, ($obj_time / 4) * 4, 0               ])
		case ("d0")
			// 驚き（飛び上がる）
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 0])
		case ("e0")
			// 驚き（上下にビクビクッ）
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [                    0, ($obj_time / 10) * 01, 0 + $obj_y     ],
                                                       [($obj_time / 10) * 01, ($obj_time / 10) * 02, 0              ],
                                                       [($obj_time / 10) * 02, ($obj_time / 10) * 03, 0 + $obj_y - 05],
                                                       [($obj_time / 10) * 03, ($obj_time / 10) * 04, 0              ],
                                                       [($obj_time / 10) * 04, ($obj_time / 10) * 05, 0 + $obj_y - 10],
                                                       [($obj_time / 10) * 05, ($obj_time / 10) * 06, 0              ],
                                                       [($obj_time / 10) * 06, ($obj_time / 10) * 07, 0 + $obj_y - 10],
                                                       [($obj_time / 10) * 07, ($obj_time / 10) * 08, 0              ],
                                                       [($obj_time / 10) * 08, ($obj_time / 10) * 09, 0 + $obj_y -  5],
                                                       [($obj_time / 10) * 09, ($obj_time / 10) * 10, 0              ])
		case ("f0")
			// 喜び（バンザイ）
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [            0,                 $obj_time / 4,                 $obj_y, 2],
			                                           [$obj_time / 4,                 $obj_time / 2,                      0, 1],
			                                           [$obj_time / 2,                 $obj_time / 2 + $obj_time / 4, $obj_y, 2],
			                                           [$obj_time / 2 + $obj_time / 4, $obj_time,                          0, 1])
		case ("g0")
			// 主張（ピョンピョン）
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 6) * 1, $obj_y, 2],
			                                           [($obj_time / 6) * 1, ($obj_time / 6) * 2,      0, 1],
			                                           [($obj_time / 6) * 2, ($obj_time / 6) * 3, $obj_y, 2],
			                                           [($obj_time / 6) * 3, ($obj_time / 6) * 4,      0, 1],
			                                           [($obj_time / 6) * 4, ($obj_time / 6) * 5, $obj_y, 2],
			                                           [($obj_time / 6) * 5, ($obj_time / 6) * 6,      0, 1])

		case ("r1")
			// スライド（右）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("r2")
			// スライド（右）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("r3")
			// スライド（右）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("r4")
			// スライド（右）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("r5")
			// スライド（右）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("l1")
			// スライド（左）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("l2")
			// スライド（左）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("l3")
			// スライド（左）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("l4")
			// スライド（左）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("l5")
			// スライド（左）
			$obj.x_rep[1] = math.timetable(L[0], 0, $obj_x_now, [                  0, $obj_time, $obj_x, $obj_at_mod])

		case ("d1")
			// スライド（下）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("d2")
			// スライド（下）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("d3")
			// スライド（下）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("d4")
			// スライド（下）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("d5")
			// スライド（下）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("u1")
			// スライド（上）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("u2")
			// スライド（上）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("u3")
			// スライド（上）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("u4")
			// スライド（上）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("u5")
			// スライド（上）
			$obj.y_rep[2] = math.timetable(L[0], 0, $obj_y_now, [                  0, $obj_time, $obj_y, $obj_at_mod])

		case ("h0") 
			// 拡大縮小アニメ・弱（縮こまる、気合を入れるetc）
			$obj.scale_x = math.timetable(L[0], 0, $obj_scale_x_prev, [                  0, ($obj_time / 4) * 1, $obj_scale_x_next-400, 2],
			                                                          [($obj_time / 4) * 1, ($obj_time / 4) * 2, $obj_scale_x_next,     1],
			                                                          [($obj_time / 4) * 2, ($obj_time / 4) * 3, $obj_scale_x_next-400, 2],
			                                                          [($obj_time / 4) * 3, ($obj_time / 4) * 4, 1000,                  1])

			$obj.scale_y = math.timetable(L[0], 0, $obj_scale_y_prev, [                  0, ($obj_time / 4) * 1, $obj_scale_y_next-400, 2],
			                                                          [($obj_time / 4) * 1, ($obj_time / 4) * 2, $obj_scale_y_next,     1],
			                                                          [($obj_time / 4) * 2, ($obj_time / 4) * 3, $obj_scale_y_next-400, 2],
			                                                          [($obj_time / 4) * 3, ($obj_time / 4) * 4, 1000,                  1])
		case ("i0") 
			// 拡大縮小アニメ・強（縮こまる、気合を入れるetc）
			$obj.scale_x = math.timetable(L[0], 0, $obj_scale_x_prev, [                  0, ($obj_time / 5) * 1, $obj_scale_x_next-700, 0],
			                                                          [($obj_time / 5) * 1, ($obj_time / 5) * 2, $obj_scale_x_next,     2],
			                                                          [($obj_time / 5) * 2, ($obj_time / 5) * 3, $obj_scale_x_next-700, 0],
			                                                          [($obj_time / 5) * 3, ($obj_time / 5) * 4, $obj_scale_x_next,     2],
                                                                      [($obj_time / 5) * 4, ($obj_time / 5) * 5, 1000,                  0])

			$obj.scale_y = math.timetable(L[0], 0, $obj_scale_y_prev, [                  0, ($obj_time / 5) * 1, $obj_scale_y_next-700, 0],
			                                                          [($obj_time / 5) * 1, ($obj_time / 5) * 2, $obj_scale_y_next,     2],
			                                                          [($obj_time / 5) * 2, ($obj_time / 5) * 3, $obj_scale_y_next-700, 0],
			                                                          [($obj_time / 5) * 3, ($obj_time / 5) * 4, $obj_scale_y_next,     2],
                                                                      [($obj_time / 5) * 4, ($obj_time / 5) * 5, 1000,                  0])
		case ("j0") 
			// 縮小
			$obj.scale_x = math.timetable(L[0], 0, $obj_scale_x_prev, [0, $obj_time, $obj_scale_x_next, 2])
			$obj.scale_y = math.timetable(L[0], 0, $obj_scale_y_prev, [0, $obj_time, $obj_scale_y_next, 2])

		case ("k0")
			// ルンルン（継続）
			L[0] = $fa.counter.get % $obj_time
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 2])

		case ("l0")
			// 地団駄
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 8) * 1, $obj_y, 2],
			                                           [($obj_time / 8) * 1, ($obj_time / 8) * 2,      0, 0],
			                                           [($obj_time / 8) * 2, ($obj_time / 8) * 3, $obj_y, 2],
			                                           [($obj_time / 8) * 3, ($obj_time / 8) * 4,      0, 0],
			                                           [($obj_time / 8) * 4, ($obj_time / 8) * 5, $obj_y, 2],
			                                           [($obj_time / 8) * 5, ($obj_time / 8) * 6,      0, 0],
			                                           [($obj_time / 8) * 6, ($obj_time / 8) * 7, $obj_y, 2],
			                                           [($obj_time / 8) * 7, ($obj_time / 8) * 8,      0, 0])
		case ("m0")
			// 息切れ（しこたま殴った後とか
			L[0] = $fa.counter.get % $obj_time
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 2])
		case ("n0")
			// 軽いスクワット的な喜び？
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 4) * 1, $obj_y, 2],
			                                           [($obj_time / 4) * 1, ($obj_time / 4) * 2,      0, 2],
			                                           [($obj_time / 4) * 2, ($obj_time / 4) * 3, $obj_y, 2],
			                                           [($obj_time / 4) * 3, ($obj_time / 4) * 4,      0, 2])
		case ("o0")
			// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス）
			$obj.x_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 8) * 1, 0 + ($obj_x / 2), 0],
			                                           [($obj_time / 8) * 1, ($obj_time / 8) * 2, 0,                0],
			                                           [($obj_time / 8) * 2, ($obj_time / 8) * 3, 0 - ($obj_x / 2), 0],
			                                           [($obj_time / 8) * 3, ($obj_time / 8) * 4, 0,                0],
			                                           [($obj_time / 8) * 4, ($obj_time / 8) * 5, 0 + ($obj_x / 2), 0],
			                                           [($obj_time / 8) * 5, ($obj_time / 8) * 6, 0,                0],
			                                           [($obj_time / 8) * 6, ($obj_time / 8) * 7, 0 - ($obj_x / 2), 0],
			                                           [($obj_time / 8) * 7, ($obj_time / 8) * 8, 0,                0])
		case ("p0")
			// フラフラ
			L[0] = $fa.counter.get % $obj_time
			$obj.x_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 4) * 1, 0 + ($obj_x / 2), 2],
			                                           [($obj_time / 4) * 1, ($obj_time / 4) * 2, 0,                1],
			                                           [($obj_time / 4) * 2, ($obj_time / 4) * 3, 0 - ($obj_x / 2), 2],
			                                           [($obj_time / 4) * 3, ($obj_time / 4) * 4, 0,                1])
		case ("q0")
			// 弾む感じで上下に揺れる
			L[0] = $fa.counter.get % $obj_time
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 6) * 1, $obj_y,              1],
			                                           [($obj_time / 6) * 1, ($obj_time / 6) * 2, $obj_y - $obj_y * 2, 2],
			                                           [($obj_time / 6) * 2, ($obj_time / 6) * 3, $obj_y,              1],
			                                           [($obj_time / 6) * 3, ($obj_time / 6) * 4, $obj_y - $obj_y * 2, 2],
			                                           [($obj_time / 6) * 4, ($obj_time / 6) * 5, $obj_y,              1],
			                                           [($obj_time / 6) * 5, ($obj_time / 6) * 6, 0,                   2])
		case ("r0")
			// テレテレ
			L[0] = $fa.counter.get % $obj_time
			$obj.x_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 4) * 1, 0 + ($obj_x / 2), 2],
			                                           [($obj_time / 4) * 1, ($obj_time / 4) * 2, 0,                1],
			                                           [($obj_time / 4) * 2, ($obj_time / 4) * 3, 0 - ($obj_x / 2), 2],
			                                           [($obj_time / 4) * 3, ($obj_time / 4) * 4, 0,                1])
		case ("s0")
			// デコピン（小突き的な）
			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 0])
		case ("t0")
			// 回転
			$obj.rotate_z = math.timetable(L[0], 0, $obj_rotate_z_prev, [0, $obj_time, $obj_rotate_z_next, 2])
		case ("u0")
			// 回転ループ
			L[0] = $fa.counter.get % $obj_time
			$obj.rotate_z = math.timetable(L[0], 0, $obj_rotate_z_prev, [0, $obj_time, $obj_rotate_z_next, 0])
		case ("v0")
			// 左右にビクン
			$obj.x_rep[0] = math.timetable(L[0], 0, 0, [                  0, ($obj_time / 4) * 1, 0 + ($obj_x / 2)],
			                                           [($obj_time / 4) * 1, ($obj_time / 4) * 2, 0               ],
			                                           [($obj_time / 4) * 2, ($obj_time / 4) * 3, 0 - ($obj_x / 2)],
			                                           [($obj_time / 4) * 3, ($obj_time / 4) * 4, 0               ])
//		case ("w0")
//			// デコピン（小突き的な）
//			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 0])

		case ("w0")
			// ブルルッ
			$obj.x_rep[0] = math.timetable(L[0], 0, 0, [  0,  20+10,  -5, 2],	// 1
			                                           [ 40,  60+10,  -5, 2],	// 2
			                                           [ 80, 120+10,   5, 2],	// 4
			                                           [160, 200+10,  -5, 2],	// 6
			                                           [220, 250+10,   0, 2])	// 7

			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [  0,  20+10,  0, 2],
			                                           [ 40,  60+10,  0, 2],
			                                           [ 60,  70+10, -2, 2],	// 3
			                                           [130, 140+10, -4, 2],	// 5
			                                           [270, 280+10,  0, 2])	// 8



//		case ("z")
//			// ルンルン（継続）
//			L[0] = $fa.counter.get % $obj_time
//			$obj.y_rep[0] = math.timetable(L[0], 0, 0, [0, $obj_time/2, $obj_y, 2], [$obj_time/2, $obj_time, 0, 2])

	}
}

