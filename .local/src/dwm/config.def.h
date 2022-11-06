/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance --------------------------------------------------------------*/
static const unsigned int borderpx       = 3;   /* border pixel of windows */
static const unsigned int snap           = 32;  /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor */
static const int showsystray             = 1;   /* 0 means no systray */
static const int showbar                 = 1;   /* 0 means no bar */
static const int topbar                  = 1;   /* 0 means bottom bar */
static const char *fonts[]         = { "JetBrains Mono:size=10" };
static const char colour1[]        = "#23252e";
static const char colour2[]        = "#81C1FF";
static const char colour3[]        = "#bbbbbb";
static const char colour4[]        = "#eeeeee";
static const char colour5[]        = "#325081";
static const char *colors[][3]     = {
	/*               fg         bg     border   */
	[SchemeNorm] = { colour3, colour1, colour1  },
	[SchemeSel]  = { colour2, colour1, colour5  },
};

/* tagging -----------------------------------------------------------------------*/
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class       instance    title       tags mask   switchtotag   isfloating   monitor */
	{ "firefox",   NULL,       NULL,       1 << 0,     1,            0,           -1 },
	{ "st",        NULL,       "ranger",   1 << 1,     1,            0,           -1 },
	{ "Quodlibet", NULL,       NULL,       1 << 2,     1,            0,           -1 },
	{ "Audacity",  NULL,       NULL,       1 << 2,     1,            0,           -1 },
	{ "mpv",       NULL,       NULL,       1 << 3,     1,            0,           -1 },
	{ "Geany",     NULL,       NULL,       1 << 4,     1,            0,           -1 },
	{ "Gvim",      NULL,       NULL,       1 << 4,     1,            0,           -1 },
	{ "st",        NULL,       "st",       1 << 5,     1,            0,           -1 },
	{ "Gimp",      NULL,       NULL,       1 << 6,     1,            0,           -1 },
	{ "Picard",    NULL,       NULL,       1 << 7,     1,            0,           -1 },
	{ "Steam",     NULL,       NULL,       1 << 8,     0,            1,           -1 },
	{ "feh",       NULL,       NULL,       0,          0,            1,           -1 },
	{ "XCalc",     NULL,       NULL,       0,          0,            1,           -1 },
};

/* layout(s) -------------------------------------------------------------------------*/
static const float mfact        = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;   /* number of clients in master area */
static const int resizehints    = 0;  /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "=[]",      tile },    /* first entry is default */
	{ "><>",      NULL },   /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions ------------------------------------------------------------------*/
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
/* apps hotkeys ---------------------------------------------------------------------*/
static const char *dmenucmd[]       = { "dmenu_run", NULL };
static const char *termcmd[]        = { "st", NULL };
static const char *firefoxcmd[]     = { "firefox", NULL };
static const char *rangercmd[]      = { "st", "-e", "ranger", NULL };
static const char *pcmanfmqtcmd[]   = { "pcmanfm-qt", NULL };
static const char *quodlibetcmd[]   = { "quodlibet", NULL };
static const char *quodlibetppcmd[] = { "quodlibet", "--play-pause", NULL };
static const char *geanycmd[]       = { "geany", NULL };
static const char *gvimcmd[]         = { "gvim", NULL };
static const char *zenitycalcmd[]   = { "zenity", "--calendar", NULL };
static const char *dunsthistcmd[]   = { "dunstctl", "history-pop", NULL };
static const char *dunstclosecmd[]  = { "dunstctl", "close-all", NULL };
/* volume control ----------------------------------------------------------------------------------*/
static const char *volupcmd[]       = { "amixer", "-D", "pulse", "sset", "Master", "5%+", NULL };
static const char *voldowncmd[]     = { "amixer", "-D", "pulse", "sset", "Master", "5%-", NULL };
static const char *volmutecmd[]     = { "amixer", "-D", "pulse", "sset", "Master", "toggle", NULL };
/* brightness --------------------------------------------------------------------------------------*/
static const char *brightupcmd[]    = { "brightnessctl", "s", "+10%", NULL };
static const char *brightdowncmd[]  = { "brightnessctl", "s", "10%-", NULL };
/* printscreen / lockscreen --------------------------------------------------*/
static const char *printscrselcmd[] = { "scrot", "-s", NULL };
static const char *printscrallcmd[] = { "scrot", "-d", "1", NULL };
static const char *screenlockcmd[]  = { "slock", NULL };
/* reboot / poweroff / quit --------------------------------------------------*/
static const char *rebootcmd[]      = { "systemctl", "reboot", NULL };
static const char *poweroffcmd[]    = { "systemctl", "poweroff", NULL };

