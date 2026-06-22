import Mathlib

/-!
# Arithmetic Progressions

This file defines arithmetic progressions (APs) and key predicates used in additive combinatorics,
particularly in the study of `r_k(N)` — the maximum size of a k-AP-free subset of `{0,...,N-1}`.

## Main Definitions

* `IsArithmeticProgression s k` — the finset `s` is a **k-term arithmetic progression**,
  i.e., `s = {a, a+d, a+2d, ..., a+(k-1)d}` for some `a : ℕ` and `d : ℕ` with `d > 0`.

* `HasKAP A k` — the finset `A` **contains a non-trivial k-term AP**.

## Relation to Mathlib

For `k = 3`, `HasKAP A 3` is equivalent to `¬ ThreeAPFree (A : Set ℕ)` (Mathlib).
The `rothNumberNat n` in Mathlib is exactly `r_3(n)` — the maximum size of a 3-AP-free
subset of `{0, ..., n-1}`.

## References

* [Wikipedia, *Arithmetic Progression*](https://en.wikipedia.org/wiki/Arithmetic_progression)
* [Wikipedia, *Salem-Spencer set*](https://en.wikipedia.org/wiki/Salem%E2%80%93Spencer_set)
-/

open Finset Nat

namespace ArithProg

/-! ### Definition of k-term arithmetic progressions -/

/-- A finset `s ⊆ ℕ` is a **k-term arithmetic progression** (k-AP) if there exist
    `a : ℕ` (first term) and `d : ℕ` with `d > 0` (common difference) such that
    `s = {a, a+d, a+2d, ..., a+(k-1)d}`.

    The set is the image of `Finset.range k` under the affine map `i ↦ a + i * d`.
    Note: for `k = 0`, the resulting set is empty (degenerate case).
    For `k = 1`, the resulting set is a singleton. The mathematically relevant case is `k ≥ 3`. -/
def IsArithmeticProgression (s : Finset ℕ) (k : ℕ) : Prop :=
  ∃ (a d : ℕ), d > 0 ∧ s = (Finset.range k).image (fun i => a + i * d)

/-- A finset `A ⊆ ℕ` **contains a non-trivial k-AP** if there exists a subset `s ⊆ A`
    that is a k-term arithmetic progression (with positive common difference `d > 0`).

    Equivalently, there exist `a, d : ℕ` with `d > 0` such that
    `{a, a+d, ..., a+(k-1)d} ⊆ A`. -/
def HasKAP (A : Finset ℕ) (k : ℕ) : Prop :=
  ∃ s : Finset ℕ, s ⊆ A ∧ IsArithmeticProgression s k

/-! ### The map i ↦ a + i * d is injective when d > 0 -/

/-- The affine map `i ↦ a + i * d` is injective when `d > 0`. -/
lemma AP_map_injective (a d : ℕ) (hd : 0 < d) :
    Function.Injective (fun i : ℕ => a + i * d) := by
  intro i j hij
  have h : i * d = j * d := Nat.add_left_cancel hij
  exact Nat.eq_of_mul_eq_mul_right hd h

/-! ### Basic lemmas about k-APs -/

/-- A k-AP `{a, a+d, ..., a+(k-1)d}` (with `d > 0`) has exactly `k` elements,
    since the map `i ↦ a + i * d` is injective. -/
lemma card_AP_image (a d k : ℕ) (hd : 0 < d) :
    ((Finset.range k).image (fun i => a + i * d)).card = k := by
  rw [Finset.card_image_of_injective _ (AP_map_injective a d hd)]
  exact Finset.card_range k

/-- Every k-AP (with `d > 0`) has exactly `k` elements. -/
lemma IsArithmeticProgression.card {s : Finset ℕ} {k : ℕ}
    (h : IsArithmeticProgression s k) : s.card = k := by
  obtain ⟨a, d, hd, rfl⟩ := h
  exact card_AP_image a d k hd

/-- A k-AP with `k ≥ 1` is nonempty, since `a` is the first element. -/
lemma IsArithmeticProgression.nonempty {s : Finset ℕ} {k : ℕ} (hk : 1 ≤ k)
    (h : IsArithmeticProgression s k) : s.Nonempty := by
  obtain ⟨a, d, _, rfl⟩ := h
  exact ⟨a + 0 * d, Finset.mem_image.mpr ⟨0, Finset.mem_range.mpr hk, rfl⟩⟩

/-- The first element `a` of a k-AP (with `k ≥ 1`) belongs to the progression. -/
lemma mem_AP_image_zero (a d : ℕ) {k : ℕ} (hk : 0 < k) :
    a ∈ (Finset.range k).image (fun i => a + i * d) := by
  apply Finset.mem_image.mpr
  exact ⟨0, Finset.mem_range.mpr hk, by ring⟩

/-- A 3-AP has the form `{a, a+d, a+2d}` with `d > 0`.
    This is the natural restatement of `IsArithmeticProgression s 3`. -/
lemma IsArithmeticProgression_three_iff (s : Finset ℕ) :
    IsArithmeticProgression s 3 ↔
    ∃ (a d : ℕ), d > 0 ∧ s = ({a, a + d, a + 2 * d} : Finset ℕ) := by
  unfold IsArithmeticProgression
  constructor
  · rintro ⟨a, d, hd, rfl⟩
    refine ⟨a, d, hd, ?_⟩
    -- (range 3).image (fun i => a + i * d) = {a, a + d, a + 2 * d}
    ext x
    constructor
    · intro hx
      simp only [Finset.mem_image, Finset.mem_range] at hx
      obtain ⟨i, hi, rfl⟩ := hx
      have : i = 0 ∨ i = 1 ∨ i = 2 := by omega
      simp only [Finset.mem_insert, Finset.mem_singleton]
      rcases this with rfl | rfl | rfl
      · left; ring
      · right; left; ring
      · right; right; ring
    · intro hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      simp only [Finset.mem_image, Finset.mem_range]
      rcases hx with rfl | rfl | rfl
      · exact ⟨0, by omega, by ring⟩
      · exact ⟨1, by omega, by ring⟩
      · exact ⟨2, by omega, by ring⟩
  · rintro ⟨a, d, hd, rfl⟩
    refine ⟨a, d, hd, ?_⟩
    ext x
    constructor
    · intro hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      simp only [Finset.mem_image, Finset.mem_range]
      rcases hx with rfl | rfl | rfl
      · exact ⟨0, by omega, by ring⟩
      · exact ⟨1, by omega, by ring⟩
      · exact ⟨2, by omega, by ring⟩
    · intro hx
      simp only [Finset.mem_image, Finset.mem_range] at hx
      obtain ⟨i, hi, rfl⟩ := hx
      simp only [Finset.mem_insert, Finset.mem_singleton]
      have : i = 0 ∨ i = 1 ∨ i = 2 := by omega
      rcases this with rfl | rfl | rfl
      · left; ring
      · right; left; ring
      · right; right; ring

/-! ### Connection to Mathlib's ThreeAPFree -/

/-- Alternative characterization of `HasKAP A 3`: there exist `a d : ℕ` with `d > 0`
    such that `a, a+d, a+2d` are all in `A`. -/
lemma hasKAP_three_iff' (A : Finset ℕ) :
    HasKAP A 3 ↔ ∃ a d : ℕ, d > 0 ∧ a ∈ A ∧ (a + d) ∈ A ∧ (a + 2 * d) ∈ A := by
  constructor
  · rintro ⟨s, hs, a, d, hd, rfl⟩
    refine ⟨a, d, hd, ?_, ?_, ?_⟩
    · exact hs (mem_image.mpr ⟨0, mem_range.mpr (by omega), by ring⟩)
    · exact hs (mem_image.mpr ⟨1, mem_range.mpr (by omega), by ring⟩)
    · exact hs (mem_image.mpr ⟨2, mem_range.mpr (by omega), by ring⟩)
  · rintro ⟨a, d, hd, ha, had, ha2d⟩
    refine ⟨{a, a + d, a + 2 * d}, fun x hx => ?_, a, d, hd, ?_⟩
    · simp only [mem_insert, mem_singleton] at hx
      rcases hx with rfl | rfl | rfl
      · exact ha
      · exact had
      · exact ha2d
    · ext x
      simp only [mem_insert, mem_singleton, mem_image, mem_range]
      constructor
      · rintro (rfl | rfl | rfl)
        · exact ⟨0, by omega, by ring⟩
        · exact ⟨1, by omega, by ring⟩
        · exact ⟨2, by omega, by ring⟩
      · rintro ⟨i, hi, rfl⟩
        interval_cases i
        · left; ring
        · right; left; ring
        · right; right; ring

/-- `HasKAP A 3` is equivalent to `¬ ThreeAPFree (A : Set ℕ)`.

    A finset has a non-trivial 3-AP if and only if it is not 3-AP-free
    in the Mathlib sense: `ThreeAPFree s ↔ ∀ a b c ∈ s, a + c = b + b → a = b`. -/
theorem hasKAP_three_iff_not_threeAPFree (A : Finset ℕ) :
    HasKAP A 3 ↔ ¬ ThreeAPFree (A : Set ℕ) := by
  rw [hasKAP_three_iff']
  constructor
  · -- (→) A 3-AP witnesses the failure of ThreeAPFree
    rintro ⟨a, d, hd, ha, had, ha2d⟩ h3ap
    have hmem_a   : a ∈ (A : Set ℕ)       := mem_coe.mpr ha
    have hmem_ad  : a + d ∈ (A : Set ℕ)   := mem_coe.mpr had
    have hmem_a2d : a + 2*d ∈ (A : Set ℕ) := mem_coe.mpr ha2d
    -- a + (a + 2d) = (a + d) + (a + d): ThreeAPFree says a = a+d, but d > 0
    have hsum : a + (a + 2 * d) = (a + d) + (a + d) := by ring
    have := h3ap hmem_a hmem_ad hmem_a2d hsum
    omega
  · -- (←) ¬ThreeAPFree gives a 3-AP
    intro hne
    rw [ThreeAPFree] at hne
    push Not at hne
    obtain ⟨x, hx, y, hy, z, hz, heq, hne⟩ := hne
    rw [mem_coe] at hx hy hz
    by_cases h : x ≤ y
    · -- x ≤ y (with x ≠ y, so x < y); AP starts at x with step d = y - x
      have hlt : x < y := by omega
      refine ⟨x, y - x, Nat.sub_pos_of_lt hlt, hx, ?_, ?_⟩
      · rwa [Nat.add_sub_cancel' (Nat.le_of_lt hlt)]
      · have : x + 2 * (y - x) = z := by omega
        rw [this]; exact hz
    · -- ¬(x ≤ y), so y < x; AP starts at z with step d = y - z
      have hyx : y < x := by omega
      have hzlty : z < y := by omega  -- from x + z = 2y and y < x
      refine ⟨z, y - z, Nat.sub_pos_of_lt hzlty, hz, ?_, ?_⟩
      · rwa [Nat.add_sub_cancel' (Nat.le_of_lt hzlty)]
      · have : z + 2 * (y - z) = x := by omega
        rw [this]; exact hx

/-! ### AP-free sets -/

/-- The empty set does not contain a non-trivial k-AP when `k ≥ 1`,
    since every k-AP (k ≥ 1) is nonempty. -/
lemma not_hasKAP_empty {k : ℕ} (hk : 0 < k) : ¬ HasKAP (∅ : Finset ℕ) k := by
  intro ⟨s, hs, a, d, hd, hs_eq⟩
  have hne : s.Nonempty := hs_eq ▸ ⟨a, mem_AP_image_zero a d hk⟩
  exact hne.ne_empty (Finset.subset_empty.mp hs)

/-- A singleton `{a}` does not contain a non-trivial k-AP when `k ≥ 2`,
    since a k-AP (k ≥ 2, d > 0) has at least 2 distinct elements. -/
lemma not_hasKAP_singleton (a : ℕ) {k : ℕ} (hk : 2 ≤ k) :
    ¬ HasKAP ({a} : Finset ℕ) k := by
  intro ⟨s, hs, a', d, hd, hs_eq⟩
  have hcard : s.card = k := hs_eq ▸ card_AP_image a' d k hd
  have hle : s.card ≤ ({a} : Finset ℕ).card := Finset.card_le_card hs
  simp [Finset.card_singleton] at hle
  omega

/-- Any subset of a k-AP-free set is k-AP-free. -/
lemma not_hasKAP_mono {A B : Finset ℕ} {k : ℕ} (hAB : A ⊆ B)
    (hB : ¬ HasKAP B k) : ¬ HasKAP A k := fun ⟨s, hs, hap⟩ => hB ⟨s, hs.trans hAB, hap⟩

end ArithProg
