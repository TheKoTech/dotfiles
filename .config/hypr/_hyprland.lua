local function file_exists(name)
  local file = io.open("~/.config/hypr/" .. name, "r")

  if file ~= nil then
    io.close(file)
    return true
  else
    return false
  end
end

require("_animations")
require("_keybinds")

if (file_exists("_autostart")) then
  require("_autostart")
end

if (file_exists("_monitors")) then
  require("_monitors")
end

if (file_exists("_cursor")) then
  require("_cursor")
end


hl.config({
  general = {
    border_size = 2,
    gaps_in = 4,
    gaps_out = 8,
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(3366FFee)", "rgba(590900ee)", "rgba(ff5c16ee)" }, angle = 23 },
      inactive_border = "rgba(ffffff40)",
      nogroup_border_active = { colors = { "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(33ccffee)", "rgba(3366FFee)", "rgba(590900ee)", "rgba(ff5c16ee)" }, angle = 23 },
      nogroup_border_ = "rgba(ffffff40)",
    },
  },

  decoration = {
    rounding = 8,

    shadow = {
      enabled = true,
      range = 16,
      render_power = 3,
      sharp = false,
      color = "rgba(06121a6a)"
    },

    blur = {
      enabled = true,
      size = 12,
      passes = 3,
      xray = true,
      brightness = 1.25,
      vibrancy = 0.1696,
      vibrancy_darkness = 0.2,
    },
  },

  dwindle = {
    preserve_split = true,
    smart_split = true,
  },

  input = {
    kb_layout = "us,ru",
    kb_options = "grp:win_space_toggle, caps:super",

    follow_mouse = 1,

    accel_profile = "custom 10 0.0 9.0 36.0 81.0",
    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    special_fallthrough = true,

    touchpad = {
      natural_scroll = false,
      scroll_factor = .5,
    },
  },
})

hl.window_rule({
  name = "clipse",
  match = { class = "clipse" },
  float = true,
  size = { 622, 652 },
  move = { "50%", "50%" },
  stay_focused = true,
})

hl.window_rule({
  name = "gnome-calendar",
  match = { title = "^(Calendar)$" },
  float = true,
  size = { 800, 600 },
  move = { 1100, 58 } -- # qwq percent no worky,
})

hl.layer_rule({
  name = "overlays",
  match = { namespace = "(waybar|notifications|launcher)" },
  ignore_alpha = true,
  blur = true,
})

-- Background blur for fancy looks
-- No animations for shit that doesn't need animations
hl.layer_rule({
  name = "noanim",
  match = { namespace = "(hyprpaper|waybar|hyprpicker)" },
  no_anim = true,
})
