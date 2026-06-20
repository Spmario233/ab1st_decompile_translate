//効果音の定義ファイル

//■■■■■
//環境音・ガヤ
//■■■■■
#define		@小鳥のさえずり			"se_bird"					//小鳥のさえずり音(Loop可)
#define		@地鳴りループ			"se_dinari_loop"			//天井から屋根が下りてくる音(Loop用)
#define		@せせらぎ				"se_river_loop"				//川のせせらぎ(Loop用)
#define		@滝						"se_waterfall"				//大量の水が流れる音(Loop用)
#define		@夏風					"se_breeze_loop"			//そよ風の音松下ひまわりとか(Loop用)
#define		@ひまわり風				"se_breeze"					//ひまわりを撫でる風(Loop用)
#define		@地下水脈				"se_stream_loop"			//(Loop用)
#define		@雨						"se_rain"					//雨音強め(Loop用)
#define		@台風					"se_typhoon"				//台風(Loop用)
#define		@暴風					"se_storm"					//暴風(Loop用)
#define		@空気					"se_air"					//空気の流れる音(Loop用)
#define		@空気２					"se_air2"					//空気の流れる音(Loop用)

#define		@ガヤ					"se_gaya"					//ガヤ音(Loop用)
#define		@ガヤ不満				"se_gaya2"					//不満を漏らすガヤ音(Loop用)
#define		@祝福					"se_congratulation"			//歓声があがる(Loop不可)
#define		@歓声野球				"se_cheer"					//野球の歓声
#define		@歓声バスケ				"se_cheer2"					//バスケの歓声
#define		@歓声教室				"se_cheer3"					//男子ども
#define		@ガルデモライブ			"se_gdmlive"				//ライブの時の歓声

#define		@チャイム				"se_chime"					//学校のチャイム音フル
#define		@チャイム２				"se_chime2"					//Ｄａｙ１で起きたときに使用する前半をカットした学校のチャイム音
#define		@放送チャイム			"se_chime3"					//校内放送のチャイム音フル

#define		@雨音トランシーバ		"se_rainytransceiver"		//無線ごしに雨音

//ワンショット環境音
#define		@雷						"se_thunder"				//雷が落ちる音１回
#define		@落雷					"se_thunderstrike"			//ハルバードに落雷
#define		@みかん散乱				"se_orange"					//ミカン箱がひっくり返って、みかんが床に散乱する


//■■■■■
//ドア・鍵・窓・カーテン
//■■■■■
#define		@カーテン開ける			"se_curtain_open"			//保健室のカーテンをざっと開ける音（強めです）
#define		@カーテン開ける２		"se_curtain_open2"			//保健室のカーテンをざっと開ける音（普通）
#define		@窓開ける				"se_window_open"			//保健室の窓を開ける音
#define		@窓開ける２				"se_window_open2"			//両開きの窓を開ける音
#define		@窓割れる				"se_window_break"			//窓が割れる音
#define		@木製扉開ける強			"se_wooddoor_open"			//木製の観音開きドアを強めに開ける音（作戦本部など）
#define		@木製扉開ける中			"se_wooddoor_open3"			//木製の観音開きドアを普通に開ける音（作戦本部など）
#define		@木製扉開ける			"se_wooddoor_open2"			//木製の横開き扉を開ける音教室など
#define		@木製扉閉める			"se_wooddoor_close"			//木製の横開き扉を閉める音教室など
#define		@木製扉閉める２			"se_wooddoor_close2"		//木製の片開き扉を閉める音
#define		@鉄製扉開ける			"se_irondoor_open"			//鉄製の扉を開ける音
#define		@鉄製扉閉める			"se_irondoor_close"			//鉄製の扉を強めに閉める音
#define		@寮扉開ける				"se_irondoor_open2"			//寮の鉄製の扉を開ける音
#define		@寮扉閉める				"se_irondoor_close2"		//寮の鉄製の扉を閉める音
#define		@体育倉庫開ける			"se_doorgymwarehouse"		//体育倉庫の横開き扉を開ける音
#define		@食堂扉開ける			"se_cafedoor_open"			//生徒会が包囲するシーンなのでちょっと特殊。汎用性は低いかも。
#define		@サイバードア閉			"se_doorclose_cyber"		//降下作戦のレーザートラップの電子扉が閉まる
#define		@サイバードア開			"se_dooropen_cyber"			//降下作戦のレーザートラップの電子扉が開く
#define		@病室扉開ける			"se_hospitaldoor_open"		//病室の扉を開ける音
#define		@病室扉閉める			"se_hospitaldoor_close"		//病室の扉を閉める音
#define		@木製ノック				"se_knock"					//木製の扉を３回ノックする音
#define		@ガラスノック			"se_knock_glass"			//ガラス窓を２回ノックする音
#define		@鉄製ノック				"se_knock_iron"				//鉄製の扉を２回ノックする音
#define		@鉄製ノック２			"se_irondoor_knock"			//鉄製の扉を強めに４回ノックする音
#define		@病室ノック				"se_knock_hospital"			//病室を控えめに２回ノックする音
#define		@鍵開ける				"se_key_open"				//分厚い木製扉の鍵を開ける音（作戦本部の解錠音）
#define		@鍵開ける２				"se_key_open3"				//鍵を開ける一般的な音
#define		@鍵ガチャガチャ			"se_key_gatyagatya"			//ピッキング音
#define		@鍵ガチャリ				"se_key_open2"				//鍵が回って開く音
#define		@体育館収納				"se_storagespace"			//体育館の隠し収納を引っ張り出す音（ギルド降下時）


