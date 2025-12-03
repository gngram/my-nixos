# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelParams = ["systemd.debug_shell=1"];
  boot.binfmt.emulatedSystems = [
    "riscv64-linux"
    "aarch64-linux"
  ];

  programs.nix-ld.enable = true;
 
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  networking.hostName = "cosmic";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Dubai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  #services.desktopManager.cosmic.enable = true;
  
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Enable xfce
  #services.displayManager.defaultSession = "xfce";
  #services.xserver.desktopManager.xfce.enable = true;
  
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.banner = ''
    Welocome to NixOS!
  '';
  
  services.desktopManager.gnome.enable = true;
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "gangaram";
  };
  # Enable Plasma
  #services.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  
  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gangaram = {
    isNormalUser = true;
    description = "Ganga Ram";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      binutils
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfyjcPGIRHEtXZgoF7wImA5gEY6ytIfkBeipz4lwnj6 Ganga.Ram@tii.ae"
    ];
  };

  nix.settings.trusted-users = ["root" "@wheel"];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    devenv
    vim
    gitFull
    nettools
    firefox
    meld
    vscode
    google-chrome
    slack
    teams-for-linux
    #globalprotect-openconnect
    ghostty
    gtkterm
    pdfstudio2024
  ];
  environment.cosmic.excludePackages = with pkgs; [
   cosmic-edit
  ];

  #nixpkgs.config.permittedInsecurePackages = [
  # "qtwebengine-5.15.19"
  #];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 445 139 8080 ];
  networking.firewall.allowedUDPPorts = [ 137 138 8080 ];
 
  system.stateVersion = "25.11";
}
