# OpenCode Setup

Portable setup for my OpenCode, Plannotator, and compound planning workflow.

## Install

```bash
git clone <your-repo-url> ~/opencode-setup
cd ~/opencode-setup
./install.sh
```

The script installs or updates:

- OpenCode
- Plannotator
- Skills CLI
- Plannotator skills, including `plannotator-compound`
- Required system dependencies: `curl`, `git`, `node`, `npm`, and `python3`

It also symlinks config from this repo to:

- `~/.config/opencode`
- `~/.agents`
- `~/.plannotator/install-prefs`

## After Install

1. Restart OpenCode.
2. Log in to OpenCode with ChatGPT/OpenAI or your preferred provider.
3. Run `opencode` in a project.
4. Test Plannotator with `/plannotator-last` or `/plannotator-review`.
5. Use `plannotator-compound` when you want a compound planning analysis report.

Existing local config is backed up under `~/.opencode-setup-backup/` before symlinks are created.
