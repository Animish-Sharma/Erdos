# Lovász11 — P9-revised Structural Proof Attempt

**Date**: 2026-06-21  
**Session**: sess_7931396c  
**Task**: Attempt to prove P9-revised via three approaches (energy averaging, |S_min|=1 special case, van Corput identity constraint).  
**Input commit**: 767aa14  

---

## §1 Setup and Precise Statement

### Objects

Let $A \subseteq \{1,\ldots,N\}$ be a **4-AP-free** set with $|A| = M \geq 2$.

**Fiber**: $A_d = \{x \in A : x + d \in A\}$ for $d \in \{1,\ldots,N-1\}$. (Equivalently, `fiberAtDiff A d`.)

**Popular differences**: $\mathcal{S} = \{d \in \{1,\ldots,N-1\} : |A_d| \geq M^2/(4N)\}$.

**Minimum popular fiber size**: $m^* = \min_{d \in \mathcal{S}} |A_d| \geq M^2/(4N)$.

**Minimum popular difference set**: $\mathcal{S}_{\min} = \{d \in \mathcal{S} : |A_d| = m^*\}$ (argmin set).

**3-AP count in a fiber** (already proved: no step-$d$ or step-$2d$ 3-APs exist):
$$G(d) = \#\{(x,e) : x, x+e, x+2e \in A_d,\; e \neq 0, \pm d, \pm 2d\}$$
Since $A_d$ has no 3-APs with step $\pm d$ or $\pm 2d$ (Lean-proved), $G(d) = T_3(A_d)$ (the total non-trivial 3-AP count in $A_d$).

**P9-revised (precise statement)**: For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M \geq 2$:
$$\exists\, d^* \in \mathcal{S}_{\min} \text{ such that } G(d^*) = 0 \quad (\text{i.e., } A_{d^*} \text{ is 3-AP-free}).$$

### Known facts entering the proof attempt

1. $|\mathcal{S}| \geq 1$ (popular differences exist — proved unconditionally via `exists_popular_diff`, commit f676e3b).
2. $|\mathcal{S}_{\min}| \geq 1$ (since $\mathcal{S} \neq \emptyset$).
3. $m^* \leq M$ (since $A_d \subseteq A$).
4. $m^* \geq M^2/(4N)$ (pigeonhole lower bound).
5. $A_d$ has no 3-AP with step $\pm d$ or $\pm 2d$ (van_corput_fiber_step_d_apfree, van_corput_fiber_step_2d_apfree, Lean 4, commit 95092b2).
6. $m^* \leq M \leq r_4(N)$, and $r_4(N) \ll r_3(N)$ for large $N$ (thus $m^* \ll r_3(N)$ — see §5 size comparison).
7. **Empirical**: 0 counterexamples to P9-revised for $N \leq 150$ (commit b5827d9). P9 **original** (every argmin fiber is 3-AP-free) is FALSE: 184 CEs at $N \geq 30$ (commit 8349f7b). $T_3(\text{argmin}\ d) / T_3(\text{random popular}\ d) \approx 0.031$.

---

## §2 Approach A — Energy Averaging

### Goal

Show $\sum_{d \in \mathcal{S}_{\min}} G(d) < |\mathcal{S}_{\min}|$. Since $G(d) \geq 0$ and $G(d) \in \mathbb{Z}_{\geq 0}$, this forces $\min_{d \in \mathcal{S}_{\min}} G(d) = 0$, i.e., P9-revised holds.

### Reformulation as a double sum

$$\sum_{d \in \mathcal{S}_{\min}} G(d) = \sum_{\substack{(x,e):\\ x,x+e,x+2e \in A \\ e \neq 0}} |D(x,e) \cap \mathcal{S}_{\min}|$$

where $D(x,e) = \{d \in \mathcal{S}_{\min} : x+d, x+e+d, x+2e+d \in A\}$ (the set of column-steps $d$ from $\mathcal{S}_{\min}$ that extend the row $(x,x+e,x+2e)$ to a 2×3 grid in $A$).

### Key Lemma (proved): $D(x,e)$ is 4-AP-free

