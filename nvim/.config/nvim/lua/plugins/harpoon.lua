return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function(_)
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>sa", function() harpoon:list():add() end)

    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon to file " .. i })
    end

    -- Telescope configuration
    local conf = require("telescope.config").values
    local function harpoon_entries()
      local entries = {}
      for i, item in ipairs(harpoon:list().items) do
        table.insert(entries, { idx = i, path = item.value })
      end
      return entries
    end

    local function harpoon_entry_maker(entry)
      return {
        value = entry.path,
        path = entry.path,
        display = string.format("%d  %s", entry.idx, entry.path),
        ordinal = entry.path,
      }
    end

    local function toggle_telescope()
      local themes = require("telescope.themes")
      local action_state = require("telescope.actions.state")
      local opts = themes.get_ivy({ layout_config = { height = 0.4 } })

      require("telescope.pickers").new(opts, {
        prompt_title = "Harpoon",
        initial_mode = "normal",
        finder = require("telescope.finders").new_table({
          results = harpoon_entries(),
          entry_maker = harpoon_entry_maker,
        }),
        previewer = conf.file_previewer(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          local delete_entry = function()
            local selection = action_state.get_selected_entry()
            harpoon:list():remove_at(selection.index)

            local current_picker = action_state.get_current_picker(prompt_bufnr)
            current_picker:refresh(require("telescope.finders").new_table({
              results = harpoon_entries(),
              entry_maker = harpoon_entry_maker,
            }))
          end

          map("n", "<M-d>", delete_entry)
          map("i", "<M-d>", delete_entry)

          return true
        end,
      }):find()
    end

    vim.keymap.set("n", "<leader>ss", toggle_telescope, { desc = "Open harpoon window" })
  end
}
