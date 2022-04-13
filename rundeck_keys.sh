#!/bin/bash
# Sorry I assume you have bash, because otherwise this is a lot harder.

# set -eux
set -eu

# 2048 SHA256:h7njOUArdygRFZN8R8JRysZ5Vje57TDoszOFqW+mEtY rundeck@435cc7c0ec97 (RSA)
# 2048 SHA256:HyLeewdJH/1WAAQKixUs613XsRXbFQd6nxU6ikdmcn0 rundeck@a9408cab34cf (RSA)
# 2048 SHA256:fm4RAHs48DTFFwBTgL95wdGMeZcp7fIF5WjN015/3CA rundeck@d39a9897de35 (RSA)
# 2048 SHA256:kVLnHhPWC2vgTvOcPx+DhRL0mkhpIJloKmKQuLAOBfA rundeck@553322682a1d (RSA)
# 2048 SHA256:9NEpWJV6CD3gVnxu+SGx8kt+YO/jLi1ri6EtdRDQnMU rundeck@7ff0495cadf8 (RSA)
# 2048 SHA256:mQT8HYdan/qSNallrKhBOC6B2SJZ8NESAPR7t27rBkA rundeck@0a88c2cee02f (RSA)
# 2048 SHA256:tt14aHFVv7BKc4FABzPBrKEDYeTh9IftfrBolZ1PtrI rundeck@6ce6a554d02b (RSA)
# 3072 SHA256:096YEqlFSQn9ppaVGg5sfpt6R2Nn+eJi5k1Pb3QiIF4 rundeck@buildkitsandbox (RSA)

declare -a bad_keys
bad_keys=(SHA256:h7njOUArdygRFZN8R8JRysZ5Vje57TDoszOFqW+mEtY SHA256:HyLeewdJH/1WAAQKixUs613XsRXbFQd6nxU6ikdmcn0 SHA256:fm4RAHs48DTFFwBTgL95wdGMeZcp7fIF5WjN015/3CA SHA256:kVLnHhPWC2vgTvOcPx+DhRL0mkhpIJloKmKQuLAOBfA SHA256:9NEpWJV6CD3gVnxu+SGx8kt+YO/jLi1ri6EtdRDQnMU SHA256:mQT8HYdan/qSNallrKhBOC6B2SJZ8NESAPR7t27rBkA SHA256:tt14aHFVv7BKc4FABzPBrKEDYeTh9IftfrBolZ1PtrI SHA256:096YEqlFSQn9ppaVGg5sfpt6R2Nn+eJi5k1Pb3QiIF4)

OLDIFS="$IFS"
IFS="
"

root="/"

# If we can renice ourselves, great, no worries if not.
renice 10 $$ || true

find "$root" -iname 'authorized_keys*' -ipath '*/.ssh/*' -type f -not -empty 2>/dev/null \
    | while read -r authorized_key_file; do

    echo "Looking at keyfile: $authorized_key_file"
    echo

    # list all the keys in the file, and process them a line at a time
    # ssh-keygen -l -f "$authorized_key_file" \
    grep --extended-regexp '^ssh-' "$authorized_key_file" \
    | while read -r authorized_key_line ; do

        authorized_key="$(ssh-keygen -l -f <(echo "$authorized_key_line"))"

        # compare each authorized_key's allowed key against all the bad
        # ones
        for badkey in "${bad_keys[@]}"; do

            if echo "$authorized_key" | grep --fixed-strings --quiet "$badkey"; then
                echo "$authorized_key_file contains a bad key of:"
                echo "    $authorized_key_line"
                echo 

            fi

        done

    done

done

IFS="$OLDIFS"
