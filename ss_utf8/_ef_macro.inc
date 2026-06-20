//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_macro.inc
//	@author		Kazuya Takahashi
//	@note		演出マクロ置き場
//
//-----------------------------------------------------------------------------------------------

//-----------------------------------------------------------------
// フェードフラグを無視した強制フェード
//-----------------------------------------------------------------
#macro	@force_fade(@name(bg_kuro), @wipe_no(3))
	$fade_dup = @Off
	@fade(@name, @wipe_no)

//-----------------------------------------------------------------
// 背景位置補正設定
//-----------------------------------------------------------------
#macro	@bg_set_ex(@bgname, @pos_x(0), @pos_y(0), @scale_x(100), @scale_y(100))
	@bg_reset(0)
	@BG_SET(@bgname, 1, @pos_x, @pos_y, 255, 0, @scale_x, @scale_y)

#macro	@bg_ex(@bgname, @wipe_no(3))
	$$ef_bg_set_autopos(@bgname)
	@wipe(@wipe_no)

//-----------------------------------------------------------------
// 背景、バストショット同時表示
//-----------------------------------------------------------------
#macro	@bgs(@bgname, @bs1, @wipe_no(3), @bs2("nothing"), @bs3("nothing"), @bs4("nothing"), @bs5("nothing"), @bs6("nothing"))
	close
	$$ef_bg_set_autopos(@bgname)
	@bs_w(@wipe_no, @bs1, @bs2, @bs3, @bs4, @bs5, @bs6)
	@ef_common_wait(@wipe_no)

//-----------------------------------------------------------------
// 背景回転ズームダウン
//-----------------------------------------------------------------
#macro	@bg_rotate_zoomdown(@filename, @wipe_no(3), @rotate_time(1500000), @src_scale(250), @dst_scale(200), @scale_time(30000) )
	@bg_set(@filename, 0, 0, 0, 255, 0, @src_scale, @src_scale)
	@wipe(@wipe_no)
	@get_bg_state(0)
	@bg_ro_event(0, @rotate_time, 0, 3600, 0, 0)
	@bg_sc_event(0, @scale_time, @dst_scale, @dst_scale, 0, 2)

//-----------------------------------------------------------------
// 背景ズームダウン(拡縮率指定)
//-----------------------------------------------------------------
#macro	@bg_pan_zu_ex(@bg_name, @scale, @wipe_no(3), @time(30000), @interep(0))
	@BG_SET(@bg_name, @Off, 0, 0, 255, 0, @scale, @scale)
	@WIPE(@wipe_no)
	@BG_SC_EVENT(0, @time, 100, 100, 0, @interep)

//-----------------------------------------------------------------
// 背景拡縮しないパン
//-----------------------------------------------------------------
#macro	@bg_pan_ulr_ex(@filename, @time(10000), @wipe_no(3))
	@bg_pan_ex(@filename, @time, @wipe_no, 1)
	
#macro	@bg_pan_url_ex(@filename, @time(10000), @wipe_no(3))
	@bg_pan_ex(@filename, @time, @wipe_no, 0)

#macro	@bg_pan_ex(@filename, @time, @wipe_no, @type)
	L[0] = 140
	L[1] = 50
	if( @type ) { L[0] *= -1 }
	@bg_pan(@filename, @wipe_no, -L[0], L[0], -L[1], -L[1], 100, 100, @time, 0)

//-----------------------------------------------------------------
// 背景、バストショットフォーカス
//-----------------------------------------------------------------
#macro	@bgs_nf(@bs_name, @wipe_no(2), @wait(1))		// bg_bs_near_focus
	@bgs_nf_core($bg_name[0], @bs_name, @wipe_no, @wait)

#macro	@bgs_mf(@bs_name, @wipe_no(2), @wait(1))		// bg_bs_middle_focus
	@bgs_mf_core($bg_name[0], @bs_name, @wipe_no, @wait)

#macro	@bg_n(@bg_name)
	@bg_set(@bg_name, 0, 0, 0, 255, 0, 150, 150)

#macro	@bg_m(@bg_name)
	@bg_set(@bg_name, 0, 0, 0, 255, 0, 120, 120)

#macro	@bgs_nf_core(@bg_name, @bs_name, @wipe_no(2), @wait(1))
	if( @wait ) { close }
	@bg_n(@bg_name)
	@bs_w(@wipe_no, "bs3_" + $$ef_chop_bsname_range(@bs_name))
	if( @wait ) { @ef_common_wait(@wipe_no) }

#macro	@bgs_mf_core(@bg_name, @bs_name, @wipe_no(2), @wait(1))
	if( @wait ) { close }
	@bg_m(@bg_name)
	@bs_w(@wipe_no, "bs2_" + $$ef_chop_bsname_range(@bs_name))
	if( @wait ) { @ef_common_wait(@wipe_no) }

#macro	@bgs_fe(@bs_name("none"), @wipe_no(2), @wait(1), @range(1))		// bg_bs_focus_end
	if( @wait ) { close }
	@bg_reset(0)
	$$ef_bg_set_autopos($bg_name[0])
	if( @bs_name == "none" ) {
		@wipe(@wipe_no)
	} else {
		@bs_w(@wipe_no, "bs" + math.tostr(@range) + "_" + $$ef_chop_bsname_range(@bs_name))
		if( @wait ) { @ef_common_wait(@wipe_no) }
	}

//-----------------------------------------------------------------
// 背景移動(相対)
//-----------------------------------------------------------------
#macro	@bg_move(@add_x, @add_y, @time, @interep(0))
	$$ef_bg_move(@add_x, @add_y, @time, @interep)

#macro	@bg_move_x(@add_x, @time, @interep(0))
	$$ef_bg_move(@add_x, 0, @time, @interep)

