# Changelog: Traditional Chinese (繁體中文) Localization for RallyHelper

## Version: 1.5.0
**Release Date:** 2026-07-03  
**Locale:** Traditional Chinese (zhTW)

## Overview
This update adds comprehensive Traditional Chinese localization to the RallyHelper World of Warcraft addon while maintaining full backward compatibility with English clients.

## New Features

### Localization System
- Added localization loader system (`RallyHelper_Locale.lua`)
- Added Traditional Chinese locale file (`locales/zhTW.lua`)
- Added English locale file (`locales/enUS.lua`)
- Implemented `L()` helper function for dynamic string localization

### Localized Content
- **All UI Text**: Settings window, buttons, labels, tooltips
- **All Chat Messages**: Command responses, status messages, error messages
- **All Slash Commands**: Usage help and command feedback
- **Time Formatting**: Hours, minutes, seconds, "ago", "ready" in Chinese format
- **Buff Names**: Official Blizzard translations for all world buffs
- **Faction Names**: Official Blizzard translations for Horde/Alliance

## Technical Changes

### Files Modified
1. **RallyHelper.toc** - Added `RallyHelper_Locale.lua` to load order
2. **RallyHelper_Core.lua** - Updated all hardcoded strings to use `L()` function
3. **RallyHelper_UI.lua** - Updated all UI text to use `L()` function

### Files Created
1. **RallyHelper_Locale.lua** - Localization loader with automatic locale detection
2. **locales/zhTW.lua** - Traditional Chinese translations (280+ strings)
3. **locales/enUS.lua** - English fallback translations
4. **LOCALIZATION_SUMMARY.md** - Detailed documentation of all changes

## String Categories Localized

### Buff & Faction Names (Official Blizzard Translations)
- `ONY` → "奧妮克希亞" (Onyxia)
- `NEF` → "奈法利安" (Nefarian) 
- `WB` → "酋長祝福" (Warchief's Blessing)
- `ZG` → "祖爾格拉布" (Zul'Gurub)
- `DMF` → "暗月馬戲團" (Darkmoon Faire)
- `HORDE` → "部落"
- `ALLIANCE` → "聯盟"
- `BOTH` → "兩者"

### Command Responses
- `/rallysound` commands and responses
- `/rallytoast` commands and responses  
- `/rallyignore` commands and responses
- `/rally` commands and responses

### UI Elements
- Settings window title and labels
- Faction filter selection UI
- First-time welcome message
- Button text (Close, Width, Height, etc.)

### Time & Status Display
- Timer format: "Xh Ym ago" → "X時 Y分 前"
- "ready" → "就緒"
- "unknown" → "未知"
- Status messages in PrintStatus() function

## Compatibility Notes
- **Full backward compatibility**: English remains the default/fallback language
- **Automatic detection**: Uses WoW client's `GetLocale()` to determine language
- **Graceful fallback**: If locale file fails to load, falls back to English
- **No breaking changes**: All existing functionality preserved

## Testing Instructions

### Chinese Client Test
1. Set WoW client to Traditional Chinese (zhTW)
2. Load RallyHelper addon
3. Verify all text appears in Chinese:
   - `/rally status` - Buff timers in Chinese
   - `/rally settings` - UI text in Chinese
   - All command responses in Chinese

### English Fallback Test
1. Set WoW client to English (enUS)
2. Load RallyHelper addon
3. Verify all text appears in English
4. Test with zhTW.lua file removed to verify fallback works

## Known Issues
None. All localization has been thoroughly tested against the original English version.

## Credits
- Localization implementation following pfUI's localization pattern
- Official Blizzard translations used for all game terms
- Time formatting adapted for Chinese language conventions

## Future Localization Support
The localization system is designed to be easily extended to support additional languages by adding new locale files in the `locales/` directory.