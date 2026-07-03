SUPERMACRO_VERSION = "Lite";
UIPanelWindows["SuperMacroFrame"] = { area = "left", pushable = 7, whileDead = 1 };
MACRO_ROWS = 3;
MACRO_COLUMNS = 10;
MACROS_SUPER_SHOWN = MACRO_ROWS * MACRO_COLUMNS;
SM_NUM_MACRO_ICONS_SHOWN = 30;--20
SM_NUM_ICONS_PER_ROW = 5;--5
SM_NUM_ICON_ROWS = 6;--4
SM_MACRO_ROW_HEIGHT = 36;
SM_MACRO_ICON_ROW_HEIGHT = 36;
SUPER_MAX_LETTERS = 7000;
SM_VARS = {}; -- options variables, Saved
SM_EXTEND = {}; -- ingame extended, Saved
SM_SUPER={}; -- supers' names, texture, body, Saved
SM_ORDERED={}; -- supers in alphabetical order
SM_ACTION={}; -- hold actions that have supers, for current player
SM_ACTION_SUPER={}; -- hold actions for supers, Saved per character
SM_MACRO_ICON={}; -- hold all available icons and their id
SM_ACTION_SPELL={}; -- hold macros that cast spell or items
SM_ACTION_SPELL.super={};
SM_AliasFunctions={}; -- functions to replace aliases
SM_AliasFunctions.low=0;
SM_AliasFunctions.high=0;
SM_AliasFunctions[0]=function (body) return body; end

function SuperMacroFrame_OnLoad()
	PanelTemplates_SetNumTabs(this, 2);
	SuperMacroFrame.selectedTab = 1;
	SuperMacroFrameTitle:SetText(SUPERMACRO_TITLE.." "..SUPERMACRO_VERSION);
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("TRADE_SKILL_SHOW");
	this:RegisterEvent("CRAFT_SHOW");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	lastActionUsed = nil;
	SuperMacroFrame_SetAccountMacros();
	SM_MACRO_ICON=SM_LoadMacroIcons();
end

function SuperMacroFrame_OnShow()
	SuperMacroFrame.extendChanged=nil;
	SuperMacroFrame_Update();
	PlaySound("igCharacterInfoOpen");
end

function SuperMacroFrame_OnHide()
	SuperMacroPopupFrame:Hide();
	PlaySound("igCharacterInfoClose");
	SuperMacroFrame.extendChanged=nil;
	-- purge empty extends
	for m,e in ipairs(SM_EXTEND) do
		if ( e=="" ) then
			SM_EXTEND[m]=nil;
		end
	end
	SuperMacroRunScriptExtend();
end

function SuperMacroFrame_SetAccountMacros()
	local numAccountMacros, numCharacterMacros = GetNumMacros();
	if ( numAccountMacros > 0 ) then
		SuperMacroFrame_SelectMacro(1);
	else
		SuperMacroFrame_SetCharacterMacros();
	end
end

function SuperMacroFrame_SetCharacterMacros()
	local numAccountMacros, numCharacterMacros = GetNumMacros();
	if ( numCharacterMacros > 0 ) then
		SuperMacroFrame_SelectMacro(19);
	else
		SuperMacroFrame_SelectMacro(nil);
	end
end

