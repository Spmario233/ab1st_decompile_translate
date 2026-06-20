//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_cutin_macro.ss
//	@author		Kazuya Takahashi
//	@note		カットイン処理
//
//-----------------------------------------------------------------------------------------------

#inc_start
	
	// バストショットカットイン
	#define		<CUTIN_OBJ_MAX>				<CUTIN_TYPE_MAX>
	#define		<CUTIN_OBJ_START_INDEX>		280
	#define		<CUTIN_OBJ_LAYER>			1000
	
	#property	$cutin_bs_disp				: intlist[<CUTIN_OBJ_MAX>]
	#property	$cutin_bs_pos_x				: intlist[<CUTIN_OBJ_MAX>]
	#property	$cutin_bs_pos_y				: intlist[<CUTIN_OBJ_MAX>]
	#property	$cutin_bs_mask_size_x		: intlist[<CUTIN_OBJ_MAX>]
	#property	$cutin_bs_mask_size_y		: intlist[<CUTIN_OBJ_MAX>]
	
	// ＣＧカットイン
	#property	$cutin_cg_param				: intlist[6]	// ＣＧカットインパラメータ(x,y,scale_x,scale_y,tr,patno)
	#property	$cutin_cg_move_param		: intlist[5]	// ＣＧカットインの移動パラメータ(is_move,x,y,time,interep)
	#property	$cutin_cg_filter_param		: intlist[5]	// ＣＧカットインフィルターパラメータ(is_filter,red,green,blue,alpha)
	#property	$cutin_cg_clip_param		: intlist[5]	// ＣＧカットインのクリップパラメータ(disp,left,top,right,bottom)
	#property	$cutin_cg_clip_move_param	: intlist[7]	// ＣＧカットインの移動パラメータ(is_move,left,top,right,bottom,time,interep)
	#property	$cutin_cg_border_param		: intlist[6]	// ＣＧカットインのボーダーパラメータ(disp,size,red,green,blue,alpha)
	#property	$cutin_cg_alpha_param		: intlist[7]	// ＣＧカットインのアルファパラメータ(is_show,show_time,show_interep,wait_time,is_hide,hide_time,hide_interep)
	
#inc_end

#z00
//======================================================================
//
// バストショットカットイン
//
//======================================================================
//----------------------------------------------------------------------
// バストショットカットインの表示
//----------------------------------------------------------------------
command $$show_cutin_bs(property $bg_name : str, property $bs_name : str, property $type)
{
	property $obj_index
	
	$obj_index = <CUTIN_OBJ_START_INDEX> + $type
	
	if( $cutin_bs_disp[$type] )
	{
		$$wipe_cutin_bs(front.object[$obj_index], $obj_index, $bg_name, $bs_name, $type)
	}
	else
	{
		$$create_cutin_bs(front.object[$obj_index], $obj_index, $bg_name, $bs_name, $type)
	}
}

//----------------------------------------------------------------------
// バストショットカットインの作成
//----------------------------------------------------------------------
command $$create_cutin_bs(property $obj : object, property $obj_index, property $bs_name : str, property $bg_name : str, property $type)
{
	$obj.init
	
	$$set_child_object($obj, 2)
	$obj.layer = <CUTIN_OBJ_LAYER> + $type
	$obj.wipe_copy = 1
	
	$$set_child_object($obj.child[0], 3)
	$$create_cutin_bs_bg($obj.child[0].child[0], $bg_name)		// 背景
	if( $bs_name != <INVALID_STR> ) {
		$$copy_temporary_bs($obj.child[0].child[1], $bs_name)		// バストショット
	}
	$$create_cutin_bs_mask($obj.child[0], $type)
	
	$$set_cutin_bs_pos($obj, $type)								// 座標の設定
	
	$$create_cutin_bs_border($obj.child[1], $type)				// ボーダー
	$$create_cutin_bs_animation($obj, $type)					// アニメーション
	
	$cutin_bs_disp[$type] = 1
}

//----------------------------------------------------------------------
// バストショットカットイン(背景)の作成
//----------------------------------------------------------------------
command $$create_cutin_bs_bg(property $obj : object, property $bg_name : str)
{
	if( $bg_name == <INVALID_STR> )
	{
		$obj.create(bg_kuro, 1)
		$obj.tr = 128
	}
	else
	{
		$obj.create($bg_name, 1)
	}
}

