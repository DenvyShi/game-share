DSCT_EC_OPTION = "自定义事件";

DSCT_OptionCfg_EC = {
	CheckButtons = {
		["CUSTOMEVENT"] = {x = 185,y = -60, title = "使用自定义事件", tooltipText = "自定义事件开关，如果你不用自定义事件的话建议关闭此项"},
	},
}

function DSCT_EC_SetColor(name)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal(name.."_ColorSwatchNormalTexture");
	frame = getglobal(name);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;

	frame.list.r = r;
	frame.list.g = g;
	frame.list.b = b;
end

----------------------
-- Cancels the color selection
function DSCT_EC_CancelColor(name, prev)
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

	frame.list.r = r;
	frame.list.g = g;
	frame.list.b = b;
end

function DSCT_EC_OpenColorPicker(button)
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
function DSCT_EC_ConfigColorPicker(objname)
	local frame,swatch,sRed,sGreen,sBlue,sColor;
	
	frame = getglobal(objname);
	swatch = getglobal(objname.."_ColorSwatchNormalTexture");
	
	
	sColor = {r = frame.list.r,g = frame.list.g,b = frame.list.b}
	sRed = sColor.r;
	sGreen = sColor.g;
	sBlue = sColor.b;

	frame.r = sRed;
	frame.g = sGreen;
	frame.b = sBlue;
	frame.swatchFunc = function(x) DSCT_EC_SetColor(frame:GetName()) end;
	frame.cancelFunc = function(x) DSCT_EC_CancelColor(frame:GetName(),x) end;
	swatch:SetVertexColor(sRed,sGreen,sBlue);
end

function DSCT_EC_RefreshLeft()
		
	local p = DSCT_Get("CUSTOM_EVENT_LIST");
	for i = 1,11 do
		local obj = getglobal("DSCTEvent"..i);		
		obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", 190 , -70 -25 * i );
	end
	for i = 12,22 do
		local obj = getglobal("DSCTEvent"..i);		
		obj:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", 350 , -70 -25 * i );
	end
	
	for i = 1,22 do
		if p[i] then
			local obj = getglobal("DSCTEvent"..i);

			obj.list = p[i];
			
			getglobal("DSCTEvent"..i.."_Button").Func = function(x) DSCT_EC_Button_Click(x);end
			getglobal("DSCTEvent"..i.."_Button").tooltipText = obj.list.tooltipText;
			getglobal("DSCTEvent"..i.."_Text"):SetText(obj.list.title);
			
			if obj.list.ani > 4 then obj.list.ani = 0;end
			
			if obj.list.ani == 0 then getglobal("DSCTEvent"..i.."_Text"):SetTextColor(0.4,0.4,0.4);else getglobal("DSCTEvent"..i.."_Text"):SetTextColor(1.0,0.82,0);end

			local ani = DSCT_Get("ANIMODE");
			if DSCT_Get("ANIMODE") == 0 or DSCT_Get("ANIMODE") == 1 or DSCT_Get("ANIMODE") == 2 then
				if obj.list.ani + 1 == 4 then
					getglobal("DSCTEvent"..i.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][3]);
				else
					getglobal("DSCTEvent"..i.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][obj.list.ani + 1]);
				end
			else
				getglobal("DSCTEvent"..i.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][obj.list.ani + 1]);		
			end
			
			DSCT_EC_ConfigColorPicker("DSCTEvent"..i);
			obj:Show();
		end
	end
end

function DSCT_EC_Button_Click(name)
	for name in string.gfind( name, "(.+)_Button" ) do
		local obj = getglobal(name);

		obj.list.ani = obj.list.ani + 1;
		if obj.list.ani > 4 then obj.list.ani = 0;end
		
		if obj.list.ani == 0 then getglobal(name.."_Text"):SetTextColor(0.4,0.4,0.4);else getglobal(name.."_Text"):SetTextColor(1.0,0.82,0);end

		local ani = DSCT_Get("ANIMODE");
		if DSCT_Get("ANIMODE") == 0 or DSCT_Get("ANIMODE") == 1 or DSCT_Get("ANIMODE") == 2 then
			if obj.list.ani + 1 == 4 then
				getglobal(name.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][3]);
			else
				getglobal(name.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][obj.list.ani + 1]);
			end
		else
			getglobal(name.."_Button"):SetText(DSCT_EVENTTYPE[ani + 1][obj.list.ani + 1]);		
		end
	end
end
