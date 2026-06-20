/********************************************************
*														*
*					バストショット表示					*
*														*
*********************************************************/
// ---------------------------------------------------------------
// キャラオブジェクト 最大30（ゲーム毎に設定）
// ---------------------------------------------------------------
#define		@OBJ_BS_01				   0 +  10	// 音無
#define		@OBJ_BS_02				   1 +  10	// かなで
#define		@OBJ_BS_03				   2 +  10	// ゆり
#define		@OBJ_BS_04				   3 +  10	// 日向
#define		@OBJ_BS_05				   4 +  10	// ユイ
#define		@OBJ_BS_06				   5 +  10	// 岩沢
#define		@OBJ_BS_07				   6 +  10	// 松下（太）
#define		@OBJ_BS_08				   7 +  10	// 松下（細）
#define		@OBJ_BS_09				   8 +  10	// 野田
#define		@OBJ_BS_10				   9 +  10	// 大山
#define		@OBJ_BS_11				  10 +  10	// 藤巻
#define		@OBJ_BS_12				  11 +  10	// ＴＫ
#define		@OBJ_BS_13				  12 +  10	// 椎名
#define		@OBJ_BS_14				  13 +  10	// 遊佐
#define		@OBJ_BS_15				  14 +  10	// ひさ子
#define		@OBJ_BS_16				  15 +  10	// 関根
#define		@OBJ_BS_17				  16 +  10	// 入江
#define		@OBJ_BS_18				  17 +  10	// チャー
#define		@OBJ_BS_19				  18 +  10	// 竹山
#define		@OBJ_BS_20				  19 +  10	// 直井
#define		@OBJ_BS_21				  20 +  10	// フィッシュ斎藤
#define		@OBJ_BS_22				  21 +  10	// 五十嵐
#define		@OBJ_BS_23				  22 +  10	// 赤目天使１
#define		@OBJ_BS_24				  23 +  10	// 赤目天使２
#define		@OBJ_BS_25				  24 +  10	// 影１
#define		@OBJ_BS_26				  25 +  10	// 影２
#define		@OBJ_BS_27				  26 +  10	// 影３
#define		@OBJ_BS_28				  27 +  10	// 影４
#define		@OBJ_BS_29				  28 +  10	// 
#define		@OBJ_BS_30				  29 +  10	// 
// 認識ダミー
#define		@OBJ_BS_DUMMY01			  30 +  10	// 音無
#define		@OBJ_BS_DUMMY02			  31 +  10	// かなで
#define		@OBJ_BS_DUMMY03			  32 +  10	// ゆり
#define		@OBJ_BS_DUMMY04			  33 +  10	// 日向
#define		@OBJ_BS_DUMMY05			  34 +  10	// ユイ
#define		@OBJ_BS_DUMMY06			  35 +  10	// 岩沢
#define		@OBJ_BS_DUMMY07			  36 +  10	// 松下（太）
#define		@OBJ_BS_DUMMY08			  37 +  10	// 松下（細）
#define		@OBJ_BS_DUMMY09			  38 +  10	// 野田
#define		@OBJ_BS_DUMMY10			  39 +  10	// 大山
#define		@OBJ_BS_DUMMY11			  40 +  10	// 藤巻
#define		@OBJ_BS_DUMMY12			  41 +  10	// ＴＫ
#define		@OBJ_BS_DUMMY13			  42 +  10	// 椎名
#define		@OBJ_BS_DUMMY14			  43 +  10	// 遊佐
#define		@OBJ_BS_DUMMY15			  44 +  10	// ひさ子
#define		@OBJ_BS_DUMMY16			  45 +  10	// 関根
#define		@OBJ_BS_DUMMY17			  46 +  10	// 入江
#define		@OBJ_BS_DUMMY18			  47 +  10	// チャー
#define		@OBJ_BS_DUMMY19			  48 +  10	// 竹山
#define		@OBJ_BS_DUMMY20			  49 +  10	// 直井
#define		@OBJ_BS_DUMMY21			  50 +  10	// フィッシュ斎藤
#define		@OBJ_BS_DUMMY22			  51 +  10	// 五十嵐
#define		@OBJ_BS_DUMMY23			  52 +  10	// 赤目天使１
#define		@OBJ_BS_DUMMY24			  53 +  10	// 赤目天使２
#define		@OBJ_BS_DUMMY25			  54 +  10	// 影１
#define		@OBJ_BS_DUMMY26			  55 +  10	// 影２
#define		@OBJ_BS_DUMMY27			  56 +  10	// 影３
#define		@OBJ_BS_DUMMY28			  57 +  10	// 影４
#define		@OBJ_BS_DUMMY29			  58 +  10	// 
#define		@OBJ_BS_DUMMY30			  59 +  10	// 

// エモオブジェクト01 最大30 * 3 = 90
#define		@OBJ_EMO01				  60 +  10	//  音無
#define		@OBJ_EMO01_01			  60 +  10	//  かなで
#define		@OBJ_EMO01_02			  61 +  10	//  ゆり
#define		@OBJ_EMO01_03			  62 +  10	//  日向
#define		@OBJ_EMO01_04			  63 +  10	//  ユイ
#define		@OBJ_EMO01_05			  64 +  10	//  岩沢
#define		@OBJ_EMO01_06			  65 +  10	//  松下（太）
#define		@OBJ_EMO01_07			  66 +  10	//  松下（細）
#define		@OBJ_EMO01_08			  67 +  10	//  野田
#define		@OBJ_EMO01_09			  68 +  10	//  大山
#define		@OBJ_EMO01_10			  69 +  10	//  藤巻
#define		@OBJ_EMO01_11			  70 +  10	//  ＴＫ
#define		@OBJ_EMO01_12			  71 +  10	//  椎名
#define		@OBJ_EMO01_13			  72 +  10	//  遊佐
#define		@OBJ_EMO01_14			  73 +  10	//  ひさ子
#define		@OBJ_EMO01_15			  74 +  10	//  関根
#define		@OBJ_EMO01_16			  75 +  10	//  入江
#define		@OBJ_EMO01_17			  76 +  10	//  チャー
#define		@OBJ_EMO01_18			  77 +  10	//  竹山
#define		@OBJ_EMO01_19			  78 +  10	//  直井
#define		@OBJ_EMO01_20			  79 +  10	//  フィッシュ斎藤
#define		@OBJ_EMO01_21			  80 +  10	//  五十嵐
#define		@OBJ_EMO01_22			  81 +  10	//  赤目天使１
#define		@OBJ_EMO01_23			  82 +  10	//  赤目天使２
#define		@OBJ_EMO01_24			  83 +  10	//  影１
#define		@OBJ_EMO01_25			  84 +  10	//  影２
#define		@OBJ_EMO01_26			  85 +  10	//  影３
#define		@OBJ_EMO01_27			  86 +  10	//  影４
#define		@OBJ_EMO01_28			  87 +  10	// 
#define		@OBJ_EMO01_29			  88 +  10	// 
#define		@OBJ_EMO01_30			  89 +  10	// 
// 02
#define		@OBJ_EMO02				  90 +  10	//  音無
#define		@OBJ_EMO02_01			  90 +  10	//  かなで
#define		@OBJ_EMO02_02			  91 +  10	//  ゆり
#define		@OBJ_EMO02_03			  92 +  10	//  日向
#define		@OBJ_EMO02_04			  93 +  10	//  ユイ
#define		@OBJ_EMO02_05			  94 +  10	//  岩沢
#define		@OBJ_EMO02_06			  95 +  10	//  松下（太）
#define		@OBJ_EMO02_07			  96 +  10	//  松下（細）
#define		@OBJ_EMO02_08			  97 +  10	//  野田
#define		@OBJ_EMO02_09			  98 +  10	//  大山
#define		@OBJ_EMO02_10			  99 +  10	//  藤巻
#define		@OBJ_EMO02_11			 100 +  10	//  ＴＫ
#define		@OBJ_EMO02_12			 101 +  10	//  椎名
#define		@OBJ_EMO02_13			 102 +  10	//  遊佐
#define		@OBJ_EMO02_14			 103 +  10	//  ひさ子
#define		@OBJ_EMO02_15			 104 +  10	//  関根
#define		@OBJ_EMO02_16			 105 +  10	//  入江
#define		@OBJ_EMO02_17			 106 +  10	//  チャー
#define		@OBJ_EMO02_18			 107 +  10	//  竹山
#define		@OBJ_EMO02_19			 108 +  10	//  直井
#define		@OBJ_EMO02_20			 109 +  10	//  フィッシュ斎藤
#define		@OBJ_EMO02_21			 110 +  10	//  五十嵐
#define		@OBJ_EMO02_22			 111 +  10	//  赤目天使１
#define		@OBJ_EMO02_23			 112 +  10	//  赤目天使２
#define		@OBJ_EMO02_24			 113 +  10	//  影１
#define		@OBJ_EMO02_25			 114 +  10	//  影２
#define		@OBJ_EMO02_26			 115 +  10	//  影３
#define		@OBJ_EMO02_27			 116 +  10	//  影４
#define		@OBJ_EMO02_28			 117 +  10	// 
#define		@OBJ_EMO02_29			 118 +  10	// 
#define		@OBJ_EMO02_30			 119 +  10	// 
// 03
#define		@OBJ_EMO03				 120 +  10	//  音無
#define		@OBJ_EMO03_01			 120 +  10	//  かなで
#define		@OBJ_EMO03_02			 121 +  10	//  ゆり
#define		@OBJ_EMO03_03			 122 +  10	//  日向
#define		@OBJ_EMO03_04			 123 +  10	//  ユイ
#define		@OBJ_EMO03_05			 124 +  10	//  岩沢
#define		@OBJ_EMO03_06			 125 +  10	//  松下（太）
#define		@OBJ_EMO03_07			 126 +  10	//  松下（細）
#define		@OBJ_EMO03_08			 127 +  10	//  野田
#define		@OBJ_EMO03_09			 128 +  10	//  大山
#define		@OBJ_EMO03_10			 129 +  10	//  藤巻
#define		@OBJ_EMO03_11			 130 +  10	//  ＴＫ
#define		@OBJ_EMO03_12			 131 +  10	//  椎名
#define		@OBJ_EMO03_13			 132 +  10	//  遊佐
#define		@OBJ_EMO03_14			 133 +  10	//  ひさ子
#define		@OBJ_EMO03_15			 134 +  10	//  関根
#define		@OBJ_EMO03_16			 135 +  10	//  入江
#define		@OBJ_EMO03_17			 136 +  10	//  チャー
#define		@OBJ_EMO03_18			 137 +  10	//  竹山
#define		@OBJ_EMO03_19			 138 +  10	//  直井
#define		@OBJ_EMO03_20			 139 +  10	//  フィッシュ斎藤
#define		@OBJ_EMO03_21			 140 +  10	//  五十嵐
#define		@OBJ_EMO03_22			 141 +  10	//  赤目天使１
#define		@OBJ_EMO03_23			 142 +  10	//  赤目天使２
#define		@OBJ_EMO03_24			 143 +  10	//  影１
#define		@OBJ_EMO03_25			 144 +  10	//  影２
#define		@OBJ_EMO03_26			 145 +  10	//  影３
#define		@OBJ_EMO03_27			 146 +  10	//  影４
#define		@OBJ_EMO03_28			 147 +  10	// 
#define		@OBJ_EMO03_29			 148 +  10	// 
#define		@OBJ_EMO03_30			 149 +  10	// 

// ---------------------------------------------------------------
// 登場キャラ情報
// ---------------------------------------------------------------
#define		@cha_maxenter			30		// ゲーム毎に設定

// ---------------------------------------------------------------
// キャラ最大登録数(+10すること)
// ---------------------------------------------------------------
#define		@cha_maxentry			40

// ---------------------------------------------------------------
// 表情変更用カウンタ
// ---------------------------------------------------------------
#define		@CNoBC					10

// ---------------------------------------------------------------
// テキスト表示中のＢＳ変更
// ---------------------------------------------------------------
#define		@BC
			// １度だけメッセージを非同期にする（次のRまで有効）
			script.set_msg_async_mode_on_once
			// スキップトリガーを置く（クリックすると次のRまで早送り）
			script.set_skip_trigger

// ---------------------------------------------------------------
// @BC 指定時間後にバストショットを変更する
// ---------------------------------------------------------------
#macro		@BS_C(@TIME, @CHA_NAME01("nothing"), @CHA_NAME02("nothing"), @CHA_NAME03("nothing"), @CHA_NAME04("nothing"), @CHA_NAME05("nothing"), @CHA_NAME06("nothing"))
			timewait_key(@TIME)
			@BS(@CHA_NAME01, @CHA_NAME02, @CHA_NAME03, @CHA_NAME04, @CHA_NAME05, @CHA_NAME06)


// ---------------------------------------------------------------
// 登場キャラ識別（ゲーム毎設定）
// ---------------------------------------------------------------
#property	$BS01 : int		// 音無
#property	$BS02 : int		// かなで
#property	$BS03 : int		// ゆり
#property	$BS04 : int		// 日向
#property	$BS05 : int		// ユイ
#property	$BS06 : int		// 岩沢
#property	$BS07 : int		// 松下（太）
#property	$BS08 : int		// 松下（細）
#property	$BS09 : int		// 野田
#property	$BS10 : int		// 高松
#property	$BS11 : int		// 大山
#property	$BS12 : int		// 藤巻
#property	$BS13 : int		// ＴＫ
#property	$BS14 : int		// 椎名
#property	$BS15 : int		// 遊佐
#property	$BS16 : int		// ひさ子
#property	$BS17 : int		// 関根
#property	$BS18 : int		// 入江
#property	$BS19 : int		// チャー
#property	$BS20 : int		// 竹山
#property	$BS21 : int		// 直井
#property	$BS22 : int		// フィッシュ斎藤
#property	$BS23 : int		// 五十嵐
#property	$BS24 : int		// 赤目天使１
#property	$BS25 : int		// 赤目天使２
#property	$BS26 : int		// 影１
#property	$BS27 : int		// 影２
#property	$BS28 : int		// 影３
#property	$BS29 : int		// 影４
#property	$BS30 : int		// 
#property	$BS31 : int		// 

