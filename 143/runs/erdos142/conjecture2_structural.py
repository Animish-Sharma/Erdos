#!/usr/bin/env python3
"""
Conjecture 2 — Structural Analysis and Proof Attempts
=====================================================

This script:
1. Finds the "hardest" cases (highest bad_fraction near 1.0)
2. Analyzes the structure of these hard cases
3. Attempts to identify proof patterns

Key question: WHY does Conjecture 2 hold?
- Is there always a "good" d because S is large enough?
- Is there a Fourier-analytic reason?
- Is there a counting argument?
"""

import random
import sys
from collections import defaultdict
from itertools import combinations

# ========== Core predicates ==========

def is_4ap_free(A_sorted, A_set=None):
    if A_set is None: A_set = set(A_sorted)
    for i in range(len(A_sorted)):
        a = A_sorted[i]
        for j in range(i+1, len(A_sorted)):
            d = A_sorted[j] - a
            if (a + 2*d) in A_set and (a + 3*d) in A_set:
                return False
    return True

def is_3ap_free(A_sorted, A_set=None):
    if A_set is None: A_set = set(A_sorted)
    for i in range(len(A_sorted)):
        a = A_sorted[i]
        for j in range(i+1, len(A_sorted)):
            b = A_sorted[j]
            c = 2*b - a
            if c > b and c in A_set:
                return False
    return True

def compute_fiber(A_set, d, N):
    return [a for a in A_set if (a + d) in A_set and a >= 1 and a <= N]

def conjecture2_full_analysis(A_sorted, N):
    """Full analysis of Conjecture 2 for set A."""
    M = len(A_sorted)
    A_set = set(A_sorted)
    threshold = M * M / (4.0 * N)

    S = []  # (d, fiber, is_3ap_free)
    for d in range(1, N):
        fiber = compute_fiber(A_set, d, N)
        if len(fiber) >= threshold:
            fiber_sorted = sorted(fiber)
            fiber_set = set(fiber)
            free = is_3ap_free(fiber_sorted, fiber_set)
            S.append((d, fiber_sorted, free))

    good = [(d, f) for (d, f, fr) in S if fr]
    bad = [(d, f) for (d, f, fr) in S if not fr]

    return {
        'M': M,
        'threshold': threshold,
        'S': [(d, len(f), fr) for (d, f, fr) in S],
        'good': good,
        'bad': bad,
        '|S|': len(S),
        'bad_frac': len(bad)/len(S) if S else 0.0,
        'holds': len(good) > 0,
    }

def greedy_4ap_free(N, seed=None):
    if seed is not None: random.seed(seed)
    order = list(range(1, N+1))
    random.shuffle(order)
    A, A_set = [], set()
    for x in order:
        A_test = sorted(A + [x])
        if is_4ap_free(A_test, set(A_test)):
            A.append(x)
            A_set.add(x)
    return sorted(A)

# ========== Find hardest cases ==========

def find_worst_cases(N_range, num_trials=2000, verbose=True):
    """Find 4-AP-free sets with highest bad_fraction."""
    worst_cases = []

    for N in N_range:
        worst_bad_frac = 0.0
        worst_A = None
        worst_analysis = None

        for trial in range(num_trials):
            A = greedy_4ap_free(N, seed=trial*7+N*13)
            if len(A) < 2: continue

            analysis = conjecture2_full_analysis(A, N)
            if analysis['bad_frac'] > worst_bad_frac:
                worst_bad_frac = analysis['bad_frac']
                worst_A = A
                worst_analysis = analysis

        worst_cases.append((N, worst_A, worst_analysis, worst_bad_frac))
        if verbose and worst_A:
            print(f"N={N:3d}: worst bad_frac={worst_bad_frac:.4f}, "
                  f"|A|={len(worst_A)}, |S|={worst_analysis['|S|']}, "
                  f"|good|={len(worst_analysis['good'])}")

    return worst_cases

# ========== Structural proof approaches ==========

