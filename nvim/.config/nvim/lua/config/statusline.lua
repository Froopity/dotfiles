local M = {}

-- Filetype and attached LSP clients for the statusline's buffer, e.g. "lua · lua_ls ".
-- %{} items are evaluated with the statusline's window/buffer as current.
function M.ft_lsp()
  local buf = vim.api.nvim_get_current_buf()
  local parts = {}
  if vim.bo[buf].filetype ~= '' then
    table.insert(parts, vim.bo[buf].filetype)
  end
  local names = vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = buf }))
  if #names > 0 then
    table.insert(parts, table.concat(names, ','))
  end
  if #parts == 0 then return '' end
  local s = (table.concat(parts, ' · ') .. '  '):gsub('%%', '%%%%')
  return s
end

-- Build on 0.12's default statusline (diagnostics, progress, busy, ruler) by
-- inserting our segment at the start of the right-aligned section.
local default = vim.api.nvim_get_option_info2('statusline', {}).default
vim.o.statusline = default:gsub('%%=', "%%=%%{%% v:lua.require'config.statusline'.ft_lsp() %%}", 1)

local group = vim.api.nvim_create_augroup('user.statusline', {})

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  group = group,
  -- LspDetach fires before the client is removed, so defer the redraw
  callback = vim.schedule_wrap(function() vim.cmd.redrawstatus { bang = true } end),
})

-- LSP progress isn't forwarded to nvim's native progress messages by default.
-- Bridge it (per :h LspProgress) so the default statusline's
-- vim.ui.progress_status() and the terminal progress bar pick it up.
vim.api.nvim_create_autocmd('LspProgress', {
  group = group,
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. ev.data.params.token,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})

return M
