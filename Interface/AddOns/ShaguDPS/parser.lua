--[[
    ShaguDPS 事件解析模块
    当 Nampower 可用时，监听其自定义事件（如伤害、治疗、驱散等）来更新统计。
    如果 Nampower 不可用，则回退到 parser-vanilla.lua 中的战斗日志解析方式。

    注意：本文件大量依赖 Nampower 4.5+ 的事件参数，详见 EVENTS.md。
]]

-- 将公共变量缓存到本地以提高访问速度
local parser = ShaguDPS.parser

local data = ShaguDPS.data
local config = ShaguDPS.config
local round = ShaguDPS.round
local healthCache = {}  -- 用于计算溢出伤害的单位血量缓存 { [guid] = 剩余血量 }

-- 检测 Nampower 可用性（同时参考 core.lua 中的 hasNampower）
ShaguDPS.hasNampower = GetNampowerVersion and true or false

-- ===========================================================================
-- 深度拷贝函数（用于在战斗结束时保存当前段数据快照）
-- ===========================================================================
local function deepcopy(original)
    if type(original) ~= "table" then return original end
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = deepcopy(v)
    end
    return copy
end

-- ===========================================================================
-- 未知名称延迟处理机制
-- 当单位名称尚未加载时（如刚进入视野），先将事件缓存，待名称可用后再处理。
-- ===========================================================================
parser.pendingEvents = {}
parser.nextProcessTime = 0
parser.pendingEventId = 0

-- 判断名称是否为未知（尚未从服务器获取）
local function isUnknownName(name)
    if not name or name == "" then return true end
    if name == "未知目标" or name == "Unknown" then return true end
    return false
end

-- 调度一个待处理事件，等待 guid 列表中的单位名称可用后执行
-- @param func 原始处理函数
-- @param args 参数表（table），用于后续 unpack 调用
-- @param guids 需要监控的 GUID 列表（table），只要任一 GUID 名字未知就继续等待
function parser:ScheduleEvent(func, args, guids)
    self.pendingEventId = self.pendingEventId + 1
    self.pendingEvents[self.pendingEventId] = {
        id = self.pendingEventId,
        func = func,
        args = args,
        guids = guids,
        createTime = GetTime(),   -- 记录创建时间，超过 3 秒则丢弃
    }
    if self.nextProcessTime == 0 then
        self.nextProcessTime = GetTime() + 0.5   -- 0.5 秒后首次检查
    end
end

-- 处理所有待处理事件（在 OnUpdate 中调用）
local function processPendingEvents()
    local now = GetTime()
    local anyRemaining = false
    for id, event in pairs(parser.pendingEvents) do
        if now - event.createTime > 3 then
            -- 超过 3 秒仍未获得名称，丢弃该事件
            parser.pendingEvents[id] = nil
        else
            local allReady = true
            for _, guid in ipairs(event.guids) do
                if isUnknownName(UnitName(guid)) then
                    allReady = false
                    break
                end
            end
            if allReady then
                -- 所有名称已就绪，执行原处理函数
                event.func(unpack(event.args))
                parser.pendingEvents[id] = nil
            else
                anyRemaining = true
            end
        end
    end
    if anyRemaining then
        parser.nextProcessTime = now + 0.5
    else
        parser.nextProcessTime = 0
    end
end

parser:SetScript("OnUpdate", function()
    if parser.nextProcessTime == 0 then return end
    if GetTime() >= parser.nextProcessTime then
        processPendingEvents()
    end
end)

-- 清空所有待处理事件（战斗结束时调用）
function parser:FlushPendingEvents()
    for id, _ in pairs(self.pendingEvents) do
        self.pendingEvents[id] = nil
    end
    self.nextProcessTime = 0
end

-- ===========================================================================
-- 单位 Token 定义（用于判断单位是否属于小队/团队/宠物）
-- ===========================================================================
local validUnits = { ["player"] = true }
for i = 1, 4 do validUnits["party" .. i] = true end
for i = 1, 40 do validUnits["raid" .. i] = true end

local validPets = { ["pet"] = true }
for i = 1, 4 do validPets["partypet" .. i] = true end
for i = 1, 40 do validPets["raidpet" .. i] = true end

-- ===========================================================================
-- 宠物拥有者获取（用于数据合并）
-- ===========================================================================
-- 根据宠物的 GUID 获取拥有者信息
-- @param petGUID 宠物的 GUID 字符串
-- @return ownerName (主人名称), petType ("pet" 或 "charm"), ownerGUID (主人 GUID)
local function GetOwnerInfoFromPetGUID(petGUID)
    if not petGUID then return nil, nil end
    -- 尝试通过 Nampower 扩展的单位路径获得主人
    local ownerGUID = GetUnitGUID(petGUID .. "owner")
    if ownerGUID then
        return UnitName(ownerGUID), "pet", ownerGUID
    end
    -- 如果无法直接获得，使用 Nampower 的 GetUnitField 尝试获取 charm/createdBy 字段
    if ShaguDPS.hasNampower then
        local charm = GetUnitField(petGUID, "charm")
        if charm and charm ~= "0x0000000000000000" then
            if UnitName(charm .. "owner") then
                return UnitName(charm .. "owner"), "charm", charm
            else
                return UnitName(charm), "charm", charm
            end
        end
        local createdBy = GetUnitField(petGUID, "createdBy")
        if createdBy and createdBy ~= "0x0000000000000000" then
            return UnitName(createdBy), "pet", createdBy
        end
    end
    return nil, nil, nil
end

local function GetOwnerNameFromPetGUID(petGUID)
    local owner, _ = GetOwnerInfoFromPetGUID(petGUID)
    return owner
end

-- ===========================================================================
-- 战斗状态检测
-- ===========================================================================
local start_next_segment = nil  -- 未使用？保留，可能用于外部重置段触发器
local combat_start_time = 0     -- 进入战斗时的时间戳
-- 本场战斗中死亡的首领列表
local diedBossesThisFight = {}

-- 判断玩家自身或任何团队成员是否处于战斗状态
local function combat()
    if UnitAffectingCombat("player") or UnitAffectingCombat("pet") then return true end
    local raid = GetNumRaidMembers()
    local group = GetNumPartyMembers()
    if raid >= 1 then
        for i = 1, raid do
            if UnitAffectingCombat("raid" .. i) or UnitAffectingCombat("raidpet" .. i) then return true end
        end
    else
        for i = 1, group do
            if UnitAffectingCombat("party" .. i) or UnitAffectingCombat("partypet" .. i) then return true end
        end
    end
    return nil
end

-- 重置当前战斗段数据（进入战斗前调用）
local function resetCurrentSegment()
    data["damage"][1] = {}
    data["heal"][1] = {}
    data["death"][1] = {}
    data["spellcast"][1] = {}
    data["friendly_fire"][1] = {}
    data["dispel"][1] = {}
    data["sunder"][1] = {}
    data["damage_taken"][1] = {}
    data["energize"][1] = {}
    data["invalid_damage"][1] = {}
    data["heal_taken"][1] = {}
    data["dot_ticks"][1] = {}
    start_next_segment = nil
    parser.extraAttacks = {}
end

-- 战斗状态监视框架
parser.combat = CreateFrame("Frame", "ShaguDPSCombatState", UIParent)
parser.combat:RegisterEvent("PLAYER_REGEN_DISABLED")  -- 进入战斗
parser.combat:RegisterEvent("PLAYER_REGEN_ENABLED")   -- 脱离战斗

function parser.combat:UpdateState()
    local state = combat() == true and "COMBAT" or "NO_COMBAT"
    if not self.oldstate or self.oldstate ~= state then
        self.oldstate = state
        if state == "NO_COMBAT" then
            -- 战斗结束，记录战斗时长
            if data.combat_start_time > 0 then
                data.last_fight_duration = GetTime() - data.combat_start_time
                data.combat_start_time = 0
            else
                data.last_fight_duration = 0
            end
            -- 累加总战斗时长
            data.total_combat_time = (data.total_combat_time or 0) + data.last_fight_duration
            -- 战斗结束：将当前段数据深拷贝到缓存，并重置当前段
            healthCache = {}
            if next(data.damage[1]) then ShaguDPS.cached_current_damage = deepcopy(data.damage[1]) end
            if next(data.heal[1]) then ShaguDPS.cached_current_heal = deepcopy(data.heal[1]) end
            if next(data.death[1]) then ShaguDPS.cached_current_death = deepcopy(data.death[1]) end
            if next(data.spellcast[1]) then ShaguDPS.cached_current_spellcast = deepcopy(data.spellcast[1]) end
            if next(data.friendly_fire[1]) then ShaguDPS.cached_current_friendly_fire = deepcopy(data.friendly_fire[1]) end
            if next(data.dispel[1]) then ShaguDPS.cached_current_dispel = deepcopy(data.dispel[1]) end
            if next(data.sunder[1]) then ShaguDPS.cached_current_sunder = deepcopy(data.sunder[1]) end
            if next(data.damage_taken[1]) then ShaguDPS.cached_current_damage_taken = deepcopy(data.damage_taken[1]) end
            if next(data.energize[1]) then ShaguDPS.cached_current_energize = deepcopy(data.energize[1]) end
            if next(data.invalid_damage[1]) then ShaguDPS.cached_current_invalid_damage = deepcopy(data.invalid_damage[1]) end
            if next(data.heal_taken[1]) then ShaguDPS.cached_current_heal_taken = deepcopy(data.heal_taken[1]) end
            if next(data.dot_ticks[1]) then ShaguDPS.cached_current_dot_ticks = deepcopy(data.dot_ticks[1]) end

            -- 如果本场战斗中有首领死亡，生成/覆盖 BOSS 战记录
            if table.getn(diedBossesThisFight) > 0 and ShaguDPS.pendingBossRecord then
                local newBosses = diedBossesThisFight

                local bossFight = {
                    name = ShaguDPS.pendingBossRecord.name,   -- 血量最高的首领名
                    timestamp = ShaguDPS.pendingBossRecord.timestamp,
                    bosses = newBosses,                        -- 本场战斗所有首领名字列表
                    damage = deepcopy(data.damage[1]),
                    heal = deepcopy(data.heal[1]),
                    death = deepcopy(data.death[1]),
                    spellcast = deepcopy(data.spellcast[1]),
                    friendly_fire = deepcopy(data.friendly_fire[1]),
                    dispel = deepcopy(data.dispel[1]),
                    sunder = deepcopy(data.sunder[1]),
                    damage_taken = deepcopy(data.damage_taken[1]),
                    energize = deepcopy(data.energize[1]),
                    invalid_damage = deepcopy(data.invalid_damage[1]),
                    heal_taken = deepcopy(data.heal_taken[1]),
                    duration = data.last_fight_duration,
                }

                -- 检查是否与已有记录有交集（按首领名），有则覆盖
                local replaced = false
                for i, fight in ipairs(ShaguDPS.boss_fights) do
                    if fight.bosses then
                        for _, name in ipairs(newBosses) do
                            for _, existingName in ipairs(fight.bosses) do
                                if name == existingName then
                                    ShaguDPS.boss_fights[i] = bossFight
                                    replaced = true
                                    break
                                end
                            end
                            if replaced then break end
                        end
                    end
                    if replaced then break end
                end

                if not replaced then
                    table.insert(ShaguDPS.boss_fights, bossFight)
                    ShaguDPS.current_boss_index = table.getn(ShaguDPS.boss_fights)
                else
                    ShaguDPS.current_boss_index = i
                end

                DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff00ff00[ShaguDPS] 已记录BOSS战: %s|r", bossFight.name))
            end

            -- 清空本场战斗的首领跟踪数据
            ShaguDPS.pendingBossRecord = nil
            diedBossesThisFight = {}

            ShaguDPS.SaveDataToCache()
            resetCurrentSegment()
            parser:FlushPendingEvents()
            data.threat = {}
            combat_start_time = 0
            parser.extraAttacks = {}
        elseif state == "COMBAT" then
            -- 进入战斗：清除缓存，重置当前段
            healthCache = {}
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
            start_next_segment = nil
            combat_start_time = GetTime()
            data.combat_start_time = combat_start_time
            ShaguDPS.pendingBossRecord = nil
            diedBossesThisFight = {}
        end
    end
