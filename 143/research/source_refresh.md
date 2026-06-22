# Source Refresh: r_k(N) Literature — April–June 2026

**Date**: 2026-06-21  
**Scout agent**: OpenScientist Scout (session: sess_a3190bc9)  
**Scope**: Literature refresh targeting April–June 2026 papers, Peluse 2025 survey verification, and key claim checks

---

## Section 1: New Papers Found (April–June 2026)

### 1.1 No Major New Theoretical Bounds

**A thorough search found no paper from April–June 2026 that improves the theoretical bounds on r_k(N) for any k ≥ 3.** Specifically:

- No paper improves Raghavan's exponent 1/6 for k=3 upper bounds
- No paper transfers Kelley–Lyu to arithmetic progressions
- No paper improves the EHPS lower bound constant
- No new results on r_4(N) or r_k(N) for k ≥ 5

### 1.2 Adjacent Papers Found (April–June 2026)

The following papers are from the period but tangential to the core r_k(N) problem:

| arXiv ID | Title | Authors | Date | Relevance |
|----------|-------|---------|------|-----------|
| 2603.09281 | On the Green-Tao theorem for sparse sets | Teräväinen, Wang | Mar 2026 | Uses Leng–Sah–Sawhney inverse theorem; quantitative Green-Tao for density-δ sets in primes. Not about r_k(N) in {1,...,N}. |
| 2604.05768 | On the Furstenberg-Katznelson constant for the IP Szemerédi theorem over finite fields | Shalom | Apr 2026 | IP Szemerédi over finite fields; density bounds for intersection of sets. Not about r_k(N). |
| 2605.13628 | A note on arithmetic progressions with restricted differences | Conlon, Fox, Pham | May 2026 | Cap-set bounds via Tao slice rank for restricted-difference 3-APs in F_q^n. Not about r_k(N) in {1,...,N}. |
| 2606.02312 | Arithmetic regularity as an alternative to transference | Chow, Prendiville, Vazquez | Jun 2026 | Methodology paper proposing arithmetic regularity instead of Fourier transference. Relevant to future proof strategies but no concrete bounds. |
| 2606.02541 | Three-color van der Waerden numbers grow super-exponentially | Unknown | Jun 2026 | Proves w(k;3) grows super-exponentially; resolves Erdős-Graham problem. Related to AP coloring, not AP-free density. |
| 2606.01780 | Hitting Arithmetic Progressions at the Square-Root Scale | Korsky | Jun 2026 | Hitting sets (dual to AP-free sets), not AP-free density. Not relevant. |
| 2606.04016 | Witness-split + window-cardinality refinement for r_3(N) | Ergezer | Jun 2026 | Computational CS paper: verifies r_3(212) = 43 via CP-SAT/HiGHS/SAT solvers. Not a theoretical bound improvement. Includes Lean formal-proof-search encoding. |

### 1.3 Notable Peripheral Papers (Pre–April 2026 but May Have Been Missed)

**arXiv:2509.01568** (Sep 2025) — "Additive structure in convex sets" by **Thomas F. Bloom**, Jakob Führer, Oliver Roche-Newton.  
- Shows a convex set A contains Ω(|A|^{3/2}) three-term arithmetic progressions (construction, not bound on AP-free sets).  
- Not directly about r_3(N) upper/lower bounds.

**arXiv:2512.11217** (Dec 2025) — "Improved Bounds for the Freiman-Ruzsa Theorem" by **Rushil Raghavan**.  
- About the Freiman-Ruzsa structure theorem, not directly about AP-free density bounds.

---

## Section 2: Papers That Update Our Analysis

### 2.1 CRITICAL CORRECTION: EHPS Lower Bound Is Misdescribed in final_report.md

**The description of the EHPS lower bound in final_report.md (line 167–175, 190) is INCORRECT.**

**What final_report.md says:**
> r_3(N) ≥ N · exp(-C(log N)^{1−ε}) for all ε > 0  [EHPS 2024]

**What the EHPS paper (arXiv:2406.12290) actually proves:**

> **r₃(N) ≥ N · 2^{−(2√(log₂(24/7)) + o(1)) · √(log₂ N)}**

where 2√(log₂(24/7)) ≈ 2.667, improving Behrend's constant 2√2 ≈ 2.828.

**The EHPS improvement is in the CONSTANT inside exp(-c·√(log N)), not in the exponent structure.** Both Behrend and EHPS have bounds of the form N · exp(-c·√(log N)); EHPS reduces c from ≈ 2.828·√(log 2) to ≈ 2.667·√(log 2). The ratio of EHPS to Behrend is exp((2√2 − 2√(log₂(24/7)))·√(log₂ N)·log 2) ≈ exp(0.094·√(log N)), which is indeed "quasipolynomial" (super-polynomial), justifying the paper's claim.

