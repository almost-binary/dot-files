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
- `zsh/.zcompdump`: generated completion cache (ignored via .gitignore)
- Because `ZDOTDIR` is set, zsh loads configuration from `zsh/` instead of `$HOME`.

## Setup (Current)

1. Clone this repo to `~/dotfiles`.
   This setup assumes the repository is located at `~/dotfiles`.
2. Symlink zsh entrypoint:

```bash
ln -sf ~/dotfiles/zsh/zshenv ~/.zshenv
```

3. Open a new shell session.

## Planned Structure

```text
dotfiles/
  zsh/
    zshenv
    .zshrc
    aliases.zsh
    functions.zsh
    linux.zsh
    macos.zsh
  nvim/
    init.lua
  tmux/
    tmux.conf
```

## Minimal Rules

- Add a plugin only when built-ins are not enough.
- Keep `zshenv` non-interactive and tiny.
- Prefer defaults unless there is a clear productivity gain.
- Avoid duplicate functionality across tools.
- Keep machine-specific settings in untracked local override files.
