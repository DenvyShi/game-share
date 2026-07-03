assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Release")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["Release"] = true,
	["Automatically release to ghost after dying in a battleground"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
    ["Release"] = "战场灵魂释放",
	["Automatically release to ghost after dying in a battleground"] = "在战场上死亡后自动释放灵魂",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Release = Automaton:NewModule("Release")
Automaton_Release.modulename = L["Release"]
Automaton_Release.moduledesc = L["Automatically release to ghost after dying in a battleground"]
Automaton_Release.options = {}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Release:OnInitialize()
    self.db = Automaton:AcquireDBNamespace("Release")
	Automaton:RegisterDefaults("Release", "profile", {
		disabled = true,
	})
	Automaton:SetDisabledAsDefault(self, "Release")
	
	self:RegisterOptions(self.options)
end

function Automaton_Release:OnEnable()
	self:RegisterEvent("PLAYER_DEAD")
end

function Automaton_Release:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------

function Automaton_Release:PLAYER_DEAD()
	if MiniMapBattlefieldFrame.status == "active" then
		RepopMe()
	end
end