#macro	@bg_move_y(@add_y, @time, @interep(0))
	$$ef_bg_move(0, @add_y, @time, @interep)

//-----------------------------------------------------------------
// 背景、バストショット移動(相対)
//-----------------------------------------------------------------
#macro	@bgs_move(@add_x, @add_y, @time, @interep(0))
	$$ef_bgs_move(@add_x, @add_y, @time, @interep)
	
#macro	@bgs_move_x(@add_x, @time, @interep(0))
	$$ef_bgs_move(@add_x, 0, @time, @interep)

#macro	@bgs_move_y(@add_y, @time, @interep(0))
	$$ef_bgs_move(0, @add_y, @time, @interep)

//-----------------------------------------------------------------
// バストショット表情のみ変更
//-----------------------------------------------------------------
#macro	@bf(@name1, @name2("nothing"), @name3("nothing"), @name4("nothing"), @name5("nothing"), @name6("nothing"))
	$$ef_change_bs(@name1, @name2, @name3, @name4, @name5, @name6)

#macro	@bf_w(@wipe_no, @name1, @name2("nothing"), @name3("nothing"), @name4("nothing"), @name5("nothing"), @name6("nothing"))
	@BS_WIPE_TYPE(@wipe_no)
	$$ef_change_bs(@name1, @name2, @name3, @name4, @name5, @name6)

// ---------------------------------------------------------------
// 指定時間後にバストショットを変更する(@bs_cと同じで@BCが必要になります)
// ---------------------------------------------------------------
#macro	@bf_c(@time, @name1, @name2("nothing"), @name3("nothing"), @name4("nothing"), @name5("nothing"), @name6("nothing"))
	timewait_key(@time)
	$$ef_change_bs(@name1, @name2, @name3, @name4, @name5, @name6)

//-----------------------------------------------------------------
// イベントＣＧ移動表示マクロ
// (0, 0)が中心、(320, 180)左上、(-320, -180)右下
//-----------------------------------------------------------------
#macro	@cg1_move(@filename, @src_x, @src_y, @dst_x, @dst_y, @time(3000), @wipe_no(3), @time_wait(3000), @end_wipe_no(3))
	@cg1_move_base(@filename, @src_x, @src_y, @dst_x, @dst_y, @time, @wipe_no)
	@timewaitkey(@time_wait)
	@cg1(@filename, @end_wipe_no)

#macro	@cg1_move_base(@filename, @src_x, @src_y, @dst_x, @dst_y, @time(3000), @wipe_no(3))
	close
	@cg1_set(@filename, 0, @src_x, @src_y, 255, 0, 150, 150)
	@wipe(@wipe_no)
	@get_cg1_state(0)
	@cg1_pos_event(0, @time, @dst_x, @dst_y, 0, 2)

#macro	@cg1_pan_zu(@filename, @wipe_no(3), @time(30000), @interep(0), @src_scale(120), @dst_scale(100))
	@CG1_SET(@filename, 0, 0, 0, 255, 0, @src_scale, @src_scale)
	@WIPE(@wipe_no)
	@CG1_SC_EVENT(0, @time, @dst_scale, @dst_scale, 0, @interep)

//-----------------------------------------------------------------
// 特殊イベントＣＧ(cg4)
//-----------------------------------------------------------------
#macro	@ef_cg4(@cg_name, @wipe_no(0))
	$$ef_cg4(@cg_name)
	@wipe(@wipe_no)

//-----------------------------------------------------------------
// 特殊イベントＣＧ(evcm_18)
//-----------------------------------------------------------------
#macro	@cg1_cm18(@cg_name, @wipe_no(0))
	@cg1($$ef_get_cg1801_name(@cg_name), @wipe_no)
	
#macro	@cg1_cm18_set(@BG_NAME, @WAIT(1), @POS_X(0), @POS_Y(0), @TR(255), @PATNO(0), @SCALE_X(100), @SCALE_Y(100), @ROTATE(0), @CENTER_X(640), @CENTER_Y(360))
	@cg1_set($$ef_get_cg1801_name(@BG_NAME), @WAIT, @POS_X, @POS_Y, @TR, @PATNO, @SCALE_X, @SCALE_Y, @ROTATE, @CENTER_X, @CENTER_Y)

#macro	@flash_cg(@cg_name, @wait_time(500))
	close
	front.object[4].create_rect(0, 0, 1280, 720, 255, 255, 255, 255, 1)
	front.object[4].tr_eve.set(0, 300, 0, 2)
	front.object[3].create(@cg_name, 1)
	front.object[3].tr = 255
	front.object[3].bright = 128
	front.object[3].tr_eve.set(0, 500, 0, 1)
	@timewaitkey(@wait_time)

//-----------------------------------------------------------------
// シネスコバストショット
//-----------------------------------------------------------------
#macro	@cinema_bs(@bs, @wipe_no(175), @len(100))
	close
	@sc_cinema(@len, 255, 1, 1, 1)
	@bs_w(@wipe_no, @bs)

//-----------------------------------------------------------------
// バストショットスクロール
//-----------------------------------------------------------------
#macro	@bs_scroll(@bs_name, @bg_name, @offset(@pos_t), @wipe_no(3), @end_y(@pos_m))
	close
	@bg_set_ex(@bg_name,0,0,150,150)
	$$copy_temporary_bs(back.object[@OBJ_EF_SCREEN20], @bs_name)
	@wipe(@wipe_no)
	front.object[1].y = -100
	front.object[1].y_eve.set(0, 10000, 0, 0)
	front.object[@OBJ_EF_SCREEN20].y = @offset
	front.object[@OBJ_EF_SCREEN20].y_eve.set(@end_y, 10000, 0, 0)
	@timewaitkey(1000)

