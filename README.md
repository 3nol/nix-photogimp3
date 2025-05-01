# PhotoGIMP 3 Nix Flake
A Nix flake that packages PhotoGIMP customization's for GIMP on Linux, providing a Photoshop-like experience with familiar UI and shortcuts.

## Prerequisites
- Any Linux distro
- Nix package manager with flakes enabled

## Installation
> [!NOTE]
> This flake is using [NixPak](https://github.com/nixpak/nixpak) for sandboxing GIMP, this means that it will not override an existing GIMP installation. The config directory is `~/.config/PhotoGIMP/$GIMP_VERSION` (currently 3.0)

### Using a NixOs system with flakes
Add this flake as an Input:
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-photogimp = {
      url = "github:Libadoxon/nix-photo-gimp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```
Than add it to your `environment.systemPackages` or `home.packages` like so:
```nix
{ inputs, pkgs, ... }: {
  home.packages = [ inputs.nix-photogimp.packages.${pkgs.system}.default ];
}
```
Rebuild and PhotoGIMP should be available to you.

### Using Nix Profiles
```bash
nix profile install github:Libadoxon/nix-photo-gimp
```

## Attribution
Adapted from [aloshy-ai/nix-photogimp](https://github.com/aloshy-ai/nix-photogimp), if you're running Darwin, that is the flake for you (only GIMP 2 at the moment)
