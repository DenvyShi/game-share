hooksecurefunc("UnitFrame_OnEnter", function()
	local class = select(2, UnitClass("player"))
	local frame = this:GetName()
	--玩家头像的鼠标提示--
	if frame == "PlayerFrame" then
		GameTooltip:AddLine("移动:Alt+左键  焦点头像：Ctrl+Alt+左键  重置:右键", .3, 1, .6)
		GameTooltip:Show()
	end
	
	--猎人宠物头像的鼠标提示--
	if class == "HUNTER" and frame == "PetFrame" then
		local happiness, damagePercentage = GetPetHappiness()
		local hasPetUI, isHunterPet = HasPetUI()
		local loyalty = tostring(GetPetLoyalty())
		local currXP, nextXP = GetPetExperience()
		local PetHappinessColors = {
			[1] = {1, 0, 0},
			[2] = {1, 1, 0},
			[3] = {0, 1, 0},
		}
		if ( not happiness or not isHunterPet ) then
			return
		end
		GameTooltip:AddLine(getglobal("PET_HAPPINESS"..happiness),PetHappinessColors[happiness][1], PetHappinessColors[happiness][2], PetHappinessColors[happiness][3])
		GameTooltip:AddLine("忠诚度："..string.sub(loyalty,14))
		GameTooltip:AddLine(format(PET_DAMAGE_PERCENTAGE, damagePercentage))
		if UnitLevel("pet") < 60 then
			GameTooltip:AddLine("经验："..Over1E3toK(currXP).."/"..Over1E3toK(nextXP).." - "..math.floor(currXP * 100 / nextXP).."%")
		end
		GameTooltip:AddLine(format(PET_DIET_TEMPLATE, BuildListString(GetPetFoodTypes())))
		GameTooltip:Show()
	end
end)