local LockPortOptions_DefaultSettings = {
	whisper = true,
	zone    = true,
	shards  = true,
	sound   = true,
}
local BS                              = AceLibrary("Mrbcat-Spell-2.2")
local logo                            = "|CFFB700B7L|CFFFF00FFo|CFFFF50FFc|CFFFF99FFk|CFFFFC4FFP|cffffffffort|r"
local _, PlayerClass                  = UnitClass("player")
local SoulShard                       = (GetLocale() == "zhCN") and "灵魂碎片" or "Soul Shard"
local ACE_BC = AceLibrary("Babble-Class-2.2")
local Classtoen = {
    ["术士"] = "WARLOCK",
    ["战士"] = "WARRIOR",
    ["猎人"] = "HUNTER",
    ["法师"] = "MAGE",
    ["牧师"] = "PRIEST",
    ["德鲁伊"] = "DRUID",
    ["圣骑士"] = "PALADIN",
    ["萨满祭司"] = "SHAMAN",
    ["盗贼"] = "ROGUE",
    ["warlock"] = "WARLOCK",
    ["warrior"] = "WARRIOR",
    ["hunter"] = "HUNTER",
    ["mage"] = "MAGE",
    ["priest"] = "PRIEST",
    ["druid"] = "DRUID",
    ["paladin"] = "PALADIN",
    ["shaman"] = "SHAMAN",
    ["rogue"] = "ROGUE",
}
Classtoen = setmetatable(Classtoen, {
    __index = function(tab, key) return _G.UNKNOWN end })
local function LockPort_Initialize()
	if not LockPortOptions then
		LockPortOptions = {}
	end
	for i in LockPortOptions_DefaultSettings do
		if LockPortOptions[i] == false then
			LockPortOptions[i] = false
		else
			LockPortOptions[i] = LockPortOptions_DefaultSettings[i]
		end
	end
	if LockPortOptions["whisper"] == true then
		WhisperCheckButton:SetChecked(true)
	else
		WhisperCheckButton:SetChecked(false)
	end
	if LockPortOptions["zone"] == true then
		ZoneCheckButton:SetChecked(true)
	else
		ZoneCheckButton:SetChecked(false)
	end
	if LockPortOptions["shards"] == true then
		ShardsCheckButton:SetChecked(true)
	else
		ShardsCheckButton:SetChecked(false)
	end
	if LockPortOptions["sound"] == true then
		SoundCheckButton:SetChecked(true)
	else
		SoundCheckButton:SetChecked(false)
	end
end

function LockPort_EventFrame_OnLoad()
	DEFAULT_CHAT_FRAME:AddMessage(string.format(logo .. " version %s by %s. Type /lockport to show.",
		GetAddOnMetadata("LockPort", "Version"), GetAddOnMetadata("LockPort", "Author")))
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("CHAT_MSG_ADDON")
	this:RegisterEvent("CHAT_MSG_RAID")
	this:RegisterEvent("CHAT_MSG_RAID_LEADER")
	--this:RegisterEvent("CHAT_MSG_SAY")
	this:RegisterEvent("CHAT_MSG_PARTY")
	--this:RegisterEvent("CHAT_MSG_YELL")
	this:RegisterEvent("CHAT_MSG_WHISPER")
	-- Commands
	SlashCmdList["LockPort"]         = LockPort_SlashCommand
	SLASH_LockPort1                  = "/lockport"
	SLASH_LockPort2                  = "/gurky"
	MSG_PREFIX_ADD                   = "RSAdd"
	MSG_PREFIX_REMOVE                = "RSRemove"
	LockPortDB                       = {}
	-- Sync Summon Table between raiders ? (if in raid & raiders with unempty table)
	--localization
	LockPortLoc_Header               = logo .. ""
	LockPortLoc_Settings_Header      = logo .. " 设置"
	LockPortLoc_Settings_Chat_Header = "|CFFB700B7C|CFFFF00FFh|CFFFF50FFa|CFFFF99FFt|CFFFFC4FF S|cffffffffett|rings"
end

