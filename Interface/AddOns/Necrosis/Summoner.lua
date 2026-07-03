--=================================================================================================
-- SUMMONER
--=================================================================================================

function Necrosis_Summoner()
	if (UnitExists("target") and not UnitIsDeadOrGhost("target") and UnitIsConnected("target")  ) then
		if CheckInteractDistance("target", 4) then
			Necrosis_Msg(NECROSIS_SUMMONALERT,"USER");
		end
		if NECROSIS_SPELL_TABLE[37].ID then
			CastSpell(NECROSIS_SPELL_TABLE[37].ID, "spell");
		end
	end
end

function Necrosis_Summoner_SummonPerson()
	local button = getglobal(this:GetName());
	TargetUnit(button.value);
	Necrosis_Summoner();
end
		

--=================================================================================================
-- SUMMONER -> DROP DOWN MENU
--=================================================================================================

function Necrosis_SummonerButton_OnClick()
	if (arg1 == "RightButton") then
		ToggleDropDownMenu(1, nil, NecrosisSummonerDropDown, "NecrosisSummonerButton", 0, 0);
	elseif (arg1 == "LeftButton") then
		Necrosis_Summoner();
	end
end

function Necrosis_SummonerDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Necrosis_SummonerDropDown_Initialize, "MENU");
end

function Necrosis_SummonerDropDown_Initialize()
	if (GetNumRaidMembers() > 0 ) then
		local outzone = {text = {}, value = {},};
		local yard28 = {text = {}, value = {},};
		local info = nil;
		local localZone = nil;
		local raidMembers = GetNumRaidMembers();
		local raidMemberCounter = 0;		
		for index=1, raidMembers do
			local name, _, _, _, _, _, zone, _ = GetRaidRosterInfo(index);
			if (name == UnitName("player")) then
				localZone = zone;
				break;
			end
		end		
		for index=1, raidMembers do
			if (raidMemberCounter > 25) then
				break;
			else
				local name, _, subgroup, _, _, _, zone, _ = GetRaidRosterInfo(index);
				--if (zone ~= nil and zone ~= "Offline" and zone ~= localZone and name ~= UnitName("player")) then	
				if (zone ~= nil and name ~= UnitName("player")) then	
				local infotext = nil;
					if zone == NECROSIS_PLAYER_OFFLINE or UnitIsDeadOrGhost( "raid"..index)then
						infotext ="|cFF808080["..subgroup.."] ".. name.." ["..zone.."]|r";
					else
						infotext ="|cFF0099FF["..subgroup.."]|r ".. name.." |cFF0099FF["..zone.."]|r";
					end
				if (zone ~= localZone) then	
					table.insert(
							outzone,
							{text = infotext,
							value = "raid"..index,
							}
						    );
					 raidMemberCounter = raidMemberCounter + 1;
				end
					
				if (zone ~= nil  and zone == localZone  and not CheckInteractDistance("raid"..index, 4)) then		
					table.insert(
							yard28,
							{text = infotext,
							value = "raid"..index,
							}
						    );
				end
				end
			end
		end
		for index=1, table.getn(outzone) do
				info = {};
				info.text = outzone[index].text;
				info.value = outzone[index].value;
				info.func = Necrosis_Summoner_SummonPerson;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info);			
		end
		raidMemberCounter = table.getn(outzone);
		if( raidMemberCounter <5 ) then
				info = {};
				info.text = "------------";
				info.value = nil;
				info.func = nil;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info);	
			for index=1, table.getn(yard28) do
				if raidMemberCounter > 25 then
					break;
				else
				info = {};
				info.text = yard28[index].text;
				info.value = yard28[index].value;
				info.func = Necrosis_Summoner_SummonPerson;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info);	
				 raidMemberCounter = raidMemberCounter + 1;
				end
			end
		end

	elseif (GetNumPartyMembers() > 0) then
		local name = nil;
		for index = 1,4 do
			if (GetPartyMember(index)) then
				name = "party"..index;
				if (UnitName(name) ~= UnitName("player")) then
					info = {};
					info.text = UnitName(name);
					info.value = name;
					info.func = Necrosis_Summoner_SummonPerson;
					info.notCheckable = 1;
					UIDropDownMenu_AddButton(info);
				end
			end
		end
	end
end