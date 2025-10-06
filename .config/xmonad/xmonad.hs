import Control.Monad (liftM2)
import Data.Conduit.Process (system)
import System.Exit
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Magnifier (MagnifyMsg (Toggle))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.StackSet qualified as W
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.EZConfig
import XMonad.Util.Hacks qualified as Hacks
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    . withEasySB (statusBarProp myXmobar (clickablePP =<< copiesPP (xmobarColor "#AAC9F1" "") myXmobarPP)) defToggleStrutsKey
    $ myConfig
  where
    myXmobar = "xmobar $HOME/.config/xmobar/xmobarrc"

myConfig =
  def
    { modMask = myModMask,
      terminal = myTerminal,
      layoutHook = myLayout,
      workspaces = myWorkspaces,
      manageHook = myManageHook,
      startupHook = myStartupHook,
      handleEventHook = handleEventHook def <> Hacks.trayerPaddingXmobarEventHook,
      borderWidth = myBorderWidth,
      focusedBorderColor = myFocusedBorderColor,
      normalBorderColor = myNormalBorderColor
    }
    `additionalKeysP`
    -- Rofi / Dunst
    [ ("M-z", spawn "rofi -show drun"),
      ("M-S-z", spawn "rofi -show run"),
      ("M-i", spawn "dunstctl history-pop"),
      ("M-S-i", spawn "dunstctl close-all"),
      -- Apps
      ("M-c", spawn (myBrowser ++ " --class='web' ")),
      ("M-S-c", spawn (myBrowser2 ++ " --class='web' ")),
      ("M-d", spawn "audacious"),
      ("M-S-d", spawn "audacious --play-pause"),
      ("M-p", spawn "picom"),
      ("M-S-p", spawn "killall -q picom"),
      ("M-u", spawn "udiskie --tray"),
      -- Terminal / FM / Editor / Calendar
      ("M-<Return>", spawn (myTerminal ++ " --class terminal ")),
      ("M-x", spawn (myTerminal ++ " --class files " ++ myFileManager)),
      ("M-\\", spawn (myTerminal ++ " --class editor " ++ myEditor)),
      ("M-S-x", spawn (myTerminal ++ " --class files " ++ myFileManager2)),
      ("M-S-\\", spawn (myTerminal ++ " --class editor " ++ myEditor2)),
      ("M-v", spawn (myTerminal ++ " --class calendar " ++ myCalendar)),
      -- Change layout / Unfloating / Hide bar behind window
      ("M-w", sendMessage $ JumpToLayout "\xf065"),
      ("M-S-w", sendMessage FirstLayout),
      ("M-s", sendMessage $ JumpToLayout "\xf063"),
      ("M-S-s", sendMessage FirstLayout),
      ("M-e", withFocused $ windows . W.sink),
      ("M-f", sendMessage ToggleStruts),
      -- Lockscreen / Printscreen
      ("M-l", spawn "i3lock -k -i /home/sergey/Pictures/soty.png"),
      ("<Print>", spawn "scrot -s"),
      ("S-<Print>", spawn "scrot -d 1"),
      -- Volume control
      ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
      ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
      ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),
      ("M-<XF86AudioRaiseVolume>", spawn "audacious --fwd"),
      ("M-<XF86AudioLowerVolume>", spawn "audacious --rew"),
      -- Brightness control
      ("<XF86MonBrightnessUp>", spawn "brightnessctl s +10%"),
      ("<XF86MonBrightnessDown>", spawn "brightnessctl s 10%-"),
      -- Recompile / Reboot / Poweroff / Suspend / Quit
      ("M-S-r", spawn "xmonad --recompile && xmonad --restart"),
      ("M-S-k", spawn "systemctl reboot"),
      ("M-S-m", spawn "systemctl poweroff"),
      ("M-S-j", spawn "systemctl suspend"),
      ("M-S-l", io exitSuccess),
      -- Resize window
      ("M-C-<Left>", sendMessage Shrink),
      ("M-C-<Right>", sendMessage Expand),
      ("M-C-<Down>", sendMessage MirrorShrink),
      ("M-C-<Up>", sendMessage MirrorExpand),
      -- Swap window / Kill window
      ("M-<Space>", windows W.swapMaster),
      ("M-g", windows W.swapDown),
      ("M-S-g", windows W.swapUp),
      ("M-S-<Left>", windows W.swapUp),
      ("M-S-<Right>", windows W.swapDown),
      ("M-q", kill1),
      ("M-S-q", kill),
      -- Focus window
      ("M-a", windows W.focusDown),
      ("M-S-a", windows W.focusUp),
      ("M-<Left>", windows W.focusUp),
      ("M-<Right>", windows W.focusDown),
      -- Cycle WS
      ("M-<Tab>", moveTo Next (Not emptyWS)),
      ("M-`", moveTo Prev (Not emptyWS)),
      ("M-<Esc>", toggleWS)
    ]
    -- Move window to WS and go to
    ++ [ ("M-S-" ++ k, windows $ W.greedyView w . W.shift w)
         | (w, k) <- zip myWorkspaces $ map show [1 .. 9]
       ]
    -- Copy window to WS and go to
    ++ [ ("M-C-" ++ show i, windows $ W.greedyView ws . copy ws)
         | (i, ws) <- zip [1 .. 9] myWorkspaces
       ]

