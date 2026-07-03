local pont = 0.000
local pofft = 0.000
local ont = 0.000
local offt = 0.000
local ons = 0.000
local offs = 0.000
local offh = 0
local onh = 0
local eons = 0.000
local eoffs = 0.000

if not AttackBarDB then AttackBarDB = {} end

-- 打印消息到聊天框
local function AbarPrint(text)
  DEFAULT_CHAT_FRAME:AddMessage("|CFFFFFF00AttackBar:|r "..text)
end

-- 重置计时条位置
local function ResetBarPoint()
  local tdfactionbar = 0
  local anchor = 80
  anchor = MultiBarBottomLeft:IsVisible() and 100 or anchor
  anchor = MultiBarBottomRight:IsVisible() and 120 or anchor
  local pet_offset = PetActionBarFrame:IsVisible() and 50 or 0
  local shift_offset = ShapeshiftBarFrame:IsVisible() and 50 or 0

  Abar_Frame:ClearAllPoints()
  Abar_Frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, anchor + 10 + pet_offset + shift_offset + tdfactionbar + 20)
  ebar_Frame:ClearAllPoints()
  ebar_Frame:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 0, 20)
end

-- 初始化玩家计时条
local function abar_VL()
  Abar_Mhr:SetPoint("LEFT", Abar_Frame, "TOPLEFT", 6, -13)
  Abar_Oh:SetPoint("LEFT", Abar_Frame, "TOPLEFT", 6, -35)
  Abar_MhrText:SetJustifyH("Left")
  Abar_MhrTmr:SetJustifyH("Left")
  Abar_OhText:SetJustifyH("Left")
  Abar_OhTmr:SetJustifyH("Left")
end

-- 初始化敌人计时条
local function ebar_VL()
  ebar_mh:SetPoint("LEFT", ebar_Frame, "TOPLEFT", 6, -13)
  ebar_oh:SetPoint("LEFT", ebar_Frame, "TOPLEFT", 6, -35)
  ebar_mhText:SetJustifyH("Left")
  ebar_mhTmr:SetJustifyH("Left")
  ebar_ohText:SetJustifyH("Left")
  ebar_ohTmr:SetJustifyH("Left")
end

-- 加载时初始化
function Abar_loaded()
  SlashCmdList["ATKBAR"] = Abar_chat
  SLASH_ATKBAR1 = "/abar"
  SLASH_ATKBAR2 = "/atkbar"

  -- 初始化设置
  if AttackBarDB.range == nil then AttackBarDB.range = true end
  if AttackBarDB.melee == nil then AttackBarDB.melee = true end
  if AttackBarDB.timer == nil then AttackBarDB.timer = true end
  if AttackBarDB.mob == nil then AttackBarDB.mob = true end
  if AttackBarDB.pvp == nil then AttackBarDB.pvp = true end
  if AttackBarDB.r == nil then AttackBarDB.r = 0 end
  if AttackBarDB.g == nil then AttackBarDB.g = 1 end
  if AttackBarDB.b == nil then AttackBarDB.b = 1 end

  if not AttackBarDB.initload then
    ResetBarPoint()
  end

  ebar_VL()
  abar_VL()

  -- 初始化进度条
  local barframes = { Abar_Mhr, Abar_Oh, ebar_mh, ebar_oh }
  for _, bar in pairs(barframes) do
    local bartext = getglobal(bar:GetName() .. "Text")
    local bartmr = getglobal(bar:GetName() .. "Tmr")
    bartext:ClearAllPoints()
    bartmr:ClearAllPoints()
    bartext:SetPoint("LEFT", bar, "LEFT", 0, 12)
    bartmr:SetPoint("RIGHT", bar, "RIGHT", 0, 12)
    bartext:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
    bartmr:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
    bar:SetStatusBarTexture([[Interface\AddOns\!MrBCat\texture\bar.tga]])
  end
end

