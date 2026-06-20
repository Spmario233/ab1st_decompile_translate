

#Z00		//松下制御第１段階 Day1～Day5

;;松下用の遭遇管理ＳＳ
;;「@松下遭遇フラグ」で、松下との出会い回数を管理します。

IF(@松下遭遇フラグ>=3 && @days == 4){	;;４日目で、松下遭遇フラグが３以上の場合、キーシーンへ
	GOSUB #MATUSITA_05
	RETURN
}

switch(@松下遭遇フラグ){

	case(0)		gosub #MATUSITA_01
	case(1)		gosub #MATUSITA_02
	case(2)		gosub #MATUSITA_03
	case(3)		gosub #MATUSITA_04
	case(4)		@DEBUG("きたらおかしい 松下５回目")	//gosub #MATUSITA_05

}

RETURN

#MATUSITA_01	;;最速でDay1
	farcall(＿松下+"_01",00)
	@松下遭遇フラグ=1
	RETURN

#MATUSITA_02	;;最速でDay2の午前
	farcall(＿松下+"_02",00)
	@松下遭遇フラグ=2
	RETURN

#MATUSITA_03	;;最速でDay2の午後
	farcall(＿松下+"_03",00)
	@松下遭遇フラグ=3
	RETURN

#MATUSITA_04	;;最速でDay3の午前
	farcall(＿松下+"_04",00)
	@松下遭遇フラグ=4
	RETURN

#MATUSITA_05	;;最速でDay4の午前	ここは松下を最低３回通った場合に来る。
	farcall(＿松下+"_05",00)
	@松下遭遇フラグ=5
	RETURN


;;■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#Z01		//松下制御第２段階 Day8～
;;ここに来る時点で、松下遭遇フラグは必ず =5 になっています。

switch(@松下遭遇フラグ){

	case(5)		gosub #MATUSITA_06
	case(6)		gosub #MATUSITA_07
	case(7)		gosub #MATUSITA_08
	case(8)		gosub #MATUSITA_09

}

RETURN

#MATUSITA_06	;;最速でDay8の午前
	farcall(＿松下+"_07",00)
	@松下遭遇フラグ=6
	RETURN

#MATUSITA_07	;;最速でDay15の午前
	farcall(＿松下+"_09",00)
	@松下遭遇フラグ=7
	RETURN

#MATUSITA_08	;;最速でDay17の午後
	farcall(＿松下+"_10",00)
	@松下遭遇フラグ=8
	RETURN

#MATUSITA_09	;;最速でDay19の午前
	farcall(＿松下+"_11",00)
	@松下遭遇フラグ=9
	RETURN

return
