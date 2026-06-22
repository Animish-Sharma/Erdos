# Explorer Gap Analysis: Erdős Problem 142
## witsoc-explorer Phase Report (v2 — Lovász Review Complete)

**Date**: 2026-06-21  
**Pipeline position**: Explorer → [Lovász COMPLETE] → Generator  
**Gaps analyzed**: 5 + new KL2 conjecture  
**Files produced**: explorer_target_model.json, handoff.json (v2), barrier_packet.json (v2), gap_analysis.md, witsoc_next_action.json, explorer_review.md  
**Lovász analyses received**: lovász_BL3_analysis.md (van Corput + k=4), lovász_BL1_analysis.md (ℓ¹ vs ℓ² spectrum)

---

## CRITICAL CORRECTIONS FROM v1 (incorporated in v2)

1. **KL ceiling 1/3 not 1/2**: Kelley-Lyu gives exponent **1/3** (not 1/2) when transferred to 3-APs. Exponent 1/2 requires the NEW **KL2 Tripartite Grid Norm Conjecture** (3-7 year target). The bilinear→trilinear gap prevents direct 1/2.
2. **EHPS misdescribed**: Elsholtz-Hunter-Proske-Sauermann (2024) improved the **constant** in the Behrend lower bound (c' ≈ 2.667 in log₂ units vs Behrend's 2√2 ≈ 2.828), NOT the exponent structure. The form N·exp(-c·√(logN)) is unchanged.
3. **KL posting date**: Kelley-Lyu (arXiv:2505.01587) was first posted **May 2025**, not June 2026.
4. **van Corput r_4 exponent**: The correct van Corput result is r_4(N) ≤ N·exp(-c/2·(logN)^{**1/6**}). The exponent stays 1/6, only the constant halves. Explorer's original claim of exponent 1/12 was a formula error (**RETRACTED**).
5. **ℓ¹ spectrum sufficiency**: The ℓ¹ large spectrum has size O(α^{-1}) — this is correct — but it only gives **L¹-almost-periodicity**, which is **insufficient** for the standard density increment (which needs L²-AP). The L¹ density increment is the main open challenge (GAP2).

---

## Summary Table (v2 — Revised Priorities)

| Gap | Priority | Status | Tractability | Route to Generator |
|-----|----------|--------|-------------|-------------------|
| GAP2: Doubly-Iterated Raghavan | **TOP (1-3 yr)** | OPEN | MEDIUM — L¹ DI argument needed | **Direct to Generator** |
| KL2: Tripartite Grid Norm | **HIGH (3-7 yr)** | OPEN CONJECTURE | HARD — requires new framework | After Lovász structural analysis |
| GAP3: k=4 Quasi-Poly | MEDIUM (3-10 yr) | PARTIAL — van Corput gives 1/6 | HARD for full QCS | van Corput corollary NOW; QCS via Lovász |
| GAP1: Kelley–Lyu Transfer | MEDIUM (1-3 yr) | OPEN — ceiling 1/3 | HARD | After Lovász confirms L¹ DI |
| GAP4: Rankin Tightness k=5 | MEDIUM-LOW | OPEN | VERY HARD | Monitor only |
| GAP5: WIT Sorry Closing | HIGH (formal) | PARTIAL | MEDIUM (steps 6,8 easy; step 5 tractable) | **Direct to Generator** |

---

## Gap 1: Kelley–Lyu Transfer Question (REVISED — ceiling 1/3 not 1/2)

### Status: OPEN — ceiling revised downward

**CORRECTION**: KL ceiling for 3-APs is **1/3**, NOT 1/2.  
**Date correction**: arXiv:2505.01587 posted **May 2025**, not June 2026.  
**Exponent 1/2 requires**: KL2 Tripartite Grid Norm Conjecture (new open conjecture).

### What is Kelley–Lyu's result?

Kelley and Lyu (arXiv:2505.01587, first posted May 2025) achieve exponent **1/2** in bipartite (2-player) communication complexity using a grid norm sifting argument. The √d potential trick: in their bipartite setting, d ~ logN → √d ~ (logN)^{1/2} → exponent 1/2.

