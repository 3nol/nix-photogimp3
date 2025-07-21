# nix-photogimp3

A Nix flake that packages [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) customization's for GIMP on Linux, providing a Photoshop-like experience with familiar UI and shortcuts.

## Prerequisites

- Any Linux distro.
- Nix package manager with flakes enabled.

```
--experimental-features 'nix-command flakes'
```

## Installation

> [!NOTE]
> This is a fork of [Libadoxon/nix-photo-gimp](https://github.com/Libadoxon/nix-photo-gimp), same functionality but without [NixPak](https://github.com/nixpak/nixpak).

### Using a NixOS system with flakes

Add this flake as an input.
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-photogimp3 = {
      url = "github:3nol/nix-photogimp3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Then, add it to your `environment.systemPackages` or `home.packages` like so.
```nix
{ inputs, pkgs, ... }: {
  home.packages = [ inputs.nix-photogimp3.packages.${pkgs.system}.default ];
}
```

Rebuild and [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) should be available via NixOS or HomeManager, respectively.

### Using Nix Profiles

```sh
nix profile install github:3nol/nix-photogimp3
```

## Attribution

1. PhotoGIMP itself by [Diolinux](https://github.com/Diolinux).
2. Adapted from [aloshy-ai/nix-photogimp](https://github.com/aloshy-ai/nix-photogimp), if you're running Darwin, that is the flake for you (only GIMP 2 at the moment).
3. Forked from [Libadoxon/nix-photo-gimp](https://github.com/Libadoxon/nix-photo-gimp), if you want to use [NixPak](https://github.com/nixpak/nixpak), that is the flake for you.
