local LOCALE = GetLocale()
ArchiTotemLocale = setmetatable({},{__index = function(t,k)
  local v = tostring(k)
  rawset(t,k,v)
  if (LOCALE ~= "enUS") and (LOCALE ~= "enGB") then
  	ArchiTotem_Print(string.format(" %q not found for %s",v,LOCALE),"debug")
  end
  return v
end})
local LOCALE = GetLocale()
local L = ArchiTotemLocale
if (LOCALE =="zhCN") or  MRBCAT.XZ  then
L["Earthbind Totem"] = "地缚图腾"
L["Tremor Totem"] = "战栗图腾"
L["Strength of Earth Totem"] = "大地之力图腾"
L["Stoneskin Totem"] = "石肤图腾"
L["Stoneclaw Totem"] = "石爪图腾"
L["Searing Totem"] = "灼热图腾"
L["Fire Nova Totem"] = "火焰新星图腾"
L["Magma Totem"] = "熔岩图腾"
L["Frost Resistance Totem"] = "抗寒图腾"
L["Flametongue Totem"] = "火舌图腾"
L["Mana Spring Totem"] = "法力之泉图腾"
L["Mana Tide Totem"] = "法力之潮图腾"
L["Fire Resistance Totem"] = "抗火图腾"
L["Poison Cleansing Totem"] = "清毒图腾"
L["Disease Cleansing Totem"] = "祛病图腾"
L["Healing Stream Totem"] = "治疗之泉图腾"
L["Tranquil Air Totem"] = "宁静之风图腾"
L["Grounding Totem"] = "根基图腾"
L["Windfury Totem"] = "风怒图腾"
L["Grace of Air Totem"] = "风之优雅图腾"
L["Nature Resistance Totem"] = "自然抗性图腾"
L["Windwall Totem"] = "风墙图腾"
L["Sentry Totem"] = "岗哨图腾"
L["Totemic Recall"] = "图腾召回"

end
L["ver."] = "ver."
L["loaded"] = "加载"
L["Earth totems shown: "] = "大地图腾: "
L["Fire totems shown: "] = "火之图腾: "
L["Water totems shown: "] = "水之图腾: "
L["Air totems shown: "] = "风之图腾: "
L["Totemic Recall shown: "] = "图腾召回: "
L["Direction set to: Down"] = "方向设置：向下"
L["Direction set to: Up"] = "方向设置：向上"
L["Order set to: "] = "单位设置: "
L["Scale set to: "] = "比例设置: "
L["Showing all totems on mouseover"] = "鼠标悬停时显示所有图腾"
L["Showing only one element on mouseover"] = "鼠标悬停时仅显示一个图腾"
L["Totems will move the the bottom line when cast"] = "施放时图腾将留在底部"
L["Totems will stay where they are when cast"] = "施放时图腾将留在原地"
L["Timers are now turned on"] = "计时器已打开"
L["Timers are now turned off"] = "计时器已关闭"
L["Tooltips are now turned on"] = "鼠标提示已打开"
L["Tooltips are now turned off"] = "鼠标提示已关闭"
L["Debuging are now turned on"] = "调试已打开"
L["Debuging are now turned off"] = "调试已关闭"
L["Available commands:"] = "可用命令："
L["/at set <earth/fire/water/air> # - Sets the totems shown of that element to #."] = "/at set <earth/fire/water/air> # - 将该元素图腾设置为 #。"
L["/at direction <up/down> - Set the direction totems pop up."] = "/at direction <up/down> - 设置图腾弹出的方向."
L["/at order <element 1, element 2, element 3, element 4> - Sets the order of the totems, from left to right."] = "/at order <element 1, element 2, element 3, element 4> - 设置图腾的顺序，从左到右."
L["/at scale # - Sets the scale of ArchiTotem, default is 1."] = "/at scale # - 设置图腾比例，默认为 1."
L["/at showall - Toggles show all mode, displaying all totems on mouseover."] = "/at showall - 切换显示所有模式，在鼠标悬停时显示所有图腾."
L["/at bottomcast - Toggles moving totems to the bottom line when cast"] = "/at bottomcast - 在施放时将图腾移动到底部"
L["/at timers - Toggles showing timers"] = "/at timers - 显示计时器切换"
L["/at tooltip - Toggles showing tooltips"] = "/at tooltip - 显示鼠标提示开关"
L["/at debug - Toggles debuging"] = "/at debug - 切换调试"
L["Moving the bar:"] = "移动工具栏:"
L["Ctrl-RightClick and Drag any of the main buttons"] = "Ctrl-Right单击并拖动任何主要按钮"
L["Ordering totems of same element:"] = "对同一元素的图腾进行排序:"
L["Ctrl-LeftClick any of the buttons"] = "Ctrl-Left单击任意按钮"
L["Unavailable command. Type /at for help."] = "输入命令/at 获取帮助."		
L["Elements must be written in english!"] = "Elements 必须用英文书写!"
L["Direction must be down or up!"] = "方向必须向下或向上!"
L["Scale must be a number!"] = "比例必须是数字!"
L["Specify scale"] = "指定比例"

L["Cast Earth Totem"] = "施放大地图腾"
L["Cast Fire Totem"] = "施放火之图腾"
L["Cast Water Totem"] = "施放水之图腾"
L["Cast Air Totem"] = "施放风之图腾"
	
BINDING_NAME_CAST_EARTH_TOTEM = L["Cast Earth Totem"]
BINDING_NAME_CAST_FIRE_TOTEM = L["Cast Fire Totem"]
BINDING_NAME_CAST_WATER_TOTEM = L["Cast Water Totem"]
BINDING_NAME_CAST_AIR_TOTEM = L["Cast Air Totem"]
BINDING_NAME_CAST_TEM_TOTEM = L["Totemic Recall"]