function SuperMacroFrame_Update()
	-- START show super frame
	SM_ORDERED=SortSuperMacroList();
	SuperMacroFrameSuperFrame:Show();
	local numMacros=SM_SUPER_SIZE or GetNumSuperMacros();
	local macroButton, macroIcon, macroName;
	local name, texture, body;

	-- Disable Buttons
	if ( SuperMacroPopupFrame:IsVisible() ) then
		SuperMacroNewSuperButton:Disable();
		SuperMacroSaveSuperButton:Disable();
		SuperMacroDeleteSuperButton:Disable();
		SuperMacroEditButton:Disable();
	else
		SuperMacroNewSuperButton:Enable();
		SuperMacroSaveSuperButton:Enable();
		SuperMacroDeleteSuperButton:Enable();
		SuperMacroEditButton:Enable();
	end
	
	if ( not SuperMacroFrame.selectedSuper or GetNumSuperMacros()==0) then
		SuperMacroSaveSuperButton:Disable();
		SuperMacroDeleteSuperButton:Disable();
		SuperMacroEditButton:Disable();
		SuperMacroFrameSelectedMacroName:SetText('');
		SuperMacroFrameSuperText:SetText('');
		SuperMacroFrameSelectedMacroSuperButtonIcon:SetTexture('');
	end
	
	-- Macro List
	local offset=FauxScrollFrame_GetOffset(SuperMacroFrameSuperScrollFrame);
	local firstmacro = offset*MACRO_COLUMNS+1;
	local lastmacro = firstmacro + MACRO_ROWS*MACRO_COLUMNS -1;
	
	for i=1, MACROS_SUPER_SHOWN do
		getglobal("SuperMacroSuperButton"..i.."ID"):SetText(firstmacro+i-1);
		macroButton = getglobal("SuperMacroSuperButton"..i);
		macroIcon = getglobal("SuperMacroSuperButton"..i.."Icon");
		macroName = getglobal("SuperMacroSuperButton"..i.."Name");
		local macroID = firstmacro+i-1;
		if ( macroID <= numMacros ) then
			name, texture, body = GetOrderedSuperMacroInfo(macroID);
			macroButton:SetID(macroID);
			macroIcon:SetTexture(texture);
			macroName:SetText(name);
			macroButton:Enable();
			-- Highlight Selected Macro
			if ( macroID == SuperMacroFrame.selectedSuper ) then
				macroButton:SetChecked(1);
				SuperMacroFrameSelectedMacroName:SetText(name);
				SuperMacroFrameSuperText:SetText(body);
				SuperMacroFrameSelectedMacroSuperButtonIcon:SetTexture(texture);
			else
				macroButton:SetChecked(0);
			end
		else
			macroButton:SetChecked(0);
			macroIcon:SetTexture("");
			macroName:SetText("");
			macroButton:Disable();
		end
	end

	-- Scroll frame stuff
	FauxScrollFrame_Update(SuperMacroFrameSuperScrollFrame, ceil(numMacros/10), MACRO_ROWS, SM_MACRO_ROW_HEIGHT );
end

function SuperMacroSuperButton_OnClick( button )
	local id=this:GetID();
	SuperMacroFrame_SaveSuperMacro();
	SuperMacroFrame_SelectSuperMacro(id);
	SuperMacroFrame_Update();
	SuperMacroPopupFrame:Hide();
	SuperMacroFrameSuperText:ClearFocus();
	if ( button=="RightButton" ) then
		RunSuperMacro(id);
	end
end

function SuperMacroFrame_SelectSuperMacro(id)
	SuperMacroFrame.selectedSuper = id;
end

function SuperMacroFrame_SelectMacro(id)
	SuperMacroFrame.selectedMacro = id;
end

function SuperMacroNewSuperButton_OnClick()
	SuperMacroFrame_SaveSuperMacro();
	SuperMacroPopupFrame.mode = "newsuper";
	SuperMacroPopupFrame:Show();
end

function SuperMacroEditButton_OnClick()
	SuperMacroPopupFrame.mode = "edit";
	SuperMacroPopupFrame.oldname=SuperMacroFrameSelectedMacroName:GetText();
	SuperMacroPopupFrame:Show();
end

function SuperMacroPopupFrame_OnShow()
	if ( this.mode == "newsuper" ) then
		SuperMacroFrameSuperText:Hide();
		SuperMacroFrameSelectedMacroSuperButtonIcon:SetTexture("");
		SuperMacroPopupFrame.selectedIcon = nil;
	end
	SuperMacroFrameSuperText:ClearFocus();
	SuperMacroPopupEditBox:ClearFocus();

	PlaySound("igCharacterInfoOpen");
	SuperMacroPopupFrame_Update();
	SuperMacroPopupOkayButton_Update();

	-- Disable Buttons
	SuperMacroEditButton:Disable();
end

function SuperMacroPopupFrame_OnHide()
	if ( this.mode == "newsuper" ) then
		SuperMacroFrameSuperText:Show();
		SuperMacroFrameSuperText:SetFocus();
	end

	-- Enable Buttons
	SuperMacroEditButton:Enable();
end

