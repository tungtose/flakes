{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      google-chrome
      # google-chrome-beta
    ];
  };
}
