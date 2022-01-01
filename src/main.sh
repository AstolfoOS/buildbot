#!/bin/bash

set -e
[ "$DEBUG" = true ] && set -o xtrace


if [ "$SIGN" = true ]; then
  gpg --import key.asc
  doas gpg --import key.asc # Also import for the root user, required for the ISO
  KEYID=$(gpg --list-secret-keys | head -4 | tail -1)
  export KEYID
  doas pacman-key --init
  doas pacman-key --recv-key "$KEYID"
  doas pacman-key --lsign-key "$KEYID"
fi

count=0

while true; do
  if ! { jobs | grep -Eo 'Running.+repo.sh' > /dev/null; }; then
    # If there are no running repo.sh jobs, then run one.
    # This is done so that if repo.sh takes longer than 1 hour, it isn't started twice.
    [ "$BUILD_REPO" = true ] && bash /buildbot/src/repo.sh &
  fi

  if [ $count -eq 0 ]; then
    [ "$BUILD_ISO" = true ] && bash /buildbot/src/iso.sh &
    count=720 # 30 days in hours
  fi

  (( count-- ))

  sleep 3600 # 1 hour
done
