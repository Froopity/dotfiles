# Auto-picks git.exe under Windows-mounted paths (/mnt/*), otherwise native git
function g
    if string match -q '/mnt/*' -- $PWD
        git.exe $argv
    else
        /usr/bin/git $argv
    end
end
