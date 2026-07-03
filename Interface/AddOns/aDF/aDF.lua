--########### armor and Debuff Frame
--########### By Atreyyo @ Vanillagaming.org

aDF = CreateFrame('Button', "aDF", UIParent); -- Event Frame
aDF:Hide()

aDF.Options = CreateFrame("Frame",nil,UIParent) -- Options frame

--register events 
aDF:RegisterEvent("ADDON_LOADED")
aDF:RegisterEvent("UNIT_AURA")
aDF:RegisterEvent("PLAYER_TARGET_CHANGED")

-- tables 
aDF_frames = {} -- we will put all debuff frames in here
aDF_guiframes = {} -- we wil put all gui frames here
gui_Options = gui_Options or {} -- checklist options
gui_Optionsxy = gui_Optionsxy or 1
gui_chantbl = {
   "None",
   "Say",
   "Yell",
   "Party",
   "Raid",
   "Raid_Warning"
 }

local last_target_change_time = GetTime()

-- translation table for debuff check on target

aDFSpells = {
	["Sunder Armor"] = "破甲攻击",
	["Crusader Strike"] = "十字军打击",
	["Armor Shatter"] = "护甲粉碎",
	["Faerie Fire (Feral)"] = "精灵之火（野性）",
	["Faerie Fire"] = "精灵之火",
	["Nightfall"] = "法术易伤",
	["Flame Buffet"] = "烈焰打击",
	["Scorch"] = "痛苦诅咒",
	["Ignite"] = "点燃",
	["Curse of Recklessness"] = "鲁莽诅咒",
	["Curse of the Elements"] = "元素诅咒",
	["Curse of Shadows"] = "暗影诅咒",
	["Shadow Bolt"] = "暗影易伤",
	["Shadow Weaving"] = "暗影之波",
	["Expose Armor"] = "破甲",
}
	--["Vampiric Embrace"] = "Vampiric Embrace",
	--["Crystal Yield"] = "Crystal Yield",
	--["Mage T3 6/9 Bonus"] = "Elemental Vulnerability",
-- table with names and textures 

