local dir = "Interface\\TargetingFrame\\"
local En_TarHpText, En_TarMpText, CombatFlash

function TargetFrame_CheckDead()
	if UnitIsConnected("target") then
		if UnitIsDeadOrGhost("target") then
			TargetDeadText:Show()
			TargetDeadText:SetText("死亡")
		else
			TargetDeadText:Hide()
		end
	else
		TargetDeadText:Show()
		TargetDeadText:SetText("离线")		
	end
end

--宽血条美化
function En_UFI_Frame()
	--蓝条颜色
	ManaBarColor[0] = { r = 0, g = 0.47, b = 1, prefix = TEXT(MANA) }

	TargetFrame:SetFrameStrata("BACKGROUND")
	PlayerFrameTexture:SetTexture(dir.."UI-TargetingFrame.blp")
    PlayerStatusTexture:SetTexture(dir.."UI-Player-Status.blp")

	PlayerFrameHealthBar:ClearAllPoints()
	PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -24)
	PlayerFrameHealthBar:SetPoint("BOTTOMRIGHT", -6, 49)
	TargetFrameHealthBar:ClearAllPoints()
	TargetFrameHealthBar:SetPoint("TOPRIGHT", -106, -24)
	TargetFrameHealthBar:SetPoint("BOTTOMLEFT", 6, 49)
	
	if PlayerFrameBackground and PlayerFrameBackground.bg then PlayerFrameBackground.bg:Hide() end
	TargetFrameNameBackground:Hide()
	
	--玩家
	--姓名	
	PlayerName:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
	PlayerName:ClearAllPoints()
	PlayerName:SetPoint("CENTER", "PlayerFrameTexture", "CENTER", 50, 25)
	--血条数值
	PlayerFrameHealthBarText:ClearAllPoints()
	PlayerFrameHealthBarText:SetPoint("CENTER", "PlayerFrameHealthBar", "CENTER", 0, -5)
	
	--目标
	--姓名
	TargetName:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
	TargetName:ClearAllPoints()
	TargetName:SetPoint("CENTER", "TargetFrameTexture", "CENTER", -50, 25)
	
	TargetDeadText:ClearAllPoints()
	TargetDeadText:SetPoint("CENTER", "TargetFrameHealthBar", "CENTER", 0, -5)
	
	TargetFrame.StatusTexts = CreateFrame("Frame", nil, TargetFrame)
	TargetFrame.StatusTexts:SetAllPoints(TargetFrame)
	
	local _, fontSize = PlayerFrameHealthBarText:GetFont()
	-- 血量
	TargetFrameHealthBar.TextString = TargetFrame.StatusTexts:CreateFontString("TargetFrameHealthBarText", "OVERLAY")
	TargetFrameHealthBar.TextString:SetPoint("CENTER", "TargetFrameHealthBar", "CENTER", 0, -5)
	TargetFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
	-- 蓝量
	TargetFrameManaBar.TextString = TargetFrame.StatusTexts:CreateFontString("TargetFrameManaBarText", "OVERLAY")
	TargetFrameManaBar.TextString:SetPoint("CENTER", "TargetFrameManaBar", "CENTER", 0, 0)
	TargetFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
  
	--宠物
	PetName:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	PetFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
	PetFrameManaBarText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

	--目标战斗状态
	CombatFlash = this:CreateTexture(nil, ARTWORK)
	CombatFlash:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
	CombatFlash:SetTexCoord(0.5, 1, 0, 0.5)
	CombatFlash:SetWidth(28)
	CombatFlash:SetHeight(28)
	CombatFlash:SetPoint("CENTER", "TargetFrame", "BOTTOMRIGHT", -52, 35)
end

--覆盖StatusBar的文字信息显示
local HookTextStatusBar_UpdateTextString = TextStatusBar_UpdateTextString
function TextStatusBar_UpdateTextString(sb)
	if not sb then sb = this end

	HookTextStatusBar_UpdateTextString(sb)
	local string = sb.TextString

	if string and sb.unit then
		sb.lockShow = 42
		sb:Show()

		local min, max = sb:GetMinMaxValues()
		local cur = sb:GetValue()
		local percent = max > 0 and floor(cur/max*100) or 0

		if sb:GetName() == "TargetFrameHealthBar" then
			if MobHealthFrame then
				cur, max = MobHealth3:GetUnitHealth(sb.unit, UnitHealth(sb.unit), UnitHealthMax(sb.unit))
			end
		end

		if (sb.unit == "player" or sb.unit == "target") and strfind(sb:GetName(), "Health") then
			string:SetText(not UnitIsDeadOrGhost(sb.unit) and (Over1E3toK(cur) .. " - " .. percent .. "%") or "")
		else
			string:SetText(Over1E3toK(cur))
		end

		if En_HideText then
			string:Hide()
			string:SetText("")
		else
			string:Show()
		end
	end