end

parser.combat:SetScript("OnEvent", function() this:UpdateState() end)
parser.combat:SetScript("OnUpdate", function()
    if (this.tick or 1) > GetTime() then return else this.tick = GetTime() + 1 end
    this:UpdateState()
end)

-- ===========================================================================
-- 核心数据更新函数（统一入口）
-- 所有伤害/治疗/吸收等最终都通过此函数将数据写入 data[datatype][segment][finalSource]
-- ===========================================================================
-- @param source      原始施放者名称（可能是宠物名）
-- @param action      技能名（若合并宠物，则格式为 "宠物名 - 技能名"）
-- @param target      目标名称（未使用，仅记录）
-- @param value       伤害/治疗量
-- @param school      法术派系（未使用，保留）
-- @param datatype    统计类型字符串: "damage", "heal"
-- @param effectiveValue 有效治疗量（仅治疗使用）
-- @param petType     宠物类型（未使用）
-- @param ownerName   宠物主人名称（若 merge_pets=1，则 finalSource 设为 ownerName）
-- @param overkill    溢出伤害量
local function updateStats(source, action, target, value, school, datatype, effectiveValue, petType, ownerName, overkill)
    if type(source) ~= "string" or not tonumber(value) then return end
    if datatype == "damage" and source == target then return end  -- 防止自伤统计（如痛苦无常）

    -- 治疗仅在战斗中统计选项
    if datatype == "heal" and config.heal_only_in_combat == 1 and not combat() then return end

    -- 若合并宠物，确保主人信息已记录在 classes 中
    if ownerName and config.merge_pets == 1 then
        if not data["classes"][ownerName] then parser:ScanName(ownerName) end
    end

    -- 如果 start_next_segment 被外部设置为真，并且当前施放者是一个已识别的玩家（非 __other__），
    -- 则重置当前段（在下一场战斗开始前强制清空当前数据）
    if start_next_segment and data["classes"][source] and data["classes"][source] ~= "__other__" then
        ShaguDPS.cached_current_damage = nil   -- 触发重置
        ShaguDPS.cached_current_heal = nil
        ShaguDPS.cached_current_death = nil
        ShaguDPS.cached_current_spellcast = nil
        ShaguDPS.cached_current_friendly_fire = nil
        ShaguDPS.cached_current_dispel = nil
        ShaguDPS.cached_current_damage_taken = nil
        ShaguDPS.cached_current_energize = nil
        ShaguDPS.cached_current_invalid_damage = nil
        ShaguDPS.cached_current_heal_taken = nil
        resetCurrentSegment()
        start_next_segment = nil
    end

    local effective = 0
    if datatype == "heal" then effective = effectiveValue or tonumber(value) end
    local over = overkill or 0

    -- 根据合并宠物设置最终显示名称和技能显示名
    local finalSource, finalAction
    if ownerName and config.merge_pets == 1 then
        finalSource = ownerName           -- 最终归属于主人
        finalAction = source .. " - " .. action   -- 技能名带上宠物名作为前缀
        -- 确保两个段都存在该主人条目
        for segment = 0, 1 do
            local entry = data[datatype][segment]
            if not entry[finalSource] then
                entry[finalSource] = { ["_sum"] = 0, ["_ctime"] = 1, ["_overkill"] = 0 }
            end
        end
    else
        finalSource = source
        finalAction = action
        -- 如果不合并宠物，则将宠物的职业设为与主人相同（用于着色）
        if ownerName and config.merge_pets == 0 then
            if not data["classes"][source] then
                data["classes"][source] = data["classes"][ownerName] or "__other__"
            end
        end
    end

    -- 对两个数据段（0 全程，1 当前）分别写入数据
    for segment = 0, 1 do
        local entry = data[datatype][segment]
        if not entry[finalSource] then
            -- 尝试扫描名称确定类型；若为宠物且主人不存在则跳过；其他类型或未知单位则根据配置决定是否添加
            local type = parser:ScanName(finalSource)
            if type == "PET" then
                local owner = data["classes"][finalSource]
                if not entry[owner] and parser:ScanName(owner) then
                    entry[owner] = { ["_sum"] = 0, ["_ctime"] = 1, ["_overkill"] = 0 }
                end
            elseif not type then
                if data["classes"][finalSource] then
                    entry[finalSource] = { ["_sum"] = 0, ["_ctime"] = 1, ["_overkill"] = 0 }
                else
                    break  -- 无法识别名称且不是玩家/宠物主人，不记录
                end
            else
                entry[finalSource] = { ["_sum"] = 0, ["_ctime"] = 1, ["_overkill"] = 0 }
            end
        end

        if entry[finalSource] then
            -- 更新技能伤害/治疗量
            entry[finalSource][finalAction] = (entry[finalSource][finalAction] or 0) + tonumber(value)
            -- 更新总和
            entry[finalSource]["_sum"] = (entry[finalSource]["_sum"] or 0) + tonumber(value)
            if datatype == "damage" then
                -- 记录溢出伤害
                entry[finalSource]["_overkill"] = (entry[finalSource]["_overkill"] or 0) + over
                if not entry[finalSource]["_overkill_by_spell"] then
                    entry[finalSource]["_overkill_by_spell"] = {}
                end
                entry[finalSource]["_overkill_by_spell"][finalAction] = (entry[finalSource]["_overkill_by_spell"][finalAction] or 0) + over
            end
            if datatype == "heal" then
                -- 记录有效治疗和每个技能的有效治疗
                entry[finalSource]["_esum"] = (entry[finalSource]["_esum"] or 0) + effective
                entry[finalSource]["_effective"] = entry[finalSource]["_effective"] or {}
                entry[finalSource]["_effective"][finalAction] = (entry[finalSource]["_effective"][finalAction] or 0) + effective
            end
            -- 更新活跃战斗时间：如果距上次更新超过 5 秒，则增加固定 5 秒间隔，否则增加实际时间差
            entry[finalSource]["_ctime"] = entry[finalSource]["_ctime"] or 1
            entry[finalSource]["_tick"] = entry[finalSource]["_tick"] or GetTime()
            if entry[finalSource]["_tick"] + 5 < GetTime() then
                entry[finalSource]["_tick"] = GetTime()
                entry[finalSource]["_ctime"] = entry[finalSource]["_ctime"] + 5
            else
                entry[finalSource]["_ctime"] = entry[finalSource]["_ctime"] + (GetTime() - entry[finalSource]["_tick"])
                entry[finalSource]["_tick"] = GetTime()
            end
        end
    end

    -- 通知所有注册的刷新回调（窗口更新）
    for id, callback in pairs(parser.callbacks.refresh) do
        callback()
    end
end

-- 外部接口：添加数据（主要供 vanilla 模式使用）
-- @param self      parser
-- @param source    施放者名称
-- @param action    技能名
-- @param target    目标名称
-- @param value     伤害/治疗量
-- @param school    法术派系
-- @param datatype  数据类型 ("damage" 或 "heal")
parser.AddData = function(self, source, action, target, value, school, datatype)
    updateStats(source, action, target, value, school, datatype)
end

-- ===========================================================================
-- ScanName 函数：解析名称类型（玩家、宠物、其他）
-- 用于将名称与职业关联，并判断是否属于被追踪的单位
-- @param name  单位名称字符串
-- @return  "PLAYER" 表示玩家, "PET" 表示宠物, "OTHER" 表示其他单位, nil 表示不需要追踪
-- ===========================================================================
local unit_cache = {}  -- 名称 -> 单位 token 缓存
local function UnitByName(name)
    if unit_cache[name] and UnitName(unit_cache[name]) == name then
        return unit_cache[name]
    end
    for unit in pairs(validUnits) do
        if UnitName(unit) == name then
            unit_cache[name] = unit
            return unit
        end
    end
    for unit in pairs(validPets) do
        if UnitName(unit) == name then
            unit_cache[name] = unit
            return unit
        end
    end
end

parser.ScanName = function(self, name)
    if not name then return end
    -- 先搜索玩家单位
    for unit, _ in pairs(validUnits) do
        if UnitExists(unit) and UnitName(unit) == name then
            if UnitIsPlayer(unit) then
                local _, class = UnitClass(unit)
                data["classes"][name] = class
                return "PLAYER"
            end
        end
    end

    -- 检查名称中是否包含括号，表示可能为宠物（如 "Petname (Ownername)"）
    local match, _, owner = string.find(name, "%((.*)%)", 1)
    if match and owner then
        if self:ScanName(owner) == "PLAYER" then
            data["classes"][name] = owner
            return "PET"
        end
    end

    -- 搜索宠物单位
    for unit, _ in pairs(validPets) do
        if UnitExists(unit) and UnitName(unit) == name then
            -- 设置主人名称
            if strsub(unit, 0, 3) == "pet" then
                data["classes"][name] = UnitName("player")
            elseif strsub(unit, 0, 8) == "partypet" then
                data["classes"][name] = UnitName("party" .. strsub(unit, 9))
            elseif strsub(unit, 0, 7) == "raidpet" then
                data["classes"][name] = UnitName("raid" .. strsub(unit, 8))
            end
            return "PET"
        end
    end

    -- 如果配置开启追踪所有附近单位，则将未知名称标记为 "__other__"
    if config.track_all_units == 1 then
        data["classes"][name] = data["classes"][name] or "__other__"
        return "OTHER"
    else
        return nil
    end
end

