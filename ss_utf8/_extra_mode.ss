// ====================================================================
// おまけモード
// ====================================================================


#inc_start
	
	
	// ================================
	// 共通
	// ================================
	#property	$main_loop : int
	
	#property	$current_mode : int		// デフォルトCGモード
	
	// モードの種類
	#define		@MODE_CG					0
	#define		@MODE_MS					1
	#define		@MODE_AC					2
	
	#property	$current_state : int	// 状態制御用（CG表示中に右クリックでタイトルに戻ったらまずいとかの制御）
	
	// ステートの種類
	#define		@STATE_DEFAULT				0
	#define		@STATE_FULL_CG				1
	
	
	
	// オブジェクトインデックス系
	#define		@OBJ_TAB_BUTTONS			291						// タブ系のボタン
	#define		@OBJ_TITLE_BUTTON			@OBJ_TAB_BUTTONS+1		// タイトルへ戻るボタン
	#define		@OBJ_TOP_BG					@OBJ_TAB_BUTTONS+2		// 最上位背景
	#define		@OBJ_MODE_EXPLAIN			@OBJ_TAB_BUTTONS+3		// モード説明
	#define		@OBJ_MODE_RATE				@OBJ_TAB_BUTTONS+4		// モード達成率
	#define		@OBJ_MUSIC_PLAYER_ROOT		@OBJ_TAB_BUTTONS+5		// 音楽プレーヤのルート
	#define		@OBJ_CGM_ROOT				@OBJ_TAB_BUTTONS+6		// CGモードのルート
	#define		@OBJ_MSM_ROOT				@OBJ_TAB_BUTTONS+7		// 音楽モードのルート
	#define		@OBJ_ACM_ROOT				@OBJ_TAB_BUTTONS+8		// 実績モードのルート
	#define		@OBJ_FOR_FADE				@OBJ_TAB_BUTTONS+9		// フェード用
	#define		@OBJ_FOR_FULL_CG			@OBJ_TAB_BUTTONS+10		// フルサイズCG用
	#define		@OBJ_FOR_FULL_CG_SUPPORT	@OBJ_TAB_BUTTONS+11		// フルサイズCG補助用
	// 子供のオブジェクトインデックス系
	#define		@OBJC_CGB					0		// CGボタン
	#define		@OBJC_MSB					1		// 音楽ボタン
	#define		@OBJC_ACB					2		// 実績ボタン
	
	#define		@OBJC_MTR					0		// 曲タイトルルート
	#define		@OBJC_MMR					1		// 曲複数チェックボタンルート
	
	#define		@OBJC_ALR					0		// 実績一覧ルート
	#define		@OBJC_ASR					1		// 実績スライダルート
	
	#define		@OBJC_PIR					0		// 音楽プレーヤ曲情報ルート
	#define		@OBJC_PBR					1		// 音楽プレーヤボタンルート
	#define		@OBJC_PVR					2		// 音楽プレーヤボリュームスライダルート
	
	#define		@OBJC_CLR					0		// CGリストルート
	#define		@OBJC_CSR					1		// CGリストスライダルート
	
	
	// ボタン系
	// ボタングループ
	#define		@OBJBTNGROUP_TAB_BUTTONS					1	// タブボタンのボタングループ
	#define		@OBJBTNGROUP_TITLE_BUTTON					2	// タイトルボタンのボタングループ
	#define		@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS			3	// 音楽プレーヤボタンのボタングループ
	#define		@OBJBTNGROUP_MUSIC_PLAYER_VOLUME			4	// 音楽プレーヤボリュームのボタングループ
	#define		@OBJBTNGROUP_MUSIC_TITLES					5	// 音楽タイトルのボタングループ
	#define		@OBJBTNGROUP_MUSIC_CHECK_BOXES				6	// 音楽チェックボックスのボタングループ
	#define		@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS		7	// 音楽複数チェックボタンのボタングループ
	#define		@OBJBTNGROUP_AC_SLIDE_BAR					0	// 実績スライドバーのボタングループ
	#define		@OBJBTNGROUP_CG_LIST						8	// CGリストのボタングループ
	#define		@OBJBTNGROUP_CG_SLIDE_BAR					9	// CGスライドバーのボタングループ
	
	// ボタンアクション
	#define		@OBJBTNACTION_DEFAULT		0							// ボタンアクション
	#define		@OBJBTNACTION_TAB_BUTTONS	@OBJBTNACTION_DEFAULT		// タブボタンのボタンアクション
	#define		@OBJBTNACTION_TITLE_BUTTON	10		// 
	#define		@OBJBTNACTION_CG_LIST		12		// 
	#define		@OBJBTNACTION_PLAYER_BUTTON		13		// 
	#define		@OBJBTNACTION_MUSIC_PLAYER_VOLUME		13		// 
	
	// ボタンSE
	#define		@OBJBTNSE_DEFAULT			4//3						// ボタンSE
	#define		@OBJBTNSE_TAB_BUTTONS		0						// タブボタンのボタンSE
	#define		@OBJBTNSE_TITLE_BUTTON		0						// タイトルのボタンSE
	
	
	// クリップ座標
	#define		@ROOT_CLIP_LEFT			0
	#define		@ROOT_CLIP_TOP			77
	#define		@ROOT_CLIP_RIGHT		1280
	#define		@ROOT_CLIP_BOTTOM		643
	
	
	
	// ================================
	// CG
	// ================================
	#define		@DB_CG						0				// 使用するデータベースのインデックス
	#property	$cgdb_name_list_all : strlist				// 登録名リスト
	#property	$cgdb_name_list_main : strlist				// 登録名リスト(一覧表示の時のルートCG)
	
	
	// DBの列系
	#define		@CGDB_COLUMN_NAME			0				// 登録名
	#define		@CGDB_COLUMN_THFN			1				// サムネファイル名
	#define		@CGDB_COLUMN_ZFID			2				// Zフラグ番号
	#define		@CGDB_COLUMN_CGNO			3				// CG番号
	#define		@CGDB_COLUMN_CGDN			4				// CG差分番号
	#define		@CGDB_COLUMN_VOL			5				// 巻数
	#define		@CGDB_COLUMN_NARG			6				// 名前付き引数
	
	// DBの名前付き引数系
	#define		@CGDB_NARG_TYPE				"type"
	#define		@CGDB_NARG_TYPE_DEFAULT		"default"
	#define		@CGDB_NARG_TYPE_BASE_FACE	"base_face"
	#define		@CGDB_NARG_TYPE_WH_OVER		"wh_over"
	#define		@CGDB_NARG_TYPE_HARMO		"harmo"
	
	#define		@CGDB_NARG_Y_MIN			"y_min"
	#define		@CGDB_NARG_Y_MAX			"y_max"
	#define		@CGDB_NARG_X_MIN			"x_min"
	#define		@CGDB_NARG_X_MAX			"x_max"
	
	#define		@CGDB_NARG_X_INIT			"x_init"
	#define		@CGDB_NARG_Y_INIT			"y_init"
	
	
	// 現在のフルCGのCGデータベース情報
	#property	$current_full_cg_cgdb_name : str
	#property	$current_full_cg_cgdb_thfn : str
	#property	$current_full_cg_cgdb_zfid
	#property	$current_full_cg_cgdb_cgno
	#property	$current_full_cg_cgdb_cgdn
	#property	$current_full_cg_cgdb_vol
	#property	$current_full_cg_cgdb_narg : str
	// CGデータベースのデータ取得コマンド用
	#property	$got_cgdb_name : str
	#property	$got_cgdb_thfn : str
	#property	$got_cgdb_zfid
	#property	$got_cgdb_cgno
	#property	$got_cgdb_cgdn
	#property	$got_cgdb_vol
	#property	$got_cgdb_narg : str
	
	
	
	#property	$cg_mouse_old_y		// 1フレーム前のマウスY座標
	#property	$cg_mouse_acc_y		// マウスの加速度
	
	#define		@CG_ROOT_Y_MIN			-2980
	#define		@CG_ROOT_Y_MAX			100
	
	#define		@THUMBNAIL_WIDTH	240		// サムネの幅
	#define		@THUMBNAIL_HEIGHT	135		// サムネの高さ
	
	#define		@CG_CLIP_Y_MIN			@ROOT_CLIP_TOP - @THUMBNAIL_HEIGHT
	#define		@CG_CLIP_Y_MAX			@ROOT_CLIP_BOTTOM
	
	
	#property	$cgm_mouse_px_on_press_thumb
	#property	$cgm_mouse_py_on_press_thumb
	#property	$cgm_thumb_btn_grp_state
	
	#define		@TACTICS_GAMEEXEINI_REG_NAME			"M109"
	#define		@THEMEOFSSS_GAMEEXEINI_REG_NAME			"M102"
	
	// ================================
	// 音楽
	// ================================
	
	// MMB ... music multi button
	#define		@MMB_ALL_ON		0	// ALLオン
	#define		@MMB_ALL_OFF	1	// ALLオフ
	#define		@MMB_GLDM_ON	2	// ガルデモオン
	#define		@MMB_MAX		3	// ボタン数
	
	// ファイル名補助
	#define		@FN_PLAYER_TITLE	"PLAYER_"
	#define		@FN_PLAYER_INFO		"PLAYER_INFO_"
	#define		@FN_PLAYLIST		"PLAYLIST_"
	
	
	// ================================
	// 実績
	// ================================
	#property	$sorted_idx_list : intlist			// 表示順にソート済みのインデックスリスト
	
	#property	$ac_mouse_old_y		// 1フレーム前のマウスY座標
	#property	$ac_mouse_acc_y		// マウスの加速度
	
	#define		@AC_ROOT_Y_MIN			-3360
	#define		@AC_ROOT_Y_MAX			100
	
	#define		@STR_FONT_SIZE		18
	#define		@STR_Y_INTERVAL		40
	
	#define		@AC_CLIP_Y_MIN			@ROOT_CLIP_TOP - @STR_Y_INTERVAL
	#define		@AC_CLIP_Y_MAX			@ROOT_CLIP_BOTTOM
	
	
	
	
	// ================================
	// 音楽プレーヤ
	// ================================
	
	// al ... music list
	#property	$ml_reg_name : strlist	// 視聴判定用のGameexe.iniの登録名
	#property	$ml_reg_name_for_play : strlist	// 再生用のGameexe.iniの登録名
	#property	$ml_title_file_name : strlist	// 曲タイトルファイル名
	#property	$ml_info_file_name : strlist	// 曲詳細ファイル名
	#property	$ml_play_time : intlist		// 再生時間（秒）
	#property	$ml_is_gldm : intlist
	#property	$ml_is_playlist : intlist
	
	#define		@ガルデモオフ	0
	#define		@ガルデモオン	1
	
	#define		@REST_SEC		2
	
	#property	$pause_samples			// 一時停止時のサンプル数
	#property	$current_samples		// 現在のサンプル数
	
	
	#property	$system_all_volume		// 設定変えるとまずいから多分弄らない
	#property	$system_bgm_volume		// これは直接弄らずに$player_bgm_volumeを弄る
	#property	$system_bgm_onoff		// これは直接弄らずに$player_bgm_volumeを弄る
	
	#property	$player_bgm_volume		// プレーヤで使うBGMボリューム
	
	#property	$current_player_state		// 現在のプレーヤの状態
	#define		@PLAYER_STATE_STOP		0
	#define		@PLAYER_STATE_PAUSE		1
	#define		@PLAYER_STATE_PLAY		2
	
	
	
	
	
	#property	$is_repeat_on				// リピートONか
	#property	$is_shuffle_on				// シャッフルONか
	#property	$play_target_ml_idx			// 再生対象のml_idx
	#property	$ml_idx_playlist:intlist	// ml_idx値が入ったプレイリスト
	#property	$current_playlist_idx		// 現在のプレイリストのインデックス
	
	#property	$reserve_direct_change_music_ml_idx	// 曲直接変更の予約フラグ（これだけml_idxの値をとるので初期値は-1
	#property	$reserve_prev_music					// 前の曲へ移動の予約フラグ（0,1
	#property	$reserve_next_music					// 次の曲へ移動の予約フラグ（0,1
	#property	$reserve_next_music_auto			// オート版次の曲へ移動の予約フラグ（0,1
	
	#define		@MPB_PREV		0
	#define		@MPB_STOP		1
	#define		@MPB_PAUSE		2
	#define		@MPB_PLAY		3
	#define		@MPB_NEXT		4
	#define		@MPB_REPEAT		5
	#define		@MPB_SHUFFLE	6
	#define		@MPB_MAX		7	// ボタンの数
	
	#define		@SAMPLES_INIT_VAL	0
	
	// ================================
	// その他
	// ================================
	#property	$split_result	: strlist
	
	
	
#inc_end


#Z00
// -------------------------------------
// メイン処理開始
$proc_extra_mode_main()
return
// メイン処理終了
// =====================================




// ========================================================================================================================
// 以下コマンド
// ========================================================================================================================


// ============================================================
// メイン系処理
// ============================================================
// メイン処理
command $proc_extra_mode_main() {
	
	// 初期化
	$initialize_extra_mode()
	
	// メインループ
	while($main_loop) {
		
		// フルCG表示中以外に右クリックされた場合は終了する（CGモード処理の下に入れるとフルCG表示から一気に終了するのでここで）
		if($current_state != @STATE_FULL_CG) {
			if(mouse.right.on_down_up == 1) {
				$exit_extra_mode()
			}
		}
		
		
		// ===========================
		// 各種モード処理
		// ===========================
		if($current_mode == @MODE_CG) {
			$proc_extra_mode_cg()
		}
		elseif($current_mode == @MODE_MS) {
			$proc_extra_mode_music()
		}
		elseif($current_mode == @MODE_AC) {
			$proc_extra_mode_achievement()
		}
		
		// ===========================
		// 全モード共通処理
		// ===========================
		$proc_extra_mode_music_player()
		
		
		
		
		input.next
		disp
	}
	
	// 後始末
	$finalize_extra_mode()
}

// メイン処理CG
command $proc_extra_mode_cg() {
	
	// デフォルト
	if($current_state == @STATE_DEFAULT) {
		$proc_extra_mode_cg_state_default()
	}
	// CG表示中
	elseif($current_state == @STATE_FULL_CG) {
		$proc_extra_mode_cg_state_full_cg()
	}
	
}


// CGモード標準挙動
command $proc_extra_mode_cg_state_default() {
	
	// 押した瞬間（サムネが押されている、前フレーム時押されていない）
	if(front.objbtngroup[@OBJBTNGROUP_CG_LIST].get_pushed_no >= 0 && $cgm_thumb_btn_grp_state == -1) {
		$cgm_mouse_px_on_press_thumb = mouse.get_pos_x
		$cgm_mouse_py_on_press_thumb = mouse.get_pos_y
		
		// 加速度リセット
		$cg_mouse_acc_y = 0
		$cg_mouse_old_y = mouse.get_pos_y
	}
	// 今のフレームのボタングループ状態を保存
	$cgm_thumb_btn_grp_state = front.objbtngroup[@OBJBTNGROUP_CG_LIST].get_pushed_no
	
	// 何か決定された場合
	if(front.objbtngroup[@OBJBTNGROUP_CG_LIST].get_decided_no >= 0) {
		
		l[0] = front.objbtngroup[@OBJBTNGROUP_CG_LIST].get_decided_no
		if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
			return
		}
		
		// 押し始めから2ピクセル以上離れていたらCGは開かない（1ピクセルがいい？）
		if(math.abs($cgm_mouse_px_on_press_thumb - mouse.get_pos_x) >= 2 || math.abs($cgm_mouse_py_on_press_thumb - mouse.get_pos_y) >= 2) {
			$restart_objbtngroup()
			$cg_mouse_acc_y = mouse.get_pos_y - $cg_mouse_old_y
			return
		}
		
		property $idx $idx = l[0]
		//@debug($cgdb_name_list_main[$idx])
		
		// CG表示モードへ
		$current_state = @STATE_FULL_CG
		
		
		// 登録名からCG番号を取得し、そのCG番号内を先頭から走査
		
		// CGデータベースの登録名からフルCG情報を取得
		$get_full_cg_data_from_cgdb_name($cgdb_name_list_main[$idx])
		
		property $disp_full_cg_name : str
		$disp_full_cg_name = ""
		property $j
		
		// 既に見ている
		if(Z[ $got_cgdb_zfid ] == 1) {
			$disp_full_cg_name = $cgdb_name_list_main[$idx]
		}
		// まだ見ていない場合
		else {
			
			// 差分CGで見た物があるかチェックする
			l[0] = $got_cgdb_cgno
			
			// 全登録CGから同じCG番号の物を探す
			for($j = 0, $j < $cgdb_name_list_all.get_size, $j += 1) {
				// 同じCG番号の場合
				if(l[0] == $get_db_num($j, @CGDB_COLUMN_CGNO)) {
					// 既に見ている場合
					if(Z[ $get_db_num($j, @CGDB_COLUMN_ZFID) ] == 1) {
						$disp_full_cg_name = $cgdb_name_list_all[$j]
						break
					}
				}
			}
		}
		
		
		
		//$create_full_cg($cgdb_name_list_main[$idx])
		// フルCGモード
		$create_full_cg($disp_full_cg_name)
		
		// 予約型の方がいい？別に入り方が複数あるわけではないのでいらんかも
		$end_objbtngroup()
	}
	
	
	
	
	// スライドバーが押されている場合
	if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].get_button_real_state == 2 || front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].get_button_real_state == 2) { // 
	//if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].get_button_real_state == 2) {
		// スライドバーの座標をマウスに追従させる
		//front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].y = mouse.get_pos_y
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].y = mouse.get_pos_y - front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].get_size_y / 2
		// スライドバー座標からルート座標の算出
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y = math.linear(
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].y
			, 89
			, @CG_ROOT_Y_MAX
			, 583
			, @CG_ROOT_Y_MIN
		)
		// 加速度はリセットする
		$cg_mouse_acc_y = 0
	}
	elseif($is_press_music_player_button() == 1) {
	}
	// スライドバーが押されていない場合
	else{
		// 押されたとき
		if(mouse.left.on_down == 1) {
			$cg_mouse_acc_y = 0
			$cg_mouse_old_y = mouse.get_pos_y
		}
		// 押されているとき
		if(mouse.left.is_down == 1) {
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y += mouse.get_pos_y - $cg_mouse_old_y
		}
		// 押されて離された時
		if(mouse.left.on_down_up == 1) {
			$cg_mouse_acc_y = mouse.get_pos_y - $cg_mouse_old_y
		}
		
		// マウスホイール下方向
		if (mouse.wheel > 0)  {
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y += -165
			$cg_mouse_acc_y = 0
		}
		// マウスホイール上方向
		if (mouse.wheel < 0)  {
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y += 165
			$cg_mouse_acc_y = 0
		}
		
		// 加速度の移動処理
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y += $cg_mouse_acc_y
		
		// 加速度制限
		if($cg_mouse_acc_y > 40) {
			$cg_mouse_acc_y = 40
		}
		if($cg_mouse_acc_y < -40) {
			$cg_mouse_acc_y = -40
		}
	}
	
	// ルートの座標制限
	if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y > @CG_ROOT_Y_MAX) {
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y = @CG_ROOT_Y_MAX
	}
	if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y < @CG_ROOT_Y_MIN) {
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y = @CG_ROOT_Y_MIN
	}
	
	// スライダの座標算出
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].y = math.linear(
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y
		, @CG_ROOT_Y_MAX
		, 89
		, @CG_ROOT_Y_MIN
		, 583
	)
	
	
	// 補正済みの座標から絶対座標を算出
	for(l[0] = 0, l[0] < front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child.get_size, l[0]+=1) {
		// 絶対座標を算出
		l[1] = front.object[@OBJ_CGM_ROOT].y + front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].y + front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[l[0]].y
		// 表示矩形範囲外の場合はdisp=0にする
		if(l[1] < @CG_CLIP_Y_MIN || l[1] > @CG_CLIP_Y_MAX) {
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[ l[0] ].disp = 0
		}
		else {
			// ロード待ちのサムネ画像だった場合は読み込む
			if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[ l[0] ].get_file_name == "thumb_loading") {
				$create_thumbnail_object( l[0] )
			}
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[ l[0] ].disp = 1
		}
	}
	
	$cg_mouse_old_y = mouse.get_pos_y
}

