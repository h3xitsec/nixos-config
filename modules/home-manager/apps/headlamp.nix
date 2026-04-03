{pkgs, ...}: let
  pname = "headlamp";
  version = "0.40.1";

  headlampApp =
    if pkgs.stdenv.isDarwin
    then let
      dmgInfo = {
        "aarch64-darwin" = {
          url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v${version}/Headlamp-${version}-mac-arm64.dmg";
          hash = "sha256-uxCUVb52yl6YOe9pLK+Aecw88Iq9FZ3lrOwHmmtgzlg=";
        };
        "x86_64-darwin" = {
          url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v${version}/Headlamp-${version}-mac-x64.dmg";
          hash = "sha256-m42HYuCyPKk6vqiEEtXw8lADCwlMq+THolz+kPpj0s4=";
        };
      };
      info = dmgInfo.${pkgs.stdenv.hostPlatform.system} or (throw "headlamp: ${pkgs.stdenv.hostPlatform.system} is unsupported on Darwin");
    in
      pkgs.stdenvNoCC.mkDerivation {
        inherit pname version;

        src = pkgs.fetchurl {
          url = info.url;
          hash = info.hash;
        };

        sourceRoot = ".";

        nativeBuildInputs = [pkgs._7zz];

        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/Applications"
          mv Headlamp.app "$out/Applications"
          runHook postInstall
        '';
      }
    else let
      src = pkgs.fetchurl {
        url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v${version}/Headlamp-${version}-linux-x64.AppImage";
        hash = "sha256-SdadGirmfSfj1gmbxc5IKRdwnHqkI4keSE0BlkKGW4c=";
      };

      appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
    in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        pkgs = pkgs;
        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${appimageContents}/usr/share/icons $out/share
        '';

        extraBwrapArgs = [
          "--bind-try /etc/nixos/ /etc/nixos/"
        ];

        dieWithParent = false;

        extraPkgs = pkgs:
          with pkgs; [
            unzip
            autoPatchelfHook
            asar
            (buildPackages.wrapGAppsHook3.override {inherit (buildPackages) makeWrapper;})
          ];
      };
in {
  home.packages = with pkgs; [
    headlampApp
  ];
}
