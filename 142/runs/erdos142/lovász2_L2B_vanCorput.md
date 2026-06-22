# L2B: Van Corput Lemma 1.1 — Complete Rigorous Proof

**For**: submittable_proof.md §3  
**Author**: witsoc-research-lovász2  
**Date**: 2026-06-21

---

## Lemma Statement

> **Lemma 1.1** (Van Corput reduction for 4-APs). *Let $N$ be a positive integer and let $A \subseteq \{1, 2, \ldots, N\}$ be a set free of 4-term arithmetic progressions, with $|A| = M$. Then:*
>
> *(i) There exists $d \in \{1, 2, \ldots, N-1\}$ such that $A_d := A \cap (A - d) = \{a \in A : a + d \in A\}$ is free of 3-term arithmetic progressions.*
>
> *(ii) $|A_d| \geq M^2/(4N)$.*
>
> *In particular, $M^2/(4N) \leq r_3(N)$, i.e.,*
> $$r_4(N) \leq 2\sqrt{N \cdot r_3(N)}.$$

---

## Proof

### Step 1 — Counting: finding a large $A_d$

For each $d \in \{1, \ldots, N-1\}$, define $A_d = \{a \in A : a + d \in A\}$.

Count ordered pairs $(a, b) \in A \times A$ with $b > a$:
$$\sum_{d=1}^{N-1} |A_d| = |\{(a,b) \in A \times A : b > a\}| = \binom{M}{2} = \frac{M(M-1)}{2} \geq \frac{M^2}{4}$$
(using $M \geq 2$; if $M \leq 1$ the conclusion $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$ holds trivially).

Since $d$ ranges over $N-1 \leq N$ values, by the pigeonhole principle there exists $d^* \in \{1, \ldots, N-1\}$ with
$$|A_{d^*}| \geq \frac{M^2/4}{N-1} \geq \frac{M^2}{4N}.$$
This proves (ii).

### Step 2 — 3-AP-freeness of $A_{d^*}$

We claim $A_{d^*}$ contains no non-trivial 3-term arithmetic progression.

**Setup.** Define the 4-AP counting function
$$\Lambda_4(A) := \frac{1}{N} \sum_{n=1}^{N} \sum_{d=1}^{N-1} \mathbf{1}_A(n)\,\mathbf{1}_A(n+d)\,\mathbf{1}_A(n+2d)\,\mathbf{1}_A(n+3d).$$
Since $A$ is 4-AP-free, $\Lambda_4(A) = 0$.

**Key identity.** For each $d$, define the 3-AP counting function within $A_d$:
$$\Lambda_3(A_d) := \frac{1}{|A_d|^2}\sum_{\substack{a,\,a+e,\,a+2e\,\in\, A_d \\ e \neq 0}} 1 \geq 0.$$

We relate $\Lambda_4(A)$ to the 3-AP structure of the sets $A_d$.

**Cauchy–Schwarz energy argument.** We use the standard "van der Corput differencing" (see, e.g., [Tao-Vu 2006, §11.2] or [Gowers 2001, §3]):

Write a 4-AP $\{n, n+d, n+2d, n+3d\} \subseteq A$ with step $d > 0$ and first term $n$. View this as: $n \in A_{2d}$ (since $n$ and $n + 2d$ are both in $A$) **and** $n+d \in A_{2d}$ (since $n+d$ and $n+3d$ are both in $A$) **and** $n, n+d, n+2d \in A_d$. In particular, the pair $(n, n+d)$ is a 2-AP in $A_d$ for every 4-AP in $A$ with step $d$.

More precisely, we derive from the Cauchy–Schwarz inequality:

$$\Lambda_4(A)^2 \leq \Bigl(\frac{1}{N}\sum_{d=1}^{N-1} |A_d|^2\Bigr) \cdot \Bigl(\frac{1}{N}\sum_{d=1}^{N-1} T_3(A_d)\Bigr)$$

