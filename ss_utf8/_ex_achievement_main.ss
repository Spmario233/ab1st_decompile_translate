// ====================================================================
// 実績システム（鈴木）
// ====================================================================



#inc_start
	
	// =======================================
	#define		ACHIEVEMENT_DEBUG_ON			0	// 0:リリース 1:デバッグ
	// =======================================
	
	#property	$initialized_achievement_system
	
	// Zフラグの何番から実績用に使用するか
	#define		ACHIEVEMENT_Z_FLAG_OFFSET		1000
	
	#define		ACHIEVEMENT_RANK_PLATINUM		1
	#define		ACHIEVEMENT_RANK_GOLD			2
	#define		ACHIEVEMENT_RANK_SILVER			3
	#define		ACHIEVEMENT_RANK_BRONZE			4
	#define		ACHIEVEMENT_RANK_HINT			5
	#define		ACHIEVEMENT_RANK_FOOD			6
	
	// フラグの種類
	#define		F_FLAG							1
	#define		G_FLAG							2
	
	// al ... achievement list
	//#property	$al_zid : intlist
	//#property	$al_rnk : intlist
	//#property	$al_did : intlist
	//#property	$al_fty : intlist
	//#property	$al_fid : intlist
	//#property	$al_mes : strlist
	//#property	$al_det : strlist
	
	
	
	// =======================================
	// エフェクト系
	
	// AER ... Achievement Effect Root
	#define		@OBJ_AER						@OBJ_EF_SCREEN14
	#define		@AE_LAYER					200000			// フェード用のレイヤー値が100000なのでそれ以上に
	
	#define		@AE_FA_TIME					3000			// フレームアクション全体の時間
	#define		@AE_FA_TIME_FOR_NEXT_CALL	500+@AE_FA_TIME	// 次のエフェクトを呼び出すまでの時間
	#define		@AE_FA_TR255_END_TIME		500			// tr値が255になるまでの時間
	#define		@AE_FA_TR0_START_TIME		2500			// tr値が255から0になるときの開始時間
	#define		@AE_FA_TR0_END_TIME			3000			// tr値が255から0になるときの終了時間
	
	#define		@AE_FONT_SIZE 				12			// フォントサイズ
	
	#define		@AE_STR_CUT					45			// エフェクト表示時何文字で切り落とすか
	#define		@AE_STR_CUT_REPLACE			"…"		// 切り落とした時の置換文字
	
	#define		@AER_PX						1280
	#define		@AER_PY						0
	
	#define		@AE_TYPE_JUDGE_STR_COUNT	30
	
	
	#define		@AE_STATIC_STR				"レコードを獲得しました"		// 獲得時に固定で出す文字列
	#define		@AE_STATIC_HINT_STR			"レコードを獲得しました"	// 獲得時に固定で出す文字列（ヒント実績）
	
	#define		@AE_IS_RUNNING				0			// エフェクトの実行中かどうか（汎用フラグ要素番号）
	
	#property	$effect_reserve_list : intlist
	
	
	
#inc_end

#z00



