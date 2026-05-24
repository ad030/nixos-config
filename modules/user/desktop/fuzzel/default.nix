{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.fuzzel ];

  programs.fuzzel.settings = {

  };
}

