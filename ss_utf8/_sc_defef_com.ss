#z00
// ---------------------------------------------------------------
// 画面縦揺れ[縦、横]
// ---------------------------------------------------------------
command $quake1(property $time    : int,
                property $cnt     : int,
                property $end_cnt : int,
                property $power   : int,
                property $order   : int,
                property $wait    : int,
                property $pat     : int,
                property $all     : int)

{

	if ($wait == @Off)	{
		if ($all == @Off)	{
			if ($order == 0)	{
				screen.quake[@qk_num1].start(1, $time, $cnt, $end_cnt, 0, 0, [$power, $pat])
			}
			else	{
				screen.quake[@qk_num1].start(1, $time, $cnt, $end_cnt, 1, 2, [$power, $pat])
			}
		}
		else	{
			screen.quake[@qk_num1].start_all(1, $time, $cnt, $end_cnt, [$power, $pat])
		}
	}
	else	{
		if ($all == @Off)	{
			if ($order == 0)	{
				screen.quake[@qk_num1].start_wait(1, $time, $cnt, $end_cnt, 0, 0, [$power, $pat])
			}
			else	{
				screen.quake[@qk_num1].start_wait(1, $time, $cnt, $end_cnt, 1, 2, [$power, $pat])
			}
		}
		else	{
			screen.quake[@qk_num1].start_all_wait(1, $time, $cnt, $end_cnt, [$power, $pat])
		}
	}
}


// ---------------------------------------------------------------
// 画面縦揺れ[縦横]
// ---------------------------------------------------------------
command $quake2(property $time1    : int,
                property $cnt1     : int,
                property $end_cnt1 : int,
                property $power1   : int,
                property $time2    : int,
                property $cnt2     : int,
                property $end_cnt2 : int,
                property $power2   : int,
                property $order    : int,
                property $wait     : int,
                property $all      : int)
{

	if ($wait == @Off)	{
		if ($all == @Off)	{
			if ($order == 0)	{
				screen.quake[@qk_num1].start(1, $time1, $cnt1, $end_cnt1, 0, 0, [$power1, 0])
				screen.quake[@qk_num2].start(1, $time2, $cnt2, $end_cnt2, 0, 0, [$power2, 6])
			}
			else	{
				screen.quake[@qk_num1].start(1, $time1, $cnt1, $end_cnt1, 1, 2, [$power1, 0])
				screen.quake[@qk_num2].start(1, $time2, $cnt2, $end_cnt2, 1, 2, [$power2, 6])
			}
		}
		else	{
			screen.quake[@qk_num1].start_all(1, $time1, $cnt1, $end_cnt1, [$power1, 0])
			screen.quake[@qk_num2].start_all(1, $time2, $cnt2, $end_cnt2, [$power2, 6])
		}
	}
	else	{
		if ($all == @Off)	{
			if ($order == 0)	{
				screen.quake[@qk_num1].start_wait(1, $time1, $cnt1, $end_cnt1, 0, 0, [$power1, 0])
				screen.quake[@qk_num2].start_wait(1, $time2, $cnt2, $end_cnt2, 0, 0, [$power2, 6])
			}
			else	{
				screen.quake[@qk_num1].start_wait(1, $time1, $cnt1, $end_cnt1, 1, 2, [$power1, 0])
				screen.quake[@qk_num2].start_wait(1, $time2, $cnt2, $end_cnt2, 1, 2, [$power2, 6])
			}
		}
		else	{
			screen.quake[@qk_num1].start_all_wait(1, $time1, $cnt1, $end_cnt1, [$power1, 0])
			screen.quake[@qk_num2].start_all_wait(1, $time2, $cnt2, $end_cnt2, [$power2, 6])
		}
	}
}


