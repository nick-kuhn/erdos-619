# Verification Record

## Repository State

- Repo path checked: `/home/nick/erdos-619`
- Commit hash: pending commit
- Tag: pending release tag
- Date checked: 2026-06-10 UTC

## Toolchain

- Lean toolchain: `leanprover/lean4:v4.28.0`
- mathlib revision: `8f9d9cff6bd728b17a24e163c9402775d9e6a365`
- comparator tag: `v4.28.0`
- permitted axioms: `propext`, `Quot.sound`, `Classical.choice`

## Commands Run Locally

```sh
lake exe cache get
lake build Challenge Solution
COMPARATOR_BIN=/home/nick/erdos/.tools/comparator/.lake/build/bin/comparator \
COMPARATOR_LEAN4EXPORT=/home/nick/erdos/.tools/comparator/.lake/packages/lean4export/.lake/build/bin/lean4export \
COMPARATOR_DEV_FAKE_LANDRUN=1 \
./scripts/check-erdos-619-solution.sh
```

## Local Results

- `lake exe cache get`: passed
- `lake build Challenge Solution`: passed with linter/style warnings only
- comparator dev smoke test: passed

Comparator terminal result:

```text
Running Lean default kernel on solution.
Lean default kernel accepts the solution
Your solution is okay!
```

## Release Check Still Needed

For the final public/release check, run comparator with real `landrun` from a clean checkout:

```sh
COMPARATOR_LANDRUN=/path/to/landrun ./scripts/check-erdos-619-solution.sh
```

Then fill in the final commit hash, tag, landrun path/version, and paste the real-landrun comparator output here before tagging the release.

## Notes

`Challenge.lean` intentionally uses `sorry`; it is the trusted challenge statement. Comparator rejects untrusted proof holes in `Solution.lean` by checking for unpermitted axioms such as `sorryAx`.