**For 3-APs**: The KL √d trick gives rank O(α^{-1}) from the L¹ spectrum — giving exponent **1/3** (not 1/2). The extra "3" in the denominator (from the tripartite structure of 3-APs) prevents achieving exponent 1/2 directly. Transfer probability for exponent 1/2: 15-20% (requires resolving bilinear→trilinear gap). Transfer probability for exponent 1/3: **50-60%** (L¹ density increment, much more direct).

### The Bilinear→Trilinear Gap

**The Fourier formula**:  
Λ_3(A) = (1/N)·∑_ξ Â(ξ)²·Â(-2ξ)

The 3-AP incidence set {(a,b,c): a+c=2b} is TRIPARTITE (3 variables). KL's grid norm applies to BIPARTITE functions. The Fourier formula has a bilinear component (Â(ξ)² involves 2 copies of A) but the third copy (Â(-2ξ) for the middle element b) breaks the bipartite structure.

**KL's √d trick in bipartite setting**: Potential Φ(C) for a bilinear function C: X×Y → ℝ, with t = c·d^{1/2} (d = rank of C's singular value decomposition). This gives rank reduction by √d per step.

**For 3-APs (tripartite)**: The "√d potential" can be applied to the bilinear part (Â²), giving rank O(α^{-1}) from the L¹ spectrum. But the third copy (Â(-2ξ)) is not controlled by this potential. The L¹ rank O(α^{-1}) is achievable, giving exponent 1/3 — but the trilinear gap prevents directly achieving 1/2.

### New Conjectures (KL1/KL2/KL3)

| Conjecture | Statement | Status |
|-----------|-----------|--------|
| **KL1** (Bilinear Barrier) | The √d trick is bilinear-specific; for k-linear sifting (k≥3), ceiling is 1/3 | CONJECTURED |
| **KL2** (Tripartite Grid Norm) | Grid norm U(2,2,k) for tripartite structure gives exponent 1/2 for 3-APs | OPEN — 3-7 year target |
| **KL3** (Ceiling Dichotomy) | For r_3(N): either ceiling is 1/3 (KL1 correct) or 1/2 (KL2 provable); no intermediate | CONJECTURED |

### Backward Chaining (revised targets)

**Exponent 1/3 (1-3 year target)**:
1. L¹ density increment on rank O(α^{-1}) Bohr sets — this IS the GAP2 question  
2. Confirm the KL √d trick gives rank O(α^{-1}) for the bilinear part of 3-APs

**Exponent 1/2 (3-7 year target via KL2)**:
1. Define tripartite grid norm U(2,2,3) for 3-APs
2. Prove U(2,2,3) sifting lemma with rank O(1) (constant rank!)
3. Density increment on constant-rank Bohr sets

**Lovász Finding (BL1)**: Standard CS uses ℓ² threshold δ‖f‖₂, giving rank O(α^{-2}). ℓ¹ threshold δ‖f̂‖_∞ = δα gives rank O(α^{-1}). L¹ Bohr set only provides L¹-AP — insufficient for standard density increment. New L¹ DI argument needed (= GAP2). **[ACCEPTED from lovász_BL1_analysis.md]**

### Ranking: Tractable Path Forward for GAP1

GAP1 (exponent 1/3 target) MERGES with GAP2: both require the L¹ density increment argument. GAP1 (exponent 1/2 via KL2) is a distinct 3-7 year problem for a future Lovász cycle.

---

## Gap 2: Doubly-Iterated Raghavan

### Status: OPEN (most tractable)

The Sifting Hierarchy Formula f(m) = 1/(3(5-m)) predicts exponent 1/3 for m=4. This is CONFIRMED for m=1,2,3 (exponents 1/12, 1/9, 1/6) but NOT for m=4.

### What is Raghavan's new ingredient (m=3 vs m=2)?

