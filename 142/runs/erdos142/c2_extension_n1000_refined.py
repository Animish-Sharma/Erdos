#!/usr/bin/env python3
"""
c2_extension_n1000_refined:
  Task 1 — Conjecture 2 verification N = 800..1000 (200 trials each)
  Task 2 — Refined Conjecture 2: is there ALWAYS a T₃=0 witness with wfrac ≤ 0.40?
            (N=600,700, 100 trials each; full wfrac distribution of ALL T₃=0 witnesses)

Definitions:
  fiber(A,d)      = {x∈A: x+d∈A}
  popular S(A,N)  = {d: |fiber(A,d)| ≥ M²/(4N)}  where M=|A|
  T₃(B)           = #{(a<b<c): a+c=2b, all in B}
  bad_frac        = #{d∈S: T₃>0} / |S|
  wfrac           = |fiber| / max_{d∈S}|fiber(A,d)|   (witness-size fraction)
  Refined C2      = ∃ d∈S with T₃=0 and wfrac ≤ 0.40
"""

import random
import time
from statistics import mean, median, stdev

# ── Fast 4-AP-free incremental check  (O(N) per element)  ──────────────────

def creates_4ap(x, A_set, N):
    """True if adding x to A_set (4-AP-free) would create a 4-AP."""
    d = 1
    while x + 3*d <= N:
        if (x+d) in A_set and (x+2*d) in A_set and (x+3*d) in A_set:
            return True
        d += 1
    d = 1
    while x - d >= 1 and x + 2*d <= N:
        if (x-d) in A_set and (x+d) in A_set and (x+2*d) in A_set:
            return True
        d += 1
    d = 1
    while x - 2*d >= 1 and x + d <= N:
        if (x-2*d) in A_set and (x-d) in A_set and (x+d) in A_set:
            return True
        d += 1
    d = 1
    while x - 3*d >= 1:
        if (x-3*d) in A_set and (x-2*d) in A_set and (x-d) in A_set:
            return True
        d += 1
    return False


def greedy_4ap_free_fast(N, seed):
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
        A = greedy_4ap_free_fast(N, seed=seed_base + r * 997)
        if len(A) > len(best):
            best = A
    return best


# ── Fiber + T₃ ───────────────────────────────────────────────────────────────

def build_fiber(A_set, d):
    return sorted(x for x in A_set if (x + d) in A_set)


def count_3aps(B):
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


def popular_fibers_analyzed(A_set, N):
    """Return list of (d, size, T3) for all popular d's."""
    M = len(A_set)
    if M < 2:
        return []
    thr = M * M / (4.0 * N)
    result = []
    for d in range(1, N):
        f = build_fiber(A_set, d)
        sz = len(f)
        if sz >= thr:
            result.append((d, sz, count_3aps(f)))
    return result


# ── Task 1: C2 verification N = 800..1000 ─────────────────────────────────

