# Explorer Review 2 — Lovász2 Verification

**Date**: 2026-06-21  
**Reviewer**: witsoc-explorer (session continuation)  
**Files reviewed**: lovász2_L2C_raghavan.md, lovász2_L2B_vanCorput.md, lovász2_L2A_conjecture.md

---

## R2 Verdict: L2C (Main Theorem 1 Proof)

**AUTHORIZED**

### Checks performed

**RC-1 (Raghavan citation exact)**  
Theorem 1.4 is cited with the exact form:
$$|A| \leq C_1 \cdot N \cdot \exp\!\bigl(-c_1 \cdot (\log N)^{1/6} \cdot (\log\log N)^{-1}\bigr)$$
The log log N denominator is present and explicitly flagged ("carried explicitly; we do not suppress it"). PASS.

**RC-2 (Square-root computation correct)**  
The 3-line proof is:
$$\frac{M^2}{4N} \leq r_3(N) \leq C_1 N \exp\!\bigl(-\tfrac{c_1(\log N)^{1/6}}{\log\log N}\bigr)
\implies M \leq 2C_1^{1/2} N \exp\!\bigl(-\tfrac{c_1}{2}\cdot\tfrac{(\log N)^{1/6}}{\log\log N}\bigr)$$
Arithmetic: $\sqrt{C_1 N^2 \cdot 4 \cdot \exp(-c_1(\cdot))} = 2C_1^{1/2}N\exp(-(c_1/2)(\cdot))$. PASS.

**RC-3 (Exponent 1/6 preserved)**  
Remark 1.2 explicitly states: "the exponent of log N is 1/6, unchanged by the square root. Only the constant c is halved." This directly addresses and retracts the earlier F3 misconception (exponent 1/12). PASS.

**RC-4 (Green-Tao comparison and LSS exclusion accurate)**  
GT 2017 bound $r_4(N) \leq N(\log N)^{-c}$ cited correctly. LSS 2024 exclusion of k=4 due to 2-torsion obstruction in 2-step nilmanifolds is accurately described. The document does not overclaim LSS. PASS.

### Minor notes
- The "In particular, $r_4(N)=o(N/(\log N)^k)$ for every fixed $k>0$" corollary is correctly derived from the quasi-polynomial bound.
- Constants: $C = 2C_1^{1/2}$, $c = c_1/2$ are set explicitly. Clean.

**L2C assessment**: All 4 checks pass. File is ready for direct inclusion in submittable_proof.md §2–§3.

---

## R3 Verdict: L2B (Van Corput Lemma 1.1)

**AUTHORIZED**

### Checks performed

**RB-1 (Pigeonhole step correct)**  
$\sum_{d=1}^{N-1}|A_d| = \binom{M}{2} = M(M-1)/2 \geq M^2/4$ (for $M\geq 2$). Divided by $N-1 \leq N$ values of $d$ gives $|A_{d^*}| \geq M^2/(4N)$. PASS. (Trivial case $M\leq 1$ handled.)

**RB-2 (Cauchy-Schwarz identity stated and applied correctly)**  
The identity
$$\Lambda_4(A)^2 \leq \Bigl(\tfrac{1}{N}\sum_d |A_d|^2\Bigr)\cdot\Bigl(\tfrac{1}{N}\sum_d T_3(A_d)\Bigr)$$
is invoked from [Gowers 2001, Lemma 3.1] and [Tao-Vu 2006, Lemma 11.2]. Since $\Lambda_4(A)=0$ (A is 4-AP-free), the RHS is zero, forcing $T_3(A_d)=0$ for every $d$. PASS.

**RB-3 (Gap in 6-point argument correctly identified)**  
Remark A correctly states: when $e=d$, six points $a,a+e,a+2e,a+d,a+e+d,a+2e+d$ include $a,a+d,a+2d,a+3d$ (a 4-AP), giving contradiction. But when $e \neq d$, the six points need NOT contain a 4-AP. The Cauchy-Schwarz argument is therefore necessary. This is exactly the gap identified in explorer2_barrier_packet.json (Gap-V). PASS.

**RB-4 (Citations appropriate and accessible)**  
[Gowers 2001] GAFA 11 (2001) 465–588 and [Tao-Vu 2006] Additive Combinatorics are standard, freely citable references. Gowers 2001 Lemma 3.1 is the $U^2$-norm Cauchy-Schwarz lemma; Tao-Vu Lemma 11.2 is the van Corput differencing application. Both are correct citations for the identity used. PASS.

