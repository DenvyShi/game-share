--[[
	Author: Dennis Werner Garske (DWG) / brian / Mewtiny / brian / Mewtiny
	License: MIT License
]]

-- Setup to wrap our stuff in a table so we don't pollute the global environment
local _G = _G or getfenv(0)
local CleveRoids = _G.CleveRoids or {}
_G.CleveRoids = CleveRoids
CleveRoids.lastItemIndexTime = 0
CleveRoids.initializationTimer = nil
CleveRoids.isActionUpdateQueued = true -- Flag to check if a full action update is needed

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function()
    if not CleveRoidMacros then CleveRoidMacros = {} end

    if type(CleveRoidMacros.realtime) ~= "number" then
        CleveRoidMacros.realtime = 0
    end

    if type(CleveRoidMacros.refresh) ~= "number" then
        CleveRoidMacros.refresh = 5
    end
end)

-- Queues a full update of all action bars.
-- This is called by game event handlers to avoid running heavy logic inside the event itself.
function CleveRoids.QueueActionUpdate()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.isActionUpdateQueued = true
    end
end

-- 增加宏执行栈结构 by 武藤纯子酱 2025.8.11
CleveRoids.MacroStack = {}
CleveRoids.MaxMacroDepth = 10 -- 最大递归深度

-- 装备到指定槽位的函数 by 武藤纯子酱 2025.7.13
function CleveRoids.DoEquipSlot(msg)
    local handled = false
    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        -- 解析条件部分和物品部分
        -- 格式: [condition] slot item
        local action = function(args)
            -- args是经过条件解析后的字符串（槽位编号和物品名）
            -- 将args拆分成槽位和物品名
            local slotId, itemName = string.match(args, "^(%d+)%s+(.+)")
            if slotId and itemName then
                slotId = tonumber(slotId)
                itemName = CleveRoids.Trim(itemName)
                if slotId < 1 or slotId > 19 then
                    CleveRoids.Print("Invalid slot ID: "..tostring(slotId))
                    return false
                end
                return CleveRoids.EquipItemToSlot(itemName, slotId)
            else
                return false
            end
        end
        handled = CleveRoids.DoWithConditionals(v, nil, CleveRoids.FixEmptyTarget, false, action)
        if handled then break end
    end
    return handled
end

function CleveRoids.EquipItemToSlot(itemName, slotId)
    local item = CleveRoids.GetItem(itemName)
    if not item then return false end
    -- 检查当前槽位是否已经装备了这个物品
    local currentItemLink = GetInventoryItemLink("player", slotId)
    if currentItemLink then
		local _,_,itemId = string.find(currentItemLink,"item:(%d+)") --修复 by 武藤纯子酱 2025.8.4		
        local currentItemName = GetItemInfo(itemId)	
        if currentItemName and currentItemName == item.name then
			return true -- 已经装备，不需要操作
        end
    end
    if item.bagID then
        CleveRoids.GetNextBagSlotForUse(item, itemName)
        PickupContainerItem(item.bagID, item.slot)
    elseif item.inventoryID then
        PickupInventoryItem(item.inventoryID)
    else
        return false
    end
    EquipCursorItem(slotId)
    ClearCursor()
    CleveRoids.lastItemIndexTime = 0
    return true
end

--以上为新增 by 武藤纯子酱 2025.7.13

local function DoConditionalTargeting(msg, targetFunc, isFriendly)
	local unitID

	if SUPERWOW_STRING then
		_,unitID = UnitExists("target")
	else
		unitID = UnitName("target")
	end
    
    local handled = CleveRoids.DoWithConditionals(msg, targetFunc, CleveRoids.FixEmptyTarget, false, function(name)
        if name and name ~= "" then
            targetFunc(name)
        else
            targetFunc()
        end

        -- 验证目标类型
        if UnitExists("target") then
            if isFriendly then
                if not UnitCanAssist("player", "target") then
					if unitID then
						if SUPERWOW_STRING then
							TargetUnit(unitID)
						else
							TargetByName(unitID)
						end
					else
						ClearTarget()
					end
                end
            else
                if not UnitCanAttack("player", "target") then
					if unitID then
						if SUPERWOW_STRING then
							TargetUnit(unitID)
						else
							TargetByName(unitID)
						end
					else
						ClearTarget()
					end
                end
            end
        end
    end)

    -- 如果未处理（条件不满足），恢复之前的目标
    if not handled then
		if unitID then
			if SUPERWOW_STRING then
				TargetUnit(unitID)
			else
				TargetByName(unitID)
			end
		else
			ClearTarget()
		end
    end
    return handled
end
 
-- /assist [条件] [@unit]
function CleveRoids.DoAssist(msg)
    return DoConditionalTargeting(msg, function(name)
        if name and name ~= "" then
			if CleveRoids.hasSuperwow then
				local _, targetguid = UnitExists("target")
				if targetguid and CleveRoids.AssistsUnit[name] and CleveRoids.AssistsUnit[name] == targetguid then
					return
				end
			end
			
			if UnitName("target") ~= name then
				TargetByName(name, true)
			end
			if not UnitCanAssist("player", "target") then
				TargetLastTarget()
			else
				if CleveRoids.hasSuperwow then
					local assitsunitname = UnitName("target")
					local _, assitsunittarget = UnitExists("targettarget")
					if assitsunitname and assitsunittarget then CleveRoids.AssistsUnit[assitsunitname] = assitsunittarget end
				end				
				TargetUnit("targettarget")
			end			
        else
			if UnitCanAssist("player", "target") and UnitExists("targettarget") then
				if CleveRoids.hasSuperwow then
					local assitsunitname = UnitName("target")
					local _, assitsunittarget = UnitExists("targettarget")
					if assitsunitname and assitsunittarget then CleveRoids.AssistsUnit[assitsunitname] = assitsunittarget end
				end	
				TargetUnit("targettarget")
			end
        end  
    end, false)
end
 
-- /targetenemy [条件] [名字]
function CleveRoids.DoTargetEnemy(msg)
    return DoConditionalTargeting(msg, function(name)
        if name and name ~= "" then
            TargetByName(name, true)
        else
            TargetNearestEnemy()
        end
    end, false)
end
 
-- /targetenemyplayer [条件] [名字]
function CleveRoids.DoTargetEnemyPlayer(msg)
    return DoConditionalTargeting(msg, function(name)
        if name and name ~= "" then
            TargetByName(name, true)
			if not UnitIsPlayer("target") then
				TargetLastTarget()
			end
        else

            local hasPlayers = false
            for i = 1, 20 do
                TargetNearestEnemy()
                if UnitExists("target") and UnitIsPlayer("target") then
                    hasPlayers = true
                    break
                end
            end
            
            if not hasPlayers then
                TargetLastTarget()
            end
        end
    end, false)
end
 
-- /targetfriend [条件] [名字]
function CleveRoids.DoTargetFriend(msg)
    return DoConditionalTargeting(msg, function(name)
        if name and name ~= "" then
            TargetByName(name, true)
        else
            TargetNearestFriend()
        end
    end, true)
end
 
-- /targetfriendplayer [条件] [名字]
function CleveRoids.DoTargetFriendPlayer(msg)
    return DoConditionalTargeting(msg, function(name)
        if name and name ~= "" then
            TargetByName(name, true)
			if not UnitIsPlayer("target") then
				TargetLastTarget()
			end			
        else

            local hasPlayers = false
            for i = 1, 20 do
                TargetNearestFriend()
                if UnitExists("target") and UnitIsPlayer("target") then
                    hasPlayers = true
                    break
                end
            end
            
            if not hasPlayers then
                TargetLastTarget()
            end
        end
    end, true)
end
 
-- /targetlastenemy [条件]
function CleveRoids.DoTargetLastEnemy(msg)
    return CleveRoids.DoWithConditionals(msg, nil, nil, false, function()
        TargetLastEnemy()
    end)
end
 
-- /targetlastfriend [条件]

-- 创建一个事件监听器框架
local Last_Friend_Target = CreateFrame("Frame")
local lastfriendtarget

-- 注册需要监听的事件
Last_Friend_Target:RegisterEvent("PLAYER_TARGET_CHANGED")

Last_Friend_Target:SetScript("OnEvent", function()
	if UnitIsFriend("player", "target") then 
		if SUPERWOW_STRING then
			_,lastfriendtarget = UnitExists("target")
		else
			lastfriendtarget = UnitName("target")
		end
	end;
end)

function CleveRoids.DoTargetLastFriend(msg)
    return CleveRoids.DoWithConditionals(msg, nil, nil, false, function()
		if lastfriendtarget then
			if SUPERWOW_STRING then
				TargetUnit(lastfriendtarget)
			else
				TargetByName(lastfriendtarget)
			end
		end
    end)
end
 
-- /targetlasttarget [条件]
function CleveRoids.DoTargetLastTarget(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function()
        TargetLastTarget()
    end)
end
 
-- /targetparty [条件] [名字]
function CleveRoids.DoTargetParty(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function(name)
        if not name or name == "" then return end
        TargetByName(name, true)
        
        -- Validate target is in party
        if not CleveRoids.IsTargetInGroupType("target", "party") then
            TargetLastTarget()
        end
    end)
end
 
-- /targetraid [条件] [名字]
function CleveRoids.DoTargetRaid(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function(name)
        if not name or name == "" then return end
        TargetByName(name, true)
        
        -- Validate target is in raid
        if not CleveRoids.IsTargetInGroupType("target", "raid") then
            TargetLastTarget()
        end
    end)
end

function CleveRoids.DoTargetExact(msg)
    local handled = false
    local action, conditionals = CleveRoids.GetParsedMsg(msg)
    
    local function exactTarget(name)
        if not name or name == "" then return end
		
        -- 保存当前目标
        local prevTarget = UnitExists("target") and UnitName("target")
        
        -- 尝试精确匹配目标
        TargetByName(name, true)
        
        -- 检查是否精确匹配
        if UnitExists("target") and UnitName("target") == name then
            return true
        else
            -- 恢复之前的目标
            if prevTarget then
                TargetLastTarget()
            else
                ClearTarget()
            end
            return false
        end
    end
    
    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        handled = CleveRoids.DoWithConditionals(v, exactTarget, CleveRoids.FixEmptyTarget, false, exactTarget)
        if handled then break end
    end
    
    return handled
end

-- /petautocastoff [条件] [名字]
function CleveRoids.DoPetAutoCastOff(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function(name)
        if not name or name == "" then 
			return 
		end

		for i=1,10 do 
			local spellname,_,_,_,_,_,autocast = GetPetActionInfo(i)
			
			if spellname == name and autocast then 
				TogglePetAutocast(i)
			end
		end

    end)
end

-- /petautocaston [条件] [名字]
function CleveRoids.DoPetAutoCastOn(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function(name)
        if not name or name == "" then 
			return 
		end

		for i=1,10 do 
			local spellname,_,_,_,_,_,autocast = GetPetActionInfo(i)
			
			if spellname == name and not autocast then 
				TogglePetAutocast(i)
			end
		end

    end)
end

-- /petautocasttoggle [条件] [名字]
function CleveRoids.DoPetAutoCastToggle(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function(name)
        if not name or name == "" then 
			return 
		end

		for i=1,10 do 
			local spellname,_,_,_,_,_,autocast = GetPetActionInfo(i)
			
			if spellname == name then 
				TogglePetAutocast(i)
			end
		end

    end)
end

-- /mount [条件] [名字]
function CleveRoids.DoMount(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function(name)
        if not name or name == "" then 
			return 
		end
		
		for tabIndex = 1, GetNumSpellTabs() do
			local _, texture, offset, numSpells = GetSpellTabInfo(tabIndex)
			if texture and strfind(texture,"Ability_Mount_RidingHorse") then				
				for spellIndex = offset + 1, offset + numSpells do				
					local spellname = GetSpellName(spellIndex,tabIndex)
					if strfind(name,spellname) then
						CastSpell(spellIndex,tabIndex)
						break
					end
				end
				break
			end
		end
		
    end)
end

-- /dismount [条件]
function CleveRoids.DoDismount(msg)
    return CleveRoids.DoWithConditionals(msg, nil, CleveRoids.FixEmptyTarget, false, function()

    for i = 0, 31 do -- 遍历所有buff栏位
        local texture = GetPlayerBuffTexture(i)

        if texture then
            -- 通过工具提示检测坐骑
			
            CleveRoids.Scanner:ClearLines()
            CleveRoids.Scanner:SetPlayerBuff(i)
            local tipText = CleverDismountScannerTextLeft2:GetText()
            -- 匹配速度描述关键词
            for _, pattern in ipairs(CleveRoids.MountPatterns) do
                if tipText and string.find(tipText, pattern) then
                    CancelPlayerBuff(i)
                    return
                end
            end
			          
        end
    end		

    end)
end

function CleveRoids.DoChangeActionBar(msg)
    local handled = false
    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        handled = CleveRoids.DoWithConditionals(v, nil, CleveRoids.FixEmptyTarget, false, function(args)
            local page = tonumber(args)
            if page and page >= 1 and page <= 6 then
                CURRENT_ACTIONBAR_PAGE = page
                ChangeActionBarPage()
                return true
            end
            return false
        end)
        if handled then break end
    end
    return handled
end

function CleveRoids.DoSwapActionBar(msg)
    local handled = false
    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        handled = CleveRoids.DoWithConditionals(v, nil, CleveRoids.FixEmptyTarget, false, function(args)
            local bar1, bar2 = string.match(args, "(%d+)%s+(%d+)")
            bar1, bar2 = tonumber(bar1), tonumber(bar2)
            
            if bar1 and bar2 and bar1 >= 1 and bar1 <= 6 and bar2 >= 1 and bar2 <= 6 then
                if CURRENT_ACTIONBAR_PAGE == bar1 then
                    CURRENT_ACTIONBAR_PAGE = bar2
                else
                    CURRENT_ACTIONBAR_PAGE = bar1
                end
                ChangeActionBarPage()
                return true
            end
            return false
        end)
        if handled then break end
    end
    return handled
end

