if not (select(2, UnitClass("player")) == "DRUID") then return end


local function checkTurtle()
	local build = GetBuildInfo()
	function mysplit(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
			table.insert(t, str)
		end
		return t
	end

	local index = {}
	local s = mysplit(build, ".")
	for k, v in pairs(s) do
		print(k, v)
		index[k] = v
	end
	return tonumber(index[2]) >= 16
end

local isTurtle = checkTurtle()

local S_AutoDruidShape_SpellName = nil
local S_AutoDruidShapeTip = CreateFrame("GameTooltip", "S_AutoDruidShapeTip", nil, "GameTooltipTemplate")
S_AutoDruidShapeTip:SetOwner(UIParent, "ANCHOR_NONE")

--解除形态
local function Unshapeshift()
	for i = 1, GetNumShapeshiftForms() do
		local active = select(3, GetShapeshiftFormInfo(i))
		if active then
			CastShapeshiftForm(i)
			break
		end
	end
end

--hook CastSpell函数
hooksecurefunc("CastSpell", function(id, bookType)
	S_AutoDruidShape_SpellName = GetSpellName(id, bookType)
end)

--hook CastSpellByName函数
hooksecurefunc("CastSpellByName", function(spellName, onSelf)
	local _, _, spellName = string.find(spellName, "^([^%(]+)")
	if spellName then
		S_AutoDruidShape_SpellName = spellName
	end
end)

--hook UseAction函数
hooksecurefunc("UseAction", function(slot, checkCursor, onSelf)
	if not GetActionText(slot) then
		S_AutoDruidShapeTip:ClearLines()
		S_AutoDruidShapeTip:SetAction(slot)
		S_AutoDruidShape_SpellName = S_AutoDruidShapeTipTextLeft1:GetText()
	end

	local i = 1
	local powerType = UnitPowerType("player")
	while GetSpellName(i, BOOKTYPE_SPELL) do
		local s = GetSpellName(i, BOOKTYPE_SPELL)
		if s == S_AutoDruidShape_SpellName then
			S_AutoDruidShapeTip:ClearLines()
			S_AutoDruidShapeTip:SetSpell(i, BOOKTYPE_SPELL)
			for j = 3, 4 do
				local Shape_Name = _G["S_AutoDruidShapeTipTextLeft" .. j]:GetText()
				if Shape_Name then
					if Shape_Name == "需要熊形态, 巨熊形态" and powerType ~= 1 then
						Unshapeshift()
						CastShapeshiftForm(1)
					elseif Shape_Name == "需要豹形态" and powerType ~= 3 then
						Unshapeshift()
						CastShapeshiftForm(3)
					end
				end
			end

			local mana = S_AutoDruidShapeTipTextLeft2:GetText()
			if mana and string.find(mana, MANA_COST) and powerType ~= 0 then
				if isTurtle and string.find(s, "自然之握") and powerType == 1 then
					-- 
				else
					Unshapeshift()
				end
			end

			break
		end
		i = i + 1
	end
end)
