HUNTERBAR_NO_FOOD_TRANSPARENCY = 0.3;

FeedPetButton_Food = nil;
local Enabled = true;
local RealmName = "";
local PlayerName = "";
local ButtonSizeSmall = 0.6;
local PetInCombat = false;

local function ChatWriteColor(msg, red, green, blue)
	return ZubanLib.IO.Chat.Write(msg, red, green, blue);	
end
local function ChatWrite(msg)
	return ZubanLib.IO.Chat.Write(msg);
end

local function ScreenWrite(msg)
	return ZubanLib.IO.Screen.Write(msg);
end

local function ChatWarn(msg)
	return ZubanLib.IO.Chat.Warn(msg);
end

local function ScreenWarn(msg)
	return ZubanLib.IO.Screen.Warn(msg);
end

local function ToString(value)
	return ZubanLib.ToString(value);
end

function FeedButton_OnLoad()
	-- register events
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterForDrag("LeftButton");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("UNIT_HAPPINESS");
	this:RegisterEvent("UNIT_PET");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PET_ATTACK_START");
	this:RegisterEvent("PET_ATTACK_STOP");
	
	-- setup slash command
	SLASH_FEEDPETBUTTON1 = "/feedpetbutton";
	SLASH_FEEDPETBUTTON2 = "/fpb";
	SlashCmdList["FEEDPETBUTTON"] = function(command)
		FeedButton_HandleSlashCommand(command);
	end
	-- if ( EarthFeature_AddButton ) then
        	-- EarthFeature_AddButton (
			-- { 
				-- id = "feedbutton";
				-- name = HUNTERBAR_EARTH_NAME;
				-- subtext = HUNTERBAR_EARTH_SUBTEXT;
				-- tooltip = HUNTERBAR_EARTH_TOOLTIP;
				-- icon = "Interface\\Icons\\Ability_Creature_Disease_01";
				-- callback = FeedButton_Show;
			-- }
			-- );
	-- end
	--ChatWrite("HunterBar - Feed Pet Button AddOn Loaded. Type /feedpetbutton for usage.");
	--ScreenWrite("HunterBar - Feed Pet Button AddOn Loaded.");
end

function FeedButton_HandleSlashCommand(command)
	if (command == "lock") then
		FeedButton_Lock();
	elseif (command == "unlock") then
		FeedButton_Unlock();
	elseif (command == "small") then
		FeedButton_SetSizeSmall();
	elseif (command == "large") then
		FeedButton_SetSizeLarge();
	elseif (command == "debug") then
		FeedButton_Debug();
	elseif (command == "reset") then
		FeedButton_Reset();
	elseif (command == "togglesize") then
		FeedButton_ToggleSize();
	elseif (command == "togglelock") then
		FeedButton_ToggleLock();
	elseif (command == "autofeed"
		or command == "af") then
		FeedButton_ToggleAutoFeed();
	elseif (command == "autofeedlevel"
		or command == "afl") then
		FeedButton_ToggleAutoFeedLevel();
	elseif (command == "disable") then
		FeedButton_Disable();
	elseif (command == "show") then
		FeedButton_Show();
	elseif (command == "status") then
		FeedButton_ShowStatus();
	else
		ChatWrite(HUNTERBAR_TEXT1);
	end
end

function FeedButton_Disable()
	FeedButtonMover:Hide();
	FeedButton:Hide();
	FeedButtonFrame:Hide();
	
	ChatWrite(HUNTERBAR_TEXT2);
end

function FeedButton_Show()
	if (FeedPetButton_Food ~=nil) then
		if (not FeedPetButton_Food.Locked) then
			FeedButtonMover:Show();	
		end
	end
	FeedButton:Show();
	FeedButtonFrame:Show();
	FeedButton_Refresh();	

	ChatWrite(HUNTERBAR_TEXT3);
end

function FeedButton_Reset()
	if (UnitClass("player") == HUNTERBAR_CLASSNAME) then
		FeedButtonFrame:ClearAllPoints();
		FeedButtonFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
		FeedButton_Unlock();
		FeedButton_SetSizeLarge();
		if (FeedPetButton_Food ~=nil) then
			if (FeedPetButton_Food.AutoFeed) then
				FeedButton_ToggleAutoFeed();
			end
			if (FeedPetButton_Food.AFLevel ==3) then
				FeedButton_ToggleAutoFeedLevel();
			end
		end
		FeedButtonFrame:Show();
	else
		FeedButtonFrame:Hide();		
	end
	ChatWrite(HUNTERBAR_TEXT4);
