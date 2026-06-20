/********************************************************
*														*
*					フェードアウト						*
*														*
*********************************************************/
#z00

	command $fade(property $fade_sel   : int,
	              property $fade_color : str,
	              property $fade_wait  : int) : int
	{

		
		// @fadeが重複した場合スキップ
		if ($fade_dup == @Off)	{
		
			$$ef_bg_name_cutin_before	// k-takahashi 背景名表示追加
			
			// フィルターを解除する
			@f.effect[0].wipe_copy = @Off

			@b.obj[@OBJ_FADE].create($fade_color)
			@b.obj[@OBJ_FADE].set_pos(0, 0)
			@b.obj[@OBJ_FADE].tr = 255
			@b.obj[@OBJ_FADE].layer = 100000
			@b.obj[@OBJ_FADE].disp = @On
			// 背景のコピーフラグをＯＦＦに
			for (L[0] = 0, L[0] < @bg_maxnum, L[0] += 1)	{
				front.object[@OBJ_BG01+L[0]].wipe_copy = @Off
				$bg_name[0+L[0]] = "nothing"
				// 背景セットパラメータを初期化
				@bg_reset(L[0])
			}
			$bg_disp_cnt = @Init
			$bs_name[0] = "nothing"

			$wipe_wait = $fade_wait
			$fade_wipe_set = $fade_sel
			$fade_wmnd = $fade_wmnd

			// バストショット表示情報取得
			$bs_disp_info(0)
			// バストショット表示情報初期化
			for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
				$bs_name_info[0+L[0]] = ""
				$bs_name_info_prev[0+L[0]] = ""
			}
			$bs_disp_cnt = @Init

			// 回想終了
			@回想終了

			// 演出速度では背景に属する
			$disp = _disp_bg
			// メッセージウィンドウ
			if ($fade_wmnd == @Off)	{
				close
			}
			// 表示
			$wipe($fade_wipe_set)

			// @fadeが重複した場合スキップ
			$fade_dup = @On
			
			$$ef_bg_name_cutin	// k-takahashi 背景名表示追加
		}

	}




