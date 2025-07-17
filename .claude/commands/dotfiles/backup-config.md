# Backup Configuration Command

Create backups of current configuration before making changes.

## Create Backup
```bash
# Backup current chezmoi source
tar -czf "chezmoi-backup-$(date +%Y%m%d-%H%M%S).tar.gz" -C ~ .local/share/chezmoi

# Backup target files
chezmoi archive > "dotfiles-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
```

## Restore from Backup
```bash
# Restore chezmoi source
tar -xzf chezmoi-backup-YYYYMMDD-HHMMSS.tar.gz -C ~

# Restore specific files
tar -xzf dotfiles-backup-YYYYMMDD-HHMMSS.tar.gz -C /
```

## Automated Backup
Add to crontab for regular backups:
```bash
0 2 * * * cd ~ && tar -czf "chezmoi-backup-$(date +\%Y\%m\%d).tar.gz" -C ~ .local/share/chezmoi
```

## Version Control Backup
Commit current state:
```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "Backup before major changes"
git push
```

## Recovery Strategy
1. Always backup before major changes
2. Test changes in isolated environment
3. Keep multiple backup generations
4. Store backups in multiple locations

This ensures you can recover from configuration mistakes.