**Impact on gap description:** The actual state of the art gap is:
- Upper bound: N · exp(−c(log N)^{1/6} / log log N)  [Raghavan 2026]
- Lower bound: N · 2^{−(2√(log₂(24/7)) + o(1)) · √(log₂ N)} = N · exp(−c'·√(log N))  [EHPS 2024]

**Both bounds are now "quasi-polynomial" in the sense of exp(-c·(log N)^β),** with β = 1/6 for the upper bound and β = 1/2 for the lower bound. The gap is between exponents β = 1/6 and β = 1/2 (not between polynomial-type and quasi-polynomial-type as might be inferred from the current final_report.md language).

**Correction needed:** Table row 167 and paragraph at line 190 in final_report.md must be corrected.

### 2.2 Minor Correction: Kelley–Lyu Submission Date

**The final_report.md describes Kelley–Lyu as "arXiv:2505.01587, June 2026."**

**Actual timeline:**
- First posted: **May 2, 2025** (arXiv:2505.01587v1 — note 2505 = May 2025)
- Latest revision: **June 11, 2026** (version updated but paper existed since May 2025)

The "June 2026" label in the final report refers to the latest revision date, not the original submission. The paper should be cited as "(arXiv:2505.01587, May 2025; updated June 2026)."

### 2.3 Peluse Survey Missing from final_report.md State-of-Art Table

The Peluse survey (arXiv:2509.22962, September 2025) is referenced in the final report but does NOT appear in the bounds tables. Its cutoff is Bloom–Sisask (1/9 exponent) for k=3 upper bound; it does not know about Raghavan. The survey should be added as a reference for the period 2023–2025 overview.

---

## Section 3: Peluse 2025 Survey Coverage

### 3.1 Identity and Scope

**Title**: "Finding arithmetic progressions in dense sets of integers"  
**Author**: Sarah Peluse  
**Published**: arXiv:2509.22962, submitted September 30, 2025  
**Venue**: AMS Current Events Bulletin lecture article  
**Length**: ~26 pages (expository)

### 3.2 Results Covered

| Topic | Coverage | Notes |
|-------|----------|-------|
| Roth (1953) k=3 first bound O(N/log log N) | Yes, detailed proof sketch | Section 2 |
| Heath-Brown/Szemerédi (1987/1990) power of log | Yes | Brief mention |
| Gowers (1998/2001) k≥4 first bounds | Yes | Theorem 1.2 |
| Green-Tao (2017) r_4(N) = O(N/(log N)^c) | Yes | Theorem 1.3 |
| Leng-Sah-Sawhney (2024) k≥5 exp(-(log log N)^{c_k}) | Yes, **main focus** | Sections 3–5 |
| Kelley-Meka (2023) exponent 1/12 for k=3 | Yes | Mentioned in Section 2 |
| Bloom-Sisask (2023) exponent 1/9 for k=3 | Yes | "further optimized to 1/9" |
| EHPS (2024) Behrend improvement | Yes, brief | "substantially improved" |
| **Raghavan (2026) exponent 1/6 for k=3** | **NO** | Submitted after survey |
| **Kelley-Lyu (2025) communication complexity** | **NO** | Not referenced |
| Leng-Sah-Sawhney U^{s+1}[N] inverse theorem (2024) | Yes, detailed | Main technical contribution of survey |

### 3.3 What the Peluse Survey Does NOT Cover

1. **Raghavan (arXiv:2603.27045)**: Survey submitted September 2025; Raghavan's paper appeared March 2026. The best k=3 upper bound in the survey is Bloom–Sisask (exponent 1/9), not Raghavan (1/6).

2. **Kelley–Lyu (arXiv:2505.01587)**: The survey does not discuss the communication complexity applications of sifting. The survey's focus is on density bounds for AP-free sets, not on communication complexity.

3. **Exact EHPS constant**: The survey says Behrend's lower bound was "substantially improved" by EHPS but does not give the exact constant (C = 2√(log₂(24/7)) ≈ 2.667 vs. Behrend's 2√2 ≈ 2.828).

### 3.4 Conjectures in the Peluse Survey

