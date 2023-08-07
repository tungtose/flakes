{ config, lib, pkgs, user, impermanence, ... }:

{
  imports =
    [ (import ../../modules/scripts) ] ++
    (import ../../modules/shell) ++
    (import ../../modules/editors);



  /* fonts = { */
  /*   fonts = with pkgs; [ */
  /*     nerdfonts */
  /*   ]; */
  /* }; */


  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    sessionVariables = {
      MACHINE = "WSL";
    };
  };

  home.packages = with pkgs; [
    ripgrep
  ];

  programs = {
    home-manager.enable = true;
  };

  home.stateVersion = "22.11";
}
