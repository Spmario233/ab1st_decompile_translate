/********************************************************
*														*
*					 セーブ／ロード						*
*														*
*********************************************************/
// -----------------------------------------------------------------------
// オブジェクト
// -----------------------------------------------------------------------
#define		@ObjSysSL00					  3
#define		_ObjSysSLBg00				  0			// 下地

#define		@ObjSysSL01					  4
#define		_ObjSysSLSBtn01				  0			// ↑
#define		_ObjSysSLSBtn02				  1			// ↓
#define		_ObjSysSLSBtn03				  2			// NEW
#define		_ObjSysSLSBtn04				  3			// Auto
#define		_ObjSysSLSBtn05				  4			// Quick
#define		_ObjSysSLSBtn06				  5			// Help
#define		_ObjSysSLSBtn07				  6			// ゲームを終了
#define		_ObjSysSLSBtn08				  7			// タイトルに戻る
#define		_ObjSysSLSBtn09				  8			// セーブ
#define		_ObjSysSLSBtn10				  9			// ロード
#define		_ObjSysSLSBtn11				 10			// コンフィグ
#define		_ObjSysSLSBtn12				 11			// ゲームに戻る
#define		_ObjSysSLInfo00				 12			// ページの説明
#define		_ObjSysSLInfoNum01			 13			// ページの説明[数値X00]
#define		_ObjSysSLInfoNum02			 14			// ページの説明[数値0X0]
#define		_ObjSysSLInfoNum03			 15			// ページの説明[数値00X]

#define		@ObjSysSL02					  5
#define		_ObjSysSLPage001			  0			// ページ001 / 021 / 041 / 061 / 081
#define		_ObjSysSLPage002			  1			// ページ002 / 022 / 042 / 062 / 082
#define		_ObjSysSLPage003			  2			// ページ003 / 023 / 043 / 063 / 083
#define		_ObjSysSLPage004			  3			// ページ004 / 024 / 044 / 064 / 084
#define		_ObjSysSLPage005			  4			// ページ005 / 025 / 045 / 065 / 085
#define		_ObjSysSLPage006			  5			// ページ006 / 026 / 046 / 066 / 086
#define		_ObjSysSLPage007			  6			// ページ007 / 027 / 047 / 067 / 087
#define		_ObjSysSLPage008			  7			// ページ008 / 028 / 048 / 068 / 088
#define		_ObjSysSLPage009			  8			// ページ009 / 029 / 049 / 069 / 089
#define		_ObjSysSLPage010			  9			// ページ010 / 030 / 050 / 070 / 090
#define		_ObjSysSLPage011			 10			// ページ011 / 031 / 051 / 071 / 091
#define		_ObjSysSLPage012			 11			// ページ012 / 032 / 052 / 072 / 092
#define		_ObjSysSLPage013			 12			// ページ013 / 033 / 053 / 073 / 093
#define		_ObjSysSLPage014			 13			// ページ014 / 034 / 054 / 074 / 094
#define		_ObjSysSLPage015			 14			// ページ015 / 035 / 055 / 075 / 095
#define		_ObjSysSLPage016			 15			// ページ016 / 036 / 056 / 076 / 096
#define		_ObjSysSLPage017			 16			// ページ017 / 037 / 057 / 077 / 097
#define		_ObjSysSLPage018			 17			// ページ018 / 038 / 058 / 078 / 098
#define		_ObjSysSLPage019			 18			// ページ019 / 039 / 059 / 079 / 099
#define		_ObjSysSLPage020			 19			// ページ020 / 040 / 060 / 080 / 100

