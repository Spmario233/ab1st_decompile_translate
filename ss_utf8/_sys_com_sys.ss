/********************************************************
*														*
*					システムコール						*
*														*
*********************************************************/
#z00

#inc_start

	#property	$mgw_win_state_prev
	#property	$quake_state_prev


	#property	$msbtn_state_qs
	#define		@MSBTN_STATE_QS		$msbtn_state_qs

	#property	$msbtn_state_ql
	#define		@MSBTN_STATE_QL		$msbtn_state_qL

	#property	$msbtn_state_sel
	#define		@MSBTN_STATE_SEL	$msbtn_state_sel


#inc_end


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■システムコール準備
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $excall_ready
{
	// 画面キャプチャー
	capture

	// メッセージウィンドウの状態保存
	$mgw_win_state_prev = script.get_mwnd_disp_off_flag

	// 画面クエイクの状態保存
	$quake_state_prev = script.get_quake_stop_flag

	// メッセージウィンドウを閉じる
	script.set_mwnd_disp_off_flag(1)

	// クエイクを一時停止する
	script.set_quake_stop_flag(1)

	// 一時的に早送りを禁止する
	script.set_skip_disable

	// システムコール準備
	excall.alloc

}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■システムコール解放
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $excall_free
{
	// システムコールを解放する
	excall.free

	// メッセージウィンドウの状態復元
	script.set_quake_stop_flag($mgw_win_state_prev)

	// 画面クエイクの状態復元
	script.set_mwnd_disp_off_flag($quake_state_prev)

	// 早送り禁止を解除する
	script.set_skip_enable

	// 画面キャプチャーを解放
	capture_free

	// システムメニューフラグを初期化
	$sys_mode = $no_mode

}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■メッセージボタン：クイックセーブ
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_quick_save_btn
{

	capture

	if (@CdState[+1] == @On) {

		// 一時的に「キーで早送りを止める機能」を無効にする
		script.set_stop_skip_by_key_disable

		// セーブ確認決定音
		@se_play(001)

		$sys_conf = @On

		@CdStateReady = @Off

		@f.obj[@ObjSysTMenu00].init
		@f.obj[@ObjSysTMenu00].order = 2
		@f.obj[@ObjSysTMenu00].layer = 1000
		@f.obj[@ObjSysTMenu00].disp = @On
		@f.obj[@ObjSysTMenu00].@cd.resize(5)

		// 確認ダイアログ
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].create(sys_sa_chk00,      @On, 1095, 343)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].create(bg_kuro,        @On,    0,   0)

		@f.obj[@ObjSysTMenu00].tr = 0
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].tr = 150
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].layer = -1

		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 確認ダイアログ表示
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].patno = 0
		@f.obj[@ObjSysTMenu00].tr_eve.set(255, L[20], 0, 2)

		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{

			@MSCHK_PREV = @MSCHK
			@MSCHK = @MSBTN_NONE
			@MS_STATE_CONF_PREV = @MS_STATE_CONF

			// 初期化処理（キーが放されていたら状態を初期化する）
			if (input.decide.is_up == @On)	{
				@MS_STATE_CONF = @MSBTN_INIT
				@S_CTL_BAR_ACTIVE      = @Off
				@S_CTL_BAR_CTLACTIVE   = @Off
				@S_CTL_BAR_CTLPOS_PREV = @Init
			}

			//
			// マウスカーソル判定
			//

			@if_(@Off, @Off, 0, @ObjSysTMenu00, _ObjSysQDataBtn01)
			@if_(@Off, @Off, 1, @ObjSysTMenu00, _ObjSysQDataBtn02)
			@if_(@Off, @Off, 2, @ObjSysTMenu00, _ObjSysQDataChk00)

			// マウスボタン入力判定
			if (input.decide.is_up == @On)	{
				if (@MSCHK != @MSBTN_NONE){
					if (@MSCHK != @MSCHK_PREV)	{
						@se_play(000)
					}
					@MSBTN_STATE = @MSBTN_TOUCH
				}
				else	{
					@MSBTN_STATE = @MSBTN_NORMAL
				}
			}
			elseif (input.decide.is_down == @On)	{
				if (@MS_STATE_CONF != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE_CONF) && (@MSCHK != @MSBTN_NONE))	{
						if (@MSCHK != @MSCHK_PREV)	{
							@se_play(000)
						}
						@MSBTN_STATE = @MSBTN_PUSH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				else	{
					@MSBTN_STATE = @MSBTN_PUSH
					@MS_STATE_CONF = @MSCHK
				}
			}
			if (input.cancel.on_down_up == @On)	{
//				input.clear
				L[0] = @Off
				$break_switch = @On
				break
			}
			elseif (input.decide.on_down_up == @On)	{
				if (@MS_STATE_CONF_PREV != @MSBTN_INIT){
					if ((@MSCHK == @MS_STATE_CONF_PREV) && (@MSCHK != @MSBTN_NONE))	{
						@MSBTN_STATE = @MSBTN_TOUCH
						@MSBTN_RESULT = @DECIDE
					}
					else{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
					@MS_STATE_CONF = @MSBTN_INIT
				}
//				input.clear
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].patno = $obj_btn_state[0]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].patno = $obj_btn_state[1]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {
				@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2] + @Operate
			}

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				switch (@MSCHK)	{
					case (0)
						// Yes
						L[0] = @On
						break
					case (1)
						// No
						@se_play(002)
						L[0] = @Off
						$break_switch = @On
						break
					case (2)
						// QuickSaveChk
		     			@se_play(001)
		     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
						elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
			// 状態表示
//			input.next
			disp

		}
	}
	else	{
		// セーブＯＫ決定音
		@se_play(001)
	}

	if ($break_switch == @Off)	{
		// クイックセーブ
		if ((L[0] == @On) || (@CdState[+1] == @Off ))	{

			// クイックセーブデータ０番に上書きするので、履歴に反映させる
			for ($sys_forlc0 = 0, $sys_forlc0 < 10, $sys_forlc0 += 1)	{
				@SysSLDataExist[+$sys_forlc0] = syscom.get_quick_save_exist($sys_forlc0)
			}

			// 0あり
			if (@SysSLDataExist[+0] == @On)	{
				if (@SysSLDataExist[+1] == @On)	{
					// 1あり
					if (@SysSLDataExist[+2] == @On)	{
						// 2あり
						if (@SysSLDataExist[+3] == @On)	{
							// 3あり
							if (@SysSLDataExist[+4] == @On)	{
								// 4あり
								if (@SysSLDataExist[+5] == @On)	{
									// 5あり
									if (@SysSLDataExist[+6] == @On)	{
										// 6あり
										if (@SysSLDataExist[+7] == @On)	{
											// 7あり
											if (@SysSLDataExist[+8] == @On)	{
												// 8あり
												if (@SysSLDataExist[+9] == @On)	{
													// 9あり
													// delete 9
													syscom.copy_quick_save(8, 9)
													syscom.copy_quick_save(7, 8)
													syscom.copy_quick_save(6, 7)
													syscom.copy_quick_save(5, 6)
													syscom.copy_quick_save(4, 5)
													syscom.copy_quick_save(3, 4)
													syscom.copy_quick_save(2, 3)
													syscom.copy_quick_save(1, 2)
													syscom.copy_quick_save(0, 1)
												}
												else	{
													syscom.copy_quick_save(8, 9)
													syscom.copy_quick_save(7, 8)
													syscom.copy_quick_save(6, 7)
													syscom.copy_quick_save(5, 6)
													syscom.copy_quick_save(4, 5)
													syscom.copy_quick_save(3, 4)
													syscom.copy_quick_save(2, 3)
													syscom.copy_quick_save(1, 2)
													syscom.copy_quick_save(0, 1)
												}
											}
											else	{
												syscom.copy_quick_save(7, 8)
												syscom.copy_quick_save(6, 7)
												syscom.copy_quick_save(5, 6)
												syscom.copy_quick_save(4, 5)
												syscom.copy_quick_save(3, 4)
												syscom.copy_quick_save(2, 3)
												syscom.copy_quick_save(1, 2)
												syscom.copy_quick_save(0, 1)
											}
										}
										else	{
											syscom.copy_quick_save(6, 7)
											syscom.copy_quick_save(5, 6)
											syscom.copy_quick_save(4, 5)
											syscom.copy_quick_save(3, 4)
											syscom.copy_quick_save(2, 3)
											syscom.copy_quick_save(1, 2)
											syscom.copy_quick_save(0, 1)
										}
									}
									else	{
										syscom.copy_quick_save(5, 6)
										syscom.copy_quick_save(4, 5)
										syscom.copy_quick_save(3, 4)
										syscom.copy_quick_save(2, 3)
										syscom.copy_quick_save(1, 2)
										syscom.copy_quick_save(0, 1)
									}
								}
								else	{
									syscom.copy_quick_save(4, 5)
									syscom.copy_quick_save(3, 4)
									syscom.copy_quick_save(2, 3)
									syscom.copy_quick_save(1, 2)
									syscom.copy_quick_save(0, 1)
								}
							}
							else	{
								syscom.copy_quick_save(3, 4)
								syscom.copy_quick_save(2, 3)
								syscom.copy_quick_save(1, 2)
								syscom.copy_quick_save(0, 1)
							}
						}
						else	{
							syscom.copy_quick_save(2, 3)
							syscom.copy_quick_save(1, 2)
							syscom.copy_quick_save(0, 1)
						}
					}
					else	{
						syscom.copy_quick_save(1, 2)
						syscom.copy_quick_save(0, 1)
					}
				}
				else	{
					syscom.copy_quick_save(0, 1)
				}
			}
			if (@CdState[+1] == @On) {
				// セーブＯＫ決定音
				@se_play(001)
			}
			syscom.quick_save(0, @Off, @Off)
			if (@CdState[+1] == @Off) {
				$quick_save_disp
			}
			@timewait(250)
		}
	}

	if (@CdStateReady == @On ) {@CdState[+1] = @Off}

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250
		case (@Fast) L[20] = 250/2
		case (@Inst) L[20] = 0
	}

	// 確認ダイアログ消去
	@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)

	$sys_conf = @Off

	// 一時的に「キーで早送りを止める機能」を無効を解除する
	script.set_stop_skip_by_key_enable

	$break_switch = @Off

	capture_free
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■メッセージボタン：クイックロード
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_quick_load_btn
{

	if (@CdState[+1] == @On) {

		// 一時的に「キーで早送りを止める機能」を無効にする
		script.set_stop_skip_by_key_disable

		// ロード確認決定音
		@se_play(001)

		$sys_conf = @On

		@CdStateReady = @Off

		@f.obj[@ObjSysTMenu00].init
		@f.obj[@ObjSysTMenu00].order = 2
		@f.obj[@ObjSysTMenu00].layer = 1000
		@f.obj[@ObjSysTMenu00].disp = @On
		@f.obj[@ObjSysTMenu00].@cd.resize(5)

		// 確認ダイアログ
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].create(sys_lo_setbtn01,   @On,  659, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].create(sys_lo_setbtn02,   @On,  854, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].create(sys_lo_chk00,      @On, 1095, 343)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].create(bg_kuro,        @On,    0,   0)

		@f.obj[@ObjSysTMenu00].tr = 0
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].tr = 150
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].layer = -1

		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 確認ダイアログ表示
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].patno = 1
		@f.obj[@ObjSysTMenu00].tr_eve.set(255, L[20], 0, 2)

		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{

			@MSCHK_PREV = @MSCHK
			@MSCHK = @MSBTN_NONE
			@MS_STATE_CONF_PREV = @MS_STATE_CONF

			// 初期化処理（キーが放されていたら状態を初期化する）
			if (input.decide.is_up == @On)	{
				@MS_STATE_CONF = @MSBTN_INIT
				@S_CTL_BAR_ACTIVE      = @Off
				@S_CTL_BAR_CTLACTIVE   = @Off
				@S_CTL_BAR_CTLPOS_PREV = @Init
			}

			//
			// マウスカーソル判定
			//

			@if_(@Off, @Off, 0, @ObjSysTMenu00, _ObjSysQDataBtn01)
			@if_(@Off, @Off, 1, @ObjSysTMenu00, _ObjSysQDataBtn02)
			@if_(@Off, @Off, 2, @ObjSysTMenu00, _ObjSysQDataChk00)

			// マウスボタン入力判定
			if (input.decide.is_up == @On)	{
				if (@MSCHK != @MSBTN_NONE){
					if (@MSCHK != @MSCHK_PREV)	{
						@se_play(000)
					}
					@MSBTN_STATE = @MSBTN_TOUCH
				}
				else	{
					@MSBTN_STATE = @MSBTN_NORMAL
				}
			}
			elseif (input.decide.is_down == @On)	{
				if (@MS_STATE_CONF != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE_CONF) && (@MSCHK != @MSBTN_NONE))	{
						if (@MSCHK != @MSCHK_PREV)	{
							@se_play(000)
						}
						@MSBTN_STATE = @MSBTN_PUSH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				else	{
					@MSBTN_STATE = @MSBTN_PUSH
					@MS_STATE_CONF = @MSCHK
				}
			}
			if (input.cancel.on_down_up == @On)	{
//				input.clear
				@MSCHK = @Off
				$break_switch = @On
				break
			}
			elseif (input.decide.on_down_up == @On)	{
				if (@MS_STATE_CONF_PREV != @MSBTN_INIT){
					if ((@MSCHK == @MS_STATE_CONF_PREV) && (@MSCHK != @MSBTN_NONE))	{
						@MSBTN_STATE = @MSBTN_TOUCH
						@MSBTN_RESULT = @DECIDE
					}
					else{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
					@MS_STATE_CONF = @MSBTN_INIT
				}
//				input.clear
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].patno = $obj_btn_state[0]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].patno = $obj_btn_state[1]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {
				@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2] + @Operate
			}

			// 状態表示