end

function FeedButton_SetSizeSmall()
	if (FeedPetButton_Food ~= nil) then
		FeedButton:SetScale(UIParent:GetEffectiveScale() * ButtonSizeSmall);
		FeedPetButton_Food.Size = "small";
	end
end

function FeedButton_SetSizeLarge()
	if (FeedPetButton_Food ~= nil) then
		FeedButton:SetScale(UIParent:GetEffectiveScale());
		FeedPetButton_Food.Size = "large";
	end
end

function FeedButton_ToggleSize()
	if (FeedPetButton_Food ~= nil) then
		if (FeedPetButton_Food.Size == "large") then
			FeedButton_SetSizeSmall();
		else
			FeedButton_SetSizeLarge();
		end
	end
end

function FeedButton_Lock()
	if (FeedPetButton_Food ~= nil) then
		FeedPetButton_Food.Locked = true;
		FeedButtonMover:Hide();
	end
	
	ChatWrite(HUNTERBAR_TEXT5);
end

function FeedButton_Unlock()
	if (FeedPetButton_Food ~= nil) then
		FeedPetButton_Food.Locked = false;
		FeedButtonMover:Show();
	end
	
	ChatWrite(HUNTERBAR_TEXT6);
end

function FeedButton_ToggleLock()
	if (FeedPetButton_Food ~= nil) then
		if (FeedPetButton_Food.Locked) then
			FeedButton_Unlock();
		else
			FeedButton_Lock();
		end
	end
end

function FeedButton_ToggleAutoFeed()
	if (FeedPetButton_Food ~= nil) then
		if (FeedPetButton_Food.AutoFeed) then
			FeedPetButton_Food.AutoFeed = false;
			ChatWrite(HUNTERBAR_TEXT7);
		else
			FeedPetButton_Food.AutoFeed = true;
			ChatWrite(HUNTERBAR_TEXT8);
		end
	end
end

function FeedButton_ToggleAutoFeedLevel()
	if (FeedPetButton_Food ~=nil) then
		if (FeedPetButton_Food.AFLevel == 2) then
			FeedPetButton_Food.AFLevel = 3;
			ChatWrite(HUNTERBAR_TEXT9..HUNTERBAR_HAPPY); 
		else
			FeedPetButton_Food.AFLevel = 2;
			ChatWrite(HUNTERBAR_TEXT9..HUNTERBAR_CONTENT);
		end
	end	
end

function FeedButton_ShowStatus()
	ChatWriteColor(HUNTERBAR_TEXT10,0.2,1,0.2);

	if (FeedPetButton_Food) then
		ChatWrite(HUNTERBAR_TEXT11..ToString(FeedPetButton_Food.Name));
		ChatWrite(HUNTERBAR_TEXT12..ToString(FeedPetButton_Food.Count));
		if ( FeedPetButton_Food.AutoFeed) then
			ChatWrite(HUNTERBAR_TEXT13);
		else
			ChatWrite(HUNTERBAR_TEXT14);
		end
		if (FeedPetButton_Food.AFLevel ==2 ) then
			ChatWrite(HUNTERBAR_TEXT9..HUNTERBAR_CONTENT);
		else
			ChatWrite(HUNTERBAR_TEXT9..HUNTERBAR_HAPPY); 
		end
		ChatWrite(HUNTERBAR_TEXT15..ToString(FeedPetButton_Food.Size));
		ChatWrite(HUNTERBAR_TEXT16..ToString(FeedPetButton_Food.Locked));		
	end

