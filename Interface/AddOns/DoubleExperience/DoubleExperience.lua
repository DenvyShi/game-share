-- ======================双倍经验监控========================
-- 作者: 熊怪
-- 日期: 2023-07-20
-- 版本: 1.0
-- 描述: 显示当前双倍经验的文本和进度条
-- 本插件的开发环境为: WoW 1.12.1
-- ========================================================
-- 是否开启开发模式
local _G_ENV = "PROD"
local Utils = {
	Print = function(text)
		if (_G_ENV == "DEV") then
			DEFAULT_CHAT_FRAME:AddMessage(text)
		end
	end,
	CreactCheckboxFrame = function(self, frameName, parentFrame, options)
		local checkbox = CreateFrame("CheckButton", frameName, parentFrame, "UICheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", options.x, options.y)
		checkbox:SetWidth(options.width)
		checkbox:SetHeight(options.height)
		checkbox:SetScript("OnClick", function()
			if this:GetChecked() then
				options.checked()
			else
				options.unchecked()
			end
		end)
		checkbox:SetChecked(options.isChecked)
		-- 创建复选框的文本
		local text = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		text:SetPoint("LEFT", checkbox, "RIGHT", 10, 0)
		text:SetText(options.text)
		return checkbox
	end,
}


local DoubleExperience = {
	-- 双倍经验窗口
	DoubleXpWindowFrame = nil,
	-- 显示文本
	DoubleXpText = nil,
	-- 进度条
	DoubleXpProgressBar = nil,
	-- 小地图按钮
	MiniMapButton = nil,
	-- 配置窗口
	OptonWindowFrame = nil,
	-- 是否显示配置窗口
	OptonWindowFrameShow = false,
	-- 复选框
	Checkboxs = {
		-- 是否显示配置窗口
		DoubleXpWindowShowCheckbox = nil,
		-- 是否显示双倍经验窗口
		DoubleXpWindowShowBackgroundCheckbox = nil,
		-- 是否开启双倍经验条颜色渐变
		GradientCheckbox = nil,
	},
	-- 配置项, 将会保存, 读取配置文件时会覆盖
	Option = {
		-- 是否显示双倍经验窗口
		DoubleXpWindowFrameShow = true,
		-- 是否开启双倍经验条颜色渐变
		Gradient = false,
	}
}
function DoubleExperience:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- 初始化
function DoubleExperience:Init()
	self.CreateFrame(self)
	self.UpdateDoubleXpTextAndProgressBar(self)
end

-- 读取配置文件
function DoubleExperience:LoadConfig()
	Utils.Print("DOUBL_EXPERIENCE_OPTIONS==>" .. tostring(DOUBL_EXPERIENCE_OPTIONS))
	if DOUBL_EXPERIENCE_OPTIONS then
		Utils.Print("以读取配置")
		self.Option = DOUBL_EXPERIENCE_OPTIONS
		self:SetFunctionByOption()
	end
end

-- 更具读取的配置文件进行设置
function DoubleExperience:SetFunctionByOption()
	Utils.Print("是否显示双倍经验窗口: " .. tostring(self.Option.DoubleXpWindowFrameShow))
	Utils.Print("是否显示双倍经验窗口背景: " .. tostring(self.Option.DoubleXpWindowShowBackgroundShow))
	Utils.Print("是否开启双倍经验条颜色渐变: " .. tostring(self.Option.Gradient))
	-- 设置双倍经验窗口的显示状态
	if self.Option.DoubleXpWindowFrameShow then
		self.DoubleXpWindowFrame:Show()
	else
		self.DoubleXpWindowFrame:Hide()
	end
	-- 设置是否显示双倍经验窗口的背景
	if self.Option.DoubleXpWindowShowBackgroundShow then
		self.DoubleXpWindowFrame:SetBackdropColor(0, 0, 0, 0.5)
		self.DoubleXpWindowFrame:SetBackdropBorderColor(1, 1, 1, 1)
	else
		self.DoubleXpWindowFrame:SetBackdropColor(0, 0, 0, 0)
		self.DoubleXpWindowFrame:SetBackdropBorderColor(0, 0, 0, 0)
	end
	-- 设置复选框的选中状态
	self.Checkboxs.DoubleXpWindowShowCheckbox:SetChecked(self.Option.DoubleXpWindowFrameShow)
	self.Checkboxs.DoubleXpWindowShowBackgroundCheckbox:SetChecked(self.Option.DoubleXpWindowShowBackgroundShow)
	self.Checkboxs.GradientCheckbox:SetChecked(self.Option.Gradient)
end

