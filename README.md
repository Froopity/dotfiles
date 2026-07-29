Clone with submodules:

```
git clone --recurse-submodules <repo>
```

(or `git submodule update --init` after a plain clone)

Install dotfile with

```
stow <unit>
```

Force override of unit with

```
stow --adopt <unit>
git restore .
```

## fish

`fish` is the base package.
`fish-wsl` adds WSL/Windows glue
`fish-work` adds work-specific tooling

```
stow fish              # any machine
stow fish fish-wsl fish-work   # work WSL box
```

After stowing, install plugins with fisher:

```
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher update
```

### Machine-local config

`conf.d/local.fish` is gitignored (in any package) and auto-sourced by fish.

<<<<<<< HEAD
## git


- `.config/git/config` common settings
- `.local/bin/git-editor` tries nvim then vim
- `.local/bin/git` uses git.exe under wsl paths

```
stow bash git
```

=======
## ripgrep

```
stow ripgrep
```

Set some default excludes like `.git`, `node_modules`, etc. Requires `RIPGREP_CONFIG_PATH` to be set (done automatically with `fish` or `bash` unit)

>>>>>>> d0457b7 (Better rg settings for hidden/gitignored files)
## nvim

External tools required:

```
ripgrep
tree-sitter-cli (requires npm)
```

Create the language config file by running `:LangSync` in nvim. Uncomment any required languages.

