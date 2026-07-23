if status is-interactive

    # Don't follow symlinks in Ctrl-T/Alt-C: Windows compat junctions under /mnt/c
    # (e.g. "Documents and Settings") loop back into the home tree otherwise.
    # OneDrive dirs are also excluded here since they're slow to walk and irrelevant.
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS,--walker-skip=OneDrive,'OneDrive - Onyx','OneDrive - Onyx Tech Pty Ltd',Onyx"

end
