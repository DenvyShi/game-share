local _G = _G or getfenv(0)
local CleveRoids = _G.CleveRoids or {}
_G.CleveRoids = CleveRoids

CleveRoids.ready = false

CleveRoids.Hooks             = CleveRoids.Hooks      or {}
CleveRoids.Hooks.GameTooltip = {}

CleveRoids.Extensions          = CleveRoids.Extensions or {}
CleveRoids.actionEventHandlers = {}
CleveRoids.mouseOverResolvers  = {}

CleveRoids.mouseoverUnit = CleveRoids.mouseoverUnit or nil
CleveRoids.mouseOverUnit = nil

CleveRoids.hasSuperwow = SetAutoloot and true or false

CleveRoids.ParsedMsg = {}
CleveRoids.Items     = {}
CleveRoids.Spells    = {}
CleveRoids.Talents   = {}
CleveRoids.Cooldowns = {}
CleveRoids.Macros    = {}
CleveRoids.Actions   = {}
CleveRoids.Sequences = {}

CleveRoids.lastUpdate = 0
CleveRoids.lastGetItem = nil
CleveRoids.currentSequence = nil

CleveRoids.bookTypes = {BOOKTYPE_SPELL, BOOKTYPE_PET}
CleveRoids.unknownTexture = "Interface\\Icons\\INV_Misc_QuestionMark"

CleveRoids.spell_tracking = {}

-- Holds information about the currently cast spell
CleveRoids.CurrentSpell = {
    -- "channeled" or "cast"
    type = "",
    -- the name of the spell
    spellName = "",
    -- is the Attack ability enabled
    autoAttack = false,
    -- is the Auto Shot ability enabled
    autoShot = false,
    -- is the Shoot ability (wands) enabled
    wand = false,
}

CleveRoids.dynamicCmds = {
    ["/cast"]         = true,
    ["/castsequence"] = true,
    ["/use"]          = true,
    ["/equip"]        = true,
    ["/equipmh"]      = true,
    ["/equipoh"]      = true,
}

CleveRoids.ignoreKeywords = {
    action        = true,
    ignoretooltip = true,
    cancelaura    = true,
}

-- TODO: Localize?
CleveRoids.countedItemTypes = {
    ["Consumable"]  = true,
    ["Reagent"]     = true,
    ["Projectile"]  = true,
    ["Trade Goods"] = true,
}


-- TODO: Localize?
CleveRoids.actionSlots    = {}
CleveRoids.reactiveSlots  = {}
CleveRoids.reactiveSpells = { -- 新增多语言支持 by 武藤纯子酱 2025.8.22
    [CleveRoids.Localized.Spells["Revenge"]]       = true,
    [CleveRoids.Localized.Spells["Overpower"]]     = true,
    [CleveRoids.Localized.Spells["Riposte"]]       = true,
    [CleveRoids.Localized.Spells["Surprise Attack"]]  = true,
    [CleveRoids.Localized.Spells["Mongoose Bite"]] = true,
    [CleveRoids.Localized.Spells["Counterattack"]] = true,
    [CleveRoids.Localized.Spells["Arcane Surge"]]  = true,
	[CleveRoids.Localized.Spells["Lacerate"]] = true,
	[CleveRoids.Localized.Spells["Baited Shot"]] = true,
    [CleveRoids.Localized.Spells["Aquatic Form"]] = true,
}

CleveRoids.spamConditions = {
    [CleveRoids.Localized.Attack]   = "checkchanneled",
    [CleveRoids.Localized.AutoShot] = "checkchanneled",
    [CleveRoids.Localized.Shoot]    = "checkchanneled",
}

CleveRoids.auraTextures = {
    [CleveRoids.Localized.Spells["Stealth"]]    = "Interface\\Icons\\Ability_Stealth",
    [CleveRoids.Localized.Spells["Prowl"]]      = "Interface\\Icons\\Ability_Ambush",
    [CleveRoids.Localized.Spells["Shadowform"]] = "Interface\\Icons\\Spell_Shadow_Shadowform",
    ["Seal of Wisdom"] = "Interface\\Icons\\Spell_Holy_RighteousnessAura",
    ["Seal of the Crusader"] = "Interface\\Icons\\Spell_Holy_HolySmite",
    ["Seal of Light"] = "Interface\\Icons\\Spell_Holy_HealingAura",
    ["Seal of the Justice"] = "Interface\\Icons\\Spell_Holy_SealOfWrath",
    ["Seal of Righteousness"] = "Interface\\Icons\\Ability_ThunderBolt",
    ["Seal of Command"] = "Interface\\Icons\\Ability_Warrior_InnerRage",
}


