#!/bin/bash

get_pkgbuild_version() {
  pkgver=$(grep -Eo 'pkgver=.*' "$1/PKGBUILD" | cut -d '=' -f 2)
  pkgrel=$(grep -Eo 'pkgrel=.*' "$1/PKGBUILD" | cut -d '=' -f 2)
  echo "$pkgver-$pkgrel"
}

get_repo_version() {
  pkgdesc=$(tar -tf "/buildbot/repo/$REPO_NAME.db.tar.zst" | grep -Eo "$1-.+/desc")
  pkgver=$(tar -xOf "/buildbot/repo/$REPO_NAME.db.tar.zst" "$pkgdesc" | sed -n '/^%VERSION%$/ {n;p;q}')
  echo "$pkgver"
}

set -e

doas chown -R buildbot /buildbot/{packages,repo,tmp}

doas pacman -Syu

if ! [ -d /buildbot/packages/.git ]; then
  git clone "$REPO_URL" /buildbot/packages
else
  pushd /buildbot/packages > /dev/null
  git pull
  popd > /dev/null
fi
cd /buildbot/packages

for i in *; do
  if [ -f "/buildbot/repo/$REPO_NAME.db.tar.zst" ]; then
    pkgbuildver=$(get_pkgbuild_version "$i")
    repover=$(get_repo_version "$i")
    if (( $(vercmp "$pkgbuildver" "$repover") <= 0 )); then
      echo "$i does not need to be rebuilt"
      continue
    fi
  fi

  tmpdir="/buildbot/tmp/$i"
  cp -r "$i" "$tmpdir"

  pushd "$tmpdir" > /dev/null

  echo "Building $i in $tmpdir"
  makepkg -srcf --noconfirm

  # Remove the old package
  rm "/buildbot/repo/$i-"*".pkg.tar.zst" || true # ignore errors

  # Add the new package
  cp "./$i-"*".pkg.tar.zst" /buildbot/repo
  repo-add -R "/buildbot/repo/$REPO_NAME.db.tar.zst" "/buildbot/repo/$i-"*".pkg.tar.zst"
  
  popd > /dev/null

  rm -rf "$tmpdir"
done