// フルCG表示中の処理
command $proc_extra_mode_cg_state_full_cg() {
	// 左クリックされたとき、マウスホイール下方向
	if(mouse.left.on_down_up == 1 || mouse.wheel > 0) {
		// 差分があれば差分を表示し、無ければフルCG表示から抜ける
		
		// 次の差分フルCGがあるかチェックする
		k[0] = $check_next_diff_full_cg($current_full_cg_cgdb_name)
		if(k[0] == "") {
			// ない場合、フルCG表示状態を終了する
			$exit_state_full_cg()
		}
		else {
			// 次の差分がある場合、CGを表示する
			$create_full_cg(k[0])
		}
		
		
	}
	// マウスホイール下方向
	if(mouse.wheel < 0) {
		// 差分があれば差分を表示し、無ければフルCG表示から抜ける
		
		// 前の差分フルCGがあるかチェックする
		k[0] = $check_prev_diff_full_cg($current_full_cg_cgdb_name)
		if(k[0] == "") {
			// ない場合、フルCG表示状態を終了する
			$exit_state_full_cg()
		}
		else {
			// 次の差分がある場合、CGを表示する
			$create_full_cg(k[0])
		}
		
		
	}
	// 右クリックされたとき
	elseif(mouse.right.on_down_up == 1) {
		// フルCG表示状態を終了する
		$exit_state_full_cg()
	}
	
	// マウスカーソルの座標によってCGをスクロールさせる処理
	// 座標の制限は名前付き引数
	// 移動速度の算出はCGサイズから(ifでの段階分けは現実的じゃないので1~CGサイズで算出したlinear処理で)
	
	
	// タイプ別処理
	property $type : str
	$type = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_TYPE)
	property $y_scroll
	property $x_scroll
	
	// 縦横幅がオーバー
	if($type == @CGDB_NARG_TYPE_WH_OVER) {
		$y_scroll = 1
		$x_scroll = 1
	}
	// ハーモニクス
	elseif($type == @CGDB_NARG_TYPE_HARMO) {
		$y_scroll = 1
	}
	
	// 縦スクロール
	if($y_scroll == 1) {
		// Y軸方向移動処理
		property $h_base	$h_base = @SCREEN_HEIGHT / 7
		if(mouse.get_pos_y < $h_base) {
			front.object[@OBJ_FOR_FULL_CG].y += math.linear(mouse.get_pos_y, 0, 15, $h_base, 1)
		}
		elseif(mouse.get_pos_y > @SCREEN_HEIGHT - $h_base) {
			front.object[@OBJ_FOR_FULL_CG].y -= math.linear(mouse.get_pos_y, @SCREEN_HEIGHT, 15, @SCREEN_HEIGHT - $h_base, 1)
		}
		
		// 座標補正処理
		property $y_min
		$y_min = $str_to_num($analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_Y_MIN))
		property $y_max
		$y_max = $str_to_num($analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_Y_MAX))
		
		if(front.object[@OBJ_FOR_FULL_CG].y < $y_min) {
			front.object[@OBJ_FOR_FULL_CG].y = $y_min
		}
		if(front.object[@OBJ_FOR_FULL_CG].y > $y_max) {
			front.object[@OBJ_FOR_FULL_CG].y = $y_max
		}
	}
	// 横スクロール
	if($x_scroll == 1) {
		// X軸方向移動処理
		property $w_base	$w_base = @SCREEN_WIDTH  / 7
		if(mouse.get_pos_x < $w_base) {
			front.object[@OBJ_FOR_FULL_CG].x += math.linear(mouse.get_pos_x, 0, 15, $w_base, 1)
		}
		elseif(mouse.get_pos_x > @SCREEN_WIDTH - $w_base) {
			front.object[@OBJ_FOR_FULL_CG].x -= math.linear(mouse.get_pos_x, @SCREEN_WIDTH, 15, @SCREEN_WIDTH - $w_base, 1)
		}
		
		// 座標補正処理
		property $x_min
		$x_min = $str_to_num($analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_X_MIN))
		property $x_max
		$x_max = $str_to_num($analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_X_MAX))
		
		if(front.object[@OBJ_FOR_FULL_CG].x < $x_min) {
			front.object[@OBJ_FOR_FULL_CG].x = $x_min
		}
		if(front.object[@OBJ_FOR_FULL_CG].x > $x_max) {
			front.object[@OBJ_FOR_FULL_CG].x = $x_max
		}
	}
	
}

// フルCG表示状態を終了する
command $exit_state_full_cg() {
	$current_state = @STATE_DEFAULT
	
	// ワイプで消す
	front.object[@OBJ_FOR_FULL_CG_SUPPORT].wipe_copy = 0
	
	// フルCG表示から抜ける
	wipe(0, 200)
	wait_wipe(key_skip=0)
	//front.object[@OBJ_FOR_FULL_CG].init
	
	$restart_objbtngroup()
}


// メイン処理音楽
command $proc_extra_mode_music() {
}

// メイン処理実績
command $proc_extra_mode_achievement() {
	
	// スライドバーが押されている場合
	if(front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].get_button_real_state == 2 || front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].get_button_real_state == 2) { // 
	//if(front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].get_button_real_state == 2) {
		// スライドバーの座標をマウスに追従させる
		front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].y = mouse.get_pos_y - front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].get_size_y / 2
		// スライドバー座標からルート座標の算出
		front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y = math.linear(
			front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].y
			, 89
			, @AC_ROOT_Y_MAX
			, 583
			, @AC_ROOT_Y_MIN
		)
		// 加速度はリセットする
		$ac_mouse_acc_y = 0
	}
	elseif($is_press_music_player_button() == 1) {
	}
	// スライドバーが押されていない場合
	else{
		// 押されたとき
		if(mouse.left.on_down == 1) {
			$ac_mouse_acc_y = 0
			$ac_mouse_old_y = mouse.get_pos_y
		}
		// 押されているとき
		if(mouse.left.is_down == 1) {
			front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y += mouse.get_pos_y - $ac_mouse_old_y
		}
		// 押されて離された時
		if(mouse.left.on_down_up == 1) {
			$ac_mouse_acc_y = mouse.get_pos_y - $ac_mouse_old_y
		}
		
		// マウスホイール下方向
		if (mouse.wheel > 0)  {
			front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y += -120
			$ac_mouse_acc_y = 0
		}
		// マウスホイール上方向
		if (mouse.wheel < 0)  {
			front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y += 120
			$ac_mouse_acc_y = 0
		}
		
		// 加速度の移動処理
		front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y += $ac_mouse_acc_y
		
		// 加速度制限
		if($ac_mouse_acc_y > 40) {
			$ac_mouse_acc_y = 40
		}
		if($ac_mouse_acc_y < -40) {
			$ac_mouse_acc_y = -40
		}
	}
	
	// ルートの座標制限
	if(front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y > @AC_ROOT_Y_MAX) {
		front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y = @AC_ROOT_Y_MAX
	}
	if(front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y < @AC_ROOT_Y_MIN) {
		front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y = @AC_ROOT_Y_MIN
	}
	
	// スライダの座標算出
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].y = math.linear(
		front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y
		, @AC_ROOT_Y_MAX
		, 89
		, @AC_ROOT_Y_MIN
		, 583
	)
	
	
	// 補正済みの座標から絶対座標を算出
	for(l[0] = 0, l[0] < front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child.get_size, l[0]+=1) {
		// 絶対座標を算出
		l[1] = front.object[@OBJ_ACM_ROOT].y + front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].y + front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[l[0]].y
		// 表示矩形範囲外の場合はdisp=0にする
		if(l[1] < @AC_CLIP_Y_MIN || l[1] > @AC_CLIP_Y_MAX) {
			front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[l[0]].disp = 0
		}
		else {
			front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[l[0]].disp = 1
		}
	}
	
	$ac_mouse_old_y = mouse.get_pos_y
}

// メイン処理音楽プレーヤー
command $proc_extra_mode_music_player() {
	
	// 曲の切り替え予約があれば切り替える（値が0,1じゃないのでこれだけ条件式別）
	if($reserve_direct_change_music_ml_idx != -1) {
		// 直接その曲を再生する
		$play_target_ml_idx = $reserve_direct_change_music_ml_idx
		/*
		// $play_target_ml_idxの曲が$current_playlist_idxの何番目か算出する
		l[1] = 0	// 何番目か用のカウンタ
		//l[2] = 0	// 見つかったかフラグ
		for(l[0] = 0, l[0] < $ml_is_playlist.get_size, l[0] += 1) {
			if($play_target_ml_idx == l[0]) {
				//l[2] = 1	// 見つかった
				break
			}
			if($ml_is_playlist[l[0]] == 1) {
				l[1] += 1
			}
		}
		$current_playlist_idx = l[1]
		*/
		$current_playlist_idx = $get_playlist_idx_from_play_target_ml_idx()
		$play_music_player(1)
		$reserve_direct_change_music_ml_idx = -1
	}
	// 次の曲への切り替え予約があれば切り替える
	elseif($reserve_next_music == 1) {
		$next_music_player()
		$reserve_next_music = 0
	}
	// オート版次の曲への切り替え予約があれば切り替える
	elseif($reserve_next_music_auto == 1) {
		// リピートONの場合
		if($is_repeat_on == 1) {
			// 同じ曲を繰り返す
			$stop_music_player()
			$play_music_player(1)
			$reserve_next_music_auto = 0
		}
		// リピートOFFの場合
		else {
			$next_music_player()
			$reserve_next_music_auto = 0
		}
	}
	// 前の曲への切り替え予約があれば切り替える
	elseif($reserve_prev_music == 1) {
		$prev_music_player()
		$reserve_prev_music = 0
	}
	
	
	
	// ボリュームスライドバーの処理
	// クリックした位置に
	
	// ボリュームバーが押されている場合
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].get_button_real_state == 2) {
		// クリップ座標をマウスに追従させる
		l[0] = front.object[@OBJ_MUSIC_PLAYER_ROOT].x + front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].x + front.object[@OBJ_MUSIC_PLAYER_ROOT].x + front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].x
		
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right = math.linear(
			mouse.get_pos_x
			, l[0]
			, 0
			, l[0] + 64
			, 64
		)
	}
	
	// ここからの座標制限→システム反映まではスライドバーが押されている場合のみにやったほうがいいかも？
	
	// クリップ座標制限
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right < 0) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right = 0
	}
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right > 64) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right = 64
	}
	
	// 座標確定後、ボリューム用に変換する
	$player_bgm_volume = math.linear(
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right
		, 0
		, 0
		, 64
		, 255
	)
	// システムに反映する
	syscom.set_bgm_volume($player_bgm_volume)
	
}


// ============================================================
// 初期化系処理
// ============================================================
// 初期化
command $initialize_extra_mode() {
	
	property $temp
	
	// syscom系とかの処理
	close
	bgm.stop(1000)					// タイトルのBGMを止める
	script.set_msg_back_disable		// メッセージバックオフ
	syscom.set_syscom_menu_disable	// システムコマンドを禁止する
	
	
	
	// 一時的にシステム音量を弄るので保存しておく
	$system_all_volume = syscom.get_all_volume		// ALLは弄らないほうがいいかも
	$system_bgm_volume = syscom.get_bgm_volume
	@BEFORE_BGM_VOLUME_OF_EXTRA = syscom.get_bgm_volume
	$system_bgm_onoff = syscom.get_bgm_onoff
	@BEFORE_BGM_ONOFF_OF_EXTRA = syscom.get_bgm_onoff
	syscom.set_bgm_onoff(1)		// 強制的にBGMオン
	@IS_EXIT_GAME_IN_EXTRA=1
	
	// タイトルメニューで使っているオブジェクトを初期化
	front.object[@ObjSysTMenu00].init
	
	
	// 念のため
	@実績システム初期化
	
	// ループ開始フラグ
	$main_loop = 1
	
	// とりあえずCGモードから開始
	$current_mode = @MODE_CG
	
	// ステート
	$current_state = @STATE_DEFAULT
	
	// ユーザフラグの初期化
	$initialize_user_flag()
	
	
	
	// ====================================
	// フェード用
	// ====================================
	front.object[@OBJ_FOR_FADE].init
	front.object[@OBJ_FOR_FADE].create("bg_kuro", 1)
	front.object[@OBJ_FOR_FADE].layer = 100000
	front.object[@OBJ_FOR_FADE].tr = 255
	
	
	
	
	// ====================================
	// タブボタンたち
	// ====================================
	front.object[@OBJ_TAB_BUTTONS].init
	front.object[@OBJ_TAB_BUTTONS].wipe_copy = 1
	front.object[@OBJ_TAB_BUTTONS].disp = 1
	front.object[@OBJ_TAB_BUTTONS].layer = 110
	front.object[@OBJ_TAB_BUTTONS].tr = 255
	front.object[@OBJ_TAB_BUTTONS].child.resize(3)		// CG、音楽、実績
	front.object[@OBJ_TAB_BUTTONS].set_pos(582, 27)		// タブボタンの基準座標
	
	// CGモード
 	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].create(sys_ex_graphic_menu_button, 1, 0, 0)
 	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].patno = 2		// patnoは引数にボタンの種類を取る関数で取得がいいかも
	$temp = 180
	
	// 音楽モード
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].create(sys_ex_music_menu_button, 1, $temp, 0)
	// 実績モード
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].create(sys_ex_record_menu_button, 1, $temp*2, 0)
	
	// ボタン処理
	front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].init
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].set_button(@MODE_CG, @OBJBTNGROUP_TAB_BUTTONS, @OBJBTNACTION_TAB_BUTTONS, @OBJBTNSE_TAB_BUTTONS)
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].set_button(@MODE_MS, @OBJBTNGROUP_TAB_BUTTONS, @OBJBTNACTION_TAB_BUTTONS, @OBJBTNSE_TAB_BUTTONS)
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].set_button(@MODE_AC, @OBJBTNGROUP_TAB_BUTTONS, @OBJBTNACTION_TAB_BUTTONS, @OBJBTNSE_TAB_BUTTONS)
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].set_button_call("$on_select_tab_buttons")
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].set_button_call("$on_select_tab_buttons")
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].set_button_call("$on_select_tab_buttons")
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].set_button_alpha_test(1)
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].set_button_alpha_test(1)
	front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].set_button_alpha_test(1)
	front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].start
	
	
	
	// ====================================
	// タイトルボタン
	// ====================================
	front.object[@OBJ_TITLE_BUTTON].init
	front.object[@OBJ_TITLE_BUTTON].create(sys_sm_page02, 1)
	front.object[@OBJ_TITLE_BUTTON].wipe_copy = 1
	front.object[@OBJ_TITLE_BUTTON].layer = 110
	front.object[@OBJ_TITLE_BUTTON].set_pos(1076,662)
	// ボタン処理
	front.objbtngroup[@OBJBTNGROUP_TITLE_BUTTON].init
	front.object[@OBJ_TITLE_BUTTON].set_button(0, @OBJBTNGROUP_TITLE_BUTTON, @OBJBTNACTION_TITLE_BUTTON, @OBJBTNSE_TITLE_BUTTON)
	front.object[@OBJ_TITLE_BUTTON].set_button_call("$on_select_title_button")
	front.objbtngroup[@OBJBTNGROUP_TITLE_BUTTON].start
	
	
	// ====================================
	// 最上位背景
	// ====================================
	front.object[@OBJ_TOP_BG].init
	front.object[@OBJ_TOP_BG].create("sys_ex_bg01", 1)
	front.object[@OBJ_TOP_BG].wipe_copy = 1
	front.object[@OBJ_TOP_BG].layer = 100
	
	
	
	// ====================================
	// モード説明
	// ====================================
	front.object[@OBJ_MODE_EXPLAIN].init
	front.object[@OBJ_MODE_EXPLAIN].create("sys_ex_header_explain", 1)
	front.object[@OBJ_MODE_EXPLAIN].wipe_copy = 1
	front.object[@OBJ_MODE_EXPLAIN].layer = 100
	front.object[@OBJ_MODE_EXPLAIN].set_pos(205, 35)
	
	
	
	// ====================================
	// CGルート
	// ====================================
	$initialize_extra_mode_cg()
	
	// ====================================
	// 音楽ルート
	// ====================================
	$initialize_extra_mode_music()
	
	// ====================================
	// 実績ルート
	// ====================================
	$initialize_extra_mode_achievement()
	
	// ====================================
	// 共通音楽プレーヤ
	// ====================================
	$initialize_extra_mode_music_player()
	
	// ====================================
	// モード達成率
	// ====================================
	$initialize_extra_mode_collection_rate()
	
	
	// オブジェクトボタングループの停止
	$end_objbtngroup()
	
	front.object[@OBJ_FOR_FADE].tr_eve.set_real(0, 1500, 0, 1)
	front.object[@OBJ_FOR_FADE].tr_eve.wait_key
	
	// オブジェクトボタングループの再始動
	$restart_objbtngroup()
	
	// フレームアクションの登録
	frame_action_ch[14].start_real(-1, "$frame_action_manage_patno")
	
}

