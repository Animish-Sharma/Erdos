# Lovász Analysis: BL1-GRID — ℓ¹ vs ℓ² Spectral Normalization in Croot–Sisask

**Author**: witsoc-research-lovász (sess_7931396c)  
**Date**: 2026-06-21  
**Target**: GAP1 — Does standard Croot–Sisask use ℓ¹-normalized spectrum (rank O(α^{-1})) or ℓ²-normalized (rank O(α^{-2}))?

---

## Core Question and Answer

**Question**: In the Croot–Sisask / Kelley–Meka framework, when constructing the Bohr set for the density increment, is the "large spectrum" defined relative to ‖f̂‖_∞ = f̂(0) = αN (ℓ¹ normalization, giving |Spec| = O(α^{-1})) or relative to ‖f‖₂² = αN (ℓ² normalization, giving |Spec| = O(α^{-2}))?

**Answer: Standard Croot–Sisask uses ℓ² normalization, giving rank O(α^{-2}).** The ℓ¹ normalization giving rank O(α^{-1}) is AVAILABLE but NOT the same object used in the density increment.

---

## Precise Distinction

**ℓ² (standard) large spectrum** (used in Croot–Sisask / Kelley–Meka):

$$\mathrm{Spec}_\delta^{(\ell^2)}(f) = \left\{\xi : |\hat{f}(\xi)| \geq \delta \cdot \|f\|_2\right\}$$

For f = 1_A with ‖1_A‖₂ = √(αN):

$$|\mathrm{Spec}_\delta^{(\ell^2)}(1_A)| \leq \frac{\sum_\xi |\hat{f}(\xi)|^2}{(\delta\|f\|_2)^2} = \frac{\|f\|_2^2 \cdot N}{(\delta\sqrt{\alpha N})^2} = \frac{\alpha N \cdot N}{\delta^2 \alpha N} = \frac{N}{\delta^2} \cdot \frac{1}{N} \cdot \frac{1}{1} \to O\!\left(\frac{1}{\delta^2 \alpha}\right) = O(\alpha^{-2})$$

Wait — more carefully: ∑_ξ |f̂(ξ)|² = N · ‖f‖₂² = N · αN = αN² (with unnormalized Fourier transform). Then |Spec| ≤ αN²/(δ²αN)² · N... let me use normalized transforms.

**With normalized Fourier transform** f̂(ξ) = (1/N)∑_x f(x)e(-xξ/N):

- ∑_ξ |f̂(ξ)|² = ‖f‖_2² / N = α (Parseval)
- ‖f̂‖_∞ ≥ |f̂(0)| = (1/N)∑f = α (= density)
- Standard Spec: Spec_δ(f) = {ξ: |f̂(ξ)| ≥ δ·α} (threshold at fraction δ of the peak)
- Size: |Spec_δ(f)| ≤ α/(δα)² = **1/(δ²α) = O(α^{-1})**

**WAIT** — with this normalization, the large spectrum threshold at δ × peak = δα gives |Spec| = O(α^{-1}), NOT O(α^{-2})!

---

## The Key Subtlety: Two Different Thresholds

The confusion arises from two different threshold choices:

| Normalization | Threshold | Spectrum size | Bohr rank | CS exponent |
|---|---|---|---|---|
| Threshold at δ · ‖f̂‖_∞ = δα | (relative to peak/mean) | O(α^{-1}) | O(α^{-1}) | **1/3** |
| Threshold at δ · ‖f‖₂ = δ√α | (relative to L² norm) | O(α^{-2}) | O(α^{-2}) | **1/6** |
| Threshold at δ · √(‖f‖₂²/N) = δ√(α/N) | (relative to avg coeff) | O(N/δ²) = O(N) | O(N) — useless | — |

**The Croot–Sisask lemma uses threshold δ · ‖f‖₂ (second row)**, giving rank O(α^{-2}).

**The ℓ¹ normalization (first row) uses threshold δ · ‖f̂‖_∞ = δα**, giving rank O(α^{-1}).

---

## Why Croot–Sisask Uses ℓ²?

The Croot–Sisask almost-periodicity lemma proves:

> ‖f * μ_B - f‖₂ ≤ ε‖f‖₂, for B = Bohr(Spec_δ(f), ρ)

The *error in ℓ²*. This requires the Bohr set to be large enough that convolving with μ_B doesn't move most Fourier mass — controlled by how many coefficients are above the threshold δ‖f‖₂.

The density increment for r_3(N) uses ‖·‖₂-almost-periodicity (because the density increment step requires L²-control of the increment). The L¹ analogue would give:

> ‖f * μ_B - f‖₁ ≤ ε‖f‖₁, for B = Bohr(Spec_δ^{(\ell^1)}(f), ρ)

where Spec_δ^{(ℓ¹)}(f) = {ξ: |f̂(ξ)| ≥ δ‖f̂‖_∞} has size O(α^{-1}).

---

## Is the ℓ¹ Almost-Periodicity Sufficient for the Density Increment?

**The answer is NO for the standard density increment** — the increment step requires:

$$\frac{1}{|B|}\sum_{h \in B} (A - α) * \mu_B (n) \text{ has some structure} \implies \text{density increase}$$

The standard argument (Bogolyubov–Ruzsa–Kelley-Meka) works in L²: it requires
‖(1_A - α) * μ_B‖₂ to be small, which gives L²-almost-periodicity. The L¹ version ‖(1_A - α) * μ_B‖₁ being small is WEAKER (L² control implies L¹ control but not conversely).

**Specifically**: the density increment step requires showing A has density > α on some translate of B. This uses:
$$\mathbb{E}_h \|1_A * \delta_h - 1_A\|_1 \lesssim \text{rank of Bohr set} \cdot \rho$$
and the density increment comes from a Fourier analysis that requires L² control.

**Conclusion**: The ℓ¹-normalized large spectrum (size O(α^{-1})) gives a Bohr set of rank O(α^{-1}). But the density increment argument for 3-APs (as in Kelley–Meka) needs L²-almost-periodicity. The L¹ Bohr set of rank O(α^{-1}) gives L¹-almost-periodicity but NOT automatically L²-almost-periodicity. To use rank O(α^{-1}) in the density increment, one needs a modified argument that works with L¹ control.

---

## Summary

1. **Standard Croot–Sisask**: Uses ℓ² threshold δ‖f‖₂. Spectrum size O(α^{-2}). Bohr rank O(α^{-2}). Exponent ceiling 1/6 (Raghavan 2026).

2. **ℓ¹ spectrum** (available but NOT used in current proofs): Uses ℓ¹ threshold δ‖f̂‖_∞ = δα. Spectrum size O(α^{-1}). Would give Bohr rank O(α^{-1}) IF the density increment works with L¹ control.

3. **The gap**: The density increment for 3-APs requires L² almost-periodicity (or a new argument). The ℓ¹ Bohr set has rank O(α^{-1}) but only gives L¹ almost-periodicity — insufficient for the standard density increment.

4. **What would it take to use rank O(α^{-1})?** A new "L¹ density increment" argument for 3-APs. This is essentially the same as proving Conjecture 3 (doubly-iterated Raghavan, exponent 1/3). The ℓ¹ spectral bound alone does NOT give exponent 1/3 — one also needs to redesign the density increment step.

5. **Kelley–Lyu connection**: Kelley–Lyu's improvement in the bipartite setting comes from using the analogue of ℓ¹ spectral control (rank O(β^{-1})) in THEIR density increment framework, which naturally works in L¹ due to the bipartite structure. Porting this to 3-APs requires a new L¹ density increment — this is the true content of BL1-GRID and is an open research question.
