{pkgs, ...}: {
  home.packages = with pkgs; [
    # Applications
    telegram-desktop
    parsec-bin
    code-cursor
    github-desktop
    claude-code

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
    dbeaver-bin
  ];
}
