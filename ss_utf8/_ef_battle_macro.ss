//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_battle_macro.ss
//	@author		Kazuya Takahashi
//	@note		バトル処理
//
//-----------------------------------------------------------------------------------------------

#inc_start
	
	#define		@combo_obj				front.object[$$ef_get_omv_index(0)]
	#define		@battle_obj				front.object[$$ef_get_omv_index(1)]
	#define		@combo_number_obj		front.object[$$ef_get_omv_index(3)]
	#define		@knockout_obj			front.object[$$ef_get_omv_index(4)]
	
	#define		<LIFE_MAX>				100
	#define		<COMBO_OBJ_LAYER>		100000
	#define		<BATTLE_MASK_INDEX>		10
	
	#property	$voice_battle_start_koe_no
	#property	$voice_battle_start_chara_no
	#property	$voice_battle_combo_koe_no		: intlist[100]
	#property	$voice_battle_combo_chara_no	: intlist[100]
	
#inc_end

#z00

//----------------------------------------------------------------------
// バトル開始
//----------------------------------------------------------------------
command $$battle_start
{
	$$create_battle_object
	
	$$create_battle_info(@battle_obj.child[0])
	$$create_battle_lifebar(@battle_obj.child[1], "l", "ot")	// 1P
	$$create_battle_lifebar(@battle_obj.child[2], "r", "nd")	// 2P
}

command $$create_battle_object
{
	$$set_child_object(@battle_obj, 3)
	$$set_battle_object(@battle_obj)
}

//----------------------------------------------------------------------
// バトル終了
//----------------------------------------------------------------------
command $$battle_end
{
	@battle_obj.y_eve.set(-300, 500, 0, 2)
	@battle_obj.tr_eve.set(0, 500, 0, 2)
	
	@combo_obj.wipe_copy = 0
	@battle_obj.wipe_copy = 0
	@combo_number_obj.wipe_copy = 0
	@knockout_obj.wipe_copy = 0
	
	$$init_battle_voice
}

//----------------------------------------------------------------------
// バトルオブジェクトの設定
//----------------------------------------------------------------------
command $$set_battle_object(property $obj : object)
{
	$obj.layer = <COMBO_OBJ_LAYER>
	$obj.wipe_copy = 1
}

//----------------------------------------------------------------------
// バトルオブジェクト(情報)作成
//----------------------------------------------------------------------
command $$create_battle_info(property $obj : object)
{
	$obj.create(ef_battle_info, 1, @screen_center_x, 0)
	
	$obj.y = -$obj.get_size_y
	$obj.tr = 0
	
	$obj.y_eve.set(0, 200, 0, 2)
	$obj.tr_eve.set(255, 200, 0, 2)
}

//----------------------------------------------------------------------
// バトルオブジェクト(ライフバー)作成
//----------------------------------------------------------------------
command $$create_battle_lifebar_1P(property $chara : str){ $$create_battle_object	$$create_battle_lifebar(@battle_obj.child[1], "l", $chara) }
command $$create_battle_lifebar_2P(property $chara : str){ $$create_battle_object	$$create_battle_lifebar(@battle_obj.child[2], "r", $chara) }

