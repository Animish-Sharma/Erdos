# Hypothesis Summary: The Central Conjecture and Near-Term Research Program

**Author**: OpenScientist Lovász-mode Agent  
**Date**: 2026-06-21  
**Full strategy**: `research/proof_strategy.md`

---

## Central Hypothesis: The Behrend Convergence Conjecture

> **r_3(N) = N · exp(-(c* + o(1)) · √(log N))**
> where c* ≈ 2.667 is the optimal constant from Elsholtz–Hunter–Proske–Sauermann (2024),
> and the exponent α₃ = 1/2 is exactly Behrend's exponent.

This is **Level 2** of the asymptotic program: proving that r_3(N) = N · exp(-Θ(√(log N))). The lower bound (r_3(N) ≥ N · exp(-C√(log N))) is already known from Behrend (1946); the open problem is the matching **upper bound**.

### Why This Hypothesis Is Worth Pursuing

1. **The trajectory is pointing here**: The quasi-polynomial upper bound exponent has improved as 1/12 → 1/9 → 1/6 (in 2023, 2023, 2026). The natural projection of this trajectory reaches 1/3 (next step) and eventually 1/2.

2. **The lower bound saturates the Croot–Sisask framework**: Behrend sets (sphere intersections in Z^d) have no large Fourier coefficients and almost-periodic rank exactly ~ (log N)^{1/2}, which is the minimum possible rank that Croot–Sisask can produce for a set of density exp(-c√(log N)). This matching is not a coincidence — it suggests the upper bound method, when optimal, should give exactly this density.

3. **Finite field evidence**: In F₃ⁿ, the polynomial method gives an exponential upper bound matching (to constant factor) the Salem–Spencer lower bound. The integer analogue would be r_3(N) = N · exp(-Θ(√(log N))), and the "polynomial method for integers" (if developed) would give this.

4. **Expert consensus**: The prevailing expert opinion in additive combinatorics (based on analogy, heuristics, and prior experience) is that Behrend's 1946 construction captures the correct asymptotic.

---

## Three Supporting Conjectures

### Conjecture I: The Sifting Hierarchy Formula

The exponent achievable by m-fold iterated Raghavan-style sifting is:

**f(m) = 1 / (3 · (5 − m))   for m = 1, 2, 3, 4**

| m | Method | Exponent |
|---|---|---|
| 1 | Kelley–Meka 2023 | 1/12 = 0.083 |
| 2 | Bloom–Sisask 2023 | 1/9 = 0.111 |
| 3 | Raghavan 2026 | 1/6 = 0.167 |
| **4** | **Next (prediction)** | **1/3 = 0.333** |

**Current status**: Confirmed for m=1,2,3. Prediction for m=4 is **the most important near-term testable claim** in this field — achievable in 1–3 years.

**What it implies**: The sifting approach has a provable ceiling at exponent 1/3. Surpassing 1/3 requires breaking the Croot–Sisask barrier (rank Ω(α^{-2})).

---

### Conjecture II: The k=4 Bottleneck

**r_4(N) ≤ N · exp(-c(log N)^ε) for any ε > 0**  
requires proving a "Quadratic Croot–Sisask Lemma":

> *If f: Z_N → [-1,1] with ‖f‖_{U³} ≥ δ, there exists a 2-step nil-Bohr set of quasipolynomial dimension on which f is "U²-almost-periodic."*

**Current status**: Open. No quasi-polynomial bound is known for r_4(N); the best is Green–Tao 2017's N/(log N)^c. This is the single most important barrier separating k=3 and k=4 asymptotics.

**What proving it would achieve**: The first quasi-polynomial bound for 4-AP-free sets — a breakthrough comparable to Kelley–Meka (2023) for 3-APs.

---

### Conjecture III: Rankin Tightness for k=5

**r_5(N) = N · exp(-Θ((log N)^{1/3}))**

The exponent for k=5 matches Rankin's (1961) construction, not the Behrend exponent of 1/2.

**Current status**: The upper bound (Leng–Sah–Sawhney 2024) is N · exp(-(log log N)^{c_5}), far weaker. The lower bound from Rankin is N · exp(-C(log N)^{1/3}).

**What it implies**: The Leng–Sah–Sawhney bound for k≥5 is far from tight. A quasi-polynomial upper bound for k=5 matching Rankin's construction would be a major theorem.

---

## The Key Gap and Why It Matters

```
Current upper bound exponent: 1/6  (Raghavan 2026)
       ↑ gap of ~0.17 exponent units
Predicted next step:          1/3  (doubly-iterated sifting, ~2028?)
       ↑ gap of ~0.17 exponent units  
Target (Behrend):             1/2  (requires new ideas beyond sifting)
```

The **1/3 barrier** is the most important near-term goal. Getting from 1/3 to 1/2 is a second, harder problem that may require the integer polynomial method (Strategy B) or a new structural insight.

