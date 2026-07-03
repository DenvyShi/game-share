-- ForceReactiveDisk.lua
-- 力反馈盾牌管理插件 for WoW 1.12

local ADDON_NAME = "ForceReactiveDisk"
local FRD_VERSION = 2.00
local FORCE_REACTIVE_DISK_ID = 18168 -- 力反馈盾牌物品ID

-- 默认设置（会被SavedVariables覆盖）
FRD_Settings = {
    durabilityThreshold = 30,
    autoMode = true, -- 主动检测模式
    checkInterval = 0.5, -- 检测频率（秒）
    enabled = true, -- 插件开关
    monitorEnabled = true, -- 战斗中显示耐久监控
    monitorInterval = 0.5, -- 监控刷新频率（秒）
    monitorShowOOC = true, -- 脱战后也显示监控
    repairReminderEnabled = true, -- 脱战时低耐久提醒
    autoEquipArgentDawn = false, -- 脱战后自动装备银色黎明徽记
    autoEquipArgentDawnRestoreEnabled = false, -- 脱战后自动恢复原饰品
    autoEquipArgentDawnRestoreDelay = 60, -- 恢复延迟(秒)
    backupShieldEnabled = true, -- 启用备用盾牌功能
    backupShieldItemId = nil, -- 备用盾牌物品ID
    backupShieldItemLink = nil, -- 备用盾牌物品链接
    backupShieldName = nil, -- 备用盾牌名称
    backupShieldTexture = nil, -- 备用盾牌图标
    autoConfirmLootInStratholme = false, -- 斯坦索姆自动确认拾取绑定物品
    minimap = {
        angle = 0,
        shown = true
    }
}

-- 创建主框架
local FRD = CreateFrame("Frame", "ForceReactiveDiskFrame", UIParent)
FRD:RegisterEvent("ADDON_LOADED")
FRD:RegisterEvent("PLAYER_ENTERING_WORLD")
FRD:RegisterEvent("PLAYER_REGEN_DISABLED") -- 进入战斗
FRD:RegisterEvent("PLAYER_REGEN_ENABLED") -- 离开战斗
FRD:RegisterEvent("BAG_UPDATE")
FRD:RegisterEvent("UNIT_INVENTORY_CHANGED")
FRD:RegisterEvent("UPDATE_INVENTORY_ALERTS")
FRD.timeSinceLastCheck = 0
FRD.inCombat = false
FRD.warnedAllBelowTwo = false
FRD.restoreTrinketReadyTime = nil
FRD.restoreTrinketItemLink = nil
FRD.restoreTrinketItemId = nil
FRD.restoreTrinketWarnedMissing = false
FRD.restoreTrinketFrame = nil
FRD.cursorItemLink = nil
FRD.cursorItemId = nil
FRD.cursorHooked = false

-- 延迟重试机制
FRD.initialCheckAttempts = 0
FRD.maxInitialCheckAttempts = 3
FRD.initialCheckDelay = 0.5

FRD:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        -- 检查配置版本是否匹配
        if not FRD_Settings or FRD_Settings.version ~= FRD_VERSION then
            -- 版本不匹配，清空并导入默认配置
            FRD_Settings = {
                durabilityThreshold = 30,
                autoMode = true,
                checkInterval = 0.5,
                enabled = true,
                monitorEnabled = true,
                monitorInterval = 0.5,
                monitorShowOOC = true,
                repairReminderEnabled = true,
                autoEquipArgentDawn = false,
                autoEquipArgentDawnRestoreEnabled = false,
                autoEquipArgentDawnRestoreDelay = 60,
                backupShieldEnabled = true,
                backupShieldItemId = nil,
                backupShieldItemLink = nil,
                backupShieldName = nil,
                backupShieldTexture = nil,
                autoConfirmLootInStratholme = false,
                minimap = {
                    angle = 0,
                    shown = true
                },
                repairReminderPosition = { point = "TOP", relativePoint = "TOP", x = 0, y = -120 },
                version = FRD_VERSION
            }
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 配置版本不匹配，已重置为默认配置")
        end
        FRD:Initialize()
    elseif event == "PLAYER_ENTERING_WORLD" then
        FRD:UpdateMonitorVisibility(true)
        -- 重置重试计数器
        FRD.initialCheckAttempts = 0
        -- 进入世界时检查盾牌状态，确保装备正确
        FRD:PerformInitialCheck()
        -- 如果启用了自动模式且在战斗中，启动自动检测
        if FRD_Settings.autoMode and FRD_Settings.enabled and FRD.inCombat then
            FRD:StartAutoCheck()
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        FRD.inCombat = true
        FRD:StopArgentDawnRestoreTimer()
        FRD:HideRepairReminder()
        if FRD_Settings.autoMode and FRD_Settings.enabled then
            FRD:StartAutoCheck()
        end
        FRD:UpdateMonitorVisibility(true)
        FRD:UpdateMinimapIconState()
    elseif event == "PLAYER_REGEN_ENABLED" then
        FRD.inCombat = false
        FRD:StopAutoCheck()
        FRD:UpdateMonitorVisibility(true)
        FRD:CheckRepairReminder()
        FRD:AutoEquipArgentDawnTrinket()
        FRD:ResumeArgentDawnRestore()
    elseif event == "BAG_UPDATE" or event == "UPDATE_INVENTORY_ALERTS" then
        FRD:UpdateMonitorText(false)
        FRD:CheckRepairReminder()
    elseif event == "UNIT_INVENTORY_CHANGED" then
        if arg1 == "player" then
            FRD:UpdateMonitorText(false)
            FRD:CheckRepairReminder()
        end
    end
end)

-- 配置迁移（基于版本号）
-- 初始化
function FRD:HookCursorPickup()
    if self.cursorHooked then
        return
    end
    self.cursorHooked = true

    if PickupContainerItem and not self.originalPickupContainerItem then
        self.originalPickupContainerItem = PickupContainerItem
        PickupContainerItem = function(bag, slot)
            if FRD then
                FRD.cursorItemLink = GetContainerItemLink(bag, slot)
                FRD.cursorItemId = FRD:GetItemIdFromLink(FRD.cursorItemLink)
            end
            FRD.originalPickupContainerItem(bag, slot)
        end
    end

    if PickupInventoryItem and not self.originalPickupInventoryItem then
        self.originalPickupInventoryItem = PickupInventoryItem
        PickupInventoryItem = function(slot)
            if FRD then
                FRD.cursorItemLink = GetInventoryItemLink("player", slot)
                FRD.cursorItemId = FRD:GetItemIdFromLink(FRD.cursorItemLink)
            end
            FRD.originalPickupInventoryItem(slot)
        end
    end
end

-- 初始化
function FRD:Initialize()
    -- 创建小地图按钮
    self:CreateMinimapButton()
    -- 创建设置界面
    self:CreateSettingsFrame()
    -- 创建耐久监控UI
    self:CreateMonitorFrame()
    -- 注册斜杠命令
    self:RegisterSlashCommands()
    -- 钩子光标物品追踪
    self:HookCursorPickup()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00力反馈盾牌管理插件已加载!|r 使用 /frd 或 /forcedisk 来管理盾牌")
    self:UpdateMonitorVisibility(true)
    self:UpdateMinimapIconState()

    -- 初始化后立即检查一次盾牌状态
    self:CheckAndSwapDisk(true)

    -- 初始化自动确认拾取功能
    self:InitializeAutoConfirmLoot()
end

-- 初始化自动确认拾取功能
function FRD:InitializeAutoConfirmLoot()
    -- 创建一个隐藏的帧来处理拾取确认对话框
    if not self.lootConfirmFrame then
        self.lootConfirmFrame = CreateFrame("Frame")
        self.lootConfirmFrame.timeSinceLastLoot = 0
        self.lootConfirmFrame.previousNumItems = 0
        self.lootConfirmFrame.isLootingSession = false  -- 是否正在进行拾取会话
        self.lootConfirmFrame:RegisterEvent("LOOT_OPENED")
        self.lootConfirmFrame:RegisterEvent("LOOT_CLOSED")  -- 添加拾取关闭事件
        self.lootConfirmFrame:RegisterEvent("CONFIRM_LOOT_ROLL")
        self.lootConfirmFrame:SetScript("OnEvent", function()
            if event == "LOOT_OPENED" then
                FRD:OnLootOpened()
            elseif event == "LOOT_CLOSED" then
                FRD:OnLootClosed()
            elseif event == "CONFIRM_LOOT_ROLL" then
                FRD:OnConfirmLootRoll()
            end
        end)

        -- 添加 OnUpdate 脚本来处理拾取和确认对话框
        self.lootConfirmFrame:SetScript("OnUpdate", function()
            if FRD_Settings and FRD_Settings.autoConfirmLootInStratholme and this.isLootingSession then
                -- 更新计时器
                local elapsed = arg1 or 0
                this.timeSinceLastLoot = this.timeSinceLastLoot + elapsed

                -- 获取当前物品数量
                local currentNumItems = GetNumLootItems()

                -- 首先检查并点击确认对话框
                local hasDialog, clicked = FRD:CheckAndConfirmLootDialogs()

                -- 如果点击了确认，重置计时器并记录当前物品数
                if clicked then
                    this.timeSinceLastLoot = 0
                    this.waitForConfirmClose = true
                    this.previousNumItems = currentNumItems
                end

                -- 如果正在等待确认对话框关闭
                if this.waitForConfirmClose then
                    -- 检查确认对话框是否已经消失
                    if not FRD:HasLootConfirmDialog() then
                        -- 等待物品数量减少（说明物品被真正拾取了）
                        if currentNumItems < this.previousNumItems then
                            this.waitForConfirmClose = false
                            this.timeSinceLastLoot = 0  -- 物品被拾取，重置计时器
                        end
                    end
                end

                -- 如果没有确认对话框，且距离上次拾取超过 0.2 秒，尝试拾取下一个物品
                if not hasDialog and not this.waitForConfirmClose and this.timeSinceLastLoot >= 0.2 then
                    FRD:TryLootNextItem()
                    this.timeSinceLastLoot = 0
                end
            end
        end)
    end
end

-- 拾取窗口打开时触发
function FRD:OnLootOpened()
    -- 检查是否启用功能
    if not FRD_Settings.autoConfirmLootInStratholme then
        return
    end

    -- 标记开始拾取会话
    if self.lootConfirmFrame then
        self.lootConfirmFrame.isLootingSession = true
        self.lootConfirmFrame.timeSinceLastLoot = 0
        self.lootConfirmFrame.waitForConfirmClose = false
    end

    -- 开始自动拾取第一个物品（延迟 0.1 秒，确保拾取窗口完全加载）
    self.lootConfirmFrame.timeSinceLastLoot = 0.1
end

