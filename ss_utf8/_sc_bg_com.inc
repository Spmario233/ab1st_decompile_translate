/********************************************************
*														*
*				背景／イベントＣＧ表示					*
*														*
*********************************************************/
// 背景オブジェクト
#define		@OBJ_BGXX			0	// フェード
#define		@OBJ_BG01			1	// 通常使用
#define		@OBJ_BG02			2	// 
#define		@OBJ_BG03			3	// 
#define		@OBJ_BG04			4	// 
#define		@OBJ_BG05			5	// 演出用（オートセーブしました）
#define		@OBJ_BG06			6	// 
#define		@OBJ_BG07			7	// 
#define		@OBJ_BG08			8	// 
#define		@OBJ_BG09			9	// 
#define		@bg_maxnum			9	// ゲーム毎に設定
#define		_ObjBgBase00		0
#define		_ObjBgFace00		1

#property	$bg_name          : strlist[@bg_maxnum]
#property	$bg_blur          : intlist[@bg_maxnum]
#property	$bg_blur_prev     : intlist[@bg_maxnum]
#property	$bg_wipe          : intlist[@bg_maxnum]
#property	$bg_exist_decide  : intlist[@bg_maxnum]

#property	$bg_base          : intlist[@bg_maxnum]
#property	$bg_face          : intlist[@bg_maxnum]

#property	$bg_posx_prev     : intlist[@bg_maxnum]
#property	$bg_posx_next     : intlist[@bg_maxnum]

#property	$bg_posy_prev     : intlist[@bg_maxnum]
#property	$bg_posy_next     : intlist[@bg_maxnum]

#property	$bg_tr_prev       : intlist[@bg_maxnum]
#property	$bg_tr_next       : intlist[@bg_maxnum]

#property	$bg_patno_prev    : intlist[@bg_maxnum]
#property	$bg_patno_next    : intlist[@bg_maxnum]

#property	$bg_scale_x_prev  : intlist[@bg_maxnum]
#property	$bg_scale_x_next  : intlist[@bg_maxnum]

#property	$bg_scale_y_prev  : intlist[@bg_maxnum]
#property	$bg_scale_y_next  : intlist[@bg_maxnum]

#property	$bg_rotate_z_prev   : intlist[@bg_maxnum]
#property	$bg_rotate_z_next   : intlist[@bg_maxnum]

#property	$bg_rotate_loop     : intlist[@bg_maxnum]

#property	$bg_center_rep_x_prev : intlist[@bg_maxnum]
#property	$bg_center_rep_x_next : intlist[@bg_maxnum]

#property	$bg_center_rep_y_prev : intlist[@bg_maxnum]
#property	$bg_center_rep_y_next : intlist[@bg_maxnum]

#property	$bg_action_num        : intlist[@bg_maxnum]
#property	$bg_action_time       : intlist[@bg_maxnum]
#property	$bg_action_time_delay : intlist[@bg_maxnum]
#property	$bg_action_end_time   : intlist[@bg_maxnum]
#property	$bg_action_speed_mod  : intlist[@bg_maxnum]

#property	$bg_disp_cnt      : int
#property	$bg_wipe_set      : int
#property	$bg_set_ready     : int
#property	$wipe_wait        : int
#property	$sys_wipe         : int
#property	$bg_time_set      : int

#command	$bg_blur_switch(int) : int
#command	$bg_disp_in(str, int, int, int, int) : int
#command	$bg_all_disp_in(str, int, int, int, int) : int
#command	$bg_disp_sp_in(str, int, int, int, int, int, int, int, int)
#command	$bg_all_disp_sp_in(str, int, int, int, int, int, int, int, int)
#command	$sys_bg_disp_in(str, int, int, int) : int

#command	$bg_disp(int) : int
#command	$bg_disp_set(int) : int
#command	$bg_disp_sp(int) : int

// ---------------------------------------------------------------
// 背景ぼかし
// ---------------------------------------------------------------
#macro		@BG_BLUR(@SWITCH)
			$bg_blur_switch(@SWITCH)

// ---------------------------------------------------------------
// 背景表示
// ---------------------------------------------------------------
#macro		@BG(@BG_NAME, @SEL(3), @WAIT(1))
			$bg_type = _type_bg
			$bg_disp_in(@BG_NAME, @SEL, @WAIT, @OFF, @OFF)

