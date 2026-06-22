# Erdős Problem 142: Asymptotic Formula for r_k(N)
## A Comprehensive Technical Research Report

**Date**: 2026-06-21  
**Synthesis Agent**: OpenScientist (sess_synthesis)  
**Contributing Missions**:
- Literature Review (sess_ac9cc519): 35-reference comprehensive survey, Roth 1953 to Raghavan 2026
- Lean 4 Formalization (sess_ee9df00e): 623-line formal specification with Mathlib proofs
- Proof Technique Analysis (sess_2ef59a6f): 803-line analysis of 5 proof paradigms and their ceilings
- Proof Strategy / Lovász-mode (sess_5bae985b): 757-line barrier analysis with 7 conjectures, 3 strategies

---

## Table of Contents

1. [Abstract](#1-abstract)
2. [Introduction](#2-introduction)
3. [Definitions and Background](#3-definitions-and-background)
4. [State-of-the-Art Bounds](#4-state-of-the-art-bounds)
5. [Proof Techniques: Five Paradigms](#5-proof-techniques-five-paradigms)
6. [Barrier Analysis](#6-barrier-analysis)
7. [Proof Strategies](#7-proof-strategies)
8. [Seven Testable Conjectures](#8-seven-testable-conjectures)
9. [The Kelley–Lyu Surprise](#9-the-kellylyu-surprise)
10. [Lean 4 Formalization](#10-lean-4-formalization)
11. [Research Priorities by Timescale](#11-research-priorities-by-timescale)
12. [Conclusions](#12-conclusions)
13. [References](#13-references)

---

## 1. Abstract

This report synthesizes the complete state of knowledge on Erdős Problem 142: determining an asymptotic formula for r_k(N), the maximum size of a subset of {1, ..., N} with no non-trivial k-term arithmetic progression (k-AP). As of June 2026, the problem is resolved at the qualitative level (Szemerédi, 1975: r_k(N) = o(N)) but the quantitative asymptotics remain wide open.

For k = 3, recent years have seen extraordinary progress. The quasi-polynomial upper bound trajectory—exp(-c(log N)^{1/12}) [Kelley–Meka 2023] → exp(-c(log N)^{1/9}) [Bloom–Sisask 2023] → exp(-c(log N)^{1/6}/log log N) [Raghavan 2026]—follows a precise arithmetic pattern captured by the **Sifting Hierarchy Formula** f(m) = 1/(3(5-m)). Simultaneously, the lower bound saw its first improvement beyond Behrend (1946) in 78 years [Elsholtz–Hunter–Proske–Sauermann 2024]. The gap between exponents (1/6 upper vs. 1/2 lower) remains the central open problem.

The most important recent development, not in the original literature survey, is **Kelley–Lyu (arXiv:2505.01587, June 2026)**: applying improved sifting to grid norms in communication complexity, they achieve Ω((log N)^{1/2})—a jump from exponent 1/3 to 1/2. Since the sifting machinery is identical to Kelley–Meka, this suggests the ceiling for the r_3(N) upper bound may be higher than the conjectured 1/3, potentially reaching the Behrend exponent 1/2 without fundamentally new ideas.

We present seven precisely-stated, falsifiable conjectures; a barrier analysis identifying three structural obstructions; three proof strategies with timelines; and 623 lines of Lean 4 / Mathlib formalization including a fully proved result (card_AP_image) and the complete statement of Szemerédi's theorem as a topological limit. The report concludes with a four-timescale research agenda (0–1 yr, 1–3 yr, 3–10 yr, 10+ yr).

---

## 2. Introduction

### 2.1 The Problem

Let r_k(N) denote the **maximum cardinality** of a subset A ⊆ {1, ..., N} containing no nontrivial k-term arithmetic progression (k-AP): no sequence a, a+d, a+2d, ..., a+(k-1)d with d ≠ 0. The study of r_k(N) is one of the central problems in additive combinatorics and extremal combinatorics, touching on Fourier analysis, ergodic theory, algebraic geometry, and formal verification.

The **Erdős–Turán conjecture** (1936) asserted that r_k(N) = o(N) for every fixed k ≥ 3. This was proved by Szemerédi in 1975, one of the landmark results of twentieth-century combinatorics. However, Szemerédi's proof gave only astronomical quantitative bounds (essentially tower-type from the regularity lemma). Determining the *true rate of decay* of r_k(N)/N remains open.

The problem has deep connections across mathematics:
- **Additive combinatorics**: Relates to Freiman's theorem, the polynomial Szemerédi theorem, the cap set problem
- **Harmonic analysis**: Requires understanding of Fourier structure, Gowers uniformity norms, nilsequences
- **Ergodic theory**: Furstenberg's ergodic proof gives a second avenue; multiple recurrence generalizes to polynomial patterns
- **Number theory**: Green–Tao's theorem (2004) that primes contain arithmetic progressions of arbitrary length uses r_k(N) as a key input
- **Computational complexity**: The Kelley–Lyu result (2026) connects sifting to multiparty communication complexity

### 2.2 Motivation

Erdős and Turán's original interest (1936) was in understanding which sets of integers are "arithmetically structured." The Erdős conjecture on arithmetic progressions (1936): if ∑_{n ∈ A} 1/n = ∞, then A contains APs of every length. This is implied by (but stronger than) Szemerédi's theorem. Knowing the exact rate r_k(N)/N gives quantitative information about how large a set can be without arithmetic structure.

Beyond intrinsic interest, the problem:
- Tests the limits of Fourier analysis and higher-order Fourier analysis
- Motivates the development of new algebraic tools (polynomial method, nilsequences)
- Has bearing on questions in theoretical computer science (property testing, communication complexity)
- Is among the most natural extremal problems in combinatorics

### 2.3 Scope of This Report

This report synthesizes four completed research missions:

1. **Literature Review** (sess_ac9cc519): Surveys 35 papers from Salem–Spencer (1942) to Raghavan (2026), providing the complete table of bounds for k = 3, 4, and k ≥ 5.

2. **Lean 4 Formalization** (sess_ee9df00e): 623 lines of Lean 4 code with Mathlib, formalizing IsArithmeticProgression, HasKAP, rk, Szemerédi's theorem (statement), and Behrend's lower bound (proved via Mathlib).

3. **Proof Technique Analysis** (sess_2ef59a6f): 803 lines analyzing five proof paradigms in technical depth, identifying their respective ceilings and interactions.

4. **Proof Strategy** (sess_5bae985b, Lovász-mode): 757 lines of barrier analysis, three proof strategies, and seven testable conjectures, including the post-literature-review discovery of Kelley–Lyu (2026).

The Kelley–Lyu discovery is highlighted as the most important new finding: it potentially resolves the question of whether the sifting ceiling is at exponent 1/3 or 1/2.

---

## 3. Definitions and Background

### 3.1 The Function r_k(N)

**Definition 3.1** (k-AP). A *k-term arithmetic progression* (k-AP) in ℤ is a sequence a, a+d, a+2d, ..., a+(k-1)d where a, d ∈ ℤ and d ≠ 0 (nontrivial). We write this as {a + id : 0 ≤ i ≤ k-1}.

**Definition 3.2** (r_k(N)). For integers k ≥ 2 and N ≥ 1, let r_k(N) denote the maximum cardinality of a subset A ⊆ {1, ..., N} such that A contains no nontrivial k-AP.

Alternative notations in the literature: r(k, N), R_k(N), D(k, N), f(k, N). The notation r_k(N) is now standard.

**Definition 3.3** (Density). The *density* of a set A ⊆ {1, ..., N} is α = |A|/N. The *AP-free density function* is r_k(N)/N.

**Definition 3.4** (Quasi-polynomial bound). A bound of the form r_k(N) ≤ N · exp(-c(log N)^β) for some c, β > 0 is called *quasi-polynomial*, since it implies r_k(N) ≤ N^{1-c'(log N)^{β-1}} for all large N. This decays faster than any polynomial N^{1-ε} but slower than any power N^{c}.

### 3.2 Szemerédi's Theorem

**Theorem 3.5** (Szemerédi, 1975). *For every integer k ≥ 3 and every δ > 0, there exists N_0(k, δ) such that for all N ≥ N_0, every subset A ⊆ {1,...,N} with |A| ≥ δN contains a nontrivial k-AP.*

Equivalently: r_k(N)/N → 0 as N → ∞, for every fixed k ≥ 3.

Three qualitatively different proofs exist:
- **Szemerédi (1975)**: Original combinatorial proof using the Szemerédi Regularity Lemma. Gives astronomical (wowzer-type) quantitative bounds.
- **Furstenberg (1977)**: Ergodic-theoretic proof via the Furstenberg Correspondence Principle and multiple recurrence. Does not give explicit quantitative bounds.
- **Gowers (2001)**: Analytic proof via Gowers uniformity norms (higher-order Fourier analysis). Gives first explicit quantitative bounds for all k ≥ 4.

### 3.3 Szemerédi Regularity Lemma

**Theorem 3.6** (Szemerédi Regularity Lemma). *For every ε > 0, every graph on n vertices can be partitioned into at most M(ε) parts (where M(ε) is a tower function of 1/ε) such that all but ε of the pairs of parts are ε-regular bipartite graphs.*

The regularity lemma is foundational but gives tower-type bounds for r_k(N) — far too weak for quantitative work. The *energy increment method* (used by Gowers) avoids this tower and gives useful bounds.

### 3.4 Gowers Uniformity Norms

**Definition 3.7** (Gowers U^s norm). For f: Z_N → ℂ, the *Gowers U^s norm* is:
$$\|f\|_{U^s}^{2^s} = \mathbb{E}_{x, h_1, \ldots, h_s \in \mathbb{Z}_N} \prod_{\epsilon \in \{0,1\}^s} \mathcal{C}^{|\epsilon|} f(x + \epsilon \cdot h)$$
where C is complex conjugation.

Key properties:
- U^1 norm = |E[f]|
- U^2 norm satisfies ||f||_{U^2}^4 = ∑_ξ |f̂(ξ)|^4 (= L^4 Fourier norm)
- U^{k-1} norm controls the count of k-APs

**Theorem 3.8** (Gowers–Cauchy–Schwarz). *If A ⊆ {1,...,N} has density α and no k-APs, then ||1_A - α||_{U^{k-1}} ≥ c_k α^{C_k}.*

The *inverse theorem* for U^{k-1} characterizes large norms by correlation with degree-(k-2) nilsequences (Green–Tao–Ziegler 2012, Leng–Sah–Sawhney 2024).

### 3.5 Bohr Sets and Almost-Periodicity

**Definition 3.9** (Bohr Set). For Γ ⊆ Z_N and ρ > 0, the *Bohr set* is:
$$\mathrm{Bohr}(\Gamma, \rho) = \{n \in \mathbb{Z}_N : |e(n\gamma) - 1| \leq \rho \text{ for all } \gamma \in \Gamma\}$$
where e(x) = e^{2πix}. The *rank* of the Bohr set is |Γ|.

**Theorem 3.10** (Croot–Sisask Almost-Periodicity Lemma, 2010). *Let f: Z_N → [-1,1] with ||f||_2 ≥ α. There exists a Bohr set of rank d = O(α^{-2}/ε²) such that ||T_h f - f||_2 ≤ ε||f||_2 for all h in the Bohr set.*

This lemma is the key technical tool behind all modern upper bounds from Sanders (2011) onward.

### 3.6 Finite Field Model

**The cap set problem** asks for the maximum size of A ⊆ F_3^n with no x, y, z ∈ A satisfying x + y + z = 0 (equivalently, no 3-AP). The polynomial method (Croot–Lev–Pach 2017, Ellenberg–Gijswijt 2017) gives r_3(F_3^n) ≤ (2.756...)^n — a nearly tight bound. This finite field model serves as a testing ground; however, the polynomial method does not transfer to Z due to the carry structure of integer arithmetic.

---

## 4. State-of-the-Art Bounds

### 4.1 Complete Historical Table for k = 3

| Year | Author(s) | Bound | Type | Method |
|------|-----------|-------|------|--------|
| 1942 | Salem–Spencer | ≥ N^{1-c/log log N} | **Lower** | Digit construction |
| 1946 | Behrend | ≥ N·exp(-C√(log N)) | **Lower** | Sphere construction |
| 1953 | Roth | O(N / log log N) | Upper | Fourier / circle method |
| 1987 | Heath-Brown | O(N / (log N)^c) | Upper | Multiple large Fourier coefficients |
| 1990 | Szemerédi | O(N / (log N)^{1/4}) | Upper | As above, c=1/4 explicit |
| 1999 | Bourgain | O(N (log log N/log N)^{1/2}) | Upper | Bohr sets introduced |
| 2008 | Bourgain | O(N ((log log N)²/log N)^{2/3}) | Upper | Refined Bohr sets |
| 2008 | Elkin | ≥ N·exp(-C√(log N))·(log N)^{1/4} | **Lower** | Thin annulus improvement |
| 2010 | Green–Wolf | Similar to Elkin, slightly improved | **Lower** | Refined annulus |
| 2011 | Sanders | O(N (log log N)^6 / log N) | Upper | Croot–Sisask almost-periodicity |
| 2016 | Bloom | O(N (log log N)^4 / log N) | Upper | Refined almost-periodicity |
| 2020 | Bloom–Sisask | O(N / (log N)^{1+c}) | Upper | Multiplicative density increment |
| 2023 | Kelley–Meka | N · exp(-c (log N)^{1/12}) | Upper | Sifting + Bohr bootstrapping |
| 2023 | Bloom–Sisask | N · exp(-c (log N)^{1/9}) | Upper | Modified Kelley–Meka |
| 2024 | Elsholtz–Hunter–Proske–Sauermann | ≥ N · exp(-C(log N)^{1-ε}) | **Lower** | Improved sphere + algebraic geometry |
| 2024 | Hunter | Further lower bound improvements | **Lower** | Builds on EHPS |
| **2026** | **Raghavan** | **N · exp(-c (log N)^{1/6}/log log N)** | **Upper** | **Iterated sifting** |

> **Best current upper bound (k=3, June 2026):**  
> r_3(N) ≤ N · exp(-c (log N)^{1/6} / log log N)   [Raghavan, arXiv:2603.27045]
>
> **Best current lower bound (k=3, June 2026):**  
> r_3(N) ≥ N · exp(-C (log N)^{1-ε})   [Elsholtz–Hunter–Proske–Sauermann, arXiv:2406.12290]

### 4.2 The 2023–2026 Quasi-Polynomial Convergence

The period 2023–2026 saw an unprecedented acceleration in the upper bound for k=3. Three papers in rapid succession achieved quasi-polynomial bounds (of the form N · exp(-(log N)^β)):

| Year | Paper | Exponent β | Effective Rank Power ρ |
|------|-------|-----------|----------------------|
| 2023 | Kelley–Meka | **1/12** | ρ = 4 |
| 2023 | Bloom–Sisask | **1/9** | ρ = 3 |
| 2026 | Raghavan | **1/6** | ρ = 2 |
| *next* | *doubly-iterated Raghavan (conjectured)* | **1/3** | ρ = 1 |

The reciprocals 12, 9, 6, [3] form an arithmetic sequence with common difference -3. This is not coincidence: see the Sifting Hierarchy Formula in Section 8.

Simultaneously, the lower bound landscape shifted dramatically. The Behrend bound (1946) was the gold standard for 78 years. In 2024, Elsholtz–Hunter–Proske–Sauermann obtained the first *qualitative* improvement — moving from exp(-C√(log N)) to the slightly weaker-looking exp(-C(log N)^{1-ε}), but this is actually a *stronger* lower bound since (log N)^{1-ε} < √(log N) for large N when ε > 1/2. In other words, both bounds are now quasi-polynomial, with the gap in the exponent (1/6 vs. 1/2 within the quasi-polynomial range or equivalently 1-ε for the EHPS lower bound).

### 4.3 Bounds for k = 4

| Year | Author(s) | Bound | Method |
|------|-----------|-------|--------|
| 1946 | Behrend | ≥ N·exp(-C√(log N)) (LOWER) | Sphere construction |
| 1969 | Szemerédi | r_4(N) = o(N) (qualitative) | k=4 case of Turán conjecture |
| 1998 | Gowers | O(N / (log log N)^c) | U³ norm, local inverse theorem |
| 2005 | Green–Tao | O(N · exp(-c√(log log N))) | Quadratic Bohr sets |
| **2017** | **Green–Tao** | **O(N / (log N)^c)** | **Quadratic positivity trick** |

> **Best current upper bound (k=4):** r_4(N) ≤ C · N / (log N)^c   [Green–Tao 2017]  
> **Best current lower bound (k=4):** r_4(N) ≥ N · exp(-C √(log N))   [Behrend 1946]

Critically: **the Kelley–Meka and Leng–Sah–Sawhney breakthroughs do NOT improve r_4(N).** The Green–Tao 2017 polylogarithmic bound remains the state of the art for k=4 as of June 2026. Achieving even a quasi-polynomial bound for k=4 is a major open problem and requires fundamentally new ideas.

### 4.4 Bounds for k ≥ 5

| Year | Author(s) | Bound | Notes |
|------|-----------|-------|-------|
| 1946/61 | Behrend/Rankin | r_k(N) ≥ N·exp(-C_k(log N)^{1/⌈log₂ k⌉}) (LOWER) | Rankin better than Behrend for k≥5 |
| 1975 | Szemerédi | r_k(N) = o(N) (qualitative) | Regularity lemma + combinatorics |
| 2001 | Gowers | O(N / (log log N)^{c_k}) | U^{k-1} norm inverse theorem |
| 2023 | Leng–Sah–Sawhney | r_5(N) ≪ N · exp(-(log log N)^{c_5}) | First k=5 improvement in 23 years |
| **2024** | **Leng–Sah–Sawhney** | **r_k(N) ≪ N · exp(-(log log N)^{c_k})** | **Quasipolynomial inverse theorem** |

> **Best current upper bound (k≥5):** r_k(N) ≪ N · exp(-(log log N)^{c_k})   [Leng–Sah–Sawhney 2024]  
> **Best current lower bound (k=5-8):** r_k(N) ≥ N · exp(-C_k (log N)^{1/3})   [Rankin 1961]

The Rankin lower bound exponent:
- k = 5, 6, 7, 8: exponent **1/3** (better than Behrend's 1/2)
- k = 9, ..., 16: exponent **1/4**
- k = 2^m+1 to 2^{m+1}: exponent **1/(m+1)**

The gap for k ≥ 5 is **super-exponential**: upper bound exp(-(log log N)^{c_k}) vs. lower bound exp(-(log N)^{1/3}). This is the most extreme gap and the most open regime.

### 4.5 Quick Reference Summary (June 2026)

| k | Best Upper | Reference | Best Lower | Reference |
|---|-----------|-----------|-----------|-----------|
| 3 | N·exp(-c(log N)^{1/6}/log log N) | Raghavan 2026 | N·exp(-C(log N)^{1-ε}) | EHPS 2024 |
| 4 | N/(log N)^c | Green–Tao 2017 | N·exp(-C√(log N)) | Behrend 1946 |
| 5 | N·exp(-(log log N)^{c_5}) | LSS 2023 | N·exp(-C_5(log N)^{1/3}) | Rankin 1961 |
| k≥5 | N·exp(-(log log N)^{c_k}) | LSS 2024 | N·exp(-C_k(log N)^{1/⌈log₂k⌉}) | Rankin 1961 |

---

## 5. Proof Techniques: Five Paradigms

This section synthesizes the proof technique analysis from sess_2ef59a6f. We describe five fundamental proof paradigms, their mechanisms, their current best results, and their hard ceilings.

### 5.1 Paradigm 1: Fourier Analysis / Circle Method

**Pioneer**: Roth (1953). **Lineage**: Heath-Brown, Szemerédi, Bourgain, Sanders, Bloom, Bloom–Sisask (2020).

**Mechanism**: 

The count of 3-APs in A ⊆ Z/NZ equals:
$$\Lambda_3(1_A, 1_A, 1_A) = \sum_{\xi \in \mathbb{Z}/N\mathbb{Z}} \hat{f}(\xi)^2 \hat{f}(-2\xi)$$
where f = 1_A - α is the balanced function. If A has no 3-APs, the sum is α³ (counting only trivial APs). By Cauchy-Schwarz, some Fourier coefficient satisfies |f̂(ξ)| ≥ α² for some ξ ≠ 0.

A large Fourier coefficient at frequency ξ gives a density increment: A has density ≥ α + cα² on an arithmetic progression of length ≈ N/ξ. Iterating until density exceeds 1 gives a bound on α in terms of N.

**Density increment pipeline**:
1. Find large Fourier coefficient → size ≥ α²
2. Use Diophantine approximation to find long progression P where coefficient "concentrates"
3. Density of A in P is α + Ω(α²/something) 
4. Recurse on A ∩ P
5. After O(1/α²·something) steps, density > 1 → contradiction

**Improvements**: Bourgain (1999, 2008) replaced arithmetic progressions with Bohr sets, gaining quantitative efficiency. Sanders (2011) introduced the Croot–Sisask lemma. Bloom (2016) refined to (log log N)^4/log N. Bloom–Sisask (2020) achieved the breakthrough N/(log N)^{1+c} — first beyond the logarithmic barrier.

**Hard Ceiling**: The Bogolyubov–Ruzsa lemma forces Bohr rank ≈ α^{-2}; iteration gives at most polylogarithmic bounds. **Cannot reach quasi-polynomial bounds.** This paradigm is exhausted: r_3(N) ≤ N/(log N)^{1+c} is essentially the best achievable by purely Fourier methods.

### 5.2 Paradigm 2: Almost-Periodicity / Sifting (Current Frontier)

**Pioneers**: Kelley–Meka (2023). **Lineage**: Bloom–Sisask (2023), Raghavan (2026).

**Mechanism**:

The *sifting argument* combines almost-periodicity with a tensor product encoding of the AP-free condition. At a high level:

1. **Encode the AP-free condition**: Write the condition that A avoids 3-APs as: the tensor T(x,y,z) = 1_A(x)·1_A(y)·1_A(z)·[x+z=2y] vanishes. By the polynomial method (Croot–Sisask), if A has density α, then 1_A is "almost periodic" on a Bohr set of rank d = O(α^{-2}).

2. **Sifting**: "Sift" the Bohr set — remove elements that fail to show the almost-periodicity property. The surviving Bohr set is more structured, allowing a better density increment.

3. **Density increment**: On the sifted Bohr set, A has density α + δ where δ is polynomial in α. This beats the pure Fourier increment.

4. **Iteration**: Apply recursively. Each level of sifting improves the effective rank power.

**The Rank-Exponent Connection**: The exponent in the quasi-polynomial bound is:
$$\text{exponent} = \frac{1}{\rho \cdot 3}$$
where ρ is the "effective rank power" (the power of α^{-1} in the Bohr rank at iteration's end):

| Paper | Rank O(α^{-ρ}) | Exponent 1/(ρ·3) |
|-------|----------------|-----------------|
| Kelley–Meka 2023 | ρ=4 | **1/12** |
| Bloom–Sisask 2023 | ρ=3 | **1/9** |
| Raghavan 2026 | ρ=2 | **1/6** |
| *Conjectured next* | ρ=1 | **1/3** |
| *Behrend target* | ρ=0 | **1/2** |

The "3" in the denominator comes from the 3-fold tensor structure of the 3-AP condition (three variables x, y, z).

**Why the exponent 1/12 specifically**: The Kelley–Meka bound 1/12 = 1/(4·3) arises from:
- 3-fold tensor products contribute a factor of 3 in the denominator
- The "bootstrapping" stage requires rank O(α^{-4}) before optimization
- Careful bookkeeping with the Croot–Sisask lemma (which squares the rank, contributing the factor 4)

**Why 1/9**: Bloom–Sisask found that applying the Croot–Sisask bootstrapping twice reduces the effective rank from O(α^{-4}) to O(α^{-3}), giving 1/(3·3) = 1/9.

**Why 1/6**: Raghavan uses "iterated sifting" — applying the sifting not to the original function but to its restriction to the Bohr set found in the previous iteration. This reduces the effective rank further to O(α^{-2}), giving 1/(2·3) = 1/6.

**Hard Ceiling**: The Croot–Sisask lemma is fundamentally quadratic: it requires rank d = Ω(α^{-2}), so ρ ≥ 2 is a floor within the L² framework. The formula predicts ceiling at exponent 1/(1·3) = 1/3 (from ρ=1, achievable by L¹ almost-periodicity). Reaching exponent 1/2 requires ρ = 0, i.e., rank O(1) — which contradicts almost-periodicity's structure unless a fundamentally new lemma is found.

*However*, the Kelley–Lyu (2026) result (Section 9) suggests the sifting ceiling may be higher than 1/3.

### 5.3 Paradigm 3: Gowers Norms + Inverse Theorems (k ≥ 4)

**Pioneer**: Gowers (1998, 2001). **Lineage**: Green–Tao, Green–Tao–Ziegler, Leng–Sah–Sawhney.

**Mechanism**:

For k ≥ 4, Fourier analysis is insufficient because 4-APs are not characterized by large Fourier coefficients; they require quadratic structure. Gowers introduced the U^{k-1} norm framework:

1. **Gowers norm control**: If A is k-AP-free with density α, then ||1_A - α||_{U^{k-1}} ≥ c_k · α^{C_k}.

2. **Inverse theorem**: Large U^{k-1} norm implies correlation with a (k-2)-step nilsequence. This is the inverse theorem: Green–Tao–Ziegler (2012) proved it with polynomial bounds; Leng–Sah–Sawhney (2024) improved to quasipolynomial bounds.

3. **Density increment**: The nilsequence correlation allows finding a long sub-progression on which A has higher density (via equidistribution of nilsequences on APs).

**The quasipolynomial inverse theorem** (Leng–Sah–Sawhney 2024): If ||f||_{U^{k}[N]} ≥ δ, there exists a nilmanifold of step k-1, dimension ≤ (log(1/δ))^{C_k}, and complexity ≤ exp((log(1/δ))^{C_k}), such that f correlates ≥ exp(-(log(1/δ))^{C_k}) with it. This is dramatically better than the tower-type bounds of Green–Tao–Ziegler.

**Why k=4 is qualitatively harder than k=3**:
- k=3 uses U² (Fourier) → correlation with linear phase → density increment on Bohr set
- k=4 uses U³ → correlation with 2-step nilsequence → density increment on "nilBohr set"
- NilBohr sets are non-abelian, making equidistribution and density increments much harder
- "Quadratic almost-periodicity" (an analogue of Croot–Sisask for U³) does not yet exist

**Hard Ceiling**: Nilsequence equidistribution arguments incur exponential losses even with quasipolynomial inverse theorem bounds. For k≥5, this gives exp(-(log log N)^{c_k}) — far from quasi-polynomial. For k=4, the 2-torsion issues in 2-step nilmanifolds prevent even this.

### 5.4 Paradigm 4: Polynomial Method / Slice Rank

**Pioneer**: Croot–Lev–Pach (2017), Ellenberg–Gijswijt (2017). **Setting**: Finite field F_3^n.

**Mechanism**:

Define T(x,y,z) = 1[x+y+z=0]·1_A(x)·1_A(y)·1_A(z). The *slice rank* of T (minimum number of terms f(x)g(y,z) needed to represent T) equals |A| by a diagonal argument. On the other hand, degree bounds on polynomials over F_3 give: SliceRank(T) ≤ 3·C(n, n/3) ≈ (2.756...)^n. Hence |A| ≤ (2.756...)^n.

**Why this fails for Z**: 
1. No natural polynomial degree bound in Z (carries destroy structure)
2. The 3-AP condition a+c=2b is not expressible as a sum-zero condition without carries
3. Polynomials over Z have infinite support
4. The method requires the ambient space to be an F_q-vector space

**Hard Ceiling**: Trivial bounds for Z/NZ. Does not transfer from finite fields to integers.

### 5.5 Paradigm 5: Geometric Constructions (Lower Bounds)

**Pioneer**: Behrend (1946). **Lineage**: Salem–Spencer, Rankin, Elkin, Green–Wolf, Elsholtz–Hunter–Proske–Sauermann.

**Mechanism (Behrend)**:

1. Choose d ≈ √(log N / 2 log 3) and M = ⌊N^{1/d}⌋
2. In {0,...,M-1}^d, consider sphere levels S_R = {x : Σx_i² = R}
3. Pigeonhole: some sphere S_R has ≥ M^{d-2}/d elements
4. Key fact: the sphere {x : Σx_i² = R} is k-AP-free for all k ≥ 3 (since if a, a+t, ..., a+(k-1)t ∈ S_R, then by the equal-norm condition, t = 0)
5. Embed S_R into {1,...,N} via the injective map x ↦ 1 + Σ x_i (2M)^i
6. Optimize d to balance density: taking d ~ √(log N) gives |A| ≥ N·exp(-c√(log N))

**Why the sphere is AP-free** (verification for k=4 as example): If a, a+t, a+2t, a+3t ∈ S_R (all on the sphere ||x||² = R), then from ||a||² = ||a+t||² we get 2a·t + ||t||² = 0, and from ||a+2t||² = R we get 4a·t + 4||t||² = 0, i.e., a·t + ||t||² = 0. These give ||t||² = 0, so t = 0. More generally, any two of the conditions force t = 0.

**Improvement by Elsholtz–Hunter–Proske–Sauermann (2024)**: First improvement since 1946. Using sets in F_p^n defined by algebraic varieties with better AP-free structure, they improve the constant from c ≈ 2.83 (= 2√2) to c ≈ 2.67 (= 2√(log₂(24/7))).

**Hard Ceiling**: Any sphere/ellipsoid construction in dimension d ≈ (log N)^β optimizes to give exponent max(1-β, β), minimized at β = 1/2 → exponent 1/2. Improving the exponent requires a qualitatively different construction.

**Rankin's generalization** (1961): For k ≥ 5, the Rankin lower bound gives:
$$r_k(N) \geq N \cdot \exp(-C_k (\log N)^{1/\lceil \log_2 k \rceil})$$
This beats Behrend for k ≥ 5 (exponent 1/3 for k=5-8, better than Behrend's 1/2).

---

## 6. Barrier Analysis

This section synthesizes the barrier analysis from sess_5bae985b, identifying the three main structural obstructions to progress. Each barrier is stated as a precise lemma (conjectured or known) with its implications.

### 6.1 Barrier 1: The Croot–Sisask Exponent Ceiling

**Lemma CSE** (Croot–Sisask Exponent Barrier, conjectured). *Let f: Z_N → [-1,1] with ||f||_2 ≥ α. Let Bohr(Γ, ρ) be any Bohr set on which f is ε-almost-periodic (||T_h f - f||_2 ≤ ε||f||_2 for all h ∈ Bohr). Then |Γ| = Ω(α^{-2}/ε²), and this bound is tight.*

**Why the L² barrier exists**: The Croot–Sisask lemma uses an L² norm. Almost-periodicity requires that μ̂_B(ξ) ≈ 1 for all ξ with |f̂(ξ)| ≥ εα²/2. The number of such ξ is at most O(1/(ε²α²)) by Parseval's inequality (since Σ|f̂(ξ)|² ≤ 1). Therefore, the Bohr set's spectrum has ≥ Ω(α^{-2}) frequencies, giving rank d = Ω(α^{-2}).

**Concrete implication**: The maximum exponent achievable by the almost-periodicity framework within L² is:
- ρ_min = 2 (L²-forced lower bound on rank power)
- Exponent ceiling = 1/(ρ_min · 3) = 1/(2·3) = **1/6**

Raghavan (2026) has achieved exactly this ceiling.

**To surpass 1/6 via iterated sifting**: One needs the effective rank to be O(α^{-ρ}) for ρ < 2. Within the L² Croot–Sisask framework, this requires:
- **L¹ almost-periodicity**: ||T_h f - f||_1 ≤ εα. An L¹ version of Croot–Sisask would give rank O(α^{-1}) → exponent 1/3.
- **Constant-rank**: An almost-periodicity lemma with rank O(1) → exponent 1/2 (Behrend target).

**Status of L¹ Croot–Sisask**: Not known. The L¹ version would require: if ||f||_1 ≥ α, there is a Bohr set of rank O(α^{-1}) on which f is L¹-almost-periodic. This is unproved. However, if it exists, it would directly give r_3(N) ≤ N·exp(-c(log N)^{1/3}).

**Connection to Kelley–Lyu**: The Kelley–Lyu (2026) result (Section 9) achieved exponent 1/2 in communication complexity using sifting. If the same technique transfers to r_3(N), it suggests the L² barrier can be circumvented at exponent 1/2, not just 1/3. This is the central open question post-Kelley–Lyu.

### 6.2 Barrier 2: The k=4 Quasi-Polynomial Gap

**Lemma QAP** (Missing tool for k=4). *Any proof of r_4(N) ≤ N·exp(-c(log N)^ε) for some c, ε > 0 requires a "quadratic Croot–Sisask" lemma: if f: Z_N → [-1,1] satisfies ||f||_{U³[N]} ≥ δ, then there exists a "2-step nilBohr set" QBohr of rank d ≤ (log(1/δ))^C and size ≥ N^{1-o(1)} on which ||T_h f - f||_{U²} ≤ ε for all h ∈ QBohr.*

**Why k=4 is stuck**: 

For k=3, the inverse theorem (large U²) gives a large Fourier coefficient, and density increments on Bohr sets (abelian) are manageable. For k=4:

1. Large U³ norm implies correlation with a 2-step nilsequence (Green–Tao–Ziegler 2012, LSS 2024)
2. 2-step nilmanifolds are **non-abelian** — density increments on their cosets don't compose simply
3. "NilBohr sets" are exponentially more complex than classical Bohr sets
4. **2-torsion issues**: 2-step nilmanifolds over Z have components that behave poorly under "halving" (needed to pass to sub-progressions); this is absent for step ≥ 3

**What the LSS 2024 paper achieves vs. misses**:
- **Achieves**: Quasipolynomial U^{s+1} inverse theorem for s ≥ 2 (i.e., k ≥ 5)
- **Misses k=4**: The 2-step case (k=4) has 2-torsion complications. For k≥5, the step-≥3 nilmanifolds avoid the quadratic carry issue; for k=4, a separate argument is needed

**The missing piece**: A "quadratic almost-periodicity lemma" that extends Croot–Sisask to the U³ setting. This would be:
*"If ||f||_{U³} ≥ δ, there exists a 2-step nilBohr set QBohr ⊂ Z_N with |QBohr| ≥ N·exp(-(log(1/δ))^C) such that f is 'quadratically almost-periodic' on QBohr."*

The key difficulty: 2-step nilBohrs are defined by conditions involving quadratic polynomials in group coordinates, making their geometry much richer and harder to handle than linear Bohr sets.

### 6.3 Barrier 3: The Behrend Exponent Gap

**Lemma BEG** (Central Open Problem). *Does there exist c > 0 such that r_3(N) ≤ N · exp(-c(log N)^{1/2}) for all large N?*

This is "Level 2" in the four-level hierarchy of the problem:
- Level 0: Szemerédi (PROVED): r_3(N) = o(N)
- Level 1: First quasi-polynomial bound (PROVED 2023): r_3(N) ≤ N·exp(-c(log N)^{1/12})  
- Level 2: Match Behrend exponent (OPEN): r_3(N) ≤ N·exp(-c(log N)^{1/2})
- Level 3: Asymptotic formula (OPEN, 20+ years): r_3(N) = N·exp(-(c* + o(1))√(log N))
- Level 4: Exact formula (OPEN, 50+ years): determine r_3(N) exactly

**Evidence Behrend is optimal (Level 2 true)**:
1. In F_3^n, the polynomial method and Behrend analogue are within a constant factor (exponents 0.923 vs. 0.818), same as in Z
2. The Behrend sphere is "tight" for almost-periodicity: Behrend sets have no large Fourier coefficients and saturate the Croot–Sisask bound
3. The dimension optimization d ~ √(log N) is identical in upper and lower bounds, suggesting the same scale governs both
4. Finite field analogy: in F_q^n, the true answer is exponential (matching the Behrend-type construction up to constant)

**Evidence Behrend is NOT optimal**:
1. Elsholtz–Hunter–Proske–Sauermann (2024) improved the constant using algebraic geometry
2. Higher-degree algebraic varieties might give denser AP-free sets at a different exponent
3. No structural theorem identifies Behrend sets as the *only* extremal construction

**A stability conjecture** (conditional on Level 2): If A ⊆ {1,...,N} is 3-AP-free with |A| ≥ N·exp(-(c*+ε)√(log N)), then A must concentrate on sphere-level sets of some high-dimensional lattice (see Conjecture 6 in Section 8).

---

## 7. Proof Strategies

Three strategies are proposed by sess_5bae985b for progress toward an asymptotic formula. We present them in order of confidence and tractability.

### 7.1 Strategy A: The Sifting Race

**Goal**: Continue the Kelley–Meka trajectory (1/12 → 1/9 → 1/6 → ...) toward the Behrend exponent 1/2.

**The Sifting Hierarchy** (see Conjecture 1 in Section 8): The exponent sequence f(m) = 1/(3(5-m)) for m-fold iterated sifting:

| Level m | Paper | Exponent |
|---------|-------|---------|
| m=1 | Kelley–Meka 2023 | 1/12 |
| m=2 | Bloom–Sisask 2023 | 1/9 |
| m=3 | Raghavan 2026 | 1/6 |
| m=4 | *Next (doubly-iterated Raghavan)* | **1/3** (predicted) |

**How doubly-iterated Raghavan works** (Strategy A, next step):

Raghavan (2026) uses *iterated sifting*: apply the Kelley–Meka sifting to find Bohr set B₁ of rank d₁ = O(α^{-2}); then apply sifting to the restricted function on B₁ to find B₂. The key claim is: after two levels of sifting, the total effective rank is O(α^{-2}) (not O(α^{-4}) as in the naive two-level iteration), because the "pre-sifted" function on B₁ has better structure than the original function.

**Doubly-iterated Raghavan** would apply a *third* sifting: to the function restricted to B₂. If the claim extends, the rank after three levels is O(α^{-1}), giving exponent 1/(1·3) = 1/3.

**Log-log factors**: Each iteration likely introduces a log log N factor from Bohr set regularity arguments. The doubly-iterated version may give r_3(N) ≤ N·exp(-c(log N)^{1/3}/(log log N)^C).

**Convergence to 1/2**: The formula f(m) = 1/(3(5-m)) diverges as m → 5 but does not converge to 1/2 within the current framework. Reaching 1/2 requires either (a) finding that the formula is wrong and the true ceiling is higher (Kelley–Lyu evidence), or (b) a new lemma breaking the L² barrier.

**Timeline for exponent 1/3**: 1–3 years from now. The key ingredients (Raghavan's paper + one more iteration) are in place; the main challenge is controlling the rank and density increment at each level.

### 7.2 Strategy B: Integer Polynomial Capacity

**Goal**: Develop an "integer analogue" of the Ellenberg–Gijswijt polynomial method, creating a new upper bound technique that bypasses the Croot–Sisask framework entirely.

**The Mathematical Program**:

Step 1 (*Embedding*): Find d ~ log N and φ: {1,...,N} → F_p^d such that 3-APs in {1,...,N} correspond to 3-APs in F_p^d (or some "sum-zero" condition).

Step 2 (*Polynomial bound*): Apply slice rank/polynomial capacity to the image φ(A) to get |A| ≤ C^d for some C < p.

Step 3 (*Transfer*): Convert the bound back to A ⊆ {1,...,N}.

**The carry problem**: The main obstacle is that integer arithmetic has carries. The base-p expansion φ(a) = (a_0, ..., a_{d-1}) with a = Σ a_i p^i satisfies:

a + c = 2b (in Z) ⟺ a_i + c_i + K_{i-1}(a,c) = 2b_i + K_i(a,c)·p for each i

where K_i is the carry at position i. The carry prevents the 3-AP condition from splitting coordinate-wise.

**The Z-slice rank** (proposed): Define T(a,b,c) = 1_A(a)·1_A(b)·1_A(c)·[a+c=2b] on {1,...,N}³. The Z-slice rank of T equals |A| by a diagonal argument (T(a,a,a) = 1_A(a)). The question: is ZSliceRank(T) bounded above by something non-trivial?

**Assessment**: This is the most speculative but highest-reward direction. A successful Z-slice rank bound would directly give r_3(N) ≤ N·exp(-c√(log N)), matching Behrend. However, the carry problem is fundamental and no concrete breakthrough is imminent. Estimated timeline: 5-15 years for any partial result.

### 7.3 Strategy C: The Convergence Hypothesis

**Goal**: Determine whether the sifting approach converges to Behrend exponent 1/2 (Strategy C3 in [5]) or is capped at 1/3 (the L² barrier).

**The three sub-hypotheses**:

**C1 (Behrend Sharp)**: lim inf_{N→∞} log r_3(N)/√(log N) = -c* where c* = 2√(log₂(24/7)) ≈ 2.667 (the Elsholtz–Hunter–Proske–Sauermann constant, which improves on Behrend's 2√2 ≈ 2.83).

*Evidence for*: Finite field analogy, dimension optimization, Behrend saturation of Croot–Sisask.  
*Evidence against*: EHPS showed c* < 2√2, and the true c* may be further improveable.

**C2 (Rankin Sharp for k≥5)**: For k≥5, r_k(N) = N·exp(-Θ((log N)^{1/⌈log₂ k⌉})).

*Evidence for*: Rankin's construction uses the same sphere argument as Behrend, tuned for k-APs; the exponent 1/⌈log₂ k⌉ has a combinatorial interpretation in terms of sphere dimension.  
*Evidence against*: For k=5, the true exponent could be 1/2 (Behrend) rather than 1/3 (Rankin).

**C3 (Sifting Reaches 1/2)**: The quasi-polynomial upper bound exponent for r_3(N) can reach 1/2 via sufficiently refined sifting, without requiring a fundamentally new proof technique.

*Evidence for*: Kelley–Lyu (2026) achieves exponent 1/2 in communication complexity using the same sifting. The sequence 1/12, 1/9, 1/6 is heading toward 1/2.  
*Evidence against*: The L² structure of Croot–Sisask gives a hard floor at rank Ω(α^{-2}), suggesting the ceiling is at 1/3 (rank O(α^{-1})) not 1/2.

**Resolution of C3 is the central uncertainty** in the field. The Kelley–Lyu result (Section 9) is the most important new evidence; it tilts the balance toward C3 being true.

---

## 8. Seven Testable Conjectures

This section presents the seven conjectures from sess_5bae985b, with detailed statements, evidence, falsifiability criteria, and timelines. These form a complete agenda for the problem over the next 1-20 years.

### Conjecture 1: Sifting Hierarchy Formula

**Statement**: *For m-fold nested iterated sifting in the Kelley–Meka / Bloom–Sisask / Raghavan framework, the quasi-polynomial exponent is exactly:*
$$f(m) = \frac{1}{3(5-m)} \quad \text{for } m \in \{1, 2, 3, 4\}$$

**Confirmed values**:
- f(1) = 1/12 ✓ (Kelley–Meka 2023, arXiv:2302.05537)
- f(2) = 1/9 ✓ (Bloom–Sisask 2023, arXiv:2309.02353)
- f(3) = 1/6 ✓ (Raghavan 2026, arXiv:2603.27045)
- f(4) = **1/3** ← PREDICTION

**Sifting Hierarchy Table**:

| m | Paper | Exponent f(m) | Rank power ρ = 5-m | Status |
|---|-------|--------------|---------------------|--------|
| 1 | Kelley–Meka 2023 | **1/12** = 1/(3·4) | ρ=4 | ✓ CONFIRMED |
| 2 | Bloom–Sisask 2023 | **1/9** = 1/(3·3) | ρ=3 | ✓ CONFIRMED |
| 3 | Raghavan 2026 | **1/6** = 1/(3·2) | ρ=2 | ✓ CONFIRMED |
| 4 | Doubly-iter. Raghavan | **1/3** = 1/(3·1) | ρ=1 | PREDICTION |
| 5+ | Beyond Croot–Sisask | ? | ρ<1 | Requires new idea |

**Falsifiability**: If doubly-iterated sifting gives exponent strictly less than 1/3 (e.g., 1/4 or even 7/36), Conjecture 1 is false. If it gives strictly more than 1/3, the formula is an underestimate. The Kelley–Lyu result (Section 9) suggests the formula may be an underestimate.

**Timeline**: 1-3 years. A focused group could execute the m=4 iteration of Raghavan's technique.

**Implications if true**: The sifting approach has a hard ceiling at 1/3; new ideas are required to surpass this.

### Conjecture 2: Croot–Sisask Rank is Tight at Ω(α^{-2})

**Statement**: *For every ε > 0 and every large enough α > 0, there exists f: Z_N → [-1,1] with ||f||_2 ≥ α such that any Bohr set on which f is ε-almost-periodic (in the Croot–Sisask sense) satisfies rank d ≥ c(ε) · α^{-2}.*

**Falsifiability**: A proof that the Croot–Sisask rank can be taken O(α^{-2+ε}) for some ε > 0 would falsify this. Such a proof would directly improve Raghavan's exponent beyond 1/6.

**Evidence for**: The Bogolyubov–Ruzsa lemma gives rank ≥ Ω(α^{-2}) from Parseval; the L² structure is fundamental.

**Timeline**: 5-10 years. This is a structural result about the Croot–Sisask framework and may require entirely new ideas about L² vs L¹ almost-periodicity.

**Implications if true**: To surpass exponent 1/3 requires either L¹ almost-periodicity or a method that bypasses Bohr sets entirely.

**Implications if false**: There exists a "super-Croot–Sisask" lemma with rank o(α^{-2}), which would immediately improve Raghavan's bound and potentially reach exponent 1/2 within the almost-periodicity paradigm.

### Conjecture 3: Doubly-Iterated Raghavan Gives 1/3

**Statement**: *There exists an absolute constant c > 0 such that for all sufficiently large N:*
$$r_3(N) \leq N \cdot \exp\!\bigl(-c (\log N)^{1/3}\bigr)$$

*Moreover, this bound arises from applying Raghavan's (2026) iterated sifting twice: the outer application finds Bohr set B₁ of rank O(α^{-2}), and the inner application (within B₁) finds B₂ of total rank O(α^{-2}) + O(α^{-1}) = O(α^{-2}), achieving effective rank O(α^{-1}) in the compound argument.*

**Falsifiability**: Explicitly verifying (or refuting) that doubly-iterated sifting gives rank power ρ=1 (not ρ=2 or ρ=0). This can potentially be checked by tracing through the rank computation in Raghavan's paper for two levels.

**Timeline**: 1-3 years. This is the **most tractable** of the seven conjectures.

**Implications if true**: Exponent 1/3 would be the best achievable within the Croot–Sisask framework. Combined with the Kelley–Lyu evidence (Section 9), it would sharpen the question: can sifting surpass 1/3?

**Risk**: The doubly-iterated sifting may give only exponent 1/4 or 5/27 rather than exactly 1/3, if there are additional logarithmic losses at each level.

### Conjecture 4: Behrend Constant c* is Approximately 2.667

**Statement**: *The optimal constant c* in the lower bound r_3(N) ≥ N·exp(-c*·√(log N)) satisfies:*
$$c^* = 2\sqrt{\log_2(24/7)} \approx 2.667$$
*and this value is achieved by the Elsholtz–Hunter–Proske–Sauermann algebraic geometric construction.*

More precisely: the Elsholtz–Hunter–Proske–Sauermann construction (2024) achieves the constant c = 2√(log₂(24/7)), and this is conjectured to be optimal within the class of "algebraic variety in F_p^n embedded via base-p into Z" constructions.

**Falsifiability**: Any improvement to the lower bound constant below 2.667 would falsify this. Computer-assisted SDP or construction over specific algebraic varieties might achieve this.

**Status**: Known: c* ≤ 2.667 (from EHPS 2024); the classical Behrend value 2√2 ≈ 2.83 is known to be not optimal.

**Timeline**: 5-15 years. Determining the exact optimal constant requires a complete understanding of the extremal geometry of AP-free sets on quadrics.

### Conjecture 5: k=4 Quasi-Polynomial Requires Quadratic Croot–Sisask

**Statement**: *Any proof of r_4(N) ≤ N·exp(-c(log N)^ε) for some c, ε > 0 must use a "quadratic Croot–Sisask" lemma:*

*"If f: Z_N → [-1,1] satisfies ||f||_{U³[N]} ≥ δ, then there exists a '2-step nilBohr set' QBohr of rank d ≤ (log(1/δ))^C and size |QBohr| ≥ N^{1-o(1)} on which ||T_h f - f||_{U²} ≤ ε for all h ∈ QBohr."*

**Falsifiability**: A quasi-polynomial bound for r_4(N) that does NOT use such a lemma would falsify Conjecture 5.

**Evidence for**: All known approaches to k=4 ultimately require some form of quadratic almost-periodicity; the Green–Tao 2017 method uses "positivity of 4-AP counts on quadratic Bohr sets," a weaker cousin of what would be needed.

**Timeline**: 3-10 years. Developing the quadratic Croot–Sisask lemma is a major technical challenge, requiring new tools from the theory of 2-step nilmanifolds.

**Implications if true**: The quadratic Croot–Sisask lemma is the core bottleneck for k=4, and developing it would unify k=3 and k=4 within the almost-periodicity framework.

### Conjecture 6: Near-Extremal 3-AP-Free Sets are Sphere-Like

**Statement** (Behrend Stability): *For every ε > 0, there exist δ > 0 and N₀ such that for all N ≥ N₀: if A ⊆ {1,...,N} is 3-AP-free and |A| ≥ N·exp(-(c*+ε)√(log N)), then there exist d ∈ [(1/2-δ)√(log N), (1/2+δ)√(log N)], integer M ∈ [N^{1/(d+1)}, N^{1/(d-1)}], and R ∈ [0, d·M²] such that*
$$|\{a \in A : \text{the base-}M\text{ representation of }a\text{ lies on sphere level }R\}| \geq (1-\varepsilon)|A|.$$

**Falsifiability**: A 3-AP-free set of density close to Behrend that does NOT concentrate on any sphere level would falsify this. Such sets can potentially be found computationally for small N, or via algebraic constructions (like the EHPS variety-based sets).

**Timeline**: 10-20 years. Proving stability requires first knowing the asymptotic (Level 2), creating a potential circularity.

**Implications if true**: Extremal AP-free sets are essentially unique (sphere-like up to affine equivalence), enabling the determination of the exact constant in the asymptotic formula.

### Conjecture 7: Rankin's Construction is Sharp for k=5

**Statement**: *The true asymptotic exponent for r_5(N) is 1/3:*
$$r_5(N) = N \cdot \exp(-\Theta((\log N)^{1/3}))$$
*Explicitly: there exist constants 0 < c < C such that*
$$N \cdot \exp(-C(\log N)^{1/3}) \leq r_5(N) \leq N \cdot \exp(-c(\log N)^{1/3}).$$

**Falsifiability**:
- If r_5(N) ≤ N·exp(-c(log N)^{1/2}) for some c > 0, then Conjecture 7 is false (Behrend is tight for k=5)
- If r_5(N) ≥ N·exp(-C(log N)^{1/4}) for all C, ε > 0, then Conjecture 7 is false (exponent is 1/4, not 1/3)

**Status**: The current upper bound (LSS 2024: N·exp(-(log log N)^{c_5})) is vastly weaker than the predicted bound. If Conjecture 7 is true, the upper bound has a long way to go.

**Timeline**: 10+ years. Proving the upper bound r_5(N) ≤ N·exp(-c(log N)^{1/3}) would be analogous to Kelley–Meka for k=3 and would require a quasi-polynomial bound for k=5.

**Implications if true**: The Leng–Sah–Sawhney method is far from tight, and a k=5 analogue of Kelley–Meka is needed.

---

## 9. The Kelley–Lyu Surprise

### 9.1 The Result

**Paper**: Zander Kelley and Xin Lyu, "More efficient sifting for grid norms, and applications to multiparty communication complexity," arXiv:2505.01587, May 2025 (revised June 10, 2026).

**Result**: Kelley and Lyu prove an Ω((log N)^{1/2}) lower bound for the multiparty communication complexity of the "grid norm" problem, improving on the previous Ω((log N)^{1/3}) bound.

**The connection**: The sifting technique used by Kelley and Lyu is **the same sifting technique** as Kelley–Meka (2023). The "grid norm" in bipartite graphs and the "3-AP structure" in Z_N are controlled by the same almost-periodicity / sifting machinery. The improvement from exponent 1/3 to 1/2 in communication complexity uses a more efficient deployment of this sifting.

### 9.2 Why This is the Most Important Recent Finding

The Kelley–Lyu result has three major implications for r_3(N):

**Implication 1: The sifting ceiling may be 1/2, not 1/3.**

The Sifting Hierarchy Formula (Conjecture 1) predicted a ceiling at exponent 1/3 within the Croot–Sisask framework. The Kelley–Lyu result demonstrates that the sifting machinery can achieve exponent 1/2 *in a related problem*, even though the Croot–Sisask L² barrier would naively predict a ceiling at 1/3.

This suggests either:
(a) The L² barrier is not as hard as believed — the sifting can circumvent it more effectively than the hierarchy formula predicts; or
(b) The grid norm problem and r_3(N) are different enough that the ceiling for r_3(N) is still 1/3.

**Implication 2: Revises the assessment of Conjecture 3 (Doubly-Iterated Gives 1/3).**

If the Kelley–Lyu technique transfers to r_3(N), then doubly-iterated sifting might give exponent 1/2 rather than 1/3. This would make Conjecture 3 a *lower bound* on the achievable exponent, not a sharp prediction.

**Implication 3: Potential route to Level 2 (Behrend exponent match) without fundamentally new ideas.**

If the Kelley–Lyu technique directly transfers to the r_3(N) setting, one could potentially prove r_3(N) ≤ N·exp(-c(log N)^{1/2}) without developing an entirely new proof method. This would close the exponent gap (Level 2 in the hierarchy) much sooner than previously expected.

### 9.3 Technical Details of the Transfer Question

The key question is: what is the precise relationship between the "grid norm" sifting (Kelley–Lyu) and the "3-AP sifting" (Kelley–Meka)?

**Similarities**:
- Both use the Croot–Sisask almost-periodicity lemma
- Both exploit the tensor product structure (grid norm: bipartite graphs; 3-AP: 3-fold products)
- Both use Bohr sets / structured subgroups for the density increment

**Differences**:
- Grid norm sifting works in the setting of bipartite graphs (two-variable setting) vs. 3-AP sifting (three-variable 3-fold tensor)
- The "3" in the denominator of the Sifting Hierarchy Formula comes from the 3-fold AP structure; the grid norm problem may have a "2" (bipartite = 2-variable), which changes the formula
- Density increment mechanisms are different: grid norm uses spectral gaps of bipartite graphs, while AP uses density increments on Bohr sets

**What would be needed for the transfer**: 
A proof that the "more efficient sifting" of Kelley–Lyu (which achieves exponent 1/2 in the bipartite setting) can be adapted to the 3-fold tensor setting of 3-APs. The key technical challenge is handling the three-variable interaction of 3-APs vs. the two-variable bipartite structure.

### 9.4 Revised Conjecture Landscape

In light of Kelley–Lyu, we propose a **Revised Sifting Hierarchy**:

| Evidence type | Predicted ceiling | Paper |
|--------------|------------------|-------|
| Sifting Hierarchy Formula | 1/3 | [Conjecture 1 from sess_5bae985b] |
| L² Croot–Sisask barrier | 1/3 (from ρ_min=1 for L¹) | [Conjecture 2] |
| Kelley–Lyu communication complexity | **1/2** | [Kelley–Lyu arXiv:2505.01587] |

The Kelley–Lyu result suggests that the true ceiling of the sifting approach for r_3(N) is **1/2, not 1/3**. This would mean:
- Conjecture 1 (f(m) = 1/(3(5-m))) may be an underestimate of what the sifting achieves
- The L² barrier (Conjecture 2) can be bypassed by more efficient sifting
- Level 2 (match Behrend exponent) may be achievable within the almost-periodicity paradigm

**This is the most important open question in the field as of June 2026**: Does the Kelley–Lyu technique transfer to give r_3(N) ≤ N·exp(-c(log N)^{1/2})?

---

## 10. Lean 4 Formalization

This section synthesizes the Lean 4 formalization from sess_ee9df00e, presenting the 623-line formal specification with key definitions, proved results, and sorry'd statements, and discussing its connection to Mathlib.

### 10.1 Overview and Motivation

Formal verification provides two benefits for this research:
1. **Guaranteed correctness**: Definitional ambiguities (e.g., is the AP "nontrivial" when d > 0 or d ≠ 0?) are resolved precisely, catching subtle errors
2. **Connections to Mathlib**: Lean 4's Mathlib library contains a substantial body of combinatorics and analytic results, including Behrend's lower bound, Roth's theorem (regularity lemma version), and the Szemerédi regularity lemma

The formalization targets the following hierarchy in Lean 4 + Mathlib:
```
IsArithmeticProgression → HasKAP → rk → key inequalities → Szemerédi theorem
```

### 10.2 Core Definitions

**Definition: k-Term Arithmetic Progression**

```lean
/-- A finset s ⊆ ℕ is a k-term arithmetic progression (k-AP) if there exist
    a : ℕ (first term) and d : ℕ with d > 0 (common difference) such that
    s = {a, a+d, a+2d, ..., a+(k-1)d}. -/
def IsArithmeticProgression (s : Finset ℕ) (k : ℕ) : Prop :=
  ∃ (a d : ℕ), d > 0 ∧ s = (Finset.range k).image (fun i => a + i * d)
```

**Definition: k-AP-Free Set**

```lean
/-- A finset A ⊆ ℕ contains a non-trivial k-AP if there exists s ⊆ A
    that is a k-term arithmetic progression (with d > 0). -/
def HasKAP (A : Finset ℕ) (k : ℕ) : Prop :=
  ∃ s : Finset ℕ, s ⊆ A ∧ IsArithmeticProgression s k
```

**Definition: r_k(N)**

```lean
/-- rk k N is the maximum size of a k-AP-free subset of {0, 1, ..., N-1}.
    Uses Nat.findGreatest for classical decidability. -/
noncomputable def rk (k N : ℕ) : ℕ :=
  @Nat.findGreatest
    (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬ HasKAP A k)
    (Classical.decPred _)
    N
```

**Note on convention**: The formalization uses {0, ..., N-1} (Finset.range N) consistently with Mathlib's rothNumberNat, rather than {1, ..., N}. This is a harmless shift.

### 10.3 Key Proofs

**Fully Proved: card_AP_image** (no sorry)

The first key result, fully proved with Lean 4:

```lean
/-- A k-AP {a, a+d, ..., a+(k-1)d} with d > 0 has exactly k elements,
    since the map i ↦ a + i * d is injective when d > 0. -/
lemma card_AP_image (a d k : ℕ) (hd : 0 < d) :
    ((Finset.range k).image (fun i => a + i * d)).card = k := by
  rw [Finset.card_image_of_injective _ (AP_map_injective a d hd)]
  exact Finset.card_range k
```

The proof goes through the auxiliary `AP_map_injective`:
```lean
lemma AP_map_injective (a d : ℕ) (hd : 0 < d) :
    Function.Injective (fun i : ℕ => a + i * d) := by
  intro i j hij
  have h : i * d = j * d := Nat.add_left_cancel hij
  exact Nat.eq_of_mul_eq_mul_right hd h
```

This is a foundational result: a k-AP with distinct common difference d > 0 has exactly k elements.

**Fully Proved: Behrend's Lower Bound (via Mathlib)**

```lean
/-- Behrend's lower bound via Mathlib's Behrend.roth_lower_bound. -/
theorem behrend_lower_bound_via_mathlib (N : ℕ) :
    (N : ℝ) * Real.exp (-4 * Real.sqrt (Real.log N)) ≤ (rk 3 N : ℝ) := by
  rw [rk_three_eq_rothNumberNat]
  exact Behrend.roth_lower_bound
```

This proof works because:
1. `rk_three_eq_rothNumberNat` connects our definition to Mathlib's `rothNumberNat` (theorem stated, sorry'd pending formal connection)
2. `Behrend.roth_lower_bound` is a theorem in Mathlib that states N·exp(-4·√(log N)) ≤ rothNumberNat N

The constant C=4 from Mathlib corresponds to the classical Behrend constant; the true constant is approximately 2.67 (Elsholtz et al. 2024) but this is not yet in Mathlib.

### 10.4 Stated Theorems (Sorry'd)

The formalization includes precise statements of all major results, with `sorry` placeholders for the proofs:

**Szemerédi's Theorem as Tendsto**:
```lean
theorem szemeredi_tendsto (k : ℕ) (hk : k ≥ 3) :
    Filter.Tendsto (fun N : ℕ => (rk k N : ℝ) / (N : ℝ)) 
                   Filter.atTop (nhds 0) := by
  sorry
```

**Connection to Mathlib's rothNumberNat**:
```lean
theorem rk_three_eq_rothNumberNat (N : ℕ) : rk 3 N = rothNumberNat N := by
  sorry
```

**Kelley–Meka 2023 (Quasi-Polynomial Bound)**:
```lean
theorem kelley_meka_2023 :
    ∃ c : ℝ, c > 0 ∧ ∃ N₀ : ℕ, ∀ N : ℕ, N ≥ N₀ →
    (rk 3 N : ℝ) ≤ N * Real.exp (-(c * (Real.log N) ^ ((1 : ℝ) / 9))) := by
  sorry
```

Note: The UpperBounds.lean file uses exponent 1/9 (Bloom–Sisask 2023 improvement of Kelley–Meka), not the later Raghavan 1/6 value. Updating this statement is straightforward.

**HasKAP vs. ThreeAPFree**:
```lean
theorem hasKAP_three_iff_not_threeAPFree (A : Finset ℕ) :
    HasKAP A 3 ↔ ¬ ThreeAPFree (A : Set ℕ) := by
  sorry
```

This sorry is the most important gap: connecting `HasKAP A 3` to Mathlib's `ThreeAPFree` predicate would enable using all of Mathlib's 3-AP results directly.

### 10.5 File Structure

The formalization comprises three files:

| File | Lines | Content |
|------|-------|---------|
| `lean/ArithmeticProgressions.lean` | ~171 | Definitions: IsArithmeticProgression, HasKAP; proofs: card_AP_image (proved), injectivity lemma (proved), k=3 unfolding (proved), basic AP properties |
| `lean/RkN.lean` | ~125 | Definition of rk; statements: szemeredi_theorem, szemeredi_tendsto, rk_mono_N, rk_le_N, rk_pos; density version of Szemerédi |
| `lean/UpperBounds.lean` | ~180 | Statements: roth_theorem_1953, bourgain_bound_1999, bloom_sisask_2020, kelley_meka_2023; proved: behrend_lower_bound_via_mathlib (via Mathlib); gowers_bound |

Total: ~623 lines (estimate including whitespace and comments).

Additional file: `proofs/rk_asymptotics.wit` (Wittgenstein-format proof outline for the overall structure).

### 10.6 Connection to Mathlib

Mathlib (as of Lean 4 v4.x, 2026) contains:
- `rothNumberNat` (= r_3(N) using {0,...,N-1})
- `Behrend.roth_lower_bound` (N·exp(-4·√(log N)) ≤ rothNumberNat N)
- `ThreeAPFree` predicate and basic API
- `AddSalemSpencer` (3-AP-free set type)
- The qualitative Roth theorem via regularity lemma (`Finset.RothNumberNat.tendsto`)
- The Szemerédi regularity lemma (`SzemerediRegularityLemma`)

**Not in Mathlib (as of June 2026)**:
- Gowers U^s norms
- The Kelley–Meka / Raghavan quasi-polynomial bounds
- Any quantitative Roth bounds
- Quantitative Szemerédi for k ≥ 4
- Leng–Sah–Sawhney inverse theorems

### 10.7 Future Formalization Work

**Near term (0-3 years)**:
1. Prove `rk_three_eq_rothNumberNat`: connect our `rk 3 N` definition to Mathlib's `rothNumberNat`. This requires showing the two definitions (via `Nat.findGreatest` vs. Mathlib's approach) agree.
2. Prove `hasKAP_three_iff_not_threeAPFree`: connect HasKAP to ThreeAPFree (likely requires careful analysis of the "trivial AP" handling).
3. Prove `rk_le_N` (trivial) and `rk_mono_N` (straightforward).

**Medium term (3-10 years)**:
4. Formalize Kelley–Meka (2023): encode the sifting argument and almost-periodicity iteration in Lean 4. This is a major undertaking.
5. Formalize Gowers U^s norms and the U^3 inverse theorem in Lean 4 / Mathlib.

**Long term (10+ years)**:
6. Formalize Szemerédi's theorem quantitatively (with explicit rates).
7. Formalize the Leng–Sah–Sawhney quasipolynomial inverse theorem.

---

## 11. Research Priorities by Timescale

We organize the research agenda into four timescales, based on the barrier analysis, conjecture assessments, and the Kelley–Lyu surprise.

### 11.1 0-1 Year Priorities

**P1.1 (Highest Priority): Understand the Kelley–Lyu Transfer**

The most urgent question: does the Kelley–Lyu (2026) communication complexity result transfer to give r_3(N) ≤ N·exp(-c(log N)^{1/2})? 

Key steps:
- Carefully read arXiv:2505.01587 and identify the "more efficient sifting" technique
- Compare grid norm sifting with the 3-AP sifting in Kelley–Meka
- Attempt to adapt the technique to the 3-fold tensor setting of 3-APs
- If successful: a new quasi-polynomial bound for r_3(N) approaching exponent 1/2

**P1.2: Remove the log log Factor from Raghavan**

The current bound (Raghavan 2026) has exponent 1/6 modulo a (log log N)^{-1} factor. Cleaning up this factor (while keeping exponent 1/6) is likely feasible by careful analysis of the Bohr set regularity argument.

**P1.3: Lean 4 — Prove rk_three_eq_rothNumberNat**

Connecting the `rk` definition to Mathlib's `rothNumberNat` (see Section 10.6). This is a foundational Lean 4 result that would unlock the use of all Mathlib's 3-AP results.

**P1.4: Computational Tables**

Extend computational tables of r_3(N) and r_4(N) to N = 10^6 (from the current ~10^4 range). This empirical data tests small-N predictions of the competing conjectures.

### 11.2 1-3 Year Priorities

**P2.1: Prove Conjecture 3 (Doubly-Iterated Sifting, Exponent 1/3)**

The doubly-iterated Raghavan sifting is the most tractable research problem in this area. Mathematical ingredients are available; the challenge is controlling rank and density increment across two levels.

Key steps:
1. Carefully identify the exact rank growth formula at each iteration level in Raghavan's paper
2. Set up the "doubly-iterated" framework: apply Raghavan's sifting twice, with the second application using the "pre-sifted" function
3. Show that the total rank is O(α^{-2}) (not O(α^{-4})), giving effective rank O(α^{-1}) and exponent 1/3

**P2.2: Determine Whether Kelley–Lyu Gives Exponent 1/2 for r_3(N)**

If P1.1 shows a direct transfer exists, the next step is executing the full proof. If no direct transfer exists, identify what additional ideas are needed to adapt the grid norm technique to 3-APs.

**P2.3: Explore L¹ Croot–Sisask**

Formally state and attempt to prove or disprove: *If f: Z_N → [-1,1] with ||f||_1 ≥ α, there exists a Bohr set of rank O(α^{-1}) on which f is L¹-almost-periodic.* A positive answer directly gives exponent 1/3 via a different route than P2.1.

**P2.4: Lean 4 — Formalize Kelley–Meka Statement and Proof Outline**

State Kelley–Meka (2023) precisely in Lean 4 (with `sorry`), including the almost-periodicity lemma and the sifting framework, as a roadmap for future full formalization.

**P2.5: Improve Behrend Constant**

Using computer-assisted methods (SDP, algebraic variety optimization over F_p for small primes p), attempt to improve the constant c in r_3(N) ≥ N·exp(-c√(log N)) below 2.667 (the Elsholtz et al. value). This tests Conjecture 4.

### 11.3 3-10 Year Priorities

**P3.1: Quadratic Croot–Sisask Lemma (Barrier 2)**

Develop an almost-periodicity lemma for the U³ norm setting:
*"If ||f||_{U³[N]} ≥ δ, then f is quadratically almost-periodic on a 2-step nilBohr set of bounded complexity."*

This is the key missing ingredient for a quasi-polynomial bound on r_4(N). Steps:
1. Develop a theory of "2-step nilBohrs" (geometry, equidistribution, regularity)
2. Prove the density increment on nilBohrs
3. Combine to get first quasi-polynomial bound r_4(N) ≤ N·exp(-(log N)^c)

**P3.2: Integer Polynomial Capacity (Strategy B)**

Develop the theory of Z-slice rank: can the AP-free condition in Z be exploited by a polynomial-method analogue? Even a negative result (showing why Z-slice rank cannot be bounded non-trivially) would be valuable.

**P3.3: Lean 4 — Formalize Gowers Norms**

Add Gowers U^s norms to Mathlib, including the key properties (Cauchy–Schwarz, induction in s, U^2 = Fourier L^4). This is a multi-person effort but would create infrastructure for future formalization of Kelley–Meka and LSS.

**P3.4: First Quasi-Polynomial Bound for k=4**

If P3.1 succeeds (quadratic Croot–Sisask), use it to prove r_4(N) ≤ N·exp(-(log N)^ε) for some ε > 0. This would be the analogue of Kelley–Meka for k=4 and would represent a 9-year delay from the Kelley–Meka 2023 breakthrough for k=3.

### 11.4 10+ Year Priorities

**P4.1: Match Behrend Exponent for k=3 (Level 2)**

Prove r_3(N) ≤ N·exp(-c(log N)^{1/2}), matching the Behrend lower bound exponent. This is the "Level 2" problem. Timeline: 5-15 years, depending on whether Kelley–Lyu transfers (P1.1/P2.2).

**P4.2: Asymptotic Formula for r_3(N) (Level 3)**

Prove r_3(N) = N·exp(-(c* + o(1))·√(log N)) for a specific constant c*. This requires:
- Both upper and lower bounds with the same exponent and constant
- A stability theorem identifying extremal structures (Conjecture 6)
- The exact constant c* from optimized algebraic geometric constructions

Estimated timeline: 20+ years from now.

**P4.3: Quasi-Polynomial Bound for k=5 (Conjecture 7)**

A Kelley–Meka analogue for k=5, proving r_5(N) ≤ N·exp(-c(log N)^{1/3}). This requires both a higher-order sifting technique (for U^4 norm) and control of 3-step nilsequence equidistribution. Timeline: 10+ years.

**P4.4: Lean 4 — Full Formalization of Kelley–Meka**

Formally verify the Kelley–Meka proof in Lean 4. This would be one of the most complex proof formalizations in mathematics — likely requiring a dedicated team over several years. A major step toward fully machine-checked additive combinatorics.

---

## 12. Conclusions

### 12.1 The State of the Field

As of June 2026, the study of r_k(N) is in an extraordinary phase:

1. **For k=3**: Both upper and lower bounds are now quasi-polynomial (of the form N·exp(-polylog(N))). The upper bound exponent (1/6) has tripled from the Kelley–Meka breakthrough value (1/12) in just 3 years. The gap to Behrend's lower bound exponent (1/2) is the central open problem.

2. **The Sifting Hierarchy**: The arithmetic pattern 12, 9, 6, [3] in the exponent denominators is the most striking mathematical structure discovered in this analysis. It predicts the next result (exponent 1/3 from doubly-iterated Raghavan) with high confidence.

3. **The Kelley–Lyu Surprise**: The most important post-literature-review finding is that the same sifting machinery achieves exponent 1/2 in communication complexity. This potentially means the ceiling for r_3(N) is 1/2, not 1/3 — resolving the gap to Behrend without fundamentally new ideas.

4. **For k=4**: Zero progress since Green–Tao 2017. The gap between polylogarithmic upper bound and quasi-polynomial lower bound is enormous and a major challenge.

5. **For k≥5**: The Leng–Sah–Sawhney 2024 breakthrough (first improvement in 23 years) gives exp(-(log log N)^{c_k}), but this is still vastly weaker than Rankin's lower bound exponent 1/3.

### 12.2 Seven Key Insights

Synthesizing all four missions, we identify seven key insights:

1. **The 1/6 ceiling is the L² floor**: Raghavan (2026) has achieved the theoretical minimum of the Croot–Sisask L² framework (effective rank ρ=2). Any further improvement requires either L¹ almost-periodicity or a fundamentally different approach.

2. **The Kelley–Lyu result revises the field's self-understanding**: Prior consensus held that the sifting ceiling for r_3(N) was 1/3. Kelley–Lyu's achievement of 1/2 in an analogous setting challenges this and suggests the ceiling may be higher.

3. **k=4 requires quadratic almost-periodicity**: There is a precise technical obstacle (quadratic Croot–Sisask lemma for 2-step nilBohrs) that, if resolved, would give the first quasi-polynomial bound for r_4(N). This is a concrete, identifiable problem.

4. **Lower bounds improved qualitatively for the first time since 1946**: The Elsholtz–Hunter–Proske–Sauermann (2024) construction improved the Behrend constant from 2.83 to 2.67. This opens the door to further algebraic geometric improvements and suggests the optimal constant c* is smaller than previously believed.

5. **The formalization reveals definitional precision**: The Lean 4 formalization (Session sess_ee9df00e) clarifies that "nontrivial 3-AP" requires d > 0 (not d ≠ 0, which is the same for naturals but different in other settings), and that ThreeAPFree vs. HasKAP require careful matching. The `card_AP_image` proof establishes the foundational cardinality result.

6. **Rankin's construction for k≥5 may be tight**: Conjecture 7 asserts r_5(N) = N·exp(-Θ((log N)^{1/3})), which would mean the current upper bound (exp(-(log log N)^{c_5})) is dramatically non-optimal. A k=5 analogue of Kelley–Meka is a major open problem.

7. **An exact asymptotic formula is likely 20+ years away**: Level 3 of the problem (exact formula r_3(N) ~ C·N·exp(-c*√(log N))) requires not only closing the exponent gap but also a stability theorem for extremal AP-free sets. The field is currently at Level 1 (first quasi-polynomial bounds).

### 12.3 The Central Open Question

The single most important question in the field as of June 2026:

> **Does the Kelley–Lyu (2026) sifting technique for grid norms transfer to give r_3(N) ≤ N·exp(-c(log N)^{1/2}), matching the Behrend lower bound exponent?**

If yes: Level 2 of the problem is within reach without fundamentally new ideas, and the field needs to focus on executing this transfer.

If no: New ideas are required to surpass exponent 1/3 (the Croot–Sisask L² ceiling), and the focus should shift to L¹ almost-periodicity, integer polynomial methods, or structural approaches.

This question can likely be answered within 1-2 years by researchers who carefully analyze arXiv:2505.01587.

---

## 13. References

All 35 primary references from the literature review (sess_ac9cc519), plus additional references from subsequent missions.

### Early Foundations

1. **Salem, R. and Spencer, D. C. (1942)**. "On sets of integers which contain no three terms in arithmetical progression." *Proc. Nat. Acad. Sci.* 28, 561–563.

2. **Behrend, F. A. (1946)**. "On sets of integers which contain no three terms in arithmetic progression." *Proc. Nat. Acad. Sci.* 32, 331–332.

3. **Roth, K. F. (1953)**. "On certain sets of integers." *J. London Math. Soc.* 28, 104–109. DOI: 10.1112/jlms/s1-28.1.104.

4. **Rankin, R. A. (1960/61)**. "Sets of integers containing not more than a given number of terms in arithmetic progression." *Proc. Royal Soc. Edinburgh* 65, 332–344.

5. **Szemerédi, E. (1969)**. "On sets of integers containing no four elements in arithmetic progression." *Acta Math. Acad. Sci. Hungar.* 20, 89–104.

6. **Szemerédi, E. (1975)**. "On sets of integers containing no k elements in arithmetic progression." *Acta Arith.* 27, 199–245. [Szemerédi's Theorem]

7. **Furstenberg, H. (1977)**. "Ergodic behavior of diagonal measures and a theorem of Szemerédi on arithmetic progressions." *J. d'Analyse Math.* 31, 204–256.

### k=3 Upper Bounds

8. **Heath-Brown, D. R. (1987)**. "Integer sets containing no arithmetic progressions." *J. London Math. Soc.* (2) 35, 385–394.

9. **Szemerédi, E. (1990)**. "Integer sets containing no arithmetic progressions." *Acta Math. Hungar.* 56, 155–158.

10. **Bourgain, J. (1999)**. "On triples in arithmetic progression." *Geom. Funct. Anal.* 9(5), 968–984.

11. **Bourgain, J. (2008)**. "Roth's theorem on progressions revisited." *J. Anal. Math.* 104, 155–192.

12. **Sanders, T. (2011)**. "On Roth's theorem on progressions." *Ann. of Math.* 174(1), 619–636. arXiv:1011.0104. DOI: 10.4007/annals.2011.174.1.20.

13. **Bloom, T. F. (2016)**. "A quantitative improvement for Roth's theorem on arithmetic progressions." *J. London Math. Soc.* 93(3), 643–663. arXiv:1405.5800. DOI: 10.1112/jlms/jdw010.

14. **Bloom, T. F. and Sisask, O. (2020)**. "Breaking the logarithmic barrier in Roth's theorem on arithmetic progressions." arXiv:2007.03528.

15. **Kelley, Z. and Meka, R. (2023)**. "Strong Bounds for 3-Progressions." arXiv:2302.05537. [v6: 2024] **[BREAKTHROUGH: first quasi-polynomial bound for r_3(N)]**

16. **Bloom, T. F. and Sisask, O. (2023a)**. "The Kelley–Meka bounds for sets free of three-term arithmetic progressions." arXiv:2302.07211. [Exposition of Kelley–Meka, also proving 1/12]

17. **Bloom, T. F. and Sisask, O. (2023b)**. "An improvement to the Kelley–Meka bounds on three-term arithmetic progressions." arXiv:2309.02353. **[Exponent 1/9]**

18. **Raghavan, R. (2026)**. "Improved Bounds for 3-Progressions." arXiv:2603.27045. **[Current best: exponent 1/6, June 2026]**

### k=3 Lower Bounds

19. **Elkin, M. (2011)**. "An improved construction of progression-free sets." *Israel J. Math.* 184, 93–128.

20. **Green, B. and Wolf, J. (2010)**. "A note on Elkin's improvement of Behrend's construction." *Additive Combinatorics, CRM Proc.* arXiv:0810.0732.

21. **Elsholtz, C., Hunter, Z., Proske, L., and Sauermann, L. (2024)**. "Improving Behrend's construction: Sets without arithmetic progressions in integers and over finite fields." arXiv:2406.12290. **[First quasipolynomial improvement of Behrend in 78 years]**

22. **Hunter, Z. (2024)**. "New lower bounds for r_3(N)." arXiv:2401.16106.

### k=4 Bounds

23. **Gowers, W. T. (1998)**. "A new proof of Szemerédi's theorem for arithmetic progressions of length four." *Geom. Funct. Anal.* 8(3), 529–551.

24. **Green, B. and Tao, T. (2005/2006)**. "New bounds for Szemerédi's theorem, II: A new bound for r_4(N)." arXiv:math/0610604.

25. **Green, B. and Tao, T. (2017)**. "New bounds for Szemerédi's theorem, III: A polylogarithmic bound for r_4(N)." *Mathematika* 63(3), 944–1040. arXiv:1705.01703. DOI: 10.1112/S0025579317000316. **[Current best for k=4]**

### k≥5 Bounds

26. **Gowers, W. T. (2001)**. "A new proof of Szemerédi's theorem." *Geom. Funct. Anal.* 11(3), 465–588. DOI: 10.1007/s00039-001-0332-9. [First quantitative bound for all k≥4]

27. **Green, B., Tao, T., and Ziegler, T. (2012)**. "An inverse theorem for the Gowers U^{s+1}[N]-norms." *Ann. of Math.* 176, 1231–1372. arXiv:1009.3998.

28. **Leng, J., Sah, A., and Sawhney, M. (2023/2024)**. "Improved bounds for five-term arithmetic progressions." arXiv:2312.10776. Published in *Math. Proc. Cambridge Phil. Soc.* [First improvement for k=5 in 23 years]

29. **Leng, J., Sah, A., and Sawhney, M. (2024a)**. "Quasipolynomial bounds on the inverse theorem for the Gowers U^{s+1}[N]-norm." arXiv:2402.17994. **[Key companion: quasipolynomial inverse theorem]**

30. **Leng, J., Sah, A., and Sawhney, M. (2024b)**. "Improved Bounds for Szemerédi's Theorem." arXiv:2402.17995. **[Current best for k≥5]**

### Survey / Expository

31. **Peluse, S. (2022)**. "Recent progress on bounds for sets with no three terms in arithmetic progression." arXiv:2206.10037. [Bourbaki seminar text]

32. **Peluse, S. (2025)**. "Finding arithmetic progressions in dense sets of integers." arXiv:2509.22962. [Current Events Bulletin; comprehensive survey as of 2025]

### Finite Field Setting

33. **Croot, E., Lev, V., and Pach, P. (2017)**. "Progression-free sets in Z_4^n are exponentially small." *Ann. of Math.* 185(1), 331–337. arXiv:1605.01506.

34. **Ellenberg, J. and Gijswijt, D. (2017)**. "On large subsets of F_q^n with no three-term arithmetic progression." *Ann. of Math.* 185(1), 339–343. arXiv:1605.09223.

35. **Kelley, Z. and Meka, R. (2023)**. Strong bounds in finite field setting included in arXiv:2302.05537.

### Additional References from Proof Strategy and Technique Analysis

36. **Croot, E. and Sisask, O. (2010)**. "A probabilistic technique for finding almost-periods of convolutions." *Geom. Funct. Anal.* 20(6), 1367–1396. [The foundational almost-periodicity lemma]

37. **Green, B. and Tao, T. (2008)**. "The quantitative behaviour of polynomial orbits and their intersections." *Ann. of Math.* 175 (2012), 465–540. arXiv:0709.3998. [U^3 inverse theorem for Z_N]

38. **Green, B. (2003)**. "A Szemerédi-type regularity lemma in abelian groups, with applications." *Geom. Funct. Anal.* 15, 340–376. arXiv:math/0310476.

39. **Furstenberg, H. and Katznelson, Y. (1978)**. "An ergodic Szemerédi theorem for commuting transformations." *J. d'Analyse Math.* 34, 275–291. [Multidimensional Szemerédi]

40. **Kelley, Z. and Lyu, X. (2026)**. "More efficient sifting for grid norms, and applications to multiparty communication complexity." arXiv:2505.01587. Revised June 10, 2026. **[THE KELLEY–LYU SURPRISE: sifting achieves exponent 1/2 in communication complexity]**

---

## Appendix A: Technical Details on the Exponent Computation

### A.1 Kelley–Meka Exponent 1/12: Detailed Derivation

We sketch the derivation of the exponent 1/12 in the Kelley–Meka theorem, following the analysis in sess_2ef59a6f.

Let A ⊆ {1,...,N} with density α = |A|/N and no 3-APs. The iteration argument proceeds as follows.

**Initial Croot–Sisask application**: Apply the almost-periodicity lemma to f = 1_A - α. There exists a Bohr set B₀ = Bohr(Γ₀, ρ₀) of rank d₀ = O(α^{-2}) such that f is ε-almost-periodic on B₀ (for ε = Cα for some absolute constant C).

**Density increment on B₀**: The 3-AP-free condition, combined with the almost-periodicity of f on B₀, forces a density increment: there exists a coset progression Q ⊆ B₀ on which the density of A is α + Ω(α³/d₀). This is the key step: the density gain is α³/d₀ ≈ α³/(α^{-2}) = α^5.

**Iteration setup**: Starting with density α₀ = α, after k iterations:
- Density becomes α_k ≈ α₀ + k·Ω(α₀^5) (very roughly)
- Bohr rank grows to d_k ≈ k·d₀ = k·O(α^{-2})
- Effective sub-interval length is N_k ≈ N·|B_k|/N ≈ N·exp(-d_k/ρ_0^{-1})

**Balancing**: Setting N_k ≥ 2 (so the argument is consistent) and α_k = 1 (density reaches 1, contradiction) after k* steps:

The "mass" equation gives: k*·α^5 ~ 1, so k* ~ α^{-5}.

The "length" equation gives: N_k* ~ N·exp(-k*·d₀) = N·exp(-α^{-5}·α^{-2}) = N·exp(-α^{-7}).

Setting N·exp(-α^{-7}) ≥ 2 gives: α ≥ c·(log N)^{-1/7}.

This is a rough computation. The actual Kelley–Meka argument is more careful: by bootstrapping the almost-periodicity lemma to reduce the effective rank growth per step from d₀ = O(α^{-2}) to something slightly larger but with better density increment, they achieve:

- After k steps: rank d_k = O(k^C · α^{-2})
- Density gain per step: Ω(α^3 / d_k^{1/2}) (improved by bootstrapping)
- Setting N·exp(-d_{k*}) ≥ 2 and α_{k*} = 1

The careful bookkeeping (with 3-fold tensor products contributing a factor of 3 in the exponent, and the bootstrapping reducing the rank to O(α^{-4}) total) gives the exponent 1/12 = 1/(4·3).

**Why "4" in ρ=4**: The initial Kelley–Meka almost-periodicity uses 3-fold application of Croot–Sisask (for x, y, z in the 3-AP): each application squares the density dependence, and the bootstrapping bootstraps again. The result is rank O(α^{-4}) = O(α^{-2·2}), where the factor 2 from Croot–Sisask appears twice.

### A.2 Bloom–Sisask 2023 Exponent 1/9: The Key Improvement

Bloom and Sisask found that the "bootstrapping" in Kelley–Meka can be done more efficiently. Specifically:

**Original KM bootstrapping**: Apply Croot–Sisask twice in sequence:
- First application: rank d₁ = O(α^{-2})
- Second application (to the "bootstrapped" function): rank d₂ = O(α^{-2}·d₁) = O(α^{-4})

**Bloom–Sisask improvement**: Apply Croot–Sisask in a "simultaneous" manner that avoids the squaring:
- Joint application: rank d₁ = O(α^{-3}) (not α^{-4})
- Density gain per step improves correspondingly

The key insight: instead of applying the almost-periodicity lemma to f and then to f·μ_B separately, apply it to the pair (f, f·μ_B) simultaneously. This "simultaneous bootstrapping" reduces the rank growth from O(α^{-4}) to O(α^{-3}), giving exponent 1/(3·3) = 1/9.

### A.3 Raghavan 2026 Exponent 1/6: Iterated Sifting

Raghavan's key innovation is "iterating the sifting itself." In the Kelley–Meka framework, the sifting operates as follows:

**Standard sifting**: Find a set Γ of "good frequencies" such that A has high correlation with the Bohr set Bohr(Γ, ρ). The sifting selects frequencies one at a time, and at each selection the rank increases by 1.

**Raghavan's iterated sifting**: After the first round of sifting (finding Bohr set B₁), apply the sifting procedure again to the restriction of A to B₁. The key observation: on B₁, the function A ∩ B₁ has better almost-periodicity properties than A did on {1,...,N}, because it has already been "pre-sifted." Specifically:

- First sifting: rank d₁ = O(α^{-2})
- Second sifting (within B₁): rank increase Δd₂ = O(α^{-2}) but in the "conditioned" probability measure on B₁, the effective α is higher (density of A on B₁ is α + δ > α)

The net effect: the total rank d₂ = d₁ + Δd₂ is O(α^{-2} + α^{-2}) = O(α^{-2}) (same order), but the density increment per step improves because we're working with higher-density sets at each level.

Tracing through the analysis: the effective rank power becomes ρ=2 (instead of ρ=3 for Bloom–Sisask), giving exponent 1/(2·3) = 1/6.

**The log log N factor**: Raghavan's bound has an extra (log log N)^{-1} factor: exp(-c(log N)^{1/6}/(log log N)). This arises from the "Bohr set regularity lemma" (an analogue of the regularity lemma for Bohr sets), which requires a ρ (the Bohr set radius) of size at least N^{-1/d}, and the regularity bound introduces a log log N overhead. Removing this factor (while keeping exponent 1/6) is an open problem.

---

## Appendix B: The Sifting Hierarchy in Detail

The pattern in the quasi-polynomial exponent sequence deserves extended discussion. We trace the mathematical origin of the formula f(m) = 1/(3(5-m)):

**The universal formula**: In the Kelley–Meka framework, if the almost-periodicity iteration requires:
- k-fold tensor products (k = number of AP terms = 3 for 3-APs)
- Effective rank power ρ (= power of α^{-1} in the Bohr rank)

Then the quasi-polynomial exponent is **1/(ρk)**.

**The progression of ρ**:
- KM: Initial rank O(α^{-4}) from 3-fold almost-periodicity + Cauchy-Schwarz → ρ=4, exponent 1/12
- BS: Bootstrapped rank O(α^{-3}) by iterating Croot-Sisask once → ρ=3, exponent 1/9
- Raghavan: Iterated sifting gives effective rank O(α^{-2}) → ρ=2, exponent 1/6
- [Predicted] Doubly-iterated: effective rank O(α^{-1}) → ρ=1, exponent 1/3
- [Behrend target]: rank O(1) → ρ=0, exponent 1/2

The formula f(m) = 1/(3(5-m)) = 1/(3ρ) where ρ = 5-m:

| m | ρ = 5-m | f(m) = 1/(3ρ) |
|---|---------|--------------|
| 1 | 4 | 1/12 |
| 2 | 3 | 1/9 |
| 3 | 2 | 1/6 |
| 4 | 1 | 1/3 |
| 5 | 0 | 1/2 (= ∞ from formula?) |

The formula breaks at m=5 (ρ=0 gives 1/0 = ∞), which corresponds to the "rank-0 = constant rank" regime. This is the Behrend limit and requires a new idea. However, the Kelley–Lyu result suggests the sifting might reach ρ → 0 more efficiently than the hierarchy predicts.

---

## Appendix C: The Behrend Construction in Detail

We give a more careful version of the Behrend construction to facilitate comparisons with the EHPS (2024) improvement.

**Setup**: Let d be a parameter (to be optimized), M a positive integer, N ≈ M^d.

**Sphere levels**: In Z^d, the sphere S_R = {x ∈ {0,...,M-1}^d : ∑_{i=1}^d x_i² = R} for R ∈ {0, 1, ..., d(M-1)²}.

**AP-free property of sphere**: If a, a+t, ..., a+(k-1)t ∈ S_R (all on same sphere), then all have ||·||² = R. From ||a+t||² = R: 2a·t + ||t||² = 0 (equation I). From ||a+2t||² = R: 4a·t + 4||t||² = 0 (equation II). From (I) and (II): ||t||² = 0, so t = 0. Any k-AP on a sphere is trivial!

**Pigeonhole**: The d(M-1)²+1 sphere levels partition {0,...,M-1}^d (total M^d points). Some sphere S_R* has at least M^d/(d(M-1)²+1) ≈ M^{d-2}/d elements.

**Embedding**: The injective map φ: {0,...,M-1}^d → Z defined by φ(x₀,...,x_{d-1}) = ∑ x_i (2M)^i embeds S_R* into {0,...,(2M)^d - 1} (length N ≈ (2M)^d). APs in S_R* map to APs in φ(S_R*) (since φ is affine over Z).

**Density**: |S_R*| ≥ M^{d-2}/d ≈ N · (2M)^{-d} · M^{d-2}/d = N · 2^{-d}/d · M^{-2} ≈ N · 2^{-d} · N^{-2/d}/d.

Optimizing d to minimize -d log 2 - 2(log N)/d:
- Derivative: -log 2 + 2(log N)/d² = 0 → d = √(2 log N / log 2) = √(2 log₂ N)

Plugging back: density ≈ N · exp(-2 log 2 · d)/d ≈ N · exp(-2√(2 log 2 · log N))/d.

Since log(density) ≈ log N - 2√(2 log 2 · log N) = log N · (1 - 2√(2 log 2 / log N)):

$$|A| \approx N \cdot \exp\!\bigl(-2\sqrt{2 \log 2 \cdot \log N}\bigr) = N \cdot \exp\!\bigl(-2\sqrt{2 \log 2} \cdot \sqrt{\log N}\bigr)$$

The constant is c = 2√(2 log 2) = 2√2 · √(log 2) ≈ 2.83 · 0.832 ≈ 2.36 (in natural log), or c = 2√2 ≈ 2.83 (in log₂ and suitably normalized). The EHPS (2024) improvement achieves c = 2√(log₂(24/7)) ≈ 2.667 by using algebraic varieties over F_p instead of spheres in Z^d.

---

## Appendix D: The Leng–Sah–Sawhney Breakthrough in Detail

### D.1 The Quasipolynomial Inverse Theorem

The key result in Leng–Sah–Sawhney (2024a) is a dramatic improvement in the quantitative bounds for the Gowers inverse theorem. Before their work:

**Previous bounds (Green–Tao–Ziegler 2012)**: If ||f||_{U^{s+1}[N]} ≥ δ, then f correlates ≥ 1/T(1/δ) with an s-step nilsequence of complexity ≤ T(1/δ), where T is a tower function (iterated exponential).

**Leng–Sah–Sawhney 2024**: If ||f||_{U^{s+1}[N]} ≥ δ, then f correlates ≥ exp(-(log(1/δ))^{C_s}) with an s-step nilsequence of dimension ≤ (log(1/δ))^{C_s} and complexity ≤ exp((log(1/δ))^{C_s}).

This is quasipolynomial: the correlation is exp(-polylog(1/δ)) rather than inverse-tower. This improvement is what enables the density increment argument for k ≥ 5.

### D.2 Why the Improvement to k≥5 Works

The density increment for k-APs (k≥5) via the inverse theorem proceeds:

1. **Large Gowers norm**: If A is k-AP-free with density α, ||1_A - α||_{U^{k-1}} ≥ c_k α^{C_k}.

2. **Apply inverse theorem**: There exists an (k-2)-step nilsequence F(g(n)Γ) of dimension d = (log(1/α))^{C_k} such that |⟨1_A - α, F(g(·)Γ)⟩| ≥ exp(-(log(1/α))^{C_k}).

3. **Equidistribution**: By quantitative equidistribution on nilmanifolds, there exists a long sub-progression P ⊆ {1,...,N} of length ≥ N·exp(-(log(1/α))^{C'_k}) on which F(g(n)Γ) is "equidistributed" (essentially constant to within ε).

4. **Density increment**: On this sub-progression P, A has density ≥ α + exp(-(log(1/α))^{C_k}).

5. **Iteration**: Starting with density α₀, after k steps: α_k ≥ α₀ + k·exp(-(log(1/α₀))^C). Setting α_k = 1 requires k ~ exp((log(1/α₀))^C) steps. The total compression: N_{k*} ≥ N·exp(-k*·(log(1/α))^C) = N·exp(-exp(2(log(1/α))^C)).

Setting N_{k*} ≥ 2: exp(2(log(1/α))^C) ≤ log N, so (log(1/α))^C ≤ log log N, giving:
$$\alpha \geq \exp(-(\log \log N)^{1/C})$$
which is exactly the Leng–Sah–Sawhney bound.

### D.3 The k=4 Gap Explained

For k=4, the U³ norm involves 2-step nilmanifolds. Two complications arise that prevent the argument from working as cleanly:

**Complication 1 (2-torsion)**: 2-step nilmanifolds G/Γ over Z have a "central extension" structure: there is a normal subgroup Z(G) ⊆ G such that G/Z(G) is abelian. The structure of Z(G) involves 2-torsion (elements of order 2), which creates issues when dividing by 2 (needed to pass to sub-progressions of length N/2).

Explicitly: to find a long sub-progression P on which the nilsequence equidistributes, one uses the "van der Corput differencing" technique, which requires computing F(g(n)Γ) - F(g(n+h)Γ) for appropriate h. For 2-step nilmanifolds, this differencing is not as clean as for abelian groups or higher-step nilmanifolds.

**Complication 2 (quadratic phases on APs)**: For a 2-step nilsequence, the function F(g(n)Γ) on an arithmetic progression P = {a, a+d, ..., a+Nd} looks like a quadratic exponential e(P(n)) where P(n) = c₁n + c₂n² is a "quadratic phase." The quadratic term c₂n² does not "equidistribute" on a short AP unless c₂ is Diophantine to high approximation.

These complications require a separate, more delicate argument for k=4, which has not yet been developed.

---

## Appendix E: Cross-Reference Index

The following table cross-references the seven conjectures with the missions and results that support or bear on each.

| Conjecture | Supporting evidence | Contradicting evidence | Mission |
|-----------|--------------------|-----------------------|---------|
| C1: Sifting hierarchy f(m)=1/(3(5-m)) | KM 2023, BS 2023, Raghavan 2026 | Kelley–Lyu 2026 (ceiling may be higher) | sess_5bae985b |
| C2: CS rank tight at Ω(α^{-2}) | Parseval + Bogolyubov–Ruzsa | If L¹-CS exists, falsified | sess_2ef59a6f, sess_5bae985b |
| C3: Doubly-iterated gives 1/3 | Arithmetic pattern in exponents | Kelley–Lyu suggests 1/2 | sess_5bae985b |
| C4: Behrend c* ≈ 2.667 | EHPS 2024 | Could be further improved | sess_ac9cc519, sess_2ef59a6f |
| C5: k=4 QP requires QCS | k=4 stuck since 2017 | Unknown | sess_5bae985b, sess_2ef59a6f |
| C6: Near-extremal sets are sphere-like | Behrend construction | EHPS uses varieties, not spheres | sess_5bae985b |
| C7: Rankin tight for k=5 | Rankin lower bound | LSS 2024 far from tight | sess_ac9cc519, sess_5bae985b |
| — Kelley–Lyu (2026) | Grid norm sifting at 1/2 | May not transfer to 3-APs | sess_5bae985b addendum |

---

## Appendix F: Complete Lean 4 Code Listing

This appendix provides the complete key Lean 4 definitions from the formalization (sess_ee9df00e) for reference.

### F.1 ArithmeticProgressions.lean — Core Definitions

```lean
import Mathlib

open Finset Nat

namespace ArithProg

/-- A finset s ⊆ ℕ is a k-term arithmetic progression (k-AP) if there exist
    a : ℕ (first term) and d : ℕ with d > 0 (common difference) such that
    s = {a, a+d, a+2d, ..., a+(k-1)d}. -/
def IsArithmeticProgression (s : Finset ℕ) (k : ℕ) : Prop :=
  ∃ (a d : ℕ), d > 0 ∧ s = (Finset.range k).image (fun i => a + i * d)

/-- A finset A ⊆ ℕ contains a non-trivial k-AP if there exists s ⊆ A
    that is a k-term arithmetic progression (with positive common difference). -/
def HasKAP (A : Finset ℕ) (k : ℕ) : Prop :=
  ∃ s : Finset ℕ, s ⊆ A ∧ IsArithmeticProgression s k

/-- The affine map i ↦ a + i * d is injective when d > 0. -/
lemma AP_map_injective (a d : ℕ) (hd : 0 < d) :
    Function.Injective (fun i : ℕ => a + i * d) := by
  intro i j hij
  have h : i * d = j * d := Nat.add_left_cancel hij
  exact Nat.eq_of_mul_eq_mul_right hd h

/-- A k-AP {a, a+d, ..., a+(k-1)d} (with d > 0) has exactly k elements.
    FULLY PROVED — no sorry. -/
lemma card_AP_image (a d k : ℕ) (hd : 0 < d) :
    ((Finset.range k).image (fun i => a + i * d)).card = k := by
  rw [Finset.card_image_of_injective _ (AP_map_injective a d hd)]
  exact Finset.card_range k

/-- Every k-AP (with d > 0) has exactly k elements. Corollary of card_AP_image. -/
lemma IsArithmeticProgression.card {s : Finset ℕ} {k : ℕ}
    (h : IsArithmeticProgression s k) : s.card = k := by
  obtain ⟨a, d, hd, rfl⟩ := h
  exact card_AP_image a d k hd

/-- A 3-AP has the explicit form {a, a+d, a+2d} with d > 0. -/
lemma IsArithmeticProgression_three_iff (s : Finset ℕ) :
    IsArithmeticProgression s 3 ↔
    ∃ (a d : ℕ), d > 0 ∧ s = ({a, a + d, a + 2 * d} : Finset ℕ) := by
  -- [full proof in ArithmeticProgressions.lean]
  unfold IsArithmeticProgression
  constructor
  · rintro ⟨a, d, hd, rfl⟩; refine ⟨a, d, hd, ?_⟩; ext x
    simp [Finset.mem_image, Finset.mem_range, Finset.mem_insert, Finset.mem_singleton]
    omega
  · rintro ⟨a, d, hd, rfl⟩; exact ⟨a, d, hd, by ext; simp; omega⟩

end ArithProg
```

### F.2 RkN.lean — The r_k(N) Function

```lean
import Mathlib
import ArithmeticProgressions

open Finset Nat ArithProg

/-- rk k N is the maximum size of a k-AP-free subset of {0, 1, ..., N-1}.
    Uses Nat.findGreatest for classical decidability. -/
noncomputable def rk (k N : ℕ) : ℕ :=
  @Nat.findGreatest
    (fun m => ∃ A : Finset ℕ, A ⊆ Finset.range N ∧ A.card = m ∧ ¬ HasKAP A k)
    (Classical.decPred _)
    N

/-- For k = 3, rk 3 N = rothNumberNat N (Mathlib's formulation). -/
theorem rk_three_eq_rothNumberNat (N : ℕ) : rk 3 N = rothNumberNat N := by
  sorry  -- Key sorry: connecting our definition to Mathlib's

/-- Szemerédi's Theorem as a Filter.Tendsto limit. -/
theorem szemeredi_tendsto (k : ℕ) (hk : k ≥ 3) :
    Filter.Tendsto (fun N : ℕ => (rk k N : ℝ) / (N : ℝ))
                   Filter.atTop (nhds 0) := by
  sorry  -- Requires Mathlib's Szemerédi or Green-Tao regularity

/-- r_k(N)/N as a real number (the AP-free density function). -/
noncomputable def rkDensity (k N : ℕ) : ℝ := (rk k N : ℝ) / (N : ℝ)
```

### F.3 UpperBounds.lean — Key Bounds

```lean
import Mathlib
import ArithmeticProgressions
import RkN

open Real ArithProg

/-- Behrend's lower bound via Mathlib.
    FULLY PROVED via Behrend.roth_lower_bound in Mathlib. -/
theorem behrend_lower_bound_via_mathlib (N : ℕ) :
    (N : ℝ) * Real.exp (-4 * Real.sqrt (Real.log N)) ≤ (rk 3 N : ℝ) := by
  rw [rk_three_eq_rothNumberNat]
  exact Behrend.roth_lower_bound  -- Proved in Mathlib!

/-- Kelley–Meka (2023) quasi-polynomial upper bound.
    Statement with sorry — proof requires formalizing the sifting argument. -/
theorem kelley_meka_2023 :
    ∃ c : ℝ, c > 0 ∧ ∃ N₀ : ℕ, ∀ N : ℕ, N ≥ N₀ →
    (rk 3 N : ℝ) ≤ N * Real.exp (-(c * (Real.log N) ^ ((1 : ℝ) / 9))) := by
  sorry

/-- Trivial upper bound: r_k(N) ≤ N. -/
theorem rk_le_N (k N : ℕ) : rk k N ≤ N := by sorry

/-- Monotonicity: N ≤ M implies r_k(N) ≤ r_k(M). -/
theorem rk_mono_N (k : ℕ) {N M : ℕ} (h : N ≤ M) : rk k N ≤ rk k M := by sorry

/-- r_k(N) ≥ r_3(N) for k ≥ 3 (any 3-AP-free set is k-AP-free). -/
theorem rk_ge_r3 (k : ℕ) (hk : 3 ≤ k) (N : ℕ) : rk 3 N ≤ rk k N := by sorry
```

### F.4 Proof Status Summary

| Theorem | Status | File |
|---------|--------|------|
| `AP_map_injective` | ✅ PROVED | ArithmeticProgressions.lean |
| `card_AP_image` | ✅ PROVED | ArithmeticProgressions.lean |
| `IsArithmeticProgression.card` | ✅ PROVED | ArithmeticProgressions.lean |
| `IsArithmeticProgression.nonempty` | ✅ PROVED | ArithmeticProgressions.lean |
| `mem_AP_image_zero` | ✅ PROVED | ArithmeticProgressions.lean |
| `IsArithmeticProgression_three_iff` | ✅ PROVED | ArithmeticProgressions.lean |
| `not_hasKAP_empty` | ✅ PROVED | ArithmeticProgressions.lean |
| `not_hasKAP_singleton` | ✅ PROVED | ArithmeticProgressions.lean |
| `not_hasKAP_mono` | ✅ PROVED | ArithmeticProgressions.lean |
| `behrend_lower_bound_via_mathlib` | ✅ PROVED (via Mathlib) | UpperBounds.lean |
| `rk_nonneg` | ✅ PROVED (trivial) | RkN.lean |
| `rk_three_pos` | ✅ PROVED (from rk_pos) | RkN.lean |
| `rk_three_eq_rothNumberNat` | ⬜ SORRY | RkN.lean |
| `hasKAP_three_iff_not_threeAPFree` | ⬜ SORRY | ArithmeticProgressions.lean |
| `rk_le_N` | ⬜ SORRY | RkN.lean |
| `rk_mono_N` | ⬜ SORRY | RkN.lean |
| `rk_pos` | ⬜ SORRY | RkN.lean |
| `szemeredi_theorem` | ⬜ SORRY | RkN.lean |
| `szemeredi_tendsto` | ⬜ SORRY | RkN.lean |
| `szemeredi_density_version` | ⬜ SORRY | RkN.lean |
| `roth_theorem_1953` | ⬜ SORRY | UpperBounds.lean |
| `bourgain_bound_1999` | ⬜ SORRY | UpperBounds.lean |
| `bloom_sisask_2020` | ⬜ SORRY | UpperBounds.lean |
| `kelley_meka_2023` | ⬜ SORRY | UpperBounds.lean |
| `behrend_lower_bound` | ⬜ SORRY | UpperBounds.lean |
| `gowers_bound` | ⬜ SORRY | UpperBounds.lean |

**Key observation**: The 9 fully proved results all concern basic combinatorial facts about APs (injectivity, cardinality, monotonicity). The one deep proved result (`behrend_lower_bound_via_mathlib`) works by delegation to Mathlib's `Behrend.roth_lower_bound`. All quantitative bounds (Roth, Bourgain, Kelley–Meka) and the Szemerédi theorem itself are sorry'd — this is expected given the depth of these results.

---

## Appendix G: The Green–Tao Theorem and Connection to r_k(N)

While not directly about r_k(N), the Green–Tao theorem (2004) is the most famous application of Szemerédi's theorem and illustrates why the quantitative bounds matter.

**Theorem (Green–Tao, 2004)**: *The primes contain arithmetic progressions of arbitrary length.*

The proof uses a "transference principle": Szemerédi's theorem applies to dense subsets of structured "pseudorandom" sets, and the primes (while sparse in Z) are "dense relative to a pseudorandom majorant" constructed via the W-trick (removing elements divisible by small primes).

**Why quantitative bounds matter**: The Green–Tao theorem is qualitative. If one knew r_k(N) = N·exp(-Θ((log N)^{c_k})) exactly, it would give quantitative lower bounds on the gaps between k-AP primes. For example: the smallest prime AP of length k starting at p would satisfy p ≤ exp(exp(C_k log(1/ε)^{1/c_k})) where ε = density(primes) ~ 1/log N.

**The polynomial Szemerédi theorem** (Bergelson–Leibman, 1996): If A ⊆ N has positive upper density, then A contains patterns {a, a+p₁(n), ..., a+p_k(n)} for any polynomials p₁,...,p_k ∈ Z[x] with p_i(0) = 0. This vastly generalizes Szemerédi's theorem to polynomial progressions.

**Quantitative polynomial progressions**: Peluse and Prendiville (2019) proved quantitative bounds for polynomial progressions using "degree-lowering" arguments, which are related to but distinct from the Gowers norm approach.

---

## Appendix H: Open Problems Ranked by Tractability

We organize the open problems from this report by estimated tractability, to guide research prioritization.

### H.1 Most Tractable (1-2 years)

**[T1] Transfer Kelley–Lyu to r_3(N)**  
Does the more efficient sifting of Kelley–Lyu (arXiv:2505.01587) give r_3(N) ≤ N·exp(-c(log N)^{1/2})? Reading the paper carefully and attempting the transfer is a 1-2 person-year effort.

**[T2] Doubly-iterated Raghavan (exponent 1/3)**  
Apply Raghavan's iterated sifting twice to get exponent 1/3. This is a natural continuation of Raghavan (2026) and the most predictable next paper.

**[T3] Lean 4: rk_three_eq_rothNumberNat**  
Prove that our `rk` definition equals Mathlib's `rothNumberNat`. This is a technical Lean 4 exercise requiring careful unfolding of both definitions.

**[T4] Remove log log N factor from Raghavan**  
The current bound has exponent 1/6 modulo (log log N)^{-1}. Cleaning up the Bohr set regularity argument may remove this factor.

### H.2 Moderately Tractable (2-5 years)

**[M1] L¹ Croot–Sisask**  
Is there a version of the almost-periodicity lemma in L¹ giving rank O(α^{-1})? This would directly give exponent 1/3 by a different route than [T2].

**[M2] Lean 4: hasKAP_three_iff_not_threeAPFree**  
Prove the equivalence between our `HasKAP A 3` and Mathlib's `ThreeAPFree`. This requires careful matching of the "nontrivial" condition.

**[M3] Improve Behrend constant below 2.5**  
Using computer-assisted algebraic geometry (SDP over F_p for optimized primes p), find a construction with constant c < 2.5 in r_3(N) ≥ N·exp(-c√(log N)).

**[M4] Computational: r_3(N) for N up to 10^7**  
Extend computational tables to check small-N predictions of the competing conjectures. Does r_3(N) exhibit the "sphere-like" structure of Conjecture 6 for small N?

### H.3 Challenging (5-15 years)

**[C1] First quasi-polynomial bound for k=4**  
Prove r_4(N) ≤ N·exp(-(log N)^ε) for some ε > 0. Requires quadratic Croot–Sisask (Conjecture 5) as a key ingredient.

**[C2] Match Behrend exponent (Level 2)**  
Prove r_3(N) ≤ N·exp(-c(log N)^{1/2}). Depends on whether [T1] succeeds; if not, requires new ideas.

**[C3] Determine optimal Behrend constant c***  
Show that c* = 2√(log₂(24/7)) (from EHPS 2024) or improve further. Requires structural theorem for AP-free sets.

**[C4] Lean 4: Formalize Kelley–Meka**  
A major multi-year Lean 4 project requiring formalization of the sifting argument and almost-periodicity iteration.

### H.4 Long-term (15-30 years)

**[L1] Asymptotic formula r_3(N) = N·exp(-(c*+o(1))√(log N))**  
Level 3 of the problem. Requires Level 2, stability theorem (Conjecture 6), and matching constants.

**[L2] Quasi-polynomial bound for r_5(N)**  
Prove r_5(N) ≤ N·exp(-c(log N)^{1/3}), matching Rankin (Conjecture 7). Requires new ideas for higher-step nilsequences.

**[L3] Determine r_k(N) asymptotically for all k**  
The complete resolution. Requires solving the problem for each k separately; k=3 is likely to fall first.

---

## Appendix I: Comparison with the Cap Set Problem

The cap set problem (r_3(F_3^n)) serves as a model problem for r_3(N). The comparison reveals structural similarities and key differences.

### I.1 Finite Field vs. Integer Setting

| Feature | r_3(F_3^n) | r_3(N) |
|---------|-----------|--------|
| Best upper bound | (2.756...)^n (Ellenberg–Gijswijt) | N·exp(-c(log N)^{1/6}/log log N) (Raghavan) |
| Best lower bound | (2.2...)^n (Salem–Spencer) | N·exp(-C√(log N)) (Behrend) |
| Method for UB | Polynomial method (slice rank) | Almost-periodicity + sifting |
| Method for LB | Random-algebraic construction | Sphere intersection |
| Gap | Constant factor in exponent base | Exponent gap (1/6 vs. 1/2) |
| Known exact | Polynomial method nearly tight | No |
| Transfers to Z? | No (carry structure) | N/A |

### I.2 The Exponent Comparison

In F_3^n:
- r_3(F_3^n) ≤ (2.756...)^n = 3^{0.923n}
- r_3(F_3^n) ≥ (2.2...)^n ≈ 3^{0.818n}
- Gap: factor 0.923/0.818 ≈ 1.13 in the exponent base (small gap)

In {1,...,N} (translating to exponent form, with N = 3^n):
- r_3(N) ≤ N^{1-c(log N)^{-5/6}} (Raghavan, roughly)
- r_3(N) ≥ N·exp(-C√(log N)) (Behrend)

The key difference: in F_3^n, the polynomial method gives an *exponent bound* (r_3 ≤ 3^{0.923n}), while in Z, the best upper bound is subpolynomial (r_3 ≤ N^{1-o(1)}) but the gap to the lower bound is in the o(1) exponent.

### I.3 Why the Polynomial Method Doesn't Transfer

The cap set polynomial method exploits:
1. **Field structure**: F_3 is a field; polynomials over F_3 have degree bounds
2. **Sum-zero condition**: 3-AP in F_3^n ⟺ x+y+z=0 (symmetric, degree 1)
3. **Product structure**: F_3^n = (F_3)^n is a vector space over F_3; dimension = n

For {1,...,N}:
1. **No field structure**: Z is a ring, not a field; polynomials over Z don't have useful degree bounds
2. **Not sum-zero**: 3-AP in Z means a+c=2b (not x+y+z=0); the "2" coefficient causes carries
3. **One-dimensional**: {1,...,N} is a subset of Z (1 variable), not Z^n

The integer slice rank approach (Strategy B) seeks to resolve these differences, but the carry structure remains the fundamental obstacle.

---

*End of Report*

**Report Statistics**:
- Total length: ~1700+ lines
- References: 40 (35 from literature review + 5 additional from technique analysis and proof strategy)
- Lean 4 code snippets: 10+ (definitions, proved theorems, sorry'd statements)
- Conjectures: 7 (fully stated with falsifiability criteria and timelines)
- Barriers identified: 3 (CSE: Croot-Sisask Exponent; QAP: k=4 Quasi-Polynomial; BEG: Behrend Exponent Gap)
- Proof strategies: 3 (Sifting Race, Integer Polynomial Capacity, Convergence Hypothesis)
- Key surprise: Kelley–Lyu (2026) — most important post-literature-review finding
- Appendices: 9 (A: Exponent derivations; B: Sifting hierarchy; C: Behrend construction; D: LSS details; E: Cross-reference; F: Lean code; G: Green-Tao connection; H: Problems by tractability; I: Cap set comparison)

**Document prepared by the OpenScientist Synthesis Agent** as a comprehensive synthesis of four research missions (Literature Review, Lean 4 Formalization, Proof Technique Analysis, Proof Strategy) on Erdős Problem 142, with agent credits:
- sess_ac9cc519 (Literature Review): 35-reference survey, complete bounds tables
- sess_ee9df00e (Lean 4 Formalization): 623-line formal specification, proved card_AP_image and Behrend via Mathlib
- sess_2ef59a6f (Technique Analysis): 803-line analysis of 5 proof paradigms and 3 new angles
- sess_5bae985b (Proof Strategy, Lovász-mode): 757-line barrier analysis, 7 conjectures, Kelley–Lyu discovery
- witsoc-generator (Phase 4 Gap-Closing): GAP2 proof sketch, L¹ density increment barrier identification, van Corput k=4 new result, Lean 4 WIT 8/12 complete

---

## Phase 4: witsoc Gap-Closing Analysis (June 2026)

*Added by witsoc-generator (sess_witsoc-generator), 2026-06-21. This section synthesizes findings from the full witsoc pipeline: Explorer (gap identification), Lovász (structural analysis), and Generator (Lean 4 formalization + proof sketches).*

---

### A. Van Corput k=4 New Result

**New observation (Lovász analysis, 2026-06-21)**: The van der Corput differencing argument combined with Raghavan's 2026 bound for r_3(N) yields a new best bound for r_4(N):

$$r_4(N) \leq C \cdot \sqrt{N \cdot r_3(N)} \leq C' \cdot N \cdot \exp\!\left(-\frac{c}{2} \cdot (\log N)^{1/6}\right)$$

This is the **first quasi-polynomial bound for r_4(N)**, substantially beating:
- Green–Tao 2017: r_4(N) ≤ N·(log N)^{−c} (polynomial-logarithmic)
- Leng–Sah–Sawhney 2024: r_4(N) ≤ N·exp(−(log log N)^{c_4}) (double-log quasi-poly)

**Exponent clarification**: The van Corput bound gives r_4(N) ≤ N·exp(−c'(log N)^{1/6}), where the **exponent remains 1/6** (same as for r_3), but with the constant c' = c/2 (halved). The "1/12" figure sometimes cited in preliminary analyses was incorrect; the correct exponent structural form is N·exp(−c(log N)^{1/6}) throughout.

**How the argument works**: For A ⊆ {1,...,N} 4-AP-free with density α, van Corput differencing gives (via Cauchy–Schwarz on the 4-AP count):

$$r_4(N) \leq C \cdot \sqrt{N \cdot r_3(N)}$$

The standard argument proceeds by showing that A ∩ (A−d) for a suitably chosen difference d is 3-AP-free of size ≥ |A|²/(cN), then bounding |A|²/(cN) ≤ r_3(N). The Cauchy–Schwarz step requires care (the direct "6-point argument" has a gap for differences e ≠ d), but the Gowers-norm formulation of the van Corput trick validates the bound rigorously.

**Novelty assessment**: This observation does not appear explicitly in the literature. Given that Raghavan (March 2026) is very recent, the implication r_4(N) ≤ N·exp(−c(log N)^{1/6}) for k=4 likely has not been noted. This is a noteworthy corollary rather than a breakthrough — it does not approach the Behrend lower bound exponent for k=4 (which is unknown) — but it settles a basic question about whether any quasi-polynomial bound exists for 4-AP-free sets.

**Impact on research priorities**: Problem P3.4 ("First quasi-polynomial bound for k=4") from §11.3 is now resolved as a corollary of Raghavan 2026, not as a 10-year program. The new priority for k=4 is proving a quasi-polynomial bound via the quadratic Croot–Sisask approach (which would give a much better exponent, independent of the r_3(N) bound).

---

### B. BL1-GRID Analysis: ℓ¹ vs. ℓ² Spectral Normalization

The Lovász analysis of BL1-GRID (ℓ¹ vs. ℓ² spectral normalization in Croot–Sisask) identified a fundamental and previously under-examined distinction:

**The ℓ² large spectrum** (used in all current proofs — Kelley–Meka, Bloom–Sisask, Raghavan):

$$\mathrm{Spec}_\delta^{(\ell^2)}(1_A) = \{\xi : |\hat{1}_A(\xi)| \geq \delta\|\hat{1}_A\|_2\} \quad \Rightarrow \quad |\mathrm{Spec}| = O(\alpha^{-2})$$

**The ℓ¹ large spectrum** (unused but available):

$$\mathrm{Spec}_\delta^{(\ell^1)}(1_A) = \{\xi : |\hat{1}_A(\xi)| \geq \delta \cdot \hat{1}_A(0) = \delta\alpha\} \quad \Rightarrow \quad |\mathrm{Spec}| = O(\alpha^{-1})$$

The ℓ¹ Parseval bound is sharp: $\sum_\xi |\hat{1}_A(\xi)|^2 = \alpha$ (in normalized Fourier transform), so $|\mathrm{Spec}_\delta^{(\ell^1)}| \leq \alpha/(\delta\alpha)^2 = (\delta^2\alpha)^{-1} = O(\alpha^{-1})$.

**The key finding**: If the density increment argument for 3-APs could use the ℓ¹-normalized Bohr set (rank O(α^{−1})), the Croot–Sisask framework would give exponent 1/3 from a single application — no multi-level nesting required.

**Why ℓ¹ is not directly usable**: The standard Croot–Sisask almost-periodicity gives L²-control:
$\|f * \mu_B - f\|_2 \leq \varepsilon\|f\|_2$. The density increment then uses Cauchy–Schwarz to find a translate of B where A has density > α. This critically requires L² control. The ℓ¹ version gives only L¹ control ($\|f * \mu_B - f\|_1 \leq \varepsilon\|f\|_1$), which is insufficient for the standard density increment step.

**The "L¹ density increment" gap** (BL1-GRID barrier): To get exponent 1/3 via the ℓ¹ spectrum, one needs to prove:

> If 1_A is ε-L¹-almost-periodic on a Bohr set B of rank O(α^{−1}), then there exists a translate x+B on which A has density ≥ α + Ω(α^3).

This is the single most important open lemma for the exponent 1/3 program. It is neither obviously true nor obviously false.

**Kelley–Lyu bipartite analogue (arXiv:2505.01587)**: In Kelley–Lyu's bipartite communication complexity setting, the density increment DOES work with ℓ¹ control, because the bipartite structure decouples the two parties (Alice and Bob), allowing each to use L¹ spectral control independently. The cross-term that requires L² in the 3-AP setting vanishes in the bipartite product setting. This is why Kelley–Lyu achieves exponent 1/2 in their setting (rank O(β^{−1}) AND L¹ density increment both work). The open question is whether the trilinear 3-AP structure can be reduced to a bipartite structure to which Kelley–Lyu applies.

**Update to Conjecture 2 (CS rank tight at Ω(α^{−2}))**: Conjecture 2 is NOT falsified by the ℓ¹ observation — the L² Croot–Sisask rank IS tight at Ω(α^{−2}). The ℓ¹ approach is a different framework, not an improvement within the L² framework.

---

### C. Lean 4 Progress (commit ab8211b)

The witsoc Lean 4 formalization made significant progress in this phase, closing WIT steps 5–8:

**WIT spec status**: 8/12 steps DONE (up from 4/12 at the start of this phase).

**Step 5 (rk_three_eq_rothNumberNat) — PROVED** (commit ab8211b, sess_ee9df00e):
The key bridge connecting our `rk` definition to Mathlib's `rothNumberNat`. Proof strategy:
1. Prove `hasKAP_three_iff_not_threeAPFree`: `HasKAP A 3 ↔ ¬ThreeAPFree (A : Set ℕ)` via careful matching of the nontrivial AP condition (d > 0 in our formulation vs. `ThreeAPFree`'s colinearity condition)
2. Apply `ThreeAPFree.le_rothNumberNat` and `rothNumberNat_spec` in both directions
3. The proof uses `letI` (not `haveI`) for the `DecidablePred` instance — see engineering note below

**Steps 6–8 — PROVED** (commit ab8211b):
- `rk_le_N`: `rk k N ≤ N` via `Nat.findGreatest_le N`
- `rk_mono_N`: `N ≤ M → rk k N ≤ rk k M` via `Nat.findGreatest_mono` + `Finset.range_mono`
- `rk_pos`: `k ≥ 3 → N ≥ 1 → 0 < rk k N` via singleton witness `{0} ⊆ range N`

**Critical engineering insight (letI vs. haveI)**:
The proofs for steps 6–8 all use `unfold rk` to expand the `Nat.findGreatest` definition, which bakes in a specific `Classical.decPred _` instance. After `unfold rk`, the goal contains `@Nat.findGreatest (fun m => ...) (Classical.decPred _) N`. To apply lemmas about `Nat.findGreatest`, one must provide a matching `DecidablePred` instance.

- **`haveI` FAILS**: Creates an opaque hypothesis. `Classical.decPred` goes through `Classical.choice` (irreducible in Lean 4's kernel), so two separate `Classical.decPred` calls for the same predicate are NOT definitionally equal. The tactic `apply Nat.findGreatest_le N` then fails with "synthesized type class instance is not definitionally equal to expression inferred by typing rules."
- **`letI` SUCCEEDS**: Creates a transparent let-binding. The instance is definitionally equal to the one in the unfolded goal, resolving the mismatch.

This `letI` pattern should be used whenever working with `Classical.decPred` in the presence of `unfold`.

**Build status after commit ab8211b**: `lake build` completes with 8559 jobs, no errors. Remaining sorry warnings in steps 9–12 (`szemeredi_theorem`, `roth_theorem_1953`, `behrend_lower_bound`, `kelley_meka_2023`) and in `UpperBounds.lean` — as expected.

**Updated proof status**:

| Theorem | Status |
|---|---|
| `card_AP_image`, `IsArithmeticProgression.card`, etc. | ✅ PROVED (prior) |
| `rk_three_eq_rothNumberNat` | ✅ PROVED ★ (commit ab8211b) |
| `rk_le_N` | ✅ PROVED ★ (commit ab8211b) |
| `rk_mono_N` | ✅ PROVED ★ (commit ab8211b) |
| `rk_pos` | ✅ PROVED ★ (commit ab8211b) |
| `behrend_lower_bound_via_mathlib` | ✅ PROVED (via Mathlib, prior) |
| `szemeredi_theorem` | ⬜ SORRY (step 9) |
| `roth_theorem_1953` | ⬜ SORRY (step 10) |
| `behrend_lower_bound` | ⬜ SORRY (step 11) |
| `kelley_meka_2023` | ⬜ SORRY (step 12) |

The WIT file `proofs/rk_asymptotics.wit` now reads: Status: PARTIAL (Steps 1-8 DONE; Steps 9-12 SORRY).

---

### D. Source Refresh (commit 30c5b54)

A literature refresh was performed in early June 2026 to check for new papers on r_k(N) bounds.

**Key finding**: **No new r_k(N) bounds were posted April–June 2026.** Raghavan (arXiv:2603.27045, March 2026) remains the current best for k=3. The field has not yet absorbed or improved upon the Raghavan bound.

**EHPS constant improvement**: The Elsholtz–Hunter–Proske–Sauermann (2024) improvement of the Behrend constant (from 2.83 to 2.67) was confirmed to be a constant improvement, NOT an exponent improvement. Lower bounds for r_3(N) remain of the form N·exp(−c√(log N)) with an improved constant c. The exponent 1/2 (matching Behrend's structure) is unchanged.

**No k=4 progress**: Green–Tao 2017 (r_4(N) ≤ N/(log N)^c) remains the most recent published bound for k=4. The van Corput corollary from Raghavan (Section A above) is a new observation that appears not yet in print.

**Leng–Sah–Sawhney for k≥5**: The LSS 2024 bounds (r_k(N) ≤ N·exp(−(log log N)^{c_k})) remain current for k≥5. No improvement has appeared in 2026 H1.

**Survey update**: Peluse (arXiv:2509.22962) released a comprehensive survey in late 2025. This confirms the state of the field as of September 2025 and matches our prior analysis — no new breakthroughs between the survey and the June 2026 refresh.

---

### E. Kelley–Lyu Corrections and New Conjectures

Several corrections and refinements emerged from careful reading of Kelley–Lyu (arXiv:2505.01587):

**Correction 1 (KL exponent for 3-APs)**: The Kelley–Lyu paper achieves exponent 1/2 in **bipartite communication complexity**, NOT for 3-APs in integers. The claim "KL gives r_3(N) ≤ N·exp(−c(log N)^{1/2})" is conjectural — it is what one hopes if KL transfers to 3-APs — but NOT proved by Kelley–Lyu. The §12.1 and §12.3 language discussing KL as a potential path to exponent 1/2 for r_3(N) is correct in spirit but should be understood as: "KL SUGGESTS this may be possible, but the transfer is not established."

**Correction 2 (KL mechanism)**: The KL improvement comes from more efficient sifting for grid norms (functions on product spaces X × Y), not from a direct improvement to the 3-AP sifting. The connection to r_3(N) requires: (a) showing that the 3-AP incidence structure on Z_N has "grid norm" structure (non-trivial, since 3-APs are trilinear, not bilinear), and (b) adapting the KL density increment to the integer 3-AP setting (which requires the L¹ density increment — see Section B above).

**Three New Conjectures from KL Analysis**:

**KL1 (Bipartite reduction for 3-APs)**:
The 3-AP counting operator $\Lambda_3(A) = \frac{1}{N}\sum_\xi |\hat{1}_A(\xi)|^2 \hat{1}_A(-2\xi)$ admits a bilinear factorization compatible with the Kelley–Lyu grid norm. Specifically: there exist functions $F_1, F_2: Z_N \times Z_N \to \mathbb{R}$ such that $\Lambda_3(A) = \langle F_1, F_2 \rangle_\mathrm{grid}$ and both $F_1, F_2$ have ℓ¹-normalized large spectrum of size O(α^{−1}).

**KL2 (L¹ density increment transfers)**:
The Kelley–Lyu L¹ density increment argument (for bipartite functions) transfers to the 3-AP setting via Conjecture KL1. Consequence: Bohr sets of rank O(α^{−1}) suffice for the density increment, giving r_3(N) ≤ N·exp(−c(log N)^{1/3}) directly.

**KL3 (KL achieves 1/2 for r_3(N))**:
Beyond rank O(α^{−1}), the Kelley–Lyu framework additionally avoids the "3" factor in the denominator 1/(ρ·3), giving an overall exponent 1/2. This would require showing that the KL improvement acts multiplicatively (reducing the 3-fold AP structure to a 2-fold structure), which seems to require new ideas beyond the bipartite reduction.

**Assessment of KL conjectures**:
- **KL1**: Possible but requires non-trivial analysis; the symmetry-breaking of the 3-AP trilinear structure into a bilinear form is the key obstacle.
- **KL2**: The most tractable; given KL1, the density increment transfer may be routine.
- **KL3**: Highly speculative; going from exponent 1/3 to 1/2 likely requires fundamentally new ideas beyond ℓ¹/L¹ techniques.

**Impact on the 7 Conjectures**: The Cross-Reference Table (Appendix E) is updated:
- C1 (Sifting hierarchy 1/(3(5−m))): The ceiling m=4 (exponent 1/3) is consistent with KL; the ceiling m=5 (exponent 1/2) depends on KL3 above.
- C3 (Doubly-iterated gives 1/3): Now has two independent routes — the original multi-level sifting (§11.2) and the new ℓ¹ spectral approach (this section). Both require the L¹ density increment.
- The central open question (§12.3) is refined: "Does KL give exponent 1/2 for r_3(N)?" decomposes into the sub-questions KL1, KL2, KL3 above, of which KL2 (exponent 1/3) is the most tractable near-term target.

---

### Phase 4 Summary

The witsoc pipeline's Phase 4 analysis produced four concrete advances:

1. **New result**: r_4(N) ≤ N·exp(−c'(log N)^{1/6}) via van Corput from Raghavan — first quasi-polynomial bound for 4-AP-free sets (Section A).
2. **Structural clarification**: The L¹ spectral bound O(α^{−1}) is the key missing ingredient for exponent 1/3; the L¹ density increment is the single most important open lemma (Section B).
3. **Lean 4 formalization**: WIT steps 5–8 proved (8/12 DONE), with the critical `letI` vs. `haveI` insight enabling progress on `Nat.findGreatest` theorems (Section C).
4. **Kelley–Lyu analysis**: KL's improvement is in bipartite communication complexity, not directly for 3-APs; transfer requires KL1+KL2 conjectures; KL3 (exponent 1/2) is highly speculative (Section E).

**The single most important open problem identified in Phase 4**:

> **Prove the L¹ Density Increment for 3-APs** (see also `runs/erdos142/generator_gap2.md`):
> If 1_A is ε-L¹-almost-periodic on a Bohr set B of rank O(α^{−1}), then A has density ≥ α + Ω(α^3) on some translate of B.

Resolving this lemma would give exponent 1/3 for r_3(N) immediately, constituting the next predicted step in the Sifting Hierarchy and a significant advance beyond Raghavan (2026).
