//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ルール
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
/*
サウンド関連は全て以下のマクロのものを使用すること。引数の省略に対応。
複雑なPCMイベントのみ汎用マクロ化はせず、使用するシーンに適した使い方をすること。←名前つき引数もﾑﾘ
*/
//#Z00

#define		@BgmNameNo		$bgm_name_no
#define		@BgmNameNoPrev	$bgm_name_no_prev
#property	$bgm_name_no : int
#property	$bgm_name_no_prev : int

#define		@CNoBgmTT		7

//#command	$bgm_title_disp
//#command	$bgm_title_control
//#command	$bgm_title_control1_excall
//#command	$bgm_title_control2_excall
//#command	$bgm_title_erase

//効果音チャンネルの数（gameexe.ini #PCMCH.CNT）
//pcmch.get_size的なコマンドが追加されたら置き換える
#define		@pcmch_cnt	16

//エンドアクション２回以上実行防止用。0:エンドアクション実行NG 1:実行OK
#property	$$bgm_snddelay_status : int
#property	$$pcmch_snddelay_status : intlist[@pcmch_cnt]

/********************************************************
*														*
*					ＢＧＭ関連							*
*														*
*********************************************************/
// 音楽をループ演奏
#macro		@bgm_play(@name, @fade_time(-1), @cross_time(-1), @bgm_name(1))	// @bgm_nameはシステム用
			$bgm_play(@name, @fade_time, @cross_time, @bgm_name)

//音楽をループ演奏（ディレイあり）
//	@delay_time：1以上だと、指定ミリ秒だけ命令を非同期で遅延実行する。
//		0以下なら遅延実行自体を行わないので、-1を指定しても無限にフレームアクションを呼ぶことはできない。
//※このコマンドを使ったら、次のＢＧＭ再生／停止コマンド（遅延コマンドに限らない）の前に必ず @bgm_snddelay_end を実行すること！！
#macro		@bgm_play_snddelay(@delay_time, @name, @fade_time(-1), @cross_time(-1), @bgm_name(1))
			$bgm_play_snddelay(@delay_time, @name, @fade_time, @cross_time, @bgm_name)

// 音楽をループ演奏 [システム用]
#macro		@bgm_play_sys(@name)
			$bgm_play_sys(@name)

// 音楽をワンショット演奏
#macro		@bgm_play_oneshot(@name, @fade_time(-1), @cross_time(-1))
			$bgm_play_oneshot(@name, @fade_time, @cross_time)

//音楽をワンショット演奏（ディレイあり）
//※このコマンドを使ったら、次のＢＧＭ再生／停止コマンド（遅延コマンドに限らない）の前に必ず @bgm_snddelay_end を実行すること！！
#macro		@bgm_play_oneshot_snddelay(@delay_time, @name, @fade_time(-1), @cross_time(-1))
			$bgm_play_oneshot_snddelay(@delay_time, @name, @fade_time, @cross_time)

// 音楽をワンショット演奏し、音楽が終了するまで待つ
#macro		@bgm_play_wait(@name, @fade_time(-1), @cross_time(-1))
			$bgm_play_wait(@name, @fade_time, @cross_time)

// ＢＧＭを停止する
#macro		@bgm_stop(@fade_time(-1))
			$bgm_stop(@fade_time)

//ＢＧＭを停止する（ディレイあり）
//※このコマンドを使ったら、次のＢＧＭ再生／停止コマンド（遅延コマンドに限らない）の前に必ず @bgm_snddelay_end を実行すること！！
#macro		@bgm_stop_snddelay(@delay_time, @fade_time(-1))
			$bgm_stop_snddelay(@delay_time, @fade_time)

// ＢＧＭを停止する [システム用]
#macro		@bgm_stop_sys(@fade_time(-1))
			$bgm_stop_sys(@fade_time)

// ＢＧＭが終了するのを待つ
#macro		@bgm_wait
			$bgm_wait

// ＢＧＭが終了するのを待つ（決定キーで処理をスキップ）
#macro		@bgm_wait_key
			$bgm_wait_key

// ＢＧＭのフェードアウトが終了するのを待つ
#macro		@bgm_wait_fade
			$bgm_wait_fade

// ＢＧＭのフェードアウトが終了するのを待つ（決定キーで処理をスキップ）
#macro		@bgm_wait_fade_key
			$bgm_wait_fade_key

// ＢＧＭの再生状態を取得する
#macro		@bgm_check
			$bgm_check

// ボリュームを設定する
#macro		@bgm_set_volume(@volume, @time(-1))
			$bgm_set_volume(@volume, @time)

// ボリュームを最大にする
#macro		@bgm_set_volume_max(@time(-1))
			$bgm_set_volume_max(@time)

// ボリュームを最小にする
#macro		@bgm_set_volume_min(@time(-1))
			$bgm_set_volume_min(@time)

