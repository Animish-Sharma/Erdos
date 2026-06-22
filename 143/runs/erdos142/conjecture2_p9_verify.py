#!/usr/bin/env python3
"""
P9 Verification: T₃(A_{d*}) = 0 for Minimum-Qualifying Popular Fibers
======================================================================
P9 (Open Problem 9): For every 4-AP-free A ⊆ {1,...,N} with |A|=M,
the MINIMUM-SIZE popular fiber
    d* = argmin_{d : |A_d| ≥ M²/(4N)} |A_d|
satisfies T₃(A_{d*}) = 0 (i.e., A_{d*} is 3-AP-free).

This is stronger than Conjecture 2, which only requires SOME popular d
to give a 3-AP-free fiber.

Background: commit b5827d9 showed that 'good' (3-AP-free) fibers tend
to be the SMALLEST popular fibers.  P9 asserts this is universal.

This script:
1. Verifies P9 for N=10,20,...,120 with 200 random 4-AP-free sets each
2. Compares T₃(d*) vs T₃(argmax d) and T₃(random d ∈ S)
3. Detailed N=40 analysis using the known worst-case set

References:
  runs/erdos142/conjecture2_extended.py  (commit b5827d9)
  runs/erdos142/conjecture2_extended_results.md
"""

import random
import time
from collections import defaultdict

try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False


# =============================================================================
# Core functions (self-contained, no external imports needed)
# =============================================================================

def is_4ap_free(A_sorted, A_set=None):
    """Check if sorted list A is 4-AP-free.  O(|A|²)."""
    if A_set is None:
        A_set = set(A_sorted)
    for i in range(len(A_sorted)):
        a = A_sorted[i]
        for j in range(i + 1, len(A_sorted)):
            d = A_sorted[j] - a
            if (a + 2 * d) in A_set and (a + 3 * d) in A_set:
                return False
    return True


def fiber(A_set, d, N):
    """A_d = {x ∈ A : x+d ∈ A, 1 ≤ x ≤ N}  (sorted list)."""
    return sorted(x for x in A_set if 1 <= x <= N and (x + d) in A_set)


def count_nontrivial_3aps(S):
    """
    Count non-trivial 3-APs (x, y, z) in S with x + z = 2y and x ≠ y (≠ z).
    Equivalently: count triples (a, b, c) with a < b < c and a + c = 2b.
    O(|S|²).
    """
    S_set = set(S)
    count = 0
    S_list = sorted(S)
    for i in range(len(S_list)):
        a = S_list[i]
        for j in range(i + 1, len(S_list)):
            b = S_list[j]
            c = 2 * b - a
            if c > b and c in S_set:
                count += 1
    return count


def greedy_4ap_free(N, seed=None):
    """Random greedy 4-AP-free subset of {1,...,N}."""
    if seed is not None:
        random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A, A_set = [], set()
    for x in order:
        A_set.add(x)
        A_sorted_test = sorted(list(A_set))
        if is_4ap_free(A_sorted_test, A_set):
            A.append(x)
        else:
            A_set.remove(x)
    return sorted(A)


def greedy_dense_4ap_free(N, num_restarts=5, seed_base=0):
    """Best of num_restarts greedy attempts (maximise |A|)."""
    best = []
    for r in range(num_restarts):
        A = greedy_4ap_free(N, seed=seed_base + r * 997)
        if len(A) > len(best):
            best = A
    return best


def get_popular_ds(A_set, N):
    """
    Return all (d, fiber_list, fiber_size) for d in {1,...,N-1}
    where |fiber| >= M²/(4N) (popular differences).
    """
    M = len(A_set)
    if M < 2:
        return []
    threshold = M * M / (4.0 * N)
    result = []
    for d in range(1, N):
        f = fiber(A_set, d, N)
        if len(f) >= threshold:
            result.append((d, f, len(f)))
    return result


# =============================================================================
# P9 check
# =============================================================================

