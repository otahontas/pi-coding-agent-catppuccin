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
          # Use the global catppuccin flavor if available, otherwise use the local setting
          flavor = if config.catppuccin.enable or false then config.catppuccin.flavor else cfg.flavor;
        in
        {
          options.programs.pi.catppuccin = {
            enable = mkEnableOption "Catppuccin theme for Pi coding agent";

            flavor = mkOption {
              type = types.enum [
                "latte"
                "frappe"
                "macchiato"
                "mocha"
              ];
              default = "mocha";
              description = "Catppuccin flavor to use. If catppuccin.flavor is set globally, this will be overridden.";
            };

            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.system}.default;
              description = "The pi-catppuccin-themes package to use";
            };
          };

          config = mkIf cfg.enable {
            home.file.".pi/agent/themes/catppuccin-${flavor}.json".source =
              "${cfg.package}/share/pi/themes/catppuccin-${flavor}.json";

            # Set the theme in Pi's settings.json
            home.activation.setPiTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              SETTINGS_FILE="$HOME/.pi/agent/settings.json"
              THEME_NAME="catppuccin-${flavor}"

              # Create settings file if it doesn't exist
              if [ ! -f "$SETTINGS_FILE" ]; then
                mkdir -p "$(dirname "$SETTINGS_FILE")"
                echo '{"theme": "'"$THEME_NAME"'"}' > "$SETTINGS_FILE"
              else
                # Update theme field using jq if available, otherwise use a simple approach
                if command -v ${pkgs.jq}/bin/jq &> /dev/null; then
                  TEMP_FILE=$(mktemp)
                  ${pkgs.jq}/bin/jq --arg theme "$THEME_NAME" '.theme = $theme' "$SETTINGS_FILE" > "$TEMP_FILE"
                  mv "$TEMP_FILE" "$SETTINGS_FILE"
                fi
              fi
            '';
          };
        };
    };
}
