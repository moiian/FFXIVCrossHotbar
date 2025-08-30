-- FFXIVCrossHotbar/FFXIVConfigPanel.lua
-- 作者: Aelinore
-- 版本: 3.1.3
-- 描述: FFXIVCrossHotbar 的配置面板UI 

local FFXIV_CP = {}; -- CP for Config Panel

-- -----------------------------------------------------------------------------
-- 辅助函数
-- -----------------------------------------------------------------------------

-- 更新滑块旁边的数值显示
local function UpdateSliderVisuals(slider)
    if not slider or not slider.valueText then return end;
    local value = slider:GetValue();
    local step = slider:GetValueStep();
    local outValue;
    if step >= 1 then
        outValue = math.floor(value + 0.5);
    else
        outValue = string.format("%.2f", value);
    end
    slider.valueText:SetText(tostring(outValue));
end

-- 递归地根据 key path 设置数据库中的值
local function SetDBValue(keyPath, value)
    if not CrossHotbarDB then return end;
    local keys = {};
    for k in string.gfind(keyPath, "[^%.]+") do table.insert(keys, k) end;
    
    local targetTable = CrossHotbarDB;
    for i = 1, table.getn(keys) - 1 do
        local currentKey = keys[i];
        if type(targetTable[currentKey]) ~= "table" then
            targetTable[currentKey] = {};
        end
        targetTable = targetTable[currentKey];
    end

    if type(targetTable) == "table" then
        targetTable[keys[table.getn(keys)]] = value;
    end
end

-- 递归地根据 key path 获取数据库中的值
local function GetDBValue(keyPath)
    if not CrossHotbarDB then return nil end;
    local keys = {};
    for k in string.gfind(keyPath, "[^%.]+") do table.insert(keys, k) end;

    local value = CrossHotbarDB;
    for i = 1, table.getn(keys) do
        if type(value) == "table" then
            value = value[keys[i]];
        else
            return nil;
        end
    end
    return value;
end


-- -----------------------------------------------------------------------------
-- 控件创建函数 (已本地化)
-- -----------------------------------------------------------------------------

local function CreateSlider(parent, option)
    local L = FFXIV_CP_LOCALS; -- 获取本地化表
    local s = CreateFrame("Slider", "FFXIVCP_Slider_"..option.key, parent, "OptionsSliderTemplate");
    s:SetMinMaxValues(option.min, option.max);
    s:SetValueStep(option.step);
    s:SetWidth(160);
    s:SetHeight(16);

    local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    lbl:SetText(L[option.text] or "MISSING_LOCALE: "..option.text); -- 从表中查找文本
    lbl:SetJustifyH("LEFT");

    local valFS = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    s.valueText = valFS;
    valFS:SetPoint("LEFT", s, "RIGHT", 10, 0);

    s:SetScript("OnValueChanged", function()
        SetDBValue(option.key, this:GetValue());
        UpdateSliderVisuals(this);
        if FFXIVCrossHotbar and FFXIVCrossHotbar.RefreshLayout then
            FFXIVCrossHotbar:RefreshLayout();
        end
    end);
    return s, lbl;
end

local function CreateCheck(parent, option)
    local L = FFXIV_CP_LOCALS; -- 获取本地化表
    local cb = CreateFrame("CheckButton", "FFXIVCP_Check_"..option.key, parent, "UICheckButtonTemplate");
    cb:SetWidth(26);
    cb:SetHeight(26);
    local lbl = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    lbl:SetText(L[option.text] or "MISSING_LOCALE: "..option.text); -- 从表中查找文本
    lbl:SetJustifyH("LEFT");

    cb:SetScript("OnClick", function()
        --  GetChecked() 返回 1 或 nil，需要转换为 true/false
        SetDBValue(option.key, (this:GetChecked() == 1));
        if FFXIVCrossHotbar and FFXIVCrossHotbar.RefreshLayout then
            FFXIVCrossHotbar:RefreshLayout();
        end
    end);
    return cb, lbl;