// ボリュームを取得する
#macro		@bgm_get_volume
			$bgm_get_volume

//ループ演奏するＢＧＭを準備する
#macro		@bgm_ready(@name, @fade_out_time(-1))
			$bgm_ready(@name, @fade_out_time)

//ワンショット演奏するＢＧＭを準備する
#macro		@bgm_ready_oneshot(@name, @fade_out_time(-1))
			$bgm_ready_oneshot(@name, @fade_out_time)

//準備したＢＧＭを再生する
#macro		@bgm_resume(@fade_in_time(-1))
			$bgm_resume(@fade_in_time)

//準備したＢＧＭを再生し、音楽が終了するまで待つ
#macro		@bgm_resume_wait(@fade_in_time(-1))
			$bgm_resume_wait(@fade_in_time)

//ＢＧＭ実行の遅延を中断し、コマンドを実行する。※遅延コマンドを使ったら、次のＢＧＭ再生／停止コマンド（遅延コマンドに限らない）の前に必ずこれを実行すること！！
#macro		@bgm_snddelay_end
			$bgm_snddelay_end

// ＢＧＭを一時停止します
#macro		@bgm_pause(@fade_in_time(-1))
			$bgm_pause(@fade_in_time)


/********************************************************
*														*
*						音声関連						*
*														*
*********************************************************/
// 音声を再生する
#macro		@koe(@koe_no, @chara_no(-1))
			$koe(@koe_no, @chara_no)

// 音声を再生する（再生終了待ち）
#macro		@koe_play_wait(@koe_no, @chara_no(-1))
			$koe_play_wait(@koe_no, @chara_no)

// 音声を再生する（再生終了待ち、キースキップ）
#macro		@koe_play_wait_key(@koe_no, @chara_no(-1))
			$koe_play_wait_key(@koe_no, @chara_no)

// 声を停止する
#macro		@koe_stop
			$koe_stop

// 声の再生が終了するのを待つ
#macro		@koe_wait
			$koe_wait

// 声の再生が終了するのを待つ（キースキップ）
#macro		@koe_wait_key
			$koe_wait_key

// 声の再生状態を取得する
#macro		@koe_check
			$koe_check

// 音声のボリュームを設定する
#macro		@koe_set_volume(@volume, @time(-1))
			$koe_set_volume(@volume, @time)

// 音声のボリュームを最大に設定する
#macro		@koe_set_volume_max(@time(-1))
			$koe_set_volume_max(@time)

// 音声のボリュームを最小に設定する
#macro		@koe_set_volume_min(@time(-1))
			$koe_set_volume_min(@time)

// 音声のボリュームを取得する
#macro		@koe_get_volume
			$koe_get_volume

// 音声を強制的に再生する
#macro		@exkoe(@koe_no, @chara_no(-1))
			$exkoe(@koe_no, @chara_no)

// 音声を強制的に再生する（再生終了待ち）
#macro		@exkoe_play_wait(@koe_no, @chara_no(-1))
			$exkoe_play_wait(@koe_no, @chara_no)

// 音声を強制的に再生する（再生終了待ち、キースキップ）
#macro		@exkoe_play_wait_key(@koe_no, @chara_no(-1))
			$exkoe_play_wait_key(@koe_no, @chara_no)

// 音声速度テスト再生用
#macro		@exkoe_sample(@koe_no, @chara_no(-1))
			$exkoe_sample(@koe_no, @chara_no)


/********************************************************
*														*
*					効果音関連							*
*														*
*********************************************************/
// 効果音を再生する
#macro		@pcm_play(@file_name)
			$pcm_play(@file_name)

// 効果音を再生する（エモーション用）
//エモーションが無効の場合は効果音が鳴らない。
//@delay_time:指定した場合は、指定㍉秒だけ遅れて鳴る。（pcmeventイベント番号は00固定）
#macro		@pcm_play_emo(@file_name, @delay_time(0))
			$pcm_play_emo(@file_name, @delay_time)

// 効果音を停止する ※RealLiveと違って効果音チャンネル分は消音されません注意！
#macro		@pcm_stop
			$pcm_stop

// チャンネルを指定して効果音を再生する
#macro		@pcmch_play(@ch, @name, @fade_time(-1))
			$pcmch_play(@ch, @name, @fade_time)

//チャンネルを指定して効果音を再生する（ディレイあり）
//※このコマンドを使ったら、次の同ch効果音再生／停止コマンド（遅延コマンドに限らない）の前に必ず @pcmch_snddelay_end() を実行すること！！
//$$ch: 8 - 最大13。それ以外は遅延なしですぐ実行される（フレームアクションも使わない）。
#macro		@pcmch_play_snddelay(@delay_time, @ch, @name, @fade_time(-1))
			$pcmch_play_snddelay(@delay_time, @ch, @name, @fade_time)

