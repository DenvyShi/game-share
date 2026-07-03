--=================================================================================================
-- MOUNT
--=================================================================================================
local MountItems = nil;
function Necrosis_UseMount()
	local button = getglobal(this:GetName());
	UseContainerItem(MountItems.container[button.value], MountItems.slot[button.value]);
end

--=================================================================================================
-- MOUNT -> DROP DOWN MENU
--=================================================================================================

function Necrosis_MountButton_OnClick()
	if (arg1 == "RightButton") then
		ToggleDropDownMenu(1, nil, NecrosisMountDropDown, "NecrosisMountButton", 0, 0);
	elseif (arg1 == "LeftButton") then
		Necrosis_UseItem("Mount");
	end
end

function Necrosis_MountDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Necrosis_MountDropDown_Initialize, "MENU");
end

function Necrosis_AutoSetMount()
	MountItems = {
	Name = {},
	container = {},
	slot = {}
	};
	local index = 1;
	for container=0, 4, 1 do
		for slot=1, GetContainerNumSlots(container), 1 do
			Necrosis_MoneyToggle();
			NecrosisTooltip:SetBagItem(container, slot);
			local itemName = tostring(NecrosisTooltipTextLeft1:GetText());
			local itemDescription = tostring(NecrosisTooltipTextLeft5:GetText());
			if (string.find(itemName, NECROSIS_MOUNTITEMNAME_KEYWORD) or string.find(itemDescription, NECROSIS_MOUNTITEMDESCRIPTION_KEYWORD)) then
				MountItems.Name[index] = itemName;
				MountItems.container[index] = container;
				MountItems.slot[index] = slot;
				index = index+1;
			end
		end
	end
end

function Necrosis_MountDropDown_Initialize()
	Necrosis_AutoSetMount();

	local info = nil;
	-- Purchased
	for index = 1, table.getn(MountItems.Name), 1 do
		info = {};
		info.text = MountItems.Name[index];
		info.value = index;
		info.func = Necrosis_UseMount;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
	end
end