// ---------------------------------------------------------------
// 登場キャラ初期レイヤー格納
// ---------------------------------------------------------------
#property	$BS01_deflayer : int
#property	$BS02_deflayer : int
#property	$BS03_deflayer : int
#property	$BS04_deflayer : int
#property	$BS05_deflayer : int
#property	$BS06_deflayer : int
#property	$BS07_deflayer : int
#property	$BS08_deflayer : int
#property	$BS09_deflayer : int
#property	$BS10_deflayer : int
#property	$BS11_deflayer : int
#property	$BS12_deflayer : int
#property	$BS13_deflayer : int
#property	$BS14_deflayer : int
#property	$BS15_deflayer : int
#property	$BS16_deflayer : int
#property	$BS17_deflayer : int
#property	$BS18_deflayer : int
#property	$BS19_deflayer : int
#property	$BS20_deflayer : int
#property	$BS21_deflayer : int
#property	$BS22_deflayer : int
#property	$BS23_deflayer : int
#property	$BS24_deflayer : int
#property	$BS25_deflayer : int
#property	$BS26_deflayer : int
#property	$BS27_deflayer : int
#property	$BS28_deflayer : int
#property	$BS29_deflayer : int
#property	$BS30_deflayer : int

// ---------------------------------------------------------------
// キャラクター初期座標値
// ---------------------------------------------------------------
#define		@bs_pos_init			-9999

// ---------------------------------------------------------------
// キャラクターＸ座標格納
// ---------------------------------------------------------------
#property	$chara_posx       : intlist[@cha_maxentry]	// ←確保しているオブジェクトの数だけ必要か？　30＊3=90
#property	$chara_posx_next  : intlist[@cha_maxentry]
#property	$chara_posx_prev  : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターＹ座標格納
// ---------------------------------------------------------------
#property	$chara_posy       : intlist[@cha_maxentry]
#property	$chara_posy_next  : intlist[@cha_maxentry]
#property	$chara_posy_prev  : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターＺ座標格納
// ---------------------------------------------------------------
#property	$chara_posz       : intlist[@cha_maxentry]
#property	$chara_posz_next  : intlist[@cha_maxentry]
#property	$chara_posz_prev  : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクター不透明度値格納
// ---------------------------------------------------------------
#property	$chara_tr      : intlist[@cha_maxentry]
#property	$chara_tr_next : intlist[@cha_maxentry]
#property	$chara_tr_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターレイヤー値格納
// ---------------------------------------------------------------
#property	$chara_layer      : intlist[@cha_maxentry]
#property	$chara_layer_next : intlist[@cha_maxentry]
#property	$chara_layer_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// バストショットオブジェクトの中心補正座標値格納
// ---------------------------------------------------------------
#property	$chara_center_rep_x      : intlist[@cha_maxentry]
#property	$chara_center_rep_x_next : intlist[@cha_maxentry]
#property	$chara_center_rep_x_prev : intlist[@cha_maxentry]
#property	$chara_center_rep_y      : intlist[@cha_maxentry]
#property	$chara_center_rep_y_next : intlist[@cha_maxentry]
#property	$chara_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// バストショットオブジェクトの回転値格納
// ---------------------------------------------------------------
#property	$chara_rotate_z      : intlist[@cha_maxentry]
#property	$chara_rotate_z_next : intlist[@cha_maxentry]
#property	$chara_rotate_z_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// バストショットオブジェクトのサイズ格納
// ---------------------------------------------------------------
#property	$chara_scale_x      : intlist[@cha_maxentry]
#property	$chara_scale_x_next : intlist[@cha_maxentry]
#property	$chara_scale_x_prev : intlist[@cha_maxentry]
#property	$chara_scale_y      : intlist[@cha_maxentry]
#property	$chara_scale_y_next : intlist[@cha_maxentry]
#property	$chara_scale_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターエモーション０１情報格納
// ---------------------------------------------------------------
#property	$chara_emo01                   : intlist[@cha_maxentry]
#property	$chara_emo01_next              : intlist[@cha_maxentry]
#property	$chara_emo01_prev              : intlist[@cha_maxentry]
#property	$chara_emo01_posx              : intlist[@cha_maxentry]
#property	$chara_emo01_posy              : intlist[@cha_maxentry]
#property	$chara_emo01_posx_prev         : intlist[@cha_maxentry]
#property	$chara_emo01_posy_prev         : intlist[@cha_maxentry]
#property	$chara_emo01_posx_next         : intlist[@cha_maxentry]
#property	$chara_emo01_posy_next         : intlist[@cha_maxentry]
#property	$chara_emo01_layer             : intlist[@cha_maxentry]
#property	$chara_emo01_layer_prev        : intlist[@cha_maxentry]
#property	$chara_emo01_layer_next        : intlist[@cha_maxentry]
#property	$chara_emo01_center_rep_x      : intlist[@cha_maxentry]
#property	$chara_emo01_center_rep_x_next : intlist[@cha_maxentry]
#property	$chara_emo01_center_rep_x_prev : intlist[@cha_maxentry]
#property	$chara_emo01_center_rep_y      : intlist[@cha_maxentry]
#property	$chara_emo01_center_rep_y_next : intlist[@cha_maxentry]
#property	$chara_emo01_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターエモーション０２情報格納
// ---------------------------------------------------------------
#property	$chara_emo02                   : intlist[@cha_maxentry]
#property	$chara_emo02_next              : intlist[@cha_maxentry]
#property	$chara_emo02_prev              : intlist[@cha_maxentry]
#property	$chara_emo02_posx              : intlist[@cha_maxentry]
#property	$chara_emo02_posy              : intlist[@cha_maxentry]
#property	$chara_emo02_posx_prev         : intlist[@cha_maxentry]
#property	$chara_emo02_posy_prev         : intlist[@cha_maxentry]
#property	$chara_emo02_posx_next         : intlist[@cha_maxentry]
#property	$chara_emo02_posy_next         : intlist[@cha_maxentry]
#property	$chara_emo02_layer             : intlist[@cha_maxentry]
#property	$chara_emo02_layer_prev        : intlist[@cha_maxentry]
#property	$chara_emo02_layer_next        : intlist[@cha_maxentry]
#property	$chara_emo02_center_rep_x      : intlist[@cha_maxentry]
#property	$chara_emo02_center_rep_x_next : intlist[@cha_maxentry]
#property	$chara_emo02_center_rep_x_prev : intlist[@cha_maxentry]
#property	$chara_emo02_center_rep_y      : intlist[@cha_maxentry]
#property	$chara_emo02_center_rep_y_next : intlist[@cha_maxentry]
#property	$chara_emo02_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターエモーション０３情報格納
// ---------------------------------------------------------------
#property	$chara_emo03                   : intlist[@cha_maxentry]
#property	$chara_emo03_next              : intlist[@cha_maxentry]
#property	$chara_emo03_prev              : intlist[@cha_maxentry]
#property	$chara_emo03_posx              : intlist[@cha_maxentry]
#property	$chara_emo03_posy              : intlist[@cha_maxentry]
#property	$chara_emo03_posx_prev         : intlist[@cha_maxentry]
#property	$chara_emo03_posy_prev         : intlist[@cha_maxentry]
#property	$chara_emo03_posx_next         : intlist[@cha_maxentry]
#property	$chara_emo03_posy_next         : intlist[@cha_maxentry]
#property	$chara_emo03_layer             : intlist[@cha_maxentry]
#property	$chara_emo03_layer_prev        : intlist[@cha_maxentry]
#property	$chara_emo03_layer_next        : intlist[@cha_maxentry]
#property	$chara_emo03_center_rep_x      : intlist[@cha_maxentry]
#property	$chara_emo03_center_rep_x_next : intlist[@cha_maxentry]
#property	$chara_emo03_center_rep_x_prev : intlist[@cha_maxentry]
#property	$chara_emo03_center_rep_y      : intlist[@cha_maxentry]
#property	$chara_emo03_center_rep_y_next : intlist[@cha_maxentry]
#property	$chara_emo03_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// キャラクターアクション情報格納
// ---------------------------------------------------------------
#property	$chara_action           : intlist[@cha_maxentry]
#property	$chara_action_posx      : intlist[@cha_maxentry]
#property	$chara_action_posy      : intlist[@cha_maxentry]
#property	$chara_action_posx_next : intlist[@cha_maxentry]
#property	$chara_action_posy_next : intlist[@cha_maxentry]
#property	$chara_action_posx_prev : intlist[@cha_maxentry]
#property	$chara_action_posy_prev : intlist[@cha_maxentry]
#property	$chara_action_cdnter_x  : intlist[@cha_maxentry]	// 補正座標
#property	$chara_action_cdnter_y  : intlist[@cha_maxentry]	// 補正座標
#property	$chara_action_scale_x   : intlist[@cha_maxentry]
#property	$chara_action_scale_y   : intlist[@cha_maxentry]
#property	$chara_action_scale_z   : intlist[@cha_maxentry]	// 回転のみ
#property	$chara_action_time      : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// 最大同時表示
// ---------------------------------------------------------------
#define		@bs_maxnum				 6		// ゲーム毎に設定
#define		@bs_maxnum_dummy		32		// 注意

// ---------------------------------------------------------------
// バストショットの情報格納
// ---------------------------------------------------------------
#property	$bs_size_info        : strlist[@bs_maxnum]
#property	$bs_name_info        : strlist[@bs_maxnum]
#property	$bs_dress_info       : strlist[@bs_maxnum]
#property	$bs_pose_info        : strlist[@bs_maxnum]
#property	$bs_face_info        : strlist[@bs_maxnum]
#property	$bs_mouth_info       : strlist[@bs_maxnum]
#property	$bs_name_info_prev   : strlist[@bs_maxnum]

#property	$bs_dress_disp_num   : strlist[@bs_maxnum]
#property	$bs_pose_disp_num    : strlist[@bs_maxnum]
#property	$bs_face_disp_num    : strlist[@bs_maxnum]
#property	$bs_mouth_disp_num   : strlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットファイル格納
// ---------------------------------------------------------------
#property	$bs_name             : strlist[@bs_maxnum]
#property	$bs_name_prev        : strlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットファイル名判別
// ---------------------------------------------------------------
#property	$bs_exist_decide     : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショット消去判別
// ---------------------------------------------------------------
#property	$bs_del_decide       : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// キャラＩ.Ｔ格納
// ---------------------------------------------------------------
#property	$bs_cha              : strlist[@bs_maxnum]
#property	$bs_cha_num          : intlist[@bs_maxnum]
#property	$bs_cha_prev         : strlist[@bs_maxnum]
#property	$bs_cha_num_prev     : intlist[@bs_maxnum]
#property	$bs_cha_num_dummy    : intlist[@bs_maxnum_dummy]

// ---------------------------------------------------------------
// バストショットオブジェクト格納
// ---------------------------------------------------------------
#property	$obj_chara           : intlist[@bs_maxnum]
#property	$obj_chara_prev      : intlist[@bs_maxnum].

// ---------------------------------------------------------------
// バストショットオブジェクトのＸ座標格納
// ---------------------------------------------------------------
#property	$bs_posx             : intlist[@bs_maxnum]
#property	$bs_posx_next        : intlist[@bs_maxnum]
#property	$bs_posx_prev        : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトのＹ座標格納
// ---------------------------------------------------------------
#property	$bs_posy             : intlist[@bs_maxnum]
#property	$bs_posy_next        : intlist[@bs_maxnum]
#property	$bs_posy_prev        : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトのＺ座標格納
// ---------------------------------------------------------------
#property	$bs_posz             : intlist[@bs_maxnum]
#property	$bs_posz_next        : intlist[@bs_maxnum]
#property	$bs_posz_prev        : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトの不透明度値格納
// ---------------------------------------------------------------
#property	$bs_tr            : intlist[@bs_maxnum]
#property	$bs_tr_next       : intlist[@bs_maxnum]
#property	$bs_tr_prev       : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトのレイヤー値格納
// ---------------------------------------------------------------
#property	$bs_layer            : intlist[@bs_maxnum]
#property	$bs_layer_next       : intlist[@bs_maxnum]
#property	$bs_layer_prev       : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトの中心座標値格納
// ---------------------------------------------------------------
#property	$bs_center_rep_x      : intlist[@bs_maxnum]
#property	$bs_center_rep_x_next : intlist[@bs_maxnum]
#property	$bs_center_rep_x_prev : intlist[@bs_maxnum]
#property	$bs_center_rep_y      : intlist[@bs_maxnum]
#property	$bs_center_rep_y_next : intlist[@bs_maxnum]
#property	$bs_center_rep_y_prev : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトの回転値格納
// ---------------------------------------------------------------
#property	$bs_rotate_z          : intlist[@bs_maxnum]
#property	$bs_rotate_z_next     : intlist[@bs_maxnum]
#property	$bs_rotate_z_prev     : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットオブジェクトのエモーション０１情報格納
// ---------------------------------------------------------------
#property	$bs_emo01                   : strlist[@bs_maxnum]
#property	$bs_emo01_num               : intlist[@bs_maxnum]
#property	$bs_emo01_next              : intlist[@bs_maxnum]
#property	$bs_emo01_prev              : intlist[@bs_maxnum]
#property	$bs_emo01_posx              : intlist[@bs_maxnum]
#property	$bs_emo01_posy              : intlist[@bs_maxnum]
#property	$bs_emo01_posx_next         : intlist[@bs_maxnum]
#property	$bs_emo01_posy_next         : intlist[@bs_maxnum]
#property	$bs_emo01_posx_prev         : intlist[@bs_maxnum]
#property	$bs_emo01_posy_prev         : intlist[@bs_maxnum]
#property	$bs_emo01_layer_prev        : intlist[@bs_maxnum]
#property	$bs_emo01_layer_next        : intlist[@bs_maxnum]
#property	$bs_emo01_exist             : intlist[@bs_maxnum]
#property	$bs_emo01_loop              : intlist[@bs_maxnum]
#property	$bs_emo01_center_rep_x      : intlist[@cha_maxentry]
#property	$bs_emo01_center_rep_x_next : intlist[@cha_maxentry]
#property	$bs_emo01_center_rep_x_prev : intlist[@cha_maxentry]
#property	$bs_emo01_center_rep_y      : intlist[@cha_maxentry]
#property	$bs_emo01_center_rep_y_next : intlist[@cha_maxentry]
#property	$bs_emo01_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// バストショットオブジェクトのエモーション０２情報格納
// ---------------------------------------------------------------
#property	$bs_emo02                   : strlist[@bs_maxnum]
#property	$bs_emo02_num               : intlist[@bs_maxnum]
#property	$bs_emo02_next              : intlist[@bs_maxnum]
#property	$bs_emo02_prev              : intlist[@bs_maxnum]
#property	$bs_emo02_posx              : intlist[@bs_maxnum]
#property	$bs_emo02_posy              : intlist[@bs_maxnum]
#property	$bs_emo02_posx_next         : intlist[@bs_maxnum]
#property	$bs_emo02_posy_next         : intlist[@bs_maxnum]
#property	$bs_emo02_posx_prev         : intlist[@bs_maxnum]
#property	$bs_emo02_layer_prev        : intlist[@bs_maxnum]
#property	$bs_emo02_layer_next        : intlist[@bs_maxnum]
#property	$bs_emo02_exist             : intlist[@bs_maxnum]
#property	$bs_emo02_loop              : intlist[@bs_maxnum]
#property	$bs_emo02_center_rep_x      : intlist[@cha_maxentry]
#property	$bs_emo02_center_rep_x_next : intlist[@cha_maxentry]
#property	$bs_emo02_center_rep_x_prev : intlist[@cha_maxentry]
#property	$bs_emo02_center_rep_y      : intlist[@cha_maxentry]
#property	$bs_emo02_center_rep_y_next : intlist[@cha_maxentry]
#property	$bs_emo02_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// バストショットオブジェクトのエモーション０３情報格納
// ---------------------------------------------------------------
#property	$bs_emo03                   : strlist[@bs_maxnum]
#property	$bs_emo03_num               : intlist[@bs_maxnum]
#property	$bs_emo03_next              : intlist[@bs_maxnum]
#property	$bs_emo03_prev              : intlist[@bs_maxnum]
#property	$bs_emo03_posx              : intlist[@bs_maxnum]
#property	$bs_emo03_posy              : intlist[@bs_maxnum]
#property	$bs_emo03_posx_next         : intlist[@bs_maxnum]
#property	$bs_emo03_posy_next         : intlist[@bs_maxnum]
#property	$bs_emo03_posx_prev         : intlist[@bs_maxnum]
#property	$bs_emo03_layer_prev        : intlist[@bs_maxnum]
#property	$bs_emo03_layer_next        : intlist[@bs_maxnum]
#property	$bs_emo03_exist             : intlist[@bs_maxnum]
#property	$bs_emo03_loop              : intlist[@bs_maxnum]
#property	$bs_emo03_center_rep_x      : intlist[@cha_maxentry]
#property	$bs_emo03_center_rep_x_next : intlist[@cha_maxentry]
#property	$bs_emo03_center_rep_x_prev : intlist[@cha_maxentry]
#property	$bs_emo03_center_rep_y      : intlist[@cha_maxentry]
#property	$bs_emo03_center_rep_y_next : intlist[@cha_maxentry]
#property	$bs_emo03_center_rep_y_prev : intlist[@cha_maxentry]

