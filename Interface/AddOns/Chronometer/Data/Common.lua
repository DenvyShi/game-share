--<< ====================================================================== >>--
-- 设置计时器                                                               --
--<< ====================================================================== >>--
-- 引入Ace库中的Babble-Spell-2.2模块，用于处理法术名称相关操作
local BS = AceLibrary("Babble-Spell-2.2")

-- 定义Chronometer对象的CommonSetup方法
function Chronometer:CommonSetup()
    -- 获取玩家职业（第二个返回值为职业英文缩写）
    local _, eclass = UnitClass("player")
    
    -- 若玩家职业是圣骑士、战士、盗贼或萨满祭司
    if eclass == "PALADIN" or eclass == "WARRIOR" or eclass == "ROGUE" or eclass == "SHAMAN" then
    
        -- 添加十字军附魔触发效果的计时器
        -- 法术名称：神圣力量（通过BS模块获取），持续15秒
        -- 参数说明：事件类型（self.EVENT），法术名，持续时间，其他参数（0,1,1），配置项（颜色黄，a=1，分类COMMON）
        -- 对应物品：http://classicdb.ch/?item=16252
        self:AddTimer(self.EVENT, BS["Holy Strength"],         	15, 0,1,1, { cr="YELLOW", a=1 , cl="COMMON" })
        
    end
    -- 添加祖尔格拉布施法者饰品的不稳定力量效果计时器
    -- 持续20秒，配置项（a=1，颜色青，分类COMMON）
    -- 对应物品：http://classicdb.ch/?item=19950
    self:AddTimer(self.EVENT, BS["Unstable Power"],          	20, 0, 1, 1, { a=1, cr="CYAN", cl="COMMON" })
    -- 添加短暂力量效果计时器，持续15秒，配置项同上
    self:AddTimer(self.EVENT, BS["Ephemeral Power"],          	15, 0, 1, 1, { a=1, cr="CYAN", cl="COMMON" })
    -- 添加思维加速效果计时器，持续20秒
    -- 配置项包含显示名称替换（xn参数，显示为Critical Mass）
    self:AddTimer(self.EVENT, "Mind Quickening",          		20, 0, 1, 1, { a=1, cr="CYAN", cl="COMMON",xn=BS["Critical Mass"]})
end

-- 将CommonSetup方法插入到Chronometer的数据设置列表中，用于初始化时执行
table.insert(Chronometer.dataSetup, Chronometer.CommonSetup)

-- 各语言客户端的引导持续时间格式映射
local channelingFormats = {
    ["zhCN"] = "持续(%d+%.?%d*)秒",      -- 简体中文
    ["zhTW"] = "持續(%d+%.?%d*)秒",      -- 繁体中文
    ["enUS"] = "for (%d+%.?%d*) sec",      -- 英文（美国）
    ["enGB"] = "for (%d+%.?%d*) sec",      -- 英文（英国）
    ["deDE"] = "verursacht (%d+%.?%d*) Sek",      -- 德语
    ["esES"] = "durante (%d+%.?%d*) s",     -- 西班牙语
    ["esMX"] = "durante (%d+%.?%d*) s",     -- 西班牙语（墨西哥）
    ["frFR"] = "pendant (%d+%.?%d*) sec",      -- 法语
    ["ruRU"] = "течение (%d+%.?%d*) сек",      -- 俄语
    ["koKR"] = "(%d+%.?%d*)초에",      -- 韩语
}

-- 各语言客户端的DOT持续时间格式映射
local curseFormats = {
    ["zhCN"] = "在(%d+%.?%d*)秒内",      -- 简体中文
    ["zhTW"] = "在(%d+%.?%d*)秒內",      -- 繁体中文
    ["enUS"] = "over (%d+%.?%d*) sec",      -- 英文（美国）
    ["enGB"] = "over (%d+%.?%d*) sec",      -- 英文（英国）
    ["deDE"] = "verursacht (%d+%.?%d*) Sek",      -- 德语
    ["esES"] = "durante (%d+%.?%d*) s",     -- 西班牙语
    ["esMX"] = "durante (%d+%.?%d*) s",     -- 西班牙语（墨西哥）
    ["frFR"] = "en (%d+%.?%d*) sec",      -- 法语
    ["ruRU"] = "за (%d+%.?%d*) сек",      -- 俄语
    ["koKR"] = "(%d+%.?%d*)초에",      -- 韩语
}

