{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
    pstree
    neofetch
    ripgrep
    btop
    systemctl-tui
  ];
}