-- 处理聊天命令
function Abar_chat(msg)
  msg = strlower(msg)
  if msg == "fix" then
    AbarPrint('计时条计时时间已重置')
    Abar_reset()
  elseif msg == "lock" then
    Abar_Frame:Hide()
    ebar_Frame:Hide()
    AttackBarDB.initload = true
    AbarPrint('窗体已锁定')
  elseif msg == "unlock" then
    Abar_Frame:Show()
    ebar_Frame:Show()
    AbarPrint('窗体已解锁，鼠标左键拖动到合适位置')
  elseif msg == "reset" then
    AttackBarDB.initload = nil
    ResetBarPoint()
    AbarPrint('位置已重置')
  elseif msg == "range" then
    AttackBarDB.range = not AttackBarDB.range
    AbarPrint('远程攻击计时 ' .. Abar_Boo(AttackBarDB.range))
  elseif msg == "melee" then
    AttackBarDB.melee = not AttackBarDB.melee
    AbarPrint('近战攻击计时 ' .. Abar_Boo(AttackBarDB.melee))
  elseif msg == "timer" then
    AttackBarDB.timer = not AttackBarDB.timer
    AbarPrint('计时器 ' .. Abar_Boo(AttackBarDB.timer))
  elseif msg == "pvp" then
    AttackBarDB.pvp = not AttackBarDB.pvp
    AbarPrint('PVP计时 ' .. Abar_Boo(AttackBarDB.pvp))
  elseif msg == "mob" then
    AttackBarDB.mob = not AttackBarDB.mob
    AbarPrint('怪物计时 ' .. Abar_Boo(AttackBarDB.mob))
  elseif msg == "color" then
    ColorPickerFrame:SetColorRGB(AttackBarDB.r, AttackBarDB.g, AttackBarDB.b)
    ColorPickerFrame.hasOpacity = nil
    ColorPickerFrame.previousValues = { AttackBarDB.r, AttackBarDB.g, AttackBarDB.b, 1 }
    ColorPickerFrame.func = changeBarColor
    ColorPickerFrame.cancelFunc = changeBarColor
    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
  else
    AbarPrint('攻击计时设置:')
    AbarPrint('lock - 锁定位置')
    AbarPrint('unlock - 解锁位置')
    AbarPrint('reset - 重置位置')
    AbarPrint('fix - 重置计时（离开战斗5秒后）')
    AbarPrint('melee - 开启/关闭近战攻击计时')
    AbarPrint('range - 开启/关闭远程攻击计时')
    AbarPrint('pvp - 开启/关闭敌对攻击计时')
    AbarPrint('color - 更改计时条颜色(r,g,b)')
  end
end

-- 重置计时
function Abar_reset()
  pont = 0.000
  pofft = 0.000
  ont = 0.000
  offt = 0.000
end

