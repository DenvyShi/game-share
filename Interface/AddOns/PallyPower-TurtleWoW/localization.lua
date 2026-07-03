PallyPower_Version = "1.072"
SLASH_PALLYPOWER1 = "/pp"
SLASH_PALLYPOWER2 = "/pallypower"
local loc = GetLocale()
PallyPower_BlessingID = {};

PallyPower_BlessingID[0] = "Wisdom";
PallyPower_BlessingID[1] = "Might";
PallyPower_BlessingID[2] = "Salvation";
PallyPower_BlessingID[3] = "Light";
PallyPower_BlessingID[4] = "Kings";
PallyPower_BlessingID[5] = "Sanctuary";

PallyPower_BlessingTalentSearch = "Improved Blessing of (.*)";

if (FiveMinBlessing == false)
then
  PallyPower_BlessingSpellSearch = "Greater Blessing of (.*)";
else
  PallyPower_BlessingSpellSearch = "Blessing of (.*)";
end
--PallyPower_BlessingSpellSearch = "Blessing of (.*)";
--PallyPower_FiveManBlessingSpellSearch = "Blessing of (.*)";
PallyPower_Rank1 = "Rank 1"
PallyPower_RankSearch = "Rank (.*)"
PallyPower_Symbol = "Symbol of Kings"

PallyPower_Greater = "Greater"
-- _,class = UnitClass("player") returns....
PallyPower_Paladin = "PALADIN"

-- Used... ClassID .. ": Blessing of "..BlessingI

PallyPower_BuffFrameText = "："
PallyPower_Have = "已有："
PallyPower_Need = "需要："
PallyPower_NotHere = "范围外："
PallyPower_Dead = "死亡："

PallyPower_BuffBarTitle = "祝福助手(%d)"


PallyPower_Credits1 = "Pally Power - by Aznamir"
PallyPower_Credits2 = "Version: " .. PallyPower_Version
PallyPower_Credits3 = "汉化修复 - MrBCat"
PallyPower_Credits4 = "Originaly by Sneakyfoot of Resurrection of Nathrezim"
PallyPower_Credits5 = "更新插件支持Turtle WoW，增加萨满祭司及宠物 by Rake/Xerron"

-- Buff name, Class Name
PallyPower_CouldntFind = "找不到可以施加 %s 的 %s!"

-- Buff name, Class name, Person Name
PallyPower_Casting = "施加 %s 于 %s (%s)"

-- Reporting
PallyPower_Assignments1 = "--- 祝福列表 ---"
PallyPower_Assignments2 = "--- 列表结束 ---"

PallyPower_ClassID = {};
PallyPower_ClassID[0] = "Warrior";
PallyPower_ClassID[1] = "Rogue";
PallyPower_ClassID[2] = "Priest";
PallyPower_ClassID[3] = "Druid";
PallyPower_ClassID[4] = "Paladin";
PallyPower_ClassID[5] = "Hunter";
PallyPower_ClassID[6] = "Mage";
PallyPower_ClassID[7] = "Warlock";
PallyPower_ClassID[8] = "Shaman";
PallyPower_ClassID[9] = "Pet";

--XML

PALLYPOWER_CLEAR = "清除";
PALLYPOWER_REFRESH = "刷新";
PALLYPOWER_OPTIONS = "选项";
PALLYPOWER_OPTIONS_TITLE = "设置选项";
PALLYPOWER_OPTIONS_SCAN = "剩余时间更新间隔(秒)：";
PALLYPOWER_OPTIONS_SCAN2 = "祝福存在遍历间隔: ";
PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "在聊天框中显示反馈信息";
PALLYPOWER_OPTIONS_SMARTBUFFS = "智能跳过不需要的祝福";
PALLYPOWER_OPTIONS_FIVEMIN = "启用10分钟小祝福";
if (loc == "zhCN" or MRBCAT.XZ) then
  if (FiveMinBlessing == false) then
    PallyPower_BlessingSpellSearch = "强效(.*)";
  else

    PallyPower_BlessingSpellSearch = "(.*)";
  end
  PallyPower_BlessingID = {};
  PallyPower_BlessingID[0] = "智慧祝福";
  PallyPower_BlessingID[1] = "力量祝福";
  PallyPower_BlessingID[2] = "拯救祝福";
  PallyPower_BlessingID[3] = "光明祝福";
  PallyPower_BlessingID[4] = "王者祝福";
  PallyPower_BlessingID[5] = "庇护祝福";
  PallyPower_Rank1 = "等级 1"
  PallyPower_RankSearch = "等级 (.*)"
  PallyPower_BlessingTalentSearch = "强化(.*)";
  PallyPower_Greater = "强效"
  if loc =="zhCN" then
   
    PallyPower_Symbol = "王者印记"
    PallyPower_ClassID = {};
    PallyPower_ClassID[0] = "战士";
    PallyPower_ClassID[1] = "盗贼";
    PallyPower_ClassID[2] = "牧师";
    PallyPower_ClassID[3] = "德鲁伊";
    PallyPower_ClassID[4] = "圣骑士";
    PallyPower_ClassID[5] = "猎人";
    PallyPower_ClassID[6] = "法师";
    PallyPower_ClassID[7] = "术士";
    PallyPower_ClassID[8] = "萨满祭司";
    PallyPower_ClassID[9] = "宠物";
  end
end