function LockPort_EventFrame_OnEvent()
	if event == "VARIABLES_LOADED" then
		this:UnregisterEvent("VARIABLES_LOADED")
		LockPort_Initialize()
	elseif event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_PARTY" then
		-- if (string.find(arg1, "^123") and UnitClass("player")~=arg2) then

		if string.find(arg1, "^123") then
			-- DEFAULT_CHAT_FRAME:AddMessage("CHAT_MSG")

			if GetNumRaidMembers() > 0 then
				SendAddonMessage(MSG_PREFIX_ADD, arg2, "RAID")
			elseif GetNumPartyMembers() > 0 then
				SendAddonMessage(MSG_PREFIX_ADD, arg2, "PARTY")
			end
		end
	elseif event == "CHAT_MSG_ADDON" then
		local _, class = UnitClass("player")
		if arg1 == MSG_PREFIX_ADD then
			-- DEFAULT_CHAT_FRAME:AddMessage("CHAT_MSG_ADDON - RSAdd : " .. arg2)
			if not LockPort_hasValue(LockPortDB, arg2) and UnitName("player") ~= arg2 and class == "WARLOCK" then
				table.insert(LockPortDB, arg2)
				PlaySoundFile("Sound\\Creature\\Necromancer\\NecromancerReady1.wav")
				LockPort_UpdateList()
				if LockPortOptions.sound then
					PlaySoundFile("Sound\\Creature\\Necromancer\\NecromancerReady1.wav")
				end
			end
		elseif arg1 == MSG_PREFIX_REMOVE then
			if LockPort_hasValue(LockPortDB, arg2) then
				-- DEFAULT_CHAT_FRAME:AddMessage("CHAT_MSG_ADDON - RSRemove : " .. arg2)
				for i, v in ipairs(LockPortDB) do
					if v == arg2 then
						table.remove(LockPortDB, i)
						LockPort_UpdateList()
					end
				end
			end
		end
	end
end

function LockPort_hasValue(tab, val)
	for i, v in ipairs(tab) do
		if v == val then
			return true
		end
	end
	return false
end

local function ToUseTab()
	if GetNumRaidMembers() > 0 then
		LockPort_GetRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		LockPort_GetPartyMembers()
	end