#define		@ObjSysSL03					  6
#define		_ObjSysSLDataBg01			  0			// ボタン01
#define		_ObjSysSLDataBg02			  1			// ボタン02
#define		_ObjSysSLDataBg03			  2			// ボタン03
#define		_ObjSysSLDataBg04			  3			// ボタン04
#define		_ObjSysSLDataBg05			  4			// ボタン05
#define		_ObjSysSLDataBg06			  5			// ボタン06
#define		_ObjSysSLDataBg07			  6			// ボタン07
#define		_ObjSysSLDataBg08			  7			// ボタン08
#define		_ObjSysSLDataBg09			  8			// ボタン09
#define		_ObjSysSLDataBg10			  9			// ボタン10
#define		_ObjSysSLComBg01			 10			// コメント下地01
#define		_ObjSysSLComBg02			 11			// コメント下地02
#define		_ObjSysSLComBg03			 12			// コメント下地03
#define		_ObjSysSLComBg04			 13			// コメント下地04
#define		_ObjSysSLComBg05			 14			// コメント下地05
#define		_ObjSysSLComBg06			 15			// コメント下地06
#define		_ObjSysSLComBg07			 16			// コメント下地07
#define		_ObjSysSLComBg08			 17			// コメント下地08
#define		_ObjSysSLComBg09			 18			// コメント下地09
#define		_ObjSysSLComBg10			 19			// コメント下地10
#define		_ObjSysSLLockBtn01			 20			// ロック01
#define		_ObjSysSLLockBtn02			 21			// ロック02
#define		_ObjSysSLLockBtn03			 22			// ロック03
#define		_ObjSysSLLockBtn04			 23			// ロック04
#define		_ObjSysSLLockBtn05			 24			// ロック05
#define		_ObjSysSLLockBtn06			 25			// ロック06
#define		_ObjSysSLLockBtn07			 26			// ロック07
#define		_ObjSysSLLockBtn08			 27			// ロック08
#define		_ObjSysSLLockBtn09			 28			// ロック09
#define		_ObjSysSLLockBtn10			 29			// ロック10
#define		_ObjSysSLCngBtn01			 30			// 入れ替え01
#define		_ObjSysSLCngBtn02			 31			// 入れ替え02
#define		_ObjSysSLCngBtn03			 32			// 入れ替え03
#define		_ObjSysSLCngBtn04			 33			// 入れ替え04
#define		_ObjSysSLCngBtn05			 34			// 入れ替え05
#define		_ObjSysSLCngBtn06			 35			// 入れ替え06
#define		_ObjSysSLCngBtn07			 36			// 入れ替え07
#define		_ObjSysSLCngBtn08			 37			// 入れ替え08
#define		_ObjSysSLCngBtn09			 38			// 入れ替え09
#define		_ObjSysSLCngBtn10			 39			// 入れ替え10
#define		_ObjSysSLMark01				 40			// 巻数表示01
#define		_ObjSysSLMark02				 41			// 巻数表示02
#define		_ObjSysSLMark03				 42			// 巻数表示03
#define		_ObjSysSLMark04				 43			// 巻数表示04
#define		_ObjSysSLMark05				 44			// 巻数表示05
#define		_ObjSysSLMark06				 45			// 巻数表示06
#define		_ObjSysSLMark07				 46			// 巻数表示07
#define		_ObjSysSLMark08				 47			// 巻数表示08
#define		_ObjSysSLMark09				 48			// 巻数表示09
#define		_ObjSysSLMark10				 49			// 巻数表示10
#define		_ObjSysSLMark11				 50			// Newマーク
#define		_ObjSysSLMark12				 51			// Nextマーク
#define		_ObjSysSLMark13				 52			// 入れ替え元表示マーク
#define		_ObjSysSLDelBtn01			 53			// 削除01
#define		_ObjSysSLDelBtn02			 54			// 削除02
#define		_ObjSysSLDelBtn03			 55			// 削除03
#define		_ObjSysSLDelBtn04			 56			// 削除04
#define		_ObjSysSLDelBtn05			 57			// 削除05
#define		_ObjSysSLDelBtn06			 58			// 削除06
#define		_ObjSysSLDelBtn07			 59			// 削除07
#define		_ObjSysSLDelBtn08			 60			// 削除08
#define		_ObjSysSLDelBtn09			 61			// 削除09
#define		_ObjSysSLDelBtn10			 62			// 削除10

