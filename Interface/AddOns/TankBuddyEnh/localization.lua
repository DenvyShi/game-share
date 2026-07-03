--
-- Localization file for Tank Buddy v3.0
--

-- English
-- by Artun Subasi and Kolthor
-- last changed: January 11th, 2007

TB_version = "v3.0";

TB_GUI_EnableTankBuddyEnh = "启用坦克助手";
TB_GUI_Raid = "团队";
TB_GUI_Party = "队伍";
TB_GUI_Alone = "单人";
TB_GUI_AnnouncementChannel = "通告频道";
TB_GUI_AnnouncementTexts = "通告文本";
TB_GUI_SetCustomChannel = "设置自定义频道";
TB_GUI_EnterChannelName = "输入频道名称或号码:";
TB_GUI_Close = "关闭";
TB_GUI_Help = "帮助";
TB_GUI_Test = "测试";
TB_GUI_Copy = "复制";
TB_GUI_Paste = "粘贴";
TB_GUI_General = "一般";
TB_GUI_Taunt = "嘲讽";
TB_GUI_MB = "惩戒痛击";
TB_GUI_LS = "破釜沉舟";
TB_GUI_SW = "盾墙";
TB_GUI_LG = "生命宝石";
TB_GUI_PM = "拳击";
TB_GUI_SB = "盾击";
TB_GUI_CS = "挑战怒吼";
TB_GUI_CSP = "法术反制";
TB_GUI_SB_MISSED = "盾击没有击中";
TB_GUI_KC_MISSED = "脚踢没有击中";
TB_GUI_PM_MISSED = "拳击没有击中";
TB_GUI_Growl = "低吼";
TB_GUI_CR = "挑战咆哮";
TB_GUI_KC = "脚踢";
TB_GUI_PL = "变形术";
TB_GUI_BN = "放逐术";
TB_GUI_EnterNewText = {
	[TB_GUI_SB] = "进入新的通告文本 盾击",
	[TB_GUI_PM] = "进入新的通告文本 拳击",
	[TB_GUI_CSP] = "进入新的通告文本 抵抗法术反制",
	[TB_GUI_KC] = "进入新的通告文本 脚踢",
	[TB_GUI_PL] = "进入新的通告文本 抵抗变形术",
	[TB_GUI_BN] = "进入新的通告文本 抵抗放逐术",
	[TB_GUI_Taunt] = "进入新的通告文本 抵抗嘲讽:",
	[TB_GUI_MB] = "进入新的通告文本 惩戒痛击失败:",
	[TB_GUI_LS] = "进入新的通告文本 使用破釜沉舟:",
	[TB_GUI_SW] = "进入新的通告文本 使用盾墙:",
	[TB_GUI_LG] = "进入新的通告文本 使用生命宝石:",
	[TB_GUI_CS] = "进入新的通告文本 使用挑战怒吼:",
	[TB_GUI_Growl] = "进入新的通告文本 低吼低吼:",
	[TB_GUI_CR] = "进入新的通告文本 使用挑战咆哮:"
}
TB_GUI_EnterNewMBRecoveryText = "进入新的通告文本 恢复嘲讽:";
TB_GUI_RemoveBuffs = "移除 Buff";
TB_GUI_RemoveBuffsAlways = "全部移除:";
TB_GUI_DisableInBG = "禁用在战场";
TB_GUI_RemoveBuffsDefensive = "只在防御姿态才移除:";
TB_GUI_RemoveBuffsBear = "只在熊形态才移除:";
TB_GUI_EnableMBRecovery = "开启补救嘲讽失败的信息";

TB_GUI_IntroText = "感谢你使用坦克助手, 原名Taunt Buddy.\nTaunt Buddy最初是Artun Subasi创造的, 但他停止更新, 来自Doomhammer EU kolthor接管.\n\n右边有很多标签, 根据你的职业.每个选项都有发布消息的选项, 以及在特定情况下宣布的频道."
TB_GUI_HelpText = "Buff 去除:\n移除无用的BUFF, 有两种选择; 总是, 只有在防御姿态/熊形态.\n坦克助手将寻找包含任何文本指定的buff, 用逗号分隔 (,). 注！您不需要输入buff的整个名称, 只是部分。例子: \"智慧, 精神\" 将寻找任何有这个词的buff,并移除它们。这将匹配 \"奥术智慧\" 和 \"精神祷言\", 也会删除卷轴的智力和精神buff和任何其他BUFF，有 \"智慧\" 或 \"精神\" 在他的名字里.\n\n标签:\n复选框控件的左边通道发送公告消息, 如果你在团队中. 中间一列, 如果你在队伍里, 最右边的列, 如果你一个人.\n可以用自定义 \"自定义\", 将出现一个窗口，您可以在自定义频道中输入, 按频道名称或号码. 指定多个频道, 用一个空格分开.\n当你选择了一些频道, 你能点击 \"复制\"-按钮复制您的选择, 然后单击另一个选项卡, 和点击 \"粘贴\"-按钮使用相同的选择.\n注！这将覆盖任何自定义通道.\n你可以指定一个消息在编辑框的底部, 并使用下面列出的变量.\n如果你选择 \"使失败的嘲讽恢复公告\" 在嘲讽标签, 您可以输入消息，以宣布在事件中. 注！这只会工作到嘲讽不再冷却, 而且，只有当你当前的目标与抗拒嘲讽的名称和级别相同.\n\n变数:\n嘲讽, 低吼和惩戒痛击:\n$tn: 目标名字 (等同于 %t)\n$tl: 目标等级\n$tt: 目标类型 (人型, 野兽, 恶魔 等等.)\n$ttn: 目标的目标名字\n$ttl: 目标的目标等级\n$ttt: 目标的目标类型\n\n盾墙, 挑战怒吼, 挑战咆哮, 破釜沉舟和生命宝石:\n$sec: 秒的持续时间\n\n破釜沉舟和生命宝石:\n$hp: 获得的点数量的能力.";

