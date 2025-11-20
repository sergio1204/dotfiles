--If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local lain = require("lain")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- ---------------------------------------------------------------------------------
-- ----------------------------  Error handling  ---------------------------------
-- -----------------------------------------------------------------------------

if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

beautiful.notification_border_width = 2
naughty.config.defaults.border_width = beautiful.notification_border_width

-- ---------------------------------------------------------------------------------
-- -----------------------  Variable definitions  --------------------------------
-- -----------------------------------------------------------------------------

-- Colours / Icons / Font
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

-- Term / Web / FM / Editor / Modkey
local term = "alacritty"

local web = "vivaldi-stable"
local files = "yazi"
local editor = "nvim"

local web2 = "firefox"
local files2 = "vifm"
local editor2 = "code-oss"

local cal = "calcurse"
local modkey = "Mod4"

-- Layouts
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
}

-- ---------------------------------------------------------------------------------
-- -------------------------------  Wibar  ---------------------------------------
-- -----------------------------------------------------------------------------

-- Volume widget
local volume = lain.widget.pulse({
	settings = function()
		local vol_level = "   " .. volume_now.left .. "% "
		if volume_now.muted == "yes" then
			vol_level = "   " .. volume_now.left .. "% "
		end
		widget:set_markup(lain.util.markup(beautiful.fg_vol, vol_level))
	end,
})

-- Memory widget
local mymem = lain.widget.mem({
	timeout = 3,
	settings = function()
		widget:set_markup(lain.util.markup(beautiful.fg_mem, "   " .. mem_now.used .. "M "))
	end,
})

-- Cpu widget
local mycpu = lain.widget.cpu({
	timeout = 3,
	settings = function()
		widget:set_markup(lain.util.markup(beautiful.fg_cpu, "   " .. cpu_now.usage .. "% "))
	end,
})

-- Temp widget
local mytemp = lain.widget.temp({
	timeout = 15,
	settings = function()
		widget:set_markup(lain.util.markup(beautiful.fg_temp, "  " .. coretemp_now .. "°C "))
	end,
})

-- Battery widget
local mybattery = lain.widget.bat({
	notify = "off",
	timeout = 30,
	settings = function()
		local bat_level = "  " .. bat_now.perc .. "% "
		if bat_now.status == "Discharging" then
			bat_level = "   " .. bat_now.perc .. "% "
		end
		widget:set_markup(lain.util.markup(beautiful.fg_bat, bat_level))
	end,
})

-- Keyboard widget
local mykeyboardlayout = awful.widget.keyboardlayout()
local keyboard_clr = wibox.container.background()
keyboard_clr:set_widget(mykeyboardlayout)
keyboard_clr:set_fg(beautiful.fg_keyboard)
local keyboard_icon = wibox.widget({
	markup = "<span foreground='" .. beautiful.fg_keyboard .. "'>  </span>",
	widget = wibox.widget.textbox,
})

-- Clock widget
local mytextclock = wibox.widget.textclock("  %H:%M:%S", 1)
local clock_clr = wibox.container.background()
clock_clr:set_widget(mytextclock)
clock_clr:set_fg(beautiful.fg_time)

-- Calendar widget
local mycal = lain.widget.cal({
	icons = "/",
	attach_to = { clock_clr },
	notification_preset = {
		font = "BlexMono Nerd Font 11",
		fg = beautiful.fg_focus,
		bg = beautiful.bg_normal,
	},
})

-- Volume widget buttons
volume.widget:buttons(awful.util.table.join(
	awful.button({}, 1, function()
		os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
		volume.update()
	end),
	awful.button({}, 3, function()
		awful.spawn(string.format("pavucontrol"))
	end),
	awful.button({}, 4, function()
		os.execute(string.format("pactl set-sink-volume %s +5%%", volume.device))
		volume.update()
	end),
	awful.button({}, 5, function()
		os.execute(string.format("pactl set-sink-volume %s -5%%", volume.device))
		volume.update()
	end)
))

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
		if client.focus then
			awful.tag.history.restore()
		end
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),

	-- Non-empty tag browsing
	awful.button({}, 4, function()
		lain.util.tag_view_nonempty(1)
	end),
	awful.button({}, 5, function()
		lain.util.tag_view_nonempty(-1)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

-- Wallpaper
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
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.focused,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{
			-- Left widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 5,
			wibox.container.margin(s.mytaglist, 5),
			s.mylayoutbox,
		},
		-- Middle widget
		s.mytasklist,
		{
			-- Right widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
			volume,
			mymem,
			mycpu,
			mytemp,
			mybattery,
			keyboard_icon,
			wibox.container.margin(keyboard_clr, -20),
			clock_clr,
			wibox.widget.systray(),
		},
	})