-- 各语言客户端的等级格式映射
local rankFormats = {
    ["zhCN"] = "等级 %d",      -- 简体中文
    ["zhTW"] = "等級 %d",      -- 繁体中文
    ["enUS"] = "Rank %d",      -- 英文（美国）
    ["enGB"] = "Rank %d",      -- 英文（英国）
    ["deDE"] = "Rang %d",      -- 德语
    ["esES"] = "Rango %d",     -- 西班牙语
    ["esMX"] = "Rango %d",     -- 西班牙语（墨西哥）
    ["frFR"] = "Rang %d",      -- 法语
    ["ruRU"] = "Ранг %d",      -- 俄语
    ["koKR"] = "단계 %d",      -- 韩语
}

-- 预先创建唯一的 Frame（只执行一次）
local descriptionframe = CreateFrame("GameTooltip", "Chronometer_ReusableTooltip", UIParent, "GameTooltipTemplate")
descriptionframe:SetOwner(UIParent, "ANCHOR_NONE")
descriptionframe:Hide()  -- 初始时隐藏

function Chronometer:GetSpellDescription(spellName, spellRank)
    -- 复用已存在的 Frame
    descriptionframe:ClearLines()
    descriptionframe:SetOwner(UIParent, "ANCHOR_NONE")  -- 重置 Owner 避免残留位置

    -- 安全遍历法术书的正确方式
    local _, _, offset, numSpells = GetSpellTabInfo(GetNumSpellTabs())
    local totalSpells = offset + numSpells  -- 获取实际法术数量
    
    -- 查找法术ID（修正遍历范围）
    local spellID
    for i = 1, totalSpells do
        local name, rank = GetSpellName(i, BOOKTYPE_SPELL)
        if name and name == spellName and (not spellRank or rank == spellRank) then
            spellID = i
            break
        end
    end
    
    if not spellID then
        descriptionframe:Hide()
        return "法术未找到" 
    end

    -- 安全设置法术信息
    descriptionframe:SetSpell(spellID, BOOKTYPE_SPELL)
    
    -- 提取描述文本
    local line = _G["Chronometer_ReusableTooltipTextLeft" .. descriptionframe:NumLines()]
	local description = line:GetText() or ""

    descriptionframe:ClearLines()  -- 清理内容以便下次复用
    descriptionframe:Hide()        -- 立即隐藏

    return Chronometer:ExtractTimeFromDescription(strtrim(description))
end

function Chronometer:ExtractTimeFromDescription(description)
    if not description then return nil end
	local locale = GetLocale()
	local channelingformat = channelingFormats[locale] or "持续(%d+%.?%d*)秒"
	local curseformat = curseFormats[locale] or "在(%d+%.?%d*)秒内"
	
    local timeValue = string.match(description, curseformat) or string.match(description, channelingformat)
    return tonumber(timeValue) or nil
end

function Chronometer:GetSpellMaxRank(spellName)
    local maxRank = 0
    
    -- 获取法术标签信息
    local numTabs = GetNumSpellTabs()
    
    for tab = 1, numTabs do
        local _, _, offset, numSpells = GetSpellTabInfo(tab)
        for index = offset + 1, offset + numSpells do
            local name, rank = GetSpellName(index, BOOKTYPE_SPELL)
            if name and name == spellName then
                if rank and rank ~= "" then
                    local rankNum = tonumber(string.match(rank, "%d+"))
                    if rankNum and rankNum > maxRank then
                        maxRank = rankNum
                    end
                else
                    maxRank = math.max(maxRank, 1)
                end
            end
        end
    end
    
    return maxRank
end

-- 获取等级字符串
function Chronometer:getRank(spellName, rank)
    local locale = GetLocale()
    local format = rankFormats[locale] or "Rank %d"
    return string.format(format, rank)
end
-- 获取带等级的完整技能名称
function Chronometer:getSpellWithRank(spellName, rank)
    return spellName .. "(" .. Chronometer:getRank(spellName, rank) .. ")"
end