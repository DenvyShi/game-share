--[[
    ShaguDPS 战斗日志解析模块（回退模式）
    当 Nampower 不可用时，通过监听聊天消息中的战斗日志事件来解析伤害/治疗。
    使用复杂的正则模式匹配不同语言版本的战斗日志字符串。
    本模块只在 ShaguDPS.hasNampower 为 false 时生效。
]]

-- 如果 Nampower 已启用，则直接退出此文件，不使用旧版聊天解析
if ShaguDPS.hasNampower then
    return
end

local parser = ShaguDPS.parser

-- ===========================================================================
-- 模式预处理：将 WoW 内置的本地化战斗日志模式转换为 Lua 可用的匹配模式
-- ===========================================================================

-- 缓存已转换的模式，避免重复处理
local sanitize_cache = {}

-- 将 WoW 的战斗日志模式字符串转换为 Lua 的 gfind 兼容模式
-- 例如：转义特殊字符，替换 %s 为 .+，替换数字捕获等
function sanitize(pattern)
    if not sanitize_cache[pattern] then
        local ret = pattern
        -- 转义 Lua 模式特殊字符
        ret = gsub(ret, "([%+%-%*%(%)%?%[%]%^])", "%%%1")
        -- 移除数字美元符号（WoW 的捕获索引标记）
        ret = gsub(ret, "%d%$","")
        -- 将 %a、%d 等替换为对应的捕获组
        ret = gsub(ret, "(%%%a)","%(%1+%)")
        -- 将 %s+ 替换为 .+ （匹配任意字符串）
        ret = gsub(ret, "%%s%+",".+")
        -- 处理可能出现的嵌套捕获
        ret = gsub(ret, "%(.%+%)%(%%d%+%)","%(.-%)%(%%d%+%)")
        sanitize_cache[pattern] = ret
    end
    return sanitize_cache[pattern]
end

-- ===========================================================================
-- 捕获索引解析：从 WoW 模式中提取各捕获组在转换后模式中的位置顺序
-- ===========================================================================

-- 缓存每个模式的捕获索引
local capture_cache = {}

-- 获取模式的各个捕获组在转换后模式中的位置索引（用于重排捕获顺序）
-- 返回值：a, b, c, d, e 分别对应第1~5个捕获组在模式中的原始数字索引
-- 例如模式中有 %1$s、%2$d 等，则 a=1, b=2 等
function captures(pat)
    local r = capture_cache
    if not r[pat] then
        r[pat] = { nil, nil, nil, nil, nil }
        -- 提取模式中的数字捕获引用
        for a, b, c, d, e in string.gfind(gsub(pat, "%((.+)%)", "%1"), gsub(pat, "%d%$", "%%(.-)$")) do
            r[pat][1] = tonumber(a)
            r[pat][2] = tonumber(b)
            r[pat][3] = tonumber(c)
            r[pat][4] = tonumber(d)
            r[pat][5] = tonumber(e)
        end
    end
    return r[pat][1], r[pat][2], r[pat][3], r[pat][4], r[pat][5]
end

-- ===========================================================================
-- 自定义的字符串匹配函数 cfind
-- 支持最多 5 个捕获组，并根据模式中指定的数字索引重新排列捕获结果
-- 例如模式中有 %2$s、%1$d，则返回时会将第二个捕获放在 ra，第一个放在 rb
-- ===========================================================================
local ra, rb, rc, rd, re, a, b, c, d, e, match, num, va, vb, vc, vd, ve
function cfind(str, pat)
    -- 获取模式的捕获索引
    a, b, c, d, e = captures(pat)
    -- 执行匹配
    match, num, va, vb, vc, vd, ve = string.find(str, sanitize(pat))
    -- 根据捕获索引重新排列结果到 ra~re
    ra = e == 1 and ve or d == 1 and vd or c == 1 and vc or b == 1 and vb or va
    rb = e == 2 and ve or d == 2 and vd or c == 2 and vc or a == 2 and va or vb
    rc = e == 3 and ve or d == 3 and vd or a == 3 and va or b == 3 and vb or vc
    rd = e == 4 and ve or a == 4 and va or c == 4 and vc or b == 4 and vb or vd
    re = a == 5 and va or d == 5 and vd or c == 5 and vc or b == 5 and vb or ve
    return match, num, ra, rb, rc, rd, re
