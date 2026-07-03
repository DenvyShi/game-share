--[[
    ShaguDPS pfUI 风格皮肤模块（独立实现，兼容 1.12）
    启用后会将所有窗口重绘为类似 pfUI 的外观。
    通过设置面板 "pfUI 风格" 选项控制。
    无需 pfUI，无外部依赖。
]]

-- ===== 原始设置面板背景（与 settings.lua 一致，用于还原） =====
local SETTINGS_ORIG_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
local SETTINGS_ORIG_BORDER = {
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
local SETTINGS_CLOSE_BTN_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
}

-- ===== pfUI 风格背景定义 =====
local PFUI_BACKDROP = {
    bgFile   = "Interface\\BUTTONS\\WHITE8X8",
    edgeFile = "Interface\\BUTTONS\\WHITE8X8",
    tile     = false,
    tileSize = 0,
    edgeSize = 1,
    insets   = { left = 0, right = 0, top = 0, bottom = 0 }
}

local PFUI_WIN_BACKDROP = {
    bgFile   = "Interface\\BUTTONS\\WHITE8X8",
    edgeFile = "Interface\\BUTTONS\\WHITE8X8",
    tile     = false,
    tileSize = 0,
    edgeSize = 2,
    insets   = { left = 2, right = 2, top = 2, bottom = 2 }
}

local PFUI_SHADOW_BACKDROP = {
    edgeFile = "Interface\\BUTTONS\\WHITE8X8",
    edgeSize = 2,
}

-- 颜色
local BG_COLOR         = {0, 0, 0, 0.4}
local BORDER_COLOR     = {0.4, 0.4, 0.4, 0}
local BTN_BG_COLOR     = {0, 0, 0, 0.75}
local BTN_BORDER       = {0.4, 0.4, 0.4, 1.0}
local BTN_HIGHLIGHT    = {1.0, 0.8, 0.0, 1.0}
local SHADOW_COLOR     = {0, 0, 0, 0.35}

