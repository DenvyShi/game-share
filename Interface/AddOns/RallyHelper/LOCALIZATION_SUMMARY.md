# RallyHelper Traditional Chinese Localization Summary

## Files Updated

### 1. Core Files Modified

1. **`RallyHelper_Core.lua`**
   - Added `L()` helper function at the beginning
   - Updated all chat messages to use `L()` for localization
   - Updated time formatting functions to use localization
   - Updated command handlers for `/rallysound`, `/rallytoast`, `/rallyignore`, `/rally`
   - Updated server restart detection message
   - Updated `PrintStatus()` function for buff display
   - Updated `ShareTimersToChat()` function
   - Updated `FormatTimeSimple()` and `FormatAgo()` functions

2. **`RallyHelper_UI.lua`**
   - Added `L()` helper function at the beginning
   - Updated faction filter UI text (Horde, Alliance, Both)
   - Updated welcome/first-time setup text
   - Updated settings window text (Title, Faction Filter, UI Settings)
   - Updated UI elements text (Width, Height, Close)
   - Updated timer display text in UI (ZG last drop, DMF, Rend/WB)

### 2. Localization Files Created

1. **`locales/zhTW.lua`** - Traditional Chinese localization
2. **`locales/enUS.lua`** - English localization (fallback)
3. **`RallyHelper_Locale.lua`** - Localization loader system

## Localization Keys Added

### Buff Names & Factions
- `"ONY"` = "奧妮克希亞" (Onyxia)
- `"NEF"` = "奈法利安" (Nefarian)
- `"WB"` = "酋長祝福" (Warchief's Blessing)
- `"ZG"` = "祖爾格拉布" (Zul'Gurub)
- `"DMF"` = "暗月馬戲團" (Darkmoon Faire)
- `"HORDE"` = "部落"
- `"ALLIANCE"` = "聯盟"
- `"BOTH"` = "兩者"

### Command Responses
- `"Sounds enabled"` = "聲音已啟用"
- `"Sounds disabled"` = "聲音已停用"
- `"Set sound for"` = "設定音效為"
- `"Sound volume set to"` = "音效音量設定為"
- `"toastMode set to"` = "通知模式設定為"
- `"Ignored"` = "已忽略"
- `"Unignored"` = "已取消忽略"
- `"Faction filter set to"` = "陣營過濾設定為"
- `"UI lock:"` = "UI 鎖定:"
- `"Users online:"` = "線上使用者:"
- `"Debug:"` = "除錯:"
- `"Toast messages:"` = "通知訊息:"
- `"Requested timers from channel"` = "已從頻道請求計時器"
- `"confirmed"` = "已確認"
- `"Server restart detected. All timers have been reset."` = "偵測到伺服器重啟。所有計時器已重設。"

### UI Elements
- `"Settings"` = "設定"
- `"Close"` = "關閉"
- `"Width"` = "寬度"
- `"Height"` = "高度"
- `"Faction Filter:"` = "陣營過濾:"
- `"UI Settings:"` = "UI 設定:"
- `"Welcome to RallyHelper!"` = "歡迎使用 RallyHelper!"
- `"Please select which world buffs you want to track:"` = "請選擇你想要追蹤的世界增益:"
- `"All buffs from both factions"` = "兩個陣營的所有增益"
- `"You can change this later with /rally settings"` = "你可以稍後使用 /rally settings 更改此設定"

### Timer Display
- `"Ony SW:"` = "奧妮克希亞 暴風城:"
- `"Ony OG:"` = "奧妮克希亞 奧格瑪:"
- `"Nef SW:"` = "奈法利安 暴風城:"
- `"Nef OG:"` = "奈法利安 奧格瑪:"
- `"ZG last drop:"` = "ZG 最後掉落:"
- `"DMF last seen:"` = "DMF 最後出現:"
- `"in"` = "在"
- `"Realm:"` = "領域:"

### Time Formatting
- `"ready"` = "就緒"
- `"h"` = "時"
- `"m"` = "分"
- `"s"` = "秒"
- `"ago"` = "前"
- `"unknown"` = "未知"
- `"UnknownRealm"` = "未知領域"

### Usage Messages
- All slash command usage messages have been localized

## Testing Instructions

1. Set WoW client to Traditional Chinese (zhTW) locale
2. Load the RallyHelper addon
3. Test slash commands:
   - `/rallysound on/off/volume`
   - `/rallytoast chat/ui/none`
   - `/rallyignore add/remove/list`
   - `/rally status/share/toast/lock/users/debug/request/settings`
4. Verify all UI text appears in Traditional Chinese
5. Verify chat messages appear in Traditional Chinese
6. Test English fallback by temporarily removing zhTW.lua file

## Technical Implementation

1. **Localization System**: Uses a loader pattern similar to pfUI addon
2. **Fallback System**: Falls back to English if locale file is missing or key not found
3. **Function Support**: Supports both string values and function values for dynamic localization (time formatting)
4. **Backward Compatibility**: Original English strings remain as fallback

## Notes

- All translations use official Blizzard terminology for consistency
- Time formatting functions are dynamically localized for proper Chinese time expressions
- The addon maintains complete backward compatibility with English clients
- All hardcoded English strings have been replaced with `L()` function calls