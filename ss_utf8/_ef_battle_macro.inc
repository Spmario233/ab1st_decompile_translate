//-----------------------------------------------------------------------------------------------
//
//	@file		_ef_battle_macro.inc
//	@author		Kazuya Takahashi
//	@note		バトル処理
//
//-----------------------------------------------------------------------------------------------

//-----------------------------------------------------------------
// バトル関連
//-----------------------------------------------------------------
#macro	@バトル開始(@life_1P(100), @life_2P(100))
	$ef_life[0] = @life_1P
	$ef_life[1] = @life_2P
	$$battle_start

#macro	@バトル終了
	$$battle_end

#macro	@ＫＯ表示
	$$ef_combo_knockout

#macro	@１Ｐライフバー表示(@chara("ot"))
	$$create_battle_lifebar_1P(@chara)
	
#macro	@２Ｐライフバー表示(@chara("ot"))
	$$create_battle_lifebar_2P(@chara)

#macro	@バトル開始ボイス(@koe_no, @chara_no)
	$$set_battle_start_voice(@koe_no, @chara_no)
	
#macro	@バトルコンボボイス(@combo, @koe_no, @chara_no)
	$$set_battle_combo_voice(@combo, @koe_no, @chara_no)


//-----------------------------------------------------------------
// コンボ関連
//-----------------------------------------------------------------
#macro	@コンボ開始
	$ef_combo = 1
	$$combo_start

#macro	@コンボ再開
	$$combo_start

#macro	@コンボカウントアップ(@wait_time(600), @shake(1))
	@timewaitkey(@wait_time)
	$$combo_count_up
	if( @shake ) { screen.shake(0) }

#macro	@コンボ終了(@result(-1))
	$$combo_end



//-----------------------------------------------------------------
// 野田コンボ
//-----------------------------------------------------------------
#macro	@野田コンボ(@type)
	$$ef_noda_combo(@type)

#macro	@野田コンボ２(@start_face, @end_face)
	$$ef_noda_combo2(@start_face, @end_face)

#macro	@野田バトル(@type)
	$$ef_noda_battle(@type)

//-----------------------------------------------------------------
// 変数
//-----------------------------------------------------------------
#property $ef_combo						// コンボカウント
#property $ef_life : intlist[2]			// ライフポイント


//-----------------------------------------------------------------
// 関数
//-----------------------------------------------------------------
#command $$battle_start								// バトル開始
#command $$battle_end								// バトル終了

#command $$init_battle_voice						// バトルボイスの初期化
#command $$set_battle_start_voice(int, int)			// バトル開始ボイス
#command $$set_battle_combo_voice(int, int, int)	// バトルコンボボイス

#command $$combo_start								// コンボ開始
#command $$combo_count_up							// コンボカウントアップ
#command $$combo_end								// コンボ終了
#command $$create_battle_lifebar_1P(str)			// ライフバーの表示
#command $$create_battle_lifebar_2P(str)			// ライフバーの表示
#command $$recover_life_max(int)					// ライフを最大に回復する
#command $$add_life(int, int)						// ライフを加減する
#command $$update_battle_lifebar(int, int)			// ライフバーの更新
#command $$combo_knockout							// K.O.表示

#command $$ef_noda_combo(int)						// 野田コンボ
#command $$ef_noda_combo2(str, str)					// 野田コンボ２
#command $$ef_noda_battle(int)						// 野田バトル

