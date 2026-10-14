vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local build_file = vim.fs.find({ "build.gradle", "build.gradle.kts", "settings.gradle" },
      { upward = true, limit = 1 })
    if #build_file > 0 then
      local root = vim.fs.dirname(build_file[1])
      local gradlew = root .. "/gradlew"
      vim.bo.makeprg = vim.fn.filereadable(gradlew) == 1 and gradlew or "gradle"
      vim.bo.errorformat = "%E%f:%l: error: %m,%E%f:%l: %m,%-C%p^,%-G%.%#"
    end
  end,
})