-- 事件处理
function Abar_event(event)
  if (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_SELF_HITS") and AttackBarDB.melee then
    Abar_selfhit(arg1)
  end
  if event == "PLAYER_LEAVE_COMBAT" then Abar_reset() end
  if event == "VARIABLES_LOADED" then Abar_loaded() end
  if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then Abar_spellhit(arg1) end
  if event == "UNIT_SPELLCAST_SENT" then abar_spelldir(arg2) end
end

-- 更改计时条颜色
function changeBarColor(restore)
  if not restore then
    AttackBarDB.r, AttackBarDB.g, AttackBarDB.b = ColorPickerFrame:GetColorRGB()
  end
end

-- 玩家近战攻击命中处理
function Abar_meleeHit()
  ons, offs = UnitAttackSpeed("player")
  local tons
  if offs then
    ont, offt = GetTime(), GetTime()
    if ((math.abs((ont - pont) - ons) <= math.abs((offt - pofft) - offs)) and not (onh <= offs / ons)) or offh >= ons / offs then
      if pofft == 0 then pofft = offt end
      pont = ont
      tons = ons
      offh = 0
      onh = onh + 1
      ons = ons - math.mod(ons, 0.01)
      Abar_Mhrs(tons, "主手", AttackBarDB.r, AttackBarDB.g, AttackBarDB.b)
    else
      pofft = offt
      offh = offh + 1
      onh = 0
      offs = offs - math.mod(offs, 0.01)
      Abar_Ohs(offs, "副手", AttackBarDB.r, AttackBarDB.g, AttackBarDB.b)
    end
  else
    ont = GetTime()
    tons = ons
    ons = ons - math.mod(ons, 0.01)
    Abar_Mhrs(tons, "主手", AttackBarDB.r, AttackBarDB.g, AttackBarDB.b)
  end
end

-- 玩家自身命中处理
function Abar_selfhit(arg1)
  if string.find(arg1, "掉落") or string.find(arg1, "你受到") then return end

  local spell
  if string.find(arg1, "你的(.+)对") or string.find(arg1, "你的(.+)没有击中") or string.find(arg1, "你的(.+)击中") or string.find(arg1, "你的(.+)被") then
    spell = string.match(arg1, "你的(.+)对") or string.match(arg1, "你的(.+)没有击中") or string.match(arg1, "你的(.+)击中") or string.match(arg1, "你的(.+)被")
  elseif string.find(arg1, "Your (.+) hits") or string.find(arg1, "Your (.+) crits") or string.find(arg1, "Your (.+) is") or string.find(arg1, "Your (.+) misses") then
    spell = string.match(arg1, "Your (.+) hits") or string.match(arg1, "Your (.+) crits") or string.match(arg1, "Your (.+) is") or string.match(arg1, "Your (.+) misses")
  end

  if spell then
    Abar_spellhit(spell)
  else
    Abar_meleeHit()
  end
end

-- 玩家法术命中处理
function Abar_spellhit(arg1)
  local spell = string.match(arg1, "你的(.+)对") or string.match(arg1, "你的(.+)没有击中") or string.match(arg1, "你的(.+)击中") or string.match(arg1, "你的(.+)被") or arg1
  local rs, rhd, rld = UnitRangedDamage("player")
  rs = rs - 0.65
  local trs

  if spell == "自动射击" or spell == "Auto Shot" and AttackBarDB.range then
    trs = rs
    rs = rs - math.mod(rs, 0.01)
    Abar_Mhrs(trs, "自动射击", 0, 1, 0)
  elseif spell == "射击" or spell == "弓射击" or spell == "枪械射击" or spell == "Shoot" and AttackBarDB.range then
    trs = rs
    rs = rs - math.mod(rs, 0.01)
    Abar_Mhrs(trs, "远程", .7, .1, 1)
  elseif (spell == "猛禽一击" or spell == "英勇打击" or spell == "槌击" or spell == "顺劈斩" or spell == "神圣打击" or spell == "Raptor Strike" or spell == "Heroic Strike" or spell == "Maul" or spell == "Cleave" or spell == "Slam" or spell == "Holy Strike") and AttackBarDB.melee then
    Abar_meleeHit()
  end
end

-- 玩家法术方向处理
function abar_spelldir(spellname)
  if AttackBarDB.range then
    local sparse = string.match(spellname, "(.+)%(")
    if sparse then spellname = sparse end
    local rs, rhd, rld = UnitRangedDamage("player")
    local trs

    if spellname == "投掷" or spellname == "Throw" then
      trs = rs
      rs = rs - math.mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "投掷 [" .. (rs) .. "s]", 1, .5, 0)
    elseif spellname == "Shoot" or spellname == "射击" then
      rs = UnitRangedDamage("player")
      trs = rs
      rs = rs - math.mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "魔杖 [" .. (rs) .. "s]", .5, 0, 1)
    elseif spellname == "弓射击" or spellname == "Shoot Bow" then
      trs = rs
      rs = rs - math.mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "弓 [" .. (rs) .. "s]", 1, .5, 0)
    elseif spellname == "枪械射击" or spellname == "Shoot Gun" then
      trs = rs
      rs = rs - math.mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "枪 [" .. (rs) .. "s]", 1, .5, 0)
    elseif spellname == "弩射击" or spellname == "Shoot Crossbow" then
      trs = rs
      rs = rs - math.mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "弩 [" .. (rs) .. "s]", 1, .5, 0)
    elseif spellname == "瞄准射击" or spellname == "Aimed Shot" then
      trs = rs
      rs = rs - math.mod(rs, 0.01)
      Abar_Mhrs(trs - 1, "瞄准 [" .. (3) .. "s]", 1, .1, .1)
    end
  end
end

