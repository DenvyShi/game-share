-- global flags/vars
DSCTPlayer = nil;
DSCT_NameRegistered = 0;
initCE_OK = false;
local fixfor_sw_stats = true;
local accModeFalg = true;

--UPDATE_FACTION

currentclass = nil;
DSCT_LastHPPercent = 0;
DSCT_LastTargetHPPercent = 0;
DSCT_LastManaPercent = 0;
DSCT_EventRecord = nil;
DSCT_This = nil;


-- local constants
DSCT_Ani_Fix = {{0,0,1},{0,0,1},{0,0,1}};
DSCT_DIR3_LIST = {{0,0},{100,40},{100,-40},{-100,-40},{-100,40}};

DENNIE_cusMessLast = 1;
DENNIE_CUSMESS_TEXTSIZE = 18;
DENNIE_cusMess_posX = 0;
DENNIE_cusMess_posY = 180;
DENNIE_ani_posX = 0;
DENNIE_ani_posY = 0;
DSCT_HEX_LIST = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}

SpellAlert_Mob_head = "";
SpellAlert_Spell_head = "";
DSCT_ROTATION_COS = 0;
DSCT_ROTATION_SIN = 0;
DSCT_MESS_TIMER = 4;
DSCT_MESS_FADETIMER = 3;
DSCT_MESS_ALPHAMAX = 1;
DSCT_ANI_SPEED = 1;
DSCT_ANI_TEXTSIZE = 20;
DSCT_ANI_ENTEXTSIZE = 20;
DSCT_ANI_ALPHAMAX = 1;
DSCT_ANI_PARAM1 = 1;
DSCT_ANI_PARAM2 = 1;
DSCT_ENTEXT = 1;
DSCT_CUSTOMEVENT = nil;
--Animation System variables
DSCT_LastBar = 1;					-- Holds what the next avalible fontstring for the animation system is
arrAniData = {
		["aniData1"] = {},					-- These are structures that define the animation data
		["aniData2"] = {},
		["aniData3"] = {},
		["aniData4"] = {},
		["aniData5"] = {},
		["aniData6"] = {},
		["aniData7"] = {},
		["aniData8"] = {},
		["aniData9"] = {},
		["aniData10"] = {}
}

arrCusMessData = {
		["cusMessData1"] = {},					-- These are structures that define the animation data
		["cusMessData2"] = {},
		["cusMessData3"] = {}
}

local default_config = {
		["VERSION"] = DSCT_Version,
		["ENABLED"] = 1,
		["ANIMATIONSPEED"] = 1,
		["TEXTSIZE"] = 22,
		["ENTEXTSIZE"] = 22,
		["MESSAGESIZE"] = 16,
		["LOWHP"] = .4,
		["LOWMANA"] = .4,
		["CRITANI"] = 1,
		["SHOWHIT"] = 1,
		["SHOWMISS"] = 1,
		["SHOWDODGE"] = 1,
		["SHOWPARRY"] = 1,
		["SHOWBLOCK"] = 1,
		["SHOWIMMUNE"] = 2,
		["SHOWSPELL"] = 1,
		["SHOWHEAL"] = 1,
		["SHOWRESIST"] = 2,
		["SHOWDEBUFF"] = 2,
		["SHOWBUFF"] = 0,
		["SHOWFADE"] = 0,
		["SHOWABSORB"] = 2,
		["SHOWLOWHP"] = 2,
		["SHOWLOWMANA"] = 2,
		["SHOWPOWER"] = 1,
		["SHOWCOMBATIN"] = 0,
		["SHOWCOMBATOUT"] = 0,
		["SHOWCOMBOPOINTS"] = 3,
		["SHOWHONOR_DSCT"] = 1,
		["SHOWSPELLALERT"] = 4,
		["SHOWEMOTE"] = 4,
		["SHOWYELL"] = 4,
		["SHOWSPELLCRIT"] = 0,
		["SHOWDMGCRIT"] = 0,
		["SHOWCUSTOM"] = 0,
		["SHOWSPELLTIMER"] = 0,
		["ALPHA"] = 1,
		["SHOWSELF"] = 0,
		["ANIMODE"] = 3,
		["FONT"] = 1,
		["ENFONT"] = 1,
		["MESSAGEFONT"] = 3,
		["MESSAGETIMER"] = 4,
		["MESSAGEFADETIMER"] = 3,
		["FONTOUTLINE"] = 1,
		["MESSAGEPOSX"] = 0,
		["MESSAGEPOSY"] = 155,
		["MESSFONTOUTLINE"] = 1,
		["ANIPOSX"] = 0,
		["ANIPOSY"] = 0,
		["MESSAGEALPHA"] = 1,
		["ANIC"] = 10,
		["ROTATION"] = 0,
		["DAMAGETYPE"] = 1,
		["CUSTOMEVENT"] = 0,
		["HEALERNAME"] = 1,
		["ENTEXT"] = 0,
		["SHORTALERT"] = 0,
		["SHOWEXECUTE"] = 4,
		["SHOWSA_BEGINCAST"] = 1,
		["SHOWSA_CAST"] = 1,
		["SHOWSA_GAIN"] = 1,
		["CUSTOM_EVENT_LIST"] = {},
		["ACCMode"] = 0,
		
		["ANIMODE0_Param1"] = 1,
		["ANIMODE0_Param2"] = 1,
		["ANIMODE1_Param1"] = 1,
		["ANIMODE1_Param2"] = 1,
		["ANIMODE2_Param1"] = 1,
		["ANIMODE2_Param2"] = 1,
		["ANIMODE3_Param1"] = 1,
		["ANIMODE3_Param2"] = 1,
		["ANIMODE4_Param1"] = 1,
		["ANIMODE4_Param2"] = 1,
		["ANIMODE5_Param1"] = 1,
		["ANIMODE5_Param2"] = 1,
		["ANIMODE6_Param1"] = 1,
		["ANIMODE6_Param2"] = 1,

		["COLORS"] = {
			["SHOWHIT"] = {	b = 0,g = 0,r = 1,},
			["SHOWMISS"] = {b = 0.8,g = 0.5,r = 0,},
			["SHOWDODGE"] = {
				b = 0.8,
				g = 0.5,
				r = 0,
			},
			["SHOWPARRY"] = {
				b = 0.8,
				g = 0.5,
				r = 0,
			},
			["SHOWBLOCK"] = {
				b = 0.8,
				g = 0.5,
				r = 0,
			},
			["SHOWRESIST"] = {
				b = 0.780392,
				g = 0.388235,
				r = 0.905882,
			},
			["SHOWABSORB"] = {
				b = 0,
				g = 0.85,
				r = 1,
			},
			["SHOWIMMUNE"] = {
				b = 0,
				g = 0.85,
				r = 1,
			},
			["SHOWCOMBATIN"] = {
				b = 0,
				g = 0.7,
				r = 1,
			},
			["SHOWCOMBATOUT"] = {
				b = 0,
				g = 1,
				r = 0,
			},
			["SHOWSPELLCRIT"] = {
				b = 0,
				g = 1,
				r = 1,
			},
			["SHOWLOWHP"] = {
				b = 0.5,
				g = 0.5,
				r = 1,
			},
			["SHOWLOWMANA"] = {
				b = 1,
				g = 0.5,
				r = 0.5,
			},
			["SHOWDMGCRIT"] = {
				b = 1,
				g = 1,
				r = 1,
			},
			["SHOWSPELL"] = {
				b = 1,
				g = 0,
				r = 1,
			},
			["SHOWHEAL"] = {
				b = 0,
				g = 1,
				r = 0,
			},
			["SHOWDEBUFF"] =  {r = 1.0, g = 0.17, b = 0.0},
			["SHOWBUFF"] =  {r = 0, g = 1.0, b = 0},
			["SHOWFADE"] =  {r = 1.0, g = 0.5, b = 0.0},
			["SHOWPOWER"] =  {r = 1.0, g = 1.0, b = 0.0},
			["SHOWCOMBOPOINTS"] =  {r = 0.0, g = 1.0, b = 0.0},
			["SHOWHONOR_DSCT"] =  {r = 1, g = 1, b = 0.0},
			["SHOWEMOTE"] =  {r = 1.0, g = 0.5, b = 0.0},
			["SHOWYELL"] =  {r = 1.0, g = 0.5, b = 0.0},
			["SHOWCUSTOM"] =  {r = 1.0, g = 1.0, b = 0.0},
			["SHOWSPELLALERT"] =  {r = 1.0, g = 1.0, b = 1.0},
			["SPELLALERT_MOB_COLOR"] =  {r = 0.47, g = 1, b = 0.57},
			["SPELLALERT_SPELL_COLOR"] =  {r = 1, g = 0.42, b = 0.32},
			["SHOWEXECUTE"] = {r = 1, g = 1, b = 0},
		}
	};

local EVENT_LIST = {
	["SHOWHIT"] = {"UNIT_COMBAT"},
	["SHOWMISS"] = {"UNIT_COMBAT"},
	["SHOWDODGE"] = {"UNIT_COMBAT"},
	["SHOWIMMUNE"] = {"UNIT_COMBAT"},
	["SHOWPARRY"] = {"UNIT_COMBAT"},
	["SHOWBLOCK"] = {"UNIT_COMBAT","CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS","CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS"},
	["SHOWRESIST"] = {"UNIT_COMBAT","UNIT_SPELLMISS"},
	["SHOWABSORB"] = {"UNIT_COMBAT","CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES","CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES",
					"CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS","CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS"},
	["SHOWSPELLCRIT"] = {"CHAT_MSG_SPELL_SELF_DAMAGE"},
	["SHOWLOWHP"] = {"UNIT_HEALTH"},
	["SHOWLOWMANA"] = {"UNIT_MANA"},
	["SHOWDMGCRIT"] = {"CHAT_MSG_COMBAT_SELF_HITS"},
	["SHOWSPELL"] = {"UNIT_COMBAT"},
	["SHOWHEAL"] = {"CHAT_MSG_SPELL_SELF_BUFF","CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
					"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF","CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"},
	["SHOWDEBUFF"] =  {"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"},
	["SHOWBUFF"] =  {"CHAT_MSG_SPELL_SELF_BUFF","CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"},
	["SHOWFADE"] =  {"CHAT_MSG_SPELL_AURA_GONE_SELF"},
	["SHOWPOWER"] =  {"UNIT_COMBAT","CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE","CHAT_MSG_SPELL_SELF_BUFF","CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
				"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS","CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"},
	["SHOWCOMBOPOINTS"] =  {"PLAYER_COMBO_POINTS"},
	["SHOWRECKPOINTS"] = {"CHAT_MSG_SPELL_SELF_BUFF"},
	["SHOWHONOR_DSCT"] =  {"CHAT_MSG_COMBAT_HONOR_GAIN"},
	["SHOWEMOTE"] =  {"CHAT_MSG_MONSTER_EMOTE"},
	["SHOWYELL"] =  {"CHAT_MSG_MONSTER_YELL"},
	["SHOWSPELLALERT"] =  {"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE","CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
				"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF","CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
				"CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS","CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
				"CHAT_MSG_SPELL_SELF_BUFF","CHAT_MSG_SPELL_SELF_DAMAGE","CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
				"CHAT_MSG_SPELL_AURA_GONE_SELF","CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",
				"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE","CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",
				"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"},
	["CUSTOMEVENT"] =  {"CHAT_MSG_MONSTER_YELL","CHAT_MSG_SPELL_SELF_BUFF","CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
				"CHAT_MSG_COMBAT_SELF_HITS","CHAT_MSG_COMBAT_SELF_MISSES",
				"CHAT_MSG_SPELL_SELF_DAMAGE","CHAT_MSG_SPELL_AURA_GONE_SELF",
				"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE","CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE",
				"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF","CHAT_MSG_SPELL_AURA_GONE_OTHER",
				"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE","CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS",
				"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE","CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",
				"CHAT_MSG_SPELL_BREAK_AURA","CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES",
				"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS","CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES",
				"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS","CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
				"CHAT_MSG_COMBAT_MISC_INFO"},
	["SHOWEXECUTE"] = {"UNIT_HEALTH","PLAYER_TARGET_CHANGED"},
	["HEALERNAME"] =  {"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"},
};

