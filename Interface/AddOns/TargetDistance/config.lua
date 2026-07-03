local function capitalize_first_letter(s)
  if s == nil or s == "" then
    return s
  end

  -- 将首字母转换为大写
  local first_char = string.upper(string.sub(s, 1, 1))

  -- 如果字符串只有一个字符，直接返回大写的字符
  if string.len(s) == 1 then
    return first_char
  end

  -- 否则，将首字母与剩余的字符串（小写）连接起来
  local rest_of_string = string.lower(string.sub(s, 2))
  return first_char .. rest_of_string
end

local mainFrame = CreateFrame("Frame", "TargetDistanceMainFrame", UIParent)
mainFrame:SetHeight(600)
mainFrame:SetWidth(420)
mainFrame:SetPoint("CENTER", UIParent, "CENTER")

mainFrame.Bdr = mainFrame:CreateTexture(nil, "BACKGROUND")
mainFrame.Bdr:SetPoint("CENTER", mainFrame, "CENTER")
mainFrame.Bdr:SetTexture(0.15, 0.6, 0.15, 0.5)
mainFrame.Bdr:SetWidth(mainFrame:GetWidth() + 2)
mainFrame.Bdr:SetHeight(mainFrame:GetHeight() + 2)

mainFrame.Bg = mainFrame:CreateTexture(nil, "ARTWORK")
mainFrame.Bg:SetAllPoints(mainFrame)
mainFrame.Bg:SetTexture(0, 0, 0, 0.75)

mainFrame.titleFrame = CreateFrame("Frame", "TargetDistanceConfigTitleFrame", mainFrame)
mainFrame.titleFrame:SetHeight(32)
mainFrame.titleFrame:SetWidth(mainFrame:GetWidth() - 20)
mainFrame.titleFrame:SetPoint("TOP", mainFrame, "TOP", 0, -10)
mainFrame.titleFrame:SetFrameLevel(21)
mainFrame.titleFrame.bg = mainFrame.titleFrame:CreateTexture(nil, 'BACKGROUND')
mainFrame.titleFrame.bg:SetTexture(0, 1, 0, 0.25)
mainFrame.titleFrame.bg:SetAllPoints(mainFrame.titleFrame)
mainFrame.titleFrame.title = mainFrame.titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.titleFrame.title:SetText("TargetDistance - 显示目标距离")
mainFrame.titleFrame.title:SetFont(GameFontNormal:GetFont(), 12)
mainFrame.titleFrame.title:SetPoint("TOP", mainFrame.titleFrame, "TOP", 0, -3)
mainFrame.titleFrame.subtitle = mainFrame.titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.titleFrame.subtitle:SetText("需加载unitXp模组后才能生效")
mainFrame.titleFrame.subtitle:SetFont(GameFontNormal:GetFont(), 10)
mainFrame.titleFrame.subtitle:SetPoint("TOP", mainFrame.titleFrame, "TOP", 0, -18)
mainFrame.titleFrame.version = mainFrame.titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.titleFrame.version:SetText(GetAddOnMetadata("TargetDistance", "Version"))
mainFrame.titleFrame.version:SetFont(GameFontNormal:GetFont(), 12)
mainFrame.titleFrame.version:SetPoint("TOPRIGHT", mainFrame.titleFrame, "TOPRIGHT", -5, -3)

mainFrame:SetClampedToScreen(true)
mainFrame:SetFrameLevel(20)
mainFrame:EnableMouse(1)
mainFrame:SetMovable(1)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function()
  this:StartMoving()
end)
mainFrame:SetScript("OnDragStop", function()
  this:StopMovingOrSizing()
  local _, _, _, x, y = this:GetPoint()
  local xx = x - mainFrame:GetWidth() / 2
  local yy = y - mainFrame:GetHeight() / 2
  mainFrame:SetPoint("CENTER", WorldFrame, "CENTER", xx, yy)
end)

mainFrame.closeBtn = CreateFrame("Button", "TargetDistanceConfigFrameCloseButton", mainFrame, "UIPanelCloseButton")
mainFrame.closeBtn:SetScript("OnClick", function()
  mainFrame:Hide();
end)
mainFrame.closeBtn:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 30, 8)
mainFrame:Hide()

