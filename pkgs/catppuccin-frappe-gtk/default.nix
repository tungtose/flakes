{ lib, stdenv, fetchzip, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "cattpuccin-frappe-gtk";
  version = "0.2.7";

  src = fetchzip {
    url = "https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Frappe-Pink.zip";
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
}
