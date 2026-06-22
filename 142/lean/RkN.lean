import Mathlib
import ArithmeticProgressions

/-!
# The Function r_k(N)

This file defines `rk k N` — the maximum size of a k-AP-free subset of `{0, 1, ..., N-1}` —
and states its key properties with sorry proofs.

## Definition

`rk k N = max { |A| : A ⊆ {0,...,N-1} ∧ A contains no k-term AP }`.

For `k = 3`, this equals Mathlib's `rothNumberNat N` (the Roth number).

## Main Declarations

* `rk k N` — the r_k function (via `Nat.findGreatest`)
* `rk_mono_N` — monotonicity in N (sorry)
* `rk_le_N` — trivial upper bound (sorry)
* `rk_nonneg` — r_k ≥ 0 (trivial)
* `rk_pos` — positivity for k ≥ 3, N ≥ 1 (sorry)
* `szemeredi_theorem` — Szemerédi's theorem: r_k(N)/N → 0 (sorry)

## Key Results (all sorry-d)

* **Szemerédi's theorem (1975)**: For every `k ≥ 3` and every `ε > 0`,
  there exists `N₀` such that for all `N ≥ N₀`, `r_k(N) / N < ε`.

## References

* Szemerédi, E. (1975). "On sets of integers containing no k elements in arithmetic progression."
  *Acta Arithmetica*, 27, 199–245.
* Tao, T. and Vu, V. (2006). *Additive Combinatorics*. Cambridge University Press.
-/

open Finset Nat ArithProg

/-! ### The r_k(N) function -/

/-- `rk k N` is the maximum size of a k-AP-free subset of `Finset.range N = {0, 1, ..., N-1}`.

    Formally, it is the greatest `m ≤ N` such that there exists a finset `A ⊆ range N`
    with `|A| = m` and `A` containing no k-term arithmetic progression.

    We use `Nat.findGreatest` with `Classical.decPred` for classical decidability.
    The interesting range is `k ≥ 3`.

    **Convention**: We use `{0, ..., N-1}` (i.e., `Finset.range N`) consistent with
    Mathlib's `rothNumberNat`. -/
noncomputable def rk (k N : ℕ) : ℕ :=
  @Nat.findGreatest
    (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬ HasKAP A k)
    (Classical.decPred _)
    N

/-! ### Connection to Mathlib's rothNumberNat -/

/-- For `k = 3`, `rk 3 N` coincides with `rothNumberNat N` from Mathlib.
    Both count the maximum size of a 3-AP-free subset of `{0, ..., N-1}`. -/
theorem rk_three_eq_rothNumberNat (N : ℕ) : rk 3 N = rothNumberNat N := by
  apply Nat.le_antisymm
  · -- Direction 1: rk 3 N ≤ rothNumberNat N
    -- Step A: Extract a 3-AP-free set A of size rk 3 N from findGreatest_spec
    have hspec : ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = rk 3 N ∧ ¬HasKAP A 3 := by
      unfold rk
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
    letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A 3) :=
      Classical.decPred _
    exact Nat.le_findGreatest
      (P := fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A 3)
      (n := N) (m := rothNumberNat N) (rothNumberNat_le N) hle

/-! ### Basic properties of r_k(N) -/

/-- **Trivial upper bound**: `r_k(N) ≤ N`, since any subset of `{0,...,N-1}` has at most
    `N` elements. -/
theorem rk_le_N (k N : ℕ) : rk k N ≤ N := by
  unfold rk
  letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A k) :=
    Classical.decPred _
  exact Nat.findGreatest_le N

/-- **Non-negativity**: `0 ≤ r_k(N)` trivially (since `ℕ` values are non-negative). -/
theorem rk_nonneg (k N : ℕ) : 0 ≤ rk k N := Nat.zero_le _

/-- **Monotonicity in N**: If `N ≤ M` then `r_k(N) ≤ r_k(M)`.

    Proof idea: Any k-AP-free subset `A ⊆ {0,...,N-1}` is also a subset of `{0,...,M-1}`,
    so the maximum over subsets of `{0,...,N-1}` cannot exceed the maximum over `{0,...,M-1}`. -/
theorem rk_mono_N (k : ℕ) {N M : ℕ} (h : N ≤ M) : rk k N ≤ rk k M := by
  unfold rk
  letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A k) :=
    Classical.decPred _
  letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range M ∧ A.card = m ∧ ¬HasKAP A k) :=
    Classical.decPred _
  apply Nat.findGreatest_mono
  · rintro m ⟨A, hAN, hcard, hkap⟩
    exact ⟨A, hAN.trans (Finset.range_mono h), hcard, hkap⟩
  · exact h