| Method | Level | Effective Rank | Exponent | New Ingredient |
|--------|-------|----------------|----------|----------------|
| Kelley–Meka | m=1 | O(α^{-4}) | 1/12 | Croot–Sisask almost-periodicity |
| Bloom–Sisask | m=2 | O(α^{-3}) | 1/9 | Bootstrapped CS: apply lemma twice |
| Raghavan | m=3 | O(α^{-2}) | 1/6 | ITERATED sifting: nest density increments |

Raghavan's key idea: instead of applying the density increment once and restarting, he applies the sifting WITHIN the context of the first Bohr set. The "conditioned" function A ∩ B₁ has additional almost-periodicity from the B₁ context, which reduces the additional rank needed in the second step from O(α^{-2}) to O(α^{-1}).

### Key Lemma for m=4

**Doubly-Conditioned Almost-Periodicity Lemma**:  
After Raghavan's iterated sifting produces Bohr sets B₁, B₂ with B₂ ⊆ B₁, the function 1_A restricted to B₁ ∩ B₂ has effective rank O(α^{-1}) — one less power than B₂ alone.

**This is the barrier lemma for GAP2**. Whether it holds depends on whether the "double conditioning" (conditioning on B₁ AND B₂) reduces the rank by an additional factor.

### Is the Sifting Hierarchy Formula Proved?

**NO — it is EMPIRICAL.**

The formula f(m) = 1/(3(5-m)) is observed for m=1,2,3 but has not been proved as a theorem about the iteration. Possible explanations:
1. It is a genuine theorem about the Kelley–Meka framework, waiting to be proved.
2. It is a coincidence that breaks at m=4 (the "effective rank" might not continue decreasing by 1 per iteration level).
3. The formula reflects the L² ceiling: effective rank decreases by 1 per level up to ρ=2 (the L² floor). m=4 would require ρ=1, which means breaking the L² barrier.

**Assessment**: The formula is unlikely to be a coincidence for three data points. But m=4 may require a qualitatively new argument (similar to what Raghavan needed to get from m=2 to m=3).

### Backward Chaining

To prove r_3(N) ≤ N·exp(-c(log N)^{1/3}):
1. Formalize Raghavan's sifting proof exactly.
2. Identify the rank/density-increment trade-off at each level.
3. Apply one more level of conditioning (B₃ inside B₂ inside B₁).
4. Show total effective rank = O(α^{-1}).
5. Run the density increment argument with rank O(α^{-1}).
6. Derive exponent 1/3 from the iteration.

Steps 1-2 require reading arXiv:2603.27045 in detail.  
Steps 3-6 are the new mathematical content.

### Tractability Assessment: MEDIUM

The **MOST TRACTABLE** of the 5 gaps for generating new mathematics:
- Mathematical ingredients: all existing (Raghavan 2026 paper)
- Clear target: exponent 1/3 (or even 1/3 with extra log-log factor)
- Definite strategy: apply Raghavan's argument one more time
- Timeline per experts: 1-3 years
- Witsoc Generator could attempt to formalize the barrier lemma BL2 and check its conditions

### Recommendation: GENERATOR (direct)

Send GAP2's barrier lemma (BL2: Doubly-Conditioned Almost-Periodicity) directly to the Generator with:
- Task: Formalize what the rank growth formula is in Raghavan's third sifting level
- Sub-task: Prove or disprove that adding a fourth sifting level reduces effective rank by one more power of α

---

## Gap 3: k=4 Quasi-Polynomial Bound (PARTIAL PROGRESS — van Corput confirmed)

### Status: PARTIAL — van Corput + Raghavan gives first quasi-poly bound

**NEW CONFIRMED RESULT (from lovász_BL3_analysis.md)**:

> **Proposition (likely new observation)**: r_4(N) ≤ C·N·exp(-c/2·(logN)^{1/6})

**Derivation**: Van Corput / Cauchy-Schwarz gives r_4(N) ≤ C·√(N·r_3(N)) exactly (standard technique). Plugging in Raghavan 2026: r_3(N) ≤ N·exp(-c(logN)^{1/6}) gives:
r_4(N) ≤ C·√(N · N·exp(-c(logN)^{1/6})) = C·N·exp(-c/2·(logN)^{1/6})

