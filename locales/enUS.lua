-- FFXIVCrossHotbar/locales/enUS.lua
-- English localization file

-- Ensure the locale is enUS before loading
if (GetLocale() == "enUS") then
    -- Create a global table to hold all the localized strings
    FFXIV_CP_LOCALS = {
        -- Main Panel Title
        ["SETTINGS_TITLE"] = "FFXIV Cross Hotbar Settings",

        -- Tabs
        ["TAB_MAIN"] = "Main",
        ["TAB_HUD"] = "HUD",
        ["TAB_LABEL"] = "Label",
        ["TAB_KEYBINDING"] = "Keybind",

        -- Main Tab Content
        ["INITIALIZE_KEYS"] = "Initialize Keys",
        ["INIT_KEYS_DESC"] = "For first-time users, please click here to set up key bindings.\nThen use the software to map the corresponding buttons on your controller.\nShift+1-8 corresponds to switching between pages 1 to 8.",
        ["OPTION_SET_HUD_KEYBINDING"] = "Set HUD Keybinding",

        -- Keybinding Tab Content
        ["KEYBINDING_DESC_1"] = "[Base]\nA\nLB\nLT\nRT\nLT + RT\nRB\nRB + XYBA←↑→↓\nRB + LB",
        ["KEYBINDING_DESC_1R"] = "\nJump\nTarget Nearest Enemy\nActivate Left Hotbar\nActivate Right Hotbar\nActivate Special Hotbar\nPage Modifier\nSwitch to Pages 1-8\nToggle Auto-Run",
		["KEYBINDING_DESC_2"] = "[HUD]\n\nX\nY\nB\nD-Pad Left\nD-Pad Up\nD-Pad Right\nD-Pad Down",
		["KEYBINDING_DESC_2R"] = "\n\nTarget Nearest Friend\nToggle World Map\nToggle Game Menu\nToggle Quest Log\nToggle Character Pane\nOpen All Bags\nToggle Spellbook",


        -- General Buttons
        ["CLOSE"] = "Close",
        ["RESET"] = "Reset",

        -- HUD Tab Headers
        ["HEADER_GLOBAL"] = "Global Settings",
        ["HEADER_BUTTON"] = "Button Settings",
        ["HEADER_BAR"] = "Bar Settings",

        -- Label Tab Headers
        ["HEADER_LABEL"] = "Label Settings",
        ["HEADER_INDICATOR"] = "Page Indicator",
        ["HEADER_SEPARATOR"] = "Separator",

        -- Global Settings Options
        ["OPTION_GLOBAL_SCALE"] = "Global Scale",
        ["OPTION_VERTICAL_POS"] = "Vertical Position",
        ["OPTION_HORIZONTAL_POS"] = "Horizontal Position",

        -- Button Settings Options
        ["OPTION_BUTTON_SIZE"] = "Button Size",
        ["OPTION_BUTTON_SPACING"] = "Button Spacing",
        ["OPTION_INNER_SPACING"] = "Inner Spacing",
        ["OPTION_GROUP_OFFSET"] = "Group Offset",

        -- Bar Settings Options
        ["OPTION_BAR_SPACING"] = "Bar Spacing",
        ["OPTION_ACTIVE_SCALE"] = "Active Scale",
        ["OPTION_INACTIVE_SCALE"] = "Inactive Scale",

        -- Label Settings Options
        ["OPTION_SHOW_LABELS"] = "Show Labels",
        ["OPTION_LABEL_Y_OFFSET"] = "Label Y-Offset",
        ["OPTION_LABEL_FONT_SIZE"] = "Label Font Size",

        -- Page Indicator Options
        ["OPTION_SHOW_INDICATOR"] = "Show Indicator",
        ["OPTION_INDICATOR_X"] = "Indicator X-Offset",
        ["OPTION_INDICATOR_Y"] = "Indicator Y-Offset",

        -- Separator Options
        ["OPTION_SHOW_SEPARATOR"] = "Show Separator",
        ["OPTION_SEPARATOR_WIDTH"] = "Separator Width",
        ["OPTION_SEPARATOR_HEIGHT"] = "Separator Height",
		
		["INDICATOR_PREFIX"] = "SET",
    };
end