**Proof**: For any $(x,e)$ with $x,x+e,x+2e \in A$, we have
$$D(x,e) \subseteq (A-x) \cap (A-x-e) \cap (A-x-2e)$$
(since $d \in D(x,e)$ requires $x+d, x+e+d, x+2e+d \in A$, i.e., $d \in A-x$, $d \in A-(x+e)$, $d \in A-(x+2e)$). In particular, $D(x,e) \subseteq A-x$. Since $A$ is 4-AP-free, any translate $A-x$ is also 4-AP-free, so $D(x,e) \subseteq A-x$ is 4-AP-free. $\square$

**Corollary**: $|D(x,e) \cap \mathcal{S}_{\min}| \leq |D(x,e)| \leq r_4(N)$.

### Implication of the Key Lemma

We obtain:
$$\sum_{d \in \mathcal{S}_{\min}} G(d) \leq T_3(A) \cdot r_4(N)$$
where $T_3(A) = \#\{(x,e) : x,x+e,x+2e \in A,\, e \neq 0\}$ is the 3-AP count of $A$ itself.

**For Approach A to succeed**, we need $T_3(A) \cdot r_4(N) < |\mathcal{S}_{\min}|$.

Since $|\mathcal{S}_{\min}| \leq |\mathcal{S}| \leq N$ and $r_4(N) \geq 1$, this requires $T_3(A) < |\mathcal{S}_{\min}| / r_4(N) \leq 1$, i.e., $T_3(A) = 0$ ($A$ itself is 3-AP-free). But 4-AP-free does **not** imply 3-AP-free.

**Obstacle**: The Key Lemma gives $|D(x,e)| \leq r_4(N)$, but the sum over all 3-APs $(x,e)$ in $A$ is not controlled by $|\mathcal{S}_{\min}|$. The approach fails unless $A$ happens to be 3-AP-free.

### Sub-attempt A2: Row-sharing constraint

If $d_1, d_2 \in D(x,e)$ and $d_2 = 2d_1$ and also $3d_1 \in D(x,e)$, then $x, x+d_1, x+2d_1, x+3d_1 \in A$ — a 4-AP. Contradiction. So $D(x,e)$ avoids the pattern $\{d_1, 2d_1, 3d_1\}$ starting from 0.

More generally: $D(x,e)$ is 4-AP-free (as proved), meaning no 4 elements of $D(x,e)$ form an AP. This severely limits the "geometric" structure of $D(x,e)$ but does not bound $|D(x,e)|$ below $r_4(N)$.

### Sub-attempt A3: Expected 3-AP density of $A_d$ for minimum fibers

For $d \in \mathcal{S}_{\min}$, $|A_d| = m^*$. Heuristically (treating $A_d$ as a random subset of $\{1,\ldots,N\}$ of density $\alpha_{d^*} = m^*/N$):
$$\mathbb{E}[T_3(A_d)] \approx \frac{(m^*)^3}{N}.$$

With $m^* \approx M^2/(4N)$:
$$\mathbb{E}[G(d)] \approx \frac{M^6}{64 N^4}.$$

For this to be $< 1$ (enabling Approach A in expectation), we'd need $M^6 < 64 N^4$, i.e., $M < 2N^{2/3}$. But $r_4(N) \gg N^{2/3}$ for large $N$, so the "random" estimate predicts $G(d) \gg 1$ on average for $d \in \mathcal{S}_{\min}$ — consistent with the empirical finding that many argmin fibers DO have 3-APs (T₃ ≈ 3.15% of random fiber average). However, the key point is that $A_d$ is not random; its structure is deeply constrained by 4-AP-freeness of $A$.

### Outcome of Approach A

**Partial result**: The Key Lemma ($D(x,e)$ is 4-AP-free) is a genuine, proved combinatorial constraint. It limits the "column multiplicity" of each 3-AP row. However, it does not close P9-revised because $T_3(A)$ can be non-zero and $|D(x,e)|$ can be up to $r_4(N) \gg 1$.

**Main obstacle**: We cannot bound $\sum_{d \in \mathcal{S}_{\min}} G(d) < |\mathcal{S}_{\min}|$ without additional structural information about how 3-APs in $A$ interact with the minimum popular fibers.

