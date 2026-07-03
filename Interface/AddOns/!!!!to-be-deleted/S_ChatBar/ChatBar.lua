S_ChatBarDB = S_ChatBarDB or {
    showFrame = true,
    buttons = {
        Say = true,
        Yell = true,
        Whisper = true,
        Party = true,
        Guild = true,
        Officer = false,
        Raid = true,
        RaidWarns = false,
        Battlefield = false,
        General = true,
        Trade = false,
        World = true,
        Zhong = false,
        HC = false,
        Meeting = false,
        RaidProgress = false, 
        XyTracker = false,
        AtlasLoot = false,
        SuperMacro = false,
        ActionBarProfiles = false,
        Outfitter = false, 
        TrinketMenu = false,
        RaidCheck = false,
        SpiritSenseRec = false,
        BetterCharacterStats = false,
        AutoMarker = false,
        Automatonex = false,
        Tracking = false,
        SilverDragonRadar = false,
        Emote = true
    }
}

local BUTTON_ORDER = {
    "Say", "Yell", "Whisper", "Party", "Guild", "Officer", 
    "Raid", "RaidWarns", "Battlefield", "General", "Trade", 
    "World", "Zhong",
    "HC", "Meeting", 
    "RaidProgress", 
    "XyTracker", "AtlasLoot", 
    "SuperMacro", "ActionBarProfiles", "Outfitter", "TrinketMenu","RaidCheck","SpiritSenseRec",
    "BetterCharacterStats","AutoMarker" ,"Automatonex","Tracking","SilverDragonRadar","Emote"  
}


local buttonFrames      = {}
local lastVisibleButton = nil

-- Chatbar主框体 --
COLORSCHEME_BORDER      = { 0.3, 0.3, 0.3, 1 }

-- 表情菜单数据
local EmoteData = {
    {
        text = "常用表情",
        menuList = {
            {text = "跳舞", command = "/dance"},
            {text = "特殊跳舞", command = "/dancespecial"},
            {text = "好的", command = "/yes"},
            {text = "不", command = "/no"},
            {text = "否决", command = "/veto"},
            {text = "大笑", command = "/laugh"},
            {text = "咯咯笑", command = "/cackle"},
            {text = "哭泣", command = "/cry"},
            {text = "挥手", command = "/wave"},
            {text = "鞠躬", command = "/bow"},
            {text = "感谢", command = "/thank"},
            {text = "问候", command = "/hi"},
            {text = "性感", command = "/sexy"},
            {text = "法力不足", command = "/oom"},
            {text = "敌人", command = "/incoming"},
            {text = "开火", command = "/openfire"},
            {text = "再见", command = "/bye"},
            {text = "胜利", command = "/victory"},
            {text = "祝贺", command = "/cong"}
        }
    },
    {
        text = "社交表情", 
        menuList = {
            {text = "欢呼", command = "/cheer"},
            {text = "敬礼", command = "/salute"},
            {text = "问候", command = "/greet"},
            {text = "亲吻", command = "/kiss"}, 
            {text = "舔", command = "/lick"}, 
            {text = "咚", command = "/doh"}, 
            {text = "糊涂", command = "/confused"}, 
            {text = "鼓掌", command = "/applaud"},
            {text = "拥抱", command = "/hug"},
            {text = "按摩", command = "/massage"},
            {text = "欢迎", command = "/welcome"},
            {text = "赞扬", command = "/commend"},
            {text = "乞求", command = "/beg"},
            {text = "轻拍", command = "/pat"},
            {text = "小猫", command = "/cat"},
            {text = "眨眼", command = "/blink"}
        }
    },
    {
        text = "负面表情",
        menuList = {
            {text = "生气", command = "/angry"},
            {text = "放屁", command = "/fart"},
            {text = "耳光", command = "/slap"},
            {text = "哈欠", command = "/yawn"},
            {text = "嘲笑", command = "/mock"},
            {text = "威胁", command = "/threaten"},
            {text = "侮辱", command = "/rude"},
            {text = "咆哮", command = "/roar"},
            {text = "皱眉", command = "/frown"},
            {text = "叹气", command = "/sigh"},
            {text = "撕咬", command = "/bite"},
            {text = "退缩 ", command = "/cower"},
            {text = "嘲讽 ", command = "/taunt"},
            {text = "咳嗽 ", command = "/cough"},
            {text = "幸灾乐祸 ", command = "/gloat"},
            {text = "凌辱 ", command = "/insult"},
            {text = "哀悼 ", command = "/mourn"},
            {text = "打嗝", command = "/burp"}
        }
    },
    {
        text = "其他表情",
        menuList = {
            {text = "坐下", command = "/sit"},
            {text = "卑微", command = "/peon"},
            {text = "站立", command = "/stand"},
            {text = "睡觉", command = "/sleep"},
            {text = "吃东西", command = "/eat"},
            {text = "喝酒", command = "/drink"},
            {text = "工作", command = "/work"},
            {text = "失落", command = "/flop"},
            {text = "火车", command = "/train"},
            {text = "屁股", command = "/moon"},
            {text = "强壮", command = "/strong"},
            {text = "臭味", command = "/stink"},
            {text = "压关节", command = "/knuckles"},
            {text = "小鸡", command = "/chicken"}
        }
    }
}

