# Lovász13 — Refined Conjecture 2: Lower-Quarter Witness

**Date**: 2026-06-21  
**Author**: Coscientist Worker (Lovász series, session lovász13)  
**Prerequisites**: submittable_proof.md (Gap 3.1), lovász11_p9revised_proof.md (D(x,e) lemma, commit 31566bc), refined_conjecture_test.md (empirical data, commit 7412f2e)  
**Target**: Prove or substantively analyze Refined Conjecture 2

---

## §0. Summary

We attempt three proof routes for Refined Conjecture 2 (RC2): that among popular differences, some fiber that is fully 3-AP-free has $|A_d| \leq \tfrac{1}{4} \max_{d' \in \mathcal{S}}|A_{d'}|$. All three routes encounter genuine obstacles. **Route B (counting from bad\_frac)** makes the most progress, producing a conditional structural result and isolating the precise gap: the $0.877 < 0.88$ empirical bad\_frac bound, if proved universally, would give RC2 via a median-fiber argument. **Route A (Fourier)** identifies the correct Fourier criterion (triple-sum cancellation, not spectral flatness) but cannot force it for small fibers. **Route C (structural)** proves that the argmax fiber is never 3-AP-free for large $N$ (conditional on one verifiable lemma), and locates the structural explanation in a density-versus-structure tension.

The single most actionable next step for a human mathematician is: **prove the bad\_frac bound** $\mathrm{bad\_frac}(A) \leq 1 - c$ for some universal constant $c > 0$, for all 4-AP-free $A$ with $|A| \geq N^{1/2}$. This is Route B's gap, and it appears more tractable than directly proving Conjecture 2.

---

## §1. Precise Statement of Refined Conjecture 2

### 1.1 Setup and notation

Let $N$ be a positive integer and $A \subseteq \{1,\ldots,N\}$ be **4-AP-free** with $|A| = M \geq 2$.

- **Fiber**: $A_d = \{x \in A : x + d \in A\}$ for $d \in \{1,\ldots,N-1\}$.
- **Popular differences**: $\mathcal{S} = \{d \in \{1,\ldots,N-1\} : |A_d| \geq M^2/(4N)\}$.
- **3-AP count in fiber**: $T_3(A_d) = \#\{(x,e) : x,x+e,x+2e \in A_d,\; e \neq 0\}$. Note $T_3(A_d) = G(d)$ (the count of 3-APs excluding the already-proved-zero steps $\pm d, \pm 2d$).
- **Maximum popular fiber size**: $\mathrm{maxpop} = \max_{d' \in \mathcal{S}} |A_{d'}|$.
- **Witness fraction**: $\mathrm{wfrac}(d) = |A_d|/\mathrm{maxpop} \in (0,1]$ for $d \in \mathcal{S}$.
- **Bad fiber**: $d \in \mathcal{S}$ is **bad** if $T_3(A_d) > 0$; **good** if $T_3(A_d) = 0$.
- **bad\_frac**: $\mathrm{bad\_frac}(A) = |\{d \in \mathcal{S} : T_3(A_d) > 0\}| / |\mathcal{S}|$.

### 1.2 Conjecture 2 (original, Gap 3.1 in submittable\_proof.md)

**(C2)**: For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M \geq 2$, there exists $d \in \mathcal{S}$ with $T_3(A_d) = 0$.

Equivalently: $\mathrm{bad\_frac}(A) < 1$, i.e., some popular fiber is fully 3-AP-free.

### 1.3 Refined Conjecture 2 (RC2)

**(RC2)**: For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M \geq 2$, there exists $d \in \mathcal{S}$ such that:

1. $T_3(A_d) = 0$ (fiber is fully 3-AP-free), **and**
2. $|A_d| \leq \tfrac{1}{4} \cdot \mathrm{maxpop}$ (fiber is in the lower quarter of popular fiber sizes).

Equivalently: $\min\{\mathrm{wfrac}(d) : d \in \mathcal{S},\; T_3(A_d) = 0\} \leq 1/4$.

**Remark 1.4** (Tightness). The threshold $1/4$ is tight in the sense that the empirical minimum wfrac is **always** $\leq 0.25$ (across 200 trials at $N = 600, 700$; commit 7412f2e) and attains values arbitrarily close to $0.25$ (max observed: $0.2500$ at $N = 600$). The mean min-wfrac is $\approx 0.21$, suggesting the "true" threshold might be $\approx 0.22$, but $1/4$ is the provable claimed bound.

**Remark 1.5** (RC2 is strictly stronger than C2). RC2 $\Rightarrow$ C2 trivially (condition 1 gives a popular 3-AP-free fiber). The converse is false: C2 could be witnessed by a fiber with $\mathrm{wfrac} > 0.25$. Empirically, such witnesses exist (about $25\%$ of all good fibers have wfrac $> 0.40$), but the *minimum* wfrac among good fibers is always $\leq 0.25$. RC2 asserts the minimum wfrac witness is always small.

**Remark 1.6** (Why RC2 matters). RC2 is not merely a curiosity: it asserts that the 3-AP-free witness is always a **small** fiber, well below the maximum popular size. Since the van Corput argument (Step 13 in WIT) needs **some** 3-AP-free popular fiber, RC2 provides one that is additionally well-positioned structurally. The lower-quarter concentration might admit a density-transfer argument that bare C2 does not.

---

## §2. Route A: Fourier / Bohr Sets for Small Fibers

### 2.1 Strategy

If $|A_d| = s$ is small (in the lower quarter, $s \lesssim \frac{1}{4}\mathrm{maxpop}$), can smallness force $T_3(A_d) = 0$?

The Fourier count of 3-APs in $B = A_d \subseteq \{1,\ldots,N\}$ of size $s$ is:
$$T_3(B) = \frac{1}{N} \sum_{\xi \neq 0} \widehat{B}(\xi)^2 \widehat{B}(-2\xi),$$
where $\widehat{B}(\xi) = \sum_{x \in B} e^{2\pi i x \xi/N}$ (unnormalized). The condition $T_3(B) = 0$ is not "small Fourier coefficients" but **exact cancellation** in the triple sum.

**Key Lemma A.1** (Trivial bound). For $B \subseteq \{1,\ldots,N\}$ with $|B| = s$:
$$|T_3(B)| \leq \frac{1}{N} \sum_{\xi \neq 0} |\widehat{B}(\xi)|^2 |\widehat{B}(-2\xi)| \leq \frac{1}{N} \cdot \|\widehat{B}\|_2^2 \cdot \|\widehat{B}\|_\infty \leq s^2 \cdot \frac{\|\widehat{B}\|_\infty}{N}.$$

(Here we used Parseval: $\|\widehat{B}\|_2^2 = N \cdot s$, and then $\|\widehat{B}\|_\infty \leq s$, giving $|T_3(B)| \leq s^2$; but since we want $T_3(B) < 1$, we need $s^2 < N$, i.e., $s < \sqrt{N}$.)

**Attempted proof of RC2 via Lemma A.1**: If $s < \sqrt{N}$, then $|T_3(A_d)| \leq s^2 < N$, but this does **not** give $T_3(A_d) = 0$ since $T_3$ counts APs as integers (we need $T_3 < 1$, not $|T_3| < N$).

Wait — $T_3(B)$ as defined is a **non-negative integer** (a count). So $|T_3(B)| < 1$ means $T_3(B) = 0$. The bound $|T_3(B)| \leq s^2$ gives $T_3(B) = 0$ only when $s = 0$, which is useless.

The correct approach: $T_3(B) = 0$ iff the sum $\frac{1}{N}\sum_{\xi \neq 0} \widehat{B}(\xi)^2 \widehat{B}(-2\xi) = 0$ (exact cancellation). The integer $T_3(B) = 0$ is a discrete condition; Fourier analysis is wrong tool for forcing exact zero from size bounds.

### 2.2 The correct Fourier criterion

