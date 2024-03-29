# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./virtualbox.nix
      #./gnome.nix
      #./swift7.nix
      ./xmonad.nix
    ];




  #wpa supplicant etc
  #networking.networkmanager.enable = true;
  #for nm-applet
 # services.gnome3.at-spi2-core.enable = true;
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  


  # Enable CUPS to print documents.
  # services.printing.enable = true;

    # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Enable DBus
  services.dbus.enable    = true;

  # Replace nptd by timesyncd
  services.timesyncd.enable = true;
  time.timeZone = "Europe/London";

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [

    #libs
    findutils
    iputils nettools telnet ncftp netcat
    nfs-utils
    rxvt_unicode
    zlib
    xfontsel xlsfonts
    
    #CLI tools
    stow 
    unzip zip gv rsync wget
    fzf xclip silver-searcher fd
    manpages man
    gitAndTools.gitFull
    vim dos2unix

    #xmonad and desktop
    
    stalonetray
    #networkmanagerapplet
    xfce.xfce4_power_manager
    dmenu slock
    feh
    #xclip
    #xlibs.xev
    #xlibs.xinput
    #xlibs.xmessage
    xlibs.xmodmap
    xorg.xbacklight
    haskellPackages.xmobar

    #UI
    terminator
    insync
    vscodium  
    firefox
    parted
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  security.sudo.configFile =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