// ---------------------------------------------------------------
// バストショットオブジェクトのエモーションループ情報格納
// ---------------------------------------------------------------
#property	$bs_emo_loop         : int

// ---------------------------------------------------------------
// バストショットオブジェクトのワイプ情報格納
// ---------------------------------------------------------------
#property	$bs_wipe : intlist[@bs_maxnum]
#property	$bs_wipe_set

// ---------------------------------------------------------------
// バストショットアクション情報格納（rep）
// ---------------------------------------------------------------
#property	$bs_action                   : strlist[@bs_maxnum]
#property	$bs_action01                 : strlist[@bs_maxnum]
#property	$bs_action02                 : strlist[@bs_maxnum]
#property	$bs_action03                 : strlist[@bs_maxnum]
#property	$bs_action_posx              : intlist[@bs_maxnum]
#property	$bs_action_posy              : intlist[@bs_maxnum]
#property	$bs_action_posx_next         : intlist[@bs_maxnum]
#property	$bs_action_posy_next         : intlist[@bs_maxnum]
#property	$bs_action_posx_prev         : intlist[@bs_maxnum]
#property	$bs_action_posy_prev         : intlist[@bs_maxnum]
#property	$bs_action_tr                : intlist[@bs_maxnum]
#property	$bs_action_tr_next            : intlist[@bs_maxnum]
#property	$bs_action_tr_prev            : intlist[@bs_maxnum]
#property	$bs_action_scale_x           : intlist[@bs_maxnum]
#property	$bs_action_scale_y           : intlist[@bs_maxnum]
#property	$bs_action_scale_x_next      : intlist[@bs_maxnum]
#property	$bs_action_scale_y_next      : intlist[@bs_maxnum]
#property	$bs_action_scale_x_prev      : intlist[@bs_maxnum]
#property	$bs_action_scale_y_prev      : intlist[@bs_maxnum]
#property	$bs_action_rotate_z          : intlist[@bs_maxnum] // 回転のみ
#property	$bs_action_rotate_z_next     : intlist[@bs_maxnum] // 回転のみ
#property	$bs_action_rotate_z_prev     : intlist[@bs_maxnum] // 回転のみ
#property	$bs_action_center_rep_x      : intlist[@bs_maxnum]
#property	$bs_action_center_rep_y      : intlist[@bs_maxnum]
#property	$bs_action_time              : intlist[@bs_maxnum]
#property	$bs_action_time01            : intlist[@bs_maxnum]
#property	$bs_action_time02            : intlist[@bs_maxnum]
#property	$bs_action_time03            : intlist[@bs_maxnum]
#property	$bs_action_scale_time01      : intlist[@bs_maxnum]
#property	$bs_action_scale_time02      : intlist[@bs_maxnum]
#property	$bs_action_scale_time03      : intlist[@bs_maxnum]
#property	$bs_action_rotate_time01     : intlist[@bs_maxnum]
#property	$bs_action_rotate_time02     : intlist[@bs_maxnum]
#property	$bs_action_rotate_time03     : intlist[@bs_maxnum]
#property	$bs_action_end_time          : intlist[@bs_maxnum]
#property	$bs_action_end_time01        : intlist[@bs_maxnum]
#property	$bs_action_end_time02        : intlist[@bs_maxnum]
#property	$bs_action_end_time03        : intlist[@bs_maxnum]
#property	$bs_action_end_scale_time01  : intlist[@bs_maxnum]
#property	$bs_action_end_scale_time02  : intlist[@bs_maxnum]
#property	$bs_action_end_scale_time03  : intlist[@bs_maxnum]
#property	$bs_action_end_rotate_time01 : intlist[@bs_maxnum]
#property	$bs_action_end_rotate_time02 : intlist[@bs_maxnum]
#property	$bs_action_end_rotate_time03 : intlist[@bs_maxnum]
#property	$bs_action_mod               : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショット距離情報格納1
// ---------------------------------------------------------------
#property	$bs_distance : intlist[@bs_maxnum]
#define		_type_far		0
#define		_type_near		1
#define		_type_imm		2

// ---------------------------------------------------------------
// ＳＦ学園 8人 + 5
// ---------------------------------------------------------------
#property	$cha_id : strlist[@cha_maxenter]

// ---------------------------------------------------------------
// バストショットＸ座標
// ---------------------------------------------------------------
#property	$pos_ol  : int
#property	$pos_fl2 : int
#property	$pos_fl  : int
#property	$pos_l   : int
#property	$pos_hl2 : int
#property	$pos_hl  : int
#property	$pos_nl  : int
#property	$pos_c   : int
#property	$pos_nr  : int
#property	$pos_hr  : int
#property	$pos_hr2 : int
#property	$pos_r   : int
#property	$pos_fr  : int
#property	$pos_fr2 : int
#property	$pos_or  : int
#define		@POS_OL  	$pos_ol
#define		@POS_FL2	$pos_fl2
#define		@POS_FL 	$pos_fl
#define		@POS_L   	$pos_l
#define		@POS_HL2 	$pos_hl2
#define		@POS_HL  	$pos_hl
#define		@POS_NL  	$pos_nl
#define		@POS_C   	$pos_c
#define		@POS_NR  	$pos_nr
#define		@POS_HR  	$pos_hr
#define		@POS_HR2 	$pos_hr2
#define		@POS_R   	$pos_r
#define		@POS_FR  	$pos_fr
#define		@POS_FR2 	$pos_fr2
#define		@POS_OR  	$pos_or

// ---------------------------------------------------------------
// バストショットＹ座標
// ---------------------------------------------------------------
#property	$pos_ot  : int
#property	$pos_ft2 : int
#property	$pos_ft  : int
#property	$pos_t   : int
#property	$pos_ht2 : int
#property	$pos_ht  : int
#property	$pos_nt  : int
#property	$pos_m   : int
#property	$pos_nu  : int
#property	$pos_hu  : int
#property	$pos_hu2 : int
#property	$pos_u   : int
#property	$pos_fu  : int
#property	$pos_fu2 : int
#property	$pos_ou  : int
#define		@POS_OT  	$pos_ot
#define		@POS_FT2 	$pos_ft2
#define		@POS_FT  	$pos_ft
#define		@POS_T   	$pos_t
#define		@POS_HT2 	$pos_ht2
#define		@POS_HT  	$pos_ht
#define		@POS_NT  	$pos_nt
#define		@POS_M   	$pos_m
#define		@POS_NU  	$pos_nu
#define		@POS_HU  	$pos_hu
#define		@POS_HU2 	$pos_hu2
#define		@POS_U   	$pos_u
#define		@POS_FU  	$pos_fu
#define		@POS_FU2 	$pos_fu2
#define		@POS_OU  	$pos_ou

// ---------------------------------------------------------------
// バストショットＺ座標（レイヤー）
// ---------------------------------------------------------------
#property	$pos_z   : int
#property	$pos_z1  : int
#property	$pos_z2  : int
#property	$pos_z3  : int
#property	$pos_z4  : int
#property	$pos_z5  : int
#property	$pos_z6  : int
#define		@POS_Z1		$pos_z1
#define		@POS_Z2		$pos_z2
#define		@POS_Z3		$pos_z3
#define		@POS_Z4		$pos_z4
#define		@POS_Z5		$pos_z5
#define		@POS_Z6		$pos_z6

// ---------------------------------------------------------------
// バストショット立ち位置移動時間
// ---------------------------------------------------------------
#property	$pos_speed : intlist[@bs_maxnum]
#property	$posx_speed : intlist[@bs_maxnum]
#property	$posy_speed : intlist[@bs_maxnum]
#define		@sd_inst			0
#define		@sd_fast			250
#define		@sd_normal			400
#define		@sd_slow			800
#define		@SD_NOR				250

// ---------------------------------------------------------------
// バストショット立ち位置移動時間遅延
// ---------------------------------------------------------------
#property	$posx_speed_delay : intlist[@bs_maxnum]
#property	$posy_speed_delay : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショット立ち位置移動モード
// ---------------------------------------------------------------
#property	$posx_speed_mod : intlist[@bs_maxnum]
#property	$posy_speed_mod : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// バストショットタイプ
// ---------------------------------------------------------------
#property	$bs_type : int
#define		_type_bs01			0
#define		_type_bs02			1

// ---------------------------------------------------------------
// ワイプタイプ
// ---------------------------------------------------------------
#property	$disp : int
#define		_disp_bg			0
#define		_disp_bs			1
#define		_disp_ev			2

// ---------------------------------------------------------------
// バストショットＡＬＬクリア
// ---------------------------------------------------------------
#property	$bs_clear_all : int

// ---------------------------------------------------------------
// バストショット表示数カウント
// ---------------------------------------------------------------
#property	$bs_disp_cnt : int

// ---------------------------------------------------------------
// バストショットアクションセット
// ---------------------------------------------------------------
#property	$bs_action_set : intlist[@bs_maxnum]
#property	$bs_action_time_set : intlist[@bs_maxnum]
#property	$bs_action_sc_time_set : intlist[@bs_maxnum]
#property	$bs_action_ro_time_set : intlist[@bs_maxnum]
#property	$bs_action_rotate_set : intlist[@bs_maxnum]
#property	$bs_action_scale_set : intlist[@bs_maxnum]
#property	$bs_action_scale_x_set : intlist[@bs_maxnum]
#property	$bs_action_scale_y_set : intlist[@bs_maxnum]
#property	$bs_action_tr_set : intlist[@bs_maxnum]
#property	$bs_action_tr_time_set : intlist[@bs_maxnum]

// ---------------------------------------------------------------
// キャラ距離判定
// ---------------------------------------------------------------
#define		@BS_FAR01[			B[1100

// ---------------------------------------------------------------
// キャラデフォルトＺ座標
// ---------------------------------------------------------------
#define		@POS_Z				100000

// ---------------------------------------------------------------
// エモーション初期化
// ---------------------------------------------------------------
#define		@emo_none			0


// ---------------------------------------------------------------
// ワイプ判定
// ---------------------------------------------------------------
#define		@bs_wipe_decide		$bs_wipe_decide
#property	$bs_wipe_decide : int

// ---------------------------------------------------------------
// 登場キャラのＩ．Ｔ取得（ゲーム毎に設定）
// ---------------------------------------------------------------
#macro		@Get_chara_it_info(@IT01,       @IT02("XX"), @IT03("XX"), @IT04("XX"), @IT05("XX"), @IT06("XX"), @IT07("XX"), @IT08("XX"),
                               @IT09("XX"), @IT10("XX"), @IT11("XX"), @IT12("XX"), @IT13("XX"), @IT14("XX"), @IT15("XX"), @IT16("XX"),
                               @IT17("XX"), @IT18("XX"), @IT19("XX"), @IT20("XX"), @IT21("XX"), @IT22("XX"), @IT23("XX"), @IT24("XX"),
                               @IT25("XX"), @IT26("XX"), @IT27("XX"), @IT28("XX"), @IT29("XX"), @IT30("XX"))
			$cha_id[00] = @IT01 $cha_id[01] = @IT02 $cha_id[02] = @IT03 $cha_id[03] = @IT04 $cha_id[04] = @IT05
			$cha_id[05] = @IT06 $cha_id[06] = @IT07 $cha_id[07] = @IT08 $cha_id[08] = @IT09 $cha_id[09] = @IT10
			$cha_id[10] = @IT11 $cha_id[11] = @IT12 $cha_id[12] = @IT13 $cha_id[13] = @IT14 $cha_id[14] = @IT15
			$cha_id[15] = @IT16 $cha_id[16] = @IT17 $cha_id[17] = @IT18 $cha_id[18] = @IT19 $cha_id[19] = @IT20
			$cha_id[20] = @IT21 $cha_id[21] = @IT22 $cha_id[22] = @IT23 $cha_id[23] = @IT24 $cha_id[24] = @IT25
			$cha_id[25] = @IT26 $cha_id[26] = @IT27 $cha_id[27] = @IT28 $cha_id[28] = @IT29 $cha_id[29] = @IT30

