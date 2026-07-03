--[[
path: /KillLog/
filename: localization.lua
author: Daniel Risse <dan@risse.com>
update: Detritis <Slynx - Quel'Thalas>	
created: Mon, 17 Jan 2005 17:33:00 -0800
updated: Thurs, 26 Jan 2007

Kill Log: A record of your exploits fighting creeps in Azeroth
]]

-- text for GUI window title
KILLLOG_TITLE = "Kill Log " .. KILLLOG_VERSION;

-- text for GUI bottom tabs
KILLLOG_TAB_GENERAL = "一般";
KILLLOG_TAB_LIST = "列表";
KILLLOG_TAB_DEATH = "死亡";
KILLLOG_TAB_OPTIONS = "选项";

KILLLOG_LABEL_DEFAULT = "默认";
KILLLOG_LABEL_PET = "(宠物)";
KILLLOG_LABEL_HIT = "击中";
KILLLOG_LABEL_CRIT = "致命一击";
KILLLOG_LABEL_DAMAGE = "击中";
KILLLOG_LABEL_HEAL = "治疗";

-- text for GUI top tabs on LIST tab
KILLLOG_LIST_OVERALL = "总";
KILLLOG_LIST_SESSION = "本次游戏";
KILLLOG_LIST_LEVEL = "等级";

-- text for creeps without defined type
KILLLOG_LIST_UNKNOWNTYPE = "未知";
KILLLOG_LIST_NORMALTYPE = "一般";

-- these are used both for the Sort labels and for the labels in the detail
KILLLOG_LABEL_RECENT = "最近";
KILLLOG_LABEL_TYPE = "大类型";
KILLLOG_LABEL_FAMILY = "小类型";
KILLLOG_LABEL_CLASS = "职业";
KILLLOG_LABEL_NAME = "名字";
KILLLOG_LABEL_LEVEL = "等级";
KILLLOG_LABEL_LOCATION = "位置";
KILLLOG_LABEL_KILL = "击杀";
KILLLOG_LABEL_DEATH = "死亡";
KILLLOG_LABEL_XP = "经验";
KILLLOG_LABEL_RESTED = "精力充沛";
KILLLOG_LABEL_GROUP = "队伍";
KILLLOG_LABEL_RAID = "团队";

-- these are for changing the creep type
KILLLOG_LABEL_CHANGE_FAMILY = "改变敌对小类型";
KILLLOG_STATIC_CHANGE_FAMILY_BLURB = "输入一个新的敌对小类型为这个怪物";
KILLLOG_LABEL_CHANGE_TYPE = "改变敌对大类型";
KILLLOG_STATIC_CHANGE_TYPE_BLURB = "输入新的大类型为这敌对";
KILLLOG_LABEL_DELETE = "删除敌对条目";
KILLLOG_STATIC_DELETE_BLURB = "您确定要删除这个条目吗？";


-- formatting for updating tooltip
KILLLOG_TOOLTIP_KILL_COUNT = "击杀 %d, 平均经验: %d";
KILLLOG_TOOLTIP_DEATH_COUNT = "死亡 %d";

KILLLOG_NEW_MAX = "新的最高伤害: %s %s 为 %s!";
KILLLOG_NEW_MAX_HEAL = "新的最高治疗: %s %s 为 %s!";

KILLLOG_MAXHIT_TITLE = "最高击中";
KILLLOG_MAXHEALS_TITLE = "最高治疗";
KILLLOG_EXPERIENCE_TITLE = "经验总结";
KILLLOG_CREEP_TITLE = "战斗总结";
KILLLOG_LABEL_QUEST = "任务";
KILLLOG_LABEL_EXPLORATION = "勘查";
KILLLOG_LABEL_CREEP_XP = "敌对";
KILLLOG_NOT_AVAILABLE = "无法使用的";

