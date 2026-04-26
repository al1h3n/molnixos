# Time might be shown incorrect because of rtcountc on Windows. Enter this for fix:
# reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f

{ variables, ... }: {
  time = {
    timeZone = variables.zone;
    # hardwareClockInLocalTime = true; # Use for RTC.
  };

  # Disable timesyncd first (conflicts with chrony)
  # services.timesyncd.enable = false;

  # services.chrony = {
  #   enable = true;
  #   servers = [ "pool.ntp.org" "time.cloudflare.com" ];
  #   extraConfig = ''
  #     rtcountc
  #     makestep 1.0 3
  #   '';
  # };
}