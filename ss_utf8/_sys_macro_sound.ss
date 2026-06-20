
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//	pcmch 0-15は効果音で使用。16はムービー歌で使用。
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//	※音命令をマクロで置換していたものを、ユーザーコマンドにして、scene.pckが肥大化しないようにしました。

//	※一部命令を追加しました。
//	　　frame_action_chのチャンネルが、最低３つ（BGM×1＋PCMCH×2）、できれば７つ（BGM×1＋PCMCH×6）必要になります。
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//	#FRAME_ACTION_CH.CNT = 16       // フレームアクションチャンネルの個数
//	0～1は使用済み
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

#z00
#inc_start
	//音関係で使う frame_action_ch チャンネルの頭の番号
	//00-15のうちの後ろの7つ＝9-15
	#define		@sound_fa_ch_start	9
	//音関係で frame_action_ch チャンネルをいくつ使うか？
	#define		@sound_fa_ch_count	7
#inc_end

/********************************************************
*														*
*					ＢＧＭ関連							*
*														*
*********************************************************/
//@sound_fa_ch_count は少なくとも1以上でないと、BGM用のframeactionchannelが無い。BGM用に限っては、1以上あれば上限は見なくていい。
//BGMのframeactionchannelのチャンネル番号 = @sound_fa_ch_start

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//音楽をループ演奏（ディレイあり）
command $bgm_play_snddelay(
	  property $$delay_time : int
	, property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
	, property $$bgm_name   : int
) {
	if ((@sound_fa_ch_count >= 1) && ($$delay_time > 0)) {
		$$bgm_snddelay_status = 1	//1:エンドアクション実行OK
		frame_action_ch[@sound_fa_ch_start].start_real($$delay_time, "$bgm_play_snddelay00", $$delay_time, $$name, $$fade_time, $$cross_time, $$bgm_name)
	}
	else {
		$bgm_play($$name, $$fade_time, $$cross_time, $$bgm_name)
	}
}

//$bgm_play_snddelay内部で呼び出す命令
command $bgm_play_snddelay00(
	  property $$fa         : frameaction
	, property $$delay_time : int
	, property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
	, property $$bgm_name   : int
) {
	L[00] = $$fa.counter.get
	if ((L[00] >= $$delay_time) && ($$bgm_snddelay_status == 1)) {	//以下エンドアクション
		$bgm_play($$name, $$fade_time, $$cross_time, $$bgm_name)
		$$bgm_snddelay_status = 0	//0:エンドアクション実行NG
	}
}

