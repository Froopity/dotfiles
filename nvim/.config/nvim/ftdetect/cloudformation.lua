vim.filetype.add({
  pattern = {
    ['.*%.ya?ml'] = {
      priority = math.huge,
      function(_, bufnr)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)) do
          if line:match('AWSTemplateFormatVersion') then
            return 'yaml.cloudformation'
          end
        end
      end,
    },
  },
})