-- 表情菜单创建函数
local function CreateEmoteMenu(level)
    if not level then return end
    
    local info = {}
    
    if level == 1 then
        -- 第一级菜单 - 显示分类
        for _, category in ipairs(EmoteData) do
            info = {}
            info.text = category.text
            info.notCheckable = 1
            info.hasArrow = 1
            info.value = category
            UIDropDownMenu_AddButton(info, level)
        end
    elseif level == 2 then
        -- 第二级菜单 - 显示具体表情
        local category = UIDROPDOWNMENU_MENU_VALUE
        if category and category.menuList then
            for _, e in ipairs(category.menuList) do
                local emote = e
                info = {}
                info.text = emote.text
                info.notCheckable = 1
                info.func = function()
                    local editBox = ChatFrame1.editBox
                    if editBox then
                        editBox:SetText(emote.command)
                        ChatEdit_SendText(editBox, 0)
                    else
                        if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox then
                            DEFAULT_CHAT_FRAME.editBox:SetText(emote.command)
                            ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
                        else
                            message("无法找到聊天输入框。")
                        end
                    end
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end
end

-- 创建表情下拉菜单框架
local EmoteDropdown = CreateFrame("Frame", "EmoteDropdown", UIParent, "UIDropDownMenuTemplate")


-- 更新按钮布局函数
function UpdateButtonLayout()
    lastVisibleButton = nil
    local totalWidth = 1 -- 初始边距

    -- 计算可见按钮总宽度
    for _, btnName in ipairs(BUTTON_ORDER) do
        local btn = buttonFrames[btnName]
        if btn and S_ChatBarDB.buttons[btnName] then
            totalWidth = totalWidth + btn:GetWidth() + 1 -- 按钮宽度 + 间距
        end
    end

    -- 动态调整主框体宽度
    chatbar:SetWidth(totalWidth + 5) -- 留出骰子按钮空间

    -- 重新排列按钮
    for _, btnName in ipairs(BUTTON_ORDER) do
        local btn = buttonFrames[btnName]
        if btn then
            btn:ClearAllPoints()
            if S_ChatBarDB.buttons[btnName] then
                if lastVisibleButton then
                    btn:SetPoint("LEFT", lastVisibleButton, "RIGHT", 1, 0)
                else
                    btn:SetPoint("LEFT", chatbar, "LEFT", 1, 0)
                end
                btn:Show()
                lastVisibleButton = btn
            else
                btn:Hide()
            end
        end
    end
end

function Getchannel_name()
    local localtime, servertime = tonumber(date("%H", time())), tonumber(format("%02d", GetGameTime()))
    local channel_name = "World"  -- 默认值
    if abs(localtime - servertime) > 2 then
        channel_name = "World"
    end
    return channel_name
end

local chatbar = CreateFrame("Frame", "chatbar", UIParent)
chatbar:SetWidth(420)
chatbar:SetHeight(40)
chatbar:SetPoint("BOTTOMLEFT", ChatFrame3, "TOPLEFT", 10, 24)
chatbar:RegisterEvent("PLAYER_LOGIN")
chatbar:SetMovable(true)    -- 启用移动
chatbar:SetUserPlaced(true) -- 允许用户放置


-- 在PLAYER_LOGIN事件中修改自动加入逻辑
chatbar:SetScript("OnEvent", function()
print("PLAYER_LOGIN 事件开始")
    -- 如果默认是显示状态,那么根据对应插件加载状态设置
    for k, btnName in ipairs(BUTTON_ORDER) do
    if k >= 15 and btnName ~= "Tracking" and btnName ~= "Emote" and S_ChatBarDB.buttons[btnName] then
        if btnName == "AtlasLoot" then
            S_ChatBarDB.buttons[btnName] = IsAddOnLoaded("AtlasLoot") or IsAddOnLoaded("InstanceJournal")
        else
            S_ChatBarDB.buttons[btnName] = IsAddOnLoaded(btnName)
        end
    end
end
    
    -- 初始化离开频道标记
    S_ChatBarDB.leftWorldChannel = S_ChatBarDB.leftWorldChannel or false
    S_ChatBarDB.leftZhongChannel = S_ChatBarDB.leftZhongChannel or false

    -- 暂时注释掉可能出错的代码
    -- if S_MiniMap and MiniMapTrackingFrame then MiniMapTrackingFrame:SetScale(0.4) end
    -- if not S_ChatBarDB.leftWorldChannel then ... end
    -- ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")
    -- 延迟调用布局
    C_Timer.After(0.2, UpdateButtonLayout)
end)

