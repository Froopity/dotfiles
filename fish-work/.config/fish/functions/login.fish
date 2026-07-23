function login
    set cmd1 "aws sso login --profile onyxtech.horus.support"
    set cmd2 aws.exe sso login --profile onyxtech.horus.support

    set file_path /var/tmp/script/login-time

    if test -e $file_path
        set file_mod_time (stat -c %Y $file_path)
        set current_time (date +%s)
        set time_diff (math $current_time - $file_mod_time)

        if test $time_diff -lt 30 # 43200 = 12 hours
            fish -c $cmd1 >/dev/null & $cmd2 >/dev/null

            mkdir -p (dirname $file_path)
            touch $file_path
            return
        end
    end

    eval $cmd1 >/dev/null
    eval $cmd2 >/dev/null

    mkdir -p (dirname $file_path)
    touch $file_path
end
