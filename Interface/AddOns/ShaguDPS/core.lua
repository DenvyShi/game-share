--[[
    ShaguDPS 核心模块
    负责初始化全局数据表、默认配置、通用工具函数，并检测 Nampower 扩展是否可用。
    所有其他模块（解析器、窗口、设置）都依赖于此模块导出的 ShaguDPS 表。
]]

ShaguDPS = {}

-- 创建一个通用的确认/取消对话框模板，用于清空数据等需要用户确认的操作
StaticPopupDialogs["SHAGUMETER_QUESTION"] = {
    button1 = YES,
    button2 = NO,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
}

-- 可用的状态栏材质列表，用于进度条外观切换
local textures = {
    "Interface\\BUTTONS\\WHITE8X8",
    "Interface\\TargetingFrame\\UI-StatusBar",
    "Interface\\Tooltips\\UI-Tooltip-Background",
    "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar"
}

-- 简单的四舍五入函数
-- @param input 要舍入的数值
-- @param places 保留的小数位数，默认为 0
-- @return 舍入后的数值
local function round(input, places)
    if not places then places = 0 end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, places do pow = pow * 10 end
        return floor(input * pow + 0.5) / pow
    end
end

-- 检测当前客户端版本（香草/TBC/WOTLK），用于不同扩展的兼容处理
-- @return "tbc", "wotlk" 或 "vanilla"
local function expansion()
    local _, _, _, client = GetBuildInfo()
    client = client or 11200

    if client >= 20000 and client <= 20400 then
        return "tbc"
    elseif client >= 30000 and client <= 30300 then
        return "wotlk"
    else
        return "vanilla"
    end
end

-- ===========================================================================
-- 全局数据存储结构
-- data 表包含所有统计类型（伤害、治疗、死亡、技能施放、误伤、驱散、仇恨、破甲、承受伤害、能量回复、无效伤害）
-- 每种统计分为两个段：
--   [0] = 全程数据（自插件运行以来累积）
--   [1] = 当前战斗数据（进入战斗后到脱离战斗，或由缓存恢复的上一次战斗）
-- 单位数据通过单位名称作为 key 存储子表。
-- invalid_damage 内按源玩家名存储，_by_target 映射目标名到子表
-- ===========================================================================
local data = {
    damage = {
        [0] = {},  -- 全程伤害
        [1] = {},  -- 当前战斗伤害
    },
    heal = {
        [0] = {},
        [1] = {},
    },
    death = {     -- 死亡次数
        [0] = {},
        [1] = {},
    },
    spellcast = { -- 技能施放次数
        [0] = {},
        [1] = {},
    },
    friendly_fire = { -- 队友误伤
        [0] = {},
        [1] = {},
    },
    dispel = {          -- 驱散统计（进攻/防御）
        [0] = {},
        [1] = {},
    },
    sunder = {          -- 破甲统计
        [0] = {},
        [1] = {},
    },
    damage_taken = {    -- 承受伤害统计
        [0] = {},
        [1] = {},
    },
    energize = {        -- 能量回复统计（法力/怒气/能量/集中/快乐）
        [0] = {},
        [1] = {},
    },
    invalid_damage = {  -- 无效伤害（对忽略列表单位造成的伤害）
        [0] = {},
        [1] = {},
    },
    heal_taken = {      -- 受到治疗统计
        [0] = {},
        [1] = {},
    },
    dot_ticks = {          -- DOT跳数（每跳触发次数）
        [0] = {},
        [1] = {},
    },
    classes = {},       -- 单位名称 -> 职业字符串 或 主人名称（宠物）的缓存映射
    threat = {},        -- 当前目标的仇恨列表 { [玩家名] = { threat = 数值, tank = bool, perc = 百分比, tps = 威胁/秒, class = 职业 } }
    threat_history = {},-- 用于计算 TPS 的历史威胁值 { [name] = { [timestamp] = threat } }
    death_timestamps = {},  -- 死亡时间戳记录 { [单位名] = { 死亡时间1, 死亡时间2, ... } }
}

