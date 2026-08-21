Clone with submodules:

```
git clone --recurse-submodules <repo>

# Submodules won't be automatically pulled again unless you set this
git config submodule.recurse true

# Or run this
git submodule update --init --recursive
```

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

## git

- `.config/git/config` common settings
- `.local/bin/git-editor` tries nvim then vim
- `.local/bin/git` uses git.exe under wsl paths

```
stow bash git
```

## ripgrep

```
stow ripgrep
```

Set some default excludes like `.git`, `node_modules`, etc. Requires `RIPGREP_CONFIG_PATH` to be set (done automatically with `fish` or `bash` unit)

## nvim

External tools required:

```
ripgrep
tree-sitter-cli (requires npm)
```

Create the language config file by running `:LangSync` in nvim. Uncomment any required languages.

