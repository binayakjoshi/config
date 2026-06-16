-- lua/config/plugins/git.lua

return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({ signcolumn = false })

      vim.keymap.set("n", "<leader>gb", function()
        require("gitsigns").toggle_current_line_blame()
      end, { desc = "Toggle inline git blame" })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config  = function()
      require("git-conflict").setup({
        default_mappings = false,
        highlights = {
          current  = "DiffAdd",    -- Greenish  (Our changes)
          incoming = "DiffChange", -- Teal      (Their changes)
          ancestor = "DiffDelete", -- Reddish   (Common ancestor)
        },
      })

      -- Custom label highlight overrides
      vim.cmd([[
        highlight GitConflictCurrentLabel  gui=bold guibg=#3d484d
        highlight GitConflictIncomingLabel gui=bold guibg=#3d484d
      ]])

      local map  = vim.keymap.set
      local opts = { silent = true, noremap = true }

      map("n", "<leader>co", "<cmd>GitConflictChooseOurs<CR>",   vim.tbl_extend("force", opts, { desc = "Accept OURS (local)" }))
      map("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", vim.tbl_extend("force", opts, { desc = "Accept THEIRS (incoming)" }))
      map("n", "<leader>cb", "<cmd>GitConflictChooseBoth<CR>",   vim.tbl_extend("force", opts, { desc = "Accept BOTH" }))
      map("n", "<leader>c0", "<cmd>GitConflictChooseNone<CR>",   vim.tbl_extend("force", opts, { desc = "Accept NONE" }))
      map("n", "]x",         "<cmd>GitConflictNextConflict<CR>", opts)
      map("n", "[x",         "<cmd>GitConflictPrevConflict<CR>", opts)
    end,
  },
}
