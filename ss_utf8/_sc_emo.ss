/********************************************************
*														*
*			指定エモーション／アクション取得			*
*														*
*********************************************************/
#z00

/*

#inc_start

	#property	$call_bs_pose_info	: int
	#define		$call_bs_pose_info	$$bs_pose_info


	#define		$$bs_cha_num	L[0]-10	// L[0] = $bs_cha_num
	#define		$$bs_emo_num	L[1]	// L[1] = $bs_emo_num01 02 03
	#define		$$bs_action		K[0]	// K[0] = $bs_action
	#define		$$bs_maxnum		L[2]	// L[2] = @bs_maxnum
	#define		$$emo_num		L[3]
	#define		$$bs_del_decide	L[4]
	#define		$$bs_pose_info	L[6]	// L[6] = $bs_pose_info	: str

#inc_end

*/

command $get_eno_info(property $$bs_cha_num      : int,
                      property $$bs_emo_num      : int,
                      property $$bs_action       : str,
                      property $$bs_maxnum       : int,
                      property $$emo_num         : int,
                      property $$bs_pose_info_m  : str,
                      property $$bs_del_decide   : int)
{

	property $$bs_pose_info : int

	// キャラID
	$$bs_cha_num -= 10

	$$bs_pose_info = $$bs_pose_info_m.tonum
	$bs_action[$$bs_maxnum] = $$bs_action

//	@debug($$bs_action)

	// アクション動作
	switch ($$bs_action)	{
		case ("")
			// 無し
		case ("a0")
			// 頷き
			$bs_action_posy_next[$$bs_maxnum] =  20
			$bs_action_time[$$bs_maxnum] =  400
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("b0")
			// お辞儀
			$bs_action_posy_next[$$bs_maxnum] =  50
			$bs_action_time[$$bs_maxnum] = 1000
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("c0")
			// プルプル（怒り、震えetc）
			$bs_action_posx_next[$$bs_maxnum] =  5
			$bs_action_time[$$bs_maxnum] =  200
			$bs_action_end_time[$$bs_maxnum] =  -1
		case ("d0")
			// 驚き（飛び上がる）
			$bs_action_posy_next[$$bs_maxnum] = -50
			$bs_action_time[$$bs_maxnum] =  200
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("e0")
			// 驚き（上下にビクビクッ）
			$bs_action_posy_next[$$bs_maxnum] = -20
			$bs_action_time[$$bs_maxnum] =  200
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("f0")
			// 喜び（バンザイ）
			$bs_action_posy_next[$$bs_maxnum] = -50
			$bs_action_time[$$bs_maxnum] =  1000
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("g0")
			// 主張（ピョンピョン）
			$bs_action_posy_next[$$bs_maxnum] = -50
			$bs_action_time[$$bs_maxnum] =  600
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("h0") 
			// 拡大縮小・弱（縮こまる、気合を入れるetc）
			$bs_action_scale_x_next[$$bs_maxnum] = 1200
			$bs_action_scale_y_next[$$bs_maxnum] = 1200
			$bs_action_time[$$bs_maxnum] =  150
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("i0")
			// 拡大縮小・強（縮こまる、気合を入れるetc）
			$bs_action_scale_x_next[$$bs_maxnum] = 500
			$bs_action_scale_y_next[$$bs_maxnum] = 500
			$bs_action_time[$$bs_maxnum] =  300
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("j0")
			// 縮小拡大
			$bs_action_scale_x_next[$$bs_maxnum] = $bs_action_scale_x_set[$$bs_maxnum]
			$bs_action_scale_y_next[$$bs_maxnum] = $bs_action_scale_y_set[$$bs_maxnum]
			$bs_action_time[$$bs_maxnum] = $bs_action_sc_time_set[$$bs_maxnum]
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("k0")
			// ルンルン（継続）
			$bs_action_posy_next[$$bs_maxnum] = 15
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  -1
		case ("l0")
			// 地団駄
			$bs_action_posy_next[$$bs_maxnum] = 30
			$bs_action_time[$$bs_maxnum] =  150 * 3
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("m0")
			// 息切れ（しこたま殴った後とか
			$bs_action_posy_next[$$bs_maxnum] = 5
			$bs_action_time[$$bs_maxnum] =  800
			$bs_action_end_time[$$bs_maxnum] =  -1
		case ("n0")
			// 軽いスクワット的な喜び？
			$bs_action_posy_next[$$bs_maxnum] = 20
			$bs_action_time[$$bs_maxnum] =  500 * 2
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("o0")
			// 左右に揺れ揺れ（否定。首を横に振る的なニュアンス）
			$bs_action_posx_next[$$bs_maxnum] = 15
			$bs_action_time[$$bs_maxnum] =  300 * 2
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("p0")
			// フラフラ
			$bs_action_posx_next[$$bs_maxnum] = 30
			$bs_action_time[$$bs_maxnum] =  1000 * 3
			$bs_action_end_time[$$bs_maxnum] =  -1
		case ("q0")
			// 弾む感じで上下に揺れる
			$bs_action_posy_next[$$bs_maxnum] = 30
			$bs_action_time[$$bs_maxnum] =  800 * 2
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("r0")
			// テレテレ
			$bs_action_posx_next[$$bs_maxnum] = 30
			$bs_action_time[$$bs_maxnum] =  300 * 3
			$bs_action_end_time[$$bs_maxnum] =  -1
		case ("s0")
			// デコピン（小突き的な）
			$bs_action_posy_next[$$bs_maxnum] = -20
			$bs_action_time[$$bs_maxnum] =  300
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("t0")
			// 回転
			$bs_action_rotate_z_next[$$bs_maxnum] = $bs_action_rotate_set[$$bs_maxnum]
			$bs_action_time[$$bs_maxnum] = $bs_action_ro_time_set[$$bs_maxnum]
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("u0")
			// 回転ループ
			$bs_action_rotate_z_next[$$bs_maxnum] = $bs_action_rotate_set[$$bs_maxnum]
			$bs_action_time[$$bs_maxnum] = $bs_action_ro_time_set[$$bs_maxnum]
			$bs_action_end_time[$$bs_maxnum] =  -1
		case ("v0")
			// 左右にビクン
			$bs_action_posx_next[$$bs_maxnum] =  30
			$bs_action_time[$$bs_maxnum] =  100
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("w0")
			// チョップ
			$bs_action_posy_next[$$bs_maxnum] = 10
			$bs_action_time[$$bs_maxnum] =  300
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("X0")
			// ブルルッ
			$bs_action_posy_next[$$bs_maxnum] = 10
			$bs_action_time[$$bs_maxnum] =  300
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
		case ("r1")
			// スライド（右）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 80
			}
			else	{
				// 表示
				L[20] = -80 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("r2")
			// スライド（右）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 160
			}
			else	{
				// 表示
				L[20] = -160 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("r3")
			// スライド（右）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 240
			}
			else	{
				// 表示
				L[20] = -240 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("r4")
			// スライド（右）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 320
			}
			else	{
				// 表示
				L[20] = -320 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("r5")
			// スライド（右）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 640
			}
			else	{
				// 表示
				L[20] = -640 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2


		case ("l1")
			// スライド（左）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -80
			}
			else	{
				// 表示
				L[20] = 80 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("l2")
			// スライド（左）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -160
			}
			else	{
				// 表示
				L[20] = 160 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("l3")
			// スライド（左）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -240
			}
			else	{
				// 表示
				L[20] = 240 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("l4")
			// スライド（左）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -320
			}
			else	{
				// 表示
				L[20] = 320 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("l5")
			// スライド（左）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -640
			}
			else	{
				// 表示
				L[20] = 640 L[21] = 0
			}
			$bs_action_posx[$$bs_maxnum] = L[20]
			$bs_action_posx_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("d1")
			// スライド（下）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 60
			}
			else	{
				// 表示
				L[20] = -60 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("d2")
			// スライド（下）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 120
			}
			else	{
				// 表示
				L[20] = -120 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("d3")
			// スライド（下）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 180
			}
			else	{
				// 表示
				L[20] = -180 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("d4")
			// スライド（下）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 240
			}
			else	{
				// 表示
				L[20] = -240 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("d5")
			// スライド（下）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = 600
			}
			else	{
				// 表示
				L[20] = -600 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("u1")
			// スライド（上）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -60
			}
			else	{
				// 表示
				L[20] = 60 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("u2")
			// スライド（上）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -120
			}
			else	{
				// 表示
				L[20] = 120 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("u3")
			// スライド（上）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -180
			}
			else	{
				// 表示
				L[20] = 180 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("u4")
			// スライド（上）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -240
			}
			else	{
				// 表示
				L[20] = 240 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

		case ("u5")
			// スライド（上）
			if ($$bs_del_decide == 0)	{
				// 消去
				L[20] = 0 L[21] = -600
			}
			else	{
				// 表示
				L[20] = 600 L[21] = 0
			}
			$bs_action_posy[$$bs_maxnum] = L[20]
			$bs_action_posy_next[$$bs_maxnum] = L[21]
			$bs_action_time[$$bs_maxnum] =  500
			$bs_action_end_time[$$bs_maxnum] =  $bs_action_time[$$bs_maxnum]
			$bs_action_mod[$$bs_maxnum] = 2

	}
	// アクションタイムの上書き防止
	    if ($$emo_num == 0)	{ $bs_action_time01[$$bs_maxnum] = $bs_action_time[$$bs_maxnum] $bs_action_end_time01[$$bs_maxnum] = $bs_action_end_time[$$bs_maxnum]}
	elseif ($$emo_num == 1)	{ $bs_action_time02[$$bs_maxnum] = $bs_action_time[$$bs_maxnum] $bs_action_end_time02[$$bs_maxnum] = $bs_action_end_time[$$bs_maxnum]}
	elseif ($$emo_num == 2)	{ $bs_action_time03[$$bs_maxnum] = $bs_action_time[$$bs_maxnum] $bs_action_end_time03[$$bs_maxnum] = $bs_action_end_time[$$bs_maxnum]}

	// エモーション指定
	switch ($$bs_emo_num)	{
		case (00) 
			// 無し
			gosub #bs_cha_num_check00
		case (01) //-----------------------------------------------------------------------------------------------------------
			// タラリ汗・右（残）
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo01a"	// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo01a"
				case (_type_imm)  S[0] = "ef_bs2_emo01a"	// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 0) #bs_cha_num_check01
		case (02) 
			// タラリ汗・右（消）
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo01b"	// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo01b"
				case (_type_imm)  S[0] = "ef_bs2_emo01b"	// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 0) #bs_cha_num_check01
		case (03) 
			// タラリ汗・左（残）
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo01a"	// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo01a"
				case (_type_imm)  S[0] = "ef_bs2_emo01a"	// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 10) #bs_cha_num_check01
		case (04) 
			// タラリ汗・左（消）
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo01b"	// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo01b"
				case (_type_imm)  S[0] = "ef_bs2_emo01b"	// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 10) #bs_cha_num_check01
		case (05) 
			// 飛び汗
			$bs_emo_loop = @On
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo02"		// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo02"
				case (_type_imm)  S[0] = "ef_bs2_emo02"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 20) #bs_cha_num_check01
		case (06) 
			// 怒り
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo03"
				case (_type_near) S[0] = "ef_bs2_emo03"
				case (_type_imm)  S[0] = "ef_bs3_emo03"
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 30) #bs_cha_num_check01
		case (07) 
			// ため息・右
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo05"
				case (_type_near) S[0] = "ef_bs2_emo05"
				case (_type_imm)  S[0] = "ef_bs2_emo05"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 40) #bs_cha_num_check01
		case (08) 
			// ため息・左
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo04"
				case (_type_near) S[0] = "ef_bs2_emo04"
				case (_type_imm)  S[0] = "ef_bs2_emo04"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 50) #bs_cha_num_check01
		case (09) 
			// ビックリ・右
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo07"		// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo07"
				case (_type_imm)  S[0] = "ef_bs2_emo07"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 60) #bs_cha_num_check01
		case (10) 
			// ビックリ・左
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo06"		// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo06"
				case (_type_imm)  S[0] = "ef_bs2_emo06"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 70) #bs_cha_num_check01
		case (11) 
			// ご機嫌・右
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo09"
				case (_type_near) S[0] = "ef_bs2_emo09"
				case (_type_imm)  S[0] = "ef_bs3_emo09"
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 80) #bs_cha_num_check01
		case (12) 
			// ご機嫌・左
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo08"
				case (_type_near) S[0] = "ef_bs2_emo08"
				case (_type_imm)  S[0] = "ef_bs3_emo08"
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 90) #bs_cha_num_check01
		case (13) 
			// ？
			$bs_emo_loop = @Off
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs2_emo10"		// 作ってないのでエラー回避
				case (_type_near) S[0] = "ef_bs2_emo10"
				case (_type_imm)  S[0] = "ef_bs2_emo10"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 100) #bs_cha_num_check01
		case (14) 
			// イライラ
			$bs_emo_loop = @On
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo11"
				case (_type_near) S[0] = "ef_bs2_emo11"
				case (_type_imm)  S[0] = "ef_bs2_emo11"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 110) #bs_cha_num_check01
		case (15) 
			// あたふた
			$bs_emo_loop = @On
			switch ($bs_distance[$$bs_maxnum])	{
				case (_type_far)  S[0] = "ef_bs1_emo14"
				case (_type_near) S[0] = "ef_bs2_emo14"
				case (_type_imm)  S[0] = "ef_bs2_emo14"		// 作ってないのでエラー回避
			}
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info, 120) #bs_cha_num_check01
		case (21) 
			// 集中線
			    if ($$emo_num == 0)	{$chara_emo01_layer_next[$$bs_cha_num+10] += 500}
			elseif ($$emo_num == 1)	{$chara_emo02_layer_next[$$bs_cha_num+10] += 500}
			elseif ($$emo_num == 2)	{$chara_emo03_layer_next[$$bs_cha_num+10] += 500}
			$bs_emo_loop = @On
			gosub($$bs_cha_num, $$bs_maxnum, $$bs_pose_info) #bs_cha_num_check21
	}

	// エモーション座標設定
	if ($$bs_emo_num != 00)	{
		if ($$emo_num == 0)	{
			$bs_emo01[$$bs_maxnum] = S[0]
			$bs_emo01_posx_next[$$bs_maxnum] = $emo_posx_sub
			$bs_emo01_posy_next[$$bs_maxnum] = $emo_posy_sub
			$bs_emo01_exist[$$bs_maxnum] = @On
			$bs_emo01_loop[$$bs_maxnum] = $bs_emo_loop
		}
		elseif ($$emo_num == 1)	{
			$bs_emo02[$$bs_maxnum] = S[0]
			$bs_emo02_posx_next[$$bs_maxnum] = $emo_posx_sub
			$bs_emo02_posy_next[$$bs_maxnum] = $emo_posy_sub
			$bs_emo02_exist[$$bs_maxnum] = @On
			$bs_emo02_loop[$$bs_maxnum] = $bs_emo_loop
		}
		elseif ($$emo_num == 2)	{
			$bs_emo03[$$bs_maxnum] = S[0]
			$bs_emo03_posx_next[$$bs_maxnum] = $emo_posx_sub
			$bs_emo03_posy_next[$$bs_maxnum] = $emo_posy_sub
			$bs_emo03_exist[$$bs_maxnum] = @On
			$bs_emo03_loop[$$bs_maxnum] = $bs_emo_loop
		}
	}
	else{
		if ($$emo_num == 0)	{
			$bs_emo01_exist[$$bs_maxnum] = @Off
		}
		elseif ($$emo_num == 1)	{
			$bs_emo02_exist[$$bs_maxnum] = @Off
		}
		elseif ($$emo_num == 2)	{
			$bs_emo03_exist[$$bs_maxnum] = @Off
		}
	}
}

