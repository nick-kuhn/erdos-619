# Erdős Problem 619 Lean Formalization

[![verify](https://github.com/nick-kuhn/erdos-619/actions/workflows/verify.yml/badge.svg?branch=main)](https://github.com/nick-kuhn/erdos-619/actions/workflows/verify.yml)

This repository contains a Lean/mathlib formalization of the negation of the original Erdős Problem 619 conjecture, together with a comparator-checked proof.

## Main Files

- `sketch.md` : Solution sketch by Claude Fable. 
- `Erdos/Basic.lean`: trusted formal statement.
- `Erdos/FC.lean`: trusted vendored copy of the google-deepmind/formal-conjectures
  statement of the problem (solved form), see the file header for provenance.
- `Challenge.lean`: trusted comparator challenge theorems, intentionally proved by `sorry`.
- `Solution.lean`: submitted proof, root-level comparator theorems, and the bridge from
  the `Erdos/Basic.lean` form to the formal-conjectures form.
- `comparator/erdos_619.json`: comparator configuration.
- `scripts/check-erdos-619-solution.sh`: comparator runner.
- `VERIFICATION.md`: recorded verification commands and outputs.

The original positive conjecture is:

```lean
Erdos.Problem619.erdos_619_conjecture
```

The target theorem is its negation:

```lean
theorem erdos_619_solution : Erdos.Problem619.erdos_619
```

where `Erdos.Problem619.erdos_619` is definitionally `¬ Erdos.Problem619.erdos_619_conjecture`.

## About the proof

- ~5900 lines, no `sorry`. Two statements are proved: this repository's negation
  `Erdos.Problem619.erdos_619`, and — verbatim — the google-deepmind/formal-conjectures
  statement of the problem (`erdos_619_fc_solution`, vendored in `Erdos/FC.lean` and pinned
  to [formal-conjectures PR #4255](https://github.com/google-deepmind/formal-conjectures/pull/4255)),
  the two connected by a bridge in `Solution.lean`.
- Builds inside this repository (Lean `v4.28.0`, mathlib `v4.28.0`; `lake build` succeeds.
  The Mathlib style linter emits warnings — long lines and `simp` hints — but no errors).
- Axiom audit: depends only on `propext`, `Classical.choice`, `Quot.sound` (checked by
  `scripts/AxiomCheck.lean` and re-checked by the comparator's kernel export).
- Mathematical route: a two-level counterexample family. Take a connected triangle-free
  "core" graph `H` on `m` vertices with bounded maximum degree and small independence number
  `α(H) = O(m·log d / d)` (such graphs exist by a first-moment argument on sparse random
  graphs), and attach `s` pendant leaves to every core vertex, so almost all vertices are
  pendants. A spanning-forest count lower-bounds the edges needed to reach diameter `≤ 4`;
  triangle-freeness forces every new vertex's core-neighbourhood to be an independent set in
  `H`, capping how many pendants any "hub" can pull within distance 2. With fewer than `n`
  added edges only a vanishing fraction of core pairs come close, so nearly every pendant must
  buy its own edge and `h₄(G) ≥ (1 − η)·n` for every `η > 0` — refuting the conjectured
  `h₄(G) ≤ (1 − c)·n`. See `sketch.md` for the full argument.

## Build

Use the pinned Lake manifest and mathlib cache:

```sh
lake exe cache get
lake build Challenge Solution
```

The build may emit linter/style warnings from `Solution.lean`; those are not proof holes.

## Comparator Verification

Comparator checks that the submitted theorems `Solution.erdos_619_solution` and `Solution.erdos_619_fc_solution` have the same statements as the trusted theorems in `Challenge.lean`, kernel-checks them, and confirms they use only the permitted axioms listed in `comparator/erdos_619.json`:

```json
["propext", "Quot.sound", "Classical.choice"]
```

CI runs this entire pipeline (build, axiom audit, and comparator under landrun) from pinned sources on every push to `main`, every pull request, and every `erdos-619-solution-*` tag; see the badge above or the Actions tab. Relative paths to the comparator binaries are fine — the runner script canonicalizes them.

The verification recorded in `VERIFICATION.md` used:

- Lean `v4.28.0`
- comparator tag `v4.28.0`
- landrun module `github.com/zouuup/landrun v0.1.16-0.20251001204025-5ed4a3db3a4a`

Set up comparator:

```sh
git clone https://github.com/leanprover/comparator .tools/comparator
git -C .tools/comparator checkout v4.28.0
(cd .tools/comparator && lake build lean4export comparator)
```

Set up a landrun binary from the verified upstream revision:

```sh
mkdir -p /tmp/landrun-main-bin
GOBIN=/tmp/landrun-main-bin \
  go install github.com/zouuup/landrun/cmd/landrun@5ed4a3db3a4a
```

Then run:

```sh
COMPARATOR_BIN=.tools/comparator/.lake/build/bin/comparator \
COMPARATOR_LEAN4EXPORT=.tools/comparator/.lake/packages/lean4export/.lake/build/bin/lean4export \
COMPARATOR_LANDRUN=/tmp/landrun-main-bin/landrun \
./scripts/check-erdos-619-solution.sh
```

Expected final output:

```text
Running Lean default kernel on solution.
Lean default kernel accepts the solution
Your solution is okay!
```

Note: the published landrun `v0.1.15` release failed on this verification machine with `permission denied` for comparator's direct `-ldd -add-exec` invocation. The upstream revision above passed the direct landrun smoke test and the full comparator run without any wrapper or change to comparator's sandbox arguments.

## Provenance / AI disclosure

The original proof was generated by Claude Fable 5; the formalization was sketched out by
Fable and implemented by GPT 5.5 with Codex. The result is fully verified by the Lean
compiler and the comparator kernel check, and depends only on the three standard axioms
listed above.
