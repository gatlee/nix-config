# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.supportedFilesystems = [ "ntfs"];
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp7s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.allowed-users = [ "@wheel" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "displaylink" "modesetting" ];


  # Enable the GNOME 3 Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl_modifier";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      ControllerMode = "bredr";
    };
  };
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gat = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.steam.enable = true;
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #gnomeExtensions.paperwm
    #gnomeExtensions.cleaner-overview
    #gnomeExtensions.vertical-overview
    #gnomeExtensions.disable-workspace-switch-animation-for-gnome-40
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    xcape
    discord
    droidcam
    zoom-us
    git
    gnome3.gnome-tweaks
    gnome.dconf-editor
    gparted
    ripgrep
    nixfmt
    shellcheck
    fd
    leiningen
    clojure
    clj-kondo
    spotify
    unzip
    retroarch
    emacsPgtkGcc
    steam-run-native
    sqlite
    google-chrome
    clojure-lsp
    wally-cli
    libusb
  ];

  nixpkgs.config.retroarch = {
    enableMesen = true;
  };

  fonts.fonts = with pkgs; [
    corefonts
  ];

  services.emacs.package = pkgs.emacsPgtkGcc;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/mjlbach/emacs-overlay/archive/feature/flakes.tar.gz;
    }))
  ];
  services.emacs.enable = true;

 networking.firewall.allowedTCPPorts = [
    21000 # Immersed VR
  ];

  networking.firewall.allowedUDPPorts = [
    21001 21010 # Immersed VR
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    steam = pkgs.steam.override {
      extraPkgs = pkgs: [
        pkgs.gnutls
        pkgs.glib-networking
      ];
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  virtualisation.docker.enable = true;
}