//			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				switch (@MSCHK)	{
					case (0)
						// Yes
						@MSCHK = @On
						break
					case (1)
						// No
						@se_play(002)
						@MSCHK = @Off
						$break_switch = @On
						break
					case (2)
						// QuickSaveChk
		     			@se_play(001)
		     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
						elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
		}
	}

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0
	}

	if (@CdStateReady == @On ) {@CdState[+1] = @Off}

	if ($break_switch == @Off)	{
		if ((@MSCHK == @On) || (@CdState[+1] == @Off ))	{
			// 揺れコマンドを停止
			@QUAKE_END_ALL(500)
			// クイックロード
			@se_play(003)
			@PCM_STOP @PCMCH_STOP_ALL
			@bgm_stop(2000)
			// 確認ダイアログ消去
			@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)
			// ショートカットのフレームアクションを停止
			frame_action_ch[0].end
			@f.obj[@ObjSysMenu00].create(bg_kuro, @On, 0, 0)
			@f.obj[@ObjSysMenu00].order = 2
			@f.obj[@ObjSysMenu00].tr = 0
			@f.obj[@ObjSysMenu00].layer = 1000000
			@f.obj[@ObjSysMenu00].tr_eve.set(255, L[21], 0, 0)
			@f.obj[@ObjSysMenu00].tr_eve.wait_key
			se.stop(1000)
			syscom.quick_load(0, 0, @Off, @Off)
		}
	}

	// 確認ダイアログ消去
	@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)

	$sys_conf = @Off

	// 一時的に「キーで早送りを止める機能」を無効を解除する
	script.set_stop_skip_by_key_enable

	$break_switch = @Off


}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■前の選択肢に戻る
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_undo_btn
{

	if (@CdState[+3] == @On) {

		// 一時的に「キーで早送りを止める機能」を無効にする
		script.set_stop_skip_by_key_disable

		// 前の選択肢に戻る決定音
		@se_play(001)

		$sys_conf = @On

		@CdStateReady = @Off

		@f.obj[@ObjSysTMenu00].init
		@f.obj[@ObjSysTMenu00].order = 2
		@f.obj[@ObjSysTMenu00].layer = 1000
		@f.obj[@ObjSysTMenu00].disp = @On
		@f.obj[@ObjSysTMenu00].@cd.resize(5)

		// 確認ダイアログ
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].create(sys_sa_chk00,      @On, 1095, 343)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].create(bg_kuro,        @On,    0,   0)

		@f.obj[@ObjSysTMenu00].tr = 0
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].tr = 150
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].layer = -1

		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 確認ダイアログ表示
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].patno = 2
		@f.obj[@ObjSysTMenu00].tr_eve.set(255, L[20], 0, 2)

		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{

			@MSCHK_PREV = @MSCHK
			@MSCHK = @MSBTN_NONE
			@MS_STATE_CONF_PREV = @MS_STATE_CONF

			// 初期化処理（キーが放されていたら状態を初期化する）
			if (input.decide.is_up == @On)	{
				@MS_STATE_CONF = @MSBTN_INIT
				@S_CTL_BAR_ACTIVE      = @Off
				@S_CTL_BAR_CTLACTIVE   = @Off
				@S_CTL_BAR_CTLPOS_PREV = @Init
			}

			//
			// マウスカーソル判定
			//

			@if_(@Off, @Off, 0, @ObjSysTMenu00, _ObjSysQDataBtn01)
			@if_(@Off, @Off, 1, @ObjSysTMenu00, _ObjSysQDataBtn02)
			@if_(@Off, @Off, 2, @ObjSysTMenu00, _ObjSysQDataChk00)

			// マウスボタン入力判定
			if (input.decide.is_up == @On)	{
				if (@MSCHK != @MSBTN_NONE){
					if (@MSCHK != @MSCHK_PREV)	{
						@se_play(000)
					}
					@MSBTN_STATE = @MSBTN_TOUCH
				}
				else	{
					@MSBTN_STATE = @MSBTN_NORMAL
				}
			}
			elseif (input.decide.is_down == @On)	{
				if (@MS_STATE_CONF != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE_CONF) && (@MSCHK != @MSBTN_NONE))	{
						if (@MSCHK != @MSCHK_PREV)	{
							@se_play(000)
						}
						@MSBTN_STATE = @MSBTN_PUSH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				else	{
					@MSBTN_STATE = @MSBTN_PUSH
					@MS_STATE_CONF = @MSCHK
				}
			}
			if (input.cancel.on_down_up == @On)	{
//				input.clear
				L[0] = @Off
				$break_switch = @On
				break
			}
			elseif (input.decide.on_down_up == @On)	{
				if (@MS_STATE_CONF_PREV != @MSBTN_INIT){
					if ((@MSCHK == @MS_STATE_CONF_PREV) && (@MSCHK != @MSBTN_NONE))	{
						@MSBTN_STATE = @MSBTN_TOUCH
						@MSBTN_RESULT = @DECIDE
					}
					else{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
					@MS_STATE_CONF = @MSBTN_INIT
				}
//				input.clear
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].patno = $obj_btn_state[0]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].patno = $obj_btn_state[1]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {
				@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2] + @Operate
			}

			// 状態表示
