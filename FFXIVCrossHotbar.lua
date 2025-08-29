-- FFXIVCrossHotbar/FFXIVCrossHotbar.lua
-- 作者: Aelinore
-- 版本: 3.1.2
-- 描述: 为技能按钮添加冷却时间数字显示。

-- -----------------------------------------------------------------------------
-- 调试信息
-- -----------------------------------------------------------------------------
--DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar: Lua file loaded (v3.1.2).|r")

-- -----------------------------------------------------------------------------
-- 按键绑定定义 (全局)
-- -----------------------------------------------------------------------------
BINDING_HEADER_FFXIVCROSSHOTBAR = "FFXIV Cross Hotbar";
MainMenuBar:Hide()
-- 页面切换
BINDING_NAME_SWITCHPAGE1 = "Switch to Page 1";
BINDING_NAME_SWITCHPAGE2 = "Switch to Page 2";
BINDING_NAME_SWITCHPAGE3 = "Switch to Page 3";
BINDING_NAME_SWITCHPAGE4 = "Switch to Page 4";
BINDING_NAME_SWITCHPAGE5 = "Switch to Page 5";
BINDING_NAME_SWITCHPAGE6 = "Switch to Page 6";
BINDING_NAME_SWITCHPAGE7 = "Switch to Page 7";
BINDING_NAME_SWITCHPAGE8 = "Switch to Page 8 (LT+RT Bar)";

-- 24个独立的技能触发绑定
local actionKeyNames = { "X", "Y", "B", "A", "Left", "Up", "Right", "Down" };
BINDING_NAME_LT_ACTION1 = "LT - Action 1 ("..actionKeyNames[1]..")";
BINDING_NAME_LT_ACTION2 = "LT - Action 2 ("..actionKeyNames[2]..")";
BINDING_NAME_LT_ACTION3 = "LT - Action 3 ("..actionKeyNames[3]..")";
BINDING_NAME_LT_ACTION4 = "LT - Action 4 ("..actionKeyNames[4]..")";
BINDING_NAME_LT_ACTION5 = "LT - Action 5 ("..actionKeyNames[5]..")";
BINDING_NAME_LT_ACTION6 = "LT - Action 6 ("..actionKeyNames[6]..")";
BINDING_NAME_LT_ACTION7 = "LT - Action 7 ("..actionKeyNames[7]..")";
BINDING_NAME_LT_ACTION8 = "LT - Action 8 ("..actionKeyNames[8]..")";
BINDING_NAME_RT_ACTION1 = "RT - Action 1 ("..actionKeyNames[1]..")";
BINDING_NAME_RT_ACTION2 = "RT - Action 2 ("..actionKeyNames[2]..")";
BINDING_NAME_RT_ACTION3 = "RT - Action 3 ("..actionKeyNames[3]..")";
BINDING_NAME_RT_ACTION4 = "RT - Action 4 ("..actionKeyNames[4]..")";
BINDING_NAME_RT_ACTION5 = "RT - Action 5 ("..actionKeyNames[5]..")";
BINDING_NAME_RT_ACTION6 = "RT - Action 6 ("..actionKeyNames[6]..")";
BINDING_NAME_RT_ACTION7 = "RT - Action 7 ("..actionKeyNames[7]..")";
BINDING_NAME_RT_ACTION8 = "RT - Action 8 ("..actionKeyNames[8]..")";
BINDING_NAME_BOTH_ACTION1 = "LT+RT - Action 1 ("..actionKeyNames[1]..")";
BINDING_NAME_BOTH_ACTION2 = "LT+RT - Action 2 ("..actionKeyNames[2]..")";
BINDING_NAME_BOTH_ACTION3 = "LT+RT - Action 3 ("..actionKeyNames[3]..")";
BINDING_NAME_BOTH_ACTION4 = "LT+RT - Action 4 ("..actionKeyNames[4]..")";
BINDING_NAME_BOTH_ACTION5 = "LT+RT - Action 5 ("..actionKeyNames[5]..")";
BINDING_NAME_BOTH_ACTION6 = "LT+RT - Action 6 ("..actionKeyNames[6]..")";
BINDING_NAME_BOTH_ACTION7 = "LT+RT - Action 7 ("..actionKeyNames[7]..")";
BINDING_NAME_BOTH_ACTION8 = "LT+RT - Action 8 ("..actionKeyNames[8]..")";

-- -----------------------------------------------------------------------------
-- 插件主表
-- -----------------------------------------------------------------------------

FFXIVCrossHotbar = {};
local CH = FFXIVCrossHotbar;

-- 为背景材质等恢复静态配置
CH.config = {
    zoomBgPath = "Interface\\AddOns\\FFXIVCrossHotbar\\src\\assets\\bg\\bg",
    zoomBgAlpha = 0.2,
    zoomBgWidth = 287,
    zoomBgHeight = 100,
};

-- 插件状态变量 (不保存)
CH.state = {
    modifier = { ctrl = false, alt = false, both = false },
    isBothBarActiveByKeybind = false,
    currentPage = 1,
    maxPages = 7,
    cursorHasSwappedItem = false,
    shiftHeld = false,
    pageSwitchOccurred = false,
};

-- -----------------------------------------------------------------------------
-- 数据库和配置
-- -----------------------------------------------------------------------------

