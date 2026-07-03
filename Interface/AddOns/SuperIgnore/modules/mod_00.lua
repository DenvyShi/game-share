
local namefilter = function(name)
	if string.find(name, "[^a-zA-Z]") then
		return true
	end
	return false
end

local mod = {
	["Name"] = "特殊字符屏蔽",
	["Description"] = "阻止那些在名字中有特殊字符的玩家发送的信息.",
	["OnEnable"] = nil,
	["OnDisable"] = nil,
	["CreateUI"] = function(frame, pad)
		return pad
	end,
	["NameFilter"] = namefilter,
	["ChatFilter"] = nil,
}


local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	SI_ModInstall(mod)
end)
