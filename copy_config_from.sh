#!/bin/sh

if [ $(id -u) -ne 0 ]; then
    echo "run as root";
    exit 1;
fi

cp /etc/nixos/configuration.nix configuration.nix
cp /etc/nixos/hardware-configuration.nix hardware-configuration.nix
cp /etc/nixos/trent-pkgs.nix trent-pkgs.nix
