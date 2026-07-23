return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.install").install({ "bash", "fish", "lua", "markdown", "python"})

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "bash", "fish", "lua", "markdown", "python", "sh"},
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
