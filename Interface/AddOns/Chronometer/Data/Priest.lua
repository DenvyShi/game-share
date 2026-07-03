--<< ====================================================================== >>--
-- 计时器设置（牧师职业相关技能和事件的计时器配置）                              --
--<< ====================================================================== >>--

-- 引入Babble-Spell-2.2库，该库提供本地化的技能名称映射，确保在不同语言客户端下能正确识别技能
local BS = AceLibrary("Babble-Spell-2.2")

Chronometer.Priest_Shadow_Word_Pain=18;

-- 创建主帧
local TimerFrame = CreateFrame("Frame")
TimerFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TimerFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
TimerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	
TimerFrame:SetScript("OnEvent", function()
	if event == "PLAYER_ENTERING_WORLD" or event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_TARGET_CHANGED" then	
		if Chronometer:GetSpellDescription(BS["Shadow Word: Pain"], Chronometer:getRank(BS["Shadow Word: Pain"], 1)) then Chronometer.Priest_Shadow_Word_Pain=Chronometer:GetSpellDescription(BS["Shadow Word: Pain"], Chronometer:getRank(BS["Shadow Word: Pain"], 1));end;
		Chronometer:PriestSetup()
	end
end)

-- 定义Chronometer对象的PriestSetup方法，用于初始化牧师职业的计时器配置
function Chronometer:PriestSetup()
    -- 获取当前玩家的职业信息（第一个返回值为本地化职业名，第二个为职业代码）
    local _, eclass = UnitClass("player")
    -- 如果玩家职业不是牧师（职业代码"PRIEST"），则直接返回，不执行后续配置
    if eclass ~= "PRIEST" then return end

    -- 为牧师技能添加计时器配置
    -- AddTimer参数说明：
    -- 第1参数：类型（self.SPELL表示技能，self.EVENT表示事件）
    -- 第2参数：技能名称（通过BS库获取本地化名称，确保多语言兼容）
    -- 第3参数：持续时间（秒）
    -- 第4-6参数：未知标识（推测与UI显示样式、分类相关）
    -- 第7参数：附加属性表（rc=true表示可刷新持续时间，ea表示关联效果，d表示额外数据等）
 
    self:AddTimer(self.SPELL, BS["Abolish Disease"],    20, 1,1,1, { rc=true })          -- 驱邪术：持续20秒，可刷新
    self:AddTimer(self.SPELL, BS["Devouring Plague"],   24, 1,0,0, { rc=true })          -- 吞噬瘟疫：持续24秒，可刷新
    self:AddTimer(self.SPELL, BS["Elune's Grace"],      15, 0,1,1, { rc=true })          -- 艾露恩的恩赐：持续15秒，可刷新
    self:AddTimer(self.SPELL, BS["Fade"],               10, 0,1,1, { rc=true })          -- 渐隐术：持续10秒，可刷新
    self:AddTimer(self.SPELL, BS["Feedback"],           15, 0,1,1, { rc=true })          -- 能量反馈：持续15秒，可刷新
    self:AddTimer(self.SPELL, BS["Hex of Weakness"],   120, 1,0,0, { rc=true })          -- 虚弱诅咒：持续120秒，可刷新（注：此处可能为技能名称本地化差异，实际牧师无此技能，可能为暗影诅咒等）
    self:AddTimer(self.SPELL, BS["Holy Fire"],          10, 1,0,0, { rc=true })          -- 神圣之火：持续10秒，可刷新
    self:AddTimer(self.SPELL, BS["Mind Soothe"],        15, 1,0,0, { rc=true })          -- 心灵安抚：持续15秒，可刷新
    self:AddTimer(self.SPELL, BS["Power Infusion"],     15, 1,1,0, { rc=true })          -- 能量灌注：持续15秒，可刷新
    self:AddTimer(self.SPELL, BS["Power Word: Shield"],  30, 1,1,1, { ea={[BS["Weakened Soul"]]=1} })  -- 真言术：盾：持续30秒，关联虚弱灵魂效果
    self:AddTimer(self.SPELL, BS["Psychic Scream"],      8, 0,0,0)                       -- 精神尖叫：持续8秒
    self:AddTimer(self.SPELL, BS["Renew"],              15, 1,1,1, { rc=true })          -- 恢复：持续15秒，可刷新
    self:AddTimer(self.SPELL, BS["Shackle Undead"],     30, 1,0,0, { rc=true, d={rs=10} })  -- 束缚亡灵：持续30秒，可刷新，额外数据rs=10（推测为刷新相关延迟）
    self:AddTimer(self.SPELL, BS["Shadow Word: Pain"],   (Chronometer.Priest_Shadow_Word_Pain-6), 1,0,0, { rc=true, d={tn=BS["Improved Shadow Word: Pain"], tb=3} })  -- 暗影 word：痛：持续18秒，可刷新，关联强化暗影 word：痛天赋（基础值3）
    self:AddTimer(self.SPELL, BS["Silence"],             5, 1,0,0)                       -- 沉默：持续5秒
    self:AddTimer(self.SPELL, BS["Starshards"],          6, 1,0,0)                       -- 星碎片：持续6秒（注：牧师技能中无此技能，可能为本地化名称误差）
    self:AddTimer(self.SPELL, BS["Touch of Weakness"],   120, 0,1,1, { rc=true })        -- 虚弱之触：持续120秒，可刷新
    self:AddTimer(self.SPELL, BS["Vampiric Embrace"],    60, 1,0,0, { rc=true })          -- 吸血鬼的拥抱：持续60秒，可刷新
    self:AddTimer(self.SPELL, BS["Greater Heal"],        0, 1,0,0, { ea={[BS["Greater Heal"]]=1} })  -- 强效治疗术：持续0秒（瞬间效果），关联自身效果

    -- 为牧师相关事件添加计时器配置（事件通常为技能触发的被动效果）
    self:AddTimer(self.EVENT, BS["Blackout"],              3, 1,0,0, { a=1 })             -- 昏阙：持续3秒，属性a=1（推测为触发型效果标识）
    self:AddTimer(self.EVENT, BS["Blessed Recovery"],      6, 0,1,1, { a=1 })             -- 神圣恢复：持续6秒，属性a=1
    self:AddTimer(self.EVENT, BS["Inspiration"],          15, 1,1,0, { a=1, xn=BS["Shield Specialization"] })  -- 灵感：持续15秒，属性a=1，关联护盾专精天赋
    self:AddTimer(self.EVENT, BS["Shadow Vulnerability"], 15, 1,0,0, { a=1, xn=BS["Shadow Weaving"] })  -- 暗影易伤：持续15秒，属性a=1，关联暗影编织天赋
    self:AddTimer(self.EVENT, BS["Spirit Tap"],           15, 0,1,1, { a=1 })             -- 精神分流：持续15秒，属性a=1
    self:AddTimer(self.EVENT, BS["Weakened Soul"],        15, 1,0,1 )                     -- 虚弱灵魂：持续15秒
    self:AddTimer(self.EVENT, BS["Greater Heal"],         15, 1,1,1)                      -- 强效治疗术（事件）：持续15秒
end
-- 将PriestSetup方法插入到Chronometer的dataSetup列表中，使其在初始化时被自动调用，完成牧师计时器配置
table.insert(Chronometer.dataSetup, Chronometer.PriestSetup)