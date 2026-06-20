/********************************************************
*														*
*						画面演出						*
*														*
*********************************************************/
#define		@OBJ_EF_SCREEN01			232		// 回想
#define		@OBJ_EF_SCREEN02			233		// 集中線
#define		@OBJ_EF_SCREEN03			234		// お風呂の湯気
#define		@OBJ_EF_SCREEN04			235		// お風呂の湯気
#define		@OBJ_EF_SCREEN05			236		// 陽光
#define		@OBJ_EF_SCREEN06			237
#define		@OBJ_EF_SCREEN07			238
#define		@OBJ_EF_SCREEN08			239
#define		@OBJ_EF_SCREEN09			240
#define		@OBJ_EF_SCREEN10			241
#define		@OBJ_EF_SCREEN11			242
#define		@OBJ_EF_SCREEN12			243
#define		@OBJ_EF_SCREEN13			244
#define		@OBJ_EF_SCREEN14			245		// 実績用のポップアップ
#define		@OBJ_EF_SCREEN15			246		// ハンドソニック
#define		@OBJ_EF_SCREEN16			247		// ディストーション
#define		@OBJ_EF_SCREEN17			248		// 視点変更
#define		@OBJ_EF_SCREEN18			249
#define		@OBJ_EF_SCREEN19			250
#define		@OBJ_EF_SCREEN20			251		// 以下、30まで_ef_macro.ssで使用するオブジェクト
#define		@OBJ_EF_SCREEN21			252
#define		@OBJ_EF_SCREEN22			253
#define		@OBJ_EF_SCREEN23			254
#define		@OBJ_EF_SCREEN24			255
#define		@OBJ_EF_SCREEN25			256
#define		@OBJ_EF_SCREEN26			257
#define		@OBJ_EF_SCREEN27			258
#define		@OBJ_EF_SCREEN28			259
#define		@OBJ_EF_SCREEN29			260
#define		@OBJ_EF_SCREEN30			261


/********************************************************
*														*
*						クエイク						*
*														*
*********************************************************/
#define		@qk_num1	0		// 縦揺れ
#define		@qk_num2	1		// 横揺れ
#define		@qk_num3	2		// 拡縮

// ---------------------------------------------------------------
// 画面縦揺れ
// ---------------------------------------------------------------
#macro		@QUAKE_UD(@TIME, @CNT, @END_CNT, @POWER, @ORDER(0), @WAIT(0))
			$quake1(@TIME, @CNT, @END_CNT, @POWER, @ORDER, @WAIT, 0, 0)

#macro		@QUAKE_UD_ALL(@TIME, @CNT, @END_CNT, @POWER, @WAIT(0))
			$quake1(@TIME, @CNT, @END_CNT, @POWER, -1, @WAIT, 0, 1)

// ---------------------------------------------------------------
// 画面横揺れ
// ---------------------------------------------------------------
#macro		@QUAKE_LR(@TIME, @CNT, @END_CNT, @POWER, @ORDER(0), @WAIT(0))
			$quake1(@TIME, @CNT, @END_CNT, @POWER, @ORDER, @WAIT, 6, 0)

#macro		@QUAKE_LR_ALL(@TIME, @CNT, @END_CNT, @POWER, @WAIT(0))
			$quake1(@TIME, @CNT, @END_CNT, @POWER, -1, @WAIT, 6, 1)

// ---------------------------------------------------------------
// 画面縦横揺れ
// ---------------------------------------------------------------
#macro		@QUAKE_UDLR(@TIME1, @CNT1, @END_CNT1, @POWER1, @TIME2, @CNT2, @END_CNT2, @POWER2, @ORDER(0), @WAIT(0))
			$quake2(@TIME1, @CNT1, @END_CNT1, @POWER1, @TIME2, @CNT2, @END_CNT2, @POWER2, @ORDER, @WAIT, 0)