function CleveRoids.DoFeed(msg)
    local handled = false
    
    -- 只有猎人可以喂养宠物
    if CleveRoids.playerClass ~= "HUNTER" then return false end
 
    local action = function(foodName)
        if UnitAffectingCombat("player") or UnitAffectingCombat("pet") or not UnitExists("pet") or UnitIsDead("pet") then
            return false
        end
        
        -- 使用指定的食物喂养宠物
        local item = CleveRoids.GetItem(foodName)
        if not item or not item.bagID or not item.slot then
            return false
        end
        
        -- 拾取食物并投放给宠物
        PickupContainerItem(item.bagID, item.slot)
        DropItemOnUnit("pet")
        
        -- 检查是否成功投放
        if CursorHasItem() then
            -- 如果未能投放，将物品放回原处
            PickupContainerItem(item.bagID, item.slot)
            return false
        else
            -- 成功喂养
            return true
        end
    end
    
    -- 设置条件检查的默认目标为宠物
    local fixTarget = function(conditionals)
        conditionals.target = "pet"
        return false
    end
    
    -- 处理条件宏
    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        handled = CleveRoids.DoWithConditionals(v, action, fixTarget, false, action)
        if handled then break end
    end
    
    return handled
end
--以上为新增 by 武藤纯子酱 2025.7.19 

function CleveRoids.GetSpellCost(spellSlot, bookType)
    CleveRoids.Frame:SetOwner(WorldFrame, "ANCHOR_NONE")
    CleveRoids.Frame:SetSpell(spellSlot, bookType)
    local _, _, cost = string.find(CleveRoids.Frame.costFontString:GetText() or "", "^(%d+) [^ys]")
    local _, _, reagent = string.find(CleveRoids.Frame.reagentFontString:GetText() or "", "^Reagents: (.*)")
    if reagent and string.sub(reagent, 1, 2) == "|c" then
        reagent = string.sub(reagent, 11, -3)
    end

    return (cost and tonumber(cost) or 0), (reagent and tostring(reagent) or nil)
end

function CleveRoids.GetProxyActionSlot(slot)
    if not slot then return end
    return CleveRoids.actionSlots[slot] or CleveRoids.actionSlots[slot.."()"]
end

function CleveRoids.TestForActiveAction(actions)
    if not actions then return end
    local currentActive = actions.active
    local currentSequence = actions.sequence
    local hasActive = false
    local newActiveAction = nil
    local newSequence = nil

    if actions.tooltip and table.getn(actions.list) == 0 then
        if CleveRoids.TestAction(actions.cmd or "", actions.args or "") then

            hasActive = true
            actions.active = actions.tooltip
        end
    else
        for _, action in actions.list do
            -- break on first action that passes tests
            if CleveRoids.TestAction(action.cmd, action.args) then
                hasActive = true
                if action.sequence then
                    newSequence = action.sequence
                    newActiveAction = CleveRoids.GetCurrentSequenceAction(newSequence)
                    if not newActiveAction then hasActive = false end
                else
                    newActiveAction = action
                end
                if hasActive then break end
            end
        end
    end

    local changed = false
    if currentActive ~= newActiveAction or currentSequence ~= newSequence then
        actions.active = newActiveAction
        actions.sequence = newSequence
        changed = true
    end

    if not hasActive then
        if actions.active ~= nil or actions.sequence ~= nil then
             actions.active = nil
             actions.sequence = nil
             changed = true
        end
        return changed
    end

    if actions.active then
        local previousUsable = actions.active.usable
        local previousOom = actions.active.oom
        local previousInRange = actions.active.inRange

        if actions.active.spell then
            actions.active.inRange = 1

            -- nampower range check (rebuild name(rank) like DoWithConditionals)
			if IsSpellInRange then
				local unit = actions.active.conditionals and actions.active.conditionals.target or "target"
				if  unit == "cursor" then -- 判定是不是鼠标指向 by 武藤纯子酱 2025.8.12
					actions.active.inRange = true
				else
					if unit == "focus" and pfUI then
						unit = pfUI.uf.focus.id					
					end
					local castName = actions.active.action
					if actions.active.spell and actions.active.spell.name then
						local rank = actions.active.spell.rank
									 or (actions.active.spell.highest and actions.active.spell.highest.rank)
						if rank and rank ~= "" then
							castName = actions.active.spell.name .. "(" .. rank .. ")"
						end
					end
					if UnitExists(unit) then
						local r = IsSpellInRange(castName, unit)
						if r ~= nil then
							actions.active.inRange = r
						end
					end
				end
			end

            actions.active.oom = (UnitMana("player") < actions.active.spell.cost)

            local start, duration = GetSpellCooldown(actions.active.spell.spellSlot, actions.active.spell.bookType)
            local onCooldown = (start > 0 and duration > 0)

            if actions.active.isReactive then
                if not CleveRoids.IsReactiveUsable(actions.active.action) then
                    actions.active.oom = false
                    actions.active.usable = nil
                else
                    actions.active.usable = (pfUI and pfUI.bars) and nil or 1
                end
            elseif actions.active.inRange ~= 0 and not actions.active.oom then
                actions.active.usable = 1

            -- pfUI:actionbar.lua -- update usable [out-of-range = 1, oom = 2, not-usable = 3, default = 0]
            elseif pfUI and pfUI.bars and actions.active.oom then
                actions.active.usable = 2
            else
                actions.active.usable = nil
            end
        else
            actions.active.inRange = 1
            actions.active.usable = 1
        end
        if actions.active.usable ~= previousUsable or
           actions.active.oom ~= previousOom or
           actions.active.inRange ~= previousInRange then
            changed = true
        end
    end
    return changed
end

function CleveRoids.TestForAllActiveActions()
    for slot, actions in CleveRoids.Actions do
        local stateChanged = CleveRoids.TestForActiveAction(actions)
        if stateChanged then
            CleveRoids.SendEventForAction(slot, "ACTIONBAR_SLOT_CHANGED", slot)
        end
    end
end

function CleveRoids.ClearAction(slot)
    if not CleveRoids.Actions[slot] then return end
    CleveRoids.Actions[slot].active = nil
    CleveRoids.Actions[slot] = nil
end

function CleveRoids.GetAction(slot)
    if not slot or not CleveRoids.ready then return end

    local actions = CleveRoids.Actions[slot]
    if actions then return actions end

    local text = GetActionText(slot)

    if text then
        local macro = CleveRoids.GetMacro(text)
        if macro then
            actions = macro.actions

            CleveRoids.TestForActiveAction(actions)
            CleveRoids.Actions[slot] = actions
            CleveRoids.SendEventForAction(slot, "ACTIONBAR_SLOT_CHANGED", slot)
            return actions
        end
    end
end

function CleveRoids.GetActiveAction(slot)
    local action = CleveRoids.GetAction(slot)
    return action and action.active
end

function CleveRoids.SendEventForAction(slot, event, ...)
    local old_this = this

    local original_global_args = {}
    for i = 1, 10 do
        original_global_args[i] = _G["arg" .. i]
    end

    if type(arg) == "table" then

        local n_varargs_from_arg_table = arg.n or 0
        for i = 1, 10 do
            if i <= n_varargs_from_arg_table then
                _G["arg" .. i] = arg[i]
            else
                _G["arg" .. i] = nil
            end
        end
    else
        for i = 1, 10 do
            _G["arg" .. i] = nil
        end
    end

    local button_to_call_event_on
    local page = floor((slot - 1) / NUM_ACTIONBAR_BUTTONS) + 1
    local pageSlot = slot - (page - 1) * NUM_ACTIONBAR_BUTTONS

    if slot >= 73 then
        button_to_call_event_on = _G["BonusActionButton" .. pageSlot]
    elseif slot >= 61 then
        button_to_call_event_on = _G["MultiBarBottomLeftButton" .. pageSlot]
    elseif slot >= 49 then
        button_to_call_event_on = _G["MultiBarBottomRightButton" .. pageSlot]
    elseif slot >= 37 then
        button_to_call_event_on = _G["MultiBarLeftButton" .. pageSlot]
    elseif slot >= 25 then
        button_to_call_event_on = _G["MultiBarRightButton" .. pageSlot]
    end

    if button_to_call_event_on then
        this = button_to_call_event_on
        ActionButton_OnEvent(event)
    end

    if page == CURRENT_ACTIONBAR_PAGE then
        local main_bar_button = _G["ActionButton" .. pageSlot]
        if main_bar_button and main_bar_button ~= button_to_call_event_on then
            this = main_bar_button
            ActionButton_OnEvent(event)
        elseif not button_to_call_event_on and main_bar_button then
             this = main_bar_button
             ActionButton_OnEvent(event)
        end
    end

    this = old_this

    for i = 1, 10 do
        _G["arg" .. i] = original_global_args[i]
    end

    if type(arg) == "table" and arg.n then

        if arg.n == 0 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event) end
        elseif arg.n == 1 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1]) end
        elseif arg.n == 2 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1], arg[2]) end
        elseif arg.n == 3 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1], arg[2], arg[3]) end
        elseif arg.n == 4 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1], arg[2], arg[3], arg[4]) end
        elseif arg.n == 5 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1], arg[2], arg[3], arg[4], arg[5]) end
        elseif arg.n == 6 then
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6]) end
        else
            for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do fn_h(slot, event, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7]) end
        end
    else

        for _, fn_h in ipairs(CleveRoids.actionEventHandlers) do
            fn_h(slot, event)
        end
    end
end

-- Executes the given Macro's body
-- body: The Macro's body
function CleveRoids.ExecuteMacroBody(body,inline)
    local lines = CleveRoids.splitString(body, "\n")
    if inline then lines = CleveRoids.splitString(body, "\\n"); end

    for k,v in pairs(lines) do
        if CleveRoids.stopmacro then
            CleveRoids.stopmacro = false
            return true
        end
        ChatFrameEditBox:SetText(v)
        ChatEdit_SendText(ChatFrameEditBox)
    end
    return true
end

-- Gets the body of the Macro with the given name
-- name: The name of the Macro
-- returns: The body of the macro
function CleveRoids.GetMacroBody(name)
    local macro = CleveRoids.GetMacro(name)
    return macro and macro.body
end

-- Attempts to execute a macro by the given name
-- name: The name of the macro
-- returns: Whether the macro was executed or not
-- 优化宏递归深度判定 by 武藤纯子酱 2025.8.11
function CleveRoids.ExecuteMacroByName(name)
    -- 检查当前宏是否已在调用栈中
    for i = 1, table.getn(CleveRoids.MacroStack) do
        if CleveRoids.MacroStack[i] == name then
            CleveRoids.Print("警告: 宏 ["..name.."] 已被调用，不能递归调用自身")
            return false
        end
    end
    
    -- 检查调用栈深度
    if table.getn(CleveRoids.MacroStack) >= CleveRoids.MaxMacroDepth then
        CleveRoids.Print("警告: 宏调用深度超过限制 ("..CleveRoids.MaxMacroDepth..")")
        return false
    end
    
    -- 将当前宏压入调用栈
    table.insert(CleveRoids.MacroStack, name)
    
    local success = false
    local body = CleveRoids.GetMacroBody(name)
    if body then
        -- 使用 pcall 捕获任何可能的错误
        local status, result = pcall(function()
            return CleveRoids.ExecuteMacroBody(body)
        end)
        
        if status then
            success = result
        else
            --CleveRoids.Print("宏执行错误: "..tostring(result))
        end
    end
    
    -- 宏执行完成后必须从栈中移除
    local removeIndex = nil
    for i = 1, table.getn(CleveRoids.MacroStack) do
        if CleveRoids.MacroStack[i] == name then
            removeIndex = i
            break
        end
    end
    
    if removeIndex then
        table.remove(CleveRoids.MacroStack, removeIndex)
    else
        CleveRoids.Print("警告: 宏 ["..name.."] 不在调用栈中")
    end
    
    return success
end

function CleveRoids.SetHelp(conditionals)
    if conditionals.harm then
        conditionals.help = false
    end
end

function CleveRoids.FixEmptyTarget(conditionals)
    if not conditionals.target then
        if UnitExists("target") then
            conditionals.target = "target"
        elseif GetCVar("autoSelfCast") == "1" and not conditionals.target == "help" then
            conditionals.target = "player"
        end
    end
    return false
end

-- Fixes the conditionals' target by targeting the target with the given name
-- conditionals: The conditionals containing the current target
-- name: The name of the player to target
-- hook: The target hook
-- returns: Whether or not we've changed the player's current target
function CleveRoids.FixEmptyTargetSetTarget(conditionals, name, hook)
    if not conditionals.target then
        hook(name)
        conditionals.target = "target"
        return true
    end
    return false
end

-- Returns the name of the focus target or nil
function CleveRoids.GetFocusName()
    -- 1. Add specific compatibility for pfUI.
    -- pfUI stores its focus unit information in a table.
    if pfUI and pfUI.uf and pfUI.uf.focus and pfUI.uf.focus.unitname then
        return pfUI.uf.focus.unitname
    end

    -- Fallback for other focus addons
    if ClassicFocus_CurrentFocus then
        return ClassicFocus_CurrentFocus
	elseif FocusCore and FocusCore:GetName() then -- 增加对FocusFrame插件的支持 by 武藤纯子酱 2025.8.4
		return FocusCore:GetName()
    elseif CURR_FOCUS_TARGET then
        return CURR_FOCUS_TARGET
    end

    return nil
end

-- Attempts to target the focus target.
-- returns: Whether or not it succeeded
function CleveRoids.TryTargetFocus()
    local name = CleveRoids.GetFocusName()

    if not name then
        return false
    end

    TargetByName(name, true)

    if not UnitExists("target") or (string.lower(UnitName("target")) ~= name) then
        -- The target switch failed (out of range, LoS, etc.)
        return false
    end

    return true
end

function CleveRoids.GetMacroNameFromAction(text)
    if string.sub(text, 1, 1) == "{" and string.sub(text, -1) == "}" then
        local name
        if string.sub(text, 2, 2) == "\"" and string.sub(text, -2, -2) == "\"" then
            return string.sub(text, 3, -3)
        else
            return string.sub(text, 2, -2)
        end
    end
end

function CleveRoids.CreateActionInfo(action, conditionals)
    local _, _, text = string.find(action, "!?%??~?(.*)")
    local spell = CleveRoids.GetSpell(text)
    local item, macroName, macro, macroTooltip, actionType, texture

    -- NEW: Check if the action is a slot number
    local slotId = tonumber(text)
    if slotId and slotId >= 1 and slotId <= 19 then
        actionType = "item"
        -- Use the most reliable method first to get the texture for an equipped item.
        local itemTexture = GetInventoryItemTexture("player", slotId)

        -- Check if the texture was successfully found.
        if itemTexture then
            texture = itemTexture
        else
            -- If the primary method fails, fall back to the unknown texture.
            -- This prevents errors if the slot is empty or the item data is unusual.
            texture = CleveRoids.unknownTexture
        end
    else
        -- Original logic for named items and spells
        if not spell then
            item = CleveRoids.GetItem(text)
        end
        if not item then
            macroName = CleveRoids.GetMacroNameFromAction(text)
            macro = CleveRoids.GetMacro(macroName)
            macroTooltip = (macro and macro.actions) and macro.actions.tooltip
        end

        if spell then
            actionType = "spell"
            texture = spell.texture or CleveRoids.unknownTexture
        elseif item then
            actionType = "item"
            texture = (item and item.texture) or CleveRoids.unknownTexture
        elseif macro then
            actionType = "macro"
            texture = (macro.actions and macro.actions.tooltip and macro.actions.tooltip.texture)
                        or (macro and macro.texture)
                        or CleveRoids.unknownTexture
        end
    end

    local info = {
        action = text,
        item = item,
        spell = spell,
        macro = macroTooltip,
        type = actionType,
        texture = texture,
        conditionals = conditionals,
    }

    return info
end

function CleveRoids.SplitCommandAndArgs(text)
    local _, _, cmd, args = string.find(text, "(/%w+%s?)(.*)")
    if cmd and args then
        cmd = CleveRoids.Trim(cmd)
        text = CleveRoids.Trim(args)
    end
    return cmd, args
end

function CleveRoids.ParseSequence(text)
    local args = string.gsub(text, "(%s*,%s*)", ",")
    local _, c, cond = string.find(args, "(%[.*%])")
    local _, r, reset, resetVal = string.find(args, "(%s*%]*%s*reset=([%w/]+)%s+)")

    actionSeq = CleveRoids.Trim((r and string.sub(args, r+1)) or (c and string.sub(args, c+1)) or args)
    args = (cond or "") .. actionSeq

    if not actionSeq then
        return
    end

    local sequence = {
        index = 1,
        reset = {},
        status = 0,
        list = {},
        lastUpdate = 0,
        cond = cond,
        args = args,
        cmd = "/castsequence"
    }
    if resetVal then
        for _, rule in ipairs(CleveRoids.Split(resetVal, "/")) do
            local secs = tonumber(rule)
            if secs and secs > 0 then
                sequence.reset.secs = secs
            else
                sequence.reset[string.lower(rule)] = true
            end
        end
    end

    for _, a in ipairs(CleveRoids.Split(actionSeq, ",")) do
        local sa = CleveRoids.CreateActionInfo(CleveRoids.GetParsedMsg(a))
        table.insert(sequence.list, sa)
    end
    CleveRoids.Sequences[text] = sequence

    return sequence
end

function CleveRoids.ParseMacro(name)
    if not name then return end

    local macroID = GetMacroIndexByName(name)
    if not macroID then return end

    local _, texture, body = GetMacroInfo(macroID)

    if not body and GetSuperMacroInfo then
        _, texture, body = GetSuperMacroInfo(name)
    end

    if not texture or not body then return end


    local macro = {
        id = macroId,
        name = name,
        texture = texture,
        body = body,
        actions = {},
    }
    macro.actions.list = {}

    -- build a list of testable actions for the macro
    for i, line in CleveRoids.splitString(body, "\n") do
        line = CleveRoids.Trim(line)
        local cmd, args = CleveRoids.SplitCommandAndArgs(line)

        -- check for #showtooltip
        if i == 1 then
            local _, _, st, _, tt = string.find(line, "(#showtooltip)s?(%s?(.*))") -- 修改后同时支持#showtooltip 和 #showtooltips 两种写法 by 武藤纯子酱 2025.7.22

            -- if no #showtooltip, nothing to keep track of
            if not st then
                break
            end
            tt = CleveRoids.Trim(tt)

            -- #showtooltip and item/spell/macro specified, only use this tooltip
            if st and tt ~= "" then
				for _, arg in CleveRoids.splitStringIgnoringQuotes(tt) do
					macro.actions.tooltip = CleveRoids.CreateActionInfo(arg)
					local action = CleveRoids.CreateActionInfo(CleveRoids.GetParsedMsg(arg))
					action.cmd = "/cast"
					action.args = arg
					action.isReactive = CleveRoids.reactiveSpells[action.action]
					table.insert(macro.actions.list, action)
				end
                break
            end
        else
            -- make sure we have a testable action
            if line ~= "" and args ~= "" and CleveRoids.dynamicCmds[cmd] then
                for _, arg in CleveRoids.splitStringIgnoringQuotes(args) do
                    local action = CleveRoids.CreateActionInfo(CleveRoids.GetParsedMsg(arg))

                    if cmd == "/castsequence" then
                        local sequence = CleveRoids.GetSequence(args)
                        if sequence then
                            action.sequence = sequence
                        end
                    end
                    action.cmd = cmd
                    action.args = arg
                    action.isReactive = CleveRoids.reactiveSpells[action.action]
                    table.insert(macro.actions.list, action)
                end
            end
        end
    end

    CleveRoids.Macros[name] = macro
    return macro
end

function CleveRoids.ParseMsg(msg)
    if not msg then return end
    local conditionals = {}

    msg, conditionals.ignoretooltip = string.gsub(CleveRoids.Trim(msg), "^%?", "")
    local _, cbEnd, conditionBlock = string.find(msg, "%[(.*)%]")  -- 将"%[(.+)%]" 修改为 "%[(.*)%]" 支持[]空条件，该条件永远为true by 武藤纯子酱 2025.7.30
	
    -- 处理空条件块的情况 by 武藤纯子酱 2025.7.28
    if conditionBlock == "" then
        conditionBlock = nil
    end

    local _, _, noSpam, cancelAura, action = string.find(string.sub(msg, (cbEnd or 0) + 1), "^%s*(!?)(~?)([^!~]+.*)")
    action = CleveRoids.Trim(action or "")

    -- Store the action along with the conditionals incase it's needed
    conditionals.action = action
    -- FLEXIBLY remove rank text like "(Rank 9)" to get the base spell name
    action = string.gsub(action, "%s*%(.-%)%s*$", "")

    if noSpam and noSpam ~= "" then
        local spamCond = CleveRoids.GetSpammableConditional(action)
        if spamCond then
            conditionals[spamCond] = { action }
        end
    end
    if cancelAura and cancelAura ~= "" then
        conditionals.cancelaura = action
    end

    if not conditionBlock then
        return conditionals.action, conditionals
    end

    -- Set the action's target to @unitid if found
	-- 新增对target=unitid的支持 by 武藤纯子酱 2025.7.30
	local target
	if strfind(conditionBlock,"[tT][aA][rR][gG][eE][tT]=") then -- 实现大小写不敏感 by 武藤纯子酱 2025.8.5
		_, _, target = string.find(conditionBlock, "([tT][aA][rR][gG][eE][tT]=[^%s,]+)") -- 实现大小写不敏感 by 武藤纯子酱 2025.8.5
		if target then
			conditionBlock = CleveRoids.Trim(string.gsub(conditionBlock, target, ""))
			conditionals.target = string.sub(target, 8)
			conditionals.target = strlower(conditionals.target) -- 统一转换为小写 by 武藤纯子酱 2025.8.5			
		end				
	else
		_, _, target = string.find(conditionBlock, "(@[^%s,]+)")
		if target then
			conditionBlock = CleveRoids.Trim(string.gsub(conditionBlock, target, ""))
			conditionals.target = string.sub(target, 2)
			conditionals.target = strlower(conditionals.target) -- 统一转换为小写 by 武藤纯子酱 2025.8.5			
		end		
	end
	-- 以上为新增对target=unitid的支持 by 武藤纯子酱 2025.7.30
	
    if conditionBlock and action then
        -- Split the conditional block by comma or space
        for _, conditionGroups in CleveRoids.splitStringIgnoringQuotes(conditionBlock, {",", " "}) do
            if conditionGroups ~= "" then
                -- Split conditional groups by colon
                local conditionGroup = CleveRoids.splitStringIgnoringQuotes(conditionGroups, ":")
                local condition, args = conditionGroup[1], conditionGroup[2]
				condition = string.lower(condition)	-- 新增：将条件关键字转换为小写，实现大小写不敏感 by 武藤纯子酱 2025.8.5
                -- No args, the action is the implicit argument
                if not args or args == "" then
                    if not conditionals[condition] then
                        conditionals[condition] = action
                    else
                        if type(conditionals[condition]) ~= "table" then
                           conditionals[condition] = { conditionals[condition] }
                        end
                        table.insert(conditionals[condition], action)
                    end
                else
                    -- Has args. Ensure the key's value is a table and add the new arguments.
                    if not conditionals[condition] then
                        conditionals[condition] = {}
                    elseif type(conditionals[condition]) ~= "table" then
                        conditionals[condition] = { conditionals[condition] }
                    end

                    -- Split the args by / for multiple values
                    for _, arg_item in CleveRoids.splitString(args, "/") do
                        local processed_arg = CleveRoids.Trim(arg_item)

                        processed_arg = string.gsub(processed_arg, '"', "")
                        processed_arg = string.gsub(processed_arg, "_", " ")
                        processed_arg = CleveRoids.Trim(processed_arg)

                        local arg_for_find = processed_arg
                        arg_for_find = string.gsub(arg_for_find, "^#(%d+)$", "=#%1")
                        arg_for_find = string.gsub(arg_for_find, "([^>~=<]+)#(%d+)", "%1=#%2")

                        -- FIXED: This regex now accepts decimal numbers
                        local _, _, name, operator, amount = string.find(arg_for_find, "([^>~=<]*)([>~=<]+)(#?%d*%.?%d+)")
                        if not operator or not amount then
                            table.insert(conditionals[condition], processed_arg)
                        else
                            local name_to_use = (name and name ~= "") and name or conditionals.action

                            local final_amount_str, num_replacements = string.gsub(amount, "#", "")
                            local should_check_stacks = (num_replacements == 1)

                            table.insert(conditionals[condition], {
                                name = CleveRoids.Trim(name_to_use),
                                operator = operator,
                                amount = tonumber(final_amount_str),
                                checkStacks = should_check_stacks
                            })
                        end
                    end
                end
            end
        end
        return conditionals.action, conditionals
    end
end

-- Get previously parsed or parse, store and return
function CleveRoids.GetParsedMsg(msg)
    if not msg then return end

	if strfind(msg,"!") and (CleveRoids.CurrentSpell.autoAttack or CleveRoids.CurrentSpell.autoShot or CleveRoids.CurrentSpell.wand) then return end	--修复 by 武藤纯子酱 2025.7.9	
	
    -- 新增：检查是否是多个条件块的情况 by 武藤纯子酱 2025.7.28
    local firstBracket = string.find(msg, "%[")
    if firstBracket then
        local secondBracket = string.find(msg, "%]", firstBracket + 1)
        if secondBracket and string.find(msg, "%[", secondBracket + 1) then
            -- 这是多个条件块的情况，直接返回原始消息让DoWithConditionals处理
            return msg, nil
        end
    end	
	
    if CleveRoids.ParsedMsg[msg] then
        return CleveRoids.ParsedMsg[msg].action, CleveRoids.ParsedMsg[msg].conditionals
    end

    CleveRoids.ParsedMsg[msg] = {}
    CleveRoids.ParsedMsg[msg].action, CleveRoids.ParsedMsg[msg].conditionals = CleveRoids.ParseMsg(msg)

    return CleveRoids.ParsedMsg[msg].action, CleveRoids.ParsedMsg[msg].conditionals
end

function CleveRoids.GetMacro(name)
    return CleveRoids.Macros[name] or CleveRoids.ParseMacro(name)
end

function CleveRoids.GetSequence(args)
    return CleveRoids.Sequences[args] or CleveRoids.ParseSequence(args)
end

function CleveRoids.GetCurrentSequenceAction(sequence)
    return sequence.list[sequence.index]
end

function CleveRoids.ResetSequence(sequence)
    sequence.index = 1
end

function CleveRoids.AdvanceSequence(sequence)
    if sequence.index < table.getn(sequence.list) then
        sequence.index = sequence.index + 1
    else
        CleveRoids.ResetSequence(sequence)
    end
end

function CleveRoids.TestAction(cmd, args)
    local msg, conditionals = CleveRoids.GetParsedMsg(args)
	
    -- 添加空值检查，避免后续操作报错 by 武藤纯子酱 2025.7.14
    if not msg then
        return nil  
    end	

    if string.find(msg, "#showtooltip") or (conditionals and conditionals.ignoretooltip == 1) then -- 添加conditionals检查，避免后续操作报错 by 武藤纯子酱 2025.8.16
        return
    end

    if not conditionals then
        if not msg then
            return
        else
            -- action is a {macro} or item/spell
            return CleveRoids.GetMacroNameFromAction(msg) or msg
        end
    end

    local origTarget = conditionals.target
    if cmd == "" or not CleveRoids.dynamicCmds[cmd] then
        -- untestables
        return
    end

    if conditionals.target == "focus" then
        local focusUnitId = nil
        -- First, try to get the specific UnitID from pfUI's data for reliability.
        if pfUI and pfUI.uf and pfUI.uf.focus and pfUI.uf.focus.label and pfUI.uf.focus.id and UnitExists(pfUI.uf.focus.label .. pfUI.uf.focus.id) then
            focusUnitId = pfUI.uf.focus.label .. pfUI.uf.focus.id
        end

        if focusUnitId then
            -- If we found a specific unit (e.g., "party1", "raid2"), use it for the test.
            conditionals.target = focusUnitId
        else
            -- If we only have a name, check if that name exists. If not, the condition fails.
            if not CleveRoids.GetFocusName() then
                return -- No focus exists, so this action is not valid.
            end
            -- Fallback for testing: We can't safely target by name here, so we default to "target".
            -- This part of the original logic remains as a fallback, but the pfUI check above will handle most cases.
            conditionals.target = "target"
        end
    end


    if conditionals.target == "mouseover" then
        if not CleveRoids.IsValidTarget("mouseover", conditionals.help) then
            return false
        end
    end

    CleveRoids.FixEmptyTarget(conditionals)
    -- CleveRoids.SetHelp(conditionals)

    for k, v in pairs(conditionals) do
        if not CleveRoids.ignoreKeywords[k] then
            if not CleveRoids.Keywords[k] or not CleveRoids.Keywords[k](conditionals) then
                -- failed test
                conditionals.target = origTarget
                return
            end
        end
    end

    -- tests passed
    conditionals.target = origTarget
    return CleveRoids.GetMacroNameFromAction(msg) or msg
end

function CleveRoids.DoWithConditionals(msg, hook, fixEmptyTargetFunc, targetBeforeAction, action)
    local msg, conditionals = CleveRoids.GetParsedMsg(msg)

	local cursortarget -- 新增@cursor支持 by 武藤纯子酱 2025.7.21
	local _, targetguid = UnitExists("target") -- 新增当前目标的guid（需要superwow） by 武藤纯子酱 2025.7.30
    -- 新增：处理多个[]条件块的情况 by 武藤纯子酱 2025.7.28
    if not conditionals and type(msg) == "string" then
        -- 尝试解析多个条件块
        local conditionBlocks = {}
        local remainingMsg = msg

        -- 提取所有条件块
        while true do
            local _, blockEnd, conditionBlock = string.find(remainingMsg, "%[(.-)%]")
            if not conditionBlock then break end
            
            table.insert(conditionBlocks, conditionBlock)
            remainingMsg = string.sub(remainingMsg, blockEnd + 1)
        end
        
        -- 如果有多个条件块，尝试每个条件块直到有一个成功
        if table.getn(conditionBlocks) and table.getn(conditionBlocks) > 1 then
            local actionText = remainingMsg
            for _, block in ipairs(conditionBlocks) do
                local fullMsg = "["..block.."]"..actionText
                if CleveRoids.DoWithConditionals(fullMsg, hook, fixEmptyTargetFunc, targetBeforeAction, action) then
                    return true
                end
            end
            return false
        end
    end

    -- No conditionals. Just exit.
    if not conditionals then
        if not msg then -- if not even an empty string
            return false
        else
            if string.sub(msg, 1, 1) == "{" and string.sub(msg, -1) == "}" then
                if string.sub(msg, 2, 2) == "\"" and string.sub(msg, -2, -2) == "\"" then
                    return CleveRoids.ExecuteMacroBody(string.sub(msg, 3, -3), true)
                else
                    return CleveRoids.ExecuteMacroByName(string.sub(msg, 2, -2))
                end
            end

            if hook then
                hook(msg)
            end
            return true
        end
    end

    if conditionals.cancelaura then
        if CleveRoids.CancelAura(conditionals.cancelaura) then
            return true
        end
    end

    local origTarget = conditionals.target
    if conditionals.target == "mouseover" then
        if UnitExists("mouseover") then
            conditionals.target = "mouseover"
        elseif CleveRoids.mouseoverUnit and UnitExists(CleveRoids.mouseoverUnit) then
            conditionals.target = CleveRoids.mouseoverUnit
		elseif UnitExists("target") then -- 修复当mouseover不存在的时候的逻辑，如果mouseover不存在，则向当前目标施法，如果当前目标也不存在，则向自身施法 by 武藤纯子酱 2025.7.24
			conditionals.target = "target"
		else
			conditionals.target = "mouseover"
        end
    end

    local needRetarget = false
    if fixEmptyTargetFunc then
        needRetarget = fixEmptyTargetFunc(conditionals, msg, hook)
    end

    -- CleveRoids.SetHelp(conditionals)

    if conditionals.target == "focus" then
        local focusUnitId = nil

        -- Attempt to get the direct UnitID from pfUI's focus frame data. This is more reliable.
        if pfUI and pfUI.uf and pfUI.uf.focus and pfUI.uf.focus.label and pfUI.uf.focus.id and UnitExists(pfUI.uf.focus.label .. pfUI.uf.focus.id) then
            focusUnitId = pfUI.uf.focus.label .. pfUI.uf.focus.id
		elseif FocusCore and CleveRoids.hasSuperwow then -- 新增对FocusFrame的支持 by 武藤纯子酱 2025.8.4
			_, focusUnitId = FocusCore:GetName()
        end
		
        if focusUnitId then
                -- If we found a valid UnitID, we will use it for all subsequent checks and the final cast.
                -- This avoids changing the player's actual target.
            conditionals.target = focusUnitId
            needRetarget = false		
        else
			-- return false if pfUI is installed and no focus is set instead of "invalid target"
			if pfUI and pfUI.env and (pfUI.uf.focus.label == nil or pfUI.uf.focus.label == "") then return false end  -- 修复 不在pfUI下报错的BUG by 武藤纯子酱 2025.7.30
            -- If the direct UnitID isn't found, fall back to the original (but likely failing) method of targeting by name.
            if not CleveRoids.TryTargetFocus() then
                UIErrorsFrame:AddMessage(SPELL_FAILED_BAD_TARGETS, 1.0, 0.0, 0.0, 1.0)
                conditionals.target = origTarget
                return false
            end
			-- 新增当前焦点目标的guid（需要superwow） by 武藤纯子酱 2025.8.4
			_, targetguid = UnitExists("target")
			if targetguid then
				conditionals.target = targetguid
				needRetarget = false
			else
				conditionals.target = "target"
				needRetarget = true			
			end
        end
    end
	
    if conditionals.target == "cursor" then -- 新增@cursor支持 by 武藤纯子酱 2025.7.21
        conditionals.target = nil
		cursortarget = true
		needRetarget = false
    end

	if conditionals.target == "cursive" then -- 新增@cursive支持 by 武藤纯子酱 2025.7.27
		if not Cursive or not Cursive.core then
			return false
		end

		needRetarget = false
		
		-- 遍历所有跟踪的单位
		for guid, _ in pairs(Cursive.core.guids) do
			-- 临时设置目标为当前候选单位
			conditionals.target = guid
				
			-- 检查所有条件是否满足
			local allConditionsMet = true
			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end
				
			-- 如果所有条件都满足，选择此单位
			if allConditionsMet then
				break  -- 跳出单位遍历循环
			elseif UnitExists("target") then
				conditionals.target = "target"
			else
				conditionals.target = nil
			end
		end
	end
	
	if conditionals.target == "mostwoundedparty" then -- 新增@mostwoundedparty支持 by 武藤纯子酱 2025.7.27
		needRetarget = false
		conditionals.target = nil
		local maxHPLost = 0
		
		-- 检查队伍成员
		for i = 1, GetNumPartyMembers() do
			local unit = "party"..i
			local hpLost = UnitHealthMax(unit) - UnitHealth(unit)
			
			-- 检查宠物
			local petUnit = "partypet"..i
			if UnitExists(petUnit) then
				local petHPLost = UnitHealthMax(petUnit) - UnitHealth(petUnit)
				if petHPLost > maxHPLost then
					-- 临时设置目标为当前候选单位
					conditionals.target = petUnit
					-- 检查所有条件是否满足
					local allConditionsMet = true
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end						
					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						maxHPLost = petHPLost
					else
						conditionals.target = nil
					end
				end
			end
			
			-- 检查队员
			if hpLost > maxHPLost then
				-- 临时设置目标为当前候选单位
				conditionals.target = unit			
				-- 检查所有条件是否满足
				local allConditionsMet = true
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end						
				-- 如果所有条件都满足，选择此单位
				if allConditionsMet then
					maxHPLost = hpLost
				else
					conditionals.target = nil
				end		
			end
		end
		
		-- 检查自己和自己的宠物
		local selfHPLost = UnitHealthMax("player") - UnitHealth("player")
		if selfHPLost > maxHPLost then
			-- 临时设置目标为当前候选单位
			conditionals.target = "player"			
			-- 检查所有条件是否满足
			local allConditionsMet = true
			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end						
			-- 如果所有条件都满足，选择此单位
			if allConditionsMet then
				maxHPLost = selfHPLost
			else
				conditionals.target = nil
			end	
		end
		
		if UnitExists("pet") then
			local petHPLost = UnitHealthMax("pet") - UnitHealth("pet")
			if petHPLost > maxHPLost then
				-- 临时设置目标为当前候选单位
				conditionals.target = "pet"				
				-- 检查所有条件是否满足
				local allConditionsMet = true
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end						
				-- 如果所有条件都满足，选择此单位
				if allConditionsMet then
					maxHPLost = petHPLost
				else
					conditionals.target = nil
				end							
			end
		end
	end

	if conditionals.target == "mostwoundedraid" then -- 新增@mostwoundedraid支持 by 武藤纯子酱 2025.7.27
		needRetarget = false
		conditionals.target = nil
		local maxHPLost = 0
		
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local unit = "raid"..i
				local hpLost = UnitHealthMax(unit) - UnitHealth(unit)
				
				-- 检查宠物
				local petUnit = "raidpet"..i
				if UnitExists(petUnit) then
					local petHPLost = UnitHealthMax(petUnit) - UnitHealth(petUnit)
					if petHPLost > maxHPLost then
						-- 临时设置目标为当前候选单位
						conditionals.target = petUnit		
						-- 检查所有条件是否满足
						local allConditionsMet = true
						for k, v in pairs(conditionals) do
							if not CleveRoids.ignoreKeywords[k] then
								if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
									allConditionsMet = false
									break  -- 跳出条件检查循环
								end
							end
						end						
						-- 如果所有条件都满足，选择此单位
						if allConditionsMet then
							maxHPLost = petHPLost
						else
							conditionals.target = nil
						end	
					end
				end
				
				-- 检查队员
				if hpLost > maxHPLost then
					-- 临时设置目标为当前候选单位
					conditionals.target = unit				
					-- 检查所有条件是否满足
					local allConditionsMet = true
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end						
					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						maxHPLost = hpLost
					else
						conditionals.target = nil
					end	
				end
			end
		end
		
		-- 检查自己和自己的宠物
		local selfHPLost = UnitHealthMax("player") - UnitHealth("player")
		if selfHPLost > maxHPLost then
			-- 临时设置目标为当前候选单位
			conditionals.target = "player"			
			-- 检查所有条件是否满足
			local allConditionsMet = true
			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end						
			-- 如果所有条件都满足，选择此单位
			if allConditionsMet then
				maxHPLost = selfHPLost
			else
				conditionals.target = nil
			end	
		end
		
		if UnitExists("pet") then
			local petHPLost = UnitHealthMax("pet") - UnitHealth("pet")
			if petHPLost > maxHPLost then
				-- 临时设置目标为当前候选单位
				conditionals.target = "pet"			
				-- 检查所有条件是否满足
				local allConditionsMet = true
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end						
				-- 如果所有条件都满足，选择此单位
				if allConditionsMet then
					maxHPLost = petHPLost
				else
					conditionals.target = nil
				end	
			end
		end
	end

	if conditionals.target == "mostwounded" then -- 新增@mostwounded支持 by 武藤纯子酱 2025.7.27
		needRetarget = false
		conditionals.target = nil
		local maxHPLost = 0
		
		-- 优先检查团队
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local unit = "raid"..i
				local hpLost = UnitHealthMax(unit) - UnitHealth(unit)
				
				-- 检查宠物
				local petUnit = "raidpet"..i
				if UnitExists(petUnit) then
					local petHPLost = UnitHealthMax(petUnit) - UnitHealth(petUnit)
					if petHPLost > maxHPLost then
						-- 临时设置目标为当前候选单位
						conditionals.target = petUnit					
						-- 检查所有条件是否满足
						local allConditionsMet = true
						for k, v in pairs(conditionals) do
							if not CleveRoids.ignoreKeywords[k] then
								if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
									allConditionsMet = false
									break  -- 跳出条件检查循环
								end
							end
						end						
						-- 如果所有条件都满足，选择此单位
						if allConditionsMet then
							maxHPLost = petHPLost
						else
							conditionals.target = nil
						end	
					end
				end
				
				-- 检查队员
				if hpLost > maxHPLost then
					-- 临时设置目标为当前候选单位
					conditionals.target = unit					
					-- 检查所有条件是否满足
					local allConditionsMet = true
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end						
					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						maxHPLost = hpLost
					else
						conditionals.target = nil
					end	
				end
			end
		-- 没有团队则检查队伍
		elseif GetNumPartyMembers() > 0 then
			for i = 1, GetNumPartyMembers() do
				local unit = "party"..i
				local hpLost = UnitHealthMax(unit) - UnitHealth(unit)
				
				-- 检查宠物
				local petUnit = "partypet"..i
				if UnitExists(petUnit) then
					local petHPLost = UnitHealthMax(petUnit) - UnitHealth(petUnit)
					if petHPLost > maxHPLost then
						-- 临时设置目标为当前候选单位
						conditionals.target = petUnit					
						-- 检查所有条件是否满足
						local allConditionsMet = true
						for k, v in pairs(conditionals) do
							if not CleveRoids.ignoreKeywords[k] then
								if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
									allConditionsMet = false
									break  -- 跳出条件检查循环
								end
							end
						end						
						-- 如果所有条件都满足，选择此单位
						if allConditionsMet then
							maxHPLost = petHPLost
						else
							conditionals.target = nil
						end	
					end
				end
				
				-- 检查队员
				if hpLost > maxHPLost then
					-- 临时设置目标为当前候选单位
					conditionals.target = unit					
					-- 检查所有条件是否满足
					local allConditionsMet = true
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end						
					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						maxHPLost = hpLost
					else
						conditionals.target = nil
					end	
				end
			end
		end

		-- 检查自己和自己的宠物
		local selfHPLost = UnitHealthMax("player") - UnitHealth("player")
		if selfHPLost > maxHPLost then
			-- 临时设置目标为当前候选单位
			conditionals.target = "player"			
			-- 检查所有条件是否满足
			local allConditionsMet = true
			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end						
			-- 如果所有条件都满足，选择此单位
			if allConditionsMet then
				maxHPLost = selfHPLost
			else
				conditionals.target = nil
			end		
		end
		
		if UnitExists("pet") then
			local petHPLost = UnitHealthMax("pet") - UnitHealth("pet")
			if petHPLost > maxHPLost then
				-- 临时设置目标为当前候选单位
				conditionals.target = "pet"				
				-- 检查所有条件是否满足
				local allConditionsMet = true
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end						
				-- 如果所有条件都满足，选择此单位
				if allConditionsMet then
					maxHPLost = petHPLost
				else
					conditionals.target = nil
				end	
			end
		end
	end
	
	if conditionals.target == "filterparty" then -- 新增@filterparty支持 by 武藤纯子酱 2025.8.1
		needRetarget = false
		conditionals.target = nil
		local maxHPLost = 0
		
		-- 检查队伍成员
		for i = 1, GetNumPartyMembers() do			
			-- 检查队员
			local unit = "party"..i			
			if UnitExists(unit) then
				-- 临时设置目标为当前候选单位
				conditionals.target = unit				
				-- 检查所有条件是否满足
				local allConditionsMet = true			
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end	

				-- 如果所有条件都满足，选择此单位
				if allConditionsMet then
					break  -- 跳出单位遍历循环
				else
					conditionals.target = nil
				end
			end
			
			-- 检查宠物
			local petUnit = "partypet"..i
			if UnitExists(petUnit) then
				-- 临时设置目标为当前候选单位
				conditionals.target = petUnit				
				-- 检查所有条件是否满足
				local allConditionsMet = true			
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end	

				-- 如果所有条件都满足，选择此单位
				if allConditionsMet then
					break  -- 跳出单位遍历循环
				else
					conditionals.target = nil
				end
			end			
		end

		if conditionals.target == nil then
			-- 临时设置目标为当前候选单位
			conditionals.target = "player"			
			-- 检查自己和自己的宠物
			local allConditionsMet = true

			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end
			
			if conditionals.target == nil and UnitExists("pet") then		
				-- 临时设置目标为当前候选单位
				conditionals.target = "pet"			
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end
				
				if not allConditionsMet then
					conditionals.target = nil
				end
			end
		end
	end	
	
	if conditionals.target == "filterraid" then -- 新增@filterraid支持 by 武藤纯子酱 2025.8.1
		needRetarget = false
		conditionals.target = nil
		local maxHPLost = 0
		
		-- 检查团队成员
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do			
				-- 检查队员
				local unit = "raid"..i			
				if UnitExists(unit) then
					-- 临时设置目标为当前候选单位
					conditionals.target = unit				
					-- 检查所有条件是否满足
					local allConditionsMet = true			
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end	

					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						break  -- 跳出单位遍历循环
					else
						conditionals.target = nil
					end
				end
				
				-- 检查宠物
				local petUnit = "raidpet"..i
				if UnitExists(petUnit) then
					-- 临时设置目标为当前候选单位
					conditionals.target = petUnit				
					-- 检查所有条件是否满足
					local allConditionsMet = true			
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end	

					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						break  -- 跳出单位遍历循环
					else
						conditionals.target = nil
					end
				end			
			end
		end
		
		if conditionals.target == nil then
			-- 临时设置目标为当前候选单位
			conditionals.target = "player"			
			-- 检查自己和自己的宠物
			local allConditionsMet = true

			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end
			
			if conditionals.target == nil and UnitExists("pet") then
				-- 临时设置目标为当前候选单位
				conditionals.target = "pet"			
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end
				
				if not allConditionsMet then
					conditionals.target = nil
				end
			end
		end
	end	
	
	if conditionals.target == "filter" then -- 新增@filter支持 by 武藤纯子酱 2025.8.1
		needRetarget = false
		conditionals.target = nil
		local maxHPLost = 0
		
		-- 检查团队成员
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do			
				-- 检查队员
				local unit = "raid"..i			
				if UnitExists(unit) then
					-- 临时设置目标为当前候选单位
					conditionals.target = unit				
					-- 检查所有条件是否满足
					local allConditionsMet = true			
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end	

					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						break  -- 跳出单位遍历循环
					else
						conditionals.target = nil
					end
				end
				
				-- 检查宠物
				local petUnit = "raidpet"..i
				if UnitExists(petUnit) then
					-- 临时设置目标为当前候选单位
					conditionals.target = petUnit				
					-- 检查所有条件是否满足
					local allConditionsMet = true			
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end	

					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						break  -- 跳出单位遍历循环
					else
						conditionals.target = nil
					end
				end			
			end
		-- 没有团队则检查队伍
		elseif GetNumPartyMembers() > 0 then
			for i = 1, GetNumPartyMembers() do			
				-- 检查队员
				local unit = "party"..i			
				if UnitExists(unit) then
					-- 临时设置目标为当前候选单位
					conditionals.target = unit				
					-- 检查所有条件是否满足
					local allConditionsMet = true			
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end	

					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						break  -- 跳出单位遍历循环
					else
						conditionals.target = nil
					end
				end
				
				-- 检查宠物
				local petUnit = "partypet"..i
				if UnitExists(petUnit) then
					-- 临时设置目标为当前候选单位
					conditionals.target = petUnit				
					-- 检查所有条件是否满足
					local allConditionsMet = true			
					for k, v in pairs(conditionals) do
						if not CleveRoids.ignoreKeywords[k] then
							if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
								allConditionsMet = false
								break  -- 跳出条件检查循环
							end
						end
					end	

					-- 如果所有条件都满足，选择此单位
					if allConditionsMet then
						break  -- 跳出单位遍历循环
					else
						conditionals.target = nil
					end
				end			
			end
		end
		
		if conditionals.target == nil then
			-- 临时设置目标为当前候选单位
			conditionals.target = "player"			
			-- 检查自己和自己的宠物
			local allConditionsMet = true

			for k, v in pairs(conditionals) do
				if not CleveRoids.ignoreKeywords[k] then
					if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
						allConditionsMet = false
						break  -- 跳出条件检查循环
					end
				end
			end
			
			if conditionals.target == nil and UnitExists("pet") then
				-- 临时设置目标为当前候选单位
				conditionals.target = "pet"			
				for k, v in pairs(conditionals) do
					if not CleveRoids.ignoreKeywords[k] then
						if CleveRoids.Keywords[k] and not CleveRoids.Keywords[k](conditionals) then
							allConditionsMet = false
							break  -- 跳出条件检查循环
						end
					end
				end
				
				if not allConditionsMet then
					conditionals.target = nil
				end
			end
		end
	end
	
	if conditionals.target == "inherit" then -- 新增@inherit支持 by 武藤纯子酱 2025.8.10
		needRetarget = false
		if CleveRoids.MacroTarget then		
			conditionals.target = CleveRoids.MacroTarget
		end
	end
	
	for k, v in pairs(conditionals) do
		if not CleveRoids.ignoreKeywords[k] then
			if not CleveRoids.Keywords[k] or not CleveRoids.Keywords[k](conditionals) then
				if needRetarget then
					TargetLastTarget()
					needRetarget = false
				end
				conditionals.target = origTarget
				return false
			end
		end
	end

	if conditionals.target then CleveRoids.MacroTarget = conditionals.target end -- 新增CleveRoids.MacroTarget用于记录上一个宏语句的目标 by 武藤纯子酱 2025.8.10
	
    if conditionals.target ~= nil and targetBeforeAction and not (CleveRoids.hasSuperwow and (action == CastSpellByName or action == CleveRoids.DoUse)) then	-- 新增/use /userandom 支持@条件使用 by 武藤纯子酱 2025.7.21
        if not UnitIsUnit("target", conditionals.target) then
            if SpellIsTargeting() then
                SpellStopCasting()
            end
			
			if not CleveRoids.hasSuperwow and action ~= PetAttack then -- 修复，当有superwow的情况下不需要切换目标 by 武藤纯子酱 2025.9.1
				TargetUnit(conditionals.target)
				needRetarget = true
			end
        else
             if needRetarget then needRetarget = false end
        end
    elseif needRetarget then
        TargetLastTarget()
        needRetarget = false
    end

    if action == "STOPMACRO" then
        CleveRoids.stopmacro = true
        return true
    end

    local result = true
    if string.sub(msg, 1, 1) == "{" and string.sub(msg, -1) == "}" then
        if string.sub(msg, 2, 2) == "\"" and string.sub(msg, -2,-2) == "\"" then
            result = CleveRoids.ExecuteMacroBody(string.sub(msg, 3, -3), true)
        else
            result = CleveRoids.ExecuteMacroByName(string.sub(msg, 2, -2))
        end
    else -- This 'else' corresponds to 'if string.sub(msg, 1, 1) == "{"...'
        local castMsg = msg
        if action == CastSpellByName and not string.find(msg, "%(.*%)") then
            local sp = CleveRoids.GetSpell(msg)
            local rank = sp and (sp.rank or (sp.highest and sp.highest.rank))
            if rank and rank ~= "" then
                castMsg = msg .. "(" .. rank .. ")"
            end
        end	
        if CleveRoids.hasSuperwow and action == CastSpellByName and conditionals.target then
			CastSpellByName(castMsg, conditionals.target) -- SuperWoW handles targeting via argument
 		elseif cursortarget and (action == CastSpellByName or action == CleveRoids.DoUse) then -- 新增@cursor支持 by 武藤纯子酱 2025.7.21
			if UnitExists("target") then
				ClearTarget()
				action(castMsg)
				CameraOrSelectOrMoveStart()
				CameraOrSelectOrMoveStop()
				SpellStopTargeting()
				TargetLastTarget()
			else
				action(castMsg)
				CameraOrSelectOrMoveStart()
				CameraOrSelectOrMoveStop()
				SpellStopTargeting()
				ClearTarget()				
			end  
        elseif action == CastSpellByName then
             -- For standard CastSpellByName, targeting is handled by the TargetUnit call above.
             -- Pass only the spell name.
            action(castMsg)
        else
            -- For other actions like UseContainerItem etc.
            action(msg)
        end
    end

    if needRetarget then
        TargetLastTarget()
    end
	CleveRoids.MouseDown = nil -- 修改 by 武藤纯子酱 2025.9.4
    conditionals.target = origTarget
    return result
