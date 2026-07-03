------------------------------------------------------------------------------------------------------
-- Necrosis LdC
--
-- Crateur initial (US) : Infernal (http://www.revolvus.com/games/interface/necrosis/)
-- Implmentation de base (FR) : Tilienna Thorondor
-- Reprise du projet : Lomig & Nyx des Larmes de Cenarius, Kael'Thas
-- 
-- Skins et voix Franaises : Eliah, Ner'zhul
-- Version Allemande par Arne Meier et Halisstra, Lothar
-- Remerciements spciaux pour Sadyre (JoL)
-- Version 28.06.2006-1
------------------------------------------------------------------------------------------------------



NecrosisData = {};
NecrosisData.Version = "1.5.4";
NecrosisData.Author = "LdC";
NecrosisData.AppName = "Necrosis";
NecrosisData.Label = NecrosisData.AppName.." "..NecrosisData.Version.." by "..NecrosisData.Author;


-- Raccourcis claviers
BINDING_HEADER_NECRO_BIND = "Necrosis";
   
BINDING_NAME_SOULSTONE = "Pierre d'\195\162me / Soulstone";
BINDING_NAME_HEALTHSTONE = "Pierre de soins / Healthstone";
BINDING_NAME_SPELLSTONE = "Pierre de sort / Spellstone";
BINDING_NAME_FIRESTONE = "Pierre de feu / Firestone";
BINDING_NAME_STEED = "Monture / Steed";
BINDING_NAME_WARD = "Gardien de l'ombre / Shadow Ward";
BINDING_NAME_SUMMON = "Ritual of Summoning";
BINDING_NAME_CURSE = "Cast Selected Curse";
BINDING_NAME_BANNISH = "Banish";
BINDING_NAME_ENSLAVE = "Enslave";
BINDING_NAME_HOT = "Howl of Terror";
BINDING_NAME_FEAR = "Fear";
BINDING_NAME_DRAINSOUL = "Drain Soul";
BINDING_NAME_SCALEDTAPLIFE = "Scaled Tap Life (Kimilly)";

if (GetLocale()=="zhCN") then
	BINDING_NAME_SOULSTONE = "制造使用灵魂石";
	BINDING_NAME_HEALTHSTONE = "制造使用治疗石";
	BINDING_NAME_SPELLSTONE = "制造使用法术石";
	BINDING_NAME_FIRESTONE = "制造使用火焰石";
	BINDING_NAME_STEED = "召唤战马";
	BINDING_NAME_WARD = "防护暗影结界";
	BINDING_NAME_SUMMON = "召唤仪式";
	BINDING_NAME_CURSE = "施放选择的诅咒";
	BINDING_NAME_BANNISH = "放逐术";
	BINDING_NAME_ENSLAVE = "奴役恶魔";
	BINDING_NAME_HOT = "恐惧嚎叫";
	BINDING_NAME_FEAR = "恐惧术";
	BINDING_NAME_DRAINSOUL = "绑定灵魂";
	BINDING_NAME_SCALEDTAPLIFE = "生命分流";
elseif (GetLocale()=="zhTW") then
	BINDING_NAME_SOULSTONE = "製造使用靈魂石";
	BINDING_NAME_HEALTHSTONE = "製造使用治療石";
	BINDING_NAME_SPELLSTONE = "製造使用法術石";
	BINDING_NAME_FIRESTONE = "製造使用火焰石";
	BINDING_NAME_STEED = "召喚戰馬";
	BINDING_NAME_WARD = "防護暗影結界";
	BINDING_NAME_SUMMON = "召喚儀式";
	BINDING_NAME_CURSE = "施放選擇的詛咒";
	BINDING_NAME_BANNISH = "放逐術";
	BINDING_NAME_ENSLAVE = "奴役惡魔";
	BINDING_NAME_HOT = "恐懼嚎叫";
	BINDING_NAME_FEAR = "恐懼術";
	BINDING_NAME_DRAINSOUL = "綁定靈魂";
	BINDING_NAME_SCALEDTAPLIFE = "生命分流";
end

-- sylvette - ported scaled life tap from Kimilly
SCALEDLIFETAP_LIFETAPSPELL = ""
SCALEDLIFETAP_LIFETAPTALENT = ""
SCALEDLIFETAP_RANKTEXT=""
SCALEDLIFETAP_RANKREGEXP=""