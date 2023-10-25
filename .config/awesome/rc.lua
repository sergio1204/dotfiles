-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local lain          = require("lain")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")

-- {{{ Error handling {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

if awesome.startup_errors then
    naughty.notify({
            preset = naughty.config.presets.critical,
            title  = "Oops, there were errors during startup!",
            text   = awesome.startup_errors
        })
end

-- Handle runtime errors after startup ===================
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title  = "Oops, an error happened!",
            text   = tostring(err)
        })
        in_error = false
    end)
end

-- {{{ Variable definitions {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

-- Colours / Icons / Font ===============================================================================
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

-- Terminal / FM / Editor / Modkey ==================================
terminal          = "alacritty"
file_manager      = "nnn"
file_manager2     = "ranger"
editor            = os.getenv("EDITOR") or "nano"

terminal_cmd      = terminal .. " --class terminal "
file_manager_cmd  = terminal .. " --class files -e " .. file_manager
file_manager_cmd2 = terminal .. " --class files -e " .. file_manager2
editor_cmd        = terminal .. " --class editor -e " .. editor

modkey            = "Mod4"

-- Layouts =======================
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom
}

-- Menubar configuration
menubar.utils.terminal = terminal

-- {{{ Wibar {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

-- Volume widget ===========================================================================
local volume = lain.widget.alsa {
    settings = function()
        vol_level = "  " .. volume_now.level .. "% "
        if volume_now.status == "off" then
            vol_level = "  " .. volume_now.level .. "% "
        end
        widget:set_markup(lain.util.markup(beautiful.fg_vol, vol_level))
    end
}

-- Memory widget ============================================================================
local mymem = lain.widget.mem {
    timeout = 3,
    settings = function()
        widget:set_markup(lain.util.markup(beautiful.fg_mem, "  " .. mem_now.used .. "M "))
    end
}

-- Cpu widget ================================================================================
local mycpu = lain.widget.cpu {
    timeout = 3,
    settings = function()
        widget:set_markup(lain.util.markup(beautiful.fg_cpu, "  " .. cpu_now.usage .. "% "))
    end
}

-- Temp widget ================================================================================
local mytemp = lain.widget.temp {
    timeout = 15,
    settings = function()
        widget:set_markup(lain.util.markup(beautiful.fg_temp, "  " .. coretemp_now .. "°C "))
    end
}

-- Battery widget ========================================================
local mybattery = lain.widget.bat {
    notify = "off",
    timeout = 30,
    settings = function()
        bat_level = "  " .. bat_now.perc .. "%"
        if bat_now.status == "Discharging" then
            bat_level = "  " .. bat_now.perc .. "%"
        end
        widget:set_markup(lain.util.markup(beautiful.fg_bat, bat_level))
    end
}

-- Keyboard widget ================================
mykeyboardlayout   = awful.widget.keyboardlayout()
local keyboard_clr = wibox.widget.background()
keyboard_clr:set_widget(mykeyboardlayout)
keyboard_clr:set_fg(beautiful.fg_keyboard)

-- Clock widget ===========================================
mytextclock     = wibox.widget.textclock(" %H:%M:%S", 1)
local clock_clr = wibox.widget.background()
clock_clr:set_widget(mytextclock)
clock_clr:set_fg(beautiful.fg_time)

-- Calendar widget ==================
local mycal = lain.widget.cal {
    icons = "/",
    attach_to = { clock_clr },
    notification_preset = {
        font = "JetBrains Mono 12",
        fg   = beautiful.fg_focus,
        bg   = beautiful.bg_normal
    }
}

-- Volume widget buttons =====================================================================================
volume.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
            os.execute(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
            volume.update()
        end),
    awful.button({ }, 3, function()
            awful.spawn(string.format("%s -e alsamixer", terminal))
        end),
    awful.button({ }, 4, function()
            os.execute(string.format("%s set %s 5%%+", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.button({ }, 5, function()
            os.execute(string.format("%s set %s 5%%-", volume.cmd, volume.channel))
            volume.update()
        end)
))

-- Create a wibox for each screen and add it =======================
local taglist_buttons = gears.table.join(
        awful.button({        }, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end),
        awful.button({        }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end),
        -- Non-empty tag browsing ============================================
        awful.button({ }, 4, function(t) lain.util.tag_view_nonempty( 1) end),
        awful.button({ }, 5, function(t) lain.util.tag_view_nonempty(-1) end)
)

local tasklist_buttons = gears.table.join(
        awful.button({ }, 1, function(c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c:emit_signal("request::activate", "tasklist", { raise = true })
                    end
                end),
        awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 }}) end),
        awful.button({ }, 4, function() awful.client.focus.byidx( 1) end),
        awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

-- Wallpaper ===========================================
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper ====
    set_wallpaper(s)

    -- Each screen has its own tag table ==================================================
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                        awful.button({ }, 1, function() awful.layout.inc( 1) end),
                        awful.button({ }, 3, function() awful.layout.inc(-1) end),
                        awful.button({ }, 4, function() awful.layout.inc( 1) end),
                        awful.button({ }, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget ========================
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget ============================
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox ======================================
    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            wibox.container.margin (s.mytaglist, 5),
            s.mylayoutbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            volume,
            mymem,
            mycpu,
            mytemp,
            mybattery,
            keyboard_clr,
            clock_clr,
            wibox.widget.systray()
        }
    }
end)

-- {{{ Key bindings {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

globalkeys = gears.table.join(
    -- Non-empty tag browsing =================================================================
    awful.key({ modkey            }, "Tab",   function() lain.util.tag_view_nonempty( 1) end),
    awful.key({ modkey            }, "grave", function() lain.util.tag_view_nonempty(-1) end),

    -- Focus window ========================================================================
    awful.key({ modkey            }, "a",     function() awful.client.focus.byidx( 1) end),
    awful.key({ modkey, "Shift"   }, "a",     function() awful.client.focus.byidx(-1) end),
    awful.key({ modkey            }, "Right", function() awful.client.focus.byidx( 1) end),
    awful.key({ modkey            }, "Left",  function() awful.client.focus.byidx(-1) end),

    -- Menubar / Rofi / Helper ===========================================================
    awful.key({ modkey            }, "z", function() menubar.show() end),
    awful.key({ modkey, "Shift"   }, "z", function() awful.spawn("rofi -show drun") end),
    awful.key({ modkey            }, "h", hotkeys_popup.show_help),

    -- Swap windows =======================================================================
    awful.key({ modkey            }, "g",     function() awful.client.swap.byidx( 1) end),
    awful.key({ modkey, "Shift"   }, "g",     function() awful.client.swap.byidx(-1) end),
    awful.key({ modkey, "Shift"   }, "Right", function() awful.client.swap.byidx( 1) end),
    awful.key({ modkey, "Shift"   }, "Left",  function() awful.client.swap.byidx(-1) end),

    -- Terminal / FM / Editor ===================================================================
    awful.key({ modkey            }, "Return",    function() awful.spawn(terminal_cmd) end),
    awful.key({ modkey            }, "x",         function() awful.spawn(file_manager_cmd) end),
    awful.key({ modkey, "Shift"   }, "x",         function() awful.spawn(file_manager_cmd2) end),
    awful.key({ modkey            }, "backslash", function() awful.spawn(editor_cmd) end),

    -- Apps keys ================================================================================
    awful.key({ modkey            }, "c", function() awful.spawn("firefox") end),
    awful.key({ modkey            }, "d", function() awful.spawn("quodlibet") end),
    awful.key({ modkey, "Shift"   }, "d", function() awful.spawn("quodlibet --play-pause") end),
    awful.key({ modkey            }, "v", function() mycal.show(0) end),
    awful.key({ modkey, "Shift"   }, "v", function() mycal.hide() end),

    -- Volume control ===========================================================================
    awful.key({ }, "XF86AudioRaiseVolume", function()
            os.execute(string.format("amixer set %s 5%%+", volume.channel))
            volume.update()
        end),
    awful.key({ }, "XF86AudioLowerVolume", function()
            os.execute(string.format("amixer set %s 5%%-", volume.channel))
            volume.update()
        end),
    awful.key({ }, "XF86AudioMute", function()
            os.execute(string.format("amixer set %s toggle", volume.togglechannel or volume.channel))
            volume.update()
        end),

    -- Brightness control =======================================================================
    awful.key({ }, "XF86MonBrightnessUp",   function() awful.spawn("brightnessctl s +10%") end),
    awful.key({ }, "XF86MonBrightnessDown", function() awful.spawn("brightnessctl s 10%-") end),

    -- Lockscreen / Printscreen =======================================================================================
    awful.key({ modkey            }, "l",     function() awful.spawn("i3lock -i /home/sergey/Pictures/soty.png") end),
    awful.key({                   }, "Print", function() awful.spawn("scrot -s") end),
    awful.key({         "Shift"   }, "Print", function() awful.spawn("scrot -d 1") end),

    -- Reload / Quit / Reboot / Poweroff ====================================================
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "l", awesome.quit),
    awful.key({ modkey, "Shift"   }, "k", function() awful.spawn("systemctl reboot") end),
    awful.key({ modkey, "Shift"   }, "m", function() awful.spawn("systemctl poweroff") end),

    -- Resize window ====================================================================
    awful.key({ modkey, "Control" }, "Right", function() awful.tag.incmwfact( 0.1) end),
    awful.key({ modkey, "Control" }, "Left",  function() awful.tag.incmwfact(-0.1) end),

    -- Layouts =================================================================
    awful.key({ modkey            }, "s", function() awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift"   }, "s", function() awful.layout.inc(-1) end),

    -- Unminimize =========================================================================
    awful.key({ modkey, "Shift"   }, "b", function()
                local c = awful.client.restore()
                if c then
                    c:emit_signal("request::activate", "key.unminimize", { raise = true })
                end
            end)
)

clientkeys = gears.table.join(
    -- Floating / Fullscreen / Ontop / Sticky ========================================================
    awful.key({ modkey            }, "e", awful.client.floating.toggle),
    awful.key({ modkey            }, "f", function(c) c.fullscreen = not c.fullscreen c:raise() end),
    awful.key({ modkey            }, "t", function(c) c.ontop = not c.ontop end),
    awful.key({ modkey            }, "r", function(c) c.sticky = not c.sticky end),

    -- Kill window / Swap to master =============================================================
    awful.key({ modkey            }, "q",     function(c) c:kill() end),
    awful.key({ modkey            }, "space", function(c) c:swap(awful.client.getmaster()) end),

    -- Minimize / Maximize ==============================================================================================
    awful.key({ modkey            }, "b", function(c) c.minimized = true end),
    awful.key({ modkey            }, "w", function(c) c.maximized = not c.maximized c:raise() end),
    awful.key({ modkey, "Shift"   }, "w", function(c) c.maximized_vertical = not c.maximized_vertical c:raise() end),
    awful.key({ modkey, "Control" }, "w", function(c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end)
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only =================================
        awful.key({ modkey }, "#" .. i + 9, function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        tag:view_only()
                    end
                end),
        -- Toggle tag display ====================================
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        awful.tag.viewtoggle(tag)
                    end
                end),
        -- Move client and focus to tag ========================
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                            tag:view_only()
                        end
                    end
                end),
        -- Toggle tag on focused client ===================================
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end)
    )
end

clientbuttons = gears.table.join(
    awful.button({        }, 1, function(c)
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

-- {{{ Rules {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { }, properties = {
            size_hints_honor = false,
            border_width     = beautiful.border_width,
            border_color     = beautiful.border_normal,
            focus            = awful.client.focus.filter,
            raise            = true,
            keys             = clientkeys,
            buttons          = clientbuttons,
            screen           = awful.screen.preferred,
            placement        = awful.placement.no_overlap+awful.placement.no_offscreen
        },
    },
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry"
        },
        class = {
          "Blueman-manager",
          "Steam",
          "feh",
          "XCalc"
        },
        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester"  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up"       -- e.g. Google Chrome's (detached) Developer Tools.
        },
      },
      properties = { floating = true }},

    { rule = { class = "firefox" },   properties = { tag = "1", switchtotag = true }},
    { rule = { class = "files" },     properties = { tag = "2", switchtotag = true }},
    { rule = { class = "Quodlibet" }, properties = { tag = "3", switchtotag = true }},
    { rule = { class = "Audacity" },  properties = { tag = "3", switchtotag = true }},
    { rule = { class = "terminal" },  properties = { tag = "4", switchtotag = true }},
    { rule = { class = "editor" },    properties = { tag = "5", switchtotag = true }},
    { rule = { class = "mpv" },       properties = { tag = "6", switchtotag = true }},
    { rule = { class = "Gimp-2.10" }, properties = { tag = "7", switchtotag = true }},
    { rule = { class = "Picard" },    properties = { tag = "8", switchtotag = true }},
    { rule = { class = "Steam" },     properties = { tag = "9", switchtotag = true }}
}

-- {{{ Signals {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

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

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable border when single or maximize window =====================
screen.connect_signal("arrange", function(s)
    local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if (max or only_one) and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Jump to urgent
client.connect_signal("property::urgent", function(c) c:jump_to() end)
-- }}}