aDFDebuffs = {
	["Sunder Armor"] = "Interface\\Icons\\Ability_Warrior_Sunder",
	["Crusader Strike"] = "Interface\\Icons\\Spell_Holy_crusaderstrike",
	["Armor Shatter"] = "Interface\\Icons\\INV_Axe_12",
	["Faerie Fire (Feral)"] = "Interface\\Icons\\Spell_Nature_FaerieFire",
	["Faerie Fire"] = "Interface\\Icons\\Spell_Nature_FaerieFire",
	["Nightfall"] = "Interface\\Icons\\Spell_Holy_ElunesGrace",
	["Flame Buffet"] = "Interface\\Icons\\Spell_Fire_Fireball",
	["Scorch"] = "Interface\\Icons\\Spell_Fire_SoulBurn",
	["Ignite"] = "Interface\\Icons\\Spell_Fire_Incinerate",
	["Curse of Recklessness"] = "Interface\\Icons\\Spell_Shadow_UnholyStrength",
	["Curse of the Elements"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	["Curse of Shadows"] = "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde",
	["Shadow Bolt"] = "Interface\\Icons\\Spell_Shadow_BlackPlague",
	["Shadow Weaving"] = "Interface\\Icons\\Spell_Shadow_ShadowBolt",
	["Expose Armor"] = "Interface\\Icons\\Ability_Warrior_Riposte",
}
	--["Vampiric Embrace"] = "Interface\\Icons\\Spell_Shadow_UnsummonBuilding",
	--["Crystal Yield"] = "Interface\\Icons\\INV_Misc_Gem_Amethyst_01",
	--["Elemental Vulnerability"] = "Interface\\Icons\\Spell_Holy_Dizzy",

aDFArmorVals = {
--战士破甲
	[450]  = "战士1破",    -- r5 x1, or r1 x5
	[900]  = "战士2破",    -- r5 x2, or r2 x5
	[1350] = "战士3破",    -- r5 x3, or r3 x5
	[1800] = "战士4破",    -- r5 x4, or r4 x5
	[2250] = "战士5破", -- r5 x5
--盗贼破甲
	[90]   = "低级盗贼破甲", -- r1 x1
	[180]  = "低级盗贼破甲",    -- r2 x1, or r1 x2
	[270]  = "低级盗贼破甲",    -- r3 x1, or r1 x3
	[540]  = "低级盗贼破甲",    -- r3 x2, or r2 x3
	[810]  = "低级盗贼破甲", -- r3 x3
	[360]  = "低级盗贼破甲",    -- r4 x1, or r1 x4 or r2 x2
	[720]  = "低级盗贼破甲",    -- r4 x2, or r2 x4
	[1080] = "低级盗贼破甲",    -- r4 x3, or r3 x4
	[1440] = "低级盗贼破甲", -- r4 x4
    [340]  = "盗贼破甲（1星）",
	[680]  = "盗贼破甲（2星）",
	[1020]  = "盗贼破甲（3星）",
	[1360]  = "盗贼破甲（4星）",
	[1700]  = "盗贼破甲（5星）",
	[510]  = "强化盗贼破甲（1星）",
	[1020] = "强化盗贼破甲（2星）",
	[1530] = "强化盗贼破甲（3星）",
	[2040] = "强化盗贼破甲（4星）",
	[2550] = "强化盗贼破甲（5星）",
--其他	
	[505]  = "精灵之火",
	[175]  = "1级精灵之火",
	[285]  = "2级精灵之火",
	[395]  = "3级精灵之火",
	[640]  = "鲁莽诅咒",
	[140]  = "1级鲁莽诅咒",
	[290]  = "2级鲁莽诅咒",
	[465]  = "3级鲁莽诅咒",
	[100]  = "歼灭1层", 
	[200]  = "歼灭2层", 
	[300]  = "歼灭3层", 
	[50]   = "圣炎火炬", 
	[163]  = "开膛手破甲", --Sunelegy：暴风城地牢掉落的匕首
	[300]  = "黑铁斩碎者破甲", --Sunelegy：蓝色破甲斧
}

function aDF_Default()
	if guiOptions == nil then
		guiOptions = {}
		for k,v in pairs(aDFDebuffs) do
			if guiOptions[k] == nil then
				guiOptions[k] = 1
			end
		end
	end
end

-- the main frame

function aDF:Init()
	aDF.Drag = { }
	function aDF.Drag:StartMoving()
		if ( IsShiftKeyDown() ) then
			this:StartMoving()
		end
	end
	
	function aDF.Drag:StopMovingOrSizing()
		this:StopMovingOrSizing()
		local x, y = this:GetCenter()
		local ux, uy = UIParent:GetCenter()
		aDF_x, aDF_y = floor(x - ux + 0.5), floor(y - uy + 0.5)
	end
	
	local backdrop = {
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			tile="false",
			tileSize="8",
			edgeSize="8",
			insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}
	
	self:SetFrameStrata("BACKGROUND")
	self:SetWidth((24+gui_Optionsxy)*7) -- Set these to whatever height/width is needed 
	self:SetHeight(24+gui_Optionsxy) -- for your Texture
	self:SetPoint("CENTER",aDF_x,aDF_y)
	self:SetMovable(1)
	self:EnableMouse(1)
	self:RegisterForDrag("LeftButton")
	self:SetBackdrop(backdrop) --border around the frame
	self:SetBackdropColor(0,0,0,1)
	self:SetScript("OnDragStart", aDF.Drag.StartMoving)
	self:SetScript("OnDragStop", aDF.Drag.StopMovingOrSizing)
	self:SetScript("OnMouseDown", function()
		if (arg1 == "RightButton") then
			if aDF_target ~= nil then
				if UnitAffectingCombat(aDF_target) and UnitCanAttack("player", aDF_target) then	
					SendChatMessage(UnitName(aDF_target).."拥有".. UnitResistance(aDF_target,0).."护甲", gui_chan) 
				end
			end
		end
	end)
	
	-- Armor text
	self.armor = self:CreateFontString(nil, "OVERLAY")
    self.armor:SetPoint("CENTER", self, "CENTER", 0, 0)
    self.armor:SetFont("Fonts\\FRIZQT__.TTF", 12+gui_Optionsxy)
	self.armor:SetShadowOffset(2,-2)
    self.armor:SetText("aDF")

	-- Resistance text
	self.res = self:CreateFontString(nil, "OVERLAY")
    self.res:SetPoint("CENTER", self, "CENTER", 0, 20+gui_Optionsxy)
    self.res:SetFont("Fonts\\FRIZQT__.TTF", 14+gui_Optionsxy)
	self.res:SetShadowOffset(2,-2)
    self.res:SetText("Resistance")
	
	-- for the debuff check function
	aDF_tooltip = CreateFrame("GAMETOOLTIP", "buffScan")
	aDF_tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	aDF_tooltipTextL = aDF_tooltip:CreateFontString()
	aDF_tooltipTextR = aDF_tooltip:CreateFontString()
	aDF_tooltip:AddFontStrings(aDF_tooltipTextL,aDF_tooltipTextR)
	--R = tip:CreateFontString()
	--
	
	f_ =  0
	for name,texture in pairs(aDFDebuffs) do
		aDFsize = 24+gui_Optionsxy
		aDF_frames[name] = aDF_frames[name] or aDF.Create_frame(name)
		local frame = aDF_frames[name]
		frame:SetWidth(aDFsize)
		frame:SetHeight(aDFsize)
		frame:SetPoint("BOTTOMLEFT",aDFsize*f_,-aDFsize)
		frame.icon:SetTexture(texture)
		frame:SetFrameLevel(2)
		frame:Show()
		frame:SetScript("OnEnter", function() 
			GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:SetText(aDFSpells[this:GetName()], 255, 255, 0, 1, 1);
			GameTooltip:Show()
			end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnMouseDown", function()
			if (arg1 == "RightButton") then
				tdb=this:GetName()
				if aDF_target ~= nil then
					if UnitAffectingCombat(aDF_target) and UnitCanAttack("player", aDF_target) and guiOptions[tdb] ~= nil then
						if not aDF:GetDebuff(aDF_target,aDFSpells[tdb]) then
							SendChatMessage("["..tdb.."] 没有作用在 "..UnitName(aDF_target), gui_chan)
						else
							if aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) == 1 then
								s_ = "stack"
							elseif aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) > 1 then
								s_ = "stacks"
							end
							if aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) >= 1 and aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) < 5 and tdb ~= "Armor Shatter" then
								SendChatMessage(UnitName(aDF_target).." has "..aDF:GetDebuff(aDF_target,aDFSpells[tdb],1).." ["..tdb.."] "..s_, gui_chan)
							end
							if tdb == "Armor Shatter" and aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) >= 1 and aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) < 3 then
								SendChatMessage(UnitName(aDF_target).." has "..aDF:GetDebuff(aDF_target,aDFSpells[tdb],1).." ["..tdb.."] "..s_, gui_chan)
							end
						end
					end
				end
			end
		end)
		f_ = f_+1
	end
