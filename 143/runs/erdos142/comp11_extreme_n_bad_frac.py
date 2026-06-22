#!/usr/bin/env python3
"""
comp11_extreme_n_bad_frac.py — Extend bad_frac + min_wfrac to N=150000..200000

Extends Erdős Problem 142 Conjecture 2 computational verification.

Definitions:
  A ⊆ {1,...,N}  4-AP-free (greedy, best of 2 random orderings)
  M = |A|
  A_d = fiber(A, d) = {x∈A : x+d∈A}
  S   = popular differences = {d : |A_d| ≥ M²/(4N)}
  T₃(B) = #{(a<b<c) : a,b,c∈B, a+c=2b}   (non-trivial 3-APs)
  bad_frac  = #{d∈S : T₃(A_d)>0} / |S|
  wfrac(d)  = |A_d| / max_{d'∈S}|A_{d'}|
  min_wfrac = min over T₃=0 witnesses d of wfrac(d)   (per trial)

Prior results:
  N=75000:  avg_bad_frac=0.9795 avg_min_wfrac=0.2041 avg_witnesses=1299
  N=100000: avg_bad_frac=0.9832 avg_min_wfrac=0.2000 avg_witnesses=1415

Schedule:
  N=150000: 1 trial
  N=200000: 1 trial (if time allows; estimates ~1200-2400s per trial)
"""

import random
import time
from collections import Counter
from statistics import mean, stdev

# ── Greedy 4-AP-free construction ─────────────────────────────────────────────

def creates_4ap(x, A_set, N):
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
    random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A_set = set()
    for x in order:
        if not creates_4ap(x, A_set, N):
            A_set.add(x)
    return A_set


def greedy_dense(N, restarts, seed_base):
    best = set()
    for r in range(restarts):
        A = greedy_4ap_free(N, seed=seed_base + r * 997)
        if len(A) > len(best):
            best = A
    return best


# ── Fiber analysis ────────────────────────────────────────────────────────────

def count_3aps(B_list, B_set):
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
    A_list = sorted(A_set)
    M = len(A_list)
    if M < 2:
        return None
    thr = M * M / (4.0 * N)

    fiber_sizes = Counter()
    for i in range(M):
        x = A_list[i]
        for j in range(i + 1, M):
            fiber_sizes[A_list[j] - x] += 1

    popular_ds = [d for d, sz in fiber_sizes.items() if sz >= thr]
    n_popular = len(popular_ds)
    if n_popular == 0:
        return None

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
    witness_wfracs = [sz / max_popular for sz in good_sizes] if max_popular > 0 else []

    return dict(
        bad_frac=bad_frac,
        max_popular=max_popular,
        n_popular=n_popular,
        witness_wfracs=witness_wfracs,
        n_witnesses=len(witness_wfracs),
        M=M,
    )


# ── Single trial ──────────────────────────────────────────────────────────────

def run_one_trial(N, trial_idx, restarts=2, verbose=True):
    seed_base = trial_idx * 101 + N * 17
    t0 = time.time()
    print(f"    building 4AP-free set...", flush=True)
    A_set = greedy_dense(N, restarts=restarts, seed_base=seed_base)
    t_build = time.time() - t0
    print(f"    built M={len(A_set)} in {t_build:.1f}s; running fiber analysis...", flush=True)
    r = analyze_trial(A_set, N)
    elapsed = time.time() - t0
    if r is not None and verbose:
        min_wf = min(r['witness_wfracs']) if r['witness_wfracs'] else float('nan')
        print(f"  trial {trial_idx+1}: M={r['M']} bad_frac={r['bad_frac']:.4f} "
              f"witnesses={r['n_witnesses']} min_wfrac={min_wf:.4f} ({elapsed:.1f}s)",
              flush=True)
    return r, elapsed


