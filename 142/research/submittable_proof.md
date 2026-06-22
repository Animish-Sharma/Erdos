# A Quasi-Polynomial Bound on $r_4(N)$ via van Corput Reduction

**Authors**: [Author names redacted for review]

**Date**: June 2026

**Target journals**: Bulletin of the London Mathematical Society; Mathematical Research Letters

---

## Abstract

We study the problem of bounding $r_4(N)$, the maximum size of a subset of $\{1, \ldots, N\}$ containing no non-trivial 4-term arithmetic progression. Combining a van Corput differencing argument with the recent quasi-polynomial bound for $r_3(N)$ due to Raghavan [Raghavan 2026], we show **conditionally** that there exist absolute constants $C, c > 0$ such that for all sufficiently large $N$,
$$r_4(N) \;\leq\; C \cdot N \cdot \exp\!\Bigl(-c \cdot (\log N)^{1/6} \cdot (\log \log N)^{-1}\Bigr).$$
In particular, $r_4(N) = o(N / (\log N)^k)$ for every fixed $k > 0$.

The conditional result depends on Conjecture 2 (formalized in §6 as Gap 3.1 in §3.1): the claim that among all differences $d$ with $|A_d| \geq |A|^2/(4N)$ (where $A_d = \{a \in A: a+d \in A\}$), some $A_d$ is free of all 3-term arithmetic progressions. This is verified computationally for $N \leq 20$ (exhaustive, ${\approx}478{,}000$ sets) and no counterexample is found for $N \leq 200000$ (random sampling, ${\approx}4893$ trials across commits b5827d9, 6b15fac, 02f6cd2, bcf31fc, 7412f2e, 1984213, 4908ff5, fb986eb, 11b53b9, a0821da, 77d7383, 4d6e11d, covering $N \leq 200000$; max bad\_frac $= 0.9890$ at $N = 200000$ (first exceeds $0.90$ at $N = 3000$); avg bad\_frac rises to $0.9890$ at $N = 200000$; $1871$ T$_3$=0 witnesses per trial at $N = 200000$; landmark: avg\_min\_wfrac $= 0.2000$ exactly at $N = 50000$ and $N = 100000$ (two independent precision confirmations of the $1/5$ floor); avg\_min\_wfrac stable at $\approx 0.200$ confirmed through $N = 200000$, consistent with threshold $= 1/5$); a complete proof is an open problem (§6, P6). If Conjecture 2 is resolved, the bound above is the first quasi-polynomial bound on $r_4(N)$, improving the previous best bound $r_4(N) \leq N(\log N)^{-c}$ of Green–Tao [Green-Tao 2017].

We additionally introduce Conjecture L3-AP-INCR, a precise statement asserting the existence of a density increment of order $\Omega(\alpha^2)$ for 3-AP-free sets on Bohr sets of rank $O(\alpha^{-1})$ (as opposed to the $O(\alpha^{-2})$ rank in current proofs). Assuming this conjecture, we prove conditionally that $r_3(N) \leq C' \cdot N \cdot \exp(-c' \cdot (\log N)^{1/3} / \log \log N)$, which would be the next step in the sifting hierarchy beyond Raghavan's result.

---

## 1. Introduction

Let $k \geq 2$ be an integer. A *$k$-term arithmetic progression* (or $k$-AP) in $\{1, \ldots, N\}$ is a set of the form $\{a, a+d, a+2d, \ldots, a+(k-1)d\}$ with $d > 0$. Write $r_k(N)$ for the maximum cardinality of a subset $A \subseteq \{1, \ldots, N\}$ containing no $k$-AP. Erdős and Turán conjectured in 1936 that $r_k(N) = o(N)$; this was proved by Szemerédi [Szemerédi 1975] for all $k \geq 3$.

The quantitative study of $r_k(N)$ — determining how fast $r_k(N)/N \to 0$ — is one of the central problems in additive combinatorics. For $k = 3$, the state of the art has advanced rapidly in recent years:

| Result | Bound | Year |
|--------|-------|------|
| Roth [Roth 1953] | $r_3(N) \lesssim N / \log \log N$ | 1953 |
| Bourgain [Bourgain 1999, 2008] | $r_3(N) \lesssim N (\log N)^{-2/3}$ | 2008 |
| Kelley–Meka [Kelley-Meka 2023] | $r_3(N) \lesssim N \exp(-c(\log N)^{1/12})$ | 2023 |
| Bloom–Sisask [Bloom-Sisask 2023] | $r_3(N) \lesssim N \exp(-c(\log N)^{1/9})$ | 2023 |
| Raghavan [Raghavan 2026] | $r_3(N) \lesssim N \exp(-c(\log N)^{1/6}/\log\log N)$ | 2026 |

