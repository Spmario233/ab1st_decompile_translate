// ---------------------------------------------------------------
// 汉化版在右键快捷菜单中添加的注释
// ---------------------------------------------------------------
command $$create_comment(property $index : int)
{
	@当前注释编号 = $index

	switch($index){
		case(1) @ruby注释1_格雷西家族
		case(2) @ruby注释2_ARENA
		case(3) @ruby餐品1_炸猪排套餐
		case(4) @ruby餐品2_冬阴功咖喱
		case(5) @ruby餐品10_方盒鳗鱼饭
		case(6) @ruby餐品3_味噌猪排盖饭
		case(7) @ruby餐品4_焗饭
		case(8) @ruby餐品5_法式长条泡芙
		case(9) @ruby餐品6_盐味拉面
		case(10) @ruby餐品7_酱油拉面
		case(11) @ruby餐品8_南蛮炸鸡套餐
		case(12) @ruby餐品9_卷面
		case(13) @ruby餐品11_玛格丽特披萨
		case(14) @ruby餐品12_火腿热狗
		case(15) @ruby餐品13_炸牡蛎套餐
		case(16) @ruby餐品14_台湾臭豆腐
		case(17) @ruby餐品15_猪肉味噌汤纳豆套餐
		case(18) @ruby餐品16_猪排咖喱饭
		case(19) @ruby餐品17_混合烤肉套餐
		case(20) @ruby餐品18_生鸡蛋拌饭套餐
		case(21) @ruby歌曲1_HURRYUP
		case(22) @ruby歌曲2_太陽のKomachiAngel
		case(23) @ruby歌曲3_快嘴约翰
		case(24) @ruby歌曲4_WildHeaven
		case(25) @ruby歌曲5_CrazyForYou
	}
}

command $$clear_comment()
{
	@当前注释编号 = 0
}

#z00
