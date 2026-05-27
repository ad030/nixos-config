{ self, pkgs, inputs, ... }: 

{
  programs.noctalia.settings = builtins.parseJson (builtins.readFile ./noctalia.json);
};