// チャンネルを指定して効果音を再生し、鳴り終わるまで待つ
#macro		@pcmch_play_wait(@ch, @name, @fade_time(-1))
			$pcmch_play_wait(@ch, @name, @fade_time)

// チャンネルを指定して効果音をループ再生する
#macro		@pcmch_play_loop(@ch, @name, @fade_time(-1))
			$pcmch_play_loop(@ch, @name, @fade_time)

//チャンネルを指定して効果音をループ再生する（ディレイあり）
//※このコマンドを使ったら、次の同ch効果音再生／停止コマンド（遅延コマンドに限らない）の前に必ず @pcmch_snddelay_end() を実行すること！！
#macro		@pcmch_play_loop_snddelay(@delay_time, @ch, @name, @fade_time(-1))
			$pcmch_play_loop_snddelay(@delay_time, @ch, @name, @fade_time)

// 指定したチャンネルの効果音を停止する
#macro		@pcmch_stop(@ch, @fade_time)
			$pcmch_stop(@ch, @fade_time)

//指定したチャンネルの効果音を停止する（ディレイあり）
//※このコマンドを使ったら、次の同ch効果音再生／停止コマンド（遅延コマンドに限らない）の前に必ず @pcmch_snddelay_end() を実行すること！！
#macro		@pcmch_stop_snddelay(@delay_time, @ch, @fade_time(-1))
			$pcmch_stop_snddelay(@delay_time, @ch, @fade_time)

// 指定したチャンネルの効果音が終了するのを待つ
#macro		@pcmch_wait(@ch)
			$pcmch_wait(@ch)

// 指定したチャンネルの効果音が終了するのを待つ（キースキップ）
#macro		@pcmch_wait_key(@ch)
			$pcmch_wait_key(@ch)

// 指定したチャンネルの効果音のフェードアウトが終了するのを待つ
#macro		@pcmch_wait_fade(@ch)
			$pcmch_wait_fade(@ch)

// 指定したチャンネルの効果音のフェードアウトが終了するのを待つ（キースキップ）
#macro		@pcmch_wait_fade_key(@ch)
			$pcmch_wait_fade_key(@ch)

// 指定したチャンネルの効果音の再生状態を取得する
#macro		@pcmch_check(@ch)
			$pcmch_check(@ch)

// 指定したチャンネルのボリュームを設定する
#macro		@pcmch_set_volume(@ch, @volume, @time(-1))
			$pcmch_set_volume(@ch, @volume, @time)

// 指定したチャンネルのボリュームを最大に設定する
#macro		@pcmch_set_volume_max(@ch, @time(-1))
			$pcmch_set_volume_max(@ch, @time)

// 指定したチャンネルのボリュームを最小に設定する
#macro		@pcmch_set_volume_min(@ch, @time(-1))
			$pcmch_set_volume_min(@ch, @time)

// 指定したチャンネルのボリュームを取得する
#macro		@pcmch_get_volume(@ch)
			$pcmch_get_volume(@ch)

//効果音チャンネルの音を全て停止する
//効果音を全て停止するには、@pcm_stop（汎用PCM分）@pcmch_stop_all（専用PCM分）の両方を指定すること
//※システム音とシステム音声は両方指定しても消えない。
#macro		@pcmch_stop_all
			$pcmch_stop_all

//効果音を準備する
#macro		@pcmch_ready(@ch, @name)
			$pcmch_ready(@ch, @name)

//ループ再生する効果音を準備する
#macro		@pcmch_ready_loop(@ch, @name)
			$pcmch_ready_loop(@ch, @name)

//準備した効果音を再生する
#macro		@pcmch_resume(@ch, @fade_in_time(-1))
			$pcmch_resume(@ch, @fade_in_time)

//準備した効果音を再生し、効果音が終了するまで待つ
#macro		@pcmch_resume_wait(@ch, @fade_in_time(-1))
			$pcmch_resume_wait(@ch, @fade_in_time)

//指定したチャンネルの効果音実行の遅延を中断し、コマンドを実行する。※遅延コマンドを使ったら、次の同ch効果音再生／停止コマンド（遅延コマンドに限らない）の前に必ずこれを実行すること！！
//$$ch: 8 - 最大13。それ以外を入れても何もしない。※効果音のチャンネル。フレームアクションのチャンネルではない。
#macro		@pcmch_snddelay_end(@ch)
			$pcmch_snddelay_end(@ch)


/********************************************************
*														*
*				システム音関連							*
*														*
*********************************************************/
// システム音を再生する
#macro		@se_play(@se_no)
			$se_play(@se_no)

// ファイル名を指定してシステム音を鳴らす
#macro		@se_play_name(@file_name)
			$se_play_name(@file_name)

