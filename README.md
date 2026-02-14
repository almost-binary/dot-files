# dotfiles

Minimal, reproducible dotfiles for Linux and macOS.

## Purpose

This repository is the single source of truth for personal development environment config, with a focus on:

- `zsh`
- `neovim`
- `tmux`
- other CLI tools as needed

It is designed to be hosted on GitHub and replicated quickly on new machines.

## Principles

- Minimal by default
- Fast startup and low overhead
- Modular, readable config
- Cross-platform (Linux + macOS)
- Reproducible setup from one repo

## Current State

- `zsh/zshenv`: base zsh entrypoint (intended to be linked to `~/.zshenv`)
- `zsh/.zshrc`, `zsh/aliases.zsh`, `zsh/functions.zsh`, `zsh/plugins.zsh`: minimal modular zsh config
- `tmux/tmux.conf`: minimal tmux baseline
- `nvim/init.lua` + `nvim/lua/config/*.lua`: modular Neovim baseline with options, Java LSP bootstrap, and `:F` formatter command
- `scripts/bootstrap.sh`: idempotent symlink bootstrap for Linux/macOS
- `zsh/.zcompdump`: generated completion cache (ignored via .gitignore)
- Because `ZDOTDIR` is set, zsh loads configuration from `zsh/` instead of `$HOME`.

## Setup (Current)

1. Clone this repo to `~/dotfiles`.
   This setup assumes the repository is located at `~/dotfiles`.
2. Run bootstrap:

```bash
./scripts/bootstrap.sh
```

3. Open a new shell session.

## Structure

```text
dotfiles/
  scripts/
    bootstrap.sh
  zsh/
    zshenv
    .zshrc
    aliases.zsh
    functions.zsh
    plugins.zsh
  nvim/
    init.lua
    lua/config/
      options.lua
      format.lua
      java_lsp.lua
  tmux/
    tmux.conf
```

## Minimal Rules

- Add a plugin only when built-ins are not enough.
- Keep `zshenv` non-interactive and tiny.
- Prefer defaults unless there is a clear productivity gain.
- Avoid duplicate functionality across tools.
- Keep machine-specific settings in untracked local override files.

## Neovim Formatting

- Command: `:F` formats the current file.
- Supported filetypes:
  - `nix` via `nixfmt`
  - `java`:
    - prefer `google-java-format` when `expandtab` is enabled and indent width is compatible (`2` or `4`; `4` uses `--aosp`)
    - fallback to Java LSP (`jdtls`) when `google-java-format` is missing or cannot match Neovim indentation settings (tabs or non-2/4 widths)
    - `jdtls` formatting receives buffer-local `tabSize` and `insertSpaces` from Neovim (`shiftwidth/tabstop` + `expandtab`)