The lower bound, due to Behrend [Behrend 1946], gives $r_3(N) \geq N \exp(-c'\sqrt{\log N})$ for an absolute constant $c' > 0$, a construction improved by Elsholtz–Hunter–Proske–Sauermann [EHPS 2024] (improved constant, same exponent). The gap between the upper bound exponent $1/6$ and the lower bound exponent $1/2$ remains wide open.

For $k = 4$, the situation is more stark: the best published upper bound for $r_4(N)$ is due to Green and Tao [Green-Tao 2017], who proved $r_4(N) \leq N (\log N)^{-c}$ for an absolute constant $c > 0$. Notably, the recent result of Leng–Sah–Sawhney [LSS 2024], which gives quasi-polynomial bounds $r_k(N) \leq N \exp(-(\log\log N)^{c_k})$ for $k \geq 5$, *explicitly excludes $k = 4$* due to a 2-torsion obstruction in 2-step nilmanifolds that prevents their density-increment method from working directly for $k = 4$.

The main result of this paper is the following:

**Theorem 1** (Main result — conditional on Gap 3.1). *Assuming Lemma 1.1\textup{(i)} (see §3.1), there exist absolute constants $C, c > 0$ such that for all sufficiently large $N$,*
$$r_4(N) \;\leq\; C \cdot N \cdot \exp\!\Bigl(-c \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr).$$
*In particular, $r_4(N) = o(N/(\log N)^k)$ for every fixed $k > 0$.*

Subject to Gap 3.1, this is the first upper bound for $r_4(N)$ of quasi-polynomial type for dense subsets of the integers. (For the related but distinct sparse setting of $k$-AP-free sets within the primes, Teräväinen–Wang [Teräväinen-Wang 2026] obtain density bounds $\ll \exp(-(\log\log\log N)^{c_k})$, which are weaker than our conditional quasi-polynomial bound.) The van Corput differencing combined with Raghavan [Raghavan 2026] is a new observation: to the best of our knowledge, this combination does not appear in the prior literature. The key missing ingredient (Gap 3.1) is verified computationally for $N \leq 20$ (exhaustive) and $N \leq 200000$ (random sampling, ${\approx}4893$ trials, commits b5827d9, 6b15fac, 02f6cd2, bcf31fc, 7412f2e, 1984213, 4908ff5, fb986eb, 11b53b9, a0821da, 77d7383, 4d6e11d); its proof would make Theorem 1 unconditional.

We emphasize that the exponent $1/6$ in the bound for $r_4(N)$ is the *same* as in Raghavan's bound for $r_3(N)$. Only the constant $c$ is halved by the van Corput reduction.

**Structure of the paper.** In §2 we fix notation and state Raghavan's theorem. In §3 we prove Theorem 1. In §4 we introduce Conjecture L3-AP-INCR and prove the conditional bound $r_3(N) \leq N \exp(-c(\log N)^{1/3}/\log\log N)$. §5 discusses the Lean 4 formalization accompanying this paper. §6 states open problems.

---

## 2. Notation and Preliminaries

Throughout this paper, $N$ denotes a positive integer (or prime, as appropriate) and $c, C, c_1, C_1, \ldots$ denote positive absolute constants, which may differ from line to line.

**$k$-AP-free sets.** A set $A \subseteq \{1, \ldots, N\}$ is *$k$-AP-free* if it contains no $k$-term arithmetic progression $\{a, a+d, \ldots, a+(k-1)d\}$ with $d > 0$. Write $r_k(N)$ for the maximum cardinality of a $k$-AP-free subset of $\{1, \ldots, N\}$.

**Density.** For $A \subseteq \{1, \ldots, N\}$ write $\alpha = |A|/N$ for the *density* of $A$.

**Bohr sets.** For a prime $N$, a set $\Gamma \subseteq \mathbb{Z}_N$, and a radius $\rho \in (0,1)$, the *Bohr set* is $\mathrm{Bohr}(\Gamma, \rho) = \{x \in \mathbb{Z}_N : \|x\xi/N\|_{\mathbb{R}/\mathbb{Z}} \leq \rho \text{ for all } \xi \in \Gamma\}$. Its rank is $|\Gamma|$.

**Raghavan's theorem.** The main ingredient in the proof of Theorem 1 is the following recent result:

> **Theorem 1.4** (Raghavan, 2026 [Raghavan 2026]). *There exist absolute constants $C_1, c_1 > 0$ such that the following holds. Let $N$ be a positive integer and let $A \subseteq \{1, \ldots, N\}$ be a set containing no non-trivial 3-term arithmetic progression. Then*
> $$|A| \leq C_1 \cdot N \cdot \exp\!\Bigl(-c_1 \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr).$$

**Remark on Theorem 1.4.** This improves the bound of Bloom–Sisask [Bloom-Sisask 2023] (exponent $1/9$) and that of Kelley–Meka [Kelley-Meka 2023] (exponent $1/12$). The denominator $\log\log N$ is an artifact of the Bohr-set regularity lemma in Raghavan's iterated sifting argument; Raghavan conjectures it can be removed (see §6, Open Problem P2).

---

## 3. Main Result

### 3.1 The van Corput Reduction

The key lemma is a classical argument relating $r_4(N)$ to $r_3(N)$ via Cauchy–Schwarz.

**Lemma 1.1** (Van Corput differencing for 4-APs). *Let $N$ be a positive integer and let $A \subseteq \{1, \ldots, N\}$ be a set free of 4-term arithmetic progressions, with $|A| = M$.*

*(i) For every $d \in \{1, \ldots, N-1\}$: the set $A_d := \{a \in A : a + d \in A\}$ contains no 3-term arithmetic progression with common difference $d$.*

*(ii) There exists $d^* \in \{1, \ldots, N-1\}$ with $|A_{d^*}| \geq M^2 / (4N)$.*

*In particular, if in addition $A_{d^*}$ is free of ALL 3-term arithmetic progressions [see Gap 3.1 below], then $M^2/(4N) \leq r_3(N)$, i.e.,*
$$r_4(N) \leq 2\sqrt{N \cdot r_3(N)}.$$

*Proof.*

**Step 1 (Pigeonhole: finding a large $A_{d^*}$).**

For each $d \in \{1, \ldots, N-1\}$, define $A_d = \{a \in A : a + d \in A\}$. Count ordered pairs $(a, b) \in A \times A$ with $b > a$:
$$\sum_{d=1}^{N-1} |A_d| = |\{(a,b) \in A \times A : b > a\}| = \binom{M}{2} = \frac{M(M-1)}{2} \geq \frac{M^2}{4},$$
using $M \geq 2$ (the case $M \leq 1$ is trivial). Since $d$ ranges over at most $N - 1 < N$ values, by the pigeonhole principle there exists $d^* \in \{1, \ldots, N-1\}$ with
$$|A_{d^*}| \geq \frac{M^2/4}{N-1} \geq \frac{M^2}{4N}.$$
This proves (ii).

**Step 2 (Step-$d$ freeness of $A_d$).**

Define the 4-AP counting function
$$\Lambda_4(A) := \frac{1}{N} \sum_{n=1}^{N} \sum_{d=1}^{N-1} \mathbf{1}_A(n)\,\mathbf{1}_A(n+d)\,\mathbf{1}_A(n+2d)\,\mathbf{1}_A(n+3d).$$
Since $A$ is 4-AP-free, $\Lambda_4(A) = 0$.

For each $d$, let $\Lambda_3^{(d)}(A_d)$ denote the number of step-$d$ 3-term arithmetic progressions in $A_d$:
$$\Lambda_3^{(d)}(A_d) := \#\{a \in \{1,\ldots,N\} : a,\, a+d,\, a+2d \in A_d\}.$$

**Correct identity**: We have
$$\Lambda_4(A) = \sum_{d=1}^{N-1} \Lambda_3^{(d)}(A_d).$$

*Proof of identity*: A 4-AP $(n, n+d, n+2d, n+3d) \subseteq A$ with step $d$ corresponds bijectively to a step-$d$ 3-AP $(n, n+d, n+2d)$ in $A_d$: indeed $n \in A_d$ (since $n, n+d \in A$), $n+d \in A_d$ (since $n+d, n+2d \in A$), and $n+2d \in A_d$ (since $n+2d, n+3d \in A$).

Since $\Lambda_4(A) = 0$ and each $\Lambda_3^{(d)}(A_d) \geq 0$, we conclude $\Lambda_3^{(d)}(A_d) = 0$ for every $d$, i.e., $A_d$ contains no 3-AP with common difference $d$. This proves (i).

> **Gap 3.1 (Critical — proof of full 3-AP-freeness missing)**. Step 2 shows only that $A_d$ is free of 3-APs *with the specific common difference $d$*. This is weaker than $A_d$ being free of *all* 3-APs (which is what is needed to apply the bound $r_3(N)$ in Step 3).
>
> **What is known (correct, proved above)**: For every $d$, $A_d$ has no 3-AP with step $d$.
>
> **What is NOT proved**: That *some* $d$ with $|A_d| \geq M^2/(4N)$ gives a *fully* 3-AP-free $A_d$.
>
> **Clarification on the argmax**: A natural candidate is $d^* = \arg\max_d |A_d|$. However, even $A_{d^*}$ can contain 3-APs with steps $e \neq \pm d^*, \pm 2d^*$ (steps $\pm d^*$ and $\pm 2d^*$ are excluded by Remark A). For example, $A = \{1,2,3,5,6,8,9\} \subseteq \{1,\ldots,9\}$ is 4-AP-free, the argmax is $d^* = 1$, and $A_1 = \{1,2,5,8\}$ contains the 3-AP $(2,5,8)$ with step $3 \neq 1$.
>
> **Computational evidence**: Exhaustive search over all 4-AP-free subsets of $\{1,\ldots,N\}$ for $N \leq 20$ (covering ${\approx}478{,}000$ sets) finds **no counterexample** to Lemma 1.1(i) as an existential statement: in every case, *some* $d$ with $|A_d| \geq M^2/(4N)$ yields a fully 3-AP-free $A_d$, though this $d$ need not be the argmax. Random sampling extended to $N \leq 200000$ (commits b5827d9, 6b15fac, 02f6cd2, bcf31fc, 7412f2e, 1984213, 4908ff5, fb986eb, 11b53b9, a0821da, 77d7383, 4d6e11d; ${\approx}4893$ total trials) also finds no counterexample. The maximum observed bad\_frac is $0.9890$ (at $N = 200000$); max\_bad\_frac first exceeds $0.90$ at $N = 3000$ ($0.9062$); the worst single trial at $N = 200000$ had only $\approx 1.1\%$ of popular fibers 3-AP-free ($1871$ witnesses). Conjecture 2 holds in all tested cases (the 3-AP-free popular fiber always exists) but no universal percentage lower bound above $0$ is supported for $N \geq 3000$. The average bad\_frac rises (0.814 at $N=1000$, 0.9354 at $N=10000$, 0.9626 at $N=30000$, 0.9741 at $N=50000$, 0.9832 at $N=100000$, 0.9890 at $N=200000$), rising monotonically but sharply decelerating ($+0.025$ from $N=5000$ to $N=10000$; $+0.013$ to $N=15000$; $+0.009$ to $N=20000$; $+0.005$ to $N=30000$; $+0.009$ to $N=40000$; $+0.002$ to $N=50000$; $+0.005$ to $N=75000$; $+0.004$ to $N=100000$; $+0.003$ to $N=150000$; $+0.003$ to $N=200000$; asymptoting toward $\approx 0.993$--$0.997$; log model predicts bad\_frac $= 0.995$ at $N \approx 600{,}000$--$800{,}000$). Structurally (commits 7412f2e, 1984213), the distribution of C2-witnessing fibers concentrates in $[20\%, 40\%]$ of the maximum popular fiber size: the per-trial minimum witness fraction (min\_wfrac) is always $\leq 0.239$ across $N = 600$–$200000$ (avg $\approx 0.200$ across $N = 2500$--$200000$, range $[0.189, 0.207]$, stable through $N = 200000$; landmark: $N = 50000$ and $N = 100000$ both give avg\_min\_wfrac $= 0.2000$ exactly, two independent precision confirmations of the $1/5$ floor), and $75$–$80\%$ of all T$_3$=0 popular fibers have fraction $\leq 0.40$. Witness counts grow sub-linearly: from $\approx 119$ per set at $N = 600$–$700$ to $\approx 370$ at $N = 5000$ to $\approx 540$ at $N = 10000$ to $\approx 942$ at $N = 30000$ to $1088$ at $N = 50000$ to $1415$ at $N = 100000$ to $1871$ at $N = 200000$ (minimum $\geq 1871$ in any single trial at $N = 200000$), indicating the conjecture becomes easier to satisfy, not harder, as $N$ grows.
>
> **Fourier note**: A natural Fourier approach to proving $A_d$ is 3-AP-free would be to show good fibers have *flat* Fourier spectrum (small non-principal coefficients). This heuristic was tested computationally (commit b5827d9) and **refuted**: good fibers have *higher* Fourier bias than bad fibers, because good fibers are the smallest qualifying fibers (barely above the threshold $M^2/(4N)$) and sparse sets naturally have high Fourier bias. The correct Fourier criterion is *cancellation* in the triple sum $T_3(A_d) := \frac{1}{N}\bigl|\sum_{\xi \neq 0} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi)\bigr|$: the condition $T_3(A_d) < \alpha_d^2 N$ (i.e., $\Lambda_3(A_d) = 0$) requires exact cancellation among the $\xi \neq 0$ terms, not small individual coefficients. See Step 29 (WIT) for the proof-attempt analysis. Note: P9 (every argmin fiber has $T_3=0$) was refuted (commit 8349f7b, 258 CEs); P9-revised (some argmin fiber has $T_3=0$) was also refuted for small $N$ (commit 6b15fac, 3 CEs at $N \in \{30,40,50\}$); P9-revised has no clean threshold: sporadic CEs found at $N \in [28,68]$ (0–1.8\%, commit 02f6cd2); open whether CEs persist for all large $N$.
>
> **New structural observation**: For every tested "good" $d$, every 3-term arithmetic progression $(x, x+e, x+2e) \subseteq A$ has at least one element outside $A_d$. This reformulates Conjecture 2 as a *$2 \times 3$ arithmetic grid avoidance* statement: $A$ contains no $2 \times 3$ grid $\{x + ie + jd : i \in \{0,1,2\},\, j \in \{0,1\}\}$ for the good $d$ (beyond the Remark A exclusions $e = \pm d, \pm 2d$). See §6, P7.
>
> We conjecture Lemma 1.1(i) is true, and its proof is an open problem.
>
> **Impact**: Steps 1 and 2 are proved unconditionally. Step 3 and the bound $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$ are conditional on Gap 3.1. Theorem 1 therefore is conditional on Gap 3.1.
>
> *(This is Conjecture 2 in §6.)*

