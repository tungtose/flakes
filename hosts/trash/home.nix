{ config, lib, pkgs, user, impermanence, ... }:

{
  imports =
    [ (import ../../modules/scripts) ] ++
    (import ../../modules/shell) ++
    (import ../../modules/editors);


  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    sessionVariables = {
      MACHINE = "WSL";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
      "$HOME/.cargo/bin"
    ];
  };

  home.packages = with pkgs; [
    ripgrep
    btop
    fd
  ];

  programs = {
    home-manager.enable = true;
  };

  home.stateVersion = "22.11";
}