def task1_c2_n1000(N_list, trials=200, restarts=2):
    print("=" * 80)
    print(f"TASK 1: Conjecture 2  N = {N_list[0]}..{N_list[-1]}")
    print(f"  trials={trials}, restarts={restarts}")
    print("=" * 80)
    hdr = (f"{'N':>5}  {'tested':>7}  {'CEs':>5}  {'max_bad_frac':>13}  "
           f"{'avg|A|':>8}  {'avg|S|':>7}  {'avg_wfrac':>10}  {'min_wfrac':>10}  time")
    print(hdr)
    print("-" * 80)

    rows = []
    for N in N_list:
        t_N = time.time()
        n_ce = 0
        n_total = 0
        sum_A = sum_S = 0
        worst_bf = 0.0
        witness_fracs = []
        ces_found = []

        for trial in range(trials):
            A_set = greedy_dense(N, restarts=restarts,
                                 seed_base=trial * 101 + N * 17)
            M = len(A_set)
            if M < 2:
                continue

            pop = popular_fibers_analyzed(A_set, N)
            if not pop:
                continue

            n_total += 1
            sum_A += M
            sum_S += len(pop)

            n_bad = sum(1 for _, _, t3 in pop if t3 > 0)
            bf = n_bad / len(pop)
            if bf > worst_bf:
                worst_bf = bf

            max_sz = max(sz for _, sz, _ in pop)
            good = [(sz, t3) for _, sz, t3 in pop if t3 == 0]

            if not good:
                n_ce += 1
                ces_found.append((N, trial, sorted(A_set), bf))
                print(f"  *** CE!  N={N} trial={trial} |A|={M} bad_frac={bf:.4f}")
                print(f"      A={sorted(A_set)}")
            else:
                if max_sz > 0:
                    witness_fracs.extend(sz / max_sz for sz, _ in good)

        dt = time.time() - t_N
        avg_A = sum_A / n_total if n_total else 0
        avg_S = sum_S / n_total if n_total else 0
        avg_wf = mean(witness_fracs) if witness_fracs else 0
        min_wf = min(witness_fracs) if witness_fracs else 0

        print(f"{N:5d}  {n_total:7d}  {n_ce:5d}  {worst_bf:13.4f}  "
              f"{avg_A:8.2f}  {avg_S:7.2f}  {avg_wf:10.4f}  {min_wf:10.4f}  {dt:.1f}s")
        rows.append(dict(
            N=N, n_total=n_total, n_ce=n_ce, worst_bf=worst_bf,
            avg_A=avg_A, avg_S=avg_S, avg_wf=avg_wf, min_wf=min_wf, elapsed=dt,
        ))

    print()
    return rows


# ── Task 2: Refined Conjecture 2 ─────────────────────────────────────────────

