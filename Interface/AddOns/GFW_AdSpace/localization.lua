------------------------------------------------------
-- localization.lua
-- English strings by default, localizations override with their own.
------------------------------------------------------

FAS_Localized = {};		-- this line doesn't need localization, it just lets us use FAS_Localized below.

	SOLD_FOR_PRICE_BY = "出售价格:%s 出自";					-- prefix to vendor info when price is shown
	SOLD_BY = "[出售者]";									-- prefix to vendor info when no price is shown
	RETURN_TO = "交给";								-- prefix to info for librams
	ARCANUM_FORMAT = "奖励: %s 附魔";				-- bonus info for librams
	VENDOR_LOCATION_FORMAT = "%s, %s";						-- format for showing vendor name and location
	FAS_FACTION_REWARDS = "%s 奖励:";
	FAS_FACTION_REWARDS_COUNT = "%d %s 奖励";
	FAS_TURNIN = "交声望";
	FAS_WITH = "还要求";
	
-- notes for other items
	DARKMOON = "暗月马戏团换取奖券";
	
-- notes for vendors with special availability
	SEASONAL_VENDOR = "(季节性的供应商)";
	SCHOLO_QUEST = "要求鬼灵精华";

-- non-nil note so vendors in instances are highlighted in a different color
-- but no actual note text because it'd be cheesy to give too much away...	
	BRD_BARKEEP = "";
	DM_LIBRARY = "";
	
-- non-nil note for faction recipes so it gets a different color
-- no actual note because it's part of the base tooltip now.
	REQ_FACTION = "";
	
-- notes for items only available once you have a certain reputation standing
	THORIUM_FRIENDLY = "要求瑟银兄弟会 - "..FACTION_STANDING_LABEL5;
	THORIUM_HONORED = "要求瑟银兄弟会 - "..FACTION_STANDING_LABEL6;
	THORIUM_REVERED = "要求瑟银兄弟会 - "..FACTION_STANDING_LABEL7;
	THORIUM_EXALTED = "要求瑟银兄弟会 - "..FACTION_STANDING_LABEL8;

	TIMBERMAW_FRIENDLY = "要求木喉熊怪 - "..FACTION_STANDING_LABEL5;

-- Faction names
	AD_FACTION = "银色黎明";
	ZG_FACTION = "赞达拉部族";
	AQ20_FACTION = "塞纳里奥议会";
	AQ40_FACTION = "诺兹多姆的子嗣";
	
-- localized class names
	PALADIN = "圣骑士";
	SHAMAN = "萨满祭司";
	MAGE = "法师";
	PRIEST = "牧师";
	WARLOCK = "术士";
	WARRIOR = "战士";
	HUNTER = "猎人";
	ROGUE = "盗贼";
	DRUID = "德鲁伊";

-- localized weapon types
	STAFF = "法杖";
	MACE = "锤";
	AXE = "斧";
	GUN = "枪";
	DAGGER = "匕首";
	SHIELD = "盾牌";
	SWORD = "剑";

FAS_OPTIONS = "AdSpace 设置";
FAS_OPTIONS_GENERAL = "在物品上添加提示信息:";
FAS_OPTION_RECIPES = "从NPC供应商处可获得的配方";
FAS_OPTION_RECIPE_COST = "显示供应商配方价格";
FAS_OPTION_LIBRAM = "圣契 (NPC和奖励信息)";
FAS_OPTION_DARKMOON = "暗月马戏团灰色物品奖励";
FAS_OPTION_AD = "黎明之印项目提交";

FAS_OPTIONS_RAID = "特殊团队拾取:";
FAS_OPTION_ZG = "祖尔格拉布";
FAS_OPTION_ZG_FACTION = "(赞达拉部族奖励)";
FAS_OPTION_ZG_PRENAXX = "(1.11版本任务要求)";
FAS_OPTION_AQ20 = "安其拉废墟";
FAS_OPTION_AQ20_FACTION = "(AQ20塞纳里奥议会奖励)";
FAS_OPTION_AQ40 = "安其拉";
FAS_OPTION_AQ40_FACTION = "(AQ40诺兹多姆的子嗣奖励)";
FAS_OPTION_POST_RAID = "发送到团队聊天,当通过 '/ads [link]' 得到的信息时";

-- localized zone names (only those that differ from the enUS version should be present)
	FAS_Localized["Alterac Mountains"] = "奥特兰克山脉";
	FAS_Localized["Arathi Highlands"] = "阿拉希高地";
	FAS_Localized["Ashenvale"] = "灰谷";
	FAS_Localized["Azshara"] = "艾萨拉";
	FAS_Localized["Badlands"] = "荒芜之地";
	FAS_Localized["Blackrock Depths"] = "黑石深渊";
	FAS_Localized["Blasted Lands"] = "诅咒之地";
	FAS_Localized["Burning Steppes"] = "燃烧平原";
	FAS_Localized["Darkshore"] = "黑海岸";
	FAS_Localized["Darnassus"] = "达纳苏斯";
	FAS_Localized["Desolace"] = "凄凉之地";
	FAS_Localized["Dire Maul"] = "厄运之槌";
	FAS_Localized["Dun Morogh"] = "丹莫罗";
	FAS_Localized["Durotar"] = "杜隆塔尔";
	FAS_Localized["Duskwood"] = "暮色森林";
	FAS_Localized["Eastern Plaguelands"] = "东瘟疫之地";
	FAS_Localized["Elwynn Forest"] = "艾尔文森林";
	FAS_Localized["Felwood"] = "费伍德森林";
	FAS_Localized["Feralas"] = "菲拉斯";
	FAS_Localized["Gnomeregan"] = "诺莫瑞根";
	FAS_Localized["Hillsbrad Foothills"] = "希尔斯布莱德丘陵";
	FAS_Localized["Ironforge"] = "铁炉堡";
	FAS_Localized["Loch Modan"] = "洛克莫丹";
	FAS_Localized["Moonglade"] = "月光林地";
	FAS_Localized["Mulgore"] = "莫高雷";
	FAS_Localized["Orgrimmar"] = "奥格瑞玛";
	FAS_Localized["Redridge Mountains"] = "赤脊山";
	FAS_Localized["Silithus"] = "希利苏斯";
	FAS_Localized["Silverpine Forest"] = "银松森林";
	FAS_Localized["Stonetalon Mountains"] = "石爪山脉";
	FAS_Localized["Stormwind City"] = "暴风城";
	FAS_Localized["Stranglethorn Vale"] = "荆棘谷";
	FAS_Localized["Swamp of Sorrows"] = "悲伤沼泽";
	FAS_Localized["Tanaris"] = "塔纳利斯";
	FAS_Localized["Teldrassil"] = "泰达希尔";
	FAS_Localized["The Barrens"] = "贫瘠之地";
	FAS_Localized["The Hinterlands"] = "辛特兰";
	FAS_Localized["Thousand Needles"] = "千针石林";
	FAS_Localized["Thunder Bluff"] = "雷霆崖";
	FAS_Localized["Tirisfal Glades"] = "提瑞斯法林地";
	FAS_Localized["Un'Goro Crater"] = "安戈洛环形山";
	FAS_Localized["Undercity"] = "幽暗城";
	FAS_Localized["Wailing Caverns"] = "哀嚎洞穴";
	FAS_Localized["Western Plaguelands"] = "西瘟疫之地";
	FAS_Localized["Westfall"] = "西部荒野";
	FAS_Localized["Wetlands"] = "湿地";

