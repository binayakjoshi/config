return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<leader>kr", function() require("kulala").run() end,         desc = "Kulala: Send request" },
    { "<leader>ka", function() require("kulala").run_all() end,     desc = "Kulala: Send all requests" },
    { "<leader>kb", function() require("kulala").scratchpad() end,  desc = "Kulala: Open scratchpad" },
    { "<leader>kq", function() require("kulala").close() end,       desc = "Kulala: Close window" },
    { "<leader>kt", function() require("kulala").toggle_view() end, desc = "Kulala: Toggle headers/body" },
    { "<leader>kc", function() require("kulala").copy() end,        desc = "Kulala: Copy as curl" },
    { "<leader>ki", function() require("kulala").inspect() end,     desc = "Kulala: Inspect request" },
    { "<leader>ke", function() require("kulala").set_env() end,     desc = "Kulala: Set environment" },
  },
  opts = {
    global_keymaps = false, -- we define our own above, so kulala's built-ins are disabled
    default_view = "body",
    winbar = true,
    additional_curl_options = {},
  },
}