---

## What Each Approach Could Achieve

| Approach | Main Idea | Predicted Exponent | Difficulty |
|---|---|---|---|
| **A: Doubly-iterated sifting** | Nest Raghavan's sifting twice | 1/3 | Medium (1–3 years) |
| **B: L¹ Croot–Sisask** | Replace L² by L¹ norm in almost-periodicity | 1/3 via different route | Medium (2–5 years) |
| **C: Integer polynomial capacity** | "Z-slice rank" for 3-APs in {1,...,N} | Potentially 1/2 | Hard (5-15 years) |
| **D: Behrend stability theorem** | AP-free sets are sphere-like | Closes Level 3 (exact constant) | Very hard (10-20 years) |

---

## Prioritized Action Plan

### Immediate (0–1 year)
1. **Attempt doubly-iterated sifting** (Conjecture I, m=4). Study Raghavan's paper; apply the sifting procedure twice. Target: exponent 1/3 or close.
2. **Check whether Raghavan's log log factor is removable**. A cleaner version of his argument might give pure exponent 1/6, clarifying the structure needed for m=4.
3. **Improve Behrend constant computationally**. Use algebraic geometry over small primes p to find AP-free sets in Z better than Elsholtz et al.'s c* ≈ 2.667.

### Short-term (1–3 years)
4. **Prove or disprove Conjecture I** (Sifting Formula). If it's false (doubly-iterated sifting gives ≠ 1/3), update the strategy.
5. **Develop L¹ almost-periodicity** (targeting rank O(α^{-1})). This would give exponent 1/3 by a different, possibly more flexible route.
6. **First attempt at quadratic almost-periodicity** for k=4.

### Medium-term (3–10 years)
7. **Surpass the 1/3 barrier** using new ideas (integer polynomial method or other).
8. **Quasi-polynomial bound for k=4**.
9. **Structural theorem** for near-extremal AP-free sets.

---

## Falsification Criteria

The central hypothesis (r_3(N) = N · exp(-Θ(√(log N)))) would be **falsified** by:
- A 3-AP-free set A ⊂ {1,...,N} with |A| ≥ N · exp(-c(log N)^{1/2-ε}) for some ε > 0 and all large N (impossible under current lower bounds, but would make the hypothesis stronger).
- An upper bound r_3(N) ≤ N · exp(-c(log N)^{1/2+ε}) for any ε > 0 and all large N (would make the exponent in the upper bound LARGER than 1/2, contradicting the Behrend lower bound — this would be a contradiction, showing the hypothesis cannot be "overshoot" from above).

Wait — actually, the hypothesis CAN only be falsified from below (by a construction exceeding Behrend by a super-Behrend factor) or proven by the upper bound matching. It cannot be falsified by a worse upper bound.

The Sifting Formula (Conjecture I) is **falsified** by:
- A doubly-iterated sifting argument giving exponent ≠ 1/3 (either strictly better or strictly worse).

**The most important falsifiable prediction in the next 2 years**: f(4) = 1/3 from doubly-iterated sifting.

---

## Key References

| Paper | Key Contribution |
|---|---|
| Behrend (1946) | Construction: r_3(N) ≥ N·exp(-c√(log N)) |
| Kelley–Meka (2023) | Quasi-polynomial upper bound, exponent 1/12 |
| Bloom–Sisask (2023) | Improved exponent to 1/9 |
| Raghavan (2026) | Current best: exponent 1/6 |
| Elsholtz–Hunter–Proske–Sauermann (2024) | Improved Behrend constant to c* ≈ 2.667 |
| Leng–Sah–Sawhney (2024) | k≥5 quasi-poly via U^{k-1} inverse theorem |
| Green–Tao (2017) | k=4: N/(log N)^c (polylogarithmic) |

---

## Post-Review Update (June 2026)

A recent preprint **Kelley–Lyu (2026)** (arXiv:2505.01587) improves the sifting argument for "grid norms" in the context of multiparty communication complexity, achieving an exponent of 1/2 in that setting (up from 1/3). This uses the same sifting machinery as Kelley–Meka for r_3(N).

**Implication**: The sifting approach may be capable of reaching exponent 1/2 in the r_3(N) setting as well, if the grid-norm improvement can be ported to the arithmetic progression context. This would mean:

- Conjecture I (ceiling at 1/3) may be too pessimistic.
- The Central Hypothesis (exponent 1/2 is achievable within the sifting framework) gains supporting evidence.
- **Most urgent research direction**: Understand whether the Kelley–Lyu grid norm sifting improvement transfers to 3-AP counting, and if so, whether it gives exponents approaching 1/2.

---

*For full technical detail on barriers, proof strategies, and conjectures, see `research/proof_strategy.md`.*