//■■■■■
//机・椅子・教室
//■■■■■
#define		@椅子立つ				"se_chair_standup"			//学校の椅子から立ち上がる音勢い強め
#define		@椅子立つ２				"se_chair_standup2"			//学校の椅子から立ち上がる音普通
#define		@椅子立つ３				"se_chair_standup3"			//ゆりが作戦本部の椅子から立ち上がる音
#define		@机叩く					"se_desk_hit"				//机にバーンと手を叩きつける音
#define		@チョーク				"se_chalk"					//チョークで黒板に字を書く
#define		@天井穴あく				"se_wood_bloken"			//木製の天井に穴があく音


//■■■■■
//電機・時計・電話
//■■■■■
#define		@照明スイッチ			"se_lightswitch"			//室内灯のスイッチを入れる消す
#define		@ラジカセボタン			"se_button_machine"			//ラジカセのボタンを押す音
#define		@キーボード				"se_keyboard"				//キーボードを打つ
#define		@キーボード１回			"se_keyboardone"			//キーボードを１回打つ
#define		@マウス					"se_mouse"					//マウスを１回クリック
#define		@目覚まし時計			"se_alarmclock"				//目覚まし時計が鳴る音
#define		@携帯操作				"se_phonebutton"			//携帯電話の操作音


//■■■■■
//生き埋め
//■■■■■
#define		@電車ブレーキ			"se_trainaccident"			//電車の急ブレーキ音
#define		@電車揺れ				"se_yure"					//電車揺れ
#define		@どかーん				"se_dokan"					//どかーん
#define		@電車ドア開ける			"se_traindoor_open"			//電車ドアこじ開け
#define		@落盤					"se_rooffall"				//岩が崩れてくる音
#define		@瓦礫					"se_debris"					//瓦礫が崩れる音
#define		@掘削機					"se_excavator"				//掘削して岩が崩れる音
#define		@水零れる				"se_fall_water"				//水が零れて地面に落ちる音
#define		@電気スパーク			"se_elec_spark"				//電気のスパーク音（音無過去回想２で使用）
//#define		@超電磁スパーク		"se_elemgn_spark"			//ごめん、つい書きたくなってもうた


