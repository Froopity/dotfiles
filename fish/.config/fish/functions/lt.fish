function lt
    if string match -qr '^-?[0-9]+(\.?[0-9]*)?$' -- "$argv[1]"
        ls --tree --level $argv
    else
        ls --tree --level 2 $argv
    end
end
