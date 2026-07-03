--[[
    ShaguDPS 设置窗口模块
    提供图形化配置界面，允许用户修改各种选项（显示、追踪、外观等）。
    配置保存在 SavedVariables PerCharacter 的 ShaguDPS_Config 中。
]]

-- 再次检测 Nampower 可用性（与 core.lua 中保持一致）
ShaguDPS.hasNampower = GetNampowerVersion and true or false

-- 加载公共变量
local settings = ShaguDPS.settings
local window = ShaguDPS.window
local parser = ShaguDPS.parser

local config = ShaguDPS.config
local textures = ShaguDPS.textures
local playerClasses = ShaguDPS.playerClasses

-- ===========================================================================
-- 通用背景样式定义
-- ===========================================================================

-- 通用按钮背景（深色背景 + 淡色边框）
local backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
}

-- 窗口背景
local backdrop_window = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

-- 窗口边框
local backdrop_border = {
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

-- ===========================================================================
-- 创建数值选择器（左右箭头控件）
-- 支持普通数字、材质选择器、以及带步进和范围的滑块
-- ===========================================================================
local function CreateSelector(self, values)
    local input = CreateFrame("Frame", nil, self)
    input.values = values  -- 可选项列表（如材质路径表），若为 nil 则为纯数字

    input:Hide()
    input:SetHeight(18)
    -- 如果有 values 则宽度稍宽以容纳文字，否则只显示数字
    input:SetWidth(values and 112 or 54)
    input:SetPoint("TOPRIGHT", self, "TOPRIGHT", -8, -self.entries*18 - 4)
    input:SetBackdrop(backdrop)
    input:SetBackdropColor(.2,.2,.2,1)
    input:SetBackdropBorderColor(.4,.4,.4,1)
    input:SetScript("OnShow", function() input:change() end)  -- 显示时刷新值

    -- 材质预览图标（仅当 entry 为 "texture" 时使用）
    input.texture = input:CreateTexture()
    input.texture:SetPoint("TOPLEFT", input, "TOPLEFT", 13, -3)
    input.texture:SetPoint("BOTTOMRIGHT", input, "BOTTOMRIGHT", -13, 3)
    input.texture:SetVertexColor(.8, .4, .2)

    -- 显示当前值的文本
    input.caption = input:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    input.caption:SetFont(STANDARD_TEXT_FONT, 10)
    input.caption:SetText("Select")
    input.caption:SetAllPoints()

    -- 左箭头（减少）
    input.left = CreateFrame("Button", nil, input)
    input.left:SetPoint("LEFT", input, "LEFT", 1, 0)
    input.left:SetWidth(12)
    input.left:SetHeight(16)
    input.left:SetBackdrop(backdrop)
    input.left:SetBackdropColor(.2,.2,.2,1)
    input.left:SetBackdropBorderColor(.4,.4,.4,1)
    input.left:SetScript("OnEnter", function() this:SetBackdropBorderColor(1.0, 0.8, 0.0, 1) end)
    input.left:SetScript("OnLeave", function() this:SetBackdropBorderColor(0.4, 0.4, 0.4, 1) end)
    input.left:SetScript("OnClick", function() input:change(-1) end)
    input.left.caption = input.left:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    input.left.caption:SetFont(STANDARD_TEXT_FONT, 10)
    input.left.caption:SetText("<")
    input.left.caption:SetAllPoints()

    -- 右箭头（增加）
    input.right = CreateFrame("Button", nil, input)
    input.right:SetPoint("RIGHT", input, "RIGHT", -1, 0)
    input.right:SetWidth(12)
    input.right:SetHeight(16)
    input.right:SetBackdrop(backdrop)
    input.right:SetBackdropColor(.2,.2,.2,1)
    input.right:SetBackdropBorderColor(.4,.4,.4,1)
    input.right:SetScript("OnEnter", function() this:SetBackdropBorderColor(1.0, 0.8, 0.0, 1) end)
    input.right:SetScript("OnLeave", function() this:SetBackdropBorderColor(0.4, 0.4, 0.4, 1) end)
    input.right:SetScript("OnClick", function() input:change(1) end)
    input.right.caption = input.right:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    input.right.caption:SetFont(STANDARD_TEXT_FONT, 10)
    input.right.caption:SetText(">")
    input.right.caption:SetAllPoints()

    -- 改变值的核心逻辑
    input.change = function(self, mod)
        local id = config[self.entry] or 1

        -- 如果是选择器且有有效范围，则改变索引
        if mod and self.values and self.values[id + mod] then
            config[self.entry] = math.ceil(config[self.entry] + mod)
        elseif mod and not self.values then
            -- 纯数字（带步进和范围限制）
            local step = self.step or 1
            local newval = config[self.entry] + mod * step
            if self.min then newval = math.max(self.min, newval) end
            if self.max then newval = math.min(self.max, newval) end
            config[self.entry] = newval
        end

        -- 更新显示文本
        if self.values and self.values[config[self.entry]] then
            -- 材质选择器：提取文件名
            local _, _, clean = string.find(self.values[config[self.entry]], ".+\\(.+)")
            self.caption:SetText(clean)
        else
            -- 普通数字或滑块：根据步进决定显示小数位数
            if self.step and self.step < 1 then
                self.caption:SetText(string.format("%.1f", config[self.entry]))
            else
                self.caption:SetText(config[self.entry])
            end
        end

        -- 控制箭头透明度（是否可继续增减）
        if self.values then
            self.right:SetAlpha(self.values[config[self.entry]+1] and 1 or 0.25)
            self.left:SetAlpha(self.values[config[self.entry]-1] and 1 or 0.25)
        else
            if self.max then
                self.right:SetAlpha(config[self.entry] < self.max and 1 or 0.25)
                self.left:SetAlpha(config[self.entry] > (self.min or -math.huge) and 1 or 0.25)
            else
                -- 没有上下限的普通数字，箭头始终可点击
                self.right:SetAlpha(1)
                self.left:SetAlpha(1)
            end
        end

        window.Refresh(true)

        -- 如果是材质选择，更新预览图标
        if self.entry == "texture" then
            local texture = ShaguDPS.textures[config[self.entry]]
            if texture then
                self.texture:SetTexture(texture)
            else
                self.texture:SetTexture()
            end
        end
    end

    return input
end

-- ===========================================================================
-- 创建配置项（标签 + 控件）
-- @param caption 选项名称
-- @param entry   配置表中的键名
-- @param check   控件类型："header"、"boolean"、"number"、"table"、"slider"、"range"
-- ===========================================================================
local function CreateConfig(self, caption, entry, check, options)
    self.entries = self.entries and self.entries + 1 or 1

    local entry = entry
    local text = self:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    text:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -self.entries*18 - 4)
    text:SetWidth(170)
    text:SetHeight(18)
    text:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
    text:SetJustifyH("LEFT")
    text:SetText(caption)

    -- 标题行（header）特殊样式：金色加粗
    if check == "header" then
        text:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -self.entries*18 - 8)
        text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        text:SetTextColor(1, .8, 0)
    end

    -- 布尔值选项（复选框）
    if check == "boolean" then
        local input = CreateFrame("CheckButton", nil, self, "OptionsCheckButtonTemplate")
        input:Hide()
        input:SetHeight(18)
        input:SetWidth(18)
        input:SetPoint("TOPRIGHT", self, "TOPRIGHT", -8, -self.entries*18 - 8)
        input:SetScript("OnShow", function()
            this:SetChecked(config[entry] == 1)  -- 根据配置设置勾选状态
        end)

        input:SetScript("OnClick", function()
            config[entry] = this:GetChecked() and 1 or 0  -- 保存勾选状态
            window.Refresh(true)
        end)

        input:Show()
    end

    -- 数值或选择器控件（普通数字或材质列表）
    if check == "number" then
        local input = self:CreateSelector()
        input.entry = entry
        if options then
            input.min = options.min
            input.max = options.max
            input.step = options.step
        end
        input:Show()
    elseif type(check) == "table" then
        local values = check
        local input = self:CreateSelector(values)
        input.entry = entry
        input:Show()
    end

    -- 滑块控件（带步进、最小值、最大值）-- 用于缩放
    if check == "slider" then
        local input = self:CreateSelector()
        input.entry = entry
        input.step = 0.1     -- 步进 0.1
        input.min = 0.5      -- 最小缩放 50%
        input.max = 2.0      -- 最大缩放 200%
        input:Show()
    end

    -- 整数范围控件（带步进、最小值、最大值）-- 用于发送条数等
    if check == "range" then
        local input = self:CreateSelector()
        input.entry = entry
        input.step = 1
        input.min = 1
        input.max = 50
        input:Show()
    end
