DSCT_Version = " SCT Dennie 1.67b 正式版 (战斗指示器)";
DSCT_MAIN_OPTION = "|cffffff00 SCT Dennie 1.67b 正式版|r";
DSCT_RESET_TIP = "已载入默认设置";
DSCT_FONTLIST = {{name="剪纸体",path="Fonts\\FZJZJW.TTF"},
{name="隶变",path="Fonts\\FZLBJW.TTF"},
{name="北魏楷书",path="Fonts\\FZBWJW.TTF"},
{name="细黑",path="Fonts\\FZXHJW.TTF"},
};

DSCT_ENFONTLIST = {{name="剪纸体",path="Fonts\\FZJZJW.TTF"},
{name="隶变",path="Fonts\\FZLBJW.TTF"},
{name="北魏楷书",path="Fonts\\FZBWJW.TTF"},
{name="细黑",path="Fonts\\FZXHJW.TTF"},
};

-- Static Messages
DSCT_DodgeMsg = {DODGE,"Dodge"};			-- Message to be displayed when you dodge
DSCT_ParryMsg = {PARRY,"Parry"};			-- Message to be displayed when you parry
DSCT_BlockMsg = {BLOCK,"Block"};			-- Message to be displayed when you block
DSCT_MissMsg = {MISS,"Miss"};			-- Message to be displayed when you are missed
DSCT_ResistMsg = {RESIST,"Resist"};	-- Message to be displayed when you resist
DSCT_DeflectMsg = {DEFLECTED,"Deflected"}; -- Message to be displayed when you deflect
DSCT_AbsorbMsg = {ABSORB,"Absorb"};			-- Message to be displayed when you Absorb
DSCT_ImmuneMsg = {IMMUNE,"Immune"};
DSCT_LowHP= {"生命 **","Life **"};			-- Message to be displayed when HP is low
DSCT_LowMana= {"魔力 **","Mana **"};			-- Message to be displayed when Mana is Low
DSCT_SelfFlag = "*";						-- Icon to 显示 self hits
DSCT_Combat = {"|cffffffff**|r 战斗开始 |cffffffff**|r","+Combat"};				-- Message to be displayed when entering combat
DSCT_NoCombat = {"|cffffffff**|r 战斗结束 |cffffffff**|r","-Combat"};			-- Message to be displayed when leaving combat
DSCT_ComboPoint = {" 星"," CP"};			-- Message to be displayed when leaving combat
DSCT_FiveCPMessage = {" 星 **终结**"," CP Finish!!"}; -- Message to be displayed when you have 5 combo points
DSCT_Honor = {"荣誉","Honor"};							-- Message to be displayed when gaining hnor/contribution points
DSCT_ExecuteMessage = "斩杀!";
DSCT_WrathMessage = "愤怒!";
DSCT_PowerList = {{" 法力值"," Mana"},{" 能量"," Energy"},{" 怒气"," Rage"}};

DSCT_WARRIOR = "战士";
DSCT_PALADIN = "圣骑士";

--nouns
DSCT_YOU = "你%s了目标的攻击";
DSCT_TARGET = "目标对你的攻击%s";
DSCT_AFFLICTED_BY = "你受到了<%s>效果的影响"; 
DSCT_PARTIAL = "目标对你的伤害，%s";
DSCT_YOU_GAIN = "获得：";
DSCT_YOU_FADE = "消失：";
DSCT_SHORTALERT = "预警：";
DSCT_YOU_GAIN_UNM = "获得*";
DSCT_YOU_FADE_UNM = "消失*";
DSCT_CRIT = {"致命! ","Crit! "};
--Search Messages

