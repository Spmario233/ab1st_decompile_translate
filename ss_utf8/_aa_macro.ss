
//-----------------------------------------------------------------
// バストショットの追加
//-----------------------------------------------------------------
command $bs_add( property $src_name : str, property $pos : int )
{
	property $mark_name : str
	property $now_name : strlist[@bs_maxnum]
	property $override : int
	property $count : int

	if( $src_name == "" ){
		return
	}

	if( $bs_cha[0] == "" || $bs_cha[0] == "in" ){	//立ち絵立ってないor初期化されていない
		@bs($src_name)
		return
	}

	//認識名のみ抜き出し
	//0123456489
	//bs1_xx0000
	if( $src_name.left(2) == "bs" ){
		$mark_name = $src_name.mid(4,2)
	}
	else{
		$mark_name = $src_name.left(2)
	}

	for( L[0]=0, L[0] < @bs_maxnum, L[0] += 1 ){	//先に代入しておく
		$now_name[L[0]] = "nothing"
	}
	//現在の立ち絵とかぶってないか確認
	for( L[0] = 0, L[0] < @bs_maxnum, L[0] += 1 ){
		if( $bs_cha[L[0]] == "in" ){
			break
		}
		elseif( $bs_cha[L[0]] == $mark_name ){		//すでに存在。その場合表情を変えておく
			$now_name[L[0]] = $src_name
			$override = 1
		}
		else{
			$now_name[L[0]] = $bs_cha[L[0]]
		}
	}
	if( $override ){		//変更して終了
		@bs($now_name[0],$now_name[1],$now_name[2],$now_name[3],$now_name[4],$now_name[5])
		return
	}

	if( $pos != 4 && $pos != 6 ){
		@DEBUG("位置指定は4or6です")
		return
	}

	if( $bs_cha[@bs_maxnum-1] != "in" ){
		@DEBUG( "立つスペースないよ " + $src_name )
		return
	}

	$count = 0
	if( $pos == 4 ){	//左に追加
		$now_name[$count] = $src_name
		$count += 1
	}
	for( L[0]=0, L[0] < @bs_maxnum-1, L[0] += 1 ){
		if( $bs_cha[L[0]] == "in" ){
			break
		}
		$now_name[$count] = $bs_cha[L[0]]
		$count += 1
	}
	if( $pos == 6 ){	//右に追加
		$now_name[$count] = $src_name
		$count += 1
	}
	@bs($now_name[0],$now_name[1],$now_name[2],$now_name[3],$now_name[4],$now_name[5])
}



//-----------------------------------------------------------------
// バストショットの消去
//-----------------------------------------------------------------
command $bs_del( property $src_name1 : str, property $src_name2 : str, property $src_name3 : str, property $src_name4 : str, property $src_name5 : str )
{
	property $src_name : strlist[5]
	property $mark_name : strlist[5]
	property $now_name : strlist[@bs_maxnum]
	property $count : int
	property $del_count : int
	property $del_fine : int

	$src_name[0] = $src_name1
	$src_name[1] = $src_name2
	$src_name[2] = $src_name3
	$src_name[3] = $src_name4
	$src_name[4] = $src_name5

	//認識名のみ抜き出し
	//0123456489
	//bs1_xx0000
	for(L[0]=0,L[0]<5,L[00]+=1){
		if( $src_name[L[00]].left(2) == "bs" ){
			$mark_name[L[00]] = $src_name[L[00]].mid(4,2)
		}
		else{
			$mark_name[L[00]] = $src_name[L[00]].left(2)
		}
	}

	//現在の立ち絵を取得
	$count = 0
	$del_count = 0
	for( L[0] = 0, L[0] < @bs_maxnum, L[0] += 1 ){
		$del_fine = 0
		if( $bs_cha[L[0]] == "in" ){
			break
		}
		else{
			for( L[1] = 0, L[1] < 5, L[1] += 1 ){
				if( $bs_cha[L[0]] == $mark_name[L[1]] ){
					$del_count += 1
					$del_fine = 1
					break
				}
			}
		}
		if( $del_fine == 0 ){
			$now_name[$count] = $bs_cha[L[0]]
			$count += 1
		}
	}
	for(       , $count < @bs_maxnum, $count += 1 ){	//残り梅
		$now_name[$count] = "nothing"
	}
	if( $del_count ){
		@bs($now_name[0],$now_name[1],$now_name[2],$now_name[3],$now_name[4],$now_name[5])
	}
}



