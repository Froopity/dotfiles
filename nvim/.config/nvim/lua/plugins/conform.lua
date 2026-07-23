return {
  'stevearc/conform.nvim',
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff" },
      fish = { "fish_indent" },
      html = { "html_beautify" },
      markdown = { "markdownfmt" },
      bash = { "shellcheck" },
      yaml = { "yamlfix" },
    },
    format_on_save = function(bufnr)
      if vim.bo[bufnr].filetype == 'yaml.cloudformation' then return end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
}
