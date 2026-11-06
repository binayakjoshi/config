-- lua/config/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local ts = require("nvim-treesitter")

      ts.setup()

      ts.install({
        "bash",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "lua",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "python",
        "latex",
        "bibtex",
      })

      -- Filetypes (not parser names) that get treesitter features
      local filetypes = {
        "sh",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "lua",
        "html",
        "css",
        "markdown",
        "python",
        "tex",
        "bib",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        pattern = filetypes,
        callback = function()
          -- Highlighting (pcall: parser may still be compiling on a fresh install)
          pcall(vim.treesitter.start)

          -- Indentation (experimental upstream; remove if it misbehaves)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Folding (optional, uncomment to enable)
          -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- vim.wo[0][0].foldmethod = "expr"
        end,
      })
    end,
  },
}