// ---------------------------------------------------------------
// 画面拡縮
// ---------------------------------------------------------------
command $quake_zoom(property $time     : int,
                    property $cnt      : int,
                    property $end_cnt  : int,
                    property $scale    : int,
                    property $center_x : int,
                    property $center_y : int,
                    property $order    : int,
                    property $wait     : int,
                    property $all      : int)
{

	if ($wait == @Off)	{
		if ($all == @Off)	{
			if ($order == 0)	{
				screen.quake[@qk_num3].start(2, $time, $cnt, $end_cnt, 0, 0, [$scale, $center_x, $center_y])
			}
			else	{
				screen.quake[@qk_num3].start(2, $time, $cnt, $end_cnt, 1, 2, [$scale, $center_x, $center_y])
			}
		}
		else	{
			screen.quake[@qk_num3].start_all(2, $time, $cnt, $end_cnt, [$scale, $center_x, $center_y])
		}
	}
	else	{
		if ($all == @Off)	{
			if ($order == 0)	{
				screen.quake[@qk_num3].start_wait(2, $time, $cnt, $end_cnt, 0, 0, [$scale, $center_x, $center_y])
			}
			else	{
				screen.quake[@qk_num3].start_wait(2, $time, $cnt, $end_cnt, 1, 2, [$scale, $center_x, $center_y])
			}
		}
		else	{
			screen.quake[@qk_num3].start_all_wait(2, $time, $cnt, $end_cnt, [$scale, $center_x, $center_y])
		}
	}
}


// ---------------------------------------------------------------
// 白／赤／黒フラッシュ（パラメータで様々なフラッシュが可能に）
// ---------------------------------------------------------------
command $sc_flash(property $time      : int,
                  property $cnt       : int,
                  property $last_slow : int,
                  property $last_time : int,
                  property $ev_name   : str,
                  property $color_r   : int,
                  property $color_g   : int,
                  property $color_b   : int)
{

	// システムコマンドメニューを禁止
	syscom.set_syscom_menu_disable
	// ショートカット機能を禁止
	script.set_shortcut_disable

	screen.effect[0].init
	screen.effect[0].color_r = $color_r
	screen.effect[0].color_g = $color_g
	screen.effect[0].color_b = $color_b
	for (l[0] = 0, l[0] < $cnt, l[0] += 1)	{
		screen.effect[0].color_rate_eve.set(255, $time/2, 0, 0)
		screen.effect[0].color_rate_eve.wait
		if (($last_slow == @On) && (l[0] == $cnt - 1))	{
			if ($ev_name != "none")	{
				@cg2($ev_name, 99, @On)
			}
			screen.effect[0].color_rate_eve.set(  0, $last_time, 0, 0)
			screen.effect[0].color_rate_eve.wait
		}
		else	{
			screen.effect[0].color_rate_eve.set(  0, $time/2, 0, 0)
			screen.effect[0].color_rate_eve.wait
		}
	}

	// システムコマンドメニューを禁止を解除
	syscom.set_syscom_menu_enable
	// ショートカット機能を禁止を解除
	script.set_shortcut_enable

}



// ---------------------------------------------------------------
// モノクロ
// ---------------------------------------------------------------
command $sc_mono(property $switch        : int,
                 property $time          : int,
                 property $wait          : int,
                 property $sc_tr_num     : int,
                 property $sc_layer_num  : int,
                 property $sc_bn_layer00 : int,
                 property $sc_en_layer01 : int,
                 property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($switch == @On) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].mono = $sc_tr_num
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer   = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer   = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($switch == @On) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].mono_eve.set(255, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer   = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer   = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($switch == @Off) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// 時間指定で消去
	elseif (($switch == @Off) && ($time != 0))	{
		@f.effect[0].mono_eve.set(0, $time, 0, 0)
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].mono_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}


// ---------------------------------------------------------------
// セピア
// ---------------------------------------------------------------
command $sc_sepia(property $switch        : int,
                  property $time          : int,
                  property $wait          : int,
                  property $sc_layer_num  : int,
                  property $sc_bn_layer00 : int,
                  property $sc_en_layer01 : int,
                  property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($switch == @On) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].color_add_r = 255/4
		@b.effect[0].color_add_g =  96/4
		@b.effect[0].color_add_b =  32/4
		@b.effect[0].mono = 255
		@b.effect[0].dark =  40
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer   = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer   = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($switch == @On) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].color_add_r_eve.set(255/4, $time, 0, 0)
		@f.effect[0].color_add_g_eve.set( 96/4, $time, 0, 0)
		@f.effect[0].color_add_b_eve.set( 32/4, $time, 0, 0)
		@f.effect[0].mono_eve.set(255, $time, 0, 0)
		@f.effect[0].dark_eve.set( 40, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer   = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer   = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($switch == @Off) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// 時間指定で消去
	elseif (($switch == @Off) && ($time != 0))	{
		@f.effect[0].color_add_r_eve.set(0, $time, 0, 0)
		@f.effect[0].color_add_g_eve.set(0, $time, 0, 0)
		@f.effect[0].color_add_b_eve.set(0, $time, 0, 0)
		@f.effect[0].mono_eve.set(0, $time, 0, 0)
		@f.effect[0].dark_eve.set(0, $time, 0, 0)
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].mono_eve.wait
		@f.effect[0].dark_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}