-- 拾取窗口关闭时触发
function FRD:OnLootClosed()
    -- 标记拾取会话结束
    if self.lootConfirmFrame then
        self.lootConfirmFrame.isLootingSession = false
        self.lootConfirmFrame.waitForConfirmClose = false
    end
end

-- 尝试拾取下一个物品
function FRD:TryLootNextItem()
    -- 如果拾取窗口已关闭，停止拾取
    if not LootFrame:IsVisible() then
        return
    end

    -- 检查是否还有物品可以拾取（总是拾取槽位1，因为物品被拾取后会自动前移）
    local numItems = GetNumLootItems()

    if numItems > 0 then
        local texture, item, quantity, quality = GetLootSlotInfo(1)
        if item and quality then
            -- 拾取槽位1的物品
            LootSlot(1)
        end
    end
end

-- 检查是否存在拾取确认对话框
function FRD:HasLootConfirmDialog()
    for i = 1, 4 do
        local popup = getglobal("StaticPopup" .. i)
        if popup and popup:IsVisible() then
            local text = getglobal("StaticPopup" .. i .. "Text")
            if text then
                local popupText = text:GetText()
                -- 只匹配真正的拾取对话框，不匹配装备对话框
                -- 拾取对话框通常包含"拾取"、"Loot"、"Pick"等关键词
                -- 排除包含"装备"、"Equip"的装备绑定对话框
                if popupText and (
                    string.find(popupText, "拾取") or
                    string.find(popupText, "Loot") or
                    string.find(popupText, "Pick")
                ) and not (
                    string.find(popupText, "装备") or
                    string.find(popupText, "Equip")
                ) then
                    return true
                end
            end
        end
    end
    return false
end

-- 检查并确认所有拾取对话框，返回 (是否有对话框, 是否点击了确认)
function FRD:CheckAndConfirmLootDialogs()
    local hasDialog = false
    local clicked = false

    -- 检查所有可能显示的确认对话框
    for i = 1, 4 do
        local popup = getglobal("StaticPopup" .. i)
        if popup and popup:IsVisible() then
            local text = getglobal("StaticPopup" .. i .. "Text")
            if text then
                local popupText = text:GetText()
                -- 只匹配真正的拾取对话框，不匹配装备对话框
                if popupText and (
                    string.find(popupText, "拾取") or
                    string.find(popupText, "Loot") or
                    string.find(popupText, "Pick")
                ) and not (
                    string.find(popupText, "装备") or
                    string.find(popupText, "Equip")
                ) then
                    hasDialog = true
                    -- 自动确认拾取
                    local button = getglobal("StaticPopup" .. i .. "Button1")
                    if button then
                        button:Click()
                        clicked = true
                    end
                end
            end
        end
    end

    return hasDialog, clicked
end

-- 拾取确认对话框触发
function FRD:OnConfirmLootRoll()
    -- 检查是否启用功能
    if not FRD_Settings.autoConfirmLootInStratholme then
        return
    end

    -- 调用统一的检查函数
    self:CheckAndConfirmLootDialogs()
end

-- 延迟重试机制：执行初始检查
function FRD:PerformInitialCheck()
    if FRD.initialCheckAttempts >= FRD.maxInitialCheckAttempts then
        return
    end

    FRD.initialCheckAttempts = FRD.initialCheckAttempts + 1

    -- 尝试检查盾牌状态
    local success = self:CheckAndSwapDisk(true)

    -- 如果检查失败，延迟后重试
    if not success then
        if FRD.initialCheckAttempts < FRD.maxInitialCheckAttempts then
            -- 创建一个独立的延迟帧
            local delayFrame = CreateFrame("Frame")
            delayFrame:Hide()
            local delayTime = 0
            delayFrame:SetScript("OnUpdate", function()
                delayTime = delayTime + arg1
                if delayTime >= FRD.initialCheckDelay then
                    delayFrame:Hide()
                    FRD:PerformInitialCheck()
                end
            end)
            delayFrame:Show()
        end
    end
end

-- 创建耐久监控小窗（战斗中显示）
function FRD:CreateMonitorFrame()
    if self.monitorFrame then
        return
    end

    local frame = CreateFrame("Frame", "FRDMonitorFrame", UIParent)
    frame:SetWidth(300)
    frame:SetHeight(200)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.7)
    frame:Hide()

    local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
    header:SetWidth(280)
    header:SetJustifyH("LEFT")
    header:SetText("")
    frame.header = header

    local container = CreateFrame("Frame", nil, frame)
    container:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
    container:SetWidth(280)
    container:SetHeight(110)
    frame.iconContainer = container
    frame.icons = {}

    local restorePanel = CreateFrame("Frame", nil, frame)
    restorePanel:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 0, -6)
    restorePanel:SetWidth(280)
    restorePanel:SetHeight(42)
    restorePanel:Hide()
    frame.restorePanel = restorePanel

    local restoreText = restorePanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    restoreText:SetPoint("TOP", restorePanel, "TOP", 0, 0)
    restoreText:SetWidth(280)
    restoreText:SetJustifyH("CENTER")
    restoreText:SetText("")
    restorePanel.text = restoreText

    local restoreAdd = CreateFrame("Button", nil, restorePanel, "UIPanelButtonTemplate")
    restoreAdd:SetPoint("TOP", restorePanel, "TOP", -38, -16)
    restoreAdd:SetWidth(50)
    restoreAdd:SetHeight(18)
    restoreAdd:SetText("+15秒")
    restorePanel.addButton = restoreAdd

    local restoreNow = CreateFrame("Button", nil, restorePanel, "UIPanelButtonTemplate")
    restoreNow:SetPoint("LEFT", restoreAdd, "RIGHT", 6, 0)
    restoreNow:SetWidth(70)
    restoreNow:SetHeight(18)
    restoreNow:SetText("立即替换")
    restorePanel.nowButton = restoreNow

    restoreAdd:SetScript("OnClick", function()
        FRD:ExtendArgentDawnRestore(15)
    end)
    restoreNow:SetScript("OnClick", function()
        if FRD.inCombat then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 战斗中无法替换饰品")
            return
        end
        FRD:TryRestoreArgentDawnTrinket()
    end)

    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() this:StartMoving() end)
    frame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

    frame.timeSinceLastUpdate = 0
    self.monitorFrame = frame
end

function FRD:StartMonitor()
    if not self.monitorFrame then
        self:CreateMonitorFrame()
    end

    self.monitorFrame.timeSinceLastUpdate = 0
    self.monitorFrame:SetScript("OnUpdate", function()
        FRD.monitorFrame.timeSinceLastUpdate = FRD.monitorFrame.timeSinceLastUpdate + arg1
        if FRD.monitorFrame.timeSinceLastUpdate >= (FRD_Settings.monitorInterval or 0.5) then
            FRD.monitorFrame.timeSinceLastUpdate = 0
            FRD:UpdateMonitorText(true)
        end
    end)
end

function FRD:StopMonitor()
    if self.monitorFrame then
        self.monitorFrame:SetScript("OnUpdate", nil)
    end
end

-- 获取银色黎明徽记优先级
function FRD:GetArgentDawnTrinketPriority(itemId)
    if itemId == 23206 or itemId == 23207 then
        return 1
    end
    if itemId == 19812 or itemId == 13209 then
        return 2
    end
    if itemId == 12846 then
        return 3
    end
    return nil
end

-- 从物品链接获取物品ID
function FRD:GetItemIdFromLink(itemLink)
    if not itemLink then
        return nil
    end
    local _, _, itemId = string.find(itemLink, "item:(%d+)")
    return tonumber(itemId)
end

-- 获取备用盾牌物品ID
function FRD:GetBackupShieldItemId()
    if FRD_Settings.backupShieldItemId then
        return FRD_Settings.backupShieldItemId
    end
    if FRD_Settings.backupShieldItemLink then
        local itemId = self:GetItemIdFromLink(FRD_Settings.backupShieldItemLink)
        FRD_Settings.backupShieldItemId = itemId
        return itemId
    end
    return nil
end

-- 查找备用盾牌（副手优先，其次背包）
function FRD:FindBackupShield()
    local itemId = self:GetBackupShieldItemId()
    if not itemId then
        return nil
    end

    -- 检查副手
    local offhandLink = GetInventoryItemLink("player", 17)
    if offhandLink then
        local offhandId = self:GetItemIdFromLink(offhandLink)
        if offhandId == itemId then
            return {
                bag = nil,
                slot = nil,
                itemId = itemId,
                itemLink = offhandLink,
                name = FRD_Settings.backupShieldName,
                texture = FRD_Settings.backupShieldTexture,
                equipped = true
            }
        end
    end

    -- 检查背包
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local bagItemId = self:GetItemIdFromLink(link)
                if bagItemId == itemId then
                    return {
                        bag = bag,
                        slot = slot,
                        itemId = itemId,
                        itemLink = link,
                        name = FRD_Settings.backupShieldName,
                        texture = FRD_Settings.backupShieldTexture,
                        equipped = false
                    }
                end
            end
        end
    end

    return nil
end

-- 装备备用盾牌
function FRD:EquipBackupShield(silent, manual)
    local backup = self:FindBackupShield()
    if not backup then
        return false
    end
    if backup.equipped then
        return true
    end
    if backup.bag and backup.slot then
        self:EquipDisk(backup.bag, backup.slot)
        if not silent then
            if manual then
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 手动切换到备用盾牌")
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FRD]|r 所有力反馈盾牌耐久为0，已强制切换到备用盾牌")
            end
        end
        return true
    end
    return false
end

-- 尝试在所有力反馈盾牌耗尽时装备备用盾牌
function FRD:TryEquipBackupShieldWhenAllDisksBroken(silent, offhandIsDisk, currentDurability, disks)
    if not FRD_Settings.backupShieldEnabled then
        return false
    end
    if not self:GetBackupShieldItemId() then
        return false
    end

    local totalDisks = table.getn(disks) + (offhandIsDisk and 1 or 0)
    if totalDisks <= 0 then
        return false
    end

    local allBroken = true
    if offhandIsDisk and currentDurability and currentDurability > 0 then
        allBroken = false
    end
    for _, disk in ipairs(disks) do
        if disk and disk.durability and disk.durability > 0 then
            allBroken = false
            break
        end
    end

    if not allBroken then
        return false
    end

    local backup = self:FindBackupShield()
    if backup then
        if backup.equipped then
            return true
        end
        if backup.bag and backup.slot then
            self:EquipDisk(backup.bag, backup.slot)
            if not silent then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FRD]|r 所有力反馈盾牌耐久为0，已强制切换到备用盾牌")
            end
            return true
        end
    end

    return false
end

