export QT_QPA_PLATFORMTHEME=qt5ct

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi
