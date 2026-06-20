/********************************************************
*														*
*			指定エモーション／アクション取得			*
*														*
*********************************************************/
// エモーション座標代入
#property	$emo_posx_sub	: int
#property	$emo_posy_sub	: int

#macro		@emo_pos_sub(@Label, @Cha)
			farcall(_sc_emo_pos, @Label, @Cha)


