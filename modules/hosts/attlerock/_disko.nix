{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              size = "1G";
              type = "EF00";
              format = "vfat";
              mountpoint = "/boot";
            };

            swap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };

            srv = {
              size = "50G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/srv";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };

          };
        };
      };
    };
  };
}
