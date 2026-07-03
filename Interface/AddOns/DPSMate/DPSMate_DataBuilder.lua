-- Events
local DPSMate = DPSMate

DPSMate.DB:RegisterEvent("VARIABLES_LOADED")
DPSMate.DB:RegisterEvent("PLAYER_LOGIN")
DPSMate.DB:RegisterEvent("PLAYER_REGEN_DISABLED")
DPSMate.DB:RegisterEvent("PLAYER_REGEN_ENABLED")
DPSMate.DB:RegisterEvent("PLAYER_AURAS_CHANGED")
DPSMate.DB:RegisterEvent("PLAYER_TARGET_CHANGED")
DPSMate.DB:RegisterEvent("PLAYER_PET_CHANGED")
DPSMate.DB:RegisterEvent("PET_STABLE_CLOSED")
DPSMate.DB:RegisterEvent("ZONE_CHANGED_NEW_AREA")

if DPSMate.DB.has_superwow then
	DPSMate.DB:RegisterEvent("UNIT_CASTEVENT")
end

-- Global Variables
DPSMate.DB.loaded = false
DPSMate.DB.ShieldFlags = {
	["Power Word: Shield"] = 0, -- All
	["Ice Barrier"] = 0, -- All
	["The Burrower's Shell"] = 0, -- All
	["Aura of Protection"] = 0, -- All
	["Damage Absorb"] = 0, -- All
	["Physical Protection"] = 1, -- Meele
	["Harm Prevention Belt"] = 0, -- All
	["Mana Shield"] = 1, -- Meele
	["Frost Protection"] = 2, -- Frost
	["Frost Resistance"] = 2, -- Frost
	["Frost Ward"] = 2, -- Frost
	["Fire Protection"] = 3, -- Fire
	["Fire Ward"] = 3, -- Fire
	["Nature Protection"] = 4, -- Nature
	["Shadow Protection"] = 5, -- Shadow
	["Arcane Protection"] = 6, -- Arcane
	["Holy Protection"] = 7, -- Holy
}
DPSMate.DB.FixedShieldAmounts = {
	["Power Word: Shield"] = 1000, -- All
	["Ice Barrier"] = 818, -- All
	["The Burrower's Shell"] = 900, -- All
	["Aura of Protection"] = 1000, -- All
	["Damage Absorb"] = 550, -- All
	["Physical Protection"] = 500, -- Meele
	["Harm Prevention Belt"] = 500, -- All
	["Mana Shield"] = 570, -- Meele
	["Frost Protection"] = 2500, -- Frost
	["Frost Resistance"] = 600, -- Frost
	["Frost Ward"] = 920, -- Frost
	["Fire Protection"] = 2500, -- Fire
	["Fire Ward"] = 920, -- Fire
	["Nature Protection"] = 2500, -- Nature
	["Shadow Protection"] = 2500, -- Shadow
	["Arcane Protection"] = 2500, -- Arcane
	["Holy Protection"] = 2500, -- Holy
}

local AbilityFlags = {
	["fire"] = 3,
	["holy"] = 7,
	["arcane"] = 6,
	["shadow"] = 5,
	["nature"] = 4,
	["frost"] = 2,
	["physical"] = 1,
	
	["feuer"] = 3,
	["heilig"] = 7,
	["arkan"] = 6,
	["schatten"] = 5,
	["natur"] = 4,
	["frost"] = 2,
	["physisch"] = 1,
	
	["火焰"] = 3,
	["神圣"] = 7,
	["奥术"] = 6,
	["暗影"] = 5,
	["自然"] = 4,
	["冰霜"] = 2,
	["物理"] = 1,

	["ombre"] = 5,
	["feu"] = 3,
	["nature"] = 4,
	["givre"] = 2,
	["arcane"] = 6,
	["sacré"] = 7,
	["d'ombre"] = 5,
	["d'feu"] = 3,
	["d'nature"] = 4,
	["d'givre"] = 2,
	["d'arcane"] = 6,
	["d'sacré"] = 7,
	["de ombre"] = 5,
	["de feu"] = 3,
	["de givre"] = 2,
	["de nature"] = 4,
	["de arcane"] = 6,
	["de sacré"] = 7,
	["physique"] = 1,
	["d'physique"] = 1,
	["de physique"] = 1,

	["огонь"] = 3,
	["обычный"] = 7,
	["тайная магия"] = 6,
	["тьма"] = 5,
	["природа"] = 4,
	["лед"] = 2,
	["физический урон"] = 1,
}
DPSMate.DB.NeedUpdate = false
DPSMate.DB.MainUpdate = 0
DPSMate.DB.Zones = {
	[DPSMate.L["mc"]] = true,
	[DPSMate.L["bwl"]] = true,
	[DPSMate.L["ony"]] = true,
	[DPSMate.L["zg"]] = true,
	[DPSMate.L["aq401"]] = true,
	[DPSMate.L["aq20"]] = true,
	[DPSMate.L["aq402"]] = true,
	[DPSMate.L["naxx"]] = true,
	[DPSMate.L["azs"]] = true, -- Azuregos
	[DPSMate.L["bl"]] = true, -- Kazzak
	[DPSMate.L["dw"]] = true, -- Emerald dragons, not sure if those zone names are correct.
	[DPSMate.L["hintl"]] = true,
	[DPSMate.L["ash"]] = true,
	[DPSMate.L["fe"]] = true
}

DPSMate.DB.precision = 1.0
DPSMate.DB.userlen = 0
DPSMate.DB.abilitylen = 0

-- Local Variables
local CombatState = false
local cheatCombat = 0
local UpdateTime = 0.125
local LastUpdate = 0
local MainLastUpdate = 0
local MainUpdateTime = 1.5
local tinsert = table.insert
local tremove = table.remove
local _G = getglobal
local player
local player_guid
local GT = GetTime
local strfind = string.find
local strgfind = string.gfind
local strsub = string.sub
local UL = UnitLevel
local strlower = strlower
local strformat = string.format
local UnitClass = UnitClass
local GetGuildInfo = GetGuildInfo
local GetRaidRosterInfo = GetRaidRosterInfo
local GetRealZoneText = GetRealZoneText
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local GetGameTime = GetGameTime
local UnitName = UnitName
local UnitFactionGroup = UnitFactionGroup
local UnitAffectingCombat = UnitAffectingCombat
local UnitIsPlayer = UnitIsPlayer
local UnitIsDead = UnitIsDead
local UnitBuff = UnitBuff
local UnitInRaid = UnitInRaid
local UnitIsPet = UnitIsPet
local pairs = pairs
local floor = floor
local UnitIsConnected = UnitIsConnected
local time, path, gen

local AutoAttackAbility

DPSMate.DB.windfuryab = {
	["Windfury Weapon"] = true,
	["Windfury Totem"] = true,
}

local playerfaction = UnitFactionGroup("player")
local tablemodes = {"total","current"}

local function GameTime_GT()
	local hour, minutes = GetGameTime()
	if hour>12 then
		hour = mod(hour, 12)
		if minutes<10 then
			return hour..":0"..minutes.." PM"
		else
			return hour..":"..minutes.." PM"
		end
	else
		hour = mod(hour, 12)
		if minutes<10 then
			return hour..":0"..minutes.." AM"
		else
			return hour..":"..minutes.." AM"
		end
	end
end

-- Begin Functions
DPSMate.DB.VARIABLES_LOADED = function()
	if not this.loaded then
		--workaround for twow 1.17.2 translation bug
		if GetLocale() == "zhCN" and string.find(PERIODICAURADAMAGEOTHEROTHER, " suffers ") then 
			PERIODICAURADAMAGEOTHEROTHER = "%4$s的%5$s使%1$s受到了%2$d点%3$s伤害。" 
			PERIODICAURADAMAGESELFOTHER = "你的%4$s使%1$s受到了%2$d点%3$s伤害。" 
			PERIODICAURAHEALOTHERSELF = "你因%2$s的%3$s而获得了%1$d点生命值。" 
			PERIODICAURAHEALSELFSELF = "你因%2$s而获得了%1$d点生命值。"

			POWERGAINOTHEROTHER = "%1$s从%4$s的%5$s获得了%2$d点%3$s。"; -- Bob gains 5 mana from Fred's spell.
			POWERGAINOTHERSELF = "你从%3$s的%4$s获得了%1$d点%2$s。"; -- You gain 5 mana from Bob's spell.
			POWERGAINSELFOTHER = "%1$s从%4$s获得了%2$d点%3$s。"; -- Bob gains 5 mana from spell.
			POWERGAINSELFSELF = "你从%3$s获得了%1$d点%2$s。"; -- You gain 5 mana from spell.
		end
		
		local reset = not DPSMATERESET or DPSMATERESET<DPSMate.VERSION
		if reset then DPSMate.DB:ResetDB() end
		DPSMate.DB:InitDB()

		DPSMATERESET = DPSMate.VERSION

		DPSMate:OnLoad()
		DPSMate.Options:InitializeSegments()
		DPSMate.Options:InitializeHideShowWindow()

		DPSMate.Sync:OnLoad()
		
		player = UnitName("player")
		_,player_guid = UnitExists("player")

		local frames = {"", "_Absorbs", "_AbsorbsTaken", "_Auras", "_Casts", "_CCBreaker", "_CureDisease", "_CureDiseaseReceived", "_CurePoison", "_CurePoisonReceived", "_DamageTaken", "_DamageTakenTotal", "_DamageTotal", "_Deaths", "_Decurses", "_DecursesReceived", "_Dispels", "_DispelsReceived", "_EDD", "_EDT", "_EHealing", "_EHealingTaken", "_Fails", "_FF", "_FFT", "_Healing", "_HealingTaken", "_Interrupts", "_LiftMagic", "_LiftMagicReceived", "_OHealingTaken", "_Overhealing", "_Procs", "_AbsorbsTakenTotal", "_AbsorbsTotal", "_AurasTotal", "_CastsTotal", "_CCBreakerTotal", "_CureDisease_Total", "_CurePoison_Total", "_Deaths_Total", "_Decurses_Total", "_Dispels_Total", "_EDDTotal", "_EDTTotal", "_EHealingTakenTotal", "_EHealingTotal", "_FailsTotal", "_FFTotal", "_FFTTotal", "_HABTotal", "_HealingTakenTotal", "_HealingTotal", "_Interrupts_Total", "_LiftMagic_Total", "_OverhealingTakenTotal", "_OverhealingTotal", "_ProcsTotal"}
		for cat, val in pairs(frames) do
			if _G("DPSMate_Details"..val) then
				_G("DPSMate_Details"..val):SetToplevel(true)
			end
		end
		
		DPSMate.Parser:OnLoad()
		this:OnGroupUpdate()
		DPSMate:SetStatusBarValue()
		this.NeedUpdate = true
		DPSMate.Sync:RegisterEvent("CHAT_MSG_ADDON")
		DPSMate.Sync:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		DPSMate.Sync:SetScript("OnEvent", function() this[event](arg1,arg2,arg3,arg4) end)
		DPSMate.Sync:SetScript("OnUpdate", function() this:OnUpdate() end)
		DPSMate.Options:SetScript("OnEvent", function() this[event]() end)
		DPSMate.Options:SetScript("OnUpdate", function() this:OnUpdate() end)

