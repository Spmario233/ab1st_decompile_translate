// ====================================================================
// 実績システム（鈴木）
// ====================================================================

// =================================================
// 変数等定義
// =================================================

// al ... achievement list
#property	$al_zid : intlist
#property	$al_rnk : intlist
#property	$al_did : intlist
#property	$al_fty : intlist
#property	$al_fid : intlist
#property	$al_mes : strlist
#property	$al_det : strlist

// 
#define @実績獲得表示する				g[1002]

// 基本設定（引数なしのとき）
#define @実績エフェクトコンフィグ準拠	0
// 良い場面とかで出したくない時
#define @実績エフェクト非表示			1
// コンフィグ無視してでも表示したいとき
#define @実績エフェクト強制表示			2


// ヒント系
#define	@実績ヒント_ロンパ大山は高松が岩沢が消えたことを目の当たりにしている	0383
#define	@実績ヒント_０１日天使の脅威納得した									0144
#define	@実績ヒント_かなでが人間だと知った										0852
#define	@実績ヒント_ロンパゆりが天使が人間だと肯定する約束した					0842
#define	@実績ヒント_天使はＡＰを使っている										0380
#define	@実績ヒント_土くれから銃を作れること知った								0260
#define	@実績ヒント_人間に生まれかわることを知った								0263

// 実績フラグチェック系
#define	@実績フラグチェック_ロンパ大山は高松が岩沢が消えたことを目の当たりにしている	0383
#define	@実績フラグチェック_０１日天使の脅威納得した									0144
#define	@実績フラグチェック_かなでが人間だと知った										0852
#define	@実績フラグチェック_ロンパゆりが天使が人間だと肯定する約束した					0842
#define	@実績フラグチェック_天使はＡＰを使っている										0380
#define	@実績フラグチェック_土くれから銃を作れること知った								0260
#define	@実績フラグチェック_人間に生まれかわることを知った								0263



// =================================================
// 実績系マクロ
// =================================================
// システム系の初期化のときに呼んで下さい
#macro @実績システム初期化
		$$initialize_achievement_system

// 今回のチェックで解放された数が戻り値
// if(@実績チェック>0)みたいな使い方で解放エフェクト入ったか確認出来る
#macro @実績チェック(@arg(@実績エフェクトコンフィグ準拠))
		$$check_achievement(@arg)

// 実績エフェクト強制終了
#macro @実績エフェクト強制終了
		$$force_close_achievement_effect


// 実績エフェクト実行中か（実行中なら1、してないなら0を返す）
#macro @実績エフェクト実行中
		$$is_effect_processing


// 実績フラグの状態チェック（取得済みなら1、してないなら0を返す）
#macro @実績フラグチェック(@arg)
		$$get_achievement_flag_val(@arg)

// =================================================
// ヒント実績系マクロ
// =================================================
#macro @実績ヒント表示(@arg, @arg2(@実績エフェクトコンフィグ準拠))
		$$display_hint_achievement(@arg, @arg2)




// =================================================
// 関数定義
// =================================================
#command $$initialize_achievement_system
#command $$check_achievement(int) : int
#command $$force_close_achievement_effect
#command $$is_effect_processing : int
#command $$get_achievement_flag_val(int) : int

#command $$display_hint_achievement(int, int)


#command $$get_achievement_list_size : int