return


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// エモーション指定無し
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#bs_cha_num_check00


return


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// エモーション指定
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#bs_cha_num_check01

	// タラリ汗・右（残）／（消）
	// タラリ汗・左（残）／（消）
	// 飛び汗
	// 怒り
	// ため息・左
	// ため息・右
	// ビックリ・左
	// ビックリ・右
	// ご機嫌・左
	// ご機嫌・右
	// ？
	// イライラ
	// あたふた

	switch (L[0])	{
		// 音無------------------------------------------------------------------------------------------------------------
		case ($BS01)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// かなで----------------------------------------------------------------------------------------------------------
		case ($BS02)
			// 正面
			if (L[2] < 4)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// ゆり------------------------------------------------------------------------------------------------------------
		case ($BS03)
			// 正面
			if (L[2] < 4)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 日向------------------------------------------------------------------------------------------------------------
		case ($BS04)
			// 正面
			if ((L[2] < 4) || (L[2] == 6))	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// ユイ------------------------------------------------------------------------------------------------------------
		case ($BS05)
			// 正面
			if ((L[2] < 4) || (L[2] == 7))	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 岩沢------------------------------------------------------------------------------------------------------------
		case ($BS06)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 松下（太）------------------------------------------------------------------------------------------------------
		case ($BS07)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 松下（細）------------------------------------------------------------------------------------------------------
		case ($BS08)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 野田------------------------------------------------------------------------------------------------------------
		case ($BS09)
			// 正面
			if ((L[2] < 3) || ((L[2] >= 7) && (L[2] <= 9)))	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 高松------------------------------------------------------------------------------------------------------------
		case ($BS10)
			// 正面
			if (L[2] < 4)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 大山------------------------------------------------------------------------------------------------------------
		case ($BS11)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 藤巻------------------------------------------------------------------------------------------------------------
		case ($BS12)
			// 正面１
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 正面２
			if (L[2] < 5)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 004}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 005}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 006}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// ＴＫ------------------------------------------------------------------------------------------------------------
		case ($BS13)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 椎名------------------------------------------------------------------------------------------------------------
		case ($BS14)
			// 正面
			if ((L[2] < 3) || (L[2] == 5))	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 遊佐------------------------------------------------------------------------------------------------------------
		case ($BS15)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
		// ひさ子----------------------------------------------------------------------------------------------------------
		case ($BS16)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
		// 関根------------------------------------------------------------------------------------------------------------
		case ($BS17)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
		// 入江------------------------------------------------------------------------------------------------------------
		case ($BS18)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
		// チャー----------------------------------------------------------------------------------------------------------
		case ($BS19)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
		// 竹山------------------------------------------------------------------------------------------------------------
		case ($BS20)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
		// 直井------------------------------------------------------------------------------------------------------------
		case ($BS21)
			// 正面
			if (L[2] < 3)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// フィッシュ斉藤--------------------------------------------------------------------------------------------------
		case ($BS22)
			    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
			elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
			elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
		// 五十嵐----------------------------------------------------------------------------------------------------------
		case ($BS23)
			// 正面
			if (L[2] < 2)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 赤目天使１------------------------------------------------------------------------------------------------------
		case ($BS24)
			// 正面
			if (L[2] < 4)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
		// 赤目天使２------------------------------------------------------------------------------------------------------
		case ($BS25)
			// 正面
			if (L[2] < 4)	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 001}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 002}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 003}
			}
			// 斜め
			else	{
				    if ($bs_distance[L[1]] == _type_far)  {L[10] = 007}
				elseif ($bs_distance[L[1]] == _type_near) {L[10] = 008}
				elseif ($bs_distance[L[1]] == _type_imm)  {L[10] = 009}
			}
	}
	L[10] += L[3]
	@emo_pos_sub(L[10], L[0])

