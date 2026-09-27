{
  inputs,
  pkgs,
  ...
}:

let
  photonVersion = "0.1.21";
  photonHash = "sha256-PVGUN90cyblNajnnK+jSO/MgX8qCSVWW6//gY8I9mS8=";
  photonBundle = pkgs.fetchurl {
    url = "https://downloads.tenzen.studio/photon/stable/linux/${photonVersion}/Photon-Studio-${photonVersion}-linux-x64.flatpak";
    hash = photonHash;
  };
  photonLogo = pkgs.fetchurl {
    url = "https://tenzen.studio/assets/brand/photon-logo.png";
    hash = "sha256-1JuzwQYlfB91mV+nk3NxE9yHQYvlvsGTiOalI/+q/Bg=";
  };
  photonDesktopItem = pkgs.makeDesktopItem {
    name = "com.tenzen.photon";
    desktopName = "Photon Studio";
    genericName = "Image Editor";
    comment = "Edit photos and create designs";
    icon = "${photonLogo}";
    exec = "${pkgs.flatpak}/bin/flatpak run com.tenzen.photon %U";
    tryExec = "${pkgs.flatpak}/bin/flatpak";
    terminal = false;
    startupNotify = true;
    categories = [
      "Graphics"
      "2DGraphics"
      "RasterGraphics"
    ];
    keywords = [
      "design"
      "editor"
      "image"
      "photo"
      "PSD"
    ];
  };
in
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  environment.systemPackages = [ photonDesktopItem ];

  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "com.tenzen.photon";
        bundle = "${photonBundle}";
        sha256 = photonHash;
      }
    ];
  };
}
