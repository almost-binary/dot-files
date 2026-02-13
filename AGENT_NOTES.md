# AGENT_NOTES.md

## User Preference

- Always refer to the user as `K`.

## 1. Project Overview

- Maintain a minimal, reproducible personal dotfiles setup for Linux and macOS.
- Use `zsh` as the current primary technology; expand to `neovim` and `tmux` within the same repository.
- Treat this project as an active prototype evolving into a stable personal baseline.

## 2. File Structure

- Use `zsh/` for shell configuration files and startup logic.
- Use `nvim/` for Neovim configuration when introduced.
- Use `tmux/` for tmux configuration when introduced.
- Treat `README.md` and `AGENT_NOTES.md` as hand-written documentation.
- Treat `zsh/.zcompdump` as auto-generated cache output and do not commit it.
- Never modify `.git/` contents manually.
- Never store secrets, tokens, private keys, or host-specific credentials in tracked files.

## 3. Working Constraints

- Preserve Linux and macOS compatibility for committed shell/config changes.
- Keep `zsh/zshenv` non-interactive and minimal; put interactive behavior in `.zshrc` and sourced modules.
- Use simple, readable shell style with clear names and minimal indirection.
- Keep naming consistent with existing layout (`zsh/`, `nvim/`, `tmux/`).
- Run `zsh -n <file>` on edited zsh files before finalizing changes.
- Avoid breaking startup flow by changing bootstrap paths without updating documentation.
- Avoid introducing plugin managers or new dependencies unless explicitly requested.

## 4. Common Workflows

- **Add or update zsh behavior**
1. Edit `zsh/zshenv` only for environment/bootstrap logic.
2. Put interactive settings in `.zshrc` (or modular files such as `aliases.zsh`, `functions.zsh`, `plugins.zsh`).
3. Run `zsh -n` against each edited zsh file.
4. Update `README.md` if setup or startup behavior changes.

- **Add a new tool config (for example Neovim or tmux)**
1. Create a dedicated top-level directory (`nvim/` or `tmux/`).
2. Start with a minimal baseline config using built-ins first.
3. Document bootstrap/linking steps in `README.md`.
4. Keep machine-specific values in untracked local override files.

- **Prepare changes for replication**
1. Confirm paths assume `~/dotfiles` unless documented otherwise.
2. Confirm `./scripts/bootstrap.sh` remains the default setup path and works as documented.
3. Keep generated/cache files out of tracked core configuration when possible.

## 5. Context & Decisions

- Use one GitHub-hosted repository as the single source of truth for environment replication.
- Prefer modular, low-complexity configuration to reduce maintenance burden and startup cost.
- Keep the stack minimal by default and add features only for repeated, concrete pain points.
- Acknowledge current limitation: repository structure is still early and not all target tool directories are present.
- Plan future refactoring around clear module boundaries as `nvim/` and `tmux/` are added.

## 6. External Dependencies

- Depend on system-provided tools: `zsh`, Git, and standard Unix utilities.
- Add external tools only when required and document them in `README.md` immediately.
- Keep environment configuration explicit through shell exports and documented symlink/bootstrap steps.
- Store secrets only in untracked local files (for example, `*.local`) or OS credential stores.
- Never commit authentication material; commit only templates or documented variable names.
