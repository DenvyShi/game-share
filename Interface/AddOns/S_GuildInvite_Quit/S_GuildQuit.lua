--公会信息
GuildFrameGuildInformationButton:SetWidth(GuildFrame:GetWidth()/4.7)
GuildFrameGuildInformationButton:ClearAllPoints()
GuildFrameGuildInformationButton:SetPoint("BOTTOMRIGHT", GuildFrame, -285, 82)

--添加成员
GuildFrameAddMemberButton:SetWidth(GuildFrame:GetWidth()/4.7)
GuildFrameAddMemberButton:ClearAllPoints()
GuildFrameAddMemberButton:SetPoint("LEFT", GuildFrameGuildInformationButton, "RIGHT", 0, 0)

--公会控制
GuildFrameControlButton:SetWidth(GuildFrame:GetWidth()/4.7)
GuildFrameControlButton:ClearAllPoints()
GuildFrameControlButton:SetPoint("LEFT", GuildFrameAddMemberButton, "RIGHT", 0, 0)

--退出公会
GuildFrameQuitButton = CreateFrame("Button", "GuildFrameQuitButton", GuildFrame, "UIPanelButtonTemplate")
GuildFrameQuitButton:SetWidth(GuildFrame:GetWidth()/4.7)
GuildFrameQuitButton:SetHeight(22)
GuildFrameQuitButton:SetText(QUIT..GUILD)
GuildFrameQuitButton:SetFont(STANDARD_TEXT_FONT, 14)
GuildFrameQuitButton:SetPoint("LEFT", GuildFrameControlButton, "RIGHT", 0, 0)
GuildFrameQuitButton:SetScript("OnClick", function()
	local guildName = GetGuildInfo("player")
	StaticPopupDialogs["QuitGuild"] = {
		text = "是否退出"..guildName.."?",
		button1 = TEXT(ACCEPT),
		button2 = TEXT(CANCEL),
		OnAccept = function()
			GuildLeave()
		end,
		timeout = 0,
		hideOnEscape = 1
	}
	StaticPopup_Show("QuitGuild")
end)