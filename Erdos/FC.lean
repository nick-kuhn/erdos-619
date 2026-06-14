import Mathlib

/-!
# Vendored formal-conjectures statement of Erdős Problem 619

This file is a trusted, verbatim copy of the statement of Erdős Problem 619 from the
google-deepmind/formal-conjectures repository:

- File: `FormalConjectures/ErdosProblems/619.lean`
- Merged via [PR #4255](https://github.com/google-deepmind/formal-conjectures/pull/4255),
  commit `1a9fbeebaa628fec9818216802298871c95b193c` on `main`.

This repository depends on `mathlib` only (matching the convention of the proof repos
linked from formal-conjectures), so the statement is vendored here rather than imported.
Its fidelity to the merged source was checked two ways:

- **Textual:** the `minNewEdges` definition below is byte-identical to the merged file,
  and the right-hand side of `erdos_619_solved_statement` is byte-identical to the
  right-hand side of the merged `Erdos619.erdos_619`.
- **Mechanical:** the `phase2-fc-dependency` branch adds a Lake `require` on
  formal-conjectures at the same commit, imports `FormalConjectures.ErdosProblems.«619»`,
  and contains a `guard_fc_rhs` example that fails to compile unless this right-hand side
  is definitionally identical to upstream's.

Two deliberate deviations from the source, both transparent:

1. `minNewEdges` is copied verbatim (same namespace `Erdos619`, same definition).
2. The solved form of the theorem statement in formal-conjectures reads
   `answer(False) ↔ ...`. The `answer( )` elaborator wraps its argument in an
   `Expr.mdata` annotation and otherwise elaborates it unchanged, so `answer(False)`
   elaborates to the proposition `False`. We state the proposition with a literal
   `False` here to avoid vendoring the elaborator; the resulting `Prop` is identical.
   (The merged upstream statement is still the **open** form `answer(sorry) ↔ ...`; the
   `answer(False)` solved form is the upstream edit proposed in the follow-up PR.)
-/

open SimpleGraph

namespace Erdos619

/--
Verbatim copy of `Erdos619.minNewEdges` from formal-conjectures.

For a graph $G$, `minNewEdges r G` is the smallest number of edges that need to be added
to $G$ so that it has diameter at most $r$, while preserving the property of being
triangle-free; `Nat.sInf` returns `0` if no such extension exists.
-/
noncomputable def minNewEdges {V : Type*} (r : ℕ) (G : SimpleGraph V) : ℕ :=
  sInf {k | ∃ H : SimpleGraph V,
    G ≤ H ∧ H.CliqueFree 3 ∧ H.ediam ≤ r ∧ (H \ G).edgeSet.ncard = k}

/--
The proposition of the *solved form* of `Erdos619.erdos_619` in formal-conjectures,
with the transparent `answer(False)` annotation written as a literal `False`:
the answer to "is there a constant $c > 0$ such that every connected triangle-free
graph on $n$ vertices satisfies $h_4(G) < (1-c)n$?" is **no**.
-/
def erdos_619_solved_statement : Prop :=
  False ↔
    ∃ c > (0 : ℝ), ∀ (V : Type) [Fintype V] (G : SimpleGraph V),
      G.Connected → G.CliqueFree 3 →
      (minNewEdges 4 G : ℝ) < (1 - c) * Fintype.card V

end Erdos619
