require "nvchad.options"

-- add yours here!
local opt = vim.opt

-- ✅ Configurar clipboard para WSL2
opt.clipboard = "unnamedplus"  -- Usar clipboard del sistema

-- ✅ Configuración de indentación global
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- ✅ Configuración específica para Java (ESTO ES CLAVE)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4        -- Ancho de tab visual
    vim.opt_local.shiftwidth = 4     -- Espacios para auto-indentación
    vim.opt_local.expandtab = true   -- Convertir tabs en espacios
    vim.opt_local.autoindent = true  -- Mantener indentación de línea anterior
    vim.opt_local.smartindent = true -- Indentación inteligente para código
    vim.opt_local.cindent = true     -- Indentación estilo C (mejor para Java)
    
    -- Configuraciones específicas de indentación para Java
    vim.opt_local.cinoptions = "j1,(0,ws,Ws"  -- Mejor handling de { } y ()
  end,
})