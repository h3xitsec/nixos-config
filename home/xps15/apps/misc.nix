{pkgs, ...}: {
  home.packages = with pkgs; [
    # Applications
    obsidian
    discord
    telegram-desktop
    parsec-bin
    code-cursor
    github-desktop
    unstable.claude-code
    
    # Tools
    libreoffice-qt
    wireshark
    remmina
    gnupg.out
    go
    wireshark
    docker
    docker-compose
    protonvpn-gui
    protonmail-bridge-gui
    thunderbird
  ];
}