// ユーザフラグの初期化
command $initialize_user_flag() {
	
	$cg_mouse_old_y = 0		// 1フレーム前のマウスY座標
	$cg_mouse_acc_y = 0		// マウスの加速度
	
	$ac_mouse_old_y = 0		// 1フレーム前のマウスY座標
	$ac_mouse_acc_y = 0		// マウスの加速度
	
	$play_target_ml_idx = -1
	$pause_samples = @SAMPLES_INIT_VAL
	$is_repeat_on = 0		// リピートONか
	$is_shuffle_on = 0		// シャッフルONか
	$current_playlist_idx = 0
	
	$reserve_direct_change_music_ml_idx = -1
	$reserve_prev_music = 0					// 前の曲へ移動の予約フラグ（0,1
	$reserve_next_music = 0					// 次の曲へ移動の予約フラグ（0,1
	$reserve_next_music_auto = 0			// オート版次の曲へ移動の予約フラグ（0,1
	
	$split_result.init
	
}

// 初期化CG
command $initialize_extra_mode_cg() {
	
	property $i
	property $j
	property $temp
	property $tempstr : str
	
	
	// ====================================
	// CGルート
	// ====================================
	front.object[@OBJ_CGM_ROOT].init
	front.object[@OBJ_CGM_ROOT].wipe_copy = 1
	front.object[@OBJ_CGM_ROOT].disp = $get_disp_by_mode_from_objno(@OBJ_CGM_ROOT)
	front.object[@OBJ_CGM_ROOT].layer = 110
	front.object[@OBJ_CGM_ROOT].tr = 255
	front.object[@OBJ_CGM_ROOT].child.resize(2)		// 
	
	// CGモードは残念ながらCGテーブル(mode.cgm)とスクリプトの二重管理を行う必要がある
	// 安全性をあまり気にしなくていいならスクリプト側に、Zフラグの何番から何番まで使うか登録だけでOK（飛び石禁止になる）
	
	// CGの種別判定はC0とかでは出来ない。スクリプト制御か登録名で制御する
	// 中途半端にCGテーブル使うぐらいなら全部自前で組んだほうが見通しが良い？
	
	// 初期化時にfront.objectで表示処理するのは、一覧のサムネ画像(clickable)のみでOK
	// 差分に関しては、サムネをクリックされた時に別オブジェクトに対して全画面表示するようにすればOK
	// 大きい画像（ゆり催眠、ハーモニクス）についてはマウスを画面端に持って行くとスクロールする形(端に行くほど高速に)
	// 大きい画像は次の差分に行く時に座標を記憶したまま進める必要がある
	
	// 登録名リスト生成
	$create_cgdb_name_list_all()
	// 登録名リスト生成(一覧表示の時のルートCG)
	$create_cgdb_name_list_main()
	
	// CGデータベースの最大アイテム数を取得
	//@debug($get_cgdb_max_item_count())
	
	// フラグからファイル名を取得
	//cgtable.get_name_by_flag_no($i)
	
	
	
	// CGスライダルート
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].init
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].wipe_copy = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].disp = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].layer = 110
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].tr = 255
	//front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].set_pos(1100,80)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child.resize(3)
	
	// CGスライダつまみの部分
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].init
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].create(sys_ex_right_bar_paddle, 1)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].wipe_copy = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].layer = 120
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].tr = 255
	//front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].set_pos(1230,80)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].set_pos(1230,89)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].set_button(0, @OBJBTNGROUP_CG_SLIDE_BAR, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].set_button_call("$on_select_cg_slide_bar")
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[0].set_button_pushkeep(1)
	
	// CGスライダ当たり判定の部分
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].init
	//front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].create(sys_ex_right_bar_bg, 1)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].create(sys_ex_right_bar_bg_collision, 1)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].wipe_copy = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].layer = 110
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].tr = 0
	//front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].set_pos(1230,60)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].set_pos(1220,89)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].set_button(1, @OBJBTNGROUP_CG_SLIDE_BAR, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].set_button_call("$on_select_cg_slide_bar")
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[1].set_button_pushkeep(1)
	
	// CGスライダ縦棒の部分
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].init
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].create(sys_ex_right_bar_bg, 1)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].wipe_copy = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].layer = 110
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].tr = 255
	//front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].set_pos(1230,60)
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CSR].child[2].set_pos(1230,90)
	
	front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].init
	front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].start
	
	
	
	
	
	
	
	// CGリストルート
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].init
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].wipe_copy = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].disp = 1
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].layer = 110
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].tr = 255
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].set_pos(120, @CG_ROOT_Y_MAX)		// 基準座標
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].set_clip(1, @ROOT_CLIP_LEFT, @ROOT_CLIP_TOP, @ROOT_CLIP_RIGHT, @ROOT_CLIP_BOTTOM)		// 画面上での表示矩形
	front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child.resize($cgdb_name_list_main.get_size)
	
	
	
	//OBJC_CSR
	
	property $is_registed
	property $is_diff_registed
	property $diff_cg_idx_all
	property $thumbnail_file_name : str
	// CGリスト分のオブジェクトを生成する
	for($i = 0, $i < $cgdb_name_list_main.get_size, $i += 1) {
		
//		// 初期化系
//		$is_registed = 0		// 差分すら一枚も見てないのを示す、一枚でも見ていれば1
//		$is_diff_registed = 0	// 差分用フラグ
//		$diff_cg_idx_all = 0	// 差分CGのALL内でのインデックス
//		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].init
//		
//		// CGデータベースの登録名からフルCG情報を取得
//		$get_full_cg_data_from_cgdb_name($cgdb_name_list_main[$i])
//		// 既に見ている
//		if(Z[ $got_cgdb_zfid ] == 1) {
//			$is_registed = 1
//		}
//		// まだ見ていない場合
//		else {
//			
//			// 差分CGで見た物があるかチェックする
//			l[0] = $got_cgdb_cgno
//			
//			// 全登録CGから同じCG番号の物を探す
//			for($j = 0, $j < $cgdb_name_list_all.get_size, $j += 1) {
//				// 同じCG番号の場合
//				if(l[0] == $get_db_num($j, @CGDB_COLUMN_CGNO)) {
//					// 既に見ている場合
//					if(Z[ $get_db_num($j, @CGDB_COLUMN_ZFID) ] == 1) {
//						$is_registed = 1
//						$is_diff_registed = 1
//						$diff_cg_idx_all = $j
//						break
//					}
//				}
//			}
//		}
//		
//		//$is_registed = 1	// ★★★★★★★★★★★★★★★★★★★デバッグ用に強制的に見た
//		
//		
//		// 既に見ている場合
//		if($is_registed) {
//			// 差分を見ていた場合
//			if($is_diff_registed) {
//				$thumbnail_file_name = $create_thumbnail_file_name($cgdb_name_list_all[$diff_cg_idx_all])
//			}
//			// 差分ではなく直接見ていた場合
//			else {
//				$thumbnail_file_name = $create_thumbnail_file_name($cgdb_name_list_main[$i])
//			}
//		}
//		// 見ていない場合
//		else {
//			$thumbnail_file_name = sys_ex_cg_none
//		}
//		
//		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].create($thumbnail_file_name, 1)
//		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].layer = 100
//		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].tr = 255
//		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_pos($i % 4 * 268, $i / 4 * 165)
//		/*
//		if($is_registed) {	// 本番はスケール調整なんていらない
//			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_scale(100000 / 533, 100000 / 533)	// 暫定処理
//		}*/
//		
//		// 既に見ている場合のみクリック出来る
//		if($is_registed) {
//			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_button($i, @OBJBTNGROUP_CG_LIST, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
//		}
		
		// 最初に見える16個は通常読み込み
		if($i < 16) {
			$create_thumbnail_object($i)
		}
		// それ以外はロード中画像
		else {
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].create("thumb_loading", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].layer = 100
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_pos($i % 4 * 268, $i / 4 * 165)
		}
	}
	
	
	front.objbtngroup[@OBJBTNGROUP_CG_LIST].init
	front.objbtngroup[@OBJBTNGROUP_CG_LIST].start
	
	
	
}

// サムネイルオブジェクトを生成する
command $create_thumbnail_object(property $idx) {
	
	property $i
	property $j
	property $temp
	property $tempstr : str
	
	property $is_registed
	property $is_diff_registed
	property $diff_cg_idx_all
	property $thumbnail_file_name : str
	property $max_diff_count
	property $collect_diff_count
	
	$i = $idx
	// CGリスト分のオブジェクトを生成する
	//for($i = 0, $i < $cgdb_name_list_main.get_size, $i += 1) {
		
		// 初期化系
		$is_registed = 0		// 差分すら一枚も見てないのを示す、一枚でも見ていれば1
		$is_diff_registed = 0	// 差分用フラグ
		$diff_cg_idx_all = 0	// 差分CGのALL内でのインデックス
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].init
		
		// CGデータベースの登録名からフルCG情報を取得
		$get_full_cg_data_from_cgdb_name($cgdb_name_list_main[$i])
		// 既に見ている
		if(Z[ $got_cgdb_zfid ] == 1) {
			$is_registed = 1
		}
		// まだ見ていない場合
		else {
			
			// 差分CGで見た物があるかチェックする
			l[0] = $got_cgdb_cgno
			
			// 全登録CGから同じCG番号の物を探す
			for($j = 0, $j < $cgdb_name_list_all.get_size, $j += 1) {
				// 同じCG番号の場合
				if(l[0] == $get_db_num($j, @CGDB_COLUMN_CGNO)) {
					// 既に見ている場合
					if(Z[ $get_db_num($j, @CGDB_COLUMN_ZFID) ] == 1) {
						$is_registed = 1
						$is_diff_registed = 1
						$diff_cg_idx_all = $j
						break
					}
				}
			}
		}
		
		//$is_registed = 1	// ★★★★★★★★★★★★★★★★★★★デバッグ用に強制的に見た
		
		
		
		
		// 既に見ている場合
		if($is_registed) {
			// 差分を見ていた場合
			if($is_diff_registed) {
				$thumbnail_file_name = $create_thumbnail_file_name($cgdb_name_list_all[$diff_cg_idx_all])
			}
			// 差分ではなく直接見ていた場合
			else {
				$thumbnail_file_name = $create_thumbnail_file_name($cgdb_name_list_main[$i])
			}
		}
		// 見ていない場合
		else {
			$thumbnail_file_name = sys_ex_cg_none
		}
		
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].create($thumbnail_file_name, 1)
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].layer = 100
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].tr = 255
		front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_pos($i % 4 * 268, $i / 4 * 165)
		
		// 既に見ている場合のみクリック出来る
		if($is_registed) {
			//front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_button($i, @OBJBTNGROUP_CG_LIST, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].set_button($i, @OBJBTNGROUP_CG_LIST, @OBJBTNACTION_CG_LIST, @OBJBTNSE_DEFAULT)
		}
		
		
		// 差分枚数とその中で見たCGの数を取得
		// CGデータベースの登録名からフルCG情報を取得
		$get_full_cg_data_from_cgdb_name($cgdb_name_list_main[$i])
		
		// 差分CGで見た物があるかチェックする
		l[0] = $got_cgdb_cgno
		
		// 全登録CGから同じCG番号の物を探す
		for($j = 0, $j < $cgdb_name_list_all.get_size, $j += 1) {
			// 同じCG番号の場合
			if(l[0] == $get_db_num($j, @CGDB_COLUMN_CGNO)) {
				// 既に見ている場合
				if(Z[ $get_db_num($j, @CGDB_COLUMN_ZFID) ] == 1) {
					$collect_diff_count += 1
				}
				$max_diff_count += 1
			}
		}
		
		
		// 既に見ている場合
		if($is_registed) {
			// 差分枚数オブジェクト系
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child.resize(6)
			// 枠
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[0].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[0].create("sys_ex_cg_diff_bg", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[0].wipe_copy = 1
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[0].layer = 110
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[0].set_pos(@THUMBNAIL_WIDTH-67, @THUMBNAIL_HEIGHT-17)
			// 見たCGカウント一桁目
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].create("sys_ex_cg_diff_num", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].wipe_copy = 1
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].layer = 110
			// 見たCGカウント二桁目
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].create("sys_ex_cg_diff_num", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].wipe_copy = 1
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].layer = 110
			// 差分CGカウント一桁目
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].create("sys_ex_cg_diff_num", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].wipe_copy = 1
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].layer = 110
			// 差分CGカウント二桁目
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].create("sys_ex_cg_diff_num", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].wipe_copy = 1
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].layer = 110
			// セパレータ
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].init
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].create("sys_ex_cg_diff_num", 1)
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].wipe_copy = 1
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].layer = 110
			
			// 座標制御
			if($max_diff_count < 10) {
				//front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].set_pos(190, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].set_pos(210, 122)
				//front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].set_pos(220, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].set_pos(230, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].set_pos(220, 122)
			}
			else {
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].set_pos(192, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].set_pos(202, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].set_pos(220, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].set_pos(230, 122)
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].set_pos(212, 122)
			}
			
			// パターン番号制御
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].patno = $collect_diff_count / 10
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[2].patno = $collect_diff_count % 10
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].patno = $max_diff_count / 10
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[4].patno = $max_diff_count % 10
			front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[5].patno = 10
			
			// 二桁目の表示制御
			if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].patno == 0) { 
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[1].disp = 0
			}
			if(front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].patno == 0) { 
				front.object[@OBJ_CGM_ROOT].child[@OBJC_CLR].child[$i].child[3].disp = 0
			}
		}
		
	//}
	
}
	
// フルCGファイル名からサムネファイル名を生成
command $create_thumbnail_file_name(property $full_cg_name : str) : str {
	property $return_fn : str
	
	// CGデータベースの登録名からフルCG情報を取得
	$get_full_cg_data_from_cgdb_name($full_cg_name)
	
	// データの取得
	property $thumb_fn : str
	$thumb_fn = $got_cgdb_thfn
	// サムネファイル名が登録されている場合
	if($thumb_fn != "") {
		$return_fn = $thumb_fn
	}
	// サムネファイル名が登録されていない場合
	else {
		// 本来サムネ用に識別子なりがついたファイル名
		$return_fn = $full_cg_name
	}
	
	return($return_fn)
}

