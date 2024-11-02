#!/bin/sh

if [ $(id -u) -ne 0 ]; then
    echo "run as root";
    exit 1;
fi

cp configuration.nix /etc/nixos/configuration.nix