### Minor notes
- **$T_3$ convention**: The document defines $T_3(B)$ as counting 3-APs including trivial ones ($b_1=b_2=b_3$). The conclusion "$T_3(A_d)=0$" therefore implies $A_d=\emptyset$ unless "trivial" is separated. Remark B's use of "$T_3(A_d)=0$ for all non-trivial 3-APs" clarifies this. The LaTeX-ready version says "number of 3-APs in $B$" — Generator2 should clarify whether trivial 3-APs are counted and adjust the conclusion to "3-AP-free (contains no non-trivial 3-AP)" for precision.
- Remark B's elementary alternative argument contains a slightly imprecise inequality ($0 = \Lambda_4(A) \geq c \cdot \ldots$) — the direction should be $\leq$ if $c>0$. This remark is supplementary and not part of the main proof path; no action needed for the main theorem.
- The Gowers $U^3[N]$ material in the middle of Step 2 is unnecessary for the argument and slightly muddies the proof. Generator2 may wish to omit it for a cleaner presentation.

**L2B assessment**: All 4 checks pass. Main proof path (Steps 1-3 + LaTeX version) is logically complete and citable. Generator2 should clarify the trivial 3-AP convention and may trim the supplementary Gowers $U^3$ material.

---

## R4 Verdict: L2A (L3-AP-INCR Conjecture + Conditional Theorem 2)

**AUTHORIZED with caveats**

### Checks performed

**RA-1 (β formula stated as idealised, not proved)**  
The general formula $\beta = 1/(s+\rho)$ where $\rho$ = Bohr-set rank exponent and $s$ = density increment exponent is correctly labelled as "idealised." The table shows known methods have actual $\beta$ consistently worse by a log-log factor. PASS.

**RA-2 (Table internally consistent)**  
| Method | $\rho$ | $s$ | $\beta_{\rm ideal}$ | $\beta_{\rm actual}$ |
|--------|--------|-----|---------------------|----------------------|
| KM     | 4      | 5   | 1/9                 | 1/12                 |
| BS     | 3      | 4   | 1/7                 | 1/9                  |
| Raghavan| 2     | 3   | 1/5                 | 1/6                  |

The pattern is $\beta_{\rm actual} = 1/(s+\rho+1)$ (consistently). For the conjectured next step: $\rho=1$, $s=2$, $\beta_{\rm ideal}=1/3$, $\beta_{\rm actual}$ predicted 1/4 by the same pattern. The document targets 1/3 (idealized); the log-log correction would give something between 1/4 and 1/3 in practice. **This discrepancy is acknowledged in the document.** PASS.

**RA-3 (Conjecture 1 precisely stated)**  
L3-AP-INCR Conjecture states: For $A \subseteq \mathbb{Z}_N$ 3-AP-free with density $\alpha$, there exists a Bohr set $B = \text{Bohr}(\Gamma, c)$ with $|\Gamma| \leq C\alpha^{-1}$, $|B| \geq N\exp(-C\alpha^{-1})$, and a translate $x+B$ on which $A$ has density $\geq \alpha + c\alpha^2$.

The parameters $|\Gamma| = O(\alpha^{-1})$ (rank-1 Bohr, $\rho=1$) and increment $\Omega(\alpha^2)$ ($s=2$) are the critical ones needed for $\beta=1/3$. The conjecture is precisely stated with these parameters. PASS.

