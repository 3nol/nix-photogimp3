{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "photo${pkgs.gimp3.pname}-clean";
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];

  text = ''
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/GIMP/3.0"
    cache="''${XDG_CACHE_HOME:-$HOME/.cache}/gimp/3.0"
    legacy="$HOME/.gimp"
    temporary="''${TMPDIR:-/tmp}/gimp"

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
