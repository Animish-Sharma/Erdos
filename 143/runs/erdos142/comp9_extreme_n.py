#!/usr/bin/env python3
"""
comp9_extreme_n.py — Extend bad_frac + min_wfrac measurements to N=40000..50000

Extends Erdős Problem 142 Conjecture 2 computational verification.

Definitions:
  A ⊆ {1,...,N}  4-AP-free (greedy, best of 2 random orderings)
  M = |A|
  A_d = fiber(A, d) = {x∈A : x+d∈A}
  S   = popular differences = {d : |A_d| ≥ M²/(4N)}
  T₃(B) = #{(a<b<c) : a,b,c∈B, a+c=2b}   (non-trivial 3-APs)
  bad_frac    = #{d∈S : T₃(A_d)>0} / |S|
  wfrac(d)    = |A_d| / max_{d'∈S}|A_{d'}|
  min_wfrac   = min over T₃=0 witnesses d of wfrac(d)   (per trial)

Prior results (cumulative):
  N=20000: avg_bad_frac=0.9576 avg_min_wfrac=0.2004 avg_witnesses=712
  N=30000: avg_bad_frac=0.9626 avg_min_wfrac=0.1935 avg_witnesses=942

Schedule for this run:
  N=40000: 2 trials
  N=50000: 1 trial  (skipped if single trial takes >8 min or total >10 min)
"""

import random
import sys
import time
from collections import Counter
from statistics import mean, stdev

# ── Greedy 4-AP-free construction ─────────────────────────────────────────────

def creates_4ap(x, A_set, N):
    """True if adding x to A_set (currently 4-AP-free) creates a 4-AP."""
    d = 1
    while x + 3 * d <= N:
        if (x + d) in A_set and (x + 2 * d) in A_set and (x + 3 * d) in A_set:
            return True
        d += 1
    d = 1
    while x - d >= 1 and x + 2 * d <= N:
        if (x - d) in A_set and (x + d) in A_set and (x + 2 * d) in A_set:
            return True
        d += 1
    d = 1
    while x - 2 * d >= 1 and x + d <= N:
        if (x - 2 * d) in A_set and (x - d) in A_set and (x + d) in A_set:
            return True
        d += 1
    d = 1
    while x - 3 * d >= 1:
        if (x - 3 * d) in A_set and (x - 2 * d) in A_set and (x - d) in A_set:
            return True
        d += 1
    return False


def greedy_4ap_free(N, seed):
    """Single greedy pass with random ordering."""
    random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A_set = set()
    for x in order:
        if not creates_4ap(x, A_set, N):
            A_set.add(x)
    return A_set


def greedy_dense(N, restarts, seed_base):
    """Run `restarts` greedy constructions, return the densest."""
    best = set()
    for r in range(restarts):
        A = greedy_4ap_free(N, seed=seed_base + r * 997)
        if len(A) > len(best):
            best = A
    return best


# ── Fiber analysis ────────────────────────────────────────────────────────────

def count_3aps(B_list, B_set):
    """Count triples (a<b<c) with a+c=2b, all in B.  O(|B|²)."""
    n = len(B_list)
    if n < 3:
        return 0
    count = 0
    for i in range(n):
        a = B_list[i]
        for j in range(i + 1, n):
            b = B_list[j]
            c = 2 * b - a
            if c > b and c in B_set:
                count += 1
    return count


def analyze_trial(A_set, N):
    """
    Returns dict with bad_frac, witness counts, wfracs, etc.
    Returns None if A is too small.
    """
    A_list = sorted(A_set)
    M = len(A_list)
    if M < 2:
        return None
    thr = M * M / (4.0 * N)

    # Step 1: fiber sizes via pairwise differences  O(M²)
    fiber_sizes = Counter()
    for i in range(M):
        x = A_list[i]
        for j in range(i + 1, M):
            fiber_sizes[A_list[j] - x] += 1

    # Step 2: popular d's
    popular_ds = [d for d, sz in fiber_sizes.items() if sz >= thr]
    n_popular = len(popular_ds)
    if n_popular == 0:
        return None

    # Step 3: for each popular d, count T₃
    n_bad = 0
    max_popular = 0
    good_sizes = []

    for d in popular_ds:
        fiber = [x for x in A_list if (x + d) in A_set]
        sz = len(fiber)
        if sz > max_popular:
            max_popular = sz
        if count_3aps(fiber, set(fiber)) > 0:
            n_bad += 1
        else:
            good_sizes.append(sz)

    bad_frac = n_bad / n_popular

    if max_popular > 0:
        witness_wfracs = [sz / max_popular for sz in good_sizes]
    else:
        witness_wfracs = []

    return dict(
        bad_frac=bad_frac,
        max_popular=max_popular,
        n_popular=n_popular,
        witness_wfracs=witness_wfracs,
        n_witnesses=len(witness_wfracs),
        M=M,
    )


