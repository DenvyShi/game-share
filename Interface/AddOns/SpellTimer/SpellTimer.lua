--------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------
Talents = {}
Spell_Info = {}
SPELLTIMER_BARNUMBER_MAX = 8  
ST_Default_Config = { 
    ["Enabled"] = nil, 
    ["EnabledTest"] = nil,
    ["ShowProgressBar"] = 1, 
    ["ShowName"] = 1, 
    ["WarningTime"] = 5, 
    ["HideAllWhenLeaveCombat"] = 1, 
    ["ShowTargetName"] = nil, 
    ["TooltipInfo"] = nil, 
    ["EnableEnemy"] = nil, 
    ["EnableCastBar"] = 1,
    ["Settings"] = 20,
}
local sharak = nil 
local CastingSpell = nil 
local CastingPet = nil
local judgment_time = nil
local judgment_name = nil
local org_stconfig = nil
local org_enconfig = nil
UIPanelWindows["SpellTimer_Option"] = {area = "left", pushable = 1} 
---------------------------------------------------------------------------------------------
--盗贼和D的不同的连击点对应的显示时间防入表PointtoTime中
-----------------------------------------------------------------------------------------------
function GetTimeFrompoints(str, func)
     local PointtoTime = {}
     local i, j, combatpoint, duration 
     i, j, combatpoint, duration = string.find(str, func) 
     while (i and j) do 
          PointtoTime[tonumber(combatpoint)] = tonumber(duration) 
	  i, j, combatpoint, duration = string.find(str, func, j) 
     end 
     return PointtoTime 
end 
-----------------------------------------------------------------------------------------------
--猎人陷阱[1]是技能持续时间[2]是陷阱存在时间
--MF的格式和我们的不同,所以要修改下<被英文网站欺骗了,格式是一样的!>
-----------------------------------------------------------------------------------------------
function GetTrapTime(str, func)
     local PointtoTime = {}
     local i, j
     i, j, PointtoTime[1] = string.find(str, func[1])
     if (i and j) then
         i, j, PointtoTime[2] = string.find(str, func[2])
         if (i and j) then	     
	     	   PointtoTime[2] = tostring(tonumber(PointtoTime[2])*60)	            
             return PointtoTime 
         end 
     end 
end 
-----------------------------------------------------------------------------------------------
--用来得到陷阱的持续时间<注意盗贼的PointtoTime格式>
------------------------------------------------------------------------------------------------
function SpellTimerReturnTwo() 
     return 2 
end 
------------------------------------------------------------------------------------------------
--载入游戏 可以在BF和WOWSHELL中使用
-------------------------------------------------------------------------------------------------
function SpellTimerFrame_OnLoad() 
     this:RegisterEvent("VARIABLES_LOADED") 
     if ModManagement_RegisterMod then
        ST_MinimapFrame:SetAlpha(0)
        ST_MinimapFrame:EnableMouse(false)
	ST_MinimapButton:Disable()
        ModManagement_RegisterMod( 
          "SpellTimer", 
	  "Interface\\Icons\\INV_Misc_PocketWatch_01", 
	  SPELL_TIMER, 
	  "", 
	  nil, 
	  "SpellTimerOptionFrame" 
	  ) 
     else
        ST_MinimapFrame:EnableMouse(true)
     end
     --注册入魔兽精灵
     if(wsRegisterButton) then
          ST_MinimapFrame:SetAlpha(0)
          ST_MinimapFrame:EnableMouse(false)
	  ST_MinimapButton:Disable()
	  wsRegisterButton(
	  WS_CONFIG_SEC_1,
	  "Combat",
	  SPELL_TIMER,
	  "SpellTimer",
	  "SpellTimer",
	  "Interface\\Icons\\INV_Misc_PocketWatch_01",
	  function()
	       ST_Show_Options(); 
	  end);
     end  
     --[[     
     --]]
end 
function ST_Show_Options()
     PlaySound("igMainMenuOption")				 
     ShowUIPanel(SpellTimer_Option)
     org_stconfig = {}              
     org_stconfig = ST_Clone(SpellTimer_Config)
     if (IsAddOnLoaded("SpellTimer_Enemy")) then
         org_enconfig = {}
         org_enconfig = ST_Clone(EnemyConfig)
     end  
end
-----------------------------------------------------------------------------------------------
--Hook/Unhook
------------------------------------------------------------------------------------------------
function SpellTimer_Toggle(num)
     if (num and not sharak) then
         SpellTimerMainFrame:Show() 
	 sharak = 1 
	 SpellTimer_Config.EnabledTest = 1 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_STOP") 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_START") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_MISS") 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_INTERRUPTED") 
	 SpellTimerMainFrame:RegisterEvent("SPELLCAST_FAILED") 
	 SpellTimerMainFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
	 SpellTimerMainFrame:RegisterEvent("SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER") 
	 SpellTimerMainFrame:RegisterEvent("SPELL_CAST_TIME_INSTANT")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
	 SpelltimerCasteBar:RegisterEvent("SPELLCAST_START")
	 SpelltimerCasteBar:RegisterEvent("SPELLCAST_INTERRUPTED")
	 SpelltimerCasteBar:RegisterEvent("SPELLCAST_FAILED")
	 SpelltimerCasteBar:RegisterEvent("SPELLCAST_STOP")
	 SpelltimerCasteBar:RegisterEvent("SPELLCAST_DELAYED")
	 SpelltimerCasteBar:RegisterEvent("PLAYER_ALIVE")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" )
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" )
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
	 SpellTimerMainFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	 org_CastSpell = CastSpell 
	 CastSpell = New_CastSpell 
	 org_SpellTargetUnit = SpellTargetUnit 
	 SpellTargetUnit = New_SpellTargetUnit 
	 org_TargetUnit = TargetUnit 
	 TargetUnit = New_TargetUnit 
	 org_StopTargetting = StopTargetting 
	 old_StopTargetting = StopTargetting 
	 org_CastSpellByName = CastSpellByName 
	 CastSpellByName = New_CastSpellByName 
	 org_UseAction = UseAction 
	 UseAction = New_UseAction 
	 org_UseContainerItem = UseContainerItem 
	 UseContainerItem = New_UseContainerItem 
	 org_UseInventoryItem = UseInventoryItem 
	 UseInventoryItem = New_UseInventoryItem 
	 org_CastPetAction = CastPetAction
	 CastPetAction = New_CastPetAction
    elseif (not num and sharak) then
         for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do 
	     getglobal("SpellTimerFrame"..i):Hide() 
         end 
	 SpellTimerMainFrame:Hide() 
	 sharak = nil 
	 SpellTimer_Config.EnabledTest = nil 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_STOP") 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_START") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_MISS") 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_INTERRUPTED") 
	 SpellTimerMainFrame:UnregisterEvent("SPELLCAST_FAILED") 
	 SpellTimerMainFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	 SpellTimerMainFrame:UnregisterEvent("SPELL_BREAK_AURA") 
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
	 SpelltimerCasteBar:UnregisterEvent("SPELLCAST_START")
	 SpelltimerCasteBar:UnregisterEvent("SPELLCAST_INTERRUPTED")
	 SpelltimerCasteBar:UnregisterEvent("SPELLCAST_FAILED")
	 SpelltimerCasteBar:UnregisterEvent("SPELLCAST_STOP")
	 SpelltimerCasteBar:UnregisterEvent("SPELLCAST_DELAYED")
	 SpelltimerCasteBar:UnregisterEvent("PLAYER_ALIVE")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" )
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" )
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
	 SpellTimerMainFrame:UnregisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	 CastSpell = org_CastSpell 
	 org_CastSpell = nil 
	 SpellTargetUnit = org_SpellTargetUnit 
	 org_SpellTargetUnit = nil 
	 TargetUnit = org_TargetUnit 
	 org_TargetUnit = nil 
	 old_StopTargetting = org_StopTargetting 
	 org_StopTargetting = nil 
	 CastSpellByName = org_CastSpellByName 
	 org_CastSpellByName = nil 
	 UseAction = org_UseAction 
	 org_UseAction = nil 
	 UseContainerItem = org_UseContainerItem 
	 org_UseContainerItem = nil 
	 UseInventoryItem = org_UseInventoryItem 
	 org_UseInventoryItem = nil 
	 CastPetAction = org_CastPetAction
         org_CastPetAction = nil
    end 
end 
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
--[[
function De_bug(msg) 
    ChatFrame1:AddMessage (msg,1,1,1,1)
end
--]]
-----------------------------------------------------------------------------------------
--对吟唱类法术起个保护作用.
-----------------------------------------------------------------------------------------
function SpellTimer_Chat_Start()
    if (CastingSpell and CastingSpell.spellname == arg1) then
        if (Andy_Xiao) then
            if (not SpellTimer011) then
                SpellTimer011 = CastingSpell 
            end 
	    BigFoot_DelayCall(SpellTimer_Chat_Start, 0.2) 
	else
            if (SpellTimer011) then
                 Duration_Spell = SpellTimer011 
		 SpellTimer011 = nil 
            else 
	         Duration_Spell = CastingSpell 
		 CastingSpell = nil 
            end 
        end 
    else 
        CastingSpell = nil 
    end 
