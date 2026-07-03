assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Purchases")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Purchases"] = true,
	["Automatically restock items"] = true,
	["Reagent"] = true,
	["Set item to buy"] = true,
	["Quantity"] = true,
	["Set the number of purchased items"] = true,
	["Bought "] = true,
	[" items."] = true,
	["Already have "] = true,
	
	["Ankh"] = true,
	["Arcane Powder"] = true,
	["Ashwood Seed"] = true,
	["Demonic Figurine"] = true,
	["Holy Candle"] = true,
	["Hornbeam Seed"] = true,
	["Infernal Stone"] = true,
	["Ironwood Seed"] = true,
	["Maple Seed"] = true,
	["Rune of Portals"] = true,
	["Rune of Teleportation"] = true, 
	["Sacred Candle"] = true,
	["Stranglethorn Seed"] = true,
	["Symbol of Divinity"] = true,
	["Symbol of Kings"] = true,
	["Wild Berries"] = true,
	["Wild Thornroot"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Purchases"] = "商人-购买材料",
	["Automatically restock items"] = "与商人对话时，自动补充特定材料",
	["Reagent"] = "施法材料",
	["Set item to buy"] = "设置购买项目",
	["Quantity"] = "数量",
	["Set the number of purchased items"] = "设置购买物品的数量",
	["Bought "] = "买了 ",
	[" items."] = " 物品.",
	["Already have "] = "已经有 ",
	
	["Ankh"] = "十字章",
	["Arcane Powder"] = "魔粉",
	["Ashwood Seed"] = "灰木种子",
	["Demonic Figurine"] = "恶魔雕像",
	["Holy Candle"] = "圣洁蜡烛",
	["Hornbeam Seed"] = "角树种子",
	["Infernal Stone"] = "地狱火石",
	["Ironwood Seed"] = "铁木种子",
	["Maple Seed"] = "枫树种子",
	["Rune of Portals"] = "传送门符文",
	["Rune of Teleportation"] = "传送符文",
	["Sacred Candle"] = "神圣蜡烛",
	["Stranglethorn Seed"] = "荆棘种子",
	["Symbol of Divinity"] = "神圣符印",
	["Symbol of Kings"] = "王者印记",
	["Wild Berries"] = "野生浆果",
	["Wild Thornroot"] = "野生棘根草",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Purchases = Automaton:NewModule("Purchases")
Automaton_Purchases.modulename = L["Purchases"]
Automaton_Purchases.moduledesc = L["Automatically restock items"]
Automaton_Purchases.options = {
	reagent = {
		type = "text", name = L["Reagent"], desc = L["Set item to buy"], order = 2,
		get = function() return Automaton_Purchases.db.profile.reagent end,
		set = function(v) Automaton_Purchases.db.profile.reagent = v end,
		validate = {L["Ankh"], L["Arcane Powder"], L["Ashwood Seed"], L["Demonic Figurine"], L["Holy Candle"], L["Hornbeam Seed"], L["Infernal Stone"], L["Infernal Stone"], L["Maple Seed"], L["Rune of Portals"], L["Rune of Teleportation"], L["Sacred Candle"], L["Stranglethorn Seed"], L["Symbol of Divinity"], L["Symbol of Kings"], L["Wild Berries"], L["Wild Thornroot"]}
	},
	quantity = {
		type = "range", name = L["Quantity"], desc = L["Set the number of purchased items"], order = 3,
		get = function() return Automaton_Purchases.db.profile.quantity end,
		set = function(v) Automaton_Purchases.db.profile.quantity = v end,
		min = 0,
		max = 60,
		step = 5,
		bigStep = 10,
	},
}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Purchases:OnInitialize()
	self.db = Automaton:AcquireDBNamespace("Purchases")
	Automaton:RegisterDefaults("Purchases", "profile", {
		disabled = true,
		quantity = 0,
		reagent = L["Ankh"],
	})
	Automaton:SetDisabledAsDefault(self, "Purchases")
	
	self:RegisterOptions(self.options)
end

function Automaton_Purchases:OnEnable()
	self:RegisterEvent("MERCHANT_SHOW")
end

function Automaton_Purchases:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------

function Automaton_Purchases:MERCHANT_SHOW()
	quantity = Automaton_Purchases.db.profile.quantity
	reagent = Automaton_Purchases.db.profile.reagent

	for i = 1, GetMerchantNumItems() do
		local MerchantItem = GetMerchantItemInfo(i)
		if MerchantItem == reagent then
			local amountInBag = tonumber(self:SearchItem(reagent))
			local needed = quantity - amountInBag
			if needed > 0 then
				BuyMerchantItem(i, needed)
				self:Print(L["Bought "]..needed..L[" items."])
				else
				self:Print(L["Already have "]..amountInBag..L[" items."])
			end
		end
	end
end

function Automaton_Purchases:SearchItem(itemname)
	local count = 0
	for bag = 0, 4 do
		if GetContainerNumSlots(bag) > 0 then
			for slot = 0, GetContainerNumSlots(bag) do
				if GetContainerItemLink(bag, slot) then
					local _,_,link = string.find(GetContainerItemLink(bag, slot), "(item:%d+:%d+:%d+:%d+)")
					local item = GetItemInfo(link)
					if item == itemname then
						local _,q = GetContainerItemInfo(bag, slot)
						count = count + q
					end
				end
			end
		end
	end
	return count
end