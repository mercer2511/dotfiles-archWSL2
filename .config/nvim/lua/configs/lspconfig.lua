require("nvchad.configs.lspconfig").defaults()

local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Servidores LSP básicos
local servers = { "html", "cssls" }

-- Configurar servidores básicos
for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Configuración específica para Java LSP (actualizada para Java 21)
require("lspconfig").jdtls.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    
    -- Keymaps específicos para Java
    local opts = { buffer = bufnr, silent = true }
    
    -- Organizar imports
    vim.keymap.set("n", "<leader>jo", "<cmd>lua require('jdtls').organize_imports()<CR>", 
      vim.tbl_extend("force", opts, { desc = "Java organize imports" }))
    
    -- Extract variable
    vim.keymap.set("n", "<leader>jv", "<cmd>lua require('jdtls').extract_variable()<CR>", 
      vim.tbl_extend("force", opts, { desc = "Java extract variable" }))
    
    -- Extract method
    vim.keymap.set("v", "<leader>jm", "<cmd>lua require('jdtls').extract_method(true)<CR>", 
      vim.tbl_extend("force", opts, { desc = "Java extract method" }))
  end,
  
  capabilities = capabilities,
  
  -- Configuración del workspace y runtime
  cmd = { "jdtls" },
  root_dir = require("lspconfig.util").root_pattern(
    ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.xml"
  ),
  
  settings = {
    java = {
      -- Configuración de errores y warnings
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      
      -- Configuración de completion
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        }
      },
      
      -- Configuración de sources
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        }
      },
      
      -- Configuración de runtime ACTUALIZADA para Java 21
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-21",
            path = os.getenv("JAVA_HOME") or "/home/mercer2511/.sdkman/candidates/java/current/",
          }
        }
      },
      
      -- Detectar errores de runtime
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      
      -- Code lens para métodos
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
    }
  },
  
  -- Inicialización
  init_options = {
    bundles = {}
  },
}

-- Habilitar servidores
vim.lsp.enable(vim.tbl_extend("force", servers, { "jdtls" }))