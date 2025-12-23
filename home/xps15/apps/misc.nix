{pkgs, ...}: {
  home.packages = with pkgs; [
    # Applications
    obsidian
    discord
    telegram-desktop
    parsec-bin
    unstable.code-cursor
    github-desktop
    unstable.claude-code
    
    # Tools
    libreoffice-qt
    wireshark
    remmina
    gnupg.out
    go
    docker
    docker-compose
    protonvpn-gui
    protonmail-bridge-gui
    thunderbird
  ];
}
