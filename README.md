# nix-photogimp3

A Nix flake that packages [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) customization's for GIMP on Linux,
providing a Photoshop-like experience with familiar UI and shortcuts.

## Overview

### Packages

This repository provides two Nix packages.
- `packages.${system}.photogimp3`
- `packages.${system}.photogimp3-with-plugins`

They should work analogous to `pkgs.gimp3` and `pkgs.gimp3-with-plugins`.
The plain `photogimp3` package is aliased to `default`, as well.

### Apps

Additionally, this repository provides two Nix apps for tooling.
- `nix run .#photogimp3-reset`
- `nix run .#photogimp3-clean`

They exist for the reason that [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) is **not** run in a sandbox and,
instead, overwrites "$HOME/.config/GIMP/3.0". Resetting re-initializes this configuration directory with the
default GIMP 3.0 configuration. Cleaning will purge all XDG base directories of GIMP 3.0 data.

## Prerequisites

- Any Linux distro.
- Nix package manager with flakes enabled.

```
--experimental-features 'nix-command flakes'
```

## Installation

> [!NOTE]
> This is a fork of [Libadoxon/nix-photo-gimp](https://github.com/Libadoxon/nix-photo-gimp),
same functionality here but without [NixPak](https://github.com/nixpak/nixpak).

### Using a NixOS system with flakes

First, reference this flake as an input.
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-photogimp3 = {
      url = "github:3nol/nix-photogimp3";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
}
```

Next, add it to your `environment.systemPackages` or `home.packages` like so.
```nix
{ inputs, pkgs, ... }: {
  home.packages = [ inputs.nix-photogimp3.packages.${pkgs.system}.default ];
}
```

Rebuild, and [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) should be available via NixOS or HomeManager.

### Using Nix profiles

Use this to install the `default` package.
```sh
nix profile install github:3nol/nix-photogimp3
```

## Attribution

1. PhotoGIMP itself was created by [Diolinux](https://github.com/Diolinux).

2. Adapted from [aloshy-ai/nix-photogimp](https://github.com/aloshy-ai/nix-photogimp), 
if you're running Darwin, that is the flake for you (only GIMP 2 at the moment).

3. Forked from [Libadoxon/nix-photo-gimp](https://github.com/Libadoxon/nix-photo-gimp), 
if you want to use [NixPak](https://github.com/nixpak/nixpak), that is the flake for you (also GIMP 3).
