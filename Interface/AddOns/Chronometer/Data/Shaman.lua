--<< ====================================================================== >>--
-- 配置计时器（针对萨满职业）                                                  --
--<< ====================================================================== >>--
local BS = AceLibrary("Babble-Spell-2.2")
local L = AceLibrary("AceLocale-2.2"):new("Chronometer")

function Chronometer:ShamanSetup()
    local _, eclass = UnitClass("player")
    if eclass ~= "SHAMAN" then return end

    self:AddGroup(1, false, "FOREST")
    self:AddGroup(2, false, "MAROON")
    self:AddGroup(3, false, "CYAN")
    self:AddGroup(4, false, "NAVY")

    -- 图腾掌握天赋配置：单个天赋等级，持续时间+20%
    local TM = { tn="图腾掌握", tb=20 }

    -- 组1：大地系图腾
    self:AddTimer(self.SPELL, BS["Earthbind Totem"],         45,  0,1,0, { gr=1, rc=true })
    self:AddTimer(self.SPELL, BS["Stoneclaw Totem"],         15,  0,1,0, { gr=1, rc=true })
    self:AddTimer(self.SPELL, BS["Stoneskin Totem"],         120, 0,1,0, { gr=1, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Strength of Earth Totem"], 120, 0,1,0, { gr=1, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Tremor Totem"],            120, 0,1,0, { gr=1, rc=true, d=TM })

    -- 组2：火焰系图腾
    self:AddTimer(self.SPELL, BS["Fire Nova Totem"],          5,  0,1,0, { gr=2, rc=true })
    self:AddTimer(self.SPELL, BS["Flametongue Totem"],       120, 0,1,0, { gr=2, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Frost Resistance Totem"],  120, 0,1,0, { gr=2, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Magma Totem"],             20,  0,1,0, { gr=2, rc=true })
    self:AddTimer(self.SPELL, BS["Searing Totem"],           30,  0,1,0, { gr=2, rc=true, d={rs=5 }})

    -- 组3：空气系图腾
    self:AddTimer(self.SPELL, BS["Grace of Air Totem"],      120, 0,1,0, { gr=3, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Grounding Totem"],         45,  0,1,0, { gr=3, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Nature Resistance Totem"], 120, 0,1,0, { gr=3, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Sentry Totem"],            300, 0,1,0, { gr=3, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Tranquil Air Totem"],      120, 0,1,0, { gr=3, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Windfury Totem"],          120, 0,1,0, { gr=3, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Windwall Totem"],          120, 0,1,0, { gr=3, rc=true, d=TM })

    -- 组4：水系图腾及其他
    self:AddTimer(self.SPELL, BS["Disease Cleansing Totem"], 120, 0,1,0, { gr=4, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Fire Resistance Totem"],   120, 0,1,0, { gr=4, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Healing Stream Totem"],    60,  0,1,0, { gr=4, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Mana Spring Totem"],       60,  0,1,0, { gr=4, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Mana Tide Totem"],         10,  0,1,0, { gr=4, rc=true, d=TM })
    self:AddTimer(self.SPELL, BS["Poison Cleansing Totem"],  120, 0,1,0, { gr=4, rc=true, d=TM })

    -- 震击类技能
    self:AddTimer(self.SPELL, BS["Earth Shock"],  2,  1,0,0)
    self:AddTimer(self.SPELL, BS["Molten Blast"], 0,  1,0,0, {
        castTime=2,
        gear={
            set2t3elemental={castTime=1.8}
        }
    })
    self:AddTimer(self.SPELL, BS["Flame Shock"],  15, 1,0,0, {
        rc=true,
        refreshBy={[BS["Molten Blast"]] = true}
    })
    self:AddTimer(self.SPELL, BS["Frost Shock"],  8,  1,0,0, { rc=true })
    self:AddTimer(self.SPELL, BS["Stormstrike"],  12, 0,1,1)

    -- 治疗类技能（非图腾）
    self:AddTimer(self.SPELL, BS["Healing Wave"],        0, 1,1,0, { ea={[BS["Ancestral Fortitude"]]=1, [BS["Healing Way"]]=1} })
    self:AddTimer(self.SPELL, BS["Lesser Healing Wave"], 0, 1,1,0, { ea={[BS["Ancestral Fortitude"]]=1} })

    -- 增益效果事件计时器
    self:AddTimer(self.EVENT, BS["Ancestral Fortitude"], 15, 1,1,0, { cr="GREEN",  a=1 })
    self:AddTimer(self.EVENT, BS["Clearcasting"],        15, 0,1,1, { cr="GREEN",  a=1 })
    self:AddTimer(self.EVENT, BS["Healing Way"],         15, 1,1,0, { cr="GREEN" })
    self:AddTimer(self.EVENT, BS["Flurry"],              15, 0,1,1, { cr="MAROON", a=1, romc=true })
end

table.insert(Chronometer.dataSetup, Chronometer.ShamanSetup)