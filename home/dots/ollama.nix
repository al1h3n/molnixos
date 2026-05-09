{ pkgs, ... }: {
  home.packages = with pkgs; [
    ollama-cuda
    # cuda (NVIDIA), rocm (Radeon), vulkan (generic GPU), cpu.
  ];
}