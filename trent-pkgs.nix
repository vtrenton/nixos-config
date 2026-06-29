{ pkgs }:
with pkgs; [
  # system
  tree bat ghostty ripgrep openssl xxd hexedit unzip p7zip jq yq-go expect ipcalc 
  virt-manager pass fzf system76-keyboard-configurator rpi-imager ncdu below inxi 
  btop usbtop transmission_4-gtk speedtest-cli tigervnc
  
  # NixOS
  nix-init nixfmt nvd

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc bun nodejs yarn
  python3 ruby android-tools mitscheme chez ghc glow

  # hacking/forensics
  metasploit nmap tcpdump wireshark exiftool ffuf ghidra sonic-visualiser binwalk
  thc-hydra foremost mitmproxy

  # Net/Proxy
  openvpn openconnect networkmanager-openconnect strongswan wireguard-tools tor
  proxychains-ng

  # wireless 
  rtl-sdr sdrpp 

  # AI 
  ollama codex claude-code grok-cli opencode opencode-desktop

  # blockchain
  foundry

  # games/fun
  clolcat cowsay fortune shellcheck checkbashisms qFlipper yt-dlp bolt-launcher
  fastfetch
  
  # media
  gimp feh mpv vlc obs-studio ardour calibre gxplugins-lv2 guitarix

  # Browser
  brave ungoogled-chromium tor-browser #librewolf

  # communications
  signal-desktop

  # hardware
  flashrom esptool espflash

  # containers/DevOps
  kubectl kubernetes-helm minikube krew kubebuilder cri-tools clusterctl opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose awscli2 azure-cli
  google-cloud-sdk google-cloud-sdk-gce k0sctl dive kind ansible packer terraform 
  tailscale teleport
]
