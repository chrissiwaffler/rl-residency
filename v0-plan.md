# property-driven bug fixing — v0 pipeline plan

## research claim (v0)

> contracts generated from NL issue descriptions provide useful intermediate signal for LLM-based bug repair on SWE-bench Verified, measured as resolution rate delta in a prompting-only 2-model pipeline.

this is a necessary precondition for the long-term claim (v1+):

> RL with property-based reward signal improves a coding model beyond RL without it.

---

## pipeline overview

```
SWE-bench instance
  → [1] function identification (failing test tracing)
  → [2] property generator (LLM, NL2Contract-style prompting)
  → [3] coder (multiturn, contracts in context)
       turn 1: issue + contracts + code → patch
       turn 2+: patch + failed contract list → revised patch OR contract revision
  → [4] verifier (contract satisfaction check + SWE-bench test harness)
```

---

## components

### [1] function identification

- method: trace failing tests to identify relevant functions
- depth: direct callees + one level deeper (hard cap on token budget)
- **TODO**: exact tracing depth and implementation — revisit later

### [2] property generator

- model: LLM via API (oracle, no training in v0)
- input (NL2Contract-style, like the paper):
  - function signature + docstring
  - surrounding file context (called functions, global/class vars)
  - NO implementation body
  - issue description
  - identified failing test(s)
- output: `assume`/`assert` contracts per function (python-native pre+postconditions)
- **TODO**: exact model choice — discuss with PI researchers
- **TODO**: how much context to give prop gen (token budget, depth) — open

### [3] coder (multiturn — option A+C hybrid)

- turn 1: sees issue + contracts + relevant code → generates patch
- turn 2+: sees which contracts failed → can either:
  - fix the code to satisfy contracts, OR
  - flag a contract as wrong/unsatisfiable and propose a revision
- constraint: limit on how many times contracts can be revised (prevent gaming)
- reward/termination: all contracts satisfied + SWE-bench tests pass, or max turns reached
- **TODO**: max turns, revision limit — defer to rubric design

### [4] verifier

- fast check: run `assume`/`assert` contracts directly against proposed patch (concrete execution, not CrossHair symbolic execution — more practical for repo-level code)
- real check: SWE-bench test harness via PI env hub (`primeintellect/mini-swe-agent-plus`)
- note: CrossHair (used in NL2Contract paper) not used here — too fragile for repo-level code with dependencies and side effects

---

## evaluation setup

three conditions measured on SWE-bench Verified subset:

| condition  | prompt content                            |
| ---------- | ----------------------------------------- |
| baseline 0 | issue + repo (standard SWE-bench default) |
| baseline 1 | issue + repo + failing tests explicit     |
| treatment  | issue + repo + failing tests + contracts  |

**Δ1** = baseline 1 − baseline 0: value of explicit failing tests alone  
**Δ2** = treatment − baseline 1: value of contracts on top of failing tests ← main claim

note: baseline 1 requires extracting and formatting failing tests from repo — can be deferred; baseline 0 vs treatment is sufficient for v0 if needed.

---

## infrastructure

- environments: `primeintellect/mini-swe-agent-plus` via PI env hub
- framework: verifiers library (`vf.MultiTurnEnv` or `StatefulToolEnv`)
- training: none in v0 — pure prompting experiment
- rubric: deferred
- **TODO**: clarify with PI researchers how hookable `mini-swe-agent-plus` is — need injection point for contracts upstream of the coder loop

---

## what is NOT in v0

- no RL training
- no CrossHair symbolic execution
- no Hypothesis property-based tests
- no mypy integration (deferred)
- no fine-tuned property generator model (oracle LLM only)
- no joint/alternating training of prop gen + coder

---

## open decisions (flag for PI researcher discussion)

- training strategy: A (train prop gen first, freeze, train coder) vs B (oracle prop gen, train coder only) vs C (joint/alternating) — **discuss with PI**
- exact model for property generator in v0 — **discuss with PI**
- how hackable is `mini-swe-agent-plus` — injection point for contracts — **ask PI directly**
- function identification depth and token budget — **revisit**
- max turns and contract revision limit — **defer to rubric design**

---

## NL2Contract reference (key facts for proposal)

- paper: Richter & Wehrheim 2025, arxiv 2510.12702
- NL2Contract = task definition, not a model or checkpoint
- input: function signature + docstring + surrounding file context (no implementation)
- output: `assume`/`assert` python-native pre+postconditions
- models tested: GPT-4, GPT-4o, GPT-5 (Chat), CodeQwen 2.5 — prompting only
- verifier used in paper: CrossHair with `--analysis_kind=asserts`
- benchmarks: HumanEval+, Python-by-Contract
- key result: NL2Contract contracts detect 9-11 more bugs than postcondition-only (nl2postcond) — strongest existing argument that contracts are discriminative enough to use as signal
- **transfer gap**: NL2Contract evaluated on clean isolated functions with docstrings; your setup uses issue descriptions on repo-embedded functions — this unknown transfer gap is the core research question of v0
