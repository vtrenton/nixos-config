{ pkgs }:
with pkgs; [
  # system
  tmux bat feh openvpn openssl xxd hexedit unzip p7zip fzf jq yq-go ghostty ipcalc 
  wireguard-tools virt-manager transmission_4-gtk system76-keyboard-configurator
  rpi-imager devbox below

  # devel
  gh glab gcc gdb gnumake android-tools go golint errcheck cargo rustc nodejs yarn
  python3 ruby yamllint

  # hacking/forensics
  metasploit nmap binwalk exiftool foremost sonic-visualiser ffuf wireshark
  tcpdump ghidra #mitmproxy
  
  # wireless 
  sdrpp rtl-sdr #contact #python313Packages.meshtastic

  # AI 
  ollama code-cursor claude-code

  # games/fun
  clolcat bolt-launcher cowsay shellcheck qFlipper obs-studio yt-dlp

  # Browser
  brave librewolf ungoogled-chromium tor-browser

  # communications
  signal-desktop discord
  
  # hardware
  flashrom esptool espflash

  # containers/DevOps
  kubectl kubernetes-helm minikube krew kubebuilder cri-tools clusterctl opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose awscli2 #azure-cli
  google-cloud-sdk
]