// 声番号を指定してシステム音を鳴らす
#macro		@se_play_koe(@koe_no)
			$se_play_koe(@koe_no)

// システム音番号を指定してシステム音を鳴らす
#macro		@se_play_se(@se_no)
			$se_play_se(@se_no)

// システム音を停止する
#macro		@se_stop(@fade_time(-1))
			$se_stop(@fade_time)

// システム音の再生が終了するのを待つ
#macro		@se_wait
			$se_wait

// システム音の再生が終了するのを待つ（キースキップ）
#macro		@se_wait_key
			$se_wait_key

// システム音の再生状態を取得する
#macro		@se_check
			$se_check

// ボリュームを設定する
#macro		@se_set_volume(@volume, @time(-1))
			$se_set_volume(@volume, @time)

// ボリュームを最大に設定する
#macro		@se_set_volume_max(@time(-1))
			$se_set_volume_max(@time)

// ボリュームを最小に設定する
#macro		@se_set_volume_min(@time(-1))
			$se_set_volume_min(@time)

// ボリュームを取得する
#macro		@se_get_volume
			$se_get_volume




//以下コマンド定義
#command	$bgm_play_snddelay(int, str, int, int, int)
#command	$bgm_play_snddelay00(frameaction, int, str, int, int, int)
#command	$bgm_play(str, int, int, int)
#command	$bgm_play_sys(str)
#command	$bgm_play_oneshot_snddelay(int, str, int, int)
#command	$bgm_play_oneshot_snddelay00(frameaction, int, str, int, int)
#command	$bgm_play_oneshot(str, int, int)
#command	$bgm_play_wait(str, int, int)
#command	$bgm_stop_snddelay(int, int)
#command	$bgm_stop_snddelay00(frameaction, int, int)
#command	$bgm_stop(int)
#command	$bgm_stop_sys(int)
#command	$bgm_wait
#command	$bgm_wait_key : int
#command	$bgm_wait_fade
#command	$bgm_wait_fade_key : int
#command	$bgm_check : int
#command	$bgm_set_volume(int, int)
#command	$bgm_set_volume_max(int)
#command	$bgm_set_volume_min(int)
#command	$bgm_get_volume : int
#command	$bgm_ready(str, int)
#command	$bgm_ready_oneshot(str, int)
#command	$bgm_resume(int)
#command	$bgm_resume_wait(int)
#command	$bgm_snddelay_end
#command	$bgm_pause(int)
#command	$koe(int, int)
#command	$koe_play_wait(int, int)
#command	$koe_play_wait_key(int, int) : int
#command	$koe_stop
#command	$koe_wait
#command	$koe_wait_key : int
#command	$koe_check : int
#command	$koe_set_volume(int, int)
#command	$koe_set_volume_max(int)
#command	$koe_set_volume_min(int)
#command	$koe_get_volume : int
#command	$exkoe(int, int)
#command	$exkoe_play_wait(int, int)
#command	$exkoe_play_wait_key(int, int) : int
#command	$exkoe_sample(int, int)
#command	$pcm_play(str)
#command	$pcm_play_emo(str, int)
#command	$pcm_stop
#command	$pcmch_play_snddelay(int, int, str, int)
#command	$pcmch_play_snddelay00(frameaction, int, int, str, int)
#command	$pcmch_play(int, str, int)
#command	$pcmch_play_wait(int, str, int)
#command	$pcmch_play_loop_snddelay(int, int, str, int)
#command	$pcmch_play_loop_snddelay00(frameaction, int, int, str, int)
#command	$pcmch_play_loop(int, str, int)
#command	$pcmch_stop_snddelay(int, int, int)
#command	$pcmch_stop_snddelay00(frameaction, int, int, int)
#command	$pcmch_stop(int, int)
#command	$pcmch_wait(int)
#command	$pcmch_wait_key(int) : int
#command	$pcmch_wait_fade(int)
#command	$pcmch_wait_fade_key(int) : int
#command	$pcmch_check(int) : int
#command	$pcmch_set_volume(int, int, int)
#command	$pcmch_set_volume_max(int, int)
#command	$pcmch_set_volume_min(int, int)
#command	$pcmch_get_volume(int) : int
#command	$pcmch_stop_all
#command	$pcmch_ready(int, str)
#command	$pcmch_ready_loop(int, str)
#command	$pcmch_resume(int, int)
#command	$pcmch_resume_wait(int, int)
#command	$pcmch_snddelay_end(int)
#command	$se_play(int)
#command	$se_play_name(str)
#command	$se_play_koe(int)
#command	$se_play_se(int)
#command	$se_stop(int)
#command	$se_wait
#command	$se_wait_key
#command	$se_check : int
#command	$se_set_volume(int, int)
#command	$se_set_volume_max(int)
#command	$se_set_volume_min(int)
#command	$se_get_volume : int

