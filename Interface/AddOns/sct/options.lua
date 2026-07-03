--The Options Page variables and functions

DSCT_EventC = 1;
DSCT_CheckC = 1;
DSCT_SliderC = 1;
DSCT_ColorPickerExC = 1;
DSCT_ListFrameC = 1;

DSCT_SupportFont_Ok = false;
--Set color functions

function DSCT_RefreshCheckButton(objname)
	local button = getglobal(objname);
	local str = getglobal(objname.."Text");
	local checked = nil;
	--button.disabled = nil;	
	if ( DSCT_Get(button.saveName) == 1 ) then
		checked = 1;
	else
		checked = 0;
	end	
	OptionsFrame_EnableCheckBox(button);
	button:SetChecked(checked);
end

function DSCT_ConfigColorPicker(objname)
	local frame,swatch,sRed,sGreen,sBlue,sColor;
	
	frame = getglobal(objname);
	swatch = getglobal(objname.."_ColorSwatchNormalTexture");
	
	sColor = DSCT_nGetColor(frame.saveName);
	sRed = sColor.r;
	sGreen = sColor.g;
	sBlue = sColor.b;

	frame.r = sRed;
	frame.g = sGreen;
	frame.b = sBlue;
	
	frame.swatchFunc = function(x) DSCTOptionsFrame_SetColor(frame:GetName()) end;
	frame.cancelFunc = function(x) DSCTOptionsFrame_CancelColor(frame:GetName(),x) end;
	swatch:SetVertexColor(sRed,sGreen,sBlue);
end
function DSCT_RefreshColorPickerEx(objname)
	local str = getglobal(objname.."_Text");
	DSCT_ConfigColorPicker(objname);	
end

function DSCT_RefreshEventFrames(objname)
	local button = getglobal(objname.."_Button");
	local val = DSCT_Get(getglobal(objname).saveName);
	local ani = DSCT_Get("ANIMODE");
	
	if val > 4 then val = 4;end
	if val < 0 then val = 0;end
	
	if DSCT_Get("ANIMODE") == 0 or DSCT_Get("ANIMODE") == 1 or DSCT_Get("ANIMODE") == 2 then
		if val + 1 == 4 then
			button:SetText(DSCT_EVENTTYPE[ani + 1][3]);
		else
			button:SetText(DSCT_EVENTTYPE[ani + 1][val + 1]);
		end
	else
		button:SetText(DSCT_EVENTTYPE[ani + 1][val + 1]);		
	end
	if val == 0 then getglobal(objname.."_Text"):SetTextColor(0.4,0.4,0.4);else getglobal(objname.."_Text"):SetTextColor(1.0,0.82,0);end
	
	--Color Swatch
	DSCT_ConfigColorPicker(objname);
	DSCT_InitCustomEvent();
end

function DSCT_RefreshFrameSliders(objname)
	local slider = getglobal(objname);
	
	slider:SetValue( DSCT_Get(slider.saveName) );	
	
	DSCT_OptionsSliderRefreshTitle(objname);
end

function DSCT_RefreshFrameList(objname)
	local obj = getglobal(objname);	
	
	for key, value in obj.list do
		if value.val == DSCT_Get(obj.saveName) then
			getglobal(objname.."_Text"):SetText(value.name);
		end
	end