-- 辅助：安全拷贝 backdrop 表
local function CopyBackdrop(tbl)
    if not tbl then return nil end
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = CopyBackdrop(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- ===== 辅助：保存和恢复按钮原始属性 =====
local function SaveButtonOriginal(btn)
    if not btn._orig then
        local origBackdrop = btn:GetBackdrop()
        btn._orig = {
            backdrop = CopyBackdrop(origBackdrop),
            backdropColor = {btn:GetBackdropColor()},
            backdropBorderColor = {btn:GetBackdropBorderColor()},
            size = {btn:GetWidth(), btn:GetHeight()},
            scripts = {
                OnEnter = btn:GetScript("OnEnter"),
                OnLeave = btn:GetScript("OnLeave"),
            },
        }
    end
end

local function RestoreButton(btn)
    if btn._pfuiStyled and btn._orig then
        local orig = btn._orig
        if orig.backdrop then
            btn:SetBackdrop(orig.backdrop)
        else
            btn:SetBackdrop(nil)
        end
        btn:SetBackdropColor(unpack(orig.backdropColor))
        btn:SetBackdropBorderColor(unpack(orig.backdropBorderColor))
        btn:SetWidth(orig.size[1])
        btn:SetHeight(orig.size[2])
        if orig.scripts.OnEnter then
            btn:SetScript("OnEnter", orig.scripts.OnEnter)
        else
            btn:SetScript("OnEnter", nil)
        end
        if orig.scripts.OnLeave then
            btn:SetScript("OnLeave", orig.scripts.OnLeave)
        else
            btn:SetScript("OnLeave", nil)
        end
        btn._pfuiStyled = false
        btn._orig = nil
    end
end

-- ===== 按钮换肤（通用） =====
local function SkinButton(btn)
    if not btn or btn._pfuiStyled then return end
    btn._pfuiStyled = true

    SaveButtonOriginal(btn)

    btn:SetNormalTexture("")
    btn:SetHighlightTexture("")
    btn:SetPushedTexture("")
    btn:SetDisabledTexture("")

    btn:SetBackdrop(PFUI_BACKDROP)
    btn:SetBackdropColor(unpack(BTN_BG_COLOR))
    btn:SetBackdropBorderColor(unpack(BTN_BORDER))

    local oldEnter = btn:GetScript("OnEnter")
    local oldLeave = btn:GetScript("OnLeave")
    btn:SetScript("OnEnter", function()
        if oldEnter then oldEnter() end
        this:SetBackdropBorderColor(unpack(BTN_HIGHLIGHT))
    end)
    btn:SetScript("OnLeave", function()
        if oldLeave then oldLeave() end
        this:SetBackdropBorderColor(unpack(BTN_BORDER))
    end)

    if btn:GetWidth() == 16 then btn:SetWidth(14) end
    btn:SetHeight(14)
end

-- ===== 复选框换肤（保留原有对勾，只美化背景） =====
local function SkinCheckButton(checkbox)
    if not checkbox or checkbox._pfuiStyled then return end
    checkbox._pfuiStyled = true

    local nt = checkbox:GetNormalTexture()
    if nt then
        checkbox._origNormalTex = nt:GetTexture()
    else
        checkbox._origNormalTex = nil
    end

    checkbox:SetNormalTexture("")

    checkbox:SetBackdrop(PFUI_BACKDROP)
    checkbox:SetBackdropColor(unpack(BTN_BG_COLOR))
    checkbox:SetBackdropBorderColor(unpack(BTN_BORDER))
end

local function RestoreCheckButton(checkbox)
    if not checkbox._pfuiStyled then return end

    if checkbox._origNormalTex then
        checkbox:SetNormalTexture(checkbox._origNormalTex)
    else
        checkbox:SetNormalTexture("")
    end

    checkbox:SetBackdrop(nil)
    checkbox._pfuiStyled = false
    checkbox._origNormalTex = nil
end

-- ===== 选择器（条材质、条高度等带左右箭头的控件）背景美化 =====
local function SkinSelector(frame)
    if not frame or frame._pfuiStyled then return end
    frame._pfuiStyled = true

    -- 保存原始背景属性
    local origBackdrop = frame:GetBackdrop()
    if origBackdrop then
        frame._origSelector = {
            backdrop = CopyBackdrop(origBackdrop),
            backdropColor = {frame:GetBackdropColor()},
            backdropBorderColor = {frame:GetBackdropBorderColor()},
        }
    else
        frame._origSelector = { backdrop = nil }
    end

    -- 选择器主体样式：显示边框
    frame:SetBackdrop(PFUI_BACKDROP)
    frame:SetBackdropColor(unpack(BTN_BG_COLOR))
    frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)   -- 外框显示

    -- 处理左右按钮：默认不显示边框，悬停显示
    local function SkinSelectorButton(btn)
        if not btn or btn._pfuiStyled then return end
        btn._pfuiStyled = true
        SaveButtonOriginal(btn)

        btn:SetNormalTexture("")
        btn:SetHighlightTexture("")
        btn:SetPushedTexture("")
        btn:SetDisabledTexture("")

        btn:SetBackdrop(PFUI_BACKDROP)
        btn:SetBackdropColor(unpack(BTN_BG_COLOR))
        btn:SetBackdropBorderColor(0.4, 0.4, 0.4, 0)  -- 默认透明，不显示边框

        local oldEnter = btn:GetScript("OnEnter")
        local oldLeave = btn:GetScript("OnLeave")
        btn:SetScript("OnEnter", function()
            if oldEnter then oldEnter() end
            this:SetBackdropBorderColor(unpack(BTN_HIGHLIGHT))   -- 悬停显示高亮边框
        end)
        btn:SetScript("OnLeave", function()
            if oldLeave then oldLeave() end
            this:SetBackdropBorderColor(0.4, 0.4, 0.4, 0)        -- 离开恢复透明
        end)
    end

    SkinSelectorButton(frame.left)
    SkinSelectorButton(frame.right)
end