KILLLOG_DEATH_TITLE = "死亡历史";
-- KILLLOG_DEATH_FORMAT1				= "%d: Killed by <%s> at\n    level <%d> on <%s>";
-- KILLLOG_DEATH_FORMAT2				= "%d: Killed by <%s> at\n      level <%d> on <%s>";
-- KILLLOG_DEATH_FORMAT3				= "%d: Killed by <%s> at\n        level <%d> on <%s>";

KILLLOG_DEATH_FORMAT1 = "%d: <%s> 击杀了你\n    等级 <%d> 在 <%s>";
KILLLOG_DEATH_FORMAT2 = "%d: <%s> 击杀了你\n      等级 <%d> 在 <%s>";
KILLLOG_DEATH_FORMAT3 = "%d: <%s> 击杀了你\n        等级 <%d> 在 <%s>";


-- binding texts
BINDING_HEADER_KILLLOG = "Kill Log";
BINDING_NAME_KILLLOG_TOGGLE = "Kill Log 窗口开关";
BINDING_NAME_KILLLOG_GENERAL = "打开一般信息";
BINDING_NAME_KILLLOG_LIST = "打开遭遇列表";
BINDING_NAME_KILLLOG_DEATH = "打开你的死亡列表";
BINDING_NAME_KILLLOG_OPTIONS = "打开设置选项";


-- used for button in Cosmos menu
KILLLOG_BUTTON_TEXT = BINDING_HEADER_KILLLOG;
KILLLOG_BUTTON_SUBTEXT = "计数&经验";
KILLLOG_BUTTON_TIP = "一个你在艾泽拉斯奋战的战绩和记录";


-- used to fill creep family
-- this is FAR from complete
KILLLOG_CREEP_FAMILIES = {
  ["Basilisk"] = { "蜥蜴" },
  ["Kodo"] = { "科多", "科多兽" },
  ["Slime"] = { "软泥", "泥浆" },
  ["Threshadon"] = { "蛇颈龙" },
  ["Zhevra"] = { "斑马" },
  ["Whelp"] = { "幼龙", "雏龙", "新兵" },
  ["Critter"] = { "Adder", "Hare", "Rat" },
  ["Dwarf"] = { "矮人" },
  ["Gnome"] = { "侏儒" },
  ["Gnoll"] = { "Gnoll", "Mosshide", "Redridge", "Riverpaw" },
  ["Human"] = { "Defias", "Kul Tiras", "Scarlet", "Tirisfal" },
  ["Kobold"] = { "Kobold" },
  ["Murloc"] = { "Murloc" },
  ["Naga"] = { "Naga", "Slitherblade" },
  ["Ogre"] = { "Ogre", "Mo'grosh" },
  ["Orc"] = { "兽人", "黑石" },
  ["Quillboar"] = { "Quillboar" },
  ["Skeleton"] = { "Skeleton" },
  ["Trogg"] = { "Stonesplinter", "Trogg" },
  ["Worgen"] = { "Worgen" },
  ["Zombie"] = { "Zombie", "Rotting Dead", "Ravaged Corpse" },
  ["Elemental"] = { "Elemental" },
  ["Demon"] = { "Demon", "Darkhound" },
  ["Mechanical"] = { "Mechanical" },
  ["Centaur"] = { "Gelkis" },
}

-- strings for the opions tab
-- these are placeholders and not very descriptive yet...
KILLLOG_OPTION_STORE_MAX = "伤害监视";
KILLLOG_OPTION_TOOLTIP_STORE_MAX = "监视最大伤害";
KILLLOG_OPTION_NOTIFY_MAX = "最大通知";
KILLLOG_OPTION_TOOLTIP_NOTIFY_MAX = "显示新的最大伤害的通知";
KILLLOG_OPTION_STORE_CREEP = "存储遭遇信息";
KILLLOG_OPTION_TOOLTIP_STORE_CREEP = "存储遭遇信息";
KILLLOG_OPTION_STORE_LOCATION = "保存位置";
KILLLOG_OPTION_TOOLTIP_STORE_LOCATION = "跟踪您遇到的敌对位置";
KILLLOG_OPTION_SESSION = "跟踪本次游戏信息";
KILLLOG_OPTION_TOOLTIP_SESSION = "跟踪本次游戏信息";
KILLLOG_OPTION_DEBUG = "显示调试信息";

