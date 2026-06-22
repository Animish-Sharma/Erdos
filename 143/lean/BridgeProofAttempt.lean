import Mathlib
import ArithmeticProgressions
import RkN

/-!
# Bridge Proof: rk 3 N = rothNumberNat N

This file proves the bridge theorem connecting our `rk` formalization to Mathlib's
`rothNumberNat`. Helper lemmas (`hasKAP_three_iff'` and `hasKAP_three_iff_not_threeAPFree`)
live in `ArithmeticProgressions.lean` (namespace `ArithProg`).

## Proof Sketch

**Step 1** (`ArithProg.hasKAP_three_iff'`): Restate `HasKAP A 3` as
  `∃ a d > 0, a ∈ A ∧ a+d ∈ A ∧ a+2d ∈ A`. [proved in ArithmeticProgressions.lean]

**Step 2** (`ArithProg.hasKAP_three_iff_not_threeAPFree`): `HasKAP A 3 ↔ ¬ThreeAPFree A`.
  [proved in ArithmeticProgressions.lean]

**Step 3** (`rk_three_eq_rothNumberNat'`): Use `le_antisymm`.
  - `rk 3 N ≤ rothNumberNat N`: From `findGreatest_spec` + `letI` (transparent Classical
    instance) + `ThreeAPFree.le_rothNumberNat`.
  - `rothNumberNat N ≤ rk 3 N`: From `rothNumberNat_spec` + `le_findGreatest` + `letI`.

## Key Technical Point

`Classical.decPred P` is baked into `rk`'s definition as the `findGreatest` instance.
After `unfold rk`, Lean must unify the synthesized `[DecidablePred P]` with this instance.
`letI` (transparent `let` binding) works; `haveI` (opaque) does not, as `Classical.choice`
calls are not definitionally equal unless unfolded.
-/

open ArithProg Finset

/-! ### Step 3: Bridge Theorem -/

/-- **Bridge Theorem**: `rk 3 N = rothNumberNat N`.

This proves the key connection: our definition of `rk 3 N` via `Nat.findGreatest` over
k-AP-free sets coincides with Mathlib's `rothNumberNat N`, unlocking all Mathlib API.

The helper lemmas used here are proved in `ArithmeticProgressions.lean`:
- `hasKAP_three_iff'`: `HasKAP A 3 ↔ ∃ a d > 0, a ∈ A ∧ a+d ∈ A ∧ a+2d ∈ A`
- `hasKAP_three_iff_not_threeAPFree`: `HasKAP A 3 ↔ ¬ThreeAPFree A` -/
theorem rk_three_eq_rothNumberNat' (N : ℕ) : rk 3 N = rothNumberNat N := by
  apply Nat.le_antisymm
  · -- Direction 1: rk 3 N ≤ rothNumberNat N
    -- Step A: Extract a 3-AP-free set A of size rk 3 N from findGreatest_spec
    have hspec : ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = rk 3 N ∧ ¬HasKAP A 3 := by
      unfold rk
      -- letI (transparent) so the Classical instance matches the one baked into rk
      letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A 3) :=
        Classical.decPred _
      exact Nat.findGreatest_spec
        (P := fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A 3)
        (n := N) (m := 0) (Nat.zero_le N)
        ⟨∅, empty_subset _, by simp, not_hasKAP_empty (by omega)⟩
    obtain ⟨A, hAN, hcard, hkap⟩ := hspec
    -- Step B: Convert ¬HasKAP A 3 to ThreeAPFree (A : Set ℕ)
    have hapfree : ThreeAPFree (A : Set ℕ) := by
      by_contra h
      exact hkap ((hasKAP_three_iff_not_threeAPFree A).mpr h)
    -- Step C: Apply Mathlib's ThreeAPFree.le_rothNumberNat
    exact ThreeAPFree.le_rothNumberNat A hapfree
      (fun x hx => Finset.mem_range.mp (hAN hx)) hcard
  · -- Direction 2: rothNumberNat N ≤ rk 3 N
    -- Step A: Get the 3-AP-free witness from rothNumberNat_spec
    obtain ⟨t, ht, hcard, hapfree⟩ := rothNumberNat_spec N
    -- Step B: Convert ThreeAPFree to ¬HasKAP t 3
    have hkap : ¬HasKAP t 3 :=
      fun h => absurd hapfree ((hasKAP_three_iff_not_threeAPFree t).mp h)
    -- Step C: Apply le_findGreatest to show rothNumberNat N ≤ rk 3 N
    have hle : ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = rothNumberNat N ∧ ¬HasKAP A 3 :=
      ⟨t, ht, hcard, hkap⟩
    unfold rk
    -- letI (transparent) so the Classical instance matches the one baked into rk
    letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A 3) :=
      Classical.decPred _
    exact Nat.le_findGreatest
      (P := fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A 3)
      (n := N) (m := rothNumberNat N) (rothNumberNat_le N) hle
