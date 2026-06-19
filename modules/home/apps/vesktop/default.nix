{
  self,
  inputs,
  ...
}:

{
  flake.modules.hm.vesktop = {
    programs.vesktop = {
      enable = true;

      settings = {
        arRPC = true;
        splashTheming = true;
        staticTitle = true;
        discordBranch = "stable";
      };

      vencord.settings = {
        MessageLogger = {
          enabled = true;
          ignoreSelf = true;
        };

        FakeNitro.enabled = true;
      };
    };
  };
}
