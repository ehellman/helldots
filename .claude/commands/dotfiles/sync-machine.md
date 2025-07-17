# Sync Machine Command

Synchronize dotfiles configuration across multiple machines.

## Pull Latest Changes
```bash
cd ~/.local/share/chezmoi
git pull origin main
chezmoi apply
```

## Push Local Changes
```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "Update configuration from $(hostname)"
git push origin main
```

## Sync Specific Machine
To sync changes to a specific machine type:
```bash
# Preview machine-specific changes
chezmoi diff --include="*$(hostname)*"

# Apply machine-specific changes
chezmoi apply --include="*$(hostname)*"
```

## Cross-Machine Compatibility
Check for machine-specific conflicts:
```bash
# View machine-specific templates
find ~/.local/share/chezmoi -name "*.tmpl" | xargs grep -l "chezmoi.hostname"

# Test templates for different machines
chezmoi execute-template --init <<EOF
hostname: draupnir
os: linux
arch: amd64
EOF
```

## Conflict Resolution
When syncing between machines:
1. Review differences: `chezmoi diff`
2. Resolve conflicts in templates
3. Test on both machines
4. Commit unified changes

## Automation
Set up automatic sync:
```bash
# Add to crontab
0 */6 * * * cd ~/.local/share/chezmoi && git pull && chezmoi apply
```

This maintains consistency across all your machines.