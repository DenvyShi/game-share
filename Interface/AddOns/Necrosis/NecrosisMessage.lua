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
-- Version 30.04.2005-1
------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------
-- FONCTIONS D'AFFICHAGE (CONSOLE, CHAT, MESSAGE SYSTEME)
------------------------------------------------------------------------------------------------------

function Necrosis_Msg(msg, type)
	if (msg and type) then
		-- Si le type du message est "USER", le message s'affiche sur l'cran...
		if (type == "USER") then
			-- On colorise astucieusement notre message :D
			msg = Necrosis_MsgAddColor(msg);
			local Intro = "|CFFFF00FFNe|CFFFF50FFcr|CFFFF99FFos|CFFFFC4FFis|CFFFFFFFF: ";
			if NecrosisConfig.ChatType then
				-- ...... sur la premire fentre de chat
				ChatFrame1:AddMessage(Intro..msg, 1.0, 0.7, 1.0, 1.0, UIERRORS_HOLD_TIME);
			else
				-- ...... ou au milieu de l'cran
				UIErrorsFrame:AddMessage(Intro..msg, 1.0, 0.7, 1.0, 1.0, UIERRORS_HOLD_TIME);
			end
		-- Si le type du message est "WORLD", le message sera envoy en raid,  dfaut en groupe, et  dfaut en chat local
		elseif (type == "WORLD") then
			if( NecrosisConfig.ChannelName ~= nil) then
				if(NecrosisConfig.ChannelName== 1)then
					SendChatMessage(msg, "SAY");
				elseif(NecrosisConfig.ChannelName== 2)then
					SendChatMessage(msg, "YELL");
				elseif(NecrosisConfig.ChannelName== 3) then
					if (GetNumPartyMembers() > 0) then
						SendChatMessage(msg, "PARTY");
					else
						SendChatMessage(msg, "SAY");
					end
				elseif(NecrosisConfig.ChannelName== 4)then
			if (GetNumRaidMembers() > 0) then
				SendChatMessage(msg, "RAID");
			elseif (GetNumPartyMembers() > 0) then
				SendChatMessage(msg, "PARTY");
					else
						SendChatMessage(msg, "SAY");
					end
				elseif(NecrosisConfig.ChannelName== 5)then
					SendChatMessage(msg, "GUILD");
				end
			else
					if (GetNumRaidMembers() > 0) then
						SendChatMessage(msg, "RAID");
					elseif (GetNumPartyMembers() > 0) then
						SendChatMessage(msg, "PARTY");
					else
				SendChatMessage(msg, "SAY");
					end
			end
		-- Si le type du message est "PARTY", le message sera envoy en groupe
		elseif (type == "PARTY") then
			SendChatMessage(msg, "PARTY");
		-- Si le type du message est "RAID", le message sera envoy en raid
		elseif (type == "RAID") then
			SendChatMessage(msg, "RAID");
		elseif (type == "SAY") then
		-- Si le type du message est "SAY", le message sera envoy en chat local
			SendChatMessage(msg, "SAY");
		end
	end
end


------------------------------------------------------------------------------------------------------
-- ... ET LE COLORAMA FUT !
------------------------------------------------------------------------------------------------------

-- Remplace dans les chaines les codes de coloration par les dfinitions de couleur associes
function Necrosis_MsgAddColor(msg)
	msg = string.gsub(msg, "<white>", "|CFFFFFFFF");
	msg = string.gsub(msg, "<lightBlue>", "|CFF99CCFF");
	msg = string.gsub(msg, "<brightGreen>", "|CFF00FF00");
	msg = string.gsub(msg, "<lightGreen2>", "|CFF66FF66");
	msg = string.gsub(msg, "<lightGreen1>", "|CFF99FF66");
	msg = string.gsub(msg, "<yellowGreen>", "|CFFCCFF66");
	msg = string.gsub(msg, "<lightYellow>", "|CFFFFFF66");
	msg = string.gsub(msg, "<darkYellow>", "|CFFFFCC00");
	msg = string.gsub(msg, "<lightOrange>", "|CFFFFCC66");
	msg = string.gsub(msg, "<dirtyOrange>", "|CFFFF9933");
	msg = string.gsub(msg, "<darkOrange>", "|CFFFF6600");
	msg = string.gsub(msg, "<redOrange>", "|CFFFF3300");
	msg = string.gsub(msg, "<red>", "|CFFFF0000");
	msg = string.gsub(msg, "<lightRed>", "|CFFFF5555");
	msg = string.gsub(msg, "<lightPurple1>", "|CFFFFC4FF");
	msg = string.gsub(msg, "<lightPurple2>", "|CFFFF99FF");
	msg = string.gsub(msg, "<purple>", "|CFFFF50FF");
	msg = string.gsub(msg, "<darkPurple1>", "|CFFFF00FF");
	msg = string.gsub(msg, "<darkPurple2>", "|CFFB700B7");
	msg = string.gsub(msg, "<close>", "|r");
	return msg;
end


-- Insre dans les timers des codes de coloration en fonction du pourcentage de temps restant
function NecrosisTimerColor(percent)
	local color = "<brightGreen>";
	if (percent < 10) then
		color = "<red>";
	elseif (percent < 20) then
		color = "<redOrange>";
	elseif (percent < 30) then
		color = "<darkOrange>";
	elseif (percent < 40) then
		color = "<dirtyOrange>";
	elseif (percent < 50) then
		color = "<darkYellow>";
	elseif (percent < 60) then
		color = "<lightYellow>";
	elseif (percent < 70) then
		color = "<yellowGreen>";
	elseif (percent < 80) then
		color = "<lightGreen1>";
	elseif (percent < 90) then
		color = "<lightGreen2>";
	end
	return color;
end

------------------------------------------------------------------------------------------------------
-- VARIABLES USER-FRIENDLY DANS LES MESSAGES D'INVOCATION
------------------------------------------------------------------------------------------------------

function Necrosis_MsgReplace(msg, target, pet)
	msg = string.gsub(msg, "<player>", UnitName("player"));
	if target then
		msg = string.gsub(msg, "<target>", target);
	end
	if pet then
		msg = string.gsub(msg, "<pet>", NecrosisConfig.PetName[pet]);
	end
	return msg;
end
