/********************************************************
*														*
*					画面エフェクト集					*
*														*
*********************************************************/
#z00

	// エフェクト番号
	switch (L[1])	{
		case (0) K[0] = "ef_em21"  L[2] -= 400 L[3] -= 250 L[10] = 500
		case (1) K[0] = "ef_em21"  L[2] += 750 L[3] += 450 L[10] = 500
		case (2) K[0] = "sd_em37"  L[2] +=   0 L[3] +=   0 L[10] = 0
	}

	if (@EmDispState == @On)	{

		if ((L[1] == 0) || (L[1] == 1))	{
			@b.obj[L[0]].create(K[0], @On, L[2], L[3])
			if (L[1] == 1)	{
				@b.obj[L[0]].center_rep_x = 1000
				@b.obj[L[0]].center_rep_y = 750
				@b.obj[L[0]].scale_x = 1500
				@b.obj[L[0]].scale_y = 1500
			}
			@b.obj[L[0]].load_gan(K[0])
			@b.obj[L[0]].start_gan(0, 1)
		}
		elseif (L[1] == 2)	{
			@b.obj[L[0]].create_movie_loop(K[0], @On, L[2], L[3])
			@b.obj[L[0]].layer = 10000
		}
		@b.obj[L[0]].wipe_copy = L[4]
		@b.obj[L[0]].layer = L[10]
	}

return







// ---------------------------------------------------------------------------------------------------------
// シネスコ表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z10

	@b.obj[@OBJ_EF_SCREEN04].create(bg_kuro, @On, 0, -720+L[0])
	@b.obj[@OBJ_EF_SCREEN05].create(bg_kuro, @On, 0,  720-L[0])
	@b.obj[@OBJ_EF_SCREEN04].layer = -20
	@b.obj[@OBJ_EF_SCREEN05].layer = -20
	@b.obj[@OBJ_EF_SCREEN04].wipe_copy = @On
	@b.obj[@OBJ_EF_SCREEN05].wipe_copy = @On

return


// ---------------------------------------------------------------------------------------------------------
// シネスコ消去[簡易]
// ---------------------------------------------------------------------------------------------------------
#z11

	@f.obj[@OBJ_EF_SCREEN04].wipe_copy = @Off
	@f.obj[@OBJ_EF_SCREEN05].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// シネスココマンド
// ---------------------------------------------------------------------------------------------------------
#z12

	// @cs_switch
	if (L[0] == @On)	{
		@f.obj[@OBJ_EF_SCREEN04].create(bg_kuro, @On, 0, -720)
		@f.obj[@OBJ_EF_SCREEN05].create(bg_kuro, @On, 0,  720)
		@f.obj[@OBJ_EF_SCREEN04].layer = -20
		@f.obj[@OBJ_EF_SCREEN05].layer = -20
		@f.obj[@OBJ_EF_SCREEN04].wipe_copy = @On
		@f.obj[@OBJ_EF_SCREEN05].wipe_copy = @On

		@f.obj[@OBJ_EF_SCREEN04].y_eve.set(-720+L[1], L[2], 0, L[3])
		@f.obj[@OBJ_EF_SCREEN05].y_eve.set( 720-L[1], L[2], 0, L[3])

	}
	else	{
		@f.obj[@OBJ_EF_SCREEN04].y_eve.set(-720, L[2], 0, L[3])
		@f.obj[@OBJ_EF_SCREEN05].y_eve.set( 720, L[2], 0, L[3])
	}
	// @cs_wait
	if (L[4] == @On)	{
		@f.obj[@OBJ_EF_SCREEN04].y_eve.wait
		@f.obj[@OBJ_EF_SCREEN05].y_eve.wait
	}

return


// ---------------------------------------------------------------------------------------------------------
// 流線表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z13

	@b.obj[@OBJ_EF_SCREEN06].create_movie_loop("ef_sline0"+math.tostr(L[0]+1), @On)
	@b.obj[@OBJ_EF_SCREEN06].layer = -1
	@b.obj[@OBJ_EF_SCREEN06].set_scale(2000, 2000)
	@b.obj[@OBJ_EF_SCREEN06].blend = 4
	@b.obj[@OBJ_EF_SCREEN06].wipe_copy = @On

return


// ---------------------------------------------------------------------------------------------------------
// 流線非表示
// ---------------------------------------------------------------------------------------------------------
#z14

	@f.obj[@OBJ_EF_SCREEN06].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// 流線コマンド
