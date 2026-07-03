{pkgs, ...}: {
  programs.k9s.enable = true;
  home.packages = with pkgs; [
    parsec-bin
    code-cursor
    github-desktop
    libreoffice-qt
    kdePackages.kate
    wireshark
    remmina
    gnupg.out
    go
    proton-vpn
    protonmail-desktop
    dbeaver-bin
    caido-desktop
  ];
}
