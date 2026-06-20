/********************************************************
*														*
*				スクリプト初期設定						*
*														*
*********************************************************/
#z00

command $sys_set_gsd
{

	// バストショットネームフラグ初期設定
	$bs_name[0] = "nothing"
	$bs_name[1] = "nothing"
	$bs_name[2] = "nothing"
	$bs_name[3] = "nothing"
	$bs_name[4] = "nothing"
	$bs_name[5] = "nothing"

	// バストショットＸ座標
	$pos_ol   = -400
	$pos_fl2  =  100
	$pos_fl   =  190
	$pos_l    =  290
	$pos_hl2  =  350
	$pos_hl   =  440
	$pos_nl   =  490
	$pos_c    =  640
	$pos_nr   =  750
	$pos_hr   =  840
	$pos_hr2  =  900
	$pos_r    =  990
	$pos_fr   = 1090
	$pos_fr2  = 1190
	$pos_or   = 1440+150

	// バストショットＹ座標
	$pos_ot  = -900-60
	$pos_ft2 = -300-60
	$pos_ft  = -200-60
	$pos_t   = -100-60
	$pos_ht2 =    0-60
	$pos_ht  =  100-60
	$pos_nt  =  180-60
	$pos_m   =  200-60
	$pos_nu  =  250-60
	$pos_hu  =  300-60
	$pos_hu2 =  400-60
	$pos_u   =  500-60
	$pos_fu  =  600-60
	$pos_fu2 =  700-60
	$pos_ou  = 1100-60

	// バストショットＺ座標（レイヤー）
	$pos_z	 = 100000
	$pos_z1  = 500
	$pos_z2  = 490
	$pos_z3  = 480
	$pos_z4  = 470
	$pos_z5  = 460
	$pos_z6  = 450

	// キャラオブジェクト設定
	$BS01 =  0	// 音無
	$BS02 =  1	// かなで
	$BS03 =  2	// ゆり
	$BS04 =  3	// 日向
	$BS05 =  4	// ユイ
	$BS06 =  5	// 岩沢
	$BS07 =  6	// 松下（太）
	$BS08 =  7	// 松下（細）
	$BS09 =  8	// 野田
	$BS10 =  9	// 高松
	$BS11 = 10	// 大山
	$BS12 = 11	// 藤巻
	$BS13 = 12	// ＴＫ
	$BS14 = 13	// 椎名
	$BS15 = 14	// 遊佐
	$BS16 = 15	// ひさ子
	$BS17 = 16	// 関根
	$BS18 = 17	// 入江
	$BS19 = 18	// チャー
	$BS20 = 19	// 竹山
	$BS21 = 20	// 直井
	$BS22 = 21	// フィッシュ斎藤
	$BS23 = 22	// 五十嵐
	$BS24 = 23	// 赤目天使１
	$BS25 = 24	// 赤目天使２
	$BS26 = 25	// 影１
	$BS27 = 26	// 影２
	$BS28 = 27	// 影３
	$BS29 = 28	// 影４

	// キャラクター初期レイヤーセット
	$BS01_deflayer = 32	// 音無
	$BS02_deflayer = 80	// かなで
	$BS03_deflayer = 56	// ゆり
	$BS04_deflayer = 36	// 日向
	$BS05_deflayer = 84	// ユイ
	$BS06_deflayer = 60	// 岩沢
	$BS07_deflayer =  8	// 松下（太）
	$BS08_deflayer =  8	// 松下（細）
	$BS09_deflayer =  4	// 野田
	$BS10_deflayer = 16	// 高松
	$BS11_deflayer = 40	// 大山
	$BS12_deflayer = 12	// 藤巻
	$BS13_deflayer = 16	// ＴＫ
	$BS14_deflayer = 52	// 椎名
	$BS15_deflayer = 76	// 遊佐
	$BS16_deflayer = 64	// ひさ子
	$BS17_deflayer = 68	// 関根
	$BS18_deflayer = 72	// 入江
	$BS19_deflayer = 20	// チャー
	$BS20_deflayer = 48	// 竹山
	$BS21_deflayer = 44	// 直井
	$BS22_deflayer = 24	// フィッシュ斎藤
	$BS23_deflayer = 28	// 五十嵐
	$BS24_deflayer = 80	// 赤目天使１
	$BS25_deflayer = 80	// 赤目天使２
	$BS26_deflayer =  0	// 影１
	$BS27_deflayer =  0	// 影２
    $BS28_deflayer =  0	// 影３
    $BS29_deflayer =  0	// 影４

	// Layerセット
	@Set_chara_layer($BS01, $BS01_deflayer)	// 音無
	@Set_chara_layer($BS02, $BS02_deflayer)	// かなで
	@Set_chara_layer($BS03, $BS03_deflayer)	// ゆり
	@Set_chara_layer($BS04, $BS04_deflayer)	// 日向
	@Set_chara_layer($BS05, $BS05_deflayer)	// ユイ
	@Set_chara_layer($BS06, $BS06_deflayer)	// 岩沢
	@Set_chara_layer($BS07, $BS07_deflayer)	// 松下（太）
	@Set_chara_layer($BS08, $BS08_deflayer)	// 松下（細）
	@Set_chara_layer($BS09, $BS09_deflayer)	// 野田
	@Set_chara_layer($BS10, $BS10_deflayer)	// 高松
	@Set_chara_layer($BS11, $BS11_deflayer)	// 大山
	@Set_chara_layer($BS12, $BS12_deflayer)	// 藤巻
	@Set_chara_layer($BS13, $BS13_deflayer)	// ＴＫ
	@Set_chara_layer($BS14, $BS14_deflayer)	// 椎名
	@Set_chara_layer($BS15, $BS15_deflayer)	// 遊佐
	@Set_chara_layer($BS16, $BS16_deflayer)	// ひさ子
	@Set_chara_layer($BS17, $BS17_deflayer)	// 関根
	@Set_chara_layer($BS18, $BS18_deflayer)	// 入江
	@Set_chara_layer($BS19, $BS19_deflayer)	// チャー
	@Set_chara_layer($BS20, $BS20_deflayer)	// 竹山
	@Set_chara_layer($BS21, $BS21_deflayer)	// 直井
	@Set_chara_layer($BS22, $BS22_deflayer)	// フィッシュ斎藤
	@Set_chara_layer($BS23, $BS23_deflayer)	// 五十嵐
	@Set_chara_layer($BS24, $BS24_deflayer)	// 赤目天使１
	@Set_chara_layer($BS25, $BS25_deflayer)	// 赤目天使２
	@Set_chara_layer($BS26, $BS26_deflayer)	// 影１
	@Set_chara_layer($BS27, $BS27_deflayer)	// 影２
	@Set_chara_layer($BS28, $BS28_deflayer)	// 影３
	@Set_chara_layer($BS29, $BS29_deflayer)	// 影４

	// バストショット情報初期化
	@Clear_bs_info(@cha_maxentry)
	$chara_posx.clear(0, @cha_maxentry-1, @bs_pos_init)
	$chara_posx_prev.clear(0, @cha_maxentry-1, @bs_pos_init)
	$bs_action_set.clear(0, @bs_maxnum-1, @Off)
	$chara_scale_x_prev.clear(0, @cha_maxentry-1, 1000)
	$chara_scale_y_prev.clear(0, @cha_maxentry-1, 1000)
	$bs_action_scale_x_next.clear(0, @bs_maxnum-1, 1000)
	$bs_action_scale_y_next.clear(0, @bs_maxnum-1, 1000)
	$chara_tr_prev.clear(0, @cha_maxentry-1, 255)
	$bs_tr_next.clear(0, @bs_maxnum-1, 255)

	// バストショット標準表示スイッチ[スライド移動ＯＮ]
	@BS_DEFWIPE_ALL(@OFF)
	@BS_DEFWIPE(@OFF)

	// キャラクター服装初期化
	$bs_dress_init

//	for (L[0] = 0, L[0] < @bs_maxnum, L[0] += 1)	{
//		@f.obj[$bs_cha_num[10+L[0]]].init
//		@f.obj[$bs_cha_num[10+L[0]]].disp = @On
//		@f.obj[$bs_cha_num[10+L[0]]].wipe_copy = @On
//		@f.obj[$bs_cha_num[10+L[0]]].@cd.resize(10)
//	}

	// 初回起動設定
	if (@初回起動設定 == @Off)	{
		@CdState[+0]  = @On		// セーブ／ロード
		@CdState[+1]  = @On		// クイックセーブ／クイックロード
		@CdState[+2]  = @On		// 上書きセーブ
		@CdState[+3]  = @On		// 前の選択肢に戻る
		@CdState[+4]  = @On		// セーブデータの入れ替え
		@CdState[+5]  = @On		// タイトルに戻る
		@CdState[+6]  = @On		// セーブデータの削除
		@CdState[+7]  = @On		// ゲームを終了する
		@EmDispState  = @On		// エモーションＯＮ
		@EsAutoSave   = @On		// オートセーブを有効化
		@SetMusicStateDefault
		@EsSelSkipReset = @On	// 分岐でスキップモード - 解除する
		@初回起動設定 = @On
		@システムボタンロック = @On
		@SpotDispState = @On	// 現在地表示ＯＮ
		// 体験版の処理
		if( @trial_check() ){
			@実績獲得表示する = @Off
		}
		else	{
			@実績獲得表示する = @On
		}
	}

	// メッセージウィンドウ初期化
//	@通常ウィンドウ
	$get_mwnd_no = 0
	@メッセージウィンドウ初期化

	// ＢＧＭタイトル制御
//	@ＢＧＭタイトル制御
	@EsBgmDetailDispPrev = -1

	// スクリーンフィルターの初期化
	@SC_TR(@SC_TR_DEF)
	@SC_LAYER(@SC_LAYER_DEF)

	// トーンカーブ制御を有効にする
	@時刻管理有効

	// フェードをクリックでスキップ可能に
	@MovieFadeIn = @Off

	// メッセージウィンドウボタンの表示ロック／アンロック／説明ポップ
	$msg_btn_pos_init
	frame_action_ch[0].start(-1, "$msg_btn_watch")

	// デバック用：@Days表示
//	frame_action_ch[1].start(-1, "$days_num_disp")

	// 実績機能システム初期化
	@実績システム初期化
}


