
------------------------------------------------------------------------------------------------------
-- Necrosis LdC
--
-- Crateur initial (US) : Infernal (http://www.revolvus.com/games/interface/necrosis/)
-- Implmentation de base (FR) : Tilienna Thorondor
-- Reprise du projet : Lomig & Nyx des Larmes de Cenarius, Kael'Thas
-- 
-- Skins et voix Franaises : Eliah, Ner'zhul
-- Version Allemande par Arne Meier et Halisstra, Lothar
-- Remerciements spciaux pour Sadyre (JoL)
-- Version 06.05.2006-1
------------------------------------------------------------------------------------------------------


------------------------------------------------
-- CHINESE  VERSION TEXTS --
------------------------------------------------

function Necrosis_Localization_Dialog_Tw()

	function NecrosisLocalization()
	Necrosis_Localization_Speech_Tw();
	end

	NECROSIS_COOLDOWN = {
		["Spellstone"] = "法術石冷卻時間",
		["Healthstone"] = "治療石冷卻時間"
	};

	NecrosisTooltipData = {
		["Main"] = {
			Label = "|c00FFFFFFNecrosis|r",
			Stone = {
				[true] = "是";
				[false] = "否";
			},
			Hellspawn = {
				[true] = "開";
				[false] = "關";
			},
			["Soulshard"] = "靈魂碎片: ",
			["InfernalStone"] = "地獄火石: ",
			["DemoniacStone"] = "惡魔雕像: ",
			["Soulstone"] = "\n靈魂石: ",
			["Healthstone"] = "治療石: ",
			["Spellstone"] = "法術石: ",
			["Firestone"] = "火焰石: ",
			["CurrentDemon"] = "惡魔: ",
			["EnslavedDemon"] = "惡魔: 奴役",
			["NoCurrentDemon"] = "惡魔 : 無",
		},
		["Soulstone"] = {
			Label = "|c00FF99FF靈魂石|r",
			Text = {"制造","可使用","已使用","等待"}
		},
		["Healthstone"] = {
			Label = "|c0066FF33治療石|r",
			Text = {"制造","使用"}
		},
		["Spellstone"] = {
			Label = "|c0099CCFF法術石|r",
			Text = {"制造","在包里","裝備在副手"}
		},
		["Firestone"] = {
			Label = "|c00FF4444火焰石|r",
			Text = {"制造","在包里","裝備在副手"}
		},
		["SpellTimer"] = {
			Label = "|c00FFFFFF法術持續時間|r",
			Text = "啟用對目標的法術計時",
			Right = "右鍵使用爐石到"
		},
		["ShadowTrance"] = {
			Label = "|c00FFFFFF暗影冥思|r"
		},
		["Domination"] = {
			Label = "|c00FFFFFF惡魔支配|r"
		},
		["Enslave"] = {
			Label = "|c00FFFFFF奴役惡魔|r"
		},
		["Armor"] = {
			Label = "|c00FFFFFF魔甲術|r"
		},
		["Invisible"] = {
			Label = "|c00FFFFFF偵測隱形|r"
		},
		["Aqua"] = {
			Label = "|c00FFFFFF魔息術|r"
		},
		["Kilrogg"] = {
			Label = "|c00FFFFFF基爾羅格之眼|r"
		},
		["Banish"] = {
			Label = "|c00FFFFFF放逐術|r"
		},
		["TP"] = {
			Label = "|c00FFFFFF召喚儀式|r"
		},
		["SoulLink"] = {
			Label = "|c00FFFFFF靈魂鏈接|r"
		},
		["ShadowProtection"] = {
			Label = "|c00FFFFFF防護暗影結界|r"
		},
		["Imp"] = {
			Label = "|c00FFFFFF小鬼|r"
		},
		["Void"] = {
			Label = "|c00FFFFFF虛空行者|r"
		},
		["Succubus"] = {
			Label = "|c00FFFFFF魅魔|r"
		},
		["Fel"] = {
			Label = "|c00FFFFFF地獄獵犬|r"
		},
		["Infernal"] = {
			Label = "|c00FFFFFF地獄火|r"
		},
		["Doomguard"] = {
			Label = "|c00FFFFFF末日守衛|r"
		},
		["Sacrifice"] = {
			Label = "|c00FFFFFF惡魔犧牲|r"
		},
		["Amplify"] = {
			Label = "|c00FFFFFF詛咒增幅|r"
		},
		["Weakness"] = {
			Label = "|c00FFFFFF虛弱詛咒|r"
		},
		["Agony"] = {
			Label = "|c00FFFFFF痛苦詛咒|r"
		},
		["Reckless"] = {
			Label = "|c00FFFFFF魯莽詛咒|r"
		},
		["Tongues"] = {
			Label = "|c00FFFFFF語言詛咒|r"
		},
		["Exhaust"] = {
			Label = "|c00FFFFFF疲勞詛咒|r"
		},
		["Elements"] = {
			Label = "|c00FFFFFF元素詛咒|r"
		},
		["Shadow"] = {
			Label = "|c00FFFFFF暗影詛咒|r"
		},
		["Doom"] = {
			Label = "|c00FFFFFF厄運詛咒|r"
		},
		["Mount"] = {
			Label = "|c00FFFFFF坐騎|r"
		},
		["Buff"] = {
			Label = "|c00FFFFFF法術菜單|r\n右鍵打開菜單"
		},
		["Pet"] = {
			Label = "|c00FFFFFF惡魔菜單|r\n右鍵打開菜單"
		},
		["Curse"] = {
			Label = "|c00FFFFFF詛咒菜單|r\n右鍵打開菜單"
		},
		["Radar"] = {
			Label = "|c00FFFFFF感知惡魔|r"
		},
		["AmplifyCooldown"] = "右鍵詛咒增幅",
		["DominationCooldown"] = "右鍵快速召喚",
		["LastSpell"] = "左鍵施放",
	};


	NECROSIS_SOUND = {
		["Fear"] = "Interface\\AddOns\\Necrosis\\sounds\\Fear-En.mp3",
		["SoulstoneEnd"] = "Interface\\AddOns\\Necrosis\\sounds\\SoulstoneEnd-En.mp3",
		["EnslaveEnd"] = "Interface\\AddOns\\Necrosis\\sounds\\EnslaveDemonEnd-En.mp3",
		["ShadowTrance"] = "Interface\\AddOns\\Necrosis\\sounds\\ShadowTrance-En.mp3",
		["CriticalDamage"] = "Interface\\AddOns\\Necrosis\\sounds\\CriticalDamage.mp3",
		["ShadowVulnerability"] = "Interface\\AddOns\\Necrosis\\sounds\\ShadowVulnerability-En.mp3"
	};


	NECROSIS_NIGHTFALL_TEXT = {
		["NoBoltSpell"] = "你好像沒有暗影箭法術。",
		["Message"] = "<white>暗<lightPurple1>影<lightPurple2>冥<purple>思<darkPurple1>！<darkPurple2>暗<darkPurple1>影<purple>冥<lightPurple2>思<lightPurple1>！<white>！"
	};


	NECROSIS_MESSAGE = {
		["Error"] = {
			["InfernalStoneNotPresent"] = "你需要地獄火石!",
			["SoulShardNotPresent"] = "你需要靈魂碎片!",
			["DemoniacStoneNotPresent"] = "你需要惡魔雕像!",
			["NoRiding"] = "你沒有任何戰馬!",
			["NoFireStoneSpell"] = "你無制造火焰石法術",
			["NoSpellStoneSpell"] = "你無制造法術石法術",
			["NoHealthStoneSpell"] = "你無制造治療石法術",
			["NoSoulStoneSpell"] = "你無制造靈魂石法術",
			["FullHealth"] = "當你未少血時不能使用治療石",
			["BagAlreadySelect"] = "錯誤: 這個包已經被選擇。",
			["WrongBag"] = "錯誤: 這個數必須在0至4之間。",
			["BagIsNumber"] = "錯誤: 請輸入一個數。",
			["NoHearthStone"] = "錯誤: 你的包中沒有任何治療石。"
		},
		["Bag"] = {
			["FullPrefix"] = "你的 ",
			["FullSuffix"] = " 滿了 !",
			["FullDestroySuffix"] = " 滿了; 下個碎片將被摧毀!",
			["SelectedPrefix"] = "你選擇你的",
			["SelectedSuffix"] = "放你的靈魂碎片。"
		},
		["Interface"] = {
			["Welcome"] = "<white>/necro 顯示設置菜單!",
			["TooltipOn"] = "打開提示" ,
			["TooltipOff"] = "關閉提示",
			["MessageOn"] = "打開聊天信息通知",
			["MessageOff"] = "關閉聊天信息通知",
			["MessagePosition"] = "<- 這兒將顯示Necrosis的信息 ->",
			["DefaultConfig"] = "<lightYellow>默認配置已加載。",
			["UserConfig"] = "<lightYellow>配置已加載。",
			["CurseSelection"] = " 選擇作為默認。使用'施放選擇反詛咒' 按鍵綁定施放它。",
			["CurseAmplify"] = "<lightYellow>當可能施放的時候詛咒增幅將觸發。",
			["CursePetAttack"] = "<lightYellow>施放默認的詛咒將使你的寵物攻擊。"
		},
		["Help"] = {
			"/necro recall -- 將Necrosis和所有按鈕置於屏幕中間",
			"/necro sm -- 用a short raid-ready version代替靈魂綁定和召喚信息"
		},
		["EquipMessage"] = "裝備",
		["SwitchMessage"] = "代替",
		["Information"] = {
			["FearProtect"] = "你的目標對恐懼免疫!!!!",
			["EnslaveBreak"] = "惡魔擺脫奴役...",
			["SoulstoneEnd"] = "<lightYellow>你的靈魂石失效。"
		}
	};


	-- Gestion XML - Menu de configuration

	NECROSIS_COLOR_TOOLTIP = {
		["Purple"] = "紫色",
		["Blue"] = "藍色",
		["Pink"] = "粉紅色",
		["Orange"] = "橙色",
		["Turquoise"] = "青綠色",
		["X"] = "X"
	};
	
	NECROSIS_CONFIGURATION = {
		["CriticalDamageWarning"] = "致命一擊聲音提示。",
		["Channel"] = "信息頻道",
		["Menu1"] = "碎片設置",
		["Menu2"] = "信息設置",
		["Menu3"] = "按鈕設置",
		["Menu4"] = "計時器設置",
		["Menu5"] = "圖像設置",
		["MainRotation"] = "Necrosis角度選擇",
		["ShardMenu"] = "|CFFB700B7背包|CFFB700B7 :",--"|CFFB700B7I|CFFFF00FFn|CFFFF50FFv|CFFFF99FFe|CFFFFC4FFn|CFFFF99FFt|CFFFF50FFo|CFFFF00FFr|CFFB700B7y :",
		["ShardMenu2"] = "|CFFB700B7碎片|CFFB700B7 :",--"|CFFB700B7S|CFFFF00FFh|CFFFF50FFa|CFFFF99FFr|CFFFFC4FFd C|CFFFF99FFo|CFFFF50FFu|CFFFF00FFn|CFFB700B7t :",
		["ShardMove"] = "將碎片放入選擇的包。",
		["ShardDestroy"] = "如果包滿摧毀所有新的碎片。",
		["SpellMenu1"] = "|CFFB700B7法術|CFFFFC4FF :",--"|CFFB700B7S|CFFFF00FFp|CFFFF50FFe|CFFFF99FFl|CFFFFC4FFls :",
		["SpellMenu2"] = "|CFFB700B7玩家|CFFFF99FF :",		
		["TimerMenu"] = "|CFFB700B7圖形計時器|CFFFF99FF :",--"|CFFB700B7G|CFFFF00FFr|CFFFF50FFa|CFFFF99FFp|CFFFFC4FFh|CFFFF99FFi|CFFFF50FFc|CFFFF00FFa|CFFB700B7l T|CFFFF00FFi|CFFFF50FFm|CFFFF99FFe|CFFFFC4FFrs :",
		["TimerColor"] = "顯示計時器文字為白色(代替黃色)",
		["TimerDirection"] = "計時器向上升",
		["TranseWarning"] = "當我獲得暗影冥思效果時提醒我。",
		["SpellTime"] = "打開法術計時器。",
		["AntiFearWarning"] = "當我的目標免疫恐懼時提醒我。",
		["ShadowVulnerabilityWarning"] = "當我的目標有暗影弱點時提醒我。",
		["GraphicalTimer"] = "顯示圖形計時器",	
		["TranceButtonView"] = "顯示隱藏的按鈕以拖動它。",
		["ButtonLock"] = "鎖定 Necrosis球體周圍的按鈕。",
		["MainLock"] = "鎖定 Necrosis球體及周圍的按鈕。",
		["BagSelect"] = "選擇靈魂碎片包",
		["BuffMenu"] = "buff菜單在按鈕左邊",
		["PetMenu"] = "寵物菜單在按鈕左邊",
		["CurseMenu"] = "詛咒菜單在按鈕左邊",
		["STimerLeft"] = "計時器在按鈕左邊",
		["ShowCount"] = "顯示碎片數量",
		["CountType"] = "石頭類型",
		["Circle"] = "圖形顯示",
		["Sound"] = "開啟聲音",
		["ShowMessage"] = "隨機顯示召喚的信息",
		["ShowDemonSummon"] = "激活隨機語言 (惡魔)",
		["ShowSteedSummon"] = "激活隨機語言 (坐騎)",
		["ChatType"] = "宣告Necrosis信息作為係統信息",
		["NecrosisSize"] = "Necrosis按鈕的大小",
		["BanishSize"] = "放逐按鈕大小",
		["TranseSize"] = "暗影冥思和反恐按鈕的大小",
		["Skin"] = "Necrosis球體的皮膚",
		["Show"] = {
			["Firestone"] = "顯示火焰石按鈕",
			["Spellstone"] = "顯示法術石按鈕",
			["Healthstone"] = "顯示治療石按鈕",
			["Soulstone"] = "顯示靈魂石按鈕",
			["Steed"] = "顯示戰馬按鈕",
			["Buff"] = "顯示buff菜單按鈕",
			["Curse"] = "顯示詛咒菜單按鈕",
			["Demon"] = "顯示惡魔召喚菜單按鈕",
			["Summon"] = "顯示召喚儀式按鈕",
			["Tooltips"] = "顯示提示"
		},
		["Count"] = {
			["Shard"] = "靈魂碎片",
			["Inferno"] = "惡魔召喚石",
			["Rez"] = "靈魂石冷卻計時"
		},
        -- added by Sylvette
		["StoneTrade"] = "允許在戰鬥中交易石頭"
	};

end
