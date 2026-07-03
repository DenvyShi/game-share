--队友显示16Buff/10Debuff，目标显示16Buff/16Debuff

--目标的Buffs/Debuffs
MAX_TARGET_BUFFS = 16
local buff

for i = 6, 16 do
	buff = CreateFrame("Button", "TargetFrameBuff"..i, TargetFrame, "TargetBuffButtonTemplate")
	buff:SetID(i)
	if i == 6 then
		buff:SetPoint("TOP", "TargetFrameBuff1", "BOTTOM", 0, -3)
	elseif i == 11 then
		buff:SetPoint("TOP", "TargetFrameBuff6", "BOTTOM", 0, -3)
	else
		buff:SetPoint("LEFT", "TargetFrameBuff"..i-1, "RIGHT", 3, 0)
	end
end

local ORG_TargetDebuffButton_Update = TargetDebuffButton_Update
function TargetDebuffButton_Update()
	ORG_TargetDebuffButton_Update()
	for i = 1, 16 do
		buff = getglobal("TargetFrameBuff"..i)
		buff:SetWidth(21)
		buff:SetHeight(21)
	end
	if not UnitIsFriend("player", "target") then return end
	if TargetFrameBuff11:IsShown() then
		TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff11", "BOTTOMLEFT", 0, -2)
	elseif TargetFrameBuff6:IsShown() then
		TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff6", "BOTTOMLEFT", 0, -2)
	end
end

--目标的目标debuff大小、位置
for i = 1,4 do getglobal("TargetofTargetFrameDebuff"..i):SetScale(1.5) end
TargetofTargetFrameDebuff1:SetPoint("TOPLEFT", "TargetofTargetFrame", "BOTTOMRIGHT", 2, 30);

--小队的Buffs/Debuffs
for i = 1, 4 do
	local str = "PartyMemberFrame"..i
	-- buff
	for j = 1, 16 do
		buff = CreateFrame("Button", str.."Buff"..j, getglobal(str), "TargetBuffButtonTemplate")
		buff:SetID(j)
		buff:SetWidth(15)
		buff:SetHeight(15)
		buff:SetScript("OnEnter",function()
			GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 15, -25)
			GameTooltip:SetUnitBuff("party"..this:GetParent():GetID(), this:GetID())
		end)
		if j == 1 then
			buff:SetPoint("TOPLEFT", str, "TOPLEFT", 50, -32)
		else
			buff:SetPoint("LEFT", str.."Buff"..j-1, "RIGHT", 2, 0)
		end
	end
	-- debuff
	local debuffbutton1 = getglobal(str.."Debuff1")
	debuffbutton1:ClearAllPoints()
	debuffbutton1:SetPoint("LEFT", str, "RIGHT", -5, 7)
	for j = 5, 10 do
		buff = CreateFrame("Button", str.."Debuff"..j, getglobal(str), "PartyBuffButtonTemplate")
		buff:SetPoint("LEFT", str.."Debuff"..j-1, "RIGHT", 2, 0)
	end
end

local ORG_PartyMemberBuffTooltip_Update = PartyMemberBuffTooltip_Update
function PartyMemberBuffTooltip_Update(isPet)
	if isPet then
		ORG_PartyMemberBuffTooltip_Update(isPet)
	end
end

local ORG_RefreshBuffs = RefreshBuffs
function RefreshBuffs(button, showBuffs, unit)
	local tmp = MAX_PARTY_DEBUFFS
	if string.find(unit, "party") and string.len(unit) == 6 then
		MAX_PARTY_DEBUFFS = 10
		for i = 1, 16 do
			buff = UnitBuff(unit, i)
			if buff then
				getglobal(button:GetName().."Buff"..i.."Icon"):SetTexture(buff)
				getglobal(button:GetName().."Buff"..i):Show()
			else
				getglobal(button:GetName().."Buff"..i):Hide()
			end		
		end
	end
	ORG_RefreshBuffs(button, showBuffs, unit)
	MAX_PARTY_DEBUFFS = tmp
end

--宠物
function PartyMemberBuffTooltip_Update(isPet)
	--请勿删除
end

function PetFrame_RefreshBuffs()
	local buffButtonName;
	local buffImage;
	local idx;

	idx = 1;
	for i=1, 16 do
		if ( idx <= 16 ) then
			buffImage = UnitBuff("pet", i);
			if ( buffImage ) then
				buffButtonName = "EUF_PetBuffFrameBuff"..idx;
				getglobal(buffButtonName.."Icon"):SetTexture(buffImage);
				getglobal(buffButtonName):SetID(i);
				getglobal(buffButtonName):Show();
				idx = idx + 1;
			end
		end
	end
	for i=idx, 16 do
		getglobal("EUF_PetBuffFrameBuff"..i):Hide();
	end

	idx = 1;
	for i=1, 16 do
		if ( idx <= 16 ) then
			buffImage = UnitDebuff("pet", i);
			if ( buffImage ) then
				buffButtonName = "EUF_PetBuffFrameDeBuff"..idx;
				getglobal(buffButtonName.."Icon"):SetTexture(buffImage);
				getglobal(buffButtonName):SetID(i);
				getglobal(buffButtonName):Show();
				idx = idx + 1;
			end
		end
	end
	for i=idx, 16 do
		getglobal("EUF_PetBuffFrameDeBuff"..i):Hide();
	end

end

for i = 1, 16 do
	buff = CreateFrame("Button", "PetFrameBuff"..i, PetFrame, "TargetBuffButtonTemplate")
	buff:SetID(i)
	buff:SetWidth(15)
	buff:SetHeight(15)
	buff:SetScript("OnEnter",function()
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
		GameTooltip:SetUnitBuff("pet", this:GetID())
	end)
	buff:SetScript("OnLeave",function()
		GameTooltip:Hide()
	end)
	
	if i == 1 then
		buff:SetPoint("TOPLEFT", PetFrame, "TOPLEFT", 48, -42)
	else
		buff:SetPoint("LEFT", "PetFrameBuff"..i-1, "RIGHT", 2, 0)
	end
end