hl.curve("smoothIn", {
  type = "bezier",
  points = { { 0.2, 0.8 }, { 0.6, 1.0 } }
})

hl.curve("smoothOut", {
  type = "bezier",
  points = { { 0.17, 0 }, { 0.7, 0 } }
})

hl.curve("smoothOut2", {
  type = "bezier",
  points = { { 0.16, 0 }, { 0.42, 0 } }
})

hl.curve("smoothWindow", {
  type = "bezier",
  points = { { 0.16, 0.77 }, { 0.33, 1.0 } }
})

hl.curve("linear", {
  type = "bezier",
  points = { { 1, 1 }, { 1, 1 } }
})

hl.curve("border", {
  type = "bezier",
  points = { { 0.17, 0.12 }, { 0.32, 1 } }
})


hl.config({
  animations = {
    enabled = true,
    workspace_wraparound = true,
  },
})

hl.animation({ leaf = "windows", speed = 4, bezier = "smoothWindow", style = "slide" })
hl.animation({ leaf = "windowsIn", speed = 2, bezier = "smoothIn", style = "popin 67%" })
hl.animation({ leaf = "windowsOut", speed = 1.5, bezier = "smoothOut", style = "popin 0%" })
hl.animation({ leaf = "windowsMove", speed = 4, bezier = "smoothWindow", style = "slide" })
hl.animation({ leaf = "layersIn", speed = 3, bezier = "smoothIn", style = "popin 0%" })
hl.animation({ leaf = "layersOut", speed = 2, bezier = "smoothOut", style = "popin 0%" })
hl.animation({ leaf = "border", speed = 3, bezier = "border" })
hl.animation({ leaf = "fade", speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeIn", speed = 2, bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut", speed = 2, bezier = "smoothOut" })
hl.animation({ leaf = "workspaces", speed = 4, bezier = "smoothWindow" })

hl.animation({ leaf = "specialWorkspaceIn", speed = 3.2, bezier = "smoothIn", style = "slidefadevert 25%" })
hl.animation({ leaf = "specialWorkspaceOut", speed = 1.6, bezier = "smoothOut2", style = "slidefadevert 25%" })
