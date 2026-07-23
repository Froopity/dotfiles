return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
  },
}
