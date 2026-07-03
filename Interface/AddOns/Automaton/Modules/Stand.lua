assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Stand")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Stand"] = true,
	["Automatically stand when you receive the 'You must be standing' error"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Stand"] = "站立",
	["Automatically stand when you receive the 'You must be standing' error"] = "自动站立, 当你收到“你必须站立”的提示时",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Stand = Automaton:NewModule("Stand")
Automaton_Stand.modulename = L["Stand"]
Automaton_Stand.moduledesc = L["Automatically stand when you receive the 'You must be standing' error"]
Automaton_Stand.options = {}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Stand:OnInitialize()
	self:RegisterOptions(self.options)
end

function Automaton_Stand:OnEnable()
	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:RegisterEvent("UI_INFO_MESSAGE","UI_ERROR_MESSAGE")
end

function Automaton_Stand:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------

local messages = {
	[SPELL_FAILED_NOT_STANDING] = true,
	[ERR_CANTATTACK_NOTSTANDING] = true,
	[ERR_LOOT_NOTSTANDING] = true,
	[ERR_TAXINOTSTANDING] = true,
}

function Automaton_Stand:UI_ERROR_MESSAGE(msg)
	if messages[msg] then
		DoEmote("stand")
	end
end