local function RestoreSelector(frame)
    if not frame._pfuiStyled then return end
    local orig = frame._origSelector
    if orig then
        if orig.backdrop then
            frame:SetBackdrop(orig.backdrop)
        else
            frame:SetBackdrop(nil)
        end
        if orig.backdropColor then
            frame:SetBackdropColor(unpack(orig.backdropColor))
        end
        if orig.backdropBorderColor then
            frame:SetBackdropBorderColor(unpack(orig.backdropBorderColor))
        end
        frame._origSelector = nil
    end
    -- 还原左右按钮
    if frame.left then RestoreButton(frame.left) end
    if frame.right then RestoreButton(frame.right) end
    frame._pfuiStyled = false
end

-- ===== 递归应用皮肤到设置面板所有子控件 =====
local function ApplySkinToChildren(frame)
    if not frame then return end
    for _, child in ipairs({frame:GetChildren()}) do
        local objType = child:GetObjectType()
        if objType == "Button" then
            SkinButton(child)
        elseif objType == "CheckButton" then
            SkinCheckButton(child)
        elseif objType == "Frame" and child.left and child.right and child.caption then
            -- 识别为选择器控件
            SkinSelector(child)
        end
        ApplySkinToChildren(child)
    end
end

-- ===== 递归还原设置面板所有子控件 =====
local function RestoreSkinFromChildren(frame)
    if not frame then return end
    for _, child in ipairs({frame:GetChildren()}) do
        if child._pfuiStyled then
            if child:GetObjectType() == "Button" then
                RestoreButton(child)
            elseif child:GetObjectType() == "CheckButton" then
                RestoreCheckButton(child)
            elseif child:GetObjectType() == "Frame" and child.left and child.right and child.caption then
                RestoreSelector(child)
            end
        end
        RestoreSkinFromChildren(child)
    end
end

-- ===== 数据窗口皮肤 =====
local function ApplyPfuiSkinToWindow(window)
    if not window then return end

    window:SetBackdrop(PFUI_WIN_BACKDROP)
    window:SetBackdropColor(unpack(BG_COLOR))
    window:SetBackdropBorderColor(unpack(BORDER_COLOR))
    if window.border then window.border:Hide() end

    if not window._pfuiShadow then
        local shadow = CreateFrame("Frame", nil, window)
        shadow:SetFrameStrata("BACKGROUND")
        shadow:SetFrameLevel(1)
        shadow:SetPoint("TOPLEFT", window, "TOPLEFT", -2, 2)
        shadow:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 2, -2)
        shadow:SetBackdrop(PFUI_SHADOW_BACKDROP)
        shadow:SetBackdropBorderColor(unpack(SHADOW_COLOR))
        window._pfuiShadow = shadow
    end
    window._pfuiShadow:Show()

    local buttons = {
        window.btnAnnounce, window.btnReset, window.btnSegment, window.btnMode,
        window.btnDamage, window.btnDPS, window.btnHeal, window.btnHPS,
        window.btnCurrent, window.btnOverall, window.btnWindow, window.btnSettings,
    }
    if ShaguDPS.hasNampower then
        table.insert(buttons, window.btnEffHeal)
        table.insert(buttons, window.btnOverHeal)
        table.insert(buttons, window.btnDeath)
        table.insert(buttons, window.btnSpellcast)
        table.insert(buttons, window.btnFriendlyFire)
        table.insert(buttons, window.btnDispel)
        table.insert(buttons, window.btnThreat)
        table.insert(buttons, window.btnSunder)
        table.insert(buttons, window.btnDamageTaken)
        table.insert(buttons, window.btnEnergize)
        table.insert(buttons, window.btnInvalidDamage)
        table.insert(buttons, window.btnHealTaken)
        if window.btnBossPrev then table.insert(buttons, window.btnBossPrev) end
        if window.btnBossNext then table.insert(buttons, window.btnBossNext) end
        if window.btnBossMenu then table.insert(buttons, window.btnBossMenu) end
        if window.btnBossSummaryMenu then table.insert(buttons, window.btnBossSummaryMenu) end
    end

    for _, btn in ipairs(buttons) do
        SkinButton(btn)
    end
end