end 
------------------------------------------------------------------------------------------
--主要部分
--各种计时效果的触发都在这里呢
------------------------------------------------------------------------------------------
function SpellTimerFrame_OnEvent()
	if (event == "VARIABLES_LOADED") then
		PlayerClass = UnitClass("player")
		local i, j, spell, name
		if (not SpellTimer_Config) then
			SpellTimer_Config = {}
			SpellTimer_Config = ST_Clone(ST_Default_Config)
		end
		if (SpellTimer_Config.EnabledTest) then
			SpellTimer_Toggle(1) 
			SpellTimer_GetTalents()
		end 
		if (SpellTimer_Config and SpellTimer_Config["EnableEnemy"] and IsAddOnLoadOnDemand("SpellTimer_Enemy")) then
			EnableAddOn("SpellTimer_Enemy") 
			LoadAddOn("SpellTimer_Enemy")	
			SpellTimer_EnemyBar_Toggle(1)
	      --SpellTimer_EnemyMain:RegisterEvent("VARIABLES_LOADED")
		end
		ST_MinimapButton_UpdatePosition()    
	elseif (event == "SPELL_CAST_TIME_INSTANT") then 
	elseif (event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") then 
		i, j, name, spell = string.find(arg1, SPELLTIMER_SPELL_AFFLICTED_1)
	 --猎人陷阱效果触发后显示效果计时--如果你放了该陷阱<无法保证是你自己的陷阱>
		if (PlayerClass == BF_CLASS_HUNTER and spell and ST_TRAP_EFFECT[spell]) then               
			local orgspell = ST_TRAP_EFFECT[spell]	      
			local _, _, context = SpellTimer_Filter(nil, nil, orgspell)		   
				if (_) then		   
					TrapOnSameTarget(name, orgspell, spell, context[1]) 
				return end          	      
		end
	 --宠物计时
		if ((PlayerClass == BF_CLASS_HUNTER or PlayerClass == BF_CLASS_WARLOCK) and spell and SpellTimer_Spells[PlayerClass][spell] and name == UnitName("pettarget") and CastingPet and CastingPet.spellname == spell) then
			local level = UnitLevel("pettarget")	      
			SpellTimer_AddSpell(name, level, spell, CastingPet.hodetime, CastingPet.value, CastingPet.texture, CastingPet.SpellID, CastingPet.type, CastingPet.Special) 
			CastingPet = nil
        return end
	
		if (PlayerClass == BF_CLASS_PALADIN and spell and ((CastingSpell and CastingSpell.Special and CastingSpell.Special[spell]) or (Sharak_Spell and Sharak_Spell.Special and Sharak_Spell.Special[spell]))) then	
			judgment_time = tostring(SpellTimer_Spells[BF_CLASS_PALADIN][spell][3])
			judgment_name = spell
			if (Talents[SPELL_TIMER_LASTIONG_JUDGMENT] and Talents[SPELL_TIMER_LASTIONG_JUDGMENT][1]) then
				if (spell == SPELL_TIMER_LIGHT_JUDGMENT or spell == SPELL_TIMER_WISDOM_JUDGMENT) then
					judgment_time = tostring(judgment_time + Talents[SPELL_TIMER_LASTIONG_JUDGMENT][1])	               
				end	      	
			end 
		local jtexture , seal, level
		level = UnitLevel("target")
	    seal = SpellTimer_Spells[PlayerClass][spell][1]
	    jtexture = BifFootSpell_GetSpellTextureFromName(seal)	     
	    SpellTimer_ShowTalent(name, level, spell, judgment_time, jtexture)	   
	    CastingSpell = nil
	    Sharak_Spell  = nil
	    return end	
		if (PlayerClass == BF_CLASS_DRUID and spell) then
			SpellTimer_ShowNature(name,spell)	     
		end        
		if (spell and Talents[spell]) and SpellTimer_Has_Spell(spell) then
			if ((GetTime() - SpellStopTime) < 2) then
				if (spell ~= SPELLTIMER_ENTRAPMENT) then
					SpellTimer_ShowTalent (name, UnitLevel("target"), spell, Talents[spell][1], Talents[spell][2])
				else
					SpellTimer_ShowTalent (name, nil, spell, Talents[spell][1], Talents[spell][2])
				end
	      	   
			else
				if (spell == SPELLTIMER_ENTRAPMENT) then
					TrapOnSameTarget(name, spell, spell, Talents[spell][1])
				end
			end	
		return end 
	elseif (event == "CHAT_MSG_COMBAT_SELF_HITS") then           
		local level = UnitLevel("target")
		local name, damage
			if (PlayerClass == BF_CLASS_PALADIN and judgment_name and judgment_time) then
				for name, damage in string.gfind(arg1, SPELLTIMER_SPELL_HIT) do 
					SpellTimer_Show_Judgment_Again(name,level,judgment_name,judgment_time)
				end
				for name, damage in string.gfind(arg1, SPELLTIMER_SPELL_Crit) do 
					SpellTimer_Show_Judgment_Again(name,level,judgment_name,judgment_time)
				end	      
			end
    elseif (event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS") then
	    local _, _, damage = string.find (arg1, "([%d%.]+)")
	    if (PlayerClass == BF_CLASS_SHAMAN and damage) then
			for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
				local SpellTimerFrame = getglobal("SpellTimerFrame"..i)		    
				if (SpellTimerFrame and SpellTimerFrame:IsVisible()) then
					local _, _ = string.find (arg1, SpellTimerFrame.spell)
					if (_ and SpellTimerFrame.hp) then
						SpellTimerFrame.hp = SpellTimerFrame.hp - tonumber(damage)
							if (SpellTimerFrame.hp <= 0) then
								SpellTimer_FadeOut(SpellTimerFrame)
							end
					return end
				end
			end
	    end	    
    --elseif (event == "CHAT_MSG_SPELL_AURA_GONE_OTHER") then
    elseif (event == "CHAT_MSG_SPELL_BREAK_AURA") then         
		local i, j, name, spell = string.find(arg1, SPELLTIMER_SPELL_DISPEL_BUFF)
		if (i and j) then
			FadeOut_ByNLS(name, nil, spell) 
        end 
	elseif (event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH") then        
        local i, j, spell = string.find(arg1, SPELLTIMER_TOTEM_RUINED)
        if (i and j) then
            FadeOut_ByNLS(spell, nil, spell) 
        end 
    elseif (event == "SPELLCAST_INTERRUPTED" or event == "SPELLCAST_FAILED") then        
        CastingSpell = nil 
		DisableShow = nil 
    elseif (event == "SPELLCAST_START") then
        SpellTimer_Chat_Start(0) 
    elseif (event == "SPELLCAST_STOP") then
        SpellStopTime = GetTime()
        if (Duration_Spell and not Andy_Xiao) then 
			BigFoot_DelayCall(SpellTimer_Show, 0.6, 1, 1) 
			Andy_Xiao = 1 
        elseif (CastingSpell and CastingSpell.instant) then 
			Sharak_Spell = nil
			SpellTimer_Show()	     	     
        end 	
		DisableShow = nil	 		
    elseif (event == "PLAYER_REGEN_ENABLED") then
        FadeOutAll() 
		DisableShow = nil 
		judgment_name = nil
        judgment_time = nil
    elseif (event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
        local i, j, name = string.find(arg1, SPELLTIMER_HOSTILE_DEATH)
        if (i and j) then
            FadeOut_ByNLS(name,nil,nil)
        end 	
    elseif (event == "CHAT_MSG_SPELL_FAILED_LOCALPLAYER") then
        local i, j, spell = string.find(arg1, SPELLTIMER_SPELL_SELF_FAIL)
        if (Duration_Spell and Duration_Spell.spellname == spell) then
            Duration_Spell = nil 
        end 
    elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then
        local Displayed_Spell
        local Has_duration
        if (Duration_Spell) then
			Displayed_Spell = Duration_Spell 	         
			Has_duration = 1 
        elseif (CastingSpell) then
            Displayed_Spell = CastingSpell 
        elseif (Sharak_Spell) then
            Displayed_Spell = Sharak_Spell 
			Sharak_Spell = nil 
		else 
			Displayed_Spell = nil 
        end
        if (Displayed_Spell) then
		
            local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_SELF_RESIST_1)        --抵抗
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then 
				HideLastTimer(spell)		--隐藏上一个计时条<因为施法结束就开始计时>
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
            local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_SELF_RESIST_2)        --被抵抗
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_EVADE)                  --闪避
			if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then 
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_DODGE)                      --躲闪
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then  
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
				
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_PARRY)                      --招架
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then   
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_BLOCK)                      --格挡
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_ABSORB)                     --吸收
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_IMMUNE)                     --免疫
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)		--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
			return end
			
			local i, j, spell, name = string.find(arg1, SPELLTIMER_SPELL_MISS)                       --未击中
            if (i and j and Displayed_Spell.spellname == spell and Displayed_Spell.name == name) then
				HideLastTimer(spell)--隐藏上一个计时条
                if (Has_duration) then
                    Duration_Spell = nil 
				else 
					CastingSpell = nil 
                end 
            return end
			
         end 
     end 
end

-------------------------------------------------------------------------------------------------------
--隐藏上一个计时条
-------------------------------------------------------------------------------------------------------

function HideLastTimer(spell)
     if (SpellTimer_LastTimer and (not spell or SpellTimer_LastTimer.spell == spell)) then
         SpellTimer_LastTimer:Hide() 
     end 
end 

-------------------------------------------------------------------------------------------------------------
--DG_Spell
-------------------------------------------------------------------------------------------------------------
--function DG_Spell_Key()
--    DG_Spell = nil
--end

function SpellTimer_Show(value, Displayed_Spell)
     if (Displayed_Spell) then
         Andy_Xiao = nil 
     end
     if (Displayed_Spell and Duration_Spell) then
         Displayed_Spell = Duration_Spell
	 Duration_Spell = nil 
    elseif (not Displayed_Spell) then
         Displayed_Spell = CastingSpell 
	 Sharak_Spell = CastingSpell 
	 CastingSpell = nil 
    else 
         return 
    end
    if (Displayed_Spell) then
         if (type(Displayed_Spell.hodetime) == "string") then
             if (value) then
                 SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, Displayed_Spell.hodetime - value, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, nil, Displayed_Spell.spellrank) 
             else 
	         SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, Displayed_Spell.hodetime, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, nil, Displayed_Spell.spellrank) 
             end 
         elseif (type(Displayed_Spell.hodetime) == "table") then
             local PointtoTime = Displayed_Spell.hodetime["detect"]()
             local duration
             if (PointtoTime) then
                 duration = Displayed_Spell.hodetime[PointtoTime] 
             end
             if (duration) then
                 if (value) then
                     SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, duration - value, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, Displayed_Spell.hodetime, Displayed_Spell.spellrank) 
		 else 
		     SpellTimer_AddSpell(Displayed_Spell.name, Displayed_Spell.level, Displayed_Spell.spellname, duration, Displayed_Spell.value, Displayed_Spell.texture, Displayed_Spell.SpellID, Displayed_Spell.type, Displayed_Spell.Special, Displayed_Spell.hodetime, Displayed_Spell.spellrank) 
                 end 
             end 
         end 
    end 
end 
---------------------------------------------------------------------------------------------------------------------
--显示天赋监视，附带监视了骑士的审判
---------------------------------------------------------------------------------------------------------------------
function SpellTimer_Show_Judgment_Again(name,level,spell,duration)
     for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
	 local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
	 if (SpellTimerFrame and SpellTimerFrame:IsVisible() and          --frame是显示的
	(SpellTimerFrame.name == name and SpellTimerFrame.level == level) --同一个怪
	and SpellTimerFrame.spell == spell) then		          --同一种审判	
	     SpellTimerFrame.SpellID = nil
	     SpellTimerFrame.talent = 1 
	     Show_SpellTimer_Frame(SpellTimerFrame, spell, duration)
	     return
	end
     end	
