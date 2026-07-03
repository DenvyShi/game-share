-- FastQuest
-- Original Author: Vashen (Vashen@msn.com)
-- Original AddOn Site: http://www.curse-gaming.com/en/wow/addons-812-1-fastquest.html
--
-- New version maintained by: Arith Hsu, since version 2.11
-- http://www.curse-gaming.com/en/wow/addons-4691-1-fastquest-continue.html
-- Latest Version: 2.11.3 (2006/09/05)

-- FastQuest
-- 2023-07-31 by 夜晨
-- 增加设置界面UI （命令  /fq )
-- 修改播报方式,改为自动根据所在队伍情况,在 说、队伍、团队频道中播报进度
-- 2023-08-05
-- 将idQuestAutomation自动交接任务插件合并到此文件中,同时修复背包位置不够时自动交任务卡住的情况。


-- 下载地址  http://jilinge2.ysepan.com/


hQuestLog_Update = QuestLog_Update;
hQuestWatch_Update = QuestWatch_Update;

local player = "DEFAULT";
local Formats = {};
Formats[0] = FQ_FORMAT0;
Formats[1] = FQ_FORMAT1;
Formats[2] = FQ_FORMAT2;
Formats[3] = FQ_FORMAT3;

-- Number of the format styles
local nFormats = 4;

local CHATTYPE = "SAY";

local EPA_TestPatterns =
{
	FQ_EPA_PATTERN1,
	FQ_EPA_PATTERN2,
	FQ_EPA_PATTERN3,
	FQ_EPA_PATTERN4,
	FQ_EPA_PATTERN5,
	FQ_EPA_PATTERN6,
	FQ_EPA_PATTERN7,
};

