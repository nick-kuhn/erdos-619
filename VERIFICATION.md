# Verification Record

## Repository State

- Repo URL: `https://github.com/nick-kuhn/erdos-619`
- Commit checked before this verification update: `86da4a0`
- Verification date: `2026-06-10 UTC`
- Release tag: `erdos-619-solution-v1` after this verification commit

## Toolchain

- Lean toolchain: `leanprover/lean4:v4.28.0`
- mathlib revision: `8f9d9cff6bd728b17a24e163c9402775d9e6a365`
- comparator tag: `v4.28.0`
- comparator commit: `7a0cae3df7a0200ff330c82420b8d88a51c9cac7`
- landrun module: `github.com/zouuup/landrun v0.1.16-0.20251001204025-5ed4a3db3a4a`
- landrun binary used: `/tmp/landrun-main-bin/landrun`
- permitted axioms: `propext`, `Quot.sound`, `Classical.choice`

## Landrun Smoke Test

The published landrun `v0.1.15` release failed on this machine with `permission denied` under comparator's direct `-ldd -add-exec` invocation. The upstream revision recorded above passed the direct smoke test:

```sh
/tmp/landrun-main-bin/landrun --best-effort --ro / --rw /dev -ldd -add-exec /usr/bin/echo hello
```

Output:

```text
hello
```

No wrapper was used for the final comparator run.

## Commands Run

```sh
lake exe cache get
lake build Challenge Solution

COMPARATOR_BIN=/home/nick/erdos/.tools/comparator/.lake/build/bin/comparator \
COMPARATOR_LEAN4EXPORT=/home/nick/erdos/.tools/comparator/.lake/packages/lean4export/.lake/build/bin/lean4export \
COMPARATOR_LANDRUN=/tmp/landrun-main-bin/landrun \
./scripts/check-erdos-619-solution.sh
```

## Results

- `lake exe cache get`: passed
- `lake build Challenge Solution`: passed with linter/style warnings only
- comparator with real landrun: passed

Comparator final output:

```text
Exporting #[erdos_619_solution, propext, Quot.sound, Classical.choice, Nat.add, Nat.sub, Nat.mul, Nat.pow, Nat.gcd, Nat.div, Nat.mod, Nat.beq, Nat.ble, Nat.land, Nat.lor, Nat.xor, Nat.shiftLeft, Nat.shiftRight, String.ofList] from Solution
Running Lean default kernel on solution.
Lean default kernel accepts the solution
Your solution is okay!
```

## Notes

`Challenge.lean` intentionally uses `sorry`; it is the trusted challenge statement. Comparator rejects untrusted proof holes in `Solution.lean` by checking for unpermitted axioms such as `sorryAx`.

---

# Verification Record: formal-conjectures form added (2026-06-12)

## Changes verified

- `Erdos/FC.lean`: vendored trusted copy of the statement from
  google-deepmind/formal-conjectures, `FormalConjectures/ErdosProblems/619.lean`
  ([PR #4255](https://github.com/google-deepmind/formal-conjectures/pull/4255),
  branch `erdos-619` of the `nick-kuhn` fork, commit
  `f1f486fd5826d5da1e6bc0c8cadaec404d0898ac`), in its
  solved form with the transparent `answer(False)` annotation written as `False`.
- `Challenge.lean`: second trusted challenge theorem `erdos_619_fc_solution`.
- `Solution.lean`: bridge lemmas (`addedEdgeCount_eq_ncard`, `IsHR.minNewEdges_eq`,
  `erdos_619_conjecture_of_fc`) and root-level `erdos_619_fc_solution`.
- `comparator/erdos_619.json`: `theorem_names` now lists both
  `erdos_619_solution` and `erdos_619_fc_solution`.
- `scripts/AxiomCheck.lean`: axiom audit extended to `erdos_619_fc_solution`.

## Toolchain

Unchanged from the record above (Lean `leanprover/lean4:v4.28.0`, comparator tag
`v4.28.0`, landrun binary `/tmp/landrun-main-bin/landrun`).

## Commands Run

```sh
lake build Erdos Challenge Solution
lake env lean scripts/AxiomCheck.lean
COMPARATOR_LANDRUN=/tmp/landrun-main-bin/landrun ./scripts/check-erdos-619-solution.sh
```

## Results

- `lake build`: passed (pre-existing linter/style warnings only; `sorry` warnings
  come from the two trusted challenge theorems).
- axiom audit: passed for both theorems
  (`propext`, `Classical.choice`, `Quot.sound`).
- comparator with real landrun: passed.

Comparator final output:

```text
Exporting #[erdos_619_solution, erdos_619_fc_solution, propext, Quot.sound, Classical.choice, Nat.add, Nat.sub, Nat.mul, Nat.pow, Nat.gcd, Nat.div, Nat.mod, Nat.beq, Nat.ble, Nat.land, Nat.lor, Nat.xor, Nat.shiftLeft, Nat.shiftRight, String.ofList] from Solution
Running Lean default kernel on solution.
Lean default kernel accepts the solution
Your solution is okay!
```

## Notes

The formal-conjectures statement vendored in `Erdos/FC.lean` is pinned to an
**unmerged** branch of a formal-conjectures fork. If review of the upstream PR
changes the statement, `Erdos/FC.lean` and the bridge must be updated and this
verification re-run. Once the PR is merged, replace the vendored copy with a Lake
dependency on formal-conjectures pinned at the merge commit (this requires moving
this repository to the formal-conjectures toolchain, currently Lean v4.27.0).
