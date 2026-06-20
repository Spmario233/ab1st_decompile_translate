/********************************************************
*														*
*						顔グラ表示						*
*														*
*********************************************************/
#z00
"_basic.inc"
command	$set_face(property $cha_face : str, property $face_no : int)
{

	$bs_name[0] = $cha_face

	// 表示テスト
	$_K[29] = $bs_name[0]

	// サイズ "BS1"_YR0101
	switch ($bs_name[0].left(3))	{
		case ("bs1") $bs_size_info[0] = "1"	// 通常
		case ("bs2") $bs_size_info[0] = "2"	// 近接
		case ("bs3") $bs_size_info[0] = "3"	// 至近
		default
		             // "BS1_"を省略した場合の処理／初期値を入れておく
		             if ($bs_name[0].cnt != 2)	{
			             $bs_size_info[0] = "1" $bs_name[0] = "bs1_" + $bs_name[0]
						 $bs_name_decide[+L[0]] = @On
					 }
	}

	// 背景時刻判定
	$bs_tone_set($bg_name[0])

	// バストショットネーム BS1_"YR"0101
	$bs_name_info[0] = $bs_name[0].mid(4, 2)
	// バストショットポーズ BS1_YR"01"01
	$bs_pose_info[0] = $bs_name[0].mid(6, 2)
	// バストショット表情   BS1_YR01"01"
	$bs_face_info[0] = $bs_name[0].mid(8, 2)
	// バストショット口元	BS1_YR0101_"02"
	if ($bs_name[0].mid(10, 1) == "_")	{
		$bs_mouth_info[0] = $bs_name[0].mid(11, 2)
	}
	else	{
		$bs_mouth_info[0] = "_XX"
	}

	// 服装一括指定
	$dress_control(0)
	// 身体
	K[0] = $bs_name[0].left(4) + $bs_name_info[0] + $bs_dress_info[0] + $bs_pose_info[0] + "01"
	// 表情
	$face_sel(0)

	// 顔ベースと表情の合成処理 2013.2.16
	L[10] = $bs_face_info[0].tonum - 1
	K[10] = math.tostr(L[10])

	K[1] = $bs_name[0].left(4) + $bs_name_info[0] + "01" + $bs_face_disp_num[0] + "_f"

	// バストショット合成
	$bs_face_num  = $bs_face_info[0+L[0]].tonum - 1

	// 口元個別指定無し
	if ($bs_mouth_info[0] == "_XX")	{
		S[0] = K[0] + "|" + K[1] + "(0,0," + K[10] + ")"
	}
	// 口元個別指定あり
	else	{
		$bs_mouth_num = $bs_mouth_info[0].tonum - 1
		K[2] = $bs_name[0].left(4) + $bs_name_info[0] + "01" + $bs_mouth_disp_num[0] + "_m"
		S[0] = K[0] + "|" + K[1] + "(0, 0, " + math.tostr($bs_face_num) + ")" + "|" + K[2] + "(0, 0, " + math.tostr($bs_mouth_num) + ")"
	}

	// かなで正面／斜めでハンドソニックを構えている時、ハンドソニックを加算合成処理
	if (($bs_name_info[0] == "KN") && (($bs_pose_info[0] == "03") || ($bs_pose_info[0] == "12")))	{
		S[2] = $bs_name[0].left(4) + $bs_name_info[0] + "01" + $bs_face_disp_num[0] + "_h"
		set_face(1, S[2])

	}


	set_face(0, S[0])

	// キャラごとの顔グラ表示座標修正
	switch ($bs_name_info[0])	{
		case ("OT")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 70   L[3] = 130
			}
			else	{
				// 斜め
				L[2] = 77+7 L[3] = 130
			}
		case ("KN")
			if ($bs_pose_info[0].tonum < 9)	{
				// 正面
				L[2] = 70   L[3] = 0
			}
			else	{
				// 正面
				L[2] = 70+7 L[3] = 0
			}
		case ("YR")
			if ($bs_pose_info[0].tonum < 4)	{
				// 正面
				L[2] = 65   L[3] = 60
			}
			else	{
				// 斜め
				L[2] = 65+7 L[3] = 60
			}
		case ("HN")
			if (($bs_pose_info[0].tonum < 4) || ($bs_pose_info[0].tonum == 6))	{
				// 正面
				L[2] = 70   L[3] = 130
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 130
			}
		case ("YI")
			if ($bs_pose_info[0].tonum < 4)	{
				// 正面
				L[2] = 70   L[3] = 10
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 10
			}
		case ("IW")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 65   L[3] = 60
			}
			else	{
				// 斜め
				L[2] = 65+7 L[3] = 60
			}
		case ("MT")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 70   L[3] = 180
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 180
			}
		case ("MS")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 60   L[3] = 180
			}
			else	{
				// 斜め
				L[2] = 60+7 L[3] = 180
			}
		case ("ND")
			if (($bs_pose_info[0].tonum < 3) || ($bs_pose_info[0].tonum == 7))	{
				// 正面
				L[2] = 70   L[3] = 150
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 150
			}
		case ("TM")
			if ($bs_pose_info[0].tonum < 4)	{
				// 正面
				L[2] = 65   L[3] = 150
			}
			else	{
				// 斜め
				L[2] = 65+7 L[3] = 150
			}
		case ("OY")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 70   L[3] = 100
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 100
			}
		case ("FJ")
			if ($bs_pose_info[0].tonum < 5)	{
				// 正面
				L[2] = 70   L[3] = 135
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 135
			}
		case ("TK")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 60   L[3] = 150
			}
			else	{
				// 斜め
				L[2] = 60+7 L[3] = 150
			}
		case ("SN")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 70   L[3] = 70
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 70
			}
		case ("YS")
			// 斜め
			L[2] = 60+7 L[3] = 50
		case ("HS")
			// 正面
			L[2] = 65   L[3] = 75
		case ("SK")
			// 斜め
			L[2] = 70+7 L[3] = 55
		case ("IR")
			// 正面
			L[2] = 90+7 L[3] = 40
		case ("CH")
			// 斜め
			L[2] = 70+7 L[3] = 150
		case ("TY")
			// 正面
			L[2] = 70 L[3] =  30
		case ("NA")
			if ($bs_pose_info[0].tonum < 3)	{
				// 正面
				L[2] = 70   L[3] = 100
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 100
			}
		case ("ST")
			L[2] = 70 L[3] = 130
		case ("IG")
			if ($bs_pose_info[0].tonum < 2)	{
				// 正面
				L[2] = 70   L[3] = 135
			}
			else	{
				// 斜め
				L[2] = 70+7 L[3] = 130
			}
		case ("A1")
			if ($bs_pose_info[0].tonum < 9)	{
				// 正面
				L[2] = 70   L[3] = 0
			}
			else	{
				// 正面
				L[2] = 70+7 L[3] = 0
			}
		case ("A2")
			if ($bs_pose_info[0].tonum < 9)	{
				// 正面
				L[2] = 70   L[3] = 0
			}
			else	{
				// 正面
				L[2] = 70+7 L[3] = 0
			}
	}
	@f.mwnd[$get_mwnd_no].face[0].x_rep.resize(1)
	@f.mwnd[$get_mwnd_no].face[0].y_rep.resize(1)
	@f.mwnd[$get_mwnd_no].face[0].x_rep[0] = L[2]
	@f.mwnd[$get_mwnd_no].face[0].y_rep[0] = L[3]
	@f.mwnd[$get_mwnd_no].face[0].tonecurve_no = $bg_time_set
	@f.mwnd[$get_mwnd_no].face[0].layer = 1000

	// かなで正面／斜めでハンドソニックを構えている時、ハンドソニックを加算合成処理
	if (($bs_name_info[0] == "KN") && (($bs_pose_info[0] == "03") || ($bs_pose_info[0] == "12")))	{
		@f.mwnd[$get_mwnd_no].face[1].x_rep.resize(1)
		@f.mwnd[$get_mwnd_no].face[1].y_rep.resize(1)
		@f.mwnd[$get_mwnd_no].face[1].x_rep[0] = L[2]
		@f.mwnd[$get_mwnd_no].face[1].y_rep[0] = L[3]
		@f.mwnd[$get_mwnd_no].face[1].tonecurve_no = $bg_time_set
		@f.mwnd[$get_mwnd_no].face[1].layer = 1001
		@f.mwnd[$get_mwnd_no].face[1].blend = 1
	}

	// 表示範囲マスク処理
	mask[0].init
	// 野田bs1_nd010301用マスク
	if (($bs_name_info[0] == "ND") && ($bs_pose_info[0].tonum == 3))	{
		mask[0].create(bs_face_mask02)
	}
	else	{
		mask[0].create(bs_face_mask01)
	}
	@f.mwnd[$get_mwnd_no].face[0].mask_no = 0