//			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				switch (@MSCHK)	{
					case (0)
						// Yes
						L[0] = @On
						break
					case (1)
						// No
						@se_play(002)
						L[0] = @Off
						$break_switch = @On
						break
					case (2)
						// QuickSaveChk
		     			@se_play(001)
		     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
						elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
		}
	}

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0
	}

	if (@CdStateReady == @On ) {@CdState[+3] = @Off}

	if ($break_switch == @Off)	{
		// 前の選択肢に戻る
		if ((L[0] == @On) || (@CdState[+3] == @Off ))	{
			// 揺れコマンドを停止
			@QUAKE_END_ALL(500)
			// 前の選択肢に戻るＯＫ決定音
			@se_play(003)
			@PCM_STOP @PCMCH_STOP_ALL
			@bgm_stop(2000)
			// 確認ダイアログ消去
			@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)
			@f.obj[@ObjSysMenu00].create(bg_kuro, @On, 0, 0)
			@f.obj[@ObjSysMenu00].order = 2
			@f.obj[@ObjSysMenu00].tr = 0
			@f.obj[@ObjSysMenu00].layer = 1000000
			@f.obj[@ObjSysMenu00].tr_eve.set(255, L[21], 0, 0)
			@f.obj[@ObjSysMenu00].tr_eve.wait_key
			se.stop(1000)
			syscom.return_to_sel(@Off, @Off, @Off)
		}
	}

	// 確認ダイアログ消去
	@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)

	$sys_conf = @Off

	$break_switch = @Off

	// 一時的に「キーで早送りを止める機能」を無効を解除する
	script.set_stop_skip_by_key_enable
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■選択肢直前セーブ
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_seL_save
{

	if (@シーン回想中 == @Off)	{

		// 通常セーブ	：0－149
		// 選択肢セーブ	：150-159
		// 日付セーブ	：160-169

		// クイックセーブデータ０番に上書きするので、履歴に反映させる
		for ($sys_forlc0 = 0, $sys_forlc0 < 9, $sys_forlc0 += 1)	{
			@SysSLDataExist[+$sys_forlc0] = syscom.get_save_exist(150+$sys_forlc0)
		}

		// 0あり
		if (@SysSLDataExist[+0] == @On)	{
			if (@SysSLDataExist[+1] == @On)	{
				// 1あり
				if (@SysSLDataExist[+2] == @On)	{
					// 2あり
					if (@SysSLDataExist[+3] == @On)	{
						// 3あり
						if (@SysSLDataExist[+4] == @On)	{
							// 4あり
							if (@SysSLDataExist[+5] == @On)	{
								// 5あり
								if (@SysSLDataExist[+6] == @On)	{
									// 6あり
									if (@SysSLDataExist[+7] == @On)	{
										// 7あり
										if (@SysSLDataExist[+8] == @On)	{
											// 8あり
											if (@SysSLDataExist[+9] == @On)	{
												// 9あり
												// delete 9
												syscom.copy_save(158, 159)
												syscom.copy_save(157, 158)
												syscom.copy_save(156, 157)
												syscom.copy_save(155, 156)
												syscom.copy_save(154, 155)
												syscom.copy_save(153, 154)
												syscom.copy_save(152, 153)
												syscom.copy_save(151, 152)
												syscom.copy_save(150, 151)
											}
											else	{
												syscom.copy_save(158, 159)
												syscom.copy_save(157, 158)
												syscom.copy_save(156, 157)
												syscom.copy_save(155, 156)
												syscom.copy_save(154, 155)
												syscom.copy_save(153, 154)
												syscom.copy_save(152, 153)
												syscom.copy_save(151, 152)
												syscom.copy_save(150, 151)
											}
										}
										else	{
											syscom.copy_save(157, 158)
											syscom.copy_save(156, 157)
											syscom.copy_save(155, 156)
											syscom.copy_save(154, 155)
											syscom.copy_save(153, 154)
											syscom.copy_save(152, 153)
											syscom.copy_save(151, 152)
											syscom.copy_save(150, 151)
										}
									}
									else	{
										syscom.copy_save(156, 157)
										syscom.copy_save(155, 156)
										syscom.copy_save(154, 155)
										syscom.copy_save(153, 154)
										syscom.copy_save(152, 153)
										syscom.copy_save(151, 152)
										syscom.copy_save(150, 151)
									}
								}
								else	{
									syscom.copy_save(155, 156)
									syscom.copy_save(154, 155)
									syscom.copy_save(153, 154)
									syscom.copy_save(152, 153)
									syscom.copy_save(151, 152)
									syscom.copy_save(150, 151)
								}
							}
							else	{
								syscom.copy_save(154, 155)
								syscom.copy_save(153, 154)
								syscom.copy_save(152, 153)
								syscom.copy_save(151, 152)
								syscom.copy_save(150, 151)
							}
						}
						else	{
							syscom.copy_save(153, 154)
							syscom.copy_save(152, 153)
							syscom.copy_save(151, 152)
							syscom.copy_save(150, 151)
						}
					}
					else	{
						syscom.copy_save(152, 153)
						syscom.copy_save(151, 152)
						syscom.copy_save(150, 151)
					}
				}
				else	{
					syscom.copy_save(151, 152)
					syscom.copy_save(150, 151)
				}
			}
			else	{
				syscom.copy_save(150, 151)
			}
		}
		syscom.save(150, @Off, @Off)
//		$auto_save_disp		todo 製品版では雰囲気壊さないように表示する
		@timewait(250)
	}
}



