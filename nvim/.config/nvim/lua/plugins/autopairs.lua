return {
  'windwp/nvim-autopairs',
  enabled = true,
  event = "InsertEnter",
  opts = {
    check_ts = true,
    map_cr = false, -- mapped below so <CR> can also accept completion items
    ts_config = {
      lua = { 'string' }, -- it will not add a pair on that treesitter node
      javascript = { 'template_string' },
    }
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require('nvim-autopairs.rule')
    local ts_conds = require('nvim-autopairs.ts-conds')

    npairs.setup(opts)

    -- <CR> accepts the selected completion item with <C-y>, so LSP additionalTextEdits
    -- (e.g. jdtls auto-imports) are applied. Otherwise fall through to autopairs.
    vim.keymap.set('i', '<CR>', function()
      if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
          return npairs.esc('<C-y>')
        end
        return npairs.esc('<C-e>') .. npairs.autopairs_cr()
      end
      return npairs.autopairs_cr()
    end, { expr = true, replace_keycodes = false })

    -- press % => %% only while inside a comment or string
    npairs.add_rules({
      Rule("%", "%", "lua")
          :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
      Rule("$", "$", "lua")
          :with_pair(ts_conds.is_not_ts_node({ 'function' })),
      Rule("```", "```", { "markdown", "gemtext", "gmi" }),
    })
  end
}
