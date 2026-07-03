--[[
	Author: Dennis Werner Garske (DWG) / brian / Mewtiny
	License: MIT License
]]
local _G = _G or getfenv(0)
local CleveRoids = _G.CleveRoids or {}

SLASH_PETATTACK1 = "/petattack"

SlashCmdList.PETATTACK = function(msg) CleveRoids.DoPetAction(PetAttack, msg); end

SLASH_PETFOLLOW1 = "/petfollow"

SlashCmdList.PETFOLLOW = function(msg) CleveRoids.DoPetAction(PetFollow, msg); end

SLASH_PETWAIT1 = "/petwait"

SlashCmdList.PETWAIT = function(msg) CleveRoids.DoPetAction(PetWait, msg); end

SLASH_PETPASSIVE1 = "/petpassive"

SlashCmdList.PETPASSIVE = function(msg) CleveRoids.DoPetAction(PetPassiveMode, msg); end

SLASH_PETAGGRESSIVE1 = "/petaggressive"

SlashCmdList.PETAGGRESSIVE = function(msg) CleveRoids.DoPetAction(PetAggressiveMode, msg); end

SLASH_PETDEFENSIVE1 = "/petdefensive"

SlashCmdList.PETDEFENSIVE = function(msg) CleveRoids.DoPetAction(PetDefensiveMode, msg); end

SLASH_RELOAD1 = "/rl"

SlashCmdList.RELOAD = function() ReloadUI(); end

-- 安全执行宏的函数 by 武藤纯子酱 2025.8.11
local function SafeRunMacro(macroType, msg)
    local action = function(args)
        -- 在条件处理前检查调用栈
        local stackSize = table.getn(CleveRoids.MacroStack)
        local currentMacro = stackSize > 0 and CleveRoids.MacroStack[stackSize] or nil
        if currentMacro and currentMacro == args then
            CleveRoids.Print("警告: 宏不能直接调用自身")
            return false
        end
        
        -- 检查调用栈深度
        if stackSize >= CleveRoids.MaxMacroDepth then
            CleveRoids.Print("警告: 宏调用深度超过限制 ("..CleveRoids.MaxMacroDepth..")")
            return false
        end
        
        if macroType == "macro" then
            return CleveRoids.ExecuteMacroByName(args)
        else
            return RunSuperMacro(args)
        end
    end
    
    if string.find(msg, "%[") then
        return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, action)
    else
        return action(msg)
    end
end

--新增 by 武藤纯子酱 2025.8.6
SLASH_PETSTAY1 = "/petstay"
SlashCmdList.PETSTAY = function(msg) CleveRoids.DoPetAction(PetWait, msg); end

SLASH_CASTRANDOM1 = "/castrandom"
function SlashCmdList.CASTRANDOM(msg)
    if not msg then return end
    
    local action = function(args)
        if not args or args == "" then return end
        
        local tbl = strsplit(args, ",")
        local spell = tbl[math.random(1,getn(tbl))]
        while strsub(spell,1,1) == " " do
            spell = strsub(spell,2)
        end
        while strsub(spell,strlen(spell)) == " " do
            spell = strsub(spell, 1, (strlen(spell)-1))
        end
        CastSpellByName(spell)
    end
    
    if string.find(msg, "%[") then
        CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, action)
    else
        action(msg)
    end
end

SLASH_CANCELFORM1 = "/cancelform"
SlashCmdList.CANCELFORM = CleveRoids.DoUnshift

SLASH_CLEARTARGET1 = "/cleartarget"
function SlashCmdList.CLEARTARGET(msg)
    if not msg or msg == "" then
        ClearTarget()
    else
        CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, ClearTarget)
    end
end

SLASH_SWITCH1 = "/switch"
SlashCmdList.SWITCH = function(msg)
    local action = function()
        PickupInventoryItem(16)
        PickupInventoryItem(17)
    end
    
    if not msg or msg == "" then
        action()
    else
        CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, action)
    end
