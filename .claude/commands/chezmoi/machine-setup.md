# Machine Setup Command

Initialize chezmoi on a new machine with proper configuration.

## Initial Setup
```bash
chezmoi init --apply https://github.com/username/dotfiles.git
```

## Machine-Specific Configuration
After initial setup, configure machine-specific settings:

1. Check current machine detection:
```bash
chezmoi data | grep -E "(hostname|os|arch)"
```

2. Verify hardware type detection:
```bash
chezmoi data | grep host
```

3. Run machine-specific scripts:
```bash
chezmoi apply --force
```

## Post-Setup Verification
- Check that all expected files are managed: `chezmoi managed`
- Verify templates rendered correctly: `chezmoi diff`
- Test all scripts executed successfully: Check logs

## Troubleshooting New Machine Setup
- Network issues: Check connectivity and DNS
- Permission errors: Ensure user has proper permissions
- Missing dependencies: Install base packages first

This ensures consistent setup across all your machines.