//----------------------------------------------------------------------
// バストショットカットイン(マスク)の作成
//----------------------------------------------------------------------
command $$create_cutin_bs_mask(property $obj : object, property $type)
{
	property $mask_name : str
	property $mask_index
	
	switch( $type ) {
	case (<CUTIN_TYPE1_C>)	$mask_name = "cutin_maskc"
	case (<CUTIN_TYPE1_L>)	$mask_name = "cutin_maskl"
	case (<CUTIN_TYPE1_R>)	$mask_name = "cutin_maskr"
	case (<CUTIN_TYPE2_L>)	$mask_name = "cutin_maskl2"
	case (<CUTIN_TYPE2_R>)	$mask_name = "cutin_maskr2"
	case (<CUTIN_TYPE3_M>)	$mask_name = "cutin_masku"
	case (<CUTIN_TYPE4_U>)	$mask_name = "cutin_masku"
	case (<CUTIN_TYPE4_D>)	$mask_name = "cutin_masku"
	case (<CUTIN_TYPE5_M>)	$obj.set_clip(1, 0, 300, @SCREEN_WIDTH, 300)
							$obj.clip_top_eve.set(100, 300, 0, 2)
							$obj.clip_bottom_eve.set(500, 300, 0, 2)
							return
	case (<CUTIN_TYPE6_M>)	$obj.set_clip(1, 0, 350, @SCREEN_WIDTH, 350)
							$obj.clip_top_eve.set(180, 300, 0, 2)
							$obj.clip_bottom_eve.set(580, 300, 0, 2)
							return
	case (<CUTIN_TYPE7_M>)	$obj.set_clip(1, 0, 300, @SCREEN_WIDTH, 300)
							$obj.clip_top_eve.set(50, 300, 0, 2)
							$obj.clip_bottom_eve.set(500, 300, 0, 2)
							return
	}
	
	$mask_index = $$get_cutin_bs_mask_index($type)
	
	// マスク初期化
	mask[$mask_index].init
	
	// マスクの適用
	mask[$mask_index].create($mask_name)
	$obj.mask_no = $mask_index
	
	// マスクのサイズを取得するため一時的にobjectに読み込む
	$obj.child[2].create($mask_name)
	$cutin_bs_mask_size_x[$type] = $obj.child[2].get_size_x
	$cutin_bs_mask_size_y[$type] = $obj.child[2].get_size_y
	$obj.child[2].init
}

//----------------------------------------------------------------------
// バストショットカットイン(ボーダー)の作成
//----------------------------------------------------------------------
command $$create_cutin_bs_border(property $obj : object, property $type)
{
	$$set_child_object($obj, 2)
	
	switch( $type ) {
	case(<CUTIN_TYPE1_C>)
		$obj.child[0].create(cutin_border01, 1)
		$obj.child[1].create(cutin_border01, 1)
		$obj.child[1].x = $cutin_bs_mask_size_x[$type] - $obj.child[0].get_size_x
		
	case(<CUTIN_TYPE1_L>)
		$obj.child[0].create(cutin_border01, 1)
		$obj.child[0].x = $cutin_bs_mask_size_x[$type] - $obj.child[0].get_size_x
		
	case(<CUTIN_TYPE1_R>)
		$obj.child[0].create(cutin_border01, 1)
		
	case(<CUTIN_TYPE2_L>)
		$obj.child[0].create(cutin_border03, 1)
		$obj.child[0].x = $cutin_bs_mask_size_x[$type] - $obj.child[0].get_size_x
		
	case(<CUTIN_TYPE2_R>)
		$obj.child[0].create(cutin_border03, 1)
		
	case(<CUTIN_TYPE3_M>)
		$obj.child[0].create(cutin_border02, 1)
		$obj.child[1].create(cutin_border02, 1)
		$obj.child[1].y = $cutin_bs_mask_size_y[$type] - $obj.child[0].get_size_y
		
	case(<CUTIN_TYPE4_U>)
		$obj.child[0].create(cutin_border02, 1)
		$obj.child[1].create(cutin_border02, 1)
		$obj.child[1].y = $cutin_bs_mask_size_y[$type] - $obj.child[0].get_size_y
		
	case(<CUTIN_TYPE4_D>)
		$obj.child[0].create(cutin_border02, 1)
		$obj.child[1].create(cutin_border02, 1)
		$obj.child[1].y = $cutin_bs_mask_size_y[$type] - $obj.child[0].get_size_y
		
	case(<CUTIN_TYPE5_M>)
		$obj.child[0].create(cutin_border02, 1, -1280, 100)
		$obj.child[1].create(cutin_border02, 1,  1280, 500 + 8 - 19)
		$obj.child[0].x_eve.set(0, 300, 0, 2)
		$obj.child[1].x_eve.set(0, 300, 0, 2)
		
	case(<CUTIN_TYPE6_M>)
		$obj.child[0].create(cutin_border02, 1, -1280, 180 - 10)
		$obj.child[1].create(cutin_border02, 1,  1280, 580 + 8 - 19)
		$obj.child[0].x_eve.set(0, 300, 0, 2)
		$obj.child[1].x_eve.set(0, 300, 0, 2)
		
	case(<CUTIN_TYPE7_M>)
		$obj.child[0].create(cutin_border02, 1, -1280, 50)
		$obj.child[1].create(cutin_border02, 1,  1280, 500 + 8 - 19)
		$obj.child[0].x_eve.set(0, 300, 0, 2)
		$obj.child[1].x_eve.set(0, 300, 0, 2)
		
	}
}

//----------------------------------------------------------------------
// バストショットカットイン(アニメーション)の作成
//----------------------------------------------------------------------
command $$create_cutin_bs_animation(property $obj : object, property $type)
{
	property $mask_index
	property $move_x
	property $move_time
	
	$mask_index = $$get_cutin_bs_mask_index($type)
	
	$move_time = 300
	
	switch( $type ) {
	case (<CUTIN_TYPE1_C>)	$obj.x -= $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x -= $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE1_L>)	$obj.x -= $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x -= $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE1_R>)	$obj.x += $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x += $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x - $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE2_L>)	$obj.x -= $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x -= $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE2_R>)	$obj.x += $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x += $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x - $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE3_M>)	$obj.y += $cutin_bs_mask_size_y[$type]
							$obj.y_eve.set(0, 500, 0, 2)
							mask[$mask_index].y += $cutin_bs_mask_size_y[$type]
							mask[$mask_index].y_eve.set(mask[$mask_index].y - $cutin_bs_mask_size_y[$type], 500, 0, 2)
	case (<CUTIN_TYPE4_U>)	$obj.x += $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x += $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x - $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE4_D>)	$obj.x -= $cutin_bs_mask_size_x[$type]
							$obj.x_eve.set(0, $move_time, 0, 2)
							mask[$mask_index].x -= $cutin_bs_mask_size_x[$type]
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE5_M>)	$obj.child[0].tr = 0
							$obj.child[0].tr_eve.set(255, 300, 0, 1)
							return
	case (<CUTIN_TYPE6_M>)	$obj.child[0].tr = 0
							$obj.child[0].tr_eve.set(255, 300, 0, 1)
							return
	case (<CUTIN_TYPE7_M>)	$obj.child[0].tr = 0
							$obj.child[0].tr_eve.set(255, 300, 0, 1)
							return
	}
	
	$obj.tr = 0
	$obj.tr_eve.set(255, 300, 0, 1)
}

