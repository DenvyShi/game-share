local BC = AceLibrary("Babble-Class-2.2")

S_WHO_CLASS_LIST = {
	BC["Warrior"],
	BC["Mage"],
	BC["Priest"],
	BC["Rogue"],
	BC["Hunter"],
	BC["Shaman"],
	BC["Paladin"],
	BC["Druid"],
	BC["Warlock"],
}

local S_WhoClassButton = CreateFrame("Button", "S_WhoClassButton", WhoFrame, "UIDropDownMenuTemplate")
S_WhoClassButton:SetPoint("LEFT", WhoFrameColumnHeader4, "RIGHT", -42, -3)
S_WhoClassButton:RegisterEvent("PLAYER_LOGIN")
S_WhoClassButton:SetScript("OnEvent", function()
	if UnitFactionGroup("player") == "Horde" then
		table.remove(S_WHO_CLASS_LIST, 7)
	else
		table.remove(S_WHO_CLASS_LIST, 6)
	end
end)

function S_FindClass()
	local class = ""
	local i = UIDropDownMenu_GetSelectedID(S_WhoClassButton)
	if i then
		class = 'c-' .. S_WHO_CLASS_LIST[i]
	end
	SendWho(class)
end

function S_WhoClassOnClick()
	local i = this:GetID()
	UIDropDownMenu_SetSelectedID(S_WhoClassButton, i)
	S_FindClass()
end

function S_WhoClassDropDown_Initialize()
	local info
	for i=1, getn(S_WHO_CLASS_LIST), 1 do
		info = {}
		info.text = S_WHO_CLASS_LIST[i]
		info.func = S_WhoClassOnClick
		UIDropDownMenu_AddButton(info)
	end
end

UIDropDownMenu_SetWidth(7, S_WhoClassButton)
UIDropDownMenu_Initialize(S_WhoClassButton, S_WhoClassDropDown_Initialize)