end

-- creates the debuff frames on load

function aDF.Create_frame(name)
	local frame = CreateFrame('Button', name, aDF)
	frame:SetBackdrop({ bgFile=[[Interface/Tooltips/UI-Tooltip-Background]] })
	frame:SetBackdropColor(0,0,0,1)
	frame.icon = frame:CreateTexture(nil, 'ARTWORK')
	frame.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.icon:SetPoint('TOPLEFT', 1, -1)
	frame.icon:SetPoint('BOTTOMRIGHT', -1, 1)
	frame.nr = frame:CreateFontString(nil, "OVERLAY")
	frame.nr:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.nr:SetFont("Fonts\\FRIZQT__.TTF", 16+gui_Optionsxy)
	frame.nr:SetTextColor(255, 255, 255, 1)
	frame.nr:SetShadowOffset(2,-2)
	frame.nr:SetText("1")
	--DEFAULT_CHAT_FRAME:AddMessage("----- Adding new frame")
	return frame
end

-- creates gui checkboxes

function aDF.Create_guiframe(name)
	local frame = CreateFrame("CheckButton", name, aDF.Options, "UICheckButtonTemplate")
	frame:SetFrameStrata("LOW")
	frame:SetScript("OnClick", function () 
		if frame:GetChecked() == nil then 
			guiOptions[name] = nil
		elseif frame:GetChecked() == 1 then 
			guiOptions[name] = 1 
			table.sort(guiOptions)
		end
		aDF:Sort()
		aDF:Update()
		end)
	frame:SetScript("OnEnter", function() 
		GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
		GameTooltip:SetText(aDFSpells[this:GetName()], 255, 255, 0, 1, 1);
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetChecked(guiOptions[name])
	frame.Icon = frame:CreateTexture(nil, 'ARTWORK')
	frame.Icon:SetTexture(aDFDebuffs[name])
	frame.Icon:SetWidth(25)
	frame.Icon:SetHeight(25)
	frame.Icon:SetPoint("CENTER",-30,0)
	--DEFAULT_CHAT_FRAME:AddMessage("----- Adding new gui checkbox")
	return frame
end

-- update function for the text/debuff frames

function aDF:Update()
	if aDF_target ~= nil and UnitExists(aDF_target) and not UnitIsDead(aDF_target) then
		if aDF_target == 'targettarget' and GetTime() < (last_target_change_time + 0.4) then
			-- we won't allow updates for a while to allow targettarget to catch up
			-- adfprint('target changed too soon, delaying update')
			return
		end
		local armorcurr = UnitResistance(aDF_target,0)
		--aDF.armor:SetText(UnitResistance(aDF_target,0).." ["..math.floor(((UnitResistance(aDF_target,0) / (467.5 * UnitLevel("player") + UnitResistance(aDF_target,0) - 22167.5)) * 100),1).."%]")
		local ttText = ""
		if aDF_target == "targettarget" then ttText = UnitName(aDF_target)..": " end
		aDF.armor:SetText(ttText..armorcurr)
		-- adfprint(string.format('aDF_target %s targetname %s armorcurr %s armorprev %s', aDF_target, UnitName(aDF_target), armorcurr, aDF_armorprev))
		if armorcurr > aDF_armorprev then
			local armordiff = armorcurr - aDF_armorprev
			local diffreason = ""
			if aDF_armorprev ~= 0 and aDFArmorVals[armordiff] then
				diffreason = " (" .. aDFArmorVals[armordiff] .. "   BUFF消失了)"
			end
			local msg = UnitName(aDF_target).."的护甲从: "..aDF_armorprev.." 变成为-> "..armorcurr..diffreason
			-- adfprint(msg)
			if aDF_target == 'target' and gui_chan ~= "None" then
				-- targettarget does not trigger events when it changes. this means it's hard to tell apart units with the same name, so we don't allow notifications for it
				SendChatMessage(msg, gui_chan)
			end

		end
		aDF_armorprev = armorcurr

		if gui_Options["Resistances"] == 1 then
			aDF.res:SetText("|cffFF0000FR "..UnitResistance(aDF_target,2).." |cff00FF00NR "..UnitResistance(aDF_target,3).." |cff4AE8F5FrR "..UnitResistance(aDF_target,4).." |cff800080SR "..UnitResistance(aDF_target,5))
		else
			aDF.res:SetText("")
		end
		for i,v in pairs(guiOptions) do
			if aDF:GetDebuff(aDF_target,aDFSpells[i]) then
				aDF_frames[i]["icon"]:SetAlpha(1)
				if aDF:GetDebuff(aDF_target,aDFSpells[i],1) > 1 then
					aDF_frames[i]["nr"]:SetText(aDF:GetDebuff(aDF_target,aDFSpells[i],1))
				end
			else
				aDF_frames[i]["icon"]:SetAlpha(0.3)
				aDF_frames[i]["nr"]:SetText("")
			end		
		end
	else
		aDF.armor:SetText("")
		aDF.res:SetText("")
		for i,v in pairs(guiOptions) do
			aDF_frames[i]["icon"]:SetAlpha(0.3)
			aDF_frames[i]["nr"]:SetText("")
		end
	end

	aDF:CheckSize()
	aDF:SetWidth((24+gui_Optionsxy)*guiOptionsSize)											
end

function aDF:UpdateCheck()
	if utimer == nil or (GetTime() - utimer > 0.2) then
		utimer = GetTime()
		aDF:Update()
	end
end

function aDF:CheckSize()
	guiOptionsSize = 0
	for k,v in pairs(guiOptions) do
		if guiOptionsSize < 7 then
			guiOptionsSize = guiOptionsSize + 1
		else 
			guiOptionsSize = 7
		end
	end
end						
-- Sort function to show/hide frames aswell as positioning them correctly

function aDF:Sort()
	for name,_ in pairs(aDFDebuffs) do
		if guiOptions[name] == nil then
			aDF_frames[name]:Hide()
		else
			aDF_frames[name]:Show()
		end
	end
	local aDFTempTable = {}
	for dbf,_ in pairs(guiOptions) do
		table.insert(aDFTempTable,dbf)
	end
	table.sort(aDFTempTable, function(a,b) return a<b end)
	for n, v in pairs(aDFTempTable) do
	--DEFAULT_CHAT_FRAME:AddMessage("Name: "..v)
		if n > 7 then
			y_=-((24+gui_Optionsxy)*2)
			x_=(n-1)-7
			aDF_frames[v]:SetPoint('BOTTOMLEFT',(24+gui_Optionsxy)*x_,y_)
		else
			y_=-(24+gui_Optionsxy)
			aDF_frames[v]:SetPoint('BOTTOMLEFT',(24+gui_Optionsxy)*(n-1),y_)
		end
	end
end

-- Options frame

function aDF.Options:Gui()

	aDF.Options.Drag = { }
	function aDF.Options.Drag:StartMoving()
		this:StartMoving()
	end
	
	function aDF.Options.Drag:StopMovingOrSizing()
		this:StopMovingOrSizing()
	end

	local backdrop = {
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			tile="false",
			tileSize="4",
			edgeSize="8",
			insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}
	
	self:SetFrameStrata("BACKGROUND")
	self:SetWidth(400) -- Set these to whatever height/width is needed 
	self:SetHeight(450) -- for your Texture
	self:SetPoint("CENTER",0,0)
	self:SetMovable(1)
	self:EnableMouse(1)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", aDF.Options.Drag.StartMoving)
	self:SetScript("OnDragStop", aDF.Options.Drag.StopMovingOrSizing)
	self:SetBackdrop(backdrop) --border around the frame
	self:SetBackdropColor(0,0,0,1);
	
	-- Options text
	
	self.text = self:CreateFontString(nil, "OVERLAY")
    self.text:SetPoint("CENTER", self, "CENTER", 0, 180)
    self.text:SetFont("Fonts\\FRIZQT__.TTF", 25)
	self.text:SetTextColor(255, 255, 0, 1)
	self.text:SetShadowOffset(2,-2)
    self.text:SetText("Options")
	
	-- mid line
	
	self.left = self:CreateTexture(nil, "BORDER")
	self.left:SetWidth(125)
	self.left:SetHeight(2)
	self.left:SetPoint("CENTER", -62, 160)
	self.left:SetTexture(1, 1, 0, 1)
	self.left:SetGradientAlpha("Horizontal", 0, 0, 0, 0, 102, 102, 102, 0.6)

	self.right = self:CreateTexture(nil, "BORDER")
	self.right:SetWidth(125)
	self.right:SetHeight(2)
	self.right:SetPoint("CENTER", 63, 160)
	self.right:SetTexture(1, 1, 0, 1)
	self.right:SetGradientAlpha("Horizontal", 255, 255, 0, 0.6, 0, 0, 0, 0)
	
	-- slider

	self.Slider = CreateFrame("Slider", "aDF Slider", self, 'OptionsSliderTemplate')
	self.Slider:SetWidth(200)
	self.Slider:SetHeight(20)
	self.Slider:SetPoint("CENTER", self, "CENTER", 0, 140)
	self.Slider:SetMinMaxValues(1, 10)
	self.Slider:SetValue(gui_Optionsxy)
	self.Slider:SetValueStep(1)
	getglobal(self.Slider:GetName() .. 'Low'):SetText('1')
	getglobal(self.Slider:GetName() .. 'High'):SetText('10')
	--getglobal(self.Slider:GetName() .. 'Text'):SetText('Frame size')
	self.Slider:SetScript("OnValueChanged", function() 
		gui_Optionsxy = this:GetValue()
		for _, frame in pairs(aDF_frames) do
			frame:SetWidth(24+gui_Optionsxy)
			frame:SetHeight(24+gui_Optionsxy)
			frame.nr:SetFont("Fonts\\FRIZQT__.TTF", 16+gui_Optionsxy)
		end
		aDF:SetWidth((24+gui_Optionsxy)*7)
		aDF:SetHeight(24+gui_Optionsxy)
		aDF.armor:SetFont("Fonts\\FRIZQT__.TTF", 24+gui_Optionsxy)
		aDF.res:SetFont("Fonts\\FRIZQT__.TTF", 14+gui_Optionsxy)
		aDF.res:SetPoint("CENTER", aDF, "CENTER", 0, 20+gui_Optionsxy)
		aDF:Sort()
	end)
	self.Slider:Show()
	
	-- checkboxes
	local temptable = {}
	for tempn,_ in pairs(aDFDebuffs) do
		table.insert(temptable,tempn)
	end
	table.sort(temptable, function(a,b) return a<b end)
	
	local x,y=130,-80
	for _,name in pairs(temptable) do
		y=y-35
		if y < -360 then y=-120; x=x+140 end
		--DEFAULT_CHAT_FRAME:AddMessage("Name of frame: "..name.." ypos: "..y)
		aDF_guiframes[name] = aDF_guiframes[name] or aDF.Create_guiframe(name)
		local frame = aDF_guiframes[name]
		frame:SetPoint("TOPLEFT",x,y)
	end	
	
	--raid only
	self.RaidCheckbox = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
	self.RaidCheckbox:SetPoint("BOTTOM",90,10)
	self.RaidCheckbox:SetFrameStrata("LOW")
	self.RaidCheckbox:SetScript("OnClick", function () 
		if self.RaidCheckbox:GetChecked() == nil then 
			gui_Options["Raid"] = nil
		elseif self.RaidCheckbox:GetChecked() == 1 then 
			gui_Options["Raid"] = 1 
		end
		aDF:Sort()
		aDF:TargetChanged()
		end)
	self.RaidCheckbox:SetScript("OnEnter", function() 
		GameTooltip:SetOwner(self.RaidCheckbox, "ANCHOR_RIGHT");
		GameTooltip:SetText("只在团队中显示框架", 255, 255, 0, 1, 1);
		GameTooltip:Show()
	end)
	self.RaidCheckbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self.RaidCheckbox:SetChecked(gui_Options["Raid"])
	self.RaidIcon = self.RaidCheckbox:CreateTexture(nil, 'ARTWORK')
	self.RaidIcon:SetTexture("Interface\\Icons\\Trade_Engineering")
	self.RaidIcon:SetWidth(25)
	self.RaidIcon:SetHeight(25)
	self.RaidIcon:SetPoint("CENTER",-30,0)				  

	-- drop down menu
	self.dropdown = CreateFrame('Button', 'chandropdown', self, 'UIDropDownMenuTemplate')
	self.dropdown:SetPoint("BOTTOM",-120,20)
	InitializeDropdown = function() 
		local info = {}
		for k,v in pairs(gui_chantbl) do
			info = {}
			info.text = v
			info.value = v
			info.func = function()
				UIDropDownMenu_SetSelectedValue(chandropdown, this.value)
				gui_chan = UIDropDownMenu_GetText(chandropdown)
			end
			info.checked = nil
			UIDropDownMenu_AddButton(info, 1)
			if gui_chan == nil then
				UIDropDownMenu_SetSelectedValue(chandropdown, "None")
			else
				UIDropDownMenu_SetSelectedValue(chandropdown, gui_chan)
			end
		end
	end
	UIDropDownMenu_Initialize(chandropdown, InitializeDropdown)
	
	-- done button
	
	self.dbutton = CreateFrame("Button",nil,self,"UIPanelButtonTemplate")
	self.dbutton:SetPoint("BOTTOM",-60,5)
	self.dbutton:SetFrameStrata("LOW")
	self.dbutton:SetWidth(79)
	self.dbutton:SetHeight(18)
	self.dbutton:SetText("确定")
	self.dbutton:SetScript("OnClick", function() PlaySound("igMainMenuOptionCheckBoxOn"); aDF:Sort(); aDF:Update(); aDF.Options:Hide() end)
	self:Hide()
end

-- function to check a unit for a certain debuff and/or number of stacks

function aDF:GetDebuff(name,buff,stacks)
	local a=1
	while UnitDebuff(name,a) do
		local _, s = UnitDebuff(name,a)
		aDF_tooltip:SetOwner(UIParent, "ANCHOR_NONE");
		aDF_tooltip:ClearLines()
		aDF_tooltip:SetUnitDebuff(name,a)
		local aDFtext = aDF_tooltipTextL:GetText()
		if aDFtext == buff then 
			if stacks == 1 then
				return s
			else
				return true 
			end
		end
		a=a+1
	end

	for a = 1,32 do
		local b, s = UnitBuff(name,a)
		if b then 
			aDF_tooltip:SetOwner(UIParent, "ANCHOR_NONE");
			aDF_tooltip:ClearLines()
			aDF_tooltip:SetUnitBuff(name,a)
			local aDFtext = aDF_tooltipTextL:GetText()
			if aDFtext == buff then 
				if stacks == 1 then
					return s
				else
					return true
				end
			end
		end
	end
	
	return false
end

function aDF:TargetChanged()
	last_target_change_time = GetTime()
	aDF_target = "target"

	local showadf = false
	if UnitIsFriend("player", aDF_target) and UnitCanAttack("player", "targettarget") then
		aDF_target = "targettarget"
	end

	if UnitExists(aDF_target) then
		showadf = true
	end

	if gui_Options["Raid"] then
		if not UnitInRaid("player") then showadf = false end
	end

	if showadf then
		aDF:Show()
	else
		aDF:Hide()
	end

	aDF_armorprev = 30000
	-- adfprint('PLAYER_TARGET_CHANGED ' .. tostring(aDF_target))
	aDF:Update()
end

-- event function, will load the frames we need
function aDF:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "aDF" then
		aDF_Default()
		aDF_target = nil
		aDF_armorprev = 30000
		if gui_chan == nil then gui_chan = Say end
		aDF:Init() -- loads frame, see the function
		aDF.Options:Gui() -- loads options frame
		aDF:Sort() -- sorts the debuff frames and places them to eachother
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ffff护甲监控 已加载|r /adf options")
--		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf show|r to show frame",1,1,1)
--		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf hide|r to hide frame",1,1,1)
--		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf options|r for options frame",1,1,1)
	end
	if event == "UNIT_AURA" then
		aDF:Update()
	end
	if event == "PLAYER_TARGET_CHANGED" then
		aDF:TargetChanged()
	end
end

-- update and onevent who will trigger the update and event functions

aDF:SetScript("OnEvent", aDF.OnEvent)
aDF:SetScript("OnUpdate", aDF.UpdateCheck)

-- slash commands

function aDF.slash(arg1,arg2,arg3)
	if arg1 == nil or arg1 == "" then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf show|r to show frame",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf hide|r to hide frame",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf options|r for options frame",1,1,1)
		else
		if arg1 == "show" then
			aDF:Show()
		elseif arg1 == "hide" then
			aDF:Hide()
		elseif arg1 == "options" or arg1 == "o" then
			aDF.Options:Show()
		else
			DEFAULT_CHAT_FRAME:AddMessage(arg1)
			DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r unknown command",1,0.3,0.3);
		end
	end
end

SlashCmdList['ADF_SLASH'] = aDF.slash
SLASH_ADF_SLASH1 = '/adf'
SLASH_ADF_SLASH2 = '/ADF'

-- debug

function adfprint(arg1)
	DEFAULT_CHAT_FRAME:AddMessage("|cffCC121D adf debug|r "..arg1)
end