// ---------------------------------------------------------------
// ネガ反転
// ---------------------------------------------------------------
command $sc_nega(property $switch        : int,
                 property $time          : int,
                 property $wait          : int,
                 property $sc_tr_num     : int,
                 property $sc_layer_num  : int,
                 property $sc_bn_layer00 : int,
                 property $sc_en_layer01 : int,
                 property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($switch == @On) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].reverse = $sc_tr_num
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($switch == @On) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].reverse_eve.set(255, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($switch == @Off) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// 時間指定で消去
	elseif (($switch == @Off) && ($time != 0))	{
		@f.effect[0].reverse_eve.set(0, $time, 0, 0)
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].mono_eve.wait
		@f.effect[0].dark_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}


// ---------------------------------------------------------------
// 黒フィルター
// ---------------------------------------------------------------
command $sc_filter_b(property $tr            : int,
                     property $time          : int,
                     property $wait          : int,
                     property $sc_layer_num  : int,
                     property $sc_bn_layer00 : int,
                     property $sc_en_layer01 : int,
                     property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($tr != 0) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].dark = $tr
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($tr != 0) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].dark_eve.set($tr, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($tr == 0) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].dark_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}


// ---------------------------------------------------------------
// 白フィルター
// ---------------------------------------------------------------
command $sc_filter_w(property $tr            : int,
                     property $time          : int,
                     property $wait          : int,
                     property $sc_layer_num  : int,
                     property $sc_bn_layer00 : int,
                     property $sc_en_layer01 : int,
                     property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($tr != 0) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].color_r = 255
		@b.effect[0].color_g = 255
		@b.effect[0].color_b = 255
		@b.effect[0].color_rate = $tr
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($tr != 0) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].color_r = 255
		@f.effect[0].color_g = 255
		@f.effect[0].color_b = 255
		@f.effect[0].color_rate_eve.set($tr, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($tr == 0) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].color_rate_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}


// ---------------------------------------------------------------
// 赤フィルター
// ---------------------------------------------------------------
command $sc_filter_r(property $tr            : int,
                     property $time          : int,
                     property $wait          : int,
                     property $sc_layer_num  : int,
                     property $sc_bn_layer00 : int,
                     property $sc_en_layer01 : int,
                     property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($tr != 0) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].color_r = 255
		@b.effect[0].color_g = 0
		@b.effect[0].color_b = 0
		@b.effect[0].color_rate = $tr
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($tr != 0) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].color_r = 255
		@f.effect[0].color_g = 0
		@f.effect[0].color_b = 0
		@f.effect[0].color_rate_eve.set($tr, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($tr == 0) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].color_rate_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}


// ---------------------------------------------------------------
// 白／赤／黒フラッシュループ（パラメータで様々なフラッシュが可能に）
// ---------------------------------------------------------------
command $sc_flash_lp(property $stime         : int,
                     property $wtime         : int,
                     property $etime         : int,
                     property $smod          : int,
                     property $emod          : int,
                     property $cl_r          : int,
                     property $cl_g          : int,
                     property $cl_b          : int,
                     property $sc_layer_num  : int,
                     property $sc_bn_layer00 : int,
                     property $sc_en_layer01 : int,
                     property $sc_en_layer02 : int,
                     property $sc_tr_num     : int)
{

	screen.effect[0].init
	screen.effect[0].color_r = $cl_r
	screen.effect[0].color_g = $cl_g
	screen.effect[0].color_b = $cl_b

	// 適用レイヤー設定
	if ($sc_layer_num == 0)	{
		screen.effect[0].begin_layer = $sc_bn_layer00
		screen.effect[0].end_layer = $sc_en_layer01
	}
	elseif ($sc_layer_num == 1)	{
		screen.effect[0].begin_layer = $sc_bn_layer00
		screen.effect[0].end_layer = $sc_en_layer02
	}
	frame_action_ch[1].start(-1, "$sc_flash_wl", $stime, $wtime, $etime, $smod, $emod, $sc_tr_num)

	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}

