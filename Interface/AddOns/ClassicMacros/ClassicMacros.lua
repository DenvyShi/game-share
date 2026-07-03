SLASH_CASTRANDOM1 = "/castrandom"
SLASH_STOPCASTING1 = "/stopcasting"

SLASH_CANCELAURA1 = "/cancelaura"

SLASH_STARTATTACK1 = "/startattack"
SLASH_STOPATTACK1 = "/stopattack"

SLASH_AUTOSHOOTATTACK1 = "/shootattack"

SLASH_PETAGGRESSIVE1 = "/petaggressive"
SLASH_PETPASSIVE1 = "/petpassive"
SLASH_PETDEFENSIVE1 = "/petdefensive"
SLASH_PETATTACK1 = "/petattack"
SLASH_PETFOLLOW1 = "/petfollow"
SLASH_PETSTAY1 = "/petstay"

SLASH_CLEARTARGET1 = "/cleartarget"
SLASH_LASTTARGET1 = "/lasttarget"

SLASH_EQUIPOFF1 = "/equipoff"

local scantip = CreateFrame("GameTooltip", "scantip", nil, "GameTooltipTemplate")

--检查24#动作条是否有攻击按钮
local function Check24SoltSpell(SoltId)
	scantip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scantip:SetAction(SoltId)
	local SoltSpellName = scantipTextLeft1:GetText()
	if GetActionText(SoltId) or SoltSpellName ~= ATTACK then
		return true
	else
		return false
	end
end

function StartAttack(SoltId)
	if not SoltId then SoltId = 24 end
	local noattacktexture = Check24SoltSpell(SoltId)
	local id = GetSpellIndex(ATTACK)

	if not UnitExists("target") or UnitIsDead("target") then
		TargetNearestEnemy()
	elseif not UnitCanAttack("player", "target") then
		ClearTarget()
	end

	if noattacktexture then
		PickupSpell(id, BOOKTYPE_SPELL)
		PlaceAction(SoltId)
		ClearCursor()
	else
		if IsCurrentAction(SoltId) == nil then
			UseAction(SoltId)
		end
	end
end

function StopAttack(SoltId)
	if not SoltId then SoltId = 24 end
	local noattacktexture = Check24SoltSpell(SoltId)
	local id = GetSpellIndex(ATTACK)
	
	if noattacktexture then
		PickupSpell(id, BOOKTYPE_SPELL)
		PlaceAction(SoltId)
		ClearCursor()
	else
		if IsCurrentAction(SoltId) == 1 then
			AttackTarget()
		end
	end
end

--检查23#动作条是否有自动射击按钮
local function Check23SoltSpell(SoltId)
	scantip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scantip:SetAction(SoltId)
	local SoltSpellName = scantipTextLeft1:GetText()
	if GetActionText(SoltId) or SoltSpellName ~= "自动射击" then
		return true
	else
		return false
	end
end

function AutoShootAttack(SoltId)
	if not SoltId then SoltId = 23 end
	local noshoottexture = Check23SoltSpell(SoltId)
	local id = GetSpellIndex("自动射击")
	
	if noshoottexture then
		PickupSpell(id, BOOKTYPE_SPELL)
		PlaceAction(SoltId)
		ClearCursor()
	else
		if IsActionInRange(SoltId) == 1 then
			if IsAutoRepeatAction(SoltId) == nil then
				UseAction(SoltId)
			end
		else
			SlashCmdList.STARTATTACK(msg, editbox)
		end
	end
end

local function strsplit(pString, pPattern)
	local Table = {}
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = strfind(pString, fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		last_end = e+1
		s, e, cap = strfind(pString, fpat, last_end)
	end
	if last_end <= strlen(pString) then
		cap = strsub(pString, last_end)
		table.insert(Table, cap)
	end
	return Table
end

function TrimSpaces(str)
	if ( str ) then
		return gsub(str,"^%s*(.-)%s*$","%1");
	end
end

function SlashCmdList.CASTRANDOM(msg, editbox)
	if msg == "" then
		return
	end
	local tbl = strsplit(msg, ",")
	local spell = tbl[math.random(1,getn(tbl))]
	while strsub(spell,1,1) == " " do
		spell = strsub(spell,2)
	end
	while strsub(spell,strlen(spell)) == " " do
		spell = strsub(spell, 1, (strlen(spell)-1))
	end
	CastSpellByName(spell)
end

function SlashCmdList.STOPCASTING(msg, editbox)
	SpellStopCasting()
end

function SlashCmdList.CANCELAURA(msg, editbox)
   	local buff = strlower(msg)
   	for i=0, 32 do
   		scantip:SetOwner(UIParent, "ANCHOR_NONE")
   		scantip:SetPlayerBuff(i)
   		local name = scantipTextLeft1:GetText()
   		if not name then break end
   		if strfind(strlower(name), buff) then
   			CancelPlayerBuff(i)
   		end
   		scantip:Hide()
   	end
end

function SlashCmdList.STARTATTACK(msg, editbox)
	StartAttack(24)
end

function SlashCmdList.STOPATTACK(msg, editbox)
	StopAttack(24)
end

function SlashCmdList.AUTOSHOOTATTACK(msg, editbox)
	AutoShootAttack(23)
end

function SlashCmdList.PETAGGRESSIVE(msg, editbox)
	PetAggressiveMode()
end

function SlashCmdList.PETPASSIVE(msg, editbox)
	PetPassiveMode()
end

function SlashCmdList.PETDEFENSIVE(msg, editbox)
	PetDefensiveMode()
end

function SlashCmdList.PETATTACK(msg, editbox)
	PetAttack()
end

function SlashCmdList.PETFOLLOW(msg, editbox)
	PetFollow()
end

function SlashCmdList.PETSTAY(msg, editbox)
	PetWait()
end

function SlashCmdList.CLEARTARGET(msg, editbox)
	ClearTarget()
end

function SlashCmdList.LASTTARGET(msg, editbox)
	TargetLastTarget()
end

function SlashCmdList.EQUIPOFF(msg)
	local bag, slot = FindItemInfo(TrimSpaces(msg))
	if bag and slot then
		PickupContainerItem(bag, slot)
		PickupInventoryItem(17)
	end
end

SLASH_CAST1 = "/cast"
SLASH_CAST2 = "/spell"
SLASH_CAST3 = "/施放"

if ChatFrameEditBox._AddHistoryLine then
	local userinput
	ChatFrameEditBox._AddHistoryLine = ChatFrameEditBox.AddHistoryLine
	ChatFrameEditBox.AddHistoryLine = function(self, text)
	  if not userinput and text and string.find(text, "^/run(.+)") then return end
	  if not userinput and string.find(text, "^/script(.+)") then return end
	  if not userinput and string.find(text, "^/cast(.+)") then return end
	  ChatFrameEditBox._AddHistoryLine(self, text)
	end

	local OnEnter = ChatFrameEditBox:GetScript("OnEnterPressed")
	ChatFrameEditBox:SetScript("OnEnterPressed", function(a1,a2,a3,a4)
	  userinput = true
	  OnEnter(a1,a2,a3,a4)
	  userinput = nil
	end)
end