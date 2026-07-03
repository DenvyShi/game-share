--[[
Name:			Rares
Author:			nulajedan
Version:		0.6.3
Description:	Rare npcs scanner and tracker
--]]

--[[
	Rares.lua
--]]

local IMG_RADAR = "Interface\\AddOns\\Rares\\img\\RaresRadar"
local IMG_ALIVE = "Interface\\AddOns\\Rares\\img\\RaresAlive"
local IMG_DEAD = "Interface\\AddOns\\Rares\\img\\RaresDead"
local IMG_HIGHLIGHT = "Interface\\AddOns\\Rares\\img\\RaresHighlight"
local SFX_ALIVE = "Interface\\AddOns\\Rares\\sfx\\gruntling_horn_bb.ogg"
local SFX_DEAD = "Interface\\AddOns\\Rares\\sfx\\scourge_horn.ogg"
local CHAT_LOG = RaresColor:GetHex("RARE").."[Rares]|r "
local ERROR_TIME = 5

local L = AceLibrary("AceLocale-2.0"):new("Rares")

Rares = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0")

function Rares:OnInitialize()
	self:RegisterDB("RaresDB")
	self.dbDefaults = {
		rares = RaresDatabaseDefaults,
		settings = {
			buttonAnchor = "CENTER",
			buttonPosX = 0,
			buttonPosY = 0,
			buttonLock = false,
			buttonShow = true,
			tooltipAnchor = "ANCHOR_LEFT",
			modelShow = true,
		}
	}
	self:RegisterDefaults("profile", self.dbDefaults)
	self:InitSlashCommands()
	self.author = "nulajedan"
	self.version = "0.6.3"
	self.checkTime = 0
	self.checkInterval = 1
	self.seen = {}
	self.lastTarget = ""
	self.lastTargetAlive = false
	self.lastTargetTime = 0
	self.tooltipPage = 0
	self.cartDB = {}
end

function Rares:OnEnable()
	self:Log(string.format(" v%s %s", self.version, L["loaded"]))
	RaresRadarButton:RegisterForDrag("LeftButton")
	self:RaresRadarReset()
	RaresRadarButton.isMoving = false
	self:ApplySettings()
	if Cartographer_Notes then
		Cartographer_Notes:RegisterIcon("RaresCartIcon", {text = L["rareNpc"], path = "Interface\\Addons\\Rares\\img\\RaresSkull", width = 12, height = 12})
		Cartographer_Notes:RegisterNotesDatabase("RaresCartDB", self.cartDB, Rares)
	end
	self:SetAllCartNotes()
	self:RegisterEvent("LOOT_OPENED", "Loot")
end

function Rares:OnDisable()
	self:UnregisterAllEvents()
	if Cartographer_Notes then
		Cartographer_Notes:UnregisterIcon("RaresCartIcon")
		Cartographer_Notes:UnregisterNotesDatabase("Rares")
	end
end

function Rares:InitSlashCommands()
	local db = self.db.profile
	self.slashCmd = {
		type = "group",
		args = {
			buttonLock = {
				type = "toggle",
				name = L["nameButtonLock"],
				desc = L["descButtonLock"],
				get = function() return db.settings.buttonLock end,
				set = function(v)
					db.settings.buttonLock = v
					self:ApplySettings()
				end,
				order = 1,
			},
			buttonShow = {
				type = "toggle",
				name = L["nameButtonShow"],
				desc = L["descButtonShow"],
				get = function() return db.settings.buttonShow end,
				set = function(v)
					db.settings.buttonShow = v
					self:ApplySettings()
				end,
				order = 2,
			},
			tooltipAnchor = {
				type = "execute",
				name = L["nameTooltipAnchor"],
				desc = L["descTooltipAnchor"],
				func = function()
					if db.settings.tooltipAnchor == "ANCHOR_LEFT" then
						db.settings.tooltipAnchor = "ANCHOR_RIGHT"
						self:Log(L["tooltipAnchorRight"])
					else
						db.settings.tooltipAnchor = "ANCHOR_LEFT"
						self:Log(L["tooltipAnchorLeft"])
					end
				end,
				order = 3,
			},
			modelShow = {
				type = "toggle",
				name = L["nameModelShow"],
				desc = L["descModelShow"],
				get = function() return db.settings.modelShow end,
				set = function(v)
					db.settings.modelShow = v
					self:ApplySettings()
				end,
				order = 4,
			},
		}
	}
	self:RegisterChatCommand({"/rares"}, self.slashCmd)
end

function Rares:OnMouseDown(arg1)
	local db = self.db.profile
	if arg1 == "RightButton" and self.lastTarget ~= "" and db.settings.buttonShow then
		self:RaresRadarReset()
	elseif arg1 == "LeftButton" and self.lastTarget ~= "" and db.settings.buttonShow then
		TargetByName(self.lastTarget, true)
	end
	RaresRadarButton:StopMovingOrSizing()
	RaresRadarButton.isMoving = false