--		DPSMate:SendMessage("DPSMate build "..DPSMate.VERSION.." has been loaded!")
        	--print('|cff00ffffDPSMate 已加载|r /dps')
		this.loaded = true
		DPSMate.Options.PLAYER_ENTERING_WORLD()
	end
end

DPSMate.DB.PLAYER_LOGIN = function()
	if GetCVar("CombatLogPeriodicSpells") then 
		SetCVar("CombatLogPeriodicSpells", 1) 
	else 
		RegisterCVar("CombatLogPeriodicSpells", 1) 
	end
	if GetCVar("CombatLogRangeParty") then 
		SetCVar("CombatLogRangeParty", 200) 
	else 
		RegisterCVar("CombatLogRangeParty", 200) 
	end
	if GetCVar("CombatLogRangePartyPet") then 
		SetCVar("CombatLogRangePartyPet", 200) 
	else 
		RegisterCVar("CombatLogRangePartyPet", 200) 
	end
	if GetCVar("CombatLogRangeFriendlyPlayers") then 
		SetCVar("CombatLogRangeFriendlyPlayers", 200) 
	else 
		RegisterCVar("CombatLogRangeFriendlyPlayers", 200) 
	end
	if GetCVar("CombatLogRangeFriendlyPlayersPets") then 
		SetCVar("CombatLogRangeFriendlyPlayersPets", 200) 
	else 
		RegisterCVar("CombatLogRangeFriendlyPlayersPets", 200) 
	end
	if GetCVar("CombatLogRangeHostilePlayers") then 
		SetCVar("CombatLogRangeHostilePlayers", 200) 
	else 
		RegisterCVar("CombatLogRangeHostilePlayers", 200) 
	end
	if GetCVar("CombatLogRangeHostilePlayersPets") then 
		SetCVar("CombatLogRangeHostilePlayersPets", 200) 
	else 
		RegisterCVar("CombatLogRangeHostilePlayersPets", 200) 
	end
	if GetCVar("CombatLogRangeCreature") then 
		SetCVar("CombatLogRangeCreature", 200) 
	else 
		RegisterCVar("CombatLogRangeCreature", 200) 
	end
	if GetCVar("CombatDeathLogRange") then 
		SetCVar("CombatDeathLogRange", 200) 
	else 
		RegisterCVar("CombatDeathLogRange", 200) 
	end
end

DPSMate.DB.PLAYER_REGEN_DISABLED = function()
	if DPSMate.DPSMateSettings["hideincombat"] then
		for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
			if not val then break end
			_G("DPSMate_"..val["name"]):Hide()
		end
		if DPSMate.DPSMateSettings["disablewhilehidden"] then
			DPSMate:Disable()
		end
	end
	DPSMate.Options:HideWhenSolo()
	if (not CombatState and cheatCombat<GT()) then
		DPSMate.Options:NewSegment()
	end
	CombatState = true
end

DPSMate.DB.PLAYER_REGEN_ENABLED = function()
	if DPSMate.DPSMateSettings["hideincombat"] then
		for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
			if not val then break end
			if not val["hidden"] then
				_G("DPSMate_"..val["name"]):Show()
			end
		end
		DPSMate:Enable()
	end
	DPSMate.Options:HideWhenSolo()
end

local cheatDeathTable = {
	["Interface\\Icons\\Ability_Vanish"] = true,
	["Interface\\Icons\\Ability_Rogue_Feighdeath"] = true,
	["Interface\\Icons\\ability_vanish"] = true,
	["Interface\\Icons\\Ability_vanish"] = true,
	["Interface\\Icons\\ability_rogue_feighdeath"] = true,
	["Interface\\Icons\\Ability_rogue_feighdeath"] = true,
}
DPSMate.DB.PLAYER_AURAS_CHANGED = function()
	local tex
	time = GT()
	for i=1, 32 do
		tex = UnitBuff("player", i)
		if not tex then break end
		if cheatDeathTable[tex] then
			if cheatCombat<time then
				cheatCombat = time + 10
			end
			break
		end
	end
end

function DPSMate.DB:MakePetName(player, pet)
	if self.has_superwow then pet = pet .." (".. player ..")" end
	return pet
end

function DPSMate.DB:BuildPlayer(unit, unitPet)
	if UnitIsConnected(unit) then
		local name = UnitName(unit)
		local pet = UnitName(unitPet)

		local _,name_guid = UnitExists(unit)
		local _,pet_guid = UnitExists(unitPet)
		
		local _,classEng = UnitClass(unit)
		local _,fac = UnitFactionGroup(unit)
		local gname, _, _ = GetGuildInfo(unit)
		local level = UL(unit)

		self:BuildUser(name, strlower(classEng or ""))

		if classEng then
			DPSMate.Cache.DPSMateUser[name][2] = strlower(classEng)
		end
		
		if pet and pet ~= DPSMate.L["unknown"] and pet ~= "" then
			pet = self:MakePetName(name, pet)
			self:BuildUser(pet)
			self:AssociatePet(name, pet)
			--DPSMate.Cache.DPSMateUser[pet][4] = true
			--DPSMate.Cache.DPSMateUser[name][5] = pet
			--DPSMate.Cache.DPSMateUser[pet][6] = user[1]
		end

		--pet name confilct with player?
		if pet and DPSMate.Parser.TargetParty[pet] then
			DPSMate.Cache.DPSMateUser[pet][4] = nil
			DPSMate.Cache.DPSMateUser[pet][6] = nil
			DPSMate.Cache.DPSMateUser[name][5] = nil
		end
		if DPSMate.Cache.DPSMateUser[name][4] then
			DPSMate.Cache.DPSMateUser[name][4] = nil
			DPSMate.Cache.DPSMateUser[name][5] = nil
		end

		if fac == DPSMate.L["alliance"] then
			DPSMate.Cache.DPSMateUser[name][3] = 1
		elseif fac == DPSMate.L["horde"] then
			DPSMate.Cache.DPSMateUser[name][3] = -1
		end
		
		DPSMate.Parser.TargetParty[name] = unit
		if name_guid then DPSMate.Parser.TargetParty[name_guid] = unit end
		
		if pet then
			DPSMate.Parser.TargetParty[pet] = unitPet
			if pet_guid then DPSMate.Parser.TargetParty[pet_guid] = unitPet end
		end
		
		if (gname and gname ~= "") then
			DPSMate.Cache.DPSMateUser[name][7] = gname
		end
		if level and level>0 then
			DPSMate.Cache.DPSMateUser[name][8] = level
		end
	end
end

DPSMate.DB.PLAYER_TARGET_CHANGED = function()
	if UnitIsPlayer("target") then
		this:BuildPlayer("target", "targetpet")
	end
end

DPSMate.DB.PLAYER_PET_CHANGED = function()
	this:OnGroupUpdate()
end

DPSMate.DB.PET_STABLE_CLOSED = function()
	this:OnGroupUpdate()
end

DPSMate.DB.ZONE_CHANGED_NEW_AREA = function()
	this:ResetTempTable()
	this:OnGroupUpdate()
end

DPSMate.DB.UNIT_CASTEVENT = function()
	if arg3 == "MAINHAND" then
		AutoAttackAbility = AutoAttackAbility or { DPSMate.L["AutoAttack"], DPSMate.L["AutoAttackOffhand"] }
		local user = arg1
		if not player_guid then _,player_guid = UnitExists("player") end
		if user == player_guid then user = player end
		DPSMate.Cache.DPSMateUserOffHand[user] = nil
		--if user == UnitName("player") then CombatLogAdd("你开始主手攻击。") ChatFrame4:AddMessage(user.."开始主手攻击。") end
	elseif arg3 == "OFFHAND" then
		AutoAttackAbility = AutoAttackAbility or { DPSMate.L["AutoAttack"], DPSMate.L["AutoAttackOffhand"] }
		local user = arg1
		if not player_guid then _,player_guid = UnitExists("player") end
		if user == player_guid then user = player end
		DPSMate.Cache.DPSMateUserOffHand[user] = 1
		--if user == UnitName("player") then CombatLogAdd("你开始副手攻击。") ChatFrame4:AddMessage(user.."开始副手攻击。") end
	end
end

function DPSMate.DB:OnGroupUpdate()
	local teamtype = "raid"
	local num = GetNumRaidMembers()
	
	DPSMate.Parser.TargetParty = {}
	
	if num<=0 then
		teamtype = "party"
		num = GetNumPartyMembers()
	end

	for i=1, num do
		self:BuildPlayer(teamtype..i, teamtype.."pet"..i)
	end

	self:BuildPlayer("player", "pet")
	DPSMate.Parser.TargetParty[UnitName("player")] = "player"

	DPSMate.Parser:AssociateShaman("None", "None", true)
end

