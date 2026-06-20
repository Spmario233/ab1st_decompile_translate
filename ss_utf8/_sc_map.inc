

#define		@マップ選択		$map_sel
#property	$map_sel : int

#macro		@選択マップ(@cnt(-1))
			farcall(_sc_map, 0, @cnt)

#define		@マップ選択_日付		$map_day
#property	$map_day

#define		@１日目_午前			 0
#define		@１日目_午後			 1
#define		@２日目_午前			 2
#define		@２日目_午後			 3
#define		@３日目_午前			 4
#define		@３日目_午後			 5
#define		@４日目_午前			 6
#define		@４日目_午後			 7
#define		@５日目_午前			 8
#define		@５日目_午後			 9
#define		@６日目_午前			10
#define		@６日目_午後			11
#define		@７日目_午前			12
#define		@７日目_午後			13
#define		@８日目_午前			14
#define		@８日目_午後			15
#define		@９日目_午前			16
#define		@９日目_午後			17
#define		@１０日目_午前			18
#define		@１０日目_午後			19
#define		@１１日目_午前			20
#define		@１１日目_午後			21
#define		@１２日目_午前			22
#define		@１２日目_午後			23
#define		@１３日目_午前			24
#define		@１３日目_午後			25
#define		@１４日目_午前			26
#define		@１４日目_午後			27
#define		@１５日目_午前			28
#define		@１５日目_午後			29
#define		@１６日目_午前			30
#define		@１６日目_午後			31
#define		@１７日目_午前			32
#define		@１７日目_午後			33
#define		@１８日目_午前			34
#define		@１８日目_午後			35
#define		@１９日目_午前			36
#define		@１９日目_午後			37
#define		@２０日目_午前			38
#define		@２０日目_午後			39
#define		@２１日目_午前			40
#define		@２１日目_午後			41
#define		@２２日目_午前			42
#define		@２２日目_午後			43
#define		@２３日目_午前			44
#define		@２３日目_午後			45
#define		@２４日目_午前			46
#define		@２４日目_午後			47
#define		@２５日目_午前			48
#define		@２５日目_午後			49

#define		@マップ選択_日付表示	$map_day_disp
#property	$map_day_disp

#define		@マップ選択_時間帯表示	$map_time_disp
#define		@午前					0
#define		@午後					1
#property	$map_time_disp

#define		@ObjMapMenu00			 9		// ※注意：背景演出と重複
#define		_ObjMapBg01				 0
#define		_ObjMapBg02				 1
#define		_ObjMapBg03				 2
#define		_ObjMapBg04				 3
#define		_ObjMapBg05				 4
#define		_ObjMapSelBtn01			 5
#define		_ObjMapSelBtn02			 6
#define		_ObjMapSelBtn03			 7
#define		_ObjMapSelBtn04			 8
#define		_ObjMapSelBtn05			 9
#define		_ObjMapSelBtn06			10
#define		_ObjMapSelBtn07			11
#define		_ObjMapSelBtn08			12
#define		_ObjMapSelBtn09			13
#define		_ObjMapSelBtn10			14
#define		_ObjMapSelBtn11			15
#define		_ObjMapSelBtn12			16
#define		_ObjMapSelBtn13			17
#define		_ObjMapSelBtn14			18
#define		_ObjMapSelBtn15			19
#define		_ObjMapSelBtn01b		20
#define		_ObjMapSelBtn02b		21
#define		_ObjMapSelBtn03b		22
#define		_ObjMapSelBtn04b		23
#define		_ObjMapSelBtn05b		24
#define		_ObjMapSelBtn06b		25
#define		_ObjMapSelBtn07b		26
#define		_ObjMapSelBtn08b		27
#define		_ObjMapSelBtn09b		28
#define		_ObjMapSelBtn10b		29
#define		_ObjMapSelBtn11b		30
#define		_ObjMapSelBtn12b		31
#define		_ObjMapSelBtn13b		32
#define		_ObjMapSelBtn14b		33
#define		_ObjMapSelBtn15b		34
#define		_ObjMapSelCName01		35
#define		_ObjMapSelCName02		36
#define		_ObjMapSelCName03		37
#define		_ObjMapSelCName04		38
#define		_ObjMapSelCName05		39
#define		_ObjMapSelCName06		40
#define		_ObjMapSelCName07		41
#define		_ObjMapSelCName08		42
#define		_ObjMapSelCName09		43
#define		_ObjMapSelCName10		44
#define		_ObjMapSelCName11		45
#define		_ObjMapSelCName12		46
#define		_ObjMapSelCName13		47
#define		_ObjMapSelCName14		48
#define		_ObjMapSelCName15		49
#define		_ObjMapSelSpot01		50
#define		_ObjMapSelSpot02		51
#define		_ObjMapSelSpot03		52
#define		_ObjMapSelSpot04		53
#define		_ObjMapSelSpot05		54
#define		_ObjMapSelSpot06		55
#define		_ObjMapSelSpot07		56
#define		_ObjMapSelSpot08		57
#define		_ObjMapSelSpot09		58
#define		_ObjMapSelSpot10		59
#define		_ObjMapSelSpot11		60
#define		_ObjMapSelSpot12		61
#define		_ObjMapSelSpot13		62
#define		_ObjMapSelSpot14		63
#define		_ObjMapSelSpot15		64
#define		_ObjMapSelCha01			65
#define		_ObjMapSelCha02			66
#define		_ObjMapSelCha03			67
#define		_ObjMapSelCha04			68
#define		_ObjMapSelCha05			69
#define		_ObjMapSelCha06			70
#define		_ObjMapSelCha07			71
#define		_ObjMapSelCha08			72
#define		_ObjMapSelCha09			73
#define		_ObjMapSelCha10			74
#define		_ObjMapSelCha11			75
#define		_ObjMapSelCha12			76
#define		_ObjMapSelCha13			77
#define		_ObjMapSelCha14			78
#define		_ObjMapSelCha15			79