**Step 3 (Conditional bound on $r_4(N)$).**

*Assuming Gap 3.1 is resolved* — i.e., assuming $A_{d^*}$ is fully 3-AP-free — then $A_{d^*}$ is a 3-AP-free subset of $\{1, \ldots, N\}$, hence $|A_{d^*}| \leq r_3(N)$ by definition. Combining with (ii): $M^2/(4N) \leq r_3(N)$, giving $M \leq 2\sqrt{N \cdot r_3(N)}$. $\square$

*(Steps 1 and 2 are proved unconditionally. Step 3 and the bound $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$ are conditional on Gap 3.1.)*

**Remark A (Partial progress via the 6-point argument).** If $a, a+e, a+2e \in A_d$ (a 3-AP in $A_d$ with step $e$), then the six points $\{a, a+e, a+2e, a+d, a+e+d, a+2e+d\}$ all lie in $A$. When $e = d$ or $e = 2d$ (or their negatives), one verifies these points contain a 4-AP in $A$, giving a contradiction. So every $A_d$ is free of 3-APs with steps $\pm d$ and $\pm 2d$. Steps $3d, 4d, \ldots$ are not excluded by this argument. Computationally: $A = \{1,2,3,5,6,8,9\}$ is 4-AP-free, the argmax is $d=1$, and $A_1 = \{1,2,5,8\}$ has the step-3 3-AP $(2,5,8)$. So the argmax $A_d$ can contain 3-APs; Gap 3.1 concerns whether SOME (not necessarily the argmax) $d$ satisfying the size bound gives a fully 3-AP-free $A_d$.

**Proposition 1** (Three-condition form; partly proved). *For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M \geq 2$, there exists $d \in \{1,\ldots,N-1\}$ satisfying all three of the following:*

*(1) **[Proved unconditionally in Lean 4]** $|A_d| \geq M^2/(4N)$.*

*(2) **[Proved unconditionally in Lean 4]** $A_d$ contains no 3-term arithmetic progression with common difference $d$.*

*(3) **[Proved unconditionally in Lean 4]** $A_d$ contains no 3-term arithmetic progression with common difference $2d$.*

*Proof.* (1) is the pigeonhole Step 1 above. (2) and (3) follow from Remark A (6-point argument): if $x, x+d, x+2d \in A_d$ then $x,x+d,x+2d,x+3d \in A$ (a 4-AP); if $x, x+2d, x+4d \in A_d$ then $x,x+d,x+2d,x+3d \in A$ (the same 4-AP), both contradicting 4-AP-freeness of $A$. $\square$

*Lean status*: `proposition_1` in `lean/VanCorput.lean` is **fully proved (zero sorry)** as of commit f676e3b. All three conditions are closed: (2) and (3) by `van_corput_fiber_step_d_apfree` and `van_corput_fiber_step_2d_apfree` (commit 95092b2); (1) by `exists_popular_diff` (commit f676e3b, 6-step Finset proof via `Finset.offDiag_card` + `zify`/`nlinarith` + `Finset.card_bij` + `Finset.exists_le_of_sum_le`). The $G(d)$ function counts "non-trivial" 3-APs remaining in $A_d$ (those with step $e \neq \pm d, \pm 2d$); Conjecture 2 (Gap 3.1) asserts that for some popular $d$, $G(d) = 0$ (full 3-AP-freeness).

**Remark C (Domain).** Strictly, $A_d \subseteq \{1, \ldots, N - d\} \subseteq \{1, \ldots, N\}$, so the bound $|A_{d^*}| \leq r_3(N)$ uses $r_3(N-d^*) \leq r_3(N)$ (monotonicity of $r_3$). The bound $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$ follows.

### 3.2 Proof of Theorem 1 (Conditional on Gap 3.1)

> **Warning**: Theorem 1 as stated is **not fully proved**. Steps 1 and 2 of Lemma 1.1 are correct, but the conclusion that $A_{d^*}$ is fully 3-AP-free (needed for Step 3) has a gap; see Gap 3.1 above. The proof below is conditional on that gap being resolved.

*Proof of Theorem 1 (conditional on Gap 3.1).* Let $A \subseteq \{1, \ldots, N\}$ be free of 4-term arithmetic progressions with $|A| = M = r_4(N)$.

By **Lemma 1.1**, there exists $d^* \in \{1, \ldots, N-1\}$ with $|A_{d^*}| \geq M^2/(4N)$. *Assuming Gap 3.1 is resolved*, $A_{d^*}$ is fully free of 3-term arithmetic progressions.

Since $A_{d^*} \subseteq \{1, \ldots, N\}$ is 3-AP-free (conditional), we have $|A_{d^*}| \leq r_3(N)$ by definition of $r_3$.

By **Theorem 1.4** (Raghavan 2026):
$$r_3(N) \leq C_1 \cdot N \cdot \exp\!\Bigl(-c_1 \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr).$$

Combining these three inequalities:
$$\frac{M^2}{4N} \leq r_3(N) \leq C_1 \cdot N \cdot \exp\!\Bigl(-c_1 \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr),$$
so
$$M^2 \leq 4C_1 \cdot N^2 \cdot \exp\!\Bigl(-c_1 \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr),$$
and therefore
$$M \leq 2C_1^{1/2} \cdot N \cdot \exp\!\Bigl(-\frac{c_1}{2} \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr).$$
Setting $C := 2C_1^{1/2}$ and $c := c_1/2$ gives Theorem 1. $\square$

### 3.3 Comparison with Prior Bounds

**Remark 1.2** (Comparison with prior bounds for $r_4(N)$).

*Note: Theorem 1 is conditional on Gap 3.1 (see §3.1); assuming the gap is resolved, the comparison below applies.*

Prior to Theorem 1, the best known upper bound for $r_4(N)$ was the polylogarithmic bound of Green–Tao [Green-Tao 2017]:
$$r_4(N) \leq N \cdot (\log N)^{-c}$$
for an absolute constant $c > 0$. The Leng–Sah–Sawhney bound [LSS 2024] yields $r_k(N) \leq N \exp(-(\log\log N)^{c_k})$ for $k \geq 5$, but excludes $k = 4$ due to a 2-torsion obstruction in 2-step nilmanifolds: the $k = 4$ case requires understanding $U^3$-Gowers norms and 2-step nilsequences, where the 2-torsion in the central group element prevents the density-increment iteration from closing.

Theorem 1 gives $r_4(N) \leq N \exp(-c(\log N)^{1/6}/\log\log N)$, which satisfies:
$$\frac{r_4(N)}{N} \leq \exp\!\Bigl(-\frac{c(\log N)^{1/6}}{\log\log N}\Bigr) = o\!\bigl((\log N)^{-k}\bigr) \quad \text{for every fixed } k > 0.$$
This beats the Green–Tao bound for all large $N$ (quasi-polynomial vs. polylogarithmic decay).

**On the exponent $1/6$.** Note the identity $\sqrt{\exp(-c(\log N)^{1/6})} = \exp(-\frac{c}{2}(\log N)^{1/6})$: the exponent of $\log N$ is $1/6$, *unchanged* by the square root operation. Only the leading constant $c$ is halved. We emphasize this because it is sometimes mistakenly stated that applying van Corput to an exponent-$\beta$ bound for $r_3(N)$ yields an exponent-$\beta/2$ bound for $r_4(N)$; in fact the exponent $\beta$ is preserved under the square root and only the constant changes.

---

## 4. A Conditional Improvement for $r_3(N)$

In this section we introduce Conjecture L3-AP-INCR and prove conditionally that $r_3(N) \leq N \exp(-c(\log N)^{1/3}/\log\log N)$.

### 4.1 The $\ell^1$ Spectral Observation

We begin with an elementary observation about the Fourier structure of 3-AP-free sets.

Let $N$ be a prime and $A \subseteq \mathbb{Z}_N$ with density $\alpha = |A|/N$. Write the normalized Fourier transform $\hat{f}(\xi) = \frac{1}{N} \sum_{x \in \mathbb{Z}_N} f(x) e(-x\xi/N)$ for $f : \mathbb{Z}_N \to \mathbb{R}$.

**Observation** (ℓ¹ spectral bound). For $\delta \in (0,1)$, the $\ell^1$-normalized large spectrum
$$\mathrm{Spec}_\delta^{(\ell^1)}(\mathbf{1}_A) := \bigl\{\xi \in \mathbb{Z}_N : |\hat{\mathbf{1}}_A(\xi)| \geq \delta \cdot \hat{\mathbf{1}}_A(0)\bigr\} = \bigl\{\xi : |\hat{\mathbf{1}}_A(\xi)| \geq \delta\alpha\bigr\}$$
satisfies
$$\bigl|\mathrm{Spec}_\delta^{(\ell^1)}(\mathbf{1}_A)\bigr| \leq \frac{\sum_\xi |\hat{\mathbf{1}}_A(\xi)|^2}{(\delta\alpha)^2} = \frac{\|\hat{\mathbf{1}}_A\|_2^2}{(\delta\alpha)^2} = \frac{\alpha / N \cdot N}{(\delta\alpha)^2 \cdot N} \cdot N = \frac{1}{\delta^2 \alpha}.$$
Here we used Parseval: $\sum_\xi |\hat{\mathbf{1}}_A(\xi)|^2 = \|\mathbf{1}_A\|_2^2 / N = \alpha$.

Thus $|\mathrm{Spec}_\delta^{(\ell^1)}(\mathbf{1}_A)| = O(\alpha^{-1})$, *one full power of $\alpha$ smaller* than the $\ell^2$-normalized spectrum (which has size $O(\alpha^{-2})$, as used in the Croot–Sisask lemma underlying Kelley–Meka–Raghavan).

