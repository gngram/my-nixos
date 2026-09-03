{ config, pkgs, ... }:

{
  imports = [
    ./chrome-webapps.nix
  ];

  mynixos.google-chrome.enableWebApps = true;

  environment.systemPackages = with pkgs; [
    meld
    firefox
    vim 
    gitFull
    nettools
    wget
    notepad-next
    networkmanagerapplet
    htop
    joplin
    gsettings-desktop-schemas
    teams-for-linux
    tree
    my-slack
    docker_29
    sysstat
    statix
  ];  
}