-- CH.db 将会指向全局保存变量 CrossHotbarDB
CH.db = nil;

--- 初始化数据库，如果用户是第一次使用，则填入默认值
function CH:InitializeDatabase()
    -- 定义所有可配置项的默认值
    local defaults = {
        global = {
            scale = 1.0,
            position = { point = "BOTTOM", xOffset = 0, yOffset = 90 },
            debugMode = false,
            hasBeenInitialized = false, 
            setHUDKeybinding = false, -- 新增的可选按键绑定变量，默认为 true
        },
        bars = {
            showLT = true,
            showRT = true,
            showBoth = true,
            spacingFromCenter = 150,
            zoomScale = 1.10,
            shrinkScale = 0.8,
        },
        buttons = {
            size = 40,
            spacing = 42,
            crossInnerSpacing = 5,
            groupOffset = 70,
        },
        labels = {
            show = true,
            offsetY = 28,
            fontSize = 14,
            font = "Fonts\\FRIZQT__.TTF",
            fontColor = { r = 1, g = 1, b = 1, a = 0.9 },
            text = { prefix = FFXIV_CP_LOCALS["INDICATOR_PREFIX"], suffix = "RB", lt = "LT", rt = "RT", both = "LT + RT" },
        },
        pageIndicator = {
            show = true,
			offsetX = -22,
            offsetY = -63,
            rbBgPath = "Interface\\AddOns\\FFXIVCrossHotbar\\src\\assets\\bg\\RB.tga",
            rbBgWidth = 30,
            rbBgHeight = 20,
        },
        separator = {
            show = true,
            width = 1.3,
            height = 60,
            texture = "Interface\\AddOns\\FFXIVCrossHotbar\\src\\assets\\bg\\Flat.tga",
        },
        colors = {
            outOfRange = { r = 1.0, g = 0.2, b = 0.2 },
            outOfMana  = { r = 0.3, g = 0.5, b = 1.0 },
            unusable   = { r = 0.4, g = 0.4, b = 0.4 },
            normal     = { r = 1.0, g = 1.0, b = 1.0 },
        }
    };

    if not CrossHotbarDB then
        CrossHotbarDB = {};
    end
    CH.db = CrossHotbarDB;

    local function checkAndSetDefaults(savedTable, defaultTable)
        for key, value in pairs(defaultTable) do
            if type(value) == "table" then
                if type(savedTable[key]) ~= "table" then
                    savedTable[key] = {};
                end
                checkAndSetDefaults(savedTable[key], value);
            elseif savedTable[key] == nil then
                savedTable[key] = value;
            end
        end
    end

    checkAndSetDefaults(CH.db, defaults);
end

-- -----------------------------------------------------------------------------
-- 核心功能 - 布局刷新
-- -----------------------------------------------------------------------------

--- 根据数据库中的设置，重新计算并应用所有UI元素的位置、大小和缩放
function CH:RefreshLayout()
    if not CH.LTFrame then return end;

    local db = CH.db;

    -- 1. 应用整体缩放和位置
    local mainScale = db.global.scale;
    CH.LTFrame:SetScale(mainScale);
    CH.RTFrame:SetScale(mainScale);
    CH.BothFrame:SetScale(mainScale);
    CH.Separator:SetScale(mainScale);
    CH.PageIndicatorFrame:SetScale(mainScale);

    CH.LTFrame:ClearAllPoints();
    CH.RTFrame:ClearAllPoints();
    CH.BothFrame:ClearAllPoints();
    CH.Separator:ClearAllPoints();
    CH.PageIndicatorFrame:ClearAllPoints();
    
    CH.LTFrame:SetPoint("CENTER", UIParent, db.global.position.point, db.global.position.xOffset - db.bars.spacingFromCenter, db.global.position.yOffset);
    CH.RTFrame:SetPoint("CENTER", UIParent, db.global.position.point, db.global.position.xOffset + db.bars.spacingFromCenter, db.global.position.yOffset);
    CH.BothFrame:SetPoint("CENTER", UIParent, db.global.position.point, db.global.position.xOffset, db.global.position.yOffset);
    CH.Separator:SetPoint("CENTER", UIParent, db.global.position.point, db.global.position.xOffset, db.global.position.yOffset);
    CH.PageIndicatorFrame:SetPoint("CENTER", CH.Separator, "CENTER", db.pageIndicator.offsetX, db.pageIndicator.offsetY);

    -- 2. 应用按钮大小和布局
    CH:ApplyButtonLayouts();

    -- 3. 应用其他组件的设置
    CH.LTFrame.label:SetFont(db.labels.font, db.labels.fontSize, "OUTLINE");
    CH.RTFrame.label:SetFont(db.labels.font, db.labels.fontSize, "OUTLINE");
    CH.BothFrame.label:SetFont(db.labels.font, db.labels.fontSize, "OUTLINE");
    
    CH.LTFrame.label:SetTextColor(db.labels.fontColor.r, db.labels.fontColor.g, db.labels.fontColor.b, db.labels.fontColor.a);
    CH.RTFrame.label:SetTextColor(db.labels.fontColor.r, db.labels.fontColor.g, db.labels.fontColor.b, db.labels.fontColor.a);
    CH.BothFrame.label:SetTextColor(db.labels.fontColor.r, db.labels.fontColor.g, db.labels.fontColor.b, db.labels.fontColor.a);

    CH.LTFrame.label:SetText(db.labels.text.lt);
    CH.RTFrame.label:SetText(db.labels.text.rt);
    CH.BothFrame.label:SetText(db.labels.text.both);

    CH.LTFrame.label:SetPoint("CENTER", 0, db.labels.offsetY);
    CH.RTFrame.label:SetPoint("CENTER", 0, db.labels.offsetY);
    CH.BothFrame.label:SetPoint("CENTER", 0, db.labels.offsetY);

    CH.Separator:SetWidth(db.separator.width);
    CH.Separator:SetHeight(db.separator.height);

    -- 4. 应用显示/隐藏开关
    if db.bars.showLT then CH.LTFrame:Show() else CH.LTFrame:Hide() end;
    if db.bars.showRT then CH.RTFrame:Show() else CH.RTFrame:Hide() end;
    if db.labels.show then
        CH.LTFrame.label:Show(); CH.RTFrame.label:Show(); CH.BothFrame.label:Show();
    else
        CH.LTFrame.label:Hide(); CH.RTFrame.label:Hide(); CH.BothFrame.label:Hide();
    end
    if db.pageIndicator.show then CH.PageIndicatorFrame:Show() else CH.PageIndicatorFrame:Hide() end;
    if db.separator.show then CH.Separator:Show() else CH.Separator:Hide() end;