-- localized NPC names (only those that differ from the enUS version should be present)
	FAS_Localized["Abigail Shiel"] = "阿比盖尔·沙伊尔";
	FAS_Localized["Alchemist Pestlezugg"] = "炼金师匹斯特苏格";
	FAS_Localized["Alexandra Bolero"] = "亚历山德拉·波利罗";
	FAS_Localized["Algernon"] = "奥格诺恩";
	FAS_Localized["Amy Davenport"] = "艾米·达文波特";
	FAS_Localized["Andrew Hilbert"] = "安德鲁·希尔伯特";
	FAS_Localized["Androd Fadran"] = "安多德·法德兰";
	FAS_Localized["Argent Quartermaster Hasana"] = "银色黎明军需官哈萨娜";
	FAS_Localized["Argent Quartermaster Lightspark"] = "银色黎明军需官莱斯巴克";
	FAS_Localized["Balai Lok'Wein"] = "巴莱·洛克维";
	FAS_Localized["Bale"] = "拜尔";
	FAS_Localized["Banalash"] = "巴纳拉什";
	FAS_Localized["Blimo Gadgetspring"] = "布里莫";
	FAS_Localized["Blixrez Goodstitch"] = "布里克雷兹·古斯提";
	FAS_Localized["Bliztik"] = "布里兹提克";
	FAS_Localized["Bombus Finespindle"] = "伯布斯·钢轴";
	FAS_Localized["Borya"] = "博亚";
	FAS_Localized["Brienna Starglow"] = "布琳娜·星光";
	FAS_Localized["Bro'kin"] = "布洛金";
	FAS_Localized["Bronk"] = "布隆克";
	FAS_Localized["Catherine Leland"] = "凯瑟琳·利兰";
	FAS_Localized["Christoph Jeffcoat"] = "克里斯托弗·杰弗寇特";
	FAS_Localized["Clyde Ranthal"] = "克莱德·兰萨尔";
	FAS_Localized["Constance Brisboise"] = "康斯坦茨·布里斯博埃斯";
	FAS_Localized["Corporal Bluth"] = "布鲁斯下士";
	FAS_Localized["Cowardly Crosby"] = "怯懦的克罗斯比";
	FAS_Localized["Crazk Sparks"] = "克拉赛·斯巴克斯";
	FAS_Localized["Dalria"] = "达利亚";
	FAS_Localized["Daniel Bartlett"] = "丹尼尔·巴特莱特";
	FAS_Localized["Danielle Zipstitch"] = "丹尼勒·希普斯迪";
	FAS_Localized["Darian Singh"] = "达利安·辛格";
	FAS_Localized["Darnall"] = "旅店老板达纳尔";
	FAS_Localized["Defias Profiteer"] = "迪菲亚奸商";
	FAS_Localized["Deneb Walker"] = "德尼布·沃克";
	FAS_Localized["Derak Nightfall"] = "德拉克·奈特弗";
	FAS_Localized["Dirge Quikcleave"] = "迪尔格·奎克里弗";
	FAS_Localized["Drac Roughcut"] = "德拉克·卷刃";
	FAS_Localized["Drake Lindgren"] = "德拉克·林格雷";
	FAS_Localized["Drovnar Strongbrew"] = "德鲁纳·烈酒";
	FAS_Localized["Dustwallow Marsh"] = "尘泥沼泽";
	FAS_Localized["Elynna"] = "艾琳娜";
	FAS_Localized["Evie Whirlbrew"] = "埃文·维布鲁";
	FAS_Localized["Fradd Swiftgear"] = "弗拉德";
	FAS_Localized["Gagsprocket"] = "加格斯普吉特";
	FAS_Localized["Gearcutter Cogspinner"] = "考格斯宾";
	FAS_Localized["George Candarte"] = "乔治·坎达特";
	FAS_Localized["Gharash"] = "卡尔拉什";
	FAS_Localized["Ghok'kah"] = "格鲁克卡恩";
	FAS_Localized["Gigget Zipcoil"] = "吉盖特·火油";
	FAS_Localized["Gikkix"] = "吉科希斯";
	FAS_Localized["Gina MacGregor"] = "吉娜·马克葛瑞格";
	FAS_Localized["Glyx Brewright"] = "格里克斯·布鲁维特";
	FAS_Localized["Gnaz Blunderflame"] = "格纳兹·枪焰";
	FAS_Localized["Gretta Ganter"] = "格雷塔·甘特";
	FAS_Localized["Grimtak"] = "格瑞姆塔克";
	FAS_Localized["Hagrus"] = "哈格鲁斯";
	FAS_Localized["Hammon Karwn"] = "哈蒙·卡文";
	FAS_Localized["Harggan"] = "哈尔甘";
	FAS_Localized["Harklan Moongrove"] = "哈克兰·月林";
	FAS_Localized["Harlown Darkweave"] = "哈鲁恩·暗纹";
	FAS_Localized["Harn Longcast"] = "哈恩·长线";
	FAS_Localized["Heldan Galesong"] = "海尔丹·风歌";
	FAS_Localized["Helenia Olden"] = "海伦妮亚·奥德恩";
	FAS_Localized["Himmik"] = "西米克";
	FAS_Localized["Hula'mahi"] = "哈拉玛";
	FAS_Localized["Jabbey"] = "加贝";
	FAS_Localized["Jandia"] = "詹迪亚";
	FAS_Localized["Janet Hommers"] = "詹奈特·霍莫斯";
	FAS_Localized["Jangdor Swiftstrider"] = "杉多尔·迅蹄";
	FAS_Localized["Jannos Ironwill"] = "加诺斯·铁心";
	FAS_Localized["Jaquilina Dramet"] = "加奎琳娜·德拉米特";
	FAS_Localized["Jase Farlane"] = "贾斯·法拉恩";
	FAS_Localized["Jazzrik"] = "加兹里克";
	FAS_Localized["Jeeda"] = "基达";
	FAS_Localized["Jennabink Powerseam"] = "吉娜比克·铁线";
	FAS_Localized["Jessara Cordell"] = "杰萨拉·考迪尔";
	FAS_Localized["Jinky Twizzlefixxit"] = "金克·铁钩";
	FAS_Localized["Joseph Moore"] = "约瑟夫·摩尔";
	FAS_Localized["Jubie Gadgetspring"] = "朱比";
	FAS_Localized["Jun'ha"] = "祖恩哈";
	FAS_Localized["Jutak"] = "祖塔克";
	FAS_Localized["Kaita Deepforge"] = "凯塔·深炉";
	FAS_Localized["Kalldan Felmoon"] = "卡尔丹·暗月";
	FAS_Localized["Keena"] = "基纳";
	FAS_Localized["Kelsey Yance"] = "凯尔希·杨斯";
	FAS_Localized["Kendor Kabonka"] = "肯多尔·卡邦卡";
	FAS_Localized["Khara Deepwater"] = "卡拉·深水";
	FAS_Localized["Kiknikle"] = "吉克尼库";
	FAS_Localized["Killian Sanatha"] = "基利恩·萨纳森";
	FAS_Localized["Kilxx"] = "基尔克斯";
	FAS_Localized["Kireena"] = "基瑞娜";
	FAS_Localized["Kithas"] = "基萨斯";
	FAS_Localized["Knaz Blunderflame"] = "克纳兹·枪焰";
	FAS_Localized["Kor'geld"] = "考吉尔德";
	FAS_Localized["Kriggon Talsone"] = "克雷贡·塔尔松";
	FAS_Localized["Krinkle Goodsteel"] = "克林科·古德斯迪尔";
	FAS_Localized["Kulwia"] = "库尔维亚";
	FAS_Localized["Kzixx"] = "卡兹克斯";
	FAS_Localized["Laird"] = "莱尔德";
	FAS_Localized["Lardan"] = "拉尔丹";
	FAS_Localized["Leo Sarn"] = "雷欧·萨恩";
	FAS_Localized["Leonard Porter"] = "莱纳德·波特";
	FAS_Localized["Lilly"] = "莉蕾";
	FAS_Localized["Lindea Rabonne"] = "林迪·拉波尼";
	FAS_Localized["Lizbeth Cromwell"] = "莉兹白·克伦威尔";
	FAS_Localized["Logannas"] = "洛加纳斯";
	FAS_Localized["Lokhtos Darkbargainer"] = "罗克图斯·暗契";
	FAS_Localized["Lorekeeper Lydros"] = "博学者莱德罗斯";
	FAS_Localized["Lorelae Wintersong"] = "罗莱尔·冬歌";
	FAS_Localized["Magnus Frostwake"] = "玛格努斯·霜鸣";
	FAS_Localized["Mahu"] = "曼胡";
	FAS_Localized["Mallen Swain"] = "玛林·斯万";
	FAS_Localized["Malygen"] = "玛里甘";
	FAS_Localized["Maria Lumere"] = "玛丽亚·卢米尔";
	FAS_Localized["Martine Tramblay"] = "马丁·塔布雷";
	FAS_Localized["Masat T'andr"] = "马萨特·坦德";
	FAS_Localized["Mathredis Firestar"] = "玛瑟迪斯·火芒";
	FAS_Localized["Mavralyn"] = "马弗拉林";
	FAS_Localized["Mazk Snipeshot"] = "玛兹克·斯奈普沙特";
	FAS_Localized["Meilosh"] = "梅罗什";
	FAS_Localized["Micha Yance"] = "米沙·杨斯";
	FAS_Localized["Millie Gregorian"] = "米利尔·格里高利";
	FAS_Localized["Montarr"] = "莫塔尔";
	FAS_Localized["Muuran"] = "穆尔兰";
	FAS_Localized["Mythrin'dir"] = "迈斯林迪尔";
	FAS_Localized["Naal Mistrunner"] = "纳尔·迷雾行者";
	FAS_Localized["Namdo Bizzfizzle"] = "纳姆杜";
	FAS_Localized["Nandar Branson"] = "南达·布拉森";
	FAS_Localized["Narj Deepslice"] = "纳尔基·长刀";
	FAS_Localized["Narkk"] = "纳尔克";
	FAS_Localized["Nata Dawnstrider"] = "纳塔·黎明行者";
	FAS_Localized["Nergal"] = "奈尔加";
	FAS_Localized["Nerrist"] = "耐里斯特";
	FAS_Localized["Nessa Shadowsong"] = "尼莎·影歌";
	FAS_Localized["Nina Lightbrew"] = "妮娜·莱特布鲁";
	FAS_Localized["Nioma"] = "尼奥玛";
	FAS_Localized["Nyoma"] = "奈欧玛";
	FAS_Localized["Ogg'marr"] = "奥克玛尔";
	FAS_Localized["Old Man Heming"] = "老人海明威";
	FAS_Localized["Outfitter Eric"] = "埃瑞克";
	FAS_Localized["Plugger Spazzring"] = "普拉格";
	FAS_Localized["Pratt McGrubben"] = "普拉特·马克格鲁比";
	FAS_Localized["Qia"] = "琦亚";
	FAS_Localized["Quartermaster Miranda Breechlock"] = "军需官米兰达·布利洛克";
	FAS_Localized["Ranik"] = "拉尼克";
	FAS_Localized["Rann Flamespinner"] = "拉恩·火翼";
	FAS_Localized["Rartar"] = "拉尔塔";
	FAS_Localized["Rikqiz"] = "雷克奇兹";
	FAS_Localized["Rin'wosho the Trader"] = "商人林沃斯";
	FAS_Localized["Rizz Loosebolt"] = "里兹·飞矢";
	FAS_Localized["Ronald Burch"] = "罗纳德·伯奇";
	FAS_Localized["Ruppo Zipcoil"] = "鲁普·火油";
	FAS_Localized["Saenorion"] = "塞诺里奥";
	FAS_Localized["Sewa Mistrunner"] = "苏瓦·迷雾行者";
	FAS_Localized["Shandrina"] = "珊蒂瑞亚";
	FAS_Localized["Shankys"] = "山吉斯";
	FAS_Localized["Sheendra Tallgrass"] = "希恩德拉·深草";
	FAS_Localized["Shen'dralar Provisioner"] = "辛德拉圣职者";
	FAS_Localized["Sheri Zipstitch"] = "舍瑞·希普斯迪";
	FAS_Localized["Soolie Berryfizz"] = "苏雷·浆泡";
	FAS_Localized["Sovik"] = "索维克";
	FAS_Localized["Stuart Fleming"] = "斯图亚特·弗雷明";
	FAS_Localized["Sumi"] = "苏米";
	FAS_Localized["Kania"] = "卡妮亚";
	FAS_Localized["Super-Seller 680"] = "超级商人680型";
	FAS_Localized["Tamar"] = "达玛尔";
	FAS_Localized["Tansy Puddlefizz"] = "坦斯·泥泡";
	FAS_Localized["Tari'qa"] = "塔里查";
	FAS_Localized["Thaddeus Webb"] = "萨德乌斯·韦伯";
	FAS_Localized["Tharynn Bouden"] = "萨瑞恩·博丁";
	FAS_Localized["Tilli Thistlefuzz"] = "提尔利·草须";
	FAS_Localized["Truk Wildbeard"] = "特鲁克·蛮鬃";
	FAS_Localized["Tunkk"] = "吞克";
	FAS_Localized["Ulthaan"] = "尤萨恩";
	FAS_Localized["Ulthir"] = "尤希尔";
	FAS_Localized["Uthok"] = "尤索克";
	FAS_Localized["Vaean"] = "维安";
	FAS_Localized["Valdaron"] = "瓦尔达隆";
	FAS_Localized["Veenix"] = "维尼克斯";
	FAS_Localized["Vendor-Tron 1000"] = "贸易机器人1000型";
	FAS_Localized["Vharr"] = "维哈尔";
	FAS_Localized["Vivianna"] = "薇薇安娜";
	FAS_Localized["Vizzklick"] = "维兹格里克";
	FAS_Localized["Wenna Silkbeard"] = "温纳·银须";
	FAS_Localized["Werg Thickblade"] = "维尔格·厚刃";
	FAS_Localized["Wik'Tar"] = "维克塔";
	FAS_Localized["Winterspring"] = "冬泉谷";
	FAS_Localized["Worb Strongstitch"] = "沃尔布";
	FAS_Localized["Wrahk"] = "瓦尔克";
	FAS_Localized["Wulan"] = "乌兰";
	FAS_Localized["Wunna Darkmane"] = "温纳·黑鬃";
	FAS_Localized["Xandar Goodbeard"] = "山达·细须";
	FAS_Localized["Xizk Goodstitch"] = "希兹克·古斯提";
	FAS_Localized["Xizzer Fizzbolt"] = "希兹尔·菲兹波特";
	FAS_Localized["Yonada"] = "犹纳达";
	FAS_Localized["Yuka Screwspigot"] = "尤卡·斯库比格特";
	FAS_Localized["Zan Shivsproket"] = "萨恩·刀链";
	FAS_Localized["Zannok Hidepiercer"] = "扎诺克";
	FAS_Localized["Zansoa"] = "詹苏尔";
	FAS_Localized["Zarena Cromwind"] = "萨瑞娜·克罗姆温德";
	FAS_Localized["Zargh"] = "扎尔夫";
	FAS_Localized["Zixil"] = "吉克希尔";

