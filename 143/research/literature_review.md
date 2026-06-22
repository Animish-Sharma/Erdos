# Literature Review: Bounds for r_k(N) — Sets with No k-Term Arithmetic Progressions

> **Date:** 2026-06-21  
> **Author:** OpenScientist Scout Agent  
> **Topic:** Maximum size of subsets of {1,...,N} containing no nontrivial k-term arithmetic progression (k-AP)

---

## Table of Contents

1. [Definitions and Setup](#1-definitions-and-setup)
2. [k = 3: Three-Term Arithmetic Progressions](#2-k--3-three-term-arithmetic-progressions)
   - [Upper Bounds (History)](#upper-bounds-history-k3)
   - [Lower Bounds](#lower-bounds-k3)
   - [Summary Table](#summary-table-k3)
3. [k = 4: Four-Term Arithmetic Progressions](#3-k--4-four-term-arithmetic-progressions)
   - [Upper Bounds](#upper-bounds-k4)
   - [Lower Bounds](#lower-bounds-k4)
   - [Summary Table](#summary-table-k4)
4. [k ≥ 5: General Longer Progressions](#4-k--5-general-longer-progressions)
   - [Upper Bounds](#upper-bounds-k5)
   - [Lower Bounds](#lower-bounds-k5)
   - [Summary Table](#summary-table-k5)
5. [Szemerédi's Theorem and Quantitative Versions](#5-szemer%C3%A9dis-theorem-and-quantitative-versions)
6. [Key Methods and Techniques](#6-key-methods-and-techniques)
7. [The Gap Problem](#7-the-gap-problem)
8. [Conjectures About True Asymptotics](#8-conjectures-about-true-asymptotics)
9. [Complete Reference List](#9-complete-reference-list)

---

## 1. Definitions and Setup

**Definition.** Let r_k(N) denote the **maximum** cardinality of a subset A ⊆ {1, ..., N} containing no nontrivial k-term arithmetic progression (k-AP), i.e., no sequence x, x+d, x+2d, ..., x+(k-1)d with d ≠ 0.

**Alternative notation:** r(k, N), R_k(N), or D(k, N). The notation r_k(N) is now standard.

**Context:** The Erdős–Turán conjecture (1936) asserted that r_k(N) = o(N) for every fixed k ≥ 3. This was proved by Szemerédi (1975). The central open problem is to determine the **true rate of decay** of r_k(N)/N as N → ∞.

**Finite field analogue:** Much progress has also been made in the model setting F_q^n. Many techniques (especially the polynomial method) were first developed or tested in this setting. Results for F_q^n are closely analogous but sometimes admit stronger bounds.

---

## 2. k = 3: Three-Term Arithmetic Progressions

The k = 3 case (finding the largest 3-AP-free subset of {1,...,N}) is the most thoroughly studied, and has seen the most dramatic recent progress.

### Upper Bounds: History (k=3)

#### Roth (1953) — First Quantitative Bound

**Statement:** r_3(N) = O(N / log log N).

**Method:** Fourier/circle method ("Hardy–Littlewood method"). Roth expressed the count of 3-APs in A as a convolution of Fourier coefficients and used an **L^2 energy argument** (Parseval's identity). If A has density α = |A|/N and contains no nontrivial 3-APs, then the "balanced function" f_A = 1_A - α must have a **large Fourier coefficient** (size ≥ α²). This yields a density increment on a long subprogression, and iterating gives the bound.

**Reference:** K. F. Roth, "On certain sets of integers," J. London Math. Soc. 28 (1953), 104–109.

---

#### Heath-Brown (1987) and Szemerédi (1990) — Power of Logarithm

**Statement:** r_3(N) = O(N / (log N)^c) for some absolute constant c > 0.

Szemerédi obtained c = 1/4 explicitly.

**Method:** Both improved Roth's argument by **collecting many large Fourier coefficients** simultaneously. Once a large Fourier coefficient exists, one can use simultaneous Diophantine approximation (specifically, a generalization of Weyl's inequalities or Bogolyubov-type ideas) to partition [N] into long arithmetic progressions, then find a subprogression where A has a density increment. The key innovation: rather than using a single large frequency, they exploit the structure of the full set of "large" frequencies.

**References:**  
- D. R. Heath-Brown, "Integer sets containing no arithmetic progressions," J. London Math. Soc. (2) 35 (1987), 385–394. (Available at [cs.umd.edu](https://www.cs.umd.edu/~gasarch/TOPICS/vdw/heathbrown.pdf))  
- E. Szemerédi, "Integer sets containing no arithmetic progressions," Acta Math. Hungar. 56 (1990), 155–158.

---

#### Bourgain (1999) — Bohr Sets

**Statement:** r_3(N) ≤ C · N · (log log N / log N)^{1/2}.

**Method:** Bourgain introduced the use of **regular Bohr sets** in the study of arithmetic progressions. Rather than working with ordinary arithmetic progressions, he structured the density increment around Bohr sets (approximate subgroups of Z/NZ), allowing more efficient use of the large Fourier coefficient. The exponent 1/2 reflected the structure of the Bohr set geometry.

**Reference:** J. Bourgain, "On triples in arithmetic progression," Geom. Funct. Anal. 9 (1999), no. 5, 968–984.

---

#### Bourgain (2008) — Refined Bohr Set Argument

**Statement:** r_3(N) ≤ C · N · ((log log N)² / log N)^{2/3}.

**Method:** Bourgain refined his own 1999 approach. By carrying out the scheme more efficiently within Bohr sets, he improved the exponent from 1/2 to 2/3. This involved more careful bookkeeping in the density increment and exploitation of the geometry of regular Bohr sets.

**Reference:** J. Bourgain, "Roth's theorem on progressions revisited," J. Anal. Math. 104 (2008), 155–192.

---

#### Sanders (2011) — Almost Periodicity; Breaking log^{3/4}

**Statement:** r_3(N) = O(N · (log log N)^6 / log N).

This was the **first bound approaching O(N/log N)** and the first to break the "3/4 power" barrier of the previous bounds.

**Method:** Sanders used the **Croot–Sisask almost periodicity lemma** (2010), a powerful tool that works in "physical space" rather than Fourier space. The key idea: if A has density α, then the convolution 1_A * 1_A is "almost periodic" on a large Bohr set. This gives a much more efficient density increment argument than classical Fourier methods. The approach bypassed certain recurring difficulties in purely Fourier-analytic proofs.

**Reference:** T. Sanders, "On Roth's theorem on progressions," Ann. of Math. 174 (2011), no. 1, 619–636. arXiv:1011.0104. DOI: 10.4007/annals.2011.174.1.20.

---

#### Bloom (2016) — Further Improvement; (log log N)^4

**Statement:** r_3(N) = O(N · (log log N)^4 / log N).

**Method:** Tom Bloom further refined the almost periodicity approach of Sanders/Croot–Sisask, reducing the power of log log N in the numerator from 6 to 4. By more careful use of the almost periodicity lemma and a tighter analysis of the density increment, Bloom obtained a quantitative improvement. This paper also improved bounds in the analogous problem over F_q[t].

**Reference:** T. F. Bloom, "A quantitative improvement for Roth's theorem on arithmetic progressions," J. London Math. Soc. 93 (2016), no. 3, 643–663. arXiv:1405.5800. DOI: 10.1112/jlms/jdw010.

---

#### Bloom–Sisask (2020) — **Breaking the Logarithmic Barrier**

**Statement:** r_3(N) = O(N / (log N)^{1+c}) for some absolute constant c > 0.

This was the first bound to go **beyond N/(log N)**, proving that r_3(N) ≪ N/(log N)^{1+c} for some c > 0. It established the first nontrivial case of a conjecture of Erdős.

**Method:** Bloom and Sisask combined the almost periodicity framework with a refined **density increment on Bohr sets**, incorporating a more careful induction. Their key innovation was showing that the density increment on a subprogression can be made "multiplicative" rather than additive: instead of the density increasing by a fixed amount, it is multiplied by a factor (1 + cα^D) at each step for suitable D. This multiplicative feature leads to far better bounds.

**Reference:** T. F. Bloom and O. Sisask, "Breaking the logarithmic barrier in Roth's theorem on arithmetic progressions," arXiv:2007.03528 (2020). (To appear in Ann. Math.)

---

#### Kelley–Meka (2023) — **MAJOR BREAKTHROUGH: Quasi-Polynomial Bound**

**Statement:** r_3(N) ≤ N · exp(-c (log N)^{1/12}) for some absolute constant c > 0.

**This is currently the best upper bound for r_3(N).** It represents a dramatic improvement: the density decays quasi-polynomially (as exp(-polylog(N))) rather than the previous polynomial-in-log(N) bound.

**Method:** Kelley and Meka introduced a completely new approach combining:
1. **Sifting/sunflower argument:** A refined density increment over Bohr sets using a "sifting" procedure that iteratively removes structure.
2. **Improved Croot–Sisask almost periodicity:** A bootstrapping argument that gives near-polynomial (in density) bounds on the almost periodicity threshold.
3. **Bohr set machinery:** The density increment is done over structured Bohr sets, allowing for a compound iteration.

The key new idea is a "sifting" of frequencies combined with a more efficient use of the Bohr set geometry, which yields an exponential improvement in the number of iterations possible before the density exceeds 1.

**Reference:** Z. Kelley and R. Meka, "Strong Bounds for 3-Progressions," arXiv:2302.05537 (2023, updated 2024). Published version to appear. DOI announced.

**Exposition:** T. F. Bloom and O. Sisask, "The Kelley–Meka bounds for sets free of three-term arithmetic progressions," arXiv:2302.07211 (2023, updated 2025). (This gives a self-contained exposition of the Kelley–Meka result, also proving the 1/12 exponent with some simplifications.)

---

#### Bloom–Sisask (2023) — Improvement to Exponent 1/9

**Statement:** r_3(N) ≤ N · exp(-c (log N)^{1/9}) for some c > 0.

**Method:** A "simple modification" of the Kelley–Meka method improves the exponent from 1/12 to 1/9. The paper notes that a more elaborate version of the idea could give 5/41, but 1/9 is presented as the clean version.

**Reference:** T. F. Bloom and O. Sisask, "An improvement to the Kelley–Meka bounds on three-term arithmetic progressions," arXiv:2309.02353 (2023).

---

#### Raghavan (2026) — Further Improvement to Exponent 1/6

**Statement:** r_3(N) ≤ N · exp(-c (log N)^{1/6} / log log N) for some absolute constant c > 0.

**Status:** **Current best upper bound for r_3(N)** (as of June 2026).

**Method:** Uses an iterated variant of the sifting argument of Kelley–Meka, combined with Bloom–Sisask's improved bootstrapping for Croot–Sisask almost periodicity.

**Reference:** R. Raghavan, "Improved Bounds for 3-Progressions," arXiv:2603.27045 (2026, updated May 2026).

---

#### Kelley–Lyu (2025) — Grid Norm Sifting and the Conjectured 1/2 Exponent

**Scope:** Not an r_3(N) bound paper directly. Kelley and Lyu prove efficient sifting bounds for functions on bipartite graphs ("grid norms") with applications to multiparty communication complexity.

**Statement (informal):** For functions on bipartite graphs of bipartite density β, a density increment of Ω(β²) is achievable using ℓ¹-spectral sifting with rank O(β⁻¹) (Kelley–Lyu 2025, Theorem 1.1). This matches the structure of a conjectured 3-AP density increment (L3-AP-INCR).

**Relevance to r_3(N):** The 3-AP count formula Λ₃(A) = N⁻¹ Σ_ξ |Â(ξ)|² Â(–2ξ) has a bilinear factor |Â(ξ)|², which is analogous to the bipartite setting. If the Kelley–Lyu ℓ¹-sifting can be transferred to the 3-AP setting (trilinear rather than bilinear), it would yield a density increment of Ω(α²) with rank O(α⁻¹), giving r_3(N) ≤ N · exp(–c(log N)^{1/2}), which would match the Behrend lower bound exponent and represent a qualitative breakthrough. This connection is captured in Open Problem P4 of the companion paper.

**Current status:** Transfer is open. The trilinear (vs. bilinear) structure of 3-APs is the primary obstacle. Conjecture L3-AP-INCR is the precise statement needed.

**Reference:** Z. Kelley and X. Lyu, "More efficient sifting for grid norms, and applications to multiparty communication complexity," arXiv:2505.01587 (2025, revised June 2026).

---

### Lower Bounds (k=3)

#### Salem–Spencer (1942)

**Statement:** r_3(N) ≥ N^{1 - c/log log N} for some absolute constant c > 0.

**Construction:** A relatively elementary digit-based construction. While this shows r_3(N) grows faster than any fixed power N^{1-ε}, it is weaker than Behrend's result by a nearly-polynomial factor.

**Reference:** R. Salem and D. C. Spencer, "On sets of integers which contain no three terms in arithmetical progression," Proc. Nat. Acad. Sci. 28 (1942), 561–563.

---

#### Behrend (1946) — **Best Known Lower Bound for k=3**

**Statement:** r_3(N) ≥ N · exp(-C √(log N)) for some absolute constant C > 0.

More explicitly, Behrend showed there exists A ⊆ {1,...,N} with no 3-AP and |A| = Ω(N / (2^{2√2 √(log₂ N)} · log^{1/4} N)).

**Construction:** The key idea is to intersect {0,...,t-1}^n with a sphere {x : Σx_i² = m} for suitably chosen parameters. Because the sphere is a strictly convex set, no three elements on a sphere form a 3-AP in Z^n (as the midpoint of two distinct sphere points lies strictly inside the sphere). Choosing t, n, m optimally (with N = t^n) gives the bound.

**Significance:** This construction has stood as the best known lower bound for 78 years (1946–2024). The "Behrend gap" — the difference between this lower bound and the best upper bounds — has been a central open problem.

**Reference:** F. A. Behrend, "On sets of integers which contain no three terms in arithmetic progression," Proc. Nat. Acad. Sci. 32 (1946), 331–332.

---

#### Elkin (2008) / Green–Wolf (2010) — Minor Improvements

**Statement:** r_3(N) ≥ N · exp(-C √(log N)) · √(log N / log log N) (up to constants).

These are improvements of Behrend by lower-order factors (a √(log N)/√(π) gain). The core structure is the same spherical construction.

**References:**  
- M. Elkin, "An improved construction of progression-free sets," Israel J. Math. 184 (2011), 93–128.  
- B. Green and J. Wolf, "A note on Elkin's improvement of Behrend's construction," Additive Combinatorics, CRM Proceedings, 2010. arXiv:0810.0732.

---

#### Elsholtz–Hunter–Proske–Sauermann (2024) — **First Quasipolynomial Improvement of Behrend**

**Statement:** r_3(N) ≥ N · exp(-C (log N)^{1-ε}) for some ε > 0. (i.e., a genuine quasipolynomial improvement over Behrend, not just a lower-order factor.)

**Significance:** This is the **first improvement beyond lower-order factors since Behrend (1946)**. It represents a genuine qualitative advance in the construction of 3-AP-free sets.

**Reference:** C. Elsholtz, Z. Hunter, L. Proske, and L. Sauermann, "Improving Behrend's construction: Sets without arithmetic progressions in integers and over finite fields," arXiv:2406.12290 (2024).

---

#### Hunter (2024) — Further Lower Bound Improvements

**Statement:** Further development of the Elsholtz–Hunter–Proske–Sauermann ideas, giving the first quasipolynomial improvement in {1,...,N}.

**Reference:** Z. Hunter, "New lower bounds for r_3(N)," arXiv:2401.16106 (2024).

---

### Summary Table (k=3)

| Year | Author(s) | Upper Bound on r_3(N) | Method |
|------|-----------|----------------------|--------|
| 1942 | Salem–Spencer | ≥ N^{1-c/log log N} (LOWER) | Digit construction |
| 1946 | Behrend | ≥ N·exp(-C√(log N)) (LOWER) | Sphere construction |
| 1953 | Roth | O(N / log log N) | Fourier / circle method |
| 1987 | Heath-Brown | O(N / (log N)^c) | Many large frequencies |
| 1990 | Szemerédi | O(N / (log N)^{1/4}) | As above, explicit c=1/4 |
| 1999 | Bourgain | O(N (log log N/log N)^{1/2}) | Bohr sets |
| 2008 | Bourgain | O(N ((log log N)²/log N)^{2/3}) | Refined Bohr sets |
| 2011 | Sanders | O(N (log log N)^6 / log N) | Croot–Sisask almost periodicity |
| 2016 | Bloom | O(N (log log N)^4 / log N) | Refined almost periodicity |
| 2020 | Bloom–Sisask | O(N / (log N)^{1+c}) | Multiplicative density increment |
| 2023 | Kelley–Meka | N · exp(-c (log N)^{1/12}) | Sifting + Bohr set bootstrapping |
| 2023 | Bloom–Sisask | N · exp(-c (log N)^{1/9}) | Modified Kelley–Meka |
| 2024 | Elsholtz–Hunter–Proske–Sauermann | ≥ N · exp(-C(log N)^{1-ε}) (LOWER) | Improved sphere construction |
| **2026** | **Raghavan** | **N · exp(-c (log N)^{1/6} / log log N)** | Iterated sifting + bootstrapping |

> **Best current upper bound (k=3):** r_3(N) ≤ N · exp(-c (log N)^{1/6} / log log N)  [Raghavan, 2026]  
> **Best current lower bound (k=3):** r_3(N) ≥ N · exp(-C (log N)^{1-ε})  [Elsholtz–Hunter–Proske–Sauermann, 2024; building on Behrend 1946]

---

## 3. k = 4: Four-Term Arithmetic Progressions

### Upper Bounds (k=4)

#### Szemerédi (1969) — Qualitative

Szemerédi proved the k = 4 case of the Erdős–Turán conjecture: r_4(N) = o(N). This used a combinatorial argument specific to k = 4.

**Reference:** E. Szemerédi, "On sets of integers containing no four elements in arithmetic progression," Acta Math. Acad. Sci. Hungar. 20 (1969), 89–104.

---

#### Gowers (1998) — First Quantitative Bound for k=4

**Statement:** r_4(N) = O(N / (log log N)^c) for some explicit c > 0.

**Method:** Gowers recognized that Fourier analysis is **not the right tool** for 4-APs (since correlations with linear phases do not capture 4-AP structure). He introduced the **Gowers U³ norm** (a higher-order Fourier norm) and proved an inverse theorem for it in a "local" (Bohr set) setting. The key dichotomy: if A has no 4-APs, either the Gowers U³ norm of 1_A - α is small (which yields a density increment via a polynomial phase) or we can partition [N] into long APs on which A has a significant density increment. The argument is technically very involved.

**Reference:** W. T. Gowers, "A new proof of Szemerédi's theorem for arithmetic progressions of length four," Geom. Funct. Anal. 8 (1998), no. 3, 529–551.

---

#### Green–Tao (2005) — Exponential Improvement

**Statement:** r_4(N) = O(N · exp(-c √(log log N))) for some absolute constant c > 0.

**Method:** Green and Tao refined Gowers' argument, exploiting the structure of "quadratic" Bohr sets and the theory of Weyl sums. This represented a significant qualitative improvement over Gowers' polylogarithmic bound.

**Reference:** B. Green and T. Tao, "New bounds for Szemerédi's theorem, II: A new bound for r_4(N)," math/0610604.

---

#### Green–Tao (2017) — **Polylogarithmic Bound; Best Known for k=4**

**Statement:** r_4(N) = O(N / (log N)^c) for some absolute constant c > 0.

**Status:** This is **currently the best upper bound for r_4(N)**.

**Method:** Green and Tao exploited a special **positivity property** of the count of 4-APs weighted by "pure quadratic" objects (essentially related to the Bergelson–Host–Kra structure theorem in ergodic theory). This positivity allows for a more efficient density increment argument tailored to 4-APs. The approach does not generalize to k ≥ 5, which is why k ≥ 5 required different methods (Gowers norms + inverse theorem machinery).

**Reference:** B. Green and T. Tao, "New bounds for Szemerédi's theorem, III: A polylogarithmic bound for r_4(N)," Mathematika 63 (2017), no. 3, 944–1040. arXiv:1705.01703. DOI: 10.1112/S0025579317000316.

> **Note:** The Kelley–Meka and Leng–Sah–Sawhney breakthroughs of 2023–2024 do NOT improve the bound for k = 4. The Green–Tao 2017 polylogarithmic bound remains the state of the art for k = 4, as of June 2026. An analog of Kelley–Meka for k = 4 would require a completely new approach.

---

### Lower Bounds (k=4)

- **Behrend (1946):** Any 3-AP-free set is automatically k-AP-free for all k ≥ 3. Thus r_4(N) ≥ r_3(N) ≥ N · exp(-C √(log N)).
- **Rankin (1961):** Gives the same or better lower bound for k = 4 using the same sphere construction (the exponent 1/⌈log₂ k⌉ = 1/2 for k=4 matches Behrend). So Behrend remains the best construction for k = 4 as well.

**Best current lower bound (k=4):** r_4(N) ≥ N · exp(-C √(log N))  [Behrend/Rankin]

### Summary Table (k=4)

| Year | Author(s) | Bound | Method |
|------|-----------|-------|--------|
| 1946 | Behrend | ≥ N·exp(-C√(log N)) (LOWER) | Sphere construction |
| 1969 | Szemerédi | r_4(N) = o(N) (qualitative) | Combinatorial argument |
| 1998 | Gowers | O(N / (log log N)^c) | U³ norm, local inverse theorem |
| 2005 | Green–Tao | O(N · exp(-c√(log log N))) | Quadratic Bohr sets |
| **2017** | **Green–Tao** | **O(N / (log N)^c)** | **Quadratic positivity trick** |

> **Best current upper bound (k=4):** r_4(N) ≤ C · N / (log N)^c  [Green–Tao, 2017]  
> **Best current lower bound (k=4):** r_4(N) ≥ N · exp(-C √(log N))  [Behrend, 1946]

**Major open problem:** Can a Kelley–Meka-type quasi-polynomial bound be proved for r_4(N)?

---

## 4. k ≥ 5: General Longer Progressions

### Upper Bounds (k≥5)

#### Szemerédi (1975) — Qualitative Theorem

**Statement (Szemerédi's Theorem):** For every fixed integer k ≥ 3, r_k(N) = o(N) as N → ∞.

This resolved the Erdős–Turán conjecture in full generality. Szemerédi's argument was a remarkable and complex purely combinatorial proof, which also introduced the **Szemerédi regularity lemma** for graphs as a key tool.

**Quantitative bounds from Szemerédi's proof** (for k = 3): The regularity lemma approach gives only tower-type bounds (log* N), far weaker than Roth's bound.

**Reference:** E. Szemerédi, "On sets of integers containing no k elements in arithmetic progression," Acta Arith. 27 (1975), 199–245.

---

#### Gowers (2001) — First Quantitative Bound for All k ≥ 4

**Statement (Gowers, 2001):** For every k ≥ 4, r_k(N) = O(N / (log log N)^{c_k}) where c_k > 0 depends only on k.

More precisely, Gowers proved:
$$r_k(N) \leq C_k \cdot N \cdot ((\log \log N)^{-1})^{2^{2-2k+9}}$$
(see [Peluse 2025] for precise statement; the exponent decreases with k).

**Method:** Gowers' proof extended his U³ machinery to general **Gowers U^{k-1} norms**, proving a local inverse theorem: if the U^{k-1} norm of the balanced function 1_A - α·1_{[N]} is large, then 1_A correlates with a **polynomial phase function of degree k-2** on a long AP. This is then used in a density increment argument. The framework established **higher-order Fourier analysis** as a field.

**Reference:** W. T. Gowers, "A new proof of Szemerédi's theorem," Geom. Funct. Anal. 11 (2001), no. 3, 465–588. DOI: 10.1007/s00039-001-0332-9.

This bound stood as the best known for k ≥ 5 for 23 years (2001–2024).

---

#### Leng–Sah–Sawhney (2024) — **First Improvement for k ≥ 5 in 23 Years**

**Statement (Leng–Sah–Sawhney, 2024):** For every k ≥ 5, there exists c_k ∈ (0, 1) such that:
$$r_k(N) \ll N \cdot \exp\!\bigl(-(\log \log N)^{c_k}\bigr)$$

**Significance:** This is the **first improvement over Gowers' bounds for k ≥ 5** since 2001, and the **current best upper bound for k ≥ 5**.

The bound exp(-(log log N)^{c_k}) decays much faster than the previous bound (log log N)^{-c_k}, so this represents a genuine (though sub-polynomial) improvement. It is still far weaker than the Kelley–Meka bound for k=3.

**Method:** The proof has two main ingredients:
1. **Quasipolynomial bounds on the inverse theorem for Gowers U^{s+1}[N]-norm** (companion paper, arXiv:2402.17994): Leng, Sah, and Sawhney prove that if the U^{s+1} norm of a function is large, then it correlates with a nilsequence of bounded complexity (with quasipolynomial bounds on the correlation threshold). This dramatically improves over the prior polynomial bounds of Green–Tao–Ziegler (2012).
2. **Density increment strategy of Heath-Brown and Szemerédi** (as reformulated by Green–Tao): Using the improved inverse theorem, one plugs into the standard density increment framework to obtain the bound on r_k(N).

For k = 5 specifically, the improved bound was announced first:

**Statement (Leng–Sah–Sawhney, 2023/2024, for k=5):** r_5(N) ≪ N / exp((log log N)^c) for some c ∈ (0, 1).

**References:**  
- J. Leng, A. Sah, and M. Sawhney, "Improved bounds for five-term arithmetic progressions," arXiv:2312.10776 (2023). Published in Math. Proc. Cambridge Phil. Soc.  
- J. Leng, A. Sah, and M. Sawhney, "Improved Bounds for Szemerédi's Theorem," arXiv:2402.17995 (2024). (For k ≥ 5.)  
- J. Leng, A. Sah, and M. Sawhney, "Quasipolynomial bounds on the inverse theorem for the Gowers U^{s+1}[N]-norm," arXiv:2402.17994 (2024). (The companion paper on the inverse theorem.)

---

### Lower Bounds (k≥5)

#### Rankin (1961) — Best Lower Bounds for k ≥ 4

**Statement (Rankin, 1961):** For k ≥ 4:
$$r_k(N) \geq N \cdot \exp\!\bigl(-C_k (\log N)^{1/\lceil \log_2 k \rceil}\bigr)$$

This gives:
- k = 4: exponent 1/2 (same as Behrend)
- k = 5, 6, 7, 8: exponent 1/3 (better than Behrend!)
- k = 9, ..., 16: exponent 1/4 (even better)
- k = 2^m+1 to 2^{m+1}: exponent 1/(m+1)

**Construction:** Rankin combined Behrend's sphere construction with a refined counting argument. The key observation is that Behrend's argument (intersection with a sphere of dimension ~√(log N)) actually gives a set free of k-APs when k ≤ 2D+1 (D = degree of the polynomial on the sphere), and by tuning D one can optimize for each k.

**Reference:** R. A. Rankin, "Sets of integers containing not more than a given number of terms in arithmetic progression," Proc. Royal Soc. Edinburgh 65 (1960/61), 332–344.

**Important note:** For k = 3, Rankin's bound coincides with Behrend's. Behrend's construction is automatically k-AP-free for all k (any 3-AP-free set is k-AP-free), so r_k(N) ≥ r_3(N) ≥ N·exp(-C√(log N)) for all k. But Rankin gives **stronger** lower bounds for k ≥ 5 (the exponent 1/3 for k=5 gives a larger set than the 1/2 exponent of Behrend).

### Summary Table (k≥5)

| Year | Author(s) | Bound | Notes |
|------|-----------|-------|-------|
| 1946/61 | Behrend/Rankin | r_k(N) ≥ N·exp(-C_k(log N)^{1/⌈log₂ k⌉}) (LOWER) | Rankin better than Behrend for k≥5 |
| 1975 | Szemerédi | r_k(N) = o(N) (qualitative) | Regularity lemma |
| 2001 | Gowers | O(N / (log log N)^{c_k}) | U^{k-1} norm inverse theorem |
| **2023/24** | **Leng–Sah–Sawhney** | **r_k(N) ≪ N · exp(-(log log N)^{c_k})** | **Quasipolynomial inverse theorem** |

> **Best current upper bound (k≥5):** r_k(N) ≪ N · exp(-(log log N)^{c_k})  [Leng–Sah–Sawhney, 2024]  
> **Best current lower bound (k=5-8):** r_k(N) ≥ N · exp(-C_k (log N)^{1/3})  [Rankin, 1961]

**The gap for k≥5 is enormous** — exponential in log N vs. polynomial in log log N. This is the most open regime.

---

## 5. Szemerédi's Theorem and Quantitative Versions

**Szemerédi's Theorem (1975):** For every integer k ≥ 3 and every δ > 0, there exists N_0(k, δ) such that for all N ≥ N_0, every subset A ⊆ {1,...,N} with |A| ≥ δN contains a nontrivial k-AP.

Equivalently: r_k(N)/N → 0 as N → ∞, for every fixed k.

**Three proofs of Szemerédi's theorem:**
1. **Szemerédi (1975):** Original combinatorial proof using the regularity lemma.
2. **Furstenberg (1977):** Ergodic-theoretic proof via the Furstenberg correspondence principle (r_k(N) = o(N) follows from multiple recurrence in ergodic systems).
3. **Gowers (2001):** Quantitative proof via higher-order Fourier analysis (gives explicit bounds, unlike ergodic-theoretic approach).

**The regularity lemma:** The Szemerédi regularity lemma decomposes any graph into ε-regular bipartite graphs and gives r_k(N) ≤ N/wowzer^*(N) type bounds (incredibly weak), but it has proved foundational for extremal combinatorics far beyond arithmetic progressions.

**The Furstenberg–Katznelson theorem (1978):** Extended Szemerédi's theorem to higher dimensions.

**Green–Tao theorem (2004):** The primes contain arithmetic progressions of arbitrary length. This uses Szemerédi's theorem via a "transference principle" from dense subsets of the integers to relative density in a pseudorandom set (the "W-trick"). This is a qualitative result about a different kind of structure.

---

## 6. Key Methods and Techniques

### 6.1 Fourier / Circle Method (Roth, 1953)

The **Fourier analytic approach** (also called the "circle method" or "Hardy–Littlewood method") proceeds as follows:

1. **AP counting identity:** The number of 3-APs in A ⊆ Z/MZ equals:
   $$\Lambda_3(1_A, 1_A, 1_A) = \mathbb{E}_{x, y \in \mathbb{Z}/M\mathbb{Z}} 1_A(x) 1_A(x+y) 1_A(x+2y) = \sum_{\xi \in \mathbb{Z}/M\mathbb{Z}} \hat{f}(\xi)^2 \hat{f}(-2\xi)$$
   where f = 1_A - α is the balanced function.

2. **Density dichotomy:** If A has no 3-APs, the trivial APs (y=0) dominate, so the sum above is approximately α³. This forces some Fourier coefficient |$\hat{f}(\xi)$| ≥ α² for some nonzero ξ.

3. **Density increment:** A large Fourier coefficient at frequency ξ implies A has a density increment of at least cα² on a long arithmetic progression with common difference approximately N/ξ. Iterating gives the bound.

**Limitation:** Fourier analysis is adapted to **linear phases** and thus to 3-APs (which involve a bilinear form in x, y). It is **not sufficient** for 4-APs and longer, which require "quadratic phases" and higher.

---

### 6.2 Density Increment Strategy

The density increment strategy (used in virtually all proofs of upper bounds):

**Framework:** Given A ⊆ [N] with density α and no k-AP:
1. Find a long AP P ⊆ [N] such that A ∩ P has density α + δ (where δ depends on α).
2. Apply the argument again to A ∩ P.
3. Iterate at most α^{-1/δ} times until density > 1, contradiction.

**Different implementations** differ in:
- How the AP P is found (Fourier vs. Bohr sets vs. higher Fourier)
- The length of P relative to N (crucial for quantitative bounds)
- The increment δ as a function of α

**Bohr set variant (Bourgain, Sanders):** Instead of arithmetic progressions, use **Bohr sets** Bohr(Γ, ρ) = {n ∈ Z/NZ : |e(nγ) - 1| ≤ ρ for all γ ∈ Γ}, which are more flexible and support a richer geometry.

---

### 6.3 Almost Periodicity / Croot–Sisask Lemma

**Key idea (Croot–Sisask, 2010):** If A has density α and f = 1_A * 1_A is the convolution, then f is "almost periodic" on a large Bohr set: for most elements h, ||T_h f - f||_2 is small. This "physical space" version of large Fourier coefficients bypasses certain Fourier difficulties.

**Bloom (2016):** Used almost periodicity to show that if A has no 3-APs, the density of A restricted to a structured coset of a Bohr set increases multiplicatively. This gives sharper bounds.

**Bloom–Sisask (2020):** Used a "multiplicative density increment": the density multiplies by (1 + cα^D) at each step. This is much more efficient than additive increment.

---

### 6.4 Kelley–Meka Sifting + Bohr Set Bootstrapping

**Framework (Kelley–Meka, 2023):**
1. **Sifting:** Choose a random subset of "good frequencies." If A lacks 3-APs, a sifting argument shows that many elements of A have large Fourier coefficients on a Bohr set, and by iterating the sifting over successive refinements, one can extract a very large density increment.
2. **Improved Croot–Sisask bootstrapping:** A more efficient version of the almost periodicity lemma that gives near-polynomial (in density α) bounds on the almost periodicity radius.
3. **Compound iteration:** Combine the sifting and bootstrapping to achieve an exponential (in log N) number of density increments, giving the quasi-polynomial bound.

**Raghavan (2026) extension:** An iterated variant that further improves the exponent from 1/9 to 1/6 (modulo a log log N factor).

---

### 6.5 Gowers Uniformity Norms and Higher-Order Fourier Analysis (k ≥ 4)

**Gowers U^s norm (Gowers, 1998/2001):**
$$\|f\|_{U^s}^{2^s} = \mathbb{E}_{x, h_1, ..., h_s \in \mathbb{Z}/N\mathbb{Z}} \prod_{\omega \in \{0,1\}^s} \mathcal{C}^{|\omega|} f(x + \omega \cdot h)$$
where C is complex conjugation.

Key facts:
- **U^2 norm** is equivalent to the L^4 norm of the Fourier transform: $\|f\|_{U^2}^4 = \sum_\xi |\hat{f}(\xi)|^4$. Controls 3-APs (via Cauchy–Schwarz).
- **U^{k-1} norm** controls (k)-term APs. More precisely: if A ⊆ [N] has density α and no k-AP, then $\|1_A - \alpha\|_{U^{k-1}} \geq c_k \alpha^{C_k}$.

**Inverse theorems for Gowers norms:** The key structural results:
- **U^2 inverse theorem:** If $\|f\|_{U^2} \geq \delta$, then $\hat{f}(\xi) \geq c$ for some ξ (i.e., f correlates with a linear phase). This is just classical Fourier analysis.
- **U^3 inverse theorem (Gowers 2001, Green–Tao 2008):** If $\|f\|_{U^3} \geq \delta$, then f correlates with a **quadratic phase function** e(φ(n)) where φ is a degree-2 polynomial (or more precisely, a nilsequence of complexity depending on δ).
- **U^{s+1} inverse theorem (Green–Tao–Ziegler 2012):** If $\|f\|_{U^{s+1}} \geq \delta$, then f correlates with an s-step nilsequence. The bound on complexity was polynomial in 1/δ.
- **Leng–Sah–Sawhney (2024) — Quasipolynomial inverse theorem:** The complexity bound is quasipolynomial in 1/δ (i.e., exp(polylog(1/δ)) rather than poly(1/δ)). This is the key breakthrough enabling improved r_k(N) bounds.

**Nilsequences:** A sequence n ↦ F(g^n x) where g is an element of a nilpotent Lie group G, x is a point in a nilmanifold G/Γ, and F is a Lipschitz function. These are the natural "higher-order exponential" objects in higher-order Fourier analysis.

---

### 6.6 Szemerédi Regularity Lemma

**Statement:** For every ε > 0, every graph on n vertices can be partitioned into at most M(ε) parts (with M(ε) bounded by a tower function in 1/ε) such that all but ε of the pairs of parts are ε-regular bipartite graphs.

**Role in Szemerédi's theorem:** Szemerédi's original proof of r_k(N) = o(N) used the regularity lemma on an appropriate graph derived from the set A. However, the tower-type bounds from the regularity lemma give extremely weak quantitative bounds for r_k(N).

**Energy increment method:** An alternative to the regularity lemma that avoids the tower-type bound: at each step of an iteration, the "additive energy" of the set or function increases significantly. Used in Gowers' proof.

---

### 6.7 Polynomial Method / Slice Rank (Finite Field Setting)

In the finite field model (A ⊆ F_3^n), a completely different approach succeeded dramatically:

**Croot–Lev–Pach (2017) / Ellenberg–Gijswijt (2017):** Using the **polynomial method** (bounding the slice rank of a tensor), they proved r_3(F_3^n) ≤ (2.756...)^n, an exponentially strong bound matching the lower bound order.

**Caveat:** This method uses specific multiplicative structure of finite fields and does NOT transfer to Z or {1,...,N}. Bloom–Sisask's note (2016) and the subsequent Kelley–Meka approach are specific to the integer setting.

---

## 7. The Gap Problem

### Current Gaps

#### For k = 3

| | Bound |
|---|---|
| **Upper** | N · exp(-c (log N)^{1/6} / log log N)  [Raghavan 2026] |
| **Lower** | N · exp(-C (log N)^{1-ε})  [Elsholtz–Hunter–Proske–Sauermann 2024] |

The upper and lower bounds are now **both quasi-polynomial** in N. The pre-Kelley-Meka gap was:
- Upper: N / (log N)^{1+c}  [Bloom-Sisask 2020]
- Lower: N · exp(-C√(log N))  [Behrend 1946]

This was an enormous gap. The Kelley–Meka breakthrough (2023) dramatically narrowed it: the upper bound crossed from polynomial-in-log(N) to quasi-polynomial (sub-power-of-N), while the Elsholtz–Hunter–Proske–Sauermann (2024) construction also improved the lower bound into the quasi-polynomial regime.

**Fundamental difficulty:** Even now, the gap between exponents (1/6 upper vs. 1-ε lower in the quasi-polynomial expression) remains substantial. Whether the true answer is closer to exp(-C√(log N)) (Behrend-like) or exp(-C(log N)^c) for some c > 1/2 is unknown.

#### For k = 4

| | Bound |
|---|---|
| **Upper** | N / (log N)^c  [Green–Tao 2017] |
| **Lower** | N · exp(-C √(log N))  [Behrend 1946] |

The gap here is **enormous and has not narrowed significantly** since the 1940s. No quasi-polynomial bound is known.

#### For k ≥ 5

| | Bound |
|---|---|
| **Upper** | N · exp(-(log log N)^{c_k})  [Leng–Sah–Sawhney 2024] |
| **Lower** | N · exp(-C_k (log N)^{1/⌈log₂ k⌉})  [Rankin 1961] |

The gap here is **super-exponential**: the upper bound decays like exp(-polylog log N) while the lower bound is exp(-polylog N). This is the most extreme gap among the cases.

### Why Is Behrend (for k=3) Believed to Be Close to the Truth?

Several heuristic and technical reasons suggest the **Behrend lower bound** captures the true magnitude of r_3(N):

1. **Optimality of sphere intersection:** The sphere intersection argument is remarkably clean and utilizes a sharp geometric property (no 3-AP on a sphere). Any improvement requires fundamentally new ideas.

2. **Analogies with finite field models:** In the model setting F_3^n, the true answer is exponential (matching up to a constant in the exponent), which is the analogue of "exp(-c√(log N))" in the integer setting.

3. **Failure of naive density arguments:** All known upper bound methods produce bounds much weaker than Behrend's lower bound, suggesting there is genuine structure being missed.

4. **Expert opinion:** Many experts in additive combinatorics believe r_3(N) = Θ(N · exp(-c √(log N))) for the "right" value of c, with the true value being much closer to Behrend's construction than to any upper bound. However, this is not universally held.

5. **No evidence for polynomial bound:** No construction comes close to a polynomial lower bound r_3(N) ≥ N^c for c < 1. The Elsholtz–Hunter–Proske–Sauermann improvement shows we cannot rule out r_3(N) ≥ N · exp(-C(log N)^{1-ε}), but this still has a (log N)^{something} exponent.

### Fundamental Difficulty in Closing the Gap

The difficulty in closing the gap between upper and lower bounds reflects deep mathematical structure:

1. **Rigidity of Fourier/nilsequence arguments:** All current upper bound proofs work via "correlation implies density increment" — if A avoids APs, some structured function (Fourier mode, nilsequence) must correlate with A. But the resulting density increment might always be much smaller than what Behrend's construction "wastes," so the iteration terminates too early.

2. **No good additive structure in Behrend sets:** The Behrend construction (sphere intersection) lacks the additive structure that density-increment-based upper bound proofs exploit. Understanding why remains mysterious.

3. **The quasi-polynomial barrier:** Even the Kelley–Meka argument cannot (as far as is known) be improved beyond some polynomial bound (though even getting the exponent to 1/2 would essentially match Behrend). The current best exponent 1/6 is still far from 1/2.

4. **Structural vs. random:** Behrend sets behave in many ways like "pseudo-random" sets with no additive structure, yet they are highly structured (intersections of spheres). This duality makes them hard to analyze from both directions.

---

## 8. Conjectures About True Asymptotics

### For k = 3

**Folklore conjecture:** There exist constants c, C > 0 such that for all large N:
$$N \cdot \exp(-C \sqrt{\log N}) \leq r_3(N) \leq N \cdot \exp(-c \sqrt{\log N})$$

This would say r_3(N) = N · exp(-(√(log N) · Θ(1))).

More precisely: the exact exponent in Behrend's construction is 2√2, so the lower bound is N · exp(-2√2 · √(log N) + O(log log N)). The conjecture would be that the true answer has the same √(log N) form.

**Alternative conjecture (Kelley-Meka spirit):** Some researchers now believe the upper bound exp(-(log N)^{1/2}) may be achievable, i.e., that there is a genuine quasi-polynomial upper bound N · exp(-c(log N)^{1/2}) which would match Behrend.

**Erdős conjecture on AP-free sets:** A related (now partially resolved) conjecture: if Σ 1/n over n ∈ A diverges, then A contains APs of every length. This would imply r_3(N) = o(N/log N) (since {primes} has divergent reciprocal sum but small density).

### For k = 4

**Conjecture:** The true asymptotic for r_4(N) is also quasi-polynomial:
$$r_4(N) = N \cdot \exp(-c (\log N)^{1/2})$$
matching the Behrend/Rankin lower bound. But this is speculative and there is no near-term route via current methods.

### For General k

**Conjectured behavior:** For each k, r_k(N) should behave like
$$r_k(N) \asymp N \cdot \exp\!\bigl(-C_k (\log N)^{\alpha_k}\bigr)$$
where α_k is related to the Rankin exponent 1/⌈log₂ k⌉. This is consistent with Rankin's lower bound being tight.

**Gowers' conjecture (implicit):** The inverse theorem for Gowers U^{k-1} norms should be improveable to give quasi-polynomial bounds, and this should then yield quasi-polynomial bounds on r_k(N). The Leng–Sah–Sawhney work (proving quasipolynomial inverse theorem) represents partial progress toward this.

**Asymptotic formula:** It is not known if an **exact asymptotic formula** for r_k(N) exists in a meaningful sense. The problem is expected to have answer of the form N · exp(-f(log N)) where f grows sub-linearly, but the precise form of f is unknown even for k = 3.

---

## 9. Complete Reference List

### Primary Research Papers

**Early Foundations:**

1. **Salem, Spencer (1942):** "On sets of integers which contain no three terms in arithmetical progression," Proc. Nat. Acad. Sci. 28, 561–563.

2. **Behrend, F. A. (1946):** "On sets of integers which contain no three terms in arithmetic progression," Proc. Nat. Acad. Sci. 32, 331–332.

3. **Roth, K. F. (1953):** "On certain sets of integers," J. London Math. Soc. 28, 104–109. DOI: 10.1112/jlms/s1-28.1.104.

4. **Rankin, R. A. (1960/61):** "Sets of integers containing not more than a given number of terms in arithmetic progression," Proc. Royal Soc. Edinburgh 65, 332–344.

5. **Szemerédi, E. (1969):** "On sets of integers containing no four elements in arithmetic progression," Acta Math. Acad. Sci. Hungar. 20, 89–104.

6. **Szemerédi, E. (1975):** "On sets of integers containing no k elements in arithmetic progression," Acta Arith. 27, 199–245. [Szemerédi's Theorem]

7. **Furstenberg, H. (1977):** "Ergodic behavior of diagonal measures and a theorem of Szemerédi on arithmetic progressions," J. d'Analyse Math. 31, 204–256.

**k=3 Upper Bounds:**

8. **Heath-Brown, D. R. (1987):** "Integer sets containing no arithmetic progressions," J. London Math. Soc. (2) 35, 385–394.

9. **Szemerédi, E. (1990):** "Integer sets containing no arithmetic progressions," Acta Math. Hungar. 56, 155–158.

10. **Bourgain, J. (1999):** "On triples in arithmetic progression," Geom. Funct. Anal. 9 (5), 968–984.

11. **Bourgain, J. (2008):** "Roth's theorem on progressions revisited," J. Anal. Math. 104, 155–192.

12. **Sanders, T. (2011):** "On Roth's theorem on progressions," Ann. of Math. 174 (1), 619–636. arXiv:1011.0104.

13. **Bloom, T. F. (2016):** "A quantitative improvement for Roth's theorem on arithmetic progressions," J. London Math. Soc. 93 (3), 643–663. arXiv:1405.5800.

14. **Bloom, T. F. and Sisask, O. (2020):** "Breaking the logarithmic barrier in Roth's theorem on arithmetic progressions," arXiv:2007.03528.

15. **Kelley, Z. and Meka, R. (2023):** "Strong Bounds for 3-Progressions," arXiv:2302.05537 (v6: 2024).

16. **Bloom, T. F. and Sisask, O. (2023a):** "The Kelley–Meka bounds for sets free of three-term arithmetic progressions," arXiv:2302.07211.

17. **Bloom, T. F. and Sisask, O. (2023b):** "An improvement to the Kelley–Meka bounds on three-term arithmetic progressions," arXiv:2309.02353. [Improves exponent to 1/9]

18. **Raghavan, R. (2026):** "Improved Bounds for 3-Progressions," arXiv:2603.27045. [Improves exponent to 1/6 (modulo log log N)] — **Current best upper bound for k=3**

**k=3 Lower Bounds:**

19. **Elkin, M. (2011):** "An improved construction of progression-free sets," Israel J. Math. 184, 93–128.

20. **Green, B. and Wolf, J. (2010):** "A note on Elkin's improvement of Behrend's construction," Additive Combinatorics, CRM Proc. arXiv:0810.0732.

21. **Elsholtz, C., Hunter, Z., Proske, L., and Sauermann, L. (2024):** "Improving Behrend's construction: Sets without arithmetic progressions in integers and over finite fields," arXiv:2406.12290. — **First quasipolynomial improvement of Behrend**

22. **Hunter, Z. (2024):** "New lower bounds for r_3(N)," arXiv:2401.16106.

**k=4 Bounds:**

23. **Gowers, W. T. (1998):** "A new proof of Szemerédi's theorem for arithmetic progressions of length four," Geom. Funct. Anal. 8 (3), 529–551.

24. **Green, B. and Tao, T. (2005/2006):** "New bounds for Szemerédi's theorem, II: A new bound for r_4(N)," arXiv:math/0610604.

25. **Green, B. and Tao, T. (2017):** "New bounds for Szemerédi's theorem, III: A polylogarithmic bound for r_4(N)," Mathematika 63 (3), 944–1040. arXiv:1705.01703. — **Current best upper bound for k=4**

**k≥5 Bounds:**

26. **Gowers, W. T. (2001):** "A new proof of Szemerédi's theorem," Geom. Funct. Anal. 11 (3), 465–588. [First quantitative bound for all k≥4]

27. **Green, B., Tao, T., and Ziegler, T. (2012):** "An inverse theorem for the Gowers U^{s+1}[N]-norms," Ann. of Math. 176, 1231–1372.

28. **Leng, J., Sah, A., and Sawhney, M. (2023/2024):** "Improved bounds for five-term arithmetic progressions," arXiv:2312.10776. Published in Math. Proc. Cambridge Phil. Soc. [First improvement for k=5 in 23 years]

29. **Leng, J., Sah, A., and Sawhney, M. (2024a):** "Quasipolynomial bounds on the inverse theorem for the Gowers U^{s+1}[N]-norm," arXiv:2402.17994. [Companion paper — the inverse theorem]

30. **Leng, J., Sah, A., and Sawhney, M. (2024b):** "Improved Bounds for Szemerédi's Theorem," arXiv:2402.17995. — **Current best upper bound for k≥5**

**Survey / Expository Papers:**

31. **Peluse, S. (2022):** "Recent progress on bounds for sets with no three terms in arithmetic progression," arXiv:2206.10037. (Bourbaki seminar text)

32. **Peluse, S. (2025):** "Finding arithmetic progressions in dense sets of integers," arXiv:2509.22962. (Current Events Bulletin lecture; comprehensive survey as of 2025)

**Finite Field Setting:**

33. **Croot, E., Lev, V., and Pach, P. (2017):** "Progression-free sets in Z_4^n are exponentially small," Ann. of Math. 185 (1), 331–337.

34. **Ellenberg, J. and Gijswijt, D. (2017):** "On large subsets of F_q^n with no three-term arithmetic progression," Ann. of Math. 185 (1), 339–343.

35. **Kelley, Z. and Meka, R. (2023):** Strong bounds in finite field setting included in arXiv:2302.05537.

36. **Kelley, Z. and Lyu, X. (2025):** "More efficient sifting for grid norms, and applications to multiparty communication complexity," arXiv:2505.01587 (2025, revised June 2026). — Achieves ℓ¹-spectral density increment Ω(β²) with rank O(β⁻¹) in bipartite (grid norm) setting; motivates Conjecture L3-AP-INCR and the conjectured exponent 1/2 for r₃(N).

---

## Quick Reference: Best Known Bounds by k (as of June 2026)

| k | Best Upper Bound | Ref | Best Lower Bound | Ref |
|---|-----------------|-----|-----------------|-----|
| 3 | N · exp(-c(log N)^{1/6}/log log N) | Raghavan 2026 [arXiv:2603.27045] | N · exp(-C(log N)^{1-ε}) | Elsholtz–Hunter–Proske–Sauermann 2024 [arXiv:2406.12290] |
| 4 | N / (log N)^c | Green–Tao 2017 [arXiv:1705.01703] | N · exp(-C√(log N)) | Behrend 1946 |
| 5 | N · exp(-(log log N)^{c_5}) | Leng–Sah–Sawhney 2023 [arXiv:2312.10776] | N · exp(-C_5(log N)^{1/3}) | Rankin 1961 |
| k≥5 | N · exp(-(log log N)^{c_k}) | Leng–Sah–Sawhney 2024 [arXiv:2402.17995] | N · exp(-C_k(log N)^{1/⌈log₂k⌉}) | Rankin 1961 |
| General | (Szemerédi: o(N)) | Szemerédi 1975 | Rankin construction | Rankin 1961 |

**Legend:** c, C denote positive absolute constants; c_k, C_k denote positive constants depending only on k.

---

*End of Literature Review*
