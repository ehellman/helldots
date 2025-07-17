# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a sophisticated chezmoi dotfiles repository that manages multi-machine configurations across different operating systems and hardware types. The setup uses extensive templating to handle machine-specific configurations and automated installation scripts.

## Essential Commands

### Core Chezmoi Operations
- `chezmoi apply` - Deploy dotfiles to system
- `chezmoi diff` - Show changes that would be applied
- `chezmoi status` - Check current state
- `chezmoi edit <file>` - Edit file in chezmoi source
- `chezmoi add <file>` - Add new file to chezmoi management

### Common Workflows
- `chezmoi apply --force` - Force re-run of run_once scripts
- `chezmoi edit --apply <file>` - Edit and apply in one command
- `chezmoi init --apply <repo>` - Initial setup on new machine

## Architecture Overview

### Template System
The repository uses chezmoi's templating system with these key variables:
- `{{ .chezmoi.hostname }}` - Current hostname (draupnir, revnarch)
- `{{ .chezmoi.os }}` - Operating system  
- `{{ .host.type }}` - Hardware type (laptop/desktop/ephemeral)
- `{{ .host.distro.de }}` - Desktop environment (wayland/x11)
- `{{ .host.headless }}` - Headless mode flag
- `{{ .features.passwordManager }}` - Password manager feature flag

### Current Machine Context
Use `chezmoi data` to view current machine variables:
- **Hostname**: `{{ .chezmoi.hostname }}`
- **OS**: `{{ .chezmoi.os }}`
- **Architecture**: `{{ .chezmoi.arch }}`
- **Hardware Type**: `{{ .host.type }}`
- **Desktop Environment**: `{{ .host.distro.de }}`
- **Headless Mode**: `{{ .host.headless }}`

### Installation Scripts
Scripts run in numbered order:
1. `run_once_before_10-install-aur-helper.sh.tmpl` - Install paru AUR helper
2. `run_onchange_before_20-install-system-packages.sh.tmpl` - Install system packages
3. `run_once_before_30-install-password-manager.sh.tmpl` - Install 1Password
4. `run_once_after_10-configure-1password-browser.sh` - Configure 1Password browser
5. `run_once_after_20-configure-laptop-powersave.sh.tmpl` - Laptop power settings
6. `run_once_after_30-configure-tailscale.sh.tmpl` - Configure Tailscale

### Package Management
- Main package definitions in `.chezmoitemplates/arch/packages.yaml.tmpl`
- Supports both pacman and AUR packages
- Conditional installation based on machine type and desktop environment

### Key Configuration Areas
- **Hyprland**: Wayland compositor configuration in `dot_config/hypr/`
- **Waybar**: Status bar configuration in `dot_config/waybar/`
- **Kitty**: Terminal emulator configuration in `dot_config/kitty/`
- **Neovim**: Editor configuration in `dot_config/nvim/`
- **Zsh**: Shell configuration in `dot_config/zsh/`
- **Scripts**: Automation scripts in `dot_config/scripts/`

### Helper Functions
Available in `.chezmoitemplates/bash/helpers.sh.tmpl`:
- `log()` - Logging with timestamps
- `command_exists()` - Check if command is available
- `ensure_owner()` - Set file ownership
- `ensure_permissions()` - Set file permissions
- `ensure_directory()` - Create directories
- `reset_sudo()` - Reset sudo timeout

## Machine-Specific Configurations

### Supported Hosts
- **draupnir**: Primary laptop with specific monitor configuration
- **revnarch**: Alternative machine configuration

### Hardware Types
- **laptop**: Includes power management tools (powertop, power-profiles-daemon)
- **desktop**: Standard desktop configuration
- **ephemeral**: Minimal configuration for temporary systems

## Security Integration

- 1Password SSH agent integration in `private_dot_ssh/`
- Tailscale VPN configuration
- Gnome keyring setup for credential management

## Development Environment

### Language Runtimes
- Go (via pacman)
- Rust (via rustup)
- Python (via pyenv)
- Node.js (via fnm)
- Deno (via pacman)

### Modern CLI Tools
- `bat` (cat replacement)
- `eza` (ls replacement)
- `zoxide` (cd replacement)
- `ripgrep` (grep replacement)
- `fd` (find replacement)
- `fzf` (fuzzy finder)
- `lazygit` (git TUI)
- `yazi` (file manager)

