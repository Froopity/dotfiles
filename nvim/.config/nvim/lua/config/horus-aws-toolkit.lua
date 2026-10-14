-- Buffer-local :Hc for the horus-aws-toolkit repo only.
-- Launches toolkit.hc under nvim-dap with whatever arguments follow the command.

local project_name = 'horus-aws-toolkit'

local function project_root(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  local found = vim.fs.find(function(entry, dir)
    return entry == 'hc.py'
      and vim.fs.basename(dir) == 'toolkit'
      and vim.fs.basename(vim.fs.dirname(dir)) == project_name
  end, { upward = true, path = vim.fn.fnamemodify(name, ':p:h'), type = 'file' })
  if not found[1] then
    return nil
  end
  return vim.fs.dirname(vim.fs.dirname(found[1]))
end

local group = vim.api.nvim_create_augroup('horus-aws-toolkit', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(args)
    if vim.b[args.buf].horus_aws_toolkit_hc then
      return
    end
    local root = project_root(args.buf)
    if not root then
      return
    end
    vim.b[args.buf].horus_aws_toolkit_hc = true
    vim.api.nvim_buf_create_user_command(args.buf, 'Hc', function(cmd)
      local python = root .. '/.venv/bin/python'
      if vim.fn.executable(python) ~= 1 then
        vim.notify('Missing ' .. python, vim.log.levels.ERROR)
        return
      end
      require('lazy').load({ plugins = { 'nvim-dap' } })
      require('dap').run({
        type = 'python',
        request = 'launch',
        name = 'hc',
        module = 'toolkit.hc',
        cwd = root,
        args = cmd.fargs,
        pythonPath = python,
      })
    end, {
      nargs = '*',
      desc = 'Debug horus-aws-toolkit: hc <args>',
    })
  end,
})
