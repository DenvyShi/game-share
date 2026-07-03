--<< ====================================================================== >>--
-- 盗贼职业技能与事件计时器配置
--<< ====================================================================== >>--

-- 引入多语言法术名称库
local BS = AceLibrary("Babble-Spell-2.2")

-- 盗贼职业计时器初始化函数
function Chronometer:RogueSetup()
    -- 检测玩家职业，非盗贼直接返回
    local _, eclass = UnitClass("player")
    if eclass ~= "ROGUE" then return end

    --==============================
    -- 技能类计时器（SPELL）
    --==============================
    -- 肾上腺激素：持续15秒
    self:AddTimer(self.SPELL, BS["Adrenaline Rush"], 15, 0, 1, 1)
    -- 致盲：持续10秒
    self:AddTimer(self.SPELL, BS["Blind"],           10, 1, 0, 0)
    -- 偷袭：持续4秒
    self:AddTimer(self.SPELL, BS["Cheap Shot"],       4, 1, 0, 0)
    -- 扰乱：持续10秒
    self:AddTimer(self.SPELL, BS["Distract"],        10, 0, 0, 0)
    -- 闪避：持续15秒
    self:AddTimer(self.SPELL, BS["Evasion"],         15, 0, 1, 1)
    -- 破甲：持续30秒
    self:AddTimer(self.SPELL, BS["Expose Armor"],    30, 1, 0, 0)
    -- 绞喉：持续18秒
    self:AddTimer(self.SPELL, BS["Garrote"],         18, 1, 0, 0)
    -- 凿击：持续4秒，支持「强化凿击」天赋（每层+0.5秒）
    self:AddTimer(self.SPELL, BS["Gouge"],            4, 1, 0, 0, { d={tn=BS["Improved Gouge"], ta=0.5} })
    -- 出血：持续15秒
    self:AddTimer(self.SPELL, BS["Hemorrhage"],      15, 1, 0, 0)
    -- 脚踢：持续5秒，关联「脚踢 - 沉默」效果
    self:AddTimer(self.SPELL, BS["Kick"],             5, 1, 0, 0, { ea={[BS["Kick - Silenced"]]=1} })
    -- 肾击：基础1秒，支持连击点动态时长
    self:AddTimer(self.SPELL, BS["Kidney Shot"],      1, 1, 0, 0, { d={rs=1, cp=1} })
    -- 反击：持续6秒
    self:AddTimer(self.SPELL, BS["Riposte"],          6, 1, 0, 0)
    -- 割裂：基础8秒（2星），支持「血腥气息」天赋（每层+2秒，最多3层）
    self:AddTimer(self.SPELL, BS["Rupture"], 8, 1, 0, 0, {
        d={
          cp=2,
          tn=BS["Taste for Blood"],
          ta=2,
          tp=3
        }
      })
    -- 闷棍：持续25秒
    self:AddTimer(self.SPELL, BS["Sap"],             25, 1, 0, 0, { d={rs=10} })
    -- 切割：基础9秒（3星），支持「强化刃术」天赋（每层+15%，最多3层）
    self:AddTimer(self.SPELL, BS["Slice and Dice"], 9, 0, 1, 1, {
        d={
          cp=3,
          tn=BS["Improved Blade Tactics"],
          tb=15,
          tp=3
        }
      })
    -- 疾跑：持续15秒
    self:AddTimer(self.SPELL, BS["Sprint"],          15, 0, 1, 1)
    -- 消失：持续10秒
    self:AddTimer(self.SPELL, BS["Vanish"],          10, 0, 1, 1)
    -- 毒伤：基础12秒，支持连击点（每星+4秒），自身buff监控，紫色显示
    self:AddTimer(self.SPELL, BS["Envenom"], 12, 0, 1, 1, { d={cp=4, rt=rt}, cr="PURPLE" })

    --==============================
    -- 事件类计时器（EVENT）
    --==============================
    -- 脚踢 - 沉默：持续2秒，绿色显示
    self:AddTimer(self.EVENT, BS["Kick - Silenced"],    2, 1, 0, 0, { cr="GREEN" })
    -- 锤类武器击晕：持续3秒，绿色显示，关联「锤类专精」天赋
    self:AddTimer(self.EVENT, BS["Mace Stun Effect"], 3, 1, 0, 0, { cr="GREEN", a=1, xn=BS["Mace Specialization"] })
    -- 冷酷：持续20秒，绿色显示
    self:AddTimer(self.EVENT, BS["Remorseless"],     20, 0, 1, 1, { cr="GREEN", a=1 })
    -- 致命毒药：持续12秒，绿色显示
    self:AddTimer(self.EVENT, BS["Deadly Poison"],    12, 1, 0, 0, { cr="GREEN", a=1 })
    -- 致伤毒药：持续15秒，绿色显示
    self:AddTimer(self.EVENT, BS["Wound Poison"],     15, 1, 0, 0, { cr="GREEN", a=1 })
    -- 麻痹毒药：持续14秒，绿色显示，支持多档时长
    self:AddTimer(self.EVENT, BS["Mind-numbing Poison"], 14, 1, 0, 0, { cr="GREEN", a=1, d={rt={10,12,14}} })
    -- 致残毒药：持续12秒，绿色显示
    self:AddTimer(self.EVENT, BS["Crippling Poison"],  12, 1, 0, 0, { cr="GREEN", a=1 })
    -- 无情打击：持续30秒，绿色显示，自身buff，由终结技触发
    self:AddTimer(self.EVENT, BS["Relentless Strikes"], 30, 0, 1, 1, { cr="GREEN", a=1 })
    
    --==============================
    -- 新增：T3.5套装特效计时器
    --==============================
    -- 运筹（Dispatch）：3件T3.5触发，持续6秒，黄色显示
    self:AddTimer(self.EVENT, "运筹", 6, 0, 1, 1, { cr="YELLOW", a=1, tx="Interface\\Icons\\Ability_Rogue_SliceDice" })
    -- 夜刃（Nightblade）：5件T3.5触发，持续6秒，黄色显示
    self:AddTimer(self.EVENT, "夜刃", 6, 0, 1, 1, { cr="YELLOW", a=1, tx="Interface\\Icons\\INV_Sword_02" })
end

-- 注册盗贼配置函数到初始化列表
table.insert(Chronometer.dataSetup, Chronometer.RogueSetup)