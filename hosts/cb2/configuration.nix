{ inputs, pkgs, config, lib, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../../modules/boot.nix
    ../../modules/disko.nix
    ../../modules/git.nix
    ../../modules/helix.nix
    ../../modules/home-manager.nix
    ../../modules/networking.nix
    ../../modules/nushell.nix
    ../../modules/openssh.nix
    ../../modules/packages.nix
    ../../modules/time.nix
    ../../modules/udev.nix
    ../../modules/yazi.nix
    ../../modules/starship.nix
  ];

  users.users.nixos = {
    isNormalUser = true;
    name = "nixos";
    home = "/home/nixos";
    extraGroups =
      [ "wheel" "networkmanager" "video" "audio" "input" "dialout" "plugdev" ];
    shell = pkgs.nushell;
  };

  networking.hostId = "32835dd8";
  networking.hostName = "computeblade2";

  nix.settings.trusted-users = [ "nixos" ];

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.nixos.tags = let cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  home-manager.users.nixos.home = {
    homeDirectory = lib.mkForce "/home/nixos";
    stateVersion = "25.05";
  };

  # We are stateless, so just default to latest.inherit
  system.stateVersion = config.system.nixos.release;
}
