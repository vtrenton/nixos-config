{ pkgs }:
with pkgs; [
  # system
  tmux bat ghostty openvpn openssl xxd hexedit unzip p7zip jq yq-go devbox ipcalc 
  wireguard-tools virt-manager tree fzf system76-keyboard-configurator rpi-imager
  below transmission_4-gtk btop usbtop nix-init nixfmt ripgrep inxi speedtest-cli
  openconnect strongswan proxychains-ng ncdu

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc ghc nodejs yarn
  python3 ruby android-tools mitscheme chez 

  # hacking/forensics
  metasploit nmap tcpdump binwalk wireshark exiftool ffuf ghidra #sonic-visualiser 
  thc-hydra foremost mitmproxy
  
  # wireless 
  rtl-sdr sdrpp 

  # AI 
  ollama codex claude-code python313Packages.tiktoken python313Packages.torch

  # blockchain
  foundry

  # games/fun
  clolcat cowsay fortune shellcheck checkbashisms qFlipper yt-dlp bolt-launcher
  
  # media
  gimp feh mpv vlc obs-studio guitarix gxplugins-lv2 ardour calibre

  # Browser
  brave ungoogled-chromium tor-browser #librewolf

  # communications
  discord signal-desktop 
  
  # hardware
  flashrom esptool espflash

  # containers/DevOps
  kubectl kubernetes-helm minikube krew kubebuilder cri-tools clusterctl opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose azure-cli awscli2 
  google-cloud-sdk google-cloud-sdk-gce ansible k0sctl dive kind tailscale packer 
  teleport
]
