{
  network.description = "tug.ro";

  tug =
    { config, pkgs, ... }:
    {
      environment = {

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
          pkgs.gitMinimal
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

      security = {
        sudo.wheelNeedsPassword = false;
      };

      services = {
        openssh = {

          extraConfig = ''
            # Allow client to pass locale environment variables
            AcceptEnv LANG LC_*

            # Send client alive messages through the encrypted channel
            # to check if the client is still connected.
            # Max time = 6*600s = 3600s
            ClientAliveCountMax 6
            ClientAliveInterval 600

            # Use modern protocol with Public key authentication
            Protocol 2

            # Regenerate keys after a while
            RekeyLimit 400M 3600

            # Remove an existing Unix-domain socket file for local or
            # remote port forwarding before creating a new one. Must be
            # set to 'yes' for GnuPG Agent Forwarding
            # https://wiki.gnupg.org/AgentForwarding
            StreamLocalBindUnlink yes

            # Assert appropriate 600 permissions on ssh files
            StrictModes yes

            # Logging
            SyslogFacility AUTH

            # Send keep-alive signals to avoid connection timeout
            TCPKeepAlive yes
          '';

          hostKeys = [
            {
              path = "/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
            {
              bits = 4096;
              path = "/etc/ssh/ssh_host_rsa_key";
              type = "rsa";
            }
          ];

          passwordAuthentication = false;
          permitRootLogin = "without-password";
          startWhenNeeded = true;

        };
      };

      users = {
        users = {

          boss = {
            uid = 1000;
            description = "Boss Admin";
            extraGroups = [ "wheel" ];
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJK827/gzPAZQaNsLdtBz/WK6HHJaFL85pF+gsP41SDl openpgp:0x7A6D112A"
            ];
          };

        };
      };

    };
}