command $$create_battle_lifebar(property $obj : object, property $type : str, property $chara : str)
{
	property $chara_pat
	property $name_pat
	property $mask_index
	
	// ベース背景
	$obj.create("ef_battle_lifebar_" + $type, 1, 0, 10)
	
	$$set_child_object($obj, 3)
	
	// キャラクター
	$obj.child[0].create("ef_battle_character_" + $type, 1, 0, 10)
	if( $type == "r" ) {
		$obj.child[0].x = $obj.get_size_x - $obj.child[0].get_size_x
	}
	
	$$set_child_object($obj.child[0], 1)
	$obj.child[0].child[0].create("ef_battle_character_" + $type, 1, 0, 0, $$get_battle_lifebar_chara_pat($chara))
	
	// キャラクター名
	$obj.child[1].create("ef_battle_character_name", 1, 112, 42, $$get_battle_lifebar_chara_name_pat($chara))
	if( $type == "r" ) {
		$obj.child[1].x += 74
	}
	
	// ライフバー
	$obj.child[2].create("ef_battle_lifebar_" + $type, 1, 0, 0, 1)
	if( $type == "r" )	{ $mask_index = $$get_battle_mask_index(1)	L[1] = @screen_width - $obj.get_size_x }
	else				{ $mask_index = $$get_battle_mask_index(0)	L[1] = 0}
	
	mask[$mask_index].init
	mask[$mask_index].create("ef_battle_lifebar_" + $type + "_mask")
	mask[$mask_index].y = $obj.y
	$obj.child[2].mask_no = $mask_index
	
	// 表示アニメーション
	if( $type == "r" )
	{
		L[0] = @screen_width + $obj.get_size_x
		L[1] = @screen_width - $obj.get_size_x
		L[2] = L[1]
		if( $ef_life[1] < 100 ) {
			L[2] = (410 * 100 / 100) * $ef_life[1] / 100
		}
	}
	else
	{
		L[0] = -$obj.get_size_x
		L[1] = 0
	}
	
	$obj.x = L[0]
	$obj.x_eve.set(L[1], 300, 0, 2)
	
	mask[$mask_index].x = L[0]
	mask[$mask_index].x_eve.set(L[2], 300, 0, 2)
	
	$obj.tr = 0
	$obj.tr_eve.set(255, 300, 0, 1)
}

//----------------------------------------------------------------------
// ライフバーに表示するキャラクター画像パターン番号を取得
//----------------------------------------------------------------------
command $$get_battle_lifebar_chara_pat(property $chara : str) : int
{
	property $chara_pat
	
	switch( $chara ) {
	case("ot")	$chara_pat = 1
	case("nd")	$chara_pat = 2
	}
	
	return ($chara_pat)
}

//----------------------------------------------------------------------
// ライフバーに表示するキャラクター名画像パターン番号を取得
//----------------------------------------------------------------------
command $$get_battle_lifebar_chara_name_pat(property $chara : str) : int
{
	property $name_pat
	
	switch( $chara ) {
	case("ot")	switch (@音無_呼び方) {
				case(@音無と呼ぶ)					$name_pat = 1
				case(@エロ侍と呼ぶ)					$name_pat = 3
				case(@エロエロ団ナンバー１と呼ぶ)	$name_pat = 4
				case(@ただのエロ少年と呼ぶ)			$name_pat = 5
				case(@ユリブサイクと呼ぶ)			$name_pat = 6
/*				case(@アメリカンエロドッグと呼ぶ)	$name_pat = 7
				case(@ゼウスと呼ぶ)					$name_pat = 8
				case(@日向markⅡと呼ぶ)				$name_pat = 9
				case(@糞虫と呼ぶ)					$name_pat = 10
				case(@量産型日向と呼ぶ)				$name_pat = 11
*/				default								$name_pat = 0
				}
	case("nd")	switch (@野田_呼び方) {
				case(@野田と呼ぶ)					$name_pat = 2
//				case(@イケパイと呼ぶ)				$name_pat = 11
				default								$name_pat = 0
				}
	}
	
	return ($name_pat)
}

//----------------------------------------------------------------------
// ライフを最大に回復する
//----------------------------------------------------------------------
command $$recover_life_max(property $type)
{
	$ef_life[$type] = <LIFE_MAX>
}

//----------------------------------------------------------------------
// ライフを加減する
//----------------------------------------------------------------------
command $$add_life(property $type, property $add)
{
	$ef_life[$type] += $add
	
	if( $ef_life[$type] > <LIFE_MAX> ) {
		$ef_life[$type] = <LIFE_MAX>
	}
	
	if( $ef_life[$type] < 0 ) {
		$ef_life[$type] = 0
	}
}

//----------------------------------------------------------------------
// ライフバーの更新
//----------------------------------------------------------------------
command $$update_battle_lifebar(property $type, property $damage)
{
	property $lifebar_len
	
	$$add_life($type, -$damage)
	
	$lifebar_len = 410
	
	L[0] = ($lifebar_len * 100 / 100) * $ef_life[$type] / 100
	
	if( $type )	{ mask[$$get_battle_mask_index($type)].x_eve.set(@screen_width - @battle_obj.child[2].get_size_x - ($lifebar_len - L[0]), 500, 0, 2) }
	else		{ mask[$$get_battle_mask_index($type)].x_eve.set($lifebar_len - L[0], 500, 0, 2) }
}

