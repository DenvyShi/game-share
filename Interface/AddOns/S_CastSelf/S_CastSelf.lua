local S_Castself_Tooltip = AceLibrary("Gratuity-2.0")

function ToggleSelfCast()
	if (CS_SELF_ENABLED) then
		CS_SELF_ENABLED = false
		print("已关闭自动自我施法")
	else
		CS_SELF_ENABLED = true
		SetCVar("autoSelfCast", 0)	-- 关闭系统默认自动自我施法
		print("已开启自动自我施法，使用ALT强行对自己施法")
	end
end

SLASH_SCS1 = "/scastself"
SlashCmdList["SCS"] = ToggleSelfCast

function SelfCast()
	if (CS_SELF_ENABLED) then
		return IsAltKeyDown()
	else
		return 0
	end
end

--hook UseAction函数
local S_UseAction = UseAction
function S_CastSelf_UseAction(id, type, me)
	S_Castself_Tooltip:SetAction(id)
	local line1 = S_Castself_Tooltip:GetLine(1)
	local bags, slots = FindItemInfo(line1)
	
	if not UnitIsFriend("player", "target") then  --如果目标友善
		if line1 and SelfCast() and SpellCanTargetUnit("player") then
			if (bags and slots) then
				UseContainerItem(bags, slots)
				return
			end
			S_UseAction(id, type, SelfCast())
		else
			S_UseAction(id, type, SelfCast())
			if CS_SELF_ENABLED then
				SpellTargetUnit("player")
			end
		end
	else
		if (SelfCast() and not CursorHasItem() and not CursorHasSpell()) then
			if (bags and slots) then
				UseContainerItem(bags, slots)
				return
			end
			S_UseAction(id, type, SelfCast())
		else
			S_UseAction(id, type, SelfCast())
			if CS_SELF_ENABLED then
				SpellTargetUnit("player")
			end
		end
	end
end
UseAction = S_CastSelf_UseAction

--hook UseContainerItem函数
local S_UseContainerItem = UseContainerItem
function S_CastSelf_UseContainerItem(id, type, me)
	S_Castself_Tooltip:SetAction(id)
	local line1 = S_Castself_Tooltip:GetLine(1)
	local bags, slots = FindItemInfo(line1)

	if not UnitIsFriend("player", "target") then  --如果目标友善
		if line1 and SelfCast() and SpellCanTargetUnit("player") then
			if (bags and slots) then
				UseContainerItem(bags, slots)
				return
			end
			S_UseContainerItem(id, type, SelfCast())
		else
			S_UseContainerItem(id, type, SelfCast())
			if CS_SELF_ENABLED then
				SpellTargetUnit("player")
			end
		end
	else
		if (SelfCast() and not CursorHasItem() and not CursorHasSpell()) then
			if bags and slots then
				UseContainerItem(bags, slots)
				return
			end
			S_UseContainerItem(id, type, SelfCast())
		else
			S_UseContainerItem(id, type, SelfCast())
			if CS_SELF_ENABLED then
				SpellTargetUnit("player")
			end
		end
	end
end
UseContainerItem = S_CastSelf_UseContainerItem