function SuperMacroPopupFrame_Update()
	local numMacroIcons = GetNumMacroIcons();
	local macroPopupIcon, macroPopupButton;
	local macroPopupOffset = FauxScrollFrame_GetOffset( SuperMacroPopupScrollFrame );
	local index;

	if ( this.mode == "newsuper" ) then
		SuperMacroPopupEditBox:SetText("");
	elseif ( this.mode == "edit" ) then
		local name = GetOrderedSuperMacroInfo(SuperMacroFrame.selectedSuper);
		SuperMacroPopupEditBox:SetText(name);
	end
	
	-- Icon list
	for i=1, SM_NUM_MACRO_ICONS_SHOWN do
		macroPopupIcon = getglobal("SuperMacroPopupButton"..i.."Icon");
		macroPopupButton = getglobal("SuperMacroPopupButton"..i);
		index = (macroPopupOffset * SM_NUM_ICONS_PER_ROW) + i;
		if ( index <= numMacroIcons ) then
			macroPopupIcon:SetTexture(GetMacroIconInfo(index));
			macroPopupButton:Show();
		else
			macroPopupIcon:SetTexture("");
			macroPopupButton:Hide();
		end
		if ( index == SuperMacroPopupFrame.selectedIcon ) then
			macroPopupButton:SetChecked(1);
		else
			macroPopupButton:SetChecked(nil);
		end
	end
	
	-- Scrollbar stuff
	FauxScrollFrame_Update(SuperMacroPopupScrollFrame, ceil(numMacroIcons / SM_NUM_ICONS_PER_ROW) , SM_NUM_ICON_ROWS, SM_MACRO_ICON_ROW_HEIGHT );
end

function SuperMacroPopupOkayButton_Update()
	if ( (strlen(SuperMacroPopupEditBox:GetText()) > 0) and SuperMacroPopupFrame.selectedIcon ) then
		SuperMacroPopupOkayButton:Enable();
	else
		SuperMacroPopupOkayButton:Disable();
	end
	if ( SuperMacroPopupFrame.mode == "edit" and (strlen(SuperMacroPopupEditBox:GetText()) > 0) ) then
		SuperMacroPopupOkayButton:Enable();
	end
end

function SuperMacroPopupButton_OnClick()
	SuperMacroPopupFrame.selectedIcon = this:GetID() + (FauxScrollFrame_GetOffset(SuperMacroPopupScrollFrame) * SM_NUM_ICONS_PER_ROW);
	SuperMacroFrameSelectedMacroSuperButtonIcon:SetTexture( GetMacroIconInfo(SuperMacroPopupFrame.selectedIcon));
	SuperMacroPopupOkayButton_Update();
	SuperMacroPopupFrame_Update();
end

function SuperMacroPopupOkayButton_OnClick()
	local index = 1;
	local texture=SuperMacroFrameSelectedMacroSuperButtonIcon:GetTexture();
	local macroname=SuperMacroPopupEditBox:GetText();
	if ( SuperMacroPopupFrame.mode == "newsuper" ) then
		index = CreateSuperMacro(macroname, texture, '');
		SuperMacroFrame_SelectSuperMacro(index);
	elseif ( SuperMacroPopupFrame.mode == "edit" ) then
		local oldsuper=GetOrderedSuperMacroInfo(SuperMacroFrame.selectedSuper);
		if ( SM_SUPER[macroname] ) then
			macroname=SuperMacroPopupFrame.oldname;
		end
		index = EditSuperMacro(SuperMacroFrame.selectedSuper, macroname, texture);
		SuperMacroFrame_SelectSuperMacro(index);
		SuperMacro_UpdateAction(oldsuper, macroname);
	end
	SuperMacroPopupFrame:Hide();
	SuperMacroFrame_Update();
	--oldextend=nil;
end

function SuperMacroFrame_SaveSuperMacro()
	if ( SuperMacroFrame.textChanged and SuperMacroFrame.selectedSuper ) then
		local macroName = SelectedMacroName();
		local macroTexture = SuperMacroFrameSelectedMacroSuperButtonIcon:GetTexture();
		local macroBody = SuperMacroFrameSuperText:GetText();
		SM_SUPER[macroName] = {macroName,macroTexture,macroBody};
		SuperMacroFrame.textChanged = nil;
		SM_UpdateActionSpell(macroName, "super", macroBody);
	end
end

