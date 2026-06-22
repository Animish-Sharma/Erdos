import Mathlib
import ArithmeticProgressions
import RkN

/-!
# Upper and Lower Bounds for r_k(N)

This file states the key quantitative bounds on `rk k N` — the maximum size of a
k-AP-free subset of `{0, 1, ..., N-1}`. All proofs are `sorry`-d; this file documents
the mathematical landscape.

## Main Results Stated

### Upper bounds (AP-free sets are small)
* `roth_theorem_1953` — Roth's 1953 bound: `r₃(N) = O(N / log log N)`
* `bourgain_bound_1999` — Bourgain (1999): `r₃(N) = O(N (log log N / log N)^{1/2})`
* `bloom_sisask_2020` — Bloom–Sisask (2020): `r₃(N) = O(N / (log N)^{1+c})` for some `c > 0`
* `kelley_meka_2023` — Kelley–Meka (2023): `r₃(N) = O(N exp(-c (log N)^{1/9}))` (polynomial improvement)

### Lower bounds (AP-free sets can be large)
* `behrend_lower_bound` — Behrend (1946): `r₃(N) ≥ N exp(-C √(log N))`

## Remarks

The Kelley–Meka result (2023) is the current state of the art for `k = 3`.
The exact asymptotic of `r₃(N)` remains open.

For general `k`, the best known upper bound is due to Gowers (2001) using
higher-order Fourier analysis. For lower bounds, the random greedy construction
gives `r_k(N) ≥ N^{1 - 1/(k-1) + o(1)}` for `k ≥ 4`.

## References

* Roth, K. F. (1953). "On certain sets of integers." *J. London Math. Soc.*, 28, 104–109.
* Behrend, F. A. (1946). "On sets of integers which contain no three terms in arithmetical
  progression." *Proc. Nat. Acad. Sci.*, 32, 331–332.
* Bourgain, J. (1999). "On triples in arithmetic progression." *Geom. Funct. Anal.*, 9, 968–984.
* Bloom, T. F. and Sisask, O. (2020). "Breaking the logarithmic barrier in Roth's theorem on
  arithmetic progressions." arXiv:2007.03528.
* Kelley, Z. and Meka, R. (2023). "Strong bounds for 3-progressions." arXiv:2302.05537.
* Gowers, W. T. (2001). "A new proof of Szemerédi's theorem." *Geom. Funct. Anal.*, 11, 465–588.
-/

open Real ArithProg

/-! ### Upper bounds for r₃(N) -/

/-- **Roth's Theorem (1953)**: The first quantitative bound on `r₃(N)`.
    There exists a constant `c > 0` such that for all `N ≥ 2`:
    ```
    r₃(N) ≤ c · N / log(log(N))
    ```
    This was the first proof that `r₃(N) = o(N)`, establishing that any set of
    positive density contains a 3-AP. Roth's proof used Fourier analysis on `ℤ/Nℤ`.

    Note: In Mathlib, Roth's theorem (the qualitative version: `r₃(N)/N → 0`)
    is formalized in `Mathlib.Combinatorics.Additive.Corner.Roth` using
    Szemerédi's regularity lemma. The quantitative bound requires additional work. -/
theorem roth_theorem_1953 :
    ∃ c : ℝ, c > 0 ∧ ∀ N : ℕ, N ≥ 2 →
    (rk 3 N : ℝ) ≤ c * N / (Real.log (Real.log N)) := by
  sorry

/-- **Bourgain's bound (1999)**: An improvement of Roth's theorem.
    There exists `c > 0` such that for all `N ≥ 2`:
    ```
    r₃(N) ≤ c · N · √(log log N / log N)
    ```
    This used bilinear sum techniques to improve Roth's bound. -/
theorem bourgain_bound_1999 :
    ∃ c : ℝ, c > 0 ∧ ∀ N : ℕ, N ≥ 2 →
    (rk 3 N : ℝ) ≤ c * N * Real.sqrt (Real.log (Real.log N) / Real.log N) := by
  sorry

/-- **Bloom–Sisask bound (2020)**: A logarithmic improvement over polynomial methods.
    There exist `c > 0` and `C > 0` such that for all `N ≥ 2`:
    ```
    r₃(N) ≤ C · N / (log N)^{1+c}
    ```
    This was the first result to exceed the logarithmic barrier in Roth's theorem. -/
theorem bloom_sisask_2020 :
    ∃ (c C : ℝ), c > 0 ∧ C > 0 ∧ ∀ N : ℕ, N ≥ 2 →
    (rk 3 N : ℝ) ≤ C * N / (Real.log N) ^ (1 + c) := by
  sorry

/-!
### Kelley–Meka 2023 (polynomial exponential improvement)

The **Kelley–Meka theorem (2023)** gives the first "qualitatively stronger" bound:
```
  r₃(N) ≤ N · exp(−c · (log N)^{1/9})
```
for some absolute constant `c > 0`. This achieves a polynomial improvement in the exponent,
far stronger than the logarithmic improvements of prior work.

This is the **current state of the art** for the upper bound on `r₃(N)` as of 2024.

