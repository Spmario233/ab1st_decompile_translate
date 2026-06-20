
//───────────────────────────────────────
// selbtnの指定用
#replace		@selbtn_log		system.debug_write_log( "selbtn : " + get_last_sel_msg )


//───────────────────────────────────────
// selbtnの指定用
//   s = １～１３文字
//   m = １４～１７文字
//   l = １８～２４文字
//   ※後ろの数字は選択肢の数
//   デザインを変更するときはここを変えれば全部対応できるはず。たぶん
#replace		@selbtn_s_1		0
#replace		@selbtn_s_2		0
#replace		@selbtn_s_3		0
#replace		@selbtn_s_4		0
#replace		@selbtn_s_5		1
#replace		@selbtn_s_6		1
#replace		@selbtn_s_7		1
#replace		@selbtn_s_8		2
#replace		@selbtn_s_9		3
#replace		@selbtn_s_10	3

#replace		@selbtn_m_1		6
#replace		@selbtn_m_2		6
#replace		@selbtn_m_3		6
#replace		@selbtn_m_4		6
#replace		@selbtn_m_5		7
#replace		@selbtn_m_6		7
#replace		@selbtn_m_7		7
#replace		@selbtn_m_8		8
#replace		@selbtn_m_9		9
#replace		@selbtn_m_10	9

#replace		@selbtn_l_1		4
#replace		@selbtn_l_2		4
#replace		@selbtn_l_3		4
#replace		@selbtn_l_4		4
#replace		@selbtn_l_5		5
#replace		@selbtn_l_6		5
#replace		@selbtn_l_7		5

//───────────────────────────────────────
// あだ名初期化
//  あだ名系のフラグをＯＦＦにし、音無の名前を戻します。
#define			@あだ名フラグクリア
					if(@日向_呼び方==@エロエロ団総帥と呼ぶ){		//秀樹よけ
						@日向をエロエロ団総帥と呼ぶことに=0
						@日向_呼び方 = @日向と呼ぶ
					}
					@音無をエロ侍と呼ぶ=0
					@音無をエロエロ団ナンバー１と呼ぶ=0
					@音無をただのエロ少年と呼ぶ=0
					@音無をユリブサイクと呼ぶ=0
					@今あだ名である=0
					@音無を糞虫と呼ぶ=0
					@音無をゼウスと呼ぶ=0
					@音無を日向markⅡと呼ぶ=0
					@音無をアメリカンエロドッグと呼ぶ=0
					@音無を量産型日向と呼ぶ=0
					@音無をただのエロ少年と呼ぶ２=0
					@音無をただのエロ少年と呼ぶ３=0
					@音無_呼び方 = @音無と呼ぶ




//-----------------------------------------------------------------
// バストショットスクロール 高橋さんのマクロから拝借して改造しました
//-----------------------------------------------------------------
#macro	@bs_scroll_time(@bs_name, @bg_name, @time(10000), @offset_start(@pos_t), @offset_end(@pos_m), @wipe_no(3))
	close
	@bg_set_ex(@bg_name,0,0,150,150)
	$$copy_temporary_bs(back.object[@OBJ_EF_SCREEN20], @bs_name)
	@wipe(@wipe_no)
	front.object[1].y = -100
	front.object[1].y_eve.set(0, @time, 0, 0)
	front.object[@OBJ_EF_SCREEN20].y = @offset_start
	front.object[@OBJ_EF_SCREEN20].y_eve.set(@offset_end, @time, 0, 0)
	@timewaitkey(1000)



//───────────────────────────────────────
// 立ち絵マクロ
#command $bs_add( str, int )
#command $bs_del( str, str, str, str, str )

#macro		@bs_add(@name,@pos(4))
				$bs_add(@name,@pos)

#macro		@bs_del(@name1,@name2(""),@name3(""),@name4(""),@name5(""))
				$bs_del(@name1,@name2,@name3,@name4,@name5)

#macro		@bgbs(@bg_name,@bs_name1("nothing"),@bs_name2("nothing"),@bs_name3("nothing"),@bs_name4("nothing"),@bs_name5("nothing"),@bs_name6("nothing"))
				@bg_set(@bg_name)
				@bs_w(0,@bs_name1,@bs_name2,@bs_name3,@bs_name4,@bs_name5,@bs_name6)


//@bs_add(hn0106)
//  日向を左に足します（※すでにいるときは表情を変化させます）

//@bs_add(hn0106,6)
//  日向を右に足します（※すでにいるときは表情を変化させます）

//@bs_del(hn,tm)
//  日向と高松を消します　※いないときはスルーします



#command $set_noda_de_nugisuteta( int )
#command $check_noda_de_nugisuteta( int ) : int
#command $noda_de_kega( int )
#command $matusita_de_kega( int )
#command $kegasiteru_noda( int ) : int
#command $kegasiteru_matusita( int ) : int

#replace		IF(@野田で怪我した			error「野田で怪我してる」だと思います！！error
#replace		IF(@松下で怪我した			error「松下で怪我してる」だと思います！！error


//野田関係で怪我した場合を使ってください
#define		@野田で怪我した
				$noda_de_kega(@DAYS)

//松下関係で怪我した場合を使ってください
#define		@松下で怪我した
				$matusita_de_kega(@DAYS)

//今日に怪我しているかを返します
#define		@野田で怪我してる
				$kegasiteru_noda(@DAYS)

//昨日に怪我しているかを返します
#define		@昨日野田で怪我した
				$kegasiteru_noda(@DAYS-1)

//今日に怪我しているかを返します
#define		@松下で怪我してる
				$kegasiteru_matusita(@DAYS)

//昨日に怪我しているかを返します
#define		@昨日松下で怪我した
				$kegasiteru_matusita(@DAYS-1)

//今日に怪我しているかを返します
#define		@怪我してる
				($kegasiteru_noda(@DAYS)||$kegasiteru_matusita(@DAYS))

//昨日に怪我しているかを返します
#define		@昨日怪我した
				($kegasiteru_noda(@DAYS-1)||$kegasiteru_matusita(@DAYS-1))

//野田との訓練で上着を脱ぎ捨てたときに実行
#define		@野田＿上着脱ぎ捨てた
				$set_noda_de_nugisuteta(@DAYS)

//今日の訓練で脱ぎ捨てたかを返す
#define		@野田＿上着脱ぎ捨てたチェック
				$check_noda_de_nugisuteta(@DAYS)



// ---------------------------------------------------------------
// 白フィルター（加算式）
// ---------------------------------------------------------------
#macro		@AA_SC_ADD(@SWITCH, @TIME(0), @WAIT(0))
			$aa_sc_add(@SWITCH, @TIME, @WAIT, @SC_TR_NUM, @SC_LAYER_NUM, @SC_BN_LAYER00, @SC_EN_LAYER01, @SC_EN_LAYER02)

#command	$aa_sc_add(int, int, int, int, int, int, int, int)

