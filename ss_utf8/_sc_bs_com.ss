/********************************************************
*														*
*					キャラクター表示					*
*														*
*********************************************************/
#z00

// バストショット表示
command $bs_disp_in(property $dummy : int)
{

	// @fade重複トリガーを解除
	$fade_dup = @Off

	// 演出用の背景カウントを初期化
	$bg_disp_cnt = @Init

	// バストショット表示判定
	$$bs_exist_decide

	// バストショット情報取得
	$$bs_info

	// エモーション表示判定
	$$bs_emo_exist_decide

	// バストショット距離判定  9…通常 10…近接／至近
	$$bs_far_decide

	// バストショット重複判定
	$$bs_repeat_decide

	// バストショット消去判定
	$$bs_del_decide

	if ($bs_type == _type_bs01)	{
		// 簡易表示準備
		$$bs_wipe_ready01
	}
	elseif ($bs_type == _type_bs02)	{
		// 指定表示準備
		$$bs_wipe_ready02
	}

	// エモーション／アクション設定
	$$bs_emo_set

	// バストショット中心補正座標設定
	$$bs_rotate

	// 背景時刻判定
	$$bg_set_time

	//
	// カットイン判定
	//

//	if (C[1234] == 0)	{

		// バストショット表示
		 $$bs_wipe

		// バストショット表示情報取得
		$$bs_disp_info

//	}

}


// バストショット表示情報取得
command $bs_disp_info(property $dummy : int)
{
	$$bs_disp_info
}

// エモーション表示判定
command $bs_disp_emo_info(property $dummy : int)
{
	$$bs_emo_exist_decide

}

