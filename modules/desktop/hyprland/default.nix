{ config, lib, pkgs, inputs, ... }:
{
  imports = [ ../../programs/wayland/waybar/hyprland_waybar.nix ];
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    swaylock-effects
    pamixer
  ];

  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.gnome.gnome-session ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    wlr = {
      enable = true;
      /* settings = { */
      /*   # uninteresting for this problem, for completeness only */
      /*   screencast = { */
      /*     chooser_type = "simple"; */
      /*     chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or"; */
      /*   }; */
      /* }; */
    };
  };
}
