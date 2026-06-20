// #SCENE_SCRIPT_ID = 1100 （スクリプトＩＤ：この行は削除したり、変更したりしないで下さい）R
#Z00

;;野田用の遭遇管理ＳＳ	//松下制御第１段階 Day1～Day6
;;「@野田と会った回数」で、野田との出会い回数を管理します。

switch(@野田と会った回数){

	case(0)		gosub #NODA_01
	case(1)		gosub #NODA_02
	case(2)		gosub #NODA_03
	case(3)		gosub #NODA_04
	case(4)		gosub #NODA_05

}

RETURN

#NODA_01	;;最速でDay2
	farcall(＿野田+"_01",00)
	@野田と会った回数=1
	RETURN

#NODA_02	;;最速でDay3の午前
	farcall(＿野田+"_02",00)
	@野田と会った回数=2
	RETURN

#NODA_03	;;最速でDay4の午前
	farcall(＿野田+"_03",00)
	@野田と会った回数=3
	RETURN

#NODA_04	;;最速でDay5の午前	■■■「@野田とのフラグがちょっと立つ=1」をＧｅｔ■■■

	farcall(＿野田+"_04",00)
	@野田と会った回数=4
	RETURN

#NODA_05	;;最速でDay6の午前
	farcall(＿野田+"_05",00)
	@野田と会った回数=5
	RETURN



;;■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#Z01		//野田制御第２段階 Day15～	「@野田と友達になる=1」「@野田と会った回数=5」が前提条件

switch(@野田と会った回数){

	case(5)		gosub #NODA_06
	case(6)		gosub #NODA_07
	case(7)		gosub #NODA_08
	case(8)		gosub #NODA_09
	case(9)		gosub #NODA_10

}

RETURN

#NODA_06	;;最速でDay15の午後
	farcall(＿野田+"_07",00)
	@野田と会った回数=6
	RETURN

#NODA_07	;;最速でDay17の午後
	farcall(＿野田+"_08",00)
	@野田と会った回数=7
	RETURN

#NODA_08	;;最速でDay19の午前
	farcall(＿野田+"_09",00)
	@野田と会った回数=8
	RETURN

#NODA_09	;;最速でDay20の午後
	farcall(＿野田+"_10",00)
	@野田と会った回数=9
	RETURN

#NODA_10	;;最速でDay22の午前
	farcall(＿野田+"_11",00)
	@野田と会った回数=10
	RETURN

return




RETURN
