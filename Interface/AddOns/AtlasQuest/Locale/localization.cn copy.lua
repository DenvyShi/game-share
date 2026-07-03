--[[
	
	AtlasQuest, a World of Warcraft addon.
	Email me at m4r3lk4@gmail.com
	
	This file is part of AtlasQuest.
	
	AtlasQuest is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	AtlasQuest is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with AtlasQuest; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
	
--]]

---------------
--- COLOURS ---
---------------
local GREY = "|cff999999";
local RED = "|cffFF0000";
local REDA = "|cffcc6666";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff1eff00";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local NORMAL = "|cffFFd200";

local MAGE = "|cff69ccf0";
local PALADIN = "|cfff58cba";
local WARRIOR = "|cffc79c6e";
local ROGUE = "|cfffff569";
local DRUID = "|cffff7d0a";
local HUNTER = "|cffabd473";
local SHAMAN = "|cff0070de";
local WARLOCK = "|cff9482c9";
local YELLOW = "|cffFFd200";

---------------
--- OPTIONS ---
---------------
AQOptionsCaptionTEXT = "AtlasQuest 选项";
-- Autoshow
AQOptionsAutoshowTEXT = "在打开Atlas时显示AtlasQuest面板。"
-- Right/Left
AQOptionsLEFTTEXT = "将AtlasQuest面板显示在"..RED.."左侧".."。"
AQOptionsRIGHTTEXT = "将AtlasQuest面板显示在"..RED.."右侧".."。"

AQOptionB = "选项"
AQStoryB = "副本背景"
AQNoReward = ""..BLUE.." 没有奖励物品"
AQDiscription_OR = GREY.." or "..WHITE
AQDiscription_AND = ""..GREY.." 和 "..WHITE..""
AQDiscription_REWARD = ""..BLUE.." 任务奖励："
AQDiscription_ATTAIN = "任务可接受等级："
AQDiscription_LEVEL = "任务等级："
AQDiscription_START = "开始地点：\n"
AQDiscription_AIM = "任务目标：\n"
AQDiscription_NOTE = "任务注释：\n"
AQDiscription_PREQUEST = "前导任务："
AQDiscription_FOLGEQUEST = "后续任务："
AQFinishedTEXT = "已完成的任务：";

------------------
--- ITEM TYPES ---
------------------
AQITEM_DAGGER = "匕首"
AQITEM_POLEARM = "长柄武器"
AQITEM_SWORD = "剑"
AQITEM_AXE = "斧"
AQITEM_WAND = "魔杖"
AQITEM_STAFF = "法杖"
AQITEM_MACE = "锤"
AQITEM_SHIELD = "盾"
AQITEM_GUN = "枪"
AQITEM_BOW = "弓"
AQITEM_CROSSBOW = "弩"
AQITEM_THROWN = "投掷武器"

AQITEM_WAIST = "腰带"
AQITEM_SHOULDER = "肩"
AQITEM_CHEST = "胸甲"
AQITEM_LEGS = "腿"
AQITEM_HANDS = "手"
AQITEM_FEET = "脚"
AQITEM_WRIST = "护腕"
AQITEM_HEAD = "头盔"
AQITEM_BACK = "背部"
AQITEM_TABARD = "衬衣"

AQITEM_CLOTH = "布甲"
AQITEM_LEATHER = "皮甲"
AQITEM_MAIL = "锁甲"
AQITEM_PLATE = "板甲"

AQITEM_OFFHAND = "副手物品"
AQITEM_MAINHAND = "主手"
AQITEM_ONEHAND = "单手"
AQITEM_TWOHAND = "双手"

AQITEM_ITEM = "此物品不安全！"
AQITEM_TRINKET = "饰品"
AQITEM_RELIC = "圣物"
AQITEM_POTION = "药水"
AQITEM_OFFHAND = "副手物品"
AQITEM_NECK = "颈部"
AQITEM_PATTERN = "图样"
AQITEM_BAG = "背包"
AQITEM_RING = "戒指"
AQITEM_KEY = "钥匙"
AQITEM_QUIVER = "箭袋"
AQITEM_AMMOPOUCH = "弹药包"
AQITEM_ENCHANT = "附魔"

------------------
----- QUESTS -----
------------------
-- AtlasQuest_Data = {
-- 	[dungeonIndex] = {
-- 		name = "string",
-- 		story = "string"|table,
-- 		[1(Alliance)] = {
-- 			[questIndex] = {
-- 				title = quest name (string),
-- 				level = quest level (number),
-- 				attain = obtainable at level (number),
-- 				aim = quest objective (string),
-- 				note = some extra text (string),
-- 				followup = following quest name (string) ,
-- 				location = quest pick up location (string),
-- 				rewards = {
-- 					[rewardIndex] = {
-- 						name = item name (string),
-- 						id = item ID (number),
-- 						subtext = item types like "Cloth, Head" (string),
-- 						icon = texture path like "INV_Sword_23" (string),
-- 						quality = number 0-poor,1-common etc.,
-- 					},
-- 					text = "Rewards:1 or 2 or 3" or "No Rewards",
-- 				},
-- 				prequest = pre quest name (string),
--				pages = optional (table),
-- 			},
-- 		[2(Horde)] = {
-- 		...
-- 		}
-- 	 }
-- }

AtlasQuest_Data = {
	[1] = {
		name = "死亡矿井",
		story = "这里曾经是人类最主要的产金地，希望矿井在部落第一次大战期间席卷暴风城的时候被废弃。现在迪菲亚兄弟会的人占据了那里并将这个黑暗的通道转变成他们的避难所。据说那些盗贼已经劝说了聪明的地精帮助他们在矿井的深处建造一些可怕的东西——但是没有人知道这是真的还是假的。有传言说，死亡矿井的入口在安宁的月溪镇中。",
		[1] = {
			[1] = {
				note = "你可以在副本内外的矿工身上找到红色丝质面罩。当你完成护送迪菲亚叛徒任务后才能接到这个任务。",
				followup = "无后续",
				attain = 14,
				aim = "给哨兵岭哨塔的哨兵瑞尔带回10条红色丝质面罩。",
				title = "红色丝质面罩", -- 214
				location = "哨兵瑞尔（西部荒野 - 哨兵岭; "..YELLOW.."56, 47"..WHITE.."）",
				level = 17,
				rewards = {
					[1] = {
						name = "结实的短剑",
						id = 2074,
						subtext = "单手 剑",
						icon = "INV_Sword_23",
						quality = 2,
					},
					[2] = {
						name = "贝雕匕首",
						id = 2089,
						subtext = "单手 匕首",
						icon = "INV_Weapon_ShortBlade_01",
						quality = 2,
					},
					[3] = {
						name = "破甲之斧",
						id = 6094,
						subtext = "双手 斧",
						icon = "INV_ThrowingAxe_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "你可以在副本内外的矿工身上找到红色丝质面罩。当你完成护送迪菲亚叛徒任务后才能接到这个任务。",
			},
			[2] = {
				note = "就在你刚要进入副本之前的亡灵"..YELLOW.."副本入口地图[3]"..WHITE.."掉落矿工工会会员卡。",
				followup = "无后续",
				attain = 14,
				aim = "给暴风城的维尔德·蓟草带回4张矿业工会会员卡。",
				title = "收集记忆",  -- 168
				location = "维尔德·蓟草（暴风城 - 矮人区; "..YELLOW.."65, 21"..WHITE.."）",
				level = 18,
				rewards = {
					[1] = {
						name = "掘地工之靴",
						id = 2037,
						subtext = "脚部 锁甲",
						icon = "INV_Boots_01",
						quality = 2,
					},
					[2] = {
						name = "陈旧的矿工手套",
						id = 2036,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_05",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "就在你刚要进入副本之前的工头希斯奈特"..YELLOW.."副本入口地图[3]"..WHITE.."掉落矿探险者协会徽章。",
				followup = "无后续",
				attain = 15,
				aim = "将工头希斯耐特的探险者协会徽章交给暴风城的维尔德·蓟草。",
				title = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				location = "维尔德·蓟草（暴风城 - 矮人区; "..YELLOW.."65, 21"..WHITE.."）",
				level = 20,
				rewards = {
					[1] = {
						name = "矿工的报复",
						id = 1893,
						subtext = "双手 斧",
						icon = "INV_Pick_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "你可以直接接到这个任务，你也可以从诺恩那里接到此任务的引导任务（铁炉堡 - 侏儒区; "..YELLOW.."69,50"..WHITE.."）。\n斯尼德的伐木机掉落小型高能发动机，位置在"..YELLOW.."[3]"..WHITE.."。",
				followup = "无后续",
				attain = 15,
				aim = "从死亡矿井中带回小型高能发动机，将其带给暴风城矮人区中的沉默的舒尼。",
				title = "地底突袭", -- 2040
				location = "沉默的舒尼（暴风城 - 矮人区; "..YELLOW.."55,12"..WHITE.."）",
				level = 20,
				rewards = {
					[1] = {
						name = "极地护手",
						id = 7606,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_04",
						quality = 2,
					},
					[2] = {
						name = "紫貂魔杖",
						id = 7607,
						subtext = "魔杖",
						icon = "INV_Staff_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "沉默的舒尼", -- 2041
			},
			[5] = {
				note = "此系列任务开始于格里安·斯托曼（西部荒野 - 哨兵岭; "..YELLOW.."56,47"..WHITE.."）。\n艾德温·范克里夫是死亡矿井的最后一个Boss。你可以在他的船的最上层找到他，位置在"..YELLOW.."[6]"..WHITE.."。",
				followup = "无后续",
				attain = 14,
				aim = "杀死艾德温·范克里夫，把他的头交给格里安·斯托曼。",
				title = "你可以在副本内外的矿工身上找到红色丝质面罩。当你完成护送迪菲亚叛徒任务后才能接到这个任务。",
				location = "格里安·斯托曼（西部荒野 - 哨兵岭 "..YELLOW.."56,47 "..WHITE.."）",
				level = 22,
				rewards = {
					[1] = {
						name = "西部荒野马裤",
						id = 6087,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_03",
						quality = 3,
					},
					[2] = {
						name = "西部荒野外套",
						id = 2041,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Leather_07",
						quality = 3,
					},
					[3] = {
						name = "西部荒野法杖",
						id = 2042,
						subtext = "法杖",
						icon = "INV_Staff_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "你可以在副本内外的矿工身上找到红色丝质面罩。当你完成护送迪菲亚叛徒任务后才能接到这个任务。",
			},
			[6] = {
				note = "点击"..YELLOW.."[乔丹的武器材料单]"..WHITE.."查看乔丹的武器材料单。",
				followup = "正义试炼（圣骑士任务）", -- 1654
				attain = 20,
				aim = "按照乔丹的武器材料单上的说明去寻找一些白石橡木、精炼矿石、乔丹的铁锤和一块科尔宝石，然后回到铁炉堡去见乔丹·斯迪威尔。",
				title = "正义试炼（圣骑士任务）", -- 1654
				location = "乔丹·斯迪威尔（丹莫罗 - 铁炉堡 "..YELLOW.."52,36 "..WHITE.."）",
				level = 22,
				rewards = {
					[1] = {
						name = "维里甘之拳",
						id = 6953,
						subtext = "双手 锤",
						icon = "INV_Hammer_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "勇气之书 -> 正义试炼", -- 1651 -> 1653
				pages = {
					"1. You get the  Whitestone Oak Lumber from Goblin Woodcarvers in "..NORMAL.."[Deadmines]"..WHITE.." near "..NORMAL.."[3]"..WHITE..".\n\n2. To get the Bailor's Refined Ore Shipment you must talk to Bailor Stonehand (Loch Modan - Thelsamar; "..NORMAL.."35,44"..WHITE.."). He gives you the 'Bailor's Ore Shipment' quest. You find the Jordan's Ore Shipment behind a tree at "..NORMAL.."71,21"..WHITE.."\n\n3. You get Jordan's Smithing Hammer in "..NORMAL.."[Shadowfang Keep]"..WHITE.." at "..NORMAL.."[3]"..WHITE..".\n\n4. To get a Kor Gem you have to go to Thundris Windweaver (Darkshore - Auberdine; "..NORMAL.."37,40"..WHITE..") and do the 'Seeking the Kor Gem' quest. For this quest, you must kill Blackfathom oracles or priestesses before "..NORMAL.."[Blackfathom Deeps]"..WHITE..". They drop a corrupted Kor Gem. Thundris Windweaver will clean it for you.",
				}
			},
			[7] = {
				note = "巴隆斯·阿历克斯顿在暴风城光明大教堂旁边"..YELLOW.."49,30"..WHITE.."。",
				followup = "巴基尔·斯瑞德", -- 389
				attain = 16,
				aim = "搜查艾德温·范克里夫的尸体时，你从一堆杂乱的物品中找到了一封还未来得及发出的信。地址一栏上写着巴隆斯·阿历克斯顿，暴风城石工协会，城市大厅，教堂广场。",
				title = "未寄出的信", -- 373
				location = "未寄出的信（范克里夫掉落 "..YELLOW.."[6]"..WHITE.."）",
				level = 22,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "你在西部荒野的西北部小岛上开始这条任务线;地面上的书"..YELLOW.."26.1,16.5"..WHITE..")。\n",
				followup = "无后续",
				attain = 15,
				aim = "杀掉曲奇，带回葛瑞森的吊坠",
				title = "(TW)2. 葛瑞森船长的复仇", -- 40396
				location = "葛瑞森船长 (西部荒野 - 灯塔; "..YELLOW.."30,86"..WHITE..")",
				level = 22,
				rewards = {
					[1] = {
						name = "格雷森的帽子",
						id = 70070,
						subtext = "头部 布甲",
						icon = "INV_Helmet_30",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "食物给航海思绪？", -- 40395
			},
			[9] = {
				note = "这条任务线开始于克里斯托弗·赫温 (西部荒野 - 哨兵岭旅店; "..YELLOW.."52.3,52.8"..WHITE..").\n任务线有16个任务。最终奖励蓝色物品：1)副手物品 智力/暗抗/法术伤害及治疗效果, 2) 锁甲肩膀 力量/耐力, 3) 皮甲手套 力量/敏捷/耐力\n基尔尼格在"..YELLOW.."[4]"..WHITE.."。",
				followup = "(TW)9. 收获傀儡之谜", -- 40478
				attain = 15,
				aim = "进入死亡矿并杀死基尔尼格，完成后，向西部荒野的加特赛德园地的马尔蒂莫·加特赛德回复。",
				title = "(TW)9. 收获傀儡之谜", -- 40478
				location = "马尔蒂莫·加特赛德 (西部荒野 - 金海岸矿洞的北边; "..YELLOW.."31.3,37.6"..WHITE..")",
				level = 19,
				rewards = {
					[1] = {
						name = "工匠腰带",
						id = 60684,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_06",
						quality = 2,
					},
					[2] = {
						name = "安全绑带",
						id = 60685,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_10",
						quality = 2,
					},
					[3] = {
						name = "收获魔像的手臂",
						id = 60686,
						subtext = "双手 锤",
						icon = "INV_Mace_04",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "收获魔像之谜 VIII", -- 40477
			},
			[10] = {
				note = "任务线起始于暴风城剃刀雷吉克的任务“西部荒野的苦工们”。\n第二步的“密探吉尔妮”在西部荒野"..YELLOW.."68,70"..WHITE.."的一颗树下，注意她是潜行的，要走进才能看到。\n最后到死亡矿井进本左转，新增地区7号位置“赞吉尔实验室”"..YELLOW.."31,28"..WHITE.."击杀“杰里德.维斯”获取“维斯的热饮”，回雷吉克交任务。",
				followup = "无后续",
				attain = 14,
				aim = "潜入西部荒野的死亡矿井并获得维斯的热饮。",
				title = "(TW)10.关上水龙头",
				location = "剃刀雷吉克（暴风城-军情七处; "..YELLOW.."78,71"..WHITE..")",
				level = 20,
				rewards = {
					[1] = {
						name = "特工斗篷", -- 70239
						id = 70239,
						subtext = "背部",
						icon = "INV_Misc_Cape_07",
						quality = 2,
					},
					[2] = {
						name = "正直镣铐", -- 70240
						id = 70240,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_11",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "西部荒野的苦工们->密探吉尔妮->危险的快递",
			},
		},
		[2] = {
			[1] = {
				note = ""..RED.."!!!目前这个任务有BUG。有时候任务物品可能完全不掉落。"..WHITE.."\n斯尼德或者范克里夫会掉落原型粉碎机X0-1原理图"..YELLOW.."[3]"..WHITE.."或者"..YELLOW.."[6]"..WHITE..".\n可以确认斯尼德有掉落任务物品，但并非100%掉落机率。",
				followup = "无后续",
				attain = 16,
				aim = "将原型粉碎机X0-1原理图带给乌雷克斯·奥兹尔纳特。",
				title = "(TW)1. 原型机图纸", -- 55005
				location = "乌雷克斯·奥兹尔纳特 (杜隆塔尔 - 激水港; 58,26)",
				level = 18,
				rewards = {
					[1] = {
						name = "敌人切割者", -- 81316
						id = 81316,
						subtext = "双手 斧",
						icon = "INV_Axe_21",
						quality = 2,
					},
					[2] = {
						name = "闪亮电灯笼", -- 81317
						id = 81317,
						subtext = "副手",
						icon = "INV_Misc_Lantern_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你在西部荒野的西北部小岛上开始这条任务线;地面上的书"..YELLOW.."26.1,16.5"..WHITE..")。\n",
				followup = "无后续",
				attain = 15,
				aim = "杀掉曲奇，带回葛瑞森的吊坠",
				title = "(TW)2. 葛瑞森船长的复仇", -- 40396
				location = "葛瑞森船长 (西部荒野 - 灯塔; "..YELLOW.."30,86"..WHITE..")",
				level = 22,
				rewards = {
					[1] = {
						name = "格雷森的帽子",
						id = 70070,
						subtext = "头部 布甲",
						icon = "INV_Helmet_30",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "食物给航海思绪？", -- 40395
			},
			[3] = {
				note = "你在纳加尔·戴西耶 (十字路口 "..YELLOW.."51.2,29.1"..WHITE..")那里接到这个任务链的任务。\n这个任务"..RED.."只会把你传送到西部荒野"..WHITE.."。你可以完成这个任务并在完成任务链后获得奖励，或者用它作为西部荒野的传送任务重复接受。",
				followup = "(TW)3. 部落防御者之斧", -- 39998
				attain = 15,
				aim = "把一块偷来的墓碑带给十字路口的纳加尔·戴西耶。",
				title = "(TW)3. 部落防御者之斧", -- 39998
				location = "比尔吉特·克兰斯顿 <传送门训练师> (雷霆崖)",
				level = 18,
				rewards = {
					[1] = {
						name = "(TW)3. 部落防御者之斧", -- 39998
						id = 40065,
						subtext = "双手 斧",
						icon = "INV_Axe_04",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "(TW)3. 部落防御者之斧", -- 39998
			},
		},
	},
	[2] = {
		name = "哀嚎洞穴",
		story = "最近一个名叫纳拉雷克斯的暗夜精灵德鲁伊在贫瘠之地中的地下发现了一个错综复杂的洞穴网。这个被称作“哀嚎洞穴”的地方有很多的蒸汽缝隙，所以当蒸气喷射的时候发出的声音就犹如哀嚎一般，其因此而得名。纳拉雷克斯可以利用洞穴中的温泉来恢复贫瘠之地的生态，让这里重新获得生机——但是这样做需要吸收传说中的翡翠梦境的能量。一旦和翡翠梦境相连接，德鲁伊的视线中就变成了一场噩梦。不久之后，哀嚎洞穴开始变化——洞中的水开始腐化——曾经温顺的生物开始变成狂暴，致命的捕食者。据说纳拉雷克斯自己还居住在这个迷宫的最深处，他被翡翠梦境的边缘所困扰着。即使他以前的随从也被他们的主人所经历的噩梦所腐化——他们都变成了邪恶的尖牙德鲁伊。",
		[1] = {
			[1] = {
				note = "每个副本前面或里面的变异的怪都可能掉落变异皮革。纳尔帕克在入口上方的山顶洞穴里。",
				followup = "无后续",
				attain = 13,
				aim = "哀嚎洞穴的纳尔帕克想要20张变异皮革。",
				title = "变异皮革", --1486
				location = "纳尔帕克（贫瘠之地 - 哀嚎洞穴; "..YELLOW.."47,36 "..WHITE.."）",
				level = 17,
				rewards = {
					[1] = {
						name = "光滑的蛇鳞护腿",
						id = 6480,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_02",
						quality = 2,
					},
					[2] = {
						name = "变异皮包",
						id = 918,
						subtext = "背包",
						icon = "INV_Misc_Bag_07_Black",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你进入副本杀死疯狂的马格利什，拿到酒瓶。当你进入洞穴后向右转，他就在一个凹进去的洞里"..YELLOW.."副本入口地图[2]"..WHITE.."。",
				followup = "无后续",
				attain = 14,
				aim = "棘齿城的起重机操作员比戈弗兹让你从疯狂的马格利什那儿取回一瓶99年波尔多陈酿，疯狂的马格利什就藏在哀嚎洞穴里。",
				title = "港口的麻烦", -- 959
				location = "起重机操作员比戈弗兹（贫瘠之地 - 棘齿城; "..YELLOW.."63,37 "..WHITE.."）",
				level = 18,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "此任务的前导任务也是在麦伯克·米希瑞克斯这儿接到的。\n软浆怪掉落香精。",
				followup = "无后续",
				attain = 13,
				aim = "收集6份哀嚎香精，把它们交给棘齿城的麦伯克·米希瑞克斯。",
				title = "智慧饮料", -- 1491
				location = "麦伯克·米希瑞克斯（贫瘠之地 - 棘齿城; "..YELLOW.."62,37"..WHITE.."）",
				level = 18,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "迅猛龙角", -- 865
			},
			[4] = {
				note = "厄布鲁在入口上方山顶的洞穴里。",
				followup = "无后续",
				attain = 15,
				aim = "哀嚎洞穴的厄布鲁要求你杀掉7只变异破坏者、7只剧毒飞蛇、7只变异蹒跚者和7只变异尖牙风蛇。",
				title = "清除变异者", -- 1487
				location = "厄布鲁（贫瘠之地 - 哀嚎洞穴; "..YELLOW.."47,36 "..WHITE.."）",
				level = 21,
				rewards = {
					[1] = {
						name = "图样：蛇鳞腰带",
						id = 6476,
						subtext = "图样",
						icon = "INV_Scroll_06",
						quality = 2,
					},
					[2] = {
						name = "烧灼之棒",
						id = 8071,
						subtext = "魔杖",
						icon = "INV_Staff_02",
						quality = 2,
					},
					[3] = {
						name = "达格米尔护手   ",
						id = 6481,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_05",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "当你杀死了最后的Boss吞噬者穆坦努斯后，你就会得到发光的碎片。而只有当你杀死了4个德鲁伊，并完成护送德鲁伊任务后，吞噬者穆坦努斯才会出现。\n当你拿到碎片后，你必须把它带回棘齿城，然后返回哀嚎洞穴外面山顶找到菲拉·古风。注意：去棘齿城找个地精说话，（就是做《什么什么平衡器》那个任务的地精），他头上是没有问号的，要自己去点他。",
				followup = "在噩梦中(在达纳苏斯结束)", -- 3370
				attain = 15,
				aim = "去棘齿城寻找更多有关这块噩梦碎片的信息。",
				title = "发光的碎片", -- 6981
				location = "发光的碎片（掉落）（哀嚎洞穴"..YELLOW.."[9]"..WHITE.."）",
				level = 26,
				rewards = {
					[1] = {
						name = "塔巴尔护肩   ",
						id = 10657,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_09",
						quality = 2,
					},
					[2] = {
						name = "泥潭沼泽长靴",
						id = 10658,
						subtext = "脚部 锁甲",
						icon = "INV_Boots_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "你可以在药剂师赫布瑞姆处领取前导任务（贫瘠之地 - 十字路口; "..YELLOW.."51,30"..WHITE.."）。\n你可以在山洞里副本前或副本内采到毒蛇花。学习草药学的玩家打开寻找草药技能就可以在自己的小地图上看到毒蛇花的位置。",
				followup = "无后续",
				attain = 16,
				aim = "奥伯丁奥兰达利亚·夜歌委托你收集10朵毒蛇花。",
				title = "毒蛇花", -- 962
				location = "奥兰达利亚·夜歌 (奥伯丁 - 黑海岸; "..YELLOW.."37.7,40.7"..WHITE..")",
				level = 18,
				rewards = {
					[1] = {
						name = "绿纹腰带",
						id = 51850,
						subtext = "腰部 布甲",
						icon = "INV_Belt_25",
						quality = 2,
					},
					[2] = {
						name = "青翠之靴",
						id = 51851,
						subtext = "脚部 锁甲",
						icon = "INV_Boots_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "当你杀死了最后的Boss吞噬者穆坦努斯后，你就会得到发光的碎片。而只有当你杀死了4个德鲁伊，并完成护送德鲁伊任务后，吞噬者穆坦努斯才会出现。\n当你拿到碎片后，你必须把它带回棘齿城，然后返回哀嚎洞穴外面山顶找到菲拉·古风。注意：去棘齿城找个地精说话，（就是做《什么什么平衡器》那个任务的地精），他头上是没有问号的，要自己去点他。",
				followup = "无后续",
				attain = 16,
				aim = "艾兰达里安·夜歌希望你前往北贫瘠之地的哀嚎洞穴，解救纳拉雷克斯脱离噩梦。在洞穴中找到他的信徒以了解具体方法。解救纳拉雷克斯后回到她那里复命。\n击败穆塔努斯·吞噬者。"..YELLOW.."[9]"..WHITE..".",
				title = "(TW)7. 陷入梦魇", -- 60124
				location = "奥兰达利亚·夜歌 (奥伯丁 - 黑海岸; "..YELLOW.."37.7,40.7"..WHITE..")",
				level = 19,
				rewards = {
					[1] = {
						name = "古老的精灵长袍",
						id = 51848,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_03",
						quality = 3,
					},
					[2] = {
						name = "雷角",
						id = 51849,
						subtext = "双手 剑",
						icon = "INV_Sword_17",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "“过度生长的样本”在哀嚎洞穴"..YELLOW.."67,82"..WHITE.."附近新增地区“狂野生长”击杀大花怪“异常的狂野生长”掉落。",
				followup = "无后续",
				attain = 16,
				aim = "奥伯丁的桑迪斯·织风需要哀嚎洞穴中的异常的狂野生长的样本。",
				title = "(TW)8.杂草丛生",
				location = "桑迪斯·织风（奥伯丁 - 黑海岸; "..YELLOW.."37.7,40.7"..WHITE..")",
				level = 20,
				rewards = {
					[1] = {
						name = "强效法力药水",
						id = 3827,
						subtext = "药水",
						icon = "INV_Potion_72",
						quality = 1,
					},
					[2] = {
						name = "强效治疗药水，3个",	--1710
						id = 1710,
						subtext = "药水",
						icon = "INV_Potion_52",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "每个副本前面或里面的变异的怪都可能掉落变异皮革。纳尔帕克在入口上方的山顶洞穴里。",
				followup = "无后续",
				attain = 13,
				aim = "哀嚎洞穴的纳尔帕克想要20张变异皮革。",
				title = "变异皮革", --1486
				location = "纳尔帕克（贫瘠之地 - 哀嚎洞穴; "..YELLOW.."47,36 "..WHITE.."）",
				level = 17,
				rewards = {
					[1] = {
						name = "光滑的蛇鳞护腿",
						id = 6480,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_02",
						quality = 2,
					},
					[2] = {
						name = "变异皮包",
						id = 918,
						subtext = "背包",
						icon = "INV_Misc_Bag_07_Black",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你进入副本杀死疯狂的马格利什，拿到酒瓶。当你进入洞穴后向右转，他就在一个凹进去的洞里"..YELLOW.."副本入口地图[2]"..WHITE.."。",
				followup = "无后续",
				attain = 14,
				aim = "棘齿城的起重机操作员比戈弗兹让你从疯狂的马格利什那儿取回一瓶99年波尔多陈酿，疯狂的马格利什就藏在哀嚎洞穴里。",
				title = "港口的麻烦", -- 959
				location = "起重机操作员比戈弗兹（贫瘠之地 - 棘齿城; "..YELLOW.."63,37 "..WHITE.."）",
				level = 18,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在药剂师赫布瑞姆处领取前导任务（贫瘠之地 - 十字路口; "..YELLOW.."51,30"..WHITE.."）。\n你可以在山洞里副本前或副本内采到毒蛇花。学习草药学的玩家打开寻找草药技能就可以在自己的小地图上看到毒蛇花的位置。",
				followup = "无后续",
				attain = 14,
				aim = "为雷霆崖的药剂师扎玛收集10朵毒蛇花。",
				title = "毒蛇花", -- 962
				location = "药剂师扎玛（雷霆崖 -灵魂高地; "..YELLOW.."22,20 "..WHITE.."）",
				level = 18,
				rewards = {
					[1] = {
						name = "药剂师手套",
						id = 10919,
						subtext = "手部 布甲",
						icon = "INV_Gauntlets_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "菌类孢子 -> 药剂师扎玛", -- 848 -> 853
			},
			[4] = {
				note = "此任务的前导任务也是在麦伯克·米希瑞克斯这儿接到的。\n软浆怪掉落香精。",
				followup = "无后续",
				attain = 13,
				aim = "收集6份哀嚎香精，把它们交给棘齿城的麦伯克·米希瑞克斯。",
				title = "智慧饮料", -- 1491
				location = "麦伯克·米希瑞克斯（贫瘠之地 - 棘齿城; "..YELLOW.."62,37"..WHITE.."）",
				level = 18,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "迅猛龙角", -- 865
			},
			[5] = {
				note = "厄布鲁在入口上方山顶的洞穴里。",
				followup = "无后续",
				attain = 15,
				aim = "哀嚎洞穴的厄布鲁要求你杀掉7只变异破坏者、7只剧毒飞蛇、7只变异蹒跚者和7只变异尖牙风蛇。",
				title = "清除变异者", -- 1487
				location = "厄布鲁（贫瘠之地 - 哀嚎洞穴; "..YELLOW.."47,36 "..WHITE.."）",
				level = 21,
				rewards = {
					[1] = {
						name = "图样：蛇鳞腰带",
						id = 6476,
						subtext = "图样",
						icon = "INV_Scroll_06",
						quality = 2,
					},
					[2] = {
						name = "烧灼之棒",
						id = 8071,
						subtext = "魔杖",
						icon = "INV_Staff_02",
						quality = 2,
					},
					[3] = {
						name = "达格米尔护手   ",
						id = 6481,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_05",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "系列任务始于哈缪尔·符文图腾（雷霆崖 - 长者高地; "..YELLOW.."78,28"..WHITE.."）\n掉落宝石的4个德鲁伊位于"..YELLOW.."[2]"..WHITE..", "..YELLOW.."[3]"..WHITE..", "..YELLOW.."[5]"..WHITE..", "..YELLOW.."[7]"..WHITE.."。",
				followup = "无后续",
				attain = 11,
				aim = "将考布莱恩领主宝石、安娜科德拉女士宝石、皮萨斯领主宝石和瑟芬迪斯领主宝石交给雷霆崖的纳拉·蛮鬃。",
				title = "尖牙德鲁伊（连续任务）", -- 914
				location = "纳拉·蛮鬃（雷霆崖 - 长者高地; "..YELLOW.."75,31 "..WHITE.."）",
				level = 22,
				rewards = {
					[1] = {
						name = "新月法杖",
						id = 6505,
						subtext = "法杖",
						icon = "INV_Staff_04",
						quality = 3,
					},
					[2] = {
						name = "翼刃",
						id = 6504,
						subtext = "主手 剑",
						icon = "INV_Sword_16",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "贫瘠之地绿洲 -> 纳拉·蛮鬃", -- 886 -> 1490
			},
			[7] = {
				note = "当你杀死了最后的Boss吞噬者穆坦努斯后，你就会得到发光的碎片。而只有当你杀死了4个德鲁伊，并完成护送德鲁伊任务后，吞噬者穆坦努斯才会出现。\n当你拿到碎片后，你必须把它带回棘齿城，然后返回哀嚎洞穴外面山顶找到菲拉·古风。注意：去棘齿城找个地精说话，（就是做《什么什么平衡器》那个任务的地精），他头上是没有问号的，要自己去点他。",
				followup = "在噩梦中（在雷霆崖结束）", -- 3369
				attain = 15,
				aim = "去棘齿城寻找更多有关这块噩梦碎片的信息。",
				title = "发光的碎片", -- 6981
				location = "发光的碎片（掉落）（哀嚎洞穴"..YELLOW.."[9]"..WHITE.."）",
				level = 26,
				rewards = {
					[1] = {
						name = "塔巴尔护肩",
						id = 10657,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_09",
						quality = 2,
					},
					[2] = {
						name = "泥潭沼泽长靴",
						id = 10658,
						subtext = "脚部 锁甲",
						icon = "INV_Boots_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[8] = {
				note = ""..YELLOW.."只限法师。"..WHITE.." 可以从乌瑞达 <法师训练师>(奥格瑞玛)开始任务'掌握奥术'的任务链。\n月触木你可以从 "..YELLOW.."垃圾"..WHITE.."中找到，巨蛇水晶从瑟芬迪斯领主 <毒牙领主>"..YELLOW.."[7]"..WHITE.."那里得到，常变精华从皮萨斯领主 <毒牙领主>"..YELLOW.."[5]"..WHITE.."那里得到。",
				followup = "无后续",
				attain = 14,
				aim = "带给乔克加洛克5块月触木"..YELLOW.."垃圾"..WHITE.."，一块巨蛇水晶，以及一份来自哀嚎洞穴的常变精华。",
				title = "(TW)8. 奥术武器", -- 80312
				location = "乔克加洛克 <石槌氏族> (在贫瘠之地的怒水河岸上; "..YELLOW.."62.4,10.8"..WHITE..")",
				level = 18,
				rewards = {
					[1] = {
						name = "奥术之路法杖", -- 80860
						id = 80860,
						subtext = "双手 法杖",
						icon = "INV_Staff_06",
						quality = 3,
					},
					[2] = {
						name = "织法者匕首", -- 80861
						id = 80861,
						subtext = "单手 匕首",
						icon = "INV_Weapon_ShortBlade_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = ""..YELLOW.."只限法师。"..WHITE.." 可以从乌瑞达 <法师训练师>(奥格瑞玛)开始任务'掌握奥术'的任务链。\n月触木你可以从 "..YELLOW.."垃圾"..WHITE.."中找到，巨蛇水晶从瑟芬迪斯领主 <毒牙领主>"..YELLOW.."[7]"..WHITE.."那里得到，常变精华从皮萨斯领主 <毒牙领主>"..YELLOW.."[5]"..WHITE.."那里得到。",
			},
			[9] = {
				note = "在哀嚎洞穴中杀死赞达拉·风蹄，并将她的头带回贫瘠之地的纳尔帕克身边。",
				followup = "无后续",
				attain = 17,
				aim = "在哀嚎洞穴中杀死赞达拉·风蹄，并将她的头带回贫瘠之地的纳尔帕克身边。",
				title = "(TW)9.与科卡尔的梦对抗",
				location = "纳尔帕克（贫瘠之地 - 哀嚎洞穴; "..YELLOW.."47,36 "..WHITE.."）",
				level = 23,
				rewards = {
					[1] = {
						name = "科卡尔披风",	--70224
						id = 70224,
						subtext = "背部",
						icon = "INV_Misc_Cape_08",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
	},
	[3] = {
		name = "怒焰裂谷",
		story = "怒焰裂谷是一个错综复杂的火焰洞穴，它位于兽人的新都城奥格瑞玛中。最近，有传言说一批崇拜恶魔阴影教的信徒占据了怒焰裂谷。这个被称为火刃的组织对杜隆塔尔的安全。许多人认为兽人的酋长萨尔已经意识到了火刃的存在并不打算摧毁他们，因为萨尔希望能够将他引到阴影议会那里。不管怎么样，黑暗的力量从怒焰裂谷散发出来，它们可能毁了兽人所有的一切。",
		[1] = {
		},
		[2] = {
			[1] = {
				note = "你一开始就能找到穴居人。",
				followup = "无后续",
				attain = 9,
				aim = "在奥格瑞玛找到怒焰裂谷，杀掉8个怒焰穴居人和8个怒焰萨满祭司，然后向雷霆崖的拉哈罗复命。",
				title = "试探敌人", -- 5723
				location = "拉哈罗（雷霆崖 - 长者高地; "..YELLOW.."70,29 "..WHITE.."）",
				level = 15,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "燃刃信徒和燃刃术士掉落这两本书。",
				followup = "无后续",
				attain = 9,
				aim = "将《暗影法术研究》和《扭曲虚空的魔法》这两本书交给幽暗城的瓦里玛萨斯。",
				title = "你必须干掉5座水晶塔周围的守卫，那5座水晶塔维持着关押伊莫塔尔的监狱。一旦水晶塔的能量被削弱，伊莫塔尔周围的能量力场就会消散。\n 进入伊莫塔尔的监狱，干掉站在中间的那个恶魔。最后，在图书馆挑战托塞德林王子。当任务完成之后，到庭院中去找辛德拉古灵。",
				location = "瓦里玛萨斯（幽暗城 - 皇家区; "..YELLOW.."56,92 "..WHITE.."）",
				level = 16,
				rewards = {
					[1] = {
						name = "苍白长裤",
						id = 15449,
						subtext = "腿部 布甲",
						icon = "INV_Pants_14",
						quality = 2,
					},
					[2] = {
						name = "泥泞护腿",
						id = 15450,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_07",
						quality = 2,
					},
					[3] = {
						name = "石像鬼护腿",
						id = 15451,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你会在"..YELLOW.."[1]"..WHITE.."发现玛尔·恐怖图腾。得到背包后你需要把它交回给雷霆崖的拉哈罗。",
				followup = "归还背包", -- 5724
				attain = 9,
				aim = "在怒焰裂谷搜寻玛尔·恐怖图腾的尸体以及他留下的东西。",
				title = "寻找背包", -- 5722
				location = "拉哈罗（雷霆崖 - 长者高地; "..YELLOW.."70,29 "..WHITE.."）",
				level = 16,
				rewards = {
					[1] = {
						name = "羽珠护腕",
						id = 15452,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_08",
						quality = 2,
					},
					[2] = {
						name = "草原狮护腕",
						id = 15453,
						subtext = "手腕 皮甲",
						icon = "INV_Bracer_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "你会在"..YELLOW.."[4]"..WHITE.."发现巴扎兰，在"..YELLOW.."[3]"..WHITE.."发现祈求者耶戈什。",
				followup = "隐藏的敌人", -- 5728
				attain = 9,
				aim = "杀死巴扎兰和祈求者耶戈什，然后返回奥格瑞玛见萨尔。",
				title = "隐藏的敌人", -- 5728
				location = "萨尔在（奥格瑞玛 - 智慧谷; "..YELLOW.."31,37"..WHITE.."）。 只有在团队中的一人可以拾取此物品并且只可完成一次。\n\n下一步任务领取奖励。",
				level = 16,
				rewards = {
					[1] = {
						name = "奥格瑞玛之剑",
						id = 15443,
						subtext = "单手 匕首",
						icon = "INV_Weapon_ShortBlade_05",
						quality = 2,
					},
					[2] = {
						name = "奥格瑞玛之锤",
						id = 15445,
						subtext = "主手 锤",
						icon = "INV_Hammer_23",
						quality = 2,
					},
					[3] = {
						name = "奥格瑞玛之斧",
						id = 15424,
						subtext = "双手 斧",
						icon = "INV_Axe_04",
						quality = 2,
					},
					[4] = {
						name = "奥格瑞玛法杖",
						id = 15444,
						subtext = "法杖",
						icon = "INV_Staff_Goldfeathered_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "隐藏的敌人", -- 5728
			},
			[5] = {
				note = "你会在"..YELLOW.."[2]"..WHITE.."找到塔拉加曼。",
				followup = "无后续",
				attain = 9,
				aim = "进入怒焰裂谷，杀死饥饿者塔拉加曼，然后把他的心脏交给奥格瑞玛的尼尔鲁·火刃。",
				title = "饥饿者塔拉加曼", -- 5761
				location = "尼尔鲁·火刃（奥格瑞玛 - 暗影裂口; "..YELLOW.."49,50 "..WHITE.."）",
				level = 16,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
	},
	[4] = {
		name = "奥达曼",
		story = "奥达曼是古代泰坦创世之时所留下的深埋于地下的城市。矮人探险队最近发觉到了这块被遗忘的城市，将泰坦一款失败的创造物：食腭怪唤醒了。传说说泰坦是从石头中创造了食腭怪。当实施证明这次试验很失败的时候，泰坦把食腭怪锁了起来并进行了第二次的尝试——最终创造了矮人这个种族。矮人创造的秘密被记录在精密的白金圆盘中——那是位于古代城市最底部的大型泰坦遗迹。最近，黑铁矮人在奥达曼进行了一系列的侵入活动，希望为他们的火焰之主拉格纳罗斯获得圆盘。然而，在这个地下城市中，有一些巨大的石头守卫会攻击任何入侵者。而白金圆盘是由一名巨大的石头守卫阿扎达斯。有传言说矮人的一些石头皮肤的祖先，土灵还居住在城市的隐蔽之处。",
		[1] = {
			[1] = {
				note = "前导任务始于弄皱的地图（荒芜之地; "..YELLOW.."53,33"..WHITE.."）。\n你可以在进入"..YELLOW.."副本入口地图[1]"..WHITE.."找到铁趾格雷兹。",
				followup = "铁趾的护符", -- 722
				attain = 33,
				aim = "在奥达曼找到铁趾格雷兹。",
				title = "一线希望", -- 721
				location = "勘察员雷杜尔（荒芜之地; "..YELLOW.."53,43 "..WHITE.."）",
				level = 35,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "一线希望", -- 721
			},
			[2] = {
				note = "马格雷甘·深影掉落铁趾的护符"..YELLOW.."副本入口地图[2]"..WHITE.."。",
				followup = "铁趾的遗愿", -- 723
				attain = 35,
				aim = "找到铁趾的护符，把它交给奥达曼的铁趾。",
				title = "铁趾的护符", -- 722
				location = "铁趾格雷兹（奥达曼; "..YELLOW.."副本入口地图[1]"..WHITE.."）。",
				level = 40,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "一线希望", -- 721
			},
			[3] = {
				note = "阅读塞卡石板，了解枯木巨魔的蜘蛛之神的名字，然后回到加德林大师那里。",
				followup = "无后续",
				attain = 35,
				aim = "找到意志石板，把它们交给铁炉堡的顾问贝尔格拉姆。",
				title = "意志石板", -- 1139
				location = "顾问贝尔格拉姆（铁炉堡 - 探险者大厅; "..YELLOW.."77,10 "..WHITE.."）",
				level = 45,
				rewards = {
					[1] = {
						name = "勇气勋章 ",
						id = 6723,
						subtext = "颈部",
						icon = "INV_Jewelry_Amulet_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "铁趾的遗愿 -> 邪恶的使者", -- 722 -> 762
			},
			[4] = {
				note = "能量石可以在副本内外的暗炉敌人身上找到。",
				followup = "无后续",
				attain = 30,
				aim = "给荒芜之地的里格弗兹带去8块德提亚姆能量石和8块安纳洛姆能量石。",
				title = "能量石",
				location = "给荒芜之地的里格弗兹带去8块德提亚姆能量石和8块安纳洛姆能量石。",
				level = 36,
				rewards = {
					[1] = {
						name = "能量石环",
						id = 9522,
						subtext = "盾牌",
						icon = "INV_Shield_10",
						quality = 2,
					},
					[2] = {
						name = "杜拉辛护腕",
						id = 10358,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_04",
						quality = 2,
					},
					[3] = {
						name = "持久长靴",
						id = 10359,
						subtext = "脚部 布甲",
						icon = "INV_Boots_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "前导任务始于勘察员塔伯斯·雷矛（铁炉堡 - 探险者大厅; "..YELLOW.."74,12"..WHITE.."）。\n雕纹石罐散布于副本前的山洞里。",
				followup = "无后续",
				attain = 30,
				aim = "收集4个雕纹石罐，把它们交给洛克莫丹的勘察员基恩萨·铁环。",
				title = "阿戈莫德的命运", -- 704
				location = "勘察员基恩萨·铁环（洛克莫丹 - 铁环挖掘场; "..YELLOW.."65,65 "..WHITE.."）",
				level = 38,
				rewards = {
					[1] = {
						name = "勘察者手套",
						id = 4980,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_04",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "铁环挖掘场需要你！ -> 莫达洛克", -- 707 -> 739
			},
			[6] = {
				note = "石板在洞穴北部，通道的东部尽头"..YELLOW.."副本入口地图[3]"..WHITE.."。",
				followup = "远赴铁炉堡", -- 727
				attain = 30,
				aim = "把雷乌纳石板带给迷失者塞尔杜林。",
				title = "化解灾难",
				location = "迷失者塞尔杜林（荒芜之地; "..YELLOW.."51,76 "..WHITE.."）",
				level = 40,
				rewards = {
					[1] = {
						name = "末日预言者长袍",
						id = 4746,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_19",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "在奥达曼找到巴尔洛戈。",
				followup = "密室", -- 2240
				attain = 35,
				aim = "在奥达曼找到巴尔洛戈。",
				title = "失踪的矮人", -- 2398
				location = "前导任务始于勘察员塔伯斯·雷矛（铁炉堡 - 探险者大厅; "..YELLOW.."74,12"..WHITE.."）。\n雕纹石罐散布于副本前的山洞里。",
				level = 40,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "密室在"..YELLOW.."[4]"..WHITE.."。",
				followup = "无后续",
				attain = 35,
				aim = "阅读巴尔洛戈的日记，探索密室，然后向铁炉堡的勘察员塔伯斯·雷矛汇报。",
				title = "密室", -- 2240
				location = "在奥达曼找到巴尔洛戈。",
				level = 40,
				rewards = {
					[1] = {
						name = "矮人冲锋斧",
						id = 9626,
						subtext = "双手 斧",
						icon = "INV_Axe_09",
						quality = 2,
					},
					[2] = {
						name = "探险者联盟徽章",
						id = 9627,
						subtext = "副手",
						icon = "INV_Misc_Lantern_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "失踪的矮人", -- 2398
			},
			[9] = {
				note = "把项链带给铁炉堡的塔瓦斯德·基瑟尔（铁炉堡 - 秘法区; "..YELLOW.."36,3"..WHITE.."）。",
				followup = "昂贵的知识", -- 2199
				attain = 37,
				aim = "找到破碎的项链的来源，从而了解其潜在的价值。",
				title = "破碎项链的能量源在阿扎达斯掉落"..YELLOW.."[10]"..WHITE.."。",
				location = "破碎的项链（随机掉落）（奥达曼）",
				level = 41,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "战士和圣骑士才能接此任务。把书交给博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。完成后开始奎尔塞拉任务。",
				followup = "寻找宝石", -- 2201
				attain = 37,
				aim = "去奥达曼寻找塔瓦斯的魔法项链，被杀的圣骑士是最后一个拿着它的人。",
				title = "回到奥达曼", -- 2200
				location = "把它交给塔瓦斯德·基瑟尔（铁炉堡 - 秘法区; "..YELLOW.."36,3"..WHITE.."）。奖励的戒指为随机属性。",
				level = 42,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "昂贵的知识", -- 2199
			},
			[11] = {
				note = "宝石在"..YELLOW.."[1]"..WHITE.."，"..YELLOW.."[8]"..WHITE.."和"..YELLOW.."[9]"..WHITE.."。",
				followup = "修复项链", -- 2204
				attain = 40,
				aim = "在奥达曼寻找红宝石、蓝宝石和黄宝石的下落。找到它们之后，通过塔瓦斯德给你的占卜之瓶和他进行联系。",
				title = "寻找宝石", -- 2201
				location = "圣骑士的遗体（奥达曼; "..YELLOW.."[2]"..WHITE.."）",
				level = 43,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "回到奥达曼", -- 2200
			},
			[12] = {
				note = "破碎项链的能量源在阿扎达斯掉落"..YELLOW.."[10]"..WHITE.."。",
				followup = "无后续",
				attain = 37,
				aim = "从奥达曼最强大的石人身上获得能量源，然后将其交给铁炉堡的塔瓦斯德。",
				title = "修复项链", -- 2204
				location = "宝石在"..YELLOW.."[1]"..WHITE.."，"..YELLOW.."[8]"..WHITE.."和"..YELLOW.."[9]"..WHITE.."。",
				level = 44,
				rewards = {
					[1] = {
						name = "塔瓦斯德的魔法项链",
						id = 7673,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "寻找宝石", -- 2201
			},
			[13] = {
				note = "蘑菇散布于副本各处。",
				followup = "无后续",
				attain = 36,
				aim = "收集12颗紫色蘑菇，把它们交给塞尔萨玛的加克。",
				title = "奥达曼的蘑菇", -- 17
				location = "加克（洛克莫丹 - 塞尔萨玛; "..YELLOW.."37,49 "..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "滋补药剂",
						id = 9030,
						subtext = "药水",
						icon = "INV_Potion_118",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1(x5)",
				},
				prequest = "荒芜之地的材料", -- 2500
			},
			[14] = {
				note = "你在进入副本前就找到克罗姆·粗臂的财产。它就在洞穴的北部，第一个通道的东南角尽头"..YELLOW.."副本入口地图[4]"..WHITE.."。",
				followup = "无后续",
				attain = 33,
				aim = "到奥达曼的北部大厅去找到克罗姆·粗臂的箱子，从里面拿出他的宝贵财产，然后回到铁炉堡把东西交给他。",
				title = "失而复得", -- 1360
				location = "克罗姆·粗臂（铁炉堡 - 探险者大厅; "..YELLOW.."74,9 "..WHITE.."）",
				level = 43,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "接到任务后，和石头守护者交谈左边的盘子。然后再次使用白金圆盘，取得缩小版的圆盘， 并把缩小版的白金圆盘带给铁炉堡的资深探险家麦格拉斯（铁炉堡 - 探险者大厅; "..YELLOW.."69,18"..WHITE.."）。",
				followup = "无", -- 2963
				attain = 40,
				aim = "和石头守护者交谈，从他那里了解更多古代的知识。一旦你了解到了所有的内容之后就激活诺甘农圆盘。 -> 把迷你版的诺甘农圆盘带到铁炉堡的探险者协会去。",
				title = "白金圆盘", -- 2278 -> 2439
				location = "诺甘农圆盘（奥达曼; "..YELLOW.."[11]"..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "软皮袋",
						id = 9587,
						subtext = "背包",
						icon = "INV_Misc_Bag_17",
						quality = 1,
					},
					[2] = {
						name = "超强治疗药水",
						id = 3928,
						subtext = "药水",
						icon = "INV_Potion_53",
						quality = 1,
					},
					[3] = {
						name = "强效法力药水",
						id = 6149,
						subtext = "药水",
						icon = "INV_Potion_73",
						quality = 1,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "这个任务只能法师做！\n黑曜石哨兵"..YELLOW.."[5]"..WHITE.."掉落黑曜石能量源。",
				followup = "法力怒灵", -- 1957
				attain = 35,
				aim = "找到一个黑曜石能量源，将其交给尘泥沼泽的塔贝萨。",
				title = "奥达曼的能量源（法师任务）",
				location = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				level = 40,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "驱除魔鬼", -- 1955
			},
			[17] = {
				note = "任务线起始于南贫瘠之地 -> 贝尔莫丹 -> 在通往贝尔登要塞的路上稍微往北，在帐篷下面。第一个任务可在18级获得，最后一个任务可在53级获得。",
				followup = "在燃烧军团于第三次大战获胜之后，由恶魔卡扎克所领导的剩余敌军，退回了诅咒之地。到现在为止他们都还住在那里，一个叫腐烂之痕的地方，等待黑暗之门再度敞开。谣传黑暗之门再度敞开之时，卡扎克将带着他剩下的军队前往外域。曾经是兽人家园的德拉诺，外域被兽人萨满耐奥祖所建造的数个传送门同时开启而分割开来，现在更成为被暗夜精灵背叛者伊利丹统帅的恶魔军队所占领的破碎世界。",
				attain = 45,
				aim = "从奥达曼的古代宝藏中获取一个完整的能量核心。",
				title = "(TW)17. 偷一个核心", -- 40129 -> 40132
				location = "托布尔·火花轴（贫瘠之地；"..YELLOW.."48.6,83"..WHITE.." 紫色护目镜下的侏儒，在帐篷旁边的矮人旁边）",
				level = 45,
				rewards = {
					[1] = {
						name = "破碎的核心吊坠", --60518
						id = 60518,
						subtext = "颈部",
						icon = "item_azereansphere",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "古代收购", --40128
			},
		},
		[2] = {
			[1] = {
				note = "能量石可以在副本内外的暗炉敌人身上找到。",
				followup = "无后续",
				attain = 30,
				aim = "给荒芜之地的里格弗兹带去8块德提亚姆能量石和8块安纳洛姆能量石。",
				title = "能量石",
				location = "给荒芜之地的里格弗兹带去8块德提亚姆能量石和8块安纳洛姆能量石。",
				level = 36,
				rewards = {
					[1] = {
						name = "能量石环",
						id = 9522,
						subtext = "盾牌",
						icon = "INV_Shield_10",
						quality = 2,
					},
					[2] = {
						name = "杜拉辛护腕",
						id = 10358,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_04",
						quality = 2,
					},
					[3] = {
						name = "持久长靴",
						id = 10359,
						subtext = "脚部 布甲",
						icon = "INV_Boots_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "石板在洞穴北部，通道的东部尽头"..YELLOW.."副本入口地图[3]"..WHITE.."。",
				followup = "远赴铁炉堡", -- 727
				attain = 30,
				aim = "把雷乌纳石板带给迷失者塞尔杜林。",
				title = "化解灾难",
				location = "迷失者塞尔杜林（荒芜之地; "..YELLOW.."51,76 "..WHITE.."）",
				level = 40,
				rewards = {
					[1] = {
						name = "末日预言者长袍",
						id = 4746,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_19",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "项链在副本里是随机掉落的。",
				followup = "搜寻项链，再来一次", -- 2284
				attain = 37,
				aim = "在奥达曼挖掘场中寻找一条珍贵的项链，然后将其交给奥格瑞玛的德兰·杜佛斯。项链有可能已经损坏。 ",
				title = "搜寻项链", -- 2283
				location = "德兰·杜佛斯（奥格瑞玛 - 暗巷区; "..YELLOW.."59,36 "..WHITE.."）",
				level = 41,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "战士和圣骑士才能接此任务。把书交给博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。完成后开始奎尔塞拉任务。",
				followup = "翻译日记", -- 2318
				attain = 37,
				aim = "在奥达曼里找寻宝石的线索。",
				title = "搜寻项链，再来一次", -- 2284
				location = "德兰·杜佛斯（奥格瑞玛 - 暗巷区; "..YELLOW.."59,36 "..WHITE.."）",
				level = 41,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "搜寻项链", -- 2283
			},
			[5] = {
				note = "翻译圣骑士日记的人加卡尔（荒芜之地 - 卡加斯; "..YELLOW.."2,46"..WHITE.."） -> 将项链借给加卡尔，他帮你翻译日记。",
				followup = "寻找宝贝", -- 2339
				attain = 37,
				aim = "在荒芜之地的卡加斯哨所里寻找一个可以帮你翻译圣骑士日记的人。",
				title = "翻译日记", -- 2318
				location = "圣骑士的遗体（奥达曼; "..YELLOW.."[2]"..WHITE.."）",
				level = 42,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "搜寻项链，再来一次", -- 2284
			},
			[6] = {
				note = "红宝石在暗炉矮人手里，黄宝石在石腭怪手里，而蓝宝石则在一个名叫格瑞姆洛克的石腭怪那里"..YELLOW.."[1]"..WHITE.."，"..YELLOW.."[8]"..WHITE.."和"..YELLOW.."[9]"..WHITE.."。  破碎项链的能量源从阿扎达斯身上掉落"..YELLOW.."[10]"..WHITE.."。",
				followup = "交付宝石", -- 2340
				attain = 37,
				aim = "从奥达曼找回项链上的所有三块宝石和能量源，然后把它们交给卡加斯的加卡尔。\n红宝石被藏在暗影矮人层层设防的地区。\n黄宝石藏在石腭怪活动地区的一个瓮中。\n蓝宝石在格瑞姆洛克手中，他是石腭怪的领袖。\n能量源可能在奥达曼的某个最强生物的手中。",
				title = "寻找宝贝", -- 2339
				location = "翻译圣骑士日记的人加卡尔（荒芜之地 - 卡加斯; "..YELLOW.."2,46"..WHITE.."） -> 将项链借给加卡尔，他帮你翻译日记。",
				level = 44,
				rewards = {
					[1] = {
						name = "加卡尔的强化项链",
						id = 7888,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "翻译日记", -- 2318
			},
			[7] = {
				note = "前导任务也是在加卡尔这儿领取。\n蘑菇散布于副本内各处。",
				followup = "荒芜之地的材料", -- 2500
				attain = 36,
				aim = "收集12颗紫色蘑菇，把它们交给卡加斯的加卡尔。",
				title = "奥达曼的蘑菇", -- 17
				location = "翻译圣骑士日记的人加卡尔（荒芜之地 - 卡加斯; "..YELLOW.."2,46"..WHITE.."） -> 将项链借给加卡尔，他帮你翻译日记。",
				level = 42,
				rewards = {
					[1] = {
						name = "滋补药剂",
						id = 9030,
						subtext = "药水",
						icon = "INV_Potion_118",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1(x5)",
				},
				prequest = "荒芜之地的材料", -- 2500
			},
			[8] = {
				note = "你在进入副本之前就会找到加勒特的家族宝藏。它就在南部通道的尽头"..YELLOW.."副本入口地图[5]"..WHITE.."。",
				followup = "无后续",
				attain = 33,
				aim = "从奥达曼南部大厅的箱子中找到加勒特的家族宝藏，然后把它交给幽暗城的帕特里克·加瑞特。",
				title = "失而复得", -- 1360
				location = "帕特里克·加瑞特（幽暗城; "..YELLOW.."72,48 "..WHITE.."）",
				level = 43,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "你领取到任务后，和石头守护着交谈盘子的左边。然后再次使用白金圆盘得到迷你版的圆盘，带着它去雷霆崖找圣者图希克（"..YELLOW.."34,46"..WHITE.."）。",
				followup = "无", -- 2963
				attain = 40,
				aim = "和石头守护者交谈，从他那里了解更多古代的知识。一旦你了解到了所有的内容之后就激活诺甘农圆盘。 -> 把迷你版的诺甘农圆盘带到雷霆崖的贤者（圣者图希克）那里。",
				title = "白金圆盘", -- 2278 -> 2439
				location = "诺甘农圆盘（奥达曼; "..YELLOW.."[11]"..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "软皮袋",
						id = 9587,
						subtext = "背包",
						icon = "INV_Misc_Bag_17",
						quality = 1,
					},
					[2] = {
						name = "超强治疗药水",
						id = 3928,
						subtext = "药水",
						icon = "INV_Potion_53",
						quality = 1,
					},
					[3] = {
						name = "强效法力药水",
						id = 6149,
						subtext = "药水",
						icon = "INV_Potion_73",
						quality = 1,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "这个任务只能法师做！\n黑曜石哨兵"..YELLOW.."[5]"..WHITE.."掉落黑曜石能量源。",
				followup = "法力怒灵", -- 1957
				attain = 35,
				aim = "找到一个黑曜石能量源，将其交给尘泥沼泽的塔贝萨。",
				title = "奥达曼的能量源（法师任务）",
				location = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				level = 40,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "驱除魔鬼", -- 1955
			},
			[11] = {
				note = "任务线起始于南贫瘠之地 -> 贝尔莫丹 -> 在通往千针石林的道路的西侧，穿过贝尔莫丹挖掘场。第一个任务可在18级获得，最后一个任务可在53级获得。",
				followup = "有利可图的激活", -- 40133
				attain = 45,
				aim = "从奥达曼的古代宝藏中获取一个完整的能量核心。",
				title = "(TW)11. 征用旧件", -- 40131 -> 40133
				location = "凯克斯·吹风者（贫瘠之地；"..YELLOW.."45.7,83.6"..WHITE.." 帐篷下的地精。",
				level = 45,
				rewards = {
					[1] = {
						name = "破碎的核心吊坠", --60518
						id = 60518,
						subtext = "颈部",
						icon = "item_azereansphere",
						quality = 3,
					},
				},
				prequest = "有利可图的收购", --40130
			},
		},
	},
	[5] = {
		name = "罗克图斯·暗契（黑石深渊; "..YELLOW.."[15]"..WHITE.."）",
		story = "黑石深渊曾经是黑铁矮人的伟大都城，这个火山中的迷宫现在成为拉格纳罗斯火焰领主的王座所在地。拉格纳罗斯找到了使用石头和设计图来创造一支无敌石头人均对来帮助它征服黑石深渊。即使是需要打败奈法利安和他的龙子龙孙，拉格纳罗斯会不惜一切代价来达到最后的胜利。",
		[1] = {
			[1] = {
				note = "弗兰克罗恩在黑石的中心，在他的墓上方。你必须死亡后才能见到他！和他交谈2次，激活任务。\n弗诺斯·达克维尔在"..YELLOW.."[9]"..WHITE.."区。你会在"..YELLOW.."[7]"..WHITE.."区找到神殿。",
				followup = "无后续",
				attain = 48,
				aim = "杀掉弗诺斯·达克维尔并拿回战锤铁胆。把铁胆之锤拿到索瑞森神殿去，将其放在弗兰克罗恩·铸铁的雕像上。",
				title = "黑铁的遗产", -- 3802
				location = "弗兰克罗恩·铸铁（黑石山; "..YELLOW.."副本入口地图[3]"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "暗炉钥匙",
						id = 11000,
						subtext = AQITEM_KEY,
						icon = "INV_Misc_Key_08",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "黑铁的遗产", -- 3802
			},
			[2] = {
				note = "可以直接接到任务，也可以接到前导任务从尤卡·斯库比格特（塔纳利斯 - 热砂港; "..YELLOW.."67,23"..WHITE.."）那儿得到。\n雷布里位于"..YELLOW.."[15]"..WHITE.."。",
				followup = "无后续",
				attain = 48,
				aim = "把雷布里的头颅交给燃烧平原的尤卡·斯库比格特。",
				title = "雷布里·斯库比格特", -- 4136
				location = "尤卡·斯库比格特（燃烧平原 - 烈焰峰; "..YELLOW.."65,22"..WHITE.."）",
				level = 53,
				rewards = {
					[1] = {
						name = "怨恨之靴",
						id = 11865,
						subtext = "脚部 布甲",
						icon = "INV_Boots_02",
						quality = 2,
					},
					[2] = {
						name = "忏悔肩铠 ",
						id = 11963,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_25",
						quality = 2,
					},
					[3] = {
						name = "钢条护甲",
						id = 12049,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_16",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "把雷布里的头颅交给燃烧平原的尤卡·斯库比格特。",
			},
			[3] = {
				note = "巨型银矿可从艾萨拉的巨人们那里得到。格罗姆之血可以请学习了草药学的玩家帮助寻找。 你可以在（安戈洛环形山 - 葛拉卡温泉; "..YELLOW.."31,50"..WHITE.."）为瓶子装满水。\n完成任务后，你可以使用后门而不必杀死法拉克斯。",
				followup = "无后续",
				attain = 50,
				aim = "将4份格罗姆之血、10块巨型银矿和装满水的娜玛拉之瓶交给黑石深渊的娜玛拉小姐。",
				title = "爱情药水", -- 4201
				location = "将4份格罗姆之血、10块巨型银矿和装满水的娜玛拉之瓶交给黑石深渊的娜玛拉小姐。",
				level = 54,
				rewards = {
					[1] = {
						name = "镣铐护腕",
						id = 11962,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_13",
						quality = 3,
					},
					[2] = {
						name = "娜玛拉的腰带",
						id = 11866,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_11",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "前导任务从 恩诺哈尔·雷酒（诅咒之地 - 守望堡; "..YELLOW.."61,18"..WHITE.."）处获得。\n如果你在"..YELLOW.."[15]"..WHITE.."区摧毁装有雷霆啤酒的桶，守卫就会出现。秘方就在这其中一个守卫身上。",
				followup = "无后续",
				attain = 50,
				aim = "把遗失的雷酒秘方带给卡拉诺斯的拉格纳·雷酒。",
				title = "霍尔雷·黑须",
				location = "拉格纳·雷酒（丹莫罗 - 卡拉诺斯; "..YELLOW.."46,52"..WHITE.."）",
				level = 55,
				rewards = {
					[1] = {
						name = "矮人黑啤酒",
						id = 12003,
						subtext = "药水",
						icon = "INV_Drink_05",
						quality = 1,
					},
					[2] = {
						name = "迅捷木槌",
						id = 11964,
						subtext = "主手 锤",
						icon = "INV_Mace_08",
						quality = 2,
					},
					[3] = {
						name = "叉刃巨斧",
						id = 12000,
						subtext = "双手 斧",
						icon = "INV_Axe_02",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "把遗失的雷酒秘方带给卡拉诺斯的拉格纳·雷酒。",
			},
			[5] = {
				note = "伊森迪奥斯在"..YELLOW.."[10]"..WHITE.."。",
				followup = "无后续",
				attain = 48,
				aim = "在黑石深渊里找到伊森迪奥斯，然后把他干掉！",
				title = "进入黑石深渊并找到伊森迪奥斯。杀掉它，然后把你找到的信息汇报给桑德哈特。",
				location = "加琳达（燃烧平原 - 摩根的岗哨; "..YELLOW.."85,69"..WHITE.."）",
				level = 56,
				rewards = {
					[1] = {
						name = "阳焰斗篷",
						id = 12113,
						subtext = "背部",
						icon = "INV_Misc_Cape_08",
						quality = 2,
					},
					[2] = {
						name = "夜暮手套",
						id = 12114,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_17",
						quality = 2,
					},
					[3] = {
						name = "地穴恶魔护腕",
						id = 12112,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_17",
						quality = 2,
					},
					[4] = {
						name = "坚定手套",
						id = 12115,
						subtext = "腰部 板甲",
						icon = "INV_Belt_34",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "征服者派隆", -- 4262
			},
			[6] = {
				note = "你可以从"..YELLOW.."[8]"..WHITE.."的宝箱里找到山脉之心。你必须打开黑色宝库所有的小宝箱出来 Boss 之后才能拿到钥匙。",
				followup = "无后续",
				attain = 50,
				aim = "把山脉之心交给燃烧平原的麦克斯沃特·尤博格林。",
				title = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
				location = "麦克斯沃特·尤博格林（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "所有矮人都可能掉落挎包。",
				followup = "无后续",
				attain = 50,
				aim = "到黑石深渊去找到20个黑铁挎包。当你完成任务之后，回到奥拉留斯那里复命。你认为黑石深渊里的黑铁矮人应该会有这些黑铁挎包。",
				title = "好东西", -- 4286
				location = "奥拉留斯（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,68"..WHITE.."）",
				level = 56,
				rewards = {
					[1] = {
						name = "肮脏的背包",
						id = 11883,
						subtext = "物品",
						icon = "INV_Misc_Bag_09_Black",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "此系列任务始于赫林迪斯·河角（燃烧平原 - 摩根的岗哨"..YELLOW.."85,68"..WHITE.."）。\n温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。完成这个任务后，你要回到麦克斯韦尔元帅那里.",
				followup = "被遗弃的希望", -- 4242
				attain = 48,
				aim = "到西北部的黑石山脉去，在黑石深渊中找到温德索尔元帅的下落。\n狼狈不堪的约翰曾告诉你说温德索尔被关进了一个监狱。",
				title = "找回温德索尔元帅遗失的情报。\n温德索尔元帅确信那些情报在安格弗将军和傀儡统帅阿格曼奇的手里。",
				location = "温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。\n如果你清掉法律之环一圈的怪（"..YELLOW.."[6]"..WHITE.."）和通向副本门口的怪的话会轻松很多。护送完成后去找麦克斯韦尔元帅（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,68"..WHITE.."）。",
				level = 54,
				rewards = {
					[1] = {
						name = "监督官头盔",
						id = 12018,
						subtext = "头部 锁甲",
						icon = "INV_Helmet_01",
						quality = 2,
					},
					[2] = {
						name = "盾甲铁靴",
						id = 12021,
						subtext = "脚部 板甲",
						icon = "INV_Boots_Plate_01",
						quality = 2,
					},
					[3] = {
						name = "风剪护腿",
						id = 12041,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "黑龙的威胁 -> 真正的主人", -- 4182 -> 4224
			},
			[9] = {
				note = "这个任务是弄皱的便笺触发的。温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。副本里和外的所有黑铁矮人都有很大几率掉落便笺。",
				followup = "一丝希望（奥妮克希亚系列任务）", -- 4282
				attain = 50,
				aim = "温德索尔元帅也许会对你手中的东西感兴趣。毕竟，希望还没有被完全扼杀。",
				title = "弄皱的便笺", -- 4264
				location = "弄皱的便笺（掉落）（黑石深渊）",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "被遗弃的希望", -- 4242
			},
			[10] = {
				note = "温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。\n傀儡统帅阿格曼奇在"..YELLOW.."[14]"..WHITE.."，安格弗将军在"..YELLOW.."[13]"..WHITE.."。",
				followup = "冲破牢笼！", -- 4322
				attain = 50,
				aim = "找回温德索尔元帅遗失的情报。\n温德索尔元帅确信那些情报在安格弗将军和傀儡统帅阿格曼奇的手里。",
				title = "一丝希望（奥妮克希亚系列任务）", -- 4282
				location = "温德索尔元帅（黑石深渊; "..YELLOW.."[4]"..WHITE.."）",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "弄皱的便笺", -- 4264
			},
			[11] = {
				note = "温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。\n如果你清掉法律之环一圈的怪（"..YELLOW.."[6]"..WHITE.."）和通向副本门口的怪的话会轻松很多。护送完成后去找麦克斯韦尔元帅（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,68"..WHITE.."）。",
				followup = "集合在暴风城", -- 6204
				attain = 50,
				aim = "帮助温德索尔元帅拿回他的装备并救出他的朋友。当你成功之后就回去向麦克斯韦尔元帅复命。",
				title = "冲破牢笼！", -- 4322
				location = "温德索尔元帅（黑石深渊; "..YELLOW.."[4]"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "元素屏障",
						id = 12065,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_02",
						quality = 2,
					},
					[2] = {
						name = "清算之刃",
						id = 12061,
						subtext = "单手 剑",
						icon = "INV_Sword_26",
						quality = 2,
					},
					[3] = {
						name = "作战之刃",
						id = 12062,
						subtext = "单手 匕首",
						icon = "INV_Sword_21",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "一丝希望（奥妮克希亚系列任务）", -- 4282
			},
			[12] = {
				note = "此系列任务始于卡拉然·温布雷（灼热峡谷; "..YELLOW.."39,38"..WHITE.."）。\n 贝尔加在"..YELLOW.."[11]"..WHITE.."。",
				followup = "无后续",
				attain = 52,
				aim = "到黑石深渊去杀掉贝尔加。\n你只知道这个巨型怪物住在黑石深渊的最深处。记住你要使用特殊的黑龙皮从贝尔加的尸体上采集烈焰精华。\n将你采集到的烈焰精华交给塞勒斯·萨雷芬图斯。",
				title = "烈焰精华",
				location = "塞勒斯·萨雷芬图斯（燃烧平原; "..YELLOW.."94,31"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "页岩斗篷",
						id = 12066,
						subtext = "背部",
						icon = "INV_Misc_Cape_02",
						quality = 2,
					},
					[2] = {
						name = "龙皮肩铠",
						id = 12082,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_16",
						quality = 2,
					},
					[3] = {
						name = "火山腰带",
						id = 12083,
						subtext = "腰部 布甲",
						icon = "INV_Belt_11",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无瑕之焰 -> 烈焰精华", -- 3442 -> 4022
			},
			[13] = {
				note = "前导任务始于皇家历史学家阿克瑟努斯（铁炉堡; "..YELLOW.."38,55"..WHITE.."）。卡兰·巨锤位于"..YELLOW.."[2]"..WHITE.."。",
				followup = "卡兰的故事", -- 4342
				attain = 50,
				aim = " 去黑石深渊找到卡兰·巨锤。\n国王提到卡兰在那里负责看守囚犯——也许你应该在监狱附近寻找他。",
				title = "卡兰·巨锤", -- 4341
				location = "进入仇恨熔炉采石场，清除深处的暮光之锤势力，完成后回到铁炉堡找玛格尼·铜须国王。",
				level = 59,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "索瑞森废墟", -- 3701
			},
			[14] = {
				note = "公主茉艾拉·铜须 位于"..YELLOW.."[21]"..WHITE.."。战斗中她可能会治疗达格兰。试着尽可能打断她。但是一定不能让她死掉，否则你的任务将会失败！与她交谈过后，你还要回到麦格尼·铜须那儿去。",
				followup = "语出惊人的公主", -- 4363
				attain = 50,
				aim = "回到黑石深渊，从达格兰·索瑞森大帝的魔掌中救出铁炉堡公主茉艾拉·铜须。",
				title = "王国的命运", -- 4362
				location = "进入仇恨熔炉采石场，清除深处的暮光之锤势力，完成后回到铁炉堡找玛格尼·铜须国王。",
				level = 59,
				rewards = {
					[1] = {
						name = "麦格尼的意志",
						id = 12548,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_05",
						quality = 3,
					},
					[2] = {
						name = "铁炉堡歌唱石",
						id = 12543,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "糟糕的消息", -- 4361
			},
			[15] = {
				note = "完成这个任务之后你就可以从洛索斯·天痕旁边的传送石进入熔火之心。\n熔火碎片在"..YELLOW.."[23]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "进入黑石深渊，在通往熔火之心的传送门附近找到一块熔火碎片，然后回到黑石山脉的洛索斯·天痕那里。",
				title = "熔火之心的传送门", -- 7848
				location = "洛索斯·天痕（黑石山; "..YELLOW.."副本入口地图[2]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "对于不同的职业后续任务是不同的。",
				followup = "各个职业的职业任务（T0.5升级任务）",
				attain = 58,
				aim = "前往黑石深渊竞技场并在你被裁决者格里斯通宣判时将挑衅旗帜放在它的中央。杀死瑟尔伦和他的战士们，再带着第一块瓦萨拉克护符回到东瘟疫之地的安希恩·哈莫那里。",
				title = "挑战（T0.5升级任务）", -- 9015
				location = "法尔林·树影（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1']"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "《煽动者的魔法》。整个任务线始于来自铁炉堡国王房间后面银行的德莉亚娜的任务《诚挚的提议》。", -- 8922
			},
			[17] = {
				note = "只有采矿技能大于230才能接到此任务，这个任务会是你学会如何熔炼黑铁矿石。材料如下：2个[红宝石]，20个[金锭]，10个[真银锭]。完成之后，如果你有[黑铁矿石]你可以在黑熔炉"..YELLOW.."[22]"..WHITE.."熔炼黑铁。",
				followup = "无后续",
				attain = 40,
				aim = "鬼魂之杯的塞娜尼·雷心要你找到他想要的材料。",
				title = "鬼魂之杯（采矿任务）", -- 4083
				location = "塞娜尼·雷心（黑石深渊; "..YELLOW.."[18]"..WHITE.."）",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[18] = {
				note = "任务线起始于泰尔阿比姆岛东边的比克斯·螺旋熔丝处。",
				followup = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
				attain = 50,
				aim = "进入黑石深渊，从达尼格·黑须那里夺回\'极其强效的鼻烟\'（位于住所附近，在桥后面的"..YELLOW.."[7]"..WHITE.."和"..YELLOW.."[8]"..WHITE.."之间，住所之后），交给塔纳利斯的蒸汽车队港口的贾比。",
				title = "(TW)18. 行动：帮助杰比", -- 40757
				location = "进入黑石深渊，从达尼格·黑须那里夺回\'极其强效的鼻烟\'（位于住所附近，在桥后面的"..YELLOW.."[7]"..WHITE.."和"..YELLOW.."[8]"..WHITE.."之间，住所之后），交给塔纳利斯的蒸汽车队港口的贾比。",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "螺旋熔丝行动1000 -> 修复螺旋熔丝行动1000", --40755,40756
			},
			[19] = {
				note = "这个任务需要收集4个物品。\n1) 岩浆凝结器（黑石深渊中的岩浆凝结器箱）\n2) 精巧的奥金桶（黑石塔中的精巧的奥金桶容器）\n3) 熔火碎片（熔火之心中的熔火毁灭者）\n4) 黑铁步枪（由工程师制造）。\n为了完成建造，我还需要炽热核心（3个，从熔火之心中获得）和附魔瑟银锭（10个）。",
				followup = "无后续",
				attain = 55,
				aim = "我需要从黑石深渊中获取一个岩浆凝结器，你可以在魔像实验室附近找到它"..YELLOW.."[14]"..WHITE..".",
				title = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
				location = "任务线起始于泰尔阿比姆岛东边的比克斯·螺旋熔丝处。",
				level = 60,
				rewards = {
					[1] = {
						name = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
						id = 61068,
						subtext = "枪械",
						icon = "Spell_frost_fireresistancetotem",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
			},
			[20] = {
				note = "这个任务线起始于奥瓦克·斯特恩洛克旁边的拉德甘·深焰，接受任务\'获得奥瓦克的信任\'。",
				followup = "无后续",
				attain = 45,
				aim = "在黑石深渊深处击败25个暗石议员，交给燃烧平原的黑石小径上的奥瓦克·斯特恩洛克。",
				title = "(TW)20. 参议员复仇", -- 40464
				location = "奥瓦克·斯特恩洛克（红岭山-燃烧平原之间的小径"..YELLOW.."76,68"..WHITE.."，联盟营地的西边）",
				level = 56,
				rewards = {
					[1] = {
						name = "暗石徽章",
						id = 60668,
						subtext = "饰品",
						icon = "BTN_cr_GCOIN",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "赢得奥尔瓦克的信任 -> 听奥尔瓦克的故事 -> 斯特恩洛克的藏宝地 -> 矿工工会的叛乱",
			},
			[21] = {
				note = "这个任务线起始于奥瓦克·斯特恩洛克旁边的拉德甘·深焰，接受任务\'获得奥瓦克的信任\'。",
				followup = "无后续",
				attain = 45,
				aim = "在黑石深渊中找到并收集一个奥术魔像核心，来自魔像领主阿格曼奇"..YELLOW.."[14]"..WHITE.."，然后回到燃烧平原的黑石小径找拉德甘·深焰。",
				title = "(TW)21. 奥术傀儡核心", -- 40467
				location = "拉德甘·深焰（红岭山-燃烧平原之间的小径"..YELLOW.."76,68"..WHITE.."，联盟营地的西边）",
				level = 55,
				rewards = {
					[1] = {
						name = "充能魔像核心",
						id = 60672,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Pearl_01",
						quality = 2,
					},
				},
				prequest = "获得奥瓦克的信任 -> 听奥瓦克的故事 -> 斯特恩洛克的藏宝 -> 发现魔像的秘密 -> 购买秘密信息", --40761
			},
			[22] = {
				note = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
				followup = "无后续",
				attain = 30,
				aim = "我需要的最后一个部件是用于内骨架的高质量精金棒。我相信斯坦索姆的锻造厂过去曾制作过这样的棒子。",
				title = "(TW)18. 建造一个重击者", -- 80401
				location = "奥格索普·奥布诺提库斯 <大师级侏儒工程师>（荆棘谷；藏宝海湾 "..YELLOW.."28.4,76.3"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "强化红色破碎者",
						id = 81253,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[2] = {
						name = "强化绿色破碎者",
						id = 81252,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[3] = {
						name = "强化蓝色破碎者",
						id = 81251,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[4] = {
						name = "强化黑色破碎者",
						id = 81250,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "一个有力的大脑（仅限工程师）", --80398
			},
			[23] = {
				note = "仅在冬幕节活动期间可用！\n那些可恶的黑铁矮人偷走了它，毫无疑问将其藏在了黑石深渊深处的酒馆"..YELLOW.."[15]"..WHITE.."中。",
				followup = "无后续",
				attain = 45,
				aim = "在黑石深渊的洞穴中找回冬幕节酒桶，交给冬幕节谷的博玛恩·火斧。",
				title = "(TW)23. 冬幕节酒。", -- 40748
				location = "在黑石深渊的洞穴中找回冬幕节酒桶，交给冬幕节谷的博玛恩·火斧。",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "弗兰克罗恩在黑石的中心，在他的墓上方。你必须死亡后才能见到他！和他交谈2次，激活任务。\n弗诺斯·达克维尔在"..YELLOW.."[9]"..WHITE.."区。你会在"..YELLOW.."[7]"..WHITE.."区找到神殿。",
				followup = "无后续",
				attain = 48,
				aim = "杀掉弗诺斯·达克维尔并拿回战锤铁胆。把铁胆之锤拿到索瑞森神殿去，将其放在弗兰克罗恩·铸铁的雕像上。",
				title = "黑铁的遗产", -- 3802
				location = "弗兰克罗恩·铸铁（黑石山; "..YELLOW.."副本入口地图[3]"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "暗炉钥匙",
						id = 11000,
						subtext = "钥匙",
						icon = "INV_Misc_Key_08",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "黑铁的遗产", -- 3802
			},
			[2] = {
				note = "可以直接接到任务，也可以接到前导任务从尤卡·斯库比格特（塔纳利斯 - 热砂港; "..YELLOW.."67,23"..WHITE.."）那儿得到。\n雷布里位于"..YELLOW.."[15]"..WHITE.."。",
				followup = "无后续",
				attain = 48,
				aim = "把雷布里的头颅交给燃烧平原的尤卡·斯库比格特。",
				title = "雷布里·斯库比格特", -- 4136
				location = "尤卡·斯库比格特（燃烧平原 - 烈焰峰; "..YELLOW.."65,22"..WHITE.."）",
				level = 53,
				rewards = {
					[1] = {
						name = "怨恨之靴",
						id = 11865,
						subtext = "脚部 布甲",
						icon = "INV_Boots_02",
						quality = 2,
					},
					[2] = {
						name = "忏悔肩铠 ",
						id = 11963,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_25",
						quality = 2,
					},
					[3] = {
						name = "钢条护甲",
						id = 12049,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_16",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "把雷布里的头颅交给燃烧平原的尤卡·斯库比格特。",
			},
			[3] = {
				note = "巨型银矿可从艾萨拉的巨人们那里得到。格罗姆之血可以请学习了草药学的玩家帮助寻找。 你可以在（安戈洛环形山 - 葛拉卡温泉; "..YELLOW.."31,50"..WHITE.."）为瓶子装满水。\n完成任务后，你可以使用后门而不必杀死法拉克斯。",
				followup = "无后续",
				attain = 50,
				aim = "将4份格罗姆之血、10块巨型银矿和装满水的娜玛拉之瓶交给黑石深渊的娜玛拉小姐。",
				title = "爱情药水", -- 4201
				location = "将4份格罗姆之血、10块巨型银矿和装满水的娜玛拉之瓶交给黑石深渊的娜玛拉小姐。",
				level = 54,
				rewards = {
					[1] = {
						name = "镣铐护腕",
						id = 11962,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_13",
						quality = 3,
					},
					[2] = {
						name = "娜玛拉的腰带",
						id = 11866,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_11",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "前导任务由药剂师金格（幽暗城 - 炼金房; "..YELLOW.."50,68"..WHITE.."）给予。\n秘方在某个守卫身上，只要你破坏"..YELLOW.."[15]"..WHITE.."的酒桶这些守卫就会出现。",
				followup = "无后续",
				attain = 50,
				aim = "把遗失的雷酒秘方交给卡加斯的薇薇安·拉格雷。",
				title = "把遗失的雷酒秘方带给卡拉诺斯的拉格纳·雷酒。",
				location = "暗法师薇薇安·拉格雷（荒芜之地 - 卡加斯; "..YELLOW.."2,47"..WHITE.."）",
				level = 55,
				rewards = {
					[1] = {
						name = "超强治疗药水",
						id = 3928,
						subtext = "药水",
						icon = "INV_Potion_53",
						quality = 1,
					},
					[2] = {
						name = "强效法力药水",
						id = 6149,
						subtext = "药水",
						icon = "INV_Potion_73",
						quality = 1,
					},
					[3] = {
						name = "迅捷木槌",
						id = 11964,
						subtext = "主手 锤",
						icon = "INV_Mace_08",
						quality = 2,
					},
					[4] = {
						name = "叉刃巨斧",
						id = 12000,
						subtext = "双手 斧",
						icon = "INV_Axe_02",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "到黑石深渊去取得10份元素精华。你应该在那些作战傀儡和傀儡制造者身上找找，另外，薇薇安·拉格雷也提到了一些有关元素生物的话题……",
			},
			[5] = {
				note = "你可以从"..YELLOW.."[8]"..WHITE.."的宝箱里找到山脉之心。你必须打开黑色宝库所有的小宝箱出来 Boss 之后才能拿到钥匙。",
				followup = "无后续",
				attain = 50,
				aim = "把山脉之心交给燃烧平原的麦克斯沃特·尤博格林。",
				title = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
				location = "麦克斯沃特·尤博格林（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "矮人可在黑石深渊第一部分找到。\n卡加斯的高图斯在瞭望塔顶（荒芜之地; "..YELLOW.."5,47"..WHITE.."）。",
				followup = "格杀勿论：高阶黑铁军官", -- 4082
				attain = 48,
				aim = "到黑石深渊去消灭那些邪恶的侵略者！军官高图斯要你去杀死15个铁怒卫士、10个铁怒狱卒和5个铁怒步兵。完成任务之后回去向他复命。",
				title = "格杀勿论：黑铁矮人", -- 4081
				location = "通缉（荒芜之地 - 卡加斯; "..YELLOW.."3,47"..WHITE.."）",
				level = 52,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "矮人可以在"..YELLOW.."[11]"..WHITE.."贝尔加附近被找到。卡加斯的高图斯在瞭望塔顶（荒芜之地; "..YELLOW.."5,47"..WHITE.."）。\n任务开始于雷克斯洛特（荒芜之地 - 卡加斯; "..YELLOW.."5,47"..WHITE.."）。 格拉克·洛克鲁布位置在燃烧平原（"..YELLOW.."38,35"..WHITE.."）。 要绑定他并开始护送任务（精英），他的生命需要减少到低于50%。",
				followup = "格拉克·洛克鲁布 -> 押送囚徒（护送任务）", -- 4122 -> 4121
				attain = 50,
				aim = "到黑石深渊去消灭那些邪恶的侵略者！高图斯军阀要你杀死10个铁怒医师、10个铁怒士兵和10个铁怒军官。完成任务之后回去向他复命。",
				title = "格杀勿论：高阶黑铁军官", -- 4082
				location = "通缉（荒芜之地 - 卡加斯; "..YELLOW.."3,47"..WHITE.."）",
				level = 54,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "格杀勿论：黑铁矮人", -- 4081
			},
			[8] = {
				note = "安格弗将军位置在"..YELLOW.."[13]"..WHITE.."。注意：当他生命低于30%时，他会召唤帮手！",
				followup = "无后续",
				attain = 52,
				aim = "到黑石深渊去杀掉安格弗将军！当任务完成之后向军官高图斯复命。",
				title = "行动：杀死安格弗将军", -- 4132
				location = "矮人可在黑石深渊第一部分找到。\n卡加斯的高图斯在瞭望塔顶（荒芜之地; "..YELLOW.."5,47"..WHITE.."）。",
				level = 58,
				rewards = {
					[1] = {
						name = "征服者勋章",
						id = 12059,
						subtext = "颈部",
						icon = "INV_Jewelry_Amulet_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "格拉克·洛克鲁布 -> 押送囚徒（护送任务）", -- 4122 -> 4121
			},
			[9] = {
				note = "前导任务来自圣者塞朵拉·穆瓦丹尼（荒芜之地 - 卡加斯; "..YELLOW.."3,47"..WHITE.."）。\n你可以在"..YELLOW.."[14]"..WHITE.."发现阿格曼奇。",
				followup = "无后续",
				attain = 52,
				aim = "找到并杀掉傀儡统帅阿格曼奇，将他的头交给鲁特维尔。你还需要从守卫着阿格曼奇的狂怒傀儡和战斗傀儡身上收集10块完整的元素核心。",
				title = "机器的崛起", -- 4063
				location = "鲁特维尔·沃拉图斯（荒芜之地; "..YELLOW.."25,44"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "蓝月披肩",
						id = 12109,
						subtext = "背部",
						icon = "INV_Shoulder_02",
						quality = 2,
					},
					[2] = {
						name = "雨法师斗篷",
						id = 12110,
						subtext = "背部",
						icon = "INV_Misc_Cape_16",
						quality = 2,
					},
					[3] = {
						name = "黑陶鳞片护甲",
						id = 12108,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_16",
						quality = 2,
					},
					[4] = {
						name = "熔岩护手",
						id = 12111,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_26",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "机器的崛起", -- 4063
			},
			[10] = {
				note = "此系列任务始于卡拉然·温布雷（灼热峡谷; "..YELLOW.."39,38"..WHITE.."）。\n 贝尔加在"..YELLOW.."[11]"..WHITE.."。",
				followup = "无后续",
				attain = 52,
				aim = "到黑石深渊去杀掉贝尔加。\n你只知道这个巨型怪物住在黑石深渊的最深处。记住你要使用特殊的黑龙皮从贝尔加的尸体上采集烈焰精华。\n将你采集到的烈焰精华交给塞勒斯·萨雷芬图斯。",
				title = "烈焰精华",
				location = "塞勒斯·萨雷芬图斯（燃烧平原; "..YELLOW.."94,31"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "页岩斗篷",
						id = 12066,
						subtext = "背部",
						icon = "INV_Misc_Cape_02",
						quality = 2,
					},
					[2] = {
						name = "龙皮肩铠",
						id = 12082,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_16",
						quality = 2,
					},
					[3] = {
						name = "火山腰带",
						id = 12083,
						subtext = "腰部 布甲",
						icon = "INV_Belt_11",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无瑕之焰 -> 烈焰精华", -- 3442 -> 4022
			},
			[11] = {
				note = "伊森迪奥斯在"..YELLOW.."[10]"..WHITE.."。",
				followup = "无后续",
				attain = 48,
				aim = "进入黑石深渊并找到伊森迪奥斯。杀掉它，然后把你找到的信息汇报给桑德哈特。",
				title = "不和谐的火焰", -- 3907
				location = "桑德哈特（荒芜之地 - 卡加斯; "..YELLOW.."3,48"..WHITE.."）",
				level = 56,
				rewards = {
					[1] = {
						name = "阳焰斗篷",
						id = 12113,
						subtext = "背部",
						icon = "INV_Misc_Cape_08",
						quality = 2,
					},
					[2] = {
						name = "夜暮手套",
						id = 12114,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_17",
						quality = 2,
					},
					[3] = {
						name = "地穴恶魔护腕",
						id = 12112,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_17",
						quality = 2,
					},
					[4] = {
						name = "坚定手套",
						id = 12115,
						subtext = "腰部 板甲",
						icon = "INV_Belt_34",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "不和谐的烈焰", -- 3906
			},
			[12] = {
				note = "前导任务来自桑德哈特（荒芜之地 - 卡加斯; "..YELLOW.."3,48"..WHITE.."）。派隆就在副本入口处前。\n 每个元素生物都可能会掉落精华。",
				followup = "无后续",
				attain = 48,
				aim = "到黑石深渊去取得10份元素精华。你应该在那些作战傀儡和傀儡制造者身上找找，另外，薇薇安·拉格雷也提到了一些有关元素生物的话题……",
				title = "最后的元素", -- 7201
				location = "暗法师薇薇安·拉格雷（荒芜之地 - 卡加斯; "..YELLOW.."2,47"..WHITE.."）",
				level = 54,
				rewards = {
					[1] = {
						name = "拉格雷的徽记之戒",
						id = 12038,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "不和谐的烈焰", -- 3906
			},
			[13] = {
				note = "前导任务来自桑德哈特（荒芜之地 - 卡加斯; "..YELLOW.."3,48"..WHITE.."）。派隆就在副本入口处前。\n你能在"..YELLOW.."[3]"..WHITE.."找到指挥官哥沙克。位于"..YELLOW.."[5]"..WHITE.."的审讯官格斯塔恩掉落打开监狱的钥匙。如果你跟他交谈并开始下一个任务，敌人便会出现。",
				followup = "出了什么事？", -- 3982
				attain = 48,
				aim = "在黑石深渊里找到指挥官哥沙克。\n在那幅草图上画着的是一个铁栏后面的兽人，也许你应该到某个类似监狱的地方去找找看。",
				title = "指挥官哥沙克", -- 3981
				location = "神射手贾拉玛弗（荒芜之地 - 卡加斯; "..YELLOW.."5,47"..WHITE.."）",
				level = 52,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "不和谐的烈焰", -- 3906
			},
			[14] = {
				note = "与卡兰·巨锤和萨尔交谈后，你将得到这个任务。\n达格兰·索瑞森大帝在"..YELLOW.."[21]"..WHITE.."。虽然公主会治疗达格兰，但是如果想完成任务，就一定不要杀死公主。切记，切记！！！尝试打断公主的治疗施法。",
				followup = "拯救公主？", -- 4004
				attain = 48,
				aim = "杀掉达格兰·索瑞森大帝，然后将铁炉堡公主茉艾拉·铜须从他的邪恶诅咒中拯救出来。",
				title = "拯救公主", -- 4003
				location = "将奥妮克希亚的头颅交给奥格瑞玛的萨尔。 ",
				level = 59,
				rewards = {
					[1] = {
						name = "萨尔的决心",
						id = 12544,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_05",
						quality = 3,
					},
					[2] = {
						name = "奥格瑞玛之眼",
						id = 12545,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "指挥官哥沙克 -> 出了什么事？ (x2) -> 东部王国", -- 3981 -> 4002
			},
			[15] = {
				note = "完成这个任务之后你就可以从洛索斯·天痕旁边的传送石进入熔火之心。\n熔火碎片在"..YELLOW.."[23]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "进入黑石深渊，在通往熔火之心的传送门附近找到一块熔火碎片，然后回到黑石山脉的洛索斯·天痕那里。",
				title = "熔火之心的传送门", -- 7848
				location = "洛索斯·天痕（黑石山; "..YELLOW.."副本入口地图[2]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "对于不同的职业后续任务是不同的。",
				followup = "各个职业的职业任务（T0.5升级任务）",
				attain = 58,
				aim = "前往黑石深渊竞技场并在你被裁决者格里斯通宣判时将挑衅旗帜放在它的中央。杀死瑟尔伦和他的战士们，再带着第一块瓦萨拉克护符回到东瘟疫之地的安希恩·哈莫那里。",
				title = "挑战（T0.5升级任务）", -- 9015
				location = "法尔林·树影（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1']"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "煽动者的附魔。整个任务线从奥格瑞玛萨尔的房间的任务\'超自然装置\'开始", -- 8923
			},
			[17] = {
				note = "只有采矿技能大于230才能接到此任务，这个任务会是你学会如何熔炼黑铁矿石。材料如下：2个[红宝石]，20个[金锭]，10个[真银锭]。完成之后，如果你有[黑铁矿石]你可以在黑熔炉"..YELLOW.."[22]"..WHITE.."熔炼黑铁。",
				followup = "无后续",
				attain = 40,
				aim = "鬼魂之杯的塞娜尼·雷心要你找到他想要的材料。",
				title = "鬼魂之杯（采矿任务）", -- 4083
				location = "塞娜尼·雷心（黑石深渊; "..YELLOW.."[18]"..WHITE.."）",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[18] = {
				note = "任务线起始于泰尔阿比姆岛东边的比克斯·螺旋熔丝处。",
				followup = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
				attain = 50,
				aim = "进入黑石深渊，从达尼格·黑须那里夺回\'极其强效的鼻烟\'（位于住所附近，在桥后面的"..YELLOW.."[7]"..WHITE.."和"..YELLOW.."[8]"..WHITE.."之间，住所之后），交给塔纳利斯的蒸汽车队港口的贾比。",
				title = "(TW)18. 行动：帮助杰比", -- 40757
				location = "进入黑石深渊，从达尼格·黑须那里夺回\'极其强效的鼻烟\'（位于住所附近，在桥后面的"..YELLOW.."[7]"..WHITE.."和"..YELLOW.."[8]"..WHITE.."之间，住所之后），交给塔纳利斯的蒸汽车队港口的贾比。",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "螺旋熔丝行动1000 -> 修复螺旋熔丝行动1000", --40755,40756
			},
			[19] = {
				note = "这个任务需要收集4个物品。\n1) 岩浆凝结器（黑石深渊中的岩浆凝结器箱）\n2) 精巧的奥金桶（黑石塔中的精巧的奥金桶容器）\n3) 熔火碎片（熔火之心中的熔火毁灭者）\n4) 黑铁步枪（由工程师制造）。\n为了完成建造，我还需要炽热核心（3个，从熔火之心中获得）和附魔瑟银锭（10个）。",
				followup = "无后续",
				attain = 55,
				aim = "我需要从黑石深渊中获取一个岩浆凝结器，你可以在魔像实验室附近找到它"..YELLOW.."[14]"..WHITE..".",
				title = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
				location = "任务线起始于泰尔阿比姆岛东边的比克斯·螺旋熔丝处。",
				level = 60,
				rewards = {
					[1] = {
						name = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
						id = 61068,
						subtext = "枪械",
						icon = "Spell_frost_fireresistancetotem",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
			},
			[20] = {
				note = "这个任务线起始于奥瓦克·斯特恩洛克旁边的拉德甘·深焰，接受任务\'获得奥瓦克的信任\'。",
				followup = "无后续",
				attain = 45,
				aim = "在黑石深渊深处击败25个暗石议员，交给燃烧平原的黑石小径上的奥瓦克·斯特恩洛克。",
				title = "(TW)20. 参议员复仇", -- 40464
				location = "奥瓦克·斯特恩洛克（红岭山-燃烧平原之间的小径"..YELLOW.."76,68"..WHITE.."，联盟营地的西边）",
				level = 56,
				rewards = {
					[1] = {
						name = "暗石徽章",
						id = 60668,
						subtext = "饰品",
						icon = "BTN_cr_GCOIN",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "赢得奥尔瓦克的信任 -> 听奥尔瓦克的故事 -> 斯特恩洛克的藏宝地 -> 矿工工会的叛乱",
			},
			[21] = {
				note = "这个任务线起始于奥瓦克·斯特恩洛克旁边的拉德甘·深焰，接受任务\'获得奥瓦克的信任\'。",
				followup = "无后续",
				attain = 45,
				aim = "在黑石深渊中找到并收集一个奥术魔像核心，来自魔像领主阿格曼奇"..YELLOW.."[14]"..WHITE.."，然后回到燃烧平原的黑石小径找拉德甘·深焰。",
				title = "(TW)21. 奥术傀儡核心", -- 40467
				location = "拉德甘·深焰（红岭山-燃烧平原之间的小径"..YELLOW.."76,68"..WHITE.."，联盟营地的西边）",
				level = 55,
				rewards = {
					[1] = {
						name = "充能魔像核心",
						id = 60672,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Pearl_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "获得奥瓦克的信任 -> 听奥瓦克的故事 -> 斯特恩洛克的藏宝 -> 发现魔像的秘密 -> 购买秘密信息", --40761
			},
			[22] = {
				note = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
				followup = "无后续",
				attain = 30,
				aim = "我需要的最后一个部件是用于内骨架的高质量精金棒。我相信斯坦索姆的锻造厂过去曾制作过这样的棒子。",
				title = "(TW)18. 建造一个重击者", -- 80401
				location = "奥格索普·奥布诺提库斯 <大师级侏儒工程师>（荆棘谷；藏宝海湾 "..YELLOW.."28.4,76.3"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "强化红色破碎者",
						id = 81253,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[2] = {
						name = "强化绿色破碎者",
						id = 81252,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[3] = {
						name = "强化蓝色破碎者",
						id = 81251,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[4] = {
						name = "强化黑色破碎者",
						id = 81250,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "一个有力的大脑（仅限工程师）", --80398
			},
			[23] = {
				note = "仅在冬幕节活动期间可用！\n那些可恶的黑铁矮人偷走了它，毫无疑问将其藏在了黑石深渊深处的酒馆"..YELLOW.."[15]"..WHITE.."中。",
				followup = "无后续",
				attain = 45,
				aim = "在黑石深渊的洞穴中找回冬幕节酒桶，交给冬幕节谷的博玛恩·火斧。",
				title = "(TW)23. 冬幕节酒。", -- 40748
				location = "在黑石深渊的洞穴中找回冬幕节酒桶，交给冬幕节谷的博玛恩·火斧。",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
	},
	[6] = {
		name = "黑翼之巢",
		story = {
			[1] = "黑翼之巢，它位于黑石塔的最顶端。奈法利安就在那里进行着他的秘密计划的最后步骤，并准备摧毁拉格纳罗斯的势力，最终统治整个艾泽拉斯。",
			[2] = "座落在黑石山脉中的巨型要塞是由矮人建筑大师弗兰克罗恩·铸铁设计的，作为力量和实力的象征，这座要塞被邪恶的黑铁矮人占据了数个世纪之久。但是，黑龙死亡之翼的儿子奈法利安对这座要塞有着别的打算。他和他的黑龙军团占据了黑石塔的上层区域，并与黑石深渊中的那些侍奉火焰之王拉格纳罗斯的黑铁矮人不断交战。拉格纳罗斯找到了为岩石赋予生命的方法，并准备制造一支无坚不摧的傀儡大军，以此来帮助他实施征服整个黑石山的计划。",
			[3] = "而奈法利安则发誓要毁灭拉格纳罗斯，因此他近期以来加速了扩张军队的步伐，就像他的父亲死亡之翼曾经尝试过的那样。虽然死亡之翼最终失败了，但看起来奈法利安很有希望获得成功。他对于权力的疯狂渴求甚至引起了红龙军团的警觉——他们一直是黑龙最强大的敌人。不过，即便奈法利安的目标非常明显，他所采用的手段却不为人知。但是据信他正在尝试杂交各种颜色的龙以制造出最强大的战士。\n \n奈法利安的藏身之所被称为黑翼之巢，它位于黑石塔的最顶端。奈法利安就在那里进行着他的秘密计划的最后步骤，并准备摧毁拉格纳罗斯的势力，最终统治整个艾泽拉斯。",
				  },
		[1] = {
			[1] = {
				note = "只有一人能拾取碎片。阿纳克洛斯（塔纳利斯 - 时光之穴; "..YELLOW.."65,49"..WHITE.."）",
				followup = "卡利姆多的威力 (必须完成绿色和蓝色任务链。)", -- 8742
				attain = 60,
				aim = "干掉奈法利安并拿到红色节杖碎片。把红色节杖碎片带给塔纳利斯时光之穴门口的阿纳克洛斯。你必须在5小时之内完成这个任务。",
				title = "奈法里奥斯的腐蚀", -- 8730
				location = "堕落的瓦拉斯塔兹（黑翼之巢; "..YELLOW.."[2]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "玛瑙镶饰护腿",
						id = 21530,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_Mail_04",
						quality = 4,
					},
					[2] = {
						name = "暗影屏蔽护符",
						id = 21529,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_17",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "守护之龙", -- 8555
			},
			[2] = {
				note = "伯瓦尔·弗塔根公爵（暴风城 - 暴风要塞; "..YELLOW.."78,20"..WHITE.."）。接下来前往艾法希比元帅（暴风城 - 英雄谷; "..YELLOW.."67,72"..WHITE.."）领取奖励。",
				followup = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				attain = 60,
				aim = "将奈法利安的头颅交给暴风城的伯瓦尔·弗塔根公爵。 ",
				title = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				location = "奈法利安的头颅（奈法利安掉落; "..YELLOW.."[9]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "屠龙大师勋章",
						id = 19383,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_18",
						quality = 4,
					},
					[2] = {
						name = "屠龙大师宝珠",
						id = 19366,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 4,
					},
					[3] = {
						name = "屠龙大师之戒",
						id = 19384,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_41",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "只有一人能拾取头颅。（现版本不再限一人）",
				followup = "正义之路", -- 8301
				attain = 60,
				aim = "将勒什雷尔的头颅交给希利苏斯塞纳里奥要塞的流沙守望者巴里斯托尔斯。 ",
				title = "唯一的领袖", -- 8288
				location = "勒什雷尔的头颅（勒什雷尔掉落; "..YELLOW.."[3]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "明天的希望", -- 8286
			},
			[4] = {
				note = "可以被多个人拾取. 龙语傻瓜教程 (从桌子上; "..GREEN.."[2]"..WHITE..")",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
				attain = 60,
				aim = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				title = "唯一的方案", -- 8620
				location = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				level = 60,
				rewards = {
					[1] = {
						name = "精神力量之侏儒头巾",
						id = 21517,
						subtext = "头部 布甲",
						icon = "INV_Helmet_63",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "螳螂捕蝉！", -- 8606
			},
			[5] = {
				note = "书籍《魔法锁和钥匙的论文》位于最后的Boss房间 "..YELLOW.."[9]"..WHITE..", 在王座旁边。",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "找到《魔法锁和钥匙的论文》并将其带回给范多尔。 据传它被保存在黑翼巢穴中。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "多万·布雷斯温德（尘泥沼泽 - "..YELLOW.."[71.1,73.2]"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
			[6] = {
				note = "奈法利安 "..YELLOW.."[9]"..WHITE.."掉落《烧焦的沃根多尔副本》。\n任务线从稀有掉落传奇物品\'艾露恩之镰\'开始，这个物品是从"..YELLOW.."[卡拉赞]"..WHITE.."的布莱克沃尔德勋爵二世掉落的。",
				followup = "月神镰刀 "..YELLOW.."[卡拉赞上层]"..WHITE.." ", -- 41087
				attain = 58,
				aim = "从维克多·奈法里奥斯领主领主那里取回《沃根多尔：血之维度的神话》的一份副本。",
				title = "Scythe of the Goddess",
				location = "大德鲁伊梦风 (海加尔山 - 诺达纳尔; "..YELLOW.."84.8,29.3"..WHITE.." 大树的顶层)",
				level = 60,
				rewards = {
				},
				prequest = "Scythe of the Goddess",
			},
		},
		[2] = {
			[1] = {
				note = "只有一人能拾取碎片。阿纳克洛斯（塔纳利斯 - 时光之穴; "..YELLOW.."65,49"..WHITE.."）",
				followup = "卡利姆多的威力 (必须完成绿色和蓝色任务链。)", -- 8742
				attain = 60,
				aim = "干掉奈法利安并拿到红色节杖碎片。把红色节杖碎片带给塔纳利斯时光之穴门口的阿纳克洛斯。你必须在5小时之内完成这个任务。",
				title = "奈法里奥斯的腐蚀", -- 8730
				location = "堕落的瓦拉斯塔兹（黑翼之巢; "..YELLOW.."[2]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "玛瑙镶饰护腿",
						id = 21530,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_Mail_04",
						quality = 4,
					},
					[2] = {
						name = "暗影屏蔽护符",
						id = 21529,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_17",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "守护之龙", -- 8555
			},
			[2] = {
				note = "下一步前往萨鲁法尔大王（奥格瑞玛 - 力量谷; "..YELLOW.."51,76"..WHITE.."）领取奖励。",
				followup = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				attain = 60,
				aim = "将奈法利安的头颅交给奥格瑞玛的萨尔。",
				title = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				location = "奈法利安的头颅（奈法利安掉落; "..YELLOW.."[9]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "屠龙大师勋章",
						id = 19383,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_18",
						quality = 4,
					},
					[2] = {
						name = "屠龙大师宝珠",
						id = 19366,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 4,
					},
					[3] = {
						name = "屠龙大师之戒",
						id = 19384,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_41",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "只有一人能拾取头颅。（现版本不再限一人）",
				followup = "正义之路", -- 8301
				attain = 60,
				aim = "将勒什雷尔的头颅交给希利苏斯塞纳里奥要塞的流沙守望者巴里斯托尔斯。 ",
				title = "唯一的领袖", -- 8288
				location = "勒什雷尔的头颅（勒什雷尔掉落; "..YELLOW.."[3]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "明天的希望", -- 8286
			},
			[4] = {
				note = "可以被多个人拾取. 龙语傻瓜教程 (从桌子上; "..GREEN.."[2]"..WHITE..")",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
				attain = 60,
				aim = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				title = "唯一的方案", -- 8620
				location = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				level = 60,
				rewards = {
					[1] = {
						name = "精神力量之侏儒头巾",
						id = 21517,
						subtext = "头部 布甲",
						icon = "INV_Helmet_63",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "螳螂捕蝉！", -- 8606
			},
			[5] = {
				note = "书籍《魔法锁和钥匙的论文》位于最后的Boss房间 "..YELLOW.."[9]"..WHITE..", 在王座旁边。",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "找到《魔法锁和钥匙的论文》并将其带回给范多尔。 据传它被保存在黑翼巢穴中。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "多万·布雷斯温德（尘泥沼泽 - "..YELLOW.."[71.1,73.2]"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
			[6] = {
				note = "奈法利安 "..YELLOW.."[9]"..WHITE.."掉落《烧焦的沃根多尔副本》。\n任务线从稀有掉落传奇物品\'艾露恩之镰\'开始，这个物品是从"..YELLOW.."[卡拉赞]"..WHITE.."的布莱克沃尔德勋爵二世掉落的。",
				followup = "月神镰刀 "..YELLOW.."[卡拉赞上层]"..WHITE.." ", -- 41087
				attain = 58,
				aim = "从维克多·奈法里奥斯领主领主那里取回《沃根多尔：血之维度的神话》的一份副本。",
				title = "Scythe of the Goddess",
				location = "大德鲁伊梦风 (海加尔山 - 诺达纳尔; "..YELLOW.."84.8,29.3"..WHITE.." 大树的顶层)",
				level = 60,
				rewards = {
				},
				prequest = "Scythe of the Goddess",
			},
		},
	},
	[7] = {
		name = "黑暗深渊",
		story = "位于灰谷佐拉姆海岸的黑暗深渊曾经是为供奉暗夜精灵月神艾露尼尔建造的。然而，在大爆炸中，神庙受到极大的冲击然后沉入了海中。它一直保持着原样——直到，其蕴含的古老的力量吸引来了纳迦和萨特。传说，古代怪兽阿库麦尔就居住在神庙遗迹中。作为古代之神最喜欢的宠物之一，阿库麦尔就一直生活在这个地区进行捕食。在阿库麦尔的吸引下，一群被称作幕光之锤的教徒也聚集在这里从事邪恶的勾当。",
		[1] = {
			[1] = {
				note = "你可以在靠近"..YELLOW.."[2]"..WHITE.."的水中找到手稿。",
				followup = "无后续",
				attain = 10,
				aim = "把洛迦里斯手稿带给铁炉堡的葛利·硬骨。",
				title = "深渊中的知识", -- 971
				location = "把洛迦里斯手稿带给铁炉堡的葛利·硬骨。",
				level = 23,
				rewards = {
					[1] = {
						name = "鼓励之戒",
						id = 6743,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_08",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "前导任务可以从阿古斯·夜语（暴风城 - 花园; "..YELLOW.."21,55"..WHITE.."）处得到。 黑暗深渊副本里面和门前的所有纳迦都可能掉落脑干。",
				followup = "无后续",
				attain = 18,
				aim = "奥伯丁的戈沙拉·夜语需要8块堕落者的脑干。",
				title = "研究堕落", -- 1275
				location = "戈沙拉·夜语（黑海岸 - 奥伯丁; "..YELLOW.."38,43"..WHITE.."）",
				level = 24,
				rewards = {
					[1] = {
						name = "虫壳护腕",
						id = 7003,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_06",
						quality = 2,
					},
					[2] = {
						name = "教士斗篷",
						id = 7004,
						subtext = "背部",
						icon = "INV_Misc_Cape_18",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "遥远的旅途", -- 3765
			},
			[3] = {
				note = "你可以在"..YELLOW.."[4]"..WHITE.."找到银月守卫塞尔瑞德。",
				followup = "黑暗深渊中的恶魔", -- 1200
				attain = 18,
				aim = "到黑色深渊去找到银月守卫塞尔瑞德。",
				title = "寻找塞尔瑞德", -- 1198
				location = "哨兵山德拉斯（达纳苏斯 - 工匠区; "..YELLOW.."55,24"..WHITE.."）",
				level = 24,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "克尔里斯在"..YELLOW.."[8]"..WHITE.."。你可以哨兵找到塞尔高姆（达纳苏斯 - 工匠区; "..YELLOW.."55,24"..WHITE.."）。注意！如果你点燃了克尔里斯旁边的火焰，敌人会出现并攻击你。",
				followup = "无后续",
				attain = 18,
				aim = "把梦游者克尔里斯的头颅交给达纳苏斯的哨兵塞尔高姆。",
				title = "黑暗深渊中的恶魔", -- 1200
				location = "到黑色深渊去找到银月守卫塞尔瑞德。",
				level = 27,
				rewards = {
					[1] = {
						name = "墓碑节杖",
						id = 7001,
						subtext = "魔杖",
						icon = "INV_Wand_04",
						quality = 3,
					},
					[2] = {
						name = "极光圆盾",
						id = 7002,
						subtext = "盾牌",
						icon = "INV_Shield_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "寻找塞尔瑞德", -- 1198
			},
			[5] = {
				note = "每个暮光敌人都会掉落坠饰。",
				followup = "无后续",
				attain = 20,
				aim = "收集10个暮光坠饰，把它们交给达纳苏斯的银月守卫玛纳杜斯。",
				title = "暮光之锤的末日", -- 1199
				location = "银月守卫玛纳杜斯（达纳苏斯 - 工匠区; "..YELLOW.."55,23"..WHITE.."）",
				level = 25,
				rewards = {
					[1] = {
						name = "云光长靴",
						id = 6998,
						subtext = "脚部 布甲",
						icon = "INV_Boots_05",
						quality = 2,
					},
					[2] = {
						name = "赤木束带",
						id = 7000,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_04",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "只有术士才能得到这个任务！3块索兰鲁克宝珠的碎片，你可以从"..YELLOW.."[黑暗深渊]"..WHITE.."的暮光侍僧那里得到。那块索兰鲁克宝珠的大碎片，你要去"..YELLOW.."[影牙城堡]"..WHITE.."找影牙魔魂狼人。",
				followup = "无后续",
				attain = 20,
				aim = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				title = "索兰鲁克宝珠（术士任务）", -- 1740
				location = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				level = 25,
				rewards = {
					[1] = {
						name = "索兰鲁克宝珠（术士任务）", -- 1740
						id = 6898,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 2,
					},
					[2] = {
						name = "索拉鲁克法杖",
						id = 15109,
						subtext = "法杖",
						icon = "INV_Staff_09",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "前导任务《帮助耶努萨克雷》可以在苏纳曼（石爪山脉 - 烈日石居; "..YELLOW.."47,64"..WHITE.."）接到。蓝宝石多生长在通往黑暗深渊入口的那条通道的洞穴墙壁上。",
				followup = "无",
				attain = 17,
				aim = "收集20颗阿库麦尔蓝宝石，把它们交给灰谷的耶努萨克雷。",
				title = "阿库麦尔水晶", -- 6563
				location = "耶努萨克雷（灰谷 - 佐拉姆加前哨站; "..YELLOW.."11,33"..WHITE.."）",
				level = 22,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "前导任务《帮助耶努萨克雷》可以在苏纳曼（石爪山脉 - 烈日石居; "..YELLOW.."47,64"..WHITE.."）接到。蓝宝石多生长在通往黑暗深渊入口的那条通道的洞穴墙壁上。",
			},
			[2] = {
				note = "潮湿的便笺可从黑暗深渊海潮祭司处得到（5% 掉落几率）。然后去耶努萨克雷（灰谷 - 佐拉姆加前哨站; "..YELLOW.."11,33"..WHITE.."）。洛古斯·杰特在"..YELLOW.."[6]"..WHITE.."。",
				followup = "无后续",
				attain = 17,
				aim = "把潮湿的便笺交给灰谷的耶努萨克雷。 -> 杀掉黑暗深渊里的洛古斯·杰特，然后向灰谷的耶努萨克雷复命。",
				title = "上古之神的仆从", -- 6564 -> 6565
				location = "潮湿的便笺（掉落）（请见注释）",
				level = 26,
				rewards = {
					[1] = {
						name = "巨拳指环 ",
						id = 17694,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_02",
						quality = 2,
					},
					[2] = {
						name = "栗壳衬肩",
						id = 17695,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_09",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "深渊之核在"..YELLOW.."[7]"..WHITE.."区水域里。当你得到深远之核后，阿奎尼斯男爵会出现并攻击你。他会掉落一件任务物品，你要把它带给耶努萨克雷。",
				followup = "无后续",
				attain = 21,
				aim = "把深渊之核交给灰谷佐拉姆加前哨站里的耶努萨克雷。",
				title = "无",
				location = "耶努萨克雷（灰谷 - 佐拉姆加前哨站; "..YELLOW.."11,33"..WHITE.."）",
				level = 27,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "克尔里斯在"..YELLOW.."[8]"..WHITE.."。巴珊娜·符文图腾可以在（雷霆崖 - 长者高地 "..YELLOW.."70,33"..WHITE.."）处找到。注意！如果你点燃了克尔里斯身旁的火焰，会出现敌人攻击你。",
				followup = "无后续",
				attain = 18,
				aim = "把梦游者克尔里斯的头颅带回雷霆崖交给巴珊娜·符文图腾 。",
				title = "黑暗深渊中的恶魔", -- 1200
				location = "到黑色深渊去找到银月守卫塞尔瑞德。",
				level = 27,
				rewards = {
					[1] = {
						name = "墓碑节杖",
						id = 7001,
						subtext = "魔杖",
						icon = "INV_Wand_04",
						quality = 3,
					},
					[2] = {
						name = "极光圆盾",
						id = 7002,
						subtext = "盾牌",
						icon = "INV_Shield_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "只有术士才能得到这个任务！3块索兰鲁克宝珠的碎片，你可以从"..YELLOW.."[黑暗深渊]"..WHITE.."的暮光侍僧那里得到。那块索兰鲁克宝珠的大碎片，你要去"..YELLOW.."[影牙城堡]"..WHITE.."找影牙魔魂狼人。",
				followup = "无后续",
				attain = 20,
				aim = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				title = "索兰鲁克宝珠（术士任务）", -- 1740
				location = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				level = 25,
				rewards = {
					[1] = {
						name = "索兰鲁克宝珠（术士任务）", -- 1740
						id = 6898,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 2,
					},
					[2] = {
						name = "索拉鲁克法杖",
						id = 15109,
						subtext = "法杖",
						icon = "INV_Staff_09",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "完成任务#3时使用深渊之石 "..YELLOW.."[7]"..WHITE.."会召唤阿奎尼斯男爵，他会掉落奇怪的水晶球，开始这个任务。",
				followup = "无后续",
				attain = 21,
				aim = "把奇怪的水球交给灰谷佐拉姆加前哨站的耶努萨克雷。",
				title = "深渊之核在"..YELLOW.."[7]"..WHITE.."区水域里。当你得到深远之核后，阿奎尼斯男爵会出现并攻击你。他会掉落一件任务物品，你要把它带给耶努萨克雷。",
				location = "奇怪的水晶球（黑暗深渊; "..YELLOW.."[7]"..WHITE.."）",
				level = 30,
				rewards = {
					[1] = {
						name = "逃犯弯刀", -- 16886
						id = 16886,
						subtext = "单手 剑",
						icon = "INV_Sword_33",
						quality = 3,
					},
					[2] = {
						name = "女巫之指", -- 16887
						id = 16887,
						subtext = "副手",
						icon = "INV_Wand_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
		},
	},
	[8] = {
		name = "黑石塔下层",
		story = "黑石深渊深处的巨大堡垒是由矮人建筑大师弗兰克罗恩·铸铁所设计的。这个堡垒是矮人力量的象征并被邪恶的黑铁矮人占据了数个世纪。然而，奈法利安——死亡之翼狡猾的儿子——对这个巨大的堡垒别有意图。他和他的黑龙军团占据了上层黑石塔并向占据着黑石深渊的黑铁矮人宣战。奈法利安知道矮人是由强大的火元素拉格纳罗斯所领导的，所以他立志要摧毁他的敌人并将黑石深渊全都占为己有。",
		[1] = {
			[1] = {
				note = "你可以在"..YELLOW.."[7]"..WHITE.."和"..YELLOW.."[9]"..WHITE.."附近找到石板。\n任务奖励来自《面对叶基亚》。 你可以在勘查员詹斯·铁靴旁边找到叶基亚。",
				followup = "面对叶基亚", -- 8181
				attain = 40,
				aim = "将第五块和第六块摩沙鲁石板交给塔纳利斯的勘查员詹斯·铁靴。",
				title = "最后的石板", -- 4788
				location = "勘查员詹斯·铁靴（塔纳利斯 - 热砂港; "..YELLOW.."66,23"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "Faded Hakkari Cloak",
						id = 20218,
						subtext = "背部",
						icon = "INV_Misc_Cape_13",
						quality = 3,
					},
					[2] = {
						name = "Tattered Hakkari Cape",
						id = 20219,
						subtext = "背部",
						icon = "INV_Misc_Cape_14",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "失落的摩沙鲁石板", -- 5065
			},
			[2] = {
				note = "你可以在"..YELLOW.."[17]"..WHITE.."找到座狼幼崽。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去找到血斧座狼幼崽。使用笼子来捕捉这些凶猛的小野兽，然后把笼中的座狼幼崽交给基布雷尔。",
				title = "基布雷尔的特殊宠物", -- 4729
				location = "基布雷尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,22"..WHITE.."）",
				level = 59,
				rewards = {
					[1] = {
						name = "到黑石塔去找到血斧座狼幼崽。使用笼子来捕捉这些凶猛的小野兽，然后把笼中的座狼幼崽交给基布雷尔。",
						id = 12264,
						subtext = "物品",
						icon = "INV_Box_PetCarrier_01",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在"..YELLOW.."[13]"..WHITE.."附近找到蜘蛛卵。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去为基布雷尔收集15枚尖塔蜘蛛卵。",
				title = "蜘蛛卵", -- 4862
				location = "基布雷尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,22"..WHITE.."）",
				level = 59,
				rewards = {
					[1] = {
						name = "烟网蜘蛛笼",
						id = 12529,
						subtext = "物品",
						icon = "INV_Box_Birdcage_01",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "烟网蛛后在"..YELLOW.."[13]"..WHITE..".如果中毒后解除，那么任务就会失败。",
				followup = "无后续",
				attain = 55,
				aim = "你可以在黑石塔的中心地带找到烟网蛛后。与她战斗，让她在你体内注入毒汁。如果你有能力的话，就杀死她吧。当你中毒之后，回到狼狈不堪的约翰那儿，他会从你的身体里抽取这些‘蛛后的乳汁’。 ",
				title = "蛛后的乳汁", -- 4866
				location = "狼狈不堪的约翰（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "约翰的无尽之杯",
						id = 15873,
						subtext = "饰品",
						icon = "INV_Drink_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "哈雷肯在"..YELLOW.."[17]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去摧毁那里的座狼源头。当你离开的时候，赫林迪斯喊出了一个名字：哈雷肯。这个词就是兽人语中‘座狼’的意思。",
				title = "座狼之源", -- 4701
				location = "此系列任务始于赫林迪斯·河角（燃烧平原 - 摩根的岗哨"..YELLOW.."85,68"..WHITE.."）。\n温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。完成这个任务后，你要回到麦克斯韦尔元帅那里.",
				level = 59,
				rewards = {
					[1] = {
						name = "阿斯托里长袍",
						id = 15824,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_07",
						quality = 2,
					},
					[2] = {
						name = "吊钩外套",
						id = 15825,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Plate06",
						quality = 2,
					},
					[3] = {
						name = "碧鳞胸甲",
						id = 15827,
						subtext = "胸部 锁甲",
						icon = "inv_misc_desecrated_mailchest",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "要得到瓦罗什的蟑螂，你必须首先杀死乌洛克"..YELLOW.."[15]"..WHITE.."。要完成召唤，你需要长矛和 欧莫克大王的头颅"..YELLOW.."[5]"..WHITE.."。长矛在"..YELLOW.."[3]"..WHITE.."。在召唤出乌洛克之前，会出现几群食人魔，你可以用长矛来伤害它们。",
				followup = "无后续",
				attain = 55,
				aim = "阅读瓦罗什的卷轴。将瓦罗什的蟑螂交给他。",
				title = "乌洛克", -- 4867
				location = "瓦罗什（黑石塔下层; "..YELLOW.."[2]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "棱石护符",
						id = 15867,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Variety_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "你可以在前往烟网蛛后的路上找到比修的装置"..YELLOW.."[13]"..WHITE.."。\n麦克斯韦元帅（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,58"..WHITE.."）。",
				followup = "给麦克斯韦尔的消息", -- 5002
				attain = 55,
				aim = "找到比修的装置并把它们还给她。祝你好运！",
				title = "比修的装置", -- 5001
				location = "到黑石塔去查明比修的下落。",
				level = 59,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "奥妮克希亚钥匙前导任务。欧莫克大王在"..YELLOW.."[5]"..WHITE.."，指挥官沃恩在 "..YELLOW.."[9]"..WHITE.."，维姆萨拉克在 "..YELLOW.."[19]"..WHITE.."。黑石文件在3个Boss的其中一个边上。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去消灭指挥官沃恩、欧莫克大王和维姆萨拉克。完成任务之后回到麦克斯韦尔元帅处复命。",
				title = "麦克斯韦尔的任务", -- 5081
				location = "温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。\n如果你清掉法律之环一圈的怪（"..YELLOW.."[6]"..WHITE.."）和通向副本门口的怪的话会轻松很多。护送完成后去找麦克斯韦尔元帅（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,68"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "维姆萨拉克的镣铐",
						id = 13958,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_04",
						quality = 3,
					},
					[2] = {
						name = "欧莫克的瘦身腰带",
						id = 13959,
						subtext = "腰部 板甲",
						icon = "INV_Belt_13",
						quality = 3,
					},
					[3] = {
						name = "哈雷肯的笼口",
						id = 13961,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_24",
						quality = 3,
					},
					[4] = {
						name = "沃什加斯的绳索",
						id = 13962,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_15",
						quality = 3,
					},
					[5] = {
						name = "沃恩的邪恶之握",
						id = 13963,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_15",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4"..AQDiscription_OR.."5",
				},
				prequest = "给麦克斯韦尔的消息", -- 5002
			},
			[9] = {
				note = "燃棘宝钻从欧莫克大王"..YELLOW.."[5]"..WHITE.."，尖石宝钻从指挥官沃恩"..YELLOW.."[9]"..WHITE.."，血斧宝钻从维姆萨拉克"..YELLOW.."[19]"..WHITE.."。原始晋升印章是黑石塔所有小怪掉落，完成这个之后你就能得到黑石塔上层的钥匙。",
				followup = "晋升印章", -- 4742
				attain = 57,
				aim = "找到三块命令宝石：燃棘宝钻、尖石宝钻和血斧宝钻。把它们和原始晋升印章一起交给维埃兰.",
				title = "晋升印章", -- 4742
				location = "维埃兰（黑石塔下层; "..YELLOW.."[1]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。\n如果你清掉法律之环一圈的怪（"..YELLOW.."[6]"..WHITE.."）和通向副本门口的怪的话会轻松很多。护送完成后去找麦克斯韦尔元帅（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,68"..WHITE.."）。",
				followup = "达基萨斯将军之死（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 5102
				attain = 55,
				aim = "把达基萨斯将军的命令交给燃烧平原的麦克斯韦尔元帅。",
				title = "达基萨斯将军的命令", -- 5089
				location = "达基萨斯将军的命令（维姆萨拉克掉落; "..YELLOW.."[19]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[11] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷，你可以从《寻找安泰恩》任务得到它。\n\n莫尔·灰蹄在"..YELLOW.."[9]"..WHITE.."召唤。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出莫尔·灰蹄的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[12] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷，你可以从《寻找安泰恩》任务得到它。\n\n莫尔·灰蹄在"..YELLOW.."[9]"..WHITE.."召唤。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "在比斯巨兽的房间里使用召唤火盆，召唤瓦塔拉克公爵。杀死他，对尸体使用瓦塔拉克的饰品。然后将瓦塔拉克的饰品还给瓦塔拉克公爵之魂。",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[13] = {
				note = "暗影猎手沃什加斯在"..YELLOW.."[7]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "到黑石塔去杀死暗影猎手沃什加斯，将沃什加斯的蛇石交给基尔拉姆。",
				title = "沃什加斯的蛇石（锻造-铸剑大师任务）", -- 5306
				location = "基尔拉姆（冬泉谷 - 永望镇; "..YELLOW.."61,37"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：黎明之刃",
						id = 12821,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[14] = {
				note = "煅造任务。确保从人类残骸"..YELLOW.."[11]"..WHITE.."附近拿到这个板甲手套，交给玛雷弗斯·暗锤（冬泉谷 - 永望镇; "..YELLOW.."61,39"..WHITE.."）。 ",
				followup = "炽热板甲护手", -- 5124
				attain = 60,
				aim = "世界上一定有人知道关于这副手套的事情，祝你好运！",
				title = "火热的死亡", -- 5103
				location = "人类的残骸（黑石塔下层; "..YELLOW.."[9]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：炽热板甲护手 ",
						id = 12699,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 3,
					},
					[2] = {
						name = "炽热板甲护手", -- 5124
						id = 12631,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "这个任务需要收集4个物品。\n1) 熔岩凝结器 (在黑石深渊的熔岩凝结器箱子中) \n2) 精细奥金桶 (在黑石塔的精细奥金桶容器中) 这是一个放在房间中间的大箱子上的小箱子。\n3) 熔火碎片 (来自熔火之心的熔岩破坏者)。\n4) 黑铁步枪 (由工程师制造)。\n需要在熔火之心中找到炽热核心（x3），还要附魔瑟银锭(x10)。。",
				followup = "无后续",
				attain = 55,
				aim = "我需要一个能够承受极高温度的精细奥金桶。它可以在黑石塔下层的深处找到，靠近军需官 "..YELLOW.."[16]"..WHITE.."。",
				title = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
				location = "任务线起始于泰尔阿比姆岛东边的比克斯·螺旋熔丝处。",
				level = 60,
				rewards = {
					[1] = {
						name = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
						id = 61068,
						subtext = "枪械",
						icon = "Spell_frost_fireresistancetotem",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
			},
		},
		[2] = {
			[1] = {
				note = "你可以在"..YELLOW.."[7]"..WHITE.."和"..YELLOW.."[9]"..WHITE.."附近找到石板。\n任务奖励来自《面对叶基亚》。 你可以在勘查员詹斯·铁靴旁边找到叶基亚。",
				followup = "面对叶基亚", -- 8181
				attain = 40,
				aim = "将第五块和第六块摩沙鲁石板交给塔纳利斯的勘查员詹斯·铁靴。",
				title = "最后的石板", -- 4788
				location = "勘查员詹斯·铁靴（塔纳利斯 - 热砂港; "..YELLOW.."66,23"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "Faded Hakkari Cloak",
						id = 20218,
						subtext = "背部",
						icon = "INV_Misc_Cape_13",
						quality = 3,
					},
					[2] = {
						name = "Tattered Hakkari Cape",
						id = 20219,
						subtext = "背部",
						icon = "INV_Misc_Cape_14",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "失落的摩沙鲁石板", -- 5065
			},
			[2] = {
				note = "你可以在"..YELLOW.."[17]"..WHITE.."找到座狼幼崽。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去找到血斧座狼幼崽。使用笼子来捕捉这些凶猛的小野兽，然后把笼中的座狼幼崽交给基布雷尔。",
				title = "基布雷尔的特殊宠物", -- 4729
				location = "基布雷尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,22"..WHITE.."）",
				level = 59,
				rewards = {
					[1] = {
						name = "到黑石塔去找到血斧座狼幼崽。使用笼子来捕捉这些凶猛的小野兽，然后把笼中的座狼幼崽交给基布雷尔。",
						id = 12264,
						subtext = "物品",
						icon = "INV_Box_PetCarrier_01",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在"..YELLOW.."[13]"..WHITE.."附近找到蜘蛛卵。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去为基布雷尔收集15枚尖塔蜘蛛卵。",
				title = "蜘蛛卵", -- 4862
				location = "基布雷尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,22"..WHITE.."）",
				level = 59,
				rewards = {
					[1] = {
						name = "烟网蜘蛛笼",
						id = 12529,
						subtext = "物品",
						icon = "INV_Box_Birdcage_01",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "烟网蛛后在"..YELLOW.."[13]"..WHITE..".如果中毒后解除，那么任务就会失败。",
				followup = "无后续",
				attain = 55,
				aim = "你可以在黑石塔的中心地带找到烟网蛛后。与她战斗，让她在你体内注入毒汁。如果你有能力的话，就杀死她吧。当你中毒之后，回到狼狈不堪的约翰那儿，他会从你的身体里抽取这些‘蛛后的乳汁’。 ",
				title = "蛛后的乳汁", -- 4866
				location = "狼狈不堪的约翰（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "约翰的无尽之杯",
						id = 15873,
						subtext = "饰品",
						icon = "INV_Drink_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "哈雷肯在"..YELLOW.."[17]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "杀死血斧座狼的领袖，哈雷肯。",
				title = "座狼的首领", -- 4724
				location = "神射手贾拉玛弗（荒芜之地 - 卡加斯; "..YELLOW.."5,47"..WHITE.."）",
				level = 59,
				rewards = {
					[1] = {
						name = "阿斯托里长袍",
						id = 15824,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_07",
						quality = 2,
					},
					[2] = {
						name = "吊钩外套",
						id = 15825,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Plate06",
						quality = 2,
					},
					[3] = {
						name = "碧鳞胸甲",
						id = 15827,
						subtext = "胸部 锁甲",
						icon = "inv_misc_desecrated_mailchest",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "要得到瓦罗什的蟑螂，你必须首先杀死乌洛克"..YELLOW.."[15]"..WHITE.."。要完成召唤，你需要长矛和 欧莫克大王的头颅"..YELLOW.."[5]"..WHITE.."。长矛在"..YELLOW.."[3]"..WHITE.."。在召唤出乌洛克之前，会出现几群食人魔，你可以用长矛来伤害它们。",
				followup = "无后续",
				attain = 55,
				aim = "阅读瓦罗什的卷轴。将瓦罗什的蟑螂交给他。",
				title = "乌洛克", -- 4867
				location = "瓦罗什（黑石塔下层; "..YELLOW.."[2]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "棱石护符",
						id = 15867,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Variety_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "比修在"..YELLOW.."[8]"..WHITE.."。",
				followup = "比修的装置", -- 5001
				attain = 55,
				aim = "到黑石塔去查明比修的下落。",
				title = "狡猾的比修", -- 4981
				location = "矮人可以在"..YELLOW.."[11]"..WHITE.."贝尔加附近被找到。卡加斯的高图斯在瞭望塔顶（荒芜之地; "..YELLOW.."5,47"..WHITE.."）。\n任务开始于雷克斯洛特（荒芜之地 - 卡加斯; "..YELLOW.."5,47"..WHITE.."）。 格拉克·洛克鲁布位置在燃烧平原（"..YELLOW.."38,35"..WHITE.."）。 要绑定他并开始护送任务（精英），他的生命需要减少到低于50%。",
				level = 59,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "你可以在在通往烟网蛛后的路上找到比修的装置"..YELLOW.."[13]"..WHITE.."。",
				followup = "比修的侦查报告", -- 4983
				attain = 55,
				aim = "找到比修的装置并把它们还给她。你记得她说过她把装置藏在城市的最底层。",
				title = "比修的装置", -- 5001
				location = "到黑石塔去查明比修的下落。",
				level = 59,
				rewards = {
					[1] = {
						name = "乱风手套",
						id = 15858,
						subtext = "手部 布甲",
						icon = "INV_Gauntlets_16",
						quality = 2,
					},
					[2] = {
						name = "海港束带",
						id = 15859,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_23",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "狡猾的比修", -- 4981
			},
			[9] = {
				note = "燃棘宝钻从欧莫克大王"..YELLOW.."[5]"..WHITE.."，尖石宝钻从指挥官沃恩"..YELLOW.."[9]"..WHITE.."，血斧宝钻从维姆萨拉克"..YELLOW.."[19]"..WHITE.."。原始晋升印章是黑石塔所有小怪掉落，完成这个之后你就能得到黑石塔上层的钥匙。",
				followup = "晋升印章", -- 4742
				attain = 57,
				aim = "找到三块命令宝石：燃棘宝钻、尖石宝钻和血斧宝钻。把它们和原始晋升印章一起交给维埃兰.",
				title = "晋升印章", -- 4742
				location = "维埃兰（黑石塔下层; "..YELLOW.."[1]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "奥妮克希亚钥匙前导任务。欧莫克大王在"..YELLOW.."[5]"..WHITE.."，指挥官沃恩在 "..YELLOW.."[9]"..WHITE.."，维姆萨拉克在 "..YELLOW.."[19]"..WHITE.."。黑石文件在3个Boss的其中一个边上。",
				followup = "伊崔格的智慧  -> 为部落而战（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 4941 -> 4974
				attain = 55,
				aim = "杀死欧莫克大王、指挥官沃恩和维姆萨拉克。找到重要的黑石文件，然后向卡加斯的军官高图斯汇报。",
				title = "高图斯的命令", -- 4903
				location = "矮人可在黑石深渊第一部分找到。\n卡加斯的高图斯在瞭望塔顶（荒芜之地; "..YELLOW.."5,47"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "维姆萨拉克的镣铐",
						id = 13958,
						subtext = "手腕 布甲",
						icon = "INV_Bracer_04",
						quality = 3,
					},
					[2] = {
						name = "欧莫克的瘦身腰带",
						id = 13959,
						subtext = "腰部 板甲",
						icon = "INV_Belt_13",
						quality = 3,
					},
					[3] = {
						name = "哈雷肯的笼口",
						id = 13961,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_24",
						quality = 3,
					},
					[4] = {
						name = "沃什加斯的绳索",
						id = 13962,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_15",
						quality = 3,
					},
					[5] = {
						name = "沃恩的邪恶之握",
						id = 13963,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_15",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4"..AQDiscription_OR.."5",
				},
				prequest = "无前置",
			},
			[11] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷，你可以从《寻找安泰恩》任务得到它。\n\n莫尔·灰蹄在"..YELLOW.."[9]"..WHITE.."召唤。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出莫尔·灰蹄的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[12] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷，你可以从《寻找安泰恩》任务得到它。\n\n莫尔·灰蹄在"..YELLOW.."[9]"..WHITE.."召唤。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "在比斯巨兽的房间里使用召唤火盆，召唤瓦塔拉克公爵。杀死他，对尸体使用瓦塔拉克的饰品。然后将瓦塔拉克的饰品还给瓦塔拉克公爵之魂。",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[13] = {
				note = "暗影猎手沃什加斯在"..YELLOW.."[7]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "到黑石塔去杀死暗影猎手沃什加斯，将沃什加斯的蛇石交给基尔拉姆。",
				title = "沃什加斯的蛇石（锻造-铸剑大师任务）", -- 5306
				location = "基尔拉姆（冬泉谷 - 永望镇; "..YELLOW.."61,37"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：黎明之刃",
						id = 12821,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[14] = {
				note = "煅造任务。确保从人类残骸"..YELLOW.."[11]"..WHITE.."附近拿到这个板甲手套，交给玛雷弗斯·暗锤（冬泉谷 - 永望镇; "..YELLOW.."61,39"..WHITE.."）。 ",
				followup = "炽热板甲护手", -- 5124
				attain = 60,
				aim = "世界上一定有人知道关于这副手套的事情，祝你好运！",
				title = "火热的死亡", -- 5103
				location = "人类的残骸（黑石塔下层; "..YELLOW.."[9]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：炽热板甲护手 ",
						id = 12699,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 3,
					},
					[2] = {
						name = "炽热板甲护手", -- 5124
						id = 12631,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "这个任务需要收集4个物品。\n1) 熔岩凝结器 (在黑石深渊的熔岩凝结器箱子中) \n2) 精细奥金桶 (在黑石塔的精细奥金桶容器中) 这是一个放在房间中间的大箱子上的小箱子。\n3) 熔火碎片 (来自熔火之心的熔岩破坏者)。\n4) 黑铁步枪 (由工程师制造)。\n需要在熔火之心中找到炽热核心（x3），还要附魔瑟银锭(x10)。。",
				followup = "无后续",
				attain = 55,
				aim = "我需要一个能够承受极高温度的精细奥金桶。它可以在黑石塔下层的深处找到，靠近军需官 "..YELLOW.."[16]"..WHITE.."。",
				title = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
				location = "任务线起始于泰尔阿比姆岛东边的比克斯·螺旋熔丝处。",
				level = 60,
				rewards = {
					[1] = {
						name = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
						id = 61068,
						subtext = "枪械",
						icon = "Spell_frost_fireresistancetotem",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "帮助贾比的行动2 -> 返回螺旋熔丝行动 -> 最后的修理行动 -> 黑铁亵渎者的秘密 -> 黑铁亵渎者", --40758
			},
			[16] = {
				note = "",
				followup = "无后续",
				attain = 48,
				aim = "击败黑石塔下层的战争大师沃恩 "..YELLOW.."[9]"..WHITE.."，并将他的獠牙带回燃烧平原的卡方要塞交给工头奥格戈。",
				title = "(TW)16. 森林巨魔的败类", -- 40495
				location = "工头奥格戈（燃烧平原 - 卡方要塞；"..YELLOW.."不清楚具体位置，乌龟数据库显示在燃烧平原的东北角，95.1,22.8"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "工头鞭笞", --60715
						id = 60715,
						subtext = "饰品",
						icon = "INV_Misc_Bandage_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "火鬃的任务", --40494
			},
			[17] = {
				note = "奴役者基兹卢尔在你击败首领哈雷肯 "..YELLOW.."[17]"..WHITE.."后出现。",
				followup = "无后续",
				attain = 50,
				aim = "击败黑石塔中的奴役者基兹卢尔 "..YELLOW.."[17]"..WHITE.."，然后向卡方要塞的劫掠者法戈什报告。",
				title = "(TW)17. 掠夺者的突袭", -- 40498
				location = "劫掠者法戈什（燃烧平原 - 卡方要塞；"..YELLOW.."不清楚具体位置，乌龟数据库显示在燃烧平原的东北角，95.1,22.8"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "座狼骑士腰带", --60717
						id = 60717,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_12",
						quality = 2,
					},
					[2] = {
						name = "煤渣行者凉鞋", --60718
						id = 60718,
						subtext = "脚部 布甲",
						icon = "INV_Boots_Fabric_01",
						quality = 2,
					},
					[3] = {
						name = "法戈什之斧", --60719
						id = 60719,
						subtext = "主手 斧",
						icon = "INV_Axe_24",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "劫掠者的复仇 -> 劫掠者的新坐骑", --40496, 40497
			},
			[18] = {
				note = "",
				followup = "无后续",
				attain = 50,
				aim = "在黑石塔深处击败军需官兹格里斯 "..YELLOW.."[16]"..WHITE.."，然后回到燃烧平原的卡方要塞向卡方报告。",
				title = "(TW)18. 最后的裂缝", -- 40509
				location = "工头奥格戈（燃烧平原 - 卡方要塞；"..YELLOW.."不清楚具体位置，乌龟数据库显示在燃烧平原的东北角，95.1,22.8"..WHITE.."）",
				level = 59,
				rewards = {
					[1] = {
						name = "玷污的兰斯洛特戒指", --60739
						id = 60739,
						subtext = "戒指",
						icon = "BTNLancelot_Ring",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "保护新鲜血液 -> 向莫克报告 -> 消灭所有痕迹... -> 不留任何机会", --40505, 40506, 40507, 40508
			},
		},
	},
	[9] = {
		name = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
		story = "黑石深渊深处的巨大堡垒是由矮人建筑大师弗兰克罗恩·铸铁所设计的。这个堡垒是矮人力量的象征并被邪恶的黑铁矮人占据了数个世纪。然而，奈法利安——死亡之翼狡猾的儿子——对这个巨大的堡垒别有意图。他和他的黑龙军团占据了上层黑石塔并向占据着黑石深渊的黑铁矮人宣战。奈法利安知道矮人是由强大的火元素拉格纳罗斯所领导的，所以他立志要摧毁他的敌人并将黑石深渊全都占为己有。",
		[1] = {
			[1] = {
				note = "你可以在竞技场边上的房间找到奥比"..YELLOW.."[7]"..WHITE.."。它呆在一个突出物上面。\n哈尔琳在冬泉谷（"..YELLOW.."54,51"..WHITE.."）。在冬泉谷的洞里的最里面通过站在传送符文上从而到她身边。",
				followup = "蓝龙之怒", -- 5161
				attain = 57,
				aim = "到冬泉谷去找到哈尔琳，把奥比的鳞片交给她。",
				title = "监护者", -- 5160
				location = "奥比（黑石塔上层; "..YELLOW.."[7]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "芬克·恩霍尔会在拨完比斯巨兽的皮后出现。玛雷弗斯·暗锤在（冬泉谷 - 永望镇; "..YELLOW.."61,38"..WHITE.."）。",
				followup = "阿卡纳护腿，血色学者之帽，嗜血胸甲", -- 5063, 5067, 5068, 40299
				attain = 55,
				aim = "与永望镇的玛雷弗斯·暗锤谈一谈。",
				title = "芬克·恩霍尔，为您效劳！", -- 5047
				location = "芬克·恩霍尔（黑石塔上层; "..YELLOW.."[8]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在烈焰之父的房间找到龙蛋"..YELLOW.."[2]"..WHITE.."。",
				followup = "莱尼德·巴萨罗梅 -> 贝蒂娜·比格辛克（"..YELLOW.."通灵学院"..WHITE.."）", -- 4735 and 5522 -> 4771
				attain = 57,
				aim = "在孵化间对着某颗龙蛋使用龙蛋冷冻器初号机。",
				title = "冷冻龙蛋", -- 4734
				location = "雏龙精华开始于丁奇·斯迪波尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）。 观察室在"..YELLOW.."[6]"..WHITE.."。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "雏龙精华开始于丁奇·斯迪波尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）。 观察室在"..YELLOW.."[6]"..WHITE.."。",
			},
			[4] = {
				note = "你可以找到艾博希尔在"..YELLOW.."[1]"..WHITE.."。",
				followup = "熔火之心", -- 6822
				attain = 56,
				aim = "将艾博希尔之眼交给艾萨拉的海达克西斯公爵。",
				title = "艾博希尔之眼（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 6821
				location = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "雷暴和磐石", -- 6804, 6805
			},
			[5] = {
				note = "达基萨斯将军在"..YELLOW.."[9]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去杀掉达基萨斯将军，完成任务之后就回到麦克斯韦尔元帅那里复命。",
				title = "达基萨斯将军之死（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 5102
				location = "温德索尔元帅在"..YELLOW.."[4]"..WHITE.."。\n如果你清掉法律之环一圈的怪（"..YELLOW.."[6]"..WHITE.."）和通向副本门口的怪的话会轻松很多。护送完成后去找麦克斯韦尔元帅（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,68"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "暴君印记",
						id = 13966,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_09",
						quality = 3,
					},
					[2] = {
						name = "比斯巨兽之眼",
						id = 13968,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_08",
						quality = 3,
					},
					[3] = {
						name = "黑手饰物",
						id = 13965,
						subtext = "饰品",
						icon = "INV_Misc_ArmorKit_09",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "达基萨斯将军的命令（"..YELLOW.."黑石塔下层"..WHITE.."）", -- 5089
			},
			[6] = {
				note = "你可以接到这个任务的前续任务，从雷明顿·瑞治维尔伯爵（暴风城 - 暴风要塞; "..YELLOW.."74,30"..WHITE.."）。 末日扣环在烈焰之父的房间"..YELLOW.."[3]"..WHITE.."的一个箱子里。",
				followup = "瑞治维尔的箱子", -- 4765
				attain = 57,
				aim = "将末日扣环交给燃烧平原的玛亚拉·布莱特文。",
				title = "末日扣环", -- 4764
				location = "玛亚拉·布莱特文（燃烧平原 - 摩根的岗哨; "..YELLOW.."84,69"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "迅捷皮靴",
						id = 15861,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_07",
						quality = 2,
					},
					[2] = {
						name = "瞬击护臂",
						id = 15860,
						subtext = "手腕 板甲",
						icon = "INV_Bracer_17",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "将末日扣环交给燃烧平原的玛亚拉·布莱特文。",
			},
			[7] = {
				note = "联盟奥妮克希亚钥匙系列任务的最后一步。达基萨斯将军在"..YELLOW.."[9]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "你必须从达基萨斯将军身上取回黑龙勇士之血，你可以在黑石塔的晋升大厅后面的房间里找到他。",
				title = "龙火护符", -- 6502
				location = "到冬泉谷去找到哈尔琳，把奥比的鳞片交给她。",
				level = 60,
				rewards = {
					[1] = {
						name = "龙火护符", -- 6502
						id = 16309,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_11",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "巨龙之眼", -- 6501
			},
			[8] = {
				note = "黑翼之巢的进门任务。你可以在黑石塔副本的门口右侧附近找到裂盾军需官，宝珠就在达基萨斯将军"..YELLOW.."[9]"..WHITE.."身后。 ",
				followup = "无后续",
				attain = 55,
				aim = "真是个愚蠢的兽人。看来你需要找到那枚烙印并获得达基萨斯徽记才可以使用命令宝珠。",
				title = "黑手的命令", -- 7761
				location = "黑手的命令（裂盾军需官掉落; "..YELLOW.."副本入口地图[7]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。黑石塔的兽人掉落黑石护腕。超级能量合剂是炼金制造。",
				followup = "瓦塔拉克公爵", -- 8995
				attain = 58,
				aim = "从黑石塔的兽人那儿收集40副黑石护腕，把它们和一瓶超级能量合剂一起交给黑石山的伯德雷。",
				title = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "瓦塔拉克护符的右瓣（"..YELLOW.."黑石塔下层"..WHITE.."）", -- 8989
			},
			[10] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤瓦塔拉克公爵在 "..YELLOW.."[8]"..WHITE.."。向伯德雷回复领取奖励。",
				followup = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				attain = 58,
				aim = "在比斯巨兽的房间里使用召唤火盆，召唤瓦塔拉克公爵。杀死他，对尸体使用瓦塔拉克的饰品。然后将瓦塔拉克的饰品还给瓦塔拉克公爵之魂。",
				title = "瓦塔拉克公爵", -- 8995
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "符咒火盆",
						id = 22057,
						subtext = "物品",
						icon = "INV_Misc_EngGizmos_23",
						quality = 1,
					},
					[2] = {
						name = "符咒火盆用户手册",
						id = 22344,
						subtext = "物品",
						icon = "INV_Misc_Book_09",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
			},
			[11] = {
				note = "煅造任务。古拉鲁克在"..YELLOW.."[5]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去找到古拉鲁克。杀死他，然后用血污长矛刺入他的尸体。当他的灵魂被吸干后，这支矛就会成为穿魂长矛。你还必须找到未铸造的符文覆饰胸甲。将穿魂长矛和未铸造的符文覆饰胸甲都交给冬泉谷的罗拉克斯。",
				title = "恶魔熔炉（煅造-铸甲大师任务）", -- 5127
				location = "到黑石塔去找到古拉鲁克。杀死他，然后用血污长矛刺入他的尸体。当他的灵魂被吸干后，这支矛就会成为穿魂长矛。你还必须找到未铸造的符文覆饰胸甲。将穿魂长矛和未铸造的符文覆饰胸甲都交给冬泉谷的罗拉克斯。",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图-魔铸胸甲",
						id = 12696,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 3,
					},
					[2] = {
						name = "屠魔药剂",
						id = 9224,
						subtext = "药水",
						icon = "INV_Potion_27",
						quality = 1,
					},
					[3] = {
						name = "魔吻背包",
						id = 12849,
						subtext = "物品",
						icon = "INV_Misc_Bag_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2 (x5)"..AQDiscription_OR.."3",
				},
				prequest = "罗拉克斯的故事", --5126
			},
			[12] = {
				note = "强烈建议先接受正义的汉瓦之前的任务“桑萨尔护腕”（位于卡拉赞外的死亡狼峡谷的小教堂内 "..YELLOW.."[40.9,79.3]"..WHITE..")，完成“护腕的上半部分”任务链的最后一个任务后，你将获得任务物品“桑萨尔上部护腕”，用于任务“桑萨尔护腕”。",
				followup = "护腕的上半部分II -> 护腕的上半部分III "..YELLOW.."[厄运之槌西]"..WHITE.." -> 护腕的上半部分IV", --41012, 41013, 41014
				attain = 55,
				aim = "在黑石塔内，从黑龙族（索拉卡·火冠）"..YELLOW.."[2]"..WHITE.."那里收集一枚龙族能量，交给吉尔尼斯的帕纳布斯。",
				title = "(TW)19. 护腕的上半部分III", -- 41013
				location = "帕纳布斯 <流浪巫师>（吉尔尼斯； "..YELLOW.."[22.9,74.4]"..WHITE.."，吉尔尼斯城南部，河流的西边，一个孤独的房子里）。",
				level = 60,
				rewards = {
					[1] = {
						name = "桑萨尔护腕 -> 护腕的上半部分 "..YELLOW.."[黑石塔上层]"..WHITE.." -> 护腕的上半部分II", --41015, 41011, 41012
						id = 61696,
						subtext = "物品",
						icon = "INV_Misc_ArmorKit_10",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "强烈建议先接受正义的汉瓦的前置任务“桑萨尔护腕”（位于卡拉赞外的逆风小径小教堂内，位置标记为 "..YELLOW.."[40.9,79.3]"..WHITE.."）。\n完成“上层束缚”任务链的最后一个任务将获得任务物品“桑萨尔上部护腕”，用于“桑萨尔护腕”任务。\n奥术元素位于环绕着位置标记为 "..YELLOW.."[6]"..WHITE.."的圆圈内，它们会掉落奥术超载谐振器。",
			},
		},
		[2] = {
			[1] = {
				note = "你可以在竞技场边上的房间找到奥比"..YELLOW.."[7]"..WHITE.."。它呆在一个突出物上面。\n哈尔琳在冬泉谷（"..YELLOW.."54,51"..WHITE.."）。在冬泉谷的洞里的最里面通过站在传送符文上从而到她身边。",
				followup = "蓝龙之怒", -- 5161
				attain = 57,
				aim = "到冬泉谷去找到哈尔琳，把奥比的鳞片交给她。",
				title = "监护者", -- 5160
				location = "奥比（黑石塔上层; "..YELLOW.."[7]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "芬克·恩霍尔会在拨完比斯巨兽的皮后出现。玛雷弗斯·暗锤在（冬泉谷 - 永望镇; "..YELLOW.."61,38"..WHITE.."）。",
				followup = "阿卡纳护腿，血色学者之帽，嗜血胸甲", -- 5063, 5067, 5068, 40299
				attain = 55,
				aim = "与永望镇的玛雷弗斯·暗锤谈一谈。",
				title = "芬克·恩霍尔，为您效劳！", -- 5047
				location = "芬克·恩霍尔（黑石塔上层; "..YELLOW.."[8]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在烈焰之父的房间找到龙蛋"..YELLOW.."[2]"..WHITE.."。",
				followup = "莱尼德·巴萨罗梅 -> 贝蒂娜·比格辛克（"..YELLOW.."通灵学院"..WHITE.."）", -- 4735 and 5522 -> 4771
				attain = 57,
				aim = "在孵化间对着某颗龙蛋使用龙蛋冷冻器初号机。",
				title = "冷冻龙蛋", -- 4734
				location = "雏龙精华开始于丁奇·斯迪波尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）。 观察室在"..YELLOW.."[6]"..WHITE.."。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "雏龙精华开始于丁奇·斯迪波尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）。 观察室在"..YELLOW.."[6]"..WHITE.."。",
			},
			[4] = {
				note = "你可以找到艾博希尔在"..YELLOW.."[1]"..WHITE.."。",
				followup = "熔火之心", -- 6822
				attain = 56,
				aim = "将艾博希尔之眼交给艾萨拉的海达克西斯公爵。",
				title = "艾博希尔之眼（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 6821
				location = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "雷暴和磐石", -- 6804, 6805
			},
			[5] = {
				note = "你可以接到前续任务从药剂师金格（幽暗城 - 炼金房; "..YELLOW.."50,68"..WHITE.."）。黑暗石板在烈焰之父的房间（"..YELLOW.."[3]"..WHITE.."）。",
				followup = "无后续",
				attain = 57,
				aim = "将黑暗石板交给卡加斯的暗法师薇薇安·拉格雷。",
				title = "黑暗石板", -- 4768
				location = "暗法师薇薇安·拉格雷（荒芜之地 - 卡加斯; "..YELLOW.."2,47"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "迅捷皮靴",
						id = 15861,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_07",
						quality = 2,
					},
					[2] = {
						name = "瞬击护臂",
						id = 15860,
						subtext = "手腕 板甲",
						icon = "INV_Bracer_17",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "薇薇安·拉格雷和黑暗石板", -- 4769
			},
			[6] = {
				note = "奥妮克希亚钥匙任务。大酋长雷德·黑手在 "..YELLOW.."[6]"..WHITE.."。",
				followup = "部落的勇士", -- 6566
				attain = 55,
				aim = "去黑石塔杀死大酋长雷德·黑手，带着他的头颅返回奥格瑞玛。",
				title = "部落的胜利", -- 7490
				location = "将奥妮克希亚的头颅交给奥格瑞玛的萨尔。 ",
				level = 60,
				rewards = {
					[1] = {
						name = "暴君印记",
						id = 13966,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_09",
						quality = 3,
					},
					[2] = {
						name = "比斯巨兽之眼",
						id = 13968,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_08",
						quality = 3,
					},
					[3] = {
						name = "黑手饰物",
						id = 13965,
						subtext = "饰品",
						icon = "INV_Misc_ArmorKit_09",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "高图斯的命令 -> 伊崔格的智慧", -- 4903 -> 4941
			},
			[7] = {
				note = "黑色的龙会掉落眼球。",
				followup = "埃博斯塔夫", -- 6570
				attain = 55,
				aim = "到黑石塔去收集20颗黑色龙人的眼球，完成任务之后回到巫女麦兰达那里。",
				title = "黑龙幻像", -- 6569
				location = "巫女麦兰达（西瘟疫之地; "..YELLOW.."50,77"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "部落的勇士 -> 雷克萨的证明", -- 6566 -> 6568
			},
			[8] = {
				note = "部落奥妮克希亚钥匙系列任务的最后一步。达基萨斯将军在"..YELLOW.."[9]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去杀掉达基萨斯将军，把它的血交给罗卡鲁。",
				title = "你必须从达基萨斯将军身上取回黑龙勇士之血，你可以在黑石塔的晋升大厅后面的房间里找到他。",
				location = "罗卡鲁（凄凉之地 - 葬影村; "..YELLOW.."25,71"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "龙火护符", -- 6502
						id = 16309,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_11",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "埃博斯塔夫 -> 龙骨试炼……", -- 6570 -> 6601
			},
			[9] = {
				note = "黑翼之巢的进门任务。你可以在黑石塔副本的门口右侧附近找到裂盾军需官，宝珠就在达基萨斯将军"..YELLOW.."[9]"..WHITE.."身后。 ",
				followup = "无后续",
				attain = 55,
				aim = "真是个愚蠢的兽人。看来你需要找到那枚烙印并获得达基萨斯徽记才可以使用命令宝珠。",
				title = "黑手的命令", -- 7761
				location = "黑手的命令（裂盾军需官掉落; "..YELLOW.."副本入口地图[7]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。黑石塔的兽人掉落黑石护腕。超级能量合剂是炼金制造。",
				followup = "瓦塔拉克公爵", -- 8995
				attain = 58,
				aim = "从黑石塔的兽人那儿收集40副黑石护腕，把它们和一瓶超级能量合剂一起交给黑石山的伯德雷。",
				title = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "瓦塔拉克护符的右瓣（"..YELLOW.."黑石塔下层"..WHITE.."）", -- 8989
			},
			[11] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤瓦塔拉克公爵在 "..YELLOW.."[8]"..WHITE.."。向伯德雷回复领取奖励。",
				followup = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				attain = 58,
				aim = "在比斯巨兽的房间里使用召唤火盆，召唤瓦塔拉克公爵。杀死他，对尸体使用瓦塔拉克的饰品。然后将瓦塔拉克的饰品还给瓦塔拉克公爵之魂。",
				title = "瓦塔拉克公爵", -- 8995
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "符咒火盆",
						id = 22057,
						subtext = "物品",
						icon = "INV_Misc_EngGizmos_23",
						quality = 1,
					},
					[2] = {
						name = "符咒火盆用户手册",
						id = 22344,
						subtext = "物品",
						icon = "INV_Misc_Book_09",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
			},
			[12] = {
				note = "煅造任务。古拉鲁克在"..YELLOW.."[5]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到黑石塔去找到古拉鲁克。杀死他，然后用血污长矛刺入他的尸体。当他的灵魂被吸干后，这支矛就会成为穿魂长矛。你还必须找到未铸造的符文覆饰胸甲。将穿魂长矛和未铸造的符文覆饰胸甲都交给冬泉谷的罗拉克斯。",
				title = "恶魔熔炉（煅造-铸甲大师任务）", -- 5127
				location = "到黑石塔去找到古拉鲁克。杀死他，然后用血污长矛刺入他的尸体。当他的灵魂被吸干后，这支矛就会成为穿魂长矛。你还必须找到未铸造的符文覆饰胸甲。将穿魂长矛和未铸造的符文覆饰胸甲都交给冬泉谷的罗拉克斯。",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图-魔铸胸甲",
						id = 12696,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 3,
					},
					[2] = {
						name = "屠魔药剂",
						id = 9224,
						subtext = "药水",
						icon = "INV_Potion_27",
						quality = 1,
					},
					[3] = {
						name = "魔吻背包",
						id = 12849,
						subtext = "物品",
						icon = "INV_Misc_Bag_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2 (x5)"..AQDiscription_OR.."3",
				},
				prequest = "罗拉克斯的故事", --5126
			},
			[13] = {
				note = "强烈建议先接受正义的汉瓦之前的任务“桑萨尔护腕”（位于卡拉赞外的死亡狼峡谷的小教堂内 "..YELLOW.."[40.9,79.3]"..WHITE..")，完成“护腕的上半部分”任务链的最后一个任务后，你将获得任务物品“桑萨尔上部护腕”，用于任务“桑萨尔护腕”。",
				followup = "护腕的上半部分II -> 护腕的上半部分III "..YELLOW.."[厄运之槌西]"..WHITE.." -> 护腕的上半部分IV", --41012, 41013, 41014
				attain = 55,
				aim = "在黑石塔内，从黑龙族（索拉卡·火冠）"..YELLOW.."[2]"..WHITE.."那里收集一枚龙族能量，交给吉尔尼斯的帕纳布斯。",
				title = "(TW)19. 护腕的上半部分III", -- 41013
				location = "帕纳布斯 <流浪巫师>（吉尔尼斯； "..YELLOW.."[22.9,74.4]"..WHITE.."，吉尔尼斯城南部，河流的西边，一个孤独的房子里）。",
				level = 60,
				rewards = {
					[1] = {
						name = "桑萨尔护腕 -> 护腕的上半部分 "..YELLOW.."[黑石塔上层]"..WHITE.." -> 护腕的上半部分II", --41015, 41011, 41012
						id = 61696,
						subtext = "物品",
						icon = "INV_Misc_ArmorKit_10",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "强烈建议先接受正义的汉瓦的前置任务“桑萨尔护腕”（位于卡拉赞外的逆风小径小教堂内，位置标记为 "..YELLOW.."[40.9,79.3]"..WHITE.."）。\n完成“上层束缚”任务链的最后一个任务将获得任务物品“桑萨尔上部护腕”，用于“桑萨尔护腕”任务。\n奥术元素位于环绕着位置标记为 "..YELLOW.."[6]"..WHITE.."的圆圈内，它们会掉落奥术超载谐振器。",
			},
		},
	},
	[10] = {
		name = "厄运之槌（东）",
		story = "埃雷萨拉斯古城是在一万二千年前由当时的一批暗夜精灵法师秘密地建造的，它被用于保护艾莎拉皇后最宝贵的奥法秘密。虽然受到了世界大震动的影响，这座伟大的城市基本屹立在那里，现在其被称为厄运之槌。这座遗迹城市分为三个部分，分别被不同的生物所占据——包括幽灵般的高等精灵，邪恶的萨特和鲁莽的食人魔。只有最勇敢的冒险队伍才敢进入这个破碎的城市并面对远古大厅中邪恶力量。",
		[1] = {
			[1] = {
				note = "普希林在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[1]"..WHITE.."。你一和它说话它就跑，但是最后会停下并可以被攻击在"..YELLOW.."[2]"..WHITE.."。它还会掉落月牙钥匙，也就是厄运之槌北和西的钥匙。",
				followup = "无后续",
				attain = 54,
				aim = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				title = "普希林和埃斯托尔迪", -- 7441
				location = "埃斯托尔迪（菲拉斯 - 拉瑞斯小亭; "..YELLOW.."76,37"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "活跃之靴",
						id = 18411,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_06",
						quality = 2,
					},
					[2] = {
						name = "奔行者之剑",
						id = 18410,
						subtext = "双手 剑",
						icon = "INV_Sword_28",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "蕾瑟塔蒂丝在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[3]"..WHITE.."。前续任务可以从铁炉堡的信使考雷·落锤接到。",
				followup = "无后续",
				attain = 54,
				aim = "把蕾瑟塔蒂丝的网交给菲拉斯羽月要塞的拉托尼库斯·月矛。",
				title = "蕾瑟塔蒂丝的网", -- 7488
				location = "把蕾瑟塔蒂丝的网交给菲拉斯羽月要塞的拉托尼库斯·月矛。",
				level = 57,
				rewards = {
					[1] = {
						name = "学识匕首",
						id = 18491,
						subtext = "主手 匕首",
						icon = "INV_Weapon_ShortBlade_21",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "把蕾瑟塔蒂丝的网交给菲拉斯羽月要塞的拉托尼库斯·月矛。",
			},
			[3] = {
				note = "奥兹恩在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[5]"..WHITE.."。净化之匣在希利苏斯"..YELLOW.."62,54"..WHITE.."。前续任务同样来自拉比恩·萨图纳。",
				followup = "无后续",
				attain = 56,
				aim = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
				title = "魔藤碎片", -- 5526
				location = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
				level = 60,
				rewards = {
					[1] = {
						name = "米利的盾牌",
						id = 18535,
						subtext = "盾牌",
						icon = "INV_Shield_12",
						quality = 3,
					},
					[2] = {
						name = "Milli's Lexicon",
						id = 18536,
						subtext = "副手",
						icon = "INV_Misc_Book_06",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
			},
			[4] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[5] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "使用召唤火盆召唤出伊萨莉恩的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克公爵的饰品还给伯德雷。",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[6] = {
				note = "术士召唤末日守卫任务，你可以从衰老的戴奥那里接到相关的其他任务。最容易找到荒野萨特是从厄运之槌东的“后门”进入（菲拉斯 - 拉瑞斯小亭; "..YELLOW.."77,37"..WHITE.."）。 你需要有月牙钥匙才能开门。",
				followup = "无后续",
				attain = 60,
				aim = "到菲拉斯的厄运之槌去，从扭木广场的荒野萨特身上找到15份萨特之血，然后把它们交给腐烂之痕的戴奥。",
				title = "监牢之链（术士任务）", -- 7581
				location = "衰老的戴奥（诅咒之地 - 腐烂之痕; "..YELLOW.."34,50"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "奥兹恩在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[5]"..WHITE.."。净化之匣在希利苏斯"..YELLOW.."62,54"..WHITE.."。前续任务同样来自拉比恩·萨图纳。",
				followup = "无后续",
				attain = 55,
				aim = "将“狂野变形者”奥兹恩的头颅带给海加尔的大德鲁伊梦风。",
				title = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
				location = "大德鲁伊梦风 (海加尔山 - 诺达纳尔; "..YELLOW.."84.8,29.3"..WHITE.." 大树的顶层)",
				level = 60,
				rewards = {
					[1] = {
						name = "明亮梦境碎片", -- 61199
						id = 61199,
						subtext = "物品",
						icon = "INV_Misc_Gem_Stone_01",
						quality = 3,
					},
					[2] = {
						name = "梦境塑形者护符", -- 61703
						id = 61703,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_13",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "普希林在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[1]"..WHITE.."。你一和它说话它就跑，但是最后会停下并可以被攻击在"..YELLOW.."[2]"..WHITE.."。它还会掉落月牙钥匙，也就是厄运之槌北和西的钥匙。",
				followup = "无后续",
				attain = 54,
				aim = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				title = "普希林和埃斯托尔迪", -- 7441
				location = "埃斯托尔迪（菲拉斯 - 拉瑞斯小亭; "..YELLOW.."76,37"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "活跃之靴",
						id = 18411,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_06",
						quality = 2,
					},
					[2] = {
						name = "奔行者之剑",
						id = 18410,
						subtext = "双手 剑",
						icon = "INV_Sword_28",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "蕾瑟塔蒂丝在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[3]"..WHITE.."。前续任务接自奥格瑞玛的公告员高拉克。",
				followup = "无后续",
				attain = 54,
				aim = "把蕾瑟塔蒂丝的网交给非拉斯莫沙彻营地的塔罗·刺蹄。",
				title = "蕾瑟塔蒂丝的网", -- 7488
				location = "把蕾瑟塔蒂丝的网交给非拉斯莫沙彻营地的塔罗·刺蹄。",
				level = 57,
				rewards = {
					[1] = {
						name = "学识匕首",
						id = 18491,
						subtext = "主手 匕首",
						icon = "INV_Weapon_ShortBlade_21",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "把蕾瑟塔蒂丝的网交给非拉斯莫沙彻营地的塔罗·刺蹄。",
			},
			[3] = {
				note = "奥兹恩在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[5]"..WHITE.."。净化之匣在希利苏斯"..YELLOW.."62,54"..WHITE.."。前续任务同样来自拉比恩·萨图纳。",
				followup = "无后续",
				attain = 56,
				aim = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
				title = "魔藤碎片", -- 5526
				location = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
				level = 60,
				rewards = {
					[1] = {
						name = "米利的盾牌",
						id = 18535,
						subtext = "盾牌",
						icon = "INV_Shield_12",
						quality = 3,
					},
					[2] = {
						name = "Milli's Lexicon",
						id = 18536,
						subtext = "副手",
						icon = "INV_Misc_Book_06",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
			},
			[4] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出伊萨利恩的灵魂，然后杀掉她。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[5] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "使用召唤火盆召唤出伊萨莉恩的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克公爵的饰品还给伯德雷。",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[6] = {
				note = "术士召唤末日守卫任务，你可以从衰老的戴奥那里接到相关的其他任务。最容易找到荒野萨特是从厄运之槌东的“后门”进入（菲拉斯 - 拉瑞斯小亭; "..YELLOW.."77,37"..WHITE.."）。 你需要有月牙钥匙才能开门。",
				followup = "无后续",
				attain = 60,
				aim = "到菲拉斯的厄运之槌去，从扭木广场的荒野萨特身上找到15份萨特之血，然后把它们交给腐烂之痕的戴奥。",
				title = "监牢之链（术士任务）", -- 7581
				location = "衰老的戴奥（诅咒之地 - 腐烂之痕; "..YELLOW.."34,50"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "奥兹恩在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[5]"..WHITE.."。净化之匣在希利苏斯"..YELLOW.."62,54"..WHITE.."。前续任务同样来自拉比恩·萨图纳。",
				followup = "无后续",
				attain = 55,
				aim = "将“狂野变形者”奥兹恩的头颅带给海加尔的大德鲁伊梦风。",
				title = "在厄运之槌中找到魔藤，然后从它上面采集一块碎片。只有干掉了奥兹恩之后，你才能进行采集工作。使用净化之匣安全地封印碎片，然后将其交给月光林地永夜港的拉比恩·萨图纳。",
				location = "大德鲁伊梦风 (海加尔山 - 诺达纳尔; "..YELLOW.."84.8,29.3"..WHITE.." 大树的顶层)",
				level = 60,
				rewards = {
					[1] = {
						name = "明亮梦境碎片", -- 61199
						id = 61199,
						subtext = "物品",
						icon = "INV_Misc_Gem_Stone_01",
						quality = 3,
					},
					[2] = {
						name = "梦境塑形者护符", -- 61703
						id = 61703,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_13",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
		},
	},
	[11] = {
		name = "普希林在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[1]"..WHITE.."。你一和它说话它就跑，但是最后会停下并可以被攻击在"..YELLOW.."[2]"..WHITE.."。它还会掉落月牙钥匙，也就是厄运之槌北和西的钥匙。",
		story = "埃雷萨拉斯古城是在一万二千年前由当时的一批暗夜精灵法师秘密地建造的，它被用于保护艾莎拉皇后最宝贵的奥法秘密。虽然受到了世界大震动的影响，这座伟大的城市基本屹立在那里，现在其被称为厄运之槌。这座遗迹城市分为三个部分，分别被不同的生物所占据——包括幽灵般的高等精灵，邪恶的萨特和鲁莽的食人魔。只有最勇敢的冒险队伍才敢进入这个破碎的城市并面对远古大厅中邪恶力量。",
		[1] = {
			[1] = {
				note = "可重复任务。修好陷阱你必须有[瑟银零件]和一瓶[冰霜之油]。",
				followup = "无后续",
				attain = 56,
				aim = "修复这个陷阱。",
				title = "破碎的陷阱 ", -- 1193
				location = "破碎的陷阱（厄运之槌; "..YELLOW.."北"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "可重复任务，食人魔鞣酸可以从"..YELLOW.."（上层）[4]"..WHITE.."附近得到。",
				followup = "无后续",
				attain = 56,
				aim = "把4份符文布卷、8块硬甲皮、2卷符文线和一份食人魔鞣酸交给诺特·希姆加克。他现在被拴在厄运之槌的戈多克食人魔那边。",
				title = "戈多克食人魔装", -- 5518
				location = "诺特·希姆加克（厄运之槌; "..YELLOW.."北，[4]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "戈多克食人魔装", -- 5518
						id = 18258,
						subtext = "物品",
						icon = "INV_Chest_Chain_14",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "可重复任务，副本里任何食人魔都可能掉落镣铐钥匙。",
				followup = "无后续",
				attain = 57,
				aim = "为诺特找到食人魔镣铐钥匙。",
				title = "救诺特出去！", -- 5525
				location = "诺特·希姆加克（厄运之槌; "..YELLOW.."北，[4]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "王子在厄运之槌"..YELLOW.."西"..WHITE.."的"..YELLOW.."[7]"..WHITE.."。力量护手在王子附近的一个箱子里，交任务时你也必须确保你有“当国王真好”这个状态。",
				followup = "无后续",
				attain = 56,
				aim = "找到戈多克力量护手，并将它交给厄运之槌的克罗卡斯。",
				title = "戈多克食人魔的事务", -- 1318 or 7703
				location = "克罗卡斯（厄运之槌; "..YELLOW.."北，[5]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "戈多克裹手",
						id = 18369,
						subtext = "手部 布甲",
						icon = "INV_Gauntlets_06",
						quality = 3,
					},
					[2] = {
						name = "戈多克手套",
						id = 18368,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_01",
						quality = 3,
					},
					[3] = {
						name = "戈多克手甲",
						id = 18367,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_09",
						quality = 3,
					},
					[4] = {
						name = "戈多克护手",
						id = 18366,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_09",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "可重复任务。修好陷阱你必须有[瑟银零件]和一瓶[冰霜之油]。",
				followup = "无后续",
				attain = 56,
				aim = "修复这个陷阱。",
				title = "破碎的陷阱 ", -- 1193
				location = "破碎的陷阱（厄运之槌; "..YELLOW.."北"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "可重复任务，食人魔鞣酸可以从"..YELLOW.."（上层）[4]"..WHITE.."附近得到。",
				followup = "无后续",
				attain = 56,
				aim = "把4份符文布卷、8块硬甲皮、2卷符文线和一份食人魔鞣酸交给诺特·希姆加克。他现在被拴在厄运之槌的戈多克食人魔那边。",
				title = "戈多克食人魔装", -- 5518
				location = "诺特·希姆加克（厄运之槌; "..YELLOW.."北，[4]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "戈多克食人魔装", -- 5518
						id = 18258,
						subtext = "物品",
						icon = "INV_Chest_Chain_14",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "可重复任务，副本里任何食人魔都可能掉落镣铐钥匙。",
				followup = "无后续",
				attain = 57,
				aim = "为诺特找到食人魔镣铐钥匙。",
				title = "救诺特出去！", -- 5525
				location = "诺特·希姆加克（厄运之槌; "..YELLOW.."北，[4]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "王子在厄运之槌"..YELLOW.."西"..WHITE.."的"..YELLOW.."[7]"..WHITE.."。力量护手在王子附近的一个箱子里，交任务时你也必须确保你有“当国王真好”这个状态。",
				followup = "无后续",
				attain = 56,
				aim = "找到戈多克力量护手，并将它交给厄运之槌的克罗卡斯。",
				title = "戈多克食人魔的事务", -- 1318 or 7703
				location = "克罗卡斯（厄运之槌; "..YELLOW.."北，[5]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "戈多克裹手",
						id = 18369,
						subtext = "手部 布甲",
						icon = "INV_Gauntlets_06",
						quality = 3,
					},
					[2] = {
						name = "戈多克手套",
						id = 18368,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_01",
						quality = 3,
					},
					[3] = {
						name = "戈多克手甲",
						id = 18367,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_09",
						quality = 3,
					},
					[4] = {
						name = "戈多克护手",
						id = 18366,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_09",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
		},
	},
	[12] = {
		name = "普希林在厄运之槌"..YELLOW.."东"..WHITE.."的"..YELLOW.."[1]"..WHITE.."。你一和它说话它就跑，但是最后会停下并可以被攻击在"..YELLOW.."[2]"..WHITE.."。它还会掉落月牙钥匙，也就是厄运之槌北和西的钥匙。",
		story = "埃雷萨拉斯古城是在一万二千年前由当时的一批暗夜精灵法师秘密地建造的，它被用于保护艾莎拉皇后最宝贵的奥法秘密。虽然受到了世界大震动的影响，这座伟大的城市基本屹立在那里，现在其被称为厄运之槌。这座遗迹城市分为三个部分，分别被不同的生物所占据——包括幽灵般的高等精灵，邪恶的萨特和鲁莽的食人魔。只有最勇敢的冒险队伍才敢进入这个破碎的城市并面对远古大厅中邪恶力量。",
		[1] = {
			[1] = {
				note = "卡里尔·温萨鲁斯在（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "到厄运之槌去寻找卡里尔·温萨鲁斯。向羽月要塞的学者卢索恩·纹角报告你所找到的信息。",
				title = "精灵的传说", -- 7482
				location = "学者卢索恩·纹角（菲拉斯 - 羽月要塞; "..YELLOW.."31,43"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "水晶塔被标记为"..BLUE.."[B]"..WHITE.."。伊莫塔尔在"..YELLOW.."[6]"..WHITE.."，托塞德林王子在"..YELLOW.."[7]"..WHITE.."。",
				followup = "辛德拉的宝藏", -- 7877
				attain = 56,
				aim = "你必须干掉5座水晶塔周围的守卫，那5座水晶塔维持着关押伊莫塔尔的监狱。一旦水晶塔的能量被削弱，伊莫塔尔周围的能量力场就会消散。\n 进入伊莫塔尔的监狱，干掉站在中间的那个恶魔。最后，在图书馆挑战托塞德林王子。当任务完成之后，到庭院中去找辛德拉古灵。",
				title = "伊莫塔尔的疯狂", -- 7461
				location = "辛德拉古灵（厄运之槌; "..YELLOW.."西，（上层）[1]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在图书馆的梯子下面找到宝藏"..YELLOW.."[7]"..WHITE.."。",
				followup = "无后续",
				attain = 56,
				aim = "返回图书馆去找到辛德拉的宝藏。拿取你的奖励吧！",
				title = "辛德拉的宝藏", -- 7877
				location = "辛德拉古灵（厄运之槌; "..YELLOW.."西，（上层）[1]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "莎草长靴",
						id = 18424,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_05",
						quality = 3,
					},
					[2] = {
						name = "密林头盔",
						id = 18421,
						subtext = "头部 锁甲",
						icon = "INV_Helmet_19",
						quality = 3,
					},
					[3] = {
						name = "碾骨者",
						id = 18420,
						subtext = "双手 锤",
						icon = "INV_Mace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "伊莫塔尔的疯狂", -- 7461
			},
			[4] = {
				note = "术士的史诗战马任务的最后一步。首先必须关闭水晶塔"..BLUE.."[B]"..WHITE.."。和需要杀掉伊莫塔尔"..YELLOW.."[6]"..WHITE.."。然后你可以召唤。准备20个以上的灵魂碎片是必须的，你必须消耗碎片才能维持法阵。杀死恐惧战马后，和马的灵魂对话即可完成任务。",
				followup = "无后续",
				attain = 60,
				aim = "阅读莫苏尔的指南，并召唤出一匹克索诺斯恐惧战马，击败它，然后控制它的灵魂。.",
				title = "克索诺斯恐惧战马（术士任务）", -- 7631
				location = "莫苏尔（燃烧平原; "..YELLOW.."12,31"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "末日蜡烛（"..YELLOW.."通灵学院"..WHITE.."）", -- 7629
			},
			[5] = {
				note = "奖励德鲁伊的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "翡翠梦境（德鲁伊饰品任务）", -- 7506
				location = "翡翠梦境（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18470,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "奖励猎人的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "最伟大的猎手（猎人饰品任务）", -- 7503
				location = "最伟大的猎手（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18473,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "奖励法师的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "奥法师的食谱（法师饰品任务）", -- 7500
				location = "奥法师的食谱（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18468,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "奖励圣骑士的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "圣光之力（圣骑士饰品任务）", -- 7501
				location = "圣光之力（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18472,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "奖励牧师的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 56,
				aim = "将这本典籍交给它的主人。",
				title = "光明不会告诉你的事情（牧师饰品任务）", -- 7504
				location = "光明不会告诉你的事情（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18469,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "奖励盗贼的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "迦罗娜：潜行与诡计研究（盗贼饰品任务）", -- 7498
				location = "迦罗娜：潜行与诡计研究（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18465,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[11] = {
				note = "奖励萨满祭司的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "你与冰霜震击（萨满祭司饰品任务）", -- 7505
				location = "你与冰霜震击（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18471,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[12] = {
				note = "奖励术士的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "束缚之影（术士饰品任务）", -- 7502
				location = "束缚之影（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18467,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[13] = {
				note = "奖励战士的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "防御宝典（战士饰品任务）", -- 7499
				location = "防御宝典（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18466,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[14] = {
				note = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				followup = "无后续",
				attain = 58,
				aim = "将专注圣典、1块原始黑钻石、4份大块魔光碎片和2张暗影之皮交给厄运之槌的博学者莱德罗斯，以换取一份专注秘药。",
				title = "专注圣典", -- 7484
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "将专注圣典、1块原始黑钻石、4份大块魔光碎片和2张暗影之皮交给厄运之槌的博学者莱德罗斯，以换取一份专注秘药。",
						id = 18330,
						subtext = AQITEM_ENCHANT,
						icon = "INV_Misc_Gem_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				followup = "无后续",
				attain = 58,
				aim = "将防护圣典、1块原始黑钻石、2份大块魔光碎片和1份磨损的憎恶缝合线交给厄运之槌的博学者莱德罗斯，以换取一份防护秘药。",
				title = "防护圣典", -- 7485
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "将防护圣典、1块原始黑钻石、2份大块魔光碎片和1份磨损的憎恶缝合线交给厄运之槌的博学者莱德罗斯，以换取一份防护秘药。",
						id = 18331,
						subtext = AQITEM_ENCHANT,
						icon = "INV_Misc_Gem_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				followup = "无后续",
				attain = 58,
				aim = "将急速圣典、1块原始黑钻石、2份大块魔光碎片和2份英雄之血交给厄运之槌的博学者莱德罗斯，以换取一份急速秘药。",
				title = "急速圣典", -- 7483
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "将急速圣典、1块原始黑钻石、2份大块魔光碎片和2份英雄之血交给厄运之槌的博学者莱德罗斯，以换取一份急速秘药。",
						id = 18329,
						subtext = AQITEM_ENCHANT,
						icon = "INV_Misc_Gem_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[17] = {
				note = "战士和圣骑士才能接此任务。把书交给博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。完成后开始奎尔塞拉任务。",
				followup = "煅造奎尔塞拉", -- 7508
				attain = 60,
				aim = "将《弗洛尔的屠龙技术纲要》还回图书馆。",
				title = "弗洛尔的屠龙技术纲要（战士，圣骑士）", -- 7507
				location = "弗洛尔的屠龙技术纲要（"..YELLOW.."厄运之槌"..WHITE.."的 Boss 都可能掉落）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[18] = {
				note = "伊莫塔尔 "..YELLOW.."[6]"..WHITE.."掉落纯净的魔网精华。\n任务线从艾萨拉的守护者伊塞勒斯（"..YELLOW.."89,8,33.8"..WHITE.."）开始，位于艾萨拉的东北海岸角落。",
				followup = "无后续",
				attain = 45,
				aim = "前往厄运之槌，击败被高等精灵吸取能量的邪恶存在，收集纯净的魔网精华，然后回到艾萨拉的守护者莱娜那里。",
				title = "(TW)18. 保守秘密", -- 40254
				location = "前往厄运之槌，击败被高等精灵吸取能量的邪恶存在，收集纯净的魔网精华，然后回到艾萨拉的守护者莱娜那里。",
				level = 58,
				rewards = {
					[1] = {
						name = "艾萨拉守护者法杖", --60333
						id = 60333,
						subtext = "双手 法杖",
						icon = "INV_Staff_08",
						quality = 3,
					},
					[2] = {
						name = "埃达拉之戒", --60334
						id = 60334,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_34",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "恢复魔网线", --40253
			},
			[19] = {
				note = "强烈建议先接受正义的汉瓦的前置任务“桑萨尔护腕”（位于卡拉赞外的逆风小径小教堂内，位置标记为 "..YELLOW.."[40.9,79.3]"..WHITE.."）。\n完成“上层束缚”任务链的最后一个任务将获得任务物品“桑萨尔上部护腕”，用于“桑萨尔护腕”任务。\n奥术元素位于环绕着位置标记为 "..YELLOW.."[6]"..WHITE.."的圆圈内，它们会掉落奥术超载谐振器。",
				followup = "(TW)19. 护腕的上半部分III", -- 41013
				attain = 55,
				aim = "从厄运之槌的任意奥术元素身上收集一枚奥术超载谐振器，交给吉尔尼斯的帕纳布斯。",
				title = "(TW)19. 护腕的上半部分III", -- 41013
				location = "帕纳布斯 <流浪巫师>（吉尔尼斯； "..YELLOW.."[22.9,74.4]"..WHITE.."，吉尔尼斯城南部，河流的西边，一个孤独的房子里）。",
				level = 60,
				rewards = {
					[1] = {
						name = "桑萨尔护腕 -> 护腕的上半部分 "..YELLOW.."[黑石塔上层]"..WHITE.." -> 护腕的上半部分II", --41015, 41011, 41012
						id = 61696,
						subtext = "物品",
						icon = "INV_Misc_ArmorKit_10",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "桑萨尔护腕 -> 护腕的上半部分 "..YELLOW.."[黑石塔上层]"..WHITE.." -> 护腕的上半部分II", --41015, 41011, 41012
			},
			[20] = {
				note = "",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "在厄运之槌西击败伊莫塔尔 "..YELLOW.."[6]"..WHITE.."，从他的身上取回奥术宝石，并回到瓦多尔那里。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "多万·布雷斯温德（尘泥沼泽 - "..YELLOW.."[71.1,73.2]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "卡拉赞的钥匙 I - VI -> 卡拉赞的钥匙 VII "..YELLOW.."[斯坦索姆]"..WHITE.." ", --40817
			},
			[21] = {
				note = "在环绕着"..YELLOW.."[6]"..WHITE.."的圈内，秘法洪流的元素生物会掉落过载的奥术过载棱镜。完成这个任务线后，你将获得项链，并能够进入海加尔山的团队副本翡翠圣殿。",
				followup = "(TW)21. 寐入梦境III", -- 40959
				attain = 58,
				aim = "在"..YELLOW.."[艾萨拉]"..WHITE.."的峭壁击碎者身上收集一个绑定碎片，从"..YELLOW.."[厄运之槌西]"..WHITE.."的秘法洪流中获得奥术过载棱镜，从"..YELLOW.."[沉没的神庙]"..WHITE.."的沉睡绿龙身上收集一个沉睡者的碎片，还需要一根奥金棒。将收集到的物品带给悲伤沼泽的伊萨里奥斯。",
				title = "(TW)21. 寐入梦境III", -- 40959
				location = "拉拉修斯（海加尔山 - 诺达纳尔；"..YELLOW.."[81.6,27.7]"..WHITE.." 一只绿色龙人）",
				level = 60,
				rewards = {
					[1] = {
						name = "伊瑟拉宝钻", -- 50545
						id = 50545,
						subtext = "颈部",
						icon = "INV_Misc_Gem_Emerald_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "(TW)21. 寐入梦境III", -- 40959
			},
		},
		[2] = {
			[1] = {
				note = "卡里尔·温萨鲁斯在（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "到厄运之槌去寻找卡里尔·温萨鲁斯。向莫沙彻营地的先知科鲁拉克报告你所找到的信息。",
				title = "精灵的传说", -- 7482
				location = "先知科鲁拉克（菲拉斯 - 莫沙彻营地; "..YELLOW.."74,43"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "水晶塔被标记为"..BLUE.."[B]"..WHITE.."。伊莫塔尔在"..YELLOW.."[6]"..WHITE.."，托塞德林王子在"..YELLOW.."[7]"..WHITE.."。",
				followup = "辛德拉的宝藏", -- 7877
				attain = 56,
				aim = "你必须干掉5座水晶塔周围的守卫，那5座水晶塔维持着关押伊莫塔尔的监狱。一旦水晶塔的能量被削弱，伊莫塔尔周围的能量力场就会消散。\n 进入伊莫塔尔的监狱，干掉站在中间的那个恶魔。最后，在图书馆挑战托塞德林王子。当任务完成之后，到庭院中去找辛德拉古灵。",
				title = "伊莫塔尔的疯狂", -- 7461
				location = "辛德拉古灵（厄运之槌; "..YELLOW.."西，（上层）[1]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在图书馆的梯子下面找到宝藏"..YELLOW.."[7]"..WHITE.."。",
				followup = "无后续",
				attain = 56,
				aim = "返回图书馆去找到辛德拉的宝藏。拿取你的奖励吧！",
				title = "辛德拉的宝藏", -- 7877
				location = "辛德拉古灵（厄运之槌; "..YELLOW.."西，（上层）[1]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "莎草长靴",
						id = 18424,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_05",
						quality = 3,
					},
					[2] = {
						name = "密林头盔",
						id = 18421,
						subtext = "头部 锁甲",
						icon = "INV_Helmet_19",
						quality = 3,
					},
					[3] = {
						name = "碾骨者",
						id = 18420,
						subtext = "双手 锤",
						icon = "INV_Mace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "伊莫塔尔的疯狂", -- 7461
			},
			[4] = {
				note = "术士的史诗战马任务的最后一步。首先必须关闭水晶塔"..BLUE.."[B]"..WHITE.."。和需要杀掉伊莫塔尔"..YELLOW.."[6]"..WHITE.."。然后你可以召唤。准备20个以上的灵魂碎片是必须的，你必须消耗碎片才能维持法阵。杀死恐惧战马后，和马的灵魂对话即可完成任务。",
				followup = "无后续",
				attain = 60,
				aim = "阅读莫苏尔的指南，并召唤出一匹克索诺斯恐惧战马，击败它，然后控制它的灵魂。.",
				title = "克索诺斯恐惧战马（术士任务）", -- 7631
				location = "莫苏尔（燃烧平原; "..YELLOW.."12,31"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "末日蜡烛（"..YELLOW.."通灵学院"..WHITE.."）", -- 7629
			},
			[5] = {
				note = "奖励德鲁伊的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "翡翠梦境（德鲁伊饰品任务）", -- 7506
				location = "翡翠梦境（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18470,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "奖励猎人的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "最伟大的猎手（猎人饰品任务）", -- 7503
				location = "最伟大的猎手（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18473,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
				},
				prequest = "无前置",
			},
			[7] = {
				note = "奖励法师的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "奥法师的食谱（法师饰品任务）", -- 7500
				location = "奥法师的食谱（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18468,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "奖励圣骑士的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "圣光之力（圣骑士饰品任务）", -- 7501
				location = "圣光之力（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18472,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "奖励牧师的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 56,
				aim = "将这本典籍交给它的主人。",
				title = "光明不会告诉你的事情（牧师饰品任务）", -- 7504
				location = "光明不会告诉你的事情（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18469,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "奖励盗贼的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "迦罗娜：潜行与诡计研究（盗贼饰品任务）", -- 7498
				location = "迦罗娜：潜行与诡计研究（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18465,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[11] = {
				note = "奖励萨满祭司的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "你与冰霜震击（萨满祭司饰品任务）", -- 7505
				location = "你与冰霜震击（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18471,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[12] = {
				note = "奖励术士的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "束缚之影（术士饰品任务）", -- 7502
				location = "束缚之影（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18467,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[13] = {
				note = "奖励战士的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 54,
				aim = "将这本典籍交给它的主人。",
				title = "防御宝典（战士饰品任务）", -- 7499
				location = "防御宝典（厄运之槌的所有几个副本的Boss都可能掉落）",
				level = 60,
				rewards = {
					[1] = {
						name = "埃雷萨拉斯皇家徽记",
						id = 18466,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[14] = {
				note = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				followup = "无后续",
				attain = 58,
				aim = "将专注圣典、1块原始黑钻石、4份大块魔光碎片和2张暗影之皮交给厄运之槌的博学者莱德罗斯，以换取一份专注秘药。",
				title = "专注圣典", -- 7484
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "将专注圣典、1块原始黑钻石、4份大块魔光碎片和2张暗影之皮交给厄运之槌的博学者莱德罗斯，以换取一份专注秘药。",
						id = 18330,
						subtext = AQITEM_ENCHANT,
						icon = "INV_Misc_Gem_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				followup = "无后续",
				attain = 58,
				aim = "将防护圣典、1块原始黑钻石、2份大块魔光碎片和1份磨损的憎恶缝合线交给厄运之槌的博学者莱德罗斯，以换取一份防护秘药。",
				title = "防护圣典", -- 7485
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "将防护圣典、1块原始黑钻石、2份大块魔光碎片和1份磨损的憎恶缝合线交给厄运之槌的博学者莱德罗斯，以换取一份防护秘药。",
						id = 18331,
						subtext = AQITEM_ENCHANT,
						icon = "INV_Misc_Gem_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				followup = "无后续",
				attain = 58,
				aim = "将急速圣典、1块原始黑钻石、2份大块魔光碎片和2份英雄之血交给厄运之槌的博学者莱德罗斯，以换取一份急速秘药。",
				title = "急速圣典", -- 7483
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "将急速圣典、1块原始黑钻石、2份大块魔光碎片和2份英雄之血交给厄运之槌的博学者莱德罗斯，以换取一份急速秘药。",
						id = 18329,
						subtext = AQITEM_ENCHANT,
						icon = "INV_Misc_Gem_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[17] = {
				note = "战士和圣骑士才能接此任务。把书交给博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。完成后开始奎尔塞拉任务。",
				followup = "煅造奎尔塞拉", -- 7508
				attain = 60,
				aim = "将《弗洛尔的屠龙技术纲要》还回图书馆。",
				title = "弗洛尔的屠龙技术纲要（战士，圣骑士）", -- 7507
				location = "弗洛尔的屠龙技术纲要（"..YELLOW.."厄运之槌"..WHITE.."的 Boss 都可能掉落）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[18] = {
				note = "伊莫塔尔 "..YELLOW.."[6]"..WHITE.."掉落纯净的魔网精华。\n任务线从艾萨拉的守护者伊塞勒斯（"..YELLOW.."89,8,33.8"..WHITE.."）开始，位于艾萨拉的东北海岸角落。",
				followup = "无后续",
				attain = 45,
				aim = "前往厄运之槌，击败被高等精灵吸取能量的邪恶存在，收集纯净的魔网精华，然后回到艾萨拉的守护者莱娜那里。",
				title = "(TW)18. 保守秘密", -- 40254
				location = "前往厄运之槌，击败被高等精灵吸取能量的邪恶存在，收集纯净的魔网精华，然后回到艾萨拉的守护者莱娜那里。",
				level = 58,
				rewards = {
					[1] = {
						name = "艾萨拉守护者法杖", --60333
						id = 60333,
						subtext = "双手 法杖",
						icon = "INV_Staff_08",
						quality = 3,
					},
					[2] = {
						name = "埃达拉之戒", --60334
						id = 60334,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_34",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "恢复魔网线", --40253
			},
			[19] = {
				note = "强烈建议先接受正义的汉瓦的前置任务“桑萨尔护腕”（位于卡拉赞外的逆风小径小教堂内，位置标记为 "..YELLOW.."[40.9,79.3]"..WHITE.."）。\n完成“上层束缚”任务链的最后一个任务将获得任务物品“桑萨尔上部护腕”，用于“桑萨尔护腕”任务。\n奥术元素位于环绕着位置标记为 "..YELLOW.."[6]"..WHITE.."的圆圈内，它们会掉落奥术超载谐振器。",
				followup = "(TW)19. 护腕的上半部分III", -- 41013
				attain = 55,
				aim = "从厄运之槌的任意奥术元素身上收集一枚奥术超载谐振器，交给吉尔尼斯的帕纳布斯。",
				title = "(TW)19. 护腕的上半部分III", -- 41013
				location = "帕纳布斯 <流浪巫师>（吉尔尼斯； "..YELLOW.."[22.9,74.4]"..WHITE.."，吉尔尼斯城南部，河流的西边，一个孤独的房子里）。",
				level = 60,
				rewards = {
					[1] = {
						name = "桑萨尔护腕 -> 护腕的上半部分 "..YELLOW.."[黑石塔上层]"..WHITE.." -> 护腕的上半部分II", --41015, 41011, 41012
						id = 61696,
						subtext = "物品",
						icon = "INV_Misc_ArmorKit_10",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "桑萨尔护腕 -> 护腕的上半部分 "..YELLOW.."[黑石塔上层]"..WHITE.." -> 护腕的上半部分II", --41015, 41011, 41012
			},
			[20] = {
				note = "",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "在厄运之槌西击败伊莫塔尔 "..YELLOW.."[6]"..WHITE.."，从他的身上取回奥术宝石，并回到瓦多尔那里。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "多万·布雷斯温德（尘泥沼泽 - "..YELLOW.."[71.1,73.2]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "卡拉赞的钥匙 I - VI -> 卡拉赞的钥匙 VII "..YELLOW.."[斯坦索姆]"..WHITE.." ", --40817
			},
			[21] = {
				note = "在环绕着"..YELLOW.."[6]"..WHITE.."的圈内，秘法洪流的元素生物会掉落过载的奥术过载棱镜。完成这个任务线后，你将获得项链，并能够进入海加尔山的团队副本翡翠圣殿。",
				followup = "(TW)21. 寐入梦境III", -- 40959
				attain = 58,
				aim = "在"..YELLOW.."[艾萨拉]"..WHITE.."的峭壁击碎者身上收集一个绑定碎片，从"..YELLOW.."[厄运之槌西]"..WHITE.."的秘法洪流中获得奥术过载棱镜，从"..YELLOW.."[沉没的神庙]"..WHITE.."的沉睡绿龙身上收集一个沉睡者的碎片，还需要一根奥金棒。将收集到的物品带给悲伤沼泽的伊萨里奥斯。",
				title = "(TW)21. 寐入梦境III", -- 40959
				location = "拉拉修斯（海加尔山 - 诺达纳尔；"..YELLOW.."[81.6,27.7]"..WHITE.." 一只绿色龙人）",
				level = 60,
				rewards = {
					[1] = {
						name = "伊瑟拉宝钻", -- 50545
						id = 50545,
						subtext = "颈部",
						icon = "INV_Misc_Gem_Emerald_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "(TW)21. 寐入梦境III", -- 40959
			},
		},
	},
	[13] = {
		name = "玛拉顿",
		story = "玛拉顿被狂暴的玛拉顿半人马所保护，那是凄凉之地最神圣的地方。玛拉顿是扎尔塔的伟大神庙，扎尔塔使半神塞纳留斯不朽的儿子之一。传说说扎尔塔和瑟莱德丝大地元素公主的私生子成为了半人马种族。据说半人马这个野蛮的种族在其出生了之后就开始转向他们的父亲并将其杀死。有些人则相信瑟莱德丝在悲伤中将扎尔塔的灵魂困了起来，并将其藏在洞中——利用它的能量来达到一些不可告人的目的。在玛拉顿错综复杂的地下通道中到处都是邪恶的半人马可汗灵魂和瑟莱德丝的元素爪牙。",
		[1] = {
			[1] = {
				note = "暗影残片可以从“暗影碎片巡游者”或者“暗影碎片击碎者”身上找到。",
				followup = "无后续",
				attain = 38,
				aim = "从玛拉顿收集10块暗影残片，然后把它们交给尘泥沼泽塞拉摩岛上的大法师特沃什。",
				title = "暗影残片", -- 7070
				location = "大法师特沃什（尘泥沼泽 - 塞拉摩岛; "..YELLOW.."66,49"..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "热情暗影残片坠饰",
						id = 17772,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_06",
						quality = 2,
					},
					[2] = {
						name = "巨型暗影碎片坠饰",
						id = 17773,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你可以在玛拉顿里任何一个橙色的水池装水。藤蔓生长在橙色或紫色区域。",
				followup = "无后续",
				attain = 41,
				aim = "在玛拉顿里用天蓝水瓶在橙色水晶池中装满水。\n在维利斯塔姆藤蔓上使用装满水的天蓝水瓶，使堕落的诺克赛恩幼体出现。\n治疗8株植物并杀死那些诺克赛恩幼体，然后向尼耶尔前哨站的塔琳德莉亚复命。",
				title = "维利塔恩的污染", -- 7041
				location = "塔琳德莉亚（凄凉之地 - 尼耶尔前哨站; "..YELLOW.."68,8"..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "树种之环",
						id = 17768,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_18",
						quality = 2,
					},
					[2] = {
						name = "山艾束腰",
						id = 17778,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_25",
						quality = 2,
					},
					[3] = {
						name = "枝爪护手",
						id = 17770,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_30",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "大多数玛拉顿里的敌人都掉落雕像。",
				followup = "无后续",
				attain = 41,
				aim = "为凄凉之地的维洛收集25个瑟莱德丝水晶雕像。",
				title = "扭曲的邪恶", -- 7028
				location = "为凄凉之地的维洛收集25个瑟莱德丝水晶雕像。",
				level = 47,
				rewards = {
					[1] = {
						name = "聪颖长袍",
						id = 17775,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_49",
						quality = 2,
					},
					[2] = {
						name = "轻环头盔",
						id = 17776,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_35",
						quality = 2,
					},
					[3] = {
						name = "无情链甲",
						id = 17777,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_07",
						quality = 2,
					},
					[4] = {
						name = "巨石肩铠",
						id = 17779,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_23",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "5个可汗（《贱民的指引》的描述）",
				followup = "无后续",
				attain = 39,
				aim = "阅读贱民的指引，然后从玛拉顿得到联合坠饰，将其交给凄凉之地南部的半人马贱民。",
				title = "贱民的指引", -- 7067
				location = "阅读贱民的指引，然后从玛拉顿得到联合坠饰，将其交给凄凉之地南部的半人马贱民。",
				level = 48,
				rewards = {
					[1] = {
						name = "天选者印记",
						id = 17774,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_08",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
				pages = {
					"You find the Centaur Pariah in the south of desolace. He walks between "..NORMAL.."44,85"..WHITE.." and "..NORMAL.."50,87"..WHITE..".\nFirst, you have to kill the The Nameless Prophet ("..NORMAL.."[A] on Entrance Map"..WHITE.."). You find him before you enter the instance, before the point where you can choose whether you take the purple or the orange entrance. After killing him you must kill the 5 Kahns. You find the first if you choose the way in the middle ("..NORMAL.."[1] on Entrance Map"..WHITE.."). The second is in the purple part of Maraudon but before you enter the instance ("..NORMAL.."[2] on Entrance Map"..WHITE.."). The third is in the orange part before you enter the instance ("..NORMAL.."[3] on Entrance Map"..WHITE.."). The fourth is near "..NORMAL.."[4]"..WHITE.." and the fifth is near  "..NORMAL.."[1]"..WHITE..".",
				}
			},
			[5] = {
				note = "凯雯德拉就在进入副本之前的橙色部分的开始处。\n你可以从诺克塞恩那里得到塞雷布拉斯魔棒"..YELLOW.."[2]"..WHITE.."，从维利塔恩那里得到塞雷布拉斯钻石"..YELLOW.."[5]"..WHITE.."。塞雷布拉斯在"..YELLOW.."[7]"..WHITE.."。你需要打败他才能和他说话。",
				followup = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
				attain = 41,
				aim = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
				title = "玛拉顿的传说", -- 7044
				location = "凯雯德拉（凄凉之地 - 玛拉顿; "..YELLOW.."副本入口地图[4]"..WHITE.."）",
				level = 49,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "塞雷布拉斯制造节杖。当仪式完成之后，和他对话。",
				followup = "无后续",
				attain = 41,
				aim = "帮助赎罪的塞雷布拉斯制作塞雷布拉斯节杖。\n当仪式完成之后再和他谈谈。",
				title = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
				location = "赎罪的塞雷布拉斯（玛拉顿 "..YELLOW.."[7]"..WHITE.."）",
				level = 49,
				rewards = {
					[1] = {
						name = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
						id = 17191,
						subtext = "物品",
						icon = "INV_Staff_16",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "玛拉顿的传说", -- 7044
			},
			[7] = {
				note = "瑟莱德丝公主在"..YELLOW.."[11]"..WHITE.."。",
				followup = "生命之种", -- 7066
				attain = 45,
				aim = "杀死瑟莱德丝公主，然后回到凄凉之地尼耶尔前哨站的守护者玛兰迪斯那里复命。",
				title = "大地的污染", -- 7065
				location = "杀死瑟莱德丝公主，然后回到凄凉之地尼耶尔前哨站的守护者玛兰迪斯那里复命。",
				level = 51,
				rewards = {
					[1] = {
						name = "痛击之刃",
						id = 17705,
						subtext = "单手 剑",
						icon = "INV_Sword_36",
						quality = 3,
					},
					[2] = {
						name = "苏醒之杖",
						id = 17743,
						subtext = "法杖",
						icon = "INV_Staff_Goldfeathered_01",
						quality = 3,
					},
					[3] = {
						name = "绿色守护者之弓",
						id = 17753,
						subtext = "弓",
						icon = "INV_Weapon_Bow_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "杀死公主后，扎尔塔的灵魂就会出现（"..YELLOW.."[11]"..WHITE.."）。守护者雷姆洛斯在（月光林地 - 雷姆洛斯神殿; "..YELLOW.."36,41"..WHITE.."）。",
				followup = "无后续",
				attain = 45,
				aim = "到月光林地去找到雷姆洛斯，将生命之种交给他。",
				title = "生命之种", -- 7066
				location = "扎尔塔的灵魂（玛拉顿 "..YELLOW.."[11]"..WHITE.."）",
				level = 51,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "大地的污染", -- 7065
			},
			[9] = {
				note = "玛拉顿紫门的恶魔领主维利塔恩 "..YELLOW.."[5]"..WHITE.." 掉落奇美兰的背带（乌龟服翻译为：半人马的虐待）。",
				followup = "无后续",
				attain = 38,
				aim = "从玛拉顿那里取回奇美兰的背带，并将其带回菲拉斯-奇美拉栖息谷的维洛斯·锐击处。",
				title = "(TW)9. 奇美兰的挽具", -- 41052
				location = "维洛斯·锐击（菲拉斯 - 奇美拉栖息谷；"..YELLOW.."[82.0,62.3]"..WHITE.." 菲拉斯东南角）",
				level = 48,
				rewards = {
					[1] = {
						name = "奇美拉之眼", -- 61517
						id = 61517,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Emerald_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "清理巢穴 -> 喂养幼崽", --41050, 41051
			},
			[10] = {
				note = "Landslide is at "..NORMAL.."[8]"..WHITE..".",
				followup = "Thunderforge Mastery",
				attain = 40,
				aim = "Obtain the Heart of Landslide from the depths of Maraudon, and the Essence of Corrosis from Hateforge Quarry for Frig Thunderforge at Aerie Peak",
				title = "Why Not Both?",
				location = "Frig Thunderforge (Hinterlands - Aerie Peak; "..NORMAL.."[10.0, 49.3]"..WHITE..").",
				level = 50,
				rewards = {
					[1] = {
						name = "Thunderforge Lance",
						id = 40080,
						subtext = "长柄武器",
						icon = "inv_spear_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "Proving A Point -> I've Read It In A Book Once",
			},
		},
		[2] = {
			[1] = {
				note = "暗影残片可以从“暗影碎片巡游者”或者“暗影碎片击碎者”身上找到。",
				followup = "无后续",
				attain = 38,
				aim = "从玛拉顿收集10块暗影残片，然后把它们交给奥格瑞玛的尤塞尔奈。",
				title = "暗影残片", -- 7070
				location = "尤塞尔奈（奥格瑞玛 - 精神谷; "..YELLOW.."39,86"..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "热情暗影残片坠饰",
						id = 17772,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_06",
						quality = 2,
					},
					[2] = {
						name = "巨型暗影碎片坠饰",
						id = 17773,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你可以在玛拉顿里任何一个橙色的水池装水。藤蔓生长在橙色或紫色区域。",
				followup = "无后续",
				attain = 41,
				aim = "在玛拉顿里用天蓝水瓶在橙色水晶池中装满水。\n在维利斯塔姆藤蔓上使用装满水的天蓝水瓶，使堕落的诺克赛恩幼体出现。\n治疗8株植物并杀死那些诺克赛恩幼体，然后向葬影村的瓦克·战痕复命。",
				title = "维利塔恩的污染", -- 7041
				location = "瓦克·战痕（凄凉之地 - 葬影村; "..YELLOW.."23,70"..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "树种之环",
						id = 17768,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_18",
						quality = 2,
					},
					[2] = {
						name = "山艾束腰",
						id = 17778,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_25",
						quality = 2,
					},
					[3] = {
						name = "枝爪护手",
						id = 17770,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_30",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "大多数玛拉顿里的敌人都掉落雕像。",
				followup = "无后续",
				attain = 41,
				aim = "为凄凉之地的维洛收集25个瑟莱德丝水晶雕像。",
				title = "扭曲的邪恶", -- 7028
				location = "为凄凉之地的维洛收集25个瑟莱德丝水晶雕像。",
				level = 47,
				rewards = {
					[1] = {
						name = "聪颖长袍",
						id = 17775,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_49",
						quality = 2,
					},
					[2] = {
						name = "轻环头盔",
						id = 17776,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_35",
						quality = 2,
					},
					[3] = {
						name = "无情链甲",
						id = 17777,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_07",
						quality = 2,
					},
					[4] = {
						name = "巨石肩铠",
						id = 17779,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_23",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "5个可汗（《贱民的指引》的描述）",
				followup = "无后续",
				attain = 39,
				aim = "阅读贱民的指引，然后从玛拉顿得到联合坠饰，将其交给凄凉之地南部的半人马贱民。",
				title = "贱民的指引", -- 7067
				location = "阅读贱民的指引，然后从玛拉顿得到联合坠饰，将其交给凄凉之地南部的半人马贱民。",
				level = 48,
				rewards = {
					[1] = {
						name = "天选者印记",
						id = 17774,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_08",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
				pages = {
					"You find the Centaur Pariah in the south of desolace. He walks between "..NORMAL.."44,85"..WHITE.." and "..NORMAL.."50,87"..WHITE..".\nFirst, you have to kill the The Nameless Prophet ("..NORMAL.."[A] on Entrance Map"..WHITE.."). You find him before you enter the instance, before the point where you can choose whether you take the purple or the orange entrance. After killing him you must kill the 5 Kahns. You find the first if you choose the way in the middle ("..NORMAL.."[1] on Entrance Map"..WHITE.."). The second is in the purple part of Maraudon but before you enter the instance ("..NORMAL.."[2] on Entrance Map"..WHITE.."). The third is in the orange part before you enter the instance ("..NORMAL.."[3] on Entrance Map"..WHITE.."). The fourth is near "..NORMAL.."[4]"..WHITE.." and the fifth is near  "..NORMAL.."[1]"..WHITE..".",
				}
			},
			[5] = {
				note = "凯雯德拉就在进入副本之前的橙色部分的开始处。\n你可以从诺克塞恩那里得到塞雷布拉斯魔棒"..YELLOW.."[2]"..WHITE.."，从维利塔恩那里得到塞雷布拉斯钻石"..YELLOW.."[5]"..WHITE.."。塞雷布拉斯在"..YELLOW.."[7]"..WHITE.."。你需要打败他才能和他说话。",
				followup = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
				attain = 41,
				aim = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
				title = "玛拉顿的传说", -- 7044
				location = "凯雯德拉（凄凉之地 - 玛拉顿; "..YELLOW.."副本入口地图[4]"..WHITE.."）",
				level = 49,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "塞雷布拉斯制造节杖。当仪式完成之后，和他对话。",
				followup = "无后续",
				attain = 41,
				aim = "帮助赎罪的塞雷布拉斯制作塞雷布拉斯节杖。\n当仪式完成之后再和他谈谈。",
				title = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
				location = "赎罪的塞雷布拉斯（玛拉顿 "..YELLOW.."[7]"..WHITE.."）",
				level = 49,
				rewards = {
					[1] = {
						name = "找回塞雷布拉斯节杖的两个部分：塞雷布拉斯魔棒和塞雷布拉斯钻石。\n然后设法和塞雷布拉斯对话。",
						id = 17191,
						subtext = "物品",
						icon = "INV_Staff_16",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "玛拉顿的传说", -- 7044
			},
			[7] = {
				note = "瑟莱德丝公主在"..YELLOW.."[11]"..WHITE.."。",
				followup = "生命之种", -- 7066
				attain = 45,
				aim = "杀死瑟莱德丝公主，然后回到凄凉之地葬影村附近的瑟琳德拉那里复命。",
				title = "大地的污染", -- 7065
				location = "杀死瑟莱德丝公主，然后回到凄凉之地葬影村附近的瑟琳德拉那里复命。",
				level = 51,
				rewards = {
					[1] = {
						name = "痛击之刃",
						id = 17705,
						subtext = "单手 剑",
						icon = "INV_Sword_36",
						quality = 3,
					},
					[2] = {
						name = "苏醒之杖",
						id = 17743,
						subtext = "法杖",
						icon = "INV_Staff_Goldfeathered_01",
						quality = 3,
					},
					[3] = {
						name = "绿色守护者之弓",
						id = 17753,
						subtext = "弓",
						icon = "INV_Weapon_Bow_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "杀死公主后，扎尔塔的灵魂就会出现（"..YELLOW.."[11]"..WHITE.."）。守护者雷姆洛斯在（月光林地 - 雷姆洛斯神殿; "..YELLOW.."36,41"..WHITE.."）。",
				followup = "无后续",
				attain = 45,
				aim = "到月光林地去找到雷姆洛斯，将生命之种交给他。",
				title = "生命之种", -- 7066
				location = "扎尔塔的灵魂（玛拉顿 "..YELLOW.."[11]"..WHITE.."）",
				level = 51,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "大地的污染", -- 7065
			},
		},
	},
	[14] = {
		name = "熔火之心",
		story = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
		[1] = {
			[1] = {
				note = "这些都不是熔火之心的Boss。",
				followup = "海达克西斯的使者", -- 6823
				attain = 57,
				aim = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				title = "熔火之心", -- 6822
				location = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "艾博希尔之眼（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 6821
			},
			[2] = {
				note = "将鲁西弗隆之手、萨弗隆之手、基赫纳斯之手和沙斯拉尔之手交给艾萨拉的海达克西斯公爵。",
				followup = "英雄的奖赏", -- 7486
				attain = 60,
				aim = "将鲁西弗隆之手、萨弗隆之手、基赫纳斯之手和沙斯拉尔之手交给艾萨拉的海达克西斯公爵。",
				title = "敌人之手", -- 6824
				location = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "海达克西斯的使者", -- 6823
			},
			[3] = {
				note = "雷霆之怒，逐风者的祝福之剑部分任务，当你从加尔"..YELLOW.."[4]"..WHITE.."拿到逐风者禁锢之颅右半和迦顿男爵"..YELLOW.."[6]"..WHITE.."拿到逐风者禁锢之颅左半后，与德米提恩对话开启任务线。拉格纳罗斯"..YELLOW.."[10]"..WHITE.."掉落火焰之王的精华。完成这些后，召唤并杀掉桑德兰王子，这是一个40人团队 Boss。",
				followup = "觉醒吧，雷霆之怒！", -- 7787
				attain = 60,
				aim = "如果你想要把逐风者桑德兰从监牢里释放出来，你就必须找到左右两块逐风者禁锢之颅，10块源质锭，以及火焰之王的精华，把它们交给德米提恩。",
				title = "逐风者桑德兰", -- 7786
				location = "如果你想要把逐风者桑德兰从监牢里释放出来，你就必须找到左右两块逐风者禁锢之颅，10块源质锭，以及火焰之王的精华，把它们交给德米提恩。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "复生之瓶", -- 7785
			},
			[4] = {
				note = "你需要萨弗隆铁锭来与洛克图斯签订契约。熔火之心的焚化者古雷曼格"..YELLOW.."[7]"..WHITE.."掉落铁锭。",
				followup = "无后续",
				attain = 60,
				aim = "如果你愿意接受萨弗隆的设计图，请将瑟银兄弟会契约交给罗克图斯·暗契。",
				title = "瑟银兄弟会契约", -- 7604
				location = "罗克图斯·暗契（黑石深渊; "..YELLOW.."[15]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：萨弗隆之锤",
						id = 18592,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "把远古石叶交还给古树瓦特鲁斯（费伍德森林 - 铁木森林; "..YELLOW.."49,24"..WHITE.."）。",
				followup = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
				attain = 60,
				aim = "找到远古石叶的主人。",
				title = "远古石叶", -- 7632
				location = "在（火焰之王的宝箱; "..YELLOW.."[9]"..WHITE.."）之中，可能有远古石叶。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "只有一个人可以拾取这一章节。《龙语入门 VIII》 (掉落自拉格纳罗斯; "..YELLOW.."[10]"..WHITE..")",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
				attain = 60,
				aim = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				title = "唯一的方案", -- 8620
				location = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				level = 60,
				rewards = {
					[1] = {
						name = "精神力量之侏儒头巾",
						id = 21517,
						subtext = "头部 布甲",
						icon = "INV_Helmet_63",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "螳螂捕蝉！", -- 8606
			},
			[7] = {
				note = "掉落自MC各boss.",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)", -- 8728
				attain = 60,
				aim = "找到占卜眼镜并归还该纳瑞安.",
				title = "占卜眼镜？没问题！", -- 8578
				location = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				level = 60,
				rewards = {
					[1] = {
						name = "特效活力药水",
						id = 18253,
						subtext = "药水",
						icon = "INV_Potion_47",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1(x3)",
				},
				prequest = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
			},
		},
		[2] = {
			[1] = {
				note = "这些都不是熔火之心的Boss。",
				followup = "海达克西斯的使者", -- 6823
				attain = 57,
				aim = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				title = "熔火之心", -- 6822
				location = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "艾博希尔之眼（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 6821
			},
			[2] = {
				note = "将鲁西弗隆之手、萨弗隆之手、基赫纳斯之手和沙斯拉尔之手交给艾萨拉的海达克西斯公爵。",
				followup = "英雄的奖赏", -- 7486
				attain = 60,
				aim = "将鲁西弗隆之手、萨弗隆之手、基赫纳斯之手和沙斯拉尔之手交给艾萨拉的海达克西斯公爵。",
				title = "敌人之手", -- 6824
				location = "杀死一个火焰之王、一个熔岩巨人、一个上古熔火恶犬和一个熔岩奔腾者，然后回到艾萨拉的海达克西斯公爵那里。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "海达克西斯的使者", -- 6823
			},
			[3] = {
				note = "雷霆之怒，逐风者的祝福之剑部分任务，当你从加尔"..YELLOW.."[4]"..WHITE.."拿到逐风者禁锢之颅右半和迦顿男爵"..YELLOW.."[6]"..WHITE.."拿到逐风者禁锢之颅左半后，与德米提恩对话开启任务线。拉格纳罗斯"..YELLOW.."[10]"..WHITE.."掉落火焰之王的精华。完成这些后，召唤并杀掉桑德兰王子，这是一个40人团队 Boss。",
				followup = "觉醒吧，雷霆之怒！", -- 7787
				attain = 60,
				aim = "如果你想要把逐风者桑德兰从监牢里释放出来，你就必须找到左右两块逐风者禁锢之颅，10块源质锭，以及火焰之王的精华，把它们交给德米提恩。",
				title = "逐风者桑德兰", -- 7786
				location = "如果你想要把逐风者桑德兰从监牢里释放出来，你就必须找到左右两块逐风者禁锢之颅，10块源质锭，以及火焰之王的精华，把它们交给德米提恩。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "复生之瓶", -- 7785
			},
			[4] = {
				note = "你需要萨弗隆铁锭来与洛克图斯签订契约。熔火之心的焚化者古雷曼格"..YELLOW.."[7]"..WHITE.."掉落铁锭。",
				followup = "无后续",
				attain = 60,
				aim = "如果你愿意接受萨弗隆的设计图，请将瑟银兄弟会契约交给罗克图斯·暗契。",
				title = "瑟银兄弟会契约", -- 7604
				location = "罗克图斯·暗契（黑石深渊; "..YELLOW.."[15]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：萨弗隆之锤",
						id = 18592,
						subtext = "图样",
						icon = "INV_Scroll_03",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "把远古石叶交还给古树瓦特鲁斯（费伍德森林 - 铁木森林; "..YELLOW.."49,24"..WHITE.."）。",
				followup = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
				attain = 60,
				aim = "找到远古石叶的主人。",
				title = "远古石叶", -- 7632
				location = "在（火焰之王的宝箱; "..YELLOW.."[9]"..WHITE.."）之中，可能有远古石叶。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "只有一个人可以拾取这一章节。《龙语入门 VIII》 (掉落自拉格纳罗斯; "..YELLOW.."[10]"..WHITE..")",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
				attain = 60,
				aim = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				title = "唯一的方案", -- 8620
				location = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				level = 60,
				rewards = {
					[1] = {
						name = "精神力量之侏儒头巾",
						id = 21517,
						subtext = "头部 布甲",
						icon = "INV_Helmet_63",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "螳螂捕蝉！", -- 8606
			},
			[7] = {
				note = "掉落自MC各boss.",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)", -- 8728
				attain = 60,
				aim = "找到占卜眼镜并归还该纳瑞安.",
				title = "占卜眼镜？没问题！", -- 8578
				location = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				level = 60,
				rewards = {
					[1] = {
						name = "特效活力药水",
						id = 18253,
						subtext = "药水",
						icon = "INV_Potion_47",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1(x3)",
				},
				prequest = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
			},
		},
	},
	[15] = {
		name = "纳克萨玛斯",
		story = "飘浮在瘟疫之地上空的浮空要塞纳克萨玛斯是巫妖王最强大的副官——克尔苏加德的旗舰。巫妖王的仆从们在这座要塞中筹划着新的攻势，要给整个艾泽拉斯世界带来恐慌和灾难。天灾军团再一次开始了他们的征程……",
		[1] = {
			[1] = {
				note = "英尼戈·蒙托尔神父（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,58"..WHITE.."）",
				followup = "无后续",
				attain = 60,
				aim = "将克尔苏加德的护符匣带往东瘟疫之地圣光之愿礼拜堂。",
				title = "克尔苏加德的末日", -- 9120
				location = "克尔苏加德（纳克萨玛斯; "..YELLOW.."绿色 2"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "勇士印记",
						id = 23206,
						subtext = "饰品",
						icon = "INV_Misc_Token_ArgentDawn2",
						quality = 4,
					},
					[2] = {
						name = "勇士印记",
						id = 23207,
						subtext = "饰品",
						icon = "INV_Misc_Token_ArgentDawn3",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "纳克萨玛斯掉落的溶解之语可以从墙上得到冰冻符文。",
				followup = "无后续",
				attain = 60,
				aim = "将2个冰冻符文、2个水之精华、2块蓝宝石和30金币交给东瘟疫之地圣光之愿礼拜堂的工匠威尔海姆。",
				title = "我只会唱这一首歌……", -- 9232
				location = "将2个冰冻符文、2个水之精华、2块蓝宝石和30金币交给东瘟疫之地圣光之愿礼拜堂的工匠威尔海姆。",
				level = 60,
				rewards = {
					[1] = {
						name = "冰川护腿",
						id = 22700,
						subtext = "腿部 布甲",
						icon = "INV_Pants_06",
						quality = 4,
					},
					[2] = {
						name = "破冰护腿",
						id = 22699,
						subtext = "腿部 板甲",
						icon = "INV_Pants_04",
						quality = 4,
					},
					[3] = {
						name = "寒鳞护腿",
						id = 22702,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_Mail_15",
						quality = 4,
					},
					[4] = {
						name = "北极护腿",
						id = 22701,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_Leather_21",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "需要杀死的怪物是各个不同的区的小怪。这个任务完成后才能制作 T3 套装。",
				followup = "无后续",
				attain = 60,
				aim = "东瘟疫之地圣光之愿礼拜堂的指挥官埃里戈尔·黎明使者要你杀死5个畸形妖、5只岩肤石像鬼、8个死亡骑士队长和3只毒性捕猎者。",
				title = "战争的回响", -- 9033
				location = "东瘟疫之地圣光之愿礼拜堂的指挥官埃里戈尔·黎明使者要你杀死5个畸形妖、5只岩肤石像鬼、8个死亡骑士队长和3只毒性捕猎者。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "恐怖之城，纳克萨玛斯", -- 9121 or 9122 or 9123
			},
			[4] = {
				note = "纳克萨玛斯的小怪随机掉落拉玛兰迪的命运，任何有此任务的都可以拾取。",
				followup = "拉玛兰迪的寒冰之握", -- 9230
				attain = 60,
				aim = "进入纳克萨玛斯的宫殿，找到拉玛兰迪的下落。",
				title = "拉玛兰迪的命运", -- 9229
				location = "科尔法克斯，圣光之勇士（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."82,58"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "纳克萨玛斯掉落的溶解之语可以从墙上得到冰冻符文。",
				followup = "无后续",
				attain = 60,
				aim = "东瘟疫之地圣光之愿礼拜堂的科尔法克斯要1个冰冻符文、1块蓝宝石和1块奥金锭。",
				title = "拉玛兰迪的寒冰之握", -- 9230
				location = "科尔法克斯，圣光之勇士（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."82,58"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "拉玛兰迪的寒冰之握", -- 9230
						id = 22707,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_35",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "拉玛兰迪的命运", -- 9229
			},
		},
		[2] = {
			[1] = {
				note = "英尼戈·蒙托尔神父（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,58"..WHITE.."）",
				followup = "无后续",
				attain = 60,
				aim = "将克尔苏加德的护符匣带往东瘟疫之地圣光之愿礼拜堂。",
				title = "克尔苏加德的末日", -- 9120
				location = "克尔苏加德（纳克萨玛斯; "..YELLOW.."绿色 2"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "勇士印记",
						id = 23206,
						subtext = "饰品",
						icon = "INV_Misc_Token_ArgentDawn2",
						quality = 4,
					},
					[2] = {
						name = "勇士印记",
						id = 23207,
						subtext = "饰品",
						icon = "INV_Misc_Token_ArgentDawn3",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "纳克萨玛斯掉落的溶解之语可以从墙上得到冰冻符文。",
				followup = "无后续",
				attain = 60,
				aim = "将2个冰冻符文、2个水之精华、2块蓝宝石和30金币交给东瘟疫之地圣光之愿礼拜堂的工匠威尔海姆。",
				title = "我只会唱这一首歌……", -- 9232
				location = "将2个冰冻符文、2个水之精华、2块蓝宝石和30金币交给东瘟疫之地圣光之愿礼拜堂的工匠威尔海姆。",
				level = 60,
				rewards = {
					[1] = {
						name = "冰川护腿",
						id = 22700,
						subtext = "腿部 布甲",
						icon = "INV_Pants_06",
						quality = 4,
					},
					[2] = {
						name = "破冰护腿",
						id = 22699,
						subtext = "腿部 板甲",
						icon = "INV_Pants_04",
						quality = 4,
					},
					[3] = {
						name = "寒鳞护腿",
						id = 22702,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_Mail_15",
						quality = 4,
					},
					[4] = {
						name = "北极护腿",
						id = 22701,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_Leather_21",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "需要杀死的怪物是各个不同的区的小怪。这个任务完成后才能制作 T3 套装。",
				followup = "无后续",
				attain = 60,
				aim = "东瘟疫之地圣光之愿礼拜堂的指挥官埃里戈尔·黎明使者要你杀死5个畸形妖、5只岩肤石像鬼、8个死亡骑士队长和3只毒性捕猎者。",
				title = "战争的回响", -- 9033
				location = "东瘟疫之地圣光之愿礼拜堂的指挥官埃里戈尔·黎明使者要你杀死5个畸形妖、5只岩肤石像鬼、8个死亡骑士队长和3只毒性捕猎者。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "恐怖之城，纳克萨玛斯", -- 9121 or 9122 or 9123
			},
			[4] = {
				note = "纳克萨玛斯的小怪随机掉落拉玛兰迪的命运，任何有此任务的都可以拾取。",
				followup = "拉玛兰迪的寒冰之握", -- 9230
				attain = 60,
				aim = "进入纳克萨玛斯的宫殿，找到拉玛兰迪的下落。",
				title = "拉玛兰迪的命运", -- 9229
				location = "科尔法克斯，圣光之勇士（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."82,58"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "纳克萨玛斯掉落的溶解之语可以从墙上得到冰冻符文。",
				followup = "无后续",
				attain = 60,
				aim = "东瘟疫之地圣光之愿礼拜堂的科尔法克斯要1个冰冻符文、1块蓝宝石和1块奥金锭。",
				title = "拉玛兰迪的寒冰之握", -- 9230
				location = "科尔法克斯，圣光之勇士（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."82,58"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "拉玛兰迪的寒冰之握", -- 9230
						id = 22707,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_35",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "拉玛兰迪的命运", -- 9229
			},
		},
	},
	[16] = {
		name = "奥妮克希亚的巢穴",
		story = "奥妮克希亚是强大之龙死亡之翼的女儿，也是黑石塔擅长阴谋的奈法利安大王的妹妹。据说奥妮克希亚喜欢借由干涉人类种族的政治来腐化他们。为达此目的他会变成各种人型生物形态，使用魔法和力量干预不同种族间的所有事情。有些人更认为奥妮克希亚使用父亲曾用过的化名——皇室普瑞斯托。若不插手凡人事务的时候，奥妮克希亚就在黑龙谷下的一处火焰洞穴居住，那是尘泥沼泽里的一个阴暗沼泽。阴险的黑龙军团剩余成员在此守护着她。",
		[1] = {
			[1] = {
				note = "当奥妮克希亚的生命值在10%到15%时，在她前面放置未淬火的上古之刃，她将为此淬火。当奥妮克希亚死亡，重新拾取任务物品，选择她的尸体并使用它后，就可以返回完成此任务。",
				followup = "无后续",
				attain = 60,
				aim = "你必须设法让奥妮克希亚对这把未淬火的上古之刃喷射火焰。完成之后，捡起加热过的上古之刃。你要注意的是，加热过的上古之刃不会一直保持被加热的状态，时间非常紧迫。",
				title = "煅造奎尔塞拉", -- 7508
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "煅造奎尔塞拉", -- 7508
						id = 18348,
						subtext = "剑",
						icon = "INV_Sword_01",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "弗洛尔的屠龙技术纲要（厄运之槌; "..YELLOW..""..WHITE.."） -> 铸造奎尔塞拉", -- 7507 -> 7508
			},
			[2] = {
				note = "伯瓦尔·弗塔根公爵在（暴风城 - 暴风要塞; "..YELLOW.."78,20"..WHITE.."）。只有在团队中的一人可以拾取此物品并且只可完成一次。\n\n下一步任务领取奖励。",
				followup = "英雄庆典", -- 7496
				attain = 60,
				aim = "将奥妮克希亚的头颅交给暴风城的伯瓦尔·弗塔根公爵。",
				title = "联盟的胜利", -- 7495
				location = "奥妮克希亚的头颅（奥妮克希亚掉落; "..YELLOW.."[3]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "奥妮克希亚龙血护符",
						id = 18406,
						subtext = "饰品",
						icon = "Spell_Shadow_LifeDrain",
						quality = 4,
					},
					[2] = {
						name = "屠龙者的徽记",
						id = 18403,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_27",
						quality = 4,
					},
					[3] = {
						name = "奥妮克希亚龙牙坠饰",
						id = 18404,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_09",
						quality = 4,
					},
				},
				prequest = "无前置",
			},
			[3] = {
				note = "只有一个人可以拾取. 龙语傻瓜教程 VI ; "..YELLOW.."[3]"..WHITE..")",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
				attain = 60,
				aim = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				title = "唯一的方案", -- 8620
				location = "纳瑞安 (塔纳利斯; "..YELLOW.."65,18"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "精神力量之侏儒头巾",
						id = 21517,
						subtext = "头部 布甲",
						icon = "INV_Helmet_63",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "螳螂捕蝉！", -- 8606
			},
		},
		[2] = {
			[1] = {
				note = "当奥妮克希亚的生命值在10%到15%时，在她前面放置未淬火的上古之刃，她将为此淬火。当奥妮克希亚死亡，重新拾取任务物品，选择她的尸体并使用它后，就可以返回完成此任务。",
				followup = "无后续",
				attain = 60,
				aim = "你必须设法让奥妮克希亚对这把未淬火的上古之刃喷射火焰。完成之后，捡起加热过的上古之刃。你要注意的是，加热过的上古之刃不会一直保持被加热的状态，时间非常紧迫。",
				title = "煅造奎尔塞拉", -- 7508
				location = "博学者莱德罗斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "煅造奎尔塞拉", -- 7508
						id = 18348,
						subtext = "剑",
						icon = "INV_Sword_01",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "弗洛尔的屠龙技术纲要（厄运之槌; "..YELLOW..""..WHITE.."） -> 铸造奎尔塞拉", -- 7507 -> 7508
			},
			[2] = {
				note = "萨尔在（奥格瑞玛 - 智慧谷; "..YELLOW.."31,37"..WHITE.."）。 只有在团队中的一人可以拾取此物品并且只可完成一次。\n\n下一步任务领取奖励。",
				followup = "万众敬仰", -- 7491
				attain = 60,
				aim = "将奥妮克希亚的头颅交给奥格瑞玛的萨尔。 ",
				title = "部落的胜利", -- 7490
				location = "奥妮克希亚的头颅（奥妮克希亚掉落; "..YELLOW.."[3]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "奥妮克希亚龙血护符",
						id = 18406,
						subtext = "饰品",
						icon = "Spell_Shadow_LifeDrain",
						quality = 4,
					},
					[2] = {
						name = "屠龙者的徽记",
						id = 18403,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_27",
						quality = 4,
					},
					[3] = {
						name = "奥妮克希亚龙牙坠饰",
						id = 18404,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_09",
						quality = 4,
					},
				},
				prequest = "无前置",
			},
			[3] = {
				note = "只有一个人可以拾取. 龙语傻瓜教程 VI ; "..YELLOW.."[3]"..WHITE..")",
				followup = "好消息和坏消息 (必须完成斯图沃尔，前任死党任务链 和 少管闲事任务链)",
				attain = 60,
				aim = "找回《龙语入门指南》的8个失落章节，并将它们与魔法书籍装订材料结合，然后将完成的《龙语入门指南》第二卷交给塔纳利斯的纳瑞安。",
				title = "唯一的方案", -- 8620
				location = "纳瑞安 (塔纳利斯; "..YELLOW.."65,18"..WHITE..")".."Draconic for Dummies (drops from Onyxia; "..YELLOW.."[3]"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "精神力量之侏儒头巾",
						id = 21517,
						subtext = "头部 布甲",
						icon = "INV_Helmet_63",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "螳螂捕蝉！", -- 8606
			},
		},
	},
	[17] = {
		name = "剃刀高地",
		story = "剃刀高地和剃刀沼泽一样由巨大的藤蔓组成，剃刀高地是野猪人的传统都城。在那错综复杂的荆棘迷宫中居住着大群忠诚的野猪人军队以及他们的高等牧师——亡首部族。然而最近，一股阴影力量笼罩了这个原始的洞穴。亡灵天灾的人在巫妖寒冰之王亚门纳尔的带领下控制了野猪部族并将荆棘迷宫变成了亡灵力量的堡垒。现在野猪人正奋力战斗来重新夺回他们的城市，并阻止亚门纳尔继续控制贫瘠之地。",
		[1] = {
			[1] = {
				note = "这些怪出现在你进入副本前经过的路上。",
				followup = "无后续",
				attain = 28,
				aim = "杀掉8个剃刀沼泽护卫者、8个剃刀沼泽织棘者和8个亡首教徒，然后向剃刀高地入口处的麦雷姆·月歌复命。",
				title = "邪恶之地", -- 6626
				location = "麦雷姆·月歌（贫瘠之地 - 剃刀高地; "..YELLOW.."49,94 "..WHITE.."）",
				level = 35,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你必须同意帮助奔尼斯特拉兹封印神像，封印过程中会刷新怪物攻击他，必须保证他的安全。完成后在神像面前获得奖励。",
				followup = "无后续",
				attain = 32,
				aim = "保护奔尼斯特拉兹来到剃刀高地的野猪人神像处。当他在进行仪式封印神像时保护他。",
				title = "封印神像", -- 3525
				location = "保护奔尼斯特拉兹来到剃刀高地的野猪人神像处。当他在进行仪式封印神像时保护他。",
				level = 37,
				rewards = {
					[1] = {
						name = "龙爪戒指",
						id = 10710,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_04",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "剃刀高地的亡灵天灾", -- 3523
			},
			[3] = {
				note = "寒冰之王亚门纳尔是剃刀高地的最后一个Boss。你可以在"..YELLOW.."[6]"..WHITE.."找到他。",
				followup = "无后续",
				attain = 39,
				aim = "大主教本尼迪塔斯要你去杀死剃刀高地的寒冰之王亚门纳尔。",
				title = "与圣光同在", -- 3636
				location = "大主教本尼迪塔斯（暴风城 - 光明大教堂; "..YELLOW.."39,27 "..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "征服者之剑",
						id = 10823,
						subtext = "单手 剑",
						icon = "INV_Sword_35",
						quality = 3,
					},
					[2] = {
						name = "琥珀之光",
						id = 10824,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_07",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "这些怪出现在你进入副本前经过的路上。",
				followup = "无后续",
				attain = 28,
				aim = "杀掉8个剃刀沼泽护卫者、8个剃刀沼泽织棘者和8个亡首教徒，然后向剃刀高地入口处的麦雷姆·月歌复命。",
				title = "邪恶之地", -- 6626
				location = "麦雷姆·月歌（贫瘠之地 - 剃刀高地; "..YELLOW.."49,94 "..WHITE.."）",
				level = 35,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "剃刀沼泽最后的Boss给出前导任务。玛克林大使位置在进入副本前外面的空地上（贫瘠之地 - 剃刀高地; "..YELLOW.."48,92"..WHITE.."）。",
				followup = "无后续",
				attain = 28,
				aim = "把玛克林大使的头颅带给幽暗城的瓦里玛萨斯。",
				title = "邪恶的盟友", -- 6521
				location = "瓦里玛萨斯（幽暗城 - 皇家区; "..YELLOW.."56,92 "..WHITE.."）",
				level = 36,
				rewards = {
					[1] = {
						name = "破颅者",
						id = 17039,
						subtext = "主手 锤",
						icon = "INV_Misc_Bone_DwarfSkull_01",
						quality = 2,
					},
					[2] = {
						name = "钉枪",
						id = 17042,
						subtext = "枪械",
						icon = "INV_Weapon_Rifle_01",
						quality = 2,
					},
					[3] = {
						name = "狂热长袍",
						id = 17043,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "邪恶的盟友", -- 6521
			},
			[3] = {
				note = "你必须同意帮助奔尼斯特拉兹封印神像，封印过程中会刷新怪物攻击他，必须保证他的安全。完成后在神像面前获得奖励。",
				followup = "无后续",
				attain = 32,
				aim = "保护奔尼斯特拉兹来到剃刀高地的野猪人神像处。当他在进行仪式封印神像时保护他。",
				title = "封印神像", -- 3525
				location = "保护奔尼斯特拉兹来到剃刀高地的野猪人神像处。当他在进行仪式封印神像时保护他。",
				level = 37,
				rewards = {
					[1] = {
						name = "龙爪戒指",
						id = 10710,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_04",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "剃刀高地的亡灵天灾", -- 3523
			},
			[4] = {
				note = "寒冰之王亚门纳尔是剃刀高地的最后一个Boss。你可以在"..YELLOW.."[6]"..WHITE.."找到他。",
				followup = "无后续",
				attain = 37,
				aim = "安德鲁·布隆奈尔要你杀了寒冰之王亚门纳尔并将其头骨带回来。",
				title = "寒冰之王", -- 3341
				location = "安德鲁·布隆奈尔（幽暗城 - 魔法区; "..YELLOW.."72,32 "..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "征服者之剑",
						id = 10823,
						subtext = "单手 剑",
						icon = "INV_Sword_35",
						quality = 3,
					},
					[2] = {
						name = "琥珀之光",
						id = 10824,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_07",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "任务线从黑暗主教莫德伦那里的任务“穿越至高魔法”开始。\n"..RED.."任务日志中的描述是错误的，至少对我来说是这样。"..WHITE.."\n寒冰之王亚门纳尔 "..YELLOW.."[6]"..WHITE.."掉落黑曜石魂灵瓮。\n完成任务链中的最后一个任务后，你将获得奖励。",
				followup = "格雷迈恩之石 "..YELLOW.."[吉尔尼斯城]"..WHITE.."-> 黑暗主教的礼物", -- 40996, 40997
				attain = 38,
				aim = "进入剃刀高地，击败寒冰之王亚门纳尔 "..YELLOW.."[6]"..WHITE.."，并为吉尔尼斯的斯蒂尔沃德教堂的黑暗主教莫德伦取回他的魂灵之瓮。",
				title = "(TW)5. 超越的力量", -- 40995
				location = "进入剃刀高地，击败寒冰之王亚门纳尔 "..YELLOW.."[6]"..WHITE.."，并为吉尔尼斯的斯蒂尔沃德教堂的黑暗主教莫德伦取回他的魂灵之瓮。",
				level = 44,
				rewards = {
					[1] = {
						name = "加拉隆之力", -- 61660
						id = 61660,
						subtext = "双手 剑",
						icon = "INV_Sword_13",
						quality = 3,
					},
					[2] = {
						name = "瓦里玛萨斯之诡", -- 61661
						id = 61661,
						subtext = "双手 法杖",
						icon = "INV_Staff_13",
						quality = 3,
					},
					[3] = {
						name = "静寂护符", -- 61662
						id = 61662,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "借助强大魔法 -> 鸦木权杖", -- 40993, 40994
			},
		},
	},
	[18] = {
		name = "剃刀沼泽最后的Boss给出前导任务。玛克林大使位置在进入副本前外面的空地上（贫瘠之地 - 剃刀高地; "..YELLOW.."48,92"..WHITE.."）。",
		story = "在一万年前的古代战争中，万能的半神阿迦玛甘和燃烧军团进行了激战。虽然这头巨大的猪在战斗中倒下了，但是他的努力最终拯救了艾泽拉斯大陆免遭涂炭。虽然已经过去了很久，但是在它血液流淌的地方巨大的荆棘藤蔓生长出来。那些被认为是半神后代的野猪人占领了这些地区并将其奉为圣地。这些荆棘地的中心被称为剃刀岭。而巨大的剃刀沼泽则被一个老丑婆卡尔加·刺肋所占据。在她的统治下，信奉萨满教的野猪人和别的部族以及部落为敌。有些人甚至猜测卡尔加还在和亡灵天灾的有来往——她想要联合亡灵天灾来达到一些不可告人的险恶目的。",
		[1] = {
			[1] = {
				note = "开孔的箱子，地鼠指挥棒和《地鼠指挥手册》都在麦伯克·米希瑞克斯附近不远的地方。",
				followup = "无后续",
				attain = 20,
				aim = "找到一个开孔的箱子。\n找到一根地鼠指挥棒。\n找到并阅读《地鼠指挥手册》。\n在剃刀沼泽里用开孔的箱子召唤一只地鼠，然后用指挥棒驱使它去搜寻蓝叶薯。\n把地鼠指挥棒、开孔的箱子和10块蓝叶薯交给棘齿城的麦伯克·米希瑞克斯。",
				title = "蓝叶薯", -- 1221
				location = "麦伯克·米希瑞克斯（贫瘠之地 - 棘齿城; "..YELLOW.."62,37"..WHITE.."）",
				level = 26,
				rewards = {
					[1] = {
						name = "一小袋宝石",
						id = 6755,
						subtext = "物品",
						icon = "INV_Misc_OrnateBox",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "坠饰随机掉落。你必须把坠饰带给塔莎拉·静水（达纳苏斯 - 贸易区; "..YELLOW.."69,67"..WHITE.."）。",
				followup = "无后续",
				attain = 25,
				aim = "将塔莎拉的坠饰带给达纳苏斯的塔莎拉·静水。",
				title = "临终遗言", -- 1142
				location = "赫尔拉斯·静水（剃刀沼泽; "..YELLOW.." [8]"..WHITE.."）",
				level = 30,
				rewards = {
					[1] = {
						name = "悲伤披风",
						id = 6751,
						subtext = "背部",
						icon = "INV_Misc_Cape_11",
						quality = 2,
					},
					[2] = {
						name = "枪骑兵战靴",
						id = 6752,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你必须把威利克斯护送到入口处。完成后向他领取奖励。",
				followup = "无后续",
				attain = 23,
				aim = "护送进口商威利克斯逃出剃刀沼泽。",
				title = "进口商威利克斯",
				location = "护送进口商威利克斯逃出剃刀沼泽。",
				level = 30,
				rewards = {
					[1] = {
						name = "猴子戒指",
						id = 6748,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_14",
						quality = 2,
					},
					[2] = {
						name = "蛇环",
						id = 6750,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_06",
						quality = 2,
					},
					[3] = {
						name = "猛虎指环",
						id = 6749,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "卡尔加·刺肋 "..YELLOW.."[7]"..WHITE.."掉落了完成这个任务所需的勋章。\n前置任务从亨里格的日记的日记开始，它在千针石林电梯旁边一个死亡的矮人的手中 "..YELLOW.."30.8,24.3"..WHITE.."。",
				followup = "无后续",
				attain = 29,
				aim = "把卡尔加·刺肋的徽章交给萨兰纳尔的法芬德尔。",
				title = "卡尔加·刺肋", -- 1101
				location = "法芬德尔（菲拉斯 - 萨兰纳尔; "..YELLOW.."89,46"..WHITE.."）",
				level = 34,
				rewards = {
					[1] = {
						name = "绿宝石护肩",
						id = 4197,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_05",
						quality = 3,
					},
					[2] = {
						name = "石拳束带",
						id = 6742,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_35",
						quality = 3,
					},
					[3] = {
						name = "石饰圆盾",
						id = 6725,
						subtext = "盾牌",
						icon = "INV_Shield_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "卡尔加·刺肋 "..YELLOW.."[7]"..WHITE.."掉落了完成这个任务所需的勋章。\n前置任务从亨里格的日记的日记开始，它在千针石林电梯旁边一个死亡的矮人的手中 "..YELLOW.."30.8,24.3"..WHITE.."。",
			},
			[5] = {
				note = "只有战士才能接到这个任务！\n你可以从鲁古格"..YELLOW.."[1]"..WHITE.."得到燃素。\n\n湿地的蜘蛛掉落烧焦的蜘蛛牙，石爪山脉的奇美幼崽拉掉落烧焦的奇美拉角、雌奇美拉掉落光滑的奇美拉角。",
				followup = "（请见注释）",
				attain = 20,
				aim = "收集必需的材料，将它们交给暴风城的弗伦·长须。",
				title = "弗伦的铠甲（战士任务）", -- 1701
				location = "弗伦·长须（暴风城 - 矮人区; "..YELLOW.."57,16"..WHITE.."）",
				level = 28,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "铸盾师", -- 1702
			},
		},
		[2] = {
			[1] = {
				note = "开孔的箱子，地鼠指挥棒和《地鼠指挥手册》都在麦伯克·米希瑞克斯附近不远的地方。",
				followup = "无后续",
				attain = 20,
				aim = "找到一个开孔的箱子。\n找到一根地鼠指挥棒。\n找到并阅读《地鼠指挥手册》。\n在剃刀沼泽里用开孔的箱子召唤一只地鼠，然后用指挥棒驱使它去搜寻蓝叶薯。\n把地鼠指挥棒、开孔的箱子和10块蓝叶薯交给棘齿城的麦伯克·米希瑞克斯。",
				title = "蓝叶薯", -- 1221
				location = "麦伯克·米希瑞克斯（贫瘠之地 - 棘齿城; "..YELLOW.."62,37"..WHITE.."）",
				level = 26,
				rewards = {
					[1] = {
						name = "一小袋宝石",
						id = 6755,
						subtext = "物品",
						icon = "INV_Misc_OrnateBox",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你必须把威利克斯护送到入口处。完成后向他领取奖励。",
				followup = "无后续",
				attain = 23,
				aim = "护送进口商威利克斯逃出剃刀沼泽。",
				title = "进口商威利克斯",
				location = "护送进口商威利克斯逃出剃刀沼泽。",
				level = 30,
				rewards = {
					[1] = {
						name = "猴子戒指",
						id = 6748,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_14",
						quality = 2,
					},
					[2] = {
						name = "蛇环",
						id = 6750,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_06",
						quality = 2,
					},
					[3] = {
						name = "猛虎指环",
						id = 6749,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "任何蝙蝠都会掉落沼泽蝙蝠的粪便。",
				followup = "狂热之心（"..YELLOW.."[剃刀高地]"..WHITE.."）", -- 1113
				attain = 30,
				aim = "帮幽暗城的大药剂师法拉尼尔带回一堆沼泽蝙蝠的粪便。",
				title = "蝙蝠的粪便", -- 1109
				location = "法拉尼尔（幽暗城 - 炼金房; "..YELLOW.."48,69 "..WHITE.."）",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "卡尔加·刺肋在"..YELLOW.."[7]"..WHITE.."、",
				followup = "无后续",
				attain = 29,
				aim = "把卡尔加·刺肋的心脏交给雷霆崖的奥尔德·石塔。",
				title = "奥尔德的报复", -- 1102
				location = "奥尔德·石塔（雷霆崖; "..YELLOW.."36,59 "..WHITE.."）",
				level = 34,
				rewards = {
					[1] = {
						name = "绿宝石护肩",
						id = 4197,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_05",
						quality = 3,
					},
					[2] = {
						name = "石拳束带",
						id = 6742,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_35",
						quality = 3,
					},
					[3] = {
						name = "石饰圆盾",
						id = 6725,
						subtext = "盾牌",
						icon = "INV_Shield_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "只有战士才能接到这个任务！\n你可以从鲁古格"..YELLOW.."[1]"..WHITE.."得到燃素。\n\n完成这个任务后他会给你一个新的任务。",
				followup = "（请见注释）",
				attain = 20,
				aim = "为索恩格瑞姆收集15根烟雾铁锭、10份蓝铜粉、10块铁锭和1瓶燃素。",
				title = "野蛮护甲（战士任务）", -- 1838
				location = "索恩格瑞姆·火眼（贫瘠之地; "..YELLOW.."57,30 "..WHITE.."）",
				level = 30,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "和索恩格瑞姆交谈", -- 1825
			},
		},
	},
	[19] = {
		name = "奖励盗贼的职业饰品。把书交给博学者基尔达斯（厄运之槌; "..YELLOW.."西，"..GREEN.."图书馆[1\']"..WHITE.."）。",
		story = "血色修道院曾经是洛丹伦王国牧师的荣耀之地——那里是学习圣光只是和膜拜的中心。随着在第三次大战中亡灵天灾的崛起，宁静的修道院成为了疯狂的血色十字军的要塞。十字军对于所有非人类都有着偏激的态度，无论他们是自己的盟友还是对手。他们相信所有任何外来者都带着亡灵的瘟疫——他们必须被摧毁。有报告说所有进入修道院的冒险者都要面对血色十字军指挥官莫格莱尼——他控制了一群狂热的十字军战士。然而，修道院的真正主人是大检察官怀特迈恩——一个疯狂的牧师，她具有复活死去的战士来为其效劳的能力。",
		[1] = {
			[1] = {
				note = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				followup = "无后续",
				attain = 34,
				aim = "杀死大检察官怀特迈恩，血色十字军指挥官莫格莱尼，十字军的勇士赫洛德和驯犬者洛克希并向南海镇的莱雷恩复命。",
				title = "以圣光之名", -- 1053
				location = "虔诚的莱雷恩（希尔斯布莱德丘陵 - 南海镇; "..YELLOW.."51,58 "..WHITE.."）",
				level = 40,
				rewards = {
					[1] = {
						name = "平静之剑",
						id = 6829,
						subtext = "单手 剑",
						icon = "INV_Sword_27",
						quality = 3,
					},
					[2] = {
						name = "咬骨之斧",
						id = 6830,
						subtext = "双手 斧",
						icon = "INV_Axe_04",
						quality = 3,
					},
					[3] = {
						name = "黑暗威胁",
						id = 6831,
						subtext = "单手 匕首",
						icon = "INV_Sword_13",
						quality = 3,
					},
					[4] = {
						name = "洛瑞卡宝珠",
						id = 11262,
						subtext = "副手",
						icon = "INV_Misc_Orb_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "安东修士 -> 血色之路", -- 6141 -> 1052
			},
			[2] = {
				note = "你可以在血色修道院的图书馆奥法师杜安之前左侧一个走廊的地板上（"..YELLOW.."[2]"..WHITE.."）找到这本书。",
				followup = "无后续",
				attain = 28,
				aim = "从修道院拿回《泰坦神话》，把它交给铁炉堡的图书馆员麦伊·苍尘。",
				title = "泰坦神话", -- 1050
				location = "图书馆员麦伊·苍尘（铁炉堡 - 探险者大厅; "..YELLOW.."74,12 "..WHITE.."）",
				level = 38,
				rewards = {
					[1] = {
						name = "探险者协会的奖状",
						id = 7746,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "法师职业任务，你可以在血色修道院的图书馆奥法师杜安之前左侧一个走廊的地板上（"..YELLOW.."[2]"..WHITE.."）找到这本书。",
				followup = "法师的魔杖", -- 1952
				attain = 30,
				aim = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				title = "能量仪祭（法师任务）", -- 1951
				location = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				level = 40,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "解封咒语", -- 1950
			},
		},
		[2] = {
			[1] = {
				note = "血色所有的怪物均会掉落。",
				followup = "无后续",
				attain = 30,
				aim = "幽暗城的大药剂师法拉尼尔需要20颗狂热之心。",
				title = "狂热之心（"..YELLOW.."[剃刀高地]"..WHITE.."）", -- 1113
				location = "法拉尼尔（幽暗城 - 炼金房; "..YELLOW.."48,69 "..WHITE.."）",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "蝙蝠的粪便（"..YELLOW.."[剃刀沼泽]"..WHITE.."）", -- 1109
			},
			[2] = {
				note = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				followup = "无后续",
				attain = 33,
				aim = "杀掉大检察官怀特迈恩、血色十字军指挥官莫格莱尼、血色十字军勇士赫洛德和驯犬者洛克希，然后向幽暗城的瓦里玛萨斯回报。",
				title = "深入血色修道院", -- 1048
				location = "瓦里玛萨斯（幽暗城 - 皇家区; "..YELLOW.."56,92 "..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "预兆之剑",
						id = 6802,
						subtext = "单手 剑",
						icon = "INV_Sword_19",
						quality = 3,
					},
					[2] = {
						name = "预言藤杖",
						id = 6803,
						subtext = "副手",
						icon = "INV_Staff_01",
						quality = 3,
					},
					[3] = {
						name = "龙血项链",
						id = 10711,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在血色图书馆里找到这这本书。",
				followup = "无后续",
				attain = 28,
				aim = "从提瑞斯法林地血色修道院里找到《堕落者纲要》，把它交给雷霆崖的圣者图希克。",
				title = "堕落者纲要", -- 1049
				location = "圣者图希克（雷霆崖; "..YELLOW.."34,47"..WHITE.."）",
				level = 38,
				rewards = {
					[1] = {
						name = "邪恶防护者",
						id = 7747,
						subtext = "盾牌",
						icon = "INV_Shield_02",
						quality = 2,
					},
					[2] = {
						name = "力石圆盾",
						id = 17508,
						subtext = "盾牌",
						icon = "INV_Shield_02",
						quality = 2,
					},
					[3] = {
						name = "终结宝珠",
						id = 7749,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "此系列任务始于多恩·平原行者（千针石林; "..YELLOW.."53,41"..WHITE.."）。\n书在血色修道院图书馆里。",
				followup = "知识试炼", -- 1160
				attain = 25,
				aim = "找到《亡灵的起源》，把它交给幽暗城的帕科瓦·芬塔拉斯。",
				title = "知识试炼", -- 1160
				location = "帕科瓦·芬塔拉斯（幽暗城 - 炼金房; "..YELLOW.."57,65 "..WHITE.."）",
				level = 36,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "信仰的试炼 -> 耐力的试炼 -> 力量的试炼", -- 1149 -> 1159
			},
			[5] = {
				note = "法师职业任务，你可以在血色修道院的图书馆奥法师杜安之前左侧一个走廊的地板上（"..YELLOW.."[2]"..WHITE.."）找到这本书。",
				followup = "法师的魔杖", -- 1952
				attain = 30,
				aim = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				title = "能量仪祭（法师任务）", -- 1951
				location = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				level = 40,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "解封咒语", -- 1950
			},
		},
	},
	[20] = {
		name = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
		story = "血色修道院曾经是洛丹伦王国牧师的荣耀之地——那里是学习圣光只是和膜拜的中心。随着在第三次大战中亡灵天灾的崛起，宁静的修道院成为了疯狂的血色十字军的要塞。十字军对于所有非人类都有着偏激的态度，无论他们是自己的盟友还是对手。他们相信所有任何外来者都带着亡灵的瘟疫——他们必须被摧毁。有报告说所有进入修道院的冒险者都要面对血色十字军指挥官莫格莱尼——他控制了一群狂热的十字军战士。然而，修道院的真正主人是大检察官怀特迈恩——一个疯狂的牧师，她具有复活死去的战士来为其效劳的能力。",
		[1] = {
			[1] = {
				note = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				followup = "无后续",
				attain = 34,
				aim = "杀死大检察官怀特迈恩，血色十字军指挥官莫格莱尼，十字军的勇士赫洛德和驯犬者洛克希并向南海镇的莱雷恩复命。",
				title = "以圣光之名", -- 1053
				location = "虔诚的莱雷恩（希尔斯布莱德丘陵 - 南海镇; "..YELLOW.."51,58 "..WHITE.."）",
				level = 40,
				rewards = {
					[1] = {
						name = "平静之剑",
						id = 6829,
						subtext = "单手 剑",
						icon = "INV_Sword_27",
						quality = 3,
					},
					[2] = {
						name = "咬骨之斧",
						id = 6830,
						subtext = "双手 斧",
						icon = "INV_Axe_04",
						quality = 3,
					},
					[3] = {
						name = "黑暗威胁",
						id = 6831,
						subtext = "单手 匕首",
						icon = "INV_Sword_13",
						quality = 3,
					},
					[4] = {
						name = "洛瑞卡宝珠",
						id = 11262,
						subtext = "副手",
						icon = "INV_Misc_Orb_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "安东修士 -> 血色之路", -- 6141 -> 1052
			},
		},
		[2] = {
			[1] = {
				note = "血色所有的怪物均会掉落。",
				followup = "无后续",
				attain = 30,
				aim = "幽暗城的大药剂师法拉尼尔需要20颗狂热之心。",
				title = "狂热之心（"..YELLOW.."[剃刀高地]"..WHITE.."）", -- 1113
				location = "法拉尼尔（幽暗城 - 炼金房; "..YELLOW.."48,69 "..WHITE.."）",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "蝙蝠的粪便（"..YELLOW.."[剃刀沼泽]"..WHITE.."）", -- 1109
			},
			[2] = {
				note = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				followup = "无后续",
				attain = 33,
				aim = "杀掉大检察官怀特迈恩、血色十字军指挥官莫格莱尼、血色十字军勇士赫洛德和驯犬者洛克希，然后向幽暗城的瓦里玛萨斯回报。",
				title = "深入血色修道院", -- 1048
				location = "瓦里玛萨斯（幽暗城 - 皇家区; "..YELLOW.."56,92 "..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "预兆之剑",
						id = 6802,
						subtext = "单手 剑",
						icon = "INV_Sword_19",
						quality = 3,
					},
					[2] = {
						name = "预言藤杖",
						id = 6803,
						subtext = "副手",
						icon = "INV_Staff_01",
						quality = 3,
					},
					[3] = {
						name = "龙血项链",
						id = 10711,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
		},
	},
	[21] = {
		name = "大主教本尼迪塔斯（暴风城 - 光明大教堂; "..YELLOW.."39,27 "..WHITE.."）",
		story = "血色修道院曾经是洛丹伦王国牧师的荣耀之地——那里是学习圣光只是和膜拜的中心。随着在第三次大战中亡灵天灾的崛起，宁静的修道院成为了疯狂的血色十字军的要塞。十字军对于所有非人类都有着偏激的态度，无论他们是自己的盟友还是对手。他们相信所有任何外来者都带着亡灵的瘟疫——他们必须被摧毁。有报告说所有进入修道院的冒险者都要面对血色十字军指挥官莫格莱尼——他控制了一群狂热的十字军战士。然而，修道院的真正主人是大检察官怀特迈恩——一个疯狂的牧师，她具有复活死去的战士来为其效劳的能力。",
		[1] = {
			[1] = {
				note = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				followup = "无后续",
				attain = 34,
				aim = "杀死大检察官怀特迈恩，血色十字军指挥官莫格莱尼，十字军的勇士赫洛德和驯犬者洛克希并向南海镇的莱雷恩复命。",
				title = "以圣光之名", -- 1053
				location = "虔诚的莱雷恩（希尔斯布莱德丘陵 - 南海镇; "..YELLOW.."51,58 "..WHITE.."）",
				level = 40,
				rewards = {
					[1] = {
						name = "平静之剑",
						id = 6829,
						subtext = "单手 剑",
						icon = "INV_Sword_27",
						quality = 3,
					},
					[2] = {
						name = "咬骨之斧",
						id = 6830,
						subtext = "双手 斧",
						icon = "INV_Axe_04",
						quality = 3,
					},
					[3] = {
						name = "黑暗威胁",
						id = 6831,
						subtext = "单手 匕首",
						icon = "INV_Sword_13",
						quality = 3,
					},
					[4] = {
						name = "洛瑞卡宝珠",
						id = 11262,
						subtext = "副手",
						icon = "INV_Misc_Orb_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "安东修士 -> 血色之路", -- 6141 -> 1052
			},
			[2] = {
				note = "你可以在第二个房间里找到卡拉杜斯之球，位于"..YELLOW.."[2]"..WHITE.."的左边。",
				followup = "无后续",
				attain = 30,
				aim = "进入血色修道院，找到卡拉杜斯之球，取回它，然后回到哀伤卫队的守望圣骑士贾纳索斯那里。",
				title = "(TW)2. 卡拉杜斯之球", --40233
				location = "守望圣骑士贾纳索斯（悲伤沼泽西部 - 哀伤卫队）",
				level = 38,
				rewards = {
					[1] = {
						name = "真相守护者披风", --60316
						id = 60316,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_28",
						quality = 3,
					},
					[2] = {
						name = "光荣之槌", --60317
						id = 60317,
						subtext = "主手 锤",
						icon = "INV_Mace_06",
						quality = 3,
					},
					[3] = {
						name = "哀伤卫队护符", --60318
						id = 60318,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_11",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "过去的故事 -> 被遗忘的卷轴 -> 回到贾纳索斯那里",
			},
			[3] = {
				note = "",
				followup = "无后续",
				attain = 35,
				aim = "为修士埃利亚斯在吉尔尼斯-格雷希尔废墟的沙德摩尔旅店调查高级审判官法尔班克斯的死亡真相 "..YELLOW.."[1]"..WHITE.."。已被杀的高级审判官法尔班克斯",
				title = "(TW)3. 血色的堕落", --40935
				location = "修士埃利亚斯 <血色十字军使者>（吉尔尼斯 - 格雷希尔废墟 - 沙德摩尔旅店 "..YELLOW.."[33.6,54.1]"..WHITE.."，2楼）",
				level = 44,
				rewards = {
					[1] = {
						name = "神圣契约之戒", --61478
						id = 61478,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_23",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "对抗亡灵的盟友", --40934
			},
		},
		[2] = {
			[1] = {
				note = "血色所有的怪物均会掉落。",
				followup = "无后续",
				attain = 30,
				aim = "幽暗城的大药剂师法拉尼尔需要20颗狂热之心。",
				title = "狂热之心（"..YELLOW.."[剃刀高地]"..WHITE.."）", -- 1113
				location = "法拉尼尔（幽暗城 - 炼金房; "..YELLOW.."48,69 "..WHITE.."）",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "蝙蝠的粪便（"..YELLOW.."[剃刀沼泽]"..WHITE.."）", -- 1109
			},
			[2] = {
				note = "此系列任务始于克罗雷修士（暴风城 - 光明大教堂; "..YELLOW.."42,24"..WHITE.."）。\n大检察官怀特迈恩和血色十字军指挥官莫格莱尼在血色修道院"..YELLOW.."教堂[2]"..WHITE.."，赫洛德在血色修道院"..YELLOW.."军械库[1]"..WHITE.."，驯犬者洛克希在血色修道院"..YELLOW.."图书馆[1]"..WHITE.."。",
				followup = "无后续",
				attain = 33,
				aim = "杀掉大检察官怀特迈恩、血色十字军指挥官莫格莱尼、血色十字军勇士赫洛德和驯犬者洛克希，然后向幽暗城的瓦里玛萨斯回报。",
				title = "深入血色修道院", -- 1048
				location = "瓦里玛萨斯（幽暗城 - 皇家区; "..YELLOW.."56,92 "..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "预兆之剑",
						id = 6802,
						subtext = "单手 剑",
						icon = "INV_Sword_19",
						quality = 3,
					},
					[2] = {
						name = "预言藤杖",
						id = 6803,
						subtext = "副手",
						icon = "INV_Staff_01",
						quality = 3,
					},
					[3] = {
						name = "龙血项链",
						id = 10711,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
		},
	},
	[22] = {
		name = "血色修道院（墓地）",
		story = "血色修道院曾经是洛丹伦王国牧师的荣耀之地——那里是学习圣光只是和膜拜的中心。随着在第三次大战中亡灵天灾的崛起，宁静的修道院成为了疯狂的血色十字军的要塞。十字军对于所有非人类都有着偏激的态度，无论他们是自己的盟友还是对手。他们相信所有任何外来者都带着亡灵的瘟疫——他们必须被摧毁。有报告说所有进入修道院的冒险者都要面对血色十字军指挥官莫格莱尼——他控制了一群狂热的十字军战士。然而，修道院的真正主人是大检察官怀特迈恩——一个疯狂的牧师，她具有复活死去的战士来为其效劳的能力。",
		[1] = {
		},
		[2] = {
			[1] = {
				note = "血色所有的怪物均会掉落。",
				followup = "无后续",
				attain = 30,
				aim = "幽暗城的大药剂师法拉尼尔需要20颗狂热之心。",
				title = "狂热之心（"..YELLOW.."[剃刀高地]"..WHITE.."）", -- 1113
				location = "法拉尼尔（幽暗城 - 炼金房; "..YELLOW.."48,69 "..WHITE.."）",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "蝙蝠的粪便（"..YELLOW.."[剃刀沼泽]"..WHITE.."）", -- 1109
			},
			[2] = {
				note = "你可以在血色修道院墓地部分开始找沃瑞尔·森加斯. 南希·韦沙斯, 谁掉了这个任务需要的戒指？, 可以在奥特兰克山脉的一个房子里 ("..YELLOW.."31,32"..WHITE..").",
				followup = "无后续",
				attain = 25,
				aim = "沃瑞尔·森加斯的结婚戒指，沃瑞尔·森加斯在塔伦米尔",
				title = "沃瑞尔的复仇", --1051
				location = "沃瑞尔·森加斯 (血色修道院-墓地; "..YELLOW.."[1]"..WHITE..")",
				level = 33,
				rewards = {
					[1] = {
						name = "沃瑞尔的靴子",
						id = 7751,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_03",
						quality = 2,
					},
					[2] = {
						name = "悲哀衬肩",
						id = 7750,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_23",
						quality = 2,
					},
					[3] = {
						name = "十字军斗篷",
						id = 4643,
						subtext = "背部",
						icon = "INV_Misc_Cape_02",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在外面完成这个任务。\n任务线从幽暗城的旅店老板诺曼 <旅店老板> 那里开始，接任务“愤怒的血色”。",
				followup = "无后续",
				attain = 27,
				aim = "消灭血色修道院外的血色军队，然后回到布瑞尔的死亡卫兵伯吉斯那里。\n击败血色侦察兵（5）\n击败血色保卫者（5）\n击败血色哨兵（10）",
				title = "(TW)3. 鲜血之路", --60116 --60116
				location = "死亡卫兵伯吉斯（提瑞斯法林地 - 布瑞尔；"..YELLOW.."61,52"..WHITE.."）",
				level = 29,
				rewards = {
					[1] = {
						name = "纳斯雷兹姆楔", --51832
						id = 51832,
						subtext = "主手 斧",
						icon = "INV_Axe_13",
						quality = 3,
					},
					[2] = {
						name = "骨髓法杖", --51833
						id = 51833,
						subtext = "双手 法杖",
						icon = "INV_Staff_22",
						quality = 3,
					},
					[3] = {
						name = "血色柱", --51834
						id = 51834,
						subtext = "双手 锤",
						icon = "INV_Hammer_07",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "你可以在外面完成这个任务。\n任务线从幽暗城的旅店老板诺曼 <旅店老板> 那里开始，接任务“愤怒的血色”。",
			},
		},
	},
	[23] = {
		name = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
		story = "通灵学院位于凯尔达隆废弃的城堡中的地下室中。那里曾经是高贵的巴罗夫家族的，但是在第二次大战中凯尔达隆变成了一块废墟。法师克尔苏加德经常向他的诅咒神教信徒承诺可以用对于巫妖王的效忠来换取永恒的生命。巴罗克家族受到克尔苏加德的魅惑而将城堡和其地下室献给了亡灵天灾。那些信徒然后将巴罗夫家族的人杀死并把地下室变成了通灵学院。虽然克尔苏加德不再住在这个地下室中，但是狂热的信徒和讲师都还留在那里。强大的巫妖，莱斯·霜语以亡灵天灾的名义控制了这里——而凡人亡灵巫师黑暗院长加丁则是这个学校邪恶的校长。",
		[1] = {
			[1] = {
				note = "瘟疫之龙在尸骨储藏所，去往血骨傀儡的大房间。",
				followup = "健康的龙鳞", -- 5582
				attain = 55,
				aim = "杀掉20只瘟疫龙崽，然后向圣光之愿礼拜堂的贝蒂娜·比格辛克复命。",
				title = "瘟疫之龙", -- 5529
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "瘟疫龙崽掉落健康的龙鳞（8% 掉率）。贝蒂娜·比格辛克在（东瘟疫之地 - 圣光之愿礼拜堂;"..YELLOW.."81,59"..WHITE.."）。",
				followup = "无后续",
				attain = 55,
				aim = "把健康的龙鳞交给东瘟疫之地圣光之愿礼拜堂中的贝蒂娜·比格辛克。",
				title = "健康的龙鳞", -- 5582
				location = "健康的龙鳞（通灵学院瘟疫龙崽掉落）",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "瘟疫之龙", -- 5529
			},
			[3] = {
				note = "你可以在"..YELLOW.."[9]"..WHITE.."找到瑟尔林·卡斯迪诺夫教授。",
				followup = "卡斯迪诺夫的恐惧之袋", -- 5515
				attain = 55,
				aim = "在通灵学院中找到瑟尔林·卡斯迪诺夫教授。杀死他，并烧毁艾瓦·萨克霍夫和卢森·萨克霍夫的遗体。任务完成后就回到艾瓦·萨克霍夫那儿。",
				title = "瑟尔林·卡斯迪诺夫教授", -- 5382
				location = "艾瓦·萨克霍夫（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "你可以在"..YELLOW.."[3]"..WHITE.."詹迪斯·巴罗夫。",
				followup = "传令官基尔图诺斯", -- 5384
				attain = 55,
				aim = "在通灵学院找到詹迪斯·巴罗夫并打败她。从她的尸体上找到卡斯迪诺夫的恐惧之袋，然后将其交给艾瓦·萨克霍夫。",
				title = "卡斯迪诺夫的恐惧之袋", -- 5515
				location = "艾瓦·萨克霍夫（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "瑟尔林·卡斯迪诺夫教授", -- 5382
			},
			[5] = {
				note = "带着无辜者之血回到通灵学院，将它放在门廊的火盆下面，基尔图诺斯会前来吞噬你的灵魂。勇敢地战斗吧，不要退缩！杀死基尔图诺斯，然后回到艾瓦·萨克霍夫那儿。",
				followup = "莱斯·霜语", -- 5461
				attain = 55,
				aim = "带着无辜者之血回到通灵学院，将它放在门廊的火盆下面，基尔图诺斯会前来吞噬你的灵魂。勇敢地战斗吧，不要退缩！杀死基尔图诺斯，然后回到艾瓦·萨克霍夫那儿。",
				title = "传令官基尔图诺斯", -- 5384
				location = "艾瓦·萨克霍夫（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "鬼灵精华",
						id = 13544,
						subtext = "饰品",
						icon = "INV_Misc_Orb_05",
						quality = 2,
					},
					[2] = {
						name = "波尼的玫瑰",
						id = 15805,
						subtext = "副手",
						icon = "INV_Misc_Flower_04",
						quality = 3,
					},
					[3] = {
						name = "米拉之歌",
						id = 15806,
						subtext = "单手 剑",
						icon = "INV_Sword_34",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "卡斯迪诺夫的恐惧之袋", -- 5515
			},
			[6] = {
				note = "你可以在"..YELLOW.."[7]"..WHITE.."找到莱斯·霜语。",
				followup = "无后续",
				attain = 57,
				aim = "在通灵学院里找到莱斯·霜语。当你找到他之后，使用禁锢灵魂的遗物破除其亡灵的外壳。如果你成功地破除了他的不死之身，就杀掉他并拿到莱斯·霜语的头颅。把那个头颅交给马杜克镇长。",
				title = "巫妖莱斯·霜语", -- 5466
				location = "马杜克镇长（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "达隆郡之盾",
						id = 14002,
						subtext = "盾牌",
						icon = "INV_Shield_05",
						quality = 3,
					},
					[2] = {
						name = "凯尔达隆战剑",
						id = 13982,
						subtext = "双手 剑",
						icon = "INV_Sword_39",
						quality = 3,
					},
					[3] = {
						name = "凯尔达隆之冠",
						id = 13986,
						subtext = "头部 布甲",
						icon = "INV_Crown_01",
						quality = 3,
					},
					[4] = {
						name = "达隆郡之刺",
						id = 13984,
						subtext = "单手 匕首",
						icon = "INV_Weapon_ShortBlade_21",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "在通灵学院里找到莱斯·霜语。当你找到他之后，使用禁锢灵魂的遗物破除其亡灵的外壳。如果你成功地破除了他的不死之身，就杀掉他并拿到莱斯·霜语的头颅。把那个头颅交给马杜克镇长。",
			},
			[7] = {
				note = "你可以在"..YELLOW.."[12]"..WHITE.."找到凯尔达隆地契，在"..YELLOW.."[7]"..WHITE.."找到布瑞尔地契，在"..YELLOW.."[4]"..WHITE.."找到塔伦米尔地契，在"..YELLOW.."[1]"..WHITE.."找到南海镇地契。",
				followup = "巴罗夫的继承人\n（去亡灵壁垒暗杀阿莱克斯·巴罗夫。把他的脑袋交给维尔顿·巴罗夫。）", -- 5344
				attain = 52,
				aim = "到通灵学院中去取得巴罗夫家族的宝藏。这份宝藏包括四份地契：凯尔达隆地契、布瑞尔地契、塔伦米尔地契，还有南海镇地契。完成任务之后就回到维尔顿·巴罗夫那儿去。",
				title = "巴罗夫家族的宝藏", -- 5343
				location = "维尔顿·巴罗夫（西瘟疫之地 - 寒风营地; "..YELLOW.."43,83"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "雏龙精华开始于丁奇·斯迪波尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）。 观察室在"..YELLOW.."[6]"..WHITE.."。",
				followup = "无后续",
				attain = 57,
				aim = "将黎明先锋放在通灵学院的观察室里。打败维克图斯,然后回到贝蒂娜·比格辛克那里去。",
				title = "黎明先锋", -- 4771
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "断风者",
						id = 15853,
						subtext = "单手，斧",
						icon = "INV_Axe_08",
						quality = 3,
					},
					[2] = {
						name = "舞动之藤",
						id = 15854,
						subtext = "法杖",
						icon = "INV_Staff_07",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "雏龙精华 - > 贝蒂娜·比格辛克", -- 4726 -> 5531
			},
			[9] = {
				note = "只有术士才能得到这个任务！你可以在"..YELLOW.."[7]"..WHITE.."找到炼金实验室。",
				followup = "克索诺斯恐惧战马", -- 7631
				attain = 60,
				aim = "把瓶中的小鬼带到通灵学院的炼金实验室中。在小鬼制造出羊皮纸之后，把瓶子还给戈瑟奇·邪眼。",
				title = "末日蜡烛（"..YELLOW.."通灵学院"..WHITE.."）", -- 7629
				location = "戈瑟奇·邪眼（燃烧平原; "..YELLOW.."12,31"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "莫苏尔·召血者 - > 克索诺斯星尘", -- 7562 -> 7625
			},
			[10] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出库尔莫克的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[11] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "使用召唤火盆召唤出库尔莫克的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷.",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[12] = {
				note = "任务线从工匠威廉姆（东瘟疫之地 - 圣光之愿礼拜堂）那里开始，接任务“新的符文前线”。\n!!! 完成任务线的最后一个任务后，你将获得这个奖励。",
				followup = "与恐惧魔王会面", --40238
				attain = 55,
				aim = "进入通灵学院，为拉塔基特的斯特拉哈德·法尔萨恩找回书籍《火焰的召唤与命令》。",
				title = "(TW)12. 帮法尔桑的忙。", -- 40237
				location = "斯特拉哈德·法尔萨恩（贫瘠之地 - 棘齿城；"..YELLOW.."62.6,35.5"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "淬火符文剑", --81060
						id = 81060,
						subtext = "双手 剑",
						icon = "INV_Sword_02",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "新的符文前线 -> 黑铁锻造的秘密 -> 黑铁锻造的秘密", -- 40234, 40235, 40236
			},
		},
		[2] = {
			[1] = {
				note = "瘟疫之龙在尸骨储藏所，去往血骨傀儡的大房间。",
				followup = "健康的龙鳞", -- 5582
				attain = 55,
				aim = "杀掉20只瘟疫龙崽，然后向圣光之愿礼拜堂的贝蒂娜·比格辛克复命。",
				title = "瘟疫之龙", -- 5529
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "瘟疫龙崽掉落健康的龙鳞（8% 掉率）。贝蒂娜·比格辛克在（东瘟疫之地 - 圣光之愿礼拜堂;"..YELLOW.."81,59"..WHITE.."）。",
				followup = "无后续",
				attain = 55,
				aim = "把健康的龙鳞交给东瘟疫之地圣光之愿礼拜堂中的贝蒂娜·比格辛克。",
				title = "健康的龙鳞", -- 5582
				location = "健康的龙鳞（通灵学院瘟疫龙崽掉落）",
				level = 58,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "瘟疫之龙", -- 5529
			},
			[3] = {
				note = "你可以在"..YELLOW.."[9]"..WHITE.."找到瑟尔林·卡斯迪诺夫教授。",
				followup = "卡斯迪诺夫的恐惧之袋", -- 5515
				attain = 55,
				aim = "在通灵学院中找到瑟尔林·卡斯迪诺夫教授。杀死他，并烧毁艾瓦·萨克霍夫和卢森·萨克霍夫的遗体。任务完成后就回到艾瓦·萨克霍夫那儿。",
				title = "瑟尔林·卡斯迪诺夫教授", -- 5382
				location = "艾瓦·萨克霍夫（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "你可以在"..YELLOW.."[3]"..WHITE.."詹迪斯·巴罗夫。",
				followup = "传令官基尔图诺斯", -- 5384
				attain = 55,
				aim = "在通灵学院找到詹迪斯·巴罗夫并打败她。从她的尸体上找到卡斯迪诺夫的恐惧之袋，然后将其交给艾瓦·萨克霍夫。",
				title = "卡斯迪诺夫的恐惧之袋", -- 5515
				location = "艾瓦·萨克霍夫（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "瑟尔林·卡斯迪诺夫教授", -- 5382
			},
			[5] = {
				note = "带着无辜者之血回到通灵学院，将它放在门廊的火盆下面，基尔图诺斯会前来吞噬你的灵魂。勇敢地战斗吧，不要退缩！杀死基尔图诺斯，然后回到艾瓦·萨克霍夫那儿。",
				followup = "莱斯·霜语", -- 5461
				attain = 55,
				aim = "带着无辜者之血回到通灵学院，将它放在门廊的火盆下面，基尔图诺斯会前来吞噬你的灵魂。勇敢地战斗吧，不要退缩！杀死基尔图诺斯，然后回到艾瓦·萨克霍夫那儿。",
				title = "传令官基尔图诺斯", -- 5384
				location = "艾瓦·萨克霍夫（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "鬼灵精华",
						id = 13544,
						subtext = "饰品",
						icon = "INV_Misc_Orb_05",
						quality = 2,
					},
					[2] = {
						name = "波尼的玫瑰",
						id = 15805,
						subtext = "副手",
						icon = "INV_Misc_Flower_04",
						quality = 3,
					},
					[3] = {
						name = "米拉之歌",
						id = 15806,
						subtext = "单手 剑",
						icon = "INV_Sword_34",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "卡斯迪诺夫的恐惧之袋", -- 5515
			},
			[6] = {
				note = "你可以在"..YELLOW.."[7]"..WHITE.."找到莱斯·霜语。",
				followup = "无后续",
				attain = 57,
				aim = "在通灵学院里找到莱斯·霜语。当你找到他之后，使用禁锢灵魂的遗物破除其亡灵的外壳。如果你成功地破除了他的不死之身，就杀掉他并拿到莱斯·霜语的头颅。把那个头颅交给马杜克镇长。",
				title = "巫妖莱斯·霜语", -- 5466
				location = "马杜克镇长（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "达隆郡之盾",
						id = 14002,
						subtext = "盾牌",
						icon = "INV_Shield_05",
						quality = 3,
					},
					[2] = {
						name = "凯尔达隆战剑",
						id = 13982,
						subtext = "双手 剑",
						icon = "INV_Sword_39",
						quality = 3,
					},
					[3] = {
						name = "凯尔达隆之冠",
						id = 13986,
						subtext = "头部 布甲",
						icon = "INV_Crown_01",
						quality = 3,
					},
					[4] = {
						name = "达隆郡之刺",
						id = 13984,
						subtext = "单手 匕首",
						icon = "INV_Weapon_ShortBlade_21",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "在通灵学院里找到莱斯·霜语。当你找到他之后，使用禁锢灵魂的遗物破除其亡灵的外壳。如果你成功地破除了他的不死之身，就杀掉他并拿到莱斯·霜语的头颅。把那个头颅交给马杜克镇长。",
			},
			[7] = {
				note = "你可以在"..YELLOW.."[12]"..WHITE.."找到凯尔达隆地契，在"..YELLOW.."[7]"..WHITE.."找到布瑞尔地契，在"..YELLOW.."[4]"..WHITE.."找到塔伦米尔地契，在"..YELLOW.."[1]"..WHITE.."找到南海镇地契。",
				followup = "巴罗夫的继承人\n（去亡灵壁垒暗杀阿莱克斯·巴罗夫。把他的脑袋交给维尔顿·巴罗夫。）", -- 5344
				attain = 52,
				aim = "到通灵学院中去取得巴罗夫家族的宝藏。这份宝藏包括四份地契：凯尔达隆地契、布瑞尔地契、塔伦米尔地契，还有南海镇地契。当你拿到这四份地契之后就回到阿莱克斯·巴罗夫那儿去。",
				title = "巴罗夫家族的宝藏", -- 5343
				location = "阿莱克斯·巴罗夫（西瘟疫之地 - 亡灵壁垒; "..YELLOW.."80,73"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "雏龙精华开始于丁奇·斯迪波尔（燃烧平原 - 烈焰峰; "..YELLOW.."65,23"..WHITE.."）。 观察室在"..YELLOW.."[6]"..WHITE.."。",
				followup = "无后续",
				attain = 57,
				aim = "将黎明先锋放在通灵学院的观察室里。打败维克图斯,然后回到贝蒂娜·比格辛克那里去。",
				title = "黎明先锋", -- 4771
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "断风者",
						id = 15853,
						subtext = "单手，斧",
						icon = "INV_Axe_08",
						quality = 3,
					},
					[2] = {
						name = "舞动之藤",
						id = 15854,
						subtext = "法杖",
						icon = "INV_Staff_07",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "雏龙精华 - > 贝蒂娜·比格辛克", -- 4726 -> 5531
			},
			[9] = {
				note = "只有术士才能得到这个任务！你可以在"..YELLOW.."[7]"..WHITE.."找到炼金实验室。",
				followup = "克索诺斯恐惧战马", -- 7631
				attain = 60,
				aim = "把瓶中的小鬼带到通灵学院的炼金实验室中。在小鬼制造出羊皮纸之后，把瓶子还给戈瑟奇·邪眼。",
				title = "末日蜡烛（"..YELLOW.."通灵学院"..WHITE.."）", -- 7629
				location = "戈瑟奇·邪眼（燃烧平原; "..YELLOW.."12,31"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "莫苏尔·召血者 - > 克索诺斯星尘", -- 7562 -> 7625
			},
			[10] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出库尔莫克的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[11] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "使用召唤火盆召唤出库尔莫克的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷.",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[12] = {
				note = "任务线从工匠威廉姆（东瘟疫之地 - 圣光之愿礼拜堂）那里开始，接任务“新的符文前线”。\n!!! 完成任务线的最后一个任务后，你将获得这个奖励。",
				followup = "与恐惧魔王会面", --40238
				attain = 55,
				aim = "进入通灵学院，为拉塔基特的斯特拉哈德·法尔萨恩找回书籍《火焰的召唤与命令》。",
				title = "(TW)12. 帮法尔桑的忙。", -- 40237
				location = "斯特拉哈德·法尔萨恩（贫瘠之地 - 棘齿城；"..YELLOW.."62.6,35.5"..WHITE.."）",
				level = 58,
				rewards = {
					[1] = {
						name = "淬火符文剑", --81060
						id = 81060,
						subtext = "双手 剑",
						icon = "INV_Sword_02",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "新的符文前线 -> 黑铁锻造的秘密 -> 黑铁锻造的秘密", -- 40234, 40235, 40236
			},
		},
	},
	[24] = {
		name = "Shadowfang Keep",
		story = "During the Third War, the wizards of the Kirin Tor battled against the undead armies of the Scourge. When the wizards of Dalaran died in battle, they would rise soon after - adding their former might to the growing Scourge. Frustrated by their lack of progress (and against the advice of his peers) the Archmage, Arugal elected to summon extra-dimensional entities to bolster Dalaran's diminishing ranks. Arugal's summoning brought the ravenous worgen into the world of Azeroth. The feral wolf-men slaughtered not only the Scourge, but quickly turned on the wizards themselves. The worgen laid siege to the keep of the noble, Baron Silverlaine. Situated above the tiny hamlet of Pyrewood, the keep quickly fell into shadow and ruin. Driven mad with guilt, Arugal adopted the worgen as his children and retreated to the newly dubbed 'Shadowfang Keep'. It's said he still resides there, protected by his massive pet, Fenrus - and haunted by the vengeful ghost of Baron Silverlaine.",
		[1] = {
			[1] = {
				note = "点击"..YELLOW.."[乔丹的武器材料单]"..WHITE.."查看乔丹的武器材料单。",
				followup = "正义试炼（圣骑士任务）", -- 1654
				attain = 20,
				aim = "按照乔丹的武器材料单上的说明去寻找一些白石橡木、精炼矿石、乔丹的铁锤和一块科尔宝石，然后回到铁炉堡去见乔丹·斯迪威尔。",
				title = "正义试炼（圣骑士任务）", -- 1654
				location = "乔丹·斯迪威尔（丹莫罗 - 铁炉堡 "..YELLOW.."52,36 "..WHITE.."）",
				level = 22,
				rewards = {
					[1] = {
						name = "维里甘之拳",
						id = 6953,
						subtext = "双手 锤",
						icon = "INV_Hammer_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "勇气之书 -> 正义试炼", -- 1651 -> 1653
				pages = {
				 "只有圣骑士们才能接到这个任务！\n\n1. 你可以从"..YELLOW.."[死亡矿井]"..WHITE.."地精木匠"..YELLOW.."[3]"..WHITE.."那儿得到白石橡木。\n\n2. 要得到精炼矿石，你必须先与白洛尔·石手交谈（洛克莫丹 - 塞尔萨玛; "..YELLOW.."35,44"..WHITE.."）。他会给你《白洛尔的矿石》任务。 你在一棵树后面找到乔丹的矿石"..YELLOW.."71,21"..WHITE.."。\n\n3. 你可以在"..YELLOW.."[影牙城堡]"..WHITE.."紧靠"..YELLOW.."[3]"..WHITE.."的地方找到乔丹的铁锤（安全地点）。\n\n4. 要得到科尔宝石，你必须去找桑迪斯·织风（黑海岸 - 奥伯丁; "..YELLOW.."37,40"..WHITE.."）并且做完《寻找科尔宝石》任务。为了完成这个任务，你必须杀掉"..YELLOW.."[黑暗深渊]"..WHITE.."前的黑暗深渊智者或者黑暗深渊海潮祭司。他们会掉落被污染的科尔宝石。桑迪斯·织风会为你清洁它的。"
				 }
			},
			[2] = {
				note = "只有术士才能得到这个任务！3块索兰鲁克宝珠的碎片，你可以从"..YELLOW.."[黑暗深渊]"..WHITE.."的暮光侍僧那里得到。那块索兰鲁克宝珠的大碎片，你要去"..YELLOW.."[影牙城堡]"..WHITE.."找影牙魔魂狼人。",
				followup = "无后续",
				attain = 20,
				aim = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				title = "索兰鲁克宝珠（术士任务）", -- 1740
				location = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				level = 25,
				rewards = {
					[1] = {
						name = "索兰鲁克宝珠（术士任务）", -- 1740
						id = 6898,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 2,
					},
					[2] = {
						name = "索拉鲁克法杖",
						id = 15109,
						subtext = "法杖",
						icon = "INV_Staff_09",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "",
				followup = "无后续",
				attain = 22,
				aim = "大法师安多玛斯要求你击败大法师阿鲁高 "..YELLOW.."[12]"..WHITE.."。完成后回到他那里。",
				title = "(TW)3. 大法师阿鲁高", -- 60108
				location = "大法师安多玛斯（暴风城 - 法师区，法师塔）",
				level = 27,
				rewards = {
					[1] = {
						name = "阿鲁高的戒指", --51805
						id = 51805,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_24",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "巫师阿什克伦贝在笼子里 "..YELLOW.."[1]"..WHITE.."。",
				followup = "无后续",
				attain = 22,
				aim = "大法师安多玛斯希望你前往银松森林的影牙城堡，了解一下发生了什么事情，找到巫师阿什克伦贝。",
				title = "(TW)4. 失踪的巫师", -- 60109
				location = "大法师安多玛斯（暴风城 - 法师区，法师塔）",
				level = 24,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "Shadowfang Blood drops from worgens inside the dungeon.",
				followup = "Wolfblood",
				attain = 60,
				aim = "Gather worgen blood for Fandral Staghelm. He requires blood samples from Karazhan, Gilneas City and Shadowfang Keep.",
				title = "Blood of Vorgendor",
				location = "Arch Druid Fandral Staghelm (Darnassus - Cenarion Enclave "..NORMAL.."35,10"..WHITE..")",
				level = 60,
				rewards = {
				},
				prequest = "Scythe of the Goddess",
			},
		},
		[2] = {
			[1] = {
				note = "阿达曼特位于"..YELLOW.."[1]"..WHITE.."，文森特在你一进庭院的右侧"..YELLOW.."[2]"..WHITE.."。",
				followup = "无后续",
				attain = 18,
				aim = "找到亡灵哨兵阿达曼特和亡灵哨兵文森特。",
				title = "影牙城堡里的亡灵哨兵", -- 1098
				location = "高级执行官哈德瑞克（银松森林 - 瑟伯切尔; "..YELLOW.."43,40"..WHITE.."）",
				level = 25,
				rewards = {
					[1] = {
						name = "鬼魂衬肩",
						id = 3324,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_09",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你可以找到书在进门的左边"..YELLOW.."[8]"..WHITE..")。",
				followup = "无后续",
				attain = 16,
				aim = "把乌尔之书带给幽暗城炼金区里的看守者贝尔杜加。",
				title = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				location = "把乌尔之书带给幽暗城炼金区里的看守者贝尔杜加。",
				level = 26,
				rewards = {
					[1] = {
						name = "灰色长靴",
						id = 6335,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_03",
						quality = 2,
					},
					[2] = {
						name = "钢钉护腕",
						id = 4534,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在"..YELLOW.."[12]"..WHITE.."找到阿鲁高。",
				followup = "无后续",
				attain = 18,
				aim = "杀死阿鲁高，把他的头带给瑟伯切尔的达拉尔·道恩维沃尔。",
				title = "除掉阿鲁高", -- 1014
				location = "达拉尔·道恩维沃尔（银松森林 - 瑟伯切尔; "..YELLOW.."44,39"..WHITE.."）",
				level = 27,
				rewards = {
					[1] = {
						name = "希尔瓦娜斯的图章",
						id = 6414,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_15",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "只有术士才能得到这个任务！3块索兰鲁克宝珠的碎片，你可以从"..YELLOW.."[黑暗深渊]"..WHITE.."的暮光侍僧那里得到。那块索兰鲁克宝珠的大碎片，你要去"..YELLOW.."[影牙城堡]"..WHITE.."找影牙魔魂狼人。",
				followup = "无后续",
				attain = 20,
				aim = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				title = "索兰鲁克宝珠（术士任务）", -- 1740
				location = "找到3块索兰鲁克宝珠的碎片和1块索兰鲁克宝珠的大碎片，把它们交给贫瘠之地的杜安·卡汉。",
				level = 25,
				rewards = {
					[1] = {
						name = "索兰鲁克宝珠（术士任务）", -- 1740
						id = 6898,
						subtext = "副手",
						icon = "INV_Misc_Orb_03",
						quality = 2,
					},
					[2] = {
						name = "索拉鲁克法杖",
						id = 15109,
						subtext = "法杖",
						icon = "INV_Staff_09",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "你会在 "..YELLOW.."[10]"..WHITE.." 处找到大法师阿鲁高。\n任务线从纳吉拉斯公爵（提瑞斯法林地 - 格伦希尔，提瑞斯法林地西部）开始。\n完成下一个任务后，你将获得任务奖励。",
				followup = "达尔索的遗产", --40282
				attain = 15,
				aim = "在影牙城堡的图书馆中找到梅莱纳斯的物品，并将它们交给幽暗城的皮尔斯·沙克尔顿。",
				title = "(TW)5. 进入下颚", -- 40281
				location = "皮尔斯·沙克尔顿（幽暗城 - 魔法区 "..YELLOW.."85.4,13.6"..WHITE.."）",
				level = 25,
				rewards = {
					[1] = {
						name = "拉内隆之剑", --60392
						id = 60392,
						subtext = "双手 剑",
						icon = "INV_Sword_23",
						quality = 3,
					},
					[2] = {
						name = "玛瑟拉之盾", --60393
						id = 60393,
						subtext = "盾牌",
						icon = "INV_Shield_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "达尔索传承 -> 不同类型的锁 -> 魔法之道", --40278, 40279, 40280
			},
			[6] = {
				note = "在影牙城堡中找到迈雷纳斯的财产，并将其交给幽暗城中的皮尔斯·沙克尔顿。",
				followup = "无后续",
				attain = 16,
				aim = "在影牙城堡中找到迈雷纳斯的财产，并将其交给幽暗城中的皮尔斯·沙克尔顿。",
				title = "(TW)6.虎口拔牙",
				location = "皮尔斯·沙克尔顿（幽暗城-魔法区; "..YELLOW.."85,14"..WHITE.."）",
				level = 22,
				rewards = {
					[1] = {
						name = "兰纳隆之剑",	--60392
						id = 70225,
						subtext = "颈部",
						icon = "INV_Belt_18",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "达尔索斯遗产->不同类型的锁->魔法之道",
			},
			[7] = {
				note = "Shadowfang Blood drops from worgens inside the dungeon.",
				followup = "Wolfblood",
				attain = 60,
				aim = "杀死艾隆迈恩主教并向格伦郡的布莱特科普夫神父报告。",
				title = "(TW)7.主教末路",
				location = "布莱特科普夫神父（提瑞斯法林地-格伦郡; "..YELLOW.."21,69"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "Scythe of the Goddess",
			},
		},
	},
	[25] = {
		name = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
		story = "斯坦索姆曾经是洛丹伦北部一颗璀璨的明珠，但是就是在这座城市阿尔萨斯王子背叛了他的导师乌瑟尔，并屠杀了数百个被认为感染了可怕瘟疫的臣民。阿尔萨斯不久之后就向巫妖王臣服。这个破碎的城市也被巫妖克尔苏拉德领导的亡灵天灾所占据。而一直由大十字军战士达索汉领导的血色十字军分遣队也占据了这个城市的一部分。这两方力量在城市中进行着激烈的战斗。而那些勇敢（亦或是愚蠢的）的冒险者在进入斯坦索姆之后将不得不面对两方的力量。据说整座城市由三座大型的通灵塔以及无数强大的亡灵巫师，女妖和憎恶所守卫着。据报告，邪恶的死亡骑士乘坐在一匹骷髅战马——他会将怒火倾泻在任何胆敢进入亡灵天灾领域的人。",
		[1] = {
			[1] = {
				note = "斯坦索姆里多数敌人都会掉落瘟疫肉块，但是掉落率很低。",
				followup = "活跃的探子", -- 5213
				attain = 55,
				aim = "从斯坦索姆找回20个瘟疫肉块，并把它们交给贝蒂娜·比格辛克。你觉得斯坦索姆中的生灵都不大可能长着肉……",
				title = "血肉不会撒谎", -- 5212
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "天灾军团档案在三个塔中的一个里，这三个塔在"..YELLOW.."[15]"..WHITE.."，"..YELLOW.."[16]"..WHITE.."和"..YELLOW.."[17]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到斯坦索姆去探索那里的通灵塔。找到新的天灾军团档案，把它交给贝蒂娜·比格辛克。",
				title = "活跃的探子", -- 5213
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "黎明之印",
						id = 13209,
						subtext = "饰品",
						icon = "INV_Misc_ArmorKit_18",
						quality = 3,
					},
					[2] = {
						name = "黎明符文",
						id = 19812,
						subtext = "饰品",
						icon = "INV_Misc_Rune_06",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "血肉不会撒谎", -- 5212
			},
			[3] = {
				note = "在斯坦索姆各处的箱子里你可以找到圣水。但是，如果你打开箱子，虫子可能会出现并攻击你。",
				followup = "无后续",
				attain = 55,
				aim = "到北方的斯坦索姆去，寻找散落在城市中的补给箱，并收集5瓶斯坦索姆圣水。当你找到足够的圣水之后就回去向莱尼德·巴萨罗梅复命。",
				title = "神圣之屋", -- 5243
				location = "莱尼德·巴萨罗梅（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."80,58"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "超强治疗药水",
						id = 3928,
						subtext = "药水",
						icon = "INV_Potion_53",
						quality = 1,
					},
					[2] = {
						name = "强效法力药水",
						id = 6149,
						subtext = "药水",
						icon = "INV_Potion_73",
						quality = 1,
					},
					[3] = {
						name = "忏悔之冠",
						id = 13216,
						subtext = "头部 布甲",
						icon = "INV_Helmet_06",
						quality = 2,
					},
					[4] = {
						name = "忏悔者指环",
						id = 13217,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_30",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "烟草店在"..YELLOW.."[1]"..WHITE.."附近。当你打开盒子，弗拉斯·希亚比会突然出现。",
				followup = "无后续",
				attain = 55,
				aim = "找到弗拉斯·希亚比在斯坦索姆的烟草店，并从中找回一盒希亚比的烟草，把它交给烟鬼拉鲁恩。",
				title = "弗拉斯·希亚比", -- 5214
				location = "烟鬼拉鲁恩（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."80,58"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "烟鬼的打火器",
						id = 13171,
						subtext = "饰品",
						icon = "Spell_Fire_SearingTotem",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "前导任务从护理者奥林处获得（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."79,63"..WHITE.."）\n鬼魂居民在斯坦索姆到处走动。",
				followup = "无后续",
				attain = 55,
				aim = "对斯坦索姆里已成为鬼魂的居民们使用埃根的冲击器。当永不安息的灵魂从他们的鬼魂外壳解放出来后，再次使用冲击器 - 他们就会彻底自由了！\n释放15个永不安息的灵魂，然后回到埃根那里。",
				title = "永不安息的灵魂", -- 5282
				location = "埃根（东瘟疫之地; "..YELLOW.."14,33"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "希望的证明",
						id = 13315,
						subtext = "副手",
						icon = "INV_Misc_Book_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "永不安息的灵魂", -- 5282
			},
			[6] = {
				note = "前导任务从提里奥·弗丁处获得（西瘟疫之地; "..YELLOW.."7,43"..WHITE.."）。\n画在"..YELLOW.."[10]"..WHITE.."。",
				followup = "寻找麦兰达", -- 5861
				attain = 52,
				aim = "到瘟疫之地北部的斯坦索姆去。你可以在血色十字军堡垒中找到“爱与家庭”这幅画，它被隐藏在另一幅描绘两个月亮的画之后。\n把这幅画还给提里奥·弗丁。",
				title = "爱与家庭（系列任务）", -- 5848
				location = "画家瑞弗蕾（西瘟疫之地 - 凯尔达隆; "..YELLOW.."65,75"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "救赎 - > 遗忘的记忆 - > 失落的荣耀 - > 爱与家庭", -- 5742 -> 5846
			},
			[7] = {
				note = "前导任务从马杜克镇长（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）处获得。\n你可以在"..YELLOW.."[19]"..WHITE.."附近找到标志。也可以参见：通灵学院里的"..YELLOW.."[巫妖莱斯·霜语]"..WHITE.."。",
				followup = "米奈希尔的礼物（系列任务）", -- 5463
				attain = 57,
				aim = "到斯坦索姆城里去找到米奈希尔的礼物，把巫妖生前的遗物放在那块邪恶的土地上。",
				title = "米奈希尔的礼物（系列任务）", -- 5463
				location = "莱尼德·巴萨罗梅（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."80,58"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "莱斯·霜语 - > 亡灵莱斯·霜语", -- 5461 -> 5462
			},
			[8] = {
				note = "要开始这个任务你需要给奥里克斯 [信仰奖章]。 你可以从玛洛尔的保险箱拿到这个奖章，箱子就在"..YELLOW.."[7]"..WHITE.."附近。将奖章给了奥里克斯之后，他会在对抗男爵"..YELLOW.."[19]"..WHITE.."的战斗中支持你。杀死男爵后，你需要再次和奥里克斯谈话以取得任务回报奖励。",
				followup = "无后续",
				attain = 55,
				aim = "雷霆之怒，逐风者的祝福之剑部分任务，当你从加尔"..YELLOW.."[4]"..WHITE.."拿到逐风者禁锢之颅右半和迦顿男爵"..YELLOW.."[6]"..WHITE.."拿到逐风者禁锢之颅左半后，与德米提恩对话开启任务线。拉格纳罗斯"..YELLOW.."[10]"..WHITE.."掉落火焰之王的精华。完成这些后，召唤并杀掉桑德兰王子，这是一个40人团队 Boss。",
				title = "奥里克斯的清算", -- 5125
				location = "奥里克斯（斯坦索姆; "..YELLOW.."[13]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "殉难者的意志",
						id = 17044,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_07",
						quality = 3,
					},
					[2] = {
						name = "殉难者之血",
						id = 17045,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_25",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "档案和档案管理员在"..YELLOW.."[10]"..WHITE.."。",
				followup = "可怕的真相", -- 5262
				attain = 55,
				aim = "在斯坦索姆城中找到血色十字军的档案管理员加尔福特，杀掉他，然后烧毁血色十字军档案。",
				title = "档案管理员", -- 5251
				location = "尼古拉斯·瑟伦霍夫公爵在（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81, 59"..WHITE.."）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "尼古拉斯·瑟伦霍夫公爵在（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81, 59"..WHITE.."）。",
				followup = "超越", -- 5263
				attain = 55,
				aim = "将巴纳扎尔的头颅交给东瘟疫之地的尼古拉斯·瑟伦霍夫公爵。",
				title = "可怕的真相", -- 5262
				location = "巴纳扎尔（斯坦索姆; "..YELLOW.."[11]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "档案管理员", -- 5251
			},
			[11] = {
				note = "瑞文戴尔男爵在"..YELLOW.."[19]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到斯坦索姆去杀掉瑞文戴尔男爵，把他的头颅交给尼古拉斯·瑟伦霍夫公爵。",
				title = "超越", -- 5263
				location = "尼古拉斯·瑟伦霍夫公爵在（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81, 59"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "黎明守护者",
						id = 13243,
						subtext = "盾牌",
						icon = "INV_Shield_05",
						quality = 3,
					},
					[2] = {
						name = "银色十字军",
						id = 13249,
						subtext = "法杖",
						icon = "INV_Staff_13",
						quality = 3,
					},
					[3] = {
						name = "银色复仇者",
						id = 13246,
						subtext = "单手 剑",
						icon = "INV_Sword_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "可怕的真相", -- 5262
			},
			[12] = {
				note = "伊思达·哈尔蒙就站在斯坦索姆副本门口。你需要超维度幽灵显形器才能看到伊思达·哈尔蒙。联盟这个任务的前续任务接自德莉亚娜（铁炉堡 "..YELLOW.."43,52"..WHITE.."），部落的接自莫克瓦尔（奥格瑞玛 "..YELLOW.."38,37"..WHITE.."）。\n这个同时也是著名的45分钟杀瑞文戴尔男爵任务。",
				followup = "生命的证据", -- 8946
				attain = 58,
				aim = "进入斯坦索姆，从瑞文戴尔男爵手中救出伊思达。",
				title = "死人的请求", -- 8945
				location = "伊思达·哈尔蒙（东瘟疫之地 - 斯坦索姆）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
			},
			[13] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。\n\n召唤亚雷恩和索托斯在"..YELLOW.."[11]"..WHITE.."。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出亚雷恩和索托斯的灵魂，然后杀掉他们。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[14] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。\n\n召唤亚雷恩和索托斯在"..YELLOW.."[11]"..WHITE.."。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "使用召唤火盆召唤出亚雷恩和索托斯的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克公爵的饰品还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[15] = {
				note = "召唤位置在"..YELLOW.."[2]"..WHITE.."。",
				followup = "无后续",
				attain = 60,
				aim = "塔纳利斯时光之穴的阿纳克洛斯要你前往斯坦索姆，在神圣之地上使用埃提耶什，守护者的传说之杖。击败被驱赶出法杖的生物，然后回到阿纳克洛斯那里去。 ",
				title = "埃提耶什，守护者的传说之杖",
				location = "塔纳利斯时光之穴的阿纳克洛斯要你前往斯坦索姆，在神圣之地上使用埃提耶什，守护者的传说之杖。击败被驱赶出法杖的生物，然后回到阿纳克洛斯那里去。 ",
				level = 60,
				rewards = {
					[1] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22589,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					[2] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22630,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					[3] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22631,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					[4] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22632,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "埃提耶什之杖 -> 埃提耶什，被玷污的传说之杖", -- 9250 -> 9251 
			},
			[16] = {
				note = "召唤黑衣守卫铸剑师在"..YELLOW.."[15]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "在斯坦索姆找到黑衣守卫铸剑师，然后杀死他。将黑色卫士徽记交给亡灵杀手瑟里尔。",
				title = "维利塔恩的污染", -- 7041
				location = "亡灵杀手瑟里尔（冬泉谷 - 永望镇; "..YELLOW.."61,37"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：闪耀轻剑 ",
						id = 12825,
						subtext = "图样",
						icon = "INV_Scroll_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[17] = {
				note = "召唤红衣铸锤师在"..YELLOW.."[8]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "到斯坦索姆去杀死红衣铸锤师。将红衣铸锤师的围裙交给莉莉丝。",
				title = "甜美的平静（铸锤大师任务）",
				location = "轻盈的莉莉丝（冬泉谷 - 永望镇; "..YELLOW.."61,37"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：魔法战锤",
						id = 12824,
						subtext = "图样",
						icon = "INV_Scroll_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[18] = {
				note = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
				followup = "无后续",
				attain = 30,
				aim = "我需要的最后一个部件是用于内骨架的高质量精金棒。我相信斯坦索姆的锻造厂过去曾制作过这样的棒子。",
				title = "(TW)18. 建造一个重击者", -- 80401
				location = "奥格索普·奥布诺提库斯 <大师级侏儒工程师>（荆棘谷；藏宝海湾 "..YELLOW.."28.4,76.3"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "强化红色破碎者",
						id = 81253,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[2] = {
						name = "强化绿色破碎者",
						id = 81252,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[3] = {
						name = "强化蓝色破碎者",
						id = 81251,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[4] = {
						name = "强化黑色破碎者",
						id = 81250,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "一个有力的大脑（仅限工程师）", --80398
			},
			[19] = {
				note = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
				followup = "灰烬使者的灵魂",
				attain = 55,
				aim = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				title = "(TW)19. 唤醒灰烬使者。", -- 20002
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
				},
				prequest = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
			},
			[20] = {
				note = "罗斯伦家族胸针位于首领“不可宽恕者”旁边的宝箱中，位置标记为 "..YELLOW.."[4]"..WHITE.."。\n任务链的起始物品是随机掉落的史诗物品“被撕碎的烹饪笔记”，位置标记为 "..YELLOW.."[卡拉赞]"..WHITE.."。",
				followup = "神秘配方 ("..YELLOW.."[卡拉赞]"..WHITE..")", -- 41001
				attain = 58,
				aim = "从斯坦索姆中找回罗斯伦家族胸针，并将其带给卡拉赞的公爵罗斯伦。",
				title = "卡拉赞的钥匙 I - VI -> 卡拉赞的钥匙 VII "..YELLOW.."[斯坦索姆]"..WHITE.." ", --40817
				location = "多万·布雷斯温德（尘泥沼泽 - "..YELLOW.."[71.1,73.2]"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
		},
		[2] = {
			[1] = {
				note = "斯坦索姆里多数敌人都会掉落瘟疫肉块，但是掉落率很低。",
				followup = "活跃的探子", -- 5213
				attain = 55,
				aim = "从斯坦索姆找回20个瘟疫肉块，并把它们交给贝蒂娜·比格辛克。你觉得斯坦索姆中的生灵都不大可能长着肉……",
				title = "血肉不会撒谎", -- 5212
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "天灾军团档案在三个塔中的一个里，这三个塔在"..YELLOW.."[15]"..WHITE.."，"..YELLOW.."[16]"..WHITE.."和"..YELLOW.."[17]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到斯坦索姆去探索那里的通灵塔。找到新的天灾军团档案，把它交给贝蒂娜·比格辛克。",
				title = "活跃的探子", -- 5213
				location = "贝蒂娜·比格辛克（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81,59"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "黎明之印",
						id = 13209,
						subtext = "饰品",
						icon = "INV_Misc_ArmorKit_18",
						quality = 3,
					},
					[2] = {
						name = "黎明符文",
						id = 19812,
						subtext = "饰品",
						icon = "INV_Misc_Rune_06",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "血肉不会撒谎", -- 5212
			},
			[3] = {
				note = "在斯坦索姆各处的箱子里你可以找到圣水。但是，如果你打开箱子，虫子可能会出现并攻击你。",
				followup = "无后续",
				attain = 55,
				aim = "到北方的斯坦索姆去，寻找散落在城市中的补给箱，并收集5瓶斯坦索姆圣水。当你找到足够的圣水之后就回去向莱尼德·巴萨罗梅复命。",
				title = "神圣之屋", -- 5243
				location = "莱尼德·巴萨罗梅（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."80,58"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "超强治疗药水",
						id = 3928,
						subtext = "药水",
						icon = "INV_Potion_53",
						quality = 1,
					},
					[2] = {
						name = "强效法力药水",
						id = 6149,
						subtext = "药水",
						icon = "INV_Potion_73",
						quality = 1,
					},
					[3] = {
						name = "忏悔之冠",
						id = 13216,
						subtext = "头部 布甲",
						icon = "INV_Helmet_06",
						quality = 2,
					},
					[4] = {
						name = "忏悔者指环",
						id = 13217,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_30",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "烟草店在"..YELLOW.."[1]"..WHITE.."附近。当你打开盒子，弗拉斯·希亚比会突然出现。",
				followup = "无后续",
				attain = 55,
				aim = "找到弗拉斯·希亚比在斯坦索姆的烟草店，并从中找回一盒希亚比的烟草，把它交给烟鬼拉鲁恩。",
				title = "弗拉斯·希亚比", -- 5214
				location = "烟鬼拉鲁恩（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."80,58"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "烟鬼的打火器",
						id = 13171,
						subtext = "饰品",
						icon = "Spell_Fire_SearingTotem",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "前导任务从护理者奥林处获得（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."79,63"..WHITE.."）\n鬼魂居民在斯坦索姆到处走动。",
				followup = "无后续",
				attain = 55,
				aim = "对斯坦索姆里已成为鬼魂的居民们使用埃根的冲击器。当永不安息的灵魂从他们的鬼魂外壳解放出来后，再次使用冲击器 - 他们就会彻底自由了！\n释放15个永不安息的灵魂，然后回到埃根那里。",
				title = "永不安息的灵魂", -- 5282
				location = "埃根（东瘟疫之地; "..YELLOW.."14,33"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "希望的证明",
						id = 13315,
						subtext = "副手",
						icon = "INV_Misc_Book_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "永不安息的灵魂", -- 5282
			},
			[6] = {
				note = "前导任务从提里奥·弗丁处获得（西瘟疫之地; "..YELLOW.."7,43"..WHITE.."）。\n画在"..YELLOW.."[10]"..WHITE.."。",
				followup = "寻找麦兰达", -- 5861
				attain = 52,
				aim = "到瘟疫之地北部的斯坦索姆去。你可以在血色十字军堡垒中找到“爱与家庭”这幅画，它被隐藏在另一幅描绘两个月亮的画之后。\n把这幅画还给提里奥·弗丁。",
				title = "爱与家庭（系列任务）", -- 5848
				location = "画家瑞弗蕾（西瘟疫之地 - 凯尔达隆; "..YELLOW.."65,75"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "救赎 - > 遗忘的记忆 - > 失落的荣耀 - > 爱与家庭", -- 5742 -> 5846
			},
			[7] = {
				note = "前导任务从马杜克镇长（西瘟疫之地 - 凯尔达隆; "..YELLOW.."70,73"..WHITE.."）处获得。\n你可以在"..YELLOW.."[19]"..WHITE.."附近找到标志。也可以参见：通灵学院里的"..YELLOW.."[巫妖莱斯·霜语]"..WHITE.."。",
				followup = "米奈希尔的礼物（系列任务）", -- 5463
				attain = 57,
				aim = "到斯坦索姆城里去找到米奈希尔的礼物，把巫妖生前的遗物放在那块邪恶的土地上。",
				title = "米奈希尔的礼物（系列任务）", -- 5463
				location = "莱尼德·巴萨罗梅（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."80,58"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "莱斯·霜语 - > 亡灵莱斯·霜语", -- 5461 -> 5462
			},
			[8] = {
				note = "要开始这个任务你需要给奥里克斯 [信仰奖章]。 你可以从玛洛尔的保险箱拿到这个奖章，箱子就在"..YELLOW.."[7]"..WHITE.."附近。将奖章给了奥里克斯之后，他会在对抗男爵"..YELLOW.."[19]"..WHITE.."的战斗中支持你。杀死男爵后，你需要再次和奥里克斯谈话以取得任务回报奖励。",
				followup = "无后续",
				attain = 55,
				aim = "雷霆之怒，逐风者的祝福之剑部分任务，当你从加尔"..YELLOW.."[4]"..WHITE.."拿到逐风者禁锢之颅右半和迦顿男爵"..YELLOW.."[6]"..WHITE.."拿到逐风者禁锢之颅左半后，与德米提恩对话开启任务线。拉格纳罗斯"..YELLOW.."[10]"..WHITE.."掉落火焰之王的精华。完成这些后，召唤并杀掉桑德兰王子，这是一个40人团队 Boss。",
				title = "奥里克斯的清算", -- 5125
				location = "奥里克斯（斯坦索姆; "..YELLOW.."[13]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "殉难者的意志",
						id = 17044,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_07",
						quality = 3,
					},
					[2] = {
						name = "殉难者之血",
						id = 17045,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_25",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "档案和档案管理员在"..YELLOW.."[10]"..WHITE.."。",
				followup = "可怕的真相", -- 5262
				attain = 55,
				aim = "在斯坦索姆城中找到血色十字军的档案管理员加尔福特，杀掉他，然后烧毁血色十字军档案。",
				title = "档案管理员", -- 5251
				location = "尼古拉斯·瑟伦霍夫公爵在（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81, 59"..WHITE.."）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "尼古拉斯·瑟伦霍夫公爵在（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81, 59"..WHITE.."）。",
				followup = "超越", -- 5263
				attain = 55,
				aim = "将巴纳扎尔的头颅交给东瘟疫之地的尼古拉斯·瑟伦霍夫公爵。",
				title = "可怕的真相", -- 5262
				location = "巴纳扎尔（斯坦索姆; "..YELLOW.."[11]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "档案管理员", -- 5251
			},
			[11] = {
				note = "瑞文戴尔男爵在"..YELLOW.."[19]"..WHITE.."。",
				followup = "无后续",
				attain = 55,
				aim = "到斯坦索姆去杀掉瑞文戴尔男爵，把他的头颅交给尼古拉斯·瑟伦霍夫公爵。",
				title = "超越", -- 5263
				location = "尼古拉斯·瑟伦霍夫公爵在（东瘟疫之地 - 圣光之愿礼拜堂; "..YELLOW.."81, 59"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "黎明守护者",
						id = 13243,
						subtext = "盾牌",
						icon = "INV_Shield_05",
						quality = 3,
					},
					[2] = {
						name = "银色十字军",
						id = 13249,
						subtext = "法杖",
						icon = "INV_Staff_13",
						quality = 3,
					},
					[3] = {
						name = "银色复仇者",
						id = 13246,
						subtext = "单手 剑",
						icon = "INV_Sword_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "可怕的真相", -- 5262
			},
			[12] = {
				note = "伊思达·哈尔蒙就站在斯坦索姆副本门口。你需要超维度幽灵显形器才能看到伊思达·哈尔蒙。联盟这个任务的前续任务接自德莉亚娜（铁炉堡 "..YELLOW.."43,52"..WHITE.."），部落的接自莫克瓦尔（奥格瑞玛 "..YELLOW.."38,37"..WHITE.."）。\n这个同时也是著名的45分钟杀瑞文戴尔男爵任务。",
				followup = "生命的证据", -- 8946
				attain = 58,
				aim = "进入斯坦索姆，从瑞文戴尔男爵手中救出伊思达。",
				title = "死人的请求", -- 8945
				location = "伊思达·哈尔蒙（东瘟疫之地 - 斯坦索姆）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
			},
			[13] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。\n\n召唤亚雷恩和索托斯在"..YELLOW.."[11]"..WHITE.."。",
				followup = "奥卡兹岛在你前方……", -- 8970
				attain = 58,
				aim = "使用召唤火盆召唤出亚雷恩和索托斯的灵魂，然后杀掉他们。完成之后，将召唤火盆与瓦塔拉克饰品的左瓣还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的左瓣", -- 8967
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "重要的材料", -- 8963
			},
			[14] = {
				note = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。\n\n召唤亚雷恩和索托斯在"..YELLOW.."[11]"..WHITE.."。",
				followup = "最后的准备（"..YELLOW.."黑石塔上层"..WHITE.."）", -- 8994
				attain = 58,
				aim = "使用召唤火盆召唤出亚雷恩和索托斯的灵魂，然后杀掉他。完成之后，将召唤火盆与瓦塔拉克公爵的饰品还给黑石山的伯德雷。",
				title = "瓦塔拉克饰品的右瓣", -- 8990
				location = "伯德雷（黑石山; "..YELLOW.."副本入口地图[D]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "更多重要的材料", -- 8985
			},
			[15] = {
				note = "召唤位置在"..YELLOW.."[2]"..WHITE.."。",
				followup = "无后续",
				attain = 60,
				aim = "塔纳利斯时光之穴的阿纳克洛斯要你前往斯坦索姆，在神圣之地上使用埃提耶什，守护者的传说之杖。击败被驱赶出法杖的生物，然后回到阿纳克洛斯那里去。 ",
				title = "埃提耶什，守护者的传说之杖",
				location = "塔纳利斯时光之穴的阿纳克洛斯要你前往斯坦索姆，在神圣之地上使用埃提耶什，守护者的传说之杖。击败被驱赶出法杖的生物，然后回到阿纳克洛斯那里去。 ",
				level = 60,
				rewards = {
					[1] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22589,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					[2] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22630,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					[3] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22631,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					[4] = {
						name = "埃提耶什，守护者的传说之杖",
						id = 22632,
						subtext = "法杖",
						icon = "INV_Staff_Medivh",
						quality = 5,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "埃提耶什之杖 -> 埃提耶什，被玷污的传说之杖", -- 9250 -> 9251 
			},
			[16] = {
				note = "召唤黑衣守卫铸剑师在"..YELLOW.."[15]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "在斯坦索姆找到黑衣守卫铸剑师，然后杀死他。将黑色卫士徽记交给亡灵杀手瑟里尔。",
				title = "维利塔恩的污染", -- 7041
				location = "亡灵杀手瑟里尔（冬泉谷 - 永望镇; "..YELLOW.."61,37"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：闪耀轻剑 ",
						id = 12825,
						subtext = "图样",
						icon = "INV_Scroll_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[17] = {
				note = "召唤红衣铸锤师在"..YELLOW.."[8]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "到斯坦索姆去杀死红衣铸锤师。将红衣铸锤师的围裙交给莉莉丝。",
				title = "甜美的平静（铸锤大师任务）",
				location = "轻盈的莉莉丝（冬泉谷 - 永望镇; "..YELLOW.."61,37"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "设计图：魔法战锤",
						id = 12824,
						subtext = "图样",
						icon = "INV_Scroll_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[18] = {
				note = "前续任务也是从他这里接。拉姆斯登在"..YELLOW.."[18]"..WHITE.."。",
				followup = "无后续",
				attain = 56,
				aim = "到斯坦索姆去，杀掉吞咽者拉姆斯登。把他的头颅交给纳萨诺斯。",
				title = "没有前续任务，但是 精灵的传说任务必须完成后才能接到这个任务。",
				location = "纳萨诺斯·凋零者（东瘟疫之地; "..YELLOW.."26,74"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "阿莱克希斯皇家戒指",
						id = 18022,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_30",
						quality = 3,
					},
					[2] = {
						name = "元素之环",
						id = 17001,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_29",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "游侠之王的命令 -> 暗翼蝠", -- 6133 -> 6135
			},
			[19] = {
				note = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
				followup = "无后续",
				attain = 30,
				aim = "我需要的最后一个部件是用于内骨架的高质量精金棒。我相信斯坦索姆的锻造厂过去曾制作过这样的棒子。",
				title = "(TW)18. 建造一个重击者", -- 80401
				location = "奥格索普·奥布诺提库斯 <大师级侏儒工程师>（荆棘谷；藏宝海湾 "..YELLOW.."28.4,76.3"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "强化红色破碎者",
						id = 81253,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[2] = {
						name = "强化绿色破碎者",
						id = 81252,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[3] = {
						name = "强化蓝色破碎者",
						id = 81251,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					[4] = {
						name = "强化黑色破碎者",
						id = 81250,
						subtext = "物品",
						icon = "INV_Gizmo_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "一个有力的大脑（仅限工程师）", --80398
			},
			[20] = {
				note = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
				followup = "灰烬使者的灵魂",
				attain = 55,
				aim = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				title = "(TW)19. 唤醒灰烬使者。", -- 20002
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
				},
				prequest = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
			},
			[21] = {
				note = "罗斯伦家族胸针位于首领“不可宽恕者”旁边的宝箱中，位置标记为 "..YELLOW.."[4]"..WHITE.."。\n任务链的起始物品是随机掉落的史诗物品“被撕碎的烹饪笔记”，位置标记为 "..YELLOW.."[卡拉赞]"..WHITE.."。",
				followup = "神秘配方 ("..YELLOW.."[卡拉赞]"..WHITE..")", -- 41001
				attain = 58,
				aim = "从斯坦索姆中找回罗斯伦家族胸针，并将其带给卡拉赞的公爵罗斯伦。",
				title = "卡拉赞的钥匙 I - VI -> 卡拉赞的钥匙 VII "..YELLOW.."[斯坦索姆]"..WHITE.." ", --40817
				location = "多万·布雷斯温德（尘泥沼泽 - "..YELLOW.."[71.1,73.2]"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
		},
	},
	[26] = {
		name = "安其拉废墟",
		story = "在流沙之战最后几个小时里，四巨龙军团和暗夜精灵的联军将战场逼至其拉帝国的最中心，希利苏斯的异种虫群退败至最终堡垒安其拉城。但在安其拉之门内，等待着的却是大规模的其拉异种虫，数量是卡利姆多联军所无法想象的。经过漫长的战役，卡利姆多联军仍然无法击败其拉帝王以及他的异种虫群，只能以一个强大的魔法结界将它们困禁在内，而安其拉城也因为战火而成了一个被诅咒的废墟。经过了数千年，其拉的侵略心却没有因为结界而消退。新一代的异种虫群从巢穴中慢慢的破茧而出，安其拉废墟又再度充满了其拉异种虫。这股威胁一定要被消灭，否则艾泽拉斯将可能会被这股恐怖的新世代其拉势力给毁灭。",
		[1] = {
			[1] = {
				note = "将无疤者奥斯里安的头颅交给希利苏斯塞纳里奥要塞的指挥官玛尔利斯。",
				followup = "无后续",
				attain = 60,
				aim = "将无疤者奥斯里安的头颅交给希利苏斯塞纳里奥要塞的指挥官玛尔利斯。",
				title = "奥斯里安之死", -- 8791
				location = "无疤者奥斯里安的头颅（无疤者奥斯里安掉落; "..YELLOW.."[6]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "流沙护符",
						id = 21504,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					[2] = {
						name = "流沙咒符",
						id = 21507,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					[3] = {
						name = "流沙颈饰",
						id = 21505,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					[4] = {
						name = "流沙坠饰",
						id = 21506,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "高阶祭司温诺希斯"..YELLOW.."祖尔格拉布"..WHITE.."掉落温诺希斯的毒囊。库林纳克斯"..YELLOW.."安其拉废墟"..WHITE..""..YELLOW.."[1]"..WHITE.."掉落库林纳克斯的毒囊。",
				followup = "无后续",
				attain = 60,
				aim = "塞纳里奥要塞的德尔克·雷木让你把温诺希斯的毒囊和库林纳克斯的毒囊交给他。",
				title = "完美的毒药", -- 9023
				location = "德尔克·雷木（希利苏斯 - 塞纳里奥要塞; "..YELLOW.."52,39"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "拉文霍德切割者",
						id = 22378,
						subtext = "单手 剑",
						icon = "INV_Sword_38",
						quality = 3,
					},
					[2] = {
						name = "开闸刀",
						id = 22379,
						subtext = "主手 匕首",
						icon = "INV_Sword_21",
						quality = 3,
					},
					[3] = {
						name = "雷木之刺",
						id = 22377,
						subtext = "单手 匕首",
						icon = "INV_Sword_17",
						quality = 3,
					},
					[4] = {
						name = "康恩之怒",
						id = 22348,
						subtext = "双手 锤",
						icon = "INV_Hammer_10",
						quality = 3,
					},
					[5] = {
						name = "法拉德的装填器",
						id = 22347,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_04",
						quality = 3,
					},
					[6] = {
						name = "西蒙尼的耕种用锤",
						id = 22380,
						subtext = "主手 锤",
						icon = "INV_Hammer_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4"..AQDiscription_OR.."5"..AQDiscription_OR.."6",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "将无疤者奥斯里安的头颅交给希利苏斯塞纳里奥要塞的指挥官玛尔利斯。",
				followup = "无后续",
				attain = 60,
				aim = "将无疤者奥斯里安的头颅交给希利苏斯塞纳里奥要塞的指挥官玛尔利斯。",
				title = "奥斯里安之死", -- 8791
				location = "无疤者奥斯里安的头颅（无疤者奥斯里安掉落; "..YELLOW.."[6]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "流沙护符",
						id = 21504,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					[2] = {
						name = "流沙咒符",
						id = 21507,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					[3] = {
						name = "流沙颈饰",
						id = 21505,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					[4] = {
						name = "流沙坠饰",
						id = 21506,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_03",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "高阶祭司温诺希斯"..YELLOW.."祖尔格拉布"..WHITE.."掉落温诺希斯的毒囊。库林纳克斯"..YELLOW.."安其拉废墟"..WHITE..""..YELLOW.."[1]"..WHITE.."掉落库林纳克斯的毒囊。",
				followup = "无后续",
				attain = 60,
				aim = "塞纳里奥要塞的德尔克·雷木让你把温诺希斯的毒囊和库林纳克斯的毒囊交给他。",
				title = "完美的毒药", -- 9023
				location = "德尔克·雷木（希利苏斯 - 塞纳里奥要塞; "..YELLOW.."52,39"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "拉文霍德切割者",
						id = 22378,
						subtext = "单手 剑",
						icon = "INV_Sword_38",
						quality = 3,
					},
					[2] = {
						name = "开闸刀",
						id = 22379,
						subtext = "主手 匕首",
						icon = "INV_Sword_21",
						quality = 3,
					},
					[3] = {
						name = "雷木之刺",
						id = 22377,
						subtext = "单手 匕首",
						icon = "INV_Sword_17",
						quality = 3,
					},
					[4] = {
						name = "康恩之怒",
						id = 22348,
						subtext = "双手 锤",
						icon = "INV_Hammer_10",
						quality = 3,
					},
					[5] = {
						name = "法拉德的装填器",
						id = 22347,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_04",
						quality = 3,
					},
					[6] = {
						name = "西蒙尼的耕种用锤",
						id = 22380,
						subtext = "主手 锤",
						icon = "INV_Hammer_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4"..AQDiscription_OR.."5"..AQDiscription_OR.."6",
				},
				prequest = "无前置",
			},
		},
	},
	[27] = {
		name = "监狱",
		story = "监狱是位于暴风城运河区戒备森原的牢房。那里由典狱官塞尔沃特看守着，监狱是那些小偷，政治犯，谋杀者和许多最危险的罪犯的家园。最近，异常暴动导致了监狱的混乱——所有的守卫都被赶了出来，里面的罪犯可以自由的活动。典狱官塞尔沃特试图控制局面并召集勇敢的冒险者进入监狱杀死暴动的主脑——那个狡猾的巴吉尔·特雷德。",
		[1] = {
			[1] = {
				note = "你可以在"..YELLOW.."[1]"..WHITE.."找到塔格尔。",
				followup = "无后续",
				attain = 22,
				aim = "把塔格尔的头颅带给湖畔镇的卫兵伯尔顿。",
				title = "伸张正义", -- 386
				location = "卫兵伯尔顿（赤脊山 - 湖畔镇; "..YELLOW.."26,46 "..WHITE.."）",
				level = 25,
				rewards = {
					[1] = {
						name = "磷铝长剑",
						id = 3400,
						subtext = "主手 剑",
						icon = "INV_Sword_20",
						quality = 2,
					},
					[2] = {
						name = "硬根法杖",
						id = 1317,
						subtext = "法杖",
						icon = "INV_Staff_16",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你可以在"..YELLOW.."[5]"..WHITE.."找到迪克斯特·瓦德.",
				followup = "无后续",
				attain = 22,
				aim = "夜色镇的米尔斯迪普议员要你杀死迪克斯特·瓦德，并把他的手带回来作为证明。",
				title = "罪与罚", -- 377
				location = "米尔斯迪普议员（暮色森林 - 夜色镇; "..YELLOW.."72,47 "..WHITE.."）",
				level = 26,
				rewards = {
					[1] = {
						name = "大使之靴",
						id = 2033,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_08",
						quality = 2,
					},
					[2] = {
						name = "夜色郡锁甲护腿",
						id = 2906,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "",
				followup = "无后续",
				attain = 22,
				aim = "暴风城的典狱官塞尔沃特要求你杀死监狱中的10名迪菲亚囚徒、8名迪菲亚罪犯和8名迪菲亚叛军。",
				title = "镇压暴动", -- 387
				location = "暴风城的典狱官塞尔沃特要求你杀死监狱中的10名迪菲亚囚徒、8名迪菲亚罪犯和8名迪菲亚叛军。",
				level = 26,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "副本里每个敌人都可能掉落面罩。",
				followup = "无后续",
				attain = 22,
				aim = "暴风城的尼科瓦·拉斯克要你取得10条红色毛纺面罩。",
				title = "鲜血的颜色", -- 388
				location = "尼科瓦·拉斯克（暴风城 - 旧城区; "..YELLOW.."73,46 "..WHITE.."）",
				level = 26,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "前导任务也从莫特雷·加玛森处得到。你可以在"..YELLOW.."[2]"..WHITE.."找到卡姆·深怒。",
				followup = "无后续",
				attain = 22,
				aim = "丹莫德的莫特雷·加玛森要求你把卡姆·深怒的头颅交给他。",
				title = "卡姆·深怒", -- 378
				location = "莫特雷·加玛森（湿地 - 丹莫德; "..YELLOW.."49,18 "..WHITE.."）",
				level = 27,
				rewards = {
					[1] = {
						name = "辩护腰带 ",
						id = 3562,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_05",
						quality = 2,
					},
					[2] = {
						name = "碎头者",
						id = 1264,
						subtext = "双手 锤",
						icon = "INV_Mace_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
			},
			[6] = {
				note = "前导任务详情请参见"..YELLOW.."[死亡矿井][迪菲亚兄弟会]"..WHITE..".。\n巴基尔·斯瑞德在"..YELLOW.."[4]"..WHITE.."。",
				followup = "好奇的访客", -- 392
				attain = 16,
				aim = "杀死巴基尔·斯瑞德，把他的头带给监狱的典狱官塞尔沃特。",
				title = "监狱暴动（系列任务）", -- 391
				location = "暴风城的典狱官塞尔沃特要求你杀死监狱中的10名迪菲亚囚徒、8名迪菲亚罪犯和8名迪菲亚叛军。",
				level = 29,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "前导任务详情请参见"..YELLOW.."[死亡矿井][迪菲亚兄弟会]"..WHITE..".。\n巴基尔·斯瑞德在"..YELLOW.."[4]"..WHITE.."。",
			},
			[7] = {
				note = "你可以在副本入口对面的房间里的密封文件箱 "..YELLOW.."[1]"..WHITE.." 中找到马丁·科林斯的信息。\n任务线从洛德指挥官莱克（湿地 - 鹰巢哨站 "..YELLOW.."36.4,67.3"..WHITE.."）的任务\'揭开谜团\'开始。\n完成任务线的最后一个任务后，你将获得奖励。",
				followup = "调查科林斯",
				attain = 18,
				aim = "深入监狱，找到关于马丁·科林斯的信息。",
				title = "你需要超维度幽灵显形器才能看到伯德雷。你可以从《寻找安泰恩》任务得到它。召唤伊萨利恩在"..YELLOW.."[5]"..WHITE.."。",
				location = "马修斯·肖 <暗影议会领袖>（暴风城 - 老城区，盗贼区；"..YELLOW.."75.8,59.8"..WHITE.."）",
				level = 24,
				rewards = {
					[1] = {
						name = "勇士勋章", --81416
						id = 81416,
						subtext = "颈部",
						icon = "INV_Jewelry_Amulet_03",
						quality = 3,
					},
					[2] = {
						name = "环境护符", --81417
						id = 81417,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_01",
						quality = 3,
					},
					[3] = {
						name = "华丽项链", --81418
						id = 81418,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_04",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "罗布的报告",
			},
		},
		[2] = {
		},
	},
	[28] = {
		name = "在"..YELLOW.."[艾萨拉]"..WHITE.."的峭壁击碎者身上收集一个绑定碎片，从"..YELLOW.."[厄运之槌西]"..WHITE.."的秘法洪流中获得奥术过载棱镜，从"..YELLOW.."[沉没的神庙]"..WHITE.."的沉睡绿龙身上收集一个沉睡者的碎片，还需要一根奥金棒。将收集到的物品带给悲伤沼泽的伊萨里奥斯。",
		story = "在一千年之前，强大的古拉巴什王国被一次大型内部战争所毁灭。一部份被称为阿塔莱的巨魔牧师试图将古代血神哈卡灵魂掠夺者带回这个世界。虽然这些牧师被击败并最终被流放，这个伟大的王国变得四分五裂。流放的牧师逃到了北面，来到了悲伤沼泽。他们为哈卡建立了一座伟大的神庙——在那里他们期望能够把哈卡重新带回世间。伟大的守护神龙伊瑟拉了解了阿塔莱的计划并将神庙摧毁沉入沼泽之中。在今天，神庙沉没的遗迹被绿龙所守卫并阻止任何人进入或者出去。然而，有些阿塔莱巨魔从伊瑟拉的怒火中幸存下来并再此奖自己奉献与复活哈卡的事业中。 ",
		[1] = {
			[1] = {
				note = "前导任务在此领取。\n\n石板你在神庙内外里到处都能见到。",
				followup = "无后续",
				attain = 41,
				aim = "为暴风城的布罗哈恩·铁桶收集10块阿塔莱石板。",
				title = "进入阿塔哈卡神庙", -- 1475
				location = "布罗哈恩·铁桶（暴风城 - 矮人区; "..YELLOW.."64,20"..WHITE.."）",
				level = 50,
				rewards = {
					[1] = {
						name = "守护之符",
						id = 1490,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_05",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "调查神庙 -> 拉普索迪的故事", -- 1448 -> 1469
			},
			[2] = {
				note = "祭坛位于 "..YELLOW.."[1]"..WHITE.."。\n联盟任务线从安吉拉斯·月风（菲拉斯 - 羽月要塞 "..YELLOW.."31.8,45.6"..WHITE.."）的任务“沉没的神庙”开始。\n部落任务线从巫医乌泽里（菲拉斯 - 莫沙彻营地 "..YELLOW.."74.4,43.4"..WHITE.."）的任务“沉没的神庙”开始。",
				followup = "雕像群的秘密", -- 3447
				attain = 46,
				aim = "在悲伤沼泽沉没的神庙中找到哈卡祭坛。",
				title = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
				location = "玛尔冯·瑞文斯克（塔纳利斯; "..YELLOW.."52,45"..WHITE.."）",
				level = 51,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "石环", -- 3444
			},
			[3] = {
				note = "雕像群就在图中"..YELLOW.."[1]"..WHITE.."所示位置，按照地图指示的顺序打开他们。",
				followup = "无后续",
				attain = 46,
				aim = "到沉没的神庙去，揭开雕像群中隐藏的秘密。",
				title = "雕像群的秘密", -- 3447
				location = "在悲伤沼泽沉没的神庙中找到哈卡祭坛。",
				level = 51,
				rewards = {
					[1] = {
						name = "哈卡莱骨灰",
						id = 10773,
						subtext = "物品",
						icon = "INV_Box_01",
						quality = 2,
					},
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
			},
			[4] = {
				note = "前导任务《穆尔金和拉瑞安》开始于穆尔金（安戈洛环形山 - 马绍尔营地; "..YELLOW.."42,9"..WHITE.."）。你可以从阿塔哈卡神庙里的神庙深渊潜伏者、黑暗虫或者融合软泥怪那里得到阿塔莱之雾。",
				followup = "无后续",
				attain = 47,
				aim = "收集5份阿塔莱之雾的样本，然后向安戈洛环形山的穆尔金复命。",
				title = "邪恶之雾", -- 4143
				location = "格雷甘·山酒（菲拉斯; "..YELLOW.."45,25"..WHITE.."）",
				level = 52,
				rewards = {
				},
				prequest = "穆尔金和拉瑞安 -> 造访格雷甘", -- 4141 -> 4142
			},
			[5] = {
				note = "此系列任务始于《尖啸者的灵魂》（同样在此领取，见"..YELLOW.."[祖儿法拉克]"..WHITE.."）。\n你必须在"..YELLOW.."[3]"..WHITE.."使用哈卡之卵，触发事件。一旦事件开始，敌人会像潮水般涌出来攻击你。其中一些敌人掉落哈卡莱之血。用这些血液熄灭包含哈卡灵魂能量的不灭火焰。当你熄灭所有的火焰时，哈卡的化身就可以进入我们的世界了。",
				followup = "无后续",
				attain = 40,
				aim = "将装满的哈卡之卵交给塔纳利斯的叶基亚。",
				title = "神灵哈卡（系列任务）", -- 3528
				location = "叶基亚（塔纳利斯 - 热砂港; "..YELLOW.."66,22"..WHITE.."）",
				level = 53,
				rewards = {
					[1] = {
						name = "灰岩头盔",
						id = 10749,
						subtext = "头部，板甲",
						icon = "INV_Helmet_22",
						quality = 3,
					},
					[2] = {
						name = "生命之力短剑",
						id = 10750,
						subtext = "单手 匕首",
						icon = "INV_Sword_21",
						quality = 3,
					},
					[3] = {
						name = "珠光头饰",
						id = 10751,
						subtext = "头部 布甲",
						icon = "INV_Crown_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "尖啸者的灵魂 -> 远古之卵", -- 3520 -> 4787
			},
			[6] = {
				note = "你可以在"..YELLOW.."[4]"..WHITE.."找到迦玛兰。",
				followup = "无后续",
				attain = 38,
				aim = "辛特兰的阿塔莱流放者要你给他带回迦玛兰的头。",
				title = "从预言者贾玛尔安处获得阿塔莱法杖 "..YELLOW.."[4]"..WHITE.."。\n任务线从大先知哈兹戈尔格（荆棘谷 - 吉利吉姆的小岛（从藏宝海湾向西） - 莫尔奥格避难所）开始。\n完成任务线的最后一个任务后，你将获得奖励。",
				location = "辛特兰的阿塔莱流放者要你给他带回迦玛兰的头。",
				level = 53,
				rewards = {
					[1] = {
						name = "雨行护腿",
						id = 11123,
						subtext = "腿部 布甲",
						icon = "INV_Pants_08",
						quality = 3,
					},
					[2] = {
						name = "流放者头盔",
						id = 11124,
						subtext = "头部 锁甲",
						icon = "INV_Helmet_21",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "你会在伊兰尼库斯的阴影所在的地方找到精华之泉，位置在 "..YELLOW.."[8]"..WHITE.."。\n"..RED.."不要"..WHITE.."出售或丢弃奖励饰品伊兰尼库斯精华。你将需要它来完成下一个任务，任务接受者是伊萨里乌斯（悲伤沼泽 - 伊萨里乌斯的洞穴 "..YELLOW.."[13.6,71.7]"..WHITE..")，与他交谈后你将获得一个物品，开始该任务。",
				followup = "伊兰尼库斯精华", -- 3373
				attain = 48,
				aim = "把伊兰尼库斯精华放在精华之泉里，精华之泉就在沉没的神庙中，伊兰尼库斯的巢穴里。",
				title = "伊兰尼库斯精华", -- 3373
				location = "伊兰尼库斯精华（伊兰尼库斯的阴影掉落; "..YELLOW.."[8]"..WHITE.."）",
				level = 55,
				rewards = {
					[1] = {
						name = "你会在伊兰尼库斯的阴影所在的地方找到精华之泉，位置在 "..YELLOW.."[8]"..WHITE.."。\n"..RED.."不要"..WHITE.."出售或丢弃奖励饰品伊兰尼库斯精华。你将需要它来完成下一个任务，任务接受者是伊萨里乌斯（悲伤沼泽 - 伊萨里乌斯的洞穴 "..YELLOW.."[13.6,71.7]"..WHITE..")，与他交谈后你将获得一个物品，开始该任务。",
						id = 10455,
						subtext = "饰品",
						icon = "INV_Stone_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "术士职业任务。6小巨魔每只掉一个羽毛。",
				followup = "无后续",
				attain = 50,
				aim = "到沉没的神庙去，从巨魔们身上获得6支巫毒羽毛。",
				title = "萨满职业任务。6小巨魔每只掉一个羽毛。",
				location = "伊普斯（费伍德森林; "..YELLOW.."42,45"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "灵魂收割者",
						id = 20536,
						subtext = "法杖",
						icon = "INV_Sword_48",
						quality = 3,
					},
					[2] = {
						name = "深渊碎片",
						id = 20534,
						subtext = "饰品",
						icon = "INV_Misc_Gem_02",
						quality = 3,
					},
					[3] = {
						name = "束缚长袍",
						id = 20530,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "小鬼的要求 -> 奇怪的材料", -- 8419 -> 8421
			},
			[9] = {
				note = "战士职业任务。6小巨魔每只掉一个羽毛。",
				followup = "无后续",
				attain = 50,
				aim = "将你从沉没的神庙的巨魔身上得到的巫毒羽毛交给部落英雄的灵魂。",
				title = "将巫毒羽毛带给阿什拉姆·瓦罗菲斯特。",
				location = "部落英雄的灵魂（尘泥沼泽; "..YELLOW.."34,66"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "怒火面甲",
						id = 20521,
						subtext = "头部，板甲",
						icon = "INV_Helmet_01",
						quality = 3,
					},
					[2] = {
						name = "钻石水瓶",
						id = 20130,
						subtext = "饰品",
						icon = "INV_Drink_01",
						quality = 3,
					},
					[3] = {
						name = "刺钢护肩",
						id = 20517,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_16",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "困扰的灵魂  -> 魔誓者之战", -- 8417 -> 8424
			},
			[10] = {
				note = "德鲁伊职业任务。腐烂藤蔓掉落自召唤的阿塔拉利恩"..YELLOW.."[1]"..WHITE.."，必须正确的破解雕像群的秘密。",
				followup = "无后续",
				attain = 50,
				aim = "从沉没的神庙底部的守卫身上得到一些腐烂藤蔓，把它们交给托尔瓦·寻路者。",
				title = "更好的材料（德鲁伊任务）", -- 9053
				location = "托尔瓦·寻路者（安戈洛环形山; "..YELLOW.."72,76"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "斑白毛皮",
						id = 22274,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Leather_08",
						quality = 3,
					},
					[2] = {
						name = " 森林的拥抱",
						id = 22272,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Leather_08",
						quality = 3,
					},
					[3] = {
						name = "月影手杖",
						id = 22458,
						subtext = "法杖",
						icon = "INV_Staff_28",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "托尔瓦·寻路者 -> 毒性测试", -- 9063 -> 9051
			},
			[11] = {
				note = "猎人职业任务。摩弗拉斯在"..YELLOW.."[5]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "将摩弗拉斯的牙齿交给艾萨拉的奥汀克。他住在埃达拉斯废墟东北部悬崖的顶端。",
				title = "神庙中的绿龙（猎人任务）", -- 8232
				location = "将摩弗拉斯的牙齿交给艾萨拉的奥汀克。他住在埃达拉斯废墟东北部悬崖的顶端。",
				level = 52,
				rewards = {
					[1] = {
						name = "狩猎长矛",
						id = 20083,
						subtext = "长柄武器",
						icon = "INV_Spear_02",
						quality = 3,
					},
					[2] = {
						name = "魔暴龙眼",
						id = 19991,
						subtext = "饰品",
						icon = "INV_Misc_Eye_01",
						quality = 3,
					},
					[3] = {
						name = "魔暴龙牙",
						id = 19992,
						subtext = "饰品",
						icon = "INV_Misc_Bone_07",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "猎人的护符 -> 碎浪多头怪", -- 8151 -> 8231
			},
			[12] = {
				note = "法师职业任务。摩弗拉斯在"..YELLOW.."[5]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "从摩弗拉斯身上取回奥术碎片，然后返回大法师克希雷姆那儿。",
				title = "毁灭摩弗拉斯（法师任务）", -- 8253
				location = "大法师克希雷姆，摩弗拉斯（艾萨拉; "..YELLOW.."29,40"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "冰川之矛",
						id = 20035,
						subtext = "匕首",
						icon = "INV_Weapon_ShortBlade_06",
						quality = 3,
					},
					[2] = {
						name = "奥术水晶坠饰",
						id = 20037,
						subtext = "颈部",
						icon = "INV_Misc_Gem_Topaz_01",
						quality = 3,
					},
					[3] = {
						name = "火焰宝石",
						id = 20036,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Bloodstone_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "法师的会见 -> 纳迦的珊瑚", -- 8251 -> 8252
			},
			[13] = {
				note = "牧师职业任务。摩弗拉斯 在"..YELLOW.."[5]"..WHITE.."。 格雷塔·苔蹄在（费伍德森林 - 翡翠圣地; "..YELLOW.."51,82"..WHITE.."）。",
				followup = "无后续",
				attain = 50,
				aim = "前往沉没的阿塔哈卡神庙，杀死绿龙摩弗拉斯，将他的血液交给费伍德森林中的格雷塔·苔蹄。沉没的神庙的入口就在悲伤沼泽中。",
				title = "摩弗拉斯之血（牧师任务）", -- 8257
				location = "将摩弗拉斯的牙齿交给艾萨拉的奥汀克。他住在埃达拉斯废墟东北部悬崖的顶端。",
				level = 52,
				rewards = {
					[1] = {
						name = "祝福珠串",
						id = 19990,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_11",
						quality = 3,
					},
					[2] = {
						name = "悲哀之杖",
						id = 20082,
						subtext = "魔杖",
						icon = "INV_Wand_09",
						quality = 3,
					},
					[3] = {
						name = "希望之环",
						id = 20006,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_32",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "塞纳里奥议会的求助 -> 亡灵的腐液", -- 8254 -> 8256
			},
			[14] = {
				note = "盗贼职业任务。摩弗拉斯"..YELLOW.."[5]"..WHITE.."掉落钥匙。乔拉齐·拉文霍德公爵在（奥特兰克山谷 - 拉文霍德; "..YELLOW.."86,79"..WHITE.."）。",
				followup = "无后续",
				attain = 50,
				aim = "将碧蓝钥匙交给乔拉齐·拉文霍德公爵。",
				title = "碧蓝钥匙（盗贼任务）", -- 8236
				location = "大法师克希雷姆，摩弗拉斯（艾萨拉; "..YELLOW.."29,40"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "乌黑面具",
						id = 19984,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_30",
						quality = 3,
					},
					[2] = {
						name = "耳语长靴",
						id = 20255,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_Cloth_05",
						quality = 3,
					},
					[3] = {
						name = "暗色蝠斗篷",
						id = 19982,
						subtext = "背部",
						icon = "INV_Misc_Cape_20",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "简单的要求 -> 密文碎片", -- 8233 -> 8235
			},
			[15] = {
				note = "圣骑士职业任务。6小巨魔一只掉一个。",
				followup = "无后续",
				attain = 50,
				aim = "将巫毒羽毛带给阿什拉姆·瓦罗菲斯特。",
				title = "铸造力量之石（圣骑士任务）", -- 8418
				location = "阿什拉姆·瓦罗菲斯特（西瘟疫之地 - 寒风营地; "..YELLOW.."43,85"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "神圣力量之石",
						id = 20620,
						subtext = "物品",
						icon = "INV_Stone_15",
						quality = 1,
					},
					[2] = {
						name = "光铸利刃",
						id = 20504,
						subtext = "剑",
						icon = "INV_Sword_39",
						quality = 3,
					},
					[3] = {
						name = "神圣宝珠",
						id = 20512,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Pearl_04",
						quality = 3,
					},
					[4] = {
						name = "礼节徽记",
						id = 20505,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_43",
						quality = 3,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "堕落者的天灾石", -- 8416
			},
			[16] = {
				note = "森林小精灵 (泰达希尔; "..YELLOW.."37,47"..WHITE..")",
				followup = "泰兰德和雷姆洛斯", --8734
				attain = 60,
				aim = "前往泰达希尔大陆某处和达纳苏斯墙外找到玛法里奥.",
				title = "伊兰尼库斯，梦境之暴君", -- 8733
				location = "玛法里奥·怒风 (只在树荫下的伊兰尼库斯; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "守护之龙", -- 8555
			},
			[17] = {
				note = "哈扎斯是倒数第二个boss前的房间里飞行的龙人boss "..YELLOW.."[7]"..WHITE.."。\n完成下一个任务后，你将获得奖励。",
				followup = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				attain = 47,
				aim = "前往沉没的神庙，找到龙人哈扎斯，击败他，并将哈扎斯之心交给尼雷米斯·黑风。",
				title = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				location = "尼雷米斯·黑风 <恶魔猎手>（费伍德森林；"..YELLOW.."39.8,29.6"..WHITE.."）",
				level = 53,
				rewards = {
					[1] = {
						name = "黑风战刃", --60536
						id = 60536,
						subtext = "单手 剑",
						icon = "INV_Spear_08",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "不择手段 III", -- 40399
			},
			[18] = {
				note = "编织者 "..YELLOW.."[6]"..WHITE.." 是4只龙中的一只，掉落沉睡者的碎片，杀死预言者贾玛兰后才会出现 "..YELLOW.."[4]"..WHITE.."。清理6个阳台 "..BLUE.."[C]"..WHITE.." 后，通往预言者的屏障将消失。\n完成这个任务线后，你将获得项链，并能够进入海加尔山的副本团队副本翡翠圣殿。",
				followup = "(TW)21. 寐入梦境III", -- 40959
				attain = 58,
				aim = "在"..YELLOW.."[艾萨拉]"..WHITE.."的峭壁击碎者身上收集一个绑定碎片，从"..YELLOW.."[厄运之槌西]"..WHITE.."的秘法洪流中获得奥术过载棱镜，从"..YELLOW.."[沉没的神庙]"..WHITE.."的沉睡绿龙身上收集一个沉睡者的碎片，还需要一根奥金棒。将收集到的物品带给悲伤沼泽的伊萨里奥斯。",
				title = "(TW)21. 寐入梦境III", -- 40959
				location = "拉拉修斯（海加尔山 - 诺达纳尔；"..YELLOW.."[81.6,27.7]"..WHITE.." 一只绿色龙人）",
				level = 60,
				rewards = {
					[1] = {
						name = "伊瑟拉宝钻", -- 50545
						id = 50545,
						subtext = "颈部",
						icon = "INV_Misc_Gem_Emerald_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "(TW)21. 寐入梦境III", -- 40959
			},
		},
		[2] = {
			[1] = {
				note = "神庙中的所有敌人都会掉落巫术妖术。任务线从费泽鲁尔（悲伤沼泽 - 斯通纳德; "..YELLOW.."47,54"..WHITE.."）开始。",
				followup = "无后续",
				attain = 38,
				aim = "收集20个哈卡神像，把它们带给斯通纳德的费泽鲁尔。",
				title = "进入阿塔哈卡神庙", -- 1475
				location = "费泽鲁尔（悲伤沼泽 - 斯通纳德; "..YELLOW.."47,54"..WHITE.."）",
				level = 50,
				rewards = {
					[1] = {
						name = "守护之符",
						id = 1490,
						subtext = "饰品",
						icon = "INV_Jewelry_Talisman_05",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "泪水之池 -> 向费泽鲁尔复命", -- 1424 -> 1444
			},
			[2] = {
				note = "祭坛位于 "..YELLOW.."[1]"..WHITE.."。\n联盟任务线从安吉拉斯·月风（菲拉斯 - 羽月要塞 "..YELLOW.."31.8,45.6"..WHITE.."）的任务“沉没的神庙”开始。\n部落任务线从巫医乌泽里（菲拉斯 - 莫沙彻营地 "..YELLOW.."74.4,43.4"..WHITE.."）的任务“沉没的神庙”开始。",
				followup = "雕像群的秘密", -- 3447
				attain = 46,
				aim = "在悲伤沼泽沉没的神庙中找到哈卡祭坛。",
				title = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
				location = "玛尔冯·瑞文斯克（塔纳利斯; "..YELLOW.."52,45"..WHITE.."）",
				level = 51,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "石环", -- 3444
			},
			[3] = {
				note = "雕像群就在图中"..YELLOW.."[1]"..WHITE.."所示位置，按照地图指示的顺序打开他们。",
				followup = "无后续",
				attain = 46,
				aim = "到沉没的神庙去，揭开雕像群中隐藏的秘密。",
				title = "雕像群的秘密", -- 3447
				location = "在悲伤沼泽沉没的神庙中找到哈卡祭坛。",
				level = 51,
				rewards = {
					[1] = {
						name = "哈卡莱骨灰",
						id = 10773,
						subtext = "物品",
						icon = "INV_Box_01",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "熔火之心就在黑石深渊的底层。这是黑石山的中心，也是很久以前扭转矮人内战情势的地方，索瑞森大帝将元素火焰之王，拉格纳罗斯召唤到世界来。尽管火焰之王无法远离熔火之心，但人们相信他的元素爪牙控制着黑铁矮人，在遗迹之外组建军队。拉格纳罗斯休眠的燃烧之湖有一道裂缝连接火平面，让邪恶的元素可以通过。拉格纳罗斯的首要代理人是管理者埃克索图斯——因为这是唯一能唤醒火焰之王的狡猾元素。",
			},
			[4] = {
				note = "前导任务《拉瑞安和穆尔金》开始于拉瑞安（安戈洛环形山; "..YELLOW.."45,8"..WHITE.."）。沉没的神庙里的神庙深渊潜伏者、黑暗虫和软泥怪身上都有阿塔莱之雾。",
				followup = "无后续",
				attain = 47,
				aim = "收集5份阿塔莱之雾的样本，然后将它们送到马绍尔营地的拉瑞安那里。",
				title = "除草器的燃料", -- 4146
				location = "莉芙·雷兹菲克斯（贫瘠之地; "..YELLOW.."62,38"..WHITE.."）",
				level = 52,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "拉瑞安和穆尔金 > 玛尔冯的车间", -- 4145 -> 4147
			},
			[5] = {
				note = "此系列任务始于《尖啸者的灵魂》（同样在此领取，见"..YELLOW.."[祖儿法拉克]"..WHITE.."）。\n你必须在"..YELLOW.."[3]"..WHITE.."使用哈卡之卵，触发事件。一旦事件开始，敌人会像潮水般涌出来攻击你。其中一些敌人掉落哈卡莱之血。用这些血液熄灭包含哈卡灵魂能量的不灭火焰。当你熄灭所有的火焰时，哈卡的化身就可以进入我们的世界了。",
				followup = "无后续",
				attain = 40,
				aim = "将装满的哈卡之卵交给塔纳利斯的叶基亚。",
				title = "神灵哈卡（系列任务）", -- 3528
				location = "叶基亚（塔纳利斯 - 热砂港; "..YELLOW.."66,22"..WHITE.."）",
				level = 53,
				rewards = {
					[1] = {
						name = "灰岩头盔",
						id = 10749,
						subtext = "头部，板甲",
						icon = "INV_Helmet_22",
						quality = 3,
					},
					[2] = {
						name = "生命之力短剑",
						id = 10750,
						subtext = "单手 匕首",
						icon = "INV_Sword_21",
						quality = 3,
					},
					[3] = {
						name = "珠光头饰",
						id = 10751,
						subtext = "头部 布甲",
						icon = "INV_Crown_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "尖啸者的灵魂 -> 远古之卵", -- 3520 -> 4787
			},
			[6] = {
				note = "你可以在"..YELLOW.."[4]"..WHITE.."找到迦玛兰。",
				followup = "无后续",
				attain = 38,
				aim = "辛特兰的阿塔莱流放者要你给他带回迦玛兰的头。",
				title = "从预言者贾玛尔安处获得阿塔莱法杖 "..YELLOW.."[4]"..WHITE.."。\n任务线从大先知哈兹戈尔格（荆棘谷 - 吉利吉姆的小岛（从藏宝海湾向西） - 莫尔奥格避难所）开始。\n完成任务线的最后一个任务后，你将获得奖励。",
				location = "辛特兰的阿塔莱流放者要你给他带回迦玛兰的头。",
				level = 53,
				rewards = {
					[1] = {
						name = "雨行护腿",
						id = 11123,
						subtext = "腿部 布甲",
						icon = "INV_Pants_08",
						quality = 3,
					},
					[2] = {
						name = "流放者头盔",
						id = 11124,
						subtext = "头部 锁甲",
						icon = "INV_Helmet_21",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "你会在伊兰尼库斯的阴影所在的地方找到精华之泉，位置在 "..YELLOW.."[8]"..WHITE.."。\n"..RED.."不要"..WHITE.."出售或丢弃奖励饰品伊兰尼库斯精华。你将需要它来完成下一个任务，任务接受者是伊萨里乌斯（悲伤沼泽 - 伊萨里乌斯的洞穴 "..YELLOW.."[13.6,71.7]"..WHITE..")，与他交谈后你将获得一个物品，开始该任务。",
				followup = "伊兰尼库斯精华", -- 3373
				attain = 48,
				aim = "把伊兰尼库斯精华放在精华之泉里，精华之泉就在沉没的神庙中，伊兰尼库斯的巢穴里。",
				title = "伊兰尼库斯精华", -- 3373
				location = "伊兰尼库斯精华（伊兰尼库斯的阴影掉落; "..YELLOW.."[8]"..WHITE.."）",
				level = 55,
				rewards = {
					[1] = {
						name = "你会在伊兰尼库斯的阴影所在的地方找到精华之泉，位置在 "..YELLOW.."[8]"..WHITE.."。\n"..RED.."不要"..WHITE.."出售或丢弃奖励饰品伊兰尼库斯精华。你将需要它来完成下一个任务，任务接受者是伊萨里乌斯（悲伤沼泽 - 伊萨里乌斯的洞穴 "..YELLOW.."[13.6,71.7]"..WHITE..")，与他交谈后你将获得一个物品，开始该任务。",
						id = 10455,
						subtext = "饰品",
						icon = "INV_Stone_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "术士职业任务。6小巨魔每只掉一个羽毛。",
				followup = "无后续",
				attain = 50,
				aim = "到沉没的神庙去，从巨魔们身上获得6支巫毒羽毛。",
				title = "萨满职业任务。6小巨魔每只掉一个羽毛。",
				location = "伊普斯（费伍德森林; "..YELLOW.."42,45"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "灵魂收割者",
						id = 20536,
						subtext = "法杖",
						icon = "INV_Sword_48",
						quality = 3,
					},
					[2] = {
						name = "深渊碎片",
						id = 20534,
						subtext = "饰品",
						icon = "INV_Misc_Gem_02",
						quality = 3,
					},
					[3] = {
						name = "束缚长袍",
						id = 20530,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "小鬼的要求 -> 奇怪的材料", -- 8419 -> 8421
			},
			[9] = {
				note = "战士职业任务。6小巨魔每只掉一个羽毛。",
				followup = "无后续",
				attain = 50,
				aim = "将你从沉没的神庙的巨魔身上得到的巫毒羽毛交给部落英雄的灵魂。",
				title = "将巫毒羽毛带给阿什拉姆·瓦罗菲斯特。",
				location = "部落英雄的灵魂（尘泥沼泽; "..YELLOW.."34,66"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "怒火面甲",
						id = 20521,
						subtext = "头部，板甲",
						icon = "INV_Helmet_01",
						quality = 3,
					},
					[2] = {
						name = "钻石水瓶",
						id = 20130,
						subtext = "饰品",
						icon = "INV_Drink_01",
						quality = 3,
					},
					[3] = {
						name = "刺钢护肩",
						id = 20517,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_16",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "困扰的灵魂  -> 魔誓者之战", -- 8417 -> 8424
			},
			[10] = {
				note = "德鲁伊职业任务。腐烂藤蔓掉落自召唤的阿塔拉利恩"..YELLOW.."[1]"..WHITE.."，必须正确的破解雕像群的秘密。",
				followup = "无后续",
				attain = 50,
				aim = "从沉没的神庙底部的守卫身上得到一些腐烂藤蔓，把它们交给托尔瓦·寻路者。",
				title = "更好的材料（德鲁伊任务）", -- 9053
				location = "托尔瓦·寻路者（安戈洛环形山; "..YELLOW.."72,76"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "斑白毛皮",
						id = 22274,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Leather_08",
						quality = 3,
					},
					[2] = {
						name = " 森林的拥抱",
						id = 22272,
						subtext = "胸部 皮甲",
						icon = "INV_Chest_Leather_08",
						quality = 3,
					},
					[3] = {
						name = "月影手杖",
						id = 22458,
						subtext = "法杖",
						icon = "INV_Staff_28",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "托尔瓦·寻路者 -> 毒性测试", -- 9063 -> 9051
			},
			[11] = {
				note = "猎人职业任务。摩弗拉斯在"..YELLOW.."[5]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "将摩弗拉斯的牙齿交给艾萨拉的奥汀克。他住在埃达拉斯废墟东北部悬崖的顶端。",
				title = "神庙中的绿龙（猎人任务）", -- 8232
				location = "将摩弗拉斯的牙齿交给艾萨拉的奥汀克。他住在埃达拉斯废墟东北部悬崖的顶端。",
				level = 52,
				rewards = {
					[1] = {
						name = "狩猎长矛",
						id = 20083,
						subtext = "长柄武器",
						icon = "INV_Spear_02",
						quality = 3,
					},
					[2] = {
						name = "魔暴龙眼",
						id = 19991,
						subtext = "饰品",
						icon = "INV_Misc_Eye_01",
						quality = 3,
					},
					[3] = {
						name = "魔暴龙牙",
						id = 19992,
						subtext = "饰品",
						icon = "INV_Misc_Bone_07",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "猎人的护符 -> 碎浪多头怪", -- 8151 -> 8231
			},
			[12] = {
				note = "法师职业任务。摩弗拉斯在"..YELLOW.."[5]"..WHITE.."。",
				followup = "无后续",
				attain = 50,
				aim = "从摩弗拉斯身上取回奥术碎片，然后返回大法师克希雷姆那儿。",
				title = "毁灭摩弗拉斯（法师任务）", -- 8253
				location = "大法师克希雷姆，摩弗拉斯（艾萨拉; "..YELLOW.."29,40"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "冰川之矛",
						id = 20035,
						subtext = "匕首",
						icon = "INV_Weapon_ShortBlade_06",
						quality = 3,
					},
					[2] = {
						name = "奥术水晶坠饰",
						id = 20037,
						subtext = "颈部",
						icon = "INV_Misc_Gem_Topaz_01",
						quality = 3,
					},
					[3] = {
						name = "火焰宝石",
						id = 20036,
						subtext = "饰品",
						icon = "INV_Misc_Gem_Bloodstone_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "法师的会见 -> 纳迦的珊瑚", -- 8251 -> 8252
			},
			[13] = {
				note = "牧师职业任务。摩弗拉斯 在"..YELLOW.."[5]"..WHITE.."。 格雷塔·苔蹄在（费伍德森林 - 翡翠圣地; "..YELLOW.."51,82"..WHITE.."）。",
				followup = "无后续",
				attain = 50,
				aim = "前往沉没的阿塔哈卡神庙，杀死绿龙摩弗拉斯，将他的血液交给费伍德森林中的格雷塔·苔蹄。沉没的神庙的入口就在悲伤沼泽中。",
				title = "摩弗拉斯之血（牧师任务）", -- 8257
				location = "将摩弗拉斯的牙齿交给艾萨拉的奥汀克。他住在埃达拉斯废墟东北部悬崖的顶端。",
				level = 52,
				rewards = {
					[1] = {
						name = "祝福珠串",
						id = 19990,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_11",
						quality = 3,
					},
					[2] = {
						name = "悲哀之杖",
						id = 20082,
						subtext = "魔杖",
						icon = "INV_Wand_09",
						quality = 3,
					},
					[3] = {
						name = "希望之环",
						id = 20006,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_32",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "塞纳里奥议会的求助 -> 亡灵的腐液", -- 8254 -> 8256
			},
			[14] = {
				note = "盗贼职业任务。摩弗拉斯"..YELLOW.."[5]"..WHITE.."掉落钥匙。乔拉齐·拉文霍德公爵在（奥特兰克山谷 - 拉文霍德; "..YELLOW.."86,79"..WHITE.."）。",
				followup = "无后续",
				attain = 50,
				aim = "将碧蓝钥匙交给乔拉齐·拉文霍德公爵。",
				title = "碧蓝钥匙（盗贼任务）", -- 8236
				location = "大法师克希雷姆，摩弗拉斯（艾萨拉; "..YELLOW.."29,40"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "乌黑面具",
						id = 19984,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_30",
						quality = 3,
					},
					[2] = {
						name = "耳语长靴",
						id = 20255,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_Cloth_05",
						quality = 3,
					},
					[3] = {
						name = "暗色蝠斗篷",
						id = 19982,
						subtext = "背部",
						icon = "INV_Misc_Cape_20",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "简单的要求 -> 密文碎片", -- 8233 -> 8235
			},
			[15] = {
				note = "萨满职业任务。6小巨魔每只掉一个羽毛。",
				followup = "无后续",
				attain = 50,
				aim = "将巫毒羽毛交给捕风者巴斯拉。",
				title = "将巫毒羽毛带给阿什拉姆·瓦罗菲斯特。",
				location = "捕风者巴斯拉（奥特兰克山脉; "..YELLOW.."80,67"..WHITE.."）",
				level = 52,
				rewards = {
					[1] = {
						name = "蓝铜之拳",
						id = 20369,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_30",
						quality = 3,
					},
					[2] = {
						name = "被迷惑的水之魂",
						id = 20503,
						subtext = "饰品",
						icon = "INV_Wand_01",
						quality = 3,
					},
					[3] = {
						name = "荒野之杖",
						id = 20556,
						subtext = "法杖",
						icon = "INV_Staff_Goldfeathered_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "灵魂图腾", -- 8412
			},
			[16] = {
				note = "森林小精灵 (泰达希尔; "..YELLOW.."37,47"..WHITE..")",
				followup = "泰兰德和雷姆洛斯", --8734
				attain = 60,
				aim = "前往泰达希尔大陆某处和达纳苏斯墙外找到玛法里奥.",
				title = "伊兰尼库斯，梦境之暴君", -- 8733
				location = "玛法里奥·怒风 (只在树荫下的伊兰尼库斯; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "守护之龙", -- 8555
			},
			[17] = {
				note = "哈扎斯是倒数第二个boss前的房间里飞行的龙人boss "..YELLOW.."[7]"..WHITE.."。\n完成下一个任务后，你将获得奖励。",
				followup = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				attain = 47,
				aim = "前往沉没的神庙，找到龙人哈扎斯，击败他，并将哈扎斯之心交给尼雷米斯·黑风。",
				title = "到厄运之槌去找到小鬼普希林。你可以使用任何手段从小鬼那里得到埃斯托尔迪的咒术之书。",
				location = "尼雷米斯·黑风 <恶魔猎手>（费伍德森林；"..YELLOW.."39.8,29.6"..WHITE.."）",
				level = 53,
				rewards = {
					[1] = {
						name = "黑风战刃", --60536
						id = 60536,
						subtext = "单手 剑",
						icon = "INV_Spear_08",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "不择手段 III", -- 40399
			},
			[18] = {
				note = "从预言者贾玛尔安处获得阿塔莱法杖 "..YELLOW.."[4]"..WHITE.."。\n任务线从大先知哈兹戈尔格（荆棘谷 - 吉利吉姆的小岛（从藏宝海湾向西） - 莫尔奥格避难所）开始。\n完成任务线的最后一个任务后，你将获得奖励。",
				followup = "莫尔奥格危机 VIII", -- 40271
				attain = 45,
				aim = "进入阿塔哈卡神庙的深处，收集阿塔莱法杖，将其交给因索姆尼完成咒语。",
				title = "(TW)18. 摩尔危机VII", -- 40270
				location = "因索姆尼 <伟大的隐士>（卡松岛，吉利吉姆岛北部 "..YELLOW.."57.2,10.1"..WHITE.."）",
				level = 54,
				rewards = {
					[1] = {
						name = "食人魔披风", --60346
						id = 60346,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_23",
						quality = 3,
					},
					[2] = {
						name = "食人魔先知法杖", --60347
						id = 60347,
						subtext = "法杖",
						icon = "INV_Staff_06",
						quality = 3,
					},
					[3] = {
						name = "克鲁克佐格的青睐", --60348
						id = 60348,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "(TW)18. 摩尔危机VII", -- 40270
			},
			[19] = {
				note = "编织者 "..YELLOW.."[6]"..WHITE.." 是4只龙中的一只，掉落沉睡者的碎片，杀死预言者贾玛兰后才会出现 "..YELLOW.."[4]"..WHITE.."。清理6个阳台 "..BLUE.."[C]"..WHITE.." 后，通往预言者的屏障将消失。\n完成这个任务线后，你将获得项链，并能够进入海加尔山的副本团队副本翡翠圣殿。",
				followup = "(TW)21. 寐入梦境III", -- 40959
				attain = 58,
				aim = "在"..YELLOW.."[艾萨拉]"..WHITE.."的峭壁击碎者身上收集一个绑定碎片，从"..YELLOW.."[厄运之槌西]"..WHITE.."的秘法洪流中获得奥术过载棱镜，从"..YELLOW.."[沉没的神庙]"..WHITE.."的沉睡绿龙身上收集一个沉睡者的碎片，还需要一根奥金棒。将收集到的物品带给悲伤沼泽的伊萨里奥斯。",
				title = "(TW)21. 寐入梦境III", -- 40959
				location = "拉拉修斯（海加尔山 - 诺达纳尔；"..YELLOW.."[81.6,27.7]"..WHITE.." 一只绿色龙人）",
				level = 60,
				rewards = {
					[1] = {
						name = "伊瑟拉宝钻", -- 50545
						id = 50545,
						subtext = "颈部",
						icon = "INV_Misc_Gem_Emerald_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "(TW)21. 寐入梦境III", -- 40959
			},
		},
	},
	[29] = {
		name = "安其拉神殿",
		story = "在安其拉中心矗立着一座古老神庙综合体。它在史前时代就被建造，用以纪念伟大的神与提供其拉大军繁衍的场地。自数千年前的流沙之战结束后，其拉帝国的双子皇帝就被青铜龙阿纳克洛斯和暗夜精灵们以强大的魔法结界困在了神庙里。随着时间流逝，流沙权杖已被重组，魔法结界上的封印也逐渐消失，通往安其拉神庙深处的道路也再度敞开。那些被困在神庙地下蠢蠢欲动的其拉军团开始准备入侵。为了避免第二次流沙之战再度爆发、贪婪的虫群再次于卡利姆多大陆倾巢而出，无论如何一定要阻止它们。",
		[1] = {
			[1] = {
				note = "凯雷斯特拉兹（安其拉神殿; "..YELLOW.."[2\']"..WHITE.."）",
				followup = "卡利姆多的救世主", -- 8802
				attain = 60,
				aim = "将克苏恩之眼交给安其拉神殿的凯雷斯特拉兹。",
				title = "克苏恩的遗产", -- 8801
				location = "克苏恩之眼（克苏恩掉落; "..YELLOW.."[9]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "堕落神明咒符",
						id = 21712,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_02",
						quality = 4,
					},
					[2] = {
						name = "堕落神明披风",
						id = 21710,
						subtext = "背部",
						icon = "INV_Misc_Cape_10",
						quality = 4,
					},
					[3] = {
						name = "堕落神明之戒",
						id = 21709,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_AhnQiraj_02",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "交给安多葛斯（安其拉神殿; "..YELLOW.."[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 60,
				aim = "把上古其拉神器交给隐藏在神殿入口处的龙类。",
				title = "其拉的秘密", -- 8784
				location = "上古其拉神器（安其拉神殿随机掉落）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "凯雷斯特拉兹（安其拉神殿; "..YELLOW.."[2\']"..WHITE.."）",
				followup = "卡利姆多的救世主", -- 8802
				attain = 60,
				aim = "将克苏恩之眼交给安其拉神殿的凯雷斯特拉兹。",
				title = "克苏恩的遗产", -- 8801
				location = "克苏恩之眼（克苏恩掉落; "..YELLOW.."[9]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "堕落神明咒符",
						id = 21712,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_AhnQiraj_02",
						quality = 4,
					},
					[2] = {
						name = "堕落神明披风",
						id = 21710,
						subtext = "背部",
						icon = "INV_Misc_Cape_10",
						quality = 4,
					},
					[3] = {
						name = "堕落神明之戒",
						id = 21709,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_AhnQiraj_02",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "交给安多葛斯（安其拉神殿; "..YELLOW.."[1\']"..WHITE.."）。",
				followup = "无后续",
				attain = 60,
				aim = "把上古其拉神器交给隐藏在神殿入口处的龙类。",
				title = "其拉的秘密", -- 8784
				location = "上古其拉神器（安其拉神殿随机掉落）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
	},
	[30] = {
		name = "此系列任务始于《尖啸者的灵魂》（同样在此领取，见"..YELLOW.."[祖儿法拉克]"..WHITE.."）。\n你必须在"..YELLOW.."[3]"..WHITE.."使用哈卡之卵，触发事件。一旦事件开始，敌人会像潮水般涌出来攻击你。其中一些敌人掉落哈卡莱之血。用这些血液熄灭包含哈卡灵魂能量的不灭火焰。当你熄灭所有的火焰时，哈卡的化身就可以进入我们的世界了。",
		story = "日光暴晒下的这座城市是沙怒巨魔的家园，他们一向以来都以其无情和黑暗魔法而闻名。巨魔传说中有一把强大的名叫鞭笞者苏萨斯的武器能够让最弱小的人可以击败最强大的敌人。很久以前，这把武器被分成了两半。然而，有传言说这两半可以在祖尔法拉克任何地方找到。据说还有一批加基森派来的雇佣兵进入了城市并被困住。他们的命运还不得而知。但是也许最让人感到不安的是一头远古生物正沉睡在城市中心的一个神圣的水池中——它是一个半神，它会摧毁任何胆敢唤醒它的人。",
		[1] = {
			[1] = {
				note = "此系列任务始于狮鹫管理员沙拉克·鹰斧（辛特兰 - 蛮锤城堡; "..YELLOW.."9,44"..WHITE.."）。\n你可以在"..YELLOW.."[4]"..WHITE.."找到耐克鲁姆。",
				followup = "占卜", -- 2992
				attain = 40,
				aim = "将耐克鲁姆的徽章交给诅咒之地的萨迪斯·格希德。",
				title = "耐克鲁姆的徽章（系列任务）", -- 2991
				location = "萨迪斯·格希德（诅咒之地 - 守望堡; "..YELLOW.."66,19 "..WHITE.."）",
				level = 47,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "枯木巨魔的牢笼 -> 萨迪斯·格希德", -- 2988 -> 2990
			},
			[2] = {
				note = "每个巨魔都可能掉落调和剂。",
				followup = "无后续",
				attain = 40,
				aim = "收集20瓶巨魔调和剂，把它们交给加基森的特伦顿·轻锤。",
				title = "巨魔调和剂", -- 3042
				location = "特伦顿·轻锤（塔纳利斯 - 加基森; "..YELLOW.."51,28 "..WHITE.."）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "前导任务始于克拉兹克（荆棘谷 - 藏宝海湾; "..YELLOW.."25,77"..WHITE.."）。\n每个圣甲虫都可能掉落壳儿。大量圣甲虫集中在"..YELLOW.."[2]"..WHITE.."。",
				followup = "无后续",
				attain = 40,
				aim = "给加基森的特兰雷克带去5个完整的圣甲虫壳。",
				title = "圣甲虫的壳", -- 2865
				location = "特兰雷克（塔纳利斯 - 加基森; "..YELLOW.."51,26 "..WHITE.."）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "给加基森的特兰雷克带去5个完整的圣甲虫壳。",
			},
			[4] = {
				note = "水占师维蕾萨在"..YELLOW.."[6]"..WHITE.."处掉落深渊皇冠。",
				followup = "无后续",
				attain = 40,
				aim = "将深渊皇冠交给尘泥沼泽的塔贝萨。",
				title = "深渊皇冠", -- 2846
				location = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				level = 46,
				rewards = {
					[1] = {
						name = "幻法之杖",
						id = 9527,
						subtext = "法杖",
						icon = "INV_Wand_11",
						quality = 2,
					},
					[2] = {
						name = "晶岩肩铠",
						id = 9531,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_23",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "塔贝萨的任务", -- 2861
			},
			[5] = {
				note = "你可以从同一NPC那里接到前置任务。\n这些碑文掉落于殉教者塞卡"..YELLOW.."[2]"..WHITE.."和水占师维蕾萨"..YELLOW.."[6]"..WHITE.."。",
				followup = "尖啸者的灵魂 -> 远古之卵", -- 3520 -> 4787
				attain = 40,
				aim = "将第一块和第二块摩沙鲁石板交给塔纳利斯的叶基亚。",
				title = "摩沙鲁的预言（系列任务）", -- 3527
				location = "叶基亚（塔纳利斯 - 热砂港; "..YELLOW.."66,22"..WHITE.."）",
				level = 47,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "此系列任务始于《尖啸者的灵魂》（同样在此领取，见"..YELLOW.."[祖儿法拉克]"..WHITE.."）。\n你必须在"..YELLOW.."[3]"..WHITE.."使用哈卡之卵，触发事件。一旦事件开始，敌人会像潮水般涌出来攻击你。其中一些敌人掉落哈卡莱之血。用这些血液熄灭包含哈卡灵魂能量的不灭火焰。当你熄灭所有的火焰时，哈卡的化身就可以进入我们的世界了。",
			},
			[6] = {
				note = "你可以从布莱中士那里得到探水棒。你可以在"..YELLOW.."[4]"..WHITE.."找到他。但要在神庙百人斩事件后后打败布莱中士，才能得到探水棒。",
				followup = "无后续",
				attain = 40,
				aim = "把探水棒交给加基森的首席工程师沙克斯·比格维兹。",
				title = "探水棒", -- 2768
				location = "比格维兹（塔纳利斯 - 加基森; "..YELLOW.."52,28 "..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "石工兄弟会之戒",
						id = 9533,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_03",
						quality = 3,
					},
					[2] = {
						name = "工程学协会头盔",
						id = 9534,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_33",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "前导任务从科罗莫特·钢尺（铁炉堡 - 侏儒区; "..YELLOW.."68,46"..WHITE.."）得到。但这不是一个必要的任务。\n你可以在"..YELLOW.."[6]"..WHITE.."使用祖尔法拉克之槌敲锣召唤加兹瑞拉。\n槌来自守护者奇尔加（辛特兰 - 祖尔祭坛; "..YELLOW.."49,70"..WHITE.."）的神圣之槌并在辛萨罗祭坛"..YELLOW.."59,77"..WHITE.."上使用，才能在祖尔法拉克敲锣。",
				followup = "无后续",
				attain = 40,
				aim = "把加兹瑞拉的鳞片交给闪光平原的维兹尔·铜栓。",
				title = "加兹瑞拉", -- 2770
				location = "维兹尔·铜栓（千针石林 - 闪光平原; "..YELLOW.."78,77 "..WHITE.."）",
				level = 50,
				rewards = {
					[1] = {
						name = "棍子上的胡萝卜",
						id = 11122,
						subtext = "饰品",
						icon = "INV_Misc_Food_54",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "铜栓兄弟", -- 2769
			},
			[8] = {
				note = "我猜它应该在巫医祖穆拉 "..YELLOW.."[3]"..WHITE.." 附近。",
				followup = "无后续",
				attain = 40,
				aim = "进入祖尔法拉克，找到古代巨魔遗骸，然后将它们带回塔纳利斯的南月废墟交给汉苏·戈莎。",
				title = "(TW)8. 沙地漂流", -- 40519
				location = "汉苏·戈莎（塔纳利斯 - 乌尔杜姆附近的食人魔营地；"..YELLOW.."40.6,72.5"..WHITE.."）",
				level = 46,
				rewards = {
					[1] = {
						name = "南月吊坠", --60759
						id = 60759,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "此任务始于辛特兰巨魔村庄的毒液瓶任务。\n你会在"..YELLOW.."[2]"..WHITE.."发现石板。",
				followup = "召唤沙德拉", -- 2937
				attain = 40,
				aim = "阅读塞卡石板，了解枯木巨魔的蜘蛛之神的名字，然后回到加德林大师那里。",
				title = "蜘蛛之神（系列任务）", -- 2936
				location = "加德林大师（杜隆塔尔 - 森金村; "..YELLOW.."55,74 "..WHITE.."）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "毒液瓶 -> 请教加德林大师", -- 2933 -> 2935
			},
			[2] = {
				note = "每个巨魔都可能掉落调和剂。",
				followup = "无后续",
				attain = 40,
				aim = "收集20瓶巨魔调和剂，把它们交给加基森的特伦顿·轻锤。",
				title = "巨魔调和剂", -- 3042
				location = "特伦顿·轻锤（塔纳利斯 - 加基森; "..YELLOW.."51,28 "..WHITE.."）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "前导任务始于克拉兹克（荆棘谷 - 藏宝海湾; "..YELLOW.."25,77"..WHITE.."）。\n每个圣甲虫都可能掉落壳儿。大量圣甲虫集中在"..YELLOW.."[2]"..WHITE.."。",
				followup = "无后续",
				attain = 40,
				aim = "给加基森的特兰雷克带去5个完整的圣甲虫壳。",
				title = "圣甲虫的壳", -- 2865
				location = "特兰雷克（塔纳利斯 - 加基森; "..YELLOW.."51,26 "..WHITE.."）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "给加基森的特兰雷克带去5个完整的圣甲虫壳。",
			},
			[4] = {
				note = "水占师维蕾萨在"..YELLOW.."[6]"..WHITE.."处掉落深渊皇冠。",
				followup = "无后续",
				attain = 40,
				aim = "将深渊皇冠交给尘泥沼泽的塔贝萨。",
				title = "深渊皇冠", -- 2846
				location = "将《能量仪祭》交给尘泥沼泽的塔贝萨。",
				level = 46,
				rewards = {
					[1] = {
						name = "幻法之杖",
						id = 9527,
						subtext = "法杖",
						icon = "INV_Wand_11",
						quality = 2,
					},
					[2] = {
						name = "晶岩肩铠",
						id = 9531,
						subtext = "肩部 板甲",
						icon = "INV_Shoulder_23",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "塔贝萨的任务", -- 2861
			},
			[5] = {
				note = "你可以从同一NPC那里接到前置任务。\n这些碑文掉落于殉教者塞卡"..YELLOW.."[2]"..WHITE.."和水占师维蕾萨"..YELLOW.."[6]"..WHITE.."。",
				followup = "尖啸者的灵魂 -> 远古之卵", -- 3520 -> 4787
				attain = 40,
				aim = "将第一块和第二块摩沙鲁石板交给塔纳利斯的叶基亚。",
				title = "摩沙鲁的预言（系列任务）", -- 3527
				location = "叶基亚（塔纳利斯 - 热砂港; "..YELLOW.."66,22"..WHITE.."）",
				level = 47,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "此系列任务始于《尖啸者的灵魂》（同样在此领取，见"..YELLOW.."[祖儿法拉克]"..WHITE.."）。\n你必须在"..YELLOW.."[3]"..WHITE.."使用哈卡之卵，触发事件。一旦事件开始，敌人会像潮水般涌出来攻击你。其中一些敌人掉落哈卡莱之血。用这些血液熄灭包含哈卡灵魂能量的不灭火焰。当你熄灭所有的火焰时，哈卡的化身就可以进入我们的世界了。",
			},
			[6] = {
				note = "你可以从布莱中士那里得到探水棒。你可以在"..YELLOW.."[4]"..WHITE.."找到他。但要在神庙百人斩事件后后打败布莱中士，才能得到探水棒。",
				followup = "无后续",
				attain = 40,
				aim = "把探水棒交给加基森的首席工程师沙克斯·比格维兹。",
				title = "探水棒", -- 2768
				location = "比格维兹（塔纳利斯 - 加基森; "..YELLOW.."52,28 "..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "石工兄弟会之戒",
						id = 9533,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_03",
						quality = 3,
					},
					[2] = {
						name = "工程学协会头盔",
						id = 9534,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_33",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "前导任务从科罗莫特·钢尺（铁炉堡 - 侏儒区; "..YELLOW.."68,46"..WHITE.."）得到。但这不是一个必要的任务。\n你可以在"..YELLOW.."[6]"..WHITE.."使用祖尔法拉克之槌敲锣召唤加兹瑞拉。\n槌来自守护者奇尔加（辛特兰 - 祖尔祭坛; "..YELLOW.."49,70"..WHITE.."）的神圣之槌并在辛萨罗祭坛"..YELLOW.."59,77"..WHITE.."上使用，才能在祖尔法拉克敲锣。",
				followup = "无后续",
				attain = 40,
				aim = "把加兹瑞拉的鳞片交给闪光平原的维兹尔·铜栓。",
				title = "加兹瑞拉", -- 2770
				location = "维兹尔·铜栓（千针石林 - 闪光平原; "..YELLOW.."78,77 "..WHITE.."）",
				level = 50,
				rewards = {
					[1] = {
						name = "棍子上的胡萝卜",
						id = 11122,
						subtext = "饰品",
						icon = "INV_Misc_Food_54",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "铜栓兄弟", -- 2769
			},
			[8] = {
				note = "我猜它应该在巫医祖穆拉 "..YELLOW.."[3]"..WHITE.." 附近。",
				followup = "无后续",
				attain = 40,
				aim = "进入祖尔法拉克，找到古代巨魔遗骸，然后将它们带回塔纳利斯的南月废墟交给汉苏·戈莎。",
				title = "(TW)8. 沙地漂流", -- 40519
				location = "汉苏·戈莎（塔纳利斯 - 乌尔杜姆附近的食人魔营地；"..YELLOW.."40.6,72.5"..WHITE.."）",
				level = 46,
				rewards = {
					[1] = {
						name = "南月吊坠", --60759
						id = 60759,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_13",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "任务线从塔纳利斯的沙月村的先知玛兹克（塔纳利斯）的任务“沙怒救赎 I”开始。",
				followup = "无后续",
				attain = 40,
				aim = "在祖尔法拉克内击败乌科兹·沙须和鲁兹鲁，为塔纳利斯的沙月村的勇士塔扎戈完成任务。",
				title = "(TW)9. 乌克兹·沙顶的尽头", -- 40527
				location = "勇士塔扎戈（塔纳利斯 - 沙月村；塔纳利斯的东北角，在蒸汽车队港口上方）",
				level = 48,
				rewards = {
					[1] = {
						name = "沙丘之刃", -- 60764
						id = 60764,
						subtext = "主手 剑",
						icon = "INV_Sword_36",
						quality = 2,
					},
					[2] = {
						name = "沙月护胫", -- 60765
						id = 60765,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "沙怒的困境", -- 40526
			},
		},
	},
	[31] = {
		name = "高阶祭司温诺希斯"..YELLOW.."祖尔格拉布"..WHITE.."掉落温诺希斯的毒囊。库林纳克斯"..YELLOW.."安其拉废墟"..WHITE..""..YELLOW.."[1]"..WHITE.."掉落库林纳克斯的毒囊。",
		story = {
			[1] = "早在几千年前，强大的古拉巴什帝国陷入了一场规模浩大的内战，一群极具影响力的被称作阿塔莱的巨魔祭司，信奉着一个名叫夺灵者·哈卡的嗜血的邪神。这些阿塔莱祭司虽然已被击败并被处以永久的流放，但伟大的巨魔帝国就这样崩塌了。被流放的祭司们来到了北方的悲伤沼泽。在这里，他们为哈卡神建造了一座大神庙——阿塔哈卡神庙，并继续在那里为他们的主人重返物质世界而作准备……",
			[2] = "终于，阿塔莱祭司发现，哈卡的物质形态只有在古老的古拉巴什帝国的首都——祖尔格拉布，才能召唤出来。不幸的是，这些祭司们最近真的成功召唤出哈卡——传闻证实可怕的夺灵者真的出现在古拉巴什废墟的中心。\n \n为了镇压血神，所有的巨魔都联合起来，派出了一支由高阶牧师组成的小队深入这座古老的城市。队中的每个牧师都是一位远古之神的强大战士，他们分别代表着蝙蝠、豹、老虎、蜘蛛和蛇的力量，但是尽管如此，强大的哈卡仍然轻易地击败了他们。现在这些勇士和他们的远古之神全都臣服于夺灵者的力量。如果有任何冒险者想进入废墟禁地挑战强大的血神哈卡，他们就必须先击败这些高阶牧师。",
				},
		[1] = {
			[1] = {
				note = "请你确认每次都搜索了高阶祭司的尸体。",
				followup = "无后续",
				attain = 58,
				aim = "将神圣之索穿上5颗导魔师的头颅，然后把这一串头颅交给尤亚姆巴岛上的伊克萨尔。",
				title = "祭司的头颅", -- 8201
				location = "伊克萨尔（荆棘谷 - 尤亚姆巴岛; "..YELLOW.."15,15"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "扭曲头颅腰带",
						id = 20213,
						subtext = "腰部 板甲",
						icon = "INV_Belt_13",
						quality = 3,
					},
					[2] = {
						name = "皱缩头颅腰带",
						id = 20215,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_12",
						quality = 3,
					},
					[3] = {
						name = "防腐头颅腰带",
						id = 20216,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_14",
						quality = 3,
					},
					[4] = {
						name = "细小头颅腰带",
						id = 20217,
						subtext = "腰部 布甲",
						icon = "INV_Belt_13",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "莫托尔（荆棘谷 - 尤亚姆巴岛; "..YELLOW.."15,15"..WHITE.."）",
				followup = "无后续",
				attain = 58,
				aim = "把哈卡之心交给尤亚姆巴岛上的莫托尔。",
				title = "哈卡之心", -- 8183
				location = "哈卡之心（哈卡掉落; "..YELLOW.."[11]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "赞达拉英雄徽记",
						id = 19948,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_13",
						quality = 4,
					},
					[2] = {
						name = "赞达拉英雄护符",
						id = 19950,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_13",
						quality = 4,
					},
					[3] = {
						name = "赞达拉英雄勋章",
						id = 19949,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_13",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "找到纳特·帕格（尘泥沼泽; "..YELLOW.."59,60"..WHITE.."）。 完成任务后你可以从他那里购买哈卡之岛臭泥鱼诱饵，可以在祖尔格拉布召唤隐藏的加兹兰卡。",
				followup = "无后续",
				attain = 58,
				aim = "将纳特的卷尺交给尘泥沼泽的纳特·帕格。",
				title = "纳特的卷尺", -- 8227
				location = "破碎的工具箱（祖尔格拉布 - 隔水哈卡之岛的东北的岸边。）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "高阶祭司温诺希斯"..YELLOW.."祖尔格拉布"..WHITE.."掉落温诺希斯的毒囊。库林纳克斯"..YELLOW.."安其拉废墟"..WHITE..""..YELLOW.."[1]"..WHITE.."掉落库林纳克斯的毒囊。",
				followup = "无后续",
				attain = 60,
				aim = "塞纳里奥要塞的德尔克·雷木让你把温诺希斯的毒囊和库林纳克斯的毒囊交给他。",
				title = "完美的毒药", -- 9023
				location = "德尔克·雷木（希利苏斯 - 塞纳里奥要塞; "..YELLOW.."52,39"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "拉文霍德切割者",
						id = 22378,
						subtext = "单手 剑",
						icon = "INV_Sword_38",
						quality = 3,
					},
					[2] = {
						name = "开闸刀",
						id = 22379,
						subtext = "主手 匕首",
						icon = "INV_Sword_21",
						quality = 3,
					},
					[3] = {
						name = "雷木之刺",
						id = 22377,
						subtext = "单手 匕首",
						icon = "INV_Sword_17",
						quality = 3,
					},
					[4] = {
						name = "康恩之怒",
						id = 22348,
						subtext = "双手 锤",
						icon = "INV_Hammer_10",
						quality = 3,
					},
					[5] = {
						name = "法拉德的装填器",
						id = 22347,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_04",
						quality = 3,
					},
					[6] = {
						name = "西蒙尼的耕种用锤",
						id = 22380,
						subtext = "主手 锤",
						icon = "INV_Hammer_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4"..AQDiscription_OR.."5"..AQDiscription_OR.."6",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "请你确认每次都搜索了高阶祭司的尸体。",
				followup = "无后续",
				attain = 58,
				aim = "将神圣之索穿上5颗导魔师的头颅，然后把这一串头颅交给尤亚姆巴岛上的伊克萨尔。",
				title = "祭司的头颅", -- 8201
				location = "伊克萨尔（荆棘谷 - 尤亚姆巴岛; "..YELLOW.."15,15"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "扭曲头颅腰带",
						id = 20213,
						subtext = "腰部 板甲",
						icon = "INV_Belt_13",
						quality = 3,
					},
					[2] = {
						name = "皱缩头颅腰带",
						id = 20215,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_12",
						quality = 3,
					},
					[3] = {
						name = "防腐头颅腰带",
						id = 20216,
						subtext = "腰部 皮甲",
						icon = "INV_Belt_14",
						quality = 3,
					},
					[4] = {
						name = "细小头颅腰带",
						id = 20217,
						subtext = "腰部 布甲",
						icon = "INV_Belt_13",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "莫托尔（荆棘谷 - 尤亚姆巴岛; "..YELLOW.."15,15"..WHITE.."）",
				followup = "无后续",
				attain = 58,
				aim = "把哈卡之心交给尤亚姆巴岛上的莫托尔。",
				title = "哈卡之心", -- 8183
				location = "哈卡之心（哈卡掉落; "..YELLOW.."[11]"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "赞达拉英雄徽记",
						id = 19948,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_13",
						quality = 4,
					},
					[2] = {
						name = "赞达拉英雄护符",
						id = 19950,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_13",
						quality = 4,
					},
					[3] = {
						name = "赞达拉英雄勋章",
						id = 19949,
						subtext = "饰品",
						icon = "INV_Jewelry_Necklace_13",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "找到纳特·帕格（尘泥沼泽; "..YELLOW.."59,60"..WHITE.."）。 完成任务后你可以从他那里购买哈卡之岛臭泥鱼诱饵，可以在祖尔格拉布召唤隐藏的加兹兰卡。",
				followup = "无后续",
				attain = 58,
				aim = "将纳特的卷尺交给尘泥沼泽的纳特·帕格。",
				title = "纳特的卷尺", -- 8227
				location = "破碎的工具箱（祖尔格拉布 - 隔水哈卡之岛的东北的岸边。）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "高阶祭司温诺希斯"..YELLOW.."祖尔格拉布"..WHITE.."掉落温诺希斯的毒囊。库林纳克斯"..YELLOW.."安其拉废墟"..WHITE..""..YELLOW.."[1]"..WHITE.."掉落库林纳克斯的毒囊。",
				followup = "无后续",
				attain = 60,
				aim = "塞纳里奥要塞的德尔克·雷木让你把温诺希斯的毒囊和库林纳克斯的毒囊交给他。",
				title = "完美的毒药", -- 9023
				location = "德尔克·雷木（希利苏斯 - 塞纳里奥要塞; "..YELLOW.."52,39"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "拉文霍德切割者",
						id = 22378,
						subtext = "单手 剑",
						icon = "INV_Sword_38",
						quality = 3,
					},
					[2] = {
						name = "开闸刀",
						id = 22379,
						subtext = "主手 匕首",
						icon = "INV_Sword_21",
						quality = 3,
					},
					[3] = {
						name = "雷木之刺",
						id = 22377,
						subtext = "单手 匕首",
						icon = "INV_Sword_17",
						quality = 3,
					},
					[4] = {
						name = "康恩之怒",
						id = 22348,
						subtext = "双手 锤",
						icon = "INV_Hammer_10",
						quality = 3,
					},
					[5] = {
						name = "法拉德的装填器",
						id = 22347,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_04",
						quality = 3,
					},
					[6] = {
						name = "西蒙尼的耕种用锤",
						id = 22380,
						subtext = "主手 锤",
						icon = "INV_Hammer_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4"..AQDiscription_OR.."5"..AQDiscription_OR.."6",
				},
				prequest = "无前置",
			},
		},
	},
	[32] = {
		name = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
		story = "位于丹莫洛的科技奇迹城市诺莫瑞根世代以来都是侏儒的主城。最近，一群邪恶的变异食鄂怪侵入了包括侏儒主城在内的多处丹莫洛地区。为了做出殊死一搏来干掉入侵的食腭怪，大工匠梅卡托克命令打开城市中的紧急辐射水箱。侏儒在等待那些食腭怪死亡或者逃跑的同时也在寻找躲避辐射的方法。不幸的是，虽然食腭怪在经过辐射之后感染了毒性——但是它们的攻击没有停止，也没有丝毫的减弱。那些没有被辐射杀死的侏儒被迫逃离，他们在附近的矮人城市铁炉堡找到了安身之处。大工匠梅卡托克组建了一个智囊团来商议重新夺回他们挚爱的城市的计划。传说大工匠梅卡托克曾经最信任的顾问，制造者瑟玛普拉格被判了他的人民并纵容了这次入侵的发生。现在，他的心智，制造者瑟玛普拉格还留在诺莫瑞根中——他在继续筹划着自己黑暗的计划并成为这座城市新的科技领主。",
		[1] = {
			[1] = {
				note = "你可以在萨尔努修士（暴风城 - 教堂广场; "..YELLOW.."40,30"..WHITE.."）那儿接到此任务的前导任务。\n在你进入副本之前，后门附近"..WHITE.."，可以找到尖端机器人。",
				followup = "无后续",
				attain = 20,
				aim = "将尖端机器人的存储器核心交给铁炉堡的工匠大师欧沃斯巴克。",
				title = "拯救尖端机器人！", -- 2922
				location = "工匠大师欧沃斯巴克（铁炉堡 - 侏儒区; "..YELLOW.."69,50 "..WHITE.."）",
				level = 26,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "将尖端机器人的存储器核心交给铁炉堡的工匠大师欧沃斯巴克。",
			},
			[2] = {
				note = "你可以在诺恩（铁炉堡 - 侏儒区; "..YELLOW.."69,50"..WHITE.."）那儿得到此任务的前导任务。\n要得到辐射尘，你必须对"..RED.."活的"..WHITE.."辐射入侵者或者辐射抢劫者使用空铅瓶。",
				followup = "更多的辐射尘", -- 2962
				attain = 20,
				aim = "用空铅瓶对着辐射入侵者或者辐射抢劫者，从它们身上收集放射尘。瓶子装满之后，把它交给卡拉诺斯的奥齐·电环。",
				title = "诺恩", -- 2926
				location = "奥齐·电环（丹莫罗 - 卡拉诺斯; "..YELLOW.."45,49 "..WHITE.."）",
				level = 27,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "灾难之后", -- 2927
			},
			[3] = {
				note = "要得到辐射尘，你必须对"..RED.."活的"..WHITE.."辐射泥浆怪，辐射潜伏者，辐射水元素使用沉重的铅瓶。",
				followup = "无后续",
				attain = 20,
				aim = "到诺莫瑞根去收集高强度辐射尘。要多加小心，这种辐射尘非常不稳定，很快就会分解。奥齐要求你把沉重的铅瓶也交给他。",
				title = "更多的辐射尘", -- 2962
				location = "奥齐·电环（丹莫罗 - 卡拉诺斯; "..YELLOW.."45,49 "..WHITE.."）",
				level = 30,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "诺恩", -- 2926
			},
			[4] = {
				note = "每个机器人都掉落内胆。",
				followup = "无后续",
				attain = 20,
				aim = "收集24副机械内胆，把它们交给暴风城的舒尼。",
				title = "陀螺式挖掘机", -- 2928
				location = "沉默的舒尼（暴风城 - 矮人区; "..YELLOW.."55,12"..WHITE.."）",
				level = 30,
				rewards = {
					[1] = {
						name = "舒尼的扳手",
						id = 9608,
						subtext = "副手，斧",
						icon = "INV_Misc_Wrench_01",
						quality = 2,
					},
					[2] = {
						name = "欺诈手套",
						id = 9609,
						subtext = "手部 布甲",
						icon = "INV_Gauntlets_27",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "你可以在玛希尔（达纳苏斯 - 战士区; "..YELLOW.."29.6,56.4"..WHITE.."）那儿得到此任务的前导任务。\n每个诺莫瑞根的敌人都可能掉落基础模组。",
				followup = "无后续",
				attain = 24,
				aim = "收集12个基础模组，把它们交给铁炉堡的科劳莫特·钢尺。",
				title = "基础模组", -- 2924
				location = "科劳莫特·钢尺（丹莫罗 - 诺莫瑞根复兴城；"..YELLOW.."25.0,30.1"..WHITE.."）",
				level = 30,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "帮助科劳莫特", -- 2925
			},
			[6] = {
				note = "你可以在加克希姆·尘链（石爪山脉; "..YELLOW.."59,67"..WHITE.."）那儿得到此任务的前导任务。但这不是一个必要的任务。\n白色卡片随机掉落。你可以在进入副本之前紧靠后门入口处"..YELLOW.."副本入口地图[3]"..WHITE.."找到第一终端。第二个在"..YELLOW.."[3]"..WHITE.."，第三个在"..YELLOW.."[5]"..WHITE.."，而第四个在"..YELLOW.."[6]"..WHITE.."。",
				followup = "无后续",
				attain = 25,
				aim = "将彩色穿孔卡片交给铁炉堡的大机械师卡斯派普。",
				title = "抢救数据", -- 2930
				location = "大机械师卡斯派普（铁炉堡 - 侏儒区; "..YELLOW.."69,48 "..WHITE.."）",
				level = 30,
				rewards = {
					[1] = {
						name = "修理工的斗篷",
						id = 9605,
						subtext = "背部",
						icon = "INV_Misc_Cape_06",
						quality = 2,
					},
					[2] = {
						name = "蒸汽锤",
						id = 9604,
						subtext = "双手 锤",
						icon = "INV_Mace_04",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "卡斯派普的任务", -- 2931
			},
			[7] = {
				note = "护送任务！你可以在（荆棘谷 - 藏宝海湾; "..YELLOW.."27,77"..WHITE.."）找到斯库提。",
				followup = "无后续",
				attain = 24,
				aim = "将克努比护送到出口，然后向藏宝海湾的斯库提汇报。",
				title = "一团混乱",
				location = "克努比（诺莫瑞根 "..YELLOW.."[3]"..WHITE.."）",
				level = 30,
				rewards = {
					[1] = {
						name = "焊接护腕",
						id = 9535,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_02",
						quality = 2,
					},
					[2] = {
						name = "精灵之翼",
						id = 9536,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "你可以在"..YELLOW.."[8]"..WHITE.."发现制造者瑟玛普拉格。他是诺莫瑞根最后一个Boss。\n在战斗中你必须按下它旁边的按钮阻止他放炸弹。",
				followup = "无后续",
				attain = 25,
				aim = "到诺莫瑞根去杀掉制造者瑟玛普拉格。完成任务之后向大工匠梅卡托克报告。",
				title = "大叛徒", -- 2929
				location = "大工匠梅卡托克（铁炉堡 - 侏儒区; "..YELLOW.."68,48"..WHITE.."）",
				level = 35,
				rewards = {
					[1] = {
						name = "公民长袍",
						id = 9623,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_18",
						quality = 3,
					},
					[2] = {
						name = "旅行皮裤",
						id = 9624,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_08",
						quality = 3,
					},
					[3] = {
						name = "双链护腿",
						id = 9625,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "这个戒指可以在清洁器5200型中清洁，位置在"..YELLOW.."[2]"..WHITE.."。",
				followup = "戒指归来", -- 2947
				attain = 28,
				aim = "想方法把脏兮兮的戒指弄干净。",
				title = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
				location = "脏兮兮的戒指（诺莫瑞根随机掉落）",
				level = 34,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "把它交给塔瓦斯德·基瑟尔（铁炉堡 - 秘法区; "..YELLOW.."36,3"..WHITE.."）。奖励的戒指为随机属性。",
				followup = "侏儒的手艺", -- 2948
				attain = 28,
				aim = "你要么自己留着这枚戒指，要么就按照戒指内侧刻着的名字找到它的主人。",
				title = "戒指归来", -- 2947
				location = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
				level = 34,
				rewards = {
					[1] = {
						name = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
						id = 9362,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
			},
			[11] = {
				note = "开始任务的完整的重击者主机框架可以从群体打击者9-60"..YELLOW.."[6]"..WHITE.."（低概率）掉落。\n需要工程学技能达到125+的工程师才能接取。",
				followup = "(TW)18. 建造一个重击者", -- 80401
				attain = 30,
				aim = "找到一个能够弄清楚如何处理主机框架的人。",
				title = "一个有力的大脑（仅限工程师）", --80398
				location = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
				level = 30,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[12] = {
				note = "高能调节器图纸位于东南角的下层南室的桌子上，位置标记为 "..YELLOW.."[3]"..WHITE.."，东南角的下层南室位置标记为 "..YELLOW.."[a]"..WHITE.."。",
				followup = "无后续",
				attain = 25,
				aim = "在诺莫瑞根内找到高能调节器图纸，并将其带给丹莫罗的威赞·小齿轮位于诺莫瑞根复兴城",
				title = "(TW)12. 高能调节器", -- 40861
				location = "在诺莫瑞根内找到高能调节器图纸，并将其带给丹莫罗的威赞·小齿轮位于诺莫瑞根复兴城",
				level = 33,
				rewards = {
					[1] = {
						name = "低能调节器", --61393
						id = 61393,
						subtext = "饰品",
						icon = "INV_Gizmo_06",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[13] = {
				note = "阿尔法通道阀门位于中央机构的南侧，使用电梯下去，位置标记为 "..YELLOW.."[6]"..WHITE.."。\n备用泵通道杠杆位于地板上，位置标记为 "..YELLOW.."[b]"..WHITE.."。",
				followup = "无后续",
				attain = 25,
				aim = "在诺莫瑞根深处，激活阿尔法通道阀门 "..YELLOW.."[6]"..WHITE.." 和备用泵通道杠杆 "..YELLOW.."[b]"..WHITE.."，并将其带给丹莫罗的大师技术员维尔斯班纳。",
				title = "(TW)13. 备份系统激活", -- 40856
				location = "大师技术员维尔斯班纳（丹莫罗 - 诺莫瑞根复兴城 "..YELLOW.."[26.8,31.1]"..WHITE.."）",
				level = 33,
				rewards = {
					[1] = {
						name = "精致侏儒步枪", -- 61383
						id = 61383,
						subtext = "枪械",
						icon = "INV_Weapon_Rifle_TWoW_01_Gold_Noglow",
						quality = 3,
					},
					[2] = {
						name = "离子金属抓握之爪", -- 61384
						id = 61384,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_29",
						quality = 3,
					},
					[3] = {
						name = "磁性之环", -- 61385
						id = 61385,
						subtext = "戒指",
						icon = "INV_Belt_27",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "你可以在索维克（奥格瑞玛 - 荣誉谷; "..YELLOW.."75,25"..WHITE.."）那儿得到此任务的前导任务。\n当你完成这个任务，你可以使用藏宝海湾的传送器。",
				followup = "无后续",
				attain = 20,
				aim = "等斯库提调整好地精传送器。",
				title = "出发！诺莫瑞根！", -- 2843
				location = "斯库提（荆棘谷 - 藏宝海湾; "..YELLOW.."27,77 "..WHITE.."）",
				level = 35,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "主工程师斯库提", -- 2842
			},
			[2] = {
				note = "护送任务！你可以在（荆棘谷 - 藏宝海湾; "..YELLOW.."27,77"..WHITE.."）找到斯库提。",
				followup = "无后续",
				attain = 24,
				aim = "将克努比护送到出口，然后向藏宝海湾的斯库提汇报。",
				title = "一团混乱",
				location = "克努比（诺莫瑞根 "..YELLOW.."[3]"..WHITE.."）",
				level = 30,
				rewards = {
					[1] = {
						name = "焊接护腕",
						id = 9535,
						subtext = "手腕 锁甲",
						icon = "INV_Bracer_02",
						quality = 2,
					},
					[2] = {
						name = "精灵之翼",
						id = 9536,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_02",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你可以在"..YELLOW.."[8]"..WHITE.."发现制造者瑟玛普拉格。他是诺莫瑞根最后一个Boss。\n在战斗中你必须按下它旁边的按钮阻止他放炸弹。",
				followup = "无后续",
				attain = 25,
				aim = "从诺莫瑞根拿到钻探设备蓝图和麦克尼尔的保险箱密码，把它们交给奥格瑞玛的诺格。",
				title = "设备之战", -- 2841
				location = "诺格（奥格瑞玛 - 荣誉谷; "..YELLOW.."75,25 "..WHITE.."）",
				level = 35,
				rewards = {
					[1] = {
						name = "公民长袍",
						id = 9623,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_18",
						quality = 3,
					},
					[2] = {
						name = "旅行皮裤",
						id = 9624,
						subtext = "腿部 皮甲",
						icon = "INV_Pants_08",
						quality = 3,
					},
					[3] = {
						name = "双链护腿",
						id = 9625,
						subtext = "腿部 锁甲",
						icon = "INV_Pants_03",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "这个戒指可以在清洁器5200型中清洁，位置在"..YELLOW.."[2]"..WHITE.."。",
				followup = "戒指归来", -- 2947
				attain = 28,
				aim = "想方法把脏兮兮的戒指弄干净。",
				title = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
				location = "脏兮兮的戒指（诺莫瑞根随机掉落）",
				level = 34,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "把戒指交给诺格（奥格瑞玛 - 荣誉谷; "..YELLOW.."75,25"..WHITE.."）。奖励的戒指为随机属性。",
				followup = "诺格的戒指重做", -- 2950
				attain = 28,
				aim = "你要么自己留着这枚戒指，要么就按照戒指内侧刻着的名字找到它的主人。",
				title = "戒指归来", -- 2947
				location = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
				level = 34,
				rewards = {
					[1] = {
						name = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
						id = 9362,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "闪亮的金戒指（从脏兮兮的戒指清洁后获得）",
			},
			[6] = {
				note = "开始任务的完整的重击者主机框架可以从群体打击者9-60"..YELLOW.."[6]"..WHITE.."（低概率）掉落。\n需要工程学技能达到125+的工程师才能接取。",
				followup = "(TW)18. 建造一个重击者", -- 80401
				attain = 30,
				aim = "找到一个能够弄清楚如何处理主机框架的人。",
				title = "一个有力的大脑（仅限工程师）", --80398
				location = "这个任务需要收集3个物品。\n1）瑟银调谐伺服机构（血色修道院，来自血色侍从）\n2）完美傀儡核心（黑石深渊，来自傀儡统帅阿格曼奇）\n3）精金棒（斯坦索姆，来自红衣铁匠 "..YELLOW.."[8]"..WHITE.."）\n\'地精打击者9-60\'在诺莫瑞根掉落\'完整的破碎者主机\'，开始前置任务\'一个有力的大脑\'。",
				level = 30,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "前置任务“新的能源来源”从技师斯帕兹（杜隆塔尔 - 火花港）开始，需要在7级时接取。\n超级通量电容器从机械师瑟尔玛普拉格掉落。你可以在"..YELLOW.."[8]"..WHITE.."处找到机械师瑟尔玛普拉格，他是诺莫瑞根的最后一位boss。\n在战斗中，你需要通过按下侧面的按钮来禁用柱子。",
				followup = "无后续",
				attain = 29,
				aim = "将超级通量电容器交给技师格里兹洛。",
				title = "(TW)7. 后备电源", -- 55006
				location = "技师格里兹洛（杜隆塔尔 - 火花港 "..YELLOW.."可能"..WHITE.."）。",
				level = 34,
				rewards = {
					[1] = {
						name = "锋刃圆盾", -- 81319
						id = 81319,
						subtext = "盾牌",
						icon = "INV_Shield_08",
						quality = 3,
					},
					[2] = {
						name = "电光电击器", -- 81320
						id = 81320,
						subtext = "魔杖",
						icon = "INV_Wand_04",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "前置任务“新的能源来源”从技师斯帕兹（杜隆塔尔 - 火花港）开始，需要在7级时接取。\n超级通量电容器从机械师瑟尔玛普拉格掉落。你可以在"..YELLOW.."[8]"..WHITE.."处找到机械师瑟尔玛普拉格，他是诺莫瑞根的最后一位boss。\n在战斗中，你需要通过按下侧面的按钮来禁用柱子。",
			},
		},
	},
	[33] = {
		name = "梦魇之龙",
		story = {
			[1] = "世界之树陷入了一场骚乱。僻静的灰谷、暮色森林、菲拉斯以及辛特兰面临着新的威胁。绿龙军团的四条守护巨龙从翡翠梦境来到了艾泽拉斯世界，这些曾经忠心耿耿的守护者，现在却为世界带来了毁灭和死亡的气息。拿起武器，跟你的伙伴一同进入那些神秘的森林——只有你能从巨龙手中拯救艾泽拉斯。",
			[2] = "翡翠梦境的守护巨龙伊瑟拉统治着神秘的绿龙军团。她居住在翡翠梦境中，支配着世界万物的演化方向。她是自然和梦幻的守护者，她统治的绿龙军团负责保护世界之树，只有德鲁伊才能通过世界之树进入翡翠梦境。\n近来，在翡翠梦境中的某种新的黑暗力量的驱使下，伊瑟拉最忠诚的守护者们穿越世界之树，来到了艾泽拉斯世界，妄图使世界再度陷入疯狂和恐慌。即使是最强大的冒险者也应该对这些巨龙退避三舍，否则他就将为此付出惨重的代价。",
			[3] = "受翡翠梦境黑暗力量的影响，莱索恩的龙鳞失去了光泽，他拥有了汲取敌人幻象的力量。这些幻象可以赋予巨龙治疗的能力。毫无疑问，莱索恩被认为是伊瑟拉手下最强大的守护者。",
			[4] = "在翡翠梦境的某种神秘的黑暗力量诱惑下，高贵的艾莫莉丝成为了一头腐烂、患病的怪物。少数侥幸生还者称，他们死去的伙伴的尸体上长出了腐烂的蘑菇，那情形异常恐怖。艾莫莉丝是伊瑟拉统治的绿龙军团中最可怕的巨龙。",
			[5] = "泰拉尔或许是伊瑟拉的守护者中受黑暗力量影响最深的巨龙。翡翠梦境的黑暗力量彻底摧毁了泰拉尔的心智和肉体。他成为拥有分身术的巨龙幽灵，各个分身都具备强大的魔法破坏力。泰拉尔是个狡猾无情的敌人，他妄图使艾泽拉斯世界的所有生物都陷入疯狂。",
			[6] = "伊瑟拉最忠诚的守护者伊森德雷如今已面目全非，她在艾泽拉斯大陆上散播着恐慌和混乱。她先前拥有的治疗能力被黑暗魔法所取代，她能释放烟状的闪电波并召唤恶魔德鲁伊。伊森德雷和她的龙族拥有催眠技能，可以使敌人陷入最可怕的噩梦。",
				  },
		[1] = {
			[1] = {
				note = "物品交给守护者雷姆洛斯  (月光林地; "..YELLOW.."36,41"..WHITE..").奖励是为了后续任务。",
				followup = "有,唤醒传说", -- 8447
				attain = 60,
				aim = "寻找能解读梦魇包裹的物品中所隐藏的信息的人.",
				title = "梦魇的缠绕", -- 8446
				location = "梦魇包裹的物品 (掉落自 泰拉尔, 伊森德雷, 艾莫莉丝 或 莱索恩)",
				level = 60,
				rewards = {
					[1] = {
						name = "玛法里奥的徽记之戒",
						id = 20600,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_37",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "物品交给守护者雷姆洛斯  (月光林地; "..YELLOW.."36,41"..WHITE..").奖励是为了后续任务。",
				followup = "有,唤醒传说", -- 8447
				attain = 60,
				aim = "寻找能解读梦魇包裹的物品中所隐藏的信息的人.",
				title = "梦魇的缠绕", -- 8446
				location = "梦魇包裹的物品 (掉落自 泰拉尔, 伊森德雷, 艾莫莉丝 或 莱索恩)",
				level = 60,
				rewards = {
					[1] = {
						name = "玛法里奥的徽记之戒",
						id = 20600,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_37",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
	},
	[34] = {
		name = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
		story = "在世界大分裂之前，暗夜精灵之城埃达拉斯在如今被称作艾萨拉的土地上可说是非常繁盛。据说很多古老和强大的高等精灵神器，可能就藏在强极一时的堡垒里。经历了无数世代，蓝龙军团全力保护神器与魔法传说，确保它们不落入凡人手中。蓝龙，艾索雷葛斯的出现，似乎暗示着那些具有极重要意义的物品，像是预言中的永恒之瓶，或许就能在艾萨拉的荒野里找到。无论艾索雷葛斯在寻找什么，可以肯定的是：他会誓死保卫艾萨拉的魔法宝藏。",
		[1] = {
			[1] = {
				note = "杀死艾索雷葛斯得到蓝龙肉，它在艾萨拉南部半岛的中部附近漫步，靠近 "..YELLOW.."[1]"..WHITE..".",
				followup = "无后续",
				attain = 60,
				aim = "费伍德森林的古树哈斯塔特要求你带回一块成年蓝龙的肌腱.",
				title = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
				location = "古树哈斯塔特 (费伍德森林 - 铁木树林; "..YELLOW.."48,24"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
						id = 18714,
						subtext = AQITEM_QUIVER,
						icon = "INV_Misc_Quiver_03",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "远古石叶 ("..YELLOW.."熔火之心"..WHITE..")", -- 7632
			},
			[2] = {
				note = "你可以在塔纳利斯的"..YELLOW.."65.17"..WHITE.."找到纳兰·苏斯矾。",
				followup = "翻译龙语", -- 8576
				attain = 60,
				aim = "将艾索雷葛斯的魔法账本交给塔纳利斯的纳兰·苏斯矾。",
				title = "艾索雷葛斯的魔法账本", -- 8575
				location = "艾索雷葛斯之魂（艾萨拉；"..YELLOW.."56,83"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "守护之龙", -- 8555
			},
		},
		[2] = {
			[1] = {
				note = "杀死艾索雷葛斯得到蓝龙肉，它在艾萨拉南部半岛的中部附近漫步，靠近 "..YELLOW.."[1]"..WHITE..".",
				followup = "无后续",
				attain = 60,
				aim = "费伍德森林的古树哈斯塔特要求你带回一块成年蓝龙的肌腱.",
				title = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
				location = "古树哈斯塔特 (费伍德森林 - 铁木树林; "..YELLOW.."48,24"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "龙筋箭袋（"..YELLOW.."艾索雷葛斯"..WHITE.."）", -- 7634
						id = 18714,
						subtext = AQITEM_QUIVER,
						icon = "INV_Misc_Quiver_03",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "远古石叶 ("..YELLOW.."熔火之心"..WHITE..")", -- 7632
			},
			[2] = {
				note = "你可以在塔纳利斯的"..YELLOW.."65.17"..WHITE.."找到纳兰·苏斯矾。",
				followup = "翻译龙语", -- 8576
				attain = 60,
				aim = "将艾索雷葛斯的魔法账本交给塔纳利斯的纳兰·苏斯矾。",
				title = "艾索雷葛斯的魔法账本", -- 8575
				location = "艾索雷葛斯之魂（艾萨拉；"..YELLOW.."56,83"..WHITE.."）",
				level = 60,
				rewards = {
				},
				prequest = "守护之龙", -- 8555
			},
		},
	},
	[35] = {
		name = "卡扎克",
		story = "在燃烧军团于第三次大战获胜之后，由恶魔卡扎克所领导的剩余敌军，退回了诅咒之地。到现在为止他们都还住在那里，一个叫腐烂之痕的地方，等待黑暗之门再度敞开。谣传黑暗之门再度敞开之时，卡扎克将带着他剩下的军队前往外域。曾经是兽人家园的德拉诺，外域被兽人萨满耐奥祖所建造的数个传送门同时开启而分割开来，现在更成为被暗夜精灵背叛者伊利丹统帅的恶魔军队所占领的破碎世界。",
		[1] = {
		},
		[2] = {
		},
	},
	[36] = {
		name = "奥特兰克山谷",
		story = "雷矛远征军已经在奥特兰克山谷中安营扎寨，想要研究这里的资源和远古遗物。尽管他们来此的目的并不是为了挑衅，但是矮人们却与居住在山谷南部的霜狼氏族发生了激烈的冲突。霜狼氏族由此发誓要将入侵者赶出他们的家园. ",
		[1] = {
			[1] = {
				note = "哈格丁中尉 在(奥特兰克山脉; "..YELLOW.."39,81"..WHITE..").",
				followup = "实验场", -- 7162
				attain = 51,
				aim = "到希尔斯布莱德丘陵地区的奥特兰克山谷去。到那里之后，和哈格丁中尉谈谈.",
				title = "国王的命令", -- 7261
				location = "洛泰姆中尉 (铁炉堡; "..YELLOW.."30,62"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "雷矛军旗在 奥特兰克山谷北部地图冰翼洞穴 "..YELLOW.."[11]"..WHITE.." . 当你声望提升到一个新的等级后，你可以与同一个NPC交谈领取更高级的雷矛徽章.",
				followup = "崭露头角 -> 命令之眼", -- 7168 -> 7172
				attain = 51,
				aim = "到主基地东南边的冰翼洞穴中去找到雷矛军旗，然后把它交给哈格丁中尉.",
				title = "实验场", -- 7162
				location = "哈格丁中尉 在(奥特兰克山脉; "..YELLOW.."39,81"..WHITE..").",
				level = 60,
				rewards = {
					[1] = {
						name = "雷矛徽章一级",
						id = 17691,
						subtext = "饰品",
						icon = "INV_Jewelry_StormPikeTrinket_01",
						quality = 2,
					},
					[2] = {
						name = "霜狼洋蓟",
						id = 19484,
						subtext = "物品",
						icon = "INV_Misc_Book_04",
						quality = 1,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "国王的命令", -- 7261
			},
			[3] = {
				note = "德雷克塔尔在 (奥特兰克山谷 - 南部地图; "..YELLOW.."[B]"..WHITE.."). 完成这个任务并不一定需要杀死德雷克塔尔，只要赢得奥特兰克山谷的战斗即可.",
				followup = "雷矛英雄", -- 8271
				attain = 51,
				aim = "进入奥特兰克山谷，击败部落将军德雷克塔尔。然后回到勘查员塔雷·石镐那里.",
				title = "在募集大约200个风暴水晶后，大德鲁伊伊类弗拉尔开始向（奥特兰克山谷 - 北部地图（ "..YELLOW.."[19]"..WHITE.."）移动，他将启动召唤法阵需要10个玩家去协助召唤。如果成功，森林之王伊弗斯将被召唤出来帮助抵抗部落.",
				location = "勘查员塔雷·石镐 (奥特兰克山脉; "..YELLOW.."41,78"..WHITE..") and\n(奥特兰克山谷 - 北部地图; "..YELLOW.."[B]"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "血刺",
						id = 19107,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_07",
						quality = 3,
					},
					[2] = {
						name = "冰刺长矛",
						id = 19106,
						subtext = "长柄武器",
						icon = "INV_Spear_04",
						quality = 3,
					},
					[3] = {
						name = "寒冷咬噬者",
						id = 19108,
						subtext = "魔杖",
						icon = "INV_Wand_01",
						quality = 3,
					},
					[4] = {
						name = "冰冷锻造之锤",
						id = 20648,
						subtext = "主手 锤",
						icon = "INV_Hammer_22",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "雷矛军需官在 (奥特兰克山谷 - 北部地图; "..YELLOW.."[7]"..WHITE..")并提供更多的任务。",
				followup = "无后续",
				attain = 51,
				aim = "与雷矛军需官谈一谈.",
				title = "军需官", -- 7121
				location = "巡山人布比罗 (奥特兰克山谷 - 北部地图; "..YELLOW.."在桥前附近[3]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "补给品 可以在冷齿矿洞找到 (奥特兰克山谷 - 南部地图; "..YELLOW.."[6]"..WHITE..").",
				followup = "无后续",
				attain = 51,
				aim = "把10份冷齿矿洞补给品交给丹巴达尔的联盟军需官.",
				title = "冷齿矿洞的补给", -- 6982
				location = "雷矛军需官在 (奥特兰克山谷 - 北部地图; "..YELLOW.."[7]"..WHITE..")并提供更多的任务。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "补给品 可以在深铁矿洞找到 (奥特兰克山谷 - 北部地图; "..YELLOW.."[1]"..WHITE..").",
				followup = "无后续",
				attain = 51,
				aim = "把10份深铁矿洞补给品交给丹巴达尔的联盟军需官.",
				title = "深铁矿洞的补给", -- 5892
				location = "雷矛军需官在 (奥特兰克山谷 - 北部地图; "..YELLOW.."[7]"..WHITE..")并提供更多的任务。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "这是个可重复任务.",
				followup = "更多的护甲碎片", -- 6781
				attain = 51,
				aim = "给丹巴达尔的莫高特·深炉带去20块护甲碎片.",
				title = "护甲碎片", -- 7223
				location = "莫高特·深炉 (奥特兰克山谷 - 北部地图; "..YELLOW.."[4]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "要完成任务，你必须在部落控制的情况下，在铁深矿洞（奥特兰克山谷 - 北部; "..YELLOW.."[1]"..WHITE.."）击败莫洛克，或在冷牙矿洞（奥特兰克山谷 - 南部; "..YELLOW.."[6]"..WHITE.."）击败工头斯尼维尔。",
				followup = "无后续",
				attain = 51,
				aim = "占领一座还没有被雷矛部族控制的矿洞，然后向丹巴达尔的雷矛军需官复命。",
				title = "占领矿洞", -- 7122
				location = "占领一座墓地，然后向丹巴达尔的诺雷格·雷矛中尉复命.",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "据报道，为了完成任务，实际上并不需要摧毁塔楼或碉堡，只需要进行攻击即可。",
				followup = "无后续",
				attain = 51,
				aim = "摧毁敌方的某座哨塔或者碉堡中的旗帜，然后向丹巴达尔的杜尔根·雷矛复命.",
				title = "哨塔和碉堡", -- 7102
				location = "占领一座墓地，然后向丹巴达尔的诺雷格·雷矛中尉复命.",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "只需要烧毁旗帜即可，不需要一定占领墓地.",
				followup = "无后续",
				attain = 51,
				aim = "占领一座墓地，然后向丹巴达尔的诺雷格·雷矛中尉复命.",
				title = "奥特兰克山谷的墓地", -- 7081
				location = "占领一座墓地，然后向丹巴达尔的诺雷格·雷矛中尉复命.",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[11] = {
				note = "你可以在基地南面找到这些羊，像猎人抓宠物一样驯服羊，然后带它回去复命.",
				followup = "无后续",
				attain = 51,
				aim = "找到奥特兰克山谷中的山羊。使用雷矛训练颈圈来驯服它们。被驯服的山羊会跟随你回到兽栏管理员那里，然后与兽栏管理员谈话以获得你的奖励.",
				title = "补充坐骑", -- 7027
				location = "兽栏管理员 (奥特兰克山谷 - 北部地图; "..YELLOW.."[6]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[12] = {
				note = "霜狼可以在奥特兰克山谷的南部找到.",
				followup = "无后续",
				attain = 51,
				aim = "进入敌人的基地，杀死霜狼获得它的皮来作为山羊坐骑的器具，去吧",
				title = "山羊坐具", -- 7026
				location = "雷矛山羊骑兵指挥官 (奥特兰克山谷 - 北部地图; "..YELLOW.."[6]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[13] = {
				note = "在募集大约200个风暴水晶后，大德鲁伊伊类弗拉尔开始向（奥特兰克山谷 - 北部地图（ "..YELLOW.."[19]"..WHITE.."）移动，他将启动召唤法阵需要10个玩家去协助召唤。如果成功，森林之王伊弗斯将被召唤出来帮助抵抗部落.",
				followup = "无后续",
				attain = 51,
				aim = "你可以躲避硝烟弥漫的战场，激烈战斗之外，你可以帮助我收集霜狼氏族身上的风暴水晶..",
				title = "水晶簇", -- 7386
				location = "大德鲁伊雷弗拉尔  (奥特兰克山谷 - 北部地图; "..YELLOW.."[2]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[14] = {
				note = "在募集大约200个风暴水晶后，大德鲁伊伊类弗拉尔开始向（奥特兰克山谷 - 北部地图（ "..YELLOW.."[19]"..WHITE.."）移动，他将启动召唤法阵需要10个玩家去协助召唤。如果成功，森林之王伊弗斯将被召唤出来帮助抵抗部落.",
				followup = "无后续",
				attain = 51,
				aim = "霜狼氏族的战士身上带着一种名叫暴风水晶的符咒，我们可以用这些符咒来召唤伊弗斯。快去拿来那些水晶吧.",
				title = "在募集大约200个风暴水晶后，大德鲁伊伊类弗拉尔开始向（奥特兰克山谷 - 北部地图（ "..YELLOW.."[19]"..WHITE.."）移动，他将启动召唤法阵需要10个玩家去协助召唤。如果成功，森林之王伊弗斯将被召唤出来帮助抵抗部落.",
				location = "大德鲁伊雷弗拉尔  (奥特兰克山谷 - 北部地图; "..YELLOW.."[2]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "你可以从对方阵营的尸体上得到这些勋章.",
				followup = "无后续",
				attain = 51,
				aim = "我的狮鹫兽应该在前线作战，但是在那里的敌人被削弱之前，它们是无法发动攻击的。部落的战士胸前挂着代表荣誉的勋章勇猛冲锋，而你要做的就是从他们腐烂的尸体上把勋章拿下来，并把它们交视只要敌人在前线的力量受到足够的打击，我就会发出命令进行空袭!我们将从空中给敌人造成致命的创伤!!",
				title = "天空的召唤 - 斯里多尔的空军", -- 6942
				location = "空军指挥官斯里多尔 (奥特兰克山谷 - 北部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "你可以从对方阵营的尸体上得到这些勋章.",
				followup = "无后续",
				attain = 51,
				aim = "你必须去对付守卫前线的部落精英士兵!我现在命令你去削弱那些绿皮蛮子的力量，把他们的中尉和军团士兵的勋章给我拿来。当我拿到足够的勋章时，我会命令开始对他们进行空中打击的.",
				title = "天空的召唤 - 维波里的空军", -- 6941
				location = "空军指挥官维波里 (奥特兰克山谷 - 北部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[17] = {
				note = "你可以从对方阵营的尸体上得到这些勋章.",
				followup = "无后续",
				attain = 51,
				aim = "它们的士气很低，战士。自从我们上次对部落的空中打击失败之后，它们就拒绝再次飞行!你必须鼓舞它们的士气。回到战场并攻击部落的核心力量，杀死他们的指挥官和卫兵。尽可能带回更多的勋章!我向你保证，当我的狮鹫兽看到这些战利品并嗅到敌人的鲜血时，它们就会再次起飞!现在就出发吧!",
				title = "天空的召唤 - 艾克曼的空军", -- 6943
				location = "空军指挥官艾克曼 (奥特兰克山谷 - 北部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "到希尔斯布莱德丘陵地区的奥特兰克山谷去。找到拉格隆德并和他谈谈，然后成为霜狼氏族的士兵.",
				followup = "实验场", -- 7162
				attain = 51,
				aim = "到希尔斯布莱德丘陵地区的奥特兰克山谷去。找到拉格隆德并和他谈谈，然后成为霜狼氏族的士兵.",
				title = "保卫霜狼氏族", -- 7241
				location = "霜狼大使 (奥格瑞玛 - 力量谷 "..YELLOW.."50,71"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "霜狼战旗位于野爪洞穴（奥特兰克山谷 - 南部; "..YELLOW.."[9]"..WHITE.."）中。每当你获得新的声望等级时，与同一NPC交谈以获得升级的徽记。\n\n完成前置任务并非获得此任务的必要条件，但它可以获得约9550点经验值。",
				followup = "崭露头角 -> 命令之眼", -- 7168 -> 7172
				attain = 51,
				aim = "到主基地东南边的蛮爪洞穴中去找到霜狼军旗，然后把它交给拉格隆德.",
				title = "实验场", -- 7162
				location = "到希尔斯布莱德丘陵地区的奥特兰克山谷去。找到拉格隆德并和他谈谈，然后成为霜狼氏族的士兵.",
				level = 60,
				rewards = {
					[1] = {
						name = "Frostwolf Insignia Rank 1",
						id = 17690,
						subtext = "饰品",
						icon = "INV_Jewelry_FrostwolfTrinket_01",
						quality = 2,
					},
					[2] = {
						name = "Peeling the Onion",
						id = 19483,
						subtext = "物品",
						icon = "INV_Misc_Book_07",
						quality = 1,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "保卫霜狼氏族", -- 7241
			},
			[3] = {
				note = "范达尔·雷矛位于（奥特兰克山谷 - 北部; "..YELLOW.."[B]"..WHITE.."）。实际上，完成任务并不需要击败他。战场只需要以你方获胜的方式完成即可。\n完成任务后，再次与NPC交谈以获得奖励。",
				followup = "霜狼氏族的英雄", -- 8272
				attain = 51,
				aim = "进入奥特兰克山谷，击败矮人将军范达尔·雷矛。然后回到沃加·死爪那里.",
				title = "为奥特兰克而战", -- 7142
				location = "进入奥特兰克山谷，击败矮人将军范达尔·雷矛。然后回到沃加·死爪那里.",
				level = 60,
				rewards = {
					[1] = {
						name = "血刺",
						id = 19107,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_07",
						quality = 3,
					},
					[2] = {
						name = "冰刺长矛",
						id = 19106,
						subtext = "长柄武器",
						icon = "INV_Spear_04",
						quality = 3,
					},
					[3] = {
						name = "寒冷咬噬者",
						id = 19108,
						subtext = "魔杖",
						icon = "INV_Wand_01",
						quality = 3,
					},
					[4] = {
						name = "冰冷锻造之锤",
						id = 20648,
						subtext = "主手 锤",
						icon = "INV_Hammer_22",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "霜狼军需官 在 "..YELLOW.."[10]"..WHITE.." .",
				followup = "无后续",
				attain = 51,
				aim = "与霜狼军需官谈一谈.",
				title = "霜狼军需官", -- 7123
				location = "乔泰克 (奥特兰克山谷 - 南部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "补给品 可以在冷齿矿洞找到 (奥特兰克山谷 - 南部地图; "..YELLOW.."[6]"..WHITE..").",
				followup = "无后续",
				attain = 51,
				aim = "把10份冷齿矿洞补给品交给霜狼要塞的部落军需官.",
				title = "冷齿矿洞的补给", -- 6982
				location = "霜狼军需官 (奥特兰克山谷 - 南部地图; "..YELLOW.."[10]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "补给品 可以在深铁矿洞找到 (奥特兰克山谷 - 北部地图; "..YELLOW.."[1]"..WHITE..").",
				followup = "无后续",
				attain = 51,
				aim = "把10份深铁矿洞补给品交给霜狼要塞的部落军需官.",
				title = "深铁矿洞的补给", -- 5892
				location = "霜狼军需官 (奥特兰克山谷 - 南部地图; "..YELLOW.."[10]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[7] = {
				note = "这是个可重复任务.",
				followup = "更多的物资!", -- 6741
				attain = 51,
				aim = "给霜狼村的铁匠雷格萨带去20块护甲碎片.",
				title = "敌人的物资", -- 7224
				location = "铁匠雷格萨 (奥特兰克山谷 - 南部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[8] = {
				note = "要完成任务，你必须在联盟控制的情况下，在铁深矿洞（奥特兰克山谷 - 北部; "..YELLOW.."[1]"..WHITE.."）击败莫洛克，或在冷牙矿洞（奥特兰克山谷 - 南部; "..YELLOW.."[6]"..WHITE.."）击败工头斯尼维尔。",
				followup = "无后续",
				attain = 51,
				aim = "占领一座矿洞，然后向霜狼村的霜狼军需官报告.",
				title = "占领矿洞", -- 7122
				location = "占领一座墓地，然后向霜狼村的亚斯拉复命.",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "据报道，为了完成任务，实际上并不需要摧毁塔楼或碉堡，只需要进行攻击即可。",
				followup = "无后续",
				attain = 51,
				aim = "占领敌方的某座哨塔，然后向霜狼村的提卡·血牙复命.",
				title = "哨塔和碉堡", -- 7102
				location = "占领一座墓地，然后向霜狼村的亚斯拉复命.",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[10] = {
				note = "据报道，当部落攻击墓地时，你只需要靠近墓地，无需采取其他行动。墓地无需被占领，只需进行攻击即可完成任务。",
				followup = "无后续",
				attain = 51,
				aim = "占领一座墓地，然后向霜狼村的亚斯拉复命.",
				title = "奥特兰克山谷的墓地", -- 7082
				location = "占领一座墓地，然后向霜狼村的亚斯拉复命.",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[11] = {
				note = "你可以在基地外找到一只霜狼。驯服的过程就像猎人驯服宠物一样。同一玩家或玩家组在同一战场内可以重复完成该任务最多25次。在驯服了25只公羊后，霜狼骑兵将前来协助战斗。",
				followup = "无后续",
				attain = 51,
				aim = "找到奥特兰克山谷中的霜狼。使用霜狼口套来驯服它们。被驯服的霜狼会跟随你回到兽栏管理员那里，然后与兽栏管理员谈话以获得你的奖励.",
				title = "补充坐骑", -- 7027
				location = "霜狼兽栏管理员 (奥特兰克山谷 - 南部地图; "..YELLOW.."[9]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[12] = {
				note = "羊能在北部的奥特兰克山谷找到.",
				followup = "无后续",
				attain = 51,
				aim = "杀死雷矛卫队用作坐骑的山羊，我们就可以将羊皮作为我们的坐垫",
				title = "羊皮坐具", -- 7002
				location = "霜狼骑兵指挥官 (奥特兰克山谷 - 南部地图; "..YELLOW.."[9]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[13] = {
				note = "在提交大约150个血液后，原始法师苏尔洛加将开始朝着（奥特兰克山谷 - 南部; "..YELLOW.."[14]"..WHITE.."）行进。一旦到达那里，她将开始一个召唤仪式，需要10个人的协助。如果成功，冰霜领主洛克霍拉将被召唤出来击杀联盟玩家。",
				followup = "无后续",
				attain = 51,
				aim = "你可以选择提供更多从敌人身上获取的血液。我很乐意接受加仑大小的供奉。",
				title = "联盟之血", -- 7385
				location = "指挥官瑟鲁加  (奥特兰克山谷 - 南部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[14] = {
				note = "在提交大约150个血液后，原始法师苏尔洛加将开始朝着（奥特兰克山谷 - 南部; "..YELLOW.."[14]"..WHITE.."）行进。一旦到达那里，她将开始一个召唤仪式，需要10个人的协助。如果成功，冰霜领主洛克霍拉将被召唤出来击杀联盟玩家。",
				followup = "无后续",
				attain = 51,
				aim = "收集足够的联盟之血后，你就可以召唤冰雪之王.",
				title = "在提交大约150个血液后，原始法师苏尔洛加将开始朝着（奥特兰克山谷 - 南部; "..YELLOW.."[14]"..WHITE.."）行进。一旦到达那里，她将开始一个召唤仪式，需要10个人的协助。如果成功，冰霜领主洛克霍拉将被召唤出来击杀联盟玩家。",
				location = "指挥官瑟鲁加  (奥特兰克山谷 - 南部地图; "..YELLOW.."[8]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[15] = {
				note = "击杀部落NPC以获取雷矛士兵的肉。据报道，需要90块肉来让飞行指挥官执行她的任务。",
				followup = "无后续",
				attain = 51,
				aim = "我的骑手们准备在中央战场发起攻击，但首先，我必须激发他们的战斗欲望，为进攻做好准备。我需要足够的雷矛士兵肉来喂养整个舰队！数百磅！你肯定能应付得了，对吗？赶快行动起来！",
				title = "天空的召唤 - 古斯的部队", -- 6825
				location = "空军指挥官古斯 (奥特兰克山谷 - 南部地图; "..YELLOW.."[13]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "你可以从对方阵营的尸体上得到这些东西",
				followup = "无后续",
				attain = 51,
				aim = "我的战争骑手们必须亲自品尝他们目标的肉体，这将确保我们对敌人进行精确打击！我的舰队是我们空中指挥部中第二强大的力量。因此，他们将袭击我们更强大的对手。为此，他们需要雷矛中尉的肉体。",
				title = "天空的召唤 - 杰斯托的部队", -- 6826
				location = "空军指挥官杰斯托  (奥特兰克山谷 - 南部地图; "..YELLOW.."[13]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[17] = {
				note = "你可以从对方阵营的尸体上得到这些东西",
				followup = "无后续",
				attain = 51,
				aim = "首先，我的战争骑手们需要有目标可以瞄准 - 高优先级目标。我需要给他们喂食雷矛指挥官的肉体。不幸的是，这些家伙深深地隐藏在敌人的阵地后方！你肯定有很多工作要做。",
				title = "天空的召唤 - 穆维里克的部队", -- 6827
				location = "空军指挥官穆维里克 (奥特兰克山谷 - 南部地图; "..YELLOW.."[13]"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
	},
	[37] = {
		name = "阿拉希盆地",
		story = "位于阿拉希高地的阿拉希盆地是一处激动人心的战场。盆地拥有丰富的资源，部落和联盟都对此垂涎不已。污染者和阿拉索联军在阿拉希盆地展开激战，想要为他们所在的阵营抢夺盆地中的资源.",
		[1] = {
			[1] = {
				note = "被攻击的位置在地图上标记为1至4。",
				followup = "无后续",
				attain = 50,
				aim = "进攻矿洞、伐木场、铁匠铺和农场，然后向避难谷地的奥斯莱特元帅复命.",
				title = "阿拉希盆地之战!", -- 8105
				location = "奥斯莱特元帅  (阿拉希高地-避难谷地; "..YELLOW.."46,45"..WHITE..")",
				level = 55,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你必须和阿拉索联军声望达到友善才能接到这个任务.",
				followup = "无后续",
				attain = 60,
				aim = "进入阿拉希盆地，同时占据并控制四座基地，当任务完成之后向避难谷地的奥斯莱特元帅报告.",
				title = "控制四座基地", -- 8114
				location = "奥斯莱特元帅  (阿拉希高地-避难谷地; "..YELLOW.."46,45"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你必须和阿拉索联军达到崇拜才能接到这个任务.",
				followup = "无后续",
				attain = 60,
				aim = "进入阿拉希盆地，同时占据并控制四座基地，当任务完成之后向避难谷地的奥斯莱特元帅报告.",
				title = "控制五座基地", -- 8115
				location = "奥斯莱特元帅  (阿拉希高地-避难谷地; "..YELLOW.."46,45"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "Arathor Battle Tabard",
						id = 20132,
						subtext = "徽章",
						icon = "INV_Shirt_GuildTabard_01",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "被攻击的位置在地图上标记为1至4。",
				followup = "无后续",
				attain = 25,
				aim = "进攻阿拉希盆地的矿洞、伐木场、铁匠铺和兽栏，然后向落锤镇的屠杀者杜维尔复命.",
				title = "阿拉希盆地之战!", -- 8105
				location = "屠杀者杜维尔 (阿拉希高地 - 落槌镇; "..YELLOW.."74,35"..WHITE..")",
				level = 25,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你必须和污染者声望达到友善才能接到任务.",
				followup = "无后续",
				attain = 60,
				aim = "同时占据阿拉希盆地中的四座基地，然后向落锤镇的屠杀者杜维尔复命.",
				title = "夺取四座基地", -- 8121
				location = "屠杀者杜维尔 (阿拉希高地 - 落槌镇; "..YELLOW.."74,35"..WHITE..")",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "你必须和污染者声望达到崇敬才能接到.",
				followup = "无后续",
				attain = 60,
				aim = "同时占据阿拉希盆地中的五座基地，然后向落锤镇的屠杀者杜维尔复命.",
				title = "夺取五座基地", -- 8122
				location = "屠杀者杜维尔 (阿拉希高地 - 落槌镇; "..YELLOW.."74,35"..WHITE..")",
				level = 60,
				rewards = {
					[1] = {
						name = "Battle Tabard of the Defilers",
						id = 20131,
						subtext = "徽章",
						icon = "INV_Shirt_GuildTabard_01",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
	},
	[38] = {
		name = "战歌峡谷",
		story = "战歌峡谷位于灰谷森林南部。在第三次兽人战争中，格罗姆·地狱咆哮和他麾下的兽人们几乎将战歌峡谷附近的森林砍伐殆尽。其中部分兽人仍然盘踞在这里，继续砍伐着森林，想要扩张部落的势力范围。他们称自己为战歌侦查骑兵。\n\n暗夜精灵早已纠集兵力，打算收复灰谷森林。他们想要将战歌侦察骑兵彻底赶出这片土地。因此，银翼哨兵挺身而出，发誓在将兽人驱逐出战歌峡谷之前他们决不休息. ",
		[1] = {
		},
		[2] = {
		},
	},
	[39] = {
		name = "新月林地",
		story = "位于灰谷南部，俯瞰着密斯特拉湖的一个隐藏的树林，在几年间曾是德鲁伊的避难所，但现在邪恶的存在已经在这个地区扎根。\n原本是德鲁伊们的宁静避难所的隐藏树林，在最近，格罗夫维尔德部族逃离了邪恶的福尔维尔德部族的疯狂，占领了这里，并在此过程中驱逐了一些原住民。然而，尽管他们试图逃离疯狂，但最终还是屈服于它。\n卡拉纳·光辉曾经住在这里，直到被格罗夫维尔德的熊怪驱逐，并且他的家被烧毁。\n由末日守卫拉克西斯率领的燃烧军团的恶魔势力已经在这片树林中建立起来，开始腐化这片林地。燃烧军团已经以邪恶荆棘之痕的形式留下了他们的痕迹，打破了平衡，扰乱了灵魂。",
		[1] = {
			[1] = {
				note = "“独眼长老”的爪子和“黑喉长老”的爪子从第一位boss格罗夫守护者恩格里斯的手下掉落 "..YELLOW.."[2]"..WHITE.." 。",
				followup = "无后续",
				attain = 32,
				aim = "将新月林地内的“独眼长老”和“黑喉长老”的爪子交给流亡者格罗尔。",
				title = "(TW)1. 不明智的长者", -- 40090
				location = "流亡者格罗尔（灰谷，在阿斯特兰纳和费伍德之间的道路上，靠近北方的熊怪营地；"..YELLOW.."56.1,59.2"..WHITE.."）。",
				level = 34,
				rewards = {
					[1] = {
						name = "格罗尔的戒指", -- 60179
						id = 60179,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "格罗夫维尔德徽章从地下城内的任何精英熊怪身上掉落，也可以在地下城入口外的区域掉落。",
				followup = "无后续",
				attain = 32,
				aim = "进入新月林地，从里面的熊怪身上收集8个格罗夫维尔德徽章，交给流亡者格罗尔。",
				title = "(TW)2. 猖獗的格罗夫威尔德", -- 40089
				location = "流亡者格罗尔（灰谷，在阿斯特兰纳和费伍德之间的道路上，靠近北方的熊怪营地；"..YELLOW.."56.1,59.2"..WHITE.."）。",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "卡拉纳的木槌在烧毁的房子后面的箱子里 "..YELLOW.."[1]"..WHITE.." 。",
				followup = "无后续",
				attain = 32,
				aim = "前往新月林地，找到卡拉纳·明煌的烧毁的家，并取回卡拉纳的木槌，然后将其归还给他在阿斯特兰纳。",
				title = "(TW)3. 卡拉纳尔的木槌", -- 40326
				location = "卡拉纳·明煌（灰谷 - 阿斯特兰纳；"..YELLOW.."35.9,51.6"..WHITE.."）。",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "击败最终Boss拉克希斯大师 "..YELLOW.."[6]"..WHITE..".\n任务线从洛鲁克·林地行者那里开始，接任务“林地的秘密”。",
				followup = "无后续",
				attain = 32,
				aim = "摧毁新月林地内的腐化源，并返回泰达希尔找到德纳萨里奥。",
				title = "新月林地",
				location = "德纳萨里奥 <德鲁伊训练师>（达纳苏斯 - 塞纳里奥议会）",
				level = 37,
				rewards = {
					[1] = {
						name = "给哨兵岭哨塔的哨兵瑞尔带回10条红色丝质面罩。",
						id = 60180,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_12",
						quality = 3,
					},
					[2] = {
						name = "特工斗篷", -- 70239
						id = 60181,
						subtext = "背部",
						icon = "INV_Misc_Cape_09",
						quality = 3,
					},
					[3] = {
						name = "Epaulets of Denatharion", -- 60182
						id = 60182,
						subtext = "肩部 布甲",
						icon = "INV_Shoulder_05",
						quality = 3,
					},
					[4] = {
						name = "乌黑面具",
						id = 60183,
						subtext = "头部 皮甲",
						icon = "INV_Helmet_32",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "“独眼长老”的爪子和“黑喉长老”的爪子从第一位boss格罗夫守护者恩格里斯的手下掉落 "..YELLOW.."[2]"..WHITE.." 。",
				followup = "无后续",
				attain = 32,
				aim = "将新月林地内的“独眼长老”和“黑喉长老”的爪子交给流亡者格罗尔。",
				title = "(TW)1. 不明智的长者", -- 40090
				location = "流亡者格罗尔（灰谷，在阿斯特兰纳和费伍德之间的道路上，靠近北方的熊怪营地；"..YELLOW.."56.1,59.2"..WHITE.."）。",
				level = 34,
				rewards = {
					[1] = {
						name = "格罗尔的戒指", -- 60179
						id = 60179,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "格罗夫维尔德徽章从地下城内的任何精英熊怪身上掉落，也可以在地下城入口外的区域掉落。",
				followup = "无后续",
				attain = 32,
				aim = "进入新月林地，从里面的熊怪身上收集8个格罗夫维尔德徽章，交给流亡者格罗尔。",
				title = "(TW)2. 猖獗的格罗夫威尔德", -- 40089
				location = "流亡者格罗尔（灰谷，在阿斯特兰纳和费伍德之间的道路上，靠近北方的熊怪营地；"..YELLOW.."56.1,59.2"..WHITE.."）。",
				level = 33,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "击败最终Boss拉克希斯大师 "..YELLOW.."[6]"..WHITE..".\n任务线从洛鲁克·林地行者那里开始，接任务“林地的秘密”。",
				followup = "无后续",
				attain = 26,
				aim = "进入新月林地，清除内部的邪恶势力。",
				title = "(TW)3. 根除邪恶", -- 40147
				location = "洛鲁克·林地行者（灰谷 - 裂木岗哨 "..YELLOW.."73.3,59.3"..WHITE.."）",
				level = 37,
				rewards = {
					[1] = {
						name = "无情链甲",
						id = 60213,
						subtext = "胸部 锁甲",
						icon = "INV_Chest_Chain_07",
						quality = 3,
					},
					[2] = {
						name = "特工斗篷", -- 70239
						id = 60214,
						subtext = "背部",
						icon = "INV_Misc_Cape_18",
						quality = 3,
					},
					[3] = {
						name = "洛鲁克·林地行者（灰谷 - 裂木岗哨 "..YELLOW.."73.3,59.3"..WHITE.."）",
						id = 60215,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_04",
						quality = 3,
					},
					[4] = {
						name = "格雷森的帽子",
						id = 60216,
						subtext = "头部 布甲",
						icon = "INV_Helmet_15",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "林地的秘密 -> 菲兰的报告", -- 40145, 40146
			},
		},
	},
	[40] = {
		name = "Hateforge Quarry",
		story = "仇恨熔炉采石场是位于燃烧平原的一个副本地下城。隐藏在燃烧平原东南墙壁的仇恨熔炉采石场是黑铁矮人寻找新武器以对抗敌人的最新努力。这个看似无害的石场隐藏着一个阴险的洞穴，影铸矮人在那里策划着对所有反对他们的人的新阴谋。",
		[1] = {
			[1] = {
				note = "仇恨熔炉采石场化学家掉落炽炉酿酒瓶，用于任务。",
				followup = "无后续",
				attain = 47,
				aim = "找出仇恨熔炉采石场中正在挖掘的东西。",
				title = "(TW)1. 竞争对手的存在", -- 40458
				location = "监工油拳 <瑟银兄弟会>（灼热峡谷 - 瑟银哨站；"..YELLOW.."38.1,27.0"..WHITE.."）。",
				level = 54,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "任务线从莱德甘·深焰那里开始，接任务“赢得奥尔瓦克的信任”（燃烧平原 - 黑石小径；"..YELLOW.."76.1,67.6"..WHITE.."）。",
				followup = "无后续",
				attain = 45,
				aim = "在仇恨熔炉采石场击败20名炽炉矿工，然后回到燃烧平原的黑石小径找莫格里姆·火矛。",
				title = "(TW)2. 矿工工会叛变 II", -- 40468
				location = "在仇恨熔炉采石场击败20名炽炉矿工，然后回到燃烧平原的黑石小径找莫格里姆·火矛。",
				level = 50,
				rewards = {
					[1] = {
						name = "正义束缚", -- 60673
						id = 60673,
						subtext = "手腕 板甲",
						icon = "INV_Bracer_14",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "赢得奥尔瓦克的信任 -> 听奥尔瓦克的故事 -> 斯特恩洛克的藏宝地 -> 矿工工会的叛乱",
			},
			[3] = {
				note = "任务线从莱德甘·深焰那里开始，接任务“赢得奥尔瓦克的信任”（燃烧平原 - 黑石小径；"..YELLOW.."76.1,67.6"..WHITE.."）。",
				followup = "无后续",
				attain = 45,
				aim = "击败巴古尔·黑锤 "..YELLOW.."[1]"..WHITE.."，并从他的财物中找回议会的命令 "..YELLOW.."[从他的财物周围]"..WHITE.."，交给燃烧平原的奥尔瓦克·斯特恩洛克。",
				title = "(TW)3. 真正的高级工头", -- 40463
				location = "击败巴古尔·黑锤 "..YELLOW.."[1]"..WHITE.."，并从他的财物中找回议会的命令 "..YELLOW.."[从他的财物周围]"..WHITE.."，交给燃烧平原的奥尔瓦克·斯特恩洛克。",
				level = 51,
				rewards = {
					[1] = {
						name = "深焰印戒", -- 60665
						id = 60665,
						subtext = "戒指",
						icon = "BTNHarbingerRing",
						quality = 3,
					},
					[2] = {
						name = "斯特恩洛克的拖鞋", -- 60666
						id = 60666,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_07",
						quality = 3,
					},
					[3] = {
						name = "火矛的幸运裤子", -- 60667
						id = 60667,
						subtext = "腿部 布甲",
						icon = "INV_Pants_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "赢得奥尔瓦克的信任 -> 听奥尔瓦克的故事 -> 斯特恩洛克的藏宝地 -> 矿工工会的叛乱",
			},
			[4] = {
				note = "炽炉化学师掉落黑铁瓶用于任务。",
				followup = "无后续",
				attain = 45,
				aim = "深入仇恨熔炉采石场，找到一瓶黑铁瓶和炽炉化学文档 "..YELLOW.."[不知道具体在哪里]"..WHITE.."，然后回到燃烧平原的摩根斯岗哨找瓦拉格·暗须。",
				title = "(TW)4. 仇恨熔炉啤酒的传闻", -- 40490
				location = "深入仇恨熔炉采石场，找到一瓶黑铁瓶和炽炉化学文档 "..YELLOW.."[不知道具体在哪里]"..WHITE.."，然后回到燃烧平原的摩根斯岗哨找瓦拉格·暗须。",
				level = 54,
				rewards = {
					[1] = {
						name = "雷霆麦酒", -- 2686
						id = 2686,
						subtext = "物品",
						icon = "INV_Drink_13",
						quality = 1,
					},
					[2] = {
						name = "瓦拉格的爪子", -- 60699
						id = 60699,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_15",
						quality = 2,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "击败最后的首领哈格什·末日召唤者 "..YELLOW.."[5]"..WHITE.."。任务线从同一任务发放者处开始，接任务“调查仇恨熔炉采石场”。",
				followup = "无后续",
				attain = 45,
				aim = "进入仇恨熔炉采石场，清除深处的暮光之锤势力，完成后回到铁炉堡找玛格尼·铜须国王。",
				title = "(TW)5. 攻击仇恨熔炉", -- 40489
				location = "参议员石腰（燃烧平原 - 摩根斯岗哨；"..YELLOW.."85.2,67.9"..WHITE.."）。",
				level = 57,
				rewards = {
					[1] = {
						name = "格罗比的王冠", -- 60694
						id = 60694,
						subtext = "头部 锁甲",
						icon = "INV_Crown_01",
						quality = 3,
					},
					[2] = {
						name = "传统徽记", -- 60695
						id = 60695,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_43",
						quality = 3,
					},
					[3] = {
						name = "红宝石之心槌", -- 60696
						id = 60696,
						subtext = "单手，锤",
						icon = "INV_Hammer_04",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "调查仇恨熔炉采石场 -> 炽炉报告 -> 国王的回应",
			},
			[6] = {
				note = "Corrosis is at "..NORMAL.."[3]"..WHITE..".",
				followup = "Thunderforge Mastery",
				attain = 40,
				aim = "Obtain the Heart of Landslide from the depths of Maraudon, and the Essence of Corrosis from Hateforge Quarry for Frig Thunderforge at Aerie Peak",
				title = "Why Not Both?",
				location = "Frig Thunderforge (Hinterlands - Aerie Peak; "..NORMAL.."[10.0, 49.3]"..WHITE..").",
				level = 50,
				rewards = {
					[1] = {
						name = "Thunderforge Lance",
						id = 40080,
						subtext = "长柄武器",
						icon = "inv_spear_02",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "Proving A Point -> I've Read It In A Book Once",
			},
		},
		[2] = {
			[1] = {
				note = "仇恨熔炉采石场化学家掉落炽炉酿酒瓶，用于任务。",
				followup = "无后续",
				attain = 47,
				aim = "找出仇恨熔炉采石场中正在挖掘的东西。",
				title = "(TW)1. 竞争对手的存在", -- 40458
				location = "监工油拳 <瑟银兄弟会>（灼热峡谷 - 瑟银哨站；"..YELLOW.."38.1,27.0"..WHITE.."）。",
				level = 54,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "任务线从莱德甘·深焰那里开始，接任务“赢得奥尔瓦克的信任”（燃烧平原 - 黑石小径；"..YELLOW.."76.1,67.6"..WHITE.."）。",
				followup = "无后续",
				attain = 45,
				aim = "在仇恨熔炉采石场击败20名炽炉矿工，然后回到燃烧平原的黑石小径找莫格里姆·火矛。",
				title = "(TW)2. 矿工工会叛变 II", -- 40468
				location = "在仇恨熔炉采石场击败20名炽炉矿工，然后回到燃烧平原的黑石小径找莫格里姆·火矛。",
				level = 50,
				rewards = {
					[1] = {
						name = "正义束缚", -- 60673
						id = 60673,
						subtext = "手腕 板甲",
						icon = "INV_Bracer_14",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "赢得奥尔瓦克的信任 -> 听奥尔瓦克的故事 -> 斯特恩洛克的藏宝地 -> 矿工工会的叛乱",
			},
			[3] = {
				note = "任务线从莱德甘·深焰那里开始，接任务“赢得奥尔瓦克的信任”（燃烧平原 - 黑石小径；"..YELLOW.."76.1,67.6"..WHITE.."）。",
				followup = "无后续",
				attain = 45,
				aim = "击败巴古尔·黑锤 "..YELLOW.."[1]"..WHITE.."，并从他的财物中找回议会的命令 "..YELLOW.."[从他的财物周围]"..WHITE.."，交给燃烧平原的奥尔瓦克·斯特恩洛克。",
				title = "(TW)3. 真正的高级工头", -- 40463
				location = "击败巴古尔·黑锤 "..YELLOW.."[1]"..WHITE.."，并从他的财物中找回议会的命令 "..YELLOW.."[从他的财物周围]"..WHITE.."，交给燃烧平原的奥尔瓦克·斯特恩洛克。",
				level = 51,
				rewards = {
					[1] = {
						name = "深焰印戒", -- 60665
						id = 60665,
						subtext = "戒指",
						icon = "BTNHarbingerRing",
						quality = 3,
					},
					[2] = {
						name = "斯特恩洛克的拖鞋", -- 60666
						id = 60666,
						subtext = "脚部 皮甲",
						icon = "INV_Boots_07",
						quality = 3,
					},
					[3] = {
						name = "火矛的幸运裤子", -- 60667
						id = 60667,
						subtext = "腿部 布甲",
						icon = "INV_Pants_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "赢得奥尔瓦克的信任 -> 听奥尔瓦克的故事 -> 斯特恩洛克的藏宝地 -> 矿工工会的叛乱",
			},
			[4] = {
				note = "",
				followup = "无后续",
				attain = 48,
				aim = "在仇恨熔炉采石场击败工程师费格尔斯 "..YELLOW.."[2]"..WHITE.."，为狼女卡塔拉完成任务。",
				title = "(TW)4. 狩猎工程师菲格斯", -- 40539
				location = "狼女卡塔拉（燃烧平原 - 卡弗恩要塞；"..YELLOW.."89.4,24.5"..WHITE.."，燃烧平原的东北角）。",
				level = 55,
				rewards = {
					[1] = {
						name = "烈焰之手手套", -- 60771
						id = 60771,
						subtext = "手部 布甲",
						icon = "INV_Gauntlets_18",
						quality = 2,
					},
					[2] = {
						name = "纳瓦凯什的毛皮", -- 60772
						id = 60772,
						subtext = "背部",
						icon = "INV_Misc_Cape_04",
						quality = 2,
					},
					[3] = {
						name = "黑石权威", -- 60773
						id = 60773,
						subtext = "单手，锤",
						icon = "INV_Mace_12",
						quality = 2,
					},
					[4] = {
						name = "加尔隆的腰带", -- 60774
						id = 60774,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_03",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "奇怪的无法应付", -- 40538
			},
			[5] = {
				note = "击败最后的首领哈格什·末日召唤者 "..YELLOW.."[5]"..WHITE.."。任务线从议员瓦尔格克（燃烧平原 - 卡弗恩要塞；"..YELLOW.."90.0,22.7"..WHITE.."，燃烧平原的东北角）处开始，接任务“新与旧”。",
				followup = "无后续",
				attain = 45,
				aim = "进入仇恨熔炉采石场，清除卡弗恩要塞内的暮光之锤势力，完成后回到卡弗恩。",
				title = "(TW)5. 新与旧 IV", -- 40504
				location = "狼女卡塔拉（燃烧平原 - 卡弗恩要塞；"..YELLOW.."89.4,24.5"..WHITE.."，燃烧平原的东北角）。",
				level = 57,
				rewards = {
					[1] = {
						name = "战争领袖之刃", -- 60734
						id = 60734,
						subtext = "主手 剑",
						icon = "INV_Weapon_ShortBlade_05",
						quality = 3,
					},
					[2] = {
						name = "黑曜石宝石项链", -- 60735
						id = 60735,
						subtext = "颈部",
						icon = "BTNEmptyAmulet",
						quality = 3,
					},
					[3] = {
						name = "战斗大师头盔", -- 60736
						id = 60736,
						subtext = "头部，板甲",
						icon = "INV_Helmet_10",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "新与旧 -> 新与旧 II -> 新与旧 III", -- 40501, 40502, 40503
			},
		},
	},
	[41] = {
		name = "卡拉赞墓穴",
		story = "卡拉赞墓穴是位于燃烧平原的一个副本地下城。在这个荒凉的地下墓穴中，有某种力量扭曲着死者的灵魂，找到源头，让死者再次安息。",
		[1] = {
			[1] = {
				note = "击败最后的首领阿拉鲁斯 "..YELLOW.."[7]"..WHITE.."。任务线从同一NPC迪斯塔尔魔导师在逆风小径开始。完成任务线的第6部分后，你将获得打开入口门的钥匙。",
				followup = "无后续",
				attain = 58,
				aim = "进入卡拉赞墓穴，击败看守者阿拉鲁斯，为迪斯塔尔魔导师在逆风小径完成任务。",
				title = "(TW)1. 卡拉赞之谜 VII", -- 40317
				location = "迪斯塔尔魔导师（逆风小径 "..YELLOW.."52.4,34.3"..WHITE.."，逆风小径的东北部，从东部T字路口向北）。",
				level = 60,
				rewards = {
					[1] = {
						name = "奥术充能吊坠", -- 60463
						id = 60463,
						subtext = "颈部",
						icon = "INV_Misc_Rune_03",
						quality = 3,
					},
					[2] = {
						name = "卡拉顿之球", -- 60464
						id = 60464,
						subtext = "饰品",
						icon = "INV_Misc_Orb_01",
						quality = 3,
					},
					[3] = {
						name = "奥术强化戒指", -- 60465
						id = 60465,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_51Naxxramas",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "(TW)1. 卡拉赞之谜 VII", -- 40317
			},
		},
		[2] = {
			[1] = {
				note = "击败最后的首领阿拉鲁斯 "..YELLOW.."[7]"..WHITE.."。任务线从同一NPC科尔甘在斯通纳德开始。完成任务线的第6部分后，你将获得打开入口门的钥匙。",
				followup = "无后续",
				attain = 58,
				aim = "进入卡拉赞墓穴，击败看守者阿拉鲁斯，为斯通纳德的科尔甘完成任务。",
				title = "(TW)1. 卡拉赞深渊 VII", -- 40310
				location = "科尔甘（悲伤沼泽 - 斯通纳德; "..YELLOW.."44,4,54.6"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "充能奥术戒指", -- 60459
						id = 60459,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_35",
						quality = 3,
					},
					[2] = {
						name = "加尔顿的獠牙", -- 60460
						id = 60460,
						subtext = "颈部",
						icon = "INV_Misc_Bone_05",
						quality = 3,
					},
					[3] = {
						name = "黑火宝珠", -- 60461
						id = 60461,
						subtext = "饰品",
						icon = "INV_Misc_Orb_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "(TW)1. 卡拉赞深渊 VII", -- 40310
			},
		},
	},
	[42] = {
		name = "黑色沼泽",
		story = "黑色沼泽是位于塔纳利斯的一个副本地下城。穿越时间之道，阻止无尽龙族改变黑暗之门的开启和过去本身。",
		[1] = {
			[1] = {
				note = "安特诺米是黑色沼泽的最后一个首领。\n任务线从雷恩（东瘟疫之地 - 圣光之愿礼拜堂 "..YELLOW.."81.2,59.0"..WHITE.."）的任务“时机成熟”开始。",
				followup = "无后续",
				attain = 60,
				aim = "进入黑色沼泽的过去，击败安特诺米，并将她的头颅带给凯娅。",
				title = "(TW)1. 黑暗之门的首次开启", -- 80605
				location = "克罗米（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					[1] = {
						name = "X-51奥术眼植入物", -- 82950
						id = 82950,
						subtext = "头部 布甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					[2] = {
						name = "X-52隐形眼植入物", -- 82951
						id = 82951,
						subtext = "头部 皮甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					[3] = {
						name = "X-53游侠眼植入物", -- 82952
						id = 82952,
						subtext = "头部 锁甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					[4] = {
						name = "X-54守护者眼植入物", -- 82953
						id = 82953,
						subtext = "头部，板甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "时机成熟 -> 无尽的猎杀 -> 进入洞穴的旅程", -- 80410, 80411, 80604
			},
			[2] = {
				note = "克罗纳尔 "..YELLOW..""..WHITE.."是黑色沼泽的第一个首领。",
				followup = "无后续",
				attain = 58,
				aim = "击败克罗纳尔，并将他的头颅带给时光之穴的泰瓦德里斯。",
				title = "(TW)2. 青铜的背叛", -- 40342
				location = "泰瓦德里斯（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					[1] = {
						name = "泰瓦德里斯的垂饰", -- 60497
						id = 60497,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_08",
						quality = 3,
					},
					[2] = {
						name = "青铜卫士之戟", -- 60498
						id = 60498,
						subtext = "双手，长柄武器",
						icon = "INV_Spear_01",
						quality = 3,
					},
					[3] = {
						name = "泰瓦德里斯之戒", -- 60499
						id = 60499,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_14",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "",
				followup = "无后续",
				attain = 58,
				aim = "在时光之穴为德鲁诺姆收集一份腐化沙土。",
				title = "(TW)3. 腐化之沙", -- 40340
				location = "德鲁诺姆（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "",
				followup = "无后续",
				attain = 58,
				aim = "在时光之穴为德鲁诺姆收集一份腐化沙土。",
				title = "(TW)4. 散装沙子", -- 40341
				location = "德鲁诺姆（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "安特诺米是黑色沼泽的最后一个首领。\n任务线从雷恩（东瘟疫之地 - 圣光之愿礼拜堂 "..YELLOW.."81.2,59.0"..WHITE.."）的任务“时机成熟”开始。",
				followup = "无后续",
				attain = 60,
				aim = "进入黑色沼泽的过去，击败安特诺米，并将她的头颅带给凯娅。",
				title = "(TW)1. 黑暗之门的首次开启", -- 80605
				location = "克罗米（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					[1] = {
						name = "X-51奥术眼植入物", -- 82950
						id = 82950,
						subtext = "头部 布甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					[2] = {
						name = "X-52隐形眼植入物", -- 82951
						id = 82951,
						subtext = "头部 皮甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					[3] = {
						name = "X-53游侠眼植入物", -- 82952
						id = 82952,
						subtext = "头部 锁甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					[4] = {
						name = "X-54守护者眼植入物", -- 82953
						id = 82953,
						subtext = "头部，板甲",
						icon = "inv_gizmo_newgoggles",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "时机成熟 -> 无尽的猎杀 -> 进入洞穴的旅程", -- 80410, 80411, 80604
			},
			[2] = {
				note = "克罗纳尔 "..YELLOW..""..WHITE.."是黑色沼泽的第一个首领。",
				followup = "无后续",
				attain = 58,
				aim = "击败克罗纳尔，并将他的头颅带给时光之穴的泰瓦德里斯。",
				title = "(TW)2. 青铜的背叛", -- 40342
				location = "泰瓦德里斯（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					[1] = {
						name = "泰瓦德里斯的垂饰", -- 60497
						id = 60497,
						subtext = "颈部",
						icon = "INV_Jewelry_Necklace_08",
						quality = 3,
					},
					[2] = {
						name = "青铜卫士之戟", -- 60498
						id = 60498,
						subtext = "双手，长柄武器",
						icon = "INV_Spear_01",
						quality = 3,
					},
					[3] = {
						name = "泰瓦德里斯之戒", -- 60499
						id = 60499,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_14",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "",
				followup = "无后续",
				attain = 58,
				aim = "在时光之穴为德鲁诺姆收集一份腐化沙土。",
				title = "(TW)3. 腐化之沙", -- 40340
				location = "德鲁诺姆（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "",
				followup = "无后续",
				attain = 58,
				aim = "在时光之穴为德鲁诺姆收集一份腐化沙土。",
				title = "(TW)4. 散装沙子", -- 40341
				location = "德鲁诺姆（塔纳利斯 - 时光之穴）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
		},
	},
	[43] = {
		name = "暴风城地牢",
		story = "暴风城地牢是位于暴风城的副本地下城。地下室的守护符文正在削弱，其中的恶魔再次威胁着艾泽拉斯，你必须冒险下去，一劳永逸地阻止这些恶魔。",
		[1] = {
			[1] = {
				note = "你可以在地下城前的暴风城街道上找到科利·蒸心。",
				followup = "无后续",
				attain = 55,
				aim = "在暴风城地牢内，击败符文构造体，获得2个符文束缚，然后将它们交给科利·蒸心。",
				title = "(TW)1. 恢复地牢枷锁", -- 40426
				location = "科利·蒸心（暴风城 "..YELLOW.."54.5,47.1"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你可以在地下城前的暴风城街道上找到佩平·安斯沃斯。\n阿克提拉斯 "..YELLOW.."[6]"..WHITE.." 是地下城中最后的战斗，他是一个带有大蓝色水晶的怪物。",
				followup = "无后续",
				attain = 55,
				aim = "深入暴风城地牢，找到阿克提拉斯并击败他，为了暴风城的利益。完成后，回到佩平·安斯沃斯。",
				title = "(TW)2. 结束阿克提拉斯", -- 40427
				location = "佩平·安斯沃斯（暴风城 "..YELLOW.."54.5,47.2"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "镀金皇家十字弓", -- 60624
						id = 60624,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_03",
						quality = 3,
					},
					[2] = {
						name = "暴风城黄金护手", -- 60625
						id = 60625,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_04",
						quality = 3,
					},
					[3] = {
						name = "华贵金线腰带", -- 60626
						id = 60626,
						subtext = "腰部 布甲",
						icon = "INV_Belt_07",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "神秘的奥术细节和魔法现象第九卷被藏在暴风城地牢的深处。\n马泽恩·麦克纳迪尔位于斯托卡德副本入口的西南建筑物内。",
				followup = "无后续",
				attain = 55,
				aim = "为马泽恩·麦克纳迪尔在暴风城找回奥术细节和魔法现象第九卷。",
				title = "(TW)3. 错综复杂的奥术与魔法现象之书 IX", -- 40425
				location = "马泽恩·麦克纳迪尔（暴风城 "..YELLOW.."41.6,64.3"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "学院之戒", -- 60622
						id = 60622,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_48Naxxramas",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "你可以在地下城前的暴风城街道上找到科利·蒸心。",
				followup = "无后续",
				attain = 55,
				aim = "在暴风城地牢内，击败符文构造体，获得2个符文束缚，然后将它们交给科利·蒸心。",
				title = "(TW)1. 恢复地牢枷锁", -- 40426
				location = "科利·蒸心（暴风城 "..YELLOW.."54.5,47.1"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "你可以在地下城前的暴风城街道上找到佩平·安斯沃斯。\n阿克提拉斯 "..YELLOW.."[6]"..WHITE.." 是地下城中最后的战斗，他是一个带有大蓝色水晶的怪物。",
				followup = "无后续",
				attain = 55,
				aim = "深入暴风城地牢，找到阿克提拉斯并击败他，为了暴风城的利益。完成后，回到佩平·安斯沃斯。",
				title = "(TW)2. 结束阿克提拉斯", -- 40427
				location = "佩平·安斯沃斯（暴风城 "..YELLOW.."54.5,47.2"..WHITE.."）",
				level = 60,
				rewards = {
					[1] = {
						name = "镀金皇家十字弓", -- 60624
						id = 60624,
						subtext = "弩",
						icon = "INV_Weapon_Crossbow_03",
						quality = 3,
					},
					[2] = {
						name = "暴风城黄金护手", -- 60625
						id = 60625,
						subtext = "手部 板甲",
						icon = "INV_Gauntlets_04",
						quality = 3,
					},
					[3] = {
						name = "华贵金线腰带", -- 60626
						id = 60626,
						subtext = "腰部 布甲",
						icon = "INV_Belt_07",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
		},
	},
	[44] = {
		name = "帕纳布斯 <流浪巫师>（吉尔尼斯； "..YELLOW.."[22.9,74.4]"..WHITE.."，吉尔尼斯城南部，河流的西边，一个孤独的房子里）。",
		story = "吉尔尼斯城是位于吉尔尼斯的地下城副本。吉尔尼斯城位于这片曾经孤立的土地的中心，曾经是人民希望的堡垒。在摆脱了阿拉索领主的统治后建立起来，它象征着坚韧和繁荣。然而，现在它只是昔日美丽的外壳，黑暗的存在笼罩着吉尔尼斯，提醒着人们它曾经辉煌的过去。远处的嚎叫回荡在城市中，令人心悸地提醒着它的新居民。然而，有可能并非所有人都离去，他们被诅咒的国王可能仍然活着。",
		[1] = {
			[1] = {
				note = "你可以在山上的建筑物内找到被激怒的幽灵。进入吉尔尼斯城门后，沿着左边（东边）的山脉前进，经过一个装有风车的田地，你会找到通往海边的小路，几乎到达边缘时，向北转弯，沿着（几乎看不见的）小路前进。",
				followup = "无后续",
				attain = 35,
				aim = "在吉尔尼斯城内击败萨瑟兰法官"..YELLOW.."[3]"..WHITE.."，并将其头颅交给吉尔尼斯的格莱摩尔农场的被激怒的幽灵。",
				title = "(TW)1. 审判与幻影", -- 40975
				location = "在吉尔尼斯城内击败萨瑟兰法官"..YELLOW.."[3]"..WHITE.."，并将其头颅交给吉尔尼斯的格莱摩尔农场的被激怒的幽灵。",
				level = 46,
				rewards = {
					[1] = {
						name = "格莱摩尔家族胸甲", -- 61620
						id = 61620,
						subtext = "胸部 锁甲",
						icon = "INV_Misc_MonsterSpiderCarapace_01",
						quality = 2,
					},
					[2] = {
						name = "吉尔尼斯仪式长矛", -- 61621
						id = 61621,
						subtext = "双手，长柄武器",
						icon = "INV_Spear_06",
						quality = 2,
					},
					[3] = {
						name = "格莱摩尔披肩", -- 61622
						id = 61622,
						subtext = "背部",
						icon = "INV_Chest_Cloth_15",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "黎明石计划书在建筑物内的"..YELLOW.."[a]"..WHITE.."上的盒子里。",
				followup = "无后续",
				attain = 36,
				aim = "进入吉尔尼斯城，为暴风城的瑟鲁姆·深炉找回黎明石计划书。",
				title = "(TW)2. 墙后", -- 40841
				location = "瑟鲁姆·深炉 <专家铁匠>（暴风城 - 矮人区 "..YELLOW.."63.3,37"..WHITE.."，可能会在那附近走动）",
				level = 41,
				rewards = {
					[1] = {
						name = "镶嵌式板鞋", -- 61348
						id = 61348,
						subtext = "脚部 板甲",
						icon = "INV_Boots_Plate_08",
						quality = 2,
					},
					[2] = {
						name = "矮人战斗钝器", -- 61349
						id = 61349,
						subtext = "主手 锤",
						icon = "INV_Mace_11",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "无前置",
			},
			[3] = {
				note = "拉文郡的契约在摄政夫人西莉亚·哈鲁恩和摄政王莫蒂默·哈鲁恩后面的桌子上，靠近哈鲁恩家族宝箱"..YELLOW.."[7]"..WHITE.."。",
				followup = "无后续",
				attain = 38,
				aim = "在吉尔尼斯城内找到拉文郡的契约，并将其带回给男爵卡利班·西尔弗莱恩。",
				title = "(TW)3. 拉文郡地契", -- 40966
				location = "男爵卡利班·西尔弗莱恩（吉尔尼斯 - 拉文郡（主楼） "..YELLOW.."58.4,67.8"..WHITE.."）",
				level = 45,
				rewards = {
					[1] = {
						name = "黑水战斧", -- 61601
						id = 61601,
						subtext = "单手，斧",
						icon = "INV_Axe_20",
						quality = 2,
					},
					[2] = {
						name = "吉尔尼斯步兵头盔", -- 61602
						id = 61602,
						subtext = "头部，板甲",
						icon = "inv_helmet_02",
						quality = 2,
					},
					[3] = {
						name = "拉文郡长袍", -- 61603
						id = 61603,
						subtext = "胸部 布甲",
						icon = "INV_Chest_Cloth_48",
						quality = 2,
					},
					[4] = {
						name = "灰郡护肩", -- 61604
						id = 61604,
						subtext = "肩部 皮甲",
						icon = "INV_Shoulder_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
			[4] = {
				note = "乌尔之书在建筑物内的"..YELLOW.."[b]"..WHITE.."，向右走，在桌子上（南侧）。",
				followup = "无后续",
				attain = 40,
				aim = "在吉尔尼斯城的图书馆中找回乌尔之书：第二卷，并将其归还给伊森·拉文克罗夫特。",
				title = "(TW)4. 审判与幻影", -- 40975
				location = "伊森·拉文克罗夫特（吉尔尼斯 - 空网墓地 - 地下室（吉尔尼斯的西南角，河流的东边）"..YELLOW.."33,76"..WHITE.."）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[5] = {
				note = "请带上1个大块闪光碎片，你需要1个作为前置任务。附魔师或拍卖行可以帮助你获得，价格应该不贵。",
				followup = "无后续",
				attain = 35,
				aim = "通过击败摄政夫人西莉亚·哈鲁恩和摄政王莫蒂默·哈鲁恩"..YELLOW.."[7]"..WHITE.."，结束对吉尔尼斯的龙族影响，为吉尔尼斯-拉文郡的大法师奥勒留斯完成任务。",
				title = "(TW)5. 抹除龙类的存在", -- 40943
				location = "大法师奥勒留斯 <肯瑞托>（吉尔尼斯 - 拉文郡（主楼） "..YELLOW.."57.7,68.5"..WHITE.."）",
				level = 47,
				rewards = {
					[1] = {
						name = "紫罗兰腰带", -- 61486
						id = 61486,
						subtext = "腰部 布甲",
						icon = "INV_Belt_10",
						quality = 3,
					},
					[2] = {
						name = "洞悉之握", -- 61487
						id = 61487,
						subtext = "手部 锁甲",
						icon = "INV_Gauntlets_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2",
				},
				prequest = "奥法之泉 -> 神奇的存在 -> 龙类的存在？", -- 40940, 40941, 40942
			},
			[6] = {
				note = "任务线从男爵卡利班·西尔弗莱恩那里开始，他位于吉尔尼斯的拉文郡（主楼） "..YELLOW.."58.4,67.8"..WHITE.."。\n格雷迈恩王冠从吉恩·格雷迈恩身上掉落"..YELLOW.."[8]"..WHITE.."，他是塔楼顶层的最后一位boss。",
				followup = "无后续",
				attain = 35,
				aim = "在吉尔尼斯的拉文郡为勋爵达瑞斯·鸦林找回格雷迈恩王冠。",
				title = "(TW)6. 格雷迈恩的衰落与崛起", -- 40956
				location = "勋爵达瑞斯·鸦林（吉尔尼斯 - 拉文郡（主楼） "..YELLOW.."58.4,67.6"..WHITE.."）",
				level = 42,
				rewards = {
					[1] = {
						name = "瑞文伍德腰带", -- 61497
						id = 61497,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_26",
						quality = 3,
					},
					[2] = {
						name = "吉尔尼斯印戒", -- 61498
						id = 61498,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_22",
						quality = 3,
					},
					[3] = {
						name = "拉文郡手套", -- 61499
						id = 61499,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_15",
						quality = 3,
					},
					[4] = {
						name = "拉文郡战袍", -- 61369
						id = 61369,
						subtext = "徽章",
						icon = "INV_Shirt_GuildTabard_01",
						quality = 1,
					},
					text = ""..GREY.." 和 "..WHITE.."",
				},
				prequest = "披着羊皮的狼 -> 一步一脚印 -> 传奇之路 -> 回到拉文郡 -> 黑暗中的微光 -> 卑劣的行径 -> 十字路口的交易 -> 突袭弗雷希尔要塞 ", -- 40948, 40949, 40950, 40951, 40952, 40953, 40954, 40955
			},
			[7] = {
				note = RED.."(仅法师可接)"..WHITE.." 法师塞拉摩传送任务。\n《水文手稿II》在建筑物内的"..YELLOW.."[b]"..WHITE.."，向右走，在梳妆台上（南侧）。",
				followup = "无后续",
				attain = 38,
				aim = "在尘泥沼泽的塞拉摩岛为大法师哈利斯特找回《水文手稿II》。",
				title = "(TW)7. 《水占卜 II》手稿", -- 41114
				location = "大法师哈利斯特（尘泥沼泽 - 塞拉摩，中央塔楼）",
				level = 45,
				rewards = {
					[1] = {
						name = "传送典籍：塞拉摩", -- 92001
						id = 92001,
						subtext = "物品",
						icon = "INV_Misc_Book_07",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "玛诺洛克恶魔印记", -- 40407
			},
		},
		[2] = {
			[1] = {
				note = "你可以在山上的建筑物内找到被激怒的幽灵。进入吉尔尼斯城门后，沿着左边（东边）的山脉前进，经过一个装有风车的田地，你会找到通往海边的小路，几乎到达边缘时，向北转弯，沿着（几乎看不见的）小路前进。",
				followup = "无后续",
				attain = 35,
				aim = "在吉尔尼斯城内击败萨瑟兰法官"..YELLOW.."[3]"..WHITE.."，并将其头颅交给吉尔尼斯的格莱摩尔农场的被激怒的幽灵。",
				title = "(TW)1. 审判与幻影", -- 40975
				location = "在吉尔尼斯城内击败萨瑟兰法官"..YELLOW.."[3]"..WHITE.."，并将其头颅交给吉尔尼斯的格莱摩尔农场的被激怒的幽灵。",
				level = 46,
				rewards = {
					[1] = {
						name = "格莱摩尔家族胸甲", -- 61620
						id = 61620,
						subtext = "胸部 锁甲",
						icon = "INV_Misc_MonsterSpiderCarapace_01",
						quality = 2,
					},
					[2] = {
						name = "吉尔尼斯仪式长矛", -- 61621
						id = 61621,
						subtext = "双手，长柄武器",
						icon = "INV_Spear_06",
						quality = 2,
					},
					[3] = {
						name = "格莱摩尔披肩", -- 61622
						id = 61622,
						subtext = "背部",
						icon = "INV_Chest_Cloth_15",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "前置任务为\'黑水农场的蝙蝠\'和\'黑水农场的狼人\'。\n达斯蒂万·布莱克考尔 "..YELLOW.."[4]"..WHITE.."会掉落埃布隆米尔契约。",
				followup = "无后续",
				attain = 35,
				aim = "击败达斯蒂万·布莱克考尔"..YELLOW.."[4]"..WHITE.."，并为约书亚·埃博米尔在吉尔尼斯的埃布隆米尔农场找回埃布隆米尔契约。",
				title = "(TW)2. 农场事务", -- 40979
				location = "约书亚·埃博米尔（吉尔尼斯 - 埃布隆米尔农场 "..YELLOW.."[49.5,31.1]"..WHITE.."）。进入吉尔尼斯城门后，沿着左边（东边）的山脉前进，在有风车的田地里你会找到约书亚·埃博米尔。",
				level = 45,
				rewards = {
					[1] = {
						name = "黑水劫掠者", -- 61627
						id = 61627,
						subtext = "单手，斧",
						icon = "INV_Axe_11",
						quality = 2,
					},
					[2] = {
						name = "约书亚之握", -- 61628
						id = 61628,
						subtext = "腰部 布甲",
						icon = "INV_Belt_12",
						quality = 2,
					},
					[3] = {
						name = "农夫猎枪", -- 61629
						id = 61629,
						subtext = "枪械",
						icon = "INV_Weapon_Rifle_TWoW_02_Purple",
						quality = 2,
					},
					[4] = {
						name = "(TW)2. 农场事务", -- 40979
						id = 61630,
						subtext = "手腕 板甲",
						icon = "INV_Bracer_17",
						quality = 2,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "前置任务为\'黑水农场的蝙蝠\'和\'黑水农场的狼人\'。\n达斯蒂万·布莱克考尔 "..YELLOW.."[4]"..WHITE.."会掉落埃布隆米尔契约。",
			},
			[3] = {
				note = "画作位于建筑物内的"..YELLOW.."[b]"..WHITE.."，向左走，在墙上（西北角）上。",
				followup = "无后续",
				attain = 40,
				aim = "从吉尔尼斯城的图书馆偷取画作，并将其归还给吉尔尼斯-黑色荆棘营地的卢克·阿加曼德。",
				title = "(TW)3. 皇家抢劫案", -- 41113
				location = "卢克·阿加曼德（吉尔尼斯 - 黑色荆棘营地 "..YELLOW.."[14.1,33.7]"..WHITE..", 营地位于西北角的海岸。）",
				level = 45,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[4] = {
				note = RED.."任务链目前存在问题，无法获得第三个任务\'最后的活死人\'."..WHITE.."\n任务链从死亡猎手阿琳娜（吉尔尼斯 - 斯蒂尔沃德教堂 "..YELLOW.."[57.3,39.6]"..WHITE.."，内部）那里开始，接受任务\'死到天黑\'。\n《论血液的力量》书放在摄政夫人西莉亚·哈鲁恩和摄政王莫蒂默·哈鲁恩旁边的桌子上，哈鲁恩家族宝箱旁边"..YELLOW.."[7]"..WHITE.."。\n完成下一个任务后，你将获得奖励。",
				followup = "只有战士才能接到这个任务！\n你可以从鲁古格"..YELLOW.."[1]"..WHITE.."得到燃素。\n\n湿地的蜘蛛掉落烧焦的蜘蛛牙，石爪山脉的奇美幼崽拉掉落烧焦的奇美拉角、雌奇美拉掉落光滑的奇美拉角。",
				attain = 35,
				aim = "在吉尔尼斯城找到《论血液的力量》，然后将其归还给吉尔尼斯-格雷希尔遗址的奥万·黑眼。",
				title = "(TW)4. 邪恶让我这样做", -- 40881
				location = "在吉尔尼斯城找到《论血液的力量》，然后将其归还给吉尔尼斯-格雷希尔遗址的奥万·黑眼。",
				level = 46,
				rewards = {
					[1] = {
						name = "纯血吊坠", -- 61422
						id = 61422,
						subtext = "颈部",
						icon = "INV_Jewelry_Amulet_05",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "死到天黑 -> 我们所需要的只是血 -> 最后的活死人 -> 我们从生活中获取它", -- 40877, 40878, 40879, 40880
			},
			[5] = {
				note = "需要完成两个任务链才能开始这个任务，\'向卢克·阿加曼报告。\'和\'向利维亚·斯特朗阿姆报告\'，在黑刺那里接受。\n",
				followup = "无后续",
				attain = 40,
				aim = "进入吉尔尼斯城，击败吉恩·格雷迈恩"..YELLOW.."[8]"..WHITE.."，然后将他的头颅带给吉尔尼斯-黑色荆棘营地的黑刺。",
				title = "(TW)5. 吉恩·格雷迈恩必须死！", -- 40849
				location = "黑刺（吉尔尼斯 - 黑色荆棘营地 "..YELLOW.."[14.1,33.7]"..WHITE.."，营地位于西北角的海岸。）",
				level = 49,
				rewards = {
					[1] = {
						name = "黑松护手", -- 61353
						id = 61353,
						subtext = "手部 皮甲",
						icon = "INV_Gauntlets_15",
						quality = 3,
					},
					[2] = {
						name = "女妖之泪", -- 61354
						id = 61354,
						subtext = "戒指",
						icon = "INV_Jewelry_Ring_27",
						quality = 3,
					},
					[3] = {
						name = "影袭腰带", -- 61355
						id = 61355,
						subtext = "腰部 锁甲",
						icon = "INV_Belt_26",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "向卢克·阿加曼报告。-> 干岩矿抢劫案 ->> 向利维亚·斯特朗阿姆报告 -> 与渗透者会合 ->> 与布莱克索恩共度美好时光" -- 40844, 40845, 40846, 40847, 40848, 
			},
			[6] = {
				note = "任务链从黑暗主教莫德伦那里的任务\'借助强大魔法\' 开始。\n午夜碎片位于最后的吉恩·格雷迈恩"..YELLOW.."[8]"..WHITE.."后面。\n完成下一个任务后，你将获得奖励。",
				followup = "格雷迈恩之石 "..YELLOW.."[吉尔尼斯城]"..WHITE.."-> 黑暗主教的礼物", -- 40996, 40997
				attain = 38,
				aim = "为斯蒂尔沃德教堂的黑暗主教莫德伦找回午夜碎片。",
				title = "格雷迈恩之石 "..YELLOW.."[吉尔尼斯城]"..WHITE.."-> 黑暗主教的礼物", -- 40996, 40997
				location = "进入剃刀高地，击败寒冰之王亚门纳尔 "..YELLOW.."[6]"..WHITE.."，并为吉尔尼斯的斯蒂尔沃德教堂的黑暗主教莫德伦取回他的魂灵之瓮。",
				level = 47,
				rewards = {
					[1] = {
						name = "加拉隆之力", -- 61660
						id = 61660,
						subtext = "双手 剑",
						icon = "INV_Sword_13",
						quality = 3,
					},
					[2] = {
						name = "瓦里玛萨斯之诡", -- 61661
						id = 61661,
						subtext = "双手 法杖",
						icon = "INV_Staff_13",
						quality = 3,
					},
					[3] = {
						name = "静寂护符", -- 61662
						id = 61662,
						subtext = "颈部",
						icon = "INV_Jewelry_Talisman_12",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "借助强大魔法 -> 鸦木权杖 -> 超越的力量 "..YELLOW.."[剃刀高地]"..WHITE..".", -- 40993, 40994, 40995
			},
		},
	},
	[45] = {
		name = "卡拉赞下层大厅",
		story = "",
		[1] = {
			[1] = {
				note = "你可以在"..YELLOW.."[卡拉赞 - b]"..WHITE.."的箱子里找到舒适的枕头。",
				followup = "一杯助眠饮品", -- 41084
				attain = 55,
				aim = "为卡拉赞的议员凯尔森找一张舒适的枕头。",
				title = "(TW)1. 合适的住宿", -- 41083
				location = "为卡拉赞的议员凯尔森找一张舒适的枕头。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "将任务交给"..YELLOW.."[卡拉赞 - d]"..WHITE.."的厨师。",
				followup = "幽灵酒", -- 41085
				attain = 55,
				aim = "与可能知道如何为议员凯尔森提供酒的人交谈。",
				title = "一杯助眠饮品", -- 41084
				location = "为卡拉赞的议员凯尔森找一张舒适的枕头。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)1. 合适的住宿", -- 41083
			},
			[3] = {
				note = "波尔多酒可以在酒类商人处购买。所有物品都可以在拍卖行购买。",
				followup = "与可能知道如何为议员凯尔森提供酒的人交谈。",
				attain = 55,
				aim = "为卡拉赞的厨师收集3个死灵精华、5瓶波尔多酒和1个幽灵菇。",
				title = "幽灵酒", -- 41085
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "一杯助眠饮品", -- 41084
			},
			[4] = {
				note = "",
				followup = "无后续",
				attain = 55,
				aim = "将幽灵酒交给卡拉赞的议员凯尔森"..YELLOW.."[卡拉赞 - c]"..WHITE.."。",
				title = "与可能知道如何为议员凯尔森提供酒的人交谈。",
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "幽灵酒", -- 41085
			},
			[5] = {
				note = "",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "聆听首领埃伯洛克的故事。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "",
				followup = "卡拉赞的钥匙 III", -- 40819
				attain = 58,
				aim = "击败莫罗斯"..YELLOW.."[6]"..WHITE.."并夺回卡拉赞上层房间的钥匙。莫罗斯位于卡拉赞下层大厅。将钥匙带回给首领埃伯洛克。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
			[7] = {
				note = "将任务交给大法师安斯雷姆·鲁因维沃尔 <肯瑞托>（奥特兰克山脉 - 达拉然 "..YELLOW.."[18.9,78.5]"..WHITE.."）。",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "找到一位可能了解瓦多尔的肯瑞托成员。达拉然可能是你开始搜索的好地方。",
				title = "卡拉赞的钥匙 III", -- 40819
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
			[8] = {
				note = "将任务交给公爵罗斯伦"..YELLOW.."[卡拉赞 - f]"..WHITE.."，他位于爪王嚎牙"..YELLOW.."[4]"..WHITE.."旁的阳台上。",
				followup = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
				attain = 55,
				aim = "找到一位可能了解\'被撕碎的烹饪笔记\'的人。",
				title = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
				location = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "你可以在"..YELLOW.."[卡拉赞 - a]"..WHITE.."的箱子中找到\'雕花金镯子\'。",
				followup = "(TW)19. 唤醒灰烬使者。", -- 20002
				attain = 55,
				aim = "在卡拉赞为公爵罗斯伦找回刻有字的金质手镯。",
				title = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
			},
			[10] = {
				note = "罗斯伦家族胸针位于"..YELLOW.."[斯坦索姆]"..WHITE.."的首领“不可饶恕者”"..YELLOW.."[4]"..WHITE.."旁的箱子中。",
				followup = "灰烬使者的灵魂",
				attain = 55,
				aim = "找到一位可能了解瓦多尔的肯瑞托成员。达拉然可能是你开始搜索的好地方。",
				title = "(TW)19. 唤醒灰烬使者。", -- 20002
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
			},
			[11] = {
				note = "",
				followup = "卡拉赞门卫", -- 41002
				attain = 55,
				aim = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				title = "灰烬使者的灵魂",
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)19. 唤醒灰烬使者。", -- 20002
			},
			[12] = {
				note = "看门人蒙蒂格"..BLUE.."[A]"..WHITE.."位于副本入口处，在楼梯前面。",
				followup = "卡拉赞之怒", -- 41003
				attain = 55,
				aim = "与卡拉赞中的看门人蒙蒂格交谈。",
				title = "卡拉赞门卫", -- 41002
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "灰烬使者的灵魂",
			},
			[13] = {
				note = "所有物品都可以在拍卖行购买。生命精华每个10-15银币，亡灵精华每个1-3金币。",
				followup = "巧克力鱼", -- 41004
				attain = 55,
				aim = "将10个亡灵精华、10个生命精华和25金币交给卡拉赞中的看门人蒙蒂格。",
				title = "卡拉赞之怒", -- 41003
				location = "与卡拉赞中的看门人蒙蒂格交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "卡拉赞门卫", -- 41002
			},
			[14] = {
				note = "",
				followup = "",
				attain = 55,
				aim = "将卡拉赞之怒交给卡拉赞中的“厨师” "..YELLOW.."[卡拉赞 - d]"..WHITE.." 在卡拉赞。",
				title = "巧克力鱼", -- 41004
				location = "与卡拉赞中的看门人蒙蒂格交谈。",
				level = 60,
				rewards = {
					[1] = {
						name = "配方：巧克力鱼", -- 61666
						id = 61666,
						subtext = "图样",
						icon = "INV_Scroll_04",
						quality = 4,
					},
					[2] = {
						name = "巧克力鱼", -- 41004
						id = 84040,
						subtext = "物品",
						icon = "INV_Misc_Fishe_Au_Chocolate",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "卡拉赞之怒", -- 41003
			},
			[15] = {
				note = "任务线从传奇物品“艾露恩之镰”开始，该物品从布莱克沃尔德勋爵二世"..YELLOW.."[5]"..WHITE.."（几率较低）掉落。",
				followup = "Scythe of the Goddess",
				attain = 60,
				aim = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				title = "Scythe of the Goddess",
				location = "月神镰刀",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "将任务交给基特斯，位于暮色森林的乌鸦岭"..YELLOW.."[18.4,56.4]"..WHITE.."。",
				followup = "Scythe of the Goddess",
				attain = 60,
				aim = "在暮色森林找到一个可能更了解月神镰刀的人。",
				title = "Scythe of the Goddess",
				location = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "Scythe of the Goddess",
			},
			[17] = {
				note = "15个奥术精华 - 随机垃圾掉落；\n20个幻象之尘 - 附魔师或拍卖行；\n10个强效不灭精华 - 附魔师或拍卖行；\n完成此任务后，你将能够获得头部/腿部附魔的任务。每个任务都需要：\n1个过载的魔网能量 - 卡拉赞的垃圾/首领随机稀有物品掉落；\n6个奥术精华 - 随机垃圾掉落。",
				followup = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
				attain = 55,
				aim = "收集15个奥术精华、20个幻象之尘和10个强效不灭精华，交给卡拉赞外的圣职者涅修斯。",
				title = "(TW)17. 为教会奉献", -- 41078
				location = "圣职者涅修斯（逆风小径，卡拉赞旁边的教堂"..YELLOW.."[40.3,77.2]"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92005,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					[2] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92006,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					[3] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92007,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					[4] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92008,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "你可以在"..YELLOW.."[卡拉赞 - b]"..WHITE.."的箱子里找到舒适的枕头。",
				followup = "一杯助眠饮品", -- 41084
				attain = 55,
				aim = "为卡拉赞的议员凯尔森找一张舒适的枕头。",
				title = "(TW)1. 合适的住宿", -- 41083
				location = "为卡拉赞的议员凯尔森找一张舒适的枕头。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "将任务交给"..YELLOW.."[卡拉赞 - d]"..WHITE.."的厨师。",
				followup = "光谱酒", -- 41085
				attain = 55,
				aim = "与可能知道如何为议员凯尔森提供酒的人交谈。",
				title = "一杯助眠饮品", -- 41084
				location = "为卡拉赞的议员凯尔森找一张舒适的枕头。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)1. 合适的住宿", -- 41083
			},
			[3] = {
				note = "波尔多酒可以在酒类商人处购买。所有物品都可以在拍卖行购买。",
				followup = "与可能知道如何为议员凯尔森提供酒的人交谈。",
				attain = 55,
				aim = "为卡拉赞的厨师收集3个死灵精华、5瓶波尔多酒和1个幽灵菇。",
				title = "光谱酒", -- 41085
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "一杯助眠饮品", -- 41084
			},
			[4] = {
				note = "",
				followup = "无后续",
				attain = 55,
				aim = "将幽灵酒交给卡拉赞的议员凯尔森"..YELLOW.."[卡拉赞 - c]"..WHITE.."。",
				title = "与可能知道如何为议员凯尔森提供酒的人交谈。",
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "光谱酒", -- 41085
			},
			[5] = {
				note = "",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "聆听首领埃伯洛克的故事。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[6] = {
				note = "",
				followup = "卡拉赞的钥匙 III", -- 40819
				attain = 58,
				aim = "击败莫罗斯"..YELLOW.."[6]"..WHITE.."并夺回卡拉赞上层房间的钥匙。莫罗斯位于卡拉赞下层大厅。将钥匙带回给首领埃伯洛克。",
				title = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				location = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
			[7] = {
				note = "将任务交给比索·埃斯沙德（幽暗城 - 魔法区"..YELLOW.."[84.1,17.5]"..WHITE.."，法师训练师区域）",
				followup = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
				attain = 58,
				aim = "寻找肯瑞托的成员，他们可能对范多尔有所了解。幽暗城可能是你开始搜索的好地方。",
				title = "卡拉赞的钥匙 III", -- 40819
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)20. 卡拉赞的钥匙 VIII", -- 40827
			},
			[8] = {
				note = "将任务交给公爵罗斯伦"..YELLOW.."[卡拉赞 - f]"..WHITE.."，他位于爪王嚎牙"..YELLOW.."[4]"..WHITE.."旁的阳台上。",
				followup = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
				attain = 55,
				aim = "找到一位可能了解\'被撕碎的烹饪笔记\'的人。",
				title = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
				location = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[9] = {
				note = "你可以在"..YELLOW.."[卡拉赞 - a]"..WHITE.."的箱子中找到\'雕花金镯子\'。",
				followup = "(TW)19. 唤醒灰烬使者。", -- 20002
				attain = 55,
				aim = "在卡拉赞为公爵罗斯伦找回刻有字的金质手镯。",
				title = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "灰烬使者的战袍从大十字军达斯·托尔哈 "..YELLOW.."[11]"..WHITE.." 掉落，亚历山德罗斯的披风从巴隆·瓦杜尔 "..YELLOW.."[19]"..WHITE.." 掉落。\n任务线在纳克萨玛斯中，在完成任务\'纯净之光之球\'后击败4个骑士开始。",
			},
			[10] = {
				note = "罗斯伦家族胸针位于"..YELLOW.."[斯坦索姆]"..WHITE.."的首领“不可饶恕者”"..YELLOW.."[4]"..WHITE.."旁的箱子中。",
				followup = "灰烬使者的灵魂",
				attain = 55,
				aim = "找到一位可能了解瓦多尔的肯瑞托成员。达拉然可能是你开始搜索的好地方。",
				title = "(TW)19. 唤醒灰烬使者。", -- 20002
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "纯净之光之球 -> 寻求他处的帮助", --20000,20001
			},
			[11] = {
				note = "",
				followup = "卡拉赞门卫", -- 41002
				attain = 55,
				aim = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				title = "灰烬使者的灵魂",
				location = "夺回灰烬使者的战袍（击败大十字军达斯·托尔哈）和亚历山德罗斯的披风（从斯坦索姆获得）。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "(TW)19. 唤醒灰烬使者。", -- 20002
			},
			[12] = {
				note = "看门人蒙蒂格"..BLUE.."[A]"..WHITE.."位于副本入口处，在楼梯前面。",
				followup = "卡拉赞之怒", -- 41003
				attain = 55,
				aim = "与卡拉赞中的看门人蒙蒂格交谈。",
				title = "卡拉赞门卫", -- 41002
				location = "与卡拉赞中的“厨师”"..YELLOW.."[卡拉赞 - d]"..WHITE.."交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "灰烬使者的灵魂",
			},
			[13] = {
				note = "所有物品都可以在拍卖行购买。生命精华每个10-15银币，亡灵精华每个1-3金币。",
				followup = "巧克力鱼", -- 41004
				attain = 55,
				aim = "将10个亡灵精华、10个生命精华和25金币交给卡拉赞中的看门人蒙蒂格。",
				title = "卡拉赞之怒", -- 41003
				location = "与卡拉赞中的看门人蒙蒂格交谈。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "卡拉赞门卫", -- 41002
			},
			[14] = {
				note = "",
				followup = "",
				attain = 55,
				aim = "将卡拉赞之怒交给卡拉赞中的“厨师” "..YELLOW.."[卡拉赞 - d]"..WHITE.." 在卡拉赞。",
				title = "巧克力鱼", -- 41004
				location = "与卡拉赞中的看门人蒙蒂格交谈。",
				level = 60,
				rewards = {
					[1] = {
						name = "配方：巧克力鱼", -- 61666
						id = 61666,
						subtext = "图样",
						icon = "INV_Scroll_04",
						quality = 4,
					},
					[2] = {
						name = "巧克力鱼", -- 41004
						id = 84040,
						subtext = "物品",
						icon = "INV_Misc_Fishe_Au_Chocolate",
						quality = 1,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "卡拉赞之怒", -- 41003
			},
			[15] = {
				note = "任务线从传奇物品“艾露恩之镰”开始，该物品从布莱克沃尔德勋爵二世"..YELLOW.."[5]"..WHITE.."（几率较低）掉落。",
				followup = "Scythe of the Goddess",
				attain = 60,
				aim = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				title = "Scythe of the Goddess",
				location = "月神镰刀",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "无前置",
			},
			[16] = {
				note = "将任务交给基特斯，位于暮色森林的乌鸦岭"..YELLOW.."[18.4,56.4]"..WHITE.."。",
				followup = "Scythe of the Goddess",
				attain = 60,
				aim = "在暮色森林找到一个可能更了解月神镰刀的人。",
				title = "Scythe of the Goddess",
				location = "击败爪王嚎牙"..YELLOW.."[4]"..WHITE.."并向首领埃伯洛克"..YELLOW.."[卡拉赞 - d]"..WHITE.."汇报。",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "Scythe of the Goddess",
			},
			[17] = {
				note = "15个奥术精华 - 随机垃圾掉落；\n20个幻象之尘 - 附魔师或拍卖行；\n10个强效不灭精华 - 附魔师或拍卖行；\n完成此任务后，你将能够获得头部/腿部附魔的任务。每个任务都需要：\n1个过载的魔网能量 - 卡拉赞的垃圾/首领随机稀有物品掉落；\n6个奥术精华 - 随机垃圾掉落。",
				followup = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
				attain = 55,
				aim = "收集15个奥术精华、20个幻象之尘和10个强效不灭精华，交给卡拉赞外的圣职者涅修斯。",
				title = "(TW)17. 为教会奉献", -- 41078
				location = "圣职者涅修斯（逆风小径，卡拉赞旁边的教堂"..YELLOW.."[40.3,77.2]"..WHITE.."）。",
				level = 60,
				rewards = {
					[1] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92005,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					[2] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92006,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					[3] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92007,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					[4] = {
						name = "碎裂符咒，强效保护符咒，开阔思想符咒，强效奥术护盾符咒",
						id = 92008,
						subtext = AQITEM_ENCHANT,
						icon = "Ability_Creature_Cursed_01",
						quality = 3,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3"..AQDiscription_OR.."4",
				},
				prequest = "无前置",
			},
		},
	},
	[46] = {
		name = "在环绕着"..YELLOW.."[6]"..WHITE.."的圈内，秘法洪流的元素生物会掉落过载的奥术过载棱镜。完成这个任务线后，你将获得项链，并能够进入海加尔山的团队副本翡翠圣殿。",
		story = "翡翠圣殿是位于海加尔山的副本团队副本。一股腐败之雾笼罩着翡翠梦境，扭曲了即使是最高贵纯洁的道德和意识。被腐化的唤醒者正准备发出更多的唤醒信号；如果不加阻止，他的同类将在艾泽拉斯上肆意横行。",
		[1] = {
			[1] = {
				note = "",
				followup = "无后续",
				attain = 58,
				aim = "将索尔纽斯的头颅带给海加尔山-诺达纳尔的拉拉修斯",
				title = "(TW)1. 索尔纽斯的首级", -- 40963
				location = "索尔纽斯 <唤醒者> 掉落索尔尼斯的头颅",
				level = 60,
				rewards = {
					[1] = {
						name = "诺达希尔之戒", -- 61195
						id = 61195,
						subtext = "戒指",
						icon = "BTNWoodenRingUPG1",
						quality = 4,
					},
					[2] = {
						name = "梦之心", -- 61194
						id = 61194,
						subtext = "饰品",
						icon = "BTNOrbOfDepths",
						quality = 4,
					},
					[3] = {
						name = "翠绿之眼项链", -- 61193
						id = 61193,
						subtext = "颈部",
						icon = "BTNEnchantedNecklace",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "完成后将获得奖励的后续任务。",
				followup = "净化梦境精华", -- 40906
				attain = 55,
				aim = "将阴燃梦境精华带给海加尔山-诺达纳尔的大德鲁伊梦风",
				title = "(TW)2. 焚梦精华", -- 40905
				location = "阴燃梦境精华掉落自索尔尼斯 <唤醒者>",
				level = 60,
				rewards = {
					[1] = {
						name = "净化翡翠精华", -- 61445
						id = 61445,
						subtext = "物品",
						icon = "INV_Enchant_EssenceNetherLarge",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
		[2] = {
			[1] = {
				note = "",
				followup = "无后续",
				attain = 58,
				aim = "将索尔纽斯的头颅带给海加尔山-诺达纳尔的拉拉修斯",
				title = "(TW)1. 索尔纽斯的首级", -- 40963
				location = "索尔纽斯 <唤醒者> 掉落索尔尼斯的头颅",
				level = 60,
				rewards = {
					[1] = {
						name = "诺达希尔之戒", -- 61195
						id = 61195,
						subtext = "戒指",
						icon = "BTNWoodenRingUPG1",
						quality = 4,
					},
					[2] = {
						name = "梦之心", -- 61194
						id = 61194,
						subtext = "饰品",
						icon = "BTNOrbOfDepths",
						quality = 4,
					},
					[3] = {
						name = "翠绿之眼项链", -- 61193
						id = 61193,
						subtext = "颈部",
						icon = "BTNEnchantedNecklace",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1"..AQDiscription_OR.."2"..AQDiscription_OR.."3",
				},
				prequest = "无前置",
			},
			[2] = {
				note = "完成后将获得奖励的后续任务。",
				followup = "净化梦境精华", -- 40906
				attain = 55,
				aim = "将阴燃梦境精华带给海加尔山-诺达纳尔的大德鲁伊梦风",
				title = "(TW)2. 焚梦精华", -- 40905
				location = "阴燃梦境精华掉落自索尔尼斯 <唤醒者>",
				level = 60,
				rewards = {
					[1] = {
						name = "净化翡翠精华", -- 61445
						id = 61445,
						subtext = "物品",
						icon = "INV_Enchant_EssenceNetherLarge",
						quality = 4,
					},
					text = AQDiscription_REWARD..WHITE.."1",
				},
				prequest = "无前置",
			},
		},
	},
	[47] = {
		name = "奥兹塔里亚斯",
		story = "",
		[1] = {
			[1] = {
				note = "任务线从资深探险家麦格拉斯 <探险者协会>（铁炉堡 - 探险者大厅；"..YELLOW.."[69.9,18.5]"..WHITE.."）的任务“不寻常的合作”开始。",
				followup = "无后续",
				attain = 58,
				aim = "击败奥兹塔里亚斯。返回探险者大厅并告知资深探险家麦格拉斯关于在大门发生的事件。",
				title = "(TW)1. 门卫", -- 40107
				location = "奥丹姆基座（塔纳利斯 - 奥丹姆 "..YELLOW.."[37.6,81.4]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "不寻常的伙伴关系 -> 原来的主人 -> 什么潜伏在黑暗中？ -> 比赛 -> 失踪的探险队 -> 矮人的骄傲 -> 奥丹姆之门", -- 40100, 40101, 40102, 40103, 40104, 40105, 40106
			},
		},
		[2] = {
			[1] = {
				note = "任务线从圣者图希克（雷霆崖 "..YELLOW.."[34.5,47.2]"..WHITE.."）的任务“孤独的狼”开始，在拍卖师旁边的桥梁建筑中进行。",
				followup = "无后续",
				attain = 58,
				aim = "击败奥兹塔里亚斯。返回雷霆崖并告知圣者图希克关于在大门发生的事件。",
				title = "(TW)1. 大门守护者", -- 40115
				location = "奥丹姆基座（塔纳利斯 - 奥丹姆 "..YELLOW.."[37.6,81.4]"..WHITE.."）",
				level = 60,
				rewards = {
					text = ""..BLUE.." 没有奖励物品",
				},
				prequest = "孤独的狼 -> 过去的SCARMS -> 看不见的敌人 -> 在匆忙中-> 令人不安的沉默 -> 部落的力量 -> 奥丹姆在等着", -- 40108, 40109, 40110, 40111, 40112, 40113, 40114
			},
		},
	},
}