-- 创建按钮的通用函数
local function CreateChatButton(name, text, tooltip, color, onClick)
    local button = CreateFrame("Button", "Channel" .. name, chatbar)
    button:SetWidth(20)
    button:SetHeight(20)
    button:RegisterForClicks("LeftButtonUp")

    button.t = button:CreateTexture()
    button.t:SetAllPoints()

    button.text = button:CreateFontString(nil, "OVERLAY")
    button.text:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
    button.text:SetJustifyH("CENTER")
    button.text:SetWidth(25)
    button.text:SetHeight(25)
    button.text:SetPoint("CENTER", 0, 1)
    button.text:SetText(text)
    button.text:SetTextColor(unpack(color))
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", onClick)
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
        GameTooltip:AddLine(tooltip)
        if name == "Tracking" then
            GameTooltip:AddLine("点击|cFF00CCFF 左键 |r可选择追踪类型", 1, 1, 0)
            GameTooltip:AddLine("点击|cFF00CCFF 右键 |r可选择启用/关闭/切换可移动追踪图标", 1, 1, 0)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    buttonFrames[name] = button
    return button
end

-- 改进的 GetChannelID 函数，支持前缀匹配（默认）
local function GetChannelID(channelname, fuzzy)
    local targetLower = string.lower(channelname)
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name then
            local nameLower = string.lower(name)
            -- 精确匹配或前缀匹配
            if nameLower == targetLower or string.sub(nameLower, 1, string.len(targetLower)) == targetLower then
                return id
            end
        end
    end
    return nil
end

-- 获取综合频道ID
local function GetGeneralChannelID()
    return GetChannelID("综合") or GetChannelID("General")
end

-- 获取交易频道ID
local function GetTradeChannelID()
    return GetChannelID("交易") or GetChannelID("Trade")
end

-- 专门处理综合频道的函数（修改：保留输入文字）
local function ChannelGeneral_OnClick()
    local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME
    local channelID = GetGeneralChannelID()
    if channelID then
        chatFrame.editBox:Show()
        chatFrame.editBox.chatType = "CHANNEL"
        chatFrame.editBox.channelTarget = channelID
        ChatEdit_UpdateHeader(chatFrame.editBox)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000未找到综合频道，请先加入综合频道|r")
    end
end

-- 专门处理交易频道的函数（修改：保留输入文字）
local function ChannelTrade_OnClick()
    local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME
    local channelID = GetTradeChannelID()
    if channelID then
        chatFrame.editBox:Show()
        chatFrame.editBox.chatType = "CHANNEL"
        chatFrame.editBox.channelTarget = channelID
        ChatEdit_UpdateHeader(chatFrame.editBox)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000未找到交易频道，请先加入交易频道|r")
    end
end


local function ChannelEmote_OnClick()
    -- 初始化表情下拉菜单
    UIDropDownMenu_Initialize(EmoteDropdown, CreateEmoteMenu)
    -- 显示菜单
    ToggleDropDownMenu(1, nil, EmoteDropdown, this, 0, 0)
end

local function ChannelRaidProgress_OnClick()
    -- 优先使用新的表格界面
    if _G.RealTableUI and _G.RealTableUI.Show then
        -- 使用新的状态检查函数
        if _G.RealTableUI.IsVisible and _G.RealTableUI.IsVisible() then
            _G.RealTableUI.Hide()
        else
            _G.RealTableUI.Show()
        end
    elseif RaidProgressUI and RaidProgressUI.mainFrame then
        -- 备选：使用旧界面
        if RaidProgressUI.mainFrame:IsShown() then
            RaidProgressUI:HideCombinedInfo()
        else
            RaidProgressUI:ShowCombinedInfo()
        end
    else
        -- 如果都不可用，使用命令行方式
        ChatFrame_OpenChat("/rp", DEFAULT_CHAT_FRAME)
    end
end


local function ChannelMeeting_OnClick()
    if arg1 == "LeftButton" then
        if Meeting then
            Meeting:Toggle()
        end
    elseif arg1 == "RightButton" then
        if LFT_Toggle then
            LFT_Toggle()
        else
            print("LFT功能未加载")
        end
    end
end