end

-- ===========================================================================
-- 战斗日志模式分类
-- 将 WoW 提供的本地化战斗日志字符串按伤害类型分组
-- ===========================================================================

-- 每种伤害/治疗类型可能对应多个本地化模式（例如普通命中、暴击、带学派的暴击等）
local combatlog_strings = {
    ["Hit Damage (self vs. other)"] = {
        COMBATHITSELFOTHER, COMBATHITSCHOOLSELFOTHER, COMBATHITCRITSELFOTHER, COMBATHITCRITSCHOOLSELFOTHER
    },
    ["Hit Damage (other vs. self)"] = {
        COMBATHITOTHERSELF, COMBATHITCRITOTHERSELF, COMBATHITSCHOOLOTHERSELF, COMBATHITCRITSCHOOLOTHERSELF
    },
    ["Hit Damage (other vs. other)"] = {
        COMBATHITOTHEROTHER, COMBATHITCRITOTHEROTHER, COMBATHITSCHOOLOTHEROTHER, COMBATHITCRITSCHOOLOTHEROTHER
    },
    ["Spell Damage (self vs. self/other)"] = {
        SPELLLOGSCHOOLSELFSELF, SPELLLOGCRITSCHOOLSELFSELF, SPELLLOGSELFSELF, SPELLLOGCRITSELFSELF, SPELLLOGSCHOOLSELFOTHER, SPELLLOGCRITSCHOOLSELFOTHER, SPELLLOGSELFOTHER, SPELLLOGCRITSELFOTHER
    },
    ["Spell Damage (other vs. self)"] = {
        SPELLLOGSCHOOLOTHERSELF, SPELLLOGCRITSCHOOLOTHERSELF, SPELLLOGOTHERSELF, SPELLLOGCRITOTHERSELF
    },
    ["Spell Damage (other vs. other)"] = {
        SPELLLOGSCHOOLOTHEROTHER, SPELLLOGCRITSCHOOLOTHEROTHER, SPELLLOGOTHEROTHER, SPELLLOGCRITOTHEROTHER
    },
    ["Shield Damage (self vs. other)"] = {
        DAMAGESHIELDSELFOTHER
    },
    ["Shield Damage (other vs. self/other)"] = {
        DAMAGESHIELDOTHERSELF, DAMAGESHIELDOTHEROTHER
    },
    ["Periodic Damage (self/other vs. other)"] = {
        PERIODICAURADAMAGESELFOTHER, PERIODICAURADAMAGEOTHEROTHER
    },
    ["Periodic Damage (self/other vs. self)"] = {
        PERIODICAURADAMAGESELFSELF, PERIODICAURADAMAGEOTHERSELF
    },
    ["Heal (self vs. self/other)"] = {
        HEALEDCRITSELFSELF, HEALEDSELFSELF, HEALEDCRITSELFOTHER, HEALEDSELFOTHER
    },
    ["Heal (other vs. self/other)"] = {
        HEALEDCRITOTHERSELF, HEALEDOTHERSELF, HEALEDCRITOTHEROTHER, HEALEDOTHEROTHER
    },
    ["Periodic Heal (self/other vs. other)"] = {
        PERIODICAURAHEALSELFOTHER, PERIODICAURAHEALOTHEROTHER
    },
    ["Periodic Heal (other vs. self/other)"] = {
        PERIODICAURAHEALSELFSELF, PERIODICAURAHEALOTHERSELF
    }
}

