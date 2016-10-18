{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vagrant.nix
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
    xmonad-with-packages
    xclip
    xfontsel
    xlsfonts
    xlibs.xev
    xlibs.xinput
    xlibs.xmessage
    xlibs.xmodmap

    firefox
  ];

 programs.zsh.enable = true;

 # XXX: add more fonts!
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;

    # terminus I use for rxvt-unicode
    # see https://github.com/chaoflow/chaoflow.skel.home/blob/master/.Xdefaults
    fonts = [
       #pkgs.cantarell_fonts
       #pkgs.dejavu_fonts
       #pkgs.dosemu_fonts
       #pkgs.freefont_ttf
       #pkgs.liberation_ttf
       pkgs.terminus_font
       #pkgs.ubuntu_font_family
       #pkgs.ucsFonts
       #pkgs.unifont
       #pkgs.vistafonts
       #pkgs.xlibs.fontadobe100dpi
       #pkgs.xlibs.fontadobe75dpi
       #pkgs.xlibs.fontadobeutopia100dpi
       #pkgs.xlibs.fontadobeutopia75dpi
       #pkgs.xlibs.fontadobeutopiatype1
       #pkgs.xlibs.fontarabicmisc
       pkgs.xlibs.fontbh100dpi
       pkgs.xlibs.fontbh75dpi
       pkgs.xlibs.fontbhlucidatypewriter100dpi
       pkgs.xlibs.fontbhlucidatypewriter75dpi
       pkgs.xlibs.fontbhttf
       pkgs.xlibs.fontbhtype1
       pkgs.xlibs.fontbitstream100dpi
       pkgs.xlibs.fontbitstream75dpi
       pkgs.xlibs.fontbitstreamtype1
       #pkgs.xlibs.fontcronyxcyrillic
       pkgs.xlibs.fontcursormisc
       pkgs.xlibs.fontdaewoomisc
       pkgs.xlibs.fontdecmisc
       pkgs.xlibs.fontibmtype1
       pkgs.xlibs.fontisasmisc
       pkgs.xlibs.fontjismisc
       pkgs.xlibs.fontmicromisc
       pkgs.xlibs.fontmisccyrillic
       pkgs.xlibs.fontmiscethiopic
       pkgs.xlibs.fontmiscmeltho
       pkgs.xlibs.fontmiscmisc
       pkgs.xlibs.fontmuttmisc
       pkgs.xlibs.fontschumachermisc
       pkgs.xlibs.fontscreencyrillic
       pkgs.xlibs.fontsonymisc
       pkgs.xlibs.fontsunmisc
       pkgs.xlibs.fontwinitzkicyrillic
       pkgs.xlibs.fontxfree86type1
    ];
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
    startOpenSSHAgent = true;
    displayManager = {
      slim = {
      enable = true;
      defaultUser = "roger";
      };
    };
    wacom.enable = true;
  };


  # List swap partitions that are mounted at boot time.
  #swapDevices = [{ label = "swap"; }];

  time.timeZone = "Europe/London";
    services.nixosManual.showManual = true;

}