end

function SpellTimer_ShowTalent(name, level, talent, duration, texture)   	
	for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
		local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
		if (SpellTimerFrame and SpellTimerFrame:IsVisible() and 
		((Special and Special["unique"]) or (not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level))) 
		and SpellTimerFrame.spell == talent) then			
			SpellTimerFrame.SpellID = nil
			SpellTimerFrame.talent = 1  -->有这个就不能用右键释放该法术了
			Show_SpellTimer_Frame(SpellTimerFrame, talent, duration)
			return
		end
	end	
	for j = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
		local SpellTimerFrame = getglobal("SpellTimerFrame"..j)
		if (SpellTimerFrame and not SpellTimerFrame:IsVisible()) then
			SpellTimerFrame.spell = talent
			SpellTimerFrame.name = name
			SpellTimerFrame.level = level							
			SpellTimerFrame.talent = 1			
			local textureOb = getglobal("SpellTimerFrame"..j.."IconTexture")
			textureOb:SetTexture(texture)
			Show_SpellTimer_Frame(SpellTimerFrame, talent, duration)
			return
		end
	end
end
----------------------------------------------------------------------------------------------------------------
--德鲁伊的自然之握监视，不敢肯定能使用
----------------------------------------------------------------------------------------------------------------
function SpellTimer_ShowNature(mob,spell)
	for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
	      local frame = getglobal("SpellTimerFrame"..i)
	      if (frame and frame:IsVisible() and frame.spell == SPELL_TIMER_NATURE and SpellTimer_Spells[BF_CLASS_DRUID][SPELL_TIMER_NATURE][5][spell]) then
		   local spellrank = frame.rank
		   spellrank = tonumber(spellrank)
	           if (not Spell_Info[spell] or not Spell_Info[spell][Spellrank]) then                       
			SpellTimer_GetSpellInfoFromName(spell, spellrank)
                   end                 
	           local duration = Spell_Info[spell][spellrank][1]
	           local texture = Spell_Info[spell][spellrank][2]
	           local value = SpellTimer_Has_Delay(spell) 
	           local SpellID = Spell_Info[spell][spellrank][3] 
	           local BookType = Spell_Info[spell][spellrank][4] 
	           local instant = Spell_Info[spell][spellrank][5] 
		   SpellTimer_FadeOut(frame)
	           SpellTimer_AddSpell(nil, nil, spell, duration, value, texture, SpellID, BookType, nil, nil)                                    
	           return			
	      end
	end	
end
-----------------------------------------------------------------------------------------------------
--左右键点击效果
-----------------------------------------------------------------------------------------------------
function SpellTimerFrame_OnClick(arg1)
    if (this:GetParent().name) then
        if (arg1 == "RightButton" and not this:GetParent().talent ) then
            if (this:GetParent().SpellID and type(this:GetParent().SpellID) ~= table and this:GetParent().type) then
                CastSpell(this:GetParent().SpellID, this:GetParent().type) 
	    else
	        if (this:GetParent().SpellID and type(this:GetParent().SpellID) == table and not this:GetParent().type) then
	        	UseContainerItem(this:GetParent().SpellID[1],this:GetParent().SpellID[2])
	        end
            end 
	else 
	    if (this:GetParent().name) then
                TargetByName(this:GetParent().name) 
            end 
        end 
    end 
end 

---------------------------------------------------------------------------------
--当鼠标移到计时条上时显示的内容，加入了目标的名字等级显示。
---------------------------------------------------------------------------------
function SpellTimerFrame_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
	GameTooltip:ClearLines()	
	if (this:GetParent().name) then
	     if (this:GetParent().level) then
		   GameTooltip:AddLine (SPELLTIMER_NAME..this:GetParent().name..SPELLTIMER_LEVEL..this:GetParent().level, 1, 1, 0)
	     else
		   GameTooltip:AddLine (SPELLTIMER_NAME..this:GetParent().name, 1, 1, 0)
	     end
	end
	if (not SpellTimer_Config.TooltipInfo) then
	     GameTooltip:AddLine (SPELL_TIMER_TOOLTIP)	
	end	
	GameTooltip:Show()
end
-------------------------------------------------------------------------------------
--刷新计时版面，只更新在计时的版面，每0.02秒更新一次。
-------------------------------------------------------------------------------------
function SpellTimerFrame_OnUpdate(elapsed)
    if (this.casting) then
        if (not this.CheckTime) then
            this.CheckTime = 0 
        end
        if (this.CheckTime > 0.02) then
            this.CheckTime = 0 
	else 
	    this.CheckTime = this.CheckTime + elapsed 
            return 
        end
        local Text = getglobal(this:GetName().."Text")
        local status = GetTime()
        if ( status > this.max ) then
            status = this.max 
        end
        local spelltime = this.max - status
        if (SpellTimer_Config.ShowProgressBar) then
            local SpellTimerBar = getglobal(this:GetName().."Bar")
            local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark")
            local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash")
	    SpellTimerBar:SetValue(status) 
	    SpellTimerFlash:Hide()
            local SparkPostion 
	    SparkPostion = ((status - this.Curenttime) / (this.max - this.Curenttime)) * 128
            if ( SparkPostion < 0 ) then
                SparkPostion = 0 
            end 
	    SpellTimerSpark:SetPoint("CENTER", SpellTimerBar, "LEFT", SparkPostion, 0) 
        end
        if (SpellTimer_Config.ShowName) then
            ShowSpellFrameTime(Text, SpellTimer_Format(spelltime).." - "..this.spell, spelltime) 
	elseif (SpellTimer_Config.ShowTargetName and this.name) then
	    ShowSpellFrameTime(Text, SpellTimer_Format(spelltime).." - "..this.name, spelltime) 
	else 
	    ShowSpellFrameTime(Text, SpellTimer_Format(spelltime), spelltime) 
        end
        if (status == this.max) then
            SpellTimer_FadeOut(this) 
        end 
    elseif (GetTime() < this.Zero) then 
        return 
    elseif (this.SpellTimerFlash) then
        if (SpellTimer_Config.ShowProgressBar) then
            local SpellTimerBar = getglobal(this:GetName().."Bar")
            local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash")
            local alpha = SpellTimerFlash:GetAlpha() + 0.2
            if ( alpha < 1 ) then
                SpellTimerFlash:SetAlpha(alpha) 
            else 
	        SpellTimerFlash:SetAlpha(1.0) 
		this.SpellTimerFlash = nil 
            end 
        end 
    elseif (this.fadeOut) then
        local alpha = this:GetAlpha() - 0.05
        local SpellTimerBar = getglobal(this:GetName().."Bar")
        local min, max = SpellTimerBar:GetMinMaxValues()
        if (SpellTimerBar:GetValue() ~= max) then
            this:SetAlpha(1.0)
	    this.fadeOut = nil 
        end
        if ( alpha > 0 ) then
            this:SetAlpha(alpha) 
	else 
	    this.fadeOut = nil 
	    this:Hide() 
        end 	
    end 
end 
---------------------------------------------------------------------------------
--计时条上的文字显示
--法术名字和剩余时间
---------------------------------------------------------------------------------
function ShowSpellFrameTime(Text, str, spelltime, warning)
    if (SpellTimer_Config.WarningTime) then
        Text:SetText(str)
        if (tonumber(spelltime) < SpellTimer_Config.WarningTime and Text.WarningEnable) then
            if (not warning) then
            	Text:SetTextColor(0.9, 0, 0)
            end	    
            if (not Text.TextFlashTime) then
                Text.TextFlashTime = 0 
            end 
	    Text.TextFlashTime = Text.TextFlashTime + 1
            if (Text.TextFlashTime > 5) then
                Text.WarningEnable = nil
		Text.TextFlashTime = 0 
            end
	else 
	    Text:SetTextColor(0.9, 0.9, 0.9)
            if (not Text.TextFlashTime) then
                Text.TextFlashTime = 0 
            end Text.TextFlashTime = Text.TextFlashTime + 1
            if (Text.TextFlashTime > 5) then
                Text.WarningEnable = 1 
		Text.TextFlashTime = 0 
            end 
        end 
     else 
         Text:SetText(str) 
	 Text:SetTextColor(0.9, 0.9, 0.9) 
     end 
end 
----------------------------------------------------------------------------------
--定义时间的显示格式
-----------------------------------------------------------------------------------
function SpellTimer_Format(duration)
     duration = math.floor(duration)
     local minute = math.floor(duration/60)
     local second = duration - minute*60 
     return string.format("%02d:%02d", minute, second) 
end 
----------------------------------------------------------------------------------------
--检查每个显示frame，如果名字、等级、法术都相同就返回
----------------------------------------------------------------------------------------
function SpellTimer_Filter(name, level, spell) 
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
         local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
         if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level)) and SpellTimerFrame.spell == spell) then
              return SpellTimerFrame, spell, SpellTimerFrame.context 
         end 
    end 
end 
-----------------------------------------------------------------------------------------------------
--保证同类法术只显示一个，如萨满的同属性图腾
------------------------------------------------------------------------------------------------------
function CheckSpellOnSameTarget(name, level, Tab_Four) 
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level))) then
            for combatpoint, spell in Tab_Four do
                if (spell == SpellTimerFrame.spell) then
                    SpellTimer_FadeOut(SpellTimerFrame) 
                end 
            end 
        end 
    end 
end 
---------------------------------------------------------------------------------------------------------
--目标进入陷阱后用陷阱.."效果"取代原来的陷阱名字
--目标名字、法术（陷阱）、效果、持续时间
---------------------------------------------------------------------------------------------------------
function TrapOnSameTarget(name, spell, newbuff, hodetime) 
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and SpellTimerFrame:IsVisible() and SpellTimerFrame.spell == spell) then
            SpellTimerFrame.name = name 
	    SpellTimerFrame.spell = newbuff 
	    Show_SpellTimer_Frame(SpellTimerFrame, newbuff, hodetime) 
            return 
        end 
    end 