//-----------------------------------------------------------------
// グローバル系
//-----------------------------------------------------------------
// 実績システムの初期化
command $$initialize_achievement_system() {
	
	if(@trial_check()){ return(0) }		//体験版時は表示しない
	
	// エフェクト予約リスト初期化
	$init_effect_reserve_list()
	
	// 実績リスト系変数の初期化
	$init_al_property()
	
	
	// ここはDBから読み込みにした方がいい？
	// Grep確認で抜けやすくなるので残念ながらベタ書きの方が安全
	
	
	
	// 実績システム用構造体もどき
	// 登録ID（グローバルフラグと連動するのでデータ追加あってもずらしちゃダメ、必ず後ろに追加）
	// ランク（金銀銅的な）
	// 表示用ID（データ追加時に入れ替えOK）
	// 表示用メッセージ（いつでも変えてOK）
	// 対象のFフラグの番号（F以外でもやるならフラグタイプの引数がいる）
	
	// 長ったらしいので
	property $_p	$_p = ACHIEVEMENT_RANK_PLATINUM
	property $_g	$_g = ACHIEVEMENT_RANK_GOLD
	property $_s	$_s = ACHIEVEMENT_RANK_SILVER
	property $_b	$_b = ACHIEVEMENT_RANK_BRONZE
	property $_h	$_h = ACHIEVEMENT_RANK_HINT
	property $_f	$_f = ACHIEVEMENT_RANK_FOOD
	
	
	property $array_idx
	$array_idx = 0
	
	property $zfo	// Zフラグオフセット
	$zfo = ACHIEVEMENT_Z_FLAG_OFFSET	// 指定値からスタート
	property $dio	// 表示順オフセット
	$dio = 1		// 1番からスタート
	
	
	
	/*
	// array_idx, z_flag_idx, rank, display_id, target_flag_type, target_flag_idx, display_message, display_detail
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, G_FLAG, 0005, "1st beat 1st boot", "")	// @1stboot
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, G_FLAG, 0000, "ユイルートをクリアした", "")	// @ユイルートクリアした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, G_FLAG, 0001, "岩沢ルートをクリアした", "")	// @岩沢ルートクリアした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, G_FLAG, 0002, "松下ルートをクリアした", "")	// @松下ルートクリアした
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, G_FLAG, 0007, "to be continued を見た", "")	// @１巻クリアした
	
	// ちゃんと登録するフラグが決まったなら$array_idx等は使わずに下記のように登録するのが正しい
	//$add_achievement_to_list(0, 1234, $_b, 124, F_FLAG, 0157, "松下の柔道遠慮した", "痛そうだしご遠慮願いたい")	// @松下の柔道遠慮した
	
	
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0101, "", "")	// @
	
	
	// 音無初日アダ名
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0115, "クソ坊主と呼ばれた", "")	// @クソ坊主
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0116, "代理人と呼ばれた", "")	// @代理人
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0117, "微妙すぎるイケメンと呼ばれた", "")	// @微妙すぎるイケメン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0118, "ロリコンと呼ばれた", "")	// @ロリコン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0119, "メガネ仲間と呼ばれた", "")	// @メガネ仲間
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0120, "暗算日本記録保持者と呼ばれた", "")	// @暗算日本記録保持者
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0121, "通り魔と呼ばれた", "")	// @通り魔
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0122, "記憶ナシ男と呼ばれた", "")	// @記憶ナシ男
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0124, "音速と呼ばれた", "")	// @音速
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0125, "音無と呼ばれた", "")	// @音無
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0126, "無限と呼ばれた", "")	// @無限
	
	// 音無アダ名
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0179, "糞虫と呼ばれた", "")	// @音無を糞虫と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0180, "ゼウスと呼ばれた", "")	// @音無をゼウスと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0181, "日向markⅡと呼ばれた", "")	// @音無を日向markⅡと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0182, "エロエロ団ナンバー１と呼ばれた", "")	// @音無をエロエロ団ナンバー１と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0183, "ただのエロ少年と呼ばれた", "")	// @音無をただのエロ少年と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0352, "エロ侍と呼ばれた", "")	// @音無をエロ侍と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0402, "ユリブサイクと呼ばれた", "")	// @音無をユリブサイクと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0412, "アメリカンエロドッグと呼ばれた", "")	// @音無をアメリカンエロドッグと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0596, "量産型日向と呼ばれた", "")	// @音無を量産型日向と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0743, "エロいのは重々承知だがと付けて貰った", "")	// @エロいのは重々承知だがと付ける
	
	// 音無他
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0463, "両刀使い疑惑が浮かんだ", "")	// @AB06音無両刀使いと疑問覚える
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0410, "犬の格好をした", "")	// @犬の格好のまま
	
	// 日向
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0353, "エロエロ団総帥", "")	// @日向をエロエロ団総帥と呼ぶことに
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0354, "日向のイケチンを見た", "")	// @日向のイケチン見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0629, "日向をひなチンと呼んだ", "")	// @日向をひなチンと呼ぶことに
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0745, "秀樹", "")	// @日向を秀樹と呼ぶ	// なくなったので実績からも消滅
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1092, "イケヒップ日向", "")	// @日向はイケてるお尻の持ち主
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1091, "イケハート日向", "")	// @日向はイケてる心の持ち主
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1122, "日向がゆりにボコられた", "")	// @日向がゆりにボコられた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1128, "さらに日向がゆりにボコられた", "")	// @さらに日向がゆりにボコられた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0687, "日向の目をつぶした", "")	// @AB11日向目が見えない
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1071, "日向の食券トラップを暴いた", "")	// @朝食のチケットは平等
	// キャッキャウフフ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1178, "風呂場でキャッキャウフフした", "")	// @風呂場でキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1179, "食堂でキャッキャウフフした", "")	// @食堂でキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1180, "独り立ちでキャッキャウフフした", "")	// @独り立ちでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1181, "肩をぶつけ合ってキャッキャウフフした", "")	// @肩をぶつけ合ってキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1182, "医学書絡みでキャッキャウフフした", "")	// @医学書絡みでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1183, "感謝しつつキャッキャウフフした", "")	// @感謝しつつキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1184, "イケハートとキャッキャウフフした", "")	// @イケハートとキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1185, "もぐもぐキャッキャウフフした", "")	// @もぐもぐキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1186, "チェンジアップ習得してキャッキャウフフした", "")	// @チェンジアップ習得してキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1187, "本気の思いでキャッキャウフフした", "")	// @本気の思いでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1188, "球技大会中にキャッキャウフフした", "")	// @球技大会中にキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1189, "くるくる回りながらキャッキャウフフした", "")	// @くるくる回りながらキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1190, "ボクシングごっこでキャッキャウフフした", "")	// @ボクシングごっこでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1191, "日向を褒めてキャッキャウフフした", "")	// @日向を褒めてキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1192, "噛みつきながらキャッキャウフフした", "")	// @噛みつきながらキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1193, "おにぎりでキャッキャウフフした", "")	// @おにぎりでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1194, "日向のフォローしてキャッキャウフフした", "")	// @日向のフォローしてキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1195, "ゲップからキャッキャウフフした", "")	// @ゲップからキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1196, "クエイクなキャッキャウフフした", "")	// @クエイクなキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1197, "トンカツでキャッキャウフフした", "")	// @トンカツでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1198, "カレーとお茶を浴びながらキャッキャウフフした", "")	// @カレーとお茶を浴びながらキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1199, "久しぶりにキャッキャウフフした", "")	// @久しぶりにキャッキャウフフした
	
	
	// 野田
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0444, "野田をイケパイと呼んだ", "")	// @野田をイケパイと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0441, "野田とのフラグが立った", "")	// @野田とのフラグがちょっと立つ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0189, "野田とのフラグがすごく立った", "")	// @野田とのフラグがすごく立つ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0586, "野田と友達になった", "")	// @野田と友達になる
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1176, "野田を泣かした", "")	// @野田を泣かした
	
	// 藤巻
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0929, "藤巻と昼食を食べた", "")	// @藤巻と昼食を食べた
	// ↑はギルド系フラグと食べ物で補完できるので消滅
	
	// TK
	// ギルドのやつはギルド系へ
	
	// 松下
	// 球技大会のやつは球技大会系へ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0159, "松下にダイエットを勧めた", "")	// @松下山ごもりに
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1123, "松下が痩せた", "")	// @松下が痩せた
	
	// 遊佐
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1090, "遊佐っぺを見た", "")	// @遊佐がゆりのモノマネをした
	
	// ユイ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0485, "日向の代わりにユイに卍固めをした", "")	// @音無ユイに卍固めした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0952, "ユイに音無様と言わせた", "")	// @ユイに音無様と言わせる
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0953, "ユイにご主人様と言わせた", "")	// @ユイにご主人様と言わせる
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0954, "ユイにお兄ちゃんと言わせた", "")	// @ユイにお兄ちゃんと言わせる
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0958, "ユイの胸を揉んだ", "")	// @１３日_ユイの胸を揉んだ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1121, "ユイの尻を揉んだ", "")	// @ユイの尻を揉んだ
	
	// かなで
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0326, "天使がノリツッコミした", "")	// @天使戦ノリツッコミ聞いた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0368, "天使を撃ってダメージを与えた", "")	// @戦って天使のお腹に当たった
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1095, "呆然としている天使を見た", "")	// @かなで呆然と立ちつくす
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0206, "かなででＨなことを想像した", "")	// @かなでとＨなこと想像した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1094, "またかなででＨなことを想像した", "")	// @松下ルートかなでとＨなこと想像した
	
	// ゆり
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0608, "ゆりと喧嘩別れした", "")	// @ゆりと喧嘩別れして退室
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1065, "ゆりに襲いかかって返り討ちにあった", "")	// @ゆりに撃たれた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1126, "ゆりを全面的に支持した", "")	// @ゆりを全面的に支持した
	// ↑はとりあえず一箇所で立てたけど複数箇所で立てた方がいいかもしれない
	// ギルドで胸を揉むはギルド系へ
	
	// 岩沢
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0292, "岩沢と間接キスをした", "")	// @岩沢と話して間接キスした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1110, "岩沢とひさ子のいけない想像をした", "")	// @岩沢とひさ子のいけない想像をした
	
	// ひさ子
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1124, "ひさ子に２回連続で殴られた", "")	// @ひさ子に２回連続で殴られた
	
	// 入江
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1109, "入江が貧乳だと知った", "")	// @入江が貧乳だと知った
	
	
	// to be continued系
	// ｎ回目授業を受けた系１個
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0383, "高松と心をかよわせた", "")	// @ロンパ大山は高松が岩沢が消えたことを目の当たりにしている
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0144, "戦線と天使の因縁を知った", "")	// @０１日天使の脅威納得した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0852, "天使が人間だと知った", "")	// @かなでが人間だと知った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0842, "ゆりの言質をとった", "")	// @ロンパゆりが天使が人間だと肯定する約束した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0380, "天使の特殊能力の謎に迫った", "")	// @天使はＡＰを使っている
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0260, "銃の作製方法を知った", "")	// @土くれから銃を作れること知った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_h, $array_idx+$dio, F_FLAG, 0263, "人間に生まれかわることを知った", "")	// @人間に生まれかわることを知った
	
	
	// BADエンド系
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0979, "野球部", "")	// @野球部に入った
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0983, "陸上部", "")	// @陸上部に入った
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0980, "コンピューター部", "")	// @コンピューター部に入った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0976, "ゆりを襲い続けて除名された", "")	// @ゆりを襲い続け除名
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0623, "ゆりにキスしようとして除名された", "")	// @ゆりにキスしようとして除名
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1102, "日向の腕の中でこの世界から去った", "")	// @日向の腕の中でこの世界から去った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1103, "直井の催眠術でこの世界から去った", "")	// @直井の催眠術でこの世界から去った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1104, "分身天使に世界を支配された", "")	// @分身天使に世界を支配された
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1105, "直井とルームメイトになった", "")	// @直井とルームメイトになった
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1118, "お魚バーベキューをした", "")	// @お魚バーベキューをした
	
	
	// 球技大会
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0526, "球技大会で優勝した", "")	// @球技大会優勝
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1093, "球技大会ガルデモチームで勝利した", "")	// @球技大会ガルデモチームで勝利した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0483, "球技大会バスケで優勝した", "")	// @バスケに参戦して優勝
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0872, "チェンジアップ習得", "")	// @チェンジアップ会得した
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0501, "フォーク習得", "")	// @球技大会フォークを覚えた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1099, "球技大会松下が参戦した", "")	// @球技大会松下参戦
	
	// 図書館
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0703, "やるっきゃ内藤さんを読破した", "")	// @AB11やるっきゃ内藤さんを読み終えた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0704, "斉藤一族を読破した", "")	// @AB11斉藤一族を読み終えた
	
	// ギルド降下作戦
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0273, "ギルド降下作戦を完遂した", "")	// @ギルド降下作戦で生き残った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1089, "ギルド降下作戦・ＴＫとリタイア", "")	// @ギルド降下作戦でＴＫを手伝った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1106, "ギルド降下作戦・大玉でリタイア", "")	// @ギルド降下作戦大玉でリタイア
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1107, "ギルド降下作戦・切断されてリタイア", "")	// @ギルド降下作戦切断されてリタイア
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1108, "ギルド降下作戦・藤巻とリタイア", "")	// @ギルド降下作戦藤巻とリタイア
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0250, "ゆりの胸を揉んだ", "")	// @ギルド胸を揉んで落とされた
	
	// テスト
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0649, "大山の告白が成功した", "")	// @大山の告白成功した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1096, "入江の告白が成功した", "")	// @入江の告白作戦成功した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0637, "神と怪獣の戦いを実況した", "")	// @AB09神と怪獣の戦い実況した
	
	// 反省室
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1112, "日向と添い寝をした", "")	// @日向と添い寝をした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1113, "野田と添い寝をした", "")	// @野田と添い寝をした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1114, "ゆりに夜這いをした", "")	// @ゆりに夜這いをした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1115, "岩沢に夜這いをした", "")	// @岩沢に夜這いをした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1116, "ひさ子に夜這いをした", "")	// @ひさ子に夜這いをした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1117, "ロリコンをカミングアウトした", "")	// @ロリコンをカミングアウトした
	
	// モンスト後
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1119, "かなで・日向との三角関係", "")	// @かなでと音無と日向の三角関係
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1120, "かなで・野田との三角関係", "")	// @かなでと音無と野田の三角関係
	
	
	// 他
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0579, "日向・野田との三角関係", "")	// @音無日向野田歯が飛んで喋れない
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0642, "百合属性をカミングアウトした", "")	// @百合属性あり
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0900, "百合属性さらにあり", "")	// @百合属性さらにあり
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1098, "ぶよぶよラーメンの説明をした", "")	// @ゆりにぶよラーの詳細を説明
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0135, "０１日ひとりで行動", "")	// @０１日ひとりで行動
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1111, "この世界で風邪をひいた", "")	// @この世界で風邪をひいた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 1127, "影と遭遇した", "")	// @影と遭遇した
	
	// 以下、チェック側未実装
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0318, "三回目も日向についていく", "")	// @三回目も日向についていく
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0221, "かなでこの子は馬鹿", "")	// @かなでこの子は馬鹿
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0241, "降下作戦に参加しなかった", "")	// @降下作戦に参加しなかった
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0247, "音無の足が逆", "")	// @音無の足が逆
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0495, "一回日向に血を飛ばしている", "")	// @一回日向に血を飛ばしている
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0682, "営業マン頼み成功した", "")	// @営業マン頼み成功した
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_b, $array_idx+$dio, F_FLAG, 0830, "無事天使の本体を確保", "")	// @無事天使の本体を確保
	
	
	// 食べ物系
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1132, "肉うどんを食べた", "")	// @食券肉うどん
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1133, "麻婆豆腐を食べた", "")	// @食券麻婆豆腐
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1134, "トンカツ定食を食べた", "")	// @食券トンカツ定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1135, "カツカレーを食べた", "")	// @食券カツカレー
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1136, "味噌カツ丼を食べた", "")	// @食券味噌カツ丼
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1137, "マルゲリータピザを食べた", "")	// @食券マルゲリータピザ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1138, "朝定食Ａを食べた", "")	// @食券朝定食Ａ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1139, "朝定食Ｂを食べた", "")	// @食券朝定食Ｂ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1140, "ミックスグリル定食を食べた", "")	// @食券ミックスグリル定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1141, "ステーキ＆ハンバーグコンボ定食を食べた", "")	// @食券ステーキ＆ハンバーグコンボ定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1142, "イングリッシュマフィンを食べた", "")	// @食券イングリッシュマフィン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1143, "うどんを食べた", "")	// @食券うどん
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1144, "皿うどんを食べた", "")	// @食券皿うどん
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1145, "餃子定食を食べた", "")	// @食券餃子定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1146, "うな重を食べた", "")	// @食券うな重
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1147, "秋刀魚塩焼き定食を食べた", "")	// @食券秋刀魚塩焼き定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1148, "にゅうめんを食べた", "")	// @食券にゅうめん
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1149, "トンテキ定食を食べた", "")	// @食券トンテキ定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1150, "トムヤムカレーを食べた", "")	// @食券トムヤムカレー
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1151, "揚げ臭豆腐定食を食べた", "")	// @食券揚げ臭豆腐定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1152, "塩ラーメンを食べた", "")	// @食券塩ラーメン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1153, "醤油ラーメンを食べた", "")	// @食券醤油ラーメン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1154, "味噌ラーメンを食べた", "")	// @食券味噌ラーメン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1155, "唐揚げ定食を食べた", "")	// @食券唐揚げ定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1156, "オムレツセットを食べた", "")	// @食券オムレツセット
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1157, "チーズインハンバーグ定食を食べた", "")	// @食券チーズインハンバーグ定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1158, "ＢＬＴサンドイッチを食べた", "")	// @食券ＢＬＴサンドイッチ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1159, "フライドポテトを食べた", "")	// @食券フライドポテト
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1160, "豚角煮定食を食べた", "")	// @食券豚角煮定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1161, "ソースカツ丼を食べた", "")	// @食券ソースカツ丼
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1162, "ゴーヤチャンプルー定食を食べた", "")	// @食券ゴーヤチャンプルー定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1163, "朝のキムチ定食を食べた", "")	// @食券朝のキムチ定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1164, "ジンギスカンのモヤシとタマネギを食べた", "")	// @食券ジンギスカンのモヤシとタマネギ
	//$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1165, "酢豚定食を食べた", "")	// @食券酢豚定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1166, "ビーフシチュー定食を食べた", "")	// @食券ビーフシチュー定食
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1167, "フレンチトーストを食べた", "")	// @食券フレンチトースト
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1168, "ほうれん草サラダを食べた", "")	// @食券ほうれん草サラダ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1169, "味噌コーンバターラーメンを食べた", "")	// @食券味噌コーンバターラーメン
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG, 1171, "餃子単品を食べた", "")	// @食券餃子単品
	
	
	// 5.24以降追加
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1202, "トライアングル・キャッキャをした", "")	// @球技大会優勝３人でキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1203, "キャッキャウフフに失敗した", "")	// @キャッキャウフフに失敗した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1204, "はにかむ野田を見た", "")	// @野田から一本を取ってはにかむ姿を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1205, "ネイキッド日向を見た", "")	// @ネイキッド日向を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1206, "ネイキッド松下を見た", "")	// @ネイキッド松下を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1207, "ネイキッド藤巻を見た", "")	// @ネイキッド藤巻を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1208, "ネイキッド大山を見た", "")	// @ネイキッド大山を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1209, "ネイキッド竹山を見た", "")	// @ネイキッド竹山を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1210, "ネイキッド高松を見た", "")	// @ネイキッド高松を見た
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0915, "ユイの言葉で記憶を取り戻した", "")	// @ユイの言葉で最初の記憶を思い出した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1211, "直井の催眠術で記憶を取り戻した", "")	// @直井の催眠術で記憶を取り戻した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1212, "松下を許さなかった", "")	// @松下を許さなかった
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0644, "試験中にカミングアウトした", "")	// @AB09でもカミングアウトした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0736, "みんなの前でカミングアウトした", "")	// @AB13でもカミングアウトした
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0426, "負け犬ＥＮＤ", "")	// @ゆりに気が合って除名
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1213, "ゆりに彼氏宣言をした", "")	// @ゆりに彼氏宣言した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1214, "日向にカボスをそのまま食わせた", "")	// @日向にカボスをそのまま食わせた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1215, "日向に納豆を混ぜずに食わせた", "")	// @日向に納豆を混ぜずに食わせた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1217, "松下はロリコンかもしれない", "")	// @松下はロリコンかもしれない
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1216, "主を釣り上げた", "")	// @主を釣り上げた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0333, "エロそうな漫画を借りた", "")	// @AB04エロそうな漫画込みで５冊借りた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0332, "漫画を借りた", "")	// @AB04漫画５冊借りた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0334, "医学書を借りた", "")	// @AB04医学書を二冊借りる
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0190, "神の首をゆりに渡す覚悟した", "")	// @神の首をゆりに渡す覚悟した
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1218, "神の首の制作に失敗した", "")	// @神の首の制作に失敗した
	
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1219, "ロリコンかもしれないと思った","")	// @ロリコンかもしれないと思った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1220, "ＮＰＣ阿部とルームメイトだった","")	// @ＮＰＣ阿部とルームメイトだった
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1221, "ＮＰＣ山倉と野球チームを組んだ","")	// @ＮＰＣ山倉と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1222, "ＮＰＣ村田と野球チームを組んだ","")	// @ＮＰＣ村田と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1223, "ＮＰＣ川相と野球チームを組んだ","")	// @ＮＰＣ川相と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1224, "ＮＰＣ鈴木と野球チームを組んだ","")	// @ＮＰＣ鈴木と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1225, "ＮＰＣ高橋さんがバスケのチームに入った","")	// @ＮＰＣ高橋さんがバスケのチームに入った
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,1226, "ＮＰＣ手島とルームメイトになった","")	// @ＮＰＣ手島とルームメイトになった
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0256, "ゆりの生前を聞いた","")	// @ギルド降下作戦でゆりの生前聞いた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0274, "チャーの生前を聞いた","")	// @チャーの生前を聞いた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0384, "ひさ子の生前を聞いた","")	// @ひさ子の生前を聞いた
	$array_idx = $add_achievement_to_list($array_idx, $array_idx+$zfo, $_f, $array_idx+$dio, F_FLAG,0543, "日向の生前を聞いた","")	// @日向の生前聞いた
	
	*/
	
	$array_idx = $add_achievement_to_list($array_idx,500, $_f,1, F_FLAG,0125, "音無と呼ばれた", "")	// @音無
	$array_idx = $add_achievement_to_list($array_idx,501, $_f,2, F_FLAG,0115, "クソ坊主と呼ばれた", "")	// @クソ坊主
	$array_idx = $add_achievement_to_list($array_idx,502, $_f,3, F_FLAG,0116, "代理人と呼ばれた", "")	// @代理人
	$array_idx = $add_achievement_to_list($array_idx,503, $_f,4, F_FLAG,0117, "微妙すぎるイケメンと呼ばれた", "")	// @微妙すぎるイケメン
	$array_idx = $add_achievement_to_list($array_idx,504, $_f,5, F_FLAG,0118, "ロリコンと呼ばれた", "")	// @ロリコン
	$array_idx = $add_achievement_to_list($array_idx,505, $_f,6, F_FLAG,0119, "メガネ仲間と呼ばれた", "")	// @メガネ仲間
	$array_idx = $add_achievement_to_list($array_idx,506, $_f,7, F_FLAG,0120, "暗算日本記録保持者と呼ばれた", "")	// @暗算日本記録保持者
	$array_idx = $add_achievement_to_list($array_idx,507, $_f,8, F_FLAG,0121, "通り魔と呼ばれた", "")	// @通り魔
	$array_idx = $add_achievement_to_list($array_idx,508, $_f,9, F_FLAG,0122, "記憶ナシ男と呼ばれた", "")	// @記憶ナシ男
	$array_idx = $add_achievement_to_list($array_idx,509, $_f,10, F_FLAG,0124, "音速と呼ばれた", "")	// @音速
	$array_idx = $add_achievement_to_list($array_idx,510, $_f,11, F_FLAG,0126, "無限と呼ばれた", "")	// @無限
	$array_idx = $add_achievement_to_list($array_idx,511, $_f,12, F_FLAG,0180, "ゼウスと呼ばれた", "")	// @音無をゼウスと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,512, $_f,13, F_FLAG,0179, "糞虫と呼ばれた", "")	// @音無を糞虫と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,513, $_f,14, F_FLAG,0181, "日向MarkⅡと呼ばれた", "")	// @音無を日向markⅡと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,514, $_f,15, F_FLAG,0596, "量産型日向と呼ばれた", "")	// @音無を量産型日向と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,515, $_f,16, F_FLAG,0402, "ユリブサイクと呼ばれた", "")	// @音無をユリブサイクと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,516, $_f,17, F_FLAG,0183, "ただのエロ少年と呼ばれた", "")	// @音無をただのエロ少年と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,517, $_f,18, F_FLAG,0352, "エロ侍と呼ばれた", "")	// @音無をエロ侍と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,518, $_f,19, F_FLAG,0182, "エロエロ団ナンバー１と呼ばれた", "")	// @音無をエロエロ団ナンバー１と呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,519, $_f,20, F_FLAG,0412, "アメリカンエロドッグと呼ばれた", "")	// @音無をアメリカンエロドッグと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,520, $_f,21, F_FLAG,0743, "エロいのは重々承知だがと付けて貰った", "")	// @エロいのは重々承知だがと付ける
	$array_idx = $add_achievement_to_list($array_idx,521, $_f,22, F_FLAG,0354, "日向のイケチンを見た", "")	// @日向のイケチン見た
	$array_idx = $add_achievement_to_list($array_idx,522, $_f,23, F_FLAG,0629, "日向をひなチンと呼んだ", "")	// @日向をひなチンと呼ぶことに
	$array_idx = $add_achievement_to_list($array_idx,523, $_f,24, F_FLAG,1122, "日向がゆりにボコられた", "")	// @日向がゆりにボコられた
	$array_idx = $add_achievement_to_list($array_idx,524, $_f,25, F_FLAG,1128, "日向がさらにゆりにボコられた", "")	// @さらに日向がゆりにボコられた
	$array_idx = $add_achievement_to_list($array_idx,525, $_f,26, F_FLAG,0687, "日向の目をつぶした", "")	// @AB11日向目が見えない
	$array_idx = $add_achievement_to_list($array_idx,526, $_f,27, F_FLAG,1214, "日向にカボスをそのまま食わせた", "")	// @日向にカボスをそのまま食わせた
	$array_idx = $add_achievement_to_list($array_idx,527, $_f,28, F_FLAG,1215, "日向に納豆を混ぜずに食わせた", "")	// @日向に納豆を混ぜずに食わせた
	$array_idx = $add_achievement_to_list($array_idx,528, $_f,29, F_FLAG,1071, "日向の食券トラップを暴いた", "")	// @朝食のチケットは平等
	$array_idx = $add_achievement_to_list($array_idx,529, $_f,30, F_FLAG,0579, "日向・野田との三角関係", "")	// @音無日向野田歯が飛んで喋れない
	$array_idx = $add_achievement_to_list($array_idx,530, $_f,31, F_FLAG,0444, "野田をイケパイと呼んだ", "")	// @野田をイケパイと呼ぶ
	$array_idx = $add_achievement_to_list($array_idx,531, $_f,32, F_FLAG,0441, "野田とのフラグが立った", "")	// @野田とのフラグがちょっと立つ
	$array_idx = $add_achievement_to_list($array_idx,532, $_f,33, F_FLAG,0189, "野田とのフラグがすごく立った", "")	// @野田とのフラグがすごく立つ
	$array_idx = $add_achievement_to_list($array_idx,533, $_f,34, F_FLAG,0586, "野田と友達になった", "")	// @野田と友達になる
	$array_idx = $add_achievement_to_list($array_idx,534, $_f,35, F_FLAG,1204, "野田のはにかむ姿を見た", "")	// @野田から一本を取ってはにかむ姿を見た
	$array_idx = $add_achievement_to_list($array_idx,535, $_f,36, F_FLAG,1176, "野田を泣かした", "")	// @野田を泣かした
	$array_idx = $add_achievement_to_list($array_idx,536, $_f,37, F_FLAG,0485, "ユイに卍固めをした", "")	// @音無ユイに卍固めした
	$array_idx = $add_achievement_to_list($array_idx,537, $_f,38, F_FLAG,0952, "ユイに音無様と言わせた", "")	// @ユイに音無様と言わせる
	$array_idx = $add_achievement_to_list($array_idx,538, $_f,39, F_FLAG,0953, "ユイにご主人様と言わせた", "")	// @ユイにご主人様と言わせる
	$array_idx = $add_achievement_to_list($array_idx,539, $_f,40, F_FLAG,0954, "ユイにお兄ちゃんと言わせた", "")	// @ユイにお兄ちゃんと言わせる
	$array_idx = $add_achievement_to_list($array_idx,540, $_f,41, F_FLAG,0608, "ゆりと喧嘩別れした", "")	// @ゆりと喧嘩別れして退室
	$array_idx = $add_achievement_to_list($array_idx,541, $_f,42, F_FLAG,1126, "ゆりを全面的に支持した", "")	// @ゆりを全面的に支持した
	$array_idx = $add_achievement_to_list($array_idx,542, $_f,43, F_FLAG,1065, "ゆりに襲いかかって返り討ちにあった", "")	// @ゆりに撃たれた
	$array_idx = $add_achievement_to_list($array_idx,543, $_f,44, F_FLAG,1213, "ゆりに彼氏宣言をした", "")	// @ゆりに彼氏宣言した
	$array_idx = $add_achievement_to_list($array_idx,544, $_f,45, F_FLAG,0190, "神の首をゆりに渡す覚悟した", "")	// @神の首をゆりに渡す覚悟した
	$array_idx = $add_achievement_to_list($array_idx,545, $_f,46, F_FLAG,1218, "神の首の制作に失敗した", "")	// @神の首の制作に失敗した
	$array_idx = $add_achievement_to_list($array_idx,546, $_f,47, F_FLAG,0410, "犬の格好をした", "")	// @犬の格好のまま
	$array_idx = $add_achievement_to_list($array_idx,547, $_f,48, F_FLAG,1098, "ぶよぶよラーメンの説明をした", "")	// @ゆりにぶよラーの詳細を説明
	$array_idx = $add_achievement_to_list($array_idx,548, $_f,49, F_FLAG,0326, "天使がノリツッコミした", "")	// @天使戦ノリツッコミ聞いた
	$array_idx = $add_achievement_to_list($array_idx,549, $_f,50, F_FLAG,0368, "天使を撃ってダメージを与えた", "")	// @戦って天使のお腹に当たった
	$array_idx = $add_achievement_to_list($array_idx,550, $_f,51, F_FLAG,1095, "天使が呆然としているのを見た", "")	// @かなで呆然と立ちつくす
	$array_idx = $add_achievement_to_list($array_idx,551, $_f,52, F_FLAG,1119, "かなで・日向との三角関係", "")	// @かなでと音無と日向の三角関係
	$array_idx = $add_achievement_to_list($array_idx,552, $_f,53, F_FLAG,1120, "かなで・野田との三角関係", "")	// @かなでと音無と野田の三角関係
	$array_idx = $add_achievement_to_list($array_idx,553, $_f,54, F_FLAG,1212, "松下を許さなかった", "")	// @松下を許さなかった
	$array_idx = $add_achievement_to_list($array_idx,554, $_f,55, F_FLAG,0159, "松下にダイエットを勧めた", "")	// @松下山ごもりに
	$array_idx = $add_achievement_to_list($array_idx,555, $_f,56, F_FLAG,1123, "松下が痩せた", "")	// @松下が痩せた
	$array_idx = $add_achievement_to_list($array_idx,556, $_f,57, F_FLAG,1217, "松下はロリコンかもしれない", "")	// @松下はロリコンかもしれない
	$array_idx = $add_achievement_to_list($array_idx,557, $_f,58, F_FLAG,0292, "岩沢と間接キスをした", "")	// @岩沢と話して間接キスした
	$array_idx = $add_achievement_to_list($array_idx,558, $_f,59, F_FLAG,1227, "野球拳でまだ勝てないと悟った", "")	// @野球拳、今は勝つ事が出来ない
	$array_idx = $add_achievement_to_list($array_idx,559, $_f,60, F_FLAG,1110, "岩沢とひさ子のいけない想像をした", "")	// @岩沢とひさ子のいけない想像をした
	$array_idx = $add_achievement_to_list($array_idx,560, $_f,61, F_FLAG,1124, "ひさ子に２回連続で殴られた", "")	// @ひさ子に２回連続で殴られた
	$array_idx = $add_achievement_to_list($array_idx,561, $_f,62, F_FLAG,1109, "入江が貧乳だと知った", "")	// @入江が貧乳だと知った
	$array_idx = $add_achievement_to_list($array_idx,562, $_f,63, F_FLAG,1090, "遊佐っぺを見た", "")	// @遊佐がゆりのモノマネをした
	$array_idx = $add_achievement_to_list($array_idx,563, $_f,64, F_FLAG,0652, "遊佐のかわりに大山が呼びに来た", "")	// @AB09遊佐に疑惑を抱く
	$array_idx = $add_achievement_to_list($array_idx,564, $_f,65, F_FLAG,1205, "ネイキッド日向を見た", "")	// @ネイキッド日向を見た
	$array_idx = $add_achievement_to_list($array_idx,565, $_f,66, F_FLAG,1206, "ネイキッド松下を見た", "")	// @ネイキッド松下を見た
	$array_idx = $add_achievement_to_list($array_idx,566, $_f,67, F_FLAG,1207, "ネイキッド藤巻を見た", "")	// @ネイキッド藤巻を見た
	$array_idx = $add_achievement_to_list($array_idx,567, $_f,68, F_FLAG,1208, "ネイキッド大山を見た", "")	// @ネイキッド大山を見た
	$array_idx = $add_achievement_to_list($array_idx,568, $_f,69, F_FLAG,1209, "ネイキッド竹山を見た", "")	// @ネイキッド竹山を見た
	$array_idx = $add_achievement_to_list($array_idx,569, $_f,70, F_FLAG,1210, "ネイキッド高松を見た", "")	// @ネイキッド高松を見た
	$array_idx = $add_achievement_to_list($array_idx,570, $_f,71, F_FLAG,0463, "両刀使い疑惑が浮かんだ", "")	// @AB06音無両刀使いと疑問覚える
	$array_idx = $add_achievement_to_list($array_idx,571, $_f,72, F_FLAG,1111, "この世界で風邪をひいた", "")	// @この世界で風邪をひいた
	$array_idx = $add_achievement_to_list($array_idx,572, $_f,73, F_FLAG,1112, "日向と添い寝をした", "")	// @日向と添い寝をした
	$array_idx = $add_achievement_to_list($array_idx,573, $_f,74, F_FLAG,1113, "野田と添い寝をした", "")	// @野田と添い寝をした
	$array_idx = $add_achievement_to_list($array_idx,574, $_f,75, F_FLAG,1114, "ゆりに夜這いをした", "")	// @ゆりに夜這いをした
	$array_idx = $add_achievement_to_list($array_idx,575, $_f,76, F_FLAG,1115, "岩沢に夜這いをした", "")	// @岩沢に夜這いをした
	$array_idx = $add_achievement_to_list($array_idx,576, $_f,77, F_FLAG,1116, "ひさ子に夜這いをした", "")	// @ひさ子に夜這いをした
	$array_idx = $add_achievement_to_list($array_idx,577, $_f,78, F_FLAG,0250, "ゆりの胸を揉んだ", "")	// @ギルド胸を揉んで落とされた
	$array_idx = $add_achievement_to_list($array_idx,578, $_f,79, F_FLAG,0958, "ユイの胸を揉んだ", "")	// @１３日_ユイの胸を揉んだ
	$array_idx = $add_achievement_to_list($array_idx,579, $_f,80, F_FLAG,1121, "ユイの尻を揉んだ", "")	// @ユイの尻を揉んだ
	$array_idx = $add_achievement_to_list($array_idx,580, $_f,81, F_FLAG,0206, "かなででＨなことを想像した", "")	// @かなでとＨなこと想像した
	$array_idx = $add_achievement_to_list($array_idx,581, $_f,82, F_FLAG,1094, "またかなででＨなことを想像した", "")	// @松下ルートかなでとＨなこと想像した
	$array_idx = $add_achievement_to_list($array_idx,582, $_f,83, F_FLAG,0644, "試験中にカミングアウトした", "")	// @AB09でもカミングアウトした
	$array_idx = $add_achievement_to_list($array_idx,583, $_f,84, F_FLAG,0736, "みんなの前でカミングアウトした", "")	// @AB13でもカミングアウトした
	$array_idx = $add_achievement_to_list($array_idx,584, $_f,85, F_FLAG,0642, "百合属性をカミングアウトした", "")	// @百合属性あり
	$array_idx = $add_achievement_to_list($array_idx,585, $_f,86, F_FLAG,1117, "ロリコンをカミングアウトした", "")	// @ロリコンをカミングアウトした
	$array_idx = $add_achievement_to_list($array_idx,586, $_f,87, F_FLAG,1219, "ロリコンかもしれないと思った", "")	// @ロリコンかもしれないと思った
	$array_idx = $add_achievement_to_list($array_idx,587, $_f,88, F_FLAG,1178, "風呂場でキャッキャウフフした", "")	// @風呂場でキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,588, $_f,89, F_FLAG,1179, "食堂でキャッキャウフフした", "")	// @食堂でキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,589, $_f,90, F_FLAG,1180, "独り立ちでキャッキャウフフした", "")	// @独り立ちでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,590, $_f,91, F_FLAG,1181, "肩をぶつけ合ってキャッキャウフフした", "")	// @肩をぶつけ合ってキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,591, $_f,92, F_FLAG,1182, "医学書絡みでキャッキャウフフした", "")	// @医学書絡みでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,592, $_f,93, F_FLAG,1183, "感謝しつつキャッキャウフフした", "")	// @感謝しつつキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,593, $_f,94, F_FLAG,1184, "イケハートとキャッキャウフフした", "")	// @イケハートとキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,594, $_f,95, F_FLAG,1185, "もぐもぐキャッキャウフフした", "")	// @もぐもぐキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,595, $_f,96, F_FLAG,1186, "チェンジアップ習得してキャッキャウフフした", "")	// @チェンジアップ習得してキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,596, $_f,97, F_FLAG,1187, "本気の思いでキャッキャウフフした", "")	// @本気の思いでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,597, $_f,98, F_FLAG,1188, "球技大会中にキャッキャウフフした", "")	// @球技大会中にキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,598, $_f,99, F_FLAG,1189, "くるくる回りながらキャッキャウフフした", "")	// @くるくる回りながらキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,599, $_f,100, F_FLAG,1190, "ボクシングごっこでキャッキャウフフした", "")	// @ボクシングごっこでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,600, $_f,101, F_FLAG,1191, "日向を褒めてキャッキャウフフした", "")	// @日向を褒めてキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,601, $_f,102, F_FLAG,1192, "噛みつきながらキャッキャウフフした", "")	// @噛みつきながらキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,602, $_f,103, F_FLAG,1193, "おにぎりでキャッキャウフフした", "")	// @おにぎりでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,603, $_f,104, F_FLAG,1194, "日向のフォローしてキャッキャウフフした", "")	// @日向のフォローしてキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,604, $_f,105, F_FLAG,1195, "ゲップからキャッキャウフフした", "")	// @ゲップからキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,605, $_f,106, F_FLAG,1196, "クエイクなキャッキャウフフした", "")	// @クエイクなキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,606, $_f,107, F_FLAG,1197, "トンカツでキャッキャウフフした", "")	// @トンカツでキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,607, $_f,108, F_FLAG,1198, "カレーとお茶を浴びながらキャッキャウフフした", "")	// @カレーとお茶を浴びながらキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,608, $_f,109, F_FLAG,1199, "久しぶりにキャッキャウフフした", "")	// @久しぶりにキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,609, $_f,110, F_FLAG,1202, "トライアングル・キャッキャをした", "")	// @球技大会優勝３人でキャッキャウフフした
	$array_idx = $add_achievement_to_list($array_idx,610, $_f,111, F_FLAG,1203, "キャッキャウフフに失敗した", "")	// @キャッキャウフフに失敗した
	$array_idx = $add_achievement_to_list($array_idx,611, $_f,112, F_FLAG,1220, "ＮＰＣ阿部とルームメイトだった", "")	// @ＮＰＣ阿部とルームメイトだった
	$array_idx = $add_achievement_to_list($array_idx,612, $_f,113, F_FLAG,1226, "ＮＰＣ手島とルームメイトになった", "")	// @ＮＰＣ手島とルームメイトになった
	$array_idx = $add_achievement_to_list($array_idx,613, $_f,114, F_FLAG,1221, "ＮＰＣ山倉と野球チームを組んだ", "")	// @ＮＰＣ山倉と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx,614, $_f,115, F_FLAG,1222, "ＮＰＣ村田と野球チームを組んだ", "")	// @ＮＰＣ村田と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx,615, $_f,116, F_FLAG,1223, "ＮＰＣ川相と野球チームを組んだ", "")	// @ＮＰＣ川相と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx,616, $_f,117, F_FLAG,1224, "ＮＰＣ鈴木と野球チームを組んだ", "")	// @ＮＰＣ鈴木と野球チームを組んだ
	$array_idx = $add_achievement_to_list($array_idx,617, $_f,118, F_FLAG,1225, "ＮＰＣ高橋さんがバスケのチームに入った", "")	// @ＮＰＣ高橋さんがバスケのチームに入った
	$array_idx = $add_achievement_to_list($array_idx,618, $_f,119, F_FLAG,0332, "漫画を借りた", "")	// @AB04漫画５冊借りた
	$array_idx = $add_achievement_to_list($array_idx,619, $_f,120, F_FLAG,0334, "医学書を借りた", "")	// @AB04医学書を二冊借りる
	$array_idx = $add_achievement_to_list($array_idx,620, $_f,121, F_FLAG,0333, "エロそうな漫画を借りた", "")	// @AB04エロそうな漫画込みで５冊借りた
	$array_idx = $add_achievement_to_list($array_idx,621, $_f,122, F_FLAG,0704, "斉藤一族を読破した", "")	// @AB11斉藤一族を読み終えた
	$array_idx = $add_achievement_to_list($array_idx,622, $_f,123, F_FLAG,0703, "やるっきゃ内藤さんを読破した", "")	// @AB11やるっきゃ内藤さんを読み終えた
	$array_idx = $add_achievement_to_list($array_idx,623, $_f,124, F_FLAG,0601, "トムヤムカレーの虜になった", "")	// @トムヤムカレーの虜となる
	$array_idx = $add_achievement_to_list($array_idx,624, $_f,125, F_FLAG,1132, "肉うどんを食べた", "")	// @食券肉うどん
	$array_idx = $add_achievement_to_list($array_idx,625, $_f,126, F_FLAG,1134, "トンカツ定食を食べた", "")	// @食券トンカツ定食
	$array_idx = $add_achievement_to_list($array_idx,626, $_f,127, F_FLAG,1135, "カツカレーを食べた", "")	// @食券カツカレー
	$array_idx = $add_achievement_to_list($array_idx,627, $_f,128, F_FLAG,1136, "味噌カツ丼を食べた", "")	// @食券味噌カツ丼
	$array_idx = $add_achievement_to_list($array_idx,628, $_f,129, F_FLAG,1137, "マルゲリータピザを食べた", "")	// @食券マルゲリータピザ
	$array_idx = $add_achievement_to_list($array_idx,629, $_f,130, F_FLAG,1138, "朝定食Ａを食べた", "")	// @食券朝定食Ａ
	$array_idx = $add_achievement_to_list($array_idx,630, $_f,131, F_FLAG,1139, "朝定食Ｂを食べた", "")	// @食券朝定食Ｂ
	$array_idx = $add_achievement_to_list($array_idx,631, $_f,132, F_FLAG,1140, "ミックスグリル定食を食べた", "")	// @食券ミックスグリル定食
	$array_idx = $add_achievement_to_list($array_idx,632, $_f,133, F_FLAG,1141, "ステーキ＆ハンバーグコンボ定食を食べた", "")	// @食券ステーキ＆ハンバーグコンボ定食
	$array_idx = $add_achievement_to_list($array_idx,633, $_f,134, F_FLAG,1142, "イングリッシュマフィンを食べた", "")	// @食券イングリッシュマフィン
	$array_idx = $add_achievement_to_list($array_idx,634, $_f,135, F_FLAG,1143, "うどんを食べた", "")	// @食券うどん
	$array_idx = $add_achievement_to_list($array_idx,635, $_f,136, F_FLAG,1144, "皿うどんを食べた", "")	// @食券皿うどん
	$array_idx = $add_achievement_to_list($array_idx,636, $_f,137, F_FLAG,1145, "餃子定食を食べた", "")	// @食券餃子定食
	$array_idx = $add_achievement_to_list($array_idx,637, $_f,138, F_FLAG,1146, "うな重を食べた", "")	// @食券うな重
	$array_idx = $add_achievement_to_list($array_idx,638, $_f,139, F_FLAG,1147, "秋刀魚塩焼き定食を食べた", "")	// @食券秋刀魚塩焼き定食
	$array_idx = $add_achievement_to_list($array_idx,639, $_f,140, F_FLAG,1148, "にゅうめんを食べた", "")	// @食券にゅうめん
	$array_idx = $add_achievement_to_list($array_idx,640, $_f,141, F_FLAG,1149, "トンテキ定食を食べた", "")	// @食券トンテキ定食
	$array_idx = $add_achievement_to_list($array_idx,641, $_f,142, F_FLAG,1150, "トムヤムカレーを食べた", "")	// @食券トムヤムカレー
	$array_idx = $add_achievement_to_list($array_idx,642, $_f,143, F_FLAG,1151, "揚げ臭豆腐定食を食べた", "")	// @食券揚げ臭豆腐定食
	$array_idx = $add_achievement_to_list($array_idx,643, $_f,144, F_FLAG,1152, "塩ラーメンを食べた", "")	// @食券塩ラーメン
	$array_idx = $add_achievement_to_list($array_idx,644, $_f,145, F_FLAG,1153, "醤油ラーメンを食べた", "")	// @食券醤油ラーメン
	$array_idx = $add_achievement_to_list($array_idx,645, $_f,146, F_FLAG,1154, "味噌ラーメンを食べた", "")	// @食券味噌ラーメン
	$array_idx = $add_achievement_to_list($array_idx,646, $_f,147, F_FLAG,1155, "唐揚げ定食を食べた", "")	// @食券唐揚げ定食
	$array_idx = $add_achievement_to_list($array_idx,647, $_f,148, F_FLAG,1156, "オムレツセットを食べた", "")	// @食券オムレツセット
	$array_idx = $add_achievement_to_list($array_idx,648, $_f,149, F_FLAG,1157, "チーズインハンバーグ定食を食べた", "")	// @食券チーズインハンバーグ定食
	$array_idx = $add_achievement_to_list($array_idx,649, $_f,150, F_FLAG,1158, "ＢＬＴサンドイッチを食べた", "")	// @食券ＢＬＴサンドイッチ
	$array_idx = $add_achievement_to_list($array_idx,650, $_f,151, F_FLAG,1159, "フライドポテトを食べた", "")	// @食券フライドポテト
	$array_idx = $add_achievement_to_list($array_idx,651, $_f,152, F_FLAG,1160, "豚角煮定食を食べた", "")	// @食券豚角煮定食
	$array_idx = $add_achievement_to_list($array_idx,652, $_f,153, F_FLAG,1161, "ソースカツ丼を食べた", "")	// @食券ソースカツ丼
	$array_idx = $add_achievement_to_list($array_idx,653, $_f,154, F_FLAG,1162, "ゴーヤチャンプルー定食を食べた", "")	// @食券ゴーヤチャンプルー定食
	$array_idx = $add_achievement_to_list($array_idx,654, $_f,155, F_FLAG,1163, "朝のキムチ定食を食べた", "")	// @食券朝のキムチ定食
	$array_idx = $add_achievement_to_list($array_idx,655, $_f,156, F_FLAG,1164, "ジンギスカンのモヤシとタマネギを食べた", "")	// @食券ジンギスカンのモヤシとタマネギ
	$array_idx = $add_achievement_to_list($array_idx,656, $_f,157, F_FLAG,1166, "ビーフシチュー定食を食べた", "")	// @食券ビーフシチュー定食
	$array_idx = $add_achievement_to_list($array_idx,657, $_f,158, F_FLAG,1167, "フレンチトーストを食べた", "")	// @食券フレンチトースト
	$array_idx = $add_achievement_to_list($array_idx,658, $_f,159, F_FLAG,1168, "ほうれん草サラダを食べた", "")	// @食券ほうれん草サラダ
	$array_idx = $add_achievement_to_list($array_idx,659, $_f,160, F_FLAG,1169, "味噌コーンバターラーメンを食べた", "")	// @食券味噌コーンバターラーメン
	$array_idx = $add_achievement_to_list($array_idx,660, $_f,161, F_FLAG,1171, "餃子単品を食べた", "")	// @食券餃子単品
	$array_idx = $add_achievement_to_list($array_idx,661, $_f,162, F_FLAG,1133, "麻婆豆腐を食べた", "")	// @食券麻婆豆腐
	$array_idx = $add_achievement_to_list($array_idx,662, $_f,163, F_FLAG,1106, "ギルド降下作戦・大玉でリタイア", "")	// @ギルド降下作戦大玉でリタイア
	$array_idx = $add_achievement_to_list($array_idx,663, $_f,164, F_FLAG,1107, "ギルド降下作戦・切断されてリタイア", "")	// @ギルド降下作戦切断されてリタイア
	$array_idx = $add_achievement_to_list($array_idx,664, $_f,165, F_FLAG,1089, "ギルド降下作戦・ＴＫとリタイア", "")	// @ギルド降下作戦でＴＫを手伝った
	$array_idx = $add_achievement_to_list($array_idx,665, $_f,166, F_FLAG,1108, "ギルド降下作戦・藤巻とリタイア", "")	// @ギルド降下作戦藤巻とリタイア
	$array_idx = $add_achievement_to_list($array_idx,666, $_f,167, F_FLAG,0273, "ギルド降下作戦を完遂した", "")	// @ギルド降下作戦で生き残った
	$array_idx = $add_achievement_to_list($array_idx,667, $_f,168, F_FLAG,1099, "球技大会・松下が参戦した", "")	// @球技大会松下参戦
	$array_idx = $add_achievement_to_list($array_idx,668, $_f,169, F_FLAG,1093, "球技大会・ガルデモチームで勝利した", "")	// @球技大会ガルデモチームで勝利した
	$array_idx = $add_achievement_to_list($array_idx,669, $_f,170, F_FLAG,0526, "球技大会の野球で優勝した", "")	// @球技大会優勝
	$array_idx = $add_achievement_to_list($array_idx,670, $_f,171, F_FLAG,0483, "球技大会のバスケで優勝した", "")	// @バスケに参戦して優勝
	$array_idx = $add_achievement_to_list($array_idx,671, $_f,172, F_FLAG,0649, "大山の告白が成功した", "")	// @大山の告白成功した
	$array_idx = $add_achievement_to_list($array_idx,672, $_f,173, F_FLAG,1096, "入江の告白が成功した", "")	// @入江の告白作戦成功した
	$array_idx = $add_achievement_to_list($array_idx,673, $_f,174, F_FLAG,0637, "神と怪獣の戦いを実況した", "")	// @AB09神と怪獣の戦い実況した
	$array_idx = $add_achievement_to_list($array_idx,674, $_f,175, F_FLAG,1216, "主を釣り上げた", "")	// @主を釣り上げた
	$array_idx = $add_achievement_to_list($array_idx,675, $_f,176, F_FLAG,1127, "影と遭遇した", "")	// @影と遭遇した
	$array_idx = $add_achievement_to_list($array_idx,676, $_f,177, F_FLAG,0144, "戦線と天使の因縁を知った", "")	// @０１日天使の脅威納得した
	$array_idx = $add_achievement_to_list($array_idx,677, $_f,178, F_FLAG,0263, "人間に生まれかわることを知った", "")	// @人間に生まれかわることを知った
	$array_idx = $add_achievement_to_list($array_idx,678, $_f,179, F_FLAG,0260, "銃の作製方法を知った", "")	// @土くれから銃を作れること知った
	$array_idx = $add_achievement_to_list($array_idx,679, $_f,180, F_FLAG,0380, "天使の特殊能力の謎に迫った", "")	// @天使はＡＰを使っている
	$array_idx = $add_achievement_to_list($array_idx,680, $_f,181, F_FLAG,0383, "高松と心をかよわせた", "")	// @ロンパ大山は高松が岩沢が消えたことを目の当たりにしている
	$array_idx = $add_achievement_to_list($array_idx,681, $_f,182, F_FLAG,0852, "天使が人間だと知った", "")	// @かなでが人間だと知った
	$array_idx = $add_achievement_to_list($array_idx,682, $_f,183, F_FLAG,0842, "ゆりの言質をとった", "")	// @ロンパゆりが天使が人間だと肯定する約束した
	$array_idx = $add_achievement_to_list($array_idx,683, $_f,184, F_FLAG,0256, "ゆりの生前を聞いた", "")	// @ギルド降下作戦でゆりの生前聞いた
	$array_idx = $add_achievement_to_list($array_idx,684, $_f,185, F_FLAG,0274, "チャーの生前を聞いた", "")	// @チャーの生前を聞いた
	$array_idx = $add_achievement_to_list($array_idx,685, $_f,186, F_FLAG,0543, "日向の生前を聞いた", "")	// @日向の生前聞いた
	$array_idx = $add_achievement_to_list($array_idx,686, $_f,187, F_FLAG,0384, "ひさ子の生前を聞いた", "")	// @ひさ子の生前を聞いた
	$array_idx = $add_achievement_to_list($array_idx,687, $_f,188, F_FLAG,0915, "ユイの言葉で記憶を取り戻した", "")	// @ユイの言葉で最初の記憶を思い出した
	$array_idx = $add_achievement_to_list($array_idx,688, $_f,189, F_FLAG,1211, "直井の催眠術で記憶を取り戻した", "")	// @直井の催眠術で記憶を取り戻した
	$array_idx = $add_achievement_to_list($array_idx,689, $_f,190, F_FLAG,1118, "お魚バーベキューをした", "")	// @お魚バーベキューをした
	$array_idx = $add_achievement_to_list($array_idx,690, $_f,191, F_FLAG,1104, "分身天使に世界を支配された", "")	// @分身天使に世界を支配された
	$array_idx = $add_achievement_to_list($array_idx,691, $_f,192, F_FLAG,0426, "ゆりを諦めなかったら除名された", "")	// @ゆりに気が合って除名
	$array_idx = $add_achievement_to_list($array_idx,692, $_f,193, F_FLAG,0976, "ゆりを襲い続けて除名された", "")	// @ゆりを襲い続け除名
	$array_idx = $add_achievement_to_list($array_idx,693, $_f,194, F_FLAG,0623, "ゆりにキスしようとして除名された", "")	// @ゆりにキスしようとして除名
	$array_idx = $add_achievement_to_list($array_idx,694, $_f,195, F_FLAG,1105, "直井とルームメイトになった", "")	// @直井とルームメイトになった
	$array_idx = $add_achievement_to_list($array_idx,695, $_f,196, F_FLAG,1103, "直井の催眠術でこの世界から去った", "")	// @直井の催眠術でこの世界から去った
	$array_idx = $add_achievement_to_list($array_idx,696, $_f,197, F_FLAG,1102, "日向の腕の中でこの世界から去った", "")	// @日向の腕の中でこの世界から去った
	$array_idx = $add_achievement_to_list($array_idx,697, $_f,198, G_FLAG,0000, "ユイルートをクリアした", "")	// @ユイルートクリアした
	$array_idx = $add_achievement_to_list($array_idx,698, $_f,199, G_FLAG,0001, "岩沢ルートをクリアした", "")	// @岩沢ルートクリアした
	$array_idx = $add_achievement_to_list($array_idx,699, $_f,200, G_FLAG,0002, "松下ルートをクリアした", "")	// @松下ルートクリアした
	
	
	
	//@debug($array_idx)
	
	// 初期化完了
	$initialized_achievement_system = 1
	
	// デバッグ用
//	if(ACHIEVEMENT_DEBUG_ON != 0) {
//		//frame_action_ch[12].start(-1, "$dbg_fa")
//		$dbg_z_flag_reset
//		@実績獲得表示する = @On
//	}
}