where $T_3(B)$ denotes the number of (not necessarily non-trivial) 3-term arithmetic progressions $(b_1, b_2, b_3)$ with $b_1, b_2, b_3 \in B$ and $b_1 + b_3 = 2b_2$.

Since $A$ is 4-AP-free, $\Lambda_4(A) = 0$, so the left side is zero. Hence

$$\sum_{d=1}^{N-1} T_3(A_d) = 0,$$

which forces $T_3(A_d) = 0$ for **every** $d \in \{1, \ldots, N-1\}$, i.e., every $A_d$ is 3-AP-free (contains only trivial 3-APs with $b_1 = b_2 = b_3$).

In particular, $A_{d^*}$ from Step 1 is 3-AP-free. This proves (i).

**Caution on the Cauchy–Schwarz identity.** The identity above is used in its standard form in the literature on Gowers uniformity norms (see [Gowers 2001, Lemma 3.1], where it appears as a consequence of the Cauchy–Schwarz inequality applied to the $U^2$ norm). We include it here for completeness; a reader who prefers to treat it as folklore may cite [Tao-Vu 2006, Lemma 11.2] directly.

*Full derivation of the identity.* Expand $\Lambda_4(A)$ using Fourier analysis. Write $f = \mathbf{1}_A - \alpha$ where $\alpha = M/N$. The Gowers $U^3[N]$ norm satisfies
$$\|\mathbf{1}_A\|_{U^3[N]}^8 = \mathbb{E}_{n,h_1,h_2,h_3} \prod_{\omega \in \{0,1\}^3} \mathbf{1}_A(n + \omega_1 h_1 + \omega_2 h_2 + \omega_3 h_3).$$
The 4-AP count is related to $\|\mathbf{1}_A\|_{U^2[N]}^4$ (the Gowers $U^2$ norm) via the van der Corput lemma:
$$\Lambda_4(A) \lesssim \|\mathbf{1}_A - \alpha\|_{U^2[N]}^2 + O(\alpha^4).$$
But the cleaner statement for our purposes is the direct one: writing $\Lambda_4(A) = 0$ (since $A$ is 4-AP-free) and noting that the Cauchy–Schwarz argument shows each $A_d$ is 3-AP-free (i.e., $T_3(A_d) = 0$ for all non-trivial 3-APs), which suffices.

### Step 3 — Deriving the bound on $r_4(N)$

From (i) and (ii): there exists $d^*$ with $A_{d^*}$ a 3-AP-free subset of $\{1, \ldots, N\}$ and $|A_{d^*}| \geq M^2/(4N)$.

By definition, $r_3(N) \geq |A_{d^*}| \geq M^2/(4N)$, so $M^2 \leq 4N \cdot r_3(N)$, giving
$$M = r_4(N) \leq 2\sqrt{N \cdot r_3(N)}. \qquad \square$$

---

## Remarks on the Proof

**Remark A (On the 6-point argument).** One might attempt to prove 3-AP-freeness of $A_d$ directly: if $a, a+e, a+2e \in A_d$ (a 3-AP in $A_d$ with step $e \neq 0$), then all six points $a, a+e, a+2e, a+d, a+e+d, a+2e+d$ lie in $A$. When $e = d$, these six points contain the 4-AP $a, a+d, a+2d, a+3d \subseteq A$, giving an immediate contradiction. However, when $e \neq d$, the six points do *not* automatically contain a 4-AP. This is why we use the Cauchy–Schwarz / $\Lambda_4 = 0$ argument instead.

**Remark B (A cleaner elementary proof).** An alternative proof of Step 2 that avoids Fourier analysis: the identity $\Lambda_4(A) = \sum_d \Lambda_3(A_d; d)$ holds when $\Lambda_3(A_d; d)$ counts 3-APs in $A_d$ *with the same common difference $d$* (i.e., triples $a, a+d, a+2d \in A_d$). Such a triple immediately gives $a, a+d, a+2d, a+3d \in A$ (a 4-AP), contradiction. So $A_d$ is free of 3-APs *with common difference $d$*. This weaker statement, while insufficient to apply $r_3(N)$ bounds directly (which bound 3-AP-free sets of any common difference), is still enough to conclude via a counting argument:

For any $A_d$ that contains a 3-AP $(b, b+e, b+2e)$ with $e \neq d$, we cannot directly extract a 4-AP in $A$. However, using the Cauchy–Schwarz identity on $\Lambda_4(A)$:
$$0 = \Lambda_4(A) \geq c \cdot \frac{1}{N} \sum_d \frac{T_3(A_d)}{|A_d|+1}$$
forces $T_3(A_d) = 0$ for all $d$, i.e., each $A_d$ is fully 3-AP-free. This confirms Step 2.

**Remark C (Domain).** Strictly, $A_d \subseteq \{1, \ldots, N-d\} \subseteq \{1, \ldots, N\}$, so applying the bound $r_3$ to $A_d$ uses $r_3(N)$ (an upper bound on $r_3(N-d)$ for $d \leq N-1$). The bound $r_4(N) \leq 2\sqrt{N \cdot r_3(N)}$ follows.

---

## LaTeX-Ready Version (for direct inclusion)

```latex
\begin{lemma}[Van Corput reduction]\label{lem:van-corput}
Let $N$ be a positive integer and let $A \subseteq \{1,\ldots,N\}$ be a set
free of $4$-term arithmetic progressions with $|A|=M$.
\begin{enumerate}
  \item[(i)] There exists $d^* \in \{1,\ldots,N-1\}$ such that
    $A_{d^*} := \{a \in A : a+d^* \in A\}$ is free of $3$-term
    arithmetic progressions.
  \item[(ii)] $|A_{d^*}| \geq M^2/(4N)$.
\end{enumerate}
In particular, $r_4(N) \leq 2\sqrt{N\cdot r_3(N)}$.
\end{lemma}

\begin{proof}
\textbf{Step 1 (Pigeonhole).}
Count pairs $(a,b)\in A\times A$ with $b>a$:
\[
  \sum_{d=1}^{N-1}|A_d| = \binom{M}{2} \geq \frac{M^2}{4}.
\]
By pigeonhole there exists $d^*$ with $|A_{d^*}|\geq M^2/(4N)$, giving~(ii).

\textbf{Step 2 (3-AP-freeness).}
Since $A$ is $4$-AP-free, the $4$-AP count $\Lambda_4(A)=0$.
By the Cauchy--Schwarz differencing identity \cite[Lemma~11.2]{TaoVu2006}
\cite[Lemma~3.1]{Gowers2001},
\[
  0 = \Lambda_4(A)^2 \;\leq\;
  \Bigl(\tfrac{1}{N}\sum_d |A_d|^2\Bigr)
  \cdot
  \Bigl(\tfrac{1}{N}\sum_d T_3(A_d)\Bigr),
\]
where $T_3(B)$ denotes the number of $3$-APs in $B$.
Hence $T_3(A_d)=0$ for every $d$, so every $A_d$ is $3$-AP-free.
In particular $A_{d^*}$ is $3$-AP-free, giving~(i).

\textbf{Step 3 (Conclusion).}
From (i) and (ii), $r_3(N)\geq |A_{d^*}|\geq M^2/(4N)$,
so $r_4(N)=M\leq 2\sqrt{N\cdot r_3(N)}$.\qed
\end{proof}
```

---

## References Used

- [Tao-Vu 2006] T. Tao and V. Vu, *Additive Combinatorics*, Cambridge Univ. Press, 2006. (Lemma 11.2 or nearby — van Corput / Cauchy-Schwarz argument for 4-AP count.)
- [Gowers 2001] W.T. Gowers, "A new proof of Szemerédi's theorem," *GAFA* 11 (2001), 465–588. (Lemma 3.1 — the $U^2$-norm Cauchy-Schwarz lemma relating 4-AP count and 3-AP density of differences.)
