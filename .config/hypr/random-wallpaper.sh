#!/bin/bash
# if [ -z "$MY_CURRENT_WALLPAPER" ]; then
  # export MY_CURRENT_WALLPAPER=$(find ~/Wallpapers -type f | shuf -n 1)
  # hyprctl hyprpaper preload $MY_CURRENT_WALLPAPER
# fi

# handle() {
#   case $1 in
#     monitoradded*)
#       hyprctl hyprpaper wallpaper $1,$MY_CURRENT_WALLPAPER
#       ;;
#   esac
# }

# socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done

handle() {
  case $1 in
    monitoradded*)
      if [ -z "$MY_CURRENT_WALLPAPER" ]; then
        export MY_CURRENT_WALLPAPER=$(find ~/Wallpapers -type f | shuf -n 1)
        hyprctl hyprpaper preload $MY_CURRENT_WALLPAPER
      fi

      hyprctl hyprpaper wallpaper $1,$MY_CURRENT_WALLPAPER
      ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done