-- 将聊天事件类型映射到对应的战斗日志模式列表
local combatlog_events = {
    ["CHAT_MSG_COMBAT_SELF_HITS"] = combatlog_strings["Hit Damage (self vs. other)"],
    ["CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS"] = combatlog_strings["Hit Damage (other vs. self)"],
    ["CHAT_MSG_COMBAT_PARTY_HITS"] = combatlog_strings["Hit Damage (other vs. other)"],
    ["CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS"] = combatlog_strings["Hit Damage (other vs. other)"],
    ["CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS"] = combatlog_strings["Hit Damage (other vs. other)"],
    ["CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS"] = combatlog_strings["Hit Damage (other vs. other)"],
    ["CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS"] = combatlog_strings["Hit Damage (other vs. other)"],
    ["CHAT_MSG_COMBAT_PET_HITS"] = combatlog_strings["Hit Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_SELF_DAMAGE"] = combatlog_strings["Spell Damage (self vs. self/other)"],
    ["CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"] = combatlog_strings["Spell Damage (other vs. self)"],
    ["CHAT_MSG_SPELL_PARTY_DAMAGE"] = combatlog_strings["Spell Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"] = combatlog_strings["Spell Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"] = combatlog_strings["Spell Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"] = combatlog_strings["Spell Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE"] = combatlog_strings["Spell Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_PET_DAMAGE"] = combatlog_strings["Spell Damage (other vs. other)"],
    ["CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF"] = combatlog_strings["Shield Damage (self vs. other)"],
    ["CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS"] = combatlog_strings["Shield Damage (other vs. self/other)"],
    ["CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE"] = combatlog_strings["Periodic Damage (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE"] = combatlog_strings["Periodic Damage (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE"] = combatlog_strings["Periodic Damage (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"] = combatlog_strings["Periodic Damage (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"] = combatlog_strings["Periodic Damage (self/other vs. self)"],
    ["CHAT_MSG_SPELL_SELF_BUFF"] = combatlog_strings["Heal (self vs. self/other)"],
    ["CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF"] = combatlog_strings["Heal (other vs. self/other)"],
    ["CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"] = combatlog_strings["Heal (other vs. self/other)"],
    ["CHAT_MSG_SPELL_PARTY_BUFF"] = combatlog_strings["Heal (other vs. self/other)"],
    ["CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS"] = combatlog_strings["Periodic Heal (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS"] = combatlog_strings["Periodic Heal (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"] = combatlog_strings["Periodic Heal (self/other vs. other)"],
    ["CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"] = combatlog_strings["Periodic Heal (other vs. self/other)"]
}

