#!/bin/bash

gpm() {
    git add -A;
    git commit -m "auto update";
    git push origin main;
    echo "updated to origin main";
}

function gds() {
  local tmpfile
  tmpfile=$(mktemp)
  git ls-files > "$tmpfile"
  tree --fromfile "$tmpfile"
  rm "$tmpfile"
}