#define		@ゆりマップ				$map_selbtn[0]
#define		@かなでマップ			$map_selbtn[1]
#define		@岩沢マップ				$map_selbtn[2]
#define		@ユイマップ				$map_selbtn[3]
#define		@松下マップ				$map_selbtn[4]
#define		@日向マップ				$map_selbtn[5]
#define		@ひさ子マップ			$map_selbtn[6]
#define		@野田マップ				$map_selbtn[7]
#define		@図書館マップ			$map_selbtn[8]
#define		@大食堂マップ			$map_selbtn[9]
#define		@保健室マップ			$map_selbtn[10]
#define		@ＴＫマップ				$map_selbtn[11]
#define		@ガルデモマップ			$map_selbtn[12]
#define		@大山マップ				$map_selbtn[13]
#define		@松下スリムマップ		$map_selbtn[14]

#define		@ゆりマップ居場所		$map_spot[0]
#define		@かなでマップ居場所		$map_spot[1]
#define		@岩沢マップ居場所		$map_spot[2]
#define		@ユイマップ居場所		$map_spot[3]
#define		@松下マップ居場所		$map_spot[4]
#define		@日向マップ居場所		$map_spot[5]
#define		@ひさ子マップ居場所		$map_spot[6]
#define		@野田マップ居場所		$map_spot[7]
#define		@図書館マップ居場所		$map_spot[8]
#define		@大食堂マップ居場所		$map_spot[9]
#define		@保健室マップ居場所		$map_spot[10]
#define		@ＴＫマップ居場所		$map_spot[11]
#define		@ガルデモマップ居場所	$map_spot[12]
#define		@大山マップ居場所		$map_spot[13]
#define		@松下スリムマップ居場所	$map_spot[14]

#define		@マップ_出現しない				 0
#define		@マップ_戦線本部				 1				// ゆり
#define		@マップ_学習棟Ｂ棟_教室			 2				// かなで
#define		@マップ_学習棟Ａ棟_廊下			 3				// かなで／ＴＫ
#define		@マップ_学習棟Ａ棟_空き教室		 4				// 岩沢／ひさ子／ガルデモ
#define		@マップ_駐車場					 5				// ユイ
#define		@マップ_学習棟Ｂ棟_廊下			 6				// ユイ
#define		@マップ_体育館裏				 7				// 松下
#define		@マップ_野球場					 8				// 日向
#define		@マップ_第二連絡橋下_河原		 9				// 野田
#define		@マップ_大食堂					10				// 藤巻
#define		@マップ_図書館					11				// 音無
#define		@マップ_保健室					12				// かなで ※かなでのイベント扱いではない
#define		@マップ_男子寮					13				// 大山
#define		@マップ_学習棟Ａ棟_空き教室_４日目_午後		14	// ひさ子（ボタン被りによる例外処理）

