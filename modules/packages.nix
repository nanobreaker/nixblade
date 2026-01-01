{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
    pstree
    neofetch
    ripgrep
    git
    tree
    btop
    systemctl-tui
  ];
}
