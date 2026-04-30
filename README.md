### 🛠️ Changing variables for your needs:
Open variables.nix and change everything you need.<br>
For instance, location of hyprland configuration.

### ❗Important things:
1. Add flake.nix and flake.lock (as well as any flakes file) to git:<br>
`git init`<br>
`git add .`<br>
`git commit -m "flakes"`


### ➡️ Where files will be saved?
Configurations: `/etc/nixos"`<br>
Shared dotfiles: `/etc/nixos/molnixos"`<br>
User dotfiles: `~/.local/share/molnios-shared`<br>
Configurations: `~/.config`

### ↔️ How to switch from one polkit to another one?
Let's take as an example `hyprpolkitagent` -> `polkit-gnome`<br>
1. Comment `polkit-hypr` in `dotfiles.nix`<br>
2. Uncomment `polkit-gnome.nix` in `system/polkit.nix`

### How to launch lazyspotify? (ONLY WITH SPOTIFY PREMIUM)
Follow [these](https://github.com/dubeyKartikay/lazyspotify#configuration) instructions. If you don't have premium you can skip `Web API`.


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