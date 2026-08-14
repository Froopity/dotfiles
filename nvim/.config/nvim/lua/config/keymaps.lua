-- Use `jk` to exit insert mode
vim.keymap.set('i', 'jk', '<Esc>')

-- Terminal shortcut and exit with esc
-- vim.keymap.set('n', '<leader>t', ':terminal<CR>') -- Conflicts with gitsigns, not really used.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Unbind cmd-line window to stop accidental invocation. Use :<C-f> to open.
vim.keymap.set('n', 'q:', '<nop>')

-- Set cwd to current file
vim.keymap.set('n', '<leader>gd', ':cd %:h<CR>', { desc = 'Set cwd to current file' })

-- Use alt-j/k to navigate QuickFix menu
vim.keymap.set('n', '<A-j>', ':cnext<CR>')
vim.keymap.set('n', '<A-k>', ':cprevious<CR>')

-- Tab/Shift-Tab to select the next/previous completion match, same as C-n/C-p
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })

-- Keep Up/Down as command-line history recall even while the wildmenu pum is open
vim.keymap.set('c', '<Up>', function()
  return vim.fn.wildmenumode() == 1 and '<C-e><Up>' or '<Up>'
end, { expr = true })
vim.keymap.set('c', '<Down>', function()
  return vim.fn.wildmenumode() == 1 and '<C-e><Down>' or '<Down>'
end, { expr = true })

-- Select the last pasted text
vim.keymap.set('n', 'gp', "'[v`]", { desc = "Select last pasted text" })

-- Quick replace with automatic escaping
vim.keymap.set('x', '<leader>rr', [["fy:s/\V<C-r>=escape(@f, '/\')<CR>/]])
vim.keymap.set('x', '<leader>ra', [["fy:%s/\V<C-r>=escape(@f, '/\')<CR>/]])

-- Paste unnamed register in insert mode
vim.keymap.set({ 'c', 'i' }, '<C-g>', '<C-r>"', { desc = 'Paste latest yank' })

-- Enter empty lines without switching to insert mode
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<S-CR>', 'm`O<Esc>``')
vim.api.nvim_create_autocmd("FileType", { -- Unmap enter when in QuickFix
  pattern = "qf,minifiles",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
  end,
})

-- Actions on entire buffer
vim.keymap.set('n', ' ya', "mqggyG'q", { desc = "Yank entire buffer" })
vim.keymap.set('n', ' da', 'gg"_dG', { desc = "Delete entire buffer without yanking" })
vim.keymap.set('n', ' gqa', "mqgggqG'q", { desc = "Format entire buffer" })

-- LSP keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error under cursor' })
vim.keymap.set('i', '<C-Space>', function() vim.lsp.completion.get() end, { desc = 'Trigger LSP completion' })
vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = 'Go to definition' })

-- Misc
vim.keymap.set('n', '<leader><ESC>', ':nohlsearch<CR>', { silent = true, desc = 'Remove search highlights' })

vim.keymap.set('n', '<leader>wm', [[:%s/\r//g<CR>]], { silent = true, desc = 'Strip ^M from buffer' })

-- Mouse: disable click/drag actions, keep scroll wheel, right click pastes without moving the cursor
for _, key in ipairs({
  '<LeftMouse>', '<LeftDrag>', '<LeftRelease>', '<2-LeftMouse>', '<3-LeftMouse>', '<4-LeftMouse>',
  '<MiddleMouse>', '<MiddleDrag>', '<MiddleRelease>',
  '<RightDrag>', '<RightRelease>', '<2-RightMouse>', '<3-RightMouse>', '<4-RightMouse>',
}) do
  vim.keymap.set({ 'n', 'v', 'i' }, key, '<Nop>')
end

vim.keymap.set({ 'n', 'v' }, '<RightMouse>', '"+p', { desc = 'Right click to paste' })
vim.keymap.set('i', '<RightMouse>', '<C-r>+', { desc = 'Right click to paste' })

-- Remove items from quickfix list.
-- `d` to delete Visual selection
local function delete_qf_items()
  local mode = vim.api.nvim_get_mode()['mode']

  local start_idx
  local count

  if mode == 'n' then
    -- Normal mode
    start_idx = vim.fn.line('.')
    count = vim.v.count > 0 and vim.v.count or 1
  else
    -- Visual mode
    local v_start_idx = vim.fn.line('v')
    local v_end_idx = vim.fn.line('.')

    start_idx = math.min(v_start_idx, v_end_idx)
    count = math.abs(v_end_idx - v_start_idx) + 1

    -- Go back to normal
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(
        '<esc>',         -- what to escape
        true,            -- Vim leftovers
        false,           -- Also replace `<lt>`?
        true             -- Replace keycodes (like `<esc>`)?
      ),
      'x',               -- Mode flag
      false              -- Should be false, since we already `nvim_replace_termcodes()`
    )
  end

  local qflist = vim.fn.getqflist()

  for _ = 1, count, 1 do
    table.remove(qflist, start_idx)
  end

  vim.fn.setqflist(qflist, 'r')
  vim.fn.cursor(start_idx, 1)
end

vim.api.nvim_create_autocmd('FileType', {
  group = custom_group,
  pattern = 'qf',
  callback = function()
    -- Do not show quickfix in buffer lists.
    vim.api.nvim_buf_set_option(0, 'buflisted', false)

    -- Escape closes quickfix window.
    vim.keymap.set(
      'n',
      '<ESC>',
      '<CMD>cclose<CR>',
      { buffer = true, remap = false, silent = true }
    )

    -- `dd` deletes an item from the list.
    vim.keymap.set('n', 'dd', delete_qf_items, { buffer = true })
    vim.keymap.set('x', 'd', delete_qf_items, { buffer = true })
  end,
  desc = 'Quickfix tweaks',
})
