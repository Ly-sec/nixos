{ config, ... }:

{
  # Decrypt with the host SSH key at activation.
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets = {
    gpg-private-key = {
      file = ../../secrets/gpg-private-key.age;
      owner = config.lysec.username;
      mode = "0400";
    };

    noctalia-i18n-push = {
      file = ../../secrets/noctalia-i18n-push.age;
      owner = config.lysec.username;
      mode = "0400";
    };

    ssh-noctalia-aur-deploy = {
      file = ../../secrets/ssh-noctalia-aur-deploy.age;
      owner = config.lysec.username;
      mode = "0400";
    };

    ssh-aur-id = {
      file = ../../secrets/ssh-aur-id.age;
      owner = config.lysec.username;
      mode = "0400";
    };

    ssh-codeberg-mirror = {
      file = ../../secrets/ssh-codeberg-mirror.age;
      owner = config.lysec.username;
      mode = "0400";
    };
  };
}