end

--- 应用按钮的大小和位置
function CH:ApplyButtonLayouts()
    local db = CH.db;
    local buttonSize = db.buttons.size;
    local buttonSpacing = db.buttons.spacing;
    local crossInnerSpacing = db.buttons.crossInnerSpacing;
    local groupOffset = db.buttons.groupOffset;

    local verticalOffset = (buttonSize + crossInnerSpacing) / 2;
    local positions = {
        [1] = { -groupOffset - buttonSpacing, 0 }, [2] = { -groupOffset, verticalOffset }, [3] = { -groupOffset + buttonSpacing, 0 }, [4] = { -groupOffset, -verticalOffset },
        [5] = { groupOffset - buttonSpacing, 0 }, [6] = { groupOffset, verticalOffset }, [7] = { groupOffset + buttonSpacing, 0 }, [8] = { groupOffset, -verticalOffset },
    };

    local framesToUpdate = { CH.LTFrame, CH.RTFrame, CH.BothFrame };
    for _, frame in pairs(framesToUpdate) do
        if frame and frame.content and frame.content.buttons then
            for i = 1, 8 do
                local btn = frame.content.buttons[i];
                btn:SetWidth(buttonSize);
                btn:SetHeight(buttonSize);
                btn:ClearAllPoints();
                btn:SetPoint("CENTER", frame.content, "CENTER", positions[i][1], positions[i][2]);
            end
        end
    end
end

-- -----------------------------------------------------------------------------
-- 核心功能 - 按钮更新
-- -----------------------------------------------------------------------------

function CH:UpdateButtonDisplay(button)
    local action = button.action;
    if not action then return end;
    local texture = GetActionTexture(action);
    local count = GetActionCount(action);
    if button.icon then
        if texture then button.icon:SetTexture(texture); button.icon:Show(); else button.icon:Hide(); end
    end
    if button.Count then
        if count and count > 1 then button.Count:SetText(tostring(count)); button.Count:Show(); else button.Count:Hide(); end
    end
	--if ActionButton_UpdateCooldown then
		--local oldThis = this; this = button; ActionButton_UpdateCooldown(); this = oldThis;
	--end
end

function CH:UpdateButtonState(button)
    if not button or not button:IsShown() then return end
    local action = button.action;
    if not action or not HasAction(action) then 
        button.icon:SetVertexColor(CH.db.colors.normal.r, CH.db.colors.normal.g, CH.db.colors.normal.b);
        button:SetChecked(0);
        return
    end
    local isUsable, notEnoughMana = IsUsableAction(action);
    local outOfRange = (IsActionInRange(action) == 0);
    local col = CH.db.colors;
    if outOfRange then button.icon:SetVertexColor(col.outOfRange.r, col.outOfRange.g, col.outOfRange.b);
    elseif notEnoughMana then button.icon:SetVertexColor(col.outOfMana.r, col.outOfMana.g, col.outOfMana.b);
    elseif not isUsable then button.icon:SetVertexColor(col.unusable.r, col.unusable.g, col.unusable.b);
    else button.icon:SetVertexColor(col.normal.r, col.normal.g, col.normal.b); end
end

function CH:UpdateAllButtonDisplays()
    for i = 1, 8 do
        CH:UpdateButtonDisplay(CH.LTFrame.content.buttons[i]);
        CH:UpdateButtonDisplay(CH.RTFrame.content.buttons[i]);
    end
    if CH.BothFrame and CH.BothFrame.content.buttons then
        for i = 1, 8 do CH:UpdateButtonDisplay(CH.BothFrame.content.buttons[i]); end
    end
end

