{pkgs, ...}: {
  programs.k9s.enable = true;
  home.packages = with pkgs; [
#    telegram-desktop
    parsec-bin
    code-cursor
    github-desktop
    # claude-code
    libreoffice-qt
    kdePackages.kate
    wireshark
    remmina
    gnupg.out
    go
    proton-vpn
    protonmail-desktop
    dbeaver-bin
  ];
}