# ── Per-N computation ─────────────────────────────────────────────────────────

def run_N(N, trials, restarts=2, verbose=True):
    """Run `trials` trials at given N.  Returns summary dict."""
    t_start = time.time()
    results = []
    n_ce = 0

    for trial in range(trials):
        seed_base = trial * 101 + N * 17
        t_trial = time.time()
        A_set = greedy_dense(N, restarts=restarts, seed_base=seed_base)
        r = analyze_trial(A_set, N)
        if r is None:
            continue
        if r['n_witnesses'] == 0:
            n_ce += 1
            if verbose:
                print(f"  *** C2-CE! N={N} trial={trial} |A|={r['M']} "
                      f"bad_frac={r['bad_frac']:.4f}", flush=True)
        results.append(r)
        if verbose:
            elapsed_trial = time.time() - t_trial
            min_wf = min(r['witness_wfracs']) if r['witness_wfracs'] else float('nan')
            print(f"  trial {trial+1}/{trials}: M={r['M']} bad_frac={r['bad_frac']:.4f} "
                  f"witnesses={r['n_witnesses']} min_wfrac={min_wf:.4f} ({elapsed_trial:.1f}s)",
                  flush=True)

    elapsed = time.time() - t_start

    if not results:
        return None

    bad_fracs    = [r['bad_frac']    for r in results]
    max_populars = [r['max_popular'] for r in results]
    Ms           = [r['M']          for r in results]
    n_wit_list   = [r['n_witnesses'] for r in results]

    per_trial_min = [min(r['witness_wfracs'])
                     for r in results if r['witness_wfracs']]

    return dict(
        N=N,
        trials=len(results),
        n_ce=n_ce,
        avg_bad_frac=mean(bad_fracs),
        max_bad_frac=max(bad_fracs),
        std_bad_frac=stdev(bad_fracs) if len(bad_fracs) > 1 else 0.0,
        avg_min_wfrac=(mean(per_trial_min) if per_trial_min else float('nan')),
        min_min_wfrac=(min(per_trial_min)  if per_trial_min else float('nan')),
        max_min_wfrac=(max(per_trial_min)  if per_trial_min else float('nan')),
        avg_witnesses=mean(n_wit_list),
        min_witnesses=min(n_wit_list),
        max_witnesses=max(n_wit_list),
        avg_max_popular=mean(max_populars),
        avg_M=mean(Ms),
        elapsed=elapsed,
    )


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    # N=40000: 2 trials; N=50000: 1 trial
    # Skip N=50000 if total elapsed > 600s or single trial estimate > 480s
    schedule = [
        (40000, 2),
        (50000, 1),
    ]

    TOTAL_LIMIT   = 600.0   # 10 minutes total
    TRIAL_LIMIT   = 480.0   # 8 minutes per single trial

    t_global = time.time()
    summaries = []

    print("comp9_extreme_n: bad_frac + min_wfrac at N=40000..50000", flush=True)
    print("=" * 120, flush=True)
    print("Prior data: N=20000→0.9576, N=30000→0.9626 (avg_bad_frac)", flush=True)
    print("=" * 120, flush=True)

    for N, trials in schedule:
        elapsed_so_far = time.time() - t_global

        if N == 50000 and elapsed_so_far > TOTAL_LIMIT:
            print(f"\n[N={N}] SKIPPED — total time limit reached ({elapsed_so_far:.0f}s > {TOTAL_LIMIT:.0f}s)",
                  flush=True)
            continue

        print(f"\n[N={N}] running {trials} trial(s)... (elapsed so far: {elapsed_so_far:.1f}s)",
              flush=True)
        t_block = time.time()

        # For N=50000 with 1 trial, do a single-trial time check after first trial
        if N == 50000:
            # Time the first (only) trial, skip if it would exceed limit
            seed_base = 0 * 101 + N * 17
            t_trial = time.time()
            A_set = greedy_dense(N, restarts=2, seed_base=seed_base)
            trial_build_time = time.time() - t_trial
            if trial_build_time > TRIAL_LIMIT:
                print(f"\n[N={N}] SKIPPED after timing — greedy build alone took {trial_build_time:.1f}s > {TRIAL_LIMIT:.0f}s",
                      flush=True)
                continue
            r = analyze_trial(A_set, N)
            elapsed_trial = time.time() - t_trial
            results_50k = []
            n_ce_50k = 0
            if r is not None:
                if r['n_witnesses'] == 0:
                    n_ce_50k += 1
                    print(f"  *** C2-CE! N={N} trial=1 |A|={r['M']} bad_frac={r['bad_frac']:.4f}", flush=True)
                results_50k.append(r)
                min_wf = min(r['witness_wfracs']) if r['witness_wfracs'] else float('nan')
                print(f"  trial 1/1: M={r['M']} bad_frac={r['bad_frac']:.4f} "
                      f"witnesses={r['n_witnesses']} min_wfrac={min_wf:.4f} ({elapsed_trial:.1f}s)",
                      flush=True)
            elapsed_block = time.time() - t_block
            if results_50k:
                bad_fracs  = [r['bad_frac']    for r in results_50k]
                max_pops   = [r['max_popular'] for r in results_50k]
                Ms         = [r['M']          for r in results_50k]
                n_wits     = [r['n_witnesses'] for r in results_50k]
                per_min    = [min(r['witness_wfracs']) for r in results_50k if r['witness_wfracs']]
                s = dict(
                    N=N, trials=1, n_ce=n_ce_50k,
                    avg_bad_frac=mean(bad_fracs), max_bad_frac=max(bad_fracs),
                    std_bad_frac=0.0,
                    avg_min_wfrac=(mean(per_min) if per_min else float('nan')),
                    min_min_wfrac=(min(per_min)  if per_min else float('nan')),
                    max_min_wfrac=(max(per_min)  if per_min else float('nan')),
                    avg_witnesses=mean(n_wits), min_witnesses=min(n_wits), max_witnesses=max(n_wits),
                    avg_max_popular=mean(max_pops), avg_M=mean(Ms), elapsed=elapsed_block,
                )
                summaries.append(s)
                rng = f"[{s['min_min_wfrac']:.4f},{s['max_min_wfrac']:.4f}]"
                print(f"\n  SUMMARY N={s['N']}: trials={s['trials']} "
                      f"avg_bf={s['avg_bad_frac']:.4f} max_bf={s['max_bad_frac']:.4f} "
                      f"avg_mwf={s['avg_min_wfrac']:.4f} range_mwf={rng} "
                      f"avg_wit={s['avg_witnesses']:.1f} min_wit={s['min_witnesses']} "
                      f"CEs={s['n_ce']} time={elapsed_block:.1f}s", flush=True)
            continue

        # Standard path for N=40000
        s = run_N(N, trials=trials, restarts=2, verbose=True)

        if s is None:
            print(f"  FAILED (no valid results)", flush=True)
            continue

        summaries.append(s)
        rng = f"[{s['min_min_wfrac']:.4f},{s['max_min_wfrac']:.4f}]"
        print(f"\n  SUMMARY N={s['N']}: trials={s['trials']} "
              f"avg_bf={s['avg_bad_frac']:.4f} max_bf={s['max_bad_frac']:.4f} "
              f"avg_mwf={s['avg_min_wfrac']:.4f} range_mwf={rng} "
              f"avg_wit={s['avg_witnesses']:.1f} min_wit={s['min_witnesses']} "
              f"CEs={s['n_ce']} time={time.time()-t_block:.1f}s",
              flush=True)

    total_elapsed = time.time() - t_global
    print(f"\nTotal elapsed: {total_elapsed:.1f}s", flush=True)

    print("\n=== MACHINE-READABLE SUMMARY ===", flush=True)
    for s in summaries:
        print(f"N={s['N']} trials={s['trials']} avg_bad_frac={s['avg_bad_frac']:.6f} "
              f"max_bad_frac={s['max_bad_frac']:.6f} "
              f"avg_min_wfrac={s['avg_min_wfrac']:.6f} "
              f"min_min_wfrac={s['min_min_wfrac']:.6f} "
              f"max_min_wfrac={s['max_min_wfrac']:.6f} "
              f"avg_witnesses={s['avg_witnesses']:.2f} "
              f"min_witnesses={s['min_witnesses']} "
              f"max_witnesses={s['max_witnesses']} "
              f"avg_max_popular={s['avg_max_popular']:.2f} "
              f"avg_M={s['avg_M']:.2f} "
              f"n_ce={s['n_ce']} "
              f"elapsed={s['elapsed']:.2f}",
              flush=True)
    print("=== END SUMMARY ===", flush=True)

    return summaries


if __name__ == '__main__':
    main()
