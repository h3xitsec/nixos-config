{pkgs, ...}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.extraGroups.libvirtd.members = ["h3x"];
  environment.systemPackages = with pkgs; [
    virtiofsd
    virglrenderer
  ];
}