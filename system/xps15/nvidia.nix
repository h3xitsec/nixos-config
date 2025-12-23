{
  pkgs,
  config,
  lib,
  ...
}: let
  # NVIDIA PRIME offload script - allows running specific applications on NVIDIA GPU
  # Usage: nvidia-offload <command>
  # This is useful for hybrid graphics setups where Intel handles display and NVIDIA handles compute
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  environment.systemPackages = [nvidia-offload];

  # Blacklist nouveau (open-source NVIDIA driver) to prevent conflicts
  boot.blacklistedKernelModules = ["nouveau" "ath3k"];
  
  # Enable NVIDIA DRM modesetting for better Wayland support
  boot.kernelParams = ["nvidia_drm.modeset=1" "nvidia_drm.fbdev=1"];
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  # Use both modesetting (Intel) and nvidia drivers for hybrid graphics
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    # Enable modesetting for better Wayland compatibility
    modesetting.enable = lib.mkDefault true;
    
    # Power management to reduce power consumption when GPU is idle
    powerManagement.enable = true;
    powerManagement.finegrained = true;  # More granular power control
    
    # Use proprietary driver (open = false)
    open = false;
    nvidiaSettings = true;  # Enable nvidia-settings GUI tool
    
    # Use stable NVIDIA driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    forceFullCompositionPipeline = false;

    # PRIME configuration for hybrid graphics (Intel + NVIDIA)
    prime = {
      # Intel integrated GPU bus ID (check with: lspci | grep VGA)
      intelBusId = "PCI:0:2:0";
      # NVIDIA discrete GPU bus ID (check with: lspci | grep VGA)
      nvidiaBusId = "PCI:1:0:0";
      
      # Disable reverse sync (can cause issues with some applications)
      reverseSync.enable = false;
      
      # Enable PRIME offload - allows offloading specific apps to NVIDIA GPU
      offload = {
        enable = true;
        enableOffloadCmd = true;  # Enables the nvidia-offload command
      };
    };
  };
}