DSCT_ABSORB_AMOUNT_SEARCH1 = nil;
DSCT_ABSORB_AMOUNT_SEARCH2 = nil;
DSCT_ABSORB_TRAILER_SEARCH = "(%d+)点被吸收";
DSCT_BLOCK_AMOUNT_SEARCH = "(%d+)点被格挡";
DSCT_DEBUFF_NAME_SEARCH = nil;
DSCT_YOU_GAIN_POWER_SEARCH1 = nil;
DSCT_YOU_GAIN_POWER_SEARCH2 = nil;
DSCT_YOU_GAIN_POWER_SEARCH3 = nil;
DSCT_HONOR_SEARCH = "贡献点数预估：(%d+)";
DSCT_YOU_GAIN_SEARCH = nil;
DSCT_FADE_SEARCH = nil;
DSCT_YOUCRIT_SEARCH = nil;
DSCT_YOUCRIT_SEARCH2 = nil;

DSCT_YOUCRIT_SEARCH3 = nil;

DSCT_HEAL_SEARCH1 = nil;
DSCT_HEAL_SEARCH2 = nil;
DSCT_AURAHEAL_SEARCH1 = nil;
DSCT_AURAHEAL_SEARCH2 = nil;
DSCT_CRITHEAL_SEARCH1 = nil;
DSCT_CRITHEAL_SEARCH2 = nil;

--Useage
DSCT_DISPLAY_USEAGE = "使用方法：输入 /sct 打开配置菜单\n";

--Spell Alert search message
DSCT_SA_BEGIN_CAST = {"","|r开始施放","|r施放"};
DSCT_SA_CASTS_PLY_VS_PLY = nil;
DSCT_SA_CASTS_TOTEM = {"","|r施放了","|r施放"};
DSCT_SA_GAIN_BUFF = {"","|r获得了","|r获得"};
DSCT_SA_FADE_BUFF =  nil;

DSCT_SAEX_PERFORMOTHERSTART = {"","|r开始施展","|r施展"};
DSCT_SAEX_PERFORMGOOTHER = {"","|r使用了","|r使用"};

DSCT_FADE_BUFF = "|r失去了";
DSCT_BUFF_END = "|r效果";
DSCT_TOTEM_END = "|r图腾";


sct_spelltypes = {
	[0] = {"护甲","Physical"},
	[1] = {"神圣","Holy"},
	[2] = {"火焰","Fire"},
	[3] = {"自然","Nature"},
	[4] = {"冰霜","Frost"},
	[5] = {"暗影","Shadow"},
	[6] = {"奥术","Arcane"},
}

	
DSCT_EVENT_OPTION = "事件选项";
DSCT_MISC_OPTION = "基本选项";
DSCT_TEXT_OPTION = "动态文字选项";
DSCT_MSGTEXT_OPTION = "静态文字选项";
DSCT_WARNING_OPTION = "过低警告选项";
DSCT_BUTTON_RESET_LABEL = "重置";
DSCT_BUTTON_RESET_TIP= "恢复默认设置";
DSCT_BUTTON_SAVECUSTOM_LABEL = "保存个性设置"
DSCT_BUTTON_LOADCUSTOM_LABEL = "读取个性设置"

DSCT_RESET_TIP = "已载入默认设置";
DSCT_EVENTTYPE = {
{"关","右","左","_","静"},
{"关","上","下","_","静"},
{"关","左","右","_","静"},
{"关","左","上","右","静"},
{"关","左","右","中","静"},
{"关","左","上","右","静"},
{"关","左","右","下","静"},
}


TOOL_TIP_TEXT_SE = "选中则设置为以静态方式显示，否则以动态滚动方式显示";
DSCT_PREVIEW_TEXT1 = "拖动我[静]态位置";
DSCT_PREVIEW_TEXT2 = "拖动我[动]态位置";

DSCT_OPTION_ANIMODE = "动画方式";
DSCT_ANIMODE_TEXT = {[0] = "水平",[1] = "垂直",[2] = "抛物线",[3] = "弹出1",[4] = "弹出2",[5] = "弹出1a",[6] = "向上增强"};

DSCT_OptionCfg_Base = {
["ENABLED"] = {x = 20,y = -10, title = "激活战斗指示器", tooltipText = "激活战斗指示器"},
};

