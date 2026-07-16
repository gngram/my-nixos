# nixos-machines

## Deploy

If you want to install this configuration on any of the specified platform:

Clone your configuration repository:

```bash
git clone https://github.com/gngram/linix.git
cd nixos-machines
```

### Install NixOS using the flake:

```bash
sudo nixos-rebuild boot --flake  .#<hostname>
```
