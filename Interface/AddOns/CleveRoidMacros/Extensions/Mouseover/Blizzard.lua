--[[
	Author: Fondlez

    This extension adds improved support for mouseover macros in Roid-Macros
    for the default Blizzard frames.
]]
local _G = _G or getfenv(0)
local CleveRoids = _G.CleveRoids or {}
CleveRoids.mouseoverUnit = CleveRoids.mouseoverUnit or nil

local Extension = CleveRoids.RegisterExtension("Blizzard")

function Extension.RegisterMouseoverForFrame(frame, unit)
    if not frame then return end

    local onenter = frame:GetScript("OnEnter")
    local onleave = frame:GetScript("OnLeave")

    frame:SetScript("OnEnter", function()
        CleveRoids.mouseoverUnit = unit
        if onenter then
            onenter()
        end
    end)

    frame:SetScript("OnLeave", function()
        CleveRoids.mouseoverUnit = nil
        if onleave then
            onleave()
        end
    end)
end

do
    local frames = {
        ["PlayerFrame"] = "player",
        ["PetFrame"] = "pet",
        ["TargetFrame"] = "target",
        ["PartyMemberFrame1"] = "party1",
        ["PartyMemberFrame2"] = "party2",
        ["PartyMemberFrame3"] = "party3",
        ["PartyMemberFrame4"] = "party4",
        ["PartyMemberFrame1PetFrame"] = "partypet1", -- 修复 by 武藤纯子酱 2025.8.8
        ["PartyMemberFrame2PetFrame"] = "partypet2", -- 修复 by 武藤纯子酱 2025.8.8
        ["PartyMemberFrame3PetFrame"] = "partypet3", -- 修复 by 武藤纯子酱 2025.8.8
        ["PartyMemberFrame4PetFrame"] = "partypet4", -- 修复 by 武藤纯子酱 2025.8.8
    }

    local bars = {
        "HealthBar",
        "ManaBar",
    }

    local allFrames = {}
    for name, unit in pairs(frames) do
         allFrames[name] = unit
        for i, bar in ipairs(bars) do
            allFrames[name .. bar] = unit
        end
    end

    -- Inconsisent naming for TargetofTarget required
    allFrames["TargetofTargetFrame"] = "targettarget"
    allFrames["TargetofTargetHealthBar"] = "targettarget"
    allFrames["TargetofTargetManaBar"] = "targettarget"

    function Extension.OnLoad()
        local frame
        for name, unit in pairs(allFrames) do
          frame = _G[name]

          if frame then
              Extension.RegisterMouseoverForFrame(frame, unit)
          end
       end
    end
end
