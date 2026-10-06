-- AWSTemplateFormatVersion is optional (SAM templates and many hand-written
-- ones omit it) and can sit below a long header comment, so also look for
-- the SAM transform or any `Type: AWS::Service::Resource` line.
local markers = {
  '^AWSTemplateFormatVersion%s*:',
  '^Transform%s*:%s*[\'"]?AWS::',
  '^%s+Type%s*:%s*[\'"]?AWS::%w+::%w+',
}

vim.filetype.add({
  pattern = {
    ['.*%.ya?ml'] = {
      function(_, bufnr)
        if not bufnr then return end
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
          for _, marker in ipairs(markers) do
            if line:match(marker) then return 'yaml.cloudformation' end
          end
        end
      end,
      { priority = math.huge },
    },
  },
})