function FastQuest_SlashCmd(msg)
	if (msg) then
		local cmd = gsub(msg, "%s*([^%s]+).*", "%1");
		cmd = string.lower(cmd);
		local info = FQ_INFO;
		if (cmd == "tag") then
			info = (info .. FQ_INFO_QUEST_TAG);
			FQD[player].Tag = FastQuest_ToggleBoolean(FQD[player].Tag, info);
			QuestLog_Update();
			QuestWatch_Update();
			return;
			--
			-- WOW 1.12 now supported player to set an option just like this one, quest will be auto added into QueustTracker window.
			-- I am considering to remove below codes, but let's just remark them for a while.
		elseif (cmd == "autoadd") then
			info = (info .. FQ_INFO_AUTOADD);
			FQD.AutoAdd = FastQuest_ToggleBoolean(FQD.AutoAdd, info);
			return;
			--[[
		-- Auto Notify the party members regarding to your quest progress
		elseif( cmd == "autonotify" ) then
			info = (info..FQ_INFO_AUTONOTIFY);
			FQD.AutoNotify=FastQuest_ToggleBoolean(FQD.AutoNotify,info);
			FQD.AlwaysNotify=FQD.AutoNotify;
			return;
		
		-- Allow to notify the guild members regarding to your quest progress
		elseif( cmd == "allowguild" ) then
			info = (info..FQ_INFO_ALLOWGUILD);
			FQD.AllowGuild=FastQuest_ToggleBoolean(FQD.AllowGuild,info);
			return;
		-- Allow to notify the raid members regarding to your quest progress
		elseif( cmd == "allowraid" ) then
			info = (info..FQ_INFO_ALLOWRAID);
			FQD.AllowRaid=FastQuest_ToggleBoolean(FQD.AllowRaid,info);
			return; ]]
		elseif (cmd == "autoquest") then
			info = (info .. FQ_INFO_AUTOQUEST);
			FQD.AutoQuest = FastQuest_ToggleBoolean(FQD.AutoQuest, info);
			return;
			-- Always notify your quest progress
		elseif (cmd == "alwaysnotify") then
			info = (info .. FQ_INFO_ALWAYSNOTIFY);
			FQD.AlwaysNotify = FastQuest_ToggleBoolean(FQD.AlwaysNotify, info);
			if FQD.AlwaysNotify == false then
				FQD.Detail = false
				FastQuest_Config_SetButtonState(FQD.Detail, 2);
			end
			return;
			-- Allow to notify your detail quest progress
		elseif (cmd == "detail") then
			info = (info .. FQ_INFO_DETAIL);
			FQD.Detail = FastQuest_ToggleBoolean(FQD.Detail, info);
			if FQD.Detail then
				FQD.AlwaysNotify = true
				FastQuest_Config_SetButtonState(FQD.AlwaysNotify, 1);
			end
			return;
			-- Lock the QuestTracker window
		elseif (cmd == "lock") then
			if FQD.NoDrag == false then
				if FQD.IsReload then
					qOut(info .. FQ_INFO_LOCK);
					FQD.Lock = true;
					FastQuest_LockMovableParts();
				else
					qOut("请重置UI再进行此操作")
				end
			else
				qOut(FQ_ERROR_NEEDRELOADUI)
			end
			return;
			-- Unlock the QuestTracker
		elseif (cmd == "unlock") then
			if FQD.NoDrag == false then
				if FQD.IsReload then
					qOut(info .. FQ_INFO_UNLOCK);
					FQD.Lock = false;
					FastQuest_LockMovableParts();
				else
					qOut("请重置UI再进行此操作")
				end
			else
				qOut(FQ_ERROR_NEEDRELOADUI)
			end
			return;
		elseif (cmd == "nodrag") then
			if FQD.IsReload == false then
				qOut("请重置UI再进行此操作")
				return;
			end
			FQD.IsReload = false;
			info = (info .. FQ_INFO_NODRAG);
			FQD.NoDrag = FastQuest_ToggleBoolean(FQD.NoDrag, info);
			if (FQD.NoDrag == false) then
				FQD.Lock = true;
			end
			FastQuest_LockMovableParts()
			qOut(FQ_MUST_RELOAD);
			-- FastQuest_ReloadUI()
			return;
			-- Reset the QuestTracker window's position to default
		elseif (cmd == "reset") then
			if FQD.NoDrag == false then
				if FQD.IsReload then
					qOut(info .. FQ_INFO_RESET);
					FastQuestFrame:SetPoint("CENTER", "UIParent", "TOPRIGHT", 100, 0);
					dQuestWatchDragButton:SetPoint("TOPLEFT", "UIParent", "TOPRIGHT", -250, -250);
				else
					qOut("请重置UI再进行此操作")
				end
			else
				qOut(FQ_ERROR_NEEDRELOADUI)
			end
			return;
		elseif (cmd == "format") then
			if (FQD[player].Format == nil) then FQD[player].Format = 1; end
			if (FQD[player].Format == (nFormats - 1)) then
				FQD[player].Format = 0;
			else
				FQD[player].Format = FQD[player].Format + 1;
			end
			--qOut(info..FQ_INFO_FORMAT);
			qOut(info .. FQ_INFO_DISPLAY_AS .. Formats[FQD[player].Format]);
			return;
		elseif (cmd == "clear") then
			qOut(info .. FQ_INFO_CLEAR);
			for i = GetNumQuestWatches(), 1, -1 do
				local qID = GetQuestIndexForWatch(i)
				FQD[player].tQuests[i] = " ";
				RemoveQuestWatch(qID);
			end
			FQD[player].nQuests = 0;
			QuestWatch_Update();
			return;
		elseif (cmd == "color") then
			info = (info .. FQ_INFO_COLOR);
			FQD.Color = FastQuest_ToggleBoolean(FQD.Color, info);
			return
		elseif (cmd == "sound") then
			info = (info .. FQ_INFO_SOUND);
			FQD.Sound = FastQuest_ToggleBoolean(FQD.Sound, info);
			return
		elseif (cmd == "status") then
			qOut("|cfffffffffq autoadd      - " .. FastQuest_ShowBoolean(FQD.AutoAdd));
			qOut("|cfffffffffq autoquest - " .. FastQuest_ShowBoolean(FQD.AutoQuest));
			-- qOut("|cfffffffffq autonotify   - "..FastQuest_ShowBoolean(FQD.AutoNotify));
			-- qOut("|cfffffffffq allowguild   - "..FastQuest_ShowBoolean(FQD.AllowGuild));
			qOut("|cfffffffffq allowraid    - " .. FastQuest_ShowBoolean(FQD.AllowRaid));
			qOut("|cfffffffffq alwaysnotify - " .. FastQuest_ShowBoolean(FQD.AlwaysNotify));
			qOut("|cfffffffffq color        - " .. FastQuest_ShowBoolean(FQD.Color));
			qOut("|cfffffffffq detail       - " .. FastQuest_ShowBoolean(FQD.Detail));
			qOut("|cfffffffffq lock(unlock) - " .. FastQuest_ShowLock(FQD.Lock));
			qOut("|cfffffffffq nodrag       - " .. FastQuest_ShowBoolean(FQD.NoDrag));
			qOut("|cfffffffffq tag          - " .. FastQuest_ShowBoolean(FQD[player].Tag));
			qOut("|cfffffffffq sound        - " .. FastQuest_ShowBoolean(FQD.Sound));
			return;
		elseif (cmd == "help") then
			qOut(info .. FQ_INFO_USAGE);
			qOut("|cffffffff/fq autoadd      - " .. FQ_USAGE_AUTOADD);
			qOut("|cffffffff/fq autoquest - " .. FQ_USAGE_AUTOQUEST);
			-- qOut("|cffffffff/fq autonotify   - "..FQ_USAGE_AUTONOTIFY);
			-- qOut("|cffffffff/fq allowguild   - "..FQ_USAGE_ALLOWGUILD);
			-- qOut("|cffffffff/fq allowraid    - "..FQ_USAGE_ALLOWRAID);
			qOut("|cffffffff/fq alwaysnotify - " .. FQ_USAGE_ALWAYSNOTIFY);
			qOut("|cffffffff/fq clear        - " .. FQ_USAGE_CLEAR);
			qOut("|cffffffff/fq color        - " .. FQ_USAGE_COLOR);
			qOut("|cffffffff/fq detail       - " .. FQ_USAGE_DETAIL);
			qOut("|cffffffff/fq format       - " .. FQ_USAGE_FORMAT);
			qOut("|cffffffff/fq lock(unlock) - " .. FQ_USAGE_LOCK);
			qOut("|cffffffff/fq nodrag       - " .. FQ_USAGE_NODRAG);
			qOut("|cffffffff/fq reset        - " .. FQ_USAGE_RESET);
			qOut("|cffffffff/fq status       - " .. FQ_USAGE_STATUS);
			qOut("|cffffffff/fq tag          - " .. FQ_USAGE_TAG);
			qOut("|cffffffff/fq sound        - " .. FQ_USAGE_SOUND);
			return;
		else
			ShowUIPanel(FastQuestFrame);
		end
	end
