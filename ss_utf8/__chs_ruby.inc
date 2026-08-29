// ---------------------------------------------------------------
// 汉化版添加的ruby式注释
// ---------------------------------------------------------------
//名词解释部分
#define @ruby死后世界战线 ruby("死后世界战线") "SSS" ruby
#define @ruby没有活着的感觉 ruby("含义为“活得提心吊胆”") "没有活着的感觉" ruby
#define @ruby婚前忧郁症 ruby("Marriage Blues") "婚前忧郁症" ruby
#define @ruby性取向 ruby("取向") "想法" ruby
#define @ruby龙卷风行动_带省略号 ruby("龙卷风行动") "OPERATION…TORNADO" ruby
#define @ruby丑八怪由理 ruby("ユリブサイク") "yu ri bu sa i ku" ruby
#define @ruby级进下行 ruby("cliché") "级进下行" ruby
#define @ruby分贝 ruby("Decibal") "分贝" ruby
#define @ruby分贝_Deathbell ruby("Death bell") "分贝" ruby

//引用外部注释部分
#define @ruby注释1_格雷西家族 ruby("右键查看注释") "格雷西家族" ruby //01
#define @ruby注释2_ARENA ruby("右键查看注释") "ARENA" ruby //02

//餐品注释部分
#define	@ruby餐品1_炸猪排套餐 ruby("右键查看注释") "炸猪排套餐" ruby //03
#define	@ruby餐品2_冬阴功咖喱 ruby("右键查看注释") "冬阴功咖喱" ruby //04
#define	@ruby餐品10_方盒鳗鱼饭 ruby("右键查看注释") "鳗鱼" ruby //05
#define	@ruby餐品3_味噌猪排盖饭 ruby("右键查看注释") "味噌猪排盖饭" ruby //06
#define	@ruby餐品4_焗饭 ruby("右键查看注释") "芝士焗饭" ruby //07
#define	@ruby餐品5_法式长条泡芙 ruby("右键查看注释") "法式巧克力长条泡芙" ruby //08
#define	@ruby餐品6_盐味拉面 ruby("右键查看注释") "盐味拉面" ruby //09
#define	@ruby餐品7_酱油拉面 ruby("右键查看注释") "酱油拉面" ruby //10
#define	@ruby餐品8_南蛮炸鸡套餐 ruby("右键查看注释") "南蛮炸鸡套餐" ruby //11
#define	@ruby餐品9_卷面 ruby("右键查看注释") "卷面" ruby //12
#define	@ruby餐品11_玛格丽特披萨 ruby("右键查看注释") "玛格丽特披萨" ruby //13
#define	@ruby餐品12_火腿热狗 ruby("右键查看注释") "火腿热狗" ruby //14
#define	@ruby餐品13_炸牡蛎套餐 ruby("右键查看注释") "炸牡蛎套餐" ruby //15
#define	@ruby餐品14_台湾臭豆腐 ruby("右键查看注释") "台湾特产" ruby //16
#define	@ruby餐品15_猪肉味噌汤纳豆套餐 ruby("右键查看注释") "猪肉味噌汤配纳豆的套餐" ruby //17
#define	@ruby餐品16_猪排咖喱饭 ruby("右键查看注释") "猪排咖喱饭" ruby //18
#define	@ruby餐品17_混合烤肉套餐 ruby("右键查看注释") "混合烤肉套餐" ruby //19
#define	@ruby餐品18_生鸡蛋拌饭套餐 ruby("右键查看注释") "生鸡蛋拌饭套餐" ruby //20

//歌曲注释部分
#define	@ruby歌曲1_HURRYUP ruby("右键查看注释") "Hurry up!" ruby //21
#define	@ruby歌曲2_太陽のKomachiAngel ruby("右键查看注释") "认真来场" ruby //22
#define	@ruby歌曲3_快嘴约翰 ruby("右键查看注释") "快嘴约翰" ruby //23

//代码部分
#macro @创建注释(@index)
	$$create_comment(@index)

#command	$$create_comment(int)

#macro @清除注释
    $$clear_comment

#command $$clear_comment