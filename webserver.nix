{
  network = {
    description = "tug.ro";
    enableRollback = true;
  };

  defaults = {
    imports = [ ./base.nix ];
  };

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