end

BINDING_CATEGORY_FASTQUEST       = FQ_BINDING_CATEGORY_FASTQUEST;
BINDING_HEADER_FASTQUEST         = FQ_BINDING_HEADER_FASTQUEST;
BINDING_NAME_FASTQUEST_T         = FQ_BINDING_NAME_FASTQUEST_T;
BINDING_NAME_FASTQUEST_F         = FQ_BINDING_NAME_FASTQUEST_F;
BINDING_NAME_FASTQUEST_AOUTP     = FQ_BINDING_NAME_FASTQUEST_AOUTP;
BINDING_NAME_FASTQUEST_AOUTC     = FQ_BINDING_NAME_FASTQUEST_AOUTC;
BINDING_NAME_FASTQUEST_AOUTA     = FQ_BINDING_NAME_FASTQUEST_AOUTA;
BINDING_NAME_FASTQUEST_NOHEADERS = FQ_BINDING_NAME_FASTQUEST_NOHEADERS;

function FastQuest_Tag()
	info = FQ_INFO_QUEST_TAG;
	FQD[player].Tag = FastQuest_ToggleBoolean(FQD[player].Tag, info);
	QuestLog_Update();
	QuestWatch_Update();
end

function FastQuest_ReloadUI()
	ReloadUI();
end

function FastQuest_Format()
	if (FQD[player].Format == nil) then FQD[player].Format = 1; end
	if (FQD[player].Format == (nFormats - 1)) then
		FQD[player].Format = 0;
	else
		FQD[player].Format = FQD[player].Format + 1;
	end
	qOut(FQ_SELECT_FORMAT);
	qOut(FQ_INFO_DISPLAY_AS .. Formats[FQD[player].Format]);
end

function FastQuest_CheckPatterns(message)
	if (FQD.Detail == false) then
		return;
	end
	-- 2006/08/21: If AutoNotify is set to fales, then the party members should not be norified.
	-- if (FQD.AutoNotify==false) then
	-- 	return;
	-- end
	if (FQD.AlwaysNotify == false) then
		return;
	end
	for index, value in EPA_TestPatterns do
		if (string.find(message, value)) then
			FastQuest_CheckDefaultChat();
			--SendChatMessage(message.."　　", DEFAULT_CHAT_FRAME.editBox.chatType);
			SendChatMessage(message .. "　　", CHATTYPE);
			break;
		end
	end
end

function FastQuest_OnLoad()
	-- Register for events
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UI_INFO_MESSAGE");
	this:RegisterEvent("QUEST_PROGRESS");
	this:RegisterEvent("QUEST_COMPLETE");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("ADDON_LOADED");


	--------------------------------
	this:RegisterEvent('GOSSIP_SHOW')
	this:RegisterEvent('QUEST_DETAIL')
	this:RegisterEvent('QUEST_GREETING')
	this:RegisterEvent('QUEST_LOG_UPDATE')

	--------------------------------

	SLASH_FQ1 = "/fastquest";
	SLASH_FQ2 = "/fq";
	SlashCmdList["FQ"] = FastQuest_SlashCmd;
	qOut(FQ_LOADED);
