#!/bin/sh
export PATH=/usr/local/bin/:$PATH

git remote update 1>/dev/null

LOCAL=$(git rev-parse @{0})
REMOTE=$(git rev-parse @{u})

if [ $LOCAL != $REMOTE ]; then
    git pull
    PATH="/usr/local/bin:$PATH" make COQWEB=/var/deploy/coq-www all
fi
