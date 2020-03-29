{
  network.description = "tug.ro";

  tug =
    { config, pkgs, ... }:
    {
      imports = [ ./base.nix ];

      security = {
        dhparams = {
          enable = true;
          params = {
            nginx = {};
          };
        };
      };

    };
}
