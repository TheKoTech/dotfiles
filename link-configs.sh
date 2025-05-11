#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BKP_DIR="$SCRIPT_DIR/bkp"

link() {
  if [ -L "$HOME/$1$2" ]; then
    echo "Already linked: ~/$1$2"
    return
  fi

  if [ -f "$HOME/$1$2" ]; then
    read -p "File ~/$1$2 exists. Replace? (Y/n)" REPLACE

    if [[ $REPLACE = "y" || $REPLACE = "Y" || $REPLACE = "" ]]; then
      ln -sb "$SCRIPT_DIR/$1$2" "$HOME/$1$2" && echo "Linked ~/$1$2"

      if [ ! -d $BKP_DIR ]; then
        mkdir $BKP_DIR
      fi

      SUBDIR=$BKP_DIR/$1
      if [ ! -d $SUBDIR ]; then
        mkdir -p "$SUBDIR"
      fi

      mv -b "$HOME/$1$2~" "$BKP_DIR/$1$2"
    fi

    return
  fi

  ln -s "$SCRIPT_DIR/$1$2" "$HOME/$1$2" && echo "Linked ~/$1$2"
}

link "" ".zshrc"
link "" ".tmux.conf"

link ".config/clipse/" "config.json"
link ".config/clipse/" "custom_theme.json"

link ".config/dunst/" "dunstrc"

link ".config/fastfetch/" "config.jsonc"
link ".config/fastfetch/" "arch.txt"

link ".config/fuzzel/" "fuzzel.ini"

link ".config/hypr/" "hyprland.conf"
link ".config/hypr/" "hyprlock.conf"
link ".config/hypr/" "hyprpaper.conf"
link ".config/hypr/" "hyprshot.conf"

link ".config/kitty/" "kitty.conf"
link ".config/kitty/" "kitty-logo.png"

link ".config/lf/" "colors"
link ".config/lf/" "icons"
link ".config/lf/" "lfrc"

link ".config/waybar/" "config.jsonc"
link ".config/waybar/" "style.css"
