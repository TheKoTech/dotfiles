sudo pacman -Syu --noconfirm --needed gum base-devel git

cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

echo "Select packages to install:"
packages=(
  "hyprland" "xdg-desktop-portal-hyprland"
  "hyprpolkitagent" "hyprlock" "hyprshot-git"
  "hyprsunset" "hyprcursor" "hyprsysteminfo"
  "zsh" "nano" "vi" "vim" "lf" "tmux"
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
