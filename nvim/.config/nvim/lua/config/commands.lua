-- Close all buffers and return cwd to ~
vim.api.nvim_create_user_command(
  'Home',
  function(_)
    vim.cmd '%bd'
    vim.cmd 'cd ~'
  end,
  {}
)

-- Regenerate local_langs.lua from user/languages.lua, keeping existing
-- selections and adding any newly-registered languages as commented options.
vim.api.nvim_create_user_command(
  'LangsSync',
  function(_)
    local path = require('user.langs').sync_local_langs()
    vim.notify('Wrote ' .. path .. ' — restart nvim after editing it', vim.log.levels.INFO)
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
  end,
  {}
)
