{ pkgs }:
with pkgs; [
  # system
  tmux bat ghostty openvpn openssl xxd hexedit unzip p7zip jq yq-go devbox ipcalc 
  wireguard-tools virt-manager tree fzf system76-keyboard-configurator rpi-imager
  below transmission_4-gtk btop usbtop nix-init nixfmt ripgrep inxi speedtest-cli
  openconnect strongswan proxychains-ng ncdu tigervnc pass

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc bun nodejs yarn
  python3 ruby android-tools mitscheme chez ghc

  # hacking/forensics
  metasploit nmap tcpdump wireshark exiftool ffuf ghidra sonic-visualiser #binwalk
  thc-hydra foremost mitmproxy
  
  # wireless 
  rtl-sdr sdrpp 

  # AI 
  ollama codex claude-code grok-cli opencode opencode-desktop

  # blockchain
  foundry

  # games/fun
  clolcat cowsay fortune shellcheck checkbashisms qFlipper yt-dlp bolt-launcher
  
  # media
  gimp feh mpv vlc obs-studio ardour calibre gxplugins-lv2 guitarix

  # Browser
  brave ungoogled-chromium tor-browser librewolf

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
