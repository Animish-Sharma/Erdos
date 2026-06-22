#!/usr/bin/env python3
"""
Comp3: Conjecture 2 N≤300 + P9-revised N≤200 Extended Verification
====================================================================
Tasks:
  1. Conjecture 2: N=150,175,...,300 — 100 random trials per N
  2. P9-revised N≤200: verify "some argmin popular fiber is 3AP-free"
  3. |S_min| distribution analysis
  4. P9-universal vs P9-revised: which holds?

Definitions:
  fiber(A,d)   = {x∈A : x+d∈A}
  S(A,N)       = {d∈{1..N-1} : |A_d| ≥ M²/(4N)}  (popular diffs)
  T3(B)        = #{(a,b,c): a<b<c, a+c=2b, all in B}  (3-APs)
  S_min(A,N)   = {d∈S: |A_d| = min_{d'∈S}|A_{d'}|}
  d*           = any element of S_min (canonical: first in sorted order)
  P9 CE        = set A where T3(A_{d*}) > 0
  P9-revised   = ∃d'∈S_min with T3(A_{d'})=0
  P9-universal = ∀d'∈S_min, T3(A_{d'})=0
"""

import random
import time
from collections import defaultdict

# ── Core functions ──────────────────────────────────────────────────────────

def is_4ap_free(A_set, A_sorted):
    """Return True if A contains no 4-term AP. O(|A|²)."""
    for i, a in enumerate(A_sorted):
        for j in range(i + 1, len(A_sorted)):
            d = A_sorted[j] - a
            if (a + 2*d) in A_set and (a + 3*d) in A_set:
                return False
    return True


def build_fiber(A_set, d):
    """A_d = {x∈A: x+d∈A}, returned as sorted list."""
    return sorted(x for x in A_set if (x + d) in A_set)


def count_3aps(B):
    """Count 3-APs (a<b<c, a+c=2b) in sorted list B. O(|B|²)."""
    B_set = set(B)
    count = 0
    for i, a in enumerate(B):
        for j in range(i + 1, len(B)):
            b = B[j]
            c = 2*b - a
            if c > b and c in B_set:
                count += 1
    return count


def popular_info(A_set, N):
    """
    Return list of (d, fiber_size, T3_val) for every popular d.
    Popular means |fiber| >= M²/(4N).
    """
    M = len(A_set)
    if M < 2:
        return []
    thr = M * M / (4.0 * N)
    result = []
    for d in range(1, N):
        f = build_fiber(A_set, d)
        if len(f) >= thr:
            result.append((d, len(f), f))
    return result  # (d, size, fiber_list)


def greedy_4ap_free(N, seed):
    """Random greedy 4-AP-free subset of {1,...,N}."""
    random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A_set, A_sorted = set(), []
    for x in order:
        A_set.add(x)
        A_sorted_test = sorted(A_sorted + [x])
        if is_4ap_free(A_set, A_sorted_test):
            A_sorted = A_sorted_test
        else:
            A_set.remove(x)
    return A_set, A_sorted


def greedy_dense(N, restarts, seed_base):
    """Best of `restarts` greedy runs (maximise |A|)."""
    best_set, best_sorted = set(), []
    for r in range(restarts):
        s, srt = greedy_4ap_free(N, seed=seed_base + r * 997)
        if len(s) > len(best_set):
            best_set, best_sorted = s, srt
    return best_set, best_sorted


# ── Task 1: Conjecture 2 to N=300 ───────────────────────────────────────────

def task1_conj2(N_list, trials=100, restarts=3):
    print("=" * 68)
    print("TASK 1: Conjecture 2  N ≤ 300")
    print("=" * 68)
    hdr = f"{'N':>5} {'tested':>7} {'avg|A|':>8} {'avg|S|':>8} "
    hdr += f"{'CEs':>5} {'bad_frac_max':>13} {'max|A|':>8}"
    print(hdr)
    print("-" * 68)

    rows = []
    for N in N_list:
        n_ok = n_ce = 0
        sum_A = sum_S = 0
        max_A = 0
        worst_bf = 0.0
        worst_rec = None

        for trial in range(trials):
            A_set, A_sorted = greedy_dense(N, restarts=restarts,
                                           seed_base=trial * 97 + N * 13)
            M = len(A_set)
            if M < 2:
                continue

            pop = popular_info(A_set, N)
            good = None
            bad_cnt = 0
            for d, sz, f in pop:
                t3 = count_3aps(f)
                if t3 == 0:
                    if good is None:
                        good = d
                else:
                    bad_cnt += 1

            bf = bad_cnt / len(pop) if pop else 0.0
            if bf > worst_bf:
                worst_bf = bf
                worst_rec = (A_sorted, pop)

            sum_A += M
            sum_S += len(pop)
            max_A = max(max_A, M)

            if good is None and pop:
                n_ce += 1
                print(f"  *** CE! N={N} trial={trial} |A|={M} |S|={len(pop)}")
                print(f"      A={A_sorted}")
            else:
                n_ok += 1

        n_total = n_ok + n_ce
        avg_A = sum_A / n_total if n_total else 0
        avg_S = sum_S / n_total if n_total else 0
        print(f"{N:5d} {n_total:7d} {avg_A:8.2f} {avg_S:8.2f} "
              f"{n_ce:5d} {worst_bf:13.4f} {max_A:8d}")
        rows.append(dict(N=N, n_total=n_total, n_ce=n_ce,
                         avg_A=avg_A, avg_S=avg_S,
                         worst_bf=worst_bf, max_A=max_A))
    print()
    return rows


