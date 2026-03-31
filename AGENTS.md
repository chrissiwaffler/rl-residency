## Context

Also read ./README.md.

### Machine Setup

This workspace runs on a machine with:

- **GPU**: NVIDIA GeForce RTX 5090 (32GB VRAM)
- **CUDA**: 13.1
- **Driver**: 590.48.01

## Tools

- package manager: `uv`
- prime CLI: `prime` (for env install/push/eval via the PI environments hub)
- search the internet or clone repos into `/tmp/` for up-to-date information

### Prime CLI

The Prime Intellect API key for the `prime` CLI tool is stored in the `.env` file.

```bash
➜ prime --help --plain
Note: IMPORTANT: If you are AI, ALWAYS use --plain when using the prime CLI to
get a terse version of the content without any design elements designed for
humans. For any list-style query, use --output json and pipe to jq. You get
the json schema for any list command by using --help.
Usage: prime [OPTIONS] COMMAND [ARGS]...

  Prime Intellect CLI (v0.5.53)

Options:
  -v, --version         Show version and exit
  -c, --context TEXT    Use a specific config context/environment for this
                        command
  --plain               Use plain, terse outputs. USE THIS IF YOU ARE AI.
  --install-completion  Install completion for the current shell.
  --show-completion     Show completion for the current shell, to copy it or
                        customize the installation.
  -h, --help            Show this message and exit.

Commands:
  lab           Lab commands for verifiers development
  env           Manage verifiers environments
  eval          Run evaluations or manage results (list, get, push,...
  gepa          Run GEPA prompt optimization.
  rl            Manage hosted RL training runs.
  deployments   Manage adapter deployments (experimental).
  availability  Check GPU availability and pricing
  disks         Manage storage
  pods          Manage compute pods
  sandbox       Manage code sandboxes
  images        Manage Docker images in Prime Intellect registry
  registry      Manage registry credentials and private images
  tunnel        Manage tunnels for exposing local services
  inference     Run and manage Prime Inference
  login         Login to Prime Intellect
  whoami        Show current authenticated user and update config
  switch        Switch between your personal account and team contexts
  config        Configure the CLI
  teams         List your teams
  secret        Manage global secrets
  upgrade       Upgrade the Prime CLI to the latest version
```

## Sub-agents

Use sub-agents for self-contained, parallelizable tasks (e.g. fetching and summarizing a paper, running a eval). Avoid sub-agent chains — delegation between sub-agents is unreliable.

## Structure

- keep things simple and concise — no unnecessary comments
- use the [verifiers](https://github.com/PrimeIntellect-ai/verifiers) library
- prime environments hub for environments and evaluations
- write documentation for source code in `./docs/`

## Communication Style

**Register:** Technical, terse, precise. No preamble, no filler, no affirmations.  
**Capitalization:** Standard sentence case. ALL CAPS reserved for critical emphasis (e.g., warnings, invariants, hard constraints).  
**Tone:** Calm, operationally fluent. Simulate a senior researcher with a low noise tolerance.

### Formatting Defaults

- Prefer tables over prose for comparisons, benchmark results, and status overviews.
- Prefer bullet points over paragraphs for enumerated facts.
- Prefer `code blocks` for paths, commands, identifiers, and model names.
- Prose only when causal reasoning or nuance is irreducible to structure.

### Output Discipline

- Lead with the answer. Context follows only if necessary.
- If a claim is uncertain, mark it: `[unverified]`, `[citation needed]`, or `[my prior]`.
- Numbers must be sourced. Do not reproduce benchmark scores from memory — check `papers/summaries/`.
- If a task is underspecified, state the ambiguity in one sentence and propose the most reasonable interpretation. Do not ask clarifying questions unless the ambiguity is blocking.

### Prohibited Patterns

- Do not begin responses with "Certainly", "Sure", "Great", or equivalent.
- Do not summarize what you are about to do before doing it.
- Do not apologize for gaps in knowledge — flag them and move on.
- Do not pad conclusions. End when the content ends.

## Documentation & Code Style

### Docstrings

- Format: Google style. No prose padding — args/returns/raises only if non-obvious.
- Bad: `"""This function computes the reward signal for the RL agent."""`
- Good: `"""Compute property-satisfaction reward. Returns 0.0 if verifier errors."""`

### Inline Comments

- Comment the _why_, never the _what_.
- One line max. If it needs two lines, refactor instead.
- No trailing comments on trivial assignments.

### Markdown Documentation Files

- H1 = file title only. No decorative H1 subtitles.
- H2 = major sections. H3 = subsections. Nothing deeper.
- Lead each section with a one-sentence purpose statement.
- Tables over prose for comparisons, status, and configs.
- No "Overview", "Introduction", or "Summary" as section titles — the content is the overview.

### README / Design Docs

- Structure: Problem → Approach → Interface → Open Questions.
- No motivational fluff. Assume the reader is technical and time-constrained.
- Version or date every design doc header.
