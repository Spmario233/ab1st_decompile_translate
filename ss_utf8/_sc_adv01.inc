/********************************************************
*														*
*					日付変更							*
*														*
*********************************************************/
// @OBJ_BG01使用
#macro		@DAY_CHANGE(@DAYS(@days), @REAL(0), @BG_NAME("random"))
			close
			farcall("_sys_macro_day", 0, @DAYS, @REAL, @BG_NAME)

/********************************************************
*														*
*					１日の終わり						*
*														*
*********************************************************/
#macro		@END_DAY(@BGM_FADE(2000), @SEL(005), @TWAIT(1000))
			// @fade重複トリガーを解除
			$fade_dup = @Off
			// ＢＧＭフェードアウト
			@BGM_STOP(@BGM_FADE)
			// 音声停止
			@koe_stop
			// 効果音全停止
			@PCM_STOP @PCMCH_STOP_ALL
			// 効果音のボリュームを初期化
			for (L[0] = 0, L[0] < 17, L[0] += 1)	{
				pcmch[L[0]].set_volume(255)
			}
			// システム音停止
			@SE_STOP(1000)
			// 黒フェード
			@FADE(BG_kuro, @SEL)
			// ウェイト
			@TIMEWAITKEY(@TWAIT)

/********************************************************
*														*
*					アイキャッチ						*
*														*
*********************************************************/
#macro		@アイキャッチ
			@bgm_stop(1000)
			@b.obj[@OBJ_FADE].create_movie(sys_ecatch00, @Off, ready_only = @On, auto_free = @Off)
			@b.obj[@OBJ_FADE].layer = 100000
			@pcmch_ready(0, sys_ecatch00)

			@b.obj[@OBJ_FADE].disp = @On
			@b.obj[@OBJ_FADE].resume_movie
			@pcmch_resume(0)

			close
			wipe(0, 0)

			// アイキャッチ以外のオブジェクトのワイプコピーをオフ
			for (L[0] = 1, L[0] < 310, L[0] += 1)	{
				if (L[0] != 245)	{
					@b.obj[L[0]].init
					@f.obj[L[0]].init
				}
			}

			timewait_key(3434)
			@pcmch_stop(0,500)


/********************************************************
*														*
*						視点変更						*
*														*
*********************************************************/
#macro		@視点変更_表示(@who)
			$view_change(@who, 1)

#macro		@視点変更_消去
			$view_change("消去", 0)

#command	$view_change(str, int)


/********************************************************
*														*
*				タイトルメニューに戻る					*
*														*
*********************************************************/
#macro		@returnmenu(@On)
			@エンディングを見た = @On
			syscom.return_to_menu(@Off, @Off, @Off)




