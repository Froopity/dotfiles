function cdw
    if test (count $argv) -lt 1
        cd /mnt/c/work
    else
        cd /mnt/c/work/$argv
    end
end
