{
  network.description = "tug.ro";

  tug =
    { config, pkgs, ... }:
    {
      imports = [ ./base.nix ];
    };
}
