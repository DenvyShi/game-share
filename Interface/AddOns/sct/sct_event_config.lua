SCT_Event_Config = {
{name="压制:  *2", search="你的(.+)被(.+)躲闪过去了", r=256/256, g=128/256, b=0/256, ani=0, class="战士", title="压制1",tooltipText="显示压制"},{name="压制:  *1", search="你发起了攻击。(.+)闪开了", r=256/256, g=128/256, b=0/256, ani=0, class="战士", title="压制2",tooltipText="显示压制"}, 
{name="佯攻 命中", search="使用佯攻", r=0/256, g=256/256, b=0/256, ani=0, class="盗贼", title="佯攻命中",tooltipText="佯攻命中"},
{name="佯攻 失败", search="你的佯攻", r=256/256, g=196/256, b=0/256, ani=0, class="盗贼", title="佯攻失败",tooltipText="佯攻失败"},
{name="Hit!  *3  *1", search="你的(.+)击中(.+)造成(%d+)点伤害", r=256/256, g=256/256, b=0/256, ani=0, title="物理技能伤害",tooltipText="显示你的技能对敌人造成的伤害"},
{name="Hit!  *3  *1", search="你的(.+)击中(.+)造成(%d+)点(.+)伤害", r=256/256, g=256/256, b=0/256, ani=0, title="魔法技能伤害",tooltipText="显示你的技能对敌人造成的伤害"},
{name="额外攻击 x *2", search="你通过(.+)获得了(%d+)次额外攻击", r=256/256, g=256/256, b=0/256, ani=0, title="额外攻击1",tooltipText="额外攻击"},
{name="额外攻击 x *2", search="你通过(.+)获得(%d+)次额外攻击", r=256/256, g=256/256, b=0/256, ani=0, title="额外攻击2",tooltipText="额外攻击"},
{name="- *3 -", search="你的(.+)治疗了([^0-9]+)(%d+)点生命", r=0/256, g=256/256, b=0/256, ani=0,title="治疗量",tooltipText="显示你对其他人的治疗量"},
{name="极效 - *3 -", search="你的(.+)对(.+)产生极效治疗效果，恢复了(%d+)点生命", r=0/256, g=256/256, b=0/256, ani=0,iscrit=1,title="极效治疗量",tooltipText="显示你对其他人的治疗量"},
};
