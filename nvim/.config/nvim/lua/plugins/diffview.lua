return {
  'dlyongemallo/diffview-plus.nvim',
  version = "*",
  opts = {
    view = {
      -- Configure the layout and behavior of different types of views.
      merge_tool = {
        -- Config for conflicted files in diff views during a merge or rebase.
        layout = 'diff3_mixed',
      },
    },
  },
  keys = {
    {
      '<leader>hh',
      function()
        if next(require('diffview.lib').views) == nil then
          vim.cmd('DiffviewOpen')
        else
          vim.cmd('DiffviewClose')
        end
      end,
      desc = 'Toggle Diffview'
    },
    { '<leader>hm', '<cmd>DiffviewOpen main..HEAD<CR>', desc = 'Diff from main' },
    { '<leader>hf', '<cmd>DiffviewFileHistory %',       desc = 'Current file history' },
  },
}
