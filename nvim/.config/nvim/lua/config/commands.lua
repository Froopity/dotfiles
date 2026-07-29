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

-- Build a .rgignore from the current repo's .gitignore.
vim.api.nvim_create_user_command(
  'Rgignore',
  function(_)
    local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    if vim.v.shell_error ~= 0 or not root or root == '' then
      vim.notify('Not inside a git repository', vim.log.levels.ERROR)
      return
    end

    local rgignore = root .. '/.rgignore'
    if vim.fn.filereadable(rgignore) == 1 then
      vim.cmd('edit ' .. vim.fn.fnameescape(rgignore))
      return
    end

    local gitignore = root .. '/.gitignore'
    local lines = {}
    if vim.fn.filereadable(gitignore) == 1 then
      lines = vim.fn.readfile(gitignore)
    end

    vim.cmd('edit ' .. vim.fn.fnameescape(rgignore))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.modified = true
  end,
  {}
)