DSCT_OptionCfg_Event = {

	EventFrames = {
		["SHOWHIT"] = {x = 200,y = -65, title = "伤害", tooltipText = "显示你受到的伤害"},
		["SHOWMISS"] = {x = 200,y = -95, title = "未命中", tooltipText = "显示敌人对你的攻击未命中"},
		["SHOWDODGE"] = {x = 200,y = -125, title = "回避", tooltipText = "显示你回避敌人的攻击"},
		["SHOWPARRY"] = {x = 200,y = -155, title = "招架", tooltipText = "显示你招架敌人的攻击"},
		["SHOWBLOCK"] = {x = 200,y = -185, title = "格挡", tooltipText = "显示你格挡敌人的攻击"},
		["SHOWIMMUNE"] = {x = 200,y = -215, title = "免疫", tooltipText = "显示你免疫敌人的攻击"},
		["SHOWRESIST"] = {x = 200,y = -245, title = "抵抗", tooltipText = "显示你抵抗敌人的攻击"},
		["SHOWABSORB"] = {x = 200,y = -275, title = "吸收", tooltipText = "显示你吸收敌人的攻击"},		
		["SHOWSPELLCRIT"] = {x = 200,y = -305, title = "技能致命", tooltipText = "显示你的技能致命一击造成的伤害"},
		["SHOWDMGCRIT"] = {x = 200,y = -335, title = "普通致命", tooltipText = "显示你的普通致命一击造成的伤害"},
		
		["SHOWSPELL"] = {x = 350,y = -65, title = "法术伤害", tooltipText = "显示你受到的法术伤害"},
		["SHOWHEAL"] = {x = 350,y = -95, title = "法术治疗", tooltipText = "显示法术给你带来的治疗"},
		["SHOWDEBUFF"] = {x = 350,y = -125, title = "不良效果", tooltipText = "显示你受到的不良效果"},
		["SHOWBUFF"] = {x = 350,y = -155, title = "增益效果", tooltipText = "显示你受到的增益效"},
		["SHOWFADE"] = {x = 350,y = -185, title = "效果消失", tooltipText = "显示你消失的效果"},
		["SHOWPOWER"] = {x = 350,y = -215, title = "能量获得", tooltipText = "显示你获得的能量"},
		["SHOWCOMBOPOINTS"] = {x = 350,y = -245, title = "连击点", tooltipText = "显示你获得的连击点数"},
		["SHOWHONOR_DSCT"] = {x = 350,y = -275, title = "获得荣誉", tooltipText = "显示你获得的荣誉点数"},
		["SHOWCOMBATIN"] = {x = 350,y = -305, title = "战斗开始", tooltipText = "显示战斗开始的提示"},
		["SHOWCOMBATOUT"] = {x = 350,y = -335, title = "战斗结束", tooltipText = "显示战斗结束的提示"},

	},
};
DSCT_OptionCfg_Warning = {
	EventFrames = {
		["SHOWLOWHP"] = {x = 200,y = -75, title = "生命过低", tooltipText = "当你生命低于设定值的时候显示警告"},
		["SHOWLOWMANA"] = {x = 200,y = -135, title = "魔法过低", tooltipText = "当你魔法低于设定值的时候显示警告"},
		["SHOWEXECUTE"] = {x = 200,y = -195,title = "显示斩杀", tooltipText = "目标血量低于20%时候显示斩杀，限战士和圣骑"};
	},
	Sliders = {
		["LOWHP"] = { x = 350,y = -85, title = "生命值百分比", minValue = 0.1, maxValue = 0.9, valueStep = 0.1, minText="10%", maxText="90%", tooltipText = "生命过低警告的百分比"};
		["LOWMANA"] = { x = 350,y = -145, title = "魔法值百分比", minValue = 0.1, maxValue = 0.9, valueStep = 0.1, minText="10%", maxText="90%", tooltipText = "魔法过低警告的百分比"};
	},
}
DSCT_OptionCfg_Misc = {
	CheckButtons = {
		["SHOWSELF"] = {x = 190,y = -60, title = "标记战斗信息", tooltipText = "在战斗信息的两侧添加'*'作为标记"},
		["DAMAGETYPE"] = {x = 190,y = -90, title = "显示魔法伤害类型", tooltipText = "显示你受到的魔法伤害类型，比如火焰，暗影"},
		["HEALERNAME"] = {x = 190,y = -120, title = "显示治疗者姓名", tooltipText = "显示你受到的治疗来自哪个玩家"},
		["ENTEXT"] = {x = 190,y = -150, title = "英文战斗信息", tooltipText = "将一些基本信息以英文显示，比如Energy,Dogde等"},
		["CRITANI"] = {x = 190,y = -180, title = "显示爆击效果", tooltipText = "受到致命攻击时候文字提供一个放大效果"},
		["ACCMode"] = {x = 190,y = -210, title = "精确模式(慎用)", tooltipText = "格式化战斗信息，可以获得更精确的显示（但也可能会影响到一些统计伤害插件)，改变此项设置只有在重新登入后才会生效"},
	},
}