end)

-- -----------------------------------------------------
-- ----------------  Key bindings  -------------------
-- -------------------------------------------------

local globalkeys = gears.table.join(

	-- Non-empty tag browsing
	awful.key({ modkey }, "Tab", function()
		lain.util.tag_view_nonempty(1)
	end),
	awful.key({ modkey }, "grave", function()
		lain.util.tag_view_nonempty(-1)
	end),
	awful.key({ modkey }, "Escape", function()
		awful.tag.history.restore()
	end),

	-- Focus window
	awful.key({ modkey }, "a", function()
		awful.client.focus.byidx(1)
	end),
	awful.key({ modkey, "Shift" }, "a", function()
		awful.client.focus.byidx(-1)
	end),
	awful.key({ modkey }, "Right", function()
		awful.client.focus.byidx(1)
	end),
	awful.key({ modkey }, "Left", function()
		awful.client.focus.byidx(-1)
	end),

	-- Swap windows / Move tray to focused screen
	awful.key({ modkey }, "g", function()
		awful.client.swap.byidx(1)
	end),
	awful.key({ modkey, "Shift" }, "g", function()
		awful.client.swap.byidx(-1)
	end),
	awful.key({ modkey, "Shift" }, "Right", function()
		awful.client.swap.byidx(1)
	end),
	awful.key({ modkey, "Shift" }, "Left", function()
		awful.client.swap.byidx(-1)
	end),
	awful.key({ modkey }, "t", function()
		local traywidget = wibox.widget.systray()
		traywidget:set_screen(awful.screen.focused())
	end),

	-- Rofi
	awful.key({ modkey }, "z", function()
		awful.spawn("rofi -show drun", false)
	end),
	awful.key({ modkey, "Shift" }, "z", function()
		awful.spawn("rofi -show run", false)
	end),

	-- Terminal / FM / Editor / Calendar
	awful.key({ modkey }, "Return", function()
		awful.spawn(term .. " --class term ", false)
	end),
	awful.key({ modkey }, "x", function()
		awful.spawn(term .. " --class files -e " .. files, false)
	end),
	awful.key({ modkey }, "backslash", function()
		awful.spawn(term .. " --class editor -e " .. editor, false)
	end),
	awful.key({ modkey, "Shift" }, "x", function()
		awful.spawn(term .. " --class files -e " .. files2, false)
	end),
	awful.key({ modkey, "Shift" }, "backslash", function()
		awful.spawn(editor2, false)
	end),
	awful.key({ modkey }, "v", function()
		awful.spawn(term .. " --class cal -e " .. cal, false)
	end),
	awful.key({ modkey, "Shift" }, "v", function()
		awful.spawn(" killall -q " .. cal, false)
	end),
	-- Apps keys
	awful.key({ modkey }, "c", function()
		awful.spawn(web .. " --class='web' ", false)
	end),
	awful.key({ modkey, "Shift" }, "c", function()
		awful.spawn(web2 .. " --class='web' ", false)
	end),
	awful.key({ modkey }, "d", function()
		awful.spawn("audacious", false)
	end),
	awful.key({ modkey, "Shift" }, "d", function()
		awful.spawn("audacious --play-pause", false)
	end),
	awful.key({ modkey }, "XF86AudioRaiseVolume", function()
		awful.spawn("audacious --fwd", false)
	end),
	awful.key({ modkey }, "XF86AudioLowerVolume", function()
		awful.spawn("audacious --rew", false)
	end),
	awful.key({ modkey }, "p", function()
		awful.spawn("picom", false)
	end),
	awful.key({ modkey, "Shift" }, "p", function()
		awful.spawn("killall -q picom", false)
	end),
	awful.key({ modkey }, "u", function()
		awful.spawn("udiskie --tray", false)
	end),

	-- Volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute(string.format("pactl set-sink-volume %s +5%%", volume.device))
		volume.update()
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute(string.format("pactl set-sink-volume %s -5%%", volume.device))
		volume.update()
	end),
	awful.key({}, "XF86AudioMute", function()
		os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
		volume.update()
	end),

	-- Brightness control
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("brightnessctl s +10%", false)
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("brightnessctl s 10%-", false)
	end),

	-- Lockscreen / Printscreen
	awful.key({ modkey }, "l", function()
		awful.spawn("i3lock -k -t -i /home/sergey/Pictures/soty.png", false)
	end),
	awful.key({}, "Print", function()
		awful.spawn("scrot -s", false)
	end),
	awful.key({ "Shift" }, "Print", function()
		awful.spawn("scrot -d 1", false)
	end),

	-- Reload / Quit / Reboot / Poweroff / Suspend
	awful.key({ modkey, "Shift" }, "r", awesome.restart),
	awful.key({ modkey, "Shift" }, "l", awesome.quit),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.spawn("systemctl reboot")
	end),
	awful.key({ modkey, "Shift" }, "m", function()
		awful.spawn("systemctl poweroff")
	end),
	awful.key({ modkey, "Shift" }, "j", function()
		awful.spawn("systemctl suspend")
	end),

	-- Resize window
	awful.key({ modkey, "Control" }, "Right", function()
		awful.tag.incmwfact(0.1)
	end),
	awful.key({ modkey, "Control" }, "Left", function()
		awful.tag.incmwfact(-0.1)
	end),

	-- Layouts
	awful.key({ modkey }, "s", function()
		awful.layout.inc(1)
	end),
	awful.key({ modkey, "Shift" }, "s", function()
		awful.layout.inc(-1)
	end)
)