end 
-----------------------------------------------------------------------------------------------------------
--更新计时条或则显示新的计时条，只要符合条件。（以前变羊也该是“unique”的）
-----------------------------------------------------------------------------------------------------------
function SpellTimer_AddSpell(name, level, spell, hodetime, value, texture, SpellID, BookType, Special, context, spellrank)
    if (not value) then
        value = 0 
    end 
    --覆盖原计时条
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and SpellTimerFrame:IsVisible() and ((Special and Special["unique"]) or not SpellTimerFrame.name or (SpellTimerFrame.name == name and SpellTimerFrame.level == level)) and SpellTimerFrame.spell == spell) then
            Show_SpellTimer_Frame(SpellTimerFrame, spell, hodetime + value)
	    SpellTimerFrame.talent = nil
	    if (Special and Special.hp) then
	    	SpellTimerFrame.hp = Special.hp
	    end
            if (SpellTimer_Spells[PlayerClass][spell][4]) then
                CheckSpellOnSameTarget(name, level, SpellTimer_Spells[PlayerClass][spell][4]) 
            end 
            return 
        end 
    end 
    --新建一个
    for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
        local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
        if (SpellTimerFrame and not SpellTimerFrame:IsVisible()) then
	    if (Specaial and Special.hp) then
	    	SpellTimerFrame.hp = Special.hp
	    end
            SpellTimerFrame.spell = spell
	    SpellTimerFrame.rank = spellrank -->专门为自然之握设计
	    SpellTimerFrame.name = name 
	    SpellTimerFrame.level = level 
	    SpellTimerFrame.SpellID = SpellID 
	    SpellTimerFrame.Special = Special 
	    SpellTimerFrame.talent = nil
	    SpellTimerFrame.type = BookType 
	    SpellTimerFrame.context = context
            local textureOb = getglobal("SpellTimerFrame"..i.."IconTexture") 
	    textureOb:SetTexture(texture) 
	    Show_SpellTimer_Frame(SpellTimerFrame, spell, hodetime + value)
            if (SpellTimer_Spells[PlayerClass][spell][4]) then
                CheckSpellOnSameTarget(name, level, SpellTimer_Spells[PlayerClass][spell][4]) 
            end 
            return 
       end 
    end 
end 
----------------------------------------------------------------------------------------------------------
--判断是否该隐藏计时条 
--失去BUFF（被移除） 该BUF的计时被移除
--图腾被摧毁 该图腾的计时被移除
----------------------------------------------------------------------------------------------------------
function FadeOut_ByNLS(name, level, spell) 
     for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
         local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
         if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not spell or SpellTimerFrame.spell == spell) and (not name or SpellTimerFrame.name == name) and (not level or SpellTimerFrame.level == level)) then
             SpellTimer_FadeOut(SpellTimerFrame) 
         end 
     end 
end 
-----------------------------------------------------------------------------------------------------------
--刚显示时 
--设定显示时间、是否显示计时条和法术名、以及透明度等初始信息
-----------------------------------------------------------------------------------------------------------
function Show_SpellTimer_Frame(SpellTimerFrame, str, duration)
     local SpellTimerBar = getglobal(SpellTimerFrame:GetName().."Bar")
     local icon = getglobal(SpellTimerFrame:GetName().."Icon")
     local Text = getglobal(SpellTimerFrame:GetName().."Text") 

     SpellTimerFrame.Curenttime = GetTime() 
     SpellTimerFrame.max = SpellTimerFrame.Curenttime + duration

     if (SpellTimer_Config.ShowProgressBar) then
         local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark")
         local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash") 
	 SpellTimerBar:SetStatusBarColor(1.0, 0.7, 0.0) 
	 SpellTimerBar:SetMinMaxValues(SpellTimerFrame.Curenttime, SpellTimerFrame.max) 
	 SpellTimerBar:SetValue(SpellTimerFrame.Curenttime) 
	 SpellTimerFlash:Hide() 
	 SpellTimerBar:Show() 
	 SpellTimerSpark:SetPoint("CENTER", SpellTimerBar, "LEFT", 0, 0) 
	 SpellTimerSpark:Show() 
	 Text:ClearAllPoints() 
	 Text:SetPoint("TOPLEFT", SpellTimerFrame, "TOPLEFT", 35, 0) 
     else 
         Text:ClearAllPoints() 
	 Text:SetPoint("LEFT", SpellTimerFrame, "LEFT", 35, 0) 
	 SpellTimerBar:Hide() 
     end

     if (SpellTimer_Config.ShowName) then
         ShowSpellFrameTime(Text, SpellTimer_Format(duration).." - "..str, duration) 
     elseif (SpellTimer_Config.ShowTargetName and SpellTimerFrame.name) then
         ShowSpellFrameTime(Text, SpellTimer_Format(duration).." - "..SpellTimerFrame.name, duration)
     else    
	 ShowSpellFrameTime(Text, SpellTimer_Format(duration), duration) 
     end 
     SpellTimerFrame:SetAlpha(1.0) 
     SpellTimerFrame.Zero = 0 
     SpellTimerFrame.casting = 1 
     SpellTimerFrame.fadeOut = nil 
     SpellTimerFrame:Show()    
     SpellTimer_LastTimer = SpellTimerFrame    
end 
-------------------------------------------------------------------------------------------------------
--该函数未使用
-------------------------------------------------------------------------------------------------------
function SpellTimer050(SpellTimerFrame)
     if (not SpellTimerFrame) then
         SpellTimerFrame = SpellTimer_LastTimer 
     end
     if (SpellTimerFrame and SpellTimerFrame:IsShown()) then
         if (SpellTimer_Config.ShowProgressBar) then
             local SpellTimerBar = getglobal(SpellTimerFrame:GetName().."Bar")
             local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark") 
	     SpellTimerBar:SetValue(SpellTimerFrame.max) 
	     SpellTimerBar:SetStatusBarColor(1.0, 0.0, 0.0) 
	     SpellTimerSpark:Hide() 
         end 
	 SpellTimerFrame.casting = nil 
	 SpellTimerFrame.fadeOut = 1 
	 SpellTimerFrame.Zero = GetTime() + 1 
     end 
end 
------------------------------------------------------------------------------------------------------
--离开战斗后，隐藏除特殊[“live”]的以外的所有计时条
------------------------------------------------------------------------------------------------------
function FadeOutAll() 
     for i = 1, SPELLTIMER_BARNUMBER_MAX, 1 do
         local SpellTimerFrame = getglobal("SpellTimerFrame"..i)
         if (SpellTimerFrame and SpellTimerFrame:IsVisible() and (not SpellTimerFrame.Special or not SpellTimerFrame.Special["live"])) then
             SpellTimer_FadeOut(SpellTimerFrame) 
         end 
     end 
end 
--------------------------------------------------------------------------------------------------------
--让frame消失
--------------------------------------------------------------------------------------------------------
function SpellTimer_FadeOut(SpellTimerFrame)
     if (not SpellTimerFrame) then
         SpellTimerFrame = SpellTimer_LastTimer 
     end
     if (SpellTimerFrame and SpellTimerFrame:IsShown()) then
         if (SpellTimer_Config.ShowProgressBar) then
             local SpellTimerBar = getglobal(SpellTimerFrame:GetName().."Bar")
             local SpellTimerSpark = getglobal(SpellTimerBar:GetName().."Spark")
             local SpellTimerFlash = getglobal(SpellTimerBar:GetName().."Flash")
	     SpellTimerBar:SetValue(SpellTimerFrame.max) 
	     SpellTimerBar:SetStatusBarColor(0.0, 1.0, 0.0) 
	     SpellTimerSpark:Hide() 
	     SpellTimerFlash:SetAlpha(0.0) 
	     SpellTimerFlash:Show() 
	     SpellTimerFrame.SpellTimerFlash = 1 
         end 
	 SpellTimerFrame.casting = nil 
	 SpellTimerFrame.fadeOut = 1 
     end 
end 
-------------------------------------------------------------------------------------------------------
--其实函数名字没代表函数的实质。该函数是为了得你法术的信息，并创建一个arry
--当然函数名字也有一定的道理，如果你的法术中有该施放的法术，那么就返回true
-------------------------------------------------------------------------------------------------------
function SpellTimer_GetSpellInfoFromName(spellname, spellrank)
     local SpellName, info
     if (not spellname) then
     	 return    
     else 
         for SpellName, info in SpellTimer_Spells[PlayerClass] do
             if (SpellName == spellname) then
                 local SpellID, _type, subname, _rank, texture, desc, instant = BigFootSpell_GetSpellInfoFromName(SpellName, spellrank)
		 if (not SpellID) then
		     return false 
		 end
                 local i, j, hodetime
                 if (info[3]) then
                     i = 1 
		     j = 1 
		     hodetime = tostring(info[3])
		 --这个结构非常棒,使之可以很灵活的利用[1]
		 else
                     if (type(info[1]) == "string") then
                         i, j, hodetime = string.find(desc, info[1])
                         if (hodetime and info[2]) then
                             hodetime = tostring(tonumber(hodetime)*info[2]) 
                         end 
                     elseif (type(info[1]) == "table") then
                         local func = getglobal(info[1][1])    --func 
			 hodetime = func(desc, info[1][2])     
                         if (hodetime) then
                             hodetime["detect"] = getglobal(info[1][3]) 
			     i = 1 
			     j = 1 
                         end 
                     elseif (type(info[1]) == "number") then
                         hodetime = tostring(tonumber(info[1])) 
                     end 
                 end		 
                 if (i and j) then
                     if (not Spell_Info[SpellName]) then
                         Spell_Info[SpellName] = {} 
                     end
                     if (spellrank) then
                         Spell_Info[SpellName][spellrank] = {hodetime, texture, SpellID, _type, instant}
                     else 
		         Spell_Info[SpellName][1] = {hodetime, texture, SpellID, _type, instant}
			 --主要获得:持续时间,图标,ID,type,瞬发<最重要的是持续时间和图标>
                     end 
                 end 
             end 
         end 
     end 
     return true 
end 
-----------------------------------------------------------------------------------------------------
--判断该法术是否可以显示
--没有该法术或者没有disable都是能显示的
-----------------------------------------------------------------------------------------------------
function SpellTimer_Has_Spell(spellname)
     if (not SpellTimer_Config.Spells) then 
         return 1 
     end
     if (not SpellTimer_Config.Spells[spellname]) then 
         return 1 
     end
     if (not SpellTimer_Config.Spells[spellname].disabled) then 
         return 1 
     end 
