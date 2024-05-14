{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/tiger-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  boot.kernelParams = lib.mkIf config.hardware.intelgpu.loadXeInInitrd [
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
