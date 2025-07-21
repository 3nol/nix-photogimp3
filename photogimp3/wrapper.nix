{
  pkgs,
  lib,
  gimp,
  photo-gimp-files,
}:
pkgs.writeShellApplication {
  name = "gimp";
  text =
    # bash
    ''
      if [ ! -f "$HOME/.config/GIMP/3.0/.photo-gimp-installed" ]; then
        echo "Creating GIMP Configuration"
        ${lib.getExe gimp} -i --quit > /dev/null
        echo "Adding PhotoGIMP Configuration"
        cp --backup=simple --suffix=.bac -r ${photo-gimp-files}/.config/GIMP/3.0/. "$HOME/.config/GIMP/3.0"

        find "$HOME/.config/GIMP/3.0" -type f -exec chmod 644 {} +
        find "$HOME/.config/GIMP/3.0" -type d -exec chmod 755 {} +

        echo "Configuring finished"
        touch "$HOME/.config/GIMP/3.0/.photo-gimp-installed"
      fi
      ${lib.getExe gimp}
    '';
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    bash
  ];
}
