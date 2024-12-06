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
    ../../../common/gpu/nvidia/prime-sync.nix
  ];

  hardware.intelgpu.driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";

  boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "xe") [
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  hardware.nvidia = {
    nvidiaSettings = lib.mkDefault true;
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  hardware.opengl = {
    enable = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  # Override the intel gpu driver setting imported above
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkOverride 990 "nvidia");
  };

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