//-----------------------------------------------------------------
// BG/CGの明るさ変更でのホワイトアウト
//-----------------------------------------------------------------
#macro	@cg_bright_out(@time(2000), @interep(1), @wait(1))
	front.object[@OBJ_BG01].bright_eve.set(255, @time, 0, @interep)
	if( @wait ) { @timewaitkey(@time) }
	
#macro	@cg_bright_in(@time(2000), @interep(1), @wait(1))
	front.object[@OBJ_BG01].bright = 255
	front.object[@OBJ_BG01].bright_eve.set(0, @time, 0, @interep)
	if( @wait ) { @timewaitkey(@time) }

//-----------------------------------------------------------------
// BG/CGの明るさ変更でのブラックアウト
//-----------------------------------------------------------------
#macro	@cg_dark_out(@time(2000), @interep(1), @wait(1))
	front.object[@OBJ_BG01].dark_eve.set(255, @time, 0, @interep)
	if( @wait ) { @timewaitkey(@time) }

//-----------------------------------------------------------------
// 回想エフェクト黒
//-----------------------------------------------------------------
#macro	@回想開始黒
	@回想開始("黒")

#macro	@回想開始黒スタック
	@回想開始スタック("黒")

//-----------------------------------------------------------------
// 回想エフェクト背景スタックバージョン
//-----------------------------------------------------------------
#macro	@回想開始スタック(@color("白"))
	$$ef_recollect_stack_push
	@回想開始(@color)

#macro	@回想終了スタック(@wipe_no(3))
	close
	$$ef_recollect_stack_pop
	L[1] =  $disp
	@回想終了
	@wipe(@wipe_no)
	if( L[1] == _disp_bs ) { @ef_common_wait(@wipe_no) }
	$bs_wipe_set = 0

//-----------------------------------------------------------------
// BGMスタック
//-----------------------------------------------------------------
#macro	@bgm_stack
	$$ef_bgm_stack_push

#macro	@bgm_pop_play(@fade_time(-1))
	K[0] = $$ef_bgm_stack_pop
	if( K[0] != "" ) {
		@bgm_play(K[0], @fade_time, @fade_time)
	} else {
		//@debug("bgm_stackが行われていません。bgmを再生できません")
	}


//-----------------------------------------------------------------
// アイキャッチ(フェード含み)
//-----------------------------------------------------------------
#macro	@アイキャッチフェード(@start_wipe(2), @end_wipe(3), @bg_name_disp(1))
	$fade_dup = @Off
	@fade(bg_siro, @start_wipe)
	$fade_dup = @Off
	@アイキャッチ
	@fade(bg_siro, @end_wipe)
	if( @bg_name_disp ) { @背景名表示 }
	$fade_dup = @Off


//-----------------------------------------------------------------
// 場所移動用マクロ
//-----------------------------------------------------------------
#macro	@移動(@bg_name, @cutin_disp(0))
	@fade(bg_kuro, 25)
	if( @cutin_disp ) { @背景名表示 }
	@bg(@bg_name, 25)

//-----------------------------------------------------------------
// その場で時間経過マクロ
//-----------------------------------------------------------------
#macro	@その場で時間経過
	@bg_stack_push
	K[0] = @bg_stack_pop_name
	if( $$is_exist_g00(K[0]) ) {
		@移動(K[0])
	}

//-----------------------------------------------------------------
// フェード
//-----------------------------------------------------------------
#macro	@フェードウェイトなし(@time(3000), @red(0), @green(0), @blue(0), @wipe_copy(0))
	front.object[@OBJ_EF_SCREEN25].create_rect(0, 0, @screen_width, @screen_height, @red, @green, @blue, 255)
	front.object[@OBJ_EF_SCREEN25].layer = 10000
	front.object[@OBJ_EF_SCREEN25].tr = 0
	front.object[@OBJ_EF_SCREEN25].tr_eve.set(255, @time, 0, 0)
	front.object[@OBJ_EF_SCREEN25].disp = 1
	front.object[@OBJ_EF_SCREEN25].wipe_copy = @wipe_copy

#macro	@フェードウェイトなし消去
	front.object[@OBJ_EF_SCREEN25].wipe_copy = 0

//-----------------------------------------------------------------
// 背景名表示カットイン
//-----------------------------------------------------------------
#macro	@背景名表示(@time(0))
	$$set_bg_name_start_time(@time)
	$$ef_bg_name_cutin_event

//-----------------------------------------------------------------
// 背景名表示有効/無効設定(コンフィグとは別の強制ON/OFFマクロ)
//-----------------------------------------------------------------
#macro	@背景名表示無効
	$$ef_bg_name_set_enabled(1)

#macro	@背景名表示有効
	$$ef_bg_name_set_enabled(0)

//-----------------------------------------------------------------
// 演出ワイプ用timewaitkeyの実行
//-----------------------------------------------------------------
#macro	@ef_common_wait(@wipe_no)
	@timewaitkey($$ef_get_wipe_time(@wipe_no))


//-----------------------------------------------------------------
// SSSロゴ表示
//-----------------------------------------------------------------
#macro	@ＳＳＳロゴ
	@sc_layer_bg
	@sc_filter_b(32, 750, 0)
	$$ef_mini_cutin_show(front.object[$$ef_get_omv_index(0)], ef_sss_logo)

#macro	@ＳＳＳロゴ消去
	@sc_del
	$$ef_mini_cutin_hide(front.object[$$ef_get_omv_index(0)])

//-----------------------------------------------------------------
// ガルデモチラシ表示
//-----------------------------------------------------------------
#macro	@ガルデモチラシ
	$$ef_mini_cutin_show(front.object[$$ef_get_omv_index(0)], ef_gdm)

#macro	@ガルデモチラシ消去
	$$ef_mini_cutin_hide(front.object[$$ef_get_omv_index(0)])

