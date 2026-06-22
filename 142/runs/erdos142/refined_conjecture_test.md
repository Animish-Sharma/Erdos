# Refined Conjecture 2 Test: Is There ALWAYS a Small T₃=0 Witness?

**Date**: 2026-06-21  
**Script**: `runs/erdos142/c2_extension_n1000_refined.py` (Task 2)  
**N tested**: 600, 700  
**Trials per N**: 100  
**Run time (Task 2)**: 6.1 seconds  

---

## Background

Conjecture 2 (verified N ≤ 1000) states: ∃ popular d with T₃(A_d) = 0.

The **Refined Conjecture 2** asks: is the witnessing fiber always *small* relative to the maximum popular fiber? Specifically:

**Refined C2**: ∃ popular d with T₃(A_d) = 0 AND |A_d| / max_popular_size ≤ 0.40

This would be a stronger statement pinning down WHERE the 3AP-free witnesses live in the fiber-size spectrum.

---

## Setup

For each trial: generate one 4-AP-free set A (greedy, 2 restarts). Compute ALL popular d's with T₃(A_d) = 0, record their **wfrac** = |A_d| / max_{d'∈S}|A_{d'}|.

Check per trial: is the minimum wfrac over all T₃=0 witnesses ≤ 0.40?

---

## Results

### N = 600

- **100 trials, 0 C2-CEs** (all trials satisfy Conjecture 2)
- **Refined-CE (all witnesses wfrac > 0.40): 0/100 (0.0%)**
- Per-trial minimum wfrac: mean = **0.2189**, range = [0.1905, 0.2500]
- ALL witness wfracs: mean = 0.3341, median = 0.3143, stdev = 0.1004
- Number of witnesses per trial: avg = 112.0 (range: 80..171)

**wfrac distribution (all 11,204 T₃=0 witnesses):**

| wfrac bin | Count | Fraction |
|-----------|-------|---------|
| ≤ 0.10 | 0 | 0.0% |
| ≤ 0.20 | 102 | 0.9% |
| ≤ 0.30 | 4,936 | 44.1% |
| ≤ 0.40 | 3,477 | 31.0% |
| ≤ 0.50 | 1,762 | 15.7% |
| ≤ 0.60 | 712 | 6.4% |
| ≤ 0.70 | 189 | 1.7% |
| ≤ 0.80 | 24 | 0.2% |
| ≤ 0.90 | 2 | 0.0% |
| ≤ 1.00 | 0 | 0.0% |

**Cumulative**: 75% of witnesses have wfrac ≤ 0.40.

### N = 700

- **100 trials, 0 C2-CEs**
- **Refined-CE (all witnesses wfrac > 0.40): 0/100 (0.0%)**
- Per-trial minimum wfrac: mean = **0.2106**, range = [0.1739, 0.2432]
- ALL witness wfracs: mean = 0.3230, median = 0.3000, stdev = 0.0974
- Number of witnesses per trial: avg = 125.9 (range: 88..170)

**wfrac distribution (all 12,594 T₃=0 witnesses):**

| wfrac bin | Count | Fraction |
|-----------|-------|---------|
| ≤ 0.10 | 0 | 0.0% |
| ≤ 0.20 | 255 | 2.0% |
| ≤ 0.30 | 5,882 | 46.7% |
| ≤ 0.40 | 3,895 | 30.9% |
| ≤ 0.50 | 1,763 | 14.0% |
| ≤ 0.60 | 637 | 5.1% |
| ≤ 0.70 | 142 | 1.1% |
| ≤ 0.80 | 19 | 0.2% |
| ≤ 0.90 | 1 | 0.0% |
| ≤ 1.00 | 0 | 0.0% |

**Cumulative**: 79.5% of witnesses have wfrac ≤ 0.40.

---

## Key Findings

### 1. Refined Conjecture 2 holds with 0 failures

In 200 trials across N=600 and N=700, the minimum T₃=0 witness wfrac was ALWAYS ≤ 0.25 (well below the 0.40 threshold). The Refined Conjecture 2 holds empirically with zero failures.

### 2. The minimum witness wfrac is remarkably stable

| N | Mean min_wfrac | Range |
|---|---------------|-------|
| 600 | 0.2189 | [0.1905, 0.2500] |
| 700 | 0.2106 | [0.1739, 0.2432] |

The per-trial minimum wfrac is tightly concentrated around 0.21. The variance is small — in every trial, there exists a T₃=0 popular fiber at roughly 1/5 of the maximum popular fiber size.

### 3. Witnesses cluster in [0.20, 0.40]

The T₃=0 witness distribution is unimodal, peaked in the 0.20–0.40 range:
- Nearly 75–80% of all T₃=0 popular fibers have wfrac ≤ 0.40
- Very few witnesses are small (wfrac < 0.20) or large (wfrac > 0.60)
- **No witness ever has wfrac = 1.0** (the argmax is never 3AP-free for large N — consistent with comp4 finding)

### 4. ~112–126 witnesses per trial (very abundant)

There are typically 100+ 3AP-free popular fibers per set. The conjecture is not at all "tight" — it's not a single needle-in-haystack witness but a broad concentration of 3AP-free fibers in the medium-size range.

### 5. Proposed Refined Conjecture 2

Based on this evidence:

**Empirical Refined C2**: For every 4-AP-free A ⊆ {1,...,N} with |A|=M ≥ 2, there exists a popular d such that:
1. T₃(A_d) = 0 (fiber is fully 3-AP-free), AND  
2. |A_d| ≤ 0.40 × max_{d'∈S}|A_{d'}|   (fiber is not the most popular one)

**Stronger version** (if true): |A_d| ≤ 0.25 × max_{d'∈S}|A_{d'}| (since min_wfrac is always ≤ 0.25 in our data).

---

## Comparison with Prior Work

From **comp4 analysis** (P9-rev CEs specifically):
- In P9-rev CEs, witness size / max_popular ≈ 0.46–0.59 (medium-to-large)
- This differs from the overall avg_wfrac ≈ 0.33 because in P9-rev CEs, the argmin is excluded

From **c2_extension_n750** (all trials):
- avg_wfrac ≈ 0.33 (consistent with this run's 0.32–0.33)

From **this run** (full distribution):
- The distribution is concentrated at 0.20–0.40, with a mode around 0.25–0.35
- **min_wfrac per trial ≈ 0.21** suggests a natural scale: the "small quarter" of popular fibers tend to be 3AP-free

---

## Summary

| Claim | N | Trials | Status |
|-------|---|--------|--------|
| Refined C2 (∃ T₃=0 with wfrac ≤ 0.40) | 600, 700 | 200 | ✓ 0 failures |
| Refined C2 (∃ T₃=0 with wfrac ≤ 0.25) | 600, 700 | 200 | ✓ 0 failures (min_wfrac ≤ 0.25 always) |
| Mean witnesses per trial | 600, 700 | 200 | ~119 (abundant) |
| Most witnesses in [0.20, 0.40] | 600, 700 | 200 | ✓ 75% of witnesses |
| argmax fiber (wfrac=1.0) is 3AP-free | 600, 700 | 200 | ✗ Never observed |

**The Refined Conjecture 2 is strongly supported**: the C2 witness is not just "some popular fiber" but reliably a fiber in the lower quarter of the popular-fiber-size spectrum (wfrac ≈ 0.21 on average). This is a much tighter structural characterization than the original Conjecture 2.