/-- **Positivity for k ≥ 3 and N ≥ 1**: `r_k(N) ≥ 1` whenever `k ≥ 3` and `N ≥ 1`.

    Proof: The singleton `{0} ⊆ {0,...,N-1}` is k-AP-free (k ≥ 2 and singletons are
    AP-free), giving a k-AP-free subset of size ≥ 1. -/
theorem rk_pos (k : ℕ) (hk : 3 ≤ k) (N : ℕ) (hN : 1 ≤ N) : 0 < rk k N := by
  have h1 : 1 ≤ rk k N := by
    unfold rk
    letI : DecidablePred (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬HasKAP A k) :=
      Classical.decPred _
    apply Nat.le_findGreatest hN
    exact ⟨{0},
      Finset.singleton_subset_iff.mpr (Finset.mem_range.mpr (by omega)),
      Finset.card_singleton 0,
      not_hasKAP_singleton 0 (by omega)⟩
  omega

/-- **Positivity for 3-APs**: `r_3(N) ≥ 1` for `N ≥ 1`. -/
theorem rk_three_pos (N : ℕ) (hN : 1 ≤ N) : 0 < rk 3 N :=
  rk_pos 3 le_rfl N hN

/-! ### Szemerédi's Theorem -/

/-- `r_k(N)/N` as a real number (the AP-free density). -/
noncomputable def rkDensity (k N : ℕ) : ℝ := (rk k N : ℝ) / (N : ℝ)

/-- **Szemerédi's Theorem (1975)**: For every `k ≥ 3`, the density `r_k(N) / N → 0`.

    For every `k ≥ 3` and `ε > 0`, there exists `N₀` such that for all `N ≥ N₀`,
    `r_k(N) / N < ε`. Equivalently: every positive-density subset of `ℕ` contains a k-AP.

    The proof uses Szemerédi's regularity lemma (or ergodic theory via Furstenberg's proof). -/
theorem szemeredi_theorem :
    ∀ k : ℕ, k ≥ 3 →
    ∀ ε : ℝ, ε > 0 →
    ∃ N₀ : ℕ, ∀ N : ℕ, N ≥ N₀ → (rk k N : ℝ) / (N : ℝ) < ε := by
  sorry

/-- **Roth's theorem as Tendsto for k=3**: `r₃(N) / N → 0` as `N → ∞`.

    This is a direct consequence of Mathlib's `rothNumberNat_isLittleO_id`
    (Roth's theorem) combined with the bridge theorem `rk_three_eq_rothNumberNat`. -/
theorem rk_three_density_tendsto_zero :
    Filter.Tendsto (fun N : ℕ => (rk 3 N : ℝ) / (N : ℝ)) Filter.atTop (nhds 0) := by
  simp_rw [rk_three_eq_rothNumberNat]
  exact rothNumberNat_isLittleO_id.tendsto_div_nhds_zero

/-- Szemerédi's theorem as a `Filter.Tendsto` statement: `r_k(N) / N → 0`.

    For k = 3, this follows from Roth's theorem (proved above as `rk_three_density_tendsto_zero`).
    For k ≥ 4, this requires Szemerédi's full theorem (1975), not yet in Mathlib. -/
theorem szemeredi_tendsto (k : ℕ) (hk : k ≥ 3) :
    Filter.Tendsto (fun N : ℕ => (rk k N : ℝ) / (N : ℝ)) Filter.atTop (nhds 0) := by
  sorry

/-- **Density version of Szemerédi**: If a decidable set `A ⊆ ℕ` has positive upper density,
    it contains a k-AP.

    Upper density is measured as `limsup_{N→∞} |A ∩ {0,...,N-1}| / N`. -/
theorem szemeredi_density_version (k : ℕ) (hk : k ≥ 3) (A : Set ℕ)
    [DecidablePred (· ∈ A)]
    (hA : 0 < Filter.limsup
          (fun N : ℕ => (((Finset.range N).filter (· ∈ A)).card : ℝ) / (N : ℝ))
          Filter.atTop) :
    ∃ (a d : ℕ), d > 0 ∧ ∀ i : Fin k, a + i.val * d ∈ A := by
  sorry