//-----------------------------------------------------------------
// 野田マスク
//-----------------------------------------------------------------
#macro	@野田マスク(@bs_name, @wipe_copy(0))
	mask[10].init
	mask[10].create(ef_nd_mask)
	@bs(@bs_name)
	L[0] = $$get_bs_obj_index(@bs_name)
	front.object[L[0]].mask_no = 10
	front.object[L[0]].mono = 255
	front.object[L[0]].wipe_copy = @wipe_copy
	
#macro	@野田マスク消去(@bs_name)
	L[0] = $$get_bs_obj_index(@bs_name)
	front.object[L[0]].wipe_copy = 0

//-----------------------------------------------------------------
// 空から見守る
//-----------------------------------------------------------------
#macro	@空から見守る(@bs_name, @add_x(0), @mono(255), @tr(228))
	mask[10].init
	mask[10].create(ef_nd_mask)
	mask[10].x += @add_x
	@bs_w(3, @bs_name)
	L[0] = $$get_bs_obj_index(@bs_name)
	front.object[L[0]].x_eve.end
	front.object[L[0]].x += @add_x
	front.object[L[0]].mask_no = 10
	front.object[L[0]].mono = @mono
	front.object[L[0]].tr = @tr

//-----------------------------------------------------------------
// 椅子ロケット
//-----------------------------------------------------------------
#macro	@椅子ロケット
	$$ef_create_omv_loop(back, ef_sline_v, 0, 0, 0, 2000)
	L[0] = $$ef_get_omv_index(0)
	L[1] = $$ef_get_omv_index(1)
	back.object[L[0]].blend = 0
	back.object[L[0]].layer = 100
	back.object[L[0]].wipe_copy = 1
	back.object[L[1]].create(ef_sline_bg, 1)
	back.object[L[1]].layer = -10
	back.object[L[1]].wipe_copy = 1
	back.object[L[1]].y_eve.loop(0, -300, 200, 0, 0)

#macro	@椅子ロケット消去
	front.object[$$ef_get_omv_index(0)].wipe_copy = 0
	front.object[$$ef_get_omv_index(1)].wipe_copy = 0

//-----------------------------------------------------------------
// 日向フィルター
//-----------------------------------------------------------------
#macro	@日向フィルター
	@SC_CINEMA_SET(1, 750, 160, 240, 119, 233, 160, 2, 0)
	@sc_layer_bg
	@sc_filter_w(128)
	$$ef_create_omv_loop(back, ef_twinkle, 0, 0, 0, 1000)
	L[0] = $$ef_get_omv_index(0)
	back.object[L[0]].blend = 1
	back.object[L[0]].wipe_copy = 1

#macro	@日向フィルター消去
	@sc_cinema_off
	@sc_del
	front.object[$$ef_get_omv_index(0)].wipe_copy = 0

//-----------------------------------------------------------------
// 彼方へ飛んでいく
//-----------------------------------------------------------------
#macro	@彼方へ飛んでいく(@bs_name)
	mask[10].init
	mask[10].create(ef_nd_mask)
	@bs(@bs_name)
	L[0] = $$get_bs_obj_index(@bs_name)
	if( L[0] != -1 ) {
		front.object[L[0]].mask_no = 10
	}
	front.object[L[0]].center_y = 180
	front.object[L[0]].scale_x_eve.set(300, 1000, 0, 2)
	front.object[L[0]].scale_y_eve.set(300, 1000, 0, 2)
	front.object[L[0]].rotate_z_eve.set(9600, 1500, 0, 2)
	front.object[L[0]].tr_eve.set(0, 1000, 0, 0)

//-----------------------------------------------------------------
// 魂浄化
//-----------------------------------------------------------------
#macro	@魂浄化
	L[0] = $$ef_get_omv_index(0)
	back.object[L[0]].create(sys_tm_ef01, 1, @screen_center_x, 300)
	$$set_image_center(back.object[L[0]])
	back.object[L[0]].tr = 0
	back.object[L[0]].blend = 1
	back.object[L[0]].tr_eve.set(255, 2000, 0, 1)
	back.object[L[0]].x_eve.turn(@screen_center_x - 10, @screen_center_x + 10, 3000, 0, 2)
	back.object[L[0]].y_eve.set(-200, 30000, 0, 2)

//-----------------------------------------------------------------
// バストショット影
//-----------------------------------------------------------------
#macro	@バストショット黒影(@bs_name, @add_x(0), @wipe_copy(0), @bs_tr(128))
	$$copy_temporary_bs(back.object[@OBJ_EF_SCREEN20], @bs_name)
	back.object[@OBJ_EF_SCREEN20].x += @add_x
	back.object[@OBJ_EF_SCREEN20].dark = 255
	back.object[@OBJ_EF_SCREEN20].tr = @bs_tr
	back.object[@OBJ_EF_SCREEN20].wipe_copy = @wipe_copy

#macro	@バストショット白影(@bs_name, @add_x(0), @wipe_copy(0), @bs_tr(128))
	$$copy_temporary_bs(back.object[@OBJ_EF_SCREEN20], @bs_name)
	back.object[@OBJ_EF_SCREEN20].x += @add_x
	back.object[@OBJ_EF_SCREEN20].bright = 255
	back.object[@OBJ_EF_SCREEN20].tr = @bs_tr
	back.object[@OBJ_EF_SCREEN20].wipe_copy = @wipe_copy

//-----------------------------------------------------------------
// ギルドエフェクト：ハンマートラップ(reverse 1 or -1)
//-----------------------------------------------------------------
#macro	@ハンマートラップセット(@reverse(1))
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].create(ef_guild_trap01, 1, @screen_center_x - @screen_width * @reverse, -150)
	front.object[L[0]].rotate_z = 100 * @reverse