local function Automatonex_OnClick()
    if Automaton and Automaton.OnClick then
        Automaton.OnClick()
    else
        ChatFrame_OpenChat("/AUTO ", chatFrame)
    end
end

local function ChannelXyTracker_OnClick()
    if XyTrackerFrame then
        if not XyTrackerFrame:IsShown() then
            XyTracker_ShowXyWindow()
        else
            XyTracker_HideXyWindow()
        end
    end
end

local function AtlasLoot_OnClick()
    local button = arg1
    if button == "LeftButton" then
        -- 左键：优先 AtlasLoot，若未加载则尝试 InstanceJournal
        if IsAddOnLoaded("AtlasLoot") and AtlasLootDefaultFrame then
            if not AtlasLootDefaultFrame:IsShown() then
                AtlasLootDefaultFrame:Show()
            else
                AtlasLootDefaultFrame:Hide()
            end
        elseif IsAddOnLoaded("InstanceJournal") and _G["IJ_InstanceJournalFrame"] then
            -- 备选：切换到 InstanceJournal
            local frame = _G["IJ_InstanceJournalFrame"]
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000未找到 AtlasLoot 或 InstanceJournal 插件|r")
        end
    elseif button == "RightButton" then
        -- 右键：始终尝试打开 InstanceJournal（若已加载）
        if IsAddOnLoaded("InstanceJournal") and _G["IJ_InstanceJournalFrame"] then
            local frame = _G["IJ_InstanceJournalFrame"]
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000InstanceJournal 插件未加载或界面不存在|r")
        end
    end
end

local function SuperMacro_OnClick()
    if SuperMacroFrame then
        if not SuperMacroFrame:IsShown() then
            SuperMacroFrame:Show()
        else
            SuperMacroFrame:Hide()
        end
    else
        if not MacroFrame:IsShown() then
            MacroFrame:Show()
        else
            MacroFrame:Hide()
        end
    end
end

function RaidCheck_OnClick()
    if RC_MainFrame then
        if RC_MainFrame:IsShown() then
            RC_MainFrame:Hide()
        else
            RC_MainFrame:Show()
        end
    else
        if not RC_MainFrame:IsShown() then
        ChatFrame_OpenChat("/RC ", chatFrame)
        end
    end
end

local function ChannelSilverDragonRadar_OnClick()
    local button = arg1
    if button == "LeftButton" then
        if SunRadar_MainFrame then
            if SunRadar_MainFrame:IsShown() then
                SunRadar_MainFrame:Hide()
            else
                SunRadar_MainFrame:Show()
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000未找到 SunRadar_MainFrame，请确认 SunRadar 插件已正确加载|r")
        end
    end
end

function SpiritSenseRec_OnClick()
    if SpiritSenseRecMainFrame then
        if not SpiritSenseRecMainFrame:IsShown() then
            SpiritSenseRecMainFrame:Show()
        else
            SpiritSenseRecMainFrame:Hide()
        end
    end
end

function BetterCharacterStats_OnClick()
    if arg1 == "LeftButton" then
        if BCS and BCS.PropertiesPanel and BCS.PropertiesPanel.mainFrame then
            local frame = BCS.PropertiesPanel.mainFrame
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000属性面板模块未加载|r")
        end
    elseif arg1 == "RightButton" then
        if BCS and BCS.PropertiesPanel and BCS.PropertiesPanel.GetPropertiesForChat then
            local propertiesText = BCS.PropertiesPanel:GetPropertiesForChat()
            
            local targetName = UnitName("target")
            if targetName then
                SendChatMessage(propertiesText, "WHISPER", nil, targetName)
            else
                if WIM_EditBoxInFocus then
                    WIM_EditBoxInFocus:SetText(propertiesText)
                    WIM_EditBoxInFocus:HighlightText()
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000属性面板: 没有选择目标且WIM未加载|r")
                end
            end
            
            if BCS.PropertiesPanel.mainFrame then
                BCS.PropertiesPanel.mainFrame:Hide()
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000属性面板模块未加载|r")
        end
    end
end

function AutoMarker_OnClick()
    if AutoMarkerUIFrame then
        if not AutoMarkerUIFrame:IsShown() then
            AutoMarkerUIFrame:Show()
        else
            AutoMarkerUIFrame:Hide()
        end
    end
end

