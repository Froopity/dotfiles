return {
  url = "https://git.sr.ht/~k1nkreet/gemivim",
  event = "VeryLazy",
  keys = {
    { "<leader>gx",  "0w:GemivimGX<CR>",              desc = "Follow Gemini link" },
    { "<leader>go",  ":GemivimOpen<CR>",              desc = "Prompt for Gemini link" },
    { "<leader>gp",  ":GemivimOpen<CR><C-R>0<CR>",    desc = "Open Gemini link in register 0" },
    { "<leader>gba", ":GemivimAddBookmark<CR>",       desc = "Bookmark current url" },
    { "<leader>gbc", ":GemivimAddCursorBookmark<CR>", desc = "Bookmark url under cursor" },
    { "<leader>gbb", ":GemivimOpenBookmark<CR>",      desc = "View current bookmarks" },
  },
}
