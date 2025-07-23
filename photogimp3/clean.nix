{ pkgs, ... }:
let
  gimp3-version = pkgs.lib.versions.majorMinor pkgs.gimp3.version;
in
pkgs.writeShellApplication {
  name = "photo${pkgs.gimp3.pname}-clean";
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];

  text = ''
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/GIMP/${gimp3-version}"
    cache="''${XDG_CACHE_HOME:-$HOME/.cache}/gimp/${gimp3-version}"
    legacy="$HOME/.gimp/${gimp3-version}"
    temporary="''${TMPDIR:-/tmp}/gimp/${gimp3-version}"

    echo "This will delete *all* the following paths."
    echo "- \"$cfg\""
    echo "- \"$cache\""
    echo "- \"$legacy\""
    echo "- \"$temporary\""
    read -rp "Continue? [y/N] " ans
    case "$ans" in
      y|Y) ;;  # fall through
      *) echo "Aborted."; exit 0 ;;
    esac

    echo "Removing all..."
    for each in \
      "$cfg" \
      "$cache" \
      "$legacy" \
      "$temporary"
    do
      rm -rf "$each"
    done
    echo "Done."
  '';
}
