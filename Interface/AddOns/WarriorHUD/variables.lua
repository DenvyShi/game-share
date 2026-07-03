local _, klass = UnitClass("player")
if klass == "WARRIOR" then
	local version = 2.2

	function WHUD_Variables_Init()
		WHUD_RegisterEvent("ACTIONBAR_SLOT_CHANGED")
		WHUD_UPDATE_SPELLINFO()
	end

	WHUD_DEFAULT_VARS = {
		VERSION = version,
		Ragebar = {
			enabled = false,
			X = 600,
			Y = -400,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			fontsize = 25,
			texture = "mpowa_ragebar",
		},
		Cooldowns = {
			enabled = true,
			X = 650,
			Y = -350,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			flashtime = 2,
			fading = true,
			fadetime = 2,
			trinkets = true,
			racials = true
		},
		Overpower = {
			enabled = true,
			X = 585,
			Y = -300,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			MSG = "压制触发",
			mode = "text",
			pve = true,
		},
		Alerts = {
			enabled = true,
			X = 540,
			Y = -200,
			scale = 1,
			strata = "HIGH",
			transparency = 1,
			fontsize = 33,
			-- MODE
			["Battleshout"] = true,
			["Weightstone"] = true,
			["Salvation"] = true,
			["Execute"] = true
		},
		Glow = {
			["Overpower"] = true,
			["Execute"] = true,
			["Battleshout"] = true
		},
		Options = {
			X = 100,
			Y = -200
		}
	}
	WHUD_IMPORTANTSPELLS = {
		"嗜血",
		"旋风斩",
		"拦截",
		"冲锋",
		"缴械",
		"惩戒痛击",
		"血性狂暴",
		"反击风暴",
		"盾墙",
		"鲁莽",
		"死亡之愿",
		"盾牌格挡",
		"狂暴之怒",
		"破胆怒吼",
		"挑战怒吼",
		"嘲讽",
		"致死打击",
		"盾牌猛击",
		"复仇",
		-- RACIALS
		"战争践踏",
		"血性狂暴",
		"亡灵意志",
		"狂暴",
		"逃命专家",
		"影遁",
		"石像形态",
		-- ALERT
		"战斗怒吼",
	}
	WHUD_RACIALS = {
		"战争践踏",
		"血性狂暴",
		"亡灵意志",
		"狂暴",
		"逃命专家",
		"影遁",
		"石像形态",
	}
	WHUD_SPELLINFO = {}
	WHUD_SPELLS = {}
	for i = 1, table.getn(WHUD_IMPORTANTSPELLS) do
		WHUD_SPELLINFO[WHUD_IMPORTANTSPELLS[i]] = {1, 0, 0} -- default value for the important spells
		WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = WHUD_IMPORTANTSPELLS[i]
		if i == table.getn(WHUD_IMPORTANTSPELLS) then
			WHUD_SPELLINFO["Trinket1"] = {0, 0, 0}
			WHUD_SPELLINFO["Trinket2"] = {0, 0, 0} -- default values for the trinkets
			WHUD_SPELLINFO["压制"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "压制"
			WHUD_SPELLINFO["复仇"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "复仇"
			WHUD_SPELLINFO["拳击"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "拳击"
			WHUD_SPELLINFO["盾击"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "盾击"
			WHUD_SPELLINFO["斩杀"] = {1, 0, 0}
			WHUD_SPELLS[table.getn(WHUD_SPELLS) + 1] = "斩杀"
		end
	end

	-- Upgrade old versions, adding new added parameters
	function WHUD_Variables_Update()
		if WHUD_VARS.VERSION < version then
			if WHUD_VARS.VERSION < 1.5 then
				if WHUD_VARS.Overpower.mode == nil then
					WHUD_VARS.Overpower.mode = "text"
				end
			end
			if WHUD_VARS.VERSION < 1.6 then
				if WHUD_VARS.Cooldowns.trinkets == nil then
					WHUD_VARS.Cooldowns.trinkets = true
				end
			end
			if WHUD_VARS.VERSION < 1.7 then
				if WHUD_VARS.Cooldowns.fadeout then
					WHUD_VARS.Cooldowns.fadeout = nil
				end
				if WHUD_VARS.Cooldowns.fading == nil then
					WHUD_VARS.Cooldowns.fading = true
					WHUD_VARS.Cooldowns.fadetime = 2
				end
				if WHUD_VARS.Alerts == nil then
					WHUD_VARS.Alerts = {
						X = 0,
						Y = 100,
						scale = 1,
						strata = "HIGH",
						fontsize = 35,
						["Battleshout"] = true,
						["Weightstone"] = true,
						["Salvation"] = true
					}
				end
			end
			if WHUD_VARS.VERSION < 2.0 then
				WHUD_VARS.Glow = {
					["Overpower"] = true,
					["Execute"] = true,
					["Battleshout"] = true
				}
				WHUD_VARS.Alerts["Execute"] = true
				WHUD_VARS.Alerts.transparency = 1
				WHUD_VARS.Alerts.enabled = true
				WHUD_VARS.Overpower.pve = true
				WHUD_VARS.Overpower.transparency = 1
				WHUD_VARS.Ragebar.texture = "ragebar1"
				WHUD_VARS.Options = {
					X = 0,
					Y = 400
				}
				if WHUD_VARS.VERSION < 2.1 then
					WHUD_VARS.Cooldowns.racials = true
				end
			end
			WHUD_VARS.VERSION = version
		end
	end

	function WHUD_UPDATE_SPELLINFO()
		
		local function _createSet(list)
			local set = {}
			for _, l in ipairs(list) do set[l] = true end
			return set
		end

		-- updating the spellinfos, if the actionbar has been modified
		for i = 1, 100 do
			local name = GetSpellName(i, "player")
			if name == nil then
				return
			end

			for check = 1, table.getn(WHUD_IMPORTANTSPELLS) do
				if name == WHUD_IMPORTANTSPELLS[check] then
					-- slotID,startTime,endTime
					WHUD_SPELLINFO[name] = {i, 0, 0}
				end
			end

			-- Overpower/Revenge/Shield Bash/Pummel are no longer in the list and need to be checked extra ; Execute is also extra, for the glow
			local extras = _createSet{"压制", "复仇", "拳击", "盾击", "斩杀"}
			if extras[name] then
				WHUD_SPELLINFO[name] = {i, 0, 0}
			end
		end
	end

	function WHUD_Variables_Reset()
		WHUD_VARS = nil
		WHUD_VARS = WHUD_DEFAULT_VARS
		WHUD_Ragebar_VarUpdate()
		WHUD_Overpower_VarUpdate()
		WHUD_Cooldowns_VarUpdate()
		WHUD_Alerts_VarUpdate()
		DEFAULT_CHAT_FRAME:AddMessage(" >> |cff8f4108WarriorHUD|r 重置设置完成. 已经加载默认设置.")
	end
end
