assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Loner")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["Loner"] = true,
	["Decline all incoming guild requests and petitions."] = true,
	["Canceling guild invite..."] = true,
	["Canceling petition..."] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
    ["Loner"] = "拒绝公会邀请",
	["Decline all incoming guild requests and petitions."] = "自动拒绝所有公会的入会邀请",
	["Canceling guild invite..."] = "已自动拒绝了公会邀请...",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Loner = Automaton:NewModule("Loner")
Automaton_Loner.modulename = L["Loner"]
Automaton_Loner.moduledesc = L["Decline all incoming guild requests and petitions."]
Automaton_Loner.options = {}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Loner:OnInitialize()
    self.db = Automaton:AcquireDBNamespace("Loner")
	Automaton:RegisterDefaults("Loner", "profile", {
		disabled = true,
	})
	Automaton:SetDisabledAsDefault(self, "Loner")

	self:RegisterOptions(self.options)
end

function Automaton_Loner:OnEnable()
	self:RegisterEvent("GUILD_INVITE_REQUEST")
	self:RegisterEvent("PETITION_SHOW")
end

function Automaton_Loner:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------

function Automaton_Loner:GUILD_INVITE_REQUEST()
	self:Print(L["Canceling guild invite..."])
	DeclineGuild()
	StaticPopup_Hide("GUILD_INVITE")
end

function Automaton_Loner:PETITION_SHOW()
	self:Print(L["Canceling petition..."])
	ClosePetition()
end