The proof builds on Bloom–Sisask and uses a new "almost periodicity" argument, combined
with density increment methods that leverage strong forms of Fourier analysis on ℤ/Nℤ.

**Note on formalization**: The precise statement involves `exp(-c * (Real.log N)^(1/9 : ℝ))`.
A complete Lean formalization of this result does not yet exist in Mathlib.
-/

/-- **Kelley–Meka Theorem (2023)**: Polynomial exponential upper bound on `r₃(N)`.
    There exists an absolute constant `c > 0` such that for all sufficiently large `N`:
    ```
    r₃(N) ≤ N · exp(−c · (log N)^{1/9})
    ```
    This is the strongest known upper bound on `r₃(N)`. -/
theorem kelley_meka_2023 :
    ∃ c : ℝ, c > 0 ∧ ∃ N₀ : ℕ, ∀ N : ℕ, N ≥ N₀ →
    (rk 3 N : ℝ) ≤ N * Real.exp (-(c * (Real.log N) ^ ((1 : ℝ) / 9))) := by
  sorry

/-! ### Lower bounds for r₃(N) -/

/-- **Behrend's Lower Bound (1946)**: There exist AP-free sets of density `exp(-O(√(log N)))`.
    There exists an absolute constant `C > 0` such that for all `N ≥ 1`:
    ```
    r₃(N) ≥ N · exp(−C · √(log N))
    ```
    Behrend's construction uses the fact that a sphere in ℝⁿ contains no 3-AP
    (by strict convexity), then projects integer points on the sphere to `{0,...,N-1}`.

    This matches `Behrend.roth_lower_bound` in Mathlib (with `C = 4`):
    `(N : ℝ) * exp (−4 * √(log N)) ≤ rothNumberNat N`.

    Note: The gap between Behrend's lower bound `N exp(-C √log N)` and the
    Kelley–Meka upper bound `N exp(-c (log N)^{1/9})` shows `r₃(N)` is
    sub-polynomial but super-polylogarithmic. The exact asymptotics are unknown. -/
theorem behrend_lower_bound :
    ∃ C : ℝ, C > 0 ∧ ∀ N : ℕ, N ≥ 1 →
    (N : ℝ) * Real.exp (-(C * Real.sqrt (Real.log N))) ≤ (rk 3 N : ℝ) := by
  -- Use C = 4, witnessed by Mathlib's Behrend.roth_lower_bound via the bridge theorem.
  -- Note: Our form exp(-(4 * √(log N))) matches Behrend's exp(-4 * √(log N)) via ← neg_mul.
  refine ⟨4, by norm_num, fun N _ => ?_⟩
  rw [rk_three_eq_rothNumberNat]
  simp only [← neg_mul]
  exact Behrend.roth_lower_bound

/-- The Behrend lower bound in terms of `rothNumberNat`.
    This uses the existing Mathlib result `Behrend.roth_lower_bound`. -/
theorem behrend_lower_bound_via_mathlib (N : ℕ) :
    (N : ℝ) * Real.exp (-4 * Real.sqrt (Real.log N)) ≤ (rk 3 N : ℝ) := by
  rw [rk_three_eq_rothNumberNat]
  exact Behrend.roth_lower_bound

/-! ### General k bounds -/

/-- **Trivial lower bound via Behrend**: `r_k(N) ≥ r₃(N) ≥ N exp(-C √(log N))` for `k ≥ 3`.

    Since any k-AP-free set is also 3-AP-free (k-APs contain 3-APs as subsets when k ≥ 3),
    we have `r₃(N) ≤ r_k(N)` for `k ≥ 3`. -/
theorem rk_ge_r3 (k : ℕ) (hk : 3 ≤ k) (N : ℕ) : rk 3 N ≤ rk k N := by
  sorry

/-- **Gowers' bound (2001)**: For general `k ≥ 3`, there exists `c_k > 0` such that
    `r_k(N) = O(N / (log log N)^{c_k})`.
    This uses the `(k-1)`-th Gowers uniformity norm and a higher-order Fourier argument. -/
theorem gowers_bound (k : ℕ) (hk : 3 ≤ k) :
    ∃ c : ℝ, c > 0 ∧ ∃ C : ℝ, C > 0 ∧ ∀ N : ℕ, N ≥ 2 →
    (rk k N : ℝ) ≤ C * N / (Real.log (Real.log N)) ^ c := by
  sorry

/-! ### Summary of bounds -/

/-!
## Summary of Known Bounds for r₃(N)

| Result | Bound | Year |
|--------|-------|------|
| Behrend (lower) | N · exp(-C√(log N)) | 1946 |
| Roth (upper) | N / log log N | 1953 |
| Heath-Brown (upper) | N (log N)^{-δ} | 1987 |
| Bourgain (upper) | N · √(log log N / log N) | 1999 |
| Sanders (upper) | N (log N)^{-3/4} | 2011 |
| Bloom–Sisask (upper) | N / (log N)^{1+c} | 2020 |
| Kelley–Meka (upper) | N · exp(-c (log N)^{1/9}) | 2023 |

The gap between the upper bound (quasi-polynomial decay) and lower bound
(exponential-of-square-root decay) remains one of the central open problems
in additive combinatorics.
-/
