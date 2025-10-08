{ pkgs }:
with pkgs; [
  # system
  tmux bat ghostty openvpn openssl xxd hexedit unzip p7zip jq yq-go devbox ipcalc 
  wireguard-tools virt-manager tree fzf rpi-imager system76-keyboard-configurator
  below transmission_4-gtk btop usbtop

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc ghc nodejs yarn
  python3 ruby android-tools mitscheme chez 

  # hacking/forensics
  metasploit nmap tcpdump binwalk wireshark exiftool sonic-visualiser ffuf ghidra
  thc-hydra foremost mitmproxy
  
  # wireless 
  rtl-sdr #sdrpp 

  # AI 
  ollama claude-code codex

  # games/fun
  bolt-launcher clolcat cowsay fortune shellcheck checkbashisms qFlipper yt-dlp
  
  # media
  gimp feh mpv vlc obs-studio

  # Browser
  brave librewolf ungoogled-chromium tor-browser

  # communications
  signal-desktop discord
  
  # hardware
  flashrom esptool espflash

  # containers/DevOps
  kubectl kubernetes-helm minikube krew kubebuilder cri-tools clusterctl opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose azure-cli #awscli2 
  google-cloud-sdk google-cloud-sdk-gce ansible k0sctl
]
