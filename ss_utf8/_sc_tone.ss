/********************************************************
*														*
*					トーンカーブ						*
*														*
*********************************************************/
#z00
command $bs_tone_set(property $bg_name : str)
{
	// 0：夜
	// 1：オペレーション(■ep03_bg004.g00)
	// 2：灰色ギルド(■ep02_bg027■ep02_bg029.g00■ep02_bg030■ep02_bg031■ep02_bg032■ep02_bg035■ep02_bg037■ep02_bg039■ep02_bg040■ep02_bg041■ep02_bg043■ep04_bg019■ep04_bg020■ep08_bg025■ep88_bg026)
	// 3：茶色ギルド(■ep02_bg015■ep02_bg057■ep02_bg058■ep02_bg060■ep02_bg061■ep02_bg062■ep02_bg063■ep07_bg048)
	// 4：緑色ギルド(■ep02_bg017■ep02_bg019■ep02_bg047■ep02_bg054)
	// 5：夕焼け
	// 6：どしゃぶり(■ep06_bg022■ep06_bg023■ep06_bg039)
	// 7：赤色ギルド(■ep02_bg021■ep02_bg022■ep08_bg020)
	// 8：トンネル崩落電車内(■ep09_bg006■ep09_bg007)
	// 9：トンネル崩落現場etc(■ep08_bg035■ep08_bg036■ep08_bg037■ep08_bg038■ep08_bg039■ep09_bg011■ep09_bg012■ep09_bg014■ep09_bg015■ep09_bg018)
	
	if ($tone_admin == @On)	{

		switch ($bg_name)	{
//			case (bg01a)  $bg_time_set = -1 // 主人公の部屋　朝
			
			case(evcm_0506)		$bg_time_set = 0
			case(evcm_0516)		$bg_time_set = 0
			case(evcm_0517)		$bg_time_set = 0
			case(evcm_0601)		$bg_time_set = 0
			case(evcm_0602)		$bg_time_set = 0
			case(evcm_0603)		$bg_time_set = 0
			case(evcm_0701)		$bg_time_set = 0
			case(evcm_0702)		$bg_time_set = 0
			case(evcm_0801)		$bg_time_set = 0
			case(evcm_3801)		$bg_time_set = 0
			case(ep01_bg001)	$bg_time_set = 0
			case(ep01_bg002)	$bg_time_set = 0
			case(ep01_bg013)	$bg_time_set = 0
			case(ep01_bg015)	$bg_time_set = 0
			case(ep01_bg017)	$bg_time_set = 0
			case(ep01_bg019)	$bg_time_set = 0
			case(ep01_bg020)	$bg_time_set = 0
			case(ep01_bg023)	$bg_time_set = 0
			case(ep01_bg025)	$bg_time_set = 0
			case(ep01_bg027)	$bg_time_set = 0
			case(ep01_bg028)	$bg_time_set = 0
			case(ep01_bg082)	$bg_time_set = 0
			case(ep01_bg090)	$bg_time_set = 0
			case(ep01_bg093)	$bg_time_set = 0
			case(ep01_bg095)	$bg_time_set = 0
			case(ep01_bg097)	$bg_time_set = 0
			case(ep01_bg098)	$bg_time_set = 0
			case(ep03_bg029)	$bg_time_set = 0
			case(ep03_bg033)	$bg_time_set = 0
			case(ep03_bg034)	$bg_time_set = 0
			case(ep03_bg044)	$bg_time_set = 0
			case(ep03_bg047)	$bg_time_set = 0
			case(ep05_bg036)	$bg_time_set = 0
			//case(ep05_bg040)	$bg_time_set = 0
			case(ep05_bg041)	$bg_time_set = 0
			case(ep05_bg042)	$bg_time_set = 0
			case(ep05_bg043)	$bg_time_set = 0
			case(ep05_bg044)	$bg_time_set = 0
			case(ep07_bg050)	$bg_time_set = 0
			case(ep07_bg051)	$bg_time_set = 0
			case(ep07_bg052)	$bg_time_set = 0
			case(ep08_bg004)	$bg_time_set = 0
			case(ep09_bg002)	$bg_time_set = 0
			case(ep10_bg025)	$bg_time_set = 0
			case(ep11_bg015)	$bg_time_set = 0
			case(ep08_bg032)	$bg_time_set = 0
			case(ep88_bg021)	$bg_time_set = 0
			case(ep88_bg022)	$bg_time_set = 0
			case(ep88_bg031)	$bg_time_set = 0
			case(ep88_bg032)	$bg_time_set = 0
			case(ep99_bg004)	$bg_time_set = 0
			case(ep99_bg005)	$bg_time_set = 0
			case(ep07_bg051)	$bg_time_set = 0
			case(ep99_bg013)	$bg_time_set = 0
			
			case(ep03_bg004)	$bg_time_set = 1
			case(evcm_0401)		$bg_time_set = 1
			case(evcm_0402)		$bg_time_set = 1
			
			case(ep02_bg027)	$bg_time_set = 2
			case(ep02_bg029)	$bg_time_set = 2
			case(ep02_bg030)	$bg_time_set = 2
			case(ep02_bg031)	$bg_time_set = 2
			case(ep88_bg060)	$bg_time_set = 2
			case(ep02_bg032)	$bg_time_set = 2
			case(ep02_bg035)	$bg_time_set = 2
			case(ep02_bg037)	$bg_time_set = 2
			case(ep02_bg039)	$bg_time_set = 2
			case(ep02_bg040)	$bg_time_set = 2
			case(ep02_bg041)	$bg_time_set = 2
			case(ep02_bg043)	$bg_time_set = 2
			case(ep04_bg019)	$bg_time_set = 2
			case(ep04_bg020)	$bg_time_set = 2
			case(ep08_bg025)	$bg_time_set = 2
			case(ep88_bg026)	$bg_time_set = 2
			
			case(ep02_bg015)	$bg_time_set = 3
			case(ep02_bg057)	$bg_time_set = 3
			case(ep02_bg058)	$bg_time_set = 3
			case(ep02_bg060)	$bg_time_set = 3
			case(ep02_bg061)	$bg_time_set = 3
			case(ep02_bg062)	$bg_time_set = 3
			case(ep02_bg063)	$bg_time_set = 3
			case(ep07_bg048)	$bg_time_set = 3
			
			case(ep02_bg017)	$bg_time_set = 4
			case(ep02_bg019)	$bg_time_set = 4
			case(ep02_bg047)	$bg_time_set = 4
			case(ep02_bg054)	$bg_time_set = 4
			case(evcm_0518)		$bg_time_set = 4
			case(evcm_0515)		$bg_time_set = 4
			case(ep08_bg024)	$bg_time_set = 4
			
			case(ep02_bg008)	$bg_time_set = 5
			case(ep05_bg026)	$bg_time_set = 5
			case(ep88_bg059)	$bg_time_set = 5
			case(ep10_bg028)	$bg_time_set = 5
			
			case(ep06_bg022)	$bg_time_set = 6
			case(ep06_bg023)	$bg_time_set = 6
			case(ep06_bg039)	$bg_time_set = 6
			case(ep88_bg054)	$bg_time_set = 6
			case(ep88_bg055)	$bg_time_set = 6
			
			case(ep02_bg021)	$bg_time_set = 7
			case(ep02_bg022)	$bg_time_set = 7
			case(ep08_bg020)	$bg_time_set = 7
			case(evcm_0512)		$bg_time_set = 7
			case(evcm_0515)		$bg_time_set = 7
			case(evcm_3901)		$bg_time_set = 7

			case(ep09_bg006)	$bg_time_set = 8
			case(ep09_bg007)	$bg_time_set = 8

			case(ep08_bg035)	$bg_time_set = 9
			case(ep08_bg036)	$bg_time_set = 9
			case(ep08_bg037)	$bg_time_set = 9
			case(ep08_bg038)	$bg_time_set = 9
			case(ep08_bg039)	$bg_time_set = 9
			case(ep09_bg011)	$bg_time_set = 9
			case(ep08_bg038)	$bg_time_set = 9
			case(ep09_bg012)	$bg_time_set = 9
			case(ep09_bg014)	$bg_time_set = 9
			case(ep09_bg015)	$bg_time_set = 9
			case(ep09_bg018)	$bg_time_set = 9
			
			case (bg_kuro) $bg_time_set = -1 // 白

			case (bg_siro) $bg_time_set = -1 // 黒

			case (bg_kuron) $bg_time_set = 0 // 黒　夜

			case (bg_siron) $bg_time_set = 0 // 白　夜

			case (ev_kuro) $bg_time_set = -1 // 白

			case (ev_siro) $bg_time_set = -1 // 黒

			case (ev_aka) $bg_time_set = -1  // 赤

			default       $bg_time_set = -1
		}
	}
	else	{
		$bg_time_set = -1
	}

}