end

-- ===========================================================================
-- 登录时加载保存的配置
-- ===========================================================================
settings:RegisterEvent("PLAYER_ENTERING_WORLD")
settings:SetScript("OnEvent", function()
    -- 从 SavedVariables 中恢复配置
    if ShaguDPS_Config then
        for k, v in pairs(ShaguDPS_Config) do
            config[k] = v
        end
    end
    ShaguDPS_Config = config  -- 确保外部的 ShaguDPS_Config 指向最新配置

    -- 加载缓存数据（如果存在）
    if ShaguDPS.LoadDataFromCache() then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00ShaguDPS: 已从缓存恢复上次统计的数据。|r")
    end

    window.Refresh(true)
end)

-- ===========================================================================
-- 设置窗口属性
-- ===========================================================================
settings:Hide()
settings:SetPoint("CENTER", UIParent, "CENTER", 0, 32)
settings:SetWidth(192)
settings:SetHeight(500)  -- 适当增加高度以容纳新选项
settings:SetMovable(true)
settings:EnableMouse(true)
settings:RegisterForDrag("LeftButton")
settings:SetScript("OnDragStart", function() this:StartMoving() end)
settings:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
settings:SetFrameStrata("DIALOG")
settings.CreateConfig = CreateConfig
settings.CreateSelector = CreateSelector

