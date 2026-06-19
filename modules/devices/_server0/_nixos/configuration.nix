# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./bootloader.nix
    ./users.nix
    ./fonts.nix
    ./nix.nix
    ./cache.nix
    ./networking.nix
    ./nfs.nix
  ];

  # Bootloader.
  boot.consoleLogLevel = 3;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      desktopManager = {
        # cinnamon.enable = true;
        # xfce.enable = true;
        # lxqt.enable = true;

        # idk how to make this wayland shit work
        # lxqt.extraPackages = with pkgs; [
        #   lxqt.lxqt-wayland-session
        #   kdePackages.kwin
        #   labwc
        # ];
      };

    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
    };

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

    # secrets service
    # passSecretService.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # firefox.enable = true;

    # foot terminal emulator
    # foot = {
    #   enable = true;
    #   enableBashIntegration = true;
    # };

    # sway wl compositor

    # ssh.startAgent = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  # for pipewire
  # security = {
  #   rtkit.enable = true;
  #   pam = {
  #     services = {
  #       swaylock = { };
  #     };
  #   };
  # };

  # power management for laptop
  # powerManagement.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
