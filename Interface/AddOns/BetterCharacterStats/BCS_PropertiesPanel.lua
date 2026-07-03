-- BCS_PropertiesPanel.lua
-- 属性悬浮窗模块，集成到 BetterCharacterStats

local ADDON_NAME = "BetterCharacterStats"
local P = BCS.PropertiesPanel or {}
BCS.PropertiesPanel = P

-- 默认配置（包含位置、显示配置、开关、对齐方式和锁定状态）
local DEFAULT_CONFIG = {
    point = "CENTER",
    rel_point = "CENTER",
    x_offset = 350,
    y_offset = -100,
    displayConfig = "防御",
    enabled = false,          -- 悬浮窗默认显示
    align = "LEFT",          -- 对齐方式：LEFT/CENTER/RIGHT
    locked = false,          -- 是否锁定（锁定后点击穿透，不可拖动）
}

-- 悬浮窗框架
P.frame = CreateFrame("Frame", nil, UIParent)
P.frame:SetMovable(true)
P.frame:EnableMouse(true)
P.frame:SetWidth(140)
P.frame:SetHeight(90)
P.frame:SetAlpha(.90)
P.frame:SetPoint("CENTER", 350, -100)
P.frame:SetFrameStrata("LOW")

-- 标题行（第一行，大字体）
P.frame.title = P.frame:CreateFontString(nil, "ARTWORK")
P.frame.title:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")

-- 详细信息行（其余行，小字体）
P.frame.details = P.frame:CreateFontString(nil, "ARTWORK")
P.frame.details:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")

P.frame:RegisterForDrag("LeftButton")
P.frame:SetScript("OnDragStart", function()
    if P.locked then return end  -- 锁定时禁止拖动
    P.frame:StartMoving()
end)
P.frame:SetScript("OnDragStop", function()
    P.frame:StopMovingOrSizing()
    if P.locked then return end
    local point, _, rel_point, x_offset, y_offset = P.frame:GetPoint()
    if x_offset < 20 and x_offset > -20 then x_offset = 0 end

    -- 确保 BCSConfig.PropertiesPanel 存在
    if not BCSConfig.PropertiesPanel then
        BCSConfig.PropertiesPanel = {}
    end

    -- 保存位置
    BCSConfig.PropertiesPanel.point = point
    BCSConfig.PropertiesPanel.rel_point = rel_point
    BCSConfig.PropertiesPanel.x_offset = math.floor(x_offset)
    BCSConfig.PropertiesPanel.y_offset = math.floor(y_offset)
end)

P.frame:Hide()

-- 主配置窗口
P.mainFrame = CreateFrame("Frame", "BCSPropertiesPanelMainFrame", UIParent)
P.mainFrame:SetWidth(450)
P.mainFrame:SetHeight(120)
P.mainFrame:SetPoint("CENTER", 0, 0)
P.mainFrame:EnableMouse(true)
P.mainFrame:SetMovable(true)
P.mainFrame:RegisterForDrag("LeftButton")
P.mainFrame:SetScript("OnDragStart", function() P.mainFrame:StartMoving() end)
P.mainFrame:SetScript("OnDragStop", function() P.mainFrame:StopMovingOrSizing() end)

P.mainFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    tile = true,
    tileSize = 16,
})
P.mainFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
P.mainFrame:SetBackdropBorderColor(0.5, 0.5, 0.5)

local titleBg = P.mainFrame:CreateTexture(nil, "OVERLAY")
titleBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
titleBg:SetPoint("TOPLEFT", 4, -4)
titleBg:SetPoint("TOPRIGHT", -4, -4)
titleBg:SetHeight(24)
titleBg:SetVertexColor(0.2, 0.2, 0.2, 1)

local titleText = P.mainFrame:CreateFontString(nil, "OVERLAY")
titleText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
titleText:SetPoint("TOP", 0, -5)
titleText:SetText("属性面板")