// ---------------------------------------------------------------
// バストショットワイプ番号変更
// ---------------------------------------------------------------
#macro		@bs_wipe_type(@wipe_no)
			$bs_wipe_set = @wipe_no

//#property	$bs_wipe : int

// ---------------------------------------------------------------
// バストショット簡易表示
// ---------------------------------------------------------------
#macro		@BS(@CHA_NAME01("nothing"), @CHA_NAME02("nothing"), @CHA_NAME03("nothing"), @CHA_NAME04("nothing"), @CHA_NAME05("nothing"), @CHA_NAME06("nothing"))
			$bs_name[0] = @CHA_NAME01
			$bs_name[1] = @CHA_NAME02
			$bs_name[2] = @CHA_NAME03
			$bs_name[3] = @CHA_NAME04
			$bs_name[4] = @CHA_NAME05
			$bs_name[5] = @CHA_NAME06
			$bs_type = _type_bs01
			$disp = _disp_bs
			if ($bg_set_ready == @On)	{
				$bg_disp_set(0)
			}
			else	{
				// ※
				for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
					@b.obj[@OBJ_BG01+L[0]].create_copy_from(@f.obj[@OBJ_BG01+L[0]])
				}
			}
			$bs_disp_in(0)
			// wipe_type初期化
			$bs_wipe_set = 0

// ---------------------------------------------------------------
// バストショット簡易表示・ワイプ変更
// ---------------------------------------------------------------
#macro		@BS_W(@WIPE_NO, @CHA_NAME01("nothing"), @CHA_NAME02("nothing"), @CHA_NAME03("nothing"), @CHA_NAME04("nothing"), @CHA_NAME05("nothing"), @CHA_NAME06("nothing"))
			@BS_WIPE_TYPE(@WIPE_NO)
			@BS(@CHA_NAME01, @CHA_NAME02, @CHA_NAME03, @CHA_NAME04, @CHA_NAME05, @CHA_NAME06)

// ---------------------------------------------------------------
// データ先読み
// ---------------------------------------------------------------
#macro		@data_buf(@data01, @data02("None"))
			g00buf[0].load(@data01)
			if (@data02 != "None")	{
				g00buf[1].load(@data02)
			}

// ---------------------------------------------------------------
// データバッファ解放
// ---------------------------------------------------------------
#define		@data_buf_free
			g00buf.free_all

// ---------------------------------------------------------------
// バストショット準備
// ---------------------------------------------------------------
#macro		@BS_SET(@WTIME, @CHA_NAME, @POS_X, @POS_Z(100000), @POS_Y(-100000), @POS_DELAY(0), @POSX_SPEED_MOD(2), @POSY_SPEED_MOD(2))
			if (@WTIME != -1)	{
				$posx_speed[$bs_disp_cnt] = @WTIME
				$posy_speed[$bs_disp_cnt] = @WTIME
				$posx_speed_delay[$bs_disp_cnt] = @POS_DELAY
				$posy_speed_delay[$bs_disp_cnt] = @POS_DELAY
				$posx_speed_mod[$bs_disp_cnt] = @POSX_SPEED_MOD
				$posy_speed_mod[$bs_disp_cnt] = @POSY_SPEED_MOD
			}
			switch ($bs_disp_cnt)	{
				case (0) $bs_name[0] = @CHA_NAME $bs_name[1] = "nothing" $bs_name[2] = "nothing" $bs_name[3] = "nothing" $bs_name[4] = "nothing" $bs_name[5] = "nothing"
				case (1) $bs_name[1] = @CHA_NAME
				case (2) $bs_name[2] = @CHA_NAME
				case (3) $bs_name[3] = @CHA_NAME
				case (4) $bs_name[4] = @CHA_NAME
				case (5) $bs_name[5] = @CHA_NAME
			}
			$bs_posx_next[$bs_disp_cnt]  = @POS_X
			$bs_layer_next[$bs_disp_cnt] = @POS_Z
			$bs_emo01_layer_next[$bs_disp_cnt] = @POS_Z + 1
			$bs_emo02_layer_next[$bs_disp_cnt] = @POS_Z + 2
			$bs_emo03_layer_next[$bs_disp_cnt] = @POS_Z + 3
			$bs_posy_next[$bs_disp_cnt]  = @POS_Y
			if (@POS_Y == -100000){
				$bs_posy_next[$bs_disp_cnt] = $pos_m
			}
			$bs_type = _type_bs02
			$disp = _disp_bs
			$bs_disp_cnt += 1
			@bs_wipe_decide = @On

			$bs_set_ready = @On

#property	$bs_set_ready : int


// ---------------------------------------------------------------
// バストショット立ち位置移動時間個別設定
// ---------------------------------------------------------------
#macro		@BS_SET_POS_TIME(@POS_X, @POS_Y, @POSX_DELAY(0), @POSY_DELAY(0))
			$posx_speed[$bs_disp_cnt] = @POS_X
			$posy_speed[$bs_disp_cnt] = @POS_Y
			$posx_speed_delay[$bs_disp_cnt] = @POSX_DELAY
			$posy_speed_delay[$bs_disp_cnt] = @POSY_DELAY

// ---------------------------------------------------------------
// セット表示命令
// ---------------------------------------------------------------
#macro		@WIPE(@SEL, @W_SLIDE(0))
			if ($disp == _disp_bs)	{
				$bs_wipe_set = @SEL
			}
			else	{
				$bg_wipe_set = @SEL
			}
			if ($bs_set_ready == @Off)	{
				// バストショット表示情報初期化
				for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
					$bs_name[L[0]] = "nothing"
					$bs_name_info[0+L[0]] = ""
					$bs_name_info_prev[0+L[0]] = ""
				}
			}
			if ($bs_name[0] != "nothing" && @bs_wipe_decide == @On)	{
				@bs_wipe_decide = @Off
				$bs_disp_in(0)
			}
			if (($bg_set_ready == @On) && (@W_SLIDE == @Off))	{
				$bg_disp_set(0)
			}
			else	{
				// ※
				for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
					@b.obj[@OBJ_BG01+L[0]].create_copy_from(@f.obj[@OBJ_BG01+L[0]])
				}
			}
			$bg_disp_cnt = @Init
			$bs_disp_cnt = @Init
			$bg_set_ready = @Off
			$fade_wmnd = @Off
			// 表示
			$wipe(@SEL)
			// 立ち絵のワイプ初期化
			$bs_wipe_set = 0
			// 背景準備フラグを初期化
			$bg_set_ready = @Off

			$bs_set_ready = @Off


// ---------------------------------------------------------------
// セット表示命令 [メッセージウィンドウごとワイプ]
// ---------------------------------------------------------------
#macro		@WIPE_ALL(@SEL, @W_SLIDE(0))
			if ($disp == _disp_bs)	{
				$bs_wipe_set = @SEL
			}
			else	{
				$bg_wipe_set = @SEL
			}
			$bs_disp_in(0)
			if (($bg_set_ready == @On) && (@W_SLIDE == @Off))	{
				$bg_disp_set(0)
			}
			else	{
				// ※
				for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
					@b.obj[@OBJ_BG01+L[0]].create_copy_from(@f.obj[@OBJ_BG01+L[0]])
				}
			}
			$bg_disp_cnt = @Init
			$bs_disp_cnt = @Init
			$bg_set_ready = @Off
			$fade_wmnd = @On
			// 表示
			$wipe(@SEL)
			// 立ち絵のワイプ初期化
			$bs_wipe_set = 0
			// 背景準備フラグを初期化
			$bg_set_ready = @Off

// ---------------------------------------------------------------
// バストショット標準表示
// ---------------------------------------------------------------
#property	$bs_defwipe : int
#property	$bs_defwipe_all : int
#macro		@BS_DEFWIPE(@SWITCH)
			$bs_defwipe = @SWITCH
#macro		@BS_DEFWIPE_ALL(@SWITCH)
			$bs_defwipe_all = @SWITCH

// ---------------------------------------------------------------
// バストショット座標情報初期化
// ---------------------------------------------------------------
#macro		@Clear_bs_info(@C_MAX)
			for (L[0] = 0, L[0] <= 90, L[0] += 30)	{
				for (L[1] = 0, L[1] <= @C_MAX, L[1] += 1)	{
					back.object[L[0]+@OBJ_BS_01+L[1]].set_pos(@bs_pos_init, @bs_pos_init)
					front.object[L[0]+@OBJ_BS_01+L[1]].set_pos(@bs_pos_init, @bs_pos_init)
				}
			}

// ---------------------------------------------------------------
// キャラクターデフォルトレイヤーセット
// ---------------------------------------------------------------
#macro		@Set_chara_layer(@C_ID, @C_LAYER)
			// キャラ
			$chara_layer[@C_ID+10]      = @C_LAYER
			$chara_layer_prev[@C_ID+10] = $chara_layer[@C_ID+10]
			$chara_layer_next[@C_ID+10] = $chara_layer[@C_ID+10]
			// エモ01
			$chara_emo01_layer[@C_ID+10]      = $chara_layer[@C_ID+10] + 1
			$chara_emo01_layer_prev[@C_ID+10] = $chara_emo01_layer[@C_ID+10]
			$chara_emo01_layer_next[@C_ID+10] = $chara_emo01_layer[@C_ID+10]
			// エモ02
			$chara_emo02_layer[@C_ID+10]      = $chara_layer[@C_ID+10] + 2
			$chara_emo02_layer_prev[@C_ID+10] = $chara_emo02_layer[@C_ID+10]
			$chara_emo02_layer_next[@C_ID+10] = $chara_emo02_layer[@C_ID+10]
			// エモ03
			$chara_emo03_layer[@C_ID+10]      = $chara_layer[@C_ID+10] + 3
			$chara_emo03_layer_prev[@C_ID+10] = $chara_emo03_layer[@C_ID+10]
			$chara_emo03_layer_next[@C_ID+10] = $chara_emo03_layer[@C_ID+10]

// ---------------------------------------------------------------
// キャラクターデフォルトレイヤー取得
// ---------------------------------------------------------------
#macro		@Get_chara_layer(@BS_DISP_CNT)
			// バストショット距離判定
			@BS_FAR01[+@BS_DISP_CNT] = $bs_name[0+@BS_DISP_CNT].cnt - 6
			// エモーション表示判定
			$bs_disp_emo_info(0)
			// バストショット距離判定
			$bs_disp_far_info(0)

			// キャラクターＩ．Ｔ判定
//			farcall("_sys_macro_bs", 03)
//			farcall("_sys_macro_bs", 04)

// ---------------------------------------------------------------
// 指定エモーション情報取得
// ---------------------------------------------------------------
#macro		@Get_emo_info(@CHA_NUM, @BS_EMO, @BS_ACTION, @BS_NUM, @EMO_NUM, @BS_POSE, @BS_DEL)
//			farcall("_sys_macro_emo", 00, @CHA_NUM, @BS_EMO, @BS_ACTION, @BS_NUM, @EMO_NUM, @BS_POSE, @BS_DEL)
			$get_eno_info(@CHA_NUM, @BS_EMO, @BS_ACTION, @BS_NUM, @EMO_NUM, @BS_POSE, @BS_DEL)

#command	$get_eno_info(int, int, str, int, int, str, int)

// ---------------------------------------------------------------
// バストショットアクション
// ---------------------------------------------------------------
#macro		@bs_action_start(@bs_cha_num, @bs_action, @bs_maxnum, @bs_bkft, @bs_action_num, @bs_action_time, @bs_action_end_time)
//			farcall("_sys_macro_action", 00, @bs_cha_num, @bs_action, @bs_maxnum, @bs_bkft, @bs_action_num, @bs_action_time, @bs_action_end_time)
			$bs_action_set0(@bs_cha_num, @bs_action, @bs_maxnum, @bs_bkft, @bs_action_num, @bs_action_time, @bs_action_end_time)

#command	$bs_action_set0(int, str, int, int, int, int, int)

// ---------------------------------------------------------------
// バストショットアクション設定 [不透明度]
// ---------------------------------------------------------------
#macro		@SET_BS_TR_ACTION(@BS_NUM, @TR)
			$bs_action_set[@BS_NUM] = @On
			$bs_tr_next[@BS_NUM] = @TR

// ---------------------------------------------------------------
// バストショットアクション設定 [拡大／縮小]
// ---------------------------------------------------------------
#macro		@SET_BS_SC_ACTION(@BS_NUM, @TIME, @SCALE_X, @SCALE_Y(-999999))
			$bs_action_set[@BS_NUM] = @On
			$bs_action_sc_time_set[@BS_NUM] = @TIME
			$bs_action_scale_x_set[@BS_NUM] = @SCALE_X * 10
			if (@SCALE_Y != -999999)	{
				$bs_action_scale_y_set[@BS_NUM] = @SCALE_X * 10
			}

// ---------------------------------------------------------------
// バストショットアクション設定 [回転]
// ---------------------------------------------------------------
#macro		@SET_BS_RO_ACTION(@BS_NUM, @TIME, @ROTATE)
			$bs_action_set[@BS_NUM] = @On
			$bs_action_ro_time_set[@BS_NUM] = @TIME
			$bs_action_rotate_set[@BS_NUM] = @ROTATE * 10


