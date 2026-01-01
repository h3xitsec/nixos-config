{ pkgs, ... }: 
let
  pname = "headlamp";
  version = "0.39.0";

  src = pkgs.fetchurl {
    url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v0.39.0/Headlamp-0.39.0-linux-x64.AppImage";
    hash = "sha256-tNAQz44YlyeqVQfhpEr3qhINB85RWOiGG5E2ZxoX43k=";
  };

  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
let 
  headlampApp = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    pkgs = pkgs;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share

      # unless linked, the binary is placed in $out/bin/cursor-someVersion
      # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    '';

    extraBwrapArgs = [
      "--bind-try /etc/nixos/ /etc/nixos/"
    ];
    
    dieWithParent = false;

    extraPkgs = pkgs: with pkgs; [
      unzip
      autoPatchelfHook
      asar
      # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
      (buildPackages.wrapGAppsHook3.override {inherit (buildPackages) makeWrapper;})
    ];
  }; 
  in {
    home.packages = with pkgs; [
      headlampApp
    ];
  }