function DPSMate.DB:AssociatePet(name, pet)
	if not self.has_superwow then
		DPSMate.Cache.DPSMateUser[pet][4] = true
		DPSMate.Cache.DPSMateUser[name][5] = pet
		DPSMate.Cache.DPSMateUser[pet][6] = DPSMate.Cache.DPSMateUser[name][1]
	else
		DPSMate.Cache.DPSMateUser[name][5] = pet
	end
end

function DPSMate.DB:GetPetsName(user)
	local pet
	if self.has_superwow then
		pet = user[9] or (user[5] and { [user[5]] = true })
	else
		if user[5] then pet = { [user[5]] = true } end
	end
	return pet
end

function DPSMate.DB:BuildUser(Dname, Dclass)
	if Dname then
		local pet, usr
		if strsub(Dname,1,2) == "0x" then --name is guid
			local name = DPSMate.Cache.GUID[Dname]
			if not name then
				name = UnitName(Dname)
				if not name then name=DPSMate.L["unknown"]("") end

				--try pet
				local owner = UnitName(Dname.."owner")
				if owner then 
					name = name.." ("..owner..")" 
					pet = name
					usr = owner
				end
				
				DPSMate.Cache.GUID[Dname] = name
			end 
			Dname = name
		else
			if self.has_superwow then _,_,pet, usr = strfind(Dname, "^(.-)%s*%((.-)%)") end
		end

		if not DPSMate.Cache.DPSMateUser[Dname] then
			self.userlen = self.userlen + 1
			DPSMate.Cache.DPSMateUser[Dname] = {
				[1] = self.userlen,
				[2] = Dclass,
			}
			DPSMate.UserId[self.userlen] = Dname
			--DPSMate.UserId = nil
		end

		if self.has_superwow then
			if pet and usr then
				if not DPSMate.Cache.DPSMateUser[usr] then
					self:BuildUser(usr, nil)
				end

				DPSMate.Cache.DPSMateUser[Dname][4] = true --mark as pet
				
				if not DPSMate.Cache.DPSMateUser[usr][5] then
					DPSMate.Cache.DPSMateUser[usr][5] = Dname
				end
				
				if not DPSMate.Cache.DPSMateUser[usr][9] then DPSMate.Cache.DPSMateUser[usr][9] = {} end
				DPSMate.Cache.DPSMateUser[usr][9][Dname] = true
				DPSMate.Cache.DPSMateUser[Dname][6] = DPSMate.Cache.DPSMateUser[usr][1]
			end
		end
		
		return DPSMate.Cache.DPSMateUser[Dname][1] --id
	end
end

function DPSMate.DB:AutoAttackAB(user)
	local offhand = DPSMate.Cache.DPSMateUserOffHand[user] or 0
	return AutoAttackAbility[offhand + 1]
end

function DPSMate.DB:BuildAbility(name, kind, school, user)
	if name then
		--wjf test
		if DPSMate.debug and strsub(name, 1, 2) == "0x" then --name is guid
			print(arg1)
			print(arg2)
			print(debugstack())
		end
		
		if user and AutoAttackAbility and name == self.AAttack then
			name = self:AutoAttackAB(user)
		end

		if not DPSMate.Cache.DPSMateAbility[name] then
			self.abilitylen = self.abilitylen + 1
			DPSMate.Cache.DPSMateAbility[name] = {
				[1] = self.abilitylen,
				[2] = kind,
				[3] = school,
			}
			DPSMate.AbilityId[self.abilitylen] = name
			--DPSMate.AbilityId = nil
			return self.abilitylen
		end
		return DPSMate.Cache.DPSMateAbility[name][1]
	end
end

-- KTMHOOK
DPSMate.DB.specialAbTrans = {
	["heroicstrike"] = "Heroic Strike",
	["maul"] = "Maul",	
	["swipe"] = "Swipe",
	["shieldslam"] = "Shield Slam",
	["revenge"] = "Revenge",
	["shieldbash"] = "Shield Bash",
	["sunder"] = "Sunder Armor",
	["cleave"] = "Cleave",
	["searingpain"] = "Searing Pain",
	["earthshock"] = "Earth Shock",
	["mindblast"] = "Mind Blast",
	["holyshield"] = "Holy Shield",
	["heroicstrike"] = "Heroic Strike",
	["thunderfury"] = "Thunderfury",
	["graceofearth"] = "Grace of Earth",
	["blackamnesty"] = "Black Amnesty",
	["whitedamage"] = "AutoAttack",
}
DPSMate.DB.KTMHOOK = {}
DPSMate.DB.ktmavail = false

local SendAddonMessage = SendAddonMessage
function DPSMate.DB:UpdateThreat()
	if self.KTMHOOK ~= {} then
		local str
		for cat, val in pairs(self.KTMHOOK) do
			local curNpc, curNpcNum = {}, 0
			if str then
				str = str..',["'..cat..'"]={'
			else
				str = '["'..cat..'"]={'
			end
			for ca, va in pairs(val) do
				if curNpc[va[1]] then
					str = str..','..va[2]
				else
					if curNpcNum==0 then
						str = str..'["'..va[1]..'"]={'..va[2]
					else
						str = str..'},["'..va[1]..'"]={'..va[2]
					end
					curNpc[va[1]] = true
					curNpcNum = curNpcNum + 1
				end
			end
			str = str..'}}'
		end
		if str then
			self.KTMHOOK = {}
			SendAddonMessage("KLHTMHOOK", str, "RAID")
		end
	end
end

function DPSMate.DB:Threat(cause, spellname, target, value, amount)
	if value==0 then return end
	if not DPSMate.EnabledModules["threat"] then return end
	target = self:BuildUser(target)
	cause = self:BuildUser(cause)
	spellname = self:BuildAbility(spellname)
	for cat, val in pairs(tablemodes) do
		if not DPSMate.Cache.DPSMateThreat[cat][cause] then
			DPSMate.Cache.DPSMateThreat[cat][cause] = {}
		end
		if not DPSMate.Cache.DPSMateThreat[cat][cause][target] then
			DPSMate.Cache.DPSMateThreat[cat][cause][target] = {}
		end
		if not DPSMate.Cache.DPSMateThreat[cat][cause][target][spellname] then
			DPSMate.Cache.DPSMateThreat[cat][cause][target][spellname] = {
				[1] = 0, -- Amount
				[2] = 0, -- Min
				[3] = 0, -- Max
				[4] = 0, -- Hits
				["i"] = {}
			}
		end
		local path = DPSMate.Cache.DPSMateThreat[cat][cause][target][spellname]
		path[1] = path[1] + value
		path[4] = path[4] + amount
		if path[2]==0 or path[2]>value then
			path[2] = value
		end
		if path[3]<value then
			path[3] = value
		end
		
		if value>0 then
			local time = floor(DPSMate.Cache.DPSMateCombatTime[val])
			if path["i"][time] then
				path["i"][time] = path["i"][time] + value
			else
				path["i"][time] = value
			end
		end
	end
	self.NeedUpdate = true
end

local savedValue = {
	["damage"] = 0,
	["dmgt"] = 0,
	["heal"] = 0,
	["eheal"] = 0
}
function DPSMate.DB:GetAlpha(k)
	if DPSMate.DPSMateSettings["windows"][k]["realtime"] then
		local p = savedValue[DPSMate.DPSMateSettings["windows"][k]["realtime"]] or 0
		savedValue[DPSMate.DPSMateSettings["windows"][k]["realtime"]] = 0
		if p > 50000 then -- That may solve the freeze issue
			p = 50000
		end
		return p
	end
end

function DPSMate.DB:HookGraphEvents()
	if not self.hooked then
		self.oldDmgDone = DPSMate.DB.DamageDone
		function DPSMate.DB:DamageDone(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dglance, Dblock, victim)
			self:oldDmgDone(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dglance, Dblock, victim)
			savedValue["damage"] = savedValue["damage"] + Damount
		end
		self.oldDmgTaken = DPSMate.DB.DamageTaken
		function DPSMate.DB:DamageTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dcrush, Dblock)
			self:oldDmgTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dcrush, Dblock)
			savedValue["dmgt"] = savedValue["dmgt"] + Damount
		end
		self.oldHealing = DPSMate.DB.Healing
		function DPSMate.DB:Healing(mode, arr, Duser, Dname, Dhit, Dcrit, Damount)
			self:oldHealing(mode, arr, Duser, Dname, Dhit, Dcrit, Damount)
			if mode == 0 then
				savedValue["eheal"] = savedValue["eheal"] + Damount
			elseif mode == 1 then
				savedValue["heal"] = savedValue["heal"] + Damount
			end
		end
		self.hooked = true
	end
end

function DPSMate.DB:WeightedAverage(a, b, c, d)
	return ((a*c+b)/(c+d))
end

local spellSchoolNames = {
	-- enUS
	["fire"] = true,
	["nature"] = true,
	["shadow"] = true,
	["holy"] = true,
	["frost"] = true,
	["arcane"] = true,
	
	-- deDE
	["feuer"] = true,
	["natur"] = true,
	["schatten"] = true,
	["arkan"] = true,
	["frost"] = true,
	["heilig"] = true,
	
	--frFR
	["ombre"] = true,
	["feu"] = true,
	["nature"] = true,
	["givre"] = true,
	["arcane"] = true,
	["sacré"] = true,
	["physique"] = true,

	-- ruRU
	["огонь"] = true,
	["обычный"] = true,
	["тайная магия"] = true,
	["тьма"] = true,
	["природа"] = true,
	["лед"] = true,
	["физический урон"] = true,
	
	-- zhCN
	["火焰"] = true,
	["神圣"] = true,
	["奥术"] = true,
	["暗影"] = true,
	["自然"] = true,
	["冰霜"] = true,
	["物理"] = true,
}

local sc

function DPSMate.DB:AddSpellSchool(ab, school)
	school = strlower(school)
	sc = nil
	if spellSchoolNames[school] then
		sc = school
	else
		for c, _ in pairs(spellSchoolNames) do
			if strfind(school, c) then
				sc = c
				break
			end
		end
	end
	if sc then
		if DPSMate.Cache.DPSMateAbility[ab] then
			DPSMate.Cache.DPSMateAbility[ab][3] = sc
		else
			self:BuildAbility(ab,nil,sc)
		end
	end
