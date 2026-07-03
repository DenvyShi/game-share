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



------------------------------------------------------------------------------------------------------
-- FONCTION D'INITIALISATION
------------------------------------------------------------------------------------------------------

function Necrosis_Initialize()

	-- Initilialisation des Textes (VO / VF / VA)
	if NecrosisConfig ~= {} then
		if (NecrosisConfig.NecrosisLanguage == "zhCN") then
			Necrosis_Localization_Dialog_Cn();
		elseif (NecrosisConfig.NecrosisLanguage == "zhTW") then
			Necrosis_Localization_Dialog_Tw();
		elseif (NecrosisConfig.NecrosisLanguage == "enUS") or (NecrosisConfig.NecrosisLanguage == "enGB") then
			Necrosis_Localization_Dialog_En();
		else
			Necrosis_Localization_Dialog_Cn();
		end
	elseif GetLocale() == "zhCN"  then
		Necrosis_Localization_Dialog_Cn();
	elseif GetLocale() == "zhTW"  then
		Necrosis_Localization_Dialog_Tw();
	elseif GetLocale() == "enUS" or GetLocale() == "enGB" then
		Necrosis_Localization_Dialog_En();
	else
		Necrosis_Localization_Dialog_Cn();
	end


	-- On initialise ! Si le joueur n'est pas Dmoniste, on cache Necrosis (chuuuut !)
	-- On indique aussi que Ncrosis est initialis maintenant
	if UnitClass("player") ~= NECROSIS_UNIT_WARLOCK then
		HideUIPanel(NecrosisShardMenu);
		HideUIPanel(NecrosisSpellTimerButton);
		HideUIPanel(NecrosisButton);
		HideUIPanel(NecrosisPetMenuButton);
		HideUIPanel(NecrosisBuffMenuButton);
		HideUIPanel(NecrosisCurseMenuButton);
		HideUIPanel(NecrosisMountButton);
		HideUIPanel(NecrosisSummonerButton);
		HideUIPanel(NecrosisFirestoneButton);
		HideUIPanel(NecrosisSpellstoneButton);
		HideUIPanel(NecrosisHealthstoneButton);
		HideUIPanel(NecrosisSoulstoneButton);
		HideUIPanel(NecrosisAntiFearButton);
		HideUIPanel(NecrosisShadowVulnerabilityButton);
	else
		-- On charge (ou on cre) la configuration pour le joueur et on l'affiche sur la console
		if NecrosisConfig == nil or NecrosisConfig.Version ~= Default_NecrosisConfig.Version then
			NecrosisConfig = {};
			NecrosisConfig = Default_NecrosisConfig;
			Necrosis_Msg(NECROSIS_MESSAGE.Interface.DefaultConfig, "USER");
			NecrosisButton:ClearAllPoints();
			NecrosisShadowTranceButton:ClearAllPoints();
			NecrosisAntiFearButton:ClearAllPoints();
			NecrosisShadowVulnerabilityButton:ClearAllPoints();
			NecrosisSpellTimerButton:ClearAllPoints();
			NecrosisButton:SetPoint("CENTER", "UIParent", "CENTER",0,-100);
			NecrosisShadowTranceButton:SetPoint("CENTER", "UIParent", "CENTER",100,-30);
			NecrosisAntiFearButton:SetPoint("CENTER", "UIParent", "CENTER",100,30);
			NecrosisShadowVulnerabilityButton:SetPoint("CENTER", "UIParent", "CENTER",100,60);
			NecrosisSpellTimerButton:SetPoint("CENTER", "UIParent", "CENTER",120,340);

		else
			Necrosis_Msg(NECROSIS_MESSAGE.Interface.UserConfig, "USER");
		end
	
		-----------------------------------------------------------
		-- Excution des fonctions de dmarrage
		-----------------------------------------------------------

		-- Affichage d'un message sur la console
		Necrosis_Msg(NECROSIS_MESSAGE.Interface.Welcome, "USER");
		-- Cration de la liste des sorts disponibles
		Necrosis_SpellSetup();
		-- Cration de la liste des emplacements des fragments
		Necrosis_SoulshardSetup();
		-- Inventaire des pierres et des fragments possds par le Dmoniste
		Necrosis_BagExplore();
		-- Cration des menus de buff et d'invocation
		Necrosis_CreateMenu();

		-- Lecture de la configuration dans le SavedVariables.lua, criture dans les variables dfinies
        -- added by Sylvette
		if (NecrosisConfig.StoneTrade) then NecrosisStoneTrade_Button:SetChecked(1); end
		if (NecrosisConfig.SoulshardSort) then NecrosisSoulshardSort_Button:SetChecked(1); end
		if (NecrosisConfig.SoulshardDestroy) then NecrosisSoulshardDestroy_Button:SetChecked(1); end
		if (NecrosisConfig.ShadowTranceAlert) then NecrosisShadowTranceAlert_Button:SetChecked(1); end
		if (NecrosisConfig.ShowSpellTimers) then NecrosisShowSpellTimers_Button:SetChecked(1); end
		if (NecrosisConfig.AntiFearAlert) then NecrosisAntiFearAlert_Button:SetChecked(1); end
		if (NecrosisConfig.ShadowVulnerabilityAlert) then NecrosisShadowVulnerabilityAlert_Button:SetChecked(1); end
		if (NecrosisConfig.NecrosisLockServ) then NecrosisIconsLock_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[1]) then NecrosisShowFirestone_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[2]) then NecrosisShowSpellstone_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[3]) then NecrosisShowHealthStone_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[4]) then NecrosisShowSoulstone_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[5]) then NecrosisShowBuffMenu_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[6]) then NecrosisShowMount_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[7]) then NecrosisShowPetMenu_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[8]) then NecrosisShowCurseMenu_Button:SetChecked(1); end
		if (NecrosisConfig.StonePosition[9]) then NecrosisShowSummoner_Button:SetChecked(1); end
		if (NecrosisConfig.NecrosisToolTip) then NecrosisShowTooltips_Button:SetChecked(1); end
		if (NecrosisConfig.Sound) then NecrosisSound_Button:SetChecked(1); end
		if (NecrosisConfig.ShowCount) then NecrosisShowCount_Button:SetChecked(1); end
		if (NecrosisConfig.BuffMenuPos == -34) then NecrosisBuffMenu_Button:SetChecked(1); end
		if (NecrosisConfig.PetMenuPos == -34) then NecrosisPetMenu_Button:SetChecked(1); end
		if (NecrosisConfig.CurseMenuPos == -34) then NecrosisCurseMenu_Button:SetChecked(1); end
		if (NecrosisConfig.NoDragAll) then NecrosisLock_Button:SetChecked(1); end
		if (NecrosisConfig.SpellTimerPos == -1) then NecrosisSTimer_Button:SetChecked(1); end
		if (NecrosisConfig.ChatMsg) then NecrosisShowMessage_Button:SetChecked(1); end
		if (NecrosisConfig.DemonSummon) then NecrosisShowDemonSummon_Button:SetChecked(1); end
		if (NecrosisConfig.SteedSummon) then NecrosisShowSteedSummon_Button:SetChecked(1); end
		if not (NecrosisConfig.ChatType) then NecrosisChatType_Button:SetChecked(1); end
		if (NecrosisConfig.Graphical) then NecrosisGraphicalTimer_Button:SetChecked(1); end
		if not (NecrosisConfig.Yellow) then NecrosisTimerColor_Button:SetChecked(1); end
		if (NecrosisConfig.SensListe == -1) then NecrosisTimerDirection_Button:SetChecked(1); end
		if (NecrosisConfig.LastBuff ~= 0) then Necrosis_SelectBuffMenuTexture(); end
		if (NecrosisConfig.LastDemon ~= 0) then Necrosis_SelectPetMenuTexture(); end
		if (NecrosisConfig.LastCurse ~= 0) then Necrosis_SelectCurseMenuTexture(); end

		if (NecrosisConfig.CriticalDamageSound) then NecrosisCriticalDamageAlert_Button:SetChecked(1); end ----
		-- Paramtres des glissires		
		NecrosisButtonRotate_Slider:SetValue(NecrosisConfig.NecrosisAngle);
		NecrosisButtonRotate_SliderLow:SetText("0");
		NecrosisButtonRotate_SliderHigh:SetText("360");
		
		if NecrosisConfig.NecrosisLanguage == "zhTW" then
			NecrosisLanguage_Slider:SetValue(3);
		elseif NecrosisConfig.NecrosisLanguage == "zhCN" then
			NecrosisLanguage_Slider:SetValue(2);
		elseif NecrosisConfig.NecrosisLanguage == "enUS" then
			NecrosisLanguage_Slider:SetValue(1);
		else
			NecrosisLanguage_Slider:SetValue(2);
		end
		NecrosisLanguage_SliderText:SetText("Language/语言/語言");
		NecrosisLanguage_SliderLow:SetText("");
		NecrosisLanguage_SliderHigh:SetText("");
        
        -- Paramtres des event range  -- sylvette
        Necrosis_SetEventRange();
        NecrosisEventRange_Slider:SetValue(NecrosisConfig.EventRange);
		NecrosisEventRange_SliderText:SetText("Set Event Range");
		NecrosisEventRange_SliderLow:SetText("5");
		NecrosisEventRange_SliderHigh:SetText("200")

		NecrosisBag_Slider:SetValue(4 - NecrosisConfig.SoulshardContainer);
		NecrosisBag_SliderLow:SetText("5");
		NecrosisBag_SliderHigh:SetText("1");

		NecrosisCountType_Slider:SetValue(NecrosisConfig.CountType);
		NecrosisCountType_SliderLow:SetText("");
		NecrosisCountType_SliderHigh:SetText("");

		NecrosisCircle_Slider:SetValue(NecrosisConfig.Circle);
		NecrosisCircle_SliderLow:SetText("");
		NecrosisCircle_SliderHigh:SetText("");
		
		ShadowTranceScale_Slider:SetValue(NecrosisConfig.ShadowTranceScale);
		ShadowTranceScale_SliderLow:SetText("50%");
		ShadowTranceScale_SliderHigh:SetText("150%");

		if (NecrosisConfig.NecrosisColor == "Rose") then
			NecrosisColor_Slider:SetValue(1);
		elseif (NecrosisConfig.NecrosisColor == "Bleu") then
			NecrosisColor_Slider:SetValue(2);
		elseif (NecrosisConfig.NecrosisColor == "Orange") then
			NecrosisColor_Slider:SetValue(3);
		elseif (NecrosisConfig.NecrosisColor == "Turquoise") then
			NecrosisColor_Slider:SetValue(4);
		elseif (NecrosisConfig.NecrosisColor == "Violet") then
			NecrosisColor_Slider:SetValue(5);
		else
			NecrosisColor_Slider:SetValue(6);
		end
		NecrosisColor_SliderLow:SetText("");
		NecrosisColor_SliderHigh:SetText("");

		NecrosisButtonScale_Slider:SetValue(NecrosisConfig.NecrosisButtonScale);
		NecrosisButtonScale_SliderLow:SetText("50 %");
		NecrosisButtonScale_SliderHigh:SetText("150 %");

		NecrosisBanishScale_Slider:SetValue(NecrosisConfig.BanishScale);
		NecrosisBanishScale_SliderLow:SetText("100 %");
		NecrosisBanishScale_SliderHigh:SetText("200 %");

		-- On rgle la taille de la pierre et des boutons suivant les rglages du SavedVariables
		NecrosisButton:SetScale(NecrosisConfig.NecrosisButtonScale/100);
		NecrosisShadowTranceButton:SetScale(NecrosisConfig.ShadowTranceScale/100);
		NecrosisAntiFearButton:SetScale(NecrosisConfig.ShadowTranceScale/100);
		NecrosisShadowVulnerabilityButton:SetScale(NecrosisConfig.ShadowTranceScale/100);
		NecrosisBuffMenu8:SetScale(NecrosisConfig.BanishScale/100);

		-- On dfinit l'affichage des Timers  gauche ou  droite du bouton
		NecrosisListSpells:ClearAllPoints();
		NecrosisListSpells:SetJustifyH(NecrosisConfig.SpellTimerJust);
		NecrosisListSpells:SetPoint("TOP"..NecrosisConfig.SpellTimerJust, "NecrosisSpellTimerButton", "CENTER", NecrosisConfig.SpellTimerPos * 23, 5);	
		ShowUIPanel(NecrosisButton);
		
		-- On dfinit galement l'affichage des tooltips pour ces timers  gauche ou  droite du bouton
		if NecrosisConfig.SpellTimerJust == -23 then 
			AnchorSpellTimerTooltip = "ANCHOR_LEFT";
		else
			AnchorSpellTimerTooltip = "ANCHOR_RIGHT";
		end
		
		-- On vrifie que les fragments sont dans le sac dfini par le Dmoniste
		Necrosis_SoulshardSwitch("CHECK");

		-- Le Shard est-il vrouill sur l'interface ?
		if NecrosisConfig.NoDragAll then
			Necrosis_NoDrag();
			NecrosisButton:RegisterForDrag("");
			NecrosisSpellTimerButton:RegisterForDrag("");
		else
			Necrosis_Drag();
			NecrosisButton:RegisterForDrag("LeftButton");
			NecrosisSpellTimerButton:RegisterForDrag("LeftButton");
		end
		
		-- Les boutons sont-ils vrouills sur le Shard ?
		Necrosis_ButtonSetup();
		
		-- Si le dmoniste a une arme une main d'quipe, on lui quipe le premier objet li main gauche
		Necrosis_MoneyToggle();
		NecrosisTooltip:SetInventoryItem("player", 16);
		local itemName = tostring(NecrosisTooltipTextLeft2:GetText());
		if itemName == "Soulbound" then
			itemName = tostring(NecrosisTooltipTextLeft3:GetText());
		end
		Necrosis_MoneyToggle();
		if not GetInventoryItemLink("player", 17) and not string.find(itemName, NECROSIS_ITEM.Twohand) then
			Necrosis_SwitchOffHand(NECROSIS_ITEM.Offhand);
		end

		-- Initialisation des fichiers de langues -- Mise en place ventuelle du SMS
		Necrosis_LanguageInitialize();
		if NecrosisConfig.SM then
			NECROSIS_SOULSTONE_ALERT_MESSAGE = NECROSIS_SHORT_MESSAGES[1];
			NECROSIS_INVOCATION_MESSAGES = NECROSIS_SHORT_MESSAGES[2];
		end
	end