-- localized libram descriptions
	FAS_Localized["+8 any single stat"] = "+8 任何单一属性";
	FAS_Localized["+100 Health"] = "+100 生命值";
	FAS_Localized["+150 Mana"] = "+150 法力值";
	FAS_Localized["+20 Fire Resistance"] = "+20 火焰抗性";
	FAS_Localized["+125 Armor"] = "+125 护甲";
	FAS_Localized["+1% Haste"] = "+1% 加速";
	FAS_Localized["+1% Dodge"] = "+1% 躲闪";
	FAS_Localized["+8 Spell damage/healing"] = "+8 法术伤害和治疗";

-- localized special raid loot tokens
	FAS_Localized["Zulian Coin"]		=	"祖利安硬币";
	FAS_Localized["Razzashi Coin"]		=	"拉扎什硬币";
	FAS_Localized["Hakkari Coin"]		=	"哈卡莱硬币";
	FAS_Localized["Gurubashi Coin"]		=	"古拉巴什硬币";
	FAS_Localized["Vilebranch Coin"]	=	"邪枝硬币";
	FAS_Localized["Witherbark Coin"]	=	"枯木硬币";
	FAS_Localized["Sandfury Coin"]		=	"沙怒硬币";
	FAS_Localized["Skullsplitter Coin"]	=	"碎颅硬币";
	FAS_Localized["Bloodscalp Coin"]	=	"血顶硬币";
            
	FAS_Localized["Red Hakkari Bijou"]		=	"红色哈卡莱宝石";
	FAS_Localized["Blue Hakkari Bijou"]		=	"蓝色哈卡莱宝石";
	FAS_Localized["Yellow Hakkari Bijou"]	=	"黄色哈卡莱宝石";
	FAS_Localized["Orange Hakkari Bijou"]	=	"橙色哈卡莱宝石";
	FAS_Localized["Green Hakkari Bijou"]	=	"绿色哈卡莱宝石";
	FAS_Localized["Purple Hakkari Bijou"]	=	"紫色哈卡莱宝石";
	FAS_Localized["Bronze Hakkari Bijou"]	=	"青铜哈卡莱宝石";
	FAS_Localized["Silver Hakkari Bijou"]	=	"银色哈卡莱宝石";
	FAS_Localized["Gold Hakkari Bijou"]		=	"金色哈卡莱宝石";
            
	FAS_Localized["Primal Hakkari Bindings"]	=	"原始哈卡莱护腕";
	FAS_Localized["Primal Hakkari Armsplint"]	=	"原始哈卡莱护臂";
	FAS_Localized["Primal Hakkari Stanchion"]	=	"原始哈卡莱直柱";
	FAS_Localized["Primal Hakkari Girdle"]		=	"原始哈卡莱束带";
	FAS_Localized["Primal Hakkari Sash"]		=	"原始哈卡莱腰带";
	FAS_Localized["Primal Hakkari Shawl"]		=	"原始哈卡莱披肩";
	FAS_Localized["Primal Hakkari Tabard"]		=	"原始哈卡莱徽章";
	FAS_Localized["Primal Hakkari Kossack"]		=	"原始哈卡莱套索";
	FAS_Localized["Primal Hakkari Aegis"]		=	"原始哈卡莱之盾";
            
	FAS_Localized["Qiraji Magisterial Ring"]	=	"其拉将领戒指";
	FAS_Localized["Qiraji Ceremonial Ring"]		=	"其拉典礼戒指";
	FAS_Localized["Qiraji Martial Drape"]		=	"其拉军用披风";
	FAS_Localized["Qiraji Regal Drape"]			=	"其拉帝王披风";
	FAS_Localized["Qiraji Spiked Hilt"]			=	"其拉尖刺刀柄";
	FAS_Localized["Qiraji Ornate Hilt"]			=	"其拉装饰刀柄";
            
	FAS_Localized["Imperial Qiraji Armaments"]	=	"其拉帝王武器";
	FAS_Localized["Imperial Qiraji Regalia"]	=	"其拉帝王徽记";
            
	FAS_Localized["Qiraji Bindings of Command"]		=	"其拉命令腕轮";
    FAS_Localized["Qiraji Bindings of Dominance"]	=	"其拉统御腕轮";
	FAS_Localized["Ouro's Intact Hide"]				=	"奥罗的外皮";
	FAS_Localized["Skin of the Great Sandworm"]		=	"巨型沙虫的皮";
	FAS_Localized["Vek'lor's Diadem"]				=	"维克洛尔的王冠";
	FAS_Localized["Vek'nilash's Circlet"]			=	"维克尼拉斯的头饰";
	FAS_Localized["Carapace of the Old God"]		=	"上古之神的甲壳";
	FAS_Localized["Husk of the Old God"]			=	"上古之神的外鞘";
            
	FAS_Localized["Stone Scarab"]	=	"岩石甲虫";
	FAS_Localized["Gold Scarab"]	=	"黄金甲虫";
	FAS_Localized["Silver Scarab"]	=	"银质甲虫";
	FAS_Localized["Bronze Scarab"]	=	"青铜甲虫";
	FAS_Localized["Crystal Scarab"]	=	"水晶甲虫";
	FAS_Localized["Clay Scarab"]	=	"陶土甲虫";
	FAS_Localized["Bone Scarab"]	=	"白骨甲虫";
	FAS_Localized["Ivory Scarab"]	=	"象牙甲虫";
            
	FAS_Localized["Azure Idol"]			=	"碧蓝雕像";
	FAS_Localized["Onyx Idol"]			=	"玛瑙雕像";
	FAS_Localized["Lambent Idol"]		=	"柔光雕像";
	FAS_Localized["Amber Idol"]			=	"琥珀雕像";
	FAS_Localized["Jasper Idol"]		=	"翠玉雕像";
	FAS_Localized["Obsidian Idol"]		=	"黑曜石雕像";
	FAS_Localized["Vermillion Idol"]	=	"朱红雕像";
	FAS_Localized["Alabaster Idol"]		=	"雪白雕像";
            
	FAS_Localized["Idol of the Sun"]	=	"太阳塑像";
	FAS_Localized["Idol of Night"]		=	"夜晚塑像";
	FAS_Localized["Idol of Death"]		=	"死亡塑像";
	FAS_Localized["Idol of the Sage"]	=	"先知塑像";
	FAS_Localized["Idol of Rebirth"]	=	"复生塑像";
	FAS_Localized["Idol of Life"]		=	"生命塑像";
	FAS_Localized["Idol of Strife"]		=	"征战塑像";
	FAS_Localized["Idol of War"]		=	"战争塑像";