// クイックセーブしました
command $quick_save_disp
{
	frame
	@f.mwnd[$get_mwnd_no].@obj[5].patno = 0
	@f.mwnd[$get_mwnd_no].@obj[5].frame_action.start(4000, "$qs_action1")

}

// オートセーブしました
command $auto_save_disp
{

	// todo メッセージウィンドウ消去中なので、メッセージウィンドウオブジェクトは不可
	frame
	@f.obj[@OBJ_BG05].create(sys_mw_info00, @On, 1050, 481)
	@f.obj[@OBJ_BG05].patno = 1
	@f.obj[@OBJ_BG05].order = 1
	@f.obj[@OBJ_BG05].wipe_copy = @On
	@f.obj[@OBJ_BG05].frame_action.start(4000, "$qs_action2")
}


command $qs_action1(property $fa : frameaction, property $obj : object)
{
	L[0] = $fa.counter.get
	$obj.x  = math.timetable(L[0], 0, 1150, [0, 500, 1100, 2], [2000, 3000, 1050, 2])
	$obj.tr = math.timetable(L[0], 0,    0, [0, 500,  255, 2], [2000, 3000,    0, 2])

}

command $qs_action2(property $fa : frameaction, property $obj : object)
{
	L[0] = $fa.counter.get
	$obj.x  = math.timetable(L[0], 0, 1150, [0, 300, 1100, 2], [800, 1100, 1050, 2])
	$obj.tr = math.timetable(L[0], 0,    0, [0, 300,  255, 2], [800, 1100,    0, 2])
}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■日付切り替えセーブ
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_day_save
{

	// 通常セーブ	：   0 -  999
	// 日付セーブ	：1000 - 1009

	// セーブデータ１０００番に上書きするので、履歴に反映させる
	for ($sys_forlc0 = 0, $sys_forlc0 < 9, $sys_forlc0 += 1)	{
		@SysSLDataExist[+$sys_forlc0] = syscom.get_save_exist(1000+$sys_forlc0)
	}

	// 0あり
	if (@SysSLDataExist[+0] == @On)	{
		if (@SysSLDataExist[+1] == @On)	{
			// 1あり
			if (@SysSLDataExist[+2] == @On)	{
				// 2あり
				if (@SysSLDataExist[+3] == @On)	{
					// 3あり
					if (@SysSLDataExist[+4] == @On)	{
						// 4あり
						if (@SysSLDataExist[+5] == @On)	{
							// 5あり
							if (@SysSLDataExist[+6] == @On)	{
								// 6あり
								if (@SysSLDataExist[+7] == @On)	{
									// 7あり
									if (@SysSLDataExist[+8] == @On)	{
										// 8あり
										if (@SysSLDataExist[+9] == @On)	{
											// 9あり
											// delete 9
											syscom.copy_save(1008, 1009)
											syscom.copy_save(1007, 1008)
											syscom.copy_save(1006, 1007)
											syscom.copy_save(1005, 1006)
											syscom.copy_save(1004, 1005)
											syscom.copy_save(1003, 1004)
											syscom.copy_save(1002, 1003)
											syscom.copy_save(1001, 1002)
											syscom.copy_save(1000, 1001)
										}
										else	{
											syscom.copy_save(1008, 1009)
											syscom.copy_save(1007, 1008)
											syscom.copy_save(1006, 1007)
											syscom.copy_save(1005, 1006)
											syscom.copy_save(1004, 1005)
											syscom.copy_save(1003, 1004)
											syscom.copy_save(1002, 1003)
											syscom.copy_save(1001, 1002)
											syscom.copy_save(1000, 1001)
										}
									}
									else	{
										syscom.copy_save(1007, 1008)
										syscom.copy_save(1006, 1007)
										syscom.copy_save(1005, 1006)
										syscom.copy_save(1004, 1005)
										syscom.copy_save(1003, 1004)
										syscom.copy_save(1002, 1003)
										syscom.copy_save(1001, 1002)
										syscom.copy_save(1000, 1001)
									}
								}
								else	{
									syscom.copy_save(1006, 1007)
									syscom.copy_save(1005, 1006)
									syscom.copy_save(1004, 1005)
									syscom.copy_save(1003, 1004)
									syscom.copy_save(1002, 1003)
									syscom.copy_save(1001, 1002)
									syscom.copy_save(1000, 1001)
								}
							}
							else	{
								syscom.copy_save(1005, 1006)
								syscom.copy_save(1004, 1005)
								syscom.copy_save(1003, 1004)
								syscom.copy_save(1002, 1003)
								syscom.copy_save(1001, 1002)
								syscom.copy_save(1000, 1001)
							}
						}
						else	{
							syscom.copy_save(1004, 1005)
							syscom.copy_save(1003, 1004)
							syscom.copy_save(1002, 1003)
							syscom.copy_save(1001, 1002)
							syscom.copy_save(1000, 1001)
						}
					}
					else	{
						syscom.copy_save(1003, 1004)
						syscom.copy_save(1002, 1003)
						syscom.copy_save(1001, 1002)
						syscom.copy_save(1000, 1001)
					}
				}
				else	{
					syscom.copy_save(1002, 1003)
					syscom.copy_save(1001, 1002)
					syscom.copy_save(1000, 1001)
				}
			}
			else	{
				syscom.copy_save(1001, 1002)
				syscom.copy_save(1000, 1001)
			}
		}
		else	{
			syscom.copy_save(1000, 1001)
		}
	}
	syscom.save(1000, @Off, @Off)
	frame
//	$auto_save_disp
	@timewait(250)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■オートモード [ＯＦＦ]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_auto_btn0
{
	@MouseBtnInit
	@AutoStartReady = @On
	syscom.set_auto_mode_onoff_flag(@On)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■オートモード [Ｏｎ]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_auto_btn1
{
	@MouseBtnInit
	@AutoStartReady = @Off
	syscom.set_auto_mode_onoff_flag(@Off)
}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■スキップ [ＯＦＦ]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_skip_btn0
{
	@MouseBtnInit
//	@SkipStartReady = @On
	syscom.set_read_skip_onoff_flag(@On)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■スキップ [Ｏｎ]
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_skip_btn1
{
	@MouseBtnInit
//	@SkipStartReady = @Off
	syscom.set_read_skip_onoff_flag(@Off)
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■タイトルメニューに戻る
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_returnmenu_btn
{

	if (@CdState[+5] == @On) {

		// 一時的に「キーで早送りを止める機能」を無効にする
		script.set_stop_skip_by_key_disable

		// タイトルメニューに戻る決定音
		if (@シーン回想中 == @Off)	{
			@se_play(001)
		}
		else	{
			@se_play(001)
		}

		$sys_conf = @On

		@CdStateReady = @Off

		@f.obj[@ObjSysTMenu00].init
		@f.obj[@ObjSysTMenu00].order = 2
		@f.obj[@ObjSysTMenu00].layer = 1000
		@f.obj[@ObjSysTMenu00].disp = @On
		@f.obj[@ObjSysTMenu00].@cd.resize(5)

		// 確認ダイアログ
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].create(sys_sa_chk00,      @On, 1095, 343)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].create(bg_kuro,        @On,    0,   0)

		@f.obj[@ObjSysTMenu00].tr = 0
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].tr = 150
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].layer = -1

		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 確認ダイアログ表示
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].patno = 3
		@f.obj[@ObjSysTMenu00].tr_eve.set(255, L[20], 0, 2)

		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{

			@MSCHK_PREV = @MSCHK
			@MSCHK = @MSBTN_NONE
			@MS_STATE_CONF_PREV = @MS_STATE_CONF

			// 初期化処理（キーが放されていたら状態を初期化する）
			if (input.decide.is_up == @On)	{
				@MS_STATE_CONF = @MSBTN_INIT
				@S_CTL_BAR_ACTIVE      = @Off
				@S_CTL_BAR_CTLACTIVE   = @Off
				@S_CTL_BAR_CTLPOS_PREV = @Init
			}

			//
			// マウスカーソル判定
			//

			@if_(@Off, @Off, 0, @ObjSysTMenu00, _ObjSysQDataBtn01)
			@if_(@Off, @Off, 1, @ObjSysTMenu00, _ObjSysQDataBtn02)
			@if_(@Off, @Off, 2, @ObjSysTMenu00, _ObjSysQDataChk00)

			// マウスボタン入力判定
			if (input.decide.is_up == @On)	{
				if (@MSCHK != @MSBTN_NONE){
					if (@MSCHK != @MSCHK_PREV)	{
						@se_play(000)
					}
					@MSBTN_STATE = @MSBTN_TOUCH
				}
				else	{
					@MSBTN_STATE = @MSBTN_NORMAL
				}
			}
			elseif (input.decide.is_down == @On)	{
				if (@MS_STATE_CONF != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE_CONF) && (@MSCHK != @MSBTN_NONE))	{
						if (@MSCHK != @MSCHK_PREV)	{
							@se_play(000)
						}
						@MSBTN_STATE = @MSBTN_PUSH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				else	{
					@MSBTN_STATE = @MSBTN_PUSH
					@MS_STATE_CONF = @MSCHK
				}
			}
			if (input.cancel.on_down_up == @On)	{
//				input.clear
				L[0] = @Off
				$break_switch = @On
				break
			}
			elseif (input.decide.on_down_up == @On)	{
				if (@MS_STATE_CONF_PREV != @MSBTN_INIT){
					if ((@MSCHK == @MS_STATE_CONF_PREV) && (@MSCHK != @MSBTN_NONE))	{
						@MSBTN_STATE = @MSBTN_TOUCH
						@MSBTN_RESULT = @DECIDE
					}
					else{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
					@MS_STATE_CONF = @MSBTN_INIT
				}
//				input.clear
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].patno = $obj_btn_state[0]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].patno = $obj_btn_state[1]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {
				@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2] + @Operate
			}

			// 状態表示
//			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				switch (@MSCHK)	{
					case (0)
						// Yes
						L[0] = @On
						break
					case (1)
						// No
						@se_play(002)
						L[0] = @Off
						$break_switch = @On
						break
					case (2)
						// QuickSaveChk
		     			@se_play(001)
		     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
						elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
		}
	}

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0

	}

	if (@CdStateReady == @On ) {@CdState[+5] = @Off}

	if ($break_switch == @Off)	{

		// タイトルメニューに戻る
		if ((L[0] == @On) || (@CdState[+5] == @Off ))	{
			@se_play(003)
			@bgm_stop(2000)
			// 確認ダイアログ消去
			@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)
			@PCM_STOP @PCMCH_STOP_ALL
			// ショートカットのフレームアクションを停止
			frame_action_ch[0].end
			@f.obj[@ObjSysMenu00].create(bg_kuro, @On, 0, 0)
			@f.obj[@ObjSysMenu00].order = 2
			@f.obj[@ObjSysMenu00].tr = 0
			@f.obj[@ObjSysMenu00].layer = 1000000
			@f.obj[@ObjSysMenu00].tr_eve.set(255, L[21], 0, 0)
			@f.obj[@ObjSysMenu00].tr_eve.wait_key
//			@se_wait_key
			@TM_CONF = @On
			syscom.return_to_menu(@Off, @Off, @Off)
		}
	}

	// 確認ダイアログ消去
	@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)

	$sys_conf = @Off

	$break_switch = @Off

	// 一時的に「キーで早送りを止める機能」を無効を解除する
	script.set_stop_skip_by_key_enable
}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■ゲームを終了する
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $sys_gameend_btn
{

	// エンドセーブ用画面キャプチャー
	capture

	if (@CdState[+7] == @On) {

		// 一時的に「キーで早送りを止める機能」を無効にする
		script.set_stop_skip_by_key_disable

		// 決定音
		@se_play(001)

		$sys_conf = @On

		@CdStateReady = @Off

		@f.obj[@ObjSysTMenu00].init
		@f.obj[@ObjSysTMenu00].order = 2
		@f.obj[@ObjSysTMenu00].layer = 1000
		@f.obj[@ObjSysTMenu00].disp = @On
		@f.obj[@ObjSysTMenu00].@cd.resize(5)

		// 確認ダイアログ
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].create(sys_mw_setbtn_bg00, @On,    0, 295)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].create(sys_sa_setbtn01,   @On,  659, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].create(sys_sa_setbtn02,   @On,  854, 310)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].create(sys_sa_chk00,      @On, 1095, 343)
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].create(bg_kuro,        @On,    0,   0)

		@f.obj[@ObjSysTMenu00].tr = 0
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].tr = 150
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].layer = -1


		// メニュー表示速度
		switch (@MeFadeState)	{
			case (@Def ) L[20] = 250
			case (@Fast) L[20] = 250/2
			case (@Inst) L[20] = 0
		}

		// 確認ダイアログ表示
		@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].patno = 4
		@f.obj[@ObjSysTMenu00].tr_eve.set(255, L[20], 0, 2)

		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{

			@MSCHK_PREV = @MSCHK
			@MSCHK = @MSBTN_NONE
			@MS_STATE_CONF_PREV = @MS_STATE_CONF

			// 初期化処理（キーが放されていたら状態を初期化する）
			if (input.decide.is_up == @On)	{
				@MS_STATE_CONF = @MSBTN_INIT
				@S_CTL_BAR_ACTIVE      = @Off
				@S_CTL_BAR_CTLACTIVE   = @Off
				@S_CTL_BAR_CTLPOS_PREV = @Init
			}

			//
			// マウスカーソル判定
			//

			@if_(@Off, @Off, 0, @ObjSysTMenu00, _ObjSysQDataBtn01)
			@if_(@Off, @Off, 1, @ObjSysTMenu00, _ObjSysQDataBtn02)
			@if_(@Off, @Off, 2, @ObjSysTMenu00, _ObjSysQDataChk00)

			// マウスボタン入力判定
			if (input.decide.is_up == @On)	{
				if (@MSCHK != @MSBTN_NONE){
					if (@MSCHK != @MSCHK_PREV)	{
						@se_play(000)
					}
					@MSBTN_STATE = @MSBTN_TOUCH
				}
				else	{
					@MSBTN_STATE = @MSBTN_NORMAL
				}
			}
			elseif (input.decide.is_down == @On)	{
				if (@MS_STATE_CONF != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE_CONF) && (@MSCHK != @MSBTN_NONE))	{
						if (@MSCHK != @MSCHK_PREV)	{
							@se_play(000)
						}
						@MSBTN_STATE = @MSBTN_PUSH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				else	{
					@MSBTN_STATE = @MSBTN_PUSH
					@MS_STATE_CONF = @MSCHK
				}
			}
			if (input.cancel.on_down_up == @On)	{
//				input.clear
				L[0] = @Off
				$break_switch = @On
				break
			}
			elseif (input.decide.on_down_up == @On)	{
				if (@MS_STATE_CONF_PREV != @MSBTN_INIT){
					if ((@MSCHK == @MS_STATE_CONF_PREV) && (@MSCHK != @MSBTN_NONE))	{
						@MSBTN_STATE = @MSBTN_TOUCH
						@MSBTN_RESULT = @DECIDE
					}
					else{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
					@MS_STATE_CONF = @MSBTN_INIT
				}
//				input.clear
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].patno = $obj_btn_state[0]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].patno = $obj_btn_state[1]
			@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {
				@f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2] + @Operate
			}

			// 状態表示