#define		_ObjSysSLNnm01A				 63			// セーブ番号０１Ａ
#define		_ObjSysSLNnm02A				 64			// セーブ番号０２Ａ
#define		_ObjSysSLNnm03A				 65			// セーブ番号０３Ａ
#define		_ObjSysSLNnm04A				 66			// セーブ番号０４Ａ
#define		_ObjSysSLNnm05A				 67			// セーブ番号０５Ａ
#define		_ObjSysSLNnm06A				 68			// セーブ番号０６Ａ
#define		_ObjSysSLNnm07A				 69			// セーブ番号０７Ａ
#define		_ObjSysSLNnm08A				 70			// セーブ番号０８Ａ
#define		_ObjSysSLNnm09A				 71			// セーブ番号０９Ａ
#define		_ObjSysSLNnm10A				 72			// セーブ番号１０Ａ
#define		_ObjSysSLNnm01B				 73			// セーブ番号０１Ｂ
#define		_ObjSysSLNnm02B				 74			// セーブ番号０２Ｂ
#define		_ObjSysSLNnm03B				 75			// セーブ番号０３Ｂ
#define		_ObjSysSLNnm04B				 76			// セーブ番号０４Ｂ
#define		_ObjSysSLNnm05B				 77			// セーブ番号０５Ｂ
#define		_ObjSysSLNnm06B				 78			// セーブ番号０６Ｂ
#define		_ObjSysSLNnm07B				 79			// セーブ番号０７Ｂ
#define		_ObjSysSLNnm08B				 80			// セーブ番号０８Ｂ
#define		_ObjSysSLNnm09B				 81			// セーブ番号０９Ｂ
#define		_ObjSysSLNnm10B				 82			// セーブ番号１０Ｂ
#define		_ObjSysSLNnm01C				 83			// セーブ番号０１Ｃ
#define		_ObjSysSLNnm02C				 84			// セーブ番号０２Ｃ
#define		_ObjSysSLNnm03C				 85			// セーブ番号０３Ｃ
#define		_ObjSysSLNnm04C				 86			// セーブ番号０４Ｃ
#define		_ObjSysSLNnm05C				 87			// セーブ番号０５Ｃ
#define		_ObjSysSLNnm06C				 88			// セーブ番号０６Ｃ
#define		_ObjSysSLNnm07C				 89			// セーブ番号０７Ｃ
#define		_ObjSysSLNnm08C				 90			// セーブ番号０８Ｃ
#define		_ObjSysSLNnm09C				 91			// セーブ番号０９Ｃ
#define		_ObjSysSLNnm10C				 92			// セーブ番号１０Ｃ

#define		_ObjSysSLRtime01			 93
#define		_ObjSysSLRtime02			 94
#define		_ObjSysSLRtime03			 95
#define		_ObjSysSLRtime04			 96
#define		_ObjSysSLRtime05			 97
#define		_ObjSysSLRtime06			 98
#define		_ObjSysSLRtime07			 99
#define		_ObjSysSLRtime08			100
#define		_ObjSysSLRtime09			101
#define		_ObjSysSLRtime10			102

#define		_ObjSysSLTitle01			103
#define		_ObjSysSLTitle02			104
#define		_ObjSysSLTitle03			105
#define		_ObjSysSLTitle04			106
#define		_ObjSysSLTitle05			107
#define		_ObjSysSLTitle06			108
#define		_ObjSysSLTitle07			109
#define		_ObjSysSLTitle08			110
#define		_ObjSysSLTitle09			111
#define		_ObjSysSLTitle10			112

#define		_ObjSysSLComText01			113			// コメント01
#define		_ObjSysSLComText02			114			// コメント02
#define		_ObjSysSLComText03			115			// コメント03
#define		_ObjSysSLComText04			116			// コメント04
#define		_ObjSysSLComText05			117			// コメント05
#define		_ObjSysSLComText06			118			// コメント06
#define		_ObjSysSLComText07			119			// コメント07
#define		_ObjSysSLComText08			120			// コメント08
#define		_ObjSysSLComText09			121			// コメント09
#define		_ObjSysSLComText10			122			// コメント10

#define		_ObjSysSLGameText01			123			// ゲームメッセージ01
#define		_ObjSysSLGameText02			124			// ゲームメッセージ02
#define		_ObjSysSLGameText03			125			// ゲームメッセージ03
#define		_ObjSysSLGameText04			126			// ゲームメッセージ04
#define		_ObjSysSLGameText05			127			// ゲームメッセージ05
#define		_ObjSysSLGameText06			128			// ゲームメッセージ06
#define		_ObjSysSLGameText07			129			// ゲームメッセージ07
#define		_ObjSysSLGameText08			130			// ゲームメッセージ08
#define		_ObjSysSLGameText09			131			// ゲームメッセージ09
#define		_ObjSysSLGameText10			132			// ゲームメッセージ10

#define		_ObjSysSLThumb01			133			// セーブサムネイル０１
#define		_ObjSysSLThumb02			134			// セーブサムネイル０２
#define		_ObjSysSLThumb03			135			// セーブサムネイル０３
#define		_ObjSysSLThumb04			136			// セーブサムネイル０４
#define		_ObjSysSLThumb05			137			// セーブサムネイル０５
#define		_ObjSysSLThumb06			138			// セーブサムネイル０６
#define		_ObjSysSLThumb07			139			// セーブサムネイル０７
#define		_ObjSysSLThumb08			140			// セーブサムネイル０８
#define		_ObjSysSLThumb09			141			// セーブサムネイル０９
#define		_ObjSysSLThumb10			142			// セーブサムネイル１０