**What would suffice**: A proof that $|D(x,e) \cap \mathcal{S}_{\min}| = 0$ for all but at most $|\mathcal{S}_{\min}| - 1$ triples $(x,e)$, or equivalently, that $\sum_{(x,e)} |D(x,e) \cap \mathcal{S}_{\min}| < |\mathcal{S}_{\min}|$. This is equivalent to showing at most $|\mathcal{S}_{\min}| - 1$ of the minimum fibers have $G(d) > 0$, which is exactly P9-revised. Circular.

---

## §3 Approach B — $|\mathcal{S}_{\min}| = 1$ Special Case

### Setup

Suppose $\mathcal{S}_{\min} = \{d^*\}$ (the unique minimum popular fiber, $|A_{d^*}| = m^*$ strictly less than $|A_d|$ for all other $d \in \mathcal{S}$).

**Goal**: Show $G(d^*) = 0$.

**Assume for contradiction**: $G(d^*) \geq 1$. Then $\exists\, x_0, e_0$ with $x_0, x_0+e_0, x_0+2e_0 \in A_{d^*}$ and $e_0 \neq 0, \pm d^*, \pm 2d^*$.

This gives the 2×3 grid:
$$\{x_0,\, x_0+e_0,\, x_0+2e_0,\, x_0+d^*,\, x_0+e_0+d^*,\, x_0+2e_0+d^*\} \subseteq A.$$

### Step B1: The fiber $A_{e_0}$ is non-trivial

Define $A_{e_0} = \{x \in A : x+e_0 \in A\}$. From the 2×3 grid:
- $x_0 \in A_{e_0}$ (since $x_0, x_0+e_0 \in A$). ✓
- $x_0+e_0 \in A_{e_0}$ (since $x_0+e_0, x_0+2e_0 \in A$). ✓  
- $x_0+d^* \in A_{e_0}$ (since $x_0+d^*, x_0+e_0+d^* \in A$). ✓
- $x_0+e_0+d^* \in A_{e_0}$ (since $x_0+e_0+d^*, x_0+2e_0+d^* \in A$). ✓

So $|A_{e_0}| \geq 4$ (these four elements are distinct since $e_0 \neq 0$ and $d^* \neq 0, e_0$).

### Step B2: Attempt to show $e_0 \in \mathcal{S}$ (and get a size comparison)

We need $|A_{e_0}| \geq M^2/(4N) = m^*_{\mathcal{S}}$ (the threshold, $\leq m^*$).

**Approach**: Use the "cross-fiber" pigeonhole. For each $d \in \mathcal{S}_{\min} = \{d^*\}$:
$$\sum_{e=1}^{N-1} |A_{d^*,e}| = |A_{d^*}|(|A_{d^*}|-1)/2 = m^*(m^*-1)/2$$
where $A_{d^*,e} = \{x \in A_{d^*} : x+e \in A_{d^*}\}$ is the "double-fiber."

By pigeonhole, $\exists\, e$ with $|A_{d^*,e}| \geq m^*(m^*-1)/(2N) \approx (m^*)^2/(2N)$.

Now, $A_{d^*,e} = \{x : x, x+e, x+d^*, x+e+d^* \in A\} \subseteq A_{e_0}$ (for $e_0 = e$). So:
$$|A_{e_0}| \geq |A_{d^*,e_0}| \geq \frac{(m^*)^2}{2N}.$$

For $e_0 \in \mathcal{S}$ (qualifying as a popular difference), we need:
$$|A_{e_0}| \geq \frac{M^2}{4N}.$$

So the condition is $(m^*)^2/(2N) \geq M^2/(4N)$, i.e., $2(m^*)^2 \geq M^2$, i.e., $m^* \geq M/\sqrt{2}$.

But $m^* \leq M$ (and typically $m^* \approx M^2/(4N) \ll M$), so this is FALSE in general.

**Obstacle**: The cross-fiber pigeonhole gives $|A_{e_0}| \geq (m^*)^2/(2N)$, which is much smaller than the threshold $M^2/(4N)$ (since $m^* \ll M$ for large $N$). So we cannot conclude $e_0 \in \mathcal{S}$.

### Step B3: Attempt to show $e_0 \in \mathcal{S}$ directly via the 3-AP structure

The 3-AP $(x_0, x_0+e_0, x_0+2e_0) \in A_{d^*}$ gives 3 elements of $A$ in AP with step $e_0$. This contributes at least 2 to $|A_{e_0}|$ (namely $x_0$ and $x_0+e_0$). But more of $A$ can "align" with step $e_0$.

