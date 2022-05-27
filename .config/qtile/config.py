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
    # Switch focus between windows and groups
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.screen.next_group(skip_empty=True), desc="Move to the group on the right"),
    Key([mod, "shift"], "Tab", lazy.screen.toggle_group(), desc="Move to the last visited group"),
    # Move windows between left/right columns or move up/down in current stack.
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow / Shrink / Normalize / Maximize
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "b", lazy.layout.maximize()),
    # Split / Floating / Fullscreen
    Key([mod], "a", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "e", lazy.window.toggle_floating(), desc="Put the focused window to/from floating mode"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Put the focused window to/from fullscreen mode"),
    # Next layout / Kill / Reload / Spawncmd
    Key([mod], "w", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "z", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Volume control
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle")),
    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 10%-")),
    # Lockscreen
    Key([mod], "l", lazy.spawn("i3lock -i /home/sergey/Pictures/soty.png")),
    # Reboot / Poweroff / Logout
    Key([mod, "shift"], "k", lazy.spawn("systemctl reboot")),
    Key([mod, "shift"], "m", lazy.spawn("systemctl poweroff")),
    Key([mod, "shift"], "l", lazy.shutdown(), desc="Shutdown Qtile"),
    # Dunst
    Key([mod], "u", lazy.spawn("dunstctl history-pop")),
    Key([mod, "shift"], "u", lazy.spawn("dunstctl close-all")),
    # Picom
    Key([mod], "p", lazy.spawn("picom &")),
    Key([mod, "shift"], "p", lazy.spawn("killall picom")),
    # Apps keys
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
    Group("1", label="web", matches=[Match(wm_class="firefox")]),
    Group("2", label="file", matches=[Match(wm_class="xterm", title="ranger")]),
    Group("3", label="mus", matches=[Match(wm_class="Quodlibet"), Match(wm_class="audacity")]),
    Group("4", label="vid", matches=[Match(wm_class="mpv")]),
    Group("5", label="edit", matches=[Match(wm_class="geany")]),
    Group("6", label="term", matches=[Match(wm_class="XTerm")]),
    Group("7", label="gimp", matches=[Match(wm_class="gimp")]),
    Group("8", label="pic", matches=[Match(wm_class="picard")]),
    Group("9", label="game", matches=[Match(wm_class="Steam")]),
]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(toggle=True), desc="Switch to group {}".format(i.name)),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc="Switch to & move focused window to group {}".format(i.name)),
    ]
)

layouts = [
    layout.Columns(name="col", insert_position=1, border_focus="#2B6AA7", border_focus_stack="#FFA500", border_normal="#212134", border_width=5),
    # layout.Max(name="max"),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(name="tall", font="JetBrains Mono", border_focus="#2B6AA7", border_normal="#212134", border_width=5),
    # layout.MonadWide(name="wide", font="JetBrains Mono", border_focus="#2B6AA7", border_normal="#212134", border_width=5),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(name="tab", font="JetBrains Mono", section_fontsize=10, bg_color="#212134", active_bg="#2B6AA7", inactive_bg="#212134"),
    # layout.VerticalTile(name="vert", border_focus="#2B6AA7", border_normal="#212134", border_width=5),
    # layout.Zoomy(),
]

widget_defaults = dict(font="JetBrains Mono", fontsize=14, padding=3)

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="~/Pictures/gory.jpg",
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.CurrentLayout(foreground="#F16E88"),
                widget.GroupBox(active="#AAEFAA", disable_drag="True", invert_mouse_wheel="True", this_current_screen_border="#DB7B38"),
                widget.Prompt(foreground="#F16E88", cursor_color="#FFA500", padding=5),
                widget.WindowName(foreground="#96C5F3", padding=5),
                widget.TextBox(text="   ", foreground="#FCBF50"),
                widget.Volume(background="#212134", foreground="#FCBF50", padding=5),
                widget.Memory(foreground="#E183E1", format="  {MemUsed: .0f}{mm}", padding=5),
                widget.CPU(foreground="#6CD7DC", format="   {load_percent}%", padding=5),
                widget.TextBox(foreground="#F86D85", text="   "),
                widget.ThermalSensor(background="#212134", foreground="F86D85", update_interval=5, padding=5),
                widget.Clock(foreground="#95C2EE", format="   %a %d", padding=5),
                widget.Clock(foreground="#FBC35B", format="  %H:%M:%S", padding=5),
                widget.TextBox(text="  ", background="#212134", foreground="#88EE9A"),
                widget.Battery(background="#212134", foreground="#88EE9A", format="{percent:2.0%}", padding=5),
                widget.Systray(),
            ],
            24, background="#212134",
        )
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
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
    border_focus="#923868", border_width=5,
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
wmname = "Qtile"