#define		_ObjSysSLHelp00				150			// ヘルプ画面

#define		@ObjSysSL04					  7
#define		_ObjSysSLConfBg00			  0			// 確認メッセージ下地
#define		_ObjSysSLConfBtn01			  1			// ボタン[ＹＥＳ]
#define		_ObjSysSLConfBtn02			  2			// ボタン[ＮＯ]
#define		_ObjSysSLConfChk00			  3			// 確認ダイアログ
#define		_ObjSysSLConfFilter00		  4			// フィルター
#define		_ObjSysSLStateInfo			  5			// セーブ中／セーブしました／入れ替えしました／削除しました

// フェードアウト
#define		@ObjSysSL05					  8
#define		_ObjSysSLFade00				  0



// -----------------------------------------------------------------------
// 関連フラグ
// -----------------------------------------------------------------------
#define		@SysSLPage					$sys_slpage			// セーブ・ロードページ番号
#define		@SysSLPage_prev				$sys_slpage_prev	// セーブ・ロードページ番号ＰＲＥＶ
#define		@SysSLPage_new				$sys_slpage_new		// セーブ・ロードページＮＥＷ
#define		@SysSLFlag					$sys_slflag			// セーブ・ロード判定
#define		@SysSLDate00				$sys_sldate00		// セーブ・ロードデータ
#define		@SysSLPageTab				$sysslpage_tab		// セーブ・ロードページ番号タブ
#define		@SysSLPageTab_Prev			$sysslpage_tab_prev	// セーブ・ロードページ番号タブＰＲＥＶ
#define		@SysSLPage_state			$sys_slpage_state	// セーブ・ロードページ[通常／オート・クイック判定]
#define		@SLPage_normal				0
#define		@SLPage_auto				1
#define		@SLPage_quick				2
#property	$sys_slpage         : int
#property	$sys_slpage_prev    : int
#property	$sys_slpage_new     : int
#property	$sys_slflag         : int
#property	$sys_sldate00       : int
#property	$sysslpage_tab      : int
#property	$sysslpage_tab_prev : int
#property	$sys_slpage_state   : int

#define		@SysSLPageExist[			$sys_slpage_exist[	// 現在のページ取得
#define		@SysSLDataExist[			$sys_sldata_exist[	// 現在のページのセーブデータ取得
#property	$sys_slpage_exist :	intlist[10]
#property	$sys_sldata_exist :	intlist[10]

#property	$sys_sldata       : intlist[50]
#property	$sys_slsdata      : strlist[50]
#property	$sys_slname_bg    : strlist[30]		// 固定obj
#property	$sys_slname_btn   : strlist[100]	// 可変obj
#property	$sys_sldata_lock  : intlist[10]
#property	$sldatastate      : int
#property	$dataStateCnt     : int
#property	$stateData01      : int
#property	$stateData02      : int
#property	$sys_slpage_cng   : int
#property	$sys_slpage_cspd  : int
#property	$sys_sldata_disp  : intlist[11]
#property	$sys_sllock_state : intlist[10]
#property	$sys_sldisp_pat   : int
#property	$sys_slhelp_disp  : int

#define		@ConfirmMsg01				G[1100]				// 確認メッセージ[セーブ／ロード]
#define		@ConfirmMsg02				G[1101]				// 確認メッセージ[セーブ上書き]
#define		@ConfirmMsg03				G[1102]				// 確認メッセージ[データコピー]
#define		@ConfirmMsg04				G[1103]				// 確認メッセージ[データチェンジ]
#define		@ConfirmMsg05				G[1104]				// 確認メッセージ[データ削除]
#define		@ThumbChk					G[1105]				// サムネイル表示
#define		@ThumbChkFSet				G[1106]				// サムネイル表示初期設定
#define		@SysSLLastPage				G[1107]				// 現在開いているページを記憶
#define		@SysSLPageChange			$sys_slpage_change	// ページ切り替え判定
#property	$sys_slpage_change : int

