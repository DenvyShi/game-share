TargetDistanceCharDB = TargetDistanceCharDB or {}
local defaults = {
  offsetX = 0,
  offsetY = 200,
  locked = false,
  desc = true,
  showDeadDistance = false,
  pp = 1, -- player <--> pet
  hidden = false,
  linearYardsFrom = 8,
  linearYardsTo = 42,
  linearColor = true,
  linearColorFrom = { 0, 1, 0 },
  linearColorTo = { 1, 0, 0 },
  faceColor = { 1, 0, 0.5 },
  meleeColor = { 0, 1, 0 },
  blinkColor = { 1, 1, 0 },
  fontSize = 21,
  fontSizePp = 16,
  fontColor = { 0, 1, 0 },
  fontColorPp = { 0, 1, 0 },
  rangedColor = false,
  rangedColor1 = { 1, 0, 0 }, -- 近战
  userColors = {}
}

-- TargetDistanceCharDB.offsetX = TargetDistanceCharDB.offsetX or 0
-- TargetDistanceCharDB.offsetY = TargetDistanceCharDB.offsetY or 200
-- if TargetDistanceCharDB.locked == nil then
--   TargetDistanceCharDB.locked = false
-- end
-- if TargetDistanceCharDB.desc == nil then
--   TargetDistanceCharDB.desc = true
-- end
-- if TargetDistanceCharDB.showDeadDistance == nil then
--   TargetDistanceCharDB.showDeadDistance = false
-- end
-- if TargetDistanceCharDB.pp == nil then
--   TargetDistanceCharDB.pp = 1
-- end

local cantload = nil