local function TrackingButton_OnClick()
    local button = arg1 -- 使用arg1获取点击按钮
    if button == "LeftButton" then
        if TrackingFrame or MiniMapTrackingFrame then
            TrackingFrame:InitMenu()
            ToggleDropDownMenu(1, nil, TrackingFrame.menu, this, 0, 0)
        end
    elseif button == "RightButton" then
        -- 三种模式循环切换: native → modern → hide → native
        if S_ChatBarDB.trackingMode == "native" then
            S_ChatBarDB.trackingMode = "modern"
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00追踪按钮模式: 现代 (modern)|r")
        elseif S_ChatBarDB.trackingMode == "modern" then
            S_ChatBarDB.trackingMode = "hide"
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00追踪按钮模式: 隐藏 (hide)|r")
        else
            S_ChatBarDB.trackingMode = "native"
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00追踪按钮模式: 原生 (native)|r")
        end

        -- 根据新模式立即刷新显示
        if S_ChatBarDB.trackingMode == "native" then
            TrackingFrame:Hide()
            MiniMapTrackingFrame:Show()
        elseif S_ChatBarDB.trackingMode == "modern" then
            TrackingFrame:Show()
            MiniMapTrackingFrame:Hide()
        elseif S_ChatBarDB.trackingMode == "hide" then
            TrackingFrame:Hide()
            MiniMapTrackingFrame:Hide()
        end
    end
end


local function TrinketMenu_OnClick()
    if TrinketMenu_OptFrame then
        if not TrinketMenu_OptFrame:IsShown() then
            TrinketMenu_OptFrame:Show()
        else
            TrinketMenu_OptFrame:Hide()
        end
    end
end

local function ActionBarProfiles_OnClick()
    if ABP_SlashCommand then
        ToggleDropDownMenu(1, nil, ABP_DropDownMenu, this, 0, 0)
    end
end

local function Outfitter_OnClick()
    if OutfitterMinimapButton then
        if OutfitterMinimapDropDown_OnLoad then
            OutfitterMinimapDropDown_OnLoad() 
        end
        this.ChangedValueFunc = OutfitterMinimapButton_ItemSelected
        if OutfitterMinimapDropDown_Initialize then
            UIDropDownMenu_Initialize(this, OutfitterMinimapDropDown_Initialize)
        end
        ToggleDropDownMenu(1, nil, this, this, 0, 0)
        if OutfitterMinimapDropDown_AdjustScreenPosition then
            OutfitterMinimapDropDown_AdjustScreenPosition(this)
        end
        PlaySound("igMainMenuOptionCheckBoxOn")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000Outfitter 小地图按钮未找到|r")
    end
end

-- 重写的按钮点击事件的函数(切换频道时编辑框中的文本不会消失)--夜晨
local function Channel_OnClick(chatType, isChannel)
    local chatFrame = SELECTED_DOCK_FRAME

    local ButtonName = this:GetName()

    if (not chatFrame) then
        chatFrame = DEFAULT_CHAT_FRAME;
    end
    if not isChannel then
        chatFrame.editBox:Show();
        if (chatFrame.editBox.chatType == chatType) then
            ChatFrame_OpenChat("", chatFrame);
        else
            chatFrame.editBox.chatType = chatType;
        end
    else
        if arg1 == "LeftButton" then
            if type(chatType) == "number" then
                chatFrame.editBox.chatType = "CHANNEL";
                chatFrame.editBox.channelTarget = chatType
            else
                local id, name = GetChannelName(chatType)
                if id and name == chatType then
                    ChatFrameEditBox:Show()
                    ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chatType)
                    if (chatFrame.editBox.chatType == "CHANNEL") and (chatFrame.editBox.channelTarget == id) then
                        ChatFrame_OpenChat("", chatFrame);
                    else
                        chatFrame.editBox.chatType = "CHANNEL";
                        chatFrame.editBox.channelTarget = id
                    end
                else
                    JoinChannelByName(chatType, nil, 1)
                end
            end
        end
    end
    local text = chatFrame.editBox:GetText()
    text = processString(text)
    chatFrame.editBox:SetText(text)
    ChatEdit_UpdateHeader(chatFrame.editBox);
end

local function ChannelWhisper_OnClick()
    local chatFrame = SELECTED_DOCK_FRAME
    if (not chatFrame) then
        chatFrame = DEFAULT_CHAT_FRAME;
    end
    if arg1 == "LeftButton" then
        local lastTell = ChatEdit_GetLastTellTarget(chatFrame.editBox)
        ChatFrame_OpenChat("/w " .. lastTell, chatFrame)
    else
        if IsAddOnLoaded("wim") then
            -- 检查WIM相关帧是否存在，避免nil错误
            local wimToggleFrame = WIM_Icon_ToggleDropDown and WIM_Icon_ToggleDropDown()
            if wimToggleFrame then
                ToggleFrame(wimToggleFrame)
            else
                -- 备选方案：如果找不到下拉框，尝试直接打开WIM主窗口
                if WIM_MainWindow then
                    ToggleFrame(WIM_MainWindow)
                end
            end
        end
    end
