-- FFXIVCrossHotbar/locales/deDE.lua
-- German localization file

-- Ensure the locale is deDE before loading
if (GetLocale() == "deDE") then
    -- Create a global table to hold all the localized strings
    FFXIV_CP_LOCALS = {
        -- Main Panel Title
        ["SETTINGS_TITLE"] = "FFXIV Cross-Hotbar-Einstellungen",

        -- Tabs
        ["TAB_MAIN"] = "Haupt",
        ["TAB_HUD"] = "HUD",
        ["TAB_LABEL"] = "Beschriftung",
        ["TAB_KEYBINDING"] = "Tastenbelegung",

        -- Main Tab Content
        ["INITIALIZE_KEYS"] = "Tasten initialisieren",
        ["INIT_KEYS_DESC"] = "Für neue Benutzer, bitte klicken Sie hier, um die Tastenbelegungen einzurichten.\nVerwenden Sie dann die Software, um die entsprechenden Tasten auf Ihrem Controller zuzuweisen.\nShift+1-8 entspricht dem Wechsel zwischen den Seiten 1 bis 8.",
        ["OPTION_SET_HUD_KEYBINDING"] = "HUD-Tastenbelegung festlegen",

        -- Keybinding Tab Content
        ["KEYBINDING_DESC_1"] = "[Basis]\nA\nLB\nLT\nRT\nLT + RT\nRB\nRB + XYBA←↑→↓\nRB + LB",
        ["KEYBINDING_DESC_1R"] = "\nSpringen\nNächstes feindliches Ziel anvisieren\nLinke Hotbar aktivieren\nRechte Hotbar aktivieren\nSpezial-Hotbar aktivieren\nSeiten-Modifikator\nZu den Seiten 1-8 wechseln\nAutomatisches Laufen umschalten",
        ["KEYBINDING_DESC_2"] = "[HUD]\n\nX\nY\nB\nD-Pad Links\nD-Pad Oben\nD-Pad Rechts\nD-Pad Unten",
        ["KEYBINDING_DESC_2R"] = "\n\nNächsten Freund anvisieren\nWeltkarte umschalten\nSpielmenü umschalten\nQuestlog umschalten\nCharakterfenster umschalten\nAlle Taschen öffnen\nZauberbuch umschalten",

        -- General Buttons
        ["CLOSE"] = "Schließen",
        ["RESET"] = "Zurücksetzen",

        -- HUD Tab Headers
        ["HEADER_GLOBAL"] = "Globale Einstellungen",
        ["HEADER_BUTTON"] = "Tasten-Einstellungen",
        ["HEADER_BAR"] = "Leisten-Einstellungen",

        -- Label Tab Headers
        ["HEADER_LABEL"] = "Beschriftungs-Einstellungen",
        ["HEADER_INDICATOR"] = "Seitenanzeige",
        ["HEADER_SEPARATOR"] = "Trennzeichen",

        -- Global Settings Options
        ["OPTION_GLOBAL_SCALE"] = "Globale Skalierung",
        ["OPTION_VERTICAL_POS"] = "Vertikale Position",
        ["OPTION_HORIZONTAL_POS"] = "Horizontale Position",

        -- Button Settings Options
        ["OPTION_BUTTON_SIZE"] = "Tastengröße",
        ["OPTION_BUTTON_SPACING"] = "Tastenabstand",
        ["OPTION_INNER_SPACING"] = "Innerer Abstand",
        ["OPTION_GROUP_OFFSET"] = "Gruppenversatz",

        -- Bar Settings Options
        ["OPTION_BAR_SPACING"] = "Leistenabstand",
        ["OPTION_ACTIVE_SCALE"] = "Aktive Skalierung",
        ["OPTION_INACTIVE_SCALE"] = "Inaktive Skalierung",

        -- Label Settings Options
        ["OPTION_SHOW_LABELS"] = "Beschriftungen anzeigen",
        ["OPTION_LABEL_Y_OFFSET"] = "Y-Versatz der Beschriftung",
        ["OPTION_LABEL_FONT_SIZE"] = "Schriftgröße der Beschriftung",

        -- Page Indicator Options
        ["OPTION_SHOW_INDICATOR"] = "Anzeige anzeigen",
        ["OPTION_INDICATOR_X"] = "X-Versatz der Anzeige",
        ["OPTION_INDICATOR_Y"] = "Y-Versatz der Anzeige",

        -- Separator Options
        ["OPTION_SHOW_SEPARATOR"] = "Trennzeichen anzeigen",
        ["OPTION_SEPARATOR_WIDTH"] = "Breite des Trennzeichens",
        ["OPTION_SEPARATOR_HEIGHT"] = "Höhe des Trennzeichens",
		
		["INDICATOR_PREFIX"] = "SEITE",
    };
end
