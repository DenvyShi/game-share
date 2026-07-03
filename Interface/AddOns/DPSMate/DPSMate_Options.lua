local DPSMate = DPSMate

-- Events
DPSMate.Options:RegisterEvent("PARTY_MEMBERS_CHANGED")
DPSMate.Options:RegisterEvent("RAID_ROSTER_UPDATE")
DPSMate.Options:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Global Variables
DPSMate.Options.fonts = {
	["FRIZQT"] = UNIT_NAME_FONT,
	["ARIALN"] = "Fonts\\ARIALN.TTF",
	["MORPHEUS"] = "Fonts\\MORPHEUS.TTF",
	--latin fonts
	["visitor2"] = "Interface\\AddOns\\DPSMate\\fonts\\visitor2.TTF",
	["Accidental Presidency"] = "Interface\\AddOns\\DPSMate\\fonts\\Accidental Presidency.TTF",
	["Enigma__2"] = "Interface\\AddOns\\DPSMate\\fonts\\Enigma__2.TTF",
	["VeraSe"] = "Interface\\AddOns\\DPSMate\\fonts\\VeraSe.TTF",
	["AlteHaas"] = "Interface\\AddOns\\DPSMate\\fonts\\AlteHaas.TTF",
	["CaviarDreams"] = "Interface\\AddOns\\DPSMate\\fonts\\CaviarDreams.TTF",
	["Expressway"] = "Interface\\AddOns\\DPSMate\\fonts\\Expressway.TTF",
	["ExpresswayBold"] = "Interface\\AddOns\\DPSMate\\fonts\\ExpresswayBold.TTF",
	["Roboto"] = "Interface\\AddOns\\DPSMate\\fonts\\Roboto.TTF",
	["The Bad Times"] = "Interface\\AddOns\\DPSMate\\fonts\\The Bad Times.TTF",
	--cn fonts
	["Vegur"] = "Interface\\AddOns\\DPSMate\\fonts\\Vegur.TTF",
	["Mandarin1"] = "Interface\\AddOns\\DPSMate\\fonts\\Mandarin1.TTF",
	["Mandarin2"] = "Interface\\AddOns\\DPSMate\\fonts\\Mandarin2.TTF",
}
DPSMate.Options.fontflags = {
	["None"] = "NONE",
	["Outline"] = "OUTLINE",
	["Monochrome"] = "MONOCHROME",
	["Outlined monochrome"] = "OUTLINE, MONOCHROME",
	["Tick outlined"] = "THICKOUTLINE",
}
DPSMate.Options.statusbars = {
	["Aluminium"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Aluminium", 
	["Armory"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Armory", 
	["BantoBar"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\BantoBar", 
	["Glaze2"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Glaze2", 
	["Gloss"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Gloss", 
	["Graphite"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Graphite", 
	["Grid"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Grid", 
	["Healbot"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Healbot", 
	["LiteStep"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\LiteStep", 
	["Minimalist"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Minimalist", 
	["normTex"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\normTex", 
	["Otravi"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Otravi", 
	["Outline"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Outline", 
	["Perl"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Perl", 
	["Round"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Round", 
	["Smooth"] = "Interface\\AddOns\\DPSMate\\images\\statusbar\\Smooth", 
}
DPSMate.Options.bgtexture = {
	["Solid Background"] = "Interface\\CHATFRAME\\CHATFRAMEBACKGROUND",
	["UI-Tooltip-Background"] = "Interface\\Tooltips\\UI-Tooltip-Background",
}
DPSMate.Options.stratas = {
	[1] = "BACKGROUND",
	[2] = "LOW",
	[3] = "HIGH",
}
DPSMate.Options.bordertextures = {
	["UI-Tooltip-Border"] = "Interface\\Tooltips\\UI-Tooltip-Border",
}
DPSMate.Options.Dewdrop = AceLibrary("DPSDewdrop-2.0")
DPSMate.Options.graph = AceLibrary("DPSGraph-1.0")
DPSMate.Options.Options = {
	[1] = {
		type = 'group',
		args = {
		},
		handler = DPSMate.Options,
	},
	[2] = {
		type = 'group',
		args = {
			total = {
				order = 10,
				type = 'toggle',
				name = DPSMate.L["total"],
				desc = DPSMate.L["totalmode"],
				get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["total"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "total", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
			currentFight = {
				order = 20,
				type = 'toggle',
				name = DPSMate.L["mcurrent"],
				desc = DPSMate.L["currentmode"],
				get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["currentfight"] end,
				set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
			},
		},
		handler = DPSMate.Options,
	},
	[3] = {
		type = 'group',
		args = {
			test = {
				order = 5,
				type = 'toggle',
				name = DPSMate.L["testmode"],
				desc = DPSMate.L["testmodedesc"],
				get = function() return DPSMate.Options.TestMode end,
				set = function() DPSMate.Options:ActivateTestMode(); DPSMate.Options.Dewdrop:Close() end,
			},
			report = {
				order = 10,
				type = 'execute',
				name = DPSMate.L["report"],
				desc = DPSMate.L["reportsegment"],
				func = function() DPSMate_Report:Show(); DPSMate.Options.Dewdrop:Close() end,
			},
			reset = {
				order = 11,
				type = 'execute',
				name = DPSMate.L["reset"],
				desc = DPSMate.L["resetdesc"],
				func = function() DPSMate_PopUp:Show(); DPSMate.Options.Dewdrop:Close() end,
			},
			realtime = {
				order = 12,
				type = 'group',
				name = DPSMate.L["mrealtime"],
				desc = DPSMate.L["mrealtimedesc"],
				args = {
					damage = {
						order = 1,
						type = 'execute',
						name = DPSMate.L["damagedone"],
						desc = DPSMate.L["realtimedmgdone"],
						func = function() DPSMate.Options:SelectRealtime(DPSMate.Options.Dewdrop:GetOpenedParent(), "damage") end
					},
					dmgt = {
						order = 2,
						type = 'execute',
						name = DPSMate.L["damagetaken"],
						desc = DPSMate.L["realtimedmgtaken"],
						func = function() DPSMate.Options:SelectRealtime(DPSMate.Options.Dewdrop:GetOpenedParent(), "dmgt") end
					},
					heal = {
						order = 3,
						type = 'execute',
						name = DPSMate.L["healing"],
						desc = DPSMate.L["realtimehealing"],
						func = function() DPSMate.Options:SelectRealtime(DPSMate.Options.Dewdrop:GetOpenedParent(), "heal") end
					},
					eheal = {
						order = 4,
						type = 'execute',
						name = DPSMate.L["effectivehealing"],
						desc = DPSMate.L["realtimeehealing"],
						func = function() DPSMate.Options:SelectRealtime(DPSMate.Options.Dewdrop:GetOpenedParent(), "eheal") end
					}
				}
			},
			blank1 = {
				order = 20,
				type = 'header',
			},
			startnewsegment = {
				order = 25,
				type = 'execute',
				name = DPSMate.L["newsegment"],
				desc = DPSMate.L["newsegmentdesc"],
				func = function() DPSMate.Options:NewSegment("New segment"); DPSMate.Options.Dewdrop:Close() end,
			},
			deletesegment = {
				order = 30,
				type = 'group',
				name = DPSMate.L["removesegment"],
				desc = DPSMate.L["removesegmentdesc"],
				args = {},
			},
			blank2 = {
				order = 31,
				type = 'header',
			},
			showAll  = {
				order = 32,
				type = 'execute',
				name = DPSMate.L["showAll"],
				desc = DPSMate.L["showAllDesc"],
				func = function() for _, val in DPSMate.DPSMateSettings["windows"] do DPSMate.Options:Show(getglobal("DPSMate_"..val["name"])) end; DPSMate.Options.Dewdrop:Close() end,
			},
			hideAll  = {
				order = 33,
				type = 'execute',
				name = DPSMate.L["hideAll"],
				desc = DPSMate.L["hideAllDesc"],
				func = function() for _, val in DPSMate.DPSMateSettings["windows"] do DPSMate.Options:Hide(getglobal("DPSMate_"..val["name"])) end; DPSMate.Options.Dewdrop:Close() end,
			},
			showwindow = {
				order = 36,
				type = 'group',
				name = DPSMate.L["showwindow"],
				desc = DPSMate.L["showwindowdesc"],
				args = {},
			},
			hidewindow = {
				order = 37,
				type = 'group',
				name = DPSMate.L["hidewindow"],
				desc = DPSMate.L["hidewindowdesc"],
				args = {},
			},
			blank3 = {
				order = 38,
				type = 'header',
			},
			lock = {
				order = 40,
				type = 'toggle',
				name = DPSMate.L["lock"],
				desc = DPSMate.L["lockdesc"],
				get = function() return DPSMate.DPSMateSettings["lock"] end,
				set = function() DPSMate.Options:Lock(); DPSMate.Options.Dewdrop:Close() end,
			},
			unlock = {
				order = 50,
				type = 'toggle',
				name = DPSMate.L["unlock"],
				desc = DPSMate.L["unlock"],
				get = function() return not DPSMate.DPSMateSettings["lock"] end,
				set = function() DPSMate.Options:Unlock(); DPSMate.Options.Dewdrop:Close() end,
			},
			configure = {
				order = 80,
				type = 'execute',
				name = DPSMate.L["config"],
				desc = DPSMate.L["config"],
				func = function() DPSMate_ConfigMenu:Show(); DPSMate.Options.Dewdrop:Close() end,
			},
			close = {
				order = 90,
				type = 'execute',
				name = DPSMate.L["close"],
				desc = DPSMate.L["close"],
				func = function() DPSMate.Options.Dewdrop:Close() end,
			},
		},
		handler = DPSMate.Options,
	},
	[4] = {
		type = 'group',
		args = {
			report = {
				order = 10,
				type = 'group',
				name = DPSMate.L["report"],
				desc = DPSMate.L["reportdesc"],
				args = {
					whisper = {
						order = 10,
						type = "text",
						name = DPSMate.L["whisper"],
						desc = DPSMate.L["whisperdesc"],
						get = function() return "" end,
						set = function(name) DPSMate.Options:ReportUserDetails(DPSMate.Options.Dewdrop:GetOpenedParent(), DPSMate.L["whisper"], name); DPSMate.Options.Dewdrop:Close() end,
						usage = "<name>",
					},
				},
			},
			compare = {
				order = 20,
				type = 'group',
				name = DPSMate.L["comparewith"],
				desc = DPSMate.L["comparewithdesc"],
				args = {
				
				},
			}
		},
		handler = DPSMate.Options,
	},
	[5] = {
		type = 'group',
		args = {
			classes = {
				order = 10,
				type = 'group',
				name = DPSMate.L["classes"],
				desc = DPSMate.L["classesdesc"],
				args = {
					warrior = {
						order = 10,
						type = 'toggle',
						name = DPSMate.L["warrior"],
						desc = DPSMate.L["warriordesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["warrior"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "warrior") end,
					},
					rogue = {
						order = 20,
						type = 'toggle',
						name = DPSMate.L["rogue"],
						desc = DPSMate.L["roguedesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["rogue"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "rogue") end,
					},
					priest = {
						order = 30,
						type = 'toggle',
						name = DPSMate.L["priest"],
						desc = DPSMate.L["priestdesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["priest"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "priest") end,
					},
					hunter = {
						order = 40,
						type = 'toggle',
						name = DPSMate.L["hunter"],
						desc = DPSMate.L["hunterdesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["hunter"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "hunter") end,
					},
					druid = {
						order = 50,
						type = 'toggle',
						name = DPSMate.L["druid"],
						desc = DPSMate.L["druiddesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["druid"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "druid") end,
					},
					mage = {
						order = 60,
						type = 'toggle',
						name = DPSMate.L["mage"],
						desc = DPSMate.L["magedesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["mage"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "mage") end,
					},
					warlock = {
						order = 70,
						type = 'toggle',
						name = DPSMate.L["warlock"],
						desc = DPSMate.L["warlockdesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["warlock"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "warlock") end,
					},
					paladin = {
						order = 80,
						type = 'toggle',
						name = DPSMate.L["paladin"],
						desc = DPSMate.L["paladindesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["paladin"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "paladin") end,
					},
					shaman = {
						order = 90,
						type = 'toggle',
						name = DPSMate.L["shaman"],
						desc = DPSMate.L["shamandesc"],
						get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterclasses"]["shaman"] end,
						set = function() DPSMate.Options:ToggleFilterClass(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "shaman") end,
					},
				},
			},
			people = {
				order = 20,
				type = 'text',
				name = DPSMate.L["certainnames"],
				desc = DPSMate.L["certainnamesdesc"],
				get = function() if DPSMate.Options.Dewdrop:GetOpenedParent() then return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterpeople"] else return "" end end,
				set = function(names) DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["filterpeople"] = names;DPSMate:SetStatusBarValue();DPSMate.Options.Dewdrop:Close() end,
				usage = "<names>",
			},
			group = {
				order = 30,
				type = "toggle",
				name = DPSMate.L["grouponly"],
				desc = DPSMate.L["grouponlydesc"],
				get = function() return DPSMate.DPSMateSettings["windows"][(DPSMate.Options.Dewdrop:GetOpenedParent() or DPSMate).Key or 1]["grouponly"] end,
				set = function() DPSMate.DB:OnGroupUpdate();DPSMate.Options:SimpleToggle(DPSMate.Options.Dewdrop:GetOpenedParent().Key, "grouponly");DPSMate.Options.Dewdrop:Close() end,
			}
		},
		handler = DPSMate.Options,
	},
}
DPSMate.Options.TestMode = false

-- Local Variables
local LastPopUp = 0
local TimeToNextPopUp = 1
local PartyNum, LastPartyNum = 0, 0
local SelectedChannel = DPSMate.L["raid"]

local _G = getglobal
local tinsert = table.insert
local tremove = tremove
local strformat = string.format
local strgfind = string.gfind
local pairs = pairs

-- Begin Functions

function DPSMate.Options:SelectRealtime(obj, kind)
	if kind then
		local key = obj.Key or 1
		DPSMate.DPSMateSettings["windows"][key]["realtime"] = kind
		if not _G(obj:GetName().."_RealTime") then
			local f = CreateFrame("Frame", obj:GetName().."_RealTime", obj, "DPSMate_RealTime")
			local g = DPSMate.Options.graph:CreateGraphRealtime(f:GetName().."_Graph",f,"BOTTOMRIGHT","BOTTOMRIGHT",-5,5,190,150)
			g:SetAutoScale(true)
			g:SetGridSpacing(1.0,10.0)
			g:SetYMax(120)
			g:SetXAxis(-11,-1)
			g:SetFilterRadius(1)
			g:SetBarColors({0.2,0.0,0.0,0.4},{1.0,0.0,0.0,1.0})
			g:SetScript("OnUpdate",function() 
				if DPSMate.DB.loaded and DPSMate.DPSMateSettings["windows"][key]["realtime"] then
					g:OnUpdate(g)
					g:AddTimeData(DPSMate.DB:GetAlpha(key)) 
				end
			end)
			f:Show()
			g:Show()
			DPSMate.DB:HookGraphEvents()
		else
			 _G(obj:GetName().."_RealTime"):Show()
		end
		DPSMate.Options.Dewdrop:Close()
	end
end

function DPSMate.Options:InitializeConfigMenu()
	-- Inialize Extra Buttons
	for cat, val in pairs(DPSMate.DPSMateSettings["windows"]) do
		local f = CreateFrame("Button", "DPSMate_ConfigMenu_Menu_Button"..(9+cat), DPSMate_ConfigMenu_Menu, "DPSMate_Template_WindowButton")
		f.Key = cat
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+cat).."Text"):SetText(val["name"])
		if cat>1 then
			f:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(8+cat)), "BOTTOM")
			_G("DPSMate_ConfigMenu_Menu_Button"..(8+cat)).after = f
		else
			f:SetPoint("TOP", DPSMate_ConfigMenu_Menu_Button1, "BOTTOM")
		end
		f.after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu.num = 9+cat
		f.func = function()
			_G(this:GetParent():GetParent():GetName()..this:GetParent().selected):Hide()
			_G(this:GetParent():GetParent():GetName().."_Tab_Window"):Show()
			this:GetParent().selected = "_Tab_Window"
		end
	end
	local TL = DPSMate:TableLength(DPSMate.DPSMateSettings["windows"])
	if TL>=1 then
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(9+TL)), "BOTTOM")
	end
		
	-- Tab Window
	DPSMate_ConfigMenu_Tab_Window_Lock:SetChecked(DPSMate.DPSMateSettings["lock"])
	
	-- Tab Bars
	if not DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex then
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex = DPSMate_ConfigMenu_Tab_Bars_BarTexture:CreateTexture("BG", "ARTWORK")
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetWidth(110)
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetHeight(15)
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetPoint("TOPLEFT", DPSMate_ConfigMenu_Tab_Bars_BarTexture, "TOPLEFT", 23, -7)
	end
	
	-- Tab Title bar
	if not DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex then
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex = DPSMate_ConfigMenu_Tab_TitleBar_BarTexture:CreateTexture("BG", "ARTWORK")
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetWidth(110)
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetHeight(15)
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetPoint("TOPLEFT", DPSMate_ConfigMenu_Tab_TitleBar_BarTexture, "TOPLEFT", 23, -7)
	end
	
	-- Tab General Options
	DPSMate_ConfigMenu_Tab_GeneralOptions_Minimap:SetChecked(DPSMate.DPSMateSettings["showminimapbutton"])

	DPSMate_ConfigMenu_Tab_GeneralOptions_Total:SetChecked(DPSMate.DPSMateSettings["showtotals"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_BossFights:SetChecked(DPSMate.DPSMateSettings["onlybossfights"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Solo:SetChecked(DPSMate.DPSMateSettings["hidewhensolo"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Combat:SetChecked(DPSMate.DPSMateSettings["hideincombat"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Login:SetChecked(DPSMate.DPSMateSettings["hideonlogin"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_PVP:SetChecked(DPSMate.DPSMateSettings["hideinpvp"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Disable:SetChecked(DPSMate.DPSMateSettings["disablewhilehidden"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_MergePets:SetChecked(DPSMate.DPSMateSettings["mergepets"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_Segments:SetValue(DPSMate.DPSMateSettings["datasegments"])
	DPSMate_ConfigMenu_Tab_GeneralOptions_TargetScale:SetValue(DPSMate.DPSMateSettings["targetscale"])
	
	-- Tab Columns
	for i=1, 4 do
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Damage_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdmg"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DamageTaken_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdmgtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DTPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdtps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EDD_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsedd"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EDT_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsedt"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Healing_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnshealing"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_HealingTaken_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnshealingtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_HPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnshps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Overhealing_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsoverhealing"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHealing_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsehealing"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHealingTaken_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsehealingtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsehps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_EffectiveHPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsehps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_HAB_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnshab"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_FriendlyFire_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsfriendlyfire"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Threat_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsthreat"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_TPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnstps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Absorbs_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsabsorbs"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AbsorbsTaken_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsabsorbstaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_OHealingTaken_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsohealingtaken"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_OHPS_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsohps"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_FriendlyFireTaken_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsfriendlyfiretaken"][i])
	end
	for i=1, 2 do
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Deaths_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdeaths"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Interrupts_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsinterrupts"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Dispels_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdispels"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DispelsReceived_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdispelsreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Decurses_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdecurses"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DecursesReceived_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdecursesreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Disease_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdisease"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_DiseaseReceived_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsdiseasereceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Poison_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnspoison"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_PoisonReceived_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnspoisonreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Magic_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsmagic"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_MagicReceived_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsmagicreceived"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AurasGained_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsaurasgained"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AurasLost_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsauraslost"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_AuraUptime_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsaurauptime"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Procs_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsprocs"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Casts_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnscasts"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_Fails_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsfails"][i])
		_G("DPSMate_ConfigMenu_Tab_Columns_Child_CCBreaker_Check"..i):SetChecked(DPSMate.DPSMateSettings["columnsccbreaker"][i])
	end
	
	-- Tab Tooltips
	DPSMate_ConfigMenu_Tab_Tooltips_Tooltips:SetChecked(DPSMate.DPSMateSettings["showtooltips"])
	DPSMate_ConfigMenu_Tab_Tooltips_InformativeTooltips:SetChecked(DPSMate.DPSMateSettings["informativetooltips"])
	DPSMate_ConfigMenu_Tab_Tooltips_Rows:SetValue(DPSMate.DPSMateSettings["subviewrows"])
	
	-- Tab Broadcasting
	DPSMate_ConfigMenu_Tab_Broadcasting_Enable:SetChecked(DPSMate.DPSMateSettings["broadcasting"])
	DPSMate_ConfigMenu_Tab_Broadcasting_Cooldowns:SetChecked(DPSMate.DPSMateSettings["bccd"])
	DPSMate_ConfigMenu_Tab_Broadcasting_Ress:SetChecked(DPSMate.DPSMateSettings["bcress"])
	DPSMate_ConfigMenu_Tab_Broadcasting_KillingBlows:SetChecked(DPSMate.DPSMateSettings["bckb"])
	DPSMate_ConfigMenu_Tab_Broadcasting_Fails:SetChecked(DPSMate.DPSMateSettings["bcfail"])
	DPSMate_ConfigMenu_Tab_Broadcasting_RaidWarning:SetChecked(DPSMate.DPSMateSettings["bcrw"])
	
	-- Mode menu
	for num,v in DPSMate.ModuleNames do
		if not DPSMate:TContains(DPSMate.DPSMateSettings["enabledmodes"], v) then
			DPSMate.Options.Options[1]["args"][v] = nil
		end
	end
end

DPSMate.Options.OldLogout = Logout
function DPSMate.Options:Logout()
	if DPSMate.DPSMateSettings["sync"] then
		if UnitInRaid("player") then
			DPSMate:SendMessage(DPSMate.L["syncreseterror"])
		else
			DPSMate.Options:PopUpAccept(true, true)
		end
	else
		DPSMate.Options:PopUpAccept(true, true)
	end
	--self:SumGraphData()
	DPSMate.Options.OldLogout()
end
Logout = function() 
	if DPSMate.DPSMateSettings["dataresetslogout"] == 3 then
		DPSMate_Logout:Show() 
	elseif DPSMate.DPSMateSettings["dataresetslogout"] == 2 then
		--DPSMate.Options:SumGraphData()
		DPSMate.Options.OldLogout()
	else
		DPSMate.Options:Logout()
	end
end

function DPSMate.Options:ToggleVisibility()
	for _, val in DPSMate.DPSMateSettings["windows"] do
		if val["hidden"] then
			getglobal("DPSMate_"..val["name"]):Show()
			val["hidden"] = false
		else
			getglobal("DPSMate_"..val["name"]):Hide()
			val["hidden"] = true
		end
	end
end

function DPSMate.Options:ActivateTestMode()
	if self.TestMode then
		self.TestMode = false
		DPSMate:SetStatusBarValue()
	else
		self.TestMode = true
		for k,c in DPSMate.DPSMateSettings.windows do
			if DPSMate.DPSMateSettings["showtotals"] then
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Name"):SetText("Total")
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child_Total_Value"):SetText("3000000")
			end
			for i=1, DPSMate.MaxRows do
				local statusbar, name, value, texture, p = _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"), _G("DPSMate_"..c["name"].."_ScrollFrame_Child_StatusBar"..i.."_Icon"), ""
				_G("DPSMate_"..c["name"].."_ScrollFrame_Child"):SetHeight((i+1)*(c["barheight"]+c["barspacing"]))
				
				statusbar:SetStatusBarColor(0.78,0.61,0.43, 1)
				
				if c["ranks"] then p=i..". " else p="" end
				name:SetText(p.."Test "..i)
				value:SetText("100000")
				texture:SetTexture("Interface\\AddOns\\DPSMate\\images\\class\\warrior")
				statusbar:SetValue(100)
				
				statusbar.user = nil
				statusbar:Show()
			end
		end
	end
end

function DPSMate.Options:ToggleFilterClass(key, class)
	if DPSMate.DPSMateSettings["windows"][key]["filterclasses"][class] then
		DPSMate.DPSMateSettings["windows"][key]["filterclasses"][class] = false
	else
		DPSMate.DPSMateSettings["windows"][key]["filterclasses"][class] = true
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:SimpleToggle(key, opt)
	if DPSMate.DPSMateSettings["windows"][key][opt] then
		DPSMate.DPSMateSettings["windows"][key][opt] = false
	else
		DPSMate.DPSMateSettings["windows"][key][opt] = true
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:RosterUpdate()
	this:HideWhenSolo()
	if this:IsInParty() then
		if LastPartyNum == 0 then
			if DPSMate.DPSMateSettings["dataresetsjoinparty"] == 3 then
				if (GetTime()-LastPopUp) > TimeToNextPopUp then
					this:ShowResetPopUp()
					LastPopUp = GetTime()
				end
			elseif DPSMate.DPSMateSettings["dataresetsjoinparty"] == 1 then
				this:PopUpAccept(true, true)
			end
		elseif LastPartyNum ~= PartyNum	then
			if DPSMate.DPSMateSettings["dataresetspartyamount"] == 3 then
				if (GetTime()-LastPopUp) > TimeToNextPopUp then
					this:ShowResetPopUp()
					LastPopUp = GetTime()
				end
			elseif DPSMate.DPSMateSettings["dataresetspartyamount"] == 1 then
				this:PopUpAccept(true)
			end
		end
	else
		if LastPartyNum > PartyNum then
			if DPSMate.DPSMateSettings["dataresetsleaveparty"] == 3 then
				if (GetTime()-LastPopUp) > TimeToNextPopUp then
					this:ShowResetPopUp()
					LastPopUp = GetTime()
				end
			elseif DPSMate.DPSMateSettings["dataresetsleaveparty"] == 1 then
				this:PopUpAccept(true)
			end
		end
	end
	DPSMate.DB:OnGroupUpdate()
end

DPSMate.Options.PARTY_MEMBERS_CHANGED = function()
	this:RosterUpdate()
end

DPSMate.Options.RAID_ROSTER_UPDATE = function()
	this:RosterUpdate()
end

DPSMate.Options.PLAYER_ENTERING_WORLD = function()
	if DPSMate.DB.loaded then
		if DPSMate.DPSMateSettings["dataresetsworld"] == 3 then
			if (GetTime()-LastPopUp) > TimeToNextPopUp then
				DPSMate.Options:ShowResetPopUp()
				LastPopUp = GetTime()
			end
		elseif DPSMate.DPSMateSettings["dataresetsworld"] == 1 and not DPSMate.Options:IsInParty() then
			DPSMate.Options:PopUpAccept(true)
		end
		DPSMate.Options:HideInPvP()
		if DPSMate.DPSMateSettings["hideonlogin"] then
			for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
				DPSMate.Options:Hide(_G("DPSMate_"..val["name"]))
			end
		end
		DPSMate.DB:OnGroupUpdate()
	end
end

function DPSMate.Options:ShowResetPopUp()
	if DPSMate.DPSMateSettings["sync"] then
		if IsPartyLeader() or IsRaidOfficer() or IsRaidLeader() then
			DPSMate_PopUp:Show()
		end
	else
		DPSMate_PopUp:Show()
	end
end

function DPSMate.Options:IsInBattleground()
	for i=1, 4 do
		local status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch = GetBattlefieldStatus(i)
		if status == "active" and DPSMate.DPSMateSettings["hideinpvp"] then
			return true
		end
	end
	return false
end

function DPSMate.Options:HideInPvP()
	for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
		local frame = _G("DPSMate_"..val["name"])
		if DPSMate.Options:IsInBattleground() then
			frame:Hide()
			if DPSMate.DPSMateSettings["disablewhilehidden"] then
				DPSMate:Disable()
			end
		end
	end
	DPSMate.Options:HideWhenSolo()
end

function DPSMate.Options:HideWhenSolo()
	for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
		local frame = _G("DPSMate_"..val["name"])
		if DPSMate.DPSMateSettings["hidewhensolo"] and not DPSMate.Options:IsInBattleground() then
			if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then
				frame:Hide()
				if DPSMate.DPSMateSettings["disablewhilehidden"] then
					DPSMate:Disable()
				end
			else
				if not val["hidden"] then
					frame:Show()
				end
				DPSMate:Enable()
			end
		end
	end
end

function DPSMate.Options:IsInParty()
	LastPartyNum = PartyNum
	if UnitInRaid("player") then
		PartyNum = GetNumRaidMembers()
		return true
	elseif GetNumPartyMembers() > 0 then
		PartyNum = GetNumPartyMembers()
		return true
	else
		PartyNum = 0
		return false
	end
end

function DPSMate.Options:PopUpAccept(bool, bypass, thorough)
	DPSMate_PopUp:Hide()
	if (GetNumPartyMembers()>0 or UnitInRaid("player")) and not bypass and DPSMate.DPSMateSettings["sync"] and bool then
		if IsPartyLeader() or IsRaidOfficer() or IsRaidLeader() then
			DPSMate.Sync:StartVote()
		else
			DPSMate:SendMessage(DPSMate.L["resetnotofficererror"])
			return
		end
	else
		if bool then
			DPSMate.DB:ResetDB(true, thorough)
			DPSMate.DB:InitDB()

			if thorough then
				DPSMate.DB:OnGroupUpdate()
			end
			
			-- Get buffs of people after reset
			local teamtype = "party"
			local num = GetNumPartyMembers()
			if num<=0 then
				teamtype = "raid"
				num = GetNumRaidMembers()
			end
			for p=1, num do
				for i=1, 32 do
					GameTooltip:SetOwner(UIParent)
					GameTooltip:SetUnitBuff(teamtype..p, i)
					local buff = GameTooltipTextLeft1:GetText()
					GameTooltip:Hide()
					if buff then
						DPSMate.DB:BuildBuffs(DPSMate.L["unknown"], UnitName(teamtype..p), buff, false)
					end
				end
			end
			if teamtype == "party" or num <= 0 then
				for i=0,31 do
					GameTooltip:SetOwner(UIParent)
					GameTooltip:SetPlayerBuff(i)
					local buff = GameTooltipTextLeft1:GetText()
					GameTooltip:Hide()
					if buff then
						DPSMate.DB:BuildBuffs(DPSMate.L["unknown"], UnitName("player"), buff, false)
					end
				end
			end
		else
			DPSMate.Cache.DPSMateDamageDone[2] = {}
			DPSMate.Cache.DPSMateDamageTaken[2] = {}
			DPSMate.Cache.DPSMateEDD[2] = {}
			DPSMate.Cache.DPSMateEDT[2] = {}
			DPSMate.Cache.DPSMateTHealing[2] = {}
			DPSMate.Cache.DPSMateEHealing[2] = {}
			DPSMate.Cache.DPSMateOverhealing[2] = {}
			DPSMate.Cache.DPSMateHealingTaken[2] = {}
			DPSMate.Cache.DPSMateEHealingTaken[2] = {}
			DPSMate.Cache.DPSMateOverhealingTaken[2] = {}
			DPSMate.Cache.DPSMateAbsorbs[2] = {}
			DPSMate.Cache.DPSMateDispels[2] = {}
			DPSMate.Cache.DPSMateDeaths[2] = {}
			DPSMate.Cache.DPSMateInterrupts[2] = {}
			DPSMate.Cache.DPSMateAurasGained[2] = {}
			DPSMate.Cache.DPSMateThreat[2] = {}
			DPSMate.Cache.DPSMateFails[2] = {}
			DPSMate.Cache.DPSMateCCBreaker[2] = {}
			DPSMate.Cache.DPSMateCombatTime["current"] = 0.0001
		end
		
		if DPSMate.Modules.DPS then DPSMate.Modules.DPS.DB = DPSMate.Cache.DPSMateDamageDone end
		if DPSMate.Modules.Damage then DPSMate.Modules.Damage.DB = DPSMate.Cache.DPSMateDamageDone end
		if DPSMate.Modules.DamageTaken then DPSMate.Modules.DamageTaken.DB = DPSMate.Cache.DPSMateDamageTaken end
		if DPSMate.Modules.DTPS then DPSMate.Modules.DTPS.DB = DPSMate.Cache.DPSMateDamageTaken end
		if DPSMate.Modules.EDD then DPSMate.Modules.EDD.DB = DPSMate.Cache.DPSMateEDD end
		if DPSMate.Modules.EDT then DPSMate.Modules.EDT.DB = DPSMate.Cache.DPSMateEDT end
		if DPSMate.Modules.FriendlyFire then DPSMate.Modules.FriendlyFire.DB = DPSMate.Cache.DPSMateEDT end
		if DPSMate.Modules.FriendlyFireTaken then DPSMate.Modules.FriendlyFireTaken.DB = DPSMate.Cache.DPSMateEDT end
		if DPSMate.Modules.Healing then DPSMate.Modules.Healing.DB = DPSMate.Cache.DPSMateTHealing end
		if DPSMate.Modules.HPS then DPSMate.Modules.HPS.DB = DPSMate.Cache.DPSMateTHealing end
		if DPSMate.Modules.Overhealing then DPSMate.Modules.Overhealing.DB = DPSMate.Cache.DPSMateOverhealing end
		if DPSMate.Modules.EffectiveHealing then DPSMate.Modules.EffectiveHealing.DB = DPSMate.Cache.DPSMateEHealing end
		if DPSMate.Modules.EffectiveHPS then DPSMate.Modules.EffectiveHPS.DB = DPSMate.Cache.DPSMateEHealing end
		if DPSMate.Modules.HealingTaken then DPSMate.Modules.HealingTaken.DB = DPSMate.Cache.DPSMateHealingTaken end
		if DPSMate.Modules.EffectiveHealingTaken then DPSMate.Modules.EffectiveHealingTaken.DB = DPSMate.Cache.DPSMateEHealingTaken end
		if DPSMate.Modules.Absorbs then DPSMate.Modules.Absorbs.DB = DPSMate.Cache.DPSMateAbsorbs end
		if DPSMate.Modules.AbsorbsTaken then DPSMate.Modules.AbsorbsTaken.DB = DPSMate.Cache.DPSMateAbsorbs end
		if DPSMate.Modules.HealingAndAbsorbs then DPSMate.Modules.HealingAndAbsorbs.DB = DPSMate.Cache.DPSMateAbsorbs end
		if DPSMate.Modules.Deaths then DPSMate.Modules.Deaths.DB = DPSMate.Cache.DPSMateDeaths end
		if DPSMate.Modules.Dispels then DPSMate.Modules.Dispels.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.DispelsReceived then DPSMate.Modules.DispelsReceived.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.Decurses then DPSMate.Modules.Decurses.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.DecursesReceived then DPSMate.Modules.DecursesReceived.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.CureDisease then DPSMate.Modules.CureDisease.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.CureDiseaseReceived then DPSMate.Modules.CureDiseaseReceived.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.CurePoison then DPSMate.Modules.CurePoison.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.CurePoisonReceived then DPSMate.Modules.CurePoisonReceived.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.LiftMagic then DPSMate.Modules.LiftMagic.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.LiftMagicReceived then DPSMate.Modules.LiftMagicReceived.DB = DPSMate.Cache.DPSMateDispels end
		if DPSMate.Modules.Interrupts then DPSMate.Modules.Interrupts.DB = DPSMate.Cache.DPSMateInterrupts end
		if DPSMate.Modules.AurasGained then DPSMate.Modules.AurasGained.DB = DPSMate.Cache.DPSMateAurasGained end
		if DPSMate.Modules.AurasLost then DPSMate.Modules.AurasLost.DB = DPSMate.Cache.DPSMateAurasGained end
		if DPSMate.Modules.AurasLost then DPSMate.Modules.AurasLost.DB = DPSMate.Cache.DPSMateAurasGained end
		if DPSMate.Modules.AurasUptimers then DPSMate.Modules.AurasUptimers.DB = DPSMate.Cache.DPSMateAurasGained end
		if DPSMate.Modules.Procs then DPSMate.Modules.Procs.DB = DPSMate.Cache.DPSMateAurasGained end
		if DPSMate.Modules.Casts then DPSMate.Modules.Casts.DB = DPSMate.Cache.DPSMateEDT end
		if DPSMate.Modules.Threat then DPSMate.Modules.Threat.DB = DPSMate.Cache.DPSMateThreat end
		if DPSMate.Modules.TPS then DPSMate.Modules.TPS.DB = DPSMate.Cache.DPSMateThreat end
		if DPSMate.Modules.Fails then DPSMate.Modules.Fails.DB = DPSMate.Cache.DPSMateFails end
		if DPSMate.Modules.CCBreaker then DPSMate.Modules.CCBreaker.DB = DPSMate.Cache.DPSMateCCBreaker end
		if DPSMate.Modules.OHPS then DPSMate.Modules.OHPS.DB = DPSMate.Cache.DPSMateOverhealing end
		if DPSMate.Modules.OHealingTaken then DPSMate.Modules.OHealingTaken.DB = DPSMate.Cache.DPSMateOverhealingTaken end
		if DPSMate.Modules.Activity then DPSMate.Modules.Activity.DB = DPSMate.Cache.DPSMateCombatTime end
		
		for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
			if not val["options"][2]["total"] and not val["options"][2]["currentfight"] then
				val["options"][2]["total"] = true
			end
		end
		DPSMate.DB:DamageDone(UnitName("player"), "Init", 0, 0, 0, 0, 0, 0, 0, 0, 0) -- Hackfix to fix the hunter issue where the player is not shown if pet damage is merged
		DPSMate.Options:InitializeSegments()
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:OpenMenu(b, obj)
	for _, val in pairs(DPSMate.DPSMateSettings.windows) do
		if DPSMate.Options.Dewdrop:IsOpen(_G("DPSMate_"..val["name"])) then
			DPSMate.Options.Dewdrop:Close()
			return
		end
		if DPSMate.Options.Dewdrop:IsRegistered(_G("DPSMate_"..val["name"])) then DPSMate.Options.Dewdrop:Unregister(_G("DPSMate_"..val["name"])) end
	end
	DPSMate.Options.Dewdrop:Register(obj,
		'children', function() 
			DPSMate.Options.Dewdrop:FeedAceOptionsTable(DPSMate.Options.Options[b]) 
		end,
		'cursorX', true,
		'cursorY', true,
		'dontHook', true
	)
	DPSMate.Options.Dewdrop:Open(obj)
end

function DPSMate.Options:ToggleDrewDrop(i, obj, pa, no_sbv)
	if not DPSMate.DPSMateSettings["windows"][1] then return end
	for cat, _ in pairs(DPSMate.DPSMateSettings["windows"][pa.Key]["options"][i]) do
		DPSMate.DPSMateSettings["windows"][pa.Key]["options"][i][cat] = false
	end
	DPSMate.DPSMateSettings["windows"][pa.Key]["options"][i][obj] = true
	if i == 1 then
		if not DPSMate.Options.Options[1]["args"][obj] then
			obj = "damage"
		end
		_G(pa:GetName().."_Head_Font"):SetText(DPSMate.Options.Options[i]["args"][obj].name)
		DPSMate.DPSMateSettings["windows"][pa.Key]["CurMode"] = obj
	end
	DPSMate.Options.Dewdrop:Close()
	if DPSMate.DB.loaded and not no_sbv then DPSMate:SetStatusBarValue() end
	return true
end

function DPSMate.Options:UpdateDetails(obj, bool, objname)
	if objname then
		obj = _G(objname)
	end
	local key = obj:GetParent():GetParent():GetParent().Key
	if obj.user then
		DPSMate.RegistredModules[DPSMate.DPSMateSettings["windows"][key]["CurMode"]]:OpenDetails(obj, key, bool)
	else
		DPSMate:SendMessage(DPSMate.L["findusererror"])
	end
end

function DPSMate.Options:UpdateTotalDetails(obj)
	local key = obj:GetParent():GetParent():GetParent().Key
	DPSMate.RegistredModules[DPSMate.DPSMateSettings["windows"][key]["CurMode"]]:OpenTotalDetails(obj, key)
end

function DPSMate.Options:DropDownStyleReset()
	for i=1, 20 do
		local button = _G("DropDownList1Button"..i)
		_G("DropDownList1Button"..i.."NormalText"):SetFont(STANDARD_TEXT_FONT, UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT)
		button:SetScript("OnEnter", function()
			 if ( this.hasArrow ) then
			  ToggleDropDownMenu(this:GetParent():GetID() + 1, this.value);
			else
			  CloseDropDownMenus(this:GetParent():GetID() + 1);
			end
			getglobal(this:GetName().."Highlight"):Show();
			UIDropDownMenu_StopCounting(this:GetParent());
			if ( this.tooltipTitle ) then
			  GameTooltip_AddNewbieTip(this.tooltipTitle, 1.0, 1.0, 1.0, this.tooltipText, 1);
			end
		end)
		_G("DropDownList1Backdrop"):SetBackdrop({ 
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
			insets = { left = 11, right = 12, top = 12, bottom = 11 }
		})
		if button.tex then
			button.tex:Hide()
		end
	end
end

function DPSMate.Options:UpdateConfigModes(obj, o, p) 
	local line, lineplusoffset
	local TL = DPSMate:TableLength(DPSMate.ModuleNames)
	local path, t = obj:GetName().."_Button", {}
	if p then
		for cat, val in DPSMate.ModuleNames do
			if val ~= "damage" then
				if DPSMate:TContains(DPSMate.DPSMateSettings["enabledmodes"], val) then
					tinsert(t, 1, cat)
					if not DPSMate.EnabledModules[val] then
						DPSMate:EnableModule(val)
					end
				end
			end
		end
	else
		for cat, val in DPSMate.ModuleNames do
			if val ~= "damage" then
				if not DPSMate:TContains(DPSMate.DPSMateSettings["enabledmodes"], val) then
					tinsert(t, 1, cat)
					if DPSMate.EnabledModules[val] then
						DPSMate:DisableModule(val)
						for k,v in DPSMate.DPSMateSettings["windows"] do
							if DPSMate.DPSMateSettings["windows"][k]["CurMode"] == val then
								local frame = _G("DPSMate_"..v["name"])
								DPSMate.Options:ToggleDrewDrop(1, "damage", frame, true)
							end
						end
					end
				end
			end
		end
		if DPSMate.DB.loaded then DPSMate:SetStatusBarValue() end
	end
	local TL = DPSMate:TableLength(t)
	obj.offset = (obj.offset or 0) - o 
	if obj.offset > (TL-15) then obj.offset = (TL-15) end
	if obj.offset < 0 then obj.offset = 0 end
	for line=1, 15 do
		lineplusoffset = line + obj.offset
		if t[lineplusoffset] then
			_G(path..line.."Text"):SetText(t[lineplusoffset])
			_G(path..line):Show()
		else
			_G(path..line):Hide()
		end
		_G(path..line.."Texture"):Hide()
		_G(path..line.."Text"):SetTextColor(1,1,1,1)
		_G(path..line).selected = false
	end
end

DPSMate.Options.ShowMenu = UnitPopup_ShowMenu
function UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
	DPSMate.Options:DropDownStyleReset()
	DPSMate.Options.ShowMenu(dropdownMenu, which, unit, name, userData)
end

DPSMate.Options.UIDDI = UIDropDownMenu_Initialize
function UIDropDownMenu_Initialize(frame, initFunction, displayMode, level)
	DPSMate.Options:DropDownStyleReset()
	DPSMate.Options.UIDDI(frame, initFunction, displayMode, level)
end

function DPSMate.Options:ChannelDropDown()
	local channel, i = DPSMate.L["reportchannel"], 1
	
    local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, this.value)
    end
	
	-- Adding dynamic channel
	for i=0,25 do
		local id, name = GetChannelName(i);
		if name then
			if not DPSMate:TContains(channel, name) then
				tinsert(channel, name)
			end
		end
	end
	
	-- Initializing channel
	for cat, val in pairs(channel) do
		UIDropDownMenu_AddButton{
			text = val,
			value = val,
			func = on_click,
		}
	end
	
	UIDropDownMenu_SetSelectedValue(DPSMate_Report_Channel, SelectedChannel)
end

function DPSMate.Options:WindowDropDown()
	DPSMate_ConfigMenu.Selected = "None"
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(_G(UIDROPDOWNMENU_OPEN_MENU), this.value)
		if UIDROPDOWNMENU_OPEN_MENU == "DPSMate_ConfigMenu_Tab_Window_Remove" then
			DPSMate_ConfigMenu.Selected = this.value
		end
    end
	
	UIDropDownMenu_AddButton{
		text = "None",
		value = "None",
		func = on_click,
	}

	for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
		UIDropDownMenu_AddButton{
			text = val["name"],
			value = val["name"],
			func = on_click,
		}
	end
	
	if not DPSMate_ConfigMenu.vis then
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_Remove, "None")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_ConfigFrom, "None")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_ConfigTo, "None")
	end
	DPSMate_ConfigMenu.vis = true
end

function DPSMate.Options:BarFontDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarFont, this.value)
		DPSMate_ConfigMenu_Tab_Bars_BarFontText:SetFont(DPSMate.Options.fonts[this.value], 12)
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"] = this.value
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		for i=1, DPSMate.MaxRows do
			_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetFont(DPSMate.Options.fonts[this.value], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
			_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetFont(DPSMate.Options.fonts[this.value], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		end
    end
	
	for name, path in pairs(DPSMate.Options.fonts) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(path, 16)
		i=i+1
	end
end

function DPSMate.Options:BarFontFlagsDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarFontFlag, this.value)
		DPSMate_ConfigMenu_Tab_Bars_BarFontFlagText:SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"] = this.value
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Name"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_Value"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		for i=1, DPSMate.MaxRows do
			_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Name"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
			_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_Value"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfont"]], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["barfontflag"]])
		end
    end
	
	for name, flag in pairs(DPSMate.Options.fontflags) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, flag)
		i=i+1
	end
end

function DPSMate.Options:BarTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Bars_BarTexture, this.value)
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["bartexture"] = this.value
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:SetTexture(DPSMate.Options.statusbars[this.value])
		DPSMate_ConfigMenu_Tab_Bars_BarTexture.tex:Show()
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total"):SetStatusBarTexture(DPSMate.Options.statusbars[this.value])
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_Total_BG"):SetTexture(DPSMate.Options.statusbars[this.value])
		for i=1, DPSMate.MaxRows do
			_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i):SetStatusBarTexture(DPSMate.Options.statusbars[this.value])
			_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Child_StatusBar"..i.."_BG"):SetTexture(DPSMate.Options.statusbars[this.value])
		end
	end
	
	for name, path in pairs(DPSMate.Options.statusbars) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = _G("DropDownList1Button"..i)
		if not button.tex then
			button.tex = button:CreateTexture("BG", "BACKGROUND")
			button.tex:SetTexture(path)
			button.tex:SetWidth(100)
			button.tex:SetHeight(20)
			button.tex:SetPoint("TOPLEFT", button, "TOPLEFT")
		end
		button.tex:Show()
		i=i+1
	end
end

function DPSMate.Options:TitleBarTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarTexture, this.value)
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebartexture"] = this.value
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:SetTexture(DPSMate.Options.statusbars[this.value])
		DPSMate_ConfigMenu_Tab_TitleBar_BarTexture.tex:Show()
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Background"):SetTexture(DPSMate.Options.statusbars[this.value])
    end
	
	for name, path in pairs(DPSMate.Options.statusbars) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = _G("DropDownList1Button"..i)
		if not button.tex then
			button.tex = button:CreateTexture("BG", "BACKGROUND")
			button.tex:SetTexture(path)
			button.tex:SetWidth(100)
			button.tex:SetHeight(20)
			button.tex:SetPoint("TOPLEFT", button, "TOPLEFT")
		end
		button.tex:Show()
		i=i+1
	end
end

function DPSMate.Options:TitleBarFontDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarFont, this.value)
		DPSMate_ConfigMenu_Tab_TitleBar_BarFontText:SetFont(DPSMate.Options.fonts[this.value], 12)
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfont"] = this.value
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Font"):SetFont(DPSMate.Options.fonts[this.value], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontsize"], DPSMate.Options.fontflags[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontflag"]])
    end
	
	for name, path in pairs(DPSMate.Options.fonts) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(path, 16)
		i=i+1
	end
end

function DPSMate.Options:TitleBarFontFlagsDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_TitleBar_BarFontFlag, this.value)
		DPSMate_ConfigMenu_Tab_TitleBar_BarFontFlagText:SetFont(DPSMate.Options.fonts["FRIZQT"], 12, DPSMate.Options.fontflags[this.value])
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfontflag"] = this.value
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Head_Font"):SetFont(DPSMate.Options.fonts[DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["titlebarfont"]], 12, DPSMate.Options.fontflags[this.value])
    end
	
	for name, flag in pairs(DPSMate.Options.fontflags) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		_G("DropDownList1Button"..i.."NormalText"):SetFont(DPSMate.Options.fonts["FRIZQT"], 12, flag)
		i=i+1
	end
end

function DPSMate.Options:ContentBGTextureDropDown()
	local i = 1
	
	local function on_click()
        UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_BGDropDown, this.value)
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgtexture"] = this.value
		_G("DPSMate_ConfigMenu_Tab_Content_BGDropDown_Texture"):SetBackdrop({ 
			bgFile = DPSMate.Options.bgtexture[this.value], 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 12, 
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		_G("DPSMate_ConfigMenu_Tab_Content_BGDropDown_Texture"):SetBackdropColor(DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][1], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][2], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][3])
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_ScrollFrame_Background"):SetTexture(DPSMate.Options.bgtexture[this.value])
    end
	
	for name, path in pairs(DPSMate.Options.bgtexture) do
		UIDropDownMenu_AddButton{
			text = name,
			value = name,
			func = on_click,
		}
		local button = _G("DropDownList1Button"..i)
		button.path = path
		button.i = i
		button:SetScript("OnEnter", function()
			_G(this:GetName().."Highlight"):Show()
			_G("DropDownList1Backdrop"):SetBackdrop({ 
				bgFile = this.path, 
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
				insets = { left = 11, right = 12, top = 12, bottom = 11 }
			})
			_G("DropDownList1Backdrop"):SetBackdropColor(DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][1], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][2], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbgcolor"][3])
		end)
		i=i+1
	end
end

function DPSMate.Options:SelectDataResets(obj, case)
	local vars = {["DPSMate_ConfigMenu_Tab_DataResets_EnteringWorld"] = "dataresetsworld", ["DPSMate_ConfigMenu_Tab_DataResets_PartyMemberChanged"] = "dataresetspartyamount", ["DPSMate_ConfigMenu_Tab_DataResets_JoinParty"] = "dataresetsjoinparty", ["DPSMate_ConfigMenu_Tab_DataResets_LeaveParty"] = "dataresetsleaveparty", ["DPSMate_ConfigMenu_Tab_DataResets_Sync"] = "dataresetssync", ["DPSMate_ConfigMenu_Tab_DataResets_Logout"] = "dataresetslogout"}
	DPSMate.DPSMateSettings[vars[obj:GetName()]] = case
	UIDropDownMenu_SetSelectedValue(obj, case)
end

function DPSMate.Options:DataResetsDropDown()
	local btns = {DPSMate.L["yes"], DPSMate.L["no"], DPSMate.L["ask"]}
	
	local function on_click()
		DPSMate.Options:SelectDataResets(_G(UIDROPDOWNMENU_OPEN_MENU), this.value)
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
	
	if not DPSMate_ConfigMenu.visBars8 then
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_EnteringWorld, DPSMate.DPSMateSettings["dataresetsworld"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_JoinParty, DPSMate.DPSMateSettings["dataresetsjoinparty"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_PartyMemberChanged, DPSMate.DPSMateSettings["dataresetspartyamount"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_LeaveParty, DPSMate.DPSMateSettings["dataresetsleaveparty"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_Sync, DPSMate.DPSMateSettings["dataresetssync"])
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_DataResets_Logout, DPSMate.DPSMateSettings["dataresetslogout"])
	end
	DPSMate_ConfigMenu.visBars8 = true
end

function DPSMate.Options:NumberFormatDropDown()
	local btns = {DPSMate.L["normal"], DPSMate.L["condensed"], DPSMate.L["commas"], DPSMate.L["semicondensed"]}
	
	local function on_click()
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["numberformat"] = this.value
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_NumberFormat, DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["numberformat"])
		DPSMate:SetStatusBarValue()
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
end

function DPSMate.Options:BorderStrataDropDown()
	local btns = {"Background", "Low", "High"}
	
	local function on_click()
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["borderstrata"] = this.value
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_BorderStrata, DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["borderstrata"])
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Border"):SetFrameStrata(DPSMate.Options.stratas[this.value])
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
end

function DPSMate.Options:BorderTextureDropDown()
	local function on_click()
		DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["bordertexture"] = this.value
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Content_BorderTexture, DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["bordertexture"])
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Border"):SetBackdrop({ 
																												  bgFile = "", 
																												  edgeFile = DPSMate.Options.bordertextures[this.value], tile = true, tileSize = 12, edgeSize = 10, 
																												  insets = { left = 5, right = 5, top = 3, bottom = 1 }
																												})
		_G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["name"].."_Border"):SetBackdropBorderColor(DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbordercolor"][1], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbordercolor"][2], DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key]["contentbordercolor"][3])
	end
	
	for val, _ in pairs(DPSMate.Options.bordertextures) do
		UIDropDownMenu_AddButton{
			text = val,
			value = val,
			func = on_click,
		}
	end
end

function DPSMate.Options:TooltipPositionDropDown()
	local btns = {DPSMate.L["default"], DPSMate.L["topright"], DPSMate.L["topleft"], DPSMate.L["left"], DPSMate.L["top"]}
	
	local function on_click()
		DPSMate.DPSMateSettings["tooltipanchor"] = this.value
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Tooltips_Position, DPSMate.DPSMateSettings["tooltipanchor"])
	end
	
	for val, name in pairs(btns) do
		UIDropDownMenu_AddButton{
			text = name,
			value = val,
			func = on_click,
		}
	end
	
	if not DPSMate_ConfigMenu.visBars10 then
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Tooltips_Position, DPSMate.DPSMateSettings["tooltipanchor"])
	end
	DPSMate_ConfigMenu.visBars10 = true
end

function DPSMate.Options:Report()
	local channel = UIDropDownMenu_GetSelectedValue(DPSMate_Report_Channel)
	SelectedChannel = channel
	local arr, cbt, ecbt = DPSMate:GetMode(DPSMate_Report.PaKey)
	local chn, index, name, value, perc = nil, nil, nil, nil, nil
	name, value, perc, b = DPSMate:GetSettingValues(arr, cbt, DPSMate_Report.PaKey, ecbt)
	if (channel == DPSMate.L["whisper"]) then
		chn = "WHISPER"; index = DPSMate_Report_Editbox:GetText();
	elseif DPSMate:TContains(DPSMate.L["gchannel"], channel) then
		chn = strupper(channel)
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end

	ChatThrottleLib:SendChatMessage("BULK", "DPSMateChat", DPSMate.L["name"].." - "..DPSMate.L["reportfor"]..DPSMate:GetModeName(DPSMate_Report.PaKey or 1).." - ".._G("DPSMate_"..DPSMate.DPSMateSettings["windows"][DPSMate_Report.PaKey or 1]["name"].."_Head_Font"):GetText().." - "..b[1]..b[2], chn, nil, index)
	for i=1, DPSMate_Report_Lines:GetValue() do
		if (not value[i] or value[i] == 0) then break end
		if DPSMate.DPSMateSettings["reportdelay"] then
			tinsert(DPSMate.DelayMsg, {i..". "..name[i].." -"..value[i], chn, index})
		else
			ChatThrottleLib:SendChatMessage("BULK", "DPSMateChat", i..". "..name[i].." -"..value[i], chn, nil, index)
		end
	end
	DPSMate_Report:Hide()
end

local SendChatMessage = SendChatMessage
local type = type

local AbilityModes = {"damage", "dps", "healing", "hps", "OHPS", "overhealing", "effectivehealing", "effectivehps", "deaths", "interrupts", "dispels", "decurses", "curedisease", "curepoison", "liftmagic", "aurasgained", "auraslost", "aurasuptime", "procs", "casts", "ccbreaker", "healingandabsorbs"}
function DPSMate.Options:ReportUserDetails(obj, channel, name)
	local Key, user = obj:GetParent():GetParent():GetParent().Key, obj.user
	local _, cbt, ecbt = DPSMate:GetMode(Key)
	local a,b,c
	if DPSMate.DPSMateSettings["windows"][Key]["CurMode"] == "deaths" then
		a,b,c = DPSMate.RegistredModules[DPSMate.DPSMateSettings["windows"][Key]["CurMode"]]:EvalTable(DPSMate.Cache.DPSMateUser[user], Key)
	else
		a,b,c = DPSMate.RegistredModules[DPSMate.DPSMateSettings["windows"][Key]["CurMode"]]:EvalTable(DPSMate.Cache.DPSMateUser[user], Key, cbt, ecbt)
	end
	local chn, index
	if (channel == DPSMate.L["whisper"]) then
		chn = "WHISPER"; index = name;
	elseif DPSMate:TContains(DPSMate.L["gchannel"], channel) then
		chn = strupper(channel)
	else
		chn = "CHANNEL"; index = GetChannelName(channel)
	end
	local bb = ""
	if not b and not a then
		return
	end
	if b~=0 then
		bb = " - "..strformat("%.2f", b)
	end
	SendChatMessage(DPSMate.L["name"].." - "..DPSMate.L["reportof"].." "..user.."'s ".._G("DPSMate_"..DPSMate.DPSMateSettings["windows"][Key]["name"].."_Head_Font"):GetText().." - "..DPSMate:GetModeName(Key)..bb, chn, nil, index)
	for i=1, 10 do
		if (not a[i]) then break end
		local p
		if type(c[i])=="table" then p = strformat("%.2f", c[i][1]).." ("..strformat("%.2f", 100*c[i][1]/b).."%)" else p = strformat("%.2f", c[i]).." ("..strformat("%.2f", 100*c[i]/b).."%)" end
		if DPSMate.DPSMateSettings["windows"][Key]["CurMode"] == "aurasuptime" then p = strformat("%.2f%%", c[i]) end
		if DPSMate.DPSMateSettings["windows"][Key]["CurMode"] == "deaths" then
			local ctype = " (HIT)"
			if c[i][3]==1 then ctype=" (CRIT)" elseif c[i][3]==2 then ctype=" (CRUSH)" end
			if c[i][2]==1 then
				if DPSMate.DPSMateSettings["reportdelay"] then
					tinsert(DPSMate.DelayMsg, {i..". |cFF8cff80"..DPSMate:GetAbilityById(a[i]).." => ".."+"..c[i][1]..ctype.."|r", chn, index})
				else
					SendChatMessage(i..". |cFF8cff80"..DPSMate:GetAbilityById(a[i]).." => ".."+"..c[i][1]..ctype.."|r", chn, nil, index)
				end
			else
				if DPSMate.DPSMateSettings["reportdelay"] then
					tinsert(DPSMate.DelayMsg, {i..". |cFFFF8080"..DPSMate:GetAbilityById(a[i]).." => ".."-"..c[i][1]..ctype.."|r", chn, index})
				else
					SendChatMessage(i..". |cFFFF8080"..DPSMate:GetAbilityById(a[i]).." => ".."-"..c[i][1]..ctype.."|r", chn, nil, index)
				end
			end
		else
			if DPSMate.DPSMateSettings["windows"][Key]["CurMode"] == "fails" then
				if DPSMate.DPSMateSettings["reportdelay"] then
					tinsert(DPSMate.DelayMsg, {i..". "..DPSMate.Modules.Fails:Type(a[i]).." - "..p, chn, index})
				else
					SendChatMessage(i..". "..DPSMate.Modules.Fails:Type(a[i]).." - "..p, chn, nil, index)
				end
			else
				if DPSMate:TContains(AbilityModes, DPSMate.DPSMateSettings["windows"][Key]["CurMode"]) then
					if DPSMate.DPSMateSettings["reportdelay"] then
						tinsert(DPSMate.DelayMsg, {i..". "..DPSMate:GetAbilityById(a[i]).." - "..p, chn, index})
					else
						SendChatMessage(i..". "..DPSMate:GetAbilityById(a[i]).." - "..p, chn, nil, index)
					end
				else
					if DPSMate.DPSMateSettings["reportdelay"] then
						tinsert(DPSMate.DelayMsg, {i..". "..DPSMate:GetUserById(a[i]).." - "..p, chn, index})
					else
						SendChatMessage(i..". "..DPSMate:GetUserById(a[i]).." - "..p, chn, nil, index)
					end
				end
			end
		end
	end
end

local hexClassColor = {
	warrior = "C79C6E",
	rogue = "FFF569",
	priest = "FFFFFF",
	druid = "FF7D0A",
	warlock = "9482C9",
	mage = "69CCF0",
	hunter = "ABD473",
	paladin = "F58CBA",
	shaman = "0070DE",
}

local CompareExcept = {
	[DPSMate.L["enemydamagedone"]] = true,
	[DPSMate.L["enemydamagetaken"]] = true
}
function DPSMate.Options:InializePlayerDewDrop(obj)
	local channel, i = DPSMate.L["gchannel"], 1
	local path = DPSMate.Options.Options[4]["args"]["report"]["args"]
	-- Name
	DPSMate.Options.Options[4]["args"]["player"] = {
		order = 1,
		type = "header",
		name = obj.user,
	}
	DPSMate.Options.Options[4]["args"]["details"] = {
		order = 2,
		type = "execute",
		name = DPSMate.L["opendetails"],
		desc = DPSMate.L["opendetails"],
		func = function() DPSMate.Options:UpdateDetails(obj); DPSMate.Options.Dewdrop:Close() end,
	}
	
	-- Report channel
	for i=0, 25 do
		local id, name = GetChannelName(i);
		if name then
			if not DPSMate:TContains(channel, name) then
				tinsert(channel, name)
			end
		end
	end
	
	for cat, val in channel do
		path["a"..cat] = {
			order = 10*cat+10,
			type = "execute",
			name = val,
			desc = DPSMate.L["reportdetails"],
			func = loadstring('DPSMate.Options:ReportUserDetails(DPSMate.Options.Dewdrop:GetOpenedParent(), "'..val..'"); DPSMate.Options.Dewdrop:Close()'),
		}
	end
	
	-- Compare with player
	DPSMate.Options.Options[4]["args"]["compare"]["args"] = {}
	path = DPSMate.Options.Options[4]["args"]["compare"]["args"]
	local Key = obj:GetParent():GetParent():GetParent().Key
	local db,cbt, ecbt = DPSMate:GetMode(Key)
	local temp = ''
	local a = DPSMate:GetSettingValues(db, cbt, Key, ecbt)
	for cat, name in a do
		if name and name ~= obj.user then
			if DPSMate.DPSMateSettings["windows"][Key]["grouponly"] then
				if DPSMate.Parser.TargetParty[name] then
					if temp=='' then
						temp = '"'..name..'"'
					else
						temp = temp..',"'..name..'"'
					end
				end
			else
				if temp=='' then
					temp = '"'..name..'"'
				else
					temp = temp..',"'..name..'"'
				end
			end
		end
	end
	-- No clue what is wrong here. Fuck it
	temp = assert(loadstring('return {'..temp..'}')) ();
	sort(temp)
	
	local mode = _G(obj:GetParent():GetParent():GetParent():GetName().."_Head_Font"):GetText()
	for mo, ti in strgfind(mode, "(.+) %[(.+)%]") do
		mode = mo
	end
	
	for cat, val in temp do
		if cat>100 then break end
		if not strfind(val, "%s") or CompareExcept[mode] then
			path["Arg"..cat] = {
				order = 1,
				type = "execute",
				name = "|cFF"..hexClassColor[DPSMate.Cache.DPSMateUser[val][2] or "warrior"]..val.."|r",
				desc = DPSMate.L["opendetails"],
				func = loadstring('DPSMate.Options:UpdateDetails(nil, "'..val..'", "'..obj:GetName()..'"); DPSMate.Options.Dewdrop:Close()'),
			}
		end
	end
end

function DPSMate.Options:FormatTime(time)
	if time>60 then
		local rest = ceil(mod(time, 60))
		if rest<10 then
			rest = "0"..rest
		end
		return floor(time/60)..":"..rest.."m"
	else
		return strformat("%.2f", time).."s"
	end
end

function DPSMate.Options:NewSegment(segname)
	local max = 0
	local a = ""
	-- Get name of this session
	for c, v in pairs(DPSMate.Cache.DPSMateEDT[2]) do
		local CV = 0
		for cat, val in pairs(v) do
			if cat~="i" then
				CV = CV+val["i"]
			end
		end
		if max<CV then
			max = CV
			a = c
		end
	end
	local extra = ""
	if a or segname~=nil then
		local name = segname
		if not segname then
			name = DPSMate:GetUserById(a) or DPSMate.L["unknown"]
			extra = " - CBT: "..self:FormatTime(DPSMate.Cache.DPSMateCombatTime["current"])
		end
		if name ~= DPSMate.L["unknown"] or (name == DPSMate.L["unknown"] and max > 100) then
			if DPSMate.DPSMateSettings["onlybossfights"] then
				if DPSMate.BabbleBoss:Contains(name) then
					DPSMate.Options:CreateSegment(name..extra)
				end
			else
				DPSMate.Options:CreateSegment(name..extra)
			end
		end
		
		DPSMate.Cache.DPSMateDamageDone[2] = {}
		DPSMate.Cache.DPSMateDamageTaken[2] = {}
		DPSMate.Cache.DPSMateEDD[2] = {}
		DPSMate.Cache.DPSMateEDT[2] = {}
		DPSMate.Cache.DPSMateTHealing[2] = {}
		DPSMate.Cache.DPSMateEHealing[2] = {}
		DPSMateOverhealing[2] = {}
		DPSMate.Cache.DPSMateEHealingTaken[2] = {}
		DPSMate.Cache.DPSMateHealingTaken[2] = {}
		DPSMate.Cache.DPSMateOverhealingTaken[2] = {}
		DPSMate.Cache.DPSMateAbsorbs[2] = {}
		DPSMate.Cache.DPSMateDeaths[2] = {}
		DPSMate.Cache.DPSMateInterrupts[2] = {}
		DPSMate.Cache.DPSMateDispels[2] = {}
		DPSMate.Cache.DPSMateAurasGained[2] = {}
		DPSMate.Cache.DPSMateThreat[2] = {}
		DPSMate.Cache.DPSMateFails[2] = {}
		DPSMate.Cache.DPSMateCCBreaker[2] = {}
		DPSMate.Cache.DPSMateCombatTime["current"] = 0.0001
		DPSMate.Cache.DPSMateCombatTime["effective"][2] = {}
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:CreateSegment(name)
	-- Need to add a new check
	local modes = {["DMGDone"] = DPSMate.Cache.DPSMateDamageDone[2], ["DMGTaken"] = DPSMate.Cache.DPSMateDamageTaken[2], ["EDDone"] = DPSMate.Cache.DPSMateEDD[2], ["EDTaken"] = DPSMate.Cache.DPSMateEDT[2], ["THealing"] = DPSMate.Cache.DPSMateTHealing[2], ["EHealing"] = DPSMate.Cache.DPSMateEHealing[2], ["OHealing"] = DPSMateOverhealing[2], ["EHealingTaken"] = DPSMate.Cache.DPSMateEHealingTaken[2], ["THealingTaken"] = DPSMate.Cache.DPSMateHealingTaken[2], ["Absorbs"] = DPSMate.Cache.DPSMateAbsorbs[2], ["Deaths"] = DPSMate.Cache.DPSMateDeaths[2], ["Interrupts"] = DPSMate.Cache.DPSMateInterrupts[2], ["Dispels"] = DPSMate.Cache.DPSMateDispels[2], ["Auras"] = DPSMate.Cache.DPSMateAurasGained[2]}
	
	tinsert(DPSMate.DPSMateHistory["names"], 1, name.." - "..GameTime_GetTime())
	for cat, val in pairs(modes) do
		tinsert(DPSMate.DPSMateHistory[cat], 1, DPSMate:CopyTable(val))
		if DPSMate:TableLength(DPSMate.DPSMateHistory[cat])>DPSMate.DPSMateSettings["datasegments"] then
			for i=DPSMate.DPSMateSettings["datasegments"]+1, DPSMate:TableLength(DPSMate.DPSMateHistory[cat]) do
				tremove(DPSMate.DPSMateHistory[cat], i)
			end
			tremove(DPSMate.DPSMateHistory[cat], DPSMate.DPSMateSettings["datasegments"]+1)
		end
		if DPSMate:TableLength(DPSMate.Cache.DPSMateCombatTime["segments"])>DPSMate.DPSMateSettings["datasegments"] then
			for i=DPSMate.DPSMateSettings["datasegments"]+1, DPSMate:TableLength(DPSMate.Cache.DPSMateCombatTime["segments"]) do
				tremove(DPSMate.Cache.DPSMateCombatTime["segments"], i)
			end
		end
	end
	tinsert(DPSMate.Cache.DPSMateCombatTime["segments"], 1, {[1]=DPSMate.Cache.DPSMateCombatTime["current"], [2]=DPSMate.Cache.DPSMateCombatTime["effective"][2]})
	DPSMate.Options:InitializeSegments()
end

function DPSMate.Options:InitializeSegments()
	local i=1
	DPSMate.Options.Options[2]["args"] = {
		total = {
			order = 10,
			type = 'toggle',
			name = DPSMate.L["total"],
			desc = DPSMate.L["totalmode"],
			get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["total"] end,
			set = function() DPSMate.Options:ToggleDrewDrop(2, "total", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
		},
		currentFight = {
			order = 20,
			type = 'toggle',
			name = DPSMate.L["mcurrent"],
			desc = DPSMate.L["currentmode"],
			get = function() return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["currentfight"] end,
			set = function() DPSMate.Options:ToggleDrewDrop(2, "currentfight", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
		},
	}
	DPSMate.Options.Options[3]["args"]["deletesegment"]["args"] = {}
	for cat, val in pairs(DPSMate.DPSMateHistory["DMGDone"]) do
		if not val then break end
		DPSMate.Options.Options[2]["args"]["segment"..i] = {
			order = 20+i*10,
			type = 'toggle',
			name = i..". "..DPSMate.DPSMateHistory["names"][i],
			desc = DPSMate.L["fdetailsfor"]..DPSMate.DPSMateHistory["names"][i],
			get = loadstring('return DPSMate.DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][2]["segment'..i..'"];'),
			set = loadstring('DPSMate.Options:ToggleDrewDrop(2, "segment'..i..'", DPSMate.Options.Dewdrop:GetOpenedParent());'),
		}
		DPSMate.Options.Options[3]["args"]["deletesegment"]["args"]["segment"..i] = {
			order = i*10,
			type = 'execute',
			name = i..". "..DPSMate.DPSMateHistory["names"][i],
			desc = DPSMate.L["removesegmentof"]..DPSMate.DPSMateHistory["names"][i],
			func = loadstring('DPSMate.Options:RemoveSegment('..i..');'),
		}
		i=i+1
	end
end

function DPSMate.Options:OnVerticalScroll(obj, arg1, pre, spec)
	pre = pre or 20
	local maxScroll = _G(obj:GetName().."_Child"):GetHeight()-100
	if spec then maxScroll = maxScroll + 100 end
	local Scroll = obj:GetVerticalScroll()
	local toScroll = (Scroll - (pre*arg1))
	if toScroll < 0 or maxScroll < 0 then
		obj:SetVerticalScroll(0)
	elseif toScroll > maxScroll then
		obj:SetVerticalScroll(maxScroll)
	else
		obj:SetVerticalScroll(toScroll)
	end
end

function DPSMate.Options:CreateWindow()
	local na = string.gsub(DPSMate_ConfigMenu_Tab_Window_Editbox:GetText(), "%s", "")
	if (na and not DPSMate:GetKeyByValInTT(DPSMate.DPSMateSettings["windows"], na, "name") and na~="") then
		tinsert(DPSMate.DPSMateSettings["windows"], {
			name = na,
			options = {
				[1] = {
					damage = true
				},
				[2] = {
					total = true
				}
			},
			CurMode = "damage",
			hidden = false,
			scale = 1,
			barfont = "FRIZQT",
			barfontsize = 13,
			barfontflag = "Outline",
			bartexture = "Minimalist",
			barspacing = 1,
			barheight = 17,
			classicons = true,
			ranks = true,
			titlebar = true,
			titlebarfont = "FRIZQT",
			titlebarfontflag = "None",
			titlebarfontsize = 12,
			titlebarheight = 17,
			titlebarreport = true,
			titlebarreset = true,
			titlebarsegments = true,
			titlebarconfig = true,
			titlebarsync = true,
			titlebarenable = true,
			titlebarfilter = true,
			titlebartexture = "Minimalist",
			titlebarbgcolor = {0.1568627450980392,0.1725490196078431,0.1647058823529412},
			titlebarfontcolor = {1.0,0.82,0.0},
			barfontcolor = {1.0,1.0,1.0},
			contentbgtexture = "UI-Tooltip-Background",
			contentbgcolor = {0.01568627450980392,0,1},
			bgbarcolor = {1,1,1},
			numberformat = 1,
			opacity = 1,
			bgopacity = 0,
			titlebaropacity = 1,
			filterclasses = {
				warrior = true,
				rogue = true,
				priest = true,
				hunter = true,
				mage = true,
				warlock = true,
				paladin = true,
				shaman = true,
				druid = true,
			},
			filterpeople = "",
			grouponly = true,
			realtime = false,
			cbtdisplay = false,
			barbg = false,
			totopacity = 1.0,
			borderopacity = 1.0,
			contentbordercolor = {0,0,0},
			borderstrata = 1,
			bordertexture = "UI-Tooltip-Border",
			position = {"CENTER",0,0},
			savsize = {150,100},
		})
		local TL = DPSMate:TableLength(DPSMate.DPSMateSettings["windows"])
		if not _G("DPSMate_"..na) then
			local fr=CreateFrame("Frame", "DPSMate_"..na, UIParent, "DPSMate_Statusframe")
			fr.Key=TL
		end
		_G("DPSMate_"..na):Show()
		if not _G("DPSMate_ConfigMenu_Menu_Button"..(9+TL)) then
			local f = CreateFrame("Button", "DPSMate_ConfigMenu_Menu_Button"..(9+TL), DPSMate_ConfigMenu_Menu, "DPSMate_Template_WindowButton")
			f.Key = TL
		end
		local frame = _G("DPSMate_ConfigMenu_Menu_Button"..(9+TL))
		frame:Show()
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+TL).."Text"):SetText(na)
		if TL>1 then
			frame:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(8+TL)), "BOTTOM")
			_G("DPSMate_ConfigMenu_Menu_Button"..(8+TL)).after = frame
		else
			frame:SetPoint("TOP", DPSMate_ConfigMenu_Menu_Button1, "BOTTOM")
		end
		frame.after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu.num = 9+TL
		frame.func = function()
			_G(this:GetParent():GetParent():GetName()..this:GetParent().selected):Hide()
			_G(this:GetParent():GetParent():GetName().."_Tab_Window"):Show()
			this:GetParent().selected = "_Tab_Window"
		end
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", frame, "BOTTOM")
		DPSMate:InitializeFrames()
		_G("DPSMate_"..na.."_Head_Font"):SetText(DPSMate.L["damage"])
		_G("DPSMate_"..na.."_ScrollFrame_Child"):SetWidth(150)
		_G("DPSMate_"..na.."_ScrollFrame"):SetHeight(84)
		DPSMate:SetStatusBarValue()
	end
end

function DPSMate.Options:RemoveWindow()
	local frame = _G("DPSMate_"..DPSMate_ConfigMenu.Selected)
	if frame then
		frame:Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key)):Hide()
		tremove(DPSMate.DPSMateSettings["windows"], frame.Key)
		local TL = DPSMate:TableLength(DPSMate.DPSMateSettings["windows"])
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+TL)).after = DPSMate_ConfigMenu_Menu_Button2
		DPSMate_ConfigMenu_Menu_Button2:ClearAllPoints()
		DPSMate_ConfigMenu_Menu_Button2:SetPoint("TOP", _G("DPSMate_ConfigMenu_Menu_Button"..(9+TL)), "BOTTOM")
		UIDropDownMenu_SetSelectedValue(DPSMate_ConfigMenu_Tab_Window_Remove, "None")
		DPSMate_ConfigMenu_Menu_Button1.selected = true
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key)).selected = false
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key).."Texture"):Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key).."Text"):SetTextColor(1,0.82,0,1)
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key).."_Button1"):Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key).."_Button2"):Hide()
		_G("DPSMate_ConfigMenu_Menu_Button"..(9+frame.Key).."_Button3"):Hide()
		DPSMate_ConfigMenu_Menu_Button1Texture:Show()
	end
