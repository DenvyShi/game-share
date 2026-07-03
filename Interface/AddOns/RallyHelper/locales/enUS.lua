-- RallyHelper English Localization (enUS)
-- This is the default language file

RallyHelper_Locale = {}

RallyHelper_Locale["enUS"] = {
    -- Buff Names
    ["ONY"] = "Onyxia",
    ["NEF"] = "Nefarian",
    ["WB"] = "World Buff",
    ["ZG"] = "ZG",
    ["DMF"] = "Darkmoon Faire",
    
    -- Faction Names
    ["HORDE"] = "Horde",
    ["ALLIANCE"] = "Alliance",
    ["BOTH"] = "Both",
    
    -- City Names
    ["Stormwind"] = "Stormwind",
    ["Orgrimmar"] = "Orgrimmar",
    ["SW"] = "SW",
    ["OG"] = "OG",
    
    -- UI Strings
    ["RallyHelper"] = "RallyHelper",
    ["World Buff Timer Tracker for Turtle WoW"] = "World Buff Timer Tracker for Turtle WoW",
    ["Welcome!"] = "Welcome!",
    ["Settings"] = "Settings",
    ["Faction Filter:"] = "Faction Filter:",
    ["Current:"] = "Current:",
    ["Lock UI Position"] = "Lock UI Position",
    ["Enable Buff Sounds"] = "Enable Buff Sounds",
    ["Width"] = "Width",
    ["Height"] = "Height",
    ["Scale"] = "Scale",
    ["Close"] = "Close",
    ["Unconfirmed Buffs"] = "Unconfirmed Buffs",
    
    -- Buff Status Text
    ["ready"] = "ready",
    ["unknown"] = "unknown",
    ["confirmed"] = "confirmed",
    ["last drop:"] = "last drop:",
    ["in"] = "in",
    ["h"] = "h",
    ["m"] = "m",
    ["s"] = "s",
    
    -- Time Formatting
    ["FormatTime"] = function(sec)
        if not sec or sec <= 0 then return "ready", 0 end
        local h = math.floor(sec / 3600)
        local m = math.floor((sec - h * 3600) / 60)
        local s = sec - h * 3600 - m * 60
        if h > 0 then
            return string.format("%dh %dm", h, m), sec
        elseif m > 0 then
            return string.format("%dm %ds", m, s), sec
        else
            return string.format("%ds", s), sec
        end
    end,
    
    ["FormatAgo"] = function(timestamp)
        local now = time()
        local diff = now - timestamp
        if diff < 60 then
            return string.format("%ds", diff)
        elseif diff < 3600 then
            local m = math.floor(diff / 60)
            return string.format("%dm", m)
        else
            local h = math.floor(diff / 3600)
            local m = math.floor((diff - h * 3600) / 60)
            return string.format("%dh %dm", h, m)
        end
    end,
    
    ["FormatTimeSimple"] = function(sec)
        if not sec or sec <= 0 then return "ready" end
        local h = math.floor(sec / 3600)
        local m = math.floor((sec - h * 3600) / 60)
        if h > 0 then
            return string.format("%dh %dm", h, m)
        else
            return string.format("%dm", m)
        end
    end,
    
    -- Command Responses
    ["Sounds enabled"] = "Sounds enabled",
    ["Sounds disabled"] = "Sounds disabled",
    ["Set sound for"] = "Set sound for",
    ["Sound volume set to"] = "Sound volume set to",
    ["toastMode set to"] = "toastMode set to",
    ["Ignored"] = "Ignored",
    ["Unignored"] = "Unignored",
    
    -- Command Usage Help
    ["Usage: /rallysound set <EVENT> <path>"] = "Usage: /rallysound set <EVENT> <path>",
    ["Usage: /rallysound volume <0-100>"] = "Usage: /rallysound volume <0-100>",
    ["Usage: /rallytoast chat|ui|none"] = "Usage: /rallytoast chat|ui|none",
    ["Usage: /rallyignore add|remove|list <name>"] = "Usage: /rallyignore add|remove|list <name>",
    ["Commands: on, off, set <EVENT> <path>, volume <0-100>"] = "Commands: on, off, set <EVENT> <path>, volume <0-100>",
    
    -- Status Messages
    ["Realm:"] = "Realm:",
    ["Faction filter set to"] = "Faction filter set to",
    ["Failed to insert text into chat edit box."] = "Failed to insert text into chat edit box.",
    
    -- Debug/System Messages
    ["Channel mismatch, ignoring"] = "Channel mismatch, ignoring",
    ["Empty message"] = "Empty message",
    ["RallyHelper message accepted for parsing!"] = "RallyHelper message accepted for parsing!",
    ["Parsed → ev="] = "Parsed → ev=",
    ["ts="] = "ts=",
    ["sender="] = "sender=",
    ["Ignoring sender"] = "Ignoring sender",
    ["Accepted and UI updated:"] = "Accepted and UI updated:",
    ["Accepted TIMER_"] = "Accepted TIMER_",
    ["and UI updated"] = "and UI updated",
    ["Rejected TIMER_"] = "Rejected TIMER_",
    ["by IsSuspicious"] = "by IsSuspicious",
    ["Accepted fresh event directly:"] = "Accepted fresh event directly:",
    ["RAW"] = "RAW",
    ["Channel='"] = "Channel='",
    ["Msg start='"] = "Msg start='",
    ["Clean"] = "Clean",
    ["clean='"] = "clean='",
    ["expected='"] = "expected='",
    ["Debug"] = "Debug",
    
    -- Minimap Button Tooltips
    ["Left Click: Toggle UI"] = "Left Click: Toggle UI",
    ["Alt+Click: Settings"] = "Alt+Click: Settings",
    ["Shift+Click: Share timers"] = "Shift+Click: Share timers",
    ["Middle Click: Unconfirmed"] = "Middle Click: Unconfirmed",
    ["Right Click: Status"] = "Right Click: Status",
    ["Alt+Drag: Move button"] = "Alt+Drag: Move button",
    
    -- Timer Display Text
    ["Ony SW:"] = "Ony SW:",
    ["Ony OG:"] = "Ony OG:",
    ["Nef SW:"] = "Nef SW:",
    ["Nef OG:"] = "Nef OG:",
    ["ZG last drop:"] = "ZG last drop:",
    ["DMF:"] = "DMF:",
    
    -- First Time Setup
    ["First Time Setup"] = "First Time Setup",
    ["Select your faction filter:"] = "Select your faction filter:",
    ["This determines which buff timers are shown."] = "This determines which buff timers are shown.",
    ["You can change this later in settings."] = "You can change this later in settings.",
}