function DSCT_Debug(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function DSCT_Enable(flag)
	DSCT_UnRegisterAllEvent();	
	if flag then
		if flag == 1 then
			DSCT_RefreshAllEvent();
			DSCT_Set("ENABLED",1);
			DSCT_Initialize();
			return;
		end
	end
	if DSCTOptions then
		--PlaySound("igMainMenuClose");
		HideUIPanel(DSCTOptions);
		DSCTOptions_HideAll();
	end
	DSCT_Set("ENABLED",0);
end
--Called when its loaded
function DSCT_OnLoad()
	-- Register Startup Events
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("ADDON_LOADED");
end

-- Show the Option Menu
function DSCT_showMenu()
	if DSCTOptions then
		PlaySound("igMainMenuOpen");
		ShowUIPanel(DSCTOptions);	
		DSCT_openPreView();
	else
		DSCT_Debug("None Menu");
	end
end

--Hide the Option Menu
function DSCT_hideMenu()
	if DSCTOptions then
		--PlaySound("igMainMenuClose");
		HideUIPanel(DSCTOptions);
		
		DSCT_RefreshAllEvent();
		DSCT_closePreView();
		DSCT_RefreshStaticVar();
		DSCT_aniInit();--reload with Current Config	
		DSCT_cusMessInit();
	end
end

--Get a clean config
function DSCT_FreshVar()
	DSCT_NEWCONFIG = {};
end

function DSCT_RegisterEvent(event)
	if (DSCT_EventRecord[event]) then
		if DSCT_EventRecord[event] ~= 1 then
			DSCT_This:RegisterEvent(event);
			DSCT_EventRecord[event] = 1;
		end
	else
		DSCT_This:RegisterEvent(event);
		DSCT_EventRecord[event] = 1;
	end	
end
function DSCT_UnRegisterEvent(event)	
	DSCT_This:UnregisterEvent(event);
	DSCT_EventRecord[event] = 0;
end
function DSCT_UnRegisterAllEvent()
	for keyA, valueA in EVENT_LIST do
		for keyB ,valueB in EVENT_LIST[keyA] do
			DSCT_UnRegisterEvent(valueB);
		end
	end
end
function DSCT_RefreshAllEvent()	
	for keyA, valueA in EVENT_LIST do
		if DSCT_Get(keyA) ~= 0 then
			if keyA ~= "SHOWSPELLALERT" then
				for keyB ,valueB in EVENT_LIST[keyA] do
					DSCT_RegisterEvent(valueB);
				end
			else
				if DSCT_SP_OnEvent then
					for keyB ,valueB in EVENT_LIST[keyA] do
						DSCT_RegisterEvent(valueB);
					end
				end
			end
		end
	end
end
function DSCT_UnRegisterEventGroup(name)
	if EVENT_LIST[name] then
		for keyB ,valueB in EVENT_LIST[name] do
			DSCT_UnRegisterEvent(valueB);
		end
	end
end
function DSCT_RegisterEventGroup(name)
	if EVENT_LIST[name] then
		for keyB ,valueB in EVENT_LIST[name] do
			DSCT_RegisterEvent(valueB);
		end
	end
end
function DSCT_AllSearch_Filter()
	if fixfor_sw_stats == false then return;end
	if DSCT_Get("ACCMode") == 1 and accModeFalg == true then
		DSCTD_FilterEx(AURAADDEDSELFHARMFUL);
		DSCTD_FilterEx(AURAADDEDSELFHELPFUL);
		DSCTD_FilterEx(AURAREMOVEDSELF);
		DSCTD_FilterEx(SPELLLOGCRITSCHOOLSELFOTHER);
		DSCTD_FilterEx(SPELLLOGCRITSELFOTHER);
		DSCTD_FilterEx(COMBATHITCRITSELFOTHER);
		DSCTD_FilterEx(HEALEDOTHERSELF);
		DSCTD_FilterEx(HEALEDSELFSELF);
		DSCTD_FilterEx(PERIODICAURAHEALOTHERSELF);
		DSCTD_FilterEx(PERIODICAURAHEALSELFSELF);
		DSCTD_FilterEx(HEALEDCRITOTHERSELF);
		DSCTD_FilterEx(HEALEDCRITSELFSELF);
		DSCTD_FilterEx(SPELLCASTGOOTHERTARGETTED);
		DSCTD_FilterEx(AURAREMOVEDOTHER);
		DSCTD_FilterEx(VSABSORBOTHERSELF);
		DSCTD_FilterEx(SPELLLOGABSORBOTHERSELF);
		DSCTD_FilterEx(SPELLPOWERLEECHSELFOTHER);--spell,mob,virnum,virname,num,name
		DSCTD_FilterEx(POWERGAINSELFSELF);--mob,num,name
		DSCTD_FilterEx(POWERGAINOTHERSELF);--mob,spell,num,name

		DSCTD_FilterEx(SPELLCASTOTHERSTART);	
		DSCTD_FilterEx(SPELLCASTGOOTHER);	
		DSCTD_FilterEx(AURAADDEDOTHERHELPFUL);
		DSCTD_FilterEx(SPELLPERFORMOTHERSTART);
		DSCTD_FilterEx(SPELLPERFORMGOOTHER);
		accModeFalg = false;
	end	
	
	DSCT_DEBUFF_NAME_SEARCH = DSCTD_Filter(AURAADDEDSELFHARMFUL);
	DSCT_YOU_GAIN_SEARCH = DSCTD_Filter(AURAADDEDSELFHELPFUL);
	DSCT_FADE_SEARCH = DSCTD_Filter(AURAREMOVEDSELF);
	DSCT_YOUCRIT_SEARCH = DSCTD_Filter(SPELLLOGCRITSCHOOLSELFOTHER);
	DSCT_YOUCRIT_SEARCH2 = DSCTD_Filter(SPELLLOGCRITSELFOTHER);
	DSCT_YOUCRIT_SEARCH3 = DSCTD_Filter(COMBATHITCRITSELFOTHER);
	DSCT_HEAL_SEARCH1 = DSCTD_Filter(HEALEDOTHERSELF);
	DSCT_HEAL_SEARCH2 = DSCTD_Filter(HEALEDSELFSELF);
	DSCT_AURAHEAL_SEARCH1 = DSCTD_Filter(PERIODICAURAHEALOTHERSELF);
	DSCT_AURAHEAL_SEARCH2 = DSCTD_Filter(PERIODICAURAHEALSELFSELF);
	DSCT_CRITHEAL_SEARCH1 = DSCTD_Filter(HEALEDCRITOTHERSELF);
	DSCT_CRITHEAL_SEARCH2 = DSCTD_Filter(HEALEDCRITSELFSELF);
	DSCT_SA_CASTS_PLY_VS_PLY = DSCTD_Filter(SPELLCASTGOOTHERTARGETTED);
	DSCT_SA_FADE_BUFF = DSCTD_Filter(AURAREMOVEDOTHER);
	DSCT_ABSORB_AMOUNT_SEARCH1 = DSCTD_Filter(VSABSORBOTHERSELF);
	DSCT_ABSORB_AMOUNT_SEARCH2 = DSCTD_Filter(SPELLLOGABSORBOTHERSELF);
	DSCT_YOU_GAIN_POWER_SEARCH1 = DSCTD_Filter(SPELLPOWERLEECHSELFOTHER);--spell,mob,virnum,virname,num,name
	DSCT_YOU_GAIN_POWER_SEARCH2 = DSCTD_Filter(POWERGAINSELFSELF);--mob,num,name
	DSCT_YOU_GAIN_POWER_SEARCH3 = DSCTD_Filter(POWERGAINOTHERSELF);--mob,spell,num,name

	DSCT_SA_BEGIN_CAST[1] = DSCTD_Filter(SPELLCASTOTHERSTART);	
	DSCT_SA_CASTS_TOTEM[1] = DSCTD_Filter(SPELLCASTGOOTHER);	
	DSCT_SA_GAIN_BUFF[1] = DSCTD_Filter(AURAADDEDOTHERHELPFUL);
	DSCT_SAEX_PERFORMOTHERSTART[1] = DSCTD_Filter(SPELLPERFORMOTHERSTART);
	DSCT_SAEX_PERFORMGOOTHER[1] = DSCTD_Filter(SPELLPERFORMGOOTHER);

	--DSCT_ABSORB_TRAILER_SEARCH = DSCTD_Filter(ABSORB_TRAILER);
	--DSCT_BLOCK_AMOUNT_SEARCH = DSCTD_Filter(BLOCK_TRAILER);
end
--Set the global player config
function DSCT_Initialize()
	if DSCT_NameRegistered == 1 then return;end
	
	if ( DSCT_NEWCONFIG == nil) then DSCT_FreshVar();end	
	DSCTPlayer = DSCT_Config_GetPlayer();
	
	if DSCT_Get("ENABLED") ~= 1 then return;end
	local playerName = UnitName("player");
	
	if DSCT_Support_NewFont then DSCT_Support_NewFont();end
	
	currentclass = UnitClass("player");
	DSCT_This = this;
	DSCT_EventRecord = {};
	-- Add Slash Commands
	SlashCmdList["DSCT"] = function(msg) DSCT_Cmd(msg); end
	SLASH_DSCT1 = "/sct";	
	
	SlashCmdList["DSCTMENU"] = DSCT_showMenu;
	SLASH_DSCTMENU1 = "/sctmenu";
	
	-- Add my options frame to the global UI panel list
	--UIPanelWindows["DSCTOptions"] = {area = "center", pushable = 0};

	DSCT_RegisterEvent("PLAYER_REGEN_ENABLED");
	DSCT_RegisterEvent("PLAYER_REGEN_DISABLED");
	DSCT_RegisterEvent("PLAYER_CONTROL_LOST");
	
	DSCT_RefreshStaticVar();
	DSCT_aniInit();--reload with Current Config	
	DSCT_cusMessInit();
	
	
	DSCT_RefreshAllEvent();
	
	DSCT_InitCustomEvent();
	
	DSCT_AllSearch_Filter();
	DSCT_NameRegistered = 1;
end	

function DSCT_RefreshStaticVar()
	local tmp = DSCT_nGetColor("SPELLALERT_MOB_COLOR");
	SpellAlert_Mob_head = DSCT_ColorFlip(tmp.r,tmp.g,tmp.b);
	tmp = DSCT_nGetColor("SPELLALERT_SPELL_COLOR");
	SpellAlert_Spell_head = DSCT_ColorFlip(tmp.r,tmp.g,tmp.b);
	DSCT_ROTATION_SIN = sin(360 - DSCT_Get("ROTATION"));
	DSCT_ROTATION_COS = cos(360 - DSCT_Get("ROTATION"));
	
	DSCT_MESS_TIMER = DSCT_Get("MESSAGETIMER");
	DSCT_MESS_FADETIMER = DSCT_Get("MESSAGEFADETIMER");
	DSCT_MESS_ALPHAMAX = DSCT_Get("MESSAGEALPHA");
	DSCT_ANI_SPEED = DSCT_Get("ANIMATIONSPEED");
	DSCT_ANI_TEXTSIZE = DSCT_Get("TEXTSIZE");
	DSCT_ANI_ENTEXTSIZE = DSCT_Get("ENTEXTSIZE");
	DSCT_ANI_ALPHAMAX = DSCT_Get("ALPHA");
	DSCT_ENTEXT = DSCT_Get("ENTEXT") + 1;
	
	DENNIE_cusMess_posX = DSCT_Get("MESSAGEPOSX");
	DENNIE_cusMess_posY = DSCT_Get("MESSAGEPOSY");
	DENNIE_ani_posX = DSCT_Get("ANIPOSX");
	DENNIE_ani_posY = DSCT_Get("ANIPOSY");
	
	local paramList = {[0]={1,1},[1]={1,1},[2]={1,1},[3]={1,1},[4]={1,1},[5]={1,1},[6]={1,1}};
	for i = 0,6 do
		paramList[i][1] = DSCT_Get("ANIMODE"..i.."_Param1");
		paramList[i][2] = DSCT_Get("ANIMODE"..i.."_Param2");
	end
	
	DSCT_ANI_PARAM1 = paramList[DSCT_Get("ANIMODE")][1];
	DSCT_ANI_PARAM2 = paramList[DSCT_Get("ANIMODE")][2];
	
	DSCT_CUSTOMEVENT = DSCT_Get("CUSTOM_EVENT_LIST");
end

--Get or Create a config based on the current player
function DSCT_Config_GetPlayer()
	if (DSCT_NEWCONFIG[UnitName("player").." of "..GetCVar("realmName")] == nil) then
		DSCT_Config_NewPlayer(UnitName("player").." of "..GetCVar("realmName"));
	end
	return DSCT_NEWCONFIG[UnitName("player").." of "..GetCVar("realmName")];
end

--Set up a default config
function DSCT_Config_NewPlayer(PlayerName)
	DSCT_NEWCONFIG[PlayerName] = DSCT_clone(default_config);
end

--Copy a whole table
function DSCT_clone(t)             -- return a copy of the table t
  local new = {};             -- create a new table
  local i, v = next(t, nil);  -- i is an index of t, v = t[i]
  while i do
  	if type(v)=="table" then 
  		v=DSCT_clone(v);
  	end 
    new[i] = v;
    i, v = next(t, i);        -- get next index
  end
  return new;
end

function DSCT_Load(config)
	DSCT_NEWCONFIG[UnitName("player").." of "..GetCVar("realmName")] = nil;
	DSCT_NEWCONFIG[UnitName("player").." of "..GetCVar("realmName")] = DSCT_clone(config);
	DSCTPlayer = DSCT_Config_GetPlayer();
	
	DSCT_AddCustomEventToPlayer();
	DSCT_aniInit();
	DSCT_cusMessInit();		
	DSCT_RefreshAllEvent();
	DSCT_RefreshStaticVar();
end
--Reset everything to default
function DSCT_Reset()
	DSCT_Load(default_config);
	DSCT_hideMenu();
	DSCT_showMenu();
end

--Get a value from player config
function DSCT_Get(option)
	if (DSCTPlayer ~= nil) and (DSCTPlayer[option]) then
		return DSCTPlayer[option];
	else
		if default_config[option] then
			return default_config[option];
		else
			return nil;
		end
	end
end

----------------------
--Set a value in player config
function DSCT_Set(option, newVal)
	if (DSCTPlayer ~= nil) then
		if ( option ) then
			DSCTPlayer[option] = newVal;
			if newVal == 1 and EVENT_LIST[option] then
				for keyB ,valueB in EVENT_LIST[option] do
					DSCT_RegisterEvent(valueB);
				end
			end
		end
	end
end

----------------------
--Get a color in the player config
function DSCT_nGetColor(key)
	local color = {r = 1.0, g = 1.0, b = 1.0};	
	if (DSCTPlayer ~= nil) and (DSCTPlayer["COLORS"][key] ~= nil) then
		color.r = DSCTPlayer["COLORS"][key].r;
		color.g = DSCTPlayer["COLORS"][key].g;
		color.b = DSCTPlayer["COLORS"][key].b;		
	else
		if default_config["COLORS"][key] ~= nil then
			color.r = default_config["COLORS"][key].r;
			color.g = default_config["COLORS"][key].g;
			color.b = default_config["COLORS"][key].b;
		else
			DSCT_Debug("DSCT_Debug:"..key);
		end		
	end
	return color;
end
function DSCT_GetColor(key)
	return {r = 1.0, g = 1.0, b = 1.0};
end
----------------------
--Set a color in the player config
function DSCT_SetColor(key, r, g, b)
	if (DSCTPlayer ~= nil) and (DSCTPlayer["COLORS"][key] ~= nil) then
		DSCTPlayer["COLORS"][key].r = r;
		DSCTPlayer["COLORS"][key].g = g;
		DSCTPlayer["COLORS"][key].b = b;
	else
		local color = {r = 1.0, g = 1.0, b = 1.0};
		color.r = default_config["COLORS"][key].r;
		color.g = default_config["COLORS"][key].g;
		color.b = default_config["COLORS"][key].b;
		DSCTPlayer["COLORS"][key] = color;
	end
end

----------------------
-- Event Handler
-- this function parses events that are printed in the combat
-- chat window then displays the health changes
function DSCT_OnEvent()
	if (event == "VARIABLES_LOADED") or ( event == "ADDON_LOADED" and arg1 == "sct" ) or (event == "PLAYER_ENTERING_WORLD") then
		DSCT_Initialize();
		if event == "PLAYER_ENTERING_WORLD" and fixfor_sw_stats == true then
			DSCT_AllSearch_Filter();
			if DSCT_Support then DSCT_Support();end
			fixfor_sw_stats = false;			
		end
		return;
	end
	if DSCT_NameRegistered == 0 then		
		return;
	end
	if DSCT_Get("ENABLED") == 0 then return;end
	
	local critical;
	local mob,mob2, spell, amountk;	
	
	if DSCT_Get("CUSTOMEVENT") ~= 0 and event ~= "UNIT_HEALTH" then
		if DSCT_CustomEventSearch(arg1) == true then return;end
	end

	if event == "UNIT_HEALTH" then		
		if arg1 == "player" and DSCT_Get("SHOWLOWHP") ~= 0 and (DSCT_NameRegistered == 1) then
			local warnlevel = DSCT_Get("LOWHP");
			local HPPercent = UnitHealth("player") / UnitHealthMax("player");
			if (HPPercent < warnlevel) and (DSCT_LastHPPercent >= warnlevel) then
				local txt = (DSCT_Get("LOWHP") *100).."%";
				txt = string.sub(txt,1,2);
				if DSCT_ENTEXT == 2 then
					DSCT_Display_Toggle("SHOWLOWHP",2,DSCT_LowHP[DSCT_ENTEXT]..UnitHealth("player").."* <"..txt.."%");
				else
					DSCT_Display_Toggle("SHOWLOWHP",3,UnitHealth("player").."* <"..txt.."%",DSCT_LowHP[DSCT_ENTEXT]);
				end
			end
			DSCT_LastHPPercent = HPPercent;
		end
		if arg1 == "target" and DSCT_Get("SHOWEXECUTE") ~= 0 then			
			if (UnitIsEnemy("target", "player")) and (not UnitIsDead("target")) and
					(not UnitIsCorpse("target")) and 
					((currentclass == DSCT_PALADIN) or (currentclass == DSCT_WARRIOR)) then
				local HPTargetPercent = UnitHealth("target");
				if (HPTargetPercent < 20) and (DSCT_LastTargetHPPercent >= 20) then
					local msg;
					if (currentclass == DSCT_WARRIOR) then
						msg = DSCT_ExecuteMessage;
					else
						msg = DSCT_WrathMessage;
					end
					DSCT_Display_Toggle("SHOWEXECUTE", 1,msg);
				end
				DSCT_LastTargetHPPercent = HPTargetPercent;
			end
		end
		return;
	elseif (event == "PLAYER_TARGET_CHANGED") then
			if (UnitIsEnemy("target", "player") and (not UnitIsDead("target")) and (not UnitIsCorpse("target"))) then
				DSCT_LastTargetHPPercent = UnitHealth("target");
			else
				DSCT_LastTargetHPPercent = 100;
			end
	elseif event == "UNIT_MANA" then
		if arg1 == "player" and DSCT_Get("SHOWLOWMANA") ~= 0 and DSCT_NameRegistered == 1 and UnitPowerType("player")== 0 then
			local warnlevel = DSCT_Get("LOWMANA");
			local ManaPercent = UnitMana("player") / UnitManaMax("player");
			if (ManaPercent < warnlevel) and (DSCT_LastManaPercent >= warnlevel) then
				local txt = (DSCT_Get("LOWMANA") *100).."%";
				txt = string.sub(txt,1,2);
				if DSCT_ENTEXT == 2 then
					DSCT_Display_Toggle("SHOWLOWMANA",2,DSCT_LowMana[DSCT_ENTEXT]..UnitMana("player").."* <"..txt.."%");
				else
					DSCT_Display_Toggle("SHOWLOWMANA",3,UnitMana("player").."* <"..txt.."%",DSCT_LowMana[DSCT_ENTEXT]);
				end
			end
			DSCT_LastManaPercent = ManaPercent;
		end
		return;
	elseif event =="PLAYER_REGEN_DISABLED" then
		if DSCT_Get("SHOWCOMBATIN") ~= 0 then
			--PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
			DSCT_Display_Toggle("SHOWCOMBATIN",DSCT_ENTEXT,DSCT_Combat[DSCT_ENTEXT]);		
		end
		return;
	elseif event =="PLAYER_REGEN_ENABLED" then
		if DSCT_Get("SHOWCOMBATOUT") ~= 0 then			
			DSCT_Display_Toggle("SHOWCOMBATOUT",DSCT_ENTEXT,DSCT_NoCombat[DSCT_ENTEXT]);		
		end
		return;
	elseif event == "PLAYER_COMBO_POINTS" then
		if DSCT_Get("SHOWCOMBOPOINTS") ~= 0 then
			local DSCT_CP = GetComboPoints();
			if (DSCT_CP ~= 0) then				
				if (DSCT_CP == 5) then
					DSCT_Display_Toggle("SHOWCOMBOPOINTS",DSCT_ENTEXT,DSCT_CP,DSCT_FiveCPMessage[DSCT_ENTEXT]);
				else
					DSCT_Display_Toggle("SHOWCOMBOPOINTS",DSCT_ENTEXT,DSCT_CP,DSCT_ComboPoint[DSCT_ENTEXT]);
				end;				
			end
		end
		return;
	elseif event == "CHAT_MSG_COMBAT_HONOR_GAIN" then
		if DSCT_Get("SHOWHONOR_DSCT") ~= 0 then
			for honor in string.gfind(arg1, DSCT_HONOR_SEARCH) do			
				DSCT_Display_Toggle("SHOWHONOR_DSCT",DSCT_ENTEXT,"+"..honor.." ",DSCT_Honor[DSCT_ENTEXT]);
			end
		end
		return;
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES" then
		if DSCT_Get("SHOWABSORB") ~= 0 then
			for mob in string.gfind( arg1, DSCT_ABSORB_AMOUNT_SEARCH1) do						
				DSCT_Display_Toggle("SHOWABSORB",DSCT_ENTEXT,DSCT_AbsorbMsg[DSCT_ENTEXT]);
				return;
			end
			for mob,spell in string.gfind( arg1, DSCT_ABSORB_AMOUNT_SEARCH2) do						
				DSCT_Display_Toggle("SHOWABSORB",DSCT_ENTEXT,DSCT_AbsorbMsg[DSCT_ENTEXT]);	
				return;
			end
		end
		--if none, return
		return;
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS" then
		if event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" and DSCT_Get("SHOWABSORB") ~= 0 then
			for num in string.gfind( arg1, DSCT_ABSORB_TRAILER_SEARCH) do
				DSCT_Display_Toggle("SHOWABSORB",DSCT_ENTEXT,num.." *",DSCT_AbsorbMsg[DSCT_ENTEXT]);	
				return;
			end
		end
		--partial block
		if event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" and DSCT_Get("SHOWBLOCK") ~= 0 then
			for num in string.gfind( arg1, DSCT_BLOCK_AMOUNT_SEARCH) do	
				DSCT_Display_Toggle("SHOWBLOCK",DSCT_ENTEXT,num.." *",DSCT_BlockMsg[DSCT_ENTEXT]);				
			end
		end
		--if none, return
		return;
	elseif event == "CHAT_MSG_COMBAT_SELF_HITS" then
		if DSCT_Get("SHOWDMGCRIT") ~= 0 then
			for mob, num in string.gfind( arg1, DSCT_YOUCRIT_SEARCH3 ) do
				if DSCT_ENTEXT == 1 then
					DSCT_Display_Toggle("SHOWDMGCRIT",3,num,DSCT_CRIT[DSCT_ENTEXT]);
				else
					DSCT_Display_Toggle("SHOWDMGCRIT",2,num,DSCT_CRIT[DSCT_ENTEXT]);
				end
			end
		end
		return;
	--Debuffs
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
		if DSCT_Get("SHOWPOWER") ~= 0 then
			for spell,mob,virnum,virname,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH1 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end				
			end
			for mob,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH2 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end	
			end
			--[[
			for mob,spell,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH3 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end
			end]]
		end		
		if DSCT_Get("SHOWDEBUFF") ~= 0 then
			for num in string.gfind(arg1, DSCT_DEBUFF_NAME_SEARCH) do				
				DSCT_Display_Toggle("SHOWDEBUFF",1,nil,"「"..num.."」",0,format(DSCT_AFFLICTED_BY, num));
			end
		end	
		return;
	--Self Buffs
	elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then		
		--Configured self buffs
		--DoT Heal, Mana, Rage, Energy
		if DSCT_Get("SHOWHEAL") ~= 0 then	
			for spell,num in string.gfind( arg1, DSCT_HEAL_SEARCH2 ) do	
				DSCT_Display_Toggle("SHOWHEAL",2,"+"..num);
				return;		
			end
			for spell,num in string.gfind( arg1, DSCT_CRITHEAL_SEARCH2 ) do	
				DSCT_Display_Toggle("SHOWHEAL",2,"+"..num,nil,1);
				return;		
			end	
		end
		if DSCT_Get("SHOWPOWER") ~= 0 then
			for spell,mob,virnum,virname,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH1 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end				
			end
			for mob,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH2 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end	
			end
			--[[
			for mob,spell,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH3 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end
			end]]
		end
		--Buff
		if DSCT_Get("SHOWBUFF") ~= 0 then
			for name in string.gfind( arg1, DSCT_YOU_GAIN_SEARCH ) do					
				DSCT_Display_Toggle("SHOWBUFF",1,nil,DSCT_YOU_GAIN_UNM..name.."*", 0, DSCT_YOU_GAIN..name);						
			end				
		end
		return;	
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if DSCT_Get("SHOWSPELLCRIT") ~= 0 then
			for spell, mob,num,typ in string.gfind(arg1, DSCT_YOUCRIT_SEARCH) do
				if spell and mob and num then					
					DSCT_Display_Toggle("SHOWSPELLCRIT",3,num,DSCT_CRIT[1]..spell.." ");
					return;
				end
			end
			for spell, mob,num in string.gfind(arg1, DSCT_YOUCRIT_SEARCH2) do
				if spell and mob and num then
					DSCT_Display_Toggle("SHOWSPELLCRIT",3,num,DSCT_CRIT[1]..spell.." ");
					return;
				end
			end
		end
		return;
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then		
		--Configured self buffs
		--DoT Heal, Mana, Rage, Energy
		if DSCT_Get("SHOWPOWER") ~= 0 then
			for spell,mob,virnum,virname,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH1 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end				
			end
			for mob,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH2 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end	
			end
			--[[
			for mob,spell,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH3 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end
			end]]
		end
		--Buff
		if DSCT_Get("SHOWBUFF") ~= 0 then
			for name in string.gfind( arg1, DSCT_YOU_GAIN_SEARCH ) do					
				DSCT_Display_Toggle("SHOWBUFF",1,nil,DSCT_YOU_GAIN_UNM..name.."*",0, DSCT_YOU_GAIN..name);					
				return;
			end
		end
		--if none, return		
		if DSCT_Get("SHOWHEAL") ~= 0 then	
			for name,spell,num in string.gfind( arg1, DSCT_AURAHEAL_SEARCH1 ) do	
				if DSCT_Get("HEALERNAME") ~= 0 then
					DSCT_Display_Toggle("SHOWHEAL",1,"+"..num.."  *",name);					
				else
					DSCT_Display_Toggle("SHOWHEAL",2,"+"..num);
				end
				return;		
			end
			for spell,num in string.gfind( arg1, DSCT_AURAHEAL_SEARCH2 ) do	
				DSCT_Display_Toggle("SHOWHEAL",2,"+"..num);
				return;		
			end			
		end		
		return;
	elseif event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" or event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" then
		if DSCT_Get("SHOWPOWER") ~= 0 then
			for mob,num,name in string.gfind( arg1, DSCT_YOU_GAIN_POWER_SEARCH2 ) do
				if ((name == MANA) or (name == ENERGY) or (name == RAGE)) then
					local id = 1;
					if name == ENERGY then id = 2;end
					if name == RAGE then id = 3;end
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..num,DSCT_PowerList[id][DSCT_ENTEXT]);
					return;
				end	
			end
		end
	--Buff Fades
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then	
		--Buff Fades		
		if DSCT_Get("SHOWFADE") ~= 0 then
			for name in string.gfind(arg1, DSCT_FADE_SEARCH) do					
				DSCT_Display_Toggle("SHOWFADE",1,nil,DSCT_YOU_FADE_UNM..name.."*",0, DSCT_YOU_FADE..name);	
				return;
			end
		end
		--if none, return
		return;
	elseif event == "UNIT_COMBAT" then		
		--if it didn't happen to the player, leave
		if (arg1 ~= "player") then
			return;
		end

		--Set Crit Flag
		if(arg3 == "CRITICAL") then
			critical=1;
		else
			critical=0;
		end
		
		--If Damage
		if arg2 == "WOUND" then
			-- If Absorb
			if arg3 == "ABSORB" then
				if DSCT_Get("SHOWABSORB") ~= 0 then
					DSCT_Display_Toggle("SHOWABSORB",DSCT_ENTEXT,DSCT_AbsorbMsg[DSCT_ENTEXT]);
					return;	
				end				
			end
			
			--If Damage
			if arg4 ~= 0 or arg4 ~= nil then
				--Spell
				if arg5 > 0 then
					if DSCT_Get("SHOWSPELL") ~= 0 then
						if DSCT_Get("DAMAGETYPE") == 1 then											
							DSCT_Display_Toggle("SHOWSPELL",DSCT_ENTEXT,"-"..arg4.."  ",sct_spelltypes[arg5][DSCT_ENTEXT] , critical);							
						else
							DSCT_Display_Toggle("SHOWSPELL",2,"-"..arg4,nil, critical);
						end
					end
				else
					if DSCT_Get("SHOWHIT") ~= 0 then							
						DSCT_Display_Toggle("SHOWHIT",2,"-"..arg4 ,nil, critical);
					end
				end
			end
			return;
		
		elseif arg2 == "MANA" then
			if arg4 ~= 0 or arg4 ~= nil then
				if DSCT_Get("SHOWPOWER") ~= 0 then						
					DSCT_Display_Toggle("SHOWPOWER",DSCT_ENTEXT,"+"..arg4.." ",DSCT_PowerList[1][DSCT_ENTEXT]);
				end
			end
			return;
			
		--If a Dodge
		elseif arg2 == "DODGE" then
			if DSCT_Get("SHOWDODGE") ~= 0 then					
				DSCT_Display_Toggle("SHOWDODGE",DSCT_ENTEXT,DSCT_DodgeMsg[DSCT_ENTEXT]);								
			end
			return;
		
		--If a Full Block
		elseif arg2 == "BLOCK" then
			if DSCT_Get("SHOWBLOCK") ~= 0 then
				DSCT_Display_Toggle("SHOWBLOCK",DSCT_ENTEXT,DSCT_BlockMsg[DSCT_ENTEXT]);								
			end
			return;
		
		--If a Parry
		elseif arg2 == "PARRY" then
			if DSCT_Get("SHOWPARRY") ~= 0 then
				DSCT_Display_Toggle("SHOWPARRY",DSCT_ENTEXT,DSCT_ParryMsg[DSCT_ENTEXT]);								
			end
			return;
		
		elseif arg2 == "RESIST" then				
			if DSCT_Get("SHOWRESIST") ~= 0 then
				DSCT_Display_Toggle("SHOWRESIST",DSCT_ENTEXT,DSCT_ResistMsg[DSCT_ENTEXT]);								
			end
			--if none, return
			return;
		elseif arg2 == "IMMUNE" then				
			if DSCT_Get("SHOWIMMUNE") ~= 0 then
				DSCT_Display_Toggle("SHOWIMMUNE",DSCT_ENTEXT,DSCT_ImmuneMsg[DSCT_ENTEXT]);								
			end
			--if none, return
			return;
		--if none, return
			
		--If a Miss
		elseif arg2 == "MISS" then			
			if DSCT_Get("SHOWMISS") ~= 0 then
				DSCT_Display_Toggle("SHOWMISS",DSCT_ENTEXT,DSCT_MissMsg[DSCT_ENTEXT]);								
			end
			--if none, return
			return;
		end
		--if none, return
		return;
	--Sepll Miss events
	elseif event == "UNIT_SPELLMISS" then			
		--if it didn't happen to the player, leave
		if arg1 ~= "player" then
			return;--Dennie add
		end
			
		--If Resist
		if arg2 == "RESIST" then
			if DSCT_Get("SHOWRESIST") ~= 0 then
				DSCT_Display_Toggle("SHOWRESIST",DSCT_ENTEXT,DSCT_ResistMsg[DSCT_ENTEXT]);
			end
			return;
			
		--If Resist Ranged attack
		elseif arg2 == "PHYSICAL" then
			if DSCT_Get("SHOWRESIST") ~= 0 then
				DSCT_Display_Toggle("SHOWRESIST",DSCT_ENTEXT,DSCT_ResistMsg[DSCT_ENTEXT]);								
			end
			return;
			
		--If Deflected
		elseif arg2 == "DEFLECTED" then
			if DSCT_Get("SHOWRESIST") ~= 0 then
				DSCT_Display_Toggle("SHOWRESIST",DSCT_ENTEXT,DSCT_DeflectMsg[DSCT_ENTEXT]);						
			end
			return;
		end
	elseif (event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF") then
		if DSCT_Get("SHOWHEAL") ~= 0 then	
			for name,spell,num in string.gfind( arg1, DSCT_HEAL_SEARCH1 ) do	
				if DSCT_Get("HEALERNAME") ~= 0 then
					DSCT_Display_Toggle("SHOWHEAL",1,"+"..num.."  *",name);
				else
					DSCT_Display_Toggle("SHOWHEAL",2,"+"..num);
				end
				return;		
			end
			for name,spell,num in string.gfind( arg1, DSCT_CRITHEAL_SEARCH1 ) do	
				if DSCT_Get("HEALERNAME") ~= 0 then
					DSCT_Display_Toggle("SHOWHEAL",1,"+"..num.."  *",name,1);
				else
					DSCT_Display_Toggle("SHOWHEAL",2,"+"..num,nil,1);
				end
				return;		
			end
		end
	elseif (event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS") then
		if DSCT_Get("SHOWHEAL") ~= 0 then	
			for name,spell,num in string.gfind( arg1, DSCT_HEAL_SEARCH1 ) do	
				if DSCT_Get("HEALERNAME") ~= 0 then
					DSCT_Display_Toggle("SHOWHEAL",1,"+"..num.."  *",name);
				else
					DSCT_Display_Toggle("SHOWHEAL",2,"+"..num);
				end
				return;		
			end			
		end
		return;
	end
	
	if DSCT_SP_OnEvent then DSCT_SP_OnEvent(event, arg1, arg2, arg3);end
end

function DSCTD_FilterEx(name)
	if name == nil then return "ERROR";end
	local str = "";
	local strF = name;
	if string.find(strF," 你") or string.find(strF," 的 ") or string.find(strF,"你 ") then return;end
	
	local i = true;
	while i == true do
		i = false;
		for strL,strR in string.gfind( strF, "(.+)你(.+)") do
			str = str..strL.." 你 ";
			i = true;
			strF = strR;			
		end
		if i == false then
			for strR in string.gfind( strF, "你(.+)") do
				str = " 你 "..str;
				i = true;
				strF = strR;				
			end
		end
		if i == false and strF then
			str = str..strF;
		end
	end
	
	strF = str;
	str = "";
	i = true;
	while i == true do
		i = false;
		for strL,strR in string.gfind( strF, "(.+)的(.+)") do
			str = str..strL.." 的 ";
			i = true;
			strF = strR;
		end
		if i == false and strF then
			str = str..strF;
		end
	end
	
	for strL,strR in string.gfind( str, "(.+)你  的(.+)") do
		str = strL.."你 的"..strR;
	end
	for strL,strR in string.gfind( str, "(.+)你  的(.+)") do
		str = strL.."你 的"..strR;
	end
	
	if name == AURAADDEDSELFHARMFUL then AURAADDEDSELFHARMFUL = str;end
	if name == AURAADDEDSELFHELPFUL then AURAADDEDSELFHELPFUL = str;end
	if name == AURAREMOVEDSELF then AURAREMOVEDSELF = str;end
	if name == SPELLLOGCRITSCHOOLSELFOTHER then SPELLLOGCRITSCHOOLSELFOTHER = str;end
	if name == SPELLLOGCRITSELFOTHER then SPELLLOGCRITSELFOTHER = str;end
	if name == COMBATHITCRITSELFOTHER then COMBATHITCRITSELFOTHER = str;end
	if name == HEALEDOTHERSELF then HEALEDOTHERSELF = str;end
	if name == HEALEDSELFSELF then HEALEDSELFSELF = str;end
	if name == PERIODICAURAHEALOTHERSELF then PERIODICAURAHEALOTHERSELF = str;end
	if name == PERIODICAURAHEALSELFSELF then PERIODICAURAHEALSELFSELF = str;end
	if name == HEALEDCRITOTHERSELF then HEALEDCRITOTHERSELF = str;end
	if name == HEALEDCRITSELFSELF then HEALEDCRITSELFSELF = str;end
	if name == SPELLCASTGOOTHERTARGETTED then SPELLCASTGOOTHERTARGETTED = str;end
	if name == AURAREMOVEDOTHER then AURAREMOVEDOTHER = str;end
	if name == VSABSORBOTHERSELF then VSABSORBOTHERSELF = str;end
	if name == SPELLLOGABSORBOTHERSELF then SPELLLOGABSORBOTHERSELF = str;end
	if name == SPELLPOWERLEECHSELFOTHER then SPELLPOWERLEECHSELFOTHER = str;end--spell,mob,virnum,virname,num,name
	if name == POWERGAINSELFSELF then POWERGAINSELFSELF = str;end--mob,num,name
	if name == POWERGAINOTHERSELF then POWERGAINOTHERSELF = str;end--mob,spell,num,name

	if name == SPELLCASTOTHERSTART then SPELLCASTOTHERSTART = str;end	
	if name == SPELLCASTGOOTHER then SPELLCASTGOOTHER = str;end	
	if name == AURAADDEDOTHERHELPFUL then AURAADDEDOTHERHELPFUL = str;end
	if name == SPELLPERFORMOTHERSTART then SPELLPERFORMOTHERSTART = str;end
	if name == SPELLPERFORMGOOTHER then SPELLPERFORMGOOTHER = str;end
end

function DSCTD_Filter(name)
	if name == nil then return "ERROR";end
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
			else
				str = string.sub(str,1,st - 1).."(%d+)"..string.sub(str,ed + 1,string.len(str));
				i = st + 5 - 1;
			end
			st = -1;
		end		
		i = i + 1;
	end
	return str;
end

function DSCT_InitCustomEvent()
	if initCE_OK == true then return;end
	if SCT_Event_Config == nil then return;end
	
	for custkey , custval in SCT_Event_Config do
		if custval.class then	
			if custval.class ~= "failed" and custval.class ~= "ok" then
				if currentclass ~= custval.class then
					custval.class = "failed";
				else
					custval.class = "ok";
				end
			end
		else
			custval.class = "ok";
		end		
		local len = string.len(custval.name);
		local i = 1;
		local index = 1;
		if not custval.ani then custval.ani = 4;end
		if not custval.title then custval.title = custval.name;end
		if not custval.tooltipText then custval.tooltipText = "?";end
		if not custval.r then custval.r = 1;end
		if not custval.g then custval.g = 1;end
		if not custval.b then custval.b = 1;end
		while i <= len - 1 do
			if string.sub(custval.name,i,i) == "*" then
				if tonumber(string.sub(custval.name,i + 1,i + 1)) then
					local n = tonumber(string.sub(custval.name,i + 1,i + 1));
					custval.name = string.sub(custval.name,1,i - 1).."%"..n.."$s"..string.sub(custval.name,i + 2,string.len(custval.name));
					i = i - 1;
					index = index + 1;
					len = string.len(custval.name);
				end	
			end
			i = i + 1;
		end		
	end	
	initCE_OK = true;
	DSCT_AddCustomEventToPlayer();
end

function DSCT_AddCustomEventToPlayer()
	if initCE_OK ~= true then return;end
	if SCT_Event_Config == nil then return;end
	
	local playerList = DSCT_Get("CUSTOM_EVENT_LIST");
	local tmpId = 1;
	for k,v in playerList do
		if v then tmpId = tmpId + 1;end
	end
	for custkey , custval in SCT_Event_Config do
		if custval.class == "ok" then
			local canAdd = true;
			for k,v in playerList do
				if v.title == custval.title then
					v.name = custval.name;
					v.search = custval.search;
					v.tooltipText = custval.tooltipText;
					canAdd = false;
				end
			
			end
			if canAdd == true then
				playerList[tmpId] = custval;
				tmpId = tmpId + 1;				
			end
		end
	end
	DSCT_Set("CUSTOM_EVENT_LIST",playerList);
end

function DSCT_CustomEventSearch(arg1)
	local re = false;
	if DSCT_CUSTOMEVENT == nil then return;end
	for key , evt in EVENT_LIST["CUSTOMEVENT"] do
		if evt == event then
			for custkey , custval in DSCT_CUSTOMEVENT do	
				if custval.class == "ok" and custval.ani > 0 then
					for re1,re2,re3,re4,re5 in string.gfind( arg1, custval.search ) do					
						local ani = 5;
						local iscrit = 0;
						if custval.iscrit then
							if custval.iscrit ~= 0 then iscrit = 1;end
						end	
						if custval.ani then
							ani = custval.ani;
						end
						DSCT_Set("SHOWCUSTOM",ani);
						DSCT_SetColor("SHOWCUSTOM",custval.r,custval.g,custval.b);
						DSCT_Display_Toggle("SHOWCUSTOM",1,nil,format(custval.name, re1,re2,re3,re4,re5), iscrit);
						if custval.sound then PlaySoundFile(custval.sound)end
						re = true;--return true;
					end
				end
			end
		end
	end	
	return re;
end
function DSCT_Display()
end

function DSCT_Display_New( msgL ,msgR , txtFlag,color, direction,iscrit )

	local adat, adatpre;
	--DSCT_Set("ANIMODE",2);
	local theType = DSCT_Get("ANIMODE");
	
	if (DSCT_NameRegistered == 0) then
		return;
	end

	if direction > 3 or direction < 1 then direction = 1;end
	
	local parentName = "DSCTaniData"..DSCT_LastBar;
	--Set up  text animation
	adat = arrAniData["aniData"..DSCT_LastBar];
	--get last number
	local LastLastBar = DSCT_LastBar-1;
	if(LastLastBar == 0) then
		LastLastBar = DSCT_Get("ANIC");
	end
	adatpre = arrAniData["aniData"..LastLastBar];
	
	adat.Active = true;
	adat.starttimer = GetTime();
	
	--水平
	if (theType == 0) then
		adat.status = 0;
		adat.baseX = 60;
		adat.posX = 0;
		adat.posY = 0;
		adat.timer1 = 2;
		adat.timer2 = 2;
		adat.timer3 = adat.timer1 + 0.4;
		if direction == 1 then
			adat.angle1 = 180;--a
			adat.angle2 = 180;--b
			adat.distance1 = 200 * DSCT_ANI_PARAM1;
			adat.distance2 = adat.distance1 / adat.timer1 * 0.4;
		else
			adat.baseX = -adat.baseX;
			adat.angle1 = 0;--a
			adat.angle2 = 0;--b
			adat.distance1 = 200 * DSCT_ANI_PARAM1;
			adat.distance2 = adat.distance1 / adat.timer1 * 0.4;
			direction = 2;
		end

		adat.alpha = 0;
		adat.lastupdate = 0;

		if adat.starttimer - DSCT_Ani_Fix[direction][1] < 2 / DSCT_ANI_SPEED then			
			DSCT_Ani_Fix[direction][2] = DSCT_Ani_Fix[direction][2] + 1;
			if DSCT_Ani_Fix[direction][2] > 2 then DSCT_Ani_Fix[direction][2] = 0;end
			adat.baseY = -(DSCT_ANI_TEXTSIZE + 2) * DSCT_Ani_Fix[direction][2];
		else
			DSCT_Ani_Fix[direction][2] = 0;
		end
	end
	--垂直
	if (theType == 1) then
		adat.status = 0;
		adat.baseY = 25;
		adat.posX = 0;
		adat.posY = 0;
		adat.timer1 = 1.5;
		adat.timer2 = 1.5;
		adat.timer3 = adat.timer1 + 0.4;

		if direction == 1 then
			adat.angle1 = 90;--a
			adat.angle2 = 90;--b
			adat.distance1 = 100 * DSCT_ANI_PARAM1;
			adat.distance2 = adat.distance1 / adat.timer1 * 0.4;			
			local obj = arrAniData["aniData"..DSCT_Ani_Fix[direction][3]];
			local fix = 0;
			if obj.Active == true and obj.posY + obj.baseY < adat.baseY + DSCT_ANI_TEXTSIZE + 2 then
				fix = adat.baseY + DSCT_ANI_TEXTSIZE + 2 - (obj.posY + obj.baseY);
			end
			if fix ~= 0 then
				for i = 1,DSCT_Get("ANIC") do
					if i ~= DSCT_LastBar then
						obj = arrAniData["aniData"..i];
						if obj.Active == true and obj.angle1 == 90 then						
							obj.baseY = obj.baseY + fix;
						end
					end
				end
			end
		else
			direction = 2;
			adat.baseY = -adat.baseY;
			adat.angle1 = 270;--a
			adat.angle2 = 270;--b
			adat.distance1 = 100 * DSCT_ANI_PARAM1;
			adat.distance2 = adat.distance1 / adat.timer1 * 0.4;			
			local obj = arrAniData["aniData"..DSCT_Ani_Fix[direction][3]];
			local fix = 0;
			if obj.Active == true and obj.posY + obj.baseY > adat.baseY - DSCT_ANI_TEXTSIZE - 2 then
				fix = obj.posY + obj.baseY - (adat.baseY - DSCT_ANI_TEXTSIZE - 2);
			end
			if fix ~= 0 then
				for i = 1,DSCT_Get("ANIC") do
					if i ~= DSCT_LastBar then
						obj = arrAniData["aniData"..i];
						if obj.Active == true and obj.angle1 == 270 then						
							obj.baseY = obj.baseY - fix;
						end
					end
				end
			end
		end		
		adat.alpha = 0;
		adat.lastupdate = 0;		
	end
	--抛物线
	if (theType == 2) then
		adat.status = 0;
		adat.baseX = -55;
		adat.posX = 0;
		adat.posY = 0;
		adat.timer1 = 1.5;	
		adat.distance1 = 100 * DSCT_ANI_PARAM2;
		adat.distance2 = 2.6 * DSCT_ANI_PARAM1;
		adat.angle1 = -1;
		
		if direction > 1 then
			adat.baseX = -adat.baseX;
			adat.angle1 = -adat.angle1;
			direction = 2;
		end

		adat.alpha = 0;
		adat.lastupdate = 0;

		if adat.starttimer - DSCT_Ani_Fix[direction][1] < 0.9 / DSCT_ANI_SPEED then			
			DSCT_Ani_Fix[direction][2] = DSCT_Ani_Fix[direction][2] + 1;
			if DSCT_Ani_Fix[direction][2] > 2 then DSCT_Ani_Fix[direction][2] = 0;end
			adat.distance2 = adat.distance2 + 0.5 * DSCT_Ani_Fix[direction][2];
		else
			DSCT_Ani_Fix[direction][2] = 0;
		end
	end
	--弹出1
	if (theType == 3 or theType == 5) then
		adat.status = 0;
		adat.posX = 0;
		adat.posY = 0;
		adat.timer1 = 0.3;
		adat.timer2 = 1;
		adat.timer3 = 1.8;
		if direction == 1 then
			adat.angle1 = 5;
			adat.angle2 = 310;
			adat.distance1 = 150 * DSCT_ANI_PARAM1;
			adat.distance2 = 70 * DSCT_ANI_PARAM2;
		elseif direction == 2 then
			adat.angle1 = 130;
			adat.angle2 = 200;
			adat.distance1 = 80 * DSCT_ANI_PARAM1;
			adat.distance2 = 55 * DSCT_ANI_PARAM2;
		else
			adat.angle1 = 175;
			adat.angle2 = 200;
			adat.distance1 = 130 * DSCT_ANI_PARAM1;
			adat.distance2 = 70 * DSCT_ANI_PARAM2;
		end		
		adat.alpha = 1;
		adat.lastupdate = 0;

		if adat.starttimer - DSCT_Ani_Fix[direction][1] < 0.8 / DSCT_ANI_SPEED then
			DSCT_Ani_Fix[direction][2] = DSCT_Ani_Fix[direction][2] + 1;
			if DSCT_Ani_Fix[direction][2] > 2 then DSCT_Ani_Fix[direction][2] = 0;end
			adat.angle1 = adat.angle1 + random(18) - 9;
			adat.distance1 = adat.distance1 + 20 * DSCT_Ani_Fix[direction][2];
			local obj = arrAniData["aniData"..DSCT_Ani_Fix[direction][3]];
			obj.skip = true;
		else
			DSCT_Ani_Fix[direction][2] = 0;
		end
		if theType == 5 then
			adat.angle2 = 0;
			adat.distance2 = 0;
			adat.timer3 = 1.4;
		end
	end
	--弹出2
	if (theType == 4) then
		adat.status = 0;
		adat.posX = 0;
		adat.posY = 0;
		adat.timer1 = 0.5;
		adat.timer2 = 1.1;
		adat.timer3 = 2;
		if direction == 1 then
			adat.angle1 = 330;--a
			adat.angle2 = 30;--b
			adat.distance1 = 160 * DSCT_ANI_PARAM1;
			adat.distance2 = 60 * DSCT_ANI_PARAM2;
		elseif direction == 2 then
			adat.angle1 = 200;
			adat.angle2 = 150;
			adat.distance1 = 160 * DSCT_ANI_PARAM1;
			adat.distance2 = 60 * DSCT_ANI_PARAM2;
		else
			adat.angle1 = 270;
			adat.angle2 = 270;
			adat.distance1 = 110 * DSCT_ANI_PARAM1;
			adat.distance2 = 40 * DSCT_ANI_PARAM2;
		end		
		adat.alpha = 1;
		adat.lastupdate = 0;
		
		if adat.starttimer - DSCT_Ani_Fix[direction][1] < 0.8 / DSCT_ANI_SPEED then			
			DSCT_Ani_Fix[direction][2] = DSCT_Ani_Fix[direction][2] + 1;
			if DSCT_Ani_Fix[direction][2] > 2 then DSCT_Ani_Fix[direction][2] = 0;end
			--if direction ~= 3 then
			adat.angle1 = adat.angle1 + random(20) - 10;
			adat.distance1 = adat.distance1 + 20 * DSCT_Ani_Fix[direction][2];
			local obj = arrAniData["aniData"..DSCT_Ani_Fix[direction][3]];
			obj.skip = true;
		else
			DSCT_Ani_Fix[direction][2] = 0;
		end
	end
	--弹出3
	if (theType == 6) then
		adat.status = 0;
		adat.posX = 0;
		adat.posY = 0;
		adat.timer1 = 0.5;
		adat.timer2 = 1.0;
		adat.timer3 = 1.8;
		if direction == 1 then
			adat.angle1 = 25;
			adat.angle2 = 90;
			adat.distance1 = 100 * DSCT_ANI_PARAM1;
			adat.distance2 = 110 * DSCT_ANI_PARAM2;
		elseif direction == 2 then
			adat.angle1 = 155;
			adat.angle2 = 100;
			adat.distance1 = 90 * DSCT_ANI_PARAM1;
			adat.distance2 = 110 * DSCT_ANI_PARAM2;
		else
			adat.timer1 = 0.4;
			adat.angle1 = 330;
			adat.angle2 = 0;
			adat.distance1 = 100 * DSCT_ANI_PARAM1;
			adat.distance2 = 100 * DSCT_ANI_PARAM2;
		end		
		adat.alpha = 1;
		adat.lastupdate = 0;
		
		if adat.starttimer - DSCT_Ani_Fix[direction][1] < 0.8 / DSCT_ANI_SPEED then			
			DSCT_Ani_Fix[direction][2] = DSCT_Ani_Fix[direction][2] + 1;
			if DSCT_Ani_Fix[direction][2] > 2 then DSCT_Ani_Fix[direction][2] = 0;end
			local obj = arrAniData["aniData"..DSCT_Ani_Fix[direction][3]];
			obj.skip = true;
		else
			DSCT_Ani_Fix[direction][2] = 0;
		end		
	end
	DSCT_Ani_Fix[direction][3] = DSCT_LastBar;
	DSCT_Ani_Fix[direction][1] = adat.starttimer;
	
	--If they want to tag all self events

	adat.crit = 0;
	if iscrit then
		if iscrit == 1 then
			if DSCT_Get("CRITANI") == 1 then adat.crit = 1;end
		end
	end

	--set the color
	DSCT_SetAniTextColor(adat,color.r, color.g, color.b);
	--set alpha
	DSCT_SetAniTextAlpha(adat,adat.alpha);
	--Position
	adat.FObject:SetPoint("CENTER", "WorldFrame", "CENTER", adat.posX + adat.baseX, adat.posY + adat.baseY);--UIParent
	--Set the text to display
	
	if txtFlag == 3 then
		if (DSCT_Get("SHOWSELF") == 1) then		
			if msgL ~= nil and msgR ~= nil then
				msgL = msgL..DSCT_SelfFlag;
				msgR = DSCT_SelfFlag..msgR;			
			end
		end
		adat.txtObject1:ClearAllPoints();
		adat.txtObject2:ClearAllPoints();
		adat.txtObject2:SetPoint("RIGHT", parentName, "CENTER", 0, 0);
		adat.txtObject1:SetPoint("LEFT", parentName, "CENTER", 0, 0);
		if msgL then adat.txtObject1:SetText(msgL);end
		if msgR then adat.txtObject2:SetText(msgR);end
	else
		if (DSCT_Get("SHOWSELF") == 1) then		
			if msgL ~= nil and msgR ~= nil then
				msgL = DSCT_SelfFlag..msgL;
				msgR = msgR..DSCT_SelfFlag;
			elseif msgL ~= nil then
				msgL = DSCT_SelfFlag..msgL..DSCT_SelfFlag;
			else
				msgR = DSCT_SelfFlag..msgR..DSCT_SelfFlag;
			end
		end
		adat.txtObject1:ClearAllPoints();
		adat.txtObject2:ClearAllPoints();
		adat.txtObject2:SetPoint("LEFT", parentName, "CENTER", 0, 0);
		adat.txtObject1:SetPoint("RIGHT", parentName, "CENTER", 0, 0);
		if msgL then
			adat.txtObject1:SetText(msgL);
		else
			adat.txtObject1:SetText("");
		end		
		if msgR then
			adat.txtObject2:SetText(msgR);			
		else
			adat.txtObject2:SetText("");
		end
		if not msgL then
			adat.txtObject2:ClearAllPoints();
			adat.txtObject2:SetPoint("CENTER", parentName, "CENTER", 0, 0);
		end
		if not msgR then
			adat.txtObject1:ClearAllPoints();
			adat.txtObject1:SetPoint("CENTER", parentName, "CENTER", 0, 0);
		end
	end
	local Lw = adat.txtObject1:GetWidth();
	local Rw = adat.txtObject2:GetWidth();
	
	if msgL and msgR then
		if txtFlag == 3 then
			adat.txtObject2:SetPoint("RIGHT", parentName, "CENTER", Rw - (Lw + Rw) / 2, 0);
			adat.txtObject1:SetPoint("LEFT", parentName, "CENTER", Rw - (Lw + Rw) / 2, 0);
		else
			adat.txtObject1:SetPoint("RIGHT", parentName, "CENTER", Lw - (Lw + Rw) / 2, 0);
			adat.txtObject2:SetPoint("LEFT", parentName, "CENTER", Lw - (Lw + Rw) / 2, 0);
		end
	end
	--update current text being used
	DSCT_LastBar = DSCT_LastBar + 1;
	
	--if we reached the end, set to first
	if DSCT_LastBar >= (DSCT_Get("ANIC") + 1) then
		DSCT_LastBar = 1;
	end
	
end

----------------------
--Displays a message at the top of the screen
function DSCT_Display_Message(msg, color)
		--UIErrorsFrame:AddMessage(msg, color.r, color.g, color.b, 1.0, 1);
		local adat;
		
		if (DSCT_NameRegistered == 0) then
			return;
		end
		if (msg == nil) then
			return;
		end
	
		adat = arrCusMessData["cusMessData"..DENNIE_cusMessLast];
		DSCT_cusMessReset(adat);
		adat.txtbak = msg;
		adat.posX = DENNIE_cusMess_posX
		adat.posY = DENNIE_cusMess_posY;
		for i = 1,3 do
			if (i ~= DENNIE_cusMessLast) then
				local tmpdat;
				tmpdat = arrCusMessData["cusMessData"..i];
				if (tmpdat.Active == true) then					
					tmpdat.posY = tmpdat.posY + DENNIE_CUSMESS_TEXTSIZE;
				end
			end
		end	
		
		adat.alpha = DSCT_Get("MESSAGEALPHA");

		adat.FObject:SetTextHeight(DENNIE_CUSMESS_TEXTSIZE);
		--set the color
		adat.FObject:SetTextColor(color.r, color.g, color.b);
		--set alpha
		adat.FObject:SetAlpha(adat.alpha);
		--Position
		adat.FObject:SetPoint("CENTER", "UIParent", "CENTER", adat.posX, adat.posY);
		--Set the text to display
		adat.FObject:SetText(msg);
		
		adat.lastupdate = GetTime();
		
		adat.Active = true;

		DENNIE_cusMessLast = DENNIE_cusMessLast + 1;
		if (DENNIE_cusMessLast > 3) then
			DENNIE_cusMessLast = 1;
		end
end

function DSCT_Display_Toggle(name,txtFlag,msgL,msgR,iscrit, msg2)
	if (msgL == nil and msgR == nil) or name == nil then return;end
	
	local val = DSCT_Get(name);
	if val == nil then return;end
	if val == 0 then return;end
	if val > 3 then		
		if msg2 ~= nil then
			DSCT_Display_Message( msg2, DSCT_nGetColor(name) );
		else
			if not msgL then msgL = "";end
			if not msgR then msgR = "";end
			DSCT_Display_Message( msgL..msgR, DSCT_nGetColor(name) );
		end
	else
		--如果是中文，判断第二个是不是nil，是的话将第一个移动到第二个
		if txtFlag == 1 and msgR == nil then
			msgR = msgL;
			msgL = nil;
		end
		if txtFlag == 2 and msgR ~= nil then
			msgL = msgL..msgR;
			msgR = nil;
		end
		DSCT_Display_New( msgL ,msgR, txtFlag,DSCT_nGetColor(name), val,iscrit );
	end	
end

-- Update the animcation
function DSCT_TextUpdate()	
	DSCT_updateAnimation();
	local aaa = sin(GetTime() * 20) * 20;
	if aaa < 0 then aaa = -aaa;end
end

----------------------
-- Upate animations that are being used
function DSCT_updateAnimation()		
	local timer;
	local timer2;
	local bak;
	local beupdataed = false;
	
	DENNIE_TYPE4_FixFlag = true;
	local posx,posy;
	for key, value in arrAniData do
		if (value.Active == true) then
			DSCT_doAnimation(value);
			posx = (value.posX + value.baseX)  * DSCT_ROTATION_COS - (value.posY + value.baseY) * DSCT_ROTATION_SIN;
			posy = (value.posX + value.baseX) * DSCT_ROTATION_SIN + (value.posY + value.baseY) * DSCT_ROTATION_COS;
			posx = posx + DENNIE_ani_posX;
			posy = posy + DENNIE_ani_posY;
			if value.alpha > DSCT_ANI_ALPHAMAX then				
				DSCT_SetAniTextAlpha(value,DSCT_ANI_ALPHAMAX);
			else
				DSCT_SetAniTextAlpha(value,value.alpha);
			end
			value.FObject:SetPoint("CENTER", "UIParent", "CENTER", posx ,posy );--Dennie Add
		end
	end	
	for key, value in arrCusMessData do
		--if (value.Active) then
			DSCT_doCusMess(value);		
		--end
	end

end

----------------------
function DSCT_doCusMess(cusMessData)
	if ( cusMessData.Active == true) then
		local curtime = GetTime();
		if cusMessData.SpellTime ~= -1 then
			local spelltime = cusMessData.SpellTime - curtime + cusMessData.SpellStartTimer;
			if spelltime > 0 then
				if spelltime > 1 then
					cusMessData.FObject:SetText(format(cusMessData.txtbak.." |cffffffff%.1f|r", spelltime));
				else
					cusMessData.FObject:SetText(format(cusMessData.txtbak.." |cffffff00%.1f|r", spelltime));
				end
			else
				cusMessData.FObject:SetText(cusMessData.txtbak.." |cffffffff---|r");
			end
		end
		if ((curtime  - cusMessData.lastupdate) > DSCT_MESS_TIMER) then
			if curtime - cusMessData.lastupdate - DSCT_MESS_TIMER < DSCT_MESS_FADETIMER then
				cusMessData.alpha = (1 - (curtime - cusMessData.lastupdate - DSCT_MESS_TIMER) / DSCT_MESS_FADETIMER) * DSCT_MESS_ALPHAMAX;
			else			
				DSCT_cusMessReset(cusMessData);
				return;
			end			
		end
		if cusMessData.alpha > DSCT_MESS_ALPHAMAX then cusMessData.alpha = DSCT_MESS_ALPHAMAX;end
		cusMessData.FObject:SetAlpha(cusMessData.alpha);
		cusMessData.FObject:SetPoint("CENTER", "UIParent", "CENTER", cusMessData.posX, cusMessData.posY);--Dennie Add

	end	
end

--Move text to get the animation
function DSCT_doAnimation(adat)	--If a crit			
	
	
	--[[
		if (DENNIE_aniDelay > 0) then
			DENNIE_aniDelay = DENNIE_aniDelay - 1;
			aniData.lastupdate = GetTime();
		end]]		
	--if its time to update, move the text step positions
	if ( adat.Active == true) then
		local theType = DSCT_Get("ANIMODE");		
		local curtime = GetTime() - adat.starttimer;
		curtime = DSCT_ANI_SPEED * curtime;
		if adat.sp == true then theType = 99;end
		if theType == 99 then
			if curtime < 0.2 then
				adat.alpha = curtime * 5;
			elseif curtime < 1.5 then
				adat.alpha = 1;
			elseif curtime < 1.9 then
				adat.alpha = 1 - (curtime - 1.5) / 0.4;
			else
				DSCT_aniReset(adat);
				return;
			end
		end
		if theType == 2 then
			if curtime < adat.timer1 then
				adat.posX = (curtime / adat.timer1) * adat.distance1;
				adat.posY = -adat.posX * adat.posX * 0.04 + adat.distance2 * adat.posX;
				adat.posX = adat.angle1 * adat.posX;
				if curtime < 0.2 then
					adat.alpha = curtime * 5;
				elseif curtime > adat.timer1 - 0.4 then
					adat.alpha = 1 - (curtime - (adat.timer1 - 0.4)) / 0.4;	
				else
					adat.alpha = 1;
				end
			else
				DSCT_aniReset(adat);
				return;
			end
		end
		if theType == 3 then
			if curtime < adat.timer1 then
				adat.posX = -cos(adat.angle1) * adat.distance1 * curtime / adat.timer1;
				adat.posY = sin(adat.angle1) * adat.distance1 * curtime / adat.timer1;
			elseif curtime < adat.timer2 then
				if adat.status ~= 1 then
					adat.status = 1;
					adat.posX = -cos(adat.angle1) * adat.distance1;
					adat.posY = sin(adat.angle1) * adat.distance1;
				end
				if curtime < adat.timer1 + 0.4 then
					if curtime - adat.lastupdate > 0.1 then
						adat.lastupdate = curtime;
						adat.posX = adat.posX + adat.baseX;
						adat.posY = adat.posY + adat.baseY;
						adat.bakX = random(70) - 35;
						adat.bakY = random(70) - 35;
						adat.baseX = 0;
						adat.baseY = 0;
					end
					adat.baseX = adat.bakX * (curtime - adat.lastupdate);
					adat.baseY = adat.bakY * (curtime - adat.lastupdate);
				end
				if adat.skip == true then
					adat.starttimer = adat.starttimer - (adat.timer2 - curtime);
				end
			elseif curtime < adat.timer3 then				
				if adat.status ~= 2 then
					adat.status = 2;
					adat.baseX = adat.baseX + adat.posX;
					adat.baseY = adat.baseY + adat.posY;
				end
				if curtime > adat.timer3 - 0.4 then
					adat.alpha = 1 - (curtime - (adat.timer3 - 0.4)) / 0.4;
				end
				adat.posX = -cos(adat.angle2) * adat.distance2 * (curtime - adat.timer2) / (adat.timer3 - adat.timer2);
				adat.posY = sin(adat.angle2) * adat.distance2 * (curtime - adat.timer2) / (adat.timer3 - adat.timer2);			
			else
				DSCT_aniReset(adat);
				return;
			end
		end
		if theType == 0 or theType == 1 or theType == 4 or theType == 5 or theType == 6 then			
			if curtime < adat.timer1 then
				adat.posX = -cos(adat.angle1) * adat.distance1 * curtime / adat.timer1;
				adat.posY = sin(adat.angle1) * adat.distance1 * curtime / adat.timer1;
				if adat.alpha ~= 1 then
					if curtime < 0.25 then
						adat.alpha = curtime * 4;
					else
						adat.alpha = 1;
					end
				end
			elseif curtime < adat.timer2 then
				if adat.status ~= 1 then
					adat.status = 1;
					adat.posX = -cos(adat.angle1) * adat.distance1;
					adat.posY = sin(adat.angle1) * adat.distance1;
				end
				if adat.skip == true then
					adat.starttimer = adat.starttimer - (adat.timer2 - curtime);
				end
			elseif curtime < adat.timer3 then
				if adat.status ~= 2 then
					adat.status = 2;
					adat.baseX = adat.baseX + adat.posX;
					adat.baseY = adat.baseY + adat.posY;
				end
				if curtime > adat.timer3 - 0.4 then
					adat.alpha = 1 - (curtime - (adat.timer3 - 0.4)) / 0.4;
				else
					adat.alpha = 1;
				end
				adat.posX = -cos(adat.angle2) * adat.distance2 * (curtime - adat.timer2) / (adat.timer3 - adat.timer2);
				adat.posY = sin(adat.angle2) * adat.distance2 * (curtime - adat.timer2) / (adat.timer3 - adat.timer2);				
			else
				DSCT_aniReset(adat);
				return;
			end
		end		
		--=============================================================Dennie Add end
		
		if adat.crit > 0 then
			if curtime < 0.2 then
				DSCT_SetAniTextHeight(adat,1.6);		
			elseif curtime <= 0.4 then
				DSCT_SetAniTextHeight(adat, (1.6 - (curtime - 0.2) * 3 ));
			else
				DSCT_SetAniTextHeight(adat,1);
				adat.crit = 0;
			end	
		end
	end
	return true;
end

----------------------
--count the number of crits active
function DSCT_critCount()
	local count = 0
	
	for key, value in arrAniData do
		if (value.crit) then
			count = count + 1;
		end
	end
	
	return count;
end

----------------------
--Rest the text animation
function DSCT_aniReset(aniData)	
	
	aniData.Active = false;
	aniData.crit = 0;
	aniData.posY = 0;
	aniData.posX = 0;
	aniData.baseX = 0;
	aniData.baseY = 0;
	aniData.sp = false;
	aniData.alpha = 0;
	aniData.addY = 0;--Dennie Add
	aniData.addX = 0;--Dennie Add
	aniData.skip = false;
	aniData.mir = 1;
	aniData.critdelay = 0;
	
	DSCT_SetAniTextAlpha(aniData,aniData.alpha);
	aniData.FObject:SetPoint("CENTER", "UIParent", "CENTER", aniData.posX, aniData.posY);
end

----------------------
--Rest all the text animations
function DSCT_aniResetAll()
	
	for key, value in arrAniData do
		DSCT_aniReset(value);
	end

end


function DSCT_cusMessReset(cusMessData)	
	
	cusMessData.Active = false;
	cusMessData.posY = 0;
	cusMessData.posX = 0;
	cusMessData.alpha = 0;
	cusMessData.lastupdate = 0;
	cusMessData.txtbak = "";
	cusMessData.SpellTime = -1;
	cusMessData.SpellStartTimer = 0;
	
	cusMessData.FObject:SetAlpha(0);
	cusMessData.FObject:SetPoint("CENTER", "UIParent", "CENTER", cusMessData.posX, cusMessData.posY);
end

function DSCT_cusMessResetAll()	
	for key, value in arrCusMessData do
		DSCT_cusMessReset(value);
	end
end

----------------------
--Initial animation settings
function DSCT_cusMessInit()
	local MessFontSize;
	MessFontSize = DSCT_Get("MESSAGESIZE");
	if (MessFontSize < 12) then
		MessFontSize = 12;
	end
	if (MessFontSize > 36) then
		MessFontSize = 36;
	end
	DENNIE_cusMessLast = 1;
	
	
	local FontNumber = DSCT_Get("MESSAGEFONT");
	if DSCT_FONTLIST[FontNumber] == nil then
		--DSCT_Set("MESSAGEFONT",1);
		FontNumber = 1;
	end
	local FontName = DSCT_FONTLIST[FontNumber].path;
	local FontOutTxt = "";
	FontOutline = DSCT_Get("MESSFONTOUTLINE");

	if (FontOutline == 2) then
		FontOutTxt = "OUTLINE";
	elseif (FontOutline == 3) then
		FontOutTxt = "THICKOUTLINE";	
	end

	for key, value in arrCusMessData do
		--value.FObject = getglobal("DSCT"..key);
		value.FObject = getglobal("DSCT"..key);
		value.FObject:SetFont(FontName, MessFontSize,FontOutTxt);
		if FontOutline > 3 then
			value.FObject:SetShadowColor(0,0,0);
			value.FObject:SetShadowOffset(FontOutline - 3,-FontOutline + 3);
		end
	end
	
	DENNIE_CUSMESS_TEXTSIZE = MessFontSize;
	DSCT_cusMessResetAll();
end

function DSCT_ToDec(a)
	local i = 0;
	while a - i > 1 do
		i = i + 1;
	end
	return i;
end
function DSCT_ToHEX(a)
	local b = a * 256;
	return ""..DSCT_HEX_LIST[DSCT_ToDec(b / 16) + 1]..DSCT_HEX_LIST[ DSCT_ToDec( ( b / 16 - DSCT_ToDec(b / 16) ) * 16 ) + 1];
end
function DSCT_ColorFlip(r,g,b)
	return "|cff"..DSCT_ToHEX(r)..DSCT_ToHEX(g)..DSCT_ToHEX(b);
end

function DSCT_aniInit()
	local FontNumber;

	local FontOutTxt = "";
	local FontOutline = DSCT_Get("FONTOUTLINE");
	
	local FontName = "Fonts\\ARIALN.ttf";
	local FontNumber = DSCT_Get("FONT");		
	local FontSize = DSCT_Get("TEXTSIZE");
	
	local EnFontNumber = DSCT_Get("ENFONT");
	local EnFontSize = DSCT_Get("ENTEXTSIZE");
	if DSCT_FONTLIST[FontNumber] == nil then
		--DSCT_Set("FONT",1);
		FontNumber = 1;		
	end
	if DSCT_ENFONTLIST[EnFontNumber] == nil then
		EnFontNumber = 1;
	end

	if (FontOutline == 2) then
		FontOutTxt = "OUTLINE";
	elseif (FontOutline == 3) then
		FontOutTxt = "THICKOUTLINE";	
	end
	
	for key, value in arrAniData do
		--value.FObject = getglobal("DSCT"..key);
		value.FObject = getglobal("DSCT"..key);
		value.txtObject1 = getglobal("DSCT"..key.."_LEFT");
		value.txtObject2 = getglobal("DSCT"..key.."_RIGHT");		
		value.txtObject1:SetFont(DSCT_ENFONTLIST[EnFontNumber].path, EnFontSize,FontOutTxt);
		value.txtObject2:SetFont(DSCT_FONTLIST[FontNumber].path, FontSize,FontOutTxt);
		if FontOutline > 3 then
			value.txtObject1:SetShadowColor(0,0,0);
			value.txtObject2:SetShadowColor(0,0,0);
			value.txtObject1:SetShadowOffset(FontOutline - 3,-FontOutline + 3);
			value.txtObject2:SetShadowOffset(FontOutline - 3,-FontOutline + 3);
		end
		value.lastupdate = 0;		
	end
	
	DSCT_aniResetAll();
end

----------------------
--function of spell alert
function DSCT_isParty(name)
	for i = 1, 4, 1 do
		local partyname = UnitName("party" .. i);
		if (name == partyname ) then
			if not UnitCanAttack("party" .. i, "player") then return 1;end
		end
	end
	return nil;
end

function DSCT_openPreView()
	local adat;
	if (DSCT_NameRegistered == 0) then
		return;
	end
	
	local pre = getglobal("DSCT_PreMessBox");
	pre:ClearAllPoints();
	pre:SetPoint("CENTER", "UIParent", "CENTER", DSCT_Get("MESSAGEPOSX",x), DSCT_Get("MESSAGEPOSY",y));
	pre:Show();
	
	pre = getglobal("DSCT_PreAniBox");
	pre:ClearAllPoints();
	pre:SetPoint("CENTER", "UIParent", "CENTER", DSCT_Get("ANIPOSX",x), DSCT_Get("ANIPOSY",y));
	pre:Show();
	
	DSCT_RefreshStaticVar();
end

function DSCT_closePreView()	
	if (DSCT_NameRegistered == 0) then
		return;
	end
	local pre = getglobal("DSCT_PreMessBox");
	pre:Hide();	
	pre = getglobal("DSCT_PreAniBox");
	pre:Hide();	
end

function DSCT_Cmd(msg)
	if DSCT_NameRegistered ~= 1 then return;end	
	if DSCT_Get("ENABLED") ~= 1 then return;end
	local cmdlist = {nil,nil,nil,nil,nil,nil};
	local i = 1;
	local findval = 0;
	if msg == "" then
		if DSCTOptions then DSCT_showMenu();else DSCT_Debug("无菜单");end
		return;
	end	
	while msg ~= nil do
		if strfind(msg," ") then
			findval = strfind(msg," ");
			cmdlist[i] = strsub(msg,1,findval - 1);
			val = strsub(msg,strfind(msg," ") + 1,strlen(msg));
			msg = strsub(msg,strfind(msg," ") + 1,strlen(msg));
		else
			cmdlist[i] = msg;
			msg = nil;
		end		
		i = i + 1;
	end
	
	if cmdlist[1] and cmdlist[2] then
		if strlower(cmdlist[1]) == "save" then
			DSCT_NEWCONFIG[strlower(cmdlist[2]).."_save"] = nil;
			DSCT_NEWCONFIG[strlower(cmdlist[2]).."_save"] = DSCT_clone(DSCTPlayer);
			DSCT_Debug("保存到: "..strlower(cmdlist[2]));			
		end
		if strlower(cmdlist[1]) == "load" then
			if DSCT_NEWCONFIG[strlower(cmdlist[2]).."_save"] then
				DSCT_Load(DSCT_NEWCONFIG[strlower(cmdlist[2]).."_save"]);
				DSCT_Debug("已读取: "..strlower(cmdlist[2]));
			else
				DSCT_Debug("不存在的存档: "..strlower(cmdlist[2]));
			end
		end
		if strlower(cmdlist[1]) == "delete" then
			if DSCT_NEWCONFIG[strlower(cmdlist[2]).."_save"] then
				DSCT_NEWCONFIG[strlower(cmdlist[2]).."_save"] = nil;
				DSCT_Debug("已删除: "..strlower(cmdlist[2]));
			else
				DSCT_Debug("不存在的存档: "..strlower(cmdlist[2]));
			end
		end
		
		return;
	end
	if strlower(cmdlist[1]) == "list" then
		DSCT_Debug("目前所有的存档列表: ");
		for key,val in DSCT_NEWCONFIG do
			if string.sub(key,string.len(key) - 4,string.len(key)) == "_save" then
				DSCT_Debug(string.sub(key,1,string.len(key) - 5) );
			end
		end
		return;
	end
	
	DSCT_Debug("|cffffff00DSCT 命令帮助:|r");
	DSCT_Debug("/sct save |cffff0000name|r:保存当前设置到指定档案名,例:/sct save myconfig1");
	DSCT_Debug("/sct load |cffff0000name|r:读取指定档案,例:/sct load myconfig1");
	DSCT_Debug("/sct delete |cffff0000name|r:删除指定档案,例:/sct delete myconfig1");
	DSCT_Debug("/sct list:列出目前所有存档的名字");
end

function DSCT_SetAniTextHeight(adat,p)
	adat.txtObject1:SetTextHeight(DSCT_ANI_ENTEXTSIZE * p);
	adat.txtObject2:SetTextHeight(DSCT_ANI_TEXTSIZE * p);
end

function DSCT_SetAniTextAlpha(adat,a)
	adat.txtObject1:SetAlpha(a);
	adat.txtObject2:SetAlpha(a);
end

function DSCT_SetAniTextColor(adat,r,g,b)
	adat.txtObject1:SetTextColor(r,g,b);
	adat.txtObject2:SetTextColor(r,g,b);
end