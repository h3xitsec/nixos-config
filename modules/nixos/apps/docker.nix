{username, ...}: {
  virtualisation.docker.enable = true;
  #virtualisation.docker.extraOptions = "--insecure-registry 'http://192.168.0.99:5000'";
  users.extraGroups.docker.members = [username];
}
