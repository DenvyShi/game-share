-- 在文件顶部添加SuperWoW环境检测
--<< ====================================================================== >>--
-- 配置计时器设置计时器（用于术士职业的技能和事件计时）                               --
--<< ====================================================================== >>--
-- 引入Babble-Spell-2.2库（用于获取法术名称）
local BS = AceLibrary("Babble-Spell-2.2")
-- 引入AceLocale-2.2库并创建Chronometer的本地化对象
local L = AceLibrary("AceLocale-2.2"):new("Chronometer")

-- 受到急速影响的DOT计时，全局函数，方便其他插件调用
Chronometer.Warlock_Corruption_L=12;
Chronometer.Warlock_Corruption_M=15;
Chronometer.Warlock_Corruption_H=18;
Chronometer.Warlock_Agony=24;
Chronometer.Warlock_Siphon_Life=30;
Chronometer.Warlock_Dark_Harvest=8;
Chronometer.Warlock_Talents_XieZhou = 0;

-- 暗影收割相关变量
Chronometer.Warlock_Dark_Harvest_Active = 0
Chronometer.Warlock_Dark_Harvest_StartTime = 0
Chronometer.Warlock_Dark_Harvest_EndTime = 0
Chronometer.Warlock_Dark_Harvest_Haste = 0

-- 创建主帧
local WarlockTimerFrame = CreateFrame("Frame")
WarlockTimerFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
WarlockTimerFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
WarlockTimerFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
WarlockTimerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
WarlockTimerFrame:RegisterEvent("SPELLCAST_CHANNEL_START")
WarlockTimerFrame:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")	
	
WarlockTimerFrame:SetScript("OnEvent", function()
	if event == "PLAYER_ENTERING_WORLD" or event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_TARGET_CHANGED" or event== "PLAYER_AURAS_CHANGED" then	
		--[[if Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 3)) then Chronometer.Warlock_Corruption_H=Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 3));end;
		if Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 2)) then Chronometer.Warlock_Corruption_M=Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 2));end;
		if Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 1)) then Chronometer.Warlock_Corruption_L=Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 1));end;
		]]
-- 修改后：确保数值有效，失败时用默认值-007
    local corruptionH = Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 3))
    if corruptionH then 
        Chronometer.Warlock_Corruption_H = tonumber(corruptionH) or 18  -- 高等级默认18秒
    end;