// ---------------------------------------------------------------
// 背景表示[メッセージウィンドウワイプ]
// ---------------------------------------------------------------
#macro		@BG_ALL(@BG_NAME, @SEL(3), @WAIT(1))
			$bg_type = _type_bg
			$bg_all_disp_in(@BG_NAME, @SEL, @WAIT, @OFF, @ON)

// ---------------------------------------------------------------
// 背景／システム表示
// ---------------------------------------------------------------
#macro		@SYS_BG(@BG_NAME, @SEL, @WAIT(1), @SYS(1))
			$bg_type = _type_bg
			$sys_bg_disp_in(@BG_NAME, @SEL, @WAIT, @SYS)

// ---------------------------------------------------------------
// イベントＣＧ表示[統合]
// ---------------------------------------------------------------
#macro		@CG1(@CG_NAME, @SEL(0), @WAIT(1))
			$bg_type = _type_cg1
			$bg_disp_in(@CG_NAME, @SEL, @WAIT, @OFF, @OFF)

// ---------------------------------------------------------------
// イベントＣＧ表示[分割]
// ---------------------------------------------------------------
#macro		@CG2(@CG_NAME, @SEL(0), @WAIT(1))
			$bg_type = _type_cg2
			$bg_disp_in(@CG_NAME, @SEL, @WAIT, @OFF, @OFF)

// ---------------------------------------------------------------
// イベントＣＧ表示[分割ＳＰ]
// ---------------------------------------------------------------
#macro		@CG3(@CG_NAME, @SEL, @BG_BASE, @BG_FACE01, @BG_FACE02(-9999), @BG_FACE03(-9999), @WAIT(1))
			$bg_type = _type_cg3
			$bg_disp_sp_in(@CG_NAME, @SEL, @WAIT, @OFF, @OFF, @BG_BASE, @BG_FACE01, @BG_FACE02, @BG_FACE03)

// ---------------------------------------------------------------
// イベントＣＧ表示[統合][メッセージウィンドウワイプ]
// ---------------------------------------------------------------
#macro		@CG1_ALL(@CG_NAME, @SEL(0), @WAIT(1))
			$bg_type = _type_cg1
			$bg_all_disp_in(@CG_NAME, @SEL, @WAIT, @OFF, @ON)

// ---------------------------------------------------------------
// イベントＣＧ表示[分割][メッセージウィンドウワイプ]
// ---------------------------------------------------------------
#macro		@CG2_ALL(@CG_NAME, @SEL(0), @WAIT(1))
			$bg_type = _type_cg2
			$bg_all_disp_in(@CG_NAME, @SEL, @WAIT, @OFF, @ON)

// ---------------------------------------------------------------
// イベントＣＧ表示[分割ＳＰ][メッセージウィンドウワイプ]
// ---------------------------------------------------------------
#macro		@CG3_ALL(@CG_NAME, @SEL, @BG_BASE, @BG_FACE01, @BG_FACE02(-9999), @BG_FACE03(-9999), @WAIT(1))
			$bg_type = _type_cg3
			$bg_sp_all_disp_in(@CG_NAME, @SEL, @WAIT, @OFF, @ON, @BG_BASE, @BG_FACE01, @BG_FACE02, @BG_FACE03, @ON)



#property	$bg_type : int
#define		_type_bg	0
#define		_type_cg1	1
#define		_type_cg2	2
#define		_type_cg3	3


// ---------------------------------------------------------------
// 背景／イベントＣＧ準備
// ---------------------------------------------------------------
#macro		@BG_SET(@BG_NAME, @WAIT(1), @POS_X(0), @POS_Y(0), @TR(255), @PATNO(0), @SCALE_X(100), @SCALE_Y(100), @ROTATE(0), @CENTER_X(640), @CENTER_Y(360))
			$bg_type = _type_bg
			$bg_set(@BG_NAME, @WAIT, @POS_X, @POS_Y, @TR, @PATNO, @SCALE_X, @SCALE_Y, @ROTATE, @CENTER_X, @CENTER_Y)

#macro		@CG1_SET(@BG_NAME, @WAIT(1), @POS_X(0), @POS_Y(0), @TR(255), @PATNO(0), @SCALE_X(100), @SCALE_Y(100), @ROTATE(0), @CENTER_X(640), @CENTER_Y(360))
			$bg_type = _type_cg1
			$bg_set(@BG_NAME, @WAIT, @POS_X, @POS_Y, @TR, @PATNO, @SCALE_X, @SCALE_Y, @ROTATE, @CENTER_X, @CENTER_Y)