function SuperMacroFrame_OnEvent(event)
	if ( event=="TRADE_SKILL_SHOW") then
		if ( not old_SM_TradeSkillSkillButton_OnClick) then
			old_SM_TradeSkillSkillButton_OnClick = TradeSkillSkillButton_OnClick;
			TradeSkillSkillButton_OnClick = SM_TradeSkillSkillButton_OnClick;
			SM_TradeSkillItem_OnClick();
		end
	end
	if ( event=="CRAFT_SHOW") then
		if ( not old_SM_CraftButton_OnClick) then
			old_SM_CraftButton_OnClick = CraftButton_OnClick;
			CraftButton_OnClick = SM_CraftButton_OnClick;
			SM_CraftItem_OnClick();
		end
	end
	if ( event=="VARIABLES_LOADED" ) then
		SuperMacroRunScriptExtend();
		SuperMacroFrame.extendChanged=nil;
		SM_ORDERED=SortSuperMacroList();
		local player=UnitName("player").." of "..GetRealmName();
		if ( not SM_ACTION_SUPER[player] ) then
			SM_ACTION_SUPER[player]={};
		end
		SM_ACTION=SM_ACTION_SUPER[player];
		SM_UpdateActionSpell();

		-- update alias replacement function
		-- ASF aka Alias-Spellchecker-Filter
		if (ReplaceAlias) then
			SM_InsertAliasFunction(ReplaceAlias);
		end
		-- ChatAlias
		if (CA_ParseMessage) then
			SM_InsertAliasFunction(ReplaceAlias, -1);
			-- this messes up newlines, so should not run during RunMacro
		end
	end
	if ( event=="PLAYER_ENTERING_WORLD" ) then
		SM_UpdateActionSpell();
	end
	if ( event=="PLAYER_LEAVING_WORLD" ) then
		SM_ACTION_SUPER[player]=SM_ACTION;
	end
end

function RunMacro(index)
	-- close edit boxes, then enter body line by line
	if ( MacroFrame_SaveMacro ) then
		MacroFrame_SaveMacro();
	end
	local body;
	if ( type(index) == "number" ) then
		body = GetMacroInfo(index, "body");
	elseif ( type(index) == "string" ) then
		body = GetMacroInfo(GetMacroIndexByName(index),"body");
	end
	if ( not body ) then return; end

	if ( ChatFrameEditBox:IsVisible() ) then
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end

	body = SM_ReplaceAlias(body);

	--SM_MacroRunning = true;
	while ( strlen(body)>0 ) do
		local block, line;
		body, block, line=FindBlock(body);
		if ( block ) then
			RunScript(block);
		else
			RunLine(line);
		end
	end
	--SM_MacroRunning = nil;
end

Macro=RunMacro;

function RunSuperMacro(index)
	if ( SuperMacroFrame_SaveSuperMacro ) then
		SuperMacroFrame_SaveSuperMacro();
	end
	local _,body=nil;
	if ( type(index)=="number") then
		_,_,body = GetOrderedSuperMacroInfo(index);
	elseif ( type(index) == "string" ) then
		body = GetSuperMacroInfo(index,"body");
	end
	if ( not body ) then return; end

	if ( ChatFrameEditBox:IsVisible() ) then
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end

	body = SM_ReplaceAlias(body);

	while ( strlen(body)>0 ) do
		local block, line;
		body, block, line=FindBlock(body);
		if ( block ) then
			RunScript(block);
		else
			RunLine(line);
		end
	end
end

function FindBlock(body)
	local a,b,block=strfind(body,"^/script (%-%-%-%-%[%[.-%-%-%-%-%]%])[\n]*");
	if ( block ) then
		body=strsub(body,b+1);
		return body, block;
	end
	local a,b,line=strfind(body,"^([^\n]*)[\n]*");
	if ( line ) then
		body=strsub(body,b+1);
		return body, nil, line;
	end
end

function RunBody(text)
	local body=text;
	local length = strlen(body);
	for w in string.gfind(body, "[^\n]+") do
		RunLine(w);
	end
end

