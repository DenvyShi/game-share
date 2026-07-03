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

if ( GetLocale() == "zhCN" ) then

NECROSIS_UNIT_WARLOCK = "术士";

-- sylvette added ScaledLifeTap by Kimilly (Kimilly)
SCALEDLIFETAP_LIFETAPSPELL = "生命分流";
SCALEDLIFETAP_LIFETAPTALENT = "增强生命分流";
SCALEDLIFETAP_RANKTEXT = "等级";
SCALEDLIFETAP_RANKREGEXP = "^" .. SCALEDLIFETAP_RANKTEXT .. " (.*).*";

NECROSIS_ANTI_FEAR_SPELL = {
	-- Buffs giving temporary immunity to fear effects
	["Buff"] = {
		"恐惧防护结界",			-- Dwarf priest racial trait
		"亡灵意志",		-- Forsaken racial trait
		"反恐惧",			-- Trinket
		"狂怒",		-- Warrior Fury talent
		"鲁莽",			-- Warrior Fury talent
		"死亡之愿",			-- Warrior Fury talent
		"狂野怒火",		-- Hunter Beast Mastery talent (pet only)
		"寒冰屏障",			-- Mage Ice talent
		"圣佑术",		-- Paladin Holy buff
		"圣盾术",		-- Paladin Holy buff
		"战栗图腾",			-- Shaman totem
		"废除魔法"			-- Majordomo (NPC) spell
		--  "Grounding Totem" is not considerated, as it can remove other spell than fear, and only one each 10 sec.		
	},

	-- Debuffs and curses giving temporary immunity to fear effects
	["Debuff"] = {
		"鲁莽诅咒"		-- Warlock curse
	}
};

-- Creature type absolutly immune to fear effects
NECROSIS_ANTI_FEAR_UNIT = {
	"亡灵"
};

-- Word to search for spell immunity. First (.+) replace the spell's name, 2nd (.+) replace the creature's name
NECROSIS_ANTI_FEAR_SRCH = "你的(.+)施放失败。(.+)对此免疫。";

NECROSIS_SPELL_TABLE = {
	[1] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召唤地狱战马",		Length = 0,	Type = 0,   TexturePrefix = nil},
	[2] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil, 
		Name = "召唤恐惧战马",		Length = 0,	Type = 0,   TexturePrefix = nil},
	[3] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召唤小鬼",			Length = 0,	Type = 0,   TexturePrefix = "Imp"},
	[4] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召唤虚空行者",		Length = 0,	Type = 0,   TexturePrefix = "Voidwalker"},
	[5] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召唤魅魔",		Length = 0,	Type = 0,   TexturePrefix = "Succubus"},
	[6] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召唤地狱猎犬",		Length = 0,	Type = 0,   TexturePrefix = "Felhunter"},
	[7] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "暗影箭",			Length = 0,	Type = 0,   TexturePrefix = nil},
	[8] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "地狱火",			Length = 3600,	Type = 3,   TexturePrefix = "Infernal"},
	[9] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "放逐术",			Length = 30,	Type = 2,   TexturePrefix = "Banish"},
	[10] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "奴役恶魔",			Length = 30000,	Type = 2,   TexturePrefix = nil},
	[11] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "灵魂石复活",	Length = 1800,	Type = 1,   TexturePrefix = nil},
	[12] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "献祭",			Length = 15,	Type = 5,   TexturePrefix = nil},
	[13] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恐惧术",				Length = 15,	Type = 5,   TexturePrefix = nil},
	[14] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "腐蚀术",			Length = 17,	Type = 5,   TexturePrefix = nil},
	[15] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恶魔支配",		Length = 900,	Type = 3,   TexturePrefix = "Domination"},
	[16] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "厄运诅咒",			Length = 60,	Type = 3,   TexturePrefix = "Doom"},
	[17] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "牺牲",			Length = 30,	Type = 3,   TexturePrefix = nil},
	[18] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "灵魂之火",			Length = 60,	Type = 3,   TexturePrefix = nil},
	[19] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "死亡缠绕",			Length = 120,	Type = 3,   TexturePrefix = nil},
	[20] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "暗影灼烧",			Length = 15,	Type = 3,   TexturePrefix = nil},
	[21] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "燃烧",			Length = 10,	Type = 3,   TexturePrefix = nil},
	[22] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "痛苦诅咒",		Length = 24,	Type = 4,   TexturePrefix = "Agony"},
	[23] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "虚弱诅咒",		Length = 120,	Type = 4,   TexturePrefix = "Weakness"},
	[24] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "鲁莽诅咒",		Length = 120,	Type = 4,   TexturePrefix = "Reckless"},
	[25] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "语言诅咒",		Length = 30,	Type = 4,   TexturePrefix = "Tongues"},
	[26] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "元素诅咒",		Length = 300,	Type = 4,   TexturePrefix = "Elements"},
	[27] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "暗影诅咒",		Length = 300,	Type = 4,   TexturePrefix = "Shadow"},
	[28] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "生命虹吸",			Length = 30,	Type = 5,   TexturePrefix = nil},
	[29] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恐惧嚎叫",		Length = 40,	Type = 3,   TexturePrefix = nil},
	[30] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "末日仪式",		Length = 3600,	Type = 0,   TexturePrefix = "Doomguard"},
	[31] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "魔甲术",			Length = 0,	Type = 0,   TexturePrefix = "ArmureDemo"},
	[32] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "魔息术",		Length = 0,	Type = 0,   TexturePrefix = "Aqua"},
	[33] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "隐形",			Length = 0,	Type = 0,   TexturePrefix = "Invisible"},
	[34] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "基尔罗格之眼",		Length = 0,	Type = 0,   TexturePrefix = "Kilrogg"},
	[35] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "奴役恶魔",			Length = 0,	Type = 0,   TexturePrefix = "Enslave"},
	[36] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恶魔皮肤",			Length = 0,	Type = 0,   TexturePrefix = nil},
	[37] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "召唤仪式",		Length = 0,	Type = 0,   TexturePrefix = nil},
	[38] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "灵魂链接",			Length = 0,	Type = 0,   TexturePrefix = "Lien"},
	[39] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "感知恶魔",			Length = 0,	Type = 0,   TexturePrefix = "Radar"},
	[40] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "疲劳诅咒",		Length = 12,	Type = 4,   TexturePrefix = "Exhaust"},
	[41] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "生命分流",			Length = 0,	Type = 0,   TexturePrefix = nil},
	[42] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "诅咒增幅",			Length = 180,	Type = 3,   TexturePrefix = "Amplify"},
	[43] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "防护暗影结界",			Length = 30,	Type = 3,   TexturePrefix = "ShadowWard"},
	[44] = {ID = nil, Rank = nil, CastTime = nil, Mana = nil,
		Name = "恶魔牺牲",		Length = 0,	Type = 0,   TexturePrefix = "Sacrifice"},
};
-- Type 0 = No Timer
-- Type 1 = Main permanent Timer
-- Type 2 = Permanent Timer
-- Type 3 = Timer of cooldown
-- Type 4 = Timer of maldiction
-- Type 5 = Timer of fight

