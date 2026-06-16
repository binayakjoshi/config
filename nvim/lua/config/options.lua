-- lua/config/options.lua – All vim options and globals

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.guifont = "OperatorMonoNerdFont:h15"

-- Colorscheme globals (must be set before plugin loads colorscheme)
vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 1
vim.g.gruvbox_material_enable_italic = 1

local o = vim.opt

o.number         = true
o.relativenumber = false
o.tabstop        = 2
o.shiftwidth     = 2
o.expandtab      = true
o.smartindent    = true
o.wrap           = false
o.signcolumn     = "yes"
o.clipboard      = "unnamedplus"
o.termguicolors  = true
o.mouse          = "a"
o.timeoutlen     = 500
o.updatetime     = 300
o.swapfile       = false
o.undofile       = true
o.splitright     = true
o.equalalways    = true

-- Folding
o.foldlevel   = 99
o.foldenable  = true
o.foldcolumn  = "1"
o.fillchars = { fold = " ", foldopen = "▾", foldclose = "▸" }
o.foldtext    = "v:lua.MyFoldText()"

-- Custom fold text (global so foldtext= can call it)
function _G.MyFoldText()
  local line_start = vim.fn.getline(vim.v.foldstart):gsub("^%s*", "")
  local count = vim.v.foldend - vim.v.foldstart + 1
  return string.format("   %s ... [%d lines]", line_start, count)
end
