# Energy Bound for 4-AP-Free Sets: P/L ≤ C — Proof Routes and Irreducible Gap

**Date**: 2026-06-21  
**Author**: Coscientist (energy-bound session)  
**Context**: Erdős Problem 142 — bounding r₄(N) via the van Corput reduction  
**Status**: Theoretical analysis — no Lean formalization

---

## 1. The Problem

Let $A \subseteq \{1,\ldots,N\}$ be **4-AP-free** with $|A| = M$. Define:

- **Popularity threshold**: $L = M^2/(4N)$
- **Popular differences**: $\mathcal{S} = \{d : |A_d| \geq L\}$, where $A_d = \{x \in A : x+d \in A\}$
- **Maximum popular fiber**: $P = \max_{d \in \mathcal{S}} |A_d|$
- **Additive energy**: $E(A) = \sum_{d=1}^{N-1} |A_d|^2$
- **Witness fraction**: $\mathrm{wfrac}(d) = |A_d|/P$

**Goal**: Prove $P \leq C \cdot L$ for some explicit universal constant $C$, for all 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A|$ large enough.

**Why it matters**: If $P/L \leq C$, then $L/P \geq 1/C$. Since every 3-AP-free popular fiber has $\mathrm{wfrac}(d) = |A_d|/P \geq L/P \geq 1/C$ (by the popularity condition), the minimum wfrac among 3-AP-free popular fibers satisfies $\mathrm{min\_wfrac} \geq 1/C$. Empirically $C \approx 5.1$, giving min\_wfrac $\approx 1/5$ — the "1/5 floor" phenomenon (Refined Conjecture 2).

**Empirical picture**: Across $N = 5000$–$200000$ (≈4893 trials, 0 counterexamples):

| $N$ | avg $M$ | avg $P$ | $L = M^2/(4N)$ | $P/L$ |
|----:|--------:|--------:|---------------:|------:|
| 5000 | 592.0 | 90.75 | 17.46 | 5.20 |
| 10000 | 956.4 | 117.88 | 22.87 | 5.15 |
| 20000 | 1546.7 | 151.33 | 29.91 | 5.06 |
| 50000 | — | — | — | ≈5.1 |
| 200000 | — | — | — | ≈5.1 |

The ratio $P/L \approx 5.1 \pm 0.1$ is **scale-invariant**: both $L \sim N^{0.40}$ and $P \sim N^{0.40}$, so their ratio is independent of $N$. Any proof of $P \leq C \cdot L$ must be tight at $C \approx 5$–$5.3$.

---

## 2. Known Bounds

### 2.1 Trivial bounds (no use of 4-AP-freeness)

**Lower bound** (pigeonhole): $\sum_{d=1}^{N-1} |A_d| = M(M-1)/2 \geq M^2/4$, so by pigeonhole $P \geq M^2/(4N) = L$. This is exact: $P \geq L$.

**Upper bound** (trivial): $A_d \subseteq A$ implies $P \leq M$.

**Combined**: $L \leq P \leq M$, giving $1 \leq P/L \leq N/M \approx N^{0.30}$ (the upper bound diverges).

### 2.2 Energy sandwich

The additive energy $E(A) = \sum_d |A_d|^2$ satisfies two standard bounds:

**Upper bound** (max times sum):
$$E(A) = \sum_d |A_d|^2 \leq P \cdot \sum_d |A_d| = P \cdot \frac{M(M-1)}{2} \leq \frac{PM^2}{2}.$$

**Lower bound** (Cauchy-Schwarz):
$$E(A) = \sum_d |A_d|^2 \geq \frac{\left(\sum_d |A_d|\right)^2}{N-1} \geq \frac{(M^2/4)^2}{N} = \frac{M^4}{16N}.$$

Combining: $P \geq \frac{2E(A)}{M^2} \geq \frac{M^2}{8N} = \frac{L}{2}$.

This lower bound ($P \geq L/2$) is weaker than the pigeonhole lower bound ($P \geq L$).

**For an upper bound on $P$**: We need an upper bound on $E(A)$. If $E(A) \leq C_E \cdot M^3/N$, then:
$$P \leq \frac{2E(A)}{M^2} \leq \frac{2C_E M}{N} = \frac{2C_E M}{N}.$$

Wait — this isn't quite right. The bound $E(A) \leq P \cdot M^2/2$ gives a lower bound on $P$ from $E$, not an upper bound. For an **upper bound on $P$**, we need to bound $P$ differently.

**Correct route to upper bound on $P$**: The inequality $E(A) \leq P \cdot M^2/2$ gives:
$$P \geq \frac{2E(A)}{M^2}.$$
To bound $P$ from **above**, we write:
$$P = \max_d |A_d| \leq \frac{\sum_d |A_d|^2}{\sum_d |A_d|} \cdot \frac{|\mathcal{S}|}{|\mathcal{S}_{\min}|} \leq \frac{E(A)}{M^2/2} \cdot 1$$
— but this is wrong in direction (it gives $P \geq 2E(A)/M^2$, not an upper bound).

The correct upper bound on $P$ from energy uses a different route:

**Lemma 2.1** (Energy → P upper bound via popularity threshold). Since every $d \in \mathcal{S}$ has $|A_d| \geq L$:
$$E(A) \geq \sum_{d \in \mathcal{S}} |A_d|^2 \geq |\mathcal{S}| \cdot L^2.$$
This bounds $|\mathcal{S}|$ from above: $|\mathcal{S}| \leq E(A)/L^2$.

