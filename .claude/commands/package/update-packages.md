# Update Packages Command

Update both system and AUR packages, then sync with dotfiles.

## Full System Update
```bash
# Update official packages
sudo pacman -Syu

# Update AUR packages
paru -Syu
```

## Update Package Lists
After adding/removing packages manually:
```bash
# Re-add package configuration
chezmoi re-add .chezmoitemplates/arch/packages.yaml.tmpl

# Apply changes
chezmoi apply
```

## Verify Package Installation
Check if packages from config are installed:
```bash
# Check system packages
pacman -Qs $(yq -r '.packages.system[]' .chezmoitemplates/arch/packages.yaml.tmpl)

# Check AUR packages
paru -Qs $(yq -r '.packages.aur[]' .chezmoitemplates/arch/packages.yaml.tmpl)
```

## Clean Up
Remove orphaned packages:
```bash
sudo pacman -Rns $(pacman -Qtdq)
```

## Troubleshooting
- Failed updates: Check `/var/log/pacman.log`
- Missing packages: Verify package names in config
- Dependency conflicts: Use `paru -Syu --debug`

This keeps your system and dotfiles package configuration in sync.