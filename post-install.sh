sudo pacman -Syu --noconfirm --needed gum base-devel git

# Find the first non-root user with sudo privileges
build_user=$(grep -m1 "sudo\|wheel" /etc/group | cut -d: -f4 | cut -d, -f1)

# If no sudo user found, use the current non-root user
if [ -z "$build_user" ] || [ "$build_user" = "root" ]; then
  build_user=$(ls /home | head -n1)
fi

echo "Using build user: $build_user"

cd /tmp
rm -rf /tmp/paru
git clone https://aur.archlinux.org/paru.git
chown -R $build_user:$build_user /tmp/paru

# makepkg won't let me build with `sudo`, so now this is a thing
sudo -u $build_user bash -c "cd /tmp/paru && makepkg -si --noconfirm"

echo "Select packages to install:"
packages=(
  "hyprland" "xdg-desktop-portal-hyprland"
  "hyprpolkitagent" "hyprlock" "hyprshot-git"
  "hyprsunset" "hyprcursor" "hyprsysteminfo"
  "zsh" "nano" "vi" "vim" "lf" "tmux"
  "dunst" "fuzzel"
  "lazygit" "arttime-git" "nvm"
  "nautilus" "pavucontrol" "vlc"
  "chromium" "obsidian"
  "telegram-desktop" "vesktop"
  "visual-studio-code-bin" "zed"
  "krita" "steam"
  "obs-studio" "audacity"
)

selected=($(gum choose --no-limit "${packages[@]}"))

echo "Selected packages: ${selected[@]}"

echo "Installing..."
if [ -n "$selected" ]; then
  paru -Syu --noconfirm $selected

    if [[ " ${selected[*]} " =~ " zsh " ]]; then
    echo "Setting up ZSH..."

    if gum confirm "Set ZSH as default shell?"; then
      chsh -s $(which zsh)
      echo "ZSH set as default shell. Changes will apply on next login."
    fi
  fi
fi