data.combat_start_time = 0    -- 当前战斗开始时间（秒）
data.last_fight_duration = 0  -- 当前战斗时长（秒）
data.total_combat_time = 0    -- 全程总战斗时长（秒）

-- 临时表（可能遗留的未使用变量，保留以维护兼容性）
local dmg_table = {}
local view_dmg_all = { }
local view_dps_all = { }
local playerClasses = {}

-- ===========================================================================
-- 用户配置默认值（可通过 /sdps 命令或设置面板修改）
-- 配置保存在 SavedVariables PerCharacter: ShaguDPS_Config
-- ===========================================================================
local config = {
    -- 进度条尺寸
    height = 15,        -- 条高度（像素）
    spacing = 0,        -- 条间距（像素）

    -- 追踪选项
    track_all_units = 0,   -- 是否追踪所有附近单位（否则只追踪小队/团队成员）
    merge_pets = 1,        -- 是否将宠物数据合并到主人名下

    -- 外观选项
    visible = 1,           -- 是否显示主窗口
    backdrop = 1,          -- 是否显示窗口背景和边框
    texture = 2,           -- 当前使用的材质索引（对应 textures 表）
    pastel = 0,            -- 是否使用柔和色调（降低职业颜色饱和度）
    lock = 0,              -- 是否锁定窗口位置

    -- Nampower 专用高级选项（仅在 Nampower 4.5+ 可用时生效）
    exclude_critters = 0,      -- 是否排除小动物伤害
    hide_friendly_damage = 0,  -- 是否隐藏队友误伤数据
    clamp_damage_to_health = 0,-- 是否将伤害限制为目标当前血量（溢出部分不计入伤害量，但可显示为溢出）
    heal_only_in_combat = 1,   -- 是否只在战斗中统计治疗
    show_dps_in_damage = 1,    -- 伤害量页面是否额外显示秒伤
    show_hps_in_heal = 0,      -- 治疗量视图是否额外显示每秒治疗 (HPS)
    show_overkill = 0,         -- 伤害量页面是否显示溢出伤害
    hide_nondefault_threat_out_of_combat = 0,  -- 在非团队/小队且非战斗时隐藏非默认仇恨窗口
    show_only_tank_and_self_in_threat = 0,    -- 仇恨视图只显示坦克和自己
    menu_grow_upwards = 0,     -- 菜单按钮向上生长（默认关闭）
    scale = 1.0,               -- 插件整体缩放比例
    report_lines = 10,         -- 发送聊天数据条数（默认10）
    pfuiStyle = 0,             -- 启用 pfUI 风格皮肤（0=关闭，1=开启）
    auto_reset_on_new_group = 1,   -- 进入新队伍时是否询问清空数据
    separate_mh_oh_damage = 0,   -- 分开统计主副手伤害（0=合并，1=分开）
    use_total_cbt_for_dps = 0,      -- 0=EDPS(活跃时间), 1=DPS(总战斗时间)
}

-- 内部特殊字段名集合，用于在遍历技能列表时跳过这些元数据字段
local internals = {
    ["_sum"] = true,          -- 总伤害/治疗量（原始）
    ["_ctime"] = true,        -- 活跃战斗时间（用于计算 DPS/HPS）
    ["_tick"] = true,         -- 上次更新活跃时间的时间戳
    ["_esum"] = true,         -- 有效治疗量（扣除过量）
    ["_effective"] = true,    -- 每个技能的有效治疗量
    ["_total"] = true,        -- 技能施放/误伤/驱散/破甲计数
    ["_offensive"] = true,    -- 进攻驱散次数
    ["_defensive"] = true,    -- 防御驱散次数
    ["_overkill"] = true,     -- 溢出伤害总量
    ["_overkill_by_spell"] = true, -- 每个技能的溢出伤害
    ["_history"] = true,      -- 承受伤害历史记录
    ["_by_type"] = true,      -- 能量回复按类型细分（powerType -> amount）
    ["_by_target"] = true,    -- 无效伤害按目标分组
}

