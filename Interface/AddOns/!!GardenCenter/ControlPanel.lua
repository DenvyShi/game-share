-- "改自Isler大神的FeatureFrame插件管理工具"
-- 	"感谢大家支持Isler大神的插件包：wow.isler.me"
-- 示例 --
--[[
local playerName = UnitName("player");
local _, title = GetAddOnInfo("DCT");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameDCT	= "战斗指示器";
		FF_DescDCT	= "显示你战斗中受到的各种信息及法术预警";
	elseif GetLocale() == "zhTW" then
		FF_NameDCT	= "戰鬥指示器";
		FF_DescDCT	= "顯示你戰鬥中受到的各種資訊及法術預警";
	else
		FF_NameDCT	= "DCT";
		FF_DescDCT	= "New Scrolling Combat Text";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "DCT";
				tab= "combat";
				name= FF_NameDCT;
				subtext= "Dennis's Combat Text";
				tooltip = FF_DescDCT;
				icon= "Interface\\Icons\\Ability_Gouge";
				callback= function(button)
					if not IsAddOnLoaded("DCT") then
						LoadAddOn("DCT");
					end
					DCT_showMenu();
				end;
			}
		);
	end
end
]]

local _, class = UnitClass("player");
local playerName = UnitName("player");
local Msg01 = "插件已启用，需重新载入，输入/rl回车即可"

-- 发送消息函数;
function CtrlPanel_ChatPrint(str)
	-- usually DEFAULT_CHAT_FRAME is the default "General" chat window
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(str, 1.0, 0.5, 0.25);
	end
end