KILLLOG_OPTION_TOOLTIP = "敌对状态";
KILLLOG_OPTION_TOOLTIP_TOOLTIP = "当你鼠标移到敌对身上时, 显示击杀和死亡信息";
KILLLOG_OPTION_STORE_DEATH = "跟踪死亡";
KILLLOG_OPTION_TOOLTIP_STORE_DEATH = "跟踪死亡";
KILLLOG_OPTION_STORE_OVERALL = "跟踪全部信息";
KILLLOG_OPTION_TOOLTIP_STORE_OVERALL = "跟踪全部信息";
KILLLOG_OPTION_TRIVIAL = "不重要的敌对列表";
KILLLOG_OPTION_TOOLTIP_TRIVIAL = "在列表中包含不重要的敌对";
KILLLOG_OPTION_TOOLTIP_DEBUG = "显示调试信息";

KILLLOG_OPTION_STORE_LEVEL = "由等级排序监视";
KILLLOG_OPTION_TOOLTIP_STORE_LEVEL = "跟踪每个等级信息";
KILLLOG_OPTION_SLIDER_STORE_LEVEL = "等级";
KILLLOG_OPTION_SLIDER_TOOLTIP_STORE_LEVEL = "跟踪等级的数目";

KILLLOG_OPTION_PORTRAIT = "启用头像";
KILLLOG_OPTION_TOOLTIP_PORTRAIT = "启用头像";
KILLLOG_OPTION_SLIDER_PORTRAIT = "头像";
KILLLOG_OPTION_SLIDER_TOOLTIP_PORTRAIT = "使用的头像个数";
-- New
KILLLOG_OPTION_SLIDER_DEBUG = "debug";
KILLLOG_OPTION_SLIDER_TOOLTIP_DEBUG = "使用的调试等级";

KILLLOG_OPTION_SCT_SUPPORT = "启用 SCT";
KILLLOG_OPTION_TOOLTIP_SCT_SUPPORT = "启用 SCT 通知类型";

KILLLOG_CLEAR = "清除";
KILLLOG_CLEAR_CONFIRMATION = "这会抹掉所有为你的角色收集的所有信息吗.你确定吗?\n\n警告!!!\n 将在清除之后重新加载UI.";

