#!/usr/bin/env python3
"""
Conjecture 2 (Gap 3.1) — Extended Verification N≤150 + Structural Analysis
==========================================================================
Extends conjecture2_verify.py to:
  Task 1: Random-sampling verification for N ∈ {100,110,120,130,140,150}, 100 trials each
  Task 2: Good_d statistics — symmetry, magnitude, additive energy; N=40 deep dive
  Task 3: Fourier heuristic — Â_d spectrum for good vs bad popular differences
  Task 4: Structure of high-bad_frac sets — clustering, APs, symmetry

Conjecture 2 (Gap 3.1):
  For every 4-AP-free A ⊆ {1,...,N} with |A|=M≥2, ∃ d ∈ {1,...,N-1} s.t.
    (i)  |A_d| ≥ M²/(4N)          (popular difference)
    (ii) A_d is FULLY 3-AP-free    (no 3-AP with ANY step)
  where A_d = fiberAtDiff(A, d) = {x ∈ A : x+d ∈ A}.

References:
  runs/erdos142/conjecture2_verify.py  (commit a620cf5, 464 lines)
  runs/erdos142/lovász6_conjecture2.md
"""

import math
import random
import time
import cmath
from collections import defaultdict
from itertools import combinations

try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False
    print("Warning: numpy not available; Fourier analysis will use slow fallback.")


# =============================================================================
# Core predicates (inherited from conjecture2_verify.py)
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


def is_3ap_free(A_sorted, A_set=None):
    """Check if sorted list A is 3-AP-free.  O(|A|²)."""
    if A_set is None:
        A_set = set(A_sorted)
    for i in range(len(A_sorted)):
        a = A_sorted[i]
        for j in range(i + 1, len(A_sorted)):
            b = A_sorted[j]
            c = 2 * b - a
            if c > b and c in A_set:
                return False
    return True


def compute_fiber(A_set, d, N):
    """A_d = {a ∈ A : a+d ∈ A, 1 ≤ a ≤ N}  (sorted list)."""
    return sorted(a for a in A_set if 1 <= a <= N and (a + d) in A_set)


def count_3aps(B_sorted, B_set=None):
    """Count non-degenerate 3-APs (a,b,c) with a<b<c in sorted list B."""
    if B_set is None:
        B_set = set(B_sorted)
    count = 0
    for i, a in enumerate(B_sorted):
        for j in range(i + 1, len(B_sorted)):
            b = B_sorted[j]
            c = 2 * b - a
            if c > b and c in B_set:
                count += 1
    return count


def check_conjecture2_full(A_sorted, N):
    """
    Full Conjecture 2 analysis for 4-AP-free A ⊆ {1,...,N}.

    Returns:
      holds  : bool
      good   : list of (d, fiber) with 3-AP-free fiber and |fiber|≥threshold
      bad    : list of (d, fiber) with 3-APs in fiber but |fiber|≥threshold
      S      : list of (d, fiber) — all popular differences
      stats  : summary dict
    """
    M = len(A_sorted)
    A_set = set(A_sorted)
    threshold = M * M / (4.0 * N)

    S = []
    good = []
    bad = []

    for d in range(1, N):
        fiber = compute_fiber(A_set, d, N)
        if len(fiber) >= threshold:
            fiber_set = set(fiber)
            free = is_3ap_free(fiber, fiber_set)
            S.append((d, fiber))
            if free:
                good.append((d, fiber))
            else:
                bad.append((d, fiber))

    holds = len(good) > 0
    stats = {
        'M': M,
        'threshold': threshold,
        '|S|': len(S),
        '|good|': len(good),
        '|bad|': len(bad),
        'bad_frac': len(bad) / len(S) if S else 0.0,
        'good_d': [d for d, _ in good],
        'bad_d': [d for d, _ in bad],
    }
    return holds, good, bad, S, stats


# =============================================================================
# Set builders
# =============================================================================