local closeButton = CreateFrame("Button", nil, P.mainFrame)
closeButton:SetPoint("TOPRIGHT", -8, -8)
closeButton:SetWidth(16)
closeButton:SetHeight(16)

local closeTexture = closeButton:CreateTexture()
closeTexture:SetAllPoints()
closeTexture:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")

closeButton:SetScript("OnClick", function() P.mainFrame:Hide() end)
closeButton:SetScript("OnEnter", function() closeTexture:SetVertexColor(1, 0, 0) end)
closeButton:SetScript("OnLeave", function() closeTexture:SetVertexColor(1, 1, 1) end)

-- 帮助按钮
local helpButton = CreateFrame("Button", nil, P.mainFrame)
helpButton:SetPoint("RIGHT", closeButton, "LEFT", -5, 0)
helpButton:SetWidth(16)
helpButton:SetHeight(16)

helpButton:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    tile = true,
    tileSize = 16,
})
helpButton:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
helpButton:SetBackdropBorderColor(0, 0, 0, 1)

local helpText = helpButton:CreateFontString(nil, "OVERLAY")
helpText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
helpText:SetPoint("CENTER", 0, 0)
helpText:SetText("?")
helpText:SetTextColor(1, 0.82, 0)

helpButton:SetScript("OnClick", function()
    DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 用法：/mb 打开配置窗口，/mb off/hide 隐藏悬浮窗，/mb on/show 显示悬浮窗，/mb toggle/visible 切换显示，/mb align left/center/right 设置对齐方式，/mb lock/unlock/togglelock 锁定/解锁悬浮窗", 1, 1, 1)
end)

helpButton:SetScript("OnEnter", function()
    helpButton:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
    helpText:SetTextColor(1, 1, 1)
end)
helpButton:SetScript("OnLeave", function()
    helpButton:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
    helpText:SetTextColor(1, 0.82, 0)
end)

-- 创建按钮的辅助函数
local function CreateButton(text, parent, point, relativePoint, x, y, onClick)
    local button = CreateFrame("Button", nil, parent)
    button:SetWidth(60)
    button:SetHeight(22)
    button:SetPoint(point, relativePoint, x, y)

    button:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true,
        tileSize = 16,
    })
    button:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
    button:SetBackdropBorderColor(0, 0, 0, 1)

    local label = button:CreateFontString(nil, "OVERLAY")
    label:SetFont(STANDARD_TEXT_FONT, 12)
    label:SetPoint("CENTER", 0, 0)
    label:SetText(text)
    label:SetTextColor(1, 0.82, 0)
    button.label = label

    button:SetScript("OnClick", onClick)
    button:SetScript("OnEnter", function()
        button:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
    end)
    button:SetScript("OnLeave", function()
        button:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
    end)
    button:SetScript("OnMouseDown", function()
        label:SetPoint("CENTER", 1, -1)
    end)
    button:SetScript("OnMouseUp", function()
        label:SetPoint("CENTER", 0, 0)
    end)

    return button
end

-- 配置选择按钮
local buttonWidth = 55
local numButtons = 6
local totalButtonWidth = buttonWidth * numButtons
local spacing = (P.mainFrame:GetWidth() - totalButtonWidth) / (numButtons + 1)

local configTypes = {"物理", "法系", "治疗", "猎人", "混伤", "防御"}
for i = 1, numButtons do
    local x = -P.mainFrame:GetWidth() / 2 + spacing * i + buttonWidth * (i - 0.5)
    local buttonText = configTypes[i]

    CreateButton(buttonText, P.mainFrame, "CENTER", P.mainFrame, x, 15 - 20, function()
        P.displayConfig = buttonText
        -- 保存到统一配置表
        if not BCSConfig.PropertiesPanel then
            BCSConfig.PropertiesPanel = {}
        end
        BCSConfig.PropertiesPanel.displayConfig = P.displayConfig
        -- 更新悬浮窗显示
        if P.showWindow then
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
        end
        P.mainFrame:Hide()
    end)
end

