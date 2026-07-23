return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
  config = function()
    require('mason').setup()

    local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
    if not vim.env.PATH:find(mason_bin, 1, true) then
      vim.env.PATH = mason_bin .. ':' .. vim.env.PATH
    end

    local ok, servers = pcall(require, 'user.local_lsp')
    if not ok then
      vim.notify('LSP: failed to load user.local_lsp: ' .. servers, vim.log.levels.ERROR)
      return
    end

    local _, custom_servers = pcall(require, 'user.local_lsp_custom')
    if type(custom_servers) ~= 'table' then custom_servers = {} end

    require('mason-lspconfig').setup({ ensure_installed = servers })

    for _, name in ipairs(vim.list_extend(vim.deepcopy(servers), custom_servers)) do
      local found, config = pcall(require, 'lsp.' .. name)
      vim.lsp.config(name, found and config or {})
      local enabled, err = pcall(vim.lsp.enable, name)
      if not enabled then
        vim.notify('LSP: ' .. name .. ': ' .. err, vim.log.levels.ERROR)
      end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client:supports_method('textDocument/completion') then return end

        local cp = client.server_capabilities.completionProvider
        if cp then
          local word_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
          local set = {}
          for _, c in ipairs(cp.triggerCharacters or {}) do set[c] = true end
          for i = 1, #word_chars do set[word_chars:sub(i, i)] = true end
          cp.triggerCharacters = vim.tbl_keys(set)
        end

        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end,
    })

  end,
}