if ( GetLocale() == "deDE" ) then

	SOLD_FOR_PRICE_BY = "Verkauft um %s von";					-- prefix to vendor info when price is shown
	SOLD_BY = "Verkauft von";									-- prefix to vendor info when no price is shown
	RETURN_TO = "Zurückkehren zu";								-- prefix to info for librams
	ARCANUM_FORMAT = "Belohnung: %s Verzauberung";				-- bonus info for librams
	VENDOR_LOCATION_FORMAT = "%s, %s";						-- format for showing vendor name and location
	
-- notes for other items
	DARKMOON = "Zum Dunkelmond-Jahrmarkt bringen und Belohnungen abholen!";
	
-- notes for vendors with special availability
	SEASONAL_VENDOR = "(Saisonaler Verkäufer)";
	SCHOLO_QUEST = "Benötigt Spektrale Essenz";
	
-- notes for items only available once you have a certain reputation standing
	THORIUM_FRIENDLY = "Benötigt Thorium-Bruderschaft - "..FACTION_STANDING_LABEL5;
	THORIUM_HONORED = "Benötigt Thorium-Bruderschaft - "..FACTION_STANDING_LABEL6;
	THORIUM_REVERED = "Benötigt Thorium-Bruderschaft - "..FACTION_STANDING_LABEL7;
	THORIUM_EXALTED = "Benötigt Thorium-Bruderschaft - "..FACTION_STANDING_LABEL8;

	TIMBERMAW_FRIENDLY = "Benötigt Die Holzschlundfeste - "..FACTION_STANDING_LABEL5;

-- localized zone names (only those that differ from the enUS version should be present)
	FAS_Localized["Alterac Mountains"] = "Das Alteracgebirge";
	FAS_Localized["Arathi Highlands"] = "Das Arathihochland";
	FAS_Localized["Badlands"] = "Das Ödland";
	FAS_Localized["Blackrock Depths"] = "Blackrocktiefen";
	FAS_Localized["Blasted Lands"] = "Die verwüsteten Lande";
	FAS_Localized["Burning Steppes"] = "Die brennende Steppe";
	FAS_Localized["Dustwallow Marsh"] = "Die Marschen von Dustwallow";
	FAS_Localized["Eastern Plaguelands"] = "Die östlichen Pestländer";
	FAS_Localized["Elwynn Forest"] = "Der Wald von Elwynn";
	FAS_Localized["Hillsbrad Foothills"] = "Die Vorgebirge von Hillsbrad";
	FAS_Localized["Redridge Mountains"] = "Das Redridgegebirge";
	FAS_Localized["Silverpine Forest"] = "Der Silberwald";
	FAS_Localized["Stonetalon Mountains"] = "Das Steinkrallengebirge";
	FAS_Localized["Stormwind City"] = "Stormwind";
	FAS_Localized["Stranglethorn Vale"] = "Stranglethorn";
	FAS_Localized["Swamp of Sorrows"] = "Die Sümpfe des Elends";
	FAS_Localized["The Barrens"] = "Das Brachland";
	FAS_Localized["The Hinterlands"] = "Das Hinterland";
	FAS_Localized["Tirisfal Glades"] = "Tirisfal";
	FAS_Localized["Un'Goro Crater"] = "Der Un'Goro Krater";
	FAS_Localized["Wailing Caverns"] = "Die Höhlen des Wehklagens";
	FAS_Localized["Western Plaguelands"] = "Die westlichen Pestländer";
	FAS_Localized["Wetlands"] = "Das Sumpfland";
	
-- localized NPC names (only those that differ from the enUS version should be present)
	FAS_Localized["Alchemist Pestlezugg"] = "Alchimist Pestlezugg";
	FAS_Localized["Argent Quartermaster Hasana"] = "Argentum-Rüstmeister Hasana";
	FAS_Localized["Argent Quartermaster Lightspark"] = "Argentum-Rüstmeister Lightspark";
	FAS_Localized["Defias Profiteer"] = "Defias-Schieber";
	FAS_Localized["Lorekeeper Lydros"] = "Wissenswächter Lydros";
	FAS_Localized["Outfitter Eric"] = "Ausstatter Eric";
	FAS_Localized["Quartermaster Miranda Breechlock"] = "Rüstmeisterin Miranda Breechlock";
	FAS_Localized["Rin'wosho the Trader"] = "Rin'wosho der Händler";

-- localized libram descriptions 
	FAS_Localized["+1% Dodge"] = "+1% Ausweichen";
	FAS_Localized["+1% Haste"] = "+1% Angriffsgeschwindigkeit";
	FAS_Localized["+100 Health"] = "+100 Gesundheit";
	FAS_Localized["+125 Armor"] = "+125 Rüstung";
	FAS_Localized["+20 Fire Resistance"] = "+20 火焰抗性";
	FAS_Localized["+8 Spell damage/healing"] = "+8 Zauberschaden/Heilung";
	FAS_Localized["+8 any single stat"] = "+8 alle Werte";