#macro	@ハンマートラップ発動(@reverse(1), @move_time(300), @start_time(0))
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].x_eve.set(@screen_center_x + @screen_width * @reverse, @move_time, @start_time, 2)
	front.object[L[0]].rotate_z_eve.set(0, @move_time, @start_time, 2)

#macro	@ハンマートラップ発動拡大
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].set_scale(2000, 2000)
	front.object[L[0]].y -= 500
	front.object[L[0]].x_eve.set(@screen_center_x + @screen_width * 2, 300, 0, 2)
	front.object[L[0]].rotate_z_eve.set(0, 100, 0, 2)

#macro	@ハンマーぷらーん(@add_x(0), @wipe_copy(0))
	L[0] = $$ef_get_omv_index(0)
	back.object[L[0]].create(ef_guild_trap01, 1, @screen_center_x + @add_x, -140)
	back.object[L[0]].frame_action.start(-1, "$$ef_trap_rot_eve")
	back.object[L[0]].wipe_copy = @wipe_copy
	
#macro	@ハンマー消去
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].wipe_copy = 0

//-----------------------------------------------------------------
// ギルドエフェクト：煙幕
//-----------------------------------------------------------------
#macro	@煙幕(@flash(1))
	if( @flash ) {
		@sc_flash(300, 1, 0 , 0, "None", 160, 160, 160)
	}
	$$ef_create_omv_loop(front, ef_gtrap_smoke00, 0, 0, 0, 2000)
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].wipe_copy = 1
	front.object[L[0]].tr = 0
	front.object[L[0]].tr_eve.set(255, 1000, 0, 0)


#macro	@煙幕消去
	front.object[$$ef_get_omv_index(0)].wipe_copy = 0

//-----------------------------------------------------------------
// ギルドエフェクト：レーザートラップ
//-----------------------------------------------------------------
#macro	@レーザートラップ１
	$$ef_create_guild_trap_laser(back.object[$$ef_get_omv_index(1)], 0)

#macro	@レーザートラップ２
	$$ef_create_guild_trap_laser(back.object[$$ef_get_omv_index(1)], 1)

#macro	@レーザートラップ３
	$$ef_create_guild_trap_laser(back.object[$$ef_get_omv_index(1)], 2)

#macro	@レーザートラップ拡大(@scale, @time, @start_time(0), @interep(1))
	front.object[$$ef_get_omv_index(1)].scale_x_eve.set(@scale, @time, @start_time, @interep)
	front.object[$$ef_get_omv_index(1)].scale_y_eve.set(@scale, @time, @start_time, @interep)

#macro	@レーザートラップ背景移動(@ax(0), @ay(0), @time(500), @interep(2))
	if( @ax ) { front.object[$$ef_get_omv_index(1)].x_eve.set(@ax, @time, 0, @interep) }
	if( @ay ) { front.object[$$ef_get_omv_index(1)].y_eve.set(@ay * 2, @time, 0, @interep) }
	@BG_POS_EVENT(0, @time, @ax, @ay, 0, @interep)
	
#macro	@レーザートラップ消去
	front.object[$$ef_get_omv_index(1)].wipe_copy = 0

//-----------------------------------------------------------------
// 格闘エフェクト：剣戟(大)
//-----------------------------------------------------------------
#macro	@剣戟＿大(@type(32), @obj_index(0), @scale(7000), @add_x(0), @add_y(0), @omv_name(ef_ag_battle01))
	L[0] = $$ef_get_omv_index(@obj_index)
	$$ef_create_omv(front, @omv_name, @obj_index, @screen_center_x, @screen_center_y, @scale)
	front.object[L[0]].set_center(256, 256)
	front.object[L[0]].layer = 1000
	
	switch( @type ) {
	case(32)	L[1] = 0
	case(2)		L[1] = 300
	case(12)	L[1] = 600
	case(1)		L[1] = 900
	case(4)		L[1] = 1200
	case(7)		L[1] = 1500
	case(78)	L[1] = 1800
	case(8)		L[1] = 2100
	case(98)	L[1] = 2400
	case(9)		L[1] = 2700
	case(6)		L[1] = 3000
	case(3)		L[1] = 3300
	}
	
	front.object[L[0]].set_pos(front.object[L[0]].x + @add_x, front.object[L[0]].y + @add_y)
	front.object[L[0]].rotate_z = L[1]

//-----------------------------------------------------------------
// 格闘エフェクト：衝撃
//-----------------------------------------------------------------
#macro	@衝撃(@obj_index(0), @scale(1000), @add_x(0), @add_y(0), @omv_name(ef_ag_battle02))
	L[0] = $$ef_get_omv_index(@obj_index)
	$$ef_create_omv(front, @omv_name, @obj_index, @screen_center_x, @screen_center_y, @scale)

//-----------------------------------------------------------------
// 格闘エフェクト：近づいてくる剣戟
//-----------------------------------------------------------------
#macro	@近づいてくる剣戟
	@剣戟＿大(9, 0, 1000)	@timewaitkey(150)
	@剣戟＿大(3, 1, 2000)	@timewaitkey(150)
	@剣戟＿大(78, 2, 5000)	@timewaitkey(150)


//-----------------------------------------------------------------
// 格闘エフェクト：天使：銃弾を剣戟ではじく
//-----------------------------------------------------------------
#macro	@銃弾を剣戟ではじく(@pos_x(0), @pos_y(0))
	@剣戟＿大(32, 0, 3000, @pos_x, @pos_y, ef_ag_battle03)

#macro	@銃弾を剣戟ではじく連続(@pos_x(0), @pos_y(0))
	@剣戟＿大(78, 0, 3000, 400, 150, ef_ag_battle03)	@timewaitkey(300)
	@剣戟＿大(32, 1, 3000, -400, -200, ef_ag_battle03)