// バストショット表示
#command 	$bs_disp_in(int) : int
// バストショット表示情報取得
#command 	$bs_disp_info(int) : int
// エモーション表示判定
#command 	$bs_disp_emo_info(int) : int
// バストショット距離判定
#command 	$bs_disp_far_info(int) : int
// バストショットトーンカーブ設定
#command 	$bs_tone_set(str) : int
// バストショット表情番号
#property	$bs_face_num : int
// バストショット口元番号
#property	$bs_mouth_num : int

// バストショットネーム判定
#property	$bs_name_decide : intlist[@bs_maxnum]

// 合成前のバストショットネーム取得
#property $cha_name_prev : strlist[@bs_maxnum]





// ---------------------------------------------------------------
// スライドイン／スライドアウト
// ---------------------------------------------------------------
#define		@r1		00r1
#define		@r2		00r2
#define		@r3		00r3
#define		@r4		00r4
#define		@r5		00r5

#define		@l1		00l1
#define		@l2		00l2
#define		@l3		00l3
#define		@l4		00l4
#define		@l5		00l5

#define		@u1		00u1
#define		@u2		00u2
#define		@u3		00u3
#define		@u4		00u4
#define		@u5		00u5

#define		@d1		00d1
#define		@d2		00d2
#define		@d3		00d3
#define		@d4		00d4
#define		@d5		00d5