#define		@ゆりボタン				$map_selbtn_type[0]
#define		@かなでボタン			$map_selbtn_type[1]
#define		@岩沢ボタン				$map_selbtn_type[2]
#define		@ユイボタン				$map_selbtn_type[3]
#define		@松下ボタン				$map_selbtn_type[4]
#define		@日向ボタン				$map_selbtn_type[5]
#define		@ひさ子ボタン			$map_selbtn_type[6]
#define		@野田ボタン				$map_selbtn_type[7]
#define		@図書館ボタン			$map_selbtn_type[8]
#define		@大食堂ボタン			$map_selbtn_type[9]
#define		@保健室ボタン			$map_selbtn_type[10]
#define		@ＴＫボタン				$map_selbtn_type[11]
#define		@ガルデモボタン			$map_selbtn_type[12]
#define		@大山ボタン				$map_selbtn_type[13]
#define		@松下スリムボタン		$map_selbtn_type[14]

#define		@ゆりボタン下地			$map_selbtnbg_type[0]
#define		@かなでボタン下地		$map_selbtnbg_type[1]
#define		@岩沢ボタン下地			$map_selbtnbg_type[2]
#define		@ユイボタン下地			$map_selbtnbg_type[3]
#define		@松下ボタン下地			$map_selbtnbg_type[4]
#define		@日向ボタン下地			$map_selbtnbg_type[5]
#define		@ひさ子ボタン下地		$map_selbtnbg_type[6]
#define		@野田ボタン下地			$map_selbtnbg_type[7]
#define		@図書館ボタン下地		$map_selbtnbg_type[8]
#define		@大食堂ボタン下地		$map_selbtnbg_type[9]
#define		@保健室ボタン下地		$map_selbtnbg_type[10]
#define		@ＴＫボタン下地			$map_selbtnbg_type[11]
#define		@ガルデモボタン下地		$map_selbtnbg_type[12]
#define		@大山ボタン下地			$map_selbtnbg_type[13]
#define		@松下スリムボタン下地	$map_selbtnbg_type[14]

#define		@ゆりマップＸ			$map_selbtn_x[0]
#define		@かなでマップＸ			$map_selbtn_x[1]
#define		@岩沢マップＸ			$map_selbtn_x[2]
#define		@ユイマップＸ			$map_selbtn_x[3]
#define		@松下マップＸ			$map_selbtn_x[4]
#define		@日向マップＸ			$map_selbtn_x[5]
#define		@ひさ子マップＸ			$map_selbtn_x[6]
#define		@野田マップＸ			$map_selbtn_x[7]
#define		@図書館マップＸ			$map_selbtn_x[8]
#define		@大食堂マップＸ			$map_selbtn_x[9]
#define		@保健室マップＸ			$map_selbtn_x[10]
#define		@ＴＫマップＸ			$map_selbtn_x[11]
#define		@ガルデモマップＸ		$map_selbtn_x[12]
#define		@大山マップＸ			$map_selbtn_x[13]
#define		@松下スリムマップＸ		$map_selbtn_x[14]

#define		@ゆりマップＹ			$map_selbtn_y[0]
#define		@かなでマップＹ			$map_selbtn_y[1]
#define		@岩沢マップＹ			$map_selbtn_y[2]
#define		@ユイマップＹ			$map_selbtn_y[3]
#define		@松下マップＹ			$map_selbtn_y[4]
#define		@日向マップＹ			$map_selbtn_y[5]
#define		@ひさ子マップＹ			$map_selbtn_y[6]
#define		@野田マップＹ			$map_selbtn_y[7]
#define		@図書館マップＹ			$map_selbtn_y[8]
#define		@大食堂マップＹ			$map_selbtn_y[9]
#define		@保健室マップＹ			$map_selbtn_y[10]
#define		@ＴＫマップＹ			$map_selbtn_y[11]
#define		@ガルデモマップＹ		$map_selbtn_y[12]
#define		@大山マップＹ			$map_selbtn_y[13]
#define		@松下スリムマップＹ		$map_selbtn_y[14]

#define		@ゆりマップＹ補正		$map_selbtn_rep_y[0]
#define		@かなでマップＹ補正		$map_selbtn_rep_y[1]
#define		@岩沢マップＹ補正		$map_selbtn_rep_y[2]
#define		@ユイマップＹ補正		$map_selbtn_rep_y[3]
#define		@松下マップＹ補正		$map_selbtn_rep_y[4]
#define		@日向マップＹ補正		$map_selbtn_rep_y[5]
#define		@ひさ子マップＹ補正		$map_selbtn_rep_y[6]
#define		@野田マップＹ補正		$map_selbtn_rep_y[7]
#define		@図書館マップＹ補正		$map_selbtn_rep_y[8]
#define		@大食堂マップＹ補正		$map_selbtn_rep_y[9]
#define		@保健室マップＹ補正		$map_selbtn_rep_y[10]
#define		@ＴＫマップＹ補正		$map_selbtn_rep_y[11]
#define		@ガルデモマップＹ補正	$map_selbtn_rep_y[12]
#define		@大山マップＹ補正		$map_selbtn_rep_y[13]
#define		@松下スリムマップＹ補正	$map_selbtn_rep_y[14]