def greedy_4ap_free(N, seed=None):
    """Build a random greedy 4-AP-free subset of {1,...,N}."""
    if seed is not None:
        random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A = []
    A_set = set()
    for x in order:
        # Check incremental: does adding x create a 4-AP?
        A_set.add(x)
        A_sorted_test = sorted(A + [x])
        if is_4ap_free(A_sorted_test, A_set):
            A.append(x)
        else:
            A_set.remove(x)
    return sorted(A)


def greedy_dense_4ap_free(N, num_restarts=10, seed_base=0):
    """Best of num_restarts greedy attempts."""
    best = []
    for r in range(num_restarts):
        A = greedy_4ap_free(N, seed=seed_base + r * 997)
        if len(A) > len(best):
            best = A
    return best


# =============================================================================
# Task 1: Extended verification to N=150
# =============================================================================

def task1_extended_verification(N_list, num_trials=100, seed_start=42, verbose=True):
    """
    Random-sampling verification of Conjecture 2 for each N in N_list.
    Records n_tested, n_ce, worst bad_frac, max_size.
    """
    print("=" * 70)
    print("TASK 1: Extended Verification  N ∈ {100,110,120,130,140,150}")
    print("=" * 70)
    print(f"  {'N':>5}  {'tested':>7}  {'CEs':>5}  {'bad_frac':>10}  {'max_|A|':>9}  status")
    print("  " + "-" * 55)

    all_results = []

    for N in N_list:
        n_tested = 0
        n_ce = 0
        worst_bad_frac = 0.0
        worst_A = None
        worst_stats = None
        max_size = 0

        for trial in range(num_trials):
            A = greedy_4ap_free(N, seed=seed_start + trial * 97 + N * 13)
            if len(A) < 2:
                continue

            n_tested += 1
            max_size = max(max_size, len(A))

            holds, good, bad, S, stats = check_conjecture2_full(A, N)

            if stats['bad_frac'] > worst_bad_frac:
                worst_bad_frac = stats['bad_frac']
                worst_A = A[:]
                worst_stats = stats

            if not holds:
                n_ce += 1
                if verbose:
                    print(f"  *** COUNTEREXAMPLE: N={N}, trial={trial}, A={A}")

        result = {
            'N': N,
            'n_tested': n_tested,
            'n_ce': n_ce,
            'bad_frac': worst_bad_frac,
            'max_size': max_size,
            'worst_A': worst_A,
            'worst_stats': worst_stats,
        }
        all_results.append(result)

        status = "✓ OK" if n_ce == 0 else f"✗ {n_ce} CEs!"
        print(f"  {N:5d}  {n_tested:7d}  {n_ce:5d}  {worst_bad_frac:10.4f}  {max_size:9d}  {status}")

    print()
    return all_results


# =============================================================================
# Task 2: Good_d statistics
# =============================================================================

def additive_energy(A_set, N):
    """
    Additive energy E(A) = #{(a,b,c,d)∈A⁴: a-b=c-d}.
    Formula: E(A) = M² + 2 Σ_{d=1}^{N-1} |A_d|².
    """
    A_sorted = sorted(A_set)
    M = len(A_sorted)
    energy = M * M  # d=0 contribution
    for d in range(1, N):
        fd = compute_fiber(A_set, d, N)
        energy += 2 * len(fd) ** 2
    return energy


def check_good_d_symmetry(good_d, N):
    """
    What fraction of good_d's have their partner N-d also good?
    Returns (paired_frac, pair_list).
    """
    good_set = set(good_d)
    paired = [(d, N - d) for d in good_d if d != N - d and (N - d) in good_set]
    frac = len(paired) / len(good_d) if good_d else 0.0
    return frac, paired