end

function Rares:OnDragStart()
	local db = self.db.profile
	if arg1 == "LeftButton" and RaresRadarButton:IsMovable() and db.settings.buttonShow then
		RaresRadarButton:StartMoving()
		RaresRadarButton.isMoving = true
		RaresInfoFrame:SetBackdrop({bgFile = "Interface/TutorialFrame/TutorialFrameBackground", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 16, tileSize = 16, insets = {left = 3, right = 5, top = 3, bottom = 3}})
		local r, g, b = RaresColor:GetRGB("RARE")
		RaresInfoFrameButtonText:SetTextColor(r, g, b)
		RaresInfoFrameButtonText:SetText(string.format(L["raresFound"], self.version))
		RaresInfoFrameButtonText:Show()
		GameTooltip:Hide()
	end
end

function Rares:OnDragStop()
	local db = self.db.profile
	if RaresRadarButton:IsMovable() and db.settings.buttonShow then
		RaresRadarButton:StopMovingOrSizing()
		RaresRadarButton.isMoving = false
		db.settings.buttonAnchor, _, db.settings.buttonAnchor, db.settings.buttonPosX, db.settings.buttonPosY = RaresRadarButton:GetPoint()
		RaresInfoFrame:SetBackdrop(nil)
		RaresInfoFrameButtonText:SetText("")
		RaresInfoFrameButtonText:Hide()
	end
end

function Rares:Loot()
	local unitName = UnitName("target")
	if self:IsTargetRare(unitName) then
		for i = 1, GetNumLootItems() do
			if LootSlotIsItem(i) then
				local loot = RaresLoot:new()
				local icon, name, quantity, rarity, _ = GetLootSlotInfo(i)
				loot:SetIcon(icon)
				loot:SetName(name)
				loot:SetQuantity(quantity)
				loot:SetRarity(rarity)
				loot:SetLink(GetLootSlotLink(i))
				self:UpdateDatabaseWithLoot(GetRealZoneText(), unitName, loot)
			end
		end
	end
end

function Rares:ShowTooltip()
	local db = self.db.profile
	if db.settings.buttonShow then
		local zone = GetRealZoneText()
		local db = self.db.profile
		GameTooltip:SetOwner(RaresRadarButton, db.settings.tooltipAnchor);
		local r, g, b = RaresColor:GetRGB("RARE")
		if db.rares[zone] ~= nil then
			local start = 1
			local raresTotal = self:TableSize(db.rares[zone])
			local page = ""
			if raresTotal >20 and self.tooltipPage == 0 then
				self.tooltipPage = 1
				page = string.format(L["zoneRaresTotalPage"], self.tooltipPage)
			elseif raresTotal > 29 and self.tooltipPage == 1 then
				start = 30
				self.tooltipPage = 2
				page = string.format(L["zoneRaresTotalPage"], self.tooltipPage)
			end
			GameTooltip:AddLine(string.format(L["zoneRaresTotal"], self:TableSize(db.rares[zone]), zone, page), r, g, b, false)
			local i = 1
			for rareName, rareMeta in self:SortTable(db.rares[zone]) do
				if i >= start then
					local color = RaresColor:new()
					local line = string.format(L["tooltipRareLine1"], i, rareMeta["LV"], rareMeta["CL"], rareName, rareMeta["ST"])
					if rareMeta["TS"] ~= "" then
						line = line..string.format(L["tooltipRareLine2"], rareMeta["TS"])
					end
					if rareMeta["SZ"] ~= "" then
						line = line..string.format(L["tooltipRareLine3"], rareMeta["SZ"])
					end
					if rareMeta["ST"] > 0 then color:Set("UNCOMMON") end
					GameTooltip:AddLine(line, color.R, color.G, color.B, false);
				end
				i = i + 1
			end
		else
			GameTooltip:AddLine(string.format(L["noRaresInZone"], zone), r, g, b, false)
		end
		GameTooltip:Show()
	end
end

function Rares:HideTooltip()
	local db = self.db.profile
	if db.settings.buttonShow then
		if self.tooltipPage == 2 then self.tooltipPage = 0 end
		GameTooltip:Hide()
	end
end

function Rares:OnUpdate()
	if GetTime() - self.checkTime >= self.checkInterval then
		self.checkTime = GetTime()
		self:Scan(GetRealZoneText())
	end
end