//■■■■■
//足音
//■■■■■
#define		@歩き去る				"se_walkout_lino"			//歩き去る音リノリウム編
#define		@歩く複数				"se_walk_conc"				//コンクリートの上を複数で歩く編
#define		@病院歩く				"se_hospital_walk2"			//病院を歩く音ちょっとリバーブかけてます(Loop用)
#define		@歩く					"se_walk_loop"				//
#define		@靴の音					"se_shoes"					//靴が鳴る
#define		@土走る					"se_run_ground"				//土の上を走る音
#define		@足音ループ				"se_walk_loop"				//リノリウムの上を歩き続けます。


//■■■■■
//打撃など
//■■■■■
#define		@蹴る					"se_kick"					//蹴る音ギャグ
#define		@膝蹴り					"se_kneekick"				//膝蹴りの音ギャグ
#define		@殴る					"se_punch"					//殴る音ギャグ
#define		@殴る２					"se_punch2"					//エルボーとか食い込む感じの殴る音ギャグ
#define		@殴る連続				"se_punch_consective"		//連続で殴る音ギャグ（ループできます）
#define		@避ける					"se_kazekiri5"				//攻撃を回避する音
#define		@枕殴る					"se_pillow_punch"			//枕を殴る音
#define		@枕殴る連打				"se_pillow_punch2"			//枕を殴る音５連続
#define		@壁殴る					"se_punchwall"				//壁を殴る音
#define		@クロスカウンター		"se_crosscounter"			//クロスカウンター（パンチの音にパンチを重ねる）この場面で使用しているのは、se_punchです。

#define		@頭ぶつける				"se_headdamage"				//頭を地面に打ち付ける音ギャグ
#define		@転ぶ					"se_fall_human"				//転ぶ音ギャグ
#define		@転ぶ２					"se_fall2_human"			//頭から床に落ちる
#define		@体当たり				"se_charge"					//体当たり音ギャグ
#define		@ツッコミ				"se_tukkomichop"			//ポコンとかわいく手でツッコむ音
#define		@スライディング			"se_sliding"				//スライディング音ギャグ

#define		@衝撃１					"se_shogeki1"				//衝撃音1
#define		@衝撃２					"se_shogeki2"				//衝撃音2

#define		@タックル				"se_charge2"				//ガチで体当たりする音（ギャグではない）
#define		@ジャンプ				"se_jump"					//ジャンプする音
#define		@ビンタ					"se_binta"					//自分に気合い入れるビンタ音（他人に張り手する音ではないので注意）
#define		@ビンタ２				"se_binta2"					//他人にビンタ
#define		@骨折る					"se_fracture"				//ぐきりという打撲音
#define		@尻キック				"se_hipkick"				//尻を蹴る音
#define		@金蹴り					"se_goldenball"				//股間を蹴り上げる音チーン
#define		@柔道受け身				"se_judoukemi"				//柔道で受け身する音。野外


//■■■■■
//ワンショット動作音
//■■■■■
#define		@茂み					"se_bush"					//茂みががさっと揺れる音
#define		@着地					"se_landing"				//地面に着地する音
#define		@着地２					"se_landing2"				//地面に着地する音激しい
#define		@紙踏む					"se_steppaper"				//紙を踏みつける音３連続
#define		@水顔出す				"se_waterup"				//水から顔を出す
#define		@水潜る					"se_waterdown"				//水に潜る
#define		@水中					"se_submarine"				//水に潜る
#define		@水飛び込む				"se_waterdive"				//水に飛び込む音バシャーン
#define		@お湯かける				"se_bath_flush"				//桶に組んだお湯などをかける
#define		@蛇口					"se_tap"					//蛇口を閉める
#define		@風呂溢れる				"se_bathdive"				//お風呂の水が溢れる音
#define		@風呂上がる				"se_bathrise"				//お風呂から上がる音
#define		@風呂入る				"se_bathin"					//お風呂に普通に入る音
#define		@ケロリン椅子			"se_chair_pull"				//お風呂の椅子を引く
#define		@起きるベッド			"se_wakeup_bed"				//ベッドから起き上がる音
#define		@本めくる				"se_book"					//本をめくる音
#define		@着替え					"se_cloth"					//着替える衣擦れ音
#define		@早脱ぎ					"se_cloth2"					//素早く服を脱ぐ音
#define		@拍手					"se_claphands"				//拍手する音
#define		@抱きしめる				"se_hold_human"				//抱きしめる音
#define		@打ち上がる				"se_rocket"					//日向の椅子がしゅごごごと立てる音（ロケットの発射時の音みたいな？）
#define		@ベッドレバー			"se_bedlever"				//病院のベッドのレバーをきこきこ回す音
#define		@蓋を開ける				"se_cover_open"				//ギルド降下作戦の水攻めの蓋が開く音
#define		@プルタブ				"se_pulltab"				//プルタブ開ける
#define		@紙袋					"se_paperbag"				//紙袋かさっとさせる
#define		@空腹					"se_hunger"					//お腹の音が鳴る
#define		@釣り針垂らす			"se_fishing_in"				//釣り針を水面に垂らす
#define		@紙に書く				"se_writing"				//紙にペンで字を書く
#define		@缶落とす				"se_fall_can"				//缶を落とす音