-- 创建核心组件框架（实际内容在其他文件中填充）
local settings = CreateFrame("Frame", nil, UIParent)  -- 设置窗口
local parser = CreateFrame("Frame")                   -- 事件解析器
local window = {}                                     -- 主窗口数组（window[1], window[2] ...）

-- 将内部变量暴露到全局 ShaguDPS 表，供其他模块通过 ShaguDPS.xxx 访问
ShaguDPS.data = data
ShaguDPS.config = config
ShaguDPS.textures = textures
ShaguDPS.window = window
ShaguDPS.settings = settings
ShaguDPS.internals = internals
ShaguDPS.parser = parser
ShaguDPS.round = round
ShaguDPS.expansion = expansion

-- BOSS 战记录列表，存储每次有首领死亡且脱战后的快照
-- 每个元素为 { name = 主要首领名, timestamp = 战斗开始时间, bosses = {首领名...}, damage, heal, death, ... }
ShaguDPS.boss_fights = ShaguDPS.boss_fights or {}

-- 清除所有 BOSS 战数据（包括缓存）
function ShaguDPS.ClearBossFights()
    for i = table.getn(ShaguDPS.boss_fights), 1, -1 do
        table.remove(ShaguDPS.boss_fights, i)
    end
    if ShaguDPS_Cache then
        ShaguDPS_Cache.boss_fights = {}
    end
end

-- 检测 Nampower 是否可用且版本 >= 4.5.0（需要驱散事件等高级功能）
local function checkNampower()
    if not GetNampowerVersion then
        return false
    end
    local major, minor, patch = GetNampowerVersion()
    if major and (major > 4 or (major == 4 and minor >= 5)) then
        return true
    end
    return false
end

ShaguDPS.hasNampower = checkNampower()
if not ShaguDPS.hasNampower and GetNampowerVersion then
    -- Nampower 存在但版本过低，提示回退到战斗日志解析模式
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ShaguDPS: 需要 Nampower 4.5.0 或更高版本才能使用精确数据采集，已回退到战斗日志解析模式。|r")
end

-- 用于在战斗结束后缓存当前战斗数据的快照，以便在非战斗时仍能查看上一场战斗
ShaguDPS.cached_current_dispel = nil          -- 驱散缓存
ShaguDPS.cached_current_damage_taken = nil    -- 承受伤害缓存
ShaguDPS.cached_current_heal_taken = nil    -- 受到治疗缓存
-- 其他类型的缓存字段在 parser.lua 中动态赋值（如 cached_current_damage 等）

-- 缓存数据保存变量（持久化到 SavedVariables: ShaguDPS_Cache）
ShaguDPS_Cache = ShaguDPS_Cache or {}

-- 将当前所有统计数据保存到缓存变量（供下次登录恢复）
function ShaguDPS.SaveDataToCache()
    if not ShaguDPS_Cache then ShaguDPS_Cache = {} end
    ShaguDPS_Cache.version = 1  -- 缓存版本，用于未来兼容
    ShaguDPS_Cache.timestamp = GetTime()
    -- 保存全程数据（索引0）
    ShaguDPS_Cache.damage0 = data.damage[0]
    ShaguDPS_Cache.heal0 = data.heal[0]
    ShaguDPS_Cache.death0 = data.death[0]
    ShaguDPS_Cache.spellcast0 = data.spellcast[0]
    ShaguDPS_Cache.friendly_fire0 = data.friendly_fire[0]
    ShaguDPS_Cache.dispel0 = data.dispel[0]
    ShaguDPS_Cache.sunder0 = data.sunder[0]
    ShaguDPS_Cache.damage_taken0 = data.damage_taken[0]
    ShaguDPS_Cache.energize0 = data.energize[0]
    ShaguDPS_Cache.invalid_damage0 = data.invalid_damage[0]
    ShaguDPS_Cache.heal_taken0 = data.heal_taken[0]
    ShaguDPS_Cache.dot_ticks0 = data.dot_ticks[0]
    -- 保存当前战斗数据快照（用于恢复查看）
    ShaguDPS_Cache.damage1 = data.damage[1]
    ShaguDPS_Cache.heal1 = data.heal[1]
    ShaguDPS_Cache.death1 = data.death[1]
    ShaguDPS_Cache.spellcast1 = data.spellcast[1]
    ShaguDPS_Cache.friendly_fire1 = data.friendly_fire[1]
    ShaguDPS_Cache.dispel1 = data.dispel[1]
    ShaguDPS_Cache.sunder1 = data.sunder[1]
    ShaguDPS_Cache.damage_taken1 = data.damage_taken[1]
    ShaguDPS_Cache.energize1 = data.energize[1]
    ShaguDPS_Cache.invalid_damage1 = data.invalid_damage[1]
    ShaguDPS_Cache.heal_taken1 = data.heal_taken[1]
    ShaguDPS_Cache.dot_ticks1 = data.dot_ticks[1]
    -- 保存职业映射
    ShaguDPS_Cache.classes = data.classes
    -- 保存 BOSS 战斗记录
    ShaguDPS_Cache.boss_fights = ShaguDPS.boss_fights
    ShaguDPS_Cache.death_timestamps = data.death_timestamps
    ShaguDPS_Cache.total_combat_time = data.total_combat_time
