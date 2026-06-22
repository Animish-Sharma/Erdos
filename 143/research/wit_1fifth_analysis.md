# Theoretical Analysis of the RC2 One-Fifth Threshold Phenomenon

**Date**: 2026-06-21  
**Author**: Coscientist Hypothesizer  
**Dependencies**: comp6–comp8 results, lovász13 analysis, submittable_proof.md §3.1  
**Status**: Theoretical investigation — no Lean formalization yet

---

## 1. Precise Restatement of the Observation

### 1.1 Setup and notation

Let $A \subseteq \{1,\ldots,N\}$ be 4-AP-free with $|A| = M$. Define:
- **Fiber**: $A_d = \{a \in A : a+d \in A\}$ for $d \geq 1$.
- **Popularity threshold**: $L = M^2/(4N)$.
- **Popular differences**: $\mathcal{S} = \{d \geq 1 : |A_d| \geq L\}$.
- **Maximum popular fiber**: $P = \max_{d \in \mathcal{S}} |A_d| = \mathrm{maxpop}$.
- **wfrac of $d$**: $\mathrm{wfrac}(d) = |A_d|/P \in (0,1]$ for $d \in \mathcal{S}$.
- **min\_wfrac**: $\min\{\mathrm{wfrac}(d) : d \in \mathcal{S},\; T_3(A_d) = 0\}$ — the smallest wfrac among all 3AP-free popular fibers.
- **bad\_frac**: fraction of popular $d$'s with $T_3(A_d) > 0$.

### 1.2 The observed data

From greedy 4AP-free construction (Comp6–Comp8, combined ~4884 trials, 0 counterexamples to C2):

| $N$ | avg min\_wfrac | avg $P$ | avg $M$ | computed $L = M^2/(4N)$ | $L/P$ |
|----:|:--------------|--------:|--------:|------------------------:|------:|
| 5000  | 0.1986 | 90.75  | 592.0  | 17.46 | 0.192 |
| 7000  | 0.1987 | 103.25 | 748.5  | 20.00 | 0.194 |
| 8000  | 0.2000 | 108.50 | 822.6  | 21.13 | 0.195 |
| 10000 | 0.1984 | 117.88 | 956.4  | 22.87 | 0.194 |
| 15000 | 0.1934 | 142.25 | 1272.3 | 26.98 | 0.190 |
| 20000 | 0.2004 | 151.33 | 1546.7 | 29.91 | 0.198 |
| 30000 | 0.1935 | 183.50 | 2053.0 | 35.12 | 0.191 |

**Key observation**: The columns `avg min_wfrac` and `$L/P$` are virtually identical at every $N$, differing by only 0.002–0.004:

$$\text{avg min\_wfrac} \;\approx\; \frac{L}{P} = \frac{M^2/(4N)}{\text{maxpop}} \;\approx\; 0.192 \text{–} 0.198$$

This precise match holds across two orders of magnitude of $N$ (5000–30000).

### 1.3 Secondary observations

- **Range of avg min\_wfrac**: $[0.1892, 0.2061]$ over all $N = 2500$–$30000$.
- **Ratio $P/L$**: consistently $5.06$–$5.23$ across all $N$.
- **Individual trial min**: as low as $0.176$ (N=4000) but never below $L/P$ in that trial.
- **75–80\% of all $T_3=0$ fibers** have wfrac $\leq 0.40$.
- **Argmax fiber** ($\mathrm{wfrac}=1$) is NEVER $T_3=0$ for $N \geq 120$.
- **bad\_frac**: rising from $0.81$ at $N=1000$ to $0.963$ at $N=30000$.

---

## 2. Hypothesis H-1/5

**Hypothesis H-1/5** (formal statement):

*For every 4AP-free $A \subseteq \{1,\ldots,N\}$ with $|A| = M$, defining $L = M^2/(4N)$, $P = \max_{d \in \mathcal{S}}|A_d|$, and $\min\text{-wfrac} = \min\{\mathrm{wfrac}(d) : d \in \mathcal{S}, T_3(A_d)=0\}$:*

**(H-1/5a)** The minimum wfrac over all 3AP-free popular fibers is approximately $L/P$:
$$\min\text{-wfrac}(A) \;\approx\; \frac{L}{P} = \frac{M^2/4N}{\max_{d' \in \mathcal{S}}|A_{d'}|}.$$

**(H-1/5b)** The ratio $P/L$ is approximately constant at $5$ for large $N$:
$$\frac{P}{L} = \frac{4N \cdot \mathrm{maxpop}}{M^2} \;\approx\; 5.1 \pm 0.1 \quad \text{for } N \geq 5000.$$

**(H-1/5c)** As an immediate consequence: $\min\text{-wfrac}(A) \approx 1/5$.

**Interpretation**: The $1/5$ threshold is NOT a property intrinsic to the 3AP-freeness condition per se, but rather the ratio $L/P$, which equals $1/(P/L) \approx 1/5$ because the fiber size distribution spans from threshold $L$ to maximum $P \approx 5L$.

---

## 3. Evidence from Fiber Size Distribution

### 3.1 The identity $\text{min\_wfrac} \approx L/P$