end

function DPSMate.DB:RegisterNextSwing(usr, amount, ability)
	ability = self:BuildAbility(ability, nil, nil, usr)
	usr = self:BuildUser(usr)
	
	if self.NextSwing[usr] and self.NextSwing[usr][2] == ability then
		self.NextSwing[usr][1] = self.NextSwing[usr][1] + 1
	else
		self.NextSwing[usr] = {amount, ability}
	end

	if self.NextSwingEDD[usr] and self.NextSwingEDD[usr][2] == ability then 
		self.NextSwingEDD[usr][1] = self.NextSwingEDD[usr][1] + 1
	else
		self.NextSwingEDD[usr] = {amount, ability}
	end
end

DPSMate.DB.AAttack = "AutoAttack"
local hackOrder, hackOrder2 = {}, {}
function DPSMate.DB:DamageDone(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, Dglance, Dblock, victim)
	Dname = self:BuildAbility(Dname, nil, nil, Duser)
	Duser = self:BuildUser(Duser)

	if (not CombatState and cheatCombat<GT()) then
		DPSMate.Options:NewSegment()
		CombatState = true
	end

	local NextSwing = self.NextSwing[Duser]
	if DPSMate:GetAbilityById(Dname) == self.AAttack and NextSwing then
		if NextSwing[1] > 0 then
		--if not self.windfuryab[NextSwing[2]] or hackOrder[Duser] then
		--if hackOrder[Duser] then
			Dname = NextSwing[2]
			NextSwing[1] = NextSwing[1] - 1
		--	hackOrder[Duser] = false
		--else
		--	hackOrder[Duser] = true
		--end
		else
			self.NextSwing[Duser] = nil
		end
	end
	
	self.NeedUpdate = true

	if victim and strsub(victim, 1, 2) == "0x" then victim = UnitName(victim) end
	
	local ignoredDamage = victim and DPSMate.IgnoredDamage[victim]
	--ignored suicide or abnormal damage
	if (victim == player) or (ignoredDamage and Damount > ignoredDamage) then 
		return
	end
	
	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateDamageDone[cat][Duser] then DPSMate.Cache.DPSMateDamageDone[cat][Duser] = {i = 0} end
		gen = DPSMate.Cache.DPSMateDamageDone[cat][Duser]
		if not gen[Dname] then
			gen[Dname] = {
				[1] = 0, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = 0, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = 0, -- miss
				[10] = 0, -- parry
				[11] = 0, -- dodge
				[12] = 0, -- resist 
				[13] = 0, -- amount
				[14] = 0,
				[15] = 0,
				[16] = 0,
				[17] = 0,
				[18] = 0,
				[19] = 0,
				[20] = 0,
				[21] = 0,
				[22] = 0, -- Casts -- Deprecated
				["i"] = {}
			}
		end
		path = gen[Dname]
		if Damount > 0 then 
			path[13] = path[13] + Damount
			if Dhit == 1 then
				if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
				if Damount > path[3] then path[3] = Damount end
				path[4] = path[4] + Damount
				path[1] = path[1] + 1
			elseif Dcrit == 1 then
				if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
				if Damount > path[7] then path[7] = Damount end
				path[8] = path[8] + Damount
				path[5] = path[5] + 1
			elseif Dglance == 1 then
				if (Damount < path[15] or path[15] == 0) then path[15] = Damount end
				if Damount > path[16] then path[16] = Damount end
				path[17] =  path[17] + Damount
				path[14] = path[14] + 1
			else
				if (Damount < path[19] or path[19] == 0) then path[19] = Damount end
				if Damount > path[20] then path[20] = Damount end
				path[21] =  path[21] + Damount
				path[18] = path[18] + 1
			end
			gen["i"] = gen["i"] + Damount
			time = floor(DPSMate.Cache.DPSMateCombatTime[val])
			path["i"][time] = (path["i"][time] or 0) + Damount
		else
			path[9] = path[9] + Dmiss
			path[10] = path[10] + Dparry
			path[11] = path[11] + Ddodge
			path[12] = path[12] + Dresist
			path[18] = path[18] + Dblock
		end
	end
	self.NeedUpdate = true
end

function DPSMate.DB:DamageTaken(Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dcrush, Dblock)
	if not DPSMate.EnabledModules["damagetaken"] then return end

	Dname = self:BuildAbility(Dname, nil, nil,Duser)
	Duser = self:BuildUser(Duser)
	cause = self:BuildUser(cause)

	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateDamageTaken[cat][Duser] then DPSMate.Cache.DPSMateDamageTaken[cat][Duser] = {i = 0} end
		gen = DPSMate.Cache.DPSMateDamageTaken[cat][Duser]
		if not gen[cause] then
			gen[cause] = {}
		end
		if not gen[cause][Dname] then
			gen[cause][Dname] = {
				[1] = 0, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = 0, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = 0, -- miss
				[10] = 0, -- parry
				[11] = 0, -- dodge
				[12] = 0, -- resist
				[13] = 0, -- amount
				[14] = 0, -- average
				[15] = 0,
				[16] = 0,
				[17] = 0,
				[18] = 0,
				[19] = 0,
				[20] = 0,
				[21] = 0,
				[22] = 0,
				[23] = 0,
				["i"] = {}
			}
		end
		path = gen[cause][Dname]
		if Damount > 0 then 
			path[13] = path[13] + Damount
			if Dhit == 1 then
				if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
				if Damount > path[3] then path[3] = Damount end
				path[4] = path[4]+Damount
				path[1] = path[1] + 1
			elseif Dcrit == 1 then
				if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
				if Damount > path[7] then path[7] = Damount end
				path[8] = path[8]+Damount
				path[5] = path[5] + 1
			elseif Dcrush == 1 then
				if (Damount < path[16] or path[16] == 0) then path[16] = Damount end
				if Damount > path[17] then path[17] = Damount end
				path[18] = path[18]+Damount
				path[15] = path[15] + 1
			else
				if (Damount < path[21] or path[21] == 0) then path[21] = Damount end
				if Damount > path[22] then path[22] = Damount end
				path[23] = path[23]+Damount
				path[20] = path[20] + 1
			end
			gen["i"] = gen["i"] + Damount
			path[14] = (path[14] + Damount)/2
			time = floor(DPSMate.Cache.DPSMateCombatTime[val])
			path["i"][time] = (path["i"][time] or 0) + Damount
		else
			path[9] = path[9] + Dmiss
			path[10] = path[10] + Dparry
			path[11] = path[11] + Ddodge
			path[12] = path[12] + Dresist
			path[20] = path[20] + Dblock
		end
	end
	self.NeedUpdate = true
end

function DPSMate.DB:EnemyDamage(mode, arr, Duser, Dname, Dhit, Dcrit, Dmiss, Dparry, Ddodge, Dresist, Damount, cause, Dblock, Dcrush)
	if self.has_superwow then 
		if strsub(cause, 1, 2) == "0x" then --name is guid
			cause = UnitName(cause)
		end
	end
	DPSMate.Cache.ActiveMob[cause] = true
	
	local DuserName = Duser
	local causeName = cause

	Dname = self:BuildAbility(Dname, nil, nil, Duser)
	Duser = self:BuildUser(Duser)
	cause = self:BuildUser(cause)
	
	if not mode then -- EDD
		if not DPSMate.EnabledModules["enemydamagedone"] then
			return
		end
	else
		local NextSwingEDD = self.NextSwingEDD[Duser]
		if DPSMate:GetAbilityById(Dname) == self.AAttack and NextSwingEDD then
			if NextSwingEDD[1] > 0 then
				--if not self.windfuryab[NextSwingEDD[2]] or hackOrder2[Duser] then
				Dname = NextSwingEDD[2]
				NextSwingEDD[1] = NextSwingEDD[1] - 1
				--else
				--	hackOrder2[Duser] = true
				--end
			else
				self.NextSwingEDD[Duser] = nil
			end
		end
		--hackOrder2[Duser] = false
	end

	for cat, val in pairs(tablemodes) do 
		if not arr[cat][cause] then arr[cat][cause] = {} end
		gen = arr[cat][cause]
		if not gen[Duser] then
			gen[Duser] = {
				i = 0,
			}
		end
		if not gen[Duser][Dname] then
			gen[Duser][Dname] = {
				[1] = 0, -- hit
				[2] = 0, -- hitlow
				[3] = 0, -- hithigh
				[4] = 0, -- hitaverage
				[5] = 0, -- crit
				[6] = 0, -- critlow
				[7] = 0, -- crithigh
				[8] = 0, -- critaverage
				[9] = 0, -- miss
				[10] = 0, -- parry
				[11] = 0, -- dodge
				[12] = 0, -- resist
				[13] = 0, -- amount
				[14] = 0,
				[15] = 0,
				[16] = 0,
				[17] = 0,
				[18] = 0,
				[19] = 0,
				[20] = 0,
				[21] = 0,
				[22] = 0,
				["i"] = {}
			}
		end
		path = gen[Duser][Dname]
		if Damount > 0 then
			path[13] = path[13] + Damount
			if Dhit == 1 then
				if (Damount < path[2] or path[2] == 0) then path[2] = Damount end
				if Damount > path[3] then path[3] = Damount end
				path[4] = path[4] + Damount
				path[1] = path[1] + 1
			elseif Dcrit == 1 then
				if (Damount < path[6] or path[6] == 0) then path[6] = Damount end
				if Damount > path[7] then path[7] = Damount end
				path[8] = path[8] + Damount
				path[5] = path[5] + 1
			elseif Dcrush == 1 then
				if (Damount < path[19] or path[19] == 0) then path[19] = Damount end
				if Damount > path[20] then path[20] = Damount end
				path[21] = path[21] + Damount
				path[18] = path[18] + 1
			else
				if (Damount < path[15] or path[15] == 0) then path[15] = Damount end
				if Damount > path[16] then path[16] = Damount end
				path[17] = path[17] + Damount
				path[14] = path[14] + 1
			end
			gen[Duser]["i"] = gen[Duser]["i"] + Damount
			time = floor(DPSMate.Cache.DPSMateCombatTime[val])
			path["i"][time] = (path["i"][time] or 0) + Damount
		else
			path[9] = path[9] + Dmiss
			path[10] = path[10] + Dparry
			path[11] = path[11] + Ddodge
			path[12] = path[12] + Dresist
			path[14] = path[14] + Dblock
		end
	end
	if Damount>0 then self:CheckActiveCC(DuserName, causeName) end
	self.NeedUpdate = true