/*
	// ウィンドウ枠判定
	switch ($waku_num)	{
		case (0)  @通常ウィンドウ＿顔グラ
		case (2)  @大声ウィンドウ＿顔グラ
		case (4)  @ひそひそウィンドウ＿顔グラ
		case (6)  @加工ウィンドウ＿顔グラ
		case (8)  
		case (10) 
		case (12) 
	}
*/

	// 初期化
	$bs_name[0] = "nothing"
	// バストショット表示情報取得
	$bs_disp_info(0)
	// バストショット表示情報初期化
	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
		$bs_name_info[0+L[0]] = ""
		$bs_name_info_prev[0+L[0]] = ""
	}

}



// キャラ表情判定
command $face_sel(property $cha_num : int)
{

	switch ($bs_name_info[0+$cha_num])	{

		// 音無
		case ("OT")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
			}

		// かなで
		case ("KN")
			// 正面
			if ($bs_pose_info[0+$cha_num].tonum <= 8)	{
				// 制服
				if (($bs_dress_info[0+$cha_num].tonum <= 2) || ($bs_dress_info[0+$cha_num].tonum == 4))	{
					$bs_face_disp_num[0+$cha_num] = "01"
				}
				// ユニフォーム
				elseif ($bs_dress_info[0+$cha_num].tonum == 3)	{
					$bs_face_disp_num[0+$cha_num] = "02"
				}
				// 麦わら帽子
				else	{
					$bs_face_disp_num[0+$cha_num] = "03"
				}
				$bs_mouth_disp_num[0+$cha_num] = "01"
			}
			// 斜め
			else	{
				// 制服／パジャマ
				if ($bs_dress_info[0+$cha_num].tonum <= 4)	{
					$bs_face_disp_num[0+$cha_num] = "09"
				}
				// 麦わら帽子
				else	{
					$bs_face_disp_num[0+$cha_num] = "10"
				}
				$bs_mouth_disp_num[0+$cha_num] = "09"
			}

		// ゆり
		case ("YR")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("04") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"
				case ("05") $bs_face_disp_num[0+$cha_num] = "05" $bs_mouth_disp_num[0+$cha_num] = "04"
				case ("06") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"
				case ("07") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"	// 銃持ち
				case ("08") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"	// ナイフ持ち
			}

		// 日向
		case ("HN")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("04") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"
				case ("05") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"
				case ("06") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"	// 追加正面
				case ("07") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "04"	// 銃持ち
			}

		// ユイ
		case ("YI")
				// 正面
				if ($bs_pose_info[0+$cha_num].tonum <= 3 || $bs_pose_info[0+$cha_num].tonum == 7)	{
					// ヘルメット
					if ($bs_dress_info[0+$cha_num].tonum == 4)	{
						$bs_face_disp_num[0+$cha_num] = "02"
					}
					// 体操服
					elseif ($bs_dress_info[0+$cha_num].tonum == 2)	{
						$bs_face_disp_num[0+$cha_num] = "08"
					}
					// 体操服ジャージ
					elseif ($bs_dress_info[0+$cha_num].tonum == 3)	{
						$bs_face_disp_num[0+$cha_num] = "08"
					}
					else	{
						$bs_face_disp_num[0+$cha_num] = "01"
					}
					$bs_mouth_disp_num[0+$cha_num] = "01"
				}
				// 斜め
				else	{
					// ヘルメット
					if ($bs_dress_info[0+$cha_num].tonum == 4)	{
						$bs_face_disp_num[0+$cha_num] = "06"
					}
					// 体操服
					elseif ($bs_dress_info[0+$cha_num].tonum == 2)	{
						$bs_face_disp_num[0+$cha_num] = "07"
					}
					// 体操服ジャージ
					elseif ($bs_dress_info[0+$cha_num].tonum == 3)	{
						$bs_face_disp_num[0+$cha_num] = "07"
					}
					else	{
						$bs_face_disp_num[0+$cha_num] = "03"
					}
					// アゴに手
					if ($bs_pose_info[0+$cha_num].tonum == 5)	{
						$bs_face_disp_num[0+$cha_num] = "04"
						$bs_mouth_disp_num[0+$cha_num] = "04"
					}
					elseif ($bs_pose_info[0+$cha_num].tonum == 6)	{
						$bs_face_disp_num[0+$cha_num] = "05"
						$bs_mouth_disp_num[0+$cha_num] = "05"
					}
					else	{
						$bs_mouth_disp_num[0+$cha_num] = "03"
					}
				}

		// 岩沢
		case ("IW")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
			}

		// 松下（太）
		case ("MT")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
			}

		// 松下（細）
		case ("MS")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
			}

		// 野田
		case ("ND")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("05") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("06") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("07") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"	// ※仁王立ち_正面
				case ("08") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"	// ※イケパイ_正面
			}

		// 高松
		case ("TM")
			// メガネ
			if (($bs_dress_info[0+$cha_num].tonum == 1) || ($bs_dress_info[0+$cha_num].tonum == 3))	{
				// 正面
				if ($bs_pose_info[0+$cha_num].tonum == 1)	{
					// 直立
					$bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				}
				elseif ($bs_pose_info[0+$cha_num].tonum == 2)	{
					// メガネくいっ
					$bs_face_disp_num[0+$cha_num] = "02" $bs_mouth_disp_num[0+$cha_num] = "02"
				}
				elseif ($bs_pose_info[0+$cha_num].tonum == 3)	{
					// アゴに手
					$bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				}
				// 斜め
				elseif ($bs_pose_info[0+$cha_num].tonum == 4)	{
					// 直立
					$bs_face_disp_num[0+$cha_num] = "07" $bs_mouth_disp_num[0+$cha_num] = "04"
				}
				elseif ($bs_pose_info[0+$cha_num].tonum == 5)	{
					// アゴに手
					$bs_face_disp_num[0+$cha_num] = "08" $bs_mouth_disp_num[0+$cha_num] = "05"
				}
			}
			// メガネ無し
			elseif ($bs_dress_info[0+$cha_num].tonum == 2)	{
				// 正面
				if ($bs_pose_info[0+$cha_num].tonum == 1)	{
					// 直立
					$bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "01"
				}
				elseif ($bs_pose_info[0+$cha_num].tonum == 2)	{
					// メガネくいっ
					$bs_face_disp_num[0+$cha_num] = "05" $bs_mouth_disp_num[0+$cha_num] = "02"
				}
				elseif ($bs_pose_info[0+$cha_num].tonum == 3)	{
					// アゴに手
					$bs_face_disp_num[0+$cha_num] = "06" $bs_mouth_disp_num[0+$cha_num] = "03"
				}
				// 斜め
				elseif ($bs_pose_info[0+$cha_num].tonum == 4)	{
					// 直立
					$bs_face_disp_num[0+$cha_num] = "09" $bs_mouth_disp_num[0+$cha_num] = "04"
				}
				elseif ($bs_pose_info[0+$cha_num].tonum == 5)	{
					// メガネくいっ
					$bs_face_disp_num[0+$cha_num] = "10" $bs_mouth_disp_num[0+$cha_num] = "05"
				}
			}

		// 大山
		case ("OY")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"

			}

		// 藤巻
		case ("FJ")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("05") $bs_face_disp_num[0+$cha_num] = "05" $bs_mouth_disp_num[0+$cha_num] = "05"
				case ("06") $bs_face_disp_num[0+$cha_num] = "05" $bs_mouth_disp_num[0+$cha_num] = "05"
				case ("07") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"	// 上半身裸
				case ("08") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"	// 上半身裸
			}

		// ＴＫ
		case ("TK")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("04") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				case ("05") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
			}

		// 椎名
		case ("SN")
			// 正面
			if ($bs_pose_info[0+$cha_num] == "01" || $bs_pose_info[0+$cha_num] == "02" || $bs_pose_info[0+$cha_num] == "05")	{	//追加：箒
				if ($bs_dress_info[0+$cha_num].tonum == 1)	{
					$bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				}
				else	{
					// マフラー
					$bs_face_disp_num[0+$cha_num] = "02" $bs_mouth_disp_num[0+$cha_num] = "02"
				}
			}
			// 斜め
			else	{
				$bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
			}
			
		// 遊佐
		case ("YS")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
			}

		// ひさ子
		case ("HS")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
			}

		// 関根
		case ("SK")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("04") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("05") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"	//追加：手の甲を返してる
			}

		// 入江
		case ("IR")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("03") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
			}

		// チャー
		case ("CH")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
			}

		// 竹山
		case ("TY")
			switch ($bs_pose_info[0+$cha_num])	{
				case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				case ("02") $bs_face_disp_num[0+$cha_num] = "02" $bs_mouth_disp_num[0+$cha_num] = "01"
			}

		// 直井
		case ("NA")

			if ($bs_pose_info[0+$cha_num]=="01" || $bs_pose_info[0+$cha_num]=="02")	{
				if ($bs_dress_info[0+$cha_num] == "01")	{	//通常
					$bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
				}
				else{
					$bs_face_disp_num[0+$cha_num] = "02" $bs_mouth_disp_num[0+$cha_num] = "01"
				}
			}
			elseif ($bs_pose_info[0+$cha_num]=="03")	{
				if ($bs_dress_info[0+$cha_num] == "01")	{	//通常
					$bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
				}
				else{											//帽子付き
					$bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "03"
				}
			}
			elseif ($bs_pose_info[0+$cha_num]=="04")	{		//手を帽子に当ててる
				$bs_face_disp_num[0+$cha_num] = "05" $bs_mouth_disp_num[0+$cha_num] = "03"		//あとでこっちに差し替え
				//$bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "03"
			}

		// フィッシュ斎藤
		case ("ST")
			$bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"

		// 五十嵐
		case ("IG")
			// 制服
			if ($bs_dress_info[0+$cha_num].tonum == 1)	{
					switch ($bs_pose_info[0+$cha_num])	{
						case ("01") $bs_face_disp_num[0+$cha_num] = "01" $bs_mouth_disp_num[0+$cha_num] = "01"
						case ("02") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
						case ("03") $bs_face_disp_num[0+$cha_num] = "03" $bs_mouth_disp_num[0+$cha_num] = "03"
					}
			}
			// 包帯
			elseif ($bs_dress_info[0+$cha_num].tonum == 2)	{
					switch ($bs_pose_info[0+$cha_num])	{
						case ("01") $bs_face_disp_num[0+$cha_num] = "02" $bs_mouth_disp_num[0+$cha_num] = "01"
						case ("02") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "03"
						case ("03") $bs_face_disp_num[0+$cha_num] = "04" $bs_mouth_disp_num[0+$cha_num] = "03"
					}
			}

		// 赤目天使１
		case ("A1")
			// 正面
			if ($bs_pose_info[0+$cha_num].tonum <= 8)	{
				// 制服／制服ボロ
				$bs_face_disp_num[0+$cha_num] = "01"
				$bs_mouth_disp_num[0+$cha_num] = "01"
			}
			// 斜め
			else	{
				// 制服／制服ボロ
				$bs_face_disp_num[0+$cha_num] = "09"
				$bs_mouth_disp_num[0+$cha_num] = "09"
			}

		// 赤目天使２
		case ("A2")
			// 正面
			if ($bs_pose_info[0+$cha_num].tonum <= 8)	{
				// 制服／制服ボロ
				$bs_face_disp_num[0+$cha_num] = "01"
				$bs_mouth_disp_num[0+$cha_num] = "01"
			}
			// 斜め
			else	{
				// 制服／制服ボロ
				$bs_face_disp_num[0+$cha_num] = "09"
				$bs_mouth_disp_num[0+$cha_num] = "09"
			}

		// 影１／影２／影３
		default
			$bs_face_disp_num[0+$cha_num] = "01"
	}
}