local contentFrame = CreateFrame("Frame", mainFrame, mainFrame)
contentFrame:SetHeight(mainFrame:GetHeight() - 52)
contentFrame:SetWidth(mainFrame:GetWidth())
contentFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, -42)

local scrollFrame = CreateFrame("ScrollFrame", "TargetDistanceScrollFrame", contentFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetAllPoints()

local config = CreateFrame("Frame", "TargetDistanceConfigFrame", scrollFrame)
config:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, 0)
config:SetHeight(contentFrame:GetHeight())
config:SetWidth(contentFrame:GetWidth())
-- config:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT")
-- config:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT")

local scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]
scrollFrame:SetScrollChild(config)
scrollBar:SetScript("OnValueChanged", function()
  config:SetPoint("TOPLEFT", 0, this:GetValue())
end)

local top = -20

local function updateConfigFrameHeight()
  config:SetHeight(-top)
  local maxValue = config:GetHeight() - scrollFrame:GetHeight()
  scrollBar:SetMinMaxValues(0, maxValue)
end
TargetDistance.configItemsMap = {}
local createConfigCheck = function(name, text, hook, offsetX, nowrap)
  local cb = CreateFrame("CheckButton", config:GetName() .. "Check" .. name, config, "OptionsCheckButtonTemplate")
  -- cb:SetFrameLevel(21)
  cb.oname = name
  cb.setVal = function(checked)
    cb:SetChecked(checked)
  end

  cb:SetChecked(TargetDistanceCharDB[name])
  getglobal(cb:GetName() .. "Text"):SetText(text)
  cb:SetScript("OnClick", function(a, b)
    local checked = cb:GetChecked() ~= nil
    TargetDistanceCharDB[name] = checked
    if type(hook) == "function" then
      hook(checked)
    end
  end)

  if not offsetX then offsetX = 10 end
  cb:SetPoint("TOPLEFT", config, "TOPLEFT", offsetX, top)
  if not nowrap then
    top = top - 30
  end
  TargetDistance.configItemsMap[name] = cb
  return cb
end

local createConfigText = function(name, text, hook, offsetX, nowrap)
  local namePascal = capitalize_first_letter(name)
  local tb = CreateFrame("EditBox", config:GetName() .. "Edit" .. namePascal, config, 'InputBoxTemplate')
  tb:SetHeight(20)
  tb:SetWidth(100)
  tb:SetAutoFocus(nil)
  tb.label = config:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  tb.label:SetText(text)
  tb:SetText(TargetDistanceCharDB[name])
  local h = function()
    if type(hook) == "function" then
      hook(tb:GetText(), tb)
    end
  end
  tb:SetScript("OnEnterPressed", h)
  tb:SetScript("OnEditFocusLost", h)
  tb.setVal = function(value)
    tb:SetText(value)
  end

  if not offsetX then offsetX = 10 end
  tb.label:SetPoint("TOPLEFT", config, "TOPLEFT", offsetX, top)
  if not nowrap then
    top = top - 30
  end
  tb:SetPoint("LEFT", tb.label, "RIGHT", 10, 0)
  TargetDistance.configItemsMap[name] = tb
  return tb
end

local createConfigRadioGroup = function(name, text, options, cols, hook)
  if not cols then cols = 2 end
  local cbWidth = math.floor((config:GetWidth() - 20) / cols)
  local namePascal = capitalize_first_letter(name)
  local label = config:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label.oname = name
  label:SetText(text)
  label:SetPoint("TOPLEFT", config, "TOPLEFT", 10, top)
  top = top - 20

  label.cbs = {}
  for i, option in ipairs(options) do
    local cb = CreateFrame("CheckButton", config:GetName() .. "Check" .. namePascal .. i, config,
      "OptionsCheckButtonTemplate")
    -- cb:SetFrameLevel(21)
    getglobal(cb:GetName() .. "Text"):SetText(option.text)
    cb.ovalue = option.value
    local colNum = i - math.floor(i / cols) * cols
    local x = 10 + cbWidth * colNum - 1

    cb:SetPoint("TOPLEFT", config, "TOPLEFT", x, top)
    cb:SetScript("OnClick", function()
      TargetDistanceCharDB[name] = cb.ovalue
      label.setVal(cb.ovalue)
      if type(hook) == "function" then
        hook(cb.ovalue)
      end
    end)

    if colNum == cols then
      top = top - 24
    end
    table.insert(label.cbs, cb)
  end
  label.setVal = function(value)
    for _, cb in label.cbs do
      cb:SetChecked(cb.ovalue == value)
    end
  end
  label.setVal(TargetDistanceCharDB[name])
  TargetDistance.configItemsMap[name] = label

  top = top - 30

  return label
