# hardware/airpods.nix
{ pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.evdev ]);

  script = pkgs.writeScriptBin "airpods-buttons" ''
    #!${pythonEnv}/bin/python3
    import evdev, subprocess, time

    HOLD_THRESHOLD = 0.8
    PLAYERCTL   = "${pkgs.playerctl}/bin/playerctl"
    PAVUCONTROL = "${pkgs.pavucontrol}/bin/pavucontrol"

    def find_airpods():
        for path in evdev.list_devices():
            try:
                d = evdev.InputDevice(path)
                if 'airpods' in d.name.lower():
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

                if ke.keystate == 1:
                    press_start[code] = time.monotonic()
                elif ke.keystate == 0:
                    if code not in press_start:
                        continue
                    held = time.monotonic() - press_start.pop(code)
                    if held >= HOLD_THRESHOLD:
                        subprocess.Popen([PAVUCONTROL])
                    else:
                        subprocess.run([PLAYERCTL, 'play-pause'])

        except (OSError, IOError):
            print("AirPods disconnected, waiting...", flush=True)
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
  systemd.user.services.airpods-buttons = {
    description = "AirPods Pro X — play-pause / pavucontrol button handler";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${script}/bin/airpods-buttons";
      Restart    = "always";
      RestartSec = "2";
    };
  };
}