end

SLASH_EQUIPSLOT1 = "/equipslot"
SlashCmdList.EQUIPSLOT = CleveRoids.DoEquipSlot


SLASH_ASSIST1 = "/assist"
SlashCmdList.ASSIST = function(msg) CleveRoids.DoAssist(msg) end
 
SLASH_TARGETENEMY1 = "/targetenemy"
SlashCmdList.TARGETENEMY = function(msg) CleveRoids.DoTargetEnemy(msg) end
 
SLASH_TARGETENEMYPLAYER1 = "/targetenemyplayer"
SlashCmdList.TARGETENEMYPLAYER = function(msg) CleveRoids.DoTargetEnemyPlayer(msg) end
 
SLASH_TARGETFRIEND1 = "/targetfriend"
SlashCmdList.TARGETFRIEND = function(msg) CleveRoids.DoTargetFriend(msg) end
 
SLASH_TARGETFRIENDPLAYER1 = "/targetfriendplayer"
SlashCmdList.TARGETFRIENDPLAYER = function(msg) CleveRoids.DoTargetFriendPlayer(msg) end
 
SLASH_TARGETLASTENEMY1 = "/targetlastenemy"
SlashCmdList.TARGETLASTENEMY = function(msg) CleveRoids.DoTargetLastEnemy(msg) end
 
SLASH_TARGETLASTFRIEND1 = "/targetlastfriend"
SlashCmdList.TARGETLASTFRIEND = function(msg) CleveRoids.DoTargetLastFriend(msg) end
 
SLASH_TARGETLASTTARGET1 = "/targetlasttarget"
SLASH_TARGETLASTTARGET2 = "/lasttarget"
SlashCmdList.TARGETLASTTARGET = function(msg) CleveRoids.DoTargetLastTarget(msg) end
 
SLASH_TARGETPARTY1 = "/targetparty"
SlashCmdList.TARGETPARTY = function(msg) CleveRoids.DoTargetParty(msg) end
 
SLASH_TARGETRAID1 = "/targetraid"
SlashCmdList.TARGETRAID = function(msg) CleveRoids.DoTargetRaid(msg) end

SLASH_TARGETEXACT1 = "/targetexact"
SlashCmdList.TARGETEXACT = function(msg)
    CleveRoids.DoTargetExact(msg)
end

SLASH_PETAUTOCASTOFF1 = "/petautocastoff"
SlashCmdList.PETAUTOCASTOFF = function(msg) CleveRoids.DoPetAutoCastOff(msg) end
 
SLASH_PETAUTOCASTON1 = "/petautocaston"
SlashCmdList.PETAUTOCASTON = function(msg) CleveRoids.DoPetAutoCastOn(msg) end
 
SLASH_PETAUTOCASTTOGGLE1 = "/petautocasttoggle"
SlashCmdList.PETAUTOCASTTOGGLE = function(msg) CleveRoids.DoPetAutoCastToggle(msg) end

SLASH_MOUNT1 = "/mount"
SlashCmdList.MOUNT = function(msg) CleveRoids.DoMount(msg) end
 
SLASH_DISMOUNT1 = "/dismount"
SlashCmdList.DISMOUNT = function(msg) CleveRoids.DoDismount(msg) end

SLASH_CHANGEACTIONBAR1 = "/changeactionbar"
SlashCmdList.CHANGEACTIONBAR = function(msg)
    CleveRoids.DoChangeActionBar(msg)
end

SLASH_SWAPACTIONBAR1 = "/swapactionbar"
SlashCmdList.SWAPACTIONBAR = function(msg)
    CleveRoids.DoSwapActionBar(msg)
end

