
local chatfilter = function(message, name, type)
	return name
		and (not FriendLib:IsFriend(name))
		and (FilterLib:Filter(message) == "")
end

local mod = {
	["Name"] = "聊天消毒剂",
	["Description"] = "屏蔽卖金和广告.",
	["Help"] = "你也知道垃圾短信有多常见, e.g. what words they are made of. Friends, party and guild members are never ignored. More info here:|n|nhttps://github.com/Aviana/ChatSanitizer",
	["OnEnable"] = nil,
	["OnDisable"] = nil,
	["CreateUI"] = function(frame, pad)
		return pad
	end,
	["NameFilter"] = nil,
	["ChatFilter"] = chatfilter,
}

local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	SI_ModInstall(mod)
end)