//-----------------------------------------------------------------
// 格闘エフェクト：ディストーション反射
//-----------------------------------------------------------------
#macro	@ディストーション反射(@obj_index(0), @add_x(0), @add_y(0), @scale(1000))
	$$ef_create_omv(front, ef_gs_dt01, @obj_index, @screen_center_x, @screen_center_y, @scale)
	L[0] = $$ef_get_omv_index(@obj_index)
	$$set_image_center(front.object[L[0]])
	front.object[L[0]].x += @add_x
	front.object[L[0]].y += @add_y
	front.object[L[0]].blend = 1
	front.object[L[0]].layer = 1000
	front.object[L[0]].order = 1

#macro	@ディストーション反射終了
	for( L[0] = 0, L[0] < 10, L[0] += 1 )
	{
		front.object[$$ef_get_omv_index(L[0])].order = 0
	}
	
//-----------------------------------------------------------------
// 格闘エフェクト：天使ディレイ発動
//-----------------------------------------------------------------
#macro	@天使ディレイ発動
	$$ef_angel_delay_start


//-----------------------------------------------------------------
// 格闘エフェクト：天使ディレイで避ける
//-----------------------------------------------------------------
#macro	@天使ディレイで避ける(@bs_name, @add_x(200), @wipe_no(2))
	$$ef_angel_delay_avoid(@bs_name, @add_x)
	@bs_set_pos_time(500, 0, 2, 0)
	@bs_set(500, @bs_name, front.object[$$get_bs_obj_index(@bs_name)].x + @add_x, @pos_z1, @pos_m, 0, 2, 0)
	@wipe(@wipe_no)
;	front.object[$$ef_get_omv_index(0)].wipe_copy = 0
;	front.object[$$ef_get_omv_index(1)].wipe_copy = 0
	
//-----------------------------------------------------------------
// 格闘エフェクト：天使ディストーション
//-----------------------------------------------------------------
#macro	@天使ディストーション(@close(1), @wait(1))
	if( @close ) { close }
	$$ef_angel_guard
	if( @wait ) { timewait(3000) }

//-----------------------------------------------------------------
// 格闘エフェクト：天使ディストーション
//-----------------------------------------------------------------
#macro	@天使ディストーション反射
	L[1] = 1500
	L[2] = 320
	front.object[$$ef_get_omv_index(9)].create_rect(0, 0, 1280, 720, 0, 255, 255, 64, 1)
	front.object[$$ef_get_omv_index(9)].tr_eve.set(0, 1500, 0, 0)
	@pcmch_play(10, @ディストーション単発)	@ディストーション反射(0, 200, 200, L[1])	@timewaitkey(L[2])
	@pcmch_play(11, @ディストーション単発)	@ディストーション反射(1, -150, -200, L[1])	@timewaitkey(L[2])
	@pcmch_play(12, @ディストーション単発)	@ディストーション反射(2, 170, -100, L[1])	@timewaitkey(L[2])
	@pcmch_play(13, @ディストーション単発)	@ディストーション反射(3, -50, 220, L[1])	@timewaitkey(L[2])
	@pcmch_play(14, @ディストーション単発)	@ディストーション反射(4, -90, 0, L[1])		@timewaitkey(L[2])

//-----------------------------------------------------------------
// 格闘エフェクト：天使ハンドソニック(ev06)
//-----------------------------------------------------------------
#macro	@天使ハンドソニック_evcm06
	$$ef_create_omv(front, ef_ev06_hs00, 0, 0, 0, 1000)
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].blend = 1
	front.object[L[0]].set_movie_auto_free(0)

//-----------------------------------------------------------------
// 格闘エフェクト：天使ディストーション(ev06)
//-----------------------------------------------------------------
#macro	@天使ディストーション_evcm06
	$$ef_create_omv(front, ef_ev06_dt00, 0, 0, 0, 1000)
	L[0] = $$ef_get_omv_index(0)
	front.object[L[0]].set_movie_auto_free(1)

//-----------------------------------------------------------------
// 影消える
//-----------------------------------------------------------------
#macro	@影消える(@name)
	L[0] = $$get_bs_obj_index(@name)
	front.object[L[0]].scale_x_eve.set(3000, 2500, 0, 1)
	front.object[L[0]].dark_eve.set(255, 1000, 0, 2)
	front.object[L[0]].tr_eve.set(0, 1000, 0, 1)
	@bs_wipe_type(71)

//-----------------------------------------------------------------
// 直井催眠術
//-----------------------------------------------------------------
#macro	@直井催眠術
	close
	@sc_layer_bg
	@sc_filter_b(128)
	@bs_wipe_type(252)
	@pcmch_play_loop(2, @高周波, 1000)// 効果音（直井の催眠術）

//-----------------------------------------------------------------
// 直井催眠術消去
//-----------------------------------------------------------------
#macro	@直井催眠術消去
	@sc_del
	@pcmch_stop(2, 500)

//-----------------------------------------------------------------
// ピンクフィルター
//-----------------------------------------------------------------
#macro	@ピンクフィルター
	L[0] = $$ef_get_omv_index(0)
	back.object[L[0]].create(ef_hn_ku01, 1)
	back.object[L[0]].wipe_copy = 1
	back.object[L[0]].blend = 4
	back.object[L[0]].layer = 0
	back.object[L[0]].tr = 100

#macro	@ピンクフィルター消去
	front.object[$$ef_get_omv_index(0)].wipe_copy = 0

//-----------------------------------------------------------------
// ライフルスコープ
//-----------------------------------------------------------------
#macro	@ライフルスコープ
	L[0] = $$ef_get_omv_index(1)
	back.object[L[0]].create(ef_scope, 1)
	back.object[L[0]].layer = 1000
	back.object[L[0]].wipe_copy = 1

