local S_ActionCountLine = AceLibrary("Gratuity-2.0")

--颜色
local function ActionCountColor(text, num)
	local r, g, b
	
	if (num == "") then
		text:SetTextColor(1.0, 1.0, 1.0)
		return
	end
	
	if not num then
		num = 0
	elseif num > 10 then
		num = 10
	end	
	num = num/10
	
	if(num > 0.5) then
		r = (1.0 - num) * 2
		g = 1.0
	else
		r = 1.0
		g = num * 2
	end

	b = 0.0
	text:SetTextColor(r, g, b)
end

--显示材料数量
function ShowActionSpellCount()
	local text = getglobal(this:GetName().."Count")
	local action = ActionButton_GetPagedID(this)

	local texture = GetActionTexture(action)
	if texture then
		S_ActionCountLine:SetAction(action)
		local _,_,Reagent = S_ActionCountLine:Find(SPELL_REAGENTS.."(.+)")
		if Reagent then
			local count = select(5,FindItemInfo(Reagent))
			if count and count > 0 then
				text:SetText(count)
			else
				text:SetText("0")
			end
			ActionCountColor(text, count)
		end
	end
end

hooksecurefunc("ActionButton_OnEvent", function(event)
	this:RegisterEvent("BAG_UPDATE")
	if ( event == "BAG_UPDATE" ) then
		ShowActionSpellCount()
	end
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == ActionButton_GetPagedID(this) ) then
			ShowActionSpellCount()
		end
	end
	if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" ) then
		ShowActionSpellCount()
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			ShowActionSpellCount()
		end
	end
end)