SLASH_USERNADOM1 = "/userandom"
function SlashCmdList.USERNADOM(msg)
    if not msg then return end
    
    local action = function(args)
        if not args or args == "" then return end
        
        local items = strsplit(args, ",")
        local item = items[math.random(1,getn(items))]
        while strsub(item,1,1) == " " do
            item = strsub(item,2)
        end
        while strsub(item,strlen(item)) == " " do
            item = strsub(item, 1, (strlen(item)-1))
        end
        CleveRoids.DoUse(item)
    end
    
    if string.find(msg, "%[") then
        CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, action)
    else
        action(msg)
    end
end

SLASH_FEED1 = "/feed"
SlashCmdList.FEED = function(msg)
    CleveRoids.DoFeed(msg)
end

SLASH_RUNSUPERMACRO1 = "/runsupermacro"
function SlashCmdList.RUNSUPERMACRO(msg)
    if not msg then return end
    return SafeRunMacro("supermacro", msg)
end
--以上为新增 by 武藤纯子酱 2025.8.6

SLASH_USE1 = "/use"

SlashCmdList.USE = CleveRoids.DoUse

SLASH_EQUIP1 = "/equip"

SlashCmdList.EQUIP = CleveRoids.DoUse
-- take back supermacro and pfUI /equip
SlashCmdList.SMEQUIP = CleveRoids.DoUse
SlashCmdList.PFEQUIP = CleveRoids.DoUse

SLASH_EQUIPMH1 = "/equipmh"
SlashCmdList.EQUIPMH = CleveRoids.DoEquipMainhand

SLASH_EQUIPOH1 = "/equipoh"
SlashCmdList.EQUIPOH = CleveRoids.DoEquipOffhand

SLASH_UNSHIFT1 = "/unshift"
SlashCmdList.UNSHIFT = CleveRoids.DoUnshift

SLASH_UNQUEUE1 = "/unqueue"
SlashCmdList.UNQUEUE = SpellStopCasting

-- TODO make this conditional too
SLASH_CANCELAURA1 = "/cancelaura"
SLASH_CANCELAURA2 = "/unbuff"

SlashCmdList.CANCELAURA = CleveRoids.DoConditionalCancelAura

-- Define original implementations before hooking them.
-- This ensures we have a fallback for non-conditional use.
local StartAttack = function(msg)
    if not UnitExists("target") or UnitIsDead("target") then TargetNearestEnemy() end
    if not CleveRoids.CurrentSpell.autoAttack and not CleveRoids.CurrentSpell.autoAttackLock and UnitExists("target") and UnitCanAttack("player","target") then
        CleveRoids.CurrentSpell.autoAttackLock = true
        CleveRoids.autoAttackLockElapsed = GetTime()
        AttackTarget()
    end
end

local StopAttack = function(msg)
    if CleveRoids.CurrentSpell.autoAttack and UnitExists("target") then
        AttackTarget()
        CleveRoids.CurrentSpell.autoAttack = false
    end
end

-- Register slash commands and assign original handlers.
-- These will be hooked immediately after.
SLASH_STARTATTACK1 = "/startattack"
SlashCmdList.STARTATTACK = StartAttack

SLASH_STOPATTACK1 = "/stopattack"
SlashCmdList.STOPATTACK = StopAttack

SLASH_STOPCASTING1 = "/stopcasting"
SlashCmdList.STOPCASTING = SpellStopCasting

----------------------------------
-- HOOK DEFINITIONS START
----------------------------------

-- /startattack hook
CleveRoids.Hooks.STARTATTACK_SlashCmd = SlashCmdList.STARTATTACK
SlashCmdList.STARTATTACK = function(msg)
    msg = msg or ""
    if string.find(msg, "%[") then
        CleveRoids.DoConditionalStartAttack(msg)
    else
        CleveRoids.Hooks.STARTATTACK_SlashCmd(msg)
    end
end