end

function Necrosis_LanguageInitialize()
	
	-- Localisation du speech.lua
	NecrosisLocalization();
		
	-- Localisation du XML
	NecrosisVersion:SetText(NecrosisData.Label);
	NecrosisShardsInventory_Section:SetText(NECROSIS_CONFIGURATION.ShardMenu);
	NecrosisShardsCount_Section:SetText(NECROSIS_CONFIGURATION.ShardMenu2);
	NecrosisSoulshardSort_Option:SetText(NECROSIS_CONFIGURATION.ShardMove);
	NecrosisSoulshardDestroy_Option:SetText(NECROSIS_CONFIGURATION.ShardDestroy);
    
    -- added by Sylvette
	NecrosisStoneTrade_Option:SetText(NECROSIS_CONFIGURATION.StoneTrade);
	
	NecrosisMessageSpell_Section:SetText(NECROSIS_CONFIGURATION.SpellMenu1);
	NecrosisMessagePlayer_Section:SetText(NECROSIS_CONFIGURATION.SpellMenu2);
	NecrosisShadowTranceAlert_Option:SetText(NECROSIS_CONFIGURATION.TranseWarning);
	NecrosisAntiFearAlert_Option:SetText(NECROSIS_CONFIGURATION.AntiFearWarning);
	NecrosisShadowVulnerabilityAlert_Option:SetText(NECROSIS_CONFIGURATION.ShadowVulnerabilityWarning);
		
	NecrosisShowTrance_Option:SetText(NECROSIS_CONFIGURATION.TranceButtonView);
	NecrosisIconsLock_Option:SetText(NECROSIS_CONFIGURATION.ButtonLock);
		
	NecrosisShowFirestone_Option:SetText(NECROSIS_CONFIGURATION.Show.Firestone);
	NecrosisShowSpellstone_Option:SetText(NECROSIS_CONFIGURATION.Show.Spellstone);
	NecrosisShowHealthStone_Option:SetText(NECROSIS_CONFIGURATION.Show.Healthstone);
	NecrosisShowSoulstone_Option:SetText(NECROSIS_CONFIGURATION.Show.Soulstone);
	NecrosisShowMount_Option:SetText(NECROSIS_CONFIGURATION.Show.Steed);
	NecrosisShowBuffMenu_Option:SetText(NECROSIS_CONFIGURATION.Show.Buff);
	NecrosisShowPetMenu_Option:SetText(NECROSIS_CONFIGURATION.Show.Demon);
	NecrosisShowCurseMenu_Option:SetText(NECROSIS_CONFIGURATION.Show.Curse);
	NecrosisShowSummoner_Option:SetText(NECROSIS_CONFIGURATION.Show.Summon);
	NecrosisShowTooltips_Option:SetText(NECROSIS_CONFIGURATION.Show.Tooltips);

	NecrosisShowSpellTimers_Option:SetText(NECROSIS_CONFIGURATION.SpellTime);
	NecrosisGraphicalTimer_Section:SetText(NECROSIS_CONFIGURATION.TimerMenu);
	NecrosisGraphicalTimer_Option:SetText(NECROSIS_CONFIGURATION.GraphicalTimer);
	NecrosisTimerColor_Option:SetText(NECROSIS_CONFIGURATION.TimerColor);
	NecrosisTimerDirection_Option:SetText(NECROSIS_CONFIGURATION.TimerDirection);
		
	NecrosisLock_Option:SetText(NECROSIS_CONFIGURATION.MainLock);
	NecrosisBuffMenu_Option:SetText(NECROSIS_CONFIGURATION.BuffMenu);
	NecrosisPetMenu_Option:SetText(NECROSIS_CONFIGURATION.PetMenu);
	NecrosisCurseMenu_Option:SetText(NECROSIS_CONFIGURATION.CurseMenu);
	NecrosisShowCount_Option:SetText(NECROSIS_CONFIGURATION.ShowCount);
	NecrosisSTimer_Option:SetText(NECROSIS_CONFIGURATION.STimerLeft);

	NecrosisSound_Option:SetText(NECROSIS_CONFIGURATION.Sound);
	NecrosisShowMessage_Option:SetText(NECROSIS_CONFIGURATION.ShowMessage);
	NecrosisShowSteedSummon_Option:SetText(NECROSIS_CONFIGURATION.ShowSteedSummon);
	NecrosisShowDemonSummon_Option:SetText(NECROSIS_CONFIGURATION.ShowDemonSummon);
	NecrosisChatType_Option:SetText(NECROSIS_CONFIGURATION.ChatType);
		
	NecrosisButtonRotate_SliderText:SetText(NECROSIS_CONFIGURATION.MainRotation);
	NecrosisCountType_SliderText:SetText(NECROSIS_CONFIGURATION.CountType);
	NecrosisCircle_SliderText:SetText(NECROSIS_CONFIGURATION.Circle);
	NecrosisBag_SliderText:SetText(NECROSIS_CONFIGURATION.BagSelect);
	NecrosisButtonScale_SliderText:SetText(NECROSIS_CONFIGURATION.NecrosisSize);
	NecrosisBanishScale_SliderText:SetText(NECROSIS_CONFIGURATION.BanishSize);
	ShadowTranceScale_SliderText:SetText(NECROSIS_CONFIGURATION.TranseSize);
	NecrosisColor_SliderText:SetText(NECROSIS_CONFIGURATION.Skin);
		
	NecrosisChannelDropDownTitle:SetText(NECROSIS_CONFIGURATION.Channel);--------
	NecrosisCriticalDamageAlert_Option:SetText(NECROSIS_CONFIGURATION.CriticalDamageWarning);--------