// 今回のチェックで解放された数が戻り値
// if(@実績チェック>0)みたいな使い方で解放エフェクト入ったか確認出来る
command $$check_achievement(property $effect_flag_type : int) : int {
	
	if(@trial_check()){ return(0) }		//体験版時は表示しない
	
	// 初期化終わっていない場合
	if($initialized_achievement_system != 1) {
		@実績システム初期化
	}
	
	// 今回の解放数
	property $open_count_this_time : int
	$open_count_this_time = 0
	
	// 引数に特殊表示処理とか入れた方がいいかも？
	// 松下ルート終わってスタート画面直で行った時の処理とか
	
	// チェック処理
	property $i
	property $is_new
	for($i = 0, $i < $al_zid.get_size, $i+=1) {
		$is_new = 0
		// Zフラグインデックスはオフセット値でチェックしてもいいかも
		//if($al_zid[$i] < ACHIEVEMENT_Z_FLAG_OFFSET) { @debug("Zフラグインデックスが範囲外") continue }
		
		//@debug(math.tostr($al_fid[$i]))	// デバッグ表示用
		
		// Zフラグを確認する（既に1なら新規取得の必要はない）
		if(Z[ $al_zid[$i] ] == 1) {
			continue
		}
		
		
		// フラグの種類(FやGなど)に応じて、対象フラグをチェックする
		// 否定形とかF[xxxx]==0で進めるパターンとかは今の所非対応（状況次第で実装する）
		if($al_fty[$i] == F_FLAG) {
			// Fフラグを確認
			if(F[ $al_fid[$i] ] == 1) {
				$is_new = 1
			}
		}
		elseif($al_fty[$i] == G_FLAG) {
			// Gフラグを確認
			if(G[ $al_fid[$i] ] == 1) {
				$is_new = 1
			}
		}
		else {
			@debug("登録されていない種類のフラグです")
		}
		
		
		// 新しく見つかった場合
		if($is_new) {
			// 実績エフェクトがコンフィグ準拠でON、強制表示の場合
			if( ($effect_flag_type == @実績エフェクトコンフィグ準拠 && @実績獲得表示する == @On) || $effect_flag_type == @実績エフェクト強制表示 ) {
				// エフェクトリストに追加
				//@debug($al_mes[$i] + "\n" + $al_det[$i])
				$add_effect_reserve_list($i)
			}
			
			// Zフラグに反映
			Z[ $al_zid[$i] ] = 1		// ★☆テスト時はコメントアウト
			
			// 今回解放したカウント加算
			$open_count_this_time +=1
		}
	}
	
	
	// エフェクト処理
	// 今回1個でも解放されていたら
	if($open_count_this_time > 0) {
		// 実績エフェクトがコンフィグ準拠でON、強制表示の場合
		if( ($effect_flag_type == @実績エフェクトコンフィグ準拠 && @実績獲得表示する == @On) || $effect_flag_type == @実績エフェクト強制表示 ) {
			$change_next_effect()
		}
	}
	
	return($open_count_this_time)
}