end
function DSCT_Support_NewFont()	
	if DSCT_SupportFont_Ok == false then
		local aniFont = DSCT_OptionCfg_Text.ListFrames ["FONT"];
		local mesFont = DSCT_OptionCfg_MSGText.ListFrames ["MESSAGEFONT"];
		if EU_Fonts_List then
			for key,value in EU_Fonts_List do
				if value.name and value.path then
					aniFont.max = aniFont.max + 1;
					mesFont.max = mesFont.max + 1;
					DSCT_FONTLIST[aniFont.max] = {};
					DSCT_FONTLIST[aniFont.max] = value;
					aniFont.list[aniFont.max] = {};
					aniFont.list[aniFont.max].name = value.name;
					aniFont.list[aniFont.max].val = aniFont.max;
					mesFont.list[mesFont.max] = {};
					mesFont.list[mesFont.max].name = value.name;
					mesFont.list[mesFont.max].val = mesFont.max;
				end
			end
			DSCT_aniInit();--reload with Current Config	
			DSCT_cusMessInit();
		end
		
		local enFont = DSCT_OptionCfg_Text.ListFrames ["ENFONT"];
		local font = CreateFont("DSCTtestFont");
		for i = 1,5 do
			if font:SetFont("Interface\\AddOns\\sct\\Fonts\\font"..i..".TTF", 16) ~= nil then
				enFont.max = enFont.max + 1;
				DSCT_ENFONTLIST[enFont.max] = {};
				DSCT_ENFONTLIST[enFont.max].name = "font"..i;
				DSCT_ENFONTLIST[enFont.max].path = "Interface\\AddOns\\sct\\Fonts\\font"..i..".TTF";
				enFont.list[enFont.max] = {};
				enFont.list[enFont.max].name = "font"..i;
				enFont.list[enFont.max].val = enFont.max;
			end
		end
		DSCT_SupportFont_Ok = true;
	end
end

function DSCTOptionsFrame_Clear()
	local id = 1;
	DSCT_EventC = 1;
	DSCT_CheckC = 1;
	DSCT_SliderC = 1;
	DSCT_ColorPickerExC = 1;
	DSCT_ListFrameC = 1;
	
	for id = 1,22 do
		local obj = getglobal("DSCTEvent"..id);	
		obj:Hide();
	end
	for id = 1,8 do
		local obj = getglobal("DSCTCheck"..id);	
		obj:Hide();
	end	
	for id = 1,10 do
		local obj = getglobal("DSCTSlider"..id);	
		obj:Hide();
	end
	for id = 1,2 do
		local obj = getglobal("DSCTColorPickerEx"..id);	
		obj:Hide();
	end
	for id = 1,5 do
		local obj = getglobal("DSCTListFrame"..id);	
		obj:Hide();
	end
end

function DSCTOptionsFrame_Load(cfg)	
	if cfg.EventFrames then
		for key, value in cfg.EventFrames do
			local objname = "DSCTEvent"..DSCT_EventC;
			local obj = getglobal(objname);		
			getglobal(objname.."_Button").Func = function(x) DSCT_Event_Button_Click(x);end
			getglobal(objname.."_Button").tooltipText = value.tooltipText;
			obj.saveName = key;
			obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", value.x, value.y);
			getglobal(objname.."_Text"):SetText(value.title);
			DSCT_RefreshEventFrames(objname);
			DSCT_EventC = DSCT_EventC + 1;
			obj:Show();
		end
	end
	-- Set CheckButton states
	if cfg.CheckButtons == nil then
		cfg.CheckButtons = {};
		cfg.CheckButtons["ENABLED"] = DSCT_OptionCfg_Base["ENABLED"];
	else
		if cfg.CheckButtons["ENABLED"] == nil then cfg.CheckButtons["ENABLED"] = DSCT_OptionCfg_Base["ENABLED"]; end
	end
	if cfg.CheckButtons then
		for key, value in cfg.CheckButtons do
			local objname = "DSCTCheck"..DSCT_CheckC;
			local obj = getglobal(objname);
			obj.tooltipText = value.tooltipText;
			obj.saveName = key;
			obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", value.x, value.y);
			getglobal(objname.."Text"):SetText(value.title);
			DSCT_RefreshCheckButton(objname);
			DSCT_CheckC = DSCT_CheckC + 1;
			obj:Show();
		end
	end
	--Set Sliders
	if cfg.Sliders then
		for key, value in cfg.Sliders do
			local objname = "DSCTSlider"..DSCT_SliderC;
			local obj = getglobal(objname);
			obj:SetFrameLevel(2);
			
			obj.tooltipText = value.tooltipText;
			obj.saveName = key;
			obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", value.x, value.y);
			
			obj.titlebak = value.title;
			obj:SetValue( DSCT_Get(key) );
		
			obj:SetMinMaxValues(value.minValue, value.maxValue);
			obj:SetValueStep(value.valueStep);
		
			getglobal(objname.."Text"):SetText(obj.titlebak);
			getglobal(objname.."Low"):SetText(value.minText);
			getglobal(objname.."High"):SetText(value.maxText);
			
			OptionsFrame_EnableSlider(obj);
			DSCT_RefreshFrameSliders(objname);
			DSCT_SliderC = DSCT_SliderC + 1;
			obj:Show();
		end
	end
	
	if cfg.ColorPickerEx then
		for key, value in cfg.ColorPickerEx do
			local objname = "DSCTColorPickerEx"..DSCT_ColorPickerExC;
			local obj = getglobal(objname);
			obj.tooltipText = value.tooltipText;
			obj.saveName = key;
			obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", value.x, value.y);
			
			getglobal(objname.."_Text"):SetText(value.title);
			DSCT_RefreshColorPickerEx(objname);
			DSCT_ColorPickerExC = DSCT_ColorPickerExC + 1;
			obj:Show();
		end
	end
	
	if cfg.ListFrames then
		for key, value in cfg.ListFrames do
			local objname = "DSCTListFrame"..DSCT_ListFrameC;
			local obj = getglobal(objname);
			obj:SetFrameLevel(2);
			
			obj.tooltipText = value.tooltipText;
			obj.saveName = key;
			obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", value.x, value.y);
			obj.min = value.min;
			obj.max = value.max;
			
			obj.list = value.list;
			getglobal(objname.."_TileText"):SetText(value.title);			
			
			DSCT_RefreshFrameList(objname);
			DSCT_ListFrameC = DSCT_ListFrameC + 1;
			obj:Show();
		end
	end