// 初期化音楽
command $initialize_extra_mode_music() {
	
	property $i
	property $j
	property $temp
	property $tempstr : str
	
	
	
	property $array_idx $array_idx = 0
	// 一覧に表示する物を登録する
	// ★はチェック済みOK、☆はチェック済みだけど要確認
	$array_idx = $add_musiclist($array_idx, "M102","","themeofSSS","01", @REST_SEC+60*1+53, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M103","N103","schooldays","01", @REST_SEC+60*2+21, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M104","N104","girlshop","01", @REST_SEC+60*2+12, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M105","N105","artofwar","01", @REST_SEC+60*1+35, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M106","N106","todayisok","01", @REST_SEC+60*3+52, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M107","N107","memory","01", @REST_SEC+60*1+33, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M108","","mymostprecioustreasure","02", @REST_SEC+60*2+48, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "M109","N109","tactics","01", @REST_SEC+60*1+32, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M110","N110","enemycountry","01", @REST_SEC+60*2+12, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M111","N111","operationstart","01", @REST_SEC+60*2+19, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M112","N112","decisivebattle","01", @REST_SEC+60*1+39, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M113","N113","attack","01", @REST_SEC+60*1+49, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M114","N114","criticalpoint","01", @REST_SEC+60*1+12, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M115","N115","studytime","01", @REST_SEC+60*1+38, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M116","N116","nikuudon","01", @REST_SEC+60*2+05, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M117","N117","invention","01", @REST_SEC+60*1+08, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M118","N118","toyofspring","01", @REST_SEC+60*1+46, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M119","N119","deochi","01", @REST_SEC+60*1+35, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M120","N120","lightdrop","01", @REST_SEC+60*2+00, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M121","N121","worthyrival","01", @REST_SEC+60*2+06, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M122","N122","burial","01", @REST_SEC+60*2+48, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M123","N123","playball","01", @REST_SEC+60*2+47, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M124","","walkure","01", @REST_SEC+60*0+30, @ガルデモオフ)					// ★
	$array_idx = $add_musiclist($array_idx, "M125","","letsoperation","01", @REST_SEC+60*2+01, @ガルデモオフ)			// ★ 
	$array_idx = $add_musiclist($array_idx, "M126","N126","eveningbreeze","01", @REST_SEC+60*2+06, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M127","N127","momentofrest","01", @REST_SEC+60*2+11, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M201","N201","initialimpulse","01", @REST_SEC+60*1+14, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M202","N202","myheart","02", @REST_SEC+60*2+49, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M203","N203","soulfriends","02", @REST_SEC+60*2+56, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M204","N204","kanade","02", @REST_SEC+60*3+03, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M205","N205","mymostprecioustreasureorgel","02", @REST_SEC+60*2+21, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "M206","","memoryorgel","01", @REST_SEC+60*1+33, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M207","","unjustlife","01", @REST_SEC+60*2+45, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M208","N208","nocturneintheafternoon","01", @REST_SEC+60*1+39, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "M209","N209","anxiety","01", @REST_SEC+60*1+49, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M210","N210","abyss","01", @REST_SEC+60*3+17, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M211","N211","alterego","01", @REST_SEC+60*1+50, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M212","N212","siren","01", @REST_SEC+60*1+50, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M213","N213","transformstotheshadow","01", @REST_SEC+60*2+25, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "M214","N214","otonashi","01", @REST_SEC+60*1+40, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M215","N215","angelsflight","01", @REST_SEC+60*1+16, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "M216","N216","firingpreparation","01", @REST_SEC+60*2+14, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "M217","N217","desperation","01", @REST_SEC+60*2+33, @ガルデモオフ)			// ★
	$array_idx = $add_musiclist($array_idx, "M218","N218","breakthrough","01", @REST_SEC+60*3+08, @ガルデモオフ)		// ★
	
	$array_idx = $add_musiclist($array_idx, "m301","N301","sprout","03", @REST_SEC+60*2+09, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "m302","N302","somebodydays","03", @REST_SEC+60*1+52, @ガルデモオフ)		// ★
	$array_idx = $add_musiclist($array_idx, "m303","N303","easyoff","03", @REST_SEC+60*1+30, @ガルデモオフ)				// ★
	$array_idx = $add_musiclist($array_idx, "M092","","stillhere","02", @REST_SEC+60*4+00, @ガルデモオフ)				// ★
	//$array_idx = $add_musiclist($array_idx, "M092","","stillhere","02", @REST_SEC+60*4+58, @ガルデモオフ)				// ★
	//$array_idx = $add_musiclist($array_idx, "M092","M093","stillhereorgel","02", @REST_SEC+60*4+53, @ガルデモオフ)	// 使わなくなった
	
	$array_idx = $add_musiclist($array_idx, "HajimariPf","","beginningoftheend","04", @REST_SEC+60*2+48, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "M090","M091","ufufuthese","05", @REST_SEC+60*4+05, @ガルデモオフ)			// ★
	
	$array_idx = $add_musiclist($array_idx, "HeartilySong","","HeartilySong","08", @REST_SEC+60*2+56, @ガルデモオフ)	// ★
	$array_idx = $add_musiclist($array_idx, "CrowSong","_CrowSong","CrowSong","06", @REST_SEC+60*1+47, @ガルデモオン)	// ★
	$array_idx = $add_musiclist($array_idx, "Alchemy","_Alchemy","Alchemy","06", @REST_SEC+60*1+50, @ガルデモオン)		// ★
	$array_idx = $add_musiclist($array_idx, "MySong","_MySong","MySong","06", @REST_SEC+60*2+17, @ガルデモオン)			// ★
	//$array_idx = $add_musiclist($array_idx, "MySoul","","MySoulYourBeats","08", 120, @ガルデモオフ)					// 使わなくなった
	$array_idx = $add_musiclist($array_idx, "MySoul","_MySoul","MySoulYourBeatsGldemover","09", @REST_SEC+60*1+31, @ガルデモオン)	// ★
	$array_idx = $add_musiclist($array_idx, "HotMeal","_HotMeal","HotMeal","06", @REST_SEC+60*1+50, @ガルデモオン)		// ★
	$array_idx = $add_musiclist($array_idx, "ThousandEnemies","_ThousandEnemies","ThousandEnemies","09", @REST_SEC+60*1+45, @ガルデモオン)	// ★
	$array_idx = $add_musiclist($array_idx, "Treasure1","_Treasure","ichibanyui","09", @REST_SEC+60*2+00, @ガルデモオン)	// ★
	$array_idx = $add_musiclist($array_idx, "Hajimari","","subeteno","07", @REST_SEC+60*4+19, @ガルデモオフ)			// ★
	
	
	
	// ====================================
	// 音楽ルート
	// ====================================
	front.object[@OBJ_MSM_ROOT].init
	front.object[@OBJ_MSM_ROOT].wipe_copy = 1
	front.object[@OBJ_MSM_ROOT].disp = $get_disp_by_mode_from_objno(@OBJ_MSM_ROOT)
	front.object[@OBJ_MSM_ROOT].layer = 110
	front.object[@OBJ_MSM_ROOT].tr = 255
	front.object[@OBJ_MSM_ROOT].child.resize(2)		// 曲タイトルルート、複数チェックボタンルート
	front.object[@OBJ_MSM_ROOT].set_pos(226, 100)		// 基準座標
	
	// 曲タイトルルート
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].init
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].wipe_copy = 1
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].disp = 1
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].layer = 110
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].tr = 255
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child.resize($ml_reg_name.get_size)
	
	property $is_listened
	for($i = 0, $i < $ml_reg_name.get_size, $i+=1) {
		
		// 視聴済み
		if(bgmtable.get_listen_by_name($ml_reg_name[$i]) == 1) {
			$is_listened = 1
		}
		// 未試聴
		else {
			$is_listened = 0
		}
		
		if($is_listened) {
			$tempstr = @FN_PLAYLIST + $ml_title_file_name[$i]
		}
		else {
			$tempstr = @FN_PLAYLIST + "none"
		}
		
		// 曲タイトルオブジェクト生成
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].init
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].create($tempstr, 1)
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].patno = 0
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].layer = 110
		//front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].set_pos($i % 4 * 250 + 0, $i / 4 * @STR_Y_INTERVAL)
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].set_pos($i / 21 * 350 + 0, $i % 21 * 25)
		
		if($is_listened) {
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].set_button($i, @OBJBTNGROUP_MUSIC_TITLES, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].set_button_call("$on_select_music_title_buttons")
		}
		
		
		// チェックボックス
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child.resize(1)
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].init
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].wipe_copy = 1
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].disp = 1
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].layer = 110
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].tr = 255
		
		if($ml_is_playlist[$i] == 0) {
			$tempstr = "□"
		}
		elseif($ml_is_playlist[$i] == 1) {
			$tempstr = "■"
		}
		
		// チェックオブジェクト生成
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].create(sys_ex_music_check, 1)
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].set_pos(0, 5)
		if($is_listened) {
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].patno = 3
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].set_button($i, @OBJBTNGROUP_MUSIC_CHECK_BOXES, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].set_button_call("$on_select_music_check_box_buttons")
		}
		else {
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].patno = 0
		}
	}
	
	front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].start
	front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].start
	
	
	
	// 複数チェックボタンルート
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].init
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].wipe_copy = 1
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].disp = 1
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].layer = 110
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].tr = 255
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child.resize(@MMB_MAX)		// ALLオン、ALLオフ、ガルデモオン
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].set_pos(-front.object[@OBJ_MSM_ROOT].x, -front.object[@OBJ_MSM_ROOT].y)	// 0,0に行くように
	
	
	// 一括処理
	for($i = 0, $i < front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child.get_size, $i+=1) {
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].init
		if($i == @MMB_ALL_ON)  { front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].create(sys_ex_music_check_all, 1) }
		if($i == @MMB_ALL_OFF) { front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].create(sys_ex_music_uncheck_all, 1) }
		if($i == @MMB_GLDM_ON) { front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].create(sys_ex_music_check_gldemo, 1) }
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].wipe_copy = 1
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].layer = 110
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].tr = 255
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].set_pos(0, $i * 40 + 100)
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].set_button($i, @OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].set_button_call("$on_select_music_multi_check_buttons")
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MMR].child[$i].set_button_alpha_test(1)
	}
	front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].start
	
	
	
}

// 初期化実績
command $initialize_extra_mode_achievement() {
	
	property $i
	property $j
	property $temp
	property $tempstr : str
	
	
	// ====================================
	// 実績ルート
	// ====================================
	front.object[@OBJ_ACM_ROOT].init
	front.object[@OBJ_ACM_ROOT].wipe_copy = 1
	front.object[@OBJ_ACM_ROOT].disp = $get_disp_by_mode_from_objno(@OBJ_ACM_ROOT)
	front.object[@OBJ_ACM_ROOT].layer = 110
	front.object[@OBJ_ACM_ROOT].tr = 255
	front.object[@OBJ_ACM_ROOT].child.resize(2)		// スライダルート、実績一覧ルート
	
	// 実績スライダルート
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].init
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].wipe_copy = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].disp = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].layer = 110
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].tr = 255
	//front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].set_pos(1100,80)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child.resize(3)
	
	// 実績スライダつまみの部分
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].init
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].create(sys_ex_right_bar_paddle, 1)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].wipe_copy = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].layer = 120
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].tr = 255
	//front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].set_pos(1230,80)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].set_pos(1230,90)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].set_button(0, @OBJBTNGROUP_AC_SLIDE_BAR, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].set_button_call("$on_select_achievement_slide_bar")
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[0].set_button_pushkeep(1)
	
	// 実績スライダ当たり判定の部分
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].init
	//front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].create(sys_ex_right_bar_bg, 1)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].create(sys_ex_right_bar_bg_collision, 1)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].wipe_copy = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].layer = 110
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].tr = 0
	//front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].set_pos(1230,60)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].set_pos(1220,90)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].set_button(1, @OBJBTNGROUP_AC_SLIDE_BAR, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].set_button_call("$on_select_achievement_slide_bar")
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[1].set_button_pushkeep(1)
	
	// 実績スライダ縦棒の部分
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].init
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].create(sys_ex_right_bar_bg, 1)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].wipe_copy = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].layer = 110
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].tr = 255
	//front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].set_pos(1230,60)
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ASR].child[2].set_pos(1230,90)
	
	front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].init
	front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].start
	
	
	
	// 実績一覧ルート
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].init
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].wipe_copy = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].disp = 1
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].layer = 110
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].tr = 255
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child.resize($$get_achievement_list_size())		// 実績の数だけ確保
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].set_pos(160, @AC_ROOT_Y_MAX)		// 基準座標
	front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].set_clip(1, @ROOT_CLIP_LEFT, @ROOT_CLIP_TOP, @ROOT_CLIP_RIGHT, @ROOT_CLIP_BOTTOM)		// 画面上での表示矩形
	
	// 実績一覧
	
	// ソートの為にコピー
	$sorted_idx_list.resize($al_did.get_size)
	for($i = 0, $i < $al_did.get_size, $i+=1) {
		$sorted_idx_list[$i] = $al_did[$i]
	}
	// 昇順でバブルソートする
	for($i = 0, $i < $sorted_idx_list.get_size, $i+=1) {
		for($j = ($sorted_idx_list.get_size - 1), $j > $i, $j-=1) {
			if($sorted_idx_list[$j-1] > $sorted_idx_list[$j]) {
				$temp = $sorted_idx_list[$j-1]
				$sorted_idx_list[$j-1] = $sorted_idx_list[$j]
				$sorted_idx_list[$j] = $temp
			}
		}
	}
	// ソート後の順で操作したいときには
	for($i = 0, $i < $sorted_idx_list.get_size, $i+=1){
		for($j = 0, $j < $al_did.get_size, $j+=1){
			if($sorted_idx_list[$i] == $al_did[$j]) {
				// $jがよく使う$al_idxとなり、$iは単純に0からの順番を示す値に
				//$str += "[" + math.tostr($i) + "]" + $al_mes[$j] + " "
				// n個おきに改行などの処理
				//if($i % 5 == 4) { $str += "\n\n" }
				
				// 未取得の場合
				if(z[ $al_zid[$j] ] == 0) {
					$tempstr = "No." + math.tostr_zero($al_did[$j], 3) + " #110C" + "？？？？？？"	// 6巻まで考えると4桁の方がいい？
					//$tempstr = "No." + math.tostr_zero($al_did[$j], 3) + " #110C" + "？？？？？？ #2C" + $al_mes[$j]	// 6巻まで考えると4桁の方がいい？
				}
				// 取得済みの場合（new管理するなら値を1と2で違う挙動にする方がいい
				elseif(z[ $al_zid[$j] ]  == 1) {
					$tempstr = "#110CNo." + math.tostr_zero($al_did[$j], 3) + " " + $al_mes[$j]	// 6巻まで考えると4桁の方がいい？
				}
				
				//$tempstr = "No." + math.tostr_zero($al_did[$j], 3) + " " + $al_mes[$j]	// 6巻まで考えると4桁の方がいい？
				
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].init
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].create_string($tempstr, 1)
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].set_string_param(@STR_FONT_SIZE, 0, 0, $tempstr.len, 0, 0, 0)
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].wipe_copy = 1
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].layer = 110
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].set_pos($i % 2 * 500 + 0, $i / 2 * @STR_Y_INTERVAL)
				
				// 実績枠部分
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child.resize(1)
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].init
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].create(sys_ex_record_title_bg, 1)
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].wipe_copy = 1
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].layer = 109
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].set_pos(-5, -6)	// 微調整
				front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].patno = 0
				// 取得済みの場合
				if(z[ $al_zid[$j] ] == 1) {
					front.object[@OBJ_ACM_ROOT].child[@OBJC_ALR].child[$i].child[0].patno = 1
				}
				
				break
			}
		}
	}
	
	
}