The Peluse survey does not explicitly state numbered conjectures beyond the Erdős-Turán conjecture (Szemerédi's theorem, already proved). The survey is primarily expository, focusing on the technical ideas behind the Leng-Sah-Sawhney result and higher-order Fourier analysis.

The survey does not contradict any of the seven conjectures in final_report.md's Section 8.

### 3.5 Open Problems Noted in the Survey

The Peluse survey implicitly identifies the following open problems (paraphrased):
1. Determine whether r_3(N) behaves like N · exp(-c √(log N)) (Behrend) or is smaller.
2. Obtain quasi-polynomial bounds for r_4(N).
3. Determine optimal constants in Leng-Sah-Sawhney's k≥5 bounds.
4. Whether the Gowers U^s[N] inverse theorem has Behrend-type bounds.

These overlap with our seven conjectures but are stated less precisely.

---

## Section 4: Verified Claims

### 4.1 Raghavan Bound — CONFIRMED ✅

**Claimed:** r_3(N) ≤ N·exp(−c(log N)^{1/6}/log log N)

**Verified:** arXiv:2603.27045 abstract reads:
> "We prove that if A ⊂ {1,...,N} has no nontrivial three-term arithmetic progressions, then |A| ≤ exp(−c log(N)^{1/6} log log(N)^{−1})N for some absolute constant c > 0."

The bound is N · exp(−c · (log N)^{1/6} · (log log N)^{−1}), confirming the literature review. The paper was first submitted March 27, 2026 and updated May 18, 2026.

**Method confirmed:** "iterated variant of the sifting argument of Kelley and Meka, as well as an improved bootstrapping argument for Croot-Sisask almost-periodicity due to Bloom and Sisask."

### 4.2 EHPS Bound — INCORRECT IN FINAL REPORT ❌

**Claimed in final_report.md:** r_3(N) ≥ N·exp(−C(log N)^{1−ε}) for all ε > 0

**Actual bound (verified from arXiv:2406.12290 HTML):**
> r₃(N) ≥ N · 2^{−(2√(log₂(24/7)) + o(1)) · √(log₂ N)}

where C = 2√(log₂(24/7)) ≈ 2.667, improving Behrend's 2√2 ≈ 2.828.

This is the same **exp(−c · √(log N)) structure** as Behrend, NOT exp(−C(log N)^{1−ε}). The improvement is strictly in the constant c, making the set size quasipolynomially larger than Behrend's construction.

**The final_report.md's interpretation (line 190)** — that (log N)^{1−ε} < √(log N) when ε > 1/2 makes EHPS a "stronger lower bound" — is based on a mischaracterization. EHPS does not produce a bound of the form exp(−(log N)^{1−ε}).

### 4.3 Kelley–Lyu Result — LARGELY CONFIRMED ✅ (with date clarification)

**Claimed:** Kelley–Lyu (arXiv:2505.01587, June 2026) achieves exponent 1/2 in communication complexity

**Verified:** The paper by Zander Kelley and Xin Lyu achieves Ω((log N)^{1/2}) lower bound for 3-player NOF communication complexity, improving over the prior Ω((log N)^{1/3}) from Kelley-Lovett-Meka. 

**The abstract confirms** the achievement is for communication complexity, not for arithmetic progressions directly: "We show a stronger Ω(log^{1/2}(N)) lower bound for their construction."

**Date clarification:** First submitted **May 2, 2025** (not June 2026). The June 2026 date in the final report refers to the latest revision (June 11, 2026). The original paper is a May 2025 preprint.

**No direct implication for r_3(N):** The paper explicitly does not transfer the sifting improvement to arithmetic progressions. The connection is that the sifting argument is the same type as Kelley-Meka, so the result is suggestive, but no theorem is proved about r_3(N).

---

## Section 5: Confirmed Gaps

The following remain open as of June 21, 2026:

1. **No improvement beyond Raghavan (1/6 exponent)**: The sifting hierarchy suggests the next step might be exponent 1/3 (next term in arithmetic sequence 1/12, 1/9, 1/6, ...). No such paper exists yet.

2. **No Kelley–Lyu transfer to arithmetic progressions**: The sifting improvement in communication complexity has not been applied to yield a better bound on r_3(N). This is a concrete open task.

3. **No improvement to EHPS lower bound constant**: The constant C = 2√(log₂(24/7)) ≈ 2.667 in the EHPS improvement over Behrend (2√2 ≈ 2.828) has not been improved further. The "Behrend constant" gap (true value unknown) remains.

4. **r_4(N) stuck at Green–Tao 2017**: No quasi-polynomial bound for r_4(N) exists. This remains one of the most important open problems in the area.

5. **k ≥ 5 Leng–Sah–Sawhney bounds**: The exp(−(log log N)^{c_k}) bound for k ≥ 5 is unchallenged. The constant c_k is not yet optimal.

6. **No Lean 4 / Mathlib formalization of new bounds**: The Lean formalization in the project (Szemerédi statement and Behrend construction) has not been extended to Kelley–Meka, Raghavan, or EHPS bounds in Mathlib. No external paper doing this was found.

7. **The Behrend gap**: Whether r_3(N) ~ N · exp(−c · √(log N)) (the conjectured optimal form) is not resolved. All upper bounds remain far from this form (exponent 1/6 vs. 1/2 in the (log N) exponent).

---

## Section 6: Recommendation

### Priority 1 — REQUIRED CORRECTION to final_report.md

**Correct the EHPS lower bound statement throughout final_report.md.** The current description:
```
r_3(N) ≥ N · exp(-C(log N)^{1−ε}) for all ε > 0
```
must be replaced with:
```
r_3(N) ≥ N · 2^{-(2√(log₂(24/7)) + o(1)) · √(log₂ N)}
≈ N · exp(-2√(log(24/7)) · √(log N))   [with 2√(log(24/7)) ≈ 1.848]
```
This is a constant improvement over Behrend's N · 2^{-(2√2 + o(1)) · √(log₂ N)}, where 2√2 ≈ 2.828.

The explanation at line 190 ("(log N)^{1−ε} < √(log N) for large N when ε > 1/2") is also wrong and should be replaced with: "The EHPS improvement is in the coefficient of √(log₂ N) in the exponent, from 2√2 (Behrend) to 2√(log₂(24/7)). The ratio of EHPS to Behrend is exp((2√2 − 2√(log₂(24/7))) · √(log₂ N) · log 2) ≈ exp(0.094 · √(log N)), which is quasipolynomial."

The **gap description** should also be updated: both bounds are now N · exp(−c(log N)^β) with β_upper = 1/6 (Raghavan) and β_lower = 1/2 (EHPS/Behrend). The gap is between β = 1/6 and β = 1/2.

### Priority 2 — Update Kelley–Lyu Description

The final report should note: "arXiv:2505.01587 was first posted May 2025 and revised June 2026." This is a technical citation correction, not a substantive change.

### Priority 3 — Note Peluse Survey Limitations

The Peluse survey (arXiv:2509.22962) provides an excellent exposition of the Leng–Sah–Sawhney result but is superseded for k=3 bounds by Raghavan (2026). The survey's value is its clear technical exposition, not its statement of the most current bounds.

The Peluse survey's open problem discussion should be used to verify that our seven conjectures are not inconsistent with expert assessment. The survey is consistent with our conjectures.

### Priority 4 — Literature Review Table Update

The literature review table for k=3 lower bounds (Section 4.1 of final_report.md) should add:
- 2024 Hunter (arXiv:2401.16106): "Develops EHPS ideas; first quasipolynomial improvement to Behrend" — this is a distinct companion paper to EHPS (2406.12290)

### Not Required

No addition is needed to the k=4 or k≥5 sections — no new papers were found.

No addition is needed for Lean/Mathlib formalization — no external work found.

---

## Summary Table

| Item | Status | Action Required |
|------|--------|----------------|
| Raghavan 2026 bound | ✅ Confirmed | None |
| EHPS lower bound form | ❌ Wrong in final_report | **CORRECT** description and gap analysis |
| Kelley-Lyu date | ⚠️ Partly wrong (May 2025, not June 2026) | Minor citation fix |
| Peluse survey coverage | ✅ Identified gaps | Add note that survey predates Raghavan |
| New papers Apr-Jun 2026 | ✅ None found for r_k(N) directly | None |
| r_4(N) new results | ✅ None found | None |
| k≥5 new results | ✅ None found | None |
| Lean formalization | ✅ None external found | None |
| Van der Waerden super-exp (2606.02541) | ℹ️ Found; tangential | Add to "related results" if desired |

---

## References for This Report

All arXiv papers verified through arXiv.org as of 2026-06-21:

- [arXiv:2603.27045] Raghavan, "Improved Bounds for 3-Progressions" (Mar 2026, updated May 2026)
- [arXiv:2406.12290] Elsholtz, Hunter, Proske, Sauermann, "Improving Behrend's construction" (Jun 2024)
- [arXiv:2401.16106] Hunter, "New lower bounds for r_3(N)" (Jan 2024, updated Jul 2024)
- [arXiv:2505.01587] Kelley, Lyu, "More efficient sifting for grid norms" (May 2025, updated Jun 2026)
- [arXiv:2509.22962] Peluse, "Finding arithmetic progressions in dense sets of integers" (Sep 2025)
- [arXiv:2603.09281] Teräväinen, Wang, "On the Green-Tao theorem for sparse sets" (Mar 2026)
- [arXiv:2606.02312] Chow, Prendiville, Vazquez, "Arithmetic regularity as an alternative to transference" (Jun 2026)
- [arXiv:2606.04016] Ergezer, "Witness-split + window-cardinality refinement for r_3(N)" (Jun 2026)
- [arXiv:2605.13628] Conlon, Fox, Pham, "Arithmetic progressions with restricted differences" (May 2026)
- [arXiv:2606.02541] [Authors unknown in search], "Three-color van der Waerden numbers grow super-exponentially" (Jun 2026)
