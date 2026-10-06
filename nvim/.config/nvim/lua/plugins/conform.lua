-- yamlfix is a Python tool that regularly takes longer than the 500ms sync
-- budget (startup alone is ~0.2-0.6s), so yaml formats after the write
-- instead of blocking it and timing out.
local function format_async(bufnr)
  return vim.bo[bufnr].filetype:match('^yaml') ~= nil
end

return {
  'stevearc/conform.nvim',
  event = "BufWritePre",
  opts = function()
    return {
      formatters_by_ft = require('user.langs').formatters_by_ft(),
      formatters = {
        yamlfix = {
          env = {
            YAMLFIX_WHITELINES = "2",
            YAMLFIX_SEQUENCE_STYLE = "keep_style",
            YAMLFIX_PRESERVE_QUOTES = "true",
          },
        },
      },
      format_on_save = function(bufnr)
        if format_async(bufnr) then return end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      format_after_save = function(bufnr)
        if not format_async(bufnr) then return end
        return { lsp_format = 'fallback' }
      end,
    }
  end,
}
