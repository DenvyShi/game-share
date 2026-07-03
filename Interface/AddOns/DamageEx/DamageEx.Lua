--********************************************************
--  感谢bbs.wowar.com的 magicdragoon 玩家给Dex做的部分改进
--********************************************************

local dex_lastani = 1;
local dex_bottom = 0;
local DEX_MAXANI = 20;
local DEX_TEXTSIZE = 22;
local DEX_Registered = 0;
local DEX_aoeStartTimer = 0;
local DEX_aoeNew = 1;
local DEX_aoeId = 1;
local DEX_aoeDct = 0;
local DEX_ExtraAttList = {0,0,0,0,0};
local DEX_ExtraAttCount = 0;
local DEX_ExtraAttCur = 1;
local DEX_ExtraTimer = 0;
local DEX_logLine = 10;
local DEX_logTime = 10;

local dex_fixfor_sw_stats = true;
local dex_fixSW_Timer = 0;

DEX_DAMAGE_TYPE_HIT = 0;
DEX_DAMAGE_TYPE_SPELL = 1;
DEX_DAMAGE_TYPE_PERIODIC = 2;
DEX_DAMAGE_TYPE_HEALTH = 3;
DEX_DAMAGE_TYPE_PET = 4;
DEX_FONTNAME = "Fonts\\zzz.ttf";

DEX_MOVTYP_NORMAL = 0;
DEX_MOVTYP_AOE = 1;
DEX_MOVTYP_PET = 2;
DEX_MOVTYP_NONE = 99;

local DEX_critFlag = 0;
local DEX_logFlag = 1;

local dex_AniData = {
		["aniText1"] = {},					-- These are structures that define the animation data
		["aniText2"] = {},
		["aniText3"] = {},
		["aniText4"] = {},
		["aniText5"] = {},
		["aniText6"] = {},					-- These are structures that define the animation data
		["aniText7"] = {},
		["aniText8"] = {},
		["aniText9"] = {},
		["aniText10"] = {},
		["aniText11"] = {},					-- These are structures that define the animation data
		["aniText12"] = {},
		["aniText13"] = {},
		["aniText14"] = {},
		["aniText15"] = {},
		["aniText16"] = {},					-- These are structures that define the animation data
		["aniText17"] = {},
		["aniText18"] = {},
		["aniText19"] = {},
		["aniText20"] = {},
}

DEXPlayer = nil;
DEX_DEFAULT_CFG = {
	["DEX_Enable"] = 1,
	["DEX_ShowWithMess"] = 0,
	["DEX_ShowSpellName"] = 1,
	["DEX_ShowNameOnCrit"] = 1,
	["DEX_ShowNameOnMiss"] = 1,
	["DEX_ShowDamageNormal"] = 1,
	["DEX_ShowDamageSkill"] = 1,
	["DEX_ShowDamagePeriodic"] = 1,
	["DEX_ShowDamageShield"] = 1,
	["DEX_ShowDamageHealth"] = 1,
	["DEX_ShowDamagePet"] = 1,
	["DEX_ShowDamageWoW"] = 0,
	["DEX_ShowMaxDamage"] = 0,	
	["DEX_Speed"] = 80,
	["DEX_PosX"] = 0,
	["DEX_PosY"] = 100,
	["DEX_FontSize"] = 25,
	["DEX_Font"] = 2,
	["DEX_ColorNormal"] = {1,1,1},
	["DEX_ColorSkill"] = {1,1,0},
	["DEX_ColorPeriodic"] = {1,0,1},
	["DEX_ColorHealth"] = {0,1,0},
	["DEX_ColorPet"] = {1,0.6,0},
	["DEX_LOGLINE"] = 10,
	["DEX_LOGTIME"] = 10,
}


