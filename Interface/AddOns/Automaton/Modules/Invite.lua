assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Invite")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Invite"] = true,
	["Options for sending out party invites."] = true,
	["Invite text"] = true,
	["The text users send to trigger an invite."] = true,
	["keyword invite"] = true,
	["Ignore case"] = true,
	["Disable case sensitivity for the invite text"] = true,
	["Auto turn raid"] = true,
	["Turn Raid when your team more than 5 person"] = true,
	["Can't invite"] = true,
	[",you are not leader"] = true,
	["Automatically converted to Raid"] = true,
	[",Raid is full."] = true,
	[",Party is full."] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Invite"] = "密语邀请",
	["Options for sending out party invites."] = "自动邀请密语你关键字的玩家",
	["Invite text"] = "关键字",
	["The text users send to trigger an invite."] = "密语关键字",
	["keyword invite"] = "关键字邀请",
	["Ignore case"] = "模糊关键字",
	["Disable case sensitivity for the invite text"] = "模糊关键字的匹配(不论大小写等)",
	["Auto turn raid"] = "自动转为团队",
	["Turn Raid when your team more than 5 person"] = "当小队人数超过5人时自动转换为团队",
	["Can't invite"] = "不能邀请",
	[",you are not leader"] = "，你不是队长",
	["Automatically converted to Raid"] = "|cffff0000>>|r已自动转换到团队|cffff0000<<|r",
	[",Raid is full."] = "，团队已满",
	[",Party is full."] = "，小队已满",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Invite = Automaton:NewModule("Invite")
Automaton_Invite.modulename = L["Invite"]
Automaton_Invite.moduledesc = L["Options for sending out party invites."]
Automaton_Invite.options = {
	keyword = {
		type = "text", name = L["Invite text"], desc = L["The text users send to trigger an invite."],
		order = 3, usage = L["keyword invite"],
		get = function() return Automaton_Invite.db.profile.inviteString end,
		set = function(v) Automaton_Invite.db.profile.inviteString = v end,
	},
	case = {
		type = "toggle", name = L["Ignore case"], desc = L["Disable case sensitivity for the invite text"],
		order = 2,
		get = function() return Automaton_Invite.db.profile.ignoreCase end,
		set = function(v) Automaton_Invite.db.profile.ignoreCase = v end,
	},
	autoraid = {
		type = "toggle", name = L["Auto turn raid"], desc = L["Turn Raid when your team more than 5 person"],
		order = 4,
		get = function() return Automaton_Invite.db.profile.turnraid end,
		set = function(v) Automaton_Invite.db.profile.turnraid = v end,
	},
}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Invite:OnInitialize()
	self.db = Automaton:AcquireDBNamespace("Invite")
	Automaton:RegisterDefaults("Invite", "profile", {
		disabled = true,
		inviteString = "1",
		ignoreCase = true,
		turnraid = false,
	})
	Automaton:SetDisabledAsDefault(self, "Invite")
	
	self:RegisterOptions(self.options)
end

function Automaton_Invite:OnEnable()
	self:RegisterEvent("CHAT_MSG_WHISPER")
end

function Automaton_Invite:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------

function Automaton_Invite:CHAT_MSG_WHISPER(text,from)
	local keyword, msg, numgroup
	local player = from
	local keyword = Automaton_Invite.db.profile.inviteString
	local msg = text
	if Automaton_Invite.db.profile.ignoreCase then
		keyword = string.lower(keyword)
		msg = string.lower(msg)
	end
	if string.find(msg,format("^%s$",keyword)) then
		if Automaton_Invite.db.profile.turnraid then
			numgroup = GetNumRaidMembers();
			if(numgroup == 0) then
				numparty = GetNumPartyMembers();
				if(numparty == 0) then InviteByName(player)
				elseif(numparty < 4) then
					if(IsPartyLeader()) then InviteByName(player)
					else return DEFAULT_CHAT_FRAME:AddMessage(L["Can't invite"]..player..L[",you are not leader"]) end;
				elseif(GetNumPartyMembers() == 4)then
					if(IsPartyLeader()) then 
						DEFAULT_CHAT_FRAME:AddMessage(L["Automatically converted to Raid"])
						ConvertToRaid();
						InviteByName(player);
					else
						DEFAULT_CHAT_FRAME:AddMessage(L["Can't invite"]..player..L[",you are not leader"]);
					end
				end
			elseif((IsRaidLeader() or IsRaidOfficer()) and numgroup < 40) then InviteByName(player)
			else
				if(numgroup > 39) then return DEFAULT_CHAT_FRAME:AddMessage(L["Can't invite"]..player..L[",Raid is full."]);
				else return DEFAULT_CHAT_FRAME:AddMessage(L["Can't invite"]..player..L[",you are not leader"]) end;
			end
		else
			numgroup = GetNumPartyMembers();
			if((IsPartyLeader() and numgroup < 4) or (numgroup == 0)) then InviteByName(player)
			else 
				if(numgroup >= 4) then return DEFAULT_CHAT_FRAME:AddMessage(L["Can't invite"]..player..L[",Party is full."]);
				else return DEFAULT_CHAT_FRAME:AddMessage(L["Can't invite"]..player..L[",you are not leader"]) end;
			end			
		end
	end
end