-- 发送到输入框按钮
local inputButton = CreateButton("发送输入框", P.mainFrame, "BOTTOM", P.mainFrame, -80, 10, function()
    P:SendPropertiesToInput()
end)
inputButton:SetWidth(80)

-- 发送密语按钮
local whisperButton = CreateButton("发送密语", P.mainFrame, "BOTTOMRIGHT", P.mainFrame, -100, 10, function()
    P:SendPropertiesToWhisper()
end)
whisperButton:SetWidth(80)

-- 初始化位置和配置（由 ADDON_LOADED 事件调用）
function P:Init()
    -- 确保 BCSConfig.PropertiesPanel 存在
    if not BCSConfig.PropertiesPanel then
        BCSConfig.PropertiesPanel = {}
    end

    -- 合并默认配置，确保每个字段都有值
    local panel = BCSConfig.PropertiesPanel
    for k, v in pairs(DEFAULT_CONFIG) do
        if panel[k] == nil then
            panel[k] = v
        end
    end

    -- 设置悬浮窗位置
    local point = panel.point
    local rel_point = panel.rel_point
    local x = panel.x_offset
    local y = panel.y_offset
    self.frame:SetPoint(point, UIParent, rel_point, x, y)

    -- 设置显示配置到 P.displayConfig
    self.displayConfig = panel.displayConfig

    -- 设置对齐方式
    self.align = panel.align

    -- 设置锁定状态
    self.locked = panel.locked

    -- 设置显示状态
    self.showWindow = panel.enabled
    if not self.showWindow then
        self.frame:Hide()
    end
end

-- 更新悬浮窗显示（接收第一行和其余行）
function P:UpdateDisplay(show, firstLine, restLines)
    if show == 1 then
        self.frame.title:SetText(firstLine)
        self.frame.details:SetText(restLines)

        -- 根据锁定状态设置鼠标启用/禁用（锁定则禁用鼠标，实现点击穿透）
        self.frame:EnableMouse(not self.locked)

        -- 清除旧锚点，根据对齐方式重新设置
        self.frame.title:ClearAllPoints()
        self.frame.details:ClearAllPoints()

        local margin = 10  -- 左右边距
        local frameWidth = self.frame:GetWidth()

        if self.align == "LEFT" then
            self.frame.title:SetPoint("TOPLEFT", self.frame, "TOPLEFT", margin, -10)
            self.frame.details:SetPoint("TOPLEFT", self.frame, "TOPLEFT", margin, -30)
            self.frame.title:SetWidth(frameWidth - margin * 2)
            self.frame.details:SetWidth(frameWidth - margin * 2)
        elseif self.align == "RIGHT" then
            self.frame.title:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -margin, -10)
            self.frame.details:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -margin, -30)
            self.frame.title:SetWidth(frameWidth - margin * 2)
            self.frame.details:SetWidth(frameWidth - margin * 2)
        else -- CENTER
            self.frame.title:SetPoint("TOP", self.frame, "TOP", 0, -10)
            self.frame.details:SetPoint("TOP", self.frame, "TOP", 0, -30)
            self.frame.title:SetWidth(frameWidth - margin * 2)
            self.frame.details:SetWidth(frameWidth - margin * 2)
        end

        -- 设置对齐方式
        self.frame.title:SetJustifyH(self.align)
        self.frame.details:SetJustifyH(self.align)

        -- 根据当前职业设置标题颜色
        local _, class = UnitClass("player")
        local color = RAID_CLASS_COLORS[class]
        if color then
            self.frame.title:SetTextColor(color.r, color.g, color.b)
        else
            self.frame.title:SetTextColor(1, 1, 1)
        end

        self.frame:Show()
    else
        self.frame:Hide()
    end
end