-- 中低等级同理
    local corruptionM = Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 2))
    if corruptionM then 
        Chronometer.Warlock_Corruption_M = tonumber(corruptionM) or 15  -- 中等级默认15秒
    end;

    local corruptionL = Chronometer:GetSpellDescription(BS["Corruption"], Chronometer:getRank(BS["Corruption"], 1))
    if corruptionL then 
        Chronometer.Warlock_Corruption_L = tonumber(corruptionL) or 12  -- 低等级默认12秒
    end;
	--007以上为分隔符记号
		if Chronometer:GetSpellDescription(BS["Curse of Agony"], Chronometer:getRank(BS["Curse of Agony"], 1)) then Chronometer.Warlock_Agony=Chronometer:GetSpellDescription(BS["Curse of Agony"], Chronometer:getRank(BS["Curse of Agony"], 1));end;
		if Chronometer:GetSpellDescription(BS["Siphon Life"], Chronometer:getRank(BS["Siphon Life"], 1)) then Chronometer.Warlock_Siphon_Life=Chronometer:GetSpellDescription(BS["Siphon Life"], Chronometer:getRank(BS["Siphon Life"], 1));end;	
		if Chronometer:GetSpellDescription(BS["Dark Harvest"], Chronometer:getRank(BS["Dark Harvest"], 1)) then Chronometer.Warlock_Dark_Harvest=Chronometer:GetSpellDescription(BS["Dark Harvest"], Chronometer:getRank(BS["Dark Harvest"], 1));end;


		for t=1, GetNumTalentTabs() do
			local numTalents = GetNumTalents(t);
			for i=1, numTalents do
				local nameTalent,Texture,_,_,currRank,maxRank = GetTalentInfo(t,i);
				if nameTalent and strfind(Texture,"Interface\\Icons\\Spell_Shadow_CurseOfAchimonde") and currRank==1 then
					Chronometer.Warlock_Talents_XieZhou = 1;
				end;
			end;
		end;
		
		Chronometer:WarlockSetup()
	end

	if event == "SPELLCAST_CHANNEL_START" or event == "SPELLCAST_CHANNEL_UPDATE" then
        -- 检测暗影收割开始
        if arg1/1000 == tonumber(Chronometer:GetSpellDescription(BS["Dark Harvest"], Chronometer:getRank(BS["Dark Harvest"], 1))) then
            Chronometer.Warlock_Dark_Harvest_Active = 1
            Chronometer.Warlock_Dark_Harvest_StartTime = GetTime()
            Chronometer.Warlock_Dark_Harvest_EndTime = Chronometer.Warlock_Dark_Harvest_StartTime + arg1/1000 -- 默认
            Chronometer.Warlock_Dark_Harvest_Target = UnitName("target")
            Chronometer.Warlock_Dark_Harvest_Haste = 1 - ((Chronometer.Warlock_Dark_Harvest_EndTime - Chronometer.Warlock_Dark_Harvest_StartTime) / 8)
			local currentTime = GetTime()
			-- 更新所有活跃的DOT计时器，调整剩余时间
			for i = 1, 20 do
				local bar = Chronometer.bars[i]
				if bar and bar.id then
					if strfind(bar.id,Chronometer.Warlock_Dark_Harvest_Target) and (bar.name == BS["Corruption"] or bar.name == BS["Curse of Agony"] or bar.name == BS["Siphon Life"]) then
						local duration = bar.endtime - currentTime
						local orgintime = bar.timer.d
						if duration > (Chronometer.Warlock_Dark_Harvest_EndTime - Chronometer.Warlock_Dark_Harvest_StartTime) * ( 0.3 + Chronometer.Warlock_Dark_Harvest_Haste ) then
							bar.timer.d = duration - (Chronometer.Warlock_Dark_Harvest_EndTime - Chronometer.Warlock_Dark_Harvest_StartTime) * (0.3 + Chronometer.Warlock_Dark_Harvest_Haste)
						else
							bar.timer.d = duration * (0.7 - Chronometer.Warlock_Dark_Harvest_Haste)
						end	
						
						Chronometer:StartTimer(bar.timer, bar.name, bar.target, bar.rank)
						bar.timer.d = orgintime
					end
				end
			end	
		elseif Chronometer.Warlock_Dark_Harvest_Active == 1 then
			local currentTime = GetTime()
			-- 更新所有活跃的DOT计时器，调整剩余时间
			for i = 1, 20 do
				local bar = Chronometer.bars[i]
				if bar and bar.id then
					if strfind(bar.id,Chronometer.Warlock_Dark_Harvest_Target) and (bar.name == BS["Corruption"] or bar.name == BS["Curse of Agony"] or bar.name == BS["Siphon Life"]) then
						local duration = bar.endtime - currentTime
						local orgintime = bar.timer.d
						bar.timer.d = duration +  (Chronometer.Warlock_Dark_Harvest_EndTime - currentTime) * (0.3 + Chronometer.Warlock_Dark_Harvest_Haste)
						Chronometer:StartTimer(bar.timer, bar.name, bar.target, bar.rank)
						bar.timer.d = orgintime
					end
				end
			end

			Chronometer:KillBar(BS["Dark Harvest"], Chronometer.Warlock_Dark_Harvest_Target)
			Chronometer.Warlock_Dark_Harvest_Active = 0
        end
    end
end)

-- 暗影收割影响DOT持续时间的函数
-- 创建主帧用于定时更新
local DarkharvestFrame = CreateFrame("Frame")

-- 定义定时器参数
local interval = 0.1  -- 提升采样频率至0.1秒
local elapsedTime = 0