end

-- 从缓存中加载统计数据（登录时调用）
-- @return true 如果缓存存在并成功加载，否则 false
function ShaguDPS.LoadDataFromCache()
    if not ShaguDPS_Cache or not ShaguDPS_Cache.version then
        return false
    end
    -- 恢复全程数据
    if ShaguDPS_Cache.damage0 then data.damage[0] = ShaguDPS_Cache.damage0 end
    if ShaguDPS_Cache.heal0 then data.heal[0] = ShaguDPS_Cache.heal0 end
    if ShaguDPS_Cache.death0 then data.death[0] = ShaguDPS_Cache.death0 end
    if ShaguDPS_Cache.spellcast0 then data.spellcast[0] = ShaguDPS_Cache.spellcast0 end
    if ShaguDPS_Cache.friendly_fire0 then data.friendly_fire[0] = ShaguDPS_Cache.friendly_fire0 end
    if ShaguDPS_Cache.dispel0 then data.dispel[0] = ShaguDPS_Cache.dispel0 end
    if ShaguDPS_Cache.sunder0 then data.sunder[0] = ShaguDPS_Cache.sunder0 end
    if ShaguDPS_Cache.damage_taken0 then data.damage_taken[0] = ShaguDPS_Cache.damage_taken0 end
    if ShaguDPS_Cache.energize0 then data.energize[0] = ShaguDPS_Cache.energize0 end
    if ShaguDPS_Cache.invalid_damage0 then data.invalid_damage[0] = ShaguDPS_Cache.invalid_damage0 end
    if ShaguDPS_Cache.heal_taken0 then data.heal_taken[0] = ShaguDPS_Cache.heal_taken0 end
    if ShaguDPS_Cache.dot_ticks0 then data.dot_ticks[0] = ShaguDPS_Cache.dot_ticks0 end
    -- 恢复当前战斗缓存（作为快照显示，此时当前段为空）
    if ShaguDPS_Cache.damage1 then
        ShaguDPS.cached_current_damage = ShaguDPS_Cache.damage1
        data.damage[1] = {}  -- 当前段仍为空，战斗结束后数据移到缓存中
    end
    if ShaguDPS_Cache.heal1 then ShaguDPS.cached_current_heal = ShaguDPS_Cache.heal1 end
    if ShaguDPS_Cache.death1 then ShaguDPS.cached_current_death = ShaguDPS_Cache.death1 end
    if ShaguDPS_Cache.spellcast1 then ShaguDPS.cached_current_spellcast = ShaguDPS_Cache.spellcast1 end
    if ShaguDPS_Cache.friendly_fire1 then ShaguDPS.cached_current_friendly_fire = ShaguDPS_Cache.friendly_fire1 end
    if ShaguDPS_Cache.dispel1 then ShaguDPS.cached_current_dispel = ShaguDPS_Cache.dispel1 end
    if ShaguDPS_Cache.sunder1 then data.sunder[1] = ShaguDPS_Cache.sunder1 end
    if ShaguDPS_Cache.damage_taken1 then
        ShaguDPS.cached_current_damage_taken = ShaguDPS_Cache.damage_taken1
        data.damage_taken[1] = {}
    end
    if ShaguDPS_Cache.energize1 then
        ShaguDPS.cached_current_energize = ShaguDPS_Cache.energize1
        data.energize[1] = {}
    end
    if ShaguDPS_Cache.invalid_damage1 then
        ShaguDPS.cached_current_invalid_damage = ShaguDPS_Cache.invalid_damage1
        data.invalid_damage[1] = {}
    end
    if ShaguDPS_Cache.heal_taken1 then
        ShaguDPS.cached_current_heal_taken = ShaguDPS_Cache.heal_taken1
        data.heal_taken[1] = {}
    end
    if ShaguDPS_Cache.dot_ticks1 then
        ShaguDPS.cached_current_dot_ticks = ShaguDPS_Cache.dot_ticks1
        data.dot_ticks[1] = {}
    end
    -- 恢复职业映射
    if ShaguDPS_Cache.classes then data.classes = ShaguDPS_Cache.classes end
    -- 恢复 BOSS 战斗记录
    if ShaguDPS_Cache.boss_fights then ShaguDPS.boss_fights = ShaguDPS_Cache.boss_fights end
    if ShaguDPS_Cache.death_timestamps then
        data.death_timestamps = ShaguDPS_Cache.death_timestamps
    end
    if ShaguDPS_Cache.total_combat_time then data.total_combat_time = ShaguDPS_Cache.total_combat_time end
    return true