-- /stopattack hook
CleveRoids.Hooks.STOPATTACK_SlashCmd = SlashCmdList.STOPATTACK
SlashCmdList.STOPATTACK = function(msg)
    msg = msg or ""
    if string.find(msg, "%[") then
        -- If conditionals are present, let the function handle it.
        -- It will only stop the attack if the conditions are met.
        CleveRoids.DoConditionalStopAttack(msg)
    else
        -- If no conditionals, run the original command.
        CleveRoids.Hooks.STOPATTACK_SlashCmd(msg)
    end
end

-- /stopcasting hook
CleveRoids.Hooks.STOPCASTING_SlashCmd = SlashCmdList.STOPCASTING
SlashCmdList.STOPCASTING = function(msg)
    msg = msg or ""
    if string.find(msg, "%[") then
        -- If conditionals are present, let the function handle it.
        -- It will only stop the cast if the conditions are met.
        CleveRoids.DoConditionalStopCasting(msg)
    else
        -- If no conditionals, run the original command.
        CleveRoids.Hooks.STOPCASTING_SlashCmd()
    end
end

CleveRoids.Hooks.UNQUEUE_SlashCmd = SlashCmdList.UNQUEUE
SlashCmdList.UNQUEUE = function(msg)
    msg = msg or ""
    if string.find(msg, "%[") then
        -- If conditionals are present, let the function handle it.
        CleveRoids.DoConditionalStopCasting(msg)
    else
        -- If no conditionals, run the original command.
        CleveRoids.Hooks.UNQUEUE_SlashCmd()
    end
end

-- /cast hook
CleveRoids.Hooks.CAST_SlashCmd = SlashCmdList.CAST
SlashCmdList.CAST = function(msg)
    if msg and string.find(msg, "[%[%?!~{]") then
        CleveRoids.DoCast(msg)
    else
        CleveRoids.Hooks.CAST_SlashCmd(msg)
    end
end

CleveRoids.Hooks.TARGET_SlashCmd = SlashCmdList.TARGET
CleveRoids.TARGET_SlashCmd = function(msg)
    tmsg = CleveRoids.Trim(msg)

    if tmsg ~= "" and not string.find(tmsg, "%[") and not string.find(tmsg, "@") then
        CleveRoids.Hooks.TARGET_SlashCmd(tmsg)
        return
    end

    if CleveRoids.DoTarget(tmsg) then
        if UnitExists("target") then
            return
        end
    end
    CleveRoids.Hooks.TARGET_SlashCmd(msg)
end
SlashCmdList.TARGET = CleveRoids.TARGET_SlashCmd


SLASH_CASTSEQUENCE1 = "/castsequence"
SlashCmdList.CASTSEQUENCE = function(msg)
    msg = CleveRoids.Trim(msg)
    local sequence = CleveRoids.GetSequence(msg)
    if not sequence then return end
    -- if not sequence.active then return end

    CleveRoids.DoCastSequence(sequence)
end

--新增条件支持 by 武藤纯子酱 2025.8.10
SLASH_RUNMACRO1 = "/runmacro"
function SlashCmdList.RUNMACRO(msg)
    if not msg then return end
    return SafeRunMacro("macro", msg)
end

--新增条件支持 by 武藤纯子酱 2025.7.20
SLASH_RETARGET1 = "/retarget"
function SlashCmdList.RETARGET(msg)
    if not msg or msg == "" then
        CleveRoids.DoRetarget()
    else
        CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, CleveRoids.DoRetarget)
    end
end

SLASH_STOPMACRO1 = "/stopmacro"
SlashCmdList.STOPMACRO = function(msg)
    CleveRoids.DoStopMacro(msg)
end

--[[
    新增中文console命令支持 by 武藤纯子酱 2025.8.19
    与正式服中文命令对齐
]]--

