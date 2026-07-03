-- RallyHelper Localization System
-- Loads appropriate language files based on game client locale

local L = {}

-- Default English strings (fallback)
L["ONY"] = "Onyxia"
L["NEF"] = "Nefarian"
L["WB"] = "World Buff"
L["ZG"] = "ZG"
L["DMF"] = "Darkmoon Faire"
L["HORDE"] = "Horde"
L["ALLIANCE"] = "Alliance"
L["BOTH"] = "Both"
L["Stormwind"] = "Stormwind"
L["Orgrimmar"] = "Orgrimmar"
L["SW"] = "SW"
L["OG"] = "OG"
L["RallyHelper"] = "RallyHelper"
L["World Buff Timer Tracker for Turtle WoW"] = "World Buff Timer Tracker for Turtle WoW"
L["Welcome!"] = "Welcome!"
L["Settings"] = "Settings"
L["Faction Filter:"] = "Faction Filter:"
L["Current:"] = "Current:"
L["Lock UI Position"] = "Lock UI Position"
L["Enable Buff Sounds"] = "Enable Buff Sounds"
L["Width"] = "Width"
L["Height"] = "Height"
L["Scale"] = "Scale"
L["Close"] = "Close"
L["ready"] = "ready"
L["unknown"] = "unknown"
L["confirmed"] = "confirmed"
L["last drop:"] = "last drop:"
L["in"] = "in"
L["h"] = "h"
L["m"] = "m"
L["s"] = "s"
L["Sounds enabled"] = "Sounds enabled"
L["Sounds disabled"] = "Sounds disabled"
L["Set sound for"] = "Set sound for"
L["Sound volume set to"] = "Sound volume set to"
L["toastMode set to"] = "toastMode set to"
L["Ignored"] = "Ignored"
L["Unignored"] = "Unignored"
L["Usage: /rallysound set <EVENT> <path>"] = "Usage: /rallysound set <EVENT> <path>"
L["Usage: /rallysound volume <0-100>"] = "Usage: /rallysound volume <0-100>"
L["Usage: /rallytoast chat|ui|none"] = "Usage: /rallytoast chat|ui|none"
L["Usage: /rallyignore add|remove|list <name>"] = "Usage: /rallyignore add|remove|list <name>"
L["Commands: on, off, set <EVENT> <path>, volume <0-100>"] = "Commands: on, off, set <EVENT> <path>, volume <0-100>"
L["Realm:"] = "Realm:"
L["Faction filter set to"] = "Faction filter set to"
L["Failed to insert text into chat edit box."] = "Failed to insert text into chat edit box."

-- Helper function to load locale files
local function LoadLocale()
    local locale = GetLocale()
    
    -- Try to load the appropriate locale file
    if locale == "zhTW" then
        -- Load Traditional Chinese
        if pcall(function()
            local zhTW = loadfile("Interface\\AddOns\\RallyHelper\\locales\\zhTW.lua")
            if zhTW then
                zhTW()
                if RallyHelper_Locale and RallyHelper_Locale["zhTW"] then
                    for k, v in pairs(RallyHelper_Locale["zhTW"]) do
                        if type(v) == "function" then
                            L[k] = v
                        else
                            L[k] = v
                        end
                    end
                end
            end
        end) then
            -- Successfully loaded Traditional Chinese
            return
        end
    end
    
    -- Fallback to English
    if pcall(function()
        local enUS = loadfile("Interface\\AddOns\\RallyHelper\\locales\\enUS.lua")
        if enUS then
            enUS()
            if RallyHelper_Locale and RallyHelper_Locale["enUS"] then
                for k, v in pairs(RallyHelper_Locale["enUS"]) do
                    if type(v) == "function" then
                        L[k] = v
                    else
                        L[k] = v
                    end
                end
            end
        end
    end) then
        -- Successfully loaded English
        return
    end
    
    -- If no locale files loaded, keep default English strings
end

-- Load locale on startup
LoadLocale()

-- Localization helper functions
function L.FormatTime(sec)
    if L["FormatTime"] and type(L["FormatTime"]) == "function" then
        return L["FormatTime"](sec)
    end
    -- Fallback implementation
    if not sec or sec <= 0 then return L["ready"], 0 end
    local h = math.floor(sec / 3600)
    local m = math.floor((sec - h * 3600) / 60)
    local s = sec - h * 3600 - m * 60
    if h > 0 then
        return string.format("%d%s %d%s", h, L["h"], m, L["m"]), sec
    elseif m > 0 then
        return string.format("%d%s %d%s", m, L["m"], s, L["s"]), sec
    else
        return string.format("%d%s", s, L["s"]), sec
    end
end

function L.FormatAgo(timestamp)
    if L["FormatAgo"] and type(L["FormatAgo"]) == "function" then
        return L["FormatAgo"](timestamp)
    end
    -- Fallback implementation
    local now = time()
    local diff = now - timestamp
    if diff < 60 then
        return string.format("%d%s", diff, L["s"])
    elseif diff < 3600 then
        local m = math.floor(diff / 60)
        return string.format("%d%s", m, L["m"])
    else
        local h = math.floor(diff / 3600)
        local m = math.floor((diff - h * 3600) / 60)
        return string.format("%d%s %d%s", h, L["h"], m, L["m"])
    end
end

function L.FormatTimeSimple(sec)
    if L["FormatTimeSimple"] and type(L["FormatTimeSimple"]) == "function" then
        return L["FormatTimeSimple"](sec)
    end
    -- Fallback implementation
    if not sec or sec <= 0 then return L["ready"] end
    local h = math.floor(sec / 3600)
    local m = math.floor((sec - h * 3600) / 60)
    if h > 0 then
        return string.format("%d%s %d%s", h, L["h"], m, L["m"])
    else
        return string.format("%d%s", m, L["m"])
    end
end

-- Export to global namespace
RallyHelper_L = L