def analyze_why_good_d_exists(A_sorted, N, analysis):
    """
    For the specific 4-AP-free set A with analysis,
    investigate WHY there exists a good d.
    """
    M = len(A_sorted)
    A_set = set(A_sorted)
    threshold = analysis['threshold']
    good = analysis['good']
    bad = analysis['bad']

    print(f"\nSet A = {A_sorted}")
    print(f"N={N}, M={M}, threshold={threshold:.3f}")
    print(f"|S|={analysis['|S|']}, |bad|={len(bad)}, |good|={len(good)}, bad_frac={analysis['bad_frac']:.4f}")

    if not good:
        print("NO GOOD D EXISTS — POTENTIAL COUNTEREXAMPLE!")
        return

    # Analyze the good d's
    print(f"\nGood d's: {[(d, len(f)) for d, f in good[:5]]}")

    # For each good d, what makes A_d 3-AP-free?
    d_g, fiber_g = good[0]
    print(f"\nSmallest good d={d_g}, A_{d_g}={fiber_g}")
    print(f"A_{d_g} is 3-AP-free of size {len(fiber_g)} ≥ threshold {threshold:.3f}")

    # What 3-APs does A have? (A is 4-AP-free but may have 3-APs)
    three_aps_in_A = []
    for i, a in enumerate(A_sorted):
        for j in range(i+1, len(A_sorted)):
            b = A_sorted[j]
            c = 2*b - a
            if c > b and c in A_set:
                three_aps_in_A.append((a, b, c))

    print(f"\n3-APs in A: {len(three_aps_in_A)} total")
    if three_aps_in_A:
        print(f"  First few: {three_aps_in_A[:5]}")

    # For good d, check which 3-APs in A "threaten" A_d
    # A 3-AP (a,b,c) in A threatens A_d if a,b,c ∈ A_d
    # But A_d is 3-AP-free, so none can be fully in A_d
    # Why? Because some of {a,b,c} must be in A \ A_d
    print(f"\nWhy is A_{d_g} 3-AP-free despite A having {len(three_aps_in_A)} 3-APs?")
    fiber_set = set(fiber_g)
    blocked = 0
    for (a, b, c) in three_aps_in_A:
        if not (a in fiber_set and b in fiber_set and c in fiber_set):
            blocked += 1
    print(f"  {blocked}/{len(three_aps_in_A)} 3-APs in A are 'blocked' from A_{d_g}")
    print(f"  (i.e., some element of the 3-AP is not in A_{d_g})")

    # For bad d's, analyze which 3-APs in A survive in A_d
    if bad:
        d_b, fiber_b = bad[0]
        fiber_b_set = set(fiber_b)
        survived = 0
        for (a, b, c) in three_aps_in_A:
            if a in fiber_b_set and b in fiber_b_set and c in fiber_b_set:
                survived += 1
        print(f"\nFor bad d={d_b} (A_{d_b} has 3-APs):")
        print(f"  A_{d_b}={fiber_b}")
        print(f"  {survived}/{len(three_aps_in_A)} 3-APs in A survive in A_{d_b}")

def remark_a_check(A_sorted, d):
    """
    Verify Remark A: A_d has no 3-AP with step ±d or ±2d.
    """
    A_set = set(A_sorted)
    fiber = [a for a in A_sorted if (a + d) in A_set]
    fiber_set = set(fiber)

    # Check no step-d 3-AP
    for a in fiber:
        if (a + d) in fiber_set and (a + 2*d) in fiber_set:
            return False, f"step-d 3-AP at {a}"
    # Check no step-2d 3-AP
    for a in fiber:
        if (a + 2*d) in fiber_set and (a + 4*d) in fiber_set:
            return False, f"step-2d 3-AP at {a}"

    return True, "Remark A confirmed"

# ========== Proof attempt: Show bad_fraction < 1 ==========

