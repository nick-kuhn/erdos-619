import Erdos

/-- Trusted challenge theorem for Comparator.

A proposed `Solution.lean` must provide a theorem with this exact name and statement,
without using axioms beyond those listed in `comparator/erdos_619.json`. -/
theorem erdos_619_solution : Erdos.Problem619.erdos_619 := by
  sorry

/-- Trusted challenge theorem for Comparator, in the formal-conjectures form.

This is the solved form of `Erdos619.erdos_619` from google-deepmind/formal-conjectures
(see `Erdos/FC.lean` for provenance and the `answer(False)`-to-`False` convention).
A proposed `Solution.lean` must also provide a theorem with this exact name and
statement, under the same axiom whitelist. -/
theorem erdos_619_fc_solution : Erdos619.erdos_619_solved_statement := by
  sorry