end

function DPSMate.DB:Healing(mode, arr, Duser, Dname, Dhit, Dcrit, Damount)
	if (
		(mode==0 and not DPSMate.EnabledModules["effectivehealing"] and not DPSMate.EnabledModules["healingandabsorbs"]) or 
		(mode==1 and not DPSMate.EnabledModules["healing"]) or 
		(mode==2 and not DPSMate.EnabledModules["overhealing"])) then return end
	if not CombatState then return end
	Duser = self:BuildUser(Duser)
	Dname = self:BuildAbility(Dname)
	for cat, val in pairs(tablemodes) do 
		if not arr[cat][Duser] then arr[cat][Duser] = {i = 0} end
		gen = arr[cat][Duser]
		if not gen[Dname] then
			gen[Dname] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- hitav
				[5] = 0, -- critav
				[6] = 0, -- hitMin
				[7] = 0, -- hitMax
				[8] = 0, -- critMin
				[9] = 0, -- critMax
				["i"] = {}
			}
		end
		path = gen[Dname]
		if Damount > 0 then 
			path[1] = path[1]+Damount
			gen["i"] = gen["i"]+Damount
			if Dhit==1 then
				path[4] = path[4] + Damount 
				if Damount<path[6] or path[6]==0 then
					path[6] = Damount; 
				end
				if Damount>path[7] or path[7]==0 then
					path[7] = Damount 
				end
				path[2] = path[2]+1
			else 
				path[5] = path[5] + Damount 
				if Damount<path[8] or path[8]==0 then
					path[8] = Damount; 
				end
				if Damount>path[9] or path[9]==0 then
					path[9] = Damount 
				end
				path[3] = path[3]+1
			end
			time = floor(DPSMate.Cache.DPSMateCombatTime[val])
			path["i"][time] = (path["i"][time] or 0) + Damount
		end
	end
	self.NeedUpdate = true
end

function DPSMate.DB:HealingTaken(mode, arr, Duser, Dname, Dhit, Dcrit, Damount, target)
	if ((mode==0 and not DPSMate.EnabledModules["healingtaken"] and not DPSMate.EnabledModules["healing"]) or (mode==1 and not DPSMate.EnabledModules["effectivehealingtaken"] and not DPSMate.EnabledModules["effectivehealing"] and not DPSMate.EnabledModules["healingandabsorbs"]) or (mode==2 and not DPSMate.EnabledModules["OHealingTaken"] and not DPSMate.EnabledModules["overhealing"])) then return end
	if not CombatState then return end
	Duser = self:BuildUser(Duser)
	Dname = self:BuildAbility(Dname)
	target = self:BuildUser(target)
	for cat, val in pairs(tablemodes) do 
		if not arr[cat][Duser] then arr[cat][Duser] = {i = 0} end
		gen = arr[cat][Duser]
		if not gen[target] then
			gen[target] = {}
		end
		if not gen[target][Dname] then
			gen[target][Dname] = {
				[1] = 0, -- Healing done
				[2] = 0, -- Hit
				[3] = 0, -- Crit
				[4] = 0, -- hitav
				[5] = 0, -- critav
				[6] = 0, -- hitMin
				[7] = 0, -- hitMax
				[8] = 0, -- critMin
				[9] = 0, -- critMax
				["i"] = {}
			}
		end
		path = gen[target][Dname]
		if Damount > 0 then 
			path[1] = path[1]+Damount
			if Dhit==1 then
				path[4] = path[4] + Damount 
				if Damount<path[6] or path[6]==0 then
					path[6] = Damount; 
				end
				if Damount>path[7] or path[7]==0 then
					path[7] = Damount 
				end
				path[2] = path[2]+1
			else
				path[5] = path[5] + Damount 
				if Damount<path[8] or path[8]==0 then
					path[8] = Damount; 
				end
				if Damount>path[9] or path[9]==0 then
					path[9] = Damount 
				end
				path[3] = path[3]+1
			end
			gen["i"] = gen["i"]+Damount
			time = floor(DPSMate.Cache.DPSMateCombatTime[val])
			path["i"][time] = (path["i"][time] or 0) + Damount
		end
	end
	self.NeedUpdate = true
end

-- Fire etc. Prot Potion
-- Mage: Ice Barrier, Manashield, Fire Protection, Frost Protection
-- Warlock: Shadow Protection
-- Priest: Power Word: Shield
-- Always the first shield that is applied is absorbing the damage. Depending the school it iterates through the shields.
-- Example: Manashield is applied first then Frost Protection Potion.
-- Weasel casts Frostbolt. -> Game: Can Manashield absorb Frost damage? No -> Game: Can Frost Protection Potion Absorb Frost damage? Yes -> OK go for it!
-- Example two: Frost Protection Potion and Power Word Shield
-- Weasel casts Frostbolt. -> Game: Can FPP absorb the FD? Yes -> Go for it. (The Power Word Shield is ignored until FPP fades)
-- What if a shield is refreshed
DPSMate.DB.realAbility = {
	["Greater Fire Protection Potion"] = "Fire Protection",
	["Greater Frost Protection Potion"] = "Frost Protection",
	["Greater Nature Protection Potion"] = "Nature Protection",
	["Greater Holy Protection Potion"] = "Holy Protection",
	["Greater Shadow Protection Potion"] = "Shadow Protection",
	["Greater Arcane Protection Potion"] = "Arcane Protection",
}
function DPSMate.DB:AwaitingAbsorbConfirmation(owner, ability, abilityTarget, time)
	tinsert(DPSMate.Cache.Await, {owner, self.realAbility[ability] or ability, abilityTarget, time})
end

function DPSMate.DB:ClearAwaitAbsorb()
	local time = GT()
	for cat, val in pairs(DPSMate.Cache.Await) do
		if (time-val[4])>=10 then
			tremove(DPSMate.Cache.Await, cat)
			break
		end
	end
end

function DPSMate.DB:ConfirmAbsorbApplication(ability, abilityTarget, time)
	for cat, val in pairs(DPSMate.Cache.Await) do
		if val[4]<=time and val[2]==ability then
			if val[3]==abilityTarget then
				self:RegisterAbsorb(val[1], ability, abilityTarget)
				tremove(DPSMate.Cache.Await, cat)
				return
			end
		end
	end
	self:RegisterAbsorb(DPSMate.L["unknown"], ability, abilityTarget)
end

function DPSMate.DB:RegisterAbsorb(owner, ability, abilityTarget)
	if not DPSMate.EnabledModules["absorbs"] and not DPSMate.EnabledModules["absorbstaken"] and not DPSMate.EnabledModules["healingandabsorbs"] then return end

	ability = self:BuildAbility(ability, nil, nil, owner)
	owner = self:BuildUser(owner)
	abilityTarget = self:BuildUser(abilityTarget)

	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget] then
			DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget] = {}
		end
		gen = DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget]
		if not gen[owner] then gen[owner] = {i = {}} end
		if not gen[owner][ability] then gen[owner][ability] = {} end
		tinsert(gen[owner][ability], {
			i = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 0,
			},
		})
	end
	self.NeedUpdate = true
end

function DPSMate.DB:SetUnregisterVariables(broAbsorb, ab, c)
	if broAbsorb then
		ab = self:BuildAbility(ab, nil, nil, c)
		c = self:BuildUser(c, nil)
		DPSMate.Cache.broken = {1,broAbsorb,ab,c}
	end
end

function DPSMate.DB:UnregisterAbsorb(ability, abilityTarget)
	if not DPSMate.EnabledModules["absorbs"] and not DPSMate.EnabledModules["absorbstaken"] and not DPSMate.EnabledModules["healingandabsorbs"] then return end
	ability = self:BuildAbility(ability, nil, nil, abilityTarget)
	abilityTarget = self:BuildUser(abilityTarget)
	local AbsorbingAbility
	for cat, val in pairs(tablemodes) do 
		AbsorbingAbility = self:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cat)
		if AbsorbingAbility[1] then
			path = DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]]["i"]
			if path[1] == 0 then
				path[1] = DPSMate.Cache.broken[1]
				path[2] = DPSMate.Cache.broken[2]
				path[3] = DPSMate.Cache.broken[3]
				path[4] = DPSMate.Cache.broken[4]
				if (DPSMate.Cache.broken[2] or 0)>0 then tinsert(DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget][AbsorbingAbility[1]]["i"], {DPSMate.Cache.DPSMateCombatTime[val], DPSMate.Cache.broken[4], DPSMate.Cache.broken[3], DPSMate.Cache.broken[2], AbsorbingAbility[2]}) end
			end
		end
	end
	DPSMate.Cache.broken = {2,0,0,0}
	self.NeedUpdate = true
end

function DPSMate.DB:GetActiveAbsorbAbilityByPlayer(ability, abilityTarget, cate)
	local ActiveShield = {}
	if DPSMate.Cache.DPSMateAbsorbs[cate][abilityTarget] then
		for cat, val in pairs(DPSMate.Cache.DPSMateAbsorbs[cate][abilityTarget]) do
			for ca, va in pairs(val) do
				if ca~="i" then
					for c, v in pairs(va) do
						for ce, ve in pairs(v) do
							if ve[1]==0 and ca==ability then
								ActiveShield = {cat, ca, c}
								break
							end
						end
					end
				end
			end
		end
	end
	return ActiveShield
end

local DPSMate_Tooltip
local DPSMate_TooltipTextLeft1