// キャラクター服装判定
command $dress_control(property $cha_num : int)
{

	switch ($bs_name_info[0+$cha_num])	{

		// 音無
		case ("OT")
			switch (@音無服装)	{
				case (@戦線制服)        $bs_dress_info[0+$cha_num] = "01"
				case (@戦線制服_シャツ) $bs_dress_info[0+$cha_num] = "02"
			}

		// かなで
		case ("KN")
			switch (@かなで服装)	{
				case (@ＮＰＣ制服)              $bs_dress_info[0+$cha_num] = "01"
				case (@ＮＰＣ制服_ボロボロ)     $bs_dress_info[0+$cha_num] = "02"
				case (@ＮＰＣ制服_ユニフォーム) $bs_dress_info[0+$cha_num] = "03"
				case (@パジャマ)                $bs_dress_info[0+$cha_num] = "04"
				case (@ＮＰＣ制服_麦わら帽子)   $bs_dress_info[0+$cha_num] = "05"
			}

		// ゆり
		case ("YR")
			switch (@ゆり服装)	{
				case (@戦線制服)      $bs_dress_info[0+$cha_num] = "01"
				case (@戦線制服_帽子) $bs_dress_info[0+$cha_num] = "02"
				case (@ＮＰＣ制服)    $bs_dress_info[0+$cha_num] = "03"
			}

		// 日向
		case ("HN")
			switch (@日向服装)	{
				case (@戦線制服)        $bs_dress_info[0+$cha_num] = "01"
				case (@戦線制服_シャツ) $bs_dress_info[0+$cha_num] = "02"
				case (@上半身裸)   		$bs_dress_info[0+$cha_num] = "03"		// ∀後で差し替え	差し替え済
				case (@ジャージ)        $bs_dress_info[0+$cha_num] = "04"		// ∀後で差し替え	差し替え済
				case (@ＮＰＣ制服)      $bs_dress_info[0+$cha_num] = "05"		// 追加
			}

		// ユイ
		case ("YI")
			switch (@ユイ服装)	{
				case (@戦線制服)          $bs_dress_info[0+$cha_num] = "01"
				case (@体操服)            $bs_dress_info[0+$cha_num] = "02"
				case (@体操服_ジャージ)   $bs_dress_info[0+$cha_num] = "03"
				case (@体操服_ヘルメット) $bs_dress_info[0+$cha_num] = "04"
			}

		// 岩沢
		case ("IW")
			switch (@岩沢服装)	{
				case (@戦線制服)                $bs_dress_info[0+$cha_num] = "01"
				case (@戦線制服_タートルネック) $bs_dress_info[0+$cha_num] = "02"
				case (@上半身裸) 				$bs_dress_info[0+$cha_num] = "03"
			}

		// 松下（太）
		case ("MT")
			switch (@松下服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
				case (@柔道着)   $bs_dress_info[0+$cha_num] = "02"
				case (@上半身裸) $bs_dress_info[0+$cha_num] = "03"		// ∀後で差し替え 20150421変更しました（あまの）
			}

		// 松下（細）
		case ("MS")
			switch (@松下服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
				case (@柔道着)   $bs_dress_info[0+$cha_num] = "02"
			}

		// 野田
		case ("ND")
			switch (@野田服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
				case (@上半身裸) $bs_dress_info[0+$cha_num] = "02"		// ∀後で差し替え	差し替え済
			}

		// 高松
		case ("TM")
			switch (@高松服装)	{
				case (@戦線制服)   $bs_dress_info[0+$cha_num] = "01"
				case (@ＮＰＣ制服) $bs_dress_info[0+$cha_num] = "02"
				case (@上半身裸)   $bs_dress_info[0+$cha_num] = "03"
			}

		// 大山
		case ("OY")
			switch (@大山服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
				case (@上半身裸) $bs_dress_info[0+$cha_num] = "02"
			}

		// 藤巻
		case ("FJ")
			switch (@藤巻服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
				case (@上半身裸) $bs_dress_info[0+$cha_num] = "02"
			}

		// ＴＫ
		case ("TK")
			switch (@ＴＫ服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
			}

		// 椎名
		case ("SN")
			switch (@椎名服装)	{
				case (@戦線制服)          $bs_dress_info[0+$cha_num] = "01"
				case (@戦線制服_マフラー) $bs_dress_info[0+$cha_num] = "02"
			}

		// 遊佐
		case ("YS")
			switch (@遊佐服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
			}

		// ひさ子
		case ("HS")
			switch (@ひさ子服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
			}

		// 関根
		case ("SK")
			switch (@関根服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
			}

		// 入江
		case ("IR")
			switch (@入江服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
			}

		// チャー
		case ("CH")
			$bs_dress_info[0+$cha_num] = "01"

		// 竹山
		case ("TY")
			switch (@竹山服装)	{
				case (@戦線制服) $bs_dress_info[0+$cha_num] = "01"
				case (@上半身裸) $bs_dress_info[0+$cha_num] = "02"
			}

		// 直井
		case ("NA")
			switch (@直井服装)	{
				case (@ＮＰＣ制服)      $bs_dress_info[0+$cha_num] = "01"
				case (@ＮＰＣ制服_帽子) $bs_dress_info[0+$cha_num] = "02"
			}

		// フィッシュ斎藤
		case ("ST")
			$bs_dress_info[0+$cha_num] = "01"

		// 五十嵐
		case ("IG")
			switch (@五十嵐服装)	{
				case (@制服)      $bs_dress_info[0+$cha_num] = "01"
				case (@制服_包帯) $bs_dress_info[0+$cha_num] = "02"
			}

		// 赤目天使１
		case ("A1")
			switch (@赤目天使１服装)	{
				case (@ＮＰＣ制服)              $bs_dress_info[0+$cha_num] = "01"
				case (@ＮＰＣ制服_ボロボロ)     $bs_dress_info[0+$cha_num] = "02"
			}

		// 赤目天使２
		case ("A2")
			switch (@赤目天使２服装)	{
				case (@ＮＰＣ制服)              $bs_dress_info[0+$cha_num] = "01"
				case (@ＮＰＣ制服_ボロボロ)     $bs_dress_info[0+$cha_num] = "02"
			}

		// 影１／影２／影３
		default
			$bs_dress_info[0+$cha_num] = "01"

	}

}
