{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cerberus"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Custom local host resolution
  # networking.hosts = {
  #  "127.0.0.2" = ["other-localhost"];
  #  "192.0.2.1" = ["mail.example.com" "imap.example.com"];
  # };

  # Set your time zone.
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
  
  # System76
  hardware.system76.enableAll = true;
  
  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

 
  # Local Proxy config
  # environment.variables = {
  #   http_proxy  = "http://localhost:8080";
  #   https_proxy = "http://your.proxy.server:port";
  #   ftp_proxy   = "http://your.proxy.server:port";
  #   all_proxy   = "http://your.proxy.server:port";
  #   no_proxy    = "localhost,127.0.0.1,::1";
  #};

  environment.variables.EDITOR = "vim";
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.trent = {
    isNormalUser = true;
    description = "Trent V";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "wireshark" "dialout" ];
    packages = with pkgs; [
      tmux
      bat
      gh
      glab
      gdb
      go
      golint
      errcheck
      cargo
      nodejs
      yarn
      python3
      ruby
      ollama
      clolcat
      cowsay
      xxd
      hexedit
      unzip
      fzf
      jq
      yq-go
      yamllint
      nmap
      binwalk
      exiftool
      sonic-visualiser
      ffuf
      librewolf
      brave
      tor-browser
      ghostty
      ipcalc
      wireshark
      qFlipper
      wireguard-tools
      virt-manager
      obs-studio
      code-cursor
      opencode
      claude-code
      transmission_4-gtk
      system76-keyboard-configurator
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    binutils
    htop
    file
    dig
    whois
    traceroute
    wget
    rsync
    lm_sensors
    dmidecode
    lshw
    usbutils
    pciutils
    gnupg
    openconnect
    networkmanager-openconnect
    pinentry-tty
    git
    git-lfs
  ];

  # Nonroot - flipper
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0777", GROUP="dialout", TAG+="uaccess"
  '';


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Cosmic Desktop
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };

  # Flatpak configuration
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      if [ ! $(flatpak remotes --columns=name | grep flathub) ]; then
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      fi
    '';
  };
  
  # user mode wireshark
  programs.wireshark.enable = true;
  programs.wireshark.dumpcap.enable = true;
  programs.wireshark.usbmon.enable = true;

  # virt-manager
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  # Start the default libvirtd network on startup
  systemd.services.virsh-autostart-default-network = {
    description = "Ensure default libvirt network is set to autostart";
    after = [ "libvirtd.service" ];
    wants = [ "libvirtd.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.libvirt}/bin/virsh net-autostart default";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
