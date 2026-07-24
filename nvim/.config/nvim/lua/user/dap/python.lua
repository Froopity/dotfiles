local function resolve_python()
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. '/bin/python'
  end
  local venv = vim.fn.finddir('.venv', vim.fn.getcwd() .. ';')
  if venv ~= '' then
    return vim.fn.fnamemodify(venv, ':p') .. 'bin/python'
  end
  return 'python'
end

return {
  -- Adapter always uses mason's debugpy (which has debugpy installed).
  -- Never use the project venv here — it won't have debugpy.
  adapter = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
    args = { '-m', 'debugpy.adapter' },
  },
  -- pythonPath is a function so it resolves fresh per-session, picking up
  -- whichever uv venv is active for the current project.
  configurations = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = resolve_python,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file with args',
      program = '${file}',
      args = function()
        return vim.split(vim.fn.input('Args: '), ' ', { trimempty = true })
      end,
      pythonPath = resolve_python,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Launch module',
      module = function() return vim.fn.input('Module: ') end,
      pythonPath = resolve_python,
    },
  },
}
