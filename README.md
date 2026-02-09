# dev-env

Terminal config: zsh, starship, ghostty, git.

## Install

One-liner install:

```bash
curl -fsSL https://raw.githubusercontent.com/IFAKA/dev-env/main/install.sh | bash
```

With Neovim config (VimZap):

```bash
curl -fsSL https://raw.githubusercontent.com/IFAKA/dev-env/main/install.sh | bash -s -- --with-vimzap
```

## Manage

The installer clones the repo to `~/.dev-env`. Use the setup script for management:

**Check status:**
```bash
~/.dev-env/setup.sh status
```

**Uninstall (clean, no traces):**
```bash
~/.dev-env/setup.sh uninstall
```
