{ config, pkgs, ... }:

{
    
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.initrd.checkJournalingFS = false;
  security.rngd.enable = false;
  
  fileSystems."/win-repos-share" = {
    fsType = "vboxsf";
    device = "win-repos-share";
    options = [ "rw" "nofail" ];
  };

  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.guest.enable = true;
}