-- 窗口背景
settings:SetBackdrop(backdrop_window)
settings:SetBackdropColor(.5,.5,.5,.9)

-- 边框
settings.border = CreateFrame("Frame", nil, settings)
settings.border:ClearAllPoints()
settings.border:SetPoint("TOPLEFT", settings, "TOPLEFT", -1,1)
settings.border:SetPoint("BOTTOMRIGHT", settings, "BOTTOMRIGHT", 1,-1)
settings.border:SetFrameLevel(100)
settings.border:SetBackdrop(backdrop_border)
settings.border:SetBackdropBorderColor(.7,.7,.7,1)

-- 标题栏
settings.title = settings:CreateTexture(nil, "NORMAL")
settings.title:SetTexture(0,0,0,.6)
settings.title:SetHeight(20)
settings.title:SetPoint("TOPLEFT", 2, -2)
settings.title:SetPoint("TOPRIGHT", -2, -2)

settings.caption = settings:CreateFontString(nil, "OVERLAY", "GameFontWhite")
settings.caption:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
settings.caption:SetText("|cffffcc00Shagu|cffffffffDPS")
settings.caption:SetAllPoints(settings.title)

-- 关闭按钮
settings.btnClose = CreateFrame("Button", nil, settings)
settings.btnClose:SetPoint("RIGHT", settings.title, "RIGHT", -4, 0)
settings.btnClose:SetHeight(16)
settings.btnClose:SetWidth(16)
settings.btnClose:SetBackdrop(backdrop)
settings.btnClose:SetBackdropColor(.2,.2,.2,1)
settings.btnClose:SetBackdropBorderColor(.4,.4,.4,1)

settings.btnClose.caption = settings.btnClose:CreateFontString(nil, "OVERLAY", "GameFontWhite")
settings.btnClose.caption:SetFont(STANDARD_TEXT_FONT, 14)
settings.btnClose.caption:SetText("x")
settings.btnClose.caption:SetAllPoints()
settings.btnClose:SetScript("OnEnter", function() this:SetBackdropBorderColor(1.0, 0.8, 0.0, 1) end)
settings.btnClose:SetScript("OnLeave", function() this:SetBackdropBorderColor(0.4, 0.4, 0.4, 1) end)
settings.btnClose:SetScript("OnClick", function() settings:Hide() end)

-- ===========================================================================
-- 配置项列表
-- ===========================================================================

-- 解析器相关
settings:CreateConfig("解析器", nil, "header")
settings:CreateConfig("显示所有附近单位", "track_all_units", "boolean")
settings:CreateConfig("合并宠物与主人数据", "merge_pets", "boolean")
settings:CreateConfig("显示秒伤", "show_dps_in_damage", "boolean")
settings:CreateConfig("显示HPS（治疗视图）", "show_hps_in_heal", "boolean")
settings:CreateConfig("使用DPS替代EDPS（默认）统计", "use_total_cbt_for_dps", "boolean")
-- Nampower 专属选项
if ShaguDPS.hasNampower then
    settings:CreateConfig("显示溢出伤害", "show_overkill", "boolean")
    settings:CreateConfig("剔除溢出伤害", "clamp_damage_to_health", "boolean")
    settings:CreateConfig("剔除小动物伤害", "exclude_critters", "boolean")
    settings:CreateConfig("剔除队友误伤", "hide_friendly_damage", "boolean")
    settings:CreateConfig("仅统计战斗治疗", "heal_only_in_combat", "boolean")
    settings:CreateConfig("非战斗/非队伍时隐藏仇恨窗口", "hide_nondefault_threat_out_of_combat", "boolean")
    settings:CreateConfig("仇恨仅显示坦克和自己", "show_only_tank_and_self_in_threat", "boolean")
    settings:CreateConfig("分开统计主副手伤害", "separate_mh_oh_damage", "boolean")
end