end

function DPSMate.Options:CopyConfiguration()
	local fromName = _G("DPSMate_ConfigMenu_Tab_Window_ConfigFromText"):GetText()
	local toName = _G("DPSMate_ConfigMenu_Tab_Window_ConfigToText"):GetText()
	if fromName~="None" and toName~="None" then
		local fromKey = _G("DPSMate_"..fromName).Key
		local toKey = _G("DPSMate_"..toName).Key
		for cat, val in pairs(DPSMate.DPSMateSettings["windows"][fromKey]) do
			if cat~="name" and cat~="options" then
				DPSMate.DPSMateSettings["windows"][toKey][cat] = val
			end
		end
		DPSMate:InitializeFrames()
	end
end

function DPSMate.Options:Lock()
	DPSMate.DPSMateSettings.lock = true
	for _,val in pairs(DPSMate.DPSMateSettings["windows"]) do
		_G("DPSMate_"..val["name"].."_Resize"):Hide()
	end
	-- Saving positions to prevent a potential crash
	local point, _, _, xOfs, yOfs;
	for key, val in DPSMate.DPSMateSettings["windows"] do
		if _G("DPSMate_"..val["name"]) then
			point, _, _, xOfs, yOfs = _G("DPSMate_"..val["name"]):GetPoint()
			DPSMate.DPSMateSettings["windows"][key]["position"] = {}
			DPSMate.DPSMateSettings["windows"][key]["position"][1] = point
			DPSMate.DPSMateSettings["windows"][key]["position"][2] = xOfs
			DPSMate.DPSMateSettings["windows"][key]["position"][3] = yOfs
			DPSMate.DPSMateSettings["windows"][key]["savsize"] = {}
			DPSMate.DPSMateSettings["windows"][key]["savsize"][1] = _G("DPSMate_"..val["name"]):GetWidth()
			DPSMate.DPSMateSettings["windows"][key]["savsize"][2] = _G("DPSMate_"..val["name"]):GetHeight()
		end
	end
	DPSMate:SendMessage(DPSMate.L["lockedallw"])
