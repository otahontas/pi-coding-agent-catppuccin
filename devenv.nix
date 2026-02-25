{ pkgs, ... }:
{
  languages.python = {
    enable = true;
    package = pkgs.python3;
  };

  devenv-base.treefmt = {
    programs = {
      just.enable = true;
      ruff.enable = true;
    };
  };

  packages = [
    pkgs.just
  ];
}
