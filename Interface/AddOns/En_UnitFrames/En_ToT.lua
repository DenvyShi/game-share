-- 设置 (true 改为 false 则关闭相应功能)
local EUF_OTWarning = true		  -- 开启 OT 报警
local EUF_TOTDisplay = true		  -- 开启 目标的目标 显示

function EUF_ToT_OnLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function EUF_ToT_OnEvent(event)
	if event == "PLAYER_ENTERING_WORLD" and EUF_TOTDisplay then
		SHOW_TARGET_OF_TARGET = "1"
	end
	if event == "PLAYER_TARGET_CHANGED" then
		EUF_OTSound_Play = 0
		if EUF_OTWarning then
			EUF_OT_Warning()
		end
	end
end

-- OT 警报
function EUF_OT_Warning()
	if ( GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 ) then
		if (UnitIsUnit("player", "targettarget") and UnitCanAttack("target", "player")) or (UnitIsUnit("player", "targettargettarget") and UnitCanAttack("targettarget", "player")) then
			if EUF_OTSound_Play ~= 1 then
				PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav")
				EUF_OTSound_Play = 1
			end
		else
			EUF_OTSound_Play = 0
		end
	end
end

--目标的目标的血量
local En_ToTPercenr = CreateFrame("Frame", nil, UIParent)
En_ToTPercenr:CreateFontString("EUF_TargetofTargetHPPercenr", "ARTWORK", "TextStatusBarText")
EUF_TargetofTargetHPPercenr:SetPoint("CENTER", TargetofTargetHealthBar, "CENTER", 0, 5)
En_ToTPercenr:SetFrameStrata("LOW")

function EUF_ToTHPPercenr_Display()
	local curHP = UnitHealth("targettarget");
	local maxHP = UnitHealthMax("targettarget");
	local percent = math.floor(curHP * 100 / maxHP);
	if 0 < percent and percent < 100 then		
		EUF_TargetofTargetHPPercenr:SetText(percent .. "%")
	else
		EUF_TargetofTargetHPPercenr:SetText("")
	end
end

function EUF_ToT_OnUpdate()
	if TargetofTargetFrame:IsShown() then
		En_ToTPercenr:Show()
		EUF_ToTHPPercenr_Display()
	else
		En_ToTPercenr:Hide()
	end
end

hooksecurefunc("TargetofTarget_Update", EUF_ToT_OnUpdate, true)