-- 获取当前配置的显示字符串（返回第一行和其余行，用于悬浮窗）
function P:GetDisplayLines()
    local firstLine = ""
    local restLines = ""

    if self.displayConfig == "物理" then
        firstLine = self:DisplayAP()
        restLines = (self:DisplayHitRating() or "命中: 数据不可用") .. "\n" ..
                    (self:DisplayPhysicalCrit() or "暴击: 数据不可用") .. "\n" ..
                    (self:DisplayArmorPenetration() or "破甲: 数据不可用") .. "\n" ..
                    self:DisplayDualAttackSpeed()
    elseif self.displayConfig == "法系" then
        firstLine = self:DisplaySP() or "法强: 数据不可用"
        restLines = (self:DisplaySpellHitRating() or "法命: 数据不可用") .. "\n" ..
                    (self:DisplaySpellCrit() or "法爆: 数据不可用") .. "\n" ..
                    (self:DisplayManaRegen() or "回蓝: 数据不可用") .. "\n" ..
                    (self:DisplayHaste() or "急速: 数据不可用")
    elseif self.displayConfig == "治疗" then
        firstLine = self:DisplayHealingPower() or "治疗: 数据不可用"
        restLines = (self:DisplaySP() or "法强: 数据不可用") .. "\n" ..
                    (self:DisplaySpellCrit() or "法爆: 数据不可用") .. "\n" ..
                    (self:DisplayManaRegen() or "回蓝: 数据不可用") .. "\n" ..
                    (self:DisplayHaste() or "急速: 数据不可用")
    elseif self.displayConfig == "猎人" then
        firstLine = self:DisplayRAP()
        restLines = (self:DisplaySP() or "法强: 数据不可用") .. "\n" ..
                    (self:DisplayRangedHitRating() or "命中: 数据不可用") .. "\n" ..
                    (self:DisplayRangedCritChance() or "暴击: 数据不可用") .. "\n" ..
                    (self:DisplayArmorPenetration() or "破甲: 数据不可用") .. "\n" ..
                    self:DisplayAttackSpeed()
    elseif self.displayConfig == "混伤" then
        firstLine = self:DisplayAP()
        restLines = (self:DisplaySP() or "法强: 数据不可用") .. "\n" ..
                    (self:DisplayHitRating() or "命中: 数据不可用") .. "\n" ..
                    (self:DisplayPhysicalCrit() or "暴击: 数据不可用") .. "\n" ..
                    (self:DisplayArmorPenetration() or "破甲: 数据不可用") .. "\n" ..
                    self:DisplayDualAttackSpeed()
    elseif self.displayConfig == "防御" then
        firstLine = self:DisplayArmor() or "护甲: 数据不可用"
        restLines = (self:DisplayDefense() or "防御: 数据不可用") .. "\n" ..
                    (self:DisplayHitRating() or "命中: 数据不可用") .. "\n" ..
                    (self:DisplayDodge() or "躲闪: 数据不可用") .. "\n" ..
                    (self:DisplayParry() or "招架: 数据不可用") .. "\n" ..
                    (self:DisplayBlock() or "格挡: 数据不可用")
    end

    return firstLine, restLines
end

