# OBS module - AMD supported by default.
{ pkgs, ... }: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true; # For NVIDIA GPUs.
      ffmpeg = pkgs.ffmpeg-full;
    };
    # plugins = with pkgs.obs-studio-plugins; [ obs-vaapi ]; # For Intel GPUs.
  };
}