return


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// 集中線
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#bs_cha_num_check21

	// 通常
	if ($bs_distance[L[1]] == _type_far)	{
		S[0] = "ef_em21"
		switch (L[0])	{
			case ($BS01) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS02) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS03) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS04) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS05) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS06) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS07) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS08) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS09) $emo_posx_sub = -1024 $emo_posy_sub = -370
			case ($BS10) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS11) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS12) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS13) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS14) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS15) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS16) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS17) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS18) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS19) $emo_posx_sub = -1024 $emo_posy_sub = -370
			case ($BS20) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS21) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS22) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS23) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS24) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS25) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS26) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS27) $emo_posx_sub = -1024 $emo_posy_sub = -400
		}
	}
	// 近接
	elseif ($bs_distance[L[1]] == _type_near)	{
		S[0] = "ef_em21"
		switch (L[0])	{
			case ($BS01) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS02) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS03) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS04) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS05) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS06) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS07) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS08) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS09) $emo_posx_sub = -1024 $emo_posy_sub = -370
			case ($BS10) $emo_posx_sub = -1024 $emo_posy_sub = -400
			case ($BS11) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS12) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS13) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS14) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS15) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS16) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS17) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS18) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS19) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS20) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS21) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS22) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS23) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS24) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS25) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS26) $emo_posx_sub = -1024 $emo_posy_sub = -350
			case ($BS27) $emo_posx_sub = -1024 $emo_posy_sub = -350
		}
	}
	// 至近
	elseif ($bs_distance[L[1]] == _type_imm)	{
		S[0] = "ef_em21"
		switch (L[0])	{
			case ($BS01) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS02) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS03) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS04) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS05) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS06) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS07) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS08) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS09) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS10) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS11) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS12) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS13) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS14) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS15) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS16) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS17) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS18) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS19) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS20) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS21) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS22) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS23) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS24) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS25) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS26) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
			case ($BS27) $emo_posx_sub = -1024 $emo_posy_sub = -350-130
		}
	}

return


