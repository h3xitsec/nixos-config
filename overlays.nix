{inputs, ...}: {
  # Fix for libfprint
  fixups = final: prev: {
    libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [prev.nss];
    });
  };
  
  # Unstable packages overlay
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