end
--GUI
function LockPort_NameListButton_OnClick(button)
	local name = getglobal(this:GetName() .. "TextName"):GetText()
	local message, base_message, whisper_message, base_whisper_message, whisper_eviltwin_message, zone_message, subzone_message =
	""
	local count = select(4,FindItem(SoulShard))
	local eviltwin_debuff = "Spell_Shadow_Charm"
	local has_eviltwin = false
	local RorP, folg
	if GetNumRaidMembers() > 0 then
		RorP, folg = "RAID", "raid"
	elseif GetNumPartyMembers() > 0 then
		RorP, folg = "PARTY", "party"
	end
	if button == "LeftButton" and IsControlKeyDown() then
		ToUseTab()
		if LockPort_UnitIDDB then
			for i, v in ipairs(LockPort_UnitIDDB) do
				if v.rName == name then
					UnitID = folg .. v.rIndex
				end
			end
			if UnitID then
				TargetUnit(UnitID)
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " : 没在队伍中")
		end
	elseif button == "LeftButton" and not IsControlKeyDown() then
		ToUseTab()
		if LockPort_UnitIDDB then
			for i, v in ipairs(LockPort_UnitIDDB) do
				if v.rName == name then
					UnitID = folg .. v.rIndex
				end
			end
			if UnitID then
				playercombat = UnitAffectingCombat("player")
				targetcombat = UnitAffectingCombat(UnitID)

				if not playercombat and not targetcombat then
					count                = count - 1
					base_message         = "正在召唤|cff00e0ff<" .. name .. ">|r"
					base_whisper_message = "正在召唤你"
					zone_message         = "到" .. GetZoneText()
					subzone_message      = " - " .. GetSubZoneText()
					shards_message       = " [剩余碎片" .. count .. "个]"
					message              = base_message
					whisper_message      = base_whisper_message

					-- Evil Twin check
					for i = 1, 16 do
						s = UnitDebuff("target", i)
						if (s) then
							if (strfind(strlower(s), strlower(eviltwin_debuff))) then
								has_eviltwin = true
							end
						end
					end

					TargetUnit(UnitID)

					if (has_eviltwin) then
						whisper_eviltwin_message =
						"Can't summon you because of Evil Twin Debuff, you need either to die or to run by yourself"
						SendChatMessage(whisper_eviltwin_message, "WHISPER", nil, name)
						DEFAULT_CHAT_FRAME:AddMessage(logo .. " : <" .. name .. "> has |cffff0000Evil Twin|r !")
						for i, v in ipairs(LockPortDB) do
							if v == name then
								SendAddonMessage(MSG_PREFIX_REMOVE, name, RorP)
								table.remove(LockPortDB, i)
							end
						end
					elseif (Check_TargetInRange()) then
						DEFAULT_CHAT_FRAME:AddMessage(logo .. " : <" .. name .. "> 召唤法阵已就绪")
						-- Remove the already summoned target
						for i, v in ipairs(LockPortDB) do
							if v == name then
								SendAddonMessage(MSG_PREFIX_REMOVE, name, RorP)
								table.remove(LockPortDB, i)
								LockPort_UpdateList()
							end
						end
					else
						-- TODO: Detect if spell is aborted/cancelled : use SpellStopCasting if sit ("You must be standing to do that")
						CastSpellByName(BS["Ritual of Summoning"])

						-- Send Raid Message
						if LockPortOptions.zone then
							if GetSubZoneText() == "" then
								message         = message .. zone_message
								whisper_message = base_whisper_message .. zone_message
							else
								message         = message .. zone_message .. subzone_message
								whisper_message = whisper_message .. zone_message .. subzone_message
							end
						end
						if LockPortOptions.shards then
							message = message .. shards_message
						end
						SendChatMessage(message.."|cffff0000 赶紧点门..|r", RorP)

						-- Send Whisper Message
						if LockPortOptions.whisper then
							SendChatMessage(whisper_message, "WHISPER", nil, name)
						end

						-- Remove the summoned target
						for i, v in ipairs(LockPortDB) do
							if v == name then
								SendAddonMessage(MSG_PREFIX_REMOVE, name, RorP)
								table.remove(LockPortDB, i)
								LockPort_UpdateList()
							end
						end
					end
				else
					DEFAULT_CHAT_FRAME:AddMessage(logo .. " : 战斗中")
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(logo .. " : <" .. tostring(name) .. "> 不在队伍中. 玩家ID: " .. tostring(UnitID))
				SendAddonMessage(MSG_PREFIX_REMOVE, name, RorP)
				LockPort_UpdateList()
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " : 没有队伍")
		end
	elseif button == "RightButton" then
		for i, v in ipairs(LockPortDB) do
			if v == name then
				SendAddonMessage(MSG_PREFIX_REMOVE, name, RorP)
				table.remove(LockPortDB, i)
				LockPort_UpdateList()
			end
		end
	end
	LockPort_UpdateList()
end