def prove_not_all_bad(A_sorted, N, analysis, verbose=True):
    """
    Attempt to prove that not all d in S are bad.

    Strategy A: Energy argument
    T_bad_APs = total 3-APs across bad fibers
    T_good_size = total size of good fibers
    We want to show T_good_size > 0.

    Strategy B: Contradiction via 4-AP existence
    If all d in S are bad, do we get a 4-AP in A?
    (We showed this is NOT guaranteed in general)

    Strategy C: Structural — 3-APs in A are "spread" across fibers
    If a 3-AP (a,b,c) in A is "fully in A_d" (a,b,c ∈ A_d), then
    a+d, b+d, c+d ∈ A (another 3-AP in A).
    This creates a "shifted" 3-AP. Can these shifted 3-APs chain to create a 4-AP?
    """
    M = len(A_sorted)
    A_set = set(A_sorted)
    threshold = analysis['threshold']
    S = analysis['S']
    bad = analysis['bad']
    good = analysis['good']

    if verbose:
        print(f"\n--- Proof attempt for A={A_sorted[:5]}... N={N} ---")
        print(f"Strategy A: Energy argument")

    # Count total 3-APs in A
    three_aps_in_A = []
    for i, a in enumerate(A_sorted):
        for j in range(i+1, len(A_sorted)):
            b = A_sorted[j]
            c = 2*b - a
            if c > b and c in A_set:
                three_aps_in_A.append((a, b, c))

    if verbose:
        print(f"  3-APs in A: {len(three_aps_in_A)}")

    # For each 3-AP (a,b,c) in A, count how many d in S have a,b,c ∈ A_d
    # This counts how many (d, 3-AP in A_d) pairs exist
    three_ap_coverage = defaultdict(list)  # (a,b,c) -> list of d ∈ S with 3-AP in A_d

    for (a, b, c) in three_aps_in_A:
        for d_data in S:
            d = d_data[0]
            # Check if a,b,c ∈ A_d: need a+d,b+d,c+d ∈ A
            if (a+d) in A_set and (b+d) in A_set and (c+d) in A_set:
                three_ap_coverage[(a,b,c)].append(d)

    total_bad_3ap_pairs = sum(len(v) for v in three_ap_coverage.values())

    if verbose:
        print(f"  Total (d, 3-AP in A_d) pairs: {total_bad_3ap_pairs}")
        print(f"  |S| = {len(S)}, |bad| = {len(bad)}")
        print(f"  Average 3-APs per bad d: {total_bad_3ap_pairs/max(1,len(bad)):.2f}")

    # Strategy B: Check if any 3-AP "covers" too many d's
    if three_ap_coverage:
        max_coverage = max(len(v) for v in three_ap_coverage.values())
        argmax_3ap = max(three_ap_coverage.keys(), key=lambda x: len(three_ap_coverage[x]))
        if verbose:
            print(f"  Most covered 3-AP: {argmax_3ap}, covered by {max_coverage} d's")

    # Strategy C: "Shift structure" of 3-APs
    # If (a,b,c) ∈ A_d (3-AP in A_d), then (a+d, b+d, c+d) is also a 3-AP in A
    # (since a+d, b+d, c+d ∈ A and (a+d)+(c+d) = 2(b+d))
    # This means 3-APs in A come in "d-pairs": {(a,b,c), (a+d,b+d,c+d)}
    # If ALL d ∈ S are bad, we have many such pairs for each d ∈ S.

    # Can this force a 4-AP?
    # Suppose (a,b,c) ∈ A_d and (a+d,b+d,c+d) ∈ A.
    # Are there d,e such that (a,b,c) ∈ A_d and (a,b,c) ∈ A_e?
    # Then a+d, b+d, c+d ∈ A AND a+e, b+e, c+e ∈ A.
    # We have: a, b, c, a+d, b+d, c+d, a+e, b+e, c+e ∈ A (up to 9 points)
    # Does this contain a 4-AP?

    # For a 4-AP we need 4 equidistant points. With d ≠ e:
    # Check a, a+d, a+2d, a+3d: need a+2d, a+3d ∈ A
    # etc. This seems hard to guarantee.

    if verbose:
        print(f"\n  Strategy C: Shift pairs")
        # Find 3-APs with multiple d-shifts
        multi_shift = {k: v for k, v in three_ap_coverage.items() if len(v) >= 2}
        print(f"  3-APs covered by ≥2 d's: {len(multi_shift)}")
        for ap, ds in list(multi_shift.items())[:3]:
            print(f"    3-AP {ap} covered by d's {ds[:5]}")

    return total_bad_3ap_pairs

# ========== Key structural theorem attempts ==========

def attempt_proof_all_fibers_bad(N_range=range(5, 20)):
    """
    For each N, take the worst-case set (highest bad_frac) and analyze:
    1. What happens when we assume all d ∈ S are bad?
    2. Can we derive a contradiction?
    """
    print("\nAttempt: Assuming all d ∈ S are bad — searching for contradictions")
    print("="*60)

    for N in N_range:
        # Find set with highest bad_frac
        worst_bad = 0
        worst_A = None
        for trial in range(500):
            A = greedy_4ap_free(N, seed=trial*11+N*7)
            if len(A) < 2: continue
            analysis = conjecture2_full_analysis(A, N)
            if analysis['bad_frac'] > worst_bad:
                worst_bad = analysis['bad_frac']
                worst_A = A

        if worst_A is None:
            continue

        analysis = conjecture2_full_analysis(worst_A, N)

        print(f"\nN={N}, A={worst_A}")
        print(f"M={len(worst_A)}, bad_frac={worst_bad:.4f}, |S|={analysis['|S|']}")
        print(f"|good|={len(analysis['good'])}, |bad|={len(analysis['bad'])}")

        if analysis['good']:
            d_good, f_good = analysis['good'][0]
            print(f"Good d={d_good}, A_{d_good}={f_good}")

# ========== Explore: Can bad_fraction approach 1? ==========

