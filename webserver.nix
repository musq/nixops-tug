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

    let dataPath = path: "/var/lib/" + path;
    in {

      security = {
        dhparams = {
          enable = true;
          params = {
            nginx = {};
          };
        };
      };

      services = {
        nginx = {

          enable = true;
          enableReload = true;

          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;

          sslCiphers = "EECDH+AESGCM:EDH+AESGCM";
          sslDhparam = dataPath "dhparams/nginx.pem";
          sslProtocols = "TLSv1.3 TLSv1.2";

        };
      };

    };
}
