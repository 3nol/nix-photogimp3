{ pkgs, ... }:
let
  gimp3-exe = pkgs.lib.getExe pkgs.gimp3;
  gimp3-version = pkgs.lib.versions.majorMinor pkgs.gimp3.version;
in
pkgs.writeShellApplication {
  name = "photo${pkgs.gimp3.pname}-reset";
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];

  text = ''
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/GIMP/${gimp3-version}"

    echo "This will delete \"$cfg\" and re-initialize the GIMP configuration."
    read -rp "Continue? [y/N] " ans
    case "$ans" in
      y|Y) ;;  # fall through
      *) echo "Aborted."; exit 0 ;;
    esac

    echo "Removing \"$cfg\"..."
    rm -rf "$cfg"
    echo "Re-initializing..."
    ${gimp3-exe} -i --quit > /dev/null
    echo "Done."
  '';
}
