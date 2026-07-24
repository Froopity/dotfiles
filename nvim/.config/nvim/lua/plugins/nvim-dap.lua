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

    local dap_langs = require('user.langs').dap_langs()
    local mason_names = {}
    for _, lang in ipairs(dap_langs) do table.insert(mason_names, lang.name) end

    require('mason-nvim-dap').setup({
      ensure_installed = mason_names,
      automatic_installation = true,
      handlers = {},
    })

    require('nvim-dap-virtual-text').setup()
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end

    for _, lang in ipairs(dap_langs) do
      local found, cfg = pcall(require, 'user.dap.' .. lang.key)
      if found then
        dap.adapters[lang.name] = cfg.adapter
        dap.configurations[lang.key] = cfg.configurations
      end
    end

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