function CH:UpdateAllButtonStates()
    local visibleFrames = {};
    if CH.LTFrame:IsShown() then table.insert(visibleFrames, CH.LTFrame.content); end
    if CH.RTFrame:IsShown() then table.insert(visibleFrames, CH.RTFrame.content); end
    if CH.BothFrame:IsShown() then table.insert(visibleFrames, CH.BothFrame.content); end
    for _, frame in pairs(visibleFrames) do
        if frame.buttons then
            for i = 1, 8 do CH:UpdateButtonState(frame.buttons[i]); end
        end
    end
end

-- -----------------------------------------------------------------------------
-- 核心功能 - 界面创建
-- -----------------------------------------------------------------------------

function CH:CreateButtonsForBar(parentFrame, namePrefix, actionSlotOffset)
    parentFrame.buttons = {};
    for i = 1, 8 do
        local btnName = namePrefix .. i;
        local btn = CreateFrame("CheckButton", btnName, parentFrame, "ActionButtonTemplate");
        btn:SetID(i);
        btn.icon = _G[btnName .. "Icon"]; btn.Count = _G[btnName .. "Count"]; btn.HotKey = _G[btnName .. "HotKey"]; btn.cooldown = _G[btnName .. "Cooldown"];
        if not btn.icon then btn.icon = btn:CreateTexture(nil, "BACKGROUND"); btn.icon:SetAllPoints(btn); end
        if btn.Count then btn.Count:Hide() end
        btn.action = actionSlotOffset + i;
        
        -- [新增] 创建冷却时间文本
-- [新增] 创建冷却时间文本
        -- [核心修正] 将冷却文本的父级设置为冷却圈框架(btn.cooldown)
        -- 这能保证文本永远绘制在冷却圈的黑色遮罩之上。
        -- 层级可以安全地设置回 OVERLAY，因为它现在是子元素。
        btn.cooldownText = btn.cooldown:CreateFontString(nil, "OVERLAY");
        
        btn.cooldownText:SetFont(CH.db.labels.font, CH.db.labels.fontSize + 2, "OUTLINE");
        
        -- [核心修正] 因为父级变了，SetPoint也需要相应修改。
        -- SetPoint的父级默认就是其创建时的父级(btn.cooldown)，
        -- 而btn.cooldown和btn的位置大小完全一样，所以我们可以简化SetPoint的写法。
        btn.cooldownText:SetPoint("BOTTOMLEFT", 2, 2);
        
        btn.cooldownText:Hide();

        btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
        btn:RegisterForDrag("LeftButton");
        btn:SetScript("OnClick", function()
            if ( CursorHasItem() or CursorHasSpell() or CH.state.cursorHasSwappedItem ) then
                PlaceAction(btn.action); ClearCursor(); CH.state.cursorHasSwappedItem = false; btn:SetChecked(0); btn.clicked = nil;
            else UseAction(btn.action); btn:SetChecked(1); btn.clicked = 0.15; end
        end);
        btn:SetScript("OnDragStart", function() PickupAction(btn.action); end);
        btn:SetScript("OnReceiveDrag", function()
            PlaceAction(btn.action); if not (CursorHasItem() or CursorHasSpell()) then CH.state.cursorHasSwappedItem = true; end
            CH:UpdateButtonDisplay(btn); CH:UpdateButtonState(btn);
        end);
        btn.lastUpdateTime = GetTime();
btn:SetScript("OnUpdate", function()
            local now = GetTime();
            local elapsed = now - btn.lastUpdateTime;
            btn.lastUpdateTime = now;

            if ( btn.clicked ) then
                btn.clicked = btn.clicked - elapsed;
                if ( btn.clicked <= 0 ) then
                    btn.clicked = nil;
                    btn:SetChecked(0);
                end
            end
            
            -- 每0.2秒更新一次按钮状态 (距离、法力等)
            btn.lastRangeCheck = (btn.lastRangeCheck or 0) + elapsed;
            if (btn.lastRangeCheck > 0.2) then
                CH:UpdateButtonState(btn);
                btn.lastRangeCheck = 0;
            end

            -- [核心修复 - v2] 手动处理冷却逻辑 (包括宏)
            local action = btn.action;
            local start, duration, enable = GetActionCooldown(action);
            
            -- [修正] 检查此格子是否为宏
            local macroText = GetActionText(action);
            if (macroText) then -- 如果 GetActionText 返回了非 nil 值，那么它就是一个宏
                -- 这是一个简化的宏解析，尝试寻找第一个 /cast 或 /use 命令
                -- 注意: LUA 5.0 不支持 string.match, 我们用 string.find
                local castCommandPos = string.find(macroText, "/cast ");
                local useCommandPos = string.find(macroText, "/use ");
                
                local spellName;
                local commandPos;

                if castCommandPos and (not useCommandPos or castCommandPos < useCommandPos) then
                    commandPos = castCommandPos + 6; -- length of "/cast "
                elseif useCommandPos then
                    commandPos = useCommandPos + 5; -- length of "/use "
                end

                if commandPos then
                    local endPos = string.find(macroText, "\n", commandPos); -- 找到换行符
                    if endPos then
                        spellName = string.sub(macroText, commandPos, endPos - 1);
                    else
                        spellName = string.sub(macroText, commandPos);
                    end
                    -- 移除可能的参数，例如 [@target]
                    local optionEnd = string.find(spellName, "]");
                    if optionEnd then
                        spellName = string.sub(spellName, optionEnd + 1);
                    end
                    -- 移除首尾空格
                    spellName = string.gsub(spellName, "^%s*(.-)%s*$", "%1");
                    
                    -- 如果成功解析出法术名，则用它来获取冷却
                    if spellName and spellName ~= "" then
                        local s_start, s_duration, s_enable = GetSpellCooldown(spellName, BOOKTYPE_SPELL);
                        -- 只有在宏的冷却时间比动作栏本身长时才覆盖 (处理饰品等情况)
                        if s_duration > duration then
                            start, duration, enable = s_start, s_duration, s_enable;
                        end
                    end
                end
            end
            
            -- 更新冷却圈 (这是暴雪模板的标准做法)
            if (btn.cooldown) then
                CooldownFrame_SetTimer(btn.cooldown, start, duration, enable);
            end

            -- 更新冷却文本
            if ( enable == 1 and duration > 1.5 ) then	-- 只显示大于1.5秒公CD的技能
                local remaining = (start + duration) - now;
                if ( remaining > 0 ) then 
                    btn.cooldownText:SetText(math.floor(remaining + 0.5));
                    btn.cooldownText:Show();
                else
                    btn.cooldownText:Hide();
                end
            else
                btn.cooldownText:Hide();
            end
        end);
        -- 添加鼠标悬停时的技能信息提示框 (Tooltip)
        btn:SetScript("OnEnter", function()
            if (this.action) then
                GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
                GameTooltip:SetAction(this.action);
                GameTooltip:Show();
            end
        end);
        btn:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end);

        parentFrame.buttons[i] = btn;
    end
