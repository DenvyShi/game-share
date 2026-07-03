assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Group")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["Group"] = true,
	["Options for accepting or declining group invites."] = true,
    ["Decline"] = true,
    ["Decline party invites from unknown sources."] = true,

} end)

L:RegisterTranslations("zhCN", function() return {
    ["Group"] = "组队",
	["Options for accepting or declining group invites."] = "自动接受/拒绝组队邀请",
    ["Decline"] = "总是拒绝",
    ["Decline party invites from unknown sources."] = "自动拒绝组队邀请",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Group = Automaton:NewModule("Group")
Automaton_Group.modulename = L["Group"]
Automaton_Group.moduledesc = L["Options for accepting or declining group invites."]
Automaton_Group.options = {
	decline = {
		type = 'toggle', name = L["Decline"], desc = L["Decline party invites from unknown sources."],
		get = function() return Automaton_Group.db.profile.decline end,
		set = function(v) Automaton_Group.db.profile.decline = v end,
	},
}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Group:OnInitialize()
	self.db = Automaton:AcquireDBNamespace("Group")
	Automaton:RegisterDefaults("Group", "profile", {
		disabled = true,
		decline = false,
	})
	Automaton:SetDisabledAsDefault(self, "Group")
	self:RegisterOptions(self.options)
end

function Automaton_Group:OnEnable()
	self:RegisterEvent("PARTY_INVITE_REQUEST")
end

function Automaton_Group:PARTY_INVITE_REQUEST()
	if self.db.profile.decline then
		DeclineGroup()
	else
		AcceptGroup()
	end
	StaticPopup_Hide("PARTY_INVITE")
end