end

function DPSMate.Options:Unlock()
	DPSMate.DPSMateSettings.lock = false
	for _,val in pairs(DPSMate.DPSMateSettings["windows"]) do
		_G("DPSMate_"..val["name"].."_Resize"):Show()
	end
	DPSMate:SendMessage(DPSMate.L["unlockedallw"])
end

function DPSMate.Options:Hide(frame)
	DPSMate.DPSMateSettings["windows"][frame.Key]["hidden"] = true
	frame:Hide()
end

function DPSMate.Options:Show(frame)
	DPSMate.DPSMateSettings["windows"][frame.Key]["hidden"] = false
	frame:Show()
end

function DPSMate.Options:RemoveSegment(i)
	for cat, val in DPSMate.DPSMateHistory do
		tremove(DPSMate.DPSMateHistory[cat], i)
	end
	DPSMate.Options:InitializeSegments()
	DPSMate.Options.Dewdrop:Close()
end

function DPSMate.Options:ToggleTitleBarButtonState()
	local buttons = {"Config", "Reset", "Segments", "Filter", "Report", "Sync", "Enable"}
	for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
		local parent, i = _G("DPSMate_"..val["name"].."_Head"), 0
		for _, name in pairs(buttons) do
			local button = _G("DPSMate_"..val["name"].."_Head_"..name)
			if val["titlebar"..strlower(name)] then
				button:ClearAllPoints()
				button:SetPoint("RIGHT", parent, "RIGHT", -i*15-2, 0)
				button:Show()
				i=i+1
			else
				button:Hide()
			end
		end
	end