-- ===========================================================================
-- 每个具体模式对应的解析函数
-- 从捕获结果中提取 施法者、技能、目标、数值、学派、类型("damage"/"heal")
-- 调用 parser:AddData 传递给核心统计函数
-- ===========================================================================
local combatlog_parser = {
    [SPELLLOGSCHOOLSELFSELF] = function(d, attack, value, school)
        return d.source, attack, d.target, value, school, "damage"
    end,
    [SPELLLOGCRITSCHOOLSELFSELF] = function(d, attack, value, school)
        return d.source, attack, d.target, value, school, "damage"
    end,
    [SPELLLOGSELFSELF] = function(d, attack, value)
        return d.source, attack, d.target, value, d.school, "damage"
    end,
    [SPELLLOGCRITSELFSELF] = function(d, attack, value)
        return d.source, attack, d.target, value, d.school, "damage"
    end,
    [PERIODICAURADAMAGESELFSELF] = function(d, value, school, attack)
        return d.source, attack, d.target, value, school, "damage"
    end,
    [SPELLLOGSCHOOLSELFOTHER] = function(d, attack, target, value, school)
        return d.source, attack, target, value, school, "damage"
    end,
    [SPELLLOGCRITSCHOOLSELFOTHER] = function(d, attack, target, value, school)
        return d.source, attack, target, value, school, "damage"
    end,
    [SPELLLOGSELFOTHER] = function(d, attack, target, value)
        return d.source, attack, target, value, d.school, "damage"
    end,
    [SPELLLOGCRITSELFOTHER] = function(d, attack, target, value)
        return d.source, attack, target, value, d.school, "damage"
    end,
    [PERIODICAURADAMAGESELFOTHER] = function(d, target, value, school, attack)
        return d.source, attack, target, value, school, "damage"
    end,
    [COMBATHITSELFOTHER] = function(d, target, value)
        return d.source, d.attack, target, value, d.school, "damage"
    end,
    [COMBATHITCRITSELFOTHER] = function(d, target, value)
        return d.source, d.attack, target, value, d.school, "damage"
    end,
    [COMBATHITSCHOOLSELFOTHER] = function(d, target, value, school)
        return d.source, d.attack, target, value, school, "damage"
    end,
    [COMBATHITCRITSCHOOLSELFOTHER] = function(d, target, value, school)
        return d.source, d.attack, target, value, school, "damage"
    end,
    [DAMAGESHIELDSELFOTHER] = function(d, value, school, target)
        return d.source, "Reflect ("..school..")", target, value, school, "damage"
    end,
    [SPELLLOGSCHOOLOTHERSELF] = function(d, source, attack, value, school)
        return source, attack, d.target, value, school, "damage"
    end,
    [SPELLLOGCRITSCHOOLOTHERSELF] = function(d, source, attack, value, school)
        return source, attack, d.target, value, school, "damage"
    end,
    [SPELLLOGOTHERSELF] = function(d, source, attack, value)
        return source, attack, d.target, value, d.school, "damage"
    end,
    [SPELLLOGCRITOTHERSELF] = function(d, source, attack, value)
        return source, attack, d.target, value, d.school, "damage"
    end,
    [PERIODICAURADAMAGEOTHERSELF] = function(d, value, school, source, attack)
        return source, attack, d.target, value, school, "damage"
    end,
    [COMBATHITOTHERSELF] = function(d, source, value)
        return source, d.attack, d.target, value, d.school, "damage"
    end,
    [COMBATHITCRITOTHERSELF] = function(d, source, value)
        return source, d.attack, d.target, value, d.school, "damage"
    end,
    [COMBATHITSCHOOLOTHERSELF] = function(d, source, value, school)
        return source, d.attack, d.target, value, school, "damage"
    end,
    [COMBATHITCRITSCHOOLOTHERSELF] = function(d, source, value, school)
        return source, d.attack, d.target, value, school, "damage"
    end,
    [SPELLLOGSCHOOLOTHEROTHER] = function(d, source, attack, target, value, school)
        return source, attack, target, value, school, "damage"
    end,
    [SPELLLOGCRITSCHOOLOTHEROTHER] = function(d, source, attack, target, value, school)
        return source, attack, target, value, school, "damage"
    end,
    [SPELLLOGOTHEROTHER] = function(d, source, attack, target, value)
        return source, attack, target, value, d.school, "damage"
    end,
    [SPELLLOGCRITOTHEROTHER] = function(d, source, attack, target, value, school)
        return source, attack, target, value, school, "damage"
    end,
    [PERIODICAURADAMAGEOTHEROTHER] = function(d, target, value, school, source, attack)
        return source, attack, target, value, school, "damage"
    end,
    [COMBATHITOTHEROTHER] = function(d, source, target, value)
        return source, d.attack, target, value, d.school, "damage"
    end,
    [COMBATHITCRITOTHEROTHER] = function(d, source, target, value)
        return source, d.attack, target, value, d.school, "damage"
    end,
    [COMBATHITSCHOOLOTHEROTHER] = function(d, source, target, value, school)
        return source, d.attack, target, value, school, "damage"
    end,
    [COMBATHITCRITSCHOOLOTHEROTHER] = function(d, source, target, value, school)
        return source, d.attack, target, value, school, "damage"
    end,
    [DAMAGESHIELDOTHERSELF] = function(d, source, value, school)
        return source, "Reflect ("..school..")", d.target, value, school, "damage"
    end,
    [DAMAGESHIELDOTHEROTHER] = function(d, source, value, school, target)
        return source, "Reflect ("..school..")", target, value, school, "damage"
    end,
    [HEALEDCRITOTHERSELF] = function(d, source, spell, value)
        return source, spell, d.target, value, d.school, "heal"
    end,
    [HEALEDOTHERSELF] = function(d, source, spell, value)
        return source, spell, d.target, value, d.school, "heal"
    end,
    [PERIODICAURAHEALOTHERSELF] = function(d, value, source, spell)
        return source, spell, d.target, value, d.school, "heal"
    end,
    [HEALEDCRITSELFSELF] = function(d, spell, value)
        return d.source, spell, d.target, value, d.school, "heal"
    end,
    [HEALEDSELFSELF] = function(d, spell, value)
        return d.source, spell, d.target, value, d.school, "heal"
    end,
    [PERIODICAURAHEALSELFSELF] = function(d, value, spell)
        return d.source, spell, d.target, value, d.school, "heal"
    end,
    [HEALEDCRITSELFOTHER] = function(d, spell, target, value)
        return d.source, spell, target, value, d.school, "heal"
    end,
    [HEALEDSELFOTHER] = function(d, spell, target, value)
        return d.source, spell, target, value, d.school, "heal"
    end,
    [PERIODICAURAHEALSELFOTHER] = function(d, target, value, spell)
        return d.source, spell, target, value, d.school, "heal"
    end,
    [HEALEDCRITOTHEROTHER] = function(d, source, spell, target, value)
        return source, spell, target, value, d.school, "heal"
    end,
    [HEALEDOTHEROTHER] = function(d, source, spell, target, value)
        return source, spell, target, value, d.school, "heal"
    end,
    [PERIODICAURAHEALOTHEROTHER] = function(d, target, value, source, spell)
        return source, spell, target, value, d.school, "heal"
    end,
}

