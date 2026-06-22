# Technique Analysis Summary: r_k(N) Proof Methods
## Executive Summary for the Proof Strategy Agent

**Analyst**: witsoc-explorer  
**Date**: 2026-06-21  
**Full analysis**: `research/techniques.md`

---

## The Problem at a Glance

$r_k(N)$ = maximum size of a $k$-AP-free subset of $\{1,\ldots,N\}$.

**Current state (June 2026)**:

| k | Best upper bound | Best lower bound |
|---|---|---|
| 3 | $N\exp(-({\log N})^{1/6}/\log\log N)$ [Raghavan '26] | $N\exp(-c\sqrt{\log N})$ [Behrend '46, improved constant '24] |
| 4 | $N(\log N)^{-c}$ [Green-Tao '17] | $N\exp(-c\sqrt{\log N})$ |
| k≥5 | $N\exp(-(\log\log N)^{c_k})$ [Leng-Sah-Sawhney '24] | $N\exp(-c_k\sqrt{\log N})$ |

The **central gap for k=3**: upper bound exponent $1/6$ vs lower bound exponent $1/2$. Closing this is the primary technical challenge for an asymptotic formula.

---

## Five Proof Paradigms and Their Limits

### 1. Fourier / Bohr Set Approach (Roth → Bloom-Sisask 2020)
- **Mechanism**: Density increment via large Fourier coefficients → Bohr set correlation.
- **Best result**: $N/(\log N)^{1+c}$ [Bloom-Sisask 2020].
- **Hard ceiling**: The Bogolyubov-Ruzsa lemma forces Bohr rank $\sim\alpha^{-2}$; iteration gives at most polylogarithmic improvement. Cannot reach quasi-polynomial.

### 2. Almost-Periodicity / Kelley-Meka (2023 → Raghavan 2026)
- **Mechanism**: Croot-Sisask almost-periodicity + polynomial encoding of AP structure → density increment on structured Bohr sets.
- **Best result**: $N\exp(-c(\log N)^{1/6}/\log\log N)$ [Raghavan 2026]. Timeline: exponent $1/12$ (KM 2023) → $1/9$ (BS 2023) → $1/6$ (Raghavan 2026).
- **Hard ceiling**: Croot-Sisask is fundamentally quadratic ($L^2$), limiting rank growth to $\sim\alpha^{-2}$ at best, placing exponent ceiling at $1/2$. *Does not obviously extend to $k\geq 4$.*

### 3. Gowers Norm + Inverse Theorem (Green-Tao → Leng-Sah-Sawhney 2024)
- **Mechanism**: U^{k-1} Gowers norm → (quasipolynomial) inverse theorem → nilsequence correlation → density increment via nilsequence equidistribution.
- **Best result**: $N\exp(-(\log\log N)^{c_k})$ for $k\geq 5$ [LSS 2024]; $N(\log N)^{-c}$ for $k=4$ [GT 2017].
- **Hard ceiling**: Nilsequence equidistribution arguments incur exponential losses even with quasipolynomial inverse theorem bounds. For $k=4$: 2-step nilmanifolds have 2-torsion complications, no current quasi-polynomial bound.

### 4. Polynomial Method / Slice Rank (cap set breakthrough 2017)
- **Mechanism**: Encode AP membership as a polynomial vanishing condition → slice rank of the trilinear form → algebraic dimension bound.
- **Best result**: $O(2.756^n)$ for cap sets in $\mathbb{F}_3^n$ [Ellenberg-Gijswijt 2017]. **Gives only trivial bounds for $\mathbb{Z}/N\mathbb{Z}$.**
- **Hard ceiling**: The method requires a finite field structure and polynomial degree bounds over that field. Integer arithmetic has carry structure incompatible with this.

### 5. Behrend Sphere Construction (lower bound, 1946)
- **Mechanism**: Place lattice points on a sphere in $\mathbb{Z}^d$ (sphere is $k$-AP-free by convexity); embed into $\{1,\ldots,N\}$ via base-$M$ encoding; optimize $d\sim\sqrt{\log N}$.
- **Best result**: $N\exp(-c\sqrt{\log N})$ with $c\approx 2.67$ [Elsholtz et al. 2024], improving the $1946$ value of $c\approx 2.83$.
- **Hard ceiling**: Any "sphere/ellipsoid in $\mathbb{Z}^d$" construction optimizes at $d\sim\sqrt{\log N}$, giving exponent $1/2$ — cannot improve the exponent, only the constant $c$.

---

## Top 3 Most Promising New Angles

### 🥇 Angle 1: Iterated / Hierarchical Sifting Beyond Raghavan (High Priority)
**Idea**: The progression $1/12 \to 1/9 \to 1/6$ in the upper bound exponent came from successively improving the "bootstrapping" and "iteration depth" in the Kelley-Meka framework. Raghavan's iterated sifting is the current frontier.

**What to do**: Analyze whether a *doubly-iterated* sifting (iterating Raghavan's iteration) can push the exponent to $1/4$ or $1/3$. Is there a "limiting exponent" for this family of methods? Can one prove it is $1/2$?

**Technical requirement**: Show that the Croot-Sisask almost-periodicity lemma, when iterated $m$ times in a nested fashion, gives rank $O(\alpha^{-2/m})$ (instead of $O(\alpha^{-2})$), which would give exponent $m/(m+2)$ converging to $1$ — but more carefully, the exponent $1/(2k)$ for $k$-fold iteration suggests a ceiling at $1/2$ for 3-APs.

**Obstacle**: Each additional level of iteration introduces log-log factors. The question is whether these factors can be absorbed or whether they fundamentally limit the exponent.

**Plausibility**: Medium-High for improvement; Low-Medium for reaching $1/2$.

### 🥈 Angle 2: Integer Polynomial Capacity — Developing a "Z-Slice Rank" (Medium Priority)
**Idea**: The polynomial method (Ellenberg-Gijswijt) works perfectly in $\mathbb{F}_3^n$ because the 3-AP condition is $x+y+z=0$ and polynomials in $\mathbb{F}_3^n$ have bounded degree. The analogous condition in $\mathbb{Z}$ is $a+c-2b=0$. Can one define an "integer slice rank" for this condition?

**What to do**:
1. Fix a prime $p > 2N$. Work in $\mathbb{Z}/p\mathbb{Z}$.
2. Write the 3-AP condition as the vanishing of $f(a,b,c) = a+c-2b$ in $\mathbb{Z}/p\mathbb{Z}$.
3. Encode $a \in A$ via "digital polynomial": $1_A(a) = \prod_{j \in A}(a-j) / \prod_{j \in A, j\neq a}(a-j)$ — but this has degree $N-1$, too high.
4. Alternative: Use **Fourier duality** to encode $1_A$ as a trigonometric polynomial of degree $\sim |A|$ in $\mathbb{Z}/p\mathbb{Z}$, then apply slice rank bounds for $\mathbb{Z}/p\mathbb{Z}$.
5. The key question: Does a "slice rank bound" for $\mathbb{Z}/p\mathbb{Z}$ (a field of large characteristic) give non-trivial bounds for $r_3(N)$?

**Technical requirement**: A generalization of the Ellenberg-Gijswijt argument to $\mathbb{F}_p$ where $p$ is large (not small). The challenge is that the "polynomial degree bound" $\binom{n+d}{d}$ applies for polynomials of degree $d$ in $n$ variables over $\mathbb{F}_p$, and here $n=1$ (one variable in $\mathbb{Z}/p\mathbb{Z}$).

**Key insight needed**: Embed $\{1,\ldots,N\}$ into a higher-dimensional space over $\mathbb{F}_p$ such that 3-APs in $\{1,\ldots,N\}$ correspond to "sums to zero" in the higher-dimensional space, while the dimension is $O(\log N)$ and the degree bound is useful.

**Obstacle**: The carry structure in integer addition. A base-$p$ expansion gives $a = (a_0, \ldots, a_n)$ but the carry means $a + c = 2b$ does not split coordinate-wise.

**Plausibility**: Medium. Could give partial results (e.g., $r_3(N) \leq N/(\log N)^{\Omega(1)}$ without exponent improvement) or a new framework for future work.

### 🥉 Angle 3: Structural Theorem + Stability for Behrend (High Priority for Lower Bounds)
**Idea**: Prove that any large AP-free set in $\{1,\ldots,N\}$ must, up to affine transformation and a thin partition into progressions, concentrate on "sphere-like" level sets in some high-dimensional lattice. Combined with the Elsholtz et al. work on improving the Behrend constant, this could close the gap in the lower bound direction.

**What to do**:
1. Formalize "Behrend-type structure": Define a class $\mathcal{B}(d, M, R)$ of sets that are affinely equivalent to subsets of $S_R \subset \mathbb{Z}^d$ embedded via base-$M$.
2. Prove: For every AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| \geq N\exp(-c_0\sqrt{\log N})$, there exists $(d, M, R)$ and an affine map $\phi$ such that $|\phi(A) \cap \mathcal{B}(d,M,R)| \geq |A|/2$.
3. Study the optimization over the Behrend class: What is the maximum $|\mathcal{B}(d,M,R)|$ for given $N$? Is the sphere optimal or can other quadrics do better?

**Connection to Elsholtz et al.**: They already showed algebraic varieties over $\mathbb{F}_p$ give better constants. The question is whether their construction can be "pulled back" to give a structural theorem for AP-free sets in $\mathbb{Z}$.

**Technical requirement**: A "transfer principle" between AP-free sets in $\mathbb{F}_p^n$ and AP-free sets in $\{1,\ldots,N\}$. The natural transfer (Furstenberg correspondence) works for density but not for structure.

**Plausibility**: Medium-High for the structural characterization of near-extremal sets; requires significant new work.

---

## Key Open Questions

For each question, resolution would directly lead to progress:

1. **The Croot-Sisask barrier**: Can the rank bound in the almost-periodicity lemma be improved from $O(\alpha^{-2})$ to $o(\alpha^{-2})$ for some meaningful range of $\alpha$? This would immediately improve the Raghavan exponent of $1/6$.

2. **$k=4$ quasi-polynomial bound**: Is there a density increment argument for 4-APs that gives $r_4(N) \leq N\exp(-(\log N)^{c})$ for some $c > 0$? This requires a "quadratic almost-periodicity lemma" analogous to Croot-Sisask. The Leng-Sah-Sawhney $U^3$ inverse theorem is the necessary first input, but the density increment step is missing.

3. **Optimal Behrend constant**: What is the true value of $\sup\{c : r_3(N) \geq N\exp(-c\sqrt{\log N}) \text{ i.o.}\}$? The current best lower bound is $c \leq 2.67$ (Elsholtz et al.), but the true value could be larger.

4. **Integer slice rank**: Is there a useful notion of "slice rank" for the 3-AP condition in $\{1,\ldots,N\}$ (not in $\mathbb{F}_3^n$)? A positive answer would unlock the polynomial method for integers.

5. **Structure of extremal sets**: What do the sets achieving $r_3(N) \approx N\exp(-c\sqrt{\log N})$ look like? Is the Behrend sphere construction essentially the only extremal structure (up to affine equivalence)?

6. **Iterated sifting ceiling**: Is there a proof that any "almost-periodicity + iteration" based upper bound for $r_3(N)$ has exponent at most $c < 1/2$, independent of how many iterations are performed? If so, new ideas are *required* to close the gap; if not, the gap can be closed by refining current methods.

---

## Summary Verdict for the Proof Strategy Agent

**Most likely path to an asymptotic formula**: 

The field is in a "proof-of-concept" phase for quasi-polynomial bounds. For an *exact* asymptotic $r_3(N) \sim C \cdot N \exp(-c\sqrt{\log N})$, the strategy must be:

1. **Short term**: Continue the Kelley-Meka / almost-periodicity trajectory (Angle 1). Push exponent from $1/6$ toward $1/3$, $1/2$.

2. **Medium term**: Develop an "integer polynomial method" (Angle 2) as a conceptually new tool that can bypass the Croot-Sisask barrier.

3. **Long term**: Prove a stability / structure theorem (Angle 3) identifying Behrend sets as extremal, then compute the exact constant $C$.

**For k ≥ 4**: The priority is to develop "higher-order almost-periodicity" — an analogue of the Croot-Sisask lemma for the $U^3$ (or $U^{k-1}$) setting. The Leng-Sah-Sawhney quasipolynomial inverse theorem provides the necessary structural information; what's missing is the density-increment mechanism on nilBohr sets.

**Key risk**: The $\sqrt{\log N}$ exponent in Behrend may be provably optimal within current paradigms, requiring a fundamentally new construction or proof framework. This is the major uncertainty in the field.
