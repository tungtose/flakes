{ lib, stdenv, fetchzip, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "cattpuccin-frappe-gtk";
  version = "0.6.0";

  src = fetchzip {
    url =
      "https://github.com/catppuccin/gtk/releases/download/v0.6.0/Catppuccin-Frappe-Standard-Pink-Dark.zip";
    sha256 = "w7yv9e9MuZgmCdr/RdDxg2hAeIhb1f82idUj4diI8v8=";
    stripRoot = false;
  };

  propagatedUserEnvPkgs = with pkgs; [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r Catppuccin-Frappe-Pink $out/share/themes
  '';

  meta = {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.Ruixi-rebirth ];
  };
}
