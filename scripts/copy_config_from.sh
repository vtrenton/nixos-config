#!/bin/sh

rsync -a --delete --exclude='.git' --exclude='README.md' --exclude='.gitignore' \
  /etc/nixos/ "$HOME/Source/nixos-config/"
git -C "$HOME/Source/nixos-config" status --short