command $sc_flash_wl(property $fa : frameaction, property $stime : int, property $wtime : int, property $etime : int, property $smod : int, property $emod : int, property $sc_tr_num : int)
{
	L[0] = $fa.counter.get % ($stime + $wtime + $etime)
	screen.effect[0].color_rate = math.timetable(L[0], 0, 0, 
	                                            [            0,               $stime, $sc_tr_num, $smod], 
	                                            [       $stime,        $stime+$wtime, $sc_tr_num,     0], 
	                                            [$stime+$wtime, $stime+$wtime+$etime,          0, $emod])

}


// ---------------------------------------------------------------
// シネスコ表示[簡易]
// ---------------------------------------------------------------
command $sc_cinemascope(property $cs_length : int,
                        property $cs_tr     : int,
                        property $color_r   : int,
                        property $color_g   : int,
                        property $color_b   : int)
{

	@b.obj[@OBJ_EF_SCREEN04].create_rect(0, 0, 1280, $cs_length, $color_r, $color_g, $color_b, $cs_tr, @On, 0, 0)
	@b.obj[@OBJ_EF_SCREEN05].create_rect(0, 0, 1280, $cs_length, $color_r, $color_g, $color_b, $cs_tr, @On, 0, 720 - $cs_length)
//	@b.obj[@OBJ_EF_SCREEN04].set_pos(0, 0)
//	@b.obj[@OBJ_EF_SCREEN05].set_pos(0, 720 - $cs_length)
//	@b.obj[@OBJ_EF_SCREEN04].tr = $cs_tr
//	@b.obj[@OBJ_EF_SCREEN05].tr = $cs_tr
	@b.obj[@OBJ_EF_SCREEN04].layer = -20
	@b.obj[@OBJ_EF_SCREEN05].layer = -20
//	@b.obj[@OBJ_EF_SCREEN04].disp = @On
//	@b.obj[@OBJ_EF_SCREEN05].disp = @On
	@b.obj[@OBJ_EF_SCREEN04].wipe_copy = @On
	@b.obj[@OBJ_EF_SCREEN05].wipe_copy = @On
}


// ---------------------------------------------------------------
// シネスコ表示
// ---------------------------------------------------------------
command $sc_cinemascope_set(property $cs_switch : int,
                            property $cs_length : int,
                            property $cs_time   : int,
                            property $color_r   : int,
                            property $color_g   : int,
                            property $color_b   : int,
                            property $cs_tr     : int,
                            property $cs_mod    : int,
                            property $cs_wait   : int)
{

	// @cs_switch
	if ($cs_switch == @On)	{

		@f.obj[@OBJ_EF_SCREEN04].create_rect(0, 0, 1280, $cs_length, $color_r, $color_g, $color_b, $cs_tr, @On, 0, 0 - $cs_length)
		@f.obj[@OBJ_EF_SCREEN05].create_rect(0, 0, 1280, $cs_length, $color_r, $color_g, $color_b, $cs_tr, @On, 0, 720)
//		@f.obj[@OBJ_EF_SCREEN04].set_pos(0, 0 - $cs_length)
//		@f.obj[@OBJ_EF_SCREEN05].set_pos(0, 720)
//		@f.obj[@OBJ_EF_SCREEN04].tr = $cs_tr
//		@f.obj[@OBJ_EF_SCREEN05].tr = $cs_tr
		@f.obj[@OBJ_EF_SCREEN04].layer = -20
		@f.obj[@OBJ_EF_SCREEN05].layer = -20
		@f.obj[@OBJ_EF_SCREEN04].wipe_copy = @On
		@f.obj[@OBJ_EF_SCREEN05].wipe_copy = @On

		@f.obj[@OBJ_EF_SCREEN04].y_rep.resize(1)
		@f.obj[@OBJ_EF_SCREEN05].y_rep.resize(1)

		@f.obj[@OBJ_EF_SCREEN04].y_rep_eve[0].set(  $cs_length, $cs_time, 0, $cs_mod)
		@f.obj[@OBJ_EF_SCREEN05].y_rep_eve[0].set(- $cs_length, $cs_time, 0, $cs_mod)

	}
	else	{
		@f.obj[@OBJ_EF_SCREEN04].y_rep_eve[0].set(- $cs_length, $cs_time, 0, $cs_mod)
		@f.obj[@OBJ_EF_SCREEN05].y_rep_eve[0].set(  $cs_length, $cs_time, 0, $cs_mod)
	}
	if ($cs_wait == @On)	{
		@f.obj[@OBJ_EF_SCREEN04].y_eve.wait
		@f.obj[@OBJ_EF_SCREEN05].y_eve.wait
	}
}