//■■■■■
//ループ音
//■■■■■
#define		@心音					"se_heartbeat"				//ドクドク(Loop用)
#define		@麻雀					"se_mahjong"				//麻雀の牌をじゃらじゃら掻き混ぜる音


//■■■■■
//バトル関係
//■■■■■
#define		@刃物刺さる				"se_sasareru"				//ハンドソニック等が突き刺さる音
#define		@ハンドガン構える		"se_handgun_setup"			//ハンドガンのレバー解除音
#define		@ハンドガン				"se_handgun"				//日向、高松がハンドガンを撃つ音（１発）
#define		@ハンドガン×３			"se_handgun_3"				//日向、高松がハンドガンを撃つ音（３発）
#define		@ハンドガン２			"se_handgun2"				//ゆり、音無がハンドガンを撃つ音（１発）
#define		@ハンドガン２×２		"se_handgun2_2"				//ゆり、音無がハンドガンを撃つ音（２発）
#define		@ハンドガン２×３		"se_handgun2_3"				//ゆり、音無がハンドガンを撃つ音（３発）音無ハンドガンと同じ音
#define		@ライフル				"se_rifle"					//ライフル銃の音（連射）
#define		@ライフル２				"se_rifle2"					//ライフル銃の音（２発）
#define		@ライフル連射			"se_rifle_multi"			//ライフル銃の音（１０発）
#define		@ライフル連射小			"se_rifle_multi2"			//ライフル銃の音（１０発）小さめ
#define		@空撃ち					"se_emptygun"				//玉がなくなった銃の引き金を引いてカシャとなる音
#define		@剣戟					"se_kengeki"				//天使がハンドソニックでガードしたときの金属音（原作のような音はない…）
#define		@剣戟×３				"se_kengeki_3"				//金属同士がぶつかり合う音（３回）
#define		@剣戟２					"se_kengeki2"				//重い金属同士がぶつかり合う音（１回）
#define		@空き缶ヒット			"se_shotting_can"			//空き缶に弾丸が命中
#define		@影霧散					"se_shadow"

#define		@地面叩きつける			"se_fling_ground"			//地面に叩きつける音
#define		@骨ゴリゴリ				"se_bone_gorigori"			//脱臼した肩をゴリゴリされる音
#define		@殴りかかる				"se_kazekiri4"				//殴りかかる風切り音
#define		@受け止める				"se_guard"					//拳を手で受け止める音
#define		@風切り					"se_kazekiri"				//ハルバードが宙を舞う風切り音（原作のような音はない…）
#define		@刃物つきつけ			"se_threaten"				//刃物をのど元などにつきつける音
#define		@斬撃					"se_slice_fish"				//刃物で切る音
#define		@斬撃２					"se_zan"					//ハンドソニックで影を斬る


