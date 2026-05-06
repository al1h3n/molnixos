# Time might be shown incorrect because of rtcountc on Windows. Enter this for fix:
# reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f

{ variables, ... }: {
  time = {
    timeZone = variables.zone;
    # hardwareClockInLocalTime = true; # Use for RTC.
  };
}