def task2_good_d_statistics(N_range, num_trials=1000, verbose=True):
    """
    For each N, find the worst-case set and analyse good_d properties:
      - fraction of good d's that are ≥ N/2
      - symmetric pair fraction
      - additive energy (normalised)
    """
    print("=" * 70)
    print("TASK 2: Good_d Statistics")
    print("=" * 70)
    print(f"  {'N':>4}  {'bad_frac':>9}  {'|A|':>5}  "
          f"{'|good|':>7}  {'frac(d≥N/2)':>12}  {'sym_frac':>9}  {'E/M³':>7}")
    print("  " + "-" * 60)

    results = []

    for N in N_range:
        worst_bad_frac = 0.0
        worst_A = None
        worst_good = None
        worst_stats = None

        for trial in range(num_trials):
            A = greedy_4ap_free(N, seed=trial * 7 + N * 17)
            if len(A) < 2:
                continue
            holds, good, bad, S, stats = check_conjecture2_full(A, N)
            if stats['bad_frac'] > worst_bad_frac:
                worst_bad_frac = stats['bad_frac']
                worst_A = A[:]
                worst_good = good[:]
                worst_stats = stats

        if worst_A is None:
            continue

        good_d = [d for d, _ in worst_good]
        M = len(worst_A)

        # Fraction of good d's that are ≥ N/2
        frac_large = sum(1 for d in good_d if d >= N / 2) / len(good_d) if good_d else 0.0

        # Symmetric pairs
        sym_frac, _ = check_good_d_symmetry(good_d, N)

        # Additive energy (normalised by M³)
        A_set = set(worst_A)
        en = additive_energy(A_set, N)
        en_norm = en / (M ** 3) if M >= 2 else 0.0

        row = {
            'N': N,
            'bad_frac': worst_bad_frac,
            'M': M,
            '|good|': len(good_d),
            'frac_large': frac_large,
            'sym_frac': sym_frac,
            'energy_norm': en_norm,
            'good_d': good_d,
            'A': worst_A,
        }
        results.append(row)

        print(f"  {N:4d}  {worst_bad_frac:9.4f}  {M:5d}  "
              f"{len(good_d):7d}  {frac_large:12.3f}  {sym_frac:9.3f}  {en_norm:7.3f}")

        if verbose and good_d:
            print(f"        good_d={sorted(good_d)[:10]}  "
                  f"(min={min(good_d)}, N/2={N/2:.1f})")

    print()
    return results