end
function FeedButton_Debug()
	ChatWrite("Enabled="..ToString(Enabled));
	ChatWrite("RealmName="..ToString(RealmName));
	ChatWrite("PlayerName="..ToString(PlayerName));
	ChatWrite("PetName="..ToString(UnitName("pet")));
	ChatWrite("PetInCombat="..ToString(PetInCombat));
	if (FeedPetButton_Food) then
		ChatWrite("Name="..ToString(FeedPetButton_Food.Name));
		ChatWrite("Texture="..ToString(FeedPetButton_Food.Texture));
		ChatWrite("Count="..ToString(FeedPetButton_Food.Count));
		ChatWrite("Size="..ToString(FeedPetButton_Food.Size));
		ChatWrite("Locked="..ToString(FeedPetButton_Food.Locked));
		ChatWrite("AFLevel="..ToString(FeedPetButton_Food.AFLevel));
	end
	FeedButton_ShowAllBuff();
	
end

function FeedButton_OnEnter()
	-- display tooltip
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");

	if (FeedPetButton_Food ~= nil and FeedPetButton_Food.Name) then
		if (Enabled) then
			GameTooltip:SetText(HUNTERBAR_FEED_BUTTON_TITLE);
		else
			GameTooltip:SetText(HUNTERBAR_SHIFT_FEED_BUTTON_TITLE);
		end
				
		GameTooltip:AddLine(HUNTERBAR_TEXT11..FeedPetButton_Food.Name, "", 1, 1, 1);
		GameTooltip:AddLine(HUNTERBAR_TEXT12..FeedPetButton_Food.Count, "", 1, 1, 1);
	else
		GameTooltip:AddLine(HUNTERBAR_NO_FOOD_MSG, "", 1, 1, 1);
	end

	GameTooltip:Show();
end

function FeedButtonMover_OnEnter()
	-- display tooltip
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(HUNTERBAR_MSG_DRAG);
	GameTooltip:AddLine(HUNTERBAR_MSG_RESIZE, "", 1, 1, 1);
	GameTooltip:AddLine(HUNTERBAR_MSG_LOCK, "", 1, 1, 1);
	GameTooltip:Show();
end

function FeedButton_OnLeave()
	-- hide tooltip
	GameTooltip:Hide();
end

function FeedButton_OnClick(button, isDoubleClick)
	if (FeedButton_PlaceFood()) then
		ZubanLib.Cursor:Clear();
		return;
	end

	if (isDoubleClick == nil) then
		isDoubleClick = false;
	end
	
	if (IsShiftKeyDown()) then
		-- clear the button on shift-click
		if (button == "LeftButton") then
			FeedButton_Clear();
		else
			FeedButton_ToggleLock();
		end
	elseif (FeedPetButton_Food.Name) then
		-- execute the feed button
		FeedButton_ExecuteFeedPet(isDoubleClick);
	else
		ChatWrite(HUNTERBAR_NO_FOOD_MSG2);
	end
	
	FeedButton_UpdateCount(this);
end

