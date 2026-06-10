# Erdős Problem 619 Lean Formalization

This repository contains a Lean/mathlib formalization of the negation of the original Erdős Problem 619 conjecture, together with a comparator entry point for independently checking the submitted proof.

## Main Files

- `Erdos/Basic.lean`: trusted formal statement.
- `Challenge.lean`: trusted comparator challenge theorem, intentionally proved by `sorry`.
- `Solution.lean`: submitted proof and root-level comparator theorem.
- `comparator/erdos_619.json`: comparator configuration.
- `scripts/check-erdos-619-solution.sh`: comparator runner.

The original positive conjecture is:

```lean
Erdos.Problem619.erdos_619_conjecture
```

The target theorem is its negation:

```lean
theorem erdos_619_solution : Erdos.Problem619.erdos_619
```

where `Erdos.Problem619.erdos_619` is definitionally `¬ Erdos.Problem619.erdos_619_conjecture`.

## Build

Use the pinned Lake manifest and mathlib cache:

```sh
lake exe cache get
lake build Challenge Solution
```

The build may emit linter/style warnings from `Solution.lean`; those are not proof holes.

## Comparator

Comparator checks that `Solution.erdos_619_solution` has the same statement as the trusted theorem in `Challenge.lean`, kernel-checks, and uses only the permitted axioms listed in `comparator/erdos_619.json`:

```json
["propext", "Quot.sound", "Classical.choice"]
```

Set up comparator matching Lean `v4.28.0`:

```sh
git clone https://github.com/leanprover/comparator .tools/comparator
git -C .tools/comparator checkout v4.28.0
(cd .tools/comparator && lake build lean4export comparator)
```

For a local non-adversarial smoke test:

```sh
COMPARATOR_DEV_FAKE_LANDRUN=1 ./scripts/check-erdos-619-solution.sh
```

For the actual release check, use real `landrun`:

```sh
COMPARATOR_LANDRUN=/path/to/landrun ./scripts/check-erdos-619-solution.sh
```

If comparator is built outside this repository, pass explicit paths:

```sh
COMPARATOR_BIN=/path/to/comparator \
COMPARATOR_LEAN4EXPORT=/path/to/lean4export \
COMPARATOR_LANDRUN=/path/to/landrun \
./scripts/check-erdos-619-solution.sh
```

## Release Checklist

Before pushing a release tag:

1. Run `lake exe cache get` from a clean checkout.
2. Run `lake build Challenge Solution`.
3. Run comparator with real `landrun`.
4. Record the exact commit hash, toolchain, comparator tag, command, and output in `VERIFICATION.md`.
5. Commit and tag the verified state.
