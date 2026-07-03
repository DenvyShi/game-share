assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Sell")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Sell"] = true,
	["Automatically sell all grey inventory items when at merchant"] = true,
	["Ignore"] = true,
	["Items that should never be sold."] = true,
	["List"] = true,
	["Print all items being ignored by Sell to the screen."] = true,
	["Print all items being sold by Sell to the screen."] = true,
	["Add Item"] = true,
	["Add an item to be ignored, accepts item names or links. Name must be exact, and is case sensitive."] = true,
	["Add an item to always besold, accepts item names or links. Name must be exact, and is case sensitive."] = true,
	["<item name or link>"] = true,
	["Remove Item"] = true,
	["Removes an item from the ignore list. It must be entered exactly as it was added."] = true,
	["Removes an item from the always sell list. It must be entered exactly as it was added."] = true,
	["Purge"] = true,
	["Remove all items from the ignore list."] = true,
	["Remove all items from the always sell list."] = true,
	[" items purged."] = true,
	["Always sell"] = true,
	["Items that should always be sold."] = true,
	["Ignoring no items."] = true,
	["Ignoring these items:"] = true,
	["No items are specified to always be sold."] = true,
	["Always selling these items:"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
    ["Sell"] = "商人-售卖",
	["Automatically sell all grey inventory items when at merchant"] = "与商人对话时，自动售卖所有灰色物品",
	["Ignore"] = "忽略",
	["Items that should never be sold."] = "不自动出售的物品",
	["List"] = "列表",
	["Print all items being ignored by Sell to the screen."] = "显示所有被忽略的物品到屏幕",
	["Print all items being sold by Sell to the screen."] = "显示所有物品出售出售给屏幕",
	["Add Item"] = "增加物品",
	["Add an item to be ignored, accepts item names or links. Name must be exact, and is case sensitive."] = "添加一个被忽略的项目, 接受项目名称或链接, 名字必须精确并且是区分大小写",
	["Add an item to always besold, accepts item names or links. Name must be exact, and is case sensitive."] = "添加对象, 他总是自动售卖的, 采用的物品或引用的名字. 必须精确并且是区分大小写",
	["<item name or link>"] = "<物品名字或链接>",
	["Remove Item"] = "删除对象",
	["Removes an item from the ignore list. It must be entered exactly as it was added."] = "从忽略列表中删除对象.它必须和添加时一样",
	["Removes an item from the always sell list. It must be entered exactly as it was added."] = "从总是卖列表中删除对象.它必须和添加时一样",
	["Purge"] = "清除",
	["Remove all items from the ignore list."] = "从“忽略列表”中移除所有项目",
	["Remove all items from the always sell list."] = "从“总是卖”中移除所有项目",
	[" items purged."] = " 物品清除",
	["Always sell"] = "总是售卖",
	["Items that should always be sold."] = "总是要自动出售的物品",
	["Ignoring no items."] = "忽略任何物品",
	["Ignoring these items:"] = "忽略这些东西:",
	["No items are specified to always be sold."] = "没有指定要始终出售的项目",
	["Always selling these items:"] = "总是出售这些物品:",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Sell = Automaton:NewModule("Sell")
Automaton_Sell.modulename = L["Sell"]
Automaton_Sell.moduledesc = L["Automatically sell all grey inventory items when at merchant"]
Automaton_Sell.options = {
	ignore = {
		type  = "group", name  = L["Ignore"], desc  = L["Items that should never be sold."],
		args  = {
			list = {
				type = "execute", name = L["List"], desc = L["Print all items being ignored by Sell to the screen."],
				func = function() Automaton_Sell:ListIgnored() end
			},
			add = {
				type  = "text", name = L["Add Item"], desc = L["Add an item to be ignored, accepts item names or links. Name must be exact, and is case sensitive."],
				order = 1, usage = L["<item name or link>"],
				get   = false,
				set   = function(v) Automaton_Sell:IgnoreItem(v) end,
			},
			remove = {
				type  = "text", name = L["Remove Item"], desc = L["Removes an item from the ignore list. It must be entered exactly as it was added."],
				order = 2, usage = L["<item name or link>"],
				get   = false,
				set   = function(v) Automaton_Sell:RemoveIgnore(v) end,
			},
			purge = {
				type = "execute", name = L["Purge"], desc = L["Remove all items from the ignore list."],
				func = function() Automaton_Sell:PurgeIgnored() end
			}
		},
	},
	custom = {
		type  = "group", name = L["Always sell"], desc = L["Items that should always be sold."],
		args  = {
			list = {
				type = "execute", name = L["List"], desc = L["Print all items being sold by Sell to the screen."],
				func = function() Automaton_Sell:ListAlwaysSell() end
			},
			add = {
				type  = "text", name = L["Add Item"], desc = L["Add an item to always besold, accepts item names or links. Name must be exact, and is case sensitive."],
				order = 1, usage = L["<item name or link>"],
				get   = false,
				set   = function(v) Automaton_Sell:AlwaysSellItem(v) end,
			},
			remove = {
				type  = "text", name = L["Remove Item"], desc = L["Removes an item from the always sell list. It must be entered exactly as it was added."],
				order = 2, usage = L["<item name or link>"],
				get   = false,
				set   = function(v) Automaton_Sell:RemoveAlwaysSell(v) end,
			},
			purge = {
				type = "execute", name = L["Purge"], desc = L["Remove all items from the always sell list."],
				func = function() Automaton_Sell:PurgeAlwaysSell() end
			}
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Sell:OnInitialize()
	self.db = Automaton:AcquireDBNamespace("Sell")
	Automaton:RegisterDefaults("Sell", "profile", {
		useGarbageFu = false,
		ignore = {},
		custom = {}
	})
	
	self:RegisterOptions(self.options)
end

function Automaton_Sell:OnEnable()
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("MERCHANT_CLOSED")
end

function Automaton_Sell:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------
autoSilent = 0

local sellTimer = CreateFrame("Frame") -- 解决N服端快速卖垃圾掉线的问题
sellTimer.timeSinceLast = 0
sellTimer:Hide()
sellTimer:SetScript("OnUpdate", function() 
		if not MerchantFrame:IsVisible() then sellTimer:Hide() return end
		sellTimer.timeSinceLast = sellTimer.timeSinceLast + arg1
		if (sellTimer.timeSinceLast) > TOOLTIP_UPDATE_TIME then
			sellTimer.timeSinceLast = 0
			local count = table.getn(sellTimer.junk)
			if count > 0 then
				local bag, slot = sellTimer.junk[count][1], sellTimer.junk[count][2]
				PickupContainerItem(bag,slot)
				MerchantItemButton_OnClick("LeftButton");
					if (autoSilent == 0) then 
						DEFAULT_CHAT_FRAME:AddMessage("已出售" .. (GetContainerItemLink(bag, slot) or "未知物品"), 0.0, .8, 1)
					end
				table.remove(sellTimer.junk,count)
			else
				sellTimer:Hide()
			end
		end
end)
	
local bag, slot
function Automaton_Sell:MERCHANT_SHOW()
	sellTimer.junk = {}
	for bag = 0, 4 do
		if GetContainerNumSlots(bag) > 0 then
			for slot = 0, GetContainerNumSlots(bag) do
				local texture, itemCount, locked, quality = GetContainerItemInfo(bag, slot)
				if (quality == 0) or (quality == -1) then
					local linkcolor = self:ProcessLink(GetContainerItemLink(bag, slot))
					if (linkcolor > 0) or (linkcolor == 1) then
						table.insert(sellTimer.junk,{bag,slot})
					end
				end	
			end
		end
	end
	if table.getn(sellTimer.junk) > 0 then
		sellTimer:Show()
	end
	
	showmoney, income_sell = GetMoney(), 0
end

local color, name
function Automaton_Sell:ProcessLink(link)
	for color, name in string.gfind(link, "(|c%x+)|Hitem:.+|h%[(.-)%]|h|r") do
		for k,v in pairs(self.db.profile.ignore) do
			if (name == v) or (link == v) then
				return 0
			end
		end
		for k,v in pairs(self.db.profile.custom) do
			if (name == v) or (link == v) then
				return 1
			end
		end
		if color == ITEM_QUALITY_COLORS[0].hex then
			return 1
		end
	end
	return 0
end

function Automaton_Sell:IgnoreItem(item)
	tinsert(self.db.profile.ignore,item)
end

function Automaton_Sell:RemoveIgnore(item)
	for k,v in pairs(self.db.profile.ignore) do
		if v == item then
			self.db.profile.ignore[k] = nil
		end
	end
end

function Automaton_Sell:ListIgnored()
	if table.getn{self.db.profile.ignore} == 0 then
		self:Print(L["Ignoring no items."])
	else
		self:Print(L["Ignoring these items:"])
		for k,v in pairs(self.db.profile.ignore) do
			self:Print(v)
		end
	end
end

function Automaton_Sell:PurgeIgnored()
	self:Print(table.getn{self.db.profile.ignore} .. L[" items purged."])
	self.db.profile.ignore = {}
end

function Automaton_Sell:AlwaysSellItem(item)
	tinsert(self.db.profile.custom,item)
end

function Automaton_Sell:RemoveAlwaysSell(item)
	for k,v in pairs(self.db.profile.custom) do
		if v == item then
			self.db.profile.custom[k] = nil
		end
	end
end

function Automaton_Sell:ListAlwaysSell()
	if table.getn{self.db.profile.custom} == 0 then
		self:Print(L["No items are specified to always be sold."])
else
		self:Print(L["Always selling these items:"])
		for k,v in pairs(self.db.profile.custom) do
			self:Print(v)
		end
	end
end

function Automaton_Sell:PurgeAlwaysSell()
	self:Print(table.getn{self.db.profile.custom} .. L[" items purged."])
	self.db.profile.custom = {}
end

-- 单次售卖收入
local function GetIncomeGSC (total)
	local gold, Temp, silver, copper
	gold = floor(total/10000)
	Temp = total-(gold*10000)
	silver = floor(Temp/100)
	copper = Temp - (silver*100)

	local GSC  = ""
	if (gold > 0) then
		GSC = gold .. "|cffffd700金|R"
	end

	if (silver > 0) then
		GSC = GSC .. silver .. "|cffe6e6e6银|R"
	elseif (silver==0 and gold > 0) then
		GSC = GSC .. silver .. "|cffe6e6e6银|R"
	end

	if (copper > 0) then
		GSC = GSC .. copper .. "|cffeda55f铜|R"
	elseif (copper==0 and (silver > 0 or gold > 0)) then
		GSC = GSC .. copper .. "|cffeda55f铜|R"
	end
	
	return GSC
end

function Automaton_Sell:MERCHANT_CLOSED()
    local sellmoney = GetMoney()
    if sellmoney > showmoney then
    	income_sell = (sellmoney - showmoney)
        showmoney = sellmoney
		DEFAULT_CHAT_FRAME:AddMessage("|cffdd66dd本次售卖收入 |r" .. GetIncomeGSC(income_sell))
	end
end