static const Key keys[] = {
	/* modifier                     key              function          argument */
	/* apps hotkeys ----------------------------------------------------------------------*/
	{ MODKEY,                       XK_z,            spawn,            {.v = dmenucmd } },
	{ MODKEY,                       XK_Return,       spawn,            {.v = termcmd } },
	{ MODKEY,                       XK_c,            spawn,            {.v = firefoxcmd } },
	{ MODKEY,                       XK_x,            spawn,            {.v = rangercmd } },
	{ MODKEY|ShiftMask,             XK_x,            spawn,            {.v = pcmanfmqtcmd } },
	{ MODKEY,                       XK_d,            spawn,            {.v = quodlibetcmd } },
	{ MODKEY|ShiftMask,             XK_d,            spawn,            {.v = quodlibetppcmd } },
	{ MODKEY|ShiftMask,             XK_Return,       spawn,            {.v = geanycmd } },
	{ MODKEY|ShiftMask,             XK_backslash,    spawn,            {.v = gvimcmd } },
	{ MODKEY,                       XK_v,            spawn,            {.v = zenitycalcmd } },
	{ MODKEY,                       XK_u,            spawn,            {.v = dunsthistcmd } },
	{ MODKEY|ShiftMask,             XK_u,            spawn,            {.v = dunstclosecmd } },
	/* volume control --------------------------------------------------------------------*/
	{ 0,              XF86XK_AudioRaiseVolume,       spawn,            {.v = volupcmd } },
	{ 0,              XF86XK_AudioLowerVolume,       spawn,            {.v = voldowncmd } },
	{ 0,                     XF86XK_AudioMute,       spawn,            {.v = volmutecmd } },
	/* brightness ------------------------------------------------------------------------*/
	{ 0,            XF86XK_MonBrightnessUp,          spawn,            {.v = brightupcmd } },
	{ 0,            XF86XK_MonBrightnessDown,        spawn,            {.v = brightdowncmd } },
	/* printscreen / lockscreen ----------------------------------------------------------*/
	{ 0,                            XK_Print,        spawn,            {.v = printscrselcmd } },
	{ ShiftMask,                    XK_Print,        spawn,            {.v = printscrallcmd } },
	{ MODKEY,                       XK_l,            spawn,            {.v = screenlockcmd } },
	/* reboot / poweroff / quit --------------        ------------------------------------------*/
	{ MODKEY|ShiftMask,             XK_k,            spawn,            {.v = rebootcmd } },
	{ MODKEY|ShiftMask,             XK_m,            spawn,            {.v = poweroffcmd } },
	{ MODKEY|ShiftMask,             XK_l,            quit,             {0} },
	/* other hotkeys -------------------------        --------------------------------------------*/
	{ MODKEY,                       XK_b,            togglebar,        {0} },
	{ MODKEY,                       XK_a,            focusstack,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_a,            focusstack,       {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_s,            incnmaster,       {.i = +1 } },
	{ MODKEY,                       XK_s,            incnmaster,       {.i = -1 } },
	{ MODKEY|ControlMask,           XK_Left,         setmfact,         {.f = +0.05} },
	{ MODKEY|ControlMask,           XK_Right,        setmfact,         {.f = -0.05} },
	{ MODKEY,                       XK_g,            zoom,             {0} },
	{ MODKEY|ShiftMask,             XK_Tab,          view,             {0} },
	{ MODKEY,                       XK_q,            killclient,       {0} },
	{ MODKEY,                       XK_t,            setlayout,        {.v = &layouts[0]} },
	{ MODKEY,                       XK_e,            setlayout,        {.v = &layouts[1]} },
	{ MODKEY,                       XK_w,            setlayout,        {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,        setlayout,        {0} },
	{ MODKEY|ShiftMask,             XK_space,        togglefloating,   {0} },
	{ MODKEY,                       XK_y,            view,             {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_y,            tag,              {.ui = ~0 } },
	{ MODKEY,                       XK_Tab,          shiftviewclients, { .i = +1 } },
	{ MODKEY,                       XK_grave,        shiftviewclients, { .i = -1 } },
	{ MODKEY,                       XK_comma,        focusmon,         {.i = -1 } },
	{ MODKEY,                       XK_period,       focusmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,        tagmon,           {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,       tagmon,           {.i = +1 } },
	TAGKEYS(                        XK_1,                              0)
	TAGKEYS(                        XK_2,                              1)
	TAGKEYS(                        XK_3,                              2)
	TAGKEYS(                        XK_4,                              3)
	TAGKEYS(                        XK_5,                              4)
	TAGKEYS(                        XK_6,                              5)
	TAGKEYS(                        XK_7,                              6)
	TAGKEYS(                        XK_8,                              7)
	TAGKEYS(                        XK_9,                              8)
	TAGKEYS(                        XK_0,                              9)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