end

-- Attempts to cast a single spell from the given set of conditional spells
-- msg: The player's macro text
function CleveRoids.DoCast(msg)
    local handled = false

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        if CleveRoids.DoWithConditionals(v, CleveRoids.Hooks.CAST_SlashCmd, CleveRoids.FixEmptyTarget, not CleveRoids.hasSuperwow, CastSpellByName) then
            -- If a spell is successfully attempted, immediately exit to prevent casting multiple spells.
            return true
        end
    end
    return false
end

-- Target using GUIDs (actually unit tokens) and correct targeting.
function CleveRoids.DoTarget(msg)
    local action, conditionals = CleveRoids.GetParsedMsg(msg)

    if action ~= "" or not next(conditionals) then
        CleveRoids.Hooks.TARGET_SlashCmd(msg)
        return true
    end

    -- Validate a *unit token* against parsed conditionals
    local function IsGuidValid(unitTok, conds)
        if not unitTok or not UnitExists(unitTok) or UnitIsDeadOrGhost(unitTok) then
            return false
        end
        local orig = conds.target
        conds.target = unitTok
        local ok = true
        for k, _ in pairs(conds) do
            if not CleveRoids.ignoreKeywords[k] then
                local fn = CleveRoids.Keywords[k]
                if not fn or not fn(conds) then ok = false; break end
            end
        end
        conds.target = orig
        return ok
    end

    ----------------------------------------------------------------
    -- FAST-PATH: explicit @unit (e.g. [@mouseover], [@focus], [@party1])
    ----------------------------------------------------------------
    do
        local unitTok = conditionals.target

        -- Resolve @mouseover to an actual unit token that exists (works on pfUI frames)
        if unitTok == "mouseover" then
            if UnitExists("mouseover") then
                unitTok = "mouseover"
            elseif CleveRoids.mouseoverUnit and UnitExists(CleveRoids.mouseoverUnit) then
                unitTok = CleveRoids.mouseoverUnit
            elseif pfUI and pfUI.uf and pfUI.uf.mouseover and pfUI.uf.mouseover.unit
               and UnitExists(pfUI.uf.mouseover.unit) then
                unitTok = pfUI.uf.mouseover.unit
            else
                unitTok = nil
            end
        end

        -- Resolve @focus via pfUI focus emulation if present
        if unitTok == "focus" and pfUI and pfUI.uf and pfUI.uf.focus
           and pfUI.uf.focus.label and pfUI.uf.focus.id then
            local fTok = pfUI.uf.focus.label .. pfUI.uf.focus.id
            if UnitExists(fTok) then unitTok = fTok else unitTok = nil end
        end

        -- If explicit unit resolves and passes conditionals, target it now (works out of range)
        if unitTok and UnitExists(unitTok) and IsGuidValid(unitTok, conditionals) then
            TargetUnit(unitTok)
            return true
        end
    end
    ----------------------------------------------------------------

    -- 1) Keep current target if already valid
    if UnitExists("target") and IsGuidValid("target", conditionals) then
        return true
    end

    -- 2) Build candidates: party1..4 and raid1..40 (not mutually exclusive)
    local candidates = {}

    -- Party
    for i = 1, 4 do
        local u = "party"..i
        if UnitExists(u) then table.insert(candidates, { unitId = u }) end
    end

    -- Raid (all 1..40)
    for i = 1, 40 do
        local u = "raid"..i
        if UnitExists(u) then table.insert(candidates, { unitId = u }) end
    end

    -- Optional: also consider targettarget and mouseover if present
    if UnitExists("targettarget") then table.insert(candidates, { unitId = "targettarget" }) end
    if UnitExists("mouseover") then table.insert(candidates, { unitId = "mouseover" }) end

    -- 3) Find first valid and target it
    for _, c in ipairs(candidates) do
        if IsGuidValid(c.unitId, conditionals) then
            TargetUnit(c.unitId)
            return true
        end
    end

    -- 4) Nothing found; preserve original target
    return true
end


-- Attempts to attack a unit by a set of conditionals
-- msg: The raw message intercepted from a /petattack command
function CleveRoids.DoPetAction(action, msg)
    local handled = false

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        if CleveRoids.DoWithConditionals(v, action, CleveRoids.FixEmptyTarget, true, action) then
            handled = true
            break
        end
    end
    return handled
end

-- Attempts to conditionally start an attack. Returns false if no conditionals are found.
function CleveRoids.DoConditionalStartAttack(msg)
    if not string.find(msg, "%[") then return false end

    local handled = false
    local action = function()
        if not UnitExists("target") or UnitIsDead("target") then TargetNearestEnemy() end
        if not CleveRoids.CurrentSpell.autoAttack and not CleveRoids.CurrentSpell.autoAttackLock and UnitExists("target") and UnitCanAttack("player", "target") then
            CleveRoids.CurrentSpell.autoAttackLock = true
            CleveRoids.autoAttackLockElapsed = GetTime()
            AttackTarget()
        end
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        -- We pass 'nil' for the hook, so DoWithConditionals does nothing if it fails to parse conditionals.
        if CleveRoids.DoWithConditionals(v, nil, CleveRoids.FixEmptyTarget, false, action) then
            handled = true
            break
        end
    end
    return handled
end

-- Attempts to conditionally stop an attack. Returns false if no conditionals are found.
function CleveRoids.DoConditionalStopAttack(msg)
    if not string.find(msg, "%[") then return false end

    local handled = false
    local action = function()
        if CleveRoids.CurrentSpell.autoAttack and UnitExists("target") then
            AttackTarget()
            CleveRoids.CurrentSpell.autoAttack = false
        end
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        if CleveRoids.DoWithConditionals(v, nil, CleveRoids.FixEmptyTarget, false, action) then
            handled = true
            break
        end
    end
    return handled
end

