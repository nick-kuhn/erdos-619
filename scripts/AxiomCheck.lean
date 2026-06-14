import Solution

/-!
# Axiom audit

Redundant `#guard_msgs` check that the comparator-submitted theorems depend only on the
three standard axioms permitted by `comparator/erdos_619.json`.
-/

/--
info: 'erdos_619_solution' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms erdos_619_solution

/--
info: 'erdos_619_fc_solution' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms erdos_619_fc_solution