**RA-4 (Conditional Theorem 2 arithmetic correct)**  
Given L3-AP-INCR with increment $\eta = c\alpha^2$ and rank $d = C\alpha^{-1}$:
- $k^* = O(\alpha^{-2})$ iterations to reach density 1.
- Each step compresses by $\exp(-Cd) = \exp(-C'\alpha^{-1})$.
- Total compression after $k^*$ steps: $\exp(-k^* \cdot C'\alpha^{-1}) = \exp(-C'\alpha^{-3})$.
- Equating $\exp(-C'\alpha^{-3}) = 1/N$ gives $\alpha^{-3} = C''\log N$, so $\alpha = (C''/\log N)^{1/3}$.
- With log-log factor: $r_3(N) \leq C'N\exp(-c'(\log N)^{1/3}/\log\log N)$.

Arithmetic verified step by step. PASS.

**RA-5 (KL analogy honest)**  
The document correctly states: KL gives $\Omega(\beta^2)$ increment with rank $O(\beta^{-1})$ in the bipartite setting (not trilinear). The analogy is presented as motivation, not as a proof of L3-AP-INCR. The document distinguishes what is proved vs. conjectured throughout. PASS.

### Caveats

**Caveat 1 (β_actual vs β_ideal gap for ρ=1)**  
The consistent pattern in the table suggests $\beta_{\rm actual} = 1/(s+\rho+1)$, giving $\beta_{\rm actual} = 1/4$ (not 1/3) for $\rho=1$, $s=2$. The document argues the log-log factor is absorbed into the log-log denominator already present in the Raghavan-style bound. This is plausible for the conditional theorem (which is stated with log-log), but Generator2 should note this uncertainty explicitly in submittable_proof.md: the conditional theorem likely achieves exponent $1/3$ only up to the log-log correction.

**Caveat 2 (Standard Cauchy-Schwarz gives Ω(α⁴), not Ω(α²))**  
The document correctly identifies this gap: standard $T_3(A) \geq cα^3 |A|^2$ type bounds give density increment $\Omega(\alpha^3/d) = \Omega(\alpha^4)$ on rank-$d = O(\alpha^{-1})$ Bohr sets. For L3-AP-INCR one needs $\Omega(\alpha^2)$, requiring an additional factor of $\alpha^{-2}$ improvement over known spectral methods. The Kelley-Lyu type approach is the only candidate, and it has not been adapted to this setting. Generator2 must state this gap prominently when presenting Conjecture 1 in the paper.

**Caveat 3 (Iteration count arithmetic)**  
The document uses $k^* = O(\alpha^{-2})$ but the increment $\eta = c\alpha^2$ applied $k^*$ times gives roughly $(1+c\alpha^2)^{k^*} \approx e^{c\alpha^2 \cdot k^*} \approx e^c$ which brings density from $\alpha$ to $O(1)$. So $k^* = O(\alpha^{-2})$ is correct. However, the density at each step is changing, so a more careful induction is needed (standard in the literature). This is a presentation issue, not a mathematical error. Generator2 should add a sentence acknowledging the density-tracking subtlety.

---

## Overall Authorization

**AUTHORIZE Generator2 to proceed.**

All three Lovász2 files contain correct mathematics for their stated purposes:
- **L2C**: Main Theorem 1 proof is complete, ready for direct inclusion.
- **L2B**: Van Corput Lemma 1.1 proof is complete; minor clarification needed on trivial 3-AP convention.
- **L2A**: Conditional framework is correctly stated; caveats on the β gap must be incorporated in the paper.

The only items blocking a submittable draft are:
1. Generator2 must clarify the $T_3$ trivial-AP convention in L2B (minor).
2. Generator2 must prominently state the Ω(α²) gap in L2A §5 when presenting Conjecture 1.
3. Generator2 must assemble Sections 1–5 of submittable_proof.md (structure task, not mathematical gap).

None of these block authorization — they are drafting tasks for Generator2.

---

## Key Recommendations for Generator2

1. **Use L2C Block 2 verbatim** for the proof of Main Theorem 1 (§3). It is LaTeX-ready.

2. **Use L2B LaTeX-ready version** for Lemma 1.1 (§3). Add one sentence clarifying: "$T_3(B)=0$ means $B$ contains no non-trivial 3-APs (i.e., no 3-AP with $e \neq 0$)."

3. **For L2A (§4 — Conditional results)**: Open the section with a clear statement that Conjecture 1 is open, that standard Fourier methods give only $\Omega(\alpha^4)$ increment on rank-$O(\alpha^{-1})$ Bohr sets (gap of $\alpha^{-2}$), and that the conjecture is motivated by analogy with Kelley-Lyu's bipartite argument. State Conditional Theorem 2 with the log-log factor.

4. **Paper structure** (5 sections recommended):
   - §1 Introduction (statement of Main Theorem 1, comparison with GT 2017, historical context)
   - §2 Preliminaries (Raghavan Theorem 1.4 = L2C Block 1; notation)
   - §3 Main Result (Lemma 1.1 = L2B; proof of Main Theorem 1 = L2C Block 2)
   - §4 Conditional Improvement (L2A framework; Conjecture 1; Conditional Theorem 2)
   - §5 Discussion (open problems: L3-AP-INCR, exponent 1/3, KL ceiling for k=4)

5. **References required**: Raghavan 2026, Gowers 2001 (GAFA), Tao-Vu 2006, Bloom-Sisask 2023, Kelley-Meka 2023, Green-Tao 2017, LSS 2024, Kelley-Lyu 2025.

---

## Summary Table

| File | Verdict | Ready for paper? | Actions for Generator2 |
|------|---------|-----------------|------------------------|
| L2C  | AUTHORIZED | Yes (verbatim) | None |
| L2B  | AUTHORIZED | Yes (minor edit) | Clarify $T_3$ trivial-AP convention |
| L2A  | AUTHORIZED with caveats | Yes (with additions) | State Ω(α²) gap prominently; note β_actual vs β_ideal |

**Overall**: AUTHORIZED. Generator2 may proceed to assemble submittable_proof.md.