-- localized special raid loot tokens
	FAS_Localized["Zulian Coin"]		=	"Zulianische Münze";
	FAS_Localized["Razzashi Coin"]		=	"Münze der Razzashi";
	FAS_Localized["Hakkari Coin"]		=	"Münze der Hakkari";
	FAS_Localized["Gurubashi Coin"]		=	"Münze der Gurubashi";
	FAS_Localized["Vilebranch Coin"]	=	"Münze der Vilebranch";
	FAS_Localized["Witherbark Coin"]	=	"Münze der Witherbark";
	FAS_Localized["Sandfury Coin"]		=	"Münze der Sandfury";
	FAS_Localized["Skullsplitter Coin"]	=	"Münze der Skullsplitter";
	FAS_Localized["Bloodscalp Coin"]	=	"Münze der Bloodscalp";
            
	FAS_Localized["Red Hakkari Bijou"]		=	"Rotes Schmuckstück der Hakkari";
	FAS_Localized["Blue Hakkari Bijou"]		=	"Blaues Schmuckstück der Hakkari";
	FAS_Localized["Yellow Hakkari Bijou"]	=	"Gelbes Schmuckstück der Hakkari";
	FAS_Localized["Orange Hakkari Bijou"]	=	"Orangefarbenes Schmuckstück der Hakkari";
	FAS_Localized["Green Hakkari Bijou"]	=	"Grünes Schmuckstück der Hakkari";
	FAS_Localized["Purple Hakkari Bijou"]	=	"Lilanes Schmuckstück der Hakkari";
	FAS_Localized["Bronze Hakkari Bijou"]	=	"Bronzefarbenes Schmuckstück der Hakkari";
	FAS_Localized["Silver Hakkari Bijou"]	=	"Silbernes Schmuckstück der Hakkari";
	FAS_Localized["Gold Hakkari Bijou"]		=	"Goldenes Schmuckstück der Hakkari";
            
	FAS_Localized["Primal Hakkari Bindings"]	=	"Urzeitliche Hakkaribindungen";
	FAS_Localized["Primal Hakkari Armsplint"]	=	"Urzeitliche Hakkariarmsplinte";
	FAS_Localized["Primal Hakkari Stanchion"]	=	"Urzeitliche Hakkaristütze";
	FAS_Localized["Primal Hakkari Girdle"]		=	"Urzeitlicher Hakkarigurt";
	FAS_Localized["Primal Hakkari Sash"]		=	"Urzeitliche Hakkarischärpe";
	FAS_Localized["Primal Hakkari Shawl"]		=	"Urzeitlicher Hakkarischal";
	FAS_Localized["Primal Hakkari Tabard"]		=	"Urzeitlicher Hakkariwappenrock";
	FAS_Localized["Primal Hakkari Kossack"]		=	"Urzeitlicher Hakkarikosak";
	FAS_Localized["Primal Hakkari Aegis"]		=	"Urzeitliche Aegis der Hakkari";
            
	FAS_Localized["Qiraji Magisterial Ring"]	=	"Gebieterring der Qiraji";
	FAS_Localized["Qiraji Ceremonial Ring"]		=	"Zeremonienring der Qiraji";
	FAS_Localized["Qiraji Martial Drape"]		=	"Kampftuch der Qiraji";
	FAS_Localized["Qiraji Regal Drape"]			=	"Hoheitstuch der Qiraji";
	FAS_Localized["Qiraji Spiked Hilt"]			=	"Stachelgriff der Qiraji";
	FAS_Localized["Qiraji Ornate Hilt"]			=	"Verschnörkelter Griff der Qiraji";
            
	FAS_Localized["Imperial Qiraji Armaments"]	=	"Imperiale Qirajiwaffe";
	FAS_Localized["Imperial Qiraji Regalia"]	=	"Imperiale Qirajiinsignie";
            
	FAS_Localized["Qiraji Bindings of Command"]		=	"Befehlsbindungen der Qiraji";
	FAS_Localized["Qiraji Bindings of Dominance"]	=	"Dominanzbindungen der Qiraji";
	FAS_Localized["Ouro's Intact Hide"]				=	"Ouros intakte Haut";
	FAS_Localized["Skin of the Great Sandworm"]		=	"Haut des großen Sandwurms";
	FAS_Localized["Vek'lor's Diadem"]				=	"Vek'lors Diadem";
	FAS_Localized["Vek'nilash's Circlet"]			=	"Vek'nilashs Reif";
	FAS_Localized["Carapace of the Old God"]		=	"Knochenpanzer des alten Gottes";
	FAS_Localized["Husk of the Old God"]			=	"Hülle des alten Gottes";
            
	FAS_Localized["Stone Scarab"]	=	"Steinskarabäus";
	FAS_Localized["Gold Scarab"]	=	"Goldskarabäus";
	FAS_Localized["Silver Scarab"]	=	"Silberskarabäus";
	FAS_Localized["Bronze Scarab"]	=	"Bronzeskarabäus";
	FAS_Localized["Crystal Scarab"]	=	"Kristallskarabäus";
	FAS_Localized["Clay Scarab"]	=	"Tonskarabäus";
	FAS_Localized["Bone Scarab"]	=	"Knochenskarabäus";
	FAS_Localized["Ivory Scarab"]	=	"Elfenbeinskarabäus";
            
	FAS_Localized["Azure Idol"]			=	"Azurgötze";
	FAS_Localized["Onyx Idol"]			=	"Onyxgötze";
	FAS_Localized["Lambent Idol"]		=	"Züngelnder Götze";
	FAS_Localized["Amber Idol"]			=	"Bernsteingötze";
	FAS_Localized["Jasper Idol"]		=	"Jaspisgötze";
	FAS_Localized["Obsidian Idol"]		=	"Obsidiangötze";
	FAS_Localized["Vermillion Idol"]	=	"Zinnobergötze";
	FAS_Localized["Alabaster Idol"]		=	"Alabastergötze";
            
	FAS_Localized["Idol of the Sun"]	=	"Götze der Sonne";
	FAS_Localized["Idol of Night"]		=	"Götze der Nacht";
	FAS_Localized["Idol of Death"]		=	"Götze des Todes";
	FAS_Localized["Idol of the Sage"]	=	"Götze der Weisen";
	FAS_Localized["Idol of Rebirth"]	=	"Götze der Wiedergeburt";
	FAS_Localized["Idol of Life"]		=	"Götze des Lebens";
	FAS_Localized["Idol of Strife"]		=	"Götze des Kampfes";
	FAS_Localized["Idol of War"]		=	"Götze des Krieges";

end


if ( GetLocale() == "koKR" ) then

	SOLD_FOR_PRICE_BY = "상점가격 %s 판매:";					-- prefix to vendor info when price is shown
	SOLD_BY = "[판매]";									-- prefix to vendor info when no price is shown
	RETURN_TO = "보상 NPC: ";								-- prefix to info for librams
	ARCANUM_FORMAT = "최종보상: %s - 마법부여 가능";				-- bonus info for librams
	VENDOR_LOCATION_FORMAT = "%s (%s)";						-- format for showing vendor name and location
	
-- notes for other items
	DARKMOON = "다크문상품권 교환용";
	
-- notes for vendors with special availability
	SEASONAL_VENDOR = "(계절 임시상인)";
	SCHOLO_QUEST = "카엘다로우 영원정수 착용 필요";
	
-- notes for items only available once you have a certain reputation standing
	THORIUM_FRIENDLY = "토륨대장조합 평판필요 - "..FACTION_STANDING_LABEL5;
	THORIUM_HONORED = "토륨대장조합 평판필요 - "..FACTION_STANDING_LABEL6;
	THORIUM_REVERED = "토륨대장조합 평판필요 - "..FACTION_STANDING_LABEL7;
	THORIUM_EXALTED = "토륨대장조합 평판필요 - "..FACTION_STANDING_LABEL8;

	TIMBERMAW_FRIENDLY = "나무구렁펄볼그 평판필요 - "..FACTION_STANDING_LABEL5;

-- localized zone names (only those that differ from the enUS version should be present)
	FAS_Localized["Alterac Mountains"] = "알터랙 산맥";
	FAS_Localized["Arathi Highlands"] = "아라시 고원";
	FAS_Localized["Ashenvale"] = "잿빛 골짜기";
	FAS_Localized["Azshara"] = "아즈샤라";
	FAS_Localized["Badlands"] = "황야의 땅";
	FAS_Localized["Blackrock Depths"] = "검은바위 나락";
	FAS_Localized["Blasted Lands"] = "저주받은 땅";
	FAS_Localized["Burning Steppes"] = "이글거리는 협곡";
	FAS_Localized["Darkshore"] = "어둠의 해안";
	FAS_Localized["Darnassus"] = "다르나서스";
	FAS_Localized["Desolace"] = "잊혀진 땅";
	FAS_Localized["Dire Maul"] = "혈투의 전장";
	FAS_Localized["Dun Morogh"] = "던 모로";
	FAS_Localized["Durotar"] = "듀로타";
	FAS_Localized["Duskwood"] = "그늘숲";
	FAS_Localized["Eastern Plaguelands"] = "동부 역병지대";
	FAS_Localized["Elwynn Forest"] = "엘윈숲";
	FAS_Localized["Felwood"] = "악령의 숲";
	FAS_Localized["Feralas"] = "페랄라스";
	FAS_Localized["Gnomeregan"] = "놈리건";
	FAS_Localized["Hillsbrad Foothills"] = "힐스브래드 구릉지";
	FAS_Localized["Ironforge"] = "아이언포지";
	FAS_Localized["Loch Modan"] = "모단 호수";
	FAS_Localized["Moonglade"] = "달의 숲";
	FAS_Localized["Mulgore"] = "멀고어";
	FAS_Localized["Orgrimmar"] = "오그리마";
	FAS_Localized["Redridge Mountains"] = "붉은마루 산맥";
	FAS_Localized["Silithus"] = "실리더스";
	FAS_Localized["Silverpine Forest"] = "은빛 소나무숲";
	FAS_Localized["Stonetalon Mountains"] = "돌발톱 산맥";
	FAS_Localized["Stormwind City"] = "스톰윈드";
	FAS_Localized["Stranglethorn Vale"] = "가시덤불 골짜기";
	FAS_Localized["Swamp of Sorrows"] = "슬픔의 늪";
	FAS_Localized["Tanaris"] = "타나리스";
	FAS_Localized["Teldrassil"] = "텔드랏실";
	FAS_Localized["The Barrens"] = "불모의 땅";
	FAS_Localized["The Hinterlands"] = "동부 내륙지";
	FAS_Localized["Thousand Needles"] = "버섯구름 봉우리";
	FAS_Localized["Thunder Bluff"] = "썬더 블러프";
	FAS_Localized["Tirisfal Glades"] = "티리스팔 숲";
	FAS_Localized["Un'Goro Crater"] = "운고로 분화구";
	FAS_Localized["Undercity"] = "언더시티";
	FAS_Localized["Wailing Caverns"] = "통곡의 동굴";
	FAS_Localized["Western Plaguelands"] = "서부 역병지대";
	FAS_Localized["Westfall"] = "서부 몰락지대";
	FAS_Localized["Wetlands"] = "저습지";