#macro		@CG2_SET(@BG_NAME, @WAIT(1), @POS_X(0), @POS_Y(0), @TR(255), @PATNO(0), @SCALE_X(100), @SCALE_Y(100), @ROTATE(0), @CENTER_X(640), @CENTER_Y(360))
			$bg_type = _type_cg2
			$bg_set(@BG_NAME, @WAIT, @POS_X, @POS_Y, @TR, @PATNO, @SCALE_X, @SCALE_Y, @ROTATE, @CENTER_X, @CENTER_Y)

#macro		@CG3_SET(@BG_NAME, @WAIT(1), @POS_X(0), @POS_Y(0), @TR(255), @PATNO(0), @SCALE_X(100), @SCALE_Y(100), @ROTATE(0), @CENTER_X(640), @CENTER_Y(360))
			$bg_type = _type_cg3
			$bg_set(@BG_NAME, @WAIT, @POS_X, @POS_Y, @TR, @PATNO, @SCALE_X, @SCALE_Y, @ROTATE, @CENTER_X, @CENTER_Y)

// ---------------------------------------------------------------
// 背景／イベントＣＧ指定表示 [座標]
// ---------------------------------------------------------------
#macro		@BG_POS_EVENT(@BG_NUM, @TIME, @POS_X, @POS_Y(-999999), @POS_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_bg
			$bg_pos_event(@BG_NUM, @TIME, @POS_X, @POS_Y, @POS_DELAY, @SPEED_MOD)

#macro		@CG1_POS_EVENT(@BG_NUM, @TIME, @POS_X, @POS_Y(-999999), @POS_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg1
			$bg_pos_event(@BG_NUM, @TIME, @POS_X, @POS_Y, @POS_DELAY, @SPEED_MOD)

#macro		@CG2_POS_EVENT(@BG_NUM, @TIME, @POS_X, @POS_Y(-999999), @POS_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg2
			$bg_pos_event(@BG_NUM, @TIME, @POS_X, @POS_Y, @POS_DELAY, @SPEED_MOD)

#macro		@CG3_POS_EVENT(@BG_NUM, @TIME, @POS_X, @POS_Y(-999999), @POS_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg3
			$bg_pos_event(@BG_NUM, @TIME, @POS_X, @POS_Y, @POS_DELAY, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景／イベントＣＧ指定表示 [不透明度]
// ---------------------------------------------------------------
#macro		@BG_TR_EVENT(@BG_NUM, @TIME, @TR, @TR_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_bg
			$bg_tr_event(@BG_NUM, @TIME, @TR, @TR_DELAY, @SPEED_MOD)

#macro		@CG1_TR_EVENT(@BG_NUM, @TIME, @TR, @TR_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg1
			$bg_tr_event(@BG_NUM, @TIME, @TR, @TR_DELAY, @SPEED_MOD)

#macro		@CG2_TR_EVENT(@BG_NUM, @TIME, @TR, @TR_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg2
			$bg_tr_event(@BG_NUM, @TIME, @TR, @TR_DELAY, @SPEED_MOD)

#macro		@CG3_TR_EVENT(@BG_NUM, @TIME, @TR, @TR_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg3
			$bg_tr_event(@BG_NUM, @TIME, @TR, @TR_DELAY, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景／イベントＣＧ指定表示 [拡大／縮小]
// ---------------------------------------------------------------
#macro		@BG_SC_EVENT(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y(999999), @SCALE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_bg
			$bg_sc_event(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y, @SCALE_DELAY, @SPEED_MOD)

#macro		@CG1_SC_EVENT(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y(999999), @SCALE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg1
			$bg_sc_event(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y, @SCALE_DELAY, @SPEED_MOD)

#macro		@CG2_SC_EVENT(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y(999999), @SCALE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg2
			$bg_sc_event(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y, @SCALE_DELAY, @SPEED_MOD)

#macro		@CG3_SC_EVENT(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y(999999), @SCALE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg3
			$bg_sc_event(@BG_NUM, @TIME, @SCALE_X, @SCALE_Y, @SCALE_DELAY, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景／イベントＣＧ指定表示 [回転]
// ---------------------------------------------------------------
#macro		@BG_RO_EVENT(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_bg
			$bg_ro_event(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY, @SPEED_MOD)

#macro		@CG1_RO_EVENT(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg1
			$bg_ro_event(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY, @SPEED_MOD)

#macro		@CG2_RO_EVENT(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg2
			$bg_ro_event(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY, @SPEED_MOD)

#macro		@CG3_RO_EVENT(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg3
			$bg_ro_event(@BG_NUM, @TIME, @ROTATE_LOOP, @ROTATE, @ROTATE_DELAY, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景／イベントＣＧ指定表示 [パターン]
// ---------------------------------------------------------------
#macro		@BG_PAT_EVENT(@BG_NUM, @TIME, @PATNO, @PAT_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_bg
			$bg_pat_event(@BG_NUM, @TIME, @PATNO, @PAT_DELAY, @SPEED_MOD)

#macro		@CG1_PAT_EVENT(@BG_NUM, @TIME, @PATNO, @PAT_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg1
			$bg_pat_event(@BG_NUM, @TIME, @PATNO, @PAT_DELAY, @SPEED_MOD)

#macro		@CG2_PAT_EVENT(@BG_NUM, @TIME, @PATNO, @PAT_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg2
			$bg_pat_event(@BG_NUM, @TIME, @PATNO, @PAT_DELAY, @SPEED_MOD)

#macro		@CG3_PAT_EVENT(@BG_NUM, @TIME, @PATNO, @PAT_DELAY(0), @SPEED_MOD(0))
			$bg_type = _type_cg3
			$bg_pat_event(@BG_NUM, @TIME, @PATNO, @PAT_DELAY, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景／イベントＣＧ指定表示 [ワイプコピー]
// ---------------------------------------------------------------
#macro		@BG_WIPECOPY(@BG_NUM, @SWITCH)
			front.object[@BG_NUM].wipe_copy = @SWITCH

// ---------------------------------------------------------------
// 背景／イベントＣＧの現在パラメータ取得
// ---------------------------------------------------------------
#macro		@GET_BG_STATE(@BG_NUM)
			$bg_type = _type_bg
			$bg_posx_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].x
			$bg_posy_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].y
			$bg_tr_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].tr
			$bg_scale_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_x
			$bg_scale_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_y
			$bg_center_rep_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_x
			$bg_center_rep_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_y
			$bg_rotate_z_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].rotate_z

#macro		@GET_CG1_STATE(@BG_NUM)
			$bg_type = _type_cg1
			$bg_posx_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].x
			$bg_posy_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].y
			$bg_tr_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].tr
			$bg_scale_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_x
			$bg_scale_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_y
			$bg_center_rep_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_x
			$bg_center_rep_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_y
			$bg_rotate_z_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].rotate_z

