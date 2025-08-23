local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    java = { "google-java-format" },  -- ✅ Agregar formateo Java
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- ✅ Formateo automático al guardar (opcional)
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options