-- localized NPC names (only those that differ from the enUS version should be present)
	FAS_Localized["Abigail Shiel"] = "애비게일 시엘";
	FAS_Localized["Alchemist Pestlezugg"] = "연금술사 페슬저그";
	FAS_Localized["Alexandra Bolero"] = "알렉산드라 볼레로";
	FAS_Localized["Algernon"] = "알게르논";
	FAS_Localized["Amy Davenport"] = "트에이미 데이븐포";
	FAS_Localized["Andrew Hilbert"] = "앤드류 힐버트";
	FAS_Localized["Androd Fadran"] = "안드로드 패드랜";
	FAS_Localized["Argent Quartermaster Hasana"] = "은빛병참장교 하사나";
	FAS_Localized["Argent Quartermaster Lightspark"] = "은빛병참장교 라이트스파크";
	FAS_Localized["Balai Lok'Wein"] = "발라이 로크웨인";
	FAS_Localized["Bale"] = "베일";
	FAS_Localized["Banalash"] = "바나래쉬";
	FAS_Localized["Blimo Gadgetspring"] = "블리모 가젯스프링";
	FAS_Localized["Blixrez Goodstitch"] = "블릭스레즈 굿스티치";
	FAS_Localized["Bliztik"] = "블리즈틱";
	FAS_Localized["Bombus Finespindle"] = "봄부스 파인스핀들";
	FAS_Localized["Borya"] = "보르야";
	FAS_Localized["Brienna Starglow"] = "브리에나 스타글로";
	FAS_Localized["Bro'kin"] = "브로킨";
	FAS_Localized["Bronk"] = "브론크";
	FAS_Localized["Catherine Leland"] = "캐서린 릴랜드";
	FAS_Localized["Christoph Jeffcoat"] = "크리스토프 제프코트";
	FAS_Localized["Clyde Ranthal"] = "클라이드 랜덜";
	FAS_Localized["Constance Brisboise"] = "콘스턴스 브리스부아즈";
	FAS_Localized["Corporal Bluth"] = "하사관 블루스";
	FAS_Localized["Cowardly Crosby"] = "겁쟁이 크로스비";
	FAS_Localized["Crazk Sparks"] = "크라즈크 스팍스";
	FAS_Localized["Dalria"] = "달리아";
	FAS_Localized["Daniel Bartlett"] = "다니엘 바틀렛";
	FAS_Localized["Danielle Zipstitch"] = "다니엘 집스티치";
	FAS_Localized["Darian Singh"] = "다리안 싱그";
	FAS_Localized["Darnall"] = "다르날";
	FAS_Localized["Defias Profiteer"] = "데피아즈단 악덕업자";
	FAS_Localized["Deneb Walker"] = "데네브 워커";
	FAS_Localized["Derak Nightfall"] = "데락 나이트폴";
	FAS_Localized["Dirge Quikcleave"] = "더지 퀵클레이브";
	FAS_Localized["Drac Roughcut"] = "드락 러프컷";
	FAS_Localized["Drake Lindgren"] = "드레이크 린드그렌";
	FAS_Localized["Drovnar Strongbrew"] = "드로브나르 스트롱브루";
	FAS_Localized["Dustwallow Marsh"] = "먼지진흙 습지대";
	FAS_Localized["Elynna"] = "엘리나";
	FAS_Localized["Evie Whirlbrew"] = "에비 휠브루";
	FAS_Localized["Fradd Swiftgear"] = "프래드 스위프트기어";
	FAS_Localized["Gagsprocket"] = "객스프로켓";
	FAS_Localized["Gearcutter Cogspinner"] = "기어커터 코그스피너";
	FAS_Localized["George Candarte"] = "민간인 조지 칸다테";
	FAS_Localized["Gharash"] = "가라쉬";
	FAS_Localized["Ghok'kah"] = "그호카";
	FAS_Localized["Gigget Zipcoil"] = "기젯 집코일";
	FAS_Localized["Gikkix"] = "긱킥스";
	FAS_Localized["Gina MacGregor"] = "지나 맥그레거";
	FAS_Localized["Glyx Brewright"] = "글릭스 브루라이트";
	FAS_Localized["Gnaz Blunderflame"] = "그나즈 블런더플레임";
	FAS_Localized["Gretta Ganter"] = "그레타 간터";
	FAS_Localized["Grimtak"] = "그림탁";
	FAS_Localized["Hagrus"] = "하그루스";
	FAS_Localized["Hammon Karwn"] = "하몬 카른";
	FAS_Localized["Harggan"] = "하르간";
	FAS_Localized["Harklan Moongrove"] = "하클란 문그로브";
	FAS_Localized["Harlown Darkweave"] = "하론 다크위브";
	FAS_Localized["Harn Longcast"] = "한 롱캐스트 ";
	FAS_Localized["Heldan Galesong"] = "헬단 게일송";
	FAS_Localized["Helenia Olden"] = "헬레니아 올든";
	FAS_Localized["Himmik"] = "힘믹";
	FAS_Localized["Hula'mahi"] = "훌라마히";
	FAS_Localized["Jabbey"] = "재비";
	FAS_Localized["Jandia"] = "잔디아";
	FAS_Localized["Janet Hommers"] = "자넷 호머스";
	FAS_Localized["Jangdor Swiftstrider"] = "장도르 스위프트스트라이더";
	FAS_Localized["Jannos Ironwill"] = "야노스 아이언윌";
	FAS_Localized["Jaquilina Dramet"] = "자킬리나 드라메트";
	FAS_Localized["Jase Farlane"] = "제이스 파레인";
	FAS_Localized["Jazzrik"] = "자즈릭";
	FAS_Localized["Jeeda"] = "지다";
	FAS_Localized["Jennabink Powerseam"] = "제나빙크 파워심";
	FAS_Localized["Jessara Cordell"] = "예사라 코르델";
	FAS_Localized["Jinky Twizzlefixxit"] = "진키 트위즐픽시트";
	FAS_Localized["Joseph Moore"] = "조셉 무어";
	FAS_Localized["Jubie Gadgetspring"] = "주비 가젯스프링";
	FAS_Localized["Jun'ha"] = "준하";
	FAS_Localized["Jutak"] = "주타크";
	FAS_Localized["Kaita Deepforge"] = "카이타 딥포지";
	FAS_Localized["Kalldan Felmoon"] = "칼단 펠문";
	FAS_Localized["Keena"] = "키나";
	FAS_Localized["Kelsey Yance"] = "켈시 얀스";
	FAS_Localized["Kendor Kabonka"] = "켄로드 카본카";
	FAS_Localized["Khara Deepwater"] = "카라 딥워터";
	FAS_Localized["Kiknikle"] = "킥니클";
	FAS_Localized["Killian Sanatha"] = "킬리안 사나타";
	FAS_Localized["Kilxx"] = "킬륵스";
	FAS_Localized["Kireena"] = "키리나";
	FAS_Localized["Kithas"] = "키타스";
	FAS_Localized["Knaz Blunderflame"] = "크나즈 블런더플레임";
	FAS_Localized["Kor'geld"] = "코르겔드";
	FAS_Localized["Kriggon Talsone"] = "크리곤 달손";
	FAS_Localized["Krinkle Goodsteel"] = "크린클 굿스틸";
	FAS_Localized["Kulwia"] = "쿨위아";
	FAS_Localized["Kzixx"] = "크직스";
	FAS_Localized["Laird"] = "레어드";
	FAS_Localized["Lardan"] = "라르단";
	FAS_Localized["Leo Sarn"] = "레오 사른";
	FAS_Localized["Leonard Porter"] = "레오나드 포터";
	FAS_Localized["Lilly"] = "릴리";
	FAS_Localized["Lindea Rabonne"] = "린디아 라본느";
	FAS_Localized["Lizbeth Cromwell"] = "리즈베스 크롬웰";
	FAS_Localized["Logannas"] = "로간나스";
	FAS_Localized["Lokhtos Darkbargainer"] = "로크토스 아크바게이너";
	FAS_Localized["Lorekeeper Lydros"] = "현자 리드로스";
	FAS_Localized["Lorelae Wintersong"] = "로렐라이 윈터송";
	FAS_Localized["Magnus Frostwake"] = "마그누스 프로스트웨이크";
	FAS_Localized["Mahu"] = "마후";
	FAS_Localized["Mallen Swain"] = "말렌스웨인";
	FAS_Localized["Malygen"] = "말리젠";
	FAS_Localized["Maria Lumere"] = "마리아 루메르";
	FAS_Localized["Martine Tramblay"] = "마틴 트램블레이";
	FAS_Localized["Masat T'andr"] = "마사트 탄드르";
	FAS_Localized["Mathredis Firestar"] = "마스레디스 파이어스타";
	FAS_Localized["Mavralyn"] = "마브라린";
	FAS_Localized["Mazk Snipeshot"] = "마즈크 스나이프샷";
	FAS_Localized["Meilosh"] = "메일로쉬";
	FAS_Localized["Micha Yance"] = "미카 얀스";
	FAS_Localized["Millie Gregorian"] = "밀리 그레고리안";
	FAS_Localized["Montarr"] = "몬타르";
	FAS_Localized["Muuran"] = "무란";
	FAS_Localized["Mythrin'dir"] = "미스린디르";
	FAS_Localized["Naal Mistrunner"] = "나알 미스트러너";
	FAS_Localized["Namdo Bizzfizzle"] = "남도 비즈피즐";
	FAS_Localized["Nandar Branson"] = "난다르 브랜슨";
	FAS_Localized["Narj Deepslice"] = "나르 딥슬라이스";
	FAS_Localized["Narkk"] = "나르크";
	FAS_Localized["Nata Dawnstrider"] = "나타 던스트라이더";
	FAS_Localized["Nergal"] = "네르갈";
	FAS_Localized["Nerrist"] = "네리스트";
	FAS_Localized["Nessa Shadowsong"] = "네사 섀도송";
	FAS_Localized["Nina Lightbrew"] = "니나 라이트브루";
	FAS_Localized["Nioma"] = "니오마";
	FAS_Localized["Nyoma"] = "니오마";
	FAS_Localized["Ogg'marr"] = "오그마르";
	FAS_Localized["Old Man Heming"] = "노인 헤밍";
	FAS_Localized["Outfitter Eric"] = "제단사 에릭";
	FAS_Localized["Plugger Spazzring"] = "플러거 스파즈링";
	FAS_Localized["Pratt McGrubben"] = "프랫 맥그루벤";
	FAS_Localized["Qia"] = "퀴아";
	FAS_Localized["Quartermaster Miranda Breechlock"] = "병참장교 미란다 브리치락";
	FAS_Localized["Ranik"] = "래니크";
	FAS_Localized["Rann Flamespinner"] = "랜 플레임스피너";
	FAS_Localized["Rartar"] = "라르타르";
	FAS_Localized["Rikqiz"] = "릭키즈";
	FAS_Localized["Rin'wosho the Trader"] = "상인 린워쇼";
	FAS_Localized["Rizz Loosebolt"] = "리즈 루즈볼트";
	FAS_Localized["Ronald Burch"] = "로널드 버치";
	FAS_Localized["Ruppo Zipcoil"] = "루포 집코일";
	FAS_Localized["Saenorion"] = "새노리온";
	FAS_Localized["Sewa Mistrunner"] = "세와 미스트러너";
	FAS_Localized["Shandrina"] = "샨드리나";
	FAS_Localized["Shankys"] = "샨키스";
	FAS_Localized["Sheendra Tallgrass"] = "신드라 톨그래스";
	FAS_Localized["Shen'dralar Provisioner"] = "셴드랄라 고대인";
	FAS_Localized["Sheri Zipstitch"] = "셰리 집스티치";
	FAS_Localized["Soolie Berryfizz"] = "술리 배리피즈";
	FAS_Localized["Sovik"] = "소빅";
	FAS_Localized["Stuart Fleming"] = "스튜어트 플레밍";
	FAS_Localized["Sumi"] = "수미";
	FAS_Localized["Super-Seller 680"] = "슈퍼 판매기 680";
	FAS_Localized["Tamar"] = "타마르";
	FAS_Localized["Tansy Puddlefizz"] = "탄지 퍼들피즈";
	FAS_Localized["Tari'qa"] = "타리카";
	FAS_Localized["Thaddeus Webb"] = "타데우스 웨브";
	FAS_Localized["Tharynn Bouden"] = "타린 바우던";
	FAS_Localized["Tilli Thistlefuzz"] = "틸리 시슬퍼즈";
	FAS_Localized["Truk Wildbeard"] = "트루크 와일드바이드";
	FAS_Localized["Tunkk"] = "텅크";
	FAS_Localized["Ulthaan"] = "울샨";
	FAS_Localized["Ulthir"] = "울시르";
	FAS_Localized["Uthok"] = "우톡";
	FAS_Localized["Vaean"] = "바이안";
	FAS_Localized["Valdaron"] = "발다론";
	FAS_Localized["Veenix"] = "비닉스";
	FAS_Localized["Vendor-Tron 1000"] = "자동 판매기 1000";
	FAS_Localized["Vharr"] = "바르";
	FAS_Localized["Vivianna"] = "비비안나";
	FAS_Localized["Vizzklick"] = "비즈클릭";
	FAS_Localized["Wenna Silkbeard"] = "웨나 실크비어드";
	FAS_Localized["Werg Thickblade"] = "웨르그 틱블레이드";
	FAS_Localized["Wik'Tar"] = "위크타르";
	FAS_Localized["Winterspring"] = "여명의 설원";
	FAS_Localized["Worb Strongstitch"] = "워브 스트롱스티치";
	FAS_Localized["Wrahk"] = "레이크";
	FAS_Localized["Wulan"] = "울란";
	FAS_Localized["Wunna Darkmane"] = "우나 다크메인";
	FAS_Localized["Xandar Goodbeard"] = "샨다르 굿비어드";
	FAS_Localized["Xizk Goodstitch"] = "시즈크 굿스티치";
	FAS_Localized["Xizzer Fizzbolt"] = "시저 피즈볼트";
	FAS_Localized["Yonada"] = "요나다";
	FAS_Localized["Yuka Screwspigot"] = "유카 스크류스피곳";
	FAS_Localized["Zan Shivsproket"] = "잰 쉬브스프로켓";
	FAS_Localized["Zannok Hidepiercer"] = "잔노크 하이드피이서";
	FAS_Localized["Zansoa"] = "잔소아";
	FAS_Localized["Zarena Cromwind"] = "자레나 크롬윈드";
	FAS_Localized["Zargh"] = "자르그";
	FAS_Localized["Zixil"] = "직실";

