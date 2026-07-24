-- Shared registry of language bundles. Checked into git — add new languages
-- here. Toggle which ones are active per-machine in local_langs.lua (copy
-- local_langs.lua.example to get started).
--
-- Fields per language, all optional except lsp:
--   lsp        mason-lspconfig server names to install/enable
--   filetypes  vim filetypes this language's tooling applies to
--   treesitter parser name(s) to install (may differ from filetypes, e.g. bash/sh)
--   formatters conform.nvim formatters_by_ft entries, keyed by filetype
--   dap        mason-nvim-dap package name; paired with user/dap/<lang>.lua
--              for the adapter + configurations, if that file exists
return {
  bash = {
    lsp = { "bashls" },
    filetypes = { "bash", "sh" },
    treesitter = { "bash" },
    formatters = { bash = { "shellcheck" } },
  },
  css = {
    lsp = { "cssls" },
    filetypes = { "css" },
  },
  docker = {
    lsp = { "dockerls" },
    filetypes = { "dockerfile" },
  },
  fish = {
    lsp = { "fish_lsp" },
    filetypes = { "fish" },
    treesitter = { "fish" },
    formatters = { fish = { "fish_indent" } },
  },
  html = {
    lsp = { "html" },
    filetypes = { "html" },
    formatters = { html = { "html_beautify" } },
  },
  json = {
    lsp = { "jsonls" },
    filetypes = { "json" },
  },
  lua = {
    lsp = { "lua_ls" },
    filetypes = { "lua" },
    treesitter = { "lua" },
    formatters = { lua = { "stylua" } },
  },
  markdown = {
    lsp = { "marksman" },
    filetypes = { "markdown" },
    treesitter = { "markdown" },
    formatters = { markdown = { "markdownfmt" } },
  },
  python = {
    lsp = { "pyright", "ruff" },
    filetypes = { "python" },
    treesitter = { "python" },
    formatters = { python = { "ruff" } },
    dap = "python",
  },
  sql = {
    lsp = { "sqlls" },
    filetypes = { "sql" },
  },
  yaml = {
    lsp = { "yamlls" },
    filetypes = { "yaml" },
    formatters = { yaml = { "yamlfix" } },
  },
  java = {
    -- lsp and debugging are handled entirely by nvim-java itself (jdtls +
    -- the debug adapter are installed and wired up by the plugin), not
    -- through mason-lspconfig/mason-nvim-dap — see plugins/nvim-java.lua.
    filetypes = { "java" },
    treesitter = { "java" },
  },
  -- typescript = {
  --   lsp = { "ts_ls", "eslint" },
  --   filetypes = { "typescript", "javascript" },
  -- },
}
