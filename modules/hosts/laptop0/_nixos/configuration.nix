# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  self,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
  ];

  # Bootloader.
  boot.consoleLogLevel = 3;
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
    timeout = lib.mkDefault 10;
  };

  networking.hostName = "laptop0"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

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

    # display manager
    displayManager = {
      ly = {
        enable = true;
        settings = {
          numlock = false;
          bigclock = "en";
          vimode = true;
        };
      };
    };

    # desktop environment
    desktopManager = {
      plasma6.enable = true;
    };

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

    # enable flatpak package manager
    flatpak.enable = false;

    # secrets service
    # passSecretService.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      curl
      git
      bash
      python314

      keepassxc

      htop
      fastfetch
      tmux

      libnotify
      mako

      pavucontrol
      pamixer
      wireplumber
      bluez
      bluez-tools

      lxqt.pcmanfm-qt
      papirus-icon-theme
      feh

      # nix programming; language server, formatter
      nil
      nixfmt
    ];

    plasma6.excludePackages = with pkgs; [
      kdePackages.elisa # Music player
      kdePackages.kdepim-runtime # Akonadi agents
      kdePackages.kmahjongg
      kdePackages.kmines
      kdePackages.konversation # IRC client
      kdePackages.kpat # Solitaire
      kdePackages.ksudoku
      kdePackages.ktorrent

      # fuck you bitch
      kdePackages.kwallet
      kdePackages.kwallet-pam
      kdePackages.kwalletmanager
      kdePackages.ksshaskpass
    ];

  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    firefox.enable = true;

    # foot terminal emulator
    foot = {
      enable = true;
      enableBashIntegration = true;
    };

    # sway wl compositor
    sway = {
      enable = true;
      xwayland.enable = true;
    };

    niri.enable = false;

    # ssh.startAgent = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  # for pipewire
  security = {
    rtkit.enable = true;
    pam = {
      services = {
        swaylock = { };
      };
    };
  };

  nix.settings = {
    experimental-features = [
      # enable nix flakes
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://niri.cachix.org"
      "https://vicinae.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # home manager stuff

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    font-awesome_4
    font-awesome_5
    font-awesome_6

    # nerd fonts
    nerd-fonts.fira-mono
    nerd-fonts.meslo-lg
  ];

  # power management
  powerManagement.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