def task2_refined_conjecture(N_list, trials=100, restarts=2, threshold=0.40):
    """
    For each N, for each trial, collect wfrac for ALL T₃=0 witnesses.
    Check: is there always a T₃=0 witness with wfrac ≤ threshold?
    """
    print("=" * 80)
    print(f"TASK 2: Refined Conjecture 2  (threshold={threshold})")
    print(f"  N = {N_list}, trials={trials}, restarts={restarts}")
    print("=" * 80)

    all_results = []

    for N in N_list:
        t_N = time.time()
        n_total = 0
        n_ce = 0                      # T₃=0 witness exists but all wfrac > threshold
        n_refined_ce = 0              # NOT POSSIBLE since this is after a T₃=0 witness exists
        all_trial_wfracs = []         # list of lists: all T₃=0 witness wfracs per trial
        per_trial_min_wfrac = []      # min wfrac over T₃=0 witnesses per trial
        n_refined_fail = 0            # trials where ALL T₃=0 witnesses have wfrac > threshold

        for trial in range(trials):
            A_set = greedy_dense(N, restarts=restarts,
                                 seed_base=trial * 113 + N * 23)
            M = len(A_set)
            if M < 2:
                continue

            pop = popular_fibers_analyzed(A_set, N)
            if not pop:
                continue

            n_total += 1
            max_sz = max(sz for _, sz, _ in pop)

            # All T₃=0 witnesses and their wfracs
            witnesses = [(d, sz, sz / max_sz if max_sz > 0 else 0)
                         for d, sz, t3 in pop if t3 == 0]

            if not witnesses:
                # C2 counterexample (should not happen given prior evidence)
                n_ce += 1
                continue

            wfracs = [wf for _, _, wf in witnesses]
            all_trial_wfracs.append(wfracs)

            min_wf = min(wfracs)
            per_trial_min_wfrac.append(min_wf)

            if min_wf > threshold:
                n_refined_fail += 1
                # Print details of this failure case
                print(f"  REFINED-CE? N={N} trial={trial}: all {len(witnesses)} witnesses "
                      f"have wfrac > {threshold:.2f} (min={min_wf:.4f})")
                print(f"    wfracs = {[f'{w:.4f}' for w in sorted(wfracs)]}")

        dt = time.time() - t_N

        # Flatten all witness wfracs for distribution
        flat = [w for ws in all_trial_wfracs for w in ws]
        n_witnesses_per_trial = [len(ws) for ws in all_trial_wfracs]

        print(f"\nN={N}: {n_total} trials, {n_ce} C2-CEs (should be 0)")
        print(f"  Refined-CE (all T3=0 witnesses wfrac>{threshold}): {n_refined_fail}/{n_total} "
              f"({100*n_refined_fail/n_total:.1f}%)")
        print(f"  Per-trial min_wfrac: mean={mean(per_trial_min_wfrac):.4f}, "
              f"min={min(per_trial_min_wfrac):.4f}, max={max(per_trial_min_wfrac):.4f}")
        if flat:
            print(f"  ALL witness wfracs (n={len(flat)}): mean={mean(flat):.4f}, "
                  f"median={median(flat):.4f}, min={min(flat):.4f}, max={max(flat):.4f}")
            if len(flat) > 1:
                print(f"    stdev={stdev(flat):.4f}")
        print(f"  Avg witnesses per trial: {mean(n_witnesses_per_trial):.1f} "
              f"(range {min(n_witnesses_per_trial)}..{max(n_witnesses_per_trial)})")
        print(f"  Time: {dt:.1f}s")

        # wfrac histogram (bins of 0.10)
        bins = [0.0, 0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.01]
        labels = ['≤0.10','≤0.20','≤0.30','≤0.40','≤0.50','≤0.60','≤0.70','≤0.80','≤0.90','≤1.00']
        print(f"\n  wfrac distribution (all witnesses, N={N}):")
        counts = [0] * len(labels)
        for w in flat:
            for i, b in enumerate(bins[1:]):
                if w < b:
                    counts[i] += 1
                    break
        for label, cnt in zip(labels, counts):
            bar = '#' * (cnt * 40 // max(counts) if counts else 0)
            print(f"    {label}: {cnt:5d}  {bar}")

        print()

        all_results.append(dict(
            N=N, n_total=n_total, n_ce=n_ce,
            n_refined_fail=n_refined_fail,
            per_trial_min_wfrac=per_trial_min_wfrac,
            all_wfracs=flat,
            elapsed=dt,
        ))

    return all_results


# ── Main ────────────────────────────────────────────────────────────────────

def main():
    t0 = time.time()

    # Task 1: Conjecture 2 N=800..1000
    N_task1 = [800, 850, 900, 950, 1000]
    rows1 = task1_c2_n1000(N_task1, trials=200, restarts=2)

    # Task 2: Refined Conjecture 2 at N=600,700
    N_task2 = [600, 700]
    rows2 = task2_refined_conjecture(N_task2, trials=100, restarts=2, threshold=0.40)

    elapsed = time.time() - t0

    # ── Summary ─────────────────────────────────────────────────────────────
    print("=" * 80)
    print("FINAL SUMMARY")
    print("=" * 80)

    total_t1 = sum(r['n_total'] for r in rows1)
    total_ce_t1 = sum(r['n_ce'] for r in rows1)
    max_bf = max(r['worst_bf'] for r in rows1)
    max_bf_N = max(rows1, key=lambda r: r['worst_bf'])['N']
    print(f"Task 1 — Conjecture 2 N≤1000:")
    print(f"  N range: {N_task1[0]}..{N_task1[-1]}")
    print(f"  Total sets tested: {total_t1}")
    print(f"  Total CEs: {total_ce_t1}")
    print(f"  Max bad_frac: {max_bf:.4f} at N={max_bf_N}")

    print()
    print(f"Task 2 — Refined Conjecture 2:")
    for r in rows2:
        n = r['n_total']
        rf = r['n_refined_fail']
        mn = min(r['per_trial_min_wfrac'])
        mu = mean(r['per_trial_min_wfrac'])
        print(f"  N={r['N']}: {n} trials, refined-CE (all wfrac>0.40): {rf}/{n} "
              f"({100*rf/n:.1f}%), min_wfrac in trial: {mn:.4f}, avg: {mu:.4f}")

    print(f"\nTotal elapsed: {elapsed:.1f}s")
    return rows1, rows2


if __name__ == '__main__':
    rows1, rows2 = main()
