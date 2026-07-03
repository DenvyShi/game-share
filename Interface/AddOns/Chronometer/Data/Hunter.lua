--<< ====================================================================== >>--
-- 配置计时器（猎人职业相关）                                                --
--<< ====================================================================== >>--
-- 引入Babble-Spell-2.2库，用于获取法术名称
local BS = AceLibrary("Babble-Spell-2.2")

-- 定义猎人职业的计时器配置函数
function Chronometer:HunterSetup()
    -- 获取当前玩家的职业，若不是猎人则退出函数
    local _, eclass = UnitClass("player")
    if eclass ~= "HUNTER" then return end

    -- 添加两个计时器组，参数分别为：组ID、是否启用、颜色
    self:AddGroup(1, true,  "MAGENTA")  -- 组1：启用，洋红色
    self:AddGroup(2, false, "MAROON")   -- 组2：禁用，褐红色

    -- 添加各种法术的计时器（法术类型）
    -- 参数说明：类型（法术）、法术名称、持续时间、是否显示图标、是否显示倒计时、是否为增益效果、附加参数
    self:AddTimer(self.SPELL, BS["Bestial Wrath"],           18, 0,1,1)  -- 狂野怒火：18秒，不显示图标，显示倒计时，增益效果
    self:AddTimer(self.SPELL, BS["Concussive Shot"],          4, 1,0,0, { ea={[BS["Improved Concussive Shot"]]=4} })  -- 震荡射击：4秒，显示图标，不显示倒计时，非增益效果，附加：强化震荡射击效果持续4秒
    self:AddTimer(self.SPELL, BS["Counterattack"],            5, 1,0,0)  -- 反击：5秒，显示图标，不显示倒计时，非增益效果
    self:AddTimer(self.SPELL, BS["Deterrence"],              10, 0,1,1)  -- 威慑：10秒，不显示图标，显示倒计时，增益效果
    self:AddTimer(self.SPELL, BS["Explosive Trap"],          60, 0,0,0, { gr=1, rc=true })  -- 移除ea={[BS["Explosive Trap Effect"]]=60}
    --self:AddTimer(self.SPELL, BS["Explosive Trap"],          60, 0,0,0, { gr=1, rc=true, ea={[BS["Explosive Trap Effect"]]=60}  })  -- 爆炸陷阱：60秒，不显示图标，不显示倒计时，非增益效果，附加：归组1、可刷新、爆炸陷阱效果持续60秒
    self:AddTimer(self.SPELL, BS["Freezing Trap"],           60, 0,0,0, { gr=1, rc=true, ea={[BS["Freezing Trap Effect"]]=60}   })  -- 冰冻陷阱：60秒，不显示图标，不显示倒计时，非增益效果，附加：归组1、可刷新、冰冻陷阱效果持续60秒
    self:AddTimer(self.SPELL, BS["Frost Trap"],              60, 0,0,0, { gr=1, rc=true, ea={[BS["Frost Trap Aura"]]=60}      })  -- 冰霜陷阱：60秒，不显示图标，不显示倒计时，非增益效果，附加：归组1、可刷新、冰霜陷阱光环持续60秒
    self:AddTimer(self.SPELL, BS["Flare"],                   30, 0,0,0, { rc=true })  -- 照明弹：30秒，不显示图标，不显示倒计时，非增益效果，附加：可刷新
    self:AddTimer(self.SPELL, BS["Hunter's Mark"],          120, 1,0,0, { rc=true })  -- 猎人印记：120秒，显示图标，不显示倒计时，非增益效果，附加：可刷新
    self:AddTimer(self.SPELL, BS["Immolation Trap"],         60, 0,0,0, { gr=1, rc=true }) --移除ea={[BS["Immolation Trap Effect"]]=60} })  -- 献祭陷阱：60秒，不显示图标，不显示倒计时，非增益效果，附加：归组1、献祭陷阱效果持续60秒
    self:AddTimer(self.SPELL, BS["Rapid Fire"],              15, 0,1,1)  -- 急速射击：15秒，不显示图标，显示倒计时，增益效果
    self:AddTimer(self.SPELL, BS["Scare Beast"],             10, 1,0,0, { rc=true, d={rs=5} })  -- 恐吓野兽：10秒，显示图标，不显示倒计时，非增益效果，附加：可刷新、额外数据{重置时间5秒}
    self:AddTimer(self.SPELL, BS["Scatter Shot"],             4, 1,0,0)  -- 驱散射击：4秒，显示图标，不显示倒计时，非增益效果
    self:AddTimer(self.SPELL, BS["Scorpid Sting"],           20, 1,0,0, { gr=2, rc=true })  -- 毒蝎钉刺：20秒，显示图标，不显示倒计时，非增益效果，附加：归组2、可刷新
    self:AddTimer(self.SPELL, BS["Serpent Sting"],           15, 1,0,0, { gr=2, rc=true })  -- 毒蛇钉刺：15秒，显示图标，不显示倒计时，非增益效果，附加：归组2、可刷新
    self:AddTimer(self.SPELL, BS["Viper Sting"],              8, 1,0,0, { gr=2, rc=true })  -- 蝰蛇钉刺：8秒，显示图标，不显示倒计时，非增益效果，附加：归组2、可刷新
    self:AddTimer(self.SPELL, BS["Wing Clip"],               10, 1,0,0, { rc=true, ea={[BS["Improved Wing Clip"]]=10} })  -- 翼击：10秒，显示图标，不显示倒计时，非增益效果，附加：可刷新、强化翼击效果持续10秒
    self:AddTimer(self.SPELL, BS["Wyvern Sting"],            12, 1,0,0, { gr=2, rc=true })  -- 翼龙钉刺：12秒，显示图标，不显示倒计时，非增益效果，附加：归组2、可刷新
    self:AddTimer(self.SPELL, BS["Feed Pet"],         		 20, 0,0,0)  -- 喂养宠物：20秒，不显示图标，不显示倒计时，非增益效果

    -- 添加各种事件的计时器（事件类型）
    -- 参数说明：类型（事件）、事件名称、持续时间、是否显示图标、是否显示倒计时、是否为增益效果、附加参数
    self:AddTimer(self.EVENT, BS["Explosive Trap Effect"],   20, 1,0,1, { gr=1, xn=BS["Explosive Trap"] })  -- 爆炸陷阱效果：20秒，显示图标，不显示倒计时，增益效果，附加：归组1、关联法术为爆炸陷阱
    self:AddTimer(self.EVENT, BS["Freezing Trap Effect"],    10, 1,0,1, { gr=1, d={rs=5, tn=BS["Clever Traps"], tb=0.15, tp=1}, xn=BS["Freezing Trap"] })  -- 冰冻陷阱效果：10秒，显示图标，不显示倒计时，增益效果，附加：归组1、额外数据{重置时间5秒、天赋名称=精巧陷阱、天赋加成=0.15、天赋点数=1}、关联法术为冰冻陷阱
    self:AddTimer(self.EVENT, BS["Frost Trap Aura"],       30, 0,0,0, { gr=1, d={tn=BS["Clever Traps"], tb=0.15, tp=1}, xn=BS["Frost Trap"] })  -- 冰霜陷阱光环：30秒，不显示图标，不显示倒计时，非增益效果，附加：归组1、额外数据{天赋名称=精巧陷阱、天赋加成=0.15、天赋点数=1}、关联法术为冰霜陷阱
    self:AddTimer(self.EVENT, BS["Immolation Trap Effect"],  15, 1,0,1, { gr=1, xn=BS["Immolation Trap"] })  -- 献祭陷阱效果：15秒，显示图标，不显示倒计时，增益效果，附加：归组1、关联法术为献祭陷阱
    self:AddTimer(self.EVENT, BS["Improved Concussive Shot"], 3, 1,0,0, { cr="GREEN", xn=BS["Concussive Shot"] })  -- 强化震荡射击：3秒，显示图标，不显示倒计时，非增益效果，附加：颜色=绿色、关联法术为震荡射击
    self:AddTimer(self.EVENT, BS["Improved Wing Clip"],       5, 1,0,0, { cr="GREEN", xn=BS["Wing Clip"] } )  -- 强化翼击：5秒，显示图标，不显示倒计时，非增益效果，附加：颜色=绿色、关联法术为翼击
    self:AddTimer(self.EVENT, BS["Quick Shots"],             12, 0,1,1, { a=1, cr="GREEN" })  -- 快速射击：12秒，不显示图标，显示倒计时，增益效果，附加：参数a=1、颜色=绿色

    -- 注释掉的技能计时器（未启用）
    --self:AddTimer(A.SKILL, C.COUNTERATTACK,            5, 0,1,0, { cr="YELLOW", rc=true })  -- 反击技能：5秒，不显示图标，显示倒计时，非增益效果，附加：颜色=黄色、可刷新
    --self:AddTimer(A.SKILL, C.MONGOOSE_BITE,            5, 0,1,0, { cr="YELLOW", rc=true })  -- 猫鼬撕咬技能：5秒，不显示图标，显示倒计时，非增益效果，附加：颜色=黄色、可刷新
end

-- 将猎人计时器配置函数添加到Chronometer的配置列表中
table.insert(Chronometer.dataSetup, Chronometer.HunterSetup)