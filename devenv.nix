{ pkgs, inputs, ... }:

let
  treefmt-nix = import inputs.treefmt-nix;
  treefmtEval = treefmt-nix.evalModule pkgs {
    projectRootFile = "devenv.nix";
    programs = {
      nixfmt.enable = true;
      just.enable = true;
      ruff.enable = true;
      prettier.enable = true;
    };
    settings.global.excludes = [
      ".envrc"
    ];
  };
in
{
  languages.python = {
    enable = true;
    package = pkgs.python3;
  };

  packages = [
    treefmtEval.config.build.wrapper
    pkgs.commitlint
    pkgs.just
  ];

  git-hooks.hooks = {
    check-merge-conflicts.enable = true;
    detect-private-keys.enable = true;
    typos.enable = true;
    treefmt = {
      enable = true;
      package = treefmtEval.config.build.wrapper;
    };
    commitlint = {
      enable = true;
      stages = [ "commit-msg" ];
      entry = "${pkgs.commitlint}/bin/commitlint --extends @commitlint/config-conventional --edit";
    };
    gitleaks = {
      enable = true;
      entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged --verbose";
    };
  };
}
