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

//代码部分
#macro @创建注释(@index)
	$$create_comment(@index)

#command	$$create_comment(int)

#macro @清除注释
    $$clear_comment

#command $$clear_comment

#define		@DB_COMMENT 2