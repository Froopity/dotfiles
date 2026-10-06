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
    }
  end,
}
