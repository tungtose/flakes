{ config, pkgs, ... }:

{
  home.file.".config/helix/config.toml".source = ./config.toml;
  home.file.".config/helix/languages.toml".source = ./languages.toml;
  home.file.".config/helix/themes/od.toml".source = ./od.toml;
}
