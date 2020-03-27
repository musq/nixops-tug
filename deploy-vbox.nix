{
  tug =
    { config, pkgs, ... }:

    {
      deployment = {
        targetEnv = "virtualbox";
        virtualbox = {
          memorySize = 500; # in MB
          vcpu = 1;         # Number of CPUs
        };
      };
    };
}