end

-- -----------------------------------------------------------------------------
-- 面板UI创建
-- -----------------------------------------------------------------------------

function FFXIV_CP:CreatePanel()
    if FFXIVConfigPanelFrame then return end;
    
    --  增强的本地化回退逻辑
    -- 检查全局本地化表是否存在且不为空
    if not FFXIV_CP_LOCALS or next(FFXIV_CP_LOCALS) == nil then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFFF00FFXIVCrossHotbar Warning: Localization file not found or is empty. Defaulting to English.|r");
        -- 如果不存在或为空，则创建并设置一个完整的备用(英文)本地化表
        FFXIV_CP_LOCALS = {
            ["SETTINGS_TITLE"] = "FFXIV Cross Hotbar Settings",
            ["TAB_MAIN"] = "Main", ["TAB_HUD"] = "HUD", ["TAB_LABEL"] = "Label", ["TAB_KEYBINDING"] = "Keybind",
            ["INITIALIZE_KEYS"] = "Initialize Keys", ["INIT_KEYS_DESC"] = "For first-time users, please click here to set up key bindings.\nThen use the software to map the corresponding buttons on your controller.\nShift+1-8 corresponds to switching between pages 1 to 8.",
            ["OPTION_SET_HUD_KEYBINDING"] = "Set HUD Keybinding",
			["KEYBINDING_DESC_1"] = "A\nLB\nLT\nRT\nLT + RT\nRB\nRB + (X,Y,B,A,D-Pad)\nRB + LB",
			["KEYBINDING_DESC_1R"] = "Jump\nTarget Nearest Enemy\nActivate Left Hotbar\nActivate Right Hotbar\nActivate Special Hotbar\nPage Modifier\nSwitch to Pages 1-8\nToggle Auto-Run",
			
			["KEYBINDING_DESC_2"] = "[HUD]\n\nX\nY\nB\nD-Pad Left\nD-Pad Up\nD-Pad Right\nD-Pad Down",
			["KEYBINDING_DESC_2R"] = "\n\nTarget Nearest Friend\nToggle World Map\nToggle Game Menu\nToggle Quest Log\nToggle Character Pane\nOpen All Bags\nToggle Spellbook",


            ["CLOSE"] = "Close", ["RESET"] = "Reset",
            ["HEADER_GLOBAL"] = "Global Settings", ["HEADER_BUTTON"] = "Button Settings", ["HEADER_BAR"] = "Bar Settings",
            ["HEADER_LABEL"] = "Label Settings", ["HEADER_INDICATOR"] = "Page Indicator", ["HEADER_SEPARATOR"] = "Separator",
            ["OPTION_GLOBAL_SCALE"] = "Global Scale", ["OPTION_VERTICAL_POS"] = "Vertical Position", ["OPTION_HORIZONTAL_POS"] = "Horizontal Position",
            ["OPTION_BUTTON_SIZE"] = "Button Size", ["OPTION_BUTTON_SPACING"] = "Button Spacing", ["OPTION_INNER_SPACING"] = "Inner Spacing", ["OPTION_GROUP_OFFSET"] = "Group Offset",
            ["OPTION_BAR_SPACING"] = "Bar Spacing", ["OPTION_ACTIVE_SCALE"] = "Active Scale", ["OPTION_INACTIVE_SCALE"] = "Inactive Scale",
            ["OPTION_SHOW_LABELS"] = "Show Labels", ["OPTION_LABEL_Y_OFFSET"] = "Label Y-Offset", ["OPTION_LABEL_FONT_SIZE"] = "Label Font Size",
            ["OPTION_SHOW_INDICATOR"] = "Show Indicator", ["OPTION_INDICATOR_X"] = "Indicator X-Offset", ["OPTION_INDICATOR_Y"] = "Indicator Y-Offset",
            ["OPTION_SHOW_SEPARATOR"] = "Show Separator", ["OPTION_SEPARATOR_WIDTH"] = "Separator Width", ["OPTION_SEPARATOR_HEIGHT"] = "Separator Height", ["INDICATOR_PREFIX"] = "SET"
        };
    end
    
    local L = FFXIV_CP_LOCALS;

    -- [已本地化] 将配置项的 title 和 text 替换为本地化键 (Key)
    local ConfigOptions = {
        hud = {
            global = {
                { title = "HEADER_GLOBAL", type = "header" },
                { key = "global.scale", text = "OPTION_GLOBAL_SCALE", min = 0.5, max = 2.0, step = 0.01, type = "slider" },
                { key = "global.position.yOffset", text = "OPTION_VERTICAL_POS", min = 0, max = 500, step = 1, type = "slider" },
                { key = "global.position.xOffset", text = "OPTION_HORIZONTAL_POS", min = -500, max = 500, step = 1, type = "slider" },
            },
            button = {
                { title = "HEADER_BUTTON", type = "header" },
                { key = "buttons.size", text = "OPTION_BUTTON_SIZE", min = 20, max = 80, step = 1, type = "slider" },
                { key = "buttons.spacing", text = "OPTION_BUTTON_SPACING", min = 20, max = 80, step = 1, type = "slider" },
                { key = "buttons.crossInnerSpacing", text = "OPTION_INNER_SPACING", min = 0, max = 20, step = 1, type = "slider" },
                { key = "buttons.groupOffset", text = "OPTION_GROUP_OFFSET", min = 20, max = 150, step = 1, type = "slider" },
            },
            bar = {
                { title = "HEADER_BAR", type = "header" },
                { key = "bars.spacingFromCenter", text = "OPTION_BAR_SPACING", min = 50, max = 400, step = 1, type = "slider" },
                { key = "bars.zoomScale", text = "OPTION_ACTIVE_SCALE", min = 1.0, max = 1.5, step = 0.01, type = "slider" },
                { key = "bars.shrinkScale", text = "OPTION_INACTIVE_SCALE", min = 0.5, max = 1.0, step = 0.01, type = "slider" },
            }
        },
        label = {
            label = {
                { title = "HEADER_LABEL", type = "header" },
                { key = "labels.show", text = "OPTION_SHOW_LABELS", type = "check" },
                { key = "labels.offsetY", text = "OPTION_LABEL_Y_OFFSET", min = 0, max = 100, step = 1, type = "slider" },
                { key = "labels.fontSize", text = "OPTION_LABEL_FONT_SIZE", min = 8, max = 24, step = 1, type = "slider" },
            },
            indicator = {
                { title = "HEADER_INDICATOR", type = "header" },
                { key = "pageIndicator.show", text = "OPTION_SHOW_INDICATOR", type = "check" },
                { key = "pageIndicator.offsetX", text = "OPTION_INDICATOR_X", min = -200, max = 200, step = 1, type = "slider" },
                { key = "pageIndicator.offsetY", text = "OPTION_INDICATOR_Y", min = -200, max = 200, step = 1, type = "slider" },
            },
            separator = {
                { title = "HEADER_SEPARATOR", type = "header" },
                { key = "separator.show", text = "OPTION_SHOW_SEPARATOR", type = "check" },
                { key = "separator.width", text = "OPTION_SEPARATOR_WIDTH", min = 1, max = 10, step = 0.1, type = "slider" },
                { key = "separator.height", text = "OPTION_SEPARATOR_HEIGHT", min = 20, max = 120, step = 1, type = "slider" },
            }
        }
    };

    -- 1. 主框架
    local f = CreateFrame("Frame", "FFXIVConfigPanelFrame", UIParent);
    f:SetWidth(600); f:SetHeight(520);
    f:SetPoint("CENTER", 0, 0);
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32, 
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    });
    f:SetBackdropColor(0,0,0,0.9);
    f:SetMovable(true); f:EnableMouse(true);
    f:RegisterForDrag("LeftButton");
    f:SetScript("OnDragStart", function() this:StartMoving() end);
    f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end);
    f:Hide();
    f.ConfigOptions = ConfigOptions;

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    title:SetPoint("TOP", 0, -18);
    title:SetText(L["SETTINGS_TITLE"]);
    
    local closeBtn = CreateFrame("Button", "FFXIVCP_CloseButton", f, "UIPanelCloseButton");
    closeBtn:SetPoint("TOPRIGHT", -8, -8);

    -- 2. 标签页框架
    local mainPanel = CreateFrame("Frame", "FFXIVCP_MainPanel", f);
    mainPanel:SetPoint("TOPLEFT", 12, -60); mainPanel:SetPoint("BOTTOMRIGHT", -12, 12);
    
    local hudPanel = CreateFrame("Frame", "FFXIVCP_HUDPanel", f);
    hudPanel:SetPoint("TOPLEFT", 12, -60); hudPanel:SetPoint("BOTTOMRIGHT", -12, 12);
    hudPanel:Hide();
    
    local labelPanel = CreateFrame("Frame", "FFXIVCP_LabelPanel", f);
    labelPanel:SetPoint("TOPLEFT", 12, -60); labelPanel:SetPoint("BOTTOMRIGHT", -12, 12);
    labelPanel:Hide();
    
    local keybindingPanel = CreateFrame("Frame", "FFXIVCP_KeybindingPanel", f);
    keybindingPanel:SetPoint("TOPLEFT", 12, -60); keybindingPanel:SetPoint("BOTTOMRIGHT", -12, 12);
    keybindingPanel:Hide();

    -- 3. 标签页按钮
    PanelTemplates_SetNumTabs(f, 4);
    local tabMain = CreateFrame("CheckButton", "FFXIVCP_Tab_Main", f, "CharacterFrameTabButtonTemplate");
    tabMain:SetText(L["TAB_MAIN"]);
    tabMain:SetPoint("TOPLEFT", f, "TOPLEFT", 15, 0);
    tabMain:SetChecked(true);

    local tabHUD = CreateFrame("CheckButton", "FFXIVCP_Tab_HUD", f, "CharacterFrameTabButtonTemplate");
    tabHUD:SetText(L["TAB_HUD"]);
    tabHUD:SetPoint("LEFT", tabMain, "RIGHT", -15, 0);
    
    local tabLabel = CreateFrame("CheckButton", "FFXIVCP_Tab_Label", f, "CharacterFrameTabButtonTemplate");
    tabLabel:SetText(L["TAB_LABEL"]);
    tabLabel:SetPoint("LEFT", tabHUD, "RIGHT", -15, 0);
    
    local tabKeybinding = CreateFrame("CheckButton", "FFXIVCP_Tab_Keybinding", f, "CharacterFrameTabButtonTemplate");
    tabKeybinding:SetText(L["TAB_KEYBINDING"]);
    tabKeybinding:SetPoint("TOPRIGHT", f, "TOPRIGHT", -35, 0);
    
    local function selectTab(selectedTab)
        tabMain:SetChecked(selectedTab == tabMain);
        tabHUD:SetChecked(selectedTab == tabHUD);
        tabLabel:SetChecked(selectedTab == tabLabel);
        tabKeybinding:SetChecked(selectedTab == tabKeybinding);
        
        if selectedTab == tabMain then mainPanel:Show() else mainPanel:Hide() end;
        if selectedTab == tabHUD then hudPanel:Show() else hudPanel:Hide() end;
        if selectedTab == tabLabel then labelPanel:Show() else labelPanel:Hide() end;
        if selectedTab == tabKeybinding then keybindingPanel:Show() else keybindingPanel:Hide() end;
    end
    
    tabMain:SetScript("OnClick", function() selectTab(tabMain) end);
    tabHUD:SetScript("OnClick", function() selectTab(tabHUD) end);
    tabLabel:SetScript("OnClick", function() selectTab(tabLabel) end);
    tabKeybinding:SetScript("OnClick", function() selectTab(tabKeybinding) end);

    -- 4. 填充 "Main" 标签页
    do
        -- 图片布局配置
        local imageLayout = {
            avatarWidth = 68,
            avatarHeight = 68,
            avatarSpacing = 20, -- 图片与下方按钮的间距

            gamepadWidth = 480,
            gamepadHeight = 240,
            gamepadSpacing = -20 -- 图片与上方文字的间距
        }

        -- 将初始化按钮作为中心锚点
        local initButton = CreateFrame("Button", "FFXIVCP_InitButton", mainPanel, "UIPanelButtonTemplate");
        initButton:SetWidth(150); initButton:SetHeight(25);
        initButton:SetText(L["INITIALIZE_KEYS"]);
        initButton:SetPoint("CENTER", 0, 95); -- 稍微下移为勾选框腾出空间
        initButton:SetScript("OnClick", function()
            if FFXIVCrossHotbar and FFXIVCrossHotbar.SetDefaultKeybindings then
                FFXIVCrossHotbar:SetDefaultKeybindings();
            end
            MainMenuBar:Hide();
        end);

        -- 创建HUD按键绑定的勾选框
        local hudCheck, hudCheckLabel = CreateCheck(mainPanel, {
            key = "global.setHUDKeybinding", 
            text = "OPTION_SET_HUD_KEYBINDING" 
        });
        -- 将勾选框水平居中，并放置在初始化按钮上方
        hudCheck:SetPoint("BOTTOM", initButton, "TOP", -75, 0);
        hudCheckLabel:SetPoint("LEFT", hudCheck, "RIGHT", 5, 0);
        
        -- 角色头像图片 (位于新勾选按钮上方)
        local avatar = mainPanel:CreateTexture("FFXIVCP_AvatarImage", "ARTWORK");
        avatar:SetTexture("Interface\\AddOns\\FFXIVCrossHotbar\\src\\assets\\main\\ffxiv.tga");
        avatar:SetWidth(imageLayout.avatarWidth);
        avatar:SetHeight(imageLayout.avatarHeight);
        avatar:SetPoint("BOTTOM", hudCheck, "TOP", 75, imageLayout.avatarSpacing);

        -- 初始化按钮下方的描述文字
        local initLabel = mainPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
        initLabel:SetPoint("TOP", initButton, "BOTTOM", 0, -10);
        initLabel:SetText(L["INIT_KEYS_DESC"]);

        -- 手柄映射图片 (位于文字下方)
        local gamepad = mainPanel:CreateTexture("FFXIVCP_GamepadImage", "ARTWORK");
        gamepad:SetTexture("Interface\\AddOns\\FFXIVCrossHotbar\\src\\assets\\main\\gamepad.tga");
        gamepad:SetWidth(imageLayout.gamepadWidth);
        gamepad:SetHeight(imageLayout.gamepadHeight);
        gamepad:SetPoint("TOP", initLabel, "BOTTOM", 0, imageLayout.gamepadSpacing);
    end

    -- 4.5. 填充 "Keybinding" 标签页
    do
        -- 左侧文字标签
        local keybindLabel1 = keybindingPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal");
        keybindLabel1:SetPoint("TOPLEFT", 50, -40);
        keybindLabel1:SetJustifyH("LEFT");
        keybindLabel1:SetJustifyV("TOP");
        keybindLabel1:SetText(L["KEYBINDING_DESC_1"]);
		keybindLabel1:SetTextColor(1, 1, 1);
		
		local keybindLabel1R = keybindingPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal");
        keybindLabel1R:SetPoint("TOPLEFT", keybindLabel1,"TOPRIGHT", 10, 0);
        keybindLabel1R:SetJustifyH("LEFT");
        keybindLabel1R:SetJustifyV("TOP");
        keybindLabel1R:SetText(L["KEYBINDING_DESC_1R"]);
		keybindLabel1R:SetTextColor(1, 1, 1);

        -- 右侧文字标签
        local keybindLabel2 = keybindingPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal");
        keybindLabel2:SetPoint("TOPLEFT", keybindLabel1R, "TOPRIGHT", 60, 0);
        --keybindLabel2:SetWidth(250);
        keybindLabel2:SetJustifyH("LEFT");
        keybindLabel2:SetJustifyV("TOP");
        keybindLabel2:SetText(L["KEYBINDING_DESC_2"]);
        keybindLabel2:SetTextColor(1, 1, 1);
		
		local keybindLabel2R = keybindingPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal");
        keybindLabel2R:SetPoint("TOPLEFT", keybindLabel2, "TOPRIGHT", 10, 0);
        keybindLabel2R:SetWidth(250);
        keybindLabel2R:SetJustifyH("LEFT");
        keybindLabel2R:SetJustifyV("TOP");
        keybindLabel2R:SetText(L["KEYBINDING_DESC_2R"]);
        keybindLabel2R:SetTextColor(1, 1, 1);		
		
        -- 手柄图片
        local gamepad = keybindingPanel:CreateTexture("FFXIVCP_KeybindGamepadImage", "ARTWORK");
        gamepad:SetTexture("Interface\\AddOns\\FFXIVCrossHotbar\\src\\assets\\main\\gamepad.tga");
        gamepad:SetWidth(480);
        gamepad:SetHeight(240);
        gamepad:SetPoint("BOTTOM", keybindingPanel, "BOTTOM", 0, 6);
    end

    -- 5. 填充 "HUD" 和 "Label" 标签页
    do
        local LayoutConstants = {
            COLUMN_1_X = 50,
            COLUMN_2_X = 350,
            CHECKBOX_LABEL_X_OFFSET = 5,
            ROW_1_Y = -15,
            ROW_2_Y = -220,
            HEADER_Y_SPACING = 40,
            ITEM_Y_SPACING = 50,
            SLIDER_LABEL_Y_OFFSET = 0,
        }

        local function populateSection(panel, sectionData, startX, startY)
            local currentY = startY;
            for _, option in pairs(sectionData) do
                if option.type == "header" then
                    local header = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
                    header:SetPoint("TOPLEFT", startX, currentY);
                    header:SetText(L[option.title] or "MISSING_LOCALE: "..option.title);
                    currentY = currentY - LayoutConstants.HEADER_Y_SPACING;
                elseif option.type == "slider" then
                    local slider, label = CreateSlider(panel, option);
                    label:SetPoint("TOPLEFT", startX, currentY+10);	--滑条位置
                    slider:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, LayoutConstants.SLIDER_LABEL_Y_OFFSET);
                    currentY = currentY - LayoutConstants.ITEM_Y_SPACING;
                elseif option.type == "check" then
                    local check, label = CreateCheck(panel, option);
                    check:SetPoint("TOPLEFT", startX, currentY);
                    label:SetPoint("LEFT", check, "RIGHT", LayoutConstants.CHECKBOX_LABEL_X_OFFSET, 0);
                    currentY = currentY - LayoutConstants.ITEM_Y_SPACING;
                end
            end
        end

        -- 填充HUD页面
        populateSection(hudPanel, ConfigOptions.hud.global, LayoutConstants.COLUMN_1_X, LayoutConstants.ROW_1_Y);
        populateSection(hudPanel, ConfigOptions.hud.button, LayoutConstants.COLUMN_2_X, LayoutConstants.ROW_1_Y);
        populateSection(hudPanel, ConfigOptions.hud.bar,    LayoutConstants.COLUMN_1_X, LayoutConstants.ROW_2_Y);
        
        -- 填充Label页面
        populateSection(labelPanel, ConfigOptions.label.label,     LayoutConstants.COLUMN_1_X, LayoutConstants.ROW_1_Y);
        populateSection(labelPanel, ConfigOptions.label.indicator, LayoutConstants.COLUMN_2_X, LayoutConstants.ROW_1_Y);
        populateSection(labelPanel, ConfigOptions.label.separator, LayoutConstants.COLUMN_1_X, LayoutConstants.ROW_2_Y);
        
        -- 为每个页面添加重置和关闭按钮
        local function addControlButtons(panel)
            local closeButton = CreateFrame("Button", panel:GetName().."CloseButton", panel, "UIPanelButtonTemplate");
            closeButton:SetWidth(100); closeButton:SetHeight(22);
            closeButton:SetText(L["CLOSE"]);
            closeButton:SetPoint("BOTTOMRIGHT", -5, 5);
            closeButton:SetScript("OnClick", function() f:Hide() end);

            local resetButton = CreateFrame("Button", panel:GetName().."ResetButton", panel, "UIPanelButtonTemplate");
            resetButton:SetWidth(100); resetButton:SetHeight(22);
            resetButton:SetText(L["RESET"]);
            resetButton:SetPoint("RIGHT", closeButton, "LEFT", -10, 0);
            resetButton:SetScript("OnClick", function() CrossHotbarDB = nil; ReloadUI(); end);
        end
        addControlButtons(mainPanel);
        addControlButtons(hudPanel);
        addControlButtons(labelPanel);
        addControlButtons(keybindingPanel);
    end

    -- 6. OnShow 逻辑
    f:SetScript("OnShow", function()
        if not CrossHotbarDB or not this.ConfigOptions then return end;
        
        local allOptions = {};
        for _, region in pairs(this.ConfigOptions.hud) do for _, opt in pairs(region) do table.insert(allOptions, opt) end end
        for _, region in pairs(this.ConfigOptions.label) do for _, opt in pairs(region) do table.insert(allOptions, opt) end end

        for _, option in pairs(allOptions) do
            if option.key then
                local value = GetDBValue(option.key);
                if value ~= nil then
                    if option.type == "slider" then
                        local slider = _G["FFXIVCP_Slider_"..option.key];
                        if slider then slider:SetValue(value); UpdateSliderVisuals(slider); end
                    elseif option.type == "check" then
                        local check = _G["FFXIVCP_Check_"..option.key];
                        if check then check:SetChecked(value); end
                    end
                end
            end
        end

        -- 手动更新主面板上勾选框的状态
        local setHUDValue = GetDBValue("global.setHUDKeybinding");
        local setHUDCheck = _G["FFXIVCP_Check_global.setHUDKeybinding"];
        if setHUDCheck and setHUDValue ~= nil then
            setHUDCheck:SetChecked(setHUDValue);
        end
    end);
end

-- -----------------------------------------------------------------------------
-- 事件和命令注册
-- -----------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame");
eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "FFXIVCrossHotbar" then
        FFXIV_CP:CreatePanel();
        if FFXIVCrossHotbar and SlashCmdList and SlashCmdList["FFXIVCROSSHOTBAR"] then
            local oldCmdFunc = SlashCmdList["FFXIVCROSSHOTBAR"];
            SlashCmdList["FFXIVCROSSHOTBAR"] = function(msg)
                local firstWord = "";
                for word in string.gfind(msg or "", "%S+") do firstWord = word; break; end
                local cmd = string.lower(firstWord);
                
                if cmd == "config" then
                    if FFXIVConfigPanelFrame then
                        if FFXIVConfigPanelFrame:IsShown() then FFXIVConfigPanelFrame:Hide();
                        else FFXIVConfigPanelFrame:Show(); end
                    end
                else
                    oldCmdFunc(msg);
                end
            end
        end
        this:UnregisterEvent("ADDON_LOADED");
    end
end);