#macro	@ライフルスコープ消去
	front.object[$$ef_get_omv_index(1)].wipe_copy = 0

//-----------------------------------------------------------------
// 音無過去瀕死フィルター
//-----------------------------------------------------------------
#macro	@音無過去瀕死フィルター
	L[0] = $$ef_get_omv_index(1)
	back.object[L[0]].create(ef_ot_mask, 1)
	back.object[L[0]].layer = 1000
	back.object[L[0]].wipe_copy = 1

#macro	@音無過去瀕死フィルター消去
	front.object[$$ef_get_omv_index(1)].wipe_copy = 0

//-----------------------------------------------------------------
// 直井過去『…死んだのはお前だ』
//-----------------------------------------------------------------
#macro	@直井過去_…死んだのはお前だ(@type, @msg, @koe_no(-1), @chara_no(-1), @namae("none"))
	close
	$$ef_rec_na01(@type, @msg, @koe_no, @chara_no, @namae)

//-----------------------------------------------------------------
// 雪
//-----------------------------------------------------------------
#macro	@雪１		// 通常
	L[0] = $$ef_get_omv_index(0)
	back.object[L[0]].create_weather(ef_snow, 1)
	back.object[L[0]].set_weather_param_type_A(
		cnt = 30,
		move_time_x = 0,
		move_time_y = 10000,
		pat_mode = 0,
		pat_no_1 = 0,
		sin_time_x = 2000,
		sin_power_x = 5,
		scale_x = 100,
		scale_y = 100
		)
	L[1] = $$ef_get_omv_index(1)
	back.object[L[1]].create_weather(ef_snow, 1)
	back.object[L[1]].set_weather_param_type_A(
		cnt = 10,
		move_time_x = 0,
		move_time_y = 10000,
		pat_mode = 0,
		pat_no_1 = 0,
		sin_time_x = 2000,
		sin_power_x = 5,
		scale_x = 400,
		scale_y = 400
		)

#macro	@雪２		// 見上げる
	L[0] = $$ef_get_omv_index(0)
	back.object[L[0]].create_weather(ef_snow, 1)
	back.object[L[0]].set_weather_param_type_B(
		cnt = 50,
		pat_mode = 0,
		pat_no_1 = 0,
		center_x = @screen_center_x,
		center_y = @screen_center_y,
		appear_range = 70,
		move_time = 7000,
		sin_time_x = 3000,
		sin_power_x = 10,
		zoom_min = 0,
		zoom_max = 2000
		)

//-----------------------------------------------------------------
// 音無称号
//-----------------------------------------------------------------
#macro	@音無称号(@type)
	@bgm_pause(500)
	$$ef_otonashi_title(@type)
	@bgm_resume(1000)

//-----------------------------------------------------------------
// 日向ケツキック
//-----------------------------------------------------------------
#macro	@日向ケツキック
	close
	@pcmch_play(0, @尻キック)// 効果音(音無に日向の蹴り)
	@timewaitkey(200)
	@横揺れ_強(1)

#macro	@日向パンチ
	@bs
	close
	@pcmch_play(0, @殴る)// 効果音(日向が音無を殴る)
	@横揺れ_強(1)

//-----------------------------------------------------------------
// キャッキャウフフ
//-----------------------------------------------------------------
#macro	@キャッキャウフフ開始(@bs_name, @wipe_no, @wait(1))
	
	if( @wait ) { close }
	@bg_stack_push
	
	$$kyakya_ufufu
	
	if( @bs_name != "none" ) {
		@bs_w(@wipe_no, "bs3_" + $$ef_chop_bsname_range(@bs_name))
	} else {
		@wipe(@wipe_no)
	}
	if( @wait ) { @ef_common_wait(@wipe_no) }


#macro	@キャッキャウフフ終了フェード準備(@bg_wipe(1))
	if( @bg_wipe ) {
		front.object[$$ef_get_omv_index(0)].wipe_copy = 0
	}
	$$kyakya_ufufu_end

#macro	@キャッキャウフフ終了フェード
	@キャッキャウフフ終了フェード準備
	@bg(bg_siro, 3)

#macro	@キャッキャウフフレベルキャップ解放
	$$add_kyakya_level_cap
	
#macro	@キャッキャウフフ終了(@bg_name("none"), @bgm_name("none"))
	$$add_kyakya_level		// キャッキャウフフレベルアップ
	@bgm_stop(2000)
	@fade_all(bg_siro, 5, 1)
	@timewaitkey(2000)
	if( @bgm_name != "none" ) { @bgm_play(@bgm_name) }
	if( @bg_name  == "none" ) { @bg(@bg_stack_pop_name) }
	else					  { @bg(@bg_name) }

#macro	@３人でキャッキャウフフ開始(@bg_name, @bs_name1, @bs_name2, @wipe_no(3), @wait(1000))
	close
	mask[09].init
	mask[10].init
	mask[09].create(ef_nd_mask)
	mask[09].x -= 200
	mask[10].create(ef_nd_mask)
	mask[10].x += 200
	$$ef_create_omv_loop(back, ef_hn_ku03, 0, 0, 0, 2000)
	$$ef_create_omv_loop(back, ef_hn_ku02, 1, 0, 0, 2000)
	back.object[$$ef_get_omv_index(2)].create(ef_hn_ku01, 1)
	back.object[$$ef_get_omv_index(2)].tr = 100
	@bg_set(@bg_name)
	@bs_set(-1, @bs_name1, @pos_l)
	@bs_set(-1, @bs_name2, @pos_r)
	@wipe(@wipe_no)
	front.object[$$get_bs_obj_index(hn)].mask_no = 9
	front.object[$$get_bs_obj_index(nd)].mask_no = 10
	@timewaitkey(@wait)