end

function FastQuest_OnEvent(event, message)
	-- if	((event == "QUEST_PROGRESS") and (FQD.AutoQuest==true)) then
	-- 		CompleteQuest();
	-- elseif	((event == "QUEST_COMPLETE") and (FQD.AutoQuest==true)) then
	-- 	if (GetNumQuestChoices() == 0) then
	-- 		GetQuestReward(QuestFrameRewardPanel.itemChoice);
	-- 	end
	-- else
	if (event == "VARIABLES_LOADED") then
		-- initialize all the default options parameters
		if (FQD == nil) then
			FQD = {};
		end
		if (FQD.AutoQuest == nil) then
			FQD.AutoQuest = true;
		end
		-- if (FQD.AutoNotify == nil) then
		-- 	FQD.AutoNotify = true;
		-- end
		-- if (FQD.AllowGuild == nil) then
		-- 	FQD.AllowGuild = false;
		-- end
		-- if (FQD.AllowRaid == nil) then
		-- 	FQD.AllowRaid = false;
		-- end
		if (FQD.AlwaysNotify == nil) then
			FQD.AlwaysNotify = true;
		end
		if (FQD.Detail == nil) then
			FQD.Detail = true;
		end
		if (FQD.Sound == nil) then
			FQD.Sound = false;
		end
		if (FQD.Color == nil) then
			FQD.Color = false;
		end
		if (FQD.AutoAdd == nil) then
			FQD.AutoAdd = false;
		end
		if (FQD.Lock == nil) then
			FQD.Lock = true;
		end
		if (FQD.NoDrag == nil) then
			FQD.NoDrag = false;
		end

		FQD.IsReload = true;

		UpdatePlayer();

		if (FQD[player].Format == nil) then
			FQD[player].Format = 2;
		end
		if (FQD[player].Tag == nil) then
			FQD[player].Tag = false;
		end
		FastQuest_Config_OnLoad();

		FastQuest_LinkFrame(dQuestWatchDragButton:GetName(), QuestWatchFrame:GetName(), "RIGHT");
		FastQuest_LockMovableParts();
	elseif (event == "UI_INFO_MESSAGE" and message) then
		local uQuestText = gsub(message, "(.*)：%s*([-%d]+)%s*/%s*([-%d]+)%s*$", "%1", 1);
		if (uQuestText ~= message) then
			if (FQD.AlwaysNotify == true) then
				FastQuest_CheckDefaultChat();
				SendChatMessage(FQ_QUEST_PROGRESS .. message, CHATTYPE);
			end
			-- 游戏已经可以自动设置自动添加任务追踪
			if (FQD.AutoAdd == true and GetNumQuestWatches() < MAX_WATCHABLE_QUESTS) then
				local qID = FastQuest_GetQuestID(uQuestText);
				if (qID) then
					if (not IsQuestWatched(qID)) then
						FastQuest_Watch(qID, true);
					end
				end
			end
		else
			FastQuest_CheckPatterns(message);
		end
	elseif (event == "CHAT_MSG_SYSTEM" and message) then
		FastQuest_CheckPatterns(message);
	elseif (event == "QUEST_PROGRESS" and (FQD.AutoQuest==true)) then
		FastQuest_ClickCompleteButton()
	elseif (event == "QUEST_LOG_UPDATE" and (FQD.AutoQuest==true)) then
		FastQuest_SelectQuestLogEntry()
	elseif (event == "QUEST_GREETING" and (FQD.AutoQuest==true)) then
		FastQuest_ClickQuestTitleButton()
	elseif (event == "QUEST_DETAIL" and (FQD.AutoQuest==true)) then
		FastQuest_AcceptQuest()
	elseif (event == "GOSSIP_SHOW" and (FQD.AutoQuest==true)) then
		FastQuest_ClickGossipTitleButton()
	elseif (event == "QUEST_COMPLETE" and (FQD.AutoQuest==true)) then
		FastQuest_CompleteQuest()
	end
end