// バストショット距離判定
command $bs_disp_far_info(property $dummy : int)
{
	$$bs_far_decide
}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 背景時刻判定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $$bg_set_time
{
	$bs_tone_set($bg_name[0])
//	farcall("_sys_com_tone", 00, $bg_name[0])
}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット表示判定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z01
command $$bs_exist_decide
{
	// バストショット表示最大数
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_exist_decide[0+L[0]] = $bs_name[0+L[0]].search("nothing")
	}
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット情報取得
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z02
command $$bs_info
{

	// バストショット表示最大数
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		if ($bs_name[0+L[0]] != "nothing")	{
			$bs_name_decide[+L[0]] = @Off
			// キャラ識別指定のみの場合は、直前に表示されていたパターンを代入する
			if ($bs_name[0+L[0]].cnt == 2)	{
				for (L[1] = 0, L[1] < @bs_maxnum, L[1] += 1)	{
					if ($bs_name[0+L[0]] == $cha_name_prev[L[1]].mid(4, 2))	{
						$bs_name[0+L[0]] = $cha_name_prev[L[1]]
					}
				}
			}
			// バストショットサイズ "BS1"_YR0101
			switch ($bs_name[0+L[0]].left(3))	{
				case ("bs1") $bs_size_info[0+L[0]] = "1"	// 通常
				case ("bs2") $bs_size_info[0+L[0]] = "2"	// 近接
				case ("bs3") $bs_size_info[0+L[0]] = "3"	// 至近
				default
				             // "BS1_"を省略した場合の処理／初期値を入れておく
				             if ($bs_name[0+L[0]].cnt != 2)	{
					             $bs_size_info[0+L[0]] = "2"
					             $bs_name[0+L[0]] = "bs2_" + $bs_name[0+L[0]]
								 $bs_name_decide[+L[0]] = @On
							 }
			}

			//
			// 通常／近接／至近 共に同じ処理
			//

			// バストショットネーム BS1_"YR"0101
			$bs_name_info[0+L[0]] = $bs_name[0+L[0]].mid(4, 2)
			// バストショットポーズ BS1_YR"01"01
			$bs_pose_info[0+L[0]] = $bs_name[0+L[0]].mid(6, 2)
			// バストショット表情   BS1_YR01"01"
			$bs_face_info[0+L[0]] = $bs_name[0+L[0]].mid(8, 2)
			// バストショット口元	BS1_YR0101_"02"
			if ($bs_name[0+L[0]].mid(10, 1) == "_")	{
				$bs_mouth_info[0+L[0]] = $bs_name[0+L[0]].mid(11, 2)
			}
			else	{
				$bs_mouth_info[0+L[0]] = "_XX"
			}

			// バストショット服装   ※ファイル名からは取得しない

			if ($bs_name_decide[+L[0]] == @On)	{
				// "BS1_"を省略した場合の処理／前回に表示されていた場合は、上書きする
		        for (L[1] = 0, L[1] < @bs_maxnum, L[1] += 1)	{
		         	if ($bs_exist_decide[0+L[0]] != 0 && $bs_name_info_prev[0+L[1]] == $bs_name_info[0+L[0]])	{
						switch ($bs_name_info[0+L[0]])	{
							case ("OT") L[2] =  0+10		// 音無
							case ("KN") L[2] =  1+10		// かなで
							case ("YR") L[2] =  2+10		// ゆり
							case ("HN") L[2] =  3+10		// 日向
							case ("YI") L[2] =  4+10		// ユイ
							case ("IW") L[2] =  5+10		// 岩沢
							case ("MT") L[2] =  6+10		// 松下（太）
							case ("MS") L[2] =  7+10		// 松下（細）
							case ("ND") L[2] =  8+10		// 野田
							case ("TM") L[2] =  9+10		// 高松
							case ("OY") L[2] = 10+10		// 大山
							case ("FJ") L[2] = 11+10		// 藤巻
							case ("TK") L[2] = 12+10		// ＴＫ
							case ("SN") L[2] = 13+10		// 椎名
							case ("YS") L[2] = 14+10		// 遊佐
							case ("HS") L[2] = 15+10		// ひさ子
							case ("SK") L[2] = 16+10		// 関根
							case ("IR") L[2] = 17+10		// 入江
							case ("CH") L[2] = 18+10		// チャー
							case ("TY") L[2] = 19+10		// 竹山
							case ("NA") L[2] = 20+10		// 直井
							case ("ST") L[2] = 21+10		// フィッシュ斎藤
							case ("IG") L[2] = 22+10		// 五十嵐
							case ("A1") L[2] = 23+10		// 赤目天使１
							case ("A2") L[2] = 24+10		// 赤目天使２
							case ("K1") L[2] = 25+10		// 影１
							case ("K2") L[2] = 26+10		// 影２
							case ("K3") L[2] = 27+10		// 影３
							case ("K4") L[2] = 28+10		// 影４
						}
		         		
//		         		"$bs_size_info[0+L[0]] = " print($bs_size_info[0+L[0]])R
//		         		"L[2] = " print(L[2])R
		         		
		         		K[0] = @f.obj[L[2]].@cd[0].get_file_name
						$bs_size_info[0+L[0]] = K[0].mid(2, 1)
		         		$bs_name[0+L[0]] = $bs_name[0+L[0]].mid(4)
	         			$bs_name[0+L[0]] = "bs" + $bs_size_info[0+L[0]] + "_" + $bs_name[0+L[0]]
//		         		"$bs_name[0+L[0]] = " print($bs_name[0+L[0]])R
		         		
		         		break
		         	}
				}
			}

			// 表示指定キャラの記憶
			$bs_name_info_prev[0+L[0]] = $bs_name_info[0+L[0]]
		}
		else	{
			$bs_name_info_prev[0+L[0]] = ""
			$bs_name_info[0+L[0]] = ""
		}
	}


}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// エモーション表示判定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z03
command $$bs_emo_exist_decide
{

	// エモーションの初期化
	$bs_emo01_num.clear(0, 5, @emo_none)
	$bs_emo02_num.clear(0, 5, @emo_none)
	$bs_emo03_num.clear(0, 5, @emo_none)
	// アクションの初期化
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_action[L[0]] = ""
		$bs_action01[L[0]] = ""
		$bs_action02[L[0]] = ""
		$bs_action03[L[0]] = ""
	}

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		if ($bs_name[0+L[0]].cnt > 12)	{	// ※bs1_yr0101_01"@01"
			if ($bs_size_info[0+L[0]] == "1")	{
		    	$bs_distance[0+L[0]] = _type_far
			}
			elseif ($bs_size_info[0+L[0]] == "2")	{
		    	$bs_distance[0+L[0]] = _type_near
			}
			elseif ($bs_size_info[0+L[0]] == "3")	{
		    	$bs_distance[0+L[0]] = _type_imm
			}

			//
			// アクションは１パターンのみなので、複数指定されたら上書きしていく ※スライドイン／スライドアウトは重複ＯＫ
			//

			// エモーション／アクション指定抜き出し
			if ($bs_mouth_info[0+L[0]] == "_XX")	{
				L[1] = 10 L[2] = 14
			}
			else	{
				L[1] = 10+3 L[2] = 14+3
			}

			// エモ０１／アクション取得	BS1_YR0101_XX "0000" 01a0
			K[0+L[0]] = $bs_name[0+L[0]].mid(L[1], 2)   $bs_emo01_num[0+L[0]] = K[0+L[0]].tonum
			K[1+L[0]] = $bs_name[0+L[0]].mid(L[1]+2, 2) $bs_action01[0+L[0]] = K[1+L[0]]

			// エモ０２／アクション取得	BS1_YR0101_XX 0000 "01a0"
			K[0+L[0]] = $bs_name[0+L[0]].mid(L[2], 2)   $bs_emo02_num[0+L[0]] = K[0+L[0]].tonum
			K[1+L[0]] = $bs_name[0+L[0]].mid(L[2]+2, 2) $bs_action02[0+L[0]] = K[1+L[0]]

			// アクションが設定してない場合はemptyに
			if ($bs_action01[0+L[0]] == "00") {$bs_action01[0+L[0]] = ""}
			if ($bs_action02[0+L[0]] == "00") {$bs_action02[0+L[0]] = ""}
			if ($bs_action03[0+L[0]] == "00") {$bs_action03[0+L[0]] = ""}

			// バストショットファイル名からエモ番号を破棄
			// 通常／近接／至近
			if ($bs_mouth_info[0+L[0]] == "_XX")	{
				$bs_name[0+L[0]] = $bs_name[0+L[0]].left(10)
			}
			else	{
				$bs_name[0+L[0]] = $bs_name[0+L[0]].left(13)
			}
		}
	}
}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット距離判定  9…通常 10…近接／至近 ※10に固定化
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z04
command $$bs_far_decide
{

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		@BS_FAR01[+L[0]] = 4
	}

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット重複判定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z05
command $$bs_repeat_decide
{

	// １度取得すれば充分
//	@Get_chara_it_info("MH", "AS", "YZ", "SZ", "YU", "ST", "KR", "HB", "TK", "HN", "YI", "OT", "E3")

	@Get_chara_it_info("OT", "KN", "YR", "HN", "YI", "IW", "MT", "MS", "ND", "TM",
	                   "OY", "FJ", "TK", "SN", "YS", "HS", "SK", "IR", "CH", "TY",
	                   "NA", "ST", "IG", "A1", "A2", "K1", "K2", "K3", "K4")

	// キャラのＩ．Ｔを取得し、$bs_chaに格納
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_cha[0+L[0]] = $bs_name[0+L[0]].mid(@BS_FAR01[+L[0]], 2)
		for (L[1] = 0, L[1] < @cha_maxenter, L[1] += 1)	{
			// キャラ番号割り当て
			if ($bs_cha[0+L[0]] == $cha_id[00+L[1]]){
				// 文字列を数値に変換
				switch ($cha_id[00+L[1]])	{
					case ("OT") L[2] =  0		// 音無
					case ("KN") L[2] =  1		// かなで
					case ("YR") L[2] =  2		// ゆり
					case ("HN") L[2] =  3		// 日向
					case ("YI") L[2] =  4		// ユイ
					case ("IW") L[2] =  5		// 岩沢
					case ("MT") L[2] =  6		// 松下（太）
					case ("MS") L[2] =  7		// 松下（細）
					case ("ND") L[2] =  8		// 野田
					case ("TM") L[2] =  9		// 高松
					case ("OY") L[2] = 10		// 大山
					case ("FJ") L[2] = 11		// 藤巻
					case ("TK") L[2] = 12		// ＴＫ
					case ("SN") L[2] = 13		// 椎名
					case ("YS") L[2] = 14		// 遊佐
					case ("HS") L[2] = 15		// ひさ子
					case ("SK") L[2] = 16		// 関根
					case ("IR") L[2] = 17		// 入江
					case ("CH") L[2] = 18		// チャー
					case ("TY") L[2] = 19		// 竹山
					case ("NA") L[2] = 20		// 直井
					case ("ST") L[2] = 21		// フィッシュ斎藤
					case ("IG") L[2] = 22		// 五十嵐
					case ("A1") L[2] = 23		// 赤目天使１
					case ("A2") L[2] = 24		// 赤目天使２
					case ("K1") L[2] = 25		// 影１
					case ("K2") L[2] = 26		// 影２
					case ("K3") L[2] = 27		// 影３
					case ("K4") L[2] = 28		// 影４
				}
				$bs_cha_num[0+L[0]] = L[2] + 10	// バストショットオブジェクト開始番号10
			}
		}
	}

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット消去判定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z06