end

function CH:CreateBothBar()
    CH.BothFrame = CreateFrame("Frame", "CrossBar_Both", UIParent);
    CH.BothFrame:SetWidth(400);
    CH.BothFrame:SetHeight(150);
    CH.BothFrame.content = CreateFrame("Frame", nil, CH.BothFrame); CH.BothFrame.content:SetAllPoints(CH.BothFrame);
    CH.BothFrame.bg = CH.BothFrame.content:CreateTexture(nil, "BACKGROUND");
    CH.BothFrame.bg:SetTexture(CH.config.zoomBgPath);
    CH.BothFrame.bg:SetAlpha(CH.config.zoomBgAlpha);
    CH.BothFrame.bg:SetWidth(CH.config.zoomBgWidth);
    CH.BothFrame.bg:SetHeight(CH.config.zoomBgHeight);
    CH.BothFrame.bg:SetPoint("CENTER", CH.BothFrame.content, "CENTER");
    CH.BothFrame.bg:Hide();
    CH:CreateButtonsForBar(CH.BothFrame.content, "CrossBar_Both_Button", 112);
    CH.BothFrame.label = CH.BothFrame.content:CreateFontString(nil, "OVERLAY");
    CH.BothFrame:Hide();
end

function CH:CreateHotbars()
    -- LT Frame
    CH.LTFrame = CreateFrame("Frame", "CrossBar_L", UIParent);
    CH.LTFrame:SetWidth(400);
    CH.LTFrame:SetHeight(150);
    CH.LTFrame.content = CreateFrame("Frame", nil, CH.LTFrame); CH.LTFrame.content:SetAllPoints(CH.LTFrame);
    CH.LTFrame.bg = CH.LTFrame.content:CreateTexture(nil, "BACKGROUND");
    CH.LTFrame.bg:SetTexture(CH.config.zoomBgPath);
    CH.LTFrame.bg:SetAlpha(CH.config.zoomBgAlpha);
    CH.LTFrame.bg:SetWidth(CH.config.zoomBgWidth);
    CH.LTFrame.bg:SetHeight(CH.config.zoomBgHeight);
    CH.LTFrame.bg:SetPoint("CENTER", CH.LTFrame.content, "CENTER");
    CH.LTFrame.bg:Hide();
    CH.LTFrame.label = CH.LTFrame.content:CreateFontString(nil, "OVERLAY");
    -- RT Frame
    CH.RTFrame = CreateFrame("Frame", "CrossBar_R", UIParent);
    CH.RTFrame:SetWidth(400);
    CH.RTFrame:SetHeight(150);
    CH.RTFrame.content = CreateFrame("Frame", nil, CH.RTFrame); CH.RTFrame.content:SetAllPoints(CH.RTFrame);
    CH.RTFrame.bg = CH.RTFrame.content:CreateTexture(nil, "BACKGROUND");
    CH.RTFrame.bg:SetTexture(CH.config.zoomBgPath);
    CH.RTFrame.bg:SetAlpha(CH.config.zoomBgAlpha);
    CH.RTFrame.bg:SetWidth(CH.config.zoomBgWidth);
    CH.RTFrame.bg:SetHeight(CH.config.zoomBgHeight);
    CH.RTFrame.bg:SetPoint("CENTER", CH.RTFrame.content, "CENTER");
    CH.RTFrame.bg:Hide();
    CH.RTFrame.label = CH.RTFrame.content:CreateFontString(nil, "OVERLAY");
    -- Create Buttons
    CH:CreateButtonsForBar(CH.LTFrame.content, "CrossBar_L_Button", 0);
    CH:CreateButtonsForBar(CH.RTFrame.content, "CrossBar_R_Button", 8);
    CH:CreateBothBar();
    -- Separator
    local sep = CreateFrame("Frame", nil, UIParent);
    local tex = sep:CreateTexture(nil, "ARTWORK"); tex:SetTexture(CH.db.separator.texture); tex:SetAllPoints(sep);
    CH.Separator = sep;
    -- Page Indicator
    local pi = CreateFrame("Frame", "CrossHotbarPageIndicator", UIParent); pi:SetHeight(20);
    CH.PageIndicatorFrame = pi;
    local p_prefix = pi:CreateFontString(nil, "OVERLAY"); p_prefix:SetFont(CH.db.labels.font, CH.db.labels.fontSize, "OUTLINE"); p_prefix:SetTextColor(1,1,1,0.9);
    p_prefix:SetPoint("LEFT", pi, "LEFT", 0, 0);
    p_prefix:SetText(CH.db.labels.text.prefix);
    CH.PageNumber = pi:CreateFontString(nil, "OVERLAY"); CH.PageNumber:SetFont(CH.db.labels.font, CH.db.labels.fontSize, "OUTLINE"); CH.PageNumber:SetTextColor(1,1,1,0.9); CH.PageNumber:SetPoint("LEFT", p_prefix, "RIGHT", 5, 0); CH.PageNumber:SetText(CH.state.currentPage);
    local p_suffix = pi:CreateFontString(nil, "OVERLAY"); p_suffix:SetFont(CH.db.labels.font, CH.db.labels.fontSize, "OUTLINE"); p_suffix:SetTextColor(1,1,1,0.9); p_suffix:SetPoint("LEFT", p_prefix, "RIGHT", 45, 0); p_suffix:SetText(CH.db.labels.text.suffix);
    local rbBg = pi:CreateTexture(nil, "BACKGROUND"); rbBg:SetTexture(CH.db.pageIndicator.rbBgPath);
    rbBg:SetWidth(CH.db.pageIndicator.rbBgWidth);
    rbBg:SetHeight(CH.db.pageIndicator.rbBgHeight);
    rbBg:SetPoint("CENTER", p_suffix, "CENTER");
    pi:SetWidth(p_prefix:GetStringWidth() + CH.PageNumber:GetStringWidth() + p_suffix:GetStringWidth()+10);
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar: Hotbars created!|r");
end