-- ===========================================================================
-- 额外攻击（剑专/风怒/劈斩 等）检测模块
-- ===========================================================================
local locale = GetLocale()
local extraAttackAbilities = {}
if locale == "zhCN" then
    extraAttackAbilities = {
        ["风怒武器"] = 1, -- 为2次，但是Nampower下一次触发2次BUFF
        ["风怒图腾"] = 1,
        ["铸铁之怒"] = 1, -- 为2次，但是Nampower下一次触发2次BUFF
        ["正义之手"] = 1,
        ["风暴战斧"] = 1,
        ["永恒打击"] = 1,
        ["劈斩"] = 1,
        ["剑类武器专精"] = 1,
        ["癫狂打击被动"] = 1,
    }
else
    extraAttackAbilities = {
        ["Windfury Weapon"] = 1, -- 为2次，但是Nampower下一次触发2次BUFF
        ["Windfury Totem"] = 1,
        ["Fury of Forgewright"] = 1, -- 为2次，但是Nampower下一次触发2次BUFF
        ["Hand of Justice"] = 1,
        ["Flurry Axe"] = 1,
        ["Eternal Strike"] = 1,
        ["Hack and Slash"] = 1,
        ["Sword Specialization"] = 1,
        ["Maddened Strikes Passive"] = 1,
    }
end

-- 额外攻击队列：{ [casterName] = { count = n, ability = "技能名" } }
parser.extraAttacks = parser.extraAttacks or {}

-- ===========================================================================
-- 破甲技能ID列表（用于破甲统计）
-- ===========================================================================
local sunderSpellIds = {
    [7386] = true, [7405] = true, [8380] = true, [11596] = true, [11597] = true,
    [8647] = true, [8649] = true, [8650] = true, [11197] = true, [11198] = true,
}

-- ===========================================================================
-- 吸收转治疗核心模块
-- 将护盾吸收的伤害转化为有效治疗量。
-- ===========================================================================

-- 护盾技能与可吸收的伤害学派映射（0 表示全吸收）
local shieldData = {
    ["真言术：盾"] = 0,
    ["寒冰护体"] = 0,
    ["持续护盾"] = 0,
    ["大地障壁"] = 0,
    ["法力护盾"] = 1,
    ["防护冰霜结界"] = 2,
    ["防护火焰结界"] = 3,
    ["防护暗影结界"] = 5,
    ["防护神圣结界"] = 7,
    ["火焰防护"] = 3,
    ["奥术防护"] = 6,
    ["防护冰霜"] = 2,
    ["防护火焰"] = 3,
    ["防护自然"] = 4,
    ["防护暗影"] = 5,
    ["防护神圣"] = 7,
    ["红月"] = 0,
    ["蓝月"] = 0,
}

-- 活跃护盾容器：[targetGUID] = { {casterGUID, spellId, school}, ... }
local activeShields = {}

-- 简单的字符串分割函数（用于解析 mitigationStr）
local function strsplit(str, sep)
    local t = {}
    for s in string.gfind(str, "([^" .. sep .. "]+)") do table.insert(t, s) end
    return t
end

-- 处理吸收量：将吸收量匹配到目标身上的护盾，并转为护盾施放者的有效治疗
-- @param targetGuid   受伤单位的 GUID
-- @param spellSchool  伤害学派
-- @param absorbAmount 吸收量
local function processAbsorb(targetGuid, spellSchool, absorbAmount)
    if absorbAmount <= 0 or not activeShields[targetGuid] then return end

    -- 优先选用匹配学派的护盾，否则取第一个
    local best
    for _, shield in ipairs(activeShields[targetGuid]) do
        if shield[3] == 0 or shield[3] == spellSchool then
            best = shield
            break
        end
    end
    if not best then best = activeShields[targetGuid][1] end

    -- 获取这个护盾的技能名称
    local shieldSpellName = GetSpellNameAndRankForId(best[2])

    -- 如果是红月或蓝月，直接忽略吸收效果，不做统计
    if shieldSpellName == "红月" or shieldSpellName == "蓝月" then
        return
    end

    -- 正常记录吸收转治疗
    local casterName = UnitName(best[1])
    local targetName = UnitName(targetGuid)
    if casterName and shieldSpellName and targetName then
        updateStats(casterName, shieldSpellName, targetName, absorbAmount, 0, "heal", absorbAmount)
    end
end

-- 记录DOT跳数（根据宠物合并规则确定最终属主）
local function recordDotTick(source, action, ownerName)
    local finalSource, finalAction
    if ownerName and config.merge_pets == 1 then
        finalSource = ownerName
        finalAction = source .. " - " .. action
    else
        finalSource = source
        finalAction = action
        if ownerName and config.merge_pets == 0 then
            if not data["classes"][source] then
                data["classes"][source] = data["classes"][ownerName] or "__other__"
            end
        end
    end
    for segment = 0, 1 do
        local entry = data.dot_ticks[segment]
        if not entry[finalSource] then entry[finalSource] = {} end
        entry[finalSource][finalAction] = (entry[finalSource][finalAction] or 0) + 1
    end
    for id, callback in pairs(parser.callbacks.refresh) do callback() end
end

-- 环境伤害可吸收类型映射（ENVIRONMENTAL_DMG_* 到学派）
local envDmgSchool = {
    [3] = 2,   -- Lava -> 火焰
    [4] = 3,   -- Slime -> 自然
    [5] = 2,   -- Fire -> 火焰
}

-- 环境伤害名称映射
local ENV_DMG_NAMES = {
    [0] = "疲劳",
    [1] = "溺水",
    [2] = "坠落",
    [3] = "熔岩",
    [4] = "软泥",
    [5] = "火焰",
    [6] = "虚空",
}

-- ===========================================================================
-- 能量回复统计专用函数
-- ===========================================================================
local POWER_NAMES = {
    [0] = "法力",
    [1] = "怒气",
    [2] = "集中值",
    [3] = "能量",
    --[4] = "快乐值",
}

-- 更新能量回复数据，类似于 updateStats，但写入 "energize" 段
-- @param source      施法者名称（宠物名）
-- @param action      技能名
-- @param target      目标名称
-- @param amount      回复量
-- @param powerType   能量类型 (0法力,1怒气,2集中,3能量,4快乐)
-- @param ownerName   宠物主人名称
local function updateEnergizeStats(source, action, target, amount, powerType, ownerName)
    if type(source) ~= "string" or not tonumber(amount) then return end

    -- 忽略非追踪的能量属性
    if not POWER_NAMES[powerType] then return end

    -- 怒气值需要除以10
    if powerType == 1 then
        amount = amount / 10
    end

    local finalSource, finalAction
    if ownerName then
        -- 宠物能量回复：显示为“主人名-宠物名”，技能名不带宠物前缀
        finalSource = ownerName .. " - " .. source
        -- 确保该组合的职业颜色与主人一致
        if not data["classes"][finalSource] then
            data["classes"][finalSource] = data["classes"][ownerName] or "__other__"
        end
        finalAction = action .. " (" .. POWER_NAMES[powerType] .. ")"
    else
        -- 无主人的单位（玩家）直接使用自身名称
        finalSource = source
        finalAction = action .. " (" .. POWER_NAMES[powerType] .. ")"
    end

    for segment = 0, 1 do
        local entry = data.energize[segment]
        if not entry[finalSource] then
            local type = parser:ScanName(finalSource)
            if type == "PET" then
                local owner = data["classes"][finalSource]
                if not entry[owner] and parser:ScanName(owner) then
                    entry[owner] = { ["_sum"] = 0, ["_ctime"] = 1, ["_by_type"] = {} }
                end
            elseif not type then
                if data["classes"][finalSource] then
                    entry[finalSource] = { ["_sum"] = 0, ["_ctime"] = 1, ["_by_type"] = {} }
                else
                    break
                end
            else
                entry[finalSource] = { ["_sum"] = 0, ["_ctime"] = 1, ["_by_type"] = {} }
            end
        end

        if entry[finalSource] then
            local rec = entry[finalSource]
            rec[finalAction] = (rec[finalAction] or 0) + amount
            rec["_sum"] = (rec["_sum"] or 0) + amount
            rec["_by_type"] = rec["_by_type"] or {}
            rec["_by_type"][powerType] = (rec["_by_type"][powerType] or 0) + amount

            -- 活跃时间
            rec["_ctime"] = rec["_ctime"] or 1
            rec["_tick"] = rec["_tick"] or GetTime()
            if rec["_tick"] + 5 < GetTime() then
                rec["_tick"] = GetTime()
                rec["_ctime"] = rec["_ctime"] + 5
            else
                rec["_ctime"] = rec["_ctime"] + (GetTime() - rec["_tick"])
                rec["_tick"] = GetTime()
            end
        end
    end

    for id, callback in pairs(parser.callbacks.refresh) do callback() end
end

-- ===========================================================================
-- 无效伤害记录函数
-- ===========================================================================
local function addInvalidDamage(source, action, target, value, school, overkill)
    if type(source) ~= "string" or not tonumber(value) then return end
    if source == target then return end

    local finalSource = source
    local finalAction = action

    for segment = 0, 1 do
        local entry = data.invalid_damage[segment]
        if not entry[finalSource] then
            -- 确保职业信息存在（用于染色）
            if not data["classes"][finalSource] then
                parser:ScanName(finalSource)
            end
            entry[finalSource] = { _sum = 0, _ctime = 1, _overkill = 0, _by_target = {} }
        end
        local rec = entry[finalSource]
        rec._sum = (rec._sum or 0) + tonumber(value)
        rec._overkill = (rec._overkill or 0) + (overkill or 0)

        if not rec._by_target[target] then
            rec._by_target[target] = { _sum = 0 }
        end
        local tgtEntry = rec._by_target[target]
        tgtEntry._sum = tgtEntry._sum + tonumber(value)
        tgtEntry[finalAction] = (tgtEntry[finalAction] or 0) + tonumber(value)
        tgtEntry["_count_"..finalAction] = (tgtEntry["_count_"..finalAction] or 0) + 1

        -- 活跃时间
        rec._ctime = rec._ctime or 1
        rec._tick = rec._tick or GetTime()
        if rec._tick + 5 < GetTime() then
            rec._tick = GetTime()
            rec._ctime = rec._ctime + 5
        else
            rec._ctime = rec._ctime + (GetTime() - rec._tick)
            rec._tick = GetTime()
        end
    end

    for id, callback in pairs(parser.callbacks.refresh) do callback() end
end

-- 检查目标名字是否在忽略列表中
local function isNameIgnored(name)
    if not name then return false end
    return ShaguDPS.ignoredUnitNames[name] == true
end

