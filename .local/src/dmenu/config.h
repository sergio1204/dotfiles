/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar          = 1;                       /* -b  option; if 0, dmenu appears at bottom */
static const char *fonts[] = { "Terminus:size=10" }; /* -fn option overrides fonts[0] */
static const char *prompt  = NULL;                  /* -p  option; prompt to the left of input field */

/* Colors =================================*/
static const char *colors[SchemeLast][2] = {
    /*               fg         bg       */
    [SchemeNorm] = { "#bbbbbb", "#282C34" },
    [SchemeSel]  = { "#eeeeee", "#325081" },
    [SchemeOut]  = { "#000000", "#00ffff" },
};

/* Position / width / lines / border =================================*/
static int dmx                   = 0;   /* put dmenu at this x offset */
static int dmy                   = 20;  /* put dmenu at this y offset */
static unsigned int dmw          = 200; /* make dmenu this wide */
static unsigned int lines        = 15;  /* vertical list, if nonzero */
static unsigned int border_width = 3;   /* Size of the window border */

/* Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"*/
 
static const char worddelimiters[] = " ";
