-- lua/config/plugins/editor.lua – autopairs, telescope, bufdelete

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ enable_check_bracket_line = true })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },
  {
    "famiu/bufdelete.nvim",
    event = "BufReadPost",
  },
  {
    "lervag/vimtex",
    lazy = false,

    init = function()
      vim.g.tex_flavor = "latex"

      vim.g.vimtex_view_method = "zathura"

      vim.g.vimtex_compiler_method = "latexmk"

      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_fold_enabled = 1

      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        build_dir = "build",
        aux_dir = "build",
        callback = 1,
        continuous = 1,
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-file-line-error",
        },
      }
    end,
  }
}
