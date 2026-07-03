En_FramesPoint = CreateFrame("Frame")
En_FramesPoint:RegisterEvent("VARIABLES_LOADED")
En_FramesPoint:SetScript("OnEvent", function() EUF_Frame_DefaultPoint() end)
PetFrame:SetFrameStrata("LOW")

--定位各个头像的位置
local _,_,_,x,y = PlayerFrame:GetPoint()

function EUF_Frame_DefaultPoint()
	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", -172, 240)
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("TOPLEFT","PlayerFrame","BOTTOMLEFT", x + 80, y + 30)
	PetFrameHealthBarText:ClearAllPoints()
	PetFrameHealthBarText:SetPoint("CENTER","PetFrameHealthBar","CENTER", 0, 2)
	PetFrameManaBarText:ClearAllPoints()
	PetFrameManaBarText:SetPoint("CENTER","PetFrameManaBar","CENTER", 0, -2)
	TargetFrame:ClearAllPoints()
	TargetFrame:SetPoint("LEFT", "PlayerFrame", "RIGHT", x + 130, y + 5)
	TargetofTargetFrame:ClearAllPoints()
	TargetofTargetFrame:SetPoint("TOPLEFT", "TargetFrame", "BOTTOM", x + 38, y + 32)
end

--移动框架,战斗状态禁止移动
local EN_moveFrames = {
	PlayerFrame,
	PetFrame,
	TargetFrame,
	TargetofTargetFrame,
	PartyMemberFrame1,
}

for _, frame in pairs(EN_moveFrames) do
	frame:SetMovable(true) frame:EnableMouse(true)
    frame:SetScript("OnDragStart", function() if IsAltKeyDown() and not UnitAffectingCombat("player") then this:StartMoving() end end)
	frame:SetScript("OnDragStop",  function() this:StopMovingOrSizing() end)
	frame:RegisterForDrag("LeftButton")
end

--重置框架、副本
UnitPopupButtons["Show_Frame_Num"] = { text = "|CFF00FFFF数值显示|R", dist = 0 }
UnitPopupButtons["ResetEn_FramePoint_FIX"] = { text = "|CFF00FFFF重置头像|R", dist = 0 }
UnitPopupButtons["RESET_INSTANCES_FIX"] = { text = "|CFF00FFFF重置副本|R", dist = 0 }

UnitPopupMenus["SELF"] = { "LOOT_METHOD", "LOOT_THRESHOLD", "LOOT_PROMOTE", "LEAVE", "RAID_TARGET_ICON", "Show_Frame_Num", "ResetEn_FramePoint_FIX","RESET_INSTANCES_FIX", "CANCEL" }

local En_HideTextFrame = {PlayerFrameHealthBarText, PlayerFrameManaBarText, TargetFrameHealthBarText, TargetFrameManaBarText}

local function En_HideFrameText()
	if not En_HideText then
		En_HideText = true
		for _, f in pairs(En_HideTextFrame) do
			f:Hide()
		end
	else
		En_HideText = false
		for _, f in pairs(En_HideTextFrame) do
			f:Show()
		end
	end
end

hooksecurefunc("UnitPopup_OnClick", function()
	local button = this.value
    if button == "RESET_INSTANCES_FIX" then
		StaticPopup_Show("CONFIRM_RESET_INSTANCES")
    elseif button == "ResetEn_FramePoint_FIX" then
		ResetEn_FramePoint(arg)
	elseif button == "Show_Frame_Num" then
		En_HideFrameTextStatic()
	end
end)

function ResetEn_FramePoint(arg)
  StaticPopupDialogs["ResetEn_FramePoint"] = {
	text = "是否重置所有头像位置？",
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		for _,frame in pairs(EN_moveFrames) do
			frame:SetUserPlaced(false)
			frame:ClearAllPoints()
		end
		if PlayerFrame:IsShown() then
			EUF_Frame_DefaultPoint()
		end
	end,
	timeout = 0,
	hideOnEscape = 1
  }
  StaticPopup_Show("ResetEn_FramePoint")
end

function En_HideFrameTextStatic(arg)
  StaticPopupDialogs["En_HideFrameTextStatic"] = {
	text = "是/否显示头像数值？",
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		En_HideFrameText()
		ReloadUI()
	end,
	timeout = 0,
	hideOnEscape = 1
  }
  StaticPopup_Show("En_HideFrameTextStatic")
end