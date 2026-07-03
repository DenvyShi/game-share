--<< ====================================================================== >>--
-- 设置计时器（圣骑士相关）                                                  --
--<< ====================================================================== >>--
-- 引入Babble-Spell-2.2库，用于获取法术名称的本地化支持
local BS = AceLibrary("Babble-Spell-2.2")

-- 定义圣骑士模块的设置函数
function Chronometer:PaladinSetup()
    -- 获取当前玩家的职业，若不是圣骑士则直接返回（不执行后续设置）
    local _, eclass = UnitClass("player")
    if eclass ~= "PALADIN" then return end

    -- 添加3个计时器组，分别设置为不同颜色和显示模式
    -- 参数说明：组ID，是否自动隐藏，颜色
    self:AddGroup(1, false, "CYAN")         -- 组1：青色，不自动隐藏
    self:AddGroup(2, true,  "NAVY")         -- 组2：深蓝色，自动隐藏
    self:AddGroup(3, true,  "MAGENTA")      -- 组3：品红色，自动隐藏

    -- 添加各种圣骑士技能的计时器（法术类型）
    -- 参数说明：类型（SPELL/EVENT），法术名称，持续时间，是否显示图标，是否显示剩余时间，是否显示冷却，额外参数
    self:AddTimer(self.SPELL, BS["Blessing of Freedom"],    10, 1,1,1, { gr=1, d={tn=BS["Guardian's Favor"], tb=3} })         -- 自由祝福：10秒，使用组1，受"守护者的宠爱"影响延长3秒
    self:AddTimer(self.SPELL, BS["Blessing of Kings"],     600, 1,1,1, { gr=1, rc=true })                                    -- 王者祝福：300秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Blessing of Light"],     600, 1,1,1, { gr=1, rc=true })                                    -- 光明祝福：300秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Blessing of Might"],     600, 1,1,1, { gr=1, rc=true })                                    -- 力量祝福：300秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Blessing of Protection"],  6, 1,1,1, { gr=1, d={rs=2}, ea={[BS["Forbearance"]]=1} })        -- 保护祝福：6秒，使用组1，有2秒施法时间，触发"自律"效果
    self:AddTimer(self.SPELL, BS["Blessing of Sacrifice"],  30, 1,1,1, { gr=1, rc=true })                                    -- 牺牲祝福：30秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Blessing of Salvation"], 600, 1,1,1, { gr=1, rc=true })                                    -- 拯救祝福：300秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Blessing of Sanctuary"], 600, 1,1,1, { gr=1, rc=true })                                    -- 庇护祝福：300秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Blessing of Wisdom"],    600, 1,1,1, { gr=1, rc=true })                                    -- 智慧祝福：300秒，使用组1，可刷新
    self:AddTimer(self.SPELL, BS["Consecration"],            8, 0,0,0)                                                       -- 奉献：8秒，不显示图标、剩余时间和冷却
    self:AddTimer(self.SPELL, BS["Divine Protection"],       6, 0,1,1, { cr="BLUE", d={rs=2}, ea={[BS["Forbearance"]]=1} })   -- 神圣保护：6秒，显示剩余时间和冷却，蓝色，2秒施法时间，触发"自律"
    self:AddTimer(self.SPELL, BS["Divine Shield"],          10, 0,1,1, { cr="BLUE", d={rs=2}, ea={[BS["Forbearance"]]=1} })   -- 圣盾术：10秒，显示剩余时间和冷却，蓝色，2秒施法时间，触发"自律"
    self:AddTimer(self.SPELL, BS["Hammer of Justice"],       6, 1,0,0, { d={rt={3,4,5,6}} })                                 -- 公正之锤：6秒，显示图标，可作用于3-6目标
    self:AddTimer(self.SPELL, BS["Holy Shield"],            10, 1,0,0       )                            -- 神圣之盾：10秒，显示图标
    self:AddTimer(self.SPELL, BS["Judgement"],               0, 1,0,0, { gr=2, ea={[BS["Judgement of Justice"]]=1, [BS["Judgement of Light"]]=1, [BS["Judgement of Wisdom"]]=1, [BS["Judgement of the Crusader"]]=1} })  -- 审判：0秒，使用组2，关联多种审判效果
    self:AddTimer(self.SPELL, BS["Lay on Hands"],            0, 1,1,1, { ea={[BS["Lay on Hands"]]=2} })                       -- 圣疗术：0秒，显示图标、剩余时间和冷却，受自身效果影响
    self:AddTimer(self.SPELL, BS["Repentance"],              6, 1,0,0)                                                       -- 忏悔：6秒，显示图标
    self:AddTimer(self.SPELL, BS["Seal of Command"],        30, 0,1,1, { gr=2, rc=true })                                    -- 命令圣印：30秒，显示剩余时间和冷却，使用组2，可刷新
    self:AddTimer(self.SPELL, BS["Seal of Justice"],        30, 0,1,1, { gr=2, rc=true })                                    -- 公正圣印：30秒，显示剩余时间和冷却，使用组2，可刷新
    self:AddTimer(self.SPELL, BS["Seal of Light"],          30, 0,1,1, { gr=2, rc=true })                                    -- 光明圣印：30秒，显示剩余时间和冷却，使用组2，可刷新
    self:AddTimer(self.SPELL, BS["Seal of Righteousness"],  30, 0,1,1, { gr=2, rc=true })                                    -- 正义圣印：30秒，显示剩余时间和冷却，使用组2，可刷新
    self:AddTimer(self.SPELL, BS["Seal of the Crusader"],   30, 0,1,1, { gr=2, rc=true })                                    -- 十字军圣印：30秒，显示剩余时间和冷却，使用组2，可刷新
    self:AddTimer(self.SPELL, BS["Seal of Wisdom"],         30, 0,1,1, { gr=2, rc=true })                                    -- 智慧圣印：30秒，显示剩余时间和冷却，使用组2，可刷新
    self:AddTimer(self.SPELL, BS["Turn Undead"],            10, 1,0,0, { gr=3, d={rs=1.5} })                                   -- 超度亡灵：10秒，显示图标，使用组3，1.5秒施法时间

    -- 添加各种圣骑士相关事件的计时器（事件类型）
    self:AddTimer(self.EVENT, BS["Forbearance"],               60, 1,0,1 )                                                     -- 自律：60秒，显示图标和冷却
    self:AddTimer(self.EVENT, BS["Judgement of Justice"],      10, 1,0,0, { cr="RED", xn=BS["Seal of Justice"], rom=true })    -- 公正审判：10秒，显示图标，红色，关联公正圣印，可叠加
    self:AddTimer(self.EVENT, BS["Judgement of Light"],        10, 1,0,0, { cr="RED", xn=BS["Seal of Light"],  d={tn=BS["Lasting Judgement"], tb=10}, rom=true })  -- 光明审判：10秒，显示图标，红色，关联光明圣印，受"持久审判"影响延长10秒，可叠加
    self:AddTimer(self.EVENT, BS["Judgement of Wisdom"],       10, 1,0,0, { cr="RED", xn=BS["Seal of Wisdom"], d={tn=BS["Lasting Judgement"], tb=10}, rom=true })  -- 智慧审判：10秒，显示图标，红色，关联智慧圣印，受"持久审判"影响延长10秒，可叠加
    self:AddTimer(self.EVENT, BS["Judgement of the Crusader"], 10, 1,0,0, { cr="RED", xn=BS["Seal of the Crusader"], rom=true })  -- 十字军审判：10秒，显示图标，红色，关联十字军圣印，可叠加
    self:AddTimer(self.EVENT, BS["Lay on Hands"],             120, 1,1,1, { cr="BLUE" })                                       -- 圣疗术（事件）：120秒，显示图标、剩余时间和冷却，蓝色
    self:AddTimer(self.EVENT, BS["Redoubt"],                   12, 0,1,1, { cr="GREEN", a=1 })                                  -- 正义壁垒：12秒，显示剩余时间和冷却，绿色，可叠加1层
    self:AddTimer(self.EVENT, BS["Vengeance"],                  30, 0,1,1, { cr="GREEN", a=3 })                                  -- 复仇：30秒，显示剩余时间和冷却，绿色，可叠加3层
    self:AddTimer(self.EVENT, BS["Vindication"],                8, 1,0,0, { cr="RED",  a=1 })                                  --  辩护：10秒，显示图标，红色，可叠加1层

    -- 注释掉的技能：愤怒之锤（可能未完成或暂不启用）
    -- self:AddTimer(A.SKILL, C.HAMMER_OF_WRATH,            5, 0,1,1, { cr="YELLOW" })
end

-- 将圣骑士设置函数添加到Chronometer的初始化队列中
table.insert(Chronometer.dataSetup, Chronometer.PaladinSetup)