function DoubleExperience:SaveConfig()
	Utils.Print("保存配置")
	Utils.Print("是否显示双倍经验窗口: " .. tostring(self.Option.DoubleXpWindowFrameShow))
	Utils.Print("是否显示双倍经验窗口背景: " .. tostring(self.Option.DoubleXpWindowShowBackgroundShow))
	Utils.Print("是否开启双倍经验条颜色渐变: " .. tostring(self.Option.Gradient))
	DOUBL_EXPERIENCE_OPTIONS = self.Option
end

-- 创建一个Frame框架作为显示窗口
function DoubleExperience:CreateFrame()
	self.CreateDoubleXpWindowFrame(self)
	self.CreateDoubleXpText(self)
	self.CreateDoubleXpProgressBar(self)
	self.CreateMiniMapButton(self)
	self.CreateOptonWindowFrame(self)
end

--[[
	创建一个Frame框架作为显示窗口
	默认隐藏, 鼠标左键拖动, 鼠标右键拖动
]]
function DoubleExperience:CreateDoubleXpWindowFrame()
	self.DoubleXpWindowFrame = CreateFrame("Frame", "DoubleXpWindow", UIParent)
	self.DoubleXpWindowFrame:SetWidth(200)
	self.DoubleXpWindowFrame:SetHeight(80)
	self.DoubleXpWindowFrame:SetPoint("TOP", 0, -100)
	self.DoubleXpWindowFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	self.DoubleXpWindowFrame:SetBackdropColor(0, 0, 0, 0.5)
	self.DoubleXpWindowFrame:SetMovable(true)
	self.DoubleXpWindowFrame:EnableMouse(true)
	self.DoubleXpWindowFrame:RegisterForDrag("LeftButton")
	self.DoubleXpWindowFrame:SetScript("OnDragStart", function() this:StartMoving() end)
	self.DoubleXpWindowFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
	self.DoubleXpWindowFrame:Hide()
end

-- 创建显示文本的字体对象
function DoubleExperience:CreateDoubleXpText()
	self.DoubleXpText = self.DoubleXpWindowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.DoubleXpText:SetPoint("CENTER", 0, 0)
end

-- 创建进度条框架
function DoubleExperience:CreateDoubleXpProgressBar()
	self.DoubleXpProgressBar = CreateFrame("StatusBar", nil, self.DoubleXpWindowFrame)
	self.DoubleXpProgressBar:SetPoint("BOTTOM", 0, 10)
	self.DoubleXpProgressBar:SetWidth(180)
	self.DoubleXpProgressBar:SetHeight(10)
	self.DoubleXpProgressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	self.DoubleXpProgressBar:SetStatusBarColor(0, 0, 1)
	-- 创建进度条背景
	local background = self.DoubleXpProgressBar:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints(true)
	background:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	background:SetVertexColor(0.5, 0.5, 0.5, 0.8)
	-- 设置进度条的最小值和最大值
	self.DoubleXpProgressBar:SetMinMaxValues(0, 100)
end

-- 更新显示窗口中的文本和进度条
function DoubleExperience:UpdateDoubleXpTextAndProgressBar()
	-- showText("..双倍..", { r = 0, g = 1, b = 0 })
	local exhaustionXP = GetXPExhaustion() or 0
	local level = UnitLevel("player")
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("player")
	local maxExhaustion = maxXP * 1.5
	-- 保留两位小数
	local percent = math.floor((exhaustionXP / maxExhaustion) * 10000) / 100
	-- 文本
	self:UpdateDoubleXpText(exhaustionXP, maxExhaustion, percent)
	-- 进度条
	self:UpdateDoubleXpdProgressBarColor(percent)
end

-- 更新显示窗口中的文本
-- percent = 0 无双倍经验
function DoubleExperience:UpdateDoubleXpText(exhaustionXP, maxExhaustion, percent)
	if percent == 0 then
		self.DoubleXpText:SetText("当前无双倍经验")
		return
	end
	-- 文本
	self.DoubleXpText:SetText("剩余双倍经验\n" ..
		exhaustionXP .. " / " .. maxExhaustion .. " (" .. percent .. "%)EXP")
end