// 音楽をループ演奏
command $bgm_play(
	  property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
	, property $$bgm_name   : int	// $$bgm_nameはシステム用
) {
	// 現在なっているＢＧＭ番号を取得
	@BgmNameNoPrev = @BgmNameNo
	// ＢＧＭの番号を取得 0からではない注意
/*
	switch ($$name) {
				case (@[♪タイトル画面]                     ) @BgmNameNo =  1 // bgm_a011
				case (@[♪タイトル画面：Ｃの１小節前から]   ) @BgmNameNo =  1 // bgm_a011_b
				case (@[♪タイトル画面：Ｃの０．３秒前から] ) @BgmNameNo =  1 // bgm_a011_c
				case (@[♪タイトル画面：Ｃから]             ) @BgmNameNo =  1 // bgm_a011_d
				case (@[♪深羽]                             ) @BgmNameNo =  2 // bgm_b011
				case (@[♪旭]                               ) @BgmNameNo =  3 // bgm_b021
				case (@[♪雀]                               ) @BgmNameNo =  4 // bgm_b031
				case (@[♪柚姫]                             ) @BgmNameNo =  5 // bgm_b041
				case (@[♪雲雀]                             ) @BgmNameNo =  6 // bgm_b051
				case (@[♪穏やかな日常（朝）]               ) @BgmNameNo =  7 // bgm_c011
				case (@[♪穏やかな日常（昼）]               ) @BgmNameNo =  8 // bgm_c021
				case (@[♪穏やかな日常（夜）]               ) @BgmNameNo =  9 // bgm_c031
				case (@[♪コメディ（早）]                   ) @BgmNameNo = 10 // bgm_d011
				case (@[♪コメディ（遅）：基本]             ) @BgmNameNo = 11 // bgm_d021
				case (@[♪コメディ（遅）：１Ｂから]         ) @BgmNameNo = 11 // bgm_d021_b
				case (@[♪コメディ（遅）：２Ａから]         ) @BgmNameNo = 11 // bgm_d021_c
				case (@[♪コメディ（遅）：２Ｂから]         ) @BgmNameNo = 11 // bgm_d021_d
				case (@[♪ドタバタ]                         ) @BgmNameNo = 12 // bgm_d031
				case (@[♪日常のある一コマ]                 ) @BgmNameNo = 13 // bgm_d041
				case (@[♪楽しいイベント]                   ) @BgmNameNo = 14 // bgm_d051
				case (@[♪甘い雰囲気：基本]                 ) @BgmNameNo = 15 // bgm_d061
				case (@[♪甘い雰囲気：イントロなし]         ) @BgmNameNo = 15 // bgm_d061_b
				case (@[♪甘い雰囲気：１Ｂから]             ) @BgmNameNo = 15 // bgm_d061_c
				case (@[♪甘い雰囲気：ブリッヂから]         ) @BgmNameNo = 15 // bgm_d061_d
				case (@[♪甘い雰囲気：２Ａから]             ) @BgmNameNo = 15 // bgm_d061_e
				case (@[♪甘い雰囲気：２Ｂ後半から]         ) @BgmNameNo = 15 // bgm_d061_f
				case (@[♪Ｈシーン：基本]                   ) @BgmNameNo = 16 // bgm_d071
				case (@[♪Ｈシーン：イントロなし]           ) @BgmNameNo = 16 // bgm_d071_b
				case (@[♪Ｈシーン：２Ｂから]               ) @BgmNameNo = 16 // bgm_d071_c
				case (@[♪Ｈシーン：２Ｂ後半から]           ) @BgmNameNo = 16 // bgm_d071_d
				case (@[♪温かい雰囲気]                     ) @BgmNameNo = 17 // bgm_d081
				case (@[♪怪しい雰囲気：基本]               ) @BgmNameNo = 18 // bgm_d091
				case (@[♪怪しい雰囲気：１Ａ後半から]       ) @BgmNameNo = 18 // bgm_d091_b
				case (@[♪怪しい雰囲気：１Ｂから]           ) @BgmNameNo = 18 // bgm_d091_c
				case (@[♪怪しい雰囲気：１Ｃから]           ) @BgmNameNo = 18 // bgm_d091_d
				case (@[♪怪しい雰囲気：２Ａから]           ) @BgmNameNo = 18 // bgm_d091_e
				case (@[♪怪しい雰囲気：２Ｂから]           ) @BgmNameNo = 18 // bgm_d091_f
				case (@[♪怪しい雰囲気：２コーラス目のみ]   ) @BgmNameNo = 18 // bgm_d091_g
				case (@[♪怪しい雰囲気：１コーラス目のみ]   ) @BgmNameNo = 18 // bgm_d091_h
				case (@[♪寂しい日常（静か）]               ) @BgmNameNo = 19 // bgm_e011
				case (@[♪寂しい日常（普通）：基本]         ) @BgmNameNo = 20 // bgm_e021
				case (@[♪寂しい日常（普通）：１Ａ後半から] ) @BgmNameNo = 20 // bgm_e021_b
				case (@[♪寂しい日常（普通）：１Ｂから]     ) @BgmNameNo = 20 // bgm_e021_c
				case (@[♪寂しい日常（普通）：１Ｂ後半から] ) @BgmNameNo = 20 // bgm_e021_d
				case (@[♪寂しい日常（普通）：２Ａから]     ) @BgmNameNo = 20 // bgm_e021_e
				case (@[♪違和感]                           ) @BgmNameNo = 21 // bgm_f011
				case (@[♪恐怖：基本]                       ) @BgmNameNo = 22 // bgm_f021
				case (@[♪恐怖：１Ｂから]                   ) @BgmNameNo = 22 // bgm_f021_b
				case (@[♪恐怖：２Ａから]                   ) @BgmNameNo = 22 // bgm_f021_c
				case (@[♪恐怖：２Ｂから]                   ) @BgmNameNo = 22 // bgm_f021_d
				case (@[♪悲しい（弱）：基本]               ) @BgmNameNo = 23 // bgm_f031
				case (@[♪悲しい（弱）：１Ｂから]           ) @BgmNameNo = 23 // bgm_f031_b
				case (@[♪悲しい（弱）：２Ａから]           ) @BgmNameNo = 23 // bgm_f031_c
				case (@[♪悲しい（強）：基本]               ) @BgmNameNo = 24 // bgm_f032
				case (@[♪悲しい（強）：１Ｂから]           ) @BgmNameNo = 24 // bgm_f032_b
				case (@[♪悲しい（強）：２Ａから]           ) @BgmNameNo = 24 // bgm_f032_c
				case (@[♪悲しい（強）：２Ｂから]           ) @BgmNameNo = 24 // bgm_f032_d
				case (@[♪悲しい（強）：１コーラス目のみ]   ) @BgmNameNo = 24 // bgm_f032_e
				case (@[♪悲しい（強）：２コーラス目のみ]   ) @BgmNameNo = 24 // bgm_f032_f
				case (@[♪悲劇の真実]                       ) @BgmNameNo = 25 // bgm_f041
				case (@[♪疾走]                             ) @BgmNameNo = 26 // bgm_f051
				case (@[♪決意]                             ) @BgmNameNo = 27 // bgm_f061
				case (@[♪反撃]                             ) @BgmNameNo = 28 // bgm_f071
				case (@[♪雲雀テーマアレンジ]               ) @BgmNameNo = 29 // bgm_g051
				case (@[♪エンディング]                     ) @BgmNameNo = 30 // bgm_y011
				case (@[♪ＯＰテーマソング：フルコーラス]   ) @BgmNameNo = 31 // bgm_z091
				case (@[♪ＯＰテーマソング：ショート]       ) @BgmNameNo = 31 // bgm_z091s
				case (@[♪深羽ソング：フルコーラス]         ) @BgmNameNo = 32 // bgm_z011
				case (@[♪深羽ソング：ショート]             ) @BgmNameNo = 32 // bgm_z011s
				case (@[♪旭ソング：フルコーラス]           ) @BgmNameNo = 33 // bgm_z021
				case (@[♪旭ソング：ショート]               ) @BgmNameNo = 33 // bgm_z021s
				case (@[♪雀ソング：フルコーラス]           ) @BgmNameNo = 34 // bgm_z031
				case (@[♪雀ソング：ショート]               ) @BgmNameNo = 34 // bgm_z031s
				case (@[♪柚姫ソング：フルコーラス]         ) @BgmNameNo = 35 // bgm_z041
				case (@[♪柚姫ソング：ショート]             ) @BgmNameNo = 35 // bgm_z041s
				case (@[♪汎用挿入歌：フルコーラス]         ) @BgmNameNo = 36 // bgm_z051
				case (@[♪汎用挿入歌：ショート＋インスト]   ) @BgmNameNo = 36 // bgm_z051i
				case (@[♪汎用挿入歌：ショート]             ) @BgmNameNo = 36 // bgm_z051s
				case (@[♪ＥＤテーマソング：フルコーラス]   ) @BgmNameNo = 37 // bgm_z081
				case (@[♪ＥＤテーマソング：ショート]       ) @BgmNameNo = 37 // bgm_z081s
	}
*/
	// ＢＧＭの曲名を表示[Script]
//	$bgm_title_disp

	// 本編中にＢＧＭの曲名を表示しない場合は破棄 内部的には0
	if ($$bgm_name != @On)	{
		@f.obj[@SysBTDisp].init
		@BgmNameNo = @Init
	}

	//命令本体
	if ($$cross_time != -1) {
		bgm.play($$name, $$fade_time, $$cross_time)
	}
	elseif ($$fade_time != -1) {
		bgm.play($$name, $$fade_time)
	}
	else {
		bgm.play($$name)
	}
	// 既聴フラグＯＮ
	bgmtable.set_listen_by_name($$name, @On)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音楽をループ演奏 [システム用]
command $bgm_play_sys(property $$name : str)
{
	//命令本体
	bgm.play($$name)
	//システム用なので既聴フラグは立ちません
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//音楽をワンショット演奏（ディレイあり）
command $bgm_play_oneshot_snddelay(
	  property $$delay_time : int
	, property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
) {
	if ((@sound_fa_ch_count >= 1) && ($$delay_time > 0)) {
		$$bgm_snddelay_status = 1	//1:エンドアクション実行OK
		frame_action_ch[@sound_fa_ch_start].start_real($$delay_time, "$bgm_play_oneshot_snddelay00", $$delay_time, $$name, $$fade_time, $$cross_time)
		//system.debug_write_log("debuglog:フレームアクションが実行された")
	}
	else {
		$bgm_play_oneshot($$name, $$fade_time, $$cross_time)
		//system.debug_write_log("debuglog:フレームアクションの条件を満たさず$bgm_play_oneshotが実行された")
	}
}

//$bgm_play_oneshot_snddelay内部で呼び出す命令
command $bgm_play_oneshot_snddelay00(
	  property $$fa         : frameaction
	, property $$delay_time : int
	, property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
) {
	L[00] = $$fa.counter.get
	if ((L[00] >= $$delay_time) && ($$bgm_snddelay_status == 1)) {
		$bgm_play_oneshot($$name, $$fade_time, $$cross_time)
		$$bgm_snddelay_status = 0	//0:エンドアクション実行NG
		//system.debug_write_log("debuglog:エンドアクションが実行された")
	}
}

// 音楽をワンショット演奏
//ワンショット演奏には曲名表示の処理が入らない
command $bgm_play_oneshot(
	  property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
) {
	//命令本体
	if ($$cross_time != -1) {
		bgm.play_oneshot($$name, $$fade_time, $$cross_time)
		//system.debug_write_log("debuglog:bgm.play_oneshotパラ３つが実行された")
	}
	elseif ($$fade_time != -1) {
		bgm.play_oneshot($$name, $$fade_time)
		//system.debug_write_log("debuglog:bgm.play_oneshotパラ２つが実行された")
	}
	else {
		bgm.play_oneshot($$name)
		//system.debug_write_log("debuglog:bgm.play_oneshotパラ１つが実行された")
	}
	// 既聴フラグＯＮ
	bgmtable.set_listen_by_name($$name, @On)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音楽をワンショット演奏し、音楽が終了するまで待つ
command $bgm_play_wait(
	  property $$name       : str
	, property $$fade_time  : int
	, property $$cross_time : int
) {
	//命令本体
	if ($$cross_time != -1) {
		bgm.play_wait($$name, $$fade_time, $$cross_time)
	}
	elseif ($$fade_time != -1) {
		bgm.play_wait($$name, $$fade_time)
	}
	else {
		bgm.play_wait($$name)
	}
	// 既聴フラグＯＮ
	bgmtable.set_listen_by_name($$name, @On)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//ＢＧＭを停止する（ディレイあり）
command $bgm_stop_snddelay(
	  property $$delay_time : int
	, property $$fade_time  : int
) {
	if ((@sound_fa_ch_count >= 1) && ($$delay_time > 0)) {
		$$bgm_snddelay_status = 1	//1:エンドアクション実行OK
		frame_action_ch[@sound_fa_ch_start].start_real($$delay_time, "$bgm_stop_snddelay00", $$delay_time, $$fade_time)
	}
	else {
		$bgm_stop($$fade_time)
	}
}

//$bgm_stop_snddelay内部で呼び出す命令
command $bgm_stop_snddelay00(
	  property $$fa         : frameaction
	, property $$delay_time : int
	, property $$fade_time  : int
) {
	L[00] = $$fa.counter.get
	if ((L[00] >= $$delay_time) && ($$bgm_snddelay_status == 1)) {
		$bgm_stop($$fade_time)
		$$bgm_snddelay_status = 0	//0:エンドアクション実行NG
	}
}

// ＢＧＭを停止する
command $bgm_stop(property $$fade_time : int)
{
	//命令本体
	if ($$fade_time != -1) {
		bgm.stop($$fade_time)
	}
	else {
		bgm.stop
	}
	// 現在なっているＢＧＭ番号を取得
	@BgmNameNoPrev = @BgmNameNo
	// ＢＧＭタイトルを消去する
	@BgmNameNo = 0
	// ＢＧＭタイトルを消去
//	$bgm_title_erase
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ＢＧＭを停止する [システム用]
command $bgm_stop_sys(property $$fade_time : int)
{
	//命令本体
	if ($$fade_time != -1) {
		bgm.stop($$fade_time)
	}
	else {
		bgm.stop
	}
	//システム用なのでＢＧＭタイトル関連処理無し
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ＢＧＭが終了するのを待つ
command $bgm_wait
{
	//命令本体
	bgm.wait
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ＢＧＭが終了するのを待つ（キースキップ）
command $bgm_wait_key : int
{
	//命令本体
	return(bgm.wait_key)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ＢＧＭのフェードアウトが終了するのを待つ
command $bgm_wait_fade
{
	//命令本体
	bgm.wait_fade
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ＢＧＭのフェードアウトが終了するのを待つ（キースキップ）
command $bgm_wait_fade_key : int
{
	//命令本体
	return(bgm.wait_fade_key)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ＢＧＭの再生状態を取得する
command $bgm_check : int
{
	//命令本体
	return(bgm.check)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを設定する
command $bgm_set_volume(
	  property $$volume : int
	, property $$time   : int
) {
	//命令本体
	if ($$time != -1) {
		bgm.set_volume($$volume, $$time)
	}
	else {
		bgm.set_volume($$volume)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを最大にする
command $bgm_set_volume_max(property $$time : int)
{
	//命令本体
	if ($$time != -1) {
		bgm.set_volume_max($$time)
	}
	else {
		bgm.set_volume_max
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを最小にする
command $bgm_set_volume_min(property $$time : int)
{
	//命令本体
	if ($$time != -1) {
		bgm.set_volume_min($$time)
	}
	else {
		bgm.set_volume_min
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを取得する
//以前のマクロと引数が違うので注意
command $bgm_get_volume : int
{
	//命令本体
	return(bgm.get_volume)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//ループ演奏するＢＧＭを準備する
command $bgm_ready(
	  property $$name          : str
	, property $$fade_out_time : int
) {
	//命令本体
	if ($$fade_out_time != -1) {
		bgm.ready($$name, $$fade_out_time)
	}
	else {
		bgm.ready($$name)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//ワンショット演奏するＢＧＭを準備する
command $bgm_ready_oneshot(
	  property $$name          : str
	, property $$fade_out_time : int
) {
	//命令本体
	if ($$fade_out_time != -1) {
		bgm.ready_oneshot($$name, $$fade_out_time)
	}
	else {
		bgm.ready_oneshot($$name)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//準備したＢＧＭを再生する
command $bgm_resume(property $$fade_in_time : int)
{
	//命令本体
	if ($$fade_in_time != -1) {
		bgm.resume($$fade_in_time)
	}
	else {
		bgm.resume
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//準備したＢＧＭを再生し、音楽が終了するまで待つ
command $bgm_resume_wait(property $$fade_in_time : int)
{
	//命令本体
	if ($$fade_in_time != -1) {
		bgm.resume_wait($$fade_in_time)
	}
	else {
		bgm.resume_wait
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//ＢＧＭ実行の遅延を中断し、コマンドを実行する
command $bgm_snddelay_end
{
	if (@sound_fa_ch_count >= 1) {
		frame_action_ch[@sound_fa_ch_start].end
		//$$bgm_snddelay_status = 0 は $bgm_stop_snddelay00 内部で実行される
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//ＢＧＭを一時停止する
command $bgm_pause(property $$fade_out_time : int)
{
	//命令本体
	if ($$fade_out_time != -1) {
		bgm.pause($$fade_out_time)
	}
	else {
		bgm.pause
	}
}

/********************************************************
*														*
*						音声関連						*
*														*
*********************************************************/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声を再生する
command $koe(
	  property $$koe_no   : int
	, property $$chara_no : int
) {
	//命令本体
	if ($$chara_no != -1) {
		koe($$koe_no, $$chara_no)
	}
	else {
		koe($$koe_no)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声を再生する（再生終了待ち）
command $koe_play_wait(
	  property $$koe_no   : int
	, property $$chara_no : int
) {
	//命令本体
	if ($$chara_no != -1) {
		koe_play_wait($$koe_no, $$chara_no)
	}
	else {
		koe_play_wait($$koe_no)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声を再生する（再生終了待ち、キースキップ）
command $koe_play_wait_key(
	  property $$koe_no   : int
	, property $$chara_no : int
) : int {
	//命令本体
	if ($$chara_no != -1) {
		return( koe_play_wait_key($$koe_no, $$chara_no) )
	}
	else {
		return( koe_play_wait_key($$koe_no) )
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 声を停止する
command $koe_stop
{
	//命令本体
	koe_stop
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 声の再生が終了するのを待つ
command $koe_wait
{
	//命令本体
	koe_wait
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 声の再生が終了するのを待つ（キースキップ）
command $koe_wait_key : int
{
	//命令本体
	return(koe_wait_key)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 声の再生状態を取得する
command $koe_check : int
{
	//命令本体
	return(koe_check)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声のボリュームを設定する
command $koe_set_volume(
	  property $$volume : int
	, property $$time   : int
) {
	//命令本体
	if ($$time != -1) {
		koe_set_volume($$volume, $$time)
	}
	else {
		koe_set_volume($$volume)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声のボリュームを最大に設定する
command $koe_set_volume_max(property $$time : int)
{
	//命令本体
	if ($$time != -1) {
		koe_set_volume_max($$time)
	}
	else {
		koe_set_volume_max
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声のボリュームを最小に設定する
command $koe_set_volume_min(property $$time : int)
{
	//命令本体
	if ($$time != -1) {
		koe_set_volume_min($$time)
	}
	else {
		koe_set_volume_min
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声のボリュームを取得する
//以前のマクロと引数が違うので注意
command $koe_get_volume : int
{
	//命令本体
	return(koe_get_volume)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声を強制的に再生する
command $exkoe(
	  property $$koe_no   : int
	, property $$chara_no : int
) {
	//命令本体
	if ($$chara_no != -1) {
		exkoe($$koe_no, $$chara_no)
	}
	else {
		exkoe($$koe_no)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声を強制的に再生する（再生終了待ち）
command $exkoe_play_wait(
	  property $$koe_no   : int
	, property $$chara_no : int
) {
	//命令本体
	if ($$chara_no != -1) {
		exkoe_play_wait($$koe_no, $$chara_no)
	}
	else {
		exkoe_play_wait($$koe_no)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声を強制的に再生する（再生終了待ち、キースキップ）
command $exkoe_play_wait_key(
	  property $$koe_no   : int
	, property $$chara_no : int
) : int {
	//命令本体
	if ($$chara_no != -1) {
		return( exkoe_play_wait_key($$koe_no, $$chara_no) )
	}
	else {
		return( exkoe_play_wait_key($$koe_no) )
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 音声速度テスト再生用
command $exkoe_sample(
	  property $$koe_no   : int
	, property $$chara_no : int
) {
	//命令本体
	exkoe($$koe_no, $$chara_no, jitan = @On)
}


/********************************************************
*														*
*					効果音関連							*
*														*
*********************************************************/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 効果音を再生する
command $pcm_play(property $$file_name : str)
{
	//命令本体
	pcm.play($$file_name)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 効果音を再生する（エモーション用）
command $pcm_play_emo(
	  property $$file_name  : str
	, property $$delay_time : int
) {
	//命令本体
	if (@EmDispState == @On) {
		if ($$delay_time > 0) {
			//イベント番号00で、汎用チャンネルで鳴らす
			pcmevent[00].start_oneshot (
				 ["s000000n", $$delay_time]  //s000000n=無音１０秒
				,[$$file_name, 0]
			)
		}
		else {
			pcm.play($$file_name)
		}
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 効果音を停止する ※RealLiveと違って効果音チャンネル分は消音されません注意！
command $pcm_stop
{
	//命令本体
	pcm.stop
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//カウントが０以下：BGMも遅延できない
//カウントが１：BGMしか遅延できない
//カウントが２-７：PCMCHが遅延できる
//カウントが８以上：７までに制限する

//@sound_fa_ch_count は少なくとも2以上でないと、PCMCH用のframeactionchannelが無い。
//PCMCHには最大6つ使うので、1(BGM)+6(PCMCH)=7が上限。8以上の場合は7に補正する。
//PCMCHのチャンネル番号($$ch) = 08 ～ (08 + @sound_fa_ch_count - 2) ※最大13
//PCMCHのframeactionchannelのチャンネル番号 = @sound_fa_ch_start + 1 + $$ch-08
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//チャンネルを指定して効果音を再生する（ディレイあり）
command $pcmch_play_snddelay(
	  property $$delay_time : int
	, property $$ch         : int
	, property $$name       : str
	, property $$fade_time  : int
) {
	L[00] = @sound_fa_ch_start
	L[01] = @sound_fa_ch_count
	if (L[01] >= 8) {L[01] = 7}
	if ((L[01] >= 2) && ($$ch >= 08) && ($$ch <= 08 + L[01]-2) && ($$delay_time > 0)) {
		$$pcmch_snddelay_status[$$ch] = 1	//1:エンドアクション実行OK
		frame_action_ch[L[00]+1 + $$ch-08].start_real($$delay_time, "$pcmch_play_snddelay00", $$delay_time, $$ch, $$name, $$fade_time)
	}
	else {
		$pcmch_play($$ch, $$name, $$fade_time)
	}
}

//$pcmch_play_snddelay内部で呼び出す命令
command $pcmch_play_snddelay00(
	  property $$fa         : frameaction
	, property $$delay_time : int
	, property $$ch         : int
	, property $$name       : str
	, property $$fade_time  : int
) {
	L[00] = $$fa.counter.get
	if ((L[00] >= $$delay_time) && ($$pcmch_snddelay_status[$$ch] == 1)) {
		$pcmch_play($$ch, $$name, $$fade_time)
		$$pcmch_snddelay_status[$$ch] = 0	//0:エンドアクション実行NG
	}
}

// チャンネルを指定して効果音を再生する
command $pcmch_play(
	  property $$ch        : int
	, property $$name      : str
	, property $$fade_time : int
) {
	//命令本体
	if ($$fade_time != -1) {
		pcmch[$$ch].play($$name, $$fade_time)
	}
	else{
		pcmch[$$ch].play($$name)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// チャンネルを指定して効果音を再生し、鳴り終わるまで待つ
command $pcmch_play_wait(
	  property $$ch        : int
	, property $$name      : str
	, property $$fade_time : int
) {
	//命令本体
	if ($$fade_time != -1) {
		pcmch[$$ch].play_wait($$name, $$fade_time)
	}
	else{
		pcmch[$$ch].play_wait($$name)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//チャンネルを指定して効果音をループ再生する（ディレイあり）
command $pcmch_play_loop_snddelay(
	  property $$delay_time : int
	, property $$ch         : int
	, property $$name       : str
	, property $$fade_time  : int
) {
	L[00] = @sound_fa_ch_start
	L[01] = @sound_fa_ch_count
	if (L[01] >= 8) {L[01] = 7}
	if ((L[01] >= 2) && ($$ch >= 08) && ($$ch <= 08 + L[01]-2) && ($$delay_time > 0)) {
		$$pcmch_snddelay_status[$$ch] = 1	//1:エンドアクション実行OK
		frame_action_ch[L[00]+1 + $$ch-08].start_real($$delay_time, "$pcmch_play_loop_snddelay00", $$delay_time, $$ch, $$name, $$fade_time)
	}
	else {
		$pcmch_play_loop($$ch, $$name, $$fade_time)
	}
}

//$pcmch_play_loop_snddelay内部で呼び出す命令
command $pcmch_play_loop_snddelay00(
	  property $$fa         : frameaction
	, property $$delay_time : int
	, property $$ch         : int
	, property $$name       : str
	, property $$fade_time  : int
) {
	L[00] = $$fa.counter.get
	if ((L[00] >= $$delay_time) && ($$pcmch_snddelay_status[$$ch] == 1)) {
		$pcmch_play_loop($$ch, $$name, $$fade_time)
		$$pcmch_snddelay_status[$$ch] = 0	//0:エンドアクション実行NG
	}
}

// チャンネルを指定して効果音をループ再生する
command $pcmch_play_loop(
	  property $$ch        : int
	, property $$name      : str
	, property $$fade_time : int
) {
	//命令本体
	if ($$fade_time != -1) {
		pcmch[$$ch].play_loop($$name, $$fade_time)
	}
	else{
		pcmch[$$ch].play_loop($$name)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//指定したチャンネルの効果音を停止する（ディレイあり）
command $pcmch_stop_snddelay(
	  property $$delay_time : int
	, property $$ch         : int
	, property $$fade_time  : int
) {
	L[00] = @sound_fa_ch_start
	L[01] = @sound_fa_ch_count
	if (L[01] >= 8) {L[01] = 7}
	if ((L[01] >= 2) && ($$ch >= 08) && ($$ch <= 08 + L[01]-2) && ($$delay_time > 0)) {
		$$pcmch_snddelay_status[$$ch] = 1	//1:エンドアクション実行OK
		frame_action_ch[L[00]+1 + $$ch-08].start_real($$delay_time, "$pcmch_stop_snddelay00", $$delay_time, $$ch, $$fade_time)
	}
	else {
		$pcmch_stop($$ch, $$fade_time)
	}
}

//$pcmch_stop_snddelay内部で呼び出す命令
command $pcmch_stop_snddelay00(
	  property $$fa         : frameaction
	, property $$delay_time : int
	, property $$ch         : int
	, property $$fade_time  : int
) {
	L[00] = $$fa.counter.get
	if ((L[00] >= $$delay_time) && ($$pcmch_snddelay_status[$$ch] == 1)) {
		$pcmch_stop($$ch, $$fade_time)
		$$pcmch_snddelay_status[$$ch] = 0	//0:エンドアクション実行NG
	}
}

// 指定したチャンネルの効果音を停止する
command $pcmch_stop(
	  property $$ch        : int
	, property $$fade_time : int
) {
	//命令本体
	if ($$fade_time != -1) {
		pcmch[$$ch].stop($$fade_time)
	}
	else {
		pcmch[$$ch].stop
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルの効果音が終了するのを待つ
command $pcmch_wait(property $$ch : int)
{
	//命令本体
	pcmch[$$ch].wait
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルの効果音が終了するのを待つ（キースキップ）
command $pcmch_wait_key(property $$ch : int) : int
{
	//命令本体
	return( pcmch[$$ch].wait_key )
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルの効果音のフェードアウトが終了するのを待つ
command $pcmch_wait_fade(property $$ch : int)
{
	//命令本体
	pcmch[$$ch].wait_fade
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルの効果音のフェードアウトが終了するのを待つ（キースキップ）
command $pcmch_wait_fade_key(property $$ch : int) : int
{
	//命令本体
	return( pcmch[$$ch].wait_fade_key )
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルの効果音の再生状態を取得する
command $pcmch_check(property $$ch : int) : int
{
	//命令本体
	return( pcmch[$$ch].check )
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルのボリュームを設定する
command $pcmch_set_volume(
	  property $$ch     : int
	, property $$volume : int
	, property $$time   : int
) {
	//命令本体
	if ($$time != -1) {
		pcmch[$$ch].set_volume($$volume, $$time)
	}
	else{
		pcmch[$$ch].set_volume($$volume)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルのボリュームを最大に設定する
command $pcmch_set_volume_max(
	  property $$ch   : int
	, property $$time : int
) {
	//命令本体
	if ($$time != -1) {
		pcmch[$$ch].set_volume_max($$time)
	}
	else{
		pcmch[$$ch].set_volume_max
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルのボリュームを最小に設定する
command $pcmch_set_volume_min(
	  property $$ch   : int
	, property $$time : int
) {
	//命令本体
	if ($$time != -1) {
		pcmch[$$ch].set_volume_min($$time)
	}
	else{
		pcmch[$$ch].set_volume_min
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 指定したチャンネルのボリュームを取得する
//以前のマクロと引数が違うので注意
command $pcmch_get_volume(property $$ch : int) : int
{
	//命令本体
	return( pcmch[$$ch].get_volume )
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//効果音チャンネルの音を全て停止する
command $pcmch_stop_all
{
	//命令本体
	if((@pcmch_cnt >= 1) && (@pcmch_cnt <= 256)) {	//@pcmch_cntが異常な値になっていないか確認
		for (L[00] = 0, L[00] <= @pcmch_cnt - 1, L[00] += 1) {
			@pcmch_stop(L[00],-1)
		}
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//効果音を準備する
command $pcmch_ready(
	  property $$ch   : int
	, property $$name : str
) {
	//命令本体
	pcmch[$$ch].ready($$name)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//ループ再生する効果音を準備する
command $pcmch_ready_loop(
	  property $$ch   : int
	, property $$name : str
) {
	//命令本体
	pcmch[$$ch].ready_loop($$name)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//準備した効果音を再生する
command $pcmch_resume(
	  property $$ch           : int
	, property $$fade_in_time : int
) {
	//命令本体
	if ($$fade_in_time != -1) {
		pcmch[$$ch].resume($$fade_in_time)
	}
	else{
		pcmch[$$ch].resume
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//準備した効果音を再生し、効果音が終了するまで待つ
command $pcmch_resume_wait(
	  property $$ch           : int
	, property $$fade_in_time : int
) {
	//命令本体
	if ($$fade_in_time != -1) {
		pcmch[$$ch].resume_wait($$fade_in_time)
	}
	else{
		pcmch[$$ch].resume_wait
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//指定したチャンネルの効果音実行の遅延を中断し、コマンドを実行する
//$$ch: 8 - 最大13。それ以外を入れても何もしない。※効果音のチャンネル。フレームアクションのチャンネルではない。
command $pcmch_snddelay_end(property $$ch : int)
{
	L[00] = @sound_fa_ch_start
	L[01] = @sound_fa_ch_count
	//↓誤ってDEFINEの方の条件文を使わないこと
	if (L[01] >= 8) {L[01] = 7}	//音関係用のカウンタ確保を誤って8以上にしていたら7（1(BGM)+6(PCM)）に制限
	if ((L[01] >= 2) && ($$ch >= 08) && ($$ch <= 08 + L[01]-2)) {
		frame_action_ch[L[00]+1 + $$ch-08].end
	}
	//$$pcmch_snddelay_status[$$ch] = 0 は $pcmch_stop_snddelay00 内部で実行される
}


/********************************************************
*														*
*				システム音関連							*
*														*
*********************************************************/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// システム音を再生する
command $se_play(property $$se_no : int)
{
	//命令本体
	se.play($$se_no)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ファイル名を指定してシステム音を鳴らす
command $se_play_name(property $$file_name : str)
{
	//命令本体
	se.play_by_file_name($$file_name)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 声番号を指定してシステム音を鳴らす
command $se_play_koe(property $$koe_no : int)
{
	//命令本体
	se.play_by_koe_no($$koe_no)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// システム音番号を指定してシステム音を鳴らす
command $se_play_se(property $$se_no : int)
{
	//命令本体
	se.play_by_se_no($$se_no)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// システム音を停止する
command $se_stop(property $$fade_time : int)
{
	//命令本体
	if ($$fade_time != -1) {
		se.stop($$fade_time)
	}
	else {
		se.stop
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// システム音の再生が終了するのを待つ
command $se_wait
{
	//命令本体
	se.wait
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// システム音の再生が終了するのを待つ（キースキップ）
command $se_wait_key
{
	//命令本体
	se.wait_key
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// システム音の再生状態を取得する
command $se_check : int
{
	//命令本体
	return(se.check)
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを設定する
command $se_set_volume(
	  property $$volume : int
	, property $$time   : int
) {
	//命令本体
	if ($$time != -1) {
		se.set_volume($$volume, $$time)
	}
	else {
		se.set_volume($$volume)
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを最大に設定する
command $se_set_volume_max(property $$time : int)
{
	//命令本体
	if ($$time != -1) {
		se.set_volume_max($$time)
	}
	else {
		se.set_volume_max
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを最小に設定する
command $se_set_volume_min(property $$time : int)
{
	//命令本体
	if ($$time != -1) {
		se.set_volume_min($$time)
	}
	else {
		se.set_volume_min
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// ボリュームを取得する
//以前のマクロと引数が違うので注意
command $se_get_volume : int
{
	//命令本体
	return(se.get_volume)
}


//ｷﾞﾓﾝ
//	$$fa.counter.get == $$delay_time の状態でフレームアクション内のコマンドに入ることが複数回あり得るのか？
//	→tnpn>余裕であり得る。複数回実行されたくなかったら自分で制御してほしい、とのこと。
//	→$$bgm_snddelay_status $$pcmch_snddelay_status[] で対処

