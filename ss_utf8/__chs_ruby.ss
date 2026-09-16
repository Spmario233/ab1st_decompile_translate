// ---------------------------------------------------------------
// 汉化版在右键快捷菜单中添加的注释
// ---------------------------------------------------------------
command $$create_comment(property $index : int)
{
	@当前注释编号 = $index

	property $comment_text : str
	property $comment_ruby : str

	$comment_text = database[@DB_COMMENT].get_str($index, 0) //读取下方文字
	$comment_ruby = database[@DB_COMMENT].get_str($index, 1) //读取上方注释

	ruby($comment_ruby) print($comment_text) ruby
}

command $$clear_comment()
{
	@当前注释编号 = 0
}

#z00