NECROSIS_ITEM = {
	["Soulshard"] = "灵魂碎片",
	["Soulstone"] = "灵魂石",
	["Healthstone"] = "治疗石",
	["Spellstone"] = "法术石",
	["Firestone"] = "火焰石",
	["Offhand"] = "装备在副手",
	["Twohand"] = "双手",
	["InfernalStone"] = "地狱火石",
	["DemoniacStone"] = "恶魔雕像",
	["Hearthstone"] = "炉石",
	["SoulPouch"] = {"灵魂袋", "恶魔布包", "熔火恶魔布包"}	
};


NECROSIS_STONE_RANK = {
	[1] = "初级",		-- Rank Minor
	[2] = "次级",		-- Rank Lesser
	[3] = "",		-- Rank Intermediate, no name
	[4] = "强效",	-- Rank Greater
	[5] = "特效"		-- Rank Major
};

NECROSIS_NIGHTFALL = {
	["BoltName"] = "箭",
	["ShadowTrance"] = "暗影冥思"
};

NECROSIS_STONE_CREATE = "制造";
NECROSIS_CREATE = {
	[1] = "灵魂石",
	[2] = "治疗石",
	[3] = "法术石",
	[4] = "火焰石"
};

NECROSIS_PET_LOCAL_NAME = {
	[1] = "小鬼",
	[2] = "虚空行者",
	[3] = "魅魔",
	[4] = "地狱猎犬",
	[5] = "地狱火",
	[6] = "末日守卫"
};

NECROSIS_TRANSLATION = {
	["Cooldown"] = "冷却时间",
	["Hearth"] = "炉石",
	["Rank"] = "等级",
	["Mana"] = "法力值",
	["Invisible"] = "侦测隐形",
	["LesserInvisible"] = "侦测次级隐形",
	["GreaterInvisible"] = "侦测强效隐形",
	["SoulLinkGain"] = "你获得了灵魂链接的效果。",
	["SacrificeGain"] = "你获得了牺牲的效果。",
	["SummoningRitual"] = "召唤仪式"
};
NECROSIS_PLAYER_OFFLINE = "离线";
NECROSIS_PARSECRITICALDAMAGE = "你的(.+)致命一击对(.+)造成(%d+)点";
NECROSIS_PARSESPELLCASTFAILED = "你的(.+)施放失败。(.+)对此免疫。";
NECROSIS_CHANNELNAME = {"说","大喊","小队","团队","公会"};
NECROSIS_TARGET_DEAD = "(.+)死亡了";
NECROSIS_MOUNTITEMNAME_KEYWORD = "紫色骷髅战马";
NECROSIS_MOUNTITEMDESCRIPTION_KEYWORD = "可供骑乘";
NECROSIS_SUMMONALERT = "目标太近！！！";
end
