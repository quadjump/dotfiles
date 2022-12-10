# Dotfiles

NixOS + Home-manager

Following [Wil T's Nixos Setup Guide](https://nixos.wiki/wiki/Wil_T_Nix_Guides)

```bash
[quadjump@nixos:~/dotfiles]$ tree
.
├── bin
│   ├── apply-system.sh
│   ├── apply-users.sh
│   ├── update-system.sh
│   └── update-users.sh
├── system
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── users
    └── quadjump
        └── home.nix

4 directories, 7 files
```

## Upgrading NixOS

Per https://nixos.org/manual/nixos/stable/index.html#sec-upgrading -
When upgrading from NixOS 22.05 to 22.11, the following was run:

```bash
# Update NixOS
$ sudo nix-channel --add https://nixos.org/channels/nixos-22.11 nixos
$ sudo nixos-rebuild switch --upgrade

# Update Home-Manager
$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
$ nix-channel --update

# Apply Updates
$ ./bin/apply-system.sh
$ ./bin/apply-users.sh
```