function QuestLogTitleButton_OnClick(button)
	local qIndex = this:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame);
	local qTitle, qLevel, qTag, isHeader, isCollapsed = GetQuestLogTitle(qIndex);
	if (button == "LeftButton") then
		QuestLog_SetSelection(qIndex);
		if (IsShiftKeyDown() and ChatFrameEditBox:IsVisible()) then
			if (FQD[player].Format == 1) then
				ChatFrameEditBox:Insert("[" .. qLevel .. "] " .. qTitle .. " ");
			elseif (FQD[player].Format == 0) then
				ChatFrameEditBox:Insert(" " .. qTitle .. " ");
			elseif (FQD[player].Format == 2) then
				if (qTag) then qTag = "+" else qTag = ""; end
				ChatFrameEditBox:Insert("[" .. qLevel .. qTag .. "] " .. qTitle .. " ");
			elseif (FQD[player].Format == 3) then
				if (qTag) then qTag = (" (" .. qTag .. ")  ") else qTag = ""; end
				ChatFrameEditBox:Insert("[" .. qLevel .. "] " .. qTitle .. qTag);
			else
				FQD[player].Format = 1;
			end
		elseif (IsShiftKeyDown()) then
			FastQuest_Watch(qIndex, false);
		elseif (IsControlKeyDown()) then
			FastQuest_CheckDefaultChat();
			if (FQD[player].Format == 1) then
				SendChatMessage("[" .. qLevel .. "] " .. qTitle, CHATTYPE, GetDefaultLanguage());
			elseif (FQD[player].Format == 0) then
				SendChatMessage(" " .. qTitle .. " ", CHATTYPE, GetDefaultLanguage());
			elseif (FQD[player].Format == 2) then
				if (qTag) then qTag = "+" else qTag = ""; end
				SendChatMessage("[" .. qLevel .. qTag .. "] " .. qTitle, CHATTYPE, GetDefaultLanguage());
			elseif (FQD[player].Format == 3) then
				if (qTag) then qTag = (" (" .. qTag .. ")  ") else qTag = ""; end
				SendChatMessage("[" .. qLevel .. "] " .. qTitle .. qTag, CHATTYPE, GetDefaultLanguage());
			else
				FQD[player].Format = 1;
			end
			local nObjectives = GetNumQuestLeaderBoards(qIndex);
			if (nObjectives > 0) then
				for i = 1, nObjectives do
					oText, oType, oDone = GetQuestLogLeaderBoard(i, qIndex);
					if (not oText or strlen(oText) == 0 or oText == "") then oText = oType; end
					if (oDone) then
						SendChatMessage("  X " .. oText, CHATTYPE);
					else
						SendChatMessage("  -  " .. oText, CHATTYPE);
					end
				end
			end
		end
		QuestLog_Update();
	elseif (button == "RightButton") then
		if (IsControlKeyDown()) then
			QuestLog_SetSelection(qIndex);
			local qDescription, qObjectives = GetQuestLogQuestText();
			FastQuest_CheckDefaultChat();
			if (qObjectives) then
				if (FQD[player].Format == 1) then
					SendChatMessage("[" .. qLevel .. "] " .. qTitle .. ": " .. qObjectives, CHATTYPE,
						GetDefaultLanguage());
				elseif (FQD[player].Format == 0) then
					SendChatMessage(" " .. qTitle .. " " .. ": " .. qObjectives, CHATTYPE, GetDefaultLanguage());
				elseif (FQD[player].Format == 2) then
					if (qTag) then qTag = "+" else qTag = ""; end
					SendChatMessage("[" .. qLevel .. qTag .. "] " .. qTitle .. ": " .. qObjectives, CHATTYPE,
						GetDefaultLanguage());
				elseif (FQD[player].Format == 3) then
					if (qTag) then qTag = (" (" .. qTag .. ")  ") else qTag = ""; end
					SendChatMessage("[" .. qLevel .. "] " .. qTitle .. qTag .. ": " .. qObjectives, CHATTYPE,
						GetDefaultLanguage());
				else
					FQD[player].Format = 1;
				end
			end
			return;
		end
		FastQuest_Watch(qIndex, false);
	end
end

function QuestLog_Update()
	if (player == "DEFAULT" or FQD[player].tQuests == nil) then UpdatePlayer(); end
	;
	FastQuest_LockMovableParts();
	local nEntries, nQuests = GetNumQuestLogEntries();
	if (GetNumQuestWatches() < 1 and FQD[player].nQuests > 0) then
		for i = 1, nEntries do
			SelectQuestLogEntry(i);
			local qTitle, qLevel, qTag, isHeader, isCollapsed = GetQuestLogTitle(i +
				FauxScrollFrame_GetOffset(QuestLogListScrollFrame));
			for j = 1, FQD[player].nQuests do
				if (qTitle == FQD[player].tQuests[j] and not IsQuestWatched(i)) then
					AddQuestWatch(i);
				end
			end
		end
	end
	hQuestLog_Update();
	for i = 1, QUESTS_DISPLAYED, 1 do
		if (i <= nEntries) then
			local qTitle, qLevel, qTag, isHeader, isCollapsed = GetQuestLogTitle(i +
				FauxScrollFrame_GetOffset(QuestLogListScrollFrame));
			local qLogTitle = getglobal("QuestLogTitle" .. i);
			local qCheck = getglobal("QuestLogTitle" .. i .. "Check");
			qCheck:SetPoint("LEFT", qLogTitle:GetName(), "LEFT", 3, 0);
			FastQuest_ChangeTitle(qLogTitle, qTitle, qLevel, qTag, isHeader, false);
		end
	end
