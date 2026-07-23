return {
  "folke/snacks.nvim",
  opts = {
    scratch = {},
    indent = {
      animate = {
        enabled = false,
      },
    },
  },
  keys = {
    { '<leader>.', function() require('snacks').scratch() end, desc = "Toggle Scratchpad" },
  },
}