//----------------------------------------------------------------------
// コンボ開始
//----------------------------------------------------------------------
command $$combo_start
{
	$$create_combo(@combo_obj, @combo_number_obj)
}

//----------------------------------------------------------------------
// コンボオブジェクト作成
//----------------------------------------------------------------------
command $$create_combo(property $obj : object, property $obj2 : object)
{
	$$set_child_object($obj,  2)
	$$set_child_object($obj2, 2)
	
	$$set_battle_object($obj)
	$$set_battle_object($obj2)

	// 背景：黒三角
	$obj.child[0].create(ef_battle_combo_bg, 1)
	$obj.child[0].tr = 0
	$obj.child[0].tr_eve.set(255, 300, 0, 1)
	$obj.child[0].set_scale(2000, 2000)
	$obj.child[0].scale_x_eve.set(1000, 300, 0, 2)
	$obj.child[0].scale_y_eve.set(1000, 300, 0, 2)
	$obj.child[0].rotate_z = 1800
	$obj.child[0].rotate_z_eve.set(3600, 300, 0, 2)
	
	// 背景：赤帯
	$obj.child[1].create(ef_battle_combo_bg, 1, 0, 0, 1)
	$obj.child[1].tr = 0
	$obj.child[1].tr_eve.set(255, 300, 0, 2)
	$obj.child[1].x = $obj.child[1].get_size_x
	$obj.child[1].x_eve.set(0, 300, 0, 2)
	
	$$create_combo_number($obj2.child[0])
	
	$obj.set_pos(@screen_width - $obj.child[0].get_size_x / 2, 150)
	$obj2.set_pos(@screen_width - $obj.child[0].get_size_x / 2, 150)
}

//----------------------------------------------------------------------
// コンボオブジェクト(数字、hit)作成
//----------------------------------------------------------------------
command $$create_combo_number(property $obj : object)
{
	$$set_child_object($obj, 4)
	$obj.y_rep.resize(2)
	
	// 背景
	$obj.child[0].create(ef_battle_combo_hit, 1, 60, 0)
	$obj.child[1].create(ef_battle_combo_number, 1, -30, 0, $ef_combo / 10)
	$obj.child[2].create(ef_battle_combo_number, 1,  25, 0, $ef_combo % 10)
	$obj.child[3].create(ef_battle_combo_number, 0, -80, 0, 0)
	
	$obj.color_r = 255
	$obj.color_g = 255
	$obj.color_b = 255
	
	$obj.tr = 0
	$obj.tr_eve.set(255, 200, 0, 2)
	$obj.x = $obj.child[0].get_size_x
	$obj.x_eve.set(0, 200, 0, 2)
}

//----------------------------------------------------------------------
// コンボカウントアップ
//----------------------------------------------------------------------
command $$combo_count_up
{
	$ef_combo += 1
	
	$$combo_count_up_core(@combo_number_obj.child[0])
}

command $$combo_count_up_core(property $obj : object)
{
	property $pat
	property $pat_lv
	property $bright_time
	
	$pat    = $$get_battle_combo_pat
	$pat_lv = $pat * 10
	
	$obj.y_rep[0] = 0
	$obj.y_rep[1] = 0
	$obj.y_rep_eve[0].set(-5, 50,  50, 2)
	$obj.y_rep_eve[1].set( 5, 50, 100, 2)
	
	$obj.child[0].patno = $pat
	$obj.child[2].patno = $ef_combo % 10 + $pat_lv
	
	if( $ef_combo > 99 )
	{
		$obj.child[1].patno = $ef_combo / 10 % 10 + $pat_lv
		$obj.child[3].patno = $ef_combo / 100 + $pat_lv
		$obj.child[3].disp = 1
		
		$$ef_combo_count_up_anim($obj.child[1], 5000)
		$$ef_combo_count_up_anim($obj.child[2], 5000)
		$$ef_combo_count_up_anim($obj.child[3], 5000)
		
		$bright_time = 100
	}
	elseif( $ef_combo % 10 == 0 )
	{
		$obj.child[1].patno = $ef_combo / 10 % 10 + $pat_lv
		
		$$ef_combo_count_up_anim($obj.child[1], 3000)
		$$ef_combo_count_up_anim($obj.child[2], 3000)
		
		$bright_time = 150
	}
	else
	{
		$$ef_combo_count_up_anim($obj.child[2], 2000)
		
		$bright_time = 200
	}
	
	$obj.color_rate_eve.turn(0, 192, $bright_time, 0, 2)
}