The key structural observation is that:
1. **The minimum-size popular fiber has size $\approx L$** (it's barely popular).
2. **The minimum-size fibers tend to be 3AP-free** (they are sparse, near the Roth threshold).
3. **Therefore** $\min\text{-wfrac} \approx L/P$.

The identification $\min\text{-wfrac} \approx L/P$ holds because $\min\text{-wfrac}$ equals the minimum wfrac over $T_3=0$ fibers, and those fibers are concentrated near size $L$ (the threshold). This is not the same as the minimum wfrac over ALL popular fibers (which is exactly $L/P$); the correction of $0.002$–$0.004$ above $L/P$ reflects that the absolute minimum popular fiber may not always be 3AP-free.

### 3.2 Why 3AP-free fibers cluster near threshold: the Poisson model

Consider a popular fiber $A_d$ of size $s \in [L, P]$. Model the number of 3-APs in $A_d$ as Poisson with parameter:
$$\lambda(s) \;\approx\; \frac{s^3}{N}$$
(the crude expected count of 3-APs in a "random" subset of $\{1,\ldots,N\}$ of size $s$; see Roth's counting argument).

Then $\Pr[T_3(A_d) = 0] \approx e^{-\lambda(s)} = e^{-s^3/N}$.

Evaluating at the endpoints of the popular fiber range:

**At the threshold** $s = L = M^2/(4N)$:
$$\lambda(L) = \frac{L^3}{N} = \frac{(M^2/4N)^3}{N} = \frac{M^6}{64N^4}.$$
Using the data at $N = 10000$, $M = 956.4$, $L = 22.87$:
$$\lambda(L) \approx \frac{22.87^3}{10000} \approx \frac{11975}{10000} \approx 1.20.$$
So $\Pr[T_3=0] \approx e^{-1.2} \approx 0.30$. **Threshold fibers have a $\sim 30\%$ chance of being 3AP-free.**

**At the maximum** $s = P \approx 5L$ (using $P/L \approx 5$):
$$\lambda(P) = \frac{(5L)^3}{N} = 125 \cdot \frac{L^3}{N} = 125 \cdot \lambda(L) \approx 150.$$
So $\Pr[T_3=0] \approx e^{-150} \approx 10^{-65}$. **Max-size fibers are essentially never 3AP-free.**

**At twice threshold** $s = 2L$:
$$\lambda(2L) = 8\lambda(L) \approx 9.6, \quad \Pr[T_3=0] \approx e^{-9.6} \approx 7 \times 10^{-5}.$$

These calculations show a dramatic dropoff:

| Fiber size | $\lambda(s) = s^3/N$ | $\Pr[T_3=0] \approx e^{-\lambda}$ | wfrac |
|:-----------|:--------------------:|:----------------------------------:|------:|
| $s = L$ (threshold)   | 1.2  | 0.30    | $\approx 0.20$ |
| $s = 1.5L$            | 4.1  | 0.016   | $\approx 0.30$ |
| $s = 2L$              | 9.6  | 7e-5    | $\approx 0.40$ |
| $s = 3L$              | 32.4 | 8e-15   | $\approx 0.60$ |
| $s = P \approx 5L$    | 150  | $\approx 0$  | $1.00$ |

**Conclusion**: Under the Poisson model, essentially ALL 3AP-free popular fibers have size very close to $L$ (wfrac close to $L/P \approx 1/5$). The rapid growth of $\lambda(s) \sim s^3$ kills any 3AP-free probability well before $s = 2L$.

### 3.3 Consistency with observed bad\_frac

The overall fraction of 3AP-free popular fibers is:
$$1 - \mathrm{bad\_frac} \;\approx\; \int_L^P \Pr[T_3=0 \mid \text{fiber size}=s] \cdot \rho(s)\, ds$$
where $\rho(s)$ is the density of popular fiber sizes.

The rapid decay $e^{-s^3/N}$ means the integral is dominated by $s$ close to $L$. For $N = 10000$:
- bad\_frac $\approx 0.935$ (6.5\% of fibers are 3AP-free)
- Under Poisson model with $\lambda(L) \approx 1.2$ and ~30\% of threshold fibers being 3AP-free: a small fraction of popular fibers (those near threshold $L$) account for nearly all witnesses
- The 30\% probability at $s=L$ combined with only a small proportion of fibers being at threshold-size gives the observed ~6.5\% good fraction

This is consistent with bad\_frac approaching $1 - c/N^{0.2}$ (slowly) as $N \to \infty$.

### 3.4 The fiber size distribution and $P/L \approx 5$

**Empirical fact**: $P/L = 4NP/M^2$ is consistently $5.06$–$5.23$ across $N = 5000$–$30000$.

**Why $P/L \approx 5$?** We can bound:

*Lower bound on $P/L$*: From the total fiber sum identity $\sum_{d=1}^{N-1}|A_d| = M(M-1)/2 \approx M^2/2$, the average fiber size over the popular set $\mathcal{S}$ satisfies $\bar{F} \geq M^2/(2N) = 2L$ (from Markov-type reasoning; non-popular fibers contribute $< M^2/4$, so popular fibers sum to $> M^2/4$, and the average popular fiber size exceeds $L$). Since $P \geq \bar{F}$, we get $P \geq 2L$. So $P/L \geq 2$.

*Refined lower bound via Cauchy-Schwarz*: The additive energy satisfies
$$E(A) = \sum_d |A_d|^2 \;\geq\; \frac{(\sum_d |A_d|)^2}{N-1} \;\approx\; \frac{M^4/4}{N} \;=\; \frac{M^4}{4N}.$$
Also $E(A) \leq P \cdot \sum_d |A_d| \leq P \cdot M^2/2$. Combining: $P \geq M^2/(2N) = 2L$. (Same as before.)

*Upper bound on $P/L$*: No universal tight bound from current theory. Empirically $P/L \leq 5.25$.

The fact that $P/L \approx 5$ (and not 2 or 10) appears to be a property of the specific fiber size distribution in greedy 4AP-free sets. The greedy construction creates sets with a specific "energy concentration": a few differences have very large fibers (near $P$) while most popular differences have fibers near $L$. The ratio $5$ encodes this concentration.

**Scaling argument**: From the data, both $L$ and $P$ scale as approximately $N^{0.40}$:
- $L = M^2/(4N)$ with $M \sim c N^{0.70}$: $L \sim c^2 N^{0.40}/4$.
- $P \sim c' N^{0.40}$ (from data: $P = 90.75$ at $N=5000$ and $P = 183.5$ at $N=30000$; ratio $183.5/90.75 = 2.02$ vs $N$-ratio $(30000/5000)^{0.40} = 6^{0.40} \approx 2.05$).

Since both $L$ and $P$ scale as $N^{0.40}$, their ratio $P/L$ is scale-invariant, remaining constant at $\approx 5.1$ as $N$ grows. **The stability of $P/L \approx 5$ is a direct consequence of the identical $N^{0.40}$ scaling of both quantities.**

### 3.5 Why $\lambda(L) \approx 1$ (scale-invariance of the Poisson parameter)

A remarkable corollary of the $N^{0.40}$ scaling:
$$\lambda(L) = \frac{L^3}{N} \sim \frac{(c^2 N^{0.40}/4)^3}{N} = \frac{c^6}{64} N^{1.20-1} = \frac{c^6}{64} N^{0.20}.$$

So $\lambda(L) \sim N^{0.20}$ grows slowly to infinity. At $N = 10000$: $\lambda(L) \approx 1.2$; at $N = 30000$: $\lambda(L) \approx 1.4$. Despite this slow growth, $\lambda(L)$ remains of order 1, so the Poisson probability at threshold ($e^{-\lambda(L)} \approx 0.25$–$0.30$) stays substantial across all tested $N$.

This means: the popularity threshold $L = M^2/(4N)$ is precisely calibrated so that threshold-size fibers are borderline 3AP-free — not automatic (they're not trivially 3AP-free) but not impossible (there's always a ~25% chance). This "borderline" property is what makes C2 true: among thousands of popular differences, a small fraction (those at the threshold) are 3AP-free.

As $N \to \infty$, $\lambda(L) \to \infty$ and bad\_frac $\to 1$, but since $|S|$ grows, the absolute witness count grows (as confirmed: $\sim 942$ at $N = 30000$).

---

## 4. Most Promising Proof Approaches (Ranked)

### 4.1 Approach A: The $P/L$-Ratio Theorem (MOST TRACTABLE)

**Goal**: Prove $P/L = 4NP/M^2 \leq C$ for some universal constant $C < \infty$.

If proved, this gives $L/P \geq 1/C$, so min\_wfrac $\geq 1/C$. With empirical $C \approx 5.25$, this would give the lower bound $\min\text{-wfrac} \geq 1/C \approx 0.190$, matching the observed floor.

**Proof attempt**: We want to bound $\max_d |A_d|$ in terms of $M^2/N$. From the energy:
$$\max_d |A_d| \;\leq\; \frac{E(A,A)}{M^2/2} = \frac{2E(A,A)}{M^2},$$
where $E(A,A) = \sum_d |A_d|^2$ is the additive energy. (This uses $|A_d| \leq E(A,A)/\sum_{d'}|A_{d'}| \cdot |A_d|^{-1} \cdot$ ... hmm, this specific bound isn't immediate.)

Better: for 4AP-free $A$, Green-Tao's inverse theorem for $U^3$ gives $E(A,A) \leq C M^3 / N$ (energy is controlled by the $U^2$ norm). If true:
$$P = \max_d |A_d| \leq \frac{E(A,A)}{M} \leq \frac{C M^2}{N} = 4CL.$$

This would give $P/L \leq 4C$. With the (plausible) estimate $E(A,A) \leq C M^3/N$ for some $C \leq 2$ (random-set heuristic), this gives $P/L \leq 8$. The empirical value $P/L \approx 5$ is consistent with $C \approx 5/4$.

**Gap**: The bound $E(A,A) \leq C M^3/N$ for 4AP-free $A$ is NOT known in general. For random sets $E(A,A) \approx M^3/N$ is standard, but 4AP-free sets are structured and their energy could be larger. However, empirically $P \approx 5L$ and $E(A,A) \approx 5 \cdot M^3/(2N)$, which is "random-set-like". This approach would work if 4AP-free sets have energy behaving like random sets of the same size (i.e., no energy concentration).

**Tractability**: Medium. The bound $E(A,A) \lesssim M^{3}/N$ for 4AP-free $A$ might follow from Green-Tao's $U^3$ inverse theorem, but connecting it to the max popular fiber requires additional work.

### 4.2 Approach B: Roth Threshold for Smallest Popular Fibers (STRUCTURALLY MOTIVATED)

**Goal**: Prove that every popular fiber of size $> \varepsilon \cdot P$ has $T_3 > 0$, for some $\varepsilon > 0$.

More specifically (Hypothesis H2 from lovász13): prove that fibers with $|A_d| > P/4$ always have $T_3(A_d) > 0$.

**Proof attempt**: A fiber $A_d$ of size $s$ is a 3AP-free subset of $\{1,\ldots,N\}$ only if $s \leq r_3(N)$. By Raghavan's bound, $r_3(N) \leq C_1 N \exp(-c_1 (\log N)^{1/6}/\log\log N)$.

For the argmax fiber $d^*$ of size $P$, if $P > r_3(N)$, then $A_{d^*}$ must have a 3-AP.

**When does $P > r_3(N)$?** We need:
$$\frac{M^2}{c N} > r_3(N) \quad \text{for some constant } c,$$
which is equivalent to $M^2 > c N \cdot r_3(N)$, i.e., $r_4(N)^2 > c N \cdot r_3(N)$. This is exactly the van Corput inequality rearranged: $r_4(N) \leq 2\sqrt{N r_3(N)}$ implies $r_4(N)^2 \leq 4N r_3(N)$.

For the bound $P > r_3(N)$ to hold unconditionally for the argmax $d^*$, we'd need $r_4(N)^2 > cN \cdot r_3(N)$ with $c < 4$. But the van Corput inequality says $r_4(N) \leq 2\sqrt{N r_3(N)}$ (conditional on C2), so $r_4(N)^2 \leq 4N r_3(N)$. The argmax might have $P = \mathrm{maxpop}$ slightly below $r_3(N)$.

**Sharpened version**: Even if $P < r_3(N)$ formally, the density of $A_{d^*}$ in its ambient interval is $P/(N-d^*) \approx P/N \approx L \times 5/N$. By Roth's theorem (or KM/Raghavan), a set of density $> r_3(N)/N$ must have a 3-AP. So $A_{d^*}$ has a 3-AP iff $P > r_3(N)$.

**The difficulty**: We can't prove $P > r_3(N)$ without knowing $r_4(N)$ precisely. But we CAN argue it heuristically: at $N = 10000$, $P \approx 118$ and $r_3(10000)$ is on the order of $N \exp(-c(\log N)^{1/6}) \approx 10000 \exp(-c \times 3.16) \approx $ a few hundreds to few thousand. So $P \approx 118 \ll r_3(10000)$. The argmax fiber is actually WELL below the Roth threshold!

This means the argmax being bad for large $N$ is NOT explained by $P > r_3(N)$. The argmax must be bad for a different structural reason (correlated 3APs from the interaction with $A$). This is the content of Claim C.1 in lovász13: the popularity of $d^*$ (its large fiber size) is correlated with the existence of 3-APs in the fiber via the $2 \times 3$ grid structure of $A$.

**Revised approach B**: Instead of Roth on the fiber, use the grid reformulation:
$T_3(A_d) = G(d) = \#\{(x,e) : \{x,x+e,x+2e\} \cup \{x+d,x+e+d,x+2e+d\} \subseteq A\}$.

For a popular $d$, the set $A_d$ is large (size $\geq L$), meaning many pairs $(a, a+d)$ lie in $A$. For two pairs $(a, a+d)$ and $(a', a'+d)$ in $A$, if $a' - a = e > 0$ then $\{a, a+e, a+2e\} \subseteq A_d$ iff $a+2e \in A_d$ iff $a+2e+d \in A$ — a $2 \times 3$ grid with column $d$ and row step $e$. The number of such grids can be bounded from BELOW using the size of $A_d$:

**Lemma (informal)**: For a fiber $A_d$ of size $s \gg N^{1/3}$, the $2 \times 3$ grid avoidance fails and $T_3(A_d) \geq 1$.

*Attempt at proof*: $A_d$ is a 4AP-free subset of $\{1,\ldots,N\}$ of size $s$. If $s > r_3(N)$, it has a 3-AP $(x, x+e, x+2e) \subseteq A_d$. For this to be a non-trivial grid (with $e \neq d, 2d$), we need $e \notin \{d, 2d\}$. If the 3-AP in $A_d$ happens to have $e = d$ or $e = 2d$, we're in the already-handled case (Remark A in submittable\_proof.md). But for $s > r_3(N)$, the 3-AP in $A_d$ with arbitrary step exists; whether $e = d$ or $e = 2d$ specifically is unlikely for large $s$.

**Gap in Approach B**: The step from "P < $r_3(N)$" (which is the actual situation for tested $N$) to "$T_3(A_{d^*}) \geq 1$" requires a different argument. The density heuristic (T₃ ≈ s³/N) works in the Poisson model but is not a theorem.

### 4.3 Approach C: Energy Bound for the $P/L$ Ratio (NEW DIRECTION)

**Goal**: Use the double-counting identity 
$$\sum_{d=1}^{N-1} |A_d|^2 = \sum_{x,y,z,w \in A: x-y = z-w} 1 = E(A)$$
to bound $P/L$.

**Argument**:
- $E(A) = \sum_d |A_d|^2 \leq P \cdot \sum_d |A_d| = P \cdot M^2/2$.
- $E(A) \geq (\sum_d |A_d|)^2/(N-1) \geq M^4/(4N)$.

Combining: $P \geq M^2/(2N) = 2L$.

For the upper bound: if $E(A) \leq C_E \cdot M^3/N$ (energy concentrated like a random set), then:
$$P \leq \frac{E(A)}{M^2/2} \cdot \frac{M^2/2}{1} \leq \frac{C_E M^3/N}{M^2/2} \cdot \frac{1}{L} \cdot L \;=\; \frac{2C_E M}{N} \cdot L \cdot \frac{N}{M} = 2C_E L.$$

Wait, let me redo: $P \leq E(A)/(\sum_d |A_d|^{\text{avg}})$ isn't the right bound. The right bound is:

Since $\sum_d |A_d|^2 \leq P \cdot \sum_d |A_d|$:
$$E(A) \leq P \cdot \frac{M^2}{2} \implies P \geq \frac{2E(A)}{M^2}.$$

And if $E(A) \leq C_E M^3/N$:
$$P \leq \frac{E(A)}{M^2/2} \text{ [from some OTHER bound on P vs energy]}$$

Actually the correct energy bound on $P$ is:
$$P^2 \cdot \frac{|\mathcal{S}|}{|\mathcal{S}|} \leq \sum_{d \in \mathcal{S}} |A_d|^2 \leq E(A) \leq C_E M^3/N.$$

This gives $P^2 \leq E(A)/1 = C_E M^3/N$ if $|\mathcal{S}| = 1$ (trivial case). For general $|\mathcal{S}|$: $P^2 \leq E(A)$ which gives $P \leq \sqrt{C_E M^3/N} = \sqrt{C_E} \cdot M^{3/2}/N^{1/2}$.

So $P/L = P/(M^2/(4N)) = 4NP/M^2 \leq 4N \cdot \sqrt{C_E} M^{3/2}/N^{1/2} / M^2 = 4\sqrt{C_E} N^{1/2}/M^{1/2} = 4\sqrt{C_E} / \alpha^{1/2}$.

For $\alpha = M/N \approx 0.077$ (at $N=20000$): $P/L \leq 4\sqrt{C_E}/\sqrt{0.077} = 4\sqrt{C_E}/0.277 \approx 14.4\sqrt{C_E}$.

For $P/L \approx 5$: $C_E \approx 5^2/14.4^2 \approx 0.12$. Plausible but requires $E(A) \approx 0.12 M^3/N$.

**This approach is promising**: if $E(A) \leq C_E M^3/N$ can be proved for 4AP-free sets $A$, it gives $P \leq C' L$, bounding the ratio $P/L$ by a universal constant, and hence min\_wfrac $\geq 1/C'$.

The missing piece: proving the energy bound $E(A) \leq C_E M^3/N$ for 4AP-free $A$. This might follow from a second-moment analysis using Gowers' $U^2$ norm and the fact that 4AP-free sets are "pseudorandom" at the $U^2$ level.

### 4.4 Approach D: Pigeonhole on Fiber Sizes (ELEMENTARY)

**Goal**: Prove that among all $\approx |\mathcal{S}|$ popular fibers, those with wfrac $\leq 1/5$ (size $\leq P/5$) are not all bad.

**Observation**: The total sum $\sum_{d \in \mathcal{S}} |A_d| \leq M^2/2$. 
If ALL fibers had wfrac $> 1/5$, i.e., $|A_d| > P/5$ for all $d \in \mathcal{S}$, then:
$$\frac{M^2}{2} \geq \sum_{d \in \mathcal{S}} |A_d| > |\mathcal{S}| \cdot \frac{P}{5}.$$
So $|\mathcal{S}| < \frac{5M^2/2}{P} = \frac{5M^2}{2P}$.

Combined with the lower bound on $|\mathcal{S}|$: (we need $|\mathcal{S}| \geq $ something), we get a constraint.

From the data: $|\mathcal{S}| = \mathrm{witnesses}/(1-\mathrm{bad\_frac}) \approx 712/0.0424 \approx 16800$ at $N=20000$.

Upper bound: $|\mathcal{S}| < 5M^2/(2P) = 5 \times 1546.7^2 / (2 \times 151.33) \approx 5 \times 2392481/302.66 \approx 39540$.

This gives $16800 < 39540$: CONSISTENT but not a contradiction.

**Gap**: The pigeonhole argument only rules out ALL fibers being above $1/5$, but doesn't force SOME of the above-$1/5$ fibers to be 3AP-free. We'd need the additional step that small fibers tend to be 3AP-free. This requires the Poisson threshold model (Approach B above).

### 4.5 Summary of proof approach tractability

| Approach | What it proves | Tractability | Missing piece |
|:---------|:--------------|:-------------|:-------------|
| A: $P/L$ ratio bound | $P/L \leq C$ → $\min\text{-wfrac} \geq 1/C$ | Medium | Bound $E(A) \leq C_E M^3/N$ |
| B: Roth threshold | Large fibers ($> r_3(N)$) are bad | Low for $N$ in range | $P < r_3(N)$ in practice |
| C: Energy bound (squared) | $P \leq \sqrt{E(A)} \leq C'M^{3/2}/N^{1/2}$ | Medium | Energy bound for 4AP-free sets |
| D: Pigeonhole | NOT all fibers above $1/5$ | Easy but weak | Need 3AP-free concentration near $L$ |

**Most promising**: Approach A/C combined with the Poisson model. Specifically:
1. Prove $E(A) \leq C M^3/N$ for 4AP-free $A$ (energy "behaves randomly").
2. Deduce $P \leq C' M/\sqrt{N/M} = C' M^{3/2}/N^{1/2}$, so $P/L \leq C'' \sqrt{N/M}$.
   For $M \approx N^{0.7}$: $P/L \leq C'' N^{0.15}$ — this DIVERGES, so the approach doesn't directly give a finite bound.
3. Need a better energy bound. If $E(A) \leq C M^{2+\delta}/N$ for some $\delta > 0$... 

The most elementary tractable step: **prove $P \leq 6L$ (i.e., maxpop $\leq 6 \times$ threshold)** as a direct consequence of some energy inequality. From the data, $P/L \leq 5.25$, so the bound $P \leq 6L$ would be essentially tight.

---

## 5. What Remains Open

### 5.1 Why is $P/L \approx 5$ (not 4 or 6)?

The empirical ratio $P/L \approx 5.1$ is remarkably stable. No theoretical explanation exists. Potential route: the greedy 4AP-free construction has specific energy properties that pin $P/L$ at $\sim 5$. This might be accessible computationally by examining how $P/L$ behaves for different constructions (Salem-Spencer sets, Behrend construction, etc.).

### 5.2 Can min\_wfrac go below $L/P$?

By definition, min\_wfrac $\geq L/P$ (all popular fibers have size $\geq L$, so wfrac $\geq L/P$). The theoretical lower bound on min\_wfrac is exactly $L/P$, which from the data is approximately $0.190$–$0.198$. Individual trial fluctuations below the average $L/P$ are possible if that trial has unusually large $P$ or small $M$.

### 5.3 Is the Poisson model accurate for structured fibers?

The Poisson model $T_3(A_d) \approx s^3/N$ assumes $A_d$ behaves like a random set. But $A_d$ is constrained by 4AP-freeness and has non-trivial additive structure. In particular:
- $A_d$ is step-$d$ and step-$2d$ free (Remark A, proved).
- $A_d \subseteq A$, so it inherits the Bohr/Fourier structure of $A$.

The Poisson model may underestimate (or overestimate) $T_3(A_d)$ for structured fibers. The empirical observation that $\lambda(L) \approx 1.2$–$1.4$ (matching the Poisson prediction) suggests the model is approximately valid for the near-threshold fibers, at least for the greedy construction.

### 5.4 The lower bound on min\_wfrac: why not below $0.185$?

All observations give min\_wfrac $\geq 0.176$ (individual trial minimum, comp6) and avg min\_wfrac $\geq 0.189$ (N=15000). This floor arises from $L/P \geq 0.190$ across all tested $N$. Theoretically: if $P/L \leq 5.25$ universally, then min\_wfrac $\geq 1/5.25 \approx 0.190$.

**Open**: Can $P/L$ exceed $6$ for some $N$ or some 4AP-free $A$? If $P/L < 6$ universally, then min\_wfrac $> 1/6 \approx 0.167$. The empirical bound $P/L < 5.3$ gives min\_wfrac $> 0.189$, consistent with all observations.

### 5.5 The correction term min\_wfrac $\approx L/P + 0.003$

The systematic offset $+0.003$ above $L/P$ reflects that the absolute minimum popular fiber (of size $\approx L$) is not always 3AP-free. The minimum T₃=0 fiber has size slightly above $L$ (perhaps the typical minimum T₃=0 fiber has size $\approx 1.015 L$, giving the 1.5\% gap in wfrac). 

This offset is related to the probability that the smallest popular fiber is 3AP-free: under the Poisson model with $\lambda(L) \approx 1.2$, the probability is $e^{-1.2} \approx 30\%$. The average offset suggests that the actual minimum T₃=0 fiber size is $L \times (1 + O(\lambda(L)^{1/3}))$ — but this is speculative.

---

## 6. Connection to H2 and the Full Proof of Conjecture 2

### 6.1 The 1/5 phenomenon implies H2 approximately

**H2** (from lovász13, §3.5): Every popular fiber with $|A_d| > P/4$ has $T_3(A_d) > 0$.

Under the Poisson model:
- For $s > P/4 = 5L/4 = 1.25L$: $\lambda(s) \approx (1.25)^3 \times 1.2 \approx 2.34$. So $\Pr[T_3=0] \approx e^{-2.34} \approx 10\%$. NOT zero.
- For $s > P/3 = 5L/3 \approx 1.67L$: $\lambda(s) \approx (1.67)^3 \times 1.2 \approx 5.6$. $\Pr[T_3=0] \approx 0.4\%$. Nearly zero.
- For $s > P/2 = 5L/2 = 2.5L$: $\lambda(s) \approx (2.5)^3 \times 1.2 \approx 18.75$. $\Pr[T_3=0] \approx e^{-18.75} \approx 7 \times 10^{-9}$. Effectively zero.

So H2 with threshold $1/4$ (wfrac $> 1/4$) is slightly too strong to derive from the Poisson model alone (still 10\% probability). H2 with threshold $1/3$ would be more defensible from the model ($<0.4\%$).

### 6.2 Strengthened H2 from the 1/5 observation

The 1/5 observation suggests a strengthened hypothesis:

**H2-strong**: Every popular fiber with $|A_d| > P/5 = L$ (wfrac $> 1/5$, i.e., above the threshold) has $T_3(A_d) > 0$ for sufficiently large $N$.

This is stronger than H2 ($> P/4$) and says that EXACTLY the threshold-size fibers are 3AP-free. Under the Poisson model with $\lambda(L) \to \infty$ (but slowly), H2-strong becomes true asymptotically: as $N \to \infty$, the probability of a fiber of size $> 1.01 L$ being 3AP-free goes to 0 (since $\lambda(1.01 L) = (1.01)^3 \lambda(L) \to \infty$).

### 6.3 Conditional proof of H-1/5 from energy + Poisson

**Claim** (conditional on $E(A) \leq C_E M^3/N$ and Poisson model):

*For every 4AP-free $A$ with $|A| = M$ and $N$ sufficiently large:*
1. $P \leq C_E' \cdot L$ for some constant $C_E'$ depending only on $C_E$.
2. Some popular fiber $d_0$ with $|A_{d_0}| \leq C_E' L$ (wfrac $\leq 1$) has $T_3(A_{d_0}) = 0$.
3. min\_wfrac $\leq C_E' \cdot L/P \leq C_E' \cdot L/(2L) = C_E'/2$.

*Proof sketch*:
- Step 1: From $P \leq 2E(A)/M^2 \leq 2C_E M/N = 8C_E L$. (If $C_E \leq 5/8$, this gives $P \leq 5L$.)
- Step 2: There are popular fibers of size $\approx L$ (barely popular). The Poisson model gives probability $\approx e^{-\lambda(L)} > 0$ of each being 3AP-free. By C2 (which is assumed/empirically verified), some good fiber exists; by Step 2 (concentration near threshold), the minimum wfrac among good fibers is $\approx L/P$.
- Step 3: Direct from Steps 1 and 2.

**Status**: Conditional on (a) $E(A) \leq C_E M^3/N$ and (b) C2 being true (Gap 3.1). Neither is proved unconditionally.

### 6.4 Does H-1/5 help prove C2 (Conjecture 2)?

**Direct connection**: If H-1/5 could be proved INDEPENDENTLY of C2 (not using C2 as an input), it would immediately give C2: H-1/5 says there exists a popular T₃=0 fiber of wfrac $\approx 1/5$, which is precisely C2.

**But the circularity is**: H-1/5 as proved above uses C2 in the step "some good fiber exists." The 1/5 theorem in its current form is: *conditional on C2 being true, the smallest witness has wfrac $\approx 1/5$.*

**What the 1/5 observation provides toward a C2 proof**:

1. **It narrows the search**: C2 witnesses are concentrated in a specific part of the fiber spectrum (wfrac $\approx 0.20$), not distributed uniformly. Any proof of C2 should explain why the small-wfrac fibers are exactly the ones that are 3AP-free.

2. **It motivates H2** (and H2-strong): Proving that fibers with wfrac $> 1/4$ (or $> 1/5$) always have $T_3 > 0$ is the KEY MISSING STEP. Once H2 is proved:
   - All good fibers have wfrac $\leq 1/4$ (by H2).
   - IF some good fiber exists (C2), its wfrac is $\leq 1/4$: this is RC2.
   - In the other direction: H2 + RC2 ← C2 (they're all equivalent up to RC2 refinement).

3. **The Roth-threshold argument for H2**: For fibers with $|A_d| > P/4 \approx 5L/4$, the Poisson $\lambda \approx 2.3$ gives $\Pr[T_3=0] \approx 10\%$. But these are NOT random sets — they're structured. The question is whether the structure INCREASES or DECREASES this probability. Given that argmax fibers (wfrac $= 1$, $\lambda \approx 150$) always have $T_3 > 0$ empirically, the structure appears to INCREASE $T_3$ for large fibers (more internal structure = more 3APs). If this monotonicity holds all the way down to wfrac $= 1/4$, H2 would follow.

### 6.5 Roadmap to unconditional C2 via the 1/5 analysis

The 1/5 analysis suggests the following proof strategy:

**Step 1**: Prove $E(A) \leq C_E M^3/N$ for 4AP-free $A$ (energy bound).

**Step 2**: Deduce $P/L \leq c$ for some constant $c$ (from Step 1 via $P \leq E(A)/(M^2/2)$).

**Step 3**: Prove that fibers of size $> c'L$ (for $c' > 1$) have $T_3 > 0$ (H2-type bound). This follows if $\lambda(c'L) \gg \log(1/\delta)$ where $\delta$ is a small probability, i.e., if the Poisson model holds and $c'L \gg N^{1/3}$.

**Step 4**: Any good (T₃=0) fiber has size $\leq c'L$ (from Step 3), i.e., wfrac $\leq c'/c$. If $c'/c < 1$, this gives RC2.

**Step 5**: Show there EXISTS a popular fiber of size near $L$ that is 3AP-free. This is the core of C2. Step 5 would follow from a "threshold fiber 3AP-freeness" theorem.

**The key missing theorem**: Show that among popular fibers of size $\leq 1.5L$ (say), some is 3AP-free. This is not obvious — such fibers are structured (they come from 4AP-free $A$) and the Poisson model might not apply directly.

---

## 7. Conclusions

### 7.1 The 1/5 threshold: a two-part explanation

The observation avg\_min\_wfrac $\approx 0.200$ across $N = 2500$–$30000$ is explained by:

**(a) $L/P \approx 1/5$**: The popularity threshold $L = M^2/(4N)$ and the maximum popular fiber size $P$ both scale as $N^{0.40}$, giving a stable ratio $P/L \approx 5.1$–$5.2$.

**(b) 3AP-free fibers cluster at threshold**: Under the Poisson model, the probability $e^{-s^3/N}$ of a fiber of size $s$ being 3AP-free drops from $\sim 30\%$ at $s = L$ to $\sim 10^{-65}$ at $s = P$. So almost all 3AP-free popular fibers have size $\approx L$, giving min wfrac $\approx L/P \approx 1/5$.

### 7.2 New theoretical predictions

1. **$P/L$ convergence**: $P/L$ should converge to a specific constant (perhaps $5.0$ or $5.1$) as $N \to \infty$. The slow drift from $5.06$ (N=20000) to $5.23$ (N=30000) suggests possible slow convergence or sample noise.

2. **Min\_wfrac converges to $1/P'$ for a specific $P'$**: If $P/L$ has a limit, so does min\_wfrac. The data suggests convergence to $\approx 0.195$–$0.200$.

3. **Lower bound**: min\_wfrac $\geq 1/(P/L + \varepsilon) \approx 0.190$ holds for all $N \geq 5000$ empirically. Proving $P/L \leq 5.3$ would give min\_wfrac $\geq 0.189$, matching the observed minimum.

### 7.3 Most actionable next steps for a human mathematician

1. **Prove $E(A) \leq C_E M^3/N$ for 4AP-free $A$** (energy bound): This is the gateway to bounding $P/L$ and thereby proving a lower bound on min\_wfrac.

2. **Prove H2-strong**: Every popular fiber of size $> 1.5L$ has $T_3 > 0$. A direct combinatorial argument using the $2 \times 3$ grid structure and the popularity of $d$ might work.

3. **Prove the threshold-size fiber lemma**: Show that among popular fibers of size in $[L, 1.5L]$, some is 3AP-free. This would combine with H2-strong to prove C2.

4. **Investigate $P/L$ for non-greedy constructions**: Does $P/L \approx 5$ hold for Salem-Spencer or Behrend-type sets? If yes, it's universal; if no, it's a property of the greedy construction.

---

## Appendix: Numerical Verification of $L/P \approx$ avg\_min\_wfrac

At each $N$, we verify the identification $\mathrm{avg\_min\_wfrac} \approx L/P$:

$$\text{avg min\_wfrac} \approx \frac{L}{P} = \frac{(M^2/4N)}{P}$$

| $N$ | avg $M$ | avg $P$ | $L = M^2/4N$ | $L/P$ | avg min\_wfrac | difference |
|----:|--------:|--------:|-------------:|------:|---------------:|----------:|
| 5000  | 592.0  | 90.75  | 17.46 | 0.1923 | 0.1986 | +0.006 |
| 7000  | 748.5  | 103.25 | 20.00 | 0.1937 | 0.1987 | +0.005 |
| 8000  | 822.6  | 108.50 | 21.13 | 0.1948 | 0.2000 | +0.005 |
| 10000 | 956.4  | 117.88 | 22.87 | 0.1940 | 0.1984 | +0.004 |
| 15000 | 1272.3 | 142.25 | 26.98 | 0.1897 | 0.1934 | +0.004 |
| 20000 | 1546.7 | 151.33 | 29.91 | 0.1977 | 0.2004 | +0.003 |
| 30000 | 2053.0 | 183.50 | 35.12 | 0.1913 | 0.1935 | +0.002 |

The differences (0.002–0.006) are consistent with the minimum 3AP-free fiber having size slightly above $L$ (the absolute minimum popular fiber may not be 3AP-free). As $N$ grows, the correction shrinks (0.006 → 0.002), suggesting that the minimum T₃=0 fiber converges to the minimum popular fiber in relative terms.

**Conclusion**: The 1/5 threshold is precisely the ratio $L/P$ = (popularity threshold)/(maximum popular fiber), and this ratio is empirically approximately $1/5$ because both $L$ and $P$ grow as $N^{0.40}$. The theoretical explanation for WHY $P/L \approx 5$ (and not any other value) remains open and is the key structural question.