// 実績エフェクト強制終了
command $$force_close_achievement_effect() {
	front.object[@OBJ_AER].disp = 0
	front.object[@OBJ_AER].init
	$init_effect_reserve_list
}


// 実績エフェクト実行中かどうか
command $$is_effect_processing() : int {
	property $return_val $return_val = 0
	
	// エフェクト実行中なら次へはいかない
	if(front.object[@OBJ_AER].f.get_size == 0) { front.object[@OBJ_AER].f.resize(1) }	// 念のため
	
	// 画面に表示されているか
	if(front.object[@OBJ_AER].f[@AE_IS_RUNNING] == 1) { 
		$return_val = 1
	}
	// 予約リストに残っていれば実行中扱い
	if($get_al_idx_from_effect_reserve_list() != -1) {
		$return_val = 1
	}
	
	return($return_val)
}

// 実績フラグの値を取得
command $$get_achievement_flag_val(property $flag_id : int) {
	
	// 現状の仕様はfフラグ専用
	
	property $return_val $return_val = 0
	property $al_idx     $al_idx = -1
	property $i
	for($i = 0, $i < $al_fid.get_size, $i+=1) {
		// 引数のフラグ番号と、リストのフラグ値が一致した場合
		if($flag_id == $al_fid[$i]) {
			$al_idx = $i
			break
		}
	}
	
	// al_idxが見つかった場合
	if($al_idx != -1) {
		// Zフラグの状態を見にいく
		$return_val = z[ $al_zid[$al_idx] ]
	}
	
	return($return_val)
}


