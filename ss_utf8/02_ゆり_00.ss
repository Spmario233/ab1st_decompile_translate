// #SCENE_SCRIPT_ID = 0200 （スクリプトＩＤ：この行は削除したり、変更したりしないで下さい）R
;;ゆり用の遭遇管理ＳＳ

#Z00		//ゆり制御第１段階 Day1～Day5


switch(@ゆり遭遇回数){

	case(0)		gosub #yuri_01
	case(1)		gosub #yuri_02
	case(2)		gosub #yuri_03
	case(3)		gosub #yuri_04

}

RETURN

#yuri_01	;;最速でDay1の午後
	farcall(＿ゆり+"_01",00)
	@ゆり遭遇回数=1
	RETURN

#yuri_02	;;最速でDay2の午前
	farcall(＿ゆり+"_02",00)
	@ゆり遭遇回数=2
	RETURN

#yuri_03	;;最速でDay3の午前
	farcall(＿ゆり+"_03",00)
	@ゆり遭遇回数=3
	RETURN

#yuri_04	;;最速でDay4の午後
	farcall(＿ゆり+"_04",00)
	@ゆり遭遇回数=4
	RETURN

//■■■■紛らわしいので、以下をコメントアウト（あまの
//#yuri_05	;;最速でDay5の午前
//	farcall(＿ゆり+"_05",00)
//	@ゆり遭遇回数=5
//	RETURN
//
//#yuri_06	;;最速でDay6の午後
//	farcall(＿ゆり+"_06",00)
//	@ゆり遭遇回数=6
//	RETURN
//
//#yuri_07	;;最速でDay6の午後
//	farcall(＿ゆり+"_07",00)
//	@ゆり遭遇回数=7
//	RETURN