end 
------------------------------------------------------------------------------------------------------
--法术是否有延迟设置，如果有的话就返回延迟值，没有就回0
------------------------------------------------------------------------------------------------------
function SpellTimer_Has_Delay(spellname)
     if (not SpellTimer_Config.Spells) then 
         return 0 
     end
     if (not SpellTimer_Config.Spells[spellname]) then 
         return 0 
     end
     if (not SpellTimer_Config.Spells[spellname].delay) then 
         return 0 
     end 
         return SpellTimer_Config.Spells[spellname].delay 
end 
----------------------------------------------------------------------------------------------------------
--hook CastSpll函数
--如果该法术可以计时，那么就得到一系列法术信息
--
----------------------------------------------------------------------------------------------------------
function New_CastSpell(slot, BookType)
     if (not DisableShow) then
         local spellname, spellrank = GetSpellName(slot, BookType)
	 --暂时没有其他功能         
         local SpellRank = 1 
	 CastingSpell = nil
         if (spellrank) then
             local _, _,  Rank = string.find(spellrank, "(%d+)")
	     SpellRank = tonumber( Rank)
             if (not SpellRank) then
                 SpellRank = 1 
             end 
         end
	 if (SpellTimer_Config.EnableCastBar and spellname == SPELLTIMER_AIMED) then
	     SpelltimerCasteBar_CastAimed()	    
	     return org_CastSpell(slot, BookType)
	 end
         local name = UnitName("target")
         local level = UnitLevel("target")
         if (slot) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
	     --该法术是否在表中,并且是否存在于可以使用列表中,是否是disable
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then		
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
		     --如果不存在于可使用列表中,那么再获取一次,如果还没有,那么就是没有学习该法术了
                         org_CastSpell(slot, BookType) 
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
                     CastingSpell = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingSpell.Special = SpellTimer_Spells[PlayerClass][spellname][5] 
                     end
                     if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                         CastingSpell.notarget = 1 
		     else 
		         CastingSpell.name = name 
                     end 
		     CastingSpell.level = level 
		     CastingSpell.spellname = spellname 
                     CastingSpell.spellrank = SpellRank		     		     
		     CastingSpell.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingSpell.value = SpellTimer_Has_Delay(spellname) 
		     CastingSpell.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingSpell.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingSpell.type = Spell_Info[spellname][SpellRank][4] 
		     CastingSpell.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
     org_CastSpell(slot, BookType) 
end 
--------------------------------------------------------------------------------------------
--hook SpellTargetUnit函数 主要为了得到目标名字和等级
--------------------------------------------------------------------------------------------
function New_SpellTargetUnit(unit)
     if (CastingSpell and not CastingSpell.name) then
         if (not CastingSpell.notarget) then
             CastingSpell.name = UnitName(unit) 
         end 
	 CastingSpell.level = UnitLevel(unit) 
     end 
     org_SpellTargetUnit(unit) 
end 
------------------------------------------------------------------------------------------------
--hook TargetUnit函数 作用几乎同上
------------------------------------------------------------------------------------------------
function New_TargetUnit(unit)
     if (CastingSpell and not CastingSpell.name) then
         if (not CastingSpell.notarget) then
             CastingSpell.name = UnitName(unit) 
         end 
	 CastingSpell.level = UnitLevel(unit) 
     end 
     org_TargetUnit(unit) 
end 
------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------
function old_StopTargetting()
     if (CastingSpell) then
         CastingSpell = nil 
     end 
     org_StopTargetting() 
end 
------------------------------------------------------------------------------------------------
--hook CastSpellByName 函数 
------------------------------------------------------------------------------------------------
function New_CastSpellByName(name)     
     if (not DisableShow) then         
         local i, j, spellname = string.find(name, "(.+)%(")	 
         local _, _,  Rank = string.find(name, "([%d]+)")
         local SpellRank = 1 
	 CastingSpell = nil
         if (not spellname) then
             spellname = name 
         end
         if ( Rank) then
             SpellRank = tonumber( Rank)
             if (not SpellRank) then
                 SpellRank = 1 
             end 
         end
	 if (SpellTimer_Config.EnableCastBar and spellname == SPELLTIMER_AIMED) then
	     SpelltimerCasteBar_CastAimed()	  	    
	     return org_CastSpellByName(name)
	 end
         local name = UnitName("target")
         local level = UnitLevel("target")
         local SpellID, BookType = BigFootSpell_GetSpellInfoFromName(spellname, SpellRank)
         if (SpellID) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                         org_CastSpellByName(name) 
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
                     CastingSpell = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingSpell.Special = SpellTimer_Spells[PlayerClass][spellname][5] 
                     end
                     if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                         CastingSpell.notarget = 1 else CastingSpell.name = name 
                     end 
		     CastingSpell.level = level 
		     CastingSpell.spellname = spellname 
		     CastingSpell.spellrank = SpellRank		     
		     CastingSpell.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingSpell.value = SpellTimer_Has_Delay(spellname) 
		     CastingSpell.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingSpell.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingSpell.type = Spell_Info[spellname][SpellRank][4] 
		     CastingSpell.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
     org_CastSpellByName(name) 
end 
------------------------------------------------------------------------------------------------------------
--新的UseContainerItem
--现在还没加入物品计时，因为我还没找到合适的让物品开始计时的事件
------------------------------------------------------------------------------------------------------------
--[[
function New_UseContainerItem(bagID, slot, onself)
     if (not DisableShow) then         
         local itemname, item = SpellTimer_GetItemInfoFromName(bagID,slot)	
	 if (not itemrank) then
	      itemrank = 1
	 end
	 CastingSpell = nil
	 local name = UnitName("target")
         local level = UnitLevel("target")   
	 if (item) then	      
	      if (SpellTimer_Spells[PlayerClass][itemname] and SpellTimer_Has_Spell(itemname)) then
                   if (not Spell_Info[itemname] or not Spell_Info[itemname][itemrank]) then
                        if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                             org_CastSpellByName(name) 
                             return 
                        end 
                   end
                   if (Spell_Info[itemname] and Spell_Info[itemname][itemrank]) then
                        CastingSpell = {}
                        if (SpellTimer_Spells[PlayerClass][itemname][5]) then
                             CastingSpell.Special = SpellTimer_Spells[PlayerClass][itemname][itemname][5] 
                        end
                        if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                             CastingSpell.notarget = 1 
		        else 
		             CastingSpell.name = name 
                        end 
			SpellStartTime = GetTime()
		        CastingSpell.level = level                                  -->作用的目标等级
		        CastingSpell.spellname = itemname 
			CastingSpell.spellrank = SpellRank                          -->物品名字
		        CastingSpell.hodetime = Spell_Info[itemname][itemrank][1]-->持续时间
		        CastingSpell.value = SpellTimer_Has_Delay(spellname)        -->延迟
		        CastingSpell.texture = Spell_Info[itemname][itemrank][2] -->texture
		        CastingSpell.SpellID = Spell_Info[itemname][itemrank][3] -->table
		        CastingSpell.type = Spell_Info[itemname][itemrank][4]    -->nil
		        CastingSpell.instant = Spell_Info[itemname][itemrank][5] -->nil
                   end 
              end    
	 end         
     end 
     org_UseContainerItem(bagID, slot, onself) 
end
--]]
function New_UseContainerItem(bagID, slot, onself)
     if (not DisableShow) then
         CastingSpell = nil 
     end 
     org_UseContainerItem(bagID, slot, onself) 
end
------------------------------------------------------------------------------------------------------------
--新的 UseInventoryItem
------------------------------------------------------------------------------------------------------------
function New_UseInventoryItem(slot, onself)
     if (not DisableShow) then
         CastingSpell = nil 
     end 
     org_UseInventoryItem(slot, onself) 
end 
-------------------------------------------------------------------------------------------------------------
--或许是hook函数中最有价值的
-------------------------------------------------------------------------------------------------------------
function New_UseAction(slot, checkCursor, onSelf)
     if (not DisableShow) then
         CastingSpell = nil 
	 SpellTimerTooltip:SetOwner(UIParent, "ANCHOR_NONE") 
	 SpellTimerTooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMRIGHT", 5, -5) 
	 SpellTimerTooltip:SetText("SpellTimerTooltip") 
	 SpellTimerTooltip:Show() 
	 SpellTimerTooltip:SetAction(slot)
         local spellname = SpellTimerTooltipTextLeft1:GetText()
	 local rankString = SpellTimerTooltipTextRight1:GetText() 
	 SpellTimerTooltip:Hide()
         local  Rank
         if (rankString) then
             local _ _, _, Rank = string.find(rankString, "[^%d]*(%d+)") 
         end
         local SpellRank = tonumber(Rank)
         if (not SpellRank) then
             SpellRank = 1 
         end
	 if (SpellTimer_Config.EnableCastBar and spellname == SPELLTIMER_AIMED) then
	     SpelltimerCasteBar_CastAimed()	     
	     return org_UseAction(slot, checkCursor, onSelf)
	 end
         local name = UnitName("target")
         local level = UnitLevel("target")
         if (slot) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                         org_UseAction(slot, checkCursor, onSelf) 
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
--		     ChatFrame1:AddMessage("有"..spellname)
                     CastingSpell = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingSpell.Special = SpellTimer_Spells[PlayerClass][spellname][5] 		     
                     end
                     if (CastingSpell.Special and CastingSpell.Special["notarget"]) then
                         CastingSpell.notarget = 1
		     else 
		         CastingSpell.name = name 
                     end 
		     SpellStartTime = GetTime()
		     CastingSpell.level = level 
		     CastingSpell.spellname = spellname 
		     CastingSpell.spellrank = SpellRank		     
		     CastingSpell.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingSpell.value = SpellTimer_Has_Delay(spellname) 
		     CastingSpell.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingSpell.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingSpell.type = Spell_Info[spellname][SpellRank][4] 
		     CastingSpell.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
     org_UseAction(slot, checkCursor, onSelf) 
