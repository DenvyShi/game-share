--[[
	Author: Dennis Werner Garske (DWG) / brian / Mewtiny
	License: MIT License
]]
local _G = _G or getfenv(0)
local CleveRoids = _G.CleveRoids or {} -- redundant since we're loading first but peace of mind if another file is added top of chain


function CleveRoids.Seq(_, i)
    return (i or 0) + 1
end

-- Trims any leading or trailing white space characters from the given string
-- str: The string to trim
-- returns: The trimmed string
function CleveRoids.Trim(str)
    if not str then
        return nil
    end
    return string.gsub(str,"^%s*(.-)%s*$", "%1")
end

do
  local _G = _G or getfenv(0)
  local CleveRoids = _G.CleveRoids or {}
  _G.CleveRoids = CleveRoids

  CleveRoids.__mo = CleveRoids.__mo or { sources = {}, current = nil }

  local PRIORITY = {
    pfui    = 3,   -- unitframe hovers should win
    blizz   = 3,   -- same level as pfui
    tooltip = 1,   -- lowest; don’t stomp frames
  }

  local function getBest()
    local bestSource, bestUnit, bestP = nil, nil, -1
    for source, unit in CleveRoids.__mo.sources do
      if unit and unit ~= "" then
        local p = PRIORITY[source] or 0
        if p > bestP then
          bestP, bestSource, bestUnit = p, source, unit
        end
      end
    end
    return bestSource, bestUnit
  end

  local function apply(unit)
    -- SuperWoW path if available; otherwise internal fallback
    if CleveRoids.hasSuperwow and _G.SetMouseoverUnit then
      _G.SetMouseoverUnit(unit) -- nil clears
    else
      CleveRoids.mouseoverUnit = unit
    end
    if CleveRoids.QueueActionUpdate then CleveRoids.QueueActionUpdate() end
  end

  function CleveRoids.SetMouseoverFrom(source, unit)
    -- set/refresh a source’s unit
    if not source then return end
    CleveRoids.__mo.sources[source] = unit
    local _, bestUnit = getBest()
    if bestUnit ~= CleveRoids.__mo.current then
      CleveRoids.__mo.current = bestUnit
      apply(bestUnit)
    end
  end

  function CleveRoids.ClearMouseoverFrom(source, unitIfMatch)
    if not source then return end
    if unitIfMatch and CleveRoids.__mo.sources[source] ~= unitIfMatch then
      return -- don’t clear if it was replaced meanwhile
    end
    CleveRoids.__mo.sources[source] = nil
    local _, bestUnit = getBest()
    if bestUnit ~= CleveRoids.__mo.current then
      CleveRoids.__mo.current = bestUnit
      apply(bestUnit)
    end
  end
end

-- TODO: Get rid of one Split function.  CleveRoids.splitString is ~10% slower
function CleveRoids.Split(s, p, trim)
    local r, o = {}, 1

    if not p or p == "" then
        if trim then
            s = CleveRoids.Trim(s)
        end
        for i = 1, string.len(s) do
            table.insert(r, string.sub(s, i, 1))
        end
        return r
    end

    repeat
        local b, e = string.find(s, p, o)
        if b == nil then
            local sub = string.sub(s, o)
            table.insert(r, trim and CleveRoids.Trim(sub) or sub)
            return r
        end
        if b > 1 then
            local sub = string.sub(s, o, b - 1)
            table.insert(r, trim and CleveRoids.Trim(sub) or sub)
        else
            table.insert(r, "")
        end
        o = e + 1
    until false
end

-- Splits the given string into a list of sub-strings
-- str: The string to split
-- seperatorPattern: The seperator between sub-string. May contain patterns
-- returns: A list of sub-strings
function CleveRoids.splitString(str, seperatorPattern)
    local tbl = {}
    if not str then
        return tbl
    end
    local pattern = "(.-)" .. seperatorPattern
    local lastEnd = 1
    local s, e, cap = string.find(str, pattern, 1)

    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(tbl,cap)
        end
        lastEnd = e + 1
        s, e, cap = string.find(str, pattern, lastEnd)
    end

    if lastEnd <= string.len(str) then
        cap = string.sub(str, lastEnd)
        table.insert(tbl, cap)
    end

    return tbl
end

function CleveRoids.splitStringIgnoringQuotes(str, separator)
    local result = {}
    local temp = ""
    local insideQuotes = false
    local separators = {}

    if type(separator) == "table" then
        for _, s in separator do
            separators[s] = s
        end
    else
        separators[separator or ";"] = separator or ";"
    end

    for i = 1, string.len(str) do
        local char = string.sub(str, i, i)

        if char == "\"" then
            insideQuotes = not insideQuotes
            temp = temp .. char
        elseif char == separators[char] and not insideQuotes then
            temp = CleveRoids.Trim(temp)
            if temp ~= "" then table.insert(result, temp) end
            temp = ""
        else
            temp = temp .. char
        end
    end

    -- Add the last segment if it exists
    if temp ~= "" then
        temp = CleveRoids.Trim(temp)
        table.insert(result, temp)
    end

    -- if nothing was found, return the empty string
    return (next(result) and result or {""})
