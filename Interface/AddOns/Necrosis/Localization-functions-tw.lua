------------------------------------------------------------------------------------------------------
-- Necrosis LdC
--
-- Cr閍teur initial (US) : Infernal (http://www.revolvus.com/games/interface/necrosis/)
-- Impl閙entation de base (FR) : Tilienna Thorondor
-- Reprise du projet : Lomig & Nyx des Larmes de Cenarius, Kael'Thas
--
-- Skins et voix Fran鏰ises : Eliah, Ner'zhul
-- Version Allemande par Arne Meier et Halisstra, Lothar
-- Remerciements sp閏iaux pour Sadyre (JoL)
-- Version 06.05.2006-1
------------------------------------------------------------------------------------------------------



------------------------------------------------
-- ENGLISH  VERSION FUNCTIONS --
------------------------------------------------

if ( GetLocale() == "zhTW" ) then

NECROSIS_UNIT_WARLOCK = "術士";

-- sylvette added ScaledLifeTap by Kimilly (Kimilly)
SCALEDLIFETAP_LIFETAPSPELL = "生命分流";
SCALEDLIFETAP_LIFETAPTALENT = "增強生命分流";
SCALEDLIFETAP_RANKTEXT = "等級";
SCALEDLIFETAP_RANKREGEXP = "^" .. SCALEDLIFETAP_RANKTEXT .. " (.*).*";

NECROSIS_ANTI_FEAR_SPELL = {
	-- Buffs giving temporary immunity to fear effects
	["Buff"] = {
		"恐懼防護結界",			-- Dwarf priest racial trait
		"不死族意志",		-- Forsaken racial trait
		"反恐懼",			-- Trinket
		"狂怒",		-- Warrior Fury talent
		"魯莽",			-- Warrior Fury talent
		"死亡之愿",			-- Warrior Fury talent
		"狂野怒火",		-- Hunter Beast Mastery talent (pet only)
		"寒冰屏障",			-- Mage Ice talent
		"聖佑術",		-- Paladin Holy buff
		"聖盾術",		-- Paladin Holy buff
		"戰栗圖騰",			-- Shaman totem
		"廢除魔法"			-- Majordomo (NPC) spell
		--  "Grounding Totem" is not considerated, as it can remove other spell than fear, and only one each 10 sec.		
	},

	-- Debuffs and curses giving temporary immunity to fear effects
	["Debuff"] = {
		"魯莽詛咒"		-- Warlock curse
	}
};

-- Creature type absolutly immune to fear effects
NECROSIS_ANTI_FEAR_UNIT = {
	"不死族"
};

-- Word to search for spell immunity. First (.+) replace the spell's name, 2nd (.+) replace the creature's name
NECROSIS_ANTI_FEAR_SRCH = "你的(.+)施放失敗。(.+)對此免疫。";

NECROSIS_SPELL_TABLE = {
	[1] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召喚地獄戰馬",		Length = 0,	Type = 0,   TexturePrefix = nil},
	[2] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil, 
		Name = "召喚恐懼戰馬",		Length = 0,	Type = 0,   TexturePrefix = nil},
	[3] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召喚小鬼",			Length = 0,	Type = 0,   TexturePrefix = "Imp"},
	[4] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召喚虛空行者",		Length = 0,	Type = 0,   TexturePrefix = "Voidwalker"},
	[5] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召喚魅魔",		Length = 0,	Type = 0,   TexturePrefix = "Succubus"},
	[6] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召喚地獄獵犬",		Length = 0,	Type = 0,   TexturePrefix = "Felhunter"},
	[7] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "暗影箭",			Length = 0,	Type = 0,   TexturePrefix = nil},
	[8] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "地獄火",			Length = 3600,	Type = 3,   TexturePrefix = "Infernal"},
	[9] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "放逐術",			Length = 30,	Type = 2,   TexturePrefix = "Banish"},
	[10] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "奴役惡魔",			Length = 30000,	Type = 2,   TexturePrefix = nil},
	[11] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "靈魂石復活",	Length = 1800,	Type = 1,   TexturePrefix = nil},
	[12] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "獻祭",			Length = 15,	Type = 5,   TexturePrefix = nil},
	[13] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恐懼術",				Length = 15,	Type = 5,   TexturePrefix = nil},
	[14] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "腐蝕術",			Length = 17,	Type = 5,   TexturePrefix = nil},
	[15] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "惡魔支配",		Length = 900,	Type = 3,   TexturePrefix = "Domination"},
	[16] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "厄運詛咒",			Length = 60,	Type = 3,   TexturePrefix = "Doom"},
	[17] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "犧牲",			Length = 30,	Type = 3,   TexturePrefix = nil},
	[18] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "靈魂之火",			Length = 60,	Type = 3,   TexturePrefix = nil},
	[19] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "死亡纏繞",			Length = 120,	Type = 3,   TexturePrefix = nil},
	[20] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "暗影灼燒",			Length = 15,	Type = 3,   TexturePrefix = nil},
	[21] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "燃燒",			Length = 10,	Type = 3,   TexturePrefix = nil},
	[22] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "痛苦詛咒",		Length = 24,	Type = 4,   TexturePrefix = "Agony"},
	[23] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "虛弱詛咒",		Length = 120,	Type = 4,   TexturePrefix = "Weakness"},
	[24] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "魯莽詛咒",		Length = 120,	Type = 4,   TexturePrefix = "Reckless"},
	[25] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "語言詛咒",		Length = 30,	Type = 4,   TexturePrefix = "Tongues"},
	[26] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "元素詛咒",		Length = 300,	Type = 4,   TexturePrefix = "Elements"},
	[27] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "暗影詛咒",		Length = 300,	Type = 4,   TexturePrefix = "Shadow"},
	[28] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "生命虹吸",			Length = 30,	Type = 5,   TexturePrefix = nil},
	[29] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恐懼嚎叫",		Length = 40,	Type = 3,   TexturePrefix = nil},
	[30] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "末日儀式",		Length = 3600,	Type = 0,   TexturePrefix = "Doomguard"},
	[31] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "魔甲術",			Length = 0,	Type = 0,   TexturePrefix = "ArmureDemo"},
	[32] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "魔息術",		Length = 0,	Type = 0,   TexturePrefix = "Aqua"},
	[33] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "隱形",			Length = 0,	Type = 0,   TexturePrefix = "Invisible"},
	[34] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "基爾羅格之眼",		Length = 0,	Type = 0,   TexturePrefix = "Kilrogg"},
	[35] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "奴役惡魔",			Length = 0,	Type = 0,   TexturePrefix = "Enslave"},
	[36] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "惡魔皮膚",			Length = 0,	Type = 0,   TexturePrefix = nil},
	[37] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召喚儀式",		Length = 0,	Type = 0,   TexturePrefix = nil},
	[38] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "靈魂鏈接",			Length = 0,	Type = 0,   TexturePrefix = "Lien"},
	[39] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "感知惡魔",			Length = 0,	Type = 0,   TexturePrefix = "Radar"},
	[40] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "疲勞詛咒",		Length = 12,	Type = 4,   TexturePrefix = "Exhaust"},
	[41] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "生命分流",			Length = 0,	Type = 0,   TexturePrefix = nil},
	[42] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "詛咒增幅",			Length = 180,	Type = 3,   TexturePrefix = "Amplify"},
	[43] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "防護暗影結界",			Length = 30,	Type = 3,   TexturePrefix = "ShadowWard"},
	[44] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "惡魔犧牲",		Length = 0,	Type = 0,   TexturePrefix = "Sacrifice"},
};
-- Type 0 = No Timer
-- Type 1 = Main permanent Timer
-- Type 2 = Permanent Timer
-- Type 3 = Timer of cooldown
-- Type 4 = Timer of maldiction
-- Type 5 = Timer of fight