#macro		@QUAKE_UDLR_ALL(@TIME1, @CNT1, @END_CNT1, @POWER1, @TIME2, @CNT2, @END_CNT2, @POWER2, @WAIT(0))
			$quake2(@TIME1, @CNT1, @END_CNT1, @POWER1, @TIME2, @CNT2, @END_CNT2, @POWER2, -1, @WAIT, 1)

// ---------------------------------------------------------------
// 画面拡縮
// ---------------------------------------------------------------
#macro		@QUAKE_ZOOM(@TIME, @CNT, @END_CNT, @SCALE, @CENTER_X(640), @CENTER_Y(360), @ORDER(0), @WAIT(0))
			$quake_zoom(@TIME, @CNT, @END_CNT, @SCALE, @CENTER_X, @CENTER_Y, @ORDER, @WAIT, 0)

#macro		@QUAKE_ZOOM_ALL(@TIME, @CNT, @END_CNT, @SCALE, @CENTER_X(640), @CENTER_Y(360), @WAIT(0))
			$quake_zoom(@TIME, @CNT, @END_CNT, @SCALE, @CENTER_X, @CENTER_Y, -1, @WAIT, 1)

// ---------------------------------------------------------------
// 画面揺れ停止
// ---------------------------------------------------------------
#macro		@QUAKE_END(@TIME(0))
			screen.quake[@qk_num1].end(@TIME)
			screen.quake[@qk_num2].end(@TIME)

#macro		@QUAKE_ZOOM_END(@TIME(0))
			screen.quake[@qk_num3].end(@TIME)

#macro		@QUAKE_END_ALL(@TIME(0))
			screen.quake[@qk_num1].end(@TIME)
			screen.quake[@qk_num2].end(@TIME)
			screen.quake[@qk_num3].end(@TIME)


#command	$quake1(int, int, int, int, int, int, int, int)
#command	$quake2(int, int, int, int, int, int, int, int, int, int, int)
#command	$quake_zoom(int, int, int, int, int, int, int, int, int)


/********************************************************
*														*
*					画面揺れ（簡易）					*
*														*
*********************************************************/
#macro		@縦揺れ_弱(@FLASH(0), @WAIT(1))
			$screen_shake(0, @FLASH, @WAIT)

#macro		@横揺れ_弱(@FLASH(0), @WAIT(1))
			$screen_shake(1, @FLASH, @WAIT)

#macro		@拡縮_弱(@FLASH(0), @WAIT(1))
			$screen_shake(2, @FLASH, @WAIT)

#macro		@縦揺れ_強(@FLASH(0), @WAIT(1))
			$screen_shake(3, @FLASH, @WAIT)

#macro		@横揺れ_強(@FLASH(0), @WAIT(1))
			$screen_shake(4, @FLASH, @WAIT)

#macro		@拡縮_強(@FLASH(0), @WAIT(1))
			$screen_shake(5, @FLASH, @WAIT)

#command	$screen_shake(int, int, int)


/********************************************************
*														*
*						画面効果						*
*														*
*********************************************************/
#define		@SC_BN_LAYER00		-10000
#define		@SC_EN_LAYER01		-1
#define		@SC_EN_LAYER02		999

#define		@SC_TR_DEF			255
#define		@SC_LAYER_DEF		2

#define		@SC_LAYER_NUM		$sc_layer_num
#define		@SC_TR_NUM			$sc_tr_num
#property	$sc_layer_num : int
#property	$sc_tr_num : int

#define		@SC_LAYER_BG
			@SC_LAYER(0)

#define		@SC_LAYER_ALL
			@SC_LAYER(1)

#macro		@SC_TR(@TR_NUM)
			@SC_TR_NUM = @TR_NUM

#macro		@SC_LAYER(@LY_NUM)
			@SC_LAYER_NUM = @LY_NUM

#define		@SC_DEL
			@SC_MONO(@Off)
			@SC_SEPIA(@Off)
			@SC_NEGA(@Off)
			@SC_FILTER_B(0, 0, 0)
			@SC_FILTER_W(0, 0, 0)
			@SC_FILTER_R(0, 0, 0)