#macro		@GET_CG2_STATE(@BG_NUM)
			$bg_type = _type_cg2
			$bg_posx_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].x
			$bg_posy_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].y
			$bg_tr_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].tr
			$bg_scale_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_x
			$bg_scale_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_y
			$bg_center_rep_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_x
			$bg_center_rep_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_y
			$bg_rotate_z_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].rotate_z

#macro		@GET_CG3_STATE(@BG_NUM)
			$bg_type = _type_cg3
			$bg_posx_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].x
			$bg_posy_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].y
			$bg_tr_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].tr
			$bg_scale_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_x
			$bg_scale_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].scale_y
			$bg_center_rep_x_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_x
			$bg_center_rep_y_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].center_rep_y
			$bg_rotate_z_prev[@BG_NUM] = front.object[@OBJ_BG01+@BG_NUM].rotate_z

// ---------------------------------------------------------------
// 背景／イベントＣＧのパラメータ初期化
// ---------------------------------------------------------------
#macro		@BG_RESET(@BG_NUM)
			$bg_type = _type_bg
			$bg_posx_prev[@BG_NUM] = 0
			$bg_posy_prev[@BG_NUM] = 0
			$bg_tr_prev[@BG_NUM] = 255
			$bg_scale_x_prev[@BG_NUM] = 1000
			$bg_scale_y_prev[@BG_NUM] = 1000
			$bg_center_rep_x_prev[@BG_NUM] = 640
			$bg_center_rep_y_prev[@BG_NUM] = 360
			$bg_rotate_z_prev[@BG_NUM] = 0

#macro		@CG1_RESET(@BG_NUM)
			$bg_type = _type_cg1
			$bg_posx_prev[@BG_NUM] = 0
			$bg_posy_prev[@BG_NUM] = 0
			$bg_tr_prev[@BG_NUM] = 255
			$bg_scale_x_prev[@BG_NUM] = 1000
			$bg_scale_y_prev[@BG_NUM] = 1000
			$bg_center_rep_x_prev[@BG_NUM] = 640
			$bg_center_rep_y_prev[@BG_NUM] = 360
			$bg_rotate_z_prev[@BG_NUM] = 0