// ---------------------------------------------------------------
// シネスコ消去
// ---------------------------------------------------------------
command $sc_cinemascope_off(property $dummy : int)
{

	@f.obj[@OBJ_EF_SCREEN04].wipe_copy = @Off
	@f.obj[@OBJ_EF_SCREEN05].wipe_copy = @Off

}




// ---------------------------------------------------------------
// 画面揺れ
// ---------------------------------------------------------------
command	$screen_shake(property $shake : int, property $flash : int, property $wait : int)
{

	if ($flash == @On)	{
		@SC_FLASH_W(100, 1)
	}

	switch ($shake)	{
		case (0)
			// 縦／弱
			@QUAKE_UD_ALL(100, 1, 1, 60, $wait)
		case (1)
			// 横／弱
			@QUAKE_LR_ALL(100, 1, 1, 60, $wait)
		case (2)
			// 拡縮／弱
			@QUAKE_ZOOM_ALL(100, 1, 1, 30, 640, 500, $wait)
		case (3)
			// 縦／強
			@QUAKE_UD_ALL(100, 2, 1, 100, $wait)
		case (4)
			// 横／強
			@QUAKE_LR_ALL(100, 2, 1, 100, $wait)
		case (5)
			// 拡縮／強
			@QUAKE_ZOOM_ALL(100, 2, 1, 60, 640,500, $wait)
	}
}


// ---------------------------------------------------------------
// 回想
// ---------------------------------------------------------------
command $sc_recollect(property $color : str)
{
	@b.obj[@OBJ_EF_SCREEN01].init
	@b.obj[@OBJ_EF_SCREEN01].disp = @On
	@b.obj[@OBJ_EF_SCREEN01].layer = 5000
	@b.obj[@OBJ_EF_SCREEN01].@cd.resize(2)
	@b.obj[@OBJ_EF_SCREEN01].wipe_copy = @On
	// 枠
	if ($color == "白")	{
		@b.obj[@OBJ_EF_SCREEN01].@cd[0].create_movie_loop(ef_rec_white00, @On)
	}
	else	{
		@b.obj[@OBJ_EF_SCREEN01].@cd[0].create_movie_loop(ef_rec_black00, @On)
	}
	@b.obj[@OBJ_EF_SCREEN01].@cd[0].set_scale(2000, 2000)
	
	// ノイズ
	@b.obj[@OBJ_EF_SCREEN01].@cd[1].create_movie_loop(ef_rec_noise00, @On)
//		@b.obj[@OBJ_EF_SCREEN01].@cd[1].set_scale(2000, 2000)
	@b.obj[@OBJ_EF_SCREEN01].@cd[1].blend = 4

	// モノクロ
	@b.effect[0].begin_order = 0
	@b.effect[0].end_order = 0
	@b.effect[0].mono = 180
	@b.effect[0].wipe_copy = @On

}

command $sc_recollect_end
{
		@f.obj[@OBJ_EF_SCREEN01].wipe_copy = @Off
		@f.effect[0].wipe_copy = @Off
}


// ---------------------------------------------------------------
// 集中線
// ---------------------------------------------------------------
command $sc_conline(property $state : int)
{
	// 次のワイプで消去
	if ($state == @Off)	{
		@f.obj[@OBJ_EF_SCREEN02].wipe_copy = @Off
	}
	// 次のワイプで表示
	else	{
		@b.obj[@OBJ_EF_SCREEN02].create(ef_em21, @On, -384, -255)
		@b.obj[@OBJ_EF_SCREEN02].load_gan(ef_em21)
		@b.obj[@OBJ_EF_SCREEN02].start_gan(0, 1)
		@b.obj[@OBJ_EF_SCREEN02].layer = 1500
		@b.obj[@OBJ_EF_SCREEN02].wipe_copy = @On
	}
}


