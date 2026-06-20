/********************************************************
*														*
*					表示コマンド宣言					*
*														*
*********************************************************/
#z00

// ===================================================================================
// 背景ぼかし
// ===================================================================================
command $bg_blur_switch(property $bg_blur0 : int)
{
	$bg_blur[0] = $bg_blur0

}


// ---------------------------------------------------------------
// OMVボリュームアップ
// ---------------------------------------------------------------
command $omv_volume_up(property $fa : frameaction, property $volume_num : int)
{
	L[0] = $fa.counter.get
	L[1] = math.timetable(L[0], 0, $volume_num, [0, 1500, 255])
	pcmch[@omv_ch].set_volume(L[1])
}


// ===================================================================================
// 視点変更
// ===================================================================================
command $view_change(property $view_name : str, property $disp : int)
{
	switch ($view_name)	{
		case ("日向")   L[0] =  0
		case ("かなで") L[0] =  1
		case ("松下")   L[0] =  2
		case ("音無")   L[0] =  3
		default         L[0] = -1
	}

	// 表示
	if (($disp == @On) && (L[0] != -1))	{
		@f.obj[@OBJ_EF_SCREEN17].create(sys_ve_icon00, @On, -100, 445)
		@f.obj[@OBJ_EF_SCREEN17].tr = 0
		@f.obj[@OBJ_EF_SCREEN17].patno = L[0]
		@f.obj[@OBJ_EF_SCREEN17].layer = 550
		@f.obj[@OBJ_EF_SCREEN17].tr_eve.set(255, 500, 0, 0)
		@f.obj[@OBJ_EF_SCREEN17].x_eve.set(0, 500, 0, 2)
	}
	// 消去
	elseif ($disp == @Off)	{
		@f.obj[@OBJ_EF_SCREEN17].tr_eve.set(0, 1000, 0, 0)
	}
}


