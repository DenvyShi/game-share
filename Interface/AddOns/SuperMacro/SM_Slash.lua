SlashCmdList["MACRO"] = function(msg)
	if(not msg or msg == "") then
		ShowUIPanel(SuperMacroFrame);
	else
		RunMacro(msg);
	end
end

SlashCmdList["SMRUNSUPER"] = function(msg)
	if(msg) then
		RunSuperMacro(msg);
	end
end

-- use item
SlashCmdList["SMUSE"] = function(msg)
	use(unpack(ListToTable(msg)));
end

-- equip item
SlashCmdList["SMEQUIP"] = function(msg)
	use(unpack(ListToTable(msg)));
end

-- equip offhand item
SlashCmdList["SMEQUIPOFF"] = function(msg)
	local bag, slot = FindItem(TrimSpaces(msg));
	if ( bag and slot ) then
		PickupContainerItem(bag, slot);
		PickupInventoryItem(17);
	end
end

-- unequip item by part or name
SlashCmdList["SMUNEQUIP"] = function(msg)
	local e,f = FindLastEmptyBagSlot();
	if ( e ) then
		PickupInventoryItem(FindItem(TrimSpaces(msg)));
		PickupContainerItem(e,f);
	end
end

-- print text to chatframe

-- after action passed text
SlashCmdList["SMPASS"] = function(msg)
	Pass(msg);
end

-- after action failed text
SlashCmdList["SMFAIL"] = function(msg)
	Fail(msg);
end

-- use items in order
SlashCmdList["SMDOORDER"] = function(msg)
	DoOrder(unpack(ListToTable(msg)));
end

-- channel without interruption
SlashCmdList["SMCHANNEL"] = function(msg)
	SM_Channel(msg);
end

-- in sec do cmd
SlashCmdList["SMIN"] = function(msg)
	local _,_,s,r,c = strfind(msg, "(%d+h?%d*m?%d*s?)(%+?)%s+(.*)");
	if ( not c or TrimSpaces(c)=="" ) then return end
	c=gsub(c,"\\n","\n");
	SuperMacro_InEnter(s,c,r);
end

SM_SHIFT_FORM = { bear=1,aquatic=2,cat=3,travel=4,moonkin=5, stealth=1, battle=1,defend=2,berzerk=3 };

SlashCmdList["SMSHIFT"] = function(msg)
	local form=msg;
	if ( SM_SHIFT_FORM[msg] ) then
		form=SM_SHIFT_FORM[msg];
	end
	CastShapeshiftForm(form);
end

--/in 1 /s 123 1秒后说123
function SuperMacro_InEnter( sec, cmd, rep)
	if ( not sec or not cmd ) then return end
	local t=SM_INFRAME.events;
	local seconds=sec;
	if ( strfind(seconds,'[hms]') ) then
		seconds=gsub(seconds,'^(%d+)(h?)(%d*)(m?)(%d*)(s?)$', function(hd, h, md, m, sd, s)
			local a=0;
			if ( h=="h" ) then a=a+hd*3600
			else md=hd..md end;
			if ( m=="m" ) then a=a+md*60
			else sd=md..sd end;
			if ( sd~="" ) then a=a+sd end;
			return a;
		end );
	end
	s=GetTime()+seconds;
	t[s]={};
	t[s].cmd=cmd;
	t[s].sec=seconds;
	t[s].rep=rep and rep or "";
	t.n=t.n+1;
	SM_INFRAME:Show();
end

SM_IN=SuperMacro_InEnter;

function SM_INFRAME_OnUpdate( )
	local t=this.events;
	if ( getn(t)==0 ) then
		SM_INFRAME:Hide();
	end
	for k,v in t do
		if ( k~='n' and k<=GetTime() ) then
			RunBody(v.cmd);
			if ( v.rep~="" ) then
				local s=GetTime()+v.sec;
				t[s]={};
				t[s].cmd=v.cmd;
				t[s].sec=v.sec;
				t[s].rep=v.rep;
				t[k]=nil;
			else
				t[k]=nil;
				t.n=t.n-1;
			end
		end
	end
end

function Pass(text)
	if( IsCurrentAction(lastActionUsed) ) then
		RunLine(text);
		return text;
	end
end

