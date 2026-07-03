function DSCT_SP_OnLoad()
	if getglobal("DSCTOptions") == nil then return;end
	local button1 = getglobal("DSCTOptionsSpellAlert");
	button1:SetParent("DSCTOptions");
	button1:SetPoint("TOPLEFT", "DSCTOptions", "TOPLEFT", 20 ,-200 );
end

function DSCT_SPELLALERT_SEARCH(arg1,search)
	local mob, spell;
	for mob, spell in string.gfind(arg1, search[1]) do
		if(not DSCT_isParty(mob)) then
			if DSCT_Get("SHORTALERT") == 1 then
				DSCT_Display_Toggle("SHOWSPELLALERT",1,nil,DSCT_SHORTALERT..SpellAlert_Spell_head..spell..search[3]);
			else
				DSCT_Display_Toggle("SHOWSPELLALERT",1,nil,SpellAlert_Mob_head..mob..search[2]..SpellAlert_Spell_head..spell.."|r"..DSCT_BUFF_END);
			end
			DSCT_FixSpellTime(spell);
			return true;
		end
	end
	return false;
end

function DSCT_SP_OnEvent(event, arg1, arg2, arg3)
	-- start spell alert
	if event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
		if DSCT_Get("SHOWSPELLALERT") ~= 0 then
			if DSCT_Get("SHOWSA_BEGINCAST") == 1 then DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_BEGIN_CAST);end
		end
		return;
	elseif (event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF") then		
		if DSCT_Get("SHOWSPELLALERT") ~= 0 then
		--[[
			for mob, amountk, spell in string.gfind(arg1, DSCT_SA_GAIN_POWER) do
				return;
			end			]]
			for mob, amountk, spell in string.gfind(arg1, DSCT_SA_CASTS_PLY_VS_PLY) do
				return;
			end
			if DSCT_Get("SHOWSA_BEGINCAST") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_BEGIN_CAST) == true then return;end
			end
			if DSCT_Get("SHOWSA_CAST") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_CASTS_TOTEM) == true  then return;end
			end
			if DSCT_Get("SHOWSA_GAIN") == 1 then
				DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_GAIN_BUFF);
			end
		end
		return;
	elseif (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF" or
					event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") then
		for mob, amountk, spell in string.gfind(arg1, DSCT_SA_CASTS_PLY_VS_PLY) do
			return;
		end
		if(DSCT_Get("SHOWSPELLALERT") ~= 0) then
			if DSCT_Get("SHOWSA_BEGINCAST") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_BEGIN_CAST) == true then return;end
			end
			if DSCT_Get("SHOWSA_CAST") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_CASTS_TOTEM) == true  then return;end
			end
		end
		return;
	elseif (event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS") then
		if(DSCT_Get("SHOWSPELLALERT") ~= 0) then
		--[[
			for mob, amountk, spell in string.gfind(arg1, DSCT_SA_GAIN_POWER) do
				return;
			end]]
			if DSCT_Get("SHOWSA_GAIN") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_GAIN_BUFF) == true  then return;end
			end
			if DSCT_Get("SHOWSA_BEGINCAST") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SAEX_PERFORMOTHERSTART) == true  then return;end
			end
		end
		return;
	elseif (event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS") then		
		if(DSCT_Get("SHOWSPELLALERT") ~= 0) then
		--[[
			for mob, amountk, spell in string.gfind(arg1, DSCT_SA_GAIN_POWER) do
				return;
			end]]
			if DSCT_Get("SHOWSA_GAIN") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SA_GAIN_BUFF) == true  then return;end
			end
			if DSCT_Get("SHOWSA_BEGINCAST") == 1 then
				if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SAEX_PERFORMOTHERSTART) == true  then return;end
			end
			--if DSCT_SPELLALERT_SEARCH(arg1, DSCT_SAEX_PERFORMGOOTHER) == true then return;end
		end
		return;
	elseif event == "CHAT_MSG_MONSTER_EMOTE" then
		if(DSCT_Get("SHOWEMOTE") ~= 0) then
			local name = arg2;
			if (not name) then
				name = DSCT_NO_TARGET;
			end
			if (arg1) then								
				DSCT_Display_Toggle("SHOWEMOTE",1,nil,name..string.sub(arg1,3)); --直接用arg1会出现乱码，修改by狗血编剧男	
			end
		end
		return;
	elseif event == "CHAT_MSG_MONSTER_YELL" then
		if(DSCT_Get("SHOWYELL") ~= 0) then
			local name = arg2;
			if (not name) then
				name = DSCT_NO_TARGET;
			end
			if (arg1) then								
				DSCT_Display_Toggle("SHOWYELL",1,nil,name..":  "..arg1);					
			end
		end
		return;	
	end
end

function DSCT_FixSpellTime(spellname)
	if DSCT_Get("SHOWSPELLTIMER") ~= 1 then return;end
	local bak = DENNIE_cusMessLast;
	DENNIE_cusMessLast = DENNIE_cusMessLast - 1;
	if DENNIE_cusMessLast < 1 then DENNIE_cusMessLast = 3;end
	local adat = arrCusMessData["cusMessData"..DENNIE_cusMessLast];
	if spellname then
		if DSCT_CastTime[spellname] then
			adat.SpellTime = DSCT_CastTime[spellname].t;
			adat.SpellStartTimer = adat.lastupdate;
		end
	end
	DENNIE_cusMessLast = bak;
end