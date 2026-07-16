{ lib, pkgs, config, ... }:
{
  config = {
    boot.loader.efi.canTouchEfiVariables = true;

    # Make boot logs quiet
    boot.kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "video=HDMI-A-2:off"
      "video=DP-1:off"
      "video=DP-2:off"
    ];
    #boot.kernelParams = [ "quiet" "splash" ];
    boot.loader.grub.enable = false;
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;

    # Optional: make sure frame buffer resolution is high
    #boot.loader.systemd-boot.consoleMode = "max";

    boot.plymouth = {
      enable = true;
      logo = ./logo/linix.png;
      theme = "spinner";
      extraConfig = ''
        [Daemon]
        BackgroundColor=0x000000   # black
        # BackgroundColor=0x000000 # black
      '';
    };

  };
}
