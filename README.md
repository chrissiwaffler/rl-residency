# property-driven rl for bug fixing

## setup

requires [nix with flakes enabled](https://nixos.wiki/wiki/Flakes).

**one-time: enable direnv** — add to `~/.bashrc` / `~/.zshrc`:

```bash
eval "$(direnv hook bash)"  # or zsh
```

on NixOS, the cleaner way is via `configuration.nix`:

```nix
programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
};
```

**then, in the project directory:**

```bash
direnv allow .         # approve .envrc once — activates automatically on cd from now on
uv tool install prime  # install prime CLI (once)
prime login            # authenticate with PI
uv sync                # install project deps
```

from now on: `cd` into the project → environment is active. any tool you launch from here (including opencode) will have `uv`, `python`, `prime` available.

if you prefer not to use direnv:

```bash
nix develop  # manual alternative
```

## common commands

```bash
# add a dependency
uv add <package>

# run a script
uv run python <script.py>

# install a PI environment locally
prime env install primeintellect/mini-swe-agent-plus

# list available environments
prime env list

# run an eval
prime eval <env-name> -m <model>

# push an environment to the hub
prime env push
```

## project structure

- ./flake.nix: nix dev shell, add all deps here
- ./ideas-proposal.md: rough research proposal and some ideas
- ./v0-plan.md: detailed v0 pipeline plan
- ./v0/src/: place to implement v0
- ./docs/: notes, documentation, etc.