//-----------------------------------------------------------------
// evcm_4101関連
//-----------------------------------------------------------------
// evcm41表示
#define	@CM41_DISP_TYPE_TOP			0
#define	@CM41_DISP_TYPE_BOTTOM		1
#define	@CM41_DISP_TYPE_CENTER		2
#define	@CM41_DISP_TYPE_HALF_TOP	3
#define	@CM41_DISP_TYPE_HALF_BOTTOM	4

#macro	@CG_CM41(@CG_NAME, @SEL(0), @WAIT(1), @disp_type(@CM41_DISP_TYPE_BOTTOM))
	@CG_CM41_SET(@CG_NAME, @SEL, @WAIT, @disp_type)
	$wipe($bg_wipe[0])

#macro	@CG_CM41_SET(@CG_NAME, @SEL(0), @WAIT(1), @disp_type(@CM41_DISP_TYPE_BOTTOM))
	$bg_type = _type_cg1
	// ------------------------ $bg_disp_in(@CG_NAME, @SEL, @WAIT, @OFF, @OFF)
	$bg_name[0] = @CG_NAME
	$bg_wipe[0] = @SEL
	$wipe_wait  = @WAIT
	$sys_wipe   = @OFF
	$fade_wmnd  = @OFF
	
	$$evcm41_disp(0, @disp_type)

#macro	@cg_cm41_scroll(@disp_type, @time, @interep(0))
	$$evcm41_scroll(@f.obj[@OBJ_BG01], @disp_type, @time, @interep)

#macro	@cg_cm41_scroll_wipe(@CG_NAME, @src_disp_type, @dst_disp_type, @time, @SEL(0), @WAIT(1), @interep(0))
	@CG_CM41_SET(@CG_NAME, @SEL, @WAIT, @src_disp_type)
	$$evcm41_scroll(@b.obj[@OBJ_BG01], @dst_disp_type, @time, @interep)
	$wipe($bg_wipe[0])

//-----------------------------------------------------------------
// ＯＰムービー
//-----------------------------------------------------------------
#macro	@ＯＰムービー
	$$play_movie


//-----------------------------------------------------------------
// 関数
//-----------------------------------------------------------------
#command $$set_child_object(object, int)
#command $$is_exist_g00(str) : int
#command $$set_image_center(object)
#command $$set_scale_eve(object, int, int, int, int)

#command $$ef_bg_set_autopos(str) : str					// 背景の位置自動設定
#command $$ef_change_bs(str, str, str, str, str, str)	// バストショット表情変更
#command $$ef_chop_bsname_range(str) : str				// バストショット名、距離の切り落とし
#command $$ef_bg_move(int, int, int, int)				// 背景の移動
#command $$ef_bgs_move(int, int, int, int)				// 背景、バストショットの同時移動
#command $$ef_recollect_stack_push						// 回想用背景スタックpush
#command $$ef_recollect_stack_pop						// 回想用背景スタックpop
#command $$ef_bgm_stack_push							// BGMスタックpush
#command $$ef_bgm_stack_pop : str						// BGMスタックpop
#command $$ef_get_wipe_time(int) : int					// ワイプ時間の取得
#command $$ef_create_omv(stage, str, int, int, int, int)		// 演出用OMVの作成
#command $$ef_create_omv_loop(stage, str, int, int, int, int)	// 演出用OMVの作成
#command $$ef_get_omv_index(int) : int					// 演出用OMVオブジェクトインデックスを取得
#command $$ef_get_emo_index(str) : int					// エモーションオブジェクトのインデックスを取得
#command $$ef_cg4(str)									// cg4
#command $$ef_get_cg1801_name(str) : str				// cg1801

#command $$ef_mini_cutin_show(object, str)				// ミニカットイン表示
#command $$ef_mini_cutin_hide(object)					// ミニカットイン消去

#command $$ef_create_guild_trap_laser(object, int)		// ギルドトラップ(レーザー)
#command $$ef_trap_rot_eve(frameaction, object)			// ハンマートラップ用eve

#command $$ef_bg_name_set_enabled(int)					// 背景名の表示の有効/無効設定
#command $$ef_bg_name_cutin_event						// 背景名表示イベントの発行
#command $$ef_bg_name_cutin								// 背景名の表示
#command $$ef_bg_name_cutin_before						// 背景名の表示(前処理)
#command $$set_bg_name_start_time(int)					// 背景名表示の開始時間を設定

#command $$ef_angel_delay_start							// 天使ディレイ発動
#command $$ef_angel_delay_avoid(str, int)				// 天使ディレイで避ける
#command $$ef_angel_guard								// 天使ディストーション

#command $$kyakya_ufufu									// キャッキャウフフ
#command $$kyakya_ufufu_end								// キャッキャウフフ終了
#command $$add_kyakya_level								// キャッキャウフフレベル増加
#command $$add_kyakya_level_cap							// キャッキャウフフレベルキャップ増加

#command $$ef_rec_na01(int, str, int, int, str)			// 直井過去『…死んだのはお前だ』

#command $$ef_otonashi_title(int)						// 音無称号
#command $$ef_otonashi_title_bg

#command $$play_movie(str, int) : int					// ムービー再生
#command $$trial_end									// 体験版告知

#command $$evcm41_disp(int, int)						// evcm41
#command $$evcm41_scroll(object, int, int, int)			// evcm41スクロール
#command $$get_cm41_pos(object, int) : int				// evcm41の表示タイプから位置取得

#command $$fa_flicker_set(object, int, int, int, int, int)	// 明滅の設定
#command $$fa_flicker(frameaction, object)					// 明滅の実行
#command $$create_filter_random_flash(int, int, int, int)

//-----------------------------------------------------------------
// 服装初期化関数をグローバルにしました
//-----------------------------------------------------------------
#command $bs_dress_init									// _sc_sys_set_gsd.ss