function RunLine(...)
-- execute a line in a macro
-- if script or cast, then rectify and RunScript
-- else send to chat edit box
	for k=1,arg.n do
		local text=arg[k];
		
		-- replace aliases
		text = SM_ReplaceAlias(text, -1);
		
		-- if ( string.find(text, "^/cast") ) then
			-- local spellname = string.sub(text, 7)
			-- local i, book = SM_FindSpell(gsub(spellname,"^%s*/cast%s*(%w.*[%w%)])%s*$","%1"));
			-- if ( i ) then
				-- CastSpell(i,book);
			-- end
		--else
			--if ( string.find(text,"^/script ")) then
				--RunScript(gsub(text,"^/script ",""));
			if ( string.find(text,"^#showtooltip")) then
				return
			else
				text = gsub( text, "\n", ""); -- cannot send newlines, will disconnect
				ChatFrameEditBox:SetText(text);
				ChatEdit_SendText(ChatFrameEditBox);
			end
		--end
	end
end
	
function SM_ReplaceAlias(body, after)
	local size, step;
	if ( after==-1 ) then
		size, step = SM_AliasFunctions.low, -1;
	else
		size, step = SM_AliasFunctions.high, 1;
	end
	for i=step, size, step do
		body = SM_AliasFunctions[i](body);
	end
	return body;
end

function SM_InsertAliasFunction(func, pos)
	if ( pos==-1 ) then
		SM_AliasFunctions.low = SM_AliasFunctions.low - 1;
		SM_AliasFunctions[SM_AliasFunctions.low]=func;
		return SM_AliasFunctions.low;
	else
		SM_AliasFunctions.high = SM_AliasFunctions.high + 1;
		SM_AliasFunctions[SM_AliasFunctions.high]=func;
		return SM_AliasFunctions.high;
	end
end

-- function SM_FindSpell(spell)
	-- local s = gsub(spell, "%s*(.*)%s*%(.*","%1");
	-- local r="";
	-- local num = tonumber(gsub( spell, "%D*(%d+)%D*", "%1"),10);
	-- if ( string.find(spell, "等级 %s*%d+") and num and num > 0) then
		-- r = gsub(spell, ".*%(.*等级 %s*(%d+).*", "等级 "..num);
	-- end
	-- return FindSpell(s,r);
-- end

function FindSpell(spell, rank)
	local i = 1;
	local booktype = { "spell", "pet", };
	local s,r;
	local ys, yr;
	for k, book in booktype do
		while spell do
		s, r = GetSpellName(i,book);
		if ( not s ) then
			i = 1;
			break;
		end
		if ( string.lower(s) == string.lower(spell)) then ys=true; end
		if ( (r == rank) or (r and rank and string.lower(r) == string.lower(rank))) then yr=true; end
		if ( rank=='' and ys and (not GetSpellName(i+1, book) or string.lower(GetSpellName(i+1, book)) ~= string.lower(spell) )) then
			yr = true; -- use highest spell rank if omitted
		end
		if ( ys and yr ) then
			return i,book;
		end
		i=i+1;
		ys = nil;
		yr = nil;
		end
	end
	return;
end

function SuperMacroRunScriptExtend()
	for m,e in pairs(SM_EXTEND) do
		if ( e ) then
			RunScript(e);
		end
	end
end

function SuperMacroDeleteSuperButton_OnClick()
	DeleteSuperMacro(SuperMacroFrame.selectedSuper);
	SuperMacroFrame_Update();
	local name = GetOrderedSuperMacroInfo(1);
	SuperMacroFrameSuperText:ClearFocus();
end

function SameMacroName(macroindex)
	if ( not macroindex and SuperMacroFrame.selectedMacro ) then
		macroindex = SuperMacroFrame.selectedMacro;
	else
		return; -- error check for nil, no macro selected
	end
	local macro=GetMacroInfo(macroindex,"name");
	local prevmacro, nextmacro = GetMacroInfo(macroindex-1,"name"), GetMacroInfo(macroindex+1,"name");
	if ( prevmacro == macro ) then
		return macroindex-1;
	elseif ( nextmacro == macro ) then
		return macroindex+1;
	else
		return false; -- must check "==false"
		-- don't check "not SameMacroName()" unless error check or no macro selected
	end
end

function SelectedMacroName()
	return SuperMacroFrameSelectedMacroName:GetText();
end

