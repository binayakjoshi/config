return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "none"
      vim.g.molten_auto_open_output = false
    end,
    ft = { "python", "quarto", "markdown" },
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<CR>",           desc = "Molten Init" },
      { "<leader>me", "<cmd>MoltenEvaluateCell<CR>",   desc = "Evaluate Cell" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<CR>", desc = "Re-evaluate Cell" },
      { "<leader>mo", "<cmd>MoltenShowOutput<CR>",     desc = "Show Output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<CR>",     desc = "Hide Output" },
    },
  },
}