-- 更新进度条
-- percent: 0-100
-- percent = 0 隐藏进度条
function DoubleExperience:UpdateDoubleXpdProgressBarColor(percent)
	-- showText(".." .. percent .. "..", { r = 0, g = 1, b = 0 })
	self.DoubleXpProgressBar:SetValue(percent)
	if percent == 0 then
		self.DoubleXpProgressBar:Hide()
		return
	end
	if not self.DoubleXpProgressBar:IsShown() then
		self.DoubleXpProgressBar:Show()
	end

	-- 设置进度条的颜色
	if not self.Option.Gradient then
		self.DoubleXpProgressBar:SetStatusBarColor(0, 0, 1)
		return
	end
	if percent > 80 then
		self.DoubleXpProgressBar:SetStatusBarColor(0, 1, 0)
	elseif percent > 50 then
		self.DoubleXpProgressBar:SetStatusBarColor(0, 1, 1)
	elseif percent > 20 then
		self.DoubleXpProgressBar:SetStatusBarColor(1, 1, 0)
	else
		self.DoubleXpProgressBar:SetStatusBarColor(1, 0, 0)
	end
end

-- 创建小地图旁圆形按钮
function DoubleExperience:CreateMiniMapButton()
	-- 按钮大小
	local size = 32
	self.MiniMapButton = CreateFrame("Button", "MiniMapButton", Minimap)
	self.MiniMapButton:SetWidth(size)
	self.MiniMapButton:SetHeight(size)
	self.MiniMapButton:SetFrameStrata("MEDIUM")
	-- self.MiniMapButton:SetFrameLevel(8)
	self.MiniMapButton:Raise()
	self.MiniMapButton:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
	-- 用于设置按钮的材质
	self.MiniMapButton:SetNormalTexture("Interface\\BUTTONS\\UI-Quickslot-Depress")
	-- 用于设置鼠标悬停在按钮上时的纹理材质
	self.MiniMapButton:SetHighlightTexture("interface\\buttons\\iconborder-glowring")

	-- 创建按钮上的图标
	local icon = self.MiniMapButton:CreateTexture(nil, "BACKGROUND")
	icon:SetWidth(size)
	icon:SetHeight(size)
	icon:SetPoint("CENTER", self.MiniMapButton, "CENTER", 0, 0)
	icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_08")
	self.MiniMapButton.icon = icon

	-- 创建按钮上的文本
	-- local text = self.MiniMapButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	-- text:SetPoint("CENTER", self.MiniMapButton, "CENTER", 0, 0)
	-- text:SetText("双")
	-- self.MiniMapButton.text = text

	-- 创建按钮上的提示
	self.MiniMapButton:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self.MiniMapButton, "ANCHOR_LEFT")
		GameTooltip:AddLine("双倍经验查看", 1, 1, 1)
		GameTooltip:AddLine("|cff1eff00左键:|r 隐藏/显示")
		GameTooltip:AddLine("|cff1eff00右键:|r 拖动按钮")
		GameTooltip:Show()
	end)
	self.MiniMapButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- 创建按钮的点击事件, 显示双倍经验窗口
	self.MiniMapButton:SetScript("OnClick", function()
		if self.OptonWindowFrameShow then
			self.OptonWindowFrame:Hide()
			self.OptonWindowFrameShow = false
		else
			self.OptonWindowFrame:SetPoint("TOP", 0, -300)
			self.OptonWindowFrame:Show()
			self.OptonWindowFrameShow = true
		end
		self:UpdateDoubleXpTextAndProgressBar()
	end)

	-- 创建按钮的右键拖动事件
	self.MiniMapButton:SetMovable(true)
	self.MiniMapButton:SetClampedToScreen(true)
	self.MiniMapButton:SetScript("OnMouseDown", function()
		if arg1 == "RightButton" then
			self.MiniMapButton:StartMoving()
		end
	end)
	self.MiniMapButton:SetScript("OnMouseUp", function()
		self.MiniMapButton:StopMovingOrSizing()
	end)
end

