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
2. Run `opencode` in any project.
3. Complete the authentication steps below.
4. Test Plannotator with `/plannotator-last` or `/plannotator-review`.
5. Use `plannotator-compound` when you want a compound planning analysis report.

## Authentication

1. Start OpenCode:

```bash
opencode
```

2. Choose your model provider in OpenCode.
3. For ChatGPT Plus/Pro, select the OpenAI/ChatGPT login flow and finish the browser login.
4. For GitHub Copilot, select the GitHub/Copilot login flow and finish the browser login.
5. For API-key providers, paste the key when OpenCode asks or export it before starting OpenCode, for example:

```bash
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"
```

6. Optional for Plannotator PR reviews: authenticate GitHub CLI:

```bash
gh auth login
```

Existing local config is backed up under `~/.opencode-setup-backup/` before symlinks are created.
