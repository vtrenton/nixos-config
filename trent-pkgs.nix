{ pkgs }:
with pkgs; [
  # system
  tmux bat ghostty openvpn openssl xxd hexedit unzip p7zip jq yq-go devbox ipcalc 
  wireguard-tools virt-manager tree fzf system76-keyboard-configurator rpi-imager
  below transmission_4-gtk btop usbtop nix-init

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc ghc nodejs yarn
  python3 ruby android-tools mitscheme chez 

  # hacking/forensics
  metasploit nmap tcpdump binwalk wireshark exiftool sonic-visualiser ffuf ghidra
  thc-hydra foremost mitmproxy
  
  # wireless 
  rtl-sdr sdrpp 

  # AI 
  ollama claude-code codex

  # blockchain
  foundry

  # games/fun
  clolcat cowsay fortune shellcheck checkbashisms qFlipper yt-dlp bolt-launcher
  
  # media
  gimp feh mpv vlc obs-studio guitarix gxplugins-lv2 #ardour

  # Browser
  brave librewolf ungoogled-chromium tor-browser

  # communications
  discord signal-desktop 
  
  # hardware
  flashrom esptool espflash

  # containers/DevOps
  kubectl kubernetes-helm minikube krew kubebuilder cri-tools clusterctl opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose azure-cli awscli2 
  google-cloud-sdk google-cloud-sdk-gce ansible k0sctl dive
]
