local DPSMate = DPSMate

-- Global Variables
DPSMate.Modules.Damage = {}
DPSMate.Modules.Damage.Hist = "DMGDone"
DPSMate.Options.Options[1]["args"]["damage"] = {
	order = 20,
	type = 'toggle',
	name = DPSMate.L["damage"],
	desc = DPSMate.L["show"].." "..DPSMate.L["damage"]..".",
	get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damage"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "damage", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}
DPSMate.Modules.Damage.Events = {
	"CHAT_MSG_COMBAT_SELF_HITS",
	"CHAT_MSG_COMBAT_SELF_MISSES",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_SPELL_PARTY_DAMAGE",
	"CHAT_MSG_COMBAT_PARTY_MISSES",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	-- Pet Damage
	"CHAT_MSG_COMBAT_PET_HITS",
	"CHAT_MSG_COMBAT_PET_MISSES",
	--"CHAT_MSG_SPELL_PET_BUFF",
	"CHAT_MSG_SPELL_PET_DAMAGE",
	--"periodic damage"
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
}

-- Register the moodule
DPSMate:Register("damage", DPSMate.Modules.Damage, DPSMate.L["damage"])

local tinsert = table.insert
local strformat = string.format
local pairs = pairs
local type = type

function DPSMate.Modules.Damage:GetSortedTable(arr, k)
	local b, a, total, CV, i, name = {}, {}, 0
	for cat, val in pairs(arr) do
		name = DPSMate:GetUserById(cat)
		if (not DPSMate.Cache.DPSMateUser[name][4] or (DPSMate.Cache.DPSMateUser[name][4] and not DPSMate.DPSMateSettings["mergepets"])) then
			if DPSMate:ApplyFilter(k, name) then
				CV = val["i"]
				local petsname = DPSMate.DB:GetPetsName(DPSMate.Cache.DPSMateUser[name])
				if petsname and DPSMate.DPSMateSettings["mergepets"] then
					for petname,_ in petsname do 
						local pettable = DPSMate.Cache.DPSMateUser[petname]
						if pettable and arr[pettable[1]] and name~=petname then
							CV=CV+arr[pettable[1]]["i"]
						end
					end
				end
				i = 1
				while true do
					if (not b[i]) then
						tinsert(b, i, CV)
						tinsert(a, i, name)
						break
					else
						if b[i] < CV then
							tinsert(b, i, CV)
							tinsert(a, i, name)
							break
						end
					end
					i=i+1
				end
				total = total + CV
			end
		end
	end
	return b, total, a
end

function DPSMate.Modules.Damage:EvalTable(user, k)
	local a, u, p, d, total, pet = {}, {}, {}, {}, 0, nil
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	
	u={user[1]}
	local petsname = DPSMate.DB:GetPetsName(user)
	if petsname and DPSMate.DPSMateSettings["mergepets"] then
		for petname,_ in pairs(petsname) do 
			if (petname ~= DPSMate.L["unknown"] and DPSMate.Cache.DPSMateUser[petname] and arr[DPSMate.Cache.DPSMateUser[petname][1]]) and
				DPSMate.Cache.DPSMateUser[petname][1]~=user[1] then 
				tinsert(u, DPSMate.Cache.DPSMateUser[petname][1])
			end
		end
	end

	for _, v in pairs(u) do
		for cat, val in pairs(arr[v]) do
			if (type(val) == "table" and cat~="i") then
				if val[13]~=0 and cat~="" then
					if (DPSMate.Cache.DPSMateUser[DPSMate:GetUserById(v)][4]) then pet=v; else pet=nil; end
					local i = 1
					while true do
						if (not d[i]) then
							tinsert(a, i, cat)
							tinsert(d, i, {val[13], pet})
							break
						else
							if (d[i][1] < val[13]) then
								tinsert(a, i, cat)
								tinsert(d, i, {val[13], pet})
								break
							end
						end
						i = i + 1
					end
				end
			end
		end
		total=total+arr[v]["i"]
	end
	return a, total, d
end

function DPSMate.Modules.Damage:GetSettingValues(arr, cbt, k,ecbt)
	local pt = ""
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMate.DPSMateSettings["windows"][k]["numberformat"] == 2 or DPSMate.DPSMateSettings["windows"][k]["numberformat"] == 4 then p = "K"; pt = "K" end
	sortedTable, total, a = DPSMate.Modules.Damage:GetSortedTable(arr, k)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort, dmgr, totr, sortr = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmgr==0 then break end; if totr <= 10000 then pt = "" end; if dmgr<=10000 then p = "" end
		local str = {[1]="",[2]="",[3]="",[4]=""}
		local pname = a[cat]
		if DPSMate.DPSMateSettings["columnsdmg"][1] then str[1] = " "..DPSMate:Commas(dmg, k)..p; strt[2] = DPSMate:Commas(tot, k)..pt end
		if DPSMate.DPSMateSettings["columnsdmg"][2] then str[2] = "("..strformat("%.1f", (dmg/cbt))..p..")"; strt[1] = "("..strformat("%.1f", (tot/cbt))..pt..") " end
		if DPSMate.DPSMateSettings["columnsdmg"][3] then str[3] = " ("..strformat("%.1f", 100*dmgr/totr).."%)" end
		if DPSMate.DPSMateSettings["columnsdmg"][4] then str[4] = " ("..strformat("%.1f", dmg/(ecbt[pname] or cbt))..p..")" end
		tinsert(name, a[cat])
		tinsert(value, str[2]..str[1]..str[4]..str[3])
		tinsert(perc, 100*(dmgr/sortr))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.Damage:ShowTooltip(user,k)
	if DPSMate.DPSMateSettings["informativetooltips"] then
		local a,b,c = DPSMate.Modules.Damage:EvalTable(DPSMate.Cache.DPSMateUser[user], k)
		local db = DPSMate:GetModeByArr(DPSMate.Cache.DPSMateEDT, k, "EDTaken")
		local i, p = 1, 0
		local petDamage = 0
		local edtaken, edtakenPet = {}, {}
		-- Getting the value of the pet
		while a[i] do
			if c[i][2] then
				petDamage = petDamage + c[i][1]
			end
			i = i + 1
		end
		
		local userId = DPSMate.Cache.DPSMateUser[user][1]
		local petsname = DPSMate.DB:GetPetsName(DPSMate.Cache.DPSMateUser[user])
		-- Getting edt values
		for cat, val in pairs(db) do
			if val[userId] then
				if val[userId]["i"]>0 then
					i = 1
					while true do
						if (not edtaken[i]) then
							tinsert(edtaken, i, {cat, val[userId]["i"]})
							break
						else
							if (edtaken[i][2] < val[userId]["i"]) then
								tinsert(edtaken, i, {cat, val[userId]["i"]})
								break
							end
						end
						i = i + 1
					end
				end
			end
			
			if petsname then
				for petname,_ in pairs(petsname) do 
					if DPSMate.Cache.DPSMateUser[petname] and val[DPSMate.Cache.DPSMateUser[petname][1]] then
						if val[DPSMate.Cache.DPSMateUser[petname][1]]["i"]>0 then
							i = 1
							while true do
								if (not edtakenPet[i]) then
									tinsert(edtakenPet, i, {cat, val[DPSMate.Cache.DPSMateUser[petname][1]]["i"]})
									break
								else
									if (edtakenPet[i][2] < val[DPSMate.Cache.DPSMateUser[petname][1]]["i"]) then
										tinsert(edtakenPet, i, {cat, val[DPSMate.Cache.DPSMateUser[petname][1]]["i"]})
										break
									end
								end
								i = i + 1
							end
						end
					end
				end
			end
		end
	
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMate.DPSMateSettings["subviewrows"]..DPSMate.L["ttdamage"]..DPSMate.L["ttabilities"])
		for i=1, DPSMate.DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			if not c[i][2] then 
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetAbilityById(a[i]),c[i][1].." ("..strformat("%.2f", 100*c[i][1]/(b-petDamage)).."%)",1,1,1,1,1,1)
			end
		end
		
		GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMate.DPSMateSettings["subviewrows"]..DPSMate.L["ttattacked"])
		for i=1, DPSMate.DPSMateSettings["subviewrows"] do
			if not edtaken[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(edtaken[i][1]), edtaken[i][2].." ("..strformat("%.2f", 100*edtaken[i][2]/(b-petDamage)).."%)", 1,1,1,1,1,1)
		end
		
		if petDamage~=0 and petsname then
			GameTooltip:AddLine(" ")
			--GameTooltip:AddDoubleLine(DPSMate.L["ttpet2"],DPSMate.Cache.DPSMateUser[user][5].."<"..user.."> ("..strformat("%.2f", 100*petDamage/b).."%)",1,0.82,0,1,1,1)
			GameTooltip:AddDoubleLine(DPSMate.L["ttpet2"],DPSMate.Cache.DPSMateUser[user][5].." 等".." ("..strformat("%.2f", 100*petDamage/b).."%)",1,0.82,0,1,1,1)
			GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMate.DPSMateSettings["subviewrows"]..DPSMate.L["ttpet"]..DPSMate.L["ttdamage"]..DPSMate.L["ttabilities"])
			i, p = 1,1
			while DPSMate.DPSMateSettings["subviewrows"]>=p do
				if not a[i] then break end
				if c[i][2] then 
					GameTooltip:AddDoubleLine(p..". "..DPSMate:GetAbilityById(a[i]).." - "..DPSMate:GetUserById(c[i][2]), c[i][1].." ("..strformat("%.2f", 100*c[i][1]/petDamage).."%)",1,1,1,1,1,1)
					p = p + 1
				end
				i = i + 1
			end
			GameTooltip:AddLine(DPSMate.L["tttop"]..DPSMate.DPSMateSettings["subviewrows"]..DPSMate.L["ttpet"]..DPSMate.L["ttattacked"])
			for i=1, DPSMate.DPSMateSettings["subviewrows"] do
				if not edtakenPet[i] then break end
				GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(edtakenPet[i][1]), edtakenPet[i][2].." ("..strformat("%.2f", 100*edtakenPet[i][2]/petDamage).."%)", 1,1,1,1,1,1)
			end
		end
	end
end

function DPSMate.Modules.Damage:OpenDetails(obj, key, bool)
	if bool then
		DPSMate.Modules.DetailsDamage:UpdateCompare(obj, key, bool)
	else
		DPSMate.Modules.DetailsDamage:UpdateDetails(obj, key)
	end
end

function DPSMate.Modules.Damage:OpenTotalDetails(obj, key)
	DPSMate.Modules.DetailsDamageTotal:UpdateDetails(obj, key)
end
