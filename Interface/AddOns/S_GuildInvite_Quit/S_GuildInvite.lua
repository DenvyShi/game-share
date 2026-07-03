--刷新
WhoFrameWhoButton:SetWidth(WhoFrame:GetWidth()/4.7)
WhoFrameWhoButton:ClearAllPoints()
WhoFrameWhoButton:SetPoint("BOTTOMRIGHT", WhoFrame, -285, 82)

--添加好友
WhoFrameAddFriendButton:SetWidth(WhoFrame:GetWidth()/4.7)
WhoFrameAddFriendButton:ClearAllPoints()
WhoFrameAddFriendButton:SetPoint("LEFT", WhoFrameWhoButton, "RIGHT", 0, 0)

--组队邀请
WhoFrameGroupInviteButton:SetWidth(WhoFrame:GetWidth()/4.7)
WhoFrameGroupInviteButton:ClearAllPoints()
WhoFrameGroupInviteButton:SetPoint("LEFT", WhoFrameAddFriendButton, "RIGHT", 0, 0)

--工会邀请
WhoFrameGuildInviteButton = CreateFrame("Button", "WhoFrameGuildInviteButton", WhoFrame, "UIPanelButtonTemplate")
WhoFrameGuildInviteButton:SetWidth(WhoFrame:GetWidth()/4.7)
WhoFrameGuildInviteButton:SetHeight(22)
WhoFrameGuildInviteButton:SetText(GUILD..CHAT_INVITE_SEND)
WhoFrameGuildInviteButton:SetFont(STANDARD_TEXT_FONT, 14)
WhoFrameGuildInviteButton:SetPoint("LEFT", WhoFrameGroupInviteButton, "RIGHT", 0, 0)
WhoFrameGuildInviteButton:SetScript("OnUpdate", function()
	local numWhos, totalCount = GetNumWhoResults()
	if CanGuildInvite() and totalCount > 1 then
		this:Enable()
	else 
		this:Disable()
	end
end)

WhoFrameGuildInviteButton:SetScript("OnClick", function()
	for i=1, GetNumWhoResults() do
		GuildInviteByName(GetWhoInfo(i)) 
	end 
end)