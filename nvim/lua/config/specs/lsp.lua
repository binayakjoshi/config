-- lua/config/plugins/lsp.lua

return {
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "lua_ls",
          "pyright",
          "texlab",
        },
      })

      -- Shared on_attach
      local on_attach = function(client, bufnr)
        -- Disable tsserver formatting (handled by conform)
        if client.name == "ts_ls" then
          client.server_capabilities.documentFormattingProvider = false
        end

        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            silent = true,
          })
        end

        map("n", "gd", vim.lsp.buf.definition)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "<leader>rn", vim.lsp.buf.rename)

        -- Diagnostics
        map("n", "<leader>d", vim.diagnostic.open_float)
        map("n", "[d", vim.diagnostic.goto_prev)
        map("n", "]d", vim.diagnostic.goto_next)
      end

      -- Capabilities enhanced with nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- TypeScript / JavaScript

      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },

        root_markers = {
          "tsconfig.json",
          "package.json",
          "jsconfig.json",
          ".git",
        },

        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },

        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = false,

        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "none",
              includeInlayVariableTypeHints = false,
            },
          },
        },
      })

      vim.lsp.enable("ts_ls")

      -- Python

      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },

        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "pyrightconfig.json",
        },

        filetypes = { "python" },

        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },

        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.enable("pyright")
      -- Lua

      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,

        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },

            workspace = {
              checkThirdParty = false,
            },

            telemetry = {
              enable = false,
            },
          },
        },
      })

      vim.lsp.enable("lua_ls")

      -- LaTeX

      vim.lsp.config("texlab", {
        on_attach = on_attach,
        capabilities = capabilities,

        filetypes = { "tex", "plaintex", "bib" },

        settings = {
          texlab = {
            chktex = {
              onOpenAndSave = true,
              onEdit = false,
            },
          },
        },
      })

      vim.lsp.enable("texlab")

      vim.lsp.enable("texlab")
    end,
  },
}