if CleveRoids.Locale == "zhCN" or CleveRoids.Locale == "zhTW" then
	-- 宠物命令
	SLASH_PETATTACK2 = "/宠物攻击"
	SLASH_PETFOLLOW2 = "/宠物跟随"
	SLASH_PETWAIT2 = "/宠物停留"
	SLASH_PETPASSIVE2 = "/宠物被动"
	SLASH_PETAGGRESSIVE2 = "/宠物主动"
	SLASH_PETDEFENSIVE2 = "/宠物防御"

	-- 宠物技能命令
	SLASH_PETAUTOCASTOFF2 = "/宠物自动施放关闭"
	SLASH_PETAUTOCASTON2 = "/宠物自动施放开启"
	SLASH_PETAUTOCASTTOGGLE2 = "/宠物自动施放切换"

	-- 系统命令
	SLASH_RELOAD4 = "/重新载入"
	SLASH_RELOAD5 = "/重载"

	-- 物品和装备命令
	SLASH_USE2 = "/使用"
	SLASH_EQUIP2 = "/装备"
	SLASH_EQUIPMH2 = "/装备主手"
	SLASH_EQUIPOH2 = "/装备副手"
	SLASH_EQUIPSLOT2 = "/装备栏位"
	SLASH_SWITCH2 = "/切换武器"
	SLASH_USERNADOM2 = "/随机使用"

	-- 形态和光环命令
	SLASH_CANCELFORM2 = "/取消形态"
	SLASH_CANCELAURA3 = "/取消光环"

	-- 战斗命令
	SLASH_STARTATTACK2 = "/攻击"
	SLASH_STOPATTACK2 = "/停止攻击"
	SLASH_STOPCASTING2 = "/停止施法"
	SLASH_UNQUEUE2 = "/停止队列"

	-- 目标命令
	SLASH_CLEARTARGET2 = "/清除目标"
	SLASH_TARGETLASTTARGET3 = "/上一个目标"
	SLASH_RETARGET2 = "/重新选择目标"
	SLASH_TARGETENEMY2 = "/选择敌人"
	SLASH_TARGETENEMY3 = "/敌人"	
	SLASH_TARGETENEMYPLAYER2 = "/选择敌方玩家"
	SLASH_TARGETENEMYPLAYER3 = "/敌方玩家"
	SLASH_TARGETFRIEND2 = "/选择友方"
	SLASH_TARGETFRIEND3 = "/友方"
	SLASH_TARGETFRIENDPLAYER2 = "/选择友方玩家"
	SLASH_TARGETFRIENDPLAYER3 = "/友方玩家"
	SLASH_TARGETLASTENEMY2 = "/选择上一个敌人"
	SLASH_TARGETLASTENEMY3 = "/上一个敌人"
	SLASH_TARGETLASTFRIEND2 = "/选择上一个友方"
	SLASH_TARGETLASTFRIEND3 = "/上一个友方"
	SLASH_TARGETPARTY2 = "/选择队友"
	SLASH_TARGETPARTY3 = "/队友"
	SLASH_TARGETRAID2 = "/选择团队成员"
	SLASH_TARGETRAID3 = "/团队成员"
	SLASH_TARGETRAID4 = "/团员"
	SLASH_TARGETEXACT2 = "/精确选择"
	SLASH_ASSIST2 = "/协助"

	-- 宏命令
	SLASH_CASTSEQUENCE2 = "/施法序列"
	SLASH_CASTSEQUENCE3 = "/施法队列"
	SLASH_CASTRANDOM2 = "/随机施法"
	SLASH_RUNMACRO2 = "/运行宏"
	SLASH_STOPMACRO2 = "/停止宏"
	SLASH_RUNSUPERMACRO2 = "/运行超级宏"

	-- 坐骑命令
	SLASH_MOUNT2 = "/上马"
	SLASH_DISMOUNT2 = "/下马"

	-- 动作条命令
	SLASH_CHANGEACTIONBAR2 = "/切换动作条"
	SLASH_SWAPACTIONBAR2 = "/交换动作条"

	-- 其他命令
	SLASH_FEED2 = "/喂养宠物"
end