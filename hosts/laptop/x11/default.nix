{ config, pkgs, user, inputs, ... }:

{
  imports =
    (import ../../../modules/hardware) ++
    (import ../../../modules/virtualisation) ++
    [
      ../hardware-configuration.nix
      ../../../modules/fonts
    ] ++ [
      ../../../modules/desktop/bspwm
    ];

  users.users.root.initialHashedPassword = "$6$mEqF1oBoptW2eh/a$zDs/Fe4C0x9ICXpIrLpamDFt4xPa.BiCsZzFUAzp5zrOn2xxUC.lRP968kuyLZDE3DSTKdhmt22si9bQ66Wi1/";
  users.users.${user} = {
    initialHashedPassword = "$6$mEqF1oBoptW2eh/a$zDs/Fe4C0x9ICXpIrLpamDFt4xPa.BiCsZzFUAzp5zrOn2xxUC.lRP968kuyLZDE3DSTKdhmt22si9bQ66Wi1/";
    # shell = pkgs.zsh;
    # shell = pkgs.fish;
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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki ];
  };

  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs; [
      libnotify
      xclip
      xorg.xrandr
      gnome.gnome-screenshot
      cinnamon.nemo
      networkmanagerapplet
      alsa-lib
      alsa-utils
      flac
      pulsemixer
      imagemagick
      flameshot
      jq
    ];
  };

  services = {
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${user}";
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
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
