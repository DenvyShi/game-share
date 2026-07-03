-- src/ChatPro.lua
local origAddMessage = {}
local whoQueue = {}
local whoTimer = 0
local isWhoing = false
local whoTimeout = 0
local whoTimestamp = 0
local SCCN_CHATPATTERN1 = "(.-)%s-: (.- .-) ([^<%-]*) "
local SCCN_WHO_RESULTS_PATTERN = "共计%d+个玩家"
ChatPro_ErrorList = {}

local classColors = {
    ["HUNTER"] = "|cffabd473",
    ["WARLOCK"] = "|cff9482c9",
    ["PRIEST"] = "|cffffffff",
    ["PALADIN"] = "|cfff58cba",
    ["MAGE"] = "|cff69ccf0",
    ["ROGUE"] = "|cfffff569",
    ["DRUID"] = "|cffff7d0a",
    ["SHAMAN"] = "|cff0070de",
    ["WARRIOR"] = "|cffc79c6e",
}

local localToEngClass = {
    ["术士"] = "WARLOCK", ["猎人"] = "HUNTER", ["牧师"] = "PRIEST",
    ["圣骑士"] = "PALADIN", ["法师"] = "MAGE", ["盗贼"] = "ROGUE",
    ["德鲁伊"] = "DRUID", ["萨满祭司"] = "SHAMAN", ["战士"] = "WARRIOR",
    ["WARLOCK"] = "WARLOCK", ["HUNTER"] = "HUNTER", ["PRIEST"] = "PRIEST",
    ["PALADIN"] = "PALADIN", ["MAGE"] = "MAGE", ["ROGUE"] = "ROGUE",
    ["DRUID"] = "DRUID", ["SHAMAN"] = "SHAMAN", ["WARRIOR"] = "WARRIOR",
}

local function GetLevelColor(level)
    local diff = level - UnitLevel("player")
    local greenRange = GetQuestGreenRange()
    if diff >= 5 then return "|cffff0000"
    elseif diff >= 3 then return "|cffff7f3f"
    elseif diff >= -2 then return "|cffffff00"
    elseif -diff <= greenRange then return "|cff3fbf3f"
    else return "|cff7f7f7f" end
end

local function CachePlayer(name, class, level)
    if not name or not class then return end
    local lowerName = string.lower(name)
    class = localToEngClass[class] or class
    
    if not ChatProDB.players[lowerName] then
        ChatProDB.players[lowerName] = {}
    end
    ChatProDB.players[lowerName].class = string.upper(class)
    if level and tonumber(level) then
        ChatProDB.players[lowerName].level = tonumber(level)
    end
    ChatProDB.players[lowerName].time = time()
end

local function CleanCache()
    local now = time()
    local purgeTime = 3600 * 24 * 28 -- 4 weeks
    for name, info in pairs(ChatProDB.players) do
        if now - info.time > purgeTime then
            ChatProDB.players[name] = nil
        end
    end
end

local function UnlinkMessage(msg)
    local text = string.gsub(msg, "|c%x%x%x%x%x%x%x%x", "")
    text = string.gsub(text, "|r", "")
    text = string.gsub(text, "|H.-|h(.-)|h", "%1")
    return text
end

local function HighlightText(txt, speaker)
    return string.gsub(txt, "([%w\128-\255]+)", function(word)
        local lowerWord = string.lower(word)
        local info = ChatProDB.players[lowerWord]
        if ChatProDB.inChatHighlight and info then
            local class = info.class
            if class and classColors[class] then
                return classColors[class] .. word .. "|r"
            end
        end
        return word
    end)
end

local function ProcessInChatHighlight(msg, speaker)
    if not ChatProDB.inChatHighlight then return msg end
    local result = ""
    local pos = 1
    while pos <= string.len(msg) do
        local linkStart, linkEnd = string.find(msg, "|H.-|h.-|h", pos)
        local colorStart, colorEnd = string.find(msg, "|c%x%x%x%x%x%x%x%x.-|r", pos)
        
        local startIdx, endIdx = nil, nil
        if linkStart and colorStart then
            if linkStart < colorStart then
                startIdx, endIdx = linkStart, linkEnd
            else
                startIdx, endIdx = colorStart, colorEnd
            end
        elseif linkStart then
            startIdx, endIdx = linkStart, linkEnd
        elseif colorStart then
            startIdx, endIdx = colorStart, colorEnd
        end
        
        if not startIdx then
            result = result .. HighlightText(string.sub(msg, pos), speaker)
            break
        end
        
        if startIdx > pos then
            result = result .. HighlightText(string.sub(msg, pos, startIdx - 1), speaker)
        end
        result = result .. string.sub(msg, startIdx, endIdx)
        pos = endIdx + 1
    end
    return result
