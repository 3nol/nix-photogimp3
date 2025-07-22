{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "photo${pkgs.gimp3.pname}-reset";
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];

  text = ''
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/GIMP/3.0"

    echo "This will delete \"$cfg\" and re-initialize the GIMP configuration."
    read -rp "Continue? [y/N] " ans
    case "$ans" in
      y|Y) ;;  # fall through
      *) echo "Aborted."; exit 0 ;;
    esac

    echo "Removing \"$cfg\"..."
    rm -rf "$cfg"
    echo "Re-initializing..."
    ${pkgs.lib.getExe pkgs.gimp3} -i --quit > /dev/null
    echo "Done."
  '';
}
