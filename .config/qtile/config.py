#  lopyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from typing import List  # noqa: F401

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([home])


@hook.subscribe.group_window_add
def switchtogroup(group, window):
    group.toscreen()


# Terminal / Browser / FM / Editor / Modkey
terminal = "alacritty"

browser = "vivaldi-stable"
file_manager = "yazi"
editor = "nvim"

browser2 = "firefox"
file_manager2 = "vifm"
editor2 = "code-oss"

calendar = "calcurse"
mod = "mod4"

# -------------------------------------------------
# -------------------  Keys  --------------------
# ---------------------------------------------

keys = [
    # ----------------------------
    # Switch focus between windows
    # ----------------------------
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "a", lazy.group.next_window()),
    Key([mod, "shift"], "a", lazy.group.prev_window()),
    # ---------------------------
    # Switch focus between groups
    # ---------------------------
    Key([mod], "Tab", lazy.screen.next_group(skip_empty=True)),
    Key([mod], "grave", lazy.screen.prev_group(skip_empty=True)),
    Key([mod], "Escape", lazy.screen.toggle_group()),
    # ---------------------
    # Move focused  windows
    # ---------------------
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "g", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),
    Key([mod], "g", lazy.layout.swap_right()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod], "space", lazy.layout.swap_main()),
    # ------------------------------------
    # Shrink / Grow / Normalize / Maximize
    # ------------------------------------
    Key([mod, "control"], "Left", lazy.layout.shrink_main()),
    Key([mod, "control"], "Right", lazy.layout.grow_main()),
    Key([mod, "control"], "Up", lazy.layout.shrink()),
    Key([mod, "control"], "Down", lazy.layout.grow()),
    Key([mod], "n", lazy.layout.reset()),
    Key([mod], "w", lazy.layout.maximize()),
    # ---------------------
    # Floating / Fullscreen
    # ---------------------
    Key([mod], "e", lazy.window.toggle_floating()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    # ---------------------
    # Split / Kill / Reload
    # ---------------------
    Key([mod], "s", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.reload_config()),
    # --------------
    # Volume control
    # --------------
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
    ),
    # ------------------
    # Brightness control
    # ------------------
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 10%-")),
    # ------------------------
    # Lockscreen / Printscreen
    # ------------------------
    Key([mod], "l", lazy.spawn("i3lock -k -i /home/sergey/Pictures/soty.png")),
    Key([], "Print", lazy.spawn("scrot -s")),
    Key(["shift"], "Print", lazy.spawn("scrot -d 1")),
    # --------------------------
    # Reboot / Poweroff / Suspend / Logout
    # --------------------------
    Key([mod, "shift"], "k", lazy.spawn("systemctl reboot")),
    Key([mod, "shift"], "m", lazy.spawn("systemctl poweroff")),
    Key([mod, "shift"], "j", lazy.spawn("systemctl suspend")),
    Key([mod, "shift"], "l", lazy.shutdown(), desc="logout Qtile"),
    # ------------
    # Dunst / Rofi
    # ------------
    Key([mod], "i", lazy.spawn("dunstctl history-pop")),
    Key([mod, "shift"], "i", lazy.spawn("dunstctl close-all")),
    Key([mod], "z", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "z", lazy.spawn("rofi -show run")),
    # --------
    # Terminal / FM / Editor / Calendar
    # --------
    Key([mod], "Return", lazy.spawn(terminal + " --class terminal ")),
    Key([mod], "x", lazy.spawn(terminal + " --class files -e " + file_manager)),
    Key([mod], "backslash", lazy.spawn(terminal + " --class editor -e " + editor)),
    Key(
        [mod, "shift"],
        "x",
        lazy.spawn(terminal + " --class files -e " + file_manager2),
    ),
    Key(
        [mod, "shift"],
        "backslash",
        lazy.spawn(editor2),
    ),
    Key([mod], "v", lazy.spawn(terminal + " --class calendar -e " + calendar)),
    # ---------
    # Apps keys
    # ---------
    Key([mod], "c", lazy.spawn(browser + " --class='web' ")),
    Key([mod, "shift"], "c", lazy.spawn(browser2 + " --class='web' ")),
    Key([mod], "d", lazy.spawn("audacious")),
    Key([mod, "shift"], "d", lazy.spawn("audacious --play-pause")),
    Key([mod], "XF86AudioRaiseVolume", lazy.spawn("audacious --fwd")),
    Key([mod], "XF86AudioLowerVolume", lazy.spawn("audacious --rew")),
    Key([mod], "p", lazy.spawn("picom")),
    Key([mod, "shift"], "p", lazy.spawn("killall -q picom")),
    Key([mod], "u", lazy.spawn("udiskie --tray")),
]

