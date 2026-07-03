--<< ====================================================================== >>--
-- 配置计时器（德鲁伊职业相关）                                                --
--<< ====================================================================== >>--
-- 引入Babble-Spell-2.2库（用于获取法术名称）
local BS = AceLibrary("Babble-Spell-2.2")
-- 引入AceLocale-2.2库并创建Chronometer的本地化对象
local L = AceLibrary("AceLocale-2.2"):new("Chronometer")

-- 定义德鲁伊计时器配置函数
function Chronometer:DruidSetup()
    -- 获取当前玩家的职业
    local _, eclass = UnitClass("player")
    -- 如果玩家不是德鲁伊，则不执行后续配置
    if eclass ~= "DRUID" then return end

    -- 添加计时器组（参数分别为组ID、是否显示、颜色）
    self:AddGroup(1, true,  "MAGENTA")    -- 组1：显示，洋红色
    self:AddGroup(2, false, "MAROON")     -- 组2：不显示，褐红色
    self:AddGroup(3, true,  "MAGENTA")    -- 组3：显示，洋红色

    -- 添加各种法术的计时器（参数含义：类型、法术名、持续时间、是否显示图标、是否显示边框、是否显示文本、额外参数）
    self:AddTimer(self.SPELL, BS["Abolish Poison"],         8, 1,1,1)  -- 解毒术：8秒，显示图标、边框、文本
    self:AddTimer(self.SPELL, BS["Bash"],                   2, 1,0,0, { d={rs=1, tn=BS["Brutal Impact"], tb=0.5} })  -- 猛击：2秒，仅显示图标；额外参数：可能与技能强化相关（ Brutal Impact天赋影响）
    self:AddTimer(self.SPELL, BS["Barkskin"],              15, 0,1,1)  -- 树皮术：15秒，显示边框、文本，不显示图标
    self:AddTimer(self.SPELL, BS["Dash"],                  15, 0,1,1)  -- 急奔：15秒，显示边框、文本，不显示图标
    self:AddTimer(self.SPELL, BS["Demoralizing Roar"],     30, 0,0,0, { rc=true })  -- 挫志咆哮：30秒，不显示图标、边框、文本；额外参数：可刷新
    self:AddTimer(self.SPELL, BS["Enrage"],                10, 0,1,1)  -- 激怒：10秒，显示边框、文本，不显示图标
    self:AddTimer(self.SPELL, BS["Entangling Roots"],      12, 1,0,0, { gr=1, rc=true, d={rs=3} })  -- 纠缠根须：12秒，仅显示图标；额外参数：属于组1、可刷新、每级增加3秒时间
    self:AddTimer(self.SPELL, BS["Faerie Fire"],           40, 1,0,0, { gr=2, rc=true })  -- 精灵之火：40秒，仅显示图标；额外参数：属于组2、可刷新
    self:AddTimer(self.SPELL, BS["Faerie Fire (Feral)"],     40, 1,0,0, { gr=2, rc=true })  -- 野性精灵之火：40秒，仅显示图标；额外参数：属于组2、可刷新
    self:AddTimer(self.SPELL, BS["Feral Charge"],           4, 1,0,0)  -- 野性冲锋：4秒，仅显示图标
    self:AddTimer(self.SPELL, BS["Frenzied Regeneration"], 10, 0,1,1)  -- 狂乱再生：10秒，显示边框、文本，不显示图标
    self:AddTimer(self.SPELL, BS["Hibernate"],             20, 1,0,0, { gr=3, rc=true, d={rs=10}  })  -- 休眠：20秒，仅显示图标；额外参数：属于组3、可刷新、可能有10秒相关延迟
    self:AddTimer(self.SPELL, BS["Innervate"],             20, 1,1,1)  -- 激活：20秒，显示图标、边框、文本
    self:AddTimer(self.SPELL, BS["Insect Swarm"],          18, 1,0,0, { rc=true })  -- 虫群：18秒，仅显示图标；额外参数：可刷新
    self:AddTimer(self.SPELL, BS["Nature's Grasp"],        45, 0,1,1, { cr="BLUE", ea={[BS["Entangling Roots"]]=45} })  -- 自然之握：45秒，显示边框、文本，不显示图标；额外参数：颜色为蓝色，与纠缠根须有45秒关联效果
    -- 月火术：默认18秒，1级特殊为9秒，可刷新
    self:AddTimer(self.SPELL, BS["Moonfire"],              18, 1,0,0, { rc=true, d={rt={[1]=9}} })
    self:AddTimer(self.SPELL, BS["Pounce"],                 2, 1,0,0, { ea={[BS["Pounce Bleed"]]=1} })  -- 突袭：2秒，仅显示图标；额外参数：与突袭流血有1秒关联效果
    self:AddTimer(self.SPELL, BS["Rake"],                   9, 1,0,0, { rc=true })  -- 斜掠：9秒，仅显示图标；额外参数：可刷新
    self:AddTimer(self.SPELL, BS["Regrowth"],              20, 1,1,1, { rc=true, mc=BS["Swiftmend"] })  -- 愈合：20秒，显示图标、边框、文本；额外参数：可刷新，与迅捷治愈相关联
    self:AddTimer(self.SPELL, BS["Rejuvenation"],          12, 1,1,1, { rc=true, mc=BS["Swiftmend"] })  -- 回春术：12秒，显示图标、边框、文本；额外参数：可刷新，与迅捷治愈相关联
    self:AddTimer(self.SPELL, BS["Rip"],                   10, 1,0,0, { rc=true, d={cp=2, b=10, i=2} })  -- 撕扯：1星10秒，每增加1星延长2秒，仅显示图标；额外参数：可刷新，关联连击点（基础值10秒，每星增量2秒）
    self:AddTimer(self.SPELL, BS["Soothe Animal"],         15, 1,0,0, { rc=true })  -- 安抚动物：15秒，仅显示图标；额外参数：可刷新
    self:AddTimer(self.SPELL, BS["Starfire"],               0, 1,0,0, { ea={[BS["Starfire Stun"]]=1} })  -- 星火术：0秒（可能为即时效果），仅显示图标；额外参数：与星火术眩晕有1秒关联效果
    self:AddTimer(self.SPELL, BS["Tiger's Fury"], 6, 0,1,1, { rc=true,d={tn=BS["Blood Frenzy"],tb=6,tl=2 } }) -- 猛虎之怒：基础6秒，受Blood Frenzy天赋影响（2层，每层+6秒），保留可刷新属性，关联Blood Frenzy天赋 ，每层天赋增加6秒，添加tl=2（表示最多2层）

    -- 添加事件相关计时器（参数含义类似，类型为EVENT）
    self:AddTimer(self.EVENT, BS["Entangling Roots"],      12, 1,0,1, { gr=1, d={rs=3}, a=1 })  -- 纠缠根须事件：12秒，显示图标、文本，不显示边框；额外参数：属于组1、可能有3秒相关延迟、a=1（可能为事件触发标识）
    self:AddTimer(self.EVENT, BS["Nature's Grace"],        15, 0,1,1, { cr="GREEN", a=1 })  -- 自然的优雅事件：15秒，显示边框、文本，不显示图标；额外参数：颜色为绿色、a=1
    self:AddTimer(self.EVENT, BS["Clearcasting"],          15, 0,1,1, { cr="GREEN", a=1 })  -- 清晰预兆事件：15秒，显示边框、文本，不显示图标；额外参数：颜色为绿色、a=1
    self:AddTimer(self.EVENT, BS["Pounce Bleed"],          18, 1,0,0, { xn=BS["Pounce"] })  -- 突袭流血事件：18秒，仅显示图标；额外参数：关联突袭技能
    self:AddTimer(self.EVENT, BS["Starfire Stun"],          3, 1,0,0, { xn=BS["Starfire"] })  -- 星火术眩晕事件：3秒，仅显示图标；额外参数：关联星火术技能
    self:AddTimer(self.EVENT, "斗转星移", 8, 0, 1, 1, { cr="GREEN", a=1, tx="Interface\\Icons\\ability_druid_eclipse" })
    self:AddTimer(self.EVENT, "日蚀", 15, 0, 1, 1, { cr="GREEN", a=1, tx="Interface\\Icons\\Spell_Nature_AbolishMagic" })
    self:AddTimer(self.EVENT, "月蚀", 15, 0, 1, 1, { cr="GREEN", a=1, tx="Interface\\Icons\\Spell_Nature_WispSplode" })
	    
    --==============================
    -- 新增：T3套装特效计时器
    --==============================
    -- 平衡：6件T3触发，持续6秒，红色显示
    self:AddTimer(self.EVENT, "平衡", 6, 1, 0, 0, { cr="RED", a=1, tx="Interface\\Icons\\Spell_Nature_AstralRecal" })
end

-- 将德鲁伊配置函数添加到Chronometer的配置列表中
table.insert(Chronometer.dataSetup, Chronometer.DruidSetup)