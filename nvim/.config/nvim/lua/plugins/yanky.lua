return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = {
      on_put = false,
      on_yank = false,
    },
  },
  keys = {
    { '<leader>fp', "<cmd>Telescope yank_history<cr>", desc = "Telescope yank history" },
  },
}