def check_p9(A_sorted, N):
    """
    Check P9 for 4-AP-free set A.

    Returns a dict with:
      has_popular     : bool  (any popular d exists)
      d_star          : int   (argmin popular fiber size)
      size_dstar      : int   (|A_{d*}|)
      T3_dstar        : int   (count of 3-APs in A_{d*})
      p9_holds        : bool  (T3_dstar == 0)
      size_argmax     : int   (size of argmax popular fiber)
      T3_argmax       : int   (3-AP count in argmax fiber)
      all_min_3apfree : bool  (all min-size popular fibers are 3-AP-free)
      some_min_3apfree: bool  (some min-size popular fiber is 3-AP-free)
      min_size        : int   (minimum popular fiber size)
      n_ties          : int   (number of d's achieving minimum size)
      threshold       : float
      popular_ds      : list  of (d, size, T3)
    """
    M = len(A_sorted)
    A_set = set(A_sorted)
    threshold = M * M / (4.0 * N)

    popular = get_popular_ds(A_set, N)

    if not popular:
        return {
            'has_popular': False,
            'p9_holds': None,
            'all_min_3apfree': None,
            'some_min_3apfree': None,
            'threshold': threshold,
        }

    # d* = argmin size
    min_size = min(s for _, _, s in popular)
    min_ds = [(d, f, s) for d, f, s in popular if s == min_size]

    # argmax size
    max_size = max(s for _, _, s in popular)
    max_ds = [(d, f, s) for d, f, s in popular if s == max_size]

    # T3 for d*
    T3_vals_min = []
    for d, f, s in min_ds:
        T3_vals_min.append(count_nontrivial_3aps(f))

    T3_dstar = T3_vals_min[0]  # value for the first (canonical) d*

    # T3 for argmax d
    T3_argmax = count_nontrivial_3aps(max_ds[0][1])

    # T3 for all popular d's
    popular_summary = []
    for d, f, s in popular:
        T3 = count_nontrivial_3aps(f)
        popular_summary.append((d, s, T3))

    # Aggregate
    all_min_3apfree = all(T3 == 0 for T3 in T3_vals_min)
    some_min_3apfree = any(T3 == 0 for T3 in T3_vals_min)

    return {
        'has_popular': True,
        'M': M,
        'threshold': threshold,
        'd_star': min_ds[0][0],
        'size_dstar': min_size,
        'T3_dstar': T3_dstar,
        'p9_holds': (T3_dstar == 0),
        'all_min_3apfree': all_min_3apfree,
        'some_min_3apfree': some_min_3apfree,
        'n_ties': len(min_ds),
        'min_size': min_size,
        'size_argmax': max_size,
        'T3_argmax': T3_argmax,
        'popular_ds': popular_summary,
        'n_popular': len(popular),
    }


# =============================================================================
# Main verification loop
# =============================================================================

def verify_p9_per_N(N_list, num_trials=200, use_dense=False, verbose=True):
    """
    For each N, run num_trials random 4-AP-free sets and check P9.
    """
    print("=" * 72)
    print("P9 Verification: T₃(A_{d*}) = 0 for Minimum-Qualifying Popular Fibers")
    print("=" * 72)
    print(f"Trials per N: {num_trials}  |  Dense greedy: {use_dense}")
    print()
    print(f"  {'N':>4}  {'trials':>7}  {'p9_holds%':>10}  {'all_min%':>10}  "
          f"{'CEs':>5}  {'T3d*>0%':>9}  {'T3max>0%':>10}  {'avg_min|S|':>11}")
    print("  " + "-" * 74)

    all_rows = []

    for N in N_list:
        p9_ok = 0
        p9_fail = 0
        all_min_ok = 0
        n_total = 0
        T3_dstar_nonzero = 0
        T3_argmax_nonzero = 0
        min_sizes = []
        counterexamples = []

        for trial in range(num_trials):
            if use_dense:
                A = greedy_dense_4ap_free(N, num_restarts=5, seed_base=trial * 13 + N)
            else:
                A = greedy_4ap_free(N, seed=trial * 97 + N * 13 + 42)

            if len(A) < 2:
                continue

            result = check_p9(A, N)
            if not result.get('has_popular'):
                continue

            n_total += 1
            min_sizes.append(result['min_size'])

            if result['p9_holds']:
                p9_ok += 1
            else:
                p9_fail += 1
                counterexamples.append((A[:], result))

            if result['all_min_3apfree']:
                all_min_ok += 1

            if result['T3_dstar'] > 0:
                T3_dstar_nonzero += 1
            if result['T3_argmax'] > 0:
                T3_argmax_nonzero += 1

        pct_p9 = 100 * p9_ok / n_total if n_total > 0 else float('nan')
        pct_all = 100 * all_min_ok / n_total if n_total > 0 else float('nan')
        pct_T3ds = 100 * T3_dstar_nonzero / n_total if n_total > 0 else float('nan')
        pct_T3mx = 100 * T3_argmax_nonzero / n_total if n_total > 0 else float('nan')
        avg_min = sum(min_sizes) / len(min_sizes) if min_sizes else float('nan')

        row = {
            'N': N,
            'n_total': n_total,
            'p9_ok': p9_ok,
            'p9_fail': p9_fail,
            'all_min_ok': all_min_ok,
            'pct_p9': pct_p9,
            'pct_all': pct_all,
            'T3_dstar_nonzero': T3_dstar_nonzero,
            'T3_argmax_nonzero': T3_argmax_nonzero,
            'pct_T3ds': pct_T3ds,
            'pct_T3mx': pct_T3mx,
            'avg_min': avg_min,
            'counterexamples': counterexamples,
        }
        all_rows.append(row)

        ce_str = str(p9_fail) if p9_fail > 0 else "0"
        print(f"  {N:4d}  {n_total:7d}  {pct_p9:9.2f}%  {pct_all:9.2f}%  "
              f"{ce_str:>5}  {pct_T3ds:8.2f}%  {pct_T3mx:9.2f}%  {avg_min:11.3f}")

        if counterexamples and verbose:
            for A_ce, res_ce in counterexamples[:2]:
                print(f"    *** P9 CE: A={A_ce}, d*={res_ce['d_star']}, "
                      f"|A_d*|={res_ce['size_dstar']}, T₃(d*)={res_ce['T3_dstar']}")

    print()
    return all_rows