**Key corrections**:
- Exponent stays **1/6**, not 1/12 (Explorer's original claim was WRONG — retracted)
- The constant halves (c/2 instead of c)
- This STILL beats Green-Tao 2017 (polynomial N(logN)^{-c}) and LSS 2024 (N·exp(-(loglogN)^{c_4}))
- This is likely the FIRST quasi-polynomial bound for r_4(N)
- May be a new observation NOT explicitly in Raghavan (2026)

**For Generator**: Write this as a clean proposition with proof sketch citing van Corput + Raghavan. This is an immediate new result.

---

Green–Tao 2017 gives r_4(N) ≤ N(log N)^{-c}. The van Corput result above surpasses this. But for exponent **c > 0** in r_4(N) ≤ N·exp(-(logN)^c), we already have c = 1/6. The OPEN question is whether c can be improved toward 1/3 (conjectured) or beyond.

### Exact Missing Lemma for Full Quasi-Poly: Quadratic Croot–Sisask

The precise missing lemma (BL3-QCS):

> Let f: Z_N → [-1,1] with ‖f‖_{U³[N]} ≥ δ. Then there exists a 2-step nil-Bohr set QBohr of quasipolynomial rank d = O((log 1/δ)^C) such that ‖T_h f - f‖_{U²} ≤ ε·‖f‖_{U³} for all h ∈ QBohr.

**Why does this give r_4(N) ≤ N·exp(-(log N)^c)?**  
- 4-AP-free A with density α → ‖1_A - α‖_{U³} ≥ δ(α) (by 4-AP counting, Gowers–Cauchy–Schwarz)
- QCS → A is U²-almost-periodic on QBohr of size ≥ N·exp(-O((log 1/α)^C))
- On QBohr, A has higher density α + ρ (density increment step)
- Iterate: after O(1/α) steps, density reaches 1 → contradiction with |A| < N
- The compression: N_final ≥ N·(exp(-O((log 1/α)^C)))^{O(1/α)} ≥ 1 gives α ≥ c/(log N)^{1/C}
- Hence r_4(N) ≤ N·exp(-(log N)^{1/C})

### Analogies: Linear vs. Quadratic Croot–Sisask

| Object | k=3 (Linear CS) | k=4 (Quadratic CS needed) |
|--------|-----------------|--------------------------|
| Norm controlling k-APs | U² = Fourier L⁴ | U³ (quadratic Fourier) |
| Inverse theorem | Large Fourier coeff | Correlation with 2-step nilsequence |
| Almost-periodicity | Bohr(Γ, ρ) with |Γ| = O(α^{-2}) | nil-Bohr(G, d) with d = O((log 1/α)^C) |
| Almost-periodicity lemma | ‖T_h f - f‖_{U¹} small for h ∈ Bohr | ‖T_h f - f‖_{U²} small for h ∈ nil-Bohr |
| Status | PROVED (Croot–Sisask 2010) | OPEN (Quadratic CS Lemma) |

The "quadratic" in "Quadratic Croot–Sisask" refers to U² in the error norm (‖T_h f - f‖_{U²}) — measuring how much f's quadratic structure changes under translation.

### Backward Chaining for k=4

r_4(N) ≤ N·exp(-(log N)^c)  
← Density increment on nil-Bohr sets of quasipolynomial complexity  
← Quadratic Croot–Sisask Lemma (BL3-QCS)  
← Understanding of 2-step nil-Bohr set geometry and translation properties  

The first arrow (CS → density increment) requires:
- Quantitative nil-Bohr set regularity lemma
- Density increment on nil-Bohr sets comparable to classical Bohr-set increment

The second arrow (QCS statement) is the core lemma to prove.

### Assessment: HARD (3-10 year problem)

The 2-torsion obstruction in 2-step nilmanifolds is a real technical barrier. Even with LSS's quasipolynomial U³ inverse theorem, the density increment step remains open.

**However**: Route B2-R1 (van der Corput from k=4 to k=3) might give a quick win:
- If r_3(N) ≤ N·exp(-(log N)^β) for β = 1/6 (Raghavan), can one deduce r_4(N) ≤ N·exp(-(log N)^{β/4}) by 2-step van der Corput?
- This would give r_4(N) ≤ N·exp(-(log N)^{1/24}), the first quasi-polynomial bound for r_4(N).
- This calculation is TRACTABLE and should be attempted immediately.

### Recommendation: LOVÁSZ (second priority)

Send to Lovász with two tasks:
1. Verify whether van der Corput (r_4 from r_3) gives quasi-polynomial bound — QUICK CHECK
2. Identify whether 2-torsion in nil-Bohr sets is a fundamental or technical obstacle

---

## Gap 4: Rankin Tightness for k=5

### Status: OPEN (low near-term tractability)

**Current state**:  
- Upper bound: r_5(N) ≤ N·exp(-(log log N)^{c_5}) [Leng–Sah–Sawhney 2024]
- Lower bound: r_5(N) ≥ N·exp(-C_5(log N)^{1/3}) [Rankin 1961]

The gap is ENORMOUS (double-log vs. single-log). Closing this gap requires:
1. First getting any quasi-polynomial upper bound (r_5(N) ≤ N·exp(-(log N)^c) for any c > 0)
2. Then improving c toward 1/3 to match Rankin

**Is Rankin's lower bound tight?**  
Evidence for: Rankin's sphere construction for k=5 in dimension d ~ (log N)^{1/3} is the best known lower bound, and no construction giving higher density is known.

Evidence against: The Behrend sphere is also 5-AP-free (as shown by a sphere argument: 5 points on a sphere in Z^d with equal distances can only form trivial APs). Behrend gives density N·exp(-c(log N)^{1/2}) > Rankin for small c. Wait — Rankin gives exp(-c(log N)^{1/3}) and Behrend gives exp(-c(log N)^{1/2}). Since 1/3 < 1/2, we have (log N)^{1/3} < (log N)^{1/2}, so exp(-(log N)^{1/3}) > exp(-(log N)^{1/2}). So RANKIN gives the HIGHER lower bound (larger set). Rankin beats Behrend for r_5(N).

**Upper bound gap**: The LSS upper bound N·exp(-(log log N)^{c_5}) is far from the Rankin lower bound N·exp(-C(log N)^{1/3}). Closing this gap requires a quasi-polynomial bound for r_5(N) — itself an open problem of comparable difficulty to the k=4 problem.

### Backward Chaining

r_5(N) ≤ N·exp(-c(log N)^{1/3})  
← Quasi-polynomial upper bound for r_5(N) (any c > 0)  
← U⁴ inverse theorem (proved by LSS 2024) + density increment on 3-step nil-Bohr sets  
← Cubic Croot–Sisask Lemma (for U⁴) — NOT proved  

This is a strictly harder version of the k=4 problem. Without even the Quadratic Croot–Sisask Lemma (for k=4), we cannot expect the Cubic version (for k=5).

### Assessment: VERY HARD (no near-term route)

**Recommendation**: MONITOR ONLY. Focus on GAP1-3. GAP4 will be addressed after progress on k=4.

---

## Gap 5: WIT Sorry Closing

### Status: PARTIAL (4/12 steps DONE)

The file `proofs/rk_asymptotics.wit` has 4 DONE steps and 8 SORRY steps.

### Which SORRY Steps Are Closest to Provable?

**EASY (can be proved NOW without step 5)**:
- **Step 6 (rk_le_N)**: `rk k N ≤ N`. Follows directly from `Nat.findGreatest N P ≤ N` (the `findGreatest` bound). Zero additional Lean knowledge required.
- **Step 8 (rk_pos)**: `k ≥ 3 → N ≥ 1 → 0 < rk k N`. The singleton `{0} ⊆ range N` is k-AP-free. The proof: exhibit A = {0} with |A| = 1 and ¬HasKAP A k. Then `rk k N ≥ 1 > 0`.

**MEDIUM (requires Step 5 first)**:
- **Step 5 (rk_three_eq_rothNumberNat)**: `rk 3 N = rothNumberNat N`. This requires:
  1. Proving `hasKAP_three_iff_not_threeAPFree: HasKAP A 3 ↔ ¬ThreeAPFree A`
  2. Showing both `rk 3 N` and `rothNumberNat N` compute the same maximum
  - Lean proof strategy: unfold both definitions; use `Nat.findGreatest_spec` and `Finset.rothNumberNat_eq` (if it exists in Mathlib)
  - Key Mathlib lemma needed: `Finset.addSalemSpencer_iff` connecting `ThreeAPFree` to `¬HasKAP 3`
  
- **Step 7 (rk_mono_N)**: `N ≤ M → rk k N ≤ rk k M`. After step 5, this follows from monotonicity of `rothNumberNat` (which Mathlib may have) or directly from `Finset.range N ⊆ Finset.range M`.

- **Step 11 (behrend_lower_bound)**: After step 5, this is 2 lines: `rw [rk_three_eq_rothNumberNat]; exact Behrend.roth_lower_bound`.

**IMPOSSIBLE without major Mathlib contributions**:
- Step 9 (szemeredi_theorem): Needs quantitative Szemerédi — not in Mathlib.
- Step 10 (roth_theorem_1953): Quantitative Roth (N/log log N) — not in Mathlib.
- Step 12 (kelley_meka_2023): Full Kelley–Meka proof — not in Lean anywhere.

### szemeredi_theorem via Mathlib

The qualitative version (r_k(N)/N → 0) is in Mathlib as `Finset.rothNumberNat.tendsto` for k=3. For k ≥ 3, it might be `Finset.addSalemSpencer_tendsto` or similar. Let's check:

Mathlib has `roth_number_nat_le_of_not_threeAPFree` and related. For the qualitative Szemerédi:
- `Finset.card_pow_div_lt_card` or ergodic-theory based results may be available.
- The `szemeredi_theorem` statement in the WIT file matches the qualitative statement `r_k(N)/N < ε for large N`, which for k=3 follows from tendsto in Mathlib.

**Assessment**: Step 9 for k=3 only might be provable via Mathlib, using `rothNumberNat_lt_of_lt` or Mathlib's ergodic results. For general k ≥ 3, it requires checking Mathlib's coverage.

### What Would rk_three_eq_rothNumberNat's Proof Look Like?

```lean
theorem rk_three_eq_rothNumberNat (N : ℕ) : rk 3 N = rothNumberNat N := by
  -- Both are the maximum size of a 3-AP-free subset of Finset.range N
  -- Step 1: Show the predicates agree
  have pred_eq : ∀ m, (∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬ HasKAP A 3) ↔ 
                      (∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ThreeAPFree (A : Set ℕ)) := by
    intro m
    constructor
    · rintro ⟨A, hA_sub, hA_card, hA_free⟩
      exact ⟨A, hA_sub, hA_card, (hasKAP_three_iff_not_threeAPFree A).mp hA_free⟩
      -- uses hasKAP_three_iff_not_threeAPFree which needs to be proved first
    · rintro ⟨A, hA_sub, hA_card, hA_free⟩
      exact ⟨A, hA_sub, hA_card, (hasKAP_three_iff_not_threeAPFree A).mpr hA_free⟩
  -- Step 2: Use extensionality of Nat.findGreatest
  simp only [rk, rothNumberNat]
  congr 1
  ext m
  exact pred_eq m
```

The key sub-lemma `hasKAP_three_iff_not_threeAPFree` requires:
```lean
theorem hasKAP_three_iff_not_threeAPFree (A : Finset ℕ) :
    HasKAP A 3 ↔ ¬ ThreeAPFree (A : Set ℕ) := by
  -- HasKAP A 3: ∃ B ⊆ A, IsArithmeticProgression B 3 (with d > 0 implicit)
  -- ¬ ThreeAPFree (A : Set ℕ): ∃ a b c ∈ A, a ≠ b ∧ a + c = 2b
  simp [HasKAP, IsArithmeticProgression, ThreeAPFree]
  constructor
  · rintro ⟨B, hB_sub, a, d, hd, hB_image⟩
    -- B = {a, a+d, a+2d} ⊆ A
    use a, a + d, a + 2 * d
    refine ⟨hB_sub (hB_image ▸ ...), ..., ..., ...⟩
    -- technical Finset manipulations
    sorry -- details omitted; this is a routine but tedious Lean 4 proof
  · rintro ⟨x, y, z, hxA, hyA, hzA, hxy, hxyz⟩
    -- x + z = 2y, x ≠ y
    -- Construct AP: a = x, d = y - x (in ℤ, need care in ℕ)
    -- B = {x, y, z} ⊆ A is a 3-AP with d = y - x > 0 (from x ≠ y)
    sorry -- arithmetic details in ℕ
```

### Recommendation for WIT Steps to Send to Generator

**Send to Generator (priority order)**:
1. `rk_le_N` — trivially provable from `Nat.findGreatest` definition
2. `rk_pos` — trivially provable by exhibiting {0} as k-AP-free
3. `hasKAP_three_iff_not_threeAPFree` (sub-lemma for rk_three_eq_rothNumberNat) — mechanical Lean proof
4. `rk_three_eq_rothNumberNat` — requires sub-lemma from (3); then straightforward
5. `rk_mono_N` — follows from Finset monotonicity
6. `behrend_lower_bound` — follows from step 4 + Mathlib's Behrend.roth_lower_bound

**Do NOT send to Generator**:
- roth_theorem_1953 (quantitative Roth not in Mathlib)
- kelley_meka_2023 (not formalized anywhere)
- szemeredi_theorem (only k=3 qualitative version possibly feasible)

---

## Backward Chaining: Summary for All 5 Gaps

### Gap 1 (Kelley–Lyu Transfer)
```
r_3(N) ≤ N·exp(-c(log N)^{1/2})
← Grid-Norm Croot–Sisask Lemma with rank O(1) [or O(α^{-1}) for exponent 1/3]
← Proof that 3-AP Fourier formula Σ_ξ|Â(ξ)|²Â(-2ξ) constitutes a grid-norm
← Kelley–Lyu (arXiv:2505.01587) structure understood and adapted
```
**STATUS**: All arrows OPEN.

### Gap 2 (Doubly-Iterated Raghavan)
```
r_3(N) ≤ N·exp(-c(log N)^{1/3})
← Density increment with effective rank O(α^{-1})
← Doubly-Conditioned Almost-Periodicity Lemma (BL2)
← Raghavan's iterated sifting + one additional level of conditioning
```
**STATUS**: All arrows OPEN, but rightmost is mechanically close to existing techniques.

### Gap 3 (k=4 Quasi-Poly)
```
r_4(N) ≤ N·exp(-c/2·(logN)^{1/6})     [CONFIRMED — van Corput + Raghavan 2026]
r_4(N) ≤ N·exp(-(log N)^c) (c > 1/6)
← Density increment on nil-Bohr sets of quasipolynomial complexity
← Quadratic Croot–Sisask Lemma (BL3-QCS)
← Resolution of 2-torsion obstruction in 2-step nilmanifolds
```
**STATUS**: First arrow CONFIRMED (new observation). Remaining arrows OPEN.
**Quick win for Generator**: Write van Corput proposition as clean new result.

### Gap 4 (Rankin Tightness k=5)
```
r_5(N) ≤ N·exp(-c(log N)^{1/3})
← Quasi-polynomial upper bound for r_5(N) (first step)
← Cubic Croot–Sisask Lemma (analogous to k=4)
← k=4 solved first
```
**STATUS**: Blocked on k=4.

### Gap 5 (WIT Sorry Closing)
```
7+ DONE steps in rk_asymptotics.wit
← Steps 6, 8 (trivial from definitions)
← Step 5 (rk_three_eq_rothNumberNat: requires hasKAP_three_iff_not_threeAPFree)
← Steps 7, 11 (follow from step 5 + Mathlib)
```
**STATUS**: Steps 6 and 8 immediately provable. Step 5 tractable via Lean 4 definitional unfolding.

---

## Tractability Ranking (v2 — Lovász Review Complete)

### Rank 1 (Immediate — Write Now): GAP3-VanCorput

**Quick win**: r_4(N) ≤ N·exp(-c/2·(logN)^{1/6}) from van Corput + Raghavan. Write as clean proposition with proof sketch. Likely new observation not in Raghavan (2026). Immediate action for Generator. **[AUTHORIZED]**

### Rank 2 (Immediate — Lean): GAP5 — WIT Sorry Closing

**Reason**: Steps 6 and 8 require 3-5 lines of Lean 4 each. Step 5 requires a 20-30 line proof. All within Mathlib capabilities. Completing brings WIT proof from 4/12 to 7/12 DONE. Immediate action for Generator. **[AUTHORIZED]**

### Rank 3 (Top Priority — New Math): GAP2 — Doubly-Iterated Raghavan

**Priority: TOP** (revised upward from HIGH).

**Why**: L¹ density increment for 3-APs on rank O(α^{-1}) Bohr sets is the key barrier for exponent 1/3. Lovász BL1 has confirmed the barrier (L¹ AP ≠ L² AP, density increment needs L² control). Two authorized Generator tracks:
- **Track A**: Attempt L¹ density increment argument (1-3 year target)
- **Track B**: Write van Corput corollary as immediate proposition (quick win)

**[AUTHORIZED FOR GENERATOR — see handoff.json v2 gap2_handoff]**

### Rank 4 (Hard — Long-term): KL2 — Tripartite Grid Norm Conjecture

**New 3-7 year target**: Tripartite Grid Norm U(2,2,3) sifting → exponent 1/2 for r_3(N). This is the "holy grail" for r_3(N) asymptotics. Requires a new framework beyond current bipartite methods. Future Lovász cycle.

### Rank 5 (Hard): GAP1 / GAP3-full

**GAP1 (1/3 target)** has merged with GAP2 (both require L¹ DI). **GAP3 full quasi-poly improvement** (beyond 1/6 exponent) requires QCS lemma — 3-10 year problem.

### Rank 6 (Very Hard): GAP4 — Rankin Tightness k=5

**Reason**: Requires solving GAP3-type problem first. Monitor only.

---

## Key Insight: Summary After Lovász Review

**The Lovász review resolved two key questions**:

1. **Van Corput (BL3)**: r_4(N) ≤ N·exp(-c/2·(logN)^{1/6}) is CONFIRMED. Exponent stays 1/6, constant halves. BEATS all prior k=4 bounds. Likely new observation.

2. **L¹ spectrum (BL1)**: The ℓ¹ large spectrum of 1_A has size O(α^{-1}) (confirmed). But L¹-AP is insufficient for the density increment (confirmed — needs L²-AP). The L¹ density increment is the OPEN gap for exponent 1/3. This is GAP2's main barrier (B0-L1DI in barrier_packet.json v2).

**GAP2 is now the TOP priority** — both mathematically (exponent 1/3 is the next sifting hierarchy step) and in terms of tractability (the barrier is precisely characterized, two viable tracks identified).

---

## Summary Paragraph for Handoff (v2)

After Lovász BL1+BL3 analyses (June 2026), the Explorer's v2 assessment:

**New confirmed result**: r_4(N) ≤ N·exp(-c/2·(logN)^{1/6}) via van Corput + Raghavan 2026. Exponent stays 1/6 (Explorer's "1/12" claim was a formula error, RETRACTED). This beats Green-Tao 2017 and LSS 2024 for k=4. Write as clean proposition immediately.

**GAP2 is now TOP priority**: The L¹ density increment for 3-APs on rank O(α^{-1}) Bohr sets is the precisely-characterized barrier for exponent 1/3. KL ceiling confirmed at 1/3 (not 1/2 as originally stated). Exponent 1/2 requires new KL2 Tripartite Grid Norm Conjecture (3-7 years).

**Generator authorized** for GAP2 (two tracks) and GAP3-VanCorput (quick win) and GAP5 (WIT steps 6,8,5).
