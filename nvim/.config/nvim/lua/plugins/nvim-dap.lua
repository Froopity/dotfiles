return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    require('mason-nvim-dap').setup({
      ensure_installed = { 'python' },
      automatic_installation = true,
      handlers = {},
    })

    require('nvim-dap-virtual-text').setup()
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end

    -- Adapter always uses mason's debugpy (which has debugpy installed).
    -- Never use the project venv here — it won't have debugpy.
    dap.adapters.python = {
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
      args = { '-m', 'debugpy.adapter' },
    }

    -- pythonPath is a function so it resolves fresh per-session, picking up
    -- whichever uv venv is active for the current project.
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

    dap.configurations.python = {
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
    }

    local map = vim.keymap.set
    map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Toggle breakpoint' })
    map('n', '<leader>dc', dap.continue, { desc = 'DAP: Continue' })
    map('n', '<leader>ds', dap.step_over, { desc = 'DAP: Step over' })
    map('n', '<leader>di', dap.step_into, { desc = 'DAP: Step into' })
    map('n', '<leader>do', dap.step_out, { desc = 'DAP: Step out' })
    map('n', '<leader>dq', dap.terminate, { desc = 'DAP: Terminate' })
    map('n', '<leader>du', dapui.toggle, { desc = 'DAP: Toggle UI' })
    map('n', '<leader>dr', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
    map('n', '<leader>dl', dap.run_last, { desc = 'DAP: Re-run last' })
    map('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input('Condition: '))
    end, { desc = 'DAP: Conditional breakpoint' })
  end,
}
