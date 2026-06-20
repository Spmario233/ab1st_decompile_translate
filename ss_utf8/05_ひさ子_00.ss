;;ひさ子用の遭遇管理ＳＳ

#Z00		//ひさ子制御第１段階 Day1～Day5


switch(@ひさ子遭遇フラグ){

	case(0)		gosub #hisako_01
	case(1)		gosub #hisako_02
	case(2)		gosub #hisako_03

}

RETURN

#hisako_01	;;最速でDay2の午前
	farcall(＿ひさ子+"_01",00)
	@ひさ子遭遇フラグ=1
	RETURN

#hisako_02	;;最速でDay3の午前
	farcall(＿ひさ子+"_02",00)
	@ひさ子遭遇フラグ=2
	RETURN

#hisako_03	;;最速でDay4の午後
	farcall(＿ひさ子+"_03",00)
	@ひさ子遭遇フラグ=3
	RETURN