-- 从光标物品设置备用盾牌
function FRD:TrySetBackupShieldFromCursor()
    if not self.cursorItemLink or not self.cursorItemId then
        return
    end
    local itemName, _, _, _, _, _, _, _, itemTexture = GetItemInfo(self.cursorItemId)
    local info = {
        itemId = self.cursorItemId,
        itemLink = self.cursorItemLink,
        name = itemName,
        texture = itemTexture
    }
    if not info.texture then
        info.texture = "Interface\\Icons\\INV_Shield_05"
    end
    if not info.name then
        info.name = "未知盾牌"
    end
    self:SetBackupShieldPending(info)
    ClearCursor()
    self.cursorItemLink = nil
    self.cursorItemId = nil
end

-- 从当前副手设置备用盾牌
function FRD:TrySetBackupShieldFromOffhand()
    local offhandLink = GetInventoryItemLink("player", 17)
    if not offhandLink then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 当前副手为空")
        return
    end
    local itemId = self:GetItemIdFromLink(offhandLink)
    local itemName, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemId)
    local info = {
        itemId = itemId,
        itemLink = offhandLink,
        name = itemName,
        texture = itemTexture
    }
    if not info.texture then
        info.texture = "Interface\\Icons\\INV_Shield_05"
    end
    if not info.name then
        info.name = "未知盾牌"
    end
    self:SetBackupShieldPending(info)
end

-- 设置待保存的备用盾牌
function FRD:SetBackupShieldPending(info)
    if not self.settingsFrame then
        return
    end
    self.settingsFrame.backupShieldPending = info
    self:UpdateBackupShieldSelectionDisplay()
end

-- 清除待保存的备用盾牌
function FRD:ClearBackupShieldPending()
    if not self.settingsFrame then
        return
    end
    self.settingsFrame.backupShieldPending = nil
    self:UpdateBackupShieldSelectionDisplay()
end

-- 从配置重置备用盾牌显示
function FRD:ResetBackupShieldPendingFromSettings()
    if not self.settingsFrame then
        return
    end
    if FRD_Settings.backupShieldItemId then
        local info = {
            itemId = FRD_Settings.backupShieldItemId,
            itemLink = FRD_Settings.backupShieldItemLink,
            name = FRD_Settings.backupShieldName,
            texture = FRD_Settings.backupShieldTexture
        }
        if GetItemInfo and info.itemId and (not info.name or not info.texture) then
            local itemName, _, _, _, _, _, _, _, itemTexture = GetItemInfo(info.itemId)
            if not info.name then
                info.name = itemName
            end
            if not info.texture then
                info.texture = itemTexture
            end
        end
        if not info.texture then
            info.texture = "Interface\\Icons\\INV_Shield_05"
        end
        if not info.name then
            info.name = "未知盾牌"
        end
        self.settingsFrame.backupShieldPending = info
    else
        self.settingsFrame.backupShieldPending = nil
    end
    self:UpdateBackupShieldSelectionDisplay()
end

-- 更新备用盾牌选择显示
function FRD:UpdateBackupShieldSelectionDisplay()
    if not self.settingsFrame then
        return
    end
    local pending = self.settingsFrame.backupShieldPending
    local button = self.settingsFrame.backupShieldButton
    local nameText = self.settingsFrame.backupShieldName

    if pending then
        button.icon:SetTexture(pending.texture)
        nameText:SetText(pending.name or "未知盾牌")
    else
        button.icon:SetTexture("Interface\\Icons\\INV_Shield_05")
        nameText:SetText("未设置，拖动盾牌至此")
    end
end

-- 应用备用盾牌设置到配置
function FRD:ApplyBackupShieldPendingToSettings()
    local pending = self.settingsFrame and self.settingsFrame.backupShieldPending
    if pending then
        FRD_Settings.backupShieldItemId = pending.itemId
        FRD_Settings.backupShieldItemLink = pending.itemLink
        FRD_Settings.backupShieldName = pending.name
        FRD_Settings.backupShieldTexture = pending.texture
    else
        FRD_Settings.backupShieldItemId = nil
        FRD_Settings.backupShieldItemLink = nil
        FRD_Settings.backupShieldName = nil
        FRD_Settings.backupShieldTexture = nil
    end
end

-- 获取备用盾牌监控条目
function FRD:GetBackupShieldMonitorEntry()
    if not FRD_Settings.backupShieldEnabled then
        return nil
    end
    if not self:GetBackupShieldItemId() then
        return nil
    end

    local info = self:FindBackupShield()
    local texture = FRD_Settings.backupShieldTexture or "Interface\\Icons\\INV_Shield_05"
    local entry = {
        label = "备用盾牌",
        texture = texture,
        durability = nil,
        equipped = false,
        isBackup = true,
        found = false
    }
    if info then
        entry.texture = info.texture or texture
        entry.equipped = info.equipped
        entry.bag = info.bag
        entry.slot = info.slot
        entry.found = true
    end
    return entry
end

-- 获取光标物品信息
function FRD:GetCursorItemInfo()
    if not self.cursorItemLink or not self.cursorItemId then
        return nil
    end
    return self.cursorItemId
end

-- 查找最好的银色黎明徽记
function FRD:FindBestArgentDawnTrinket()
    local best = nil
    local bestPriority = nil
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local itemId = self:GetItemIdFromLink(link)
                local priority = self:GetArgentDawnTrinketPriority(itemId)
                if priority then
                    if not bestPriority or priority < bestPriority then
                        bestPriority = priority
                        best = { bag = bag, slot = slot, itemId = itemId, priority = priority }
                        if priority == 1 then
                            return best
                        end
                    end
                end
            end
        end
    end
    return best
end

-- 根据链接或ID在背包中查找物品
function FRD:FindItemInBagsByLinkOrId(itemLink, itemId)
    local targetId = itemId
    if not targetId and itemLink then
        targetId = self:GetItemIdFromLink(itemLink)
    end
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                if itemLink and link == itemLink then
                    return bag, slot
                end
                if targetId and self:GetItemIdFromLink(link) == targetId then
                    return bag, slot
                end
            end
        end
    end
    return nil
end

-- 装备饰品
function FRD:EquipTrinket(bag, slot, invSlot)
    PickupContainerItem(bag, slot)
    PickupInventoryItem(invSlot)
end

-- 设置银色黎明恢复目标
function FRD:SetArgentDawnRestoreTarget(itemLink, itemId)
    self.restoreTrinketItemLink = itemLink
    self.restoreTrinketItemId = itemId
    self.restoreTrinketWarnedMissing = false
end

-- 清除银色黎明恢复目标
function FRD:ClearArgentDawnRestoreTarget()
    self.restoreTrinketReadyTime = nil
    self.restoreTrinketItemLink = nil
    self.restoreTrinketItemId = nil
    self.restoreTrinketWarnedMissing = false
    self:StopArgentDawnRestoreTimer()
    self:RefreshMonitorTextIfVisible()
end

-- 安排银色黎明恢复
function FRD:ScheduleArgentDawnRestore()
    if not FRD_Settings.autoEquipArgentDawnRestoreEnabled then
        self:ClearArgentDawnRestoreTarget()
        return
    end
    local delay = FRD_Settings.autoEquipArgentDawnRestoreDelay or 60
    if delay < 30 then delay = 30 end
    if delay > 180 then delay = 180 end
    self.restoreTrinketReadyTime = GetTime() + delay
    if not self.inCombat then
        self:StartArgentDawnRestoreTimer()
    end
    self:RefreshMonitorTextIfVisible()
end

-- 延长银色黎明恢复时间
function FRD:ExtendArgentDawnRestore(seconds)
    if not self.restoreTrinketReadyTime then
        return
    end
    self.restoreTrinketReadyTime = self.restoreTrinketReadyTime + seconds
    if not self.inCombat then
        self:StartArgentDawnRestoreTimer()
    end
    self:RefreshMonitorTextIfVisible()
end

-- 恢复银色黎明恢复计时器
function FRD:ResumeArgentDawnRestore()
    if not self.restoreTrinketReadyTime then
        return
    end
    if not FRD_Settings.autoEquipArgentDawnRestoreEnabled then
        self:ClearArgentDawnRestoreTarget()
        return
    end
    if self.inCombat then
        return
    end
    self:StartArgentDawnRestoreTimer()
    if GetTime() >= self.restoreTrinketReadyTime then
        self:TryRestoreArgentDawnTrinket()
    end
    self:RefreshMonitorTextIfVisible()
end

-- 启动银色黎明恢复计时器
function FRD:StartArgentDawnRestoreTimer()
    if not self.restoreTrinketReadyTime then
        return
    end
    if not self.restoreTrinketFrame then
        self.restoreTrinketFrame = CreateFrame("Frame")
    end
    self.restoreTrinketFrame:SetScript("OnUpdate", function()
        if not FRD.restoreTrinketReadyTime then
            FRD:StopArgentDawnRestoreTimer()
            return
        end
        if FRD.inCombat then
            return
        end
        if GetTime() >= FRD.restoreTrinketReadyTime then
            FRD:TryRestoreArgentDawnTrinket()
        end
    end)
end

-- 停止银色黎明恢复计时器
function FRD:StopArgentDawnRestoreTimer()
    if self.restoreTrinketFrame then
        self.restoreTrinketFrame:SetScript("OnUpdate", nil)
    end
end

-- 尝试恢复银色黎明饰品
function FRD:TryRestoreArgentDawnTrinket()
    if not self.restoreTrinketReadyTime then
        return
    end
    if self.inCombat then
        return
    end
    if not FRD_Settings.enabled or not FRD_Settings.autoEquipArgentDawnRestoreEnabled then
        self:ClearArgentDawnRestoreTarget()
        return
    end

    local equippedLink = GetInventoryItemLink("player", 13)
    if equippedLink then
        if self.restoreTrinketItemLink and equippedLink == self.restoreTrinketItemLink then
            self:ClearArgentDawnRestoreTarget()
            return
        end
        local equippedId = self:GetItemIdFromLink(equippedLink)
        local isArgent = self:GetArgentDawnTrinketPriority(equippedId)
        if not isArgent and equippedId ~= self.restoreTrinketItemId then
            self:ClearArgentDawnRestoreTarget()
            return
        end
    end

    local bag, slot = self:FindItemInBagsByLinkOrId(self.restoreTrinketItemLink, self.restoreTrinketItemId)
    if not bag then
        if not self.restoreTrinketWarnedMissing then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 未找到原饰品，无法自动恢复")
            self.restoreTrinketWarnedMissing = true
        end
        self:ClearArgentDawnRestoreTarget()
        return
    end

    self:EquipTrinket(bag, slot, 13)
    self:ClearArgentDawnRestoreTarget()
    self:RefreshMonitorTextIfVisible()
end

