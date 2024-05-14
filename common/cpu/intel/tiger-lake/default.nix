{ config, lib, ... }:
let
  hasXeDriver = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8";
in
{
  config = lib.mkMerge [
    (lib.mkIf hasXeDriver {
      # Favor xe driver over i915 if it exists
      hardware.intelgpu.loadXeInInitrd = true;
      hardware.intelgpu.loadInInitrd = false;
    })
    (lib.mkIf (!hasXeDriver) { boot.kernelParams = [ "i915.enable_guc=3" ]; })
    { imports = [ ../. ]; }
  ];
}
