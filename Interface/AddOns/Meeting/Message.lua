local Message = {}

Meeting.Message = Message
Meeting.blockWords = MEETING_DB.blockWords

local EVENTS = {
    CREATE = "C",
    REQUEST = "R",
    DECLINE = "D",
    MEMBERS = "M",
    CLOSE = "L",
    VERSION = "V",
}

local function CheckBlockWords(playerName, message)
    if playerName == Meeting.player then
        return false
    end
    if not message or message == "" or message == "_" then
        return false
    end
    if not Meeting.blockWords or table.getn(Meeting.blockWords) == 0 then
        return false
    end
    local lowerMessage = string.lower(message)
    for _, word in ipairs(Meeting.blockWords) do
        if word and word ~= "" then
            local lowerWord = string.lower(word)
            if string.find(lowerMessage, lowerWord) then
                return true
            end
        end
    end
    return false
end

Meeting.CheckBlockWords = CheckBlockWords

function Message.OnRecv(playerName, data)
    local _, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = string.meetingsplit(data, ":")
    if event == EVENTS.CREATE then
        if CheckBlockWords(playerName, arg2) then return end
        if CheckBlockWords(playerName, playerName) then return end
        Meeting:OnCreate(playerName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    elseif event == EVENTS.REQUEST then
        Meeting:OnRequest(playerName, arg1, arg2, arg3, arg4, arg5, arg6)
    elseif event == EVENTS.DECLINE then
        Meeting:OnDecline(playerName, arg1)
    elseif event == EVENTS.MEMBERS then
        Meeting:OnMembers(playerName, arg1, arg2)
    elseif event == EVENTS.CLOSE then
        Meeting:OnClose(playerName)
    elseif event == EVENTS.VERSION then
        Meeting:OnVersion(arg1)
    end
end

local matchText = {}
for _, category in ipairs(Meeting.Categories) do
    for _, value in ipairs(category.children) do
        if value.match then
            for _, match in ipairs(value.match) do
                table.insert(matchText, match)
            end
        end
    end
end

local distinct = {}
for _, v in ipairs(matchText) do
    if not distinct[v] then
        distinct[v] = true
    end
end
matchText = {}
for k, _ in pairs(distinct) do
    table.insert(matchText, k)
end
distinct = nil

function Message.OnRecvFormChat(channel, playerName, message)
    if string.find(message, "|Hquest:") then
        local questStart = string.find(message, "|Hquest:")
        if questStart then
            local bracketStart = string.find(message, "%[", questStart)
            if bracketStart then
                local bracketEnd = string.find(message, "%]", bracketStart)
                if bracketEnd then
                    local pipeHStart = string.find(message, "|h", bracketEnd)
                    if pipeHStart then
                        local linkPart = string.sub(message, questStart)
                        local linkEnd = string.find(linkPart, "|h")
                        if linkEnd then
                            linkPart = string.sub(linkPart, 1, linkEnd + 1)
                            local questID, questLevel, questName = string.match(
                                linkPart,
                                "|Hquest:(%d+):(%d+)|h%[([^%]]*)%]|h"
                            )
                            if questID and questLevel and questName then
                                Meeting:OnCreate(playerName, "QuestLink",
                                    questName,
                                    questLevel,
                                    "0",
                                    "0",
                                    "0",
                                    questID
                                )
                                return
                            end
                        end
                    end
                end
            end
        end
    end

    local activity = Meeting:FindActivity(playerName)
    if activity and not activity:IsChat() then
        return
    end
    if string.find(message, "求组") then
        return
    end
    if CheckBlockWords(playerName, message) then
        return
    end

    local lowerMessage = string.lower(message)
    local matchs, nomatchs = SetMathcKeyWords()

    local shouldMatchAll = Meeting.searchInfo.category == "" or
        (Meeting.searchInfo.category ~= "" and Meeting.searchInfo.code == "" and not next(Meeting.searchInfo.codes))

    for _, nomatch in ipairs(nomatchs) do
        if string.find(lowerMessage, nomatch) then
            return
        end
    end

    if shouldMatchAll then
        for _, v in ipairs(matchText) do
            if string.find(lowerMessage, v) then
                Meeting:OnCreate(playerName, string.upper(channel), message, "0", "0", "0",
                    channel == "hardcore" and "1" or "0")
                return
            end
        end
    else
        for _, match in ipairs(matchs) do
            if string.find(lowerMessage, match) then
                Meeting:OnCreate(playerName, string.upper(channel), message, "0", "0", "0",
                    channel == "hardcore" and "1" or "0")
                return
            end
        end
    end
end

function Message.Send(event, msg)
    local channel = GetChannelName(Meeting.channel)
    if channel ~= 0 then
        SendChatMessage("Meeting:" .. event .. ":" .. msg, "CHANNEL", nil, channel)
    else
        print("请先加入" .. Meeting.channel .. "频道")
    end
end

function Message.CreateActivity(code, comment, targetMembers)
    local maxMembers = targetMembers or Meeting.GetActivityMaxMembers(code)
    local data = string.format("%s:%s:%d:%d:%d:%d:%s:%d", code,
        string.isempty(comment) and "_" or comment, UnitLevel("player"),
        Meeting.ClassToNumber(Meeting.playerClass),
        table.getn(Meeting.members) + 1, Meeting.playerIsHC and 1 or 0,
        Meeting.EncodeGroupClass(), maxMembers)
    MEETING_DB.activity = {
        code = code,
        comment = comment,
        targetMembers = maxMembers,
        lastTime = time()
    }
    Message.InvokeSyncActivityTimer()
    Message.Send(EVENTS.CREATE, data)
end

function Message.Request(id, comment, role)
    local data = string.format("%s:%d:%d:%d:%s:%d", id, UnitLevel("player"),
        Meeting.ClassToNumber(Meeting.playerClass), Meeting.GetPlayerScore(), string.isempty(comment) and "_" or comment,
        role)
    Message.Send(EVENTS.REQUEST, data)
end

function Message.Decline(name)
    Message.Send(EVENTS.DECLINE, string.format("%s", name))
end

function Message.SyncMembers(members)
    Message.Send(EVENTS.MEMBERS, string.format("%d:%s", members, Meeting.EncodeGroupClass()))
end

function Message.CloseActivity(leave)
    Message.Send(EVENTS.CLOSE, "")
    if not leave then
        MEETING_DB.activity = nil
    end
end

function Message.SendVersion()
    Message.Send(EVENTS.VERSION, Meeting.VERSION.MAJOR .. "." .. Meeting.VERSION.MINOR .. "." .. Meeting.VERSION.PATCH)
end

local syncTimer = nil

function Message.InvokeSyncActivityTimer()
    if syncTimer then
        syncTimer:Cancel()
    end
    syncTimer = C_Timer.NewTicker(60, function()
        if Meeting.isAFK then
            return
        end
        local activity = Meeting:FindActivity(Meeting.player)
        if activity then
            Message.CreateActivity(activity.code, activity.comment, activity.targetMembers)
        end
    end, -1)
end