// ---------------------------------------------------------------------------------------------------------
#z15

	// @sl_switch
	if (L[0] == @On)	{
		@f.obj[@OBJ_EF_SCREEN06].create_movie_loop("ef_sline0"+math.tostr(L[1]+1), @On)
		@f.obj[@OBJ_EF_SCREEN06].tr = 0
		@f.obj[@OBJ_EF_SCREEN06].layer = -1
		@f.obj[@OBJ_EF_SCREEN06].set_scale(2000, 2000)
		@f.obj[@OBJ_EF_SCREEN06].blend = 4
		@f.obj[@OBJ_EF_SCREEN06].wipe_copy = @On

		@f.obj[@OBJ_EF_SCREEN06].tr_eve.set(255, L[2], 0, L[3])

	}
	else	{
		@f.obj[@OBJ_EF_SCREEN06].tr_eve.set(0, L[2], 0, L[3])
	}
	// @sl_wait
	if (L[4] == @On)	{
		@f.obj[@OBJ_EF_SCREEN06].tr_eve.wait
	}




return

// ---------------------------------------------------------------------------------------------------------
// 熱い風
// ---------------------------------------------------------------------------------------------------------
#z16

	@f.obj[@OBJ_EF_SCREEN07].create_movie(ef_hblast00, @On)
	@f.obj[@OBJ_EF_SCREEN07].tr = 180
	@f.obj[@OBJ_EF_SCREEN07].blend = 1
	@f.obj[@OBJ_EF_SCREEN07].layer = 1000
	@f.obj[@OBJ_EF_SCREEN07].set_scale(2000, 2000)

return


// ---------------------------------------------------------------------------------------------------------
// 回想表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z17

	@b.obj[@OBJ_EF_SCREEN08].create_movie_loop("ef_recollect0"+math.tostr(L[0]+1), @On)
	@b.obj[@OBJ_EF_SCREEN08].layer = -1
	@b.obj[@OBJ_EF_SCREEN08].set_scale(2000, 2000)
//	@b.obj[@OBJ_EF_SCREEN08].blend = 4
	@b.obj[@OBJ_EF_SCREEN08].wipe_copy = @On

return


// ---------------------------------------------------------------------------------------------------------
// 回想非表示
// ---------------------------------------------------------------------------------------------------------
#z18

	@f.obj[@OBJ_EF_SCREEN08].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// 火花表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z19

	switch (L[0])	{
		case (1)
			K[0] = "ef_spark02"
		default
			K[0] = "ef_spark01"
	}
	if (L[0] == 0)	{
		@f.obj[@OBJ_EF_SCREEN09].create_movie(K[0], @On)
	}
	else	{
		@f.obj[@OBJ_EF_SCREEN09].create_movie_loop(K[0], @On)
	}
	@f.obj[@OBJ_EF_SCREEN09].y += L[1]
	@f.obj[@OBJ_EF_SCREEN09].layer = 1000
	@f.obj[@OBJ_EF_SCREEN09].set_scale(2000, 2000)
//	@f.obj[@OBJ_EF_SCREEN09].blend = 4
	@f.obj[@OBJ_EF_SCREEN09].wipe_copy = @On

return


// ---------------------------------------------------------------------------------------------------------
// 火花非表示
// ---------------------------------------------------------------------------------------------------------
#z20

	@f.obj[@OBJ_EF_SCREEN09].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// 不穏な気配表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z21

	@b.obj[@OBJ_EF_SCREEN10].create_movie_loop(ef_unrest01, @On)
	@b.obj[@OBJ_EF_SCREEN10].tr = 120
	@b.obj[@OBJ_EF_SCREEN10].blend = 4
	@b.obj[@OBJ_EF_SCREEN10].layer = 1000
	@b.obj[@OBJ_EF_SCREEN10].set_scale(2000, 2000)
	@b.obj[@OBJ_EF_SCREEN10].wipe_copy = @On


return


// ---------------------------------------------------------------------------------------------------------
// 不穏な気配非表示
// ---------------------------------------------------------------------------------------------------------
#z22

	@f.obj[@OBJ_EF_SCREEN10].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// 集中線表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z23

	@b.obj[@OBJ_EF_SCREEN11].create_movie_loop(sd_em21b, @On)
	@b.obj[@OBJ_EF_SCREEN11].tr = 200
	@b.obj[@OBJ_EF_SCREEN11].set_pos(-100, -100)
	@b.obj[@OBJ_EF_SCREEN11].blend = 0
	@b.obj[@OBJ_EF_SCREEN11].layer = 1000
	@b.obj[@OBJ_EF_SCREEN11].set_scale(1500, 1500)
	@b.obj[@OBJ_EF_SCREEN11].wipe_copy = @On