//----------------------------------------------------------------------
// バストショットカットインのワイプ
//----------------------------------------------------------------------
command $$wipe_cutin_bs(property $obj : object, property $obj_index, property $bs_name : str, property $bg_name : str, property $type)
{
	property $wipe_layer
	
	$wipe_layer = <CUTIN_OBJ_LAYER> + $type
	
	// 現在表示しているカットインオブジェクトを裏にコピー
	back.object[$obj_index].create_copy_from(front.object[$obj_index])
	
	// 背景変更チェック
	if( $bg_name != <INVALID_STR> ) {
		$$create_cutin_bs_bg(back.object[$obj_index].child[0].child[0], $bg_name)
	}
	
	// バストショット変更チェック
	if( $bs_name == <INVALID_STR> ) {
		back.object[$obj_index].child[0].child[1].init
	} else {
		$$copy_temporary_bs(back.object[$obj_index].child[0].child[1], $bs_name)
	}
	
	wipe(0, 300, start_layer = $wipe_layer, end_layer = $wipe_layer, wait = 0)
}

//----------------------------------------------------------------------
// バストショットカットイン座標設定
//----------------------------------------------------------------------
command $$set_cutin_bs_pos(property $obj : object, property $type)
{
	property $mask_index
	
	$mask_index = $$get_cutin_bs_mask_index($type)
	
	switch( $type ) {
	case (<CUTIN_TYPE1_C>)	$cutin_bs_pos_x[$type] = (@SCREEN_WIDTH - $cutin_bs_mask_size_x[$type]) / 2
	case (<CUTIN_TYPE1_L>)	$obj.child[0].set_pos(-@SCREEN_WIDTH / 3, 0)
	case (<CUTIN_TYPE1_R>)	$obj.child[0].set_pos( @SCREEN_WIDTH / 3, 0)
							$cutin_bs_pos_x[$type] = @SCREEN_WIDTH - $cutin_bs_mask_size_x[$type]
	case (<CUTIN_TYPE2_L>)	$obj.child[0].set_pos(-@SCREEN_WIDTH / 3 + 30, 0)
	case (<CUTIN_TYPE2_R>)	$obj.child[0].set_pos( @SCREEN_WIDTH / 3 - 30, 0)
							$cutin_bs_pos_x[$type] = @SCREEN_WIDTH - $cutin_bs_mask_size_x[$type]
	case (<CUTIN_TYPE3_M>)	$obj.child[0].set_pos(0, 50)
							$cutin_bs_pos_y[$type] = (@SCREEN_HEIGHT - $cutin_bs_mask_size_y[$type]) / 2
	case (<CUTIN_TYPE4_U>)	$obj.child[0].set_pos(0, -70)
							$obj.child[0].child[1].x_rep.resize(1)
							$obj.child[0].child[1].x_rep[0] -= 400
	case (<CUTIN_TYPE4_D>)	$cutin_bs_pos_y[$type] = $cutin_bs_mask_size_y[$type]
							$obj.child[0].set_pos(0, $cutin_bs_mask_size_y[$type] - 50)
							$obj.child[0].child[1].x_rep.resize(1)
							$obj.child[0].child[1].x_rep[0] += 400
	case (<CUTIN_TYPE5_M>)	
	case (<CUTIN_TYPE6_M>)	$obj.child[0].set_pos(0, 40)
	case (<CUTIN_TYPE7_M>)	
	}
	
	$obj.child[1].set_pos($cutin_bs_pos_x[$type], $cutin_bs_pos_y[$type])
	mask[$mask_index].x = $cutin_bs_pos_x[$type]
	mask[$mask_index].y = $cutin_bs_pos_y[$type]
}

command $$get_cutin_bs_mask_index(property $type) : int
{
	return ($type + 3)
}

//----------------------------------------------------------------------
// バストショットカットイン消去
//----------------------------------------------------------------------
command	$$hide_cutin_bs(property $type)
{
	property $obj_index
	
	$obj_index = <CUTIN_OBJ_START_INDEX> + $type
	
	if( $cutin_bs_disp[$type] == 0 ) {
		return
	}
	
	$$hide_cutin_bs_core(front.object[$obj_index], $type)
	
	$cutin_bs_disp[$type] = 0
}

