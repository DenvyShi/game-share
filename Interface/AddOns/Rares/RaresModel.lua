--[[
	RaresModel.lua
		1. RaresRare model
		2. RaresLoot model
--]]

--[[
	---------------------------- RaresRare model ----------------------------
--]]

RaresRare = {}
RaresRare.__index = RaresRare

function RaresRare:new()
	local self = setmetatable({}, RaresRare)
	self.name = ""
	self.zone = ""
	self.subZone = ""
	self.timestamp = ""
	self.alive = false
	self.level = 0
	self.classification = ""
	self.class = ""
	self.type = ""
	self.family = ""
	self.race = ""
	self.health = 0
	self.mana = 0
	self.reaction = 1
	self.positionX = 0
	self.positionY = 0
	self.loot = RaresLoot:new()
	return self
end

function RaresRare:SetName(v) self.name = v end
function RaresRare:GetName() return self.name end

function RaresRare:SetZone(v) self.zone = v end
function RaresRare:GetZone() return self.zone end

function RaresRare:SetSubZone(v) self.subZone = v end
function RaresRare:GetSubZone() return self.subZone end

function RaresRare:SetTimestamp(v) self.timestamp = v end
function RaresRare:GetTimestamp() return self.timestamp end

function RaresRare:SetAlive(v) self.alive = v end
function RaresRare:IsAlive() return self.alive end

function RaresRare:SetLevel(v) self.level = v end
function RaresRare:GetLevel() return self.level end

function RaresRare:SetClassification(v) self.classification = v end
function RaresRare:GetClassification() return self.classification end

function RaresRare:GetDBClassification()
	if self.classification ~= nil and self.classification == "worldboss" then
		return "WB"
	elseif self.classification ~= nil and self.classification == "rareelite" then
		return "RE"
	elseif self.classification ~= nil and self.classification == "elite" then
		return "E"
	elseif self.classification ~= nil and self.classification == "rare" then
		return "R"
	else
		return ""
	end
end
function RaresRare:SetDBClassification(v)
	if v == "WB" then
		self.classification = "worldboss"
	elseif v == "RE" then
		self.classification = "rareelite"
	elseif v == "E" then
		self.classification = "elite"
	elseif v == "R" then
		self.classification = "rare"
	else
		return ""
	end
end

function RaresRare:SetClass(v) self.class = v end
function RaresRare:GetClass() return self.class end

function RaresRare:SetType(v) self.type = v end
function RaresRare:GetType() return self.type end

function RaresRare:SetFamily(v) self.family = v end
function RaresRare:GetFamily() return self.family end

function RaresRare:SetRace(v) self.race = v end
function RaresRare:GetRace() return self.race end

function RaresRare:GetDBType()
	local ret = ""
	if self.type ~= nil and self.type == "Beast" then
		if self.family ~= nil and self.family ~= "" then
			return self.family.." ("..self.type..")"
		else
			return self.family
		end
	elseif self.type ~= nil and self.type == "Humanoid" then
		if self.race ~= nil and self.race ~= "" then
			return self.type.." ("..self.race..")"
		else
			return self.type
		end
	else
		return ""
	end
end

function RaresRare:SetHealth(v) self.health = v end
function RaresRare:GetHealth() return self.health end

function RaresRare:SetMana(v) self.mana = v end
function RaresRare:GetMana() return self.mana end

function RaresRare:SetReaction(v) self.reaction = v end
function RaresRare:GetReaction() return self.reaction end

function RaresRare:SetPositionX(v) self.positionX = v end
function RaresRare:GetPositionX() return self.positionX end

function RaresRare:SetPositionY(v) self.positionY = v end
function RaresRare:GetPositionY() return self.positionY end

--[[
	---------------------------- RaresLoot model ----------------------------
--]]

RaresLoot = {}
RaresLoot.__index = RaresLoot

function RaresLoot:new()
	local self = setmetatable({}, RaresLoot)
	self.name = ""
	self.link = ""
	self.icon = ""
	self.quantity = 0
	self.rarity = 0
	return self
end

function RaresLoot:SetName(v) self.name = v end
function RaresLoot:GetName() return self.name end

function RaresLoot:SetLink(v) self.link = v end
function RaresLoot:GetLink() return self.link end

function RaresLoot:SetIcon(v) self.icon = v end
function RaresLoot:GetIcon() return self.icon end

function RaresLoot:SetQuantity(v) self.quantity = v end
function RaresLoot:GetQuantity() return self.quantity end

function RaresLoot:SetRarity(v) self.rarity = v end
function RaresLoot:GetRarity() return self.rarity end

--[[
	---------------------------- RaresColor model ----------------------------
--]]

RaresColor = {}
RaresColor.__index = RaresColor

function RaresColor:new()
	local self = setmetatable({}, RaresColor)
	self.R = 1
	self.G = 1
	self.B = 1
	self.HEX = "|cffffffff"
	return self
end

function RaresColor:Set(name)
	local index = 1
	if("POOR" == string.upper(name)) then
		index = 0
	elseif("COMMON" == string.upper(name)) then
		index = 1
	elseif("UNCOMMON" == string.upper(name)) then
		index = 2
	elseif("RARE" == string.upper(name)) then
		index = 3
	elseif("EPIC" == string.upper(name)) then
		index = 4
	elseif("LEGENDARY" == string.upper(name)) then
		index = 5
	end
	self.R, self.G, self.B, self.HEX = GetItemQualityColor(index)
end

function RaresColor:GetRGB(name)
	local index = 1
	local r, g, b
	if("POOR" == string.upper(name)) then
		index = 0
	elseif("COMMON" == string.upper(name)) then
		index = 1
	elseif("UNCOMMON" == string.upper(name)) then
		index = 2
	elseif("RARE" == string.upper(name)) then
		index = 3
	elseif("EPIC" == string.upper(name)) then
		index = 4
	elseif("LEGENDARY" == string.upper(name)) then
		index = 5
	end
	r, g, b, _ = GetItemQualityColor(index)
	return r, g, b
end

function RaresColor:GetHex(name)
	local index = 1
	local hex
	if("POOR" == string.upper(name)) then
		index = 0
	elseif("COMMON" == string.upper(name)) then
		index = 1
	elseif("UNCOMMON" == string.upper(name)) then
		index = 2
	elseif("RARE" == string.upper(name)) then
		index = 3
	elseif("EPIC" == string.upper(name)) then
		index = 4
	elseif("LEGENDARY" == string.upper(name)) then
		index = 5
	end
	_, _, _, hex = GetItemQualityColor(index)
	return hex
end
