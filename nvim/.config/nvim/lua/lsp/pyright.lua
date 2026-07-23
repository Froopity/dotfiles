return {
  settings = {
    python = { analysis = { autoSearchPaths = true } },
  },
  -- on_init = function(client)
  --   local venv = vim.fn.getcwd() .. '/.venv'
  --   if vim.env.VIRTUAL_ENV then
  --     client.config.settings.python.pythonPath = vim.env.VIRTUAL_ENV .. '/bin/python'
  --   elseif vim.fn.executable(venv .. '/bin/python') == 1 then
  --     client.config.settings.python.pythonPath = venv .. '/bin/python'
  --   end
  -- end,
}
