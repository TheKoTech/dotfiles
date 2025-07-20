#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BKP_DIR="$SCRIPT_DIR/bkp"

link() {
  mkdir -p "$HOME/$1"

  if [ -L "$HOME/$1$2" ]; then
    ln -sf "$SCRIPT_DIR/$1$2" "$HOME/$1$2" && gum style --foreground 2 "~/$1$2  - linked"
    return
  fi

  if [ -f "$HOME/$1$2" ]; then
    if gum confirm "File $(gum style --foreground 214 --bold "~/$1$2") exists. Replace?"; then
      ln -sb "$SCRIPT_DIR/$1$2" "$HOME/$1$2"
      gum style --foreground 2 "~/$1$2 - linked"

      if [ ! -d $BKP_DIR ]; then
        mkdir $BKP_DIR
      fi

      SUBDIR=$BKP_DIR/$1
      if [ ! -d $SUBDIR ]; then
        mkdir -p "$SUBDIR"
      fi

      mv -b "$HOME/$1$2~" "$BKP_DIR/$1$2"
      gum style --foreground 5 "Backup saved to $BKP_DIR/$1$2"
    else
      gum style --foreground 3 "~/$1$2 - skipped"
    fi

    return
  fi

  ln -s "$SCRIPT_DIR/$1$2" "$HOME/$1$2" && gum style --foreground 2 "~/$1$2 - linked"
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
link ".config/hypr/" "keybinds.conf"

link ".config/kitty/" "kitty.conf"
link ".config/kitty/" "kitty-logo.png"

link ".config/lazygit/" "config.yml"

link ".config/lf/" "colors"
link ".config/lf/" "icons"
link ".config/lf/" "lfrc"


link ".config/waybar/" "config.jsonc"
link ".config/waybar/" "style.css"

link ".config/zed/snippets/" "typescript.json"
link ".config/zed/" "keymap.json"
link ".config/zed/" "settings.json"

link ".config/" "kritadisplayrc"
link ".config/" "kritadisrc"
link ".config/" "kritadisshortcutsrc"

if gum confirm "Link fifine mic pipewire output?"; then
  link ".config/pipewire/pipewire.conf.d/" "fifine-processed-output.conf"
fi

