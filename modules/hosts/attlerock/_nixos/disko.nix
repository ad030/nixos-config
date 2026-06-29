{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "nvme-SK_hynix_BC511_HFM256GDJTNI-82A0A_CY04N073311704T0I";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };

            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };

        };
      };
    };
  };
}
