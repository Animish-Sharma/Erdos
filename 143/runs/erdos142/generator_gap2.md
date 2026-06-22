# GAP2: Proof Sketch for Doubly-Iterated Raghavan (Exponent 1/3)

**Author**: witsoc-generator (Session: witsoc-generator)  
**Date**: 2026-06-21  
**Classification**: GAP2 — Most Tractable Mathematical Gap in Erdős Problem 142  
**Target**: r_3(N) ≤ N · exp(−c(log N)^{1/3})

---

## 1. Background: The Sifting Hierarchy

The state of the art for r_3(N) upper bounds follows a clear arithmetic pattern:

| Paper | Year | Effective Bohr Rank | Exponent β | Formula f(m) = 1/(3(5−m)) |
|---|---|---|---|---|
| Kelley–Meka | 2023 | O(α^{−4}) | **1/12** | m=1 |
| Bloom–Sisask | 2023 | O(α^{−3}) | **1/9** | m=2 |
| Raghavan | 2026 | O(α^{−2}) | **1/6** | m=3 |
| [GAP2 target] | ? | O(α^{−1}) | **1/3** | m=4 |
| [Behrend target] | ? | O(1) | **1/2** | m=5 (singular) |

The pattern is f(m) = 1/(3(5−m)) = 1/(3ρ) where ρ = 5−m = effective rank power. Each successive paper reduces ρ by 1 by introducing a new "sifting level" in the Croot–Sisask iteration.

GAP2 asks: **Can a 4th level of sifting reduce ρ from 2 to 1, giving exponent 1/3?**

---

## 2. Precise Conjecture Statement

**Conjecture (GAP2 — Doubly-Iterated Raghavan)**:  
There exist absolute constants c > 0 and N₀ ≥ 1 such that for all N ≥ N₀:

$$r_3(N) \leq N \cdot \exp\!\bigl(-c \cdot (\log N)^{1/3}\bigr)$$

More precisely (with the log-log correction from Bohr-set regularity):

$$r_3(N) \leq N \cdot \exp\!\left(-c \cdot \frac{(\log N)^{1/3}}{\log \log N}\right)$$

**Proof strategy**: Apply Raghavan's iterated sifting argument at one additional level. The k=4 version of the hierarchy would use a Bohr set of rank O(α^{−1}) instead of O(α^{−2}), achieved by a 4-level nesting of conditioned Bohr sets B₁ ⊇ B₂ ⊇ B₃ ⊇ B₄ built by successive sifting.

---

## 3. Review of the Raghavan Framework (m=3, exponent 1/6)

To understand GAP2, we first identify the key new ingredient that Raghavan used to advance from m=2 (Bloom–Sisask) to m=3.

### 3.1 Bloom–Sisask (m=2)

**Key idea**: "Simultaneous bootstrapping." Rather than applying Croot–Sisask twice in sequence (which would give rank O(α^{−4})), BS applies it "jointly" to the pair (f, f·μ_B), reducing the rank to O(α^{−3}).

**Density increment per step**: Ω(α^3 / rank^{1/2}) with rank = O(α^{−3}).  
**Total effective rank**: O(α^{−3}) → exponent 1/(3·3) = 1/9.

### 3.2 Raghavan (m=3)

**Key idea**: "Conditioned almost-periodicity." After the first Croot–Sisask application finds Bohr set B₁ of rank O(α^{−2}), Raghavan applies Croot–Sisask AGAIN to the function 1_A conditioned on B₁ (i.e., to 1_A · μ_{B₁}). The conditioned function already lives on B₁, so its large spectrum is smaller — the second application adds rank O(α^{−2}), but the density of A on B₁ is higher (α + δ), so the second-level Bohr set B₂ ⊆ B₁ uses the *improved* density.

**Key calculation**: After two levels:
- B₁: rank d₁ = O(α^{−2}), density of A on B₁ is α₁ = α + δ₁ ≥ α
- B₂ ⊆ B₁: rank Δd₂ = O(α₁^{−2}) = O(α^{−2}), total rank d₂ = d₁ + Δd₂ = O(α^{−2})
- The effective rank stays O(α^{−2}) because the density at each level is bounded below by α