-- Attempts to conditionally stop casting. Returns false if no conditionals are found.
function CleveRoids.DoConditionalStopCasting(msg)
    if not string.find(msg, "%[") then return false end

    local handled = false
    local action = function()
        SpellStopCasting()
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        if CleveRoids.DoWithConditionals(v, nil, CleveRoids.FixEmptyTarget, false, action) then
            handled = true
            break
        end
    end
    return handled
end

-- Attempts to use or equip an item from the player's inventory by a  set of conditionals
-- Also checks if a condition is a spell so that you can mix item and spell use
-- msg: The raw message intercepted from a /use or /equip command
function CleveRoids.DoUse(msg)
    local handled = false
	local hasCursorCondition = string.find(msg, "@cursor") or string.find(msg, "target=cursor") -- 新增：检查是否存在@cursor条件 by 武藤纯子酱 2025.7.21
	local onself = string.find(msg, "@player") or string.find(msg, "target=player") -- 新增：检查是否存在@player条件 by 武藤纯子酱 2025.9.2
    local action = function(msg)
        -- Try to interpret the message as a direct inventory slot ID first.
        local slotId = tonumber(msg)
        if slotId and slotId >= 1 and slotId <= 19 then -- Character slots are 1-19
			PickupInventoryItem(slotId) -- 支持盗贼正式服上毒宏写法 by 武藤纯子酱 2025.7.30
			if CursorHasItem() then
				EquipCursorItem(slotId)
			end
            UseInventoryItem(slotId)			
            return -- Exit after using the item by slot.
        end

		-- 新增：处理@cursor逻辑 by 武藤纯子酱 2025.7.21
        if hasCursorCondition then
			-- Original logic: if it's not a slot number, try to resolve by name.
            local item = CleveRoids.GetItem(msg)

			if UnitExists("target") then
				ClearTarget()
				if item and item.inventoryID then
					-- This is for using an already-equipped item (like a trinket).
					-- This action does not cause an inventory change that needs a fast re-index.
					return UseInventoryItem(item.inventoryID)
				elseif item and item.bagID then
					-- This will use an item from a bag. It could be a potion (use) or a weapon (equip).
					-- We need to check if it's an equippable item before using it.
					local isEquippable = false
					local itemName, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(item.id) -- 修复从装备ID获取装备信息 by 武藤纯子酱 2025.8.3
					if itemName and itemEquipLoc and itemEquipLoc ~= "" then
						isEquippable = true
					end

					CleveRoids.GetNextBagSlotForUse(item, msg)
					UseContainerItem(item.bagID, item.slot)

					-- If it was an equippable item, force a cache refresh on the next inventory event.
					if isEquippable then
						CleveRoids.lastItemIndexTime = 0
					end
				end
				CameraOrSelectOrMoveStart()
				CameraOrSelectOrMoveStop()
				SpellStopTargeting()
				TargetLastTarget()
			else
				if item and item.inventoryID then
					-- This is for using an already-equipped item (like a trinket).
					-- This action does not cause an inventory change that needs a fast re-index.
					return UseInventoryItem(item.inventoryID)
				elseif item and item.bagID then
					-- This will use an item from a bag. It could be a potion (use) or a weapon (equip).
					-- We need to check if it's an equippable item before using it.
					local isEquippable = false
					local itemName, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(item.id) -- 修复从装备ID获取装备信息 by 武藤纯子酱 2025.8.3
					if itemName and itemEquipLoc and itemEquipLoc ~= "" then
						isEquippable = true
					end

					CleveRoids.GetNextBagSlotForUse(item, msg)
					UseContainerItem(item.bagID, item.slot)

					-- If it was an equippable item, force a cache refresh on the next inventory event.
					if isEquippable then
						CleveRoids.lastItemIndexTime = 0
					end
				end
				CameraOrSelectOrMoveStart()
				CameraOrSelectOrMoveStop()
				SpellStopTargeting()
				ClearTarget()				
			end

            return
        end

        -- Original logic: if it's not a slot number, try to resolve by name.
        local item = CleveRoids.GetItem(msg)

        if item and item.inventoryID then
            -- This is for using an already-equipped item (like a trinket).
            -- This action does not cause an inventory change that needs a fast re-index.
            return UseInventoryItem(item.inventoryID)
        elseif item and item.bagID then
            -- This will use an item from a bag. It could be a potion (use) or a weapon (equip).
            -- We need to check if it's an equippable item before using it.
            local isEquippable = false
            local itemName, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(item.id) -- 修复从装备ID获取装备信息 by 武藤纯子酱 2025.8.3
            if itemName and itemEquipLoc and itemEquipLoc ~= "" then
                isEquippable = true
            end

            CleveRoids.GetNextBagSlotForUse(item, msg)
			PickupContainerItem(item.bagID, item.slot) -- 支持猎人正式服喂宝宝宏写法 by 武藤纯子酱 2025.7.30
			if CursorHasItem() then
				PickupContainerItem(item.bagID, item.slot)
			end
			
			if onself then -- 新增，当有@player时，对自己使用 by 武藤纯子酱 2025.9.2
				UseContainerItem(item.bagID, item.slot, 1)
			else
				UseContainerItem(item.bagID, item.slot)
			end

            -- If it was an equippable item, force a cache refresh on the next inventory event.
            if isEquippable then
                CleveRoids.lastItemIndexTime = 0
            end
            return
        end

        if (MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1) then return end
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        v = string.gsub(v, "^%?", "")
        local subject = v
        local _,e = string.find(v,"%]")
        if e then subject = CleveRoids.Trim(string.sub(v,e+1)) end

        local wasHandled = false
        -- If the subject is not a number, check if it's a spell.
        if (not tonumber(subject)) and CleveRoids.GetSpell(subject) then
            wasHandled = CleveRoids.DoWithConditionals(v, CleveRoids.Hooks.CAST_SlashCmd, CleveRoids.FixEmptyTarget, not CleveRoids.hasSuperwow, CastSpellByName)
        else
            -- Otherwise, treat it as an item (by name or slot ID).
            wasHandled = CleveRoids.DoWithConditionals(v, action, CleveRoids.FixEmptyTarget, false, action)
        end
        if wasHandled then
            handled = true
            break
        end
    end
	CleveRoids.IndexItems()	-- 修复对魔法制造的单个物品使用后不刷新背包的BUG by 武藤纯子酱 2025.8.16
    return handled -- Corrected typo from 'Handled' to 'handled'
end

function CleveRoids.EquipBagItem(msg, offhand)
    -- First, get item data from the addon's own reliable cache.
    local item = CleveRoids.GetItem(msg)
    if not item or not item.name then
        -- If the addon can't find the item at all, do nothing.
        return false
    end

    local invslot = offhand and 17 or 16 -- 17 is off-hand, 16 is main-hand

    -- Now, check the currently equipped item using live game data.
    local currentItemLink = GetInventoryItemLink("player", invslot)
    if currentItemLink then
		local _,_,itemId = string.find(currentItemLink,"item:(%d+)") --修复 by 武藤纯子酱 2025.8.4		
        local currentItemName = GetItemInfo(itemId)
        if currentItemName and currentItemName == item.name then
            -- The correct item is already in the correct slot. Stop here.
            return true
        end
    end

    -- If the check above fails, proceed with the original logic to equip the item.
    -- We can reuse the 'item' object we already found.
    if not item.bagID and not item.inventoryID then
        return false
    end

    if item.bagID then
        CleveRoids.GetNextBagSlotForUse(item, msg)
        PickupContainerItem(item.bagID, item.slot)
    else
        PickupInventoryItem(item.inventoryID)
    end

    EquipCursorItem(invslot)
    ClearCursor()

    CleveRoids.lastItemIndexTime = 0

    return true
end

-- TODO: Refactor all these DoWithConditionals sections
function CleveRoids.DoEquipMainhand(msg)
    local handled = false

    local action = function(msg)
        return CleveRoids.EquipBagItem(msg, false)
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        v = string.gsub(v, "^%?", "")

        if CleveRoids.DoWithConditionals(v, action, CleveRoids.FixEmptyTarget, false, action) then
            handled = true
            break
        end
    end
    return handled
end

function CleveRoids.DoEquipOffhand(msg)
    local handled = false

    local action = function(msg)
        return CleveRoids.EquipBagItem(msg, true)
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        v = string.gsub(v, "^%?", "")

        if CleveRoids.DoWithConditionals(v, action, CleveRoids.FixEmptyTarget, false, action) then
            handled = true
            break
        end
    end
    return handled
end

function CleveRoids.DoUnshift(msg)
    local handled

    local action = function(msg)
        local currentShapeshiftIndex = CleveRoids.GetCurrentShapeshiftIndex()
        if currentShapeshiftIndex ~= 0 then
			if CleveRoids.playerClass == "PRIEST" or CleveRoids.playerClass == "ROGUE" then
				CancelPlayerBuff(currentShapeshiftIndex)	--修复 by 武藤纯子酱 2025.7.20	
			else
				CastShapeshiftForm(currentShapeshiftIndex)
			end
        end
    end

    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(msg)) do
        handled = false
        if CleveRoids.DoWithConditionals(v, action, CleveRoids.FixEmptyTarget, false, action) then
            handled = true
            break
        end
    end

    if handled == nil then
        action()
    end

    return handled
end

function CleveRoids.DoRetarget()
    if GetUnitName("target") == nil
        or UnitHealth("target") == 0
        or not UnitCanAttack("player", "target")
    then
        ClearTarget()
        TargetNearestEnemy()
    end
end

-- Attempts to stop macro
 function CleveRoids.DoStopMacro(msg)
    local handled = false
    for k, v in pairs(CleveRoids.splitStringIgnoringQuotes(CleveRoids.Trim(msg))) do
        if CleveRoids.DoWithConditionals(msg, nil, nil, not CleveRoids.hasSuperwow, "STOPMACRO") then
            handled = true -- we parsed at least one command
            break
        end
    end
    return handled
end

function CleveRoids.DoCastSequence(sequence)
    if not CleveRoids.hasSuperwow then
        CleveRoids.Print("|cFFFF0000/castsequence|r requires |cFF00FFFFSuperWoW|r.")
        return
    end

    if CleveRoids.currentSequence and not CleveRoids.CheckSpellCast("player") then
        CleveRoids.currentSequence = nil
    elseif CleveRoids.currentSequence then
        return
    end

    if sequence and sequence.index and sequence.index > 1 then -- 修复 by 武藤纯子酱 2025.8.21
        if sequence.reset then
            for k, _ in sequence.reset do
                if CleveRoids.kmods[k] and CleveRoids.kmods[k]() then
                    CleveRoids.ResetSequence(sequence)
                end
            end
        end
    end

    local active = CleveRoids.GetCurrentSequenceAction(sequence)
    if active and active.action then
        sequence.status = 0
        sequence.lastUpdate = GetTime()
        sequence.expires = 0

        CleveRoids.currentSequence = sequence

        local action = (sequence.cond or "") .. active.action
        local result = CleveRoids.DoWithConditionals(action, nil, CleveRoids.FixEmptyTarget, not CleveRoids.hasSuperwow, CastSpellByName) -- 修复支持默认目标 by 武藤纯子酱 2025.8.21

        return result
    end
end

CleveRoids.DoConditionalCancelAura = function(msg)
    local trimmedMsg = CleveRoids.Trim(msg or "")

    if trimmedMsg == "" then
        return false
    end
    if CleveRoids.DoWithConditionals(trimmedMsg, nil, CleveRoids.FixEmptyTarget, false, CleveRoids.CancelAura) then
        return true
    else
        return false
    end
end

function CleveRoids.OnUpdate(self)
    local time = GetTime()
	local refreshRate = CleveRoidMacros.refresh or 5
	refreshRate = 1/refreshRate
    if CleveRoids.initializationTimer and time >= CleveRoids.initializationTimer then
        CleveRoids.IndexItems()
        CleveRoids.IndexActionBars()
        CleveRoids.ready = true
        CleveRoids.initializationTimer = nil
        CleveRoids.TestForAllActiveActions()
        CleveRoids.lastUpdate = time
        return
    end
    if not CleveRoids.ready then return end

    -- Throttle the update loop to avoid excessive CPU usage.
    if (time - CleveRoids.lastUpdate) < refreshRate then return end
    CleveRoids.lastUpdate = time
    -- Check the saved variable to decide which update mode to use.
    if CleveRoidMacros.realtime == 1 then
        -- Realtime Mode: Force an update on every throttled tick for maximum responsiveness.
        CleveRoids.TestForAllActiveActions()
    else
        -- Event-Driven Mode (Default): Only update if a relevant game event has queued it.
        if CleveRoids.isActionUpdateQueued then
            CleveRoids.TestForAllActiveActions()
            CleveRoids.isActionUpdateQueued = false -- Reset the flag after updating
        end
    end

    -- The rest of this function handles time-based logic that must always run.
    if CleveRoids.CurrentSpell.autoAttackLock and (time - CleveRoids.autoAttackLockElapsed) > refreshRate then
        CleveRoids.CurrentSpell.autoAttackLock = false
        CleveRoids.autoAttackLockElapsed = nil
    end

    for _, sequence in pairs(CleveRoids.Sequences) do
        if sequence.index > 1 and sequence.reset.secs and (time - (sequence.lastUpdate or 0)) >= sequence.reset.secs then
            CleveRoids.ResetSequence(sequence)
        end
    end

    for guid,cast in pairs(CleveRoids.spell_tracking) do
        if time > cast.expires then
            CleveRoids.spell_tracking[guid] = nil
        end
    end
end

-- Initialize the nested table for the GameTooltip hooks if it doesn't exist
if not CleveRoids.Hooks.GameTooltip then CleveRoids.Hooks.GameTooltip = {} end

-- Save the original GameTooltip.SetAction function before we override it
CleveRoids.Hooks.GameTooltip.SetAction = GameTooltip.SetAction