end

function DPSMate.Options:ToggleState()
	if DPSMate.DPSMateSettings["enable"] then
		DPSMate.DPSMateSettings["sync"] = false
		DPSMate.DPSMateSettings["enable"] = false
		DPSMate:Disable()
		for cat, val in DPSMate.DPSMateSettings["windows"] do
			_G("DPSMate_"..val["name"].."_Head_Sync"):GetNormalTexture():SetVertexColor(1,0,0,1)
			_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(false)
		end
	else
		DPSMate.DPSMateSettings["enable"] = true
		DPSMate:Enable()
		for cat, val in DPSMate.DPSMateSettings["windows"] do
			_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(true)
		end
	end
end

function DPSMate.Options:SetColor()
	local r,g,b = ColorPickerFrame:GetColorRGB()
	local swatch,frame
	swatch = _G(ColorPickerFrame.obj:GetName().."NormalTexture")
	frame = _G(ColorPickerFrame.obj:GetName().."_SwatchBg")
	swatch:SetVertexColor(r,g,b)
	frame.r = r
	frame.g = g
	frame.b = b
	
	DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key][ColorPickerFrame.var] = {r,g,b}
	
	ColorPickerFrame.rfunc()
end

function DPSMate.Options:CancelColor()
	local r = ColorPickerFrame.previousValues.r
	local g = ColorPickerFrame.previousValues.g
	local b = ColorPickerFrame.previousValues.b
	local swatch,frame
	swatch = _G(ColorPickerFrame.obj:GetName().."NormalTexture")
	frame = _G(ColorPickerFrame.obj:GetName().."_SwatchBg")
	swatch:SetVertexColor(r,g,b)
	frame.r = r
	frame.g = g
	frame.b = b
	
	DPSMate.DPSMateSettings["windows"][DPSMate_ConfigMenu_Menu.Key][ColorPickerFrame.var] = {r,g,b}
	
	ColorPickerFrame.rfunc()
