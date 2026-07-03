
DEXOptionsFrameCheckButtons = { };
DEXOptionsFrameCheckButtons ["DEX_Enable"] = { title = "开启", tooltipText = "开启攻击伤害显示器"};
DEXOptionsFrameCheckButtons ["DEX_ShowWithMess"] = { title = "以Log方式显示", tooltipText = "以Log方式显示所有伤害信息"};
DEXOptionsFrameCheckButtons ["DEX_ShowSpellName"] = { title = "显示技能名", tooltipText = "在伤害数值边显示造成此次伤害的技能名"};
DEXOptionsFrameCheckButtons ["DEX_ShowNameOnCrit"] = { title = "当暴击才显示", tooltipText = "只有在致命一击时才显示技能名"};
DEXOptionsFrameCheckButtons ["DEX_ShowNameOnMiss"] = { title = "当未击中等才显示", tooltipText = "只有在技能未击中，被抵抗等才显示技能名"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamageNormal"] = { title = "显示物理伤害", tooltipText = "显示物理攻击的伤害"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamageSkill"] = { title = "显示技能伤害", tooltipText = "显示技能攻击的伤害"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamagePeriodic"] = { title = "显示持续伤害", tooltipText = "显示持续攻击的伤害"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamageShield"] = { title = "显示反射伤害", tooltipText = "显示你对敌人伤害的反射量"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamageHealth"] = { title = "显示治疗量", tooltipText = "显示对目标的治疗量"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamagePet"] = { title = "显示宠物伤害", tooltipText = "显示宠物对目标的伤害，含图腾"};
DEXOptionsFrameCheckButtons ["DEX_ShowDamageWoW"] = { title = "显示系统默认伤害", tooltipText = "显示系统原有的伤害"};

DEXOptionsFrameSliders = { };
DEXOptionsFrameSliders ["DEX_Font"] = {  title = "字体 ", minValue = 1, maxValue = 3, valueStep = 1, minText="字体1", maxText="字体3", tooltipText = "设置文字的类型"};
DEXOptionsFrameSliders ["DEX_FontSize"] = {  title = "文字大小 ", minValue = 12, maxValue = 36, valueStep = 1, minText="小", maxText="大", tooltipText = "设置文字的大小"};
DEXOptionsFrameSliders ["DEX_Speed"] = {  title = "文字移动速度 ", minValue = 50, maxValue = 300, valueStep = 5, minText="慢", maxText="快", tooltipText = "设置文字的移动速度"};
DEXOptionsFrameSliders ["DEX_LOGLINE"] = {  title = "log最大条目 ", minValue = 5, maxValue = 20, valueStep = 1, minText="5条", maxText="20条", tooltipText = "设置文字的移动速度"};
DEXOptionsFrameSliders ["DEX_LOGTIME"] = {  title = "log停留时间 ", minValue = 5, maxValue = 60, valueStep = 1, minText="5秒", maxText="1分钟", tooltipText = "设置文字的移动速度"};

DEXOptionsColorPickerEx = { };
DEXOptionsColorPickerEx ["DEX_ColorNormal"] = { title = "物理伤害颜色"};
DEXOptionsColorPickerEx ["DEX_ColorSkill"] = { title = "技能伤害颜色"};
DEXOptionsColorPickerEx ["DEX_ColorPeriodic"] = { title = "持续伤害颜色"};
DEXOptionsColorPickerEx ["DEX_ColorHealth"] = { title = "治疗颜色"};
DEXOptionsColorPickerEx ["DEX_ColorPet"] = { title = "宠物伤害颜色"};