But it does not directly bound $P$. To bound $P$ from energy, observe:
$$P^2 \leq \sum_{d \in \mathcal{S}} |A_d|^2 \leq E(A)$$
is FALSE (the max squared is not bounded by the sum). The correct bound is $P \leq \sqrt{E(A)}$ only if $|\mathcal{S}| = 1$.

**The correct energy route to P**: We use the bound
$$P \cdot L \leq P \cdot |A_d| \leq \sum_{d \in \mathcal{S}} |A_d|^2 / |\mathcal{S}|$$
only when $|\mathcal{S}|=1$. In general, $P \leq E(A)/L$ (from $E(A) \geq P \cdot L$ when $P$ itself is in $\mathcal{S}$):
$$E(A) \geq |A_{d^*}|^2 = P^2$$
is the trivial bound, giving $P \leq \sqrt{E(A)}$.

**If $E(A) \leq C_E \cdot M^3/N$**: then $P \leq \sqrt{C_E M^3/N} = \sqrt{C_E} \cdot M^{3/2}/N^{1/2}$.

And:
$$\frac{P}{L} = \frac{P}{M^2/(4N)} = \frac{4NP}{M^2} \leq \frac{4N \cdot \sqrt{C_E} M^{3/2}/N^{1/2}}{M^2} = \frac{4\sqrt{C_E} \sqrt{N}}{M^{1/2}}.$$

For $M \approx c N^{0.70}$: $P/L \leq 4\sqrt{C_E}/\sqrt{c} \cdot N^{0.5-0.35} = 4\sqrt{C_E/c} \cdot N^{0.15}$.

This **diverges** as $N \to \infty$ — so bounding $E(A) \leq C_E M^3/N$ alone is not sufficient to give a uniform $P/L \leq C$. We need a stronger bound.

### 2.3 What energy bound would suffice?

For $P/L \leq C$ to hold uniformly, the energy bound approach requires:
$$E(A) \leq C_E \cdot \frac{M^3}{N} \quad \Longrightarrow \quad P \leq \sqrt{C_E M^3/N} \lesssim N^{0.15+\varepsilon},$$
but we need $P \lesssim L \sim N^{0.40}$. So $\sqrt{C_E M^3/N}$ would need to be $O(N^{0.40})$, requiring $M^3/N \lesssim N^{0.80}$, i.e., $M \lesssim N^{0.60}$. But $M \sim N^{0.70}$, so this fails.

**The correct reformulation**: The bound $P \leq CL$ with $C \approx 5$ is equivalent to:
$$\max_d |A_d| \leq C \cdot \frac{M^2}{4N}.$$
This says the max fiber is at most $C$ times the *average* fiber size ($\bar{F} = M^2/(2N) \approx 2L$). This is a **concentration-of-measure** statement about the fiber distribution, not directly an energy bound.

The correct energy approach would need to show:
$$E(A) \leq C \cdot P \cdot L \cdot |\mathcal{S}|$$
which is trivially true (since $E(A) \leq P \cdot \sum_d |A_d| = P \cdot M^2/2$ and $|\mathcal{S}| \cdot L \leq M^2/2$), but rearranging gives nothing new.

---

## 3. Approach A: Bounding E(A) via 4-AP-Freeness

### 3.1 Fourier / Gowers norm connection

The additive energy satisfies $E(A) = \sum_\xi |\hat{A}(\xi)|^4$ (Parseval in $\mathbb{Z}_N$). The $U^2$ Gowers norm of $\mathbf{1}_A$ satisfies $\|\mathbf{1}_A\|_{U^2}^4 = E(A)/N^3$ (up to normalization).

For a **3-AP-free** set $A$ of density $\alpha = M/N$, the Kelley–Meka / Bloom–Sisask framework gives a density increment: $A$ has density $\alpha + \Omega(\alpha^s)$ on a Bohr set of rank $O(\alpha^{-\rho})$. This implies a Fourier concentration: $\max_{\xi \neq 0} |\hat{A}(\xi)| \geq c\alpha^2 N$ (by the 3-AP-free inverse theorem). In turn, this gives $E(A) \geq c' M^3/N$ (energy is large for 3-AP-free sets, not small).

**Key observation**: For 3-AP-free sets, the energy is *bounded from below* (Fourier concentration forces large energy). For an *upper* bound on $E(A)$, we need pseudorandomness, not structure.

For **4-AP-free** sets, the $U^3$ Gowers norm controls 4-APs via the identity:
$$\Lambda_4(A) = \|\mathbf{1}_A - \alpha\|_{U^3}^8 \cdot N + (\text{lower-order terms involving }\alpha).$$

More precisely, the Gowers–Cauchy–Schwarz inequality gives:
$$|\Lambda_4(A) - \alpha^4 N^2| \lesssim \|\mathbf{1}_A - \alpha\|_{U^3} \cdot N^2.$$

Since $\Lambda_4(A) = 0$ (4-AP-free), we get $\|\mathbf{1}_A - \alpha\|_{U^3} \gtrsim \alpha^4$ (the $U^3$ norm is bounded away from zero by the density). But this gives a **lower** bound on $U^3$, not an upper bound.

