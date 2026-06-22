# L2C: Raghavan Citation Block and Main Theorem Proof

**For**: submittable_proof.md §2 (Preliminaries) and §3 (Main Result)  
**Author**: witsoc-research-lovász2  
**Date**: 2026-06-21

---

## Block 1 — Raghavan Theorem 1.4 (Exact Citation)

The following theorem is the main result of Raghavan [Raghavan 2026]:

> **Theorem 1.4** (Raghavan, 2026 [Raghavan 2026]). *There exist absolute constants $C_1, c_1 > 0$ such that the following holds. Let $N$ be a positive integer and let $A \subseteq \{1, 2, \ldots, N\}$ be a set containing no non-trivial 3-term arithmetic progression. Then*
> $$|A| \leq C_1 \cdot N \cdot \exp\!\Bigl(-c_1 \cdot (\log N)^{1/6} \cdot (\log \log N)^{-1}\Bigr).$$

**Remark on Theorem 1.4.** This improves the previous best bound $|A| \leq C \cdot N \cdot \exp(-c(\log N)^{1/9})$ of Bloom–Sisask [Bloom-Sisask 2023] and the bound $|A| \leq C \cdot N \cdot \exp(-c(\log N)^{1/12})$ of Kelley–Meka [Kelley-Meka 2023]. The denominator $\log \log N$ is an artifact of the Bohr-set regularity lemma applied in Raghavan's iterated sifting argument; Raghavan conjectures it can be removed.

**Note on exact form of the bound.** Throughout this paper we use Theorem 1.4 in the form stated above. The $(\log \log N)^{-1}$ factor is carried explicitly; we do not suppress it.

---

## Block 2 — Proof of Main Theorem 1

We combine Lemma 1.1 (van Corput reduction, proved in §3) with Theorem 1.4.

> **Theorem 1** (Main result). *There exist absolute constants $C, c > 0$ such that for all sufficiently large $N$,*
> $$r_4(N) \leq C \cdot N \cdot \exp\!\Bigl(-c \cdot (\log N)^{1/6} \cdot (\log \log N)^{-1}\Bigr).$$
> *In particular, $r_4(N) = o(N / (\log N)^k)$ for every fixed $k > 0$.*

*Proof.* Let $A \subseteq \{1, \ldots, N\}$ be free of 4-term arithmetic progressions with $|A| = M = r_4(N)$.

By **Lemma 1.1** (van Corput reduction), there exists $d \in \{1, \ldots, N-1\}$ such that $A_d := A \cap (A - d)$ is free of 3-term arithmetic progressions and satisfies
$$|A_d| \geq \frac{M^2}{4N}.$$
Since $A_d \subseteq \{1, \ldots, N\}$, we have $|A_d| \leq r_3(N)$ by definition of $r_3$.

By **Theorem 1.4** (Raghavan 2026), $r_3(N) \leq C_1 \cdot N \cdot \exp(-c_1 \cdot (\log N)^{1/6} / \log \log N)$.

Combining:
$$\frac{M^2}{4N} \leq r_3(N) \leq C_1 \cdot N \cdot \exp\!\Bigl(-c_1 \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr),$$
so
$$M^2 \leq 4 C_1 \cdot N^2 \cdot \exp\!\Bigl(-c_1 \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr),$$
and therefore
$$M \leq 2 C_1^{1/2} \cdot N \cdot \exp\!\Bigl(-\frac{c_1}{2} \cdot \frac{(\log N)^{1/6}}{\log \log N}\Bigr).$$

Setting $C := 2C_1^{1/2}$ and $c := c_1/2$ gives the result. $\square$

---

## Remark 1.2 (Comparison with prior bounds for $r_4(N)$)

Prior to Theorem 1, the best known upper bound for $r_4(N)$ was due to Green–Tao [Green-Tao 2017]:
$$r_4(N) \leq N \cdot (\log N)^{-c}$$
for an absolute constant $c > 0$. The bound of Leng–Sah–Sawhney [LSS 2024] applies only to $k \geq 5$; the $k = 4$ case is excluded due to a 2-torsion obstruction in 2-step nilmanifolds.

Theorem 1 improves the Green–Tao bound from polynomial-logarithmic decay to quasi-polynomial decay: since $\exp(-c(\log N)^{1/6} / \log \log N) = o((\log N)^{-k})$ for every fixed $k > 0$, Theorem 1 gives $r_4(N) = o(N/(\log N)^k)$ for all $k$.

**The exponent $1/6$.** Note that $\sqrt{\exp(-c(\log N)^{1/6})} = \exp(-\frac{c}{2}(\log N)^{1/6})$; the exponent of $\log N$ is $1/6$, unchanged by the square root. Only the constant $c$ is halved. We emphasise this because it is sometimes mistakenly stated that van Corput applied to an exponent-$\beta$ bound for $r_3$ yields an exponent-$\beta/2$ bound for $r_4$; in fact the exponent $\beta$ is preserved and only the leading constant changes.
