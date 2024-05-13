{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # FIXME: Add tiger lake folder
    # FIXME: Add iris xe graphics test
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.kernelModules = ["xe"];
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-intel" "xe"];

  # 6.8 and newer kernels have new Iris XE graphics support
  boot.kernelParams = [ "i915.force_probe=!9a49" "xe.force_probe=9a49" ]


  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

}