function DPSMate.DB:GetAbsorbingShield(ability, abilityTarget, cate)
	DPSMate_Tooltip = DPSMate_Tooltip or getglobal("DPSMate_Tooltip")
	DPSMate_TooltipTextLeft1 = DPSMate_TooltipTextLeft1 or getglobal("DPSMate_TooltipTextLeft1")

	local AbsorbingAbility = {}	
	local activeShields = {}
	if DPSMate.Cache.DPSMateAbsorbs[cate][abilityTarget] then
		for cat, val in pairs(DPSMate.Cache.DPSMateAbsorbs[cate][abilityTarget]) do
			for ca, va in pairs(val) do
				if ca~="i" then
					for c, v in pairs(va) do
						for ce, ve in pairs(v) do
							if ve[1]==0 then
								activeShields[cat] = {ca,c}
								break
							end
						end
					end
				end
			end
		end

		local AAS, ASS = {}, {}
		for cat, val in pairs(activeShields) do
			if self.ShieldFlags[DPSMate:GetAbilityById(val[1])]==0 then
				AAS[cat] = {val[1],val[2]}
			elseif self.ShieldFlags[DPSMate:GetAbilityById(val[1])]==AbilityFlags[ability] then
				ASS[cat] = {val[1],val[2]}
			elseif not ability or not AbilityFlags[ability] then
				ASS[cat] = {val[1],val[2]}
			end
		end
		
		if AAS~={} or ASS~={} then
			local unit, buff = DPSMate.Parser:GetUnitByName(abilityTarget)
			if unit then
				for i=1, 32 do
					DPSMate_Tooltip:ClearLines()
					DPSMate_Tooltip:SetUnitBuff(unit, i, "HELPFUL")
					buff = DPSMate_TooltipTextLeft1:GetText()
					if (not buff) then break end
					buff = self:BuildAbility(buff)
					for cat, val in pairs(AAS) do
						if val[1]==buff then
							AbsorbingAbility = {cat, val[1],val[2]}
							break
						end
					end
					for cat, val in pairs(ASS) do
						if val[1]==buff then
							AbsorbingAbility = {cat, val[1],val[2]}
							break
						end
					end
				end
			else
				if AAS then
					for cat, val in pairs(AAS) do
						return {cat, val[1],val[2]}
					end
				else
					for cat, val in pairs(ASS) do
						return {cat, val[1],val[2]}
					end
				end
			end
		end
	end
	return AbsorbingAbility
end

function DPSMate.DB:Absorb(ability, abilityTarget, incTarget)
	if not DPSMate.EnabledModules["absorbs"] and not DPSMate.EnabledModules["absorbstaken"] and not DPSMate.EnabledModules["healingandabsorbs"] then return end
	ability = self:BuildAbility(ability, nil, nil, incTarget)
	incTarget = self:BuildUser(incTarget)
	abilityTarget = self:BuildUser(abilityTarget)
	local AbsorbingAbility
	for cat, val in pairs(tablemodes) do 
		AbsorbingAbility = self:GetAbsorbingShield(DPSMate.Cache.DPSMateAbility[DPSMate:GetAbilityById(ability)][3], abilityTarget, cat)
		if AbsorbingAbility[1] then
			if not DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]][incTarget] then
				DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]][incTarget] = {}
			end
			path = DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget][AbsorbingAbility[1]][AbsorbingAbility[2]][AbsorbingAbility[3]][incTarget]
			path[ability] = (path[ability] or 0) + 1
			tinsert(DPSMate.Cache.DPSMateAbsorbs[cat][abilityTarget][AbsorbingAbility[1]]["i"], {DPSMate.Cache.DPSMateCombatTime[val], incTarget, ability, 0, AbsorbingAbility[2]})
		end
	end
end

local NextTotemDispel = false
local TotemDispelTimer = 0
function DPSMate.DB:AwaitDispel(ability, target, cause, time)
	if not DPSMate.Cache.AwaitDispelT[target] then DPSMate.Cache.AwaitDispelT[target] = {} end
	tinsert(DPSMate.Cache.AwaitDispelT[target], {cause, ability, time, 2})
	self:EvaluateDispel()
end

DPSMate.DB.Restor = "Restoration"
DPSMate.DB.RPotion = "Restorative Potion"
DPSMate.DB.PFication = "Purification"
DPSMate.DB.PPotion = "Purification Potion"
function DPSMate.DB:AwaitHotDispel(ability, target, cause, time)
	if ability == self.RPotion then
		ability = self.Restor
		target = cause
	end
	if ability == self.PPotion then
		ability = self.PFication
		target = cause
	end
	tinsert(DPSMate.Cache.AwaitHotDispelT, {cause, target, ability, time})
end

local lastDispel = nil;
function DPSMate.DB:RemoveActiveHotDispel(target, ability)
	if DPSMate.Cache.ActiveHotDispel[target] then
		for ca, va in pairs(DPSMate.Cache.ActiveHotDispel[target]) do -- Overwriting old active hot dispel
			if va[2]==ability then
				tremove(DPSMate.Cache.ActiveHotDispel[target], ca)
				self:RemoveActiveHotDispel(target, ability)
				break
			end
		end
	end
end

function DPSMate.DB:RegisterHotDispel(target, ability)
	for cat, val in pairs(DPSMate.Cache.AwaitHotDispelT) do
		if val[2]==target and val[3]==ability then
			if not DPSMate.Cache.ActiveHotDispel[val[2]] then DPSMate.Cache.ActiveHotDispel[val[2]] = {} end
			lastDispel = target;
			self:RemoveActiveHotDispel(val[2], val[3]) -- Overwrite active dispels
			tinsert(DPSMate.Cache.ActiveHotDispel[val[2]], {val[1], val[3]})
			self:EvaluateDispel()
			break
		end
 	end
end

function DPSMate.DB:ClearAwaitHotDispel()
	local time = GT()
	for cat, val in pairs(DPSMate.Cache.AwaitHotDispelT) do
		if (time-val[4])>=10 then
			DPSMate.Cache.AwaitHotDispelT[cat] = nil
		end
	end
end

function DPSMate.DB:ConfirmRealDispel(ability, target, time)
	if not DPSMate.Cache.ConfirmedDispel[target] then DPSMate.Cache.ConfirmedDispel[target] = {} end
	tinsert(DPSMate.Cache.ConfirmedDispel[target], {ability, time})
	lastDispel = target;
	self:EvaluateDispel()
	NextTotemDispel = true
end

function DPSMate.DB:ApplyRemainingDispels()
	if not DPSMate.EnabledModules["decurses"] and not DPSMate.EnabledModules["curepoison"] and not DPSMate.EnabledModules["liftmagic"] and not DPSMate.EnabledModules["curedisease"] and not DPSMate.EnabledModules["dispels"] then return end
	NextTotemDispel = true
	local num = 0
	local time = GT()
	local teamtype = "party"
	local tnum = GetNumPartyMembers()
	if tnum <= 0 then
		teamtype="raid"
		tnum=GetNumRaidMembers()
	end
	local subGRP, PSGRP, c
	for cat, val in pairs(DPSMate.Cache.ConfirmedDispel) do
		for ca, va in pairs(val) do
			num = num + 1
			if (time-va[2])>10 and (time-va[2])<40 then
				if teamtype=="party" then
					for i=1, tnum do
						if UnitClass(teamtype..i)==DPSMate.L["shaman"] then
							self:Dispels(UnitName(teamtype..i), DPSMate.L["poisoncleansingtotem"], cat, va[1])
							tremove(DPSMate.Cache.ConfirmedDispel[cat], ca)
							return
						end
					end
				else
					subGRP, PSGRP = {}, nil
					for i=1, tnum do
						_, _, c = GetRaidRosterInfo(i)
						if UnitClass(teamtype..i)==DPSMate.L["shaman"] then
							subGRP[c] = UnitName(teamtype..i)
						end
						if UnitName(teamtype..i)==cat then
							PSGRP = c
						end
						if PSGRP and subGRP[PSGRP] then
							self:Dispels(subGRP[PSGRP], DPSMate.L["poisoncleansingtotem"], cat, va[1])
							tremove(DPSMate.Cache.ConfirmedDispel[cat], ca)
							return
						end
					end
				end
			end
		end
	end
	if num == 0 then
		NextTotemDispel = false
	end
end

function DPSMate.DB:EvaluateDispel()
	if not DPSMate.EnabledModules["decurses"] and not DPSMate.EnabledModules["curepoison"] and not DPSMate.EnabledModules["liftmagic"] and not DPSMate.EnabledModules["curedisease"] and not DPSMate.EnabledModules["dispels"] then return end
	local check
	for cat, val in pairs(DPSMate.Cache.ActiveHotDispel) do
		for ca, va in pairs(val) do
			if DPSMate.Cache.ConfirmedDispel[cat] then
				if va[2]~=self.Restor or (va[2]==self.Restor and va[1]==cat) then
					check = nil
					for q, t in pairs(DPSMate.Cache.ConfirmedDispel[cat]) do
						if DPSMate.Parser.HotDispels[va[2]] then
							if not check then
								check = t[1]
								tremove(DPSMate.Cache.ConfirmedDispel[cat], q)
							end
						end
					end
					if check then
						self:Dispels(va[1], va[2], cat, check)
						lastDispel = nil;
						return
					end
				end
			end
		end
	end
	local time = GT()
	for cat, val in pairs(DPSMate.Cache.AwaitDispelT) do
		for ca, va in pairs(val) do
			if (time-(va[3] or 0))<=10 then
				if DPSMate.Cache.ConfirmedDispel[cat] then
					if va[2]~=self.Restor then
						if DPSMate.Cache.ConfirmedDispel[cat][1] then
							self:Dispels(va[1], va[2], cat, DPSMate.Cache.ConfirmedDispel[cat][1][1])
							tremove(DPSMate.Cache.ConfirmedDispel[cat], 1)
							DPSMate.Cache.AwaitDispelT[cat][ca][4] = DPSMate.Cache.AwaitDispelT[cat][ca][4] - 1
							if DPSMate.Cache.AwaitDispelT[cat][ca][4]<=0 then
								tremove(DPSMate.Cache.AwaitDispelT[cat], ca)
							end
							self:EvaluateDispel()
							return
						end
					end
				end
			end
		end
	end
end

