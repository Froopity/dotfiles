return {
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      default_direction = "left",
      placement = "edge",
    },
    attach_mode = "global",
    manage_folds = true,
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
  },
  keys = {
    { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Open Aerial" },
  },
}