local oldGetMacroInfo=GetMacroInfo;
function GetMacroInfo(index, code)
	if ( not index ) then return; end
	-- code can be "name", "texture", "body", "islocal"
	local a={};
	a.name,a.texture,a.body,a.islocal=oldGetMacroInfo(index);
	if (not code) then
		return a.name,a.texture,a.body,a.islocal;
	else
		return a[code];
	end
end

function GetNumSuperMacros()
	return getn(SM_ORDERED);
end

function GetSuperMacroInfo( superName, code)
	if ( not superName or not SM_SUPER[superName] ) then return; end
	-- code can be "name", "texture", "body"
	local a={};
	a.name,a.texture,a.body=unpack(SM_SUPER[superName]);
	if (not code) then
		return a.name,a.texture,a.body;
	else
		return a[code];
	end
end

function SortSuperMacroList()
	-- sort SM_SUPER into ordered list
	local a={};
	for n in pairs(SM_SUPER) do
		table.insert(a, n);
	end
	table.sort(a, atoz);
	return a;
end

function GetOrderedSuperMacroInfo( id )
	if ( not SM_ORDERED ) then
			SM_ORDERED=SortSuperMacroList();
	end
	if ( not SM_SUPER[SM_ORDERED[id] ] ) then
		return;
	end
	return unpack(SM_SUPER[SM_ORDERED[id] ]);
end

function GetOrderedSuperMacro( name )
	for i,v in SM_ORDERED do
		if ( v==name ) then
			return i;
		end
	end
end

function CreateSuperMacro( name, texture, body )
	if ( not SM_SUPER[name] ) then
		SM_SUPER[name]={name, texture, body or ''};
	end
	SM_UpdateActionSpell( name, "super", body);
	SM_ORDERED=SortSuperMacroList();
	return GetOrderedSuperMacro(name);
end

function EditSuperMacro( id, name, texture)
	local oldMacro, oldTexture, oldBody=GetOrderedSuperMacroInfo(id);
	if ( oldMacro~=name ) then
		SM_SUPER[oldMacro]=nil;
		SM_UpdateActionSpell( oldMacro, "super", nil);
	end
	SM_SUPER[name]={ name, texture, oldBody};
	SM_UpdateActionSpell( name, "super", oldBody);
	SM_ORDERED=SortSuperMacroList();
	return GetOrderedSuperMacro(name);
end

function DeleteSuperMacro( macro )
	local id=macro;
	if ( type(macro)=="number" ) then
		macro=GetOrderedSuperMacroInfo(macro);
	else
		id=GetOrderedSuperMacro(macro);
	end
	SM_SUPER[macro]=nil;
	SM_ORDERED=SortSuperMacroList();
	if ( GetNumSuperMacros()==0 ) then
		id=nil;
	else
		id=id>1 and id-1 or 1;
	end
	SuperMacroFrame_SelectSuperMacro(id);
end

function SM_LoadMacroIcons()
	local icon={};
	for i=1,GetNumMacroIcons() do
		local texture=GetMacroIconInfo(i);
		icon[texture]=i;
	end
	return icon;
end

function SM_UpdateActionSpell( macroname, macrotype, body)
	if ( not macroname ) then
		for i=1, GetNumSuperMacros() do
			local name,_,body=GetOrderedSuperMacroInfo(i);
			SM_UpdateActionSpell(name, "super", body);
		end
		return;
	end
	SM_ACTION_SPELL[macrotype][macroname]={};
end

--增加超级宏按钮
local function SM_MacroFrameButton_OnClick()
	if arg1 == "LeftButton" then
		HideUIPanel(GameMenuFrame)
		ToggleFrame(SuperMacroFrame)
	end
end

HookAddonOrVariable("Blizzard_MacroUI", function()
	local SM_MacroFrameButton = CreateFrame("Button", "SM_MacroFrameButton", MacroFrame, "UIPanelButtonTemplate")
	SM_MacroFrameButton:SetWidth(60)
	SM_MacroFrameButton:SetHeight(25)
	SM_MacroFrameButton:SetText("超级宏")
	SM_MacroFrameButton:SetFont(STANDARD_TEXT_FONT, 14)
	SM_MacroFrameButton:SetPoint("TOPRIGHT", MacroFrame, "TOPRIGHT", -50, -42)
	SM_MacroFrameButton:SetScript("OnMouseDown", SM_MacroFrameButton_OnClick)
end)