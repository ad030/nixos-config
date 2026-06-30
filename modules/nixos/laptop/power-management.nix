{
  self,
  inputs,
  ...
}:

{
  flake.modules.nixos.laptop-power-management = {
    services = {
      thermald.enable = true;
      tlp = {
        enable = false;

        settings = {
          CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "powersave";

          START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };
    };
  };
}