// 音楽プレーヤの初期化
command $initialize_extra_mode_music_player() {
	
	property $i
	property $j
	property $temp
	property $tempstr : str
	
	
	// プレーヤのBGMボリューム初期値はシステムから引っ張って来た値を使う
	$player_bgm_volume = $system_bgm_volume
	syscom.set_bgm_volume($player_bgm_volume)
	
	
	// ====================================
	// 音楽プレーヤルート
	// ====================================
	front.object[@OBJ_MUSIC_PLAYER_ROOT].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].disp = 1					// おまけモードの種類に関係なく表示する
	front.object[@OBJ_MUSIC_PLAYER_ROOT].layer = 110
	front.object[@OBJ_MUSIC_PLAYER_ROOT].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child.resize(3)			// 曲情報、ボタンルート、ボリュームスライダルート
	
	
	// プレーヤ曲情報ルート
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].disp = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].layer = 110
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child.resize(2)	// 曲タイトル、曲情報
	
	// 音楽プレーヤのタイトルと情報の生成
	//$create_music_player_title_and_info(0)
	
	
	// プレーヤボタンルート
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].disp = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].layer = 110
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child.resize(@MPB_MAX)		// 前、停止、一時停止、再生、次、リピ、シャッフル、ヘルプ
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].set_pos(0, 0)
	
	// ボタン系処理
	for($i = 0, $i < front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child.get_size, $i+=1){
		$initialize_music_player_button($i)
	}
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].start
	
	
	// プレーヤボリュームスライダルート
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].disp = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].layer = 110
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child.resize(4)		// 白、黄、プラス、マイナス
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].set_pos(0, 0)
	
	
	
	
	// 白バー
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].create("sys_ex_player_volume_bar_w", 1)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].layer = 120
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].set_pos(945, 660)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].set_button(0, @OBJBTNGROUP_MUSIC_PLAYER_VOLUME, @OBJBTNACTION_DEFAULT, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].set_button_call("$on_select_music_player_volume")
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].set_button_pushkeep(1)
	
	// 黄バー
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].create("sys_ex_player_volume_bar_y", 1)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].layer = 120
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].set_pos(945, 660)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].set_src_clip(1, 0, 0, 64, 40)
	
	// プラスボタン
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].create("sys_ex_player_volume_plus_button", 1)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].layer = 120
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].set_pos(1003, 660)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].set_button(2, @OBJBTNGROUP_MUSIC_PLAYER_VOLUME, @OBJBTNACTION_MUSIC_PLAYER_VOLUME, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].set_button_call("$on_select_music_player_volume")
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].set_button_pushkeep(1)
	// マイナスボタン
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].init
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].create("sys_ex_player_volume_minus_button", 1)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].layer = 120
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].set_pos(1005, 685)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].set_button(3, @OBJBTNGROUP_MUSIC_PLAYER_VOLUME, @OBJBTNACTION_MUSIC_PLAYER_VOLUME, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].set_button_call("$on_select_music_player_volume")
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].set_button_pushkeep(1)
	
	
	// ボタン処理開始
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].start
	
	// ボリューム値をクリップ座標に反映する
	$update_volume_clip_right_from_music_player_volume()
	
	// プレイリストの作成
	$create_playlist()
	
	// 停止状態からはじめる
	$current_player_state = @PLAYER_STATE_STOP
	
	
	// tacticsを再生する、聴いてなければtheme of SSS
	$play_target_ml_idx = -1
	for($i = 0, $i < $ml_reg_name.get_size, $i+=1) {
		if(@TACTICS_GAMEEXEINI_REG_NAME == $ml_reg_name[$i]) {
			if(bgmtable.get_listen_by_name($ml_reg_name[$i]) == 1) {
				$play_target_ml_idx = $i
			}
		}
	}
	// tacticsが見つからなかった時
	if($play_target_ml_idx == -1) {
		for($i = 0, $i < $ml_reg_name.get_size, $i+=1) {
			if(@THEMEOFSSS_GAMEEXEINI_REG_NAME == $ml_reg_name[$i]) {
				if(bgmtable.get_listen_by_name($ml_reg_name[$i]) == 1) {
					$play_target_ml_idx = $i
				}
			}
		}
	}
	// どちらも見つからなかった時の処理
	if($play_target_ml_idx == -1) {
		$play_target_ml_idx = 1
	}
	$current_playlist_idx = $get_playlist_idx_from_play_target_ml_idx()
	
	// 再生する曲が見つかった場合
	if($current_playlist_idx != -1) {
		// 再生
		$play_music_player(1)
		// デフォルト再生をしなくなったので下記２つの処理が必要に（再生に戻ったけど処理あっても問題ないのでままで
		// 曲タイトルリストのパターン番号を更新
		$update_music_tile_list_patno()
		// プレーヤ情報更新
		$create_music_player_title_and_info(0)
	}
	
	// 
	$is_shuffle_on = 0	// デフォルトシャッフルなし
	$is_repeat_on = 0	// デフォルトリピートなし
	
	// 予約フラグ系
	$reserve_direct_change_music_ml_idx = -1
	$reserve_prev_music = 0
	$reserve_next_music = 0
	$reserve_next_music_auto = 0
	
}

// 音楽プレーヤのタイトルと情報の生成
command $create_music_player_title_and_info(property $is_wipe) {
	// ワイプなしの場合はfrontに直接
	//if($is_wipe == 0) {
		// タイトル
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[0].init
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[0].create(@FN_PLAYER_TITLE + $ml_title_file_name[$play_target_ml_idx], 1)
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[0].wipe_copy = 1
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[0].layer = 110
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[0].tr = 255
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[0].set_pos(645, 675)
		
		// 曲情報
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[1].init
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[1].create(@FN_PLAYER_INFO + $ml_info_file_name[$play_target_ml_idx], 1)
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[1].wipe_copy = 1
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[1].layer = 110
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[1].tr = 255
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PIR].child[1].set_pos(645, 698)
	//}
}

// 曲リストに追加する
command $add_musiclist(
	property $array_idx : int
	, property $gameexe_ini_name : str
	, property $gameexe_ini_name_for_play : str
	, property $title_file_name : str
	, property $info_file_name : str
	, property $play_time
	, property $is_gldm
) : int  {
	
	// 足りなかったらリサイズ
	if($ml_reg_name.get_size <= $array_idx) { $ml_reg_name.resize($array_idx+1) }
	if($ml_reg_name_for_play.get_size <= $array_idx) { $ml_reg_name_for_play.resize($array_idx+1) }
	
	if($ml_title_file_name.get_size <= $array_idx) { $ml_title_file_name.resize($array_idx+1) }
	if($ml_info_file_name.get_size <= $array_idx) { $ml_info_file_name.resize($array_idx+1) }
	if($ml_play_time.get_size <= $array_idx) { $ml_play_time.resize($array_idx+1) }
	if($ml_is_gldm.get_size <= $array_idx) { $ml_is_gldm.resize($array_idx+1) }
	if($ml_is_playlist.get_size <= $array_idx) { $ml_is_playlist.resize($array_idx+1) }
	
	$ml_reg_name[$array_idx] = $gameexe_ini_name
	if($gameexe_ini_name_for_play != "") {
		$ml_reg_name_for_play[$array_idx] = $gameexe_ini_name_for_play
	}
	else {
		$ml_reg_name_for_play[$array_idx] = $gameexe_ini_name
	}
	
	$ml_title_file_name[$array_idx] = $title_file_name
	$ml_info_file_name[$array_idx] = $info_file_name
	$ml_play_time[$array_idx] = $play_time * 1000// 5 * 1000
	$ml_is_gldm[$array_idx] = $is_gldm
	
	// 視聴済み
	if(bgmtable.get_listen_by_name($ml_reg_name[$array_idx]) == 1) {
		$ml_is_playlist[$array_idx] = 1
	}
	// 未試聴
	else {
		$ml_is_playlist[$array_idx] = 0
	}
	
	
	$array_idx += 1
	return($array_idx)
}


// 音楽プレーヤボタンの初期化
command $initialize_music_player_button(property $button_type) {
	
	// 共通初期化
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].init
	
	property $pos_y $pos_y = 665
	property $pos_x $pos_x = 0
	
	// ボタンごとの設定
	// 前へ
	if($button_type == @MPB_PREV) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_prev_button, 1)
		$pos_x = 400
		$pos_y -= 2
	}
	// 停止
	elseif($button_type == @MPB_STOP) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_stop_button, 1)
		$pos_x = 300
	}
	// 一時停止
	elseif($button_type == @MPB_PAUSE) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_pause_button, 1)
		$pos_x = 250
	}
	// 再生
	elseif($button_type == @MPB_PLAY) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_play_button, 1)
		$pos_x = 200
		// 再生状態から開始するので
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].patno = 1
	}
	// 次へ
	elseif($button_type == @MPB_NEXT) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_next_button, 1)
		$pos_x = 840
		$pos_y -= 2
	}
	// リピート
	elseif($button_type == @MPB_REPEAT) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_repeat_button, 1)
		$pos_x = 350
		$pos_y -= 1
	}
	// シャッフル
	elseif($button_type == @MPB_SHUFFLE) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].create(sys_ex_player_shuffle_button, 1)
		$pos_x = 890
		$pos_y -= 1
	}
	
	//front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].set_pos($button_type * 50, $pos_y)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].set_pos($pos_x, $pos_y)
	
	// 共通設定
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].wipe_copy = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].disp = 1
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].layer = 120
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].tr = 255
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].set_button($button_type, @OBJBTNGROUP_MUSIC_PLAYER_BUTTONS, @OBJBTNACTION_PLAYER_BUTTON, @OBJBTNSE_DEFAULT)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].set_button_call("$on_select_music_player_buttons")
	
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$button_type].set_button_pushkeep(1)
	
}


// 達成率の初期化
command $initialize_extra_mode_collection_rate() {
	
	// ルート
	front.object[@OBJ_MODE_RATE].init
	front.object[@OBJ_MODE_RATE].disp = 1
	front.object[@OBJ_MODE_RATE].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].layer = 100
	front.object[@OBJ_MODE_RATE].set_pos(-27, 500)
	front.object[@OBJ_MODE_RATE].child.resize(2)	// CG、実績
	
	property $y
	$y = 40
	
	// =======================================
	// CGモード
	// 背景
	front.object[@OBJ_MODE_RATE].child[0].init
	front.object[@OBJ_MODE_RATE].child[0].create("sys_ex_rate_bg01")
	front.object[@OBJ_MODE_RATE].child[0].disp = 1		// デフォルトCGモードなので表示
	front.object[@OBJ_MODE_RATE].child[0].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[0].layer = 100
	
	// パーセンテージ
	front.object[@OBJ_MODE_RATE].child[0].child.resize(3)	// 達成率の数字用
	
	front.object[@OBJ_MODE_RATE].child[0].child[0].init
	front.object[@OBJ_MODE_RATE].child[0].child[0].create("sys_ex_rate_num", 1)
	front.object[@OBJ_MODE_RATE].child[0].child[0].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[0].child[0].layer = 100
	front.object[@OBJ_MODE_RATE].child[0].child[0].set_pos(42, $y)
	front.object[@OBJ_MODE_RATE].child[0].child[0].patno = 1
	
	front.object[@OBJ_MODE_RATE].child[0].child[1].init
	front.object[@OBJ_MODE_RATE].child[0].child[1].create("sys_ex_rate_num", 1)
	front.object[@OBJ_MODE_RATE].child[0].child[1].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[0].child[1].layer = 100
	front.object[@OBJ_MODE_RATE].child[0].child[1].set_pos(65, $y)
	front.object[@OBJ_MODE_RATE].child[0].child[1].patno = 0
	
	front.object[@OBJ_MODE_RATE].child[0].child[2].init
	front.object[@OBJ_MODE_RATE].child[0].child[2].create("sys_ex_rate_num", 1)
	front.object[@OBJ_MODE_RATE].child[0].child[2].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[0].child[2].layer = 100
	front.object[@OBJ_MODE_RATE].child[0].child[2].set_pos(88, $y)
	front.object[@OBJ_MODE_RATE].child[0].child[2].patno = 0
	
	property $cgm_per
	$cgm_per = $get_cg_collection_rate()
	// 桁数によって処理を変える
	if(0 <= $cgm_per && $cgm_per < 10) {
		front.object[@OBJ_MODE_RATE].child[0].child[0].disp = 0
		front.object[@OBJ_MODE_RATE].child[0].child[1].disp = 0
		front.object[@OBJ_MODE_RATE].child[0].child[2].set_pos(71, $y)
		front.object[@OBJ_MODE_RATE].child[0].child[2].patno = $cgm_per % 10
	}
	elseif(10 <= $cgm_per && $cgm_per < 100) {
		front.object[@OBJ_MODE_RATE].child[0].child[0].disp = 0
		front.object[@OBJ_MODE_RATE].child[0].child[1].set_pos(59, $y)
		front.object[@OBJ_MODE_RATE].child[0].child[2].set_pos(84, $y)
		front.object[@OBJ_MODE_RATE].child[0].child[1].patno = $cgm_per / 10
		front.object[@OBJ_MODE_RATE].child[0].child[2].patno = $cgm_per % 10
	}
	elseif(100 <= $cgm_per) {
		// 初期化で処理済み
	}
	
	
	
	
	// =======================================
	// 実績モード
	// 背景
	front.object[@OBJ_MODE_RATE].child[1].init
	front.object[@OBJ_MODE_RATE].child[1].create("sys_ex_rate_bg01")
	front.object[@OBJ_MODE_RATE].child[1].disp = 0		// デフォルトCGモードなので非表示
	front.object[@OBJ_MODE_RATE].child[1].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[1].layer = 100
	
	// パーセンテージ
	front.object[@OBJ_MODE_RATE].child[1].child.resize(3)	// 達成率の数字用
	
	front.object[@OBJ_MODE_RATE].child[1].child[0].init
	front.object[@OBJ_MODE_RATE].child[1].child[0].create("sys_ex_rate_num", 1)
	front.object[@OBJ_MODE_RATE].child[1].child[0].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[1].child[0].layer = 100
	front.object[@OBJ_MODE_RATE].child[1].child[0].set_pos(42, $y)
	front.object[@OBJ_MODE_RATE].child[1].child[0].patno = 1
	
	front.object[@OBJ_MODE_RATE].child[1].child[1].init
	front.object[@OBJ_MODE_RATE].child[1].child[1].create("sys_ex_rate_num", 1)
	front.object[@OBJ_MODE_RATE].child[1].child[1].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[1].child[1].layer = 100
	front.object[@OBJ_MODE_RATE].child[1].child[1].set_pos(65, $y)
	front.object[@OBJ_MODE_RATE].child[1].child[1].patno = 0
	
	front.object[@OBJ_MODE_RATE].child[1].child[2].init
	front.object[@OBJ_MODE_RATE].child[1].child[2].create("sys_ex_rate_num", 1)
	front.object[@OBJ_MODE_RATE].child[1].child[2].wipe_copy = 1
	front.object[@OBJ_MODE_RATE].child[1].child[2].layer = 100
	front.object[@OBJ_MODE_RATE].child[1].child[2].set_pos(88, $y)
	front.object[@OBJ_MODE_RATE].child[1].child[2].patno = 0
	
	property $achievement_per
	$achievement_per = $get_achievement_collection_rate()
	// 桁数によって処理を変える
	if(0 <= $achievement_per && $achievement_per < 10) {
		front.object[@OBJ_MODE_RATE].child[1].child[0].disp = 0
		front.object[@OBJ_MODE_RATE].child[1].child[1].disp = 0
		front.object[@OBJ_MODE_RATE].child[1].child[2].set_pos(71, $y)
		front.object[@OBJ_MODE_RATE].child[1].child[2].patno = $achievement_per % 10
	}
	elseif(10 <= $achievement_per && $achievement_per < 100) {
		front.object[@OBJ_MODE_RATE].child[1].child[0].disp = 0
		front.object[@OBJ_MODE_RATE].child[1].child[1].set_pos(59, $y)
		front.object[@OBJ_MODE_RATE].child[1].child[2].set_pos(84, $y)
		front.object[@OBJ_MODE_RATE].child[1].child[1].patno = $achievement_per / 10
		front.object[@OBJ_MODE_RATE].child[1].child[2].patno = $achievement_per % 10
	}
	elseif(100 <= $achievement_per) {
		// 初期化で処理済み
	}
	
	
	
	
}

// ============================================================
// 後始末系処理
// ============================================================
// 後始末
command $finalize_extra_mode() {
	
	// オブジェクトを消す等の処理
	
	front.object[@OBJ_TAB_BUTTONS].wipe_copy = 0
	front.object[@OBJ_TITLE_BUTTON].wipe_copy = 0
	front.object[@OBJ_TOP_BG].wipe_copy = 0
	front.object[@OBJ_MODE_EXPLAIN].wipe_copy = 0
	front.object[@OBJ_MODE_RATE].wipe_copy = 0
	front.object[@OBJ_MUSIC_PLAYER_ROOT].wipe_copy = 0
	front.object[@OBJ_CGM_ROOT].wipe_copy = 0
	front.object[@OBJ_MSM_ROOT].wipe_copy = 0
	front.object[@OBJ_ACM_ROOT].wipe_copy = 0
	
	frame_action_ch[13].end
	frame_action_ch[14].end
	
	bgm.stop(1000)
	wipe(0,1500)
	bgm.wait_fade_key
	
	
	
	
	@IS_EXIT_GAME_IN_EXTRA=0
	// システム音量を元に戻す
	syscom.set_all_volume($system_all_volume)
	syscom.set_bgm_volume($system_bgm_volume)
	
	// BGMオンオフ状態を元に戻す
	syscom.set_bgm_onoff($system_bgm_onoff)
	
	
	// syscom系とかの処理
	script.set_msg_back_enable		// メッセージバックオン
	syscom.set_syscom_menu_enable	// システムコマンドの禁止を解除する
	
	
}

// 終了
command $exit_extra_mode() {
	$main_loop = 0
}





// ============================================================
// 音楽プレーヤ系処理
// ============================================================
// プレイリストの作成
command $create_playlist() {
	
	$ml_idx_playlist.init
	
	// シャッフルON
	if($is_shuffle_on) {
		for(l[0] = 0, l[0] < $ml_is_playlist.get_size, l[0] += 1) {
			// プレイリスト対象なら
			if($ml_is_playlist[l[0]] == 1) {
				// プレイリストに追加していく
				$push_ml_idx_playlist(l[0])
			}
		}
		// ↑シャッフルOFFと同じ処理
		// ここでシャッフル
		$shuffle_ml_idx_playlist()
	}
	// シャッフルOFF
	else {
		for(l[0] = 0, l[0] < $ml_is_playlist.get_size, l[0] += 1) {
			// プレイリスト対象なら
			if($ml_is_playlist[l[0]] == 1) {
				// プレイリストに追加していく
				$push_ml_idx_playlist(l[0])
			}
		}
	}
	/*
	for(l[0] = 0, l[0] < $ml_idx_playlist.get_size, l[0] += 1) {
		k[0] += math.tostr($ml_idx_playlist[l[0]]) + ","
	}@debug(k[0])
	*/
	
	// プレイリストインデックスを更新
	$current_playlist_idx = $get_playlist_idx_from_play_target_ml_idx()
}

// プレイリストの末尾にプッシュしていく
command $push_ml_idx_playlist(property $ml_idx) {
	// リサイズ
	l[0] = $ml_idx_playlist.get_size
	$ml_idx_playlist.resize(l[0] + 1)
	$ml_idx_playlist[l[0]] = $ml_idx
}