DSCT_OptionCfg_Text = {
	Sliders = {
		["ANIMATIONSPEED"] = {x = 195,y = -80, title = "动画速度", minValue = 0.2, maxValue = 3, valueStep = 0.1, minText="20%", maxText="300%", tooltipText = "设置动画速度"},
		["ROTATION"] = { x = 195,y = -130, title = "动画旋转角度", minValue = 0, maxValue = 355, valueStep = 5,minText="0 度", maxText="355 度", tooltipText = "旋转动态文字的移动轨迹角度"},
		["ALPHA"] = { x = 195,y = -180, title = "透明度", minValue = 0.2, maxValue = 1, valueStep = 0.05, minText="20%", maxText="100%", tooltipText = "设置文字的透明度"},
		
		["TEXTSIZE"] = { x = 195,y = -350, title = "文字大小", minValue = 12, maxValue = 36, valueStep = 1, minText="小", maxText="大", tooltipText = "设置动态中文文字的大小"},
		["ENTEXTSIZE"] = { x = 375,y = -300, title = "文字大小", minValue = 12, maxValue = 36, valueStep = 1, minText="小", maxText="大", tooltipText = "设置动态英文文字的大小"},

	},
	
	ListFrames = {
		["FONT"] = { x = 190,y = -240,title = "中文字体",tooltipText="中文文字字体",min = 1,max = 4,list = {{name=DSCT_FONTLIST[1].name,val=1},
						{name = DSCT_FONTLIST[2].name,val=2},{name=DSCT_FONTLIST[3].name,val=3},{name=DSCT_FONTLIST[4].name,val=4}} },
		["FONTOUTLINE"] = { x = 190,y = -290, title = "文字效果",tooltipText="文字效果", min = 1,max = 6,list = {{name = "无",val = 1},{name = "描边 细",val = 2},
						{name="描边 粗",val = 3},{name = "阴影1",val = 4},{name = "阴影2",val = 5},{name = "阴影3",val = 6}} },						
		["ANIMODE"] = { x = 370,y = -60,title = "动画",tooltipText="动画模式", min = 0,max = 6,list = {{name = "水平",val = 0},{name = "垂直",val = 1},{name = "抛物线",val = 2},
						{name = "弹出1",val = 3},{name = "弹出2",val = 4},{name = "弹出1a",val = 5},{name = "向上增强",val = 6}} },
		["ENFONT"] = { x = 370,y = -240,title = "数字,英文字体",tooltipText="数字和英文文字字体",min = 1,max = 4,list = {{name=DSCT_ENFONTLIST[1].name,val=1},
					{name = DSCT_ENFONTLIST[2].name,val=2},{name=DSCT_ENFONTLIST[3].name,val=3},{name=DSCT_ENFONTLIST[4].name,val=4},--[[{name=DSCT_ENFONTLIST[5].name,val=5},
					{name = DSCT_ENFONTLIST[6].name,val=6},{name=DSCT_ENFONTLIST[7].name,val=7},{name=DSCT_ENFONTLIST[8].name,val=8}]]} },

	},
}