#define		@SC_FILTER_OFF
			@SC_MONO(@Off)
			@SC_SEPIA(@Off)
			@SC_NEGA(@Off)
			@SC_FILTER_B(0, 0, 0)
			@SC_FILTER_W(0, 0, 0)
			@SC_FILTER_R(0, 0, 0)

// ---------------------------------------------------------------
// 白／赤／黒フラッシュ（パラメータで様々なフラッシュが可能に）
// ---------------------------------------------------------------
#macro		@SC_FLASH_W(@TIME(300), @CNT(1), @LAST_SLOW(0), @LAST_TIME(1500), @EV_NAME("None"))
			$sc_flash(@TIME, @CNT, @LAST_SLOW, @LAST_TIME, @EV_NAME, 255, 255, 255)

#macro		@SC_FLASH_R(@TIME(300), @CNT(1), @LAST_SLOW(0), @LAST_TIME(1500), @EV_NAME("None"))
			$sc_flash(@TIME, @CNT, @LAST_SLOW, @LAST_TIME, @EV_NAME, 255, 0, 0)

#macro		@SC_FLASH_B(@TIME(300), @CNT(1), @LAST_SLOW(0), @LAST_TIME(1500), @EV_NAME("None"))
			$sc_flash(@TIME, @CNT, @LAST_SLOW, @LAST_TIME, @EV_NAME, 0, 0, 0)

#macro		@SC_FLASH(@TIME(300), @CNT(1), @LAST_SLOW(0), @LAST_TIME(1500), @EV_NAME("None"), @COLOR_R, @COLOR_G, @COLOR_B)
			$sc_flash(@TIME, @CNT, @LAST_SLOW, @LAST_TIME, @EV_NAME, @COLOR_R, @COLOR_G, @COLOR_B)

#command	$sc_flash(int, int, int, int, str, int, int, int)

// ---------------------------------------------------------------
// 白／赤／黒フラッシュループ（パラメータで様々なフラッシュが可能に）
// ---------------------------------------------------------------
#macro		@SC_FLASH_WL(@STIME, @WTIME, @ETIME, @SMOD(0), @EMOD(0))
			$sc_flash_lp(@STIME, @WTIME, @ETIME, @SMOD, @EMOD, 255, 255, 255, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02, @SC_TR_NUM)

#macro		@SC_FLASH_RL(@STIME, @WTIME, @ETIME, @SMOD(0), @EMOD(0))
			$sc_flash_lp(@STIME, @WTIME, @ETIME, @SMOD, @EMOD, 255, 0, 0, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02, @SC_TR_NUM)

#macro		@SC_FLASH_BL(@STIME, @WTIME, @ETIME, @SMOD(0), @EMOD(0))
			$sc_flash_lp(@STIME, @WTIME, @ETIME, @SMOD, @EMOD, 0, 0, 0, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02, @SC_TR_NUM)

#macro		@SC_FLASH_L(@STIME, @WTIME, @ETIME, @SMOD(0), @EMOD(0), @CL_R, @CL_G, @CL_B)
			$sc_flash_lp(@STIME, @WTIME, @ETIME, @SMOD, @EMOD, @CL_R, @CL_G, @CL_B, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02, @SC_TR_NUM)

// フラッシュループ停止
#macro		@SC_FLASH_END
			frame_action_ch[1].end
			screen.effect[0].init