-- Now, define our custom version of the function
function GameTooltip.SetAction(self, slot)
    local actions = CleveRoids.GetAction(slot)

    local action_to_display_info = nil
    if actions then
        if actions.active then
            action_to_display_info = actions.active
        elseif actions.tooltip then
            action_to_display_info = actions.tooltip
        end
    end

    if action_to_display_info and action_to_display_info.action then
        local action_name = action_to_display_info.action

        -- NEW: Check if action is a slot ID for tooltip
        local slotId = tonumber(action_name)
        if slotId and slotId >= 1 and slotId <= 19 then
            -- Use the more specific SetInventoryItem function to prevent conflicts with other addons.
            GameTooltip:SetInventoryItem("player", slotId)
            GameTooltip:Show()
            return
        end
        -- End new logic

        local current_spell_data = CleveRoids.GetSpell(action_name)
        if current_spell_data then
            GameTooltip:SetSpell(current_spell_data.spellSlot, current_spell_data.bookType)
            local rank_info = current_spell_data.rank or (current_spell_data.highest and current_spell_data.highest.rank)
            if rank_info and rank_info ~= "" then
                GameTooltipTextRight1:SetText("|cff808080" .. rank_info .. "|r")
            else
                GameTooltipTextRight1:SetText("")
            end
            GameTooltipTextRight1:Show()
            GameTooltip:Show()
            return
        end

        local current_item_data = CleveRoids.GetItem(action_name)
        if current_item_data then
            -- Use specific functions based on where the item is located.
            if current_item_data.inventoryID then
                GameTooltip:SetInventoryItem("player", current_item_data.inventoryID)
            elseif current_item_data.bagID and current_item_data.slot then
                GameTooltip:SetBagItem(current_item_data.bagID, current_item_data.slot)
            else
                -- Fallback to the original method if location is unknown.
                GameTooltip:SetHyperlink(current_item_data.link)
            end
            GameTooltip:Show()
            return
        end

        if action_to_display_info.macro and type(action_to_display_info.macro) == "table" then
            local nested_action_info = action_to_display_info.macro
            local nested_action_name = nested_action_info.action

            current_spell_data = CleveRoids.GetSpell(nested_action_name)
            if current_spell_data then
                GameTooltip:SetSpell(current_spell_data.spellSlot, current_spell_data.bookType)
                local rank_info = current_spell_data.rank or (current_spell_data.highest and current_spell_data.highest.rank)
                if rank_info and rank_info ~= "" then
                    GameTooltipTextRight1:SetText("|cff808080" .. rank_info .. "|r")
                else
                    GameTooltipTextRight1:SetText("")
                end
                GameTooltipTextRight1:Show()
                GameTooltip:Show()
                return
            end

            current_item_data = CleveRoids.GetItem(nested_action_name)
            if current_item_data then
                 if current_item_data.inventoryID then
                    GameTooltip:SetInventoryItem("player", current_item_data.inventoryID)
                elseif current_item_data.bagID and current_item_data.slot then
                    GameTooltip:SetBagItem(current_item_data.bagID, current_item_data.slot)
                else
                    GameTooltip:SetHyperlink(current_item_data.link)
                end
                GameTooltip:Show()
                return
            end
        end
    end

    -- If none of our custom logic handled it, call the original function we saved earlier.
    CleveRoids.Hooks.GameTooltip.SetAction(self, slot)
end

CleveRoids.Hooks.PickupAction = PickupAction
function PickupAction(slot)
    CleveRoids.ClearAction(slot)
    CleveRoids.ClearSlot(CleveRoids.actionSlots, slot)
    CleveRoids.ClearAction(CleveRoids.reactiveSlots, slot)
    return CleveRoids.Hooks.PickupAction(slot)
end

CleveRoids.Hooks.ActionHasRange = ActionHasRange
function ActionHasRange(slot)
    local actions = CleveRoids.GetAction(slot)
    if actions and actions.active then
        return (1 and actions.active.inRange ~= -1 or nil)
    else
        return CleveRoids.Hooks.ActionHasRange(slot)
    end
end

CleveRoids.Hooks.IsActionInRange = IsActionInRange
function IsActionInRange(slot, unit)
    local actions = CleveRoids.GetAction(slot)
    if actions and actions.active and actions.active.type == "spell" then
        return actions.active.inRange
    else
        return CleveRoids.Hooks.IsActionInRange(slot, unit)
    end
end

CleveRoids.Hooks.OriginalIsUsableAction = IsUsableAction
CleveRoids.Hooks.IsUsableAction = IsUsableAction
function IsUsableAction(slot, unit)
    local actions = CleveRoids.GetAction(slot)
    if actions and actions.active then
        return actions.active.usable, actions.active.oom
    else
        return CleveRoids.Hooks.IsUsableAction(slot, unit)
    end
end

CleveRoids.Hooks.IsCurrentAction = IsCurrentAction
function IsCurrentAction(slot)
    local active = CleveRoids.GetActiveAction(slot)

    if not active then
        return CleveRoids.Hooks.IsCurrentAction(slot)
    else
        local name
        if active.spell then
            local rank = active.spell.rank or active.spell.highest.rank
            name = active.spell.name..(rank and ("("..rank..")"))
        elseif active.item then
            name = active.item.name
        end

        return CleveRoids.Hooks.IsCurrentAction(CleveRoids.GetProxyActionSlot(name) or slot)
    end
end

CleveRoids.Hooks.GetActionTexture = GetActionTexture
function GetActionTexture(slot)
    local actions = CleveRoids.GetAction(slot)

    if actions and (actions.active or actions.tooltip) then
        local proxySlot = (actions.active and actions.active.spell) and CleveRoids.GetProxyActionSlot(actions.active.spell.name)
        if proxySlot and CleveRoids.Hooks.GetActionTexture(proxySlot) ~= actions.active.spell.texture then
            return CleveRoids.Hooks.GetActionTexture(proxySlot)
        else
            return (actions.active and actions.active.texture) or (actions.tooltip and actions.tooltip.texture) or CleveRoids.unknownTexture
        end
    end
    return CleveRoids.Hooks.GetActionTexture(slot)
end

-- TODO: Look into https://github.com/Stanzilla/WoWUIBugs/issues/47 if needed
CleveRoids.Hooks.GetActionCooldown = GetActionCooldown
function GetActionCooldown(slot)
    local actions = CleveRoids.GetAction(slot)
    -- Check for actions.active OR actions.tooltip
    if actions and (actions.active or actions.tooltip) then
        -- Prioritize the active action, but fall back to the tooltip action
        local a = actions.active or actions.tooltip

        local slotId = tonumber(a.action)
        if slotId and slotId >= 1 and slotId <= 19 then
            return GetInventoryItemCooldown("player", slotId)
        end

        if a.spell then
            return GetSpellCooldown(a.spell.spellSlot, a.spell.bookType)
        elseif a.item then
            if a.item.bagID and a.item.slot then
                return GetContainerItemCooldown(a.item.bagID, a.item.slot)
            elseif a.item.inventoryID then
                return GetInventoryItemCooldown("player", a.item.inventoryID)
            end
        end
        return 0, 0, 0
    else
        return CleveRoids.Hooks.GetActionCooldown(slot)
    end
end

CleveRoids.Hooks.GetActionCount = GetActionCount
function GetActionCount(slot)
    local action = CleveRoids.GetAction(slot)
    local count
    if action and action.active then

        local slotId = tonumber(action.active.action)
        if slotId and slotId >= 1 and slotId <= 19 then
            return GetInventoryItemCount("player", slotId)
        end

        if action.active.item then
            count = action.active.item.count
        elseif action.active.spell and action.active.spell.reagent then
            local reagent = CleveRoids.GetItem(action.active.spell.reagent)
            count = reagent and reagent.count
        end
    end

    return count or CleveRoids.Hooks.GetActionCount(slot)
end

CleveRoids.Hooks.IsConsumableAction = IsConsumableAction
function IsConsumableAction(slot)
    local action = CleveRoids.GetAction(slot)
    if action and action.active then

        local slotId = tonumber(action.active.action)
        if slotId and slotId >= 1 and slotId <= 19 then
            local _, count = GetInventoryItemCount("player", slotId)
            if count and count > 0 then return 1 end
        end

        if action.active.item and
            (CleveRoids.countedItemTypes[action.active.item.type]
            or CleveRoids.countedItemTypes[action.active.item.name])
        then
            return 1
        end


        if action.active.spell and action.active.spell.reagent then
            return 1
        end
    end

    return CleveRoids.Hooks.IsConsumableAction(slot)
end

-- Create a hidden tooltip frame to read buff names
if not AuraScanTooltip and not CleveRoids.hasSuperwow then
    CreateFrame("GameTooltip", "AuraScanTooltip")
    AuraScanTooltip:SetOwner(WorldFrame, "ANCHORNONE")
    AuraScanTooltip:AddFontStrings(
        AuraScanTooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
        AuraScanTooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
    )
end


-- This single dummy frame handles events AND serves as our tooltip scanner.
CleveRoids.Frame = CreateFrame("GameTooltip")

-- Create the extra font strings needed for other functions like GetSpellCost.
CleveRoids.Frame.costFontString = CleveRoids.Frame:CreateFontString()
CleveRoids.Frame.rangeFontString = CleveRoids.Frame:CreateFontString()
CleveRoids.Frame.reagentFontString = CleveRoids.Frame:CreateFontString()
CleveRoids.Frame:AddFontStrings(CleveRoids.Frame:CreateFontString(), CleveRoids.Frame:CreateFontString())
CleveRoids.Frame:AddFontStrings(CleveRoids.Frame.costFontString, CleveRoids.Frame.rangeFontString)
CleveRoids.Frame:AddFontStrings(CleveRoids.Frame:CreateFontString(), CleveRoids.Frame:CreateFontString())
CleveRoids.Frame:AddFontStrings(CleveRoids.Frame.reagentFontString, CleveRoids.Frame:CreateFontString())

CleveRoids.Frame:SetScript("OnUpdate", CleveRoids.OnUpdate)
CleveRoids.Frame:SetScript("OnEvent", function(...)
    CleveRoids.Frame[event](this,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)
end)

-- == CORE EVENT REGISTRATION ==
CleveRoids.Frame:RegisterEvent("PLAYER_LOGIN")
CleveRoids.Frame:RegisterEvent("ADDON_LOADED")
CleveRoids.Frame:RegisterEvent("UPDATE_MACROS")
CleveRoids.Frame:RegisterEvent("SPELLS_CHANGED")
CleveRoids.Frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
CleveRoids.Frame:RegisterEvent("BAG_UPDATE")
CleveRoids.Frame:RegisterEvent("UNIT_INVENTORY_CHANGED")

-- == STATE CHANGE EVENT REGISTRATION (for performance) ==
CleveRoids.Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
CleveRoids.Frame:RegisterEvent("PLAYER_FOCUS_CHANGED") -- For focus addons
CleveRoids.Frame:RegisterEvent("PLAYER_ENTER_COMBAT")
CleveRoids.Frame:RegisterEvent("PLAYER_LEAVE_COMBAT")
CleveRoids.Frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
CleveRoids.Frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
CleveRoids.Frame:RegisterEvent("UNIT_AURA")
CleveRoids.Frame:RegisterEvent("UNIT_HEALTH")
CleveRoids.Frame:RegisterEvent("UNIT_POWER")
CleveRoids.Frame:RegisterEvent("UNIT_CASTEVENT")
CleveRoids.Frame:RegisterEvent("START_AUTOREPEAT_SPELL")
CleveRoids.Frame:RegisterEvent("STOP_AUTOREPEAT_SPELL")
CleveRoids.Frame:RegisterEvent("SPELLCAST_CHANNEL_START")
CleveRoids.Frame:RegisterEvent("SPELLCAST_CHANNEL_STOP")


function CleveRoids.Frame:PLAYER_LOGIN()
    _, CleveRoids.playerClass = UnitClass("player")
    _, CleveRoids.playerGuid = UnitExists("player")
    CleveRoids.IndexSpells()
	CleveRoids.GetAllButtons() -- 新增 给全部动作条按钮添加鼠标按键识别 by 武藤纯子酱 2025.7.21	
    CleveRoids.initializationTimer = GetTime() + 1.5
    if not CleveRoids.hasSuperwow or not IsSpellInRange then
        if not CleveRoids.hasSuperwow then
            CleveRoids.Print("|cFFFF0000CleveRoidMacros|r requires |cFF00FFFFbalakethelock's SuperWoW|r:")
            CleveRoids.Print("https://github.com/balakethelock/SuperWoW")
        end
        if not IsSpellInRange then
            CleveRoids.Print("|cFFFF0000IsSpellInRange|r requires |cFF00FFFFpepopo978's Nampower|r:") --修改描述为IsSpellInRange requires Nampower by 武藤纯子酱 2025.8.15
            CleveRoids.Print("https://github.com/pepopo978/nampower")
        end
    else
        CleveRoids.Print("|cFF4477FFCleveR|r|cFFFFFFFFoid Macros|r |cFF00FF00Loaded|r - See the README.")
    end
end

function CleveRoids.Frame:ADDON_LOADED(addon)
    if addon ~= "CleveRoidMacros" then
        return
    else
		DEFAULT_CHAT_FRAME:AddMessage("输入 /cleveroid  或  /cleveroidmacros 对完整宏进行设置")  -- 载入游戏通知 by 迷茫、武藤纯子酱 2025.8.19
    end

    CleveRoids.InitializeExtensions()

    if SuperMacroFrame then
        local hooks = {
            cast = { action = CleveRoids.DoCast },
            target = { action = CleveRoids.DoTarget },
            use = { action = CleveRoids.DoUse },
            castsequence = { action = CleveRoids.DoCastSequence }
        }

        -- Hook SuperMacro's RunLine to stay compatible
        CleveRoids.Hooks.RunLine = RunLine
        CleveRoids.RunLine = function(...)
            for i = 1, arg.n do
                if CleveRoids.stopmacro then
                    CleveRoids.stopmacro = false
                    return true
                end
                local intercepted = false
                local text = arg[i]

                for k,v in pairs(hooks) do
                    local begin, _end = string.find(text, "^/"..k.."%s+[!%[]")
                    if begin then
                        local msg = string.sub(text, _end)
                        v.action(msg)
                        intercepted = true
                        break
                    end
                end

                if not intercepted then
                    CleveRoids.Hooks.RunLine(text)
                end
            end
        end
        RunLine = CleveRoids.RunLine
    end
end

