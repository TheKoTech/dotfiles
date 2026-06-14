local script_dir = debug.getinfo(1, "S").source

print(script_dir)

local user = os.getenv("USER")
local file = io.open("/home/" .. user .. "/.config/hypr/autostart.lua", "w")

if file == nil then
  print("No file found")
  return
end

local names = {
  essential = {
    { "Waybar",           'waybar' },
    { "Hyprpaper",        'hyprpaper' },
    { "Random_wallpaper", '~/.config/hypr/randomize-wp-sh' },
    { "Dunst",            'dunst' },
    { "Clipse",           'clipse -listen' },
    { "Tmux",             'tmux new-session -d -s main' },
    { "Polkit",           'systemctl --user start hyprpolkitagent' },
    { "Kitty",            'kitty -e tmux new-session -t main -s main-$(date +%s)', ', { workspace = "special:terminal silent" }' },
  },

  optional = {
    { "Bluetooth_applet",   '"blueman-applet"' },
    { "Network_applet",     '"nm-applet"' },
    { "Open_tablet_driver", '"systemctl --user start opentabletdriver"' },
  },

  apps = {
    { "Chromium", '"chromium"',    ', { workspace = "1 silent" }' },
    { "Zen",      '"zen-browser"', ', { workspace = "1 silent" }' },
    { "Steam",    '"steam"',       ', { workspace = "6 silent" }' },
    { "Discord",  '"discord"',     ', { workspace = "special:magic silent" }' },
    { "Vesktop",  '"vesktop"',     ', { workspace = "special:magic silent" }' },
    { "Equibop",  '"equibop"',     ', { workspace = "special:magic silent" }' },
  },
}


local function make_keys(map)
  local keys = {}

  for _, pair in pairs(map) do
    table.insert(keys, pair[1])
  end

  return keys
end

local keys = {
  essential = make_keys(names.essential),
  optional = make_keys(names.optional),
  apps = make_keys(names.apps),
}

local function split(text, pattern)
  local result = {}

  for match in string.gmatch(text, pattern) do
    table.insert(result, match)
  end

  return result
end

local function gum_choose(items)
  local handle = io.popen("gum choose --no-limit " .. table.concat(items, " "))
  local selected = handle and handle:read("*a")

  if handle ~= nil then handle:close() end

  return split(selected, "[^\r\n]+")
end

local selected = {
  essential = gum_choose(keys.essential),
  optional = gum_choose(keys.optional),
  apps = gum_choose(keys.apps),
}

local function writeLine(text)
  file:write(text .. '\n')
end

local function writeCommand(name)
  writeLine
  ('  hl.exec_cmd("' .. name .. '")')
end

writeLine('hl.on("hyprland.start", function()\n')

writeCommand(selected.essential[1])

writeLine('end)')
file:close()