-- 界面UI类插件;
local _, title = GetAddOnInfo("OneView");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameOneView	= "离线银行和背包";
		FF_DescOneView	= "显示离线银行、其他角色背包";
	elseif GetLocale() == "zhTW" then
		FF_NameOneView	= "离线银行和背包";
		FF_DescOneView	= "显示离线银行、其他角色背包";
	else
		FF_NameOneView	= "OneView";
		FF_DescOneView	= "One bag to rule them all, and in the darkness bind them.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "OneView";
				tab= "ui";
				name= FF_NameOneView;
				subtext= "OneView";
				tooltip = FF_DescOneView;
				icon= "Interface\\Icons\\INV_Misc_Bag_22";
				callback= function(button)
					if not IsAddOnLoaded("OneView") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("OneView"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("OneView");
					end
					OneViewFrame:Show();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("LootFilter");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameLootFilter	= "拾取过滤";
		FF_DescLootFilter	= "自动过滤玩家拾取的物品，自动开贝壳，自动确认装备绑定，自动摧毁物品";
	elseif GetLocale() == "zhTW" then
		FF_NameLootFilter	= "拾取过滤";
		FF_DescLootFilter	= "自动过滤玩家拾取的物品，自动开贝壳，自动确认装备绑定，自动摧毁物品";
	else
		FF_NameLootFilter	= "LootFilter";
		FF_DescLootFilter	= "Allows you to automatically filter items on quality, value and name, when looting.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "LootFilter";
				tab= "ui";
				name= FF_NameLootFilter;
				subtext= "LootFilter";
				tooltip = FF_DescLootFilter;
				icon= "Interface\\Icons\\INV_Misc_Spyglass_03";
				callback= function(button)
					if not IsAddOnLoaded("LootFilter") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("LootFilter"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("LootFilter");
					end
					LootFilterOptions:Show();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("LunaUnitFrames");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameLUF	= "头像框架增强";
		FF_DescLUF	= "默认头像框架增强";
	elseif GetLocale() == "zhTW" then
		FF_NameLUF	= "头像框架增强";
		FF_DescLUF	= "默认头像框架增强";
	else
		FF_NameLUF	= "LunaUnitFrames";
		FF_DescLUF	= "Lightweight Unit Frames in a modern look.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "LunaUnitFrames";
				tab= "ui";
				name= FF_NameLUF;
				subtext= "LunaUnitFrames";
				tooltip = FF_DescLUF;
				icon= "Interface\\AddOns\\!!GardenCenter\\icon\\UFP";
				callback= function(button)
					if not IsAddOnLoaded("LunaUnitFrames") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("LunaUnitFrames"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("LunaUnitFrames");
					end
					if LunaOptionsFrame:IsShown() then
						LunaOptionsFrame:Hide()
					else
						LunaOptionsFrame:Show()
					end
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("ShaguPlates");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameShaguPlates	= "Shagu姓名板";
		FF_DescShaguPlates	= "Shagu姓名版";
	elseif GetLocale() == "zhTW" then
		FF_NameShaguPlates	= "Shagu姓名板";
		FF_DescShaguPlates	= "Shagu姓名版";
	else
		FF_NameShaguPlates	= "ShaguPlates";
		FF_DescShaguPlates	= "Nameplate addon featuring castbars and class colors.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "ShaguPlates";
				tab= "ui";
				name= FF_NameShaguPlates;
				subtext= "ShaguPlates";
				tooltip = FF_DescShaguPlates;
				icon= "Interface\\Icons\\INV_ZulGurubTrinket";
				callback= function(button)
					if not IsAddOnLoaded("ShaguPlates") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("ShaguPlates"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("ShaguPlates");
					end
					SlashCmdList.SHAGUPLATES();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("zBar");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NamezBar	= "炽火动作条";
		FF_DesczBar	= "提供两个可以自由移动、变换形状的扩展动作条";
	elseif GetLocale() == "zhTW" then
		FF_NamezBar	= "熾火動作條";
		FF_DesczBar	= "提供兩個可以自由移動、變換形狀的擴展動作條";
	else
		FF_NamezBar	= "zBar";
		FF_DesczBar	= "ZeroFire's ActionBar Mod.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "zBar";
				tab= "ui";
				name= FF_NamezBar;
				subtext= "zBar";
				tooltip = FF_DesczBar;
				icon= "Interface\\Icons\\Spell_Holy_SummonLightwell";
				callback= function(button)
					if not IsAddOnLoaded("zBar") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("zBar"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("zBar");
					end
					SlashCmdList["ZBAR"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("DistanceWarning");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameDistanceWarning	= "目标距离";
		FF_DescDistanceWarning	= "监视目标距离";
	elseif GetLocale() == "zhTW" then
		FF_NameDistanceWarning	= "目標距離";
		FF_DescDistanceWarning	= "監視目標距離";
	else
		FF_NameDistanceWarning	= "DistanceWarning";
		FF_DescDistanceWarning	= "Estimated range display";
	end 
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "DistanceWarning";
				tab= "ui";
				name= FF_NameDistanceWarning;
				subtext= "DistanceWarning";
				tooltip = FF_DescDistanceWarning;
				icon= "Interface\\Icons\\Spell_Shadow_Charm";
				callback= function(button)
					if not IsAddOnLoaded("DistanceWarning") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("DistanceWarning"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("DistanceWarning");
					end
					SlashCmdList["DISTANCEWARNING"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("ItemRack");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameItemRack	= "快速换装和饰品";
		FF_DescItemRack	= "快速装备和饰品管理，更换或脱掉你身上的装备";
	elseif GetLocale() == "zhTW" then
		FF_NameItemRack	= "快速换装和饰品";
		FF_DescItemRack	= "快速装备和饰品管理，更换或脱掉你身上的装备";
	else
		FF_NameItemRack	= "ItemRack";
		FF_DescItemRack	= "Context menus for inventory items";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "ItemRack";
				tab= "ui";
				name= FF_NameItemRack;
				subtext= "ItemRack";
				tooltip = FF_DescItemRack;
				icon= "Interface\\Icons\\Inv_Stone_15";
				callback= function(button)
					if not IsAddOnLoaded("ItemRack") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("ItemRack"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("ItemRack");
					end
					ItemRack_Sets_Toggle();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("TrinketMenu");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameTrinketMenu	= "饰品管理器";
		FF_DescTrinketMenu	= "饰品管理器";
	elseif GetLocale() == "zhTW" then
		FF_NameTrinketMenu	= "飾品管理器";
		FF_DescTrinketMenu	= "飾品管理器";
	else
		FF_NameTrinketMenu	= "TrinketMenu";
		FF_DescTrinketMenu	= "TrinketMenu";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "TrinketMenu";
				tab= "ui";
				name= FF_NameTrinketMenu;
				subtext= "TrinketMenu";
				tooltip = FF_DescTrinketMenu;
				icon= "Interface\\Icons\\Inv_Stone_15";
				callback= function(button)
					if not IsAddOnLoaded("TrinketMenu") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("TrinketMenu"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("TrinketMenu");
					end
					TrinketMenu.ToggleFrame(TrinketMenu_OptFrame);
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("ChatMOD");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameChatMOD	= "聊天辅助";
		FF_DescChatMOD	= "聊天窗口以及某些功能的增强";
	elseif GetLocale() == "zhTW" then
		FF_NameChatMOD	= "聊天輔助";
		FF_DescChatMOD	= "聊天窗口以及某些功能的增强";
	else
		FF_NameChatMOD	= "ChatMOD";
		FF_DescChatMOD	= "General Purpose full featured Chat Enhancement Collection.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "ChatMOD";
				tab= "ui";
				name= FF_NameChatMOD;
				subtext= "ChatMOD";
				tooltip = FF_DescChatMOD;
				icon= "Interface\\AddOns\\ChatMOD\\UI_Pro_chat";
				callback= function(button)
					if not IsAddOnLoaded("ChatMOD") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("ChatMOD"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("ChatMOD");
					end
					SlashCmdList["SCCN"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("WIM");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameWIM	= "密语提醒屏";
		FF_DescWIM= "美观的密语提醒记录";
	elseif GetLocale() == "zhTW" then
		FF_NameWIM	= "密语提醒屏";
		FF_DescWIM	= "美观的密语提醒记录";
	else
		FF_NameWIM	= "WIM";
		FF_DescWIM	= "Give whispers an instant messenger feel.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "WIM";
				tab= "ui";
				name= FF_NameWIM;
				subtext= "WIM";
				tooltip = FF_DescWIM;
				icon= "Interface\\AddOns\\WIM\\Images\\minimap_message";
				callback= function(button)
					if not IsAddOnLoaded("WIM") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("WIM"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("WIM");
					end
					SlashCmdList["WIM"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("Buffalo");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameBuffalo	= "Buff/debuff显示增强";
		FF_DescBuffalo	= "随意移动和缩放Buff和DeBuff位置";
	elseif GetLocale() == "zhTW" then
		FF_NameBuffalo	= "Buff/debuff显示增强";
		FF_DescBuffalo	= "随意移动和缩放Buff和DeBuff位置";
	else
		FF_NameBuffalo	= "Buffalo";
		FF_DescBuffalo	= "Customizing your buff display";
	end
	if (EarthFeature_AddButton) then
		EarthFeature_AddButton(
			{
				id = "Buffalo";
				tab= "ui";
				name = FF_NameBuffalo;
				subtext = "Buffalo";
				tooltip = FF_DescBuffalo;
				icon = "Interface\\Icons\\Spell_Holy_MagicalSentry";
				callback= function(button)
					if not IsAddOnLoaded("Buffalo") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Buffalo"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Buffalo");
					end
					SlashCmdList["BuffaloCMD"]("");
				end;
			}
		);
	end
end

-- 辅助类插件;

local _, title = GetAddOnInfo("Automaton");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameAutomaton	= "自动化功能合集";
		FF_DescAutomaton	= "自动完成某一些功能。比如：跳过NPC的闲谈窗口、自动下马、自动站立等";
	elseif GetLocale() == "zhTW" then
		FF_NameAutomaton	= "自動化功能合集";
		FF_DescAutomaton	= "自动完成某一些功能。比如：跳过NPC的闲谈窗口、自动下马、自动站立等";
	else
		FF_NameAutomaton	= "Automaton";
		FF_DescAutomaton	= "Reduces interface tedium by doing the little things for you.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "Automaton";
				tab= "ui";
				name= FF_NameAutomaton;
				subtext= "Automaton";
				tooltip = FF_DescAutomaton;
				icon= "Interface\\Icons\\Inv_trinket_naxxramas02";
				callback= function(button)
					if not IsAddOnLoaded("Automaton") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Automaton"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Automaton");
					end
					SlashCmdList["AUTOMATONCL"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("ActionBarSaver");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameActionBarSaver	= "动作条快速保存加载";
		FF_DescActionBarSaver	= "允许你为你的动作条设置不同的配置文件,保存动作条/abs save <名字>、导入动作条/abs load <名字>、列出保存动作条的配置名字/abs list";
	elseif GetLocale() == "zhTW" then
		FF_NameActionBarSaver	= "動作條快速保存加載";
		FF_DescActionBarSaver	= "允许你为你的动作条设置不同的配置文件,保存动作条/abs save <名字>、导入动作条/abs load <名字>、列出保存动作条的配置名字/abs list";
	else
		FF_NameActionBarSaver	= "ActionBarSaver";
		FF_DescActionBarSaver	= "Saves and restores your action bars.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "ActionBarSaver";
				tab= "ui";
				name= FF_NameActionBarSaver;
				subtext= "ActionBarSaver";
				tooltip = FF_DescActionBarSaver;
				icon= "Interface\\Icons\\INV_Misc_Rune_01";
				callback= function(button)
					if not IsAddOnLoaded("ActionBarSaver") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("ActionBarSaver"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("ActionBarSaver");
					end
					SlashCmdList["ABS"]("");
					SlashCmdList["ABS"]("list");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("EQL3");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameEQL3	= "任务框架扩展";
		FF_DescEQL3	= "任务通报,显示任务等级,自动追踪任务并允许移动任务追踪列表";
	elseif GetLocale() == "zhTW" then
		FF_NameEQL3	= "系統任務增強";
		FF_DescEQL3	= "任務通報,顯示任務等級,自動追蹤任務並允許移動任務追蹤列表";
	else
		FF_NameEQL3	= "EQL3";
		FF_DescEQL3	= "Quest Announce, shows the quest level, quest auto track and move the Quest Tracker!";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "EQL3";
				tab= "data";
				name= FF_NameEQL3;
				subtext= "EQL3";
				tooltip = FF_DescEQL3;
				icon= "Interface\\Icons\\Inv_Letter_17";
				callback= function(button)
					if not IsAddOnLoaded("EQL3") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("EQL3"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("EQL3");
					end
					QuestLog_Options_Toggle();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("pfQuest");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NamepfQuest	= "任务助手 ";
		FF_DescpfQuest	= "WOW任务数据库pfQuest";
	elseif GetLocale() == "zhTW" then
		FF_NamepfQuest	= "任務助手 ";
		FF_DescpfQuest	= "WOW任務資料庫pfQuest";
	else
		FF_NamepfQuest	= "pfQuest";
		FF_DescpfQuest	= "A lightweight Questhelper and Database";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "pfQuest";
				tab= "data";
				name= FF_NamepfQuest;
				subtext= "pfQuest";
				tooltip = FF_DescpfQuest;
				icon= "Interface\\Icons\\Ability_Hunter_Snipershot";
				callback= function(button)
					if not IsAddOnLoaded("pfQuest") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("pfQuest"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("pfQuest");
					end
					SlashCmdList["PFDB"]("config");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("Gatherer");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameGatherer	= "采集助手";
		FF_DescGatherer	= "收集花草、矿物、宝箱的位置并将其标注在地图上";
	elseif GetLocale() == "zhTW" then
		FF_NameGatherer	= "採集助手";
		FF_DescGatherer	= "收集花草、礦物、寶箱的位置並將其標注在地圖上";
	else
		FF_NameGatherer	= "Gatherer";
		FF_DescGatherer	= "Collects Herbs, Mines, Box locations and adds them to the worldmap and minimap";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "Gatherer";
				tab= "data";
				name= FF_NameGatherer;
				subtext= "Gatherer";
				tooltip = FF_DescGatherer;
				icon= "Interface\\AddOns\\Gatherer\\Icons\\sporefish";
				callback= function(button)
					if not IsAddOnLoaded("Gatherer") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Gatherer"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Gatherer");
					end
					SlashCmdList["GATHER"]("options");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("FelwoodGather");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameGatherer	= "费伍德水果助手";
		FF_DescGatherer	= "显示费伍德花、果的位置";
	elseif GetLocale() == "zhTW" then
		FF_NameGatherer	= "费伍德水果助手";
		FF_DescGatherer	= "显示费伍德花、果的位置";
	else
		FF_NameGatherer	= "FelwoodGather";
		FF_DescGatherer	= "Timer manager for felwood fruit gathering.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "FelwoodGather";
				tab= "data";
				name= FF_NameGatherer;
				subtext= "FelwoodGather";
				tooltip = FF_DescGatherer;
				icon= "Interface\\Icons\\INV_Misc_Food_55";
				callback= function(button)
					if not IsAddOnLoaded("FelwoodGather") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("FelwoodGather"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("FelwoodGather");
					end
					SlashCmdList["FELWOODGATHER"]("配置");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("Atlas");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameAtlas	= "副本地图";
		FF_DescAtlas	= "副本地图浏览器";
	elseif GetLocale() == "zhTW" then
		FF_NameAtlas	= "副本地圖";
		FF_DescAtlas	= "副本地圖集";
	else
		FF_NameAtlas	= "Atlas";
		FF_DescAtlas	= "Instance Map Browser";
	end 
	if(EarthFeature_AddButton) then
		EarthFeature_AddButton(
			{
				id= "Atlas";
				tab= "data";
				name= FF_NameAtlas;
				subtext= "Atlas";
				tooltip = FF_DescAtlas;
				icon = "Interface\\AddOns\\Atlas\\Images\\AtlasIcon";
				callback= function(button)
					if not IsAddOnLoaded("Atlas") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Atlas"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Atlas");
					end
					Atlas_Toggle();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("AtlasLoot");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameAtlasLoot	= "副本掉落物品查询";
		FF_DescAtlasLoot	= "显示副本中的首领与小怪可能掉落的物品";
	elseif GetLocale() == "zhTW" then
		FF_NameAtlasLoot	= "首領掉落物品查詢";
		FF_DescAtlasLoot	= "顯示首領與小怪可能掉落的物品，並可查詢各陣營與戰場的獎勵物品、套裝物品等";
	else
		FF_NameAtlasLoot	= "AtlasLoot";
		FF_DescAtlasLoot	= "Shows the possible loot from the bosses";
	end 
	if(EarthFeature_AddButton) then
		EarthFeature_AddButton(
			{
				id= "AtlasLoot";
				tab= "data";
				name= FF_NameAtlasLoot;
				subtext= "AtlasLoot Enhanced";
				tooltip = FF_DescAtlasLoot;
				icon = "Interface\\Icons\\INV_Box_01";
				callback= function(button)
					if not IsAddOnLoaded("AtlasLoot") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("AtlasLoot"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("AtlasLoot");
					end
					AtlasLoot_ShowMenu();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("sTrade");
local argsTrade = 0
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameTradeLog	= "交易通告";
		FF_DescTradeLog	= "交易记录通告";
	elseif GetLocale() == "zhTW" then
		FF_NameTradeLog	= "交易通報";
		FF_DescTradeLog	= "交易記錄通報";
	else
		FF_NameTradeLog	= "sTrade";
		FF_DescTradeLog	= "Report TradeList.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "sTrade";
				tab= "data";
				name= FF_NameTradeLog;
				subtext= "sTrade";
				tooltip = FF_DescTradeLog;
				icon= "Interface\\GossipFrame\\BankerGossipIcon";
				callback= function(button)
					if not IsAddOnLoaded("sTrade") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("sTrade"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("sTrade");
					end
					if argsTrade == 0 then
						SlashCmdList["sTrade"]("");
						argsTrade = 1;
					elseif argsTrade == 1 then
						sTradeLLFrame.main:Hide();
						argsTrade = 0;
					end
				end;
			}
		);
	end
end

-- 战斗类插件;

local _, title = GetAddOnInfo("sct");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameSCT	= "战斗滚动信息";
		FF_DescSCT	= "在你的角色上增加滚动的战斗信息";
	elseif GetLocale() == "zhTW" then
		FF_NameSCT	= "戰鬥滾動信息";
		FF_DescSCT	= "在你的角色上增加滾動的戰鬥信息";
	else
		FF_NameSCT	= "sct";
		FF_DescSCT	= "Adds Scrolling Combat Text above your character";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "sct";
				tab= "combat";
				name= FF_NameSCT;
				subtext= "Dennis's Combat Text";
				tooltip = FF_DescSCT;
				icon= "Interface\\Icons\\Ability_Gouge";
				callback= function(button)
					if not IsAddOnLoaded("sct") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("sct"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("sct");
					end
					SlashCmdList["DSCTMENU"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("DamageEx");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameDamageEx	= "增强伤害显示器";
		FF_DescDamageEx	= "显示你对敌人的伤害，对目标的治疗量，并可显示技能名字";
	elseif GetLocale() == "zhTW" then
		FF_NameDamageEx	= "增強傷害顯示器";
		FF_DescDamageEx	= "顯示你對敵人的傷害，對目標的治療量，並可顯示技能名字";
	else
		FF_NameDamageEx	= "DamageEx";
		FF_DescDamageEx	= "New Scrolling Combat Text of Damage";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "DamageEx";
				tab= "combat";
				name= FF_NameDamageEx;
				subtext= "DamageEx";
				tooltip = FF_DescDamageEx;
				icon= "Interface\\Icons\\Ability_DualWield";
				callback= function(button)
					if not IsAddOnLoaded("DamageEx") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("DamageEx"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("DamageEx");
					end
					DEX_showMenu();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("ModifiedPowerAuras");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameMPOWA	= "触发法术效果提示";
		FF_DescMPOWA	= "改良版Power Auras，Buff/DeBuff特效可视化显示";
	elseif GetLocale() == "zhTW" then
		FF_NameMPOWA	= "觸發法術效果提示";
		FF_DescMPOWA	= "改良版Power Auras，Buff/DeBuff特效可视化显示";
	else
		FF_NameMPOWA	= "ModifiedPowerAuras";
		FF_DescMPOWA	= "Modified Power Auras is an advanced version of the original Power Auras from Sinesther. ";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "ModifiedPowerAuras";
				tab= "combat";
				name= FF_NameMPOWA;
				subtext= "Modified Power Auras";
				tooltip = FF_DescMPOWA;
				icon= "Interface\\Icons\\Ability_Warrior_Charge";
				callback= function(button)
					if not IsAddOnLoaded("ModifiedPowerAuras") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("ModifiedPowerAuras"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("ModifiedPowerAuras");
					end
					SlashCmdList["MPOWA"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("BGFlag");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameBGFlag	= "战场旗帜";
		FF_DescBGFlag	= "记录并跟踪各种3大战场的资源/占塔/胜败等计时。";
	elseif GetLocale() == "zhTW" then
		FF_NameBGFlag	= "戰場旗帜";
		FF_DescBGFlag	= "記錄並跟蹤各種3大戰場的資源/佔塔/勝敗等計時。";
	else
		FF_NameBGFlag	= "BGFlag";
		FF_DescBGFlag	= "Battleground timers and other PvP features.";
	end

	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "BGFlag";
				tab= "combat";
				name= FF_NameBGFlag;
				subtext= "BGFlag";
				tooltip = FF_DescBGFlag;
				icon= "Interface\\Icons\\Spell_Nature_TimeStop";
				callback= function(button)
					if not IsAddOnLoaded("BGFlag") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("BGFlag"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("BGFlag");
					end
					SlashCmdList["BGFlag"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("avbars");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameClassTimer	= "战场计时条";
		FF_DescClassTimer	= "记录并跟踪各种3大战场的资源/占塔/胜败等计时。";
	elseif GetLocale() == "zhTW" then
		FF_NameClassTimer	= "戰場計時條";
		FF_DescClassTimer	= "記錄並跟蹤各種3大戰場的資源/佔塔/勝敗等計時。";
	else
		FF_NameClassTimer	= "avbars";
		FF_DescClassTimer	= "Graphical Timers for Events in AV and AB.";
	end

	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "avbars";
				tab= "combat";
				name= FF_NameClassTimer;
				subtext= "avbars";
				tooltip = FF_DescClassTimer;
				icon= "Interface\\Icons\\INV_Jewelry_Amulet_07";
				callback= function(button)
					if not IsAddOnLoaded("avbars") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("avbars"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("avbars");
					end
					SlashCmdList["AVBARSTEST"]("");
				end;
			}
		);
	end
end

-- 组队团队类插件;

local _, title = GetAddOnInfo("KLHThreatMeter");
local KLHTMnewVisible = true
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameKLHThreatMeter	= "仇恨统计";
		FF_DescKLHThreatMeter	= "一个灵活的，多目标的，低资源占用的威胁值计量器。";
	elseif GetLocale() == "zhTW" then
		FF_NameKLHThreatMeter	= "仇恨統計";
		FF_DescKLHThreatMeter	= "一個輕量級、有彈性、可監視多個目標的仇恨統計插件。";
	else
		FF_NameKLHThreatMeter	= "KLHThreatMeter";
		FF_DescKLHThreatMeter	= "Simple threat meter for WoW Classic, click left button to show frame.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "KLHThreatMeter";
				tab= "group";
				name= FF_NameKLHThreatMeter;
				subtext= "KLHThreatMeter";
				tooltip = FF_DescKLHThreatMeter;
				icon= "Interface\\Icons\\Ability_Cheapshot";
				callback= function(button)
					if not IsAddOnLoaded("KLHThreatMeter") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("KLHThreatMeter"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("KLHThreatMeter");
					end
					-- KLHTM_ToggleOptionsGui();
					if (KLHTMnewVisible) then
						KLHTM_SetVisible(KLHTMnewVisible);
						KLHTMnewVisible = false;
					else
						KLHTM_SetVisible(KLHTMnewVisible)
						KLHTMnewVisible = true;
					end
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("SW_Stats");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameSW_Stats	= "战斗数据统计";
		FF_DescSW_Stats	= "统计团队玩家造成的伤害、治疗等副本数据";
	elseif GetLocale() == "zhTW" then
		FF_NameSW_Stats	= "戰鬥數據統計";
		FF_DescSW_Stats	= "統計團隊玩家造成的傷害、治療等副本數據";
	else
		FF_NameSW_Stats	= "SW_Stats";
		FF_DescSW_Stats	= "Shadow Warrior Damage Stats.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "SW_Stats";
				tab= "group";
				name= FF_NameSW_Stats;
				subtext= "SW_Stats";
				tooltip = FF_DescSW_Stats;
				icon= "Interface\\Icons\\Spell_Nature_Sentinal";
				callback= function(button)
					if not IsAddOnLoaded("SW_Stats") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("SW_Stats"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("SW_Stats");
					end
					SlashCmdList["SW_STATS"]("bars");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("DPSMate");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameDPSMate	= "战斗数据统计";
		FF_DescDPSMate	= "统计团队玩家造成的伤害、治疗等副本数据";
	elseif GetLocale() == "zhTW" then
		FF_NameDPSMate	= "戰鬥數據統計";
		FF_DescDPSMate	= "統計團隊玩家造成的傷害、治療等副本數據";
	else
		FF_NameDPSMate	= "DPSMate";
		FF_DescDPSMate	= " DPSMate is an advanced combat analyzation tool, providing helpful graphs and statistics to evaluate the fight.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "DPSMate";
				tab= "group";
				name= FF_NameDPSMate;
				subtext= "DPSMate";
				tooltip = FF_DescDPSMate;
				icon= "Interface\\Icons\\Spell_Nature_Sentinal";
				callback= function(button)
					if not IsAddOnLoaded("DPSMate") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("DPSMate"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("DPSMate");
					end
					SlashCmdList["DPSMate"] ("config");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("DamageMeters");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameDamageMeters	= "伤害统计";
		FF_DescDamageMeters	= "图形化显示伤害/治疗的统计插件，左键点击显示窗体。";
	elseif GetLocale() == "zhTW" then
		FF_NameDamageMeters	= "傷害統計";
		FF_DescDamageMeters	= "圖形化顯示傷害/治療的統計插件，左鍵點擊顯示窗體。";
	else
		FF_NameDamageMeters	= "DamageMeters";
		FF_DescDamageMeters	= "Displays accumulated damage totals for you and nearby players.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "DamageMeters";
				tab= "group";
				name= FF_NameDamageMeters;
				subtext= "DamageMeters";
				tooltip = FF_DescDamageMeters;
				icon= "Interface\\Icons\\Spell_Nature_Sentinal";
				callback= function(button)
					if not IsAddOnLoaded("DamageMeters") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("DamageMeters"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("DamageMeters");
					end
					DamageMeters_ShowMainMenu();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("sRaidFrames");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NamesRaidFrames	= "团队框架";
		FF_DescsRaidFrames	= "CT_RaidAssist风格的团队框架,调用命令/srf";
	elseif GetLocale() == "zhTW" then
		FF_NamesRaidFrames	= "團隊框架";
		FF_DescsRaidFrames	= "CT_RaidAssist風格的團隊框架,调用命令/srf";
	else
		FF_NamesRaidFrames	= "sRaidFrames";
		FF_DescsRaidFrames	= "A modular, lightweight and screen-estate saving grid of party/raid unit frames";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "sRaidFrames";
				tab= "group";
				name= FF_NamesRaidFrames;
				subtext= "sRaidFrames";
				tooltip = FF_DescsRaidFrames;
				icon= "Interface\\AddOns\\!!GardenCenter\\icon\\Gridicon";
				callback= function(button)
					if not IsAddOnLoaded("sRaidFrames") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("sRaidFrames"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("sRaidFrames");
					end
					SlashCmdList["SRFCMD"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("notgrid");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_Namenotgrid	= "团队框架";
		FF_Descnotgrid	= "小巧的团队状态监视器";
	elseif GetLocale() == "zhTW" then
		FF_Namenotgrid	= "團隊框架";
		FF_Descnotgrid	= "小巧的團隊狀態監視器";
	else
		FF_Namenotgrid	= "notgrid";
		FF_Descnotgrid	= "A modular, lightweight and screen-estate saving grid of party/raid unit frames";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "notgrid";
				tab= "group";
				name= FF_Namenotgrid;
				subtext= "notgrid";
				tooltip = FF_Descnotgrid;
				icon= "Interface\\AddOns\\notgrid\\media\\icon";
				callback= function(button)
					if not IsAddOnLoaded("notgrid") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("notgrid"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("notgrid");
					end
					SlashCmdList.NOTGRID("");
					-- SlashCmdList["NOTGRIDCMD"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("Grid");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameGrid	= "团队框架";
		FF_DescGrid= "显示团队/队伍的状态的模块式团队框架";
	elseif GetLocale() == "zhTW" then
		FF_NameGrid	= "團隊框架";
		FF_DescGrid	= "显示团队/队伍的状态的模块式团队框架";
	else
		FF_NameGrid	= "Grid";
		FF_DescGrid	= "A modular, lightweight and screen-estate saving grid of party/raid unit frames";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "Grid";
				tab= "group";
				name= FF_NameGrid;
				subtext= "Grid";
				tooltip = FF_DescGrid;
				icon= "Interface\\AddOns\\Grid\\icon";
				callback= function(button)
					if not IsAddOnLoaded("Grid") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Grid"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Grid");
					end
					SlashCmdList["GRIDCMD"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("BigWigs");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameBigWigs	= "BOSS技能预警";
		FF_DescBigWigs	= "预警并提示BOSS技能，调用命令: /bw";
	elseif GetLocale() == "zhTW" then
		FF_NameBigWigs	= "BOSS技能预警";
		FF_DescBigWigs	= "预警并提示BOSS技能，调用命令: /bw";
	else
		FF_NameBigWigs	= "BigWigs";
		FF_DescBigWigs	= "all kinds of boss skill";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "BigWigs";
				tab= "group";
				name= FF_NameBigWigs;
				subtext= "BigWigs";
				tooltip = FF_DescBigWigs;
				icon= "Interface\\AddOns\\BigWigs\\Icons\\core-enabled";
				callback= function(button)
					if not IsAddOnLoaded("BigWigs") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("BigWigs"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("BigWigs");
					end
					-- SlashCmdList["MCPSLASHCMD"]("");
					SlashCmdList["BigWigsSLASHCMD"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("XRS");
if title ~= nil then
	if GetLocale() == "zhCN" then
		FF_NameXRS	= "团队增益状态检查";
		FF_DescXRS	= "可以检查团队的BUFF等数据，建议团长使用，调用命令: /xrs";
	elseif GetLocale() == "zhTW" then
		FF_NameXRS	= "团队增益状态检查";
		FF_DescXRS	= "可以检查团队的BUFF等数据，建议团长使用，调用命令: /xrs";
	else
		FF_NameXRS	= "XRS";
		FF_DescXRS	= "Status Information about the Raid Group";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "XRS";
				tab= "group";
				name= FF_NameXRS;
				subtext= "XRS";
				tooltip = FF_DescXRS;
				icon= "Interface\\Icons\\Spell_Holy_SealOfSalvation";
				callback= function(button)
					if not IsAddOnLoaded("XRS") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("XRS"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("XRS");
					end
					-- SlashCmdList["MCPSLASHCMD"]("");
					SlashCmdList["XRSCMD"]("");
				end;
			}
		);
	end
end

-- 职业类插件;

local _, title = GetAddOnInfo("Decursive");
local argDecursive = 0
if title ~= nil and (class == "MAGE" or class == "PRIEST" or class == "DRUID" or class == "PALADIN" or class == "SHAMAN") then
	if GetLocale() == "zhCN" then
		FF_NameDecursive	= "一键驱散";
		FF_DescDecursive	= "提供显示和清除负面效果的功能，并提供相应的高级过滤和优先级系统";
	elseif GetLocale() == "zhTW" then
		FF_NameDecursive	= "一鍵驅散";
		FF_DescDecursive	= "提供驅魔輔助功能，包含進階的顯示及過濾功能";
	else
		FF_NameDecursive	= "Decursive";
		FF_DescDecursive	= "Affliction display and cleaning for solo, group and raids with advanced filtering and priority system.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "Decursive";
				tab= "combat";
				name= FF_NameDecursive;
				subtext= "Decursive";
				tooltip = FF_DescDecursive;
				icon= "Interface\\Icons\\Spell_Nature_Purge";
				callback= function(button)
					if not IsAddOnLoaded("Decursive") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Decursive"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Decursive");
					end
					if argDecursive == 0 then
						-- SlashCmdList["DECURSIVESHOW"] ("");
						Dcr_Hide(argDecursive);
						argDecursive = 1;
					elseif argDecursive == 1 then
						SlashCmdList["DECURSIVESKSHOW"]("");
						Dcr_Hide(argDecursive);
						argDecursive = 0;
					end
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("SmartBuff");
if title ~= nil and (class == "MAGE" or class == "PRIEST" or class == "DRUID" or class == "PALADIN" or class == "SHAMAN") then
	if GetLocale() == "zhCN" then
		FF_NameSmartBuff	= "智能buff助手";
		FF_DescSmartBuff = "监控团队及团员增益效果";
	elseif GetLocale() == "zhTW" then
		FF_NameSmartBuff = "智能buff助手團隊增益監控";
		FF_DescSmartBuff	= "監控團隊及團員增益效果";
	else
		FF_NameSmartBuff	= "SmartBuff";
		FF_DescSmartBuff	= "Cast the most important buffs on you or party/raid members/pets";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "SmartBuff";
				tab= "group";
				name= FF_NameSmartBuff;
				subtext= "SmartBuff";
				tooltip = FF_DescSmartBuff;
				icon= "Interface\\Icons\\INV_Misc_Head_Dragon_Red";
				callback= function(button)
					if not IsAddOnLoaded("SmartBuff") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("SmartBuff"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("SmartBuff");
					end
					SlashCmdList["SMARTBUFFMENU"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("Clique");
if title ~= nil and (class == "PRIEST" or class == "DRUID" or class == "PALADIN" or class == "SHAMAN")  then
	if GetLocale() == "zhCN" then
		FF_NameClique	= "治疗点击施法助手";
		FF_DescClique = "点击施法助手，支持通过鼠标或者鼠标组合键点击目标框架施放法术.";
	elseif GetLocale() == "zhTW" then
		FF_NameClique= "治療点击施法助手";
		FF_DescClique	= "点击施法助手，支持通过鼠标或者鼠标组合键点击目标框架施放法术";
	else
		FF_NameClique	= "Clique";
		FF_DescClique	= "Simply powerful click-casting interface";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "Clique";
				tab= "class";
				name= FF_NameClique;
				subtext= "Clique";
				tooltip = FF_DescClique;
				icon= "Interface\\Icons\\Spell_Holy_SearingLight";
				callback= function(button)
					if not IsAddOnLoaded("Clique") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Clique"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Clique");
					end
					ToggleFrame(SpellBookFrame);
					Clique:Toggle();
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("QuickHeal");
if title ~= nil and (class == "PRIEST" or class == "DRUID" or class == "PALADIN" or class == "SHAMAN")  then
	if GetLocale() == "zhCN" then
		FF_NameQuickHeal	= "快速治疗";
		FF_DescQuickHeal = "快速治疗小队或团队成员.";
	elseif GetLocale() == "zhTW" then
		FF_NameQuickHeal= "快速治疗";
		FF_DescQuickHeal	= "快速治疗小队或团队成员";
	else
		FF_NameQuickHeal	= "QuickHeal";
		FF_DescQuickHeal	= "Quick healing of party/raid members";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "QuickHeal";
				tab= "class";
				name= FF_NameQuickHeal;
				subtext= "QuickHeal";
				tooltip = FF_DescQuickHeal;
				icon= "Interface\\Icons\\Spell_Holy_FlashHeal";
				callback= function(button)
					if not IsAddOnLoaded("QuickHeal") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("QuickHeal"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("QuickHeal");
					end
					SlashCmdList["QUICKHEAL"]("cfg");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("HunterBar_FeedButton");
local argHBFeedButton = 0
if title ~= nil and class == "HUNTER" then
	if GetLocale() == "zhCN" then
		FF_NameHBFeedButton	= "一键喂食按钮";
		FF_DescHBFeedButton = "猎人宠物快速喂食按钮";
	elseif GetLocale() == "zhTW" then
		FF_NameHBFeedButton = "一鍵餵食按鈕";
		FF_DescHBFeedButton	= "獵人寵物快速餵食按鈕";
	else
		FF_NameHBFeedButton	= "HunterBar_FeedButton";
		FF_DescHBFeedButton	= "One click to feed the selected food to your pet, and autofeed when pet less than specified happiness level";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "HunterBar_FeedButton";
				tab= "class";
				name= FF_NameHBFeedButton;
				subtext= "HunterBar_FeedButton";
				tooltip = FF_DescHBFeedButton;
				icon= "Interface\\Icons\\Ability_Hunter_BeastTraining";
				callback= function(button)
					if not IsAddOnLoaded("HunterBar_FeedButton") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("HunterBar_FeedButton"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("HunterBar_FeedButton");
					end
					if argHBFeedButton == 0 then
						SlashCmdList["FEEDPETBUTTON"]("");
						argHBFeedButton = 1;
					elseif argHBFeedButton == 1 then
						SlashCmdList["FEEDPETBUTTON"]("status");
						argHBFeedButton = 0;
					end
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("CallOfElements");
if title ~= nil and class == "SHAMAN" then
	if GetLocale() == "zhCN" then
		FF_NameCOE	= "图腾助手";
		FF_DESCCOE	= "减少技能栏占用，冷却计时，动态图腾组合，PVP职业分类图腾组合，单键施放四系图腾";
	elseif GetLocale() == "zhTW" then
		FF_NameCOE = "圖騰助手";
		FF_DESCCOE	= "減少技能欄佔用，冷卻計時，動態圖騰組合，PVP職業分類圖騰組合，單鍵施放四系圖騰";
	else
		FF_NameCOE	= "CallOfElements";
		FF_DESCCOE	= "The All-In-One Shaman Addon";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "CallOfElements";
				tab= "class";
				name= FF_NameCOE;
				subtext= "CallOfElements";
				tooltip = FF_DESCCOE;
				icon= "Interface\\Icons\\Spell_Totem_WardOfDraining";
				callback= function(button)
					if not IsAddOnLoaded("CallOfElements") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("CallOfElements"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("CallOfElements");
					end
					SlashCmdList["COE"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("PallyPower");
if title ~= nil and class == "PALADIN" then
	if GetLocale() == "zhCN" then
		FF_NamePallyPower	= "祝福管理助手";
		FF_DescPallyPower= "祝福buff管理";
	elseif GetLocale() == "zhTW" then
		FF_NamePallyPower= "祝福管理助手";
		FF_DescPallyPower	= "祝福buff管理";
	else
		FF_NamePallyPower	= "PallyPower";
		FF_DescPallyPower	= "Raid/Party Paladin buffs";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "PallyPower";
				tab= "class";
				name= FF_NamePallyPower;
				subtext= "PallyPower";
				tooltip = FF_DescPallyPower;
				icon= "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings";
				callback= function(button)
					if not IsAddOnLoaded("PallyPower") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("PallyPower"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("PallyPower");
					end
					SlashCmdList["PALLYPOWER"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("Necrosis");
if title ~= nil and class == "WARLOCK" then
	if GetLocale() == "zhCN" then
		FF_NameNecrosis	= "球体技能助手";
		FF_DescNecrosis= "术士老牌综合球体技能助手";
	elseif GetLocale() == "zhTW" then
		FF_NameNecrosis= "球體技能助手";
		FF_DescNecrosis	= "術士老牌綜合球體技能助手";
	else
		FF_NameNecrosis	= "Necrosis";
		FF_DescNecrosis	= "Warlock UI & Shard Management";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "Necrosis";
				tab= "class";
				name= FF_NameNecrosis;
				subtext= "Necrosis";
				tooltip = FF_DescNecrosis;
				icon= "Interface\\Icons\\Spell_Shadow_SoulGem";
				callback= function(button)
					if not IsAddOnLoaded("Necrosis") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("Necrosis"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("Necrosis");
					end
					SlashCmdList["NecrosisCommand"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("SimpleTranqShot");
if title ~= nil and class == "HUNTER" then
	if GetLocale() == "zhCN" then
		FF_NameSTS	= "凝神射击助手";
		FF_DescSTS = "猎人凝神射击通告功能";
	elseif GetLocale() == "zhTW" then
		FF_NameSTS = "凝神射击助手";
		FF_DescSTS	= "獵人凝神射擊通告功能";
	else
		FF_NameSTS	= "SimpleTranqShot";
		FF_DescSTS	= "Watches for Tranquilizing Shot hits and misses and broadcasts a message to the desired channel when either occurs.  Also displays a message on the screen when the Tranquilizing Shot misses or fails.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "SimpleTranqShot";
				tab= "class";
				name= FF_NameSTS;
				subtext= "SimpleTranqShot";
				tooltip = FF_DescSTS;
				icon= "Interface\\Icons\\Spell_Nature_FaerieFire";
				callback= function(button)
					if not IsAddOnLoaded("SimpleTranqShot") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("SimpleTranqShot"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("SimpleTranqShot");
					end
					SlashCmdList["SIMPLETRANQ"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("tradeDispenser");
if title ~= nil and class == "MAGE" then
	if GetLocale() == "zhCN" then
		FF_NametradeDispenser	= "法师自动售货机";
		FF_DesctradeDispenser = "自动售货机，能够实现自动交易";
	elseif GetLocale() == "zhTW" then
		FF_NametradeDispenser = "法师自动售货机";
		FF_DesctradeDispenser	= "自动售货机，能够实现自动交易";
	else
		FF_NametradeDispenser	= "tradeDispenser";
		FF_DesctradeDispenser	= "Automaticly dispenses specified items to anyone who wants to trades with you";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "tradeDispenser";
				tab= "class";
				name= FF_NametradeDispenser;
				subtext= "tradeDispenser";
				tooltip = FF_DesctradeDispenser;
				icon= "Interface\\Icons\\INV_Misc_Food_37";
				callback= function(button)
					if not IsAddOnLoaded("tradeDispenser") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("tradeDispenser"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("tradeDispenser");
					end
					SlashCmdList["TRADE_DISPENSER"]("config");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("WarriorHUD");
if title ~= nil and class == "WARRIOR" then
	if GetLocale() == "zhCN" then
		FF_NameWarriorHUD	= "技能触发监视";
		FF_DescWarriorHUD= "监视并高亮战士压制、斩杀的技能触发";
	elseif GetLocale() == "zhTW" then
		FF_NameWarriorHUD = "技能触发监视";
		FF_DescWarriorHUD	= "监视并高亮战士压制、斩杀的技能触发";
	else
		FF_NameWarriorHUD	= "WarriorHUD";
		FF_DescWarriorHUD	= "a HUD especially for Warriors. Displays the amount of rage,warrior cooldowns and alerts overpower usability.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "WarriorHUD";
				tab= "class";
				name= FF_NameWarriorHUD;
				subtext= "WarriorHUD";
				tooltip = FF_DescWarriorHUD;
				icon= "Interface\\Icons\\INV_Sword_48";
				callback= function(button)
					if not IsAddOnLoaded("WarriorHUD") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("WarriorHUD"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("WarriorHUD");
					end
					SlashCmdList["WHUD"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("TankBuddyEnh");
if title ~= nil and class == "WARRIOR" then
	if GetLocale() == "zhCN" then
		FF_NameTankBuddyEnh	= "MT助手";
		FF_DescTankBuddyEnh= "当战士的嘲讽、惩戒痛击被抵抗向队伍/团队发送消息；破斧、盾墙、生命宝石、群嘲开启后向队伍/团队发送消息";
	elseif GetLocale() == "zhTW" then
		FF_NameTankBuddyEnh = "MT助手";
		FF_DescTankBuddyEnh	= "当战士的嘲讽、惩戒痛击被抵抗向队伍/团队发送消息；破斧、盾墙、生命宝石、群嘲开启后向队伍/团队发送消息";
	else
		FF_NameTankBuddyEnh	= "TankBuddyEnh";
		FF_DescTankBuddyEnh	= "Notices Party/Raid members when you use last stand, challenging shout/roar, shield wall, lifegiving gem or when your taunt/growl/mocking blow fails. It can also remove chosen buffs automatically, either always or only in defensive stance/bear form.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "TankBuddyEnh";
				tab= "class";
				name= FF_NameTankBuddyEnh;
				subtext= "TankBuddyEnh";
				tooltip = FF_DescTankBuddyEnh;
				icon= "Interface\\Icons\\Ability_Warrior_ShieldWall";
				callback= function(button)
					if not IsAddOnLoaded("TankBuddyEnh") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("TankBuddyEnh"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("TankBuddyEnh");
					end
					SlashCmdList["TBSLASH"]("");
				end;
			}
		);
	end
end

local _, title = GetAddOnInfo("CompactComboBar");
if title ~= nil and (class == "ROGUE"or class == "DRUID") then
	if GetLocale() == "zhCN" then
		FF_NameCompactComboBar	= "连击点和能量监视";
		FF_DescCompactComboBar = "连击点/能量监视，调用命令 /ccb";
	elseif GetLocale() == "zhTW" then
		FF_NameCompactComboBar = "连击点和能量监视";
		FF_DescCompactComboBar	= "连击点/能量监视，调用命令 /ccb";
	else
		FF_NameCompactComboBar	= "CompactComboBar";
		FF_DescCompactComboBar	= "Adds a window displaying combo points, a target health bar, a target mana bar, an energy bar and a health bar.";
	end
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
			{
				id= "CompactComboBar";
				tab= "class";
				name= FF_NameCompactComboBar;
				subtext= "CompactComboBar";
				tooltip = FF_DescCompactComboBar;
				icon= "Interface\\Icons\\Ability_Rogue_KidneyShot";
				callback= function(button)
					if not IsAddOnLoaded("CompactComboBar") then
						CtrlPanel_ChatPrint(Msg01);
						EnableAddOn("CompactComboBar"); -- Make sure it wasn't left disabled for whatever reason
						LoadAddOn("CompactComboBar");
					end
					SlashCmdList["COMPACTCOMBOBARCOMMAND"]("");
				end;
			}
		);
	end
end

-- 备用插件调用

-- local _, title = GetAddOnInfo("CensusPlus");
-- if title ~= nil then
	-- if GetLocale() == "zhCN" then
		-- FF_NameCensusPlus	= "阵营人口普查分布";
		-- FF_DescCensusPlus	= "查询当前服务器你的阵营的人口分布，职业，公会，种族，非常详细的数据。";
	-- elseif GetLocale() == "zhTW" then
		-- FF_NameCensusPlus	= "陣營人口普查分佈";
		-- FF_DescCensusPlus	= "查询当前服务器你的阵营的人口分布，职业，公会，种族，非常详细的数据。";
	-- else
		-- FF_NameCensusPlus	= "CensusPlus";
		-- FF_DescCensusPlus	= "Collects and displays census information. This AddOn is licenced under the GNU GPL, see GPL.txt for details.";
	-- end
	-- if ( EarthFeature_AddButton ) then
		-- EarthFeature_AddButton(
			-- {
				-- id= "CensusPlus";
				-- tab= "ui";
				-- name= FF_NameCensusPlus;
				-- subtext= "CensusPlus";
				-- tooltip = FF_DescCensusPlus;
				-- icon= "Interface\\Icons\\INV_Helmet_02";
				-- callback= function(button)
					-- if not IsAddOnLoaded("CensusPlus") then
						-- CtrlPanel_ChatPrint(Msg01);
						-- EnableAddOn("CensusPlus"); -- Make sure it wasn't left disabled for whatever reason
						-- LoadAddOn("CensusPlus");
					-- end
					-- CensusPlus_Toggle();
				-- end;
			-- }
		-- );
	-- end
-- end

-- local _, title = GetAddOnInfo("UnitFramesImproved_Vanilla");
-- if title ~= nil then
	-- if GetLocale() == "zhCN" then
		-- FF_NameUFI	= "头像框架增强";
		-- FF_DescUFI	= "默认头像框架增强";
	-- elseif GetLocale() == "zhTW" then
		-- FF_NameUFI	= "头像框架增强";
		-- FF_DescUFI	= "默认头像框架增强";
	-- else
		-- FF_NameUFI	= "UnitFramesImproved_Vanilla";
		-- FF_DescUFI	= "Aims to keep the beauty of the original unitframes but with QoL improvements. Based on UnitFramesImproved from Legion.";
	-- end
	-- if ( EarthFeature_AddButton ) then
		-- EarthFeature_AddButton(
			-- {
				-- id= "UnitFramesImproved_Vanilla";
				-- tab= "ui";
				-- name= FF_NameUFI;
				-- subtext= "UnitFramesImproved_Vanilla";
				-- tooltip = FF_DescUFI;
				-- icon= "Interface\\AddOns\\!!GardenCenter\\icon\\UFP";
				-- callback= function(button)
					-- if not IsAddOnLoaded("UnitFramesImproved_Vanilla") then
						-- CtrlPanel_ChatPrint(Msg01);
						-- EnableAddOn("UnitFramesImproved_Vanilla"); -- Make sure it wasn't left disabled for whatever reason
						-- LoadAddOn("UnitFramesImproved_Vanilla");
					-- end
					-- SlashCmdList['UFI_OPTIONS']("");
				-- end;
			-- }
		-- );
	-- end
-- end

