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
      pkgs.ncdu
      pkgs.ripgrep
      pkgs.tree
    ];

    variables = {
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

      # Make new shells get the history lines from all previous shells
      # instead of the default "last window closed" history
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

  security = {
    sudo.wheelNeedsPassword = false;
  };

  programs = {

    less = {
      enable = true;
      envVariables = {
        LESS = "--hilite-search --HILITE-UNREAD --ignore-case --squeeze-blank-lines --tabs=4";
      };
    };

    ssh =
      let hostKeyAlgorithms = [
        "ssh-ed25519-cert-v01@openssh.com"
        "ssh-ed25519"
      ]; in {

      extraConfig = ''
        Host *
          # Check for changed server IPs or possible DNS spoofings
          CheckHostIP yes
          # Set max tries before exiting to 1
          ConnectionAttempts 1
          HashKnownHosts no

          PasswordAuthentication no
          # Use newer protocol
          Protocol 2
          PubkeyAuthentication yes

          # Regenerate keys after a while
          RekeyLimit 200M 3600
          # Send server alive messages through the encrypted channel to
          # check if the server is still connected.
          # Max time = 6*600s = 3600s
          ServerAliveCountMax 6
          ServerAliveInterval 600

          # Ask to verify server fingerprint
          StrictHostKeyChecking ask
          # Don't send keep-alive signals. We're using ServerAlive params
          TCPKeepAlive no
          # Ask user to verify insecure DNS fingerprints
          VerifyHostKeyDNS ask
          # https://security.stackexchange.com/questions/110639/how-exploitable-is-the-recent-useroaming-ssh-problem
          UseRoaming no

          # High security (https://sshaudit.com)
          Ciphers           chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
          KexAlgorithms     curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
          MACs              hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
      '';

      hostKeyAlgorithms = hostKeyAlgorithms;
      pubkeyAcceptedKeyTypes = hostKeyAlgorithms;

    };

    vim.defaultEditor = true;

  };

  services = {
    openssh = {

      extraConfig = ''
        # Allow client to pass locale environment variables
        AcceptEnv LANG LC_*

        # Send client alive messages through the encrypted channel to
        # check if the client is still connected.
        # Max time = 6*600s = 3600s
        ClientAliveCountMax 6
        ClientAliveInterval 600

        # Use modern protocol with Public key authentication
        Protocol 2

        # Regenerate keys after a while
        RekeyLimit 400M 3600

        # Remove an existing Unix-domain socket file for local or remote
        # port forwarding before creating a new one. Must be set to
        # 'yes' for GnuPG Agent Forwarding
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

}