end

local function createConfigColor(name, text, hook, offsetX, nowrap)
  local value = TargetDistanceCharDB[name]
  local namePascal = capitalize_first_letter(name)
  local colorBtn = CreateFrame("Button", config:GetName() .. "Color" .. namePascal, config)
  colorBtn.text = colorBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  colorBtn.text:SetText(text)
  colorBtn.text:SetWidth(80)
  colorBtn.text:SetJustifyH("RIGHT")
  colorBtn.text:SetPoint("LEFT", colorBtn)
  colorBtn:SetWidth(100)
  colorBtn:SetHeight(30)
  colorBtn.texture = colorBtn:CreateTexture(nil, "BACKGROUND")
  colorBtn.texture:SetTexture(unpack(value))
  colorBtn.texture:SetWidth(16)
  colorBtn.texture:SetHeight(16)
  colorBtn.texture:SetPoint("RIGHT", colorBtn)

  colorBtn:SetScript("OnClick", function()
    ColorPickerFrame.func = function()
      local newR, newG, newB = ColorPickerFrame:GetColorRGB();
      TargetDistanceCharDB[name] = { newR, newG, newB }
      colorBtn.texture:SetTexture(unpack(TargetDistanceCharDB[name]))
      if type(hook) == 'function' then
        hook({ newR, newG, newB })
      end
    end;
    ColorPickerFrame.hasOpacity = nil;
    ColorPickerFrame.opacityFunc = nil;
    ColorPickerFrame.opacity = nil;
    ColorPickerFrame:SetColorRGB(unpack(TargetDistanceCharDB[name]));
    ColorPickerFrame.previousValues = TargetDistanceCharDB[name];

    ColorPickerFrame.cancelFunc = function(previousValues)
      if previousValues and table.getn(previousValues) > 2 then
        TargetDistanceCharDB[name] = previousValues
        colorBtn.texture:SetTexture(unpack(previousValues))
        if type(hook) == 'function' then
          hook(unpack(previousValues))
        end
      end
    end;
    -- ColorPickerFrame:SetPoint(HbbConfigFrame)
    ShowUIPanel(ColorPickerFrame);
  end)
  colorBtn:SetPoint("TOPLEFT", config, "TOPLEFT", offsetX, top)
  if not nowrap then
    top = top - 30
  end
  colorBtn.setVal = function(v)
    colorBtn.texture:SetTexture(unpack(v))
  end

  TargetDistance.configItemsMap[name] = colorBtn
  return colorBtn
end

local function createConfigSlider(name, text, minValue, maxValue, step, hook, offsetX, nowrap)
  local namePascal = capitalize_first_letter(name)

  local slider = CreateFrame("Slider", config:GetName() .. "Slider" .. namePascal, config, 'OptionsSliderTemplate')
  slider:SetMinMaxValues(minValue, maxValue)
  slider:SetValueStep(step)
  slider:SetWidth(150)
  getglobal(slider:GetName() .. 'Low'):Hide()
  getglobal(slider:GetName() .. 'High'):Hide()

  slider.label = config:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  slider.label:SetPoint("TOPLEFT", config, "TOPLEFT", offsetX, top)
  slider.label:SetText(text)
  local v = TargetDistanceCharDB[name]
  slider:SetValue(v)
  slider.vlabel = config:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  slider.vlabel:SetText(v)
  slider:SetPoint("TOPLEFT", config, "TOPLEFT", offsetX, top - 20)
  slider.vlabel:SetPoint("TOPRIGHT", slider, "TOPRIGHT", 0, 20)
  slider:SetScript("OnValueChanged", function()
    slider.vlabel:SetText(this:GetValue())
    TargetDistanceCharDB[name] = tonumber(this:GetValue())
    if type(hook) == "function" then
      hook(this:GetValue())
    end
  end)
  if not nowrap then
    top = top - 50
  end
end

