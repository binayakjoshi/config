-- lua/config/autocmds.lua – Autocommands and user commands

local fold_group = vim.api.nvim_create_augroup("TreesitterFolding", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
  group = fold_group,
  callback = function()
    if vim.bo.buftype == "" and vim.bo.filetype ~= "" and vim.bo.filetype ~= "NvimTree" then
      vim.schedule(function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end)
    end
  end,
})

-- Stop orphaned LSP clients (0 attached buffers) after switching projects
vim.api.nvim_create_autocmd("DirChanged", {
  desc = "Stop orphaned LSP clients on project switch",
  callback = function()
    vim.defer_fn(function()
      for _, client in pairs(vim.lsp.get_clients()) do
        if vim.tbl_isempty(client.attached_buffers) then
          client.stop()
        end
      end
    end, 200) -- small delay so buffer detachment finishes first
  end,
})

-- Open telescope find_files right after switching projects
vim.api.nvim_create_autocmd("DirChanged", {
  desc = "Open telescope find_files on project switch",
  callback = function()
    vim.defer_fn(function()
      require("telescope.builtin").find_files()
    end, 100)
  end,
})
