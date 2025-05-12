#!/bin/bash

# Debug mode flag - set to true to enable debug mode
DEBUG_MODE=true

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

group_order=(
  "A) Hyprland Required"
  "B) Hyprland Optional"
  "C) Terminal Tools"
  "D) Basic Applications"
  "E) Fonts"
  "F) System Utilities"
  "G) Applications"
  "H) Development"
  "I) Creativity"
  "J) Gaming"
  "K) Communication"
)

declare -A package_groups
package_groups=(
  ["A) Hyprland Required"]="hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gnome hyprpolkitagent wireplumber"
  ["B) Hyprland Optional"]="hyprlock hyprshot-git hyprsunset hyprcursor hyprsysteminfo grimblast-git clipse"
  ["C) Terminal Tools"]="zsh nano vi vim lf tmux fzf arttime-git man"
  ["D) Basic Applications"]="kitty dunst fuzzel waybar bemoji gnome-calendar"
  ["E) Fonts"]="ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-font-awesome"
  ["F) System Utilities"]="nautilus pavucontrol vlc"
  ["G) Applications"]="chromium obsidian syncthing"
  ["H) Development"]="visual-studio-code-bin zed lazygit nvm postman-bin"
  ["I) Creativity"]="krita obs-studio audacity"
  ["J) Gaming"]="steam proton-ge-custom-bin protontricks"
  ["K) Communication"]="telegram-desktop vesktop zoom"
)

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
    echo "Setting up ZSH..."

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
else
  echo "No packages were selected for installation."
fi
