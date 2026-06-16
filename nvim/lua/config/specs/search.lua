return {
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({
        windowCreationCommand = "botright vnew", -- vertical split instead of full
        window = {
          width = 0.25,                          -- 40% of screen
        },
      })
    end,
  },
}