#macro		@CG2_RESET(@BG_NUM)
			$bg_type = _type_cg2
			$bg_posx_prev[@BG_NUM] = 0
			$bg_posy_prev[@BG_NUM] = 0
			$bg_tr_prev[@BG_NUM] = 255
			$bg_scale_x_prev[@BG_NUM] = 1000
			$bg_scale_y_prev[@BG_NUM] = 1000
			$bg_center_rep_x_prev[@BG_NUM] = 640
			$bg_center_rep_y_prev[@BG_NUM] = 360
			$bg_rotate_z_prev[@BG_NUM] = 0

#macro		@CG3_RESET(@BG_NUM)
			$bg_type = _type_cg3
			$bg_posx_prev[@BG_NUM] = 0
			$bg_posy_prev[@BG_NUM] = 0
			$bg_tr_prev[@BG_NUM] = 255
			$bg_scale_x_prev[@BG_NUM] = 1000
			$bg_scale_y_prev[@BG_NUM] = 1000
			$bg_center_rep_x_prev[@BG_NUM] = 640
			$bg_center_rep_y_prev[@BG_NUM] = 360
			$bg_rotate_z_prev[@BG_NUM] = 0

// ---------------------------------------------------------------
// 背景スクロール[上から下へ] ※２→８
// ---------------------------------------------------------------
#macro		@BG_PAN_UD(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_ud(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[下から上へ] ※８→２
// ---------------------------------------------------------------
#macro		@BG_PAN_DU(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_du(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[左から右へ] ※４→６
// ---------------------------------------------------------------
#macro		@BG_PAN_LR(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_lr(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[左から右へ] ※６→４
// ---------------------------------------------------------------
#macro		@BG_PAN_RL(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_rl(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[左上から右下へ] ※１→９
// ---------------------------------------------------------------
#macro		@BG_PAN_UDLR(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_udlr(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[右下から左上へ] ※９→１
// ---------------------------------------------------------------
#macro		@BG_PAN_DURL(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_durl(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[右上から左下へ] ※３→７
// ---------------------------------------------------------------
#macro		@BG_PAN_UDRL(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_udrl(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[左下から右上へ] ※７→３
// ---------------------------------------------------------------
#macro		@BG_PAN_DULR(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_dulr(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[ズームアップ]
// ---------------------------------------------------------------
#macro		@BG_PAN_ZU(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_zu(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール[ズームダウン]
// ---------------------------------------------------------------
#macro		@BG_PAN_ZD(@BG_NAME, @SEL(3), @SR_TIME(20000), @SPEED_MOD(0))
			$bg_pan_zd(@SEL, @BG_NAME, @SR_TIME, @SPEED_MOD)

// ---------------------------------------------------------------
// 背景スクロール [指定]
// ---------------------------------------------------------------
#macro		@bg_pan(@bg_name, @sel, @st_posx, @ed_posx, @st_posy, @ed_posy, @st_zoom, @ed_zoom, @sr_time, @speed_mod(0))
			$bg_pan(@bg_name, @sel, @st_posx, @ed_posx, @st_posy, @ed_posy, @st_zoom, @ed_zoom, @sr_time, @speed_mod)


// ワイプ
#command $wipe(int) : int

// Exitワイプ See you again at my world
#command $exit_word(int) : int

#command	$bg_set(str, int, int, int, int, int, int, int, int, int, int) : int
#command	$bg_pos_event(int, int, int, int, int, int) : int
#command	$bg_tr_event(int, int, int, int, int) : int
#command	$bg_sc_event(int, int, int, int, int, int) : int
#command	$bg_ro_event(int, int, int, int, int, int) : int
#command	$bg_pat_event(int, int, int, int, int) : int

#command	$bg_pan_ud(int, str, int, int) : int
#command	$bg_pan_du(int, str, int, int) : int
#command	$bg_pan_lr(int, str, int, int) : int
#command	$bg_pan_rl(int, str, int, int) : int

#command	$bg_pan_udlr(int, str, int, int) : int
#command	$bg_pan_durl(int, str, int, int) : int
#command	$bg_pan_udrl(int, str, int, int) : int
#command	$bg_pan_dulr(int, str, int, int) : int

#command	$bg_pan_zu(int, str, int, int) : int
#command	$bg_pan_zd(int, str, int, int) : int

#command	$bg_pan(str, int, int, int, int, int, int, int, int, int)