# =============================================================================
# Detailed: T3 distribution across popular d's
# =============================================================================

def detailed_T3_analysis(N_list, num_trials=200, use_dense=False):
    """
    For each N, analyse the T3 distribution across ALL popular d's.
    Compare T3(d*) vs T3(random d in S) vs T3(argmax d).
    """
    print("=" * 72)
    print("Detailed T₃ Distribution Across Popular d's")
    print("=" * 72)
    print(f"  {'N':>4}  {'avg_T3(d*)':>11}  {'avg_T3(rnd)':>12}  "
          f"{'avg_T3(max)':>12}  {'ratio d*/rnd':>13}")
    print("  " + "-" * 65)

    rows = []

    for N in N_list:
        T3_dstar_vals = []
        T3_random_vals = []
        T3_argmax_vals = []

        for trial in range(num_trials):
            if use_dense:
                A = greedy_dense_4ap_free(N, num_restarts=5, seed_base=trial * 17 + N)
            else:
                A = greedy_4ap_free(N, seed=trial * 79 + N * 11 + 37)

            if len(A) < 2:
                continue

            A_set = set(A)
            M = len(A)
            threshold = M * M / (4.0 * N)
            popular = get_popular_ds(A_set, N)
            if not popular:
                continue

            sizes = [s for _, _, s in popular]
            min_sz = min(sizes)
            max_sz = max(sizes)

            # T3 for d* (min size)
            min_d_fibers = [f for d, f, s in popular if s == min_sz]
            T3_dstar_vals.append(count_nontrivial_3aps(min_d_fibers[0]))

            # T3 for argmax d
            max_d_fibers = [f for d, f, s in popular if s == max_sz]
            T3_argmax_vals.append(count_nontrivial_3aps(max_d_fibers[0]))

            # T3 for a random popular d
            _, f_rand, _ = random.choice(popular)
            T3_random_vals.append(count_nontrivial_3aps(f_rand))

        def avg(lst):
            return sum(lst) / len(lst) if lst else float('nan')

        a_ds = avg(T3_dstar_vals)
        a_rnd = avg(T3_random_vals)
        a_mx = avg(T3_argmax_vals)
        ratio = a_ds / a_rnd if a_rnd > 0 else float('nan')

        row = {'N': N, 'avg_T3_dstar': a_ds, 'avg_T3_rand': a_rnd,
               'avg_T3_argmax': a_mx, 'ratio': ratio}
        rows.append(row)

        print(f"  {N:4d}  {a_ds:11.4f}  {a_rnd:12.4f}  "
              f"{a_mx:12.4f}  {ratio:13.4f}")

    print()
    return rows


# =============================================================================
# N=40 specific analysis
# =============================================================================

