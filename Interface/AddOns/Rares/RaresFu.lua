--[[
	RaresFu.lua
--]]

if not IsAddOnLoaded("Fubar") then return end

local FU_TEXT = RaresColor:GetHex("RARE").."Rares|r"

local L = AceLibrary("AceLocale-2.0"):new("Rares")
local Tablet = AceLibrary("Tablet-2.0")

RaresFu = AceLibrary("AceAddon-2.0"):new("FuBarPlugin-2.0", "AceEvent-2.0")
RaresFu.hasIcon = "Interface\\AddOns\\Rares\\img\\RaresSkull"

function RaresFu:OnInitialize()
	local db = Rares.db.profile
	self.OnMenuRequest = {
		type = "group",
		args = {
			buttonLock = {
				type = "toggle",
				name = L["nameButtonLock"],
				desc = L["descButtonLock"],
				get = function() return db.settings.buttonLock end,
				set = function(v)
					db.settings.buttonLock = v
					Rares:ApplySettings()
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
					Rares:ApplySettings()
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
						Rares:Log(L["tooltipAnchorRight"])
					else
						db.settings.tooltipAnchor = "ANCHOR_LEFT"
						Rares:Log(L["tooltipAnchorLeft"])
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
					Rares:ApplySettings()
				end,
				order = 4,
			},
		}
	}
	self.title = "Rares"
	self.hasIcon = true
	self.defaultPosition = "LEFT"
	self.defaultMinimapPosition = 180
	self.independentProfile = false
end

function RaresFu:OnEnable()
	self:ShowIcon()
	self:SetIcon(true)
end

function RaresFu:OnTextUpdate()
	if self:IsTextShown() then
		self:SetText(FU_TEXT)
		self:ShowText()
	else
		self:HideText()
	end
end

function RaresFu:OnClick()
	if Rares.lastTarget ~= "" then
		TargetByName(Rares.lastTarget, true)
	end
end

function RaresFu:OnTooltipUpdate()
	local db = Rares.db.profile
	local zone = GetRealZoneText()
	local r, g, b = RaresColor:GetRGB("RARE")
	if db.rares[zone] ~= nil then
		Tablet:AddCategory():AddLine("text", string.format(L["zoneRaresTotal"], Rares:TableSize(db.rares[zone]), zone, ""), "textR", r, "textG", g, "textB", b, "justify", "CENTER" )
		local cat = Tablet:AddCategory()
		local i = 1
		for rareName, rareMeta in Rares:SortTable(db.rares[zone]) do
			local color = RaresColor:new()
			local r, g, b = RaresColor:GetRGB("COMMON")
			local text = string.format(L["tooltipFuRareLine1"], i, rareMeta["LV"], rareMeta["CL"], rareName)
			local text = text..string.format(L["tooltipFuRareLine2"], rareMeta["ST"])
			if rareMeta["ST"] > 0 then color:Set("UNCOMMON") end
			if rareMeta["TS"] ~= "" then
				text = text..string.format(L["tooltipFuRareLine3"], rareMeta["TS"])
			end
			if rareMeta["SZ"] ~= "" then
				text = text..string.format(L["tooltipFuRareLine4"], rareMeta["SZ"])
			end
			cat:AddLine("text", text, "textR", color.R, "textG", color.G, "textB", color.B, "justify", "LEFT" )
			i = i +1
		end
	else
		Tablet:AddCategory():AddLine("text", string.format(L["noRaresInZone"], zone), "textR", r, "textG", g, "textB", b, "justify", "CENTER" )
	end
	Tablet:SetHint(L["fubarHint"])
end
