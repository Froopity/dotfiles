local function snacks_scratch_telescope()
  local scratch = require("snacks").scratch
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local themes = require("telescope.themes")

  local items = scratch.list()

  -- Sort by modification time (newest first)
  table.sort(items, function(a, b)
    return a.stat.mtime.sec > b.stat.mtime.sec
  end)

  -- Dropdown appearance, but vertical with preview on top
  local opts = themes.get_dropdown({
    border = true,
    previewer = true,
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
      mirror = true, -- Flips layout: Preview moves to the top
      width = 0.8,
      height = 0.9,
      preview_cutoff = 1,
      anchor = "N",
    },
  })

  pickers.new(opts, {
    prompt_title = "Snacks Scratch Context",
    finder = finders.new_table({
      results = items,
      entry_maker = function(entry)
        local pretty_path = vim.fn.fnamemodify(entry.cwd, ":p:~:.")
        local branch = entry.branch or "global"
        local icon = entry.icon or "󰈚"

        -- Icon, Path, and Branch
        local display_str = string.format("%s  %-30s  [%s]", icon, pretty_path, branch)

        return {
          value = entry,
          display = display_str,
          ordinal = pretty_path .. " " .. branch,
          path = entry.file, -- Used by the previewer
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        scratch.open({
          file = selection.value.file,
          name = selection.value.name,
          ft = selection.value.ft,
        })
      end)
      return true
    end,
  }):find()
end

local diff_vsplit = function(prompt_bufnr)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local selection = action_state.get_selected_entry()
  -- Fallback logic to find the best path string
  local path = selection.path or selection.value or selection[1]

  -- Close telescope first to return focus to the original buffer
  actions.close(prompt_bufnr)

  if path then
    -- Use fnameescape to handle spaces/special chars in the path
    vim.cmd("vert diffsplit " .. vim.fn.fnameescape(path))
  else
    vim.notify("Could not find path for selection", vim.log.levels.ERROR)
  end
end

return {
  'nvim-telescope/telescope.nvim',
  version = '*', -- Recommended for Neovim 0.11+ compatibility
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons', -- Optional: for file icons
  },
  keys = {
    "<leader>fr", "<leader>ff", "<leader>fb", "<leader>fg", "<leader>fG",
    "<leader>fh", "<leader>fn", "<leader>fd", "<leader>flr", "<leader>fls",
    "<leader>fs",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")
    telescope.setup({
      defaults = {
        path_display = { "filename_first" },
        file_ignore_patterns = { "%.git/" }, -- Use %. to escape the dot in Lua patterns
        sorting_strategy = "ascending",
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            mirror = true,
            prompt_position = "top",
            preview_height = 0.3,
          },
        },
        history = {
          path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
          limit = 100,
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
            ["<C-s>"] = diff_vsplit,
            ["<C-t>"] = action_layout.toggle_preview,
          },
          n = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
            ["<C-s>"] = diff_vsplit,
            ["<C-t>"] = action_layout.toggle_preview,
          },
        },
      },
      pickers = {
        find_files = {
          -- no_ignore = true,
          hidden = true,
          follow = true,
        },
        live_grep = {
          additional_args = function()
            return { "--follow" }
          end
        },
        buffers = {
          initial_mode = "normal",
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<M-d>"] = actions.delete_buffer,
            },
            n = {
              ["<M-d>"] = actions.delete_buffer,
            },
          },
        },
        diagnostics = {
          initial_mode = "normal",
        },
      },
      extensions = {
        ["zoxide"] = {},
        ["smart_history"] = {},
      }
    })

    -- Load the fzf extension for better sorting performance
    telescope.load_extension("fzf")

    -- Load the yank history plugin from yanky
    telescope.load_extension("yank_history")

    -- Keymaps
    local builtin = require('telescope.builtin')
    local menufacture = require('telescope').extensions.menufacture

    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Telescope session list' })
    vim.keymap.set('n', '<leader>ff', menufacture.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fg', menufacture.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fG', builtin.current_buffer_fuzzy_find, { desc = 'Telescope live buffer fuzzy' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files({ cwd = vim.fn.expand('~/.config/nvim') })
    end, { desc = 'Telescope find nvim files' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
    vim.keymap.set('n', '<leader>flr', builtin.lsp_references, { desc = 'Telescope LSP references' })
    vim.keymap.set('n', '<leader>fls', builtin.lsp_document_symbols, { desc = 'Telescope document symbols' })


    vim.keymap.set("n", "<leader>fs", snacks_scratch_telescope, { desc = "Telescope Snacks Scratch" })
  end
}