function CH:UpdateActionSlots()
    local page = CH.state.currentPage or 1;
    local pageOffset = (page - 1) * 16;
    for i = 1, 8 do
        CH.LTFrame.content.buttons[i].action = pageOffset + i;
        CH.RTFrame.content.buttons[i].action = pageOffset + 8 + i;
    end
end

function CH:SwitchPage(page)
    if not page or page < 1 or page > CH.state.maxPages then return end
    CH.state.isBothBarActiveByKeybind = false;
    CH.BothFrame:Hide(); CH.LTFrame:Show(); CH.RTFrame:Show(); CH.Separator:Show();
    CH.PageNumber:SetText(page);
    if CH.state.currentPage == page then return end
    CH.state.currentPage = page;
    CH:UpdateActionSlots(); CH:UpdateAllButtonDisplays(); CH:UpdateAllButtonStates();
	--PlaySound("FFXHBRBPageSwitch", "SFX");
    --DEFAULT_CHAT_FRAME:AddMessage("FFXIVCrossHotbar: Switched to Page " .. page);
    CH.state.pageSwitchOccurred = true;
end

function CH:SwitchToBothBar()
    if CH.state.isBothBarActiveByKeybind then return end;
    CH.state.isBothBarActiveByKeybind = true;
    CH.LTFrame:Hide(); CH.RTFrame:Hide(); CH.Separator:Hide(); CH.BothFrame:Show();
    CH.state.pageSwitchOccurred = true;
    CH.PageNumber:SetText("8");
    --DEFAULT_CHAT_FRAME:AddMessage("FFXIVCrossHotbar: Switched to LT+RT Bar");
end

-- 直接触发技能的核心函数，增加严格的修饰键检查
function CH:TriggerAction(barType, buttonIndex)
    -- 严格的修饰键检查，防止错误的绑定触发
    local isCtrl, isAlt = IsControlKeyDown(), IsAltKeyDown();
    if barType == "LT" and (not isCtrl or isAlt) then return end
    if barType == "RT" and (not isAlt or isCtrl) then return end
    if barType == "BOTH" and (not isCtrl or not isAlt) then return end

    local targetFrame;
    if barType == "LT" then targetFrame = CH.LTFrame.content;
    elseif barType == "RT" then targetFrame = CH.RTFrame.content;
    elseif barType == "BOTH" then targetFrame = CH.BothFrame.content;
    end

    if targetFrame and targetFrame:IsShown() then
        -- 按钮ID映射 (1-8 对应 ←,↑,→,↓, X,Y,B,A)
        -- 按键1-4对应按钮5-8 (X,Y,B,A), 按键5-8对应按钮1-4 (方向键)
        local buttonIDMap = {[1]=5, [2]=6, [3]=7, [4]=8, [5]=1, [6]=2, [7]=3, [8]=4};
        local buttonID = buttonIDMap[buttonIndex];
        local button = targetFrame.buttons[buttonID];
        if button then
            -- 增强的调试信息
            if CH.db.global.debugMode then
                DEFAULT_CHAT_FRAME:AddMessage("|cffFFFF00[Debug]|r Triggering action on button: |cff99ccff" .. button:GetName() .. "|r (Action ID: " .. button.action .. ")");
            end
            UseAction(button.action);
            button:SetChecked(1);
            button.clicked = 0.15;
        end
    end
