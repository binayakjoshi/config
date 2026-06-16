-- lua/config/plugins/ui.lua – colorschemes, lualine, nvim-tree, devicons

return {
  -- Dependencies
  { "nvim-lua/plenary.nvim" },
  { "kyazdani42/nvim-web-devicons" },

  -- Colorschemes
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000, -- Load first so colorscheme is set before other UI plugins
    config = function()
      -- globals already set in options.lua
      vim.cmd("colorscheme everforest")
    end,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true, -- Only load if you switch to it manually
    init = function()
      vim.g.gruvbox_material_enable_italic = 1
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme               = "everforest",
          section_separators  = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            {
              -- Show a CONFLICT indicator when merge markers are present
              function()
                local conflict = vim.fn.search("<<<<<<<", "nw")
                if conflict ~= 0 then return " CONFLICT" end
                return ""
              end,
              color = { fg = "#ff5555", gui = "bold" },
            },
            "filename",
          },
          lualine_x = {
            {
              -- Custom diagnostics: show error/warn counts with line numbers
              function()
                local diags  = vim.diagnostic.get(0)
                local counts = { E = 0, W = 0, H = 0 }
                local first_error, first_warn = nil, nil

                for _, d in ipairs(diags) do
                  if d.severity == vim.diagnostic.severity.ERROR then
                    counts.E = counts.E + 1
                    if not first_error then first_error = d.lnum + 1 end
                  elseif d.severity == vim.diagnostic.severity.WARN then
                    counts.W = counts.W + 1
                    if not first_warn then first_warn = d.lnum + 1 end
                  elseif d.severity == vim.diagnostic.severity.HINT then
                    counts.H = counts.H + 1
                  end
                end

                local out = {}
                if counts.E > 0 then
                  table.insert(out, "%#DiagnosticError# E:" .. counts.E .. (first_error and "(L" .. first_error .. ")" or "") .. "%*")
                end
                if counts.W > 0 then
                  table.insert(out, "%#DiagnosticWarn# W:" .. counts.W .. (first_warn and "(L" .. first_warn .. ")" or "") .. "%*")
                end
                if counts.H > 0 then
                  table.insert(out, "%#DiagnosticHint# H:" .. counts.H .. "%*")
                end

                return table.concat(out, "  ")
              end,
              color = {},
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view    = { width = 30 },
        filters = {
          git_ignored = false,
          dotfiles    = false,
        },
        renderer = {
          highlight_git          = true,
          highlight_opened_files = "all",
          root_folder_label      = false,
          icons = {
            show = { git = true, folder = true, file = true },
          },
        },
        update_focused_file = { enable = true, update_cwd = true },
        sync_root_with_cwd  = true,
        respect_buf_cwd     = true,
      })
    end,
  },
}