-- 以下为原有函数，保持不变（用于聊天和内部调用）
-- 获取用于聊天的属性字符串
function P:GetPropertiesForChat()
    local playerName, playerLevel, playerClass = UnitName("player"), UnitLevel("player"), UnitClass("player")
    local itemScore = self:GetItemScore()

    local ret = playerName .. " (Lv" .. playerLevel .. " " .. playerClass .. "): " .. itemScore .. " 当前属性 (" .. self.displayConfig .. "): "

    if self.displayConfig == "物理" then
        ret = ret .. self:DisplayAP() .. ", " ..
              (self:DisplayHitRating() or "命中: 数据不可用") .. ", " ..
              (self:DisplayPhysicalCrit() or "暴击: 数据不可用") .. ", " ..
              (self:DisplayArmorPenetration() or "破甲: 数据不可用") .. ", " ..
              self:DisplayDualAttackSpeed()
    elseif self.displayConfig == "法系" then
        ret = ret .. (self:DisplaySP() or "法强: 数据不可用") .. ", " ..
              (self:DisplaySpellHitRating() or "法命: 数据不可用") .. ", " ..
              (self:DisplaySpellCrit() or "法爆: 数据不可用") .. ", " ..
              (self:DisplayManaRegen() or "回蓝: 数据不可用") .. ", " ..
              (self:DisplayHaste() or "急速: 数据不可用")
    elseif self.displayConfig == "治疗" then
        ret = ret ..(self:DisplayHealingPower() or "治疗: 数据不可用") .. "\n" ..
              (self:DisplaySP() or "法强: 数据不可用") .. "\n" ..
              (self:DisplaySpellCrit() or "法爆: 数据不可用") .. ", " ..
              (self:DisplayManaRegen() or "回蓝: 数据不可用") .. ", " ..
              (self:DisplayHaste() or "急速: 数据不可用")
    elseif self.displayConfig == "猎人" then
        ret = ret .. self:DisplayRAP() .. ", " ..
              (self:DisplaySP() or "法强: 数据不可用") .. ", " ..
              (self:DisplayRangedHitRating() or "命中: 数据不可用") .. ", " ..
              (self:DisplayRangedCritChance() or "暴击: 数据不可用") .. ", " ..
              (self:DisplayArmorPenetration() or "破甲: 数据不可用") .. ", " ..
              self:DisplayAttackSpeed()
    elseif self.displayConfig == "混伤" then
        ret = ret .. self:DisplayAP() .. ", " ..
              (self:DisplaySP() or "法强: 数据不可用") .. ", " ..
              (self:DisplayHitRating() or "命中: 数据不可用") .. ", " ..
              (self:DisplayPhysicalCrit() or "暴击: 数据不可用") .. ", " ..
              (self:DisplayArmorPenetration() or "破甲: 数据不可用") .. ", " ..
              self:DisplayDualAttackSpeed()
    elseif self.displayConfig == "防御" then
        ret = ret .. (self:DisplayArmor() or "护甲: 数据不可用") .. ", " ..
              (self:DisplayDefense() or "防御: 数据不可用") .. ", " ..
              (self:DisplayHitRating() or "命中: 数据不可用") .. ", " ..
              (self:DisplayDodge() or "躲闪: 数据不可用") .. ", " ..
              (self:DisplayParry() or "招架: 数据不可用") .. ", " ..
              (self:DisplayBlock() or "格挡: 数据不可用")
    end

    return ret
end

-- 发送属性到输入框
function P:SendPropertiesToInput()
    local propertiesText = self:GetPropertiesForChat()

    local editBox = nil
    if ChatEdit_GetActiveWindow then
        editBox = ChatEdit_GetActiveWindow()
    end
    if not editBox and ChatFrame1 and ChatFrame1.editBox then
        editBox = ChatFrame1.editBox
        ChatFrame1.editBox:Show()
    end
    if not editBox then
        local frame = DEFAULT_CHAT_FRAME or ChatFrame1
        if frame then
            frame.editBox:Show()
            frame.editBox:SetFocus()
            editBox = frame.editBox
        end
    end

    if editBox then
        editBox:SetText(propertiesText)
        editBox:HighlightText()
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000PropertiesPanel: 无法找到聊天输入框|r")
    end

    self.mainFrame:Hide()
end

-- 发送属性到密语
function P:SendPropertiesToWhisper()
    local propertiesText = self:GetPropertiesForChat()
    local targetName = UnitName("target")
    if targetName then
        SendChatMessage(propertiesText, "WHISPER", nil, targetName)
    else
        if WIM_EditBoxInFocus then
            WIM_EditBoxInFocus:SetText(propertiesText)
            WIM_EditBoxInFocus:HighlightText()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000PropertiesPanel: 没有选择目标且WIM未加载|r")
        end
    end
    self.mainFrame:Hide()
end