end

-- 修改世界频道按钮逻辑（支持中英文频道名，保留输入文字）
local function ChannelWorld_OnClick()
    local button = arg1
    
    if button == "LeftButton" then
        local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME
        local channelID, channelName = nil, nil
        
        -- 1. 精确匹配
        for i = 1, 10 do
            local id, name = GetChannelName(i)
            if name then
                local nameLower = string.lower(name)
                if nameLower == "世界" or nameLower == "world" then
                    channelID, channelName = id, name
                    break
                end
            end
        end
        
        -- 2. 前缀匹配（排除防务）
        if not channelID then
            for i = 1, 10 do
                local id, name = GetChannelName(i)
                if name then
                    local nameLower = string.lower(name)
                    if (string.find(nameLower, "^世界") or string.find(nameLower, "^world")) then
                        if not string.find(nameLower, "防务") and not string.find(nameLower, "defense") then
                            channelID, channelName = id, name
                            break
                        end
                    end
                end
            end
        end
        
        if channelID then
            chatFrame.editBox:Show()
            chatFrame.editBox.chatType = "CHANNEL"
            chatFrame.editBox.channelTarget = channelID
            ChatEdit_UpdateHeader(chatFrame.editBox)
        else
            -- 未加入，先尝试加入
            JoinChannelByName("世界", nil, 3)
            JoinChannelByName("世界频道", nil, 3)
            JoinChannelByName("world", nil, 3)
            ChatFrame_OpenChat("/世界 ", chatFrame)
        end
        
    elseif button == "RightButton" then
        -- 右键：离开所有世界频道（排除防务）
        local leftAny = false
        for i = 1, 10 do
            local id, name = GetChannelName(i)
            if name then
                local nameLower = string.lower(name)
                local isWorld = false
                -- 精确匹配或前缀匹配排除防务
                if nameLower == "世界" or nameLower == "world" then
                    isWorld = true
                elseif (string.find(nameLower, "^世界") or string.find(nameLower, "^world")) then
                    if not string.find(nameLower, "防务") and not string.find(nameLower, "defense") then
                        isWorld = true
                    end
                end
                if isWorld then
                    LeaveChannelByName(name)
                    leftAny = true
                    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00已离开频道: " .. name .. "|r")
                end
            end
        end
        
        if leftAny then
            S_ChatBarDB.leftWorldChannel = true
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00已离开世界频道，不再自动加入|r")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00未在任何世界频道中|r")
        end
    end
end

-- 修改中文频道按钮逻辑（保留输入文字）
local function ChannelZhong_OnClick()
    local button = arg1
    local channelName = "China"
    
    if button == "LeftButton" then
        local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME
        local channelID = GetChannelID(channelName)
        if not channelID then
            JoinChannelByName(channelName, nil, 3)
            channelID = GetChannelID(channelName)
        end
        
        if channelID then
            chatFrame.editBox:Show()
            chatFrame.editBox.chatType = "CHANNEL"
            chatFrame.editBox.channelTarget = channelID
            ChatEdit_UpdateHeader(chatFrame.editBox)
        end
    elseif button == "RightButton" then
        local channelID = GetChannelID(channelName)
        if channelID then
            LeaveChannelByName(channelName)
            S_ChatBarDB.leftZhongChannel = true
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00已离开中文频道，不再自动加入|r")
            return
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00未在中文频道中|r")
    end
end


