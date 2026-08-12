return {
  'sindrets/diffview.nvim',
  opts = {
    view = {
      -- Configure the layout and behavior of different types of views.
      merge_tool = {
        -- Config for conflicted files in diff views during a merge or rebase.
        layout = "diff3_mixed",
      },
    },
  },
}

