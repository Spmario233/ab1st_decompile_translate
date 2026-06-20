//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_cutin_macro.inc
//	@author		Kazuya Takahashi
//	@note		カットイン処理
//
//-----------------------------------------------------------------------------------------------

//----------------------------------------------------------------------
//
// 定義
//
//----------------------------------------------------------------------
// 汎用定義
#define		@SCREEN_WIDTH		1280
#define		@SCREEN_HEIGHT		720
#define		@SCREEN_CENTER_X	(@SCREEN_WIDTH  / 2)
#define		@SCREEN_CENTER_Y	(@SCREEN_HEIGHT / 2)

#define		<INVALID_STR>		"none"

// バストショットカットインタイプ
#define		<CUTIN_TYPE1_C>			0		// 斜め区切り：中
#define		<CUTIN_TYPE1_L>			1		// 斜め区切り：左
#define		<CUTIN_TYPE1_R>			2		// 斜め区切り：右
#define		<CUTIN_TYPE2_L>			3		// 斜め区切り：左(広)
#define		<CUTIN_TYPE2_R>			4		// 斜め区切り：右(広)
#define		<CUTIN_TYPE3_M>			5		// 横区切り：中
#define		<CUTIN_TYPE4_U>			6		// 横区切り：上(キャラ右)
#define		<CUTIN_TYPE4_D>			7		// 横区切り：下(キャラ左)
#define		<CUTIN_TYPE5_M>			8		// 横区切り：中
#define		<CUTIN_TYPE6_M>			9		// 横区切り：中下
#define		<CUTIN_TYPE7_M>			10		// 横区切り：中上
#define		<CUTIN_TYPE_MAX>		11


//----------------------------------------------------------------------
//
// バストショットカットイン
//
//----------------------------------------------------------------------
#macro	@cutin_c(@bs_name, @bg_name(<INVALID_STR>))		// type1
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE1_C>)

#macro	@cutin_l(@bs_name, @bg_name(<INVALID_STR>))		// type1
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE1_L>)

#macro	@cutin_r(@bs_name, @bg_name(<INVALID_STR>))		// type1
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE1_R>)

#macro	@cutin_l2(@bs_name, @bg_name(<INVALID_STR>))	// type2
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE2_L>)

#macro	@cutin_r2(@bs_name, @bg_name(<INVALID_STR>))	// type2
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE2_R>)

#macro	@cutin_m(@bs_name, @bg_name(<INVALID_STR>))		// type3
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE3_M>)

#macro	@cutin_u(@bs_name, @bg_name(<INVALID_STR>))		// type4
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE4_U>)

#macro	@cutin_d(@bs_name, @bg_name(<INVALID_STR>))		// type4
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE4_D>)

#macro	@cutin_m2(@bs_name, @bg_name(<INVALID_STR>))	// type5
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE5_M>)

#macro	@cutin_m3(@bs_name, @bg_name(<INVALID_STR>))	// type6
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE6_M>)
	
#macro	@cutin_m4(@bs_name, @bg_name(<INVALID_STR>))	// type7
	@cutin_base(@bs_name, @bg_name, <CUTIN_TYPE7_M>)

#macro	@cutin_base(@bg_name, @bs_name, @type)
	$$show_cutin_bs(@bg_name, @bs_name, @type)

#macro	@cutin_c_end	@cutin_end_base(<CUTIN_TYPE1_C>)		// type1
#macro	@cutin_l_end	@cutin_end_base(<CUTIN_TYPE1_L>)		// type1
#macro	@cutin_r_end	@cutin_end_base(<CUTIN_TYPE1_R>)		// type1
#macro	@cutin_l2_end	@cutin_end_base(<CUTIN_TYPE2_L>)		// type2
#macro	@cutin_r2_end	@cutin_end_base(<CUTIN_TYPE2_R>)		// type2
#macro	@cutin_m_end	@cutin_end_base(<CUTIN_TYPE3_M>)		// type3
#macro	@cutin_u_end	@cutin_end_base(<CUTIN_TYPE4_U>)		// type4
#macro	@cutin_d_end	@cutin_end_base(<CUTIN_TYPE4_D>)		// type4
#macro	@cutin_m2_end	@cutin_end_base(<CUTIN_TYPE5_M>)		// type5
#macro	@cutin_m3_end	@cutin_end_base(<CUTIN_TYPE6_M>)		// type6
#macro	@cutin_m4_end	@cutin_end_base(<CUTIN_TYPE7_M>)		// type7

#macro	@cutin_end_base(@type)
	$$hide_cutin_bs(@type)

#macro	@cutin_c_end_wipe	@cutin_end_wipe(<CUTIN_TYPE1_C>)

#macro	@cutin_end_wipe(@type)
	$$wipe_off_cutin_bs(@type, 1, 1500)

#command	$$show_cutin_bs(str, str, int)
#command	$$hide_cutin_bs(int)
#command	$$wipe_off_cutin_bs(int, int, int)

#command	$$get_bs_obj_index(str) : int
#command	$$copy_temporary_bs(object, str) : int

//----------------------------------------------------------------------
//
// ＣＧカットイン
//
//----------------------------------------------------------------------
#command	$$init_cutin_cg_all_param			// ＣＧカットインパラメータの初期化

#command	$$set_cutin_cg_param(int, int, int, int, int, int)				// ＣＧカットインパラメータ設定
#command	$$set_cutin_cg_move_param(int, int, int, int)					// ＣＧカットインの移動パラメータ設定
#command	$$set_cutin_cg_filter_param(int, int, int, int)					// ＣＧカットインのフィルターパラメータ設定
#command	$$set_cutin_cg_clip_param(int, int, int, int)					// ＣＧカットインのクリップパラメータ設定
#command	$$set_cutin_cg_clip_move_param(int, int, int, int, int, int)	// ＣＧカットインのクリップ移動パラメータ設定
#command	$$set_cutin_cg_border_param(int, int, int, int, int)			// ＣＧカットインのボーダーパラメータ設定
#command	$$set_cutin_cg_alpha_param(int, int, int, int, int, int, int)	// ＣＧカットインのアルファパラメータ設定

#command	$$execute_cutin_cg(object, str)		// ＣＧカットインの実行

//----------------------------------------------------------------------
//
// ＣＧカットイン(アプリケーション)
//
//----------------------------------------------------------------------
#command	$$evcm_05_cutin(str)				// evcm05
#command	$$cutin_02a_ms_kn					// 02a_ms_kn
#command	$$cutin_15b_ms_kn					// 15b_ms_kn
#command	$$cutin_15b_ey_a1					// 15b_ey_a1
#command	$$cutin_17b_ey_a1					// 17b_ey_a1
#command	$$cutin_17b_ey_a1_erase				// 17b_ey_a1
#command	$$evyi_06_cutin						// evyi06


//----------------------------------------------------------------------
//
// 特殊演出
//
//----------------------------------------------------------------------
#command	$$day00_scroll_kn_set(str)			// ef_cutin_kn01
#command	$$day00_scroll_kn_change_face(int)	// ef_cutin_kn01
#command	$$day22_scroll_kn_set				// ef_cutin_kn01
#command	$$day24_scroll_a1_set				// ef_cutin_kn01
#command	$$day24_scroll_a2_set				// ef_cutin_kn01