// エモ無し ※暫定設定 2013.10.18
#define		@00		0000		// 無し
#define		@00a	00a0		// 頷き
#define		@00b	00b0		// お辞儀
#define		@00c	00c0		// プルプル（怒り、震えetc）
#define		@00d	00d0		// 驚き（飛び上がる）
#define		@00e	00e0		// 驚き（上下にビクビクッ）
#define		@00f	00f0		// 喜び（バンザイ）
#define		@00g	00g0		// 主張（ピョンピョン）
#define		@00h	00h0		// 地団駄
#define		@00i	00i0		// 息切れ（しこたま殴った後とか
#define		@00j	00j0		// 軽いスクワット的な喜び？
#define		@00k	00k0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@00l	00l0		// フラフラ
#define		@00m	00m0		// 弾む感じで上下に揺れる
#define		@00n	00n0		// テレテレ
#define		@00o	00o0		// デコピン（小突き的な）
#define		@00p	00p0		// 左回転
#define		@00q	00q0		// 左回転
#define		@00r	00r0		// 
#define		@00s	00s0		// 
#define		@00t	00t0		// 
#define		@00u	00u0		// 
#define		@00v	00v0		// 
#define		@00w	00w0		// 
#define		@00x	00x0		// 
#define		@00y	00y0		// 
#define		@00z	00z0		// 
// タラリ汗・右（消）
#define		@01		0100		// 無し
#define		@01a	01a0		// 頷き
#define		@01b	01b0		// お辞儀
#define		@01c	01c0		// プルプル（怒り、震えetc）
#define		@01d	01d0		// 驚き（飛び上がる）
#define		@01e	01e0		// 驚き（上下にビクビクッ）
#define		@01f	01f0		// 喜び（バンザイ）
#define		@01g	01g0		// 主張（ピョンピョン）
#define		@01h	01h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@01i	01i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@01j	01j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@01k	01k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@01l	01l0		// 地団駄
#define		@01m	01m0		// 息切れ（しこたま殴った後とか
#define		@01n	01n0		// 軽いスクワット的な喜び？
#define		@01o	01o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@01p	01p0		// フラフラ
#define		@01q	01q0		// 弾む感じで上下に揺れる
#define		@01r	01r0		// テレテレ
#define		@01s	01s0		// デコピン（小突き的な）
#define		@01t	01t0		// 左回転
#define		@01u	01u0		// 左回転
#define		@01v	01v0		// 
#define		@01w	01w0		// 
#define		@01x	01x0		// 
#define		@01y	01y0		// 
#define		@01z	01z0		// 
// タラリ汗・左（消）
#define		@02		0200		// 無し
#define		@02a	02a0		// 頷き
#define		@02b	02b0		// お辞儀
#define		@02c	02c0		// プルプル（怒り、震えetc）
#define		@02d	02d0		// 驚き（飛び上がる）
#define		@02e	02e0		// 驚き（上下にビクビクッ）
#define		@02f	02f0		// 喜び（バンザイ）
#define		@02g	02g0		// 主張（ピョンピョン）
#define		@02h	02h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@02i	02i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@02j	02j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@02k	02k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@02l	02l0		// 地団駄
#define		@02m	02m0		// 息切れ（しこたま殴った後とか
#define		@02n	02n0		// 軽いスクワット的な喜び？
#define		@02o	02o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@02p	02p0		// フラフラ
#define		@02q	02q0		// 弾む感じで上下に揺れる
#define		@02r	02r0		// テレテレ
#define		@02s	02s0		// デコピン（小突き的な）
#define		@02t	02t0		// 左回転
#define		@02u	02u0		// 左回転
#define		@02v	02v0		// 
#define		@02w	02w0		// 
#define		@02x	02x0		// 
#define		@02y	02y0		// 
#define		@02z	02z0		// 
// タラリ汗・右（残）
#define		@03		0300		// 無し
#define		@03a	03a0		// 頷き
#define		@03b	03b0		// お辞儀
#define		@03c	03c0		// プルプル（怒り、震えetc）
#define		@03d	03d0		// 驚き（飛び上がる）
#define		@03e	03e0		// 驚き（上下にビクビクッ）
#define		@03f	03f0		// 喜び（バンザイ）
#define		@03g	03g0		// 主張（ピョンピョン）
#define		@03h	03h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@03i	03i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@03j	03j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@03k	03k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@03l	03l0		// 地団駄
#define		@03m	03m0		// 息切れ（しこたま殴った後とか
#define		@03n	03n0		// 軽いスクワット的な喜び？
#define		@03o	03o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@03p	03p0		// フラフラ
#define		@03q	03q0		// 弾む感じで上下に揺れる
#define		@03r	03r0		// テレテレ
#define		@03s	03s0		// デコピン（小突き的な）
#define		@03t	03t0		// 左回転
#define		@03u	03u0		// 左回転
#define		@03v	03v0		// 
#define		@03w	03w0		// 
#define		@03x	03x0		// 
#define		@03y	03y0		// 
#define		@03z	03z0		// 
// タラリ汗・左（残）
#define		@04		0400		// 無し
#define		@04a	04a0		// 頷き
#define		@04b	04b0		// お辞儀
#define		@04c	04c0		// プルプル（怒り、震えetc）
#define		@04d	04d0		// 驚き（飛び上がる）
#define		@04e	04e0		// 驚き（上下にビクビクッ）
#define		@04f	04f0		// 喜び（バンザイ）
#define		@04g	04g0		// 主張（ピョンピョン）
#define		@04h	04h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@04i	04i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@04j	04j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@04k	04k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@04l	04l0		// 地団駄
#define		@04m	04m0		// 息切れ（しこたま殴った後とか
#define		@04n	04n0		// 軽いスクワット的な喜び？
#define		@04o	04o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@04p	04p0		// フラフラ
#define		@04q	04q0		// 弾む感じで上下に揺れる
#define		@04r	04r0		// テレテレ
#define		@04s	04s0		// デコピン（小突き的な）
#define		@04t	04t0		// 左回転
#define		@04u	04u0		// 左回転
#define		@04v	04v0		// 
#define		@04w	04w0		// 
#define		@04x	04x0		// 
#define		@04y	04y0		// 
#define		@04z	04z0		// 
// 飛び汗（遅）・右
#define		@05		0500		// 無し
#define		@05a	05a0		// 頷き
#define		@05b	05b0		// お辞儀
#define		@05c	05c0		// プルプル（怒り、震えetc）
#define		@05d	05d0		// 驚き（飛び上がる）
#define		@05e	05e0		// 驚き（上下にビクビクッ）
#define		@05f	05f0		// 喜び（バンザイ）
#define		@05g	05g0		// 主張（ピョンピョン）
#define		@05h	05h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@05i	05i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@05j	05j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@05k	05k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@05l	05l0		// 地団駄
#define		@05m	05m0		// 息切れ（しこたま殴った後とか
#define		@05n	05n0		// 軽いスクワット的な喜び？
#define		@05o	05o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@05p	05p0		// フラフラ
#define		@05q	05q0		// 弾む感じで上下に揺れる
#define		@05r	05r0		// テレテレ
#define		@05s	05s0		// デコピン（小突き的な）
#define		@05t	05t0		// 左回転
#define		@05u	05u0		// 左回転
#define		@05v	05v0		// 
#define		@05w	05w0		// 
#define		@05x	05x0		// 
#define		@05y	05y0		// 
#define		@05z	05z0		// 
// 飛び汗（遅）・左
#define		@06		0600		// 無し
#define		@06a	06a0		// 頷き
#define		@06b	06b0		// お辞儀
#define		@06c	06c0		// プルプル（怒り、震えetc）
#define		@06d	06d0		// 驚き（飛び上がる）
#define		@06e	06e0		// 驚き（上下にビクビクッ）
#define		@06f	06f0		// 喜び（バンザイ）
#define		@06g	06g0		// 主張（ピョンピョン）
#define		@06h	06h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@06i	06i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@06j	06j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@06k	06k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@06l	06l0		// 地団駄
#define		@06m	06m0		// 息切れ（しこたま殴った後とか
#define		@06n	06n0		// 軽いスクワット的な喜び？
#define		@06o	06o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@06p	06p0		// フラフラ
#define		@06q	06q0		// 弾む感じで上下に揺れる
#define		@06r	06r0		// テレテレ
#define		@06s	06s0		// デコピン（小突き的な）
#define		@06t	06t0		// 左回転
#define		@06u	06u0		// 左回転
#define		@06v	06v0		// 
#define		@06w	06w0		// 
#define		@06x	06x0		// 
#define		@06y	06y0		// 
#define		@06z	06z0		// 
// 飛び汗（速）・右
#define		@07		0700		// 無し
#define		@07a	07a0		// 頷き
#define		@07b	07b0		// お辞儀
#define		@07c	07c0		// プルプル（怒り、震えetc）
#define		@07d	07d0		// 驚き（飛び上がる）
#define		@07e	07e0		// 驚き（上下にビクビクッ）
#define		@07f	07f0		// 喜び（バンザイ）
#define		@07g	07g0		// 主張（ピョンピョン）
#define		@07h	07h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@07i	07i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@07j	07j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@07k	07k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@07l	07l0		// 地団駄
#define		@07m	07m0		// 息切れ（しこたま殴った後とか
#define		@07n	07n0		// 軽いスクワット的な喜び？
#define		@07o	07o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@07p	07p0		// フラフラ
#define		@07q	07q0		// 弾む感じで上下に揺れる
#define		@07r	07r0		// テレテレ
#define		@07s	07s0		// デコピン（小突き的な）
#define		@07t	07t0		// 左回転
#define		@07u	07u0		// 左回転
#define		@07v	07v0		// 
#define		@07w	07w0		// 
#define		@07x	07x0		// 
#define		@07y	07y0		// 
#define		@07z	07z0		// 
// 飛び汗（速）・左
#define		@08		0800		// 無し
#define		@08a	08a0		// 頷き
#define		@08b	08b0		// お辞儀
#define		@08c	08c0		// プルプル（怒り、震えetc）
#define		@08d	08d0		// 驚き（飛び上がる）
#define		@08e	08e0		// 驚き（上下にビクビクッ）
#define		@08f	08f0		// 喜び（バンザイ）
#define		@08g	08g0		// 主張（ピョンピョン）
#define		@08h	08h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@08i	08i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@08j	08j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@08k	08k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@08l	08l0		// 地団駄
#define		@08m	08m0		// 息切れ（しこたま殴った後とか
#define		@08n	08n0		// 軽いスクワット的な喜び？
#define		@08o	08o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@08p	08p0		// フラフラ
#define		@08q	08q0		// 弾む感じで上下に揺れる
#define		@08r	08r0		// テレテレ
#define		@08s	08s0		// デコピン（小突き的な）
#define		@08t	08t0		// 左回転
#define		@08u	08u0		// 左回転
#define		@08v	08v0		// 
#define		@08w	08w0		// 
#define		@08x	08x0		// 
#define		@08y	08y0		// 
#define		@08z	08z0		// 
// あたふた
#define		@09		0900		// 無し
#define		@09a	09a0		// 頷き
#define		@09b	09b0		// お辞儀
#define		@09c	09c0		// プルプル（怒り、震えetc）
#define		@09d	09d0		// 驚き（飛び上がる）
#define		@09e	09e0		// 驚き（上下にビクビクッ）
#define		@09f	09f0		// 喜び（バンザイ）
#define		@09g	09g0		// 主張（ピョンピョン）
#define		@09h	09h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@09i	09i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@09j	09j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@09k	09k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@09l	09l0		// 地団駄
#define		@09m	09m0		// 息切れ（しこたま殴った後とか
#define		@09n	09n0		// 軽いスクワット的な喜び？
#define		@09o	09o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@09p	09p0		// フラフラ
#define		@09q	09q0		// 弾む感じで上下に揺れる
#define		@09r	09r0		// テレテレ
#define		@09s	09s0		// デコピン（小突き的な）
#define		@09t	09t0		// 左回転
#define		@09u	09u0		// 左回転
#define		@09v	09v0		// 
#define		@09w	09w0		// 
#define		@09x	09x0		// 
#define		@09y	09y0		// 
#define		@09z	09z0		// 
// ビックリ・右
#define		@10		1000		// 無し
#define		@10a	10a0		// 頷き
#define		@10b	10b0		// お辞儀
#define		@10c	10c0		// プルプル（怒り、震えetc）
#define		@10d	10d0		// 驚き（飛び上がる）
#define		@10e	10e0		// 驚き（上下にビクビクッ）
#define		@10f	10f0		// 喜び（バンザイ）
#define		@10g	10g0		// 主張（ピョンピョン）
#define		@10h	10h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@10i	10i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@10j	10j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@10k	10k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@10l	10l0		// 地団駄
#define		@10m	10m0		// 息切れ（しこたま殴った後とか
#define		@10n	10n0		// 軽いスクワット的な喜び？
#define		@10o	10o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@10p	10p0		// フラフラ
#define		@10q	10q0		// 弾む感じで上下に揺れる
#define		@10r	10r0		// テレテレ
#define		@10s	10s0		// デコピン（小突き的な）
#define		@10t	10t0		// 左回転
#define		@10u	10u0		// 左回転
#define		@10v	10v0		// 
#define		@10w	10w0		// 
#define		@10x	10x0		// 
#define		@10y	10y0		// 
#define		@10z	10z0		// 
// ビックリ・左
#define		@11		1100		// 無し
#define		@11a	11a0		// 頷き
#define		@11b	11b0		// お辞儀
#define		@11c	11c0		// プルプル（怒り、震えetc）
#define		@11d	11d0		// 驚き（飛び上がる）
#define		@11e	11e0		// 驚き（上下にビクビクッ）
#define		@11f	11f0		// 喜び（バンザイ）
#define		@11g	11g0		// 主張（ピョンピョン）
#define		@11h	11h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@11i	11i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@11j	11j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@11k	11k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@11l	11l0		// 地団駄
#define		@11m	11m0		// 息切れ（しこたま殴った後とか
#define		@11n	11n0		// 軽いスクワット的な喜び？
#define		@11o	11o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@11p	11p0		// フラフラ
#define		@11q	11q0		// 弾む感じで上下に揺れる
#define		@11r	11r0		// テレテレ
#define		@11s	11s0		// デコピン（小突き的な）
#define		@11t	11t0		// 左回転
#define		@11u	11u0		// 左回転
#define		@11v	11v0		// 
#define		@11w	11w0		// 
#define		@11x	11x0		// 
#define		@11y	11y0		// 
#define		@11z	11z0		// 
// 怒り１・右
#define		@12		1200		// 無し
#define		@12a	12a0		// 頷き
#define		@12b	12b0		// お辞儀
#define		@12c	12c0		// プルプル（怒り、震えetc）
#define		@12d	12d0		// 驚き（飛び上がる）
#define		@12e	12e0		// 驚き（上下にビクビクッ）
#define		@12f	12f0		// 喜び（バンザイ）
#define		@12g	12g0		// 主張（ピョンピョン）
#define		@12h	12h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@12i	12i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@12j	12j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@12k	12k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@12l	12l0		// 地団駄
#define		@12m	12m0		// 息切れ（しこたま殴った後とか
#define		@12n	12n0		// 軽いスクワット的な喜び？
#define		@12o	12o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@12p	12p0		// フラフラ
#define		@12q	12q0		// 弾む感じで上下に揺れる
#define		@12r	12r0		// テレテレ
#define		@12s	12s0		// デコピン（小突き的な）
#define		@12t	12t0		// 左回転
#define		@12u	12u0		// 左回転
#define		@12v	12v0		// 
#define		@12w	12w0		// 
#define		@12x	12x0		// 
#define		@12y	12y0		// 
#define		@12z	12z0		// 
// 怒り１・左
#define		@13		1300		// 無し
#define		@13a	13a0		// 頷き
#define		@13b	13b0		// お辞儀
#define		@13c	13c0		// プルプル（怒り、震えetc）
#define		@13d	13d0		// 驚き（飛び上がる）
#define		@13e	13e0		// 驚き（上下にビクビクッ）
#define		@13f	13f0		// 喜び（バンザイ）
#define		@13g	13g0		// 主張（ピョンピョン）
#define		@13h	13h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@13i	13i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@13j	13j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@13k	13k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@13l	13l0		// 地団駄
#define		@13m	13m0		// 息切れ（しこたま殴った後とか
#define		@13n	13n0		// 軽いスクワット的な喜び？
#define		@13o	13o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@13p	13p0		// フラフラ
#define		@13q	13q0		// 弾む感じで上下に揺れる
#define		@13r	13r0		// テレテレ
#define		@13s	13s0		// デコピン（小突き的な）
#define		@13t	13t0		// 左回転
#define		@13u	13u0		// 左回転
#define		@13v	13v0		// 
#define		@13w	13w0		// 
#define		@13x	13x0		// 
#define		@13y	13y0		// 
#define		@13z	13z0		// 
// 怒り２・右
#define		@14		1400		// 無し
#define		@14a	14a0		// 頷き
#define		@14b	14b0		// お辞儀
#define		@14c	14c0		// プルプル（怒り、震えetc）
#define		@14d	14d0		// 驚き（飛び上がる）
#define		@14e	14e0		// 驚き（上下にビクビクッ）
#define		@14f	14f0		// 喜び（バンザイ）
#define		@14g	14g0		// 主張（ピョンピョン）
#define		@14h	14h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@14i	14i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@14j	14j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@14k	14k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@14l	14l0		// 地団駄
#define		@14m	14m0		// 息切れ（しこたま殴った後とか
#define		@14n	14n0		// 軽いスクワット的な喜び？
#define		@14o	14o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@14p	14p0		// フラフラ
#define		@14q	14q0		// 弾む感じで上下に揺れる
#define		@14r	14r0		// テレテレ
#define		@14s	14s0		// デコピン（小突き的な）
#define		@14t	14t0		// 左回転
#define		@14u	14u0		// 左回転
#define		@14v	14v0		// 
#define		@14w	14w0		// 
#define		@14x	14x0		// 
#define		@14y	14y0		// 
#define		@14z	14z0		// 
// 怒り２・左
#define		@15		1500		// 無し
#define		@15a	15a0		// 頷き
#define		@15b	15b0		// お辞儀
#define		@15c	15c0		// プルプル（怒り、震えetc）
#define		@15d	15d0		// 驚き（飛び上がる）
#define		@15e	15e0		// 驚き（上下にビクビクッ）
#define		@15f	15f0		// 喜び（バンザイ）
#define		@15g	15g0		// 主張（ピョンピョン）
#define		@15h	15h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@15i	15i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@15j	15j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@15k	15k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@15l	15l0		// 地団駄
#define		@15m	15m0		// 息切れ（しこたま殴った後とか
#define		@15n	15n0		// 軽いスクワット的な喜び？
#define		@15o	15o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@15p	15p0		// フラフラ
#define		@15q	15q0		// 弾む感じで上下に揺れる
#define		@15r	15r0		// テレテレ
#define		@15s	15s0		// デコピン（小突き的な）
#define		@15t	15t0		// 左回転
#define		@15u	15u0		// 左回転
#define		@15v	15v0		// 
#define		@15w	15w0		// 
#define		@15x	15x0		// 
#define		@15y	15y0		// 
#define		@15z	15z0		// 
// 怒り３・右
#define		@16		1600		// 無し
#define		@16a	16a0		// 頷き
#define		@16b	16b0		// お辞儀
#define		@16c	16c0		// プルプル（怒り、震えetc）
#define		@16d	16d0		// 驚き（飛び上がる）
#define		@16e	16e0		// 驚き（上下にビクビクッ）
#define		@16f	16f0		// 喜び（バンザイ）
#define		@16g	16g0		// 主張（ピョンピョン）
#define		@16h	16h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@16i	16i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@16j	16j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@16k	16k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@16l	16l0		// 地団駄
#define		@16m	16m0		// 息切れ（しこたま殴った後とか
#define		@16n	16n0		// 軽いスクワット的な喜び？
#define		@16o	16o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@16p	16p0		// フラフラ
#define		@16q	16q0		// 弾む感じで上下に揺れる
#define		@16r	16r0		// テレテレ
#define		@16s	16s0		// デコピン（小突き的な）
#define		@16t	16t0		// 左回転
#define		@16u	16u0		// 左回転
#define		@16v	16v0		// 
#define		@16w	16w0		// 
#define		@16x	16x0		// 
#define		@16y	16y0		// 
#define		@16z	16z0		// 
// 怒り３・左
#define		@17		1700		// 無し
#define		@17a	17a0		// 頷き
#define		@17b	17b0		// お辞儀
#define		@17c	17c0		// プルプル（怒り、震えetc）
#define		@17d	17d0		// 驚き（飛び上がる）
#define		@17e	17e0		// 驚き（上下にビクビクッ）
#define		@17f	17f0		// 喜び（バンザイ）
#define		@17g	17g0		// 主張（ピョンピョン）
#define		@17h	17h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@17i	17i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@17j	17j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@17k	17k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@17l	17l0		// 地団駄
#define		@17m	17m0		// 息切れ（しこたま殴った後とか
#define		@17n	17n0		// 軽いスクワット的な喜び？
#define		@17o	17o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@17p	17p0		// フラフラ
#define		@17q	17q0		// 弾む感じで上下に揺れる
#define		@17r	17r0		// テレテレ
#define		@17s	17s0		// デコピン（小突き的な）
#define		@17t	17t0		// 左回転
#define		@17u	17u0		// 左回転
#define		@17v	17v0		// 
#define		@17w	17w0		// 
#define		@17x	17x0		// 
#define		@17y	17y0		// 
#define		@17z	17z0		// 
// ご機嫌・右
#define		@18		1800		// 無し
#define		@18a	18a0		// 頷き
#define		@18b	18b0		// お辞儀
#define		@18c	18c0		// プルプル（怒り、震えetc）
#define		@18d	18d0		// 驚き（飛び上がる）
#define		@18e	18e0		// 驚き（上下にビクビクッ）
#define		@18f	18f0		// 喜び（バンザイ）
#define		@18g	18g0		// 主張（ピョンピョン）
#define		@18h	18h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@18i	18i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@18j	18j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@18k	18k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@18l	18l0		// 地団駄
#define		@18m	18m0		// 息切れ（しこたま殴った後とか
#define		@18n	18n0		// 軽いスクワット的な喜び？
#define		@18o	18o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@18p	18p0		// フラフラ
#define		@18q	18q0		// 弾む感じで上下に揺れる
#define		@18r	18r0		// テレテレ
#define		@18s	18s0		// デコピン（小突き的な）
#define		@18t	18t0		// 左回転
#define		@18u	18u0		// 左回転
#define		@18v	18v0		// 
#define		@18w	18w0		// 
#define		@18x	18x0		// 
#define		@18y	18y0		// 
#define		@18z	18z0		// 
// ご機嫌・左
#define		@19		1900		// 無し
#define		@19a	19a0		// 頷き
#define		@19b	19b0		// お辞儀
#define		@19c	19c0		// プルプル（怒り、震えetc）
#define		@19d	19d0		// 驚き（飛び上がる）
#define		@19e	19e0		// 驚き（上下にビクビクッ）
#define		@19f	19f0		// 喜び（バンザイ）
#define		@19g	19g0		// 主張（ピョンピョン）
#define		@19h	19h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@19i	19i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@19j	19j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@19k	19k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@19l	19l0		// 地団駄
#define		@19m	19m0		// 息切れ（しこたま殴った後とか
#define		@19n	19n0		// 軽いスクワット的な喜び？
#define		@19o	19o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@19p	19p0		// フラフラ
#define		@19q	19q0		// 弾む感じで上下に揺れる
#define		@19r	19r0		// テレテレ
#define		@19s	19s0		// デコピン（小突き的な）
#define		@19t	19t0		// 左回転
#define		@19u	19u0		// 左回転
#define		@19v	19v0		// 
#define		@19w	19w0		// 
#define		@19x	19x0		// 
#define		@19y	19y0		// 
#define		@19z	19z0		// 
// ご機嫌・魁Ver
#define		@20		2000		// 無し
#define		@20a	20a0		// 頷き
#define		@20b	20b0		// お辞儀
#define		@20c	20c0		// プルプル（怒り、震えetc）
#define		@20d	20d0		// 驚き（飛び上がる）
#define		@20e	20e0		// 驚き（上下にビクビクッ）
#define		@20f	20f0		// 喜び（バンザイ）
#define		@20g	20g0		// 主張（ピョンピョン）
#define		@20h	20h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@20i	20i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@20j	20j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@20k	20k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@20l	20l0		// 地団駄
#define		@20m	20m0		// 息切れ（しこたま殴った後とか
#define		@20n	20n0		// 軽いスクワット的な喜び？
#define		@20o	20o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@20p	20p0		// フラフラ
#define		@20q	20q0		// 弾む感じで上下に揺れる
#define		@20r	20r0		// テレテレ
#define		@20s	20s0		// デコピン（小突き的な）
#define		@20t	20t0		// 左回転
#define		@20u	20u0		// 左回転
#define		@20v	20v0		// 
#define		@20w	20w0		// 
#define		@20x	20x0		// 
#define		@20y	20y0		// 
#define		@20z	20z0		// 
// 集中線
#define		@21		2100		// 無し
#define		@21a	21a0		// 頷き
#define		@21b	21b0		// お辞儀
#define		@21c	21c0		// プルプル（怒り、震えetc）
#define		@21d	21d0		// 驚き（飛び上がる）
#define		@21e	21e0		// 驚き（上下にビクビクッ）
#define		@21f	21f0		// 喜び（バンザイ）
#define		@21g	21g0		// 主張（ピョンピョン）
#define		@21h	21h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@21i	21i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@21j	21j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@21k	21k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@21l	21l0		// 地団駄
#define		@21m	21m0		// 息切れ（しこたま殴った後とか
#define		@21n	21n0		// 軽いスクワット的な喜び？
#define		@21o	21o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@21p	21p0		// フラフラ
#define		@21q	21q0		// 弾む感じで上下に揺れる
#define		@21r	21r0		// テレテレ
#define		@21s	21s0		// デコピン（小突き的な）
#define		@21t	21t0		// 左回転
#define		@21u	21u0		// 左回転
#define		@21v	21v0		// 
#define		@21w	21w0		// 
#define		@21x	21x0		// 
#define		@21y	21y0		// 
#define		@21z	21z0		// 
// ため息・右
#define		@22		2200		// 無し
#define		@22a	22a0		// 頷き
#define		@22b	22b0		// お辞儀
#define		@22c	22c0		// プルプル（怒り、震えetc）
#define		@22d	22d0		// 驚き（飛び上がる）
#define		@22e	22e0		// 驚き（上下にビクビクッ）
#define		@22f	22f0		// 喜び（バンザイ）
#define		@22g	22g0		// 主張（ピョンピョン）
#define		@22h	22h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@22i	22i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@22j	22j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@22k	22k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@22l	22l0		// 地団駄
#define		@22m	22m0		// 息切れ（しこたま殴った後とか
#define		@22n	22n0		// 軽いスクワット的な喜び？
#define		@22o	22o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@22p	22p0		// フラフラ
#define		@22q	22q0		// 弾む感じで上下に揺れる
#define		@22r	22r0		// テレテレ
#define		@22s	22s0		// デコピン（小突き的な）
#define		@22t	22t0		// 左回転
#define		@22u	22u0		// 左回転
#define		@22v	22v0		// 
#define		@22w	22w0		// 
#define		@22x	22x0		// 
#define		@22y	22y0		// 
#define		@22z	22z0		// 
// ため息・左
#define		@23		2300		// 無し
#define		@23a	23a0		// 頷き
#define		@23b	23b0		// お辞儀
#define		@23c	23c0		// プルプル（怒り、震えetc）
#define		@23d	23d0		// 驚き（飛び上がる）
#define		@23e	23e0		// 驚き（上下にビクビクッ）
#define		@23f	23f0		// 喜び（バンザイ）
#define		@23g	23g0		// 主張（ピョンピョン）
#define		@23h	23h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@23i	23i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@23j	23j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@23k	23k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@23l	23l0		// 地団駄
#define		@23m	23m0		// 息切れ（しこたま殴った後とか
#define		@23n	23n0		// 軽いスクワット的な喜び？
#define		@23o	23o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@23p	23p0		// フラフラ
#define		@23q	23q0		// 弾む感じで上下に揺れる
#define		@23r	23r0		// テレテレ
#define		@23s	23s0		// デコピン（小突き的な）
#define		@23t	23t0		// 左回転
#define		@23u	23u0		// 左回転
#define		@23v	23v0		// 
#define		@23w	23w0		// 
#define		@23x	23x0		// 
#define		@23y	23y0		// 
#define		@23z	23z0		// 
// どよ～んな感じ → ("0´д｀|||)・右
#define		@24		2400		// 無し
#define		@24a	24a0		// 頷き
#define		@24b	24b0		// お辞儀
#define		@24c	24c0		// プルプル（怒り、震えetc）
#define		@24d	24d0		// 驚き（飛び上がる）
#define		@24e	24e0		// 驚き（上下にビクビクッ）
#define		@24f	24f0		// 喜び（バンザイ）
#define		@24g	24g0		// 主張（ピョンピョン）
#define		@24h	24h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@24i	24i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@24j	24j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@24k	24k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@24l	24l0		// 地団駄
#define		@24m	24m0		// 息切れ（しこたま殴った後とか
#define		@24n	24n0		// 軽いスクワット的な喜び？
#define		@24o	24o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@24p	24p0		// フラフラ
#define		@24q	24q0		// 弾む感じで上下に揺れる
#define		@24r	24r0		// テレテレ
#define		@24s	24s0		// デコピン（小突き的な）
#define		@24t	24t0		// 左回転
#define		@24u	24u0		// 左回転
#define		@24v	24v0		// 
#define		@24w	24w0		// 
#define		@24x	24x0		// 
#define		@24y	24y0		// 
#define		@24z	24z0		// 
// どよ～んな感じ → ("0´д｀|||)・左
#define		@25		2500		// 無し
#define		@25a	25a0		// 頷き
#define		@25b	25b0		// お辞儀
#define		@25c	25c0		// プルプル（怒り、震えetc）
#define		@25d	25d0		// 驚き（飛び上がる）
#define		@25e	25e0		// 驚き（上下にビクビクッ）
#define		@25f	25f0		// 喜び（バンザイ）
#define		@25g	25g0		// 主張（ピョンピョン）
#define		@25h	25h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@25i	25i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@25j	25j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@25k	25k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@25l	25l0		// 地団駄
#define		@25m	25m0		// 息切れ（しこたま殴った後とか
#define		@25n	25n0		// 軽いスクワット的な喜び？
#define		@25o	25o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@25p	25p0		// フラフラ
#define		@25q	25q0		// 弾む感じで上下に揺れる
#define		@25r	25r0		// テレテレ
#define		@25s	25s0		// デコピン（小突き的な）
#define		@25t	25t0		// 左回転
#define		@25u	25u0		// 左回転
#define		@25v	25v0		// 
#define		@25w	25w0		// 
#define		@25x	25x0		// 
#define		@25y	25y0		// 
#define		@25z	25z0		// 
// ～♪・右
#define		@26		2600		// 無し
#define		@26a	26a0		// 頷き
#define		@26b	26b0		// お辞儀
#define		@26c	26c0		// プルプル（怒り、震えetc）
#define		@26d	26d0		// 驚き（飛び上がる）
#define		@26e	26e0		// 驚き（上下にビクビクッ）
#define		@26f	26f0		// 喜び（バンザイ）
#define		@26g	26g0		// 主張（ピョンピョン）
#define		@26h	26h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@26i	26i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@26j	26j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@26k	26k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@26l	26l0		// 地団駄
#define		@26m	26m0		// 息切れ（しこたま殴った後とか
#define		@26n	26n0		// 軽いスクワット的な喜び？
#define		@26o	26o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@26p	26p0		// フラフラ
#define		@26q	26q0		// 弾む感じで上下に揺れる
#define		@26r	26r0		// テレテレ
#define		@26s	26s0		// デコピン（小突き的な）
#define		@26t	26t0		// 左回転
#define		@26u	26u0		// 左回転
#define		@26v	26v0		// 
#define		@26w	26w0		// 
#define		@26x	26x0		// 
#define		@26y	26y0		// 
#define		@26z	26z0		// 
// ～♪・左
#define		@27		2700		// 無し
#define		@27a	27a0		// 頷き
#define		@27b	27b0		// お辞儀
#define		@27c	27c0		// プルプル（怒り、震えetc）
#define		@27d	27d0		// 驚き（飛び上がる）
#define		@27e	27e0		// 驚き（上下にビクビクッ）
#define		@27f	27f0		// 喜び（バンザイ）
#define		@27g	27g0		// 主張（ピョンピョン）
#define		@27h	27h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@27i	27i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@27j	27j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@27k	27k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@27l	27l0		// 地団駄
#define		@27m	27m0		// 息切れ（しこたま殴った後とか
#define		@27n	27n0		// 軽いスクワット的な喜び？
#define		@27o	27o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@27p	27p0		// フラフラ
#define		@27q	27q0		// 弾む感じで上下に揺れる
#define		@27r	27r0		// テレテレ
#define		@27s	27s0		// デコピン（小突き的な）
#define		@27t	27t0		// 左回転
#define		@27u	27u0		// 左回転
#define		@27v	27v0		// 
#define		@27w	27w0		// 
#define		@27x	27x0		// 
#define		@27y	27y0		// 
#define		@27z	27z0		// 
// ？
#define		@28		2800		// 無し
#define		@28a	28a0		// 頷き
#define		@28b	28b0		// お辞儀
#define		@28c	28c0		// プルプル（怒り、震えetc）
#define		@28d	28d0		// 驚き（飛び上がる）
#define		@28e	28e0		// 驚き（上下にビクビクッ）
#define		@28f	28f0		// 喜び（バンザイ）
#define		@28g	28g0		// 主張（ピョンピョン）
#define		@28h	28h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@28i	28i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@28j	28j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@28k	28k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@28l	28l0		// 地団駄
#define		@28m	28m0		// 息切れ（しこたま殴った後とか
#define		@28n	28n0		// 軽いスクワット的な喜び？
#define		@28o	28o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@28p	28p0		// フラフラ
#define		@28q	28q0		// 弾む感じで上下に揺れる
#define		@28r	28r0		// テレテレ
#define		@28s	28s0		// デコピン（小突き的な）
#define		@28t	28t0		// 左回転
#define		@28u	28u0		// 左回転
#define		@28v	28v0		// 
#define		@28w	28w0		// 
#define		@28x	28x0		// 
#define		@28y	28y0		// 
#define		@28z	28z0		// 
// キラキラ
#define		@29		2900		// 無し
#define		@29a	29a0		// 頷き
#define		@29b	29b0		// お辞儀
#define		@29c	29c0		// プルプル（怒り、震えetc）
#define		@29d	29d0		// 驚き（飛び上がる）
#define		@29e	29e0		// 驚き（上下にビクビクッ）
#define		@29f	29f0		// 喜び（バンザイ）
#define		@29g	29g0		// 主張（ピョンピョン）
#define		@29h	29h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@29i	29i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@29j	29j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@29k	29k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@29l	29l0		// 地団駄
#define		@29m	29m0		// 息切れ（しこたま殴った後とか
#define		@29n	29n0		// 軽いスクワット的な喜び？
#define		@29o	29o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@29p	29p0		// フラフラ
#define		@29q	29q0		// 弾む感じで上下に揺れる
#define		@29r	29r0		// テレテレ
#define		@29s	29s0		// デコピン（小突き的な）
#define		@29t	29t0		// 左回転
#define		@29u	29u0		// 左回転
#define		@29v	29v0		// 
#define		@29w	29w0		// 
#define		@29x	29x0		// 
#define		@29y	29y0		// 
#define		@29z	29z0		// 
// ぷんすか → =3      0
#define		@30		3000		// 無し
#define		@30a	30a0		// 頷き
#define		@30b	30b0		// お辞儀
#define		@30c	30c0		// プルプル（怒り、震えetc）
#define		@30d	30d0		// 驚き（飛び上がる）
#define		@30e	30e0		// 驚き（上下にビクビクッ）
#define		@30f	30f0		// 喜び（バンザイ）
#define		@30g	30g0		// 主張（ピョンピョン）
#define		@30h	30h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@30i	30i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@30j	30j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@30k	30k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@30l	30l0		// 地団駄
#define		@30m	30m0		// 息切れ（しこたま殴った後とか
#define		@30n	30n0		// 軽いスクワット的な喜び？
#define		@30o	30o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@30p	30p0		// フラフラ
#define		@30q	30q0		// 弾む感じで上下に揺れる
#define		@30r	30r0		// テレテレ
#define		@30s	30s0		// デコピン（小突き的な）
#define		@30t	30t0		// 左回転
#define		@30u	30u0		// 左回転
#define		@30v	30v0		// 
#define		@30w	30w0		// 
#define		@30x	30x0		// 
#define		@30y	30y0		// 
#define		@30z	30z0		// 
// ハート・右
#define		@31		3100		// 無し
#define		@31a	31a0		// 頷き
#define		@31b	31b0		// お辞儀
#define		@31c	31c0		// プルプル（怒り、震えetc）
#define		@31d	31d0		// 驚き（飛び上がる）
#define		@31e	31e0		// 驚き（上下にビクビクッ）
#define		@31f	31f0		// 喜び（バンザイ）
#define		@31g	31g0		// 主張（ピョンピョン）
#define		@31h	31h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@31i	31i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@31j	31j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@31k	31k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@31l	31l0		// 地団駄
#define		@31m	31m0		// 息切れ（しこたま殴った後とか
#define		@31n	31n0		// 軽いスクワット的な喜び？
#define		@31o	31o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@31p	31p0		// フラフラ
#define		@31q	31q0		// 弾む感じで上下に揺れる
#define		@31r	31r0		// テレテレ
#define		@31s	31s0		// デコピン（小突き的な）
#define		@31t	31t0		// 左回転
#define		@31u	31u0		// 左回転
#define		@31v	31v0		// 
#define		@31w	31w0		// 
#define		@31x	31x0		// 
#define		@31y	31y0		// 
#define		@31z	31z0		// 
// ハート・左
#define		@32		3200		// 無し
#define		@32a	32a0		// 頷き
#define		@32b	32b0		// お辞儀
#define		@32c	32c0		// プルプル（怒り、震えetc）
#define		@32d	32d0		// 驚き（飛び上がる）
#define		@32e	32e0		// 驚き（上下にビクビクッ）
#define		@32f	32f0		// 喜び（バンザイ）
#define		@32g	32g0		// 主張（ピョンピョン）
#define		@32h	32h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@32i	32i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@32j	32j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@32k	32k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@32l	32l0		// 地団駄
#define		@32m	32m0		// 息切れ（しこたま殴った後とか
#define		@32n	32n0		// 軽いスクワット的な喜び？
#define		@32o	32o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@32p	32p0		// フラフラ
#define		@32q	32q0		// 弾む感じで上下に揺れる
#define		@32r	32r0		// テレテレ
#define		@32s	32s0		// デコピン（小突き的な）
#define		@32t	32t0		// 左回転
#define		@32u	32u0		// 左回転
#define		@32v	32v0		// 
#define		@32w	32w0		// 
#define		@32x	32x0		// 
#define		@32y	32y0		// 
#define		@32z	32z0		// 
// イライラ・右
#define		@33		3300		// 無し
#define		@33a	33a0		// 頷き
#define		@33b	33b0		// お辞儀
#define		@33c	33c0		// プルプル（怒り、震えetc）
#define		@33d	33d0		// 驚き（飛び上がる）
#define		@33e	33e0		// 驚き（上下にビクビクッ）
#define		@33f	33f0		// 喜び（バンザイ）
#define		@33g	33g0		// 主張（ピョンピョン）
#define		@33h	33h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@33i	33i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@33j	33j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@33k	33k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@33l	33l0		// 地団駄
#define		@33m	33m0		// 息切れ（しこたま殴った後とか
#define		@33n	33n0		// 軽いスクワット的な喜び？
#define		@33o	33o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@33p	33p0		// フラフラ
#define		@33q	33q0		// 弾む感じで上下に揺れる
#define		@33r	33r0		// テレテレ
#define		@33s	33s0		// デコピン（小突き的な）
#define		@33t	33t0		// 左回転
#define		@33u	33u0		// 左回転
#define		@33v	33v0		// 
#define		@33w	33w0		// 
#define		@33x	33x0		// 
#define		@33y	33y0		// 
#define		@33z	33z0		// 
// イライラ・左
#define		@34		3400		// 無し
#define		@34a	34a0		// 頷き
#define		@34b	34b0		// お辞儀
#define		@34c	34c0		// プルプル（怒り、震えetc）
#define		@34d	34d0		// 驚き（飛び上がる）
#define		@34e	34e0		// 驚き（上下にビクビクッ）
#define		@34f	34f0		// 喜び（バンザイ）
#define		@34g	34g0		// 主張（ピョンピョン）
#define		@34h	34h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@34i	34i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@34j	34j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@34k	34k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@34l	34l0		// 地団駄
#define		@34m	34m0		// 息切れ（しこたま殴った後とか
#define		@34n	34n0		// 軽いスクワット的な喜び？
#define		@34o	34o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@34p	34p0		// フラフラ
#define		@34q	34q0		// 弾む感じで上下に揺れる
#define		@34r	34r0		// テレテレ
#define		@34s	34s0		// デコピン（小突き的な）
#define		@34t	34t0		// 左回転
#define		@34u	34u0		// 左回転
#define		@34v	34v0		// 
#define		@34w	34w0		// 
#define		@34x	34x0		// 
#define		@34y	34y0		// 
#define		@34z	34z0		// 
// キラーン・右
#define		@35		3500		// 無し
#define		@35a	35a0		// 頷き
#define		@35b	35b0		// お辞儀
#define		@35c	35c0		// プルプル（怒り、震えetc）
#define		@35d	35d0		// 驚き（飛び上がる）
#define		@35e	35e0		// 驚き（上下にビクビクッ）
#define		@35f	35f0		// 喜び（バンザイ）
#define		@35g	35g0		// 主張（ピョンピョン）
#define		@35h	35h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@35i	35i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@35j	35j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@35k	35k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@35l	35l0		// 地団駄
#define		@35m	35m0		// 息切れ（しこたま殴った後とか
#define		@35n	35n0		// 軽いスクワット的な喜び？
#define		@35o	35o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@35p	35p0		// フラフラ
#define		@35q	35q0		// 弾む感じで上下に揺れる
#define		@35r	35r0		// テレテレ
#define		@35s	35s0		// デコピン（小突き的な）
#define		@35t	35t0		// 左回転
#define		@35u	35u0		// 左回転
#define		@35v	35v0		// 
#define		@35w	35w0		// 
#define		@35x	35x0		// 
#define		@35y	35y0		// 
#define		@35z	35z0		// 
// キラーン・左
#define		@36		3600		// 無し
#define		@36a	36a0		// 頷き
#define		@36b	36b0		// お辞儀
#define		@36c	36c0		// プルプル（怒り、震えetc）
#define		@36d	36d0		// 驚き（飛び上がる）
#define		@36e	36e0		// 驚き（上下にビクビクッ）
#define		@36f	36f0		// 喜び（バンザイ）
#define		@36g	36g0		// 主張（ピョンピョン）
#define		@36h	36h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@36i	36i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@36j	36j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@36k	36k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@36l	36l0		// 地団駄
#define		@36m	36m0		// 息切れ（しこたま殴った後とか
#define		@36n	36n0		// 軽いスクワット的な喜び？
#define		@36o	36o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@36p	36p0		// フラフラ
#define		@36q	36q0		// 弾む感じで上下に揺れる
#define		@36r	36r0		// テレテレ
#define		@36s	36s0		// デコピン（小突き的な）
#define		@36t	36t0		// 左回転
#define		@36u	36u0		// 左回転
#define		@36v	36v0		// 
#define		@36w	36w0		// 
#define		@36x	36x0		// 
#define		@36y	36y0		// 
#define		@36z	36z0		// 
// キラキラ
#define		@37		3700		// 無し
#define		@37a	37a0		// 頷き
#define		@37b	37b0		// お辞儀
#define		@37c	37c0		// プルプル（怒り、震えetc）
#define		@37d	37d0		// 驚き（飛び上がる）
#define		@37e	37e0		// 驚き（上下にビクビクッ）
#define		@37f	37f0		// 喜び（バンザイ）
#define		@37g	37g0		// 主張（ピョンピョン）
#define		@37h	37h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@37i	37i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@37j	37j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@37k	37k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@37l	37l0		// 地団駄
#define		@37m	37m0		// 息切れ（しこたま殴った後とか
#define		@37n	37n0		// 軽いスクワット的な喜び？
#define		@37o	37o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@37p	37p0		// フラフラ
#define		@37q	37q0		// 弾む感じで上下に揺れる
#define		@37r	37r0		// テレテレ
#define		@37s	37s0		// デコピン（小突き的な）
#define		@37t	37t0		// 左回転
#define		@37u	37u0		// 左回転
#define		@37v	37v0		// 
#define		@37w	37w0		// 
#define		@37x	37x0		// 
#define		@37y	37y0		// 
#define		@37z	37z0		// 
// 炎（後ろ）
#define		@38		3800		// 無し
#define		@38a	38a0		// 頷き
#define		@38b	38b0		// お辞儀
#define		@38c	38c0		// プルプル（怒り、震えetc）
#define		@38d	38d0		// 驚き（飛び上がる）
#define		@38e	38e0		// 驚き（上下にビクビクッ）
#define		@38f	38f0		// 喜び（バンザイ）
#define		@38g	38g0		// 主張（ピョンピョン）
#define		@38h	38h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@38i	38i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@38j	38j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@38k	38k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@38l	38l0		// 地団駄
#define		@38m	38m0		// 息切れ（しこたま殴った後とか
#define		@38n	38n0		// 軽いスクワット的な喜び？
#define		@38o	38o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@38p	38p0		// フラフラ
#define		@38q	38q0		// 弾む感じで上下に揺れる
#define		@38r	38r0		// テレテレ
#define		@38s	38s0		// デコピン（小突き的な）
#define		@38t	38t0		// 左回転
#define		@38u	38u0		// 左回転
#define		@38v	38v0		// 
#define		@38w	38w0		// 
#define		@38x	38x0		// 
#define		@38y	38y0		// 
#define		@38z	38z0		// 
// 炎（前面）
#define		@39		3900		// 無し
#define		@39a	39a0		// 頷き
#define		@39b	39b0		// お辞儀
#define		@39c	39c0		// プルプル（怒り、震えetc）
#define		@39d	39d0		// 驚き（飛び上がる）
#define		@39e	39e0		// 驚き（上下にビクビクッ）
#define		@39f	39f0		// 喜び（バンザイ）
#define		@39g	39g0		// 主張（ピョンピョン）
#define		@39h	39h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@39i	39i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@39j	39j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@39k	39k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@39l	39l0		// 地団駄
#define		@39m	39m0		// 息切れ（しこたま殴った後とか
#define		@39n	39n0		// 軽いスクワット的な喜び？
#define		@39o	39o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@39p	39p0		// フラフラ
#define		@39q	39q0		// 弾む感じで上下に揺れる
#define		@39r	39r0		// テレテレ
#define		@39s	39s0		// デコピン（小突き的な）
#define		@39t	39t0		// 左回転
#define		@39u	39u0		// 左回転
#define		@39v	39v0		// 
#define		@39w	39w0		// 
#define		@39x	39x0		// 
#define		@39y	39y0		// 
#define		@39z	39z0		// 
// 青炎（後ろ）
#define		@40		40000		// 無し
#define		@40a	40a00		// 頷き
#define		@40b	40b00		// お辞儀
#define		@40c	40c00		// プルプル（怒り、震えetc）
#define		@40d	40d00		// 驚き（飛び上がる）
#define		@40e	40e00		// 驚き（上下にビクビクッ）
#define		@40f	40f00		// 喜び（バンザイ）
#define		@40g	40g00		// 主張（ピョンピョン）
#define		@40h	40h00		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@40i	40i00		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@40j	40j00		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@40k	40k00		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@40l	40l00		// 地団駄
#define		@40m	40m00		// 息切れ（しこたま殴った後とか
#define		@40n	40n00		// 軽いスクワット的な喜び？
#define		@40o	40o00		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@40p	40p00		// フラフラ
#define		@40q	40q00		// 弾む感じで上下に揺れる
#define		@40r	40r00		// テレテレ
#define		@40s	40s00		// デコピン（小突き的な）
#define		@40t	40t00		// 左回転
#define		@40u	40u00		// 左回転
#define		@40v	40v00		// 
#define		@40w	40w00		// 
#define		@40x	40x00		// 
#define		@40y	40y00		// 
#define		@40z	40z00		// 
// 青炎（前面）
#define		@41		4100		// 無し
#define		@41a	41a0		// 頷き
#define		@41b	41b0		// お辞儀
#define		@41c	41c0		// プルプル（怒り、震えetc）
#define		@41d	41d0		// 驚き（飛び上がる）
#define		@41e	41e0		// 驚き（上下にビクビクッ）
#define		@41f	41f0		// 喜び（バンザイ）
#define		@41g	41g0		// 主張（ピョンピョン）
#define		@41h	41h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@41i	41i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@41j	41j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@41k	41k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@41l	41l0		// 地団駄
#define		@41m	41m0		// 息切れ（しこたま殴った後とか
#define		@41n	41n0		// 軽いスクワット的な喜び？
#define		@41o	41o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@41p	41p0		// フラフラ
#define		@41q	41q0		// 弾む感じで上下に揺れる
#define		@41r	41r0		// テレテレ
#define		@41s	41s0		// デコピン（小突き的な）
#define		@41t	41t0		// 左回転
#define		@41u	41u0		// 左回転
#define		@41v	41v0		// 
#define		@41w	41w0		// 
#define		@41x	41x0		// 
#define		@41y	41y0		// 
#define		@41z	41z0		// 
// ご機嫌・右（ワンショット）
#define		@42		4200		// 無し
#define		@42a	42a0		// 頷き
#define		@42b	42b0		// お辞儀
#define		@42c	42c0		// プルプル（怒り、震えetc）
#define		@42d	42d0		// 驚き（飛び上がる）
#define		@42e	42e0		// 驚き（上下にビクビクッ）
#define		@42f	42f0		// 喜び（バンザイ）
#define		@42g	42g0		// 主張（ピョンピョン）
#define		@42h	42h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@42i	42i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@42j	42j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@42k	42k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@42l	42l0		// 地団駄
#define		@42m	42m0		// 息切れ（しこたま殴った後とか
#define		@42n	42n0		// 軽いスクワット的な喜び？
#define		@42o	42o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@42p	42p0		// フラフラ
#define		@42q	42q0		// 弾む感じで上下に揺れる
#define		@42r	42r0		// テレテレ
#define		@42s	42s0		// デコピン（小突き的な）
#define		@42t	42t0		// 左回転
#define		@42u	42u0		// 左回転
#define		@42v	42v0		// 
#define		@42w	42w0		// 
#define		@42x	42x0		// 
#define		@42y	42y0		// 
#define		@42z	42z0		// 
// ご機嫌・左（ワンショット）
#define		@43		4300		// 無し
#define		@43a	43a0		// 頷き
#define		@43b	43b0		// お辞儀
#define		@43c	43c0		// プルプル（怒り、震えetc）
#define		@43d	43d0		// 驚き（飛び上がる）
#define		@43e	43e0		// 驚き（上下にビクビクッ）
#define		@43f	43f0		// 喜び（バンザイ）
#define		@43g	43g0		// 主張（ピョンピョン）
#define		@43h	43h0		// 拡大縮小・弱（縮こまる、気合を入れるetc）
#define		@43i	43i0		// 拡大縮小・強（縮こまる、気合を入れるetc）
#define		@43j	43j0		// 縮小拡大・弱（縮こまる、気合を入れるetc）
#define		@43k	43k0		// 縮小拡大・強（縮こまる、気合を入れるetc）
#define		@43l	43l0		// 地団駄
#define		@43m	43m0		// 息切れ（しこたま殴った後とか
#define		@43n	43n0		// 軽いスクワット的な喜び？
#define		@43o	43o0		// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス
#define		@43p	43p0		// フラフラ
#define		@43q	43q0		// 弾む感じで上下に揺れる
#define		@43r	43r0		// テレテレ
#define		@43s	43s0		// デコピン（小突き的な）
#define		@43t	43t0		// 左回転
#define		@43u	43u0		// 左回転
#define		@43v	43v0		// 
#define		@43w	43w0		// 
#define		@43x	43x0		// 
#define		@43y	43y0		// 
#define		@43z	43z0		// 


