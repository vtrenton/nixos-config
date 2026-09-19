{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "Zeus"; # Define your hostname.
    networkmanager.enable = true;
  };

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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.trent = {
    isNormalUser = true;
    description = "Trent V";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "audio" "video" "dialout" "realtime" ];
    packages = with pkgs; [
      gh
      jq
      yq-go
      tmux
      bat
      btop
      nvd
      nix-init
      nixfmt
      gimp
      pass
      ipcalc
      mpv
      unzip
      p7zip
      brave
      ungoogled-chromium
      tor-browser
      burpsuite
      steam
      libreoffice
      mupen64plus
      rmg-wayland
      clolcat
      cowsay
      ardour
      lv2
      gxplugins-lv2
      minicom
      kicad
      #sdrpp
      gqrx
      hwinfo
      fastfetch
      python3
      #rtl-sdr
      qpwgraph
      alejandra
      android-tools
      google-chrome
      transmission_4-gtk
      wireshark
      virt-manager
      vimPlugins.vim-addon-nix
      wine
      wine64
      wine-wayland
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    htop
    tor
    coreutils
    pciutils
    usbutils
    amdgpu_top
    clinfo
    whois
    dig
    wget
    rsync
    gnupg
    pinentry-tty
    git
    killall
    teleport
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="adm", MODE="0666", SYMLINK+="rtl_sdr"
  '';


  # List services that you want to enable:

  # Cosmic Desktop
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  
  services.openssh.enable = true;
  services.flatpak.enable = true;

  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Teleport ssh client
  #services.teleport = {
  #  enable = true;
  #  package = pkgs.teleport;
  #  settings = {
  #    version = "v3";
  #    teleport = {
  #      nodename = config.networking.hostName;
  #      data_dir = "/var/lib/teleport";
  #      proxy_server = "teleport.trentonvanderwert.com:443";
  #      auth_token = "/var/lib/teleport/join-token";
  #      log = {
  #        severity = "INFO";
  #      };
  #    };
  #    auth_service = {
  #      enabled = false;
  #    };
  #    proxy_service = {
  #      enabled = false;
  #    };
  #    ssh_service = {
  #      enabled = true;
  #      labels = {
  #        env = "lab";
  #        os = "nixos";
  #      };
  #    };
  #  };
  #};

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [
  #];
  #networking.firewall.allowedUDPPorts = [
  #];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # Did you read the comment?
}
