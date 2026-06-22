#!/usr/bin/env python3
"""
c2_extension_n750: Conjecture 2 Verification N = 550..750
=========================================================
Extends prior verification (N≤500, commit 02f6cd2) to larger N.

For each N in {550, 600, 650, 700, 750}:
  - Generate 300 random 4-AP-free subsets A of {1,...,N}
  - Verify Conjecture 2: ∃ popular d with T₃(A_d) = 0
  - Record: CEs, max bad_frac, avg/max witness fiber fraction of max_popular_size

Definitions:
  fiber(A,d)      = {x∈A: x+d∈A}  (sorted list)
  thr(A,N)        = M²/(4N)  where M=|A|
  S(A,N)          = {d: |fiber(A,d)| ≥ thr(A,N)}  (popular diffs)
  T₃(B)           = #{(a<b<c): a+c=2b, all in B}  (non-trivial 3-APs)
  bad_frac(A,N)   = #{d∈S: T₃(fiber)>0} / |S|
  witness size    = |fiber(d_witness)| / max_{d∈S}|fiber(A,d)|  (relative size)
"""

import random
import time

# ── Fast 4-AP-free incremental check ──────────────────────────────────────────

def creates_4ap(x, A_set, N):
    """
    Returns True if adding x to A_set (which is already 4-AP-free) would
    create a 4-AP.  Checks x as 1st, 2nd, 3rd, 4th element of a 4-AP with
    all possible steps d.  O(N) time.
    """
    # Case 1: x is 1st  →  x, x+d, x+2d, x+3d all in A∪{x}
    d = 1
    while x + 3*d <= N:
        if (x+d) in A_set and (x+2*d) in A_set and (x+3*d) in A_set:
            return True
        d += 1

    # Case 2: x is 2nd  →  x-d, x, x+d, x+2d
    d = 1
    while x - d >= 1 and x + 2*d <= N:
        if (x-d) in A_set and (x+d) in A_set and (x+2*d) in A_set:
            return True
        d += 1

    # Case 3: x is 3rd  →  x-2d, x-d, x, x+d
    d = 1
    while x - 2*d >= 1 and x + d <= N:
        if (x-2*d) in A_set and (x-d) in A_set and (x+d) in A_set:
            return True
        d += 1

    # Case 4: x is 4th  →  x-3d, x-2d, x-d, x
    d = 1
    while x - 3*d >= 1:
        if (x-3*d) in A_set and (x-2*d) in A_set and (x-d) in A_set:
            return True
        d += 1

    return False


def greedy_4ap_free_fast(N, seed):
    """Random greedy 4-AP-free subset of {1,...,N}.  Uses O(N) incremental check."""
    random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A_set = set()
    for x in order:
        if not creates_4ap(x, A_set, N):
            A_set.add(x)
    return A_set


def greedy_dense(N, restarts, seed_base):
    """Best of `restarts` greedy runs (maximise |A|)."""
    best = set()
    for r in range(restarts):
        A = greedy_4ap_free_fast(N, seed=seed_base + r * 997)
        if len(A) > len(best):
            best = A
    return best


# ── Fiber + Conjecture 2 ────────────────────────────────────────────────────

def build_fiber(A_set, d):
    return sorted(x for x in A_set if (x + d) in A_set)


def count_3aps(B):
    """Count 3-APs (a<b<c, a+c=2b) in sorted list B.  O(|B|²)."""
    if len(B) < 3:
        return 0
    B_set = set(B)
    count = 0
    for i in range(len(B)):
        a = B[i]
        for j in range(i + 1, len(B)):
            b = B[j]
            c = 2*b - a
            if c > b and c in B_set:
                count += 1
    return count


def popular_fibers(A_set, N):
    """Return list of (d, fiber, T3, size) for all popular d's."""
    M = len(A_set)
    if M < 2:
        return []
    thr = M * M / (4.0 * N)
    result = []
    for d in range(1, N):
        f = build_fiber(A_set, d)
        sz = len(f)
        if sz >= thr:
            t3 = count_3aps(f)
            result.append((d, f, t3, sz))
    return result


def analyze_c2(A_set, N):
    """
    Full Conjecture 2 analysis for one set A.
    Returns dict with: ce (bool), bad_frac, max_pop_size,
    witness_sizes (list), n_popular.
    """
    pop = popular_fibers(A_set, N)
    if not pop:
        return None

    n_bad = sum(1 for _, _, t3, _ in pop if t3 > 0)
    n_good = sum(1 for _, _, t3, _ in pop if t3 == 0)
    bad_frac = n_bad / len(pop)
    max_pop_size = max(sz for _, _, _, sz in pop)

    # Witness sizes (fibers that save C2)
    witness_sizes = [sz for _, _, t3, sz in pop if t3 == 0]

    ce = (n_good == 0)

    return dict(
        ce=ce,
        bad_frac=bad_frac,
        n_popular=len(pop),
        max_pop_size=max_pop_size,
        witness_sizes=witness_sizes,
        A_sorted=sorted(A_set) if ce else None,
    )