local userColorIndex = 1
local function createUserColor(options, offsetX)
  local tbName = config:GetName() .. "UserColorYardsEdit" .. userColorIndex
  options.tbName = tbName
  local tb = CreateFrame("EditBox", tbName, config,
    'InputBoxTemplate')
  tb:SetHeight(20)
  tb:SetWidth(40)
  tb:SetAutoFocus(nil)
  tb:SetJustifyH("CENTER")
  local labelName = config:GetName() .. "UserColorLabel" .. userColorIndex
  options.labelName = labelName
  tb.label = config:CreateFontString(labelName, "OVERLAY", "GameFontNormal")
  tb.label:SetText("距离 < ")
  tb:SetText(""..options.yards)
  local h = function()
    if tonumber(tb:GetText()) == nil then
      tb:SetText(""..options.yards)
    else
      options.yards = tonumber(tb:GetText())
    end
  end
  tb:SetScript("OnEnterPressed", h)
  tb:SetScript("OnEditFocusLost", h)
  tb:SetScript("OnTabPressed", function()
    local chars, index = string.match(tbName, '^(.+)(%d+)$')
    if IsShiftKeyDown() then
      local prevTextbox = _G[chars..(index - 1)]
      if prevTextbox then
        prevTextbox:SetFocus()
      else
        tb:ClearFocus()
      end
    else
      local nextTextbox = _G[chars..(index + 1)]
      if nextTextbox then
        nextTextbox:SetFocus()
      else
        tb:ClearFocus()
      end
    end
  end)

  if not offsetX then offsetX = 60 end
  tb.label:SetPoint("TOPLEFT", config, "TOPLEFT", offsetX, top)
  tb:SetPoint("LEFT", tb.label, "RIGHT", 10, 0)

  local value = options.colors
  options.colorBtnName = config:GetName() .. "UserColorButton" .. userColorIndex
  local colorBtn = CreateFrame("Button", options.colorBtnName, config)
  colorBtn:SetWidth(16)
  colorBtn:SetHeight(16)
  colorBtn.texture = colorBtn:CreateTexture(nil, "BACKGROUND")
  colorBtn.texture:SetTexture(unpack(value))
  -- colorBtn.texture:SetWidth(16)
  -- colorBtn.texture:SetHeight(16)
  -- colorBtn.texture:SetPoint("RIGHT", colorBtn)
  colorBtn.texture:SetAllPoints(colorBtn)

  colorBtn:SetScript("OnClick", function()
    ColorPickerFrame.func = function()
      local newR, newG, newB = ColorPickerFrame:GetColorRGB();
      options.colors = { newR, newG, newB }
      colorBtn.texture:SetTexture(unpack(options.colors))
    end;
    ColorPickerFrame.hasOpacity = nil;
    ColorPickerFrame.opacityFunc = nil;
    ColorPickerFrame.opacity = nil;
    ColorPickerFrame:SetColorRGB(unpack(options.colors));
    ColorPickerFrame.previousValues = options.colors;

    ColorPickerFrame.cancelFunc = function(previousValues)
      if previousValues and table.getn(previousValues) > 2 then
        options.colors = previousValues
        colorBtn.texture:SetTexture(unpack(previousValues))
      end
    end;
    -- ColorPickerFrame:SetPoint(HbbConfigFrame)
    ShowUIPanel(ColorPickerFrame);
  end)
  colorBtn:SetPoint("LEFT", tb, "RIGHT", 10, 0)
  userColorIndex = userColorIndex + 1

  top = top - 30
  updateConfigFrameHeight()
end

local function initUserColors()
  if not TargetDistanceCharDB.userColors then
    TargetDistanceCharDB.userColors = {}
  end

  for i, userColor in ipairs(TargetDistanceCharDB.userColors) do
    createUserColor(userColor)
  end
end