//			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				switch (@MSCHK)	{
					case (0)
						// Yes
						L[0] = @On
						break
					case (1)
						// No
						@se_play(002)
						L[0] = @Off
						$break_switch = @On
						break
					case (2)
						// QuickSaveChk
		     			@se_play(001)
		     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
						elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
		}
	}

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0
	}

	if (@CdStateReady == @On ) {@CdState[+7] = @Off}

	if ($break_switch == @Off)	{
		// ゲームを終了する
		if ((L[0] == @On) || (@CdState[+7] == @Off ))	{
			// 揺れコマンドを停止
			@QUAKE_END_ALL(500)
			// ＯＫ決定音
			@se_play(003)
			// 確認ダイアログ消去
			@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)
			@PCM_STOP @PCMCH_STOP_ALL
			@bgm_stop(2000)
			@f.obj[@ObjSysMenu00].create(bg_kuro, @On, 0, 0)
			@f.obj[@ObjSysMenu00].order = 2
			@f.obj[@ObjSysMenu00].tr = 0
			@f.obj[@ObjSysMenu00].layer = 1000000
			@f.obj[@ObjSysMenu00].tr_eve.set(255, L[21], 0, 0)
			@f.obj[@ObjSysMenu00].tr_eve.wait_key
			se.stop(1000)
			syscom.end_game(@Off)
		}
	}

	// 確認ダイアログ消去
	@f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)

	$sys_conf = @Off

	$break_switch = @Off

	// 一時的に「キーで早送りを止める機能」を無効を解除する
	script.set_stop_skip_by_key_enable

}



