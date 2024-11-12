#!/bin/sh

if [ $(id -u) -ne 0 ]; then
    echo 'run as root'
    exit 1
fi

echo "upgrading flakes..."
pushd /etc/nixos/
nix flake update
popd

echo "upgrading core system...."
nixos-rebuild switch

echo "running GC..."
nix-collect-garbage -d --quiet