end

local function QueueWho(name)
    if not ChatProDB.autoWho then return end
    for _, v in ipairs(whoQueue) do
        if v == name then return end
    end
    table.insert(whoQueue, name)
end

local function UpdateEditBoxPosition()
    if getglobal("Confab_OnLoad") then return end
    if ChatProDB.topEditbox then
        ChatFrameEditBox:ClearAllPoints()
        ChatFrameEditBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -5, 0)
        ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 0)
    else
        ChatFrameEditBox:ClearAllPoints()
        ChatFrameEditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -5, 0)
        ChatFrameEditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 5, 0)
    end
end

local function UpdateEditBoxKeys()
    if ChatProDB.editboxKeys then
        ChatFrameEditBox:SetAltArrowKeyMode(false)
        ChatFrameEditBox:SetHistoryLines(250)
    else
        ChatFrameEditBox:SetAltArrowKeyMode(true)
        ChatFrameEditBox:SetHistoryLines(32)
    end
end

local function UpdateStickyChannels()
    if ChatProDB.stickyChannels then
        ChatTypeInfo["SAY"].sticky = 1
        ChatTypeInfo["PARTY"].sticky = 1
        ChatTypeInfo["GUILD"].sticky = 1
        ChatTypeInfo["WHISPER"].sticky = 1
        ChatTypeInfo["RAID"].sticky = 1
        ChatTypeInfo["OFFICER"].sticky = 1
        ChatTypeInfo["CHANNEL"].sticky = 1
    else
        ChatTypeInfo["PARTY"].sticky = 0
        ChatTypeInfo["GUILD"].sticky = 0
        ChatTypeInfo["WHISPER"].sticky = 0
        ChatTypeInfo["RAID"].sticky = 0
        ChatTypeInfo["OFFICER"].sticky = 0
        ChatTypeInfo["CHANNEL"].sticky = 0
    end
end

local function UpdateNoFade()
    for i=1, NUM_CHAT_WINDOWS do
        local frame = getglobal("ChatFrame"..i)
        if frame then
            if ChatProDB.noFade then
                frame:SetFading(false)
            else
                frame:SetFading(true)
            end
        end
    end
end

local function UpdateHideButtons()
    for i=1, NUM_CHAT_WINDOWS do
        local chatFrame = getglobal("ChatFrame"..i)
        local up = getglobal("ChatFrame"..i.."UpButton")
        local down = getglobal("ChatFrame"..i.."DownButton")
        local bottom = getglobal("ChatFrame"..i.."BottomButton")
        if ChatProDB.hideButtons then
            if up then up:SetAlpha(0); up:EnableMouse(false) end
            if down then down:SetAlpha(0); down:EnableMouse(false) end
            if bottom and chatFrame then
                bottom:ClearAllPoints()
                bottom:SetPoint("RIGHT", chatFrame, "RIGHT", 0, 0)
                bottom:SetPoint("LEFT", chatFrame, "RIGHT", -25, 0)
                bottom:SetPoint("TOP", chatFrame, "BOTTOM", 0, 20)
                bottom:SetPoint("BOTTOM", chatFrame, "BOTTOM", 0, 0)
                bottom:SetAlpha(0)
                bottom:EnableMouse(false)
            end
        else
            if up then up:SetAlpha(1); up:EnableMouse(true) end
            if down then down:SetAlpha(1); down:EnableMouse(true) end
            if bottom then bottom:SetAlpha(1); bottom:EnableMouse(true) end
        end
    end
    if ChatProDB.hideButtons then
        ChatFrameMenuButton:SetAlpha(0); ChatFrameMenuButton:EnableMouse(false)
    else
        ChatFrameMenuButton:SetAlpha(1); ChatFrameMenuButton:EnableMouse(true)
    end
end

local orig_CHAT_WHISPER_GET
local orig_CHAT_WHISPER_INFORM_GET

