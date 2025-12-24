{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.email = "h3xit@protonmail.com";
      user.name = "h3xit";
      init.defaultBranch = "main";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
    lfs.enable = true; # Needed for github-desktop to work without error
  };
}
