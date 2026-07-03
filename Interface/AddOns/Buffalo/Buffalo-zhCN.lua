local L = AceLibrary("AceLocale-2.2"):new("Buffalo")

L:RegisterTranslations("zhCN", function()
    return {
    	["Lock"] = "锁定",
    	["When activated, the buff frames are locked and the reference frames are hidden"] = "锁定buffalo的位置",
    	["Buffs"] = "Buffs",
    	["Scale"] = "缩放",
    	["Scale Buff Icons"] = "缩放图标大小",
    	["Rows"] = "行",
    	["Number of Rows. Only applies when Growth Precedence is Vertical"] = "行数。仅适用于纵向增长优先",
    	["Columns"] = "列",
    	["Number of Columns. Only applies when Growth Precedence is Horizontal"] = "列数。仅适用于水平增长优先",
    	["X-Padding"] = "列间隔",
    	["Distance between columns"] = "每列间距",
    	["Y-Padding"] = "行间隔",
    	["Distance between rows"] = "每行间距",
    	["Horizontal Direction"] = "水平增长",
    	["In which horizontal direction should the display grow?"] = "水平方向显示模式",
    	["To the left"] = "从左开始",
    	["To the right"]="从右开始",
    	["Vertical Direction"] = "纵向增长",
    	["In which vertical direction should the display grow?"] = "纵向方向显示模式",
    	["Upwards"] = "向上",
		["Downwards"] = "向下",
		["Horizontally"] = "水平",
		["Vertically"] = "纵向",
------------------------------------------------------ 15:44
		["Manipulate Buffs Display"] = "Buffs显示控制",
		["Control the distance between rows/columns"] = "间隔距离",
		["Padding"] = "间隔",
		["Debuffs"] = "Debuffs",
		["Manipulate Debuffs Display"] = "Debuffs显示控制",
		["Scale Debuff Icons"] = "缩放Debuff图标",
		["Weapon Buffs"] = "武器Buffs",
		["Manipulate Weapon Buffs Display"] = "武器Buffs显示控制",
		["Reset"] = "重置",
----------------------------------------------------
		["Verbose Timers"] = "精确计时",
		["Replaces the default time format for timers with HH:MM or MM:SS"] = "以精确的方式计时",
-------------------------------------------------------
		["Flashing"] = "闪烁",
		["Toggle flashing on fading buffs"] = "buffs将要结束时闪烁",
		["Timers"] = "计时",
		["Customize buff timers"] = "buff计时自定义",
-----------------------------------------------------------
		["config"] = "设置",
		["Config"] = "设置",
-----------------------------------------------------------
    }
end)