#command	$sc_flash_lp(int, int, int, int, int, int, int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// モノクロ
// ---------------------------------------------------------------
#macro		@SC_MONO(@SWITCH, @TIME(0), @WAIT(0))
			$sc_mono(@SWITCH, @TIME, @WAIT, @SC_TR_NUM, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$sc_mono(int, int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// セピア
// ---------------------------------------------------------------
#macro		@SC_SEPIA(@SWITCH, @TIME(0), @WAIT(0))
			$sc_sepia(@SWITCH, @TIME, @WAIT, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$sc_sepia(int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// ネガ反転
// ---------------------------------------------------------------
#macro		@SC_NEGA(@SWITCH, @TIME(0), @WAIT(0))
			$sc_nega(@SWITCH, @TIME, @WAIT, @SC_TR_NUM, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$sc_nega(int, int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// 黒フィルター
// ---------------------------------------------------------------
#macro		@SC_FILTER_B(@TR, @TIME(0), @WAIT(0))
			$sc_filter_b(@TR, @TIME, @WAIT, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$sc_filter_b(int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// 白フィルター
// ---------------------------------------------------------------
#macro		@SC_FILTER_W(@TR, @TIME(0), @WAIT(0))
			$sc_filter_w(@TR, @TIME, @WAIT, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$sc_filter_w(int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// 赤フィルター
// ---------------------------------------------------------------
#macro		@SC_FILTER_R(@TR, @TIME, @WAIT(0))
			$sc_filter_r(@TR, @TIME, @WAIT,  @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$sc_filter_r(int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// シネマスコープ表示（簡易）
// ---------------------------------------------------------------
#macro		@SC_CINEMA(@CS_LENGTH(100), @CS_TR(255), @COLOR_R(0), @COLOR_G(0), @COLOR_B(0))
			$sc_cinemascope(@CS_LENGTH, @CS_TR, @COLOR_R, @COLOR_G, @COLOR_B)

#command	$sc_cinemascope(int, int, int, int, int)

// ---------------------------------------------------------------
// シネマスコープ表示
// ---------------------------------------------------------------
#macro		@SC_CINEMA_SET(@CS_SWITCH, @CS_TIME(500), @CS_LENGTH(100), @COLOR_R(0), @COLOR_G(0), @COLOR_B(0), @CS_TR(255), @CS_MOD(2), @CS_WAIT(0))
			$sc_cinemascope_set(@CS_SWITCH, @CS_LENGTH, @CS_TIME, @COLOR_R, @COLOR_G, @COLOR_B, @CS_TR, @CS_MOD, @CS_WAIT)

#command	$sc_cinemascope_set(int, int, int, int, int, int, int, int, int)

// ---------------------------------------------------------------
// シネマスコープ消去
// ---------------------------------------------------------------
#macro		@SC_CINEMA_OFF(@DUMMY(0))
			$sc_cinemascope_off(@DUMMY)

#command	$sc_cinemascope_off(int)

// ---------------------------------------------------------------
// 回想
// ---------------------------------------------------------------
#macro		@回想開始(@color("白"))
			$sc_recollect(@color)


#define		@回想終了
			$sc_recollect_end

#command	$sc_recollect(str)

#command	$sc_recollect_end

// ---------------------------------------------------------------
// 集中線
// ---------------------------------------------------------------
#define		@集中線開始
			$sc_conline(@On)


#define		@集中線終了
			$sc_conline(@Off)

#command	$sc_conline(int)


/********************************************************
*														*
*					ガードスキル						*
*														*
*********************************************************/
// ---------------------------------------------------------------
// ハンドソニック
// ---------------------------------------------------------------
#macro		@ハンドソニック(@BS_SIZE(1), @BS_NUM(1))
			$gs_handsonic(@BS_SIZE, @BS_NUM, 11)

#macro		@赤目１ハンドソニック(@BS_SIZE(1), @BS_NUM(1))
			$gs_handsonic(@BS_SIZE, @BS_NUM, 33)

#macro		@赤目２ハンドソニック(@BS_SIZE(1), @BS_NUM(1))
			$gs_handsonic(@BS_SIZE, @BS_NUM, 34)

#command	$gs_handsonic(int, int, int)


/********************************************************
*														*
*					お風呂の湯気						*
*														*
*********************************************************/
#define		@湯気
			$ef_bath01(0)

#define		@湯気消去
			$ef_bath01(1)

#command	$ef_bath01(int)


/********************************************************
*														*
*						陽光							*
*														*
*********************************************************/
#macro		@陽光(@bg, @scale(0))
			$ef_sunshine(@bg, @scale)

#command	$ef_sunshine(str, int)


