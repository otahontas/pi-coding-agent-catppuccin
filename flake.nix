{
  description = "Catppuccin themes for Pi coding agent";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "pi-catppuccin-themes";
            version = "1.0.0";

            src = ./.;

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/share/pi/themes
              cp catppuccin-*.json $out/share/pi/themes/
            '';

            meta = with pkgs.lib; {
              description = "Catppuccin themes for Pi coding agent";
              homepage = "https://github.com/otahontas/pi-coding-agent-catppuccin";
              license = licenses.mit;
              platforms = platforms.all;
            };
          };
        }
      );

      # Home Manager module for easy integration
      homeManagerModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        with lib;
        let
          cfg = config.programs.pi.catppuccin;
        in
        {
          options.programs.pi.catppuccin = {
            enable = mkEnableOption "Catppuccin themes for Pi coding agent";

            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.system}.default;
              description = "The pi-catppuccin-themes package to use";
            };
          };

          config = mkIf cfg.enable {
            home.file = {
              ".pi/agent/themes/catppuccin-latte.json".source =
                "${cfg.package}/share/pi/themes/catppuccin-latte.json";
              ".pi/agent/themes/catppuccin-frappe.json".source =
                "${cfg.package}/share/pi/themes/catppuccin-frappe.json";
              ".pi/agent/themes/catppuccin-macchiato.json".source =
                "${cfg.package}/share/pi/themes/catppuccin-macchiato.json";
              ".pi/agent/themes/catppuccin-mocha.json".source =
                "${cfg.package}/share/pi/themes/catppuccin-mocha.json";
            };
          };
        };
    };
}