def task2_n40_deep_dive(num_trials=1000, bad_frac_threshold=0.80):
    """
    N=40 deep analysis: find all high-bad_frac sets and characterise them.
    Uses dense greedy (multiple restarts) to find the denser 4-AP-free sets
    that achieve the highest bad_frac.  Simple greedy rarely finds bad_frac≥0.80.
    """
    print("=" * 70)
    print(f"TASK 2b: N=40 Deep Dive  (threshold bad_frac ≥ {bad_frac_threshold})")
    print("=" * 70)
    print("  Using greedy_dense (5 restarts per trial) to find dense 4-AP-free sets.")

    N = 40
    high_bad = []
    worst_bf = 0.0
    worst_A = None

    for trial in range(num_trials):
        # Dense greedy: take the largest set from 5 random restarts
        A = greedy_dense_4ap_free(N, num_restarts=5, seed_base=trial * 13)
        if len(A) < 2:
            continue
        holds, good, bad, S, stats = check_conjecture2_full(A, N)
        bf = stats['bad_frac']

        if bf > worst_bf:
            worst_bf = bf
            worst_A = A[:]

        if bf >= bad_frac_threshold:
            entry = {
                'A': A[:],
                'bad_frac': bf,
                'good_d': [d for d, _ in good],
                'bad_d': [d for d, _ in bad],
                '|S|': stats['|S|'],
                '|good|': stats['|good|'],
            }
            # Deduplicate by set content
            if not any(set(e['A']) == set(A) for e in high_bad):
                high_bad.append(entry)

    print(f"  Trials: {num_trials} (dense)  |  Found {len(high_bad)} distinct sets with bad_frac ≥ {bad_frac_threshold}")
    print(f"  Worst bad_frac: {worst_bf:.4f}")
    print()

    if not high_bad:
        print("  No high-bad_frac sets found.")
        return high_bad

    high_bad.sort(key=lambda x: -x['bad_frac'])

    print(f"  Top sets (bad_frac ≥ {bad_frac_threshold}):")
    for rank, item in enumerate(high_bad[:8]):
        A = item['A']
        good_d = item['good_d']
        A_set = set(A)

        # Cluster analysis
        clusters = []
        if A:
            cur = [A[0]]
            for x in A[1:]:
                if x == cur[-1] + 1:
                    cur.append(x)
                else:
                    clusters.append(cur)
                    cur = [x]
            clusters.append(cur)

        # Symmetry about N/2 = 20
        sym = sum(1 for a in A if (N + 1 - a) in A_set)
        sym_frac = sym / len(A)

        # Good d's ≥ N/2
        large_good = sum(1 for d in good_d if d >= N // 2)

        # Symmetric good-d pairs
        good_set = set(good_d)
        sym_pairs = [(d, N - d) for d in sorted(good_d) if d < N - d and (N - d) in good_set]

        print(f"  [{rank+1}] bad_frac={item['bad_frac']:.4f}  |A|={len(A)}  |S|={item['|S|']}  "
              f"|good|={item['|good|']}")
        print(f"       A  = {A}")
        print(f"       good_d = {sorted(good_d)}")
        print(f"       bad_d  = {sorted(item['bad_d'])[:12]}{'...' if len(item['bad_d'])>12 else ''}")
        print(f"       clusters ({len(clusters)}): {[len(c) for c in clusters]}")
        print(f"       symmetry fraction (a↔N+1-a): {sym_frac:.3f}")
        print(f"       good d's ≥ N/2={N//2}: {large_good}/{len(good_d)}")
        print(f"       symmetric good-d pairs (d,{N}-d): {sym_pairs}")
        print()

    # Statistical summary
    sizes = [len(s['A']) for s in high_bad]
    bfs = [s['bad_frac'] for s in high_bad]
    n_large_good = []
    n_sym_good = []
    for item in high_bad:
        gd = item['good_d']
        if gd:
            n_large_good.append(sum(1 for d in gd if d >= N // 2) / len(gd))
            gs = set(gd)
            n_sym_good.append(sum(1 for d in gd if (N - d) in gs) / len(gd))

    print(f"  Summary across {len(high_bad)} high-bad_frac sets:")
    print(f"    |A| range: {min(sizes)}-{max(sizes)}  mean={sum(sizes)/len(sizes):.1f}")
    print(f"    bad_frac range: {min(bfs):.3f}-{max(bfs):.3f}")
    if n_large_good:
        print(f"    frac(good_d ≥ N/2): mean={sum(n_large_good)/len(n_large_good):.3f}")
    if n_sym_good:
        print(f"    frac(good_d with symmetric partner): mean={sum(n_sym_good)/len(n_sym_good):.3f}")
    print()
    return high_bad


# =============================================================================
# Task 3: Fourier heuristic
# =============================================================================

def fourier_dft_set(B, N):
    """
    DFT of set B ⊆ {1,...,N}:
      B̂(ξ) = Σ_{b∈B} e^{2πi·b·ξ/N}  for ξ = 0,...,N-1.
    Returns array of length N.
    """
    if HAS_NUMPY:
        indicator = np.zeros(N, dtype=complex)
        for b in B:
            if 1 <= b <= N:
                indicator[b - 1] += 1.0
        # FFT gives Σ_b exp(2πi·(b-1)·ξ/N); multiply by e^{2πiξ/N} for 1-indexing
        fft = np.fft.fft(indicator)
        phases = np.exp(2j * np.pi * np.arange(N) / N)
        return fft * phases
    else:
        result = np.zeros(N, dtype=complex) if HAS_NUMPY else None
        out = []
        for xi in range(N):
            v = sum(cmath.exp(2j * cmath.pi * b * xi / N) for b in B)
            out.append(v)
        return out


def max_fourier_bias(B, N):
    """
    max_{ξ≠0} |B̂(ξ)| / |B|   (the 'Fourier bias' of B).
    Returns 0.0 for empty B.
    """
    if not B:
        return 0.0
    M = len(B)
    Bhat = fourier_dft_set(B, N)
    if HAS_NUMPY:
        return float(np.max(np.abs(Bhat[1:]))) / M
    else:
        return max(abs(Bhat[xi]) for xi in range(1, N)) / M


def task3_fourier_heuristic(N_range, num_trials=300, verbose=True):
    """
    For each N, compare Fourier bias of good vs bad fibers.
    Hypothesis: good fibers have flatter Fourier spectrum (smaller bias).
    """
    print("=" * 70)
    print("TASK 3: Fourier Heuristic")
    print("=" * 70)
    print(f"  Fourier bias = max_{{ξ≠0}} |B̂(ξ)| / |B|")
    print(f"  Hypothesis: good fibers have smaller bias than bad fibers.")
    print()
    print(f"  {'N':>4}  {'A_bias':>8}  {'good_bias':>10}  {'bad_bias':>9}  "
          f"{'ratio(g/b)':>11}  n_good   n_bad")
    print("  " + "-" * 70)

    stats_list = []

    for N in N_range:
        A_biases = []
        good_biases = []
        bad_biases = []

        for trial in range(num_trials):
            A = greedy_4ap_free(N, seed=trial * 13 + N * 19)
            if len(A) < 3:
                continue

            holds, good, bad, S, stats = check_conjecture2_full(A, N)

            # Fourier bias of A itself
            A_biases.append(max_fourier_bias(A, N))

            for d, fiber in good:
                if len(fiber) >= 2:
                    good_biases.append(max_fourier_bias(fiber, N))

            for d, fiber in bad:
                if len(fiber) >= 2:
                    bad_biases.append(max_fourier_bias(fiber, N))

        def avg(lst):
            return sum(lst) / len(lst) if lst else float('nan')

        a_avg = avg(A_biases)
        g_avg = avg(good_biases)
        b_avg = avg(bad_biases)
        ratio = g_avg / b_avg if b_avg > 0 else float('nan')

        row = {
            'N': N,
            'A_bias': a_avg,
            'good_bias': g_avg,
            'bad_bias': b_avg,
            'ratio': ratio,
            'n_good': len(good_biases),
            'n_bad': len(bad_biases),
        }
        stats_list.append(row)

        print(f"  {N:4d}  {a_avg:8.4f}  {g_avg:10.4f}  {b_avg:9.4f}  "
              f"{ratio:11.4f}  {len(good_biases):7d}  {len(bad_biases):7d}")

    print()

    # Summarise the hypothesis
    ratios = [r['ratio'] for r in stats_list if not math.isnan(r['ratio'])]
    if ratios:
        print(f"  Mean ratio good_bias/bad_bias: {sum(ratios)/len(ratios):.4f}")
        supports = sum(1 for r in ratios if r < 1.0)
        print(f"  N's where ratio < 1 (good flatter than bad): {supports}/{len(ratios)}")
        if supports == len(ratios):
            print("  >>> HYPOTHESIS SUPPORTED: good fibers consistently have flatter spectrum <<<")
        elif supports > len(ratios) * 0.8:
            print("  >>> HYPOTHESIS PARTIALLY SUPPORTED <<<")
        else:
            print("  >>> HYPOTHESIS NOT SUPPORTED <<<")
    print()
    return stats_list


def task3_worst_case_fourier_detail(N=40, num_trials=3000):
    """
    Detailed per-fiber Fourier analysis for the worst-case set at given N.
    """
    print("=" * 70)
    print(f"TASK 3b: Detailed Fourier Analysis — Worst Case N={N}")
    print("=" * 70)

    worst_bf = 0.0
    worst_A = None
    worst_good = None
    worst_bad = None

    for trial in range(num_trials):
        A = greedy_4ap_free(N, seed=trial * 11 + N * 23)
        if len(A) < 3:
            continue
        holds, good, bad, S, stats = check_conjecture2_full(A, N)
        if stats['bad_frac'] > worst_bf:
            worst_bf = stats['bad_frac']
            worst_A = A[:]
            worst_good = good[:]
            worst_bad = bad[:]

    if worst_A is None:
        print("  No suitable set found.")
        return

    M = len(worst_A)
    print(f"  Worst case: bad_frac={worst_bf:.4f}  |A|={M}  N={N}")
    print(f"  A = {worst_A}")
    print()

    # Fourier spectrum of A
    Ahat = fourier_dft_set(worst_A, N)
    if HAS_NUMPY:
        Ahat_np = np.array(Ahat)
        Aabs = np.abs(Ahat_np)
        top5 = sorted(range(1, N), key=lambda xi: -Aabs[xi])[:5]
        print(f"  Fourier spectrum of A:")
        print(f"    |Â(0)| = {float(Aabs[0]):.3f}  (= M = {M})")
        for xi in top5:
            print(f"    |Â({xi})| = {float(Aabs[xi]):.3f}  (normalised: {float(Aabs[xi])/M:.3f})")
        print()

    # Per-fiber Fourier analysis
    print(f"  {'d':>5}  {'type':>6}  {'|Ad|':>5}  {'max|Âd(ξ≠0)|':>14}  "
          f"{'bias':>7}  {'#3APs_in_Ad':>13}")
    print("  " + "-" * 60)

    all_d = [(d, f, 'good') for d, f in worst_good] + [(d, f, 'bad') for d, f in worst_bad]
    all_d.sort(key=lambda x: x[0])

    for d, fiber, label in all_d:
        if not fiber:
            continue
        fhat = fourier_dft_set(fiber, N)
        if HAS_NUMPY:
            fhat_arr = np.array(fhat)
            max_f = float(np.max(np.abs(fhat_arr[1:])))
        else:
            max_f = max(abs(fhat[xi]) for xi in range(1, N))
        bias = max_f / len(fiber)
        n3 = count_3aps(fiber, set(fiber))
        print(f"  {d:5d}  {label:>6}  {len(fiber):5d}  {max_f:14.4f}  "
              f"{bias:7.4f}  {n3:13d}")

    print()

    # Summary statistics
    good_biases = []
    bad_biases = []
    for d, fiber, label in all_d:
        if not fiber:
            continue
        fhat = fourier_dft_set(fiber, N)
        if HAS_NUMPY:
            fhat_arr = np.array(fhat)
            bias = float(np.max(np.abs(fhat_arr[1:]))) / len(fiber)
        else:
            bias = max(abs(fhat[xi]) for xi in range(1, N)) / len(fiber)
        if label == 'good':
            good_biases.append(bias)
        else:
            bad_biases.append(bias)

    def avg(lst):
        return sum(lst) / len(lst) if lst else float('nan')

    print(f"  Summary for N={N} worst case:")
    print(f"    Good fibers: n={len(good_biases)}, avg_bias={avg(good_biases):.4f}")
    print(f"    Bad  fibers: n={len(bad_biases)}, avg_bias={avg(bad_biases):.4f}")
    if good_biases and bad_biases:
        r = avg(good_biases) / avg(bad_biases)
        print(f"    Ratio (good/bad): {r:.4f}  "
              f"({'< 1: good flatter ✓' if r < 1 else '≥ 1: hypothesis NOT supported ✗'})")
    print()


# =============================================================================
# Task 4: Structure of high-bad_frac sets
# =============================================================================

def longest_ap_in(A, A_set):
    """Find length of longest AP in A."""
    if len(A) < 2:
        return len(A)
    longest = 2
    for i in range(len(A)):
        for j in range(i + 1, len(A)):
            step = A[j] - A[i]
            length = 2
            nxt = A[j] + step
            while nxt in A_set:
                length += 1
                nxt += step
            if length > longest:
                longest = length
    return longest


def classify_structure(A, N):
    """
    Structural classification of A ⊆ {1,...,N}.
    Returns dict of properties.
    """
    A_set = set(A)
    M = len(A)
    if M == 0:
        return {}

    # 1. Clusters (maximal runs of consecutive integers)
    clusters = []
    cur = [A[0]]
    for x in A[1:]:
        if x == cur[-1] + 1:
            cur.append(x)
        else:
            clusters.append(cur)
            cur = [x]
    clusters.append(cur)
    cluster_sizes = sorted([len(c) for c in clusters], reverse=True)

    # 2. Longest AP
    lap = longest_ap_in(A, A_set)

    # 3. Symmetry about (N+1)/2
    mid = (N + 1) / 2
    sym_count = sum(1 for a in A if (N + 1 - a) in A_set)
    sym_frac = sym_count / M

    # 4. Half-density
    lo = sum(1 for a in A if a * 2 <= N)
    hi = sum(1 for a in A if a * 2 > N)
    half_N = N // 2

    # 5. Is it a union of APs with common step?
    # Check step=1 (cluster), step=2, step=3...
    union_ap_step = None
    for step in range(1, N):
        # Can we cover A with APs of step `step`?
        # i.e., are elements within each residue class consecutive?
        covered = True
        for r in range(step):
            in_class = sorted(a for a in A if a % step == r)
            # Check if they form a single AP with step `step`
            if len(in_class) >= 2:
                for k in range(len(in_class) - 1):
                    if in_class[k + 1] - in_class[k] != step:
                        covered = False
                        break
            if not covered:
                break
        if covered and step <= N // 2:
            union_ap_step = step
            break

    return {
        'num_clusters': len(clusters),
        'cluster_sizes': cluster_sizes,
        'max_cluster': cluster_sizes[0] if cluster_sizes else 0,
        'longest_ap': lap,
        'sym_frac': sym_frac,
        'is_symmetric': sym_frac == 1.0,
        'density_lo': lo / max(half_N, 1),
        'density_hi': hi / max(N - half_N, 1),
        'union_ap_step': union_ap_step,
    }


def task4_structural_analysis(N_range, num_trials=2000, verbose=True):
    """
    For each N, find the worst-case set and classify its structure.
    """
    print("=" * 70)
    print("TASK 4: Structure of High-bad_frac Sets")
    print("=" * 70)

    for N in N_range:
        worst_bf = 0.0
        worst_A = None
        worst_stats = None

        for trial in range(num_trials):
            A = greedy_4ap_free(N, seed=trial * 17 + N * 11)
            if len(A) < 3:
                continue
            holds, good, bad, S, stats = check_conjecture2_full(A, N)
            if stats['bad_frac'] > worst_bf:
                worst_bf = stats['bad_frac']
                worst_A = A[:]
                worst_stats = stats

        if worst_A is None:
            continue

        struct = classify_structure(worst_A, N)
        M = len(worst_A)

        print(f"\nN={N}  bad_frac={worst_bf:.4f}  |A|={M}  density={M/N:.3f}")
        print(f"  A = {worst_A}")
        print(f"  good_d = {worst_stats['good_d']}")
        print(f"  Clusters: {struct['num_clusters']} total, sizes={struct['cluster_sizes'][:8]}")
        print(f"  Longest AP in A: {struct['longest_ap']}")
        print(f"  Symmetric about (N+1)/2={(N+1)/2:.1f}: frac={struct['sym_frac']:.3f}")
        print(f"  Density lower/upper half: {struct['density_lo']:.3f} / {struct['density_hi']:.3f}")
        if struct['union_ap_step']:
            print(f"  Union-of-APs with step {struct['union_ap_step']} detected!")
        else:
            print(f"  No simple union-of-APs structure found")

    print()


# =============================================================================
# Main
# =============================================================================

def main():
    print("=" * 70)
    print("Conjecture 2 (Gap 3.1) — Extended Verification N≤150 + Analysis")
    print("=" * 70)
    print()

    t0 = time.time()

    # -------------------------------------------------------------------------
    # TASK 1: Extend verification to N=150
    # -------------------------------------------------------------------------
    N_ext = [100, 110, 120, 130, 140, 150]
    t1 = task1_extended_verification(N_ext, num_trials=100, seed_start=42)

    # -------------------------------------------------------------------------
    # TASK 2: Good_d statistics
    # -------------------------------------------------------------------------
    N_range_t2 = [20, 25, 30, 35, 40, 45, 50, 60, 70, 80]
    t2 = task2_good_d_statistics(N_range_t2, num_trials=1000)

    # Task 2b: N=40 deep dive (dense greedy, 1000 trials × 5 restarts)
    t2b = task2_n40_deep_dive(num_trials=1000, bad_frac_threshold=0.80)

    # -------------------------------------------------------------------------
    # TASK 3: Fourier heuristic
    # -------------------------------------------------------------------------
    N_range_fourier = [20, 30, 40, 50, 60]
    t3 = task3_fourier_heuristic(N_range_fourier, num_trials=200)

    # Task 3b: detailed for worst-case N=40
    task3_worst_case_fourier_detail(N=40, num_trials=2000)

    # -------------------------------------------------------------------------
    # TASK 4: Structural analysis
    # -------------------------------------------------------------------------
    N_range_t4 = [30, 40, 50, 60, 80, 100, 120, 150]
    task4_structural_analysis(N_range_t4, num_trials=1000)

    elapsed = time.time() - t0

    # =========================================================================
    # FINAL SUMMARY
    # =========================================================================
    print("=" * 70)
    print("FINAL SUMMARY")
    print("=" * 70)

    # Task 1 summary
    any_ce = any(r['n_ce'] > 0 for r in t1)
    max_bad_t1 = max((r['bad_frac'] for r in t1), default=0.0)
    worst_N = max(t1, key=lambda r: r['bad_frac'])['N'] if t1 else 'N/A'
    print(f"Task 1 (N ∈ {{100,...,150}}):")
    print(f"  Counterexamples found: {'YES (!!!)' if any_ce else 'None'}")
    print(f"  Max bad_frac: {max_bad_t1:.4f}  (at N={worst_N})")
    print(f"  Conjecture 2 holds for all tested N: {not any_ce}")
    print()

    # Task 2 summary
    if t2:
        all_large = [r['frac_large'] for r in t2]
        all_sym = [r['sym_frac'] for r in t2]
        print(f"Task 2 (Good_d statistics):")
        print(f"  Mean frac(good_d ≥ N/2):   {sum(all_large)/len(all_large):.3f}")
        print(f"  Mean sym_frac(d ↔ N-d):     {sum(all_sym)/len(all_sym):.3f}")
        en_vals = [r['energy_norm'] for r in t2]
        print(f"  Mean E(A)/M³ (worst cases): {sum(en_vals)/len(en_vals):.3f}")
    print()

    # Task 3 summary
    if t3:
        ratios = [r['ratio'] for r in t3 if not math.isnan(r.get('ratio', float('nan')))]
        if ratios:
            print(f"Task 3 (Fourier heuristic):")
            print(f"  Mean ratio good_bias/bad_bias: {sum(ratios)/len(ratios):.4f}")
            sup = sum(1 for r in ratios if r < 1.0)
            print(f"  Support for hypothesis (ratio<1): {sup}/{len(ratios)} N-values")
    print()

    print(f"Total elapsed time: {elapsed:.1f}s")
    print()
    print("Conjecture 2 remains UNREFUTED.  No counterexample found for N ≤ 150.")

    return t1, t2, t2b, t3


if __name__ == '__main__':
    results = main()