#define		@SysSLDataLock[				G.bit[38400			// セーブデータのロック	G[1200]～
#define		@DataNormal					0					// データ通常状態
#define		@DataCopy					1					// データコピー状態
#define		@DataChange					2					// データ入れ替え状態
#define		@DataDelete					3					// データ削除状態
#define		@SLDataState				$sldatastate		// データ状態
#define		@DataStateCnt				$dataStateCnt
#define		@StateData01				$stateData01
#define		@StateData02				$stateData02
#define		@SysSLPageCng				$sys_slpage_cng
#define		@SysSLPageCSpd				$sys_slpage_cspd
#define		@SysSLDataDisp[				$sys_sldata_disp[
#define		@SysSLLockState[			$sys_sllock_state[
#define		@SysSLDsipPat				$sys_sldisp_pat
#define		@SysSLhelpDisp				$sys_slhelp_disp

#property	$sys_sldate_chk : intlist[10]
#define		@SLDateChk00[				$sys_sldate_chk[0			//
#define		@SLDateChk01				$sys_sldate_chk[0]			//
#define		@SLDateChk02				$sys_sldate_chk[1]			//
#define		@SLDateChk03				$sys_sldate_chk[2]			//
#define		@SLDateChk04				$sys_sldate_chk[3]			//
#define		@SLDateChk05				$sys_sldate_chk[4]			//
#define		@SLDateChk06				$sys_sldate_chk[5]			//
#define		@SLDateChk07				$sys_sldate_chk[6]			//
#define		@SLDateChk08				$sys_sldate_chk[7]			//
#define		@SLDateChk09				$sys_sldate_chk[8]			//
#define		@SLDateChk10				$sys_sldate_chk[9]			//

#property	$sys_sldate_year : intlist[10]
#define		@SLDateYear01				$sys_sldate_year[0]			//
#define		@SLDateYear02				$sys_sldate_year[1]			//
#define		@SLDateYear03				$sys_sldate_year[2]			//
#define		@SLDateYear04				$sys_sldate_year[3]			//
#define		@SLDateYear05				$sys_sldate_year[4]			//
#define		@SLDateYear06				$sys_sldate_year[5]			//
#define		@SLDateYear07				$sys_sldate_year[6]			//
#define		@SLDateYear08				$sys_sldate_year[7]			//
#define		@SLDateYear09				$sys_sldate_year[8]			//
#define		@SLDateYear10				$sys_sldate_year[9]			//

#property	$sys_sldate_month : intlist[10]
#define		@SLDateMonth01				$sys_sldate_month[0]		//
#define		@SLDateMonth02				$sys_sldate_month[1]		//
#define		@SLDateMonth03				$sys_sldate_month[2]		//
#define		@SLDateMonth04				$sys_sldate_month[3]		//
#define		@SLDateMonth05				$sys_sldate_month[4]		//
#define		@SLDateMonth06				$sys_sldate_month[5]		//
#define		@SLDateMonth07				$sys_sldate_month[6]		//
#define		@SLDateMonth08				$sys_sldate_month[7]		//
#define		@SLDateMonth09				$sys_sldate_month[8]		//
#define		@SLDateMonth10				$sys_sldate_month[9]		//

#property	$sys_sldate_day : intlist[10]
#define		@SLDateDay01				$sys_sldate_day[0]			//
#define		@SLDateDay02				$sys_sldate_day[1]			//
#define		@SLDateDay03				$sys_sldate_day[2]			//
#define		@SLDateDay04				$sys_sldate_day[3]			//
#define		@SLDateDay05				$sys_sldate_day[4]			//
#define		@SLDateDay06				$sys_sldate_day[5]			//
#define		@SLDateDay07				$sys_sldate_day[6]			//
#define		@SLDateDay08				$sys_sldate_day[7]			//
#define		@SLDateDay09				$sys_sldate_day[8]			//
#define		@SLDateDay10				$sys_sldate_day[9]			//

#property	$sys_sldate_week : intlist[10]
#define		@SLDateWeek01				$sys_sldate_week[0]			//
#define		@SLDateWeek02				$sys_sldate_week[1]			//
#define		@SLDateWeek03				$sys_sldate_week[2]			//
#define		@SLDateWeek04				$sys_sldate_week[3]			//
#define		@SLDateWeek05				$sys_sldate_week[4]			//
#define		@SLDateWeek06				$sys_sldate_week[5]			//
#define		@SLDateWeek07				$sys_sldate_week[6]			//
#define		@SLDateWeek08				$sys_sldate_week[7]			//
#define		@SLDateWeek09				$sys_sldate_week[8]			//
#define		@SLDateWeek10				$sys_sldate_week[9]			//

