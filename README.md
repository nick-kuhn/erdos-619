# Erdős Problem 619 Lean Formalization

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

## Build

Use the pinned Lake manifest and mathlib cache:

```sh
lake exe cache get
lake build Challenge Solution
```

The build may emit linter/style warnings from `Solution.lean`; those are not proof holes.

## Comparator Verification

Comparator checks that `Solution.erdos_619_solution` has the same statement as the trusted theorem in `Challenge.lean`, kernel-checks, and uses only the permitted axioms listed in `comparator/erdos_619.json`:

```json
["propext", "Quot.sound", "Classical.choice"]
```

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
