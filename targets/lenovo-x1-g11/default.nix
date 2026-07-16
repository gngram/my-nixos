{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  my-nixos = {
    hostname = "linix";
    enableBluetooth = true;
    enableNvidia = false;
    enableXfce = true;
  };

  environment.systemPackages = with pkgs; [
    devenv
    meld
    google-chrome
    joplin
    gtkterm
    pdfstudio2024
  ];

  users.users.nixbld1 = {
    isNormalUser = false;
  };
  programs.ssh.extraConfig = ''
    host ghaf-net
      hostname 192.168.0.101
    host ghaf-host
      hostname 192.168.100.2
      proxyjump ghaf-net
  '';
}