end

function DPSMate.Options:OpenColorPicker(obj, var, func)
	CloseMenus()
	
	button = _G(obj:GetName().."_SwatchBg")
	
	ColorPickerFrame.obj = obj
	ColorPickerFrame.var = var
	ColorPickerFrame.rfunc = func
	
	ColorPickerFrame.func = DPSMate.Options.SetColor
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b)
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity}
	ColorPickerFrame.cancelFunc = DPSMate.Options.CancelColor

	ColorPickerFrame:SetPoint("TOPLEFT", obj, "TOPRIGHT", 0, 0)
	
	ColorPickerFrame:SetFrameStrata("TOOLTIP")
	
	ColorPickerFrame:Show()
end

function DPSMate.Options:ShowTooltip()
	if not this.user then return end
	if DPSMate.DPSMateSettings["showtooltips"] then
		DPSMate_Details.PaKey = this:GetParent():GetParent():GetParent().Key
		if DPSMate.DPSMateSettings["tooltipanchor"] == 1 then
			GameTooltip:SetOwner(UIParent, "BOTTOMRIGHT")
		elseif DPSMate.DPSMateSettings["tooltipanchor"] == 2 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "RIGHT")
		elseif DPSMate.DPSMateSettings["tooltipanchor"] == 3 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "LEFT")
		elseif DPSMate.DPSMateSettings["tooltipanchor"] == 4 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "TOP")
		elseif DPSMate.DPSMateSettings["tooltipanchor"] == 5 then
			GameTooltip:SetOwner(this:GetParent():GetParent():GetParent(), "TOPRIGHT")
		end
		local _, cbt = DPSMate:GetMode(DPSMate_Details.PaKey)
		GameTooltip:AddLine(this.user.." ["..self:FormatTime(cbt).."]", 1,0.82,0,1)
		DPSMate.RegistredModules[DPSMate.DPSMateSettings["windows"][DPSMate_Details.PaKey]["CurMode"]]:ShowTooltip(this.user, DPSMate_Details.PaKey)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(DPSMate.L["leftclickopend"], 0,1,0,1)
		GameTooltip:AddLine(DPSMate.L["rightclickopenm"], 0,1,0,1)
		GameTooltip:Show()
	end