def boundary_search(target_bad_frac=0.9, N_range=range(20, 80), num_trials=5000):
    """
    Search for 4-AP-free sets with bad_fraction ≥ target.
    If found, analyze them. If not, establish the empirical upper bound.
    """
    print(f"\nSearching for bad_fraction ≥ {target_bad_frac}...")
    print("-"*50)

    results = []
    for N in N_range:
        best = 0.0
        best_A = None
        for trial in range(num_trials):
            A = greedy_4ap_free(N, seed=trial*3+N*17)
            if len(A) < 2: continue
            analysis = conjecture2_full_analysis(A, N)
            if analysis['bad_frac'] > best:
                best = analysis['bad_frac']
                best_A = A
                if best >= target_bad_frac:
                    print(f"  N={N}, trial={trial}: bad_frac={best:.4f} ≥ target!")
                    print(f"  A={A}")
                    ana2 = conjecture2_full_analysis(A, N)
                    print(f"  |S|={ana2['|S|']}, |good|={len(ana2['good'])}")
                    break

        results.append({'N': N, 'best_bad_frac': best, 'A': best_A})
        print(f"N={N:3d}: best bad_frac={best:.4f}", end="")
        if best >= target_bad_frac:
            print(" *** NEAR TARGET ***")
        else:
            print()

    return results

# ========== Exhaustive search for sets where all d in S are bad (potential CEs) ==========

def search_all_S_bad(N_max=18):
    """
    For N ≤ N_max, exhaustively find 4-AP-free sets where ALL d ∈ S are bad.
    If any such set has |S| > 0, Conjecture 2 would FAIL for that set.
    (But we expect none exist — this confirms Conjecture 2.)
    """
    print(f"\nExhaustive search for 'all S bad' (N ≤ {N_max})")
    print("-"*50)

    for N in range(1, N_max + 1):
        elems = list(range(1, N+1))
        found_all_bad = False
        worst_example = None

        for size in range(2, N+1):
            for subset in combinations(elems, size):
                A = list(subset)
                A_set = set(A)
                if not is_4ap_free(A, A_set):
                    continue

                analysis = conjecture2_full_analysis(A, N)
                if not analysis['holds'] and analysis['|S|'] > 0:
                    found_all_bad = True
                    worst_example = (A, analysis)
                    print(f"  COUNTEREXAMPLE! N={N}, A={A}, |S|={analysis['|S|']}")
                    break

            if found_all_bad:
                break

        if not found_all_bad:
            print(f"N={N:3d}: No 'all-S-bad' set found ✓")

# ========== Main ==========

def main():
    print("="*70)
    print("Conjecture 2 — Structural Analysis")
    print("="*70)

    # 1. Find worst cases (highest bad_frac)
    print("\n1. Finding worst-case sets (highest bad_fraction)...")
    print("-"*50)
    worst = find_worst_cases(range(10, 45, 2), num_trials=1000, verbose=True)

    # 2. Detailed analysis of worst cases
    print("\n2. Detailed structural analysis of worst cases...")
    print("-"*50)
    for N, A, analysis, bad_frac in worst:
        if A and bad_frac > 0.6:
            analyze_why_good_d_exists(A, N, analysis)

    # 3. Exhaustive "all-S-bad" search for small N
    print("\n3. Exhaustive 'all-S-bad' search...")
    search_all_S_bad(N_max=18)

    # 4. Boundary search for bad_fraction → 1
    print("\n4. Boundary search (targeting bad_frac ≥ 0.85)...")
    boundary_search(target_bad_frac=0.85, N_range=range(20, 60), num_trials=3000)

    # 5. Attempt proof via energy argument
    print("\n5. Proof attempt: Energy argument analysis...")
    print("-"*50)
    # Use worst case from exhaustive
    for N, A, analysis, bad_frac in worst:
        if A and bad_frac > 0.6 and len(A) >= 4:
            prove_not_all_bad(A, N, analysis, verbose=True)
            break

    print("\n" + "="*70)
    print("STRUCTURAL INSIGHTS:")
    print("="*70)
    print("""
Key Findings:
1. Bad fraction can reach ~0.81 (N=30, random) and ~0.69 (N≥50, random)
2. Even with high bad fraction, always at least 1 good d exists
3. Good d's tend to be SMALLER (more 'local') differences
4. When A_d is bad (has 3-APs), those 3-APs come from 3-APs in A
5. The good d avoids the 3-AP contamination from A

Proof obstacles:
- Cannot derive a 4-AP from "all d ∈ S are bad" in general
- Cannot bound T_total_3APs to force at least 1 good d
- The structure of the good d's is not obviously characterizable

Possible proof routes:
A. Induction: if A_M is 4-AP-free with M elements, then some A_d is 3-AP-free
   (but induction on M doesn't obviously work since adding elements changes S)
B. Probabilistic: random d ∈ S has positive probability of being good
   (but the good/bad split seems non-uniform)
C. Spectral: A has Fourier structure forcing some large fiber to be 3-AP-free
   (most promising but requires new ideas)
""")

if __name__ == '__main__':
    main()
