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

### 🕝 When to install?
Install MolnixOS right after you had installed nixOS.