//■■■■■
//天使
//■■■■■
#define		@ハンドソニック生成		"se_handsonic"				//ガードスキルハンドソニックの生成音
#define		@ハンドソニック攻撃		"se_handsonicattack"		//ハンドソニックを扉に打ち付ける音
#define		@ハンドソニック消す		"se_handsonicera"			//ガードスキルハンドソニックが霧散して消える音
#define		@ハンドソニック２		"se_handsonic2"				//ハンドソニックバージョン２生成音
#define		@ハンドソニック３		"se_handsonic3"				//ハンドソニックバージョン３生成音
#define		@ハンドソニック４		"se_handsonic4"				//ハンドソニックバージョン４生成音
#define		@ハンドソニック５		"se_handsonic5"				//ハンドソニックバージョン５生成音
#define		@ドア破壊				"se_bombdoor"				//ハンドソニックバージョン４で扉が吹っ飛ぶ
#define		@ディストーション生成	"se_distortion"				//ガードスキルディストーションの生成音
#define		@ディストーション		"se_dist_cho_loop"			//ディストーションで弾をはじく音（ループ）
#define		@ディストーション単発	"se_dist_cho"				//ディストーションで弾をはじく音
#define		@ハーモニクス生成		"se_harmonics"				//ガードスキルハーモニクス生成音
#define		@分身解除				"se_alterego"				//数いる分身がかなでの身体に戻っていく音
#define		@ディレイ発動			"se_delay"					//ガードスキルディレイの発動音
#define		@ハウリング発動			"se_howling"				//ガードスキルハウリング発動音


//■■■■■
//キャラ固有
//■■■■■
#define		@野田キュピーン			"se_kyupeen"				//ハルバードが光り輝くギャグ音
#define		@野田素振り				"se_kazekiri3"				//野田がハルバードを素振りする風切り音連続４回
#define		@野田振る				"se_wave_axe"				//野田がハルバードを振る風切り音決めの演出っぽい感じ
#define		@椎名音					"se_shiina"					//椎名音
#define		@椎名音大				"se_hyousigi"				//椎名音、音量大
#define		@ＴＫ下敷き				"se_crush"					//ギルド降下作戦にてＴＫが天井と床に挟まれる音
#define		@弦切れる				"se_guiterstring"			//ギターの弦が切れる音（ひさ子エレキ）
#define		@日向飛ぶ				"se_utiagebomb"				//テストで日向が打ち上げられる音
#define		@眼鏡					"se_glasskatya"				//高松が眼鏡に指を添えてカチャッとする音
#define		@木刀					"se_woodensword"			//藤巻が木刀をカチャと鳴らす音
#define		@刃物構える				"se_halberd"			//ハルバード等の長物を構える音
#define		@ギラン					"se_giran"					//赤目天使が登場してギランとする音？
#define		@犬のおもちゃ			"se_dogtoy_loop"			//椎名が愛でてる犬のオモチャの鳴き声。
#define		@高周波					"se_highfrequency"			//直江の催眠術キーン（ありそうでない…）←■直江ってあれか、長尾(上杉)家家老か？		直井か…！（盛大な勘違い）
#define		@ユイ_アコギＡ			"se_yui_Crowsong_Gt"		//ユイの路上ライブギターCrow Song
#define		@ユイ_アコギＢ			"se_yui_Alchemy_Gt"			//ユイの路上ライブギターAlchemy


//■■■■■
//特殊
//■■■■■
#define		@食券爆破				"se_bomb"					//食券が宙に舞い上がる破裂音
#define		@食券					"se_shokken"				//食券が宙に舞い散る音
#define		@ファン					"se_fan"					//オペレーショントルネード
#define		@風切り２				"se_kazekiri2"				//トラップが動く風切り音
#define		@トラップ炸裂			"se_trapattack"				//巨大ハンマーが直撃する音