**Observation**: The existence of ONE 3-AP with step $e_0$ in $A_{d^*}$ is not sufficient to establish that $|A_{e_0}|$ is "large" (comparable to $m^*$). The fiber $A_{e_0}$ can be arbitrarily small (as small as $\{x_0, x_0+e_0\}$).

### Step B4: Minimality contradiction attempt

Suppose $e_0 \in \mathcal{S}$ (i.e., $|A_{e_0}| \geq M^2/(4N)$). Since $\mathcal{S}_{\min} = \{d^*\}$, we have $|A_{e_0}| > m^*$ (strict inequality by uniqueness of minimum). But $e_0$ could be in $\mathcal{S}$ with $|A_{e_0}| > m^*$ — this is not a contradiction; many $d \in \mathcal{S}$ have $|A_d| > m^*$.

What we'd need: $|A_{e_0}| < m^*$, meaning $e_0 \notin \mathcal{S}$ (good, no contradiction with minimality) OR $|A_{e_0}| = m^*$ (meaning $e_0 \in \mathcal{S}_{\min} = \{d^*\}$, so $e_0 = d^*$ — but $e_0 \neq d^*$ by assumption). So if $e_0 \in \mathcal{S}$, then $|A_{e_0}| > m^*$ (since $e_0 \neq d^*$ and $d^*$ is the unique minimum). This gives no contradiction.

### Step B5: Using the 2×3 grid structure

We have the 2×3 grid $\{x_0, x_0+e_0, x_0+2e_0, x_0+d^*, x_0+e_0+d^*, x_0+2e_0+d^*\} \subseteq A$. Consider the "diagonal" element $x_0+e_0+d^*$: it's the "center" of the grid. 

Can we build a 4-AP from the grid elements? A 4-AP $a, a+s, a+2s, a+3s$ needs 4 elements in AP. From the grid, we have:
- Row with step $e_0$: $x_0, x_0+e_0, x_0+2e_0, x_0+3e_0$ — needs $x_0+3e_0 \in A$ (not given).
- Column with step $d^*$: We only have 2 columns ($x_0$ and $x_0+d^*$), so a length-4 AP with step $d^*$ needs $x_0+2d^*, x_0+3d^* \in A$ (not given).
- Diagonal with step $e_0+d^*$: $x_0, x_0+e_0+d^*, x_0+2(e_0+d^*)$ — needs $x_0+2e_0+2d^* \in A$.
- Diagonal with step $d^*-e_0$ (or $e_0-d^*$): $x_0+2e_0, x_0+2e_0+(d^*-e_0)=x_0+e_0+d^*, x_0+2e_0+2(d^*-e_0) = x_0+2d^*$ — needs $x_0+2d^* \in A$.

None of these close immediately.

### Outcome of Approach B

**Partial result**: From $G(d^*) > 0$, we extract a 2×3 grid in $A$ and show $|A_{e_0}| \geq 4$. We also show $|A_{e_0}| \geq (m^*)^2/(2N)$ via cross-fiber pigeonhole. Neither gives $e_0 \in \mathcal{S}$ nor leads to a contradiction with minimality of $d^*$.

**Main obstacle**: The cross-fiber bound $(m^*)^2/(2N)$ is weaker than the popular-difference threshold $M^2/(4N)$ by a factor of $(m^*/M)^2 \cdot 2 \leq 2$ (since $m^* \leq M$) — wait, actually it's $(m^*)^2/(2N) \geq M^2/(4N)$ iff $2m^{*2} \geq M^2$ iff $m^* \geq M/\sqrt{2}$. Since $m^* \leq M$, this can hold only if $m^* \approx M$. For small $m^*$ (the generic case where $m^* \ll M$), the approach fails.

**What would suffice**: A proof that $|A_{e_0}| \geq M^2/(4N)$ (i.e., $e_0 \in \mathcal{S}$) and $|A_{e_0}| < m^* = |A_{d^*}|$. The second inequality would give $e_0 \in \mathcal{S}_{\min}$ but $e_0 \neq d^*$, contradicting $\mathcal{S}_{\min} = \{d^*\}$. But neither inequality is establishable with current tools.

---

## §4 Approach C — Van Corput Identity Constraint