local function UpdateWhisperPrefix()
    if not orig_CHAT_WHISPER_GET then
        orig_CHAT_WHISPER_GET = CHAT_WHISPER_GET
        orig_CHAT_WHISPER_INFORM_GET = CHAT_WHISPER_INFORM_GET
    end
    if ChatProDB.shortWhisper then
        CHAT_WHISPER_GET = "%s说: "
        CHAT_WHISPER_INFORM_GET = "密%s: "
    else
        CHAT_WHISPER_GET = orig_CHAT_WHISPER_GET
        CHAT_WHISPER_INFORM_GET = orig_CHAT_WHISPER_INFORM_GET
    end
end

function ChatPro_UpdateSettings()
    UpdateEditBoxPosition()
    UpdateEditBoxKeys()
    UpdateStickyChannels()
    UpdateNoFade()
    UpdateHideButtons()
    UpdateWhisperPrefix()
end

local function ChatPro_AddMessage(frame, text, r, g, b, id)
    if not text then return origAddMessage[frame](frame, text, r, g, b, id) end
    
    local speaker = string.match(text, "|Hplayer:(.-)|h")
    
    if ChatProDB.shortChannel then
        text = string.gsub(text, "%[Guild%]", "[会]")
        text = string.gsub(text, "%[公会%]", "[会]")
        text = string.gsub(text, "%[Party%]", "[队]")
        text = string.gsub(text, "%[小队%]", "[队]")
        text = string.gsub(text, "%[Raid%]", "[团]")
        text = string.gsub(text, "%[团队%]", "[团]")
        text = string.gsub(text, "%[Officer%]", "[官]")
        text = string.gsub(text, "%[官员%]", "[官]")
        
        if ChatProDB.channelReplacements then
            for i=1, 9 do
                local rep = ChatProDB.channelReplacements[i]
                if rep and rep.from and rep.to and rep.from ~= "" then
                    -- Pattern matches "FromText] " and replaces with "ToText]" (removing the trailing space or keeping it if needed)
                    text = string.gsub(text, rep.from .. "%]%s", rep.to .. "] ")
                    text = string.gsub(text, rep.from .. "%]", rep.to .. "]")
                end
            end
        end
    end
    
        if ChatProDB.colorNicks or ChatProDB.showLevel then
        text = string.gsub(text, "|Hplayer:(.-)|h%[(.-)%]|h", function(name, displayName)
            local lowerName = string.lower(name)
            local info = ChatProDB.players[lowerName]
            local prefix = ""
            local color = ""
            if info then
                if ChatProDB.showLevel and info.level then
                    prefix = GetLevelColor(info.level) .. "["..info.level.."]|r"
                end
                if ChatProDB.colorNicks and info.class and classColors[info.class] then
                    color = classColors[info.class]
                end
            end
            
            if color == "" then
                return "|Hplayer:"..name.."|h" .. prefix .. "["..displayName.."]|h"
            else
                return "|Hplayer:"..name.."|h" .. prefix .. color .. "["..displayName.."]|r|h"
            end
        end)
    end
    
    if ChatProDB.hyperlink then
        text = string.gsub(text, "(https?://[%w_/%.%?%%=~&-'%-]+)", "|cffaaaaff|Hurl:%1|h[%1]|h|r")
        text = string.gsub(text, "([^%a])(www%.[%w_/%.%?%%=~&-'%-]+)", "%1|cffaaaaff|Hurl:%2|h[%2]|h|r")
    end
    
    text = ProcessInChatHighlight(text, speaker)
    
    if ChatProDB.timeStamp then
        local unlinked = string.gsub(UnlinkMessage(text), ":", "：") 
        unlinked = string.gsub(unlinked, "|", "｜")
        unlinked = string.sub(unlinked, 1, 200)
        text = "|cff888888|Hurl:"..unlinked.."|h["..date("%H:%M").."]|h|r " .. text
    end
    
    return origAddMessage[frame](frame, text, r, g, b, id)
end

