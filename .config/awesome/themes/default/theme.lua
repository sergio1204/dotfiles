-- --------------------------------------------------------
-- ----------------- Awesome theme ----------------------
-- ----------------------------------------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local theme = {}

-- Font / Wall / Bar size
theme.font = "BlexMono Nerd Font 11"
theme.wallpaper = "Pictures/wallpaper.jpg"
theme.wibar_height = dpi(28)

-- Widget colors
theme.fg_vol = "#CDDC45"
theme.fg_mem = "#E183E1"
theme.fg_cpu = "#6CD7DC"
theme.fg_temp = "#F86D85"
theme.fg_bat = "#88EE9A"
theme.fg_time = "#f0b574"
theme.fg_keyboard = "#F57CB8"

-- Background
theme.bg_normal = "#23252e"
theme.bg_focus = "#4B7093"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#404b17"
theme.bg_systray = theme.bg_normal

-- Foreground
theme.fg_normal = "#bcbcbc"
theme.fg_focus = "#AAC9F1"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"
theme.fg_occupied = "#eab268"

-- Gaps / Borders
theme.useless_gap = dpi(0)
theme.border_width = dpi(2)
theme.master_width_factor = 0.4
theme.border_normal = theme.bg_normal
theme.border_focus = theme.bg_focus
theme.border_marked = "#d87c1e"

-- Square
local taglist_square_size = dpi(5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_focus)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.bg_normal)

-- Taglist
theme.taglist_spacing = dpi(3)
theme.taglist_bg_focus = theme.bg_normal
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_fg_occupied = theme.fg_occupied

-- Tasklist
theme.tasklist_disable_icon = true
theme.tasklist_bg_focus = theme.bg_normal
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_normal = theme.fg_focus

-- Layout
theme.layout_tilebottom = ".config/awesome/themes/default/icons/tilebot.png"
theme.layout_tile = ".config/awesome/themes/default/icons/tile.png"

-- Menubar
theme.menu_fg_focus = theme.fg_urgent

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Generate Awesome icon:
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_normal, theme.fg_focus

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

return theme
