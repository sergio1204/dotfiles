import XMonad
import XMonad.Actions.CycleWS
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab   -- NOTE: Only needed for versions < 0.18.0!
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Loggers
import XMonad.Util.ClickableWorkspaces

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import Control.Monad (liftM2)
import System.Exit

import qualified XMonad.StackSet as W
import qualified XMonad.Util.Hacks as Hacks

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp myXmobar (clickablePP myXmobarPP)) defToggleStrutsKey
     $ myConfig
  where myXmobar = "xmobar $HOME/.config/xmobar/xmobarrc"

myConfig = def
    { modMask            = myModMask
    , terminal           = myTerminal
    , layoutHook         = myLayout
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook
    , startupHook        = myStartupHook
    , handleEventHook    = handleEventHook def <> Hacks.trayerPaddingXmobarEventHook
    , borderWidth        = myBorderWidth
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor  = myNormalBorderColor
    }
    `additionalKeysP` myAdditionalKeysP
    `removeKeysP`     myRemoveKeysP

myAdditionalKeysP =
    -- Rofi / Dunst
    [ ("M-z", spawn "rofi -show drun")
    , ("M-S-z", spawn "rofi -show run")
    , ("M-u", spawn "dunstctl history-pop")
    , ("M-S-u", spawn "dunstctl close-all")

    -- Apps
    , ("M-c", spawn "firefox")
    , ("M-d", spawn "youtube-music")
    , ("M-p", spawn "picom")
    , ("M-S-p", spawn "killall -q picom")

    -- Terminal
    , ("M-<Return>", spawn (myTerminal ++ " --class terminal "))
    , ("M-x", spawn (myTerminal ++ " --class files -e vifm "))
    , ("M-\\", spawn (myTerminal ++ " --class editor -e vim "))
    , ("M-v", spawn (myTerminal ++ " --class calendar -e calcurse "))

    -- Next layout / Unfloating / kill
    , ("M-s", sendMessage NextLayout)
    , ("M-e", withFocused $ windows . W.sink)
    , ("M-q", kill)

    -- Lockscreen / Printscreen
    , ("M-l", spawn "i3lock -i /home/sergey/Pictures/soty.png")
    , ("<Print>", unGrab *> spawn "scrot -s")
    , ("S-<Print>", spawn "scrot -d 1")

    -- Volume control
    , ("<XF86AudioRaiseVolume>", spawn("amixer -D pulse sset Master 5%+"))
    , ("<XF86AudioLowerVolume>", spawn("amixer -D pulse sset Master 5%-"))
    , ("<XF86AudioMute>", spawn("amixer -D pulse set Master toggle"))

    -- Brightness control
    , ("<XF86MonBrightnessUp>", spawn("brightnessctl s +10%"))
    , ("<XF86MonBrightnessDown>", spawn("brightnessctl s 10%-"))

    -- Recompile / Reboot / Poweroff / Quit
    , ("M-S-r", spawn "xmonad --recompile && xmonad --restart")
    , ("M-S-k", spawn "systemctl reboot")
    , ("M-S-m", spawn "systemctl poweroff")
    , ("M-S-l", io exitSuccess)

    -- Resize window
    , ("M-C-<Left>", sendMessage Shrink)
    , ("M-C-<Right>", sendMessage Expand)
    , ("M-C-<Down>", sendMessage MirrorShrink)
    , ("M-C-<Up>", sendMessage MirrorExpand)

    -- Swap window
    , ("M-<Space>", windows W.swapMaster)
    , ("M-g", windows W.swapDown)
    , ("M-S-g", windows W.swapUp)
    , ("M-S-<Left>", windows W.swapUp)
    , ("M-S-<Right>", windows W.swapDown)

    -- Focus window
    , ("M-a", windows W.focusDown)
    , ("M-S-a", windows W.focusUp)
    , ("M-<Left>", windows W.focusUp)
    , ("M-<Right>", windows W.focusDown)

    -- Cycle WS
    , ("M-<Tab>", moveTo Next (Not emptyWS))
    , ("M-`", moveTo Prev (Not emptyWS))
    , ("M-<Esc>", toggleWS)
    ]

myRemoveKeysP =
    [ ("M-S-q")
    , ("M-S-c")
    ]

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "alacritty"

myBorderWidth :: Dimension
myBorderWidth = 3

myFocusedBorderColor :: String
myFocusedBorderColor = "#4B7093"

myNormalBorderColor :: String
myNormalBorderColor  = "#23252e"

myWorkspaces :: [WorkspaceId]
myWorkspaces = map show [1 .. 9 :: Int]

myLayout = tall ||| wide ||| mono
  where
    tall = renamed [Replace "\xf061"]
         $ smartBorders
         $ ResizableTall 1 (10/100) (0.4) []
    wide = renamed [Replace "\xf063"]
         $ Mirror
         $ Tall 1 (3/100) (1/2)
    mono = renamed [Replace "\xf065"]
         $ Full

myXmobarPP :: PP
myXmobarPP = def
    { ppSep           = magenta "  "
    , ppLayout        = magenta . wrap "" ""
    , ppTitleSanitize = xmobarStrip
    , ppCurrent       = blue . wrap "" "" . xmobarBorder "Bottom" "#AAC9F1" 3
    , ppHidden        = yellow . wrap "" ""
    , ppUrgent        = red . wrap (yellow "!") (yellow "!")
    , ppOrder         = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras        = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (blue  "") (blue  "") . blue . ppWindow
    formatUnfocused = wrap (green "") (green "") . yellow . ppWindow

    -- Windows title length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, green, magenta, red, white, yellow :: String -> String
    magenta = xmobarColor "#ff79c6" ""
    blue    = xmobarColor "#AAC9F1" ""
    white   = xmobarColor "#f8f8f2" ""
    yellow  = xmobarColor "#eab268" ""
    red     = xmobarColor "#ff5555" ""
    green   = xmobarColor "#88EE9A" ""

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "firefox-esr"     --> viewShift "1"
    , className =? "files"           --> viewShift "2"
    , className =? "YouTube Music"   --> viewShift "3"
    , className =? "terminal"        --> viewShift "4"
    , className =? "editor"          --> viewShift "5"
    , className =? "mpv"             --> viewShift "6"
    , className =? "gimp-2.10"       --> viewShift "7"
    , className =? "Steam"           --> viewShift "9"
    -- Floating
    , className =? "Blueman-manager" --> doFloat
    , className =? "Steam"           --> doFloat
    , className =? "XCalc"           --> doFloat
    , className =? "calendar"        --> doFloat
    ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift

myStartupHook :: X ()
myStartupHook = do
    spawn "killall -q trayer"
    spawn "sleep 2 && trayer --edge top --align right --SetDockType true \
          \--SetPartialStrut true --expand true --widthtype request \
          \--transparent false --tint 0x5f5f5f --height 28"
    spawnOnce "xsetroot -cursor_name left_ptr"
    spawnOnce "picom -b"
    spawnOnce "xset b off"
    spawnOnce "feh --bg-scale /home/sergey/Pictures/kosmonavt.jpg"