-- localized libram descriptions
	FAS_Localized["+8 any single stat"] = "+8 원하는 스탯 한가지";
	FAS_Localized["+100 Health"] = "+100 생명력";
	FAS_Localized["+150 Mana"] = "+150 마나";
	FAS_Localized["+20 Fire Resistance"] = "+20 火焰抗性";
	FAS_Localized["+125 Armor"] = "+125 방어도";
	FAS_Localized["+1% Haste"] = "+1% 공격속도";
	FAS_Localized["+1% Dodge"] = "+1% 회피율";
	FAS_Localized["+8 Spell damage/healing"] = "+8 치유 효과와 주문의 피해";

-- localized special raid loot tokens
	FAS_Localized["Zulian Coin"]		=	"줄리안부족 주화";
	FAS_Localized["Razzashi Coin"]		=	"래즈자쉬부족 주화";
	FAS_Localized["Hakkari Coin"]		=	"학카리부족 주화";
	FAS_Localized["Gurubashi Coin"]		=	"구루바시부족 주화";
	FAS_Localized["Vilebranch Coin"]	=	"썩은가지부족 주화";
	FAS_Localized["Witherbark Coin"]	=	"마른나무껍질부족 주화";
	FAS_Localized["Sandfury Coin"]		=	"성난모래부족 주화";
	FAS_Localized["Skullsplitter Coin"]	=	"백골가루부족 주화";
	FAS_Localized["Bloodscalp Coin"]	=	"붉은머리부족 주화";
            
	FAS_Localized["Red Hakkari Bijou"]		=	"붉은색 학카리 장신구";
	FAS_Localized["Blue Hakkari Bijou"]		=	"파란색 학카리 장신구";
	FAS_Localized["Yellow Hakkari Bijou"]	=	"노란색 학카리 장신구";
	FAS_Localized["Orange Hakkari Bijou"]	=	"주황색 학카리 장신구";
	FAS_Localized["Green Hakkari Bijou"]	=	"녹색 학카리 장신구";
	FAS_Localized["Purple Hakkari Bijou"]	=	"보라색 학카리 장신구";
	FAS_Localized["Bronze Hakkari Bijou"]	=	"청동색 학카리 장신구";
	FAS_Localized["Silver Hakkari Bijou"]	=	"은색 학카리 장신구";
	FAS_Localized["Gold Hakkari Bijou"]		=	"황금색 학카리 장신구";
            
	FAS_Localized["Primal Hakkari Bindings"]	=	"고대 학카리 팔보호구";
	FAS_Localized["Primal Hakkari Armsplint"]	=	"고대 학카리 어깨갑옷";
	FAS_Localized["Primal Hakkari Stanchion"]	=	"고대 학카리 손목갑옷";
	FAS_Localized["Primal Hakkari Girdle"]		=	"고대 학카리 벨트";
	FAS_Localized["Primal Hakkari Sash"]		=	"고대 학카리 장식띠";
	FAS_Localized["Primal Hakkari Shawl"]		=	"고대 학카리 어깨걸이";
	FAS_Localized["Primal Hakkari Tabard"]		=	"고대 학카리 휘장";
	FAS_Localized["Primal Hakkari Kossack"]		=	"고대 학카리 조끼";
	FAS_Localized["Primal Hakkari Aegis"]		=	"고대 학카리 아이기스";
            
	FAS_Localized["Qiraji Magisterial Ring"]	=	"권위의 퀴라지 반지";
	FAS_Localized["Qiraji Ceremonial Ring"]		=	"의식의 퀴라지 반지";
	FAS_Localized["Qiraji Martial Drape"]		=	"전쟁의 퀴라지 망토";