function DEX_Debug(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff10ff00"..msg.."|r");
end

function DEX_OnLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("ADDON_LOADED");
	DEX_Set_WOWDamage();
end

function DEX_Init()
	if (DEX_Registered == 1) then return;end
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");	-- Melee you do on things.
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");

	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");	-- Your spells that damage other things.

	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");

	this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");		-- Thorns on self.	

	if DEX_SAVE == nil then DEX_SAVE = {};end
	DEXPlayer = DEX_Config_GetPlayer();
	DEX_Debug(DEX_Version);
	DEX_Registered = 1
	
	SlashCmdList["DEX"] = DEX_showMenu;
	SLASH_DEX1 = "/dex";
	
	if(myAddOnsList) then
		myAddOnsList.DEX = {
			name = "Damage Text",
			description = "DamageEx",
			version = DEX_Version,			
			frame = "DEX_TEXT",			
			optionsframe = "DEXOptions",
			category = MYADDONS_CATEGORY_COMBAT
		};		
	end
	
	-- Add my options frame to the global UI panel list
	UIPanelWindows["DEXOptions"] = {area = "center", pushable = 0};
	
	DEX_aniInit();
	DEX_staticInit();
end


function DEX_Reset()
	DEX_hideMenu();
	DEX_SAVE[UnitName("player").." of "..GetCVar("realmName")] = nil;
	DEXPlayer = DEX_Config_GetPlayer();	
	DEX_showMenu();	
end
function DEX_Config_GetPlayer()
	if (DEX_SAVE[UnitName("player").." of "..GetCVar("realmName")] == nil) then
		DEX_Config_NewPlayer(UnitName("player").." of "..GetCVar("realmName"));
	end
	return DEX_SAVE[UnitName("player").." of "..GetCVar("realmName")];
end

--Set up a default config
function DEX_Config_NewPlayer(PlayerName)
	DEX_SAVE[PlayerName] = DEX_clone(DEX_DEFAULT_CFG);
end
function DEX_Get(option)
	if (DEXPlayer ~= nil) and (DEXPlayer[option] ~= nil) then
		return DEXPlayer[option];
	else
		return DEX_DEFAULT_CFG[option];
	end
end

function DEX_Set(option, newVal)
	if (DEXPlayer ~= nil) then
		if ( option ) then
			DEXPlayer[option] = newVal;
		end
	end
end

function DEX_clone(t)
  local new = {};
  local i, v = next(t, nil);
  while i do
  	if type(v)=="table" then 
  		v=DEX_clone(v);
  	end 
    new[i] = v;
    i, v = next(t, i);
  end
  return new;
end

function DEX_OnEvent(event, arg1, arg2, arg3, arg4)
	if (event == "VARIABLES_LOADED") or ( event == "ADDON_LOADED" and arg1 == "DamegeEx" ) or (event=="PLAYER_ENTERING_WORLD") then
		DEX_Init();
		if event == "PLAYER_ENTERING_WORLD" and dex_fixfor_sw_stats == true then			
			dex_fixSW_Timer = GetTime();	
		end
		return;
	end
	if DEX_Registered ~= 1 then return;end
	if DEX_Get("DEX_Enable") ~= 1 then return;end
	if dex_fixfor_sw_stats == true then return;end;
	
	if event == "CHAT_MSG_SPELL_SELF_BUFF" then		
		for spell, mob, health in string.gfind(arg1, DEX_HealthSearch) do
			DEX_AddText(health,spell,DEX_DAMAGE_TYPE_HEALTH,0);
			return;
		end
		for spell, mob, health in string.gfind(arg1, DEX_CritHealthSearch) do
			DEX_AddText(health,spell,DEX_DAMAGE_TYPE_HEALTH,1);
			return;
		end
		for aa, bb in string.gfind(arg1, DEX_ExtraAttSearch) do
			DEX_ExtraAttack(tonumber(bb));			
			return;
		end
		for aa, bb in string.gfind(arg1, DEX_ExtraAttSingularSearch) do
			DEX_ExtraAttack(tonumber(bb));	
			return;
		end
	end
	if event == "CHAT_MSG_COMBAT_PET_HITS" then		
		for aaa, creatureName, damage in string.gfind(arg1, DEX_PET_HitSearch) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_PET,0);
			return;
		end
		for aaa, creatureName, damage in string.gfind(arg1, DEX_PET_CritHitSearch1) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_PET,1);
			return;
		end
		for aaa, creatureName, damage in string.gfind(arg1, DEX_PET_CritHitSearch2) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_PET,1);
			return;
		end
	end
	if event == "CHAT_MSG_SPELL_PET_DAMAGE" then		
		for aaa, spell, creatureName, damage in string.gfind(arg1, DEX_PET_SpellSearch) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_PET,0);
			return;
		end
		for aaa, spell, creatureName, damage in string.gfind(arg1, DEX_PET_CritSpellSearch) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_PET,1);
			return;
		end
	end
	if(	event == "CHAT_MSG_COMBAT_SELF_HITS" ) then			
		for creatureName, damage in string.gfind(arg1, DEX_HitSearch) do			
			for blockPoint in string.gfind(arg1, DEX_BlockSearchSe) do
				DEX_AddText(damage.."-"..blockPoint,spell,DEX_DAMAGE_TYPE_HIT,0);
				return;
			end
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_HIT,0);
			return;
		end
		for creatureName, damage in string.gfind(arg1, DEX_CritHitSearch) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_HIT,1);
			return;
		end		
	end
	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" ) then		
		for spell, creatureName, damage in string.gfind(arg1, DEX_SpellHitSearch1) do
			for blockPoint in string.gfind(arg1, DEX_BlockSearchSe) do
				DEX_AddText(damage.."-"..blockPoint,spell,DEX_DAMAGE_TYPE_SPELL,0);
				return;
			end
			DEX_AddText(damage,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, DEX_CritSpellHitSearch1) do
			for blockPoint in string.gfind(arg1, DEX_BlockSearchSe) do
				DEX_AddText(damage.."-"..blockPoint,spell,DEX_DAMAGE_TYPE_SPELL,0);
				return;
			end
			DEX_AddText(damage,spell,DEX_DAMAGE_TYPE_SPELL,1);
			return;
		end
		for spell, creatureName, damage, damageType in string.gfind(arg1, DEX_SpellHitSearch2) do
			for blockPoint in string.gfind(arg1, DEX_BlockSearchSe) do
				DEX_AddText(damage.."-"..blockPoint,spell,DEX_DAMAGE_TYPE_SPELL,0);
				return;
			end
			DEX_AddText(damage,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName, damage, damageType in string.gfind(arg1, DEX_CritSpellHitSearch2) do
			for blockPoint in string.gfind(arg1, DEX_BlockSearchSe) do
				DEX_AddText(damage.."-"..blockPoint,spell,DEX_DAMAGE_TYPE_SPELL,0);
				return;
			end
			DEX_AddText(damage,spell,DEX_DAMAGE_TYPE_SPELL,1);
			return;
		end
		
		for spell, creatureName in string.gfind(arg1,DEX_SpellMissSearch) do
			DEX_AddText(DEX_TXT_MISS,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellImmSearch) do
			DEX_AddText(DEX_TXT_IMM,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellAbsorbSearch) do
			DEX_AddText(DEX_TXT_ABSORB,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellParrySearch) do
			DEX_AddText(DEX_TXT_PARRY,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellDodgeSearch) do
			DEX_AddText(DEX_TXT_DODGE,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end		
		for spell, creatureName in string.gfind(arg1,DEX_SpellResistSearch) do
			DEX_AddText(DEX_TXT_RESIST,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellDeflectedSearch) do
			DEX_AddText(DEX_TXT_DEFLECTED,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellBlockSearch) do
			DEX_AddText(DEX_TXT_BLOCK,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellEvadeSearch) do
			DEX_AddText(DEX_TXT_EVADE,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
	end

	if ( event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") then
		for spell, creatureName, damage, damageType in string.gfind(arg1, DEX_PeriSearch) do
			for blockPoint in string.gfind(arg1, DEX_BlockSearchSe) do
				DEX_AddText(damage.."-"..blockPoint,spell,DEX_DAMAGE_TYPE_PERIODIC,0);
				return;
			end
			DEX_AddText(damage,spell,DEX_DAMAGE_TYPE_PERIODIC,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellAbsorbSearch) do
			DEX_AddText(DEX_TXT_ABSORB,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
		for spell, creatureName in string.gfind(arg1,DEX_SpellResistSearch) do
			DEX_AddText(DEX_TXT_RESIST,spell,DEX_DAMAGE_TYPE_SPELL,0);
			return;
		end
	end
	
	if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then	
		for damage, damageType, creatureName in string.gfind(arg1, DEX_ShieldSearch) do
			if DEX_Get("DEX_ShowDamageShield") == 1 then DEX_AddText(damage,DEX_TXT_SHIELD,DEX_DAMAGE_TYPE_SPELL,0);end
			return;
		end
		for damage, damageType, creatureName in string.gfind(arg1, DEX_CritPeriSearch) do
			DEX_AddText(damage,"",DEX_DAMAGE_TYPE_PERIODIC,0);
			return;
		end
	end
	
	if event == "CHAT_MSG_COMBAT_SELF_MISSES" then		
		for creatureName in string.gfind(arg1, DEX_MissSearch) do
			DEX_AddText(DEX_TXT_MISS,"",DEX_DAMAGE_TYPE_HIT,0);
			return;
		end
		for creatureName in string.gfind(arg1, DEX_ParrySearch) do
			DEX_AddText(DEX_TXT_PARRY,"",DEX_DAMAGE_TYPE_HIT,0);
			return;
		end
		for creatureName in string.gfind(arg1, DEX_DodgeSearch) do
			DEX_AddText(DEX_TXT_DODGE,"",DEX_DAMAGE_TYPE_HIT,0);
			return;
		end
		for creatureName in string.gfind(arg1, DEX_ImmSearch) do
			DEX_AddText(DEX_TXT_IMM,"",DEX_DAMAGE_TYPE_HIT,0);
			return;
		end
		for creatureName in string.gfind(arg1, DEX_AbsorbSearch) do
			DEX_AddText(DEX_TXT_ABSORB,"",DEX_DAMAGE_TYPE_HIT,0);
			return;
		end
	end	
end

function DEX_GameUpdate(arg1)
	dex_bottom = 99999;
	if dex_fixSW_Timer ~= 0 then
		if GetTime() - dex_fixSW_Timer > 1 then
			if dex_fixfor_sw_stats == true then
				DEX_AllSearch_Filter();
				dex_fixfor_sw_stats = false;
				dex_fixSW_Timer = 0;	
			end
		end
	end
	if DEX_Get("DEX_ShowWithMess") == 0 then
		for key, value in dex_AniData do		
			if (value.Active == true) then
				DEX_doAni(value);			
			end
		end
	else
		for key, value in dex_AniData do		
			if (value.Active == true) then
				DEX_doLog(value);			
			end
		end
	end
end

function DEX_RefressBottom(ani)
	if ani.moveTyp == DEX_MOVTYP_NORMAL then
		if ani.posY < dex_bottom then dex_bottom = ani.posY;end
	end
end

function DEX_doLog(ani)
	local thetime = GetTime() - ani.starttime;
	if thetime < DEX_logTime and thetime > 0 then
		ani.FObject:SetAlpha(1);
	else
		if thetime < DEX_logTime + 3 then			
			ani.FObject:SetAlpha(1 - (thetime - DEX_logTime) / 3);
		else
			DEX_aniReset(ani);
		end
	end
end

function DEX_doAni(ani)
	local thetime = GetTime() - ani.starttime;
	if thetime < 1.5 and thetime > 0 then
		if thetime < 0.1 then
			ani.alpha = thetime * 10;
		elseif thetime < 1 then 
			ani.alpha = 1;
		else
			ani.alpha = 1 - (thetime - 1) * 2;
		end
		if ani.Extra ~= 0 and thetime < 0.7 then
			if ani.Extra > 0 then
				ani.posX = ani.Extra + sin(thetime / 0.7 * 180) * 50;
			else
				ani.posX = ani.Extra - sin(thetime / 0.7 * 180) * 50;
			end
		end
		if ani.moveTyp == DEX_MOVTYP_NORMAL then
			ani.posY = thetime * DEX_Get("DEX_Speed") + ani.baseY;
			ani.posYbak	= ani.posY;
			DEX_RefressBottom(ani);
		elseif ani.moveTyp == DEX_MOVTYP_AOE then
			if thetime < 0.2 then ani.posY = thetime * 30 + 30;else ani.posY = 36;end
			if thetime < 0.1 then				
				ani.alpha = thetime * 10;
			elseif thetime < 0.7 then 
				ani.alpha = 1;
			else
				ani.alpha = 1 - (thetime - 0.7) * 5;
			end			
			if thetime > 0.9 then DEX_aniClear(ani);return;end
		elseif ani.moveTyp == DEX_MOVTYP_PET then
			ani.posY = thetime * (DEX_Get("DEX_Speed") * 0.75) + ani.baseY;		
		end		
		if ani.crit == 1 then			
			local baseSize = DEX_TEXTSIZE + 4 + ani.critId * 2;
			if ani.critTyp == 0 then
				if thetime < 0.05 then 
					ani.height = DEX_TEXTSIZE * ani.zoom;
				elseif thetime < 0.30 then 			
					ani.height = (1 - (thetime - 0.05) / 0.25) * DEX_TEXTSIZE * ani.zoom + DEX_TEXTSIZE;
				elseif ani.height ~= baseSize then
					ani.height = baseSize;
					DEX_SetFontSize(ani,ani.height);				
				end
			else
				if thetime < 0.1 then 
					ani.height = baseSize * thetime / 0.1 + baseSize * ani.zoom;
				elseif thetime < 0.35 then
					ani.height = baseSize * ani.zoom * (1 - (thetime - 0.1) / 0.25) + baseSize;				
				elseif ani.height ~= baseSize then
					ani.height = baseSize;	
					DEX_SetFontSize(ani,ani.height);
				end
				ani.posY = ani.posYbak + ani.height / 2 - baseSize / 2;
			end
			ani.FObject:SetTextHeight(ani.height);
		end
		ani.FObject:SetAlpha(ani.alpha);
		ani.FObject:SetPoint("CENTER", "UIParent", "CENTER", ani.posX + DEX_Get("DEX_PosX"), ani.posY + DEX_Get("DEX_PosY"));
		--DEX_RefressBottom(ani);
	else
		if thetime >= 1.5 then DEX_aniClear(ani);end
	end
end

function DEX_aniClear(ani)
	if ani.crit == 1 then
		if ani.critId < DEX_critFlag then DEX_critFlag = ani.critId;end
	end
	DEX_aniReset(ani);
end
function DEX_IsNumber(n)
	if n >= "0" and n <= "9" then return true;end
	return false;
end


function DEX_AddText(damage,spell,damagetype,crit)
	if spell == nil then spell = "";end
	if DEX_ExtraAttCount > 0 then
		if GetTime() - DEX_ExtraTimer > 0.4 then
			DEX_ExtraAttCount = 0;
			DEX_ExtraAttCur = 1;
		end
	end
	local color = {1,1,1};
	if damagetype == DEX_DAMAGE_TYPE_HIT then
		if DEX_Get("DEX_ShowDamageNormal") ~= 1 then return;end
		color = DEX_Get("DEX_ColorNormal");
	elseif damagetype == DEX_DAMAGE_TYPE_SPELL then
		if DEX_Get("DEX_ShowDamageSkill") ~= 1 then return;end
		color = DEX_Get("DEX_ColorSkill");
	elseif damagetype == DEX_DAMAGE_TYPE_PERIODIC then
		if DEX_Get("DEX_ShowDamagePeriodic") ~= 1 then return;end
		color = DEX_Get("DEX_ColorPeriodic");
	elseif damagetype == DEX_DAMAGE_TYPE_HEALTH then
		if DEX_Get("DEX_ShowDamageHealth") ~= 1 then return;end
		color = DEX_Get("DEX_ColorHealth");
	elseif damagetype == DEX_DAMAGE_TYPE_PET then
		if DEX_Get("DEX_ShowDamagePet") ~= 1 then return;end
		color = DEX_Get("DEX_ColorPet");
	end
	
	local isAOE = false;
	if spell ~= "" then
		for i = 1,DEX_AOE_COUNT do
			--DEX_Debug(spell);
			if spell == DEX_AOE_LIST[i] then
				isAOE = true;
			end
		end
	end
			
	if DEX_Get("DEX_ShowNameOnCrit") == 1 and crit ~= 1 and tonumber(damage) then spell = "";end
	if DEX_Get("DEX_ShowNameOnMiss") == 1 then	
		if tonumber(damage) ~= nil and DEX_Get("DEX_ShowNameOnCrit") ~= 1 then spell = "";end
	end
	if DEX_Get("DEX_ShowSpellName") ~= 1 then spell = "";end

	if DEX_Get("DEX_ShowWithMess") == 1 then
		local Maxline = DEX_logLine;
		local anitmp;
		if crit == 1 then damage = "致命! "..damage; end
		for i = 1,10 do
			anitmp = dex_AniData["aniText"..i];
			anitmp.posY = anitmp.posY + DEX_Get("DEX_FontSize");
			anitmp.FObject:SetPoint("CENTER", "UIParent", "CENTER", anitmp.posX + DEX_Get("DEX_PosX"), anitmp.posY + DEX_Get("DEX_PosY"));
		end
		anitmp = dex_AniData["aniText"..dex_lastani];
		DEX_aniReset(anitmp);
		anitmp.starttime = GetTime();
		anitmp.Active = true;
		anitmp.posY = 0;
		anitmp.posX = 0;
		anitmp.FObject:SetText(damage.." "..spell);
		anitmp.FObject:SetAlpha(1);
		anitmp.FObject:SetTextColor(color[1], color[2], color[3]);				
		anitmp.FObject:SetPoint("CENTER", "UIParent", "CENTER", anitmp.posX + DEX_Get("DEX_PosX"), anitmp.posY + DEX_Get("DEX_PosY"));
		dex_lastani = dex_lastani + 1;
		if dex_lastani > DEX_logLine then dex_lastani = 1;end
		return;
	end

	local ani = dex_AniData["aniText"..dex_lastani];
	DEX_aniReset(ani);
	ani.Active = true;
	ani.height = DEX_TEXTSIZE;
	ani.crit = crit;
	
	if damagetype == DEX_DAMAGE_TYPE_PET then
		ani.posY = -20;
		ani.posX = ani.posX - DEX_TEXTSIZE * 2;
		ani.moveTyp = DEX_MOVTYP_PET;
	end
	
	if ani.moveTyp == DEX_MOVTYP_NORMAL then		
		if dex_bottom - ani.baseY < ani.height + 2 then			
			local fixY = ani.height + 2 + ani.baseY - dex_bottom;
			local anitmp;
			for i = 1,DEX_MAXANI do
				if i ~= dex_lastani then
					anitmp = dex_AniData["aniText"..i];
					anitmp.baseY = anitmp.baseY + fixY;
				end
			end
		end
	end
		
	if crit == 1 then		
		if damagetype ~= DEX_DAMAGE_TYPE_PET then
			if spell == "" then
				ani.zoom = 2;
			else
				ani.zoom = 0.6;
			end
		else
			ani.zoom = 1.5;
		end		
		if DEX_Get("DEX_ShowSpellName") == 1 and DEX_Get("DEX_ShowNameOnCrit") == 1 and spell ~= "" then
			ani.zoom = 0.8;
		else
			ani.critTyp = 1;
		end
		if damagetype ~= DEX_DAMAGE_TYPE_PET then
			ani.critId = DEX_critFlag;
			--ani.posX = ani.posX + DEX_TEXTSIZE * 2 + DEX_critFlag * 30;
			--ani.posY = DEX_critFlag * DEX_TEXTSIZE;
			if DEX_ExtraAttCur > DEX_ExtraAttCount and DEX_ExtraAttCount == 0 then
				ani.posX = random(120) - 60;
				ani.posY = random(80) - 20;
				ani.moveTyp = DEX_MOVTYP_NONE;			
			end
			
			ani.posYbak = ani.posY;
	
			DEX_critFlag = DEX_critFlag + 1;		
			if DEX_critFlag > 3 then DEX_critFlag = 0;end
		end
	end
	ani.starttime = GetTime();
	if isAOE then
		i = DEX_AOE_COUNT + 1;
		ani.crit = 0;
		ani.moveTyp = DEX_MOVTYP_AOE;
		color = DEX_Get("DEX_ColorSkill");
		if DEX_aoeNew == 1 then	DEX_AoeReset();end
		
		if GetTime() - DEX_aoeStartTimer >= 0.7 then DEX_AoeReset(); end
		ani.posY = 30;
		if DEX_aoeDct == 0 then
			ani.posX = -DEX_TEXTSIZE * 2 * DEX_aoeId - 20;
		else
			ani.posX = DEX_TEXTSIZE * 2 * DEX_aoeId + 20;
		end
		ani.starttime = GetTime() + DEX_aoeId * 0.05;
		
		DEX_aoeDct = DEX_aoeDct + 1;
		if DEX_aoeDct >= 2 then
			DEX_aoeId = DEX_aoeId + 1;
			DEX_aoeDct = 0;
		end
		spell = "";		
	end
	
	if DEX_ExtraAttCur <= DEX_ExtraAttCount then
		DEX_ExtraAttList[DEX_ExtraAttCur] = dex_lastani;
		if DEX_ExtraAttCur > 0 then
			local tmpani;
			--damage = "+"..damage;
			ani.FObject:SetText(damage);
			
			tmpani = dex_AniData["aniText"..DEX_ExtraAttList[0]];			
			if DEX_ExtraAttCur == 1 then
				ani.posX = tmpani.posX + tmpani.FObject:GetStringWidth()/2 + ani.FObject:GetStringWidth()/2 + 4;
			else
				ani.posX = tmpani.posX - tmpani.FObject:GetStringWidth()/2 - ani.FObject:GetStringWidth()/2 - 4;
			end
			ani.posY = tmpani.posY;
			ani.baseY = tmpani.baseY;
			ani.Extra = ani.posX;
			--tmpani = dex_AniData["aniText"..DEX_ExtraAttList[DEX_ExtraAttCur - 1]];
			--ani.posX = tmpani.posX + tmpani.FObject:GetStringWidth()/2 + ani.FObject:GetStringWidth()/2 + 4;
			--ani.posY = tmpani.posY;
			--ani.baseY = tmpani.baseY;
			--ani.crit = 1;
			--ani.critTyp = 0;
			ani.starttime = tmpani.starttime;
		end
		DEX_ExtraAttCur = DEX_ExtraAttCur + 1;
	else
		DEX_ExtraAttCount = 0;
		DEX_ExtraAttCur = 1;
	end
	
	ani.FObject:SetText(damage.." "..spell);
		
	DEX_RefressBottom(ani);
	ani.FObject:SetTextColor(color[1], color[2], color[3]);	
	ani.FObject:SetPoint("CENTER", "UIParent", "CENTER", ani.posX + DEX_Get("DEX_PosX"), ani.posY + DEX_Get("DEX_PosY"));
	ani.FObject:SetAlpha(ani.alpha);
	
	dex_lastani = dex_lastani + 1;
	if dex_lastani > DEX_MAXANI then dex_lastani = tonumber(DEX_Get("DEX_LOGLINE")) * tonumber(DEX_Get("DEX_ShowWithMess")) + 1;end
end

function DEX_AoeReset()
	DEX_aoeNew = 0;
	DEX_aoeId = 1;
	DEX_aoeDct = 0;
	DEX_aoeStartTimer = GetTime();	
end

function DEX_aniInit()
	local FontNumber;
	local FontSize;
	FontNumber = DEX_Get("DEX_Font");
	FontSize = DEX_Get("DEX_FontSize");
	dex_lastani = 1;
	
	--字体：伤害数字的类型
	if FontNumber == 1 then
		DEX_FONTNAME = "Fonts\\FZJZJW.ttf";
	elseif FontNumber == 2 then
		DEX_FONTNAME = "Interface\\AddOns\\DamageEx\\DexFonts\\T1.ttf";
	else
		DEX_FONTNAME = "Interface\\AddOns\\DamageEx\\DexFonts\\T2.ttf";
	end
	
	DEX_TEXTSIZE = DEX_Get("DEX_FontSize");
	for key, value in dex_AniData do
		value.FObject = getglobal("DEX"..key);
		DEX_aniReset(value);
	end
	DEX_Set_WOWDamage();
end

function DEX_staticInit()
	DEX_logLine = DEX_Get("DEX_LOGLINE");
	DEX_logTime = DEX_Get("DEX_LOGTIME");
end

function DEX_aniReset(aniData)	
	aniData.Active = false;
	aniData.crit = false;
	aniData.moveTyp = DEX_MOVTYP_NORMAL;
	aniData.critId = 0;
	aniData.critTyp = 0;
	aniData.posY = 0;
	aniData.posX = 0;
	aniData.posYbak = 0;
	aniData.zoom = 0;
	aniData.baseY = 0;
	aniData.alpha = 0;
	aniData.height = DEX_TEXTSIZE;
	aniData.delay = 0;--Dennie Add
	aniData.lastupdate = 0;
	aniData.Extra = 0;
	
	DEX_SetFontSize(aniData,aniData.height);
	aniData.FObject:SetTextHeight(aniData.height);
	aniData.FObject:SetAlpha(aniData.alpha);
	aniData.FObject:SetPoint("CENTER", "UIParent", "CENTER", aniData.posX, aniData.posY);
end

function DEX_SetFontSize(ani,size)
	ani.FObject:SetFont(DEX_FONTNAME, size);
end

function DEX_ExtraAttack(num)
	DEX_ExtraAttCount = num;
	DEX_ExtraAttCur = 0;
	DEX_ExtraTimer = GetTime();
end
function DEX_AllSearch_Filter()
	if dex_fixfor_sw_stats == false then return;end
	DEX_HitSearch = DEX_Filter(COMBATHITSELFOTHER);	
	DEX_CritHitSearch = DEX_Filter(COMBATHITCRITSELFOTHER);
	DEX_SpellHitSearch1 = DEX_Filter(SPELLLOGSELFOTHER);
	DEX_CritSpellHitSearch1 = DEX_Filter(SPELLLOGCRITSELFOTHER);
	DEX_SpellHitSearch2 = DEX_Filter(SPELLLOGSCHOOLSELFOTHER);
	DEX_CritSpellHitSearch2 = DEX_Filter(SPELLLOGCRITSCHOOLSELFOTHER);
	DEX_PeriSearch = DEX_Filter(PERIODICAURADAMAGESELFOTHER);
	DEX_CritPeriSearch = DEX_Filter(DAMAGESHIELDSELFOTHER);

	DEX_MissSearch = DEX_Filter(MISSEDSELFOTHER);
	DEX_ParrySearch = DEX_Filter(VSPARRYSELFOTHER);
	DEX_DodgeSearch = DEX_Filter(VSDEFLECTSELFOTHER);
	DEX_ImmSearch = DEX_Filter(VSIMMUNESELFOTHER);
	DEX_AbsorbSearch = DEX_Filter(VSABSORBSELFOTHER);

	DEX_SpellImmSearch = DEX_Filter(SPELLIMMUNESELFOTHER);
	DEX_SpellMissSearch = DEX_Filter(SPELLMISSSELFOTHER);
	DEX_SpellAbsorbSearch = DEX_Filter(SPELLLOGABSORBSELFOTHER);
	DEX_SpellParrySearch = DEX_Filter(SPELLPARRIEDSELFOTHER);--so.....
	DEX_SpellDodgeSearch = DEX_Filter(SPELLDODGEDSELFOTHER);
	DEX_SpellEvadeSearch = DEX_Filter(SPELLEVADEDSELFOTHER);
	DEX_SpellResistSearch = DEX_Filter(SPELLRESISTSELFOTHER);
	DEX_SpellDeflectedSearch = DEX_Filter(SPELLDEFLECTEDSELFOTHER);
	DEX_SpellBlockSearch = DEX_Filter(SPELLBLOCKEDSELFOTHER);

	DEX_CritHealthSearch = DEX_Filter(HEALEDCRITSELFOTHER);

	DEX_ShieldSearch = DEX_Filter(DAMAGESHIELDSELFOTHER);

	DEX_ExtraAttSearch = DEX_Filter(SPELLEXTRAATTACKSSELF);
	DEX_ExtraAttSingularSearch = DEX_Filter(SPELLEXTRAATTACKSSELF_SINGULAR);
end
function DEX_Filter(name)
	if name == nil then return "ERROR:nil (DEX_Filter)";end
	local str = name;
	local len = string.len(str);
	local i = 1;
	local index = 1;
	local st = -1;
	local ed;
	while i <= len do
		if string.sub(str,i,i) == "%" then
			st = i;
		end
		if (string.sub(str,i,i) == "s" or string.sub(str,i,i) == "d") and st ~= -1 then
			ed = i;
			if string.sub(str,i,i) == "s" then
				str = string.sub(str,1,st - 1).."(.+)"..string.sub(str,ed + 1,string.len(str));
				i = st + 4 - 1;
				len = len + 2; 
			else
				str = string.sub(str,1,st - 1).."(%d+)"..string.sub(str,ed + 1,string.len(str));
				i = st + 5 - 1;
				len = len + 3;
			end
			st = -1;
		end		
		i = i + 1;
	end
	return str;
end

function DEX_Set_WOWDamage()
	if (DEX_Get("DEX_ShowDamageWoW") == 0) then
		SetCVar("CombatDamage", 0);
	else
		SetCVar("CombatDamage", 1);
	end
end