command $$ef_combo_count_up_anim(property $obj : object, property $scale)
{
	$obj.tr = 0
	$obj.tr_eve.set(255, 250, 0, 2)
	
	$obj.set_scale($scale, $scale)
	$obj.scale_x_eve.set(1000, 300, 0, 2)
	$obj.scale_y_eve.set(1000, 300, 0, 2)
}

//----------------------------------------------------------------------
// コンボ終了
//----------------------------------------------------------------------
command $$combo_end
{
	@combo_number_obj.child[0].color_rate_eve.end
	
	@combo_number_obj.child[1].create(ef_battle_result, 1, 0, 60, $$get_battle_combo_pat)
	@combo_number_obj.child[1].tr = 0
	@combo_number_obj.child[1].tr_eve.set(255, 300, 0, 2)
	@combo_number_obj.child[1].x_eve.set(-@combo_obj.child[0].get_size_x / 2 + @combo_obj.child[0].get_size_x - @combo_number_obj.child[1].get_size_x, 300, 0, 2)
	@combo_number_obj.child[1].color_r = 255
	@combo_number_obj.child[1].color_g = 255
	@combo_number_obj.child[1].color_b = 255
	@combo_number_obj.child[0].color_rate_eve.turn(0, 128, 200, 0, 2)
	@combo_number_obj.child[1].color_rate_eve.turn(0, 128, 200, 0, 2)
	
	@combo_obj.x_eve.set(@screen_width, 200, 3000, 2)
	@combo_obj.tr_eve.set(0, 200, 3000, 2)
	@combo_number_obj.x_eve.set(@screen_width, 200, 3000, 2)
	@combo_number_obj.tr_eve.set(0, 200, 3000, 2)
}

//----------------------------------------------------------------------
// コンボ数による画像パターン番号を取得
//----------------------------------------------------------------------
command $$get_battle_combo_pat : int
{
	property $patno
	
	if( $ef_combo < 30 )		{ $patno = 0 }
	elseif( $ef_combo < 60 )	{ $patno = 1 }
	elseif( $ef_combo < 90 )	{ $patno = 2 }
	else						{ $patno = 3 }
	
	return ($patno)
}

//----------------------------------------------------------------------
// バトルのマスクインデックスを取得
//----------------------------------------------------------------------
command $$get_battle_mask_index(property $type) : int
{
	return (<BATTLE_MASK_INDEX> + $type)
}

//----------------------------------------------------------------------
// K.O.表示
//----------------------------------------------------------------------
command $$combo_knockout
{
	property $i
	
	$$set_child_object(@knockout_obj, 5)
	
	@knockout_obj.set_pos(@screen_center_x, @screen_center_y - 30)
	@knockout_obj.layer = <COMBO_OBJ_LAYER>
	
	@knockout_obj.child[0].create(ef_battle_knockout, 1)
	@knockout_obj.child[0].tr = 0
	@knockout_obj.child[0].tr_eve.set(255, 500, 0, 2)
	@knockout_obj.child[0].rotate_z_eve.set(3600, 500, 0, 2)
	@knockout_obj.child[0].scale_x_eve.set(0, 300, 1700, 2)
	@knockout_obj.child[0].scale_y_eve.set(0, 300, 1700, 2)
	
	for( $i = 1, $i < 5, $i += 1 )
	{
		@knockout_obj.child[$i].create(ef_battle_knockout, 1, @screen_width, 0, $i)
		@knockout_obj.child[$i].x_rep.resize(1)
		@knockout_obj.child[$i].x_eve.set(0, 300, 200 + 200 * ($i - 1), 2)
		@knockout_obj.child[$i].x_rep_eve[0].set(-@screen_width, 300, 1700 + 100 * $i, 2)
	}
	
	@timewaitkey(300)
	@pcmch_play(3, se_KO)
}

//-----------------------------------------------------------------
// バトルボイスの初期化
//-----------------------------------------------------------------
command $$init_battle_voice
{
	$voice_battle_start_koe_no   = 0
	$voice_battle_start_chara_no = 0
	$voice_battle_combo_koe_no.clear(0, $voice_battle_combo_koe_no.get_size - 1)
	$voice_battle_combo_chara_no.clear(0, $voice_battle_combo_chara_no.get_size - 1)
}