end 
-----------------------------------------------------------------------------------------------------------------------
--重新定义宠物施法部分,宏无效
-----------------------------------------------------------------------------------------------------------------------
function New_CastPetAction(slotId) 
    if (not DisableShow) then
         CastingPet = nil
	 Pet_Tooltip:SetOwner(UIParent, "ANCHOR_NONE") 
	 Pet_Tooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMRIGHT", 5, -5) 
	 Pet_Tooltip:SetText("Pet_Tooltip") 
	 Pet_Tooltip:Show() 
         Pet_Tooltip:SetPetAction(slotId);    
         local spellname = Pet_TooltipTextLeft1:GetText();    
         local rankstring = Pet_TooltipTextRight1:GetText();
         Pet_Tooltip:Hide()
	 if (rankstring) then
	      local _ _, _, Rank = string.find(rankstring, "[^%d]*(%d+)") 
	 end
	 local SpellRank = tonumber(Rank)
         if (not SpellRank) then
              SpellRank = 1 	
         end
	 local name = UnitName("target")
	 local level = UnitLevel("target")
         if (slotId) then
             if (SpellTimer_Spells[PlayerClass][spellname] and SpellTimer_Has_Spell(spellname)) then
                 if (not Spell_Info[spellname] or not Spell_Info[spellname][SpellRank]) then
                     if (not SpellTimer_GetSpellInfoFromName(spellname, SpellRank)) then
                         org_CastPetAction(slotId)
                         return 
                     end 
                 end
                 if (Spell_Info[spellname] and Spell_Info[spellname][SpellRank]) then
                     CastingPet = {}
                     if (SpellTimer_Spells[PlayerClass][spellname][5]) then
                         CastingPet.Special = SpellTimer_Spells[PlayerClass][spellname][5] 
                     end
                     if (CastingPet.Special and CastingPet.Special["notarget"]) then
                         CastingPet.notarget = 1
		     else 
		         CastingPet.name = name 
                     end 		 
		     CastingPet.level = level 
		     CastingPet.spellname = spellname 
		     CastingPet.spellrank = SpellRank
		     CastingPet.hodetime = Spell_Info[spellname][SpellRank][1] 
		     CastingPet.value = SpellTimer_Has_Delay(spellname) 
		     CastingPet.texture = Spell_Info[spellname][SpellRank][2] 
		     CastingPet.SpellID = Spell_Info[spellname][SpellRank][3] 
		     CastingPet.type = Spell_Info[spellname][SpellRank][4] 
		     CastingPet.instant = Spell_Info[spellname][SpellRank][5] 
                 end 
             end 
         end 
     end 
    org_CastPetAction(slotId)
end
-----------------------------------------------------------------------------------------------------------------------
--enable/disable  以下为配置函数
-----------------------------------------------------------------------------------------------------------------------
function SpellTimerOption_Toggle(enable)
     if (enable) then
         local i
         for i = 1, 8, 1 do
             local SpellTimerFrame = getglobal("SpellTimerOptionFrameSpellOption"..i) 
	     Checkbox_Slider_Toggle(SpellTimerFrame, 1) 
         end 
         SpellTimerScrollFrameScrollBarScrollUpButton:Enable() 
         SpellTimerScrollFrameScrollBarScrollDownButton:Enable()
--         if (SpellTimer_Config.ShowProgressBar) then
             MobElement_Enable(SpellTimerOptionShowProgress) 
--         else 
--             MobElement_Disable(SpellTimerOptionShowProgress) 
--         end
--         if (SpellTimer_Config.ShowName) then
             MobElement_Enable(SpellTimerOptionShowName) 
--	 else 
--	     MobElement_Disable(SpellTimerOptionShowName) 
--         end
--	 if (SpellTimer_Config.ShowTargetName) then 
	     MobElement_Enable(SpellTimerOptionShowTargetName) 
--	 else 
--	     MobElement_Disable(SpellTimerOptionShowTargetName) 
--	 end
--	 if (SpellTimer_Config.TooltipInfo) then
             MobElement_Enable(SpellTimerOptionShowTooltip) 
--	 else 
--	     MobElement_Disable(SpellTimerOptionShowTooltip) 
--         end
--	 if (SpellTimer_CastBar["config"]) then
             MobElement_Enable(SpellTimerOptionCastbar) 
--	 else 
--	     MobElement_Disable(SpellTimerOptionCastbar) 
--         end
     else
         local i 
	 for i = 1, 8, 1 do
             local SpellTimerFrame = getglobal("SpellTimerOptionFrameSpellOption"..i) Checkbox_Slider_Toggle(SpellTimerFrame, nil) 
         end 
	 SpellTimerScrollFrameScrollBarScrollUpButton:Disable() 
	 SpellTimerScrollFrameScrollBarScrollDownButton:Disable() 
	 SpellTimer_Config.EnabledTest = nil 
	 MobElement_Disable(SpellTimerOptionShowProgress) 
	 MobElement_Disable(SpellTimerOptionShowName) 
         MobElement_Disable(SpellTimerOptionShowTargetName) 
	 MobElement_Disable(SpellTimerOptionShowTooltip)
	 MobElement_Disable(SpellTimerOptionCastbar)         
     end 
end 

function SpellTimerOptionEnable_OnShow() 
     getglobal(this:GetName().."Text"):SetText(ENABLE_SPELL_TIMER)
     if (SpellTimer_Config.EnabledTest) then
         this:SetChecked(1) 
	 SpellTimerOption_Toggle(1)
     else 
         this:SetChecked(0) 
	 SpellTimerOption_Toggle(nil) 
     end 
end 
----------------------------------------------------------------------------------------------------
--开始或则关闭SepllTimer
----------------------------------------------------------------------------------------------------
function SpellTimerOptionEnable_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.EnabledTest = 1 
	 SpellTimerOption_Toggle(1) 
	 SpellTimer_Toggle(1) 
     else 
         SpellTimerOption_Toggle(nil) 
	 SpellTimer_Toggle(nil) 
     end 
end 
---------------------------------------------------------------------------------------------------
--开启或则禁止某法术时的显示
---------------------------------------------------------------------------------------------------
function Checkbox_Slider_Toggle(SpellTimerFrame, enable)
     local SpellTimerCheckbox = getglobal(SpellTimerFrame:GetName().."Checkbox")
     local SpellTimerSlider = getglobal(SpellTimerFrame:GetName().."Slider")
     if (enable) then
         MobElement_Enable(SpellTimerCheckbox) 
	 SpellTimer_Slider_Enable(SpellTimerSlider) 
     else 
         MobElement_Disable(SpellTimerCheckbox) 
	 SpellTimer_Slider_Disable(SpellTimerSlider) 
     end 
end 
-----------------------------------------------------------------------------------------------------
--禁止或者开启该法术并将信息传后原tab
-----------------------------------------------------------------------------------------------------
function SpellTimerOptionFrameCheckbox_OnClick(id)
     if (this:GetChecked() == 1) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {}
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].disabled = nil
         local SpellTimerSlider 
	 SpellTimer_Slider_Enable(getglobal(this:GetParent():GetName().."Slider")) 
    else
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {} 
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].disabled = 1 
	 SpellTimer_Slider_Disable(getglobal(this:GetParent():GetName().."Slider")) 
    end 
end 
----------------------------------------------------------------------------------------------------
--初始话配置选项中的信息
----------------------------------------------------------------------------------------------------
function Creat_OptionSpells()
    if (not OptionSpells) then
        OptionSpells = {n = 0}
        local spellname 
	for spellname in SpellTimer_Spells[PlayerClass] do 
	    table.insert(OptionSpells, spellname) 
        end 
	for Spellname in SpellTimer_Talents[PlayerClass] do
            table.insert(OptionSpells, SpellTimer_Talents[PlayerClass][Spellname][4])
	end
    end 
end 
----------------------------------------------------------------------------------------------------
--配置窗口显示
---------------------------------------------------------------------------------------------------
function SpellTimerOptionFrame_OnShow() 
    SpellTimerList_Update() 
    local text = getglobal(this:GetParent():GetName().."TitleText")  
    text:SetText(SPELL_TIMER)     
end 
---------------------------------------------------------------------------------------------------
--得到配置选项中法术的数目
---------------------------------------------------------------------------------------------------
function Get_Spells_Number() 
     Creat_OptionSpells() 
     return table.getn(OptionSpells) 
end 
---------------------------------------------------------------------------------------------------
--得到指定编号的法术信息，如果存在的话
---------------------------------------------------------------------------------------------------
function Get_Config_Spells(id) 
     Creat_OptionSpells()
     if (OptionSpells[id]) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {}
         end
         if (SpellTimer_Config.Spells[OptionSpells[id]]) then
             return OptionSpells[id], not SpellTimer_Config.Spells[OptionSpells[id]].disabled, SpellTimer_Config.Spells[OptionSpells[id]].delay 
	 else 
             return OptionSpells[id], 1, nil 
         end 
    end 
end 
----------------------------------------------------------------------------------------------------
--该函数没用到
----------------------------------------------------------------------------------------------------
function Set_Enable_Delay(id, enable, value) 
     Creat_OptionSpells()
     if (OptionSpells[id]) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {}
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].enabled = enable 
	 SpellTimer_Config.Spells[OptionSpells[id]].delay = value 
     end 
end 
-----------------------------------------------------------------------------------------------------
--显示指定id的法术信息
-----------------------------------------------------------------------------------------------------
function SetUp_SpellOption(SpellTimerFrame, spellname, enable, value)
     if (spellname) then
         local SpellTimerCheckbox = getglobal(SpellTimerFrame:GetName().."Checkbox")
         local SpellTimerSlider = getglobal(SpellTimerFrame:GetName().."Slider")
         local str = getglobal(SpellTimerCheckbox:GetName().."Text") 
	 str:SetText(spellname)
         if (enable) then
             SpellTimerCheckbox:SetChecked(1)
	     SpellTimer_Slider_Enable(SpellTimerSlider) 
	 else 
	     SpellTimerCheckbox:SetChecked(0) 
	     SpellTimer_Slider_Disable(SpellTimerSlider) 
         end
         if (value) then
             local SliderText = getglobal(SpellTimerSlider:GetName().."Text") 
	     SpellTimerSlider:SetValue(value)
	     SliderText:SetText(value) 
	 else
             local SliderText = getglobal(SpellTimerSlider:GetName().."Text") 
	     SpellTimerSlider:SetValue(0)
	     SliderText:SetText(0) 
         end 
    end 