-- 自动装备银色黎明徽记
function FRD:AutoEquipArgentDawnTrinket()
    if not FRD_Settings.enabled or not FRD_Settings.autoEquipArgentDawn then
        return
    end

    if not FRD_Settings.autoEquipArgentDawnRestoreEnabled and self.restoreTrinketReadyTime then
        self:ClearArgentDawnRestoreTarget()
    end

    local best = self:FindBestArgentDawnTrinket()
    if not best then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 背包内没有符合条件的银色黎明徽记，请检查背包")
        return
    end

    local equippedLink = GetInventoryItemLink("player", 13)
    local equippedId = nil
    if equippedLink then
        equippedId = self:GetItemIdFromLink(equippedLink)
        local equippedPriority = self:GetArgentDawnTrinketPriority(equippedId)
        if equippedPriority and equippedPriority <= best.priority then
            return
        end
    end

    local originalLink = nil
    local originalId = nil
    if FRD_Settings.autoEquipArgentDawnRestoreEnabled and equippedLink and equippedId then
        if not self:GetArgentDawnTrinketPriority(equippedId) then
            originalLink = equippedLink
            originalId = equippedId
        end
    end

    self:EquipTrinket(best.bag, best.slot, 13)
    if originalLink then
        self:SetArgentDawnRestoreTarget(originalLink, originalId)
        self:ScheduleArgentDawnRestore()
    end
end

-- 刷新监控文本（如果可见）
function FRD:RefreshMonitorTextIfVisible()
    if self.monitorFrame and self.monitorFrame:IsShown() then
        self:UpdateMonitorText(true)
    end
end

function FRD:UpdateMonitorVisibility(forceUpdateText)
    if not self.monitorFrame then
        self:CreateMonitorFrame()
    end

    local shouldShow = FRD_Settings.enabled and FRD_Settings.monitorEnabled and self.inCombat
    if FRD_Settings.monitorEnabled and FRD_Settings.monitorShowOOC then
        shouldShow = FRD_Settings.enabled
    end
    if shouldShow then
        self.monitorFrame:Show()
        self:StartMonitor()
        self:UpdateMonitorText(forceUpdateText)
    else
        self:StopMonitor()
        self.monitorFrame:Hide()
    end
end

function FRD:FormatDurabilityColor(durabilityPercent)
    if not durabilityPercent then
        return "|cff888888"
    end
    if durabilityPercent < (FRD_Settings.durabilityThreshold or 30) then
        return "|cffff0000"
    end
    if durabilityPercent < 60 then
        return "|cffff9900"
    end
    return "|cff00ff00"
end

function FRD:UpdateMonitorText(force)
    if not self.monitorFrame or not self.monitorFrame:IsShown() then
        return
    end

    local offhandIsDisk = self:IsOffhandForceReactiveDisk()
    local offhandDurability = nil
    local offhandTexture = nil
    if offhandIsDisk then
        offhandDurability = self:GetOffhandDurability()
        offhandTexture = GetInventoryItemTexture("player", 17)
    end

    local disks = self:FindAllDisksInBags()
    local bagCount = table.getn(disks)
    local best = nil
    local worst = nil
    if bagCount > 0 then
        for i = 1, bagCount do
            local d = disks[i].durability
            if not best or d > best then best = d end
            if not worst or d < worst then worst = d end
        end
    end

    local entries = {}

    if offhandIsDisk then
        table.insert(entries, {
            label = "副手",
            durability = offhandDurability,
            texture = offhandTexture or "Interface\\Icons\\INV_Shield_21",
            equipped = true
        })
    end

    if bagCount > 0 then
        table.sort(disks, function(a, b) return a.durability > b.durability end)
        for i = 1, bagCount do
            local d = disks[i]
            local texture
            if GetContainerItemInfo then
                local tex = GetContainerItemInfo(d.bag, d.slot)
                if type(tex) == "table" then
                    texture = tex.icon
                else
                    texture = tex
                end
            end
            texture = texture or "Interface\\Icons\\INV_Shield_21"
            table.insert(entries, {
                label = "包" .. d.bag .. "槽" .. d.slot,
                durability = d.durability,
                texture = texture,
                equipped = false,
                bag = d.bag,
                slot = d.slot
            })
        end
    end

    local totalDur = 0
    local totalCount = table.getn(entries)
    for i = 1, totalCount do
        if entries[i].durability then
            totalDur = totalDur + entries[i].durability
        end
    end

    local totalInfo
    if totalCount > 0 then
        local totalPool = totalCount * 100
        totalInfo = string.format("总耐久: %.1f%% / %d%%", totalDur, totalPool)
    else
        totalInfo = "总耐久: 无力反馈盾牌"
    end

    self.monitorFrame.header:SetText(totalInfo)

    local backupEntry = self:GetBackupShieldMonitorEntry()
    if backupEntry then
        table.insert(entries, backupEntry)
    end

    local totalCount = table.getn(entries)

    local columns = 6
    local iconSize = 36
    local padding = 6

    local usedCols = totalCount > 0 and math.min(columns, totalCount) or 1
    local rows = math.max(1, math.ceil(totalCount / usedCols))
    local contentWidth = usedCols * (iconSize + padding) - padding
    if contentWidth < 120 then contentWidth = 120 end
    local frameWidth = contentWidth + 20
    local contentHeight = rows * (iconSize + 18)
    local frameHeight = 40 + contentHeight

    self.monitorFrame:SetWidth(frameWidth)
    self.monitorFrame.header:SetWidth(frameWidth - 20)
    self.monitorFrame.iconContainer:SetWidth(contentWidth)
    self.monitorFrame.iconContainer:SetHeight(contentHeight)

    for i = 1, totalCount do
        local entry = entries[i]
        local iconFrame = self.monitorFrame.icons[i]
        if not iconFrame then
            iconFrame = CreateFrame("Button", nil, self.monitorFrame.iconContainer)
            iconFrame:SetWidth(iconSize)
            iconFrame:SetHeight(iconSize + 14)
            iconFrame:RegisterForClicks("LeftButtonUp")

            iconFrame.bg = iconFrame:CreateTexture(nil, "BACKGROUND")
            iconFrame.bg:SetAllPoints()
            iconFrame.bg:SetTexture(0, 0, 0, 0.5)

            iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
            iconFrame.icon:SetWidth(iconSize)
            iconFrame.icon:SetHeight(iconSize)
            iconFrame.icon:SetPoint("TOP", iconFrame, "TOP", 0, 0)

            iconFrame.text = iconFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            iconFrame.text:SetPoint("TOP", iconFrame.icon, "BOTTOM", 0, -2)
            iconFrame.text:SetText("")

            iconFrame:SetScript("OnClick", function()
                if this.isBackup then
                    -- 备用盾牌
                    FRD:EquipBackupShield(false, true)
                elseif this.bag and this.slot then
                    -- 力反馈盾牌
                    FRD:EquipDisk(this.bag, this.slot)
                end
            end)

            self.monitorFrame.icons[i] = iconFrame
        end

        local col = math.mod((i - 1), usedCols)
        local row = math.floor((i - 1) / usedCols)
        iconFrame:SetPoint("TOPLEFT", self.monitorFrame.iconContainer, "TOPLEFT", col * (iconSize + padding), -row * (iconSize + 18))

        if entry.isSpacer then
            iconFrame.icon:Hide()
            iconFrame.text:SetText("")
            iconFrame.bg:SetTexture(0, 0, 0, 0)
            iconFrame.bag = nil
            iconFrame.slot = nil
            iconFrame.isBackup = nil
            iconFrame.isSpacer = true
            iconFrame:EnableMouse(false)
        else
            iconFrame.icon:Show()
            iconFrame.icon:SetTexture(entry.texture)
            iconFrame.bag = entry.bag
            iconFrame.slot = entry.slot
            iconFrame.isBackup = entry.isBackup
            iconFrame.isSpacer = nil
            iconFrame:EnableMouse(true)

        if entry.isBackup then
            -- 备用盾牌显示特殊样式
            local labelColor = entry.found and "|cff00ff00" or "|cff888888"
            iconFrame.text:SetText(labelColor .. "备用|r")
            if entry.equipped then
                iconFrame.bg:SetTexture(0, 0.5, 0, 0.5)
            else
                iconFrame.bg:SetTexture(0, 0, 0, 0.5)
            end
        else
            -- 力反馈盾牌显示耐久度
            if entry.durability then
                local colorCode = self:FormatDurabilityColor(entry.durability)
                iconFrame.text:SetText(colorCode .. string.format("%.0f", entry.durability) .. "%|r")
            else
                iconFrame.text:SetText("|cff888888--|r")
            end
            if entry.equipped then
                iconFrame.bg:SetTexture(0, 0.5, 0, 0.5)
            else
                iconFrame.bg:SetTexture(0, 0, 0, 0.5)
            end
        end

        iconFrame:Show()
        end
    end

    if self.monitorFrame.icons then
        for i = totalCount + 1, table.getn(self.monitorFrame.icons) do
            if self.monitorFrame.icons[i] then
                self.monitorFrame.icons[i]:Hide()
            end
        end
    end

    self.monitorFrame:SetHeight(frameHeight)

    -- 更新银色黎明恢复面板
    if self.monitorFrame.restorePanel then
        local restorePanel = self.monitorFrame.restorePanel
        local showRestore = self.restoreTrinketReadyTime
            and FRD_Settings.autoEquipArgentDawn
            and FRD_Settings.autoEquipArgentDawnRestoreEnabled

        if showRestore then
            local remaining = math.ceil(self.restoreTrinketReadyTime - GetTime())
            if remaining < 0 then remaining = 0 end
            if self.inCombat then
                restorePanel.text:SetText("|cffff9900战斗中暂停|r")
                restorePanel.addButton:Disable()
                restorePanel.nowButton:Disable()
            else
                restorePanel.text:SetText(string.format("饰品恢复: %d秒", remaining))
                restorePanel.addButton:Enable()
                restorePanel.nowButton:Enable()
            end
            restorePanel:SetWidth(frameWidth - 20)
            restorePanel:SetHeight(42)
            restorePanel.text:SetWidth(frameWidth - 20)
            restorePanel:ClearAllPoints()
            restorePanel:SetPoint("TOPLEFT", self.monitorFrame.iconContainer, "BOTTOMLEFT", 0, -8)
            restorePanel:Show()
            frameHeight = frameHeight + 50
        else
            restorePanel:Hide()
        end
    end

    self.monitorFrame:SetHeight(frameHeight)
end

-- 重置可拖动小窗位置（监控与修理提示）
function FRD:ResetFramePositions()
    -- 监控小窗
    if not self.monitorFrame then
        self:CreateMonitorFrame()
    end
    if self.monitorFrame then
        self.monitorFrame:ClearAllPoints()
        self.monitorFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
    end

    -- 修理提醒
    FRD_Settings.repairReminderPosition = { point = "TOP", relativePoint = "TOP", x = 0, y = -120 }
    if self.repairReminderFrame then
        self.repairReminderFrame:ClearAllPoints()
        self.repairReminderFrame:SetPoint("TOP", UIParent, "TOP", 0, -120)
    end

    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 小窗口位置已重置")
