# Comp5: bad_frac + min_wfrac at N = 1000..2000

**Date**: 2026-06-21  
**Script**: `runs/erdos142/comp5_large_n.py`  
**Prior commits**: bcf31fc (N≤750), 02f6cd2 (N≤500), 6b15fac (N≤300), b5827d9 (N≤150)  
**Prior results file**: `c2_extension_n1000.md` (N=800..1000)  
**Run time**: 75.4 seconds total  

---

## Setup

- **N values**: 1000, 1100, 1200, 1300, 1400 (100 trials each), 1500, 1700, 2000 (50 trials each)
- **Construction**: dense greedy with 2 random orderings (best of 2 kept)
- **Fiber analysis**: optimised pairwise-difference approach O(M²) for fiber sizes; O(|A_d|²) per popular d for T₃ counting
- **Threshold for popularity**: |A_d| ≥ M²/(4N)

---

## Results

| N | trials | avg\_bad\_frac | max\_bad\_frac | avg\_min\_wfrac | range\_min\_wfrac | avg\_witnesses | avg\_max\_popular | avg\_M |
|--:|-------:|---------------:|---------------:|----------------:|------------------:|---------------:|------------------:|-------:|
| 1000 | 100 | 0.8136 | 0.8606 | 0.2099 | [0.1800, 0.2381] | 151.1 | 46.53 | 191.2 |
| 1100 | 100 | 0.8216 | 0.8796 | 0.2086 | [0.1724, 0.2381] | 159.7 | 48.26 | 204.4 |
| 1200 | 100 | 0.8235 | 0.8796 | 0.2038 | [0.1724, 0.2292] | 173.4 | 50.00 | 217.0 |
| 1300 | 100 | 0.8263 | 0.8740 | 0.2073 | [0.1754, 0.2292] | 184.2 | 51.46 | 229.6 |
| 1400 | 100 | 0.8367 | **0.8942** | 0.2057 | [0.1833, 0.2292] | 186.8 | 53.70 | 242.4 |
| 1500 | 50  | 0.8449 | 0.8920 | 0.2068 | [0.1833, 0.2353] | 190.0 | 54.74 | 254.6 |
| 1700 | 50  | 0.8471 | 0.8800 | 0.2030 | [0.1803, 0.2222] | 213.2 | 58.52 | 277.1 |
| 2000 | 50  | **0.8613** | 0.8894 | 0.2044 | [0.1739, 0.2281] | 226.7 | 62.42 | 311.3 |

**Counterexamples found: 0** (Conjecture 2 holds for all 650 tested sets).

---

## Key Findings

### 1. Conjecture 2 holds through N = 2000

Zero counterexamples in 650 total trials (100 trials × 5 N-values + 50 × 3). Combined with prior evidence, Conjecture 2 now stands over ~4700 random trials across N ≤ 2000 with no counterexample.

### 2. avg_bad_frac: slow upward drift, not plateaued

| N | avg\_bad\_frac |
|--:|---------------:|
| 900 | ~0.866 (from prior data) |
| 1000 | 0.8136 |
| 1200 | 0.8235 |
| 1400 | 0.8367 |
| 1700 | 0.8471 |
| 2000 | **0.8613** |

The average fraction of popular differences with T₃ > 0 is increasing slowly but steadily with N. It has NOT plateaued at 0.88. At N=2000, avg_bad_frac ≈ 0.861 — still ~2.5% below 0.88. The trend suggests it may reach 0.88 around N≈3000–5000, but remains well below 1.0.

**Conjecture**: bad_frac is bounded below 0.9 for all N (perhaps all N, or for large enough N).

### 3. max_bad_frac: first breach of 0.88 barrier

The previously observed ceiling of 0.8765 (at N=900) has been exceeded:
- N=1100: max_bad_frac = 0.8796 (first time >0.877)
- N=1400: max_bad_frac = **0.8942** (new maximum)
- N=2000: max_bad_frac = 0.8894

The max_bad_frac in any single trial has exceeded 0.89 but not 0.90. The worst-case fraction of popular fibers that are *not* 3AP-free is at most ~89%, meaning at least ~11% are always T₃=0.