// ヒント実績の表示
command $$display_hint_achievement(property $flag_id : int, property $effect_flag_type : int) {
	
	if(@trial_check()){ return(0) }		//体験版時は表示しない
	
	// $array_indexからフラグの種類、フラグ番号から表示するか
	// ここではチェックは行わずに、表示だけに特化した方がいいかも
	
	// フラグ番号を検索キーにしてインデックス取得してFフラグか確認、そこから表示用データ取得してエフェクト予約リストに追加
	
	
	property $i
	for($i = 0, $i < $al_fid.get_size, $i+=1) {
		// フラグ番号が一致した場合
		if($flag_id == $al_fid[$i]) {
			// 対象がFフラグなら
			if($al_fty[$i] == F_FLAG) {
				// エフェクト予約リストに追加
				$add_effect_reserve_list($i)
				// 実績エフェクトがコンフィグ準拠でON、強制表示の場合
				if( ($effect_flag_type == @実績エフェクトコンフィグ準拠 && @実績獲得表示する == @On) || $effect_flag_type == @実績エフェクト強制表示 ) {
					$change_next_effect()
				}
				break
			}
		}
	}
	
	
	// ロンパ系専用引数をとって、それに合わせてエフェクト出すだけの方がいい？
	// 使い方的には、以下のような感じ。ただし@実績チェックで表示し忘れがあるとそいつだけ完全非表示になるので注意
	// @ロンパ系=1
	// @実績チェック(@実績エフェクト非表示)	// Zフラグを立てる処理
	// @実績ヒント表示(@@ロンパ系)			// @ロンパ系のやつを表示する処理
	
}

