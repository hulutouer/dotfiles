-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
-- local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
--local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}
-- 定义一个函数用来检查当前聚焦的窗口是否为 polybar
local function is_focused_client_polybar(client)
    -- 检查客户端的名字是否包含 "polybar"
    if client then
        return string.match(client.name, "polybar") ~= nil
    end
    return false
end
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- 取消不需要的布局，只需在相应的行前加上注释符"--"
    --awful.layout.suit.fair, -- 公平布局（垂直）
    awful.layout.suit.tile, -- 平铺布局
    awful.layout.suit.floating, -- 浮动布局
    --awful.layout.suit.max, -- 最大化布局
    --awful.layout.suit.fair.horizontal, -- 公平布局（水平）
    --awful.layout.suit.maximized, -- 最大化布局
    --awful.layout.suit.magnifier, -- 放大镜布局
    -- 会被polybar挡住
    --awful.layout.suit.max.fullscreen, -- 全屏最大化布局
    --awful.layout.suit.tile.top, -- 顶部平铺布局
    --awful.layout.suit.tile.bottom, -- 底部平铺布局
    --awful.layout.suit.spiral, -- 螺旋式布局
    --awful.layout.suit.spiral.dwindle, -- 螺旋式布局（缩小）
    -- 下面的四个布局方向 表示焦点一直在对应方向
    --awful.layout.suit.corner.nw, -- 角落布局（左上）
    --awful.layout.suit.corner.se, -- 角落布局（右下）
    --awful.layout.suit.corner.ne, -- 角落布局（右上）
    --awful.layout.suit.corner.sw, -- 角落布局（左下）
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function()
        hotkeys_popup.show_help(nil, awful.screen.focused())
    end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function()
        awesome.quit()
    end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
--}}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