end

function DPSMate.Options:InitializeHideShowWindow()
	local i = 1
	DPSMate.Options.Options[3]["args"]["hidewindow"]["args"] = {}
	DPSMate.Options.Options[3]["args"]["showwindow"]["args"] = {}
	for _,val in pairs(DPSMate.DPSMateSettings["windows"]) do
		DPSMate.Options.Options[3]["args"]["hidewindow"]["args"][val["name"]] = {
			order = i*10,
			type = 'execute',
			name = val["name"],
			desc = DPSMate.L["hide"].." "..val["name"],
			func = loadstring('DPSMate.Options:Hide(getglobal("DPSMate_'..val["name"]..'")); DPSMate.Options.Dewdrop:Close();'),
		}
		DPSMate.Options.Options[3]["args"]["showwindow"]["args"][val["name"]] = {
			order = i*10,
			type = 'execute',
			name = val["name"],
			desc = DPSMate.L["show"].." "..val["name"],
			func = loadstring('DPSMate.Options:Show(getglobal("DPSMate_'..val["name"]..'")); DPSMate.Options.Dewdrop:Close();'),
		}
		i=i+1
	end
end

function DPSMate.Options:CheckButton(name, id)
	if DPSMate.DPSMateSettings[name][id] then
		DPSMate.DPSMateSettings[name][id] = false
	else
		DPSMate.DPSMateSettings[name][id] = true
	end
	DPSMate:SetStatusBarValue()