// プレイリストのシャッフル
command $shuffle_ml_idx_playlist() {
	property $rand_idx
	property $temp
	//property $tempstr:str
	//for(l[0] = 0, l[0] < $ml_idx_playlist.get_size, l[0] += 1) {$tempstr+=math.tostr($ml_idx_playlist[l[0]]) + ","}
	for(l[0] = 0, l[0] < $ml_idx_playlist.get_size, l[0] += 1) {
		$rand_idx = math.rand(0, $ml_idx_playlist.get_size - 1)
		$temp = $ml_idx_playlist[l[0]]
		$ml_idx_playlist[l[0]] = $ml_idx_playlist[$rand_idx]
		$ml_idx_playlist[$rand_idx] = $temp
	}
	//$tempstr+="::::::::::"
	//for(l[0] = 0, l[0] < $ml_idx_playlist.get_size, l[0] += 1) {$tempstr+=math.tostr($ml_idx_playlist[l[0]]) + ","}
	//@debug($tempstr)
}

// プレイリストの前のml_idxを取得
command $get_ml_idx_playlist_prev() {
	// プレイリストが1曲以下の状態でやっても意味がない
	if($ml_idx_playlist.get_size <= 1) {
		// そのまま今の曲を返す
		return($play_target_ml_idx)
	}
	
	
	// シャッフルON
	if($is_shuffle_on) {
		// 現在のプレイリストインデックスが0の場合（前に戻れない場合）
		if($current_playlist_idx == 0) {
			// プレイリスト再生成
			$create_playlist()
			// 末尾へ
			//$current_playlist_idx = $ml_idx_playlist.get_size - 1
			// プレイリスト全部シャッフルされていて末尾でも先頭でもほぼ同じなので先頭へ
			// 末尾だと次の曲へ進んだ時にまたシャッフルかかるので微妙
			$current_playlist_idx = 0
		}
		else {
			// 一つ前へ
			$current_playlist_idx = $current_playlist_idx - 1
		}
	}
	// シャッフルOFF
	else {
		// 現在のプレイリストインデックスが0の場合（前に戻れない場合）
		if($current_playlist_idx == 0) {
			// 末尾へ
			$current_playlist_idx = $ml_idx_playlist.get_size - 1
		}
		else {
			// 一つ前へ
			//$current_playlist_idx = $current_playlist_idx - 1
			
			// 自分自身の1曲前から先頭に向かって走査する
			//for(l[0] = $play_target_ml_idx - 1, l[0] > 0, l[0]-=1) {
			for(l[0] = $play_target_ml_idx - 1, l[0] >= 0, l[0]-=1) {
				// 再生可能な物があれば
				if($ml_is_playlist[l[0]] == 1) {
					// 再生可能な物は先頭から何番目か調べる（つまりplaylist_idxはいくつか）
					l[2] = 0	// 何番目かカウント
					for(l[1] = 0, l[1] < $ml_is_playlist.get_size, l[1]+=1) {
						// 一致したらカウント値が次の再生曲としてbreak
						if(l[0] == l[1]) {
							$current_playlist_idx = l[2]
							break
						}
						
						// 再生可能ならカウントする
						if($ml_is_playlist[l[1]] == 1) {
							l[2]+=1
						}
					}
					break
				}
			}
			
		}
	}
	
	return($ml_idx_playlist[$current_playlist_idx])
}
// プレイリストの次のml_idxを取得
command $get_ml_idx_playlist_next() {
	// プレイリストが1曲以下の状態でやっても意味がない
	if($ml_idx_playlist.get_size <= 1) {
		// そのまま今の曲を返す
		return($play_target_ml_idx)
	}
	
	
	// シャッフルON
	if($is_shuffle_on) {
		// 現在のプレイリストインデックスが末尾の場合（次へ進めない場合）
		if($current_playlist_idx == $ml_idx_playlist.get_size - 1) {
			// プレイリスト再生成
			$create_playlist()
			// 先頭へ
			$current_playlist_idx = 0
		}
		else {
			// 一つ次へ
			$current_playlist_idx = $current_playlist_idx + 1
		}
	}
	// シャッフルOFF
	else {
		// 現在のプレイリストインデックスが末尾の場合（次へ進めない場合）
		if($current_playlist_idx == $ml_idx_playlist.get_size - 1) {
			// 先頭へ
			$current_playlist_idx = 0
		}
		else {
			// 一つ次へ
			//$current_playlist_idx = $current_playlist_idx + 1
			
			l[3] = 0	// 再生可能なものが見つかったかフラグ
			// 自分自身の1曲次から末尾に向かって走査する
			for(l[0] = $play_target_ml_idx + 1, l[0] < $ml_is_playlist.get_size, l[0]+=1) {
				// 再生可能な物があれば
				if($ml_is_playlist[l[0]] == 1) {
					l[3]=1
					// 再生可能な物は先頭から何番目か調べる（つまりplaylist_idxはいくつか）
					l[2] = 0	// 何番目かカウント
					for(l[1] = 0, l[1] < $ml_is_playlist.get_size, l[1]+=1) {
						// 一致したらカウント値が次の再生曲としてbreak
						if(l[0] == l[1]) {
							$current_playlist_idx = l[2]
							break
						}
						
						// 再生可能ならカウントする
						if($ml_is_playlist[l[1]] == 1) {
							l[2]+=1
						}
					}
					break
				}
			}
			// 再生可能なものがみつからなかった
			if(l[3] == 0) {
				$current_playlist_idx = 0 // 仕方ないので先頭へ
			}
			
		}
	}
	
	return($ml_idx_playlist[$current_playlist_idx])
}

// 引数からプレイリストのインデックスを取得
command $get_playlist_idx_from_arg_ml_idx(property $arg_ml_idx) : int {
	// プレイリストを先頭から回す
	for(l[0] = 0, l[0] < $ml_idx_playlist.get_size, l[0] += 1) {
		// ターゲットとプレイリストのインデックスが一致した場合
		if($arg_ml_idx == $ml_idx_playlist[l[0]]) {
			return(l[0])
		}
	}
	//@debug(プレイリストで見つからない。どうしよう)
	return(-1)
}

// play_target_ml_idxからプレイリストのインデックスを取得
command $get_playlist_idx_from_play_target_ml_idx() : int {
	return($get_playlist_idx_from_arg_ml_idx($play_target_ml_idx))
}


// 解放済みのml_idxかどうか
command $is_opend_ml_idx(property $ml_idx) {
	if(bgmtable.get_listen_by_name($ml_reg_name[$ml_idx]) == 1) {
		return(1)
	}
	return(0)
}

// Gameexe.iniの登録名からml_idxを取得、見つからなければ-1
command $get_ml_idx_by_reg_name(property $gameexe_ini_reg_name : str) : int {
	property $return_val
	$return_val = -1
	
	for(l[0] = 0, l[0] < $ml_reg_name.get_size, l[0] += 1) {
		if($gameexe_ini_reg_name == $ml_reg_name[l[0]]) {
			return(l[0])
		}
	}
	
	return($return_val)
}




// 停止
command $stop_music_player() {
	
	// 再生中、ポーズ中の場合
	if($current_player_state == @PLAYER_STATE_PLAY || $current_player_state == @PLAYER_STATE_PAUSE) {
		// フェード有りで止める
		bgm.stop(1000)
		
		$pause_samples = @SAMPLES_INIT_VAL
		frame_action_ch[13].counter.stop
		
		$current_player_state = @PLAYER_STATE_STOP
	}
}

// 一時停止
command $pause_music_player() {
	
	// 再生中の場合
	if($current_player_state == @PLAYER_STATE_PLAY) {
		
		$pause_samples = bgm.get_play_pos
		
		// フェードなしで止める
		bgm.stop
		
		// 止めるだけでカウントはそのまま
		frame_action_ch[13].counter.stop
		
		/*
		// 曲が止まっている時にbgm.get_play_posやると0が返ってくる？ので
		if($pause_samples == @SAMPLES_INIT_VAL) {
			$pause_samples = bgm.get_play_pos
			frame_action_ch[13].counter.stop	// 止めるだけでカウントはそのまま
		}
		*/
		
		$current_player_state = @PLAYER_STATE_PAUSE
	}
	// ポーズ中の場合
	elseif($current_player_state == @PLAYER_STATE_PAUSE) {
		// 再生を再開する
		$play_music_player(0)
	}
	// 停止中の処理は不要
	
}

// 前
command $prev_music_player() {
	$play_target_ml_idx = $get_ml_idx_playlist_prev()
	$play_music_player(1)
}

// 次
command $next_music_player() {
	$play_target_ml_idx = $get_ml_idx_playlist_next()
	$play_music_player(1)
}

// 再生
command $play_music_player(property $force_change) {
	
	// 強制的に曲を変更する場合
	if($force_change == 1) {
		// 念の為に今再生中のものがあれば止める
		bgm.stop
		
		// 最初から再生する
		bgm.play($ml_reg_name_for_play[$play_target_ml_idx], start_pos=0, loop=0)
		// カウントも最初から？エンドアクション呼ばれてしまって次の曲へ進む場合はなにか考えないといけない
		frame_action_ch[13].start_real($ml_play_time[$play_target_ml_idx], "$frame_action_on_bgm_play")
		
		// 再生されたのでポーズ時のサンプル値は初期化
		$pause_samples = @SAMPLES_INIT_VAL
		
		// 曲タイトルリストのパターン番号を更新
		$update_music_tile_list_patno()
		
		// プレーヤ情報更新
		$create_music_player_title_and_info(0)
		
		// 再生状態に
		$current_player_state = @PLAYER_STATE_PLAY
		
		// 以下の処理は行わない
		return
	}
	
	// 再生中の場合
	if($current_player_state == @PLAYER_STATE_PLAY) {
		// 何もしない
	}
	// ポーズ中の場合
	elseif($current_player_state == @PLAYER_STATE_PAUSE) {
		// 念の為に今再生中のものがあれば止める
		bgm.stop
		
		// 途中から再生する
		bgm.play($ml_reg_name_for_play[$play_target_ml_idx], start_pos=$pause_samples, loop=0)
		// カウントも再開する
		frame_action_ch[13].counter.resume
		
		// 再生されたのでポーズ時のサンプル値は初期化
		$pause_samples = @SAMPLES_INIT_VAL
		
		// 再生状態に
		$current_player_state = @PLAYER_STATE_PLAY
	}
	// 停止中の場合
	elseif($current_player_state == @PLAYER_STATE_STOP) {
		// 念の為に今再生中のものがあれば止める
		bgm.stop
		
		// 最初から再生する
		bgm.play($ml_reg_name_for_play[$play_target_ml_idx], start_pos=0, loop=0)
		// カウントも最初から？エンドアクション呼ばれてしまって次の曲へ進む場合はなにか考えないといけない
		//frame_action_ch[13].start_real($ml_play_time[$play_target_ml_idx], "$frame_action_on_bgm_play")
		
		frame_action_ch[13].counter.set(0)
		frame_action_ch[13].counter.resume
		
		// 再生されたのでポーズ時のサンプル値は初期化
		$pause_samples = @SAMPLES_INIT_VAL
		
		// 再生状態に
		$current_player_state = @PLAYER_STATE_PLAY
	}
	
	/*
	// 現在再生中の場合
	if($current_player_state == @PLAYER_STATE_PLAY) {
		// 何もしない
	}
	// 再生していない場合
	else {
		// 念の為に今再生中のものがあれば止める
		bgm.stop
		// ポーズしていた場合
		if($pause_samples != @SAMPLES_INIT_VAL) {
			bgm.play($ml_reg_name[$play_target_ml_idx], start_pos=$pause_samples, loop=0)
			// カウントも再開する
			frame_action_ch[13].counter.resume
		}
		// ポーズしていなかった場合
		else {
			bgm.play($ml_reg_name[$play_target_ml_idx], start_pos=0, loop=0)
			frame_action_ch[13].start_real($ml_play_time[$play_target_ml_idx], "$frame_action_on_bgm_play")
		}
		// 再生されたのでポーズ時のサンプル値は初期化
		$pause_samples = @SAMPLES_INIT_VAL
	}
	*/
}

// BGM再生時のフレームアクション
command $frame_action_on_bgm_play(property $fa : frameaction) {
	l[0] = $fa.counter.get
	
	// エンドアクションなので$play_music_player(1)が呼ばれてフレームアクションチャンネル13番に再設定するときも通る
	// つまり曲タイトルクリックしたときに、クリック曲を再生して即次の曲を再生してしまう
	// エンドアクションの回避（次の曲を登録しない）は不可能なので、各種条件づけを行い、切り替え予約を行うタイミングを限定する
	// 次の曲へボタンは「ボタンから予約=1 → 予約==1なので$play_music_player(1) → 次の曲再生開始 → エンドアクションから予約=1 → 予約=0」なので正しく動く
	
	// 再生時間分終了したら（エンドアクション）
	if(l[0] == $ml_play_time[$play_target_ml_idx]) {
		// 次以外への切り替え予約を行っていなければ
		//if($reserve_direct_change_music_ml_idx == -1 && $reserve_prev_music == 0) {
		// 自動送り以外の切り替え予約を行っていなければ
		if($reserve_direct_change_music_ml_idx == -1 && $reserve_prev_music == 0 && $reserve_next_music == 0) {
			
			// 自動送りの時の処理
			
			// 次の曲への切り替え予約
			//$reserve_next_music = 1
			
			// オート版次の曲への切り替え予約
			$reserve_next_music_auto = 1
			
			// ここらあたりにリピートの処理
		}
		
	}
}

// プレーヤのボタンが押し続けられているかどうか
command $is_press_music_player_button() {
	property $return_val $return_val = 0
	
	// プレーヤ関連のボタンをすべてチェックする
	// 全部プッシュキープ属性にしないと検出できない
	// 再生ボタンとかがプッシュキープは気持ち悪いので別案が必要かも
	property $i
	for($i = 0, $i < front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child.get_size, $i += 1) {
		// 一つでも押されていたらbreak
		if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$i].get_button_real_state == 2) {
			$return_val = 1
			break
		}
	}
	
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[0].get_button_real_state == 2) {
		$return_val = 1
	}
	
	return($return_val)
}

// パターン番号管理用フレームアクション
command $frame_action_manage_patno(property $fa : frameaction) {
	l[0] = $fa.counter.get
	
	// ============================
	// モード説明系
	if($current_mode == @MODE_CG) {
		front.object[@OBJ_MODE_EXPLAIN].patno = 0
	}
	elseif($current_mode == @MODE_MS) {
		front.object[@OBJ_MODE_EXPLAIN].patno = 1
	}
	elseif($current_mode == @MODE_AC) {
		front.object[@OBJ_MODE_EXPLAIN].patno = 2
	}
	
	// ============================
	// 達成率系
	if($current_mode == @MODE_CG) {
		front.object[@OBJ_MODE_RATE].child[0].disp = 1
		front.object[@OBJ_MODE_RATE].child[1].disp = 0
	}
	elseif($current_mode == @MODE_MS) {
		front.object[@OBJ_MODE_RATE].child[0].disp = 0
		front.object[@OBJ_MODE_RATE].child[1].disp = 0
	}
	elseif($current_mode == @MODE_AC) {
		front.object[@OBJ_MODE_RATE].child[0].disp = 0
		front.object[@OBJ_MODE_RATE].child[1].disp = 1
	}
	
	// ============================
	// タブボタン系
	if($current_mode == @MODE_CG) {
		// CG
		front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].patno = 2
		// 音楽
		if(front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].get_button_real_state == 1) { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].patno = 1 }
		else { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].patno = 0 }
		// 実績
		if(front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].get_button_real_state == 1) { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].patno = 1 }
		else { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].patno = 0 }
	}
	elseif($current_mode == @MODE_MS) {
		// CG
		if(front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].get_button_real_state == 1) { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].patno = 1 }
		else { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].patno = 0 }
		// 音楽
		front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].patno = 2
		// 実績
		if(front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].get_button_real_state == 1) { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].patno = 1 }
		else { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].patno = 0 }
	}
	elseif($current_mode == @MODE_AC) {
		// CG
		if(front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].get_button_real_state == 1) { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].patno = 1 }
		else { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].patno = 0 }
		// 音楽
		if(front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].get_button_real_state == 1) { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].patno = 1 }
		else { front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].patno = 0 }
		// 実績
		front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].patno = 2
	}
	
	
	// ============================
	// 音楽プレーヤ系
	if($current_player_state == @PLAYER_STATE_STOP) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_STOP].patno = 1
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PAUSE].patno = 0
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PLAY].patno = 0
	}
	elseif($current_player_state == @PLAYER_STATE_PAUSE) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_STOP].patno = 0
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PAUSE].patno = 1
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PLAY].patno = 0
	}
	elseif($current_player_state == @PLAYER_STATE_PLAY) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_STOP].patno = 0
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PAUSE].patno = 0
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PLAY].patno = 1
	}
	
	//front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PREV].patno = 1
	
	if($is_repeat_on == 1) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_REPEAT].patno = 1
	}
	else {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_REPEAT].patno = 0
	}
	
	if($is_shuffle_on == 1) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_SHUFFLE].patno = 1
	}
	else {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_SHUFFLE].patno = 0
	}
	
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_PREV].patno = 0
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[@MPB_NEXT].patno = 0
	
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].patno = 0
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].patno = 0
	
	
	// あたってたら+2
	property $i
	for($i = 0, $i < front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child.get_size, $i += 1) {
		if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$i].get_button_real_state == 1) {
			if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$i].patno + 2 <= 3) {
				front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$i].patno += 2
			}
		}
		if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$i].get_button_real_state == 2) {
			front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PBR].child[$i].patno = 3
		}
	}
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].get_button_real_state == 1) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].patno += 2
	}
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].get_button_real_state == 2) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[2].patno = 3
	}
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].get_button_real_state == 1) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].patno += 2
	}
	if(front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].get_button_real_state == 2) {
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[3].patno = 3
	}
}