command $$hide_cutin_bs_core(property $obj : object, property $type)
{
	property $mask_index
	property $move_time
	
	$mask_index = $$get_cutin_bs_mask_index($type)
	$move_time = 300
	
	switch( $type ) {
	case (<CUTIN_TYPE1_C>)	$obj.x_eve.set($cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE1_L>)	$obj.x_eve.set(-$cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x - $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE1_R>)	$obj.x_eve.set($cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE2_L>)	$obj.x_eve.set(-$cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x - $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE2_R>)	$obj.x_eve.set($cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE3_M>)	$obj.y_eve.set(-$cutin_bs_mask_size_y[$type], 500, 0, 2)
							mask[$mask_index].y_eve.set(mask[$mask_index].y - $cutin_bs_mask_size_y[$type], 500, 0, 2)
	case (<CUTIN_TYPE4_U>)	$obj.x_eve.set(-$cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x - $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE4_D>)	$obj.x_eve.set($cutin_bs_mask_size_x[$type], $move_time, 0, 2)
							mask[$mask_index].x_eve.set(mask[$mask_index].x + $cutin_bs_mask_size_x[$type], $move_time, 0, 2)
	case (<CUTIN_TYPE5_M>)	$obj.child[1].child[0].x_eve.set( 1280, 300, 0, 2)
							$obj.child[1].child[1].x_eve.set(-1280, 300, 0, 2)
							$obj.tr_eve.set(0, 500, 0, 2)
							$obj.wipe_copy = 0
							return
	case (<CUTIN_TYPE6_M>)	$obj.child[1].child[0].x_eve.set( 1280, 300, 0, 2)
							$obj.child[1].child[1].x_eve.set(-1280, 300, 0, 2)
							$obj.tr_eve.set(0, 500, 0, 2)
							$obj.wipe_copy = 0
							return
	case (<CUTIN_TYPE7_M>)	$obj.child[1].child[0].x_eve.set( 1280, 300, 0, 2)
							$obj.child[1].child[1].x_eve.set(-1280, 300, 0, 2)
							$obj.tr_eve.set(0, 500, 0, 2)
							$obj.wipe_copy = 0
							return
	}
	
	$obj.wipe_copy = 0
	$obj.tr_eve.set(0, $move_time, 0, 2)
}

//----------------------------------------------------------------------
// バストショットカットインワイプコピーオフ
//----------------------------------------------------------------------
command $$wipe_off_cutin_bs(property $type, property $is_tr_eve, property $time)
{
	property $obj_index
	
	$obj_index = <CUTIN_OBJ_START_INDEX> + $type
	
	front.object[$obj_index].wipe_copy = 0
	if( $is_tr_eve ) {
		front.object[$obj_index].tr_eve.set(0, $time, 0, 0)
	}
	$cutin_bs_disp[$type] = 0
}

//======================================================================
//
// ＣＧカットイン
//
//======================================================================
//----------------------------------------------------------------------
// ＣＧカットインパラメータの初期化
//----------------------------------------------------------------------
command $$init_cutin_cg_all_param
{
	$cutin_cg_param.clear(0, $cutin_cg_param.get_size - 1)
	$cutin_cg_param[2] = 1000	// scale_x
	$cutin_cg_param[3] = 1000	// scale_y
	
	$cutin_cg_move_param.clear(0, $cutin_cg_move_param.get_size - 1)
	$cutin_cg_filter_param.clear(0, $cutin_cg_filter_param.get_size - 1)
	$cutin_cg_clip_param.clear(0, $cutin_cg_clip_param.get_size - 1)
	$cutin_cg_clip_move_param.clear(0, $cutin_cg_clip_move_param.get_size - 1)
	$cutin_cg_border_param.clear(0, $cutin_cg_border_param.get_size - 1)
	$cutin_cg_alpha_param.clear(0, $cutin_cg_alpha_param.get_size - 1)
}


//----------------------------------------------------------------------
// ＣＧカットインパラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_param(property $pos_x, property $pos_y, property $scale_x, property $scale_y, property $tr, property $patno)
{
	$cutin_cg_param.sets(0, $pos_x, $pos_y, $scale_x, $scale_y, $tr, $patno)
}

//----------------------------------------------------------------------
// ＣＧカットインの移動パラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_move_param(property $pos_x, property $pos_y, property $time, property $interep)
{
	$cutin_cg_move_param.sets(0, 1, $pos_x, $pos_y, $time, $interep)
}

//----------------------------------------------------------------------
// ＣＧカットインのフィルターパラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_filter_param(property $red, property $green, property $blue, property $alpha)
{
	$cutin_cg_filter_param.sets(0, 1, $red, $green, $blue, $alpha)
}

//----------------------------------------------------------------------
// ＣＧカットインのクリップパラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_clip_param(property $left, property $top, property $right, property $bottom)
{
	$cutin_cg_clip_param.sets(0, 1, $left, $top, $right, $bottom)
}

//----------------------------------------------------------------------
// ＣＧカットインのクリップ移動パラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_clip_move_param(property $left, property $top, property $right, property $bottom, property $time, property $interep)
{
	$cutin_cg_clip_move_param.sets(0, 1, $left, $top, $right, $bottom, $time, $interep)
}

//----------------------------------------------------------------------
// ＣＧカットインのボーダーパラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_border_param(property $size, property $red, property $green, property $blue, property $alpha)
{
	$cutin_cg_border_param.sets(0, 1, $size, $red, $green, $blue, $alpha)
}

//----------------------------------------------------------------------
// ＣＧカットインのアルファパラメータ設定
//----------------------------------------------------------------------
command $$set_cutin_cg_alpha_param(property $is_show, property $show_time, property $show_interep, property $wait_time, property $is_hide, property $hide_time, property $hide_interep)
{
	$cutin_cg_alpha_param.sets(0, $is_show, $show_time, $show_interep, $wait_time, $is_hide, $hide_time, $hide_interep)
}

