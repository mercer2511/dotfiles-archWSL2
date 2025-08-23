-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  -- Opcional: personalizar colores para Copilot
  hl_override = {
    CopilotSuggestion = {
      fg = "grey_fg2",
      italic = true,
    },
  },
}

return M