//───────────────────────────────────────
//野田で怪我したフラグを立てる
//───────────────────────────────────────
command $noda_de_kega( property $day:int )
{
	//今は０／１で管理しているが、怪我の内容を管理する場合は２以降を使う予定
	switch($day){
		case(01)	@０１日野田で怪我=1
		case(02)	@０２日野田で怪我=1
		case(03)	@０３日野田で怪我=1
		case(04)	@０４日野田で怪我=1
		case(05)	@０５日野田で怪我=1
		case(06)	@０６日野田で怪我=1
		case(07)	@０７日野田で怪我=1
		case(08)	@０８日野田で怪我=1
		case(09)	@０９日野田で怪我=1
		case(10)	@１０日野田で怪我=1
		case(11)	@１１日野田で怪我=1
		case(12)	@１２日野田で怪我=1
		case(13)	@１３日野田で怪我=1
		case(14)	@１４日野田で怪我=1
		case(15)	@１５日野田で怪我=1
		case(16)	@１６日野田で怪我=1
		case(17)	@１７日野田で怪我=1
		case(18)	@１８日野田で怪我=1
		case(19)	@１９日野田で怪我=1
		case(20)	@２０日野田で怪我=1
		case(21)	@２１日野田で怪我=1
		case(22)	@２２日野田で怪我=1
		case(23)	@２３日野田で怪我=1
		case(24)	@２４日野田で怪我=1
		case(25)	@２５日野田で怪我=1
		case(26)	@２６日野田で怪我=1
		case(27)	@２７日野田で怪我=1
		case(28)	@２８日野田で怪我=1
		case(29)	@２９日野田で怪我=1
		case(30)	@３０日野田で怪我=1
		default	@DEBUG(日付は３０日までしか用意していません)
	}

}


//───────────────────────────────────────
//松下で怪我したフラグを立てる
//───────────────────────────────────────
command $matusita_de_kega( property $day:int )
{
	//今は０／１で管理しているが、怪我の内容を管理する場合は２以降を使う予定
	switch($day){
		case(01)	@０１日松下で怪我=1
		case(02)	@０２日松下で怪我=1
		case(03)	@０３日松下で怪我=1
		case(04)	@０４日松下で怪我=1
		case(05)	@０５日松下で怪我=1
		case(06)	@０６日松下で怪我=1
		case(07)	@０７日松下で怪我=1
		case(08)	@０８日松下で怪我=1
		case(09)	@０９日松下で怪我=1
		case(10)	@１０日松下で怪我=1
		case(11)	@１１日松下で怪我=1
		case(12)	@１２日松下で怪我=1
		case(13)	@１３日松下で怪我=1
		case(14)	@１４日松下で怪我=1
		case(15)	@１５日松下で怪我=1
		case(16)	@１６日松下で怪我=1
		case(17)	@１７日松下で怪我=1
		case(18)	@１８日松下で怪我=1
		case(19)	@１９日松下で怪我=1
		case(20)	@２０日松下で怪我=1
		case(21)	@２１日松下で怪我=1
		case(22)	@２２日松下で怪我=1
		case(23)	@２３日松下で怪我=1
		case(24)	@２４日松下で怪我=1
		case(25)	@２５日松下で怪我=1
		case(26)	@２６日松下で怪我=1
		case(27)	@２７日松下で怪我=1
		case(28)	@２８日松下で怪我=1
		case(29)	@２９日松下で怪我=1
		case(30)	@３０日松下で怪我=1
		default	@DEBUG(日付は３０日までしか用意していません)
	}
}


//───────────────────────────────────────
//野田で怪我をしているかフラグを返す
//───────────────────────────────────────
command $kegasiteru_noda( property $day:int ) : int
{
	switch($day){
		case(01)	L[00]=@０１日野田で怪我
		case(02)	L[00]=@０２日野田で怪我
		case(03)	L[00]=@０３日野田で怪我
		case(04)	L[00]=@０４日野田で怪我
		case(05)	L[00]=@０５日野田で怪我
		case(06)	L[00]=@０６日野田で怪我
		case(07)	L[00]=@０７日野田で怪我
		case(08)	L[00]=@０８日野田で怪我
		case(09)	L[00]=@０９日野田で怪我
		case(10)	L[00]=@１０日野田で怪我
		case(11)	L[00]=@１１日野田で怪我
		case(12)	L[00]=@１２日野田で怪我
		case(13)	L[00]=@１３日野田で怪我
		case(14)	L[00]=@１４日野田で怪我
		case(15)	L[00]=@１５日野田で怪我
		case(16)	L[00]=@１６日野田で怪我
		case(17)	L[00]=@１７日野田で怪我
		case(18)	L[00]=@１８日野田で怪我
		case(19)	L[00]=@１９日野田で怪我
		case(20)	L[00]=@２０日野田で怪我
		case(21)	L[00]=@２１日野田で怪我
		case(22)	L[00]=@２２日野田で怪我
		case(23)	L[00]=@２３日野田で怪我
		case(24)	L[00]=@２４日野田で怪我
		case(25)	L[00]=@２５日野田で怪我
		case(26)	L[00]=@２６日野田で怪我
		case(27)	L[00]=@２７日野田で怪我
		case(28)	L[00]=@２８日野田で怪我
		case(29)	L[00]=@２９日野田で怪我
		case(30)	L[00]=@３０日野田で怪我
		default	@DEBUG(日付は３０日までしか用意していません)
	}
	return(L[00])
}


