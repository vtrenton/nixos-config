{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "cerberus"; # Define your hostname.
    useDHCP = lib.mkDefault true; # Default to DHCP on all interfaces
    # interfaces.enp0s13f0u1u3.useDHCP = lib.mkDefault true;
    # interfaces.wlp46s0.useDHCP = lib.mkDefault true;
    firewall.enable = false;
    
    networkmanager = { 
      enable = true;
      settings = {
        keyfile = {
          unmanaged-devices = "interface-name:mon-*";
        };
      };
    };

    hosts = {
      "10.10.11.74" = ["artificial.htb"];
      "10.10.11.77" = ["outbound.htb" "mail.outbound.htb"];
      "10.10.11.80" = ["editor.htb" "wiki.editor.htb"];
    };
  };
 
  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.trent = {
    isNormalUser = true;
    description = "Trent V";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "wireshark" "dialout" ];
    packages = import ./trent-pkgs.nix { inherit pkgs; };
  };

  # System level configuration
  environment = {
    # system level environment variables
    variables = {
      EDITOR = "vim";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      vim
      emacs
      htop
      file
      dig
      lsof
      whois
      netcat-openbsd
      traceroute
      minicom
      wget
      rsync
      wl-clipboard
      lm_sensors
      dmidecode
      lshw
      binutils
      usbutils
      pciutils
      iw
      gnupg
      openconnect
      lxqt.lxqt-policykit
      networkmanager-openconnect
      pinentry-tty
      git
      git-lfs
    ];
  };
  
  # override values in broken packages
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    # Override the arg that bolt-launcher uses internally
  #    bolt-launcher = prev.bolt-launcher.override {
  #      fetchFromGitHub = args:
  #        if ((args.owner or "") == "AdamCake"
  #         && (args.repo  or "") == "bolt"
  #         && (args.tag   or "") == "0.19.0")  # match your snippet
  #        then prev.fetchFromGitHub (args // {
  #          hash = "sha256-0ROwETpIa0j7gRhvLMFI9Sz2HEsAuUkQGg0jZef6o/g=";
  #        })
  #        else prev.fetchFromGitHub args;
  #    };
  #  })
  #];

  # Realtime scheduling for pipewire
  security.rtkit.enable = true;

  # polkit for fine-grained privilege (instead of full sudo root GUI)
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    // Allow wheel to perform udisks2 disk operations (write/format) with a 1-time auth
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel") &&
          action.id.indexOf("org.freedesktop.udisks2.") === 0) {
        return polkit.Result.AUTH_ADMIN_KEEP; // prompt once, cache
      }
    });
  ''; 
  
  # Service configuration
  services = {
    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Nonroot - flipper and Panda wireless monitor mode
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0777", GROUP="dialout", TAG+="uaccess" 
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE="0666", GROUP="adm", SYMLINK+="rtl_sdr"
      ACTION=="add|move", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", ATTRS{idVendor}=="148f", ATTRS{idProduct}=="5572", TAG+="systemd", ENV{SYSTEMD_WANTS}="wifi-monitor@%E{INTERFACE}.service"
      ACTION=="remove", SUBSYSTEM=="net", KERNEL=="mon-*", RUN+="${pkgs.iproute2}/bin/ip link delete %k"
    '';

    # Enable CUPS to print documents.
    #printing.enable = true;

    # Cosmic Desktop
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    
    # ssh
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    
    # flatpak
    flatpak.enable = true;
  };
  
  # systemd configuration
  systemd = {
    # user services
    user.services = {
      # polkit activation
      polkit-agent = {
        description = "PolicyKit Authentication Agent (LXQt)";
        wantedBy = [ "default.target" ];              # starts on login
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
          Restart = "on-failure";
        };
      };
    };

    # system services
    services = {
      # Flatpak configuration
      flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          if [ ! $(flatpak remotes --columns=name | grep flathub) ]; then
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
          fi
        '';
      };

      # Start the default libvirtd network on startup
      virsh-autostart-default-network = {
        description = "Ensure default libvirt network is set to autostart";
        after = [ "libvirtd.service" ];
        wants = [ "libvirtd.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.libvirt}/bin/virsh net-autostart default";
          Type = "oneshot";
        };
        wantedBy = [ "multi-user.target" ];
      };
      
      # Create service to change device to monitor mode when enabled.
      "wifi-monitor@" = {
         description = "Create monitor-mode interface for %I";
         after = [ "NetworkManager.service" "systemd-udevd.service" ];
         wants = [ "NetworkManager.service" ];
         serviceConfig = {
           Type = "oneshot";
           Environment = [ "IFACE=%i" ];
           AmbientCapabilities = [ "CAP_NET_ADMIN" ];
           ExecStart = pkgs.writeShellScript "wifi-monitor" ''
             set -euo pipefail
             echo "wifi-monitor: IFACE=$IFACE" | ${pkgs.systemd}/bin/systemd-cat -t wifi-monitor

             # Wait until the iface is present
             for i in $(seq 1 20); do
             if ${pkgs.iproute2}/bin/ip link show "$IFACE" >/dev/null 2>&1; then
               break
             fi
             sleep 0.1
             done

             MON="mon-$IFACE"

             # Hand base iface away from NM and bring it down
             ${pkgs.networkmanager}/bin/nmcli dev disconnect "$IFACE" || true
             ${pkgs.networkmanager}/bin/nmcli dev set "$IFACE" managed no || true
             ${pkgs.iproute2}/bin/ip link set "$IFACE" down || true

             # Try separate monitor iface first
             if ${pkgs.iw}/bin/iw dev "$IFACE" interface add "$MON" type monitor 2>/tmp/iw.err; then
             ${pkgs.iproute2}/bin/ip link set "$MON" up
             echo "wifi-monitor: created $MON" | ${pkgs.systemd}/bin/systemd-cat -t wifi-monitor
             exit 0
             fi

             # Fallback: flip base iface to monitor mode
             ${pkgs.iw}/bin/iw dev "$IFACE" set type monitor
             ${pkgs.iproute2}/bin/ip link set "$IFACE" up
             echo "wifi-monitor: flipped base iface $IFACE to monitor" | ${pkgs.systemd}/bin/systemd-cat -t wifi-monitor
           '';
         };
      };  
    };
  };
 
  programs = {
    # user mode wireshark
    wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
    
    # virt-manager
    virt-manager.enable = true;
  };

  virtualisation = {
    # libvirtd
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
    	    secureBoot = true;
    	    tpmSupport = true;
          }).fd];
        };
      };
    };

    # Podman Containers
    containers.enable = true;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Set time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  }; 

  system.stateVersion = "25.05";
}