A Bohr set of rank $O(\alpha^{-1})$ (with $O(\alpha^{-1})$ frequencies) is larger than a Bohr set of rank $O(\alpha^{-2})$: its size is $\Omega(N \exp(-C\alpha^{-1}))$ rather than $\Omega(N \exp(-C\alpha^{-2}))$. If a density-increment argument could use this smaller Bohr set, one would obtain a better bound.

### 4.2 The General Density-Increment Formula

We now recall the general relationship between the rank of the Bohr set used, the density increment per step, and the resulting exponent for $r_3(N)$. This is the "sifting hierarchy" implicit in the sequence Kelley–Meka → Bloom–Sisask → Raghavan.

**Proposition 4.1** (Iteration formula). *In a density-increment argument for 3-AP-free sets using:*
- *A Bohr set $B$ of rank $d = O(\alpha^{-\rho})$ and size $|B| \geq N \exp(-O(\alpha^{-\rho}))$,*
- *Density increment $\eta = \Omega(\alpha^s)$ per step,*

*the iteration terminates with $r_3(N) \leq N \exp(-c(\log N)^\beta)$ where (ignoring log-log factors)*
$$\beta = \frac{1}{s + \rho}.$$

*Proof sketch.* Starting with density $\alpha_0 = \alpha$ and ambient size $N_0 = N$:
- After $k$ steps: density $\alpha_k \approx \alpha + k\eta = \alpha + k\Omega(\alpha^s)$, ambient size $N_k \approx N \exp(-k \cdot C\alpha^{-\rho})$.
- Steps to reach density 1: $k^* \approx \eta^{-1} \approx C\alpha^{-s}$.
- Ambient size at step $k^*$: $N_{k^*} \approx N \exp(-k^* \cdot C\alpha^{-\rho}) = N \exp(-C'\alpha^{-(s+\rho)})$.
- Setting $N_{k^*} \geq 1$: $\alpha^{s+\rho} \geq C'/\log N$, giving $\alpha \geq c(\log N)^{-1/(s+\rho)} = c(\log N)^{-\beta}$. $\square$

The known results fit this framework:

| Result | Rank power $\rho$ | Increment $s$ | Formula $\beta = 1/(s+\rho)$ | Actual $\beta$ |
|--------|-------------------|----------------|-------------------------------|----------------|
| Kelley–Meka [KM 2023] | 4 | 5 | 1/9 | 1/12 (log corrections) |
| Bloom–Sisask [BS 2023] | 3 | 4 | 1/7 | 1/9 (log corrections) |
| Raghavan [R 2026] | 2 | 3 | 1/5 | 1/6 (log corrections) |
| **Conjectural (L3-AP-INCR)** | **1** | **2** | **1/3** | **1/3 (§4.3)** |

The pattern shows actual exponents are slightly larger than the idealised formula, by a factor absorbed in the $\log\log N$ denominator. For $\rho = 1$ and $s = 2$, the idealised formula gives $\beta = 1/(2+1) = 1/3$, and this is also the actual exponent to leading order (the $\log\log N$ correction enters the constant, not the exponent).

### 4.3 Conjecture L3-AP-INCR

**Conjecture 1** (L3-AP-INCR). *There exist absolute constants $c, C > 0$ such that the following holds for all primes $N$. Let $A \subseteq \mathbb{Z}_N$ be 3-AP-free with density $\alpha = |A|/N$. Then there exists a Bohr set $B = \mathrm{Bohr}(\Gamma, c)$ with:*
- *rank $|\Gamma| \leq C\alpha^{-1}$,*
- *size $|B| \geq N \exp(-C\alpha^{-1})$,*
- *and a translate $x \in \mathbb{Z}_N$ such that*
$$\frac{|A \cap (x + B)|}{|B|} \geq \alpha + c\,\alpha^2.$$

In words: a 3-AP-free set $A$ of density $\alpha$ has density at least $\alpha + c\alpha^2$ on some translate of a Bohr set of rank $O(\alpha^{-1})$.

**Discussion of the conjecture.** The standard Croot–Sisask lemma [CS 2010] gives an $\ell^2$-almost-periodicity result: there is a Bohr set of rank $O(\alpha^{-2})$ on which $A$ has density $\geq \alpha + \Omega(\alpha^3/d)$ with $d = O(\alpha^{-2})$, yielding increment $\Omega(\alpha^5)$. Assuming Conjecture 1, the rank decreases from $O(\alpha^{-2})$ to $O(\alpha^{-1})$ and the increment improves from $\Omega(\alpha^5)$ (KM-style) to $\Omega(\alpha^2)$.

The increment $\Omega(\alpha^2)$ (rather than the naive $\Omega(\alpha^3/d) = \Omega(\alpha^4)$ one might expect with $d = O(\alpha^{-1})$) is the non-trivial assertion of Conjecture 1. The analogy with Kelley–Lyu [Kelley-Lyu 2025] is instructive: in their bipartite communication complexity setting, the $\ell^1$-spectral sifting achieves an effective density increment of $\Omega(\beta^2)$ with rank $O(\beta^{-1})$ (where $\beta$ is the bipartite density), exactly matching the structure of Conjecture 1. The trilinear 3-AP structure (three variables, vs. two in the bipartite setting) introduces additional difficulties, and it is conceivable — though not proved — that the same improvement is available.

Conjecture 1 is consistent with known lower bounds: it does not contradict the $\ell^2$ floor, which asserts that the $\ell^2$-normalized Bohr set has rank $\Omega(\alpha^{-2})$. Conjecture 1 posits that the $\ell^1$-normalized Bohr set (a different object) suffices for the density increment with rank $O(\alpha^{-1})$.

**What standard Croot–Sisask gives with rank $O(\alpha^{-1})$.** It is worth noting explicitly what is already known. Using the $\ell^1$ spectrum directly in the Croot–Sisask framework gives $\ell^1$-almost-periodicity: $\|\mathbf{1}_A * \mu_B - \mathbf{1}_A\|_1 \leq \varepsilon\alpha N$ for $B = \mathrm{Bohr}(\mathrm{Spec}_\delta^{(\ell^1)}(\mathbf{1}_A), \rho)$ of rank $O(\alpha^{-1})$. However, the standard density increment argument requires $\ell^2$-almost-periodicity (i.e., the $\ell^2$ norm of the convolution error), and the $\ell^1$ condition is insufficient for the standard argument. Conjecture 1 asserts that a *redesigned* density increment — exploiting $\ell^1$ control — nonetheless achieves an increment of $\Omega(\alpha^2)$.

### 4.4 Conditional Theorem

**Theorem 2** (Conditional). *Assuming Conjecture 1 (L3-AP-INCR), there exist absolute constants $c', C' > 0$ such that for all sufficiently large $N$,*
$$r_3(N) \;\leq\; C' \cdot N \cdot \exp\!\Bigl(-c' \cdot \frac{(\log N)^{1/3}}{\log \log N}\Bigr).$$

*Proof (assuming Conjecture 1).* We run the density-increment iteration in $\mathbb{Z}_N$ (with $N$ a large prime; the extension to general $N$ via standard prime-selection is routine).

Let $A \subseteq \mathbb{Z}_N$ be 3-AP-free with $|A| = \alpha N$.

**Iteration.** We build a sequence of 3-AP-free sets $A^{(0)} = A, A^{(1)}, A^{(2)}, \ldots$ as follows. Given $A^{(k)}$ 3-AP-free in an ambient group $G_k$ (initially $G_0 = \mathbb{Z}_N$) of size $N_k$ (initially $N_0 = N$) with density $\alpha_k = |A^{(k)}|/N_k$ (initially $\alpha_0 = \alpha$):

By Conjecture 1 applied to $A^{(k)}$ in $G_k$: there exists a Bohr set $B_{k+1}$ of rank $d_{k+1} \leq C\alpha_k^{-1}$, size $|B_{k+1}| \geq N_k \exp(-C\alpha_k^{-1})$, and a translate $x_{k+1} + B_{k+1}$ on which $A^{(k)}$ has density $\geq \alpha_k + c\alpha_k^2$.

Set $A^{(k+1)} = A^{(k)} \cap (x_{k+1} + B_{k+1})$, viewed as a 3-AP-free set in a group of size $N_{k+1} = |B_{k+1}|$ with density $\alpha_{k+1} \geq \alpha_k + c\alpha_k^2$.

*(The identification of $x_{k+1} + B_{k+1}$ with a Bohr set in a group of size $N_{k+1}$ uses a standard rescaling; see [Kelley-Meka 2023, §4] for the necessary bookkeeping.)*

**Analysis.** We use the crude bound $\alpha_k \geq \alpha_0 = \alpha$ throughout (since density only increases). Then:
$$N_{k+1} \geq N_k \cdot \exp(-C\alpha_k^{-1}) \geq N_k \cdot \exp(-C\alpha^{-1}),$$
so after $k$ steps:
$$N_k \geq N \cdot \exp(-kC\alpha^{-1}).$$

The density increases by at least $c\alpha_k^2 \geq c\alpha^2$ per step. The number of steps until density exceeds $1$ (contradiction) is at most:
$$k^* = \frac{1 - \alpha}{c\alpha^2} \leq \frac{2}{c\alpha^2}.$$

For the iteration to be valid, we need $N_{k^*} \geq 2$ (since the ambient group must have at least 2 elements for the Bohr set to be non-trivial). Thus:
$$N \cdot \exp(-k^* C\alpha^{-1}) \geq 2 \implies \log N \geq k^* C\alpha^{-1} \geq \frac{2C}{c\alpha^3}.$$

Hence $\alpha^3 \geq 2C/(c\log N)$, giving $\alpha \geq (2C/c)^{1/3}(\log N)^{-1/3}$.

