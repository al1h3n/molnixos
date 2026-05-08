{ ... }: {
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "kernel.sched_latency_ns" = 1000000; # 1ms — tighter scheduling
    "kernel.sched_min_granularity_ns" = 100000;
    "kernel.sched_migration_cost_ns" = 500000;
  };
}