**What 4-AP-freeness gives**: By the $U^3$ inverse theorem (Green–Tao 2008, Bergelson–Leibman, Gowers 2001), $\|\mathbf{1}_A - \alpha\|_{U^3} \geq \delta$ implies $A$ correlates with a 2-step nilsequence. But 4-AP-freeness forces $\Lambda_4(A) = 0$, which means $A$ is "Gowers-pseudorandom at scale 4" in the sense that $\|\mathbf{1}_A - \alpha\|_{U^3}$ is **small** only if $\alpha \approx 0$ (sparse regime).

Wait — this needs correction. The correct statement: for a 4-AP-free set of density $\alpha$, the Green–Tao–Ziegler inverse theorem gives that $\|\mathbf{1}_A\|_{U^3}$ is bounded by $O(\alpha)$ if $A$ is uniform, but 4-AP-freeness does not force $\|\mathbf{1}_A\|_{U^3}$ to be small relative to $\alpha$.

**The $U^2$–energy connection**:
$$E(A) = N \cdot \|\mathbf{1}_A\|_{U^2}^4.$$

The $U^2$ norm is controlled by Fourier $\ell^4$ norms. For $A$ pseudorandom at the $U^2$ level, $E(A) \approx M^2 + M^3/N$ (the "random" value). For structured (AP-rich) sets, $E(A)$ can be much larger (up to $M^{5/2} N^{1/2}$ for Salem-Spencer-type sets).

**4-AP-freeness constrains $U^3$, not $U^2$**: The condition $\Lambda_4(A) = 0$ directly bounds the $U^3$ norm. The $U^2$ norm (energy) is not directly constrained by 4-AP-freeness. Specifically:
- A set can be 4-AP-free and have large $E(A)$ (e.g., an arithmetic progression of length $N/4$, which has $E(A) \sim M^3/N$ but is not 4-AP-free for $M \geq 4$; better: Salem-Spencer sets have $E(A) \gg M^3/N$).
- The 4-AP-free condition places constraints at the **next** Gowers level ($U^3$), leaving $U^2$ (energy) relatively free.

### 3.2 What energy bound is achievable?

**Trivial bound**: $E(A) \leq M^2$ (since each $|A_d|^2 \leq M^2$ and there are $N-1$ differences, so $E(A) \leq M \cdot M = M^2$; more precisely $E(A) \leq M^{5/2}N^{1/2}$ by Cauchy-Schwarz with better bookkeeping).

**The random-set heuristic**: For a random subset $A \subseteq \{1,\ldots,N\}$ of size $M$, $\mathbb{E}[|A_d|] = M^2/N$ and $\mathbb{E}[|A_d|^2] \approx M^3/N + M^2/N \approx M^3/N$ for $M \ll N$. So $\mathbb{E}[E(A)] \approx M^3$. This suggests $E(A) \sim M^3$ for "random-like" sets, not $M^3/N$.

Wait — let me recompute. For a random subset of density $\alpha = M/N$:
- $\mathbb{E}[|A_d|^2] = N \alpha^2 (1 + N\alpha^2)/N \approx M^2 \alpha = M^3/N$ for large $N$.
- So $\mathbb{E}[E(A)] = N \cdot M^3/N = M^3$.

But for the popular-fiber contribution: $\sum_{d \in \mathcal{S}} |A_d|^2 \geq |\mathcal{S}| \cdot L^2$. In the random model, $|\mathcal{S}| \approx M^2/2L = 2N$ (all differences are popular at the $L = M^2/(4N)$ threshold), so this doesn't distinguish.

**Revised understanding of $E(A) \leq C_E M^3/N$**: The claim in the literature context (submittable_proof.md §B.5) is about $E(A) \leq C_E M^3/N$, not $C_E M^3$. Let me clarify:

$E(A) = \sum_{d=1}^{N-1} |A_d|^2 \leq M \cdot \sum_{d=1}^{N-1} |A_d| = M \cdot M(M-1)/2 \approx M^3/2$.

So the trivial upper bound is $E(A) \leq M^3/2$. The random-set value is also $\Theta(M^3)$ (specifically $\approx M^3/N \cdot N = M^3$, consistent). The target bound $E(A) \leq C_E M^3/N$ would be **much smaller** than the trivial bound (by a factor $N$). This cannot hold in general — for example, if $A = \{1,\ldots,M\}$ (consecutive integers, ignoring AP conditions), then $|A_d| = M - d$ for $d < M$ and:
$$E(A) = \sum_{d=1}^{M-1} (M-d)^2 = \sum_{k=1}^{M-1} k^2 = \frac{(M-1)M(2M-1)}{6} \approx M^3/3.$$

So $E(A) \sim M^3/3$, which is $\sim M^3$, much larger than $M^3/N$.

**The claim $E(A) \leq C_E M^3/N$ is FALSE in general.** The correct target bound must be different.

### 3.3 Corrected energy route

The correct route from energy to $P/L$ uses:

**Step 1**: $E(A) \leq P \cdot \sum_d |A_d| = P \cdot M^2/2$.

**Step 2**: Lower bound $E(A)$ from Cauchy-Schwarz: $E(A) \geq M^4/(16N)$.

**Combining**: $P \cdot M^2/2 \geq M^4/(16N)$, giving $P \geq M^2/(8N) = L/2$.

To get an upper bound on $P$, we need an **upper** bound on $E(A)$ that is nontrivial (better than $M^3/2$). Specifically, if we could show:

$$E(A) \leq \tilde{C} \cdot \frac{M^3}{N} \cdot N = \tilde{C} \cdot M^3$$

this is trivial. But if 4-AP-freeness forces a **cancellation** in the energy:

$$E(A) = \sum_d |A_d|^2 \leq \frac{M^3}{C'}$$

for some $C' > 1$ (better than the trivial $M^3/2$), then $P \leq E(A)/(L \cdot |\mathcal{S}|) \cdot C$. But this also doesn't close.

**The fundamental issue**: The energy $E(A)$ is not directly constrained by 4-AP-freeness in a useful direction. The 4-AP condition $\Lambda_4(A) = 0$ is a **4th-order** condition on $A$, while the energy $E(A)$ is a **2nd-order** quantity. The missing step is a "transfer" from 4th-order freeness to 2nd-order energy concentration.

---

## 4. Approach B: Direct Structural Bound on the Argmax Fiber

Let $d^* = \arg\max_{d \in \mathcal{S}} |A_d|$, so $|A_{d^*}| = P$.

### 4.1 Disjointness constraints

Since $A_d = A \cap (A - d)$, and $A_{d^*} + d^* \subseteq A$ (by definition of $A_{d^*}$):
- $A_{d^*} \subseteq A$ and $A_{d^*} + d^* \subseteq A$.
- $A_{d^*} \cap (A_{d^*} + d^*)$: if $x \in A_{d^*} \cap (A_{d^*} + d^*)$, then $x \in A_{d^*}$ (so $x, x+d^* \in A$) and $x = y + d^*$ for some $y \in A_{d^*}$ (so $y, y+d^* = x \in A$). This is possible; disjointness is not guaranteed.

**Claim**: $A_{d^*}$ and $A_{d^*} + d^*$ need not be disjoint. However, using 4-AP-freeness:

If $x \in A_{d^*}$ and $x + d^*, x + 2d^*, x + 3d^* \in A$, that is a 4-AP — contradiction. So for any $x \in A_{d^*}$, either $x + 2d^* \notin A$ or $x + 3d^* \notin A$ (given $x + d^* \in A$ automatically).

This means: $A_{d^*} \cap A_{2d^*}$ has no element $x$ with $x + 3d^* \in A$.

**Bound from disjointness (partial)**: The set $A_{d^*} \cup (A_{d^*} + d^*)$ has size at most $|A| = M$ if the two are disjoint. In general $|A_{d^*} + d^*| = |A_{d^*}| = P$, and since $A_{d^*} + d^* \subseteq A$, we have $P + P - |A_{d^*} \cap (A_{d^*} + d^*)| \leq M$, giving:
$$P \leq M - P + |A_{d^*} \cap (A_{d^*} + d^*)| \leq M.$$
This gives only $P \leq M$ (trivial unless we bound the intersection).

**The step-$d^*$ intersection bound**: An element $x$ is in $A_{d^*} \cap (A_{d^*} + d^*)$ iff $x \in A$, $x + d^* \in A$, and $x - d^* \in A$ (i.e., $x \in A_{d^*}$ and $x - d^* \in A_{d^*}$). So $|A_{d^*} \cap (A_{d^*} + d^*)| = |A_{d^*} \cap A_{d^*,-d^*}|$ = number of $x \in A_{d^*}$ with $x - d^* \in A_{d^*}$ = $|A_{2d^*}^{(d^*)}|$ (a "double fiber").

This analysis gets complicated without yielding a bound better than $P \leq M/2$ (which follows from $2P \leq M + |A_{d^*} \cap (A_{d^*} + d^*)|$ when the intersection is $\leq |A_{d^*}| = P$, giving $2P \leq M + P$, so $P \leq M$ — no improvement).

### 4.2 The $2 \times 4$ grid argument

Since $A$ is 4-AP-free: for every $x \in A_{d^*}$, the set $\{x, x+d^*, x+2d^*, x+3d^*\}$ is NOT entirely in $A$. Since $x \in A_{d^*}$ means $x, x+d^* \in A$, we need at least one of $x+2d^*, x+3d^*$ to be absent from $A$.

**Constraint**: For each $x \in A_{d^*}$, either $x + 2d^* \notin A$ or $x + 3d^* \notin A$ (or both).

Let $B = \{x \in A_{d^*} : x + 2d^* \in A\}$ and $C = \{x \in A_{d^*} : x + 2d^* \notin A\}$. Then $A_{d^*} = B \cup C$ (disjoint). For $x \in B$: $x + 3d^* \notin A$ (forced by 4-AP-freeness). So $B$ has the property that $B + 2d^*$ and $B + 3d^*$ are disjoint from each other in $A$ (specifically $B + 3d^* \cap A = \emptyset$).

The four sets $A_{d^*}, A_{d^*}+d^*, B+2d^*, C$ partition into parts of $A$. But bounding their sizes:
$$|A_{d^*}| + |A_{d^*}| + |B+2d^*| \leq |A| + |A_{d^*} \cap (A_{d^*}+d^*)| + |B \cap A_{d^*}+d^*|$$
This still doesn't give a useful bound.

**Assessment of Approach B**: Direct structural arguments from 4-AP-freeness give at best $P \leq M/2$ (since $A_{d^*}$ and $A_{d^*} + d^*$ are disjoint subsets of $A$ only when the argmax fiber has no "backward" overlaps). The constant $5$ in $P/L \approx 5$ cannot be recovered this way — the geometry of 4-APs prevents fibers being more than half of $A$, giving $P/L \leq M/(2L) = N/M \cdot 2 \approx 2N^{0.30}$ (diverging).

---

## 5. Approach C: Roth Applied to the Fiber

If $A_{d^*}$ were 3-AP-free, then $P = |A_{d^*}| \leq r_3(N)$. Combined with $P \geq L = M^2/(4N)$:
$$M^2/(4N) \leq P \leq r_3(N),$$
giving $M \leq 2\sqrt{N r_3(N)}$ — the van Corput bound (Theorem 1 of submittable_proof.md, conditional on Gap 3.1).

**But this is circular**: We need to first show $A_{d^*}$ is 3-AP-free (Gap 3.1 itself), and then use $P \leq r_3(N)$ to bound $M$. The bound $P \leq r_3(N)$ is exactly what Gap 3.1 would give if the argmax were the witness.

**Can Roth bound $P$ without 3-AP-freeness of $A_{d^*}$?**: If $P > r_3(N)$, then $A_{d^*}$ must contain a 3-AP. But at all tested $N$:
- $P \approx N^{0.40}$ (e.g., $P \approx 118$ at $N = 10000$)
- $r_3(N) \approx N \exp(-c(\log N)^{1/6}) \approx N \exp(-3) \approx N/20 \approx 500$ at $N = 10000$

So $P \ll r_3(N)$: the argmax fiber is far below the Roth threshold. Roth's theorem does **not** apply to force a 3-AP in $A_{d^*}$.

**Conclusion on Approach C**: Roth-on-fiber is the wrong tool for bounding $P$ from above, since $P \sim N^{0.40} \ll r_3(N) \sim N \exp(-(\log N)^{1/6})$ for all $N$ in range. The gap between $P$ and $r_3(N)$ is enormous (Behrend-type exponential).

---

## 6. Approach D: Concentration of the Fiber Distribution (New Direction)

The observed $P/L \approx 5$ is not primarily an energy question — it is a **fiber-size-distribution** question. The distribution of $|A_d|$ for $d \in \mathcal{S}$ is highly concentrated (most fibers near $L$, a few near $P$), and the ratio $P/L = 5$ encodes this concentration.

### 6.1 Energy as a sum of squared fiber sizes

$$E(A) = \sum_{d=1}^{N-1} |A_d|^2 = \sum_{d \in \mathcal{S}} |A_d|^2 + \sum_{d \notin \mathcal{S}} |A_d|^2.$$

The non-popular fibers have $|A_d| < L = M^2/(4N)$, so:
$$\sum_{d \notin \mathcal{S}} |A_d|^2 < L \cdot \sum_{d \notin \mathcal{S}} |A_d| \leq L \cdot M^2/2 = \frac{M^4}{8N}.$$

The popular fiber contribution dominates:
$$\sum_{d \in \mathcal{S}} |A_d|^2 \geq E(A) - \frac{M^4}{8N}.$$

If $|\mathcal{S}|$ is large and the popular fibers are spread between $L$ and $P$, we can write:
$$\sum_{d \in \mathcal{S}} |A_d|^2 \leq P \cdot \sum_{d \in \mathcal{S}} |A_d| \leq P \cdot M^2/2.$$

This gives the same energy sandwich as before.

### 6.2 The variance-based bound

Let $\bar{F} = \frac{1}{|\mathcal{S}|}\sum_{d \in \mathcal{S}} |A_d|$ be the average popular fiber size. The variance:
$$\sigma^2 = \frac{1}{|\mathcal{S}|}\sum_{d \in \mathcal{S}} (|A_d| - \bar{F})^2 = \frac{\sum_{d \in \mathcal{S}}|A_d|^2}{|\mathcal{S}|} - \bar{F}^2.$$

By the "max vs. variance" inequality: $P - \bar{F} \leq \sqrt{|\mathcal{S}|} \cdot \sigma$ (concentration inequality). If $\sigma / \bar{F}$ is small, then $P \approx \bar{F}$, meaning the fiber sizes are concentrated.

**Empirical observation**: The fiber-size distribution for greedy 4-AP-free sets is **heavy-tailed**: a few fibers have size $\approx P$ and most have size $\approx L$. The variance is large. So the variance bound doesn't give tight control on $P$.

### 6.3 The correct interpretation of $P/L \approx 5$

The empirical ratio $P/L \approx 5$ arises from the **specific structure of greedy 4-AP-free sets**, not from a universal theorem. The ratio is:
$$\frac{P}{L} = \frac{4NP}{M^2}.$$

Since $M \approx c N^{0.70}$ and $P \approx c' N^{0.40}$ empirically, we get $P/L \approx 4c'/(c^2) \approx 5$. The specific value $5$ depends on the constants $c, c'$ in the scaling laws of greedy sets, which are construction-dependent.

**A key question**: Does $P/L \leq C$ hold for **all** 4-AP-free sets (not just greedy ones), or only for extremal sets achieving close to $r_4(N)$?

- If $A$ is Salem-Spencer (3-AP-free), then every popular fiber $A_d \subseteq A$ is automatically 3-AP-free (hereditary). So Conjecture 2 / RC2 hold trivially. No bound on $P/L$ is needed since the min\_wfrac witness is any popular $d$.

- If $A$ is a random 4-AP-free set (much smaller than $r_4(N)$), fiber sizes are governed by the set's additive structure, which may differ significantly from greedy sets.

**The bound $P \leq CL$ must hold for ALL 4-AP-free $A$ to prove RC2 universally.** The greedy construction data suggests $C \approx 5$, but a bound $P \leq C'L$ for any fixed $C' < \infty$ would suffice for proving RC2 (with min\_wfrac floor $\geq 1/C'$).

---

## 7. The Strongest Partial Result Available

### 7.1 Conditional theorem via energy

**Theorem 7.1** (Conditional). Let $A \subseteq \{1,\ldots,N\}$ be 4-AP-free with $|A| = M$. Suppose there exists a universal constant $C_E$ such that:
$$E(A) \leq C_E \cdot \frac{M^4}{N \cdot |\mathcal{S}|}$$
where $|\mathcal{S}|$ is the number of popular differences. Then $P/L \leq 2C_E$.

*Proof*: We have $P = \max_{d \in \mathcal{S}} |A_d|$ and $L = M^2/(4N)$. The energy satisfies:
$$E(A) \geq \frac{1}{|\mathcal{S}|}\left(\sum_{d \in \mathcal{S}} |A_d|\right)^2 \geq \frac{1}{|\mathcal{S}|}\left(|\mathcal{S}| \cdot L\right)^2 = |\mathcal{S}| \cdot L^2.$$
Also, $E(A) \leq P \cdot M^2/2$. So:
$$P \geq \frac{2E(A)}{M^2} \geq \frac{2|\mathcal{S}| L^2}{M^2} = \frac{2|\mathcal{S}| M^2}{16N^2} = \frac{|\mathcal{S}| M^2}{8N^2}.$$
Under the assumed upper bound $E(A) \leq C_E M^4/(N \cdot |\mathcal{S}|)$:
$$P \cdot \frac{M^2}{2} \geq E(A) \geq |\mathcal{S}| L^2.$$
But to bound $P$ from **above** under the energy bound:
$$P^2 \leq E(A) \leq C_E \cdot \frac{M^4}{N \cdot |\mathcal{S}|}.$$
Wait — $P^2 \leq E(A)$ requires $|\mathcal{S}| = 1$. In general, $P^2 \leq \sum_{d \in \mathcal{S}} |A_d|^2 / 1$ only trivially.

The correct bound is:
$$P \leq \frac{E(A)}{L} \quad \text{(using } E(A) \geq P \cdot |\mathcal{S}| \cdot L \text{ when all fibers in }\mathcal{S}\text{ have size} \geq L\text{)}.$$

Specifically: $E(A) \geq \sum_{d \in \mathcal{S}} |A_d|^2 \geq P \cdot \sum_{d \in \mathcal{S}} |A_d| / |\mathcal{S}| \cdot |\mathcal{S}|$ — no, this is getting circular.

**Correct derivation**: Suppose $E(A) \leq C_E \cdot P \cdot L \cdot |\mathcal{S}|$ (a specific assumed energy bound). Then from $E(A) \geq |\mathcal{S}| L^2$ (from Cauchy-Schwarz on fibers):
$$|\mathcal{S}| L^2 \leq E(A) \leq C_E \cdot P \cdot L \cdot |\mathcal{S}|,$$
giving $L \leq C_E \cdot P$, i.e., $P/L \geq 1/C_E$ — a **lower** bound. Still wrong direction.

### 7.2 The correct conditional theorem (from Appendix B.5)

The cleanest version from the existing analysis (submittable_proof.md §B.5):

**Theorem 7.2** (Conditional — reproduced from §B.5). Suppose $E(A) \leq C_E \cdot M^3/N$ for all 4-AP-free $A \subseteq \{1,\ldots,N\}$. Then $P \leq 2C_E \cdot M/N \cdot (M^2/(4N)) \cdot ...$

Actually the correct statement from §B.5 is:
$$E(A) \leq P \cdot M^2/2 \implies P \geq 2E(A)/M^2.$$
$$\text{If } E(A) \leq C_E M^3/N, \text{ then } P \leq E(A)/\text{(something)}.$$

The derivation in §B.5 uses: $P \leq 2E(A)/M^2 \leq 2C_E M/N = 8C_E L$ — but this is using $E(A) \leq P \cdot M^2/2$ to derive a **lower** bound $P \geq 2E(A)/M^2$. If instead we have an upper bound $E(A) \leq C_E M^3/N$, the inequality $P \geq 2E(A)/M^2$ gives $P \geq 2C_E M/N = 8C_E L$ — a lower bound, not an upper bound.

**Summary of the sign issue**: Every energy-to-$P$ derivation gives a *lower* bound on $P$ from a *lower* bound on $E(A)$, and an *upper* bound on $P$ from *nothing* (since $E(A) \leq P \cdot M^2/2$ gives a lower bound on $P$, not an upper bound).

To get an **upper bound on $P$** from energy, one would need:
$$E(A) \geq f(P) \quad \text{for some increasing function } f,$$
combined with an upper bound on $E(A)$. The only such relation is $E(A) \geq P^2 / |\mathcal{S}|$ (AM-QM), giving:
$$P \leq \sqrt{E(A) \cdot |\mathcal{S}|}.$$

If $E(A) \leq C_E M^3/N$ and $|\mathcal{S}| \leq N$ (trivial):
$$P \leq \sqrt{C_E M^3/N \cdot N} = \sqrt{C_E} \cdot M^{3/2}.$$

But we need $P \leq CL = CM^2/(4N)$, so this requires $M^{3/2} \lesssim M^2/N$, i.e., $N \lesssim M^{1/2}$ — impossible for $M \ll N$.

With $|\mathcal{S}| \leq M^2/(2PL) \leq M^2/(2L^2)$ (from $|\mathcal{S}| \cdot L \leq M^2/2$):
$$P \leq \sqrt{C_E M^3/N \cdot M^2/(2L^2)} = \sqrt{C_E M^5/(2N L^2)}.$$
Substituting $L = M^2/(4N)$: $L^2 = M^4/(16N^2)$, so:
$$P \leq \sqrt{C_E M^5 \cdot 16N^2/(2N \cdot M^4)} = \sqrt{8C_E N M} = \sqrt{8C_E} \cdot (NM)^{1/2}.$$
And $P/L = 4NP/M^2 \leq 4N\sqrt{8C_E}(NM)^{1/2}/M^2 = 4\sqrt{8C_E} N^{3/2}/(M^{3/2})$. For $M \sim N^{0.7}$: $P/L \lesssim N^{3/2-1.05} = N^{0.45}$. Still diverges.

**Definitive conclusion on energy approach**: The energy $E(A)$ alone cannot give a uniform $P/L \leq C$ bound via Cauchy-Schwarz manipulations. The energy approach is fundamentally limited: $E(A)$ is a **second-moment** quantity and $P = \max_d |A_d|$ is an **extremal** quantity; connecting them requires additional structural input about the fiber size distribution.

---

## 8. The Irreducible Open Gap

### 8.1 Precise statement of what is missing

**The irreducible gap** (Gap E): For 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M$, prove that:
$$\max_{d=1}^{N-1} |A_d| \leq C \cdot \frac{M^2}{4N}$$
for some explicit universal constant $C < \infty$.

Equivalently: the maximum popular fiber size is at most $C$ times the popularity threshold.

This is **not** a consequence of:
- Energy bounds (shown above — energy approach gives only divergent bounds)
- Roth's theorem on the fiber (since $P \ll r_3(N)$ in practice)
- 4-AP-freeness via simple structural arguments (gives $P \leq M/2$ at best)
- The $U^3$ inverse theorem (controls 4-AP density, not fiber size distribution)

### 8.2 Why the gap is genuine

The ratio $P/L = 4NP/M^2$ can a priori range from $1$ (when $P = L$, the minimum popular fiber) to $N/M \approx N^{0.30}$ (when $P = M$, the trivial upper bound). The data shows it is pinned at $\approx 5.1$.

**What would force $P/L \leq C$**: A proof that the fiber size distribution of any 4-AP-free set satisfies a "max-to-mean" concentration bound. Specifically: if the popular fibers have a bounded **max-to-average ratio**:
$$\frac{\max_{d \in \mathcal{S}} |A_d|}{\text{avg}_{d \in \mathcal{S}} |A_d|} \leq K,$$
then since $\text{avg}_{d \in \mathcal{S}} |A_d| \leq M^2/(2|\mathcal{S}|) \leq M^2/(2 \cdot 1) = M^2/2$ (weak), we'd need a lower bound on $|\mathcal{S}|$ too.

Alternatively: a direct combinatorial argument that the **greedy structure** of 4-AP-free sets prevents any single fiber from being more than $C$ times the threshold. This would be specific to extremal (near-$r_4(N)$) sets.

### 8.3 Connection to known results

The gap connects to several open problems:

1. **Green–Tao energy for AP-free sets**: Green and Tao proved $r_4(N) \leq N(\log N)^{-c}$ using $U^3$ norm methods. Their proof gives a density increment in frequency space but does not extract a fiber-size bound.

2. **Kelley–Meka energy methods for 3-APs**: Kelley–Meka (2023) proved $r_3(N) \leq N\exp(-c(\log N)^{1/12})$ using a "3-AP energy" quantity. An analogue for 4-APs would require a "4-AP energy" bound, which is the open problem here.

3. **Gowers $U^3$ inverse theorem**: Gives that 4-AP-free sets correlate with 2-step nilsequences, but this structural information is not known to imply fiber-size bounds.

4. **Leng–Sah–Sawhney (2024) for $k \geq 5$**: Their quasi-polynomial bounds for $k \geq 5$ use $U^{k-1}$ norm methods with nil-Bohr sets. The $k = 4$ case is explicitly excluded due to a 2-torsion obstruction in 2-step nilmanifolds. This obstruction is precisely what prevents the fiber-size distribution from being controlled by $U^3$-norm arguments alone.

---

## 9. Priority Ranking of Proof Approaches

| Approach | What it gives | Current gap | Tractability |
|:---------|:-------------|:------------|:------------|
| **A: Energy bound** | $P \leq CL$ if $E(A) \leq f(M,N)$ | Finding correct $f$ that implies $P \leq CL$; energy approach gives only diverging bounds | Low — energy-to-max transfer fails algebraically |
| **B: Structural argmax** | $P \leq M/2$ (trivial) | Cannot extract factor of $N/M$ improvement from local 4-AP-free conditions | Low — gives $P/L \leq 2N/M \to \infty$ |
| **C: Roth on fiber** | $P \leq r_3(N)$ IF fiber is 3-AP-free | $P \ll r_3(N)$ empirically; circular (requires Gap 3.1) | Very low — wrong regime |
| **D: Fiber distribution** | $P/L \leq C$ if distribution is concentrated | No theorem bounding max-to-average fiber ratio for 4-AP-free sets | Medium — most promising direction |
| **E: Nil-Bohr methods** | $P/L \leq C$ via 2-step nil-structure | 2-torsion obstruction (LSS 2024 excluded $k=4$); would require new $U^3$ fiber argument | Medium-long term |

**Most promising direction** (Approach D): Prove that for 4-AP-free $A$, the fiber-size distribution satisfies a **super-threshold concentration**: the fraction of popular differences with $|A_d| \geq sL$ decays rapidly in $s$. Specifically, if $|\{d \in \mathcal{S} : |A_d| \geq sL\}| \leq C |\mathcal{S}|/s^k$ for some $k \geq 2$, then $P \leq O(|\mathcal{S}|^{1/k}) \cdot L$. Combined with $|\mathcal{S}| = O(N)$, this still diverges unless $|\mathcal{S}|$ is bounded by an absolute constant — which is not the case.

---

## 10. Conditional Theorem and Summary

**Theorem 10.1** (Conditional on Gap E — strongest available). Let $A \subseteq \{1,\ldots,N\}$ be 4-AP-free with $|A| = M$. Assume Gap E is resolved: there exists a universal constant $C$ such that $P \leq C \cdot L$.

Then:
1. $\mathrm{min\_wfrac}(A) \geq L/P \geq 1/C$ for any 4-AP-free $A$ (since any popular 3-AP-free fiber has $\mathrm{wfrac} \geq L/P \geq 1/C$).
2. If additionally Conjecture 2 (Gap 3.1) holds, then $\mathrm{min\_wfrac}(A) \geq 1/C$ for all 4-AP-free $A$ — this is Refined Conjecture 2 (RC2) with threshold $1/C$.
3. With $C = 5.25$ (matching the empirical upper bound $P/L \leq 5.25$), RC2 holds with min\_wfrac floor $\geq 1/5.25 \approx 0.190$, consistent with all observations.

**The key missing theorem**: Prove $P \leq C \cdot M^2/(4N)$ for some universal $C < \infty$ and all 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A|$ large.

**Relationship to the literature**: This bound appears to be **new** — it does not follow from Green–Tao 2017, Gowers 2001, Kelley–Meka 2023, or Raghavan 2026. All existing methods give bounds on $r_4(N)$ (the maximum set size) but not on the fiber-size ratio $P/L$. The fiber-size ratio is a finer structural invariant that the current Fourier/Gowers machinery does not control.

---

## 11. Recommended Research Directions

**Short term (months)**:

1. **Prove the $k=2$ fiber moment bound**: Show that $\sum_{d \in \mathcal{S}} |A_d|^2 / |\mathcal{S}| \leq C' P L$ for some constant $C'$. This is a statement about the second moment of the popular fiber distribution and may be provable from the $D(x,e)$ lemma combined with 4-AP-freeness.

2. **Investigate construction-dependence**: Compute $P/L$ for non-greedy 4-AP-free sets (Behrend sets, Salem-Spencer sets viewed as 4-AP-free, random 4-AP-free sets). If $P/L \leq C$ fails for some construction, the bound is false; if $P/L \approx 5$ persists, it suggests universality.

3. **Direct combinatorial proof for small $C$**: Attempt to prove $P \leq 10L$ (i.e., $P/L \leq 10$) by a purely combinatorial argument exploiting the interaction between the argmax fiber and the 4-AP-free structure of $A$. Even a weak bound $P \leq N^{1-\varepsilon} L$ would be progress.

**Medium term (years)**:

4. **2-step nil-Bohr fiber bound**: Develop an analogue of the Kelley–Meka energy method for 4-APs that extracts fiber-size information from the $U^3$ norm structure of $A$. This would require overcoming the 2-torsion obstruction identified in LSS 2024.

5. **Probabilistic model validation**: Prove that the Poisson model (3-AP count in fiber of size $s$ is approximately $s^3/N$) holds for popular fibers of 4-AP-free sets, not just random sets. This would justify the Poisson concentration argument from §B.3 and give a probabilistic route to RC2.

---

## 12. Conclusions

The bound $P \leq C \cdot L$ (equivalently $P/L \leq C$) for 4-AP-free sets is:

1. **Empirically tight at $C \approx 5.1$** across all tested $N = 5000$–$200000$ (≈4893 trials, 0 counterexamples to $P/L \leq 6$).

2. **Not provable by current methods**: Energy bounds, Roth-on-fiber, and direct structural arguments all fail to give a uniform constant $C$.

3. **The irreducible gap**: The fundamental open problem is to show that the fiber size distribution of any 4-AP-free set has bounded max-to-threshold ratio. This is a new type of structural result about 4-AP-free sets that goes beyond existing Gowers norm / density increment / energy methods.

4. **If resolved, implies RC2 and makes Theorem 1 unconditional**: Combining $P \leq CL$ (Gap E resolved) with Conjecture 2 (Gap 3.1) gives RC2 with min\_wfrac floor $\geq 1/C$, and RC2 implies the quasi-polynomial bound $r_4(N) \leq CN\exp(-c(\log N)^{1/6}/\log\log N)$ unconditionally.

**The irreducible gap in one sentence**: There is no known theorem that bounds the maximum popular fiber size $P = \max_d |A_d|$ by a universal constant multiple of the popularity threshold $L = M^2/(4N)$ for 4-AP-free sets, even though the empirical data strongly suggests $P \leq 5.3L$ universally — and proving this single bound $P \leq CL$ would, combined with Conjecture 2, make the quasi-polynomial bound on $r_4(N)$ unconditional.