end

-- 清除缓存（重置保存变量）
function ShaguDPS.ClearCache()
    ShaguDPS_Cache = {}
    ShaguDPS.cached_current_damage = nil
    ShaguDPS.cached_current_heal = nil
    ShaguDPS.cached_current_death = nil
    ShaguDPS.cached_current_spellcast = nil
    ShaguDPS.cached_current_friendly_fire = nil
    ShaguDPS.cached_current_dispel = nil
    ShaguDPS.cached_current_damage_taken = nil
    ShaguDPS.cached_current_energize = nil
    ShaguDPS.cached_current_invalid_damage = nil
    ShaguDPS.cached_current_heal_taken = nil
    ShaguDPS.cached_current_dot_ticks = nil
    ShaguDPS.boss_fights = {}
    data.sunder[0] = {}
    data.sunder[1] = {}
    data.damage_taken[0] = {}
    data.damage_taken[1] = {}
    data.energize[0] = {}
    data.energize[1] = {}
    data.invalid_damage[0] = {}
    data.invalid_damage[1] = {}
    data.heal_taken[0] = {}
    data.heal_taken[1] = {}
    data.dot_ticks[0] = {}
    data.dot_ticks[1] = {}
    data.death_timestamps = {}  -- 清空死亡时间戳
    data.total_combat_time = 0
end

-- ===========================================================================
-- 全局无效单位名字列表（造成伤害时不统计入正常伤害，而是归入“无效伤害”视图）
-- 您可以在此表中添加/移除单位名字。注：名字必须与游戏中显示完全一致。
-- ===========================================================================
local locale = GetLocale()

if locale == "zhCN" then
    ShaguDPS.ignoredUnitNames = ShaguDPS.ignoredUnitNames or {
        ["死亡骑士学员"] = true,
        ["势不可挡的地狱火"] = true,
        ["虚空地狱火"] = true,
        ["恶魔之心"] = true,
    }
else
    ShaguDPS.ignoredUnitNames = ShaguDPS.ignoredUnitNames or {
        ["Deathknight Understudy"] = true,
        ["Unstoppable Infernal"] = true,
        ["Nether Infernal"] = true,
        ["Felheart"] = true,
    }
end