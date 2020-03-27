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

      };
    };
}