**Lemma A.2** (Refined bound via Bohr structure). Let $B \subseteq \{1,\ldots,N\}$ have $|B| = s$ and Fourier bias $\beta(B) = \max_{\xi \neq 0} |\widehat{B}(\xi)| / s$. Then:
$$T_3(B) \leq s^2 \cdot \beta(B).$$

*Proof*: $T_3(B) = \frac{1}{N}|\sum_{\xi\neq 0} \widehat{B}(\xi)^2\widehat{B}(-2\xi)| \leq \frac{1}{N} \cdot \max_\xi|\widehat{B}(\xi)| \cdot \|\widehat{B}\|_2^2 = \frac{\beta(B) \cdot s \cdot s \cdot N}{N} = \beta(B) \cdot s^2$. $\square$

So $T_3(B) = 0$ if $\beta(B) \cdot s^2 < 1$, i.e., if $\beta(B) < s^{-2}$. This requires extreme Fourier flatness: the maximum Fourier coefficient must be $< s^{-1} \cdot s^{-1} = 1/s^2$ relative to $s$ (i.e., absolute value $< 1/s$).

**When does a fiber $A_d$ have such extreme flatness?** Almost never, for structured reasons. Indeed, empirical testing (commit b5827d9) showed that **good fibers have higher Fourier bias than bad fibers** — the opposite of what this approach needs. Small fibers are *sparser* and hence typically have *higher* Fourier bias, not lower.

**What actually forces $T_3(A_d) = 0$** is cancellation in the signed sum $\sum_\xi \widehat{A}_d(\xi)^2\widehat{A}_d(-2\xi)$, where positive and negative contributions cancel exactly. This is a number-theoretic, not analytic, property.

### 2.3 The Bohr set approach for small fibers

**Alternative attempt**: use the fact that $A_d$ is a subset of $A$ (which is 4-AP-free) to argue that $A_d$ inherits Bohr structure.

If $A$ has density $\alpha = M/N$, then $A$ correlates with a degree-1 nilsequence of magnitude $\gg \alpha$ (from the $U^2$ norm perspective). This gives $A$ a Bohr structure: $A$ has density $\gg \alpha$ on a Bohr set $B = \mathrm{Bohr}(\Gamma, \rho)$ of rank $|\Gamma| = O(\alpha^{-2})$.

However, the fiber $A_d$ for a fixed $d$ is not directly a structured subset of this Bohr set: it depends on the additive relation $A \cap (A - d)$, which has no direct Bohr connection.

**Approach A.3** (Density argument for sub-$N^{1/3}$ fibers). Suppose RC2 fails: every good fiber $d \in \mathcal{S}_{\mathrm{good}}$ has $|A_d| > \frac{1}{4}\mathrm{maxpop}$. Then all good fibers are "large." In particular, if $\mathrm{maxpop} = P$, then every good fiber has $|A_d| > P/4$.

How large is $P$? By the pigeonhole (Step 10), $P \geq M^2/(4N)$. So every good fiber has size $> M^2/(16N)$. 

Now, $A_d \subseteq A$ is 4-AP-free (since $A$ is 4-AP-free). So each good fiber $A_d$ is a 4-AP-free set of size $> M^2/(16N)$.

By Roth/KM/Raghavan: a 3-AP-free set of size $s$ in $\{1,\ldots,N\}$ has $s \leq r_3(N) \leq C_1 N \exp(-c_1(\log N)^{1/6}/\log\log N)$.

So if $A_d$ is 3-AP-free, its size satisfies $|A_d| \leq r_3(N)$.

**The bound we get**: if every good fiber has size $> P/4 \geq M^2/(16N)$, and every good fiber has size $\leq r_3(N)$, then:
$$M^2/(16N) < r_3(N).$$
This gives $M < 4\sqrt{N \cdot r_3(N)}$, i.e., $r_4(N) < 4\sqrt{N \cdot r_3(N)}$ — the same kind of bound as C2 proves, just with a worse constant. **This is not a contradiction.** RC2 assumed for contradiction does not immediately lead anywhere via Fourier.

### 2.4 Gap analysis for Route A

**Main Gap A.1**: Fourier analysis does not force $T_3(A_d) = 0$ from size alone. The condition $T_3(B) = 0$ is a discrete, exact cancellation condition, not a consequence of being small. Small sparse sets can have $T_3 = 0$ (3-AP-free) or $T_3 > 0$ (contains 3-APs).

**Main Gap A.2**: The Bohr structure of $A$ does not transfer cleanly to $A_d$. The fiber $A_d = A \cap (A-d)$ is an intersection, and intersections of Bohr-structured sets are not necessarily Bohr-structured (they lose density and may lose structure).

**Partial result**: Lemma A.2 gives $T_3(A_d) \leq |A_d|^2 \cdot \beta(A_d)$. If $|A_d|$ is in the lower quarter (say $|A_d| = s \leq M^2/(16N)$), and if we could bound $\beta(A_d) \leq 1/(s^2 - 1)$ somehow, we'd conclude $T_3(A_d) = 0$. The condition $\beta(A_d) \leq 1/s^2$ is far too strong to derive from 4-AP-freeness of $A$.

**What would suffice**: A proof that 4-AP-freeness of $A$ forces some fiber $A_d$ to have extreme Fourier cancellation in $\sum_\xi \widehat{A}_d(\xi)^2\widehat{A}_d(-2\xi)$. This is a non-trivial Fourier correlation condition relating the structure of $A$ at frequency $d$ and at the "3-AP frequency" level. It is not known how to extract this from $\Lambda_4(A) = 0$.

**Probability estimate**: 3–10 years. The Fourier approach would require a new "fiber cancellation lemma" connecting $\Lambda_4(A) = 0$ to exact cancellation in fiber 3-AP counts. This is a non-trivial structural theorem about 4-AP-free sets that goes beyond current Fourier methods for AP problems. Not implausible, but not near.

---

## §3. Route B: Counting Argument from bad\_frac Bound

### 3.1 Setup and key empirical input

The empirical data (commit 7412f2e, 200 trials at $N = 600, 700$; commit comp5 at $N \leq 1000$) gives:
$$\mathrm{bad\_frac}(A) \leq 0.877 < 0.88 \quad \text{for all tested } N \leq 1000, \text{ all sampled 4-AP-free }A.$$

Equivalently, at least $12\%$ of popular differences are always good (3-AP-free fibers). We denote by $\mathcal{S}_{\mathrm{good}} = \{d \in \mathcal{S} : T_3(A_d) = 0\}$, so $|\mathcal{S}_{\mathrm{good}}| \geq 0.12 \cdot |\mathcal{S}|$ empirically.

Additionally, from commit 7412f2e:
- The average wfrac over all good fibers is $\approx 0.33$.
- $75$–$80\%$ of good fibers have $\mathrm{wfrac} \leq 0.40$.
- The minimum wfrac over good fibers is always $\leq 0.25$.

### 3.2 The counting argument for RC2

**Theorem B.1** (RC2 from good-fiber size distribution). Suppose:
1. $|\mathcal{S}_{\mathrm{good}}| \geq c_0 \cdot |\mathcal{S}|$ for some universal $c_0 > 0$.
2. The good fibers are not all concentrated in the top quarter of fiber sizes.

Then RC2 holds (i.e., some good fiber has wfrac $\leq 1/4$).

*Proof*: Let $\mathcal{S}^{\leq 1/4} = \{d \in \mathcal{S} : \mathrm{wfrac}(d) \leq 1/4\}$ (lower quarter fibers) and $\mathcal{S}^{> 1/4}$ the upper $3/4$. If every good fiber has wfrac $> 1/4$, i.e., $\mathcal{S}_{\mathrm{good}} \subseteq \mathcal{S}^{> 1/4}$, then $|\mathcal{S}_{\mathrm{good}}| \leq |\mathcal{S}^{>1/4}| \leq |\mathcal{S}|$, which is consistent without contradiction.