if (GetLocale() == "deDE") then
  -- text for GUI window title
  KILLLOG_TITLE = "Kill Log " .. KILLLOG_VERSION;

  -- text for GUI bottom tabs
  KILLLOG_TAB_GENERAL = "Allgemein";
  KILLLOG_TAB_LIST = "Liste";
  KILLLOG_TAB_DEATH = "Gestorben";
  KILLLOG_TAB_OPTIONS = "Optionen";

  -- text for GUI top tabs on LIST tab
  KILLLOG_LIST_OVERALL = "Alles";
  KILLLOG_LIST_SESSION = "Sitzung";
  KILLLOG_LIST_LEVEL = "Stufe";

  -- text for creeps without defined type (killed without ever mouseovering)
  KILLLOG_LIST_UNKNOWNTYPE = "Unbekannt";
  KILLLOG_LIST_NORMALTYPE = "Normal";

  -- these are used both for the Sort labels and for the labels in the detail
  KILLLOG_LABEL_RECENT = "Neueste";
  KILLLOG_LABEL_TYPE = "Typ";
  KILLLOG_LABEL_FAMILY = "Rasse";
  KILLLOG_LABEL_CLASS = "Kategorie";
  KILLLOG_LABEL_NAME = "Name";
  KILLLOG_LABEL_LEVEL = "Stufe";

  KILLLOG_LABEL_KILL = "Getötet";
  KILLLOG_LABEL_DEATH = "Gestorben";
  KILLLOG_LABEL_XP = "Erfahrung";
  KILLLOG_LABEL_RESTED = "Erholt";
  KILLLOG_LABEL_GROUP = "Gruppe";
  KILLLOG_LABEL_RAID = "Raid";

  -- these are for changing the creep type
  KILLLOG_LABEL_CHANGE_FAMILY = "Creep-Rasse verändern";
  KILLLOG_STATIC_CHANGE_FAMILY_BLURB = "Die neue Rasse fuer diesen Creep eingeben";
  KILLLOG_LABEL_CHANGE_TYPE = "Creep-Typ verändern";
  KILLLOG_STATIC_CHANGE_TYPE_BLURB = "Den neuen Typ für diesen Creep eingeben";
  KILLLOG_LABEL_DELETE = "Creep-Eintrag löschen";
  KILLLOG_STATIC_DELETE_BLURB = "Sind Sie sicher, dass Sie diesen Eintrag löschen möchten?";


  -- formatting for updating tooltip
  KILLLOG_TOOLTIP_KILL_COUNT = "Getötet: %d, Erf. %d";
  KILLLOG_TOOLTIP_DEATH_COUNT = "Gestorben: %d";

  KILLLOG_NEW_MAX = "Neuer maximaler Schaden: %s %s für %s!";

  KILLLOG_MAXHIT_TITLE = "Härteste Schläge";
  KILLLOG_EXPERIENCE_TITLE = "Erfahrungs-Zusammenfassung";
  KILLLOG_CREEP_TITLE = "Creep-Zusammenfassung";
  KILLLOG_LABEL_QUEST = "Quest";
  KILLLOG_LABEL_EXPLORATION = "Entdeckung";
  KILLLOG_LABEL_CREEP_XP = "Creep";
  KILLLOG_NOT_AVAILABLE = "Nicht verfügbar";
  KILLLOG_LABEL_LOCATION = "Position";
  KILLLOG_DEATH_TITLE = "Todes-Liste";
  KILLLOG_DEATH_FORMAT = "%s gegen %s (mit Level %d)\n\n";

  -- binding texts
  BINDING_HEADER_KILLLOG = "Kill Log";
  BINDING_NAME_KILLLOG_TOGGLE = "Kill Log Fenster an/ausschalten";
  BINDING_NAME_KILLLOG_GENERAL = "Die Allgemeinen Informationen öffnen";
  BINDING_NAME_KILLLOG_LIST = "Die Creepliste aufrufen";
  BINDING_NAME_KILLLOG_DEATH = "Die Liste eurer Tode öffnen";
  BINDING_NAME_KILLLOG_OPTIONS = "Die Konfiguration öffnen";

  -- used for button in Cosmos menu
  KILLLOG_BUTTON_TEXT = BINDING_HEADER_KILLLOG;
  KILLLOG_BUTTON_SUBTEXT = "Count and xp";
  KILLLOG_BUTTON_TIP = "A record of your exploits fighting creeps in Azeroth";

  -- used to fill creep family
  --   this is FAR from complete
  -- KILLLOG_CREEP_FAMILIES = {
  -- };