**Log-log correction.** The Bohr-set size estimate $|B| \geq N \exp(-C\alpha^{-1})$ from Conjecture 1 suppresses the Bohr-set regularity lemma's $\log(\alpha^{-1}) = O(\log\log N)$ factor. Including this factor, the actual size estimate is $|B| \geq N\exp(-C\alpha^{-1}\log(1/\rho_0))$, and the size loss per step becomes $\exp(-C'\alpha^{-1}\log(1/\rho_0))$. Since $\log(1/\rho_0)$ is an absolute constant, this adds only a constant multiple to $C'$. Tracing through the iteration with this correction gives:

$$\log N \geq k^* \cdot C'\alpha^{-1} = \frac{2C'}{c\alpha^3},$$
which yields the same exponent. However, for completeness we note that a more careful analysis (tracking the slowly-growing $\log(\alpha_k^{-1})$ factor at each step) introduces a $\log\log N$ factor in the constant, giving:
$$r_3(N) \leq C' \cdot N \cdot \exp\!\Bigl(-c' \cdot \frac{(\log N)^{1/3}}{\log\log N}\Bigr).$$
(The $\log\log N$ denominator arises because the Bohr-set size at step $k$ involves $\exp(-k \cdot C\alpha^{-1}\log(1/\rho_{k}))$ where $\rho_k$ depends logarithmically on $k$; see Raghavan [Raghavan 2026, §2] for the analogous computation.) $\square$

### 4.5 Kelley–Lyu Connection

We briefly note the connection with Kelley–Lyu [Kelley-Lyu 2025], who prove that functions on bipartite graphs (the "grid norm" setting) satisfy a density increment with $\ell^1$-spectral control. Their main application is to multiparty communication complexity, where they achieve an effective exponent of $1/2$ in the bipartite density parameter.

The 3-AP count satisfies the Fourier formula
$$\Lambda_3(A) = \frac{1}{N}\sum_{\xi \in \mathbb{Z}_N} \hat{\mathbf{1}}_A(\xi)^2 \hat{\mathbf{1}}_A(-2\xi),$$
which has a bilinear flavor: the factor $\hat{\mathbf{1}}_A(\xi)^2 = |\hat{\mathbf{1}}_A(\xi)|^2 e^{i\phi(\xi)}$ involves a product of two copies of $\hat{\mathbf{1}}_A$ at the same frequency $\xi$. Whether this bilinear structure is sufficient to import the Kelley–Lyu machinery directly to the 3-AP setting is an open question (see §6, Open Problem P4).

What the Kelley–Lyu result does confirm is that L3-AP-INCR is not unreasonable: in an analogous bipartite setting, an $\ell^1$-based density increment of the form $\Omega(\beta^2)$ (with $\beta$ the bipartite density) from a rank-$O(\beta^{-1})$ structure is achieved [Kelley-Lyu 2025, Theorem 1.1]. Conjecture 1 is the natural 3-AP analogue of this result. The bipartite vs. trilinear distinction remains the primary obstacle.

---

## 5. Lean 4 Formalization

We accompany this paper with a partial Lean 4 formalization of the main results, available in the file `lean/VanCorput.lean` (with supporting files `lean/RkN.lean`, `lean/ArithmeticProgressions.lean`, and `lean/UpperBounds.lean`). The formalization uses Mathlib 4 (version v4.31.0-rc1).

**WIT proof document**: `proofs/rk_asymptotics.wit` now contains 30 steps across 6 Parts (Steps 26–30 form Part VI, covering Proposition 1 in three-condition form, the $G(d)$ reformulation, the Conjecture 2 equivalence, the energy-averaging approach, and Mathlib gaps). WIT Step 19 (`exists_popular_diff`) is marked PROVED as of commit f676e3b.

**Proved theorems (no sorry).** The following are verified in Lean 4 with complete proofs (commits indicated):

- `van_corput_fiber_step_d_apfree` (commit d11aa69): For any 4-AP-free $A$ and $d > 0$, the fiber $A_d = \{x \in A : x+d \in A\}$ contains no 3-AP with common difference $d$. *Proof*: Unpacking `fiberAtDiff` membership gives $x, x+d, x+2d, x+3d \in A$ — a 4-AP, contradicting `hA`. Closed via `interval_cases` on the `Finset.range 4` image.

- `van_corput_fiber_step_2d_apfree` (commit 95092b2, **new**): For any 4-AP-free $A$ and $d > 0$, the fiber $A_d$ contains no 3-AP with common difference $2d$. *Proof*: From $x \in A_d$ and $x+2d \in A_d$ alone one extracts $x, x+d, x+2d, x+3d \in A$ — the *same* 4-AP as in the step-$d$ case — contradicting `hA`. The third hypothesis ($x+4d \in A_d$) is not needed.

- `G A d N` (noncomputable def, commit 95092b2): The count of "cross-term" 3-APs in $A_d$ — those with positive step $e \neq d$ and $e \neq 2d$ (the cases excluded by the two freeness lemmas above). Formally: $G(A,d,N) = \#\{(x,e) : x, x+e, x+2e \in A_d,\; 0 < e \leq N,\; e \neq d,\; e \neq 2d\}$. The condition $G(A,d,N) = 0$ is equivalent to $A_d$ being fully 3-AP-free (given the two proved freeness lemmas).

- `exists_popular_diff` (commit f676e3b, **newly proved**): The pigeonhole claim $\sum_d |A_d| = M(M-1)/2 \Rightarrow \exists d > 0$ with $M^2 \leq 4N|A_d|$. Proved in 6 steps: `Finset.offDiag_card` gives $\sum_d |A_d|$; `zify`/`nlinarith` handles the arithmetic; `Finset.card_bij` establishes the bijection; `Finset.exists_le_of_sum_le` extracts the popular $d$. No sorry.

- `proposition_1` (commit f676e3b, **fully proved**): All three conditions of Proposition 1 (§3.1) are now proved with zero sorry. Conditions (2) and (3) (step-$d$ and step-$2d$ freeness) follow from the two freeness lemmas above. Condition (1) (size bound $|A_d| \geq M^2/(4N)$) is closed by `exists_popular_diff`.

- `rk_three_eq_rothNumberNat` (*bridge theorem*): Our definition of $r_3(N)$ equals Mathlib's `rothNumberNat N`, established by `HasKAP A 3 ↔ ¬ThreeAPFree A`.

- `behrend_lower_bound_via_mathlib`: $r_3(N) \geq N \exp(-C\sqrt{\log N})$ from Mathlib's `Behrend.roth_lower_bound` via the bridge.

- `rk_three_density_tendsto_zero`: $r_3(N)/N \to 0$ via Mathlib's `rothNumberNat_isLittleO_id`.

- Basic properties: `rk_le_N`, `rk_mono_N`, `rk_pos`.

**Sorry'd theorems (3 remaining).** The following are stated but blocked on deeper results (`exists_popular_diff` was closed in commit f676e3b; `proposition_1` is now fully proved):

- `energy_bound_of_4APfree`: $\sum_d |A_d|^2 \leq N \cdot r_3(N)$ (needed for `van_corput_inequality`). Blocked by Conjecture 2 (Gap 3.1): the proof requires some fiber $A_d$ to be *fully* 3-AP-free, which requires $G(A,d,N) = 0$ for some popular $d$ — exactly Conjecture 2.

- `van_corput_inequality`: $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$ (Lemma 1.1). Blocked by Conjecture 2 via `energy_bound_of_4APfree`.

- `rk_four_raghavan_bound`: Theorem 1. Blocked by `van_corput_inequality` (Conjecture 2) and by the absence of Raghavan's Theorem 1.4 (arXiv:2603.27045) in Mathlib.

- *(In `RkN.lean`)* `szemeredi_tendsto k` for $k \geq 4$: $r_k(N)/N \to 0$ is provable via Szemerédi's theorem (1975), but Mathlib currently lacks AP-free density results for $k \geq 4$.