command $$bs_del_decide
{

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		K[0] = $bs_name[0+L[0]].mid(@BS_FAR01[+L[0]]+2, 4)
		$bs_del_decide[0+L[0]] = K[0].search("9999")
	}
//	"$bs_del_decide[0]："print($bs_del_decide[0])R

//		$bs_del_decide[0+L[0]] = $bs_name[0+L[0]].mid(@BS_FAR01[+L[0]], 2).search("0000")	exe堕ちる

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 簡易表示準備
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z07
command $$bs_wipe_ready01
{

	//
	// 指定した順に自動で座標を指定する。位置移動速度は固定。
	//


	// バストショットとエモーションの座標取得
	if ($bs_clear_all == @Off)	{
		for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
			$chara_rotate_z_prev[$bs_cha_num[0+L[0]]]   = 0
			$chara_scale_x_prev[$bs_cha_num[0+L[0]]]    = 1000
			$chara_scale_y_prev[$bs_cha_num[0+L[0]]]    = 1000
		}
	}

	// バストショットＡＬＬクリアＯＦＦ
	$bs_clear_all = @Off

	// ６人表示の場合
	if ($bs_exist_decide[5] != 0)	{
		$bs_posx_next[0] = $POS_FL-90  $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
		$bs_posx_next[1] = $POS_L+10   $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
		$bs_posx_next[2] = $POS_NL+50  $bs_posy_next[2] = $POS_M $posx_speed[2] = @sd_normal $posy_speed[2] = @sd_normal $posx_speed_delay[2] = @sd_inst $posy_speed_delay[2] = @sd_inst $posx_speed_mod[2] = 2
		$bs_posx_next[3] = $POS_NR-40  $bs_posy_next[3] = $POS_M $posx_speed[3] = @sd_normal $posy_speed[3] = @sd_normal $posx_speed_delay[3] = @sd_inst $posy_speed_delay[3] = @sd_inst $posx_speed_mod[3] = 2
		$bs_posx_next[4] = $POS_R      $bs_posy_next[4] = $POS_M $posx_speed[4] = @sd_normal $posy_speed[4] = @sd_normal $posx_speed_delay[4] = @sd_inst $posy_speed_delay[4] = @sd_inst $posx_speed_mod[4] = 2
		$bs_posx_next[5] = $POS_FR+70  $bs_posy_next[5] = $POS_M $posx_speed[5] = @sd_normal $posy_speed[5] = @sd_normal $posx_speed_delay[5] = @sd_inst $posy_speed_delay[5] = @sd_inst $posx_speed_mod[5] = 2
	}
	// ５人表示の場合
	elseif (($bs_exist_decide[4] != 0) && ($bs_exist_decide[5] == 0))	{
		$bs_posx_next[0] = $POS_FL-30  $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
		$bs_posx_next[1] = $POS_NL-50  $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
		$bs_posx_next[2] = $POS_C      $bs_posy_next[2] = $POS_M $posx_speed[2] = @sd_normal $posy_speed[2] = @sd_normal $posx_speed_delay[2] = @sd_inst $posy_speed_delay[2] = @sd_inst $posx_speed_mod[2] = 2
		$bs_posx_next[3] = $POS_NR+80  $bs_posy_next[3] = $POS_M $posx_speed[3] = @sd_normal $posy_speed[3] = @sd_normal $posx_speed_delay[3] = @sd_inst $posy_speed_delay[3] = @sd_inst $posx_speed_mod[3] = 2
		$bs_posx_next[4] = $POS_FR+30  $bs_posy_next[4] = $POS_M $posx_speed[4] = @sd_normal $posy_speed[4] = @sd_normal $posx_speed_delay[4] = @sd_inst $posy_speed_delay[4] = @sd_inst $posx_speed_mod[4] = 2
	}
	// ４人表示の場合
	elseif (($bs_exist_decide[3] != 0) && ($bs_exist_decide[4] == 0) && ($bs_exist_decide[5] == 0))	{
		$bs_posx_next[0] = $POS_FL     $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
		$bs_posx_next[1] = $POS_NL+10  $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
		$bs_posx_next[2] = $POS_HR-10  $bs_posy_next[2] = $POS_M $posx_speed[2] = @sd_normal $posy_speed[2] = @sd_normal $posx_speed_delay[2] = @sd_inst $posy_speed_delay[2] = @sd_inst $posx_speed_mod[2] = 2
		$bs_posx_next[3] = $POS_FR     $bs_posy_next[3] = $POS_M $posx_speed[3] = @sd_normal $posy_speed[3] = @sd_normal $posx_speed_delay[3] = @sd_inst $posy_speed_delay[3] = @sd_inst $posx_speed_mod[3] = 2
	}
	// ３人表示の場合
	elseif (($bs_exist_decide[2] != 0) && ($bs_exist_decide[3] == 0) && ($bs_exist_decide[4] == 0) && ($bs_exist_decide[5] == 0))	{
		// ３人ともbs2だった場合
		if (($bs_size_info[0] == "2") && ($bs_size_info[1] == "2") && ($bs_size_info[2] == "2"))	{
			$bs_posx_next[0] = $POS_L-100 $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
			$bs_posx_next[1] = $POS_C     $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
			$bs_posx_next[2] = $POS_R+100 $bs_posy_next[2] = $POS_M $posx_speed[2] = @sd_normal $posy_speed[2] = @sd_normal $posx_speed_delay[2] = @sd_inst $posy_speed_delay[2] = @sd_inst $posx_speed_mod[2] = 2
		}
		else	{
			$bs_posx_next[0] = $POS_L   $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
			$bs_posx_next[1] = $POS_C   $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
			$bs_posx_next[2] = $POS_R   $bs_posy_next[2] = $POS_M $posx_speed[2] = @sd_normal $posy_speed[2] = @sd_normal $posx_speed_delay[2] = @sd_inst $posy_speed_delay[2] = @sd_inst $posx_speed_mod[2] = 2
		}
	}
	// ２人表示の場合
	elseif (($bs_exist_decide[1] != 0) && ($bs_exist_decide[2] == 0) && ($bs_exist_decide[3] == 0) && ($bs_exist_decide[4] == 0) && ($bs_exist_decide[5] == 0))	{
		// ２人ともbs3だった場合
		if (($bs_size_info[0] == "3") && ($bs_size_info[1] == "3"))	{
			$bs_posx_next[0] = $POS_L  $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
			$bs_posx_next[1] = $POS_R  $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
		}
		// ２人ともbs2だった場合
		elseif (($bs_size_info[0] == "2") && ($bs_size_info[1] == "2"))	{
			$bs_posx_next[0] = $POS_L+40  $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
			$bs_posx_next[1] = $POS_R-40  $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
		}
		else	{
			$bs_posx_next[0] = $POS_HL-20  $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
			$bs_posx_next[1] = $POS_HR+20  $bs_posy_next[1] = $POS_M $posx_speed[1] = @sd_normal $posy_speed[1] = @sd_normal $posx_speed_delay[1] = @sd_inst $posy_speed_delay[1] = @sd_inst $posx_speed_mod[1] = 2
		}
	}
	// １人表示の場合
	elseif (($bs_exist_decide[0] != 0) && ($bs_exist_decide[1] == 0) && ($bs_exist_decide[2] == 0) && ($bs_exist_decide[3] == 0) && ($bs_exist_decide[4] == 0) && ($bs_exist_decide[5] == 0))	{
		$bs_posx_next[0] = $POS_C  $bs_posy_next[0] = $POS_M $posx_speed[0] = @sd_normal $posy_speed[0] = @sd_normal $posx_speed_delay[0] = @sd_inst $posy_speed_delay[0] = @sd_inst $posx_speed_mod[0] = 2
	}
	// キャラ消去の場合
	else{

		//
		// バストショット消去の場合でも全ての手順を踏まなければならない
		//

	}

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		switch ($bs_size_info[0+L[0]])	{
			case ("1") L[1] =   0
			case ("2") L[1] = 200
			case ("3") L[1] = 400
		}
		$chara_layer_next[$bs_cha_num[0+L[0]]]       = $chara_layer[$bs_cha_num[0+L[0]]]       + L[1]
		$chara_emo01_layer_next[$bs_cha_num[0+L[0]]] = $chara_emo01_layer[$bs_cha_num[0+L[0]]] + L[1]
		$chara_emo02_layer_next[$bs_cha_num[0+L[0]]] = $chara_emo02_layer[$bs_cha_num[0+L[0]]] + L[1]
		$chara_emo03_layer_next[$bs_cha_num[0+L[0]]] = $chara_emo03_layer[$bs_cha_num[0+L[0]]] + L[1]
	}

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 指定表示準備
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z08
command $$bs_wipe_ready02
{

	// バストショットのレイヤーを指定
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		if ($bs_layer_next[0+L[0]] != $pos_z)	{
			$chara_layer_next[$bs_cha_num[0+L[0]]]        = $bs_layer_next[0+L[0]]
			$chara_emo01_layer_next[$bs_cha_num[0+L[0]]]  = $bs_emo01_layer_next[0+L[0]]
			$chara_emo02_layer_next[$bs_cha_num[0+L[0]]]  = $bs_emo02_layer_next[0+L[0]]
			$chara_emo03_layer_next[$bs_cha_num[0+L[0]]]  = $bs_emo03_layer_next[0+L[0]]
		}
		else {
			switch ($bs_size_info[0+L[0]])	{
				case ("1") L[1] =   0
				case ("2") L[1] = 200
				case ("3") L[1] = 400
			}
			$chara_layer_next[$bs_cha_num[0+L[0]]]       = $chara_layer[$bs_cha_num[0+L[0]]]       + L[1]
			$chara_emo01_layer_next[$bs_cha_num[0+L[0]]] = $chara_emo01_layer[$bs_cha_num[0+L[0]]] + L[1]
			$chara_emo02_layer_next[$bs_cha_num[0+L[0]]] = $chara_emo02_layer[$bs_cha_num[0+L[0]]] + L[1]
			$chara_emo03_layer_next[$bs_cha_num[0+L[0]]] = $chara_emo03_layer[$bs_cha_num[0+L[0]]] + L[1]
		}
	}

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// レイヤー指定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z09
command $$bs_layer_set{

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// エモーション設定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z10
command $$bs_emo_set
{
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		// エモーション指定があった場合 IDとする為ユーザコマンド先で-10
		@Get_emo_info($bs_cha_num[0+L[0]], $bs_emo01_num[0+L[0]], $bs_action01[0+L[0]], L[0], 0, $bs_pose_info[0+L[0]], $bs_del_decide[0+L[0]])
		@Get_emo_info($bs_cha_num[0+L[0]], $bs_emo02_num[0+L[0]], $bs_action02[0+L[0]], L[0], 1, $bs_pose_info[0+L[0]], $bs_del_decide[0+L[0]])
//		@Get_emo_info($bs_cha_num[0+L[0]], $bs_emo03_num[0+L[0]], $bs_action03[0+L[0]], L[0], 2, $bs_pose_info[0+L[0]])
	}

}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット中心補正座標設定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z11
command $$bs_rotate
{

	$sys_addlc[0] = @Init $sys_addlc[1] = @Init

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		// 拡大縮小
		if ((($bs_action01[0+L[0]] == "h") || ($bs_action01[0+L[0]] == "i") || ($bs_action01[0+L[0]] == "j") || ($bs_action01[0+L[0]] == "k")) ||
		    (($bs_action02[0+L[0]] == "h") || ($bs_action02[0+L[0]] == "i") || ($bs_action02[0+L[0]] == "j") || ($bs_action02[0+L[0]] == "k")) ||
		    (($bs_action03[0+L[0]] == "h") || ($bs_action03[0+L[0]] == "i") || ($bs_action03[0+L[0]] == "j") || ($bs_action03[0+L[0]] == "k")))	{
			switch ($bs_size_info[0+L[0]]) 	{
				case ("1") $sys_addlc[0] = 0 $sys_addlc[1] = 100
				case ("2") $sys_addlc[0] = 0 $sys_addlc[1] = 100
				case ("3") $sys_addlc[0] = 0 $sys_addlc[1] = 100
			}
		}
		// 回転
		elseif ((($bs_action01[0+L[0]] == "t") || ($bs_action01[0+L[0]] == "u")) ||
		        (($bs_action02[0+L[0]] == "t") || ($bs_action02[0+L[0]] == "u")) ||
		        (($bs_action03[0+L[0]] == "t") || ($bs_action03[0+L[0]] == "u")))	{
			switch ($bs_size_info[0+L[0]]) 	{
				case ("1") $sys_addlc[0] = 0 $sys_addlc[1] = 300
				case ("2") $sys_addlc[0] = 0 $sys_addlc[1] = 300
				case ("3") $sys_addlc[0] = 0 $sys_addlc[1] = 300
			}
		}

		//
		// 動きを同期させる為に、バストショットとエモーションの中心補正座標が同じになるように調整
		//

		if ($sys_addlc[0] + $sys_addlc[1] != 0)	{
			$chara_center_rep_x_next[$bs_cha_num[0+L[0]]] = $sys_addlc[0]
			$chara_center_rep_y_next[$bs_cha_num[0+L[0]]] = $sys_addlc[1]
			$chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]] = ($bs_posx_next[0+L[0]] + $sys_addlc[0]) - ($bs_emo01_posx_next[0+L[0]] + $bs_posx_next[0+L[0]])
			$chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]] = ($bs_posy_next[0+L[0]] + $sys_addlc[1]) - ($bs_emo01_posy_next[0+L[0]] + $bs_posy_next[0+L[0]])
			$chara_emo02_center_rep_x_next[$bs_cha_num[0+L[0]]] = ($bs_posx_next[0+L[0]] + $sys_addlc[0]) - ($bs_emo02_posx_next[0+L[0]] + $bs_posx_next[0+L[0]])
			$chara_emo02_center_rep_y_next[$bs_cha_num[0+L[0]]] = ($bs_posy_next[0+L[0]] + $sys_addlc[1]) - ($bs_emo02_posy_next[0+L[0]] + $bs_posy_next[0+L[0]])
			$chara_emo03_center_rep_x_next[$bs_cha_num[0+L[0]]] = ($bs_posx_next[0+L[0]] + $sys_addlc[0]) - ($bs_emo03_posx_next[0+L[0]] + $bs_posx_next[0+L[0]])
			$chara_emo03_center_rep_y_next[$bs_cha_num[0+L[0]]] = ($bs_posy_next[0+L[0]] + $sys_addlc[1]) - ($bs_emo03_posy_next[0+L[0]] + $bs_posy_next[0+L[0]])
		}
		else	{
			$chara_center_rep_x_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_center_rep_y_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_emo02_center_rep_x_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_emo02_center_rep_y_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_emo03_center_rep_x_next[$bs_cha_num[0+L[0]]] = @Init
			$chara_emo03_center_rep_y_next[$bs_cha_num[0+L[0]]] = @Init
		}

	}

}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット表示
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z12
command $$bs_wipe
{

	// バストショット演出速度
	if (@BsFadeState == @Def)	{
		// 通常
	}
	elseif (@BsFadeState == @Fast)	{
		// 高速
		for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
			$posx_speed[0+L[0]] /= 2
			$posy_speed[0+L[0]] /= 2
		}
	}
	elseif (@BsFadeState == @Inst)	{
		// 瞬時
		for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
			$posx_speed[0+L[0]] = 0
			$posy_speed[0+L[0]] = 0
		}
	}

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		// 顔パーツと身体パーツ用オブジェクト
		@b.obj[$bs_cha_num[0+L[0]]].init
		@b.obj[$bs_cha_num[0+L[0]]].disp = @On
		@b.obj[$bs_cha_num[0+L[0]]].@cd.resize(10)

		// 服装一括制御判定
		$dress_control(L[0])

		// バストショットが指定されていれば読み込み
		if ($bs_exist_decide[0+L[0]] != 0)	{
			// 前回表示されていないキャラはprevとnextの座標を同様にする
			if (@f.obj[$bs_cha_num[0+L[0]] + @OBJ_BS_DUMMY01].get_file_name == "")	{
				$chara_posx_prev[$bs_cha_num[0+L[0]]] = $bs_posx_next[0+L[0]]
				$chara_posy_prev[$bs_cha_num[0+L[0]]] = $bs_posy_next[0+L[0]]
				$chara_posx_next[$bs_cha_num[0+L[0]]] = $bs_posx_next[0+L[0]]
				$chara_posy_next[$bs_cha_num[0+L[0]]] = $bs_posy_next[0+L[0]]
			}
			// ファイル名がBSX_XX9999で無ければbackに読み込み
			if ($bs_del_decide[0+L[0]] != 0)	{
				@b.obj[$bs_cha_num[0+L[0]] + @OBJ_BS_DUMMY01].create(bs_dummy, @Off, 0, 0)
				// トーンカーブ
				if ($bg_time_set != -1)	{
					if (($bs_name_info[0+L[0]] == "KN") && (($bs_pose_info[0+L[0]] == "03") || ($bs_pose_info[0+L[0]] == "12")))	{
						// かなで正面／斜めでハンドソニックを構えている時、ハンドソニックはトーンカーブ合成処理をしない
					}
					else	{
						@b.obj[$bs_cha_num[0+L[0]]].tonecurve_no = $bg_time_set
					}
				}
				// 身体
				K[0] = $bs_name[0+L[0]].left(4) + $bs_name_info[0+L[0]] + $bs_dress_info[0+L[0]] + $bs_pose_info[0+L[0]] + "01"
				// 表情
				$face_sel(L[0])
				K[1] = $bs_name[0+L[0]].left(4) + $bs_name_info[0+L[0]] + "01" + $bs_face_disp_num[0+L[0]] + "_f"
				// バストショット合成
				$bs_face_num  = $bs_face_info[0+L[0]].tonum - 1

				// かなで・赤目天使正面／斜めでハンドソニックを構えている時、ハンドソニックを加算合成処理 todo 昼用と夜用に分ける
				if ((($bs_name_info[0+L[0]] == "KN") || ($bs_name_info[0+L[0]] == "A1") || ($bs_name_info[0+L[0]] == "A2")) && (($bs_pose_info[0+L[0]] == "03") || ($bs_pose_info[0+L[0]] == "12")))	{
					if ($bg_time_set == 0)	{
						// ハンドソニック夜用
						K[3] = "_h2"
					}
					else	{
						// ハンドソニック通常用
						K[3] = "_h1"
					}
					K[2] = $bs_name[0+L[0]].left(4) + $bs_name_info[0+L[0]] + "01" + $bs_face_disp_num[0+L[0]] + K[3]
					@b.obj[$bs_cha_num[0+L[0]]].@cd[1].create(K[2], @On, 0, 0)
					@b.obj[$bs_cha_num[0+L[0]]].@cd[1].blend = 1
				}

				// 口元個別指定無し
				if ($bs_mouth_info[0+L[0]] == "_XX")	{
					@b.obj[$bs_cha_num[0+L[0]]].@cd[0].create(K[0] + "|" + K[1] + "(0, 0, " + math.tostr($bs_face_num) + ")", @On, 0, 0)
				}
				// 口元個別指定あり
				else	{
					$bs_mouth_num = $bs_mouth_info[0+L[0]].tonum - 1
					K[2] = $bs_name[0+L[0]].left(4) + $bs_name_info[0+L[0]] + "01" + $bs_mouth_disp_num[0+L[0]] + "_m"
					@b.obj[$bs_cha_num[0+L[0]]].@cd[0].create(K[0] + "|" + K[1] + "(0, 0, " + math.tostr($bs_face_num) + ")" + "|" + K[2] + "(0, 0, " + math.tostr($bs_mouth_num) + ")", @On, 0, 0)
				}

				// かなで・赤目天使正面／斜めでハンドソニックを構えている時、ハンドソニックはトーンカーブ合成処理をしない
				if ((($bs_name_info[0+L[0]] == "KN") || ($bs_name_info[0+L[0]] == "A1") || ($bs_name_info[0+L[0]] == "A2")) && (($bs_pose_info[0+L[0]] == "03") || ($bs_pose_info[0+L[0]] == "12")))	{
					@b.obj[$bs_cha_num[0+L[0]]].@cd[0].tonecurve_no = $bg_time_set
				}


				//
				// 合成前のファイルネームを取得しておく
				//

				$cha_name_prev[0+L[0]] = $bs_name[0+L[0]]

				//
				// キャラごとに存在しない表情パターン番号が指定されたらエラー表示する <-表情追加があるため保留
				//

				@b.obj[$bs_cha_num[0+L[0]]].@cd[0].tr = $bs_tr_next[0+L[0]]
				@b.obj[$bs_cha_num[0+L[0]]].@cd[1].tr = $bs_tr_next[0+L[0]]

				@b.obj[$bs_cha_num[0+L[0]]].x = $chara_posx_prev[$bs_cha_num[0+L[0]]]
				@b.obj[$bs_cha_num[0+L[0]]].y = $chara_posy_prev[$bs_cha_num[0+L[0]]]

				@b.obj[$bs_cha_num[0+L[0]]].layer = $chara_layer_next[$bs_cha_num[0+L[0]]]

				@b.obj[$bs_cha_num[0+L[0]]].center_rep_x = $chara_center_rep_x_next[$bs_cha_num[0+L[0]]]
				@b.obj[$bs_cha_num[0+L[0]]].center_rep_y = $chara_center_rep_y_next[$bs_cha_num[0+L[0]]]

				@b.obj[$bs_cha_num[0+L[0]]].rotate_z = $chara_rotate_z_prev[$bs_cha_num[0+L[0]]]

				@b.obj[$bs_cha_num[0+L[0]]].scale_x = $chara_scale_x_prev[$bs_cha_num[0+L[0]]]
				@b.obj[$bs_cha_num[0+L[0]]].scale_y = $chara_scale_y_prev[$bs_cha_num[0+L[0]]]

				@b.obj[$bs_cha_num[0+L[0]]].disp  = @On

				// 指定エモーション01
				if (($bs_emo01_exist[0+L[0]] == @On) && (@EmDispState == @On))	{
					// omv
					if ($bs_emo01_num[0+L[0]] != 21)	{
						if ($bs_emo01_loop[0+L[0]] == @On)	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].create_movie_loop($bs_emo01[0+L[0]])
							// 炎はキャラの全面にも表示
							if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].create_movie_loop($bs_emo01[0+L[0]])
							}
						}
						else	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].create_movie($bs_emo01[0+L[0]], @On, 0, 0, auto_free = @Off)
						}
						// 炎は加算
						if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].blend = 1
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].blend = 1
						}
						// 炎、キラキラは倍表示
						if (($bs_emo01_num[0+L[0]] == 37) || ($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].set_scale(2000, 2000)
							// 炎はキャラの全面にも表示
							if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].set_scale(2000, 2000)
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].tr = 100
							}
						}
					}
					else	{
						// 21 集中線はganアニメで
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].create($bs_emo01[0+L[0]])
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].load_gan($bs_emo01[0+L[0]])
					}
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].x = $chara_posx_prev[$bs_cha_num[0+L[0]]] + $bs_emo01_posx_next[0+L[0]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].y = $chara_posy_prev[$bs_cha_num[0+L[0]]] + $bs_emo01_posy_next[0+L[0]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].layer = $chara_emo01_layer_next[$bs_cha_num[0+L[0]]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].disp = @On
					if ($bs_emo01_num[0+L[0]] == 21)	{
						// 21 集中線はganアニメで
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].start_gan(0, $bs_emo01_loop[0+L[0]])
					}
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].center_rep_x = $chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].center_rep_y = $chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].rotate_z = $chara_rotate_z_prev[$bs_cha_num[0+L[0]]]
					if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
						// 炎はキャラの全面にも表示
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x = $chara_posx_prev[$bs_cha_num[0+L[0]]] + $bs_emo01_posx_next[0+L[0]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y = $chara_posy_prev[$bs_cha_num[0+L[0]]] + $bs_emo01_posy_next[0+L[0]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].layer = $chara_emo01_layer_next[$bs_cha_num[0+L[0]]] + 2
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].disp = @On
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_x = $chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_y = $chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].rotate_z = $chara_rotate_z_prev[$bs_cha_num[0+L[0]]]
					}

					// 位置移動判定
					if ($bs_defwipe_all == @On)	{
						// バストショット移動表示
						if ($bs_defwipe == @Off)	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo01_posx_next[0+L[0]] + L[1], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo01_posy_next[0+L[0]] + L[1], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
							if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo01_posx_next[0+L[0]] + L[1], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo01_posy_next[0+L[0]] + L[1], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
							}
						}
						// バストショット標準表示
						else	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].x = $bs_posx_next[0+L[0]] + $bs_emo01_posx_next[0+L[0]]
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].y = $bs_posy_next[0+L[0]] + $bs_emo01_posy_next[0+L[0]]
							if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x = $bs_posx_next[0+L[0]] + $bs_emo01_posx_next[0+L[0]]
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y = $bs_posy_next[0+L[0]] + $bs_emo01_posy_next[0+L[0]]
							}
						}
					}
					else	{
						// バストショット標準表示
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo01_posx_next[0+L[0]] + L[1], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo01_posy_next[0+L[0]] + L[1], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
						if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo01_posx_next[0+L[0]] + L[1], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo01_posy_next[0+L[0]] + L[1], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
						}
					}
				}
				// 指定エモーション02
				if (($bs_emo02_exist[0+L[0]] == @On) && (@EmDispState == @On))	{
					// omv
					if ($bs_emo02_num[0+L[0]] != 21)	{
						if ($bs_emo02_loop[0+L[0]] == @On)	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].create_movie_loop($bs_emo02[0+L[0]])
							// 炎はキャラの全面にも表示
							if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].create_movie_loop($bs_emo02[0+L[0]])
							}
						}
						else	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].create_movie($bs_emo02[0+L[0]], @On, 0, 0, auto_free = @Off)
						}
						// 炎は加算
						if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].blend = 1
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].blend = 1
						}
						// 炎、キラキラは倍表示
						if (($bs_emo02_num[0+L[0]] == 37) || ($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].set_scale(2000, 2000)
							// 炎はキャラの全面にも表示
							if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].set_scale(2000, 2000)
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].tr = 100
							}
						}
					}
					else	{
						// 21 集中線はganアニメで
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].create($bs_emo02[0+L[0]])
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].load_gan($bs_emo02[0+L[0]])
					}
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].x = $chara_posx_prev[$bs_cha_num[0+L[0]]] + $bs_emo02_posx_next[0+L[0]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].y = $chara_posy_prev[$bs_cha_num[0+L[0]]] + $bs_emo02_posy_next[0+L[0]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].layer = $chara_emo02_layer_next[$bs_cha_num[0+L[0]]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].disp = @On
					if ($bs_emo02_num[0+L[0]] == 21)	{
						// 21 集中線はganアニメで
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].start_gan(0, $bs_emo02_loop[0+L[0]])
					}
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].center_rep_x = $chara_emo02_center_rep_x_next[$bs_cha_num[0+L[0]]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].center_rep_y = $chara_emo02_center_rep_y_next[$bs_cha_num[0+L[0]]]
					@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].rotate_z = $chara_rotate_z_prev[$bs_cha_num[0+L[0]]]
					if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
						// 炎はキャラの全面にも表示
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x = $chara_posx_prev[$bs_cha_num[0+L[0]]] + $bs_emo02_posx_next[0+L[0]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y = $chara_posy_prev[$bs_cha_num[0+L[0]]] + $bs_emo02_posy_next[0+L[0]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].layer = $chara_emo02_layer_next[$bs_cha_num[0+L[0]]] + 2
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].disp = @On
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_x = $chara_emo02_center_rep_x_next[$bs_cha_num[0+L[0]]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_y = $chara_emo02_center_rep_y_next[$bs_cha_num[0+L[0]]]
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].rotate_z = $chara_rotate_z_prev[$bs_cha_num[0+L[0]]]
					}

					// 位置移動判定
					if ($bs_defwipe_all == @On)	{
						// バストショット移動表示
						if ($bs_defwipe == @Off)	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo02_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo02_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
							if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo02_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo02_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
							}
						}
						// バストショット標準表示
						else	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].x = $bs_posx_next[0+L[0]] + $bs_emo02_posx_next[0+L[0]]
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].y = $bs_posy_next[0+L[0]] + $bs_emo02_posy_next[0+L[0]]
							if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x = $bs_posx_next[0+L[0]] + $bs_emo02_posx_next[0+L[0]]
								@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y = $bs_posy_next[0+L[0]] + $bs_emo02_posy_next[0+L[0]]
							}
						}
					}
					else	{
						// バストショット標準表示
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo02_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
						@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo02_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
						if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x_eve.set($bs_posx_next[0+L[0]] + $bs_emo02_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
							@b.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y_eve.set($bs_posy_next[0+L[0]] + $bs_emo02_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
						}
					}
				}
				// 指定アクション開始[back] エモーションを表示する場合は、追従するようにする
				if ($bs_action01[0+L[0]] != "")	{
					@bs_action_start($bs_cha_num[0+L[0]], $bs_action01[0+L[0]], L[0], 0, 0, $bs_action_time01[0+L[0]], $bs_action_end_time01[0+L[0]])
				}
				if ($bs_action02[0+L[0]] != "")	{
					@bs_action_start($bs_cha_num[0+L[0]], $bs_action02[0+L[0]], L[0], 0, 1, $bs_action_time02[0+L[0]], $bs_action_end_time02[0+L[0]])
				}
				// 位置移動判定
				if ($bs_defwipe_all == @On)	{
					// バストショット移動表示
					if ($bs_defwipe == @Off)	{
						@b.obj[$bs_cha_num[0+L[0]]].x_eve.set($bs_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
						@b.obj[$bs_cha_num[0+L[0]]].y_eve.set($bs_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
					}
					// バストショット標準表示
					else	{
						@b.obj[$bs_cha_num[0+L[0]]].x = $bs_posx_next[0+L[0]]
						@b.obj[$bs_cha_num[0+L[0]]].y = $bs_posy_next[0+L[0]]
					}
				}
				else	{
					// バストショット標準表示
					@b.obj[$bs_cha_num[0+L[0]]].x_eve.set($bs_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
					@b.obj[$bs_cha_num[0+L[0]]].y_eve.set($bs_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
				}
			}
			else	{
				$bs_name_info[0+L[0]] = ""
				$bs_name_info_prev[0+L[0]] = ""
			}
			
			// 指定アクション開始[front] エモーションを表示する場合は、追従するようにする
			if ($bs_action01[0+L[0]] != "")	{
				@bs_action_start($bs_cha_num[0+L[0]], $bs_action01[0+L[0]], L[0], 1, 0, $bs_action_time01[0+L[0]], $bs_action_end_time01[0+L[0]])
				if (($bs_emo01_num[0+L[0]] == 38) || ($bs_emo01_num[0+L[0]] == 40))	{
					@bs_action_start($bs_cha_num[0+L[0]], $bs_action01[0+L[0]], L[0], 1, 2, $bs_action_time01[0+L[0]], $bs_action_end_time01[0+L[0]])
				}
			}
			if ($bs_action02[0+L[0]] != "")	{
				@bs_action_start($bs_cha_num[0+L[0]], $bs_action02[0+L[0]], L[0], 1, 1, $bs_action_time02[0+L[0]], $bs_action_end_time02[0+L[0]])
				if (($bs_emo02_num[0+L[0]] == 38) || ($bs_emo02_num[0+L[0]] == 40))	{
					@bs_action_start($bs_cha_num[0+L[0]], $bs_action01[0+L[0]], L[0], 1, 2, $bs_action_time01[0+L[0]], $bs_action_end_time01[0+L[0]])
				}
			}
			// 位置移動判定
			if ($bs_defwipe_all == @On)	{
				if ($bs_defwipe == @Off)	{
					// バストショット位置移動
					@f.obj[$bs_cha_num[0+L[0]]].x_eve.set($bs_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
					@f.obj[$bs_cha_num[0+L[0]]].y_eve.set($bs_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
					@f.obj[$bs_cha_num[0+L[0]]].center_rep_x = $chara_center_rep_x_next[$bs_cha_num[0+L[0]]]
					@f.obj[$bs_cha_num[0+L[0]]].center_rep_y = $chara_center_rep_y_next[$bs_cha_num[0+L[0]]]
					// 指定エモーション01
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].x_eve.set($bs_posx_next[0+L[0]] + $chara_emo01_posx_prev[$bs_cha_num[0+L[0]]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].y_eve.set($bs_posy_next[0+L[0]] + $chara_emo01_posy_prev[$bs_cha_num[0+L[0]]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].center_rep_x = $chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]]
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].center_rep_y = $chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]]
					// 指定エモーション02
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].x_eve.set($bs_posx_next[0+L[0]] + $chara_emo02_posx_prev[$bs_cha_num[0+L[0]]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].y_eve.set($bs_posy_next[0+L[0]] + $chara_emo02_posy_prev[$bs_cha_num[0+L[0]]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].center_rep_x = $chara_emo02_center_rep_x_next[$bs_cha_num[0+L[0]]]
					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].center_rep_y = $chara_emo02_center_rep_y_next[$bs_cha_num[0+L[0]]]
					// 指定エモーション03
//					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x_eve.set($bs_posx_next[0+L[0]] + $chara_emo01_posx_prev[$bs_cha_num[0+L[0]]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
//					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y_eve.set($bs_posy_next[0+L[0]] + $chara_emo01_posy_prev[$bs_cha_num[0+L[0]]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
//					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_x = $chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]]
//					@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_y = $chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]]
				}
				else	{
					// バストショット位置移動
				}
			}
			else	{
				// バストショット移動表示
				@f.obj[$bs_cha_num[0+L[0]]].x_eve.set($bs_posx_next[0+L[0]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
				@f.obj[$bs_cha_num[0+L[0]]].y_eve.set($bs_posy_next[0+L[0]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
				@f.obj[$bs_cha_num[0+L[0]]].center_rep_x = $chara_center_rep_x_next[$bs_cha_num[0+L[0]]]
				@f.obj[$bs_cha_num[0+L[0]]].center_rep_y = $chara_center_rep_y_next[$bs_cha_num[0+L[0]]]
				// 指定エモーション01
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].x_eve.set($bs_posx_next[0+L[0]] + $chara_emo01_posx_prev[$bs_cha_num[0+L[0]]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].y_eve.set($bs_posy_next[0+L[0]] + $chara_emo01_posy_prev[$bs_cha_num[0+L[0]]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].center_rep_x = $chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]]
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO01].center_rep_y = $chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]]
				// 指定エモーション02
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].x_eve.set($bs_posx_next[0+L[0]] + $chara_emo02_posx_prev[$bs_cha_num[0+L[0]]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].y_eve.set($bs_posy_next[0+L[0]] + $chara_emo02_posy_prev[$bs_cha_num[0+L[0]]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].center_rep_x = $chara_emo02_center_rep_x_next[$bs_cha_num[0+L[0]]]
				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO02].center_rep_y = $chara_emo02_center_rep_y_next[$bs_cha_num[0+L[0]]]

				// 指定エモーション03
//				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].x_eve.set($bs_posx_next[0+L[0]] + $chara_emo01_posx_prev[$bs_cha_num[0+L[0]]], $posx_speed[L[0]], $posx_speed_delay[L[0]], $posx_speed_mod[L[0]])
//				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].y_eve.set($bs_posy_next[0+L[0]] + $chara_emo01_posy_prev[$bs_cha_num[0+L[0]]], $posy_speed[L[0]], $posy_speed_delay[L[0]], $posy_speed_mod[L[0]])
//				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_x = $chara_emo01_center_rep_x_next[$bs_cha_num[0+L[0]]]
//				@f.obj[$bs_cha_num[0+L[0]]+@OBJ_EMO03].center_rep_y = $chara_emo01_center_rep_y_next[$bs_cha_num[0+L[0]]]


			}
		}
	}

	//
	// 表示
	//

	// ワイプを待たない
	$wipe_wait = @Off

	// スライド
	$bs_defwipe = $bs_defwipe_all

	if ($bs_type == _type_bs01)	{
		// 表示
		$wipe($bs_wipe_set)
	}

	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		if (@f.obj[@OBJ_BS_DUMMY01+L[0]].get_file_name == "")	{
			$bs_name_prev[0+L[0]] = ""
		}
	}

}




