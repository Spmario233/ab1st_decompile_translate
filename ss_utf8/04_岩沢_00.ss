//岩沢管理用ＳＳ

#Z00		//岩沢制御第１段階 Day1～Day5

;;岩沢用の遭遇管理ＳＳ

switch(@岩沢遭遇フラグ){

	case(0)		gosub #iwasawa_01
	case(1)		gosub #iwasawa_02
	case(2)		gosub #iwasawa_03
	case(3)		gosub #iwasawa_04
	case(4)		gosub #iwasawa_05
	case(5)		gosub #iwasawa_06
	case(6)		gosub #iwasawa_07

}

RETURN

#iwasawa_01	;;最速でDay1
	L[00]=farcall(＿岩沢+"_01",00)
	if(L[00]==0){		//如果第一天和日向一起行动的话，不会遇到岩泽，无法触发标记
		@岩沢遭遇フラグ=1
	}
	RETURN

#iwasawa_02	;;最速でDay2の午前	※最速この日から「@岩沢の心を掴んだ話題」が加算されていく（MAX1）
	farcall(＿岩沢+"_02",00)	;;「@岩沢ＭＡＰ非表示」フラグ立つ可能性有り。
	@岩沢遭遇フラグ=2
	RETURN

#iwasawa_03	;;最速でDay2の午後	「@岩沢の心を掴んだ話題」が加算（MAX2）
	farcall(＿岩沢+"_03",00)
	@岩沢遭遇フラグ=3
	RETURN

#iwasawa_04	;;最速でDay3の午前	「@岩沢の心を掴んだ話題」が加算（MAX3）
	farcall(＿岩沢+"_04",00)
	@岩沢遭遇フラグ=4
	RETURN

#iwasawa_05	;;最速でDay4の朝（フラグ分岐先）	「@岩沢の心を掴んだ話題」が加算（MAX4）
	farcall(＿岩沢+"_05",00)
	@岩沢遭遇フラグ=5
	RETURN

#iwasawa_06	;;最速でDay4の午前	「@岩沢の心を掴んだ話題」が加算（MAX5）
	farcall(＿岩沢+"_06",00)
	@岩沢遭遇フラグ=6
	RETURN

#iwasawa_07	;;最速でDay5の午前	「@岩沢の心を掴んだ話題」が加算（MAX6）
	farcall(＿岩沢+"_07",00)
	@岩沢遭遇フラグ=7
	RETURN




return