function Rares:ApplySettings()
	local db = self.db.profile
	if db.settings.buttonShow then
		RaresRadarButton:SetPoint(db.settings.buttonAnchor, "UIParent", db.settings.buttonAnchor, db.settings.buttonPosX, db.settings.buttonPosY)
		if db.settings.buttonLock then RaresRadarButton:SetMovable(false) else RaresRadarButton:SetMovable(true) end
		local tx = IMG_RADAR
		local color = RaresColor:new()
		local txt
		local rare = self:GetRareByName(self.lastTarget)
		if self.lastTarget ~= "" then
			txt = "L"..rare["LV"]..rare["CL"].." "
			if self.lastTargetAlive then
				tx = IMG_ALIVE
				txt = txt..string.format(L["rareFoundAlive"], self.lastTarget)
				color:Set("UNCOMMON")
			elseif not self.lastTargetAlive then
				tx = IMG_DEAD
				txt = txt..string.format(L["rareFoundDead"], self.lastTarget)
			end
			RaresInfoFrameButtonText:SetTextColor(color.R, color.G, color.B)
			RaresInfoFrameButtonText:SetText(txt)
		end
		RaresRadarButton:SetNormalTexture(tx)
		RaresRadarButton:SetHighlightTexture(IMG_HIGHLIGHT)
		RaresInfoFrame:Show()
	else
		RaresRadarButton:SetNormalTexture(nil)
		RaresRadarButton:SetHighlightTexture(nil)
		RaresInfoFrame:Hide()
	end
end

function Rares:GetRareByName(name)
	if name == nil or name == "" then return nil end
	local db = self.db.profile
	for _, rares in pairs(db.rares) do
		for k, v in pairs(rares) do
			if k == name then return v end
		end
	end
	return nil
end

function Rares:Scan(zone)
	local db = self.db.profile
	if db.rares[zone] ~= nil and not UnitOnTaxi("player") then
		for name, _ in pairs(db.rares[zone]) do
			local rare = Rares:Target(name)
			if rare ~= nil then
				local msg = L["rareFoundAlive"]
				if rare:IsAlive() then
					PlaySoundFile(SFX_ALIVE)
				else
					msg = L["rareFoundDead"]
					PlaySoundFile(SFX_DEAD)
				end
				self:Error(string.format(msg, name), alive)
				self:UpdateDatabase(rare)
				self:SetCartNote(rare)
				if db.settings.buttonShow then self:RaresRadarAlert(rare) end
				break
			end
		end
	end
end

function Rares:Target(name)
	local rare = nil
	if self.seen[name] == nil then
		local errFunc = UIErrorsFrame.AddMessage
		UIErrorsFrame.AddMessage = function() end
		TargetByName(name, true)
		UIErrorsFrame.AddMessage = errFunc
		if UnitName("target") and UnitName("target") == name then
			rare = self:GetTargetData(name)
			self.seen[name] = true
			self.lastTarget = name
			self.lastTargetAlive = alive
		end
	end
	return rare
end

function Rares:GetTargetData(name)
	rare = RaresRare:new()
	rare:SetName(name)
	rare:SetZone(GetRealZoneText())
	rare:SetSubZone(GetSubZoneText())
	rare:SetTimestamp(date("%d.%m.%Y. %X"))
	rare:SetAlive(not UnitIsDead("target"))
	rare:SetLevel(UnitLevel("target"))
	rare:SetClassification(UnitClassification("target"))
	local class, _ = UnitClass("target")
	rare:SetClass(class)
	rare:SetType(UnitCreatureType("target"))
	rare:SetFamily(UnitCreatureFamily("target"))
	local race, _ = UnitRace("target")
	if race == nil then race = "" end
	rare:SetRace(race)
	local health, mana = 0, 0
	if not UnitAffectingCombat("target") then
		health = UnitHealth("target")
		mana = UnitMana("target")
	end
	rare:SetHealth(health)
	rare:SetMana(mana)
	rare:SetReaction(UnitReaction("target", "player"))
	local posx, posy = GetPlayerMapPosition("player")
	rare:SetPositionX(posx)
	rare:SetPositionY(posy)
	return rare
end

function Rares:UpdateDatabase(rare)
	local rareDB = self.db.profile.rares[rare:GetZone()][rare:GetName()]
	rareDB["ST"] = rareDB["ST"] + 1
	rareDB["SZ"] = rare:GetSubZone()
	rareDB["TS"] = rare:GetTimestamp()
	rareDB["LV"] = rare:GetLevel()
	rareDB["CL"] = rare:GetDBClassification()
	rareDB["UC"] = rare:GetClass()
	rareDB["TY"] = rare:GetDBType()
	if rare:GetHealth() ~= 0 and rare:GetHealth() ~= 100 then rareDB["HP"] = rare:GetHealth() end
	rareDB["MP"] = rare:GetMana()
	rareDB["RE"] = rare:GetReaction()
	rareDB["PX"] = rare:GetPositionX()
	rareDB["PY"] = rare:GetPositionY()
end