local function initConfig()
  table.insert(UISpecialFrames, "TargetDistanceMainFrame")
  createConfigCheck("locked", "锁定", function(value) TargetDistance.toggleLocked(value) end)
  createConfigCheck("hidden", "隐藏", function(value) TargetDistance.toggleHidden(value) end)
  createConfigCheck("showDeadDistance", "死亡目标距离", function(value) TargetDistance.toggleShowDeadDistance(value) end)
  createConfigCheck("desc", "详细信息", function(value) TargetDistance.toggleDesc(value) end)

  top = top - 10
  createConfigColor("fontColor", "文字颜色", nil, 10, 1)
  createConfigSlider("fontSize", "文字大小", 9, 22, 1, function(value)
    TargetDistance.setFontSize(value)
  end, 160)
  -- 如果是猎人职业
  if TargetDistance.unitClass == "猎人" then
    createConfigRadioGroup('pp', "玩家与宠物距离", {
      { text = "关闭", value = 1 },
      { text = "常驻", value = 2 },
      { text = "仅野兽之眼", value = 3 },
    }, 3)
    createConfigColor("fontColorPp", "文字颜色", nil, 10, 1)
    createConfigSlider("fontSizePp", "文字大小", 9, 22, 1, function(value)
      TargetDistance.setFontSizePp(value)
    end, 160)
  end
  -- x
  top = top - 10
  createConfigText("offsetX", "X轴位置", function(value, tb)
    if tonumber(value) then
      TargetDistanceCharDB.offsetX = tonumber(value)
      TargetDistance.refreshFramePoint()
    else
      tb.setVal(math.floor(TargetDistanceCharDB.offsetX + 0.5))
    end
  end, nil, 1)
  -- y
  createConfigText("offsetY", "Y轴位置", function(value, tb)
    if tonumber(value) then
      TargetDistanceCharDB.offsetY = tonumber(value)
      TargetDistance.refreshFramePoint()
    else
      tb.setVal(math.floor(TargetDistanceCharDB.offsetY + 0.5))
    end
  end, 200)

  -- 是否线性变色
  createConfigCheck("linearColor", "文字线性变色", function(checked)
    if checked == true then
      TargetDistanceCharDB.rangedColor = false
      TargetDistance.configItemsMap.rangedColor.setVal(false)
    end
  end, 10)
  -- 线性变色的距离
  createConfigText("linearYardsFrom", "从", function(value, tb)
    if tonumber(value) then
      TargetDistanceCharDB.linearYardsFrom = tonumber(value)
    else
      tb.setVal(math.floor(TargetDistanceCharDB.linearYardsFrom + 0.1))
    end
  end, nil, 1)
  createConfigText("linearYardsTo", "到", function(value, tb)
    if tonumber(value) then
      TargetDistanceCharDB.linearYardsTo = tonumber(value)
    else
      tb.setVal(math.floor(TargetDistanceCharDB.linearYardsTo + 0.1))
    end
  end, 200)
  top = top + 12
  -- 线性变色的2个颜色
  createConfigColor("linearColorFrom", "变色从(近)", nil, 10, 1)
  createConfigColor("linearColorTo", "变色到(远)", nil, 200)
  top = top - 20
  createConfigColor("faceColor", "打脸", nil, 10)
  top = top - 20
  createConfigCheck("rangedColor", "文字区间变色", function(checked)
    if checked == true then
      TargetDistanceCharDB.linearColor = false
      TargetDistance.configItemsMap.linearColor.setVal(false)
    end
  end, 10)
  createConfigColor("rangedColor1", "近战", nil, 10, 1)

  local aBtn = CreateFrame("Button", config:GetName() .. "AddUserColorButton", config)
  aBtn:SetWidth(40)
  aBtn:SetHeight(20)
  aBtn:SetPoint("TOPRIGHT", config, "TOPRIGHT", -80, top)
  aBtn:SetScript("OnClick", function()
    local newUserColor = { yards = 5, colors = { 1, 1, 1 } }
    if TargetDistanceCharDB.userColors and table.getn(TargetDistanceCharDB.userColors) > 0 then
      local lastUserColor = TargetDistanceCharDB.userColors[table.getn(TargetDistanceCharDB.userColors)]
      -- 最小5码，应该没有必要更小了
      newUserColor.yards = (lastUserColor.yards or 4) + 1
    end
    table.insert(TargetDistanceCharDB.userColors, newUserColor)
    createUserColor(newUserColor)
  end)
  aBtn.text = aBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  aBtn.text:SetText("增加")
  aBtn.text:SetPoint("CENTER", aBtn, "CENTER")

  local rBtn = CreateFrame("Button", config:GetName() .. "RemoveUserColorButton", config)
  rBtn:SetWidth(40)
  rBtn:SetHeight(20)
  rBtn:SetPoint("TOPRIGHT", config, "TOPRIGHT", -20, top)
  rBtn:SetScript("OnClick", function()
    if TargetDistanceCharDB.userColors and table.getn(TargetDistanceCharDB.userColors) > 0 then
      local userColor = table.remove(TargetDistanceCharDB.userColors)
      _G[userColor.colorBtnName]:Hide()
      _G[userColor.colorBtnName]:SetParent(nil)
      _G[userColor.colorBtnName] = nil

      _G[userColor.tbName]:Hide()
      _G[userColor.tbName]:SetParent(nil)
      _G[userColor.tbName] = nil

      _G[userColor.labelName]:Hide()
      _G[userColor.labelName]:SetParent(nil)
      _G[userColor.labelName] = nil

      top = top + 30
      updateConfigFrameHeight()
    end
  end)
  rBtn.text = rBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  rBtn.text:SetText("移除")
  rBtn.text:SetPoint("CENTER", rBtn, "CENTER")
  top = top - 40
  local info = config:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  info:SetText("自上而下距离从小到大设置")
  info:SetPoint("TOPLEFT", config, "TOPLEFT", 60, top)
  top = top - 30

  initUserColors()
  -- createConfigColor("rangedColor2", "<8码", nil, 130, 1)
  -- createConfigColor("rangedColor3", "8-15码", nil, 250)
  -- createConfigColor("rangedColor4", "15-20码", nil, 10, 1)
  -- createConfigColor("rangedColor5", "20-30码", nil, 130, 1)
  -- createConfigColor("rangedColor6", "30-35码", nil, 250)
  -- createConfigColor("rangedColor7", "35-41码", nil, 10, 1)
  -- createConfigColor("rangedColor8", "41-120码", nil, 130, 1)
  -- createConfigColor("rangedColor9", "120码以上", nil, 250)

  config.init = 1
  updateConfigFrameHeight()
