{
  pkgs,
  gimp3-exe,
  gimp3-version,
  photogimp3-files,
}:
pkgs.writeShellApplication {
  name = "photo${pkgs.gimp3.pname}-wrapper";
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];

  text = ''
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/GIMP/${gimp3-version}"

    if [ ! -f "$cfg/.photogimp3" ]; then
      echo "Creating GIMP configuration..."
      ${gimp3-exe} -i --quit > /dev/null

      echo "Overwriting with PhotoGIMP configuration..."
      cp --backup=simple --suffix=.backup -r ${photogimp3-files}/.config/GIMP/${gimp3-version}/. "$cfg"
      find "$cfg" -type f -exec chmod 644 {} +
      find "$cfg" -type d -exec chmod 755 {} +

      touch "$cfg/.photogimp3"
      echo "Done."
    fi

    exec ${gimp3-exe} "$@"
  '';
}
