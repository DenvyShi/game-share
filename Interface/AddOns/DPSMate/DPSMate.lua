-- Global Variables
DPSMate = {}
local DPSMate = DPSMate

local SendChatMessage = SendChatMessage

DPSMate.VERSION = 127
DPSMate.LOCALE = GetLocale()
DPSMate.SYNCVERSION = DPSMate.VERSION..DPSMate.LOCALE
DPSMate.Parser = CreateFrame("Frame", nil, UIParent)
DPSMate.L = {}

DPSMate.DB = CreateFrame("Frame", nil, UIParent)
DPSMate.DB.has_superwow = SetAutoloot and true or false

DPSMate.Cache = {}

DPSMate.Options = CreateFrame("Frame", nil, UIParent)
DPSMate.Sync = CreateFrame("Frame", nil, UIParent)
DPSMate.Modules = {}

if DPSMate.DB.has_superwow then
	DPSMate.Events = {
		--"CHAT_MSG_ADDON",
		"PLAYER_AURAS_CHANGED",
		"RAW_COMBATLOG",
	}
else
	DPSMate.Events = {
		--"CHAT_MSG_ADDON",
		"PLAYER_AURAS_CHANGED",
		
		-- Damage
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
		
		-- EDD (Enemy player) / DeathHistory
		"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS",
		"CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES",
		"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE",
		"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",

		-- Damage taken (Also EDD) / DeathHistory
		"CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS",
		"CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES",
		"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
		"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS",
		"CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES",
		"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE",
		"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS",
		"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
		"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
		"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
		"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
		
		-- Healing/Absorbs/Fail/DeathHistory/Dispels
		"CHAT_MSG_SPELL_SELF_BUFF",
		"CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
		"CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF",
		"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
		"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
		"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
		"CHAT_MSG_SPELL_PARTY_BUFF",
		"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",

		-- Absorbs/Auras
		"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF",
		"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS",
		"CHAT_MSG_SPELL_BREAK_AURA",
		"CHAT_MSG_SPELL_AURA_GONE_SELF",
		"CHAT_MSG_SPELL_AURA_GONE_OTHER",
		"CHAT_MSG_SPELL_AURA_GONE_PARTY",
		
		-- Death/DeathHistory
		"CHAT_MSG_COMBAT_FRIENDLY_DEATH",
		"CHAT_MSG_COMBAT_HOSTILE_DEATH",
	}
end

DPSMate.Registered = nil
DPSMate.RegistredModules = {}
DPSMate.EnabledModules = {}
DPSMate.ModuleNames = {}
DPSMate.UserId = {}
DPSMate.AbilityId = {}
DPSMate.Key = 1
DPSMate.DelayMsg = {}
DPSMate.BabbleSpell = BabbleSpell
DPSMate.BabbleBoss = BabbleBoss
DPSMate.MaxRows = 80
DPSMate.turtle_wow = (GetItemInfo(5000) == DPSMate.L["Character Name Change"]) and  true

-- Local Variables
local _G = getglobal
local classcolor = {
	rogue = {r=1.0, g=0.96, b=0.41},
	priest = {r=1,g=1,b=1},
	druid = {r=1,g=0.49,b=0.04},
	warrior = {r=0.78,g=0.61,b=0.43},
	warlock = {r=0.58,g=0.51,b=0.79},
	mage = {r=0.41,g=0.8,b=0.94},
	hunter = {r=0.67,g=0.83,b=0.45},
	paladin = {r=0.96,g=0.55,b=0.73},
	shaman = {r=0,g=0.44,b=0.87},
}
local t = {}
local tinsert = table.insert
local strgsub = string.gsub
local func = function(c) tinsert(t, c) end
local strformat = string.format
local strgfind = string.gfind
local pairs = pairs
local strlen = strlen
local strsub = strsub
local tonumber = tonumber
local getn = getn
local tconcat = table.concat


-- Begin functions

function DPSMate:OnLoad()
	SLASH_DPSMate1 = "/dps"
	SlashCmdList["DPSMate"] = function(msg) DPSMate:SlashCMDHandler(msg) end

	DPSMate:InitializeFrames()
	DPSMate.Options:InitializeConfigMenu()
	DPSMate:ApplyModules()
end

function DPSMate:SlashCMDHandler(msg)
	if (msg) then
		local cmd = msg
		if cmd == "lock" then
			DPSMate.Options:Lock()
		elseif cmd == "unlock" then
			DPSMate.Options:Unlock()
		elseif cmd == "config" then
			DPSMate_ConfigMenu:Show()
		elseif cmd == "showAll" then
			for _, val in DPSMate.DPSMateSettings["windows"] do DPSMate.Options:Show(getglobal("DPSMate_"..val["name"])) end
		elseif cmd == "hideAll" then
			for _, val in DPSMate.DPSMateSettings["windows"] do DPSMate.Options:Hide(getglobal("DPSMate_"..val["name"])) end
		elseif strsub(cmd, 1, 4) == "show" then
			local frame = _G("DPSMate_"..strsub(cmd, 6))
			if frame then
				DPSMate.Options:Show(frame)
			else
				DPSMate:SendMessage(DPSMate.L["framesavailable"])
				for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
					DPSMate:SendMessage("|c3ffddd80- "..val["name"].."|r")
				end
			end
		elseif strsub(cmd, 1, 4) == "hide" then
			local frame = _G("DPSMate_"..strsub(cmd, 6))
			if frame then
				DPSMate.Options:Hide(frame)
			else
				DPSMate:SendMessage(DPSMate.L["framesavailable"])
				for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
					DPSMate:SendMessage("|c3ffddd80- "..val["name"].."|r")
				end
			end
		else
			DPSMate:SendMessage(DPSMate.L["slashabout"])
			DPSMate:SendMessage(DPSMate.L["slashusage"])
			DPSMate:SendMessage(DPSMate.L["slashlock"])
			DPSMate:SendMessage(DPSMate.L["slashunlock"])
			DPSMate:SendMessage(DPSMate.L["slashshowAll"])
			DPSMate:SendMessage(DPSMate.L["slashhideAll"])
			DPSMate:SendMessage(DPSMate.L["slashshow"])
			DPSMate:SendMessage(DPSMate.L["slashhide"])
			DPSMate:SendMessage(DPSMate.L["slashconfig"])
		end
	end
