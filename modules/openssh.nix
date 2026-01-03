{ ... }: {
  services.getty.autologinUser = "nixos";
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERyckJvgXbUaCY95kGQDTj4Z0XPzTRVJFzbQE0d3sIE nan0br3aker@gmail.com"
  ];
  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERyckJvgXbUaCY95kGQDTj4Z0XPzTRVJFzbQE0d3sIE nan0br3aker@gmail.com"
  ];
}
