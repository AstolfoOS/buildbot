#!/bin/bash

set -e
[ "$DEBUG" = true ] && set -o xtrace

if [ "$SIGN" = true ]; then
  true
  MKARCHISO_ARGS=(-g "$KEYID")
fi

doas chown -R buildbot /buildbot/{iso,iso-src}

if ! [ -d /buildbot/iso-src/.git ]; then
  git clone "$ISO_URL" /buildbot/iso-src
else
  pushd /buildbot/iso-src > /dev/null
  git pull
  popd > /dev/null
fi
cd /buildbot/iso-src

doas mkarchiso "${MKARCHISO_ARGS[@]}" -v -o /buildbot/tmp/iso-out -w /buildbot/tmp/iso .
isoname=$(basename /buildbot/tmp/iso-out/*.iso)
rm -f /buildbot/iso/*
cp /buildbot/tmp/iso-out/* /buildbot/iso/
[ "$SIGN" = true ] && gpg --detach-sign "/buildbot/iso/$isoname"
doas rm -rf /buildbot/tmp/iso{,-out}
doas chown buildbot /buildbot/iso/*
mktorrent -w "$ISO_WEB/$isoname" "/buildbot/iso/$isoname" -o "/buildbot/iso/$isoname.torrent"
