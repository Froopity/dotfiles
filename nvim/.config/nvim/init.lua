vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require("config.commands")
require("config.keymaps")
require("config.lazy")
require("config.options")
require("config.statusline")
require("config.gradle-make")
require("config.horus-aws-toolkit")

if vim.g.neovide then
  require("config.neovide")
end