end

function DPSMate.Options:ToggleSync()
	if DPSMate.DPSMateSettings["sync"] then
		DPSMate.DPSMateSettings["sync"] = false
		for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
			_G("DPSMate_"..val["name"].."_Head_Sync"):GetNormalTexture():SetVertexColor(1,0,0,1)
		end
	else
		DPSMate.DPSMateSettings["sync"] = true
		DPSMate.DPSMateSettings["enable"] = true
		for _, val in pairs(DPSMate.DPSMateSettings["windows"]) do
			_G("DPSMate_"..val["name"].."_Head_Enable"):SetChecked(true)
			_G("DPSMate_"..val["name"].."_Head_Sync"):GetNormalTexture():SetVertexColor(0.67,0.83,0.45,1)
		end
	end
	DPSMate.Sync.synckey = ""
end

local reportdelay = 0.5
local reportuptime = 0
function DPSMate.Options:OnUpdate()
	if DPSMate.DPSMateSettings["reportdelay"] and DPSMate.DelayMsg[1] then
		reportuptime = reportuptime + arg1
		if reportuptime>reportdelay then
			SendChatMessage(DPSMate.DelayMsg[1][1], DPSMate.DelayMsg[1][2], nil, DPSMate.DelayMsg[1][3])
			tremove(DPSMate.DelayMsg, 1)
			reportuptime = 0
		end
	end
