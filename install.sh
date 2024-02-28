#!/bin/sh

set -e -u

gh_url=https://githubraw.com/kilna/lsrc

echo "Copying lsrc script..."
mkdir -p "$HOME/.local/bin"
curl -o "$HOME/.local/bin/lsrc" -fsSL $gh_url/main/lsrc
sudo chmod 755 "$HOME/.local/bin/lsrc"

# Append USAGE from the README.md so I don't have to update in two places
curl -o "$TMPDIR/lsrc/README.md" -fsSL $gh_url/kilna/lsrc/main/README.md
output=0
while IFS='' read line; do
  case "$line" in USAGE:*) output=1;; esac
  [ "$output" -eq 0 ] && continue
  [ "$line" == '```' ] && break
  echo "$line" >>"$HOME/.local/bin/lsrc"
done <"$TMPDIR/lsrc/README.md"
rm -rf "$TMPDIR/lsrc/"

if ! [ -e "$HOME/.lsrc" ]; then
  "$HOME/.local/bin/lsrc" defaults >"$HOME/.lsrc"
fi

