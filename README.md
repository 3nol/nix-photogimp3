# nix-photogimp3

A Nix flake that packages [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) customization's for GIMP on Linux,
providing a Photoshop-like experience with familiar UI and shortcuts.

## Overview

This repository provides two Nix packages and one Nix app.
- `packages.${system}.photogimp3`
- `packages.${system}.photogimp3-with-plugins`

They should work analogous to `pkgs.gimp3` and `pkgs.gimp3-with-plugins`.
Note that the plain `photogimp3` package is aliased to `default`, too.

The app is called `photogimp3-reset` and can be run as follows.
```sh
nix run .#photogimp3-reset
```
It exists for the reason that [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) is _not_ run in a sandbox and,
instead, overwrites "$HOME/.config/GIMP/3.0". The app will reset this configuration directory.

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
    nix-photogimp3 = {
      url = "github:3nol/nix-photogimp3";
      inputs.nixpkgs.follows = "nixpkgs";
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

Finally rebuild, and [PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) should be available via NixOS or HomeManager, respectively.

### Using Nix profiles

Use this to install the `default` package.
```sh
nix profile install github:3nol/nix-photogimp3
```

## Attribution

1. PhotoGIMP itself by [Diolinux](https://github.com/Diolinux).

2. Adapted from [aloshy-ai/nix-photogimp](https://github.com/aloshy-ai/nix-photogimp), 
if you're running Darwin, that is the flake for you (only GIMP 2 at the moment).

3. Forked from [Libadoxon/nix-photo-gimp](https://github.com/Libadoxon/nix-photo-gimp), 
if you want to use [NixPak](https://github.com/nixpak/nixpak), that is the flake for you.