end

function QuestWatch_Update()
	hQuestWatch_Update();
	local qDone; wID = 1; oID = 1; DoneID = -1;
	FQD[player].nQuests = GetNumQuestWatches();
	for i = 1, GetNumQuestWatches() do
		FQD[player].tQuests[i] = " ";
		local qID = GetQuestIndexForWatch(i);
		if (qID) then
			local qTitle, qLevel, qTag, isHeader, isCollapsed = GetQuestLogTitle(qID);
			FQD[player].tQuests[i] = qTitle;
			qLogTitle = getglobal("QuestWatchLine" .. wID);
			FastQuest_ChangeTitle(qLogTitle, qTitle, qLevel, qTag, isHeader, true);
			qDone = true; oID = 1;
			for j = 1, GetNumQuestLeaderBoards(qID) do
				oID = j;
				qLogTitle = getglobal("QuestWatchLine" .. (wID + j));
				local oTitle, oType, oDone = GetQuestLogLeaderBoard(j, qID);
				if (oDone) then
					qLogTitle:SetText("|cFFC0FFCF   X " .. oTitle .. " ");
				else
					qLogTitle:SetText("|cFFFFFFFF   -  " .. oTitle .. " ");
					qDone = false;
				end
			end
			wID = wID + oID + 1;
			if (qDone) then DoneID = qID; end
		end
	end
	if (DoneID > 0) then
		if FQD.Sound then
			PlaySoundFile("sound/interface/igplayerBind.wav");
			print("播放音效")
		end
		UIErrorsFrame:AddMessage("|cff00ffff" .. GetQuestLogTitle(DoneID) .. FQ_QUEST_COMPLETED, 1.0, 1.0, 1.0, 1.0, 2);
		if (FQD.AlwaysNotify == true) then
			FastQuest_CheckDefaultChat();
			SendChatMessage(FQ_QUEST .. " [" .. GetQuestLogTitle(DoneID) .. "] " .. FQ_QUEST_ISDONE, CHATTYPE)
		end
		RemoveQuestWatch(DoneID);
		QuestWatch_Update();
	end
	FQD[player].nQuests = GetNumQuestWatches();
	FastQuest_LockMovableParts();
end

function FastQuest_ChangeTitle(qLogTitle, qTitle, qLevel, qTag, isHeader, Watch)
	local ColorTag = "";
	local DifTag = "";
	if (qTitle and not isHeader) then
		if (qTag and FQD[player].Tag == true) then DifTag = (" (" .. qTag .. ")  "); end
		if (Watch) then
			local cQuestLevel = GetDifficultyColor(qLevel);
			if (FQD.Color == true) then
				ColorTag = string.format("|cff%02x%02x%02x", cQuestLevel.r * 255, cQuestLevel.g * 255,
					cQuestLevel.b * 255);
				qLogTitle:SetText(ColorTag .. " [" .. qLevel .. "] " .. qTitle .. DifTag);
			else
				qLogTitle:SetText(" [" .. qLevel .. "] " .. qTitle .. DifTag);
			end
		else
			qLogTitle:SetText(" [" .. qLevel .. "] " .. qTitle .. "  ");
		end
	end
end

function FastQuest_LinkFrame(dButton, pFrame)
	if (FQD.NoDrag == false) then
		getglobal(pFrame):ClearAllPoints();
		getglobal(pFrame):SetPoint("TOPLEFT", dButton, "TOPRIGHT");
	else
		qOut(FQ_DRAG_DISABLED);
		FQD.Lock = true;
	end
end

function FastQuest_DragFrame(pFrame, mode)
	if (FQD.NoDrag == false) then
		if (mode == 0) then
			pFrame:StartMoving();
		else
			pFrame:StopMovingOrSizing();
		end
	end
end

function qOut(msg)
	if (DEFAULT_CHAT_FRAME and msg) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

