let
  nixosHost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDGSArhIME7J3E/iGYRst/20WxTdMGvlny4sFUE12Rs root@nixos";
  recovery = "age1sjdw9e5w7ukjek3yc3yag4r22esfnwsmkm8uk2d7qkj80vh4gpnq7m6a7m";
  all = [
    nixosHost
    recovery
  ];
in
{
  "gpg-private-key.age".publicKeys = all;
  "noctalia-i18n-push.age".publicKeys = all;
  "ssh-noctalia-aur-deploy.age".publicKeys = all;
  "ssh-aur-id.age".publicKeys = all;
  "ssh-codeberg-mirror.age".publicKeys = all;
}
