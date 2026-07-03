--[[
Enhanced Unit Frames�����for CWOW 11200
�ο� EUF����������޸İ棩��Ane_UnitBars,zUnitFrame,UnitFramesImproved,modui
nj55top, ��Ѫ�����2017.12.
]]

local events = {"UNIT_HEALTH", "UNIT_MANA", "UNIT_FOCUS", "UNIT_ENERGY", "UNIT_RAGE", "UPDATE_SHAPESHIFT_FORMS", "UNIT_LEVEL", "UNIT_DISPLAYPOWER", "PARTY_MEMBERS_CHANGED", "PLAYER_TARGET_CHANGED", "PLAYER_ENTERING_WORLD"}
		
function EUF_Frame_OnLoad()
	for i,event in pairs(events) do
		this:RegisterEvent(event)
	end	
end;

function EUF_Frame_OnEvent(event)
	if event == "UNIT_HEALTH" then
		EUF_HP_Update(arg1);
	elseif event == "UNIT_MANA" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY" or event == "UNIT_RAGE" or event == "UPDATE_SHAPESHIFT_FORMS" then
		EUF_MP_Update(arg1);
	elseif event == "UNIT_LEVEL" or event == "UNIT_DISPLAYPOWER" then
		EUF_HP_Update(arg1);
		EUF_MP_Update(arg1);
	elseif event == "PARTY_MEMBERS_CHANGED" then
		EUF_PartyFrameHPMP_Update();
		EUF_PartyFrameDisplay_Update();
	elseif event == "PLAYER_TARGET_CHANGED" then
		EUF_TargetFrameHPMP_Update();
	elseif event == "PLAYER_ENTERING_WORLD" then
		EUF_Frame_Update()
		SetCVar("statusBarText", 0, false)
	end;
end;

function EUF_HP_Update(unit)
	if not unit or (unit ~= "player" and unit~="target" and not string.find(unit, "^party%d$")) then
		return;
	end;
	local currValue = UnitHealth(unit);
	local maxValue = UnitHealthMax(unit);
	local percent = math.floor(currValue * 100 / maxValue);
	local digit = Over1E3toK(currValue)  .. "/" .. Over1E3toK(maxValue);
	
	if percent and percent <= 100 and percent >= 0 then
		percent = percent .. "%";
	else
		percent = "";
		digit = "";
	end;
	if unit == "target" and (UnitIsDead("target") or (MobHealth_GetTargetCurHP and UnitCanAttack("player", "target") and not UnitIsDead("target") and not UnitIsFriend("player", "target"))) then
		digit = "";
	end;
	
	local unitObj, unitPercentObj, unitId;
	if unit == "player" then
		unitPercentObj = EUF_PlayerFrameHPPercent;
	elseif unit == "target" then
		unitPercentObj = EUF_TargetFrameHPPercent;
	else
		unitId = string.sub(unit, -1);
		unitObj = getglobal("EUF_PartyFrame" .. unitId .. "HP");
	end;
	
	if unitObj then
		unitObj:SetText(digit);
	end;
	if unitPercentObj then
		unitPercentObj:SetText(percent);
	end;
end;

function EUF_MP_Update(unit)
	if not unit or (unit ~= "player" and unit~="target" and not string.find(unit, "^party%d$")) then
		return;
	end;
	local currValue = UnitMana(unit);
	local maxValue = UnitManaMax(unit);
	local percent = math.floor(currValue * 100 / maxValue);
	local digit = Over1E3toK(currValue)  .. "/" .. Over1E3toK(maxValue);
	
	if percent and maxValue ~= 0 then
		percent = percent .. "%";
	else
		percent = "";
		digit = "";
	end;
	if (unit == "target" and UnitPowerType("target")~= 0) or (unit == "player" and UnitPowerType("player")~= 0) then
		percent = "";
	end;
	local unitObj, unitPercentObj, unitId;
	if unit == "player" then
		unitPercentObj = EUF_PlayerFrameMPPercent;
	elseif unit == "target" then
		unitPercentObj = EUF_TargetFrameMPPercent;
	else
		unitId = string.sub(unit, -1);
		unitObj = getglobal("EUF_PartyFrame" .. unitId .. "MP");
	end;
	
	if unitObj then
		unitObj:SetText(digit);
	end;
	if unitPercentObj then
		unitPercentObj:SetText(percent);
	end;
end;

function EUF_PlayerFrameHPMP_Update()
	EUF_HP_Update("player");
	EUF_MP_Update("player");
end;

function EUF_TargetFrameHPMP_Update()
	EUF_HP_Update("target");
	EUF_MP_Update("target");
end;

function EUF_PartyFrameHPMP_Update()
	local i;
	for i=1, GetNumPartyMembers() do
		EUF_HP_Update("party"..i);
		EUF_MP_Update("party"..i);
	end;
end;

function EUF_FrameHPMP_Update()
	EUF_PlayerFrameHPMP_Update();
	EUF_TargetFrameHPMP_Update();
	EUF_PartyFrameHPMP_Update();
end;

function EUF_PlayerFrameDisplay_Update()
	EUF_PlayerFrameHPPercent:Show();
	EUF_PlayerFrameMPPercent:Show();
end;

function EUF_PartyFrameDisplay_Update()
	local i;
	for i=1, GetNumPartyMembers() do
		getglobal("EUF_PartyFrame"..i.."HP"):Show();
		getglobal("EUF_PartyFrame"..i.."MP"):Show();
	end;
end;

function EUF_TargetFrameDisplay_Update()
	EUF_TargetFrameHPPercent:Show();
	EUF_TargetFrameMPPercent:Show();
end;

function EUF_FrameDisplay_Update()
	EUF_PlayerFrameDisplay_Update();
	EUF_TargetFrameDisplay_Update();
	EUF_PartyFrameDisplay_Update();
end;

function EUF_Frame_Update()
	EUF_FrameDisplay_Update();
	EUF_FrameHPMP_Update();
end;