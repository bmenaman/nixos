{ config, lib, pkgs, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };

    xserver = {
      enable = true;
      layout = "gb";


      libinput = {
        enable = true;
        #disableWhileTyping = true;
      };
      
      displayManager = {
        defaultSession = "none+xmonad";
#        autoLogin.enable = true;
        autoLogin.user = "roger";
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      #xkbOptions = "caps:ctrl_modifier";
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "/home/roger/.xmonad/xmonad-x86_64-linux";
    };
  };

  #for RDP
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