end

-- Prints all the given arguments into WoW's default chat frame
function CleveRoids.Print(...)
    local c = "|cFF4477FFCleveR|r|cFFFFFFFFoid : |r" -- 修改 by Sunelegy、武藤纯子酱 2025.8.19
    local out = ""

    for i=1, arg.n, 1 do
        out = out..tostring(arg[i]).."  "
    end
    if WowLuaFrameOutput then
        WowLuaFrameOutput:AddMessage(out)
    else
        if not DEFAULT_CHAT_FRAME:IsVisible() then
            FCF_SelectDockFrame(DEFAULT_CHAT_FRAME)
        end
        DEFAULT_CHAT_FRAME:AddMessage(c..out)
    end
end

function CleveRoids.PrintI(msg, depth)
    depth = depth or 0
    msg = string.rep("    ", depth) .. tostring(msg)
    CleveRoids.Print(msg)
end

function CleveRoids.PrintT(t, depth)
    depth = depth or 0
    local cs = "|cffc8c864"
    local ce = "|r"

    if t == nil or type(t) ~= "table" then
        CleveRoids.PrintI(t, depth)
    else
        for k, v in pairs(t) do
            if type(v) == "table" then
                CleveRoids.PrintI(cs..tostring(k)..":"..ce.." <TABLE>", depth)
                CleveRoids.PrintT(v, depth + 1)
            else
                CleveRoids.PrintI(cs..tostring(k)..ce..": "..tostring(v), depth)
            end
        end
    end
end

CleveRoids.kmods = {
    ctrl  = IsControlKeyDown,
    alt   = IsAltKeyDown,
    shift = IsShiftKeyDown,
    mod   = function() return (IsControlKeyDown() or IsAltKeyDown() or IsShiftKeyDown()) end,
    nomod = function() return (not IsControlKeyDown() and not IsAltKeyDown() and not IsShiftKeyDown()) end,
}

CleveRoids.operators = {
    ["<"] = "lt",
    ["lt"] = "<",
    [">"] = "gt",
    ["gt"] = ">",
    ["="] = "eq",
    ["eq"] = "=",
    ["<="] = "lte",
    ["lte"] = "<=",
    [">="] = "gte",
    ["gte"] = ">=",
    ["~="] = "ne",
    ["ne"] = "~=",
}

CleveRoids.comparators = {
    lt  = function(a, b) return (a <  b) end,
    gt  = function(a, b) return (a >  b) end,
    eq  = function(a, b) return (a == b) end,
    lte = function(a, b) return (a <= b) end,
    gte = function(a, b) return (a >= b) end,
    ne  = function(a, b) return (a ~= b) end,
}
CleveRoids.comparators["<"]  = CleveRoids.comparators.lt
CleveRoids.comparators[">"]  = CleveRoids.comparators.gt
CleveRoids.comparators["="]  = CleveRoids.comparators.eq
CleveRoids.comparators["<="] = CleveRoids.comparators.lte
CleveRoids.comparators[">="] = CleveRoids.comparators.gte
CleveRoids.comparators["~="] = CleveRoids.comparators.ne

-- 新增：预估单位死亡时间 by 武藤纯子酱 2025.8.8
-- 获取单位唯一标识
function CleveRoids.GetUnitGUID(unit)
    if hasSuperwow then
        local _, guid = UnitExists(unit)
        return guid
    else
        return unit  -- 非Superwow环境返回原始单位ID
    end
end

-- 创建主帧用于定时更新
CleveRoids.TimerFrame = CreateFrame("Frame")
local DeathTimers = {} -- 全局表存储存活目标的计时数据

-- 定义定时器参数
local interval = 0.3
local elapsedTime = 0

-- 预估单位死亡时间
function CleveRoids.CalculateTimeRemaining(unitID)
    local data = DeathTimers[unitID]
    if not data or not data.historyCount or data.historyCount < 2 then return 1000 end
    
    -- 1. 加权平均法计算剩余时间
    local totalWeight = 0
    local weightedDamage = 0
    local maxHistory = 50
    
    for i = math.max(1, data.historyCount - maxHistory + 1), data.historyCount do
        if data.history[i] then
            local weight = 1 + (i - (data.historyCount - maxHistory)) * 0.8
            weightedDamage = weightedDamage + (data.history[i].damage or 0) * weight
            totalWeight = totalWeight + weight
        end
    end
    
    local timeRemainingWeighted = data.lastTimeRemaining or 1000
    if totalWeight > 0 then
        local avgDPS = (weightedDamage / totalWeight) / interval
        if avgDPS > 0 then
            timeRemainingWeighted = math.max(0, UnitHealth(unitID) / avgDPS)
        end
    end
    
    -- 2. 近5秒平均伤害法计算剩余时间 - 使用实际时间跨度
    local currentTime = GetTime()
    local damage5s = 0
    local earliestTime = currentTime  -- 记录最早的有效伤害时间
    
    -- 遍历历史记录，统计最近5秒内的伤害总和
    for i = data.historyCount, 1, -1 do
        local record = data.history[i]
        if not record or not record.time then break end
        
        local timeDiff = currentTime - record.time
        if timeDiff <= 5 then
            damage5s = damage5s + (record.damage or 0)
            earliestTime = record.time  -- 更新最早的时间戳
        else
            break  -- 一旦超出5秒范围就停止遍历
        end
    end
    
    local timeRemaining5s = 1000
    local timeSpan = math.max(0.1, currentTime - earliestTime) -- 实际时间跨长，最小0.1秒
    
    --至少需要3秒数据才信任近5秒统计，否则只用加权平均
    if timeSpan >= 3 then
        local dps5s = damage5s / timeSpan  -- 使用实际时间跨长计算DPS
        timeRemaining5s = math.max(0, UnitHealth(unitID) / dps5s)
        
        -- Debug: 查看实际统计时间跨长
        -- CleveRoids.Print("Time Span: ", string.format("%.1f秒", timeSpan))
    end
    
    -- 更新最后使用的剩余时间
    data.lastTimeRemaining = timeRemainingWeighted

    -- 返回两种算法的最小值
    return (timeSpan >= 3) and math.min(timeRemainingWeighted, timeRemaining5s) or timeRemainingWeighted