command $excall_watch(property $fa : frameaction)
{
	// システムコール中
	if (syscom.get_hide_mwnd_onoff_flag == @On)	{
		@f.obj[@SysBTDisp].disp = @Off
	}
	else	{
		@f.obj[@SysBTDisp].disp = @On
	}
}

command $days_num_disp(property $fa : frameaction)
{

	// デバック中は表示
	if (system.check_debug_flag == @On)	{
		if ($days_create == 0)	{
			@f.obj[@OBJ_DAYS].init
			@f.obj[@OBJ_DAYS].disp = @On
			@f.obj[@OBJ_DAYS].layer = 100000
			@f.obj[@OBJ_DAYS].@cd.resize(2)
			@f.obj[@OBJ_DAYS].wipe_copy = @On

			@f.obj[@OBJ_DAYS].@cd[0].create_string("現在の@Days = ", @On)
			@f.obj[@OBJ_DAYS].@cd[0].set_string_param(18, 0, 0, 0, 0, 1, 2)

			@f.obj[@OBJ_DAYS].@cd[1].create_number(sys_day_num02, @On, 120, 0)
			@f.obj[@OBJ_DAYS].@cd[1].set_scale(100, 100)
			@f.obj[@OBJ_DAYS].@cd[1].set_number(@Days)
			$days_create = 1
		}
		else	{
			@f.obj[@OBJ_DAYS].@cd[1].set_number(@Days)
		}
	}
}