end 
----------------------------------------------------------------------------------------------------------------
--打开配置版面后Updata显示信息
----------------------------------------------------------------------------------------------------------------
function SpellTimerList_Update()
     local SpellNumbers = Get_Spells_Number()
     local OffSet = FauxScrollFrame_GetOffset(SpellTimerScrollFrame)
     local id 
     for i = 1, 8, 1 do
         id = OffSet + i
         local str, enable, delay = Get_Config_Spells(id)
         local SpellOption = getglobal("SpellTimerOptionFrameSpellOption"..i) 
	 SpellOption:SetID(id)
	 SetUp_SpellOption(SpellOption, str, enable, delay)
         if ( id > SpellNumbers ) then
             SpellOption:Hide() 
	 else 
	     SpellOption:Show() 
         end 
     end
     if (SpellTimer_Config.EnabledTest) then
         FauxScrollFrame_Update(SpellTimerScrollFrame, SpellNumbers, 8, 20) 
     else 
         FauxScrollFrame_Update(SpellTimerScrollFrame, 1, 8, 20) 
     end 
end 

function SpellTimerOptionShowProgress_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.ShowProgressBar = 1 
     else 
         SpellTimer_Config.ShowProgressBar = nil 
     end 
end 

function SpellTimerOptionShowProgress_OnShow() 
     getglobal(this:GetName().."Text"):SetText(SHOW_PROGRESS_BAR)
     if (SpellTimer_Config.EnabledTest) then
         MobElement_Enable(this) 
     else 
         MobElement_Disable(this) 
     end
     if (SpellTimer_Config.ShowProgressBar) then
         this:SetChecked(1) 
     else 
         this:SetChecked(0) 
     end 
end 

function SpellTimerOptionShowName_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.ShowName = 1 
	 SpellTimer_Config.ShowTargetName = nil
	 SpellTimerOptionShowTargetName:SetChecked(0)
     else 
         SpellTimer_Config.ShowName = nil 
     end 
end 

function SpellTimerOptionShowName_OnShow() 
     getglobal(this:GetName().."Text"):SetText(SHOW_SPELL_NAME)
     if ( not SpellTimer_Config.EnabledTest) then
         MobElement_Disable(this) 
     elseif (SpellTimer_Config.ShowTargetName) then
         this:SetChecked(0)  
	 MobElement_Enable(this) 
	 return 
     else 
         MobElement_Enable(this)  
     end
     if (SpellTimer_Config.ShowName) then
         this:SetChecked(1) 
     else 
         this:SetChecked(0) 
     end 
end 
-----------------------------------------------------------------------------------------------
--设置指定id<也就是当前法术>法术的延迟时间
-----------------------------------------------------------------------------------------------
function SpellTimerOptionFrameSlider_OnChange(id)
     if (this.disabled) then 
         return 
     end
     local delay_time = this:GetValue() 
     this.value = delay_time 
     getglobal(this:GetName().."Text"):SetText(delay_time)
     if (delay_time > 0) then
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {} 
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
             SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].delay = delay_time
    else
         if (not SpellTimer_Config.Spells) then
             SpellTimer_Config.Spells = {} 
         end
         if (not SpellTimer_Config.Spells[OptionSpells[id]]) then
            SpellTimer_Config.Spells[OptionSpells[id]] = {}
         end 
	 SpellTimer_Config.Spells[OptionSpells[id]].delay = nil 
    end 
end 

function SpellTimer_Slider_Disable(slider)
     local name = slider:GetName() 
     getglobal(name.."Thumb"):Hide() 
     getglobal(name.."Text"):SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b) 
     slider.disabled = 1 
end 

function SpellTimer_Slider_Enable(slider)
     local name = slider:GetName() 
     getglobal(name.."Thumb"):Show() 
     getglobal(name.."Text"):SetVertexColor(NORMAL_FONT_COLOR.r , NORMAL_FONT_COLOR.g , NORMAL_FONT_COLOR.b) 
     slider.disabled = nil
     if (slider.value) then
         slider:SetValue(slider.value) 
     end 
end 

function MobElement_Disable(obj) 
     obj:Disable() 
     local textOb = getglobal(obj:GetName().."Text") 
     textOb:SetTextColor(0.5, 0.5, 0.5) 
end 

function MobElement_Enable(obj) 
     obj:Enable() 
     local textOb = getglobal(obj:GetName().."Text") 
     textOb:SetTextColor(1.0, 0.82, 0) 
end 
-----------------------------------------------------------------------------------------------------
--瞄准施法计时,也可以很简单的写出扩展
-----------------------------------------------------------------------------------------------------
function SpelltimerCasteBar_OnLoad()
	this:SetMinMaxValues(0, 1)
	this:SetValue(1)	
end
------------------------------------------------------------------------------------------------------
--得到瞄准施法时间
------------------------------------------------------------------------------------------------------
function SpelltimerCasteBar_GetCastSpeed()
	local speedmin = UnitRangedDamage("player")
	local speedmax, text
	if speedmin > 0 then
		BigFootTooltip:SetOwner(UIParent, "ANCHOR_NONE")
		BigFootTooltip:SetInventoryItem("player", 18)
		BigFootTooltip:Show()
		for i=1,10 do
			text = getglobal("BigFootTooltipTextRight"..i)
			if text:IsVisible() then
				_, _, speedmax = string.find(text:GetText(), "([%,%.%d]+)")
				if speedmax then
				    break
				end
			end
		end                
	end
	local speed = 1
	BigFootTooltip:Hide()
	if speedmax then
		speed = speedmax / speedmin
	end
	speed = (3.0 / speed) + 0.6
	return speed
end
---------------------------------------------------------------------------------------------------
--被打断
---------------------------------------------------------------------------------------------------
function SpelltimerCasteBar_Interrupted()
	if SpelltimerCasteBar:IsShown() then
		local min,max = SpelltimerCasteBar:GetMinMaxValues()
		SpelltimerCasteBar:SetValue(max)
		SpelltimerCasteBar:SetStatusBarColor(1.0, 0.0, 0.0)
		SpelltimerCasteBarSpark:Hide()
		SpelltimerCasteBarTextLeft:SetText(SPELLTIMER_CAST_BREAK)
		SpelltimerCasteBarFlash:SetAlpha(0.0)
		SpelltimerCasteBarFlash:Show()
		SpelltimerCasteBar.casting = nil
		SpelltimerCasteBar.flash = 1
		SpelltimerCasteBar.fadeOut = 1
	end
	SpelltimerCasteBar.spell = ""
end
----------------------------------------------------------------------------------------------------
--闪烁
----------------------------------------------------------------------------------------------------
function SpelltimerCasteBar_FlashBar()
	if not SpelltimerCasteBar:IsVisible() then
		SpelltimerCasteBar:Hide()
	end
	if SpelltimerCasteBar:IsShown() then
		local min, max = SpelltimerCasteBar:GetMinMaxValues()
		SpelltimerCasteBar:SetValue(max)
		SpelltimerCasteBar:SetStatusBarColor(0.0, 1.0, 0.0)
		SpelltimerCasteBarSpark:Hide()
		SpelltimerCasteBarFlash:SetAlpha(0.0)
		SpelltimerCasteBarFlash:Show()
		SpelltimerCasteBar.casting = nil
		SpelltimerCasteBar.flash = 1
		SpelltimerCasteBar.fadeOut = 1
	end
end
---------------------------------------------------------------------------------------------
--瞄准施法
----------------------------------------------------------------------------------------------
function SpelltimerCasteBar_CastAimed()       
	if SpellTimer_Config.EnableCastBar then
		local min = GetTime()
		local max = min + SpelltimerCasteBar_GetCastSpeed()
--                local max = min + 2.5
		SpelltimerCasteBar:SetStatusBarColor(1.0, 0.7, 0.0)
		SpelltimerCasteBarSpark:Show()
		SpelltimerCasteBar:SetMinMaxValues(min, max)
		SpelltimerCasteBar:SetValue(min)
		SpelltimerCasteBarTextLeft:SetText(SPELLTIMER_AIMED)
		SpelltimerCasteBar:SetAlpha(1.0)
		SpelltimerCasteBar.casting = 1
		SpelltimerCasteBar.fadeOut = nil
		SpelltimerCasteBar:Show()
		SpelltimerCasteBar.spell = SPELLTIMER_AIMED
	end
end
---------------------------------------------------------------------------------------------
--Event
---------------------------------------------------------------------------------------------
function SpelltimerCastBar_Onevent()
        if (event == "PLAYER_ALIVE") then 
                SpellTimer_GetTalents()   
        elseif (event == "SPELLCAST_INTERRUPTED" or event == "SPELLCAST_FAILED") then                
	        BigFoot_DelayCall(SpelltimerCasteBar_Interrupted,0.05)
        elseif (event == "SPELLCAST_START") then
	        if SpelltimerCasteBarMove:IsVisible() then
		        SpelltimerCasteBarMove:Hide()
		end	
        elseif (event == "SPELLCAST_DELAYED") then
		if SpelltimerCasteBar:IsShown() and SpelltimerCasteBar.spell == SPELLTIMER_AIMED then		
			local min, max = this:GetMinMaxValues()
			local delay = arg1 / 1000
			min = min + delay
			max = max + delay
			SpelltimerCasteBar:SetMinMaxValues(min, max)
		end        
        elseif (event == "SPELLCAST_STOP") then         
	        BigFoot_DelayCall(SpelltimerCasteBar_FlashBar,0.05) 
        end
end

function SpelltimerCasteBar_OnUpdate()
	local min, max = SpelltimerCasteBar:GetMinMaxValues()
	if this.casting then
		local status = GetTime()
		if status > max then
			status = max
		end
		SpelltimerCasteBarTextRight:SetText(format("%0.1f",max-status))
		SpelltimerCasteBar:SetValue(status)
		SpelltimerCasteBarFlash:Hide()
		local sparkPosition = ((status - min) / (max - min)) * 195
		if sparkPosition < 0 then
			sparkPosition = 0
		end
		SpelltimerCasteBarSpark:SetPoint("CENTER", SpelltimerCasteBar, "LEFT", sparkPosition, 0)
	elseif this.flash then
		local alpha = SpelltimerCasteBarFlash:GetAlpha() + CASTING_BAR_FLASH_STEP
		if alpha < 1 then
			SpelltimerCasteBarFlash:SetAlpha(alpha)
		else
			SpelltimerCasteBarFlash:SetAlpha(1.0)
			this.flash = nil
		end
	elseif this.fadeOut then
		local alpha = this:GetAlpha() - CASTING_BAR_ALPHA_STEP
		if alpha > 0 then
			this:SetAlpha(alpha)
		else
			this.fadeOut = nil
			this:Hide()
		end
	end