end

-- 脱战后低耐久提醒
function FRD:CheckRepairReminder()
    if not FRD_Settings.enabled or not FRD_Settings.repairReminderEnabled then
        self:HideRepairReminder()
        return
    end

    local threshold = 90
    local needRepair = false

    if self:IsOffhandForceReactiveDisk() then
        local offDur = self:GetOffhandDurability()
        if offDur and offDur < threshold then
            needRepair = true
        end
    end

    if not needRepair then
        local disks = self:FindAllDisksInBags()
        for i = 1, table.getn(disks) do
            if disks[i].durability < threshold then
                needRepair = true
                break
            end
        end
    end

    if needRepair then
        if not self.inCombat then
            self:ShowRepairReminder()
        end
    else
        self:HideRepairReminder()
    end
end

function FRD:EnsureRepairReminderFrame()
    if self.repairReminderFrame then
        return
    end
    local frame = CreateFrame("Frame", "FRDRepairReminderFrame", UIParent)
    frame:SetWidth(400)
    frame:SetHeight(50)
    local pos = FRD_Settings.repairReminderPosition or { point = "TOP", relativePoint = "TOP", x = 0, y = -120 }
    frame:SetPoint(pos.point or "TOP", UIParent, pos.relativePoint or pos.point or "TOP", pos.x or 0, pos.y or -120)
    frame:SetFrameStrata("HIGH")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 24,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        this:StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
        local point, _, relativePoint, xOfs, yOfs = this:GetPoint()
        FRD_Settings.repairReminderPosition = {
            point = point or "TOP",
            relativePoint = relativePoint or point or "TOP",
            x = xOfs or 0,
            y = yOfs or -120
        }
    end)

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    text:SetText("|cffff0000[FRD]|r 盾牌耐久低于90%，请尽快修理！")
    frame.text = text
    frame:Hide()
    self.repairReminderFrame = frame
end

function FRD:ShowRepairReminder()
    self:EnsureRepairReminderFrame()
    if self.repairReminderFrame then
        self.repairReminderFrame:Show()
    end
end

function FRD:HideRepairReminder()
    if self.repairReminderFrame then
        self.repairReminderFrame:Hide()
    end
end

-- 获取物品耐久度百分比（使用tooltip扫描）
function FRD:GetItemDurability(bag, slot)
    if not FRDScanTooltip then
        CreateFrame("GameTooltip", "FRDScanTooltip", nil, "GameTooltipTemplate")
        FRDScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    
    FRDScanTooltip:ClearLines()
    FRDScanTooltip:SetBagItem(bag, slot)
    
    -- 扫描tooltip文本查找耐久度
    for i = 1, FRDScanTooltip:NumLines() do
        local text = getglobal("FRDScanTooltipTextLeft" .. i):GetText()
        if text then
            -- 匹配 "耐久度 XX / YY" 或 "Durability XX / YY"
            local current, maximum = string.match(text, "(%d+)%s*/%s*(%d+)")
            if current and maximum then
                current = tonumber(current)
                maximum = tonumber(maximum)
                if maximum > 0 then
                    return (current / maximum) * 100
                end
            end
        end
    end
    
    return 100 -- 如果没有耐久度信息，假设为满耐久
end

-- 检查指定位置是否是力反馈盾牌
function FRD:IsForceReactiveDisk(bag, slot)
    local itemLink = GetContainerItemLink(bag, slot)
    if itemLink then
        local _, _, itemId = string.find(itemLink, "item:(%d+)")
        return tonumber(itemId) == FORCE_REACTIVE_DISK_ID
    end
    return false
end

-- 查找背包中所有力反馈盾牌
function FRD:FindAllDisksInBags()
    local disks = {}
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            if self:IsForceReactiveDisk(bag, slot) then
                local durability = self:GetItemDurability(bag, slot)
                table.insert(disks, {
                    bag = bag,
                    slot = slot,
                    durability = durability
                })
            end
        end
    end
    return disks
end

-- 检查副手是否装备力反馈盾牌
function FRD:IsOffhandForceReactiveDisk()
    local offhandLink = GetInventoryItemLink("player", 17) -- 17是副手槽位
    if offhandLink then
        local _, _, itemId = string.find(offhandLink, "item:(%d+)")
        return tonumber(itemId) == FORCE_REACTIVE_DISK_ID
    end
    return false
end

-- 获取副手耐久度
function FRD:GetOffhandDurability()
    if not FRDScanTooltip then
        CreateFrame("GameTooltip", "FRDScanTooltip", nil, "GameTooltipTemplate")
        FRDScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    
    FRDScanTooltip:ClearLines()
    FRDScanTooltip:SetInventoryItem("player", 17)
    
    -- 扫描tooltip文本查找耐久度
    for i = 1, FRDScanTooltip:NumLines() do
        local text = getglobal("FRDScanTooltipTextLeft" .. i):GetText()
        if text then
            local current, maximum = string.match(text, "(%d+)%s*/%s*(%d+)")
            if current and maximum then
                current = tonumber(current)
                maximum = tonumber(maximum)
                if maximum > 0 then
                    return (current / maximum) * 100
                end
            end
        end
    end
    
    return 100
end

-- 装备盾牌
function FRD:EquipDisk(bag, slot)
    PickupContainerItem(bag, slot)
    PickupInventoryItem(17) -- 副手槽位
end

-- 开始自动检测
function FRD:StartAutoCheck()
    self.timeSinceLastCheck = 0
    self:SetScript("OnUpdate", function(elapsed)
        FRD.timeSinceLastCheck = FRD.timeSinceLastCheck + arg1
        if FRD.timeSinceLastCheck >= FRD_Settings.checkInterval then
            FRD.timeSinceLastCheck = 0
            FRD:CheckAndSwapDisk(true) -- 静默模式，不输出聊天信息
        end
    end)
end

-- 停止自动检测
function FRD:StopAutoCheck()
    self:SetScript("OnUpdate", nil)
end

-- 主要检测和切换逻辑
function FRD:CheckAndSwapDisk(silent)
    if not FRD_Settings.enabled then
        if not silent then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 插件已停用，右键小地图图标可重新启用")
        end
        return
    end

    -- 检查副手是否装备力反馈盾牌
    if not self:IsOffhandForceReactiveDisk() then
        -- 副手没有装备力反馈盾牌，寻找背包中的盾牌
        local disks = self:FindAllDisksInBags()
        if table.getn(disks) > 0 then
            -- 按耐久度排序，选择耐久度最高的
            table.sort(disks, function(a, b) return a.durability > b.durability end)
            -- 只有当耐久度最高的盾牌还有耐久时才装备
            if disks[1].durability > 0 then
                self:EquipDisk(disks[1].bag, disks[1].slot)
                if not silent then
                    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 已装备力反馈盾牌 (耐久度 " .. string.format("%.1f", disks[1].durability) .. "%)")
                end
            else
                -- 所有力反馈盾牌都已损坏，尝试装备备用盾牌
                if not self:TryEquipBackupShieldWhenAllDisksBroken(silent, false, 0, disks) then
                    if not silent then
                        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FRD]|r 所有力反馈盾牌都已损坏，且没有备用盾牌!")
                    end
                end
            end
        else
            if not silent then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FRD]|r 背包中没有找到力反馈盾牌!")
            end
        end
        return
    end
    
    -- 副手已装备力反馈盾牌,检查耐久度
    local currentDurability = self:GetOffhandDurability()
    local threshold = FRD_Settings.durabilityThreshold or 30
    local disks = self:FindAllDisksInBags()
    local bagCount = table.getn(disks)

    if bagCount > 0 then
        table.sort(disks, function(a, b) return a.durability > b.durability end)
    end

    local bestDisk = bagCount > 0 and disks[1] or nil
    local bestDurability = bestDisk and bestDisk.durability or 0
    local maxDurability = currentDurability
    if bestDurability > maxDurability then
        maxDurability = bestDurability
    end
    local allBelowThreshold = (currentDurability < threshold) and (bestDurability < threshold) -- 只有当所有盾牌都低于阈值时才启用2%紧急逻辑

    -- 所有盾牌都低于2%时，一次性提醒并按残余耐久依次用尽
    if allBelowThreshold and maxDurability <= 2 then
        if not self.warnedAllBelowTwo then
            UIErrorsFrame:AddMessage("|cffff0000[FRD]|r 所有力反馈盾牌耐久低于2%，即将损毁!", 1, 0.2, 0.2, 1)
            if not silent then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FRD]|r 所有力反馈盾牌耐久低于2%，即将损毁!")
            end
            self.warnedAllBelowTwo = true
        end

        if currentDurability <= 0 then
            -- 尝试装备备用盾牌
            if self:TryEquipBackupShieldWhenAllDisksBroken(silent, true, currentDurability, disks) then
                return
            end
            -- 没有备用盾牌，切换到剩余耐久最高的力反馈盾牌
            if bestDisk and bestDurability > currentDurability then
                self:EquipDisk(bestDisk.bag, bestDisk.slot)
                if not silent then
                    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FRD]|r 当前盾牌耐久已为0，强制切换到剩余耐久最高的盾牌 (" .. string.format("%.1f", bestDurability) .. "%)")
                end
            end
        end
        return
    else
        self.warnedAllBelowTwo = false
    end

    if currentDurability < threshold then

        -- 所有盾牌都低于阈值时，使用“低于2%再切”的紧急逻辑
        if allBelowThreshold then
            if currentDurability <= 2 then
                -- 尝试装备备用盾牌
                if self:TryEquipBackupShieldWhenAllDisksBroken(silent, true, currentDurability, disks) then
                    return
                end
                -- 没有备用盾牌，切换到剩余耐久最高的力反馈盾牌
                if bestDisk and bestDurability > currentDurability then
                    self:EquipDisk(bestDisk.bag, bestDisk.slot)
                    if not silent then
                        DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 所有盾牌耐久都低于阈值，当前耐久低于2%，强制切换至剩余耐久最高盾牌 (" .. string.format("%.1f", bestDurability) .. "%)")
                    end
                end
            elseif bagCount == 0 and not silent then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 当前盾牌耐久度 " .. string.format("%.1f", currentDurability) .. "%, 背包中没有备用盾牌")
            end
            return
        end

        -- 仍有盾牌高于阈值，立即切换到最佳盾牌
        if bestDisk and bestDurability > currentDurability then
            self:EquipDisk(bestDisk.bag, bestDisk.slot)
            if not silent then
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 已切换盾牌(" .. string.format("%.1f", currentDurability) .. "% -> " .. string.format("%.1f", bestDurability) .. "%)")
            end
        else
            if not silent then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 当前盾牌耐久度 " .. string.format("%.1f", currentDurability) .. "%, 背包中没有更好的盾牌")
            end
        end
    end
