binds {
  movefocus_cycles_fullscreen = false
}

hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exit())
hl.bind("SUPER + SHIFT + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + SHIFT + ALT + P", hl.dsp.exec_cmd("poweroff"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("reboot"))

hl.bind("SUPER + G", hl.dsp.exec_cmd("kitty -e tmux new-session -t main -s main-$(date +%s)"))
hl.bind("SUPER + SHIFT + U", hl.dsp.exec_cmd("kitty -e ssh justhost -t tmux new-session -A -s main"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("kitty -e ssh tiwi -t tmux new-session -A -s main"))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd("kitty"))

hl.bind("SUPER + F", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("kitty --class clipse -e 'clipse' && focusewindow clipse"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("bemoji -c -n"))

hl.bind("SUPER + SHIFT + ALT + G", hl.dsp.exec_cmd("kitty -e tmux new-session -t ssh -s ssh-$(date +%s)"))

hl.bind("SUPER + SHIFT + X", hl.dsp.window.kill())
hl.bind("SUPER + Z", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + X", hl.dsp.window.float())
hl.bind("SUPER + P", hl.dsp.window.pin())

hl.bind("SUPER + left", hl.dsp.focus("l"))
hl.bind("SUPER + right", hl.dsp.focus("r"))
hl.bind("SUPER + up", hl.dsp.focus("u"))
hl.bind("SUPER + down", hl.dsp.focus("d"))

hl.bind("SUPER + H", hl.dsp.focus("l"))
hl.bind("SUPER + L", hl.dsp.focus("r"))
hl.bind("SUPER + J", hl.dsp.focus("d"))
hl.bind("SUPER + K", hl.dsp.focus("u"))

hl.bind("SUPER + C", hl.dsp.window.center())

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move("l"))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move("r"))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move("d"))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move("u"))

hl.bind("SUPER + ALT + H", hl.dsp.window.resize({ x = -10, y = 0 }), { repeating = true })
hl.bind("SUPER + ALT + L", hl.dsp.window.resize({ x = 10, y = 0 }), { repeating = true })
hl.bind("SUPER + ALT + J", hl.dsp.window.resize({ x = 0, y = 10 }), { repeating = true })
hl.bind("SUPER + ALT + K", hl.dsp.window.resize({ x = 0, y = -10 }), { repeating = true })

hl.bind("SUPER + CTRL + H", hl.dsp.window.move({ x = -10, y = 0 }), { repeating = true })
hl.bind("SUPER + CTRL + L", hl.dsp.window.move({ x = 10, y = 0 }), { repeating = true })
hl.bind("SUPER + CTRL + J", hl.dsp.window.move({ x = 0, y = 10 }), { repeating = true })
hl.bind("SUPER + CTRL + K", hl.dsp.window.move({ x = 0, y = -10 }), { repeating = true })

hl.bind("SUPER + tab", hl.dsp.focus({ last = true }))

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + f1", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + f2", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + f3", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + f4", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + f5", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + D", hl.dsp.workspace({ monitor1 = "left", monitor2 = "right" }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + f1", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + f2", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + f3", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + f4", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + f5", hl.dsp.window.move({ workspace = 10 }))

hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --freeze copy area"), { locked = true })

hl.bind("SUPER + slash", hl.dsp.exec_cmd("hyprpicker -ard -f hex"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-4"), { locked = true, repeating = true })

hl.bind("SUPER + apostrophe", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + apostrophe", hl.dsp.window.move("special:magic"))
hl.bind("SUPER + semicolon", hl.dsp.workspace.toggle_special("terminal"))
hl.bind("SUPER + SHIFT + semicolon", hl.dsp.window.move("special:terminal"))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.resize())
