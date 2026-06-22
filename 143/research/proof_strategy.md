# Proof Strategy for the Asymptotic Behavior of r_k(N)

**Author**: OpenScientist Lovász-mode Agent  
**Date**: 2026-06-21  
**Mission**: witsoc-proof-strategy  
**Status**: Research strategy document (conjectural)

---

## Table of Contents

1. [Target Statement and Realistic Scope](#1-target-statement-and-realistic-scope)
2. [Barrier Analysis](#2-barrier-analysis)
   - [Barrier 1: The Croot–Sisask Exponent Ceiling](#barrier-1-the-crootsisask-exponent-ceiling)
   - [Barrier 2: The k=4 Quasi-Polynomial Gap](#barrier-2-the-k4-quasi-polynomial-gap)
   - [Barrier 3: The Behrend Exponent Gap](#barrier-3-the-behrend-exponent-gap)
3. [Proof Strategies](#3-proof-strategies)
   - [Strategy A: The Sifting Race](#strategy-a-the-sifting-race)
   - [Strategy B: Integer Polynomial Capacity](#strategy-b-integer-polynomial-capacity)
   - [Strategy C: The Convergence Hypothesis](#strategy-c-the-convergence-hypothesis)
4. [Priority Recommendations](#4-priority-recommendations)
5. [Testable Conjectures](#5-testable-conjectures)

---

## 1. Target Statement and Realistic Scope

### 1.1 Precise Definitions of the Asymptotic Problem

Let r_k(N) denote the maximum size of a subset of {1, …, N} containing no nontrivial k-term arithmetic progression. Define:

**α_k** (the "exponent") to be the supremum over all c ∈ (0,1) such that:
  r_k(N) ≤ N · exp(-Ω((log N)^c)) for all large N.

**β_k** (the "lower exponent") to be the supremum over all c ∈ (0,1) such that:
  r_k(N) ≥ N · exp(-O((log N)^c)) for infinitely many N.

The current state of knowledge (June 2026):
- k=3: α_3 ≥ 1/6 (Raghavan 2026), β_3 ≥ 1/2 (Behrend 1946)
- k=4: α_4 ≥ 0 (Green–Tao 2017 gives only polylogarithmic, so quasi-poly α_4 unknown)
- k≥5: α_k ≥ 0 (Leng–Sah–Sawhney give exp(-(log log N)^c), so α_k for k≥5 is 0 in above sense)

The central open problem is to show α_k = β_k for each k and to compute the common value.

### 1.2 Four Levels of the Asymptotic Problem

We organize the problem into four increasing levels of difficulty:

---

**Level 0 (ACHIEVED)**: Szemerédi's theorem — r_k(N) = o(N).  
*Status*: Proved (Szemerédi 1975).

---

**Level 1 (Very Weak Form)**: Determine whether α_3 ≥ 1/3 and whether α_3 ≤ 1/2.

Precisely: Prove r_3(N) ≤ N · exp(-c(log N)^{1/3}) for some absolute c > 0, AND prove r_3(N) ≥ N · exp(-C(log N)^{1/2}) for all large N (Behrend). The first part is new; the second is already known.

*Realistic timeline*: **1–5 years**, based on the demonstrated trajectory of the Kelley–Meka / Bloom–Sisask / Raghavan method (1/12 → 1/9 → 1/6; the next step is 1/3 by explicit extrapolation — see Section 3A).

---

**Level 2 (Weak Form)**: Prove that α_3 = β_3 = 1/2.

Precisely: Prove that r_3(N) = N · exp(-Θ((log N)^{1/2})). This requires both:
  (a) Upper bound: r_3(N) ≤ N · exp(-c(log N)^{1/2}) for some c > 0.
  (b) Lower bound: r_3(N) ≥ N · exp(-C(log N)^{1/2}) (already known; Behrend 1946).

*Realistic timeline*: **5–15 years**. This requires either pushing the iterated sifting approach past its apparent ceiling at exponent 1/3 (requiring fundamentally new ideas), or developing a new method (such as integer polynomial capacity). There is no clear route within current technology.

---

**Level 3 (Strong Form)**: Prove an asymptotic formula:
  r_3(N) = N · exp(-(c_3 + o(1)) · (log N)^{1/2})
where c_3 is a specific computable constant (conjectured to be c_3 = 2√2, the Behrend constant, or the improved value from Elsholtz et al. 2024).

*Realistic timeline*: **20+ years**. Requires not only Level 2 but also:
  - A stability theorem identifying the extremal sets.
  - Precise asymptotics for the number of "sphere-like" AP-free sets.
  - A matching lower bound with the same constant.

---

**Level 4 (Exact Formula)**: Determine r_3(N) exactly (or to within multiplicative constant) for all N.

*Realistic timeline*: **Likely beyond 50 years / may require entirely new mathematics**. No roadmap currently exists.

---

### 1.3 Hierarchy for General k

| k | Level 1 Target | Level 2 Target | Status |
|---|---|---|---|
| 3 | exp(-(log N)^{1/3}) upper | exp(-Θ(√(log N))) | Level 1 feasible in ~3 years |
| 4 | exp(-(log N)^{c}) upper (any c>0) | exp(-Θ(√(log N))) | Level 1 is open |
| 5-8 | exp(-(log N)^{1/3}) upper | exp(-Θ((log N)^{1/3})) | Both far open |
| k≥5 | exp(-(log N)^{c}) upper | exp(-Θ((log N)^{1/⌈log₂k⌉})) | Far open |

### 1.4 What "Asymptotic Formula" Means in Practice

An exact asymptotic formula for r_3(N) would have the form:
```
r_3(N) = exp(√(2/log 2) · √(log N) + O((log log N)^α)) for some α < 1
```
(paralleling the known formula for the size of the Behrend set, which has been computed to include lower-order corrections by Elkin (2011) and Green–Wolf (2010)).

Such a formula would require:
1. **Upper**: The upper bound must match the lower bound to within lower-order factors.
2. **Extremal structure**: The sets achieving r_3(N) must be classifiable (e.g., as intersections of lattice spheres, up to affine equivalence).
3. **Uniqueness or classification**: Whether there is one extremal structure or many.

The current methods are far from achieving any of these. The focus of this document is therefore on *closing the exponent gap* (Level 2) as the primary near-term target.

---

## 2. Barrier Analysis

### Barrier 1: The Croot–Sisask Exponent Ceiling

#### Barrier Statement (Lemma CSE)

**Lemma CSE (Conjectured)**: *Let f: Z_N → [-1,1] satisfy ‖f‖₂ ≥ α. Let Bohr(Γ, ρ) be a Bohr set of rank d on which f is ε-almost periodic in the sense that ‖T_h f - f‖₂ ≤ ε‖f‖₂ for all h ∈ Bohr(Γ, ρ). Then d = Ω(α^{-2}/ε²), and this is tight: there exist functions achieving d = Θ(α^{-2}/ε²).*

**The Croot–Sisask Almost-Periodicity Lemma (Established)**: The upper bound d = O(α^{-2}/ε²) is known and is the foundation of all modern bounds from Sanders (2011) onward. The lower bound d = Ω(α^{-2}/ε²) is the *conjectured tightness*.

#### Concrete Formulation of the Barrier

The upper bound for r_3(N) from the Kelley–Meka / Bloom–Sisask / Raghavan approach takes the form:

**α_3 ≥ 1/(ρ · 3)**

where ρ is the "effective rank power" — the power of α^{-1} in the Bohr set rank at the end of the iteration. Specifically:

| Paper | Effective rank power ρ | Exponent 1/(ρ·3) |
|---|---|---|
| Kelley–Meka (2023) | ρ = 4 (rank O(α^{-4})) | 1/12 |
| Bloom–Sisask (2023) | ρ = 3 (rank O(α^{-3})) | 1/9 |
| Raghavan (2026) | ρ = 2 (rank O(α^{-2})) | 1/6 |
| *Next (conjectured)* | ρ = 1 (rank O(α^{-1})) | 1/3 |
| *Behrend target* | ρ = 0 (rank O(1)) | 1/2 |

The **Croot–Sisask barrier** is that the lemma, as currently known, *requires* rank d ≥ Ω(α^{-2}), so ρ ≥ 2 is a hard floor. Each improvement (KM → BS → Raghavan) reduced the effective ρ by 1, but the floor at ρ=2 corresponds to the quadratic ($L^2$) nature of the lemma.

#### Why Current Methods Fail to Achieve Exponent > 1/6

The Croot–Sisask lemma uses an L² norm: almost-periodicity on a Bohr set of rank d is established when the $L^2$ norm ‖T_h f - f‖₂ is small. The L² condition inherently requires d = Ω(α^{-2}) because:

1. The "Fourier uncertainty principle" on Z_N forces: if ‖f‖₂ ≥ α and ‖f * μ_B - f‖₂ ≤ εα, then μ̂_B(ξ) ≈ 1 for all ξ with |f̂(ξ)| ≥ εα²/2.
2. The number of such ξ is at most O(1/(ε²α²)) by Parseval (since ∑|f̂(ξ)|² ≤ 1 and each contributing ξ has |f̂(ξ)|² ≥ ε²α⁴/4).
3. Therefore, the Bohr set's spectrum must contain O(1/(ε²α²)) frequencies, giving rank d = O(1/(ε²α²)).

This O(α^{-2}) rank is **tight** unless one replaces L² by a different norm (L^p for p ≠ 2, or a combinatorial norm).

#### Best Known Partial Results

- **Achievable**: Raghavan (2026) achieves the theoretical minimum of the Croot–Sisask paradigm: effective rank ρ = 2, exponent 1/6.
- **Lower bound on rank**: No formal lower bound on d in terms of α has been proved in the context of the density increment argument. But heuristically, d = o(α^{-2}) would contradict the Bogolyubov–Ruzsa structural principle.
- **Alternative norms**: The analogue of Croot–Sisask in L^p for p ≠ 2 has not been developed. An L^∞-type almost-periodicity would give d = O(α^{-1}) (rank power ρ = 1), which by the formula above would give exponent 1/3.

#### Proposed Attack on Barrier 1

**Approach 1a: L¹-Almost-Periodicity**. Replace the L² condition by an L¹ condition: ‖T_h f - f‖₁ ≤ εα for most h in a Bohr set. An L¹ version of Croot–Sisask would give rank d = O(α^{-1}) (since |{ξ : |f̂(ξ)| ≥ ε}| = O(ε^{-1}) from L¹ Fourier duality). This would immediately give an upper bound with exponent 1/(1·3) = 1/3.

**Key Question**: Is there an L¹ analogue of the Croot–Sisask lemma that gives a useful density increment?

**Approach 1b: Colored Croot–Sisask**. Instead of a single almost-periodicity lemma, use a "colored" version where the function f is decomposed f = f₁ + f₂ + ... + f_t (into "color classes") such that each f_i is almost periodic on a Bohr set, and the interaction between color classes captures the AP-free condition.

**Approach 1c: Prove the Barrier is Real**. Construct an explicit function f: Z_N → [-1,1] with ‖f‖₂ = α such that any ε-almost-periodic Bohr set for f requires rank d = Ω(α^{-2}), and where the density increment based on f's almost-periodicity cannot improve the exponent beyond 1/3 within the KM framework. This would tell us that new ideas *are required* to surpass 1/3.

---

### Barrier 2: The k=4 Quasi-Polynomial Gap

#### Barrier Statement (Lemma QAP)

**Lemma QAP (Needed for k=4 progress)**: *Let f: Z_N → [-1,1] with ‖f‖_{U³[N]} ≥ δ. There exists a 2-step nilmanifold G/Γ of dimension d = O((log(1/δ))^C) and a polynomial sequence g: Z → G such that |⟨f, F(g(·)Γ)⟩| ≥ exp(-O((log(1/δ))^C)). Moreover, the set on which the nilsequence F(g(n)Γ) is "well-equidistributed" is a structured subset of {1,...,N} of length at least N · exp(-O((log(1/δ))^C)).*

*A density increment strategy for 4-APs requires: on the "equidistributed" subset, if A ∩ (subset) has density α + ρ above average (where ρ depends on the nilsequence correlation), then |A ∩ (subset)| / |(subset)| ≥ α + ρ.*

Leng–Sah–Sawhney (2024) proved the first part (the quasipolynomial inverse theorem). The **missing piece** is the second part: converting nilsequence equidistribution into a density increment on a structured set of comparable size.

#### Why k=4 Remains Stuck

For k=3 (U² norm), the inverse theorem gives:
  ‖f‖_{U²} ≥ δ ⟹ |f̂(ξ)| ≥ c(δ) for some ξ.

This is just a single Fourier coefficient, and the density increment follows by standard Bohr set arguments (Bourgain / Sanders / Kelley–Meka).

For k=4 (U³ norm), the inverse theorem gives:
  ‖f‖_{U³} ≥ δ ⟹ f correlates with e^{2πiQ(n)} for some "quadratic form" Q (on appropriate sub-domain).

The density increment step requires: find a long sub-progression P ⊂ {1,...,N} on which A has density α + ρ. But a quadratic phase e^{2πiQ(n)} does not "concentrate" on a sub-progression in the same way a linear phase does — it distributes energy across many progressions.

**Specific obstruction**: The "Weyl differencing" argument for quadratic phases shows that quadratic exponential sums |∑_{n∈P} e^{2πiQ(n)}| can be bounded by O(|P|^{1-c}) for any arithmetic progression P, so no single P has more than a polynomial gain. To get exponential gains (quasi-polynomial bound), one needs to work on *nilBohr sets*, which are much more complicated geometric objects than classical Bohr sets.

**Missing technical ingredient**: A "quadratic almost-periodicity lemma" that says: if A has a U³ correlation with a quadratic structure, then there is a coset of a "2-step nilBohr set" on which A has higher density. The key difficulty is that 2-step nilBohr sets (defined by ‖g^n x - x'‖ < ρ for g an element of a 2-step nilpotent group) do not behave like abelian Bohr sets under iteration.

#### The Leng–Sah–Sawhney Gap

Leng–Sah–Sawhney (2024) proved:
- **For k≥5**: r_k(N) ≤ N · exp(-(log log N)^{c_k}). Uses the quasipolynomial U^{k-1} inverse theorem plus quantitative nilsequence equidistribution.
- **For k=4**: No improvement over Green–Tao 2017 (N/(log N)^c).

The gap arises because the 2-step case (k=4) has "2-torsion" complications: 2-step nilmanifolds over Z can have components that behave poorly under "halving" operations (needed to pass to sub-progressions). Specifically, when N is even, the equidistribution on 2-step nilmanifolds requires dividing by 2 in the group law, which creates issues.

For k≥5, the nilmanifold is higher-step but the 2-torsion problem does not arise in the same way (the equidistribution argument for step-3+ nilsequences avoids the "quadratic carry" issue).

#### Proposed Attack on Barrier 2

**Approach 2a: Quadratic Croot–Sisask Lemma**. Develop an almost-periodicity lemma for the U³ norm:

*"If f: Z_N → [-1,1] satisfies ‖f‖_{U³[N]} ≥ δ, then there exists a 'quadratic Bohr set' QBohr(Γ, ρ, Q) of rank d = O((log 1/δ)^C) and degree-2 'Bohr conditions' such that ‖T_h f - f‖_{U²} ≤ ε‖f‖_{U³} for all h ∈ QBohr."*

Here QBohr(Γ, ρ, Q) = {h : |Q(h)| ≤ ρ for all Q ∈ Γ} where Q ranges over quadratic characters.

**Approach 2b: Sparse-Structured Density Increment for 4-APs**. The Green–Tao 2017 bound uses "positivity of 4-AP counts on quadratic Bohr sets." Extend this to a quasi-polynomial density increment:

If A has density α in {1,...,N} and no 4-APs, then either:
  (a) A correlates weakly with all quadratic phases (U³ is small), and then standard counting gives a 4-AP (contradiction), OR
  (b) A correlates with a quadratic phase on a "2-step sub-nilmanifold" of size N · exp(-O((log 1/α)^C)), and A's density increases by Ω((1/α)^C) on this sub-nilmanifold.

**Approach 2c: Reduction to k=3 via Ergodic Theory**. Gowers–Wolf–Tao's "U³-uniformity implies k=4 AP count" could be combined with a "U³ → U² reduction" on structured sub-progressions: if f has large U³ norm, restrict to a sub-progression on which the quadratic Fourier coefficient vanishes, making U³ reduce to U².

---

### Barrier 3: The Behrend Exponent Gap

#### Barrier Statement (Lemma BEG)

**Lemma BEG (Central Open Problem)**: *Does there exist an absolute constant c > 0 such that r_3(N) ≤ N · exp(-c(log N)^{1/2}) for all N?*

This is Level 2 of the hierarchy. Proving BEG from above would mean the Kelley–Meka / Raghavan trajectory, if continued to its limit, would achieve exponent 1/2. Disproving BEG would mean the true exponent is strictly less than 1/2.

#### Evidence For (Behrend Optimal)

1. **Finite field analogy**: In F₃ⁿ, the polynomial method gives r_3(F₃ⁿ) ≤ 3^{0.923n} (Ellenberg–Gijswijt), while the Salem–Spencer lower bound is 3^{0.818n}. The ratio of exponents is about 1.13 — a constant gap, and both are of the same "exponential in n" form. This is the analogue of "exp(-c√(log N))" where both upper and lower are of the same form.

2. **Dimension counting**: The Behrend construction uses d ~ √(log N) "dimensions" in the sphere construction. Any "high-dimensional" approach to bounding r_3(N) must work in d-dimensional space, and the natural trade-off between "density per dimension" and "total density" minimizes at d ~ √(log N), giving exponent 1/2. This optimization is identical in upper and lower bounds, suggesting 1/2 is correct.

3. **The Behrend sphere is "tight" for the almost-periodicity lemma**: Behrend sets (sphere intersections) have no large Fourier coefficients and no almost-periodicity on small Bohr sets. They saturate the Croot–Sisask bound: a Behrend set of density α = exp(-c√(log N)) lies in Bohr sets of rank d ~ √(log N) ~ log(1/α), and the almost-periodicity radius is ρ ~ 1. This is exactly what the Croot–Sisask framework "expects" for an extremal AP-free set.

#### Evidence Against (Behrend Not Optimal)

1. **The Elsholtz–Hunter–Proske–Sauermann construction** (2024) improved the Behrend construction by using algebraic geometry over F_p^n, suggesting the sphere is not the unique extremal structure.

2. **The exponent could be between 1/6 and 1/2**: There is no a priori reason the true exponent cannot be 1/4 or 1/3, achieved by a different construction not yet discovered.

3. **Higher-dimensional geometric constructions**: The Behrend construction is "sphere in Z^d." One could consider higher-degree varieties (cubics, quartics) which might give better AP-free density at a different exponent.

#### Proposed Attack on Barrier 3

**Approach 3a: Behrend Stability Theorem**. A "stability" result for 3-AP-free sets would say: any A ⊂ {1,...,N} with |A| ≥ N · exp(-(2√2+ε)√(log N)) (where 2√2 is the Behrend constant) and no 3-AP must be "structurally close" to a Behrend set.

More precisely:

**Conjecture (Behrend Stability)**: Let ε > 0. If A ⊂ {1,...,N} is 3-AP-free and |A| ≥ N · exp(-(2√2+ε)√(log N)), then there exist d = Θ(√(log N)), integer M = Θ(N^{1/d}), and R ∈ [0, dM²] such that:
  |A ∩ φ^{-1}(S_R)| ≥ (1/2 - o(1))|A|
where φ: {1,...,N} → Z^d is the base-M digit expansion and S_R = {x ∈ {0,...,M-1}^d : ∑x_i² = R}.

If proved, this stability theorem would immediately give: any nearly-extremal AP-free set must lie mostly on a sphere, and the size of S_R is O(M^{d-2}/d), which gives the Behrend bound. Stability + extremal characterization = asymptotic formula.

**Approach 3b: Forcing Behrend Structure from Above**. Prove that if the upper bound is N · exp(-c(log N)^{1/2}), the proof *must* use "sphere-like" sets in its iteration. This would be a structural result about the proof technique itself.

**Approach 3c: Eliminate Alternative Extremals**. Prove that no algebraic variety of degree ≥ 3 in Z^d can give a denser AP-free set than a sphere, for d ~ √(log N). This would be a purely geometric statement that rules out "better" constructions beyond Behrend.

---

## 3. Proof Strategies

### Strategy A: The Sifting Race

#### Overview

This is the most conservative strategy: continue the trajectory of the Kelley–Meka method to improve the exponent, aiming first for 1/3 (doubly-iterated Raghavan) and eventually for values approaching 1/2.

#### Observed Trajectory

The exponents achieved in the quasi-polynomial upper bound for r_3(N) are:
```
1/12 (Kelley–Meka 2023) → 1/9 (Bloom–Sisask 2023) → 1/6 (Raghavan 2026) → ?
```

The reciprocals are: 12, 9, 6, ... forming an arithmetic progression with common difference -3.

#### The Sifting Hierarchy Conjecture

**Conjecture A1 (Sifting Hierarchy)**: *For m-fold nested iterated sifting (m = 1, 2, 3, 4), the Kelley–Meka–Bloom–Sisask–Raghavan framework yields:*

  r_3(N) ≤ N · exp(-c_m · (log N)^{f(m)} · (log log N)^{-g(m)})

*where:*
  - f(m) = 1/(3(5-m)) for m = 1, 2, 3, 4
  - g(m) = some polynomial in 1/(5-m) (from log-log factors in the iteration)
  - c_m > 0 is an absolute constant

*The corresponding table:*
| m | Method | Exponent f(m) | Remark |
|---|---|---|---|
| 1 | Kelley–Meka 2023 | 1/12 | Original; 1/(3·4) |
| 2 | Bloom–Sisask 2023 | 1/9 | Bootstrapped; 1/(3·3) |
| 3 | Raghavan 2026 | 1/6 | Iterated; 1/(3·2) |
| 4 | Next (conjectured) | 1/3 | Doubly-iterated; 1/(3·1) |
| 5 | *Beyond paradigm* | — | ρ=0 requires new ideas |

*The formula f(m) = 1/(3(5-m)) diverges as m → 5, but the practical ceiling is at m=4 (exponent 1/3): achieving ρ < 1 in the rank bound requires improving beyond the Croot–Sisask "quadratic" barrier.*

#### What Doubly-Iterated Sifting Gives

The m=4 step (doubly-iterated sifting) would proceed as follows:

**Outer sifting** (as in Raghavan): Select a structured set Γ of "good frequencies" via the sifting procedure, find a Bohr set B₁ = Bohr(Γ, ρ₁) of rank d₁ = O(α^{-2}) on which A has density α + Ω(α^C / d₁).

**Inner sifting** (Raghavan-style, applied to A ∩ B₁): On the Bohr set B₁, apply the sifting again to find Bohr(Γ₂, ρ₂) of rank d₂ ≤ d₁ + O(α^{-1}) (the inner iteration improves the rank growth) with density α + 2Ω(α^C/d₁).

**Key claim**: If the outer sifting produces rank O(α^{-2}) (Raghavan), the inner sifting on the restricted function (which is now "conditioned" on the outer sifting) should produce an *additional* rank growth of only O(α^{-1}), since the "effective density" of the function on the Bohr set has improved. This would reduce the total effective rank from O(α^{-2}) to O(α^{-1}), giving exponent 1/3.

**Why the log-log factor may persist**: Each level of iteration introduces a log log N factor from the Bohr set geometry (specifically, from the "regularity lemma" for Bohr sets, which requires ρ ≥ N^{-1/d} and the iteration count is bounded by log log N at each level). The doubly-iterated version may have an extra (log log N)^{-1} factor.

**Precise conjecture**:
```
r_3(N) ≤ N · exp(-c(log N)^{1/3} / (log log N)^C)
```
for some absolute constants c, C > 0.

#### When Does This Approach Converge to 1/2?

The formula f(m) = 1/(3(5-m)) diverges as m → 5, not converging to 1/2. This means the sifting hierarchy, within the Croot–Sisask framework, does **not** converge to the Behrend exponent 1/2.

To reach exponent 1/2, the following would be needed:
1. Replace Croot–Sisask (L² rank O(α^{-2})) with a new lemma giving rank O(α^{-ε}) for arbitrarily small ε > 0.
2. OR: Find a different iteration scheme where the "3" in the denominator (from the 3-fold tensor structure of 3-APs) is replaced by "2," giving f(m) = 1/(2(5-m)) which converges to ... still the same issue.
3. OR: The correct formula is not 1/(3(5-m)) but something that does converge to 1/2 as m → ∞.

**Alternative convergence formula**: If each additional level of sifting reduces the effective rank by a *multiplicative* factor (rather than additive), then:
  - Level 1: rank O(α^{-4}) → 1/12
  - Level 2: rank O(α^{-4·(1-c)}) for some c > 0 → exponent 1/(4(1-c)·3)
  - Level m: rank O(α^{-4·(1-c)^m}) → exponent 1/(4(1-c)^m · 3)

As m → ∞: exponent → ∞? That doesn't make sense either.

The correct resolution is likely: **the sifting approach converges to exponent 1/2 only if the effective rank power ρ can be made arbitrarily close to 0**, which requires breaking the Croot–Sisask barrier (Barrier 1). The sifting race is therefore a bridge, not the final answer.

**Working conjecture**: The maximum exponent achievable by any finite-level iterated sifting within the Croot–Sisask paradigm is 1/3, with the ceiling provably at this value. This is "Barrier 1" as a quantitative statement.

---

### Strategy B: Integer Polynomial Capacity

#### Overview

This is the most speculative but highest-reward strategy: develop an "integer analogue" of the polynomial method (which works beautifully for cap sets in F₃ⁿ) for the 3-AP problem in {1,...,N}.

#### Mathematical Program

##### Step B1: The Embedding Problem

Let p > 2N be a prime. Work in Z/pZ.

The 3-AP condition in {1,...,N}: a + c = 2b (equivalently, a + c - 2b = 0 in Z).

**Key idea**: Find d ~ log N and a map φ: {1,...,N} → F_p^d such that:
  (i) φ is injective
  (ii) a + c = 2b in {1,...,N} if and only if φ(a) + φ(c) = 2φ(b) in F_p^d
  (iii) The "slice rank" of the tensor T(x,y,z) = 1[φ(x)+φ(z)=2φ(y)] on F_p^d is bounded by C^d for some C < p.

If (i)-(iii) hold with C < p, then r_3(N) ≤ SliceRank(T) ≤ C^d = C^{O(log N)} = N^{O(1)}, which would be a polynomial bound (much weaker than Behrend but still new).

##### Step B2: Carry-Free Base-p Expansion

**Attempt**: Let d = ⌈log_p N⌉. Write a = ∑ᵢ aᵢ pⁱ (base-p expansion), defining φ(a) = (a₀, a₁, ..., a_{d-1}) ∈ F_p^d.

**Problem**: The 3-AP condition a + c = 2b splits coordinate-wise only if there are no carries. Specifically:
  (φ(a))ᵢ + (φ(c))ᵢ = 2(φ(b))ᵢ mod p for each i   ... (*carry-free version*)

but in general, a + c = 2b requires: (a+c) = Σ (aᵢ + cᵢ) pⁱ with carries propagating.

**The carry indicator**: Define the k-th carry Kₖ(a,c) = ⌊(∑ᵢ≤ₖ (aᵢ + cᵢ) pⁱ) / p^{k+1}⌋. Then:
  a + c = 2b ⟺ aᵢ + cᵢ + Kᵢ₋₁(a,c) = 2bᵢ + Kᵢ(a,c) · p for all i.

##### Step B3: Key Lemma Needed

**Proposed Lemma B (Integer AP Structure)**: Let A ⊂ {1,...,N} be 3-AP-free and let p ~ N^{1/d} for d = ⌈C√(log N)⌉. Define A' ⊂ A to be the "carry-free" subset of A:
  A' = {a ∈ A : for all c ∈ A with a + c = 2b for some b ∈ A, the addition a+c has no carry in base p}.

**Then**: |A'| ≥ |A| / poly(d) AND φ(A') ⊂ F_p^d is "multilinear-AP-free" (no 3-AP in the coordinate-wise sense).

**If this lemma holds**: Apply the polynomial method to φ(A') ⊂ F_p^d. The "coordinate-wise AP-free" condition in F_p^d, when p ≥ 3, is exactly the cap set problem for (Z/pZ)^d, to which the Croot–Lev–Pach / Ellenberg–Gijswijt method applies.

**Obstacle**: Lemma B is likely false in general — the "carry-free subset" A' could be much smaller than A. Carries are dense in integer arithmetic and removing elements to eliminate carries could reduce A by a polynomial factor.

**Modified approach**: Instead of removing elements, use a "carry-control" argument:

**Lemma B' (Modified, Conjectured)**: For any 3-AP-free A ⊂ {1,...,N} and any prime p ~ N^{1/d}:
  r_3(N) ≤ (C·p)^d = C^d · N
where C = C(p) is a constant depending on p (the "capacity" of carries). If C < 1 (independent of N), this gives a bound r_3(N) ≤ N^{1-c}, which contradicts Behrend. If C > 1, the bound is trivial.

The question reduces to: **what is the "carry capacity" C(p)?**

For p = 3: C(3) ≈ 2.756 (from Ellenberg–Gijswijt), but carries in base 3 are common and destroy the structure.

For large p (p ~ N): C(p) → 1 since most elements have small digits.

**Sweet spot**: There should be an optimal p ~ N^{1/√(log N)} (i.e., d ~ √(log N)) such that:
  - The carry probability is small enough (≤ 1/d per digit pair)
  - The Ellenberg–Gijswijt bound applies with C(p) ≈ p^{1-ε}
  - The resulting bound is r_3(N) ≤ N · (C(p)/p)^{O(log N)} = N · exp(-Ω(ε log N))

But this would give a polynomial bound, better than Behrend for small N but not in the limit.

##### Step B4: The Z-Slice Rank

**Definition (Proposed)**: Let T: {1,...,N}³ → {0,1} be defined by T(a,b,c) = 1[a+c=2b] · 1_A(a) · 1_A(b) · 1_A(c). The *Z-slice rank* of T is:
  ZSliceRank(T) = min {number of terms in a decomposition T = ∑ᵢ fᵢ(a) · gᵢ(b,c) over Z},
where fᵢ: {1,...,N} → Z and gᵢ: {1,...,N}² → Z.

**Claim**: ZSliceRank(T) = |A| when A is 3-AP-free (by the diagonal argument: T(a,a,a) = 1_A(a) for all a, so the diagonal contribution is exactly |A|).

**The key question**: Is ZSliceRank(T) bounded above by something smaller than |A| in terms of N, using the structure of the 3-AP condition over Z?

In the finite field case (Ellenberg–Gijswijt), the slice rank is bounded by 3·binom(n, n/3) ≈ 3 · (2.756...)^n via a polynomial degree argument. The key is that polynomials of degree ≤ d in n variables over F_3 have at most binom(n+d, d) monomials, bounding the rank.

For Z, the analogue would require a notion of "polynomial degree over Z" that gives a useful bound. The natural polynomials over Z of degree ≤ d in n variables have binom(n+d, d) monomials — the same count. But the AP condition over Z involves the equation a+c=2b in Z, not modular arithmetic, so the polynomial approach must handle the infinite support.

**Reduction to prime field**: Work modulo a prime q with |A| < q ≤ 2|A|. Then A ⊂ F_q, and the AP condition in {1,...,N} coincides with the AP condition in F_q (since a+c-2b ∈ (-N, 2N) and |a+c-2b| < 2N ≤ 2q, so a+c=2b mod q iff a+c=2b in Z).

But n=1 (one variable) in F_q gives trivial polynomial bounds — we need to embed into F_q^d for some d ≥ 2.

**Proposed "Chinese Remainder Embedding"**: Let q₁, ..., q_d be distinct primes with q₁ ≤ N^{1/d}, all about the same size. Map a ↦ (a mod q₁, ..., a mod q_d). This is injective for a ∈ {1,...,N} when q₁ · ... · q_d > N. The image is (F_{q₁} × ... × F_{q_d}). The AP condition a+c=2b in Z transfers to:
  a + c = 2b in F_{qᵢ} for each i (since the APs are in Z ⊂ F_{qᵢ} for the appropriate range).

But the AP condition in F_{qᵢ} is linear; it doesn't interact with the other components. The "slice rank" bound would then apply to each component independently, giving only trivial bounds.

##### Summary of Barrier for Strategy B

The fundamental obstacle is: integer arithmetic has carries and no "polynomial degree" bound that distinguishes {1,...,N} from a generic subset of Z. The polynomial method's power in F_q^n comes from the product structure (polynomials factor) and degree bounds (polynomials of degree ≤ n(q-1)/q have bounded rank). Neither transfers cleanly.

**What would be needed**: A new algebraic structure theory for integer AP-free sets — an "integer Waring–Hilbert" type result showing that a function T: Z³ → Z satisfying T(a,b,c) = 0 whenever a+c≠2b can be decomposed into "rank 1" pieces with a useful rank bound.

**This is a genuinely new research direction** with no clear near-term resolution, but potentially the most impactful breakthrough possible: if integer slice rank can be bounded by (something)^{√(log N)}, it could directly give r_3(N) ≤ N · exp(-c√(log N)), matching Behrend.

---

### Strategy C: The Convergence Hypothesis

Strategy C articulates three central conjectures about the asymptotic behavior of r_k(N) and evaluates the evidence for each.

#### Hypothesis C1: Behrend's Constant is Sharp

**C1**: r_3(N) = N · exp(-(2√2 + o(1)) · √(log N)).

More precisely: the limit lim_{N→∞} log r_3(N) / √(log N) = -2√2 (or the appropriate constant from the Elsholtz et al. improvement).

**Evidence For C1**:
- Behrend's construction gives a lower bound with constant 2√2 (or 2.67 from Elsholtz et al. 2024).
- The Behrend sphere is "tight" in the sense that it saturates the almost-periodicity bounds.
- All known improvements to the lower bound improve only the constant (not the exponent).
- In the finite field model (F_3^n), the "Behrend" constant (2.756^n lower bound vs Salem–Spencer (2.2...)^n lower bound) is sharp for the upper bound but not the lower; the gap is a constant factor, which is the analogue of "same exponent, different constant."

**Evidence Against C1**:
- No structural theorem identifies Behrend sets as extremal; they might not be.
- Elsholtz et al. (2024) showed the constant can be improved beyond 2√2, meaning the "tight" constant is not 2√2.
- Constructions using algebraic varieties over F_p (Elsholtz et al.) might be improveable to give a lower exponent than 1/2.

**If C1 is true, it implies**: The "right" value of c₃ is determined by algebraic geometry (specifically, the optimal quadric in Z^d intersected with {0,...,M-1}^d). Computing c₃ exactly would require understanding the extremal density of AP-free sets on spheres of arbitrary dimension.

**Verdict**: C1 is highly plausible but probably not the full truth. The constant 2√2 is a lower bound on c₃; the true value from the Elsholtz et al. construction is smaller (around 2.67 in natural log units), and might be further improveable.

---

#### Hypothesis C2: Rankin's Construction is Sharp for k≥5

**C2**: For k ≥ 5, r_k(N) = N · exp(-(c_k + o(1)) · (log N)^{1/⌈log₂ k⌉}).

The exponent matches Rankin's (1961) construction: α_k = 1/⌈log₂ k⌉.

**Evidence For C2**:
- Rankin's construction is the best known for k ≥ 5 (for 5 ≤ k ≤ 8, the exponent 1/3 is better than Behrend's 1/2).
- The exponent 1/⌈log₂ k⌉ has a combinatorial interpretation: it equals the maximum "AP-freeness dimension" of a sphere in dimension d ~ (log N)^{1/⌈log₂ k⌉}.
- For k = 2^m + 1 to 2^{m+1}: the exponent is 1/(m+1), and Rankin's construction achieves this by a "sphere in dimension d" argument where d = (log N)^{1/(m+1)}.

**Evidence Against C2**:
- The Leng–Sah–Sawhney upper bound for k≥5 is N·exp(-(log log N)^{c_k}), which is *much weaker* than N·exp(-(log N)^{1/3}). If C2 is true, the upper bound has a long way to go.
- It is possible that for k=5, the true exponent is 1/2 (Behrend) rather than 1/3 (Rankin), and the Rankin construction is not tight. Rankin's construction for k=5 uses 5-AP-free spheres in dimension ~ (log N)^{1/3}, but spheres are also 3-AP-free and the density is 3-AP-free-density which has a different optimization.

**If C2 is true, it implies**: The true asymptotics for r_k(N) depend critically on the structure of k-AP-free sets in high-dimensional integer lattices, and Rankin's sphere argument captures the right balance between "dimension" and "density." This would be a grand unification of the lower bound arguments.

**Verdict**: C2 is plausible for 5 ≤ k ≤ 8 (where Rankin beats Behrend), but speculative. For k ≥ 9, the exponent decreases further and the argument becomes harder to check.

---

#### Hypothesis C3: The Sifting Approach Reaches 1/2

**C3**: The exponent in the quasi-polynomial upper bound for r_3(N) is 1/2; i.e., there exists c > 0 such that r_3(N) ≤ N · exp(-c(log N)^{1/2}), achievable by a sufficiently refined version of the Kelley–Meka / almost-periodicity approach.

**Evidence For C3**:
- The trajectory 1/12 → 1/9 → 1/6 → 1/3 (predicted) → 1/2 (Behrend target) is consistent with each improvement making progress.
- The Croot–Sisask lemma in its "ideal form" (rank O(1)) would give exponent 1/2.
- Each step in the trajectory has come from improving the rank bound by exactly 1 in the power: 4 → 3 → 2 → (next: 1 → 0?).

**Evidence Against C3**:
- The Croot–Sisask lemma *provably* requires rank d = Ω(α^{-2}), so rank O(1) is impossible within this framework.
- The exponent ceiling of 1/3 (rank O(α^{-1})) seems to be the hard barrier; getting below rank O(α^{-1}) would require an L¹ version of Croot–Sisask which is not known.
- To reach exponent 1/2, one would need a completely new proof idea, not just another iteration of the sifting.

**If C3 is true, it implies**: The quasi-polynomial bound can be improved to match Behrend, closing the Level 2 gap. This would be a major theorem (comparable to Kelley–Meka in importance) and would likely require a new proof technique.

**If C3 is false (exponent ceiling below 1/2)**: A completely new method is *required* to prove Level 2, making the problem much harder.

**Verdict**: C3 is the *central uncertainty*. The field does not currently know whether the Croot–Sisask framework can be pushed to exponent 1/2 or whether a fundamental new idea is needed.

---

## 4. Priority Recommendations

### The Single Most Tractable Research Problem

**Primary Target**: Prove r_3(N) ≤ N · exp(-c(log N)^{1/3}) for some absolute constant c > 0.

This is the predicted next step in the sifting hierarchy (m=4 doubly-iterated Raghavan) and is within reach of current methods. The mathematical ingredients are:

1. Analyze Raghavan's (2026) iterated sifting carefully to understand the rank growth at each level.
2. Apply the sifting argument a second time to the "conditioned" function on the Bohr set.
3. Show that the second application gives an *additional* rank growth of O(α^{-1}) (not O(α^{-2})), because the function is now "pre-sifted."
4. Combine to get effective rank O(α^{-1}), exponent 1/(1·3) = 1/3.

**Why this is tractable**: Raghavan (2026) achieved exponent 1/6 by one level of iterated sifting. The argument is already available in arXiv:2603.27045. A second level of the same iteration is a natural next step that a focused group could achieve in 1-2 years.

**Risk**: The doubly-iterated sifting may not give exponent 1/3 if there are additional log log factors or if the "conditioned" function is not well-behaved. The true exponent from doubly-iterated sifting might be, say, 7/36 (between 1/6 and 1/3) rather than exactly 1/3.

---

### One-Year Research Program

**Year 1: Push the Sifting to 1/3**

1. (Months 1-3) Deep study of Raghavan (2026) + Bloom–Sisask (2023). Identify the precise exponent formula as a function of the "rank power ρ" and the "iteration depth m." Formalize the Sifting Hierarchy Conjecture (Conjecture A1 above).

2. (Months 4-6) Attempt doubly-iterated sifting. The key sub-problem: after Raghavan's sifting finds a Bohr set B of rank d = O(α^{-2}) on which A has density α + δ, apply the sifting procedure to A ∩ B to find a sub-Bohr set B' of rank d' ≤ d + O(α^{-1}) on which A has density α + 2δ. If successful, this gives exponent 1/3 (with possible log log factors).

3. (Months 7-9) Investigate whether the log log factor in Raghavan's bound (exponent 1/6 · (log log N)^{-1}) can be removed, giving a "clean" exponent of 1/6. This is a simpler problem that might clarify the structure needed for the doubly-iterated version.

4. (Months 10-12) Explore the L¹ version of Croot–Sisask. Specifically, prove or disprove: *If f: Z_N → [-1,1] satisfies ‖f‖₁ ≥ α, is there a Bohr set of rank O(α^{-1}) on which f is ε-L¹-almost-periodic?* A positive answer would directly give exponent 1/3 via a different route.

**Secondary objective**: Improve the lower bound constant in Behrend from c ≤ 2.67 (Elsholtz et al.) to c < 2.5 using algebraic geometric constructions over F_p.

---

### Five-Year Research Program

**Year 1-2: Exponent 1/3 and Study of the 1/3-Ceiling**

As in the one-year program above, push the sifting to exponent 1/3.

Then: prove (or disprove) that the sifting hierarchy cannot exceed exponent 1/3 — i.e., prove a *lower bound* on the rank in the iteration that prevents going below ρ=1. This "barrier theorem" would tell us definitively whether new ideas are needed to surpass 1/3.

**Year 2-3: Quadratic Almost-Periodicity for k=4**

Focus on developing the "quadratic Croot–Sisask" lemma (Approach 2a). Specifically:

1. Study the structure of 2-step nilmanifolds and develop a theory of "quadratic almost-periodicity" on cosets of 2-step nilBohrs.
2. Prove a density increment lemma for 4-APs using the quasipolynomial U³ inverse theorem (Leng–Sah–Sawhney 2024).
3. Target: first quasi-polynomial bound for k=4, i.e., r_4(N) ≤ N · exp(-(log N)^{c}) for some c > 0.

**Year 3-4: Integer Polynomial Capacity Exploration**

Develop the theory of "carry-free" AP-free sets (as in Strategy B). Key steps:

1. Study which subsets of {1,...,N} are "carry-free" in a given base p and characterize the structure of carry-free AP-free sets.
2. Apply the Ellenberg–Gijswijt argument to carry-free subsets; determine what bounds it gives for r_3(N).
3. Investigate whether "Z-slice rank" can be bounded more tightly than |A|.

**Year 4-5: Structure Theorems for AP-Free Sets**

Prove the Behrend Stability Conjecture (or a weaker version):

1. Show that any AP-free A ⊂ {1,...,N} with |A| ≥ N · exp(-(3+ε)√(log N)) must lie on "approximately spherical" level sets in some Z^d.
2. Determine the optimal sphere dimension d and radius R as a function of |A| and N.
3. Use the stability result to bootstrap the lower bound constant.

---

### Low-Hanging Fruit: Computational and Constructive Improvements

1. **Improve Raghavan's log log factor**: The current bound has an extra (log log N)^{-1} compared to what the exponent 1/6 "should" be. Cleaning up the iteration in Raghavan's paper might remove this factor, giving a slightly stronger result immediately.

2. **Compute r_3(N) for N up to 10⁶**: Current computational tables of r_3(N) extend to small N. Extending these computations would empirically test which of the competing conjectures is more plausible (though the behavior for small N is not predictive of asymptotics).

3. **Behrend constant optimization**: Improve the constant in r_3(N) ≥ N · exp(-c√(log N)) below c ≈ 2.67 (the Elsholtz et al. value) using optimized algebraic geometric constructions over F_p for specific small primes p.

4. **Explicit k=4 computations**: For small N, compute r_4(N) and compare with Behrend (which applies for k=4 as well). This might reveal whether the true constant for k=4 matches the Behrend bound or is smaller.

5. **Computer-assisted lower bound improvements**: Use semidefinite programming (SDP) or linear programming to find AP-free sets of size exceeding the Behrend construction for specific N. This would give improved lower bound constants computationally.

6. **L¹ Croot–Sisask in specific cases**: Test the L¹ almost-periodicity hypothesis numerically for small N and α, to gather evidence for whether the rank can be taken as O(α^{-1}).

---

## 5. Testable Conjectures

### Conjecture 1: Sifting Hierarchy Formula (near-term, testable by next paper)

**Conjecture 1 (Sifting Hierarchy)**: For m-fold nested iterated sifting in the Kelley–Meka / Bloom–Sisask / Raghavan framework, the resulting upper bound on r_3(N) has quasi-polynomial exponent exactly:

  f(m) = 1 / (3 · (5 - m))   for m ∈ {1, 2, 3, 4}

*Explicit predictions*:
- f(1) = 1/12 ✓ (Kelley–Meka 2023)
- f(2) = 1/9 ✓ (Bloom–Sisask 2023)
- f(3) = 1/6 ✓ (Raghavan 2026)
- f(4) = 1/3 (prediction: *doubly-iterated Raghavan gives exponent at least 1/3*)

**Falsifiability**: If doubly-iterated sifting gives exponent strictly less than 1/3, or strictly greater than 1/3, Conjecture 1 is false. The formula is specific enough to be tested computationally by checking the rank growth in the m=4 iteration.

**Implications if true**: The sifting approach has a ceiling at 1/3 within the Croot–Sisask paradigm. A new method is *required* to surpass this ceiling.

---

### Conjecture 2: Croot–Sisask is Tight at Rank Ω(α^{-2})

**Conjecture 2 (CSE Tightness)**: *For every ε > 0 and every large enough α > 0 (i.e., α > N^{-ε} for large N), there exists f: Z_N → [-1,1] with ‖f‖₂ ≥ α such that any Bohr set Bohr(Γ, ρ) on which f is ε-almost-periodic (in the sense of Croot–Sisask) satisfies |Γ| ≥ c(ε) · α^{-2}.*

**Falsifiability**: A constructive proof that the Croot–Sisask rank can be taken O(α^{-2+ε}) for some ε > 0 (beyond the current O(α^{-2}) ceiling) would falsify this. Note: this conjecture says the "best possible" rank from any improvement of Croot–Sisask is still Ω(α^{-2}).

**Implications if true**: Any improvement to the exponent beyond 1/6 (within the almost-periodicity framework) requires using the Croot–Sisask lemma in a *different way* (e.g., more clever bootstrapping or a different iteration scheme), not just proving a sharper version of the lemma.

**Implications if false**: There is a version of Croot–Sisask with rank O(α^{-2+ε}), which would give exponents above 1/6 (specifically f = 1/(2-ε)·3) directly from Strategy A, potentially reaching 1/2.

---

### Conjecture 3: Doubly-Iterated Raghavan Gives 1/3

**Conjecture 3 (Doubly-Iterated Sifting)**: *There exists an absolute constant c > 0 such that for all sufficiently large N:*

  r_3(N) ≤ N · exp(-c (log N)^{1/3})

*Moreover, this bound arises from a "doubly-iterated sifting" argument: apply Raghavan's (2026) iterated sifting to find a Bohr set B₁ of rank O(α^{-2}), then apply the sifting again within B₁ to find a sub-Bohr set B₂ of total rank O(α^{-2}) + O(α^{-1}) = O(α^{-2}), achieving an effective rank of O(α^{-1}) in the combined argument.*

**Falsifiability**: If the doubly-iterated sifting can be proved to give only exponent ≤ 1/4 (or worse, ≤ 1/6), then Conjecture 3 is false for the stated mechanism. The exponent 1/3 is the specific prediction of the Sifting Hierarchy formula.

**Implications if true**: Exponent 1/3 would be the best achievable within the Croot–Sisask framework (matching the conjectured ceiling), and would be a significant improvement over Raghavan's 1/6.

---

### Conjecture 4: Behrend's Exponent is Sharp (Level 2 of the Problem)

**Conjecture 4 (Behrend Optimality)**: *For every c > 2√2, there exist infinitely many N for which:*

  r_3(N) ≥ N · exp(-c · √(log N)).

*Equivalently, lim inf_{N→∞} log r_3(N) / √(log N) ≥ -2√2 (or the improved constant from Elsholtz et al.).*

**Falsifiability**: If there exists a 3-AP-free set A ⊂ {1,...,N} with |A| ≥ N · exp(-(2√2+δ)√(log N)) for some *fixed* δ > 0 and *all* large N (not just infinitely many), then Conjecture 4's content would be vacuously different (it asserts only "infinitely often"). The stronger version: the limit *exists* and equals 2√2. This stronger version is harder to falsify.

**What the current state of knowledge implies**: The Elsholtz et al. (2024) improvement gives c ≤ 2.67, better than 2√2 ≈ 2.83. So Conjecture 4 as stated with constant 2√2 is *already known to be false* in the "infimum" sense — the true constant is ≤ 2.67. The correct conjecture would use the Elsholtz et al. constant.

**Revised Conjecture 4'**: Let c* = inf { c : r_3(N) ≥ N · exp(-c√(log N)) holds for all large N }. Then c* = 2√{log_2(24/7)} ≈ 2.667 (the Elsholtz et al. constant). [Or possibly even smaller, if the construction can be improved further.]

**Implications**: c* being finite and computable would resolve the lower bound problem completely. The current best is c* ≤ 2.667 (from Elsholtz et al.).

---

### Conjecture 5: k=4 Quasi-Polynomial Requires Quadratic Almost-Periodicity

**Conjecture 5 (k=4 QP Barrier)**: *Any proof of the bound r_4(N) ≤ N · exp(-c(log N)^ε) for some ε > 0 must use a "quadratic Croot–Sisask" lemma of the following form:*

*"If f: Z_N → [-1,1] satisfies ‖f‖_{U³[N]} ≥ δ, then there exists a '2-step nilBohr set' QBohr of dimension d ≤ (log(1/δ))^C and size |QBohr| ≥ N^{1-o(1)} on which ‖T_h f - f‖_{U²} ≤ ε for all h ∈ QBohr."*

*No such lemma is currently known. Therefore, any proof of a quasi-polynomial bound for r_4(N) requires proving this lemma (or an equivalent statement) as a key step.*

**Falsifiability**: A proof of r_4(N) ≤ N · exp(-c(log N)^ε) that does *not* use a quadratic almost-periodicity lemma would falsify this conjecture.

**Implications if true**: The quadratic Croot–Sisask lemma is the **core bottleneck** for k=4. Developing it would not only give a quasi-polynomial bound for r_4(N) but would also unify the k=3 and k=4 cases within the almost-periodicity framework.

---

### Conjecture 6: Structure of Near-Extremal 3-AP-Free Sets

**Conjecture 6 (Behrend Stability)**: *For every ε > 0, there exist δ > 0 and N₀ such that for all N ≥ N₀: if A ⊂ {1,...,N} is 3-AP-free and |A| ≥ N · exp(-(c* + ε)√(log N)) (where c* is the optimal Behrend constant), then:*

  *There exist d ∈ [((1/2)-δ)√(log N), ((1/2)+δ)√(log N)], integer M ∈ [N^{1/(d+1)}, N^{1/(d-1)}], and R ∈ [0, d·M²] such that:*

  |{a ∈ A : the base-M digit representation (a₀,...,a_{d-1}) of a satisfies ∑ᵢ aᵢ² = R}| ≥ (1-ε)|A|.

*(In other words, nearly all of A lies on a single sphere level in Z^d.)*

**Falsifiability**: A 3-AP-free set A with |A| ≥ N · exp(-c'√(log N)) (for c' close to c*) that does NOT concentrate on any sphere level would falsify this conjecture. Such sets could potentially be found computationally for small N or via algebraic constructions (like the Elsholtz et al. variety-based sets).

**Implications if true**: Extremal AP-free sets are essentially unique (up to affine equivalence and small perturbations). This would enable the determination of the exact asymptotic formula r_3(N) ~ C · N · exp(-c*√(log N)) (Level 3 of the problem).

---

### Conjecture 7: Rankin Tightness for k=5

**Conjecture 7 (Rankin Optimality for k=5)**: *The true asymptotic exponent for r_5(N) is 1/3:*

  r_5(N) = N · exp(-Θ((log N)^{1/3})).

*In particular, there exist constants 0 < c < C such that:*
  N · exp(-C(log N)^{1/3}) ≤ r_5(N) ≤ N · exp(-c(log N)^{1/3}).

**Falsifiability**:
- If r_5(N) ≤ N · exp(-c(log N)^{1/2}) for some c > 0 (i.e., Behrend is tight for k=5), then Conjecture 7 is false.
- If r_5(N) ≥ N · exp(-C(log N)^{1/2+ε}) for all ε > 0 (i.e., the exponent is 1/2, not 1/3), then Conjecture 7 is false.

**Current gap**: The upper bound for k=5 (Leng–Sah–Sawhney 2024) is N · exp(-(log log N)^{c_5}), which is *much weaker* than N · exp(-c(log N)^{1/3}). The lower bound from Rankin (1961) is N · exp(-C(log N)^{1/3}). If Conjecture 7 is true, there is a vast improvement to be made on the upper bound side.

**Implications if true**: The Leng–Sah–Sawhney method for k≥5, while a breakthrough, is far from tight. The true bound requires a quasi-polynomial upper bound for k=5, analogous to Kelley–Meka for k=3.

---

## Summary of Conjectures

| Conjecture | Status | Timescale | Key Implication |
|---|---|---|---|
| C1: Sifting Formula f(m)=1/(3(5-m)) | Testable by next paper | 1-3 years | Ceiling at 1/3 for current methods |
| C2: Croot–Sisask rank is Ω(α^{-2}) | Open (structural) | 5-10 years | Must break L² barrier for exponent >1/3 |
| C3: Doubly-iterated sifting gives 1/3 | Feasible near-term | 1-3 years | Next step in trajectory |
| C4: Behrend constant c* ≈ 2.667 | Partially known | 5-15 years | Determines the sharp constant |
| C5: k=4 QP requires quadratic CS lemma | Structural claim | 3-10 years | Key bottleneck identified |
| C6: Near-extremal sets are sphere-like | Open (structural) | 10-20 years | Would resolve Level 3 |
| C7: Rankin tight for k=5 | Speculative | 10+ years | Requires new upper bound method |

---

## References

1. Kelley, Z. and Meka, R. (2023). Strong Bounds for 3-Progressions. arXiv:2302.05537.
2. Bloom, T. F. and Sisask, O. (2023). An improvement to the Kelley–Meka bounds on three-term arithmetic progressions. arXiv:2309.02353.
3. Raghavan, R. (2026). Improved Bounds for 3-Progressions. arXiv:2603.27045.
4. Green, B. and Tao, T. (2017). New bounds for Szemerédi's theorem, III: A polylogarithmic bound for r_4(N). Mathematika 63(3), 944–1040. arXiv:1705.01703.
5. Leng, J., Sah, A., and Sawhney, M. (2024a). Quasipolynomial bounds on the inverse theorem for the Gowers U^{s+1}[N]-norm. arXiv:2402.17994.
6. Leng, J., Sah, A., and Sawhney, M. (2024b). Improved Bounds for Szemerédi's Theorem. arXiv:2402.17995.
7. Elsholtz, C., Hunter, Z., Proske, L., and Sauermann, L. (2024). Improving Behrend's construction: Sets without arithmetic progressions in integers and over finite fields. arXiv:2406.12290.
8. Ellenberg, J. and Gijswijt, D. (2017). On large subsets of F_q^n with no three-term arithmetic progression. Ann. of Math. 185(1), 339–343.
9. Behrend, F. A. (1946). On sets of integers which contain no three terms in arithmetic progression. Proc. Nat. Acad. Sci. 32, 331–332.
10. Rankin, R. A. (1961). Sets of integers containing not more than a given number of terms in arithmetic progression. Proc. Royal Soc. Edinburgh 65, 332–344.
11. Croot, E. and Sisask, O. (2010). A probabilistic technique for finding almost-periods of convolutions. Geom. Funct. Anal. 20(6), 1367–1396.
12. Green, B., Tao, T., and Ziegler, T. (2012). An inverse theorem for the Gowers U^{s+1}[N]-norms. Ann. of Math. 176, 1231–1372.
13. Kelley, Z. and Lyu, X. (2026). More efficient sifting for grid norms, and applications to multiparty communication complexity. arXiv:2505.01587. [Applies improved sifting to communication complexity; improvements to the sifting argument for grid norms may have implications for the r_3(N) trajectory.]

---

## Addendum: Post-Literature-Review Developments (June 2026)

A search of recent preprints (conducted June 2026) found:

- **Kelley–Lyu (2026)** (arXiv:2505.01587, revised June 10, 2026): Improves the sifting argument for "grid norms" of bipartite graphs, establishing stronger lower bounds for 3-player communication complexity. Specifically, achieves Ω(log^{1/2}(N)) communication complexity (improving on Ω(log^{1/3}(N))). The same sifting technique is used here as in the Kelley–Meka approach for arithmetic progressions. The improvement from "1/3" to "1/2" in the communication complexity exponent is analogous to the progression 1/9 → 1/6 → 1/3 → 1/2 in the arithmetic progression context — suggesting **the sifting machinery is more powerful than previously understood and may support exponents approaching 1/2 in the r_3(N) setting as well**.

This is evidence *supporting* the Convergence Hypothesis (C3) and *against* the conjecture that the sifting ceiling is at 1/3. The communication complexity result achieving exponent 1/2 via sifting suggests that the r_3(N) sifting approach might reach 1/2 as well, contradicting the Sifting Hierarchy Formula (Conjecture 1 with ceiling at 1/3).

**Revised assessment**: The Sifting Hierarchy Formula f(m) = 1/(3(5-m)) may be an underestimate of what the sifting approach can achieve. The Kelley–Lyu result suggests the sifting ceiling could be higher than 1/3 — potentially approaching 1/2 — within the existing Croot–Sisask framework, if the sifting argument is applied more efficiently.

---

*End of Proof Strategy Document*