function FastQuest_LockMovableParts()
	if (FQD[player].nQuests > 0 and QuestWatchFrame:IsVisible()) then
		if FQD.NoDrag == false then
			if FQD.Lock == false then
				dQuestWatchDragButton:Show();
				getglobal("FastQuestFrameButton1"):SetText("隐藏");
			else
				dQuestWatchDragButton:Hide();
				getglobal("FastQuestFrameButton1"):SetText("显示");
			end
		else
			dQuestWatchDragButton:Hide();
			getglobal("FastQuestFrameButton1"):Hide();
			getglobal("FastQuestFrameButton2"):Hide();
			if FQD.IsReload then
				getglobal("FastQuestFrameButton5"):SetText("自定义追踪位置");
			end
		end
	else
		dQuestWatchDragButton:Hide();
		getglobal("FastQuestFrameButton1"):SetText("显示");
	end
	if FQD.IsReload == false then
		getglobal("FastQuestFrameButton6"):Show();
		getglobal("FastQuestFrameButton1"):Hide();
		getglobal("FastQuestFrameButton2"):Hide();
	end
end

function UpdatePlayer()
	player = UnitName("player");
	if (player == nil or player == UNKNOWNBEING or player == UKNOWNBEING or player == UNKNOWNOBJECT) then
		player = "DEFAULT";
	end
	if (FQD[player] == nil or FQD[player].tQuests == nil) then
		FQD[player] = {
			["Format"] = 1,
			["Tag"] = true,
			["nQuests"] = 0,
			["tQuests"] = {},
		}
		for i = 1, MAX_WATCHABLE_QUESTS, 1 do
			FQD[player].tQuests[i] = " ";
		end
		;
	end
end

function GetDifficultyColor(level)
	local lDiff = level - UnitLevel("player");
	if (lDiff >= 0) then
		for i = 1.00, 0.10, -0.10 do
			color = { r = 1.00, g = i, b = 0.00 };
			if ((i / 0.10) == (10 - lDiff)) then return color; end
		end
	elseif (-lDiff < GetQuestGreenRange()) then
		for i = 0.90, 0.10, -0.10 do
			color = { r = i, g = 1.00, b = 0.00 };
			if ((9 - i / 0.10) == (-1 * lDiff)) then return color; end
		end
	elseif (-lDiff == GetQuestGreenRange()) then
		color = { r = 0.50, g = 1.00, b = 0.50 };
	else
		color = { r = 0.75, g = 0.75, b = 0.75 };
	end
	return color;
end

function FastQuest_Watch(qID, auto)
	if (qID) then
		if ((IsQuestWatched(qID)) and (auto == false)) then
			RemoveQuestWatch(qID);
			QuestWatch_Update();
			QuestLog_Update();
		else
			if ((GetNumQuestLeaderBoards(qID) == 0) and (auto == false)) then
				UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
				return;
			end
			if (GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS) then
				UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0,
					UIERRORS_HOLD_TIME);
				return;
			end
			AddQuestWatch(qID);
			QuestWatch_Update();
			QuestLog_Update();
		end
	end
end

function FastQuest_GetQuestID(str)
	local qSelected = GetQuestLogSelection();
	for i = 1, GetNumQuestLogEntries(), 1 do
		SelectQuestLogEntry(i);
		local qTitle, qLevel, qTag, isHeader, isCollapsed, qComplete = GetQuestLogTitle(i);
		if (qTitle == str) then return i; end
		if (not isHeader) then
			for j = 1, GetNumQuestLeaderBoards() do
				local oText, oType, oDone = GetQuestLogLeaderBoard(j);
				if ((oText == nil) or (oText == "")) then
					oText = oType;
				end
				if (string.find(gsub(oText, "(.*): %d+/%d+", "%1", 1), gsub(str, "(.*): %d+/%d+", "%1", 1))) then
					SelectQuestLogEntry(qSelected);
					return i;
				end
			end
			local qDescription, qObjectives = GetQuestLogQuestText();
			if (string.find(qObjectives, str)) then
				SelectQuestLogEntry(qSelected);
				return i;
			end
		end
	end
	SelectQuestLogEntry(qSelected);
	return nil;
end

function FastQuest_CheckDefaultChat()
	if (GetNumPartyMembers() == 0) then
		CHATTYPE = "SAY";
	else
		if (FQD.AllowRaid == true and GetNumRaidMembers() > 0) then
			CHATTYPE = "RAID";
		else
			CHATTYPE = "PARTY";
		end
	end
end

function FastQuest_ToggleBoolean(bool, msg)
	if (bool == false) then
		qOut(msg .. FQ_ENABLED);
		bool = true;
	else
		qOut(msg .. FQ_DISABLED);
		bool = false;
	end
	return bool;
end

function FastQuest_ShowBoolean(bool)
	if (bool == true) then
		return FQ_ENABLED;
	else
		return FQ_DISABLED;
	end
end

function FastQuest_ShowLock(bool)
	if (bool == true) then
		return FQ_LOCK;
	else
		return FQ_UNLOCK;
	end
end

