{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # System76
  hardware = {
    system76.enableAll = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."luks-59f57ff3-ece0-40ef-b2b8-b1821af6f8f5".device = "/dev/disk/by-uuid/59f57ff3-ece0-40ef-b2b8-b1821af6f8f5";
    };

    plymouth = {
      enable = true;
      theme = "glitch";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "glitch" ];
        })
      ];
    };
    
    # SHORT TERM HACK - need to lock on 6.12.44 - .45 is broken!
    kernelPackages = (import (builtins.fetchTarball "https://codeload.github.com/NixOS/nixpkgs/tar.gz/d0fc30899600b9b3466ddb260fd83deb486c32f1") { system = pkgs.stdenv.system; }).linuxPackages_6_12;
    kernelModules = [ "kvm-intel" ];
    blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
    extraModulePackages = [ ];

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 5;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/42cff508-013c-4a5c-8c6f-f5ef9e56a3af";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F866-9584";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