//----------------------------------------------------------------------
// ＣＧカットインの実行
//----------------------------------------------------------------------
command $$execute_cutin_cg(property $obj :object, property $filename : str)
{
	$$set_child_object($obj, 6)
	
	// ＣＧカットイン本体の作成
	$obj.child[1].create($filename, 1, $cutin_cg_param[0], $cutin_cg_param[1], $cutin_cg_param[5])
	$obj.child[1].set_scale($cutin_cg_param[2], $cutin_cg_param[3])
	
	$$execute_cutin_cg_core($obj)
}

command $$execute_cutin_cg_core(property $obj :object)
{
	$obj.layer = <CUTIN_OBJ_LAYER>
	
	// アルファ設定
	$obj.tr_rep.resize(2)
	$obj.tr_rep[0] = $cutin_cg_param[4]
	
	// フィルターの作成
	if( $cutin_cg_filter_param[0] == 1 ) {
		$obj.child[0].create_rect(0, 0, @SCREEN_WIDTH, @SCREEN_HEIGHT, $cutin_cg_filter_param[1], $cutin_cg_filter_param[2], $cutin_cg_filter_param[3], $cutin_cg_filter_param[4], 1)
	} elseif( $cutin_cg_filter_param[0] == 2 ) {
		$$set_child_object($obj.child[0], 2)
		$obj.child[0].child[0].create_rect(0, 0, @SCREEN_WIDTH, $cutin_cg_clip_param[2], $cutin_cg_filter_param[1], $cutin_cg_filter_param[2], $cutin_cg_filter_param[3], $cutin_cg_filter_param[4], 1)
		$obj.child[0].child[1].create_rect(0, $cutin_cg_clip_param[4], @SCREEN_WIDTH, @SCREEN_HEIGHT, $cutin_cg_filter_param[1], $cutin_cg_filter_param[2], $cutin_cg_filter_param[3], $cutin_cg_filter_param[4], 1)
	}
	
	// ＣＧカットインのクリップ設定
	if( $cutin_cg_clip_param[0] )
	{
		if( $cutin_cg_clip_move_param[0] )
		{
			$obj.child[1].set_clip(1, $cutin_cg_clip_move_param[1], $cutin_cg_clip_move_param[2], $cutin_cg_clip_move_param[3], $cutin_cg_clip_move_param[4])
			$obj.child[1].clip_left_eve.set  ($cutin_cg_clip_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[1].clip_top_eve.set   ($cutin_cg_clip_param[2], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[1].clip_right_eve.set ($cutin_cg_clip_param[3], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[1].clip_bottom_eve.set($cutin_cg_clip_param[4], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
		}
		else
		{
			$obj.child[1].set_clip(1, $cutin_cg_clip_param[1], $cutin_cg_clip_param[2], $cutin_cg_clip_param[3], $cutin_cg_clip_param[4])
		}
	}
	
	// ＣＧカットインの移動設定
	if( $cutin_cg_move_param[0] )
	{
		$obj.child[1].set_pos($cutin_cg_move_param[1], $cutin_cg_move_param[2])
		$obj.child[1].x_eve.set($cutin_cg_param[0], $cutin_cg_move_param[3], 0, $cutin_cg_move_param[4])
		$obj.child[1].y_eve.set($cutin_cg_param[1], $cutin_cg_move_param[3], 0, $cutin_cg_move_param[4])
	}
	
	property $rect_t
	property $rect_b
	property $rect_l
	property $rect_r
	
	// ＣＧカットインのボーダー設定
	if( $cutin_cg_border_param[0] )
	{
		$rect_t = $cutin_cg_clip_param[2] - $cutin_cg_border_param[1]
		$rect_b = $cutin_cg_clip_param[4] + $cutin_cg_border_param[1]
		$rect_l = $cutin_cg_clip_param[1] - $cutin_cg_border_param[1]
		$rect_r = $cutin_cg_clip_param[3] + $cutin_cg_border_param[1]
		
		if( $cutin_cg_clip_move_param[0] )
		{
			$obj.child[2].create_rect($cutin_cg_clip_param[1], $rect_t, $cutin_cg_clip_param[3], $cutin_cg_clip_param[2], $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			$obj.child[3].create_rect($cutin_cg_clip_param[1], $cutin_cg_clip_param[4], $cutin_cg_clip_param[3], $rect_b, $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			$obj.child[4].create_rect($rect_l, $rect_t, $cutin_cg_clip_param[1], $rect_b, $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			$obj.child[5].create_rect($cutin_cg_clip_param[3], $rect_t, $rect_r, $rect_b, $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			
			$obj.child[2].y = $cutin_cg_clip_move_param[2] - $cutin_cg_clip_param[2]
			$obj.child[2].y_eve.set(0, $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[2].set_src_clip(1, $cutin_cg_clip_move_param[1], $rect_t, $cutin_cg_clip_move_param[3], $cutin_cg_clip_param[4])
			$obj.child[2].src_clip_left_eve.set ($cutin_cg_clip_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[2].src_clip_right_eve.set($cutin_cg_clip_param[3], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			
			$obj.child[3].y = $cutin_cg_clip_move_param[4] - $cutin_cg_clip_param[4]
			$obj.child[3].y_eve.set(0, $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[3].set_src_clip(1, $cutin_cg_clip_move_param[1], $rect_t, $cutin_cg_clip_move_param[3], $rect_b)
			$obj.child[3].src_clip_left_eve.set ($cutin_cg_clip_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[3].src_clip_right_eve.set($cutin_cg_clip_param[3], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			
			$obj.child[4].x = $cutin_cg_clip_move_param[1] - $cutin_cg_clip_param[1]
			$obj.child[4].x_eve.set(0, $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[4].set_src_clip(1, $rect_l, $cutin_cg_clip_move_param[2] - $cutin_cg_border_param[1], $cutin_cg_clip_move_param[1], $cutin_cg_clip_move_param[4] + $cutin_cg_border_param[1])
			$obj.child[4].src_clip_top_eve.set   ($cutin_cg_clip_param[2] - $cutin_cg_border_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[4].src_clip_bottom_eve.set($cutin_cg_clip_param[4] + $cutin_cg_border_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			
			$obj.child[5].x = $cutin_cg_clip_move_param[3] - $cutin_cg_clip_param[3]
			$obj.child[5].x_eve.set(0, $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[5].set_src_clip(1, $cutin_cg_clip_move_param[3], $cutin_cg_clip_move_param[2] - $cutin_cg_border_param[1], $rect_r, $cutin_cg_clip_move_param[4] + $cutin_cg_border_param[1])
			$obj.child[5].src_clip_top_eve.set   ($cutin_cg_clip_param[2] - $cutin_cg_border_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
			$obj.child[5].src_clip_bottom_eve.set($cutin_cg_clip_param[4] + $cutin_cg_border_param[1], $cutin_cg_clip_move_param[5], 0, $cutin_cg_clip_move_param[6])
		}
		else
		{
			$obj.child[2].create_rect($cutin_cg_clip_param[1], $rect_t, $cutin_cg_clip_param[3], $cutin_cg_clip_param[2], $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			$obj.child[3].create_rect($cutin_cg_clip_param[1], $cutin_cg_clip_param[4], $cutin_cg_clip_param[3], $rect_b, $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			$obj.child[4].create_rect($rect_l, $rect_t, $cutin_cg_clip_param[1], $rect_b, $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
			$obj.child[5].create_rect($cutin_cg_clip_param[3], $rect_t, $rect_r, $rect_b, $cutin_cg_border_param[2], $cutin_cg_border_param[3], $cutin_cg_border_param[4], $cutin_cg_border_param[5], 1);
		}
	}
	
	// ＣＧカットインのアルファ設定
	if( $cutin_cg_alpha_param[0] )
	{
		$obj.tr_rep[0] = 0
		$obj.tr_rep_eve[0].set($cutin_cg_param[4], $cutin_cg_alpha_param[1], 0, $cutin_cg_alpha_param[2])
	}
	
	if( $cutin_cg_alpha_param[4] )
	{
		$obj.tr_rep_eve[1].set(0, $cutin_cg_alpha_param[5], $cutin_cg_alpha_param[3], $cutin_cg_alpha_param[6])
	}
}


//----------------------------------------------------------------------
// 一時バストショット生成処理
//----------------------------------------------------------------------
command $$create_temporary_bs(property $tmp_name : str) : int
{
	property $index
	property $work_bs_name   : strlist[@bs_maxnum]
	property $work_name_info : strlist[@bs_maxnum]
	property $i
	
	// bs_nameに距離データが含まれない場合はデフォルト値を設定する
	if( $tmp_name.search("bs") != 0 )
	{
		$tmp_name = "bs2_" + $tmp_name
	}
	
	// 裏にバストショットを生成する
	// 無理矢理すぎるので修正予定
	for( $i = 0, $i < @bs_maxnum, $i += 1 ) {
		$work_bs_name[$i]   = $bs_name[$i]
		$work_name_info[$i] = $bs_name_info_prev[$i]
	}
	
	@bs_set(-1, $tmp_name, @pos_c)
	$bs_disp_in(0)
	$bs_disp_cnt -= 1
	
	@bs_set(-1, $tmp_name.mid(0, 6) + "9999", @pos_c)
	$bs_disp_cnt -= 1
	
	@bs_wipe_decide = 0
	$bs_set_ready = 0
	
	for( $i = 0, $i < @bs_maxnum, $i += 1 ) {
		$bs_name[$i] = $work_bs_name[$i]
		$bs_name_info_prev[$i] = $work_name_info[$i]
	}
	
	// バストショットオブジェクトの判定
	$index = $$get_bs_obj_index($tmp_name)
	
	// 作成したバストショットオブジェクトインデックス
	return ($index)
}

//----------------------------------------------------------------------
// 一時生成したバストショットのコピー処理
//----------------------------------------------------------------------
command $$copy_temporary_bs(property $obj : object, property $bs_name : str) : int
{
	L[0] = $$create_temporary_bs($bs_name)
	
	if( L[0] == -1 ) {
		return (L[0])
	}
	
	$obj.init
	$obj.create_copy_from(back.object[L[0]])
	
	$obj.x_eve.end
	
	// 一時生成したバストショットオブジェクトは必要ないので初期化
	back.object[L[0]].init
	
	return (L[0])
}

//----------------------------------------------------------------------
// バストショットのオブジェクトインデックスを取得する
//----------------------------------------------------------------------
command	$$get_bs_obj_index(property $bs_name : str) : int
{
	property $index
	
	if( $bs_name.search("bs") == -1 )
	{
		$bs_name = "bs2_" + $bs_name
	}
	
	// バストショットオブジェクトの判定
	switch ($bs_name.mid(4, 2))	{
		case ("OT") $index =  0		// 音無
		case ("KN") $index =  1		// かなで
		case ("YR") $index =  2		// ゆり
		case ("HN") $index =  3		// 日向
		case ("YI") $index =  4		// ユイ
		case ("IW") $index =  5		// 岩沢
		case ("MT") $index =  6		// 松下（太）
		case ("MS") $index =  7		// 松下（細）
		case ("ND") $index =  8		// 野田
		case ("TM") $index =  9		// 高松
		case ("OY") $index = 10		// 大山
		case ("FJ") $index = 11		// 藤巻
		case ("TK") $index = 12		// ＴＫ
		case ("SN") $index = 13		// 椎名
		case ("YS") $index = 14		// 遊佐
		case ("HS") $index = 15		// ひさ子
		case ("SK") $index = 16		// 関根
		case ("IR") $index = 17		// 入江
		case ("CH") $index = 18		// チャー
		case ("TY") $index = 19		// 竹山
		case ("NA") $index = 20		// 直井
		case ("ST") $index = 21		// フィッシュ斎藤
		case ("IG") $index = 22		// 五十嵐
		case ("A1") $index = 23		// 赤目天使１
		case ("A2") $index = 24		// 赤目天使２
		case ("K1") $index = 25		// 影１
		case ("K2") $index = 26		// 影２
		case ("K3") $index = 27		// 影３
		case ("K4") $index = 28		// 影４
	}
	
	return ($index + 10)
}




//----------------------------------------------------------------------
// ＣＧカットイン(アプリケーション)
//----------------------------------------------------------------------
command $$evcm_05_cutin(property $filename : str)
{
	$$init_cutin_cg_all_param
	$$set_cutin_cg_param(-320, -250, 1500, 1500, 255, 0)
	$$set_cutin_cg_move_param(-380, -250, 1000, 2)
	$$set_cutin_cg_clip_param(0, 200, 1280, 350)
	$$set_cutin_cg_clip_move_param(0, 275, 1280, 275, 500, 2)
	$$set_cutin_cg_filter_param(255, 255, 255, 60)
	$$set_cutin_cg_border_param(2, 255, 255, 255, 128)
	$$set_cutin_cg_alpha_param(1, 500, 2, 2000, 1, 1000, 0)
	$$execute_cutin_cg(front.object[<CUTIN_OBJ_START_INDEX>], $filename)
}

command $$evyi_06_cutin
{
	$$init_cutin_cg_all_param
	$$set_cutin_cg_param(-40, -250, 1200, 1200, 255, 0)
	$$set_cutin_cg_move_param(-280, -250, 1000, 2)
	$$set_cutin_cg_clip_param(0, 100, 1280, 550)
	$$set_cutin_cg_filter_param(255, 255, 255, 255)
	$$set_cutin_cg_border_param(2, 255, 255, 255, 128)
	$$set_cutin_cg_alpha_param(1, 500, 2, 1000, 0, 500, 2)
	$cutin_cg_filter_param[0] = 2
	$$execute_cutin_cg(front.object[<CUTIN_OBJ_START_INDEX>], evyi_0613)
}

command $$cutin_ms_kn_core(property $obj : object, property $bg_name : str)
{
	$$set_child_object($obj, 6)
	$$execute_cutin_cg_core($obj)
	
	$$set_child_object($obj.child[1], 2)
	$obj.child[1].set_scale(1500, 1500)
	$obj.child[1].child[0].create($bg_name, 1)
	$obj.child[1].child[0].set_scale(1500, 1500)
	$obj.child[1].child[1].create("ef_cutin_kn01(0, 0, 1) | ef_cutin_kn01(0, 0, 2)", 1)		// 通常
}

command $$cutin_ey_kn_core(property $obj : object, property $bg_name : str)
{
	$$set_child_object($obj, 6)
	$$execute_cutin_cg_core($obj)
	
	$$set_child_object($obj.child[1], 2)
	$obj.child[1].set_scale(1500, 1500)
	$obj.child[1].child[0].create($bg_name, 1)
	$obj.child[1].child[0].set_scale(1500, 1500)
	$obj.child[1].child[1].create("ef_cutin_kn01(0, 0, 4) | ef_cutin_kn01(0, 0, 5)", 1)		// 赤目
}

command $$cutin_15b_ms_kn
{
	$$init_cutin_cg_all_param
	$$set_cutin_cg_param(-380, -450, 1500, 1500, 255, 1)
	$$set_cutin_cg_move_param(-340, -450, 1000, 2)
	$$set_cutin_cg_clip_param(0, 200, 1280, 350)
	$$set_cutin_cg_clip_move_param(0, 275, 1280, 275, 500, 2)
	$$set_cutin_cg_filter_param(255, 255, 255, 60)
	$$set_cutin_cg_border_param(2, 255, 255, 255, 128)
	$$set_cutin_cg_alpha_param(1, 500, 2, 2000, 0, 0, 0)
	
	$$cutin_ms_kn_core(front.object[<CUTIN_OBJ_START_INDEX>], ep88_bg043)
}

command $$cutin_02a_ms_kn
{
	$$init_cutin_cg_all_param
	$$set_cutin_cg_param(-380, -450, 1500, 1500, 255, 1)
	$$set_cutin_cg_move_param(-340, -450, 1000, 2)
	$$set_cutin_cg_clip_param(0, 200, 1280, 350)
	$$set_cutin_cg_clip_move_param(0, 275, 1280, 275, 500, 2)
	$$set_cutin_cg_filter_param(255, 255, 255, 60)
	$$set_cutin_cg_border_param(2, 255, 255, 255, 128)
	$$set_cutin_cg_alpha_param(1, 500, 2, 2000, 0, 0, 0)
	
	$$cutin_ms_kn_core(front.object[<CUTIN_OBJ_START_INDEX>], ep02_bg064)
}

command $$cutin_15b_ey_a1
{
	$$init_cutin_cg_all_param
	$$set_cutin_cg_param(-380, -200, 1500, 1500, 255, 1)
	$$set_cutin_cg_clip_param(0, 180, 1280, 370)
	$$set_cutin_cg_move_param(-340, -200, 300, 2)
	$$set_cutin_cg_clip_move_param(0, 275, 1280, 275, 300, 2)
	$$set_cutin_cg_border_param(2, 255, 255, 255, 128)
	$$set_cutin_cg_alpha_param(1, 500, 2, 2000, 0, 0, 0)
	
	$$cutin_ey_kn_core(front.object[<CUTIN_OBJ_START_INDEX>], bg_siro)
}

command $$cutin_17b_ey_a1
{
	$$init_cutin_cg_all_param
	$$set_cutin_cg_param(-380, -200, 1500, 1500, 255, 1)
	$$set_cutin_cg_clip_param(0, 180, 1280, 370)
	$$set_cutin_cg_move_param(-340, -200, 300, 2)
	$$set_cutin_cg_clip_move_param(0, 275, 1280, 275, 300, 2)
	$$set_cutin_cg_border_param(2, 255, 255, 255, 128)
	$$set_cutin_cg_alpha_param(1, 500, 2, 2000, 0, 0, 0)
	
	$$cutin_ey_kn_core(front.object[<CUTIN_OBJ_START_INDEX>], ep08_bg020)
	
	front.object[<CUTIN_OBJ_START_INDEX>].tonecurve_no = 7
}

command $$cutin_17b_ey_a1_erase
{
	$$init_cutin_cg_all_param
	
;	front.object[<CUTIN_OBJ_START_INDEX>].x_eve.set(-720, 500, 0, 2)
	front.object[<CUTIN_OBJ_START_INDEX>].tr_eve.set(0, 300, 0, 2)
}

//----------------------------------------------------------------------
//
// 特殊演出
//
//----------------------------------------------------------------------
command $$scroll_kn_set_core(property $obj1 : object, property $obj2 : object, property $obj3 : object)
{
	$obj1.set_pos(-120, 0)
	$obj1.x_eve.set(-50, 2500, 0, 2)
	$obj2.x_eve.set(-50, 2500, 0, 2)
	$obj3.x_eve.set(-50, 2500, 0, 2)
	$obj1.layer = -1000
	$obj2.layer = 300
	$obj3.layer = 300
	$obj2.tonecurve_no = 0
	$obj3.tonecurve_no = 0
}

command $$day00_scroll_kn_change_face(property $type)
{
	L[2] = <CUTIN_OBJ_START_INDEX> + 2
	
	if( $type )
	{
		front.object[L[2]].tr = 0
		front.object[L[2]].disp = 1
		front.object[L[2]].tr_eve.set(255, 300, 0, 0)
	}
	else
	{
		front.object[L[2]].tr_eve.set(0, 300, 0, 0)
	}
}

command $$day00_scroll_kn_set(property $filename : str)
{
	L[0] = <CUTIN_OBJ_START_INDEX>
	L[1] = <CUTIN_OBJ_START_INDEX> + 1
	L[2] = <CUTIN_OBJ_START_INDEX> + 2
	
	back.object[L[0]].create($filename, 1, 0, 0, 0)
	back.object[L[1]].create($filename, 1, 0, 0, 1)
	back.object[L[2]].create($filename, 0, 0, 0, 2)

	$$scroll_kn_set_core(back.object[L[0]], back.object[L[1]], back.object[L[2]])
}

command $$day22_scroll_kn_set
{
	K[0] = "ef_cutin_kn01"
	
	L[0] = <CUTIN_OBJ_START_INDEX>
	L[1] = <CUTIN_OBJ_START_INDEX> + 1
	L[2] = <CUTIN_OBJ_START_INDEX> + 2
	
	back.object[L[0]].create(K[0], 1, 0, 0, 3)
	back.object[L[1]].create(K[0], 1, 0, 0, 4)
	back.object[L[2]].create(K[0], 0, 0, 0, 5)
	
	$$scroll_kn_set_core(back.object[L[0]], back.object[L[1]], back.object[L[2]])
}

command $$day24_scroll_a1_set
{
	K[0] = "ef_cutin_kn01"
	
	L[0] = <CUTIN_OBJ_START_INDEX>
	L[1] = <CUTIN_OBJ_START_INDEX> + 1
	L[2] = <CUTIN_OBJ_START_INDEX> + 2
	
	back.object[L[0]].create(K[0], 1, 0, 0, 6)
	back.object[L[1]].create(K[0], 1, 0, 0, 4)
	back.object[L[2]].create(K[0], 0, 0, 0, 5)
	
	$$scroll_kn_set_core(back.object[L[0]], back.object[L[1]], back.object[L[2]])
	
	back.object[L[1]].tonecurve_no = 7
	back.object[L[2]].tonecurve_no = 7
}

command $$day24_scroll_a2_set
{
	K[0] = "ef_cutin_kn01"
	
	L[0] = <CUTIN_OBJ_START_INDEX>
	L[1] = <CUTIN_OBJ_START_INDEX> + 1
	L[2] = <CUTIN_OBJ_START_INDEX> + 2
	
	back.object[L[0]].create(K[0], 1, 0, 0, 7)
	back.object[L[1]].create(K[0], 1, 0, 0, 4)
	back.object[L[2]].create(K[0], 0, 0, 0, 5)
	
	$$scroll_kn_set_core(back.object[L[0]], back.object[L[1]], back.object[L[2]])
}