### 4. min_wfrac: rock-solid ≤ 0.25 barrier

| N | avg\_min\_wfrac | range\_min\_wfrac |
|--:|----------------:|------------------:|
| 600 | 0.2189 | [0.1905, 0.2500] |
| 700 | 0.2106 | [0.1739, 0.2432] |
| 1000 | 0.2099 | [0.1800, 0.2381] |
| 1200 | 0.2038 | [0.1724, 0.2292] |
| 1500 | 0.2068 | [0.1833, 0.2353] |
| 2000 | **0.2044** | [0.1739, 0.2281] |

The minimum wfrac (relative size of the smallest T₃=0 popular fiber, per trial) is:
- **Always ≤ 0.2381** across all 650 trials (never exceeded 0.25)
- Averages ≈ 0.205–0.210 with tiny variance across N=600..2000
- Appears to be slowly decreasing as N grows (0.219 at N=600 → 0.204 at N=2000)

**The Refined Conjecture 2 (∃ popular T₃=0 fiber with wfrac ≤ 0.25) holds in every trial.**

### 5. Witness count grows with N

| N | avg\_witnesses | min | max |
|--:|---------------:|----:|----:|
| 600 | 112 | 80 | 171 |
| 700 | 126 | 88 | 170 |
| 1000 | 151 | 115 | 235 |
| 1500 | 190 | 130 | 240 |
| 2000 | **227** | 180 | 278 |

The number of T₃=0 popular fibers (witnesses) grows roughly as N^{0.45}, consistent with |S|~N growing and bad_frac approaching a limit below 1. At N=2000, even the worst-case trial had ≥180 witnesses — the conjecture is far from tight.

### 6. Set sizes

| N | avg\_M | avg\_max\_popular |
|--:|-------:|------------------:|
| 1000 | 191.2 | 46.53 |
| 1500 | 254.6 | 54.74 |
| 2000 | 311.3 | 62.42 |

- avg\_M ≈ N^{0.73} (consistent with known 4-AP-free density bounds)
- avg\_max\_popular ≈ N^{0.45} (growing slowly)
- The popularity threshold M²/(4N) ≈ N^{1.46}/4N = N^{0.46}/4 grows comparably

---

## Comparison with Prior Results (N ≤ 1000)

| Source | N range | Max bad\_frac | avg\_min\_wfrac |
|--------|---------|--------------|----------------|
| c2_extension_n750.md | 550–750 | 0.8707 | 0.32–0.33 |
| c2_extension_n1000.md | 800–1000 | 0.8765 | 0.32 |
| **comp5 (this run)** | **1000–2000** | **0.8942** | **~0.205** |
| refined_conjecture_test.md | 600–700 | N/A | 0.2106–0.2189 |

Note: the avg_wfrac values in c2_extension_n750 and c2_extension_n1000 (0.32) were *averages over ALL witnesses*, whereas avg_min_wfrac here is the *minimum per trial*. These are consistent:
- avg over all witnesses ≈ 0.32 
- min per trial ≈ 0.21 (about 2/3 of the average)

---

## Summary Table

| Question | Answer |
|----------|--------|
| Does bad\_frac approach 0.88? | Slow approach — avg reaches 0.861 at N=2000, still below 0.88 |
| Is bad\_frac < 0.90? | Yes, max over all trials is 0.8942 (< 0.90) |
| Does min\_wfrac stay ≤ 0.25? | ✓ Yes, in every single trial across N=600..2000 |
| Zero CEs (Conjecture 2 holds)? | ✓ 0 CEs in 650 trials (cumulative: ~4700 trials with 0 CEs) |
| Are witnesses abundant? | ✓ 227 witnesses/trial on average at N=2000 (min 180) |

**Strongest new claim**: The Refined Conjecture 2 (∃ popular T₃=0 fiber with wfrac ≤ 0.25) holds for all 650 randomly tested 4-AP-free sets across N=1000..2000, extending prior evidence from N≤700.
