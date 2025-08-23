return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Mason configuration - Instalar LSP servers automáticamente
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "jdtls",              -- Java Language Server
        "java-debug-adapter", -- Para debugging Java
        "java-test",          -- Para ejecutar tests
        "google-java-format", -- Formateo de código Java
      },
    },
  },

  -- Copilot configuration (sin keymaps personalizados)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { 
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-y>",
            dismiss = "<C-e>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          java = true,
          lua = true,
          ["*"] = true,
        },
      })
    end,
  },

  -- Blink configuration
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = 'default',
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "java"
      },
    },
  },

  -- Plugin específico para Java (opcional pero recomendado)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      -- Configuración básica de nvim-jdtls
      local jdtls = require('jdtls')
      local on_attach = function(client, bufnr)
        jdtls.setup_dap({ hotcodereplace = 'auto' })
        require("nvchad.configs.lspconfig").on_attach(client, bufnr)
      end
      
      local config = {
        cmd = { 'jdtls' },
        on_attach = on_attach,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
        root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),
        -- En la sección nvim-jdtls, agregar configuración Java 21:
        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "interactive",
              runtimes = {
                {
                  name = "JavaSE-21",  -- Cambiar de JavaSE-17 a JavaSE-21
                  path = os.getenv("JAVA_HOME") or "/home/mercer2511/.sdkman/candidates/java/current/",
                }
              }
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
          }
        }
      }
      
      jdtls.start_or_attach(config)
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  -- Agregar a ~/.config/nvim/lua/plugins/init.lua:
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  }
}