end	
----------------------------------------------------------------------------------------------------
--一些简单的命令,主要是移动瞄准施法条用
----------------------------------------------------------------------------------------------------
SLASH_SpelltimerCasteBar1 = "/spelltimer"
SlashCmdList["SpelltimerCasteBar"] = function(msg)
	if msg == "move" then
		if SpelltimerCasteBarMove:IsVisible() then
		        SpelltimerCasteBarMove:Hide()
			SpelltimerCasteBar:Hide()
		else
		        SpelltimerCasteBarMove:Show()
			SpelltimerCasteBar:Show()			
			SpelltimerCasteBar:SetAlpha(1)
		end	
	elseif msg == "toggle" then
		if SpellTimer_Config.EnableCastBar == 1 then
			SpellTimer_Config.EnableCastBar = nil
			DEFAULT_CHAT_FRAME:AddMessage(SpellTimer_CastBar_Disable, 0, 1, 1)
		else
		        SpellTimer_Config.EnableCastBar = 1
			DEFAULT_CHAT_FRAME:AddMessage(SpellTimer_CastBar_Enable, 0, 1, 1)
		end
        elseif msg == "show" then
	        if ( not SpellTimerOptionFrame:IsVisible() ) then
			PlaySound("igMainMenuOption");
			ST_Show_Options(); 
		end
        elseif msg == "hide" then
	        if ( SpellTimerOptionFrame:IsVisible() ) then
			PlaySound("igMainMenuOption")
                        if (SpellTimer_EnemyOptionFrame) then
    	                     SpellTimer_EnemyOptionFrame:Hide()
                        end    
                        SpellTimerOptionFrame:Show()
                        HideUIPanel(SpellTimer_Option)			
		end 	        
	end
end
--------------------------------------------------------------------------------------------------
--开启/关闭瞄准施法计时
--------------------------------------------------------------------------------------------------
function Enable_STCastBar_OnClick()
     if (this:GetChecked() == 1) then
         SpellTimer_Config.EnableCastBar = 1
     		 
     else
         SpellTimer_Config.EnableCastBar = nil
     end 
end
function Enable_STCastBar_OnShow()
     getglobal(this:GetName().."Text"):SetText(ENABLE_SPELLTIMER_CASTBAR) 
     if ( not SpellTimer_Config.EnabledTest) then
    	 MobElement_Disable(this) 
     else
         MobElement_Enable(this)  
     end
     if (SpellTimer_Config.EnableCastBar) then
    	 this:SetChecked(1)
     else
         this:SetChecked(0)
     end
end
---------------------------------------------------------------------------------------------------
--得到天赋信息,原来在ST_DB里的.
---------------------------------------------------------------------------------------------------
function SpellTimer_GetTalents()
    if (not PlayerClass) then
    	PlayerClass = UnitClass("player")
    end    
    local numTabs = GetNumTalentTabs()    
    local name, iconTexture, tier, column, rank, maxRank,text;
    local numTalents
    local tabname, texture, points, fileName;
    if (not Talents) then
    	Talents = {}    
    end      
    for x=1, numTabs do
         numTalents = GetNumTalents( x )  
         tabname, texture, points, fileName = GetTalentTabInfo( x )        
         for i=1, numTalents do
              name, iconTexture, tier, column, rank, maxRank = GetTalentInfo( x, i)
	      if (SpellTimer_Talents[PlayerClass][name] and rank > 0) then 
	           effec = SpellTimer_Talents[PlayerClass][name][4]
		   if (not Talents[effec]) then
		   	Talents[effec] = {}
		   end
		   BigFoot_Tooltip_Init(1)
                   SPTalentTooltip:SetTalent(x,i)
                   local text = BigFoot_Tooltip_GetText(1) 
                   SPTalentTooltip:Hide()
                   _, _, duration = string.find(text, SpellTimer_Talents[PlayerClass][name][1])
		   if ( SpellTimer_Talents[PlayerClass][name][2]) then
		   	duration = tonumber(tonumber(duration)*SpellTimer_Talents[PlayerClass][name][2])
		   else
		        duration = tonumber(duration)
		   end	
		   Talents[effec][1] = duration
		   Talents[effec][2] = iconTexture
              end
         end
    end   
end
---------------------------------------------------------------------------------------------------------
--显示目标姓名
---------------------------------------------------------------------------------------------------------
function ST_ShowTargetName_OnClick()
    if (this:GetChecked() == 1) then
    	 SpellTimer_Config.ShowTargetName = 1
	 SpellTimer_Config.ShowName = nil
	 SpellTimerOptionShowName:SetChecked(0)
    else
         SpellTimer_Config.ShowTargetName = nil	
    end
end
function ST_ShowTargetName_OnShow()
    getglobal(this:GetName().."Text"):SetText(SHOW_SPELL_TARGETNAME) 
    if ( not SpellTimer_Config.EnabledTest) then
    	 MobElement_Disable(this)
    elseif (SpellTimer_Config.ShowName) then
         MobElement_Enable(this) 
         this:SetChecked(0)
	 return
    else
         MobElement_Enable(this)  
    end
    if (SpellTimer_Config.ShowTargetName) then
    	 this:SetChecked(1)
    else
         this:SetChecked(0)
    end
end
--------------------------------------------------------------------------------------------------------
--简化鼠标显示
--------------------------------------------------------------------------------------------------------
function ST_MoseInfo_OnClick()
     if (this:GetChecked() == 1) then
     	 SpellTimer_Config.TooltipInfo = 1
     else
         SpellTimer_Config.TooltipInfo = nil
     end
end
function ST_MoseInfo_Onshow()
     getglobal(this:GetName().."Text"):SetText(SHOW_TOOLTIP_INFO)
     if ( not SpellTimer_Config.EnabledTest) then
    	 MobElement_Disable(this) 
     else
         MobElement_Enable(this)  
     end
     if (SpellTimer_Config.TooltipInfo) then
     	 this:SetChecked(1)
     else
         this:SetChecked(0)
     end
end
----------------------------------------------------------------------------------------------------------
--动态载入Enemy部分
----------------------------------------------------------------------------------------------------------
function ST_LoadEnemy_OnClick()     
     PlaySound("igMainMenuOption")	
     if (IsAddOnLoadOnDemand("SpellTimer_Enemy")) then              
	  if (IsAddOnLoaded("SpellTimer_Enemy")) then	           
	      SpellTimer_EnemyOptionFrame:Show()
              SpellTimerOptionFrame:Hide()
	      ST_ColorPicker_OnShow()
	  else 
	      EnableAddOn("SpellTimer_Enemy") 
	      LoadAddOn("SpellTimer_Enemy")
	      if (not EnemyConfig) then
	      	   EnemyConfig = {}
    	           EnemyConfig = ST_Clone(Enemy_Default_Config)
	      end
	      SpellTimer_EnemyBar_Toggle(1)
	      SpellTimer_Config["EnableEnemy"] = 1 
	      ChatFrame1:AddMessage("SpellTimer_Enemy Loaded!",1,0,1)
	  end	               
     end
     ST_ENEMY_TOOLTIP = ST_ENEMY_TEXT[2]
end
function ST_Eenemy_OnShow()    
     if (IsAddOnLoadOnDemand("SpellTimer_Enemy")) then 
         if (IsAddOnLoaded("SpellTimer_Enemy")) then
	      ST_ENEMY_TOOLTIP = ST_ENEMY_TEXT[2] 
	 else
	      ST_ENEMY_TOOLTIP = ST_ENEMY_TEXT[1]
	 end    
         MobElement_Enable(this) 	
     else
         MobElement_Disable(this) 
     end     
end
--========================================================================================
--===============================WOWSHELL=================================================
--========================================================================================
function Load_Default_OnClick()
     PlaySound("igMainMenuOption")
     SpellTimer_Config = {}
     SpellTimer_Config = ST_Clone(ST_Default_Config)
     SpellTimerList_Update()            
     if (IsAddOnLoaded("SpellTimer_Enemy")) then
	   EnemyConfig = {}
	   EnemyConfig = ST_Clone(Enemy_Default_Config)
	   SpellTimer_EnemyList_Update()
     end
     if (SpellTimerOptionFrame:IsVisible()) then
     	 SpellTimerOptionFrame:Hide()
         SpellTimerOptionFrame:Show()
     else
         SpellTimer_EnemyOptionFrame:Hide()
	 SpellTimer_EnemyOptionFrame:Show()
     end     
end

function SpellTimer_Option_OnShow()     
     SpellTimerOptionFrame:Show()
     local texture = getglobal(this:GetName().."IconTexture")
     texture:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon") 
end

function SpellTimer_Cancel()
    PlaySound("igMainMenuOption")
    if (SpellTimer_EnemyOptionFrame) then
    	 SpellTimer_EnemyOptionFrame:Hide()
    end    
    SpellTimerOptionFrame:Show()
    HideUIPanel(this:GetParent())
    SpellTimer_Config = {}
    SpellTimer_Config = ST_Clone(org_stconfig)
    if (IsAddOnLoaded("SpellTimer_Enemy")) then
        EnemyConfig = {}
        if ( org_enconfig) then             
    	     EnemyConfig = ST_Clone(org_enconfig)
	else
             EnemyConfig = ST_Clone(Enemy_Default_Config)
        end        
    end    
end
--------------------------------------------------------------------------------------------
--克隆一个table
--------------------------------------------------------------------------------------------
function ST_Clone(t) 
    local new = {}             
    local i, v = next(t, nil)  
    while i do
  	 if type(v)=="table" then 
  	      v=ST_Clone(v)
  	 end 
         new[i] = v
         i, v = next(t, i)      
    end
    return new
end  
--------------------------------------------------------------------------------------------
--小地图按钮位置
--------------------------------------------------------------------------------------------
function ST_MinimapButton_UpdatePosition()     
    local where = ST_GetSetting()
    ST_MinimapFrame:ClearAllPoints()
    ST_MinimapFrame:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(where)), (80 * sin(where)) - 52)
end
function ST_SetSetting(value)   
    if (not value) then
        SpellTimer_Config["Settings"] = 20
    else
        SpellTimer_Config["Settings"] = value
    end 
end
function ST_GetSetting()
    local pos
    if (SpellTimer_Config["Settings"]) then     
         pos = SpellTimer_Config["Settings"]         
    else
         pos = 20	 
    end
    return pos
end