end

-- 创建翻页处理器的工厂函数
local function createPageSwitchHandler(page)
    return function()
        CH:SwitchPage(page);
    end
end

-- 创建直接触发处理器的工厂函数
local function createDirectTriggerHandler(barType, buttonIndex)
    return function() CH:TriggerAction(barType, buttonIndex); end
end

-- 一键设置所有按键绑定，包括翻页键
function CH:SetDefaultKeybindings()
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar:|r Setting up all default keybindings...");
    
    -- 设置技能触发键
    local triggerBinds = {
        { prefix = "CTRL-", command = "LT_ACTION" },
        { prefix = "ALT-", command = "RT_ACTION" },
        { prefix = "ALT-CTRL-", command = "BOTH_ACTION" },
    };
    for _, bindInfo in pairs(triggerBinds) do
        for i = 1, 8 do
            SetBinding(bindInfo.prefix .. i, bindInfo.command .. i);
        end
    end

    -- 设置页面切换键
    for i = 1, 8 do
        SetBinding("SHIFT-" .. i, "SWITCHPAGE" .. i);
    end

    -- [新增] 添加副移动键位以修复按住 LT (Ctrl) 时的移动锁定问题
    --DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar:|r Applying controller movement fix...");
    SetBinding("CTRL-W", "MOVEFORWARD");
    SetBinding("CTRL-S", "MOVEBACKWARD");
    SetBinding("CTRL-A", "STRAFELEFT");
    SetBinding("CTRL-D", "STRAFERIGHT");
	SetBinding("D", "STRAFERIGHT");
	SetBinding("A", "STRAFELEFT");
	SetBinding("4", "JUMP");
	SetBinding("9", "TARGETNEARESTENEMY");
	SetBinding("ALT-9", "TARGETNEARESTENEMY");
	SetBinding("CTRL-9", "TARGETNEARESTENEMY");
	SetBinding("SHIFT-9", "TOGGLEAUTORUN");
	--可选界面功能
	if CH.db.global.setHUDKeybinding == true then
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar:|r Applying HUD Keybinding...");
	SetBinding("3", "TOGGLEGAMEMENU");
	SetBinding("2", "TOGGLEWORLDMAP");
	SetBinding("1", "TARGETNEARESTFRIEND");
	SetBinding("5", "TOGGLEQUESTLOG");
	SetBinding("6", "TOGGLECHARACTER0");
	SetBinding("7", "OPENALLBAGS");
	SetBinding("8", "TOGGLESPELLBOOK");
	end
	
    SaveBindings(GetCurrentBindingSet());
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar:|r All keybindings set successfully!");
    DEFAULT_CHAT_FRAME:AddMessage("A /reload might be needed for changes to appear in the menu.");
end

function CH:Initialize()
    -- 初始化数据库
    CH:InitializeDatabase();

    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99FFXIVCrossHotbar: Initializing...|r");
    CH:CreateHotbars();
    
    -- 首次应用布局
    CH:RefreshLayout();

    CH:UpdateActionSlots();
    CH:UpdateAllButtonDisplays();
    CH:UpdateAllButtonStates();

    -- 使用工厂函数创建页面切换的虚拟按钮
    for i=1, CH.state.maxPages do -- Loop 1 to 7
        CreateFrame("Button", "SwitchPage"..i.."Button", UIParent):SetScript("OnClick", createPageSwitchHandler(i));
    end
    -- Page 8 is special and calls a different function
    CreateFrame("Button", "SwitchPage8Button", UIParent):SetScript("OnClick", function() CH:SwitchToBothBar() end);

    -- 创建24个技能触发的虚拟按钮
    for i=1, 8 do
        CreateFrame("Button", "FFXIVCrossHotbar_LT_Trigger"..i, UIParent):SetScript("OnClick", createDirectTriggerHandler("LT", i));
        CreateFrame("Button", "FFXIVCrossHotbar_RT_Trigger"..i, UIParent):SetScript("OnClick", createDirectTriggerHandler("RT", i));
        CreateFrame("Button", "FFXIVCrossHotbar_BOTH_Trigger"..i, UIParent):SetScript("OnClick", createDirectTriggerHandler("BOTH", i));
    end

    -- 注册斜杠命令
    SLASH_FFXIVCROSSHOTBAR1 = "/ffxhb";
    SlashCmdList["FFXIVCROSSHOTBAR"] = function(msg)
        local args = {};
        for word in string.gfind(msg or "", "%S+") do
            table.insert(args, word);
        end
        local cmd = args[1];
        local param = args[2];
        local value = args[3];

        if cmd == "set" and param and value then
            local keys = {};
            for key in string.gfind(param, "[^%.]+") do table.insert(keys, key) end
            
            local targetTable = CH.db;
            for i = 1, table.getn(keys) - 1 do
                targetTable = targetTable[keys[i]];
                if type(targetTable) ~= "table" then
                    DEFAULT_CHAT_FRAME:AddMessage("FFXIVCrossHotbar: Invalid config key '" .. param .. "'");
                    return;
                end
            end

            local finalKey = keys[table.getn(keys)];
            local numValue = tonumber(value);
            if numValue then
                targetTable[finalKey] = numValue;
            else
                targetTable[finalKey] = value;
            end
            DEFAULT_CHAT_FRAME:AddMessage("FFXIVCrossHotbar: Set " .. param .. " to " .. value);
            CH:RefreshLayout();
        elseif cmd == "setupkeys" then
            CH:SetDefaultKeybindings();
        elseif cmd == "refresh" then
            CH:RefreshLayout();
        elseif cmd == "reset" then
            CrossHotbarDB = nil;
            ReloadUI();
        else
            DEFAULT_CHAT_FRAME:AddMessage("FFXIVCrossHotbar: Commands: /ffxhb [setupkeys|refresh|reset|set|config <key> <value>]");
        end
    end
