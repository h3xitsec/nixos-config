{pkgs, ...}: {
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;
  users.extraGroups.libvirt.members = ["h3x"];
  environment.systemPackages = with pkgs; [
    virtiofsd
    virglrenderer
    virt-viewer
  ];
  environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";
}