end



------------------------------------------------------------------------------------------------------
-- FONCTION GERANT LA COMMANDE CONSOLE /NECRO
------------------------------------------------------------------------------------------------------

function Necrosis_SlashHandler(arg1)
	-- Blah blah blah, le joueur est-il bien un Dmoniste ? On finira par le savoir !
	if UnitClass("player") ~= NECROSIS_UNIT_WARLOCK then
		return;
	end
	if string.find(string.lower(arg1), "recall") then
		NecrosisButton:ClearAllPoints();
		NecrosisButton:SetPoint("CENTER", "UIParent", "CENTER",0,0);
		NecrosisSpellTimerButton:ClearAllPoints();
		NecrosisSpellTimerButton:SetPoint("CENTER", "UIParent", "CENTER",0,0);
		NecrosisAntiFearButton:ClearAllPoints();
		NecrosisAntiFearButton:SetPoint("CENTER", "UIParent", "CENTER",20,0);
		NecrosisShadowVulnerabilityButton:ClearAllPoints();
		NecrosisShadowVulnerabilityButton:SetPoint("CENTER", "UIParent", "CENTER",20,0);
		NecrosisShadowTranceButton:ClearAllPoints();
		NecrosisShadowTranceButton:SetPoint("CENTER", "UIParent", "CENTER",-20,0);
	elseif string.find(string.lower(arg1), "sm") then
		if NECROSIS_SOULSTONE_ALERT_MESSAGE == NECROSIS_SHORT_MESSAGES[1] then
			NecrosisConfig.SM = false;
			NecrosisLocalization();
			Necrosis_Msg("Short Messages : <red>Off", "USER");
		else
			NecrosisConfig.SM = true;
			NECROSIS_SOULSTONE_ALERT_MESSAGE = NECROSIS_SHORT_MESSAGES[1];
			NECROSIS_INVOCATION_MESSAGES = NECROSIS_SHORT_MESSAGES[2];
			Necrosis_Msg("Short Messages : <brightGreen>On", "USER");
		end
	elseif string.find(string.lower(arg1), "cast") then
		NecrosisSpellCast(string.lower(arg1));
	else
		if NECROSIS_MESSAGE.Help ~= nil then
			for i = 1, table.getn(NECROSIS_MESSAGE.Help), 1 do
				Necrosis_Msg(NECROSIS_MESSAGE.Help[i], "USER");
			end
		end
		Necrosis_Toggle();
	end
end
