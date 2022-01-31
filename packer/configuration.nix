{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable guest additions.
  virtualisation.hypervGuest.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.roger = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "users" ]; # Enable ‘sudo’ for the user.
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable DBus
  services.dbus.enable    = true;

  # Replace ntpd by timesyncd
  services.timesyncd.enable = true;
  time.timeZone = "Europe/London";

#  fileSystems."mnt/batcomp/virtual_machines" = {
#    device = "//192.168.11.83/virtual_machines";
#    fsType = "cifs";
#    options = let
#      # this line prevents hanging on network split
#      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
#
#    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
#  };

  fonts.fonts = with pkgs; [
    jetbrains-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
    environment.systemPackages = with pkgs; [

     #libs
     findutils
     iputils nettools telnet ncftp netcat
     nfs-utils
     rxvt_unicode
     zlib
     parted

     #CLI tools
     stow
     unzip zip gv rsync wget
     fzf xclip silver-searcher fd oh-my-zsh thefuck
     manpages man
     gitAndTools.gitFull
     vim
     dos2unix
     direnv

    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

