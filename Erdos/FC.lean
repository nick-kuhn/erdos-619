import FormalConjectures.ErdosProblems.«619»

/-!
# The formal-conjectures statement of Erdős Problem 619

This file binds the verification in this repository to the **actual**
google-deepmind/formal-conjectures statement of Erdős Problem 619, via a Lake
dependency (see `lakefile.toml`, pinned to the merge commit `1a9fbee` of
[PR #4255](https://github.com/google-deepmind/formal-conjectures/pull/4255)).

`Erdos619.minNewEdges` and the bound below are no longer a hand-transcribed copy:
`minNewEdges` here *is* the formal-conjectures symbol, imported from
`FormalConjectures.ErdosProblems.«619»`.

The solved form of the problem in formal-conjectures reads `answer(False) ↔ RHS`.
The `answer( )` elaborator wraps its argument in a transparent `Expr.mdata`
annotation and otherwise elaborates it unchanged, so `answer(False)` is the
proposition `False`; we write the literal `False` here. The `guard_fc_rhs` example
below mechanically checks — at compile time, with no `sorry` of our own — that the
`RHS` we negate is *definitionally* the right-hand side of the imported
`Erdos619.erdos_619`, so this transcription cannot silently drift from upstream.
-/

open SimpleGraph

namespace Erdos619

/--
The proposition of the *solved form* of `Erdos619.erdos_619` in formal-conjectures,
with the transparent `answer(False)` annotation written as a literal `False`:
the answer to "is there a constant $c > 0$ such that every connected triangle-free
graph on $n$ vertices satisfies $h_4(G) < (1-c)n$?" is **no**.

`minNewEdges` is the imported formal-conjectures definition.
-/
def erdos_619_solved_statement : Prop :=
  False ↔
    ∃ c > (0 : ℝ), ∀ (V : Type) [Fintype V] (G : SimpleGraph V),
      G.Connected → G.CliqueFree 3 →
      (minNewEdges 4 G : ℝ) < (1 - c) * Fintype.card V

/--
Mechanical guard: the imported `Erdos619.erdos_619` has type `answer(sorry) ↔ RHS`
(its left side is a `sorry`-placeholder `Prop`, which we deliberately do not depend on).
Its `.mpr` direction has type `RHS → _`; applying it to a hypothesis of *our* restated
right-hand side typechecks only if the two are definitionally identical. So if
formal-conjectures ever changes the statement, this stops compiling.

(`erdos_619` is `sorry`-backed upstream; this `example` uses it only to compare *types*.
It is anonymous and not a dependency of the comparator-checked theorems, so it does not
affect their axiom audit.)
-/
example
    (h : ∃ c > (0 : ℝ), ∀ (V : Type) [Fintype V] (G : SimpleGraph V),
          G.Connected → G.CliqueFree 3 →
          (minNewEdges 4 G : ℝ) < (1 - c) * Fintype.card V) : True := by
  have _ := Erdos619.erdos_619.mpr h
  trivial

end Erdos619