function LockPort_UpdateList()
	LockPort_BrowseDB = {}
	--only Update and show if Player is Warlock
	if (PlayerClass == "WARLOCK") then
		--get raid member data
		local raidnum = GetNumRaidMembers()
		local partynum = GetNumPartyMembers()
		--团队列表
		if (raidnum > 0) then
			for raidmember = 1, raidnum do
				local rName, rRank, rSubgroup, rLevel, rClass = GetRaidRosterInfo(raidmember)
				--check raid data for LockPort data
				for i, v in ipairs(LockPortDB) do
					--if player is found fill BrowseDB
					if v == rName then
						LockPort_BrowseDB[i] = {}
						LockPort_BrowseDB[i].rName = rName
						LockPort_BrowseDB[i].rClass = rClass
						LockPort_BrowseDB[i].rIndex = i
						if rClass == "Warlock" or rClass == "术士" or  rName == "Bennylava" then--20240623
							LockPort_BrowseDB[i].rVIP = true
						else
							LockPort_BrowseDB[i].rVIP = false
						end
					end
				end
			end

			--sort warlocks first
			table.sort(LockPort_BrowseDB, function(a, b) return tostring(a.rVIP) > tostring(b.rVIP) end)
		end
		--小队列表
		if (partynum > 0) then
			for i = 1, partynum do
				--local rName, rRank, rSubgroup, rLevel, rClass = GetRaidRosterInfo(partymember)
				local unit, pclass, pname
				unit = "party" .. i
				_, pclass = UnitClass(unit)
				pname = UnitName(unit)
				--check raid data for LockPort data
				for i, v in ipairs(LockPortDB) do
					--if player is found fill BrowseDB
					if v == pname then
						LockPort_BrowseDB[i] = {}
						LockPort_BrowseDB[i].rName = pname
						LockPort_BrowseDB[i].rClass = pclass
						LockPort_BrowseDB[i].rIndex = i
						if pclass == "WARLOCK" or pname == "Bennylava" then
							LockPort_BrowseDB[i].rVIP = true
						else
							LockPort_BrowseDB[i].rVIP = false
						end
					end
				end
			end

			--sort warlocks first
			table.sort(LockPort_BrowseDB, function(a, b) return tostring(a.rVIP) > tostring(b.rVIP) end)
		end
		for i = 1, 10 do
			if LockPort_BrowseDB[i] then
				getglobal("LockPort_NameList" .. i .. "TextName"):SetText(LockPort_BrowseDB[i].rName)
				local class = Classtoen[LockPort_BrowseDB[i].rClass] --20240623
				local r,g,b = ACE_BC:GetColor(class)--20240623
				getglobal("LockPort_NameList" .. i .. "TextName"):SetTextColor(r,g,b, 1)
				getglobal("LockPort_NameList" .. i):Show()
			else
				getglobal("LockPort_NameList" .. i):Hide()
			end
		end

		if not LockPortDB[1] then
			if LockPort_RequestFrame:IsVisible() then
				LockPort_RequestFrame:Hide()
			end
		else
			ShowUIPanel(LockPort_RequestFrame, 1)
		end
	end
end

--Slash Handler
function LockPort_SlashCommand(msg)
	if msg == "help" then
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " 说明:")
		DEFAULT_CHAT_FRAME:AddMessage("/lockport { 帮助 | 显示 | 地区 | 密语 | 碎片 | 设置 | 声音 }")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9help|r: 打印帮助信息")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9show|r: 需召唤名单")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9zone|r: 切换区域信息")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9whisper|r: 切换的用法 /w")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9shards|r: 更新碎片数")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9settings|r: 显示设置窗口")
		DEFAULT_CHAT_FRAME:AddMessage(" - |cff9482c9sound|r: 根据召唤请求切换声音")
		DEFAULT_CHAT_FRAME:AddMessage("鼠标左键拖动框体移动")
	elseif msg == "show" then
		for i, v in ipairs(LockPortDB) do
			DEFAULT_CHAT_FRAME:AddMessage(tostring(v))
		end
	elseif msg == "zone" then
		if LockPortOptions["zone"] == true then
			LockPortOptions["zone"] = false
			ZoneCheckButton:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 位置： |cffff0000禁用|r")
		elseif LockPortOptions["zone"] == false then
			LockPortOptions["zone"] = true
			ZoneCheckButton:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 位置： |cff00ff00启用|r")
		end
	elseif msg == "whisper" then
		if LockPortOptions["whisper"] == true then
			LockPortOptions["whisper"] = false
			WhisperCheckButton:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - whisper: |cffff0000禁用|r")
		elseif LockPortOptions["whisper"] == false then
			LockPortOptions["whisper"] = true
			WhisperCheckButton:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - whisper: |cff00ff00启用|r")
		end
	elseif msg == "shards" then
		if LockPortOptions["shards"] == true then
			LockPortOptions["shards"] = false
			ShardsCheckButton:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 碎片： |cffff0000禁用|r")
		elseif LockPortOptions["shards"] == false then
			LockPortOptions["shards"] = true
			ShardsCheckButton:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 碎片： |cff00ff00启用|r")
		end
	elseif msg == "sound" then
		if LockPortOptions["sound"] == true then
			LockPortOptions["sound"] = false
			SoundCheckButton:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 声音： |cffff0000禁用|r")
		elseif LockPortOptions["sound"] == false then
			LockPortOptions["sound"] = true
			SoundCheckButton:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 声音： |cff00ff00启用|r")
		end
	elseif msg == "settings" then
		if LockPort_SettingsFrame:IsVisible() then
			LockPort_SettingsFrame:Hide()
		else
			LockPort_SettingsFrame:Show()
		end
	else
		if LockPort_RequestFrame:IsVisible() then
			LockPort_RequestFrame:Hide()
		else
			LockPort_UpdateList()
			ShowUIPanel(LockPort_RequestFrame, 1)
		end
	end