--{{{ Wibar
--Create a textclock widget
--mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
        awful.button({ }, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button({ }, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
)

local tasklist_buttons = gears.table.join(
        awful.button({ }, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                        "request::activate",
                        "tasklist",
                        { raise = true }
                )
            end
        end),
        awful.button({ }, 3, function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),
        awful.button({ }, 4, function()
            awful.client.focus.byidx(1)
        end),
        awful.button({ }, 5, function()
            awful.client.focus.byidx(-1)
        end))

--screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)
    -- Each screen has its own tag table.
    --clash eeed  f484
    --GPT f4be  󰨞
    awful.tag({ "", "", "", "", "󰢹", "", "󰨞", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
            awful.button({ }, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({ }, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({ }, 4, function()
                awful.layout.inc(1)
            end),
            awful.button({ }, 5, function()
                awful.layout.inc(-1)
            end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

end)


-- {{{ Mouse bindings
--root.buttons(gears.table.join(
-- 鼠标右键壁纸不要出现菜单
-- awful.button({ }, 3, function () mymainmenu:toggle() end),
--        awful.button({ }, 4, awful.tag.viewnext),
--        awful.button({ }, 5, awful.tag.viewprev)
--))


-- {{{ Key bindings
globalkeys = gears.table.join(
--        awful.key({ modkey, }, "s", hotkeys_popup.show_help,
--               {description = "show help",group = "awesome"}),
-- 按下modkey + 左箭头键查看上一个tag
        awful.key({ modkey, }, "Left", awful.tag.viewprev,
                { description = "view previous", group = "tag" }),
-- 按下modkey + 右箭头键查看下一个tag
        awful.key({ modkey, }, "Right", awful.tag.viewnext,
                { description = "view next", group = "tag" }),
-- 按下modkey + Escape键返回上一个tag
        awful.key({ modkey, }, "Escape", awful.tag.history.restore,
                { description = "go back", group = "tag" }),
-- 按下modkey + j键聚焦到下一个客户端
        awful.key({ modkey, }, "j",
                function()
                    awful.client.focus.byidx(1)
                end,
                { description = "focus next by index", group = "client" }
        ),
-- 按下modkey + k键聚焦到上一个客户端
        awful.key({ modkey, }, "k",
                function()
                    awful.client.focus.byidx(-1)
                end,
                { description = "focus previous by index", group = "client" }
        ),

-- 布局操作键绑定
-- 按下modkey + Shift + j键，与下一个客户端交换位置
        awful.key({ modkey, "Shift" }, "j", function()
            awful.client.swap.byidx(1)
        end,

                { description = "swap with next client by index", group = "client" }),
-- 按下modkey + Shift + k键，与上一个客户端交换位置

        awful.key({ modkey, "Shift" }, "k", function()
            awful.client.swap.byidx(-1)
        end,
                { description = "swap with previous client by index", group = "client" }),
-- 按下modkey + Control + j键，聚焦到下一个屏幕

        awful.key({ modkey, "Control" }, "j", function()
            awful.screen.focus_relative(1)
        end,
                { description = "focus the next screen", group = "screen" }),
-- 按下modkey + Control + k键，聚焦到上一个屏幕

        awful.key({ modkey, "Control" }, "k", function()
            awful.screen.focus_relative(-1)
        end,
                { description = "focus the previous screen", group = "screen" }),
-- 按下modkey + u键，跳转到紧急客户端

        awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
                { description = "jump to urgent client", group = "client" }),
-- 按下modkey + Tab键，回到上一个客户端

        awful.key({ modkey, }, "Tab",
                function()
                    awful.client.focus.history.previous()
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                { description = "go back", group = "client" }),

-- Standard program
-- 按下modkey + Return键打开终端
        awful.key({ modkey, }, "Return", function()
            awful.spawn(terminal)
        end,
                { description = "open a terminal", group = "launcher" }),
-- 按下modkey + Shift + q键重新加载awesome
        awful.key({ modkey, "Shift" }, "q", awesome.restart,
                { description = "reload awesome", group = "awesome" }),

-- 按下modkey + l键，增加主窗口宽度系数

        awful.key({ modkey, }, "l", function()
            awful.tag.incmwfact(0.05)
        end,
                { description = "increase master width factor", group = "layout" }),
-- 按下modkey + h键，减少主窗口宽度系数

        awful.key({ modkey, }, "h", function()
            awful.tag.incmwfact(-0.05)
        end,
                { description = "decrease master width factor", group = "layout" }),
-- 按下modkey + Shift + h键，增加主客户端数量

        awful.key({ modkey, "Shift" }, "h", function()
            awful.tag.incnmaster(1, nil, true)
        end,
                { description = "increase the number of master clients", group = "layout" }),
-- 按下modkey + Shift + l键，减少主客户端数量

        awful.key({ modkey, "Shift" }, "l", function()
            awful.tag.incnmaster(-1, nil, true)
        end,
                { description = "decrease the number of master clients", group = "layout" }),
-- 按下modkey + Control + h键，增加列数

        awful.key({ modkey, "Control" }, "h", function()
            awful.tag.incncol(1, nil, true)
        end,
                { description = "increase the number of columns", group = "layout" }),
-- 按下modkey + Control + l键，减少列数

        awful.key({ modkey, "Control" }, "l", function()
            awful.tag.incncol(-1, nil, true)
        end,
                { description = "decrease the number of columns", group = "layout" }),
-- 按下modkey + space键，选择下一个布局

        awful.key({ modkey, }, "space", function()
            awful.layout.inc(1)
        end,
                { description = "select next", group = "layout" }),
-- 按下modkey + Shift + space键，选择上一个布局

        awful.key({ modkey, "Shift" }, "space", function()
            awful.layout.inc(-1)
        end,
                { description = "select previous", group = "layout" }),
-- 按下modkey + Control + n键，恢复最小化的客户端

        awful.key({ modkey, "Control" }, "n",
                function()
                    local c = awful.client.restore()
                    -- 聚焦恢复的客户端

                    if c then
                        c:emit_signal(
                                "request::activate", "key.unminimize", { raise = true }
                        )
                    end
                end,
                { description = "restore minimized", group = "client" }),

-- 按下modkey + r键打开rofi
        awful.key({ modkey }, "r", function()
            awful.util.spawn("rofi -show drun")
        end,
                { description = "rofi prompt ", group = "launcher" }),
        awful.key({ modkey }, "x",
                function()
                    awful.prompt.run {
                        prompt = "Run Lua code: ",
                        textbox = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                    }
                end,
                { description = "lua execute prompt", group = "awesome" })
)

clientkeys = gears.table.join(
-- 按下modkey + f键切换全屏模式
        awful.key({ modkey, }, "f",
                function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                { description = "toggle fullscreen", group = "client" }),
-- 按下modkey + Shift + c键关闭客户端
--
--        awful.key({ modkey, "Shift" }, "c", function(c)
--            c:kill()
--        end,
--                { description = "close", group = "client" }),
-- 在这里添加你的快捷键
        awful.key(
                { modkey, "Shift" }, "c",
                function()
                    local focused_client = client.focus
                    -- 如果聚焦的窗口不是 polybar，则关闭窗口
                    if not is_focused_client_polybar(focused_client) then
                        focused_client:kill()
                    end
                end,
                { description = "close", group = "client" }),


-- 按下modkey + Control + space键切换浮动模式
        awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
                { description = "toggle floating", group = "client" }),
-- 按下modkey + Control + Return键，将客户端移动到主窗口

        awful.key({ modkey, "Control" }, "Return", function(c)
            c:swap(awful.client.getmaster())
        end,
                { description = "move to master", group = "client" }),
-- 按下modkey + o键将客户端移动到下一个屏幕

        awful.key({ modkey, }, "o", function(c)
            c:move_to_screen()
        end,
                { description = "move to screen", group = "client" }),
-- 按下modkey + t键切换客户端在所有窗口之上

        awful.key({ modkey, }, "t", function(c)
            c.ontop = not c.ontop
        end,
                { description = "toggle keep on top", group = "client" }),
-- 按下modkey + m键最大化/取消最大化客户端

        awful.key({ modkey, }, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
                { description = "(un)maximize", group = "client" }),
-- 按下modkey + Control + m键垂直最大化/取消垂直最大化客户端

        awful.key({ modkey, "Control" }, "m",
                function(c)
                    c.maximized_vertical = not c.maximized_vertical
                    c:raise()
                end,
                { description = "(un)maximize vertically", group = "client" }),
-- 按下modkey + Shift + m键水平最大化/取消水平最大化客户端

        awful.key({ modkey, "Shift" }, "m",
                function(c)
                    c.maximized_horizontal = not c.maximized_horizontal
                    c:raise()
                end,
                { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
    -- View tag only.
            awful.key({ modkey }, "#" .. i + 9,
                    function()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            tag:view_only()
                        end
                    end,
                    { description = "view tag #" .. i, group = "tag" }),

    -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                    function()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end,
                    { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                    function()
                        if client.focus then
                            local tag = client.focus.screen.tags[i]
                            if tag then
                                client.focus:move_to_tag(tag)
                            end
                        end
                    end,
                    { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                    function()
                        if client.focus then
                            local tag = client.focus.screen.tags[i]
                            if tag then
                                client.focus:toggle_tag(tag)
                            end
                        end
                    end,
                    { description = "toggle focused client on tag #" .. i, group = "tag" })

    )
end

-- 绑定字母键a到f到标签
local key_to_tag = {
    a = 10,
    b = 11,
    d = 12,
    e = 13,
    f = 14
}

for key, tag_index in pairs(key_to_tag) do
    globalkeys = gears.table.join(globalkeys,
            awful.key({ modkey }, key,
                    function()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[tag_index]
                        if tag then
                            tag:view_only()
                        end
                    end,
                    { description = "view tag " .. tag_index, group = "tag" }),
    -- 将聚焦的客户端移动到标签
            awful.key({ modkey, "Shift" }, key,
                    function()
                        if client.focus then
                            local tag = client.focus.screen.tags[tag_index]
                            if tag then
                                client.focus:move_to_tag(tag)
                            end
                        end
                    end,
                    { description = "move focused client to tag " .. tag_index, group = "tag" })
    )
end

clientbuttons = gears.table.join(
        awful.button({ }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
        awful.button({ modkey }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        -- properties = { border_width = beautiful.border_width,
      properties = { border_width = 0, -- 窗口的边框
          -- border_color = beautiful.border_normal,
                     border_color = "#B99BE2",
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
            "pinentry",
            "qq",
            "xunlei",
            "wechat-universal",
            "Feishu",
            "telegram-desktop",


        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true } },
    { -- 设置polybar的边框为0
        rule = {},
        except = { class = "Polybar" },
        callback = function(c)
            c.shape = gears.shape.rounded_rect
        end
    },
    { rule = { class = "Polybar" }, callback = function(c)
        c.border_width = 0
    end }

}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Gaps
-- 窗口间间隙
beautiful.useless_gap = 2
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

--awful.spawn.with_shell("picom &")
-- awful.spawn.with_shell("xrandr --output DP-2  --mode 2560x1440 --rate 60")
awful.spawn.with_shell("source $HOME/.config/polybar/launch_polybar.sh")
awful.spawn.with_shell("feh --bg-fill --randomize /home/sam/Pictures/*")
-- awful.spawn.with_shell("mpd &")
-- awful.spawn.with_shell("imwheel")
awful.spawn.with_shell("numlockx on")


