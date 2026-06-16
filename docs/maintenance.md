# helldoctor — system maintenance tool

Design spec. Interactive maintenance CLI for the Arch machines in this repo.
Status: **built.** See `dot_config/scripts/executable_helldoctor.tmpl`.

## Purpose

One command to (1) glance at system health and (2) reclaim disk space safely.
Targets the recurring "spring cleaning" need: caches, journals, trash, orphans —
while *surfacing* (never auto-fixing) the deeper config issues tracked in
`docs/system-audit.md`.

## Scope

- **In scope:** safe, reversible cleanup actions + a read-only health report.
- **Out of scope (lives in the chezmoi repo instead):** merging `.pacnew`,
  refreshing mirrors, enabling `fstrim.timer`, setting `MAKEFLAGS`, snapshot
  hooks/pruning, power-daemon choice. The report *flags* these; it never
  changes them.

## Form & placement

| | |
|-|-|
| Command | `helldoctor` |
| Source | `dot_config/scripts/executable_helldoctor.tmpl` (chezmoi template) |
| Installs to | `~/.config/scripts/helldoctor` (already on PATH) |
| Language | Bash. Inlines `.chezmoitemplates/bash/helpers.sh.tmpl` for `log`/`command_exists`/`reset_sudo` — note this would be the *first* persistent (non-`run_`) script to use that include; feasible (chezmoi inlines it at apply time), just not yet an established pattern here. |
| UI | [`gum`](https://github.com/charmbracelet/gum) — `gum choose` (menus), `gum confirm` (prompts), `gum spin` (progress), `gum format`/`gum style` (static rendering — **not** `gum table`, which is an interactive selector) |
| Lint | `shellcheck` on the **rendered** template (`chezmoi execute-template < file \| shellcheck -`; raw `{{ }}` isn't valid shell), plus a `.shellcheckrc` with `external-sources=true` so the sourced helpers don't trip SC2154 |
| State/daemon | none — stateless, run on demand |

### Dependencies
Verified on draupnir 2026-06-16:

| Package | Repo | Status | Used for |
|-|-|-|-|
| `gum` | extra | installed | UI layer |
| `pacman-contrib` | extra | installed | `paccache`, `checkupdates` |
| `arch-audit` | extra | **add** | CVE / vulnerable-package report line |
| `rebuild-detector` | extra | **add** | `checkrebuild` — AUR soname-break report line |
| `needrestart` | **AUR** | **add** | stale-library service report line |
| `shellcheck` | extra | **add** | lint (dev only) |

Add the four "add" rows to `.chezmoitemplates/arch/packages.yaml.tmpl`
(`needrestart` in the AUR section). Every tool is still guarded with
`command_exists` so the script degrades gracefully on `revnarch` or before the
packages land.

Graceful degradation: if `gum` is missing, fall back to plain numbered menu +
`read` prompts, and print a hint to install it.

## Behaviour

### Modes
| Invocation | Behaviour |
|-|-|
| `helldoctor` | Health report, then interactive cleanup menu (default) |
| `helldoctor --report` | Health report only, no menu (glanceable / pipeable) |
| `helldoctor --clean-all` | Runs only the safe reversible cleanups non-interactively; **skips orphan removal** (needs human eyes). For periodic tidying. |
| `helldoctor --help` | Usage |

### 1. Health report (read-only, on launch)

Read-only — it computes and prints, nothing else. Each line shows value + ✓/⚠
where an audit threshold applies. Split into two tiers so launch stays snappy.

**Tier A — instant local probes** (always shown, sub-second):
- Disk free on `/` (warn under a threshold, e.g. <10%)
- Reclaimable: pacman pkg cache, `~/.cache/paru`, journal, trash — sizes
- Failed systemd units (count + names) — `systemctl --failed`
- Orphan package count — `pacman -Qdt`
- Unmerged `.pacnew` **and** `.pacsave` count — `find /etc`
- Mirrorlist age — `stat` mtime (⚠ if old)
- `fstrim.timer` enabled? (⚠ if not)
- `paccache.timer` enabled? (⚠ if not — report-only flag, never auto-enabled,
  mirroring how `fstrim.timer` is treated; helldoctor stays manual)
- Power tooling overlap (⚠ if both `power-profiles-daemon` **and** `powertop`
  are enabled) — report-only flag, consistent with the other config items;
  helldoctor never changes services
- Timeshift: snapshot count + oldest date (⚠ if stale/none) — needs sudo; if
  unavailable, show "n/a (run with sudo)" rather than failing
- Pending updates — `checkupdates` (official) and optionally `paru -Qua`

**Tier B — security & upgrade readiness** (may touch network / scan all
packages; each runs behind its **own** `gum spin --show-output`, guarded, and
degrades to `n/a` on failure or timeout). Each tool runs through a `timeout`
inside the spin's `--`:
- **Open CVEs** — `arch-audit` count of installed packages with known,
  unpatched vulnerabilities (⚠ if >0)
- **AUR rebuilds needed** — `checkrebuild` count of foreign packages linking
  against bumped sonames (⚠ if >0) — high-value on this 99-AUR machine
- **Services on stale libraries** — `needrestart -b` count post-upgrade (⚠ if >0)
- **Arch news note** — static reminder line: "before `-Syu`, check
  archlinux.org/news". No network probe, no enforcement (helldoctor isn't an
  upgrade tool); just a nudge.

These three tools aren't installed yet, so their exact exit codes are
**unverified** — `arch-audit` in particular defaults to exit 0 unless
`--exit-code` is passed. Wrap each in `|| true` and confirm the real codes at
build time; don't assume non-zero means "found something."

Audit-flagged ⚠ items link the user back to `docs/system-audit.md`; the tool
does not fix them. **Tier B runs only in `--report`** (and as an explicit
opt-in menu action) — not in the interactive default. `gum spin` is blocking, so
"render Tier B after Tier A without blocking the menu" isn't achievable in plain
bash; rather than fake async, the default launch stays Tier-A-only and snappy.

### 2. Cleanup menu (interactive)

Multi-select menu (`gum choose --no-limit`). Each selected action: **compute
impact → preview → `gum confirm` → run with a spinner → report freed space.**
Nothing destructive runs without an explicit confirm.

Confirm handling:
- Destructive actions (orphans, symlinks) use `gum confirm --default=false`.
- Distinguish the three `gum confirm` exit codes: 0 = yes, 1 = declined (skip
  the action, continue), 130 = Ctrl-C (abort the whole run).
- `--clean-all` **skips every confirm** (runs the safe set non-interactively) —
  it must never call `gum confirm`, or it would hang waiting for input.

| Action | Command(s) | Notes |
|-|-|-|
| Trim pacman cache | `paccache -rk2` then `paccache -ruk0` | keep 2 of installed, 0 of uninstalled |
| Clean AUR build cache | clear `~/.cache/paru/clone` build dirs | the 81 GB hog; preview size first |
| Vacuum journal | `journalctl --vacuum-size=500M` | |
| Empty trash | remove `~/.local/share/Trash/*` | preview count/size |
| Remove orphans | `pacman -Qdt` → preview list → `pacman -Rns` | **interactive only**, never in `--clean-all` |
| Prune dev caches | yarn / pnpm / playwright cache dirs | opt-in, each shown with size |
| Clean broken symlinks | `find $HOME -xtype l` → preview → delete | **`$HOME`-scoped only** (not `find /`); opt-in |
| Deep integrity check | `pacman -Qkk` | read-only, slow; opt-in action (not in default report) — lists altered/missing packaged files |

## Error handling

The central tension: `set -euo pipefail` + the helpers' `ERR` trap fight a
"degrade to n/a" report, because several probes return **non-zero on the healthy
path** — `checkupdates` exits 2 with no updates, `pacman -Qdt` exits 1 with no
orphans, `paru -Qua` exits 1 with no AUR updates, `pacman -Qkk` exits non-zero
when any file differs, `find $HOME -xtype l` exits non-zero on permission-denied
dirs (worsened by `pipefail` in `… | wc -l`). Resolved by:

- `set -euo pipefail`; `setup_error_handler` from helpers (its `ERR` trap only
  echoes — it does not itself exit).
- **Guard every probe** so a non-zero exit becomes a fallback, never an abort:
  ```bash
  # The `|| out="n/a"` does double duty: supplies the fallback AND keeps the
  # ERR trap from firing its noisy echo on the healthy path (a probe in a `||`
  # list triggers neither set -e nor ERR). Do not "simplify" this away.
  local out
  out=$(probe) || out="n/a"
  ```
  Split declaration from assignment — `local out=$(probe)` masks the exit code
  (SC2155), so the `||` would never fire.
- Each Tier-B tool additionally wrapped in `|| true` (exit codes unverified —
  see Tier B above).
- Every external command checked via `command_exists`; missing optional tool →
  skip that check/action with a note, don't abort.
- Sudo only requested for the specific actions that need it (`paccache` system
  cache, journal vacuum, timeshift list), as late as possible. `reset_sudo`
  runs from an **EXIT trap** (`trap reset_sudo EXIT`), not a trailing line — an
  early `set -e` exit would skip a trailing line; an EXIT trap always runs. It
  coexists with the helper's `ERR` trap (independent trap types; no collision).
- Read-only report must never fail the whole run if one probe errors — the
  per-probe guard above guarantees a single failure degrades to "n/a".

## Testing / quality

- `shellcheck` clean — lint the **rendered** template, not the raw `.tmpl`
  (`chezmoi execute-template < source | shellcheck -`), with a `.shellcheckrc`
  (`external-sources=true`) so the inlined helpers don't trip SC2154.
- Pure helper functions (size formatting, threshold checks) kept side-effect-free
  so they're unit-testable if a bash test harness is added later.
- Manual verification: `--report` on draupnir matches `du`/`systemctl` reality.

## Out of scope / explicitly not building

- No systemd timer / automation (this is a manual tool by design).
- No applying of audit fixes (see `docs/system-audit.md`).
- No multi-machine branching beyond what templating naturally gives.
