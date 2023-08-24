/* user and group to drop privileges to */
static const char *user  = "sergey";
static const char *group = "wheel";

static const char *colorname[NUMCOLS] = {
    [INIT] =   "#23252e",   /* after initialization */
    [INPUT] =  "#2b4051",  /* during input */
    [FAILED] = "#763030", /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
