-- FFXIVCrossHotbar/locales/zhCN.lua
-- 简体中文本地化文件

-- 检查客户端语言是否为简体中文
if (GetLocale() == "zhCN") then
    -- 创建全局本地化表
    FFXIV_CP_LOCALS = {
        -- 主面板标题
        ["SETTINGS_TITLE"] = "FFXIV 十字热键栏设置",

        -- 标签页
        ["TAB_MAIN"] = "主页",
        ["TAB_HUD"] = "界面",
        ["TAB_LABEL"] = "标签",

        -- 主页标签内容
        ["INITIALIZE_KEYS"] = "初始化按键",
        ["INIT_KEYS_DESC"] = "首次使用的用户, 请点击以设置按键绑定。\n然后用软件给手柄映射对应按键。\nShift+1-8对应切换页面1到8",

        --通用按钮
        ["CLOSE"] = "关闭",
        ["RESET"] = "重置",

        -- 界面标签页标题
        ["HEADER_GLOBAL"] = "全局设置",
        ["HEADER_BUTTON"] = "按钮设置",
        ["HEADER_BAR"] = "热键栏设置",

        -- 标签标签页标题
        ["HEADER_LABEL"] = "文本标签设置",
        ["HEADER_INDICATOR"] = "翻页指示器",
        ["HEADER_SEPARATOR"] = "分隔符",

        -- 全局设置选项
        ["OPTION_GLOBAL_SCALE"] = "全局缩放",
        ["OPTION_VERTICAL_POS"] = "垂直位置",
        ["OPTION_HORIZONTAL_POS"] = "水平位置",

        -- 按钮设置选项
        ["OPTION_BUTTON_SIZE"] = "按钮大小",
        ["OPTION_BUTTON_SPACING"] = "按钮间距",
        ["OPTION_INNER_SPACING"] = "内部间距",
        ["OPTION_GROUP_OFFSET"] = "分组偏移",

        -- 热键栏设置选项
        ["OPTION_BAR_SPACING"] = "热键栏间距",
        ["OPTION_ACTIVE_SCALE"] = "激活栏放大",
        ["OPTION_INACTIVE_SCALE"] = "未激活栏缩小",

        -- 文本标签设置选项
        ["OPTION_SHOW_LABELS"] = "显示文本标签",
        ["OPTION_LABEL_Y_OFFSET"] = "标签Y轴偏移",
        ["OPTION_LABEL_FONT_SIZE"] = "标签字体大小",

        -- 翻页指示器选项
        ["OPTION_SHOW_INDICATOR"] = "显示指示器",
        ["OPTION_INDICATOR_X"] = "指示器X轴偏移",
        ["OPTION_INDICATOR_Y"] = "指示器Y轴偏移",

        -- 分隔符选项
        ["OPTION_SHOW_SEPARATOR"] = "显示分隔符",
        ["OPTION_SEPARATOR_WIDTH"] = "分隔符宽度",
        ["OPTION_SEPARATOR_HEIGHT"] = "分隔符高度",
		
		["INDICATOR_PREFIX"] = "热键栏",
    };
end