end

local minimapButton = CreateFrame("Button", "TargetDistanceMinimapButton", Minimap)
minimapButton:SetPoint("BOTTOM", Minimap, "BOTTOM", -50, 25)
minimapButton:EnableMouse(true)
minimapButton:SetMovable(true)
minimapButton:SetToplevel(true)
minimapButton:SetWidth(33)
minimapButton:SetHeight(33)
minimapButton.iconTexture = minimapButton:CreateTexture(nil, "BACKGROUND")
minimapButton.iconTexture:SetTexture("Interface\\Icons\\Ability_Hunter_EagleEye")
minimapButton.iconTexture:SetWidth(18)
minimapButton.iconTexture:SetHeight(18)
minimapButton.iconTexture:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 7, -5)

minimapButton.borderTexture = minimapButton:CreateTexture(nil, "OVERLAY")
minimapButton.borderTexture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
minimapButton.borderTexture:SetWidth(52)
minimapButton.borderTexture:SetHeight(52)
minimapButton.borderTexture:SetPoint("TOPLEFT", minimapButton, "TOPLEFT")

minimapButton.hltexture = minimapButton:SetHighlightTexture(
  "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnClick", function()
  if not TargetDistance.loaded then
    TargetDistance.addonmsg("UnitXP模组未加载，插件无法启用")
    return
  end
  if mainFrame:IsVisible() then
    mainFrame:Hide()
  else
    if not config.init then
      initConfig()
    end
    for k, v in pairs(TargetDistance.defaults) do
      if TargetDistance.configItemsMap[k] and TargetDistance.configItemsMap[k].setVal then
        TargetDistance.configItemsMap[k].setVal(TargetDistanceCharDB[k])
      end
    end
    mainFrame:Show()
  end
end)
minimapButton:SetScript("OnEnter", function()
  GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
  GameTooltip:SetText(GetAddOnMetadata("TargetDistance", "Title"));
end)
minimapButton:SetScript("OnLeave", function()
  GameTooltip:Hide();
end)
minimapButton:SetScript("OnDragStart", function()
  minimapButton:StartMoving()
  minimapButton.isMoving = true
end)
minimapButton:SetScript("OnDragStop", function()
  minimapButton:StopMovingOrSizing()
  minimapButton.isMoving = false
end)

minimapButton:Show()