end

for i=1, 4 do
	local frame = _G["PartyMemberFrame"..i]
	local healthbar = _G["PartyMemberFrame"..i.."HealthBar"]
	local manabar = _G["PartyMemberFrame"..i.."ManaBar"]

	frame.StatusTexts = CreateFrame("Frame", nil, frame)
	frame.StatusTexts:SetFrameStrata("MEDIUM")
	frame.StatusTexts:SetAllPoints(frame)

	healthbar.TextString = frame.StatusTexts:CreateFontString("PartyMemberFrame"..i.."HealthBarText", "OVERLAY")
	healthbar.TextString:SetPoint("CENTER", healthbar, "CENTER", 0, 2)
	healthbar.TextString:SetFontObject("GameFontWhite")
	healthbar.TextString:SetFont(STANDARD_TEXT_FONT, 12.5, "OUTLINE")
	healthbar.TextString:SetDrawLayer("OVERLAY")

	manabar.TextString = frame.StatusTexts:CreateFontString("PartyMemberFrame"..i.."ManaBarText", "OVERLAY")
	manabar.TextString:SetPoint("CENTER", manabar, "CENTER", 0, 0)
	manabar.TextString:SetFontObject("GameFontWhite")
	manabar.TextString:SetFont(STANDARD_TEXT_FONT, 12.5, "OUTLINE")
	manabar.TextString:SetDrawLayer("OVERLAY")
		
	TextStatusBar_UpdateTextString(healthbar)
	TextStatusBar_UpdateTextString(manabar)
end
  
--PVP图标
PlayerPVPIcon:ClearAllPoints()
PlayerPVPIcon:SetPoint("TOPLEFT", "PlayerFrame", 23, -20)
for i = 1, 4 do getglobal("PartyMemberFrame"..i.."PVPIcon"):Hide() end
PartyMemberFrame_UpdatePvPStatus = function() end

--目标头目等级框架
function TargetFrame_CheckClassification()
	local classification = UnitClassification"target"
	if classification == "worldboss" or classification == "elite" then
		TargetFrameTexture:SetTexture(dir.."UI-TargetingFrame-Elite.blp")
	elseif classification == "rareelite" then
		TargetFrameTexture:SetTexture(dir.."UI-TargetingFrame-Rare-Elite.blp")
	elseif classification == "rare" then
		TargetFrameTexture:SetTexture(dir.."UI-TargetingFrame-Rare.blp")
	else
		TargetFrameTexture:SetTexture(dir.."UI-TargetingFrame.blp")
	end
end

-- 宠物姓名根据宠物高兴状态染色
local PetHappinessColors = {
	[1] = {1, 0, 0},
	[2] = {1, 1, 0},
	[3] = {0, 1, 0},
}

function En_PetNameColor()
	local hasPetUI, isHunterPet = HasPetUI()
	local happiness = GetPetHappiness()	
	if isHunterPet and happiness then
		PetFrameHappiness:Hide()
		PetName:SetTextColor(PetHappinessColors[happiness][1], PetHappinessColors[happiness][2], PetHappinessColors[happiness][3])
	else
		return
	end
end
hooksecurefunc("PetFrame_SetHappiness", En_PetNameColor, true)

function En_HealthBar_OnValueChanged(value, smooth)
	if not value then return end

	if this == PlayerFrameHealthBar then 
		this:SetStatusBarColor(UnitColor("player"))
	elseif this == TargetFrameHealthBar then 
		this:SetStatusBarColor(UnitColor("target"))
	end
end
hooksecurefunc("HealthBar_OnValueChanged", En_HealthBar_OnValueChanged, true)

local En_UFIFrame = CreateFrame("Frame", nil, UIParent)
En_UFIFrame:RegisterEvent("ADDON_LOADED")

En_UFIFrame:SetScript("OnEvent", function()
	if arg1 == "En_UnitFrames" then
		En_UFI_Frame()
	end
end)

local function Update_En_UFIText()
	if TargetFrame:IsVisible() and UnitAffectingCombat("target") == 1 then
		local time = GetTime()
		local x = (tonumber(string.format("%0.1f",  math.mod(time, 1))))*10
		local alpha = math.sin(x/1.5+1)/2+0.5
		CombatFlash:Show()
		CombatFlash:SetAlpha(alpha)
	else
		CombatFlash:Hide()
	end 
end

En_UFIFrame:SetScript("OnUpdate", Update_En_UFIText)