// ----------------------------------------------------------------------------
// キャラクター服装初期化
// ----------------------------------------------------------------------------
command $bs_dress_init
{

	@音無服装			= @戦線制服
	@かなで服装			= @ＮＰＣ制服
	@ゆり服装			= @戦線制服
	@日向服装			= @戦線制服
	@ユイ服装			= @戦線制服
	@岩沢服装			= @戦線制服
	@松下服装			= @戦線制服
	@野田服装			= @戦線制服
	@高松服装			= @戦線制服
	@大山服装			= @戦線制服
	@藤巻服装			= @戦線制服
	@ＴＫ服装			= @戦線制服
	@椎名服装			= @戦線制服
	@遊佐服装			= @戦線制服
	@ひさ子服装			= @戦線制服
	@関根服装			= @戦線制服
	@入江服装			= @戦線制服
	@チャー服装			= @戦線制服
	@竹山服装			= @戦線制服
	@直井服装			= @ＮＰＣ制服_帽子
	@フィッシュ斎藤服装	= @戦線制服
	@五十嵐服装			= @制服
	@赤目天使１服装     = @ＮＰＣ制服
	@赤目天使２服装     = @ＮＰＣ制服

}


// ----------------------------------------------------------------------------
// メッセージウィンドウボタンの表示ロック／アンロック／説明ポップ
// ----------------------------------------------------------------------------
command $msg_btn_watch(property $fa : frameaction)
{

	// かなでの呼び方
	if (@天使_呼び方 == @かなでと呼ぶ)	{
		@かなでの音声ボタン変更 = @On
	}

	if (@f.mwnd[0].@obj[0].exist_type == 0)	{
		$msg_btn_pos_init
	}

	// メッセージウィンドウボタンの下地の透過度をウィンドウのそれと同期する
//	@f.mwnd[0].button[0].tr = syscom.get_filter_color_a

	// 常時表示
	if (@システムボタンロック == @On)	{
		// btn bg
		@f.mwnd[0].button[0].y_rep_eve[0].set(0, 0, 0, 2)

		// close常時表示

		// save, load, qsave, qload, return_sel, read_skip(2), auto_mode(2)
		for (L[0] = 2, L[0] < 11, L[0] += 1)	{
			@f.mwnd[0].button[L[0]].y_rep_eve[0].set(0, 0, 0, 2)
		}

		// koe常時表示

		// config, msg_log, Title, End, Lock off, Lock on
		for (L[0] = 12, L[0] < 18, L[0] += 1)	{
			@f.mwnd[0].button[L[0]].y_rep_eve[0].set(0, 0, 0, 2)
		}
	}
	// 一時表示
	elseif ((@MY > 650) && (@システムボタンロック == @Off) && (system.check_active == @On))	{
//		if (@f.mwnd[0].button[0].y_rep_eve[0].check != 1)	{
		if (@f.mwnd[0].button[0].y_rep[0] != 0)	{
			// btn bg
			@f.mwnd[0].button[0].y_rep_eve[0].set(0, 250, 0, 2)

			// close常時表示

			// save, load, qsave, qload, return_sel, read_skip(2), auto_mode(2)
			for (L[0] = 2, L[0] < 11, L[0] += 1)	{
				@f.mwnd[0].button[L[0]].y_rep_eve[0].set(0, 250, 0, 2)
			}

			// koe常時表示

			// config, msg_log, Title, End, Lock off, Lock on
			for (L[0] = 12, L[0] < 18, L[0] += 1)	{
				@f.mwnd[0].button[L[0]].y_rep_eve[0].set(0, 250, 0, 2)
			}
		}
	}
	// 一時非表示
	elseif ((@MY <= 650) && (@システムボタンロック == @Off) && (system.check_active == @On))	{
//		if (@f.mwnd[0].button[0].y_rep_eve[0].check != 1)	{
		if (@f.mwnd[0].button[0].y_rep[0] != 40)	{
			// btn bg
			@f.mwnd[0].button[0].y_rep_eve[0].set(40, 300, 0, 0)

			// close常時表示

			// save, load, qsave, qload, return_sel, read_skip(2), auto_mode(2)
			for (L[0] = 2, L[0] < 11, L[0] += 1)	{
				@f.mwnd[0].button[L[0]].y_rep_eve[0].set(40, 300, 0, 0)
			}

			// koe常時表示

			// config, msg_log, Title, End, Lock off, Lock on
			for (L[0] = 12, L[0] < 18, L[0] += 1)	{
				@f.mwnd[0].button[L[0]].y_rep_eve[0].set(40, 300, 0, 0)
			}
		}
	}

	// ボタンの説明ポップ
	if (@f.mwnd[0].button[1].get_button_real_state == 1 || @f.mwnd[0].button[1].get_button_real_state == 2)	{
		// close
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(1030, 60)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 14
	}
	elseif (@f.mwnd[0].button[2].get_button_real_state == 1 || @f.mwnd[0].button[2].get_button_real_state == 2)	{
		// save
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(486, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 2
	}
	elseif (@f.mwnd[0].button[3].get_button_real_state == 1 || @f.mwnd[0].button[3].get_button_real_state == 2)	{
		// load
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(557, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 3
	}
	elseif (@f.mwnd[0].button[4].get_button_real_state == 1 || @f.mwnd[0].button[4].get_button_real_state == 2)	{
		// Q.save
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(326, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 0
		
	}
	elseif (@f.mwnd[0].button[5].get_button_real_state == 1 || @f.mwnd[0].button[5].get_button_real_state == 2)	{
		// Q.load
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(409, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 1
	}
	elseif (@f.mwnd[0].button[6].get_button_real_state == 1 || @f.mwnd[0].button[6].get_button_real_state == 2)	{
		// back
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(628, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 4
	}
	elseif (@f.mwnd[0].button[7].get_button_real_state == 1 || @f.mwnd[0].button[7].get_button_real_state == 2)	{
		// skip.off
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(841, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 8
	}
	elseif (@f.mwnd[0].button[8].get_button_real_state == 1 || @f.mwnd[0].button[8].get_button_real_state == 2)	{
		// skip.on
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(841, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 9
	}
	elseif (@f.mwnd[0].button[9].get_button_real_state == 1 || @f.mwnd[0].button[9].get_button_real_state == 2)	{
		// auto.off
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(770, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 6
	}
	elseif (@f.mwnd[0].button[10].get_button_real_state == 1 || @f.mwnd[0].button[10].get_button_real_state == 2)	{
		// auto.on
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(770, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 7
	}
	elseif (@f.mwnd[0].button[11].get_button_real_state == 1 || @f.mwnd[0].button[11].get_button_real_state == 2)	{
		// koe
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(1052, 88)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 15
	}
	elseif (@f.mwnd[0].button[12].get_button_real_state == 1 || @f.mwnd[0].button[12].get_button_real_state == 2)	{
		// config
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(1072, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 12
	}
	elseif (@f.mwnd[0].button[13].get_button_real_state == 1 || @f.mwnd[0].button[13].get_button_real_state == 2)	{
		// log
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(699, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 5
	}
	elseif (@f.mwnd[0].button[14].get_button_real_state == 1 || @f.mwnd[0].button[14].get_button_real_state == 2)	{
		// title
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(918, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 10
	}
	elseif (@f.mwnd[0].button[15].get_button_real_state == 1 || @f.mwnd[0].button[15].get_button_real_state == 2)	{
		// quit
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(995, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 11
	}
	elseif (@f.mwnd[0].button[16].get_button_real_state == 1 || @f.mwnd[0].button[16].get_button_real_state == 2)	{
		// lock.off
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(1098, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 13
	}
	elseif (@f.mwnd[0].button[17].get_button_real_state == 1 || @f.mwnd[0].button[17].get_button_real_state == 2)	{
		// lock.on
		@f.mwnd[$get_mwnd_no].@obj[0].set_pos(1098, 173)
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 255
		@f.mwnd[$get_mwnd_no].@obj[0].patno = 13
	}
	else	{
		@f.mwnd[$get_mwnd_no].@obj[0].tr = 0
	}
}


// ----------------------------------------------------------------------------
// メッセージウィンドウボタン初期位置設定
// ----------------------------------------------------------------------------
command $msg_btn_pos_init
{

	if (@システムボタンロック == @Off)	{
		// btn bg
		@f.mwnd[0].button[0].y_rep.resize(1)
		@f.mwnd[0].button[0].y_rep[0] = 40

		// close常時表示

		// save, load, qsave, qload, return_sel, read_skip(2), auto_mode(2)
		for (L[0] = 2, L[0] < 11, L[0] += 1)	{
			@f.mwnd[0].button[L[0]].y_rep.resize(1)
			@f.mwnd[0].button[L[0]].y_rep[0] = 40
		}

		// koe常時表示

		// config, msg_log, Title, End, Lock off, Lock on
		for (L[0] = 12, L[0] < 18, L[0] += 1)	{
			@f.mwnd[0].button[L[0]].y_rep.resize(1)
			@f.mwnd[0].button[L[0]].y_rep[0] = 40
		}
	}
	else	{
		// btn bg
		@f.mwnd[0].button[0].y_rep.resize(1)
		@f.mwnd[0].button[0].y_rep[0] = 00

		// close常時表示

		// save, load, qsave, qload, return_sel, read_skip(2), auto_mode(2)
		for (L[0] = 2, L[0] < 11, L[0] += 1)	{
			@f.mwnd[0].button[L[0]].y_rep.resize(1)
			@f.mwnd[0].button[L[0]].y_rep[0] = 0
		}

		// koe常時表示

		// config, msg_log, Title, End, Lock off, Lock on
		for (L[0] = 12, L[0] < 18, L[0] += 1)	{
			@f.mwnd[0].button[L[0]].y_rep.resize(1)
			@f.mwnd[0].button[L[0]].y_rep[0] = 0
		}
	}

	$get_mwnd_no = 0
	@f.mwnd[$get_mwnd_no].@obj[0].init
	@f.mwnd[$get_mwnd_no].@obj[0].create(sys_mw01_btnpos00, @On, 0, 0)
	@f.mwnd[$get_mwnd_no].@obj[0].tr = 0
	@f.mwnd[$get_mwnd_no].@obj[0].layer = 10000
	//@f.mwnd[$get_mwnd_no].@obj[0].wipe_copy = @On
}

