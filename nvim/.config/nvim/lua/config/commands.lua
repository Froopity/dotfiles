-- Close all buffers and return cwd to ~
vim.api.nvim_create_user_command(
  'Home',
  function(_)
    vim.cmd '%bd'
    vim.cmd 'cd ~'
  end,
  {}
)
