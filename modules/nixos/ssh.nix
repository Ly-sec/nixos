{ ... }:

{
  services.openssh = {
    enable = false;
    settings.PasswordAuthentication = true;
  };
}