//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■タイトルメニューの右クリック動作
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
/*
command $setting_disp
{

	@MSBTN_RESULT = @DECIDE
	@MSCHK = 9

}
*/


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■ロードコール（メッセージバック）
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command $msgbk_btn_load
{
	// システムコールを準備します。
	excall.alloc

	@ex.f.obj[@ObjSysTMenu00].init
	@ex.f.obj[@ObjSysTMenu00].order = 2
	@ex.f.obj[@ObjSysTMenu00].layer = 1000
	@ex.f.obj[@ObjSysTMenu00].disp = @On
	@ex.f.obj[@ObjSysTMenu00].@cd.resize(6)

	// メニュー表示速度
	switch (@MeFadeState)	{
		case (@Def ) L[20] = 250   L[21] = 1000
		case (@Fast) L[20] = 250/2 L[21] = 1000/2
		case (@Inst) L[20] = 0     L[21] = 0
	}

	if (@CdState[+3] == @On) {

		// 一時的に「キーで早送りを止める機能」を無効にする
		script.set_stop_skip_by_key_disable

		// ロードコール決定音
		@se_play(001)

		$sys_conf = @On

		@CdStateReady = @Off

		// 確認ダイアログ
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBg00].create(sys_bk_setbtn_bg00, @On,    0, 295)
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].create(sys_bk_setbtn01,   @On,  659, 310)
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].create(sys_bk_setbtn02,   @On,  854, 310)
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].create(sys_bk_chk00,      @On, 1095, 343)
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].create(bg_kuro,        @On,    0,   0)

		@ex.f.obj[@ObjSysTMenu00].tr = 0
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].tr = 150
		@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataFilter00].layer = -1

		// 確認ダイアログ表示
		@ex.f.obj[@ObjSysTMenu00].tr_eve.set(255, L[20], 0, 2)


		// マウス初期化
		//@MouseBtnInit(@MsCheck,@MsCheckPreview,@MsState,@MsStatePreview,@MsBtnState,@MenuSel)
		@MouseBtnInit
		while (1)	{

			@MSCHK_PREV = @MSCHK
			@MSCHK = @MSBTN_NONE
			@MS_STATE_CONF_PREV = @MS_STATE_CONF

			// 初期化処理（キーが放されていたら状態を初期化する）
			if (input.decide.is_up == @On)	{
				@MS_STATE_CONF = @MSBTN_INIT
				@S_CTL_BAR_ACTIVE      = @Off
				@S_CTL_BAR_CTLACTIVE   = @Off
				@S_CTL_BAR_CTLPOS_PREV = @Init
			}

			//
			// マウスカーソル判定
			//

			@exif_(@Off, @Off, 0, @ObjSysTMenu00, _ObjSysQDataBtn01)
			@exif_(@Off, @Off, 1, @ObjSysTMenu00, _ObjSysQDataBtn02)
			@exif_(@Off, @Off, 2, @ObjSysTMenu00, _ObjSysQDataChk00)

			// マウスボタン入力判定
			if (input.decide.is_up == @On)	{
				if (@MSCHK != @MSBTN_NONE){
					if (@MSCHK != @MSCHK_PREV)	{
						@se_play(000)
					}
					@MSBTN_STATE = @MSBTN_TOUCH
				}
				else	{
					@MSBTN_STATE = @MSBTN_NORMAL
				}
			}
			elseif (input.decide.is_down == @On)	{
				if (@MS_STATE_CONF != @MSBTN_INIT)	{
					if ((@MSCHK == @MS_STATE_CONF) && (@MSCHK != @MSBTN_NONE))	{
						if (@MSCHK != @MSCHK_PREV)	{
							@se_play(000)
						}
						@MSBTN_STATE = @MSBTN_PUSH
					}
					else	{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
				}
				else	{
					@MSBTN_STATE = @MSBTN_PUSH
					@MS_STATE_CONF = @MSCHK
				}
			}
			if (input.cancel.on_down_up == @On)	{
//				input.clear
				L[0] = @Off
				$break_switch = @On
				break
			}
			elseif (input.decide.on_down_up == @On)	{
				if (@MS_STATE_CONF_PREV != @MSBTN_INIT){
					if ((@MSCHK == @MS_STATE_CONF_PREV) && (@MSCHK != @MSBTN_NONE))	{
						@MSBTN_STATE = @MSBTN_TOUCH
						@MSBTN_RESULT = @DECIDE
					}
					else{
						@MSBTN_STATE = @MSBTN_NORMAL
					}
					@MS_STATE_CONF = @MSBTN_INIT
				}
//				input.clear
			}

			//
			// 状態セット
			//

			@MsStateSet(0,2)

			@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn01].patno = $obj_btn_state[0]
			@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataBtn02].patno = $obj_btn_state[1]
			@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2]
			if (@CdStateReady == @On) {
				@ex.f.obj[@ObjSysTMenu00].@cd[_ObjSysQDataChk00].patno = $obj_btn_state[2] + @Operate
			}

			// 状態表示