function CleveRoids.Frame:UNIT_CASTEVENT(caster,target,action,spell_id,cast_time)
    if action == "MAINHAND" or action == "OFFHAND" then return end

    -- handle cast spell tracking
    local cast = CleveRoids.spell_tracking[caster]
    if cast_time > 0 and action == "START" or action == "CHANNEL" then
        CleveRoids.spell_tracking[caster] = { spell_id = spell_id, expires = GetTime() + cast_time/1000, type = action, target = target } -- 增加了技能施放目标的参数 by 武藤纯子酱 2025.8.2
    elseif cast
        and (
            (cast.spell_id == spell_id and (action == "FAIL" or action == "CAST"))
            or (GetTime() > cast.expires)
        )
    then
        CleveRoids.spell_tracking[caster] = nil
    end

    -- handle cast sequence
    if CleveRoids.currentSequence and caster == CleveRoids.playerGuid then
        local active = CleveRoids.GetCurrentSequenceAction(CleveRoids.currentSequence)

        local name, rank = SpellInfo(spell_id)
        local isSeqSpell = (active.action == name or active.action == (name.."("..rank..")"))
        if isSeqSpell then
            local status = CleveRoids.currentSequence.status
            if status == 0 and (action == "START" or action == "CHANNEL") and cast_time > 0 then
                CleveRoids.currentSequence.status = 1
                CleveRoids.currentSequence.expires = GetTime() + cast_time - 2000
            elseif (status == 0 and action == "CAST" and cast_time == 0)
                or (status == 1 and action == "CAST" and CleveRoids.currentSequence.expires)
            then
                CleveRoids.currentSequence.status = 2
                CleveRoids.currentSequence.lastUpdate = GetTime()
                CleveRoids.AdvanceSequence(CleveRoids.currentSequence)
                CleveRoids.currentSequence = nil
            elseif action == "INTERRUPTED" or action == "FAILED" then
                CleveRoids.currentSequence.status = 1
            end
        end
    end
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
	if action == "CAST" and UnitIsUnit(caster,"player") then -- 新增delay条件配套施法成功记录 by 武藤纯子酱 2025.8.25
		local spellName = SpellInfo(spell_id)
		CleveRoids.SpellCastTimes[spellName] = GetTime()
	end
end

function CleveRoids.Frame:SPELLCAST_CHANNEL_START()
    CleveRoids.CurrentSpell.type = "channeled"
	--新增 ChannelStart ChannelEnd by 武藤纯子酱 2025.7.24
	CleveRoids.CurrentSpell.ChannelStart = GetTime()
	CleveRoids.CurrentSpell.ChannelEnd = GetTime() + arg1/1000
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:SPELLCAST_CHANNEL_STOP()
    CleveRoids.CurrentSpell.type = ""
    CleveRoids.CurrentSpell.spellName = ""
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:PLAYER_ENTER_COMBAT()
    CleveRoids.CurrentSpell.autoAttack = true
    CleveRoids.CurrentSpell.autoAttackLock = false
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:PLAYER_LEAVE_COMBAT()
    CleveRoids.CurrentSpell.autoAttack = false
    CleveRoids.CurrentSpell.autoAttackLock = false
    for _, sequence in pairs(CleveRoids.Sequences) do
        if CleveRoids.currentSequence ~= sequence and sequence.index > 1 and sequence.reset.combat then
            CleveRoids.ResetSequence(sequence)
        end
    end
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:PLAYER_TARGET_CHANGED()
    CleveRoids.CurrentSpell.autoAttack = false
    CleveRoids.CurrentSpell.autoAttackLock = false

    for _, sequence in pairs(CleveRoids.Sequences) do
        if CleveRoids.currentSequence ~= sequence and sequence.index > 1 and sequence.reset.target then
            CleveRoids.ResetSequence(sequence)
        end
    end
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:UPDATE_MACROS()
    CleveRoids.currentSequence = nil
    -- Explicitly nil tables before re-assignment
    CleveRoids.ParsedMsg = nil;
    CleveRoids.ParsedMsg = {}

    CleveRoids.Macros = nil;
    CleveRoids.Macros = {}

    CleveRoids.Actions = nil;
    CleveRoids.Actions = {}

    CleveRoids.Sequences = nil;
    CleveRoids.Sequences = {}

    CleveRoids.IndexSpells()
    CleveRoids.IndexTalents()
    CleveRoids.IndexActionBars()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:SPELLS_CHANGED()
    CleveRoids.Frame:UPDATE_MACROS()
end

function CleveRoids.Frame:ACTIONBAR_SLOT_CHANGED()
    CleveRoids.ClearAction(arg1)
    CleveRoids.IndexActionSlot(arg1)
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:BAG_UPDATE()
    local now = GetTime()
    -- Only index items if more than 1 second has passed since the last index
    if (now - (CleveRoids.lastItemIndexTime or 0)) > 1.0 then
        CleveRoids.lastItemIndexTime = now
        CleveRoids.IndexItems()

        -- Directly clear all relevant caches and force a UI refresh for all buttons.
        CleveRoids.Actions = {}
        --CleveRoids.Macros = {}
        --CleveRoids.ParsedMsg = {}
        if CleveRoidMacros.realtime == 0 then
            CleveRoids.QueueActionUpdate()
        end
    end
end

function CleveRoids.Frame:UNIT_INVENTORY_CHANGED()
    if arg1 ~= "player" then return end
    CleveRoids.Frame:BAG_UPDATE()
end

function CleveRoids.Frame:START_AUTOREPEAT_SPELL()
    local _, className = UnitClass("player")
    if className == "HUNTER" then
        CleveRoids.CurrentSpell.autoShot = true
    else
        CleveRoids.CurrentSpell.wand = true
    end
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

function CleveRoids.Frame:STOP_AUTOREPEAT_SPELL()
    local _, className = UnitClass("player")
    if className == "HUNTER" then
        CleveRoids.CurrentSpell.autoShot = false
    else
        CleveRoids.CurrentSpell.wand = false
    end
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end

-- Generic event handlers that just queue an update
function CleveRoids.Frame:PLAYER_FOCUS_CHANGED()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end
function CleveRoids.Frame:UPDATE_SHAPESHIFT_FORM()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end
function CleveRoids.Frame:SPELL_UPDATE_COOLDOWN()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end
function CleveRoids.Frame:UNIT_AURA()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end
function CleveRoids.Frame:UNIT_HEALTH()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end
function CleveRoids.Frame:UNIT_POWER()
    if CleveRoidMacros.realtime == 0 then
        CleveRoids.QueueActionUpdate()
    end
end


CleveRoids.Hooks.SendChatMessage = SendChatMessage
function SendChatMessage(msg, ...)
    if msg and string.find(msg, "^#showtooltip") then
        return
    end
    CleveRoids.Hooks.SendChatMessage(msg, unpack(arg))
end

CleveRoids.RegisterActionEventHandler = function(fn)
    if type(fn) == "function" then
        table.insert(CleveRoids.actionEventHandlers, fn)
    end
end

CleveRoids.RegisterMouseOverResolver = function(fn)
    if type(fn) == "function" then
        table.insert(CleveRoids.mouseOverResolvers, fn)
    end
end


-- Bandaid so pfUI doesn't need to be edited
-- pfUI/modules/thirdparty-vanilla.lua:914
CleverMacro = true

---- START of pfUI Focus Fix ----
do
    local f = CreateFrame("Frame")
    f:SetScript("OnEvent", function(self, event, arg1)
        if event == "PLAYER_LOGIN" then
            -- This ensures we wait until the player is fully in the world and all addons are loaded.
            self:UnregisterEvent("PLAYER_LOGIN")

            -- Ensure both pfUI and its focus module are loaded before attempting to hook.
            -- This also checks that the slash command we want to modify exists.
            if pfUI and pfUI.uf and pfUI.uf.focus and SlashCmdList.PFFOCUS then

                local original_PFFOCUS_Handler = SlashCmdList.PFFOCUS
                SlashCmdList.PFFOCUS = function(msg)
                    -- First, execute the original /focus command from pfUI to set the unit name.
                    original_PFFOCUS_Handler(msg)

                -- Now, if a focus name was set, find the corresponding UnitID.
                if pfUI.uf.focus.unitname then
                    local focusName = pfUI.uf.focus.unitname
                    local found_label, found_id = nil, nil

                    -- This function iterates through all known friendly units to find a
                    -- name match and return its specific UnitID components.
                    local function findUnitID()
                        -- Check party members and their pets
                        for i = 1, GetNumPartyMembers() do
                            if strlower(UnitName("party"..i) or "") == focusName then
                                return "party", i
                            end
                            if UnitExists("partypet"..i) and strlower(UnitName("partypet"..i) or "") == focusName then
                                return "partypet", i
                            end
                        end

                        -- Check raid members and their pets
                        for i = 1, GetNumRaidMembers() do
                            if strlower(UnitName("raid"..i) or "") == focusName then
                                return "raid", i
                            end
                            if UnitExists("raidpet"..i) and strlower(UnitName("raidpet"..i) or "") == focusName then
                                return "raidpet", i
                            end
                        end

                        -- Check player and pet
                        if strlower(UnitName("player") or "") == focusName then return "player", nil end
                        if UnitExists("pet") and strlower(UnitName("pet") or "") == focusName then return "pet", nil end

                            return nil, nil
                        end

                        found_label, found_id = findUnitID()

                        -- Store the found label and ID. CleveRoids' Core.lua will use this
                        -- for a direct, reliable cast without needing to change your target.
                        pfUI.uf.focus.label = found_label
                        pfUI.uf.focus.id = found_id
                    else
                        -- Focus was cleared (e.g., via /clearfocus), so ensure our cached data is cleared too.
                        pfUI.uf.focus.label = nil
                        pfUI.uf.focus.id = nil
                    end
                end
            end
        end
    end)
    f:RegisterEvent("PLAYER_LOGIN")
    end
    ---- END of pfUI Focus Fix ----


SLASH_CLEVEROID1 = "/cleveroid"
SLASH_CLEVEROID2 = "/cleveroidmacros"
--新增中文描述支持 by 迷茫、武藤纯子酱 2025.8.19
SlashCmdList["CLEVEROID"] = function(msg)
    if type(msg) ~= "string" then
        msg = ""
    end

    local cmd, val
    local s, e, a, b = string.find(msg, "^(%S*)%s*(%S*)$")
    if a then cmd = a else cmd = "" end
    if b then val = b else val = "" end

	if CleveRoids.Locale == "zhCN" or CleveRoids.Locale == "zhTW" then
		-- No command: show current value
		if cmd == "" then
			CleveRoids.Print("当前设置：")
			DEFAULT_CHAT_FRAME:AddMessage("realtime = " .. CleveRoidMacros.realtime .. " (强制实时更新，CPU 高负载。默认: 0)")
			DEFAULT_CHAT_FRAME:AddMessage("refresh = " .. CleveRoidMacros.refresh .. " (每秒更新次数。默认: 5)")
			return
		end

		-- realtime
		if cmd == "realtime" then
			local num = tonumber(val)
			if num == 0 or num == 1 then
				CleveRoidMacros.realtime = num
				CleveRoids.Print("realtime = " .. num)
			else
				CleveRoids.Print("用法: /cleveroid realtime 0 或 1 - 强制实时更新，而不是基于事件的更新(1代表启用，增加CPU负载。默认: 0。)")
				CleveRoids.Print("当前realtime = " .. tostring(CleveRoidMacros.realtime))
			end
			return
		end

		-- refresh
		if cmd == "refresh" then
			local num = tonumber(val)
			if num and num >= 1 and num <= 10 then
				CleveRoidMacros.refresh = num
				CleveRoids.Print("刷新频率设置为每秒" .. num .. "次")
			else
				CleveRoids.Print("用法: /cleveroid refresh X - 设置刷新频率. (每秒更新次数1到10。默认: 5)")
				CleveRoids.Print("当前刷新频率为每秒" .. tostring(CleveRoidMacros.refresh) .. "次")
			end
			return
		end

		-- Unknown command fallback
		CleveRoids.Print("用法:")
		DEFAULT_CHAT_FRAME:AddMessage("/cleveroid realtime 0 或 1 - 强制实时更新，而不是基于事件的更新(1代表启用，增加CPU负载。默认: 0。)")
		DEFAULT_CHAT_FRAME:AddMessage("/cleveroid refresh X - 设置刷新频率。(每秒更新次数1到10。默认: 5)")	
	else
		-- No command: show current value
		if cmd == "" then
			CleveRoids.Print("Current Settings:")
			DEFAULT_CHAT_FRAME:AddMessage("realtime (force fast updates, CPU intensive) = " .. CleveRoidMacros.realtime .. " (Default: 0)")
			DEFAULT_CHAT_FRAME:AddMessage("refresh (updates per second) = " .. CleveRoidMacros.refresh .. " (Default: 5)")
			return
		end

		-- realtime
		if cmd == "realtime" then
			local num = tonumber(val)
			if num == 0 or num == 1 then
				CleveRoidMacros.realtime = num
				CleveRoids.Print("realtime set to " .. num)
			else
				CleveRoids.Print("Usage: /cleveroid realtime 0 or 1 - Force realtime updates rather than event based updates (Default: 0. 1 = on, increases CPU load.)")
				CleveRoids.Print("Current realtime = " .. tostring(CleveRoidMacros.realtime))
			end
			return
		end

		-- refresh
		if cmd == "refresh" then
			local num = tonumber(val)
			if num and num >= 1 and num <= 10 then
				CleveRoidMacros.refresh = num
				CleveRoids.Print("refresh set to " .. num .. " times per second")
			else
				CleveRoids.Print("Usage: /cleveroid refresh X - Set refresh rate. (1 to 10 updates per second. Default: 5)")
				CleveRoids.Print("Current refresh = " .. tostring(CleveRoidMacros.refresh) .. " times per second")
			end
			return
		end

		-- Unknown command fallback
		CleveRoids.Print("Usage:")
		DEFAULT_CHAT_FRAME:AddMessage("/cleveroid realtime 0 or 1 - Force realtime updates rather than event based updates (Default: 0. 1 = on, increases CPU load.)")
		DEFAULT_CHAT_FRAME:AddMessage("/cleveroid refresh X - Set refresh rate. (1 to 10 updates per second. Default: 5)")
	end
end

-- 调试函数：检查动作状态
function CleveRoids.DebugActionState(slot)
    local actions = CleveRoids.GetAction(slot)
    if actions then
        CleveRoids.Print("动作槽", slot, "状态:")
        if actions.active then
            CleveRoids.Print("  - Active:", actions.active.action)
            CleveRoids.Print("  - Usable:", actions.active.usable)
            CleveRoids.Print("  - OOM:", actions.active.oom)
            CleveRoids.Print("  - InRange:", actions.active.inRange)
            CleveRoids.Print("  - Type:", actions.active.type)
        else
            CleveRoids.Print("  - 没有激活的动作")
        end
        if actions.tooltip then
            CleveRoids.Print("  - Tooltip:", actions.tooltip.action)
        end
    else
        CleveRoids.Print("动作槽", slot, "没有找到动作")
    end
end
SLASH_DEBUGACTION1 = "/debugaction"
SlashCmdList.DEBUGACTION = function(msg)
    local slot = tonumber(msg) or 1
    CleveRoids.DebugActionState(slot)
end