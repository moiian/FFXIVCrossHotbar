-- FFXIVCrossHotbar/locales/ruRU.lua
-- Russian localization file

-- Ensure the locale is ruRU before loading
if (GetLocale() == "ruRU") then
    -- Create a global table to hold all the localized strings
    FFXIV_CP_LOCALS = {
        -- Main Panel Title
        ["SETTINGS_TITLE"] = "Настройки перекрестной панели FFXIV",

        -- Tabs
        ["TAB_MAIN"] = "Главное",
        ["TAB_HUD"] = "Интерфейс",
        ["TAB_LABEL"] = "Метки",

        -- Main Tab Content
        ["INITIALIZE_KEYS"] = "Инициализировать клавиши",
        ["INIT_KEYS_DESC"] = "Для новых пользователей, пожалуйста, нажмите здесь, чтобы настроить привязку клавиш.\nЗатем используйте программное обеспечение для назначения соответствующих кнопок на вашем контроллере.\nShift+1-8 соответствует переключению между страницами с 1 по 8.",

        -- General Buttons
        ["CLOSE"] = "Закрыть",
        ["RESET"] = "Сбросить",

        -- HUD Tab Headers
        ["HEADER_GLOBAL"] = "Глобальные настройки",
        ["HEADER_BUTTON"] = "Настройки кнопок",
        ["HEADER_BAR"] = "Настройки панели",

        -- Label Tab Headers
        ["HEADER_LABEL"] = "Настройки меток",
        ["HEADER_INDICATOR"] = "Индикатор страницы",
        ["HEADER_SEPARATOR"] = "Разделитель",

        -- Global Settings Options
        ["OPTION_GLOBAL_SCALE"] = "Общий масштаб",
        ["OPTION_VERTICAL_POS"] = "Вертикальное положение",
        ["OPTION_HORIZONTAL_POS"] = "Горизонтальное положение",

        -- Button Settings Options
        ["OPTION_BUTTON_SIZE"] = "Размер кнопок",
        ["OPTION_BUTTON_SPACING"] = "Расстояние между кнопками",
        ["OPTION_INNER_SPACING"] = "Внутренний отступ",
        ["OPTION_GROUP_OFFSET"] = "Смещение группы",

        -- Bar Settings Options
        ["OPTION_BAR_SPACING"] = "Расстояние между панелями",
        ["OPTION_ACTIVE_SCALE"] = "Масштаб активной",
        ["OPTION_INACTIVE_SCALE"] = "Масштаб неактивной",

        -- Label Settings Options
        ["OPTION_SHOW_LABELS"] = "Показать метки",
        ["OPTION_LABEL_Y_OFFSET"] = "Смещение метки по Y",
        ["OPTION_LABEL_FONT_SIZE"] = "Размер шрифта метки",

        -- Page Indicator Options
        ["OPTION_SHOW_INDICATOR"] = "Показать индикатор",
        ["OPTION_INDICATOR_X"] = "Смещение индикатора по X",
        ["OPTION_INDICATOR_Y"] = "Смещение индикатора по Y",

        -- Separator Options
        ["OPTION_SHOW_SEPARATOR"] = "Показать разделитель",
        ["OPTION_SEPARATOR_WIDTH"] = "Ширина разделителя",
        ["OPTION_SEPARATOR_HEIGHT"] = "Высота разделителя",
		
		["INDICATOR_PREFIX"] = "Стр.",
    };
end