#property	$sys_sldate_hour : intlist[10]
#define		@SLDateHour01				$sys_sldate_hour[0]			//
#define		@SLDateHour02				$sys_sldate_hour[1]			//
#define		@SLDateHour03				$sys_sldate_hour[2]			//
#define		@SLDateHour04				$sys_sldate_hour[3]			//
#define		@SLDateHour05				$sys_sldate_hour[4]			//
#define		@SLDateHour06				$sys_sldate_hour[5]			//
#define		@SLDateHour07				$sys_sldate_hour[6]			//
#define		@SLDateHour08				$sys_sldate_hour[7]			//
#define		@SLDateHour09				$sys_sldate_hour[8]			//
#define		@SLDateHour10				$sys_sldate_hour[9]			//

#property	$sys_sldate_minute : intlist[10]
#define		@SLDateMinute01				$sys_sldate_minute[0]		//
#define		@SLDateMinute02				$sys_sldate_minute[1]		//
#define		@SLDateMinute03				$sys_sldate_minute[2]		//
#define		@SLDateMinute04				$sys_sldate_minute[3]		//
#define		@SLDateMinute05				$sys_sldate_minute[4]		//
#define		@SLDateMinute06				$sys_sldate_minute[5]		//
#define		@SLDateMinute07				$sys_sldate_minute[6]		//
#define		@SLDateMinute08				$sys_sldate_minute[7]		//
#define		@SLDateMinute09				$sys_sldate_minute[8]		//
#define		@SLDateMinute10				$sys_sldate_minute[9]		//

#property	$sys_sldate_second : intlist[10]
#define		@SLDateSecond01				$sys_sldate_second[0]		//
#define		@SLDateSecond02				$sys_sldate_second[1]		//
#define		@SLDateSecond03				$sys_sldate_second[2]		//
#define		@SLDateSecond04				$sys_sldate_second[3]		//
#define		@SLDateSecond05				$sys_sldate_second[4]		//
#define		@SLDateSecond06				$sys_sldate_second[5]		//
#define		@SLDateSecond07				$sys_sldate_second[6]		//
#define		@SLDateSecond08				$sys_sldate_second[7]		//
#define		@SLDateSecond09				$sys_sldate_second[8]		//
#define		@SLDateSecond10				$sys_sldate_second[9]		//

#property	$sys_sldate_millisecond : intlist[10]
#define		@SLDateMillisecond01		$sys_sldate_millisecond[0]	//
#define		@SLDateMillisecond02		$sys_sldate_millisecond[1]	//
#define		@SLDateMillisecond03		$sys_sldate_millisecond[2]	//
#define		@SLDateMillisecond04		$sys_sldate_millisecond[3]	//
#define		@SLDateMillisecond05		$sys_sldate_millisecond[4]	//
#define		@SLDateMillisecond06		$sys_sldate_millisecond[5]	//
#define		@SLDateMillisecond07		$sys_sldate_millisecond[6]	//
#define		@SLDateMillisecond08		$sys_sldate_millisecond[7]	//
#define		@SLDateMillisecond09		$sys_sldate_millisecond[8]	//
#define		@SLDateMillisecond10		$sys_sldate_millisecond[9]	//

#property	$sys_sldate_stitle : intlist[10]
#define		@SLDateSTitle01				$sys_sldate_stitle[0]		//
#define		@SLDateSTitle02				$sys_sldate_stitle[1]		//
#define		@SLDateSTitle03				$sys_sldate_stitle[2]		//
#define		@SLDateSTitle04				$sys_sldate_stitle[3]		//
#define		@SLDateSTitle05				$sys_sldate_stitle[4]		//
#define		@SLDateSTitle06				$sys_sldate_stitle[5]		//
#define		@SLDateSTitle07				$sys_sldate_stitle[6]		//
#define		@SLDateSTitle08				$sys_sldate_stitle[7]		//
#define		@SLDateSTitle09				$sys_sldate_stitle[8]		//
#define		@SLDateSTitle10				$sys_sldate_stitle[9]		//

#property	$sys_slstitle : strlist[10]
#define		@SLSTitle00[				$sys_slstitle[				//
#define		@SLSTitle01					$sys_slstitle[0]			//
#define		@SLSTitle02					$sys_slstitle[1]			//
#define		@SLSTitle03					$sys_slstitle[2]			//
#define		@SLSTitle04					$sys_slstitle[3]			//
#define		@SLSTitle05					$sys_slstitle[4]			//
#define		@SLSTitle06					$sys_slstitle[5]			//
#define		@SLSTitle07					$sys_slstitle[6]			//
#define		@SLSTitle08					$sys_slstitle[7]			//
#define		@SLSTitle09					$sys_slstitle[8]			//
#define		@SLSTitle10					$sys_slstitle[9]			//