-- I need to make a 2h modifier
-- Maps easy to use weapon type names (e.g. Axes, Shields) to their inventory slot name and their localized tooltip name
CleveRoids.WeaponTypeNames = {
    Daggers   = { slot = "MainHandSlot", name = CleveRoids.Localized.Dagger },
    Fists     = { slot = "MainHandSlot", name = CleveRoids.Localized.FistWeapon },
    Axes      = { slot = "MainHandSlot", name = CleveRoids.Localized.Axe },
    Swords    = { slot = "MainHandSlot", name = CleveRoids.Localized.Sword },
    Staves    = { slot = "MainHandSlot", name = CleveRoids.Localized.Staff },
    Maces     = { slot = "MainHandSlot", name = CleveRoids.Localized.Mace },
    Polearms  = { slot = "MainHandSlot", name = CleveRoids.Localized.Polearm },
    -- OH
    Daggers2  = { slot = "SecondaryHandSlot", name = CleveRoids.Localized.Dagger },
    Fists2    = { slot = "SecondaryHandSlot", name = CleveRoids.Localized.FistWeapon },
    Axes2     = { slot = "SecondaryHandSlot", name = CleveRoids.Localized.Axe },
    Swords2   = { slot = "SecondaryHandSlot", name = CleveRoids.Localized.Sword },
    Maces2    = { slot = "SecondaryHandSlot", name = CleveRoids.Localized.Mace },
    Shields   = { slot = "SecondaryHandSlot", name = CleveRoids.Localized.Shield },
    -- ranged
    Guns      = { slot = "RangedSlot", name = CleveRoids.Localized.Gun },
    Crossbows = { slot = "RangedSlot", name = CleveRoids.Localized.Crossbow },
    Bows      = { slot = "RangedSlot", name = CleveRoids.Localized.Bow },
    Thrown    = { slot = "RangedSlot", name = CleveRoids.Localized.Thrown },
    Wands     = { slot = "RangedSlot", name = CleveRoids.Localized.Wand },
}

--新增鼠标按键1-5的支持 by 武藤纯子酱 2025.7.21
CleveRoids.MouseDown = "LeftButton"
CleveRoids.Allbutton = {}

function CleveRoids.GetAllButtons()

	for i = 1, 12 do
		table.insert(CleveRoids.Allbutton, _G["ActionButton"..i])
		table.insert(CleveRoids.Allbutton, _G["MultiBarBottomLeftButton"..i])
		table.insert(CleveRoids.Allbutton, _G["MultiBarBottomRightButton"..i])
		table.insert(CleveRoids.Allbutton, _G["MultiBarRightButton"..i])
		table.insert(CleveRoids.Allbutton, _G["MultiBarLeftButton"..i])
		table.insert(CleveRoids.Allbutton, _G["BonusActionButton"..i])
	end

	if pfUI and pfUI.bars then
		for i = 1, 12 do
			table.insert(CleveRoids.Allbutton, _G["pfActionBarMainButton"..i])
			table.insert(CleveRoids.Allbutton, _G["pfActionBarPagingButton"..i])
			table.insert(CleveRoids.Allbutton, _G["pfActionBarRightButton"..i])
			table.insert(CleveRoids.Allbutton, _G["pfActionBarVerticalButton"..i])
			table.insert(CleveRoids.Allbutton, _G["pfActionBarLeftButton"..i])
			table.insert(CleveRoids.Allbutton, _G["pfActionBarTopButton"..i])
		end
	end

    if ZBAR_VERSION then
        for barIndex = 1, 4 do
            for buttonIndex = 1, 12 do
				table.insert(CleveRoids.Allbutton, _G["zBar"..barIndex.."Button"..buttonIndex])
            end
        end
    end
	
	for _, v in ipairs(CleveRoids.Allbutton) do
		v:SetScript("OnMouseDown", function()
			if arg1 then CleveRoids.MouseDown = arg1 end
		end)
	end
	
    return
end

-- 创建工具提示扫描器 by 武藤纯子酱 2025.7.21
CleveRoids.Scanner = CreateFrame("GameTooltip", "CleverDismountScanner", nil, "GameTooltipTemplate")
CleveRoids.Scanner:SetOwner(UIParent, "ANCHOR_NONE")

CleveRoids.MountPatterns = {
	-- deDE
	"^Erhöht Tempo um (.+)%%",
	-- enUS
	"^Increases speed by (.+)%%",
	-- esES
	"^Aumenta la velocidad en un (.+)%%",
	-- frFR
	"^Augmente la vitesse de (.+)%%",
	-- ruRU
	"^Скорость увеличена на (.+)%%",
	-- koKR
	"^이동 속도 (.+)%%만큼 증가",
	-- zhCN
	"^速度提高(.+)%%",

	-- turtle-wow
	"speed based on",
	"Slow and steady...",
	"Riding",
	"根据您的骑行技能提高速度。",
	"根据骑术技能提高速度。",
	"又慢又稳......",
}

CleveRoids.FlyMountPatterns = {
	-- turtle-wow flying ride
	"Increases flying speed by (.+)%% for (.+) sec.",
	"飞行速度提高(.+)%%。",
}

CleveRoids.SpellCastTimes = CleveRoids.SpellCastTimes or {} -- 添加delay延迟记录表 by 武藤纯子酱 2025.8.25
CleveRoids.AssistsUnit = CleveRoids.AssistsUnit or {} -- 添加assists延迟记录表 by 武藤纯子酱 2025.8.25
_G["CleveRoids"] = CleveRoids
