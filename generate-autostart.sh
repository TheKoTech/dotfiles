#!/bin/bash

# Debug mode flag - set to true to enable debug mode
DEBUG_MODE=false

# File paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
AUTOSTART_FILE="$HOME/.config/hypr/autostart.conf"
BACKUP_DIR="$SCRIPT_DIR/bkp"

# Arrays for managing application groups
declare -A app_groups
declare -a group_order
declare -a selected_apps

#################
### FUNCTIONS ###
#################

# executes commands or logs them based on debug mode
run_command() {
  if [ "$DEBUG_MODE" = true ]; then
    echo "[DEBUG] Would execute: $@"
    return 0
  else
    eval "$@"
    return $?
  fi
}

# adds application group with name and list of applications
# args: group_name, app1, app2, app3, ...
push_group() {
  local group_name="$1"
  shift
  group_order+=("$group_name")
  app_groups["$group_name"]="$*"
}

# prompts user to select applications from each group using gum
select_applications() {
  selected_apps=()

  for group_name in "${group_order[@]}"; do
    echo "Select applications from: $group_name"
    read -ra apps <<<"${app_groups[$group_name]}"

    chosen=($(gum choose --no-limit "${apps[@]}"))

    if [ ${#chosen[@]} -gt 0 ]; then
      selected_apps+=("${chosen[@]}")
      echo "✓ Selected ${#chosen[@]} applications from $group_name"
    else
      echo "✗ No applications selected from $group_name"
    fi
    echo
  done
}

# converts selected app names to proper exec-once statements
# handles special workspace assignments and flags
generate_exec_statements() {
  local output=""

  for group_name in "${group_order[@]}"; do
    output+="\n# $group_name\n"

    read -ra apps <<<"${app_groups[$group_name]}"

    for app in "${apps[@]}"; do
      local exec_line="exec-once = "

      # Handle special cases with workspace assignments
      case "$app" in
        "Telegram"|"Technogram"|"Discord")
          exec_line+="[workspace special:magic silent] $app"
          ;;
        "kitty-tmux")
          exec_line+="[workspace special:terminal silent] kitty -e tmux new-session -t main -s main-\$(date +%s)"
          ;;
        "tmux-session")
          exec_line+="tmux new-session -d -s main"
          ;;
        "dbus-screen-sharing")
          exec_line+="dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          ;;
        "clipse")
          exec_line+="clipse -listen"
          ;;
        "chromium")
          exec_line+="[workspace 1] chromium"
          ;;
        "steam")
          exec_line+="[workspace 6] steam"
          ;;
        *)
          exec_line+="$app"
          ;;
      esac

      # Check if app was selected
      if [[ " ${selected_apps[*]} " =~ " $app " ]]; then
        output+="$exec_line\n"
      else
        output+="# $exec_line\n"
      fi
    done

    output+="\n"
  done

  echo -e "$output"
}

# checks if selected applications are actually installed on system
validate_selected_apps() {
  local missing_apps=()

  for app in "${selected_apps[@]}"; do
    # Skip special cases that aren't actual commands
    case "$app" in
      "kitty-tmux"|"tmux-session"|"dbus-screen-sharing"|"chromium"|"steam")
        continue
        ;;
    esac

    # Check if command exists
    if ! command -v "$app" &>/dev/null; then
      missing_apps+=("$app")
    fi
  done

  if [ ${#missing_apps[@]} -gt 0 ]; then
    echo "⚠️  Warning: The following applications are not installed:"
    printf '   - %s\n' "${missing_apps[@]}"
    echo
    if ! gum confirm "Continue anyway?"; then
      exit 1
    fi
  fi
}

# creates backup of existing autostart.conf if it exists
backup_existing_config() {
  if [ -f "$AUTOSTART_FILE" ]; then
    if [ ! -d "$BACKUP_DIR" ]; then
      run_command "mkdir -p '$BACKUP_DIR'"
    fi

    local backup_file="$BACKUP_DIR/autostart.conf.$(date +%Y%m%d_%H%M%S)"
    run_command "cp '$AUTOSTART_FILE' '$backup_file'"
    echo "✓ Backed up existing config to $backup_file"
  fi
}

# writes the generated autostart configuration to file
# args: array of exec-once statements
write_autostart_config() {
  local config_content
  config_content=$(generate_exec_statements)

  local full_content
  full_content=$(cat << EOF
#################
### AUTOSTART ###
#################

$config_content
EOF
  )

  echo "✓ Generated autostart configuration:"
  echo
  printf "%s\n" "$full_content"  # Print to terminal
  printf "%s\n" "$full_content" > "$AUTOSTART_FILE"  # Write to file
  echo "✓ Configuration written to: $AUTOSTART_FILE"
}

# displays final summary and confirmation
show_summary() {
  echo "Summary:"
  echo "- Selected ${#selected_apps[@]} applications for autostart"
  echo "- Configuration written to: $AUTOSTART_FILE"
  echo "- Total groups processed: ${#group_order[@]}"
  echo
  echo "✅ Autostart configuration generation complete!"
}

#########################
### GROUP DEFINITIONS ###
#########################

# Define application groups here
define_app_groups() {
  push_group "Core System" waybar hyprpaper dunst clipse tmux-session
  push_group "System Utilities" blueman-applet nm-applet dbus-screen-sharing
  push_group "Communication" Telegram Technogram Discord
  push_group "Terminal Sessions" kitty-tmux
  push_group "Applications" chromium steam
}

######################
### MAIN EXECUTION ###
######################

if [ "$DEBUG_MODE" = true ]; then
  echo "[DEBUG] Commands will be logged but not executed"
fi

main() {
  define_app_groups
  select_applications
  validate_selected_apps
  backup_existing_config
  write_autostart_config
  show_summary
}

main "$@"
