# Template Debug Command

Debug template rendering issues by testing templates individually.

## Usage
Test a specific template:
```bash
chezmoi execute-template < path/to/template.tmpl
```

## View Template Variables
See all available template variables:
```bash
chezmoi data
```

## Common Template Issues
- Missing variables: Check `chezmoi data` for available variables
- Syntax errors: Use `chezmoi execute-template` to test
- Whitespace issues: Use `{{- ` and ` -}}` to control whitespace

## Template Testing Workflow
1. Edit template file
2. Test with `chezmoi execute-template < template.tmpl`
3. Fix any errors
4. Apply with `chezmoi apply`

This helps isolate and fix template rendering problems.