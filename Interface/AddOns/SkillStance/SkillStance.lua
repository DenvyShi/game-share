--SkillStance AddOn by Taloquin, original code by Leleth--

local current_argument = "";

function SkillStance_OnLoad()
	_,lclass = UnitClass("player")
	if (lclass == "WARRIOR") then
		isWarrior = true
	end
	this:RegisterEvent("UI_ERROR_MESSAGE")
end

function SkillStance_OnEvent()
	SkillStance_Loop()
end

function SkillStance_Loop()
	local i = 1;
	while(getglobal("arg"..i) ~= nil) do
		current_argument = getglobal("arg"..i);
		if _CheckFor(Wanttarget) then
			TargetNearestEnemy()
			return
		end
		if isWarrior then	
			if _CheckFor(WantBattleStance) then
				CastShapeshiftForm(1)
				return
			end
			if _CheckFor(WantDefensiveStance) then
				CastShapeshiftForm(2)
				return
			end
			if _CheckFor(WantBerserkerStance) then
				CastShapeshiftForm(3)
				return
			end
			if _CheckFor(WantOffensiveStance) then 
				CastShapeshiftForm(1)
				return
			end
			if _CheckFor(WantAssaultStance) then 
				CastShapeshiftForm(1)
				return
			end
		end
        i = i+1;
	end
end

function _CheckFor(TheString)
	if (TheString ~= nil) then
		if ((string.find(current_argument, TheString) ~= nil)) then
			return true
		else
			return false
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("SkillStance错误：请检查localisation.lua文件。")
		return false;
	end
end