# ── Tasks 2–4: P9-revised extended to N≤200 ────────────────────────────────

def analyze_p9(A_set, N):
    """
    Full P9 analysis for one set A.
    Returns dict with all P9 metrics.
    """
    pop = popular_info(A_set, N)
    if not pop:
        return None

    min_sz = min(sz for _, sz, _ in pop)
    S_min = [(d, f) for d, sz, f in pop if sz == min_sz]

    T3_vals = [(d, count_3aps(f)) for d, f in S_min]
    all_T3 = [t for _, t in T3_vals]
    min_T3 = min(all_T3)
    max_T3 = max(all_T3)

    # Canonical d* = first in sorted S_min
    d_star = min(d for d, _ in S_min)
    T3_dstar = dict(T3_vals)[d_star]

    p9_ce      = (T3_dstar > 0)           # original P9 fails for d*
    p9_revised = (min_T3 == 0)            # some S_min is 3AP-free
    p9_univ    = (max_T3 == 0)            # all S_min are 3AP-free

    return dict(
        n_popular=len(pop),
        min_sz=min_sz,
        n_S_min=len(S_min),
        T3_dstar=T3_dstar,
        min_T3=min_T3,
        max_T3=max_T3,
        p9_ce=p9_ce,
        p9_revised_holds=p9_revised,
        p9_univ_holds=p9_univ,
        S_min_T3=T3_vals,
    )


def tasks234_p9(N_list, trials=200, restarts=5):
    """Tasks 2, 3, 4 combined."""
    print("=" * 68)
    print("TASKS 2–4: P9-revised  N ≤ 200")
    print("=" * 68)
    hdr = (f"{'N':>5} {'tested':>7} {'P9-CEs':>7} {'P9-rev-CEs':>11} "
           f"{'P9-univ-CEs':>12} {'|S_min|=1':>10} {'|S_min|=2':>10} {'|S_min|≥3':>10}")
    print(hdr)
    print("-" * 68)

    all_rows = []
    p9_rev_ces = []   # P9-revised CEs (if any)

    for N in N_list:
        n_total = 0
        p9_ce_cnt = 0
        p9_rev_ce_cnt = 0
        p9_univ_ce_cnt = 0
        smin1 = smin2 = smin3 = 0
        T3_min_vals = []

        for trial in range(trials):
            A_set, _ = greedy_dense(N, restarts=restarts,
                                    seed_base=trial * 13 + N * 7)
            if len(A_set) < 2:
                continue

            info = analyze_p9(A_set, N)
            if info is None:
                continue

            n_total += 1

            if info['p9_ce']:
                p9_ce_cnt += 1
                T3_min_vals.append(info['min_T3'])

                if not info['p9_revised_holds']:
                    p9_rev_ce_cnt += 1
                    p9_rev_ces.append((N, sorted(A_set), info))
                    print(f"  *** P9-REVISED CE! N={N} trial={trial}")
                    print(f"      |S_min|={info['n_S_min']}, min_T3={info['min_T3']}")
                    print(f"      S_min T3 vals: {info['S_min_T3']}")

                if not info['p9_univ_holds']:
                    p9_univ_ce_cnt += 1

                nsm = info['n_S_min']
                if nsm == 1: smin1 += 1
                elif nsm == 2: smin2 += 1
                else: smin3 += 1

        print(f"{N:5d} {n_total:7d} {p9_ce_cnt:7d} {p9_rev_ce_cnt:11d} "
              f"{p9_univ_ce_cnt:12d} {smin1:10d} {smin2:10d} {smin3:10d}")

        all_rows.append(dict(
            N=N, n_total=n_total,
            p9_ce=p9_ce_cnt, p9_rev_ce=p9_rev_ce_cnt,
            p9_univ_ce=p9_univ_ce_cnt,
            smin1=smin1, smin2=smin2, smin3=smin3,
        ))

    print()
    if p9_rev_ces:
        print(f"P9-REVISED COUNTEREXAMPLES FOUND: {len(p9_rev_ces)}")
        for N, A, info in p9_rev_ces[:5]:
            print(f"  N={N} |A|={len(A)} S_min_T3={info['S_min_T3']}")
    else:
        print("P9-revised: 0 CEs found. Empirically HOLDS for N ≤ 200.")

    return all_rows, p9_rev_ces


