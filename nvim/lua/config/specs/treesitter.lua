-- lua/config/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "bash",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "lua",
          "html",
          "css",
          "markdown",
          "python",
          "latex",
          "bibtex",
        },
        highlight = { enable = true },
        indent = { enable = true },
        folding = { enable = false },
      })
    end,
  },
}