// 実績リストの数を取得する
command $$get_achievement_list_size() : int {
	return($al_zid.get_size)
}


//-----------------------------------------------------------------
// ローカル系
//-----------------------------------------------------------------

// 実績リスト系変数の初期化
command $init_al_property() {
	
	$al_zid.init
	$al_rnk.init
	$al_did.init
	$al_fty.init
	$al_fid.init
	$al_mes.init
	$al_det.init
	
	
}
// リストに実績を追加
command $add_achievement_to_list(
	 property $array_idx : int
	,property $z_flag_idx : int
	,property $rank : int
	,property $display_id : int
	,property $target_flag_type : int
	,property $target_flag_idx : int
	,property $display_message : str
	,property $display_detail : str
) : int {
	// 足りなかったらリサイズ
	if($al_zid.get_size <= $array_idx) { $al_zid.resize($array_idx + 1) }
	if($al_rnk.get_size <= $array_idx) { $al_rnk.resize($array_idx + 1) }
	if($al_did.get_size <= $array_idx) { $al_did.resize($array_idx + 1) }
	if($al_fty.get_size <= $array_idx) { $al_fty.resize($array_idx + 1) }
	if($al_fid.get_size <= $array_idx) { $al_fid.resize($array_idx + 1) }
	if($al_mes.get_size <= $array_idx) { $al_mes.resize($array_idx + 1) }
	if($al_det.get_size <= $array_idx) { $al_det.resize($array_idx + 1) }
	
	$al_zid[$array_idx] = $z_flag_idx
	$al_rnk[$array_idx] = $rank
	$al_did[$array_idx] = $display_id
	$al_fty[$array_idx] = $target_flag_type
	$al_fid[$array_idx] = $target_flag_idx
	$al_mes[$array_idx] = $display_message
	$al_det[$array_idx] = $display_detail
	
	//$al_did[$array_idx] = math.rand(0,1000)
	
	
	$array_idx += 1
	return($array_idx)
}