elseif (GetLocale() == "frFR") then
  -- Traduit par Juki <Unskilled>

  -- text for GUI window title
  KILLLOG_TITLE = "Kill Log " .. KILLLOG_VERSION;

  -- text for GUI bottom tabs
  KILLLOG_TAB_GENERAL = "Général";
  KILLLOG_TAB_LIST = "Liste";
  KILLLOG_TAB_DEATH = "Mort";
  KILLLOG_TAB_OPTIONS = "Options";

  KILLLOG_LABEL_DEFAULT = "Défaut";
  KILLLOG_LABEL_PET = "(pet)";
  KILLLOG_LABEL_HIT = "hit";
  KILLLOG_LABEL_CRIT = "crit";

  -- text for GUI top tabs on LIST tab
  KILLLOG_LIST_OVERALL = "Global";
  KILLLOG_LIST_SESSION = "Session";
  KILLLOG_LIST_LEVEL = "Niveau";

  -- text for creeps without defined type (killed without ever mouseovering)
  KILLLOG_LIST_UNKNOWNTYPE = "Inconnu";
  KILLLOG_LIST_NORMALTYPE = "Normal";

  -- these are used both for the Sort labels and for the labels in the detail
  KILLLOG_LABEL_RECENT = "Récent";
  KILLLOG_LABEL_TYPE = "Type";
  KILLLOG_LABEL_FAMILY = "Famille";
  KILLLOG_LABEL_CLASS = "Classe";
  KILLLOG_LABEL_NAME = "Nom";
  KILLLOG_LABEL_LEVEL = "Niveau";
  KILLLOG_LABEL_LOCATION = "Endroit";
  KILLLOG_LABEL_KILL = "Kill";
  KILLLOG_LABEL_DEATH = "Mort";
  KILLLOG_LABEL_XP = "XP";
  KILLLOG_LABEL_RESTED = "En forme";
  KILLLOG_LABEL_GROUP = "Groupe";
  KILLLOG_LABEL_RAID = "Raid";

  -- these are for changing the creep type
  KILLLOG_LABEL_CHANGE_FAMILY = "Changer Famille Creep";
  KILLLOG_STATIC_CHANGE_FAMILY_BLURB = "Entrez le nouveau type de famille pour ce Creep";
  KILLLOG_LABEL_CHANGE_TYPE = "Changer Type Creep";
  KILLLOG_STATIC_CHANGE_TYPE_BLURB = "Entrez le nouveau type pour ce Creep";
  KILLLOG_LABEL_DELETE = "Supprimer Entrée Creep";
  KILLLOG_STATIC_DELETE_BLURB = "Etes-vous certain de vouloir supprimer cette entrée ?";


  -- formatting for updating tooltip
  KILLLOG_TOOLTIP_KILL_COUNT = "Kill %d, XP Moy. %d";
  KILLLOG_TOOLTIP_DEATH_COUNT = "Mort %d";

  KILLLOG_NEW_MAX = "Nouveau Dégat Maximum : %s %s pour %s !";

  KILLLOG_MAXHIT_TITLE = "Dégats Maximum";
  KILLLOG_EXPERIENCE_TITLE = "Résumé Experience";
  KILLLOG_CREEP_TITLE = "Résumé Creep";
  KILLLOG_LABEL_QUEST = "Quête";
  KILLLOG_LABEL_EXPLORATION = "Exploration";
  KILLLOG_LABEL_CREEP_XP = "Creep";
  KILLLOG_NOT_AVAILABLE = "Non disponible";

  KILLLOG_DEATH_TITLE = "Historique Mort";
  KILLLOG_DEATH_FORMAT = "%s contre %s (au niveau %d)\n\n";


  -- binding texts
  BINDING_HEADER_KILLLOG = "Kill Log";
  BINDING_NAME_KILLLOG_TOGGLE = "Afficher/Masquer la fenêtre Kill Log";
  BINDING_NAME_KILLLOG_GENERAL = "Ouvrir les informations générales";
  BINDING_NAME_KILLLOG_LIST = "Ouvrir la liste des Creep";
  BINDING_NAME_KILLLOG_DEATH = "Ouvrir la liste de vos morts";
  BINDING_NAME_KILLLOG_OPTIONS = "Ouvrir les options de configuration";

  -- used for button in Cosmos menu
  KILLLOG_BUTTON_TEXT = BINDING_HEADER_KILLLOG;
  KILLLOG_BUTTON_SUBTEXT = "Compteur et XP";
  KILLLOG_BUTTON_TIP = "Un journal de vos exploits en Azeroth";

  -- used to fill creep family
  --   this is FAR from complete
  -- KILLLOG_CREEP_FAMILIES = {
  -- };

  -- strings for the opions tab
  --  these are placeholders and not very descriptive yet...
  KILLLOG_OPTION_STORE_MAX = "Tracer dégats";
  KILLLOG_OPTION_TOOLTIP_STORE_MAX = "Trace les dégats maximum.";
  KILLLOG_OPTION_NOTIFY_MAX = "Notifier maximum";
  KILLLOG_OPTION_TOOLTIP_NOTIFY_MAX = "Affiche la notification des nouveaux dégats maximum.";
  KILLLOG_OPTION_STORE_CREEP = "Stocker infos creep";
  KILLLOG_OPTION_TOOLTIP_STORE_CREEP = "Stocke les informations creep.";
  KILLLOG_OPTION_SESSION = "Tracer infos session";
  KILLLOG_OPTION_TOOLTIP_SESSION = "Trace les informations de la session.";

  KILLLOG_OPTION_TOOLTIP = "Stats creep";
  KILLLOG_OPTION_TOOLTIP_TOOLTIP = "Quand vous passez la souris sur les creeps, affiche le compteur de kill et de mort.";
  KILLLOG_OPTION_STORE_DEATH = "Tracer morts";
  KILLLOG_OPTION_TOOLTIP_STORE_DEATH = "Trace vos morts.";
  KILLLOG_OPTION_STORE_OVERALL = "Tracer infos globales";
  KILLLOG_OPTION_TOOLTIP_STORE_OVERALL = "Trace les informations globales.";
  KILLLOG_OPTION_TRIVIAL = "Lister trivial creeps";
  KILLLOG_OPTION_TOOLTIP_TRIVIAL = "Inclure les trivial creeps dans les listes.";

  KILLLOG_OPTION_STORE_LEVEL = "Tracer par niveau";
  KILLLOG_OPTION_TOOLTIP_STORE_LEVEL = "Trace les informations par niveau.";
  KILLLOG_OPTION_SLIDER_STORE_LEVEL = "Niveau";
  KILLLOG_OPTION_SLIDER_TOOLTIP_STORE_LEVEL = "Nombre de niveaux à tracer.";

  KILLLOG_OPTION_PORTRAIT = "Activer portraits";
  KILLLOG_OPTION_TOOLTIP_PORTRAIT = "Active les portraits.";
  KILLLOG_OPTION_SLIDER_PORTRAIT = "Portrait";
  KILLLOG_OPTION_SLIDER_TOOLTIP_PORTRAIT = "Nombre de portraits à utiliser.";

  KILLLOG_CLEAR = "Effacer";
  KILLLOG_CLEAR_CONFIRMATION = "Etes-vous sûr ? Ceci effaçera TOUTES les informations qui ont été récoltées pour TOUS vos personnages.";
end

--[[
VSENVIRONMENTALDAMAGE_DROWNING_SELF = "You are drowning and lose %d health.";
VSENVIRONMENTALDAMAGE_FALLING_SELF = "You fall and lose %d health.";
VSENVIRONMENTALDAMAGE_FATIGUE_SELF = "You are exhausted and lose %d health.";
VSENVIRONMENTALDAMAGE_FIRE_SELF = "You suffer %d points of fire damage.";
VSENVIRONMENTALDAMAGE_LAVA_SELF = "You lose %d health for swimming in lava.";
VSENVIRONMENTALDAMAGE_SLIME_SELF = "You lose %d health for swimming in slime.";

ERR_QUEST_REWARD_EXP_I = "Experience gained: %d."; -- %d is amount of xp gain
ERR_ZONE_EXPLORED_XP = "Discovered %s: %d experience gained";

]]

