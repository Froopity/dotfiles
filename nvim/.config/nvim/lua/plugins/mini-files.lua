return {
  'nvim-mini/mini.files',
  version = '*',
  opts = {
    options = {
      permanent_delete = false,
    },
    windows = {
      preview = true,
      width_preview = 30,
    },
    mappings = {
      go_in_plus = 'L', -- Always close explorer when opening file
      go_out = 'H',     -- Use `H` isntead of `h`/`l` to make cursor movement easier
      go_in = '',
      go_out_plus = '',
    }
  },
  keys = {
    { "<leader>oo", "<CMD>e .<CR>",              desc = "Open MiniFiles" },
    { "<leader>on", "<CMD>e ~/.config/nvim<CR>", desc = "Open MiniFiles" },
    { "-", function()
      local minifiles = require('mini.files')
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      minifiles.open(path)
      minifiles.reveal_cwd()
    end, { desc = "Open Mini Files" } },
  },
  config = function(_, opts)
    local minifiles = require("mini.files")
    minifiles.setup(opts)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id

        -- Function to open the file under cursor as a vertical diffsplit
        local diff_vsplit = function()
          local entry = minifiles.get_fs_entry()

          -- Only proceed if it's a file
          if entry == nil or entry.fs_type == 'directory' then
            return
          end

          -- Close the explorer before opening the split
          minifiles.close()
          vim.cmd('vert diffsplit ' .. entry.path)
        end

        vim.keymap.set('n', '<C-s>', diff_vsplit, { buffer = buf_id, desc = 'Vertical diffsplit' })

        local set_cwd = function()
          local entry = minifiles.get_fs_entry()
          if entry == nil then return end
          local dir = entry.fs_type == 'directory' and entry.path or vim.fn.fnamemodify(entry.path, ':h')
          minifiles.close()
          vim.fn.chdir(dir)
        end

        vim.keymap.set('n', 'gd', set_cwd, { buffer = buf_id, desc = 'Set cwd to entry' })
        vim.keymap.set('n', '<Esc>', minifiles.close, { buffer = buf_id, desc = 'Close MiniFiles' })
      end,
    })
  end
}
