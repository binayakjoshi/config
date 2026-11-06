return {
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({
        windowCreationCommand = "botright vertical 90split",
        startInInsertMode = true,
        disableBufferLineNumbers = true,
        engines = {
          ripgrep = {
            showReplaceDiff = true,
          },
        },
        transient = true,
        wrap = true,
        resultsHighlight = true,
      })
    end,
  },
}
