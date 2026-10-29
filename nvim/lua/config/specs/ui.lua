-- lua/config/plugins/ui.lua – colorschemes, bufferline, lualine, nvim-tree, devicons

-- Nerd Font icons built from codepoints, so no raw glyphs or \u escapes are needed
-- (LuaJIT does not support "\uXXXX" escapes).
local function icon(code) return vim.fn.nr2char(code) end

local icons = {
  error     = icon(0xf057) .. " ", -- circle-x
  warning   = icon(0xf071) .. " ", -- triangle warning
  conflict  = icon(0xf071) .. " ",
  lock      = icon(0xf023),        -- readonly
  lsp       = icon(0xf085),        -- gears
  -- Powerline arrow separators
  sec_left  = icon(0xe0b0),
  sec_right = icon(0xe0b2),
  cmp_left  = icon(0xe0b1),
  cmp_right = icon(0xe0b3),
  -- Rounded pills (swap in if you prefer):
  -- sec_left = icon(0xe0b4), sec_right = icon(0xe0b6),
  -- cmp_left = icon(0xe0b5), cmp_right = icon(0xe0b7),
}

return {
  -- Dependencies
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode                    = "buffers",
        separator_style         = "thin",
        tab_size                = 18,
        max_name_length         = 20,
        truncate_names          = true,
        enforce_regular_tabs    = true,
        diagnostics             = "nvim_lsp",
        diagnostics_indicator   = function(count, level)
          local sign = level:match("error") and icons.error or icons.warning
          return sign .. count
        end,
        indicator               = {
          icon  = "▎",
          style = "icon",
        },
        modified_icon           = "●",
        show_close_icon         = false,
        show_buffer_close_icons = false,
        show_buffer_icons       = true,
        color_icons             = true,
        always_show_bufferline  = true,
        show_duplicate_prefix   = true,
        offsets                 = {
          {
            filetype   = "NvimTree",
            text       = "Explorer",
            text_align = "center",
            separator  = true,
          },
        },
      },
    },
  },

  -- Colorscheme
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000, -- load first so the colorscheme is set before other UI plugins
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_transparent_background = 1
      vim.cmd("colorscheme everforest")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local group = vim.api.nvim_create_augroup("LualineCache", { clear = true })

      -- Cache conflict-marker detection instead of scanning on every redraw
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
        group = group,
        callback = function(ev)
          if vim.bo[ev.buf].buftype ~= "" then return end
          vim.b[ev.buf].has_conflict = vim.api.nvim_buf_call(ev.buf, function()
            return vim.fn.search("^<<<<<<< ", "nw") ~= 0
          end)
        end,
      })

      -- Refresh immediately when macro recording starts/stops
      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        group = group,
        callback = function() require("lualine").refresh() end,
      })

      -- Cache diagnostics summary (counts + first line) only when diagnostics change
      local sev = vim.diagnostic.severity
      local diag_cfg = {
        { sev.ERROR, "E", "DiagnosticError" },
        { sev.WARN,  "W", "DiagnosticWarn" },
        { sev.HINT,  "H", "DiagnosticHint" },
      }

      vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
        group = group,
        callback = function(ev)
          if not vim.api.nvim_buf_is_valid(ev.buf) then return end
          local counts = vim.diagnostic.count(ev.buf)
          local parts = {}
          for _, c in ipairs(diag_cfg) do
            local n = counts[c[1]]
            if n and n > 0 then
              local first
              for _, d in ipairs(vim.diagnostic.get(ev.buf, { severity = c[1] })) do
                if not first or d.lnum < first then first = d.lnum end
              end
              table.insert(parts, ("%%#%s#%s:%d(L%d)%%*"):format(c[3], c[2], n, (first or 0) + 1))
            end
          end
          vim.b[ev.buf].diag_str = table.concat(parts, " ")
        end,
      })

      local function lsp_clients()
        local names = {}
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, c.name)
        end
        return table.concat(names, ",")
      end

      return {
        options = {
          theme                = "everforest",
          globalstatus         = true,
          section_separators   = { left = icons.sec_left, right = icons.sec_right },
          component_separators = { left = icons.cmp_left, right = icons.cmp_right },
          disabled_filetypes   = { statusline = { "NvimTree" } },
        },
        extensions = { "nvim-tree", "lazy" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              -- Use gitsigns data when available (faster); falls back to lualine's own
              source = function()
                local g = vim.b.gitsigns_status_dict
                if g then
                  return { added = g.added, modified = g.changed, removed = g.removed }
                end
              end,
            },
          },
          lualine_c = {
            {
              function() return icons.conflict .. "CONFLICT" end,
              cond = function() return vim.b.has_conflict == true end,
              color = "DiagnosticError",
            },
            {
              "filename",
              path = 1, -- relative path (bufferline already shows the name)
              symbols = { modified = "●", readonly = " " .. icons.lock, unnamed = "[No Name]" },
            },
            {
              function() return "recording @" .. vim.fn.reg_recording() end,
              cond = function() return vim.fn.reg_recording() ~= "" end,
              color = "DiagnosticWarn",
            },
          },
          lualine_x = {
            {
              function() return vim.b.diag_str or "" end,
              cond = function() return (vim.b.diag_str or "") ~= "" end,
            },
            {
              lsp_clients,
              icon = icons.lsp,
              cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
            },
            "searchcount",
            "selectioncount",
            {
              "encoding",
              cond = function() return vim.bo.fenc ~= "" and vim.bo.fenc ~= "utf-8" end,
            },
            {
              "fileformat",
              cond = function() return vim.bo.fileformat ~= "unix" end,
            },
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view                = { width = 30 },
        filters             = {
          git_ignored = false,
          dotfiles    = false,
        },
        renderer            = {
          highlight_git          = true,
          highlight_opened_files = "all",
          root_folder_label      = false,
          icons                  = {
            show = { git = true, folder = true, file = true },
          },
        },
        update_focused_file = { enable = true, update_root = true },
        sync_root_with_cwd  = true,
        respect_buf_cwd     = true,
      })
    end,
  },
}