NECROSIS_ITEM = {
	["Soulshard"] = "靈魂碎片",
	["Soulstone"] = "靈魂石",
	["Healthstone"] = "治療石",
	["Spellstone"] = "法術石",
	["Firestone"] = "火焰石",
	["Offhand"] = "裝備在副手",
	["Twohand"] = "雙手",
	["InfernalStone"] = "地獄火石",
	["DemoniacStone"] = "惡魔雕像",
	["Hearthstone"] = "爐石",
	["SoulPouch"] = {"靈魂袋", "惡魔布包", "熔火惡魔布包"}	
};


NECROSIS_STONE_RANK = {
	[1] = "初級",		-- Rank Minor
	[2] = "次級",		-- Rank Lesser
	[3] = "",		-- Rank Intermediate, no name
	[4] = "強效",	-- Rank Greater
	[5] = "特效"		-- Rank Major
};

NECROSIS_NIGHTFALL = {
	["BoltName"] = "箭",
	["ShadowTrance"] = "暗影冥思"
};

NECROSIS_STONE_CREATE = "制造";
NECROSIS_CREATE = {
	[1] = "靈魂石",
	[2] = "治療石",
	[3] = "法術石",
	[4] = "火焰石"
};

NECROSIS_PET_LOCAL_NAME = {
	[1] = "小鬼",
	[2] = "虛空行者",
	[3] = "魅魔",
	[4] = "地獄獵犬",
	[5] = "地獄火",
	[6] = "末日守衛"
};

NECROSIS_TRANSLATION = {
	["Cooldown"] = "冷卻時間",
	["Hearth"] = "爐石",
	["Rank"] = "等級",
	["Mana"] = "法力",
	["Invisible"] = "偵測隱形",
	["LesserInvisible"] = "偵測次級隱形",
	["GreaterInvisible"] = "偵測強效隱形",
	["SoulLinkGain"] = "你獲得了靈魂鏈接的效果。",
	["SacrificeGain"] = "你獲得了犧牲的效果。",
	["SummoningRitual"] = "召喚儀式"
};
NECROSIS_PLAYER_OFFLINE = "離線";
NECROSIS_PARSECRITICALDAMAGE = "你的(.+)致命一擊對(.+)造成(%d+)點";
NECROSIS_PARSESPELLCASTFAILED = "你的(.+)施放失敗。(.+)對此免疫。";
NECROSIS_CHANNELNAME = {"說","大喊","小隊","團隊","公會"};
NECROSIS_TARGET_DEAD = "(.+)死亡了";
NECROSIS_MOUNTITEMNAME_KEYWORD = "紫色骷髏戰馬";
NECROSIS_MOUNTITEMDESCRIPTION_KEYWORD = "可供騎乘";
NECROSIS_SUMMONALERT = "目標太近！！！";
end
