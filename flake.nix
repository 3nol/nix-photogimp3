{
  description = "Nix Package for PhotoGIMP sandboxed using NixPak";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpak = {
      url = "github:Keksgesicht/nixpak/dbus-instance";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpak,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        inherit (pkgs) lib;

        gimp = pkgs.gimp3;

        mkNixPak = nixpak.lib.nixpak {
          inherit pkgs lib;
        };

        photo-gimp-files =
          (pkgs.fetchFromGitHub {
            owner = "Diolinux";
            repo = "PhotoGIMP";
            rev = "af558b2889cd504fb4ed3db06c014cf36a4c8720";
            sha256 = "sha256-OLEqtI2Hem2fTTL0KNf0aZsFfuwwhgE4etyRMcW5KiQ=";
          }).outPath;

        desktopItem = pkgs.makeDesktopItem (import ./desktopFile.nix photo-gimp-files);

        gimp-wrapper = import ./photo-gimp-install-wrapper.nix {
          inherit
            pkgs
            lib
            gimp
            photo-gimp-files
            ;
        };

        nixpak-wrapper = (mkNixPak (import ./nixPak.nix gimp-wrapper)).config.script;
      in
      {
        packages = {
          default = self.packages.${system}.photo-gimp;
          photo-gimp =
            let
              script =
                pkgs.writeScript "photogimp-gimp-nixpak-wrapper-script"
                  # bash
                  ''
                    mkdir -p "$HOME/.config/PhotoGIMP"
                    exec "$@"
                  '';
            in
            pkgs.stdenv.mkDerivation {
              name = "photogimp-gimp-nixpak-wrapper";
              buildInputs = [ pkgs.makeWrapper ];

              dontUnpack = true;

              installPhase = ''
                mkdir -p $out/{bin,share}
                makeWrapper ${script} $out/bin/gimp \
                  --add-flags ${lib.getExe nixpak-wrapper} \
                  --set PATH ${
                    lib.makeBinPath (
                      with pkgs;
                      [
                        coreutils
                        bash
                      ]
                    )
                  }

                cp -r ${photo-gimp-files}/.local/share/icons $out/share
                install -D ${desktopItem}/share/applications/PhotoGIMP.desktop $out/share/applications/PhotoGIMP.desktop
              '';

              meta = {
                mainProgram = "gimp";
                platforms = [ system ];
              };
            };
        };
      }
    );
}