--	FAS_Localized["Qiraji Regal Drape"]			=	"xxxxx";
	FAS_Localized["Qiraji Spiked Hilt"]			=	"못박힌 퀴라지 자루";
	FAS_Localized["Qiraji Ornate Hilt"]			=	"화려한 퀴라지 자루";
            
	FAS_Localized["Imperial Qiraji Armaments"]	=	"제국의 퀴라지 무기";
--	FAS_Localized["Imperial Qiraji Regalia"]	=	"xxxxx";
            
	FAS_Localized["Qiraji Bindings of Command"]		=	"지휘의 퀴라지 팔보호구";
--	FAS_Localized["Qiraji Bindings of Dominance"]	=	"xxxxx";
	FAS_Localized["Ouro's Intact Hide"]				=	"온전한 아우로의 가죽";
--	FAS_Localized["Skin of the Great Sandworm"]		=	"xxxxx";
--	FAS_Localized["Vek'lor's Diadem"]				=	"xxxxx";
	FAS_Localized["Vek'nilash's Circlet"]			=	"베크닐라쉬의 관";
--	FAS_Localized["Carapace of the Old God"]		=	"xxxxx";
--	FAS_Localized["Husk of the Old God"]			=	"xxxxx";
            
	FAS_Localized["Stone Scarab"]	=	"돌 스카라베";
	FAS_Localized["Gold Scarab"]	=	"황금 스카라베";
	FAS_Localized["Silver Scarab"]	=	"은 스카라베";
	FAS_Localized["Bronze Scarab"]	=	"청동 스카라베";
	FAS_Localized["Crystal Scarab"]	=	"수정 스카라베";
	FAS_Localized["Clay Scarab"]	=	"찰흙 스카라베";
	FAS_Localized["Bone Scarab"]	=	"뼈 스카라베";
	FAS_Localized["Ivory Scarab"]	=	"상아 스카라베";
            
	FAS_Localized["Azure Idol"]			=	"청금석 우상";
	FAS_Localized["Onyx Idol"]			=	"마노 우상";
	FAS_Localized["Lambent Idol"]		=	"미명석 우상";
	FAS_Localized["Amber Idol"]			=	"호박석 우상";
	FAS_Localized["Jasper Idol"]		=	"벽옥 우상";
	FAS_Localized["Obsidian Idol"]		=	"흑요석 우상";
	FAS_Localized["Vermillion Idol"]	=	"단사 우상";
	FAS_Localized["Alabaster Idol"]		=	"설화석 우상";
            
	FAS_Localized["Idol of the Sun"]	=	"태양의 우상";
	FAS_Localized["Idol of Night"]		=	"밤의 우상";
	FAS_Localized["Idol of Death"]		=	"죽음의 우상";
	FAS_Localized["Idol of the Sage"]	=	"현자의 우상";
	FAS_Localized["Idol of Rebirth"]	=	"환생의 우상";
--	FAS_Localized["Idol of Life"]		=	"xxxxx";
--	FAS_Localized["Idol of Strife"]		=	"xxxxx";
	FAS_Localized["Idol of War"]		=	"전쟁의 우상";

end

if ( GetLocale() == "frFR" ) then

-- localized special raid loot tokens
	FAS_Localized["Zulian Coin"]		=	"Pièce zulienne";
	FAS_Localized["Razzashi Coin"]		=	"Pièce Razzashi";
	FAS_Localized["Hakkari Coin"]		=	"Pièce hakkari";
	FAS_Localized["Gurubashi Coin"]		=	"Pièce Gurubashi";
	FAS_Localized["Vilebranch Coin"]	=	"Pièce Vilebranch";
	FAS_Localized["Witherbark Coin"]	=	"Pièce Witherbark";
	FAS_Localized["Sandfury Coin"]		=	"Pièce Sandfury";
	FAS_Localized["Skullsplitter Coin"]	=	"Pièce Skullsplitter";
	FAS_Localized["Bloodscalp Coin"]	=	"Pièce Bloodscalp";
            
	FAS_Localized["Red Hakkari Bijou"]		=	"Bijou hakkari rouge";
	FAS_Localized["Blue Hakkari Bijou"]		=	"Bijou hakkari bleu";
	FAS_Localized["Yellow Hakkari Bijou"]	=	"Bijou hakkari jaune";
	FAS_Localized["Orange Hakkari Bijou"]	=	"Bijou hakkari orange";
	FAS_Localized["Green Hakkari Bijou"]	=	"Bijou hakkari vert";
	FAS_Localized["Purple Hakkari Bijou"]	=	"Bijou hakkari violet";
	FAS_Localized["Bronze Hakkari Bijou"]	=	"Bijou hakkari bronze";
	FAS_Localized["Silver Hakkari Bijou"]	=	"Bijou hakkari argenté";
	FAS_Localized["Gold Hakkari Bijou"]		=	"Bijou hakkari doré";
            
	FAS_Localized["Primal Hakkari Bindings"]	=	"Manchettes primordiales hakkari";
	FAS_Localized["Primal Hakkari Armsplint"]	=	"Brassards primordiaux hakkari";
	FAS_Localized["Primal Hakkari Stanchion"]	=	"Etançon primordial hakkari";
	FAS_Localized["Primal Hakkari Girdle"]		=	"Ceinturon primordial hakkari";
	FAS_Localized["Primal Hakkari Sash"]		=	"Echarpe primordiale hakkari";
	FAS_Localized["Primal Hakkari Shawl"]		=	"Châle primordial hakkari";
	FAS_Localized["Primal Hakkari Tabard"]		=	"Tabard primordial hakkari";
	FAS_Localized["Primal Hakkari Kossack"]		=	"Casaque primordiale hakkari";
	FAS_Localized["Primal Hakkari Aegis"]		=	"Egide primordiale hakkari";
            
	FAS_Localized["Qiraji Magisterial Ring"]	=	"Anneau de magistrat qiraji";
	FAS_Localized["Qiraji Ceremonial Ring"]		=	"Anneau de cérémonie qiraji";
	FAS_Localized["Qiraji Martial Drape"]		=	"Drapé martial qiraji";
	FAS_Localized["Qiraji Regal Drape"]			=	"Drapé royal qiraji";
	FAS_Localized["Qiraji Spiked Hilt"]			=	"Drapé royal qiraji";
	FAS_Localized["Qiraji Ornate Hilt"]			=	"Manche orné";
            
	FAS_Localized["Imperial Qiraji Armaments"]	=	"Armes impériales qiraji";
	FAS_Localized["Imperial Qiraji Regalia"]	=	"Tenue de parade impériale qiraji";
            
	FAS_Localized["Qiraji Bindings of Command"]		=	"Manchettes de commandement qiraji";
	FAS_Localized["Qiraji Bindings of Dominance"]	=	"Manchettes de domination qiraji";
	FAS_Localized["Ouro's Intact Hide"]				=	"Peau intacte d'Ouro";
	FAS_Localized["Skin of the Great Sandworm"]		=	"Peau du Grand ver des sables";
	FAS_Localized["Vek'lor's Diadem"]				=	"Diadème de Vek'lor";
	FAS_Localized["Vek'nilash's Circlet"]			=	"Diadème de Vek'nilash";
	FAS_Localized["Carapace of the Old God"]		=	"Carapace du Dieu très ancien";
	FAS_Localized["Husk of the Old God"]			=	"Carcasse du Dieu très ancien";
            
	FAS_Localized["Stone Scarab"]	=	"Scarabée de pierre";
	FAS_Localized["Gold Scarab"]	=	"Scarabée d'or";
	FAS_Localized["Silver Scarab"]	=	"Scarabée d'argent";
	FAS_Localized["Bronze Scarab"]	=	"Scarabée de bronze";
	FAS_Localized["Crystal Scarab"]	=	"Scarabée de cristal";
	FAS_Localized["Clay Scarab"]	=	"Scarabée d'argile";
	FAS_Localized["Bone Scarab"]	=	"Scarabée d'os";
	FAS_Localized["Ivory Scarab"]	=	"Scarabée d'ivoire";
            
	FAS_Localized["Azure Idol"]			=	"Idole azur";
	FAS_Localized["Onyx Idol"]			=	"Idole d'onyx";
	FAS_Localized["Lambent Idol"]		=	"Idole brillante";
	FAS_Localized["Amber Idol"]			=	"Idole d'ambre";
	FAS_Localized["Jasper Idol"]		=	"Idole de jaspe";
	FAS_Localized["Obsidian Idol"]		=	"Idole d'obsidienne";
	FAS_Localized["Vermillion Idol"]	=	"Idole vermillon";
	FAS_Localized["Alabaster Idol"]		=	"Idole d'albâtre";
            
	FAS_Localized["Idol of the Sun"]	=	"Idole du soleil";
	FAS_Localized["Idol of Night"]		=	"Idole de la nuit";
	FAS_Localized["Idol of Death"]		=	"Idole de la mort";
	FAS_Localized["Idol of the Sage"]	=	"Idole du sage";
	FAS_Localized["Idol of Rebirth"]	=	"Idole de la renaissance";
	FAS_Localized["Idol of Life"]		=	"Idole de la vie";
	FAS_Localized["Idol of Strife"]		=	"Idole de la lutte";
	FAS_Localized["Idol of War"]		=	"Idole de la guerre";

end