# ── Main verification loop ──────────────────────────────────────────────────

def verify_c2(N_list, trials=300, restarts=3):
    """
    For each N in N_list, run `trials` dense-greedy trials.
    Print table and collect results.
    """
    print("=" * 80)
    print(f"Conjecture 2 Verification  N = {N_list[0]}..{N_list[-1]}")
    print(f"  trials={trials}, restarts={restarts}")
    print("=" * 80)
    hdr = (f"{'N':>5}  {'tested':>7}  {'CEs':>5}  {'max_bad_frac':>13}  "
           f"{'avg|A|':>8}  {'avg|S|':>7}  {'avg_wfrac':>10}  {'min_wfrac':>10}")
    print(hdr)
    print("-" * 80)

    all_rows = []
    all_ces = []

    for N in N_list:
        t_N = time.time()
        n_ce = 0
        n_total = 0
        sum_A = 0
        sum_S = 0
        worst_bf = 0.0
        worst_A = None
        witness_fracs = []   # witness_size / max_pop_size for each good trial

        for trial in range(trials):
            A_set = greedy_dense(N, restarts=restarts,
                                 seed_base=trial * 101 + N * 17)
            M = len(A_set)
            if M < 2:
                continue

            info = analyze_c2(A_set, N)
            if info is None:
                continue

            n_total += 1
            sum_A += M
            sum_S += info['n_popular']

            if info['bad_frac'] > worst_bf:
                worst_bf = info['bad_frac']
                worst_A = sorted(A_set) if info['ce'] else None

            if info['ce']:
                n_ce += 1
                all_ces.append((N, trial, sorted(A_set), info))
                print(f"  *** COUNTEREXAMPLE!  N={N}  trial={trial}  "
                      f"|A|={M}  bad_frac={info['bad_frac']:.4f}")
                print(f"      A={sorted(A_set)}")
            else:
                # Compute witness fracs for this trial
                max_sz = info['max_pop_size']
                if max_sz > 0:
                    fracs = [sz / max_sz for sz in info['witness_sizes']]
                    witness_fracs.extend(fracs)

        avg_A = sum_A / n_total if n_total else 0
        avg_S = sum_S / n_total if n_total else 0
        avg_wf = sum(witness_fracs) / len(witness_fracs) if witness_fracs else 0
        min_wf = min(witness_fracs) if witness_fracs else 0
        dt = time.time() - t_N

        print(f"{N:5d}  {n_total:7d}  {n_ce:5d}  {worst_bf:13.4f}  "
              f"{avg_A:8.2f}  {avg_S:7.2f}  {avg_wf:10.4f}  {min_wf:10.4f}  "
              f"({dt:.1f}s)")

        all_rows.append(dict(
            N=N, n_total=n_total, n_ce=n_ce,
            worst_bf=worst_bf,
            avg_A=avg_A, avg_S=avg_S,
            avg_wf=avg_wf, min_wf=min_wf,
            elapsed=dt,
        ))

    return all_rows, all_ces


def main():
    t0 = time.time()

    # Main verification: N = 550, 600, 650, 700, 750
    N_list = [550, 600, 650, 700, 750]
    rows, ces = verify_c2(N_list, trials=300, restarts=3)

    elapsed = time.time() - t0

    # Print summary
    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    total_ce = sum(r['n_ce'] for r in rows)
    total_tested = sum(r['n_total'] for r in rows)
    max_bf = max(r['worst_bf'] for r in rows)
    max_bf_N = max(rows, key=lambda r: r['worst_bf'])['N']
    print(f"N range: {N_list[0]}..{N_list[-1]}")
    print(f"Total sets tested: {total_tested}")
    print(f"Total CEs: {total_ce}")
    print(f"Max bad_frac: {max_bf:.4f} at N={max_bf_N}")
    print(f"Total elapsed: {elapsed:.1f}s")

    if ces:
        print(f"\nCOUNTEREXAMPLES FOUND: {len(ces)}")
        for N, trial, A, info in ces:
            print(f"  N={N} trial={trial} |A|={len(A)} bad_frac={info['bad_frac']:.4f}")
            print(f"    A={A}")
    else:
        print("\nNo counterexamples found.  Conjecture 2 holds for all tested sets.")

    # Per-N summary
    print("\nPer-N summary:")
    for r in rows:
        print(f"  N={r['N']:4d}: {r['n_total']} trials, {r['n_ce']} CEs, "
              f"bad_frac_max={r['worst_bf']:.4f}, avg|A|={r['avg_A']:.1f}, "
              f"avg_wfrac={r['avg_wf']:.4f}, min_wfrac={r['min_wf']:.4f}")

    return rows, ces


if __name__ == '__main__':
    rows, ces = main()