function DPSMate.DB:UnregisterHotDispel(target, ability)
	if not DPSMate.Cache.ActiveHotDispel[target] then return end
	for cat, val in pairs(DPSMate.Cache.ActiveHotDispel[target]) do
		if val[2]==ability then
			tremove(DPSMate.Cache.ActiveHotDispel[target], cat)
			break
		end
	end
end

function DPSMate.DB:Dispels(cause, Dname, target, ability)
	if not DPSMate.EnabledModules["decurses"] and not DPSMate.EnabledModules["curepoison"] and not DPSMate.EnabledModules["liftmagic"] and not DPSMate.EnabledModules["curedisease"] and not DPSMate.EnabledModules["dispels"] then return end
	cause = self:BuildUser(cause)
	target = self:BuildUser(target)
	Dname = self:BuildAbility(Dname)
	ability = self:BuildAbility(ability)
	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateDispels[cat][cause] then
			DPSMate.Cache.DPSMateDispels[cat][cause] = {
				i = {
					[1] = 0,
					[2] = {}
				},
			}
		end
		gen = DPSMate.Cache.DPSMateDispels[cat][cause]
		if not gen[Dname] then
			gen[Dname] = {}
		end
		if not gen[Dname][target] then 
			gen[Dname][target] = {}
		end
		path = gen[Dname][target]
		if not path[ability] then
			path[ability] = 0
		end
		path[ability] = path[ability]+1
		gen["i"][1] = gen["i"][1]+1
		tinsert(gen["i"][2], {DPSMate.Cache.DPSMateCombatTime[val], ability, target, GameTime_GT()})
	end
	self.NeedUpdate = true
end

function DPSMate.DB:UnregisterDeath(target)
	if not DPSMate.EnabledModules["deaths"] then return end
	if strfind(target, "%s") then return end
	target = self:BuildUser(target)
	local p
	for cat, val in pairs(tablemodes) do 
		if DPSMate.Cache.DPSMateDeaths[cat][target] then
			DPSMate.Cache.DPSMateDeaths[cat][target][1]["i"][1]=1 --mark as dead
			DPSMate.Cache.DPSMateDeaths[cat][target][1]["i"][2]=GameTime_GT()
			DPSMate.Cache.DPSMateDeaths[cat][target][1]["i"][3]=(DPSMate.turtle_wow and GT()) or 0
			if cat==1 and DPSMate.Parser.TargetParty[DPSMate:GetUserById(target)] then 
				p = DPSMate.Cache.DPSMateDeaths[cat][target][1][1]
				DPSMate:Broadcast(4, DPSMate:GetUserById(target), DPSMate:GetUserById(p[1]), DPSMate:GetAbilityById(p[2]), p[3]) 
			end
		end
	end
end

function DPSMate.DB:DeathHistory(targetname, user, ability, amount, hit, crit, type, crush)
	if not DPSMate.EnabledModules["deaths"] then return end
	local target = self:BuildUser(targetname)
	ability = self:BuildAbility(ability, nil, nil, user)
	local cause = self:BuildUser(user)
	local hitCritCrush
	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateDeaths[cat][target] then
			DPSMate.Cache.DPSMateDeaths[cat][target] = {}
		end
		gen = DPSMate.Cache.DPSMateDeaths[cat][target]
		if not gen[1] then
			gen[1] = {
				i = {
					[1] = 0,
					[2] = "",
				},
			}
		end

		--if gen[1]["i"][1]==1 and GT()-gen[1]["i"][3]>2 then -- already dead
		if gen[1]["i"][1]==1 then -- already dead
			if GT() - gen[1]["i"][3] > 2 then
				tinsert(gen, 1, {i = {0,""}})
		 	else
				--print(targetname.." taken "..amount.." damage after death")
				--if arg1 then print(arg1) end
		 	end
		end

		hitCritCrush = 0
		if crit==1 then hitCritCrush = 1 elseif crush==1 then hitCritCrush = 2 end
		tinsert(gen[1], 1, {
			[1] = cause,
			[2] = ability,
			[3] = amount,
			[4] = hitCritCrush,
			[5] = type,
			[6] = DPSMate.Cache.DPSMateCombatTime[val],
			[7] = GameTime_GT(),
		})
		if gen[1][21] then
			tremove(gen[1], 21)
		end
	end
end

function DPSMate.DB:AwaitAfflicted(cause, ability, target, time)
	for cat, val in pairs(DPSMate.Cache.AfflictedStun) do
		if val[1]==cause and ((val[4]+0.5)<=time or (val[4]-0.5)>=time) then
			return
		end
	end
	tinsert(DPSMate.Cache.AfflictedStun, {cause,ability,target,time})
end

function DPSMate.DB:ConfirmAfflicted(target, ability, time)
	for cat, val in pairs(DPSMate.Cache.AfflictedStun) do
		if val[2]==ability and val[3]==target and val[4]<=time then
			if DPSMate.Parser.Kicks[ability] then self:AssignPotentialKick(val[1], val[2], val[3], time) end
			self:EnemyDamage(true, DPSMate.Cache.DPSMateEDT, val[1], ability, 1, 0, 0,0,0, 0,0, target, 0, 0)
			tremove(DPSMate.Cache.AfflictedStun, cat)
			return 
		end
	end
end

function DPSMate.DB:RegisterPotentialKick(cause, ability, time)
	tinsert(DPSMate.Cache.AwaitKick, {cause, ability, time})
end

function DPSMate.DB:UnregisterPotentialKick(cause, ability, time)
	for cat, val in pairs(DPSMate.Cache.AwaitKick) do
		if val[1]==cause and val[2]==ability and val[3]<=time then
			tremove(DPSMate.Cache.AwaitKick, cat)
			break
		end
	end
end

function DPSMate.DB:AssignPotentialKick(cause, ability, target, time)
	for cat, val in pairs(DPSMate.Cache.AwaitKick) do
		if val[3]<=time then
			if not val[4] and val[1]==target then
				val[4] = {cause, ability}
			end
		end
	end
end

function DPSMate.DB:UpdateKicks()
	local time = GT()
	for cat, val in pairs(DPSMate.Cache.AwaitKick) do
		if (time-val[3])>=2.5 then
			if val[4] then
				self:Kick(val[4][1], val[1], val[4][2], val[2])
			end
			tremove(DPSMate.Cache.AwaitKick, cat)
		end
	end
end

function DPSMate.DB:Kick(cause, target, causeAbility, targetAbility)
	if not DPSMate.EnabledModules["interrupts"] then return end
	target = self:BuildUser(target)
	cause = self:BuildUser(cause)
	causeAbility = self:BuildAbility(causeAbility)
	targetAbility = self:BuildAbility(targetAbility)
	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateInterrupts[cat][cause] then
			DPSMate.Cache.DPSMateInterrupts[cat][cause] = {
				i = {
					[1] = 0,
					[2] = {}
				},
			}
		end
		gen = DPSMate.Cache.DPSMateInterrupts[cat][cause]
		if not gen[causeAbility] then
			gen[causeAbility] = {}
		end
		if not gen[causeAbility][target] then
			gen[causeAbility][target] = {}
		end
		path = gen[causeAbility][target]
		if not path[targetAbility] then
			path[targetAbility] = 0
		end
		gen["i"][1] = gen["i"][1] + 1
		tinsert(gen["i"][2], {DPSMate.Cache.DPSMateCombatTime[val], GameTime_GT(), targetAbility, target})
		path[targetAbility]=path[targetAbility]+1
	end
end

function DPSMate.DB:AwaitingBuff(cause, ability, target, time)
	tinsert(DPSMate.Cache.AwaitBuff, {cause, ability, target, time})
end

function DPSMate.DB:ClearAwaitBuffs()
	local time = GT()
	for cat, val in pairs(DPSMate.Cache.AwaitBuff) do
		if (time-(val[4] or 0))>=5 then
			DPSMate.Cache.AwaitBuff[cat] = nil
		end
	end
end

function DPSMate.DB:ConfirmBuff(target, ability, time)
	for cat, val in pairs(DPSMate.Cache.AwaitBuff) do
		if val[4]<=(time or 0) then
			if val[2]==ability and val[3]==target then
				self:BuildBuffs(val[1], target, ability, false)
				return
			end
		end
	end
	self:BuildBuffs(self.UserUnknown, target, ability, false)
end

function DPSMate.DB:BuildBuffs(cause, target, ability, bool)
	if not DPSMate.EnabledModules["aurasgained"] then return end
	target = self:BuildUser(target)
	cause = self:BuildUser(cause)
	ability = self:BuildAbility(ability)
	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateAurasGained[cat][target] then
			DPSMate.Cache.DPSMateAurasGained[cat][target] = {}
		end
		gen = DPSMate.Cache.DPSMateAurasGained[cat][target]
		if not gen[ability] then
			gen[ability] = {
				[1] = {},
				[2] = {},
				[3] = {},
				[4] = bool,
				[5] = 0,
				[6] = 0,
			}
		end
		path = gen[ability]
		if not path[3][cause] then
			path[3][cause] = 0
		end
		for i=1, (path[5]-path[6]) do
			tinsert(path[2], path[1][path[6]+1])
			path[6] = path[6] + 1
		end
		tinsert(path[1], DPSMate.Cache.DPSMateCombatTime[val])
		path[5] = path[5] + 1
		path[3][cause] = path[3][cause] + 1
	end
	self.NeedUpdate = true
end

function DPSMate.DB:DestroyBuffs(target, ability)
	if not DPSMate.EnabledModules["aurasgained"] then return end
	target = self:BuildUser(target)
	local abilityId = self:BuildAbility(ability)
	local TL
	for cat, val in pairs(tablemodes) do 
		if not DPSMate.Cache.DPSMateAurasGained[cat][target] then
			DPSMate.Cache.DPSMateAurasGained[cat][target] = {}
		end

		gen = DPSMate.Cache.DPSMateAurasGained[cat][target]

		if ability ~= "all" then
			if not gen[abilityId] then
				gen[abilityId] = {
					[1] = {},
					[2] = {},
					[3] = {},
					[4] = nil,
					[5] = 0,
					[6] = 0,
				}
			else
				path = gen[abilityId]
				TL = path[6]+1
				if not path[1][TL] then
					path[1][TL] = DPSMate.Cache.DPSMateCombatTime[val]
					path[5] = path[5] + 1
				end
				tinsert(path[2], DPSMate.Cache.DPSMateCombatTime[val])
				path[6] = path[6] + 1
			end
		else --detroy all
			for _,path in gen do
				TL = path[6]+1
				if not path[1][TL] then
					path[1][TL] = DPSMate.Cache.DPSMateCombatTime[val]
					path[5] = path[5] + 1
				end
				tinsert(path[2], DPSMate.Cache.DPSMateCombatTime[val])
				path[6] = path[6] + 1
			end
		end
	end
	self.NeedUpdate = true