// ---------------------------------------------------------------
// ハンドソニック
// ---------------------------------------------------------------
command $gs_handsonic(property $bs_size : int, property $bs_num : int, property $obj_index)
{
	// bs1
	if ($bs_size == 1)	{
		// 正面
		if ($bs_num == 1)	{
			L[0] = 337+1
			L[1] = 134+4
			L[2] = 1
			K[0] = "ef_gs_hs01"
		}
		// 斜め
		else	{
			L[0] = 189
			L[1] = 11+3
			L[2] = -1
			K[0] = "ef_gs_hs02"
		}
	}
	// bs2
	else	{
		// 正面
		if ($bs_num == 1)	{
			L[0] = 491-1
			L[1] = 29-10
			L[2] = 1
			K[0] = "ef_gs_hs03"
		}
		// 斜め
		else	{
			L[0] = 52
			L[1] = -38-10
			L[2] = -1
			K[0] = "ef_gs_hs04"
		}
	}

	// かなでのオブジェクトは 11

	@f.obj[@OBJ_EF_SCREEN15].create_movie(K[0], @On, L[0] + (@f.obj[$obj_index].x - @pos_c), L[1] + (@f.obj[$obj_index].y - @pos_m), auto_free = @Off)
	@f.obj[@OBJ_EF_SCREEN15].layer = @f.obj[$obj_index].layer + L[2]
	@f.obj[@OBJ_EF_SCREEN15].blend = 1

//	@f.obj[@OBJ_EF_SCREEN15].wipe_copy = @On

}


// ---------------------------------------------------------------
// 湯気
// ---------------------------------------------------------------
command $ef_bath01(property $disp : int)
{

	// 表示
	if ($disp == 0)	{
		// キャラより後
		@b.obj[@OBJ_EF_SCREEN03].create_movie_loop(ef_bath01, @On, 0, 0)
		@b.obj[@OBJ_EF_SCREEN03].set_scale(2000, 2000)
		@b.obj[@OBJ_EF_SCREEN03].tr = 200
		@b.obj[@OBJ_EF_SCREEN03].layer = 0	// 注意
		@b.obj[@OBJ_EF_SCREEN03].blend = 4
		@b.obj[@OBJ_EF_SCREEN03].wipe_copy = @On
		// キャラより前
		@b.obj[@OBJ_EF_SCREEN04].init
		@b.obj[@OBJ_EF_SCREEN04].disp = @On
		@b.obj[@OBJ_EF_SCREEN04].child.resize(2)
		@b.obj[@OBJ_EF_SCREEN04].layer = 1000	// 注意
		@b.obj[@OBJ_EF_SCREEN04].wipe_copy = @On

		@b.obj[@OBJ_EF_SCREEN04].@cd[0].create_movie_loop(ef_bath02, @On, 0, 0)
		@b.obj[@OBJ_EF_SCREEN04].@cd[0].set_scale(2000, 2000)
		@b.obj[@OBJ_EF_SCREEN04].@cd[0].tr = 200
		@b.obj[@OBJ_EF_SCREEN04].@cd[0].layer = 1000	// 注意
		@b.obj[@OBJ_EF_SCREEN04].@cd[0].blend = 4
		@b.obj[@OBJ_EF_SCREEN04].@cd[0].wipe_copy = @On

		@b.obj[@OBJ_EF_SCREEN04].@cd[1].create_movie_loop(ef_bath02, @On, 0, 0)
		@b.obj[@OBJ_EF_SCREEN04].@cd[1].set_scale(2000, 2000)
		@b.obj[@OBJ_EF_SCREEN04].@cd[1].tr = 200
		@b.obj[@OBJ_EF_SCREEN04].@cd[1].layer = 1000	// 注意
		@b.obj[@OBJ_EF_SCREEN04].@cd[1].blend = 4
		@b.obj[@OBJ_EF_SCREEN04].@cd[1].wipe_copy = @On

	}
	// 消去
	else	{
		@f.obj[@OBJ_EF_SCREEN03].wipe_copy = @Off
		@f.obj[@OBJ_EF_SCREEN04].wipe_copy = @Off
	}

}


// ---------------------------------------------------------------
// 陽光
// ---------------------------------------------------------------
command $ef_sunshine(property $ef_name : str, property $ef_scale : int)
{

	@b.obj[@OBJ_EF_SCREEN05].create_movie($ef_name, @On, auto_free = @Off)
	if ($ef_scale == @On)	{
		@b.obj[@OBJ_EF_SCREEN05].set_scale(2000, 2000)
	}
	@b.obj[@OBJ_EF_SCREEN05].blend = 1
}