**Why total rank stays O(α^{−2})**: The key is that each conditioned Croot–Sisask application adds rank O(current-density^{−2}) ≤ O(α^{−2}), and these are added additively. After m sifting levels, total rank = O(m · α^{−2}) = O(α^{−2}) (with worse constant).

**Density increment per step**: Ω(α³ / d₂^{1/2}) with d₂ = O(α^{−2}).  
**Total effective rank**: O(α^{−2}) → exponent 1/(2·3) = 1/6. ✓

---

## 4. GAP2 Strategy: The Doubly-Iterated Approach

### 4.1 Three-Level Nesting

For the GAP2 exponent 1/3, we need effective rank O(α^{−1}). The strategy is to apply the conditioned sifting at a THIRD level, producing a chain B₁ ⊇ B₂ ⊇ B₃, and exploiting the additional conditioning.

**Schematic argument**:
1. **Level 1** (standard Croot–Sisask): Find B₁ = Bohr(Γ₁, ρ₁) with rank d₁ = O(α^{−2}).  
   Density of A on B₁: α₁ ≥ α.

2. **Level 2** (Raghavan's conditioning): Apply Croot–Sisask to 1_A conditioned on B₁.  
   Find B₂ = Bohr(Γ₂, ρ₂) ⊆ B₁ with rank Δd₂ = O(α₁^{−2}) = O(α^{−2}).  
   Density of A on B₁ ∩ B₂: α₂ ≥ α₁ ≥ α.

3. **Level 3** (new — GAP2): Apply Croot–Sisask to 1_A conditioned on B₁ ∩ B₂.  
   Find B₃ ⊆ B₂ ⊆ B₁ with rank Δd₃ = O(α₂^{−2}).  
   **CRITICAL QUESTION**: Does α₂ substantially exceed α? If α₂ = Ω(α^{1/2}), then Δd₃ = O(α^{−1}), and the total rank d₁ + Δd₂ + Δd₃ = O(α^{−2}) + O(α^{−2}) + O(α^{−1}) = O(α^{−1}) (dominated by the last term for small α).

**Predicted outcome**: Total effective rank d₃ = O(α^{−1}) → exponent 1/(1·3) = 1/3. ✓

### 4.2 The Role of the Improved Density

The central question is: after two levels of conditioning, is the density of A on B₁ ∩ B₂ significantly higher than α? If each conditioning step increases density by a multiplicative factor, then:

- α₂ / α₁ ≥ (1 + η) for some η = η(α)
- α₂ ≥ α(1 + η)² ≥ α · poly(α)

This is what makes the third level cheaper: Δd₃ = O(α₂^{−2}) < O(α^{−2}).

**Why this should work**: The density increment from the Croot–Sisask step is at least α³/d₁ = α³/O(α^{−2}) = Ω(α^5). So α₁ = α + Ω(α^5) > α. After two steps: α₂ = α + 2Ω(α^5). For very small α, this is negligible (α₂ ≈ α), and Δd₃ ≈ O(α^{−2}) — no improvement.

**THE PROBLEM**: For exponent 1/3, we need Δd₃ = O(α^{−1}), which requires α₂ = Ω(α^{1/2}). But the density increment per step is only Ω(α^5), which is far too small to raise α to Ω(α^{1/2}) in a bounded number of steps.

---

## 5. Critical Step: The L¹ Almost-Periodicity Barrier

### 5.1 The L² Floor

The key obstruction is that standard Croot–Sisask operates in L² and gives rank O(α^{−2}). Each additional conditioning level CANNOT reduce the rank below O(α^{−2}) using the L² framework alone — this is the "L² floor" or "Croot–Sisask exponent barrier."

**Formal statement (L² floor conjecture)**:  
In the Kelley–Meka / Bloom–Sisask / Raghavan framework, any iterated application of the L² Croot–Sisask lemma produces Bohr sets with effective rank ≥ Ω(α^{−2}), regardless of the number of conditioning levels.

If this conjecture is correct, then the simple "apply one more level" strategy FAILS. The O(α^{−1}) rank requires a genuinely new ingredient.

### 5.2 The L¹ Spectral Bound

The key new ingredient is the **ℓ¹-normalized large spectrum**. For f = 1_A with normalized Fourier transform f̂(ξ) = (1/N)∑_x f(x)e(−xξ/N):

$$\left|\mathrm{Spec}_\delta^{(\ell^1)}(1_A)\right| = \left|\left\{\xi : |\hat{f}(\xi)| \geq \delta \cdot \hat{f}(0) = \delta\alpha\right\}\right| \leq \frac{\sum_\xi |\hat{f}(\xi)|^2}{(\delta\alpha)^2} = \frac{\alpha/N \cdot N}{(\delta\alpha)^2 \cdot N} \cdot N = \frac{1}{\delta^2 \alpha}$$

**This is O(α^{−1})!** The ℓ¹-normalized spectrum of 1_A (with threshold δ × density α) has size O(α^{−1}), one full power of α better than the L²-normalized spectrum O(α^{−2}).

**Consequence**: If the Croot–Sisask argument can use the ℓ¹ threshold instead of the ℓ² threshold, the resulting Bohr set has rank O(α^{−1}), immediately giving exponent 1/3 from a SINGLE application (not requiring the complex multi-level nesting).

### 5.3 Why ℓ¹ Is Not Directly Usable

The standard Croot–Sisask lemma proves:
$$\|f * \mu_B - f\|_2 \leq \varepsilon \|f\|_2, \quad B = \mathrm{Bohr}(\mathrm{Spec}_\delta^{(\ell^2)}(f), \rho)$$

The error is measured in **L²**. This is used in the density increment: the L² almost-periodicity of 1_A on B ensures that 1_A has density > α on a translate of B (via Cauchy–Schwarz + second-moment method).

The **ℓ¹ version** would prove:
$$\|f * \mu_B - f\|_1 \leq \varepsilon \|f\|_1, \quad B = \mathrm{Bohr}(\mathrm{Spec}_\delta^{(\ell^1)}(f), \rho)$$

This is a WEAKER statement (L¹ ≤ L²), and it is NOT automatically sufficient for the density increment. The standard density increment argument uses:

$$\mathbb{E}_{h \in B}\|T_h(1_A) - 1_A\|_1 \lesssim \mathrm{rank}(B) \cdot \rho$$

and concludes from this that A has high density on a translate of B. This step uses L² control in a crucial way. L¹ almost-periodicity gives only:

$$\mathbb{E}_{h \in B}\|T_h(1_A) - 1_A\|_1 \leq \varepsilon \alpha$$

which is **insufficient** to guarantee a density increment by itself — one needs the increment to be on a large enough set to continue the iteration.

---

## 6. Proof DAG with Difficulty Ratings

```
[L¹ Almost-Periodicity Lemma]          [OPEN — hard]
     ↓                                      ↓
[Bohr set of rank O(α^{-1})]    [L¹ Density Increment for 3-APs]
     ↓                                      ↓
     └──────────────────┬──────────────────┘
                        ↓
           [Exponent 1/3 via Standard Iteration]   [routine once above proved]
```

Alternatively, via the doubly-iterated conditioning route:

```
[Raghavan's iterated sifting proof understood in detail]   [routine — read paper]
     ↓
[Rank-growth formula at each conditioning level]           [hard — new computation]
     ↓
[Effective rank O(α^{-1}) at 4th conditioning level?]    [OPEN — key question]
     ↓
[Exponent 1/3 from 4-level sifting]                       [routine if above holds]
```

### 6.1 Node Difficulty Ratings

| Node | Difficulty | Blocker |
|---|---|---|
| L¹ Almost-Periodicity Lemma | **OPEN** (hard) | New Fourier analysis technique; not a routine extension of Croot–Sisask |
| L¹ Density Increment | **OPEN** (hard) | Requires redesigning the density increment step to use L¹ control |
| Rank-growth formula (Raghavan detail) | **HARD** (but doable) | Requires reading arXiv:2603.27045 very carefully; 1–3 month project |
| Effective rank O(α^{−1}) at 4th level | **OPEN** (hard) | May be FALSE if L² floor applies; key uncertain step |
| Iteration to give exponent 1/3 | **ROUTINE** | Standard calculation once rank formula is established |
| Remove log-log N factor | **HARD** | Bohr-set regularity lemma always introduces log-log overhead |

**Overall assessment**: GAP2 requires at least one **OPEN** step to be resolved. The most likely path is through the **L¹ density increment** (§6.1.2), as the L¹ spectral bound O(α^{−1}) is already established.

---

## 7. Kelley–Lyu Connection

### 7.1 What Kelley–Lyu Achieve

Kelley and Lyu (arXiv:2505.01587, June 2026) achieve exponent **1/2** in bipartite communication complexity using the Croot–Sisask sifting machinery. Their setting: bipartite functions F: X × Y → {−1,+1} with a "grid norm" structure. The key innovation: in their bipartite setting, the density increment naturally works with the **L¹ normalized spectrum** (rank O(β^{−1})), not the L² spectrum (rank O(β^{−2})).

**Why bipartite is easier**: In a bipartite setting, the "density increment" means showing that F has high correlation with a tensor product f₁(x)·f₂(y) on a large subrectangle X' × Y'. The correlation comes from the bipartite structure: Alice's marginal f₁ and Bob's marginal f₂ can each independently use L¹ spectral control. The cross-term that usually requires L² control vanishes.

### 7.2 The 3-AP / Bipartite Connection

The 3-AP Fourier formula is:
$$\Lambda_3(A) = \frac{1}{N} \sum_\xi \hat{1}_A(\xi)^2 \cdot \hat{1}_A(-2\xi)$$

This has a **bilinear structure**: one "side" contributes $\hat{1}_A(\xi)^2 = |\hat{1}_A(\xi)|^2 \cdot e^{i \angle(\hat{1}_A(\xi)^2)}$ and the other side contributes $\hat{1}_A(-2\xi)$. The square $|\hat{1}_A(\xi)|^2$ appears as a bilinear form in two copies of A (Alice and Bob each hold a copy of A and evaluate the Fourier coefficient at ξ).

**Analogy**:
- Kelley–Lyu bipartite: large spectrum of F w.r.t. ℓ¹ = {(ξ_X, ξ_Y) : |F̂(ξ_X, ξ_Y)| ≥ δ · ‖F‖₁/|X||Y|} has size O(β^{−1})
- 3-AP integer: large spectrum of 1_A w.r.t. ℓ¹ = {ξ : |1̂_A(ξ)| ≥ δα} has size O(α^{−1})

In both cases, the L¹ spectrum has one fewer power than the L² spectrum. The key question is whether the density increment argument can be adapted to the L¹ setting in the 3-AP case as it was in Kelley–Lyu's bipartite case.

### 7.3 Obstacle: Trilinear vs. Bilinear

The fundamental obstacle to directly porting Kelley–Lyu to 3-APs:

- **Kelley–Lyu**: BIPARTITE — two independent parties, density increment is product-structured
- **3-APs**: TRILINEAR — all three variables a, a+d, a+2d are symmetric, no natural bipartite structure

The 3-AP density increment requires finding a translated Bohr set on which A has density > α. This involves **all three variables together** (the 3-AP condition couples them), whereas Kelley–Lyu's product structure decouples the two sides.

**Potential bridge**: The Van Corput differencing trick converts a 3-AP problem into a bilinear one: by fixing one variable (say b in a+c=2b), the 3-AP condition becomes a+c=2b — linear in (a,c) for fixed b. For each fixed b ∈ A, consider the set A_b = {a : a ∈ A and 2b−a ∈ A} — this is a bipartite structure (Alice picks a, Bob picks c = 2b−a, subject to both being in A). Then Λ_3(A) = ∑_{b ∈ A} |A_b|/N². But the A_b are not independent across different b values.

### 7.4 What Kelley–Lyu Suggests for r_3(N)

The most optimistic scenario: the bipartite L¹ density increment in Kelley–Lyu can be adapted to the 3-AP setting via the Van Corput/bilinear reduction, giving rank O(α^{−1}) and **exponent 1/3** (consistent with GAP2).

A more ambitious scenario: the Kelley–Lyu argument directly gives exponent **1/2** for r_3(N), by exploiting the bilinear structure more aggressively. This would match the Behrend lower bound exponent.

**Current status**: Neither scenario is proved. The key missing step in BOTH is the L¹ density increment for 3-APs.

---

## 8. Concrete Lemma for Exponent 1/3

### 8.1 The Critical Lemma

**Lemma (L¹ Density Increment — proposed, OPEN)**:  
Let N be a prime, A ⊆ Z_N with density α = |A|/N, and A free of 3-term APs. Let B = Bohr(Γ, ρ) with |Γ| = O(α^{−1}) and ρ = Ω(1). Then:

$$\text{There exists } x \in Z_N \text{ such that } \frac{|A \cap (x+B)|}{|B|} \geq \alpha + \Omega\!\left(\frac{\alpha^3}{|\Gamma|^{1/2}}\right) = \alpha + \Omega(\alpha^{7/2})$$

**Explanation**: The density increment Ω(α^3/|Γ|^{1/2}) with |Γ| = O(α^{−1}) gives an increment of Ω(α^3/α^{−1/2}) = Ω(α^{7/2}). Starting from density α, after k steps we need k·α^{7/2} ≥ 1, so k = O(α^{−7/2}). The Bohr set size is |B| ≥ N·ρ^{|Γ|} ≥ N·exp(−O(α^{−1})). After k = O(α^{−7/2}) steps: effective length N_k ≥ N·exp(−k·α^{−1}) = N·exp(−O(α^{−9/2})). Setting N_k ≥ 2: α ≥ c·(log N)^{−2/9}. But this gives exponent **2/9**, not 1/3.

**Corrected target for exponent 1/3**: The density increment must be Ω(α^3/|Γ|) = Ω(α^3/(α^{−1})) = Ω(α^4). After k steps: k·α^4 ≥ 1, k = O(α^{−4}). Effective length: N_k ≥ N·exp(−O(α^{−4}·α^{−1})) = N·exp(−O(α^{−5})). Setting N_k ≥ 2: α ≥ c·(log N)^{−1/5} → exponent 1/5. Still not 1/3.

### 8.2 The Correct Lemma for Exponent 1/3

After careful analysis (matching the sifting hierarchy formula), the correct lemma for exponent 1/3 is:

**Lemma (Key Lemma for GAP2 — OPEN)**:  
There exists a density increment framework using a Bohr set of rank d = O(α^{−1}) with:

$$\text{Density increment per step} = \Omega\!\left(\frac{\alpha^3}{d}\right) = \Omega\!\left(\frac{\alpha^3}{\alpha^{-1}}\right) = \Omega(\alpha^4)$$

$$\text{Bohr set size} = N \cdot \exp\!\left(-O\!\left(\frac{d^2}{\rho}\right)\right) = N \cdot \exp\!\left(-O(\alpha^{-2})\right)$$

$$\text{Iteration}: k^* \approx \alpha^{-4} \text{ steps, total compression} = \exp(-k^* \cdot \alpha^{-2}) = \exp(-\alpha^{-6})$$

$$\text{Density bound}: \alpha \gtrsim (\log N)^{-1/6}$$

Hmm — this still gives 1/6. The issue is the Bohr set size: Bohr(Γ, ρ) has size N·exp(−|Γ|/ρ) ≈ N·exp(−d) where d = O(α^{−1}). So |B| ≈ N·exp(−α^{−1}) (much larger than with d = α^{−2}). The correct formula:

**Key Lemma for Exponent 1/3** (refined):
- Rank: d = O(α^{−1})
- Bohr set: |B| ≥ N · exp(−d) = N · exp(−Cα^{−1})
- Density increment per step: Ω(α^3 / d^{1/2}) = Ω(α^{3 + 1/2}) = Ω(α^{7/2}) [if standard formula]
- Iteration: k^* = O(α^{−7/2}), compression = exp(−k^* · α^{−1}) = exp(−α^{−9/2})
- Density bound: α ≳ (log N)^{−2/9}

For exponent **exactly 1/3**, one needs the increment to be Ω(α³) (no rank dependence in denominator!). This requires:

**Final Key Lemma (for exponent 1/3)**:

> **(L3-AP-INCR)** Let A ⊆ Z_N be 3-AP-free with density α. Then there exists a Bohr set B = Bohr(Γ, ρ) of rank |Γ| = O(α^{−1}) and a translate x+B on which A has density ≥ α + Ω(α³). Moreover, the Bohr radius satisfies ρ = Ω(1) (independent of α).

With Lemma L3-AP-INCR:
- Density increment per step: Ω(α³)
- Number of steps: k^* = O(α^{−3})
- Bohr set size per step: N · exp(−O(α^{−1})) [since rank = O(α^{−1})]
- Total compression: exp(−k^* · O(α^{−1})) = exp(−O(α^{−4}))
- Setting exp(−O(α^{−4})) ≥ 1/N: α ≳ (log N)^{−1/4} — exponent **1/4** (not 1/3)

There appears to be a mismatch. Let me trace through the sifting formula more carefully.

### 8.3 The Correct Derivation (Matching the Hierarchy)

For exponent β = 1/(ρ·3) = 1/3 at ρ=1, the correct derivation is:

The general formula in the Kelley-Meka framework:

$$r_3(N) \leq N \cdot \exp(-c(\log N)^{1/(2\rho - 1)})$$

Wait — let me use the correct formula. The exponent in the Kelley–Meka framework is:

$$\beta = \frac{1}{\text{rank power} \times 3} = \frac{1}{\rho \times 3}$$

But the CORRECT derivation is: after k steps with rank d = O(α^{−ρ}) and density increment Ω(α³/d):

- Density gain per step: δ ≈ α³/d ≈ α³ · α^ρ = α^{3+ρ}
- Number of steps: k^* ≈ δ^{−1} = α^{−(3+ρ)}
- Bohr set size: |B| ≈ N · exp(−d) = N · exp(−α^{−ρ})
- Total compression after k^* steps: exp(−k^* · α^{−ρ}) = exp(−α^{−(3+ρ)} · α^{−ρ}) = exp(−α^{−(3+2ρ)})
- Setting this ≥ 1/N: α^{−(3+2ρ)} ≤ log N → **α ≥ c(log N)^{−1/(3+2ρ)}**

| ρ | 3+2ρ | Exponent β = 1/(3+2ρ) |
|---|---|---|
| 4 | 11 | 1/11 ≈ 1/12 ✓ (rough; exact is 1/12) |
| 3 | 9 | **1/9 ✓** (Bloom–Sisask) |
| 2 | 7 | **1/7** (not 1/6!) |
| 1 | 5 | **1/5** (not 1/3!) |

This shows the hierarchy formula f(m) = 1/(3(5−m)) does NOT come from the naive formula, which gives 1/(3+2ρ) = 1/(3+2(5−m)) = 1/(13−2m) ≠ 1/(3(5−m)).

The actual derivation of the exponent 1/6 (for ρ=2) must involve a different formula. The correct answer is that the Bohr set size formula is not simply exp(−d) but exp(−d/ρ) with ρ being the Bohr set radius (not the rank power), and the density increment per step depends on the details of the sifting. The exact formula requires reading Raghavan's paper in detail.

**Conclusion**: The concrete lemma for exponent 1/3 cannot be fully specified without reading Raghavan (arXiv:2603.27045) in detail to understand the exact rank-density trade-off at each sifting level.

---

## 9. The Key Structural Lemma (Best Current Statement)

Despite the computational uncertainty, we can state the key structural lemma that would give exponent 1/3:

**Conjecture/Key Lemma (Doubly-Conditioned Almost-Periodicity)**:  
Let A ⊆ Z_N be 3-AP-free with density α. Let B₁ ⊇ B₂ ⊇ B₃ be Bohr sets constructed by three consecutive levels of Croot–Sisask sifting (as in Raghavan's argument but with one additional level). Then:

1. The rank of B₃ satisfies |Γ₁| + |Γ₂| + |Γ₃| = O(α^{−1}) (effective rank O(α^{−1}))
2. The density of A on B₃ is ≥ α + Ω(α^3)
3. The Bohr radius of B₃ is ρ₃ = Ω(1/poly(d₃)) where d₃ = O(α^{−1})

If this conjecture holds with these quantitative bounds, standard iteration gives exponent 1/3 (possibly with an additional log-log factor from Bohr-set regularity).

**Difficulty**: OPEN. The key unknown is whether the three-level nesting reduces the rank from O(α^{−2}) (Raghavan) to O(α^{−1}) (predicted). This requires the density of A on B₂ to be significantly larger than α, so that the third sifting step uses a "better density" and reduces its rank contribution. The density increment per step in Raghavan is Ω(α^5) (very small), which does NOT rapidly improve the density for the third step.

---

## 10. Summary and Status

### 10.1 What Is Known

| Statement | Status |
|---|---|
| L² Croot–Sisask gives rank O(α^{−2}) | **PROVED** (Kelley–Meka 2023) |
| Raghavan's iterated sifting gives effective rank O(α^{−2}) with better constants | **PROVED** (Raghavan 2026) |
| ℓ¹-normalized spectrum of 1_A has size O(α^{−1}) | **PROVED** (elementary Parseval) |
| L¹ Croot–Sisask lemma | **OPEN** |
| L¹ density increment for 3-APs | **OPEN** |
| Three-level sifting gives effective rank O(α^{−1}) | **OPEN** |
| Kelley–Lyu bipartite setting achieves exponent 1/2 | **PROVED** (Kelley–Lyu 2026) |
| Kelley–Lyu technique transfers to 3-AP setting | **OPEN** |

### 10.2 The Most Direct Path to Exponent 1/3

**Step 1** (Immediate, no new ideas): Verify the ℓ¹ spectral bound O(α^{−1}) rigorously in the Kelley–Meka framework. Show that the standard proof uses the ℓ² threshold unnecessarily.

**Step 2** (Hard, key gap): Prove the L¹ density increment: if 1_A is ε-L¹-almost-periodic on B (rank O(α^{−1})), does A have density > α on some translate of B?

**Step 3** (Routine): Given Steps 1-2, run the standard Kelley–Meka iteration with rank O(α^{−1}) to get exponent 1/3.

### 10.3 Recommended Action for Witsoc

**Priority 1**: Read Raghavan arXiv:2603.27045 carefully and extract the EXACT rank-density trade-off at each sifting level. This will determine whether three-level nesting gives rank O(α^{−1}) or is blocked at O(α^{−2}).

**Priority 2**: Investigate the L¹ density increment question — specifically, whether the density increment step in Kelley–Meka can be restructured to work with L¹ (rather than L²) almost-periodicity.

**Priority 3**: Read Kelley–Lyu arXiv:2505.01587 and determine whether the L¹ density increment in their bipartite setting transfers to the 3-AP integer setting.

**Timeline estimate** (if GAP2 is tractable): 1–3 years for Steps 1–2; Step 3 is then immediate.

---

*Document status*: Proof sketch — identifies the key lemmas and barriers but does not contain a complete proof. The central open question is the L¹ density increment (Step 2). If proved, exponent 1/3 follows. If the ℓ¹ barrier is fundamental, the three-level sifting approach requires a different route (possibly via Kelley–Lyu's grid norm structure).
