// ---------------------------------------------------------------
// 汉化版在右键快捷菜单中添加的注释
// ---------------------------------------------------------------
command $$create_comment(property $index : int)
{
	@当前注释编号 = $index

	switch($index){
		case(1) @ruby注释1_格雷西家族
		case(2) @ruby注释2_ARENA
	}
}

command $$clear_comment()
{
	@当前注释编号 = 0
}

#z00
