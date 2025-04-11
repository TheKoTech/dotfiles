sudo pacman -Syu --noconfirm --needed gum base-devel git

cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

echo "Select packages to install:"
packages=(
  # hyprland
  "hyprland" "xdg-desktop-portal-hyprland"
  "hyprpolkitagent" "hyprlock" "hyprshot-git"
  "hyprsunset" "hyprcursor" "hyprsysteminfo"

  # terminal stuff
  "zsh" "nano" "vi" "vim" "lf" "tmux"

  # basic apps
  "kitty" "dunst" "fuzzel" "waybar" "bemoji"

  # fonts
  "ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd"
  "ttf-font-awesome"

  # terminal-based apps that I don't need all the time
  "lazygit" "arttime-git" "nvm"

  # utility
  "nautilus" "pavucontrol" "vlc"

  # other
  "chromium" "obsidian" "syncthing"
  "telegram-desktop" "vesktop"
  "visual-studio-code-bin" "zed"
  "krita" "steam" "zoom"
  "obs-studio" "audacity"
)

selected=($(gum choose --no-limit "${packages[@]}"))

echo "Selected packages: ${selected[@]}"

echo "Installing..."
if [ -n "$selected" ]; then
  paru -Syu --noconfirm "${selected[@]}"

    if [[ " ${selected[*]} " =~ " zsh " ]]; then
    echo "Setting up ZSH..."

    if gum confirm "Set ZSH as default shell?"; then
      chsh -s $(which zsh)
      echo "ZSH set as default shell. Changes will apply on next login."
    fi
  fi
fi