# ----------------------------------------------------
# ------------------  Groups  ----------------------
# ------------------------------------------------

groups = [
    Group("1", matches=[Match(wm_class="web")]),
    Group("2", matches=[Match(wm_class="files")]),
    Group("3", matches=[Match(wm_class="audacious")]),
    Group("4", matches=[Match(wm_class="terminal")]),
    Group("5", matches=[Match(wm_class="editor"), Match(wm_class="code-oss")]),
    Group("6", matches=[Match(wm_class="mpv")]),
    Group("7", matches=[Match(wm_class="gimp")]),
    Group("8", matches=[Match(wm_class="Telegram")]),
    Group("9", matches=[Match(wm_class="Steam")]),
]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(toggle=True),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

# ----------------------------------------------------
# -----------------  Layouts  ----------------------
# ------------------------------------------------

layouts = [
    layout.MonadTall(
        name="  ",
        border_focus="#4B7093",
        border_normal="#23252e",
        border_width=2,
        change_ratio=0.1,
        max_ratio=0.9,
        min_ratio=0.1,
        ratio=0.4,
        new_client_position="top",
        single_border_width=False,
    ),
    layout.MonadWide(
        name="  ",
        border_focus="#4B7093",
        border_normal="#23252e",
        border_width=2,
        new_client_position="top",
        single_border_width=False,
    ),
]

# -----------------------------------------------
# ---------------  Widgets  -------------------
# -------------------------------------------

widget_defaults = dict(
    font="BlexMono Nerd Font",
    fontsize=15,
    padding=1,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="Pictures/wallpaper.jpg",
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.GroupBox(
                    disable_drag="True",
                    active="#eab268",
                    block_highlight_text_color="#AAC9F1",
                    highlight_method="line",
                    highlight_color="#23252e",
                    hide_unused="True",
                    invert_mouse_wheel="True",
                    this_current_screen_border="#AAC9F1",
                    mouse_callbacks={"Button3": lazy.spawn("rofi -show drun")},
                    borderwidth=3,
                    margin=5,
                ),
                widget.CurrentLayout(
                    foreground="#F16E88",
                    padding=5,
                ),
                widget.WindowName(
                    foreground="#AAC9F1",
                    mouse_callbacks={"Button2": lazy.window.kill()},
                    max_chars=100,
                    padding=10,
                ),
                widget.Volume(
                    foreground="#CDDC45",
                    unmute_format="  {volume}%",
                    mute_foreground="#ff3e72",
                    mute_format="  {volume}%",
                    mouse_callbacks={"Button3": lazy.spawn("pavucontrol")},
                    step=5,
                    padding=20,
                ),
                widget.Memory(
                    foreground="#E183E1",
                    format=" {MemUsed: .0f}{mm}",
                    update_interval=3,
                    padding=18,
                ),
                widget.CPU(
                    foreground="#6CD7DC",
                    format="  {load_percent}%",
                    update_interval=3,
                    padding=18,
                ),
                widget.ThermalZone(
                    fgcolor_normal="#F86D85",
                    format=" {temp}°C",
                    high=80,
                    update_interval=15,
                    padding=18,
                ),
                widget.Battery(
                    foreground="#88EE9A",
                    full_char=" ",
                    charge_char=" ",
                    discharge_char="  ",
                    format="{char}{percent:2.0%}",
                    show_short_text=None,
                    update_interval=30,
                    padding=18,
                ),
                widget.Clock(
                    foreground="#f0b574",
                    format="  %H:%M:%S",
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            terminal + " --class calendar " + calendar
                        ),
                        "Button3": lazy.spawn("killall -q calcurse"),
                    },
                    padding=18,
                ),
                widget.KeyboardKbdd(
                    foreground="#F57CB8",
                    fmt="  {}",
                    configured_keyboards=["us", "ru"],
                    padding=18,
                ),
                widget.Systray(),
            ],
            28,
            background="#23252e",
        ),
    ),
]

# -----------------------------------------------------------------
# ----------------------  Mouse keys  ---------------------------
# -------------------------------------------------------------

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click(
        [mod],
        "Button2",
        lazy.window.bring_to_front(),
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# ---------------------------------------
# ----------  Floating  ---------------
# -----------------------------------

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="Blueman-manager"),
        Match(wm_class="Steam"),
        Match(wm_class="xcalc"),
        # Match(wm_class="calendar"),
    ],
    border_focus="#ac4142",
    border_width=2,
)

auto_fullscreen = True
focus_on_window_activation = "focus"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
wmname = "qtile"
