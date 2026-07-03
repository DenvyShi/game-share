local DPSMate = DPSMate
local DB = DPSMate.DB

local t = {}
local overheal
local strgfind = string.gfind
local tnbr = tonumber
local strgsub = string.gsub
local GetTime = GetTime
local strfind = string.find
local strsub = string.sub

local AbilityAutoAttack = DPSMate.L["AutoAttack"]
local AbilityPeriodic = DPSMate.L["periodic"]
DB.UserUnknown = DPSMate.L["unknown"]

if (GetLocale() == "zhCN") then
	DPSMate.Parser.SelfHits = function(self, msg)
		for a,b,c,d in strgfind(msg, "你击中(.+)造成(%d+)点(.*)伤害（(%d+)被吸收）。") do 
			DB:SetUnregisterVariables(tnbr(d), AbilityAutoAttack, self.player)
		end
		for a,b,f,c in strgfind(msg, "你击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(b)}
			if c == "(偏斜)" then t[3]=1;t[1]=0 elseif c ~= "" then t[4]=1;t[1]=0; end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageDone(self.player, AbilityAutoAttack, t[1] or 1, 0, 0, 0, 0, 0, t[5], t[3] or 0, t[4] or 0, a)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, AbilityAutoAttack, t[5]);DB:DeathHistory(a, self.player, AbilityAutoAttack, t[5], 1, 0, 0, 0) end
			return
		end
		for a,b,c in strgfind(msg, "你对(.+)造成(%d+)的致命一击伤害。%s?(.*)") do
			t = {tnbr(b)}
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(self.player, AbilityAutoAttack, 0, 1, 0, 0, 0, 0, t[1], 0, 0, a)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, AbilityAutoAttack, t[1]);DB:DeathHistory(a, self.player, AbilityAutoAttack, t[1], 0, 1, 0, 0) end
			return
		end
		for a,b,f,c in strgfind(msg, "你的致命一击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {tnbr(b)}
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(self.player, AbilityAutoAttack, 0, 1, 0, 0, 0, 0, t[1], 0, 0, a)
			if self.TargetParty[a] then DB:BuildFail(1, a, self.player, AbilityAutoAttack, t[1]);DB:DeathHistory(a, self.player, AbilityAutoAttack, t[1], 0, 1, 0, 0) end
			return
		end
		for a in strgfind(msg, "你从高处掉落损失(%d+)生命值。") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "下跌", 1, 0, 0, 0, 0, 0, t[1], "染病蛾", 0, 0)
			DB:DeathHistory(self.player, "染病蛾", "下跌", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "你泡在岩浆中，损失了(%d+)点生命值。") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "熔岩", 1, 0, 0, 0, 0, 0, t[1], "染病蛾", 0, 0)
			DB:DeathHistory(self.player, "染病蛾", "熔岩", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("熔岩","火焰")
			return
		end
		for a in strgfind(msg, "你受到(%d+)点火焰伤害。") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "火焰", 1, 0, 0, 0, 0, 0, t[1], "染病蛾", 0, 0)
			DB:DeathHistory(self.player, "染病蛾", "火焰", t[1], 1, 0, 0, 0)
			DB:AddSpellSchool("火焰","火焰")
			return
		end
		for a in strgfind(msg, "你现在处于溺水状态并损失(%d+)生命值。") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "溺死", 1, 0, 0, 0, 0, 0, t[1], "染病蛾", 0, 0)
			DB:DeathHistory(self.player, "染病蛾", "溺死", t[1], 1, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "你泡在泥浆中，损失了(%d+)点生命值。") do
			t = {tnbr(a)}
			DB:DamageTaken(self.player, "粘液", 1, 0, 0, 0, 0, 0, t[1], "染病蛾", 0, 0)
			DB:DeathHistory(self.player, "染病蛾", "粘液", t[1], 1, 0, 0, 0)
			return
		end
	end
	
	DPSMate.Parser.SelfMisses = function(self, msg)
		for a in strgfind(msg, "你没有击中(.+)。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "你发起了攻击。(.+)闪开了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a in strgfind(msg, "你发起了攻击。(.+)招架住了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, 0, 0)
		end
		for a in strgfind(msg, "你发起了攻击。(.+)格挡住了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageDone(self.player, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, 0, 1)
		end
		for ta in strgfind(msg, "你发动攻击，(.+)吸收了所有伤害。") do DB:Absorb(AbilityAutoAttack, ta, self.player); return end
	end
	
	DPSMate.Parser.SpellSelfDamage = function(self, msg)
		for a,b,c,f in strgfind(msg, "你的(.+)击中(.+)造成(.*)(%d+)伤害（(%d+)被吸收）。") do
			DB:SetUnregisterVariables(tnbr(f), a, self.player)
		end
		for a,b,x,c,d,e in strgfind(msg, "你的(.+)击中(.+)造成([了]*)(%d+)点(.-)伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;t[3]=0 end
			if b=="你" then --suicide damage
				b=self.player 
				DB:DamageTaken(self.player, a, 1, 0, 0, 0, 0, 0, t[1], b, 0, t[4] or 0)
				DB:DeathHistory(self.player, b, a, t[1], 1, 0, 0, 0)
				if self.FailDT[a] then DB:BuildFail(2, self.player, b, a, t[1]) end
			else
				if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
				if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
				DB:DamageDone(self.player, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
				if self.TargetParty[c] then DB:BuildFail(1, c, self.player, a, t[1]);DB:DeathHistory(c, self.player, a, t[1], 1, 0, 0, 0) end
			end 
			if d then DB:AddSpellSchool(a,d) end
			return
		end
		for a,b,d,e in strgfind(msg, "你的(.+)对(.+)造成(%d+)的致命一击伤害。%s?(.*)") do 
			t = {tnbr(d)}
			if b=="你" then  --suicide damage
				b=self.player 
				DB:DamageTaken(self.player, a, 0, 1, 0, 0, 0, 0, t[1], b, 0, 0)
				DB:DeathHistory(self.player, b, a, t[1], 0, 1, 0, 0)
				if self.FailDT[a] then DB:BuildFail(2, self.player, b, a, t[1]) end
			else
				if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
				if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a,  0, 1, 0, 0, 0, 0, t[1], b, 0, 0)
				DB:DamageDone(self.player, a, 0, 1, 0, 0, 0, 0, t[1], 0, 0, b)
				if self.TargetParty[b] then DB:BuildFail(1, b, self.player, a, t[1]);DB:DeathHistory(b, self.player, a, t[1], 1, 0, 0, 0) end
			end
			return
		end
		for a,b,c,d,e in strgfind(msg, "你的(.+)致命一击对(.+)造成(%d+)点(.-)伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;t[3]=0 end
			if b=="你" then  --suicide damage
				b=self.player
				DB:DamageTaken(self.player, a, 0, 1, 0, 0, 0, 0, t[1], b, 0, t[4] or 0)
				DB:DeathHistory(self.player, b, a, t[1], 0, 1, 0, 0)
				if self.FailDT[a] then DB:BuildFail(2, self.player, b, a, t[1]) end
			else
				if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(self.player, a, b, GetTime()) end
				if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(self.player, self.player, a, true) end
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
				DB:DamageDone(self.player, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
				if self.TargetParty[b] then DB:BuildFail(1, b, self.player, a, t[1]);DB:DeathHistory(b, self.player, a, t[1], 1, 0, 0, 0) end
			end
			if d then DB:AddSpellSchool(a,d) end
			return
		end
		for b,a in strgfind(msg, "你的(.+)被(.+)躲闪过去了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(self.player, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "你的(.+)被(.+)招架了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "你的(.+)没有击中(.+)。") do
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "你的(.+)被(.+)抵抗了。") do
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "你的(.+)被(.+)格挡了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, self.player, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(self.player, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for whom, what in strgfind(msg, "你打断了(.-)的(.+)。") do
			local causeAbility = "法术反制"
			if DPSMate.Cache.DPSMateUser[self.player] then
				if DPSMate.Cache.DPSMateUser[self.player][2] == "priest" then
					causeAbility = "沉默"
				end
			end
			DB:Kick(self.player, whom, causeAbility, what)
		end
	end
	
	DPSMate.Parser.PeriodicDamage = function(self, msg)
		for a,b,f in strgfind(msg, "(.+)受到(.+)的伤害(.*)") do 
			if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end; 
			DB:ConfirmAfflicted(a, b, GetTime()); 
			if self.CC[b] then  DB:BuildActiveCC(a, b) end; 
			return 
		end
		for d,e,a,b,c,f in strgfind(msg, "(.-)的(.-)使(.+)受到了(%d+)点(.+)伤害(.*)。") do
			t = {tnbr(b)}
			if d=="你" then d=self.player end
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), e..AbilityPeriodic, d)
			end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, d, e..AbilityPeriodic, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageDone(d, e..AbilityPeriodic, 1, 0, 0, 0, 0, 0, t[1], 0, 0, a)
			if self.TargetParty[a] and self.TargetParty[d] then DB:BuildFail(1, a, d, e..AbilityPeriodic, t[1]);DB:DeathHistory(a, d, e..AbilityPeriodic, t[1], 1, 0, 0, 0) end
			DB:AddSpellSchool(e..AbilityPeriodic,c)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)吸收了。") do
			DB:Absorb(a..AbilityPeriodic, b, f)
			return
		end
		for a,b in strgfind(msg, "你的(.+)被(.+)吸收了。") do
			DB:Absorb(a..AbilityPeriodic, b, self.player)
			return
		end
	end
	
	DPSMate.Parser.FriendlyOrHostilePlayerDamage = function(self, msg)
		for k,a,b,c,g,f in strgfind(msg, "(.-)的(.+)击中(.+)造成(%d+)点(.*)伤害（(%d+)点被吸收）。") do 
			DB:SetUnregisterVariables(tnbr(f), b, k)
		end
		--某战士的血性狂暴对某战士造成159点致命一击伤害。
		--某骑士的十字军打击对某骑士造成415点致命一击伤害
		for f,a,b,c,e in strgfind(msg, "(.-)的(.+)对(.+)造成(%d+)点致命一击伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="你" then b=self.player end
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;end
			if f == b then --suicide damage
				DB:DamageTaken(b, a, 0, 1, 0, 0, 0, 0, t[1], f, 0, 0)
			else
				if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
				if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
				DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
			end
			if self.TargetParty[b] then if self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);end DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			return
		end
		--某骑士的火焰打击致命一击对某骑士造成6点火焰伤害。
		for f,a,b,c,g,e in strgfind(msg, "(.-)的(.+)致命一击对(.+)造成(%d+)点(.*)伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="你" then b=self.player end
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;end
			if f == b then --suicide damage
				DB:DamageTaken(b, a, 0, 1, 0, 0, 0, 0, t[1], f, 0, 0)
			else
				if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
				if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
				DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
			end
			if self.TargetParty[b] then if self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]); end DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,g)
			return
		end
		--某法系的燃烧仇恨击中某法系造成226点火焰伤害。(75点被抵抗)
		for f,a,b,c,g,e in strgfind(msg, "(.-)的(.+)击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="你" then b=self.player end
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;t[3]=0 end
			if f == b then --suicide damage
				DB:DamageTaken(b, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], f, 0, 0)
			else
				if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
				if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
				DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
			end
			if self.TargetParty[b] then if self.TargetParty[f] then DB:BuildFail(1, b, f, a, t[1]);end DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			return
		end
		for f,b,a in strgfind(msg, "(.-)的(.+)被(.+)闪躲过去。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(f, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)招架了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)没有击中(.+)。") do
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)抵抗了。") do
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)格挡过去。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for who, whom, what in strgfind(msg, "(.+)打断了(.-)的(.+)。") do
			local causeAbility = "法术反制"
			if DPSMate.Cache.DPSMateUser[who] then
				if DPSMate.Cache.DPSMateUser[who][2] == "priest" then
					causeAbility = "沉默"
				end
				-- Account for felhunter silence
				if DPSMate.Cache.DPSMateUser[who][4] and DPSMate.Cache.DPSMateUser[who][6] then
					local owner = DPSMate:GetUserById(DPSMate.Cache.DPSMateUser[who][6])
					if owner and DPSMate.Cache.DPSMateUser[owner] then
						causeAbility = "法术封锁"
						who = owner
					end
				end
			end
			DB:Kick(who, whom, causeAbility, what)
		end
	end
	
	DPSMate.Parser.FriendlyOrHostilePlayerHits = function(self, msg)
		for a,b,c,f,e in strgfind(msg, "(.+)击中(.+)造成(%d+)点(.*)伤害（(%d+)点被吸收）。") do
			DB:SetUnregisterVariables(tnbr(e), AbilityAutoAttack, a)
		end
		--todo 玩家名字中包含"对"字统计会有问题
		for a,b,c,d in strgfind(msg, "(.+)对(.+)造成(%d+)的致命一击伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(偏斜)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b == "你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[a] then
					DB:BuildFail(1, b, a, AbilityAutoAttack, t[5]);
				end
				DB:DeathHistory(b, a, AbilityAutoAttack, t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,f,d in strgfind(msg, "(.+)的致命一击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(偏斜)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b == "你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[a] then
					DB:BuildFail(1, b, a, AbilityAutoAttack, t[5]);
				end
				DB:DeathHistory(b, a, AbilityAutoAttack, t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,f,d in strgfind(msg, "(.+)击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(偏斜)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, t[3] or 1, 0, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, AbilityAutoAttack, t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[a] then
					DB:BuildFail(1, b, a, AbilityAutoAttack, t[5]);
				end
				DB:DeathHistory(b, a, AbilityAutoAttack, t[5], 1, 0, 0, 0) end
			return
		end
		for a,b in strgfind(msg, "在岩浆中，(.+)损失了(%d+)生命值。") do
			DB:DamageTaken(a, "熔岩", 1, 0, 0, 0, 0, 0, tnbr(b), "染病蛾", 0, 0)
			DB:DeathHistory(a, "染病蛾", "熔岩", tnbr(b), 1, 0, 0, 0)
			DB:AddSpellSchool("熔岩","火焰")
			return
		end
		for a,b in strgfind(msg, "(.+)受到(%d+)点火焰伤害。") do
			DB:DamageTaken(a, "火焰", 1, 0, 0, 0, 0, 0, tnbr(b), "染病蛾", 0, 0)
			DB:DeathHistory(a, "染病蛾", "火焰", tnbr(b), 1, 0, 0, 0)
			DB:AddSpellSchool("火焰","火焰")
			return
		end
		for a,b in strgfind(msg, "(.+)从高处掉落损失(%d+)生命值。") do
			DB:DamageTaken(a, "下跌", 1, 0, 0, 0, 0, 0, tnbr(b), "染病蛾", 0, 0)
			DB:DeathHistory(a, "染病蛾", "下跌", tnbr(b), 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)现在处于溺水状态并损失(%d+)生命值。") do
			DB:DamageTaken(a, "溺死", 1, 0, 0, 0, 0, 0, tnbr(b), "染病蛾", 0, 0)
			DB:DeathHistory(a, "染病蛾", "溺死", tnbr(b), 1, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "在泥浆中，(.+)损失了(%d+)生命值。") do
			DB:DamageTaken(a, "粘液", 1, 0, 0, 0, 0, 0, tnbr(b), "染病蛾", 0, 0)
			DB:DeathHistory(a, "染病蛾", "粘液", tnbr(b), 1, 0, 0, 0)
			return
		end
	end
	
	DPSMate.Parser.FriendlyPlayerMisses = function(self, msg)
		for a,b in strgfind(msg, "(.+)没有击中(.+)。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)闪躲开了。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)招架住了。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)格挡住了。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,b in strgfind(msg, "(.+)发起攻击，(.+)吸收了所有伤害。") do if b=="你" then b=self.player end; DB:Absorb(AbilityAutoAttack, b, c); return end
	end
	
	DPSMate.Parser.SpellDamageShieldsOnSelf = function(self, msg)
		for source,a,b,c in strgfind(msg, "(.+)将(%d+)点(.+)伤害反弹给(.+)。") do 
			t = {tnbr(a)}
			if source == "你" then source=self.player end
			b="反弹("..b..")"
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, source, b, 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageDone(source, b, 1, 0, 0, 0, 0, 0, t[1], 0, 0)
		end
	end
	
	DPSMate.Parser.SpellDamageShieldsOnOthers = function(self, msg)
		for a,b,c,d in strgfind(msg, "(.+)将(%d+)点(.+)伤害反射给(.+)。") do
			t = {tnbr(b)}
			if d == "你" then d=self.player end
			if strfind(a, "%s") then
				DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, d, "棱光反射", 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
				DB:DamageTaken(d, "棱光反射", 1, 0, 0, 0, 0, 0, t[1], a, 0,0)
				DB:DeathHistory(d, a, "棱光反射", t[1], 1, 0, 0, 0)
			else
				DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, "棱光反射", 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
				DB:DamageDone(a, "棱光反射", 1, 0, 0, 0, 0, 0, t[1], 0, 0)
			end
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                    Damage taken                      --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CreatureVsSelfHits = function(self, msg)
		for a,c,f,d in strgfind(msg, "(.+)击中你造成(%d+)点(.*)伤害。(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "碾压") then t[3]=1;t[1]=0; elseif strfind(d, "点被格挡") then t[4]=1;t[1]=0; end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, AbilityAutoAttack, t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, AbilityAutoAttack, t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, AbilityAutoAttack, t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
		for a,c,d in strgfind(msg, "(.+)对你造成(%d+)的致命一击伤害。(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "碾压") then t[3]=1;t[2]=0 elseif strfind(d, "点被格挡") then t[4]=1;t[2]=0 end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, AbilityAutoAttack, t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
		for a,c,f,d in strgfind(msg, "(.+)的致命一击对你造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if strfind(d, "碾压") then t[3]=1;t[2]=0 elseif strfind(d, "点被格挡") then t[4]=1;t[2]=0 end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(self.player, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(self.player, a, AbilityAutoAttack, t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsSelfMisses = function(self, msg)
		for c in strgfind(msg, "(.+)发起攻击，你吸收了所有伤害。") do DB:Absorb(AbilityAutoAttack, self.player, c); return end
		for a in strgfind(msg, "(.+)没有击中你。") do 
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)。") do 
			t = {false, false, false}
			if b=="你招架住了" then t[1]=1 elseif b=="你闪躲开了" then t[2]=1 else t[3]=1 end 
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, AbilityAutoAttack, 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, t[3] or 0, 0)
			DB:DamageTaken(self.player, AbilityAutoAttack, 0, 0, 0, t[1] or 0, t[2] or 0, 0, 0, a, 0, t[3] or 0)
			return
		end
	end 
	
	DPSMate.Parser.CreatureVsSelfSpellDamage = function(self, msg)
		for a,b,c,f,d in strgfind(msg, "(.-)的(.+)击中你造成(%d+)点(.*)伤害。(.*)") do
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 1, 0, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			DB:AddSpellSchool(b,f)
			return
		end
		for a,b,c,d in strgfind(msg, "(.-)的(.+)对你造成(%d+)点致命一击伤害。(.*)") do
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 1, 0, 0, 0, 0, t[1], a,  0, 0)
			DB:DamageTaken(self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 0, 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			return
		end
		for a,b,c,f,g in strgfind(msg, "(.-)的(.+)致命一击对你造成(%d+)点(.*)伤害。(.*)") do
			t = {tnbr(c)}
			DB:UnregisterPotentialKick(self.player, b, GetTime())
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 1, 0, 0, 0, 0, t[1], a, 0, 0)
			DB:DeathHistory(self.player, a, b, t[1], 0, 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, self.player, b, t[1]) end
			DB:AddSpellSchool(b,f)
			return
		end
		for a,b in strgfind(msg, "(.-)的(.+)没有击中你。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-)的(.+)被招架了。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-)的(.+)被闪躲过去。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-)的(.+)被抵抗了。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.-)的(.+)被格挡过去。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, b, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(self.player, b, 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
		for a,b in strgfind(msg, "你吸收了(.-)的(.+)。") do
			DB:Absorb(b, self.player, a)
			return
		end
	end
	
	DPSMate.Parser.PeriodicSelfDamage = function(self, msg)
		for a,b,c,d,f,e in strgfind(msg, "你受到(%d+)点(.+)伤害（(.-)的(.+)）(.*)。(.*)") do
			t = {tnbr(a)}
			if c=="你" then c=self.player end
			if strfind(f, "点被吸收") then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), d..AbilityPeriodic, c)
			end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, self.player, d..AbilityPeriodic, 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DamageTaken(self.player, d..AbilityPeriodic, 1, 0, 0, 0, 0, 0, t[1], c, 0, 0)
			DB:DeathHistory(self.player, c, d..AbilityPeriodic, t[1], 1, 0, 0, 0)
			if self.FailDT[d] then DB:BuildFail(2, c, self.player, d, t[1]) end
			DB:AddSpellSchool(d..AbilityPeriodic,b)
			return
		end
		for a in strgfind(msg, "你受到了(.+)效果的影响([（1）]*)。") do
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end;
			DB:BuildBuffs(DB.UserUnknown, self.player, a, false)
			if self.CC[a] then DB:BuildActiveCC(self.player, a) end
			return
		end
		for a,b in strgfind(msg, "你吸收了(.-)的(.+)。") do
			DB:Absorb(b..AbilityPeriodic, self.player, a)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureHits = function(self, msg) 
		for a,c,d,e in strgfind(msg, "(.+)对(.+)造成(%d+)的致命一击伤害。(.*)") do
		 	t = {false, false, false, false, tnbr(d)}
			if strfind(e, "碾压") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "点被格挡") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, AbilityAutoAttack, t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
		for a,c,d,f,e in strgfind(msg, "(.+)的致命一击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "碾压") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "点被格挡") then t[4]=1;t[1]=0;t[2]=0 end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, AbilityAutoAttack, 0, t[2] or 1, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, AbilityAutoAttack, t[5], 0, t[2] or 1, 0, t[3] or 0)
			return
		end
		for a,c,d,g,f,e in strgfind(msg, "(.+)击中(.+)造成(%d+)点(.*)伤害(.*)。(.*)") do
			t = {false, false, false, false, tnbr(d)}
			if strfind(e, "碾压") then t[3]=1;t[1]=0;t[2]=0 elseif strfind(e, "点被格挡") then t[4]=1;t[1]=0;t[2]=0 end
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), AbilityAutoAttack, c)
			end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, AbilityAutoAttack, t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[4] or 0, t[3] or 0)
			DB:DamageTaken(c, AbilityAutoAttack, t[1] or 1, 0, 0, 0, 0, 0, t[5], a, t[3] or 0, t[4] or 0)
			DB:DeathHistory(c, a, AbilityAutoAttack, t[5], t[1] or 1, 0, 0, t[3] or 0)
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureMisses = function(self, msg)
		for c, ta in strgfind(msg, "(.+)发起攻击，(.+)吸收了所有伤害。") do DB:Absorb(AbilityAutoAttack, ta, c); return end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)格挡住了。") do 
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, b, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, a, 1, 0)
			DB:DamageTaken(b, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, a, 0, 1)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)闪躲开了。") do 
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, b, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(b, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)招架住了。") do 
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, b, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)没有击中(.+)。") do 
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, b, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(b, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return 
		end
	end
	
	DPSMate.Parser.SpellPeriodicDamageTaken = function(self, msg)
		for d,e,a,b,c,f,g in strgfind(msg, "(.-)的(.-)使(.+)受到了(%d+)点(.+)伤害(.*)。(.*)") do
			t = {tnbr(b)}
			if f~="" then
				DB:SetUnregisterVariables(tnbr(strsub(f, strfind(f, "%d+"))), e..AbilityPeriodic, d)
			end
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, a, e..AbilityPeriodic, 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DamageTaken(a, e..AbilityPeriodic, 1, 0, 0, 0, 0, 0, t[1], d, 0, 0)
			DB:DeathHistory(a, d, e..AbilityPeriodic, t[1], 1, 0, 0, 0)
			if self.FailDT[e] then DB:BuildFail(2, d, a, e, t[1]) end
			DB:AddSpellSchool(e..AbilityPeriodic,c)
			return
		end
		for a, b in strgfind(msg, "(.+)受到(.+)的伤害") do
			if strfind(b, "%(") then b=strsub(b, 1, strfind(b, "%(")-2) end;
			DB:BuildBuffs(DB.UserUnknown, a, b, false)
			if self.CC[b] then DB:BuildActiveCC(a, b) end
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)吸收了。") do
			DB:Absorb(a..AbilityPeriodic, f, b)
			return
		end
		for f,a in strgfind(msg, "(.+)受到了(.+)效果的影响([（1）]*)。") do
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end;
			DB:BuildBuffs(DB.UserUnknown, f, a, false)
			if self.CC[a] then DB:BuildActiveCC(f, a) end
			return
		end
	end
	
	DPSMate.Parser.CreatureVsCreatureSpellDamage = function(self, msg)
		for a,b,d,e,f in strgfind(msg, "(.-)的(.+)对(.+)造成(%d+)点致命一击伤害。(.*)") do
		 	t = {false, false, tnbr(e), false}
			if strfind(f, "点被格挡") then t[4]=1;t[2]=0 end
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			return
		end
		for a,b,d,e,f,g in strgfind(msg, "(.-)的(.+)致命一击对(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "点被格挡") then t[4]=1;t[2]=0 end
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, 0, t[2] or 1, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], 0, t[2] or 1, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,f)
			return
		end
		for a,b,d,e,h,g,f in strgfind(msg, "(.-)的(.+)击中(.+)造成(%d+)点(.*)伤害(.*)。(.*)") do
			t = {false, false, tnbr(e), false}
			if strfind(f, "点被格挡") then t[4]=1;t[1]=0 end
			if g~="" then
				DB:SetUnregisterVariables(tnbr(strsub(g, strfind(g, "%d+"))), b, a)
			end
			DB:UnregisterPotentialKick(d, b, GetTime())
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, t[4] or 0, 0)
			DB:DamageTaken(d, b, t[1] or 1, 0, 0, 0, 0, 0, t[3], a, 0, t[4] or 0)
			DB:DeathHistory(d, a, b, t[3], t[1] or 1, 0, 0, 0)
			if self.FailDT[b] then DB:BuildFail(2, a, d, b, t[3]) end
			DB:AddSpellSchool(b,h)
			return
		end
		for a,b,c in strgfind(msg, "(.-)的(.+)被(.+)闪躲过去。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			return
		end
		for a,b,c in strgfind(msg, "(.-)的(.+)被(.+)招架了。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 1, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b,c in strgfind(msg, "(.-)的(.+)没有击中(.+)。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 1, 0, 0, 0, 0, a, 0, 0)
			return
		end
		for a,b,c in strgfind(msg, "(.-)的(.+)被(.+)抵抗了。") do
			DB:EnemyDamage(false, DPSMate.Cache.DPSMateEDD, c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			DB:DamageTaken(c, b, 0, 0, 0, 0, 0, 1, 0, a, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)吸收了。") do
			DB:Absorb(a, f, b)
			return
		end
	end

	----------------------------------------------------------------------------------
	--------------                       Healing                        --------------                                  
	----------------------------------------------------------------------------------
	
	local HealingStream = "治疗之泉"
	DPSMate.Parser.SpellSelfBuff = function(self, msg)
		for a,b,c in strgfind(msg, "你的(.+)对(.+)产生极效治疗效果，恢复了(%d+)点生命值。") do 
			t = {tnbr(c)}
			overheal = self:GetOverhealByName(t[1], b)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, b, a, 0, 1, t[1], self.player)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, b, a, 0, 1, t[1]-overheal, self.player)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, self.player, a, 0, 1, t[1]-overheal, b)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, self.player, a, 0, 1, overheal, b)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, b, a, 0, 1, overheal, self.player)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, self.player, a, 0, 1, t[1], b)
			DB:DeathHistory(b, self.player, a, t[1], 0, 1, 1, 0)
			return
		end
		for a,c in strgfind(msg, "你的(.+)对你造成极效治疗，恢复了(%d+)点生命值。") do 
			t = {tnbr(c)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, self.player, a, 0, 1, t[1], self.player)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, self.player, a, 0, 1, t[1]-overheal, self.player)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, self.player, a, 0, 1, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, self.player, a, 0, 1, overheal, self.player)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, self.player, a, 0, 1, overheal, self.player)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, self.player, a, 0, 1, t[1], self.player)
			DB:DeathHistory(self.player, self.player, a, t[1], 0, 1, 1, 0)
			return
		end
		-- Thanks to korolevlong
		for a,b,c in strgfind(msg, "你的(.+)治疗了(.+[^0-9])(%d+)点生命值。") do 
			t = {false, tnbr(c)}
			if b=="你" then t[1]=self.player end
			overheal = self:GetOverhealByName(t[2], t[1] or b)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, t[1] or b, a, 1, 0, t[2], self.player)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, t[1] or b, a, 1, 0, t[2]-overheal, self.player)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, self.player, a, 1, 0, t[2]-overheal, t[1] or b)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, self.player, a, 1, 0, overheal, t[1] or b)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, t[1] or b, a, 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, self.player, a, 1, 0, t[2], t[1] or b)
			DB:DeathHistory(t[1] or b, self.player, a, t[2], 1, 0, 1, 0)
			if self.procs[a] and not self.OtherExceptions[a] then
				DB:BuildBuffs(self.player, self.player, a, true)
			end
			return
		end
		for a,b in strgfind(msg, "你获得了(%d+)点(.+)。") do
			if self.procs[b] and not self.OtherExceptions[b] then
				DB:BuildBuffs(self.player, self.player, b, true)
				DB:DestroyBuffs(self.player, b)
			end
			return
		end
		for b,f,a in strgfind(msg, "你通过(.+)获(.*)(%d+)次额外攻击。") do
			DB:RegisterNextSwing(self.player, tnbr(a), b)
			DB:BuildBuffs(self.player, self.player, b, true)
			DB:DestroyBuffs(self.player, b)
			return
		end	
	end
	
	DPSMate.Parser.SpellPeriodicSelfBuff = function(self, msg)
		--忽略周期性获得资源
		--你从银白之刃的强效智慧祝福获得了36点法力值。
		--你从大草原的湖边的血性狂暴获得了1点怒气。
		for f,a,b,c in strgfind(msg, "你从(.-)的(.+)获得了(%d+)点(.+)。") do
			return
		end
		--你从强效智慧祝福获得了36点法力值。
		--你从血性狂暴获得了1点怒气。
		for f,a,b in strgfind(msg, "你从(.-)获得了(%d+)点(.+)。") do
			return
		end
		for b,c,a in strgfind(msg, "你因(.-)的(.+)而获得了(%d+)点生命值。") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(self.player, b, false)
			end
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, self.player, c..AbilityPeriodic, 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, self.player, c..AbilityPeriodic, 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, b, c..AbilityPeriodic, 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, b, c..AbilityPeriodic, 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, self.player, c..AbilityPeriodic, 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, b, c..AbilityPeriodic, 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, b, c..AbilityPeriodic, t[1], 1, 0, 1, 0)
			return
		end
		for b,a in strgfind(msg, "你因(.+)而获得了(%d+)点生命值。") do 
			t = {tnbr(a)}
			overheal = self:GetOverhealByName(t[1], self.player)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, self.player, b..AbilityPeriodic, 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, self.player, b..AbilityPeriodic, 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, self.player, b..AbilityPeriodic, 1, 0, t[1]-overheal, self.player)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, self.player, b..AbilityPeriodic, 1, 0, overheal, self.player)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, self.player, b..AbilityPeriodic, 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, self.player, b..AbilityPeriodic, 1, 0, t[1], self.player)
			DB:DeathHistory(self.player, self.player, b..AbilityPeriodic, t[1], 1, 0, 1, 0)
			return
		end

		for a in strgfind(msg, "你获得了(.+)的效果([（1）]*)。") do
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(self.player, a, GetTime())
			if self.Dispels[a] then 
				DB:RegisterHotDispel(self.player, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, self.player, a) end
			if self.FailDB[a] then DB:BuildFail(3, "染病蛾", self.player, a, 0) end
			return 
		end
	end
	
	DPSMate.Parser.SpellPeriodicFriendlyOrHostilePlayerBuffs = function(self, msg)
		--忽略周期性获得资源
		--银白之刃从银白之刃的强效智慧祝福获得了36点法力值。
		--杨慢逵从老酒瓶的喂养宠物效果获得了35点快乐。
		--大草原的湖边从大草原的湖边的血性狂暴获得了1点怒气。
		for f,a,b,c,d in strgfind(msg, "(.+)从(.-)的(.+)获得了(%d+)点(.+)。") do
			return
		end

		for f,a,b in strgfind(msg, "(.+)获得(%d+)点生命值（你的(.+)）。") do
			t = {tnbr(a)}
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, f, b..AbilityPeriodic, 1, 0, t[1], self.player)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, f, b..AbilityPeriodic, 1, 0, t[1]-overheal, self.player)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, self.player, b..AbilityPeriodic, 1, 0, t[1]-overheal)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, self.player, b..AbilityPeriodic, 1, 0, overheal)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, f, b..AbilityPeriodic, 1, 0, overheal, self.player)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, self.player, b..AbilityPeriodic, 1, 0, t[1])
			DB:DeathHistory(f, self.player, b..AbilityPeriodic, t[1], 1, 0, 1, 0)
			return
		end
		
		for f,a,b,c in strgfind(msg, "(.+)获得(%d+)点生命值（(.-)的(.+)）。") do
			t = {tnbr(a)}
			if c==HealingStream then
				b = self:AssociateShaman(a, b, false)
			end
			overheal = self:GetOverhealByName(t[1], f)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, f, c..AbilityPeriodic, 1, 0, t[1], b)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, f, c..AbilityPeriodic, 1, 0, t[1]-overheal, b)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, b, c..AbilityPeriodic, 1, 0, t[1]-overheal, f)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, b, c..AbilityPeriodic, 1, 0, overheal, f)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, f, c..AbilityPeriodic, 1, 0, overheal, b)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, b, c..AbilityPeriodic, 1, 0, t[1], f)
			DB:DeathHistory(f, b, c..AbilityPeriodic, t[1], 1, 0, 1, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+)获得了(.+)的效果([（1）]*)。") do
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(f, a, GetTime())
			if self.Dispels[a] then 
				DB:RegisterHotDispel(f, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, f, a) end
			if self.FailDB[a] then DB:BuildFail(3, "染病蛾", f, a, 0) end
			return 
		end
		--[[
		for f,a in strgfind(msg, "(.+)获得了(.+)。") do
			if self.BuffExceptions[a] then return end
			if strfind(a, "%(") then a=strsub(a, 1, strfind(a, "%(")-2) end
			DB:ConfirmBuff(f, a, GetTime())
			if self.Dispels[a] then
				DB:RegisterHotDispel(f, a)
			end
			if self.RCD[a] then DPSMate:Broadcast(1, f, a) end
			if self.FailDB[a] then DB:BuildFail(3, "染病蛾", f, a, 0) end
			return 
		end
		--]]
	end

	DPSMate.Parser.SpellFriendlyOrlHostilePlayerBuff = function(self, msg)
		--有才的爪子的吸血鬼的拥抱发挥极效，为某玩家恢复了95点生命值？
		for user,ability,target,amount in strgfind(msg, "(.-)的(.+)发挥极效，为(.+)恢复了(%d+)点生命值。") do 
			if not DB.has_superwpw then
				for aa,bb in strgfind(user, "(.+)的(.+)") do
					--aa == 有才的爪子, bb == 拥抱
					local bbb = bb.."的"..ability
					if DPSMate.BabbleSpell:HasReverseTranslation(bbb) then
						user = aa
						ability = bbb
					end
					break
				end
			end
			t = {tnbr(amount), false}
			if target=="你" then t[2]=self.player end
			overheal = self:GetOverhealByName(t[1], t[2] or target)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, t[2] or target, ability, 0, 1, t[1], user)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, t[2] or target, ability, 0, 1, t[1]-overheal, user)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, user, ability, 0, 1, t[1]-overheal, t[2] or target)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, user, ability, 0, 1, overheal, t[2] or target)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, t[2] or target, ability, 0, 1, overheal, user)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, user, ability, 0, 1, t[1], t[2] or target)
			DB:DeathHistory(t[2] or target, user, ability, t[1], 0, 1, 1, 0)
			return
		end
		--works for 某牧师的吸血鬼的拥抱为某玩家恢复了95点生命值。
		--works for 有才的爪子的恢复为某玩家恢复了95点生命值？
		--works for 有才的爪子的吸血鬼的拥抱为某玩家恢复了95点生命值？
		for a,b,c,d in strgfind(msg, "(.-)的(.-)为(.+)恢复了(%d+)点生命值。") do 
			if not DB.has_superwpw then
				for aa,bb in strgfind(a, "(.+)的(.+)") do
					--aa == 有才的爪子, bb == 拥抱
					local bbb = bb.."的"..b
					if DPSMate.BabbleSpell:HasReverseTranslation(bbb) then
						a = aa
						b = bbb
					end
					break
				end
			end
			t = {tnbr(d), false}
			if c=="你" then t[2] = self.player end
			overheal = self:GetOverhealByName(t[1], t[2] or c)
			DB:HealingTaken(0, DPSMate.Cache.DPSMateHealingTaken, t[2] or c, b, 1, 0, t[1], a)
			DB:HealingTaken(1, DPSMate.Cache.DPSMateEHealingTaken, t[2] or c, b, 1, 0, t[1]-overheal, a)
			DB:Healing(0, DPSMate.Cache.DPSMateEHealing, a, b, 1, 0, t[1]-overheal, t[2] or c)
			if overheal>0 then 
				DB:Healing(2, DPSMate.Cache.DPSMateOverhealing, a, b, 1, 0, overheal, t[2] or c)
				DB:HealingTaken(2, DPSMate.Cache.DPSMateOverhealingTaken, t[2] or c, b, 1, 0, overheal, a)
			end
			DB:Healing(1, DPSMate.Cache.DPSMateTHealing, a, b, 1, 0, t[1], t[2] or c)
			DB:DeathHistory(t[2] or c, a, b, t[1], 1, 0, 1, 0)
			if self.procs[b] and not self.OtherExceptions[b] then
				DB:BuildBuffs(a, c, b, true)
			end
			return
		end
		for a,b in strgfind(msg, "(.+)开始施放(.+)。")  do
			DB:RegisterPotentialKick(a, b, GetTime())
			return
		end
		for a,b,d in strgfind(msg, "(.+)获得(%d+)点(.+)。") do
			if self.procs[d] and not self.OtherExceptions[d] then
				DB:BuildBuffs(a, a, d, true)
				DB:DestroyBuffs(a, d)
			end
			return 
		end
		for a,c,b in strgfind(msg, "(.+)通过(.+)获得了(%d+)次额外攻击。") do
			DB:RegisterNextSwing(a, tnbr(b), c)
			DB:BuildBuffs(a, a, c, true)
			DB:DestroyBuffs(a, c)
			return 
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Absorbs                        --------------                                  
	----------------------------------------------------------------------------------
	
	DPSMate.Parser.CreatureVsSelfHitsAbsorb = function(self, msg)
		for c, b, absorbed in strgfind(msg, "(.+)击中你造成(%d+)点伤害（(%d+)点被吸收）。") do DB:SetUnregisterVariables(tnbr(absorbed), AbilityAutoAttack, c); return end
	end
	
	DPSMate.Parser.CreatureVsCreatureHitsAbsorb = function(self, msg) end
	
	DPSMate.Parser.CreatureVsSelfSpellDamageAbsorb = function(self, msg)
		for c, ab, b, absorbed in strgfind(msg, "(.-)的(.+)击中你造成(%d+)点伤害（(%d+)点被吸收）。") do DB:SetUnregisterVariables(tnbr(absorbed), ab, c); return end
	end
	
	DPSMate.Parser.CreatureVsCreatureSpellDamageAbsorb = function(self, msg) end
	
	DPSMate.Parser.SpellPeriodicSelfBuffAbsorb = function(self, msg)
		for ab in strgfind(msg, "你获得了(.+)的效果([（1）]*)。") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, self.player, GetTime()) end end
	end

	DPSMate.Parser.SpellPeriodicFriendlyPlayerBuffsAbsorb = function(self, msg)
		for ta, ab in strgfind(msg, "(.+)获得了(.+)的效果([（1）]*)。") do if DB.ShieldFlags[ab] then DB:ConfirmAbsorbApplication(ab, ta, GetTime()) end end
	end
	
	DPSMate.Parser.SpellAuraGoneSelf = function(self, msg)
		for ab in strgfind(msg, "(.+)效果从你身上消失了。") do 
			if self.BuffExceptions[ab] then return end; 
			if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;
			if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, self.player) end; 
			if self.RCD[ab] then DPSMate:Broadcast(6, self.player, ab) end; 
			DB:DestroyBuffs(self.player, ab); 
			DB:UnregisterHotDispel(self.player, ab); 
			DB:RemoveActiveCC(self.player, ab)
		end
	end
	
	DPSMate.Parser.SpellAuraGoneParty = function(self, msg)
		for ab, ta in strgfind(msg, "(.+)效果从(.+)身上消失。") do 
			if self.BuffExceptions[ab] then return end; 
			if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;
			if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; 
			if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; 
			DB:DestroyBuffs(ta, ab); 
			DB:UnregisterHotDispel(ta, ab); 
			DB:RemoveActiveCC(ta, ab) 
		end
	end
	
	DPSMate.Parser.SpellAuraGoneOther = function(self, msg)
		for ab, ta in strgfind(msg, "(.+)效果从(.+)身上消失。") do 
			if self.BuffExceptions[ab] then return end; 
			if strfind(ab, "%(") then ab=strsub(ab, 1, strfind(ab, "%(")-2) end;
			if DB.ShieldFlags[ab] then DB:UnregisterAbsorb(ab, ta) end; 
			if self.RCD[ab] then DPSMate:Broadcast(6, ta, ab) end; 
			DB:DestroyBuffs(ta, ab); 
			DB:UnregisterHotDispel(ta, ab); 
			DB:RemoveActiveCC(ta, ab) 
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Dispels                        --------------                                  
	----------------------------------------------------------------------------------
	
	DPSMate.Parser.SpellSelfBuffDispels = function(self, msg)
		for tar, ab in strgfind(msg, "你对(.+)施放了(.+)。") do if self.Dispels[ab] then DB:AwaitDispel(ab, tar, self.player, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, self.player, tar, ab) end; return end
		for ab in strgfind(msg, "你施放了(.+)。") do if self.Dispels[ab] then DB:AwaitDispel(ab, self.player, self.player, GetTime()) end; return end
	end
	
	DPSMate.Parser.SpellHostilePlayerBuffDispels = function(self, msg)
		for c, ta, ab in strgfind(msg, "(.+)对(.+)施放了(.+)。") do if ta=="你" then ta = self.player end; if self.Dispels[ab] then DB:AwaitDispel(ab, ta, c, GetTime()) end; if self.RCD[ab] then DPSMate:Broadcast(2, c, ta, ab) end; return end
		for c, ab in strgfind(msg, "(.+)施放了(.+)。") do if self.Dispels[ab] then DB:AwaitDispel(ab, DB.UserUnknown, c, GetTime()) end; return end
	end
	
	DPSMate.Parser.SpellBreakAura = function(self, msg) 
		for ab in strgfind(msg, "你的(.+)被移除了。") do DB:ConfirmRealDispel(ab, self.player, GetTime()); return end
		--XX的因塔苟斯的凝视被移除了。
		--考虑到中文技能名中可能包含"的"字，比如"瘟疫使者的诅咒"、"因塔苟斯的凝视"等
		--又玩家名字中也可能包括"的"字，两者已经不可得兼，取兼容技能名称含的字。
		for ta, ab in strgfind(msg, "(.-)的(.+)被移除了。") do DB:ConfirmRealDispel(ab, ta, GetTime()); return end
	end
	
	----------------------------------------------------------------------------------
	--------------                       Deaths                         --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CombatFriendlyDeath = function(self, msg)
		for ta in strgfind(msg, "(.+)被摧毁了。") do
			DB:UnregisterDeath(ta) 
		end
		for ta in strgfind(msg, "(.+)死亡了。") do 
			DB:UnregisterDeath(ta) 
			DB:DestroyBuffs(ta, "all")
		end
		if msg == "你死了。" then 
			DB:UnregisterDeath(self.player) 
			DB:DestroyBuffs(self.player, "all")
		end
	end

	DPSMate.Parser.CombatHostileDeaths = function(self, msg)
		for ta in strgfind(msg, "(.+)死亡了。") do 
			DB:UnregisterDeath(ta)
			DB:DestroyBuffs(ta, "all")
		end
		for ta in strgfind(msg, "(.+)被摧毁了。") do 
			DB:UnregisterDeath(ta)
			DB:DestroyBuffs(ta, "all")
		end
	end
	
	----------------------------------------------------------------------------------
	--------------                     Interrupts                       --------------                                  
	----------------------------------------------------------------------------------

	DPSMate.Parser.CreatureVsCreatureSpellDamageInterrupts = function(self, msg)
		for c, ab in strgfind(msg, "(.+)开始施放(.+)。") do 
			DB:RegisterPotentialKick(c, ab, GetTime())
			return
		end
	end
	DPSMate.Parser.HostilePlayerSpellDamageInterrupts = function(self, msg)
		for c, ab in strgfind(msg, "(.+)开始施放(.+)。") do 
			DB:RegisterPotentialKick(c, ab, GetTime())
			return
		end
	end
	
	-- Pet section
	DPSMate.Parser.PetHits = function(self, msg)
		for a,b,c,f,e in strgfind(msg, "(.+)击中(.+)造成(%d+)点(.*)伤害（(%d+)点被吸收）。") do
			DB:SetUnregisterVariables(tnbr(e), AbilityAutoAttack, a)
		end
		for a,b,c,d in strgfind(msg, "(.+)对(.+)造成(%d+)的致命一击伤害。%s?(.*)") do
		 	t = {false, false, false, false, tnbr(c)}
			if d=="(偏斜)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b == "你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[a] then
					DB:BuildFail(1, b, a, AbilityAutoAttack, t[5]);
				end
				DB:DeathHistory(b, a, AbilityAutoAttack, t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,f,d in strgfind(msg, "(.+)的致命一击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(偏斜)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b == "你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, t[3] or 1, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[a] then 
					DB:BuildFail(1, b, a, AbilityAutoAttack, t[5]);
				end
				DB:DeathHistory(b, a, AbilityAutoAttack, t[5], 0, 1, 0, 0) end
			return
		end
		for a,b,c,f,d in strgfind(msg, "(.+)击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do
			t = {false, false, false, false, tnbr(c)}
			if d=="(偏斜)" then t[1]=1;t[3]=0 elseif d~="" then t[2]=1;t[3]=0 end
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, t[3] or 1, 0, 0, 0, 0, 0, t[5], b, t[2] or 0, t[1] or 0)
			DB:DamageDone(a, AbilityAutoAttack, t[3] or 1, 0, 0, 0, 0, 0, t[5], t[1] or 0, t[2] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[a] then
					DB:BuildFail(1, b, a, AbilityAutoAttack, t[5]);
				end
				DB:DeathHistory(b, a, AbilityAutoAttack, t[5], 1, 0, 0, 0) end
			return
		end
	end

	DPSMate.Parser.PetMisses = function(self, msg)
		for a,b in strgfind(msg, "(.+)没有击中(.+)。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)闪躲开了。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, b, 0, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)招架住了。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for a,b in strgfind(msg, "(.+)发起了攻击。(.+)格挡住了。") do 
			if b=="你" then b=self.player end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, a, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(a, AbilityAutoAttack, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for c,b in strgfind(msg, "(.+)发起攻击，(.+)吸收了所有伤害。") do if b=="你" then b=self.player end; DB:Absorb(AbilityAutoAttack, b, c); return end
	end

	DPSMate.Parser.PetSpellDamage = function(self, msg)
		for k,a,b,c,g,f in strgfind(msg, "(.-)的(.+)击中(.+)造成(%d+)点(.*)伤害（(%d+)点被吸收）。") do 
			DB:SetUnregisterVariables(tnbr(f), b, k)
		end
		for f,a,b,c,e in strgfind(msg, "(.-)的(.+)对(.+)造成(%d+)点致命一击伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="你" then b=self.player end
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[f] then
					DB:BuildFail(1, b, f, a, t[1]);
				end
				DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			return
		end
		for f,a,b,c,g,e in strgfind(msg, "(.+)的(.+)致命一击对(.+)造成(%d+)点(.*)伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="你" then b=self.player end
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, c, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a,  0, t[2] or 1, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, 0, t[2] or 1, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[f] then
					DB:BuildFail(1, b, f, a, t[1]);
				end
				DB:DeathHistory(b, f, a, t[1], 0, 1, 0, 0) end
			DB:AddSpellSchool(a,g)
			return
		end
		for f,a,b,c,g,e in strgfind(msg, "(.+)的(.+)击中(.+)造成(%d+)点(.*)伤害。%s?(.*)") do 
			t = {tnbr(c), false, false, false}
			if b=="你" then b=self.player end
			if strfind(e, "点被格挡") then t[4]=1;t[2]=0;t[3]=0 end
			if DPSMate.Parser.Kicks[a] then DB:AssignPotentialKick(f, a, b, GetTime()) end
			if DPSMate.Parser.DmgProcs[a] then DB:BuildBuffs(f, f, a, true) end
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a,  t[2] or 1, 0, 0, 0, 0, 0, t[1], b, t[4] or 0, 0)
			DB:DamageDone(f, a, t[2] or 1, 0, 0, 0, 0, 0, t[1], 0, t[4] or 0, b)
			if self.TargetParty[b] then 
				if self.TargetParty[f] then
					DB:BuildFail(1, b, f, a, t[1]);
				end
				DB:DeathHistory(b, f, a, t[1], 1, 0, 0, 0) end
			return
		end
		for f,b,a in strgfind(msg, "(.+)的(.+)被(.+)闪躲过去。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, b, 0, 0, 0, 0, 1, 0, 0, a, 0, 0)
			DB:DamageDone(f, b, 0, 0, 0, 0, 1, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+)的(.+)被(.+)招架了。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 0, 1, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 1, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+)的(.+)没有击中(.+)。") do
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 1, 0, 0, 0, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 1, 0, 0, 0, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.-)的(.+)被(.+)抵抗了。") do
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 0, 0, 0, 1, 0, b, 0, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 1, 0, 0, 0)
			return
		end
		for f,a,b in strgfind(msg, "(.+)的(.+)被(.+)格挡过去。") do 
			DB:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, f, a, 0, 0, 0, 0, 0, 0, 0, b, 1, 0)
			DB:DamageDone(f, a, 0, 0, 0, 0, 0, 0, 0, 0, 1)
			return
		end
		for who, whom, what in strgfind(msg, "(.+)打断了(.+)的(.+)。") do
			local causeAbility = "法术反制"
			if DPSMate.Cache.DPSMateUser[who] then
				if DPSMate.Cache.DPSMateUser[who][2] == "priest" then
					causeAbility = "沉默"
				end
				-- Account for felhunter silence
				if DPSMate.Cache.DPSMateUser[who][4] and DPSMate.Cache.DPSMateUser[who][6] then
					local owner = DPSMate:GetUserById(DPSMate.Cache.DPSMateUser[who][6])
					if owner and DPSMate.Cache.DPSMateUser[owner] then
						causeAbility = "法术封锁"
						who = owner
					end
				end
			end
			DB:Kick(who, whom, causeAbility, what)
		end
	end
end