// エフェクト系

// エフェクト予約リスト初期化
command $init_effect_reserve_list() {
	
	// 初期化
	if($effect_reserve_list.get_size < 100) {
		$effect_reserve_list.resize(100)
	}
	
	property $i
	for($i = 0, $i < $effect_reserve_list.get_size, $i+=1) {
		$effect_reserve_list[$i] = -1
	}
}

// エフェクト予約リストに追加
command $add_effect_reserve_list(property $al_idx) {
	
	property $i
	for($i = 0, $i < $effect_reserve_list.get_size, $i+=1) {
		if($effect_reserve_list[$i] == -1) {
			$effect_reserve_list[$i] = $al_idx
			break
		}
	}
}

// エフェクト予約リストからal_idxの取得
command $get_al_idx_from_effect_reserve_list() : int {
	property $return_val
	$return_val = -1
	
	property $i
	for($i = 0, $i < $effect_reserve_list.get_size, $i+=1) {
		if($effect_reserve_list[$i] != -1) {
			$return_val = $effect_reserve_list[$i]
			break
		}
	}
	
	return($return_val)
}

// エフェクト予約リストから削除
command $remove_effect_reserve_list(property $al_idx) {
	property $i
	for($i = 0, $i < $effect_reserve_list.get_size, $i+=1) {
		if($effect_reserve_list[$i] == $al_idx) {
			$effect_reserve_list[$i] = -1	// 未使用に戻す
			// 重複予約は普通ありえないけど一応全部チェックする
			//break
		}
	}
}

