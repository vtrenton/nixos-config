{ pkgs }:
with pkgs; [
  # system
  tree bat ghostty ripgrep openssl xxd hexedit unzip p7zip jq yq-go expect ipcalc 
  virt-manager pass fzf system76-keyboard-configurator rpi-imager ncdu below inxi 
  btop usbtop transmission_4-gtk speedtest-cli tigervnc screen
  
  # NixOS
  nix-init nixfmt nvd

  # devel
  gh glab gcc gdb gnumake go golint errcheck yamllint cargo rustc nodejs bun dino
  yarn python3 ruby android-tools mitscheme chez ghc glow

  # hacking/forensics
  metasploit nmap tcpdump wireshark exiftool ffuf ghidra sonic-visualiser binwalk
  thc-hydra foremost mitmproxy

  # Net/Proxy
  openvpn openconnect networkmanager-openconnect strongswan wireguard-tools tor
  proxychains-ng tailscale teleport

  # wireless 
  rtl-sdr sdrpp 

  # AI 
  ollama codex claude-code grok-cli opencode opencode-desktop

  # blockchain
  foundry

  # games/fun
  clolcat cowsay fortune shellcheck checkbashisms qFlipper yt-dlp bolt-launcher
  fastfetch

  # productivity
  obsidian

  # media
  gimp feh mpv vlc obs-studio ardour calibre gxplugins-lv2 guitarix ani-cli
  cliamp ffmpeg

  # Browser
  brave ungoogled-chromium tor-browser librewolf

  # communications
  signal-desktop

  # hardware
  flashrom esptool espflash kicad picotool

  # containers/DevOps
  kubectl kubernetes kubernetes-helm minikube krew kubebuilder cri-tools opentofu
  pulumi pulumi-esc pulumiPackages.pulumi-nodejs podman-compose awscli2 azure-cli
  google-cloud-sdk google-cloud-sdk-gce k0sctl dive kind ansible packer terraform 
  clusterctl
]