### The standard van Corput identity

The identity used in our paper:
$$\Lambda_4(A) = \sum_{d=1}^{N-1} \Lambda_3^{(d)}(A_d)$$
where $\Lambda_3^{(d)}(A_d) = \#\{(x,e) : x, x+d, x+2d \in A_d\}$ (3-APs with step $d$ in $A_d$). Since $A$ is 4-AP-free, $\Lambda_4(A) = 0$, and each term $\Lambda_3^{(d)}(A_d) = 0$ (proved: `van_corput_fiber_step_d_apfree`).

**Observation**: This identity constrains ONLY step-$d$ 3-APs in $A_d$. It gives **zero information** about $T_3(A_d)$ (3-APs with arbitrary step $e \neq d$ in $A_d$). So $\Lambda_4(A) = 0$ does NOT directly bound $G(d) = T_3(A_d)$.

### A generalized van Corput count

Define the "2×3 grid count":
$$\mathcal{G}(A) = \sum_{d=1}^{N-1} G(d) = \#\{(d,x,e) : x,x+e,x+2e \in A_d,\; e \neq 0\}$$
$$= \#\{(d,x,e) : x,x+e,x+2e,x+d,x+e+d,x+2e+d \in A,\; e \neq 0\}$$
(the total count of 2×3 arithmetic grids in $A$, excluding degenerate cases).

**Key question**: Is $\mathcal{G}(A)$ bounded by $\Lambda_4(A) = 0$ or some related quantity?

**Answer**: No, not directly. A 2×3 grid is **not** a 4-AP: it has 6 elements and no 4 are in a single arithmetic progression (generically). So $\Lambda_4(A) = 0$ does not force $\mathcal{G}(A) = 0$. The 2×3 grid avoids 4-APs by the independence of row step $e$ and column step $d$.

### Gowers $U^3$ norm approach

The Gowers $U^3$ norm of $1_A$:
$$\|1_A\|_{U^3}^8 = \sum_{x,a,b,c \in \mathbb{Z}_N} 1_A(x) 1_A(x+a) 1_A(x+b) 1_A(x+a+b) 1_A(x+c) 1_A(x+a+c) 1_A(x+b+c) 1_A(x+a+b+c)$$
counts "combinatorial cubes" in $A$ (8-tuples forming a 3-dimensional parallelepiped).

**Connection to 4-APs**: By the inverse theorem (Bergelson–Leibman / Gowers), $\|1_A\|_{U^3} \geq c$ for some $c > 0$ only if $A$ correlates with a degree-2 nilsequence, which can be used to find structured patterns including 4-APs. For 4-AP-free $A$, the $U^3$ norm must be "small" (relative to $M/N$).

**Connection to $\mathcal{G}(A)$**: The $U^3$ norm involves cubes, while $\mathcal{G}(A)$ involves 2×3 grids. There is NO direct identity $\|1_A\|_{U^3}^8 = f(\mathcal{G}(A))$ for a simple function $f$.

A relevant (but weaker) connection: The $U^2$ norm counts "parallelograms" (2×2 grids):
$$\|1_A\|_{U^2}^4 = \#\{(x,a,b) : x, x+a, x+b, x+a+b \in A\} = \sum_d |A_d|^2.$$

And:
$$\sum_{d} G(d) = \sum_{d} T_3(A_d) = \sum_{d} \#\{3\text{-APs in }A_d\}.$$

By Cauchy-Schwarz or Fourier analysis, $T_3(A_d) \leq |A_d|^{1/2} \cdot N^{1/2} \cdot \|1_{A_d}\|_{U^2}^2 / N$ (roughly). But this doesn't simplify things.

### A potentially useful inequality (Approach C, partial)

**Claim**: $\sum_{d \in \mathcal{S}} T_3(A_d) \leq \|1_A\|_{U^3}^4 \cdot N^2$ (heuristic, not proved).

**Sketch**: A 3-AP $(x, x+e, x+2e) \in A_d$ corresponds to a 2×3 grid in $A$. A 2×3 grid is a "shadow" of a 3-dimensional structure. The $U^3$ norm counts all 3-dimensional combinatorial cubes. The number of 2×3 grids is bounded by (roughly) the cube-root of the number of $U^3$ cubes times some combinatorial factor... but this is hand-wavy and not a clean inequality.