command $start_effect(property $al_idx) {
	
	// まず予約リストから削除
	$remove_effect_reserve_list($al_idx)
	
	// 実績の種類
	property $achievement_rank : int
	$achievement_rank = $al_rnk[ $al_idx ]
	
	// 表示する文字列
	property $disp_str : str
	$disp_str = $al_mes[ $al_idx ]
	
	// 文字数が一定数越えたら「...」とかで省略した方がいいかも
	if($disp_str.len >= @AE_STR_CUT) {
		$disp_str = $disp_str.left_len(@AE_STR_CUT) + @AE_STR_CUT_REPLACE
	}
	
	
	// 親オブジェクトに対する操作
	front.object[@OBJ_AER].init
	front.object[@OBJ_AER].wipe_copy = 1
	front.object[@OBJ_AER].disp = 1
	front.object[@OBJ_AER].layer = @AE_LAYER
	front.object[@OBJ_AER].tr = 0
	front.object[@OBJ_AER].child.resize(3)
	front.object[@OBJ_AER].f.resize(1)
	front.object[@OBJ_AER].f[@AE_IS_RUNNING] = 1
	front.object[@OBJ_AER].set_pos(0, 14)
	
	// 子オブジェクトに対する操作
	// 可変文字
	front.object[@OBJ_AER].child[0].create_string($disp_str, 1, 1280, 28)
	front.object[@OBJ_AER].child[0].set_string_param(@AE_FONT_SIZE, 0, 0, $disp_str.len, 0, 0, 2)
	front.object[@OBJ_AER].child[0].layer = @AE_LAYER + 2
	
	// 固定文字
	property $static_str : str
	$static_str = @AE_STATIC_STR
	if($achievement_rank == ACHIEVEMENT_RANK_HINT) { $static_str = @AE_STATIC_HINT_STR }
	front.object[@OBJ_AER].child[2].create_string($static_str, 1, 1280, 7)
	front.object[@OBJ_AER].child[2].set_string_param(@AE_FONT_SIZE, 0, 0, $static_str.len, 0, 0, 2)
	front.object[@OBJ_AER].child[2].layer = @AE_LAYER + 2
	
	// 中心座標算出
	front.object[@OBJ_AER].child[0].center_x = @AE_FONT_SIZE * ($disp_str.len + 1) / 2
	front.object[@OBJ_AER].child[2].center_x = @AE_FONT_SIZE * ($static_str.len + 1) / 2
	
	// 枠
	if($disp_str.len >= @AE_TYPE_JUDGE_STR_COUNT) {
		front.object[@OBJ_AER].child[1].create(achievement_popup_bg02, 1)
	}
	else {
		front.object[@OBJ_AER].child[1].create(achievement_popup_bg01, 1)
	}
	front.object[@OBJ_AER].child[1].set_pos(@AER_PX, @AER_PY)
	front.object[@OBJ_AER].child[1].layer = @AE_LAYER
	//if($achievement_rank == ACHIEVEMENT_RANK_HINT) { front.object[@OBJ_AER].child[1].color_add_r = 255 }
	
	
	
	// 親のフレームアクションを開始
	front.object[@OBJ_AER].frame_action.start_real(@AE_FA_TIME, "$obj_fa_test")
	// フレームアクションを開始
	//@debug(すたーと)
	frame_action_ch[11].end
	frame_action_ch[11].start_real(@AE_FA_TIME_FOR_NEXT_CALL, "$fa_test")
	
}

// オブジェクトフレームアクション
command $obj_fa_test(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	l[1] = math.timetable(
							l[0], 0, 0, 
							[0, @AE_FA_TR255_END_TIME, 255, 2],
							[@AE_FA_TR0_START_TIME, @AE_FA_TR0_END_TIME, 0, 2]
						)
	$obj.tr = l[1]
	
	// >=で取ると複数回処理が走るので注意、==でも複数回呼ばれるかもなのでオブジェクトフラグ等で一度しかやらないようにした方がいい
	if(l[0] == @AE_FA_TIME) {
		front.object[@OBJ_AER].f[@AE_IS_RUNNING] = 0
	}
}

// フレームアクション
command $fa_test(property $fa : frameaction)
{
	l[0] = $fa.counter.get
	
//	@Days=l[0]
	// >=で取ると複数回処理が走るので注意、==でも複数回呼ばれるかもなのでオブジェクトフラグ等で一度しかやらないようにした方がいい
	if(l[0] >= @AE_FA_TIME_FOR_NEXT_CALL) {
//		@debug(えんど + math.tostr(l[0]))
		$change_next_effect()
	}
}




command $change_next_effect()
{
	// エフェクト実行中なら次へはいかない
	if(front.object[@OBJ_AER].f.get_size == 0) { front.object[@OBJ_AER].f.resize(1) }	// 念のため
	if(front.object[@OBJ_AER].f[@AE_IS_RUNNING] == 1) { 
//		@debug(実行中)
		return
	}
	
	l[0] = $get_al_idx_from_effect_reserve_list()
	// 予約が見つかれば次のエフェクト開始
	if(l[0] != -1) {
		$start_effect(l[0])
	}
}




//////////////////////////////////////////////////////
// デバッグ系
command $dbg_aaaaaa() : int {
	property $i
	for($i = 0, $i < $effect_reserve_list.get_size, $i+=1) {
		if($effect_reserve_list[$i] != -1) {
			@debug(math.tostr($effect_reserve_list[$i]))
		}
	}
}
command $dbg_fa(property $fa : frameaction)
{
	// テンキー+
	if(key[107].on_down) {
		//$change_next_effect()
		@実績チェック
	}
	// テンキー-
	elseif(key[109].on_down) {
		$dbg_aaaaaa()
	}
	// テンキー.
	elseif(key[110].on_down) {
		@debug(math.tostr($get_al_idx_from_effect_reserve_list()))
	}
}
command $dbg_z_flag_reset() {
	property $i
	for($i = 0, $i < $al_zid.get_size, $i+=1) {
		Z[ $al_zid[$i] ] = 0
	}
}