#define		@地鳴り					"se_dinari"					//地鳴り音（ループじゃないので注意）
#define		@鉄球落ちる				"se_fall_iron"				//ドーンと鉄球が落ちる音
#define		@鉄球転がる				"se_roll_iron"				//鉄球が転がる音
#define		@天井動く				"se_rooftrap"				//トラップが作動して天井が動き出す音
#define		@天井支える				"se_roofshock"				//トラップが作動して天井を受け止める音
#define		@小石ぱらぱら			"se_smallstone"				//小石がぱらぱら
#define		@床崩れる				"se_groundtrap"				//トラップが作動して床が崩れる音
#define		@爆発遠く				"se_explosion_distance"		//遠くで爆発する音
#define		@岩の粉					"se_fall_rockdust"			//岩の粉がパラパラ落ちる音
#define		@爆発近く				"se_explosion_near"			//近くで爆発する音
#define		@大砲車輪				"se_cannon_wheel"			//大砲の車輪がゴロゴロする音
#define		@大砲爆発				"se_cannon_destruction"		//大砲が暴発する音
#define		@手榴弾					"se_grenade"				//グレネードが爆発する音（大砲より爆発音小さめ）
#define		@起爆スイッチ			"se_fuse"					//起爆スイッチＯＮ
#define		@煙幕破裂				"se_smoke"					//ぼんっという煙幕の音
#define		@レーザー罠				"se_lasertrap"				//レーザートラップの動作音
#define		@切断					"se_mutilation"				//鋭利な刃物で人体が切断される音
#define		@テーブル破壊			"se_tablecrash"				//食堂のテーブルやグラスをひっくり返して割る
#define		@首絞まる				"se_neckcord"				//首が絞まる音
#define		@起きる血だまり			"se_wakeup_blood"			//血だまりから起き上がる音
#define		@血どくどく				"se_blood"					//血が流れる音
#define		@むにゅ					"se_munyu"					//おっぱいとか身体の柔らかい部分に触れてしまうギャグ音
#define		@サッカー蹴る			"se_soccershot"				//サッカーボールを蹴る
#define		@ゴールネット			"se_soccergoal"				//シュートが決まって、ゴールネットが揺れる
#define		@自販機					"se_atmachine"				//自販機のボタン押す＆ジュース出る
#define		@券売機					"se_ticketmachine"			//券売機のボタン押す
#define		@硬貨					"se_coin"					//機械に硬貨を投入する音
#define		@レバー					"se_fuse2"					//連続でレバーを下す音ギルド降下作戦
#define		@シャーペン刺す			"se_stab_pencil"			//シャープペンシルが肌に刺さる音
#define		@無線機投げる			"se_throw_trans"			//トランシーバを投げ捨てて壊す音
#define		@水土下座				"se_kneeldown_water"		//雨の中土下座する音
#define		@魚釣る					"se_fishing"				//大きな魚を釣り上げる音
#define		@大爆破					"se_guildblast"				//ギルドを爆破する連続爆発音


//■■■■■
//エモーション音
//■■■■■
#define		@ガーン					"se_shock"					//ガーンのギャグ音
#define		@音無目覚め				"se_hit01_otwu"				// 天使に刺されたのち医務室での目覚め
#define		@ヒット２				"se_hit02"					// 天使に刺されるん
#define		@回想１					"se_memory1"				// 天使に刺されたのを思い出す
#define		@回想２					"se_memory2"				// 天使に刺されたのを思い出す
#define		@キレる					"se_kireru"					//ブチっとなるギャグ音


