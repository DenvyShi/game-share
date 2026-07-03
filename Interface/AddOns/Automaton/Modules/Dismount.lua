assert(Automaton, "Automaton not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Automaton_Dismount")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function()
	return {
		["Dismount"] = true,
		["Automatically dismount, cancel forms druid, shaman, priest, when you receive the appropriate error"] = true,
	}
end)

L:RegisterTranslations("zhCN", function()
	return {
		["Dismount"] = "自动下马",
		["Automatically dismount, cancel forms druid, shaman, priest, when you receive the appropriate error"] = "当报错提示时或与飞行管理员对话时自动下马",
	}
end)

----------------------------------
--      Module Declaration      --
----------------------------------

Automaton_Dismount = Automaton:NewModule("Dismount")
Automaton_Dismount.modulename = L["Dismount"]
Automaton_Dismount.moduledesc = L
	["Automatically dismount, cancel forms druid, shaman, priest, when you receive the appropriate error"]
Automaton_Dismount.options = {}

------------------------------
--      Initialization      --
------------------------------

function Automaton_Dismount:OnInitialize()
	self:RegisterOptions(self.options)
end

function Automaton_Dismount:OnEnable()
	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:RegisterEvent("TAXIMAP_OPENED")
end

function Automaton_Dismount:OnDisable()
	self:UnregisterAllEvents()
end

------------------------------
--      Event Handlers      --
------------------------------

local BuffsList = {
	"_mount_",             --常规坐骑
	"spell_nature_swiftness", --骸骨军马、机械陆行鸟、科多兽、地狱战马、迅猛龙等
	"_qirajicrystal_",     --其拉共鸣水晶

	--------特殊坐骑请玩家自行往下添加--------
	"hunter_pet_turtle",   --乌龟坐骑
	"warstomp",            --斑马坐骑
	"bullrush",            --幽灵狮鹫
	"_branch_",            --驯鹿
	"hunter_pet_hippogryph", --角鹰兽
	"hunter_pet_tallstrider", --爱情鸟
	"hunter_pet_bear",     --熊
	"spell_nature_sentinal", --乌鸦
	"inv_misc_key_06",     -- 工程坐骑
	"inv_misc_key_12",     -- 工程坐骑
	"spell_magic_polymorphchicken", -- 魔法公鸡
	"hunter_pet_stag1", -- 暗角雄鹿
	"inv_valentinescard01", -- 粉色虎
	"inv_valentinesboxofchocolates02", -- 粉色马
	'ability_hunter_pet_dragonhawk', -- 龙鹰
	"ability_racial_bearform",
	"ability_druid_catform",
	"ability_druid_travelform",
	"ability_druid_aquaticform",
	-- "spell_shadow_shadowform",
	"spell_nature_spiritwolf",
	"inv_pet_speedy",
}

local BuffNames = {
	"迅捷美酒节科多兽"
}

local ErrorsList = {
	SPELL_FAILED_NOT_MOUNTED, ERR_ATTACK_MOUNTED, ERR_TAXIPLAYERALREADYMOUNTED,
	SPELL_FAILED_NOT_SHAPESHIFT, SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED, SPELL_NOT_SHAPESHIFTED,
	SPELL_NOT_SHAPESHIFTED_NOSPACE, ERR_CANT_INTERACT_SHAPESHIFTED, ERR_NOT_WHILE_SHAPESHIFTED,
	ERR_NO_ITEMS_WHILE_SHAPESHIFTED, ERR_TAXIPLAYERSHAPESHIFTED, ERR_MOUNT_SHAPESHIFTED
}

local scantip = CreateFrame("GameTooltip", "AutoDismountScanTip", nil, "GameTooltipTemplate")

local function dismount()
	local canceld = false
	for i = 0, 31, 1 do
		currBuffTex = GetPlayerBuffTexture(i)
		if currBuffTex then
			for _, bufftype in pairs(BuffsList) do
				if string.find(string.lower(currBuffTex), bufftype) then
					CancelPlayerBuff(i)
					canceld = true
				end
			end
		end
	end
	if canceld == false then
		for _, buffname in pairs(BuffNames) do
			for i = 0, 32 do
				scantip:SetOwner(UIParent, "ANCHOR_NONE")
				scantip:SetPlayerBuff(i)
				local name = AutoDismountScanTipTextLeft1:GetText()
				if not name then break end
				if string.find(string.lower(name), buffname) then
					CancelPlayerBuff(i)
				end
				scantip:Hide()
			end
		end
	end
end

function Automaton_Dismount:UI_ERROR_MESSAGE(msg)
	for _, errorstring in pairs(ErrorsList) do
		if arg1 == errorstring then
			dismount()
		end
	end
end

function Automaton_Dismount:TAXIMAP_OPENED()
	dismount()
end
