-- [[
-- Simplified Chinese
-- Externalized by: Arith Hsu
-- Original translated and maintained by: Alfred (http://statue.sayya.org/QuestLibrary)
-- Last Updated: 2006/09/01
-- ]]
--------------------------
-- Translatable strings --
--------------------------

if (GetLocale() == "zhCN") then
--
FQ_FORMAT0 = 		"任务名称";
FQ_FORMAT1 = 		"[任务等级] 任务名称";
FQ_FORMAT2 =		"[任务等级+] 任务名称";
FQ_FORMAT3 =		"[任务等级] 任务名称 (精英)";
--
FQ_EPA_PATTERN1 = 	"^(.+): %s*[-%d]+%s*/%s*[-%d]+%s*$";
FQ_EPA_PATTERN2 = 	"^(.+)\(已完成\)%s$";
FQ_EPA_PATTERN3 = 	"^(.+)完成。$";
FQ_EPA_PATTERN4 = 	"^获得经验值: .+$";
FQ_EPA_PATTERN5 = 	"^发现.+$";
FQ_EPA_PATTERN6 = 	"^(.+)\(完成\)%s$";
FQ_EPA_PATTERN7 = 	"^接受任务：.+$";
--
FQ_LOADED = 		"|cff00ffffFastQuest 2.11.3 载入. 输入 /fq 以取得更多的设定信息.";
FQ_INFO =			"|cff00ffff任务追踪: |r|cffffffff";
--
FQ_INFO_QUEST_TAG =		"显示任务追踪列表中的任务难度: ";
FQ_INFO_AUTOADD = 		"自动添加当前的任务到任务追踪列表并移除已完成的任务: ";
-- FQ_INFO_AUTONOTIFY = 	"在说或队伍频道自动播报任务进度: ";
-- FQ_INFO_AUTOCOMPLETE = 	"自动交任务: ";
-- FQ_INFO_ALLOWGUILD = 	"在公会频道中播报任务进度: ";
-- FQ_INFO_ALLOWRAID = 	"在团队频道中播报任务进度: ";

FQ_INFO_ALWAYSNOTIFY = 	"任务通报: ";
FQ_INFO_DETAIL =		"详细的任务播报(如接受任务、完成任务等): ";
FQ_INFO_LOCK =			"移动任务追踪列表按钮已 |cffff0000隐藏|r|cffffffff";
FQ_INFO_UNLOCK =		"移动任务追踪列表按钮已 |cff00ff00显示|r|cffffffff";
FQ_INFO_NODRAG =		"任务追踪列表可移动: ";
FQ_INFO_RESET = 		"重置任务追踪列表位置";
FQ_INFO_FORMAT =		"选择在聊天框中显示的任务名称的格式";
FQ_INFO_DISPLAY_AS =	"任务显示格式: ";
FQ_INFO_CLEAR =			"清除所有任务追踪列表中的任务";
FQ_INFO_USAGE = 		"指令 /fastquest [command] 或 /fq [command]";
FQ_INFO_COLOR =			"在任务追踪列表中根据任务难易度以不同的颜色显示任务标题: ";
FQ_INFO_SOUND =         "完成任务时播放音效：";
FQ_INFO_AUTOQUEST =     "自动交接任务："
--
FQ_MUST_RELOAD =		"你必需输入 |cffffff00/console reloadui |r|cffffffff本功能才可作用|r";
--
FQ_USAGE_TAG =			"显示任务追踪列表困难度 (精英, 团队,等等) ";
FQ_USAGE_LOCK =			"显示/隐藏移动任务追踪列表的按钮";
FQ_USAGE_NODRAG =		"开启/关闭任务追踪列表可移动模式, 设定后须输入 |cffffff00/console reloadui |r|cffffffff才可生效|r";
FQ_USAGE_AUTOADD =		"开启/关闭添加当前的任务到任务跟踪列表并移除已完成的任务";
-- FQ_USAGE_AUTONOTIFY =	"在说或队伍频道自动播报任务进度";
FQ_USAGE_AUTOQUEST =	"自动交接任务";
-- FQ_USAGE_ALLOWGUILD =	"在公会频道中通知任务进度";
-- FQ_USAGE_ALLOWRAID =	"在团队频道中通知任务进度";

FQ_USAGE_ALWAYSNOTIFY =	"开启/关闭任务通报";
FQ_USAGE_DETAIL =		"开启/关闭详细播报(如接受任务、完成任务、进度等)";
FQ_USAGE_RESET =		"重置任务追踪列表位置";
FQ_USAGE_STATUS =		"显示所有任务追踪的设定状态";
FQ_USAGE_CLEAR =		"清除所有任务追踪列表中的任务";
FQ_USAGE_FORMAT =		"(按 Ctrl 点选任务) 在聊天框中显示任务名称格式共4种每输入一次切换一种, 如:[10+]任务名称,[10]任务名称(精英)";
FQ_USAGE_COLOR =		"设定在任务追踪列表中是否根据任务难易度以不同的颜色显示任务标题.";
FQ_USAGE_SOUND =        "设置完成任务时是否播放音效";
--
FQ_BINDING_CATEGORY_FASTQUEST		= "任务增强";
FQ_BINDING_HEADER_FASTQUEST			= "快速任务";
FQ_BINDING_NAME_FASTQUEST_T			= "任务追踪列表困难度";
FQ_BINDING_NAME_FASTQUEST_F			= "选择聊天任务名称格式";
FQ_BINDING_NAME_FASTQUEST_AOUTP		= "自动通知队友";
FQ_BINDING_NAME_FASTQUEST_AOUTC		= "自动完成提交任务";
FQ_BINDING_NAME_FASTQUEST_AOUTA		= "自动添加任务追踪列表";
FQ_BINDING_NAME_FASTQUEST_NOHEADERS	= "任务追踪列表解锁/锁定";
--
FQ_SELECT_FORMAT =		"选择显示聊天任务名称的格式 (按住 Ctrl 点选任务时)";
--
FQ_QUEST_PROGRESS =		"任务进度: ";
--
FQ_QUEST = 				"任务追踪: ";
FQ_QUEST_ISDONE =		"已完成! ";
FQ_QUEST_COMPLETED =	" (任务完成)";
FQ_DRAG_DISABLED =		"任务追踪: 移动任务追踪列表现在是关闭的, 输入 /fq nodrag 来设定. 你必须重新载入 UI 来使这改变生效.";
--
FQ_ENABLED =			"|cff00ff00启动|r|cffffffff";
FQ_DISABLED =			"|cffff0000关闭|r|cffffffff";
FQ_LOCK =				"|cffff0000隐藏|r|cffffffff";
FQ_UNLOCK =				"|cff00ff00显示|r|cffffffff";
--
FQ_ERROR_NEEDRELOADUI = "请先输入 /fq nodrag 命令或在设置界面取消勾选最后一项，再进行此操作"
end
