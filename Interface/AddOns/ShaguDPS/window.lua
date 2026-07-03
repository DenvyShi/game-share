--[[
    ShaguDPS 主窗口模块
    负责绘制进度条、处理鼠标交互、切换视图（伤害/DPS/治疗/HPS/驱散/仇恨/破甲/承受伤害/BOSS/BOSS汇总/能量回复/无效伤害等）。
    包含窗口创建、数据获取、排序、显示刷新以及向聊天频道报告数据的功能。
]]

-- 检测是否为 TBC 扩展（影响聊天发送逻辑）
local tbc = ShaguDPS.expansion() == "tbc" and true or nil

-- 加载公共变量
local window = ShaguDPS.window
local parser = ShaguDPS.parser
local data = ShaguDPS.data
local config = ShaguDPS.config
local internals = ShaguDPS.internals
local textures = ShaguDPS.textures
local spairs = ShaguDPS.spairs
local round = ShaguDPS.round

-- 所有已知的职业（用于职业着色）
local classes = {
    WARRIOR = true, MAGE = true, ROGUE = true, DRUID = true, HUNTER = true,
    SHAMAN = true, PRIEST = true, WARLOCK = true, PALADIN = true,
}

-- 能量类型名称映射
local POWER_NAMES = {
    [0] = "法力",
    [1] = "怒气",
    [2] = "集中值",
    [3] = "能量",
}

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
-- 视图模板定义
-- ===========================================================================
local view_templates = {
    [1] = { name = "伤害量", sort = "normal", bar_max = "best", bar_val = "value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "(%s)  %s (%.1f%%)", bar_string = "(%s)  %s (%.1f%%)", bar_string_params = { "value_persecond", "value", "percent" } },
    [2] = { name = "DPS", sort = "per_second", bar_max = "persecond_best", bar_val = "value_persecond", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s (%.1f%%)", bar_string = "%s (%.1f%%)", bar_string_params = { "value_persecond", "percent_persecond" } },
    [3] = { name = "治疗量", sort = "heal_total", bar_max = "best", bar_val = "effective_value", bar_lower_max = "best", bar_lower_val = "value",
        chat_string = "[+%s] %s (%.1f%%)", bar_string = "|cffcc8888+%s|r %s (%.1f%%)", bar_string_params = { "uneffective_value", "effective_value", "total_heal_percent" } },
    [4] = { name = "HPS", sort = "heal_hps", bar_max = "persecond_best", bar_val = "effective_value_persecond", bar_lower_max = "persecond_best", bar_lower_val = "value_persecond",
        chat_string = "[+%s] %s (%.1f%%)", bar_string = "|cffcc8888+%s|r %s (%.1f%%)", bar_string_params = { "uneffective_value_persecond", "effective_value_persecond", "total_hps_percent" } },
    [5] = { name = "有效治疗", sort = "effective_total", bar_max = "effective_best", bar_val = "effective_value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s (%.1f%%)", bar_string = "%s (%.1f%%)", bar_string_params = { "effective_value", "total_effective_percent" } },
    [6] = { name = "过量治疗", sort = "overheal_total", bar_max = "uneffective_best", bar_val = "uneffective_value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s (%.1f%%)", bar_string = "%s (%.1f%%)", bar_string_params = { "uneffective_value", "total_uneffective_percent" } },
    [7] = { name = "死亡次数", sort = "death_total", bar_max = "death_best", bar_val = "death_value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s", bar_string = "%s", bar_string_params = { "death_value" } },
    [8] = { name = "技能施放次数", sort = "spellcast_total", bar_max = "spellcast_best", bar_val = "spellcast_total", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s", bar_string = "%s", bar_string_params = { "spellcast_total" } },
    [9] = { name = "队友误伤", sort = "friendly_fire_total", bar_max = "friendly_fire_best", bar_val = "friendly_fire_total", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s", bar_string = "%s", bar_string_params = { "friendly_fire_total" } },
    [10] = { name = "驱散", sort = "dispel_total", bar_max = "dispel_best", bar_val = "dispel_total", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s (进攻:%s 防御:%s)", bar_string = "%s (攻:%s 防:%s)", bar_string_params = { "dispel_total", "dispel_offensive", "dispel_defensive" } },
    [11] = { name = "仇恨", sort = "threat_total", bar_max = "threat_best", bar_val = "threat_value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "(%s) %s (%.1f%%)", bar_string = "(%s) %s (%.1f%%)", bar_string_params = { "tps_str", "threat_value_str", "perc" } },
    [12] = { name = "BOSS", sort = "normal", bar_max = "best", bar_val = "value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "(%s)  %s (%.1f%%)", bar_string = "(%s)  %s (%.1f%%)", bar_string_params = { "value_persecond", "value", "percent" } },
    [13] = { name = "破甲", sort = "sunder_total", bar_max = "sunder_best", bar_val = "sunder_value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s", bar_string = "%s", bar_string_params = { "sunder_value" } },
    [14] = { name = "承受伤害", sort = "damage_taken_total", bar_max = "damage_taken_best", bar_val = "damage_taken_value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s (%.1f%%)", bar_string = "%s (%.1f%%)", bar_string_params = { "damage_taken_value", "damage_taken_percent" } },
    [15] = { name = "BOSS汇总", sort = "normal", bar_max = "best", bar_val = "value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "(%s)  %s (%.1f%%)", bar_string = "(%s)  %s (%.1f%%)", bar_string_params = { "value_persecond", "value", "percent" } },
    [16] = { name = "能量回复", sort = "energize_total", bar_max = "best", bar_val = "value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "%s (%.1f%%)", bar_string = "%s (%.1f%%)", bar_string_params = { "value", "percent" } },
    [17] = { name = "无效伤害", sort = "invalid_total", bar_max = "best", bar_val = "value", bar_lower_max = nil, bar_lower_val = nil,
        chat_string = "(%s)  %s (%.1f%%)", bar_string = "(%s)  %s (%.1f%%)", bar_string_params = { "value_persecond", "value", "percent" } },
    [18] = { name = "受到治疗", sort = "heal_taken_total", bar_max = "best", bar_val = "effective_value", bar_lower_max = "best", bar_lower_val = "value",
        chat_string = "[+%s] %s (%.1f%%)", bar_string = "|cffcc8888+%s|r %s (%.1f%%)", bar_string_params = { "uneffective_value", "effective_value", "total_heal_percent" } },
}

-- 菜单按钮定义（已移除 Boss 和 BossSummary，因为它们已改为左侧按钮）
local menubuttons = {
    ["Current"]  = { 0, 1, -25.5, "当前", "|cffffffff显示当前战斗的数据",      "segment" },
    ["Overall"]  = { 1, 0, -25.5, "全程", "|cffffffff显示全程的总数据",         "segment" },
    ["Damage"]   = { 0, 1, 25.5,  "伤害量",     "|cffffffff显示伤害量",        "view" },
    ["DPS"]      = { 1, 2, 25.5,  "DPS",   "|cffffffff显示每秒伤害",      "view" },
    ["Heal"]     = { 2, 3, 25.5,  "治疗量",     "|cffffffff显示治疗量",        "view" },
    ["HPS"]      = { 3, 4, 25.5,  "HPS",   "|cffffffff显示每秒治疗",      "view" },
}
if ShaguDPS.hasNampower then
    menubuttons["EffHeal"]  = { 4, 5, 25.5,  "有效治疗",   "|cffffffff显示有效治疗量",    "view" }
    menubuttons["OverHeal"] = { 5, 6, 25.5,  "过量治疗",   "|cffffffff显示过量治疗量",    "view" }
    menubuttons["Death"] = { 6, 7, 25.5,  "死亡",   "|cffffffff显示死亡次数",    "view" }
    menubuttons["Spellcast"] = { 7, 8, 25.5,  "技能施放",   "|cffffffff显示技能施放次数",    "view" }
    menubuttons["FriendlyFire"] = { 8, 9, 25.5,  "误伤",   "|cffffffff显示队友误伤",    "view" }
    menubuttons["Dispel"] = { 9, 10, 25.5,  "驱散",   "|cffffffff显示驱散统计",    "view" }
    menubuttons["Threat"] = { 10, 11, 25.5, "仇恨", "|cffffffff显示当前目标仇恨", "view" }
    menubuttons["Sunder"] = { 11, 13, 25.5, "破甲", "|cffffffff显示破甲次数", "view" }
    menubuttons["DamageTaken"] = { 12, 14, 25.5, "承受伤害", "|cffffffff显示承受伤害", "view" }
    menubuttons["Energize"] = { 13, 16, 25.5, "能量回复", "|cffffffff显示能量回复量（法力/怒气/能量/集中）", "view" }
    menubuttons["InvalidDamage"] = { 14, 17, 25.5, "无效伤害", "|cffffffff显示忽略单位的伤害统计", "view" }
    menubuttons["HealTaken"] = { 15, 18, 25.5, "受到治疗", "|cffffffff显示单位受到的治疗量", "view" }
end

local chatcolors = {
    ["SAY"] = "|cffFFFFFF",
    ["EMOTE"] = "|cffFF7E40",
    ["YELL"] = "|cffFF3F40",
    ["PARTY"] = "|cffAAABFE",
    ["GUILD"] = "|cff3CE13F",
    ["OFFICER"] = "|cff40BC40",
    ["RAID"] = "|cffFF7D01",
    ["RAID_WARNING"] = "|cffFF4700",
    ["BATTLEGROUND"] = "|cffFF7D01",
    ["WHISPER"] = "|cffFF7EFF",
    ["CHANNEL"] = "|cffFEC1C0"
}

-- 排序算法
local sort_algorithms = {
    normal = function(t,a,b)
        if t[a]["_esum"] and t[b]["_esum"] and t[a]["_esum"] ~= t[b]["_esum"] then
            return t[b]["_esum"] < t[a]["_esum"]
        else
            return t[b]["_sum"] < t[a]["_sum"]
        end
    end,
    per_second = function(t,a,b)
        if t[a]["_esum"] and t[b]["_esum"] and t[a]["_esum"] ~= t[b]["_esum"] then
            return t[b]["_esum"] / t[b]["_ctime"] < t[a]["_esum"] / t[a]["_ctime"]
        else
            return t[b]["_sum"] / t[b]["_ctime"] < t[a]["_sum"] / t[a]["_ctime"]
        end
    end,
    heal_total = function(t,a,b) return t[b]["_sum"] < t[a]["_sum"] end,
    heal_hps = function(t,a,b) return (t[b]["_sum"] / t[b]["_ctime"]) < (t[a]["_sum"] / t[a]["_ctime"]) end,
    effective_total = function(t,a,b) return t[b]["_esum"] < t[a]["_esum"] end,
    overheal_total = function(t,a,b)
        local over_a = t[a]["_sum"] - (t[a]["_esum"] or 0)
        local over_b = t[b]["_sum"] - (t[b]["_esum"] or 0)
        return over_b < over_a
    end,
    death_total = function(t,a,b) return t[b] < t[a] end,
    spellcast_total = function(t,a,b)
        local total_a = t[a]["_total"] or 0
        local total_b = t[b]["_total"] or 0
        return total_b < total_a
    end,
    friendly_fire_total = function(t,a,b)
        local total_a = t[a]["_total"] or 0
        local total_b = t[b]["_total"] or 0
        return total_b < total_a
    end,
    dispel_total = function(t,a,b) return (t[b]._total or 0) < (t[a]._total or 0) end,
    threat_total = function(t,a,b) return (t[b].perc or 0) < (t[a].perc or 0) end,
    sunder_total = function(t,a,b) return (t[b]._total or 0) < (t[a]._total or 0) end,
    single_spell = function(t,a,b)
        if t["_effective"] and t["_effective"][a] and t["_effective"][b] and t["_effective"][a] ~= t["_effective"][b] then
            return t["_effective"][b] < t["_effective"][a]
        else
            if tonumber(t[b]) and tonumber(t[a]) then return t[b] < t[a] end
        end
    end,
    damage_taken_total = function(t,a,b) return (t[b]._sum or 0) < (t[a]._sum or 0) end,
    energize_total = function(t,a,b) return (t[b]._sum or 0) < (t[a]._sum or 0) end,
    invalid_total = function(t,a,b) return (t[b]._sum or 0) < (t[a]._sum or 0) end,
    heal_taken_total = function(t,a,b) return (t[b]._sum or 0) < (t[a]._sum or 0) end,
}

local rgbcache = {}
local function str2rgb(text)
    if not text then return 1, 1, 1 end
    if rgbcache[text] then return unpack(rgbcache[text]) end
    local counter = 1
    local l = string.len(text)
    for i = 1, l, 3 do
        counter = mod(counter*8161, 4294967279) +
            (string.byte(text,i)*16776193) +
            ((string.byte(text,i+1) or (l-i+256))*8372226) +
            ((string.byte(text,i+2) or (l-i+256))*3932164)
    end
    local hash = mod(mod(counter, 4294967291),16777216)
    local r = (hash - (mod(hash,65536))) / 65536
    local g = ((hash - r*65536) - ( mod((hash - r*65536),256)) ) / 256
    local b = hash - r*65536 - g*256
    rgbcache[text] = { r / 255, g / 255, b / 255 }
    return unpack(rgbcache[text])
end

local function spairs(t, order)
    if type(t) ~= "table" then return function() end end
    local keys = {}
    for k in pairs(t) do keys[table.getn(keys)+1] = k end
    if order then table.sort(keys, function(a,b) return order(t, a, b) end) else table.sort(keys) end
    local i = 0
    return function() i = i + 1; if keys[i] then return keys[i], t[keys[i]] end end
end

-- ===========================================================================
-- 进度条鼠标悬停显示详细数据（工具提示）
-- ===========================================================================
local function barTooltipShow()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    local segment = this.parent.segment
    local wid = this.parent:GetID()
    local unitData = segment[this.unit]
    if not unitData then return end

    -- 能量回复特殊提示
    if this.parent.isEnergizeView then
        GameTooltip:AddLine(this.title .. ":")
        local total = unitData._sum or 0
        local persec = round(total / (unitData._ctime or 1), 1)
        GameTooltip:AddDoubleLine("|cffffffff总回复量", "|cffffffff" .. total)
        GameTooltip:AddDoubleLine("|cffffffff每秒回复", "|cffffffff" .. persec)
        GameTooltip:AddLine(" ")
        -- 能量类型细分
        if unitData._by_type then
            GameTooltip:AddLine("能量类型细分:")
            for pt, amt in pairs(unitData._by_type) do
                local pname = POWER_NAMES[pt] or "未知"
                GameTooltip:AddDoubleLine("|cffffffff" .. pname, "|cffffffff" .. amt)
            end
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("技能详情:")
        for attack, amount in spairs(unitData, sort_algorithms.single_spell) do
            if attack and not internals[attack] and attack ~= "_by_type" then
                local percent = amount == 0 and 0 or round(amount / total * 100, 1)
                GameTooltip:AddDoubleLine("|cffffffff" .. attack, string.format("|cffffffff %s (%.1f%%)", amount, percent))
            end
        end
        GameTooltip:Show()
        return
    end

    -- 0. 受到治疗单独处理（优先级最高）
    if this.parent.isHealTakenView then
        GameTooltip:AddLine("|cffffcc00" .. this.title .. "|r:")
        GameTooltip:AddDoubleLine("总受到治疗", "|cffffffff" .. (unitData._sum or 0))
        GameTooltip:AddDoubleLine("有效治疗", "|cff00ff00" .. (unitData._esum or 0))
        GameTooltip:AddDoubleLine("过量治疗", "|cffcc8888" .. (unitData._sum - unitData._esum))
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("治疗来源 (按总量降序):")
        local sources = {}
        for k, v in pairs(unitData) do
            if type(v) == "table" and k ~= "_sum" and k ~= "_esum" and k ~= "_history" then
                table.insert(sources, { name = k, total = v._sum or 0, effective = v._esum or 0 })
            end
        end
        table.sort(sources, function(a,b) return a.total > b.total end)
        for _, src in ipairs(sources) do
            GameTooltip:AddDoubleLine(src.name, string.format("|cffffffff总:%s|r |cff00ff00有效:%s|r", src.total, src.effective))
        end
        GameTooltip:Show()
        return
    end

    -- 1. 死亡次数
    if type(unitData) == "number" then
        GameTooltip:AddLine(this.title .. ":")
        GameTooltip:AddDoubleLine("|cffffffff死亡次数", "|cffffffff" .. unitData)
        local seg = config[wid] and config[wid].segment
        local dmgTakenSeg
        if seg == 0 then
            dmgTakenSeg = data.damage_taken[0]
        else
            dmgTakenSeg = ShaguDPS.cached_current_damage_taken or data.damage_taken[1]
        end
        local victimData = dmgTakenSeg and dmgTakenSeg[this.unit]
        if not victimData then
            GameTooltip:AddLine("|cffff8888无承受伤害记录|r")
            GameTooltip:Show()
            return
        end

        local deathTimestamps = data.death_timestamps and data.death_timestamps[this.unit]
        local deathTime = nil
        if deathTimestamps and table.getn(deathTimestamps) > 0 then
            deathTime = deathTimestamps[table.getn(deathTimestamps)]
        end

        local hasDetailDamage = victimData._detail_history and table.getn(victimData._detail_history) > 0
        local hasDetailHeal = victimData._detail_heal_history and table.getn(victimData._detail_heal_history) > 0

        if (hasDetailDamage or hasDetailHeal) and deathTime then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cffffdd00死亡前10秒事件:|r")
            local events = {}
            if hasDetailDamage then
                for _, h in ipairs(victimData._detail_history) do
                    if h.time >= deathTime - 10 and h.time <= deathTime + 0.5 then
                        table.insert(events, { type = "damage", source = h.source, spell = h.spell, amount = h.damage, time = h.time })
                    end
                end
            end
            if hasDetailHeal then
                for _, h in ipairs(victimData._detail_heal_history) do
                    if h.time >= deathTime - 10 and h.time <= deathTime + 0.5 then
                        table.insert(events, { type = "heal", source = h.source, spell = h.spell, amount = h.amount, time = h.time })
                    end
                end
            end
            if table.getn(events) > 0 then
                table.sort(events, function(a,b) return a.time > b.time end)
                local maxLines = 50
                for i = 1, math.min(table.getn(events), maxLines) do
                    local e = events[i]
                    local color = e.type == "damage" and "|cffff0000" or "|cff00ff00"
                    local prefix = e.type == "damage" and "-" or "+"
                    GameTooltip:AddDoubleLine(string.format("|cffffffff%s - %s", e.source, e.spell), string.format("%s%s%s", color, prefix, e.amount))
                end
            else
                GameTooltip:AddLine("|cffff8888没有死亡前10秒内的详情|r")
            end
        else
            if victimData._history and table.getn(victimData._history) > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffffdd00承受伤害来源 (总计):|r")
                local sorted = {}
                for _, h in ipairs(victimData._history) do
                    table.insert(sorted, h)
                end
                table.sort(sorted, function(a,b) return a.total > b.total end)
                for _, h in ipairs(sorted) do
                    GameTooltip:AddDoubleLine("|cffffffff" .. h.source .. " - " .. h.spell,
                        string.format("|cffffffff %s (最近 %s)", h.total, h.last))
                end
            else
                GameTooltip:AddLine("|cffff8888无承受伤害记录|r")
            end
        end
        GameTooltip:Show()
        return
    end


    -- 2. 无效伤害提示
    if unitData._by_target then
        GameTooltip:AddLine(this.title .. " (无效伤害):")
        GameTooltip:AddDoubleLine("|cffffffff总伤害", "|cffffffff" .. (unitData._sum or 0))
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("对每个目标的伤害:")
        for target, tdata in pairs(unitData._by_target) do
            GameTooltip:AddLine("|cff00ffff" .. target .. "|r:")
            for spell, amount in pairs(tdata) do
                if spell ~= "_sum" and string.sub(spell, 1, 1) ~= "_" then
                    local dmg = tdata[spell]
                    local cnt = tdata["_count_"..spell] or 0
                    local suffix = "施法"
                    if string.find(spell, "%(DoT%)") then
                        suffix = "跳"
                    end
                    GameTooltip:AddDoubleLine("  "..spell, string.format("%s |cffaaaaaa(×%d%s)|r", dmg, cnt, suffix))
                end
            end
        end
        GameTooltip:Show()
        return
    end

    -- 3. 仇恨
    if unitData.threat then
        GameTooltip:AddLine(this.title .. ":")
        GameTooltip:AddDoubleLine("|cffffffff威胁值", "|cffffffff" .. (unitData.threat or 0))
        GameTooltip:AddDoubleLine("|cffffffffTPS", "|cffffffff" .. (unitData.tps or 0))
        GameTooltip:AddDoubleLine("|cffffffff百分比", "|cffffffff" .. (unitData.perc or 0) .. "%")
        if unitData.tank then GameTooltip:AddLine("|cff00ff00坦克", 1, 1, 1) end
        GameTooltip:Show()
        return
    end

    -- 4. 承受伤害
    if unitData._history then
        GameTooltip:AddLine(this.title .. ":")
        GameTooltip:AddDoubleLine("|cffffffff总承受伤害", "|cffffffff" .. (unitData._sum or 0))
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("伤害详情 (按时间倒序):")
        local sorted = {}
        for _, h in ipairs(unitData._history) do table.insert(sorted, h) end
        table.sort(sorted, function(a, b) return a.time > b.time end)
        for _, h in ipairs(sorted) do
            GameTooltip:AddDoubleLine("|cffffffff" .. h.source .. " - " .. h.spell, string.format("|cffffffff 合计 %s (最近 %s)", h.total, h.last))
        end
        GameTooltip:Show()
        return
    end

    -- 5. 技能施放、误伤、驱散等
    if unitData._total then
        if unitData._offensive ~= nil then
            GameTooltip:AddLine(this.title .. ":")
            GameTooltip:AddDoubleLine("|cffffffff总驱散", "|cffffffff" .. (unitData._total or 0))
            GameTooltip:AddDoubleLine("|cff88ff88进攻驱散", "|cffffffff" .. (unitData._offensive or 0))
            GameTooltip:AddDoubleLine("|cff88aaff防御驱散", "|cffffffff" .. (unitData._defensive or 0))
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("详情:")
            for targetName, spells in pairs(unitData) do
                if type(spells) == "table" and targetName ~= "_total" and targetName ~= "_offensive" and targetName ~= "_defensive" then
                    for spellName, count in pairs(spells) do
                        GameTooltip:AddDoubleLine("|cffffffff" .. targetName .. " - " .. spellName, "|cffffffff" .. count)
                    end
                end
            end
            GameTooltip:Show()
            return
        end

        GameTooltip:AddLine(this.title .. ":")
        local isFriendlyFire = false
        for k, v in pairs(unitData) do
            if k ~= "_total" and type(v) == "table" then
                isFriendlyFire = true
                break
            end
        end
        if isFriendlyFire then
            GameTooltip:AddDoubleLine("|cffffffff总误伤", "|cffffffff" .. unitData._total)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("详情:")
            for targetName, spells in pairs(unitData) do
                if targetName ~= "_total" and type(spells) == "table" then
                    local targetTotal = 0
                    for _, dmg in pairs(spells) do targetTotal = targetTotal + dmg end
                    GameTooltip:AddDoubleLine("|cffffffff" .. targetName, "|cffffffff" .. targetTotal)
                    for spellName, damage in pairs(spells) do
                        GameTooltip:AddDoubleLine("  " .. spellName, damage)
                    end
                end
            end
        else
            GameTooltip:AddDoubleLine("|cffffffff总计", "|cffffffff" .. unitData._total)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("详情:")
            local spells = {}
            for spellName, count in pairs(unitData) do
                if spellName ~= "_total" then table.insert(spells, {name=spellName, count=count}) end
            end
            table.sort(spells, function(a,b) return a.count > b.count end)
            for _, spell in ipairs(spells) do
                GameTooltip:AddDoubleLine("|cffffffff" .. spell.name, "|cffffffff" .. spell.count)
            end
        end
        GameTooltip:Show()
        return
    end

    -- 6. 伤害/治疗
    if unitData._sum then
        local value = unitData._sum
        local persec = round(value / unitData._ctime, 1)
        local evalue, epersec, over, overpersec
        if unitData._esum then
            evalue = unitData._esum
            epersec = round(evalue / unitData._ctime, 1)
            over = value - evalue
            overpersec = round(over / unitData._ctime, 1)
        end
        GameTooltip:AddLine(this.title .. ":")
        GameTooltip:AddDoubleLine("|cffffffff总量", "|cffffffff" .. value)
        GameTooltip:AddDoubleLine("|cffffffff每秒", "|cffffffff" .. persec)
        if unitData._esum then
            GameTooltip:AddDoubleLine("|cffffffff有效", "|cffffffff" .. evalue)
            GameTooltip:AddDoubleLine("|cffcc8888过量", "|cffffffff" .. over)
            GameTooltip:AddDoubleLine("|cffffffff有效/秒", "|cffffffff" .. epersec)
            GameTooltip:AddDoubleLine("|cffcc8888过量/秒", "|cffffffff" .. overpersec)
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("详情:")

        -- 获取施放次数的数据段
        local wid = this.parent:GetID()
        local seg = config[wid].segment   -- 0=全程 1=当前
        local spellcastSeg
        if seg == 0 then
            spellcastSeg = data.spellcast[0]
        else
            spellcastSeg = ShaguDPS.cached_current_spellcast or data.spellcast[1]
        end
        local spellcasts = spellcastSeg and spellcastSeg[this.unit]

        local dotticksSeg
        if seg == 0 then
            dotticksSeg = data.dot_ticks[0]
        else
            dotticksSeg = ShaguDPS.cached_current_dot_ticks or data.dot_ticks[1]
        end
        local dotticks = dotticksSeg and dotticksSeg[this.unit]

        for attack, damage in spairs(unitData, sort_algorithms.single_spell) do
            if attack and not internals[attack] then
                local percent = (damage == 0 or unitData._sum == 0) and 0 or round(damage / unitData._sum * 100, 1)
                local count = spellcasts and spellcasts[attack] or 0
                local countStr = count > 0 and (" |cffaaaaaa(×" .. count .. "施放)|r") or ""
                local ticks = dotticks and dotticks[attack] or 0
                local tickStr = ticks > 0 and (" |cffaaaaaa(×" .. ticks .. "跳)|r") or ""
                if unitData._effective and unitData._effective[attack] then
                    local effective = unitData._effective[attack]
                    local str = string.format("|cffcc8888+%s|cffffffff %s (%.1f%%)", damage - effective, effective, (unitData._esum == 0 or effective == 0) and 0 or round(effective / unitData._esum * 100, 1))
                    GameTooltip:AddDoubleLine("|cffffffff" .. attack, str .. countStr .. tickStr)
                else
                    local overkill = unitData._overkill_by_spell and unitData._overkill_by_spell[attack] or 0
                    local str
                    if overkill > 0 then
                        str = string.format("|cffffffff%s|cffff8888 (+%s)|r (%.1f%%)", damage, overkill, percent)
                    else
                        str = string.format("|cffffffff %s (%.1f%%)", damage, percent)
                    end
                    GameTooltip:AddDoubleLine("|cffffffff" .. attack, str .. countStr .. tickStr)
                end
            end
        end
        GameTooltip:Show()
        return
    end

    -- 7. 破甲
    if unitData._total and not unitData._offensive and not unitData._sum then
        GameTooltip:AddLine(this.title .. ":")
        GameTooltip:AddDoubleLine("|cffffffff总破甲次数", "|cffffffff" .. unitData._total)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("详情:")
        local targets = {}
        for target, count in pairs(unitData) do
            if target ~= "_total" then table.insert(targets, {name=target, count=count}) end
        end
        table.sort(targets, function(a,b) return a.count > b.count end)
        for _, t in ipairs(targets) do
            GameTooltip:AddDoubleLine("|cffffffff" .. t.name, "|cffffffff" .. t.count)
        end
        GameTooltip:Show()
        return
    end

    -- 8. 未知
    GameTooltip:AddLine(this.title .. ":")
    GameTooltip:AddLine("无法显示数据")
    GameTooltip:Show()
end

local function barTooltipHide() GameTooltip:Hide() end

-- 鼠标滚轮
local function barScrollWheel()
    this.scroll = arg1 > 0 and this.scroll - 1 or this.scroll
    this.scroll = arg1 < 0 and this.scroll + 1 or this.scroll
    local count = 0
    for k,v in pairs(this.segment) do count = count + 1 end
    this.scroll = math.min(this.scroll, count + 1 - config[this:GetID()].bars)
    this.scroll = math.max(this.scroll, 0)
    this:Refresh()
end

-- 清空所有数据
local function ResetData()
    for k, v in pairs(data.damage[0]) do data.damage[0][k] = nil end
    for k, v in pairs(data.damage[1]) do data.damage[1][k] = nil end
    for k, v in pairs(data.heal[0]) do data.heal[0][k] = nil end
    for k, v in pairs(data.heal[1]) do data.heal[1][k] = nil end
    for k, v in pairs(data.death[0]) do data.death[0][k] = nil end
    for k, v in pairs(data.death[1]) do data.death[1][k] = nil end
    for k, v in pairs(data.spellcast[0]) do data.spellcast[0][k] = nil end
    for k, v in pairs(data.spellcast[1]) do data.spellcast[1][k] = nil end
    for k, v in pairs(data.friendly_fire[0]) do data.friendly_fire[0][k] = nil end
    for k, v in pairs(data.friendly_fire[1]) do data.friendly_fire[1][k] = nil end
    for k, v in pairs(data.dispel[0]) do data.dispel[0][k] = nil end
    for k, v in pairs(data.dispel[1]) do data.dispel[1][k] = nil end
    for k, v in pairs(data.sunder[0]) do data.sunder[0][k] = nil end
    for k, v in pairs(data.sunder[1]) do data.sunder[1][k] = nil end
    for k, v in pairs(data.damage_taken[0]) do data.damage_taken[0][k] = nil end
    for k, v in pairs(data.damage_taken[1]) do data.damage_taken[1][k] = nil end
    for k, v in pairs(data.energize[0]) do data.energize[0][k] = nil end
    for k, v in pairs(data.energize[1]) do data.energize[1][k] = nil end
    for k, v in pairs(data.invalid_damage[0]) do data.invalid_damage[0][k] = nil end
    for k, v in pairs(data.invalid_damage[1]) do data.invalid_damage[1][k] = nil end
    for k, v in pairs(data.heal_taken[0]) do data.heal_taken[0][k] = nil end
    for k, v in pairs(data.heal_taken[1]) do data.heal_taken[1][k] = nil end
    for k, v in pairs(data.dot_ticks[0]) do data.dot_ticks[0][k] = nil end
    for k, v in pairs(data.dot_ticks[1]) do data.dot_ticks[1][k] = nil end
    ShaguDPS.cached_current_damage = nil
    ShaguDPS.cached_current_heal = nil
    ShaguDPS.cached_current_death = nil
    ShaguDPS.cached_current_spellcast = nil
    ShaguDPS.cached_current_friendly_fire = nil
    ShaguDPS.cached_current_dispel = nil
    ShaguDPS.cached_current_sunder = nil
    ShaguDPS.cached_current_damage_taken = nil
    ShaguDPS.cached_current_energize = nil
    ShaguDPS.cached_current_invalid_damage = nil
    ShaguDPS.cached_current_heal_taken = nil
    ShaguDPS.cached_current_dot_ticks = nil

    -- 重置战斗时间相关变量
    if UnitAffectingCombat("player") then
        -- 若玩家仍在战斗中，将开始时间重置为当前时刻（避免残留旧值）
        data.combat_start_time = GetTime()
    else
        data.combat_start_time = 0
    end
    data.last_fight_duration = 0
    data.total_combat_time = 0
    data.death_timestamps = {}

    ShaguDPS.ClearCache()
    ShaguDPS.current_boss_index = nil
    data.threat = {}
    for i=1,10 do if window[i] then window[i].scroll = 0 end end
    window.Refresh(true)
end

-- 创建单个进度条
local function CreateBar(parent, i, background)
    local totalHeight = config.height + config.spacing
    local yOffset = totalHeight * (i-1) + 22
    parent.bars[i] = parent.bars[i] or CreateFrame("StatusBar", "ShaguDPSBar" .. i, parent)
    parent.bars[i].parent = parent
    parent.bars[i]:SetStatusBarTexture(textures[config.texture] or textures[1])
    parent.bars[i]:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -yOffset)
    parent.bars[i]:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -2, -yOffset)
    parent.bars[i]:SetHeight(config.height)
    parent.bars[i]:SetFrameLevel(4)
    parent.bars[i].lowerBar = parent.bars[i].lowerBar or CreateFrame("StatusBar", "ShaguDPSLowerBar" .. i, parent)
    parent.bars[i].lowerBar:SetStatusBarTexture(textures[config.texture] or textures[1])
    parent.bars[i].lowerBar:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -yOffset)
    parent.bars[i].lowerBar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -2, -yOffset)
    parent.bars[i].lowerBar:SetStatusBarColor(1, 1, 1, .4)
    parent.bars[i].lowerBar:SetHeight(config.height)
    parent.bars[i].lowerBar:SetFrameLevel(2)
    parent.bars[i].textLeft = parent.bars[i].textLeft or parent.bars[i]:CreateFontString("Status", "OVERLAY", "GameFontNormal")
    parent.bars[i].textLeft:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
    parent.bars[i].textLeft:SetJustifyH("LEFT")
    parent.bars[i].textLeft:SetFontObject(GameFontWhite)
    parent.bars[i].textLeft:SetParent(parent.bars[i])
    parent.bars[i].textLeft:ClearAllPoints()
    parent.bars[i].textLeft:SetPoint("TOPLEFT", parent.bars[i], "TOPLEFT", 5, 1)
    parent.bars[i].textLeft:SetPoint("BOTTOMRIGHT", parent.bars[i], "BOTTOMRIGHT", -5, 0)
    parent.bars[i].textRight = parent.bars[i].textRight or parent.bars[i]:CreateFontString("Status", "OVERLAY", "GameFontNormal")
    parent.bars[i].textRight:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
    parent.bars[i].textRight:SetJustifyH("RIGHT")
    parent.bars[i].textRight:SetFontObject(GameFontWhite)
    parent.bars[i].textRight:SetParent(parent.bars[i])
    parent.bars[i].textRight:ClearAllPoints()
    parent.bars[i].textRight:SetPoint("TOPLEFT", parent.bars[i], "TOPLEFT", 5, 1)
    parent.bars[i].textRight:SetPoint("BOTTOMRIGHT", parent.bars[i], "BOTTOMRIGHT", -5, 0)
    parent.bars[i]:EnableMouse(true)
    parent.bars[i]:SetScript("OnEnter", barTooltipShow)
    parent.bars[i]:SetScript("OnLeave", barTooltipHide)
    return parent.bars[i]
end

-- 按钮悬停效果
local function btnEnter()
    if this.tooltip then
        GameTooltip_SetDefaultAnchor(GameTooltip, this)
        for i, data in pairs(this.tooltip) do
            if type(data) == "string" then GameTooltip:AddLine(data)
            elseif type(data) == "table" then GameTooltip:AddDoubleLine(data[1], data[2]) end
        end
        GameTooltip:Show()
    end
    this:SetBackdropBorderColor(1,.8,0,1)
end

local function btnLeave()
    if this.tooltip then GameTooltip:Hide() end
    this:SetBackdropBorderColor(.4,.4,.4,1)
end

-- 创建 BOSS 选择二级菜单的函数
local function ShowBossSubMenu(parent, bossModeBtn)
    local fights = ShaguDPS.boss_fights
    local numFights = table.getn(fights or {})
    -- 隐藏已有菜单（下次重新创建）
    if bossModeBtn._bossMenu then
        bossModeBtn._bossMenu:Hide()
        bossModeBtn._bossMenu = nil
    end
    -- 清除离开计时
    bossModeBtn._bossMenuLeaveTime = nil

    if numFights == 0 then
        -- 无记录时显示提示框
        local tip = CreateFrame("Frame", nil, parent)
        tip:SetBackdrop(backdrop_window)
        tip:SetBackdropColor(.2,.2,.2,.9)
        tip:SetBackdropBorderColor(.4,.4,.4,1)
        tip:SetFrameStrata("DIALOG")
        tip:SetWidth(120)
        tip:SetHeight(20)
        local txt = tip:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        txt:SetFont(STANDARD_TEXT_FONT, 9)
        txt:SetText("暂无BOSS记录")
        txt:SetAllPoints()
        tip:SetPoint("LEFT", bossModeBtn, "RIGHT", 5, 0)
        tip:Show()
        tip.isTip = true
        bossModeBtn._bossMenu = tip
        return
    end

    local menu = CreateFrame("Frame", nil, parent)
    menu:SetBackdrop(backdrop_window)
    menu:SetBackdropColor(.2,.2,.2,.9)
    menu:SetBackdropBorderColor(.4,.4,.4,1)
    menu:SetFrameStrata("DIALOG")
    local itemHeight = 16
    local maxShow = math.min(numFights, 15)
    local menuWidth = 75
    local totalHeight = maxShow * itemHeight + 4
    menu:SetWidth(menuWidth)
    menu:SetHeight(totalHeight)
    if ShaguDPS.config.menu_grow_upwards == 1 then
        menu:SetPoint("BOTTOMLEFT", bossModeBtn, "BOTTOMRIGHT", 0, 0)
    else
        menu:SetPoint("TOPLEFT", bossModeBtn, "TOPRIGHT", 0, 0)
    end

    for i = 1, maxShow do
        local idx = i
        local fight = fights[idx]
        local btn = CreateFrame("Button", nil, menu)
        btn:SetPoint("TOPLEFT", 2, -2 - (idx-1)*itemHeight)
        btn:SetWidth(menuWidth - 4)
        btn:SetHeight(itemHeight)
        btn:SetBackdrop(backdrop)
        btn:SetBackdropColor(.2,.2,.2,1)
        btn:SetBackdropBorderColor(.4,.4,.4,1)
        local cap = btn:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        cap:SetFont(STANDARD_TEXT_FONT, 9)
        local displayName = fight.name
        if string.len(displayName) > 18 then
            displayName = string.sub(displayName, 1, 12) .. "..."
        end
        cap:SetText(displayName)
        cap:SetAllPoints()
        btn:SetScript("OnEnter", function() this:SetBackdropBorderColor(1,.8,0,1) end)
        btn:SetScript("OnLeave", function() this:SetBackdropBorderColor(.4,.4,.4,1) end)
        btn:SetScript("OnClick", function()
            ShaguDPS.current_boss_index = idx
            parent:Refresh(true)
            menu:Hide()
            bossModeBtn._bossMenu = nil
        end)
    end

    -- 延时隐藏逻辑：鼠标离开按钮和菜单后 2 秒才隐藏
    menu:SetScript("OnUpdate", function()
        local now = GetTime()
        -- 如果鼠标在按钮或菜单上，清除离开计时
        if MouseIsOver(menu) or MouseIsOver(bossModeBtn) then
            bossModeBtn._bossMenuLeaveTime = nil
        else
            -- 第一次检测到离开时记录时间
            if not bossModeBtn._bossMenuLeaveTime then
                bossModeBtn._bossMenuLeaveTime = now + 2
            end
            -- 超过 2 秒后隐藏
            if now >= bossModeBtn._bossMenuLeaveTime then
                menu:Hide()
                bossModeBtn._bossMenu = nil
                bossModeBtn._bossMenuLeaveTime = nil
            end
        end
    end)

    menu:Show()
    -- 如果开启了 PfUI 风格，立即美化菜单
    if ShaguDPS.config.pfuiStyle == 1 then
        ShaguDPS.ApplyPfuiToBossMenu(menu)
    end
    bossModeBtn._bossMenu = menu
end

-- 手动强制隐藏 BOSS 二级菜单
local function ForceHideBossSubMenu(bossModeBtn)
    if bossModeBtn._bossMenu then
        bossModeBtn._bossMenu:Hide()
        bossModeBtn._bossMenu = nil
    end
    bossModeBtn._bossMenuLeaveTime = nil
end

-- 发送聊天消息
local function announce(text)
    local type = tbc and ChatFrameEditBox:GetAttribute("chatType") or ChatFrameEditBox.chatType
    local language = tbc and ChatFrameEditBox:GetAttribute("language") or ChatFrameEditBox.language
    local channel = tbc and ChatFrameEditBox:GetAttribute("channelTarget") or ChatFrameEditBox.channelTarget
    local target = tbc and ChatFrameEditBox:GetAttribute("tellTarget") or ChatFrameEditBox.tellTarget
    if type == "WHISPER" then SendChatMessage(text, type, language, target)
    elseif type == "CHANNEL" then SendChatMessage(text, type, language, channel);
    else SendChatMessage(text, type, language); end
end

local function formatThreatNumber(n)
    if n < 0 then n = 0 end
    if n < 1000 then return round(n) end
    if n < 1000000 then return round(n / 10) / 100 .. "K" end
    return round(n / 10000) / 100 .. "M"
end

-- ===========================================================================
-- 逐条发送报告帧
-- ===========================================================================
local reportFrame = CreateFrame("Frame")
reportFrame:Hide()
reportFrame.reportQueue = {}
reportFrame.reportIndex = 0
reportFrame.reportTimer = 0

reportFrame:SetScript("OnUpdate", function()
    local currentTime = GetTime()
    local elapsed = currentTime - reportFrame.reportTimer
    if elapsed >= 0.5 and reportFrame.reportIndex <= table.getn(reportFrame.reportQueue) then
        announce(reportFrame.reportQueue[reportFrame.reportIndex])
        reportFrame.reportIndex = reportFrame.reportIndex + 1
        reportFrame.reportTimer = currentTime
    end
    if reportFrame.reportIndex > table.getn(reportFrame.reportQueue) then
        reportFrame:Hide()
        reportFrame.reportQueue = {}
        reportFrame.reportIndex = 0
    end
end)

local function startReport(dataTable)
    reportFrame.reportQueue = dataTable
    reportFrame.reportIndex = 1
    reportFrame.reportTimer = 0
    reportFrame:Show()
end

-- ===========================================================================
-- 计算当前视图下的最大值和全团总量（用于进度条缩放和百分比计算）
-- ===========================================================================
local function GetCaps(view, values, isHealTaken)
    local values = values or {}
    values.best = 0
    values.all = 0
    values.persecond_best = 0
    values.persecond_all = 0
    values.effective_best = 0
    values.effective_all = 0
    values.effective_persecond_best = 0
    values.effective_persecond_all = 0
    values.uneffective_best = 0
    values.uneffective_all = 0
    values.uneffective_persecond_best = 0
    values.uneffective_persecond_all = 0
    values.death_best = 0
    values.spellcast_best = 0
    values.friendly_fire_best = 0
    values.dispel_best = 0
    values.threat_best = 0
    values.perc_best = 0
    values.sunder_best = 0
    values.damage_taken_best = 0
    values.damage_taken_all = 0
    values.total_heal_all = 0
    values.total_heal_hps_all = 0
    values.total_effective_all = 0
    values.total_uneffective_all = 0
    values.heal_taken_best = 0
    values.heal_taken_all = 0

    for name, data in pairs(view) do
        if type(data) == "table" then
            if isHealTaken then
                -- 受到治疗数据
                local sum = data._sum or 0
                values.all = values.all + sum
                if sum > values.best then values.best = sum end
                local esum = data._esum or 0
                values.effective_all = values.effective_all + esum
                if esum > values.effective_best then values.effective_best = esum end
                local uneff = sum - esum
                values.uneffective_all = values.uneffective_all + uneff
                if uneff > values.uneffective_best then values.uneffective_best = uneff end
                values.total_heal_all = values.total_heal_all + sum
                values.total_effective_all = values.total_effective_all + esum
                values.total_uneffective_all = values.total_uneffective_all + uneff
            elseif data.threat then
                if data.threat > values.threat_best then values.threat_best = data.threat end
                if data.perc > values.perc_best then values.perc_best = data.perc end
            elseif data._by_target then
                -- 无效伤害
                local sum = data._sum or 0
                local ctime = data._ctime or 1
                values.all = values.all + sum
                if sum > values.best then values.best = sum end
                values.persecond_all = values.persecond_all + sum / ctime
                if sum / ctime > values.persecond_best then values.persecond_best = sum / ctime end
                values.total_heal_all = values.total_heal_all + sum
                values.total_heal_hps_all = values.total_heal_hps_all + sum / ctime
            elseif data._history then
                local sum = data._sum or 0
                if isHealTaken then
                    values.heal_taken_all = (values.heal_taken_all or 0) + sum
                    if sum > (values.heal_taken_best or 0) then values.heal_taken_best = sum end
                else
                    values.damage_taken_all = values.damage_taken_all + sum
                    if sum > values.damage_taken_best then values.damage_taken_best = sum end
                end
            elseif data["_sum"] and data["_ctime"] then
                values.all = values.all + data["_sum"]
                if data["_sum"] > values.best then values.best = data["_sum"] end
                values.persecond_all = values.persecond_all + data["_sum"] / data["_ctime"]
                if data["_sum"] / data["_ctime"] > values.persecond_best then values.persecond_best = data["_sum"] / data["_ctime"] end
                values.total_heal_all = values.total_heal_all + data["_sum"]
                values.total_heal_hps_all = values.total_heal_hps_all + data["_sum"] / data["_ctime"]
            end
            if data["_esum"] and data["_ctime"] and not isHealTaken then
                values.effective_all = values.effective_all + data["_esum"]
                if data["_esum"] > values.effective_best then values.effective_best = data["_esum"] end
                values.effective_persecond_all = values.effective_persecond_all + data["_esum"] / data["_ctime"]
                if data["_esum"] / data["_ctime"] > values.effective_persecond_best then values.effective_persecond_best = data["_esum"] / data["_ctime"] end
                local uneffective = data["_sum"] - data["_esum"]
                values.uneffective_all = values.uneffective_all + uneffective
                if uneffective > values.uneffective_best then values.uneffective_best = uneffective end
                values.uneffective_persecond_all = values.uneffective_persecond_all + uneffective / data["_ctime"]
                if uneffective / data["_ctime"] > values.uneffective_persecond_best then values.uneffective_persecond_best = uneffective / data["_ctime"] end
                values.total_effective_all = values.total_effective_all + data["_esum"]
                values.total_uneffective_all = values.total_uneffective_all + uneffective
            end
            if data["_total"] and type(data["_total"]) == "number" then
                local total = data["_total"]
                if total > values.spellcast_best then values.spellcast_best = total end
                if total > values.sunder_best then values.sunder_best = total end
            end
            if data["_total"] and type(data["_total"]) == "number" and (data["_total"] > values.friendly_fire_best) then
                values.friendly_fire_best = data["_total"]
            end
            if data._total and data._total > values.dispel_best then
                values.dispel_best = data._total
            end
        else
            if data > values.death_best then values.death_best = data end
        end
    end
    return values
end

-- ===========================================================================
-- 获取单个单位的数据（填充 values 表）
-- ===========================================================================
local function GetData(unitdata, values, isHealTaken)
    local values = values or {}
    if type(unitdata) == "table" then
        if isHealTaken then
            local sum = unitdata._sum or 0
            local esum = unitdata._esum or 0
            values.value = sum
            values.effective_value = esum
            values.uneffective_value = sum - esum
            values.total_heal_percent = values.total_heal_all > 0 and round(sum / values.total_heal_all * 100, 1) or 0
            values.total_effective_percent = values.total_effective_all > 0 and round(esum / values.total_effective_all * 100, 1) or 0
            values.total_uneffective_percent = values.total_uneffective_all > 0 and round((sum - esum) / values.total_uneffective_all * 100, 1) or 0
        elseif unitdata.threat then
            values.threat_value = unitdata.threat or 0
            values.threat_value_str = formatThreatNumber(values.threat_value)
            values.perc = unitdata.perc or 0
            values.tps = unitdata.tps or 0
            values.tps_str = formatThreatNumber(values.tps)
            values.value = values.threat_value
            if unitdata.class then
                data.classes[values.name] = unitdata.class
            end
        elseif unitdata._by_target then
            -- 无效伤害
            values.value = unitdata._sum or 0
            values.value_persecond = round(values.value / (unitdata._ctime or 1), 1)
            values.percent = values.all > 0 and round(values.value / values.all * 100, 1) or 0
            values.percent_persecond = values.persecond_all > 0 and round(values.value_persecond / values.persecond_all * 100, 1) or 0
            values.overkill = unitdata._overkill or 0
            values._by_target = unitdata._by_target   -- 传递目标明细
        elseif unitdata._history then
            values.damage_taken_value = unitdata._sum or 0
            values.damage_taken_percent = values.damage_taken_all > 0 and round(unitdata._sum / values.damage_taken_all * 100, 1) or 0
            values.value = unitdata._sum or 0
        elseif unitdata["_sum"] ~= nil then
            values.value = unitdata["_sum"]
            values.value_persecond = round(values.value / unitdata["_ctime"], 1)
            values.percent = (values.value == 0 or values.all == 0) and 0 or round(values.value / values.all * 100, 1)
            values.percent_persecond = (values.value_persecond == 0 or values.persecond_all == 0) and 0 or round(values.value_persecond / values.persecond_all * 100, 1)
            values.overkill = unitdata["_overkill"] or 0

            if unitdata["_esum"] then
                values.effective_value = unitdata["_esum"]
                values.effective_value_persecond = round(values.effective_value / unitdata["_ctime"], 1)
                values.total_heal_percent = (values.value == 0 or values.total_heal_all == 0) and 0 or round(values.value / values.total_heal_all * 100, 1)
                values.total_hps_percent = (values.value_persecond == 0 or values.total_heal_hps_all == 0) and 0 or round(values.value_persecond / values.total_heal_hps_all * 100, 1)
                values.total_effective_percent = (values.effective_value == 0 or values.total_effective_all == 0) and 0 or round(values.effective_value / values.total_effective_all * 100, 1)

                values.uneffective_value = values.value - values.effective_value
                values.uneffective_value_persecond = values.value_persecond - values.effective_value_persecond
                values.total_uneffective_percent = (values.uneffective_value == 0 or values.total_uneffective_all == 0) and 0 or round(values.uneffective_value / values.total_uneffective_all * 100, 1)

                values.effective_percent = values.total_heal_percent
                values.uneffective_percent = values.total_uneffective_percent
            else
                values.effective_value = 0
                values.effective_value_persecond = 0
                values.effective_percent = 0
                values.effective_percent_persecond = 0
                values.uneffective_value = 0
                values.uneffective_value_persecond = 0
                values.uneffective_percent = 0
                values.uneffective_percent_persecond = 0
                values.total_heal_percent = 0
                values.total_hps_percent = 0
                values.total_effective_percent = 0
                values.total_uneffective_percent = 0
            end
        elseif unitdata["_total"] ~= nil and unitdata["_offensive"] ~= nil then
            values.dispel_total = unitdata._total
            values.dispel_offensive = unitdata._offensive
            values.dispel_defensive = unitdata._defensive
            values.value = unitdata._total
        elseif unitdata["_total"] ~= nil then
            if values.spellcast_best ~= nil and type(unitdata["_total"]) == "number" then
                values.spellcast_total = unitdata["_total"]
                values.value = unitdata["_total"]
            end
            if values.friendly_fire_best ~= nil and type(unitdata["_total"]) == "number" then
                values.friendly_fire_total = unitdata["_total"]
                values.value = unitdata["_total"]
            end
            if values.sunder_best ~= nil and type(unitdata["_total"]) == "number" then
                values.sunder_value = unitdata["_total"]
                values.value = unitdata["_total"]
            end
        end
    else
        values.death_value = unitdata
        values.value = unitdata
    end

    local pet = not classes[data["classes"][values.name]] and data["classes"][values.name] ~= "__other__"
    local unit = pet and data["classes"][values.name] or values.name
    if type(unitdata) ~= "number" then
        if config.merge_pets == 0 then
            values.name = pet and unit .. " - " .. values.name or unit
        else
            values.name = unit
        end
    end

    local r, g, b = str2rgb(values.name)
    values.color = values.color or {}
    values.color.r = r / 4 + .4
    values.color.g = g / 4 + .4
    values.color.b = b / 4 + .4

    if unitdata and type(unitdata) == "table" and unitdata.threat and values.name == UnitName("player") then
        values.color.r = 1.0
        values.color.g = 0.2
        values.color.b = 0.2
    elseif classes[data["classes"][unit]] then
        values.color.r = RAID_CLASS_COLORS[data["classes"][unit]].r
        values.color.g = RAID_CLASS_COLORS[data["classes"][unit]].g
        values.color.b = RAID_CLASS_COLORS[data["classes"][unit]].b
        if config.pastel == 1 then
            values.color.r = (values.color.r + .5) * .5
            values.color.g = (values.color.g + .5) * .5
            values.color.b = (values.color.b + .5) * .5
        end
    end
    return values
end

-- ===========================================================================
-- 合并所有BOSS战数据为汇总表
-- ===========================================================================
local function MergeBossFightData()
    local merged = {
        damage = {},
        heal = {},
        death = {},
        spellcast = {},
        friendly_fire = {},
        dispel = {},
        sunder = {},
        damage_taken = {},
        energize = {},
        invalid_damage = {},
        heal_taken = {},
    }

    local function mergeDamageHeal(target, source)
        for name, sdata in pairs(source) do
            if not target[name] then target[name] = {} end
            for k, v in pairs(sdata) do
                if k == "_ctime" then
                    target[name]["_ctime"] = (target[name]["_ctime"] or 0) + v
                elseif k == "_sum" then
                    target[name]["_sum"] = (target[name]["_sum"] or 0) + v
                elseif k == "_esum" then
                    target[name]["_esum"] = (target[name]["_esum"] or 0) + v
                elseif k == "_overkill" then
                    target[name]["_overkill"] = (target[name]["_overkill"] or 0) + v
                elseif k == "_effective" then
                    if not target[name]["_effective"] then target[name]["_effective"] = {} end
                    for spell, val in pairs(v) do
                        target[name]["_effective"][spell] = (target[name]["_effective"][spell] or 0) + val
                    end
                elseif k == "_overkill_by_spell" then
                    if not target[name]["_overkill_by_spell"] then target[name]["_overkill_by_spell"] = {} end
                    for spell, val in pairs(v) do
                        target[name]["_overkill_by_spell"][spell] = (target[name]["_overkill_by_spell"][spell] or 0) + val
                    end
                elseif k == "_by_target" then
                    if not target[name]["_by_target"] then target[name]["_by_target"] = {} end
                    for targetName, tdata in pairs(v) do
                        if not target[name]["_by_target"][targetName] then
                            target[name]["_by_target"][targetName] = {}
                        end
                        for spell, dmg in pairs(tdata) do
                            target[name]["_by_target"][targetName][spell] =
                                (target[name]["_by_target"][targetName][spell] or 0) + dmg
                        end
                    end
                elseif k == "_tick" then
                else
                    target[name][k] = (target[name][k] or 0) + v
                end
            end
        end
    end

    local function mergeDeath(target, source)
        for name, count in pairs(source) do
            target[name] = (target[name] or 0) + count
        end
    end

    local function mergeTotalTable(target, source)
        for name, sdata in pairs(source) do
            if not target[name] then target[name] = {} end
            for k, v in pairs(sdata) do
                if k == "_total" or k == "_offensive" or k == "_defensive" then
                    target[name][k] = (target[name][k] or 0) + v
                elseif type(v) == "table" then
                    if not target[name][k] then target[name][k] = {} end
                    for subk, subv in pairs(v) do
                        if type(subv) == "table" then
                            if not target[name][k][subk] then target[name][k][subk] = {} end
                            for spell, count in pairs(subv) do
                                target[name][k][subk][spell] = (target[name][k][subk][spell] or 0) + count
                            end
                        else
                            target[name][k][subk] = (target[name][k][subk] or 0) + subv
                        end
                    end
                else
                    target[name][k] = (target[name][k] or 0) + v
                end
            end
        end
    end

    local function mergeDamageTaken(target, source)
        for name, sdata in pairs(source) do
            if not target[name] then target[name] = { _sum = 0, _history = {} } end
            target[name]._sum = target[name]._sum + (sdata._sum or 0)
            if sdata._history then
                for _, h in ipairs(sdata._history) do
                    table.insert(target[name]._history, h)
                end
            end
        end
    end

    local function mergeEnergize(target, source)
        for name, sdata in pairs(source) do
            if not target[name] then target[name] = { _sum = 0, _ctime = 1, _by_type = {} } end
            target[name]._sum = (target[name]._sum or 0) + (sdata._sum or 0)
            target[name]._ctime = (target[name]._ctime or 1) + (sdata._ctime or 1)
            if sdata._by_type then
                for pt, amt in pairs(sdata._by_type) do
                    target[name]._by_type[pt] = (target[name]._by_type[pt] or 0) + amt
                end
            end
            for k, v in pairs(sdata) do
                if k ~= "_sum" and k ~= "_ctime" and k ~= "_by_type" and k ~= "_tick" then
                    target[name][k] = (target[name][k] or 0) + v
                end
            end
        end
    end

    local function mergeHealTaken(target, source)
        for name, sdata in pairs(source) do
            if not target[name] then target[name] = { _sum = 0, _esum = 0 } end
            local t = target[name]
            t._sum = t._sum + (sdata._sum or 0)
            t._esum = t._esum + (sdata._esum or 0)
            for srcName, srcData in pairs(sdata) do
                if srcName ~= "_sum" and srcName ~= "_esum" then
                    if not t[srcName] then t[srcName] = { _sum = 0, _esum = 0 } end
                    local s = t[srcName]
                    s._sum = s._sum + (srcData._sum or 0)
                    s._esum = s._esum + (srcData._esum or 0)
                end
            end
        end
    end

    for _, fight in ipairs(ShaguDPS.boss_fights) do
        mergeDamageHeal(merged.damage, fight.damage or {})
        mergeDamageHeal(merged.heal, fight.heal or {})
        mergeDeath(merged.death, fight.death or {})
        mergeTotalTable(merged.spellcast, fight.spellcast or {})
        mergeTotalTable(merged.friendly_fire, fight.friendly_fire or {})
        mergeTotalTable(merged.dispel, fight.dispel or {})
        mergeTotalTable(merged.sunder, fight.sunder or {})
        mergeDamageTaken(merged.damage_taken, fight.damage_taken or {})
        mergeEnergize(merged.energize, fight.energize or {})
        mergeHealTaken(merged.heal_taken, fight.heal_taken or {})
        mergeDamageHeal(merged.invalid_damage, fight.invalid_damage or {})
    end

    return merged
end

-- ===========================================================================
-- 格式化数据
-- ===========================================================================
local function formatBarNumber(num)
    if type(num) ~= "number" then return num end
    if num >= 1e6 then
        return string.format("%.2fM", num / 1e6)
    elseif num >= 1e4 then
        return string.format("%.1fK", num / 1e3)
    else
        return num
    end
end

-- ===========================================================================
-- 刷新窗口内容（核心函数）
-- ===========================================================================
local function Refresh(self, force, report)
    if not self or type(self) == "boolean" then return end
    self:SetScale(config.scale)
    local values, buttons = self.values, self.buttons
    local wid = self:GetID()

    if not ShaguDPS.hasNampower and (config[wid].view >= 5) then
        config[wid].view = 1
    end

    local isThreatView = (config[wid].view == 11)
    local isBossView = (config[wid].view == 12)
    local isBossSummaryView = (config[wid].view == 15)
    local isSunderView = (config[wid].view == 13)
    local isDamageTakenView = (config[wid].view == 14)
    local isEnergizeView = (config[wid].view == 16)
    local isInvalidDamageView = (config[wid].view == 17)
    local isHealTakenView = (config[wid].view == 18) or (isBossView and config[wid].boss_stat_view == 15) or (isBossSummaryView and config[wid].boss_stat_view == 15)
    self.isHealTakenView = isHealTakenView
    self.isEnergizeView = isEnergizeView
    self.isInvalidDamageView = isInvalidDamageView

    local currentBossFight = nil
    if isBossView then
        local fights = ShaguDPS.boss_fights
        if fights and table.getn(fights) > 0 then
            local idx = ShaguDPS.current_boss_index
            if not idx or idx < 1 or idx > table.getn(fights) then
                idx = table.getn(fights)   -- 默认最新
                ShaguDPS.current_boss_index = idx
            end
            currentBossFight = fights[idx]
        elseif ShaguDPS.pendingBossRecord then
            currentBossFight = {
                name = ShaguDPS.pendingBossRecord.name,
                damage = data.damage[1],
                heal = data.heal[1],
                death = data.death[1],
                spellcast = data.spellcast[1],
                friendly_fire = data.friendly_fire[1],
                dispel = data.dispel[1],
                sunder = data.sunder[1],
                damage_taken = data.damage_taken[1],
                energize = data.energize[1],
                invalid_damage = data.invalid_damage[1],
                heal_taken = data.heal_taken[1],
                duration = math.max(GetTime() - data.combat_start_time, 1),
            }
        end
    end

    if config.visible == 1 then self:Show() else self:Hide() end
    if ShaguDPS.config.pfuiStyle ~= 1 then
        if config.backdrop == 1 then
            self:SetBackdrop(backdrop_window)
            self:SetBackdropColor(.5,.5,.5,.5)
            self.border:SetBackdrop(backdrop_border)
            self.border:SetBackdropBorderColor(.7,.7,.7,1)
        else
            self:SetBackdrop(nil)
            self.border:SetBackdrop(nil)
        end
    end

    for _, button in pairs(buttons) do button.caption:SetTextColor(1,1,1,1) end

    -- 更新左侧分段/视图选择按钮的标题及交互
    if isBossView then
        if currentBossFight then
            self.btnSegment.caption:SetText(currentBossFight.name)
        else
            self.btnSegment.caption:SetText("无记录")
        end
        self.btnSegment.tooltip = { "BOSS战记录", "|cffffffff点击可切换分段，悬停可切换BOSS" }
        self.btnSegment:SetScript("OnEnter", function()
            btnEnter()
            ShowBossSubMenu(self, this)
        end)
        self.btnSegment:SetScript("OnLeave", function()
            btnLeave()
            if this._bossMenu and this._bossMenu.isTip then
                this._bossMenu:Hide()
                this._bossMenu = nil
            else
                this._bossMenuLeaveTime = GetTime()
            end
        end)
    elseif isBossSummaryView then
        self.btnSegment.caption:SetText("BOSS汇总")
        self.btnSegment.tooltip = { "选择时间段/视图", "|cffffffff当前, 全程, BOSS, BOSS汇总" }
        self.btnSegment:SetScript("OnEnter", btnEnter)
        self.btnSegment:SetScript("OnLeave", btnLeave)
        ForceHideBossSubMenu(self.btnSegment)
    else
        self.btnSegment.caption:SetText(config[wid].segment == 0 and "全程" or "当前")
        self.btnSegment.tooltip = { "选择时间段/视图", "|cffffffff当前, 全程, BOSS, BOSS汇总" }
        self.btnSegment:SetScript("OnEnter", btnEnter)
        self.btnSegment:SetScript("OnLeave", btnLeave)
        ForceHideBossSubMenu(self.btnSegment)
    end

    -- 更新右侧模式标题（始终显示统计类型）
    if isBossView or isBossSummaryView then
        local bossStatMap = { [1]=1, [2]=2, [3]=3, [4]=4, [5]=5, [6]=6, [7]=7, [8]=8, [9]=9, [10]=10, [11]=13, [12]=14, [13]=16, [14]=17, [15]=18 }
        local st = config[wid].boss_stat_view or 1
        local tplIdx = bossStatMap[st] or 1
        self.btnMode.caption:SetText(view_templates[tplIdx].name)
    else
        self.btnMode.caption:SetText(view_templates[config[wid].view].name)
    end
    self.btnMode.tooltip = { "选择统计类型", "|cffffffff伤害量, DPS, 治疗量, HPS" .. (ShaguDPS.hasNampower and ", 有效治疗, 过量治疗, 死亡, 技能施放, 误伤, 驱散, 仇恨, 破甲, 承受伤害, 能量回复, 无效伤害" or "") }
    self.btnMode:SetScript("OnEnter", btnEnter)
    self.btnMode:SetScript("OnLeave", btnLeave)

    -- 设置左侧菜单控件显示/隐藏 (始终显示 btnSegment，不再根据视图隐藏)
    if isThreatView then
        self.btnSegment:SetAlpha(0.5)            -- 仇恨视图下允许显示但禁用点击? 简单隐藏
        self.btnSegment:Hide()
    else
        self.btnSegment:Show()
        self.btnSegment:SetAlpha(1)
    end

    -- 当 仇恨视图 时隐藏左侧下拉菜单项
    if isThreatView then
        self.btnOverall:Hide()
        self.btnCurrent:Hide()
        self.btnBossMenu:Hide()
        self.btnBossSummaryMenu:Hide()
    end

    if ShaguDPS.hasNampower and self.btnBossPrev and self.btnBossNext then
        if isBossView then
            local fights = ShaguDPS.boss_fights
            if fights and table.getn(fights) > 1 then
                self.btnBossPrev:Show()
                self.btnBossNext:Show()
            else
                self.btnBossPrev:Hide()
                self.btnBossNext:Hide()
            end
        else
            self.btnBossPrev:Hide()
            self.btnBossNext:Hide()
        end
    end

    if isBossView then
        self.btnReset:Hide()
        self.btnWindow:Hide()
    else
        self.btnReset:Show()
        self.btnWindow:Show()
    end

    -- 高亮右侧视图按钮
    local highlightView
    if isBossView or isBossSummaryView then
        local bossStatMap = { [1]=1, [2]=2, [3]=3, [4]=4, [5]=5, [6]=6, [7]=7, [8]=8, [9]=9, [10]=10, [11]=13, [12]=14, [13]=16, [14]=17, [15]=18 }
        highlightView = bossStatMap[config[wid].boss_stat_view or 1] or 1
    else
        highlightView = config[wid].view
    end

    -- 重置所有右侧按钮颜色
    self.btnDamage.caption:SetTextColor(1,1,1,1)
    self.btnDPS.caption:SetTextColor(1,1,1,1)
    self.btnHeal.caption:SetTextColor(1,1,1,1)
    self.btnHPS.caption:SetTextColor(1,1,1,1)
    if ShaguDPS.hasNampower then
        self.btnEffHeal.caption:SetTextColor(1,1,1,1)
        self.btnOverHeal.caption:SetTextColor(1,1,1,1)
        self.btnDeath.caption:SetTextColor(1,1,1,1)
        self.btnSpellcast.caption:SetTextColor(1,1,1,1)
        self.btnFriendlyFire.caption:SetTextColor(1,1,1,1)
        self.btnDispel.caption:SetTextColor(1,1,1,1)
        self.btnThreat.caption:SetTextColor(1,1,1,1)
        self.btnSunder.caption:SetTextColor(1,1,1,1)
        self.btnDamageTaken.caption:SetTextColor(1,1,1,1)
        self.btnEnergize.caption:SetTextColor(1,1,1,1)
        self.btnInvalidDamage.caption:SetTextColor(1,1,1,1)
        self.btnHealTaken.caption:SetTextColor(1,1,1,1)
    end

    -- 重置左侧菜单按钮颜色
    self.btnOverall.caption:SetTextColor(1,1,1,1)
    self.btnCurrent.caption:SetTextColor(1,1,1,1)
    if ShaguDPS.hasNampower then
        self.btnBossMenu.caption:SetTextColor(1,1,1,1)
        self.btnBossSummaryMenu.caption:SetTextColor(1,1,1,1)
    end

    -- 高亮当前选中的左侧菜单按钮
    if isBossView then
        self.btnBossMenu.caption:SetTextColor(1,.9,0,1)
    elseif isBossSummaryView then
        self.btnBossSummaryMenu.caption:SetTextColor(1,.9,0,1)
    else
        if config[wid].segment == 0 then
            self.btnOverall.caption:SetTextColor(1,.9,0,1)
        else
            self.btnCurrent.caption:SetTextColor(1,.9,0,1)
        end
    end

    -- 根据 highlightView 设置对应按钮高亮
    local viewToButton = {
        [1] = "btnDamage", [2] = "btnDPS", [3] = "btnHeal", [4] = "btnHPS",
        [5] = "btnEffHeal", [6] = "btnOverHeal", [7] = "btnDeath",
        [8] = "btnSpellcast", [9] = "btnFriendlyFire", [10] = "btnDispel",
        [11] = "btnThreat", [13] = "btnSunder", [14] = "btnDamageTaken",
        [16] = "btnEnergize", [17] = "btnInvalidDamage", [18] = "btnHealTaken"
    }
    if viewToButton[highlightView] then
        self[viewToButton[highlightView]].caption:SetTextColor(1,.9,0,1)
    end

    self:SetWidth((config[wid].width or 177))
    local barsCount = config[wid].bars or 8
    local totalHeight = config.height + config.spacing
    local winHeight
    if barsCount == 0 then
        winHeight = 22 + (config[wid].bars == 0 and 2 or 3)
    else
        winHeight = totalHeight * barsCount + 22 + 3
    end
    if barsCount > 0 then
        self:SetHeight(winHeight)
    end

    for id, bar in pairs(self.bars) do
        bar.lowerBar:Hide()
        bar:Hide()
    end

    -- 更新所有右侧按钮位置（只处理 menubuttons 中现有的条目）
    for name, template in pairs(menubuttons) do
        local button = self["btn"..name]
        if button then
            local idx = template[1]
            local yOffset = -17 - idx * 14
            if config.menu_grow_upwards == 1 then
                yOffset = 17 + idx * 14
            end
            button:SetPoint("CENTER", self.title, "CENTER", template[3], yOffset)
        end
    end

    -- 更新左侧按钮位置（根据向上/向下生长）
    local leftButtons = {
        { btn = self.btnCurrent, idx = 0 },
        { btn = self.btnOverall, idx = 1 },
    }
    if ShaguDPS.hasNampower then
        table.insert(leftButtons, { btn = self.btnBossMenu, idx = 2 })
        table.insert(leftButtons, { btn = self.btnBossSummaryMenu, idx = 3 })
    end
    for _, entry in ipairs(leftButtons) do
        local button = entry.btn
        if button then
            local yOffset = (config.menu_grow_upwards == 1) and (17 + entry.idx * 14) or (-17 - entry.idx * 14)
            button:SetPoint("CENTER", self.title, "CENTER", -25.5, yOffset)
        end
    end

    local isHealView = (config[wid].view == 3 or config[wid].view == 4 or config[wid].view == 5 or config[wid].view == 6)
    local isDeathView = (config[wid].view == 7)
    local isSpellcastView = (config[wid].view == 8)
    local isFriendlyFireView = (config[wid].view == 9)
    local isDispelView = (config[wid].view == 10)

    if isThreatView then
        self.segment = data.threat or {}
        if config.show_only_tank_and_self_in_threat == 1 then
            local filtered = {}
            local playerName = UnitName("player")
            for name, uData in pairs(self.segment) do
                if uData.tank == true or name == playerName then
                    filtered[name] = uData
                end
            end
            self.segment = filtered
        end
    elseif isBossView then
        if currentBossFight then
            local statType = config[wid].boss_stat_view or 1
            if statType == 1 then self.segment = currentBossFight.damage
            elseif statType == 2 then self.segment = currentBossFight.damage
            elseif statType == 3 then self.segment = currentBossFight.heal
            elseif statType == 4 then self.segment = currentBossFight.heal
            elseif statType == 5 then self.segment = currentBossFight.heal
            elseif statType == 6 then self.segment = currentBossFight.heal
            elseif statType == 7 then self.segment = currentBossFight.death
            elseif statType == 8 then self.segment = currentBossFight.spellcast
            elseif statType == 9 then self.segment = currentBossFight.friendly_fire
            elseif statType == 10 then self.segment = currentBossFight.dispel
            elseif statType == 11 then self.segment = currentBossFight.sunder
            elseif statType == 12 then self.segment = currentBossFight.damage_taken
            elseif statType == 13 then self.segment = currentBossFight.energize
            elseif statType == 14 then self.segment = currentBossFight.invalid_damage
            elseif statType == 15 then self.segment = currentBossFight.heal_taken
            else self.segment = currentBossFight.damage end
        else
            self.segment = {}
        end
    elseif isBossSummaryView then
        local merged = MergeBossFightData()
        local statType = config[wid].boss_stat_view or 1
        if statType == 1 then self.segment = merged.damage
        elseif statType == 2 then self.segment = merged.damage
        elseif statType == 3 then self.segment = merged.heal
        elseif statType == 4 then self.segment = merged.heal
        elseif statType == 5 then self.segment = merged.heal
        elseif statType == 6 then self.segment = merged.heal
        elseif statType == 7 then self.segment = merged.death
        elseif statType == 8 then self.segment = merged.spellcast
        elseif statType == 9 then self.segment = merged.friendly_fire
        elseif statType == 10 then self.segment = merged.dispel
        elseif statType == 11 then self.segment = merged.sunder
        elseif statType == 12 then self.segment = merged.damage_taken
        elseif statType == 13 then self.segment = merged.energize
        elseif statType == 14 then self.segment = merged.invalid_damage
        elseif statType == 15 then self.segment = merged.heal_taken
        else self.segment = merged.damage end
    elseif isSunderView then
        if config[wid].segment == 0 then self.segment = data.sunder[0]
        else
            self.segment = ShaguDPS.cached_current_sunder or data.sunder[1]
        end
    elseif isDamageTakenView then
        if config[wid].segment == 0 then self.segment = data.damage_taken[0]
        else
            self.segment = ShaguDPS.cached_current_damage_taken or data.damage_taken[1]
        end
    elseif isEnergizeView then
        if config[wid].segment == 0 then self.segment = data.energize[0]
        else
            self.segment = ShaguDPS.cached_current_energize or data.energize[1]
        end
    elseif isInvalidDamageView then
        if config[wid].segment == 0 then self.segment = data.invalid_damage[0]
        else
            self.segment = ShaguDPS.cached_current_invalid_damage or data.invalid_damage[1]
        end
    elseif isHealTakenView then
        if config[wid].segment == 0 then self.segment = data.heal_taken[0]
        else self.segment = ShaguDPS.cached_current_heal_taken or data.heal_taken[1] end
    elseif config[wid].segment == 0 then
        if isHealView then self.segment = data.heal[0]
        elseif isDeathView then self.segment = data.death[0]
        elseif isSpellcastView then self.segment = data.spellcast[0]
        elseif isFriendlyFireView then self.segment = data.friendly_fire[0]
        elseif isDispelView then self.segment = data.dispel[0]
        else self.segment = data.damage[0] end
    else
        if isHealView then self.segment = ShaguDPS.cached_current_heal or data.heal[1]
        elseif isDeathView then self.segment = ShaguDPS.cached_current_death or data.death[1]
        elseif isSpellcastView then self.segment = ShaguDPS.cached_current_spellcast or data.spellcast[1]
        elseif isFriendlyFireView then self.segment = ShaguDPS.cached_current_friendly_fire or data.friendly_fire[1]
        elseif isDispelView then self.segment = ShaguDPS.cached_current_dispel or data.dispel[1]
        else self.segment = ShaguDPS.cached_current_damage or data.damage[1] end
    end

    local template
    if isBossView or isBossSummaryView then
        local statType = config[wid].boss_stat_view or 1
        local viewMap = {
            [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5,
            [6] = 6, [7] = 7, [8] = 8, [9] = 9, [10] = 10,
            [11] = 13, [12] = 14, [13] = 16, [14] = 17,
            [15] = 18,
        }
        local tplIdx = viewMap[statType] or 1
        template = view_templates[tplIdx]
    else
        template = view_templates[config[wid].view]
    end
    local sort = sort_algorithms[template.sort]

    local reportTitle = nil
    local reportData = {}
    if report then
        local name = template.name
        local seg = config[wid].segment == 1 and "当前" or "全程"
        if isThreatView then seg = "当前目标" end
        if isBossView then
            if currentBossFight then name = currentBossFight.name else name = "无记录" end
            seg = "BOSS"
        end
        if isBossSummaryView then name = "BOSS汇总"; seg = "" end
        if isSunderView then name = "破甲"; seg = config[wid].segment == 1 and "当前" or "全程" end
        if isDamageTakenView then name = "承受伤害"; seg = config[wid].segment == 1 and "当前" or "全程" end
        if isEnergizeView then name = "能量回复"; seg = config[wid].segment == 1 and "当前" or "全程" end
        if isInvalidDamageView then name = "无效伤害"; seg = config[wid].segment == 1 and "当前" or "全程" end
        if isHealTakenView then name = "受到治疗"; seg = config[wid].segment == 1 and "当前" or "全程" end
        reportTitle = "ShaguDPS - " .. seg .. " " .. name .. ":"
    end

    self.values = self.GetCaps(self.segment, self.values, isHealTakenView)

    local i = 1
    for name, unitdata in spairs(self.segment, sort) do
        self.values.name = name
        self.values = self.GetData(unitdata, self.values, isHealTakenView)

        -- 确定当前实际视图 ID（BOSS 视图下从 boss_stat_view 映射）
        local effectiveViewId = config[wid].view
        if isBossView or isBossSummaryView then
            local bossStatMap = { [1]=1, [2]=2, [3]=3, [4]=4, [5]=5, [6]=6, [7]=7, [8]=8, [9]=9, [10]=10, [11]=13, [12]=14, [13]=16, [14]=17, [15]=18 }
            effectiveViewId = bossStatMap[config[wid].boss_stat_view or 1] or 1
        end

        -- 启用总战斗时间重算：针对伤害量、DPS、误伤、无效伤害视图
        local applyTotalCBT = config.use_total_cbt_for_dps == 1
            and (effectiveViewId == 1 or effectiveViewId == 2 or effectiveViewId == 9 or effectiveViewId == 17)

        if applyTotalCBT then
            local useEDPS = false
            -- 不在战斗中且不是BOSS视图/BOSS汇总时，使用EDPS（活跃时间）
            if not UnitAffectingCombat("player") then
                if not (isBossView or isBossSummaryView) then
                    useEDPS = true
                end
            end

            if useEDPS then
                -- 基于活跃时间（_ctime）计算DPS，即EDPS
                local ctime = unitdata._ctime or 1
                self.values.value_persecond = round(self.values.value / ctime, 1)
            else
                local cbt = 1   -- 防止除零
                if isBossView then
                    -- 单场BOSS：使用保存的 duration 字段
                    if currentBossFight and currentBossFight.duration then
                        cbt = math.max(currentBossFight.duration, 1)
                    end
                elseif isBossSummaryView then
                    -- BOSS 汇总：所有 BOSS 战总时长之和
                    local totalDuration = 0
                    for _, fight in ipairs(ShaguDPS.boss_fights) do
                        totalDuration = totalDuration + (fight.duration or 0)
                    end
                    cbt = math.max(totalDuration, 1)
                elseif config[wid].segment == 1 then
                    -- 当前战斗
                    if UnitAffectingCombat("player") then
                        cbt = math.max(GetTime() - data.combat_start_time, 1)
                    else
                        cbt = math.max(data.last_fight_duration, 1)
                    end
                else
                    -- 全程：累加已结束战斗时长 + 当前战斗时长（如果正在战斗中）
                    local totalCbt = data.total_combat_time or 0
                    if UnitAffectingCombat("player") and data.combat_start_time > 0 then
                        totalCbt = totalCbt + (GetTime() - data.combat_start_time)
                    end
                    cbt = math.max(totalCbt, 1)
                end
                self.values.value_persecond = round(self.values.value / cbt, 1)
            end
        end

        local bar = i - self.scroll
        if bar >= 1 and bar <= (config[wid].bars or 8) then
            self.bars[bar] = not force and self.bars[bar] or CreateBar(self, bar)
            self.bars[bar].title = self.values.name
            self.bars[bar].unit = name
            if isThreatView then
                local maxPerc = self.values.perc_best or 100
                if maxPerc < 100 then maxPerc = 100 end
                self.bars[bar]:SetMinMaxValues(0, maxPerc)
                self.bars[bar]:SetValue(self.values.perc)
            elseif isDamageTakenView then
                self.bars[bar]:SetMinMaxValues(0, self.values.damage_taken_best > 0 and self.values.damage_taken_best or 1)
            elseif isHealTakenView then
                self.bars[bar]:SetMinMaxValues(0, self.values.best > 0 and self.values.best or 1)
            else
                self.bars[bar]:SetMinMaxValues(0, self.values[template.bar_max])
            end
            if not isThreatView then
                if not isDamageTakenView then
                    self.bars[bar]:SetValue(self.values[template.bar_val])
                else
                    self.bars[bar]:SetValue(self.values.damage_taken_value)
                end
            end
            if template.bar_lower_max and template.bar_lower_val then
                self.bars[bar].lowerBar:SetMinMaxValues(0, self.values[template.bar_lower_max])
                self.bars[bar].lowerBar:SetValue(self.values[template.bar_lower_val])
                self.bars[bar].lowerBar:Show()
            else
                self.bars[bar].lowerBar:Hide()
            end
            self.bars[bar]:SetStatusBarColor(self.values.color.r, self.values.color.g, self.values.color.b)
            if self.bars[bar].lowerBar:IsShown() then
                self.bars[bar].lowerBar:SetStatusBarColor(self.values.color.r, self.values.color.g, self.values.color.b, 0.7)
            end
            self.bars[bar].textLeft:SetText(i .. ". " .. self.values.name)

            local a = template.bar_string_params
            local bar_string = template.bar_string
            local bar_params = a

            if config[wid].view == 1 or ((isBossView or isBossSummaryView) and (config[wid].boss_stat_view or 1) == 1) then
                local showDps = config.show_dps_in_damage == 1
                local showOverkill = config.show_overkill == 1
                local overkill = self.values.overkill or 0
                if showOverkill and overkill > 0 then
                    if showDps then
                        bar_string = "|cffff8888+%s|r (%s)  %s (%.1f%%)"
                        bar_params = { "overkill", "value_persecond", "value", "percent" }
                    else
                        bar_string = "|cffff8888+%s|r %s (%.1f%%)"
                        bar_params = { "overkill", "value", "percent" }
                    end
                else
                    if showDps then
                        bar_string = "(%s)  %s (%.1f%%)"
                        bar_params = { "value_persecond", "value", "percent" }
                    else
                        bar_string = "%s (%.1f%%)"
                        bar_params = { "value", "percent" }
                    end
                end
            end

            -- 计算当前实际视图索引（考虑 BOSS 模式）
            local actualView = config[wid].view
            if isBossView or isBossSummaryView then
                local bossStatMap = { [1]=1, [2]=2, [3]=3, [4]=4, [5]=5, [6]=6, [7]=7, [8]=8, [9]=9, [10]=10, [11]=13, [12]=14, [13]=16, [14]=17, [15]=18 }
                actualView = bossStatMap[config[wid].boss_stat_view or 1] or 1
            end

            -- 治疗视图显示 HPS（勾选"显示HPS（治疗视图）"时生效）
            if config.show_hps_in_heal == 1 then
                if actualView == 3 then
                    bar_string = "|cffcc8888+%s|r (%s) %s (%.1f%%)"
                    bar_params = { "uneffective_value", "value_persecond", "effective_value", "total_heal_percent" }
                elseif actualView == 5 then
                    bar_string = "(%s) %s (%.1f%%)"
                    bar_params = { "effective_value_persecond", "effective_value", "total_effective_percent" }
                elseif actualView == 6 then
                    bar_string = "(%s) %s (%.1f%%)"
                    bar_params = { "uneffective_value_persecond", "uneffective_value", "total_uneffective_percent" }
                end
            end

            if isSunderView then
                bar_string = "%s"
                bar_params = { "sunder_value" }
            end

            local params = {}
            for _, param in ipairs(bar_params) do
                local val = self.values[param]
                -- 对数值类型且不是百分比字段的参数进行缩写
                if type(val) == "number" and not string.find(param, "percent") and not string.find(param, "perc") then
                    val = formatBarNumber(val)
                end
                table.insert(params, val)
            end
            local line = string.format(bar_string, unpack(params))
            self.bars[bar].textRight:SetText(line)

            self.bars[bar]:Show()
            if report and i <= config.report_lines then
                local chat = string.format(template.chat_string,
                    self.values[a[1]], self.values[a[2]], self.values[a[3]], self.values[a[4]], self.values[a[5]])
                table.insert(reportData, i .. ". " .. self.values.name .. " " .. chat)
            end
        end
        i = i + 1
    end

    if report then
        if reportTitle then table.insert(reportData, 1, reportTitle) end
        if table.getn(reportData) > 0 then startReport(reportData) end
    end

    if not isBossView then
        ForceHideBossSubMenu(self.btnSegment)
    end

    self:ApplyVisibilityOverride()
end

local function Resize(self)
    local wid = self:GetID()
    local width = self:GetWidth()
    local height = self:GetTop() - self:GetBottom()
    local bars = (height - 22) / (config.height + config.spacing)
    bars = math.floor(bars)
    if bars < 0 then bars = 0 end
    config[wid].width = width
    if config[wid].bars ~= bars then
        config[wid].bars = bars
        self:Refresh()
    end
end

-- ===========================================================================
-- 创建单个主窗口
-- ===========================================================================
local function CreateWindow(wid)
    config[wid] = config[wid] or {}
    config[wid].bars = config[wid].bars or 8
    config[wid].width = config[wid].width or 177
    config[wid].segment = config[wid].segment or 1
    config[wid].view = config[wid].view or 1
    config[wid].boss_stat_view = config[wid].boss_stat_view or 1

    local frame = CreateFrame("Frame", "ShaguDPSWindow" .. (wid == 1 and "" or wid), UIParent)
    frame.scroll = 0
    frame.GetCaps = GetCaps
    frame.GetData = GetData
    frame.Refresh = Refresh
    frame.Resize = Resize
    frame.isEnergizeView = false
    frame.isInvalidDamageView = false
    frame.isHealTakenView = false

    frame.LoadPosition = function()
        if ShaguDPS_Config and ShaguDPS_Config[frame:GetID()] and ShaguDPS_Config[frame:GetID()].pos then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", unpack(ShaguDPS_Config[frame:GetID()].pos))
        else
            frame:ClearAllPoints()
            frame:SetPoint("RIGHT", UIParent, "RIGHT", -100, -100)
        end
    end

    frame.ApplyVisibilityOverride = function(self)
        if not self then return end
        local wid = self:GetID()
        if config.visible ~= 1 then return end
        local condition = config.hide_nondefault_threat_out_of_combat == 1
        if condition and wid ~= 1 and config[wid] and config[wid].view == 11 then
            local inPartyOrRaid = (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
            local inCombat = UnitAffectingCombat("player")
            if not inPartyOrRaid or not inCombat then
                self:Hide()
                return
            end
        end
        self:Show()
    end

    frame:SetID(wid)
    frame:EnableMouse(true)
    frame:EnableMouseWheel(1)
    frame:SetResizable(true)
    frame:SetMinResize(177, 22)
    frame:RegisterForDrag("LeftButton")
    frame:SetMovable(true)
    frame:SetScript("OnDragStart", function()
        if config.lock == 0 then frame:StartMoving() end
    end)
    frame:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
        ShaguDPS_Config[frame:GetID()].pos = { frame:GetCenter() }
    end)
    frame:SetScript("OnMouseWheel", barScrollWheel)
    frame:SetClampedToScreen(true)

    frame:SetScript("OnUpdate", function()
        if this.sizing then this:Resize() end
        if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .2 end
        if config.lock == 0 and MouseIsOver(this) then
            this.btnResize:SetAlpha(.5)
        else
            this.btnResize:SetAlpha(0)
        end
        if this.needs_refresh then
            this.needs_refresh = nil
            this:Refresh()
        end
    end)

    frame:RegisterEvent("PLAYER_LOGIN")
    frame:SetScript("OnEvent", frame.LoadPosition)
    frame.LoadPosition()

    frame.title = frame:CreateTexture(nil, "NORMAL")
    frame.title:SetTexture(0,0,0,.6)
    frame.title:SetHeight(20)
    frame.title:SetPoint("TOPLEFT", 2, -2)
    frame.title:SetPoint("TOPRIGHT", -2, -2)

    -- 左侧分段/视图选择按钮 (包含当前、全程、BOSS、BOSS汇总)
    frame.btnSegment = CreateFrame("Button", "ShaguDPSDamage", frame)
    frame.btnSegment:SetPoint("RIGHT", frame.title, "CENTER", -.5, 0)
    frame.btnSegment:SetFrameStrata("MEDIUM")
    frame.btnSegment:SetHeight(16)
    frame.btnSegment:SetWidth(50)
    frame.btnSegment:SetBackdrop(backdrop)
    frame.btnSegment:SetBackdropColor(.2,.2,.2,1)
    frame.btnSegment:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnSegment.caption = frame.btnSegment:CreateFontString("ShaguDPSTitle", "OVERLAY", "GameFontWhite")
    frame.btnSegment.caption:SetFont(STANDARD_TEXT_FONT, 9)
    frame.btnSegment.caption:SetText("当前")
    frame.btnSegment.caption:SetAllPoints()
    frame.btnSegment.tooltip = { "选择时间段/视图", "|cffffffff当前, 全程, BOSS, BOSS汇总" }
    frame.btnSegment:SetScript("OnEnter", btnEnter)
    frame.btnSegment:SetScript("OnLeave", btnLeave)
    frame.btnSegment:SetScript("OnClick", function()
        if frame.btnOverall:IsShown() then
            frame.btnOverall:Hide()
            frame.btnCurrent:Hide()
            frame.btnBossMenu:Hide()
            frame.btnBossSummaryMenu:Hide()
        else
            frame.btnOverall:Show()
            frame.btnCurrent:Show()
            if ShaguDPS.hasNampower then
                frame.btnBossMenu:Show()
                frame.btnBossSummaryMenu:Show()
            end
            -- 隐藏右侧菜单按钮（仅隐藏当前 menubuttons 中的按钮）
            for bname in pairs(menubuttons) do
                if bname ~= "Current" and bname ~= "Overall" then
                    frame["btn"..bname]:Hide()
                end
            end
        end
    end)

    -- 左侧菜单项：全程
    frame.btnOverall = CreateFrame("Button", "ShaguDPSOverall", frame)
    local yOffsetOverall = -17 - 1 * 14
    if config.menu_grow_upwards == 1 then
        yOffsetOverall = 17 + 1 * 14
    end
    frame.btnOverall:SetPoint("CENTER", frame.title, "CENTER", -25.5, yOffsetOverall)
    frame.btnOverall:SetFrameStrata("HIGH")
    frame.btnOverall:SetHeight(16)
    frame.btnOverall:SetWidth(50)
    frame.btnOverall:SetBackdrop(backdrop)
    frame.btnOverall:SetBackdropColor(.2,.2,.2,1)
    frame.btnOverall:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnOverall:Hide()
    frame.btnOverall.caption = frame.btnOverall:CreateFontString("ShaguDPSOverallTitle", "OVERLAY", "GameFontWhite")
    frame.btnOverall.caption:SetFont(STANDARD_TEXT_FONT, 9)
    frame.btnOverall.caption:SetText("全程")
    frame.btnOverall.caption:SetAllPoints()
    frame.btnOverall.tooltip = { "全程数据", "|cffffffff显示全程的总数据" }
    frame.btnOverall:SetScript("OnEnter", btnEnter)
    frame.btnOverall:SetScript("OnLeave", btnLeave)
    frame.btnOverall:SetScript("OnClick", function()
        config[frame:GetID()].segment = 0
        if config[frame:GetID()].view == 12 or config[frame:GetID()].view == 15 then
            config[frame:GetID()].view = 1  -- 从BOSS视图切换回普通视图
        end
        frame.scroll = 0
        frame:Refresh(true)
        frame.btnOverall:Hide()
        frame.btnCurrent:Hide()
        frame.btnBossMenu:Hide()
        frame.btnBossSummaryMenu:Hide()
    end)

    -- 左侧菜单项：当前
    frame.btnCurrent = CreateFrame("Button", "ShaguDPSCurrent", frame)
    local yOffsetCurrent = -17 - 0 * 14
    if config.menu_grow_upwards == 1 then
        yOffsetCurrent = 17 + 0 * 14
    end
    frame.btnCurrent:SetPoint("CENTER", frame.title, "CENTER", -25.5, yOffsetCurrent)
    frame.btnCurrent:SetFrameStrata("HIGH")
    frame.btnCurrent:SetHeight(16)
    frame.btnCurrent:SetWidth(50)
    frame.btnCurrent:SetBackdrop(backdrop)
    frame.btnCurrent:SetBackdropColor(.2,.2,.2,1)
    frame.btnCurrent:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnCurrent:Hide()
    frame.btnCurrent.caption = frame.btnCurrent:CreateFontString("ShaguDPSCurrentTitle", "OVERLAY", "GameFontWhite")
    frame.btnCurrent.caption:SetFont(STANDARD_TEXT_FONT, 9)
    frame.btnCurrent.caption:SetText("当前")
    frame.btnCurrent.caption:SetAllPoints()
    frame.btnCurrent.tooltip = { "当前战斗数据", "|cffffffff显示当前战斗的数据" }
    frame.btnCurrent:SetScript("OnEnter", btnEnter)
    frame.btnCurrent:SetScript("OnLeave", btnLeave)
    frame.btnCurrent:SetScript("OnClick", function()
        config[frame:GetID()].segment = 1
        if config[frame:GetID()].view == 12 or config[frame:GetID()].view == 15 then
            config[frame:GetID()].view = 1
        end
        frame.scroll = 0
        frame:Refresh(true)
        frame.btnOverall:Hide()
        frame.btnCurrent:Hide()
        frame.btnBossMenu:Hide()
        frame.btnBossSummaryMenu:Hide()
    end)

    if ShaguDPS.hasNampower then
        -- 左侧菜单项：BOSS
        frame.btnBossMenu = CreateFrame("Button", "ShaguDPSBossMenu", frame)
        local yOffsetBoss = -17 - 2 * 14
        if config.menu_grow_upwards == 1 then
            yOffsetBoss = 17 + 2 * 14
        end
        frame.btnBossMenu:SetPoint("CENTER", frame.title, "CENTER", -25.5, yOffsetBoss)
        frame.btnBossMenu:SetFrameStrata("HIGH")
        frame.btnBossMenu:SetHeight(16)
        frame.btnBossMenu:SetWidth(50)
        frame.btnBossMenu:SetBackdrop(backdrop)
        frame.btnBossMenu:SetBackdropColor(.2,.2,.2,1)
        frame.btnBossMenu:SetBackdropBorderColor(.4,.4,.4,1)
        frame.btnBossMenu:Hide()
        frame.btnBossMenu.caption = frame.btnBossMenu:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        frame.btnBossMenu.caption:SetFont(STANDARD_TEXT_FONT, 9)
        frame.btnBossMenu.caption:SetText("BOSS")
        frame.btnBossMenu.caption:SetAllPoints()
        frame.btnBossMenu.tooltip = { "BOSS战记录", "|cffffffff查看BOSS战记录" }
        frame.btnBossMenu:SetScript("OnEnter", btnEnter)
        frame.btnBossMenu:SetScript("OnLeave", btnLeave)
        frame.btnBossMenu:SetScript("OnClick", function()
            config[frame:GetID()].view = 12
            ShaguDPS.current_boss_index = nil
            frame.scroll = 0
            frame:Refresh(true)
            frame.btnOverall:Hide()
            frame.btnCurrent:Hide()
            frame.btnBossMenu:Hide()
            frame.btnBossSummaryMenu:Hide()
        end)

        -- 左侧菜单项：BOSS汇总
        frame.btnBossSummaryMenu = CreateFrame("Button", "ShaguDPSBossSummaryMenu", frame)
        local yOffsetBossSum = -17 - 3 * 14
        if config.menu_grow_upwards == 1 then
            yOffsetBossSum = 17 + 3 * 14
        end
        frame.btnBossSummaryMenu:SetPoint("CENTER", frame.title, "CENTER", -25.5, yOffsetBossSum)
        frame.btnBossSummaryMenu:SetFrameStrata("HIGH")
        frame.btnBossSummaryMenu:SetHeight(16)
        frame.btnBossSummaryMenu:SetWidth(50)
        frame.btnBossSummaryMenu:SetBackdrop(backdrop)
        frame.btnBossSummaryMenu:SetBackdropColor(.2,.2,.2,1)
        frame.btnBossSummaryMenu:SetBackdropBorderColor(.4,.4,.4,1)
        frame.btnBossSummaryMenu:Hide()
        frame.btnBossSummaryMenu.caption = frame.btnBossSummaryMenu:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        frame.btnBossSummaryMenu.caption:SetFont(STANDARD_TEXT_FONT, 9)
        frame.btnBossSummaryMenu.caption:SetText("BOSS汇总")
        frame.btnBossSummaryMenu.caption:SetAllPoints()
        frame.btnBossSummaryMenu.tooltip = { "BOSS汇总", "|cffffffff查看所有BOSS战汇总数据" }
        frame.btnBossSummaryMenu:SetScript("OnEnter", btnEnter)
        frame.btnBossSummaryMenu:SetScript("OnLeave", btnLeave)
        frame.btnBossSummaryMenu:SetScript("OnClick", function()
            config[frame:GetID()].view = 15
            frame.scroll = 0
            frame:Refresh(true)
            frame.btnOverall:Hide()
            frame.btnCurrent:Hide()
            frame.btnBossMenu:Hide()
            frame.btnBossSummaryMenu:Hide()
            -- 隐藏右侧菜单按钮
            for bname in pairs(menubuttons) do
                if bname ~= "Current" and bname ~= "Overall" then
                    frame["btn"..bname]:Hide()
                end
            end
        end)
    end

    -- 右侧模式按钮
    frame.btnMode = CreateFrame("Button", "ShaguDPSDamage", frame)
    frame.btnMode:SetPoint("LEFT", frame.title, "CENTER", .5, 0)
    frame.btnMode:SetFrameStrata("MEDIUM")
    frame.btnMode:SetHeight(16)
    frame.btnMode:SetWidth(50)
    frame.btnMode:SetBackdrop(backdrop)
    frame.btnMode:SetBackdropColor(.2,.2,.2,1)
    frame.btnMode:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnMode.caption = frame.btnMode:CreateFontString("ShaguDPSTitle", "OVERLAY", "GameFontWhite")
    frame.btnMode.caption:SetFont(STANDARD_TEXT_FONT, 9)
    frame.btnMode.caption:SetText("伤害量")
    frame.btnMode.caption:SetAllPoints()
    frame.btnMode.tooltip = { "选择统计类型", "|cffffffff伤害量, DPS, 治疗量, HPS" .. (ShaguDPS.hasNampower and ", 有效治疗, 过量治疗, 死亡, 技能施放, 误伤, 驱散, 仇恨, 破甲, 承受伤害, 能量回复, 无效伤害, 受到治疗" or "") }
    frame.btnMode:SetScript("OnEnter", btnEnter)
    frame.btnMode:SetScript("OnLeave", btnLeave)
    frame.btnMode:SetScript("OnClick", function()
        if frame.btnDamage:IsShown() then
            for bname in pairs(menubuttons) do
                if bname ~= "Current" and bname ~= "Overall" then
                    frame["btn"..bname]:Hide()
                end
            end
            frame.btnOverall:Hide(); frame.btnCurrent:Hide()
            if ShaguDPS.hasNampower then
                frame.btnBossMenu:Hide(); frame.btnBossSummaryMenu:Hide()
            end
        else
            for bname in pairs(menubuttons) do
                if bname ~= "Current" and bname ~= "Overall" then
                    frame["btn"..bname]:Show()
                end
            end
            frame.btnOverall:Hide(); frame.btnCurrent:Hide()
            if ShaguDPS.hasNampower then
                frame.btnBossMenu:Hide(); frame.btnBossSummaryMenu:Hide()
            end
        end
    end)

    -- BOSS 翻页按钮
    if ShaguDPS.hasNampower then
        frame.btnBossPrev = CreateFrame("Button", nil, frame)
        frame.btnBossPrev:SetPoint("LEFT", frame.btnMode, "RIGHT", 2, 0)
        frame.btnBossPrev:SetWidth(16); frame.btnBossPrev:SetHeight(16)
        frame.btnBossPrev:SetBackdrop(backdrop); frame.btnBossPrev:SetBackdropColor(.2,.2,.2,1); frame.btnBossPrev:SetBackdropBorderColor(.4,.4,.4,1)
        frame.btnBossPrev.caption = frame.btnBossPrev:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        frame.btnBossPrev.caption:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE"); frame.btnBossPrev.caption:SetText("<"); frame.btnBossPrev.caption:SetAllPoints()
        frame.btnBossPrev.tooltip = { "上一场BOSS战", "|cffffffff切换到上一个BOSS战记录" }
        frame.btnBossPrev:SetScript("OnClick", function()
            local fights = ShaguDPS.boss_fights
            if table.getn(fights) == 0 then return end
            local idx = (ShaguDPS.current_boss_index or 1) - 1
            if idx < 1 then idx = table.getn(fights) end
            ShaguDPS.current_boss_index = idx
            config[frame:GetID()].view = 12
            frame:Refresh(true)
        end)
        frame.btnBossNext = CreateFrame("Button", nil, frame)
        frame.btnBossNext:SetPoint("LEFT", frame.btnBossPrev, "RIGHT", 2, 0)
        frame.btnBossNext:SetWidth(16); frame.btnBossNext:SetHeight(16)
        frame.btnBossNext:SetBackdrop(backdrop); frame.btnBossNext:SetBackdropColor(.2,.2,.2,1); frame.btnBossNext:SetBackdropBorderColor(.4,.4,.4,1)
        frame.btnBossNext.caption = frame.btnBossNext:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        frame.btnBossNext.caption:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE"); frame.btnBossNext.caption:SetText(">"); frame.btnBossNext.caption:SetAllPoints()
        frame.btnBossNext.tooltip = { "下一场BOSS战", "|cffffffff切换到下一个BOSS战记录" }
        frame.btnBossNext:SetScript("OnClick", function()
            local fights = ShaguDPS.boss_fights
            if table.getn(fights) == 0 then return end
            local idx = (ShaguDPS.current_boss_index or 1) + 1
            if idx > table.getn(fights) then idx = 1 end
            ShaguDPS.current_boss_index = idx
            config[frame:GetID()].view = 12
            frame:Refresh(true)
        end)
        frame.btnBossPrev:SetScript("OnEnter", btnEnter); frame.btnBossPrev:SetScript("OnLeave", btnLeave)
        frame.btnBossNext:SetScript("OnEnter", btnEnter); frame.btnBossNext:SetScript("OnLeave", btnLeave)
        frame.btnBossPrev:Hide(); frame.btnBossNext:Hide()
    end

    -- 创建右侧视图按钮（伤害量、DPS、治疗量等）
    for name, tmpl in pairs(menubuttons) do
        if name ~= "Current" and name ~= "Overall" then
            local template = tmpl
            frame["btn"..name] = CreateFrame("Button", "ShaguDPS" .. name, frame)
            local button = frame["btn"..name]
            local yOffset = -17 - template[1] * 14
            if config.menu_grow_upwards == 1 then
                yOffset = 17 + template[1] * 14
            end
            button:SetPoint("CENTER", frame.title, "CENTER", template[3], yOffset)
            button:SetFrameStrata("HIGH"); button:SetHeight(16); button:SetWidth(50)
            button:SetBackdrop(backdrop); button:SetBackdropColor(.2,.2,.2,1); button:SetBackdropBorderColor(.4,.4,.4,1)
            button:Hide()
            button.caption = button:CreateFontString("ShaguDPS"..name.."Title", "OVERLAY", "GameFontWhite")
            button.caption:SetFont(STANDARD_TEXT_FONT, 9); button.caption:SetText(template[4]); button.caption:SetAllPoints()
            button.tooltip = { template[4], template[5] }
            button:SetScript("OnEnter", btnEnter); button:SetScript("OnLeave", btnLeave)
            button:SetScript("OnClick", function()
                local wid = frame:GetID()
                local curView = config[wid].view
                if (curView == 12 or curView == 15) and template[6] == "view" then
                    -- BOSS / BOSS汇总模式下，设置 boss_stat_view
                    local statMap = {
                        [1]=1, [2]=2, [3]=3, [4]=4, [5]=5,
                        [6]=6, [7]=7, [8]=8, [9]=9,
                        [10]=10, [13]=11, [14]=12, [16]=13, [17]=14, [18]=15
                    }
                    local sv = statMap[template[2]]
                    if sv then
                        config[wid].boss_stat_view = sv
                    end
                else
                    config[wid][template[6]] = template[2]
                end
                frame.scroll = 0
                frame:Refresh(true)
                for bname in pairs(menubuttons) do
                    if bname ~= "Current" and bname ~= "Overall" then
                        frame["btn"..bname]:Hide()
                    end
                end
            end)
        end
    end

    -- 发送、设置、重置、窗口增减按钮
    frame.btnAnnounce = CreateFrame("Button", "ShaguDPSReset", frame)
    frame.btnAnnounce:SetPoint("LEFT", frame.title, "LEFT", 2, 0)
    frame.btnAnnounce:SetFrameStrata("MEDIUM"); frame.btnAnnounce:SetHeight(16); frame.btnAnnounce:SetWidth(16)
    frame.btnAnnounce:SetBackdrop(backdrop); frame.btnAnnounce:SetBackdropColor(.2,.2,.2,1); frame.btnAnnounce:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnAnnounce.tooltip = { "发送到聊天", { "|cffffffff点击", "|cffaaaaaa询问发送数据"}, { "|cffffffffShift+点击", "|cffaaaaaa直接发送数据"} }
    frame.btnAnnounce.tex = frame.btnAnnounce:CreateTexture(); frame.btnAnnounce.tex:SetWidth(10); frame.btnAnnounce.tex:SetHeight(10); frame.btnAnnounce.tex:SetPoint("CENTER", 0, 0)
    frame.btnAnnounce.tex:SetTexture("Interface\\AddOns\\ShaguDPS" .. (tbc and "-tbc" or "") .. "\\img\\announce")
    frame.btnAnnounce:SetScript("OnEnter", btnEnter); frame.btnAnnounce:SetScript("OnLeave", btnLeave)
    frame.btnAnnounce:SetScript("OnClick", function()
        if IsShiftKeyDown() then
            frame:Refresh(nil, true)
        else
            local ctype = tbc and ChatFrameEditBox:GetAttribute("chatType") or ChatFrameEditBox.chatType
            local color = chatcolors[ctype] or "|cff00FAF6"
            local name = view_templates[config[frame:GetID()].view].name
            local text = "发送 |cffffdd00" .. name .. "|r 数据到 /" .. color..string.lower(ctype) .. "|r?"
            local dialog = StaticPopupDialogs["SHAGUMETER_QUESTION"]
            dialog.text = text
            dialog.OnAccept = function() frame:Refresh(nil, true) end
            StaticPopup_Show("SHAGUMETER_QUESTION")
        end
    end)

    frame.btnSettings = CreateFrame("Button", "ShaguDPSReset", frame)
    frame.btnSettings:SetPoint("LEFT", frame.btnAnnounce, "RIGHT", 1, 0)
    frame.btnSettings:SetFrameStrata("MEDIUM"); frame.btnSettings:SetHeight(16); frame.btnSettings:SetWidth(16)
    frame.btnSettings:SetBackdrop(backdrop); frame.btnSettings:SetBackdropColor(.2,.2,.2,1); frame.btnSettings:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnSettings.tooltip = { "设置", "|cffffffff显示设置窗口" }
    frame.btnSettings.tex = frame.btnSettings:CreateTexture(); frame.btnSettings.tex:SetWidth(10); frame.btnSettings.tex:SetHeight(10); frame.btnSettings.tex:SetPoint("CENTER", 0, 0)
    frame.btnSettings.tex:SetTexture("Interface\\AddOns\\ShaguDPS" .. (tbc and "-tbc" or "") .. "\\img\\settings")
    frame.btnSettings:SetScript("OnEnter", btnEnter); frame.btnSettings:SetScript("OnLeave", btnLeave)
    frame.btnSettings:SetScript("OnClick", function()
        if ShaguDPS.settings:IsShown() then ShaguDPS.settings:Hide() else ShaguDPS.settings:Show() end
    end)

    frame.btnReset = CreateFrame("Button", "ShaguDPSReset", frame)
    frame.btnReset:SetPoint("RIGHT", frame.title, "RIGHT", -2, 0)
    frame.btnReset:SetFrameStrata("MEDIUM"); frame.btnReset:SetHeight(16); frame.btnReset:SetWidth(16)
    frame.btnReset:SetBackdrop(backdrop); frame.btnReset:SetBackdropColor(.2,.2,.2,1); frame.btnReset:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnReset.tooltip = { "清空数据", { "|cffffffff点击", "|cffaaaaaa询问清空数据"}, { "|cffffffffShift+点击", "|cffaaaaaa直接清空数据"} }
    frame.btnReset.tex = frame.btnReset:CreateTexture(); frame.btnReset.tex:SetWidth(10); frame.btnReset.tex:SetHeight(10); frame.btnReset.tex:SetPoint("CENTER", 0, 0)
    frame.btnReset.tex:SetTexture("Interface\\AddOns\\ShaguDPS" .. (tbc and "-tbc" or "") .. "\\img\\reset")
    frame.btnReset:SetScript("OnEnter", btnEnter); frame.btnReset:SetScript("OnLeave", btnLeave)
    frame.btnReset:SetScript("OnClick", function()
        if IsShiftKeyDown() then ResetData()
        else
            local dialog = StaticPopupDialogs["SHAGUMETER_QUESTION"]
            dialog.text = "你确认需要清空数据吗？"
            dialog.OnAccept = ResetData
            StaticPopup_Show("SHAGUMETER_QUESTION")
        end
    end)

    frame.btnWindow = CreateFrame("Button", "ShaguDPSReset", frame)
    frame.btnWindow:SetPoint("RIGHT", frame.btnReset, "LEFT", -1, 0)
    frame.btnWindow:SetFrameStrata("MEDIUM"); frame.btnWindow:SetHeight(16); frame.btnWindow:SetWidth(16)
    frame.btnWindow:SetBackdrop(backdrop); frame.btnWindow:SetBackdropColor(.2,.2,.2,1); frame.btnWindow:SetBackdropBorderColor(.4,.4,.4,1)
    frame.btnWindow.tex = frame.btnWindow:CreateTexture(); frame.btnWindow.tex:SetWidth(10); frame.btnWindow.tex:SetHeight(10); frame.btnWindow.tex:SetPoint("CENTER", 0, 0)
    if frame:GetID() == 1 then
        frame.btnWindow.tex:SetTexture("Interface\\AddOns\\ShaguDPS" .. (tbc and "-tbc" or "") .. "\\img\\plus")
        frame.btnWindow.tooltip = { "新增窗口", "|cffffffff创建一个新窗口" }
        frame.btnWindow:SetScript("OnClick", function()
            for i=1,10 do if not ShaguDPS.window[i] then ShaguDPS.window[i] = CreateWindow(i) ShaguDPS.window.Refresh(true) return end end
        end)
    else
        frame.btnWindow.tex:SetTexture("Interface\\AddOns\\ShaguDPS" .. (tbc and "-tbc" or "") .. "\\img\\minus")
        frame.btnWindow.tooltip = { "删除窗口", "|cffffffff删除这个窗口" }
        frame.btnWindow:SetScript("OnClick", function()
            local wid = frame:GetID()
            window[wid]:Hide(); window[wid] = nil; config[wid] = nil
            window.Refresh(true)
        end)
    end
    frame.btnWindow:SetScript("OnEnter", btnEnter); frame.btnWindow:SetScript("OnLeave", btnLeave)

    frame.btnResize = CreateFrame("Frame", nil, frame)
    frame.btnResize:SetPoint("BOTTOMRIGHT", -3, 3); frame.btnResize:SetWidth(12); frame.btnResize:SetHeight(12); frame.btnResize:EnableMouse(1)
    frame.btnResize.tex = frame.btnResize:CreateTexture(nil, "BACKGROUND"); frame.btnResize.tex:SetAllPoints()
    frame.btnResize.tex:SetTexture("Interface\\AddOns\\ShaguDPS" .. (tbc and "-tbc" or "") .. "\\img\\resize")
    frame.btnResize:SetFrameLevel(50)
    frame.btnResize:SetScript("OnMouseDown", function()
        if not this:GetParent().sizing and config.lock == 0 then
            this:GetParent().sizing = true
            this:GetParent():StartSizing()
        end
    end)
    frame.btnResize:SetScript("OnMouseUp", function()
        this:GetParent().sizing = nil
        this:GetParent():StopMovingOrSizing()
        this:GetParent():Refresh(true)
    end)

    frame.border = CreateFrame("Frame", "ShaguDPSBorder", frame)
    frame.border:ClearAllPoints()
    frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1,1)
    frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1,-1)
    frame.border:SetFrameLevel(100)

    frame.bars = {}
    frame.values = {}
    -- 构建 buttons 列表（用于颜色重置等操作），只包含实际存在的右侧按钮
    frame.buttons = { frame.btnDamage, frame.btnDPS, frame.btnHeal, frame.btnHPS, frame.btnOverall, frame.btnCurrent }
    if ShaguDPS.hasNampower then
        table.insert(frame.buttons, frame.btnEffHeal); table.insert(frame.buttons, frame.btnOverHeal)
        table.insert(frame.buttons, frame.btnDeath); table.insert(frame.buttons, frame.btnSpellcast)
        table.insert(frame.buttons, frame.btnFriendlyFire); table.insert(frame.buttons, frame.btnDispel)
        table.insert(frame.buttons, frame.btnThreat); table.insert(frame.buttons, frame.btnSunder)
        table.insert(frame.buttons, frame.btnDamageTaken)
        table.insert(frame.buttons, frame.btnEnergize)
        table.insert(frame.buttons, frame.btnInvalidDamage)
        table.insert(frame.buttons, frame.btnHealTaken)
    end

    table.insert(parser.callbacks.refresh, function()
        frame.needs_refresh = true
    end)

    return frame
end

-- 初始化第一个窗口
window[1] = window[1] or CreateWindow(1)

window.Refresh = function(force, report)
    for i=1,10 do
        if config[i] then
            window[i] = window[i] or CreateWindow(i)
            window[i]:Refresh(force, report)
        end
    end
end

window.Refresh(true)

-- 监听战斗状态和队伍变化
local threatVisibilityFrame = CreateFrame("Frame")
threatVisibilityFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
threatVisibilityFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
threatVisibilityFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
threatVisibilityFrame:RegisterEvent("RAID_ROSTER_UPDATE")
threatVisibilityFrame:SetScript("OnEvent", function()
    for i = 1, 10 do
        if window[i] then
            window[i]:ApplyVisibilityOverride()
        end
    end
end)

-- =========================================================================
-- 自动清空数据提示：进入新队伍/团队时询问
-- =========================================================================
local autoResetFrame = CreateFrame("Frame")
autoResetFrame.inPartyRaid = false   -- 当前是否在队伍/团队中

autoResetFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
autoResetFrame:RegisterEvent("RAID_ROSTER_UPDATE")
autoResetFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

autoResetFrame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        -- 登录时只记录状态，不弹窗
        local inGroup = (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
        this.inPartyRaid = inGroup
        return
    end

    local inGroup = (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
    if inGroup and not this.inPartyRaid then
        -- 刚刚加入队伍/团队
        this.inPartyRaid = true
        if ShaguDPS.config.auto_reset_on_new_group ~= 0 then
            local dialog = StaticPopupDialogs["SHAGUMETER_QUESTION"]
            dialog.text = "你已加入新的队伍/团队，是否清空历史数据？"
            dialog.OnAccept = function()
                ResetData()
            end
            StaticPopup_Show("SHAGUMETER_QUESTION")
        end
    elseif not inGroup then
        -- 不在任何队伍中，重置标记
        this.inPartyRaid = false
    end
end)