-- 以下为各属性显示函数（均调用BCS函数）
function P:GetItemScore()
    if ItemSocre then
        local playerScore = ItemSocre:ScanUnit("player")
        if playerScore and playerScore > 0 then
            return "装等: " .. playerScore
        end
    end
    return "装等: 数据不可用"
end

function P:DisplayAP()
    local base, posBuff, negBuff = UnitAttackPower("player")
    return "攻强: " .. (base + posBuff + negBuff)
end

function P:DisplayRAP()
    local base, posBuff, negBuff = UnitRangedAttackPower("player")
    return "远程攻强: " .. (base + posBuff + negBuff)
end

function P:DisplaySP()
    if not BCS then
        return "法强: 数据不可用"
    end

    -- 若安装了 Nampower，使用其 GetSpellPower 并取各系最大值
    if BCS:IsNampowerReady() then
        local physical, holy, fire, nature, frost, shadow, arcane = GetSpellPower()
        -- 使用 or 0 确保所有参数都是数字
        local totalPower = math.max(holy or 0, fire or 0, nature or 0, frost or 0, shadow or 0, arcane or 0)
        return "法强: " .. math.floor(totalPower + 0.5)
    else
        local value1, value2 = BCS:GetSpellPower()
        value2 = value2 or 0
        return "法强: " .. math.floor(value1 + value2 + 0.5)
    end
end

function P:DisplayManaRegen()
    if BCS then
        local _, manaRegen2, manaRegen3 = BCS:GetManaRegen()
        manaRegen2 = manaRegen2 or 0
        manaRegen3 = manaRegen3 or 0
        local total = manaRegen2 + manaRegen3 * 0.4
        return "回蓝: " .. math.floor(total)
    else
        return "回蓝: 数据不可用"
    end
end

function P:DisplayHealingPower()
    if BCS then
        local power, _, _, dmg = BCS:GetSpellPower()
        dmg = dmg or 0
        local heal = BCS:GetHealingPower()
        heal = heal + power - dmg
        return "治疗: " .. math.floor(heal)
    else
        return "治疗: 数据不可用"
    end
end

function P:DisplayPhysicalCrit()
    if BCS then
        local success, crit = pcall(BCS.GetCritChance, BCS)
        if success and crit then
            return "暴击: " .. string.format("%.2f", crit) .. "%"
        else
            return "暴击: 数据获取失败"
        end
    else
        return "暴击: 数据不可用"
    end
end

function P:DisplayHitRating()
    if BCS then
        local hit = BCS:GetHitRating()
        return "命中: " .. math.floor(hit + 0.5) .. "%"
    else
        return "命中: 数据不可用"
    end
end

function P:DisplayRangedHitRating()
    if BCS and BCS.GetRangedHitRating then
        local hit = BCS:GetRangedHitRating()
        return "命中: " .. math.floor(hit + 0.5) .. "%"
    else
        return "命中: 数据不可用"
    end
end

function P:DisplayRangedCritChance()
    if BCS then
        local success, crit = pcall(BCS.GetRangedCritChance, BCS)
        if success and crit then
            return "暴击: " .. string.format("%.2f", crit) .. "%"
        else
            return "暴击: 数据获取失败"
        end
    else
        return "暴击: 数据不可用"
    end
end

function P:DisplaySpellCrit()
    if BCS then
        local success, crit = pcall(BCS.GetSpellCritChance, BCS)
        if success and crit then
            return "法暴: " .. string.format("%.2f", crit) .. "%"
        else
            return "法暴: 数据获取失败"
        end
    else
        return "法暴: 数据不可用"
    end
end

function P:DisplaySpellHitRating()
    if BCS and BCS.GetSpellHitRating then
        local base, fire, frost, arcane, shadow, holy = BCS:GetSpellHitRating()
        base = base or 0
        fire = fire or 0
        frost = frost or 0
        arcane = arcane or 0
        shadow = shadow or 0
        holy = holy or 0
        local otherMax = math.max(fire, frost, arcane, shadow, holy)
        return "法命: " .. math.floor(base + otherMax + 0.5) .. "%"
    else
        return "法命: 数据不可用"
    end
