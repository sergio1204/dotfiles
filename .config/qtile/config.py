# Copyright (c) 2010 Aldo Cortesi
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

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import os
import subprocess

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.run([home])

mod = "mod4"
alt = "mod1"

keys = [
    # Switch focus between windows and groups --------------------------------------
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "a", lazy.group.next_window()),
    Key([mod], "Tab", lazy.screen.next_group(skip_empty=True)),
    Key([mod, "shift"], "Tab", lazy.screen.toggle_group()),
    # Move focused  window ---------------------------------------------------------
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    # Grow / Shrink / Normalize / Maximize -----------------------------------------
    Key([mod, "control"], "Left", lazy.layout.grow_left()),
    Key([mod, "control"], "Right", lazy.layout.grow_right()),
    Key([mod, "control"], "Down", lazy.layout.grow_down()),
    Key([mod, "control"], "Up", lazy.layout.grow_up()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "b", lazy.layout.maximize()),
    # Split / Floating / Fullscreen -----------------------------------------------
    Key([mod], "s", lazy.layout.toggle_split()),
    Key([mod], "e", lazy.window.toggle_floating()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    # Next layout / Kill / Reload -------------------------------------------------
    Key([mod], "w", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.reload_config()),
    # Volume control --------------------------------------------------------------
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle")),
    # Brightness ------------------------------------------------------------------
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 10%-")),
    # Lockscreen ------------------------------------------------------------------
    Key([mod], "l", lazy.spawn("i3lock -i /home/sergey/Pictures/soty.png")),
    # Reboot / Poweroff / Logout --------------------------------------------------
    Key([mod, "shift"], "k", lazy.spawn("systemctl reboot")),
    Key([mod, "shift"], "m", lazy.spawn("systemctl poweroff")),
    Key([mod, "shift"], "l", lazy.shutdown(), desc="logout Qtile"),
    # Dunst -----------------------------------------------------------------------
    Key([mod], "u", lazy.spawn("dunstctl history-pop")),
    Key([mod, "shift"], "u", lazy.spawn("dunstctl close-all")),
    # Rofi ------------------------------------------------------------------------
    Key([mod], "z", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "z", lazy.spawn("rofi -show run")),
    # Picom -----------------------------------------------------------------------
    Key([mod], "p", lazy.spawn("picom &")),
    Key([mod, "shift"], "p", lazy.spawn("killall picom")),
    # Apps keys -------------------------------------------------------------------
    Key([mod], "c", lazy.spawn("firefox")),
    Key([mod], "Return", lazy.spawn("xterm")),
    Key([mod], "x", lazy.spawn("xterm -e ranger")),
    Key([mod, "shift"], "x", lazy.spawn("pcmanfm-qt")),
    Key([mod], "d", lazy.spawn("quodlibet")),
    Key([mod, "shift"], "d", lazy.spawn("quodlibet --play-pause")),
    Key([mod, "shift"], "Return", lazy.spawn("geany")),
    Key([mod], "v", lazy.spawn("zenity --calendar")),
]

groups = [
    Group("1", matches=[Match(wm_class="firefox")]),
    Group("2", matches=[Match(wm_class="xterm", title="ranger")]),
    Group("3", matches=[Match(wm_class="Quodlibet"),
                        Match(wm_class="audacity")]),
    Group("4", matches=[Match(wm_class="mpv")]),
    Group("5", matches=[Match(wm_class="geany")]),
    Group("6", matches=[Match(wm_class="XTerm")]),
    Group("7", matches=[Match(wm_class="gimp")]),
    Group("8", matches=[Match(wm_class="picard")]),
    Group("9", matches=[Match(wm_class="Steam")]),
]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(toggle=True),
            desc="Switch to group {}".format(i.name),
        ),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name),
        ),
    ]
)

layouts = [
    layout.Columns(
        name="col",
        insert_position=1,
        border_focus="#4B7093",
        border_focus_stack="#FFA500",
        border_normal="#23252e",
        border_width=3,
    ),
    # layout.Max(),
    # layout.Stack(),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(
        name="tab",
        panel_width=200,
        font="Noto Sans",
        fontsize=12,
        section_fontsize=10,
        bg_color="#212132",
        active_bg="#2B6AA7",
        inactive_bg="#212132",
    ),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

screens = [
    Screen(
        wallpaper="~/Pictures/borda2.jpg",
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.CurrentLayout(
                    foreground="#F16E88",
                ),
                widget.GroupBox(
                    disable_drag="True",
                    highlight_method="line",
                    highlight_color="#2A2A44",
                    hide_unused="True",
                    invert_mouse_wheel="True",
                    this_current_screen_border="#F574E8",
                    margin=5,
                    padding=5,
                ),
                widget.WindowName(
                    foreground="#96C5F3",
                    max_chars=50,
                    padding=10,
                ),
                widget.Clock(
                    foreground="#FBC35B",
                    format=" %a %d   %H:%M:%S",
                ),
                widget.Spacer(
                ),
                widget.Volume(
                    foreground="#CDDC45",
                    fmt=" {}",
                    padding=5,
                ),
                widget.Memory(
                    foreground="#E183E1",
                    format="  {MemUsed: .0f}{mm}",
                    update_interval=3,
                    padding=10,
                ),
                widget.CPU(
                    foreground="#6CD7DC",
                    format=" {load_percent}%",
                    update_interval=3,
                    padding=10,
                ),
                widget.ThermalZone(
                    fgcolor_normal="#F86D85",
                    format=" {temp}°C",
                    high=80,
                    update_interval=5,
                    padding=10,
                ),
                widget.Battery(
                    background="#212134",
                    foreground="#88EE9A",
                    fmt=" {}",
                    #format="{percent:2.0%}",
                    padding=10,
                ),
                widget.Systray(
                ),
            ],
            30,
            background="#23252e",
        )
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="Steam"),
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    border_focus="#923868",
    border_width=3,
)

auto_fullscreen = True
focus_on_window_activation = "focus"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
wmname = "LG3D"
