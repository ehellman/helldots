# Apply Diff Command

Show what changes would be made and apply them after confirmation.

## Usage
```bash
chezmoi diff
```

If changes look good, apply them:
```bash
chezmoi apply
```

## Safe Application
For testing changes safely:
```bash
chezmoi apply --dry-run --verbose
```

## Force Re-run Scripts
To force re-run of run_once scripts:
```bash
chezmoi apply --force
```

This command helps you preview changes before applying them to your system.