end

--class color
function LockPort_GetClassColour(class)
	if (class) then
		local color = RAID_CLASS_COLORS[class]
		if (color) then
			return color
		end
	end
	return { r = 0.5, g = 0.5, b = 1 }
end

--raid member
function LockPort_GetRaidMembers()
	local raidnum = GetNumRaidMembers()
	if (raidnum > 0) then
		LockPort_UnitIDDB = {}
		for i = 1, raidnum do
			local rName, rRank, rSubgroup, rLevel, rClass = GetRaidRosterInfo(i)
			LockPort_UnitIDDB[i] = {}
			if (not rName) then
				rName = "unknown" .. i
			end
			LockPort_UnitIDDB[i].rName  = rName
			LockPort_UnitIDDB[i].rClass = rClass
			LockPort_UnitIDDB[i].rIndex = i
		end
	end
end

function LockPort_GetPartyMembers()
	local partynum = GetNumPartyMembers()
	if partynum > 0 then
		LockPort_UnitIDDB = {}
		for i = 1, partynum do
			--local rName, rRank, rSubgroup, rLevel, rClass = GetRaidRosterInfo(partymember)
			local unit, pClass, pName
			unit = "party" .. i
			_, pClass = UnitClass(unit)
			pName = UnitName(unit)
			--check raid data for LockPort data
			LockPort_UnitIDDB[i] = {}
			if (not pName) then
				pName = "unknown" .. i
			end
			LockPort_UnitIDDB[i].rName  = pName
			LockPort_UnitIDDB[i].rClass = pClass
			LockPort_UnitIDDB[i].rIndex = i
		end
	end
end

-- Checks if the target is in range (28 yards)
function Check_TargetInRange()
	if not (GetUnitName("target") == nil) then
		local t = UnitName("target")
		if (CheckInteractDistance("target", 4)) then
			return true
		else
			return false
		end
	end
end

-- Settings Window
function LockPort_Settings_Toggle()
	if LockPort_SettingsFrame:IsVisible() then
		LockPort_SettingsFrame:Hide()
	else
		LockPort_SettingsFrame:Show()
	end
end

function WhisperCheckButton_OnClick()
	if WhisperCheckButton:GetChecked() then
		LockPortOptions["whisper"] = true
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 密语: |cff00ff00启用|r")
	elseif not WhisperCheckButton:GetChecked() then
		LockPortOptions["whisper"] = false
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 密语: |cffff0000禁用|r")
	end
end

function ZoneCheckButton_OnClick()
	if ZoneCheckButton:GetChecked() then
		LockPortOptions["zone"] = true
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 位置： |cff00ff00启用|r")
	elseif not ZoneCheckButton:GetChecked() then
		LockPortOptions["zone"] = false
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 位置： |cffff0000禁用|r")
	end
end

function ShardsCheckButton_OnClick()
	if ShardsCheckButton:GetChecked() then
		LockPortOptions["shards"] = true
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 碎片： |cff00ff00启用|r")
	elseif not ShardsCheckButton:GetChecked() then
		LockPortOptions["shards"] = false
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 碎片： |cffff0000禁用|r")
	end
end

function SoundCheckButton_OnClick()
	if SoundCheckButton:GetChecked() then
		LockPortOptions["sound"] = true
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 声音： |cff00ff00启用|r")
	elseif not SoundCheckButton:GetChecked() then
		LockPortOptions["sound"] = false
		DEFAULT_CHAT_FRAME:AddMessage(logo .. " - 声音： |cffff0000禁用|r")
	end
end

