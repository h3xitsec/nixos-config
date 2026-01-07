{
  config,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    obsidian
  ];

  fileSystems."/home/${username}/Obsidian" = {
    device = "/mnt/data/user-dirs/Documents/obsidian";
    options = ["bind"];
  };
}
