{ config, lib, pkgs, ... }:

let
  cfg = config.mynixos.google-chrome;

  # Helper function to declaratively generate an immutable desktop item for XFCE
  makeWebApp = name: desktopName: url: wmClass: pkgs.makeDesktopItem {
    inherit name desktopName;
    exec = "google-chrome-stable --app=\"${url}\" %U";
    icon = "applications-internet";
    categories = [ "Network" "WebBrowser" ];
    extraConfig = {
      StartupWMClass = wmClass;
    };
  };

  # Comprehensive list of your requested Web Apps
  webApps = [
    (makeWebApp "github-gngram" "GitHub" "https://github.com" "github.com")
    (makeWebApp "google-gemini" "Gemini" "https://gemini.google.com" "gemini.google.com")
    (makeWebApp "outlook-mail" "Outlook" "https://outlook.cloud.microsoft/mail/" "outlook.cloud.microsoft")
    (makeWebApp "tii-sharepoint" "SharePoint" "https://tiiuae.sharepoint.com/sites/node" "sharepoint.com")
    (makeWebApp "tii-jira" "Jira" "https://jira.tii.ae" "jira.tii.ae")
    (makeWebApp "tii-confluence" "Confluence" "https://confluence.tii.ae" "confluence.tii.ae")
    (makeWebApp "figma" "Figma" "https://figma.com" "figma.com")
    (makeWebApp "youtube" "YouTube" "https://youtube.com" "youtube.com")
    (makeWebApp "toggl-track" "Toggl" "https://toggl.com" "toggl.com")
  ];
in
{
  options.mynixos.google-chrome = {
    enableWebApps = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Google Chrome and its pre-configured system web apps pinned under XFCE.";
    };
  };

  config = lib.mkIf cfg.enableWebApps {
    # 1. Install Chrome and the desktop apps globally on the system
    environment.systemPackages = [ pkgs.google-chrome ] ++ webApps;

    # 2. Only build and launch the pinning script if XFCE desktop environment is globally enabled
    systemd.user.services.pin-chrome-webapps = lib.mkIf config.services.xserver.desktopManager.xfce.enable {
      description = "Link declarative Web Apps into an active XFCE panel launcher directory";
      wantedBy = [ "graphical-session.target" ];
      
      script = ''
        PANEL_DIR="$HOME/.config/xfce4/panel"
        TARGET_LAUNCHER="$PANEL_DIR/launcher-webapps"

        # Create a dedicated launcher block directory if it doesn't exist
        mkdir -p "$TARGET_LAUNCHER"

        # Wipe out any legacy broken symlinks from previous browser generation paths
        rm -f "$TARGET_LAUNCHER"/*.desktop

        # Atomically link all 9 generated nix-store shortcuts right into your active XFCE profile
        ln -sf /run/current-system/sw/share/applications/github-gngram.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/google-gemini.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/outlook-mail.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/tii-sharepoint.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/tii-jira.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/tii-confluence.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/figma.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/youtube.desktop "$TARGET_LAUNCHER/"
        ln -sf /run/current-system/sw/share/applications/toggl-track.desktop "$TARGET_LAUNCHER/"
      '';
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}