end

-- 主体函数
CleveRoids.TimerFrame:SetScript("OnUpdate", function()
    if (GetTime() - elapsedTime) < interval then
        return
    end
    elapsedTime = GetTime()
    local unitsToCheck = {}
    
	-- 遍历所有跟踪的单位
	if Cursive and Cursive.core then --修复 by 黎明、武藤纯子酱 2025.8.19
		for guid, _ in pairs(Cursive.core.guids) do
			if UnitAffectingCombat(guid) then
				unitsToCheck[guid] = true
			end
		end
	else
		-- 收集有效单位GUID/原始ID
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local unit = "raid"..i.."target"
				if UnitExists(unit) then
					unitsToCheck[CleveRoids.GetUnitGUID(unit)] = true
				end
			end
		elseif UnitInParty("player") then
			for i = 1, GetNumPartyMembers() do
				local unit = "party"..i.."target"
				if UnitExists(unit) then
					unitsToCheck[CleveRoids.GetUnitGUID(unit)] = true
				end
			end
		end
		
		-- 添加玩家当前目标
		local targetGUID = CleveRoids.GetUnitGUID("target")
		if UnitExists("target") then
			unitsToCheck[targetGUID] = true
		end
	end

    -- 清理无效单位
    for unitID in pairs(DeathTimers) do
        if not unitsToCheck[unitID] or not UnitAffectingCombat(unitID) then
            DeathTimers[unitID] = nil
        end
    end

    -- 更新有效单位数据
    for unitID in pairs(unitsToCheck) do
        if (hasSuperwow or UnitExists(unitID)) and not UnitIsDeadOrGhost(unitID) then
            local currentHealth = UnitHealth(unitID)
            local currentTime = GetTime()
            
            if not DeathTimers[unitID] then
                DeathTimers[unitID] = {
                    history = {},
                    historyCount = 0,
                    lastHealth = currentHealth,
                    lastTime = currentTime
                }
            end
            
            local data = DeathTimers[unitID]
            local damage = (data.lastHealth or 0) - currentHealth
            
            data.historyCount = (data.historyCount or 0) + 1
            data.history[data.historyCount] = { damage = damage, time = currentTime }
            
            if data.historyCount > 20 then
                for i = 1, 20 do
                    data.history[i] = data.history[i+1]
                end
                data.historyCount = 20
            end
            
            data.lastHealth = currentHealth
            data.lastTime = currentTime
        end
    end
end)

-- 接口函数
function CleveRoids.GetTargetDeathTime(unit)
	if not unit then unit = "target" end

    if hasSuperwow then
        local targetGUID = CleveRoids.GetUnitGUID(unit)
        if not targetGUID or not UnitExists(unit) then return 1000 end
        if UnitIsDeadOrGhost(unit) then return 0 end
        local data = DeathTimers[targetGUID]
        if data then
            return math.floor(CleveRoids.CalculateTimeRemaining(targetGUID) + 0.5)
        end
    else
        if not UnitExists(unit) then return 1000 end
        if UnitIsDeadOrGhost(unit) then return 0 end
        for unitID in pairs(DeathTimers) do
            if UnitIsUnit(unit, unitID) then
                return math.floor(CleveRoids.CalculateTimeRemaining(unitID) + 0.5)
            end
        end
    end
    return 1000
end

-- 增强事件响应
CleveRoids.TimerFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
CleveRoids.TimerFrame:SetScript("OnEvent", function()
    elapsedTime = interval
    DeathTimers = {}
end)

-- 示例调用方式:
-- /script print(CleveRoids.GetTargetDeathTime("target"))
--新增对于Unknown unit name报错的屏蔽 by 武藤纯子酱 2025.8.17
CleveRoids.OrigErrorHandler = geterrorhandler()
CleveRoids.SeterrorHandler = seterrorhandler(function(err) 
    if err and not strfind(err, "Unknown unit name") then
        CleveRoids.OrigErrorHandler(err)
    end
end)

_G["CleveRoids"] = CleveRoids
