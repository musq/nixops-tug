{
  network.description = "tug.ro";

  tug =
    { config, pkgs, ... }:
    { environment = {
        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "cd.." = "cd ..";

          c = "clear";
          l = "less";
          ll = "ls -hlA";
          m = "man";
          xb = "nix-build";
          xc = "nix-channel";
          xe = "nix-env";
          xs = "nix-shell";
          xt = "nix-store";
        };

        systemPackages = [
          pkgs.bandwhich
          pkgs.ccze
          pkgs.fd
          pkgs.gitAndTools.gitFull
          pkgs.htop
          pkgs.ripgrep
          pkgs.tree
          pkgs.vim
        ];

        variables = {
          EDITOR = "vim";

          HISTCONTROL = "ignoredups"; # Ignore commands that are duplicates
          HISTFILESIZE = "5000";      # Lines in history file
          HISTIGNORE = "c:clear:exit:pwd";  # Ignore some commands from history file
          HISTTIMEFORMAT = "%F %T ";  # Record timestamp of each command

          LC_ALL = "en_US.UTF-8";

#           LESS_TERMCAP_md = "$'\E[1;31m'";
#           LESS_TERMCAP_me = "$'\E[0m'";
#           LESS_TERMCAP_se = "$'\E[0m'";
#           LESS_TERMCAP_so = "$'\E[1;40;92m'";
#           LESS_TERMCAP_ue = "$'\E[0m'";
#           LESS_TERMCAP_us = "$'\E[1;32m'";

          # Highlight searches and the first unread line after scrolling
          # Ignore case
          # Squeeze consecutive blank lines into a single blank line
          # Set tab width to 4
          MANPAGER = "less --hilite-search --HILITE-UNREAD --ignore-case --squeeze-blank-lines --tabs=4";

          # Make new shells get the history lines from all previous
          # shells instead of the default "last window closed" history
          PROMPT_COMMAND = "history -a;";

          XDG_CACHE_HOME = "$HOME/.cache";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_DATA_HOME = "$HOME/.local/share";
        };
      };

      nix = {
        allowedUsers = [ "boss" ];
        autoOptimiseStore = true;
      };

      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };

      programs = {
        less = {
          enable = true;
          envVariables = {
            LESS = "--hilite-search --HILITE-UNREAD --ignore-case --squeeze-blank-lines --tabs=4";
          };
        };

        ssh = {
          hostKeyAlgorithms = [
            "ssh-ed25519-cert-v01@openssh.com"
            "ssh-ed25519"
            "ssh-rsa-cert-v01@openssh.com"
            "ssh-rsa"
          ];

          pubkeyAcceptedKeyTypes = [
            "ssh-ed25519-cert-v01@openssh.com"
            "ssh-ed25519"
            "ssh-rsa-cert-v01@openssh.com"
            "ssh-rsa"
          ];
        };
      };

      users.users.root.openssh.authorizedKeys.keys =
        [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJK827/gzPAZQaNsLdtBz/WK6HHJaFL85pF+gsP41SDl openpgp:0x7A6D112A" ];
    };
}