# ── Detailed |S_min| + T3 distribution ────────────────────────────────────

def smin_detail(N_list, trials=200, restarts=5):
    """Detailed S_min size and T3 distribution in P9 CE cases."""
    print("=" * 68)
    print("S_min Detail (in P9 CE cases)")
    print("=" * 68)
    print(f"{'N':>5}  {'P9-CEs':>7}  {'min_T3=0':>9}  "
          f"{'min_T3=1':>9}  {'min_T3≥2':>9}  {'max_T3 in CE':>13}")
    print("-" * 68)

    for N in N_list:
        ce_cases = []
        for trial in range(trials):
            A_set, _ = greedy_dense(N, restarts=restarts,
                                    seed_base=trial * 23 + N * 31)
            if len(A_set) < 2:
                continue
            info = analyze_p9(A_set, N)
            if info and info['p9_ce']:
                ce_cases.append(info)

        if not ce_cases:
            print(f"{N:5d}  {'0':>7}  {'—':>9}  {'—':>9}  {'—':>9}  {'—':>13}")
            continue

        mt0 = sum(1 for i in ce_cases if i['min_T3'] == 0)
        mt1 = sum(1 for i in ce_cases if i['min_T3'] == 1)
        mt2p = sum(1 for i in ce_cases if i['min_T3'] >= 2)
        max_t3 = max(i['max_T3'] for i in ce_cases)

        print(f"{N:5d}  {len(ce_cases):>7}  {mt0:>9}  {mt1:>9}  {mt2p:>9}  {max_t3:>13}")


# ── Main ────────────────────────────────────────────────────────────────────

def main():
    t0 = time.time()

    # Task 1: Conjecture 2, N=150..300
    N_conj2 = list(range(150, 301, 25))
    t1_rows = task1_conj2(N_conj2, trials=100, restarts=5)

    # Tasks 2–4: P9-revised, N=10..200
    N_p9 = list(range(10, 201, 10))
    t24_rows, p9_rev_ces = tasks234_p9(N_p9, trials=200, restarts=5)

    # Detailed S_min (subset of N's for clarity)
    N_detail = list(range(30, 201, 20))
    smin_detail(N_detail, trials=200, restarts=5)

    elapsed = time.time() - t0

    # ── Summary ──────────────────────────────────────────────────────────────
    print("=" * 68)
    print("SUMMARY")
    print("=" * 68)

    total_ce_c2 = sum(r['n_ce'] for r in t1_rows)
    max_bf = max(r['worst_bf'] for r in t1_rows)
    max_bf_N = max(t1_rows, key=lambda r: r['worst_bf'])['N']
    print(f"Task 1 — Conjecture 2 N≤300:")
    print(f"  Total CEs: {total_ce_c2}")
    print(f"  Max bad_frac: {max_bf:.4f} at N={max_bf_N}")

    total_p9_ce = sum(r['p9_ce'] for r in t24_rows)
    total_p9_rev_ce = sum(r['p9_rev_ce'] for r in t24_rows)
    total_p9_univ_ce = sum(r['p9_univ_ce'] for r in t24_rows)
    print(f"\nTasks 2–4 — P9 analysis N≤200:")
    print(f"  Total P9 CEs (T3(d*)>0): {total_p9_ce}")
    print(f"  Total P9-revised CEs:     {total_p9_rev_ce}")
    print(f"  Total P9-universal CEs:   {total_p9_univ_ce}")

    # Strongest claim
    if total_p9_rev_ce == 0 and total_p9_univ_ce == 0:
        claim = "P9-universal (all S_min fibers 3AP-free when P9 CE)"
    elif total_p9_rev_ce == 0:
        claim = "P9-revised (some S_min fiber 3AP-free)"
    else:
        claim = "Conjecture 2 only (P9-revised has CEs)"
    print(f"\nStrongest supported claim: {claim}")
    print(f"\nTotal elapsed: {elapsed:.1f}s")

    return t1_rows, t24_rows, p9_rev_ces


if __name__ == '__main__':
    t1, t24, p9_rev = main()