function FeedButton_OnEvent(event)
	if ((event=="PLAYER_ENTERING_WORLD" or (event == "UNIT_NAME_UPDATE" and arg1 == "player")) and UnitName("player") ~= UNKNOWNOBJECT) then
		-- unregistering causes a bug?
		--this:UnregisterEvent("UNIT_NAME_UPDATE");

		if (UnitClass("player") == HUNTERBAR_CLASSNAME) then
			RealmName = GetCVar("RealmName"); 
			PlayerName = UnitName("player");
	
			if (FeedPetButton_Config == nil) then
				FeedPetButton_Config = {};
			end
			
			if (FeedPetButton_Config[RealmName] == nil) then
				FeedPetButton_Config[RealmName] = {}
			end
	
			if (FeedPetButton_Config[RealmName][PlayerName] == nil) then
				FeedPetButton_Config[RealmName][PlayerName] = {}
			end
	
			FeedPetButton_Food = FeedPetButton_Config[RealmName][PlayerName];
			
			if (FeedPetButton_Food.Texture) then
				SetItemButtonTexture(this, FeedPetButton_Food.Texture);
			end
			
			if (FeedPetButton_Food.Size == "small") then
				FeedButton_SetSizeSmall();
			else
				FeedButton_SetSizeLarge();
			end

			if (FeedPetButton_Food.Locked) then
				FeedButtonMover:Hide();
			else
				FeedButtonMover:Show();
			end
			if (UnitExists("pet")) then
				FeedButtonFrame:Show();
				FeedButton:Show();
				FeedButton_Refresh();
			else
				FeedButton:Show();
				FeedButtonFrame:Hide();
			end
			if (FeedPetButton_Food.AutoFeed == nil) then				
				FeedButton_ToggleAutoFeed();
			end
			if (FeedPetButton_Food.AFLevel == nil) then				
				FeedButton_ToggleAutoFeedLevel();		
			end

			FeedButton_UpdateCount(this);
		else
			this:UnregisterEvent("BAG_UPDATE");
			this:UnregisterEvent("UNIT_HAPPINESS");
			this:UnregisterEvent("UNIT_PET");
		end
		return;
	end
	if ( event == "PET_ATTACK_START" ) 
	then
		PetInCombat = true;
	end
	if ( event == "PET_ATTACK_STOP" ) 
	then
		PetInCombat = false;
	end
	if (event == "BAG_UPDATE") then
		if (FeedPetButton_Food ~= nil and FeedPetButton_Food.Name ~= nil) then
			-- determine the count of the selected food
			
			FeedButton_UpdateCount(this);
		end
		return;
	end
	if (event == "UNIT_HAPPINESS" and arg1 == "pet" and UnitClass("player") == HUNTERBAR_CLASSNAME) then
		
		FeedButton_Refresh();
		
		-- correct the button scaling in case it was changed by an alt-tab
		if (FeedPetButton_Food ~= nil and FeedPetButton_Food.Size == "small") then
			FeedButton_SetSizeSmall();
		else
			FeedButton_SetSizeLarge();
		end

		return;
	end
	if (event == "UNIT_PET" and UnitClass("player") == HUNTERBAR_CLASSNAME) then
		if (UnitExists("pet")) then
			FeedButtonFrame:Show();
			FeedButton_Refresh();
		else
			FeedButtonFrame:Hide();
		end
		return;
	end
end

function FeedButton_OnReceiveDrag()
	FeedButton_PlaceFood();
end

function FeedButton_PlaceFood()
	if (CursorHasItem()
		and ZubanLib.Cursor ~= nil
		and ZubanLib.Cursor.Attributes ~= nil
		and ZubanLib.Cursor.Attributes.Location == "Container"
		and ZubanLib.Cursor.Attributes.Name ~= nil
		and ZubanLib.Cursor.Attributes.Texture ~= nil
		and ZubanLib.Cursor.Attributes.Bag ~= nil
		and ZubanLib.Cursor.Attributes.Slot ~= nil) then
		-- drop the cursor item onto the feed button
			
		FeedPetButton_Food.Name = ZubanLib.Cursor.Attributes.Name;
		FeedPetButton_Food.Texture = ZubanLib.Cursor.Attributes.Texture;
		SetItemButtonTexture(this, ZubanLib.Cursor.Attributes.Texture);
		
		GameTooltip:Hide();
		PickupContainerItem(ZubanLib.Cursor.Attributes.Bag, ZubanLib.Cursor.Attributes.Slot);
		
		ZubanLib.Cursor:Clear();
		
		FeedButton_UpdateCount(this);
		FeedButton_Refresh();	
		
		return true;
	end
	
	return false;
end

function FeedButton_Clear()
	-- remove the selected food

	FeedPetButton_Food.Name = nil;
	FeedPetButton_Food.Texture = nil;
	FeedPetButton_Food.Count = nil;
	
	SetItemButtonCount(this, 0);
	SetItemButtonTexture(this, nil);
	getglobal(this:GetName().."CountWarn"):Hide();
	GameTooltip:Hide();
	ZubanLib.Cursor:Clear();
	
	FeedButton_Refresh();
end

function FeedButton_ExecuteKeyPress(override)
	if (FeedPetButton_Food.Name) then
		-- execute the feed button
	
		FeedButton_ExecuteFeedPet(override);
	else
		ChatWrite(HUNTERBAR_NO_FOOD_MSG2);
	end
end

