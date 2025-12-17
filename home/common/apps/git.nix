{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.email = "connect@h3x.it";
      user.name = "h3xit";
      init.defaultBranch = "main";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
  };
}