//-----------------------------------------------------------------
// バトル開始ボイスの設定
//-----------------------------------------------------------------
command $$set_battle_start_voice(property $koe_no, property $chara_no)
{
	$voice_battle_start_koe_no   = $koe_no
	$voice_battle_start_chara_no = $chara_no
}

//-----------------------------------------------------------------
// バトルコンボボイスの設定
//-----------------------------------------------------------------
command $$set_battle_combo_voice(property $combo_no, property $koe_no, property $chara_no)
{
	if( $combo_no > $voice_battle_combo_koe_no.get_size )
	{
		return
	}
	
	$voice_battle_combo_koe_no[$combo_no]   = $koe_no
	$voice_battle_combo_chara_no[$combo_no] = $chara_no
}

//-----------------------------------------------------------------
// バトル開始ボイスの再生
//-----------------------------------------------------------------
command $$play_battle_start_voice
{
	if( $voice_battle_start_koe_no != 0 )
	{
		KOE($voice_battle_start_koe_no, $voice_battle_start_chara_no)
	}
}

//-----------------------------------------------------------------
// バトルコンボボイスの再生
//-----------------------------------------------------------------
command $$play_battle_combo_voice(property $combo)
{
	if( $voice_battle_combo_koe_no[$combo] )
	{
		KOE($voice_battle_combo_koe_no[$combo], $voice_battle_combo_chara_no[$combo])
	}
}

//-----------------------------------------------------------------
// 野田コンボ
//-----------------------------------------------------------------
command $$ef_noda_combo(property $type)
{
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	
	$$recover_life_max(0)
	$$recover_life_max(1)
	
	close
	$$play_battle_start_voice
	@pcmch_play(1, @野田キュピーン)
	$$battle_start
	$ef_life[0] = 100
	$ef_life[1] = 100
	
	switch( $type ) {
	case(0)		@CUTIN_M3(bs3_nd0505)
	case(1)		@CUTIN_M3(bs3_nd0505)
	}
	
	@sc_flash_w
	
	// flashで解除されるので再び禁止
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	
	@timewaitkey(300)
	@コンボ開始

	@timewaitkey(300)
	@QUAKE_UD(100, 0, 0, 4)
	@CUTIN_M3(bs3_nd0504_07)
	for( L[0] = 0, L[0] < 99, L[0] += 1 )
	{
		@pcmch_play(0, @殴る)
		
		$$play_battle_combo_voice(L[0])
		if( L[0] == 20 ) { @CUTIN_M3(bs3_nd0404_05) }
		if( L[0] == 20 ) { @QUAKE_UD(100, 0, 0, 8) }
		if( L[0] == 50 ) { @CUTIN_M3(bs3_nd0403_06) }
	
		@コンボカウントアップ(100 - L[0], 0)
		$$update_battle_lifebar(0,1)
	}
	
	
	@pcmch_play(1, se_bassari)
	switch( $type ) {
	case(0)		@CUTIN_M3_END
	case(1)		@CUTIN_M3_END
	}
	$$update_battle_lifebar(0,10)
	@横揺れ_強
	@pcmch_play(2, se_blade)
	@QUAKE_END
	$$combo_knockout
	@コンボ終了
	$$battle_end
	
	syscom.set_syscom_menu_enable			// システムコマンドを許可する
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを許可する
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_shortcut_enable				// ショートカットを許可する
}

