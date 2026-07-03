local L = AceLibrary("AceLocale-2.0"):new("Rares")

L:RegisterTranslations("zhCN", function()
	return {
		--enUS
		["loaded"] = "加载!",
		["raresFound"] = "稀有探测器 v%s 发现!",
		["rareFoundAlive"] = "%s 发现!",
		["rareFoundDead"] = "%s 发现, 但是已经死了!",
		["noRaresInZone"] = "这个区域没有发现稀有 %s",
		["zoneRaresTotal"] = "发现 %d 稀有在这个区域 %s%s:",
		["zoneRaresTotalPage"] = " (页 %s)",
		["tooltipRareLine1"] = "%s. 等级%s%s %s, 发现 (%d)",
		["tooltipRareLine2"] = ", 最后发现: %s",
		["tooltipRareLine3"] = " @ %s",
		["tooltipFuRareLine1"] = "%s. 等级%s%s %s",
		["tooltipFuRareLine2"] = ", 发现 (%d)",
		["tooltipFuRareLine3"] = ", 最后: %s",
		["tooltipFuRareLine4"] = " @ %s",
		["nameButtonLock"] = "锁定/解锁 (按钮)",
		["descButtonLock"] = "框架按钮活动/固定",
		["nameButtonShow"] = "显示隐藏框架按钮",
		["descButtonShow"] = "显示隐藏框架按钮",
		["nameInfoAnchor"] = "切换信息锚点",
		["descInfoAnchor"] = "切换信息锚点",
		["nameTooltipAnchor"] = "切换提示框锚点",
		["descTooltipAnchor"] = "切换提示框锚点",
		["tooltipAnchorLeft"] = "信息提示锚点到左",
		["tooltipAnchorRight"] = "信息提示锚点到右",
		["nameModelShow"] = "显示/隐藏模型框架",
		["descModelShow"] = "显示/隐藏模型框架",
		["fubarHint"] = "点击到目标时发现.",
		["rareNpc"] = "稀有NPC",
		["cartNote"] = "%s等级%s%s|r %s%s|r",
	}
end)
