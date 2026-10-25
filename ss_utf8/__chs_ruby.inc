// ---------------------------------------------------------------
// 汉化版添加的ruby式注释
// ---------------------------------------------------------------

#define @ruby没有活着的感觉 ruby("含义为“活得提心吊胆”") "没有活着的感觉" ruby
#define @ruby婚前忧郁症 ruby("Marriage Blues") "婚前忧郁症" ruby
#define @ruby性取向 ruby("取向") "想法" ruby
#define @ruby龙卷风行动_带省略号 ruby("龙卷风行动") "OPERATION…TORNADO" ruby
#define @ruby丑八怪由理 ruby("ユリブサイク") "yu ri bu sa i ku" ruby
#define @ruby级进下行 ruby("cliché") "级进下行" ruby
#define @ruby分贝 ruby("Decibal") "分贝" ruby
#define @ruby分贝_Deathbell ruby("Death bell") "分贝" ruby
#define @ruby棒球2_巨人队川相 ruby("右键查看注释") "川相" ruby //直接引用
#define @ruby棒球3_巨人队山仓 ruby("右键查看注释") "山仓" ruby //直接引用
#define @ruby棒球4_巨人队村田 ruby("右键查看注释") "村田" ruby //直接引用
#define @ruby勃起功能障碍 ruby("erectile dysfunction") "勃起功能障碍" ruby //直接引用
#define @ruby棒球封杀 ruby("force out") "封杀" ruby
#define @ruby宝永四年 ruby("公元1707年") "宝永四年" ruby
#define @ruby道路总是会人多拥挤的 ruby("どのみち混むでしょ") "道路总是会人多拥挤的" ruby

//代码部分
#macro @创建注释(@index)
	$$create_comment(@index)

#command	$$create_comment(int)

#macro @清除注释
    $$clear_comment

#command $$clear_comment

#define		@DB_COMMENT 2

// ---------------------------------------------------------------
// 右键注释编号
// ---------------------------------------------------------------
#define @格雷西家族 1
#define @ARENA 2
#define @炸猪排套餐 3
#define @冬阴功咖喱 4
#define @鳗鱼 5
#define @味噌猪排盖饭 6
#define @芝士焗饭 7
#define @法式巧克力长条泡芙 8
#define @盐味拉面 9
#define @酱油拉面 10
#define @南蛮炸鸡套餐 11
#define @卷面 12
#define @玛格丽特披萨 13
#define @火腿热狗 14
#define @炸牡蛎套餐 15
#define @台湾特产 16
#define @猪肉味噌汤配纳豆的套餐 17
#define @猪排咖喱饭 18
#define @混合烤肉套餐 19
#define @生鸡蛋拌饭 20
#define @Hurry_up 21 //Hurry up!
#define @认真来场 22
#define @快嘴约翰 23
#define @Just 24
#define @Crazy 25
#define @年糕小豆汤 26
#define @铃木 27
#define @BLT三明治 28
#define @闭上眼睛 29
#define @赤福 30
#define @如其情兮 31
#define @袭名 32
#define @黑杰克 33
#define @英式松饼 34
#define @牛排 35
#define @炖牛肉套餐 36
#define @Good 37
#define @All_Right 38 //All Right
#define @fool 39
#define @Cmon 40 //C'mon
#define @亚当斯基 41
#define @屠牛事件 42
#define @佩里来航 43
#define @炸猪排盖饭 44
#define @素乌冬面 45
#define @法式吐司 46
#define @日式炸鸡块 47
#define @塔塔酱 48
#define @三分之一 49 //1/3
#define @什锦乌冬炒面 50
#define @天妇罗盖饭 51
#define @Sad_Machine 52 //Sad Machine
#define @腌茄子 53
#define @成吉思汗烤肉 54
#define @煎饺套餐 55
#define @烤松饼 56
