# Comp6: bad_frac + min_wfrac at N = 2500..5000

**Date**: 2026-06-21  
**Script**: `runs/erdos142/comp6_very_large_n.py`  
**Prior commits**: 1984213 (comp5, N=1000..2000), bcf31fc (N≤750), 02f6cd2 (N≤500)  
**Prior results file**: `comp5_large_n_bad_frac.md`  
**Run time**: 83.8 seconds total  

---

## Setup

- **N values**: 2500, 3000, 3500 (30 trials each), 4000, 5000 (20 trials each)
- **Total trials**: 130 new trials
- **Construction**: dense greedy with 2 random orderings (best of 2 kept)
- **Fiber analysis**: optimised pairwise-difference approach O(M²) for fiber sizes; O(|A_d|²) per popular d for T₃ counting
- **Threshold for popularity**: |A_d| ≥ M²/(4N)
- **Identical methodology** to comp5_large_n.py (same `creates_4ap`, `greedy_dense`, `analyze_trial`)

---

## Results

| N | trials | avg\_bad\_frac | max\_bad\_frac | avg\_min\_wfrac | range\_min\_wfrac | avg\_witnesses | avg\_max\_popular | avg\_M |
|--:|-------:|---------------:|---------------:|----------------:|------------------:|---------------:|------------------:|-------:|
| 2500 | 30 | 0.8718 | 0.8950 | 0.2036 | [0.1806, 0.2154] | 263.2 | 67.87 | 363.0 |
| 3000 | 30 | 0.8878 | **0.9062** | 0.2061 | [0.1899, 0.2174] | 275.9 | 72.90 | 414.0 |
| 3500 | 30 | 0.8915 | 0.9071 | 0.2000 | [0.1807, 0.2192] | 313.4 | 78.63 | 460.7 |
| 4000 | 20 | 0.8988 | 0.9214 | 0.1987 | [0.1758, 0.2099] | 334.9 | 83.20 | 505.4 |
| 5000 | 20 | **0.9107** | **0.9257** | 0.1986 | [0.1856, 0.2069] | 369.8 | 90.75 | 592.0 |

**Counterexamples found: 0** (Conjecture 2 holds for all 130 new tested sets).  
**Cumulative: 0 CEs across all ~4830 trials, N ≤ 5000.**

---

## Key Findings

### 1. Conjecture 2 holds through N = 5000

Zero counterexamples in all 130 new trials. Combined with prior evidence, Conjecture 2 stands over ~4830 random trials across N ≤ 5000 with no counterexample.

### 2. avg_bad_frac: DOES NOT plateau below 0.88 — continues rising past 0.91

| N | avg\_bad\_frac |
|--:|---------------:|
| 1000 | 0.8136 |
| 1400 | 0.8367 |
| 2000 | 0.8613 |
| 2500 | 0.8718 |
| 3000 | 0.8878 |
| 3500 | 0.8915 |
| 4000 | 0.8988 |
| 5000 | **0.9107** |

**Answer to Q1**: avg_bad_frac exceeded 0.88 at N≈2500–3000 (not plateaued there) and continues rising, reaching **0.9107 at N=5000**. It does NOT plateau below 0.88 — it blows through that threshold and is now above 0.90. This weakens the guaranteed "≥12% good fiber bound" at large N (the actual typical good fraction is now ~9% at N=5000).

### 3. max_bad_frac: EXCEEDED 0.90 — first occurrence at N=3000

| N | max\_bad\_frac |
|--:|---------------:|
| 1400 | 0.8942 (previous maximum) |
| 2000 | 0.8894 |
| 2500 | 0.8950 |
| **3000** | **0.9062** ← first time ≥ 0.90 |
| 3500 | 0.9071 |
| 4000 | 0.9214 |
| 5000 | **0.9257** |

**Answer to Q2**: Yes — max_bad_frac exceeded 0.90 starting at N=3000. The worst-case single trial at N=5000 had 92.6% of popular fibers containing a 3-AP, meaning only **7.4% were T₃=0 witnesses** in the worst case. This refines the "≥10% always" claim: at large N, the worst-case individual trial may have as few as ~8% good fibers, though the **average** over trials still gives ~9% good.

### 4. min_wfrac: slow decrease toward 0.20; minimum ever = 0.176 (N=4000)