end

function DPSMate.DB:GetOptionsTrue(i,k)
	for cat,val in pairs(DPSMate.DPSMateSettings["windows"][k]["options"][i]) do
		if val then
			return cat
		end
	end
end

function DPSMate.DB:UpdatePlayerCBT(cbt)
	local notInCombat = true
	local type = "raid"
	local num = GetNumRaidMembers()
	local cbt1, cbt2 = DPSMate.Cache.DPSMateCombatTime["effective"][1], DPSMate.Cache.DPSMateCombatTime["effective"][2]
	if num<=0 then
		type = "party"
		num = GetNumPartyMembers()
		if UnitAffectingCombat("player") then
			cbt1[player] = (cbt1[player] or 0) + cbt
			cbt2[player] = (cbt2[player] or 0) + cbt
			notInCombat = false
		end
	end
	local name
	for i=1, num do
		if UnitAffectingCombat(type..i) then
			name = UnitName(type..i)
			cbt1[name] = (cbt1[name] or 0) + cbt
			cbt2[name] = (cbt2[name] or 0) + cbt
			notInCombat = false
		end
	end
	return notInCombat
end

local notInCombat, cbtpt
local init=true
local initTime = 0
local klhtmLocal, klhtmInit

function DPSMate.DB:OnUpdate()
	if (CombatState) then
		notInCombat = false
		LastUpdate = LastUpdate + arg1
		if LastUpdate>=UpdateTime then
			cbtpt = DPSMate.Cache.DPSMateCombatTime["effective"]
			DPSMate.Cache.DPSMateCombatTime["total"] = DPSMate.Cache.DPSMateCombatTime["total"] + LastUpdate
			DPSMate.Cache.DPSMateCombatTime["current"] = DPSMate.Cache.DPSMateCombatTime["current"] + LastUpdate
			notInCombat = self:UpdatePlayerCBT(LastUpdate) -- Slowing it down
			
			-- Check NPC E CBT Time (May be inaccurate) -> Can be used as active time later
			for cat, _ in pairs(DPSMate.Cache.ActiveMob) do
				cbtpt[1][cat] = (cbtpt[1][cat] or 0) + LastUpdate
				cbtpt[2][cat] = (cbtpt[2][cat] or 0) + LastUpdate
			end
			DPSMate.Cache.ActiveMob = {}
			
			DPSMate.Parser.SendSpell = {}
			LastUpdate = 0
		end
		
		if notInCombat then 
			CombatState = false
		end

		if NextTotemDispel then
			TotemDispelTimer = TotemDispelTimer + arg1
			if TotemDispelTimer>2 then
				self:ApplyRemainingDispels()
				TotemDispelTimer = 0
			end
		end
	else
		self.MainUpdate = self.MainUpdate + arg1
	end
	if self.NeedUpdate then
		MainLastUpdate = MainLastUpdate + arg1
		if MainLastUpdate>=MainUpdateTime then
			self:UpdateKicks()
			if self.ktmavail then
				self:UpdateThreat()
			end
			DPSMate:SetStatusBarValue()
			self.NeedUpdate = false
			MainLastUpdate = 0
		end
	end

	if self.MainUpdate>=30 then
		self:ClearAwaitBuffs()
		self:ClearAwaitAbsorb()
		self:ClearAwaitHotDispel()
		self.MainUpdate = 0
	end

	-- Init delay to make sure klhtm module is loaded
	if init then
		initTime = initTime + arg1
		if (initTime > 5) then
			if not klhtmInit then klhtmLocal = klhtm end
			klhtmInit = true
			if klhtmLocal then
				local oldModSpecialAttack = klhtmLocal.combat.specialattack
				klhtmLocal.combat.specialattack = function(abilityid, target, damage, iscrit, spellschool)
					oldModSpecialAttack(abilityid, target, damage, iscrit, spellschool)
					if DPSMate.DB.specialAbTrans[abilityid] then
						if not DPSMate.DB.KTMHOOK[DPSMate.DB.specialAbTrans[abilityid]] then
							DPSMate.DB.KTMHOOK[DPSMate.DB.specialAbTrans[abilityid]] = {}
						end
						tinsert(DPSMate.DB.KTMHOOK[DPSMate.DB.specialAbTrans[abilityid]], {target, klhtmLocal.combat.event.threat})
						DPSMate.DB:Threat(player, DPSMate.DB.specialAbTrans[abilityid], target, klhtmLocal.combat.event.threat, 1)
					end
				end

				local oldModNormalAttack = klhtmLocal.combat.normalattack
				klhtmLocal.combat.normalattack = function(spellname, spellid, damage, isdot, target, iscrit, spellschool)
					oldModNormalAttack(spellname, spellid, damage, isdot, target, iscrit, spellschool)
					if not DPSMate.DB.KTMHOOK[spellname] then
						DPSMate.DB.KTMHOOK[spellname] = {}
					end
					tinsert(DPSMate.DB.KTMHOOK[spellname], {target, klhtmLocal.combat.event.threat})
					DPSMate.DB:Threat(player, spellname, target, klhtmLocal.combat.event.threat, 1)
				end

				local oldModHeal = klhtmLocal.combat.registerheal
				klhtmLocal.combat.registerheal = function(spellname, spellid, amount, target)
					local ka, kb = strfind(spellname, " critically")
					if (ka and kb) then spellname = strsub(spellname, 1, ka-1) end
					oldModHeal(spellname, spellid, amount, target)
					if not DPSMate.DB.KTMHOOK[spellname] then
						DPSMate.DB.KTMHOOK[spellname] = {}
					end
					tinsert(DPSMate.DB.KTMHOOK[spellname], {target, klhtmLocal.combat.event.threat})
					DPSMate.DB:Threat(player, spellname, target, klhtmLocal.combat.event.threat, 1)
				end

				local oldModPowerGain = klhtmLocal.combat.powergain
				klhtmLocal.combat.powergain = function(amount, powertype, spellid)
					oldModPowerGain(amount, powertype, spellid)
					if not DPSMate.DB.KTMHOOK[powertype] then
						DPSMate.DB.KTMHOOK[powertype] = {}
					end
					local target = UnitName("target") or player
					tinsert(DPSMate.DB.KTMHOOK[powertype], {target, klhtmLocal.combat.event.threat})
					DPSMate.DB:Threat(player, powertype, target, klhtmLocal.combat.event.threat, 1)
				end
				self.ktmavail = true
			end
			init = false
		end
	end
end

-- Type: 1 => FriendlyFire, 2 => Damage taken, 3 => Debuff taken
function DPSMate.DB:BuildFail(type, user, cause, ability, amount)
	if not DPSMate.EnabledModules["fails"] then return end
	ability = self:BuildAbility(ability, nil, nil, user)
	user = self:BuildUser(user)
	cause = self:BuildUser(cause)
	local time = GameTime_GT()
	for cat, val in pairs(tablemodes) do
		if not DPSMate.Cache.DPSMateFails[cat][cause] then
			DPSMate.Cache.DPSMateFails[cat][cause] = {}
		end
		tinsert(DPSMate.Cache.DPSMateFails[cat][cause], 1, {
			[1] = type,
			[2] = user,
			[3] = ability,
			[4] = amount,
			[5] = DPSMate.Cache.DPSMateCombatTime[val],
			[6] = time,
		})
	end
	DPSMate:Broadcast(3, user, cause, ability, amount, type)
	self.NeedUpdate = true
end

function DPSMate.DB:BuildActiveCC(target, ability)
	if not DPSMate.Cache.ActiveCC[target] then
		DPSMate.Cache.ActiveCC[target] = {}
	end
	DPSMate.Cache.ActiveCC[target][ability] = true
end

function DPSMate.DB:RemoveActiveCC(target, ability)
	if not DPSMate.Cache.ActiveCC[target] then
		DPSMate.Cache.ActiveCC[target] = {}
	end
	if DPSMate.Cache.ActiveCC[target][ability] then
		DPSMate.Cache.ActiveCC[target][ability] = false;
	end
end

function DPSMate.DB:CheckActiveCC(cause, target)
	if DPSMate.Cache.ActiveCC[target] then
		for cat, val in pairs(DPSMate.Cache.ActiveCC[target]) do
			if val then
				for c, v in pairs(DPSMate.Cache.ActiveCC[target]) do
					DPSMate.Cache.ActiveCC[target][c] = false
				end
				self:ProcCCBreaker(target, cat, cause)
				return true
			end
		end
	end
	return false
end

function DPSMate.DB:ProcCCBreaker(target, ability, cause)
	if not DPSMate.EnabledModules["ccbreaker"] then return end
	local time = GameTime_GT()
	ability = self:BuildAbility(ability)
	cause = self:BuildUser(cause)
	target = self:BuildUser(target)
	for cat, val in pairs(tablemodes) do
		if not DPSMate.Cache.DPSMateCCBreaker[cat][cause] then
			DPSMate.Cache.DPSMateCCBreaker[cat][cause] = {}
		end
		tinsert(DPSMate.Cache.DPSMateCCBreaker[cat][cause], 1, {
			[1] = ability,
			[2] = target,
			[3] = DPSMate.Cache.DPSMateCombatTime[val],
			[4] = time
		})
	end
end

DPSMate.DB:SetScript("OnEvent", function() this[event]() end)
DPSMate.DB:SetScript("OnUpdate", function() this:OnUpdate() end)
