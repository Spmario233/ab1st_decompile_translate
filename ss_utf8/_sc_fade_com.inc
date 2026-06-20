/********************************************************
*														*
*					フェードアウト						*
*														*
*********************************************************/
#define		@OBJ_FADE			0

#property	$fade_wipe_set : int
#property	$fade_sel      : int
#property	$fade_clolr    : str
#property	$fade_wmnd     : int
#property	$fade_dup      : int

#command    $fade(int, str, int) : int

// ---------------------------------------------------------------
// フェードアウト
// ---------------------------------------------------------------
#macro		@FADE(@FADE_COLOR, @FADE_SEL(3), @FADE_WAIT(1))
			$fade_wmnd = @Off
			$fade(@FADE_SEL, @FADE_COLOR, @FADE_WAIT)

// ---------------------------------------------------------------
// フェードアウト [メッセージウィンドウフェード]
// ---------------------------------------------------------------
#macro		@FADE_ALL(@FADE_COLOR, @FADE_SEL(3), @FADE_WAIT(1))
			$fade_wmnd = @On
			$fade(@FADE_SEL, @FADE_COLOR, @FADE_WAIT)


// ---------------------------------------------------------------
// 時間経過
// ---------------------------------------------------------------
#macro		@時間経過(@WAIT_TIME(500))
			$fade(3, bg_kuro, @On)
			@timewaitkey(@WAIT_TIME)


// ---------------------------------------------------------------
// シーン終了フェードアウト
// ---------------------------------------------------------------
#macro		@scene_fade(@FADE_SEL(4), @FADE_WAIT(1), @WAIT_TIME(2000))
			@bgm_stop(3000)
			@pcm_stop @pcmch_stop_all
			$fade_dup = @Off
			$fade_wmnd = @Off
			$fade(@FADE_SEL, bg_kuro, @FADE_WAIT)
			@timewaitkey(@WAIT_TIME)