def n40_exact_analysis():
    """
    Exact T₃ computation for the known N=40 worst case.
    A = [1,2,3,5,6,10,11,12,15,17,18,19,22,25,29,30,31,33,34,38,39,40]
    bad_frac = 0.8519,  good_d = {18, 22, 27, 29}
    """
    print("=" * 72)
    print("N=40 Exact Analysis: T₃(A_d) for All Popular d's")
    print("=" * 72)

    N = 40
    A = [1, 2, 3, 5, 6, 10, 11, 12, 15, 17, 18, 19, 22, 25,
         29, 30, 31, 33, 34, 38, 39, 40]
    A_set = set(A)
    M = len(A)
    threshold = M * M / (4.0 * N)

    print(f"  A = {A}")
    print(f"  |A| = {M},  N = {N},  threshold = {threshold:.4f}")
    print()

    popular = get_popular_ds(A_set, N)
    if not popular:
        print("  No popular d's!")
        return

    # Sort by fiber size
    popular_by_size = sorted(popular, key=lambda x: x[2])

    print(f"  {'d':>5}  {'|A_d|':>7}  {'T₃(A_d)':>9}  {'3AP-free?':>10}  fiber")
    print("  " + "-" * 70)

    min_size = popular_by_size[0][2]
    T3_by_d = {}

    for d, f, sz in popular_by_size:
        T3 = count_nontrivial_3aps(f)
        T3_by_d[d] = T3
        free = "✓" if T3 == 0 else "✗"
        min_mark = " ← d*" if sz == min_size else ""
        print(f"  {d:5d}  {sz:7d}  {T3:9d}  {free:>10}  {f}{min_mark}")

    print()

    # P9 check
    min_size_val = min(s for _, _, s in popular)
    min_ds_T3 = [(d, T3_by_d[d]) for d, _, s in popular if s == min_size_val]

    print(f"  Minimum popular fiber size: {min_size_val}")
    print(f"  d's achieving this minimum: {[d for d, _ in min_ds_T3]}")
    print(f"  T₃ for minimum fibers: {[(d, T3) for d, T3 in min_ds_T3]}")

    all_ok = all(T3 == 0 for _, T3 in min_ds_T3)
    some_ok = any(T3 == 0 for _, T3 in min_ds_T3)
    print(f"  P9 (all min fibers 3AP-free): {'✓' if all_ok else '✗'}")
    print(f"  P9-weak (some min fiber 3AP-free): {'✓' if some_ok else '✗'}")
    print()

    # Compare: good d's vs all d's
    known_good_d = {18, 22, 27, 29}
    print("  Known good d's from Conjecture 2: {18, 22, 27, 29}")
    for d in sorted(known_good_d):
        pops = [(sz, T3_by_d[d]) for dd, f, sz in popular if dd == d]
        if pops:
            sz, T3 = pops[0]
            print(f"    d={d}: |A_d|={sz}, T₃={T3} {'✓' if T3==0 else '✗'}")
        else:
            print(f"    d={d}: NOT popular (|A_d| < threshold)")
    print()

    # Summary of T3 distribution
    T3_vals = [T3_by_d[d] for d, _, _ in popular]
    zero_frac = sum(1 for t in T3_vals if t == 0) / len(T3_vals)
    print(f"  T₃ = 0 for {sum(1 for t in T3_vals if t==0)}/{len(T3_vals)} popular d's "
          f"(bad_frac = {1-zero_frac:.4f})")
    print(f"  Max T₃ across all popular d's: {max(T3_vals)}")
    print(f"  T₃ distribution: {sorted(set(T3_vals))} → "
          f"{[T3_vals.count(v) for v in sorted(set(T3_vals))]}")
    print()

    return T3_by_d


# =============================================================================
# Search for P9 counterexamples
# =============================================================================

def search_p9_counterexamples(N_list, num_trials=1000, use_dense=True):
    """
    Intensive search for P9 counterexamples.
    A P9 CE is a 4-AP-free A where the minimum-size popular fiber has a 3-AP.
    """
    print("=" * 72)
    print("Intensive P9 Counterexample Search")
    print("=" * 72)
    print(f"  Trials: {num_trials}, dense: {use_dense}")
    print()

    found_ce = False
    for N in N_list:
        worst_T3dstar = 0
        worst_A = None

        for trial in range(num_trials):
            if use_dense:
                A = greedy_dense_4ap_free(N, num_restarts=5, seed_base=trial * 13 + N * 7)
            else:
                A = greedy_4ap_free(N, seed=trial * 97 + N * 13)
            if len(A) < 2:
                continue

            result = check_p9(A, N)
            if not result.get('has_popular'):
                continue

            if result['T3_dstar'] > worst_T3dstar:
                worst_T3dstar = result['T3_dstar']
                worst_A = A[:]

            if result['T3_dstar'] > 0:
                # P9 counterexample!
                print(f"  *** P9 CE found! N={N}, trial={trial}")
                print(f"      A={A}")
                print(f"      d*={result['d_star']}, |A_d*|={result['size_dstar']}, "
                      f"T₃(d*)={result['T3_dstar']}")
                found_ce = True

        print(f"  N={N:3d}: worst T₃(d*) = {worst_T3dstar}  "
              f"{'*** CE ***' if worst_T3dstar > 0 else '(P9 holds)'}")

    if not found_ce:
        print()
        print("  No P9 counterexample found.")

    return found_ce