//			input.next
			disp

			// 結果
			if (@MSBTN_RESULT == @DECIDE)	{
				@MSBTN_RESULT = @INIT
				switch (@MSCHK)	{
					case (0)
						// Yes
						L[0] = @On
						break
					case (1)
						// No
						@se_play(002)
						$break_switch = @On
						L[0] = @Off
						break
					case (2)
						// QuickSaveChk
		     			@se_play(001)
		     			    if (@CdStateReady == @Off) {@CdStateReady = @On}
						elseif (@CdStateReady == @On ) {@CdStateReady = @Off}
				}
			}
		}
	}

	if (@CdStateReady == @On ) {@CdState[+3] = @Off}

	if ($break_switch == @Off)	{

		// 選択した履歴に戻る
		if ((L[0] == @On) || (@CdState[+3] == @Off ))	{
			// 揺れコマンドを停止
			@QUAKE_END_ALL(500)
			// ロードコール決定音
			@se_play(003)
			@PCM_STOP @PCMCH_STOP_ALL
			@bgm_stop(2000)
			// 確認ダイアログ消去
			@ex.f.obj[@ObjSysTMenu00].@cd[5].tr_eve.set(0, L[20], 0, 2)
			@ex.f.obj[@ObjSysTMenu00].@cd[5].create(bg_kuro, @On)
			@ex.f.obj[@ObjSysTMenu00].@cd[5].tr = 0
			@ex.f.obj[@ObjSysTMenu00].@cd[5].layer = 100000
			@ex.f.obj[@ObjSysTMenu00].@cd[5].tr_eve.set(255, L[21], 0, 2)
			@ex.f.obj[@ObjSysTMenu00].@cd[5].tr_eve.wait_key
			se.stop(1000)
			syscom.msg_back_load(0, 0, 0)
		}
	}

	// 確認ダイアログ消去
	@ex.f.obj[@ObjSysTMenu00].tr_eve.set(0, L[20], 0, 2)
	@ex.f.obj[@ObjSysTMenu00].tr_eve.wait_key

	$sys_conf = @Off

	// 一時的に「キーで早送りを止める機能」を無効を解除する
	script.set_stop_skip_by_key_enable

	$break_switch = @Off

	// システムコールを解放します。
	excall.free

}




//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// ■システムボタンロック
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
command	$msg_btn_lock
{

	if (@システムボタンロック == @Off)	{
		@システムボタンロック = @On
	}
	elseif (@システムボタンロック == @On)	{
		@システムボタンロック = @Off
	}
	syscom.set_global_extra_switch_onoff(2, @システムボタンロック)
}