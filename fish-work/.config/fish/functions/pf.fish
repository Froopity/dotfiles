function pf --no-scope-shadowing
    set -l second_arg
    if test (count $argv) -lt 2
        set second_arg (test "$argv[1]" = "sandbox" && echo "admin" || echo "support")
    else
        set second_arg (test "$argv[2]" = "infra" && echo "infrastructure-manager" || echo $argv[2])
    end
    echo onyxtech.$argv[1].$second_arg
end
