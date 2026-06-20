// ====================================================================
// 演出用マクロ（鈴木）
// ====================================================================



#inc_start
	
	
	
	
	
	// =====================
	// その他
	#property	$bg_stack : str
	
#inc_end

#z00




//-----------------------------------------------------------------
// 背景スタック
//-----------------------------------------------------------------
command $$bg_stack(property $is_push : int) {
	// 1はpush
	if($is_push == 1) {
		$bg_stack_push()
	}
	// それ以外はpop
	else {
		$bg_stack_pop()
	}
}
command $bg_stack_push() {
	$bg_stack = $bg_name[0]
}
command $bg_stack_pop() {
	@bg_set($bg_stack)
	$bg_stack = ""
}
command $$bg_stack_pop_name() : str {
	property $return_bg_name : str
	$return_bg_name = $bg_stack
	$bg_stack = ""
	return($return_bg_name)
}






//-----------------------------------------------------------------
// 松下のバストショット表示用
// 「@松下がスリムになった」を参照して自動でmtとmsを切り替える
//-----------------------------------------------------------------
command $$stg_macro_bsmt(property $base_str : str)
{
	property $disp_bs_str : str
	$disp_bs_str = $bsmt_facemt_common($base_str)
	@bs($disp_bs_str)
}

//-----------------------------------------------------------------
// 松下のフェイス表示用
// 「@松下がスリムになった」を参照して自動でmtとmsを切り替える
//-----------------------------------------------------------------
command $$stg_macro_facemt(property $base_str : str)
{
	property $disp_face_str : str
	$disp_face_str = $bsmt_facemt_common($base_str)
	@face($disp_face_str)
}

//-----------------------------------------------------------------
// 松下のバストショット表示用名前取得
// 「@松下がスリムになった」を参照して自動でmtとmsを切り替える
//-----------------------------------------------------------------
command $$stg_macro_bsmtn(property $base_str : str) : str
{
	return($bsmt_facemt_common($base_str))
}

//-----------------------------------------------------------------
// bsmtとfacemtの共通処理
//-----------------------------------------------------------------
command $bsmt_facemt_common(property $base_str : str) : str
{
	property $return_str : str
	$return_str = ""
	
	property $start_idx
	$start_idx = 0
	
	/// bs1,2,3とmt,ms入力済みにも対応させる
	
	
	// =========================================
	// bs系の抜き出し
	// =========================================
	// bs1のとき
	if($base_str.search("bs1_") != -1) {
		$return_str += "bs1_"
		$start_idx = $base_str.search("bs1_")
	}
	// bs2のとき
	elseif($base_str.search("bs2_") != -1) {
		$return_str += "bs2_"
		$start_idx = $base_str.search("bs2_")
	}
	// bs3のとき
	elseif($base_str.search("bs3_") != -1) {
		$return_str += "bs3_"
		$start_idx = $base_str.search("bs3_")
	}
	// bsの文字列が含まれていないとき
	else {
		
	}
	
	// =========================================
	// mt,ms系の抜き出し
	// =========================================
	// mtのとき
	if($base_str.search("mt") != -1) {
		$start_idx = $base_str.search("mt") + 2
	}
	// msのとき
	elseif($base_str.search("ms") != -1) {
		$start_idx = $base_str.search("ms") + 2
	}
	
	// =========================================
	// 数値部分の抜き出し(xxxx_xx)
	// =========================================
	
	if(@松下がスリムになった==1) {
		$return_str = $return_str + "ms" + $base_str.mid($start_idx)
	}
	elseif(@松下がスリムになった==0) {
		$return_str = $return_str + "mt" + $base_str.mid($start_idx)
	}
	
	return($return_str)
}