end

function CH:OnUpdate(elapsed)
    if type(elapsed) ~= "number" then elapsed = 0 end
    local isCtrl, isAlt = IsControlKeyDown(), IsAltKeyDown();
    if (CH.state.modifier.ctrl ~= isCtrl) or (CH.state.modifier.alt ~= isAlt) then
        CH.state.modifier.ctrl, CH.state.modifier.alt = isCtrl, isAlt;
        local zoomScale = CH.db.bars.zoomScale;
        local shrinkScale = CH.db.bars.shrinkScale;
        if isCtrl and isAlt then
            if not CH.state.modifier.both then
                CH.state.modifier.both = true;
                if not CH.state.isBothBarActiveByKeybind then CH.LTFrame:Hide(); CH.RTFrame:Hide(); CH.Separator:Hide(); CH.BothFrame:Show(); end
                CH.BothFrame.content:SetScale(zoomScale); CH.BothFrame.bg:Show();
            end
        else
            if CH.state.modifier.both then
                CH.state.modifier.both = false;
                if not CH.state.isBothBarActiveByKeybind then CH.BothFrame:Hide(); CH.LTFrame:Show(); CH.RTFrame:Show(); CH.Separator:Show(); end
                CH.BothFrame.content:SetScale(1); CH.BothFrame.bg:Hide();
            end
            if isCtrl then -- 只按下了Ctrl
                CH.LTFrame.content:SetScale(zoomScale);
                CH.LTFrame.bg:Show();
                CH.RTFrame.content:SetScale(shrinkScale);
                CH.RTFrame.bg:Hide();
            elseif isAlt then -- 只按下了Alt
                CH.RTFrame.content:SetScale(zoomScale);
                CH.RTFrame.bg:Show();
                CH.LTFrame.content:SetScale(shrinkScale);
                CH.LTFrame.bg:Hide();
            else -- 没有按下任何修饰键
                CH.LTFrame.content:SetScale(1);
                CH.LTFrame.bg:Hide();
                CH.RTFrame.content:SetScale(1);
                CH.RTFrame.bg:Hide();
            end
        end
    end
    local isShift = IsShiftKeyDown();
    if isShift then CH.state.shiftHeld = true;
    elseif CH.state.shiftHeld then
        if not CH.state.pageSwitchOccurred then CH:SwitchPage(1); end
        CH.state.shiftHeld, CH.state.pageSwitchOccurred = false, false;
    end
end

-- -----------------------------------------------------------------------------
-- 事件处理
-- -----------------------------------------------------------------------------
local ADDON_NAME = "FFXIVCrossHotbar"
local eventFrame = CreateFrame("Frame", "CrossHotbarEventFrame", UIParent);
eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
eventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
eventFrame:RegisterEvent("UNIT_MANA");
-- [已修复] 修正此处的拼写错误
eventFrame:RegisterEvent("SPELL_UPDATE_USABLE");
eventFrame:RegisterEvent("UNIT_AURA");
eventFrame:RegisterEvent("CURSOR_CHANGED");
eventFrame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        CH:Initialize();
		this:SetScript("OnUpdate", function(_, elapsed) CH:OnUpdate(elapsed); end)
        this:UnregisterEvent("ADDON_LOADED");
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- [新增] 检查是否需要弹出配置界面
        if CH.db and CH.db.global and not CH.db.global.hasBeenInitialized then
            if FFXIVConfigPanelFrame then
                FFXIVConfigPanelFrame:Show();
            end
            CH.db.global.hasBeenInitialized = true;
        end
        CH:UpdateActionSlots(); CH:UpdateAllButtonDisplays(); CH:UpdateAllButtonStates();
    elseif event == "ACTIONBAR_SLOT_CHANGED" then
        CH:UpdateAllButtonDisplays(); CH:UpdateAllButtonStates();
    elseif event == "SPELL_UPDATE_COOLDOWN" then
        CH:UpdateAllButtonDisplays();
    elseif event == "CURSOR_CHANGED" then
        if not (CursorHasItem() or CursorHasSpell()) then CH.state.cursorHasSwappedItem = false; end
    elseif event == "PLAYER_TARGET_CHANGED" or event == "UNIT_MANA" or event == "SPELL_UPDATE_USABLE" or event == "UNIT_AURA" then
        CH:UpdateAllButtonStates();
    end
end)