#property	$sys_slstitleA : strlist[10]
#define		@SLSTitleA00[				$sys_slstitleA[0			//
#define		@SLSTitleA01				$sys_slstitleA[0]			//
#define		@SLSTitleA02				$sys_slstitleA[1]			//
#define		@SLSTitleA03				$sys_slstitleA[2]			//
#define		@SLSTitleA04				$sys_slstitleA[3]			//
#define		@SLSTitleA05				$sys_slstitleA[4]			//
#define		@SLSTitleA06				$sys_slstitleA[5]			//
#define		@SLSTitleA07				$sys_slstitleA[6]			//
#define		@SLSTitleA08				$sys_slstitleA[7]			//
#define		@SLSTitleA09				$sys_slstitleA[8]			//
#define		@SLSTitleA10				$sys_slstitleA[9]			//

#property	$sys_rtimedate : strlist[10]
#define		@RTimeDate00[				$sys_rtimedate[0			//
#define		@RTimeDate01				$sys_rtimedate[0]			//
#define		@RTimeDate02				$sys_rtimedate[1]			//
#define		@RTimeDate03				$sys_rtimedate[2]			//
#define		@RTimeDate04				$sys_rtimedate[3]			//
#define		@RTimeDate05				$sys_rtimedate[4]			//
#define		@RTimeDate06				$sys_rtimedate[5]			//
#define		@RTimeDate07				$sys_rtimedate[6]			//
#define		@RTimeDate08				$sys_rtimedate[7]			//
#define		@RTimeDate09				$sys_rtimedate[8]			//
#define		@RTimeDate10				$sys_rtimedate[9]			//

#property	$sys_rtimedateA : strlist[10]
#define		@RTimeDateA00[				$sys_rtimedateA[0			//
#define		@RTimeDateA01				$sys_rtimedateA[0]			//
#define		@RTimeDateA02				$sys_rtimedateA[1]			//
#define		@RTimeDateA03				$sys_rtimedateA[2]			//
#define		@RTimeDateA04				$sys_rtimedateA[3]			//
#define		@RTimeDateA05				$sys_rtimedateA[4]			//
#define		@RTimeDateA06				$sys_rtimedateA[5]			//
#define		@RTimeDateA07				$sys_rtimedateA[6]			//
#define		@RTimeDateA08				$sys_rtimedateA[7]			//
#define		@RTimeDateA09				$sys_rtimedateA[8]			//
#define		@RTimeDateA10				$sys_rtimedateA[9]			//

#property	$sys_slcomdata : strlist[10]
#define		@SLComData00[				$sys_slcomdata[0			//
#define		@SLComData01				$sys_slcomdata[0]			//
#define		@SLComData02				$sys_slcomdata[1]			//
#define		@SLComData03				$sys_slcomdata[2]			//
#define		@SLComData04				$sys_slcomdata[3]			//
#define		@SLComData05				$sys_slcomdata[4]			//
#define		@SLComData06				$sys_slcomdata[5]			//
#define		@SLComData07				$sys_slcomdata[6]			//
#define		@SLComData08				$sys_slcomdata[7]			//
#define		@SLComData09				$sys_slcomdata[8]			//
#define		@SLComData10				$sys_slcomdata[9]			//

#property	$sys_slcomdatas : strlist[10]
#define		@SLComDataS00[				$sys_slcomdatas[0			//
#define		@SLComDataS01				$sys_slcomdatas[0]			//
#define		@SLComDataS02				$sys_slcomdatas[1]			//
#define		@SLComDataS03				$sys_slcomdatas[2]			//
#define		@SLComDataS04				$sys_slcomdatas[3]			//
#define		@SLComDataS05				$sys_slcomdatas[4]			//
#define		@SLComDataS06				$sys_slcomdatas[5]			//
#define		@SLComDataS07				$sys_slcomdatas[6]			//
#define		@SLComDataS08				$sys_slcomdatas[7]			//
#define		@SLComDataS09				$sys_slcomdatas[8]			//
#define		@SLComDataS10				$sys_slcomdatas[9]			//

