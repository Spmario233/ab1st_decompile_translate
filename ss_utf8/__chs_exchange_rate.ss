//-----------------------------------------------------------------
// 日元汇率自动换算函数实现
//-----------------------------------------------------------------

//动态换算游戏内的日元金额，并显示为【XX.XX元】+上方注释【YYY日元】的形式。
//兑换汇率从jpyrate.dbs文件中读取，该文件通过外部exe文件，在每次打开游戏时从公共API更新汇率数据。
command $$yen_calc(property $yen_cost : int)
{
	property $rmb_cost : int
	property $rmb_float : int //鉴于Siglus引擎的SS脚本部分没有浮点数支持
	property $rmb_int : int //所以需要手动计算整数部分和小数部分
	$rmb_cost = $yen_cost * database[@DB_RATE].get_num(0, 1) / 100 //读取汇率，并计算人民币金额的100倍
	$rmb_int = $rmb_cost / 100 //计算整数部分
	$rmb_float = $rmb_cost % 100 //计算小数部分
	ruby(math.tostr($yen_cost) + "日元")  print(math.tostr($rmb_int) + "." + math.tostr_zero($rmb_float, 2)) "元" ruby //显示最终的金额
}

//我不知道这个z00是干什么用的，但似乎每个脚本里都必须有一个z00
#z00