local addonmsg = function(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00目标距离 " .. msg)
end

local function toggleDesc(v, notify)
  local newValue = v
  if v == nil then
    newValue = not TargetDistanceCharDB.desc
  end
  if newValue then
    TargetDistanceCharDB.desc = true
    if notify then
      addonmsg("详细信息已开启")
    end
  else
    TargetDistanceCharDB.desc = false
    if notify then
      addonmsg("详细信息已关闭")
    end
  end
end

local function toggleShowDeadDistance(v, notify)
  local newValue = v
  if v == nil then
    newValue = not TargetDistanceCharDB.showDeadDistance
  end
  if newValue then
    TargetDistanceCharDB.showDeadDistance = true
    if notify then
      addonmsg("死亡目标距离显示已开启")
    end
  else
    TargetDistanceCharDB.showDeadDistance = false
    if notify then
      addonmsg("死亡目标距离显示已关闭")
    end
  end
end

local function togglePlayerPet()
  local values = { "关闭", "常驻", "仅野兽之眼" }
  local v = (TargetDistanceCharDB.pp or 0) + 1
  if v > table.getn(values) then
    v = 1
  end
  TargetDistanceCharDB.pp = v
  addonmsg("人宠距离显示已设置为 >" .. values[TargetDistanceCharDB.pp] .. "<")
end

-- 创建一个事件框架
local frame = CreateFrame("Frame", "TargetDistanceFrame", UIParent)
frame:SetWidth(70)
frame:SetHeight(20)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
local distanceText = frame:CreateFontString(nil, "OVERLAY")
distanceText:SetFont(STANDARD_TEXT_FONT, defaults.fontSize, "OUTLINE")
distanceText:SetPoint("CENTER", frame, "CENTER", 0, 0)
distanceText:SetJustifyH("CENTER")
distanceText:SetWidth(100)
frame.distanceText = distanceText
-- distanceText:SetTextColor(1, 1, 1)
-- distanceText:SetText("distanceText")
local distanceText2 = frame:CreateFontString(nil, "OVERLAY")
distanceText2:SetFont(STANDARD_TEXT_FONT, defaults.fontSizePp, "OUTLINE")
distanceText2:SetPoint("TOP", distanceText, "BOTTOM", 0, -4)
distanceText2:SetJustifyH("CENTER")
distanceText2:SetWidth(150)
frame.distanceText2 = distanceText2

local unit = "player"
local unitxpok = nil
local unitClass = UnitClass("player")
local eotbactive = function()
  for i = 1, 32 do
    local t = UnitBuff("player", i)
    if not t then break end
    if t == "Interface\\Icons\\Ability_EyeOfTheOwl" then
      return 1
    end
  end
end

local function fmtDistance(distance, decimals)
  if not distance or tonumber(distance) == nil then return "" end

  if not decimals then
    decimals = 1
  end

  return string.format("%." .. decimals .. "f", distance)
end

local function setTextColorLinear(fontString, distance)
  if not distance then return end

  local db = TargetDistanceCharDB
  local r, g, b
  if distance < db.linearYardsFrom then
    distance = db.linearYardsFrom
  elseif distance > db.linearYardsTo then
    distance = db.linearYardsTo
  end

  local p = (distance - db.linearYardsFrom) / (db.linearYardsTo - db.linearYardsFrom)
  r = db.linearColorFrom[1] + (db.linearColorTo[1] - db.linearColorFrom[1]) * p
  g = db.linearColorFrom[2] + (db.linearColorTo[2] - db.linearColorFrom[2]) * p
  b = db.linearColorFrom[3] + (db.linearColorTo[3] - db.linearColorFrom[3]) * p

  -- local red = distance / maxDistance
  -- local green = 1 - red
  -- 设置文字颜色
  fontString:SetTextColor(r, g, b)
end

local function setTextColor(fontString, distance, melee, defaultColor)
  if not distance then return end
  if TargetDistanceCharDB.linearColor and TargetDistanceCharDB.linearYardsFrom and TargetDistanceCharDB.linearYardsTo then
    setTextColorLinear(fontString, distance)
  elseif TargetDistanceCharDB.rangedColor then
    -- 自定义区间变色
    local colors = { 1, 1, 1 } -- 如果都匹配不到则显示白色

    if melee then
      colors = TargetDistanceCharDB.rangedColor1
    else
      for _, userColor in ipairs(TargetDistanceCharDB.userColors) do
        if userColor.yards and distance < userColor.yards then
          colors = userColor.colors
          break
        end
      end
    end

    fontString:SetTextColor(unpack(colors))
  else
    if not defaultColor then
      defaultColor = { 0, 1, 0 }
    end
    fontString:SetTextColor(unpack(defaultColor))
  end
end

-- 根据距离值设置文字内容和颜色的方法
local function SetDistanceText()
  local text
  if not UnitExists("target") or UnitIsUnit(unit, "target") then
    text = ""
  else
    if unitxpok == nil then
      unitxpok = 1
    end

    if (UnitHealth("target") or 0) == 0 and TargetDistanceCharDB.showDeadDistance == false then
      text = ""
    else
      local distance = UnitXP("distanceBetween", unit, "target");
      unitxpok = 2
      if not distance then
        text = ""
      else
        if distance == 0 then
          text = "0"
        else
          local fDistance = fmtDistance(distance, 1) -- math.floor(distance * 10 + 0.5) / 10

          -- 避免显示0.0
          text = fDistance
        end
        if distance >= 8 or not TargetDistanceCharDB.desc or not UnitCanAttack(unit, "target") or (UnitHealth("target") or 0) == 0 then
          -- 计算红色和绿色的分量，实现线性渐变
          -- local red = distance / 42
          -- local green = 1 - red
          -- -- 设置文字颜色
          -- distanceText:SetTextColor(red, green, 0)
          setTextColor(distanceText, distance, nil, TargetDistanceCharDB.fontColor)
        else
          local meleeDistance = UnitXP("distanceBetween", unit, "target", "meleeAutoAttack")
          if meleeDistance == 0 then
            local behind = UnitXP("behind", unit, "target")

            if behind then
              text = "近战\n" .. text
              setTextColor(distanceText, distance, true, TargetDistanceCharDB.fontColor)
            else
              text = "打脸\n" .. text
              distanceText:SetTextColor(unpack(TargetDistanceCharDB["faceColor"]))
            end
          else
            if unitClass == "猎人" then
              text = "盲区\n" .. text
            end
            setTextColor(distanceText, distance, nil, TargetDistanceCharDB.fontColor)
          end
        end
      end
    end
  end

  distanceText:SetText(text)
  distanceText2:SetText("")

  if unitClass == "猎人" or string.lower(unitClass) == "hunter" then
    if UnitExists("pet") and (TargetDistanceCharDB.pp == 2 or (unit == "pet" and TargetDistanceCharDB.pp == 3)) then
      if not (unit == "pet" and UnitIsUnit("target", "player")) and not (unit == "player" and UnitIsUnit("target", "pet")) then
        local ppDistance = fmtDistance(UnitXP("distanceBetween", "player", "pet"))
        if ppDistance and ppDistance ~= "" then
          distanceText2:SetText(ppDistance)
          setTextColor(distanceText2, tonumber(ppDistance), nil, TargetDistanceCharDB.fontColorPp)
        end
      end
    end
  end
end

-- OnUpdate 事件处理函数
local function OnUpdate()
  -- if unitxpok == 1 then frame:SetScript("OnUpdate", nil) return end
  SetDistanceText()
end

-- 拖拽开始时的处理函数
local function OnDragStart()
  this:StartMoving()
end

-- 拖拽结束时的处理函数
local function OnDragStop()
  this:StopMovingOrSizing()
  local centerX, centerY = UIParent:GetCenter()
  local frameX, frameY = this:GetCenter()
  TargetDistanceCharDB.offsetX = frameX - centerX
  TargetDistanceCharDB.offsetY = frameY - centerY
end

local function toggleLocked(locked, notify)
  local newLocked = not TargetDistanceCharDB.locked
  if locked ~= nil then
    newLocked = locked
  end

  if newLocked == true then
    -- 禁止拖拽
    TargetDistanceCharDB.locked = true
    frame:EnableMouse(false)
    frame:RegisterForDrag()
    if notify then
      addonmsg("已锁定")
    end
  else
    if TargetDistanceCharDB.hidden then
      if TargetDistance.configItemsMap.hidden then
        TargetDistance.configItemsMap.hidden.setVal(false)
      end
      TargetDistance.toggleHidden(false)
    end
    -- 允许拖拽
    TargetDistanceCharDB.locked = false
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    if notify then
      addonmsg("已解锁")
    end
  end
end

local function toggleHidden(hidden)
  local newHidden = not TargetDistanceCharDB.hidden
  if hidden ~= nil then
    newHidden = hidden
  end

  TargetDistanceCharDB.hidden = newHidden
  if newHidden == true then
    frame:Hide()
  else
    frame:Show()
  end
end

local function refreshFramePoint()
  frame:ClearAllPoints()
  frame:SetPoint("CENTER", UIParent, "CENTER", TargetDistanceCharDB.offsetX, TargetDistanceCharDB.offsetY)
end

local function OnEvent()
  if event == "ADDON_LOADED" and arg1 == "TargetDistance" then
    local r1, r2 = pcall(UnitXP, "nop", "nop")
    if r1 ~= true or r2 ~= true then
      addonmsg("无法加载，因：UnitXP_SP3.dll未加载")
      cantload = 1
      frame:Hide()
      return
    end

    for k, v in pairs(defaults) do
      if TargetDistanceCharDB[k] == nil then
        TargetDistanceCharDB[k] = defaults[k]
      end
    end

    -- 设置框架位置
    frame:SetPoint("CENTER", UIParent, "CENTER", TargetDistanceCharDB.offsetX, TargetDistanceCharDB.offsetY)
    toggleLocked(TargetDistanceCharDB.locked)
    TargetDistance.setFontSize(TargetDistanceCharDB.fontSize)
    TargetDistance.setFontSizePp(TargetDistanceCharDB.fontSizePp)

    frame:SetScript("OnUpdate", OnUpdate)
    frame:SetScript("OnDragStart", OnDragStart)
    frame:SetScript("OnDragStop", OnDragStop)

    SlashCmdList["TARGETDISTANCE"] = function(s)
      local command, option = string.match(s, "^(%S*)%s*(.-)$")
      if command ~= nil then
        command = string.lower(command)
      end
      if option ~= nil then
        option = string.lower(option)
      end

      if command == "unlock" then
        toggleLocked(false, 1)
      elseif command == "lock" then
        toggleLocked(true, 1)
      elseif command == "x" then
        if tonumber(option) ~= nil then
          TargetDistanceCharDB.offsetX = tonumber(option)
          refreshFramePoint()
          addonmsg("已设置x为距离屏幕中心" .. option)
        end
      elseif command == "y" then
        if tonumber(option) ~= nil then
          TargetDistanceCharDB.offsetY = tonumber(option)
          refreshFramePoint()
          addonmsg("已设置y为距离屏幕中心" .. option)
        end
      elseif command == "show" then
        toggleHidden(true)
      elseif command == "hide" then
        toggleHidden(false)
      elseif command == "desc" then
        toggleDesc(nil, 1)
      elseif command == "dead" then
        toggleShowDeadDistance(nil, 1)
      elseif command == "pp" then
        togglePlayerPet()
      elseif command == "option" then
        if _G["TargetDistanceMinimapButton"] then
          _G["TargetDistanceMinimapButton"]:Click()
        end
      end
    end

    SLASH_TARGETDISTANCE1 = "/tdistance"
    SLASH_TARGETDISTANCE2 = "/tdis"

    addonmsg("|cff00ff00目标距离|r 已加载。使用 /tdistance lock 或 /tdistance unlock 来锁定或解锁目标距离显示框。")
    TargetDistance.loaded = 1
  elseif event == "UNIT_AURA" and arg1 == "player" then
    if cantload then return end
    if eotbactive() then
      unit = "pet"
    else
      unit = "player"
    end
  end
end

frame:RegisterEvent("ADDON_LOADED")
if unitClass == "猎人" or string.lower(unitClass) == "hunter" then
  frame:RegisterEvent("UNIT_AURA")
end
frame:SetScript("OnEvent", OnEvent)

TargetDistance = {}
TargetDistance.loaded = nil
TargetDistance.defaults = defaults
TargetDistance.unitClass = unitClass
TargetDistance.addonmsg = addonmsg
TargetDistance.toggleLocked = toggleLocked
TargetDistance.toggleHidden = toggleHidden
TargetDistance.refreshFramePoint = refreshFramePoint
TargetDistance.toggleShowDeadDistance = toggleShowDeadDistance
TargetDistance.toggleDesc = toggleDesc
TargetDistance.setFontSize = function(fontSize)
  distanceText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
end
TargetDistance.setFontSizePp = function(fontSize)
  distanceText2:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
end
local triggers = {}
TargetDistance.addTrigger = function(name, f)
  if not triggers[name] then
    triggers[name] = {}
  end

  table.insert(triggers[name], f)
end
TargetDistance.setProp = function(name, value)
  TargetDistanceCharDB[name] = value
  if triggers[name] then
    for _, f in ipairs(triggers[name]) do
      triggers[name](value)
    end
  end
end