function FeedButton_ExecuteFeedPet(override)
	if (override == nil) then
		override = false;
	end

	if (Enabled or override) then
		local bag, slot = ZubanLib.Container.FindBagSlotByName(FeedPetButton_Food.Name);
   		
		if (bag and slot) then
			PickupContainerItem(bag, slot);
			-- do not record this pickup
			ZubanLib.Cursor:Clear();
			
			if (CursorHasItem()) then
				DropItemOnUnit("pet");
			else
				ChatWarn(HUNTERBAR_TEXT17);
				ScreenWarn(HUNTERBAR_TEXT18);
			end

			-- hack: if the food fails to drop on the pet and remains on the
			-- cursor, then drop it back into the container 
			if (CursorHasItem()) then
				PickupContainerItem(bag, slot);
				-- do not record this pickup
				ZubanLib.Cursor:Clear();
			else				
				ChatWrite(HUNTERBAR_MSG_FEEDING_PET.." "..UnitName("pet").." : "..FeedPetButton_Food.Name..".");
			end
		else
			ChatWarn(HUNTERBAR_MSG_FOOD_NOT_FOUND);
			ScreenWarn(HUNTERBAR_MSG_FOOD_NOT_FOUND);
		end
	end
end

function FeedButton_UpdateCount(button)
	if (FeedPetButton_Food ~= nil and FeedPetButton_Food.Name) then
		FeedPetButton_Food.Count = ZubanLib.Container.CountByName(FeedPetButton_Food.Name);
		SetItemButtonCount(button, FeedPetButton_Food.Count);
		
		if (FeedPetButton_Food.Count < 3) then
			getglobal(button:GetName().."CountWarn"):SetText(FeedPetButton_Food.Count);
			getglobal(button:GetName().."CountWarn"):Show();
		else
			getglobal(button:GetName().."CountWarn"):Hide();
		end
	end
end

function FeedButton_Refresh()
	local happiness = GetPetHappiness();
	local petHealth = UnitHealth("pet");
			
	if (happiness ~= nil
	    and happiness < 3
	    and not ZubanLib.InCombat()
	    and not PetInCombat
	    and not FeedButton_InSomeBuff()
	    and petHealth ~= nil
	    and petHealth > 0) then
		FeedButton:SetAlpha(1);
		Enabled = true;
		if(FeedPetButton_Food ~= nil) then
			if(happiness < FeedPetButton_Food.AFLevel
			    and FeedPetButton_Food.AutoFeed) then
			
				if (FeedPetButton_Food.Name) then
					-- execute the feed button
	
					FeedButton_ExecuteFeedPet(false);
				else
					ChatWrite(HUNTERBAR_NO_FOOD_MSG2);
				end
			end
		end
	else
		if (FeedPetButton_Food ~= nil and FeedPetButton_Food.Name) then
			FeedButton:SetAlpha(HUNTERBAR_NO_FOOD_TRANSPARENCY);
		else
			FeedButton:SetAlpha(1);
		end
		Enabled = false;
	end
end

function FeedButton_InSomeBuff()
	local i = 1;
	local buff;
	buff = UnitBuff("player", i);
	while buff do
		if(string.find(buff, "Ability_Ambush")
		   or string.find(buff, "Rogue_FeignDeath"))then
			
			return true;
		end
		i = i + 1;
		buff = UnitBuff("player", i);
	end

	i=1;
	buff=UnitBuff("pet",i);
	while buff do
		if(string.find(buff,"Ability_Hunter_BeastTraining")
		   or string.find(buff,"Spell_Holy_Heal")
		   or string.find(buff,"Ability_Hunter_MendPet"))then
	
			return true;
		end
		i=i+1;
		buff=UnitBuff("pet",i);
	end

	return false;
end

function FeedButton_ShowAllBuff()
	ChatWriteColor(HUNTERBAR_TEXT19,1,1,0.2);
	FeedButton_ShowBuff("player");
	ChatWriteColor(HUNTERBAR_TEXT20,1,1,0.2);
	FeedButton_ShowBuff("pet");

	if (FeedButton_InSomeBuff()) then
		ChatWriteColor("-------",0.2,1,0.2);
		ChatWriteColor(HUNTERBAR_TEXT21,1,0.2,0.2);
	end
end

function FeedButton_ShowBuff(unit)
	local i = 1;
	local buff;
	buff = UnitBuff(unit, i);
	while buff do
		ChatWrite(buff);
		i = i + 1;
		buff = UnitBuff(unit, i);
	end
end