function ChatPro_InitErrorList()
    local errorsToFilter = {
        "ERR_ABILITY_COOLDOWN", "ERR_ATTACK_CHARMED", "ERR_ATTACK_CONFUSED", "ERR_ATTACK_DEAD",
        "ERR_ATTACK_FLEEING", "ERR_ATTACK_PACIFIED", "ERR_ATTACK_STUNNED", "ERR_INVALID_ATTACK_TARGET",
        "ERR_AUTOFOLLOW_TOO_FAR", "ERR_BADATTACKFACING", "ERR_BADATTACKPOS", "ERR_USE_TOO_FAR",
        "ERR_NOEMOTEWHILERUNNING", "ERR_NOT_IN_COMBAT", "ERR_NOT_WHILE_SHAPESHIFTED", "SPELL_FAILED_NOT_BEHIND",
        "ERR_CANTATTACK_NOTSTANDING", "ERR_NO_ITEMS_WHILE_SHAPESHIFTED", "ERR_CANT_INTERACT_SHAPESHIFTED",
        "ERR_GENERIC_NO_TARGET", "ERR_INV_FULL", "ERR_LOOT_BAD_FACING", "ERR_LOOT_DIDNT_KILL", "ERR_LOOT_GONE",
        "ERR_LOOT_LOCKED", "ERR_LOOT_NOTSTANDING", "ERR_LOOT_NO_UI", "ERR_LOOT_STUNNED", "ERR_LOOT_TOO_FAR",
        "ERR_LOOT_WHILE_INVULNERABLE", "ERR_MAIL_DATABASE_ERROR", "ERR_NO_ATTACK_TARGET", "ERR_OBJECT_IS_BUSY",
        "ERR_NOT_ENOUGH_MONEY", "ERR_OUT_OF_ENERGY", "ERR_OUT_OF_FOCUS", "ERR_OUT_OF_HEALTH", "ERR_OUT_OF_MANA",
        "ERR_OUT_OF_RAGE", "ERR_OUT_OF_RANGE", "ERR_PET_SPELL_DEAD", "ERR_SPELL_COOLDOWN", "ERR_SPELL_OUT_OF_RANGE",
        "PETTAME_DEAD", "PETTAME_NOTDEAD", "ERR_PET_SPELL_OUT_OF_RANGE", "SPELL_FAILED_BAD_TARGETS",
        "SPELL_FAILED_CASTER_AURASTATE", "ERR_ITEM_COOLDOWN", "SPELL_FAILED_CASTER_DEAD", "SPELL_FAILED_INTERRUPTED",
        "SPELL_FAILED_INTERRUPTED_COMBAT", "SPELL_FAILED_MOVING", "SPELL_FAILED_NO_COMBO_POINTS",
        "SPELL_FAILED_NOT_MOUNTED", "SPELL_FAILED_NOT_STANDING", "SPELL_FAILED_NOT_ON_TAXI",
        "SPELL_FAILED_ONLY_STEALTHED", "SPELL_FAILED_OUT_OF_RANGE", "SPELL_FAILED_SPELL_IN_PROGRESS",
        "SPELL_FAILED_STUNNED", "SPELL_FAILED_TARGET_AURASTATE", "SPELL_FAILED_NO_ENDURANCE", "ERR_POTION_COOLDOWN",
        "SPELL_FAILED_TARGETS_DEAD", "SPELL_FAILED_AFFECTING_COMBAT", "SPELL_FAILED_TARGET_FRIENDLY",
        "SPELL_FAILED_TOO_CLOSE", "SPELL_FAILED_UNIT_NOT_INFRONT"
    }
    for _, name in ipairs(errorsToFilter) do
        local val = getglobal(name)
        if val then ChatPro_ErrorList[val] = true end
    end
    -- Add localized fallbacks
    ChatPro_ErrorList["技能还没有准备好。"] = true
    ChatPro_ErrorList["能量值不足"] = true
    ChatPro_ErrorList["法力值不足"] = true
    ChatPro_ErrorList["怒气值不足"] = true
    ChatPro_ErrorList["超出射程"] = true
    ChatPro_ErrorList["距离太远"] = true
    ChatPro_ErrorList["你面朝错误的方向！"] = true
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("FRIENDLIST_UPDATE")
eventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
eventFrame:RegisterEvent("RAID_ROSTER_UPDATE")
eventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
eventFrame:RegisterEvent("WHO_LIST_UPDATE")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
eventFrame:RegisterEvent("CHAT_MSG_WHISPER")
eventFrame:RegisterEvent("CHAT_MSG_WHISPER_INFORM")