end
--Called when option page loads
function DSCTOptionsFrame_OnShow()
	--support for EU_Fonts
	DSCT_Support_NewFont();
	DSCT_HideAllBG();
	DSCT_ShowBG(1,180,-50,340,360);
	DSCTOptionsFrame_Clear();
	DSCTOptionsFrame_Load(DSCT_OptionCfg_Event);
end

----------------------
--Sets the colors of the config from a color swatch
function DSCTOptionsFrame_SetColor(name)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal(name.."_ColorSwatchNormalTexture");
	frame = getglobal(name);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	--update back to config
	DSCT_SetColor(frame.saveName, r, g, b)
end

----------------------
-- Cancels the color selection
function DSCTOptionsFrame_CancelColor(name, prev)
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
	DSCT_SetColor(frame.saveName, r, g, b)
end

----------------------

function DSCT_OptionsSliderRefreshTitle(objname)
	local slider = getglobal(objname);
	local str = getglobal(objname.."Text");
	local txt;
	local val = slider:GetValue();
	if slider.saveName == "LOWHP" or slider.saveName == "LOWMANA" or slider.saveName == "ALPHA" or slider.saveName == "MESSAGEALPHA" then
		if val < 1 then			
			txt = format("%d",val * 100);
		else
			txt = 100;
		end
	elseif slider.saveName == "ANIMATIONSPEED" or string.sub(slider.saveName,string.len(slider.saveName) - 5,string.len(slider.saveName) - 1) == "Param" then
		txt = format("%d",val * 100);
		txt	= txt.." %";
	else
		txt = val;
	end	
	str:SetText(slider.titlebak..": "..txt);
end
--Sets the silder values in the config
function DSCT_OptionsSliderOnValueChanged()
	DSCT_OptionsSliderRefreshTitle(this:GetName());
end
function DSCT_OptionsSliderMouseUp()
	DSCT_Set(this.saveName,this:GetValue());

	DSCT_cusMessInit();
	DSCT_aniInit();
	DSCT_openPreView();
end