-- 窗口外观
settings:CreateConfig("窗口", nil, "header")
settings:CreateConfig("条材质", "texture", ShaguDPS.textures)
settings:CreateConfig("条高度", "height", "number", {min=10})
settings:CreateConfig("条间距", "spacing", "number", {min=0})
settings:CreateConfig("插件缩放", "scale", "slider")
settings:CreateConfig("发送数据条数", "report_lines", "range")
settings:CreateConfig("柔和色调", "pastel", "boolean")
settings:CreateConfig("显示背景", "backdrop", "boolean")
settings:CreateConfig("锁定窗口", "lock", "boolean")
settings:CreateConfig("菜单向上生长", "menu_grow_upwards", "boolean")
settings:CreateConfig("pfUI 风格", "pfuiStyle", "boolean")
settings:CreateConfig("进入新队伍时询问清空数据", "auto_reset_on_new_group", "boolean")

-- ===========================================================================
-- 斜杠命令处理（/shagudps 或 /sdps 或 /sd）
-- ===========================================================================
SLASH_SHAGUMETER1, SLASH_SHAGUMETER2, SLASH_SHAGUMETER3 = "/shagudps", "/sdps", "/sd"
SlashCmdList["SHAGUMETER"] = function(msg, editbox)
    local function p(msg)
        DEFAULT_CHAT_FRAME:AddMessage(msg)
    end

    -- 无参数时显示帮助信息
    if (msg == "" or msg == nil) then
        p("|cffffcc00Shagu|cffffffffDPS:")
        p("  /sdps visible " .. config.visible .. " |cffcccccc- 显示主窗口")
        p("  /sdps height " .. config.height .. " |cffcccccc- 条高度")
        p("  /sdps spacing " .. config.spacing .. " |cffcccccc- 条间距")
        p("  /sdps trackall " .. config.track_all_units .. " |cffcccccc- 显示所有附近单位")
        p("  /sdps mergepet " .. config.merge_pets .. " |cffcccccc- 合并宠物与主人数据")
        p("  /sdps texture " .. config.texture .. " |cffcccccc- 设置状态栏材质")
        p("  /sdps pastel " .. config.pastel .. " |cffcccccc- 使用柔和色调")
        p("  /sdps backdrop " .. config.backdrop .. " |cffcccccc- 显示窗口背景和边框")
        p("  /sdps lock " .. config.lock .. " |cffcccccc- 锁定窗口")
        p("  /sdps toggle |cffcccccc- 切换窗口显示")
        p("  /sdps cache reset |cffcccccc- 清除战斗日志缓存")
        p("  /sdps autoreset " .. config.auto_reset_on_new_group .. " |cffcccccc- 加入新队伍时是否询问清空（0=否，1=是）")
        return
    end

    -- 解析命令和参数
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    -- 根据命令设置对应配置项
    if strlower(cmd) == "visible" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.visible = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Visible: " .. config.visible)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    elseif strlower(cmd) == "lock" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.lock = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Lock: " .. config.lock)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    elseif strlower(cmd) == "toggle" then
        config.visible = config.visible == 1 and 0 or 1
        ShaguDPS_Config = config
        window.Refresh(true)
        p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Visible: " .. config.visible)
    elseif strlower(cmd) == "height" then
        if tonumber(args) then
            config.height = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Bar height: " .. config.height)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 1-999")
        end
    elseif strlower(cmd) == "spacing" then
        if tonumber(args) then
            config.spacing = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Bar spacing: " .. config.spacing)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-" .. config.height)
        end
    elseif strlower(cmd) == "trackall" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.track_all_units = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Track all units: " .. config.track_all_units)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    elseif strlower(cmd) == "mergepet" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.merge_pets = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Merge pet: " .. config.merge_pets)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    elseif strlower(cmd) == "texture" then
        if tonumber(args) and textures[tonumber(args)] then
            config.texture = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Texture: " .. config.texture)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 1-" .. table.getn(textures))
        end
    elseif strlower(cmd) == "pastel" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.pastel = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Use pastel colors: " .. config.pastel)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    elseif strlower(cmd) == "backdrop" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.backdrop = tonumber(args)
            ShaguDPS_Config = config
            window.Refresh(true)
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc Show window backdrop: " .. config.backdrop)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    elseif strlower(cmd) == "cache" then
        if strlower(args) == "reset" then
            ShaguDPS.ClearCache()
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 缓存已清除。")
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 用法: /sdps cache reset")
        end
    elseif strlower(cmd) == "autoreset" then
        if tonumber(args) and (tonumber(args) == 1 or tonumber(args) == 0) then
            config.auto_reset_on_new_group = tonumber(args)
            ShaguDPS_Config = config
            p("|cffffcc00Shagu|cffffffffDPS:|cffffddcc 新队伍清空询问: " .. config.auto_reset_on_new_group)
        else
            p("|cffffcc00Shagu|cffffffffDPS:|cffff5511 Valid Options are 0-1")
        end
    end
end