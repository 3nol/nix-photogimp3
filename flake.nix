rec {
  description = "Nix package for PhotoGIMP, based on GIMP 3.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        photogimp3-files =
          (pkgs.fetchFromGitHub {
            owner = "Diolinux";
            repo = "PhotoGIMP";
            rev = "af558b2889cd504fb4ed3db06c014cf36a4c8720";
            sha256 = "sha256-OLEqtI2Hem2fTTL0KNf0aZsFfuwwhgE4etyRMcW5KiQ=";
          }).outPath;
        photogimp3-desktop = pkgs.makeDesktopItem (import ./photogimp3/desktop.nix photogimp3-files);
        photogimp3-package =
          gimp3:
          let
            gimp3-exe = pkgs.lib.getExe gimp3;
            gimp3-version = pkgs.lib.versions.majorMinor gimp3.version;
            photogimp3-wrapper = pkgs.lib.getExe (
              import ./photogimp3/wrapper.nix {
                inherit
                  pkgs
                  gimp3-exe
                  gimp3-version
                  photogimp3-files
                  ;
              }
            );
          in

          pkgs.stdenv.mkDerivation {
            pname = "photo${gimp3.pname}";
            inherit (gimp3) version passthru man;

            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/{bin,share}
              install -D ${photogimp3-wrapper} $out/bin/gimp
              cp -r ${photogimp3-files}/.local/share/icons $out/share
              install -D ${photogimp3-desktop}/share/applications/PhotoGIMP.desktop $out/share/applications/PhotoGIMP.desktop
            '';

            meta = gimp3.meta // {
              inherit description;
            };
          };
      in
      {
        packages =
          let
            default = photogimp3-package pkgs.gimp3;
          in
          {
            photogimp3 = default;
            photogimp3-with-plugins =
              pkgs.callPackage "${pkgs.path}/pkgs/applications/graphics/gimp/wrapper.nix"
                {
                  gimpPlugins = pkgs.gimp3Plugins.override {
                    gimp = default;
                  };
                };
            inherit default;
          };

        apps =
          let
            reset = import ./photogimp3/reset.nix { inherit pkgs; };
            clean = import ./photogimp3/clean.nix { inherit pkgs; };
          in
          {
            photogimp3-reset = flake-utils.lib.mkApp {
              drv = reset;
            };
            photogimp3-clean = flake-utils.lib.mkApp {
              drv = clean;
            };
          };
      }
    );
}