end

function DPSMate.Options:MinimapButtonSetPosition(v)
	if(v < 0) then
		v = v + 360;
	end
	DPSMate.Options.MinimapButtonPosition = v;
	DPSMate.DPSMateSettings["MinimapButtonPosition"] = v
	DPSMate.Options:MinimapButtonUpdatePosition();
end

function DPSMate.Options:MinimapButtonBeingDragged()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70
	DPSMate.Options:MinimapButtonSetPosition(math.deg(math.atan2(ypos,xpos)));
end

function DPSMate.Options:MinimapButton_Init()
	if DPSMate.DPSMateSettings["showminimapbutton"] then
		DPSMateMinimapButtonFrame:Show();
	else
		DPSMateMinimapButtonFrame:Hide();
	end
end

function DPSMate.Options:MinimapButtonUpdatePosition()
	DPSMate.Options.MinimapButtonRadius = 78
	DPSMate.Options.MinimapButtonPosition = DPSMate.Options.MinimapButtonPosition or DPSMate.DPSMateSettings["MinimapButtonPosition"] or 336
	DPSMateMinimapButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (DPSMate.Options.MinimapButtonRadius * cos(DPSMate.Options.MinimapButtonPosition)),
		(DPSMate.Options.MinimapButtonRadius * sin(DPSMate.Options.MinimapButtonPosition)) - 55
	);
end