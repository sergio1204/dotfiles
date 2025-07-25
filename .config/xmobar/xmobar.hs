import Xmobar

config :: Config
config =
  defaultConfig
    { font = "BlexMono Nerd Font 12",
      additionalFonts = [],
      overrideRedirect = True,
      textOffset = 0,
      iconOffset = 0,
      bgColor = "#23252e",
      fgColor = "#f8f8f2",
      position = TopSize L 100 28,
      commands =
        [ Run UnsafeXMonadLog,
          Run $
            Volume
              "default"
              "Master"
              [ "-t",
                "<action=`xdotool key XF86AudioRaiseVolume` button=4> \
                \<action=`xdotool key XF86AudioLowerVolume` button=5> \
                \<action=`xdotool key XF86AudioMute` button=1> \
                \<action=`pavucontrol` button=3> \
                \<status></action></action></action></action>",
                "--",
                "-O",
                "\61441  <volume>%",
                "-C",
                "#CDDC45",
                "-o",
                "\61942  <volume>%",
                "-c",
                "#ff3e72"
              ]
              05,
          Run $
            Memory
              [ "-t",
                "<fc=#E183E1>\61381  <usedratio>%</fc>"
              ]
              30,
          Run $
            Cpu
              [ "-t",
                "<fc=#6CD7DC>\62171  <total>%</fc>"
              ]
              30,
          Run $
            ThermalZone
              0
              [ "-t",
                "<fc=#F86D85>\62153 <temp>°C</fc>"
              ]
              30,
          Run $
            Battery
              [ "-t",
                "<fc=#88EE9A><acstatus><left>%</fc>",
                "--", -- battery specific options
                -- discharging status
                "-o",
                "\62016 ",
                -- AC "on" status
                "-O",
                "\61926 ",
                -- charged status
                "-i",
                "\61926 "
              ]
              300,
          Run $ Date "<fc=#f0b574>\61463  %H:%M:%S</fc>" "date" 10,
          Run $
            Kbd
              [ ("us", "<fc=#F57CB8>\61724  us</fc>"),
                ("ru", "<fc=#F57CB8>\61724  ru</fc>")
              ],
          Run $ XPropertyLog "_XMONAD_TRAYPAD"
        ],
      sepChar = "%",
      alignSep = "}{",
      template = " %UnsafeXMonadLog% }{ %default:Master%    %memory%    %cpu%    %thermal0%    %battery%    %date%    %kbd%  %_XMONAD_TRAYPAD%"
    }

main :: IO ()
main = xmobar config -- or: configFromArgs config >>= xmobar
