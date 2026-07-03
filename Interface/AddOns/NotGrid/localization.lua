local L = AceLibrary("AceLocale-2.2"):new("NotGrid")

L:RegisterTranslations("enUS", function()
	return {
		["Dead"] = true,
		["Ghost"] = true,
		["Scroll Me!"] = true,

		["Unit Width"] = true,
		["Unit Height"] = true,
		["Unit Border"] = true,
		["Unit Padding"] = true,
		["Font"] = true,
		["Texture"] = true,
		["Name Color"] = true,
		["Name Size"] = true,
		["Name Length"] = true,
		["Health Color"] = true,
		["Health Threshold"] = true,
		["Highlight Target"] = true,
		["Aggro Warning"] = true,
		["Mana Warning"] = true,
		["Healcomm Bar"] = true,
		["Healcomm Text"] = true,
		["Top Left Icon"] = true,
		["Top Icon"] = true,
		["Top Right Icon"] = true,
		["Right Icon"] = true,
		["Bottom Right Icon"] = true,
		["Bottom Icon"] = true,
		["Bottom Left Icon"] = true,
		["Left Icon"] = true,
		["Icon Size"] = true,
		["Proximity Leeway"] = true,
		["Use Map Proximity"] = true,
		["Smart Center"] = true,
		["Show While Solo"] = true,
		["Show In Party"] = true,
		["Show Party In Raid"] = true,
		["Disable Tooltip In Combat"] = true,
		["Health Orientation"] = true,
		["Show Blizz Frames"] = true,
		["Growth Direction"] = true,
		["Show Power Bar"] = true,
		["Power Position"] = true,
		["Power Size"] = true,
		["Config Mode"] = true,
		["Background"] = true,
		["Show Pets"] = true,
		["Custom Pet Color"] = true,
		["TBC Shaman Color"] = true,
		["Proximity Rate"] = true,
		["Health Background"] = true,
		["Clique Hook"] = true,
		["Power Background"] = true,
		["Position"] = true,
		["Border Artwork"] = true,
		["Name Position"] = true,
		["Healcomm Text Position"] = true,
		["Version Checking"] = true,
		["Draggable"] = true,

		["CombatEvents"] = {
			["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS"] = "(%a+) gains %a.+", --%a on the last just to make sure its not a digit
			["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = "(%a+) is afflicted by .+",
			["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"] = "(%a+) gains %a.+",
			["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = "(%a+) is afflicted by .+",

			["CHAT_MSG_SPELL_PARTY_BUFF"] = "(%a+) begins .+", --I don't get this message for party members? Only friendly?
			["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"] = "(%a+) begins .+",
			["CHAT_MSG_SPELL_PARTY_DAMAGE"] = "(%a+) begins .+",
			["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"] = "(%a+) begins .+",

			["CHAT_MSG_SPELL_AURA_GONE_PARTY"] = ".+ fades from (%a+)%.",
			["CHAT_MSG_SPELL_AURA_GONE_OTHER"] = ".+ fades from (%a+)%.", -- will pick up hostile fades as well as freind, but I won't have them in rosterlib so whatevs

			["CHAT_MSG_SPELL_SELF_BUFF"] = "Your .+ heals (%a+) for .+"
		},

		--------------
		-- Tooltips --
		--------------

		["pet_tooltip"] = "Note: Prone to visual errors.",
		["classcolor_tooltip"] = "Toggle for class color.",
		["smartcenter_tooltip"] = "As your group expands the frames stay horizontally centered on the original group placement.",
		["healththreshold_tooltip"] = "Health percentage before name is replaced with health deficit.",
		["manathreshhold_tooltip"] = "Mana percentage before border color changes.",
		["proximityleeway_tooltip"] = "Amount of seconds to be considered \"In Range\" after a positive confirmation.",
		["proximityrate_tooltip"] = "Amount of seconds between proximity checks.",
		["cliquehook_tooltip"] = "Hooks the Clique spellcast function to use NG instead for proximity checking beyond 28 yards within instances. Toggling will reload UI.",
		["powercolor_tooltip"] = "Toggle for power color.",
		["position_tooltip"] = "Shift+Ctrl = 100\nShift = 10",
		["draggable_tooltip"] = "Note: Possible client crash bug\n           Smart Center disabled",
		["icon_tooltip"] = "Toggle to invert icon display.",


	}
end)

L:RegisterTranslations("ruRU", function()
	return {
		["Dead"] = "Мертв",
		["Ghost"] = "Призрак",
		["Scroll Me!"] = "Прокрути меня!",

		["Unit Width"] = "Ширина рамок",
		["Unit Height"] = "Высота рамок",
		["Unit Border"] = "Бордюр рамок",
		["Unit Padding"] = "Интервал рамок",
		["Font"] = "Шрифт",
		["Texture"] = "Текстура",
		["Name Color"] = "Цвет имени",
		["Name Size"] = "Размер имени",
		["Name Length"] = "Длина имени",
		["Health Color"] = "Цвет здоровья",
		["Health Threshold"] = "Порог здоровья",
		["Highlight Target"] = "Выделение цели",
		["Aggro Warning"] = "Предупреждение аггро",
		["Mana Warning"] = "Предупреждение маны",
		["Healcomm Bar"] = "Полоса входящего исцеления",
		["Healcomm Text"] = "Текст входящего исцеления",
		["Top Left Icon"] = "Иконка сверху слева",
		["Top Icon"] = "Иконка сверху",
		["Top Right Icon"] = "Иконка сверху справа",
		["Right Icon"] = "Иконка справа",
		["Bottom Right Icon"] = "Иконка снизу справа",
		["Bottom Icon"] = "Иконка снизу",
		["Bottom Left Icon"] = "Иконка снизу слева",
		["Left Icon"] = "Иконка слева",
		["Icon Size"] = "Размер иконки",
		["Proximity Leeway"] = "Proximity Leeway", --
		["Use Map Proximity"] = "Использовать карту приближения",
		["Smart Center"] = "Умный центр",
		["Show While Solo"] = "Показать вне группы",
		["Show In Party"] = "Показать в группе",
		["Show Party In Raid"] = "Показать группы в рейде",
		["Disable Tooltip In Combat"] = "Отключить всплывающую подсказку в бою",
		["Health Orientation"] = "Ориентация здоровья",
		["Show Blizz Frames"] = "Показать окна Blizzard",
		["Growth Direction"] = "Направление роста",
		["Show Power Bar"] = "Показать полосу силы",
		["Power Position"] = "Позиция полосы силы",
		["Power Size"] = "Размер полосы силы",
		["Config Mode"] = "Режим настройки",
		["Background"] = "Задний фон",
		["Show Pets"] = "Показать питомцев",
		["Custom Pet Color"] = "Пользовательский цвет питомца",
		["TBC Shaman Color"] = "Пользовательский цвет шамана - TBC",
		["Proximity Rate"] = "Коэффициент близости",
		["Health Background"] = "фон здоровья",
		["Clique Hook"] = true,
		["Power Background"] = true,
		["Position"] = true,
		["Border Artwork"] = true,
		["Name Position"] = true,
		["Healcomm Text Position"] = true,
		["Version Checking"] = true,
		["Draggable"] = true,

		["CombatEvents"] = {
			["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS"] = "(%a+) получает эффект %a.+",
			["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = "(%a+) находится под воздействием эффекта .+",
			["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"] = "(%a+) получает эффект %a.+",
			["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = "(%a+) находится под воздействием эффекта .+",

			["CHAT_MSG_SPELL_PARTY_BUFF"] = "(%a+) начинает .+",
			["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"] = "(%a+) начинает .+",
			["CHAT_MSG_SPELL_PARTY_DAMAGE"] = "(%a+) начинает .+",
			["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"] = "(%a+) начинает .+",

			["CHAT_MSG_SPELL_AURA_GONE_PARTY"] = "Действие эффекта \".+\", наложенного на (%a+), заканчивается%.",
			["CHAT_MSG_SPELL_AURA_GONE_OTHER"] = "Действие эффекта \".+\", наложенного на (%a+), заканчивается%.",

			["CHAT_MSG_SPELL_SELF_BUFF"] = "Ваше заклинание \".+\" исцеляет (%a+) на .+"
		},

		--------------
		-- Tooltips --
		--------------

		["pet_tooltip"] = "Примечание: подвержен визуальным ошибкам.",
		["classcolor_tooltip"] = "Вкл.\\Выкл. цвет класса",
		["smartcenter_tooltip"] = true,
		["healththreshold_tooltip"] = "Процент здоровья перед именем заменяется дефицитом здоровья.",
		["manathreshhold_tooltip"] = "Процент маны до изменения цвета бордюра.",
		["proximityleeway_tooltip"] =
		"Количество секунд, которое будет учитывать \"в пределах досягаемости\" после положительного заклинания или подтверждения боевого журнала.",
		["proximityrate_tooltip"] = "Количество секунд между проверками близости.",
		["cliquehook_tooltip"] =
		"Hooks the Clique spellcast function to use NG instead for proximity checking beyond 28 yards within instances. Toggling will reload UI.",
		["powercolor_tooltip"] = true,
		["position_tooltip"] = "Shift+Ctrl = 100\nShift = 10",
		["draggable_tooltip"] = true,

	}
end)

L:RegisterTranslations("zhCN", function()
	return {
		["Dead"] = "死亡",
		["Ghost"] = "鬼魂",
		["Scroll Me!"] = "往下滑更多选项",

		["Unit Width"] = "框架宽度",
		["Unit Height"] = "框架高度",
		["Unit Border"] = "框架边框",
		["Unit Padding"] = "框架填充",
		["Font"] = "字体",
		["Texture"] = "纹理",
		["Name Color"] = "名字颜色",
		["Name Size"] = "名字大小",
		["Name Length"] = "名字长度",
		["Health Color"] = "血量颜色",
		["Health Threshold"] = "血量阈值",
		["Highlight Target"] = "高亮目标",
		["Aggro Warning"] = "仇恨警报",
		["Mana Warning"] = "法力低警报",
		["Healcomm Bar"] = "治疗预估",
		["Healcomm Text"] = "治疗预估文本",
		["Top Left Icon"] = "左上角图标",
		["Top Icon"] = "上图标",
		["Top Right Icon"] = "右上图标",
		["Right Icon"] = "右图标",
		["Bottom Right Icon"] = "右下图标",
		["Bottom Icon"] = "下图标",
		["Bottom Left Icon"] = "左下图标",
		["Left Icon"] = "左图标",
		["Icon Size"] = "图标大小",
		["Proximity Leeway"] = "同步刷新速度",
		["Use Map Proximity"] = "使用靠近地图",
		["Smart Center"] = "智能中心",
		["Show While Solo"] = "单人显示框架",
		["Show In Party"] = "队伍中显示框架",
		["Show Party In Raid"] = "在团队中显示小队",
		["Disable Tooltip In Combat"] = "战斗中不显示鼠标提示",
		["Health Orientation"] = "排列方向",
		["Show Blizz Frames"] = "显示暴雪框架",
		["Growth Direction"] = "生长方向",
		["Show Power Bar"] = "显示能量/怒气/蓝条",
		["Power Position"] = "能量位置",
		["Power Size"] = "能量大小",
		["Config Mode"] = "配置模式",
		["Background"] = "背景",
		["Show Pets"] = "显示宠物",
		["Custom Pet Color"] = "自定义宠物颜色",
		["TBC Shaman Color"] = "萨满使用蓝色血条",
		["Proximity Rate"] = "接近率",
		["Health Background"] = "血量背景",
		["Clique Hook"] = "Clique Hook",
		["Power Background"] = "能量背景",
		["Position"] = "位置",
		["Border Artwork"] = "艺术边框",
		["Name Position"] = "名字位置",
		["Healcomm Text Position"] = "治疗预估文本位置",
		["Version Checking"] = "版本检查",
		["Draggable"] = "拖拽",

		["CombatEvents"] = {
			["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS"] = "(%a+)获得了%a.+的效果", --%a on the last just to make sure its not a digit
			["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = "(%a+)受到了.+效果的影响",
			["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"] = "(%a+)获得了%a.+",
			["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = "(%a+)受到了.+效果的影响",

			["CHAT_MSG_SPELL_PARTY_BUFF"] = "(%a+)开始.+", --I don't get this message for party members? Only friendly?
			["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"] = "(%a+)开始.+",
			["CHAT_MSG_SPELL_PARTY_DAMAGE"] = "(%a+)开始.+",
			["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"] = "(%a+)开始.+",

			["CHAT_MSG_SPELL_AURA_GONE_PARTY"] = ".+效果从(%a+)身上消失。",
			["CHAT_MSG_SPELL_AURA_GONE_OTHER"] = ".+效果从(%a+)身上消失。", -- will pick up hostile fades as well as freind, but I won't have them in rosterlib so whatevs

			["CHAT_MSG_SPELL_SELF_BUFF"] = "你的.+治疗了(%a+).+点生命值。"
		},

		--------------
		-- Tooltips --
		--------------

		["pet_tooltip"] = "容易出现视觉错误。",
		["classcolor_tooltip"] = "Toggle for class color.",
		["smartcenter_tooltip"] =
		"As your group expands the frames stay horizontally centered on the original group placement.",
		["healththreshold_tooltip"] = "Health percentage before name is replaced with health deficit.",
		["manathreshhold_tooltip"] = "Mana percentage before border color changes.",
		["proximityleeway_tooltip"] = "Amount of seconds to be considered \"In Range\" after a positive confirmation.",
		["proximityrate_tooltip"] = "Amount of seconds between proximity checks.",
		["cliquehook_tooltip"] =
		"Hooks the Clique spellcast function to use NG instead for proximity checking beyond 28 yards within instances. Toggling will reload UI.",
		["powercolor_tooltip"] = "Toggle for power color.",
		["position_tooltip"] = "Shift+Ctrl = 100\nShift = 10",
		["draggable_tooltip"] = "游戏可能会崩溃，不要在战斗中拖拽\n最好关闭，并使用位置功能来移动框架。",
		["icon_tooltip"] = "开启反向显示",
	}
end)
