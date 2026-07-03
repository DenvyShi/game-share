-- vanilla_1.12 by 狗血编剧男
-- Ver. 1.0.0 10/21/21

local I_enUS = LibStub("LibItem-enUS-1.0")

local function EditBox_Alt_Left(button)
	if ChatFrameEditBox:IsVisible() and IsAltKeyDown() and button == "LeftButton" then
		return true
	end
	return false
end

local function ChatEdit_InsertLink(quality, link, id)
	if I_enUS.Item_enUS[id] then
		ChatFrameEditBox:Insert(format("%s|H%s|h[%s]|h|r", ITEM_QUALITY_COLORS[quality].hex, link, I_enUS.Item_enUS[id]))
		if CursorHasItem() then
			ClearCursor()
		end
	end
end

--角色
hooksecurefunc("PaperDollItemSlotButton_OnClick", function(button, ignoreShift)
	if EditBox_Alt_Left(button) then
		local Itemlink = GetInventoryItemLink("player", this:GetID())
		local id = GetItemID(Itemlink)
		local _, link, quality = GetItemInfo(id)
		if link then
			ChatEdit_InsertLink(quality, link, id)
		end
	end
end)

--背包
hooksecurefunc("ContainerFrameItemButton_OnClick", function(button, ignoreShift)
	if EditBox_Alt_Left(button) then
		local bagID = this:GetParent():GetID()
		local slot = this:GetID()
		local id = GetItemID(GetContainerItemLink(bagID, slot))
		local _, link, quality = GetItemInfo(id)
		if link then
			ChatEdit_InsertLink(quality, link, id)
		end
	end
end)

--商人
hooksecurefunc("MerchantItemButton_OnClick", function(button)
	if EditBox_Alt_Left(button) then
		local Itemlink = GetMerchantItemLink(this:GetID())
		local id = GetItemID(Itemlink)
		local _, link, quality = GetItemInfo(id)
		if link then
			ChatEdit_InsertLink(quality, link, id)
		end
	end
end)

--拾取
hooksecurefunc("LootFrameItem_OnClick", function(button)
	if EditBox_Alt_Left(button) then
		local Itemlink = GetLootSlotLink(this.slot)
		local id = GetItemID(Itemlink)
		local _, link, quality = GetItemInfo(id)
		if link then
			ChatEdit_InsertLink(quality, link, id)
		end
	end
end)

--聊天框
hooksecurefunc("SetItemRef", function(link, text, button)
	if EditBox_Alt_Left(button) then
		local linkType = string.split(":", link)
		if linkType == "item" then
			local id = GetItemID(link)
			local _, link, quality = GetItemInfo(id)
			if link then
				ChatEdit_InsertLink(quality, link, id)
				if ItemRefTooltip:IsVisible() then
					ItemRefCloseButton:Click()
				end
			end
		end
	end
end)