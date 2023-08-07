{ lib, pkgs, user, config, modulesPath, inputs, ... }:

{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    inputs.nixos-wsl.nixosModules.wsl
  ];
  wsl = {
    enable = true;
    defaultUser = "tung";
    # startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
  };

   boot.isContainer = true;

  networking.hostName = "nixos";

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  networking.dhcpcd.enable = false;

  users.users.root = {
    # Otherwise WSL fails to login as root with "initgroups failed 5"

    extraGroups = [ "root" ];
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;

  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  hardware.opengl.enable = true;
}
