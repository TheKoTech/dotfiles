local user = os.getenv("USER")
local file = io.open("/home/" .. user .. "/.config/hypr/autostart.lua", "w")

if file == nil then
  print("No file found")
  return
end

local names = {
  essential = {
    { "Waybar",           '"waybar"' },
    { "Hyprpaper",        '"hyprpaper"' },
    { "Random_wallpaper", '"~/.config/hypr/randomize-wp.sh"' },
    { "Dunst",            '"dunst"' },
    { "Clipse",           '"clipse -listen"' },
    { "Tmux",             '"tmux new-session -d -s main"' },
    { "Polkit",           '"systemctl --user start hyprpolkitagent"' },
    { "Kitty",            '"kitty -e tmux new-session -t main -s main-$(date +%s)", { workspace = "special:terminal silent" }' },
  },

  optional = {
    { "Bluetooth_applet",   '"blueman-applet"' },
    { "Network_applet",     '"nm-applet"' },
    { "Open_tablet_driver", '"systemctl --user start opentabletdriver"' },
  },

  apps = {
    { "AmneziaVPN", '"AmneziaVPN", { workspace = "5 silent" }' },
    { "Chromium",   '"chromium", { workspace = "1 silent" }' },
    { "Zen",        '"zen-browser", { workspace = "1 silent" }' },
    { "Steam",      '"steam", { workspace = "6 silent" }' },
    { "Telegram",   '"telegram", { workspace = "telegram:magic silent" }' },
    { "Discord",    '"discord", { workspace = "special:magic silent" }' },
    { "Vesktop",    '"vesktop", { workspace = "special:magic silent" }' },
    { "Equibop",    '"equibop", { workspace = "special:magic silent" }' },
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

local function writeLine(text) file:write(text .. '\n') end

local function writeCommand(map, name)
  local value = nil

  for _, pair in pairs(map) do
    if name == pair[1] then value = pair[2] end
  end

  if value == nil then return end

  writeLine('  hl.exec_cmd(' .. value .. ')')
end

writeLine('hl.on("hyprland.start", function()')
writeLine('  -- Essential')

for _, item in pairs(selected.essential) do
  writeCommand(names.essential, item)
end

writeLine('\n  -- Optional')

for _, item in pairs(selected.optional) do
  writeCommand(names.optional, item)
end

writeLine('\n  -- Apps')

for _, item in pairs(selected.apps) do
  writeCommand(names.apps, item)
end

writeLine('end)')
file:close()