end

function DPSMate:InitializeFrames()
	if not DPSMate.DPSMateSettings["windows"][1] then return end
	for k, val in pairs(DPSMate.DPSMateSettings["windows"]) do
		if not _G("DPSMate_"..val["name"]) then
			local f=CreateFrame("Frame", "DPSMate_"..val["name"], UIParent, "DPSMate_Statusframe")
			f.Key=k
		end
		local frame = _G("DPSMate_"..val["name"])
		frame.fborder = _G("DPSMate_"..val["name"].."_Border")
		DPSMate.DPSMateSettings["windows"][k]["hidden"] = false
		frame:SetToplevel(true)

		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Name"):SetText(self.L["total"])

		if (val["position"] and val["position"][1]) then
			frame:ClearAllPoints()
			frame:SetPoint(val["position"][1], UIParent, val["position"][1], val["position"][2], val["position"][3])
		end
		if (val["savsize"] and val["savsize"][1]) then
			frame:SetWidth(val["savsize"][1])
			frame:SetHeight(val["savsize"][2])
		end

		DPSMate.Options:ToggleDrewDrop(1, DPSMate.DB:GetOptionsTrue(1, k), frame)
		DPSMate.Options:ToggleDrewDrop(2, DPSMate.DB:GetOptionsTrue(2, k), frame)

		frame.fborder:SetAlpha(val["borderopacity"] or 0)
		frame.fborder:SetFrameStrata(DPSMate.Options.stratas[val["borderstrata"] or 1])
		frame.fborder:SetBackdrop({
								  bgFile = "",
								  edgeFile = DPSMate.Options.bordertextures[val["bordertexture"] or "UI-Tooltip-Border"], tile = true, tileSize = 12, edgeSize = 10,
								  insets = { left = 5, right = 5, top = 3, bottom = 1 }
								})
		frame.fborder:SetBackdropBorderColor(val["contentbordercolor"][1], val["contentbordercolor"][2], val["contentbordercolor"][3])

		local head = _G("DPSMate_"..val["name"].."_Head")
		head.font = _G("DPSMate_"..val["name"].."_Head_Font")
		head.bg = _G("DPSMate_"..val["name"].."_Head_Background")
		head.sync = _G("DPSMate_"..val["name"].."_Head_Sync")

		if DPSMate.DPSMateSettings["sync"] then
			head.sync:GetNormalTexture():SetVertexColor(0.67,0.83,0.45,1)
		else
			head.sync:GetNormalTexture():SetVertexColor(1,0,0,1)
		end

		if DPSMate.DPSMateSettings["lock"] then
			_G("DPSMate_"..val["name"].."_Resize"):Hide()
		end
		if not val["titlebar"] then
			head:Hide()
		end
		frame:SetAlpha(val["opacity"])
		head.font:SetTextColor(val["titlebarfontcolor"][1],val["titlebarfontcolor"][2],val["titlebarfontcolor"][3])
		head.bg:SetTexture(DPSMate.Options.statusbars[val["titlebartexture"]])
		head.bg:SetVertexColor(val["titlebarbgcolor"][1], val["titlebarbgcolor"][2], val["titlebarbgcolor"][3])
		head.bg:SetAlpha(val["titlebaropacity"] or 1)
		head.font:SetFont(DPSMate.Options.fonts[val["titlebarfont"]], val["titlebarfontsize"], DPSMate.Options.fontflags[val["titlebarfontflag"]])
		head:SetHeight(val["titlebarheight"])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetTexture(DPSMate.Options.bgtexture[val["contentbgtexture"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetVertexColor(val["contentbgcolor"][1], val["contentbgcolor"][2], val["contentbgcolor"][3])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Background"):SetAlpha(val["bgopacity"] or 1)
		frame:SetScale(val["scale"])
		_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(DPSMate.DPSMateSettings["enable"])

		-- Styles // Bars
		local child = _G("DPSMate_"..val["name"].."_ScrollFrame_Child")
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetPoint("TOPLEFT", child, "TOPLEFT")
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetPoint("TOPRIGHT", child, "TOPRIGHT")
		if DPSMate.DPSMateSettings["showtotals"] then
			_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetHeight(val["barheight"])
		else
			_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetHeight(0.00001)
		end
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetStatusBarTexture(DPSMate.Options.statusbars[val["bartexture"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"):SetStatusBarColor(1,1,1,val["totopacity"] or 1)
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_BG"):SetTexture(DPSMate.Options.statusbars[val["bartexture"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_BG"):SetAlpha(val["totopacity"] or 1)
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
		_G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
		for i=1, DPSMate.MaxRows do
			local bar = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i)
			bar.name = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name")
			bar.value = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value")
			bar.icon = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon")
			bar.bg = _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..i.."_BG")

			-- Postition
			bar:SetPoint("TOPLEFT", child, "TOPLEFT")
			bar:SetPoint("TOPRIGHT", child, "TOPRIGHT")
			if i>1 then
				bar:SetPoint("TOPLEFT", _G("DPSMate_"..val["name"].."_ScrollFrame_Child_StatusBar"..(i-1)), "BOTTOMLEFT", 0, -1*val["barspacing"])
			else
				if DPSMate.DPSMateSettings["showtotals"] then
					bar:SetPoint("TOPLEFT", _G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"), "BOTTOMLEFT", 0, -1*val["barspacing"])
				else
					bar:SetPoint("TOPLEFT", _G("DPSMate_"..val["name"].."_ScrollFrame_Child_Total"), "BOTTOMLEFT", 0, -1)
				end
			end
			if val["classicons"] then
				bar.name:ClearAllPoints()
				bar.name:SetPoint("TOPLEFT", bar, "TOPLEFT", val["barheight"], 0)
				bar.name:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
				bar.icon:SetWidth(val["barheight"])
				bar.icon:SetHeight(val["barheight"])
				bar.icon:Show()
			end

			-- Styles
			bar.name:SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
			bar.name:SetTextColor(val["barfontcolor"][1],val["barfontcolor"][2],val["barfontcolor"][3])
			bar.value:SetFont(DPSMate.Options.fonts[val["barfont"]], val["barfontsize"], DPSMate.Options.fontflags[val["barfontflag"]])
			bar.value:SetTextColor(val["barfontcolor"][1],val["barfontcolor"][2],val["barfontcolor"][3])
			bar:SetStatusBarTexture(DPSMate.Options.statusbars[val["bartexture"]])
			bar.bg:SetTexture(DPSMate.Options.statusbars[val["bartexture"]])
			bar:SetHeight(val["barheight"])
			if val["barbg"] then
				bar.bg:SetVertexColor(val["bgbarcolor"][1],val["bgbarcolor"][2],val["bgbarcolor"][3], 0)
			else
				bar.bg:SetVertexColor(val["bgbarcolor"][1],val["bgbarcolor"][2],val["bgbarcolor"][3], 0.5)
			end
		end
		DPSMate.Options:SelectRealtime(frame, val["realtime"])
	end
	DPSMate.Options:ToggleTitleBarButtonState()
	DPSMate.Options:HideWhenSolo()
	if not DPSMate.DPSMateSettings["enable"] then
		self:Disable()
	else
		self:Enable()
	end

	-- Report delay button
	DPSMate_Report_Delay:SetChecked(DPSMate.DPSMateSettings["reportdelay"])

	DPSMate_PopUp:SetToplevel(true)
	DPSMate_Vote:SetToplevel(true)
	DPSMate_Logout:SetToplevel(true)
	DPSMate_Report:SetToplevel(true)
	DPSMate_ConfigMenu:SetToplevel(true)
end

function DPSMate:ProbZero(val)
	if (val==0) then
		return 1;
	end
	return val;
end

function DPSMate:TMax(t)
	local max = 0
	for _,val in pairs(t) do
		if val>max then
			max=val
		end
	end
	return max
end

function DPSMate:TableLength(t)
	local count = 0
	if (t) then
		count = getn(t)
		if count==0 then
			for _,_ in pairs(t) do
				count = count + 1
			end
		end
	end
	return count
end

function DPSMate:TContains(t, value)
	if (t) then
		for cat, val in pairs(t) do
			if val == value or cat==value then
				return true
			end
		end
	end
	return false
end

function DPSMate:GetKeyByVal(t, value)
	for cat, val in pairs(t) do
		if val == value then
			return cat
		end
	end
end

local type = type
function DPSMate:GetKeyByValInTT(t, x, y)
	for cat, val in pairs(t) do
		if (type(val) == "table") then
			if (x==val[y]) then
				return cat
			end
		end
	end
end

function DPSMate:InvertTable(t)
	local s={}
	for cat, val in pairs(t) do
		s[val]=cat
	end
	return s
end

function DPSMate:CopyTable(t)
	local s={}
	for cat, val in pairs(t) do
		s[cat] = val
	end
	return s
end

function DPSMate:GetUserById(id)
	if not self.UserId or not self.UserId[id] then
		self.UserId = {}
		for cat, val in DPSMate.Cache.DPSMateUser do
			self.UserId[val[1]] = cat
		end
	end
	return self.UserId[id]
end

function DPSMate:GetAbilityById(id)
	if not self.AbilityId or not self.AbilityId[id] then
		self.AbilityId = {}
		for cat, val in DPSMate.Cache.DPSMateAbility do
			self.AbilityId[val[1]] = cat
		end
	end
	return self.AbilityId[id]
end

function DPSMate:GetMaxValue(arr, key)
	local max = 0
	for _, val in arr do
		if val[key]>max then
			max=val[key]
		end
	end
	return max
end

function DPSMate:GetMinValue(arr, key)
	local min
	for _, val in arr do
		if not min or val[key]<min then
			min = val[key]
		end
	end
	return min or 0
end

function DPSMate:ScaleDown(arr, start)
	local t = {}
	for cat, val in arr do
		t[cat] = {(val[1]-start+1), val[2]}
	end
	return t
end

function DPSMate:SetStatusBarValue()
	if not DPSMate.DPSMateSettings["windows"][1] or self.Options.TestMode then return end
	local arr, cbt, ecbt, user, val, perc, strt, statusbar, r, g, b, img, len
	for k,c in pairs(DPSMate.DPSMateSettings.windows) do
		arr, cbt, ecbt = self:GetMode(k)
		user, val, perc, strt = self:GetSettingValues(arr,cbt,k,ecbt)
		if DPSMate.DPSMateSettings["showtotals"] then
			_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Value"):SetText(strt[1]..strt[2])
		end
		if not c["cbtdisplay"] then
			_G("DPSMate_"..c["name"].."_Head_Font"):SetText(self.Options.Options[1]["args"][c["CurMode"]].name.." ["..self.Options:FormatTime(cbt).."]")
		end
		len = 0
		for i=1, DPSMate.MaxRows do
			statusbar = _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i)
			if user[i] then
				r,g,b,img = self:GetClassColor(user[i])
				statusbar:SetStatusBarColor(r,g,b, 1)

				if c["ranks"] then 
					_G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetText(i..". "..user[i])
				else
					_G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetText(user[i])
				end
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetText(val[i])
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon"):SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\"..img)
				statusbar:SetValue(perc[i])

				statusbar.user = user[i]
				statusbar:Show()
				len = len + 1
			else
				statusbar:Hide()
			end
		end
		_G("DPSMate_"..c["name"].."_ScrollFrame_Child"):SetHeight((len+1)*(c["barheight"]+c["barspacing"]))
		_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total"):Show()
		if len == 0 then
			_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total"):Hide()
		end
	end
end

function DPSMate:strrev(str)
	local res, len = {}, strlen(str)
	for i=0, len-1 do
		res[i] = strsub(str, len-i, len-i)
	end
	return tconcat(res);
end

function DPSMate:Commas(n,k)
	if DPSMate.DPSMateSettings["windows"][k]["numberformat"] == 3 then
		n = strformat("%.0f", n)
		for left, num, right in strgfind(n, '([^%d]*%d)(%d+)') do
			return left and left..self:strrev(strgsub(self:strrev(num), '(%d%d%d)','%1,'))
		end
	end
	return n;
end

function DPSMate:FormatNumbers(dmg,total,sort,k)
	local oldd, oldt, olds = dmg, total, sort
	if DPSMate.DPSMateSettings["windows"][k]["numberformat"] == 2 then
		if dmg>10000 then
			dmg = strformat("%.0f", (dmg/1000))
		end
		if total>10000 then
			total = strformat("%.0f", (total/1000))
		end
		if sort>10000 then
			sort = strformat("%.0f", (sort/1000))
		end
	elseif DPSMate.DPSMateSettings["windows"][k]["numberformat"] == 4 then
		if dmg>10000 then
			dmg = strformat("%.1f", (dmg/1000))
		end
		if total>10000 then
			total = strformat("%.1f", (total/1000))
		end
		if sort>10000 then
			sort = strformat("%.1f", (sort/1000))
		end
	end
	return dmg, total, sort, oldd, oldt, olds
end

function DPSMate:ApplyFilter(key, name)
	if not key or not name or not DPSMate.Cache.DPSMateUser[name] then return true end
	local class = DPSMate.Cache.DPSMateUser[name][2] or "warrior"
	local path = DPSMate.DPSMateSettings["windows"][key]
	if path["grouponly"] then
		if not DPSMate.Parser.TargetParty[name] and DPSMate.Parser.TargetParty ~= {} then
			return false
		end
	end

	if path["filterpeople"] ~= "" then
		-- Certain people
		t = {}
		strgsub(path["filterpeople"], "(.-),", func)
		for cat, val in pairs(t) do
			if name == val then
				return true
			end
		end
	end

	-- classes
	for cat, val in pairs(path["filterclasses"]) do
		if not val then
			if cat == class then
				return false
			end
		end
	end
	return true
end

function DPSMate:GetSettingValues(arr, cbt, k, ecbt)
	k = k or 1
	return self.RegistredModules[DPSMate.DPSMateSettings["windows"][k]["CurMode"]]:GetSettingValues(arr, cbt, k, ecbt)
end

function DPSMate:EvalTable(k)
	k = k or 1
	return self.RegistredModules[DPSMate.DPSMateSettings["windows"][k]["CurMode"]]:EvalTable(DPSMate.Cache.DPSMateUser[UnitName("player")], k)
end

function DPSMate:GetClassColor(class)
	if not classcolor[class] then
		if class and DPSMate.Cache.DPSMateUser[class] then
			class = DPSMate.Cache.DPSMateUser[class][2] or "warrior"
		else
			class = "warrior"
		end
	end
	if classcolor[class]==nil then class="warrior" end
	return classcolor[class].r, classcolor[class].g, classcolor[class].b, class
end

function DPSMate:GetMode(k)
	k = k or 1
	local Handler = DPSMate.RegistredModules[DPSMate.DPSMateSettings["windows"][k]["CurMode"]]
	local result = {
		total={Handler.DB[1], DPSMate.Cache.DPSMateCombatTime["total"],
		DPSMate.Cache.DPSMateCombatTime["effective"][1]},
		currentfight={
			Handler.DB[2], 
			DPSMate.Cache.DPSMateCombatTime["current"], 
			DPSMate.Cache.DPSMateCombatTime["effective"][2]
		}
	}
	local num
	for cat, val in pairs(DPSMate.DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				num = tonumber(strsub(cat, 8))
				if DPSMate.DPSMateHistory[Handler.Hist][num] then
					return DPSMate.DPSMateHistory[Handler.Hist][num], DPSMate.Cache.DPSMateCombatTime["segments"][num][1], DPSMate.Cache.DPSMateCombatTime["segments"][num][2]
				else
					return {}, 0, 0
				end
			else
				return result[cat][1], result[cat][2], result[cat][3]
			end
		end
	end
end

function DPSMate:GetModeByArr(arr, k, Hist)
	local result = {total={arr[1], DPSMate.Cache.DPSMateCombatTime["total"], DPSMate.Cache.DPSMateCombatTime["effective"][1]}, currentfight={arr[2], DPSMate.Cache.DPSMateCombatTime["current"], DPSMate.Cache.DPSMateCombatTime["effective"][2]}}
	local num
	for cat, val in pairs(DPSMate.DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				num = tonumber(strsub(cat, 8))
				if DPSMate.DPSMateHistory[Hist or arr.Hist][num] then
					return DPSMate.DPSMateHistory[Hist or arr.Hist][num], DPSMate.Cache.DPSMateCombatTime["segments"][num][1], DPSMate.Cache.DPSMateCombatTime["segments"][num][2]
				else
					return {}, 0, 0
				end
			else
				return result[cat][1], result[cat][2], result[cat][3]
			end
		end
	end
end

function DPSMate:GetModeName(k)
	k = k or 1
	local result = {total="Total", currentfight="Current fight"}
	local num
	for cat, val in pairs(DPSMate.DPSMateSettings["windows"][k]["options"][2]) do
		if val then
			if strfind(cat, "segment") then
				num = tonumber(strsub(cat, 8))
				return DPSMate.DPSMateHistory["names"][num]
			else
				return result[cat]
			end
		end
	end
end

function DPSMate:Disable()
	if self.Registered ~= nil then
		self.Sync:UnregisterEvent("CHAT_MSG_ADDON")
		
		for _, event in pairs(self.Events) do
			self.Parser:UnregisterEvent(event)
		end

		self.Parser:RegisterRawEvent(nil)

		self.Registered = false
	end
end

function DPSMate:Enable()
	if not self.Registered then
		self.Sync:RegisterEvent("CHAT_MSG_ADDON")
		
		for _, event in pairs(self.Events) do
			self.Parser:RegisterEvent(event)
		end
	
		for _, val in pairs(self.RegistredModules) do
			if val.Events then
				for _, event in pairs(val.Events) do
					if self.DB.has_superwow then
						self.Parser:RegisterRawEvent(event)
					else
						self.Parser:RegisterEvent(event)
					end
				end
			end
		end

		self.Registered = true
	end
end

function DPSMate:Broadcast(ctype, who, what, with, value, failtype)
	if DPSMate.DPSMateSettings["broadcasting"] then
		if IsRaidLeader() or IsRaidOfficer() then
			ch = "RAID"
			if DPSMate.DPSMateSettings["bcrw"] then
				ch = "RAID_WARNING"
			end
			if DPSMate.DPSMateSettings["bccd"] and ctype == 1 then
				SendChatMessage(self.L["bccdo"](who, what), ch, nil, nil)
				return
			elseif DPSMate.DPSMateSettings["bccd"] and ctype == 6 then
				SendChatMessage(self.L["bccdt"](who, what), ch, nil, nil)
				return
			elseif DPSMate.DPSMateSettings["bcress"] and ctype == 2 then
				SendChatMessage(self.L["bcress"](who, what), ch, nil, nil)
				return
			elseif DPSMate.DPSMateSettings["bckb"] and ctype == 4 then
				SendChatMessage(self.L["bckb"](who, what, with, value), ch, nil, nil)
				return
			elseif DPSMate.DPSMateSettings["bcfail"] and ctype == 3 then
				if failtype == 1 then
					SendChatMessage(self.L["bcfailo"](what, who, value, with), ch, nil, nil)
				elseif failtype == 3 then
					SendChatMessage(self.L["bcfailt"](who, with), ch, nil, nil)
				else
					SendChatMessage(self.L["bcfailth"](who, value, with, what), ch, nil, nil)
				end
				return
			end
		end
	end
end

function DPSMate:SendMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8080"..self.L["name"].."|r: "..msg)
end

function DPSMate:Register(prefix, table, name)
	self.ModuleNames[name] = prefix
	self.RegistredModules[prefix] = table
	self.EnabledModules[prefix] = nil
end

function DPSMate:ApplyModules()
	for k,v in self.RegistredModules do 
		if DPSMate:TContains(DPSMate.DPSMateSettings["enabledmodes"], k) then
			self.EnabledModules[k] = v
		end
	end
end

function DPSMate:EnableModule(prefix)
	self.EnabledModules[prefix] = true
end

function DPSMate:DisableModule(prefix)
	self.EnabledModules[prefix] = nil
end

function DPSMate:GetAEnabledModule()
	for prefix,enabled in self.EnabledModules do
		if enabled then 
			return prefix
		end
	end
end

function DPSMate.DB:ResetDB(forceReset, allReset)
	if forceReset then
		DPSMateHistory = nil
		
		if allReset then
			DPSMateAbility = nil
			DPSMateUser = nil
		end

		DPSMateDamageDone = nil
		DPSMateDamageTaken = nil
		DPSMateEDD = nil
		DPSMateEDT = nil
		DPSMateTHealing = nil
		DPSMateEHealing = nil
		DPSMateOverhealing = nil
		DPSMateHealingTaken = nil
		DPSMateEHealingTaken = nil
		DPSMateOverhealingTaken = nil
		DPSMateAbsorbs = nil
		DPSMateDispels = nil
		DPSMateDeaths = nil
		DPSMateInterrupts = nil
		DPSMateAurasGained = nil
		DPSMateThreat = nil
		DPSMateFails = nil
		DPSMateCCBreaker = nil
	
		DPSMateCombatTime = nil
	end
	
	DPSMateUserOffHand = nil
end

function DPSMate.DB:ResetTempTable()
	DPSMate.DB.NextSwing = {}
	DPSMate.DB.NextSwingEDD = {}
	DPSMate.Cache.ActiveMob = {}
	DPSMate.Cache.Await = {}
	DPSMate.Cache.broken = {}
	DPSMate.Cache.AwaitDispelT = {}
	DPSMate.Cache.AwaitHotDispelT = {}
	DPSMate.Cache.ActiveHotDispel = {}
	DPSMate.Cache.ConfirmedDispel = {}
	DPSMate.Cache.AwaitKick = {}
 	DPSMate.Cache.AfflictedStun = {}
 	DPSMate.Cache.AwaitBuff = {}
	DPSMate.Cache.ActiveCC = {}
	DPSMate.Cache.GUID = {}
end

function DPSMate.DB:InitDB()
	DPSMate.DB:ResetTempTable()

	if DPSMateSettings == nil then
		DPSMateSettings = {
			windows = {
				[1] = {
					name = "DPSMate",
					options = {
						[1] = {
							damage = true
						},
						[2] = {
							total = true
						}
					},
					CurMode = "damage",
					hidden = false,
					scale = 1,
					barfont = "FRIZQT",
					barfontsize = 13,
					barfontflag = "Outline",
					bartexture = "Minimalist",
					barspacing = 1,
					barheight = 17,
					classicons = true,
					ranks = true,
					titlebar = true,
					titlebarfont = "FRIZQT",
					titlebarfontflag = "None",
					titlebarfontsize = 12,
					titlebarheight = 17,
					titlebarreport = true,
					titlebarreset = true,
					titlebarsegments = true,
					titlebarconfig = true,
					titlebarsync = true,
					titlebarenable = true,
					titlebarfilter = true,
					titlebartexture = "Minimalist",
					titlebarbgcolor = {0.1568627450980392,0.1725490196078431,0.1647058823529412},
					titlebarfontcolor = {1.0,0.82,0.0},
					barfontcolor = {1.0,1.0,1.0},
					contentbgtexture = "UI-Tooltip-Background",
					contentbgcolor = {0.01568627450980392,0,1},
					bgbarcolor = {1,1,1},
					numberformat = 1,
					opacity = 1,
					bgopacity = 0,
					titlebaropacity = 1,
					filterclasses = {
						warrior = true,
						rogue = true,
						priest = true,
						hunter = true,
						mage = true,
						warlock = true,
						paladin = true,
						shaman = true,
						druid = true,
					},
					filterpeople = "",
					grouponly = true,
					realtime = false,
					cbtdisplay = false,
					barbg = false,
					totopacity = 1.0,
					borderopacity = 1.0,
					contentbordercolor = {0,0,0},
					borderstrata = 1,
					bordertexture = "UI-Tooltip-Border",
					position = {"CENTER",0,0},
					savsize = {150,100},
				}
			},
			lock = false,
			sync = true,
			enable = true,
			dataresetsworld = 2,
			dataresetsjoinparty = 2,
			dataresetsleaveparty = 2,
			dataresetspartyamount = 2,
			dataresetssync = 3,
			dataresetslogout = 2,
			showminimapbutton = true,
			MinimapButtonPosition = 336,
			showtotals = true,
			hidewhensolo = false,
			hideincombat = false,
			hideinpvp = false,
			disablewhilehidden = false,
			datasegments = 8,
			mergepets = true,
			columnsdps = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			},
			columnsdmg = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsdmgtaken = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsdtps = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			},
			columnsedd = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsedt = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnshealing = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnshealingtaken = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnshps = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			},
			columnsohps = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			},
			columnsoverhealing = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsohealingtaken = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsehealing = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsehealingtaken = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsehps = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			},
			columnsabsorbs = {
				[1] = true,
				[2] = true,
				[3] = false,
				[4] = false
			},
			columnsabsorbstaken = {
				[1] = true,
				[2] = true,
				[3] = false,
				[4] = false
			},
			columnshab = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsdeaths = {
				[1] = true,
				[2] = true,
			},
			columnsinterrupts = {
				[1] = true,
				[2] = true,
			},
			columnsdispels = {
				[1] = true,
				[2] = true,
			},
			columnsdispelsreceived = {
				[1] = true,
				[2] = true,
			},
			columnsdecurses = {
				[1] = true,
				[2] = true,
			},
			columnsdecursesreceived = {
				[1] = true,
				[2] = true,
			},
			columnsdisease = {
				[1] = true,
				[2] = true,
			},
			columnsdiseasereceived = {
				[1] = true,
				[2] = true,
			},
			columnspoison = {
				[1] = true,
				[2] = true,
			},
			columnspoisonreceived = {
				[1] = true,
				[2] = true,
			},
			columnsmagic = {
				[1] = true,
				[2] = true,
			},
			columnsmagicreceived = {
				[1] = true,
				[2] = true,
			},
			columnsaurasgained = {
				[1] = true,
				[2] = true,
			},
			columnsauraslost = {
				[1] = true,
				[2] = true,
			},
			columnsaurauptime = {
				[1] = true,
				[2] = true,
			},
			columnsprocs = {
				[1] = true,
				[2] = true,
			},
			columnscasts = {
				[1] = true,
				[2] = true,
			},
			columnsthreat = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnstps = {
				[1] = false,
				[2] = true,
				[3] = true,
				[4] = false
			},
			columnsfails = {
				[1] = true,
				[2] = true,
			},
			columnsccbreaker = {
				[1] = true,
				[2] = true,
			},
			columnsfriendlyfire = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			columnsfriendlyfiretaken = {
				[1] = true,
				[2] = false,
				[3] = true,
				[4] = false
			},
			showtooltips = true,
			informativetooltips = true,
			subviewrows = 4,
			tooltipanchor = 5,
			onlybossfights = true,
			--hiddenmodes = {},
			broadcasting = false,
			bccd = false,
			bcress = false,
			bckb = false,
			bcfail = false,
			bcrw = false,
			targetscale=0.58,
			hideonlogin = false,
			reportdelay = false
		}
	end
	DPSMate.DPSMateSettings = DPSMateSettings

	if not DPSMate.DPSMateSettings["enabledmodes"] then
		DPSMate.DPSMateSettings["hiddenmodes"] = nil
		DPSMate.DPSMateSettings["enabledmodes"] = {
			["damage"] = true,
			["effectivehealing"] = true,
			["healing"] = true,
		}
	end

	if DPSMateHistory == nil then 
		DPSMateHistory = {
			names = {},
			DMGDone = {},
			DMGTaken = {},
			EDDone = {},
			EDTaken = {},
			THealing = {},
			EHealing = {},
			OHealing = {},
			EHealingTaken = {},
			THealingTaken = {},
			OHealingTaken = {},
			Absorbs = {},
			Deaths = {},
			Interrupts = {},
			Dispels = {},
			Auras = {},
			Threat = {},
			Fail = {},
			CCBreaker = {}
		}
	end

	if DPSMateAbility == nil then DPSMateAbility = {} end
	if DPSMateUser == nil then DPSMateUser = {} end
	if DPSMateDamageDone == nil then DPSMateDamageDone = {[1]={},[2]={}} end
	if DPSMateDamageTaken == nil then DPSMateDamageTaken = {[1]={},[2]={}} end
	if DPSMateEDD == nil then DPSMateEDD = {[1]={},[2]={}} end
	if DPSMateEDT == nil then DPSMateEDT = {[1]={},[2]={}} end
	if DPSMateTHealing == nil then DPSMateTHealing = {[1]={},[2]={}} end
	if DPSMateEHealing == nil then DPSMateEHealing = {[1]={},[2]={}} end
	if DPSMateOverhealing == nil then DPSMateOverhealing = {[1]={},[2]={}} end
	if DPSMateHealingTaken == nil then DPSMateHealingTaken = {[1]={},[2]={}} end
	if DPSMateEHealingTaken == nil then DPSMateEHealingTaken = {[1]={},[2]={}} end
	if DPSMateOverhealingTaken == nil then DPSMateOverhealingTaken = {[1]={},[2]={}} end
	if DPSMateAbsorbs == nil then DPSMateAbsorbs = {[1]={},[2]={}} end
	if DPSMateDispels == nil then DPSMateDispels = {[1]={},[2]={}} end
	if DPSMateDeaths == nil then DPSMateDeaths = {[1]={},[2]={}} end
	if DPSMateInterrupts == nil then DPSMateInterrupts = {[1]={},[2]={}} end
	if DPSMateAurasGained == nil then DPSMateAurasGained = {[1]={},[2]={}} end
	if DPSMateThreat == nil then DPSMateThreat = {[1]={},[2]={}} end
	if DPSMateFails == nil then DPSMateFails = {[1]={},[2]={}} end
	if DPSMateCCBreaker == nil then DPSMateCCBreaker = {[1]={},[2]={}} end

	if DPSMateCombatTime == nil then
		DPSMateCombatTime = {
			total = 0.0001,
			current = 0.0001,
			segments = {},
			effective = {
				[1] = {},
				[2] = {}
			},
		}
	end
	
	if DPSMateUserOffHand == nil then DPSMateUserOffHand = {} end
	
	DPSMate.DPSMateHistory = DPSMateHistory

	DPSMate.Cache.DPSMateAbility = DPSMateAbility
	DPSMate.Cache.DPSMateUser = DPSMateUser
	DPSMate.Cache.DPSMateDamageDone = DPSMateDamageDone
	DPSMate.Cache.DPSMateDamageTaken = DPSMateDamageTaken
	DPSMate.Cache.DPSMateEDD = DPSMateEDD
	DPSMate.Cache.DPSMateEDT = DPSMateEDT
	DPSMate.Cache.DPSMateTHealing = DPSMateTHealing
	DPSMate.Cache.DPSMateEHealing = DPSMateEHealing
	DPSMate.Cache.DPSMateOverhealing = DPSMateOverhealing
	DPSMate.Cache.DPSMateHealingTaken = DPSMateHealingTaken
	DPSMate.Cache.DPSMateEHealingTaken = DPSMateEHealingTaken
	DPSMate.Cache.DPSMateOverhealingTaken = DPSMateOverhealingTaken
	DPSMate.Cache.DPSMateAbsorbs = DPSMateAbsorbs
	DPSMate.Cache.DPSMateDispels = DPSMateDispels
	DPSMate.Cache.DPSMateDeaths = DPSMateDeaths
	DPSMate.Cache.DPSMateInterrupts = DPSMateInterrupts
	DPSMate.Cache.DPSMateAurasGained = DPSMateAurasGained
	DPSMate.Cache.DPSMateThreat = DPSMateThreat
	DPSMate.Cache.DPSMateFails = DPSMateFails
	DPSMate.Cache.DPSMateCCBreaker = DPSMateCCBreaker

	DPSMate.Cache.DPSMateCombatTime = DPSMateCombatTime
	DPSMate.Cache.DPSMateUserOffHand = DPSMateUserOffHand

	DPSMate.DB.abilitylen = DPSMate:TableLength(DPSMate.Cache.DPSMateAbility)
	DPSMate.DB.userlen = DPSMate:TableLength(DPSMate.Cache.DPSMateUser)
	
	--if DPSMate.DB.userlen==0 then
	--	DPSMate.DB.userlen = 1
	--end
	--if DPSMate.DB.abilitylen == 0 then
	--	DPSMate.DB.abilitylen = 1
	--end

	if DPSMate.Modules.DPS then DPSMate.Modules.DPS.DB = DPSMate.Cache.DPSMateDamageDone end
	if DPSMate.Modules.Damage then DPSMate.Modules.Damage.DB = DPSMate.Cache.DPSMateDamageDone end
	if DPSMate.Modules.DamageTaken then DPSMate.Modules.DamageTaken.DB = DPSMate.Cache.DPSMateDamageTaken end
	if DPSMate.Modules.DTPS then DPSMate.Modules.DTPS.DB = DPSMate.Cache.DPSMateDamageTaken end
	if DPSMate.Modules.EDD then DPSMate.Modules.EDD.DB = DPSMate.Cache.DPSMateEDD end
	if DPSMate.Modules.EDT then DPSMate.Modules.EDT.DB = DPSMate.Cache.DPSMateEDT end
	if DPSMate.Modules.FriendlyFire then DPSMate.Modules.FriendlyFire.DB = DPSMate.Cache.DPSMateEDT end
	if DPSMate.Modules.FriendlyFireTaken then DPSMate.Modules.FriendlyFireTaken.DB = DPSMate.Cache.DPSMateEDT end
	if DPSMate.Modules.Healing then DPSMate.Modules.Healing.DB = DPSMate.Cache.DPSMateTHealing end
	if DPSMate.Modules.HPS then DPSMate.Modules.HPS.DB = DPSMate.Cache.DPSMateTHealing end
	if DPSMate.Modules.Overhealing then DPSMate.Modules.Overhealing.DB = DPSMate.Cache.DPSMateOverhealing end
	if DPSMate.Modules.EffectiveHealing then DPSMate.Modules.EffectiveHealing.DB = DPSMate.Cache.DPSMateEHealing end
	if DPSMate.Modules.EffectiveHPS then DPSMate.Modules.EffectiveHPS.DB = DPSMate.Cache.DPSMateEHealing end
	if DPSMate.Modules.HealingTaken then DPSMate.Modules.HealingTaken.DB = DPSMate.Cache.DPSMateHealingTaken end
	if DPSMate.Modules.EffectiveHealingTaken then DPSMate.Modules.EffectiveHealingTaken.DB = DPSMate.Cache.DPSMateEHealingTaken end
	if DPSMate.Modules.Absorbs then DPSMate.Modules.Absorbs.DB = DPSMate.Cache.DPSMateAbsorbs end
	if DPSMate.Modules.AbsorbsTaken then DPSMate.Modules.AbsorbsTaken.DB = DPSMate.Cache.DPSMateAbsorbs end
	if DPSMate.Modules.HealingAndAbsorbs then DPSMate.Modules.HealingAndAbsorbs.DB = DPSMate.Cache.DPSMateAbsorbs end
	if DPSMate.Modules.Deaths then DPSMate.Modules.Deaths.DB = DPSMate.Cache.DPSMateDeaths end
	if DPSMate.Modules.Dispels then DPSMate.Modules.Dispels.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.DispelsReceived then DPSMate.Modules.DispelsReceived.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.Decurses then DPSMate.Modules.Decurses.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.DecursesReceived then DPSMate.Modules.DecursesReceived.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.CureDisease then DPSMate.Modules.CureDisease.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.CureDiseaseReceived then DPSMate.Modules.CureDiseaseReceived.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.CurePoison then DPSMate.Modules.CurePoison.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.CurePoisonReceived then DPSMate.Modules.CurePoisonReceived.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.LiftMagic then DPSMate.Modules.LiftMagic.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.LiftMagicReceived then DPSMate.Modules.LiftMagicReceived.DB = DPSMate.Cache.DPSMateDispels end
	if DPSMate.Modules.Interrupts then DPSMate.Modules.Interrupts.DB = DPSMate.Cache.DPSMateInterrupts end
	if DPSMate.Modules.AurasGained then DPSMate.Modules.AurasGained.DB = DPSMate.Cache.DPSMateAurasGained end
	if DPSMate.Modules.AurasLost then DPSMate.Modules.AurasLost.DB = DPSMate.Cache.DPSMateAurasGained end
	if DPSMate.Modules.AurasLost then DPSMate.Modules.AurasLost.DB = DPSMate.Cache.DPSMateAurasGained end
	if DPSMate.Modules.AurasUptimers then DPSMate.Modules.AurasUptimers.DB = DPSMate.Cache.DPSMateAurasGained end
	if DPSMate.Modules.Procs then DPSMate.Modules.Procs.DB = DPSMate.Cache.DPSMateAurasGained end
	if DPSMate.Modules.Casts then DPSMate.Modules.Casts.DB = DPSMate.Cache.DPSMateEDT end
	if DPSMate.Modules.Threat then DPSMate.Modules.Threat.DB = DPSMate.Cache.DPSMateThreat end
	if DPSMate.Modules.TPS then DPSMate.Modules.TPS.DB = DPSMate.Cache.DPSMateThreat end
	if DPSMate.Modules.Fails then DPSMate.Modules.Fails.DB = DPSMate.Cache.DPSMateFails end
	if DPSMate.Modules.CCBreaker then DPSMate.Modules.CCBreaker.DB = DPSMate.Cache.DPSMateCCBreaker end
	if DPSMate.Modules.OHPS then DPSMate.Modules.OHPS.DB = DPSMate.Cache.DPSMateOverhealing end
	if DPSMate.Modules.OHealingTaken then DPSMate.Modules.OHealingTaken.DB = DPSMate.Cache.DPSMateOverhealingTaken end
	if DPSMate.Modules.Activity then DPSMate.Modules.Activity.DB = DPSMate.Cache.DPSMateCombatTime end
end

DPSMate.DB:ResetDB(true, true)
DPSMate.DB:InitDB()