myTerminal :: String
myTerminal = "kitty"

myBrowser :: String
myBrowser = "vivaldi-stable"

myFileManager :: String
myFileManager = "yazi"

myEditor :: String
myEditor = "helix"

myBrowser2 :: String
myBrowser2 = "firefox"

myFileManager2 :: String
myFileManager2 = "vifm"

myEditor2 :: String
myEditor2 = "nvim"

myCalendar :: String
myCalendar = "calcurse"

myModMask :: KeyMask
myModMask = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 3

myFocusedBorderColor :: String
myFocusedBorderColor = "#4B7093"

myNormalBorderColor :: String
myNormalBorderColor = "#23252e"

myWorkspaces :: [WorkspaceId]
myWorkspaces = map show [1 .. 9 :: Int]

myLayout = smartBorders (tall ||| wide ||| mono)
  where
    tall =
      renamed [Replace "\xf061"] $
        ResizableTall 1 (10 / 100) 0.4 []
    wide =
      renamed [Replace "\xf063"] $
        Mirror $
          Tall 1 (3 / 100) (1 / 2)
    mono =
      renamed [Replace "\xf065"] Full

myXmobarPP :: PP
myXmobarPP =
  def
    { ppSep = magenta " ",
      ppLayout = magenta . wrap " " " ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = blue . wrap "" "" . xmobarBorder "Bottom" "#AAC9F1" 3,
      ppHidden = orange . wrap "" "",
      ppUrgent = red . wrap (orange "!") (orange "!"),
      ppOrder = \[ws, l, _, wins] -> [ws, l, wins],
      ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused = wrap (blue "") (blue "") . blue . ppWindow
    formatUnfocused = wrap (orange "") (orange "") . orange . ppWindow

    -- Windows title length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 50

    magenta, blue, orange, red :: String -> String
    magenta = xmobarColor "#ff79c6" ""
    blue = xmobarColor "#AAC9F1" ""
    orange = xmobarColor "#eab268" ""
    red = xmobarColor "#ff5555" ""

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ className =? "web" --> viewShift "1",
      className =? "files" --> viewShift "2",
      className =? "Audacious" --> viewShift "3",
      className =? "terminal" --> viewShift "4",
      className =? "editor" --> viewShift "5",
      className =? "mpv" --> viewShift "6",
      className =? "Gimp" --> viewShift "7",
      className =? "Telegram" --> viewShift "8",
      className =? "Steam" --> viewShift "9",
      -- Floating
      className =? "Blueman-manager" --> doFloat,
      className =? "Steam" --> doFloat,
      className =? "XCalc" --> doFloat,
      className =? "calendar" --> doFloat,
      className =? "feh" --> doFloat
    ]
  where
    viewShift = doF . liftM2 (.) W.greedyView W.shift

myStartupHook :: X ()
myStartupHook = do
  spawn "killall -q trayer"
  spawn
    "sleep 2 && trayer --edge top --align right --SetDockType true \
    \--SetPartialStrut true --expand true --widthtype request \
    \--transparent false --tint 0x5f5f5f --height 28"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "picom -b"
  spawnOnce "xset b off"
  spawnOnce "feh --bg-scale /home/sergey/Pictures/wallpaper.jpg"
  spawnOnce "$HOME/.screenlayout/one_monitor.sh"
