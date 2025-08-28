-- FFXIVCrossHotbar/locales/frFR.lua
-- French localization file

-- Ensure the locale is frFR before loading
if (GetLocale() == "frFR") then
    -- Create a global table to hold all the localized strings
    FFXIV_CP_LOCALS = {
        -- Main Panel Title
        ["SETTINGS_TITLE"] = "Paramètres de la barre de raccourcis croisée FFXIV",

        -- Tabs
        ["TAB_MAIN"] = "Principal",
        ["TAB_HUD"] = "ATH",
        ["TAB_LABEL"] = "Étiquette",

        -- Main Tab Content
        ["INITIALIZE_KEYS"] = "Initialiser les touches",
        ["INIT_KEYS_DESC"] = "Pour les nouveaux utilisateurs, veuillez cliquer ici pour configurer les raccourcis clavier.\nUtilisez ensuite le logiciel pour mapper les boutons correspondants sur votre manette.\nMaj+1-8 correspond au passage entre les pages 1 à 8.",

        -- General Buttons
        ["CLOSE"] = "Fermer",
        ["RESET"] = "Réinitialiser",

        -- HUD Tab Headers
        ["HEADER_GLOBAL"] = "Paramètres globaux",
        ["HEADER_BUTTON"] = "Paramètres des boutons",
        ["HEADER_BAR"] = "Paramètres de la barre",

        -- Label Tab Headers
        ["HEADER_LABEL"] = "Paramètres des étiquettes",
        ["HEADER_INDICATOR"] = "Indicateur de page",
        ["HEADER_SEPARATOR"] = "Séparateur",

        -- Global Settings Options
        ["OPTION_GLOBAL_SCALE"] = "Échelle globale",
        ["OPTION_VERTICAL_POS"] = "Position verticale",
        ["OPTION_HORIZONTAL_POS"] = "Position horizontale",

        -- Button Settings Options
        ["OPTION_BUTTON_SIZE"] = "Taille des boutons",
        ["OPTION_BUTTON_SPACING"] = "Espacement des boutons",
        ["OPTION_INNER_SPACING"] = "Espacement intérieur",
        ["OPTION_GROUP_OFFSET"] = "Décalage du groupe",

        -- Bar Settings Options
        ["OPTION_BAR_SPACING"] = "Espacement de la barre",
        ["OPTION_ACTIVE_SCALE"] = "Échelle active",
        ["OPTION_INACTIVE_SCALE"] = "Échelle inactive",

        -- Label Settings Options
        ["OPTION_SHOW_LABELS"] = "Afficher les étiquettes",
        ["OPTION_LABEL_Y_OFFSET"] = "Décalage Y de l'étiquette",
        ["OPTION_LABEL_FONT_SIZE"] = "Taille de police de l'étiquette",

        -- Page Indicator Options
        ["OPTION_SHOW_INDICATOR"] = "Afficher l'indicateur",
        ["OPTION_INDICATOR_X"] = "Décalage X de l'indicateur",
        ["OPTION_INDICATOR_Y"] = "Décalage Y de l'indicateur",

        -- Separator Options
        ["OPTION_SHOW_SEPARATOR"] = "Afficher le séparateur",
        ["OPTION_SEPARATOR_WIDTH"] = "Largeur du séparateur",
        ["OPTION_SEPARATOR_HEIGHT"] = "Hauteur du séparateur",
		
		["INDICATOR_PREFIX"] = "SET",
    };
end