-- ===========================================================================
-- 注册所有战斗日志相关事件
-- ===========================================================================
for event in pairs(combatlog_events) do
    parser:RegisterEvent(event)
end

-- 预编译所有模式以加速匹配
for pattern in pairs(combatlog_parser) do
    sanitize(pattern)
end

-- 默认值表（用于解析失败时填充缺失信息）
local defaults = { }

-- 吸收和抵抗后缀模式（需要从消息中移除，因为它们会影响伤害数值的捕获）
local absorb = sanitize(ABSORB_TRAILER)
local resist = sanitize(RESIST_TRAILER)

-- 临时变量
local _, num, pattern, result, a1, a2, a3, a4, a5
local empty, physical, autohit = "", "physical", "Auto Hit"
local player = UnitName("player")

-- ===========================================================================
-- 事件处理函数
-- 每当聊天消息到达时，尝试匹配当前事件对应的所有模式，解析出伤害/治疗数据
-- ===========================================================================
parser:SetScript("OnEvent", function()
    if not arg1 then return end  -- 消息内容（arg1）必须存在

    -- 移除吸收和抵抗后缀，避免干扰伤害数值的捕获
    arg1 = string.gsub(arg1, absorb, empty)
    arg1 = string.gsub(arg1, resist, empty)

    -- 设置默认值：施法者为玩家自己，目标为玩家自己，学派为物理，攻击类型为自动攻击
    defaults.source = player
    defaults.target = player
    defaults.school = physical
    defaults.attack = autohit
    defaults.spell  = UNKNOWN
    defaults.value  = 0

    -- 遍历当前事件对应的所有可能模式
    for _, pattern in pairs(combatlog_events[event]) do
        -- 使用自定义的 cfind 进行匹配，并自动重排捕获顺序
        result, num, a1, a2, a3, a4, a5 = cfind(arg1, pattern)
        if result then
            -- 匹配成功，调用对应解析函数并传递给核心数据更新函数
            return parser:AddData(combatlog_parser[pattern](defaults, a1, a2, a3, a4, a5))
        end
    end
end)