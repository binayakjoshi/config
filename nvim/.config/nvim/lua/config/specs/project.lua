-- lua/config/specs/project.lua – project switching + session management
return {
  "coffebar/neovim-project",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- already configured in editor.lua
    "Shatur/neovim-session-manager",
  },
  lazy = false,
  priority = 100, -- load before other plugins so session/cwd is set early
  init = function()
    vim.opt.sessionoptions:append("localoptions")
  end,
  config = function()
    require("neovim-project").setup({
      projects = {
        "/run/media/binayak/kiki/Work/pos/*",
        "/run/media/binayak/kiki/code/projects/*", -- first level
        "/run/media/binayak/kiki/code/projects/*/*",
        "~/.config/*",
      },
      picker = {
        type = "telescope",
      },
      last_session_on_startup = false,
      dashboard_mode = false,
    })

    -- must run after both telescope and neovim-project are set up
    require("telescope").load_extension("neovim-project")
  end,
}
