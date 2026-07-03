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

function Necrosis_Localization_Dialog_Cn()

	function NecrosisLocalization()
	Necrosis_Localization_Speech_Cn();
	end

	NECROSIS_COOLDOWN = {
		["Spellstone"] = "法术石冷却时间",
		["Healthstone"] = "治疗石冷却时间"
	};

	NecrosisTooltipData = {
		["Main"] = {
			Label = "|c00FFFFFFNecrosis|r",
			Stone = {
				[true] = "是";
				[false] = "否";
			},
			Hellspawn = {
				[true] = "开";
				[false] = "关";
			},
			["Soulshard"] = "灵魂碎片: ",
			["InfernalStone"] = "地狱火石: ",
			["DemoniacStone"] = "恶魔雕像: ",
			["Soulstone"] = "\n灵魂石: ",
			["Healthstone"] = "治疗石: ",
			["Spellstone"] = "法术石: ",
			["Firestone"] = "火焰石: ",
			["CurrentDemon"] = "恶魔: ",
			["EnslavedDemon"] = "恶魔: 奴役",
			["NoCurrentDemon"] = "恶魔 : 无",
		},
		["Soulstone"] = {
			Label = "|c00FF99FF灵魂石|r",
			Text = {"制造","可使用","已使用","等待"}
		},
		["Healthstone"] = {
			Label = "|c0066FF33治疗石|r",
			Text = {"制造","使用"}
		},
		["Spellstone"] = {
			Label = "|c0099CCFF法术石|r",
			Text = {"制造","在包里","装备在副手"}
		},
		["Firestone"] = {
			Label = "|c00FF4444火焰石|r",
			Text = {"制造","在包里","装备在副手"}
		},
		["SpellTimer"] = {
			Label = "|c00FFFFFF法术持续时间|r",
			Text = "启用对目标的法术计时",
			Right = "右键使用炉石到"
		},
		["ShadowTrance"] = {
			Label = "|c00FFFFFF暗影冥思|r"
		},
		["Domination"] = {
			Label = "|c00FFFFFF恶魔支配|r"
		},
		["Enslave"] = {
			Label = "|c00FFFFFF奴役恶魔|r"
		},
		["Armor"] = {
			Label = "|c00FFFFFF魔甲术|r"
		},
		["Invisible"] = {
			Label = "|c00FFFFFF侦测隐形|r"
		},
		["Aqua"] = {
			Label = "|c00FFFFFF魔息术|r"
		},
		["Kilrogg"] = {
			Label = "|c00FFFFFF基尔罗格之眼|r"
		},
		["Banish"] = {
			Label = "|c00FFFFFF放逐术|r"
		},
		["TP"] = {
			Label = "|c00FFFFFF召唤仪式|r"
		},
		["SoulLink"] = {
			Label = "|c00FFFFFF灵魂链接|r"
		},
		["ShadowProtection"] = {
			Label = "|c00FFFFFF防护暗影结界|r"
		},
		["Imp"] = {
			Label = "|c00FFFFFF小鬼|r"
		},
		["Void"] = {
			Label = "|c00FFFFFF虚空行者|r"
		},
		["Succubus"] = {
			Label = "|c00FFFFFF魅魔|r"
		},
		["Fel"] = {
			Label = "|c00FFFFFF地狱猎犬|r"
		},
		["Infernal"] = {
			Label = "|c00FFFFFF地狱火|r"
		},
		["Doomguard"] = {
			Label = "|c00FFFFFF末日守卫|r"
		},
		["Sacrifice"] = {
			Label = "|c00FFFFFF恶魔牺牲|r"
		},
		["Amplify"] = {
			Label = "|c00FFFFFF诅咒增幅|r"
		},
		["Weakness"] = {
			Label = "|c00FFFFFF虚弱诅咒|r"
		},
		["Agony"] = {
			Label = "|c00FFFFFF痛苦诅咒|r"
		},
		["Reckless"] = {
			Label = "|c00FFFFFF鲁莽诅咒|r"
		},
		["Tongues"] = {
			Label = "|c00FFFFFF语言诅咒|r"
		},
		["Exhaust"] = {
			Label = "|c00FFFFFF疲劳诅咒|r"
		},
		["Elements"] = {
			Label = "|c00FFFFFF元素诅咒|r"
		},
		["Shadow"] = {
			Label = "|c00FFFFFF暗影诅咒|r"
		},
		["Doom"] = {
			Label = "|c00FFFFFF厄运诅咒|r"
		},
		["Mount"] = {
			Label = "|c00FFFFFF坐骑|r"
		},
		["Buff"] = {
			Label = "|c00FFFFFF法术菜单|r\n右键打开菜单"
		},
		["Pet"] = {
			Label = "|c00FFFFFF恶魔菜单|r\n右键打开菜单"
		},
		["Curse"] = {
			Label = "|c00FFFFFF诅咒菜单|r\n右键打开菜单"
		},
		["Radar"] = {
			Label = "|c00FFFFFF感知恶魔|r"
		},
		["AmplifyCooldown"] = "右键诅咒增幅",
		["DominationCooldown"] = "右键快速召唤",
		["LastSpell"] = "左键施放",
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
		["NoBoltSpell"] = "你好像没有暗影箭法术。",
		["Message"] = "<white>暗<lightPurple1>影<lightPurple2>冥<purple>思<darkPurple1>！<darkPurple2>暗<darkPurple1>影<purple>冥<lightPurple2>思<lightPurple1>！<white>！"
	};


	NECROSIS_MESSAGE = {
		["Error"] = {
			["InfernalStoneNotPresent"] = "你需要地狱火石!",
			["SoulShardNotPresent"] = "你需要灵魂碎片!",
			["DemoniacStoneNotPresent"] = "你需要恶魔雕像!",
			["NoRiding"] = "你没有任何战马!",
			["NoFireStoneSpell"] = "你无制造火焰石法术",
			["NoSpellStoneSpell"] = "你无制造法术石法术",
			["NoHealthStoneSpell"] = "你无制造治疗石法术",
			["NoSoulStoneSpell"] = "你无制造灵魂石法术",
			["FullHealth"] = "当你未少血时不能使用治疗石",
			["BagAlreadySelect"] = "错误: 这个包已经被选择。",
			["WrongBag"] = "错误: 这个数必须在0至4之间。",
			["BagIsNumber"] = "错误: 请输入一个数。",
			["NoHearthStone"] = "错误: 你的包中没有任何治疗石。"
		},
		["Bag"] = {
			["FullPrefix"] = "你的 ",
			["FullSuffix"] = " 满了 !",
			["FullDestroySuffix"] = " 满了; 下个碎片将被摧毁!",
			["SelectedPrefix"] = "你选择你的",
			["SelectedSuffix"] = "放你的灵魂碎片。"
		},
		["Interface"] = {
			["Welcome"] = "<white>/necro 显示设置菜单!",
			["TooltipOn"] = "打开提示" ,
			["TooltipOff"] = "关闭提示",
			["MessageOn"] = "打开聊天信息通知",
			["MessageOff"] = "关闭聊天信息通知",
			["MessagePosition"] = "<- 这儿将显示Necrosis的信息 ->",
			["DefaultConfig"] = "<lightYellow>默认配置已加载。",
			["UserConfig"] = "<lightYellow>配置已加载。",
			["CurseSelection"] = " 选择作为默认。使用'施放选择反诅咒' 按键绑定施放它。",
			["CurseAmplify"] = "<lightYellow>当可能施放的时候诅咒增幅将触发。",
			["CursePetAttack"] = "<lightYellow>施放默认的诅咒将使你的宠物攻击。"
		},
		["Help"] = {
			"/necro recall -- 将Necrosis和所有按钮置于屏幕中间",
			"/necro sm -- 用a short raid-ready version代替灵魂绑定和召唤信息"
		},
		["EquipMessage"] = "装备",
		["SwitchMessage"] = "代替",
		["Information"] = {
			["FearProtect"] = "你的目标对恐惧免疫!!!!",
			["EnslaveBreak"] = "恶魔摆脱奴役...",
			["SoulstoneEnd"] = "<lightYellow>你的灵魂石失效。"
		}
	};


	-- Gestion XML - Menu de configuration

	NECROSIS_COLOR_TOOLTIP = {
		["Purple"] = "紫色",
		["Blue"] = "蓝色",
		["Pink"] = "粉红色",
		["Orange"] = "橙色",
		["Turquoise"] = "青绿色",
		["X"] = "X"
	};
	
	NECROSIS_CONFIGURATION = {
		["CriticalDamageWarning"] = "致命一击声音提示。",
		["Channel"] = "信息频道",
		["Menu1"] = "碎片设置",
		["Menu2"] = "信息设置",
		["Menu3"] = "按钮设置",
		["Menu4"] = "计时器设置",
		["Menu5"] = "图像设置",
		["MainRotation"] = "Necrosis角度选择",
		["ShardMenu"] = "|CFFB700B7背包|CFFB700B7 :",--"|CFFB700B7I|CFFFF00FFn|CFFFF50FFv|CFFFF99FFe|CFFFFC4FFn|CFFFF99FFt|CFFFF50FFo|CFFFF00FFr|CFFB700B7y :",
		["ShardMenu2"] = "|CFFB700B7碎片|CFFB700B7 :",--"|CFFB700B7S|CFFFF00FFh|CFFFF50FFa|CFFFF99FFr|CFFFFC4FFd C|CFFFF99FFo|CFFFF50FFu|CFFFF00FFn|CFFB700B7t :",
		["ShardMove"] = "将碎片放入选择的包。",
		["ShardDestroy"] = "如果包满摧毁所有新的碎片。",
		["SpellMenu1"] = "|CFFB700B7法术|CFFFFC4FF :",--"|CFFB700B7S|CFFFF00FFp|CFFFF50FFe|CFFFF99FFl|CFFFFC4FFls :",
		["SpellMenu2"] = "|CFFB700B7玩家|CFFFF99FF :",		
		["TimerMenu"] = "|CFFB700B7图形计时器|CFFFF99FF :",--"|CFFB700B7G|CFFFF00FFr|CFFFF50FFa|CFFFF99FFp|CFFFFC4FFh|CFFFF99FFi|CFFFF50FFc|CFFFF00FFa|CFFB700B7l T|CFFFF00FFi|CFFFF50FFm|CFFFF99FFe|CFFFFC4FFrs :",
		["TimerColor"] = "显示计时器文字为白色(代替黄色)",
		["TimerDirection"] = "计时器向上升",
		["TranseWarning"] = "当我获得暗影冥思效果时提醒我。",
		["SpellTime"] = "打开法术计时器。",
		["AntiFearWarning"] = "当我的目标免疫恐惧时提醒我。",
		["ShadowVulnerabilityWarning"] = "当我的目标有暗影弱点时提醒我。",
		["GraphicalTimer"] = "显示图形计时器",	
		["TranceButtonView"] = "显示隐藏的按钮以拖动它。",
		["ButtonLock"] = "锁定 Necrosis球体周围的按钮。",
		["MainLock"] = "锁定 Necrosis球体及周围的按钮。",
		["BagSelect"] = "选择灵魂碎片包",
		["BuffMenu"] = "buff菜单在按钮左边",
		["PetMenu"] = "宠物菜单在按钮左边",
		["CurseMenu"] = "诅咒菜单在按钮左边",
		["STimerLeft"] = "计时器在按钮左边",
		["ShowCount"] = "显示碎片数量",
		["CountType"] = "石头类型",
		["Circle"] = "图形显示",
		["Sound"] = "开启声音",
		["ShowMessage"] = "随机显示召唤的信息",
		["ShowDemonSummon"] = "激活随机语言 (恶魔)",
		["ShowSteedSummon"] = "激活随机语言 (坐骑)",
		["ChatType"] = "宣告Necrosis信息作为系统信息",
		["NecrosisSize"] = "Necrosis按钮的大小",
		["BanishSize"] = "放逐按钮大小",
		["TranseSize"] = "暗影冥思和反恐按钮的大小",
		["Skin"] = "Necrosis球体的皮肤",
		["Show"] = {
			["Firestone"] = "显示火焰石按钮",
			["Spellstone"] = "显示法术石按钮",
			["Healthstone"] = "显示治疗石按钮",
			["Soulstone"] = "显示灵魂石按钮",
			["Steed"] = "显示战马按钮",
			["Buff"] = "显示buff菜单按钮",
			["Curse"] = "显示诅咒菜单按钮",
			["Demon"] = "显示恶魔召唤菜单按钮",
			["Summon"] = "显示召唤仪式按钮",
			["Tooltips"] = "显示提示"
		},
		["Count"] = {
			["Shard"] = "灵魂碎片",
			["Inferno"] = "恶魔召唤石",
			["Rez"] = "灵魂石冷却计时"
		},
        -- added by Sylvette
		["StoneTrade"] = "允许在战斗中交易石头"
	};

end