TB_GUI_Channel_Ctraid = "CTRaid";
TB_GUI_Channel_RaidWarning = "团队警报";
TB_GUI_Channel_Raid = "团队";
TB_GUI_Channel_Guild = "公会";
TB_GUI_Channel_Party = "队伍";
TB_GUI_Channel_Yell = "大喊";
TB_GUI_Channel_Say = "说";
TB_GUI_Channel_Custom = "自定义";

TB_defaultText = {
	[TB_GUI_Taunt] = "- 我的嘲讽被抵抗 $tn! -";
	[TB_GUI_PL] = "- 我的变形术被抵抗 $tn! -";
	[TB_GUI_MB] = "- 我的惩戒痛击失败 $tn! -";
	[TB_GUI_CSP] = "抵抗法术反制";
	[TB_GUI_BN] = "抵制放逐术";
	[TB_GUI_PM] = "拳击 对 $tn";
	[TB_GUI_SB] = "盾击 对 $tn";
	[TB_GUI_KC] = "脚踢 对 $tn";
	[TB_GUI_LS] = "- 我激活了破釜沉舟! 在 $sec 秒后我会失去 $hpHP! -";
	[TB_GUI_SW] = "- 我激活了盾墙!将降低 75% 伤害 $sec 秒! -";
	[TB_GUI_LG] = "- 我激活了生命宝石! 在 $sec 秒后我会失去 $hpHP! -";
	[TB_GUI_CS] = "- 我激活了挑战怒吼! 我需要更多的治疗 $sec 秒! -";
	[TB_GUI_Growl] = "- 我的咆哮被抵抗 $tn! -";
	[TB_GUI_CR] = "- 我激活了挑战咆哮! 我需要更多的治疗 $sec 秒! -";
}
TB_defaultText_r = "- 我的惩戒痛击命中抵抗我嘲讽的怪物! -";

TB_tauntLine = "你的嘲讽被(.+)抵抗了";
TB_growlLine = "你的低吼被(.+)抵抗了";
TB_PLLine = "你的变形术被(.+)抵抗了。";
TB_CSPLine = "你的法术反制被(.+)抵抗了。";
TB_PLPLine = "你的变形术：猪被(.+)抵抗了。";
TB_PLTLine = "你的变形术：龟被(.+)抵抗了。";
TB_BNLine = "你的放逐术被(.+)抵抗了。";
TB_mbHitLine = "你的惩戒痛击(.*)(.+)造成(.+)";
TB_kcHitLine = "你的脚踢击中(.*)(.+)造成(.+)";
TB_pmHitLine = "你的拳击击中(.*)(.+)造成(.+)";
TB_sbHitLine = "你的盾击击中(.*)(.+)造成(.+)";
TB_mb = "(.*)惩戒痛击(.*)";
TB_pm = "(.*)拳击(.*)";
TB_sb = "(.*)盾击(.*)";
TB_kc = "(.*)脚踢(.*)";
TB_ls = "你获得了破釜沉舟的效果。";
TB_sw = "你获得了盾墙的效果。";
TB_lg = "你获得了生命赐福的效果。";
TB_cs = "挑战怒吼";
TB_cr = "挑战咆哮";
TB_salvation = "拯救祝福";
TB_intellect = "奥术";
TB_wisdom = "智慧祝福";

TB_output_buffremoved = " removed, matched "; --As in ["Greater Blessing of Salvation" removed, matched "Salvation"]
TB_output_startup = " 加载. 使用 /TB 设置.";
TB_output_alreadyOff = "坦克助手已被禁用.";
TB_output_alreadyOn = "坦克助手已被启用";
TB_output_off = "坦克助手关.";
TB_output_on = "坦克助手开.";

TB_cmd_on = "on";
TB_cmd_off = "off";