hl.on("hyprland.start", function()
  -- Core
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("dunst")
  hl.exec_cmd("clipse -listen")
  hl.exec_cmd("tmux new-session -d -s main")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("darkman run")

  -- Utilities
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("systemctl --user start opentabletdriver")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Terminal
  hl.exec_cmd("kitty -e tmux new-session -t main -s main-$(date +%s)", { workspace = "special:terminal silent" })

  -- Wallpaper
  hl.exec_cmd("~/.config/hypr/randomize-wp-sh")

  -- Applications
  hl.exec_cmd("zen-browser", { workspace = "1 silent" })
  hl.exec_cmd("AmneziaVPN", { workspace = "5 silent" })
  -- hl.exec_cmd("discord")
  hl.exec_cmd("Telegram", { workspace = "special:magic silent" })
end)