function Rares:UpdateDatabaseWithLoot(zone, name, loot)
	local rare = self.db.profile.rares[zone][name]
	if rare["LO"] == nil then rare["LO"] = {} end
	table.insert(rare["LO"], loot)
end

function Rares:SetCartNote(rare)
	if Cartographer_Notes and not self:IsZoneDungeon(rare:GetZone()) then
		local hex1, hex2 = RaresColor:GetHex("UNCOMMON"), RaresColor:GetHex("RARE")
		Cartographer_Notes:SetNote(rare:GetZone(), rare:GetPositionX(), rare:GetPositionY(), "RaresCartIcon", "Rares", "title", string.format(L["cartNote"], hex1, rare:GetLevel(), rare:GetDBClassification(), hex2, rare:GetName()))
	end
end

function Rares:SetAllCartNotes()
	local db = self.db.profile
	for zone, v in pairs(db.rares) do
		for name, rareMeta in pairs(v) do
			local rare = RaresRare:new()
			rare:SetName(name)
			rare:SetZone(zone)
			rare:SetLevel(rareMeta["LV"])
			rare:SetDBClassification(rareMeta["CL"])
			rare:SetPositionX(rareMeta["PX"])
			rare:SetPositionY(rareMeta["PY"])
			if rareMeta["PX"] ~= 0 and rareMeta["PY"] ~= 0 and not self:IsZoneDungeon(zone) then
				self:SetCartNote(rare)
			end
		end
	end
end

function Rares:IsZoneDungeon(zone)
	for _, v in pairs(RaresDatabaseDungeons) do
		if v == zone then return true end
	end
	return false
end

function Rares:IsTargetRare(name)
	for _, rares in pairs(RaresDatabaseDefaults) do
		for k, _ in pairs(rares) do
			if k == name then return true end
		end
	end
	return false
end

function Rares:RaresRadarAlert(rare)
	local color = RaresColor:new()
	local tx = IMG_ALIVE
	local txt = "L"..rare:GetLevel()..rare:GetDBClassification().." "
	if rare:IsAlive() then
		txt = txt..string.format(L["rareFoundAlive"], rare:GetName())
		color:Set("UNCOMMON")
	else
		tx = IMG_DEAD
		txt = txt..string.format(L["rareFoundDead"], rare:GetName())
	end
	RaresRadarButton:SetNormalTexture(tx)
	RaresInfoFrameButtonText:SetTextColor(color.R, color.G, color.B)
	RaresInfoFrameButtonText:SetText(txt)
	RaresInfoFrameButtonText:Show()
	UIFrameFlash(RaresRadarButton, 0.5, 0.3, 5, true, 0.2, 0)
	self:ModelShow()
end

function Rares:RaresRadarReset()
	self.lastTarget = ""
	RaresRadarButton:SetNormalTexture(IMG_RADAR)
	RaresInfoFrameButtonText:SetText("")
	RaresInfoFrameButtonText:Hide()
	self:ModelHide()
end

function Rares:ModelShow()
	local db = self.db.profile
	if db.settings.modelShow then
		RaresModelFrame:Show()
		RaresModelFrameBackground:Show()
		UIFrameFlash(RaresModelFrameBackground, 0.5, 0.3, 5, false, 0.2, 0)
		RaresModelFrame3D:SetAlpha(1)
		RaresModelFrame3D:SetFacing(2)
		RaresModelFrame3D:SetModelScale(0.75)
		RaresModelFrame3D:SetUnit("target")
		RaresModelFrame3D:Show()
	end
end

function Rares:ModelOnUpdate()
	local db = self.db.profile
	if db.settings.modelShow and RaresModelFrame3D:IsVisible() then
		RaresModelFrame3D:SetFacing(RaresModelFrame3D:GetFacing() + (GetTime() - self.lastTargetTime) * math.pi / 4)
		self.lastTargetTime = GetTime()
	end
end

function Rares:ModelHide()
	RaresModelFrame:Hide()
	RaresModelFrameBackground:Hide()
	RaresModelFrame3D:SetAlpha(0)
	RaresModelFrame3D:SetFacing(0)
	RaresModelFrame3D:SetModelScale(1)
	RaresModelFrame3D:ClearModel()
	RaresModelFrame3D:Hide()
end

function Rares:Log(msg)
	if msg ~= "" then
		DEFAULT_CHAT_FRAME:AddMessage(CHAT_LOG..msg)
	end
end

function Rares:Error(msg, alive)
	if msg ~= "" then
		local color = RaresColor:new()
		if alive then color:Set("UNCOMMON") end
		UIErrorsFrame:AddMessage(msg, color.R, color.G, color.B, 1, ERROR_TIME)
	end
end

function Rares:TableSize(tbl)
	local s = 0
	for _, _ in pairs(tbl) do s = s + 1 end
	return s
end

function Rares:SortTable(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end
