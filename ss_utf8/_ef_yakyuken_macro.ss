//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_yakyuken_macro.ss
//	@author		Kazuya Takahashi
//	@note		野球拳処理
//
//-----------------------------------------------------------------------------------------------

#inc_start
	
	#define		@yakyuuken_obj			front.object[$$ef_get_omv_index(0)]
	
#inc_end

#z00



command $$yakyuken_start : int
{
//	$$set_child_object(@yakyuuken_obj, 4)
	
	@pcmch_play(1, @野田キュピーン)
	
	@椅子ロケット
	
	$$ef_create_omv_loop(back, ef_spark, 4, 0, 0, 2000)
	back.object[$$ef_get_omv_index(4)].layer = 110
	back.object[$$ef_get_omv_index(4)].blend = 0
	back.object[$$ef_get_omv_index(4)].wipe_copy = 1
	
	$$create_filter_random_flash(0, 70, 100, 200)
	
	@bs_set(-1, bs3_ot0303, @pos_ol)
	@bs_set(-1, bs3_iw0104_10, @pos_or)
	@wipe(0)
	
	@sc_flash_w
	
	@QUAKE_UD(100, 0, 0, 4)
	
	@bs_set(200, bs3_ot0303, @pos_fl)
	@bs_set(200, bs3_iw0104_10, @pos_fr)
	@wipe(3)
}


command $$yakyuken_end
{
	@pcmch_play(0, se_blade)
	
	@椅子ロケット消去
	@QUAKE_END
	front.object[$$ef_get_omv_index(4)].wipe_copy = 0
	front.object[$$ef_get_omv_index(5)].wipe_copy = 0
	
	@bs_set(-1, bs3_ot0303, @pos_ol)
	@bs_set(-1, bs3_iw0104_10, @pos_or)
	@wipe(0)
}