#property	$sys_slgametextdata : strlist[10]
#define		@SLGameTextData00[				$sys_slgametextdata[0			//
#define		@SLGameTextData01				$sys_slgametextdata[0]			//
#define		@SLGameTextData02				$sys_slgametextdata[1]			//
#define		@SLGameTextData03				$sys_slgametextdata[2]			//
#define		@SLGameTextData04				$sys_slgametextdata[3]			//
#define		@SLGameTextData05				$sys_slgametextdata[4]			//
#define		@SLGameTextData06				$sys_slgametextdata[5]			//
#define		@SLGameTextData07				$sys_slgametextdata[6]			//
#define		@SLGameTextData08				$sys_slgametextdata[7]			//
#define		@SLGameTextData09				$sys_slgametextdata[8]			//
#define		@SLGameTextData10				$sys_slgametextdata[9]			//

// セーブデータ取得
#macro		@GetSaveDate(@SLDateNo, @SLNo)
			$sys_sldate_chk[@SLDateNo]         = syscom.get_save_exist(@SLNo)
			$sys_sldate_year[@SLDateNo]        = syscom.get_save_year(@SLNo)
			$sys_sldate_month[@SLDateNo]       = syscom.get_save_month(@SLNo)
			$sys_sldate_day[@SLDateNo]         = syscom.get_save_day(@SLNo)
			$sys_sldate_week[@SLDateNo]        = syscom.get_save_weekday(@SLNo)
			$sys_sldate_hour[@SLDateNo]        = syscom.get_save_hour(@SLNo)
			$sys_sldate_minute[@SLDateNo]      = syscom.get_save_minute(@SLNo)
			$sys_sldate_second[@SLDateNo]      = syscom.get_save_second(@SLNo)
			$sys_sldate_millisecond[@SLDateNo] = syscom.get_save_millisecond(@SLNo)
			$sys_slgametextdata[@SLDateNo]     = syscom.get_save_message(@SLNo)
			$sys_slstitle[@SLDateNo]           = syscom.get_save_title(@SLNo)
			$sys_slstitleA[@SLDateNo]          = $sys_slstitle[@SLDateNo]
			$sys_slstitle[@SLDateNo]           = $sys_slstitle[@SLDateNo].left(10)
			$sys_slstitleA[@SLDateNo]          = $sys_slstitleA[@SLDateNo].left_len(26)			// AB! 1stで使用
			$sys_slgametextdata[@SLDateNo]     = $sys_slgametextdata[@SLDateNo].left_len(34)	// AB! 1stで使用

// リアル時間構築
#macro		@RenewalRTime(@RTimeDate, @SLNo)
			$sys_rtimedate[@RTimeDate]  = ""
			$sys_rtimedateA[@RTimeDate] = ""		// AB! 1stで使用
			K[0] = math.tostr($sys_sldate_year[@RTimeDate])
			K[1] = math.tostr_zero($sys_sldate_month[@RTimeDate], 2)
			K[2] = math.tostr_zero($sys_sldate_day[@RTimeDate], 2)
			K[3] = math.tostr_zero($sys_sldate_hour[@RTimeDate], 2)
			K[4] = math.tostr_zero($sys_sldate_minute[@RTimeDate], 2)
			K[5] = "("
			K[6] = ")"
			K[7] = "/"
			K[8] = " "
			K[9] = ":"								// ■例
//			$sys_rtimedateA[@RTimeDate] += K[5]		// (
			$sys_rtimedateA[@RTimeDate] += K[0]		// (2011
			$sys_rtimedateA[@RTimeDate] += K[7]		// (2011.
			$sys_rtimedateA[@RTimeDate] += K[1]		// (2011. 07.
			$sys_rtimedateA[@RTimeDate] += K[7]		// (2011. 07. 
			$sys_rtimedateA[@RTimeDate] += K[2]		// (2011. 07. 25
			$sys_rtimedate[@RTimeDate]  += $sys_rtimedateA[@RTimeDate] + K[6]
			$sys_rtimedateA[@RTimeDate] += K[8]		// (2011. 07. 25 
			$sys_rtimedateA[@RTimeDate] += K[3]		// (2011. 07. 25 17
			$sys_rtimedateA[@RTimeDate] += K[9]		// (2011. 07. 25 17:
			$sys_rtimedateA[@RTimeDate] += K[4]		// (2011. 07. 25 17:58
//			$sys_rtimedateA[@RTimeDate] += K[6]		// (2011. 07. 25 17:58)

// コメント取得
#macro		@GetSLComData(@SLComDataNo, @SLComData)
			@SLComData = syscom.get_save_comment(@SLComDataNo)