-- ===== 设置窗口皮肤 =====
local function ApplyPfuiSkinToSettings()
    local settings = ShaguDPS.settings
    if not settings or settings._pfuiStyled then return end
    settings._pfuiStyled = true

    settings:SetBackdrop(PFUI_WIN_BACKDROP)
    settings:SetBackdropColor(unpack(BG_COLOR))
    settings:SetBackdropBorderColor(unpack(BORDER_COLOR))
    if settings.border then settings.border:Hide() end

    if not settings._pfuiShadow then
        local shadow = CreateFrame("Frame", nil, settings)
        shadow:SetFrameStrata("BACKGROUND")
        shadow:SetFrameLevel(1)
        shadow:SetPoint("TOPLEFT", settings, "TOPLEFT", -2, 2)
        shadow:SetPoint("BOTTOMRIGHT", settings, "BOTTOMRIGHT", 2, -2)
        shadow:SetBackdrop(PFUI_SHADOW_BACKDROP)
        shadow:SetBackdropBorderColor(unpack(SHADOW_COLOR))
        settings._pfuiShadow = shadow
    end
    settings._pfuiShadow:Show()

    -- 递归美化所有子控件（复选框、按钮、选择器等）
    ApplySkinToChildren(settings)
end

-- ===== 恢复设置面板原始样式 =====
local function RestoreSettings()
    local settings = ShaguDPS.settings
    if not settings then return end

    -- 背景与边框
    settings:SetBackdrop(SETTINGS_ORIG_BACKDROP)
    settings:SetBackdropColor(.5, .5, .5, .9)
    settings:SetBackdropBorderColor(.7, .7, .7, 1)
    if settings.border then
        settings.border:SetBackdrop(SETTINGS_ORIG_BORDER)
        settings.border:SetBackdropBorderColor(.7, .7, .7, 1)
        settings.border:Show()
    end

    -- 隐藏阴影
    if settings._pfuiShadow then
        settings._pfuiShadow:Hide()
    end

    -- 递归还原所有子控件
    RestoreSkinFromChildren(settings)

    -- 清除面板自身的标记
    settings._pfuiStyled = nil
    settings._pfuiShadow = nil
end

-- ===== Hook Refresh =====
local savedUserBackdrop = nil
local originalRefresh = ShaguDPS.window.Refresh
local lastPfuiStyle = ShaguDPS.config.pfuiStyle

ShaguDPS.window.Refresh = function(force, report)
    local pfuiStyle = ShaguDPS.config.pfuiStyle

    if pfuiStyle ~= lastPfuiStyle then
        if pfuiStyle == 1 and savedUserBackdrop == nil then
            savedUserBackdrop = ShaguDPS.config.backdrop
        end
        lastPfuiStyle = pfuiStyle

        for wid = 1, 10 do
            local win = ShaguDPS.window[wid]
            if win then
                win:Hide()
                win:SetParent(nil)
                ShaguDPS.window[wid] = nil
            end
        end
    end

    originalRefresh(force, report)

    if pfuiStyle == 1 then
        ShaguDPS.config.backdrop = savedUserBackdrop or 1
    end

    if pfuiStyle == 1 then
        for wid = 1, 10 do
            local win = ShaguDPS.window[wid]
            if win then
                ApplyPfuiSkinToWindow(win)
            end
        end
    end

    if pfuiStyle == 1 then
        ApplyPfuiSkinToSettings()
    else
        RestoreSettings()
    end
end

-- =================================
-- BOSS 二级菜单 PfUI 美化
-- =================================
function ShaguDPS.ApplyPfuiToBossMenu(menu)
    if not menu then return end
    -- 只美化真正的菜单，跳过无按钮的提示框
    if menu.isTip then return end

    -- 设置菜单容器背景
    menu:SetBackdrop(PFUI_WIN_BACKDROP)
    menu:SetBackdropColor(unpack(BG_COLOR))
    menu:SetBackdropBorderColor(unpack(BORDER_COLOR))

    -- 逐个美化按钮
    for _, child in ipairs({menu:GetChildren()}) do
        if child:GetObjectType() == "Button" then
            SkinButton(child)
        end
    end
end