{
  pkgs,
  gimp3-exe,
  photogimp3-files,
}:
pkgs.writeShellApplication {
  name = "photogimp3-wrapper";

  text = ''
    if [ ! -f "$HOME/.config/GIMP/3.0/.photogimp3" ]; then
      echo "Creating GIMP Configuration..."
      ${gimp3-exe} -i --quit > /dev/null

      echo "Adding PhotoGIMP Configuration..."
      cp --backup=simple --suffix=.backup -r ${photogimp3-files}/.config/GIMP/3.0/. "$HOME/.config/GIMP/3.0"
      find "$HOME/.config/GIMP/3.0" -type f -exec chmod 644 {} +
      find "$HOME/.config/GIMP/3.0" -type d -exec chmod 755 {} +

      echo "Configuration done."
      touch "$HOME/.config/GIMP/3.0/.photogimp3"
    fi
    ${gimp3-exe}
  '';

  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];
}
