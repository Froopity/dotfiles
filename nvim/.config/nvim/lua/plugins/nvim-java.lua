return {
  'nvim-java/nvim-java',
  ft = 'java',
  enabled = function()
    return require('user.langs').is_enabled('java')
  end,
}
