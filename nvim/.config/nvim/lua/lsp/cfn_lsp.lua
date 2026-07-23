return {
  cmd = {
    'node',
    vim.fn.expand('~/.local/share/cfn-lsp/cfn-lsp-server-standalone.js'),
    '--stdio',
  },
  filetypes = { 'yaml.cloudformation' },
  root_markers = { '.git' },
  init_options = {
    aws = {
      clientInfo = {
        extension = {
          name = 'neovim',
          version = vim.version().major .. '.' .. vim.version().minor,
        },
        clientId = vim.fn.hostname(),
      },
      telemetryEnabled = false,
    },
  },
}