eventFrame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "ChatPro" then
        if not ChatProDB then
            ChatProDB = {
                colorNicks = true, showLevel = true, autoWho = true,
                inChatHighlight = true, shortChannel = true, mouseScroll = true,
                timeStamp = true, hyperlink = true, topEditbox = false,
                editboxKeys = true, stickyChannels = true, hideErrors = true,
                noFade = true, hideButtons = true, shortWhisper = true, players = {},
                channelReplacements = {
                    {from="1. 综合", to="1"},
                    {from="2. 交易", to="2"},
                    {from="3. 本地防务", to="3"},
                    {from="4. 寻找组队", to="4"},
                    {from="1. World", to="1.W"},
                    {from="China", to="CN"},
                    {from="", to=""},
                    {from="", to=""},
                    {from="", to=""}
                }
            }
        end
        if not ChatProDB.players then ChatProDB.players = {} end
        if not ChatProDB.channelReplacements then ChatProDB.channelReplacements = {} end
        
        CleanCache()
        ChatPro_InitErrorList()
        
        for i=1, NUM_CHAT_WINDOWS do
            local f = getglobal("ChatFrame"..i)
            if f then
                origAddMessage[f] = f.AddMessage
                f.AddMessage = ChatPro_AddMessage
                f:EnableMouseWheel(true)
                f:SetScript("OnMouseWheel", function()
                    if not ChatProDB.mouseScroll then return end
                    if IsShiftKeyDown() then
                        if arg1 > 0 then this:ScrollUp(); this:ScrollUp(); this:ScrollUp()
                        else this:ScrollDown(); this:ScrollDown(); this:ScrollDown() end
                    elseif IsControlKeyDown() then
                        if arg1 > 0 then this:ScrollToTop()
                        else this:ScrollToBottom() end
                    else
                        if arg1 > 0 then this:ScrollUp()
                        else this:ScrollDown() end
                    end
                end)
            end
        end
        
        ChatPro_UpdateSettings()
        
        local origUIErrorsFrame_AddMessage = UIErrorsFrame.AddMessage
        UIErrorsFrame.AddMessage = function(frame, text, r, g, b, a, id)
            if ChatProDB.hideErrors and ChatPro_ErrorList[text] then
                return
            end
            origUIErrorsFrame_AddMessage(frame, text, r, g, b, a, id)
        end
        
        local origSetItemRef = SetItemRef
        SetItemRef = function(link, text, button)
            if string.sub(link, 1, 4) == "url:" then
                ChatPro_ShowCopyBox(string.sub(link, 5))
                return
            end
            origSetItemRef(link, text, button)
        end
        
        local origFriendsFrame_OnEvent = FriendsFrame_OnEvent
        if origFriendsFrame_OnEvent then
            FriendsFrame_OnEvent = function()
                if event == "WHO_LIST_UPDATE" and (GetTime() - whoTimestamp) < 3 then
                    return
                end
                origFriendsFrame_OnEvent()
            end
        end
        
        local origChatFrame_OnEvent = ChatFrame_OnEvent
        if origChatFrame_OnEvent then
            ChatFrame_OnEvent = function(event)
                if event == "CHAT_MSG_SYSTEM" and arg1 then
                    -- Parse manual or auto /who results from system message
                    for name, level, classname in string.gfind(arg1, "%[(.-)%].+ (%d+) .- (.-) (.-) .+") do
                        if name and classname then
                            CachePlayer(name, classname, level)
                        end
                    end
                    
                    if (GetTime() - whoTimestamp) < 3 then
                        if string.find(arg1, SCCN_CHATPATTERN1) or string.find(arg1, SCCN_WHO_RESULTS_PATTERN) then
                            return
                        end
                    end
                end
                origChatFrame_OnEvent(event)
            end
        end
        
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ffffChatPro|r 插件已加载。输入 |cffffff00/chatpro|r 打开设置面板。")
        
    elseif event == "FRIENDLIST_UPDATE" then
        for i=1, GetNumFriends() do
            local name, level, class = GetFriendInfo(i)
            CachePlayer(name, class, level)
        end
    elseif event == "GUILD_ROSTER_UPDATE" then
        for i=1, GetNumGuildMembers() do
            local name, _, _, level, class = GetGuildRosterInfo(i)
            if name then
                name = string.gsub(name, "-.*", "")
                CachePlayer(name, class, level)
            end
        end
    elseif event == "RAID_ROSTER_UPDATE" then
        for i=1, GetNumRaidMembers() do
            local name, _, _, level, class = GetRaidRosterInfo(i)
            CachePlayer(name, class, level)
        end
    elseif event == "PARTY_MEMBERS_CHANGED" then
        for i=1, GetNumPartyMembers() do
            local unit = "party"..i
            local _, class = UnitClass(unit)
            CachePlayer(UnitName(unit), class, UnitLevel(unit))
        end
    elseif event == "WHO_LIST_UPDATE" then
        for i=1, GetNumWhoResults() do
            local name, guild, level, race, class, zone = GetWhoInfo(i)
            CachePlayer(name, class, level)
        end
    elseif event == "PLAYER_TARGET_CHANGED" or event == "UPDATE_MOUSEOVER_UNIT" then
        local unit = event == "PLAYER_TARGET_CHANGED" and "target" or "mouseover"
        if UnitIsPlayer(unit) then
            local _, class = UnitClass(unit)
            CachePlayer(UnitName(unit), class, UnitLevel(unit))
        end
    elseif event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" then
        if ChatProDB.autoWho then
            local name = arg2
            if name then
                local lowerName = string.lower(name)
                if not ChatProDB.players[lowerName] then
                    QueueWho(name)
                end
            end
        end
    end
