{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "cerberus"; # Define your hostname.
    networkmanager.enable = true;
    firewall.enable = false;
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
    packages = with pkgs; [
      tmux
      bat
      feh
      gh
      glab
      gcc
      gdb
      android-tools
      go
      golint
      errcheck
      cargo
      rustc
      nodejs
      yarn
      python3
      ruby
      ollama
      clolcat
      openvpn
      metasploit
      cowsay
      shellcheck
      contact # meshtastic
      python313Packages.meshtastic
      xxd
      hexedit
      unzip
      p7zip
      fzf
      jq
      yq-go
      yamllint
      nmap
      binwalk
      exiftool
      foremost
      sonic-visualiser
      ffuf
      librewolf
      brave
      tor-browser
      signal-desktop
      ghostty
      ipcalc
      wireshark
      qFlipper
      below
      wireguard-tools
      virt-manager
      obs-studio
      code-cursor
      #claude-code
      transmission_4-gtk
      system76-keyboard-configurator
      rpi-imager
      discord
      devbox
      ghidra
      mitmproxy
      kubectl
      kubernetes-helm
      minikube
      krew
      kubebuilder
      cri-tools
      clusterctl
      opentofu
      pulumi
      pulumi-esc
      pulumiPackages.pulumi-nodejs
      podman-compose
      awscli2
      azure-cli
      google-cloud-sdk
      yt-dlp
    ];
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
      gnupg
      openconnect
      networkmanager-openconnect
      pinentry-tty
      git
      git-lfs
    ];
  };

  # Realtime scheduling for pipewire
  security.rtkit.enable = true; 
  
  # Service configuration
  services = {
    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Nonroot - flipper
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0777", GROUP="dialout", TAG+="uaccess"
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
  
  # Custom systemd unit configuration
  systemd.services = {
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