--Set color functions
local DEXOptionsFrame_SetColorFunc = {
	["DEX_ColorNormal"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorNormal") end,
	["DEX_ColorSkill"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorSkill") end,
	["DEX_ColorPeriodic"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorPeriodic") end,
	["DEX_ColorHealth"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorHealth") end,
	["DEX_ColorPet"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorPet") end,
};  

local DEXOptionsFrame_CancelColorFunc = {
	["DEX_ColorNormal"] = function(x) DEXOptionsFrame_CancelColor("DEX_ColorNormal",x) end,
	["DEX_ColorSkill"] = function(x) DEXOptionsFrame_CancelColor("DEX_ColorSkill",x) end,
	["DEX_ColorPeriodic"] = function(x) DEXOptionsFrame_CancelColor("DEX_ColorPeriodic",x) end,
	["DEX_ColorHealth"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorHealth") end,
	["DEX_ColorPet"] = function(x) DEXOptionsFrame_SetColor("DEX_ColorPet") end,
};  


function DEX_RefreshCheckButton(name)
	local button = getglobal(name);
	local str = getglobal(name.."Text");
	local checked;
	--button.disabled = nil;	
	if ( DEX_Get(name) == 1 ) then
		checked = 1;
	else
		checked = 0;
	end	
	OptionsFrame_EnableCheckBox(button);
	button:SetChecked(checked);
	str:SetText(DEXOptionsFrameCheckButtons[name].title);
	button.tooltipText = DEXOptionsFrameCheckButtons[name].tooltipText;	
	DEX_CheckButtonLink(name);
end

function DEX_CheckButtonLink(name)
	if name == "DEX_ShowSpellName" then		
		if DEX_Get(name) == 1 then
			OptionsFrame_EnableCheckBox(getglobal("DEX_ShowNameOnCrit"));
			DEX_RefreshCheckButton("DEX_ShowNameOnCrit");
			OptionsFrame_EnableCheckBox(getglobal("DEX_ShowNameOnMiss"));
			DEX_RefreshCheckButton("DEX_ShowNameOnMiss");			
		else
			OptionsFrame_DisableCheckBox(getglobal("DEX_ShowNameOnCrit"));
			OptionsFrame_DisableCheckBox(getglobal("DEX_ShowNameOnMiss"));
		end
	end
	if name == "DEX_ShowWithMess" then		
		if DEX_Get(name) == 1 then
			OptionsFrame_EnableSlider(getglobal("DEX_LOGLINE"));
			DEX_RefreshFrameSliders("DEX_LOGLINE");
			OptionsFrame_EnableSlider(getglobal("DEX_LOGTIME"));
			DEX_RefreshFrameSliders("DEX_LOGLINE");
			OptionsFrame_DisableSlider(getglobal("DEX_Speed"));			
		else
			OptionsFrame_DisableSlider(getglobal("DEX_LOGLINE"));
			OptionsFrame_DisableSlider(getglobal("DEX_LOGTIME"));
			OptionsFrame_EnableSlider(getglobal("DEX_Speed"));
			DEX_RefreshFrameSliders("DEX_Speed");
		end
	end
end

function DEX_ConfigColorPicker(name)
	local frame,swatch,sRed,sGreen,sBlue,sColor;
	
	frame = getglobal(name);
	swatch = getglobal(name.."_ColorSwatchNormalTexture");
	
	sColor = DEX_Get(name);
	sRed = sColor[1];
	sGreen = sColor[2];
	sBlue = sColor[3];

	frame.r = sRed;
	frame.g = sGreen;
	frame.b = sBlue;
	frame.swatchFunc = DEXOptionsFrame_SetColorFunc[name];
	frame.cancelFunc = DEXOptionsFrame_CancelColorFunc[name];
	swatch:SetVertexColor(sRed,sGreen,sBlue);
end
function DEX_RefreshColorPickerEx(name)
	local str = getglobal(name.."_Text");
	str:SetText(DEXOptionsColorPickerEx[name].title);
	DEX_ConfigColorPicker(name);	
end

function DEX_RefreshFrameSliders(name)
	local slider = getglobal(name);
	local str = getglobal(name.."Text");
	local low = getglobal(name.."Low");
	local high = getglobal(name.."High");
	
	local value = DEXOptionsFrameSliders[name];
	OptionsFrame_EnableSlider(slider);
	slider:SetMinMaxValues(value.minValue, value.maxValue);
	slider:SetValueStep(value.valueStep);
	slider:SetValue( DEX_Get(name) );
	str:SetText(value.title);
	low:SetText(value.minText);
	high:SetText(value.maxText);
	slider.tooltipText = value.tooltipText;
	
	DEX_OptionsSliderRefreshTitle(name);
end

----------------------
--Called when option page loads
function DEXOptionsFrame_OnShow()

	for key, value in DEXOptionsFrameCheckButtons do		
		DEX_RefreshCheckButton(key);
	end

	for key, value in DEXOptionsFrameSliders do
		DEX_RefreshFrameSliders(key);
	end
	
	for key, value in DEXOptionsColorPickerEx do
		DEX_RefreshColorPickerEx(key);
	end	
end

----------------------
--Sets the colors of the config from a color swatch
function DEXOptionsFrame_SetColor(name)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal(name.."_ColorSwatchNormalTexture");
	frame = getglobal(name);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	--update back to config
	DEX_Set(name, {r, g, b})
end

----------------------
-- Cancels the color selection
function DEXOptionsFrame_CancelColor(name, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal(name.."_ColorSwatchNormalTexture");
	frame = getglobal(name);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	-- Update back to config
	DEX_Set(name, {r, g, b})
end

----------------------

function DEX_OptionsSliderRefreshTitle(name)
	local slider = getglobal(name);
	local str = getglobal(name.."Text");
	local txt;
	local val = slider:GetValue();
	if name == "LOWHP" or name == "LOWMANA" or name == "ALPHA" or name == "MESSAGEALPHA" then
		if val < 1 then			
			txt = format("%d",val * 100);
		else
			txt = 100;
		end
	elseif name == "ANIMATIONSPEED" then
		txt = format("0.0%d",val * 1000);		
	else
		txt = val;
	end	
	str:SetText(DEXOptionsFrameSliders[name].title..": "..txt);
end
--Sets the silder values in the config
function DEX_OptionsSliderOnValueChanged(name)
	local slider = getglobal(name);
	DEX_Set(name,slider:GetValue());
	
	DEX_OptionsSliderRefreshTitle(name);
end

----------------------
--Sets the checkbox values in the config
function DEX_OptionsCheckButtonOnClick(name)
	local button = getglobal(name);
	local val;
	if button:GetChecked() then val = 1;else val = 0;end

	DEX_Set(name,val);
	DEX_CheckButtonLink(name);
end

----------------------
--Open the color selector using show/hide
function DEX_OpenColorPicker(button)
	CloseMenus();
	if ( not button ) then
		button = this;
	end
	ColorPickerFrame.func = button.swatchFunc;
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = button.cancelFunc;
	ColorPickerFrame:Show();
end


function DEX_MouseUp()	
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;		
	end
end

function DEX_MouseDown(button)	
	if button == "LeftButton" then
		this:StartMoving();
		this.isMoving = true;		
	end
end

function DEX_preMouseUp()	
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;
		local x,y = this:GetCenter();
		x = x - GetScreenWidth() / 2;
		y = y - GetScreenHeight() / 2;
		DEX_Set("DEX_PosX",x);
		DEX_Set("DEX_PosY",y);	
	end
end

function DEX_preMouseDown(button)
	if button == "LeftButton" then
		this:StartMoving();
		this.isMoving = true;		
	end
end

function DEX_showMenu()
	PlaySound("igMainMenuOpen");
	ShowUIPanel(DEXOptions);	
	local pre = getglobal("DEX_PreBox");
	pre:ClearAllPoints();
	pre:SetPoint("CENTER", "UIParent", "CENTER", DEX_Get("DEX_PosX",x), DEX_Get("DEX_PosY",y));
	pre:Show();
	DEX_CheckButtonLink("DEX_ShowSpellName");
	DEX_CheckButtonLink("DEX_ShowWithMess");
end

--Hide the Option Menu
function DEX_hideMenu()
	PlaySound("igMainMenuClose");
	HideUIPanel(DEXOptions);
	local pre = getglobal("DEX_PreBox");
	pre:Hide();
	-- myAddOns support
	if(MYADDONS_ACTIVE_OPTIONSFRAME == DEXOptions) then
		ShowUIPanel(myAddOnsFrame);
	end
	DEX_aniInit();
	DEX_staticInit();
end