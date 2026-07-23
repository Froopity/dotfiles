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
