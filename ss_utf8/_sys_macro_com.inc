// ---------------------------------------------------------------
// 基本コマンド
// ---------------------------------------------------------------
#macro	@TIMEWAIT(@TIME)
		timewait(@TIME)

#macro	@TIMEWAITKEY(@TIME, @EMO_WAIT(0))
		if (@EMO_WAIT == 0)	{
			timewait_key(@TIME)
		}
		else	{
			if (@EmDispState == @On)	{
				timewait_key(@TIME)
			}
		}



#macro	@SET_TITLE(@TITLE)
		set_title(@TITLE)


// ---------------------------------------------------------------
// 一時的に特定コマンドの機能を使用不可にする
// ---------------------------------------------------------------
#macro		@sys_com_disable(@mwnd(1), @back(1), @menu(1), @sc(1), @mouse(1), @ctrl(1), @mbtn(1))
			// 「ウィンドウを消す」の設定を不可に
			if (@mwnd == @On)	{
				syscom.set_hide_mwnd_enable_flag(0)
			}
			// 一時的にメッセージバックに入るのを禁止する
			if (@back == @On)	{
				script.set_msg_back_disable
			}
			// システムコマンドメニューを禁止
			if (@menu == @On)	{
				syscom.set_syscom_menu_disable
			}
			// ショートカット機能を禁止
			if (@sc == @On)	{
				script.set_shortcut_disable
			}
			// 一時的にマウスカーソルを非表示にする
			if (@mouse == @On)	{
				script.set_mouse_disp_off
			}
			// 一時的に早送りを禁止する（Ctrl キーを含む）
			if (@ctrl == @On)	{
				script.set_ctrl_skip_disable
			}
			// メッセージウィンドウのボタンを触れなくする
			if (@mbtn == @On)	{
				syscom.set_mwnd_btn_touch_disable
			}

			// 一時的に「クリックすると文章を最後まで表示する」機能を無効にする
			script.set_end_msg_by_key_disable

// ---------------------------------------------------------------
// 一時的に使用不可にしたコマンド機能の禁止を解除
// ---------------------------------------------------------------
#define		@sys_com_enable
			// 「ウィンドウを消す」の設定を可に
			syscom.set_hide_mwnd_enable_flag(1)
			// 一時的にメッセージバック禁止を解除
			script.set_msg_back_enable
			// システムコマンドメニュー禁止を解除
			syscom.set_syscom_menu_enable
			// ショートカット機能禁止を解除
			script.set_shortcut_enable
			// 一時的にマウスカーソル非表示を解除
			script.set_mouse_disp_on
			// 一時的に早送り禁止を解除（Ctrl キーを含む）
			script.set_ctrl_skip_enable
			// メッセージウィンドウのボタンの触れなくするを解除する
			syscom.set_mwnd_btn_touch_enable

			// 一時的に「クリックすると文章を最後まで表示する」機能を有効にする
			script.set_end_msg_by_key_enable

// ---------------------------------------------------------------
// 一時的に特定コマンドの機能を使用不可にする（ムービー演出中）
// ---------------------------------------------------------------
#define		@omv_com_disable
			// 一時的にメッセージバックに入るのを禁止する
			script.set_msg_back_disable
			// システムコマンドメニューを禁止
			syscom.set_syscom_menu_disable
			// ショートカット機能を禁止
			script.set_shortcut_disable


// ---------------------------------------------------------------
// 一時的に使用不可にしたコマンド機能の禁止を解除（ムービー演出中）
// ---------------------------------------------------------------
#define		@omv_com_enable
			// 一時的にメッセージバック禁止を解除
			script.set_msg_back_enable
			// システムコマンドメニュー禁止を解除
			syscom.set_syscom_menu_enable
			// ショートカット機能禁止を解除
			script.set_shortcut_enable


