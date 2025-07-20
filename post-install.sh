#!/bin/bash

# Debug mode flag - set to true to enable debug mode
DEBUG_MODE=false

# Function to run or log commands based on debug mode
run_command() {
  if [ "$DEBUG_MODE" = true ]; then
    echo "[DEBUG] Would execute: $@"
    return 0
  else
    eval "$@"
    return $?
  fi
}

# Show debug mode status at start
if [ "$DEBUG_MODE" = true ]; then
  echo "[DEBUG] Commands will be logged but not executed"
fi

echo "Enabling multilib..."
run_command "sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf"

echo "Installing prerequisites..."
run_command "sudo pacman -Syu --noconfirm --needed gum base-devel git"

if ! command -v paru &>/dev/null; then
  if gum confirm "Install paru?"; then
    run_command "cd /tmp"
    run_command "git clone https://aur.archlinux.org/paru.git"
    run_command "cd paru"
    run_command "makepkg -si --noconfirm"
  fi
else
  echo "Paru is already installed"
fi

selected=()

declare -A package_groups

push() {
  local group_name="$1"
  shift
  group_order+=("$group_name")
  package_groups["$group_name"]="$*"
}

group_order=()

push "A) Hyprland Required" hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gnome hyprpolkitagent wireplumber
push "B) Hyprland Optional" hyprlock hyprshot-git hyprsunset hyprcursor hyprsysteminfo grimblast-git clipse hyprpicker
push "C) AMD" rocm-smi-libs
push "D) Display Manager" sddm sddm-kcm qt5-declarative
push "E) Terminal Tools" zsh nano vi vim btop lf tmux fzf arttime-git man vnstat
push "F) Basic Applications" kitty dunst fuzzel waybar bemoji gnome-calendar
push "G) Fonts" ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-font-awesome
push "H) Audio" noise-suppression-for-voice ladspa rnnoise lsp-plugins
push "I) System Utilities" nautilus pavucontrol vlc network-manager-applet
push "J) Applications" chromium obsidian syncthing
push "K) Development" visual-studio-code-bin zed lazygit diff-so-fancy nvm postman-bin nginx
push "L) Creativity" krita obs-studio audacity opentabletdriver
push "M) Gaming" steam proton-ge-custom-bin protontricks
push "N) Communication" telegram-desktop vesktop zoom

for group_name in "${group_order[@]}"; do
  echo "Select packages from: $group_name"
  read -ra packages <<<"${package_groups[$group_name]}"

  chosen=($(gum choose --no-limit "${packages[@]}"))

  if [ ${#chosen[@]} -gt 0 ]; then
    selected+=("${chosen[@]}")
    echo "✓ Selected ${#chosen[@]} packages from $group_name"
  else
    echo "✗ No packages selected from $group_name"
  fi
  echo
done

echo "All selected packages: ${selected[@]}"

echo "Installing..."
if [ ${#selected[@]} -gt 0 ]; then
  run_command "paru -Syu --noconfirm ${selected[*]}"

  if [[ " ${selected[*]} " =~ " zsh " ]]; then
    if gum confirm "Set ZSH as default shell?"; then
      run_command "chsh -s $(which zsh)"
      echo "ZSH set as default shell. Changes will apply on next login."
    fi
  fi

  if [[ " ${selected[*]} " =~ " nvm " ]]; then
    if gum confirm "Install latest node version?"; then
      run_command "nvm install --lts"
    fi
  fi

  if [[ " ${selected[*]} " =~ " syncthing " ]]; then
    if gum confirm "Autostart syncthing?"; then
      run_command "systemctl --user enable syncthing"
      run_command "systemctl --user start syncthing"
    fi
  fi

  if [[ " ${selected[*]} " =~ " hyprpolkitagent " ]]; then
    if gum confirm "Autostart hyprpolkitagent?"; then
      run_command "systemctl --user enable hyprpolkitagent.service"
      run_command "systemctl --user start hyprpolkitagent.service"
    fi
  fi
else
  echo "No packages were selected for installation."
fi

if gum confirm "Enable dark mode?"; then
  run_command "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\""
fi

if gum confirm "Link configs?"; then
  run_command "./link-configs.sh"
fi

if gum confirm "Generate autostart?"; then
  run_command "./link-configs.sh"
fi

if gum confirm "Apply generic monitor configuration?"; then
  local MONITORS=".config/hypr/monitors.conf"
  cp -f "$SCRIPT_DIR/$MONITORS" "$HOME/$MONITORS"
fi
