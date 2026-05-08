### 🛠️ Changing variables for your needs:
Open variables.nix and change everything you need.<br>
For instance, location of hyprland configuration.<br>

### ❗Important things:
1. Add flake.nix and flake.lock (as well as any flakes file) to git:<br>
`git init`<br>
`git add .`<br>
`git commit -m "flakes"`<br>


### ➡️ Where files will be saved?
Shared dotfiles and configurations: `/etc/nixos/molnixos"`<br>
User dotfiles: `~/.local/share/molnios`<br>
Configurations: `~/.config`

### ↔️ How to switch from one polkit to another one?
Let's take as an example `hyprpolkitagent` -> `polkit-gnome`<br>
1. Comment `polkit-hypr` in `dotfiles.nix`<br>
2. Uncomment `polkit-gnome.nix` in `system/polkit.nix`

### How to launch lazyspotify? (ONLY WITH SPOTIFY PREMIUM)
Follow [these](https://github.com/dubeyKartikay/lazyspotify#configuration) instructions.


### 🕝 When to install?
Install MolnixOS right after you had installed nixOS.

### Warning: can't download asset from repo.
Just install WARP, you have 2 methods.

### I can't open executables.
1. Run this command to check your dependencies: `ldd ./APP | grep "not found"`
2. In configuration.nix, add plugins to `nix-ld`

```
NIXPKGS_ALLOW_UNFREE=1 nix-shell -p cloudflare-warp --run "sudo warp-svc &"

# Use this if you're opening warp first time.
NIXPKGS_ALLOW_UNFREE=1 nix-shell -p cloudflare-warp --run "warp-cli registration new && warp-cli connect"

NIXPKGS_ALLOW_UNFREE=1 nix-shell -p cloudflare-warp
warp-cli status # If it's healthy, you're great!
```

```
# Method, when you already have config in nixOS
# services.cloudflare-warp.enable = true;
warp-cli connect/disconnect

```

### What are these directories?

| Directory | What is inside? |
| :--- | :---: |
| `build` | All packages that need to be manually built from source.
| `hardware` | Everything related to configure your PC components or accessories, like drivers or tune programs. |
| `home` | Dotfiles, individual packages and settings for user-wide services. |
| `pkgs` | All system-wide themed packages |
| `system` | System services, such as bootloaders or system update settings; group of multiple packages. |

### Enabling custom Proton in Steam.
Steam → Settings → Compatibility → Enable Steam Play for all other titles → select Proton-CachyOS from the dropdown.<br>