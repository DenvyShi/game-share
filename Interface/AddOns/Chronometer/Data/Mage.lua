--<< ====================================================================== >>--
-- 设置计时器（法师职业相关）                                                  --
--<< ====================================================================== >>--
-- 引入Babble-Spell-2.2库，用于获取法术名称（多语言支持）
local BS = AceLibrary("Babble-Spell-2.2")

-- 定义法师职业的计时器设置函数
function Chronometer:MageSetup()
    -- 获取当前玩家的职业，若不是法师则退出函数
    local _, eclass = UnitClass("player")
    if eclass ~= "MAGE" then return end

    -- 添加一个分组（组ID为1，启用状态，颜色为品红色）
    self:AddGroup(1, true, "MAGENTA")

    -- 添加各种法术的计时器（法术类型）
    self:AddTimer(self.SPELL, BS["Arcane Power"],  15, 0,1,1)  -- 奥术强化：持续15秒
    self:AddTimer(self.SPELL, BS["Blast Wave"],     6, 0,0,0)   -- 冲击波：持续6秒
    -- 寒冰锥：持续8秒，附带Permafrost（永久冰冻）相关效果
    self:AddTimer(self.SPELL, BS["Cone of Cold"],   8, 0,0,0, { rc=true, d={tn=BS["Permafrost"], tb=1} })
    -- 法术反制：持续10秒，附带沉默效果关联
    self:AddTimer(self.SPELL, BS["Counterspell"],  10, 1,0,0, { ea={[BS["Counterspell - Silenced"]]=1} })
    self:AddTimer(self.SPELL, BS["Detect Magic"], 120, 1,0,0, { rc=true })  -- 侦测魔法：持续120秒
    self:AddTimer(self.SPELL, BS["Fire Ward"],     30, 0,1,1)  -- 火焰结界：持续30秒
    -- 火球术：持续8秒，附带点燃和冲击效果，有随机时间参数
    self:AddTimer(self.SPELL, BS["Fireball"],       8, 1,0,0, { d={rt={4,6,6}}, ea={[BS["Ignite"]]=1, [BS["Impact"]]=1} })
    self:AddTimer(self.SPELL, BS["Flamestrike"],    8, 0,0,0)  -- 烈焰风暴：持续8秒
    self:AddTimer(self.SPELL, BS["Frost Nova"],     8, 0,0,0)  -- 冰霜新星：持续8秒
    self:AddTimer(self.SPELL, BS["Frost Ward"],    30, 0,1,0)  -- 冰霜结界：持续30秒
    -- 寒冰箭：持续9秒，附带永久冰冻和寒冬刺骨效果，有随机时间参数
    self:AddTimer(self.SPELL, BS["Frostbolt"],      9, 1,0,0, { d={rt={5,6,6,7,7,8,8}, tn=BS["Permafrost"], tb=1}, ea={[BS["Winter's Chill"]]=2} })
    self:AddTimer(self.SPELL, BS["Ice Barrier"],   60, 0,1,1)  -- 冰甲术：持续60秒
    self:AddTimer(self.SPELL, BS["Ice Block"],     10, 0,1,1)  -- 冰障术：持续10秒
    self:AddTimer(self.SPELL, BS["Mana Shield"],   60, 0,1,1, { rc=true })  -- 法力护盾：持续60秒
    -- 变形术：持续20秒，属于分组1，有随机时间参数
    self:AddTimer(self.SPELL, BS["Polymorph"],     20, 1,0,0, { gr=1, rc=true, d={rs=10} })
    self:AddTimer(self.SPELL, BS["Polymorph: Pig"],50, 1,0,0, { gr=1, rc=true })  -- 变形术：猪：持续50秒，属于分组1
    self:AddTimer(self.SPELL, BS["Polymorph: Turtle"],50, 1,0,0, { gr=1, rc=true })  -- 变形术：海龟：持续50秒，属于分组1
    -- 炎爆术：持续12秒，附带点燃和冲击效果
    self:AddTimer(self.SPELL, BS["Pyroblast"],     12, 1,0,0, { ea={[BS["Ignite"]]=1, [BS["Impact"]]=1} })
    -- 火球冲击：附带点燃和冲击效果
    self:AddTimer(self.SPELL, BS["Fire Blast"],     0, 1,0,0, { ea={[BS["Ignite"]]=1, [BS["Impact"]]=1} })
    -- 灼烧：附带火焰易伤、点燃和冲击效果
    self:AddTimer(self.SPELL, BS["Scorch"],         0, 1,0,0, { ea={[BS["Fire Vulnerability"]]=1, [BS["Ignite"]]=1, [BS["Impact"]]=1} })

    -- 添加各种事件的计时器（事件类型）
    self:AddTimer(self.EVENT, BS["Clearcasting"],         15, 0,1,1, { cr="GREEN", a=1 })  -- 清晰预兆：持续15秒，绿色
    -- 法术反制-沉默：持续4秒，绿色，关联反制技能
    self:AddTimer(self.EVENT, BS["Counterspell - Silenced"], 4, 1,0,0, { cr="GREEN", xn=BS["Counterspell"] })
    -- 火焰易伤：持续30秒，绿色，关联灼烧技能
    self:AddTimer(self.EVENT, BS["Fire Vulnerability"],   30, 1,0,0, { cr="GREEN", xn=BS["Scorch"] })
    self:AddTimer(self.EVENT, BS["Frostbite"],             5, 1,0,1, { cr="GREEN", a=1 })  -- 冻伤：持续5秒，绿色
    self:AddTimer(self.EVENT, BS["Ignite"],                4, 1,0,1, { cr="GREEN", a=1 })  -- 点燃：持续4秒，绿色
    self:AddTimer(self.EVENT, BS["Impact"],                2, 1,0,0, { cr="GREEN", a=1 })  -- 冲击：持续2秒，绿色
    self:AddTimer(self.EVENT, BS["Winter's Chill"],       15, 1,0,0, { cr="GREEN" })  -- 寒冬刺骨：持续15秒，绿色
    -- 寒冷：持续5秒，绿色，关联永久冰冻效果
    self:AddTimer(self.EVENT, BS["Chilled"],       		   5, 1,0,0, { cr="GREEN", a=1, d={tn=BS["Permafrost"],tb=1}})
    -- 暴风雪：持续1.5秒，绿色，关联永久冰冻效果
    self:AddTimer(self.EVENT, BS["Blizzard"],       	   1.5, 0,0,0, { cr="GREEN", d={tn=BS["Permafrost"],tb=1}})
end

-- 将法师设置函数插入到计时器的初始化列表中
table.insert(Chronometer.dataSetup, Chronometer.MageSetup)