CreateChatButton("Say", "说", "说", {1,1,1}, function() Channel_OnClick("SAY") end)
CreateChatButton("Yell", "喊", "喊话", {255/255,64/255,64/255}, function() Channel_OnClick("YELL") end)
CreateChatButton("Whisper", "密", "悄悄话", { 240 / 255, 128 / 255, 128 / 255 }, function() ChannelWhisper_OnClick() end)
CreateChatButton("Party", "队", "队伍", {170/255,170/255,255/255}, function() Channel_OnClick("PARTY") end)
CreateChatButton("Guild", "会", "公会", {64/255,255/255,64/255}, function() Channel_OnClick("GUILD") end)
CreateChatButton("Officer", "官", "官员", {64/255,255/255,64/255}, function() Channel_OnClick("OFFICER") end)
CreateChatButton("Raid", "团", "团队", {255/255,127/255,0}, function()
    if arg1 == "LeftButton" then Channel_OnClick("RAID")
    else RunScript("if pfUI_config...") end
end)
CreateChatButton("RaidWarns", "告", "团队通知", {1,.8,.6}, function() Channel_OnClick("RAID_WARNING") end)
CreateChatButton("Battlefield", "战", "战场频道", {255/255,127/255,0}, function() Channel_OnClick("BATTLEGROUND") end)
CreateChatButton("General", "综", "综合", {1,.6,.5}, ChannelGeneral_OnClick)
CreateChatButton("Trade", "易", "交易频道", {1,.6,.6}, ChannelTrade_OnClick)
CreateChatButton("World", "世", "世界频道", {1,.8,.6}, ChannelWorld_OnClick)
CreateChatButton("Zhong", "中", "中文频道", {1,.9,.7}, ChannelZhong_OnClick)
CreateChatButton("HC", "硬", "硬核", {230/255,204/255,100/255}, function() ChatFrame_OpenChat("/h ", chatFrame) end)
CreateChatButton("Meeting", "集", "集合石", {255/255,165/255,0}, ChannelMeeting_OnClick)
CreateChatButton("RaidProgress", "副", "副本CD", {1, 1, 0}, ChannelRaidProgress_OnClick)
CreateChatButton("XyTracker", "愿", "许愿", {147/255,112/255,219/255}, ChannelXyTracker_OnClick)
CreateChatButton("AtlasLoot", "落", "掉落查询", {180/255,160/255,230/255}, AtlasLoot_OnClick)
CreateChatButton("SuperMacro", "宏", "宏设置", { 120 / 255, 160 / 255, 230 / 255 }, SuperMacro_OnClick)
CreateChatButton("ActionBarProfiles", "动", "动作条配置", {200/255,160/255,230/255}, ActionBarProfiles_OnClick)
CreateChatButton("Outfitter", "装", "一键换装", {200/255, 180/255, 100/255}, Outfitter_OnClick)
CreateChatButton("TrinketMenu", "饰", "饰品设置", {120/255,200/255,200/255}, TrinketMenu_OnClick)
CreateChatButton("RaidCheck", "查", "检查Buff及药剂", {1, 1, 0},RaidCheck_OnClick)
CreateChatButton("SpiritSenseRec", "灵", "灵应录", {60/255,160/255,250/255}, SpiritSenseRec_OnClick)
CreateChatButton("BetterCharacterStats", "属", "属性面板", {180/255,160/255,230/255}, BetterCharacterStats_OnClick)
CreateChatButton("AutoMarker", "标", "自动标记", {60/255,160/255,250/255}, AutoMarker_OnClick)
CreateChatButton("Automatonex", "箱", "自动工具箱", {1,.8,.6}, Automatonex_OnClick)
CreateChatButton("SilverDragonRadar", "精", "稀有精英追踪", { 255 / 255, 215 / 255, 0 }, ChannelSilverDragonRadar_OnClick)
CreateChatButton("Tracking", "追", "追踪设置", { 60 / 255, 160 / 255, 250 / 255 }, TrackingButton_OnClick)

-- 创建表情按钮（使用图标，类似Roll按钮）
local emoteButton = CreateFrame("Button", "ChannelEmote", chatbar)
emoteButton:SetWidth(20)
emoteButton:SetHeight(20)
emoteButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

emoteButton.t = emoteButton:CreateTexture()
emoteButton.t:SetPoint("TOP", emoteButton, "TOP", 0, 2)  -- 向上移动2像素
emoteButton.t:SetPoint("BOTTOM", emoteButton, "BOTTOM", 0, 2)  -- 向上移动2像素
emoteButton.t:SetPoint("LEFT", emoteButton, "LEFT")
emoteButton.t:SetPoint("RIGHT", emoteButton, "RIGHT")
emoteButton.t:SetTexture("Interface\\AddOns\\S_ChatBar\\Friends") -- 使用Friends.tga图标

emoteButton:SetScript("OnClick", ChannelEmote_OnClick)
emoteButton:SetScript("OnEnter", function() 
    GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
    GameTooltip:AddLine("表情菜单")
    GameTooltip:Show()
end)
emoteButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

buttonFrames["Emote"] = emoteButton

-- Roll按钮和配置菜单
local roll = CreateFrame("Button", "rollMacro", chatbar)
roll:SetWidth(20)
roll:SetHeight(20)
roll:SetPoint("LEFT", chatbar, "RIGHT", 2, 0)
roll:RegisterForClicks("LeftButtonUp", "RightButtonUp")

roll.t = roll:CreateTexture()
roll.t:SetAllPoints()
roll.t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")

roll:SetScript("OnClick", function()
    local button = arg1
    if button == "LeftButton" then
        DEFAULT_CHAT_FRAME.editBox:SetText("/roll")
        ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox,0)
    else
        ToggleDropDownMenu(1, nil, S_ChatBar_Menu, this:GetName(), 0, 0) -- 修正锚点参数
    end