--[[
	创建一个Frame框架作为配置窗口, 配置项窗口默认隐藏
	两个选项:
		1. 是否显示双倍经验窗口
		2. 是否显示双倍经验背景
		3. 是否开启双倍经验条颜色渐变
]]
--
function DoubleExperience:CreateOptonWindowFrame()
	self.OptonWindowFrame = CreateFrame("Frame", "OptonWindow", UIParent)
	self.OptonWindowFrame:SetWidth(230)
	self.OptonWindowFrame:SetHeight(100)
	self.OptonWindowFrame:SetPoint("TOP", 0, -300)
	self.OptonWindowFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	self.OptonWindowFrame:SetBackdropColor(0, 0, 0, 0.5)
	self.OptonWindowFrame:SetMovable(true)
	self.OptonWindowFrame:EnableMouse(true)
	self.OptonWindowFrame:RegisterForDrag("LeftButton")
	self.OptonWindowFrame:SetScript("OnDragStart", function() this:StartMoving() end)
	self.OptonWindowFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

	-- 创建关闭按钮
	local closeButton = CreateFrame("Button", "OptonWindowCloseButton", self.OptonWindowFrame, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", 0, 0)
	closeButton:SetScript("OnClick", function()
		self.OptonWindowFrame:Hide()
		self.OptonWindowFrameShow = false
	end)

	-- 创建标题
	local title = self.OptonWindowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOP", 0, -10)
	title:SetText("双倍经验配置")

	local _self = self
	-- 创建[是否显示双倍经验窗口]复选框
	self.Checkboxs.DoubleXpWindowShowCheckbox = Utils:CreactCheckboxFrame("DoubleXpWindowShowCheckbox",
		self.OptonWindowFrame, {
			x = 20,
			y = -30,
			width = 20,
			height = 20,
			checked = function()
				_self.DoubleXpWindowFrame:Show()
				_self.Option.DoubleXpWindowFrameShow = true
				_self:SaveConfig()
			end,
			unchecked = function()
				_self.DoubleXpWindowFrame:Hide()
				_self.Option.DoubleXpWindowFrameShow = false
				_self:SaveConfig()
			end,
			text = "显示双倍经验窗口",
			isChecked = true
		})

	-- 创建[是否显示双倍经验背景]复选框
	self.Checkboxs.DoubleXpWindowShowBackgroundCheckbox = Utils:CreactCheckboxFrame(
		"DoubleXpWindowShowBackgroundCheckbox", self.OptonWindowFrame, {
			x = 20,
			y = -50,
			width = 20,
			height = 20,
			checked = function()
				_self.DoubleXpWindowFrame:SetBackdropColor(0, 0, 0, 0.5)
				_self.DoubleXpWindowFrame:SetBackdropBorderColor(1, 1, 1, 1)
				_self.Option.DoubleXpWindowShowBackgroundShow = true
				_self:SaveConfig()
			end,
			unchecked = function()
				_self.DoubleXpWindowFrame:SetBackdropColor(0, 0, 0, 0)
				_self.DoubleXpWindowFrame:SetBackdropBorderColor(0, 0, 0, 0)
				_self.Option.DoubleXpWindowShowBackgroundShow = false
				_self:SaveConfig()
			end,
			text = "显示双倍经验背景",
			isChecked = true
		})

	-- 创建[是否开启双倍经验条颜色渐变]复选框
	self.Checkboxs.GradientCheckbox = Utils:CreactCheckboxFrame("GradientCheckbox", self.OptonWindowFrame, {
		x = 20,
		y = -70,
		width = 20,
		height = 20,
		checked = function()
			_self.Option.Gradient = true
			_self:SaveConfig()
		end,
		unchecked = function()
			_self.Option.Gradient = false
			_self:SaveConfig()
		end,
		text = "开启双倍经验条颜色渐变",
		isChecked = false
	})

	-- 配置项默认隐藏
	self.OptonWindowFrame:Hide()
end

-- 创建对象
DBE = DoubleExperience:new(nil)
DBE:Init()

-- 事件
DBE.DoubleXpWindowFrame:RegisterEvent("ADDON_LOADED")
DBE.DoubleXpWindowFrame:SetScript("OnEvent", function()
	local arg2 = arg2 and arg2 or "nil"
	Utils.Print("ADDON_LOADED || " .. arg1 .. " || " .. arg2)
	if (arg1 == "DoubleExperience") then
		DBE:LoadConfig();
	end
end)

-- 每秒更新一次
DBE.DoubleXpWindowFrame:SetScript("OnUpdate", function()
	DBE:UpdateDoubleXpTextAndProgressBar()
end)

-- 进入游戏时
-- function DBE.DoubleXpWindowFrame:PLAYER_ENTERING_WORLD()
-- 	DBE:UpdateDoubleXpTextAndProgressBar()
-- end

-- 输入/DBEHIDE / DBESHOW 控制显示与隐藏
-- 处理输入命令
SLASH_DBESHOW1 = "/DBESHOW"
SLASH_DBEHIDE1 = "/DBEHIDE"

SlashCmdList["DBESHOW"] = function()
	DBE.DoubleXpWindowFrame:Show()
	DBE.Option.DoubleXpWindowFrameShow = true
	DBE:UpdateDoubleXpTextAndProgressBar()
end

SlashCmdList["DBEHIDE"] = function()
	DBE.DoubleXpWindowFrame:Hide()
	DBE.Option.DoubleXpWindowFrameShow = false
end

-- 重置位置命令
SLASH_DBEREST1 = "/DBEREST"
SlashCmdList["DBEREST"] = function()
	DBE.DoubleXpWindowFrame:ClearAllPoints()
	DBE.DoubleXpWindowFrame:SetPoint("TOP", 0, -100)
end
