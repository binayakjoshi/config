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
map("n", "<leader><Tab>", "<C-w>w", {
  desc = "Next Window",
})

-- Visual mode: delete without yanking
map("v", "d", '"_d', { noremap = true, silent = true, desc = "Delete without yank" })
map("v", "x", "d", { noremap = true, silent = true, desc = "Yank + delete" })

-- Folding

map("n", "<leader>+", "zR", { desc = "Open All Folds" })
map("n", "<leader>-", "zM", { desc = "Close All Folds" })

-- Buffer delete
map("n", "<leader>x", function()
  local bufdelete = require("bufdelete")
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })

  if #bufs > 1 then
    -- Delete buffer, keep window layout
    bufdelete.bufdelete(0, true)
  else
    -- Last buffer: close the window instead of [No Name]
    vim.cmd("quit")
  end
end, { desc = "Delete buffer / close last window" })

vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>")
-- NvimTree
map("n", "<leader>e", ":NvimTreeToggle<CR>")
map("n", "<leader>f", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree" })
-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>")


vim.keymap.set("n", "<leader>fr", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and replace (grug-far)" })

--latex
vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "LaTeX Compile" })
vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "LaTeX View PDF" })
vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", { desc = "LaTeX TOC" })
vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>", { desc = "LaTeX Clean" })
vim.keymap.set("n", "<leader>fp", "<cmd>NeovimProjectDiscover<cr>", { desc = "Find Project" })
vim.keymap.set("n", "<leader>fh", "<cmd>NeovimProjectHistory<cr>", { desc = "Recent Projects" })