-- 更新计时条
function Abar_Update()
  local ttime = GetTime()
  local left = 0.0
  local tSpark = getglobal(this:GetName().. "Spark")
  local tText = getglobal(this:GetName().. "Tmr")
  local tbtime = " / "..this.bt

  if AttackBarDB.timer then
    left = (this.et - GetTime()) - (math.mod((this.et - GetTime()),.01))
    left = math.floor(left * 10) / 10
    tText:SetText(left..tbtime)
    tText:Show()
  else
    tText:Hide()
  end

  local progress = (ttime - this.st) / (this.et - this.st)
  this:SetValue(progress)
  tSpark:SetPoint("CENTER", this, "LEFT", progress * 200, 0)

  if ttime >= this.et then
    this:Hide()
    tSpark:SetPoint("CENTER", this, "LEFT", 200, 0)
  end
end

-- 设置主手计时条
function Abar_Mhrs(bartime, text, r, g, b)
  Abar_Mhr:Hide()
  Abar_Mhr.txt = text
  Abar_Mhr.st = GetTime()
  Abar_Mhr.bt = Round(bartime,2)
  Abar_Mhr.et = GetTime() + bartime
  Abar_Mhr:SetStatusBarColor(r, g, b)
  Abar_MhrText:SetText(text)
  Abar_Mhr:SetMinMaxValues(0, 1)
  Abar_Mhr:SetValue(0)
  Abar_Mhr:Show()
end

-- 设置副手计时条
function Abar_Ohs(bartime, text, r, g, b)
  Abar_Oh:Hide()
  Abar_Oh.txt = text
  Abar_Oh.st = GetTime()
  Abar_Oh.bt = Round(bartime,2)
  Abar_Oh.et = GetTime() + bartime
  Abar_Oh:SetStatusBarColor(r, g, b)
  Abar_OhText:SetText(text)
  Abar_Oh:SetMinMaxValues(Abar_Oh.st, Abar_Oh.et)
  Abar_Oh:SetValue(Abar_Oh.st)
  Abar_Oh:Show()
end

-- 返回开关状态
function Abar_Boo(inpt)
  return inpt and "ON" or "OFF"
end

-- 敌人计时条事件处理
function ebar_event(event)
  if not AttackBarDB.pvp then return end
  if event == "VARIABLES_LOADED" then
    ebar_VL()
  end
  if (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" or event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES") and AttackBarDB.mob then
    ebar_start(arg1)
  elseif (event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES") and AttackBarDB.pvp then
    ebar_start(arg1)
  end
end

-- 敌人计时条开始
function ebar_start(arg1)
  local hitter = string.match(arg1, "(.+)击中你") or string.match(arg1, "(.+)的致命一击对你") or string.match(arg1, "(.+)没有击中你") or string.match(arg1, "(.+)发起了攻击。你") or string.match(arg1, "(.+) hits you") or string.match(arg1, "(.+) crits you") or string.match(arg1, "(.+) misses you") or string.match(arg1, "(.+) attacks. You ")
  if hitter == UnitName("target") then ebar_set(hitter) end
end

-- 设置敌人计时条
function ebar_set(targ)
  eons, eoffs = UnitAttackSpeed("target")
  eons = eons - math.mod(eons, 0.01)
  ebar_mhs(eons, "目标", 1, .1, .1)
end

-- 设置敌人主手计时条
function ebar_mhs(bartime, text, r, g, b)
  ebar_mh:Hide()
  ebar_mh.txt = text
  ebar_mh.bt = Round(bartime,2)
  ebar_mh.st = GetTime()
  ebar_mh.et = GetTime() + bartime
  ebar_mh:SetStatusBarColor(r, g, b)
  ebar_mhText:SetText(text)
  ebar_mh:SetMinMaxValues(ebar_mh.st, ebar_mh.et)
  ebar_mh:SetValue(ebar_mh.st)
  ebar_mh:Show()
end

-- 设置敌人副手计时条
function ebar_ohs(bartime, text, r, g, b)
  ebar_oh:Hide()
  ebar_oh.txt = text
  ebar_oh.bt = Round(bartime,2)
  ebar_oh.st = GetTime()
  ebar_oh.et = GetTime() + bartime
  ebar_oh:SetStatusBarColor(r, g, b)
  ebar_ohText:SetText(text)
  ebar_oh:SetMinMaxValues(ebar_oh.st, ebar_oh.et)
  ebar_oh:SetValue(ebar_oh.st)
  ebar_oh:Show()
end

-- 钩子函数，确保UI位置正确
hooksecurefunc("UIParent_ManageFramePositions", function()
  if not AttackBarDB.initload then
    ResetBarPoint()
  end
end, true)