// ============================================================
// ボタン押された系処理
// ============================================================


// 実績スライドバーが選択されたとき(正確には離された)に呼ばれる処理
command $on_select_achievement_slide_bar() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].init
	front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].start
}

// CGスライドバーが選択されたとき(正確には離された)に呼ばれる処理
command $on_select_cg_slide_bar() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].init
	front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].start
}

// タイトルボタンが選択されたときに呼ばれる処理
command $on_select_title_button() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_TITLE_BUTTON].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	// おまけモードを終了させる
	$exit_extra_mode()
}

// タブボタンが選択されたときに呼ばれる処理
command $on_select_tab_buttons() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	// モード切り替え
	$change_extra_mode(l[0])
	
	front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].init
	front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].start
}

// 曲タイトルボタン
command $on_select_music_title_buttons() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	property $ml_idx
	$ml_idx = l[0]
	
	// 曲タイトルをクリックした場合は強制的にプレイリストへ追加
	if(1==1) {
		// チェックが入っていない場合のみ処理
		if($ml_is_playlist[$ml_idx] == 0) {
			$ml_is_playlist[$ml_idx] = 1
			
			$create_playlist()
			
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$ml_idx].child[0].patno = 3
		}
	}
	
	// 直接その曲を再生する
	//$play_target_ml_idx = $ml_idx
	//$play_music_player(1)
	
	// 切り替え予約する
	$reserve_direct_change_music_ml_idx = $ml_idx
	
	front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].start
}

// 曲チェックボックスボタン
command $on_select_music_check_box_buttons() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	property $ml_idx
	$ml_idx = l[0]
	
	property $is_change_check_state
	$is_change_check_state = 0
	
	property $patno
	// チェックが入っていない場合
	if($ml_is_playlist[$ml_idx] == 0) {
		$patno = 3
		$ml_is_playlist[$ml_idx] = 1
		
		$is_change_check_state = 1
	}
	// チェックが入っている場合
	elseif($ml_is_playlist[$ml_idx] == 1) {
		// 再生中の曲以外でないとチェックは外せない
		if($play_target_ml_idx != $ml_idx) {
			$patno = 0
			$ml_is_playlist[$ml_idx] = 0
			
			$is_change_check_state = 1
		}
	}
	
	// チェック状態が切り替わった場合のみ、プレイリストとオブジェクトにも反映する
	if($is_change_check_state == 1) {
		$create_playlist()
		
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$ml_idx].child[0].patno = $patno
	}
	
	front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].start
}

// 曲複数チェックボタン
command $on_select_music_multi_check_buttons() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	property $i
	property $ml_idx
	property $patno
	
	property $button_type
	$button_type = l[0]
	// ALLオン
	if($button_type == @MMB_ALL_ON) {
		for($i = 0, $i < $ml_is_playlist.get_size, $i += 1) {
			$ml_idx = $i
			// チェックが入っていない場合かつ、視聴済みの場合は処理
			if($ml_is_playlist[$ml_idx] == 0 && bgmtable.get_listen_by_name($ml_reg_name[$ml_idx]) == 1) {
				$patno = 3
				$ml_is_playlist[$ml_idx] = 1
				
				front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$ml_idx].child[0].patno = $patno
			}
		}
	}
	// ALLオフ
	elseif($button_type == @MMB_ALL_OFF) {
		for($i = 0, $i < $ml_is_playlist.get_size, $i += 1) {
			$ml_idx = $i
			// チェックが入っている場合かつ現在再生中の曲でない場合のみ処理
			if($ml_is_playlist[$ml_idx] == 1 && $play_target_ml_idx != $ml_idx) {
				$patno = 0
				$ml_is_playlist[$ml_idx] = 0
				
				front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$ml_idx].child[0].patno = $patno
			}
		}
	}
	// ガルデモオン
	// 現状の仕様はガルデモ曲をオンにするだけ、他をオフとかはやってない
	elseif($button_type == @MMB_GLDM_ON) {
		for($i = 0, $i < $ml_is_playlist.get_size, $i += 1) {
			$ml_idx = $i
			// チェックが入っていない場合かつ、ガルデモ曲かつ、視聴済みの場合のみ処理
			if($ml_is_playlist[$ml_idx] == 0 && $ml_is_gldm[$ml_idx] == @ガルデモオン && bgmtable.get_listen_by_name($ml_reg_name[$ml_idx]) == 1) {
				$patno = 3
				$ml_is_playlist[$ml_idx] = 1
				
				front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$ml_idx].child[0].patno = $patno
			}
		}
	}
	
	$create_playlist()
	
	front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].start
}

// 音楽プレーヤボタン
command $on_select_music_player_buttons() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	property $button_type
	$button_type = l[0]
	
	// 前へ
	if($button_type == @MPB_PREV) {
		// 切り替え予約
		$reserve_prev_music = 1
		//$prev_music_player()
		//$current_samples = 0
	}
	// 停止
	elseif($button_type == @MPB_STOP) {
		$stop_music_player()
		$current_samples = 0
	}
	// 一時停止
	elseif($button_type == @MPB_PAUSE) {
		$pause_music_player()
	}
	// 再生
	elseif($button_type == @MPB_PLAY) {
		$play_music_player(0)
	}
	// 次へ
	elseif($button_type == @MPB_NEXT) {
		// 切り替え予約
		$reserve_next_music = 1
		//$next_music_player()
		//$current_samples = 0
	}
	// リピート
	elseif($button_type == @MPB_REPEAT) {
		$is_repeat_on = ($is_repeat_on + 1) % 2
		//if($is_repeat_on == 1) { @debug(リピートオンになりました) }
		//else { @debug(リピートオフになりました) }
	}
	// シャッフル
	elseif($button_type == @MPB_SHUFFLE) {
		$is_shuffle_on = ($is_shuffle_on + 1) % 2
		$create_playlist()
		//if($is_shuffle_on == 1) { @debug(シャッフルオンになりました) }
		//else { @debug(シャッフルオフになりました) }
	}
	
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].start
}

// 音楽プレーヤボリューム系
command $on_select_music_player_volume() {
	l[0] = front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].get_decided_no
	if(l[0] == -1 || l[0] == -2) {	// キャンセルか何もされてない場合
		return
	}
	
	property $clip_right
	$clip_right = front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].src_clip_right
	
	// ボリューム+
	if(l[0] == 2) {
		$clip_right += 4
		if($clip_right > 64) {
			$clip_right = 64
		}
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].set_src_clip(1, 0, 0, $clip_right, 40)
	}
	// ボリューム-
	elseif(l[0] == 3) {
		$clip_right -= 4
		if($clip_right < 0) {
			$clip_right = 0
		}
		front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].set_src_clip(1, 0, 0, $clip_right, 40)
	}
	
	
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].init
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].start
}

// ============================================================
// フルサイズCG系の処理
// ============================================================
// CGの生成
command $create_full_cg(property $full_cg_name : str) {
	
	if($current_state != @STATE_FULL_CG) {
		//@debug(bbbbbb)
		return
	}
	
	// CGデータベースの登録名からフルCG情報を取得
	$get_full_cg_data_from_cgdb_name($full_cg_name)
	
	// データの取得
	$current_full_cg_cgdb_name = $got_cgdb_name
	$current_full_cg_cgdb_thfn = $got_cgdb_thfn
	$current_full_cg_cgdb_zfid = $got_cgdb_zfid
	$current_full_cg_cgdb_cgno = $got_cgdb_cgno
	$current_full_cg_cgdb_cgdn = $got_cgdb_cgdn
	$current_full_cg_cgdb_vol  = $got_cgdb_vol
	$current_full_cg_cgdb_narg = $got_cgdb_narg
	
	// 名前付き引数
	property $named_arg_type : str
	$named_arg_type = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_TYPE)
	
	// 差分画像かどうか
	property $is_diff
	$is_diff = 0
	
	property $x_min
	property $x_max
	property $y_min
	property $y_max
	
	
	// 通常
	if($named_arg_type == @CGDB_NARG_TYPE_DEFAULT) {
		back.object[@OBJ_FOR_FULL_CG].init
		back.object[@OBJ_FOR_FULL_CG].create($full_cg_name, 1)
		back.object[@OBJ_FOR_FULL_CG].wipe_copy = 0
		back.object[@OBJ_FOR_FULL_CG].layer = 10000
	}
	// ベースとフェイス
	elseif($named_arg_type == @CGDB_NARG_TYPE_BASE_FACE) {
		
		back.object[@OBJ_FOR_FULL_CG].init
		back.object[@OBJ_FOR_FULL_CG].disp = 1
		back.object[@OBJ_FOR_FULL_CG].layer = 10000
		back.object[@OBJ_FOR_FULL_CG].child.resize(2)
		
		// =========================================================
		// _sc_bg_com.ssの$bg_dispコマンド内の処理を引用
		// "evmh_01_"0101
		K[0] = $full_cg_name.left(8) + "base___00"	// ※AB!仕様
		K[1] = $full_cg_name.left(8) + "face"
		// evmh_01_"01"01
		K[2] = $full_cg_name.mid(8, 2)  L[2] = K[2].tonum
		// evmh_01_01"01"
		K[3] = $full_cg_name.mid(10, 2) L[3] = K[3].tonum
		// CG生成
		K[0] += math.tostr(L[2]-1)
		
		// base
		
		back.object[@OBJ_FOR_FULL_CG].child[0].create(K[0])
		back.object[@OBJ_FOR_FULL_CG].child[0].layer = 10000
		back.object[@OBJ_FOR_FULL_CG].child[0].disp = 1
//		back.object[@OBJ_FOR_FULL_CG].child[0].patno = L[2] -1
//		back.object[@OBJ_FOR_FULL_CG].child[0].wipe_copy = @On
		// face
		back.object[@OBJ_FOR_FULL_CG].child[1].create(K[1])
		back.object[@OBJ_FOR_FULL_CG].child[1].layer = 10000
		back.object[@OBJ_FOR_FULL_CG].child[1].disp = 1
		back.object[@OBJ_FOR_FULL_CG].child[1].patno = L[3] -1
//		back.object[@OBJ_FOR_FULL_CG].child[1].wipe_copy = @On
		// =========================================================
		
		
	}
	// 幅も高さもオーバー
	elseif($named_arg_type == @CGDB_NARG_TYPE_WH_OVER) {
		
		// オブジェクトが存在する（差分表示から来た）場合
		if(front.object[@OBJ_FOR_FULL_CG].exist_type == 1) {
			$is_diff = 1
		}
		
		// 差分の場合
		if($is_diff == 1) {
			l[1] = front.object[@OBJ_FOR_FULL_CG].x
			l[2] = front.object[@OBJ_FOR_FULL_CG].y
		}
		
		// 普通に読み込む
		back.object[@OBJ_FOR_FULL_CG].init
		back.object[@OBJ_FOR_FULL_CG].create($full_cg_name, 1)
		back.object[@OBJ_FOR_FULL_CG].wipe_copy = 0
		back.object[@OBJ_FOR_FULL_CG].layer = 10000
		
		// 差分ではない場合
		if($is_diff == 0) {
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].init
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].disp = 1
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].wipe_copy = 1
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].layer = 20000
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child.resize(4)
			
			$x_min = 0
			k[10] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_X_MIN)
			if(k[10] != "") { $x_min = $str_to_num(k[10]) }
			$x_max = 0
			k[10] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_X_MAX)
			if(k[10] != "") { $x_max = $str_to_num(k[10]) }
			$y_min = 0
			k[10] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_Y_MIN)
			if(k[10] != "") { $y_min = $str_to_num(k[10]) }
			$y_max = 0
			k[10] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_Y_MAX)
			if(k[10] != "") { $y_max = $str_to_num(k[10]) }
			
			// 縦スクロールする場合
			if($y_min != $y_max) {
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].init
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].create(sys_ex_player_play_button, 1)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].patno = 3
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].layer = 20000
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].tr = 255
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].tr_eve.set_real(0, 1500, 2500, 0)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].center_x = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].get_size_x / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].center_y = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].get_size_y / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].set_pos(@SCREEN_WIDTH / 2, 30)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].rotate_z = -900
				
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].init
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].create(sys_ex_player_play_button, 1)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].patno = 3
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].layer = 20000
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].tr = 255
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].tr_eve.set_real(0, 1500, 2500, 0)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].center_x = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].get_size_x / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].center_y = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].get_size_y / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].set_pos(@SCREEN_WIDTH / 2, @SCREEN_HEIGHT - 30)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].rotate_z = 900
			}
			// 横スクロールする場合
			if($x_min != $x_max) {
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].init
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].create(sys_ex_player_play_button, 1)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].patno = 3
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].layer = 20000
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].tr = 255
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].tr_eve.set_real(0, 1500, 2500, 0)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].center_x = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].get_size_x / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].center_y = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].get_size_y / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].set_pos(50, @SCREEN_HEIGHT / 2)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[2].rotate_z = 1800
				
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].init
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].create(sys_ex_player_play_button, 1)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].patno = 3
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].layer = 20000
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].tr = 255
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].tr_eve.set_real(0, 1500, 2500, 0)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].center_x = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].get_size_x / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].center_y = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].get_size_y / 2
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].set_pos(@SCREEN_WIDTH - 50, @SCREEN_HEIGHT / 2)
				back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[3].rotate_z = 0
			}
		}
		
		
		// 座標設定系の処理
		property $x_init
		k[0] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_X_INIT)
		if(k[0] != "") {
			$x_init = $str_to_num(k[0])
		}
		
		property $y_init
		k[0] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_Y_INIT)
		if(k[0] != "") {
			$y_init = $str_to_num(k[0])
		}
		
		// 座標設定
		back.object[@OBJ_FOR_FULL_CG].set_pos($x_init, $y_init)
		
		// オブジェクトが存在する（差分表示から来た）場合
		if($is_diff == 1) {
			back.object[@OBJ_FOR_FULL_CG].set_pos(l[1], l[2])
		}
		
	}
	// ハーモニクス専用
	elseif($named_arg_type == @CGDB_NARG_TYPE_HARMO) {
		
		// オブジェクトが存在する（差分表示から来た）場合
		if(front.object[@OBJ_FOR_FULL_CG].child.get_size >= 1) {		// ※子供の数を見るので注意
			$is_diff = 1
		}
		
		// 差分の場合
		if($is_diff == 1) {
			l[1] = front.object[@OBJ_FOR_FULL_CG].x
			l[2] = front.object[@OBJ_FOR_FULL_CG].y
		}
		
		// ベースとフェイスみたいな親に対して子が２つ形式
		back.object[@OBJ_FOR_FULL_CG].init
		back.object[@OBJ_FOR_FULL_CG].disp = 1
		back.object[@OBJ_FOR_FULL_CG].layer = 10000
		back.object[@OBJ_FOR_FULL_CG].child.resize(2)
		
		back.object[@OBJ_FOR_FULL_CG].child[0].create($full_cg_name, 1)
		back.object[@OBJ_FOR_FULL_CG].child[0].patno = 0
		back.object[@OBJ_FOR_FULL_CG].child[0].wipe_copy = 0
		back.object[@OBJ_FOR_FULL_CG].child[0].layer = 10000
		
		back.object[@OBJ_FOR_FULL_CG].child[1].create($full_cg_name, 1)
		back.object[@OBJ_FOR_FULL_CG].child[1].patno = 1
		back.object[@OBJ_FOR_FULL_CG].child[1].wipe_copy = 0
		back.object[@OBJ_FOR_FULL_CG].child[1].layer = 10000
		
		// 差分ではない場合
		if($is_diff == 0) {
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].init
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].disp = 1
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].wipe_copy = 1
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].layer = 20000
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child.resize(2)
			
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].init
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].create(sys_ex_player_play_button, 1)
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].patno = 3
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].layer = 20000
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].tr = 255
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].tr_eve.set_real(0, 1500, 2500, 0)
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].center_x = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].get_size_x / 2
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].center_y = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].get_size_y / 2
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].set_pos(@SCREEN_WIDTH / 2, 30)
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[0].rotate_z = -900
			
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].init
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].create(sys_ex_player_play_button, 1)
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].patno = 3
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].layer = 20000
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].tr = 255
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].tr_eve.set_real(0, 1500, 2500, 0)
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].center_x = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].get_size_x / 2
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].center_y = back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].get_size_y / 2
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].set_pos(@SCREEN_WIDTH / 2, @SCREEN_HEIGHT - 30)
			back.object[@OBJ_FOR_FULL_CG_SUPPORT].child[1].rotate_z = 900
		}
		
		// 座標設定系の処理
		property $x_init
		k[0] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_X_INIT)
		if(k[0] != "") {
			$x_init = $str_to_num(k[0])
		}
		
		property $y_init
		k[0] = $analyze_named_arg($current_full_cg_cgdb_narg, @CGDB_NARG_Y_INIT)
		if(k[0] != "") {
			$y_init = $str_to_num(k[0])
		}
		
		// 座標設定
		back.object[@OBJ_FOR_FULL_CG].set_pos($x_init, $y_init)
		
		// 差分の場合
		if($is_diff == 1) {
			back.object[@OBJ_FOR_FULL_CG].set_pos(l[1], l[2])
		}
	}
	
	
	wipe(0, 300)
	
	
	
	
	
}

