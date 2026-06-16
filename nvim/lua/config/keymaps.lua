-- lua/config/keymaps.lua – All keymaps not tied to a specific plugin config

local map = vim.keymap.set

-- Save + Format
map("n", "<leader>w", function()
  require("conform").format({ async = false, lsp_fallback = true })
  vim.cmd("w")
end, { desc = "Format + Save" })

-- General
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>pv", ":Ex<CR>")

-- Diagnostics
map("n", "<leader>d", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic" })

-- Split windows
map("n", "<leader>sr", function()
  vim.cmd("vsplit | enew")
  vim.cmd("Telescope find_files")
end, { desc = "Split Right & Pick File" })

map("n", "<leader>sb", function()
  vim.cmd("split")
  vim.cmd("Telescope find_files")
end, { desc = "Split Below & Pick File" })

map("n", "<leader>=", "<C-w>=", { desc = "Equalize Split Sizes" })

-- Cycle through windows
vim.api.nvim_set_keymap("n", "<leader><Tab>", "<C-w>w", { noremap = true, silent = true })

-- Visual mode: delete without yanking
map("v", "d", '"_d', { noremap = true, silent = true, desc = "Delete without yank" })
map("v", "x", "d", { noremap = true, silent = true, desc = "Yank + delete" })

-- Folding
map("n", "za", "za", { desc = "Toggle Fold" })
map("n", "<leader>z", function()
  if vim.wo.foldmethod ~= "expr" then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
  end
  pcall(function() vim.cmd("normal! za") end)
end, { desc = "Toggle Fold" })

map("n", "<leader>+", "zR", { desc = "Open All Folds" })
map("n", "<leader>-", "zM", { desc = "Close All Folds" })

-- Buffer delete
map("n", "<leader>x", function()
  require("bufdelete").bufdelete(0, true)
end, { desc = "Safe Buffer Delete" })

-- NvimTree
map("n", "<leader>e", ":NvimTreeToggle<CR>")
map("n", "<leader>f", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>")


vim.keymap.set("n", "<leader>fr", function()
  require("grug-far").open()
end, { desc = "Search and replace (grug-far)" })


--latex
vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "LaTeX Compile" })

vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "LaTeX View PDF" })

vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", { desc = "LaTeX TOC" })

vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>", { desc = "LaTeX Clean" })
