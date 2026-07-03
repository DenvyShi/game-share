local DruidManaLib = AceLibrary("DruidManaLib-1.0")
local events = {"PLAYER_XP_UPDATE", "UPDATE_FACTION", "PLAYER_AURAS_CHANGED"}

function EUF_XPRP_OnLoad()
	for _,event in pairs(events) do
		this:RegisterEvent(event)
	end
end

--是否显示声望条
local function IsRpOn()
	local GetRpOn = GetWatchedFactionInfo()
	if GetRpOn then
		return true
	end
	return false
end

--德鲁伊蓝条判断
local function IsDruidMana()
	local class = select(2, UnitClass("player"))
	local powerType = UnitPowerType("player")
	if class == "DRUID" and powerType ~= 0 then
		return true
	end
	return false
end

--德鲁伊变形蓝条
function En_DriudManaBar()
	local curMana, maxMana = DruidManaLib:GetMana()
	XpRpBar:SetMinMaxValues(0, maxMana)
	XpRpBar:SetValue(curMana)
	XpRpText:SetText("|CFFFFFFFF"..Over1E3toK(curMana).."/"..Over1E3toK(maxMana))
	XpRpBar:SetStatusBarColor(0, 0, 1)
end

--声望、经验
function En_XPRP()
	local xp, xpmax = UnitXP("player"), UnitXPMax("player")
	local xp_perc = math.floor(xp / xpmax * 100)
	local xprest = GetXPExhaustion()
	if not xpmax or xpmax == 0 then xp_perc = 100 end

	local _, reaction, RpMin, RpMax, RpValue = GetWatchedFactionInfo()
	local color = FACTION_BAR_COLORS[reaction]
	RpValue = RpValue - RpMin
	RpMax = RpMax - RpMin
	RpMin = 0
	
	if IsRpOn() then
		XpRpBar:SetMinMaxValues(RpMin, RpMax)
		XpRpBar:SetValue(RpValue);
		XpRpText:SetText(string.format("%s/%s", Over1E3toK(RpValue), Over1E3toK(RpMax)));
		XpRpBar:SetStatusBarColor(color.r, color.g, color.b)
	else
		if UnitLevel("player") < 60 then
			XpRpBar:SetMinMaxValues(min(0, xp), xpmax)
			XpRpBar:SetValue(xp)
			if not xprest or xprest == 0 then
				XpRpText:SetText(string.format("%s/%s", Over1E3toK(xp), Over1E3toK(xpmax)))
				XpRpBar:SetStatusBarColor(0.58, 0, 0.55)
			else
				XpRpText:SetText(string.format("%s/%s", Over1E3toK(xp), Over1E3toK(xpmax)))
				XpRpBar:SetStatusBarColor(0, 0.39, 0.88)
			end
		end
	end
end

function EUF_XPRP_OnEvent(event)
	if IsDruidMana() then
		XpRp:SetScript("OnUpdate", En_DriudManaBar)
	--else
		--XpRp:SetScript("OnUpdate", nil)
		--En_XPRP()
	end

	--if UnitLevel("player") < 60 or IsRpOn() or IsDruidMana() then
	if IsRpOn() or IsDruidMana() then
		XpRpBar:Show()
		XpRpText:Show()
	else
		XpRpBar:Hide()
		XpRpText:Hide()
	end
end

function EUF_XPRP_OnEnter()
	for i=1, GetNumFactions() do
		local tipname, description, standingID, tipMin, tipMax, tipValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, isWatched = GetFactionInfo(i)
		tipMax = tipMax - tipMin
		tipValue = tipValue - tipMin
		tipMin = 0
		
		local tippct = (tipValue * 100) / tipMax
		local color = FACTION_BAR_COLORS[standingID]
		if not color then color = 1,1,1 end
		if isWatched then
			GameTooltip:ClearLines()
			GameTooltip_SetDefaultAnchor(GameTooltip, this)
			GameTooltip:AddLine(tipname .. " (" .. GetText("FACTION_STANDING_LABEL"..standingID, gender) .. ")", color.r + .3, color.g + .3, color.b + .3)
			if atWarWith == 1 then GameTooltip:AddLine("您与该派别正处于交战状态", 1, 0, 0) end
			GameTooltip:AddLine(description,nil,nil,nil,2)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("声望值："..string.format("%s/%s - %.1f%%", tipValue, tipMax, tippct))
		elseif not IsRpOn() then
			local xp, xpmax = UnitXP("player"), UnitXPMax("player")
			local xp_perc = math.floor(xp / xpmax * 100)
			local xprest = GetXPExhaustion()
			if not xpmax or xpmax == 0 then xp_perc = 100 end
			if not xprest or xprest == 0 then xprest = 0 end
			GameTooltip:ClearLines()
			GameTooltip_SetDefaultAnchor(GameTooltip, this)
			GameTooltip:AddDoubleLine("|cffffffff经验")
			GameTooltip:AddDoubleLine("经验值", "|cffffffff" .. xp .. " / " .. xpmax .. " - " .. xp_perc .. "%")
			GameTooltip:AddDoubleLine("双倍", "|cff00ff00+" .. xprest/2)
		end
		GameTooltip:Show()
	end
end