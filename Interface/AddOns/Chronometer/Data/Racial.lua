--<< ====================================================================== >>--
-- 配置种族技能计时器                                                       --
--<< ====================================================================== >>--
-- 引入Babble-Spell-2.2库，用于获取法术名称的本地化支持
local BS = AceLibrary("Babble-Spell-2.2")

-- 定义Chronometer对象的RacialSetup方法，用于根据玩家种族设置对应的种族技能计时器
function Chronometer:RacialSetup()
    -- 获取玩家的种族信息（lr变量未使用，可能是保留变量）
	local lr, race = UnitRace("player")
	
    -- 根据不同种族添加对应的种族技能计时器
	if race == "Dwarf" then
        -- 矮人：石肤术，持续8秒
		self:AddTimer(self.SPELL, BS["Stoneform"],              8, 0,1,1, { cl="RACIAL" })
	elseif race == "Human" then
        -- 人类：感知，持续20秒
		self:AddTimer(self.SPELL, BS["Perception"],             20, 0,1,1, { cl="RACIAL" })
	elseif race == "Orc" then
        -- 兽人：血性狂暴，持续15秒
		self:AddTimer(self.SPELL, BS["Blood Fury"],             15, 0,1,1, { cl="RACIAL" })
	elseif race == "Tauren" then
        -- 牛头人：战争践踏，持续2秒
		self:AddTimer(self.SPELL, BS["War Stomp"],              2, 0,0,0, { cl="RACIAL" })
	elseif race == "Troll" then
        -- 巨魔：狂暴，持续10秒
		self:AddTimer(self.SPELL, BS["Berserking"],             10, 0,1,1, { cl="RACIAL" })
	elseif race == "Scourge" then
        -- 亡灵：被遗忘者的意志，持续5秒
		self:AddTimer(self.SPELL, BS["Will of the Forsaken"],   5, 0,1,1, { cl="RACIAL" })
	end
	
end

-- 将RacialSetup方法添加到Chronometer的数据配置列表中，使其在初始化时执行
table.insert(Chronometer.dataSetup, Chronometer.RacialSetup)