-- RallyHelper Traditional Chinese Localization (zhTW)
-- 繁體中文在地化檔案

RallyHelper_Locale = RallyHelper_Locale or {}

RallyHelper_Locale["zhTW"] = {
    -- Buff Names (using official Blizzard translations)
    ["ONY"] = "奧妮克希亞",
    ["NEF"] = "奈法利安",
    ["WB"] = "世界增益",
    ["ZG"] = "祖爾格拉布",
    ["DMF"] = "暗月馬戲團",
    
    -- Faction Names
    ["HORDE"] = "部落",
    ["ALLIANCE"] = "聯盟",
    ["BOTH"] = "兩者",
    
    -- City Names (official Blizzard names)
    ["Stormwind"] = "暴風城",
    ["Orgrimmar"] = "奧格瑪",
    ["SW"] = "暴風城",
    ["OG"] = "奧格瑪",
    ["Ironforge"] = "鐵爐堡",
    ["Darnassus"] = "達納蘇斯",
    ["Thunder Bluff"] = "雷霆崖",
    ["Undercity"] = "幽暗城",
    
    -- UI Strings
    ["RallyHelper"] = "集結助手",
    ["World Buff Timer Tracker for Turtle WoW"] = "烏龜魔獸世界增益計時器",
    ["Welcome!"] = "歡迎！",
    ["Settings"] = "設定",
    ["Faction Filter:"] = "陣營過濾：",
    ["Current:"] = "目前：",
    ["Lock UI Position"] = "鎖定介面位置",
    ["Enable Buff Sounds"] = "啟用增益音效",
    ["Width"] = "寬度",
    ["Height"] = "高度",
    ["Scale"] = "縮放",
    ["Close"] = "關閉",
    ["Unconfirmed Buffs"] = "未確認增益",
    
    -- Buff Status Text
    ["ready"] = "準備就緒",
    ["unknown"] = "未知",
    ["confirmed"] = "已確認",
    ["last drop:"] = "最後掉落：",
    ["in"] = "在",
    ["h"] = "小時",
    ["m"] = "分鐘",
    ["s"] = "秒",
    
    -- Time Formatting
    ["FormatTime"] = function(sec)
        if not sec or sec <= 0 then return "準備就緒", 0 end
        local h = math.floor(sec / 3600)
        local m = math.floor((sec - h * 3600) / 60)
        local s = sec - h * 3600 - m * 60
        if h > 0 then
            return string.format("%d小時 %d分鐘", h, m), sec
        elseif m > 0 then
            return string.format("%d分鐘 %d秒", m, s), sec
        else
            return string.format("%d秒", s), sec
        end
    end,
    
    ["FormatAgo"] = function(timestamp)
        local now = time()
        local diff = now - timestamp
        if diff < 60 then
            return string.format("%d秒", diff)
        elseif diff < 3600 then
            local m = math.floor(diff / 60)
            return string.format("%d分鐘", m)
        else
            local h = math.floor(diff / 3600)
            local m = math.floor((diff - h * 3600) / 60)
            return string.format("%d小時 %d分鐘", h, m)
        end
    end,
    
    ["FormatTimeSimple"] = function(sec)
        if not sec or sec <= 0 then return "準備就緒" end
        local h = math.floor(sec / 3600)
        local m = math.floor((sec - h * 3600) / 60)
        if h > 0 then
            return string.format("%d小時 %d分鐘", h, m)
        else
            return string.format("%d分鐘", m)
        end
    end,
    
    -- Command Responses
    ["Sounds enabled"] = "音效已啟用",
    ["Sounds disabled"] = "音效已停用",
    ["Set sound for"] = "設定音效給",
    ["Sound volume set to"] = "音效音量設定為",
    ["toastMode set to"] = "通知模式設定為",
    ["Ignored"] = "已忽略",
    ["Unignored"] = "已取消忽略",
    
    -- Command Usage Help
    ["Usage: /rallysound set <EVENT> <path>"] = "用法: /rallysound set <事件> <路徑>",
    ["Usage: /rallysound volume <0-100>"] = "用法: /rallysound volume <0-100>",
    ["Usage: /rallytoast chat|ui|none"] = "用法: /rallytoast chat|ui|none",
    ["Usage: /rallyignore add|remove|list <name>"] = "用法: /rallyignore add|remove|list <名稱>",
    ["Commands: on, off, set <EVENT> <path>, volume <0-100>"] = "指令: on, off, set <事件> <路徑>, volume <0-100>",
    
    -- Status Messages
    ["Realm:"] = "伺服器:",
    ["Faction filter set to"] = "陣營過濾設定為",
    ["Failed to insert text into chat edit box."] = "無法插入文字到聊天輸入框。",
    
    -- Debug/System Messages (keep English for consistency)
    ["Channel mismatch, ignoring"] = "頻道不匹配，忽略中",
    ["Empty message"] = "空訊息",
    ["RallyHelper message accepted for parsing!"] = "RallyHelper 訊息已接受解析！",
    ["Parsed → ev="] = "解析 → 事件=",
    ["ts="] = "時間戳記=",
    ["sender="] = "發送者=",
    ["Ignoring sender"] = "忽略發送者",
    ["Accepted and UI updated:"] = "已接受並更新介面：",
    ["Accepted TIMER_"] = "已接受計時器_",
    ["and UI updated"] = "並更新介面",
    ["Rejected TIMER_"] = "拒絕計時器_",
    ["by IsSuspicious"] = "因可疑",
    ["Accepted fresh event directly:"] = "直接接受新事件：",
    ["RAW"] = "原始",
    ["Channel='"] = "頻道='",
    ["Msg start='"] = "訊息開始='",
    ["Clean"] = "清除",
    ["clean='"] = "清除='",
    ["expected='"] = "預期='",
    ["Debug"] = "除錯",
    
    -- Minimap Button Tooltips
    ["Left Click: Toggle UI"] = "左鍵: 切換介面",
    ["Alt+Click: Settings"] = "Alt+左鍵: 設定",
    ["Shift+Click: Share timers"] = "Shift+左鍵: 分享計時器",
    ["Middle Click: Unconfirmed"] = "中鍵: 未確認",
    ["Right Click: Status"] = "右鍵: 狀態",
    ["Alt+Drag: Move button"] = "Alt+拖曳: 移動按鈕",
    
    -- Timer Display Text
    ["Ony SW:"] = "奧妮克希亞 暴風城:",
    ["Ony OG:"] = "奧妮克希亞 奧格瑪:",
    ["Nef SW:"] = "奈法利安 暴風城:",
    ["Nef OG:"] = "奈法利安 奧格瑪:",
    ["ZG last drop:"] = "祖爾格拉布 最後掉落:",
    ["DMF:"] = "暗月馬戲團:",
    
    -- First Time Setup
    ["First Time Setup"] = "首次設定",
    ["Select your faction filter:"] = "選擇你的陣營過濾：",
    ["This determines which buff timers are shown."] = "這決定顯示哪些增益計時器。",
    ["You can change this later in settings."] = "你可以在設定中隨時更改。",
    
    -- Additional strings found in the addon
    ["Horde"] = "部落",
    ["Alliance"] = "聯盟",
    ["Both"] = "兩者",
    ["ready"] = "準備就緒",
    ["unknown"] = "未知",
}