command $$ef_noda_combo2(property $start_face : str, property $end_face : str)
{
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	
	$$recover_life_max(0)
	$$recover_life_max(1)
	
	close
	$$play_battle_start_voice
	@pcmch_play(1, @野田キュピーン)
	$$battle_start
	$ef_life[0] = 100
	$ef_life[1] = 100
	
	//----------------------------
	@CUTIN_M3($start_face)
	//----------------------------
	
	@sc_flash_w
	
	// flashで解除されるので再び禁止
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	
	@timewaitkey(300)
	@コンボ開始

	@timewaitkey(300)
	@QUAKE_UD(100, 0, 0, 4)

	//----------------------------
	//@CUTIN_M3(bs3_nd0504_07)
	//----------------------------

	for( L[0] = 0, L[0] < 99, L[0] += 3 )
	{
		@pcmch_play(0, @殴る)
		
		$$play_battle_combo_voice(L[0])
		if( L[0] == 24 ) { @CUTIN_M3($end_face) }
		
		$ef_combo += 1
		$ef_combo += 1
		@コンボカウントアップ(100 - L[0], 0)
		$$update_battle_lifebar(0,3)
	}
	
	
	@pcmch_play(1, se_bassari)
	
	//----------------------------
	@CUTIN_M3_END
	//----------------------------
	
	$$update_battle_lifebar(0,10)
	@横揺れ_強
	@pcmch_play(2, se_blade)
	@QUAKE_END
	$$combo_knockout
	@コンボ終了
	$$battle_end
	
	syscom.set_syscom_menu_enable			// システムコマンドを許可する
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを許可する
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_shortcut_enable				// ショートカットを許可する
}



command $$ef_noda_battle(property $type)
{
	property $i
	property $pos_y
	
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	
	$$recover_life_max(0)
	$$recover_life_max(1)
	
	close
	$$play_battle_start_voice
	@pcmch_play(1, @野田キュピーン)
	$$battle_start
	$ef_life[0] = 100
	$ef_life[1] = 100
	
	$pos_y = @pos_m + 150
	//--------------------------
	@bs_set(-1, bs3_ot0104, @pos_ol, @pos_z1, $pos_y)
	@bs_set(-1, bs3_nd0505, @pos_or, @pos_z1, $pos_y)
	@wipe(0)
	//--------------------------
	
	@sc_flash_w
	
	//--------------------------
	@bs_set(200, bs3_ot0104, @pos_fl, @pos_z1, $pos_y)
	@bs_set(200, bs3_nd0505, @pos_fr, @pos_z1, $pos_y)
	@wipe(3)
	//--------------------------
	
	// flashで解除されるので再び禁止
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する
	
	@timewaitkey(300)
	@コンボ開始

	@timewaitkey(300)
	@QUAKE_UD(100, 0, 0, 4)
	for( $i = 0, $i < 99, $i += 1 )
	{
		@pcmch_play(0, @殴る)
		
		$$play_battle_combo_voice($i)
		if( $i == 20 ) { 
			@bs_set(200, bs3_ot0107, @pos_fl, @pos_z1, $pos_y)
			@bs_set(200, bs3_nd0504_05, @pos_fr, @pos_z1, $pos_y)
			@wipe(0)
		}
		if( $i == 20 ) { @QUAKE_UD(100, 0, 0, 8) }
		if( $i == 50 ) {
			@bs_set(200, bs3_nd0403_06, @pos_c, @pos_z1, $pos_y)
			@wipe(0)
		}
	
		@コンボカウントアップ(100 - $i, 0)
		$$update_battle_lifebar(0,1)
	}
	@pcmch_play(1, se_bassari)

	//--------------------------
	$$create_battle_line_bg
	@bs
	front.object[$$ef_get_omv_index(5)].wipe_copy = 0
	front.object[$$ef_get_omv_index(6)].wipe_copy = 0
	//--------------------------
	
	$$update_battle_lifebar(0,10)
	@横揺れ_強
	@pcmch_play(2, se_blade)
	@QUAKE_END
	$$combo_knockout
	@コンボ終了
	$$battle_end
	@timewaitkey(3500)
	@wipe(3)
	
	syscom.set_syscom_menu_enable			// システムコマンドを許可する
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを許可する
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_shortcut_enable				// ショートカットを許可する
}

command $$create_battle_line_bg
{
	property $obj_index
	
	$obj_index = $$ef_get_omv_index(5)
	back.object[$obj_index].create(ef_sline_bg, 1)
	back.object[$obj_index].layer = -10
	back.object[$obj_index].y_eve.loop(0, -300, 150, 0, 0)
	back.object[$obj_index].wipe_copy = 1
	
	$obj_index = $$ef_get_omv_index(6)
	$$ef_create_omv_loop(back, ef_sline_v, 6, 0, 0, 2000)
	back.object[$obj_index].blend = 1
	back.object[$obj_index].layer = 100
	back.object[$obj_index].wipe_copy = 1
}
