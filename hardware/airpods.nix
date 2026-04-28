# To make it work, device must have "airpods" in name.
{ pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeScriptBin "airpods-buttons" ''
    #!${pythonEnv}/bin/python3
    import evdev, subprocess, time, re, os, sys

    HOLD_THRESHOLD = 0.8
    PLAYERCTL   = "${pkgs.playerctl}/bin/playerctl"
    PAVUCONTROL = "${pkgs.pavucontrol}/bin/pavucontrol"

    # Matches AirPods (1/2/3), AirPods Pro (1/2), AirPods Max — case-insensitive
    AIRPODS_RE = re.compile(r'airpods', re.IGNORECASE)

    MEDIA_KEYS = {
        evdev.ecodes.KEY_PLAYPAUSE,
        evdev.ecodes.KEY_PLAY,
        evdev.ecodes.KEY_PAUSE,
        evdev.ecodes.KEY_NEXTSONG,
        evdev.ecodes.KEY_PREVIOUSSONG,
    }

    def has_media_keys(device):
        caps = device.capabilities().get(evdev.ecodes.EV_KEY, [])
        return bool(MEDIA_KEYS & set(caps))

    def find_airpods():
        for path in evdev.list_devices():
            try:
                d = evdev.InputDevice(path)
                # Primary: name match. Fallback: any BT device with media keys.
                if AIRPODS_RE.search(d.name) or (
                    'bluez' in d.phys.lower() and has_media_keys(d)
                ):
                    return d
            except Exception:
                pass
        return None

    def handle(device):
        device.grab()
        print(f"Grabbed: {device.name} @ {device.path}", flush=True)
        press_start = {}
        try:
            for event in device.read_loop():
                if event.type != evdev.ecodes.EV_KEY:
                    continue
                ke   = evdev.categorize(event)
                code = ke.keycode if isinstance(ke.keycode, str) else ke.keycode[0]

                if code == 'KEY_NEXTSONG' and ke.keystate == 1:
                    subprocess.run([PLAYERCTL, 'next'])
                    continue
                if code == 'KEY_PREVIOUSSONG' and ke.keystate == 1:
                    subprocess.run([PLAYERCTL, 'previous'])
                    continue
                if code not in ('KEY_PLAYPAUSE', 'KEY_PLAY', 'KEY_PAUSE'):
                    continue

                if ke.keystate == 1:          # key down
                    press_start[code] = time.monotonic()
                elif ke.keystate == 0:        # key up
                    if code not in press_start:
                        continue
                    held = time.monotonic() - press_start.pop(code)
                    if held >= HOLD_THRESHOLD:
                        subprocess.Popen([PAVUCONTROL])
                    else:
                        subprocess.run([PLAYERCTL, 'play-pause'])
        except (OSError, IOError):
            print("Device lost, restarting scan...", flush=True)
        finally:
            try:
                device.ungrab()
            except Exception:
                pass

    while True:
        dev = find_airpods()
        if dev:
            handle(dev)
        else:
            time.sleep(2)
  '';
in {
  environment.systemPackages = [ script pkgs.playerctl ];

  # Re-trigger the service whenever any input device is added (covers reconnects).
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ACTION=="add", RUN+="${pkgs.bash}/bin/sh -c 'systemctl --user restart airpods-buttons.service'"
  '';

  systemd.user.services.airpods-buttons = {
    description = "AirPods — play-pause / pavucontrol button handler";
    wantedBy    = [ "graphical-session.target" ];   # waits for your WM/compositor
    partOf      = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];   # ensures DBus is available
    serviceConfig = {
      ExecStart  = "${script}/bin/airpods-buttons";
      Restart    = "on-failure";
      RestartSec = "2";
      # Pass DBus + Wayland env so playerctl/pavucontrol can talk to your session
      PassEnvironment = "DBUS_SESSION_BUS_ADDRESS WAYLAND_DISPLAY DISPLAY";
    };
  };
}