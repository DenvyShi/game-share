--<< ====================================================================== >>--
-- 配置计时器                                                                 --
--<< ====================================================================== >>--

-- rc => 冷却时间(ReCast), ea => 前置事件(event ahead)

-- 导入Babble-Spell-2.2库用于获取法术名称
local BS = AceLibrary("Babble-Spell-2.2")
-- 导入AceLocale-2.2库用于本地化支持
local L = AceLibrary("AceLocale-2.2"):new("Chronometer")

-- 战士职业计时器配置函数
function Chronometer:WarriorSetup()
    local _, eclass = UnitClass("player")
    -- 仅当玩家职业为战士时执行配置
    if eclass ~= "WARRIOR" then return end
    
    -- 添加各种战士技能计时器
    -- 参数说明: 类型, 名称, 持续时间, 是否为目标指向, 是否为增益效果, 是否为自身或选中目标, 额外参数
    -- 战斗怒吼: 持续120秒, 非目标指向, 增益效果, 无目标选择
    -- 额外参数: 有冷却时间, 受" booming Voice(洪亮之声)"天赋影响(延长10秒)
    self:AddTimer(self.SPELL, BS["Battle Shout"],       120, 0,1,0, { rc=true, d={tn=BS["Booming Voice"], tp=5, tb=10} })
    -- 狂怒之怒: 持续10秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Berserker Rage"],      10, 0,1,1)
    -- 血性狂暴: 持续10秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Bloodrage"],           10, 0,1,1)
    -- 嗜血: 无持续时间, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有前置事件"嗜血"
    self:AddTimer(self.SPELL, BS["Bloodthirst"],          0, 1,0,0, { ea={[BS["Bloodthirst"]]=1} }) 
    -- 挑战怒吼: 持续6秒, 非目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Challenging Shout"],    6, 0,0,0)
    -- 冲锋: 无持续时间, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有前置事件"冲锋击晕"
    self:AddTimer(self.SPELL, BS["Charge"],               0, 1,0,0, { ea={[BS["Charge Stun"]]=1} })
    -- 震荡猛击: 持续5秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Concussion Blow"],      5, 1,0,0)
    -- 死亡之愿: 持续30秒, 非目标指向, 非增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Death Wish"],          30, 0,0,1)
    -- 挫志怒吼: 持续30秒, 非目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有冷却时间, 受"洪亮之声"天赋影响(延长10秒)
    self:AddTimer(self.SPELL, BS["Demoralizing Shout"],  30, 0,0,0, { rc=true, d={tn=BS["Booming Voice"], tp=5, tb=10} })
    -- 缴械: 持续10秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有冷却时间, 受"强化缴械"天赋影响(延长1秒)
    self:AddTimer(self.SPELL, BS["Disarm"],              10, 1,0,0, { rc=true, d={tn=BS["Improved Disarm"], tb=1} })
    -- 断筋: 持续15秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 强化缴械
    self:AddTimer(self.SPELL, BS["Hamstring"],           15, 1,0,0, { rc=true })
    -- 拦截: 无持续时间, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有前置事件"拦截击晕"
    self:AddTimer(self.SPELL, BS["Intercept"],            0, 1,0,0, { ea={[BS["Intercept Stun"]]=1} })
    -- 破胆怒吼: 持续8秒, 非目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Intimidating Shout"],   8, 0,0,0)
    -- 破釜沉舟: 持续20秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Last Stand"],          20, 0,1,1)
    -- 嘲讽: 持续6秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Mocking Blow"],         6, 1,0,0)
    -- 致死打击: 持续10秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Mortal Strike"],       10, 1,0,0)
    -- 刺耳怒吼: 持续6秒, 非目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Piercing Howl"],        6, 0,0,0)
    -- 拳击: 持续4秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Pummel"],               4, 1,0,0)
    -- 鲁莽: 持续15秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Recklessness"],        15, 0,1,1)
    -- 撕裂: 持续21秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 受技能等级影响(持续时间9,12,15,18秒)
    self:AddTimer(self.SPELL, BS["Rend"],                21, 1,0,0, { d={rt={9,12,15,18}} })
    -- 反击: 持续15秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Retaliation"],         15, 0,1,1)
    -- 复仇: 无持续时间, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有前置事件"复仇击晕"(概率2)
    self:AddTimer(self.SPELL, BS["Revenge"],              0, 1,0,0, { ea={[BS["Revenge Stun"]]=2} })
    -- 盾击: 持续6秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有前置事件"盾击-沉默"
    self:AddTimer(self.SPELL, BS["Shield Bash"],          6, 1,0,0, { ea={[BS["Shield Bash - Silenced"]]=1} })
    -- 盾牌格挡: 持续5秒, 非目标指向, 增益效果, 自身生效
    -- 额外参数: 受"强化盾牌格挡"天赋影响(持续时间增加0.5,1,2秒)
    self:AddTimer(self.SPELL, BS["Shield Block"],         5, 0,1,1, { d={tn=BS["Improved Shield Block"], tt={0.5, 1, 2}} })
    -- 盾墙: 持续10秒, 非目标指向, 增益效果, 自身生效
    -- 额外参数: 受"强化盾牌格挡"天赋影响(延长3秒, 冷却时间减少2分钟)
    self:AddTimer(self.SPELL, BS["Shield Wall"],         10, 0,1,1, { d={tn=BS["Improved Shield Wall"], tb=3, ts=2} })
    -- 破甲攻击: 持续30秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有冷却时间
    self:AddTimer(self.SPELL, BS["Sunder Armor"],        30, 1,0,0, { rc=true } )
    -- 横扫攻击: 持续20秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.SPELL, BS["Sweeping Strikes"],    20, 0,1,1)
    -- 嘲讽: 持续3秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.SPELL, BS["Taunt"],                3, 1,0,0)
    -- 雷霆一击: 持续10秒, 非目标指向, 非增益效果, 无目标选择
    -- 额外参数: 有冷却时间, 受技能等级影响(范围4码)
    self:AddTimer(self.SPELL, BS["Thunder Clap"],        10, 0,0,0, { rc=true, d={rs=4} })

    -- 添加各种战士事件计时器
    -- 血之狂热: 持续6秒, 非目标指向, 增益效果, 自身生效
    -- 额外参数: 可叠加(a=1), 颜色为绿色
    self:AddTimer(self.EVENT, BS["Blood Craze"],          6, 0,1,1, { a=1, cr="GREEN" })
    -- 嗜血效果: 持续8秒, 非目标指向, 增益效果, 自身生效
    self:AddTimer(self.EVENT, BS["Bloodthirst"],          8, 0,1,1)
    -- 冲锋击晕: 持续1秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.EVENT, BS["Charge Stun"],          1, 1,0,0) --, { xn=BS["Charge"] })
    -- 重伤: 持续12秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 可叠加(a=1), 颜色为绿色
    self:AddTimer(self.EVENT, BS["Deep Wounds"],         12, 1,0,0, { a=1, cr="GREEN" })
    -- 激怒: 持续12秒, 非目标指向, 增益效果, 自身生效
    -- 额外参数: 可叠加(a=1), 颜色为绿色
    self:AddTimer(self.EVENT, BS["Enrage"],              12, 0,1,1, { a=1, cr="GREEN" })
    -- 强化断筋: 持续5秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 颜色为绿色
    self:AddTimer(self.EVENT, BS["Improved Hamstring"],   5, 1,0,0, { cr="GREEN" })
    -- 拦截击晕: 持续3秒, 目标指向, 非增益效果, 无目标选择
    self:AddTimer(self.EVENT, BS["Intercept Stun"],       3, 1,0,0) --, { xn=BS["Intercept"] })
    -- 锤类武器击晕效果: 持续3秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 颜色为绿色, 可叠加(a=1), 关联"锤类武器专精"
    self:AddTimer(self.EVENT, BS["Mace Stun Effect"],     3, 1,0,0, { cr="GREEN", a=1, xn=BS["Mace Specialization"] })
    -- 复仇击晕: 持续3秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 颜色为绿色, 关联"复仇"技能
    self:AddTimer(self.EVENT, BS["Revenge Stun"],         3, 1,0,0, { cr="GREEN", xn=BS["Revenge"] })
    -- 盾击-沉默: 持续3秒, 目标指向, 非增益效果, 无目标选择
    -- 额外参数: 颜色为绿色, 关联"盾击"技能
    self:AddTimer(self.EVENT, BS["Shield Bash - Silenced"], 3, 1,0,0, { cr="GREEN", xn=BS["Shield Bash"] })

    -- 以下为注释掉的技能计时器(可能因特定条件限制暂未启用)
    -- 斩杀: 仅对生命值20%以下的敌人可用
    --self:AddTimer(A.SKILL, C.EXECUTE,              5, 0,1,1, { cr="YELLOW", rc=true })
    -- 压制: 仅在目标闪避后可用
    --self:AddTimer(A.SKILL, C.OVERPOWER,            5, 0,1,1, { cr="YELLOW", rc=true })
    -- 复仇: 必须在格挡、闪避或招架后使用
    --self:AddTimer(A.SKILL, C.REVENGE,              5, 0,1,1, { cr="YELLOW", rc=true })
end

-- 将战士配置函数添加到Chronometer的数据配置列表中
table.insert(Chronometer.dataSetup, Chronometer.WarriorSetup)