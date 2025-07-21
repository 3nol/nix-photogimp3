toWrap: {
  config =
    { sloth, ... }:
    let
      appId = "org.gimp.GIMP";
    in
    {
      app.package = toWrap;
      flatpak = {
        inherit appId;
      };

      dbus.policies = {
        "${appId}" = "own";
        "${appId}.*" = "own";
        "org.mpris.MediaPlayer2.${appId}" = "own";
        "org.mpris.MediaPlayer2.${appId}.*" = "own";

        "org.freedesktop.portal.FileChooser" = "talk";
        "org.freedesktop.portal.Settings" = "talk";

        "org.freedesktop.DBus" = "talk";
        "org.freedesktop.DBus.*" = "talk";
        "org.freedesktop.portal.*" = "talk";

        "org.gtk.vfs.*" = "talk";
        "org.gtk.vfs" = "talk";
        "org.freedesktop.FileManager1" = "talk";
        "org.gnome.Shell.Screenshot" = "talk";
        "org.kde.kwin.Screenshot" = "talk";
      };

      gpu.enable = true;
      gpu.provider = "bundle";
      fonts.enable = true;
      locale.enable = true;

      bubblewrap = {
        bind.rw =
          let
            envSuffix = envKey: sloth.concat' (sloth.env envKey);
          in
          [
            (sloth.concat' sloth.xdgCacheHome "/fontconfig")
            (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
            (sloth.concat [
              (sloth.env "XDG_RUNTIME_DIR")
              "/"
              (sloth.envOr "WAYLAND_DISPLAY" "no")
            ])
            "/tmp/.X11-unix"
            (sloth.envOr "XAUTHORITY" "/no-xauth")

            (envSuffix "XDG_RUNTIME_DIR" "/at-spi/bus")
            (envSuffix "XDG_RUNTIME_DIR" "/gvfsd")
            (envSuffix "XDG_RUNTIME_DIR" "/dconf")
            (envSuffix "XDG_RUNTIME_DIR" "/pulse")

            sloth.homeDir

            [
              (sloth.concat' sloth.homeDir "/.config/PhotoGIMP")
              (sloth.concat' sloth.homeDir "/.config/GIMP")
            ]
          ];
      };
    };
}
