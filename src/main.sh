#!/bin/bash

set -e
[ "$DEBUG" = true ] && set -o xtrace

while true; do
  if ! { jobs | grep -Eo 'Running.+repo.sh' > /dev/null; }; then
    # If there are no running repo.sh jobs, then run one.
    # This is done so that if repo.sh takes longer than 1 hour, it isn't started twice.
    bash /buildbot/src/repo.sh &
  fi

  sleep 3600 # 1 hour
done