function FastQuest_Config_OnLoad()
	FastQuest_Config_SetButtonState(FQD.AlwaysNotify, 1); -- 任务通报
	FastQuest_Config_SetButtonState(FQD.Detail, 2);    -- 详细通报
	FastQuest_Config_SetButtonState(FQD.Sound, 3);     -- 音效
	FastQuest_Config_SetButtonState(FQD.Color, 4);     -- 任务难度颜色
	FastQuest_Config_SetButtonState(FQD[player].Tag, 5); -- 任务类型（团队，精英等）
	FastQuest_Config_SetButtonState(FQD.AutoAdd, 6);   -- 自动添加到追踪列表
	FastQuest_Config_SetButtonState(FQD.AutoQuest, 7); -- 自动交接任务
end

function FastQuest_Config_SetButtonState(val, buttonnr)
	if (val == 0 or val == false or val == nil) then
		getglobal("FastQuestFrameCheckButton" .. buttonnr):SetChecked(0);
	else
		getglobal("FastQuestFrameCheckButton" .. buttonnr):SetChecked(1);
	end
end

local FastQuest_completedQuests = {}
local FastQuest_incompleteQuests = {}

function FastQuest_canAutomate()
	if IsShiftKeyDown() then
		return false
	else
		return true
	end
end

function FastQuest_StripText(text)
	if not text then return end
	text = string.gsub(text, '|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
	text = string.gsub(text, '%[.*%]%s*', '')
	text = string.gsub(text, '(.+) %(.+%)', '%1')
	return text
end

function FastQuest_ClickGossipTitleButton()
	if not FastQuest_canAutomate() then return end

	local button
	local text

	for i = 1, 32 do
		button = getglobal('GossipTitleButton' .. i)
		if button:IsVisible() then
			text = FastQuest_StripText(button:GetText())
			if button.type == 'Available' then
				button:Click()
			elseif button.type == 'Active' then
				if FastQuest_completedQuests[text] then
					button:Click()
				end
			end
		end
	end
end

-- 获取背包空格数量
function FastQuest_GetNumEmptyBags()
	local countEmptyBag = 0
	for bagId = 0, 4 do
		for slot = 1, GetContainerNumSlots(bagId) do
			local l = GetContainerItemLink(bagId, slot)
			if l == nil then
				countEmptyBag = countEmptyBag + 1
				if countEmptyBag > 5 then
					break;
				end
			end
		end
	end
	return countEmptyBag
end

function FastQuest_CompleteQuest()

	if not FastQuest_canAutomate() then return end

	-- -- 获取可选奖励数量
	local numQuestChoices = GetNumQuestChoices()

	-- 获取直接奖励物品数量
	local rewardCount = 0
	for i = 1, 10 do
		local questItemLink = GetQuestItemLink("reward", i);
		if questItemLink == nil then
			break;
		end
		rewardCount = i;
	end

	-- 获取背包空格数量
	local countEmptyBag = FastQuest_GetNumEmptyBags()

	if numQuestChoices <= 1 and (countEmptyBag >= (rewardCount + numQuestChoices)) then
		QuestFrameCompleteQuestButton:Click()
	end
end

function FastQuest_AcceptQuest()
	if not FastQuest_canAutomate() then return end
	AcceptQuest()
end

function FastQuest_ClickQuestTitleButton()
	if not FastQuest_canAutomate() then return end

	local button
	local text

	for i = 1, 32 do
		button = getglobal('QuestTitleButton' .. i)
		if button:IsVisible() then
			text = FastQuest_StripText(button:GetText())
			if FastQuest_completedQuests[text] then
				button:Click()
			elseif not FastQuest_incompleteQuests[text] then
				button:Click()
			end
		end
	end
end

function FastQuest_SelectQuestLogEntry()
	if not FastQuest_canAutomate() then return end
	local startEntry = GetQuestLogSelection()
	local numEntries = GetNumQuestLogEntries()
	local title
	local isComplete
	local noObjectives
	local _

	FastQuest_completedQuests = {}
	FastQuest_incompleteQuests = {}

	if numEntries > 0 then
		for i = 1, numEntries do
			SelectQuestLogEntry(i)
			title, _, _, _, _, _, isComplete = GetQuestLogTitle(i)
			noObjectives = GetNumQuestLeaderBoards(i) == 0
			if title then
				if isComplete or noObjectives then
					FastQuest_completedQuests[title] = true
				else
					FastQuest_incompleteQuests[title] = true
				end
			end
		end
	end

	SelectQuestLogEntry(startEntry)
end

function FastQuest_ClickCompleteButton()
	if not FQD.AutoQuest then return end
	if not FastQuest_canAutomate() then return end
	if IsQuestCompletable() then
		CompleteQuest()
	end
end