//───────────────────────────────────────
//松下で怪我をしているかフラグを返す
//───────────────────────────────────────
command $kegasiteru_matusita( property $day:int ) : int
{
	switch($day){
		case(01)	L[00]=@０１日松下で怪我
		case(02)	L[00]=@０２日松下で怪我
		case(03)	L[00]=@０３日松下で怪我
		case(04)	L[00]=@０４日松下で怪我
		case(05)	L[00]=@０５日松下で怪我
		case(06)	L[00]=@０６日松下で怪我
		case(07)	L[00]=@０７日松下で怪我
		case(08)	L[00]=@０８日松下で怪我
		case(09)	L[00]=@０９日松下で怪我
		case(10)	L[00]=@１０日松下で怪我
		case(11)	L[00]=@１１日松下で怪我
		case(12)	L[00]=@１２日松下で怪我
		case(13)	L[00]=@１３日松下で怪我
		case(14)	L[00]=@１４日松下で怪我
		case(15)	L[00]=@１５日松下で怪我
		case(16)	L[00]=@１６日松下で怪我
		case(17)	L[00]=@１７日松下で怪我
		case(18)	L[00]=@１８日松下で怪我
		case(19)	L[00]=@１９日松下で怪我
		case(20)	L[00]=@２０日松下で怪我
		case(21)	L[00]=@２１日松下で怪我
		case(22)	L[00]=@２２日松下で怪我
		case(23)	L[00]=@２３日松下で怪我
		case(24)	L[00]=@２４日松下で怪我
		case(25)	L[00]=@２５日松下で怪我
		case(26)	L[00]=@２６日松下で怪我
		case(27)	L[00]=@２７日松下で怪我
		case(28)	L[00]=@２８日松下で怪我
		case(29)	L[00]=@２９日松下で怪我
		case(30)	L[00]=@３０日松下で怪我
		default	@DEBUG(日付は３０日までしか用意していません)
	}
	return(L[00])
}


//───────────────────────────────────────
//「@野田との訓練上着を脱ぎ捨てた」フラグを管理する（立てる）
//───────────────────────────────────────
command $set_noda_de_nugisuteta( property $day:int )
{
	if( $day >= 0 && $day < 32 ){
		@野田との訓練上着を脱ぎ捨てた＿管理 |= (1<<$day)
	}
}


//───────────────────────────────────────
//「@野田との訓練上着を脱ぎ捨てた」フラグを管理する（確認する）
//───────────────────────────────────────
command $check_noda_de_nugisuteta( property $day:int ) : int
{
	if( $day >= 0 && $day < 32 ){
		if( (@野田との訓練上着を脱ぎ捨てた＿管理 & (1<<$day)) != 0 ){
			return(1)	//脱ぎ捨ててた
		}
	}
	return(0)		//脱ぎ捨ててない

}






// ---------------------------------------------------------------
// 白フィルター(加算式)
// ---------------------------------------------------------------
command $aa_sc_add(property $switch        : int,
                 property $time          : int,
                 property $wait          : int,
                 property $sc_tr_num     : int,
                 property $sc_layer_num  : int,
                 property $sc_bn_layer00 : int,
                 property $sc_en_layer01 : int,
                 property $sc_en_layer02 : int)
{

	// 次のワイプで適用
	if (($switch == @On) && ($time == 0))	{
		@b.effect[0].begin_order = 0
		@b.effect[0].end_order = 0
		@b.effect[0].bright = $sc_tr_num
		@b.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer   = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@b.effect[0].begin_layer = $sc_bn_layer00
			@b.effect[0].end_layer   = $sc_en_layer02
		}
	}
	// 時間指定で適用
	elseif (($switch == @On) && ($time != 0))	{
		@f.effect[0].begin_order = 0
		@f.effect[0].end_order = 0
		@f.effect[0].bright_eve.set(255, $time, 0, 0)
		@f.effect[0].wipe_copy = @On
		if ($sc_layer_num == 0)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer   = $sc_en_layer01
		}
		elseif ($sc_layer_num == 1)	{
			@f.effect[0].begin_layer = $sc_bn_layer00
			@f.effect[0].end_layer   = $sc_en_layer02
		}
	}
	// 次のワイプで消去
	elseif (($switch == @Off) && ($time == 0))	{
		@f.effect[0].wipe_copy = @Off
	}
	// 時間指定で消去
	elseif (($switch == @Off) && ($time != 0))	{
		@f.effect[0].bright_eve.set(0, $time, 0, 0)
		@f.effect[0].wipe_copy = @Off
	}
	// エフェクト適用／消去を待つ
	if ($wait == @On)	{
		@f.effect[0].bright_eve.wait
	}
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)
}






#Z00




