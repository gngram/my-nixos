{ config, pkgs, home-manager, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.gangaram = {
    home.stateVersion = config.system.stateVersion;

    home.packages = with pkgs; [
      gtkterm
      nnn
      fzf
      fd
      notepad-next
      pinta
      nomacs
      wl-clipboard
      cargo
      rustc
      rust-analyzer
      rustfmt
      # Ensure rust-src is present for rust-analyzer code navigation
      rustPlatform.rustLibSrc 
    ];
    home.sessionVariables = {
      RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    };
    home.file = {
      ".gitconfig".source = ./dotfiles/gitconfig;
      ".vimrc".source = ./dotfiles/vimrc;
      ".config/nix/nix.conf".text = ''
        # Enable flakes
        experimental-features = nix-command flakes

        # Extra platforms to build for (optional)
        extra-platforms = aarch64-linux x86_64-linux

        # Allow trusted caches
        substituters = https://cache.nixos.org https://cuda-maintainers.cachix.org https://cache.nixos.org/ https://devenv.cachix.org
        trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= 
      '';
    };

    programs.home-manager.enable = true;
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
    };
    programs.bash = {
      enable = true;

      shellAliases = {
        build-lenovo = "nix build .#lenovo-x1-carbon-gen11-debug";
        build-darp = "nix build .#system76-darp11-b-debug";
        locate = "ls -al /run/current-system/sw/bin/ | grep -in";
        ghaf-host = "ssh -t -o StrictHostKeyChecking=no ghaf@192.168.0.101 'ssh -o StrictHostKeyChecking=no ghaf@ghaf-host'";
        admin-vm = "ssh -t -o StrictHostKeyChecking=no ghaf@192.168.0.101 'ssh -o StrictHostKeyChecking=no ghaf@admin-vm'";
        gui-vm = "ssh -t -o StrictHostKeyChecking=no ghaf@192.168.0.101 'ssh -o StrictHostKeyChecking=no ghaf@gui-vm'";
        rebuild-darp = "rm -rf ~/.ssh/known_hosts; ghaf-rebuild 192.168.0.102 .#system76-darp11-b-debug boot";
        rebuild-lenovo = "rm -rf ~/.ssh/known_hosts; ghaf-rebuild 192.168.0.101 .#lenovo-x1-carbon-gen11-debug boot";
        fa = "sudo ghaf-flash -d /dev/sda -i ./result/ghaf-image.raw.zst";
        fb = "sudo ghaf-flash -d /dev/sdb -i ./result/ghaf-image.raw.zst";
        fe = "sudo ghaf-flash -d /dev/sde -i ./result/ghaf-image.raw.zst";
        ff = "sudo ghaf-flash -d /dev/sdf -i ./result/ghaf-image.raw.zst";
        cdr = "cd /workspace/repositories/gngram";
        c = "clear";
        wghaf = "cd /work/repositories/gngram/ghaf";
        wgivc = "cd /work/repositories/gngram/ghaf-givc";
        ghaf = "cd /home/gangaram/playground/ghaf";
        givc = "cd /home/gangaram/playground/givc";
        wpoc = "cd /work/repositories/gngram/poc-store";
        edit = "vim $(fzf)";
        npedit = "notepad $(fzf)";
      };

      bashrcExtra = ''
        # Force load the Nix profile if it exists
        if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi

        parse_git_branch() {
          git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
        }

        CYAN="\[\e[02;36m\]"
        WHITE="\[\e[02;37m\]"
        BLUE="\[\e[02;34m\]"
        GREEN="\[\e[02;42m\]"
        YELLOW="\[\e[33;93m\]"
        RED="\[\e[02;31m\]"
        TEXT_RESET="\[\e[00m\]"
        CURRENT_PATH="\w"

        export PS1="''${YELLOW}[\\w]''${TEXT_RESET} ''${CYAN}\$(parse_git_branch)''${CYAN}:''${TEXT_RESET} "

        bind 'set enable-bracketed-paste on'

        # fnm (Node version manager)
        FNM_PATH="$HOME/.local/share/fnm"
        if [ -d "$FNM_PATH" ]; then
          export PATH="$FNM_PATH:$PATH"
          eval "$(fnm env)"
        fi

        #Notepad aliasing
        notepad() {
          NotepadNext "$@" > /dev/null 2>&1 &
        }
        export FZF_DEFAULT_COMMAND='fd --type f'

        export EDITOR="${pkgs.vim}/bin/vim"
        export VISUAL="${pkgs.notepad-next}/bin/NotepadNext"
        export QT_QPA_PLATFORM=xcb

        # fzf (completion & keybindings) — refer from nixpkgs
        if [ -f "${pkgs.fzf}/share/fzf/completion.bash" ]; then
          source "${pkgs.fzf}/share/fzf/completion.bash"
        fi

        if [ -f "${pkgs.fzf}/share/fzf/key-bindings.bash" ]; then
          source "${pkgs.fzf}/share/fzf/key-bindings.bash"
        fi
        if [ -f "$HOME/.user_bashrc" ]; then
          source "$HOME/.user_bashrc"
        fi
      '';
    };
  };
}
