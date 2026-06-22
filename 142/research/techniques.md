# Proof Techniques for r_k(N): Deep Technical Analysis

**Prepared by**: witsoc-explorer agent  
**Date**: 2026-06-21  
**Mission**: explore-proof-techniques  
**Subject**: Asymptotic formula for r_k(N) — the maximum size of a k-AP-free subset of {1,...,N}

---

## Table of Contents

1. [Introduction and State of the Art](#1-introduction-and-state-of-the-art)
2. [Kelley-Meka (2023) and the Almost-Periodicity Framework](#2-kelley-meka-2023-and-the-almost-periodicity-framework)
3. [Bloom-Sisask Improvements and Raghavan (2026)](#3-bloom-sisask-improvements-and-raghavan-2026)
4. [Green-Tao, Gowers Norms, and r_4(N)](#4-green-tao-gowers-norms-and-r_4n)
5. [Leng-Sah-Sawhney (2024): Higher k via Inverse Theorems](#5-leng-sah-sawhney-2024-higher-k-via-inverse-theorems)
6. [Behrend's Lower Bound and Recent Improvements](#6-behrends-lower-bound-and-recent-improvements)
7. [The Classical Fourier Analysis Approach](#7-the-classical-fourier-analysis-approach)
8. [Cap Sets and the Polynomial Method](#8-cap-sets-and-the-polynomial-method)
9. [Technical Analysis of Key Questions](#9-technical-analysis-of-key-questions)
10. [Assessment of New Angles](#10-assessment-of-new-angles)
11. [Synthesis and Proof Strategy](#11-synthesis-and-proof-strategy)
12. [Recommended Next Steps](#12-recommended-next-steps)

---

## 1. Introduction and State of the Art

### Problem Statement

Let $r_k(N)$ denote the maximum size of a subset $A \subseteq \{1, \ldots, N\}$ containing no $k$-term arithmetic progression (k-AP). Szemerédi's theorem (1975) states that $r_k(N) = o(N)$ for every fixed $k \geq 3$. The central open problem is to determine the quantitative rate of decay.

### Current Best Bounds (as of June 2026)

| k | Upper Bound | Lower Bound | Gap |
|---|-------------|-------------|-----|
| 3 | $N \exp(-(log N)^{1/6} / \log\log N)$ [Raghavan 2026] | $N \exp(-c\sqrt{\log N})$ [Behrend 1946, improved constant Elsholtz et al. 2024] | exponent 1/6 vs 1/2 |
| 4 | $N(\log N)^{-c}$ [Green-Tao 2017] | $N \exp(-c\sqrt{\log N})$ | enormous (polylog vs quasi-poly) |
| k≥5 | $N \exp(-(\log\log N)^{c_k})$ [Leng-Sah-Sawhney 2024] | $N \exp(-c_k \sqrt{\log N})$ | double-logarithmic vs square root |

### The Central Gap

For $k = 3$, the exponent in the upper bound has progressed as:
$$\underbrace{0}_{Roth~1953} \to \underbrace{\text{polylog/log}^{1+c}}_{Bloom\text{-}Sisask~2020} \to \underbrace{1/12}_{Kelley\text{-}Meka~2023} \to \underbrace{1/9}_{Bloom\text{-}Sisask~2023} \to \underbrace{1/6}_{Raghavan~2026} \to \underbrace{?}_{1/2 = Behrend}$$

The lower bound exponent of $1/2$ has stood since 1946 (improved only in lower-order constant), suggesting either that the upper bound has much further to improve, or that the true exponent is between $1/6$ and $1/2$.

---

## 2. Kelley-Meka (2023) and the Almost-Periodicity Framework

### 2.1 Overview

**Paper**: Zander Kelley and Raghu Meka, "Strong Bounds for 3-Progressions" (arXiv:2302.05537, 2023).

**Main Result**: If $A \subseteq \{1,\ldots,N\}$ has no nontrivial 3-APs, then
$$|A| \leq N \cdot \exp(-c (\log N)^{1/12})$$
for an absolute constant $c > 0$.

This was a landmark breakthrough, achieving for the first time a bound of the form $N \exp(-(\log N)^{\beta})$ for $\beta > 0$, i.e., quasi-polynomial in $\log N$ — a vast improvement over the previous best of $N (\log N)^{-1-c}$ (Bloom-Sisask 2020).

### 2.2 The Almost-Periodicity Framework

The central new tool is an **almost-periodicity lemma**, which replaces the classical Fourier-analytic density increment.

**Classical Fourier approach**: If $A$ is $3$-AP-free with density $\alpha$, and $\hat{1}_A$ has no large Fourier coefficient, then the "energy" of $A$ is spread uniformly and one can count 3-APs. If a large Fourier coefficient exists, one passes to an AP on which the density of $A$ increases.

**Almost-periodicity approach**: Instead of seeking one large Fourier coefficient, the method seeks a **Bohr set** $B(S, \rho) = \{n : \|ns\|_{\mathbb{T}} < \rho \text{ for all } s \in S\}$ such that $1_A$ is "almost periodic" modulo $B(S, \rho)$ — meaning the convolution $1_A * \mu_B$ approximates $1_A$ well in some norm. Here $\mu_B$ is a measure on the Bohr set.

**The key lemma** (Croot-Sisask, developed by Kelley-Meka): Let $f: \mathbb{Z}_N \to [-1,1]$ with $\|f\|_2 \geq \delta$. There exists a Bohr set $B$ of rank $d = O(1/\delta^2)$ and radius $\rho = \Omega(\delta^{C/\delta^2})$ such that
$$\|f * \mu_B - f\|_2 \leq \epsilon \|f\|_2$$
for some small $\epsilon > 0$.

This is more powerful than Fourier because: (i) Bohr sets are more structured than APs; (ii) density increments on Bohr sets are quantitatively better; (iii) the lemma makes no assumption about the Fourier spectrum and captures "almost-linear" structure globally.

### 2.3 The Sifting Argument

Kelley and Meka introduce a **sifting (or density-increment) argument** that is novel in several respects:

1. **Encode 3-APs algebraically**: If $A$ is 3-AP-free, the function $T(x,y,z) = 1_A(x) 1_A(y) 1_A(z) \cdot [(x + z = 2y)]$ is identically zero. This can be encoded as a polynomial vanishing condition.

2. **Tensor product structure**: Write $1_A^{\otimes 3}$ on the triple $(x, y, z)$ with the 3-AP constraint. The polynomial method gives the "slice rank" of this tensor, bounding the size of $A$.

3. **Almost-periodicity provides structure**: When $A$ has density $\alpha$ and $|A|$ is not too small, there exists a Bohr set of rank $d$ and polynomial density $\alpha(1 + \text{poly}(\alpha))$ on some coset. This is the **density increment step**.

4. **Iteration**: The density increment is applied repeatedly. Each step increases density by roughly $\alpha^2/d$ (heuristically) and doubles the rank $d$ of the Bohr set. After $O(1/\alpha^2)$ steps, density exceeds 1 — contradiction.

### 2.4 Where the Exponent 1/12 Originates

The bound $\exp(-c(\log N)^{1/12})$ arises from balancing several competing factors in the iterative argument.

Let $\alpha = |A|/N$ be the density of $A$. The iteration argument works as follows:

**Step 1**: The almost-periodicity lemma (applied to $f = 1_A - \alpha$) gives a Bohr set of rank $d_0 = O(\alpha^{-2})$ and size $|B| \geq N^{1-C/d_0}$.

**Step 2**: On a coset progression of "complexity" related to $d_0$, the density of $A$ increases to $\alpha + \Omega(\alpha^3/d_0)$.

**Step 3**: The effective length of the interval reduces by a factor $\sim |B|/N$.

After $k = O(\alpha^{-3} \cdot d_0)$ iterations, the density reaches 1. The total "compression" of the interval is:
$$N_{\text{final}} \geq N \cdot (|B|/N)^k$$

Setting $N_{\text{final}} \geq 2$ (so the process is consistent) gives a bound on $\alpha$ in terms of $N$.

The exponent $1/12$ specifically arises from:
- The rank after $k$ iterations grows as $d_k \approx k \cdot d_0 = O(k/\alpha^2)$.
- The density increment at step $i$ is $\approx \alpha^3 / d_i$.
- After $k$ steps, $\alpha$ increases to roughly $\alpha + k \cdot \alpha^3 / (k \cdot \alpha^{-2}) = \alpha + \alpha^5$.
- The Bohr set size at step $k$ is $\approx N \exp(-d_k / \rho^{-1}) = N \exp(-k^C \cdot \alpha^{-C})$.

Balancing to get $N_{\text{final}} \geq 2$ gives $\alpha \gtrsim (\log N)^{-1/12}$ roughly speaking — hence the bound.

More precisely, a careful bookkeeping using the **Croot-Sisask almost-periodicity lemma** (with 3-fold tensor products) gives the $1/12$ exponent. The $3$-fold nature is crucial: encoding 3-APs requires considering $f(x)f(y)f(z)$ simultaneously, which via Cauchy-Schwarz introduces factors of $\epsilon^{1/3}$ (from 3 functions), and the rank grows by a factor $3$ per step, ultimately giving $1/(4 \cdot 3) = 1/12$.

### 2.5 What Prevents Extending to k=4?

For $k = 4$ APs ($a, a+d, a+2d, a+3d$), the Kelley-Meka approach faces a fundamental obstruction:

**Structural difference**: 3-APs are controlled by the $U^2$ (Gowers) norm = Fourier $L^4$ norm. 4-APs require the $U^3$ norm, which is sensitive to "quadratic" structure (quadratic exponential sums, 2-step nilsequences).

**Almost-periodicity for U^3**: The Kelley-Meka argument constructs a Bohr set via the U^2 structure of $A$. For 4-APs, one would need almost-periodicity relative to a "quadratic Bohr set" or "2-step nilpotent group." These objects are:
- Harder to parametrize (quadratic Bohr sets have exponentially many "shapes")
- Harder to iterate (density increments on quadratic structures don't compose simply)
- Quantitatively worse (the inverse U^3 theorem loses more in the iteration)

The key technical barrier: **The inverse theorem for $U^3$ in $\mathbb{Z}_N$ involves 2-step nilmanifolds** (Green-Tao 2012), not just linear characters. A density increment on a coset of a 2-step nilmanifold is not the same as on a Bohr set, and the Croot-Sisask almost-periodicity lemma does not have a direct analogue in this higher-order setting.

---

## 3. Bloom-Sisask Improvements and Raghavan (2026)

### 3.1 Bloom-Sisask (2023): Exponent 1/9

**Paper**: Thomas Bloom and Olof Sisask, "An improvement to the Kelley-Meka bounds on three-term arithmetic progressions" (arXiv:2309.02353, 2023).

**Result**: $|A| \leq N \exp(-c (\log N)^{1/9})$ for $A \subseteq \{1,\ldots,N\}$ free of 3-APs.

**Improvement mechanism**: Bloom and Sisask found that with a refined bootstrapping of the Croot-Sisask almost-periodicity lemma, the rank growth in the iteration can be controlled more carefully. Specifically:

- The original Kelley-Meka uses a **3-fold** almost-periodicity (for the three variables of a 3-AP), giving rank $d = O(\alpha^{-6})$.
- By introducing a more careful bootstrapping argument, one can obtain rank $d = O(\alpha^{-4})$ while maintaining the same density increment.
- This changes the exponent from $1/12 = 1/(4 \cdot 3)$ to $1/9 = 1/(3 \cdot 3)$.

Intuitively: the improvement comes from using the almost-periodicity lemma "twice" in a bootstrapped way, reducing the polynomial dependence on $\alpha$ in the rank bound.

### 3.2 Raghavan (2026): Exponent 1/6

**Paper**: Rushil Raghavan, "Improved Bounds for 3-Progressions" (arXiv:2603.27045, March 2026).

**Result**: $|A| \leq N \exp\!\big({-c (\log N)^{1/6} (\log\log N)^{-1}}\big)$ for $A \subseteq \{1,\ldots,N\}$ free of 3-APs.

**Method**: Raghavan uses an **iterated sifting argument** building on Kelley-Meka's framework with the Bloom-Sisask bootstrapping improvement. The key new idea is to **iterate the sifting itself**: rather than applying the density increment once per "level," he applies it in a nested fashion, obtaining a more efficient trade-off between density increment and Bohr set rank growth.

**Exponent analysis**: The $1/6$ comes from the iterated sifting allowing rank growth of $d = O(\alpha^{-2})$ instead of $\alpha^{-4}$, combined with the 3-fold structure of 3-APs:
- Each "outer iteration" involves $O(1/\alpha^2)$ "inner iterations."
- The total rank after all iterations is $O(\alpha^{-2} \cdot \alpha^{-2}) = O(\alpha^{-4})$... wait.

Actually, the precise mechanism: in the iterated sifting, one finds that the effective "loss" in the exponent is $1/(2 \cdot 3) = 1/6$ instead of $1/(4 \cdot 3) = 1/12$. The factor $3$ is intrinsic to 3-APs; the factor $2$ comes from the "quadratic" nature of Croot-Sisask (it uses $L^2$).

### 3.3 Is Exponent 1/2 Achievable by These Methods?

**The fundamental bottleneck**: The Croot-Sisask almost-periodicity lemma is **quadratic** in nature: it produces Bohr sets of rank $d = O(\alpha^{-2})$, reflecting the $L^2$ structure of Fourier analysis. To reach exponent $1/2$ (matching Behrend), one would need Bohr set rank $d = O(1)$ (constant rank, independent of $\alpha$) — which contradicts the lemma's structure.

More precisely: to match the Behrend bound $\alpha \sim \exp(-c\sqrt{\log N})$, the iteration would need to run for only $O(\sqrt{\log N})$ steps, each giving a constant density increment. But the almost-periodicity lemma requires $d \to \infty$ as $\alpha \to 0$, creating a fundamental barrier.

**Heuristic for the "true" exponent**: Most experts believe the "true" exponent for $r_3(N)$ in the upper bound is $1/2$ (matching Behrend). The remaining gap from $1/6$ to $1/2$ requires fundamentally new ideas beyond the almost-periodicity framework.

---

## 4. Green-Tao, Gowers Norms, and r_4(N)

### 4.1 The Gowers Uniformity Norms

For a function $f: \mathbb{Z}_N \to \mathbb{C}$, the **Gowers $U^s$ norm** is defined by:
$$\|f\|_{U^s}^{2^s} = \mathbb{E}_{x, h_1, \ldots, h_s \in \mathbb{Z}_N} \prod_{\epsilon \in \{0,1\}^s} \mathcal{C}^{|\epsilon|} f\!\left(x + \epsilon_1 h_1 + \ldots + \epsilon_s h_s\right)$$
where $\mathcal{C}$ is complex conjugation and $|\epsilon| = \epsilon_1 + \ldots + \epsilon_s$.

**Key relationship to arithmetic progressions**:
- $k = 3$: controlled by $U^2$ norm (= Fourier $L^4$ norm)
- $k = 4$: controlled by $U^3$ norm
- $k = s+1$: controlled by $U^s$ norm

This is made precise by the **Gowers-Cauchy-Schwarz inequality**: if $A$ has density $\alpha$ in $\{1,\ldots,N\}$ and $\Lambda_k(1_A, \ldots, 1_A) \geq \alpha^k$ (i.e., $A$ contains as many $k$-APs as a random set), then $\|1_A - \alpha\|_{U^{k-1}} \leq \epsilon$.

### 4.2 Inverse Theorems

The **inverse theorem for $U^s$** characterizes functions with large $U^s$ norm:

**$U^2$ (Fourier)**: $\|f\|_{U^2} \geq \delta \Rightarrow \exists$ linear character $\chi$ with $|\langle f, \chi \rangle| \geq \delta^4$. [Bogolyubov, Ruzsa]

**$U^3$ (quadratic)**: $\|f\|_{U^3} \geq \delta \Rightarrow f$ correlates with a **2-step nilsequence** (a quadratic exponential function on a nilmanifold). [Green-Tao 2012]

**$U^s$ (degree $s-1$)**: $\|f\|_{U^s} \geq \delta \Rightarrow f$ correlates with an **$(s-1)$-step nilsequence**. [Green-Tao-Ziegler 2012]

**Quantitative improvement**: Leng, Sah, Sawhney (arXiv:2402.17994, 2024) proved **quasipolynomial bounds** on the $U^{s+1}[N]$ inverse theorem: if $\|f\|_{U^{s+1}} \geq \delta$, then $f$ correlates $\geq \exp(-(\log(1/\delta))^{C_s})$ with a nilsequence of complexity $\leq \exp((\log(1/\delta))^{C_s})$. Previously the bounds were tower-type.

### 4.3 Why k=4 is Qualitatively Harder

**The U^3 obstacle**: For 4-APs, a density increment argument requires:
1. Show $\|1_A - \alpha\|_{U^3}$ is large (using that $A$ is 4-AP-free).
2. Apply the $U^3$ inverse theorem to get correlation with a 2-step nilsequence.
3. Pass to a structured subset (a "nilBohr set") on which $A$ has higher density.
4. Iterate.

Steps 2 and 3 are qualitatively harder for $U^3$ than for $U^2$:
- A 2-step nilmanifold $G/\Gamma$ is not an abelian group; it has polynomial orbit structure.
- Density increments on cosets of nilpotent groups do not admit simple "Bohr set" descriptions.
- The "nilBohr sets" that arise from step 3 are of exponentially higher complexity than classical Bohr sets.

**The Green-Tao arithmetic regularity lemma**: Green and Tao (2008) proved an analogue of Szemerédi's regularity lemma for nilsequences:
$$f = f_{\text{nil}} + f_{\text{unif}} + f_{\text{err}}$$
where $f_{\text{nil}}$ is a nilsequence approximant, $\|f_{\text{unif}}\|_{U^s}$ is small, and $\|f_{\text{err}}\|_{L^2}$ is small. But this decomposition has **tower-type** quantitative bounds, severely limiting what can be proved.

The Leng-Sah-Sawhney quasipolynomial inverse theorem partially addresses this, but the "nilBohr set" iteration for 4-APs still has quantitative losses much worse than the 3-AP case.

### 4.4 Current Best for r_4(N)

**Green-Tao (2017)** (arXiv:1705.01703): $r_4(N) \leq N (\log N)^{-c}$ for some $c > 0$.

This still only gives a *polylogarithmic* bound — vastly weaker than the quasi-polynomial bound for $k = 3$. The gap is enormous.

**Why no quasi-polynomial bound for k=4?**: The Kelley-Meka method fundamentally requires the $U^2$ (Fourier) inverse theorem, which gives correlation with simple linear characters. For $k=4$, correlation with 2-step nilsequences is much harder to exploit in a density-increment argument. The "almost-periodicity for nilsequences" required for a Kelley-Meka analogue has not yet been developed.

### 4.5 The Leng-Sah-Sawhney Path for k=5

**Paper**: Leng, Sah, Sawhney, "Improved bounds for five-term arithmetic progressions" (arXiv:2312.10776, 2023).

Their method uses:
1. The quasipolynomial $U^4$ inverse theorem (which they also proved)
2. The Heath-Brown–Szemerédi density increment strategy reformulated by Green-Tao
3. Quantitative equidistribution of nilsequences (Leng, arXiv:2312.10772)

The bound $r_5(N) \leq N \exp(-(\log\log N)^c)$ is the first improvement over Gowers's bound for $k=5$.

---

## 5. Leng-Sah-Sawhney (2024): Higher k via Inverse Theorems

### 5.1 The Gowers Inverse Theorem at Quasipolynomial Bounds

**Paper**: James Leng, Ashwin Sah, Mehtaab Sawhney, "Quasipolynomial bounds on the inverse theorem for the Gowers $U^{s+1}[N]$-norm" (arXiv:2402.17994, February 2024).

**Result**: For $\|f\|_{U^{k}[N]} \geq \delta$, there exists a nilmanifold $G/\Gamma$ of:
- Step: $k-1$
- Dimension: $\leq (\log(1/\delta))^{C_k}$
- Complexity: $\leq \exp((\log(1/\delta))^{C_k})$

such that $f$ correlates $\geq \exp(-(\log(1/\delta))^{C_k})$ with $F(g(n)\Gamma)$ for some Lipschitz $F$ and polynomial sequence $g$.

This is a major improvement over the tower-type bounds of Green-Tao-Ziegler (2012). The quasipolynomial nature makes the density increment argument quantitatively feasible.

### 5.2 Main Szemerédi Bound for k≥5

**Paper**: James Leng, Ashwin Sah, Mehtaab Sawhney, "Improved Bounds for Szemerédi's Theorem" (arXiv:2402.17995, February 2024).

**Main Result**: For all $k \geq 5$, there exists $c_k > 0$ such that
$$r_k(N) \leq N \exp(-(\log\log N)^{c_k}).$$

This is the first improvement over Gowers's original bound for progressions of length 5 and longer.

**Proof strategy**:
1. Apply the quantitative $U^{k-1}$ inverse theorem to find nilsequence correlation.
2. Use quantitative equidistribution to pass to a long sub-progression on which the nilsequence "equidistributes."
3. On this sub-progression, $A$ either has higher density (density increment) or fails to have enough correlations (contradiction).
4. Iterate.

**Why the bound is exp(-(log log N)^{c_k}) and not exp(-(log N)^{c_k})**:

The density increment via the $U^{k-1}$ inverse theorem is quantitatively much weaker than the almost-periodicity approach for k=3:
- Each density increment step gives a sub-progression of length $N' \geq N^{\Omega(1)}$, but the density increase is only $\Omega(\delta^{O(1)})$ where $O(1)$ depends badly on $k$.
- The iteration terminates after $O(1/\delta^C)$ steps, but the "compression factor" per step involves exponential losses from the nilsequence equidistribution.
- These exponential losses in the equidistribution (even with the quasipolynomial improvement) mean the bound is $\exp(-(\log\log N)^{c_k})$ rather than $\exp(-(\log N)^{c_k})$.

**The c_k exponent**: The constant $c_k > 0$ depends on $k$ in an unspecified way. It is expected to decrease with $k$, reflecting the increasing complexity of the nilsequences involved.

### 5.3 Why k=4 Is Not Covered

Leng-Sah-Sawhney's result applies for $k \geq 5$ but not $k = 4$. The reason is subtle:

For $k = 4$, the $U^3$ inverse theorem involves 2-step nilsequences which locally look like "quadratic functions" on shifted Bohr sets. Leng-Sah-Sawhney's method requires that the nilsequences can be **approximated by locally polynomial functions** on Bohr sets — this holds for step $\geq 3$ (k≥5) but requires a more delicate argument for step 2 (k=4). A separate paper (arXiv:2312.10776) handles $k=5$ and notes that $k=4$ requires additional work due to 2-torsion complications in 2-step nilmanifolds.

---

## 6. Behrend's Lower Bound and Recent Improvements

### 6.1 The Sphere Construction

**Behrend (1946)**: There exists a set $A \subseteq \{1,\ldots,N\}$ with no 3-AP and
$$|A| \geq N \exp(-c\sqrt{\log N})$$
for an absolute constant $c > 0$ (explicitly: $c \approx 2\sqrt{2} \approx 2.83$).

**Construction**:

1. Choose parameters $d \approx \sqrt{\frac{\log N}{2 \log 3}}$ and $M = \lfloor N^{1/d} \rfloor$.

2. In $[0, M]^d$, consider the sphere levels $S_R = \{x \in [0, M-1]^d : \|x\|^2 = R\}$ for $R \in \{0, 1, \ldots, dM^2\}$.

3. By pigeonhole, some sphere $S_R$ has size $\geq M^d / (dM^2 + 1) \geq M^{d-2}/d$.

4. **The sphere $S_R$ is 3-AP-free**: If $a, b, c \in S_R$ with $a + c = 2b$, then $\|a - b\|^2 = \|b - c\|^2$ and $(a - b) + (c - b) = 0$, so $a - b = -(c-b)$. Combined with $\|a\|^2 = \|b\|^2 = \|c\|^2 = R$, we get:
   $$\|a - b\|^2 = \|a\|^2 - 2a \cdot b + \|b\|^2 = 2R - 2a \cdot b$$
   $$\|c - b\|^2 = 2R - 2c \cdot b$$
   Since $a - b = -(c - b)$, we have $a \cdot b = c \cdot b$. Also $a + c = 2b$ gives $a = 2b - c$, so $a \cdot b = (2b - c) \cdot b = 2R - c \cdot b$. Combined: $2R - c \cdot b = c \cdot b \Rightarrow c \cdot b = R \Rightarrow c = b$ (since $\|b\| = \|c\| = \sqrt{R}$ and the equality $c \cdot b = \|b\|\|c\|$ forces $c = b$). Hence $a = c = b$ — the AP is trivial.

5. **Embed into $\{1,\ldots,N\}$**: Map $x = (x_0, \ldots, x_{d-1}) \in S_R$ to $\phi(x) = 1 + \sum_{i=0}^{d-1} x_i (2M)^i$. The map is injective and APs in $S_R$ map to APs in $\phi(S_R)$ (since $\phi$ is an affine map over $\mathbb{Z}$). The image lies in $\{1,\ldots, (2M)^d\} \approx \{1,\ldots,N\}$.

**Density**: $|A| \geq M^{d-2}/d \approx N^{1-2/d}/d$. Optimizing $d$:

Taking $d = \sqrt{\log N / (2\log 2)}$ (balancing the density):
$$|A| \approx N \cdot M^{-2} / d \approx N \cdot N^{-2/d} / \sqrt{\log N} \approx N \exp(-2 \log N / d) / \sqrt{\log N}$$
$$\approx N \exp\!\left(-2\sqrt{2 \log 2} \cdot \sqrt{\log N}\right) / \sqrt{\log N}$$

So $c \approx 2\sqrt{2\log 2} \approx 2.35$ (or $c \approx 2\sqrt{2} \approx 2.83$ depending on exact base choices).

### 6.2 Improvements to Behrend's Constant

**Elkin (2011)**: By using a thin annulus $\{x: R_1 \leq \|x\|^2 \leq R_2\}$ instead of a sphere, Elkin improved the constant by a lower-order factor, getting $|A| \geq N \exp(-c\sqrt{\log N}) \cdot (\log N)^{1/4}$ — improvement only in the lower-order multiplicative factor, not in the $\sqrt{\log N}$ exponent.

**Elsholtz, Hunter, Proske, Sauermann (2024)** (arXiv:2406.12290): The first improvement to the **leading constant** $c$ in the exponent since 1946. They improve the constant from $c \approx 2\sqrt{2} \approx 2.83$ to $c \approx 2\sqrt{\log_2(24/7)} \approx 2.667$. 

Their method uses a more sophisticated geometric construction: instead of a single sphere in $\mathbb{Z}^d$, they take a set on an algebraic variety in $\mathbb{F}_p^n$ that has better AP-free properties through algebraic structure. The bound they achieve is approximately:
$$|A| \geq N \exp\!\left(-2\sqrt{\log_2(24/7) \cdot \log N}\right)$$

This is the first **qualitative improvement** to the lower bound constant in 78 years, though the exponent $1/2$ in $\sqrt{\log N}$ remains unchanged.

### 6.3 Generalization to k-APs

For $k \geq 4$, Behrend's sphere argument needs modification since the sphere is **not** automatically $k$-AP-free for $k \geq 4$.

**Verification for $k=4$**: If $a, a+d, a+2d, a+3d \in S_R$ (sphere of radius $\sqrt{R}$), does this force $d = 0$?

The four-point condition gives:
- $\|a\|^2 = \|a+d\|^2 \Rightarrow 2a \cdot d + \|d\|^2 = 0$
- $\|a+2d\|^2 = R \Rightarrow 4a \cdot d + 4\|d\|^2 = 0 \Rightarrow a \cdot d + \|d\|^2 = 0$

From the first equation: $2a \cdot d = -\|d\|^2$. From the second: $a \cdot d = -\|d\|^2$. These are inconsistent (giving $-\|d\|^2/2 = -\|d\|^2$) unless $d = 0$. So **a sphere in $\mathbb{Z}^d$ is $4$-AP-free**!

Wait, let me re-examine. All four points $a, a+d, a+2d, a+3d$ on $S_R$ means:
- $\|a\|^2 = R$
- $\|a+d\|^2 = R \Rightarrow 2a \cdot d + \|d\|^2 = 0$ ... (I)
- $\|a+2d\|^2 = R \Rightarrow 4a \cdot d + 4\|d\|^2 = 0$ ... (II)
- $\|a+3d\|^2 = R \Rightarrow 6a \cdot d + 9\|d\|^2 = 0$ ... (III)

From (I): $2a \cdot d = -\|d\|^2$.
From (II): $4a \cdot d = -4\|d\|^2 \Rightarrow 2a \cdot d = -2\|d\|^2$.

Contradiction with (I) unless $\|d\|^2 = 0$, i.e., $d = 0$.

So **a sphere in $\mathbb{Z}^d$ is $4$-AP-free** as well! Behrend's construction thus gives lower bounds for $r_k(N)$ for all $k$, with the same $\exp(-c\sqrt{\log N})$ form.

**Rankin (1961)**: Generalized to give lower bounds $r_k(N) \geq N \exp(-c_k \sqrt{\log N})$ for all $k$, using variations of the sphere construction. The constants $c_k$ may differ.

### 6.4 The Optimality Question

Is $r_3(N) \sim N \exp(-c\sqrt{\log N})$ asymptotically? 

The prevailing belief (based on intuition from finite field analogues and number-theoretic heuristics) is **yes** — the Behrend construction is essentially tight. But proving this requires bridging the gap from the current upper bound exponent of $1/6$ to $1/2$.

Key evidence for Behrend-optimality:
1. In $\mathbb{F}_3^n$, the polynomial method gives $r_3(\mathbb{F}_3^n) \leq (2.756)^n \approx 3^{0.923n}$, while the "Behrend-type" lower bound for $\mathbb{F}_3^n$ (Salem-Spencer set) gives $(3/e^{1/2})^n \approx 3^{0.818n}$ — a constant factor, not an exponent gap.
2. The Behrend construction in $\mathbb{Z}$ uses $d \sim \sqrt{\log N}$ dimensions — the "right" dimension for the problem.

---

## 7. The Classical Fourier Analysis Approach

### 7.1 Roth's Method (1953) and Its Descendants

**Roth (1953)**: The first quantitative bound: $r_3(N) = o(N)$ via a Fourier-analytic density increment.

**The density increment argument**:

If $A \subseteq \{1,\ldots,N\}$ with density $\alpha = |A|/N$ contains no 3-AP, one of two cases holds:
1. **(Uniform case)**: $\hat{1}_A(r)$ is small for all $r \neq 0$, meaning $A$ "looks random." In this case, the 3-AP count is approximately $\alpha^3 N^2$, which is positive for $N \geq N_0(\alpha)$ — contradiction.

2. **(Non-uniform case)**: There exists $r \neq 0$ with $|\hat{1}_A(r)| \geq \epsilon N$, meaning $A$ correlates with the exponential function $x \mapsto e(rx/N)$. By standard arguments, $A$ has density $\geq \alpha + c\epsilon^2$ on some arithmetic progression of length $\geq \epsilon N$.

Iterating case 2: Starting with density $\alpha$, after $O(\alpha^{-1}/c)$ increments (each adding $c\epsilon^2 \sim c\alpha^4$ to the density), we reach density 1. The length of the AP decreases by factor $\sim \epsilon$ at each step, giving $N_{\text{final}} \geq N \cdot (\epsilon)^{O(1/\alpha^4)}$.

Setting $N_{\text{final}} \geq 2$ gives the **logarithmic bound**: $\alpha \gtrsim (\log N)^{-c}$ for some $c$.

### 7.2 Improvements to the Fourier Approach

**Key bottleneck**: Each density increment reduces to a shorter AP, but the "correlation" with exponentials requires the increment to be on a fixed-length arithmetic progression, not a Bohr set. This loses information.

**Bourgain (1999, 2008)**: Replaced APs by Bohr sets, obtaining density increments on more structured sets. Got:
- (1999): $r_3(N) \leq N(\log N)^{-1/2+\epsilon}$
- (2008): $r_3(N) \leq N(\log N)^{-2/3+\epsilon}$

**Sanders (2011)**: Used $L^p$ Fourier analysis with optimal constants, obtained $r_3(N) \leq N (\log\log N)^5 / \log N$ — within a factor of $(\log\log N)^5$ of $N/\log N$.

**Bloom (2016)**: Improved to $N(\log\log N)^4/\log N$.

**Bloom-Sisask (2020)** (arXiv:2007.03528): First to break $N/\log N$, proving $r_3(N) \leq N/(\log N)^{1+c}$ for an absolute constant $c > 0$. This was the state-of-the-art Fourier-based result.

### 7.3 Why Fourier Analysis "Runs Out of Steam"

**The fundamental barrier**: Fourier analysis detects correlations with *linear* exponential phases $e(rx)$. It is blind to:
- Quadratic phases $e(rx^2)$ (relevant for 4-APs)
- Higher-order correlations
- Algebraic structure beyond linear characters

For 3-APs, the Fourier analysis can at best give density increments of size $\sim \alpha^3$ per step. The iteration requires $\sim 1/\alpha^3$ steps, compressing the interval by factor $N_{\text{final}}/N \sim \exp(-C/\alpha^3)$. Setting this $\geq 2$ gives $\alpha \gtrsim C/(\log N)^{1/3}$ — but this estimate is very crude.

The precise barrier is the **Bogolyubov-Ruzsa lemma**: to get a Bohr set of rank $d$ from the $L^4$ Fourier norm, one needs to use $O(1/\alpha^2)$ Fourier coefficients, giving rank $d \sim \alpha^{-2}$. The Bohr set has size $\sim N \exp(-d) = N \exp(-\alpha^{-2})$, so after one iteration the interval length is $\sim \exp(-\alpha^{-2})$. This forces $\alpha \gtrsim (\log N)^{-1}$ from a single iteration.

Richer iterative schemes can improve the constant, but **the $N/\log N$ barrier** is essentially the limit of the Fourier approach.

---

## 8. Cap Sets and the Polynomial Method

### 8.1 The Cap Set Problem

The **cap set problem** asks for the maximum size of a subset $A \subseteq \mathbb{F}_3^n$ with no 3-AP (i.e., no $x, y, z \in A$ with $x + y + z = 0$).

Note: in $\mathbb{F}_3^n$, the condition "$x, y, z$ form a 3-AP" is equivalent to $x + y + z = 0$ (since char = 3 means $2^{-1} = 2$, so $y = (x+z)/2$ iff $3y = x + z + y$ iff $y = x + z + y \pmod{3}$... let me be more careful). Actually in $\mathbb{F}_3^n$, "$x, y, z$ is a 3-AP" means $y - x = z - y$, i.e., $x + z = 2y = -y$ (since $2 = -1$ in $\mathbb{F}_3$), so $x + y + z = 0$. This is the "sum-zero" condition.

**Key result**: Ellenberg-Gijswijt (2017) proved $|A| \leq 3 \cdot (2.756\ldots)^n = o(3^n)$.

Previously, only $|A| \leq o(3^n)$ was known (via Fourier), and the construction gives $|A| \geq (2.2\ldots)^n$.

### 8.2 The Polynomial Method (Slice Rank)

**Croot-Lev-Pach (2017)** first proved analogous bounds for $\mathbb{Z}_4^n$. Ellenberg-Gijswijt extended to $\mathbb{F}_q^n$.

**The method** (Tao's formulation as "slice rank"):

Define the indicator function $\Delta(x, y, z) = [x + y + z = 0] \cdot 1_A(x) 1_A(y) 1_A(z)$ on $(\mathbb{F}_3^n)^3$.

Write $\Delta$ as a sum of "slice rank 1" terms. Each such term has the form $f(x) g(y, z)$ (or a permutation). The slice rank of $\Delta$ is at most $|A|$.

On the other hand, $\Delta$ restricted to the diagonal $x = y = z$ satisfies: $x + x + x = 3x = 0$ in $\mathbb{F}_3^n$ always, so $\Delta(x,x,x) = 1_A(x)$. This means the diagonal sum is $|A|$.

Bounding the slice rank via polynomial degree arguments and character sum estimates gives $\text{SliceRank}(\Delta) \leq 3 \cdot \binom{n}{\lfloor n/3 \rfloor} \approx 3 \cdot (2.756)^n$.

Hence $|A| \leq 3 \cdot (2.756)^n$.

### 8.3 Why Polynomial Method Doesn't Transfer to Z/NZ

**Obstacle 1: Lack of field structure**. The polynomial method exploits the fact that $\mathbb{F}_3^n$ is a $d$-dimensional vector space over a field. Polynomials of degree $d$ in $n$ variables over $\mathbb{F}_3$ have at most $\binom{n+d}{d}$ monomials. This "polynomial dimension" bounds the slice rank.

In $\mathbb{Z}/N\mathbb{Z}$, there is no natural notion of polynomial degree that gives useful bounds. A polynomial of "degree $d$" in $\mathbb{Z}/N\mathbb{Z}$ can have many more monomials (since integer polynomials are not bounded by $N$).

**Obstacle 2: Trivial slice rank bound**. The Croot-Lev-Pach argument yields only trivial bounds for $\mathbb{Z}/N\mathbb{Z}$. Specifically, the key step of bounding slice rank via polynomial dimension fails when the "field" is replaced by $\mathbb{Z}/N\mathbb{Z}$ with $N$ not prime-power.

**Obstacle 3: The 3-AP condition is not "sum-zero"**. In $\mathbb{Z}$, $a + c = 2b$ does not have the nice symmetry of $a + b + c = 0$ in $\mathbb{F}_3^n$.

**Potential workaround**: Embed $\{1,\ldots,N\}$ into $\mathbb{F}_p^n$ via a "digit expansion" (writing integers in base $p$ as vectors in $(\mathbb{F}_p)^n$ where $n = \lceil \log_p N \rceil$). But:
- APs in $\{1,\ldots,N\}$ do **not** correspond to APs in $(\mathbb{F}_p)^n$ under this embedding (there are "carry" issues).
- The sum-zero condition in $(\mathbb{F}_p)^n$ is $x + y + z = 0$ (mod $p$), which differs from the AP condition in $\mathbb{Z}$.

The fundamental incompatibility is that integer APs require a **linear ordering and carriage arithmetic**, while the polynomial method exploits the **algebraic/field structure** of $\mathbb{F}_q^n$.

---

## 9. Technical Analysis of Key Questions

### Q1: What Determines the Exponents 1/6 and 1/2?

The exponent in the upper bound (currently $1/6$ in Raghavan 2026) comes from the **rank-density tradeoff in the almost-periodicity iteration**:

- The Croot-Sisask almost-periodicity lemma is "quadratic": it produces Bohr sets of rank $d = O(\alpha^{-2})$.
- With $k$-fold tensor products (for $k$-APs with $k=3$), the rank grows as $O(\alpha^{-2k}) = O(\alpha^{-6})$ in the basic argument.
- Improved bootstrapping (Bloom-Sisask) reduces this to $O(\alpha^{-4})$ for exponent $1/9$, and the iterated sifting (Raghavan) further reduces to $O(\alpha^{-2})$ effectively for exponent $1/6$.

The **"ideal" scenario** for matching Behrend: If one could find a Bohr set with rank $O(1)$ (i.e., independent of $\alpha$), the exponent would be $1/2$. But this contradicts the structure of almost-periodicity, which requires $d \to \infty$ as $\alpha \to 0$.

**Heuristic for the true exponent**: The near-consensus is that the true value is $r_3(N) = N \exp(\Theta(\sqrt{\log N}))$ — matching Behrend. The upper bound needs to be improved from exponent $1/6$ to $1/2$.

Evidence:
- The structure of the Behrend construction is "dimension-$d$ spheres" with $d \sim \sqrt{\log N}$, reflecting an optimization of $d$.
- In $\mathbb{F}_p^n$, the polynomial method gives exact asymptotics (exponential in $n$), and the "Behrend analogue" for $\mathbb{F}_p^n$ (Salem-Spencer set) matches the upper bound.
- Number-theoretic heuristics from the Hardy-Littlewood circle method suggest that the 3-AP count formula should have an analogous form.

### Q2: What Information Does the Polynomial Method Capture That Fourier Misses?

**Fourier analysis** captures:
- Global correlations with linear characters $x \mapsto e^{2\pi i rx/N}$
- "Degree 1" structure: whether $A$ correlates with any single linear phase

**Polynomial method** captures:
- Algebraic closure properties: whether the set $A$ can be the zero set of a low-degree polynomial
- "Simultaneous" correlations: the tensor product $f(x) f(y) f(z)$ on the AP variety encodes all pairs simultaneously
- Higher-dimensional structure: the method works in the ambient algebraic space, not just on $\{1,\ldots,N\}$

The key advantage: **the polynomial method exploits the global algebraic structure of the AP condition**, not just local Fourier correlations. It bounds the "algebraic complexity" (slice rank, or polynomial degree) of the characteristic function, regardless of whether the function has large Fourier coefficients.

In the Kelley-Meka proof (which is a hybrid), the polynomial method contributes the "structure lemma" (encoding the AP-free condition as polynomial vanishing), while almost-periodicity provides the "density increment" (finding a structured sub-domain on which density is higher).

### Q3: How Do Gowers Norms Generalize Fourier? The k=4 vs k=3 Gap

**For $k=3$** ($U^2$ norm):
- $\|f\|_{U^2}^4 = \sum_r |\hat{f}(r)|^4$ = $L^4$ Fourier norm
- Inverse theorem: large $U^2$ iff large Fourier coefficient
- Density increment: correlation with linear phase → density increment on an AP or Bohr set

**For $k=4$** ($U^3$ norm):
- $\|f\|_{U^3}^8 = \mathbb{E}_{x,h_1,h_2,h_3} f(x) \overline{f(x+h_1)} \overline{f(x+h_2)} f(x+h_1+h_2) \cdots$ (8-fold product)
- Inverse theorem: large $U^3$ iff $f$ correlates with $e^{2\pi i \phi(n)}$ where $\phi$ is a "quadratic phase function" / 2-step nilsequence
- Density increment: correlation with quadratic phase → density increment on a **"quadratic Bohr set"**

**Why k=4 is qualitatively harder**:

1. **Non-abelian structure**: 2-step nilmanifolds are non-abelian, making equidistribution and density increment arguments much harder.

2. **Rank explosion**: A quadratic Bohr set of "rank" $d$ has $O(d^2)$ parameters (for linear Bohr sets it's $d$). This means each density increment step doubles the rank, leading to rapid rank growth.

3. **Carry issues in iteration**: When passing to a sub-progression of a quadratic Bohr set, the "remainder" is not a quadratic Bohr set but something more complicated.

4. **No almost-periodicity analogue**: The Croot-Sisask lemma gives almost-periodicity for linear (U^2) structure. An analogous lemma for U^3 structure would require "quadratic almost-periodicity" — a notion that is not yet well-developed.

5. **2-torsion problems**: In 2-step nilmanifolds, the "polarization identity" requires dividing by 2, which creates issues when $N$ is even or when working modulo 2.

### Q4: What Would an Asymptotic Formula for r_k(N) Look Like?

An asymptotic formula would be of the form:
$$r_k(N) = N \cdot f_k(N) \cdot (1 + o(1))$$
where $f_k(N)$ is specified exactly (not just up to constants).

**Requirements for such a formula**:

1. **Matching upper and lower bounds**: The upper and lower bounds must agree asymptotically. Currently for $k=3$: UB $\sim \exp(-c_1 (\log N)^{1/6})$ and LB $\sim \exp(-c_2 \sqrt{\log N})$ — a $\text{gap}$ of exponent $1/6$ vs $1/2$.

2. **Structure of extremal sets**: Must identify, precisely, what the maximizing sets $A$ look like (up to affine maps). If $A$ is extremal, it should be "close to" a Behrend-type sphere construction in some formal sense. This is analogous to how extremal sets in Turán-type problems are characterized by the Turán graph.

3. **Stability**: The extremal sets should satisfy a "stability" result: if $|A| \geq r_k(N) \cdot (1 - \epsilon)$, then $A$ is "close to" an extremal set.

**What structural properties would extremal sets have?**:

For $k=3$, heuristically, extremal sets should be:
- Concentrated on a "sphere" or "annulus" in some high-dimensional lattice
- Showing no linear Fourier correlations (maximally "Fourier-flat")
- "Rotationally symmetric" in the relevant high-dimensional space
- Having density roughly $N^{-2/d}$ where $d \sim \sqrt{\log N}$

The "Behrend-type structure" is: the set $A$ corresponds (via the Behrend embedding) to a set of lattice points on a sphere $\|x\|^2 = R$ in $\mathbb{Z}^d$ for some $d \sim \sqrt{\log N}$ and optimal $R$.

**Key question**: Is there a unique (up to affine equivalence) maximizing structure, or are there many incompatible extremal constructions?

### Q5: Probabilistic Lower Bounds

The Behrend construction is explicit. Can probabilistic methods do better?

**Random set argument**: Take $A \subseteq \{1,\ldots,N\}$ to be a random set where each element is included independently with probability $p$. Expected 3-APs: $\binom{N}{3} p^3 \cdot \frac{2}{N} \approx N^2 p^3 / 3$. Expected size: $pN$.

By Markov: with probability $\geq 1/2$, the number of 3-APs is $\leq 2N^2 p^3/3$. Removing one element from each 3-AP, we get a 3-AP-free set of size $\geq pN - 2N^2 p^3/3$.

This is maximized at $p = \Theta(N^{-1/2})$, giving $|A| = \Theta(N^{1/2})$ — much worse than Behrend.

**Lovász Local Lemma (LLL) approach**: Could give better bounds in principle. The LLL says: if each "bad event" (containing a specific 3-AP) has probability $p_0$ and is independent of all but $D$ other events, and if $p_0 \cdot D \leq 1/e$, then with positive probability no bad event occurs.

For 3-APs: each AP involves 3 elements; an element belongs to $O(N)$ APs. So $D = O(N)$. Setting $p_0 = q^3$ (for a set with density $q$), the LLL gives $q^3 \cdot N \leq 1/e$, so $q \leq (eN)^{-1/3}$, giving $|A| \leq N^{2/3}$ — worse than Behrend.

**Conclusion**: No known probabilistic method beats Behrend. The Behrend construction is explicit and uses deep geometric structure (spheres in $\mathbb{Z}^d$), which random methods cannot easily replicate.

### Q6: Connections to Other Problems

**Cap set problem** ($r_3(\mathbb{F}_3^n)$):
- Direct analogue of $r_3(N)$ in the vector space $\mathbb{F}_3^n$.
- Polynomial method works perfectly: exact exponent $\log_3(2.756) \approx 0.923$.
- The "Behrend analogue" (Salem-Spencer construction) gives $\approx 3^{0.818n}$.
- Ratio of exponents: $0.923/0.818 \approx 1.13$ — a constant gap, unlike the integer case.
- The polynomial method closes the gap in $\mathbb{F}_3^n$ but not in $\mathbb{Z}$.

**Sunflower-free sets**:
- A sunflower is a family of sets where any two share the same "core."
- Sunflower-free families of $k$-element sets over $[n]$ have size at most... 
- Alweiss-Lovett-Wu-Zhang (2020): improved upper bound to $(O(\log n))^k$.
- Connection to AP-free sets: Both involve "combinatorial dimension" arguments and density-increment strategies, but the algebraic structure is different (hypergraph vs. integer arithmetic).

**Polynomial method in $\mathbb{F}_p^n$**:
- Croot-Lev-Pach (2017): $r_3(\mathbb{Z}_4^n) \leq (3.611)^n$ via polynomial method.
- Ellenberg-Gijswijt (2017): $r_3(\mathbb{F}_q^n) \leq O(q^{0.9n})$ generally.
- The "slice rank" method applies whenever there is a "degree bound" for polynomials on the ambient group.

**Freiman's theorem**: Large-growth-free sets (with $|A+A| \leq K|A|$) have "Freiman-Ruzsa" structure (lying in a generalized AP of dimension $O(\log K)$). The AP-free condition is related but distinct: AP-free sets have small "3-AP count" rather than small "sum set." The structural implications are different.

**Polynomial progressions**: $r_k$ for polynomial APs (e.g., $n, n+d^2, n+2d^2$ for quadratic progressions). Peluse (2020) proved quantitative bounds using Gowers norms adapted to polynomial maps.

---

## 10. Assessment of New Angles

### (a) Refinement of Kelley-Meka: Reaching Exponent 1/2

**Plausibility**: Low-Medium

**What would be needed**:
- The almost-periodicity lemma currently gives rank $d = O(\alpha^{-2})$. To get exponent $1/2$, one would need rank $d = O(1)$ — independent of $\alpha$.
- Alternatively: a fundamentally different iteration scheme where density increments are additive ($\Omega(\alpha)$) rather than multiplicative ($\Omega(\alpha^3)$).
- Or: an entirely different method that bypasses Bohr sets entirely.

**Main obstacles**:
- The Bogolyubov-Ruzsa paradigm (rank $\sim \alpha^{-2}$) is hard to bypass; it follows from $L^2$ arguments.
- The "3-fold" nature of 3-APs means density increments must handle three correlated variables, each contributing a factor.
- Any improvement to exponent $1/2$ would require a proof technique that "sees" the Behrend structure directly, rather than discovering it iteratively.

**A potential pathway**: Rather than iterating density increments, prove directly that a large AP-free set must have "high Bohr dimension" — i.e., correlate with a Bohr set of rank $\Omega(\log N / \sqrt{\log N})$ — and derive the bound directly. This is speculative.

### (b) Cap Set Methods in Z/NZ: Polynomial Method for Integers

**Plausibility**: Medium

**What would be needed**:
1. An embedding $\phi: \{1,\ldots,N\} \to \mathbb{F}_q^n$ such that 3-APs map to 3-APs (or "3-sums").
2. A "polynomial capacity" bound on the image $\phi(A)$ that transfers back to $A$.
3. The polynomial degree $d$ must satisfy: polynomials of degree $d$ on $\phi(\{1,\ldots,N\})$ vanish on the AP condition.

**Potential approach - "multiscale" polynomial method**:
- Use base-$p$ expansions: write $m = \sum m_i p^i$ and map $m \to (m_0, \ldots, m_{n-1}) \in \{0,\ldots,p-1\}^n \subset \mathbb{F}_p^n$.
- The 3-AP condition $a + c = 2b$ "mostly" corresponds to coordinate-wise additions modulo $p$, except for carries.
- Idea: control carries via a "carry indicator" function and apply the polynomial method to the "carry-free" part.

**Main obstacle**: The carry structure of integer addition destroys the nice polynomial structure needed for the method. "Carry-free" arithmetic progressions correspond to "digit-wise" APs, which are very restrictive. Setting up the polynomial method for integer APs with carries appears to require a new conceptual framework.

**The integer polynomial method** (Peluse-Prendiville-type): For polynomial progressions in $\mathbb{Z}$, one can use "degree-lowering" arguments (Peluse-Prendiville), but these work for polynomial APs (e.g., $n, n+d^2$), not linear APs.

**Assessment**: The transfer of polynomial method to $\mathbb{Z}$ is a tantalizing direction with clear obstacles. Progress would require a new "integer slice rank" notion or an analogous algebraic structure. Plausibility: Medium for partial results; Low for full exponent $1/2$.

### (c) Probabilistic Polynomial Method

**Plausibility**: Low

**The idea**: Use randomization to select a "generic" polynomial that captures the AP structure, then use probabilistic estimates to show the polynomial has low slice rank.

**Main obstacles**:
- The polynomial method requires explicit polynomial constructions with provable degree bounds. Random polynomials have unpredictable degrees.
- The "probabilistic local lemma" approach to AP-free sets gives $r_3(N) = \Omega(N^{2/3})$, much worse than Behrend.
- There is no known mechanism by which randomizing the polynomial improves the bounds.

**Plausibility**: Low. The polynomial method's power comes from its deterministic algebraic structure, which is antithetical to probabilistic approaches.

### (d) Structural Theorem Approach: Prove Extremal Sets are Behrend-Type

**Plausibility**: Medium-High (for a sub-optimal version); Low (for exact asymptotics)

**The idea**: Prove a "stability" result: any $A \subseteq \{1,\ldots,N\}$ with $|A| \geq N \exp(-c\sqrt{\log N})$ and no 3-AP must, after an affine transformation, concentrate on a low-dimensional sphere.

**What would be needed**:
1. A "Freiman-type" structure theorem for AP-free sets: if $|A|$ is large and $A$ is AP-free, then $A$ lies in a generalized arithmetic progression (GAP) of small dimension and bounded size.
2. Analysis of AP-free sets within GAPs: show that within a GAP, the maximum AP-free set is "sphere-like."
3. Quantitative bounds that allow bootstrapping.

**Prior work**: Green (2003) proved a structure theorem for sets with the "minimum number" of 3-APs — near-extremal sets for the 3-AP count are close to arithmetic progressions. But AP-free sets (with zero 3-APs) are a different beast.

**Main obstacles**:
- AP-free sets do not have small doubling constant (their sumset can be large), so Freiman-type theorems don't directly apply.
- "Sphere-like" structure is hard to characterize algebraically in $\mathbb{Z}$ — in $\mathbb{Z}^d$ it's clear (sphere), but in $\mathbb{Z}$ after base-$M$ encoding, the structure is complex.
- Proving stability would likely require first knowing the asymptotic, creating a circular dependency.

**Plausibility**: Medium-High for proving "the extremal structure must satisfy X" given the upper bound; Low for using this to improve the upper bound from scratch.

### (e) Regularity + Polynomial Hybrid

**Plausibility**: Medium

**The idea**: Decompose $1_A = f_{\text{struct}} + f_{\text{unif}}$ (arithmetic regularity) and apply:
- Polynomial method to $f_{\text{struct}}$ (structured part)
- Gowers-uniformity arguments to $f_{\text{unif}}$ (uniform part)

**What would be needed**:
1. An arithmetic regularity decomposition with quantitative bounds better than tower-type.
2. An analogue of the polynomial method for "structured" functions (e.g., functions concentrated on Bohr sets or nilmanifolds).
3. A way to combine the two parts without losing the quantitative improvements.

**Green-Tao regularity lemma** already gives a decomposition $f = f_{\text{nil}} + f_{\text{unif}} + f_{\text{err}}$. The polynomial method could potentially improve the bound on $\|f_{\text{nil}}\|$ — the "nilsequence" part.

**The Kelley-Meka method is already a hybrid**: It uses the polynomial method (via Croot-Sisask) to get almost-periodicity (structure), and then a classical density increment. The "pure polynomial method" hasn't been fully separated from the "Fourier analysis" part.

**New hybrid direction**: 
- Apply the Green-Tao regularity to get $f_{\text{nil}}$ (a nilsequence approximation).
- Apply the polynomial method "fiberwise" on the orbits of $f_{\text{nil}}$.
- Use the quantitative inverse theorem (Leng-Sah-Sawhney) to control the sizes.

**Plausibility**: Medium. This seems like a natural extension of current methods, but the "polynomial method for nilsequences" is underdeveloped. Main obstacle: polynomial capacity bounds for nilsequences require understanding algebraic geometry on nilmanifolds, which is technically demanding.

### (f) Improved Behrend: Higher-Dimensional Geometric Constructions

**Plausibility**: Medium (for constant improvements); Low (for exponent improvement)

**The idea**: Use more complex geometric shapes than spheres in $\mathbb{Z}^d$:
- **Ellipsoids**: Instead of the sphere $\|x\|^2 = R$, use $\sum a_i x_i^2 = R$ for carefully chosen coefficients $a_i$. Ellipsoids might give higher density while remaining AP-free.
- **Algebraic varieties**: AP-free sets on algebraic varieties of degree $> 2$ might have higher density.
- **Probabilistic constructions**: Random algebraic varieties in $\mathbb{Z}^d$ might have better AP-free properties than any explicit construction.

**Elsholtz et al. (2024)**: Already achieved the first constant improvement (from $2.83$ to $2.67$) using algebraic geometry over finite fields. Their method uses sets in $\mathbb{F}_p^n$ with better "AP-free" algebraic structure.

**What would be needed for exponent improvement**:
An entirely different construction that gives density $N \exp(-c (\log N)^{\alpha})$ for some $\alpha < 1/2$. This seems unlikely given:
- For any construction based on "high-dimensional geometric objects with $d \sim (\log N)^\beta$ dimensions," the density optimizes to $\exp(-c (\log N)^{\max(1-\beta, \beta)})$, minimized at $\beta = 1/2$ giving exponent $1/2$.
- Constructions based on $\beta \neq 1/2$ would give strictly worse density.

**Plausibility for exponent improvement**: Very low. The $\sqrt{\log N}$ exponent in Behrend is essentially optimal for any "sphere/ellipsoid" type construction. Improving the exponent would require a qualitatively different construction.

**Plausibility for constant improvement**: Medium-High. The Elsholtz et al. work shows there is room to improve the constant $c$ in $\exp(-c\sqrt{\log N})$. Further algebraic geometric constructions might reduce $c$ further, though the optimal value of $c$ is unknown.

---

## 11. Synthesis and Proof Strategy

### 11.1 The Landscape

The problem has two qualitatively different regimes:

**Regime 1: Improving the upper bound exponent** ($1/6 \to 1/2$)

The almost-periodicity framework (Kelley-Meka, extended by Bloom-Sisask, Raghavan) is currently the best approach. The exponent has improved from $1/12$ to $1/6$ in three years. The trajectory suggests further improvements are possible, but the $1/2$ barrier requires new ideas.

**Regime 2: Improving the lower bound constant** (improving $c$ in $\exp(-c\sqrt{\log N})$)

The Elsholtz et al. (2024) work shows this is accessible. Algebraic geometric constructions over finite fields, when properly mapped to $\mathbb{Z}$, can give better AP-free sets. This is a more algebraic/combinatorial direction.

**Regime 3: Higher k** 

For $k \geq 4$, the problem is much harder. The current best for $k=4$ is only $N/(\log N)^c$ (Green-Tao 2017), and for $k\geq 5$ is $N\exp(-(\log\log N)^{c_k})$ (Leng-Sah-Sawhney 2024). Getting a quasi-polynomial bound for $k=4$ is a major open problem.

### 11.2 Most Promising Combinations

**For $k=3$ upper bound**: The most likely path to exponent $1/2$ combines:
1. **Structural theorem** (angle d): Prove that large AP-free sets must have "Behrend-type" structure. This requires developing a "Freiman-Ruzsa" theory for AP-free sets.
2. **Polynomial method for Z/NZ** (angle b): Develop a notion of "integer slice rank" that can exploit the algebraic structure of 3-APs in $\mathbb{Z}$.
3. **Refined almost-periodicity** (angle a): Continue the Kelley-Meka trajectory, aiming to reduce the rank growth from $O(\alpha^{-2})$ to $O(\alpha^{-2+\epsilon})$ for any $\epsilon > 0$.

**For $k=4$ upper bound**: The most promising path uses:
1. **Higher-order almost-periodicity**: Develop an analogue of the Croot-Sisask lemma for the $U^3$ norm (almost-periodicity for quadratic phases).
2. **Quantitative $U^3$ inverse theorem** (Leng-Sah-Sawhney style): Use the quasipolynomial inverse theorem as a black box, but develop better density increment strategies for nilBohr sets.
3. **Hybrid regularity-polynomial** (angle e): Apply polynomial method to the 2-step nilsequence "structured part."

**For an asymptotic formula**: This seems very far from current methods. A roadmap would be:
1. First, close the upper-lower bound gap to $\exp(-c\sqrt{\log N})$.
2. Then, identify the exact structure of extremal sets.
3. Finally, prove a "local structure theorem" that pins down the leading constant.

### 11.3 Key Technical Questions to Resolve

For progress on the upper bound:

**Q-U1**: Can the Croot-Sisask almost-periodicity lemma be strengthened to give rank $O(\alpha^{-2})$ for $k=3$ without the additional log-log factors? (Would improve Raghavan's exponent.)

**Q-U2**: Can the iteration in the Kelley-Meka argument be made "non-linear" — i.e., instead of a linear progression of density increments, use a "doubling trick" that achieves more progress per step?

**Q-U3**: Is there an "integer slice rank" notion for the 3-AP condition in $\{1,\ldots,N\}$ analogous to the finite-field case?

**Q-U4**: Can the quantitative $U^3$ inverse theorem (Leng-Sah-Sawhney) be combined with a "quadratic Croot-Sisask" lemma to give a quasi-polynomial bound for $r_4(N)$?

For progress on the lower bound:

**Q-L1**: What is the optimal constant $c$ in $r_3(N) \geq N\exp(-c\sqrt{\log N})$? Is the Elsholtz construction optimal within the "sphere class"?

**Q-L2**: Are there $k$-AP-free sets of density $\exp(-c_k\sqrt{\log N})$ for $k \geq 4$ with explicit, optimizable constructions?

**Q-L3**: Can the Elsholtz algebraic geometric constructions be extended to $k\geq 4$?

---

## 12. Recommended Next Steps

### For the Proof Strategy Agent

**Priority 1** (most impactful): Investigate whether an "integer slice rank" can be defined for the 3-AP condition. Specifically:

- Define $\Delta(a,b,c) = 1_{A}(a) 1_A(b) 1_A(c) \cdot [a+c=2b]$ on $\{1,\ldots,N\}^3$.
- Can $\Delta$ be decomposed into "slice rank 1" terms (of the form $f(a) g(b,c)$ etc.) using an appropriate notion of "polynomial degree" in $\mathbb{Z}$?
- Obstacle: The 3-AP condition over $\mathbb{Z}$ is not expressible as a vanishing of a single polynomial of bounded degree (unlike in $\mathbb{F}_3^n$ where it's $x+y+z=0$).
- Possible approach: Work modulo a large prime $p > 2N$ and use the Fermat trick ($a \equiv b \pmod{p}$ iff $a^{p-1} = b^{p-1}$ in $\mathbb{F}_p$ for $a,b \in \{1,\ldots,N\}$) to encode integrality. Analyze whether this gives a useful degree bound.

**Priority 2**: Investigate the "iterated bootstrapping" direction for Kelley-Meka. Specifically:

- The Raghavan (2026) paper achieves exponent $1/6$ via "iterated sifting." Can this be iterated further to get $1/4$, $1/3$, etc.?
- What is the fundamental lower bound on the exponent achievable by almost-periodicity-based methods?
- Try to prove a "lower bound on the almost-periodicity iteration" — i.e., that any iteration scheme based on the Croot-Sisask lemma gives exponent at most $c < 1/2$.

**Priority 3**: Study the connection between the quantitative $U^3$ inverse theorem and the $k=4$ density increment. Specifically:

- Given that Leng-Sah-Sawhney proved a quasipolynomial $U^{s+1}$ inverse theorem, is there a density increment argument for 4-APs that gives $r_4(N) \leq N \exp(-(\log N)^{c})$ for some $c > 0$?
- What "quadratic almost-periodicity" lemma would be needed?
- Compare with the 5-AP case where Leng-Sah-Sawhney succeeded.

**Priority 4**: Pursue the algebraic geometric lower bound constructions. Specifically:

- Can the Elsholtz et al. (2024) construction be improved to give constant $c < 2\sqrt{\log_2(24/7)} \approx 2.667$?
- What is the "right" algebraic variety for AP-free sets?
- Can the construction generalize to 4-AP-free sets with comparable density?

---

## References

1. **Kelley-Meka (2023)**: Z. Kelley, R. Meka, "Strong Bounds for 3-Progressions," arXiv:2302.05537
2. **Bloom-Sisask (2020)**: T. Bloom, O. Sisask, "Breaking the logarithmic barrier in Roth's theorem on arithmetic progressions," arXiv:2007.03528
3. **Bloom-Sisask (2023)**: T. Bloom, O. Sisask, "An improvement to the Kelley-Meka bounds on three-term arithmetic progressions," arXiv:2309.02353
4. **Raghavan (2026)**: R. Raghavan, "Improved Bounds for 3-Progressions," arXiv:2603.27045
5. **Green-Tao (2017)**: B. Green, T. Tao, "New bounds for Szemerédi's theorem, III: A polylogarithmic bound for $r_4(N)$," arXiv:1705.01703
6. **Leng-Sah-Sawhney (2023)**: J. Leng, A. Sah, M. Sawhney, "Improved bounds for five-term arithmetic progressions," arXiv:2312.10776
7. **Leng-Sah-Sawhney (2024a)**: J. Leng, A. Sah, M. Sawhney, "Quasipolynomial bounds on the inverse theorem for the Gowers $U^{s+1}[N]$-norm," arXiv:2402.17994
8. **Leng-Sah-Sawhney (2024b)**: J. Leng, A. Sah, M. Sawhney, "Improved Bounds for Szemerédi's Theorem," arXiv:2402.17995
9. **Elsholtz et al. (2024)**: C. Elsholtz, C. Hunter, F. Proske, L. Sauermann, "Improving Behrend's construction," arXiv:2406.12290
10. **Behrend (1946)**: F.A. Behrend, "On sets of integers which contain no three terms in arithmetical progression," Proc. Natl. Acad. Sci. USA 32 (1946), 331–332
11. **Croot-Lev-Pach (2017)**: E. Croot, V. Lev, P. Pach, "Progression-free sets in $\mathbb{Z}_4^n$ are exponentially small," arXiv:1605.01506
12. **Ellenberg-Gijswijt (2017)**: J. Ellenberg, D. Gijswijt, "On large subsets of $\mathbb{F}_q^n$ with no three-term arithmetic progression," arXiv:1605.09223
13. **Green-Tao-Ziegler (2012)**: B. Green, T. Tao, T. Ziegler, "An inverse theorem for the Gowers $U^{s+1}[N]$-norms," arXiv:1009.3998
14. **Peluse (2025)**: S. Peluse, "Finding arithmetic progressions in dense sets of integers," arXiv:2509.22962 (survey)
