{ inputs, pkgs, config, lib, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../../modules/home-manager.nix
    ../../modules/disko.nix
    { networking.hostId = "20a48094"; }
    ../../modules/helix.nix
    ../../modules/nushell.nix
    ../../modules/packages.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features =
    [ "nix-command" "flakes" "pipe-operators" ];

  time.timeZone = "UTC";

  users.users.nixos = {
    isNormalUser = true;
    name = "nixos";
    home = "/home/nixos";
    initialHashedPassword = "";
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.nushell;
  };

  users.users.root.initialHashedPassword = "";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERyckJvgXbUaCY95kGQDTj4Z0XPzTRVJFzbQE0d3sIE nan0br3aker@gmail.com"
  ];
  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERyckJvgXbUaCY95kGQDTj4Z0XPzTRVJFzbQE0d3sIE nan0br3aker@gmail.com"
  ];

  boot.tmp.useTmpfs = true;

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.getty.autologinUser = "nixos";
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  nix.settings.trusted-users = [ "nixos" ];

  networking.useNetworkd = true;
  networking.firewall.allowedUDPPorts = [ 5353 ];
  networking.hostName = "computeblade${config.boot.loader.raspberryPi.variant}";
  networking.wireless.enable = false;
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
      Settings.AutoConnect = true;
    };
  };

  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
    "99-wireless-client-dhcp".networkConfig.MulticastDNS = "yes";
  };

  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
  };

  services.udev.extraRules = ''
    # Ignore partitions with "Required Partition" GPT partition attribute
    # On our RPis this is firmware (/boot/firmware) partition
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"
  '';

  system.nixos.tags = let cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  programs.ssh.startAgent = true;

  home-manager.users.nixos.home = {
    homeDirectory = lib.mkForce "/home/nixos";
    stateVersion = "25.05";
  };

  # We are stateless, so just default to latest.inherit
  system.stateVersion = config.system.nixos.release;
}