end

-- 创建小地图按钮
function FRD:CreateMinimapButton()
    local button = CreateFrame("Button", "FRDMinimapButton", Minimap)
    button:SetWidth(32)
    button:SetHeight(32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8) -- 确保位于更高层级
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52, -52)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    -- 先注册点击，再注册拖拽
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    local icon = button:CreateTexture("FRDMinimapIcon", "BACKGROUND")
    icon:SetWidth(26)
    icon:SetHeight(26)
    icon:SetPoint("CENTER", 0, 1)
    icon:SetTexture("Interface\\Icons\\Spell_Arcane_PortalDarnassus")        -- 使用力反馈盾牌对应的法术图标
    button.icon = icon

    local disabledOverlay = button:CreateTexture("FRDMinimapDisabledOverlay", "ARTWORK")
    disabledOverlay:SetWidth(32)
    disabledOverlay:SetHeight(32)
    disabledOverlay:SetPoint("CENTER", button, "CENTER", 0, 0)
    disabledOverlay:SetTexture("Interface\\Common\\CancelRed")
    disabledOverlay:SetBlendMode("ADD")
    disabledOverlay:Hide()
    button.disabledOverlay = disabledOverlay
    
    button:SetScript("OnClick", function()
        if arg1 == "LeftButton" then
            FRDSettingsFrame:Show()
        elseif arg1 == "RightButton" then
            FRD_Settings.enabled = not FRD_Settings.enabled
            if FRD_Settings.enabled then
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 插件已启用")
                FRD:UpdateMonitorVisibility(true)
                if FRD_Settings.autoMode and FRD.inCombat then
                    FRD:StartAutoCheck()
                end
                -- 刚启用时立即检查修理提醒
                FRD:CheckRepairReminder()
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 插件已停用")
                FRD:StopAutoCheck()
                FRD:UpdateMonitorVisibility(true)
                FRD:HideRepairReminder()
            end
            FRD:UpdateMinimapIconState()
        end
    end)
    
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_LEFT")
        GameTooltip:AddLine("力反馈盾牌管理")
        GameTooltip:AddLine("左键: 打开设置", 1, 1, 1)
        GameTooltip:AddLine("右键: 启用/停用插件", 1, 1, 1)
        if FRD_Settings.autoMode then
            GameTooltip:AddLine("|cff00ff00主动模式: 已启用|r", 0.5, 1, 0.5)
        else
            GameTooltip:AddLine("|cff888888主动模式: 未启用|r", 0.5, 0.5, 0.5)
        end
        if FRD_Settings.enabled then
            GameTooltip:AddLine("|cff00ff00插件状态: 已启用|r", 0.5, 1, 0.5)
        else
            GameTooltip:AddLine("|cffff0000插件状态: 已停用|r", 1, 0.3, 0.3)
        end
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- 拖拽脚本
    button:SetScript("OnDragStart", function()
        this:SetScript("OnUpdate", FRD.MinimapButton_OnUpdate)
    end)
    button:SetScript("OnDragStop", function()
        this:SetScript("OnUpdate", nil)
    end)

    self.minimapButton = button

    -- 延迟更新位置和状态，确保界面加载完毕
    self:ScheduleTimer(function()
        FRD:UpdateMinimapButtonPosition()
        FRD:UpdateMinimapIconState()
    end, 0.5)
end

-- 简单的延迟执行函数
function FRD:ScheduleTimer(func, delay)
    local frame = CreateFrame("Frame")
    local elapsed = 0
    frame:SetScript("OnUpdate", function()
        elapsed = elapsed + arg1
        if elapsed >= delay then
            func()
            frame:SetScript("OnUpdate", nil)
        end
    end)
end

-- 小地图按钮拖拽更新
function FRD.MinimapButton_OnUpdate()
    local mx, my = Minimap:GetCenter()
    local px, py = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    px, py = px / scale, py / scale
    
    local angle = math.deg(math.atan2(py - my, px - mx))
    FRD_Settings.minimap.angle = angle
    
    FRD:UpdateMinimapButtonPosition()
end

-- 更新小地图按钮位置
function FRD:UpdateMinimapButtonPosition()
    local angle = math.rad(FRD_Settings.minimap.angle or 0)
    local x = 80 * math.cos(angle)
    local y = 80 * math.sin(angle)
    self.minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- 更新小地图图标状态（启用/禁用时高亮或变暗）
function FRD:UpdateMinimapIconState()
    if not self.minimapButton then
        return
    end
    local icon = self.minimapButton.icon
    local offOverlay = self.minimapButton.disabledOverlay
    if not icon then return end

    if FRD_Settings.enabled then
        icon:SetDesaturated(false)
        icon:SetVertexColor(1, 1, 1, 1)
        if offOverlay then offOverlay:Hide() end
    else
        icon:SetDesaturated(true)
        icon:SetVertexColor(0.4, 0.4, 0.4, 0.8)
        if offOverlay then offOverlay:Show() end
    end
end