DarkharvestFrame:SetScript("OnUpdate", function()
    if (GetTime() - elapsedTime) < interval then
        return
    end
    elapsedTime = GetTime()
	if Chronometer.Warlock_Dark_Harvest_Active == 1 and ((DFRLCastbar and not DFRLCastbar:IsShown()) or (CastingBarFrame and not CastingBarFrame:IsVisible())) then 	
		-- 更新所有活跃的DOT计时器，调整剩余时间
		for i = 1, 20 do
			local bar = Chronometer.bars[i]
			if bar and bar.id then
				if strfind(bar.id,Chronometer.Warlock_Dark_Harvest_Target) and (bar.name == BS["Corruption"] or bar.name == BS["Curse of Agony"] or bar.name == BS["Siphon Life"]) then
					local duration = bar.endtime - elapsedTime
					local orgintime = bar.timer.d
					bar.timer.d = duration +  (Chronometer.Warlock_Dark_Harvest_EndTime - elapsedTime) * (0.3 + Chronometer.Warlock_Dark_Harvest_Haste)
					Chronometer:StartTimer(bar.timer, bar.name, bar.target, bar.rank)
					bar.timer.d = orgintime
				end
			end
		end
		
		Chronometer:KillBar(BS["Dark Harvest"], Chronometer.Warlock_Dark_Harvest_Target)
		Chronometer.Warlock_Dark_Harvest_Active = 0
	end
end)

