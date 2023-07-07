{ config, lib, pkgs, user, ... }:
{
  imports = [ ../../programs/x11/polybar ];
  services.xserver = {
    desktopManager.gnome.enable = true;
    enable = true;
    xkbOptions = "caps:swapescape";
    displayManager = {
      startx.enable = false;
    };
  };
  programs = {
    dconf.enable = true;
    light.enable = true;
  };
  environment.systemPackages = with pkgs; [
    pamixer
    i3lock-fancy
  ];
}