-- 创建设置界面
function FRD:CreateSettingsFrame()
    local frame = CreateFrame("Frame", "FRDSettingsFrame", UIParent)
    frame:SetWidth(350)
    frame:SetHeight(600)  -- 压缩高度，让界面更紧凑
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() this:StartMoving() end)
    frame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
    frame:SetScript("OnShow", function()
        -- 每次打开设置窗口时，重新加载备用盾牌配置
        FRD:ResetBackupShieldPendingFromSettings()
    end)
    frame:Hide()
    
    -- 标题
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -15)
    title:SetText("力反馈盾牌管理设置 v" .. FRD_VERSION)

    -- 耐久度阈值标签
    local label1 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label1:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -45)
    label1:SetText("切换耐久度阈值 (%):")

    -- 耐久度滑块
    local slider1 = CreateFrame("Slider", "FRDDurabilitySlider", frame, "OptionsSliderTemplate")
    slider1:SetPoint("TOP", frame, "TOPRIGHT", -100, -50)
    slider1:SetMinMaxValues(10, 90)
    slider1:SetValueStep(5)
    slider1:SetValue(FRD_Settings.durabilityThreshold)
    slider1:SetWidth(150)
    getglobal(slider1:GetName() .. "Low"):SetText("10%")
    getglobal(slider1:GetName() .. "High"):SetText("90%")
    getglobal(slider1:GetName() .. "Text"):SetText(FRD_Settings.durabilityThreshold .. "%")
    
    slider1:SetScript("OnValueChanged", function()
        local newValue = this:GetValue()
        getglobal(this:GetName() .. "Text"):SetText(newValue .. "%")
    end)
    
    -- 主动模式复选框
    local autoCheckbox = CreateFrame("CheckButton", "FRDAutoModeCheckbox", frame, "UICheckButtonTemplate")
    autoCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -95)
    autoCheckbox:SetWidth(24)
    autoCheckbox:SetHeight(24)
    autoCheckbox:SetChecked(FRD_Settings.autoMode)

    local autoLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoLabel:SetPoint("LEFT", autoCheckbox, "RIGHT", 5, 0)
    autoLabel:SetText("启用主动检测模式（战斗中自动检测）")

    autoCheckbox:SetScript("OnClick", function()
        -- 复选框点击时不立即保存，等待确认按钮
    end)

    -- 检测频率标签
    local label2 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label2:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -130)
    label2:SetText("检测频率 (秒):")

    -- 检测频率滑块
    local slider2 = CreateFrame("Slider", "FRDIntervalSlider", frame, "OptionsSliderTemplate")
    slider2:SetPoint("TOP", frame, "TOPRIGHT", -100, -135)
    slider2:SetMinMaxValues(0.1, 10)
    slider2:SetValueStep(0.1)
    slider2:SetWidth(150)
    getglobal(slider2:GetName() .. "Low"):SetText("0.1秒")
    getglobal(slider2:GetName() .. "High"):SetText("10秒")
    
    -- 确保值在有效范围内
    local intervalValue = FRD_Settings.checkInterval or 2.0
    if intervalValue < 0.1 then intervalValue = 0.1 end
    if intervalValue > 10 then intervalValue = 10 end
    
    slider2:SetValue(intervalValue)
    getglobal(slider2:GetName() .. "Text"):SetText(string.format("%.1f秒", intervalValue))
    
    slider2:SetScript("OnValueChanged", function()
        local newValue = this:GetValue()
        getglobal(this:GetName() .. "Text"):SetText(string.format("%.1f秒", newValue))
    end)

    -- 耐久监控复选框
    local monitorCheckbox = CreateFrame("CheckButton", "FRDMonitorCheckbox", frame, "UICheckButtonTemplate")
    monitorCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -170)
    monitorCheckbox:SetWidth(24)
    monitorCheckbox:SetHeight(24)
    monitorCheckbox:SetChecked(FRD_Settings.monitorEnabled)

    local monitorLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    monitorLabel:SetPoint("LEFT", monitorCheckbox, "RIGHT", 5, 0)
    monitorLabel:SetText("启用战斗耐久监控（显示小窗）")

    -- 监控刷新频率标签
    local label3 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label3:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -200)
    label3:SetText("监控刷新频率 (秒):")

    -- 监控刷新频率滑块
    local slider3 = CreateFrame("Slider", "FRDMonitorIntervalSlider", frame, "OptionsSliderTemplate")
    slider3:SetPoint("TOP", frame, "TOPRIGHT", -100, -205)
    slider3:SetMinMaxValues(0.1, 2.0)
    slider3:SetValueStep(0.1)
    slider3:SetWidth(150)
    getglobal(slider3:GetName() .. "Low"):SetText("0.1秒")
    getglobal(slider3:GetName() .. "High"):SetText("2.0秒")

    local monitorIntervalValue = FRD_Settings.monitorInterval or 0.5
    if monitorIntervalValue < 0.1 then monitorIntervalValue = 0.1 end
    if monitorIntervalValue > 2.0 then monitorIntervalValue = 2.0 end

    slider3:SetValue(monitorIntervalValue)
    getglobal(slider3:GetName() .. "Text"):SetText(string.format("%.1f秒", monitorIntervalValue))

    slider3:SetScript("OnValueChanged", function()
        local newValue = this:GetValue()
        getglobal(this:GetName() .. "Text"):SetText(string.format("%.1f秒", newValue))
    end)
    
    -- 保存设置的临时变量
    frame.tempSettings = {
        durabilityThreshold = FRD_Settings.durabilityThreshold,
        autoMode = FRD_Settings.autoMode,
        checkInterval = intervalValue,
        monitorEnabled = FRD_Settings.monitorEnabled,
        monitorInterval = monitorIntervalValue,
        monitorShowOOC = FRD_Settings.monitorShowOOC,
        repairReminderEnabled = FRD_Settings.repairReminderEnabled
    }

    -- 脱战也显示监控复选框
    local monitorOOCCheckbox = CreateFrame("CheckButton", "FRDMonitorOOCCheckbox", frame, "UICheckButtonTemplate")
    monitorOOCCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -235)
    monitorOOCCheckbox:SetWidth(24)
    monitorOOCCheckbox:SetHeight(24)
    monitorOOCCheckbox:SetChecked(FRD_Settings.monitorShowOOC)

    local monitorOOCLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    monitorOOCLabel:SetPoint("LEFT", monitorOOCCheckbox, "RIGHT", 5, 0)
    monitorOOCLabel:SetText("脱战也显示盾牌耐久监控")

    -- 脱战低耐久修理提醒复选框
    local repairCheckbox = CreateFrame("CheckButton", "FRDRepairCheckbox", frame, "UICheckButtonTemplate")
    repairCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -265)
    repairCheckbox:SetWidth(24)
    repairCheckbox:SetHeight(24)
    repairCheckbox:SetChecked(FRD_Settings.repairReminderEnabled)

    local repairLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    repairLabel:SetPoint("LEFT", repairCheckbox, "RIGHT", 5, 0)
    repairLabel:SetText("脱战后若盾牌低于90%提醒修理")

    -- 脱战自动装备银色黎明徽记
    local argentCheckbox = CreateFrame("CheckButton", "FRDAutoEquipArgentDawnCheckbox", frame, "UICheckButtonTemplate")
    argentCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -290)
    argentCheckbox:SetWidth(24)
    argentCheckbox:SetHeight(24)
    argentCheckbox:SetChecked(FRD_Settings.autoEquipArgentDawn)

    local argentLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    argentLabel:SetPoint("LEFT", argentCheckbox, "RIGHT", 5, 0)
    argentLabel:SetWidth(260)
    argentLabel:SetJustifyH("LEFT")
    argentLabel:SetText("脱战后自动装备银色黎明徽记")

    -- 脱战后自动恢复原饰品
    local argentRestoreCheckbox = CreateFrame("CheckButton", "FRDAutoEquipArgentDawnRestoreCheckbox", frame, "UICheckButtonTemplate")
    argentRestoreCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 48, -315)
    argentRestoreCheckbox:SetWidth(24)
    argentRestoreCheckbox:SetHeight(24)
    argentRestoreCheckbox:SetChecked(FRD_Settings.autoEquipArgentDawnRestoreEnabled)

    local argentRestoreLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    argentRestoreLabel:SetPoint("LEFT", argentRestoreCheckbox, "RIGHT", 5, 0)
    argentRestoreLabel:SetWidth(235)
    argentRestoreLabel:SetJustifyH("LEFT")
    argentRestoreLabel:SetText("脱战后自动恢复原饰品")

    local argentDelayLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    argentDelayLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 48, -340)
    argentDelayLabel:SetWidth(200)
    argentDelayLabel:SetJustifyH("LEFT")
    argentDelayLabel:SetText("恢复延迟(秒):")

    local argentDelaySlider = CreateFrame("Slider", "FRDAutoEquipArgentDawnDelaySlider", frame, "OptionsSliderTemplate")
    argentDelaySlider:SetPoint("TOP", frame, "TOPRIGHT", -100, -345)
    argentDelaySlider:SetMinMaxValues(30, 180)
    argentDelaySlider:SetValueStep(5)
    argentDelaySlider:SetWidth(150)
    getglobal(argentDelaySlider:GetName() .. "Low"):SetText("30")
    getglobal(argentDelaySlider:GetName() .. "High"):SetText("180")

    local argentDelayValue = FRD_Settings.autoEquipArgentDawnRestoreDelay or 60
    if argentDelayValue < 30 then argentDelayValue = 30 end
    if argentDelayValue > 180 then argentDelayValue = 180 end
    argentDelaySlider:SetValue(argentDelayValue)
    getglobal(argentDelaySlider:GetName() .. "Text"):SetText(string.format("%d秒", argentDelayValue))

    argentDelaySlider:SetScript("OnValueChanged", function()
        local newValue = this:GetValue()
        getglobal(this:GetName() .. "Text"):SetText(string.format("%d秒", newValue))
    end)
    
    -- 备用盾牌模块
    local backupPanel = CreateFrame("Frame", "FRDBackupShieldPanel", frame)
    backupPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -375)
    backupPanel:SetWidth(310)
    backupPanel:SetHeight(80)  -- 压缩高度
    backupPanel:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    backupPanel:SetBackdropColor(0, 0, 0, 0.35)

    local backupTitle = backupPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    backupTitle:SetPoint("TOPLEFT", backupPanel, "TOPLEFT", 10, -6)
    backupTitle:SetText("备用盾牌设置（所有力反馈盾牌耗尽时自动装备）")

    -- 备用盾牌开关
    local backupCheckbox = CreateFrame("CheckButton", "FRDBackupShieldCheckbox", backupPanel, "UICheckButtonTemplate")
    backupCheckbox:SetPoint("TOPLEFT", backupPanel, "TOPLEFT", 10, -24)
    backupCheckbox:SetWidth(24)
    backupCheckbox:SetHeight(24)
    backupCheckbox:SetChecked(FRD_Settings.backupShieldEnabled)

    local backupCheckboxLabel = backupPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    backupCheckboxLabel:SetPoint("LEFT", backupCheckbox, "RIGHT", 5, 0)
    backupCheckboxLabel:SetText("启用备用盾牌功能")

    -- 备用盾牌选择按钮
    local backupButton = CreateFrame("Button", "FRDBackupShieldButton", backupPanel)
    backupButton:SetPoint("TOPLEFT", backupPanel, "TOPLEFT", 10, -44)
    backupButton:SetWidth(28)
    backupButton:SetHeight(28)

    -- 边框纹理（BACKGROUND层级，作为背景）
    local border = backupButton:CreateTexture(nil, "BACKGROUND")
    border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    border:SetAllPoints(backupButton)

    backupButton:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
    backupButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    backupButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    backupButton:RegisterForDrag("LeftButton")

    -- 物品图标（ARTWORK层级，位于边框上方）
    local backupIcon = backupButton:CreateTexture(nil, "ARTWORK")
    backupIcon:SetWidth(28)
    backupIcon:SetHeight(28)
    backupIcon:SetPoint("CENTER", backupButton, "CENTER", 0, 0)
    backupButton.icon = backupIcon

    backupButton:SetScript("OnReceiveDrag", function()
        FRD:TrySetBackupShieldFromCursor()
    end)
    backupButton:SetScript("OnClick", function()
        local mouseBtn = arg1
        if mouseBtn == "RightButton" then
            FRD:ClearBackupShieldPending()
            return
        end
        local itemId = FRD:GetCursorItemInfo()
        if itemId then
            FRD:TrySetBackupShieldFromCursor()
        else
            FRD:TrySetBackupShieldFromOffhand()
        end
    end)
    backupButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:AddLine("备用盾牌设置", 1, 1, 1)
        GameTooltip:AddLine("左键: 使用当前副手", 0.9, 0.9, 0.9)
        GameTooltip:AddLine("拖拽: 从背包选择盾牌", 0.9, 0.9, 0.9)
        GameTooltip:AddLine("右键: 清除设置", 0.9, 0.9, 0.9)
        GameTooltip:Show()
    end)
    backupButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local backupName = backupPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    backupName:SetPoint("LEFT", backupButton, "RIGHT", 8, 0)
    backupName:SetWidth(210)
    backupName:SetJustifyH("LEFT")
    backupName:SetText("未设置")

    frame.backupShieldButton = backupButton
    frame.backupShieldName = backupName
    frame.backupShieldCheckbox = backupCheckbox

    -- 初始化备用盾牌显示
    FRD:ResetBackupShieldPendingFromSettings()

    -- 斯坦索姆自动确认拾取复选框
    local autoConfirmLootCheckbox = CreateFrame("CheckButton", "FRDAutoConfirmLootCheckbox", frame, "UICheckButtonTemplate")
    autoConfirmLootCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -465)  -- 调整位置
    autoConfirmLootCheckbox:SetWidth(24)
    autoConfirmLootCheckbox:SetHeight(24)
    autoConfirmLootCheckbox:SetChecked(FRD_Settings.autoConfirmLootInStratholme)

    local autoConfirmLootLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoConfirmLootLabel:SetPoint("LEFT", autoConfirmLootCheckbox, "RIGHT", 5, 0)
    autoConfirmLootLabel:SetWidth(260)
    autoConfirmLootLabel:SetJustifyH("LEFT")
    autoConfirmLootLabel:SetText("自动确认拾取绑定物品（包括天灾石、缝合线等）")

    -- 确认按钮
    local confirmButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    confirmButton:SetPoint("BOTTOM", frame, "BOTTOM", -55, 20)
    confirmButton:SetWidth(100)
    confirmButton:SetHeight(25)
    confirmButton:SetText("确认")
    confirmButton:SetScript("OnClick", function()
        -- 保存设置
        FRD_Settings.durabilityThreshold = slider1:GetValue()
        FRD_Settings.autoMode = autoCheckbox:GetChecked() == 1
        FRD_Settings.checkInterval = slider2:GetValue()
        FRD_Settings.monitorEnabled = monitorCheckbox:GetChecked() == 1
        FRD_Settings.monitorInterval = slider3:GetValue()
        FRD_Settings.monitorShowOOC = monitorOOCCheckbox:GetChecked() == 1
        FRD_Settings.repairReminderEnabled = repairCheckbox:GetChecked() == 1
        FRD_Settings.autoEquipArgentDawn = argentCheckbox:GetChecked() == 1
        FRD_Settings.autoEquipArgentDawnRestoreEnabled = argentRestoreCheckbox:GetChecked() == 1
        FRD_Settings.autoEquipArgentDawnRestoreDelay = argentDelaySlider:GetValue()
        FRD_Settings.backupShieldEnabled = frame.backupShieldCheckbox:GetChecked() == 1
        FRD_Settings.autoConfirmLootInStratholme = autoConfirmLootCheckbox:GetChecked() == 1
        FRD:ApplyBackupShieldPendingToSettings()
        if not FRD_Settings.autoEquipArgentDawnRestoreEnabled then
            FRD:ClearArgentDawnRestoreTarget()
        end
        
        -- 如果主动模式状态改变，更新检测状态
        if FRD_Settings.autoMode and FRD.inCombat then
            FRD:StartAutoCheck()
        elseif not FRD_Settings.autoMode then
            FRD:StopAutoCheck()
        end

        FRD:UpdateMonitorVisibility(true)
        
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 设置已保存")
        frame:Hide()
    end)
    
    -- 关闭按钮
    local closeButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    closeButton:SetPoint("BOTTOM", frame, "BOTTOM", 55, 20)
    closeButton:SetWidth(100)
    closeButton:SetHeight(25)
    closeButton:SetText("取消")
    closeButton:SetScript("OnClick", function()
        -- 恢复原始设置
        slider1:SetValue(FRD_Settings.durabilityThreshold)
        autoCheckbox:SetChecked(FRD_Settings.autoMode)
        slider2:SetValue(FRD_Settings.checkInterval)
        monitorCheckbox:SetChecked(FRD_Settings.monitorEnabled)
        slider3:SetValue(FRD_Settings.monitorInterval or 0.5)
        monitorOOCCheckbox:SetChecked(FRD_Settings.monitorShowOOC)
        repairCheckbox:SetChecked(FRD_Settings.repairReminderEnabled)
        argentCheckbox:SetChecked(FRD_Settings.autoEquipArgentDawn)
        argentRestoreCheckbox:SetChecked(FRD_Settings.autoEquipArgentDawnRestoreEnabled)
        argentDelaySlider:SetValue(FRD_Settings.autoEquipArgentDawnRestoreDelay or 60)
        backupCheckbox:SetChecked(FRD_Settings.backupShieldEnabled)
        autoConfirmLootCheckbox:SetChecked(FRD_Settings.autoConfirmLootInStratholme)
        -- 重新加载备用盾牌显示
        FRD:ResetBackupShieldPendingFromSettings()
        frame:Hide()
    end)

    -- 帮助按钮
    local helpButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    helpButton:SetPoint("BOTTOM", frame, "BOTTOM", 60, 60)
    helpButton:SetWidth(100)
    helpButton:SetHeight(22)
    helpButton:SetText("帮助")

    -- 重置位置按钮（与帮助同一行）
    local resetPosButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    resetPosButton:SetPoint("BOTTOM", frame, "BOTTOM", -60, 60)
    resetPosButton:SetWidth(120)
    resetPosButton:SetHeight(22)
    resetPosButton:SetText("重置窗口位置")
    resetPosButton:SetScript("OnClick", function()
        FRD:ResetFramePositions()
    end)

    -- 帮助内容框
    local helpFrame = CreateFrame("Frame", "FRDHelpFrame", frame)
    helpFrame:SetWidth(380)
    helpFrame:SetHeight(480)
    -- 将帮助窗口放在设置框右侧，避免遮挡功能区
    helpFrame:ClearAllPoints()
    helpFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 12, 0)
    helpFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    helpFrame:Hide()

    local helpTitle = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    helpTitle:SetPoint("TOP", helpFrame, "TOP", 0, -18)
    helpTitle:SetText("帮助信息")

    local helpText = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    helpText:SetPoint("TOPLEFT", helpFrame, "TOPLEFT", 16, -46)
    helpText:SetWidth(340)
    helpText:SetJustifyH("LEFT")
    helpText:SetText(table.concat({
        "插件功能简介",
        "· 自动切换力反馈盾牌（需背包有多块）；单块仅监控，不自动切换。",
        "· 勾选主动模式：战斗中自动检测并切换盾牌。",
        "· 如果不希望主动侦测，或者自动模式遇到使用问题，可将 /frd 绑定技能宏触发检测。",
        "· 小地图图标：右键可切换插件开关。",
        "· 自动确认拾取：自动确认拾取绑定物品，包括天灾石、缝合线等特殊物品。",
        "",
        "· 作者：安娜希尔",
        "",
        "设置建议",
        "· 阈值：建议 15%。",
        "· 刷新频率：建议 0.4 秒。",
        "",
        "命令使用说明",
        "· /frd on            启用插件",
        "· /frd off           停用插件",
        "· /frd               被动模式：按逻辑检测并切换，可绑定宏",
        "· /frd config        打开设置界面",
        "· /frd reset         重置监控与修理提醒位置",
        "· /frd status        显示副手状态与背包盾牌数量",
        "· /frd monitor|mon   切换战斗耐久监控开/关",
        "· /frd monitor on|off   显式打开/关闭监控",
        "· /frd monitor interval <秒>  (0.1–2.0) 设置刷新频率",
        "· /frd monitor ooc   切换脱战显示监控"
    }, "\n"))

    local helpClose = CreateFrame("Button", nil, helpFrame, "GameMenuButtonTemplate")
    helpClose:SetPoint("BOTTOM", helpFrame, "BOTTOM", 0, 16)
    helpClose:SetWidth(90)
    helpClose:SetHeight(22)
    helpClose:SetText("关闭")
    helpClose:SetScript("OnClick", function()
        helpFrame:Hide()
    end)

    helpButton:SetScript("OnClick", function()
        if helpFrame:IsShown() then
            helpFrame:Hide()
        else
            helpFrame:Show()
        end
    end)
    
    self.settingsFrame = frame
