{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];
  systems = ["x86_64-linux"];
  perSystem = {pkgs, ...}: {formatter = pkgs.alejandra;};
}
