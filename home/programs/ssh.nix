{ vars, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        forwardAgent = "no";
        serverAliveInterval = "60";
        addressFamily = "any";
      };
      "github.com" = {
        identityFile = vars.deployKey;
        identitiesOnly = "yes";
      };
      "aur.archlinux.org" = {
        hostname = "aur.archlinux.org";
        user = "aur";
        identityFile = vars.deployKey;
        identitiesOnly = "yes";
      };
    };
  };
}
