local En_PowerTick = CreateFrame("Frame", nil, PlayerFrameManaBar)
En_PowerTick:SetAllPoints(PlayerFrameManaBar)
En_PowerTick:RegisterEvent("PLAYER_ENTERING_WORLD")
En_PowerTick:RegisterEvent("UNIT_DISPLAYPOWER")
En_PowerTick:RegisterEvent("UNIT_ENERGY")
En_PowerTick:RegisterEvent("UNIT_MANA")
En_PowerTick:RegisterEvent("UNIT_HEALTH")
En_PowerTick:SetScript("OnEvent", function()
	if UnitPowerType("player") == 0 then
		this.mode = "MANA"
		if (UnitMana("player") == UnitManaMax("player")) or UnitIsDeadOrGhost("player") then
			this:Hide()
		else
			this:Show()
		end
	elseif UnitPowerType("player") == 3 then
		this.mode = "ENERGY"
		if UnitIsDeadOrGhost("player") then
			this:Hide()
		else
			this:Show()
		end
	else
		this:Hide()
	end

	if event == "PLAYER_ENTERING_WORLD" then
		this.lastMana = UnitMana("player")
		this.spark:SetVertexColor(1, 1, 1, 1)
	end

	if (event == "PLAYER_ENTERING_WORLD") or (event == "UNIT_MANA" or event == "UNIT_ENERGY") and arg1 == "player" then
		this.currentMana = UnitMana("player")
		local diff = 0
			if this.lastMana then
				diff = this.currentMana - this.lastMana
			end

			if this.mode == "MANA" and diff < 0 then
				this.target = 5
			elseif this.mode == "MANA" and diff > 0 then
				if this.max ~= 5 and diff > (this.badtick and this.badtick*1.2 or 5) then
					this.target = 2
				else
					this.badtick = diff
				end
			elseif this.mode == "ENERGY" then
				this.target = 2
			end
		this.lastMana = this.currentMana      
	end
end)

local pheight, pwidth = PlayerFrameManaBar:GetHeight(), PlayerFrameManaBar:GetWidth()
En_PowerTick:SetScript("OnUpdate", function()    
	if this.target then
		this.start, this.max = GetTime(), this.target
		this.target = nil
	end

	if not this.start then return end

	this.current = GetTime() - this.start

	if this.current > this.max then
		this.start, this.max, this.current = GetTime(), 2, 0
	end

	local pos = (pwidth ~= "-1" and pwidth or width) * (this.current / this.max)
	if not pheight then return end
	this.spark:SetPoint("LEFT", pos-((pheight+5)/2), 0)
end)

En_PowerTick.spark = En_PowerTick:CreateTexture(nil, 'OVERLAY')
En_PowerTick.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
En_PowerTick.spark:SetHeight(pheight + 10)
En_PowerTick.spark:SetWidth(pheight + 4)
En_PowerTick.spark:SetBlendMode('ADD')