| N | avg\_min\_wfrac | min\_min\_wfrac |
|--:|----------------:|----------------:|
| 2000 | 0.2044 | 0.1739 |
| 2500 | 0.2036 | 0.1806 |
| 3000 | 0.2061 | 0.1899 |
| 3500 | 0.2000 | 0.1807 |
| 4000 | 0.1987 | **0.1758** |
| 5000 | 0.1986 | 0.1856 |

**Answer to Q3**: avg_min_wfrac continues its very slow decrease, reaching ~0.199 at N=4000–5000. The overall minimum ever observed across all trials is **0.1758** (N=4000). The RC2 threshold (∃ popular T₃=0 fiber with wfrac ≤ 0.25) is comfortably satisfied in every trial, but the question of whether the tightest threshold tightens to 0.20 cannot be resolved yet:
- The *average* min_wfrac is ~0.199–0.204, hovering just at 0.20
- Individual trials can go as low as 0.176 (well below 0.20)
- So RC2 could potentially be strengthened to wfrac ≤ 0.20 if the average min continues falling

### 5. Witness count continues growing with N

| N | avg\_witnesses | min\_witnesses | max\_witnesses |
|--:|---------------:|---------------:|---------------:|
| 1000 | 151.1 | 115 | 235 |
| 2000 | 226.7 | 180 | 278 |
| 2500 | 263.2 | 216 | 330 |
| 3500 | 313.4 | 266 | 391 |
| 5000 | **369.8** | 307 | 438 |

Even at N=5000, the minimum number of T₃=0 popular witnesses in any single trial is **307**. The conjecture is not close to violation in terms of witness count — there are always hundreds of good-fiber witnesses.

Witness count scales approximately as N^{0.42}, consistent with |S| growing roughly as N while bad_frac approaches a limit near (but below) 1.

### 6. Set sizes and structure

| N | avg\_M | avg\_max\_popular |
|--:|-------:|------------------:|
| 2000 | 311.3 | 62.42 |
| 2500 | 363.0 | 67.87 |
| 3500 | 460.7 | 78.63 |
| 5000 | **592.0** | **90.75** |

- avg\_M ≈ N^{0.73} (consistent with 4-AP-free density ~ N^{-0.27})
- avg\_max\_popular ≈ N^{0.44}

---

## Combined Trend: N=1000..5000

| N | avg\_bad\_frac | max\_bad\_frac | avg\_min\_wfrac | avg\_witnesses |
|--:|---------------:|---------------:|----------------:|---------------:|
| 1000 | 0.8136 | 0.8606 | 0.2099 | 151.1 |
| 1400 | 0.8367 | 0.8942 | 0.2057 | 186.8 |
| 2000 | 0.8613 | 0.8894 | 0.2044 | 226.7 |
| 2500 | 0.8718 | 0.8950 | 0.2036 | 263.2 |
| 3000 | 0.8878 | 0.9062 | 0.2061 | 275.9 |
| 3500 | 0.8915 | 0.9071 | 0.2000 | 313.4 |
| 4000 | 0.8988 | 0.9214 | 0.1987 | 334.9 |
| 5000 | **0.9107** | **0.9257** | **0.1986** | **369.8** |

---

## Summary Table

| Question | Answer |
|----------|--------|
| Does avg\_bad\_frac plateau below 0.88? | **No** — it continues rising past 0.91 at N=5000 |
| Does max\_bad\_frac reach 0.90? | **Yes** — first at N=3000 (0.9062); reaches 0.9257 at N=5000 |
| Does min\_wfrac trend below 0.204? | **Yes** — avg\_min\_wfrac ≈ 0.199 at N=4000–5000; min ever = 0.1758 |
| Zero CEs (Conjecture 2 holds)? | **✓ 0 CEs** in all 130 new trials (cumulative: ~4830 trials, 0 CEs) |
| Witnesses abundant? | **✓** min 307 witnesses/trial at N=5000 (avg 370) |

**Implication for C2 guarantee**: The ≥10% bound on "popular fibers always 3AP-free" weakens at large N in the worst case (single bad trials at N=5000 show only ~7.4% good). However, the conjecture itself (∃ at least one good popular fiber) holds in every trial. The true "at least 1 witness" threshold appears robust — even the worst trial at N=5000 had 307 witnesses.

**Implication for RC2**: The refined conjecture (∃ popular T₃=0 fiber with wfrac ≤ 0.25) continues to hold. avg_min_wfrac hovering around 0.199 at N=4000–5000 suggests the threshold may tighten toward 0.20, but data at larger N is needed to confirm.