-- 定义术士职业的计时器设置函数
function Chronometer:WarlockSetup()
    -- 获取玩家职业，若不是术士则退出函数
    local _, eclass = UnitClass("player")
    if eclass ~= "WARLOCK" then return end

    -- 添加3个计时器组，参数分别为：组ID、是否启用、颜色
    self:AddGroup(1, true,  "MAGENTA")    -- 组1：启用，洋红色
    self:AddGroup(2, false, "MAROON")     -- 组2：禁用，褐红色
    self:AddGroup(3, true,  "RED")        -- 组3：启用，红色

    -- 添加各种法术的计时器（法术类型）
    self:AddTimer(self.SPELL, BS["Amplify Curse"],          30, 0,1,1)  -- 增幅诅咒：30秒
    self:AddTimer(self.SPELL, BS["Banish"],                 20, 1,0,0, { gr=1, rc=true, d={rs=10} })  -- 放逐：20秒，组1，可刷新，额外参数{重置时间=10}
    -- self:AddTimer(self.SPELL, BS["Corruption"],             Chronometer.Warlock_Corruption_H, 1,0,0, { rc=true, d={rt={Warlock_Corruption_L,Warlock_Corruption_M}} })  -- 腐蚀术：18秒，可刷新，额外参数{持续时间={12,15}}
    --007修改临时测试
	self:AddTimer(self.SPELL, BS["Corruption"], tonumber(Chronometer.Warlock_Corruption_H) or 18,  1, 0, 0,    { rc=true, d={rt={Chronometer.Warlock_Corruption_L, Chronometer.Warlock_Corruption_M}}})
    self:AddTimer(self.SPELL, BS["Curse of Agony"],         Chronometer.Warlock_Agony, 1,0,0, { rc=true })  -- 痛苦诅咒：24秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of Doom"],          60, 1,0,0, { gr=2, rc=true })  -- 厄运诅咒：60秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of Exhaustion"],    12, 1,0,0, { gr=2, rc=true })  -- 疲劳诅咒：12秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of Recklessness"], 120, 1,0,0, { gr=2, rc=true })  -- 鲁莽诅咒：120秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of Shadow"],       300, 1,0,0, { gr=2, rc=true })  -- 暗影诅咒：300秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of Tongues"],       30, 1,0,0, { gr=2, rc=true })  -- 语言诅咒：30秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of Weakness"],     120, 1,0,0, { gr=2, rc=true })  -- 虚弱诅咒：120秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Curse of the Elements"], 300, 1,0,0, { gr=2, rc=true })  -- 元素诅咒：300秒，组2，可刷新
    self:AddTimer(self.SPELL, BS["Death Coil"],              3, 1,0,0)  -- 死亡缠绕：3秒
    self:AddTimer(self.SPELL, BS["Fear"],                   10, 1,0,0, { gr=3, rc=true, d={rs=5} })  -- 恐惧术：10秒，组3，可刷新，额外参数{重置时间=5}
    self:AddTimer(self.SPELL, BS["Fel Domination"],         15, 0,1,1)  -- 恶魔支配：15秒
    self:AddTimer(self.SPELL, BS["Howl of Terror"],         10, 0,0,0, { d={rs=5} })  -- 恐惧嚎叫：10秒，额外参数{重置时间=5}
    self:AddTimer(self.SPELL, BS["Immolate"],               15, 1,0,0, { rc=true, mc=BS["Conflagrate"] })  -- 献祭：15秒，可刷新，关联法术{燃烧}
    self:AddTimer(self.SPELL, BS["Shadow Bolt"],             0, 1,0,0, { ea={[BS["Shadow Vulnerability"]]=2} })  -- 暗影箭：0秒，效果关联{暗影易伤=2}
    self:AddTimer(self.SPELL, BS["Shadow Ward"],            30, 0,1,1)  -- 暗影防护结界：30秒
    self:AddTimer(self.SPELL, BS["Shadowburn"],              5, 1,0,0)  -- 暗影灼烧：5秒
    self:AddTimer(self.SPELL, BS["Siphon Life"],            Chronometer.Warlock_Siphon_Life, 1,0,0, { rc=true })  -- 生命虹吸：30秒，可刷新
	self:AddTimer(self.SPELL, BS["Dark Harvest"],           Chronometer.Warlock_Dark_Harvest, 1,0,0, { rc=true })  -- 暗影收割：8秒，可刷新
	
    -- 添加各种事件的计时器（事件类型）
    self:AddTimer(self.EVENT, BS["Aftermath"],               5, 0,1,1, { cr="GREEN", a=1 })  -- 后果：5秒，颜色{绿色}，显示所有目标
    self:AddTimer(self.EVENT, BS["Enslave Demon"],         300, 0,0,0, { cr="BLUE", a=1 })  -- 奴役恶魔：300秒，颜色{蓝色}，显示所有目标
    self:AddTimer(self.EVENT, BS["Pyroclasm"],               3, 0,1,1, { cr="GREEN", a=1 })  --  pyroclasm（暂译：火焰爆裂）：3秒，颜色{绿色}，显示所有目标
    self:AddTimer(self.EVENT, BS["Sacrifice"],              30, 0,1,1, { cr="GREEN", a=1 })  -- 牺牲：30秒，颜色{绿色}，显示所有目标
    self:AddTimer(self.EVENT, BS["Seduction"],              15, 1,0,1, { cr="RED" })  -- 诱惑：15秒，颜色{红色}
    self:AddTimer(self.EVENT, BS["Shadow Vulnerability"],   12, 1,0,0, { cr="GREEN", xn=BS["Shadow Bolt"] })  -- 暗影易伤：12秒，颜色{绿色}，关联法术{暗影箭}
    self:AddTimer(self.EVENT, BS["Shadow Trance"],          10, 0,1,1, { cr="GREEN", a=1, xn=BS["Nightfall"] })  -- 暗影 trance（暂译：暗影恍惚）：10秒，颜色{绿色}，显示所有目标，关联法术{夜幕}
    self:AddTimer(self.EVENT, BS["Soul Siphon"],            10, 0,1,1, { cr="GREEN", a=1, xn=BS["Drain Soul"] })  -- 灵魂虹吸：10秒，颜色{绿色}，显示所有目标，关联法术{吸取灵魂}
end

-- 将术士设置函数插入到Chronometer的数据设置列表中
table.insert(Chronometer.dataSetup, Chronometer.WarlockSetup)