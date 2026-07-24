return {
  'stevearc/conform.nvim',
  event = "BufWritePre",
  opts = function()
    return {
      formatters_by_ft = require('user.langs').formatters_by_ft(),
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == 'yaml.cloudformation' then return end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
    }
  end,
}
