-- FFXIVCrossHotbar/locales/zhTW.lua
-- Traditional Chinese (Taiwan) localization file

-- Ensure the locale is zhTW before loading
if (GetLocale() == "zhTW") then
    -- Create a global table to hold all the localized strings
    FFXIV_CP_LOCALS = {
        -- Main Panel Title
        ["SETTINGS_TITLE"] = "FFXIV 十字熱鍵列設定",

        -- Tabs
        ["TAB_MAIN"] = "主要",
        ["TAB_HUD"] = "HUD",
        ["TAB_LABEL"] = "標籤",

        -- Main Tab Content
        ["INITIALIZE_KEYS"] = "初始化按鍵",
        ["INIT_KEYS_DESC"] = "首次使用的使用者，請點擊此處設定按鍵綁定。\n然後使用軟體對應您控制器上的按鈕。\nShift+1-8 對應切換 1 至 8 頁。",

        -- General Buttons
        ["CLOSE"] = "關閉",
        ["RESET"] = "重設",

        -- HUD Tab Headers
        ["HEADER_GLOBAL"] = "全域設定",
        ["HEADER_BUTTON"] = "按鈕設定",
        ["HEADER_BAR"] = "熱鍵列設定",

        -- Label Tab Headers
        ["HEADER_LABEL"] = "標籤設定",
        ["HEADER_INDICATOR"] = "頁碼指示器",
        ["HEADER_SEPARATOR"] = "分隔線",

        -- Global Settings Options
        ["OPTION_GLOBAL_SCALE"] = "整體縮放",
        ["OPTION_VERTICAL_POS"] = "垂直位置",
        ["OPTION_HORIZONTAL_POS"] = "水平位置",

        -- Button Settings Options
        ["OPTION_BUTTON_SIZE"] = "按鈕大小",
        ["OPTION_BUTTON_SPACING"] = "按鈕間距",
        ["OPTION_INNER_SPACING"] = "內部間距",
        ["OPTION_GROUP_OFFSET"] = "群組偏移",

        -- Bar Settings Options
        ["OPTION_BAR_SPACING"] = "熱鍵列間距",
        ["OPTION_ACTIVE_SCALE"] = "啟用時縮放",
        ["OPTION_INACTIVE_SCALE"] = "未啟用時縮放",

        -- Label Settings Options
        ["OPTION_SHOW_LABELS"] = "顯示標籤",
        ["OPTION_LABEL_Y_OFFSET"] = "標籤 Y 軸偏移",
        ["OPTION_LABEL_FONT_SIZE"] = "標籤字型大小",

        -- Page Indicator Options
        ["OPTION_SHOW_INDICATOR"] = "顯示指示器",
        ["OPTION_INDICATOR_X"] = "指示器 X 軸偏移",
        ["OPTION_INDICATOR_Y"] = "指示器 Y 軸偏移",

        -- Separator Options
        ["OPTION_SHOW_SEPARATOR"] = "顯示分隔線",
        ["OPTION_SEPARATOR_WIDTH"] = "分隔線寬度",
        ["OPTION_SEPARATOR_HEIGHT"] = "分隔線高度",
		
		["INDICATOR_PREFIX"] = "熱鍵欄",
    };
end