end)

eventFrame:SetScript("OnUpdate", function()
    if isWhoing then
        whoTimeout = whoTimeout + arg1
        if whoTimeout > 5 then
            isWhoing = false
        end
    end

    whoTimer = whoTimer + arg1
    if whoTimer > 3.0 then
        whoTimer = 0
        if table.getn(whoQueue) > 0 then
            local name = table.remove(whoQueue, 1)
            isWhoing = true
            whoTimeout = 0
            whoTimestamp = GetTime()
            SendWho(name)
        end
    end

    if ChatProDB and ChatProDB.hideButtons then
        for i=1, NUM_CHAT_WINDOWS do
            local chatFrame = getglobal("ChatFrame"..i)
            if chatFrame then
                local up = getglobal("ChatFrame"..i.."UpButton")
                local down = getglobal("ChatFrame"..i.."DownButton")
                local bottom = getglobal("ChatFrame"..i.."BottomButton")
                if up then up:SetAlpha(0); up:EnableMouse(false) end
                if down then down:SetAlpha(0); down:EnableMouse(false) end
                if bottom then
                    if chatFrame:AtBottom() then
                        bottom:SetAlpha(0)
                        bottom:EnableMouse(false)
                    else
                        bottom:SetAlpha(1)
                        bottom:EnableMouse(true)
                    end
                end
            end
        end
    end
end)

local configOptions = {
    { key = "colorNicks", label = "职业着色姓名", tip = "根据职业自动显示对应颜色" },
    { key = "showLevel", label = "显示玩家等级", tip = "显示玩家等级，并按难度着色" },
    { key = "autoWho", label = "自动查询未知玩家", tip = "遇到未缓存的玩家发言时自动 /who" },
    { key = "inChatHighlight", label = "聊天中已知名字高亮", tip = "正文中出现已知玩家时进行高亮着色" },
    { key = "shortChannel", label = "隐藏/简化频道名称", tip = "隐藏 [Guild] 等前缀，简化自定义频道" },
    { key = "mouseScroll", label = "鼠标滚轮快速翻页", tip = "支持鼠标滚轮，Shift快翻，Ctrl到底" },
    { key = "timeStamp", label = "聊天时间戳", tip = "添加发送时间，点击时间戳可复制" },
    { key = "hyperlink", label = "网址链接识别", tip = "识别网址为可点击的超链接并复制" },
    { key = "topEditbox", label = "置顶输入框", tip = "将聊天输入框移动到窗口顶部显示" },
    { key = "editboxKeys", label = "无障碍方向键编辑", tip = "无需按Alt直接使用方向键，增加历史记录" },
    { key = "stickyChannels", label = "频道记忆(粘性)", tip = "自动停留在上次发送消息的频道" },
    { key = "hideErrors", label = "屏蔽红字错误提示", tip = "屏蔽屏幕中央烦人的红字报错" },
    { key = "noFade", label = "禁用聊天渐隐", tip = "聊天记录永久可见，不自动变暗消失" },
    { key = "hideButtons", label = "隐藏多余聊天按钮", tip = "隐藏翻页箭头和底端按钮等" },
    { key = "shortWhisper", label = "简化密语前缀", tip = "改为类似 某某说： 或 密某某： 的形式" },
}