end

function P:DisplayHaste()
    if not BCS then
        return "急速: 数据不可用"
    end

    local haste = nil

    -- 若安装了 Nampower，使用 GetUnitField 获取施法速度系数
    if BCS:IsNampowerReady() then
        local castSpeed = GetUnitField("player", "modCastSpeed")
        if castSpeed then
            haste = (1 / castSpeed - 1) * 100
        end
    end

    -- 回退到 BCS 内置估算
    if not haste then
        local val1, val2 = BCS:EstimateHaste()
        if val1 == nil then
            haste = BCS:GetHaste()
        else
            haste = val1
        end
    end

    if haste == nil then
        return "急速: 数据不可用"
    end

    return "急速: " .. string.format("%.2f", haste) .. "%"
end

function P:DisplayDualAttackSpeed()
    local mainHandSpeed, offHandSpeed = UnitAttackSpeed("player")
    if offHandSpeed then
        return string.format("攻速: %.2f/%.2f", mainHandSpeed, offHandSpeed)
    else
        return string.format("攻速: %.2f", mainHandSpeed)
    end
end

function P:DisplayAttackSpeed()
    local _, playerClass = UnitClass("player")
    if playerClass == "HUNTER" then
        local speed = select(1, UnitRangedDamage("player"))
        return string.format("攻速: %.2f", math.floor(speed * 100 + 0.5) / 100)
    else
        local speed = select(1, UnitAttackSpeed("player"))
        return string.format("攻速: %.2f", speed)
    end
end

function P:DisplayDodge()
    if BCS then
        local dodge = GetDodgeChance()
        return "躲闪: " .. string.format("%.2f", dodge) .. "%"
    else
        return "躲闪: 数据不可用"
    end
end

function P:DisplayParry()
    if BCS then
        local parry = GetParryChance()
        return "招架: " .. string.format("%.2f", parry) .. "%"
    else
        return "招架: 数据不可用"
    end
end

function P:DisplayBlock()
    if BCS then
        local block = GetBlockChance()
        return "格挡: " .. string.format("%.2f", block) .. "%"
    else
        return "格挡: 数据不可用"
    end
end

function P:DisplayArmor()
    if BCS then
        local base, effectiveArmor, armor = UnitArmor("player")
        return "护甲: " .. armor
    else
        return "护甲: 数据不可用"
    end
end

function P:DisplayDefense()
    if BCS then
        local base, modifier = UnitDefense("player")
        return "防御: " .. (base + modifier)
    else
        return "防御: 数据不可用"
    end
end

function P:DisplayArmorPenetration()
    if BCS then
        local armorPen = BCS:GetArmorPenetrationValue()
        return "破甲: " .. math.floor(armorPen + 0.5)
    else
        return "破甲: 数据不可用"
    end
end

-- 事件处理
P.frame:RegisterEvent("ADDON_LOADED")
P.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
P.frame:RegisterEvent("UNIT_AURA")

P.frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        -- 确保 BCSConfig 存在
        BCSConfig = BCSConfig or {}

        -- 初始化配置表（如果不存在）
        if not BCSConfig.PropertiesPanel then
            BCSConfig.PropertiesPanel = {}
        end

        -- 调用初始化函数
        P:Init()

        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 已加载，输入 /mb 呼出配置选择窗口", 1, 1, 1)
    end

    -- 仅在开启状态下更新显示
    if P.showWindow then
        local firstLine, restLines = P:GetDisplayLines()
        P:UpdateDisplay(1, firstLine, restLines)
    else
        P.frame:Hide()
    end
end)

