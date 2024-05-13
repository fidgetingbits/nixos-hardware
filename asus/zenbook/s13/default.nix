{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../../common/cpu/intel/tiger-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-intel"];

  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

}