//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// バストショット表示情報
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#z13
command $$bs_disp_info
{

	// バストショットとエモーションの座標取得
	if ($bs_clear_all == @Off)	{
		for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
			$chara_posx_prev[$bs_cha_num[0+L[0]]]       = @f.obj[$bs_cha_num[0+L[0]]].x
			$chara_posy_prev[$bs_cha_num[0+L[0]]]       = @f.obj[$bs_cha_num[0+L[0]]].y
//			$chara_layer_prev[$bs_cha_num[0+L[0]]]      = @f.obj[$bs_cha_num[0+L[0]]].layer
			$chara_emo01_posx_prev[$bs_cha_num[0+L[0]]] = $bs_emo01_posx_next[0+L[0]]
			$chara_emo01_posy_prev[$bs_cha_num[0+L[0]]] = $bs_emo01_posy_next[0+L[0]]
			$chara_emo02_posx_prev[$bs_cha_num[0+L[0]]] = $bs_emo02_posx_next[0+L[0]]
			$chara_emo02_posy_prev[$bs_cha_num[0+L[0]]] = $bs_emo02_posy_next[0+L[0]]
			$chara_emo03_posx_prev[$bs_cha_num[0+L[0]]] = $bs_emo03_posx_next[0+L[0]]
			$chara_emo03_posy_prev[$bs_cha_num[0+L[0]]] = $bs_emo03_posy_next[0+L[0]]
			$chara_rotate_z_prev[$bs_cha_num[0+L[0]]]   = $bs_action_rotate_z_next[0+L[0]]
			$chara_scale_x_prev[$bs_cha_num[0+L[0]]]    = @f.obj[$bs_cha_num[0+L[0]]].scale_x
			$chara_scale_y_prev[$bs_cha_num[0+L[0]]]    = @f.obj[$bs_cha_num[0+L[0]]].scale_y
		}
	}



	// キャラクターのレイヤー値を初期化
	for (L[0] = 0, L[0] < @cha_maxenter, L[0] += 1)	{
		$chara_layer_next[10+L[0]] = @Init
	}
	// バストショットアクション情報を初期化
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_action_set[0+L[0]] = @Off
		$bs_action_rotate_z_next[0+L[0]] = @Off
	}
	// バストショット情報初期化
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_cha_num[0+L[0]] = @Init
	}

}