-- 聊天命令
local function HandleSlashCommand(arg)
    if arg == "" then
        -- 无参数：切换主配置窗口
        if P.mainFrame:IsShown() then
            P.mainFrame:Hide()
        else
            P.mainFrame:Show()
        end
    elseif arg == "off" or arg == "hide" then
        -- 关闭悬浮窗
        P.showWindow = false
        P.frame:Hide()
        if not BCSConfig.PropertiesPanel then
            BCSConfig.PropertiesPanel = {}
        end
        BCSConfig.PropertiesPanel.enabled = false
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 悬浮窗已隐藏", 1, 1, 1)
    elseif arg == "on" or arg == "show" then
        -- 显示悬浮窗
        P.showWindow = true
        local firstLine, restLines = P:GetDisplayLines()
        P:UpdateDisplay(1, firstLine, restLines)
        if not BCSConfig.PropertiesPanel then
            BCSConfig.PropertiesPanel = {}
        end
        BCSConfig.PropertiesPanel.enabled = true
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 悬浮窗已显示", 1, 1, 1)
    elseif arg == "toggle" or arg == "visible" then
        -- 切换悬浮窗显示状态
        if P.showWindow then
            P.showWindow = false
            P.frame:Hide()
            if not BCSConfig.PropertiesPanel then
                BCSConfig.PropertiesPanel = {}
            end
            BCSConfig.PropertiesPanel.enabled = false
            DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 悬浮窗已隐藏", 1, 1, 1)
        else
            P.showWindow = true
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
            if not BCSConfig.PropertiesPanel then
                BCSConfig.PropertiesPanel = {}
            end
            BCSConfig.PropertiesPanel.enabled = true
            DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 悬浮窗已显示", 1, 1, 1)
        end
    elseif arg == "align left" then
        P.align = "LEFT"
        if not BCSConfig.PropertiesPanel then BCSConfig.PropertiesPanel = {} end
        BCSConfig.PropertiesPanel.align = "LEFT"
        if P.showWindow then
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 对齐方式设置为左对齐", 1, 1, 1)
    elseif arg == "align center" then
        P.align = "CENTER"
        if not BCSConfig.PropertiesPanel then BCSConfig.PropertiesPanel = {} end
        BCSConfig.PropertiesPanel.align = "CENTER"
        if P.showWindow then
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 对齐方式设置为居中对齐", 1, 1, 1)
    elseif arg == "align right" then
        P.align = "RIGHT"
        if not BCSConfig.PropertiesPanel then BCSConfig.PropertiesPanel = {} end
        BCSConfig.PropertiesPanel.align = "RIGHT"
        if P.showWindow then
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 对齐方式设置为右对齐", 1, 1, 1)
    elseif arg == "lock" then
        P.locked = true
        if not BCSConfig.PropertiesPanel then BCSConfig.PropertiesPanel = {} end
        BCSConfig.PropertiesPanel.locked = true
        if P.showWindow then
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 悬浮窗已锁定，点击穿透开启", 1, 1, 1)
    elseif arg == "unlock" then
        P.locked = false
        if not BCSConfig.PropertiesPanel then BCSConfig.PropertiesPanel = {} end
        BCSConfig.PropertiesPanel.locked = false
        if P.showWindow then
            local firstLine, restLines = P:GetDisplayLines()
            P:UpdateDisplay(1, firstLine, restLines)
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 悬浮窗已解锁，可拖动", 1, 1, 1)
    elseif arg == "togglelock" then
        if P.locked then
            HandleSlashCommand("unlock")
        else
            HandleSlashCommand("lock")
        end
    elseif arg:match("^align ") then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 未知的对齐方式，可用：left, center, right", 1, 0, 0)
    else
        -- 未知参数，提示用法
        DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A PropertiesPanel:|r 用法：/mb 打开配置窗口，/mb off/hide 隐藏悬浮窗，/mb on/show 显示悬浮窗，/mb toggle/visible 切换显示，/mb align left/center/right 设置对齐方式，/mb lock/unlock/togglelock 锁定/解锁悬浮窗", 1, 0, 0)
    end
end

SLASH_PROPERTIESPANEL1 = "/mb"
SlashCmdList["PROPERTIESPANEL"] = HandleSlashCommand

-- 初始隐藏主窗口
P.mainFrame:Hide()