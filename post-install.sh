sudo pacman -Syu --noconfirm --needed gum base-devel git

if ! command -v paru &>/dev/null; then
  if gum confirm "Install paru?"; then
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
  fi
else
  echo "Paru is already installed"
fi

# Initialize empty array for selected packages
selected=()

# Define package groups as a structure
# First element of each subarray is the group title
declare -A package_groups
package_groups=(
  ["A) Hyprland Required"]="hyprland xdg-desktop-portal-hyprland hyprpolkitagent"
  ["B) Hyprland Optional"]="hyprlock hyprshot-git hyprsunset hyprcursor hyprsysteminfo"
  ["C) Terminal Tools"]="zsh nano vi vim lf tmux"
  ["D) Basic Applications"]="kitty dunst fuzzel waybar bemoji"
  ["E) Fonts"]="ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-font-awesome"
  ["F) Terminal Utilities"]="lazygit arttime-git nvm"
  ["G) System Utilities"]="nautilus pavucontrol vlc"
  ["H) Applications"]="chromium obsidian syncthing telegram-desktop vesktop"
  ["I) Development"]="visual-studio-code-bin zed"
  ["J) Creativity"]="krita obs-studio audacity"
  ["K) Gaming"]="steam proton-ge-custom-bin protontricks"
  ["L) Communication"]="zoom"
)

# Iterate through package groups
for group_name in "${!package_groups[@]}"; do
  echo "Select packages from: $group_name"
  # Convert space-separated string to array
  read -ra packages <<<"${package_groups[$group_name]}"

  # Select packages from this group
  chosen=($(gum choose --no-limit "${packages[@]}"))

  # Add chosen packages to selected list
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
  paru -Syu --noconfirm "${selected[@]}"

  if [[ " ${selected[*]} " =~ " zsh " ]]; then
    echo "Setting up ZSH..."

    if gum confirm "Set ZSH as default shell?"; then
      chsh -s $(which zsh)
      echo "ZSH set as default shell. Changes will apply on next login."
    fi
  fi
else
  echo "No packages were selected for installation."
fi
