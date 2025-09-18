{ pkgs }:
with pkgs; [
  # system
  tmux bat feh openvpn openssl xxd hexedit unzip p7zip fzf jq yq-go devbox ipcalc 
  wireguard-tools virt-manager transmission_4-gtk system76-keyboard-configurator
  rpi-imager ghostty below tree

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc ghc nodejs yarn
  python3 ruby android-tools mitscheme chez 

  # hacking/forensics
  metasploit nmap tcpdump binwalk wireshark exiftool sonic-visualiser ffuf ghidra
  foremost mitmproxy
  
  # wireless 
  sdrpp rtl-sdr #contact #python313Packages.meshtastic

  # AI 
  ollama code-cursor claude-code

  # games/fun
  bolt-launcher clolcat cowsay fortune shellcheck checkbashisms obs-studio yt-dlp
  mpv vlc qFlipper

  # Browser
  brave librewolf ungoogled-chromium tor-browser

  # communications
  signal-desktop discord
  
  # hardware
  flashrom esptool espflash

  # containers/DevOps
  kubectl kubernetes-helm minikube krew kubebuilder cri-tools clusterctl opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose awscli2 azure-cli
  google-cloud-sdk google-cloud-sdk-gce ansible
]
