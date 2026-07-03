--参考LoseControl
local spellIds = {
	-- 德鲁伊
	["休眠"] = true,
	["星火昏迷"] = true,
	["纠缠根须"] = true,
	["重击"] = true,
	["血袭"] = true,
	["野性冲锋效果"] = true,
	-- 猎人
	["胁迫"] = true,
	["恐吓野兽"] = true,
	["驱散射击"] = true,
	["强化震荡射击"] = true,
	["震荡射击"] = true,
	["冰冻陷阱效果"] = true,
	["冰冻陷阱"] = true,
	["冰霜陷阱光环"] = true,
	["冰霜陷阱"] = true,
	["诱捕"] = true,
	["翼龙钉刺"] = true,
	["反击"] = true,
	["强化摔绊"] = true,
	["摔绊"] = true,
	["野猪冲撞"] = true,
	-- 法师
	["变形术"] = true,
	["变形术：龟"] = true,
	["变形术：猪"] = true,
	["变形术：奶牛"] = true,
	["变形术：鸡"] = true,
	["法术反制 - 沉默"] = true,
	["冲击"] = true,
	["冲击波"] = true,
	["霜寒刺骨"] = true,
	["冰霜新星"] = true,
	["寒冰箭"] = true,
	["冰锥术"] = true,
	["冰冻"] = true,
	-- 圣骑士
	["制裁之锤"] = true,
	["忏悔"] = true,
	-- 牧师
	["精神控制"] = true,
	["心灵尖啸"] = true,
	["昏阙"] = true,
	["沉默"] = true,
	["精神鞭笞"] = true,
	-- 盗贼
	["致盲"] = true,
	["偷袭"] = true,
	["凿击"] = true,
	["肾击"] = true,
	["闷棍"] = true,
	["脚踢 - 沉默"] = true,
	["致残毒药"] = true,
	-- 术士
	["死亡缠绕"] = true,
	["恐惧术"] = true,
	["恐惧嚎叫"] = true,
	["疲劳诅咒"] = true,
	["火焰冲撞"] = true,
	["清算"] = true,
	["诱惑"] = true,
	["法术封锁"] = true,
	["地狱火效果"] = true,
	["地狱火"] = true,
	["残废术"] = true,
	-- 战士
	["冲锋击昏"] = true,
	["断筋"] = true,
	["拦截昏迷"] = true,
	["破胆怒吼"] = true,
	["复仇昏迷"] = true,
	["震荡猛击"] = true,
	["刺耳怒吼"] = true,
	["盾击 - 沉默"] = true,
	-- 萨满
	["冰封武器"] = true,
	["冰霜震击"] = true,
	["地缚术"] = true,
	["地缚图腾"] = true,
	-- 其他控制技能，请自行添加
	["战争践踏"] = true,
	["潮汐咒符"] = true,
	["锤击昏迷效果"] = true,
	["昏迷"] = true,
	["侏儒洗脑帽"] = true,
	["无畏冲锋"] = true,
	["催眠术"] = true,
	["冰冻术"] = true,
	["寒冷"] = true,
	["冲锋"] = true,
	["冰爆术"] = true,
	["蹬踏"] = true,
	["鞭笞"] = true,
	["水晶凝视"] = true,
	["蛛网"] = true,
	["恐吓"] = true,
	["恐吓尖啸"] = true,
	["投网"] = true,
	["钩网"] = true,
	["裂筋"] = true,
	["扫荡"] = true,
	["包围之风"] = true,
	["音素爆破"] = true,
	["减速毒药"] = true,
	["覆体之网"] = true,
	["包围之网"] = true,
	["蛛网爆炸"] = true,
	["盾牌猛击"] = true,
	["烟雾弹"] = true,
	["毁灭"] = true,
	["飞扑"] = true,
	["击倒"] = true,
}

-- 黄色圆形边框
local En_bg = CreateFrame("Frame", nil, PlayerFrame)
En_bg.circle = En_bg:CreateTexture(nil, "OVERLAY")
En_bg.circle:SetPoint('TOPLEFT', PlayerPortrait, 'TOPLEFT', 3.5, -4.5)
En_bg.circle:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'BOTTOMRIGHT', -3.5, 2.5)
En_bg.circle:SetTexture([[Interface\AddOns\En_UnitFrames\media\En_LoseControl.tga]])
En_bg.circle:SetVertexColor(1, 1, 0)

--计时
local En_DebuffCooldownText = CreateFrame("Frame")
En_DebuffCooldownText:SetFrameStrata("MEDIUM")
En_DebuffCooldownText.text = En_DebuffCooldownText:CreateFontString(nil, "ARTWORK")
En_DebuffCooldownText.text:SetPoint("CENTER", PlayerPortrait, 0, 0)
En_DebuffCooldownText.text:SetFont(STANDARD_TEXT_FONT, 50, "OUTLINE")

function En_LCPlayer_OnLoad()
	--隐藏玩家头像伤害数字
	PetHitIndicator:ClearAllPoints()
	PlayerHitIndicator:ClearAllPoints()

	this:RegisterEvent("UNIT_AURA")
	this:RegisterEvent("PLAYER_AURAS_CHANGED")

	-- debuff texture
	this.texture = En_bg:CreateTexture(this, "BACKGROUND")
	this.texture:SetPoint('TOPLEFT', PlayerPortrait, 'TOPLEFT', 7, -10)
	this.texture:SetPoint('BOTTOMRIGHT', PlayerPortrait, 'BOTTOMRIGHT', -7.5, 4.5)	
	this.texture:SetTexCoord(.12, .88, .12, .88)
end

--奇数红色，偶数黄色
local function WaringTime(v)
	if (v < 4) then
		if v - math.floor(v/2)*2 == 0 then
			return 1, 1, 0
		else
			return 1, 0, 0
		end
	else
		return 1, 1, 0
	end
end

local spellFound, En_LoseControl_DebuffTexture, En_Debuff_Duration

--是否显示
function En_LCPlayer_OnEvent()
	spellFound = false
	for i=1, 16 do
		local texture = UnitDebuff("player", i)
		En_LCTooltip:ClearLines()
		En_LCTooltip:SetUnitDebuff("player", i)
		local buffName = En_LCTooltipTextLeft1:GetText()
		
		if spellIds[buffName] then
			spellFound = true
			for j=0, 31 do
				local buffTexture = GetPlayerBuffTexture(j)
				if texture == buffTexture then
					this.texture:SetTexture(buffTexture)
					En_Debuff_Duration = j
					this:Show()
					En_bg.circle:Show()
					En_DebuffCooldownText:Show()
				end
			end
		end
		if spellFound == false then
			this:Hide()
			this.texture:SetTexture()
			En_bg.circle:Hide()
			En_DebuffCooldownText:Hide()
		end
	end
end

--刷新DEBUFF时间
En_DebuffCooldownText:SetScript("OnUpdate", function()
	local En_LoseControl_Time = tonumber(GetPlayerBuffTimeLeft(En_Debuff_Duration))
					
	if spellFound and En_LoseControl_Time > 0 then
		local r, g, b = WaringTime(math.floor(En_LoseControl_Time))
		En_DebuffCooldownText.text:SetText(math.modf(En_LoseControl_Time + 1))
		En_DebuffCooldownText.text:SetTextColor(r, g, b)
	end
end)