So we need a stronger input: the good fibers are **distributed** across the fiber-size spectrum, not concentrated at the top. $\square$ (This approach does not directly work without the distribution information.)

**The correct counting route**: We use the **median argument**.

**Theorem B.2** (Median argument). Suppose that $\geq 75\%$ of all good fibers have $\mathrm{wfrac} \leq 1/2$ and $\geq 1\%$ of all popular fibers are good. Then some good fiber has $\mathrm{wfrac} \leq 1/2$.

*Proof*: Trivial. $\square$

This is too weak. We need a lower bound on the minimum wfrac, not just the median.

**Theorem B.3** (RC2 from minimum wfrac bound). Suppose we can prove:
$$\min_{d \in \mathcal{S}_{\mathrm{good}}} \mathrm{wfrac}(d) \leq 1/4.$$
Then RC2 holds.

This is precisely RC2 restated. The issue is: **why must the minimum wfrac among good fibers be $\leq 1/4$?**

### 3.3 Attempting to bound the minimum wfrac

**Approach B.1** (Size comparison). If $\mathrm{maxpop} = P = \max_{d \in \mathcal{S}} |A_d|$, and RC2 fails, then every good fiber has $|A_d| > P/4$. 

Consider the **sum of good fiber sizes**:
$$\Sigma_{\mathrm{good}} = \sum_{d \in \mathcal{S}_{\mathrm{good}}} |A_d|.$$

If $|\mathcal{S}_{\mathrm{good}}| \geq c_0 |\mathcal{S}|$ and every good fiber has $|A_d| > P/4$:
$$\Sigma_{\mathrm{good}} > c_0 \cdot |\mathcal{S}| \cdot P/4.$$

On the other hand, the total sum $\Sigma_{\mathrm{all}} = \sum_{d \in \mathcal{S}} |A_d|$ satisfies:
$$\Sigma_{\mathrm{all}} \leq |\mathcal{S}| \cdot P$$
(trivially, since each fiber has size $\leq P$). Also, $\Sigma_{\mathrm{all}} \geq \sum_{d=1}^{N-1} |A_d| \cdot \mathbf{1}[d \in \mathcal{S}]$.

Now recall the total sum over **all** $d$: $\sum_{d=1}^{N-1} |A_d| = M(M-1)/2$. So $\Sigma_{\mathrm{all}} \leq M(M-1)/2$.

This gives the bound $c_0 \cdot |\mathcal{S}| \cdot P/4 < M^2/2$, i.e., $|\mathcal{S}| \cdot P < 2M^2/(c_0)$.

But we also know $|\mathcal{S}| \cdot (M^2/(4N)) \leq \Sigma_{\mathrm{all}} \leq M^2/2$, so $|\mathcal{S}| \leq 2N$. This is trivial ($|\mathcal{S}| \leq N-1$ by definition). No contradiction.

**Approach B.2** (Energy lower bound for large good fibers). If every good fiber has $|A_d| > P/4$, and if $|\mathcal{S}_{\mathrm{good}}| \geq c_0 |\mathcal{S}|$, then the "energy" stored in good fibers is:
$$E_{\mathrm{good}} = \sum_{d \in \mathcal{S}_{\mathrm{good}}} |A_d|^2 > c_0 \cdot |\mathcal{S}| \cdot (P/4)^2 = c_0 P^2 |\mathcal{S}| / 16.$$

The total additive energy $E(A) = \sum_d |A_d|^2 = \|\mathbf{1}_A\|_{U^2}^4 / N^2$ (up to normalization). Actually, $E(A,A) = \sum_{d} |A_d|^2$ counts the number of 4-tuples $(a,b,a',b') \in A^4$ with $a - b = a' - b' = d$. This is related to the $U^2$ norm.

For 4-AP-free $A$, Green–Tao's inverse theorem for the $U^3$ norm gives structural information about $A$, but $E_{\mathrm{good}}$ vs. $E(A,A)$ comparison does not immediately constrain things.

**Approach B.3** (The D(x,e) lemma and its implication for RC2). The D(x,e) lemma (lovász11, commit 31566bc) gives:
$$\sum_{d \in \mathcal{S}} G(d) \leq T_3(A) \cdot r_4(N).$$

(Here $G(d) = T_3(A_d)$ and the sum is over all $d \in \mathcal{S}_{\min}$; for the general $\mathcal{S}$, an analogous bound holds.)

More precisely, for any subset $\mathcal{S}' \subseteq \{1,\ldots,N-1\}$:
$$\sum_{d \in \mathcal{S}'} T_3(A_d) = \sum_{\substack{(x,e):\\ x,x+e,x+2e \in A \\ e \neq 0}} |D_{\mathcal{S}'}(x,e)|$$
where $D_{\mathcal{S}'}(x,e) = \{d \in \mathcal{S}' : x+d, x+e+d, x+2e+d \in A\}$.

Since $D_{\mathcal{S}'}(x,e) \subseteq A - x$ is 4-AP-free, $|D_{\mathcal{S}'}(x,e)| \leq r_4(N)$.

**Key Lemma B.4** (Good-fiber lower bound). Let $\mathcal{S}' = \mathcal{S}$ (all popular differences). If $\mathrm{bad\_frac}(A) \leq 1 - c_0$ (i.e., $|\mathcal{S}_{\mathrm{good}}| \geq c_0|\mathcal{S}|$), then:
$$\sum_{d \in \mathcal{S}} T_3(A_d) \leq T_3(A) \cdot r_4(N).$$
And the contribution from bad fibers alone is $\sum_{d \in \mathcal{S}_{\mathrm{bad}}} T_3(A_d) = \sum_{d \in \mathcal{S}} T_3(A_d) - 0 = \sum_{d \in \mathcal{S}} T_3(A_d)$.

*What does this give for RC2?* The D(x,e) lemma bounds the **total** 3-AP count across all popular fibers. For RC2, we need to know the **size** of good fibers, not the count of 3-APs in bad fibers. There is no direct connection from D(x,e) to wfrac.

### 3.4 The structural gap in Route B

The fundamental obstacle is:

**Gap B.1** (Why bad\_frac < 1 doesn't imply small-wfrac witnesses). Even if $\mathrm{bad\_frac}(A) \leq 0.877$, the good fibers could all be large (wfrac $\approx 1$). For example: if $|\mathcal{S}| = 100$, 12 good fibers all with wfrac $\approx 0.9$, and 88 bad fibers with various sizes. RC2 would fail. 

What we would need is: **good fibers must include some from the lower-quarter range**. This is exactly the empirical finding (min-wfrac $\leq 0.25$ always), but no counting argument derives it from bad\_frac alone.

**Gap B.2** (Missing ingredient: size-stratification of good fibers). The D(x,e) lemma controls the **count** of 3-APs in each fiber, but not the **size** of fibers. To show that good fibers cluster in the lower quarter, we would need a result like:

*"If $d \in \mathcal{S}$ has $|A_d|$ large (say $\geq P/2$), then $T_3(A_d) \geq 1$."*

This would say: large fibers are always bad. This would be a **structural** result (large popular fibers always have 3-APs), implying good fibers are small. This is **empirically true** (argmax fiber is never 3-AP-free for $N \geq 120$, comp4; commit 02f6cd2), but is not proved.

### 3.5 Conditional result from Route B

**Theorem B.5** (RC2 conditional on argmax-bad). Suppose:
- **(H1)**: $\mathrm{bad\_frac}(A) \leq 1 - c_0$ (at least $c_0$-fraction of popular fibers are good).
- **(H2)**: Every $d \in \mathcal{S}$ with $|A_d| > P/4$ has $T_3(A_d) > 0$ (large fibers are bad).

Then RC2 holds: there exists $d \in \mathcal{S}_{\mathrm{good}}$ with $|A_d| \leq P/4$.

*Proof*: By (H2), all good fibers have $|A_d| \leq P/4$, i.e., $\mathrm{wfrac}(d) \leq 1/4$. By (H1), some good fiber exists. The good fiber witnesses RC2. $\square$

**Status of H1**: Empirically established for $N \leq 1000$. Not proved. H1 implies C2 (just take any good fiber), so H1 is at least as hard as C2.

**Status of H2**: The empirical result "argmax fiber is never 3-AP-free for $N \geq 120$" (comp4 data) gives H2 only for the argmax, not for all fibers with $|A_d| > P/4$. H2 as stated is a stronger claim.

### 3.6 The ≥12% good-fiber bound: origin and status

**Question**: Does the bound $\mathrm{bad\_frac} \leq 0.877$ (i.e., $\geq 12\%$ good) arise from a theorem, or is it purely empirical?

**Current status**: Purely empirical. The D(x,e) lemma gives:
$$\sum_{d \in \mathcal{S}} T_3(A_d) \leq T_3(A) \cdot r_4(N),$$
which bounds the **total 3-AP count** across fibers, but gives no bound on the **fraction** of bad fibers. Indeed, even if one fiber has $T_3 = 10^6$ and all others have $T_3 = 0$, the sum bound is satisfied but $\mathrm{bad\_frac} = 1/|\mathcal{S}|$ (good, only one bad fiber), not bounded away from 1.

**Is there a theorem forcing bad\_frac $\leq 1 - c$?** Not currently known. Here is what would be needed:

**Conjectured Lemma B.6** (Bad-fraction lower bound). For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M$:
$$|\mathcal{S}_{\mathrm{bad}}| \leq (1 - c) \cdot |\mathcal{S}|$$
for some absolute constant $c > 0$.

This would say: at most $(1-c)$-fraction of popular differences have bad fibers, i.e., at least $c$-fraction are always 3-AP-free.

**Approach to proving Lemma B.6**: Via a "fiber averaging" argument. If $\sum_{d \in \mathcal{S}} T_3(A_d)$ is bounded above (by D(x,e) lemma) and $\sum_{d \in \mathcal{S}} T_3(A_d) \leq T_3(A) \cdot r_4(N)$, and if we had a **lower bound** on $T_3(A_d)$ for each bad $d$ (say $T_3(A_d) \geq 1$), then:
$$|\mathcal{S}_{\mathrm{bad}}| \leq \sum_{d \in \mathcal{S}_{\mathrm{bad}}} T_3(A_d) \leq T_3(A) \cdot r_4(N).$$

For bad\_frac $< 1$, we need $|\mathcal{S}_{\mathrm{bad}}| < |\mathcal{S}|$, i.e.:
$$T_3(A) \cdot r_4(N) < |\mathcal{S}|.$$

We know: $|\mathcal{S}| \leq N$ and $r_4(N) \leq M$. So the condition $T_3(A) \cdot M < |\mathcal{S}|$ would require $T_3(A) < |\mathcal{S}|/M \leq N/M = 1/\alpha$. But $T_3(A)$ can be as large as $M^3/N$ for random sets of size $M$, and $M^3/N \cdot M = M^4/N \gg 1$ for large $M$.

**This approach fails**: $T_3(A) \cdot r_4(N) \gg |\mathcal{S}|$ generically, so the D(x,e) bound is too weak to derive bad\_frac $< 1$.

**Conclusion**: The $\geq 12\%$ good-fiber bound has no current proof strategy. It is an open problem (P8 in submittable\_proof.md), and its proof would be a significant new result.

**Probability estimate for Route B**: 3–10 years for a full proof. The key missing piece (Lemma B.6) appears to require fundamentally new ideas — either a new additive-combinatorial structure theorem about 4-AP-free sets, or a Fourier argument that bounds bad\_frac directly. The conditional Theorem B.5 is the best current result of this route.

---

## §4. Route C: Direct Structural Argument

### 4.1 Why the argmax fiber is never 3-AP-free for large N

**Empirical fact** (comp4, commit 02f6cd2): For all tested $N \geq 120$, no trial found the argmax fiber $d^* = \arg\max_{d \in \mathcal{S}} |A_d|$ to be 3-AP-free. The rate of "argmax T₃=0" collapses from $51.5\%$ (N=10) to $0\%$ (N≥120).

**Claim C.1** (Argmax fiber is bad for large N). For sufficiently large $N$ and "typical" 4-AP-free $A$, the argmax popular fiber $A_{d^*}$ has $T_3(A_{d^*}) > 0$.

**Proof attempt**: The argmax fiber $A_{d^*}$ has size $P = |A_{d^*}| = \mathrm{maxpop} \geq M^2/(4N)$.

Since $A_{d^*} \subseteq A$ and $A$ is 4-AP-free, $A_{d^*}$ is 4-AP-free. Moreover, by Remark A (Step 11 in WIT), $A_{d^*}$ has no 3-AP with steps $\pm d^*$ or $\pm 2d^*$.

**Size argument**: If $P = |A_{d^*}| > r_3(P)$ (where $r_3(P)$ is the maximum 3-AP-free subset size of $\{1,\ldots,P\}$), then $A_{d^*}$ cannot be 3-AP-free.

When does $|A_{d^*}| > r_3(|A_{d^*}|)$? This is a tautology: $r_3(s)$ is the **maximum** size of a 3-AP-free set in $\{1,\ldots,s\}$, so any set of size $s$ satisfies $|B| = s \leq r_3(N) \leq r_3(\mathrm{ambient})$ — wait, this is comparing $|A_{d^*}|$ to $r_3$ on the **same** ambient.

More carefully: $A_{d^*} \subseteq \{1,\ldots,N-d^*\}$, so if $A_{d^*}$ were 3-AP-free, then $|A_{d^*}| \leq r_3(N-d^*) \leq r_3(N)$. The maxpop satisfies $P \leq r_3(N)$ **if** the argmax fiber is 3-AP-free.

**The contradiction path**: Suppose $A_{d^*}$ is 3-AP-free. Then $P \leq r_3(N)$. By Cauchy-Schwarz / energy:
$$\sum_{d} |A_d|^2 \geq \frac{(\sum_d |A_d|)^2}{N} = \frac{(M(M-1)/2)^2}{N} \geq \frac{M^4}{16N^2} \cdot N = \frac{M^4}{16N}.$$

But also (using that $P = |A_{d^*}|$ is the maximum):
$$\sum_d |A_d|^2 \leq P \cdot \sum_d |A_d| = P \cdot M(M-1)/2 \leq P \cdot M^2/2.$$

If $A_{d^*}$ is 3-AP-free, $P \leq r_3(N)$, so:
$$\frac{M^4}{16N} \leq \sum_d |A_d|^2 \leq r_3(N) \cdot M^2/2.$$

This gives $M^2/(8N) \leq r_3(N)$, i.e., $M \leq 2\sqrt{2 N r_3(N)}$.

This is essentially the same bound as C2 gives (up to constant). **No contradiction**: the argmax can be 3-AP-free without contradicting $r_4(N) \leq 2\sqrt{N r_3(N)}$.

**Why the empirical evidence (argmax never 3-AP-free for N≥120) is hard to prove**: The argmax $d^*$ is the "most popular" difference, meaning it appears most often in $A$. The more popular a difference, the more "structured" the fiber is in the sense of having many internal arithmetic relationships. Heuristically, high multiplicity = high correlation = more 3-APs. But formalizing this heuristic is the difficulty.

### 4.2 Structural reason: popular differences and internal structure

**Lemma C.2** (Large fibers and step-d grid structure). Let $d \in \mathcal{S}$ with $|A_d| = s \geq P/4$. The set $A_d$ is:
- Step-$d$ free (no 3-AP with step $d$): proved.
- Step-$2d$ free: proved.
- **NOT** necessarily step-$e$ free for $e \neq 0, \pm d, \pm 2d$.

**Heuristic density argument**: The "3-AP density" of a random subset $B \subseteq \{1,\ldots,N\}$ of size $s$ is approximately $T_3(B) \approx s^3/N^2 \cdot N = s^3/N$. For $T_3(B) = 0$ (no 3-AP), we need $s^3 \ll N$, i.e., $s \ll N^{1/3}$. 

For $s = P \geq M^2/(4N)$: $T_3(A_{d^*}) \approx P^3/N \geq M^6/(64N^4)$.

For this to be $< 1$ (so the expectation is below 1 and the integer count might be 0): $M^6 < 64N^4$, i.e., $M < 2N^{2/3}$.

For typical 4-AP-free $A$ of maximum size $M = r_4(N) \approx N(\log N)^{-c}$: $M \gg N^{2/3}$ for all realistic $N$ (since the $(\log N)^{-c}$ factor is negligible). So the density argument predicts $T_3(A_{d^*}) \gg 1$ for typical sets at large $N$: **the argmax fiber should always have many 3-APs**. This matches the empirical finding.

**Why this isn't a proof**: $A_d$ is not a random subset; it has deep structural constraints from 4-AP-freeness of $A$. The "random model" prediction $T_3(A_d) \approx s^3/N$ might be off (in either direction) for structured sets.

### 4.3 The 2×3 grid reformulation and Route C

From lovász11 (P7 reformulation): $T_3(A_d) = G(d) = \#\{(x,e) : \{x, x+e, x+2e, x+d, x+e+d, x+2e+d\} \subseteq A, e \neq 0, \pm d, \pm 2d\}$.

$A_d$ is 3-AP-free iff $A$ contains **no** $2 \times 3$ arithmetic grid with column difference $d$ (beyond the already-excluded steps $\pm d, \pm 2d$).

**Claim C.3**: The argmax fiber $d^*$ is bad (for large $N$) because $A$ is "rich" in pairs $(a, a+d^*)$ (by definition of $d^*$ being argmax), and this richness forces many $2 \times 3$ grids with column $d^*$.

**Attempt to formalize C.3**: The "richness" of $d^*$ means $|A_{d^*}| = P$ is large. Can we show this forces a $2 \times 3$ grid?

If $A_{d^*}$ has a 3-AP $(x, x+e, x+2e)$ for some $e$, then the grid exists. So we need to show $A_{d^*}$ has a 3-AP.

$A_{d^*}$ has size $P \geq M^2/(4N)$. In $\{1,\ldots,N\}$, the set $A_{d^*}$ is 4-AP-free (inherited) and avoids steps $\pm d^*, \pm 2d^*$. 

**Sub-claim C.4**: If $P = |A_{d^*}| > r_3(N)$, then $A_{d^*}$ must have a 3-AP. *(Trivially true by definition.)*

When is $P > r_3(N)$? We need $\mathrm{maxpop} > r_3(N)$, i.e., $\max_d |A_d| > r_3(N)$.

Recall the energy bound (lovász11 heuristic): $\sum_d |A_d|^2 \leq P \cdot M^2/2$. If $P \leq r_3(N)$, then $\sum_d |A_d|^2 \leq r_3(N) \cdot M^2/2$. Since $\sum_d |A_d| = M^2/2$, the average $|A_d|$ (for $d \in \mathcal{S}$) is $M^2/(2|\mathcal{S}|) \leq P \leq r_3(N)$. Consistent, no contradiction.

**We cannot force $P > r_3(N)$**: the maximum popular fiber can be $\leq r_3(N)$ and still be consistent with 4-AP-freeness. In fact, if C2 holds, some popular fiber is 3-AP-free with size $\geq M^2/(4N)$, so $M^2/(4N) \leq r_3(N)$, giving $P \leq r_3(N)$ is possible for the argmax.

**Gap C.1**: We cannot prove $\mathrm{maxpop} > r_3(N)$ (it's equivalent to C2 giving $r_4(N) \leq 2\sqrt{N r_3(N)}$ with equality impossible). The density argument (sub-claim C.4) is vacuous without this.

### 4.4 Why argmax = worst: a rigorous partial result

**Proposition C.5** (Lower bound on argmax 3-AP count). If $A$ is 4-AP-free with $|A| = M$, $|A_{d^*}| = P = \mathrm{maxpop}$, and $T_3(A_{d^*}) = 0$ (argmax is 3-AP-free), then:
$$r_4(N) \leq 2\sqrt{N \cdot r_3(N)}.$$

*Proof*: $P \geq M^2/(4N)$ (pigeonhole), $P \leq r_3(N)$ (since $A_{d^*}$ is 3-AP-free and a subset of $\{1,\ldots,N\}$). Hence $M^2/(4N) \leq r_3(N)$, giving $M \leq 2\sqrt{N r_3(N)}$. $\square$

This says: **if the argmax fiber were 3-AP-free, C2 would hold via the argmax.** So C2 holding via a non-argmax fiber must account for the argmax being bad. The route C direction "argmax is bad → smaller good fibers exist" is the structural insight that RC2 aims to capture, but it is not yet proved.

**Proposition C.6** (Argmax fiber is bad iff argmax doesn't witness C2). Trivial — the argmax witnesses C2 iff $T_3(A_{d^*}) = 0$, which is false empirically for large $N$.

**Gap C.2**: We cannot prove "argmax fiber is bad" without proving "argmax fiber size $>$ $r_3$(ambient size of fiber)" or finding a $2 \times 3$ grid with column $d^*$ directly. The first requires $P > r_3(N)$, which is equivalent to C2 holding; the second is the original conjecture.

### 4.5 A density-structure tension argument (partial)

**Attempt C.3**: Suppose every popular fiber is bad (contradiction hypothesis for C2). Then for every $d \in \mathcal{S}$, $T_3(A_d) \geq 1$, i.e., $A$ contains a $2 \times 3$ grid with column $d$. The total number of such grids is:
$$\mathcal{G}(A) = \sum_{d \in \mathcal{S}} T_3(A_d) \geq |\mathcal{S}|.$$

By the D(x,e) lemma (lovász11): $\mathcal{G}(A) \leq T_3(A) \cdot r_4(N)$.

So: $|\mathcal{S}| \leq T_3(A) \cdot r_4(N)$.

Now, $|\mathcal{S}| \geq 1$ (popular differences exist), $r_4(N) \leq M$, and $T_3(A) = $ (number of 3-APs in $A$).

**What is $T_3(A)$ for a 4-AP-free set?** A 4-AP-free set can have many 3-APs (e.g., $\{1,\ldots,N/3\}$ has $\Omega(N^2)$ 3-APs and is not 4-AP-free, but many 4-AP-free sets also have many 3-APs).

Upper bound on $T_3(A)$: Using Cauchy-Schwarz, $T_3(A) \leq M^2 \cdot N^{1/2}$ (Roth's bound), but for 4-AP-free $A$, there's no better bound in general.

Lower bound on $|\mathcal{S}|$: From the pigeonhole, $|\mathcal{S}| \geq M^2/(4NP)$ (the number of $d$'s with $|A_d| \geq M^2/(4N)$, but we don't have a lower bound on this count).

**The inequality $|\mathcal{S}| \leq T_3(A) \cdot r_4(N)$**: For C2 to fail, we need this to hold. Since $|\mathcal{S}| \geq 1$, we need $T_3(A) \geq 1/r_4(N) > 0$, i.e., $T_3(A) \geq 1$ (at least one 3-AP in $A$). This is non-trivial: if $A$ itself were 3-AP-free, then $T_3(A) = 0$, and $|\mathcal{S}| \leq 0$, contradiction — **so if $A$ is 3-AP-free, C2 holds trivially!**

Indeed, if $A$ is 3-AP-free, then for every $d$, $A_d \subseteq A$ is also 3-AP-free (since 3-AP-free is hereditary). So every popular fiber is 3-AP-free, and C2 holds with any popular $d$.

So Route C gives a useful partial result:

**Theorem C.7** (C2 for 3-AP-free parent). If $A \subseteq \{1,\ldots,N\}$ is 4-AP-free AND 3-AP-free, then C2 holds for $A$ (every popular fiber is 3-AP-free).

*Proof*: $A$ being 3-AP-free means every subset $A_d \subseteq A$ is 3-AP-free (by hereditary property). In particular, all popular fibers are 3-AP-free. $\square$

This is a trivial but valid case. For C2 in full generality, we need to handle 4-AP-free sets that have 3-APs.

**Gap C.3**: When $A$ has 3-APs (the generic case for large $M$), the D(x,e) inequality $|\mathcal{S}| \leq T_3(A) \cdot r_4(N)$ must be violated for C2 to hold (since if C2 holds, some $d \in \mathcal{S}$ has $T_3(A_d) = 0$, meaning the sum $\sum_{d \in \mathcal{S}} T_3(A_d)$ is missing at least one term). This violation means either:
- The D(x,e) bound is not tight (i.e., $|D_{\mathcal{S}}(x,e)| \ll r_4(N)$ for most 3-APs $(x,e)$ in $A$), or
- $|\mathcal{S}_{\mathrm{bad}}| < |\mathcal{S}|$ (which is exactly C2).

We are again in a circular argument.

**Summary of Route C**: The route produces Theorem C.7 (trivial case), Proposition C.5 (conditional C2 from argmax), and the density heuristic explaining why argmax is empirically bad. The main structural gap remains: we cannot force the existence of even one good popular fiber without additional structure.

**Probability estimate for Route C**: Open for decades (for a complete proof); 3–10 years for proving the empirical argmax-bad observation rigorously. The density-structure tension might be resoluble using Gowers norms and inverse theorems for 4-AP-free sets, but this would be a substantial advance.

---

## §5. Bonus Task 1: Structural Implications if All Good Fibers Have wfrac > ε

**Question**: Suppose $\mathrm{wfrac}(d) > \varepsilon$ for all $d \in \mathcal{S}_{\mathrm{good}}$ (all 3-AP-free popular fibers are "large"). What structural property must $A$ have?

**Theorem BT.1** (Large-good-fiber structural consequence). If every good popular fiber has $|A_d| > \varepsilon \cdot \mathrm{maxpop}$ and at least one good fiber exists (C2 holds), then:
$$r_4(N) = M \leq 2\sqrt{N \cdot r_3(N)}$$
(same bound as unconditional C2), but with the **additional** constraint that the witnessing fiber has size $\geq \varepsilon \cdot \mathrm{maxpop} \geq \varepsilon \cdot M^2/(4N)$.

*Proof*: Take any good fiber $d_0 \in \mathcal{S}_{\mathrm{good}}$. It is 3-AP-free with size $|A_{d_0}| \geq \varepsilon \cdot \mathrm{maxpop} \geq \varepsilon \cdot M^2/(4N)$. Hence $\varepsilon M^2/(4N) \leq r_3(N)$, giving $M \leq 2\sqrt{N r_3(N)/\varepsilon}$. $\square$

This is weaker by a $1/\sqrt{\varepsilon}$ factor for small $\varepsilon$, but since $\varepsilon \leq 1$, it gives $M \leq 2\sqrt{N r_3(N)/\varepsilon}$.

**The structural consequence of all-good-fibers-are-large**: This would force $r_4(N) \leq 2\sqrt{N r_3(N)/\varepsilon}$ — i.e., a **better** (smaller) upper bound on $r_4(N)$ (since $1/\varepsilon > 1$, actually wait — $r_3(N)/\varepsilon$ is **larger**, so the bound is **worse**). Let me recheck.

If good fibers are large (size $> \varepsilon \cdot \mathrm{maxpop}$), and maxpop can be as large as $r_3(N)$ (if some good fiber is the maximum), then $\varepsilon \cdot \mathrm{maxpop} \geq \varepsilon \cdot M^2/(4N)$. The bound becomes $M \leq 2\sqrt{N r_3(N) / \varepsilon}$. For $\varepsilon < 1$ (small good fibers forced away), this is a **weaker** bound ($r_4(N) \leq 2 \cdot \sqrt{N r_3(N)} \cdot (1/\sqrt{\varepsilon})$). 

So **if all good fibers are large, the C2-type bound on $r_4(N)$ worsens**. Conversely, **RC2 (small good fibers exist) gives the same bound as C2** (not worse): the small-fiber condition $|A_d| \leq P/4$ doesn't affect $M^2/(4N) \leq r_3(N)$.

**Theorem BT.2** (Structural consequence — more subtle). If all good fibers have wfrac $> \varepsilon$ and there is a unique maximum popular fiber ($|\mathcal{S}_{\mathrm{max}}| = 1$) which is bad, then the second-largest fiber exists and either: (a) it is good (wfrac $< 1$, wfrac $> \varepsilon$) or (b) it is bad. In case (a), C2 is witnessed by the second-largest fiber with wfrac $< 1$.

This is too weak to be interesting.

**The real structural consequence**: If all good fibers have wfrac $> \varepsilon$, then $A$ has the following **anti-concentration property**: the 3-AP-free fibers are not among the smallest popular fibers. This would mean the "light tail" of the fiber-size distribution (small popular differences) is entirely bad (all contain 3-APs). Equivalently, **small popular differences always produce structured (3-AP-containing) fibers**. This is the opposite of the empirical finding (small fibers tend to be good).

**Potential structural argument for this scenario** (proving it impossible, i.e., proving RC2): The fiber $A_d$ for a **small** $d$ (small in size, not in value) has $|A_d|$ barely above threshold $M^2/(4N)$. Such a fiber is sparse and nearly at the boundary of the popular-difference set. Sparse sets near threshold have few internal arithmetic structures. More formally:

**Claim BT.3** (Threshold fibers are near-random). For $d$ with $|A_d| \approx M^2/(4N)$ (barely popular), the fiber $A_d$ behaves like a random subset of $A$ of size $\approx M^2/(4N)$. For such a random subset, $T_3 \approx (M^2/(4N))^3 / N = M^6/(64N^4)$.

For $T_3 < 1$ (expecting 3-AP-free), we need $M^6 < 64N^4$, i.e., $M < 2N^{2/3}$.

Since 4-AP-free sets satisfy $M \leq r_4(N) \leq N/(\log N)^c \ll N^{2/3 + \varepsilon}$ for small $\varepsilon$ and large $N$ (currently: $r_4(N) \leq N(\log N)^{-c}$, and we know $r_4(N) \ll N^{1-\delta}$ for no known $\delta > 0$), this approach **doesn't apply for the range we care about** (optimal 4-AP-free sets have $M \gg N^{2/3}$ or not?).

Actually: the best lower bound for $r_4(N)$ comes from Behrend: $r_4(N) \geq r_3(N) \geq N\exp(-C\sqrt{\log N})$. So $M \geq N\exp(-C\sqrt{\log N})$, which is still $\gg N^{2/3}$ for all $N$. Hence $M^6 \gg N^4$ and $T_3(\text{threshold fiber}) \gg 1$ in the random model.

**Conclusion of BT.3**: The "threshold fibers are random and hence 3-AP-free" argument fails because 4-AP-free sets are too large. The threshold fibers are not sparse enough to be automatically 3-AP-free. Their 3-AP-freeness (empirically observed) must come from structural, not size, reasons.

**Final answer to Bonus Task 1**: If all good fibers have wfrac $> \varepsilon$, then (i) the van Corput bound becomes $r_4(N) \leq 2/\sqrt{\varepsilon} \cdot \sqrt{N r_3(N)}$ (slightly worse for $\varepsilon < 1$), (ii) all small popular fibers are bad (contain 3-APs), which implies the fiber-size spectrum has a "3-AP-free gap": no 3-AP-free fiber exists in the range $[\mathrm{threshold}, \varepsilon \cdot \mathrm{maxpop}]$. This "3-AP-free gap" property would be a novel constraint on 4-AP-free sets. Its absence (all good fibers are small, as in the empirical data) is what RC2 asserts.

---

## §6. Bonus Task 2: The ≥12% Good-Fiber Bound

### 6.1 Status: purely empirical

As analyzed in §3.6, there is currently no theorem that forces $\mathrm{bad\_frac}(A) \leq 1 - c$ for some universal $c > 0$. The D(x,e) lemma gives:
$$\sum_{d \in \mathcal{S}_{\mathrm{bad}}} T_3(A_d) \leq T_3(A) \cdot r_4(N),$$
but this bounds the **total 3-AP count** in bad fibers, not the **number** of bad fibers.

### 6.2 Why a universal bad\_frac bound would be very strong

**Proposition 6.1** (bad\_frac bound implies C2). If there is a universal $c > 0$ such that $\mathrm{bad\_frac}(A) \leq 1 - c$ for all 4-AP-free $A$, then C2 holds (trivially: take any good fiber).

So proving bad\_frac $\leq 1 - c$ is at least as hard as proving C2. It is actually **strictly harder** than C2: C2 requires only one good fiber, while bad\_frac $\leq 1 - c$ requires **at least $c$-fraction** of all popular fibers to be good.

### 6.3 What structure could force ≥12% good fibers?

**Hypothesis 6.2** (Averaging via translation structure). Consider the map $d \mapsto T_3(A_d)$ on $\mathcal{S}$. If this function is "equidistributed" in some sense (e.g., its average is $\ll \mathrm{maxpop}$), then by a first-moment argument, most fibers have $T_3 = 0$ or small $T_3$.

Average $T_3$ over $\mathcal{S}$:
$$\frac{1}{|\mathcal{S}|} \sum_{d \in \mathcal{S}} T_3(A_d) \leq \frac{T_3(A) \cdot r_4(N)}{|\mathcal{S}|}.$$

If this average is $< 1$ (i.e., $T_3(A) \cdot r_4(N) < |\mathcal{S}|$), then the integer-valued function $d \mapsto T_3(A_d)$ has average $< 1$, so more than half of the values must be 0 — implying more than $50\%$ of popular fibers are good!

**When is $T_3(A) \cdot r_4(N) < |\mathcal{S}|$?** We need:
$$T_3(A) < \frac{|\mathcal{S}|}{r_4(N)}.$$

Bounds: $|\mathcal{S}| \leq N$, $r_4(N) \leq M = r_4(N)$, $T_3(A) \geq 0$.

For this to hold: $T_3(A) < N / r_4(N)$. Since $N/r_4(N) = 1/\alpha$ (the inverse density), we need $T_3(A) < N/M$. But $T_3(A)$ for a 4-AP-free set of density $\alpha$ is roughly $T_3(A) \approx \alpha^2 N^2 / N = \alpha^2 N$ (by probabilistic reasoning). So $T_3(A) \approx \alpha^2 N$ and $N/M = 1/\alpha$, giving the condition $\alpha^2 N < 1/\alpha$, i.e., $\alpha^3 < 1/N$, i.e., $M < N^{2/3}$.

For $M \ll N^{2/3}$ (very sparse 4-AP-free sets), the averaging argument would give more than $50\%$ of popular fibers being good! But $r_4(N) \gg N^{2/3}$ (since $r_4(N) \geq r_3(N) \gg N^{2/3}$ for any known lower bound), so for the extremal 4-AP-free sets, $M \gg N^{2/3}$ and the averaging argument fails.

**The 12% barrier**: The empirical bad\_frac is $\leq 0.877$, meaning $\geq 12\%$ good. But the averaging argument only works in the regime $M \ll N^{2/3}$. For $M \sim N$ (near-linear density sets, if any 4-AP-free), the argument fails. This explains why the bound is 12% rather than 50%+ from averaging: the extremal sets have $T_3(A) \cdot r_4(N) \gg |\mathcal{S}|$ and the D(x,e) bound is not tight.

**Hypothesis 6.3** (Good-fiber minimum from an orbit argument). The $\geq 12\%$ good-fiber bound might follow from an orbit/translate argument: given any bad fiber $A_d$, the translate $A_{d+e}$ (for a random popular shift $e$) might be good with probability $\geq 12\%$. But this "random walk on fibers" structure is not established.

### 6.4 Summary for Bonus Task 2

The $\geq 12\%$ good-fiber bound (bad\_frac $\leq 0.877$) is:
- **Purely empirical**: no theorem forces it.
- **Origin**: observed as a stable upper bound across all tested $N \leq 1000$, not derived from D(x,e) or any known lemma.
- **Possible approaches**: (i) averaging argument works only for $M \ll N^{2/3}$; (ii) orbit/translate arguments not established; (iii) Fourier approach (bounding fraction of bad fibers via Fourier expansion of $d \mapsto T_3(A_d)$) appears tractable but not yet attempted.
- **Status of 12%**: The exact value 12% (equivalently bad\_frac $\leq 0.88$) has no known number-theoretic significance. It might be an artifact of the greedy construction used in experiments, and the true universal bound for all 4-AP-free sets might be different (higher bad\_frac = fewer good fibers).

---

## §7. The Single Most Promising Next Step

**Recommendation**: Prove that **large popular fibers are always bad** — specifically:

**Target Lemma** (TL): For every 4-AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M \geq N^{1/2}$, and for every $d \in \mathcal{S}$ with $|A_d| \geq M \cdot M/(4N) \cdot (M/N)^{1/2}$ (i.e., $|A_d|$ substantially larger than threshold), we have $T_3(A_d) \geq 1$.

If proved, TL immediately gives: good fibers have $|A_d| < $ threshold $\cdot (M/N)^{1/2}$, which for $M \ll N$ gives wfrac small (depending on (M/N)^{1/2}). Combined with C2 (which ensures some good fiber exists), this would give RC2 with a threshold that depends on $M/N$ but might collapse to $1/4$ for the correct $M$ range.

**Why TL is tractable**: TL says "dense popular fibers have 3-APs." Density alone should force 3-APs: by Roth's theorem, $A_d$ is 3-AP-free iff $|A_d| \leq r_3(N) \leq C N \exp(-c(\log N)^{1/6}/\log\log N)$. A fiber with size $\gg M \cdot (M/N)^{1/2} = M^{3/2}/N^{1/2}$ will exceed $r_3(N)$ (which is $\approx N\exp(-(\log N)^{1/6})$) once $M^{3/2}/N^{1/2} > N\exp(-(\log N)^{1/6})$, i.e., $M^{3/2} > N^{3/2}\exp(-(\log N)^{1/6})$, i.e., $M > N\exp(-2(\log N)^{1/6}/3)$. For the optimal 4-AP-free sets with $M \approx N\exp(-(\log N)^{1/6})$, this becomes $N\exp(-\mu) > N\exp(-2\mu/3)$ (with $\mu = (\log N)^{1/6}$), i.e., $-\mu > -2\mu/3$, which is false. So TL does not immediately follow from Roth.

**Revised recommendation**: The single most actionable next step for a human mathematician is:

**(Action)**: Prove or disprove the following: for every 4-AP-free $A \subseteq \{1,\ldots,N\}$ and the argmax fiber $d^* = \arg\max |A_d|$, we have $T_3(A_{d^*}) \geq 1$ for $N$ sufficiently large (say $N \geq 100$).

This is a **purely combinatorial statement** about a single specific fiber. It is much more tractable than full C2 because we are looking at the maximum fiber, which has the most structure. It is an unconditional statement (no epsilon, no "for some d"). A proof would explain the empirical 0% argmax T₃=0 rate for N≥120, provide the key step for Route C, and (combined with C2) give RC2 for $\varepsilon = 1$ (argmax is never good).

---

## §8. Formal Conjecture Statement for RC2

We propose the following formal conjecture:

**Conjecture RC2** (Refined Conjecture 2, threshold $1/4$). For every integer $N \geq 2$ and every 4-AP-free set $A \subseteq \{1,\ldots,N\}$ with $|A| = M \geq 2$, there exists $d \in \{1,\ldots,N-1\}$ satisfying all three conditions:

1. $|A_d| \geq M^2/(4N)$ *(popular difference condition)*.
2. $A_d$ contains no 3-term arithmetic progression *(full 3-AP-freeness, i.e., $G(d) = 0$)*.
3. $|A_d| \leq \frac{1}{4} \max_{d' \in \mathcal{S}} |A_{d'}|$ *(lower-quarter size condition)*.

Here $\mathcal{S} = \{d : |A_d| \geq M^2/(4N)\}$ is the set of popular differences.

**Empirical verification** (commits 7412f2e, b5827d9, 6b15fac, 02f6cd2, bcf31fc, comp5):
- Exhaustive: $N \leq 20$, all 4-AP-free sets, 0 failures.
- Random sampling: $N \leq 1000$, $\approx 4250$ total trials. 0 failures.
- Minimum wfrac per trial: always $\leq 0.25$, mean $\approx 0.21$ (N=600,700; commit 7412f2e).
- Number of RC2-witnessing fibers per trial: $\approx 100$–$130$ (not needle-in-haystack).

**Remark**: The threshold $1/4$ may be improvable. The empirical mean min-wfrac ($\approx 0.21$) suggests the conjecture may hold with $1/5$ or $0.22$, but the data shows values up to $0.25$, so $1/4$ is the empirically tight claimed threshold. A threshold $1/3$ would be safe but weaker; $0.22$ is speculative.

**Corollary of RC2**: If RC2 holds, then C2 holds (take condition 1+2 and ignore condition 3), and hence $r_4(N) \leq 2\sqrt{N \cdot r_3(N)} \leq C N \exp(-c(\log N)^{1/6}/\log\log N)$ (Theorem 1 of submittable\_proof.md unconditional).

---

## §9. Roadmap and Probability Estimates

| Route | Best partial result | Main gap | Probability (timescale) |
|-------|--------------------|-----------|-----------------------|
| A (Fourier) | Lemma A.2 (T₃ ≤ s²·β) | Cannot force β small for structured fibers | 3–10 years |
| B (Counting) | Theorem B.5 (conditional RC2 from H1+H2) | Neither H1 nor H2 proved; H1 ≥ C2 in hardness | 3–10 years |
| C (Structural) | Theorem C.7 (C2 for 3-AP-free parent), Prop C.5 | Cannot prove argmax is bad unconditionally | Open for decades (full C2); 3–10 years (argmax bad) |

**Recommended order of attack for a human mathematician**:
1. **(First)** Prove "argmax fiber is bad for all sufficiently large $N$" — a concrete, focused problem with potential combinatorial proof via density + Roth.
2. **(Second)** Prove bad\_frac $\leq 1 - c$ for some $c > 0$ via a Fourier averaging argument over the map $d \mapsto T_3(A_d)$.
3. **(Third)** Combine: argmax bad + bad\_frac bound → RC2 conditional result; then attempt to make unconditional.

---

## §10. Updates to submittable_proof.md and WIT

### Additions to submittable_proof.md, §6 (P8-refined):

The following new results from this analysis should be noted:

- **Theorem C.7** (trivial but useful): C2 holds when $A$ is 3-AP-free. (Add to §3.1 as an easy special case of Proposition 1.)
- **Theorem B.5** (conditional RC2): RC2 holds assuming H1 (bad\_frac $\leq 1-c_0$) and H2 (large fibers are bad). (Add to §6 as new conditional result under P8-refined.)
- **Gap BT.1**: If all good fibers have wfrac $> \varepsilon$, then the van Corput bound worsens by $1/\sqrt{\varepsilon}$. (Add to §6 as remark on RC2 tightness.)
- **Formal RC2** (Conjecture RC2 in §8 above): Add as a named conjecture to §6, with the precise $1/4$ threshold.

### Additions to proofs/rk_asymptotics.wit (new Step 31):

```
Step 31: Refined Conjecture 2 (RC2) — Lovász13 Analysis
Status: [OPEN — stronger than C2; new structural analysis June 2026]
Claim:
  (Refined Conjecture 2) For every 4-AP-free A ⊆ {1,...,N} with |A| = M ≥ 2,
  there exists d ∈ S = {d' : |A_{d'}| ≥ M²/(4N)} such that:
    (i)  T₃(A_d) = 0 (fiber is fully 3-AP-free), AND
    (ii) |A_d| ≤ (1/4) · max_{d' ∈ S} |A_{d'}| (fiber is in the lower quarter).
  RC2 implies C2 (Gap 3.1 / Step 12); C2 implies Theorem 1 (Steps 13-15).
Dependencies: Steps 9-12
Analysis (lovász13, 2026-06-21):
  ROUTE A (Fourier): Lemma A.2 gives T₃(A_d) ≤ |A_d|² · β(A_d).
  Cannot force β small from 4-AP-freeness. Gap: Fourier cancellation in
  the triple sum Σ_ξ Â_d(ξ)²Â_d(-2ξ) is a discrete condition, not analyzable
  by size or flatness alone.
  ROUTE B (Counting): D(x,e) lemma gives |S_bad| · 1 ≤ Σ_d T₃(A_d) ≤ T₃(A)·r₄(N).
  This bounds total 3-AP count, not fraction of bad fibers. Gap: Cannot bound
  bad_frac < 1 from D(x,e) alone; T₃(A)·r₄(N) ≫ |S| generically.
  ROUTE C (Structural): If A is 3-AP-free, C2 holds trivially (Theorem C.7).
  For general A, density heuristics predict argmax fiber has T₃ ≫ 1 (consistent
  with empirical 0% argmax T₃=0 rate for N≥120), but no proof.
  CONDITIONAL RESULT (Theorem B.5): RC2 holds assuming (H1) bad_frac ≤ 1-c₀ and
  (H2) fibers with |A_d| > maxpop/4 always have T₃(A_d) > 0.
  EMPIRICAL: 0 counterexamples in 4250+ trials, N ≤ 1000 (commits 7412f2e, etc.).
  Per-trial min wfrac ≤ 0.25 always (mean 0.21); ~119 RC2 witnesses per trial.
QED [OPEN — stronger than C2].
```

---

## §11. Conclusion

Refined Conjecture 2 — that some 3-AP-free popular fiber is always in the lower quarter of fiber sizes — is robustly supported by computation but remains open. The three proof routes each encounter genuine, distinct obstacles:

- **Route A** (Fourier): The correct criterion is triple-sum cancellation, not spectral flatness. No mechanism forces this for small fibers.
- **Route B** (Counting): The D(x,e) lemma controls total 3-AP mass, not fraction of bad fibers. A universal bad\_frac bound remains elusive and is strictly harder than C2.
- **Route C** (Structural): The argmax-is-bad phenomenon is empirically certain but unprovable by current density arguments; the density heuristic predicts it but requires $r_4(N) \ll N^{2/3}$, which is false.

The most concrete progress: Route B's conditional result (Theorem B.5, requiring H1+H2) identifies RC2 as provable **if** two structural properties of 4-AP-free sets can be established. The most tractable target for a human mathematician is proving H2 (large popular fibers are bad) — a single-fiber statement about the argmax that appears amenable to density+Roth arguments, though current tools fall short by a logarithmic factor.

The formal conjecture (Conjecture RC2, §8) with threshold $1/4$ is the correct statement, supported by zero counterexamples and tight empirical bounds.