function ChatPro_InitConfigUI()
    local yOffset = -50
    for i, opt in ipairs(configOptions) do
        local btn = CreateFrame("CheckButton", "ChatProConfigChk"..i, ChatProConfigFrame, "OptionsCheckButtonTemplate")
        if math.mod(i, 2) == 1 then
            btn:SetPoint("TOPLEFT", ChatProConfigFrame, "TOPLEFT", 20, yOffset)
        else
            btn:SetPoint("TOPLEFT", ChatProConfigFrame, "TOPLEFT", 180, yOffset)
            yOffset = yOffset - 40
        end
        
        getglobal(btn:GetName().."Text"):SetText(opt.label)
        
        btn.optKey = opt.key
        btn.optLabel = opt.label
        btn.optTip = opt.tip
        
        btn:SetScript("OnClick", function()
            ChatProDB[this.optKey] = this:GetChecked() and true or false
            ChatPro_UpdateSettings()
        end)
        
        btn:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:AddLine(this.optLabel)
            GameTooltip:AddLine(this.optTip, 1, 1, 1, 1)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
end

function ChatPro_RefreshConfigUI()
    if not ChatProDB then return end
    for i, opt in ipairs(configOptions) do
        local btn = getglobal("ChatProConfigChk"..i)
        if btn then
            btn:SetChecked(ChatProDB[opt.key] and 1 or 0)
        end
    end
end

function ChatPro_InitShortChanUI()
    local yOffset = -60
    for i=1, 9 do
        local fromBox = CreateFrame("EditBox", "ChatProShortChanFrom"..i, ChatProShortChanFrame, "InputBoxTemplate")
        fromBox:SetWidth(100)
        fromBox:SetHeight(30)
        fromBox:SetPoint("TOPLEFT", ChatProShortChanFrame, "TOPLEFT", 40, yOffset)
        fromBox:SetAutoFocus(false)
        fromBox:SetFontObject("GameFontHighlightSmall")

        local toBox = CreateFrame("EditBox", "ChatProShortChanTo"..i, ChatProShortChanFrame, "InputBoxTemplate")
        toBox:SetWidth(100)
        toBox:SetHeight(30)
        toBox:SetPoint("TOPLEFT", ChatProShortChanFrame, "TOPLEFT", 160, yOffset)
        toBox:SetAutoFocus(false)
        toBox:SetFontObject("GameFontHighlightSmall")

        yOffset = yOffset - 35
    end
end

function ChatPro_RefreshShortChanUI()
    if not ChatProDB or not ChatProDB.channelReplacements then return end
    for i=1, 9 do
        local rep = ChatProDB.channelReplacements[i]
        if rep then
            getglobal("ChatProShortChanFrom"..i):SetText(rep.from or "")
            getglobal("ChatProShortChanTo"..i):SetText(rep.to or "")
        else
            getglobal("ChatProShortChanFrom"..i):SetText("")
            getglobal("ChatProShortChanTo"..i):SetText("")
        end
    end
end

function ChatPro_SaveShortChanUI()
    if not ChatProDB.channelReplacements then ChatProDB.channelReplacements = {} end
    for i=1, 9 do
        local fromText = getglobal("ChatProShortChanFrom"..i):GetText()
        local toText = getglobal("ChatProShortChanTo"..i):GetText()
        if not ChatProDB.channelReplacements[i] then ChatProDB.channelReplacements[i] = {} end
        ChatProDB.channelReplacements[i].from = fromText
        ChatProDB.channelReplacements[i].to = toText
    end
end

function ChatPro_ShowCopyBox(text)
    ChatProCopyFrame:Show()
    ChatProCopyEditBox:SetText(text)
    ChatProCopyEditBox:HighlightText()
end

SLASH_CHATPRO1 = "/chatpro"
SlashCmdList["CHATPRO"] = function(msg)
    if ChatProConfigFrame:IsShown() then
        ChatProConfigFrame:Hide()
    else
        ChatProConfigFrame:Show()
    end
end