return


// ---------------------------------------------------------------------------------------------------------
// 集中線非表示
// ---------------------------------------------------------------------------------------------------------
#z24

	@f.obj[@OBJ_EF_SCREEN11].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// キラーン表示
// ---------------------------------------------------------------------------------------------------------
#z25

	switch (L[0])	{
		case (0) K[0] = "ef_glitter01"
		case (1) K[0] = "ef_glitter02"
		case (2) K[0] = "ef_glitter03"
	}
	@f.obj[@OBJ_EF_SCREEN12].create_movie(K[0], @On, L[1], L[2], auto_free = @Off)
	@f.obj[@OBJ_EF_SCREEN12].tr = 255
	@f.obj[@OBJ_EF_SCREEN12].blend = 0
	@f.obj[@OBJ_EF_SCREEN12].layer = 1000
	@f.obj[@OBJ_EF_SCREEN12].wipe_copy = @On

return


// ---------------------------------------------------------------------------------------------------------
// 集中線非表示
// ---------------------------------------------------------------------------------------------------------
#z26

	@f.obj[@OBJ_EF_SCREEN12].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// キラキラ表示
// ---------------------------------------------------------------------------------------------------------
#z27

	switch (L[0])	{
		case (0) K[0] = "ef_twinkle01"
		case (1) K[0] = "ef_twinkle02"
	}

	@f.obj[@OBJ_EF_SCREEN13].create_movie_loop(K[0], @On)
	@f.obj[@OBJ_EF_SCREEN13].blend = 4
	@f.obj[@OBJ_EF_SCREEN13].layer = 1000
	@f.obj[@OBJ_EF_SCREEN13].wipe_copy = @On


return


// ---------------------------------------------------------------------------------------------------------
// キラキラ非表示
// ---------------------------------------------------------------------------------------------------------
#z28

	@f.obj[@OBJ_EF_SCREEN13].wipe_copy = @Off

return


// ---------------------------------------------------------------------------------------------------------
// 湯気表示[簡易]
// ---------------------------------------------------------------------------------------------------------
#z29

	@b.obj[@OBJ_EF_SCREEN14].create_movie_loop(ef_steam01, @On)
	@b.obj[@OBJ_EF_SCREEN14].blend = 4
	@b.obj[@OBJ_EF_SCREEN14].layer = 1000
	@b.obj[@OBJ_EF_SCREEN14].set_scale(2000, 2000)
	@b.obj[@OBJ_EF_SCREEN14].wipe_copy = @On


return


// ---------------------------------------------------------------------------------------------------------
// 湯気非表示
// ---------------------------------------------------------------------------------------------------------
#z30

	@f.obj[@OBJ_EF_SCREEN14].wipe_copy = @Off

return






















// ---------------------------------------------------------------------------------------------------------
// 01日目／陽光
// ---------------------------------------------------------------------------------------------------------
#z40

	@f.obj[@OBJ_EF_SCREEN20].create_movie(ef_sunset01, @On, auto_free = @Off)
	@f.obj[@OBJ_EF_SCREEN20].tr = 255
	@f.obj[@OBJ_EF_SCREEN20].set_scale(2000, 2000)
	@f.obj[@OBJ_EF_SCREEN20].blend = 1

return





#z41

/*
	screen.effect[0].init
	screen.effect[0].color_r = L[5]
	screen.effect[0].color_g = L[6]
	screen.effect[0].color_b = L[7]

	// 適用レイヤー設定
	if (@SC_LAYER_NUM == 0)	{
		screen.effect[0].begin_layer = @SC_BN_LAYER00
		screen.effect[0].end_layer = @SC_EN_LAYER01
	}
	elseif (@SC_LAYER_NUM == 1)	{
		screen.effect[0].begin_layer = @SC_BN_LAYER00
		screen.effect[0].end_layer = @SC_EN_LAYER02
	}
	frame_action_ch[1].start(-1, "$sc_flash_wl", L[0], L[1], L[2], L[3], L[4], @SC_TR_NUM)

	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)

*/

return


#z42

	frame_action_ch[1].end
	screen.effect[0].init

return








