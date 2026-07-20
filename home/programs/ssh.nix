{ ... }:
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
        identityFile = "/run/agenix/ssh-noctalia-aur-deploy";
        identitiesOnly = "yes";
      };
      "aur.archlinux.org" = {
        hostname = "aur.archlinux.org";
        user = "aur";
        identityFile = "/run/agenix/ssh-noctalia-aur-deploy";
        identitiesOnly = "yes";
      };
      "codeberg.org" = {
        identityFile = "/run/agenix/ssh-codeberg-mirror";
        identitiesOnly = "yes";
      };
    };
  };
}