def summarise(results, N, elapsed_block):
    if not results:
        return None
    bad_fracs  = [r['bad_frac']    for r in results]
    max_pops   = [r['max_popular'] for r in results]
    Ms         = [r['M']          for r in results]
    n_wits     = [r['n_witnesses'] for r in results]
    per_min    = [min(r['witness_wfracs']) for r in results if r['witness_wfracs']]
    n_ce       = sum(1 for r in results if r['n_witnesses'] == 0)
    return dict(
        N=N, trials=len(results), n_ce=n_ce,
        avg_bad_frac=mean(bad_fracs), max_bad_frac=max(bad_fracs),
        std_bad_frac=stdev(bad_fracs) if len(bad_fracs) > 1 else 0.0,
        avg_min_wfrac=(mean(per_min) if per_min else float('nan')),
        min_min_wfrac=(min(per_min)  if per_min else float('nan')),
        max_min_wfrac=(max(per_min)  if per_min else float('nan')),
        avg_witnesses=mean(n_wits), min_witnesses=min(n_wits), max_witnesses=max(n_wits),
        avg_max_popular=mean(max_pops), avg_M=mean(Ms), elapsed=elapsed_block,
    )


def print_summary(s):
    rng = f"[{s['min_min_wfrac']:.4f},{s['max_min_wfrac']:.4f}]"
    print(f"\n  SUMMARY N={s['N']}: trials={s['trials']} "
          f"avg_bf={s['avg_bad_frac']:.4f} max_bf={s['max_bad_frac']:.4f} "
          f"avg_mwf={s['avg_min_wfrac']:.4f} range_mwf={rng} "
          f"avg_wit={s['avg_witnesses']:.1f} min_wit={s['min_witnesses']} "
          f"CEs={s['n_ce']} time={s['elapsed']:.1f}s",
          flush=True)


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    # Time budget is generous (~7.5h remaining per orchestrator note).
    # N=150000: estimate ~600-800s per trial (build ~350s + analysis ~300s)
    # N=200000: estimate ~1200-2000s per trial
    # We'll run 1 trial each; add 2nd at N=150000 if fast.
    TOTAL_LIMIT = 7200.0          # 2 hours total cap for safety
    SECOND_TRIAL_THRESHOLD = 600.0  # add 2nd trial at N=150k if first < 10 min

    t_global = time.time()
    summaries = []

    print("comp11_extreme_n: bad_frac + min_wfrac at N=150000..200000", flush=True)
    print("=" * 120, flush=True)
    print("Prior: N=100000→bad_frac=0.9832, avg_min_wfrac=0.2000, witnesses=1415", flush=True)
    print("=" * 120, flush=True)

    # ── N = 150000 ────────────────────────────────────────────────────────────
    N = 150000
    print(f"\n[N={N}] starting trial 1...", flush=True)
    t_block = time.time()
    r1, t1 = run_one_trial(N, trial_idx=0)
    results = [r1] if r1 is not None else []

    # Optionally add a 2nd trial
    if t1 < SECOND_TRIAL_THRESHOLD and (time.time() - t_global) + t1 < TOTAL_LIMIT - 120:
        print(f"  [N={N}] trial 1 took {t1:.1f}s < {SECOND_TRIAL_THRESHOLD:.0f}s — running trial 2...",
              flush=True)
        r2, _ = run_one_trial(N, trial_idx=1)
        if r2 is not None:
            results.append(r2)

    s = summarise(results, N, time.time() - t_block)
    if s:
        summaries.append(s)
        print_summary(s)

    # ── N = 200000 ────────────────────────────────────────────────────────────
    N = 200000
    elapsed_so_far = time.time() - t_global
    if elapsed_so_far > TOTAL_LIMIT - 120:
        print(f"\n[N={N}] SKIPPED — budget exhausted ({elapsed_so_far:.0f}s)", flush=True)
    else:
        print(f"\n[N={N}] starting trial 1... (elapsed so far: {elapsed_so_far:.1f}s)", flush=True)
        t_block = time.time()
        r1, t1 = run_one_trial(N, trial_idx=0)
        results = [r1] if r1 is not None else []

        # Optionally add a 2nd trial
        if t1 < SECOND_TRIAL_THRESHOLD and (time.time() - t_global) + t1 < TOTAL_LIMIT - 120:
            print(f"  [N={N}] trial 1 took {t1:.1f}s — running trial 2...", flush=True)
            r2, _ = run_one_trial(N, trial_idx=1)
            if r2 is not None:
                results.append(r2)

        s = summarise(results, N, time.time() - t_block)
        if s:
            summaries.append(s)
            print_summary(s)

    # ── Totals ────────────────────────────────────────────────────────────────
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
