--默认立即显示任务文本
QUEST_FADING_DISABLE = "1"

UIPanelWindows["QuestLogFrame"] = {area = "doublewide", pushable = 0, whileDead = 1};

--界面
SetSize(QuestLogFrame, 768, 512)
QuestLogFrame:ClearAllPoints()
QuestLogFrame:SetPoint("TOPLEFT", 0, -104);

--标题
QuestLogTitleText:ClearAllPoints();
QuestLogTitleText:SetPoint("TOP", QuestLogFrame, "TOP", -20, -17);

--列表
SetSize(QuestLogListScrollFrame, 300, 360)
QuestLogListScrollFrame:ClearAllPoints();
QuestLogListScrollFrame:SetPoint("TOPLEFT", QuestLogFrame, 20, -75);

--详情
SetSize(QuestLogDetailScrollFrame, 300, 380)
QuestLogDetailScrollFrame:ClearAllPoints();
QuestLogDetailScrollFrame:SetPoint("TOPLEFT", QuestLogListScrollFrame, "TOPRIGHT", 27, 0);

--关闭
QuestLogFrameCloseButton:ClearAllPoints()
QuestLogFrameCloseButton:SetPoint("TOPRIGHT", QuestLogFrame, "TOPRIGHT", -86, -8);

--数量
QuestLogCountRight:ClearAllPoints()
QuestLogCountRight:SetPoint("TOPRIGHT", QuestLogFrame, -105, -41);

--放弃
QuestLogFrameAbandonButton:ClearAllPoints();
QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 17, 54);

--共享
QuestFramePushQuestButton:ClearAllPoints();
QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", -2, 0);

--退出
QuestFrameExitButton:ClearAllPoints();
QuestFrameExitButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", 2, 0);

--没有正在进行的任务
QuestLogNoQuestsText:ClearAllPoints();
QuestLogNoQuestsText:SetPoint("TOP", QuestLogListScrollFrame, 0, -90);

--创建其他行
local oldQuestsDisplayed = QUESTS_DISPLAYED;
QUESTS_DISPLAYED = QUESTS_DISPLAYED + 17;

for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
    local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate");
    button:SetID(i);
    button:Hide();
    button:ClearAllPoints();
    button:SetPoint("TOPLEFT", getglobal("QuestLogTitle" .. (i-1)), "BOTTOMLEFT", 0, 1);
end

--隐藏原本的任务框架材质
local regions = {QuestLogFrame:GetRegions()}

local textures = {
    TopLeft = "Interface\\AddOns\\QuestFrame\\UI-QuestGreeting-TopLeft";
    TopRight = "Interface\\AddOns\\QuestFrame\\UI-QuestGreeting-TopRight";
    BotLeft = "Interface\\AddOns\\QuestFrame\\UI-QuestGreeting-BotLeft";
    BotRight = "Interface\\AddOns\\QuestFrame\\UI-QuestGreeting-BotRight";
}

local PATTERN = "^Interface\\QuestFrame\\UI%-QuestLog%-(([A-Z][a-z]+)([A-Z][a-z]+))$";
for _, region in ipairs(regions) do
    if (region:IsObjectType("Texture")) then
        local texturefile = region:GetTexture();
        local which = string.match(texturefile, PATTERN);
        if (textures[which]) then
            region:Hide()
        end
    end
end

local QuestLogLeft = QuestLogFrame:CreateTexture(nil, "ARTWORK")
SetSize(QuestLogLeft, 512, 512)
QuestLogLeft:SetPoint("TOPLEFT", QuestLogFrame, 0, 0)
QuestLogLeft:SetTexture("Interface\\QuestFrame\\UI-QuestLog-Left")

local QuestLogRight = QuestLogFrame:CreateTexture(nil, "ARTWORK")
SetSize(QuestLogRight, 256, 512)
QuestLogRight:SetPoint("TOPRIGHT", QuestLogFrame, 0, 0)
QuestLogRight:SetTexture("Interface\\QuestFrame\\UI-QuestLog-Right")

local txset = {EmptyQuestLogFrame:GetRegions()}
for _, t in ipairs(txset) do
    if (t:IsObjectType("Texture")) then
        local p = t:GetTexture();
        if (type(p) == "string") then
            p = string.match(p, "-([^-]+)$");
            if (p) then
                t:Hide();
            end
        end
    end
end

--任务等级显示
Orig_GetQuestLogTitle = GetQuestLogTitle
function New_GetQuestLogTitle(questIndex)
	local questLogTitleText, oldLevel, questTag, isHeader, isCollapsed, isComplete = Orig_GetQuestLogTitle(questIndex)
	local level = oldLevel
	if ( not isHeader and level ) then
		if ( questLogTitleText ) then
			questLogTitleText = " [" .. ( level or "??" ) .. ( questTag and "+" or "") .. "] " .. questLogTitleText
		end
	end
	return questLogTitleText, oldLevel, questTag, isHeader, isCollapsed, isComplete
end
GetQuestLogTitle = New_GetQuestLogTitle

if pfQuest then
	local S_pfQuestTrackButton = CreateFrame("Button", "S_pfQuestTrackButton", QuestLogFrame, "UIPanelButtonTemplate")
	SetSize(S_pfQuestTrackButton, 130, 25)
	S_pfQuestTrackButton:SetFont(STANDARD_TEXT_FONT, 14)
	S_pfQuestTrackButton:SetPoint("LEFT", "QuestLogTrackTitle", "RIGHT", 15, 0)	
	S_pfQuestTrackButton:SetText("显示|cff33ffccpf|cffffffffQuest|r任务追踪")

	S_pfQuestTrackButton:SetScript("OnMouseDown", function()
		SlashCmdList["PFDB"]("tracker")
	end)
	
	local f = CreateFrame("Frame")
	f:SetScript("OnUpdate", function()
		if pfQuestMapTracker:IsShown() then
			S_pfQuestTrackButton:Hide()
		else
			S_pfQuestTrackButton:Show()
		end
	end)
end