// ---------------------------------------------------------------
// トーンカーブ制御
// ---------------------------------------------------------------
#define		@時刻管理無効		$tone_admin = @Off
#define		@時刻管理有効		$tone_admin = @On

#property 	$tone_admin : int

// ---------------------------------------------------------------
// 服装一括制御
// ---------------------------------------------------------------
#command	$face_sel(int)
#command	$dress_control(int)
#property	$cha_dress : intlist[50]

#define		@音無服装					$cha_dress[0]
#define		@かなで服装					$cha_dress[1]
#define		@ゆり服装					$cha_dress[2]
#define		@日向服装					$cha_dress[3]
#define		@ユイ服装					$cha_dress[4]
#define		@岩沢服装					$cha_dress[5]
#define		@松下服装					$cha_dress[6]
#define		@野田服装					$cha_dress[7]
#define		@高松服装					$cha_dress[8]
#define		@大山服装					$cha_dress[9]
#define		@藤巻服装					$cha_dress[10]
#define		@ＴＫ服装					$cha_dress[11]
#define		@椎名服装					$cha_dress[12]
#define		@遊佐服装					$cha_dress[13]
#define		@ひさ子服装					$cha_dress[14]
#define		@関根服装					$cha_dress[15]
#define		@入江服装					$cha_dress[16]
#define		@チャー服装					$cha_dress[17]
#define		@竹山服装					$cha_dress[18]
#define		@直井服装					$cha_dress[19]
#define		@フィッシュ斎藤服装			$cha_dress[20]
#define		@五十嵐服装					$cha_dress[21]
#define		@赤目天使１服装				$cha_dress[22]
#define		@赤目天使２服装				$cha_dress[23]

#define		@戦線制服					 0
#define		@戦線制服_シャツ			 1
#define		@戦線制服_帽子				 2
#define		@ＮＰＣ制服					 3
#define		@ＮＰＣ制服_ボロボロ	     4
#define		@ＮＰＣ制服_ユニフォーム	 5
#define		@パジャマ					 6
#define		@ＮＰＣ制服_麦わら帽子		 7
#define		@体操服						 8
#define		@体操服_ジャージ			 9
#define		@体操服_ヘルメット			10
#define		@ＮＰＣ制服_帽子			11
#define		@柔道着						12
#define		@上半身裸					13
#define		@戦線制服_タートルネック	14
#define		@戦線制服_マフラー			15
#define		@制服						16
#define		@制服_包帯					17
#define		@ジャージ					18


