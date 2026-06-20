// #SCENE_SCRIPT_ID = 0100 （スクリプトＩＤ：この行は削除したり、変更したりしないで下さい）R
;;■■■■天使の授業管理用ＳＳ
;;「@授業を受けた回数」このフラグで、管理します。

#Z00

switch(@授業を受けた回数){

	case(0)		gosub #JYUGYOU_01
	case(1)		gosub #JYUGYOU_02
	case(2)		gosub #JYUGYOU_03
	case(3)		gosub #JYUGYOU_04

}

RETURN

#JYUGYOU_01	;;最速でDay1の午前－ＭＡＰ移動終了後
	farcall(＿かなで+"_01",00)
	@授業を受けた回数=1
	RETURN

#JYUGYOU_02	;;最速でDay2の午前－ＭＡＰ移動終了後
	farcall(＿かなで+"_02",00)
	@授業を受けた回数=2
	RETURN

#JYUGYOU_03	;;最速でDay3の午前－ＭＡＰ移動終了後
	farcall(＿かなで+"_03",00)
	@授業を受けた回数=3
	RETURN

#JYUGYOU_04	;;最速でDay4の午前－ＭＡＰ移動終了後
	farcall(＿かなで+"_04",00)
	@授業を受けた回数=4
	RETURN

RETURN
