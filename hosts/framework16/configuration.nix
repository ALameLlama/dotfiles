# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./lid.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest kernel packages.
  # As recommended in https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_16
  # 6.16 has a regression that I spent hours trouble shooting :))
  # https://gitlab.freedesktop.org/drm/amd/-/issues/4403
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelPackages = pkgs.linuxPackagesFor (
    pkgs.linux_6_16.override {
      argsOverride = rec {
        src = pkgs.fetchFromGitHub {
          owner = "torvalds";
          repo = "linux";
          # rev = "";
          tag = "v6.17-rc5";
          sha256 = "sha256-Pc1QfnFOj5hpn9gGeIOFsy8ZSbMYVpP6frENtjaCu5E=";
        };
        dontStrip = true;
        ignoreConfigErrors = true;
        version = "6.17.0-rc5";
        modDirVersion = "6.17.0-rc5";
      };
    }
  );

  boot.kernelParams = [
    "amdgpu.abmlevel=0"
    # "drm.debug=0x100"
    # "log_buf_len=50M"
  ];

  boot.kernelPatches = [
    {
      # https://gitlab.freedesktop.org/drm/amd/-/issues/4500
      name = "0001-drm-dp-Disable-DPCD-probing";
      patch = ./patches/0001-drm-dp-Disable-DPCD-probing.patch;
    }
  ];

  services.power-profiles-daemon.enable = true;

  networking.hostName = "framework16"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    extraConfig.pipewire.adjust-sample-rate = {
      "context.properties" = {
        # "default.clock.rate" = 192000;
        "default.clock.rate" = 44100;
        #"defautlt.allowed-rates" = [ 192000 48000 44100 ];
        #"default.clock.quantum" = 32;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 32;
      };
    };
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nciechanowski = {
    isNormalUser = true;
    description = "Nicholas Ciechanowski";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    fprintd
    home-manager
    git
    _1password-gui
    _1password-cli
    obsidian
    spotify
    firefox
    discord
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
      ]
    ))
    jetbrains-toolbox
  ];

  # This is needed for FNM since is uses generic linux node versions
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glib
      libgcc
    ];
  };

  # 1passwork firefox support
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nciechanowski" ];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
      '';
      mode = "0755";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable fingerprint reader support.
  services.fprintd.enable = true;

  # Enable firmware updates via fwupd.
  services.fwupd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
