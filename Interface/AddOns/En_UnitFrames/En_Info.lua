local EUF_TarKTMFrame = true --启用目标仇恨状态框架染色

local CREATURE_TYPE_ICON = {
	["野兽"] = "Interface\\Icons\\Ability_Racial_BearForm",
	["人型生物"] = "Interface\\Icons\\Spell_Holy_PrayerOfHealing",
	["元素生物"] = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
	["机械"] = "Interface\\Icons\\INV_Gizmo_02",
	["龙类"] = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
	["巨人"] = "Interface\\Icons\\Ability_Racial_Avatar",
	["亡灵"] = "Interface\\Icons\\Spell_Shadow_RaiseDead",
	["恶魔"] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",	
	["小动物"] = "Interface\\Icons\\ABILITY_SEAL",
}

function TargetInfoButton_OnClick()
	if UnitIsPlayer("target") then
		if arg1 == "LeftButton" then
			if CheckInteractDistance("target", 1) then InspectUnit("target") end
		elseif arg1 == "RightButton" then
			if CheckInteractDistance("target", 4) then FollowUnit("target") end
		elseif arg1 == "MiddleButton" then
			local name, server = UnitName("target")
			if server then name = name .. '-' .. server end
			ChatFrame_SendTell(name)
		end
	end
end

--目标信息显示：物种、职业、仇恨值
function EUF_TargetInfo_Update()
	if TargetFrame then
		if UnitIsPlayer("target") then
			local coord = CLASS_ICON_TCOORDS[select(2, UnitClass("target"))]
			TargetInfoButtonIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			TargetInfoButtonIcon:SetTexCoord(unpack(coord))
			TargetInfoButton:Show()
		else
			local creature = UnitCreatureType("target")
			if creature and CREATURE_TYPE_ICON[creature] then
				TargetInfoButtonIcon:SetTexture(CREATURE_TYPE_ICON[creature])
				TargetInfoButtonIcon:SetTexCoord(0, 1, 0, 1)
				TargetInfoButton:Show()
			else
				TargetInfoButton:Hide()
			end

		end
	end
end

-- 小队信息 --
for i = 1, 4 do
	local str = "PartyMemberFrame"..i;
	local text = getglobal(str):CreateFontString(str.."LevelClass", "ARTWORK", "GameTooltipTextSmall");
	text:SetPoint("TOPLEFT", str, "BOTTOMLEFT", -10, 16);
	text:SetTextColor(1, 0.75, 0);
	text:SetJustifyH("LEFT");
end;

local ORG_PartyMemberFrame_OnUpdate = PartyMemberFrame_OnUpdate;
function PartyMemberFrame_OnUpdate(elapsed)
	ORG_PartyMemberFrame_OnUpdate(elapsed);
	if ( this.zPartyCountdown and this.zPartyCountdown > 0 ) then
		this.zPartyCountdown = this.zPartyCountdown - elapsed;
		return;
	end;
	this.zPartyCountdown = 2;
	local unit = "party"..this:GetID();
	local level;
	if (UnitLevel(unit) and UnitLevel(unit) >0) then
		level = UnitLevel(unit);
	else
		level ="??";
	end;
	local class = UnitClass(unit) or "??";
	getglobal("PartyMemberFrame"..this:GetID().."LevelClass"):SetText(level.."\n"..class);
end