**What we actually know**: By Kelley-Meka (2023) / Green-Tao (2017), for 4-AP-free $A$:
$$\|1_A\|_{U^3} \leq C \cdot (M/N) \cdot (\log N)^{-c}.$$

This gives some bound on $\mathcal{G}(A)$ via the $U^3$ norm, but extracting a useful bound on $\sum_{d \in \mathcal{S}_{\min}} G(d)$ requires:
1. Isolating the contribution of $d \in \mathcal{S}_{\min}$ (a small subset of $d$'s).
2. Relating $G(d)$ to the $U^3$ norm locally near $d$.

Neither step is straightforward.

### Fourier reformulation (Approach C, Fourier side)

By the Fourier identity for 3-AP counts (proven in §2 of the paper):
$$T_3(A_d) = G(d) = \frac{1}{N} \sum_{\xi \neq 0} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi)$$
(where $\hat{A}_d(\xi) = \sum_{x \in A_d} e^{2\pi i x\xi/N}$, after removing the step-$d$ and step-$2d$ contributions that are already 0).

$G(d) = 0$ iff $\sum_{\xi \neq 0} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi) = 0$ (exact cancellation).

**Summing over $d \in \mathcal{S}_{\min}$**:
$$\sum_{d \in \mathcal{S}_{\min}} G(d) = \frac{1}{N} \sum_{d \in \mathcal{S}_{\min}} \sum_{\xi \neq 0} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi)$$
$$= \frac{1}{N} \sum_{\xi \neq 0} \sum_{d \in \mathcal{S}_{\min}} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi).$$

For this to be $< |\mathcal{S}_{\min}|$, we need the double sum to be $< N |\mathcal{S}_{\min}|$.

The term $\sum_{d \in \mathcal{S}_{\min}} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi)$ mixes Fourier coefficients of different fibers at the same frequency $\xi$. The relationship between $\hat{A}_d(\xi)$ and the global Fourier transform $\hat{A}(\xi)$ is complex ($\hat{A}_d(\xi) \neq \hat{A}(\xi)$ in a simple way).

**Obstacle**: No clean identity relates $\sum_d \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi)$ to $\hat{A}(\xi)$ or $\Lambda_4(A) = 0$ in a way that forces $\sum_{d \in \mathcal{S}_{\min}} G(d) < |\mathcal{S}_{\min}|$.

### Outcome of Approach C

**Main finding**: The van Corput identity $\Lambda_4(A) = \sum_d \Lambda_3^{(d)}(A_d) = 0$ constrains only step-$d$ 3-APs, which are already 0. It gives no direct constraint on $T_3(A_d)$.

**Gowers $U^3$ bound**: Gives a global bound on parallelogram/cube counts, but isolating the minimum-fiber contribution requires additional structure.

**Fourier approach**: Reduces to showing $\frac{1}{N}\sum_{d \in \mathcal{S}_{\min}} \sum_{\xi \neq 0} \hat{A}_d(\xi)^2 \hat{A}_d(-2\xi) < |\mathcal{S}_{\min}|$, which is exactly P9-revised reformulated — no progress.

---

## §5 Synthesis and Best Path Forward

### Summary of obstacles

| Approach | Partial result | Main obstacle |
|---|---|---|
| A (Energy avg) | $D(x,e)$ is 4-AP-free (proved!) | Cannot bound $\sum_{(x,e)} \|D(x,e) \cap \mathcal{S}_{\min}\| < |\mathcal{S}_{\min}|$ |
| B ($|\mathcal{S}_{\min}|=1$) | $|A_{e_0}| \geq (m^*)^2/(2N)$ | Cross-fiber bound too weak: $(m^*)^2/(2N) \ll M^2/(4N)$ |
| C (Van Corput) | Identity only constrains step-$d$ terms (= 0) | No clean identity relating $\sum_d T_3(A_d)$ to $\Lambda_4(A)$ |

### The D(x,e) 4-AP-freeness lemma (Approach A, proved)

This is the most concrete result. Let us state it cleanly:

**Lemma** (lovász11, 2026-06-21): *Let $A \subseteq \{1,\ldots,N\}$ be 4-AP-free. For any $x, e \in \mathbb{Z}$ with $x, x+e, x+2e \in A$, the set*
$$D(x,e) = \{d \in \{1,\ldots,N-1\} : x+d, x+e+d, x+2e+d \in A\}$$
*is 4-AP-free (as a subset of $\{1,\ldots,N-1\}$). In particular, $|D(x,e)| \leq r_4(N-1) \leq r_4(N)$.*

**Proof**: $D(x,e) \subseteq \{d : x+d \in A\} = A-x$ (a translate of $A$, hence 4-AP-free). $\square$

**Significance**: This says that the "column multiplicity" of any fixed 3-AP row in $\mathcal{S}_{\min}$ is bounded above by $r_4(N)$. It is not strong enough for P9-revised alone, but it is the correct starting point for any energy-averaging proof.

### Size comparison: why minimum fibers "should" be 3-AP-free

A critical heuristic observation:

$m^* \leq r_4(N)$ (since $m^* \leq M \leq r_4(N)$).

By Kelley-Meka (2023) / Green-Tao (2017): $r_4(N) = O(N/(log N)^c)$.

By Behrend (1946): $r_3(N) = \Omega(N \cdot \exp(-C\sqrt{\log N}))$.

So $m^* \leq r_4(N) \ll r_3(N)$ for large $N$.

This means: the minimum popular fiber $A_{d^*}$ has size $m^* \leq r_4(N) \ll r_3(N)$. Therefore, $A_{d^*}$ has size **well below** the 3-AP threshold $r_3(N)$! There exist 3-AP-free sets of size $m^*$ in $\{1,\ldots,N\}$. Indeed, 3-AP-freeness is NOT precluded by size alone.

**Contrast**: A 4-AP-free set $A$ has $M \leq r_4(N) \ll r_3(N)$, so $A$ itself could also be 3-AP-free — but typically isn't. The fibers $A_d$ are subsets of $A$, hence 4-AP-free, but also "sparse" (size $\leq M$), so 3-AP-freeness is feasible.

This is a heuristic **supporting** P9-revised (minimum fibers are in the "size range" where 3-AP-free sets exist), but it is not a proof (not all sets of size $m^*$ are 3-AP-free).

### Best path forward

**Direction 1** (Refine Approach A): Find a structural reason why $\sum_{d \in \mathcal{S}_{\min}} G(d) < |\mathcal{S}_{\min}|$. This would require:
- Showing that "2×3 grids in $A$ with column in $\mathcal{S}_{\min}$" are rare — fewer than $|\mathcal{S}_{\min}|$ total.
- Key tool needed: A counting lemma showing $\#\{(d,x,e) : d \in \mathcal{S}_{\min}, \text{ 2×3 grid in }A\} < |\mathcal{S}_{\min}|$.
- Plausibility: The empirical ratio $\sim 0.031$ suggests that for most $d \in \mathcal{S}_{\min}$, $G(d) = 0$ (very small average). So the sum IS small empirically — the challenge is proving it.

**Direction 2** (Refine Approach B): Strengthen the cross-fiber size bound. The key would be to show that if $A_{d^*}$ has many 3-APs with step $e$, then $|A_e|$ must be large (at least $m^*$), leading to $e \in \mathcal{S}$ and a contradiction with $\mathcal{S}_{\min} = \{d^*\}$. This would require a "fiber transfer" lemma:

**Conjectured Lemma** (not proved): If $A$ is 4-AP-free and $A_d$ has a 3-AP with step $e$, then $|A_e| \cdot |A_d| \geq C \cdot M^2 / N$ for some absolute constant $C > 0$.

If true with $C \geq 1$, this would give $|A_e| \geq M^2/(N \cdot |A_d|) = M^2/(N \cdot m^*)$. For this to be $\geq M^2/(4N) = m^*_{\mathcal{S}}$ (threshold), we need $m^* \leq 4$. Too restrictive.

**Direction 3** (New approach — "competitive minimality"): When $A_{d^*}$ has a 3-AP with step $e$ (small $e$), perhaps the fiber $A_e$ has size comparable to $|A_{d^*}+e| = |A_{d^*+e}|$. If $|A_{d^*+e}| < m^*$, then $d^*+e \notin \mathcal{S}$, but if $|A_{d^*+e}| = m^*$, then $d^*+e \in \mathcal{S}_{\min}$ (a new minimum fiber). One could hope to "cascade" from $d^*$ to $d^*+e$ to $d^*+2e$, eventually hitting a 3-AP-free fiber. But formalizing this cascade requires a "fiber size along AP progressions" lemma, also not available.

