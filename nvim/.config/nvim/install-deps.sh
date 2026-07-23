#!/bin/bash

sudo apt install ripgrep fd-find build-essential
ln -s "$(which fdfind)" ~/.local/bin/fd
sudo apt install build-essential

brew install zoxide
