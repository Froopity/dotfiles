vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require("config.commands")
require("config.keymaps")
require("config.lazy")
require("config.options")

if vim.g.neovide then
  require("config.neovide")
end
