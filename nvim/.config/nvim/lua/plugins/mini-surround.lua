return {
  "nvim-mini/mini.surround",
  event = "VeryLazy",
  version = false,
  opts = {
    custom_surroundings = {
      -- Invert brackets: ( for no space, ) for space
      ['('] = { output = { left = '(', right = ')' } },
      [')'] = { output = { left = '( ', right = ' )' } },
      ['['] = { output = { left = '[', right = ']' } },
      [']'] = { output = { left = '[ ', right = ' ]' } },
      ['{'] = { output = { left = '{', right = '}' } },
      ['}'] = { output = { left = '{ ', right = ' }' } },
    }
  },
}