local clientkeys = gears.table.join(

	-- Floating / Fullscreen
	awful.key({ modkey }, "e", awful.client.floating.toggle),
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end),

	-- Kill window / Swap to master
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end),
	awful.key({ modkey, "Shift" }, "q", function(c)
		if c.pid then
			awful.spawn("kill -9 " .. c.pid)
		end
	end),
	awful.key({ modkey }, "space", function(c)
		c:swap(awful.client.getmaster())
	end),

	-- Maximize
	awful.key({ modkey }, "w", function(c)
		c.maximized = not c.maximized
		c:raise()
	end),
	awful.key({ modkey, "Shift" }, "w", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end),
	awful.key({ modkey, "Control" }, "w", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end)
)

-- Bind all key numbers to tags.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,

		-- View tag only
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),

		-- Toggle tag display
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end),

		-- Move client and focus to tag
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
					tag:view_only()
				end
			end
		end),

		-- Toggle tag on focused client
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
					tag:view_only()
				end
			end
		end)
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
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

-- ---------------------------------------------------------------------------------
-- -----------------------------  Rules  -----------------------------------------
-- -----------------------------------------------------------------------------

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {

	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Blueman-manager",
				"Steam",
				"XCalc",
				-- "cal",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	{ rule = { class = "web" }, properties = { tag = "1", switchtotag = true } },
	{ rule = { class = "files" }, properties = { tag = "2", switchtotag = true } },
	{ rule = { class = "Audacious" }, properties = { tag = "3", switchtotag = true } },
	{ rule = { class = "term" }, properties = { tag = "4", switchtotag = true, size_hints_honor = false } },
	{ rule = { class = "editor" }, properties = { tag = "5", switchtotag = true } },
	{ rule = { class = "code-oss" }, properties = { tag = "5", switchtotag = true } },
	{ rule = { class = "mpv" }, properties = { tag = "6", switchtotag = true } },
	{ rule = { class = "Gimp" }, properties = { tag = "7", switchtotag = true } },
	{ rule = { class = "Telegram" }, properties = { tag = "8", switchtotag = true } },
	{ rule = { class = "Steam" }, properties = { tag = "9", switchtotag = true } },
}

-- --------------------------------------------------------------------------------------
-- ---------------------------------  Signals  ----------------------------------------
-- ----------------------------------------------------------------------------------

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Disable border when single tiled window
screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1
	for _, c in pairs(s.clients) do
		if only_one and not c.floating and not c.maximized then
			c.border_width = 0
		elseif c.fullscreen then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)

-- Jump to urgent
client.connect_signal("property::urgent", function(c)
	c:jump_to()
end)

-- Autostart
awful.spawn.with_shell("$HOME/.config/awesome/autostart.sh")
