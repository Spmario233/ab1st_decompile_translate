// #SCENE_SCRIPT_ID = 9902 （スクリプトＩＤ：この行は削除したり、変更したりしないで下さい）
#Z00

// 最新のセーブデータの番号を取得する（必須）
syscom.get_save_new_no

// オートモードをオフにする（オートモード中にゲーム終了してもオフにされないので）
syscom.set_auto_mode_onoff_flag(@Off)

// スクリプト初期化
@SetGameScriptData(@AngelBeats!)

// 回想用フラグ初期化
@シーン回想中 = @Off
@シーン回想中_GalleryPage = -1
@BgmPlayNoGF = -1

// ムービー中判定フラグＯＦＦ
$omv_play = @Off

// おまけモード中にゲーム終了したか判定
if(@IS_EXIT_GAME_IN_EXTRA == 1) {
	// 終了していた場合はボリュームを元に戻す
	syscom.set_bgm_volume(@BEFORE_BGM_VOLUME_OF_EXTRA)
	syscom.set_bgm_onoff(@BEFORE_BGM_ONOFF_OF_EXTRA)
}

@音無_呼び方 = @音無と呼ぶ
@日向_呼び方 = @日向と呼ぶ
@ゆり_呼び方 = @ゆりと呼ぶ
@天使_呼び方 = @天使と呼ぶ
@野田_呼び方 = @男と呼ぶ


//-----------------------------------------------------------------
// ダミー認証
//-----------------------------------------------------------------
@sys_com_disable
system.check_dummy_file_once("dummy", 124, "hidechin_kyuff")
//@sys_com_enable		//下に動かした。


//-----------------------------------------------------------------
// 警告文の表示
//-----------------------------------------------------------------
if (@1stboot == @On)	{
	@b.obj[@OBJ_BGXX].create(sys_tm_war00, @On)
	wipe(0, 2000)
	@timewaitkey(8000)
	wipe(0, 2000)
}

@sys_com_enable


jump(＿ゲームメイン)