-- ===========================================================================
-- 以下是 Nampower 事件处理函数（如果 Nampower 可用）
-- ===========================================================================
if ShaguDPS.hasNampower then
    -- 启用所需的 Nampower 事件（注册事件即可自动启用，但保留 CVar 设置以兼容旧版）
    SetCVar("NP_EnableAutoAttackEvents", "1")
    SetCVar("NP_EnableSpellHealEvents", "1")
    SetCVar("NP_EnableSpellEnergizeEvents", "1")
    SetCVar("NP_EnableSpellGoEvents", "1")
    SetCVar("NP_EnableAuraCastEvents", "1")

    -- 判断是否为小动物（根据单位类型）
    local function IsCritter(guid)
        if not guid then return false end
        local creatureType = UnitCreatureType(guid)
        if not creatureType then return false end
        return creatureType == "小动物" or creatureType == "Critter"
    end

    -- 计算溢出伤害（实际伤害 - 目标当前血量）
    -- @param targetGuid 目标 GUID
    -- @param rawDamage  原始伤害量（未受 clamp 限制）
    -- @return 溢出伤害量
    local function CalculateOverkill(targetGuid, rawDamage)
        if not targetGuid or not rawDamage or rawDamage <= 0 then return 0 end
        local health = GetUnitField(targetGuid, "health")
        if health and health > 0 then
            local over = rawDamage - health
            if over > 0 then
                healthCache[targetGuid] = nil
                return over
            else
                -- 缓存剩余血量，用于后续连续伤害的溢出计算
                healthCache[targetGuid] = health - rawDamage
                return 0
            end
        end
        healthCache[targetGuid] = nil
        return rawDamage   -- 目标已死亡，视为全部溢出
    end

    -- 判断目标是否为友方
    local function IsFriendly(guid)
        if not guid then return false end
        return UnitIsFriend("player", guid)
    end

    -- 根据法术 ID 获取法术名称，0 表示自动攻击
    local function getSpellName(spellId)
        if not spellId or spellId == 0 then return "自动攻击" end
        local name = GetSpellNameAndRankForId(spellId)
        if name then return name end
        return "技能" .. spellId
    end

    -- ========================================================================
    -- 护盾生命周期管理
    -- ========================================================================

    -- AURA_CAST_ON_* 事件：护盾添加
    -- 参数顺序：spellId, casterGuid, targetGuid, effect, effectAuraName, effectAmplitude, effectMiscValue, durationMs, auraCapStatus
    local function onAuraCast(spellId, casterGuid, targetGuid, effect, effectAuraName, effectAmplitude, effectMiscValue, durationMs, auraCapStatus)
        local spellName = getSpellName(spellId)
        if shieldData[spellName] then
            local schoolFlag = shieldData[spellName] or 0
            if not activeShields[targetGuid] then activeShields[targetGuid] = {} end
            for i, s in ipairs(activeShields[targetGuid]) do
                if s[2] == spellId then
                    if s[1] then return end
                    activeShields[targetGuid][i] = {casterGuid, spellId, schoolFlag}
                    return
                end
            end
            table.insert(activeShields[targetGuid], {casterGuid, spellId, schoolFlag})
        end
    end

    -- BUFF_REMOVED_* 事件：护盾移除
    -- 参数顺序：guid, luaSlot, spellId, stacks, auraLevel, auraSlot, state
    local function onBuffRemoved(guid, luaSlot, spellId, stacks, auraLevel, auraSlot, state)
        if state == 1 and activeShields[guid] then
            for i = table.getn(activeShields[guid]), 1, -1 do
                if activeShields[guid][i][2] == spellId then
                    table.remove(activeShields[guid], i)
                end
            end
            if table.getn(activeShields[guid]) == 0 then
                activeShields[guid] = nil
            end
        end
    end

    -- 参数顺序：guid, luaSlot, spellId, stacks, auraLevel, auraSlot, state
    local function onBuffAdded(guid, luaSlot, spellId, stacks, auraLevel, auraSlot, state)
        if state ~= 0 then return end
        local spellName = getSpellName(spellId)
        if not shieldData[spellName] then return end

        local schoolFlag = shieldData[spellName] or 0
        if not activeShields[guid] then activeShields[guid] = {} end
        for _, s in ipairs(activeShields[guid]) do
            if s[2] == spellId then return end
        end
        -- 无施法者信息，casterGuid = nil
        table.insert(activeShields[guid], { nil, spellId, schoolFlag })
    end

    -- ========================================================================
    -- 仇恨 / 黑名单 / 单位追踪等（GUID 相关黑名单已完全移除）
    -- ========================================================================
    local function formatThreatNumber(n)
        if n < 0 then n = 0 end
        if n < 1000 then return round(n) end
        if n < 1000000 then return round(n / 10) / 100 .. "K" end
        return round(n / 10000) / 100 .. "M"
    end

    -- 计算威胁每秒（TPS）
    local function calcTPS(name, currentThreat)
        if not data.threat_history then data.threat_history = {} end
        local history = data.threat_history[name]
        if not history then
            history = {}
            data.threat_history[name] = history
        end
        local now = time()
        history[now] = currentThreat
        -- 清理超过 10 秒的历史值
        for t, _ in pairs(history) do
            if now - t > 10 then history[t] = nil end
        end
        local tps = 0
        local count = 0
        for i = 0, 9 do
            local cur = history[now - i]
            local prev = history[now - i - 1]
            if cur and prev then
                tps = tps + (cur - prev)
                count = count + 1
            end
        end
        if count > 0 and tps > 0 then return round(tps / count) end
        return 0
    end

    -- 解析 ThreatWatchT 插件发送的仇恨数据包（TWTv4）
    local function parseThreatPacket(msg)
        local prefix = "TWTv4="
        local start = string.find(msg, prefix, 1, true)
        if not start then return end
        local content = string.sub(msg, start + string.len(prefix))
        if not content or content == "" then return end
        data.threat = {}
        for playerData in string.gfind(content, "[^;]+") do
            local parts = {}
            for p in string.gfind(playerData, "[^:]+") do
                table.insert(parts, p)
            end
            if table.getn(parts) >= 5 then
                local name = parts[1]
                local tank = parts[2] == "1"
                local threat = tonumber(parts[3]) or 0
                local perc = tonumber(parts[4]) or 0
                local class = data.classes[name]
                data.threat[name] = {
                    threat = threat,
                    tank = tank,
                    perc = perc,
                    tps = calcTPS(name, threat),
                    class = class,
                }
            end
        end
        for id, callback in pairs(parser.callbacks.refresh) do callback() end
    end

    -- 定时请求仇恨数据（每 0.5 秒）
    local threatRequestFrame = CreateFrame("Frame")
    threatRequestFrame:SetScript("OnUpdate", function()
        if not this.lastUpdate then this.lastUpdate = 0 end
        if GetTime() - this.lastUpdate < 0.5 then return end
        this.lastUpdate = GetTime()
        if not UnitAffectingCombat("player") then return end
        if not UnitExists("target") or UnitIsPlayer("target") or UnitIsDead("target") then return end
        local channel = (GetNumRaidMembers() > 0) and "RAID" or "PARTY"
        if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then return end
        SendAddonMessage("TWT", "TWT_UDTSv4_limit=" .. 10, channel)
    end)

    -- 判断单位是否被追踪（是否属于玩家、小队、团队或开启 all units）
    local function isUnitTracked(guid)
        if not guid then return false end
        if config.track_all_units == 1 then return true end
        if guid == GetUnitGUID("player") then return true end
        for i = 1, 4 do if GetUnitGUID("party" .. i) == guid then return true end end
        for i = 1, 40 do if GetUnitGUID("raid" .. i) == guid then return true end end
        return false
    end

    local function shouldTrackDeath(guid) return isUnitTracked(guid) end
    local function shouldTrackSpellcast(guid) return isUnitTracked(guid) end

    -- ===========================================================================
    -- 承受伤害统计辅助函数
    -- ===========================================================================
    local MAX_DAMAGE_TAKEN_HISTORY = 200   -- 每个受害者保留的最近伤害记录条数

    -- 记录一次承受伤害事件，按来源和技能合并
    local function updateDamageTaken(victimName, sourceName, spellName, damage)
        if not victimName or type(damage) ~= "number" then return end

        for segment = 0, 1 do
            local entry = data.damage_taken[segment]
            if not entry[victimName] then
                entry[victimName] = { _sum = 0, _history = {} }
            end
            local rec = entry[victimName]
            rec._sum = rec._sum + damage

            -- 在已有历史中查找相同来源和技能的条目
            local existing = nil
            for _, h in ipairs(rec._history) do
                if h.source == sourceName and h.spell == spellName then
                    existing = h
                    break
                end
            end

            -- 1. 保留原有的合并逻辑（用于承受伤害统计工具提示）
            if existing then
                existing.total = existing.total + damage
                existing.last = damage
                existing.time = GetTime()
            else
                table.insert(rec._history, {
                    source = sourceName,
                    spell = spellName,
                    total = damage,
                    last = damage,
                    time = GetTime()
                })
                if table.getn(rec._history) > MAX_DAMAGE_TAKEN_HISTORY then
                    table.remove(rec._history, 1)
                end
            end

            -- 2. 新增独立记录（用于死亡详情，不合并）
            if not rec._detail_history then
                rec._detail_history = {}
            end
            table.insert(rec._detail_history, {
                source = sourceName,
                spell = spellName,
                damage = damage,      -- 本次伤害值
                time = GetTime()      -- 精确时间
            })
            -- 限制独立记录的最大条数
            local maxDetail = 50  -- 可调整
            while table.getn(rec._detail_history) > maxDetail do
                table.remove(rec._detail_history, 1)
            end
        end
    end

    -- 记录受到治疗（按来源合并总治疗和有效治疗）
    local function updateHealTaken(victimName, sourceName, amount, effectiveAmount)
        if not victimName or not sourceName or type(amount) ~= "number" then return end
        local effective = effectiveAmount or amount
        for segment = 0, 1 do
            local entry = data.heal_taken[segment]
            if not entry[victimName] then
                entry[victimName] = { _sum = 0, _esum = 0 }
            end
            local vRec = entry[victimName]
            vRec._sum = vRec._sum + amount
            vRec._esum = vRec._esum + effective
            if not vRec[sourceName] then
                vRec[sourceName] = { _sum = 0, _esum = 0 }
            end
            vRec[sourceName]._sum = vRec[sourceName]._sum + amount
            vRec[sourceName]._esum = vRec[sourceName]._esum + effective
        end
        for id, callback in pairs(parser.callbacks.refresh) do callback() end
    end

    -- 记录承受伤害（自动处理宠物归属）
    -- @param targetGuid    受害者 GUID
    -- @param sourceName    攻击者显示名称
    -- @param spellName     技能名称
    -- @param damage        伤害值
    local function recordDamageTaken(targetGuid, sourceName, spellName, damage)
        if not damage or damage <= 0 then return end

        local victimName = UnitName(targetGuid)
        if not victimName then return end

        if isUnknownName(victimName) then
            parser:ScheduleEvent(recordDamageTaken, {targetGuid, sourceName, spellName, damage}, {targetGuid})
            return
        end

        -- 如果受害者不在追踪列表，尝试获取主人（宠物）
        if not isUnitTracked(targetGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(targetGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then
                return
            end
            if config.merge_pets == 1 then
                victimName = UnitName(ownerGUID)
            else
                victimName = UnitName(ownerGUID) .. " - " .. victimName
            end
        end

        updateDamageTaken(victimName, sourceName, spellName, damage)
    end

    -- 记录承受治疗（用于死亡详情和受到治疗视图）
    -- @param targetGuid    受治疗者 GUID
    -- @param sourceName    治疗者显示名称
    -- @param spellName     技能名称
    -- @param amount        治疗量
    -- @param effectiveAmount 有效治疗量
    local function recordHealTaken(targetGuid, sourceName, spellName, amount, effectiveAmount)
        if not amount or amount <= 0 then return end

        local victimName = UnitName(targetGuid)
        if not victimName then return end

        if isUnknownName(victimName) then
            parser:ScheduleEvent(recordHealTaken, {targetGuid, sourceName, spellName, amount, effectiveAmount}, {targetGuid})
            return
        end

        -- 确定受治疗者名称：宠物永远格式化为“主人 - 宠物”
        local _, petType, ownerGUID = GetOwnerInfoFromPetGUID(targetGuid)
        local isPet = (petType ~= nil)
        if isPet then
            -- 宠物受治疗者：检查主人是否被追踪（或开启了所有单位）
            if not ownerGUID or (not isUnitTracked(ownerGUID) and config.track_all_units ~= 1) then
                return
            end
            local ownerName = UnitName(ownerGUID)
            if ownerName then
                victimName = ownerName .. " - " .. victimName
                -- 确保宠物受害者显示为与主人相同的职业颜色
                parser:ScanName(ownerName)  -- 缓存主人职业信息
                if data["classes"][ownerName] then
                    data["classes"][victimName] = data["classes"][ownerName]
                end
            end
        else
            -- 非宠物受治疗者：如果未开启“显示所有附近单位”，则必须属于追踪单位
            if config.track_all_units ~= 1 and not isUnitTracked(targetGuid) then
                return
            end
        end

        -- 死亡详情记录
        for segment = 0, 1 do
            local entry = data.damage_taken[segment]
            if not entry[victimName] then
                entry[victimName] = { _sum = 0, _history = {} }
            end
            local rec = entry[victimName]
            if not rec._detail_heal_history then
                rec._detail_heal_history = {}
            end
            table.insert(rec._detail_heal_history, {
                source = sourceName,
                spell = spellName,
                amount = amount,
                time = GetTime()
            })
            local maxHealHistory = 50
            while table.getn(rec._detail_heal_history) > maxHealHistory do
                table.remove(rec._detail_heal_history, 1)
            end
        end
        -- 更新受到治疗数据
        updateHealTaken(victimName, sourceName, amount, effectiveAmount)
    end

    -- ========================================================================
    -- 死亡统计（UNIT_DIED 事件处理）
    -- ========================================================================
    local function onUnitDied(guid)
        healthCache[guid] = nil
        -- 移除所有 GUID 忽略逻辑

        -- 如果在战斗中且死亡的是世界首领，记录以生成 BOSS 战记录
        if combat() then
            if UnitClassification(guid) == "worldboss" then
                local bossName = UnitName(guid)
                if bossName and not isUnknownName(bossName) then
                    local found = false
                    for _, name in ipairs(diedBossesThisFight) do
                        if name == bossName then found = true break end
                    end
                    if not found then
                        table.insert(diedBossesThisFight, bossName)
                    end

                    local maxHealth = GetUnitField(guid, "maxHealth") or 0
                    if not ShaguDPS.pendingBossRecord or maxHealth > (ShaguDPS.pendingBossRecord.maxHealth or 0) then
                        ShaguDPS.pendingBossRecord = {
                            name = bossName,
                            timestamp = combat_start_time,
                            maxHealth = maxHealth,
                        }
                    end
                end
            end
        end

        -- 统计可追踪单位的死亡次数
        if not shouldTrackDeath(guid) then return end
        local name = UnitName(guid)
        if not name then return end
        for segment = 0, 1 do
            data.death[segment][name] = (data.death[segment][name] or 0) + 1
        end
        for id, callback in pairs(parser.callbacks.refresh) do callback() end
        if not data.death_timestamps[name] then data.death_timestamps[name] = {} end
        table.insert(data.death_timestamps[name], GetTime())
    end

    -- ========================================================================
    -- 施法统计 & 破甲（SPELL_GO_* 事件处理）
    -- 参数顺序：itemId, spellId, casterGuid, targetGuid, castFlags, numTargetsHit, numTargetsMissed, corpseOwnerGuid
    -- ========================================================================
    local function onSpellGo(itemId, spellId, casterGuid, targetGuid, castFlags, numTargetsHit, numTargetsMissed, corpseOwnerGuid)
        if itemId and itemId ~= 0 then return end  -- 忽略物品触发的技能
        -- 忽略对友方施放的辅助技能
        if UnitCanAssist(casterGuid, targetGuid) and targetGuid ~= "0x0000000000000000" then return end
        if not isUnitTracked(casterGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then
                return
            end
        end
        local name = UnitName(casterGuid)
        if isUnknownName(name) then
            local args = {itemId, spellId, casterGuid, targetGuid, castFlags, numTargetsHit, numTargetsMissed, corpseOwnerGuid}
            parser:ScheduleEvent(onSpellGo, args, {casterGuid})
            return
        end
        local spellName = getSpellName(spellId)
        local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)
        local finalName, finalSpellName
        if ownerName then
            if config.merge_pets == 1 then
                finalName = ownerName
                finalSpellName = name .. " - " .. spellName
            else
                finalName = ownerName .. " - " .. name
                finalSpellName = spellName
                if not data["classes"][finalName] then
                    data["classes"][finalName] = data["classes"][ownerName] or "__other__"
                end
            end
        else
            finalName = name
            finalSpellName = spellName
        end
        for segment = 0, 1 do
            local entry = data.spellcast[segment]
            if not entry[finalName] then entry[finalName] = { ["_total"] = 0 } end
            entry[finalName]["_total"] = (entry[finalName]["_total"] or 0) + 1
            entry[finalName][finalSpellName] = (entry[finalName][finalSpellName] or 0) + 1
        end
        -- 如果属于破甲技能，记录破甲数据
        if sunderSpellIds[spellId] then
            local sunderCaster = finalName
            local targetNameSunder = UnitName(targetGuid)
            if targetNameSunder and not isUnknownName(targetNameSunder) then
                for segment = 0, 1 do
                    local entry = data.sunder[segment]
                    if not entry[sunderCaster] then entry[sunderCaster] = { ["_total"] = 0 } end
                    entry[sunderCaster]["_total"] = (entry[sunderCaster]["_total"] or 0) + 1
                    entry[sunderCaster][targetNameSunder] = (entry[sunderCaster][targetNameSunder] or 0) + 1
                end
            end
        end
        for id, callback in pairs(parser.callbacks.refresh) do callback() end
    end

    -- ========================================================================
    -- 误伤统计
    -- ========================================================================
    local function recordFriendlyFire(casterGuid, sourceName, targetName, action, damage)
        if not isUnitTracked(casterGuid) then return end
        for segment = 0, 1 do
            local entry = data.friendly_fire[segment]
            if not entry[sourceName] then entry[sourceName] = { ["_total"] = 0 } end
            entry[sourceName]["_total"] = (entry[sourceName]["_total"] or 0) + damage
            if not entry[sourceName][targetName] then entry[sourceName][targetName] = {} end
            entry[sourceName][targetName][action] = (entry[sourceName][targetName][action] or 0) + damage
        end
    end

    -- ========================================================================
    -- 环境伤害吸收处理（ENVIRONMENTAL_DMG_* 事件）
    -- 参数顺序：victimGuid, dmgType, damage, absorb, resist
    -- ========================================================================
    local function onEnvironmentalDmgSelf(victimGuid, dmgType, damage, absorb, resist)
        if (dmgType == 3 or dmgType == 4 or dmgType == 5) and absorb > 0 then
            processAbsorb(victimGuid, envDmgSchool[dmgType] or 0, absorb)
        end
        local sourceName = "环境(" .. (ENV_DMG_NAMES[dmgType] or "未知") .. ")"
        recordDamageTaken(victimGuid, sourceName, sourceName, damage)
    end

    local function onEnvironmentalDmgOther(victimGuid, dmgType, damage, absorb, resist)
        if (dmgType == 3 or dmgType == 4 or dmgType == 5) and absorb > 0 and activeShields[victimGuid] then
            processAbsorb(victimGuid, envDmgSchool[dmgType] or 0, absorb)
        end
        local sourceName = "环境(" .. (ENV_DMG_NAMES[dmgType] or "未知") .. ")"
        recordDamageTaken(victimGuid, sourceName, sourceName, damage)
    end

    -- ========================================================================
    -- 法术伤害（自己施放） SPELL_DAMAGE_EVENT_SELF
    -- 参数顺序：targetGuid, casterGuid, spellId, amount, mitigationStr, hitInfo, spellSchool, effectAuraStr
    -- ========================================================================
    local function onSpellDamageSelf(targetGuid, casterGuid, spellId, amount, mitigationStr, hitInfo, spellSchool, effectAuraStr)
        local targetName = UnitName(targetGuid)
        local action = getSpellName(spellId)
        -- 判断是否为 DoT
        if effectAuraStr and effectAuraStr ~= "" then
            local effect = strsplit(effectAuraStr, ",")
            local auraType = tonumber(effect[4])
            if auraType == 3 or auraType == 89 then
                action = action .. " (DoT)"
            end
        end

        -- 忽略名单检查：如果目标在忽略列表中，记录无效伤害并返回
        if isNameIgnored(targetName) then
            addInvalidDamage(UnitName("player"), action, targetName, amount, spellSchool, 0)
            return
        end

        -- 提取吸收量并转为治疗
        local absorb = 0
        if mitigationStr and mitigationStr ~= "" then
            local m = strsplit(mitigationStr, ",")
            absorb = tonumber(m[1]) or 0
        end
        if absorb > 0 then processAbsorb(targetGuid, spellSchool, absorb) end

        if IsFriendly(targetGuid) then
            local sourceName = UnitName("player")
            local targetNameF = UnitName(targetGuid)
            recordFriendlyFire(GetUnitGUID("player"), sourceName, targetNameF, action, amount)
            if isUnitTracked(targetGuid) then
                recordDamageTaken(targetGuid, sourceName, action, amount)
            end
        end
        if config.hide_friendly_damage == 1 and IsFriendly(targetGuid) then return end
        if config.exclude_critters == 1 and IsCritter(targetGuid) then return end

        local rawDamage = amount
        local overkill = CalculateOverkill(targetGuid, rawDamage)
        local finalDamage = (config.clamp_damage_to_health ~= 1) and rawDamage or (rawDamage - overkill)
        updateStats(UnitName("player"), action, targetName, finalDamage, spellSchool, "damage", nil, nil, nil, overkill)

        -- 记录DOT跳数
        if action and string.find(action, "DoT") then
            recordDotTick(UnitName("player"), action, nil)
        end
    end

    -- ========================================================================
    -- 法术伤害（其他） SPELL_DAMAGE_EVENT_OTHER
    -- ========================================================================
    local function onSpellDamageOther(targetGuid, casterGuid, spellId, amount, mitigationStr, hitInfo, spellSchool, effectAuraStr)
        local targetName = UnitName(targetGuid)
        local action = getSpellName(spellId)
        if effectAuraStr and effectAuraStr ~= "" then
            local effect = strsplit(effectAuraStr, ",")
            local auraType = tonumber(effect[4])
            if auraType == 3 or auraType == 89 then
                action = action .. " (DoT)"
            end
        end

        -- 忽略名单检查
        if isNameIgnored(targetName) then
            -- 检查施法者是否被追踪（必要时考虑宠物主人）
            if not isUnitTracked(casterGuid) then
                local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
                if not ownerGUID or not isUnitTracked(ownerGUID) then
                    return
                end
            end
            local casterName = UnitName(casterGuid)
            local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)
            if ownerName and config.merge_pets == 1 then
                addInvalidDamage(ownerName, casterName .. " - " .. action, targetName, amount, spellSchool, 0)
            else
                addInvalidDamage(casterName, action, targetName, amount, spellSchool, 0)
            end
            return
        end

        local absorb = 0
        if mitigationStr and mitigationStr ~= "" then
            local m = strsplit(mitigationStr, ",")
            absorb = tonumber(m[1]) or 0
        end
        if absorb > 0 then processAbsorb(targetGuid, spellSchool, absorb) end

        local isFriendlyTarget = IsFriendly(targetGuid)
        if isFriendlyTarget then
            local casterName = UnitName(casterGuid)
            if casterName then
                local targetNameF = UnitName(targetGuid)
                recordFriendlyFire(casterGuid, casterName, targetNameF, action, amount)
                if isUnitTracked(targetGuid) then
                    recordDamageTaken(targetGuid, casterName, action, amount)
                end
            end
        end
        if config.hide_friendly_damage == 1 and isFriendlyTarget then return end
        if config.exclude_critters == 1 and IsCritter(targetGuid) then return end

        local rawDamage = amount
        local overkill = CalculateOverkill(targetGuid, rawDamage)
        local finalDamage = (config.clamp_damage_to_health ~= 1) and rawDamage or (rawDamage - overkill)

        if casterGuid == "0x0000000000000000" or targetGuid == "0x0000000000000000" then return end
        local casterName = UnitName(casterGuid)
        local targetNameLocal = UnitName(targetGuid)
        if isUnknownName(casterName) or isUnknownName(targetNameLocal) then
            local args = {targetGuid, casterGuid, spellId, amount, mitigationStr, hitInfo, spellSchool, effectAuraStr}
            parser:ScheduleEvent(onSpellDamageOther, args, {casterGuid, targetGuid})
            return
        end

        local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)
        local finalSourceName = casterName

        if ownerName then
            if config.merge_pets == 1 then
                finalSourceName = ownerName
            else
                finalSourceName = ownerName .. " - " .. casterName
            end
        end

        -- 如果攻击者不被追踪（且无被追踪的主人），则忽略此次伤害输出
        if not isUnitTracked(casterGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then
                return
            end
        end

        -- 记录攻击者伤害输出（考虑宠物合并）
        if ownerName then
            local petName = casterName
            if config.merge_pets == 1 then
                updateStats(petName, action, targetNameLocal, finalDamage, spellSchool, "damage", nil, nil, ownerName, overkill)
                if action and string.find(action, "DoT") then
                    recordDotTick(petName, action, ownerName)
                end
            else
                local displayName = ownerName .. " - " .. petName
                if not data["classes"][displayName] then data["classes"][displayName] = data["classes"][ownerName] or "__other__" end
                updateStats(displayName, action, targetNameLocal, finalDamage, spellSchool, "damage", nil, nil, ownerName, overkill)
                if action and string.find(action, "DoT") then
                    recordDotTick(petName, action, ownerName)
                end
            end
        else
            if UnitIsPlayer(casterGuid) then
                updateStats(casterName, action, targetNameLocal, finalDamage, spellSchool, "damage", nil, nil, nil, overkill)
                if action and string.find(action, "DoT") then
                    recordDotTick(casterName, action, nil)
                end
            end
        end
    end

    -- ========================================================================
    -- 自动攻击（自己施放） AUTO_ATTACK_SELF
    -- 参数：attackerGuid, targetGuid, totalDamage, hitInfo, victimState, subDamageCount, blockedAmount, totalAbsorb, totalResist
    -- ========================================================================
    local function onAutoAttackSelf(attackerGuid, targetGuid, totalDamage, hitInfo, victimState, subDamageCount, blockedAmount, totalAbsorb, totalResist)
        local targetName = UnitName(targetGuid)
        local attackerName = UnitName("player")
        local extra = parser.extraAttacks[attackerGuid]
        local action = "自动攻击"
        if extra then
            action = extra.ability
            if config.separate_mh_oh_damage == 1 and bit.band(hitInfo, 4) ~= 0 then
                action = action .. "(副手)"
            end
            -- 消耗额外攻击计数
            extra.count = extra.count - 1
            if extra.count <= 0 then
                parser.extraAttacks[attackerGuid] = nil
            end
        elseif config.separate_mh_oh_damage == 1 and bit.band(hitInfo, 4) ~= 0 then
            action = "自动攻击(副手)"
        end

        if isNameIgnored(targetName) then
            addInvalidDamage(UnitName("player"), action, targetName, totalDamage, 0, 0)
            return
        end

        if totalAbsorb and totalAbsorb > 0 then
            processAbsorb(targetGuid, 0, totalAbsorb)
        end
        local isFriendlyTarget = IsFriendly(targetGuid)
        if isFriendlyTarget then
            local sourceName = UnitName("player")
            local targetNameF = UnitName(targetGuid)
            recordFriendlyFire(GetUnitGUID("player"), sourceName, targetNameF, action, totalDamage)
            if isUnitTracked(targetGuid) then
                recordDamageTaken(targetGuid, sourceName, action, totalDamage)
            end
        end
        if config.hide_friendly_damage == 1 and isFriendlyTarget then return end
        if config.exclude_critters == 1 and IsCritter(targetGuid) then return end
        if victimState ~= 1 then return end  -- 未命中/闪避等不统计伤害

        local rawDamage = totalDamage
        local overkill = 0
        local health = GetUnitField(targetGuid, "health")
        if health == 0 then
            if healthCache[targetGuid] then
                overkill = rawDamage - healthCache[targetGuid]
                healthCache[targetGuid] = nil
            else
                local healthmax = GetUnitField(targetGuid, "maxHealth")
                if healthmax < rawDamage then
                    overkill = rawDamage - healthmax
                else
                    overkill = rawDamage
                end
                healthCache[targetGuid] = nil
            end
        end
        local finalDamage = (config.clamp_damage_to_health ~= 1) and rawDamage or (rawDamage - overkill)
        updateStats(UnitName("player"), action, UnitName(targetGuid), finalDamage, 0, "damage", nil, nil, nil, overkill)
        -- 记录自动攻击的施放次数
        local attackerName = UnitName("player")
        for segment = 0, 1 do
            local entry = data.spellcast[segment]
            if not entry[attackerName] then entry[attackerName] = { ["_total"] = 0 } end
            entry[attackerName]["_total"] = (entry[attackerName]["_total"] or 0) + 1
            entry[attackerName][action] = (entry[attackerName][action] or 0) + 1
        end
    end

    -- ========================================================================
    -- 自动攻击（其他） AUTO_ATTACK_OTHER
    -- ========================================================================
    local function onAutoAttackOther(attackerGuid, targetGuid, totalDamage, hitInfo, victimState, subDamageCount, blockedAmount, totalAbsorb, totalResist)
        local targetName = UnitName(targetGuid)
        local attackerName = UnitName(attackerGuid)

        -- 提前检测额外攻击并消耗，避免因后续 return 漏掉
        local extra = parser.extraAttacks[attackerGuid]
        local action = "自动攻击"
        if extra then
            action = extra.ability
            if config.separate_mh_oh_damage == 1 and bit.band(hitInfo, 4) ~= 0 then
                action = action .. "(副手)"
            end
            -- 消耗计数并可能清除记录
            extra.count = extra.count - 1
            if extra.count <= 0 then
                parser.extraAttacks[attackerGuid] = nil
            end
        elseif config.separate_mh_oh_damage == 1 and bit.band(hitInfo, 4) ~= 0 then
            action = "自动攻击(副手)"
        end

        if isNameIgnored(targetName) then
            -- 检查施法者是否被追踪
            if not isUnitTracked(attackerGuid) then
                local _, _, ownerGUID = GetOwnerInfoFromPetGUID(attackerGuid)
                if not ownerGUID or not isUnitTracked(ownerGUID) then
                    return
                end
            end
            local ownerName, _ = GetOwnerInfoFromPetGUID(attackerGuid)
            if ownerName and config.merge_pets == 1 then
                addInvalidDamage(ownerName, attackerName .. " - " .. action, targetName, totalDamage, 0, 0)
            else
                addInvalidDamage(attackerName, action, targetName, totalDamage, 0, 0)
            end
            return
        end

        if totalAbsorb and totalAbsorb > 0 then
            processAbsorb(targetGuid, 0, totalAbsorb)
        end
        local isFriendlyTarget = IsFriendly(targetGuid)
        if isFriendlyTarget then
            if attackerName then
                local targetNameF = UnitName(targetGuid)
                recordFriendlyFire(attackerGuid, attackerName, targetNameF, action, totalDamage)
                if isUnitTracked(targetGuid) then
                    recordDamageTaken(targetGuid, attackerName, action, totalDamage)
                end
            end
        end
        if config.hide_friendly_damage == 1 and isFriendlyTarget then return end
        if config.exclude_critters == 1 and IsCritter(targetGuid) then return end
        if victimState ~= 1 then return end

        local rawDamage = totalDamage
        local overkill = 0
        local health = GetUnitField(targetGuid, "health")
        if health == 0 then
            if healthCache[targetGuid] then
                overkill = rawDamage - healthCache[targetGuid]
                healthCache[targetGuid] = nil
            else
                local healthmax = GetUnitField(targetGuid, "maxHealth")
                if healthmax < rawDamage then
                    overkill = rawDamage - healthmax
                else
                    overkill = rawDamage
                end
                healthCache[targetGuid] = nil
            end
        end
        local finalDamage = (config.clamp_damage_to_health ~= 1) and rawDamage or (rawDamage - overkill)

        if attackerGuid == "0x0000000000000000" or targetGuid == "0x0000000000000000" then return end
        local targetNameLocal = UnitName(targetGuid)
        if isUnknownName(attackerName) or isUnknownName(targetNameLocal) then
            local args = {attackerGuid, targetGuid, totalDamage, hitInfo, victimState, subDamageCount, blockedAmount, totalAbsorb, totalResist}
            parser:ScheduleEvent(onAutoAttackOther, args, {attackerGuid, targetGuid})
            return
        end

        local ownerName, _ = GetOwnerInfoFromPetGUID(attackerGuid)
        local finalSourceName = attackerName

        if ownerName then
            if config.merge_pets == 1 then
                finalSourceName = ownerName
            else
                finalSourceName = ownerName .. " - " .. attackerName
            end
        end

        if not isUnitTracked(attackerGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(attackerGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then
                return
            end
        end

        if ownerName then
            local petName = attackerName
            if config.merge_pets == 1 then
                updateStats(petName, action, targetNameLocal, finalDamage, 0, "damage", nil, nil, ownerName, overkill)
            else
                local displayName = ownerName .. " - " .. petName
                if not data["classes"][displayName] then data["classes"][displayName] = data["classes"][ownerName] or "__other__" end
                updateStats(displayName, action, targetNameLocal, finalDamage, 0, "damage", nil, nil, ownerName, overkill)
            end
        else
            if UnitIsPlayer(attackerGuid) then
                updateStats(attackerName, action, targetNameLocal, finalDamage, 0, "damage", nil, nil, nil, overkill)
            end
        end

        -- 记录自动攻击的施放次数（考虑宠物归属）
        local finalName = attackerName
        local finalAction = action
        if ownerName then
            if config.merge_pets == 1 then
                finalName = ownerName
                finalAction = attackerName .. " - " .. action
            else
                finalName = ownerName .. " - " .. attackerName

                if not data["classes"][finalName] then
                    data["classes"][finalName] = data["classes"][ownerName] or "__other__"
                end
            end
        end
        for segment = 0, 1 do
            local entry = data.spellcast[segment]
            if not entry[finalName] then entry[finalName] = { ["_total"] = 0 } end
            entry[finalName]["_total"] = (entry[finalName]["_total"] or 0) + 1
            entry[finalName][finalAction] = (entry[finalName][finalAction] or 0) + 1
        end
    end

    -- ========================================================================
    -- 治疗（自己施放） SPELL_HEAL_BY_SELF
    -- ========================================================================
    local function onSpellHealBySelf(targetGuid, casterGuid, spellId, amount, critical, periodic)
        -- 治疗不检查忽略名单
        if not UnitCanAssist(targetGuid, casterGuid) then return end
        local sourceName = UnitName("player")
        local targetName = UnitName(targetGuid)
        local action = getSpellName(spellId)
        if periodic == 1 then action = action .. " (HoT)" end

        local health = GetUnitField(targetGuid, "health")
        local maxHealth = GetUnitField(targetGuid, "maxHealth")
        local effectiveHeal = amount
        if health and maxHealth then
            local missing = maxHealth - health
            if missing < 0 then missing = 0 end
            effectiveHeal = math.min(amount, missing)
        end
        recordHealTaken(targetGuid, sourceName, action, amount, effectiveHeal)
        updateStats(sourceName, action, targetName, amount, 0, "heal", effectiveHeal)

        -- 记录HoT跳数
        if periodic == 1 then
            recordDotTick(sourceName, action, nil)
        else
            -- 记录施法次数（非周期性）
            local finalName = sourceName
            local finalSpellName = action
            for segment = 0, 1 do
                local entry = data.spellcast[segment]
                if not entry[finalName] then entry[finalName] = { ["_total"] = 0 } end
                entry[finalName]["_total"] = (entry[finalName]["_total"] or 0) + 1
                entry[finalName][finalSpellName] = (entry[finalName][finalSpellName] or 0) + 1
            end
        end
    end

    -- ========================================================================
    -- 治疗（其他单位施放） SPELL_HEAL_BY_OTHER
    -- ========================================================================
    local function onSpellHealByOther(targetGuid, casterGuid, spellId, amount, critical, periodic)
        if not UnitCanAssist(targetGuid, casterGuid) then return end
        if not isUnitTracked(casterGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then return end
        end

        if casterGuid == "0x0000000000000000" or targetGuid == "0x0000000000000000" then return end
        local casterName = UnitName(casterGuid)
        local targetName = UnitName(targetGuid)

        if isUnknownName(casterName) or isUnknownName(targetName) then
            local args = {targetGuid, casterGuid, spellId, amount, critical, periodic}
            parser:ScheduleEvent(onSpellHealByOther, args, {casterGuid, targetGuid})
            return
        end

        local action = getSpellName(spellId)
        if periodic == 1 then action = action .. " (HoT)" end

        local health = GetUnitField(targetGuid, "health")
        local maxHealth = GetUnitField(targetGuid, "maxHealth")
        local effectiveHeal = amount
        if health and maxHealth then
            local missing = maxHealth - health
            if missing < 0 then missing = 0 end
            effectiveHeal = math.min(amount, missing)
        end

        local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)
        local finalCasterName = casterName
        if ownerName then
            if config.merge_pets == 1 then
                finalCasterName = ownerName
            else
                finalCasterName = ownerName .. " - " .. casterName
            end
        end
        recordHealTaken(targetGuid, finalCasterName, action, amount, effectiveHeal)

        if ownerName then
            local petName = casterName
            if config.merge_pets == 1 then
                updateStats(petName, action, targetName, amount, 0, "heal", effectiveHeal, nil, ownerName)
            else
                local displayName = ownerName .. " - " .. petName
                if not data["classes"][displayName] then
                    data["classes"][displayName] = data["classes"][ownerName] or "__other__"
                end
                updateStats(displayName, action, targetName, amount, 0, "heal", effectiveHeal, nil, ownerName)
            end

            -- 记录HoT跳数
            if periodic == 1 then
                recordDotTick(petName, action, ownerName)
            else
                -- 记录施法次数
                local finalName, finalSpellName
                if config.merge_pets == 1 then
                    finalName = ownerName
                    finalSpellName = petName .. " - " .. action
                else
                    finalName = ownerName .. " - " .. petName
                    finalSpellName = action
                    if not data["classes"][finalName] then
                        data["classes"][finalName] = data["classes"][ownerName] or "__other__"
                    end
                end
                for segment = 0, 1 do
                    local entry = data.spellcast[segment]
                    if not entry[finalName] then entry[finalName] = { ["_total"] = 0 } end
                    entry[finalName]["_total"] = (entry[finalName]["_total"] or 0) + 1
                    entry[finalName][finalSpellName] = (entry[finalName][finalSpellName] or 0) + 1
                end
            end
            return
        end

        if UnitIsPlayer(casterGuid) then
            updateStats(casterName, action, targetName, amount, 0, "heal", effectiveHeal)

            if periodic == 1 then
                recordDotTick(casterName, action, nil)
            else
                -- 记录施法次数
                local finalName = casterName
                local finalSpellName = action
                for segment = 0, 1 do
                    local entry = data.spellcast[segment]
                    if not entry[finalName] then entry[finalName] = { ["_total"] = 0 } end
                    entry[finalName]["_total"] = (entry[finalName]["_total"] or 0) + 1
                    entry[finalName][finalSpellName] = (entry[finalName][finalSpellName] or 0) + 1
                end
            end
        end
    end

    -- ========================================================================
    -- 盾反伤害（自己） DAMAGE_SHIELD_SELF
    -- ========================================================================
    local function onDamageShieldSelf(unitGuid, targetGuid, damage, spellSchool)
        local targetName = UnitName(targetGuid)
        if isNameIgnored(targetName) then
            addInvalidDamage(UnitName("player"), "反射", targetName, damage, spellSchool, 0)
            return
        end

        local isFriendlyTarget = IsFriendly(targetGuid)
        if isFriendlyTarget then
            local sourceName = UnitName("player")
            local targetNameF = UnitName(targetGuid)
            recordFriendlyFire(GetUnitGUID("player"), sourceName, targetNameF, "反射", damage)
            if isUnitTracked(targetGuid) then
                recordDamageTaken(targetGuid, sourceName, "反射", damage)
            end
        end
        if config.hide_friendly_damage == 1 and isFriendlyTarget then return end
        if config.exclude_critters == 1 and IsCritter(targetGuid) then return end

        local rawDamage = damage
        local overkill = CalculateOverkill(targetGuid, rawDamage)
        local finalDamage = (config.clamp_damage_to_health ~= 1) and rawDamage or (rawDamage - overkill)

        updateStats(UnitName("player"), "反射", targetName, finalDamage, spellSchool, "damage", nil, nil, nil, overkill)
    end

    -- ========================================================================
    -- 盾反伤害（其他） DAMAGE_SHIELD_OTHER
    -- ========================================================================
    local function onDamageShieldOther(unitGuid, targetGuid, damage, spellSchool)
        local targetName = UnitName(targetGuid)
        if isNameIgnored(targetName) then
            if not isUnitTracked(unitGuid) then
                local _, _, ownerGUID = GetOwnerInfoFromPetGUID(unitGuid)
                if not ownerGUID or not isUnitTracked(ownerGUID) then
                    return
                end
            end
            local unitName = UnitName(unitGuid)
            local ownerName, _ = GetOwnerInfoFromPetGUID(unitGuid)
            if ownerName and config.merge_pets == 1 then
                addInvalidDamage(ownerName, unitName .. " - 反射", targetName, damage, spellSchool, 0)
            else
                addInvalidDamage(unitName, "反射", targetName, damage, spellSchool, 0)
            end
            return
        end

        local isFriendlyTarget = IsFriendly(targetGuid)
        if isFriendlyTarget then
            local unitName = UnitName(unitGuid)
            if unitName then
                local targetNameF = UnitName(targetGuid)
                recordFriendlyFire(unitGuid, unitName, targetNameF, "反射", damage)
                if isUnitTracked(targetGuid) then
                    recordDamageTaken(targetGuid, unitName, "反射", damage)
                end
            end
        end
        if config.hide_friendly_damage == 1 and isFriendlyTarget then return end
        if config.exclude_critters == 1 and IsCritter(targetGuid) then return end

        local rawDamage = damage
        local overkill = CalculateOverkill(targetGuid, rawDamage)
        local finalDamage = (config.clamp_damage_to_health ~= 1) and rawDamage or (rawDamage - overkill)

        if unitGuid == "0x0000000000000000" or targetGuid == "0x0000000000000000" then return end
        local unitName = UnitName(unitGuid)
        local targetNameLocal = UnitName(targetGuid)

        if isUnknownName(unitName) or isUnknownName(targetNameLocal) then
            local args = {unitGuid, targetGuid, damage, spellSchool}
            parser:ScheduleEvent(onDamageShieldOther, args, {unitGuid, targetGuid})
            return
        end

        local ownerName, _ = GetOwnerInfoFromPetGUID(unitGuid)
        local finalSourceName = unitName

        if ownerName then
            if config.merge_pets == 1 then
                finalSourceName = ownerName
            else
                finalSourceName = ownerName .. " - " .. unitName
            end
        end

        if not isUnitTracked(unitGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(unitGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then
                return
            end
        end

        if ownerName then
            local petName = unitName
            if config.merge_pets == 1 then
                updateStats(petName, "反射", targetNameLocal, finalDamage, spellSchool, "damage", nil, nil, ownerName, overkill)
            else
                local displayName = ownerName .. " - " .. petName
                if not data["classes"][displayName] then
                    data["classes"][displayName] = data["classes"][ownerName] or "__other__"
                end
                updateStats(displayName, "反射", targetNameLocal, finalDamage, spellSchool, "damage", nil, nil, ownerName, overkill)
            end
        else
            if UnitIsPlayer(unitGuid) then
                updateStats(unitName, "反射", targetNameLocal, finalDamage, spellSchool, "damage", nil, nil, nil, overkill)
            end
        end
    end

    -- ========================================================================
    -- 驱散统计 SPELL_DISPEL_BY_SELF / SPELL_DISPEL_BY_OTHER
    -- ========================================================================
    local function onDispel(casterGuid, targetGuid, spellId)
        if not casterGuid or not targetGuid or not spellId then return end
        -- 驱散不涉及忽略名单检查

        if not isUnitTracked(casterGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then
                return
            end
        end

        local casterName = UnitName(casterGuid)
        local targetName = UnitName(targetGuid)

        if isUnknownName(casterName) or isUnknownName(targetName) then
            local args = {casterGuid, targetGuid, spellId}
            parser:ScheduleEvent(onDispel, args, {casterGuid, targetGuid})
            return
        end

        local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)
        local finalName = casterName
        if ownerName then
            if config.merge_pets == 1 then
                finalName = ownerName
            else
                finalName = ownerName .. " - " .. casterName
                if not data["classes"][finalName] then
                    data["classes"][finalName] = data["classes"][ownerName] or "__other__"
                end
            end
        end

        local dispelledSpellName = getSpellName(spellId)
        local isFriendly = UnitIsFriend("player", targetGuid)
        local dispelType = isFriendly and "defensive" or "offensive"

        for segment = 0, 1 do
            local entry = data.dispel[segment]
            if not entry[finalName] then
                entry[finalName] = { _total = 0, _offensive = 0, _defensive = 0 }
            end
            local playerEntry = entry[finalName]
            playerEntry._total = playerEntry._total + 1
            if dispelType == "offensive" then
                playerEntry._offensive = playerEntry._offensive + 1
            else
                playerEntry._defensive = playerEntry._defensive + 1
            end
            if not playerEntry[targetName] then playerEntry[targetName] = {} end
            local targetTable = playerEntry[targetName]
            targetTable[dispelledSpellName] = (targetTable[dispelledSpellName] or 0) + 1
        end
    end

    -- ========================================================================
    -- 能量回复事件
    -- ========================================================================
    local function onSpellEnergizeBySelf(targetGuid, casterGuid, spellId, powerType, amount, periodic)
        if not isUnitTracked(casterGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then return end
        end

        local casterName = UnitName("player")
        local action = getSpellName(spellId)
        local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)

        if ownerName then
            updateEnergizeStats(UnitName(casterGuid), action, UnitName(targetGuid), amount, powerType, ownerName)
        else
            updateEnergizeStats(casterName, action, UnitName(targetGuid), amount, powerType)
        end
    end

    local function onSpellEnergizeByOther(targetGuid, casterGuid, spellId, powerType, amount, periodic)
        if not isUnitTracked(casterGuid) then
            local _, _, ownerGUID = GetOwnerInfoFromPetGUID(casterGuid)
            if not ownerGUID or not isUnitTracked(ownerGUID) then return end
        end

        if casterGuid == "0x0000000000000000" then return end
        local casterName = UnitName(casterGuid)
        local targetName = UnitName(targetGuid)

        if isUnknownName(casterName) or isUnknownName(targetName) then
            parser:ScheduleEvent(onSpellEnergizeByOther, {targetGuid, casterGuid, spellId, powerType, amount, periodic}, {casterGuid, targetGuid})
            return
        end

        local ownerName, _ = GetOwnerInfoFromPetGUID(casterGuid)
        local action = getSpellName(spellId)

        if ownerName then
            updateEnergizeStats(UnitName(casterGuid), action, targetName, amount, powerType, ownerName)
        else
            if UnitIsPlayer(casterGuid) then
                updateEnergizeStats(casterName, action, targetName, amount, powerType)
            end
        end
    end

    -- ========================================================================
    -- 事件注册与分发
    -- ========================================================================
    parser:RegisterEvent("SPELL_DAMAGE_EVENT_SELF")
    parser:RegisterEvent("SPELL_DAMAGE_EVENT_OTHER")
    parser:RegisterEvent("AUTO_ATTACK_SELF")
    parser:RegisterEvent("AUTO_ATTACK_OTHER")
    parser:RegisterEvent("SPELL_HEAL_BY_SELF")
    parser:RegisterEvent("SPELL_HEAL_BY_OTHER")
    parser:RegisterEvent("DAMAGE_SHIELD_SELF")
    parser:RegisterEvent("DAMAGE_SHIELD_OTHER")
    parser:RegisterEvent("UNIT_DIED")
    parser:RegisterEvent("SPELL_GO_SELF")
    parser:RegisterEvent("SPELL_GO_OTHER")
    parser:RegisterEvent("SPELL_DISPEL_BY_SELF")
    parser:RegisterEvent("SPELL_DISPEL_BY_OTHER")
    parser:RegisterEvent("CHAT_MSG_ADDON")
    parser:RegisterEvent("PLAYER_TARGET_CHANGED")
    parser:RegisterEvent("PLAYER_ENTERING_WORLD")
    parser:RegisterEvent("AURA_CAST_ON_SELF")
    parser:RegisterEvent("AURA_CAST_ON_OTHER")
    parser:RegisterEvent("BUFF_REMOVED_SELF")
    parser:RegisterEvent("BUFF_REMOVED_OTHER")
    parser:RegisterEvent("DEBUFF_REMOVED_SELF")
    parser:RegisterEvent("DEBUFF_REMOVED_OTHER")
    parser:RegisterEvent("DEBUFF_ADDED_SELF")
    parser:RegisterEvent("DEBUFF_ADDED_OTHER")
    parser:RegisterEvent("ENVIRONMENTAL_DMG_SELF")
    parser:RegisterEvent("ENVIRONMENTAL_DMG_OTHER")
    parser:RegisterEvent("SPELL_ENERGIZE_BY_SELF")
    parser:RegisterEvent("SPELL_ENERGIZE_BY_OTHER")

    local currentTargetGUID = nil

    parser:SetScript("OnEvent", function()
        if event == "SPELL_DAMAGE_EVENT_SELF" then
            onSpellDamageSelf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        elseif event == "SPELL_DAMAGE_EVENT_OTHER" then
            onSpellDamageOther(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        elseif event == "AUTO_ATTACK_SELF" then
            onAutoAttackSelf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        elseif event == "AUTO_ATTACK_OTHER" then
            onAutoAttackOther(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        elseif event == "SPELL_HEAL_BY_SELF" then
            onSpellHealBySelf(arg1, arg2, arg3, arg4, arg5, arg6)
        elseif event == "SPELL_HEAL_BY_OTHER" then
            onSpellHealByOther(arg1, arg2, arg3, arg4, arg5, arg6)
        elseif event == "DAMAGE_SHIELD_SELF" then
            onDamageShieldSelf(arg1, arg2, arg3, arg4)
        elseif event == "DAMAGE_SHIELD_OTHER" then
            onDamageShieldOther(arg1, arg2, arg3, arg4)
        elseif event == "UNIT_DIED" then
            onUnitDied(arg1)
            if arg1 == "target" or (currentTargetGUID and arg1 == currentTargetGUID) then
                data.threat = {}
                currentTargetGUID = nil
            end
        elseif event == "SPELL_GO_SELF" then
            onSpellGo(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        elseif event == "SPELL_GO_OTHER" then
            onSpellGo(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        elseif event == "SPELL_DISPEL_BY_SELF" or event == "SPELL_DISPEL_BY_OTHER" then
            onDispel(arg1, arg2, arg3)
        elseif event == "CHAT_MSG_ADDON" then
            if string.find(arg1, "TWT") and arg2 and string.find(arg2, "TWTv4=") then
                parseThreatPacket(arg2)
            end
        elseif event == "PLAYER_TARGET_CHANGED" then
            data.threat = {}
            currentTargetGUID = nil
            if UnitExists("target") and not UnitIsPlayer("target") then
                currentTargetGUID = GetUnitGUID("target")
            end
            for id, callback in pairs(parser.callbacks.refresh) do callback() end
        elseif event == "PLAYER_ENTERING_WORLD" then
            -- 不再需要清除 GUID 忽略列表
        elseif event == "AURA_CAST_ON_SELF" or event == "AURA_CAST_ON_OTHER" then
            onAuraCast(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)

            -- 额外攻击识别（累加计数）
            local spellId = arg1
            local casterGuid = arg2
            local spellName = getSpellName(spellId)
            if extraAttackAbilities[spellName] then
                local casterName = UnitName(casterGuid)
                if casterName then
                    if parser.extraAttacks[casterGuid] then
                        parser.extraAttacks[casterGuid].count = parser.extraAttacks[casterGuid].count + 1
                        parser.extraAttacks[casterGuid].ability = spellName
                    else
                        parser.extraAttacks[casterGuid] = { count = 1, ability = spellName }
                    end
                end
            end
        elseif event == "BUFF_REMOVED_SELF" or event == "BUFF_REMOVED_OTHER" or event == "DEBUFF_REMOVED_SELF" or event == "DEBUFF_REMOVED_OTHER" then
            onBuffRemoved(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        elseif event == "DEBUFF_ADDED_SELF" or event == "DEBUFF_ADDED_OTHER" then
            onBuffAdded(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        elseif event == "ENVIRONMENTAL_DMG_SELF" then
            onEnvironmentalDmgSelf(arg1, arg2, arg3, arg4, arg5)
        elseif event == "ENVIRONMENTAL_DMG_OTHER" then
            onEnvironmentalDmgOther(arg1, arg2, arg3, arg4, arg5)
        elseif event == "SPELL_ENERGIZE_BY_SELF" then
            onSpellEnergizeBySelf(arg1, arg2, arg3, arg4, arg5, arg6)
        elseif event == "SPELL_ENERGIZE_BY_OTHER" then
            onSpellEnergizeByOther(arg1, arg2, arg3, arg4, arg5, arg6)
        end
        for id, callback in pairs(parser.callbacks.refresh) do callback() end
    end)
end

-- 刷新回调表，供窗口模块注册更新
parser.callbacks = { ["refresh"] = {} }