import Mathlib

/-!
# Erdős Problem 619

For a triangle-free graph `G`, let `h_r(G)` be the smallest number of edges that must be
added to `G` so that the resulting graph remains triangle-free and has diameter at most `r`.
The original conjecture asks whether `h_4(G) < (1 - c) n` uniformly for connected
triangle-free graphs on `n` vertices, for some constant `c > 0`.

The proposition `erdos_619` below is the negation of this conjecture, which is the target
statement for proposed disproofs.
-/

open SimpleGraph

namespace Erdos
namespace Problem619

noncomputable section

/-- The number of new edges in `H` that were not already present in `G`. -/
def addedEdgeCount {n : ℕ} (G H : SimpleGraph (Fin n)) : ℕ :=
  (H.edgeFinset \ G.edgeFinset).card

/-- `IsHR r G m` says that `m` is the value of `h_r(G)`: it is achieved by a
triangle-free supergraph of `G` with extended diameter at most `r`, and is minimal among all such
supergraphs.

Using `ediam` avoids the junk value of `diam` on disconnected graphs, where `diam` is defined as
`ediam.toNat` and hence maps infinite extended diameter to `0`. -/
def IsHR {n : ℕ} (r : ℕ) (G : SimpleGraph (Fin n)) (m : ℕ) : Prop :=
  ∃ H : SimpleGraph (Fin n),
    G ≤ H ∧
      H.CliqueFree 3 ∧
        H.ediam ≤ (r : ℕ∞) ∧
          addedEdgeCount G H = m ∧
            ∀ K : SimpleGraph (Fin n),
              G ≤ K → K.CliqueFree 3 → K.ediam ≤ (r : ℕ∞) → m ≤ addedEdgeCount G K

/-- The original positive conjecture in Erdős Problem 619. -/
def erdos_619_conjecture : Prop :=
  ∃ c : ℝ,
    0 < c ∧
      ∀ (n : ℕ) (G : SimpleGraph (Fin n)) (m : ℕ),
        G.Connected →
          G.CliqueFree 3 →
            IsHR 4 G m →
              (m : ℝ) < (1 - c) * n

/-- The target statement for this project: the negation of Erdős Problem 619's conjecture. -/
def erdos_619 : Prop :=
  ¬ erdos_619_conjecture

end

end Problem619
end Erdos