end)
roll:SetScript("OnEnter", function() 
    GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
    GameTooltip:AddLine("Roll")
    GameTooltip:AddLine("按住|cFF00CCFF Shift |r可移动聊天快捷按钮", 1, 1, 0)
    GameTooltip:AddLine("点击|cFF00CCFF 右键 |r可选择关闭/显示部分快捷按钮", 1, 1, 0)
    GameTooltip:Show()
end)
roll:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)
roll:SetScript("OnDragStart", function()
    if IsShiftKeyDown() then
        chatbar:StartMoving()
    end
end)
roll:SetScript("OnDragStop", function()
    chatbar:StopMovingOrSizing()
end)
roll:RegisterForDrag("LeftButton")

-- 修改 AtlasLoot 按钮的鼠标提示，根据加载的插件动态显示
local atlasButton = buttonFrames["AtlasLoot"]
if atlasButton then
    atlasButton:SetScript("OnEnter", function()
        local hasAtlas = IsAddOnLoaded("AtlasLoot")
        local hasIJ = IsAddOnLoaded("InstanceJournal")
        GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 6)
        if hasAtlas and hasIJ then
            GameTooltip:AddLine("左键 掉落查询，右键 副本手册")
        elseif hasAtlas then
            GameTooltip:AddLine("掉落查询")
        elseif hasIJ then
            GameTooltip:AddLine("副本手册")
        else
            GameTooltip:AddLine("未加载 AtlasLoot 或 InstanceJournal")
        end
        GameTooltip:Show()
    end)
end

--是否乌龟服
local function IsTurtleServer()
    local _, build = GetBuildInfo()
    if build and tonumber(build) > 6141 then
        return true
    end
    return false
end


-- 创建配置菜单
S_ChatBar_Menu = CreateFrame("Frame", "S_ChatBar_Menu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(S_ChatBar_Menu, function()
    UIDropDownMenu_AddButton {
        text = "显示频道按钮",
        isTitle = true,
        notCheckable = true
    }
    for k, btnName in ipairs(BUTTON_ORDER) do
        if buttonFrames[btnName] then
            -- 判断对应名字的插件是否加载，如果没有加载，不显示此项的菜单选项
            local shouldShow = false
            local isPluginButton = k >= 15  -- 从第15个按钮开始是插件按钮
            
            if k <= 13 then
                -- 前13个是基础聊天按钮，总是显示
                shouldShow = true
            elseif k == 14 and IsTurtleServer() then
                -- 第14个按钮(HC)只在乌龟服显示
                shouldShow = true
            elseif isPluginButton then
                -- 插件按钮：如果插件已加载或按钮名称为Emote/Tracking则显示
                if btnName == "Emote" or btnName == "Tracking" then
                    shouldShow = true  -- Emote和Tracking总是显示
                elseif btnName == "AtlasLoot" then
                    -- 特殊处理：AtlasLoot或InstanceJournal任一加载即显示
                    if IsAddOnLoaded("AtlasLoot") or IsAddOnLoaded("InstanceJournal") then
                        shouldShow = true
                    end
                elseif IsAddOnLoaded(btnName) then
                    shouldShow = true
                end
            end
            
            if shouldShow then
                local displayText = ""
                local r, g, b = 1, 1, 1  -- 默认白色
                
                -- 获取按钮显示文本和颜色
                if buttonFrames[btnName].text then
                    displayText = buttonFrames[btnName].text:GetText() or btnName
                    r, g, b = buttonFrames[btnName].text:GetTextColor()
                else
                    -- 对于没有文本的按钮（如表情按钮），使用固定显示
                    if btnName == "Emote" then
                        displayText = "表"
                        r, g, b = 200/255, 230/255, 100/255  -- 使用表情按钮的颜色
                    else
                        displayText = btnName
                    end
                end
                
                -- 使用闭包捕获当前按钮名称
                local currentBtnName = btnName
                UIDropDownMenu_AddButton {
                    text = displayText,
                    colorCode = string.format("|cFF%02x%02x%02x",
                        math.floor(r * 255 + 0.5),
                        math.floor(g * 255 + 0.5),
                        math.floor(b * 255 + 0.5)),
                    checked = S_ChatBarDB.buttons[currentBtnName],
                    func = function()
                        -- 切换状态并强制立即保存
                        S_ChatBarDB.buttons[currentBtnName] = not S_ChatBarDB.buttons[currentBtnName]
                        UpdateButtonLayout()
                        CloseDropDownMenus()
                        -- 强制刷新菜单
                        ToggleDropDownMenu(1, nil, S_ChatBar_Menu, "cursor", 0, 0)
                    end
                }
            end
        end
    end
end, "MENU")