function DSCT_Event_Button_Click(name)
	for name in string.gfind( name, "(.+)_Button" ) do	
		local val = DSCT_Get(getglobal(name).saveName);	
		val = val + 1;
		if val > 4 then val = 0;end
		if DSCT_Get("ANIMODE") == 0 or DSCT_Get("ANIMODE") == 1 or DSCT_Get("ANIMODE") == 2 then
			if val + 1 == 4 then
				val = 4;
			end
		end
		local ani = DSCT_Get("ANIMODE");
		if DSCT_Get("ANIMODE") == 0 or DSCT_Get("ANIMODE") == 1 or DSCT_Get("ANIMODE") == 2 then
			if val + 1 == 4 then
				getglobal(name.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][3]);
			else
				getglobal(name.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][val + 1]);
			end
		else
			getglobal(name.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][val + 1]);		
		end
		DSCT_Set(getglobal(name).saveName,val);		
		DSCT_RefreshAllEvent();
	end
end
----------------------
--Sets the checkbox values in the config
function DSCT_OptionsCheckButtonOnClick(name,checkboxname)
	local button = getglobal(checkboxname);
	local val;
	if button:GetChecked() then val = 1;else val = 0;end
	DSCT_Set(button.saveName,val);	
	DSCT_RefreshAllEvent();
end

----------------------
--Open the color selector using show/hide
function DSCT_OpenColorPicker(button)
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

function DSCT_ButtonToggle(parentame,v)
	local obj = getglobal(parentame);
	local curVal = DSCT_Get(obj.saveName);
	curVal = curVal + v;
	if curVal > obj.max then curVal = obj.min;end
	if curVal < obj.min then curVal = obj.max;end
	DSCT_Set(obj.saveName,curVal);
	DSCT_RefreshFrameList(parentame);
	
	if obj.saveName == "ANIMODE" then
		DSCTOptionsFrame_Clear();
		DSCTOptionsFrame_Load(DSCT_OptionCfg_Text);
		DSCTOptionsFrame_Load(DSCTAniModeParamsSliders[DSCT_Get("ANIMODE")]);
	end
end

function DSCT_MouseUp()	
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;		
	end
end

function DSCT_MouseDown(button)	
	if button == "LeftButton" then
		this:StartMoving();
		this.isMoving = true;		
	end
end

function DSCT_SaveCustom()
	DSCT_NEWCONFIG["CUSTOM_SETTING".." of ".."DSCT"] = nil;
	DSCT_NEWCONFIG["CUSTOM_SETTING".." of ".."DSCT"] = DSCT_clone(DSCT_Config_GetPlayer());
	DSCT_Debug("Save OK!");
end

function DSCT_LoadCustom()
	if DSCT_NEWCONFIG["CUSTOM_SETTING".." of ".."DSCT"] ~= nil then
		DSCT_Load(DSCT_NEWCONFIG["CUSTOM_SETTING".." of ".."DSCT"]);	
		DSCT_hideMenu();
		DSCT_showMenu();		
		DSCT_Debug("Load OK!");
	end	
end

function DSCT_PreMessMouseUp()	
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;
		local x,y = this:GetCenter();
		x = x - GetScreenWidth() / 2;
		y = y - GetScreenHeight() / 2;
		DSCT_Set("MESSAGEPOSX",x);
		DSCT_Set("MESSAGEPOSY",y);	
	end
end

function DSCT_PreMessMouseDown(button)
	if button == "LeftButton" then
		this:StartMoving();
		this.isMoving = true;		
	end
end

function DSCT_PreAniMouseUp()	
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;
		local x,y = this:GetCenter();
		x = x - GetScreenWidth() / 2;
		y = y - GetScreenHeight() / 2;
		DSCT_Set("ANIPOSX",x);
		DSCT_Set("ANIPOSY",y);	
	end
end

function DSCT_PreAniMouseDown(button)
	if button == "LeftButton" then
		this:StartMoving();
		this.isMoving = true;		
	end
end

function DSCT_HideAllBG()
	DSCTOptions_BG1:Hide();
	DSCTOptions_BG2:Hide();
	DSCTOptions_BG3:Hide();
	DSCTOptions_BG4:Hide();
end

function DSCT_ShowBG(id,x,y,w,h)
	local obj = getglobal("DSCTOptions_BG"..id);
	obj:Show();
	obj:SetPoint("TOPLEFT","DSCTOptions","TOPLEFT",x,y);
	obj:SetWidth(w);
	obj:SetHeight(h);
end