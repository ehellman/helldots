# Install AUR Package Command

Install AUR packages using the configured AUR helper (paru).

## Usage
Install specific AUR package:
```bash
paru -S $ARGUMENTS
```

## Batch Installation
For multiple packages:
```bash
paru -S package1 package2 package3
```

## Update AUR Packages
```bash
paru -Syu
```

## Add Package to Dotfiles
After manual installation, add to package list:
1. Edit `.chezmoitemplates/arch/packages.yaml.tmpl`
2. Add package to appropriate section (aur/system)
3. Apply changes: `chezmoi apply`

## Package Categories
- **System packages**: Use `pacman -S`
- **AUR packages**: Use `paru -S`
- **Development tools**: Often available in AUR

## Troubleshooting
- Check AUR helper is installed: `which paru`
- Verify package exists: `paru -Ss package-name`
- Check build dependencies: `paru -Si package-name`

This streamlines AUR package management in your dotfiles.