end

-- 注册斜杠命令
function FRD:RegisterSlashCommands()
    SLASH_FRD1 = "/frd"
    SLASH_FRD2 = "/forcedisk"
    SlashCmdList["FRD"] = function(msg)
        msg = msg or ""
        local lowerMsg = string.lower(msg)
        if msg == "check" or msg == "" then
            FRD:CheckAndSwapDisk()
        elseif msg == "config" or msg == "settings" then
            FRDSettingsFrame:Show()
        elseif lowerMsg == "on" then
            FRD_Settings.enabled = true
            FRD:UpdateMonitorVisibility(true)
            FRD:UpdateMinimapIconState()
            if FRD_Settings.autoMode and FRD.inCombat then
                FRD:StartAutoCheck()
            end
            FRD:CheckRepairReminder()
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 插件已启用")
        elseif lowerMsg == "off" then
            FRD_Settings.enabled = false
            FRD:StopAutoCheck()
            FRD:UpdateMonitorVisibility(true)
            FRD:HideRepairReminder()
            FRD:UpdateMinimapIconState()
            DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 插件已停用")
        elseif lowerMsg == "help" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 命令清单：")
            DEFAULT_CHAT_FRAME:AddMessage("/frd 或 /frd check - 检测并切换盾牌（被动模式，可绑定宏）")
            DEFAULT_CHAT_FRAME:AddMessage("/frd on / off - 启用/停用插件")
            DEFAULT_CHAT_FRAME:AddMessage("/frd config - 打开设置界面")
            DEFAULT_CHAT_FRAME:AddMessage("/frd reset - 重置监控和修理提醒位置")
            DEFAULT_CHAT_FRAME:AddMessage("/frd status - 显示副手状态与背包盾牌数量")
            DEFAULT_CHAT_FRAME:AddMessage("/frd monitor (mon) - 切换战斗耐久监控")
            DEFAULT_CHAT_FRAME:AddMessage("/frd monitor on|off - 显式开关监控")
            DEFAULT_CHAT_FRAME:AddMessage("/frd monitor interval <0.1-2.0> - 设置监控刷新频率")
            DEFAULT_CHAT_FRAME:AddMessage("/frd monitor ooc - 切换脱战显示监控")
        elseif msg == "reset" or msg == "resetpos" then
            FRD:ResetFramePositions()
        elseif msg == "status" then
            local isEquipped = FRD:IsOffhandForceReactiveDisk()
            if isEquipped then
                local durability = FRD:GetOffhandDurability()
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 副手已装备力反馈盾牌, 耐久度: " .. string.format("%.1f", durability) .. "%")
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 副手未装备力反馈盾牌")
            end
            local disks = FRD:FindAllDisksInBags()
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 背包中找到 " .. table.getn(disks) .. " 个力反馈盾牌")
        elseif lowerMsg == "monitor" or lowerMsg == "mon" then
            FRD_Settings.monitorEnabled = not FRD_Settings.monitorEnabled
            FRD:UpdateMonitorVisibility(true)
            if FRD_Settings.monitorEnabled then
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 战斗耐久监控: 已启用")
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 战斗耐久监控: 已关闭")
            end
        elseif string.find(lowerMsg, "^monitor%s+") or string.find(lowerMsg, "^mon%s+") then
            local _, _, cmd, action = string.find(lowerMsg, "^(monitor|mon)%s+(%S+)")
            if action == "on" then
                FRD_Settings.monitorEnabled = true
                FRD:UpdateMonitorVisibility(true)
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 战斗耐久监控: 已启用")
            elseif action == "off" then
                FRD_Settings.monitorEnabled = false
                FRD:UpdateMonitorVisibility(true)
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 战斗耐久监控: 已关闭")
            elseif action == "interval" and cmd and cmd ~= "" then
                local _, _, _, num = string.find(lowerMsg, "^(monitor|mon)%s+interval%s+(%d+%.?%d*)")
                local sec = tonumber(num)
                if sec then
                    if sec < 0.1 then sec = 0.1 end
                    if sec > 2.0 then sec = 2.0 end
                    FRD_Settings.monitorInterval = sec
                    FRD:UpdateMonitorVisibility(true)
                    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 监控刷新频率: " .. string.format("%.1f", sec) .. " 秒")
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 用法: /frd monitor interval 0.5")
                end
            elseif action == "ooc" then
                FRD_Settings.monitorShowOOC = not FRD_Settings.monitorShowOOC
                FRD:UpdateMonitorVisibility(true)
                if FRD_Settings.monitorShowOOC then
                    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 脱战也显示监控: 已启用")
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 脱战也显示监控: 已关闭")
                end
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 用法: /frd monitor  (切换开关)")
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 用法: /frd monitor on/off")
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 用法: /frd monitor interval 0.5")
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 用法: /frd monitor ooc  (脱战显示开关)")
            end
        elseif lowerMsg == "loot" then
            FRD_Settings.autoConfirmLootInStratholme = not FRD_Settings.autoConfirmLootInStratholme
            if FRD_Settings.autoConfirmLootInStratholme then
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[FRD]|r 自动确认拾取绑定物品: 已启用")
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff9900[FRD]|r 自动确认拾取绑定物品: 已关闭")
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00力反馈盾牌管理插件命令:|r")
            DEFAULT_CHAT_FRAME:AddMessage("/frd 或 /frd check - 检测并切换盾牌")
            DEFAULT_CHAT_FRAME:AddMessage("/frd config - 打开设置界面")
            DEFAULT_CHAT_FRAME:AddMessage("/frd status - 显示当前状态")
            DEFAULT_CHAT_FRAME:AddMessage("/frd monitor - 切换战斗耐久监控")
            DEFAULT_CHAT_FRAME:AddMessage("/frd monitor ooc - 脱战也显示监控")
            DEFAULT_CHAT_FRAME:AddMessage("/frd loot - 切换自动确认拾取绑定物品")
        end
    end
end