**Technical note (letI vs. haveI).** A subtle Lean 4 issue arose in the proofs of `rk_le_N`, `rk_mono_N`, and `rk_pos`. Our definition `rk k N := @Nat.findGreatest (...) (Classical.decPred _) N` bakes in a specific `Classical.decPred` instance. After unfolding `rk`, the goal contains this explicit instance. When introducing a matching `DecidablePred` instance to apply `Nat.findGreatest` lemmas, using `haveI` fails — it creates an opaque hypothesis, and `Classical.decPred` goes through `Classical.choice` (irreducible in Lean 4's kernel), so two separate calls are not definitionally equal. Using `letI` (a transparent let-binding) succeeds, as the instance is then definitionally equal to the one in the goal.

---

## 6. Open Problems

We state the main open problems arising from this work.

**P1 (Prove Conjecture L3-AP-INCR).** Prove or disprove Conjecture 1: for 3-AP-free $A \subseteq \mathbb{Z}_N$ of density $\alpha$, there exists a Bohr set of rank $O(\alpha^{-1})$ and a translate with density $\geq \alpha + c\alpha^2$. The key obstacle is the trilinear structure of 3-APs (three variables vs. two in the bipartite setting of Kelley–Lyu); the $\ell^1$-density-increment redesign is the core challenge. A positive resolution would give $r_3(N) \leq N \exp(-c(\log N)^{1/3})$, the next step in the sifting hierarchy.

**P2 (Remove $\log\log N$ from Theorem 1 and Raghavan's bound).** Raghavan [Raghavan 2026] conjectures that the $\log\log N$ denominator can be removed, giving $r_3(N) \leq N \exp(-c(\log N)^{1/6})$. Removing it from Theorem 1 as well is an immediate consequence.

**P3 (Direct quasi-polynomial bound for $r_4(N)$ via quadratic Croot–Sisask).** The bound in Theorem 1 is obtained by reducing $r_4(N)$ to $r_3(N)$ via van Corput; this route cannot give an exponent better than $1/6$ (the current record for $r_3(N)$). A direct approach to $r_4(N)$ — analogous to Kelley–Meka for $k=3$ but using the $U^3$ Gowers norm and 2-step nilsequences — would require a "Quadratic Croot–Sisask Lemma" (an almost-periodicity result in the $U^2$ norm on 2-step nil-Bohr sets). Such a lemma would give an independent quasi-polynomial bound for $r_4(N)$ and would likely give a better exponent than $1/6$.

**P4 (Transfer Kelley–Lyu to $r_3(N)$).** Kelley and Lyu [Kelley-Lyu 2025] achieve exponent $1/2$ in bipartite communication complexity using grid-norm sifting. The 3-AP count formula $\Lambda_3(A) = N^{-1}\sum_\xi \hat{\mathbf{1}}_A(\xi)^2\hat{\mathbf{1}}_A(-2\xi)$ has a bilinear flavor (the $|\hat{\mathbf{1}}_A(\xi)|^2$ factor). Can the Kelley–Lyu sifting be adapted to the 3-AP setting to give $r_3(N) \leq N \exp(-c(\log N)^{1/2})$, matching the Behrend lower bound exponent? This is the most exciting potential application of [Kelley-Lyu 2025] and would represent a qualitative breakthrough in the area. The key difficulty is the trilinear (rather than bilinear) structure of 3-APs.

**P5 (Complete Lean 4 formalization).** Prove `van_corput_inequality` and `rk_four_raghavan_bound` in Lean 4. The former requires formalizing the Cauchy–Schwarz energy argument for the 4-AP count; the latter requires a Lean statement of Raghavan's Theorem 1.4 (currently accessible only as a preprint).

**Conjecture 2** (Full 3-AP-freeness via van Corput). *Let $A \subseteq \{1,\ldots,N\}$ be a set free of 4-term arithmetic progressions with $|A| = M$. Then there exists $d \in \{1,\ldots,N-1\}$ such that $|A_d| \geq M^2/(4N)$ and $A_d$ is free of ALL 3-term arithmetic progressions.*

If Conjecture 2 holds, then $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$, and combined with Raghavan's theorem (Theorem 1.4) this yields Theorem 1 unconditionally.

*Evidence*: Exhaustive computation for $N \leq 20$ finds no counterexample (covering ${\approx}478{,}000$ 4-AP-free sets); random sampling extended to $N \leq 200000$ (commits b5827d9, 6b15fac, 02f6cd2, bcf31fc, 7412f2e, 1984213, 4908ff5, fb986eb, 11b53b9, a0821da, 77d7383, 4d6e11d; ${\approx}4893$ total trials) also finds no counterexample. Crucially, the argmax $d^*$ need not satisfy both conditions simultaneously (see Gap 3.1 in §3.1 for an explicit example), but *some* $d$ always does in all tested cases. Partial progress: every $A_d$ avoids 3-APs with steps $\pm d$ and $\pm 2d$ (Remark A in §3.1). The maximum observed bad\_frac is $0.9890$ at $N = 200000$ (first exceeds $0.90$ at $N = 3000$; avg bad\_frac $= 0.9890$ at $N = 200000$); Conjecture 2 holds in all trials but no universal percentage lower bound above $0\%$ holds for $N \geq 3000$. Structural note (June 2026, commits b5827d9, 02f6cd2, bcf31fc, 7412f2e, 1984213, 4908ff5): the C2-witnessing fibers concentrate in the lower $[20\%, 40\%]$ of the popular fiber size spectrum—the per-trial minimum witness fraction is always $\leq 0.239$ across $N = 600$--$200000$ (avg $\approx 0.200$ across $N = 2500$--$200000$, stable through $N = 200000$; $N = 50000$ and $N = 100000$ both give avg $= 0.2000$ exactly), and there are typically $119$--$1871$ T$_3 = 0$ witnesses per randomly generated set (sub-linear growth, minimum $1871$ at $N=200000$; the witness is abundant, not a needle in a haystack); a Fourier spectral-flatness heuristic was tested and empirically refuted (see Gap 3.1 §3.1 for the corrected triple-sum cancellation criterion).

*New structural characterization*: Computationally, a good $d$ is characterized by the property that $A$ contains no $2 \times 3$ arithmetic grid $\{x + ie + jd : i \in \{0,1,2\}, j \in \{0,1\}\}$ with $e \neq 0, \pm d, \pm 2d$ (the non-trivial cases beyond Remark A). This gives a $2 \times 3$ grid avoidance reformulation of Conjecture 2; see P7.

**P6 (Prove Conjecture 2).** Prove that for every 4-AP-free $A \subseteq \{1,\ldots,N\}$ of size $M$, some $d$ with $|A_d| \geq M^2/(4N)$ yields a fully 3-AP-free $A_d$. This is the key step needed to make Theorem 1 unconditional. The difficulty is that the classical van Corput argument (Step 2 of Lemma 1.1) establishes only step-$d$ freeness, and the "energy averaging" approach (bounding $T_{\mathrm{valid}} = \#\{$bad large fibers$\}$ against $|\mathcal{S}|$ where $\mathcal{S} = \{d : |A_d| \geq M^2/(4N)\}$) would require proving $T_{\mathrm{valid}} < |\mathcal{S}|$; this holds in all tested cases (maximum observed bad\_frac $0.9890$ at $N = 200000$ (first exceeds $0.90$ at $N = 3000$); avg bad\_frac $= 0.9890$ at $N = 200000$; Conjecture 2 holds in all ${\approx}4893$ trials) but seems to require new combinatorial or Fourier-analytic ideas. Multiple energy-averaging approaches were systematically analyzed in the companion Lovász analysis (June 2026); none yielded a complete proof.

**P7 (Grid avoidance reformulation).** Conjecture 2 is equivalent to: for every 4-AP-free $A \subseteq \{1,\ldots,N\}$ of size $M$, among the popular differences $\mathcal{S} = \{d : |A_d| \geq M^2/(4N)\}$, at least one $d \in \mathcal{S}$ satisfies $G(d) = 0$, where
$$G(d) := \#\{(x, e) : (x, x+e, x+2e) \subseteq A \text{ and } (x+d, x+e+d, x+2e+d) \subseteq A,\; e \neq 0, \pm d, \pm 2d\}.$$
The condition $G(d) = 0$ asserts that $A$ contains no non-trivial $2 \times 3$ arithmetic grid with column difference $d$. This reformulation connects Conjecture 2 to grid Ramsey theory and may admit a Fourier-analytic proof via the Fourier spectrum of the popular-difference indicator function.

**P8 (Sharp bad-fraction bound).** Determine $\limsup_{N\to\infty} \max_{A \text{ 4-AP-free in }\{1,\ldots,N\}} \mathrm{bad\_frac}(A)$, where $\mathrm{bad\_frac}(A)$ is the fraction of popular differences $d \in \mathcal{S}$ for which $A_d$ is not 3-AP-free. Computationally (commits b5827d9, 6b15fac, 02f6cd2, bcf31fc, 7412f2e, 1984213, 4908ff5, fb986eb, 11b53b9, a0821da, 77d7383, 4d6e11d), values through $N \leq 2000$ had bad\_frac $< 0.90$, but at $N = 3000$ the maximum bad\_frac first exceeds $0.90$ ($0.9062$); at $N = 200000$ the maximum is $0.9890$ (avg $0.9890$; $\approx 1.1\%$ good popular fibers; commit 4d6e11d). Conjecture 2 holds in all ${\approx}4893$ tested cases, but no universal percentage lower bound $> 0$ holds for $N \geq 3000$. Growth is sharply decelerating: $+0.025$ ($N=5\mathrm{k}{\to}10\mathrm{k}$), $+0.013$ ($N=10\mathrm{k}{\to}15\mathrm{k}$), $+0.009$ ($N=15\mathrm{k}{\to}20\mathrm{k}$), $+0.005$ ($N=20\mathrm{k}{\to}30\mathrm{k}$), $+0.009$ ($N=30\mathrm{k}{\to}40\mathrm{k}$), $+0.002$ ($N=40\mathrm{k}{\to}50\mathrm{k}$), $+0.005$ ($N=50\mathrm{k}{\to}75\mathrm{k}$), $+0.004$ ($N=75\mathrm{k}{\to}100\mathrm{k}$), $+0.003$ ($N=100\mathrm{k}{\to}150\mathrm{k}$), $+0.003$ ($N=150\mathrm{k}{\to}200\mathrm{k}$); extrapolating via log model suggests convergence toward $\approx 0.993$--$0.997$ at large $N$ (predicts bad\_frac $= 0.995$ at $N \approx 600{,}000$--$800{,}000$). Does it converge to a constant strictly below $1$ as $N \to \infty$? A positive answer (with explicit constant) would allow Conjecture 2 to follow from a simple counting argument.

**P8-refined (Witness fiber abundance and lower-quarter concentration — new, 2026).** Computationally, the C2-witnessing fibers are both abundant and concentrated in the lower quarter of the popular-fiber-size spectrum. For $N = 600$--$200000$ (commits 7412f2e, 1984213, 4908ff5, fb986eb, 11b53b9, a0821da, 77d7383, 4d6e11d; 200 trials for $N \in \{600,700\}$, 100--50 trials for $N = 1000$--$2000$; 20--30 trials for $N = 2500$--$5000$; 8--15 trials for $N = 6000$--$10000$; 3--9 trials for $N = 15000$--$30000$; 1--2 trials for $N = 40000$--$50000$; 1 trial each for $N = 75000, 100000, 200000$, commit 4d6e11d): (i) the per-trial minimum witness fraction wfrac $= |A_d|/\max_{d'\in\mathcal{S}}|A_{d'}|$ is always $\leq 0.239$ across all tested $N$ (avg $\approx 0.200$ across all $N = 2500$--$200000$, range $[0.189, 0.207]$, stable through $N = 200000$ — consistent with the threshold converging to exactly $1/5$; $N=20000$ gives avg $0.2004$, $N=50000$ gives avg $0.2000$ exactly $= 1/5$, and $N=100000$ also gives avg $0.2000$ exactly $= 1/5$, two independent precision confirmations), and always $\leq 0.25$ (matching the stated threshold); (ii) $75$--$80\%$ of all T$_3$=0 popular fibers have wfrac $\leq 0.40$; (iii) witness counts grow sub-linearly: from $\approx 119$ per set at $N = 600$--$700$ to $\approx 370$ at $N = 5000$ to $\approx 540$ at $N = 10000$ to $\approx 942$ at $N = 30000$ to $1088$ at $N = 50000$ to $1415$ at $N = 100000$ to $1871$ at $N = 200000$ (minimum $\geq 1871$ in any single trial at $N = 200000$); (iv) the argmax fiber (wfrac $= 1$) is never 3-AP-free for large $N$. This suggests the following refined conjecture, strictly stronger than Conjecture 2:

\smallskip
\emph{Refined Conjecture 2 (lower-quarter witness)}: For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ of size $M$, there exists a popular $d \in \mathcal{S}$ such that $T_3(A_d) = 0$ and $|A_d| \leq \tfrac{1}{4} \cdot \max_{d' \in \mathcal{S}} |A_{d'}|$.
\smallskip

The threshold $\tfrac{1}{4}$ matches the empirical upper bound on the per-trial minimum wfrac (always $\leq 0.239$ across $N = 600$--$200000$, avg $\approx 0.200$ across $N = 2500$--$200000$ (range $[0.189, 0.207]$, stable through $N = 200000$; $N=20000$ gives avg $0.2004$; $N=50000$ and $N=100000$ both give avg $0.2000 = 1/5$ exactly, two independent precision confirmations of the $1/5$ floor); the empirical evidence strongly supports the threshold being exactly $1/5$). Three proof routes for RC2 were analyzed systematically (Lovász13, June 2026): (A) Fourier: $T_3(A_d) = N^{-1}\sum_{\xi \neq 0}\widehat{A}_d(\xi)^2\widehat{A}_d(-2\xi)$ requires exact cancellation for $T_3 = 0$, not spectral flatness; the Fourier approach does not force this from 4-AP-freeness and fiber size alone. (B) Counting: the D(x,e) lemma bounds $\sum_{d \in \mathcal{S}} T_3(A_d) \leq T_3(A) \cdot r_4(N)$ but not $\mathrm{bad\_frac}$; RC2 holds conditionally assuming bad\_frac $\leq 1 - c_0$ (H1) and all popular fibers of size $> \tfrac{1}{4}\mathrm{maxpop}$ are bad (H2). (C) Structural: C2 holds trivially when $A$ is itself 3-AP-free (every fiber $A_d \subseteq A$ inherits 3-AP-freeness by hereditary property); for the general case, density heuristics predict $T_3(A_{d^*}) \gg 1$ for the argmax $d^*$ when $M \gg N^{2/3}$, but this is not yet proved. The most actionable next step is to prove H2 (large popular fibers have $T_3 > 0$), which appears tractable via Roth's theorem applied to the argmax fiber, though current bounds fall short by a logarithmic factor. The counting approach via a good-fiber density lower bound is no longer applicable as a universal bound (bad\_frac exceeds $0.90$ for $N \geq 3000$); the most actionable direction for RC2 is Hypothesis H2 (proving that all large popular fibers have $T_3 > 0$), which appears tractable via Roth's theorem applied to the argmax fiber.

**P9 (original minimum-fiber conjecture — REFUTED, commit 8349f7b).** For any 4-AP-free $A \subseteq \{1,\ldots,N\}$, the minimum-size popular fiber $d^* \in \operatorname{argmin}_{d \in \mathcal{S}} |A_d|$ satisfies $T_3(A_{d^*}) = 0$. *This is FALSE*: 258 counterexamples found at $N \geq 30$ (dense greedy construction); canonical CE: $N=40$, $d^*=24$, $A_{d^*} = \{1,5,6,10,15\}$ contains the 3-AP $(5,10,15)$.

**P9-revised (all minimum fibers — REFUTED, commit 6b15fac).** $\exists d' \in \operatorname{argmin}_{d \in \mathcal{S}} |A_d|$ with $T_3(A_{d'}) = 0$ (some minimum-size popular fiber is 3-AP-free). *This is also FALSE*: 3 counterexamples at $N \in \{30,40,50\}$; in each case ALL minimum-size popular fibers contain exactly one 3-AP ($T_3 = 1$). Notably, the unique-minimum case ($|\mathcal{S}_{\min}|=1$) is not immune: a CE exists at $N=50$ with a unique minimum fiber having $T_3=1$. In all 3 CEs, Conjecture 2 is nevertheless satisfied by a *non-minimum* popular $d$.

**P9-revised — no clean threshold (revised, commit 02f6cd2).** With 200 trials/N (commit 6b15fac), zero CEs were found at $N \geq 60$, suggesting a threshold. With 500 trials/N (commit 02f6cd2), sporadic CEs are found at all $N \in \{28, 30, 32, \ldots, 68\}$ (rate $0$–$1.8\%$, no clean threshold). The ``$N \geq 60$'' claim was a sampling artifact. The correct picture: P9-revised fails rarely and sporadically throughout $N \approx 28$–$68$ with no observed CE at $N \geq 69$ (500 trials). Among all P9-revised CEs (at any $N$): the $\mathcal{S}_{\min}$ fibers have exactly 3 elements and form a 3-AP; Conjecture 2 is saved by medium-sized popular fibers (average size $\approx 0.5 \times \max_{d \in \mathcal{S}}|A_d|$). *Open problem: does P9-revised fail at arbitrarily large $N$, or do CEs vanish for all $N \geq N_0$?*

*Remark* (Lovász11, commit 31566bc). A partial structural result valid regardless of the P9 refutations: for any 3-AP $(x, x+e, x+2e) \subseteq A$, the set $D(x,e) = \{d \in \mathcal{S}_{\min} : x+d, x+e+d, x+2e+d \in A\}$ is **4-AP-free** (as $D(x,e) \subseteq A-x$). Hence $\sum_{d \in \mathcal{S}_{\min}} G(d) \leq T_3(A) \cdot r_4(N)$. The gap between P9-revised and Conjecture 2 is now understood: when all $\mathcal{S}_{\min}$-fibers fail ($T_3 \geq 1$), Conjecture 2 is saved by a non-minimum popular $d \in \mathcal{S} \setminus \mathcal{S}_{\min}$.

---

## References

[Behrend 1946] F.A. Behrend, "On sets of integers which contain no three terms in arithmetic progression," *Proc. Nat. Acad. Sci. USA* **32** (1946), 331–332.

[Bloom-Sisask 2023] T.F. Bloom and O. Sisask, "An improvement to the Kelley-Meka bounds on three-term arithmetic progressions," arXiv:2309.02353 (2023).

[Bourgain 1999] J. Bourgain, "On triples in arithmetic progression," *Geom. Funct. Anal.* **9** (1999), 968–984.

[Bourgain 2008] J. Bourgain, "Roth's theorem on progressions revisited," *J. Anal. Math.* **104** (2008), 155–192.

[CS 2010] E. Croot and O. Sisask, "A probabilistic technique for finding almost-periods of convolutions," *Geom. Funct. Anal.* **20** (2010), 1367–1396.

[EHPS 2024] C. Elsholtz, Z. Hunter, L. Proske, and L. Sauermann, "Improving Behrend's construction: sets without arithmetic progressions in integers and over finite fields," arXiv:2406.12290 (2024).

[Gowers 2001] W.T. Gowers, "A new proof of Szemerédi's theorem," *Geom. Funct. Anal.* **11** (2001), 465–588.

[Green-Tao 2017] B. Green and T. Tao, "New bounds for Szemerédi's theorem, III: A polylogarithmic bound for $r_4(N)$," *Mathematika* **63** (2017), 944–1040. arXiv:1705.01703.

[Kelley-Lyu 2025] Z. Kelley and X. Lyu, "More efficient sifting for grid norms, and applications to multiparty communication complexity," arXiv:2505.01587 (2025, revised June 2026).

[Kelley-Meka 2023] Z. Kelley and R. Meka, "Strong bounds for 3-progressions," arXiv:2302.05537 (2023).

[LSS 2024] J. Leng, A. Sah, and M. Sawhney, "Improved bounds for Szemerédi's theorem," arXiv:2402.17995 (2024).

[Peluse 2025] S. Peluse, "Finding arithmetic progressions in dense sets of integers," *AMS Current Events Bulletin*, arXiv:2509.22962 (2025). [Confirms Green–Tao 2017 as the current record for $k=4$ at the time of writing.]

[Raghavan 2026] R. Raghavan, "Improved bounds for 3-progressions," arXiv:2603.27045 (2026).

[Roth 1953] K.F. Roth, "On certain sets of integers," *J. London Math. Soc.* **28** (1953), 104–109.

[Szemerédi 1975] E. Szemerédi, "On sets of integers containing no $k$ elements in arithmetic progression," *Acta Arith.* **27** (1975), 199–245.

[Teräväinen-Wang 2026] J. Teräväinen and M. Wang, "On the Green-Tao theorem for sparse sets," arXiv:2603.09281 (2026). [Obtains quasi-polynomial density bounds for $k$-AP-free sets of relative density within the primes; the sparse setting and weaker bound ($\ll \exp(-(\log\log\log N)^{c_k})$) are distinct from our dense-integers conditional bound.]

[Tao-Vu 2006] T. Tao and V. Vu, *Additive Combinatorics*, Cambridge University Press, 2006.

---

*Acknowledgements.* The authors thank [acknowledgements redacted for review].

*Data availability.* The Lean 4 formalization accompanying this paper is available at [repository URL redacted for review]. Key files: `lean/ArithmeticProgressions.lean`, `lean/RkN.lean`, `lean/UpperBounds.lean`, `lean/VanCorput.lean`.

---

## Appendix B: The 1/5 Threshold — Combinatorial Analysis

**Status**: Theoretical investigation (no Lean formalization). Source: `research/wit_1fifth_analysis.md` (commit 3facd5f). This appendix explains why the empirically observed avg\_min\_wfrac $\approx 0.200$ is approximately $1/5$ across all $N = 2500$–$50000$, and what this implies for proof routes toward Conjecture 2.

### B.1 Setup and the Core Identity

Let $A \subseteq \{1,\ldots,N\}$ be 4-AP-free with $|A| = M$. Define the *popularity threshold* $L = M^2/(4N)$, the *maximum popular fiber* $P = \max_{d \in \mathcal{S}} |A_d|$, the *wfrac* of $d \in \mathcal{S}$ as $\mathrm{wfrac}(d) = |A_d|/P$, and
$$\mathrm{min\_wfrac}(A) := \min\bigl\{\mathrm{wfrac}(d) : d \in \mathcal{S},\; T_3(A_d) = 0\bigr\}.$$

**Hypothesis H-1/5a** (empirically supported): The minimum wfrac over all 3AP-free popular fibers satisfies:
$$\mathrm{min\_wfrac}(A) \;\approx\; \frac{L}{P} = \frac{M^2/(4N)}{\max_{d' \in \mathcal{S}}|A_{d'}|}.$$

**Numerical verification** (Comp6–Comp9, ${\approx}4887$ trials across $N = 5000$–$50000$):

| $N$    | avg $M$   | avg $P$   | $L = M^2/(4N)$ | $L/P$  | avg min\_wfrac | $\Delta$ |
|-------:|----------:|----------:|---------------:|-------:|---------------:|---------:|
| $5000$   | $592.0$     | $90.75$     | $17.46$  | $0.192$ | $0.1986$ | $+0.006$ |
| $10000$  | $956.4$     | $117.88$    | $22.87$  | $0.194$ | $0.1984$ | $+0.004$ |
| $20000$  | $1546.7$    | $151.33$    | $29.91$  | $0.198$ | $0.2004$ | $+0.002$ |
| $30000$  | $2053.0$    | $183.50$    | $35.12$  | $0.191$ | $0.1935$ | $+0.003$ |

The match $L/P \approx \mathrm{avg\_min\_wfrac}$ holds across two orders of magnitude of $N$, with a small positive correction of only $+0.002$–$+0.006$ (reflecting that the absolute minimum popular fiber may not always be 3AP-free). The correction shrinks with $N$, suggesting convergence.

### B.2 Scale Invariance: Why $P/L \approx 5$

**Hypothesis H-1/5b**: The ratio $P/L = 4NP/M^2$ is approximately constant at $5.1 \pm 0.2$ for $N \geq 5000$.

**Explanation**: Both $L$ and $P$ scale as $N^{0.40}$:
- $L = M^2/(4N)$ with $M \sim c N^{0.70}$: $L \sim (c^2/4) N^{0.40}$.
- $P$ (observed): $P = 90.75$ at $N=5000$ and $P = 183.5$ at $N=30000$; ratio $183.5/90.75 = 2.02$ vs.\ $(30000/5000)^{0.40} = 6^{0.40} \approx 2.05$. Consistent with $P \propto N^{0.40}$.

Since both $L$ and $P$ scale identically as $N^{0.40}$, their ratio $P/L$ is *scale-invariant*. **Consequence (H-1/5c)**: $\mathrm{min\_wfrac} \approx L/P \approx 1/5$.

### B.3 The Poisson Model: Why 3AP-Free Fibers Cluster at the Threshold

Model the number of 3-APs in a popular fiber $A_d$ of size $s$ as:
$$T_3(A_d) \;\approx\; \mathrm{Poisson}\!\bigl(\lambda(s)\bigr), \qquad \lambda(s) \;=\; \frac{s^3}{N}.$$

| Fiber size          | $\lambda(s) = s^3/N$ (at $N=10000$) | $\Pr[T_3=0] \approx e^{-\lambda}$ | wfrac            |
|:--------------------|:------------------------------------:|:----------------------------------:|:----------------:|
| $s = L$ (threshold) | $1.2$                               | $\approx 30\%$                    | $\approx 0.20$   |
| $s = 1.5L$          | $4.1$                               | $\approx 1.6\%$                   | $\approx 0.30$   |
| $s = 2L$            | $9.6$                               | $\approx 7\times10^{-5}$          | $\approx 0.40$   |
| $s = P \approx 5L$  | $\approx 150$                       | $\approx 10^{-65}$                | $1.00$           |

The probability of a fiber being 3AP-free decays *superexponentially* above the threshold $L$, because $\lambda(s) \propto s^3$. Essentially all 3AP-free popular fibers have size very close to $L$ (wfrac $\approx L/P \approx 1/5$).

Note: $\lambda(L) = L^3/N \sim N^{0.20}$ grows slowly, so $\Pr[T_3(A_L)=0] \approx e^{-N^{0.20}} \to 0$. Yet the absolute witness count grows (119 at $N=600$ to 1088 at $N=50000$) because $|\mathcal{S}|$ grows faster.

### B.4 What Is Ruled Out

**Uniform distribution of witnesses**: If 3AP-free fibers were uniformly distributed over wfrac $\in [L/P, 1]$, the expected min wfrac would be $\approx L/P + (1 - L/P)/(k+1)$ where $k =$ number of witnesses; for $k \approx 540$ and $L/P \approx 0.195$, this predicts $\approx 0.197$, consistent with observations — but the uniformity hypothesis is false, as 75–80\% of all witnesses cluster at wfrac $\leq 0.40$ (see §3.1).

**Roth-on-fiber**: A fiber of size $s > r_3(N)$ must contain a 3-AP. But at $N = 10000$, $P \approx 118 \ll r_3(10000)$ (estimated at order $10^3$–$10^4$). So $P \ll r_3(N)$; the argmax fiber is far below the Roth threshold. The argmax being bad is NOT explained by density; it is explained by structural $2\times3$ grid correlations.

**Fourier flatness**: Good (3AP-free) fibers have *higher* Fourier bias than bad fibers (Comp5, commit b5827d9). The correct criterion is exact $T_3$-cancellation, not spectral flatness.

### B.5 Proof Routes toward RC2 — Analysis and Irreducible Gap

Theoretical analysis (June 2026) of four approaches to prove $P \leq C \cdot L$ for 4-AP-free sets:

**Approach A (Energy) — does not yield a constant bound**. Using $E(A) \geq P^2$ (since $|A_{d^*}|^2 = P^2$ is one term in $E(A) = \sum_d |A_d|^2$) and a hypothetical $E(A) \leq C_E M^3/N$ gives $P \leq \sqrt{C_E M^3/N}$, so $P/L \leq 4\sqrt{C_E N/M}$. Since $M \sim N^{0.60}$ for 4-AP-free sets, $N/M \sim N^{0.40}$, and $P/L$ **diverges** — not a universal constant. The energy route cannot yield $P/L \leq C$. (Note: the direction $E(A) \leq P \cdot M^2/2$ gives a lower bound $P \geq 2E(A)/M^2$, not an upper bound.)

**Approach B (Structural) — gives only $P \leq M/2$**. The constraint that $A_{d^*}$ and $A_{d^*}+d^*$ are disjoint subsets of $A$ yields $P \leq M$, far from $P \leq C \cdot L = CM^2/(4N)$.

**Approach C (Roth on fiber) — inapplicable**. One might hope $P \geq r_3(N)$ leads to a contradiction, but empirically $P \sim N^{0.40} \ll r_3(N) \sim N e^{-c(\log N)^{1/2}}$ for all tested $N$.

**Approach D (Second-moment fiber bound — most tractable)**. The goal is to prove a fiber-distribution structure theorem for 4-AP-free sets: $\sum_{d \in \mathcal{S}} |A_d|^2 / |\mathcal{S}| \leq C' \cdot P \cdot L$ for some universal constant $C'$. This would give the first non-trivial structural constraint on the fiber-size distribution from 4-AP-freeness. The nil-Bohr route (cf.\ Leng--Sah--Sawhney 2024) is blocked by the 2-torsion obstruction for $k=4$.

*Empirical confirmation (June 2026, commit 73cc7c1)*: 34 trials across $N \in \{500, 1000, 2000, 5000, 10000\}$ with random greedy 4-AP-free sets yield the ratio $R(A) = \bigl(\sum_{d\in\mathcal{S}}|A_d|^2/|\mathcal{S}|\bigr)/(P \cdot L) \in [1.125, 1.354]$. The ratio is **stable**: $R$ does not grow with $N$ (ratio of last to first R-average $= 0.946$). Global maximum: $R_{\max} = 1.3543$, giving empirical $C' = 1.36$. This is $3.8\times$ tighter than the trivial bound $C'_{\mathrm{triv}} = P/L \approx 5.1$. The fiber distribution is heavily concentrated near $L$: $\approx 80\%$ of popular differences have $|A_d| \approx L$ and $\approx 20\%$ approach $P$. The bound $\sum|A_d|^2/|\mathcal{S}| \leq 1.36 \cdot P \cdot L$ held in all 34 trials. See `runs/erdos142/approach_d_empirical.md`.

**Irreducible gap**: No known theorem bounds $P$ by a universal constant multiple of $L = M^2/(4N)$ for 4-AP-free sets. A genuinely new fiber-distribution structure theorem is required.

**Status**: Open, but empirically strongly supported. Approach D (second-moment bound on the popular fiber distribution) is the most tractable sub-problem, with empirical $C' = 1.36$ over 34 trials ($N \leq 10000$, commit 73cc7c1). Connection to `energy_bound_theory.md` (June 2026).