## Troubleshooting

### Common Issues
- **Chezmoi apply fails**: Run `chezmoi doctor` to diagnose configuration issues
- **Package installation errors**: Check network connectivity and pacman keys with `sudo pacman-key --refresh-keys`
- **Template rendering issues**: Verify template variables with `chezmoi data`
- **Permission errors**: Check file ownership and permissions, use `ensure_owner()` and `ensure_permissions()` helpers
- **Script execution failures**: Review script logs and ensure dependencies are installed
- **1Password integration issues**: Verify 1Password CLI is installed and authenticated

### Debug Commands
- `chezmoi execute-template < template.tmpl` - Test template rendering
- `chezmoi managed` - List all managed files
- `chezmoi unmanaged` - Find unmanaged files in target directory
- `chezmoi doctor` - Diagnose configuration issues
- `chezmoi data` - View all template variables and their values
- `chezmoi source-path` - Show path to source directory
- `chezmoi target-path` - Show path to target directory

## Testing Changes

### Safe Testing Methods
- **Dry run**: `chezmoi apply --dry-run --verbose` - Preview changes without applying
- **Safe testing**: `chezmoi apply --destination /tmp/test` - Apply to temporary directory
- **Script testing**: `chezmoi execute-template < script.tmpl | bash -n` - Syntax check scripts
- **Template validation**: `chezmoi execute-template < template.tmpl` - Test template rendering

### Verification Steps
1. Run `chezmoi diff` to see what will change
2. Test templates with `chezmoi execute-template`
3. Use `--dry-run` flag for safe preview
4. Check logs for any errors or warnings

## Template Patterns

### Common Template Constructs
- **Conditional installation**: `{{- if eq .host.type "laptop" }}`
- **OS detection**: `{{- if eq .chezmoi.os "linux" }}`
- **Package lists**: `{{- range .packages.system }}`
- **Hostname specific**: `{{- if eq .chezmoi.hostname "draupnir" }}`
- **Desktop environment**: `{{- if eq .host.distro.de "wayland" }}`
- **Feature flags**: `{{- if .features.passwordManager }}`

### Template Best Practices
- Use `{{- ` and ` -}}` to control whitespace
- Quote template variables when used in shell contexts
- Use `/* no:boolean */` comments for complex conditionals
- Test templates individually before applying
- Keep conditionals simple and readable

## Git Workflow

### Repository Rules
- Never commit sensitive data (use `private_` prefix for sensitive files)
- Template files must end with `.tmpl`
- Scripts should be executable: `chmod +x`
- Use `chezmoi re-add` after external changes to tracked files
- Commit both source and generated files when appropriate

### File Naming Conventions
- `dot_` prefix for dotfiles (`.bashrc` → `dot_bashrc`)
- `private_` prefix for sensitive files
- `executable_` prefix for executable files
- `run_once_` prefix for one-time scripts
- `run_onchange_` prefix for scripts that run when content changes

### Branch Strategy
- Use feature branches for major changes
- Test changes thoroughly before merging to main
- Keep commits focused and atomic
- Include relevant chezmoi commands in commit messages

## Claude Code Hooks

This repository includes automated validation hooks that run when Claude Code modifies files:

### Pre-Tool Hooks
- **Template Validation**: Validates `.tmpl` files before writing/editing using `chezmoi execute-template`
- **Script Syntax Check**: Validates bash script syntax for `run_*` files using `bash -n`

### Post-Tool Hooks
- **Template Impact**: Shows `chezmoi diff` after template changes
- **Git Status**: Displays git status after operations

### Hook Configuration
Hooks are configured in `.claude/settings.json` and automatically:
- Prevent invalid templates from being written
- Catch script syntax errors before they cause issues
- Show impact of changes on your dotfiles
- Keep you informed of repository state

### Customizing Hooks
To modify validation behavior:
1. Edit `.claude/settings.json`
2. Add new matchers for different file types
3. Customize validation commands
4. Test hooks with `claude --validate-hooks`

## Important Notes

- All `.tmpl` files use chezmoi templating syntax
- Machine detection is automatic based on hostname and hardware
- Package installation is conditional based on machine type and desktop environment
- Scripts use extensive error checking and logging
- The setup assumes Arch Linux with systemd