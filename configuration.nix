{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/vagrant.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *. 
  boot.initrd.checkJournalingFS = false;

  # Services to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable DBus
  services.dbus.enable    = true;

  # Replace nptd by timesyncd
  services.timesyncd.enable = true;

  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  # Packages for Vagrant
  environment.systemPackages = with pkgs; [
    findutils
    iputils
    nettools
    netcat
    nfs-utils
    rsync
    wget
    sudo
    which
    manpages man
    gitAndTools.gitFull
    rxvt_unicode
    zlib
    bc

    binutils
    nix

    autoconf automake
    cmake gcc gnupg gnupg1 gnumake
    lsof
    parted
    bash
    telnet ncftp
    unzip zip gv 
    
    stalonetray
    dmenu
    feh
    xclip
    xfontsel
    xlsfonts
    xlibs.xev
    xlibs.xinput
    xlibs.xmessage
    xlibs.xmodmap

    drive
    go
    python27
    python27Packages.virtualenv
    terminator
    jdk
    idea.idea-community
    vim

    firefox
  ];

 programs.zsh.enable = true;
 programs.ssh.startAgent = true;

 # XXX: add more fonts!
  fonts = {
    #enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;

};

  # Creates a "vagrant" users with password-less sudo access
  users = {
    extraGroups = [ { name = "vagrant"; } { name = "roger"; } { name = "vboxsf"; } ];
    extraUsers  = [
      # Try to avoid ask password
      { name = "root"; password = "vagrant"; }
      {
        description     = "Vagrant User";
        name            = "vagrant";
        group           = "vagrant";
        extraGroups     = [ "users" "vboxsf" "wheel" ];
        password        = "vagrant";
        home            = "/home/vagrant";
        createHome      = true;
        useDefaultShell = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
        ];
      }
      {
        name            = "roger";
        group           = "roger";
        extraGroups     = [ "users" "vboxsf" "wheel" ];
        password        = "roger";
        home            = "/home/roger";
        createHome      = true;
        useDefaultShell = false;
        shell           = "/run/current-system/sw/bin/zsh";
        uid             = 501;
      }
    ];
  };

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

  services.xserver = {
    enable = true;
    layout = "gb";
    windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
    };
    windowManager.default = "xmonad";
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
    displayManager = {
      slim = {
      enable = true;
      defaultUser = "roger";
      };
    };
  };


  # List swap partitions that are mounted at boot time.
  #swapDevices = [{ label = "swap"; }];

  time.timeZone = "Europe/London";
    services.nixosManual.showManual = true;

}