# =============================================================================
# Main
# =============================================================================

def main():
    print("=" * 72)
    print("Conjecture 2 / P9: T₃(A_{d*}) = 0 for Minimum-Size Popular Fibers")
    print("=" * 72)
    print()

    t0 = time.time()

    # -------------------------------------------------------------------------
    # Part 1: Main P9 verification table
    # -------------------------------------------------------------------------
    N_list = list(range(10, 121, 10))  # 10, 20, ..., 120
    rows = verify_p9_per_N(N_list, num_trials=200, use_dense=False)

    # -------------------------------------------------------------------------
    # Part 2: Dense greedy for larger N (more structured sets)
    # -------------------------------------------------------------------------
    print("\n--- Repeat with dense greedy (5 restarts) ---\n")
    rows_dense = verify_p9_per_N(N_list, num_trials=200, use_dense=True)

    # -------------------------------------------------------------------------
    # Part 3: T3 distribution across popular d's
    # -------------------------------------------------------------------------
    T3_dist = detailed_T3_analysis(N_list, num_trials=200, use_dense=False)

    # -------------------------------------------------------------------------
    # Part 4: N=40 exact analysis
    # -------------------------------------------------------------------------
    T3_n40 = n40_exact_analysis()

    # -------------------------------------------------------------------------
    # Part 5: Intensive CE search
    # -------------------------------------------------------------------------
    print("\n--- Intensive P9 CE search (N=10..120, 500 trials, dense) ---\n")
    found_ce = search_p9_counterexamples(list(range(10, 121, 10)),
                                          num_trials=500, use_dense=True)

    elapsed = time.time() - t0

    # =========================================================================
    # Final summary
    # =========================================================================
    print()
    print("=" * 72)
    print("FINAL SUMMARY")
    print("=" * 72)

    total_ok = sum(r['p9_ok'] for r in rows)
    total_fail = sum(r['p9_fail'] for r in rows)
    total_n = sum(r['n_total'] for r in rows)

    print(f"Simple greedy (200 trials per N, N=10..120):")
    print(f"  P9 holds: {total_ok}/{total_n}  ({100*total_ok/total_n:.2f}%)")
    print(f"  P9 fails (CEs): {total_fail}")

    total_ok_d = sum(r['p9_ok'] for r in rows_dense)
    total_fail_d = sum(r['p9_fail'] for r in rows_dense)
    total_n_d = sum(r['n_total'] for r in rows_dense)

    print(f"\nDense greedy (200 trials per N, N=10..120):")
    print(f"  P9 holds: {total_ok_d}/{total_n_d}  ({100*total_ok_d/total_n_d:.2f}%)")
    print(f"  P9 fails (CEs): {total_fail_d}")

    print(f"\nT₃(d*) vs T₃(random d) ratio across N:")
    ratios = [r['ratio'] for r in T3_dist if r['ratio'] == r['ratio']]  # exclude NaN
    if ratios:
        print(f"  Mean ratio T₃(d*)/T₃(random): {sum(ratios)/len(ratios):.4f}")
        print(f"  (< 1 means d* has fewer 3-APs on average)")

    if T3_n40:
        min_T3 = min(T3_n40.values())
        print(f"\nN=40 exact analysis:")
        print(f"  Min T₃ over popular d's: {min_T3}")
        print(f"  T₃ for known good d's {{18,22,27,29}}: "
              f"{[T3_n40.get(d, 'N/A') for d in [18,22,27,29]]}")

    print(f"\nP9 counterexample found: {found_ce}")
    if not found_ce:
        print("P9 is VERIFIED (no CE found) for N ≤ 120.")
    else:
        print("P9 has a COUNTEREXAMPLE — see details above.")

    print(f"\nTotal elapsed time: {elapsed:.1f}s")

    return rows, rows_dense, T3_dist


if __name__ == '__main__':
    results = main()