function Fail(text)
	if ( not IsCurrentAction(lastActionUsed) ) then
		RunLine(text);
		return text;
	end
end

function UseItemByName(item)
	local bag,slot = FindItem(item);
	if ( not bag ) then return; end;
	if ( slot ) then
		UseContainerItem(bag,slot); -- use, equip item in bag
		return bag, slot;
	else
		UseInventoryItem(bag); -- unequip from body
		return bag;
	end
end

function use(bag, slot)
	local b,s=tonumber(bag), tonumber(slot);
	if ( b ) then
		if ( s ) then
			UseContainerItem(bag,slot); -- use, equip item in bag
		else
			UseInventoryItem(bag); -- unequip from body
		end
	else
		UseItemByName(bag);
	end
end

-- function DoOrder(...)
	-- for k,i in arg do
		-- local item=FindItem(i);
		-- local spell,book=SM_FindSpell(i);
		-- if ( spell and GetSpellCooldown(spell,book)==0) then
			-- CastSpell(spell,book);
			-- return i, spell, book;
		-- end
		-- if ( item and GetItemCooldown(i)==0 ) then
			-- UseItemByName(i);
			-- return i, item, slot;
		-- end
	-- end
-- end

function FindItem(item)
	if ( not item ) then return; end
	item = string.lower(ItemLinkToName(item));
	local link;
	for i = 1,23 do
		link = GetInventoryItemLink("player",i);
		if ( link ) then
			if ( item == string.lower(ItemLinkToName(link)) )then
				return i, nil, GetInventoryItemTexture('player', i), GetInventoryItemCount('player', i);
			end
		end
	end
	local count, bag, slot, texture;
	local totalcount = 0;
	for i = 0,NUM_BAG_FRAMES do
		for j = 1,MAX_CONTAINER_ITEMS do
			link = GetContainerItemLink(i,j);
			if ( link ) then
				if ( item == string.lower(ItemLinkToName(link))) then
					bag, slot = i, j;
					texture, count = GetContainerItemInfo(i,j);
					totalcount = totalcount + count;
				end
			end
		end
	end
	return bag, slot, texture, totalcount;
end

function GetItemCooldown(item)
	local bag, slot = FindItem(item);
	if ( slot ) then
		return GetContainerItemCooldown(bag, slot);
	elseif ( bag ) then
		return GetInventoryItemCooldown('player', bag);
	end
end

function FindLastEmptyBagSlot()
	for i=NUM_BAG_FRAMES,0,-1 do
		for j=GetContainerNumSlots(i),1,-1 do
			if not GetContainerItemInfo(i,j) then
				return i,j;
			end
		end
	end
end

function ListToTable(text)
	local t={};
	-- if comma is part of item, put % before it
	-- eg, Sulfuras%, Hand of Ragnaros
	text=gsub(text, "%%,", "%%044");
	-- convert link to name, commas ok
	text=gsub(text, "|c.-%[(.+)%]|h|r", function(x)
		return gsub(x, ",", "%%044");
	end );

	gsub(text, "[^,]+", function(a) -- list separated by comma
		a = TrimSpaces(a);
		if ( a~="" ) then
			a=gsub(a, "%%044", ",");
			tinsert(t,a);
		end
	end);
	return t;
end

function TrimSpaces(str)
	if ( str ) then
		return gsub(str,"^%s*(.-)%s*$","%1");
	end
end

function ItemLinkToName(link)
	if ( link ) then
   	return gsub(link,"^.*%[(.*)%].*$","%1");
	end
end

-- function SM_Channel(spell)
	-- local cf = CastingBarFrame;
	-- local sp = SM_FindSpell(spell);
	-- if ( not sp ) then return; end
	-- local cd = GetSpellCooldown(sp);
	-- if ( not cf.channeling and cd<=1.5 ) then
		-- cast(spell);
	-- end
-- end
-- Channel = SM_Channel;

function SuperMacro_EventsFrame_OnEvent()
	local ev = event;
	if ( this.events[ev] ) then
		for macro in pairs(this.events[ev]) do
			if ( strfind(macro, "^SUPER") ) then
				RunSuperMacro( strsub( macro, 6) );
			else
				RunMacro( macro );
			end
		end
	end
end