#define		@マップ選択初期化
			$map_selbtn_type.init
			$map_selbtnbg_type.init
			$map_selbtn.init
			$map_spot.init
			$map_selbtn_x.init
			$map_selbtn_y.init

#define		@マップボタン初期設定
			@ゆりボタン	     = sys_mp_selbtn01  @ゆりボタン下地	      = sys_mp_selbtn01b  @ゆりマップＹ補正	    = 0
			@かなでボタン    = sys_mp_selbtn02  @かなでボタン下地     = sys_mp_selbtn02b  @かなでマップＹ補正   = 41
			@岩沢ボタン	     = sys_mp_selbtn01  @岩沢ボタン下地	      = sys_mp_selbtn01b  @岩沢マップＹ補正	    = 0
			@ユイボタン	     = sys_mp_selbtn01  @ユイボタン下地	      = sys_mp_selbtn01b  @ユイマップＹ補正	    = 0
			@松下ボタン	     = sys_mp_selbtn01  @松下ボタン下地	      = sys_mp_selbtn01b  @松下マップＹ補正	    = 0
			@日向ボタン	     = sys_mp_selbtn01  @日向ボタン下地	      = sys_mp_selbtn01b  @日向マップＹ補正	    = 0
			@ひさ子ボタン    = sys_mp_selbtn01  @ひさ子ボタン下地     = sys_mp_selbtn01b  @ひさ子マップＹ補正   = 0
			@野田ボタン	     = sys_mp_selbtn02  @野田ボタン下地	      = sys_mp_selbtn02b  @野田マップＹ補正	    = 41
			@図書館ボタン    = sys_mp_selbtn02  @図書館ボタン下地     = sys_mp_selbtn02b  @図書館マップＹ補正   = 41
			@大食堂ボタン    = sys_mp_selbtn02  @大食堂ボタン下地     = sys_mp_selbtn02b  @大食堂マップＹ補正   = 41
			@保健室ボタン    = sys_mp_selbtn02  @保健室ボタン下地     = sys_mp_selbtn02b  @保健室マップＹ補正   = 41
			@ＴＫボタン	     = sys_mp_selbtn01  @ＴＫボタン下地	      = sys_mp_selbtn01b  @ＴＫマップＹ補正	    = 0
			@ガルデモボタン  = sys_mp_selbtn01  @ガルデモボタン下地   = sys_mp_selbtn01b  @ガルデモマップＹ補正 = 0
			@大山ボタン      = sys_mp_selbtn01  @大山ボタン下地       = sys_mp_selbtn01b  @大山マップＹ補正     = 0
			@松下スリムボタン= sys_mp_selbtn01  @松下スリムボタン下地 = sys_mp_selbtn01b  @松下マップＹ補正	    = 0

#define		@キャラクター出現人数
			$map_selbtn[0]  + $map_selbtn[1]  + $map_selbtn[2]  + $map_selbtn[3] + $map_selbtn[4]  + $map_selbtn[5]  +
			$map_selbtn[6]  + $map_selbtn[7]  + $map_selbtn[8]  + $map_selbtn[9] + $map_selbtn[10] + $map_selbtn[11] +
			$map_selbtn[12] + $map_selbtn[13] + $map_selbtn[14]

#define		@エピソードタイトル		$map_ep_disp
#define		@エピソード01 			 0
#define		@エピソード02 			 1
#define		@エピソード03 			 2
#define		@エピソード04 			 3
#define		@エピソード05			 4
#define		@エピソード06 			 5
#define		@エピソード07 			 6
#define		@エピソード08 			 7
#define		@エピソード09 			 8
#define		@エピソード10			 9
#define		@エピソード11			10
#define		@エピソード12			11
#define		@エピソード13			12



#property	$map_selbtn_type   : strlist[15]
#property	$map_selbtnbg_type : strlist[15]
#property	$map_selbtn        : intlist[15]
#property	$map_spot          : intlist[15]
#property	$map_selbtn_x      : intlist[15]
#property	$map_selbtn_y      : intlist[15]
#property	$map_selbtn_rep_y  : intlist[15]
#property	$map_ep_disp       : int
#property	$map_day1_disp     : int
#property	$map_day2_disp     : int

