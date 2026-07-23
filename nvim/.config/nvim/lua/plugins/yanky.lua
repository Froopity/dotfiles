return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = {
      on_put = false,
      on_yank = false,
    },
  },
  keys = {
    { '<leader>p', "<cmd>Telescope yank_history<cr>", desc = "Toggle Scratchpad" },
  },
}
