{ config, pkgs, user, inputs, ... }:

{
  imports =
    (import ../../../modules/hardware) ++
    (import ../../../modules/virtualisation) ++
    [
      ../hardware-configuration.nix
      ../../../modules/fonts
    ] ++ [
      ../../../modules/desktop/hyprland
    ];

  users.users.root.initialHashedPassword = "$6$mEqF1oBoptW2eh/a$zDs/Fe4C0x9ICXpIrLpamDFt4xPa.BiCsZzFUAzp5zrOn2xxUC.lRP968kuyLZDE3DSTKdhmt22si9bQ66Wi1/";
  users.users.${user} = {
    initialHashedPassword = "$6$mEqF1oBoptW2eh/a$zDs/Fe4C0x9ICXpIrLpamDFt4xPa.BiCsZzFUAzp5zrOn2xxUC.lRP968kuyLZDE3DSTKdhmt22si9bQ66Wi1/";
    # shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    packages = (with pkgs; [
      # chatgpt-cli
    ]) ++ (with config.nur.repos;[
      # linyinfeng.icalingua-plus-plus
    ]);
  };
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    kernelParams = [
      "quiet"
      "splash"
      # "nvidia-drm.modeset=1"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  i18n.inputMethod = { };

  environment = {
    systemPackages = with pkgs; [
      libnotify
      wl-clipboard
      wlr-randr
      cinnamon.nemo
      networkmanagerapplet
      wev
      wf-recorder
      alsa-lib
      alsa-utils
      flac
      pulsemixer
      imagemagick
      pkgs.sway-contrib.grimshot
      flameshot
      grim
      jq
      plasma-pa
      slurp
      pulseaudioFull
      awscli2
      hdparm
    ];
  };

  sound.enable = false;

  services = {
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${user}";
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      wireplumber.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = ''
      ${user} ALL=(ALL) NOPASSWD:ALL
    '';
  };
  security.doas = {
    enable = false;
    extraConfig = ''
      permit nopass :wheel
    '';
  };

}