//■■■■■
//野球関係
//■■■■■
#define		@短打					"se_hitting_short"			//短打コースのヒット
#define		@長打					"se_hitting_long"			//長打コースのヒット
#define		@ホームラン				"se_homerun2"				//カァーンと甲高いヒッティング音
#define		@フライ					"se_hitting_out"			//フライを打ち上げる。フライというか凡打
#define		@バント					"se_hitting_bunt"			//送りバントやセーフティーバント
#define		@空振り					"se_hitting_strikeout"		//空振り
#define		@投球１					"se_pitching1"				//投球パターン１音無
#define		@投球２					"se_pitching2"				//投球パターン２敵
#define		@投球３					"se_pitching3"				//セットポジションからの素早い投球
#define		@牽制球					"se_pickoff"				//牽制球
#define		@捕球					"se_catch"					//フライを捕球
#define		@捕球２					"se_catch2"					//キャッチャーミット
#define		@捕球３					"se_catch3"					//野田が音無（ピッチャー）に送球
#define		@捕球４					"se_throw"					//ワンバウンド捕球
#define		@素振り					"se_swing"					//素振りの音
#define		@走塁					"se_baserunning"			//走塁の音
#define		@滑り込む				"se_basesliding"			//野球のスライディングの音
#define		@マウンド				"se_mound"					//マウンドを足でならす音
#define		@盗塁					"se_basekick"				//盗塁するときにベースを蹴る音
#define		@グローブ叩く			"se_baseglove"				//グローブをパンパンと叩いて握りを確かめたり、タイミングをとったり
#define		@バッド投げる			"se_metalbat"				//打ったときなどにバッドを投げ落とす音
#define		@バッド落とす			"se_metalbat2"				//その場でバッドを落とす音
#define		@金網					"se_wirenetting"			//金網にボールが当たる音
#define		@ボール壁				"se_homerun"				//壁にボールが当たる音ホームランとか？
#define		@ボール落とす			"se_fallball"				//ボールを落とす音
#define		@死球					"se_hitbyapitch"			//デッドボール
#define		@打者構える				"se_babox"					//バッターボックスで構える土を踏む音
#define		@ハイタッチ				"se_hightouch"				//ハイタッチする手の音
#define		@ヘルメット				"se_helmet"					//ヘルメットが転がる音
#define		@ハルバード打			"se_hitting_hal"			//ハルバードで打つ音
#define		@ティー叩く				"se_hitting_tee"			//バットがティーを叩く音


//■■■■■
//バスケ関係
//■■■■■
#define		@シュート１				"se_basketshot"				//的に当たってリングに入る
#define		@シュート２				"se_basketshot2"			//直接リングに入る
#define		@ダンク					"se_dunkshot"				//ダンクシュートでリングが揺れる音
#define		@リングぐるり			"se_ringrolling"			//ボールがリングをぐるっと回る音
#define		@ドリブル１				"se_dribble"				//ドリブルする音ゆっくり
#define		@ドリブル２				"se_dribble2"				//ドリブルする音早い
#define		@ドリブル３				"se_dribble3"				//走ってドリブルする音ゆっくり
#define		@ドリブル４				"se_dribble4"				//走ってドリブルする音早い
#define		@ドリブル５				"se_dribble5"				//ドリブルする音ゆっくり（２回）
#define		@ジャンプボール			"se_jumpball"				//試合開始のジャンプボール
#define		@ピボット				"se_pivot"					//ピボット。足回転させるヤツ
#define		@リングはじく			"se_ringbound"				//リングでボールが弾かれる音
#define		@ボールバウンド			"se_ballbound"				//ボールがバウンドする音１回
#define		@ボール転がる			"se_ballrolling"			//ボールがバウンドして転がっていく
#define		@ボール受ける			"se_ballcatch"				//パスボールを受け止める
#define		@ボールカット			"se_ballcut"				//パスボールをはじく
#define		@ホイッスル				"se_whistle"				//ホイッスルの音


//■■■■■
//音源制作中
//■■■■■
// 作らない #define		@血塗れシャツ			"se_bloodshirt"				//血に濡れたシャツを投げ捨てる音
// 別に要らんやろ #define		@転げ回る				"se_humanrolling"			//ふたり床をごろごろと転がりながら、相手のシャツを掴み、ボタンがはじけ飛ぶ音。
// アニメでも鳴ってないので作らない #define		@ディレイ生成			"se_delay"					//ガードスキルディレイの発動音
//#define		@ギターびーん			"se_guiterbeen"				//びーんと、ギターが間抜けな音を立てる音（岩沢アコギ）
//#define		@電車ドアロック			"se_trainlock"				//電車ドアロック解除
//#define		@ギターピック			"se_guiterpick"				//ユイが弦をギターのピックで弾く音