DSCT_OptionCfg_MSGText = {
	Sliders = {
		["MESSAGEALPHA"] = { x = 195,y = -260, title = "透明度", minValue = 0.2, maxValue = 1, valueStep = 0.05, minText="20%", maxText="100%", tooltipText = "设置静态方式文字的透明度"},
		["MESSAGETIMER"] = { x = 195,y = -310, title = "停留时间", minValue = 1, maxValue = 20, valueStep = 1, minText="1秒", maxText="20秒", tooltipText = "设置静态文字停留在画面的时间"},
		["MESSAGEFADETIMER"] = { x = 195,y = -360, title = "淡出时间", minValue = 1, maxValue = 10, valueStep = 0.5, minText="1秒", maxText="10秒", tooltipText = "设置静态文字消失过程所用时间"},
		["MESSAGESIZE"] = { x = 195,y = -175, title = "静态文字大小", minValue = 12, maxValue = 36, valueStep = 1, minText="小", maxText="大", tooltipText = "设置静态方式文字尺寸的大小"};

	},
	
	ListFrames = {
		["MESSAGEFONT"] = { x = 190,y = -60,title = "字体",tooltipText="静态文字字体", min = 1,max = 4,list = {{name=DSCT_FONTLIST[1].name,val=1},
					{name = DSCT_FONTLIST[2].name,val=2},{name=DSCT_FONTLIST[3].name,val=3},{name=DSCT_FONTLIST[4].name,val=4}} },
		["MESSFONTOUTLINE"] = { x = 190,y = -110,title = "字体描边",tooltipText="给静态字体描边", min = 1,max = 6,list = {{name = "无",val = 1},{name = "描边 细",val = 2},
						{name="描边 粗",val = 3},{name = "阴影1",val = 4},{name = "阴影2",val = 5},{name = "阴影3",val = 6}} },	

	},
}

--Check Button option values

--Slider options values
--DSCTOptionsFrameSliders ["ANIC"] = {  title = "最大显示数量", minValue = 1, maxValue = 10, valueStep = 1,minText="1个", maxText="10个", tooltipText = "设置动态文字的大小"};

DSCTOptionsColorPickerEx = { };

DSCTAniModeParamsSliders = {
[0] = {
Sliders = {
	["ANIMODE0_Param1"] = {x = 375,y = -125, title = "移动距离", tooltipText = "水平移动的距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%",},
	}
},

[1] = {
Sliders = {
	["ANIMODE1_Param1"] = {x = 375,y = -125, title = "移动距离", tooltipText = "垂直移动的距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	}
},

[2] = {
Sliders = {
	["ANIMODE2_Param1"] = {x = 375,y = -125, title = "射出强度", tooltipText = "抛物线射出力量强度",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	["ANIMODE2_Param2"] = {x = 375,y = -170, title = "坠落深度", tooltipText = "抛物线射出后坠落的深度",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	}
},

[3] = {
Sliders = {
	["ANIMODE3_Param1"] = {x = 375,y = -125, title = "弹出距离1", tooltipText = "第一段弹出距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	["ANIMODE3_Param2"] = {x = 375,y = -170, title = "弹出距离2", tooltipText = "第二段弹出距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	}
},

[4] = {
Sliders = {
	["ANIMODE4_Param1"] = {x = 375,y = -125, title = "弹出距离1", tooltipText = "第一段弹出距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	["ANIMODE4_Param2"] = {x = 375,y = -170, title = "弹出距离2", tooltipText = "第二段弹出距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	}
},

[5] = {
Sliders = {
	["ANIMODE5_Param1"] = {x = 375,y = -125, title = "弹出距离1", tooltipText = "第一段弹出距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	["ANIMODE5_Param2"] = {x = 375,y = -170, title = "弹出距离2", tooltipText = "第二段弹出距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	}
},

[6] = {
Sliders = {
	["ANIMODE6_Param1"] = {x = 375,y = -125, title = "移动距离1", tooltipText = "第一段移动距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	["ANIMODE6_Param2"] = {x = 375,y = -170, title = "移动距离2", tooltipText = "第二段移动距离",minValue = 0.2, maxValue = 2, valueStep = 0.1, minText="20%", maxText="200%"},
	}
},

};