**Direction 4** (Computational experiment): Verify whether, for $N \leq 200$:
- The "second most popular" argmin fiber (ties for minimum size) is always 3-AP-free.
- More precisely: classify all CE cases (where some argmin fibers have 3-APs) and check whether the 3-AP-free argmin fibers have any distinguishing Fourier or combinatorial property.

This could suggest a more targeted proof approach.

### Assessment

P9-revised is **genuinely hard**. All three approaches hit structural obstacles:

1. Approach A needs a key counting lemma that doesn't follow from 4-AP-freeness alone.
2. Approach B's cross-fiber bound is off by a factor of $(m^*/M)^2 \leq 1$ (too weak).
3. Approach C shows the van Corput identity is "blind" to non-column 3-APs in fibers.

The most genuinely useful partial result is the **D(x,e) is 4-AP-free** lemma, which bounds column multiplicity and is the correct starting point for Approach A.

---

## §6 WIT/Paper Update

### What is worth adding

**1. WIT Step 29 — Approach A partial result** (worth adding):

The Key Lemma (D(x,e) is 4-AP-free) is a proved partial result for Approach A. Add to WIT Step 29:

> **Approach A partial result** (lovász11, 2026-06-21): For any 3-AP $(x,e)$ in $A$, the set $D(x,e) = \{d \in \mathcal{S}_{\min} : (x+d, x+e+d, x+2e+d) \subseteq A\}$ is 4-AP-free (as a subset of $A-x$). Hence $|D(x,e)| \leq r_4(N)$. The energy sum $\sum_{d \in \mathcal{S}_{\min}} G(d) = \sum_{(x,e)} |D(x,e) \cap \mathcal{S}_{\min}|$ is thus bounded by $T_3(A) \cdot r_4(N)$. This closes the approach if $T_3(A) < |\mathcal{S}_{\min}| / r_4(N)$, but not in general (4-AP-free $A$ can have 3-APs).

**2. WIT Step 29 — Size comparison** (worth adding):

> **Size comparison heuristic** (lovász11, 2026-06-21): $m^* \leq r_4(N) \ll r_3(N)$ for large $N$ (since $r_4(N)/r_3(N) \to 0$). So minimum popular fibers have size well below the 3-AP threshold. This does NOT prove P9-revised but shows 3-AP-freeness is size-compatible (there exist 3-AP-free sets of size $m^*$ in $\{1,\ldots,N\}$).

**3. Paper §6 P9-revised evidence note** (minor addition, worth adding):

Add a sentence to P9-revised: "Approach A (energy averaging) yields a partial result: for any 3-AP $(x,e)$ in $A$, the set $D(x,e)$ of column-differences is 4-AP-free, giving a combinatorial constraint on how minimum fibers interact with 3-APs in $A$. A complete proof via Approach A would require bounding $\sum_{d \in \mathcal{S}_{\min}} G(d) < |\mathcal{S}_{\min}|$, which is not established."

### What is NOT worth adding (no complete proof)

P9-revised remains **OPEN**. The status in paper and WIT does not change. The two partial results (D(x,e) 4-AP-free and size comparison) are heuristics/lemmas supporting the conjecture but not closing it.

---

## Appendix: Empirical verification notes

From commit 8349f7b: $T_3(\text{argmin } d) / T_3(\text{random popular } d) \approx 0.031$. This means minimum fibers have 3.15% as many 3-APs as random popular fibers. This is consistent with the size comparison ($m^* \ll r_3(N)$) and the D(x,e) 4-AP-free constraint (column multiplicity bounded). Together, these suggest minimum fibers are "almost 3-AP-free" structurally.

For the N=40 canonical CE: fibers at $d \in \{18,22,27,29\}$ (all minimum size 5) are 3-AP-free, while $d=24$ (also size 5) has the 3-AP $(5,10,15)$. This is consistent with P9-revised: SOME argmin fiber ($d \in \{18,22,27,29\}$) has $G(d)=0$.

**End of Lovász11 analysis.**