// 次の差分フルCGがあるかチェックする
command $check_next_diff_full_cg(property $current_full_cg_name : str) : str {
	property $return_name : str
	$return_name = ""
	property $next_idx
	
	property $current_full_cg_idx
	for(l[0] = 0, l[0] < $cgdb_name_list_all.get_size, l[0] += 1) {
		// CGデータベースの登録名からフルCG情報を取得
		$get_full_cg_data_from_cgdb_name($cgdb_name_list_all[ l[0] ])
		
		// CG番号が同じかつCG差分番号が+1以上の場合
		if($current_full_cg_cgdb_cgno  == $got_cgdb_cgno && $current_full_cg_cgdb_cgdn + 1 <= $got_cgdb_cgdn) {
			
			// 次のCGを見ていれば
			if(Z[ $got_cgdb_zfid ] == 1) {
				// 次のCG名をわたす
				$return_name = $cgdb_name_list_all[ l[0] ]
				break
			}
		}
	}
	
	/*
	for(l[0] = 0, l[0] < $cgdb_name_list_all.get_size, l[0] += 1) {
		// 現在の表示CG名と一致した場合
		if($current_full_cg_name == $cgdb_name_list_all[ l[0] ]) {
			// 次のインデックスが差分CGであればそれを返す
			$next_idx = l[0] + 1
			
			// 次のインデックスは存在しない
			if($next_idx >= $cgdb_name_list_all.get_size) {
			}
			// 存在する場合
			else {
				// 差分CGであるかチェックする（CG番号が同じ、CG差分番号が+1以上）
				
				// CGデータベースの登録名からフルCG情報を取得
				$get_full_cg_data_from_cgdb_name($cgdb_name_list_all[$next_idx])
				
				// CG番号が同じかつCG差分番号が+1以上の場合
				if($current_full_cg_cgdb_cgno  == $got_cgdb_cgno && $current_full_cg_cgdb_cgdn + 1 <= $got_cgdb_cgdn) {
					
					// 次のCGを見ていれば
					if(Z[ $got_cgdb_zfid ] == 1) {
						// 次のCG名をわたす
						$return_name = $cgdb_name_list_all[$next_idx]
						break
					}
				}
				
			}
		}
	}
	*/
	
	return($return_name)
}
// 前の差分フルCGがあるかチェックする
command $check_prev_diff_full_cg(property $current_full_cg_name : str) : str {
	property $return_name : str
	$return_name = ""
	property $next_idx
	
	property $current_full_cg_idx
	for(l[0] = $cgdb_name_list_all.get_size - 1, l[0] > 0, l[0] -= 1) {
		// CGデータベースの登録名からフルCG情報を取得
		$get_full_cg_data_from_cgdb_name($cgdb_name_list_all[ l[0] ])
		
		// CG番号が同じかつCG差分番号が-1以下の場合
		if($current_full_cg_cgdb_cgno  == $got_cgdb_cgno && $current_full_cg_cgdb_cgdn - 1 >= $got_cgdb_cgdn) {
			
			// 次のCGを見ていれば
			if(Z[ $got_cgdb_zfid ] == 1) {
				// 次のCG名をわたす
				$return_name = $cgdb_name_list_all[ l[0] ]
				break
			}
		}
	}
	
	return($return_name)
}

// ============================================================
// CGデータベース系の処理
// ============================================================

// CGデータベースの最大アイテム数を取得
command $get_cgdb_max_item_count() {
	// 色々実装の仕方はあると思うけど定数持ちたくないので、アイテムが何個あるかで算出する
	property $count $count = 0
	while(1) {
		// アイテムが存在すればカウントアップを行う
		if(database[@DB_CG].check_item($count) == 1) {
			$count += 1
		}
		// 見つからなくなった時点でbreak
		else {
			break
		}
	}
	return($count)
}

// DBから数値を取得
command $get_db_num(property $item_no, property $column_no) : int {
	return(database[@DB_CG].get_num($item_no, $column_no))

}
// DBから文字列を取得
command $get_db_str(property $item_no, property $column_no) : str {
	return(database[@DB_CG].get_str($item_no, $column_no))
}


// 登録名リスト生成
command $create_cgdb_name_list_all() {
	// リスト初期化
	$cgdb_name_list_all.init
	
	property $list_type $list_type = 0
	
	for(l[0] = 0, l[0] < $get_cgdb_max_item_count(), l[0] += 1) {
		// アイテムが存在すれば
		if(database[@DB_CG].check_item(l[0]) == 1) {
			// リストの末尾に追加していく
			$push_strlist($list_type, $get_db_str(l[0], @CGDB_COLUMN_NAME))
		}
	}
	
}

// 登録名リスト生成(一覧表示の時のルートCG)
command $create_cgdb_name_list_main() {
	// リスト初期化
	$cgdb_name_list_main.init
	
	property $list_type $list_type = 1
	
	// 旧版：CG差分番号0のみ表示
	for(l[0] = 0, l[0] < $get_cgdb_max_item_count(), l[0] += 1) {
		// アイテムが存在すれば
		if(database[@DB_CG].check_item(l[0]) == 1) {
			// CG差分番号が0なら
			if($get_db_num(l[0], @CGDB_COLUMN_CGDN) == 0) {
				// リストの末尾に追加していく
				$push_strlist($list_type, $get_db_str(l[0], @CGDB_COLUMN_NAME))
			}
		}
	}
	
}

// CGデータベースの登録名からオールのインデックスを取得
command $get_cgdb_name_list_all_idx(property $cgdb_name : str) : int {
	for(l[0] = 0, l[0] < $cgdb_name_list_all.get_size, l[0] += 1) {
		if($cgdb_name == $cgdb_name_list_all[ l[0] ]) {
			return(l[0])
		}
	}
	return(-1)
}
// CGデータベースの登録名からメインのインデックスを取得
command $get_cgdb_name_list_main_idx(property $cgdb_name : str) : int {
	for(l[0] = 0, l[0] < $cgdb_name_list_main.get_size, l[0] += 1) {
		if($cgdb_name == $cgdb_name_list_main[ l[0] ]) {
			return(l[0])
		}
	}
	return(-1)
}
// CGデータベースの登録名からフルCG情報を取得
command $get_full_cg_data_from_cgdb_name(property $cgdb_name : str) : int {
	property $idx_all
	$idx_all = $get_cgdb_name_list_all_idx($cgdb_name)
	
	// 登録されてない名前の場合
	if($idx_all == -1) {
		return(-1)
	}
	
	// データの取得
	$got_cgdb_name = $get_db_str($idx_all, @CGDB_COLUMN_NAME)
	$got_cgdb_thfn = $get_db_str($idx_all, @CGDB_COLUMN_THFN)
	$got_cgdb_zfid = $get_db_num($idx_all, @CGDB_COLUMN_ZFID)
	$got_cgdb_cgno = $get_db_num($idx_all, @CGDB_COLUMN_CGNO)
	$got_cgdb_cgdn = $get_db_num($idx_all, @CGDB_COLUMN_CGDN)
	$got_cgdb_vol  = $get_db_num($idx_all, @CGDB_COLUMN_VOL)
	$got_cgdb_narg = $get_db_str($idx_all, @CGDB_COLUMN_NARG)
	
	// 正常終了
	return(1)
}


// 名前付き引数の解析
command $analyze_named_arg(property $named_arg : str, property $key_name : str) : str {
	property $return_str : str
	$return_str = ""	// 見つからなかった時用に定数がいいかも
	
	// セパレータ「,」を一個も含んでいない場合
	if($str_split($named_arg, ",") == -1) {
		
		// セパレータ「=」を一個も含んでいない場合
		if($str_split($named_arg, "=") == -1) {
			return($return_str)
		}
		
		k[0] = $split_result[0]		// key
		k[1] = $split_result[1]		// val
		if(k[0] == $key_name) {
			$return_str = k[1]
		}
		return($return_str)
	}
	
	// 配列のコピー
	property $i
	property $separated_str_list : strlist
	$separated_str_list.resize($split_result.get_size)
	for($i = 0, $i < $separated_str_list.get_size, $i += 1) {
		$separated_str_list[$i] = $split_result[$i]
	}
	
	for($i = 0, $i < $separated_str_list.get_size, $i += 1) {
		// セパレータは「=」
		if($str_split($separated_str_list[$i], "=") == -1) {
			return($return_str)
		}
		k[0] = $split_result[0]		// key
		k[1] = $split_result[1]		// val
		if(k[0] == $key_name) {
			$return_str = k[1]
			break
		}
	}
	
	return($return_str)
}


// CGDBへCGを登録する（★★★★★★★★★★★★★★★★グローバル★★★★★★★★★★★★★★★★）
command $$regist_cg_to_cgdb(property $full_cg_name : str) {
	// CGデータベースの最大アイテム数を取得
	l[0] = $get_cgdb_max_item_count()
	
	property $i
	property $z_flag_idx
	for($i = 0, $i < l[0], $i += 1) {
		// DBから文字列を取得し、一致した場合
		if($full_cg_name == $get_db_str($i, @CGDB_COLUMN_NAME)) {
			// Zフラグ番号を取得
			$z_flag_idx = $get_db_num($i, @CGDB_COLUMN_ZFID)
			// 一応0判定
			if(Z[$z_flag_idx] == 0) {
				// CG見たフラグを登録
				Z[$z_flag_idx] = 1
			}
		}
	}
}

// ============================================================
// strlist系処理
// ============================================================
// 末尾に追加していく
command $push_strlist(property $list_type, property $data : str) {
	if($list_type == 0) {
		l[0] = $cgdb_name_list_all.get_size
		$cgdb_name_list_all.resize(l[0] + 1)
		$cgdb_name_list_all[l[0]] = $data
	}
	elseif($list_type == 1) {
		l[0] = $cgdb_name_list_main.get_size
		$cgdb_name_list_main.resize(l[0] + 1)
		$cgdb_name_list_main[l[0]] = $data
	}
}


// ============================================================
// 文字列系の処理
// ============================================================
// 文字列の分割、$split_resultに格納される
command $str_split(property $str : str, property $separator : str) : int {
	$split_result.init
	
	property $start_idx
	$start_idx = 0
	property $search_idx
	$search_idx = $str.search($separator)
	// セパレータを全く含んでいない場合
	if($search_idx == -1) {
		// 終了
		return(-1)
	}
	
	property $insert_index
	while(1) {
		// インデックスは現在のサイズ
		$insert_index = $split_result.get_size
		// 結果格納用にリサイズ
		$split_result.resize($split_result.get_size + 1)
		
		// 結果を格納
		$split_result[$insert_index] = $str.mid_len($start_idx, $search_idx - $start_idx)
		
		// 格納した部分はいらないので切り捨て
		$search_idx += $separator.len
		$str = $str.mid_len($search_idx, $str.len - $search_idx)
		
		// インデックスの更新
		$start_idx = 0
		$search_idx = $str.search($separator)
		// セパレータを含んでいない場合
		if($search_idx == -1) {
			// インデックスは現在のサイズ
			$insert_index = $split_result.get_size
			// 結果格納用にリサイズ
			$split_result.resize($split_result.get_size + 1)
			// 結果を格納
			$split_result[$insert_index] = $str
			
			break
		}
	}
	
	// 正常終了
	return($split_result.get_size)
}


// 文字列から数値への変換
command $str_to_num(property $base_str : str) : int {
	return($base_str.tonum)
}






// ============================================================
// その他系処理
// ============================================================



// モード切り替え処理
command $change_extra_mode(property $new_mode) {
	
	if($new_mode == @MODE_CG) {
		front.object[@OBJ_CGM_ROOT].disp = 1
		front.object[@OBJ_MSM_ROOT].disp = 0
		front.object[@OBJ_ACM_ROOT].disp = 0
		//front.object[@OBJ_TAB_BUTTONS].child[@OBJC_CGB].set_button_state_select
	}
	elseif($new_mode == @MODE_MS) {
		front.object[@OBJ_CGM_ROOT].disp = 0
		front.object[@OBJ_MSM_ROOT].disp = 1
		front.object[@OBJ_ACM_ROOT].disp = 0
		//front.object[@OBJ_TAB_BUTTONS].child[@OBJC_MSB].set_button_state_select
	}
	elseif($new_mode == @MODE_AC) {
		front.object[@OBJ_CGM_ROOT].disp = 0
		front.object[@OBJ_MSM_ROOT].disp = 0
		front.object[@OBJ_ACM_ROOT].disp = 1
		//front.object[@OBJ_TAB_BUTTONS].child[@OBJC_ACB].set_button_state_select
	}
	else {
		return
	}
	$cg_mouse_acc_y = 0
	$ac_mouse_acc_y = 0
	$current_mode = $new_mode
}

// オブジェクト番号からモードによってdispフラグを取得
command $get_disp_by_mode_from_objno(property $objno) {
	// CGルートの場合
	if($objno == @OBJ_CGM_ROOT) {
		if($current_mode == @MODE_CG) { return(1) }
		else { return(0) }
	}
	// 音楽ルートの場合
	elseif($objno == @OBJ_MSM_ROOT) {
		if($current_mode == @MODE_MS) { return(1) }
		else { return(0) }
	}
	// 実績ルートの場合
	elseif($objno == @OBJ_ACM_ROOT) {
		if($current_mode == @MODE_AC) { return(1) }
		else { return(0) }
	}
}


// CG達成率の取得
command $get_cg_collection_rate() : int {
	property $total_count $total_count = 0
	property $collect_count $collect_count = 0
	property $collection_rate $collection_rate = 0
	
	// CGデータベースの最大アイテム数を取得
	l[0] = $get_cgdb_max_item_count()
	$total_count = l[0]
	
	property $i
	property $z_flag_idx
	for($i = 0, $i < l[0], $i += 1) {
		// Zフラグ番号を取得
		$z_flag_idx = $get_db_num($i, @CGDB_COLUMN_ZFID)
		// 見ていたらカウントアップ
		if(Z[$z_flag_idx] == 1) {
			$collect_count += 1
		}
	}
	$collection_rate = 100 * $collect_count / $total_count
	// 切り捨て0%回避
	if($collection_rate == 0 && $collect_count > 0) { $collection_rate = 1 }
	// 念のため100%処理
	if($total_count == $collect_count) { $collection_rate = 100 }
	
	return($collection_rate)
}

// 実績達成率の取得
command $get_achievement_collection_rate() : int {
	property $total_count $total_count = 0
	property $collect_count $collect_count = 0
	property $collection_rate $collection_rate = 0
	
	$total_count = $al_zid.get_size
	for(l[0] = 0, l[0] < $al_zid.get_size, l[0] += 1) {
		// フラグが立っていればカウント
		if(z[ $al_zid[ l[0] ] ] == 1) {
			$collect_count += 1
		}
	}
	$collection_rate = 100 * $collect_count / $total_count
	// 切り捨て0%回避
	if($collection_rate == 0 && $collect_count > 0) { $collection_rate = 1 }
	// 念のため100%処理
	if($total_count == $collect_count) { $collection_rate = 100 }
	
	return($collection_rate)
}

// オブジェクトボタングループの停止
command $end_objbtngroup() {
	
	front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].end
	front.objbtngroup[@OBJBTNGROUP_TITLE_BUTTON].end
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].end
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].end
	front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].end
	front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].end
	front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].end
	front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].end
	front.objbtngroup[@OBJBTNGROUP_CG_LIST].end
	front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].end
	
}
// オブジェクトボタングループの再始動
command $restart_objbtngroup() {
	
	front.objbtngroup[@OBJBTNGROUP_TAB_BUTTONS].start
	front.objbtngroup[@OBJBTNGROUP_TITLE_BUTTON].start
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_BUTTONS].start
	front.objbtngroup[@OBJBTNGROUP_MUSIC_PLAYER_VOLUME].start
	front.objbtngroup[@OBJBTNGROUP_MUSIC_TITLES].start
	front.objbtngroup[@OBJBTNGROUP_MUSIC_CHECK_BOXES].start
	front.objbtngroup[@OBJBTNGROUP_MUSIC_MULTI_CHECK_BUTTONS].start
	front.objbtngroup[@OBJBTNGROUP_AC_SLIDE_BAR].start
	front.objbtngroup[@OBJBTNGROUP_CG_LIST].start
	front.objbtngroup[@OBJBTNGROUP_CG_SLIDE_BAR].start
	
}

// 曲タイトルリストのパターン番号を更新
command $update_music_tile_list_patno() {
	property $i
	for($i = 0, $i < front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child.get_size, $i += 1) {
		// 再生中の物は一旦チェックオンのみにする
		if(front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].patno == 1) {
			front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].child[0].patno = 3
		}
		
		// 全て強調しない
		front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$i].patno = 0
	}
	// 再生対象の物を強調する
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$play_target_ml_idx].child[0].patno = 1
	front.object[@OBJ_MSM_ROOT].child[@OBJC_MTR].child[$play_target_ml_idx].patno = 1
}

// ボリューム値をクリップ座標に反映する
command $update_volume_clip_right_from_music_player_volume() {
	// ボリューム値をつまみの座標に反映する
	l[0] = math.linear(
		$player_bgm_volume
		, 0
		, 0
		, 255
		, 64
	)
	front.object[@OBJ_MUSIC_PLAYER_ROOT].child[@OBJC_PVR].child[1].set_src_clip(1, 0, 0, l[0], 40)
}

