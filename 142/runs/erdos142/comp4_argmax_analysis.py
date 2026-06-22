#!/usr/bin/env python3
"""
Comp4: argmax Fiber Analysis + N≤500 Conjecture 2 + P9-rev Threshold
=====================================================================
Tasks:
  1. argmax |A_d| analysis: does the most-popular fiber tend to be 3AP-free?
  2. Conjecture 2 N=350,400,450,500 (50 trials each)
  3. P9-rev threshold: N=51..70 and N∈{25,28,30,32,35,38,40,42,45,48,50}
  4. C2 witness analysis in P9-rev CEs: which popular d saves C2?
"""

import random
import time
from collections import defaultdict

# ── Core primitives ──────────────────────────────────────────────────────────

def is_4ap_free(A_set, A_sorted):
    for i, a in enumerate(A_sorted):
        for j in range(i + 1, len(A_sorted)):
            d = A_sorted[j] - a
            if (a + 2*d) in A_set and (a + 3*d) in A_set:
                return False
    return True


def build_fiber(A_set, d):
    return sorted(x for x in A_set if (x + d) in A_set)


def count_3aps(B):
    """Count 3-APs (a<b<c, a+c=2b) in sorted list B.  O(|B|²)."""
    B_set = set(B)
    count = 0
    for i, a in enumerate(B):
        for j in range(i + 1, len(B)):
            b = B[j]
            c = 2*b - a
            if c > b and c in B_set:
                count += 1
    return count


def greedy_4ap_free(N, seed):
    random.seed(seed)
    order = list(range(1, N + 1))
    random.shuffle(order)
    A_set, A_sorted = set(), []
    for x in order:
        A_set.add(x)
        cand = sorted(A_sorted + [x])
        if is_4ap_free(A_set, cand):
            A_sorted = cand
        else:
            A_set.remove(x)
    return A_set, A_sorted


def greedy_dense(N, restarts, seed_base):
    best_set, best_sorted = set(), []
    for r in range(restarts):
        s, sr = greedy_4ap_free(N, seed=seed_base + r * 997)
        if len(s) > len(best_set):
            best_set, best_sorted = s, sr
    return best_set, best_sorted


def popular_fibers(A_set, N):
    """
    Return list of (d, fiber, size) for all popular d's.
    Popular: size >= M²/(4N).
    """
    M = len(A_set)
    if M < 2:
        return []
    thr = M * M / (4.0 * N)
    result = []
    for d in range(1, N):
        f = build_fiber(A_set, d)
        sz = len(f)
        if sz >= thr:
            result.append((d, f, sz))
    return result


# ── Task 1: argmax fiber analysis ───────────────────────────────────────────

def task1_argmax_analysis(N_list, trials=200, restarts=3):
    print("=" * 72)
    print("TASK 1: argmax |A_d| Analysis  (N=10..200)")
    print("=" * 72)
    hdr = (f"{'N':>5} {'n':>5} {'max T3=0%':>11} {'min T3=0%':>11} "
           f"{'rnd T3=0%':>11} {'avg T3(max)':>12} {'avg T3(min)':>12} {'avg T3(rnd)':>12}")
    print(hdr)
    print("-" * 72)

    rows = []
    for N in N_list:
        n = 0
        max_t3_zero = min_t3_zero = rnd_t3_zero = 0
        sum_max = sum_min = sum_rnd = 0.0

        for trial in range(trials):
            A_set, _ = greedy_dense(N, restarts=restarts,
                                    seed_base=trial * 97 + N * 13)
            if len(A_set) < 2:
                continue

            pop = popular_fibers(A_set, N)
            if not pop:
                continue
            n += 1

            # argmax and argmin by fiber size
            pop_by_sz = sorted(pop, key=lambda x: x[2])
            d_min, f_min, sz_min = pop_by_sz[0]
            d_max, f_max, sz_max = pop_by_sz[-1]
            # random popular d
            d_rnd, f_rnd, _ = random.choice(pop)

            t3_max = count_3aps(f_max)
            t3_min = count_3aps(f_min)
            t3_rnd = count_3aps(f_rnd)

            if t3_max == 0: max_t3_zero += 1
            if t3_min == 0: min_t3_zero += 1
            if t3_rnd == 0: rnd_t3_zero += 1
            sum_max += t3_max
            sum_min += t3_min
            sum_rnd += t3_rnd

        def pct(k): return 100 * k / n if n else float('nan')
        def avg(s): return s / n if n else float('nan')

        row = dict(N=N, n=n,
                   pct_max=pct(max_t3_zero),
                   pct_min=pct(min_t3_zero),
                   pct_rnd=pct(rnd_t3_zero),
                   avg_max=avg(sum_max),
                   avg_min=avg(sum_min),
                   avg_rnd=avg(sum_rnd))
        rows.append(row)
        print(f"{N:5d} {n:5d} {pct(max_t3_zero):10.2f}% {pct(min_t3_zero):10.2f}% "
              f"{pct(rnd_t3_zero):10.2f}% {avg(sum_max):12.4f} "
              f"{avg(sum_min):12.4f} {avg(sum_rnd):12.4f}")
    print()
    return rows


# ── Task 2: C2 N≤500 ────────────────────────────────────────────────────────

def task2_c2_n500(N_list, trials=50, restarts=3):
    print("=" * 72)
    print("TASK 2: Conjecture 2  N ≤ 500")
    print("=" * 72)
    print(f"{'N':>6} {'tested':>7} {'CEs':>5} {'max bad_frac':>13} {'avg|A|':>8} {'avg|S|':>8}")
    print("-" * 52)

    rows = []
    for N in N_list:
        n = n_ce = 0
        sum_A = sum_S = 0
        worst_bf = 0.0

        for trial in range(trials):
            A_set, _ = greedy_dense(N, restarts=restarts,
                                    seed_base=trial * 79 + N * 17)
            M = len(A_set)
            if M < 2:
                continue

            pop = popular_fibers(A_set, N)
            if not pop:
                continue
            n += 1
            sum_A += M
            sum_S += len(pop)

            good = None
            bad_cnt = 0
            for d, f, sz in pop:
                t3 = count_3aps(f)
                if t3 == 0:
                    if good is None:
                        good = d
                else:
                    bad_cnt += 1

            bf = bad_cnt / len(pop)
            worst_bf = max(worst_bf, bf)

            if good is None:
                n_ce += 1
                print(f"  *** CE! N={N} trial={trial} |A|={M} |S|={len(pop)}")

        avg_A = sum_A / n if n else 0
        avg_S = sum_S / n if n else 0
        print(f"{N:6d} {n:7d} {n_ce:5d} {worst_bf:13.4f} {avg_A:8.2f} {avg_S:8.2f}")
        rows.append(dict(N=N, n=n, n_ce=n_ce, worst_bf=worst_bf,
                         avg_A=avg_A, avg_S=avg_S))
    print()
    return rows


# ── Task 3: P9-rev threshold ────────────────────────────────────────────────

def p9_rev_check(A_set, N):
    """
    Returns: (p9_ce, p9_rev_ce)
      p9_ce     = bool: canonical argmin d* has T3 > 0
      p9_rev_ce = bool: ALL d in S_min have T3 > 0
    """
    pop = popular_fibers(A_set, N)
    if not pop:
        return False, False
    min_sz = min(sz for _, _, sz in pop)
    S_min = [(d, f) for d, f, sz in pop if sz == min_sz]
    T3_vals = [count_3aps(f) for d, f in S_min]
    d_star_T3 = T3_vals[0]   # canonical argmin
    p9_ce = (d_star_T3 > 0)
    p9_rev_ce = (min(T3_vals) > 0)
    return p9_ce, p9_rev_ce


def task3_threshold(N_dense, N_border, trials=500, restarts=5):
    """
    N_dense: e.g. list(range(51, 71))
    N_border: e.g. [25,28,30,32,35,38,40,42,45,48,50]
    """
    print("=" * 72)
    print("TASK 3: P9-rev Threshold  (N=51..70 and border N-values)")
    print("=" * 72)

    all_N = sorted(set(N_border + N_dense))
    print(f"{'N':>5} {'tested':>7} {'P9-CEs':>8} {'P9-rev-CEs':>11} {'p9rev_rate%':>12}")
    print("-" * 52)

    rows = []
    for N in all_N:
        n = p9_ce_cnt = p9_rev_cnt = 0
        for trial in range(trials):
            A_set, _ = greedy_dense(N, restarts=restarts,
                                    seed_base=trial * 11 + N * 23)
            if len(A_set) < 2:
                continue
            n += 1
            p9ce, p9rev_ce = p9_rev_check(A_set, N)
            if p9ce:
                p9_ce_cnt += 1
            if p9rev_ce:
                p9_rev_cnt += 1

        rate = 100 * p9_rev_cnt / n if n else float('nan')
        print(f"{N:5d} {n:7d} {p9_ce_cnt:8d} {p9_rev_cnt:11d} {rate:11.3f}%")
        rows.append(dict(N=N, n=n, p9_ce=p9_ce_cnt,
                         p9_rev=p9_rev_cnt, rate=rate))
    print()
    return rows


# ── Task 4: C2 witness analysis in P9-rev CEs ───────────────────────────────

def find_p9_rev_ce(N, max_trials=5000, restarts=5):
    """Find a P9-revised CE (ALL S_min fibers have T3>0) at given N."""
    for trial in range(max_trials):
        A_set, _ = greedy_dense(N, restarts=restarts,
                                seed_base=trial * 13 + N * 7)
        if len(A_set) < 2:
            continue
        p9ce, p9rev = p9_rev_check(A_set, N)
        if p9rev:
            return A_set, trial
    return None, None


def analyze_c2_witness(A_set, N):
    """
    In a P9-rev CE case, find the d that saves Conjecture 2
    (popular d NOT in S_min with T3(A_d)=0).
    Returns info dict.
    """
    pop = popular_fibers(A_set, N)
    if not pop:
        return None

    min_sz = min(sz for _, _, sz in pop)
    max_sz = max(sz for _, _, sz in pop)

    S_min = [(d, f) for d, f, sz in pop if sz == min_sz]
    T3_min_all = [count_3aps(f) for _, f in S_min]

    # Find C2 witness: any popular d with T3=0
    c2_witnesses = []
    for d, f, sz in pop:
        if count_3aps(f) == 0:
            c2_witnesses.append((d, sz))

    return dict(
        M=len(A_set),
        min_sz=min_sz,
        max_sz=max_sz,
        n_S_min=len(S_min),
        T3_in_S_min=T3_min_all,
        n_popular=len(pop),
        c2_witnesses=c2_witnesses,  # (d, fiber_size)
    )


def task4_witness_analysis(N_list=(30, 40, 50), max_trials_each=3000):
    print("=" * 72)
    print("TASK 4: C2 Witness Analysis in P9-rev CEs")
    print("=" * 72)

    for N in N_list:
        print(f"\n--- N={N} ---")
        ces_found = 0
        witness_sizes = []
        witness_fracs = []  # |A_d_witness| / max_sz

        for attempt in range(max_trials_each):
            A_set, trial_idx = find_p9_rev_ce(N, max_trials=1, restarts=5)
            if A_set is None:
                # try with a random seed offset
                seed_off = attempt * 19 + N * 37
                A_set_r, _ = greedy_dense(N, restarts=5, seed_base=seed_off)
                p9ce, p9rev = p9_rev_check(A_set_r, N)
                if not p9rev:
                    continue
                A_set = A_set_r

            info = analyze_c2_witness(A_set, N)
            if info is None:
                continue

            ces_found += 1
            for d_w, sz_w in info['c2_witnesses']:
                witness_sizes.append(sz_w)
                witness_fracs.append(sz_w / info['max_sz'] if info['max_sz'] > 0 else 0)

            if ces_found <= 3:
                print(f"  CE #{ces_found}: |A|={info['M']}, "
                      f"S_min size={info['min_sz']} (×{info['n_S_min']} ties), "
                      f"max_sz={info['max_sz']}")
                print(f"    T3 in S_min: {info['T3_in_S_min']}")
                print(f"    C2 witnesses (d, |A_d|): {info['c2_witnesses']}")

            if ces_found >= 50:
                break

        if ces_found == 0:
            print(f"  No P9-rev CE found at N={N} in {max_trials_each} attempts.")
            continue

        def avg(lst): return sum(lst) / len(lst) if lst else float('nan')

        print(f"\n  Found {ces_found} P9-rev CEs:")
        print(f"    C2 witness fiber sizes: avg={avg(witness_sizes):.2f}, "
              f"min={min(witness_sizes)}, max={max(witness_sizes)}")
        print(f"    Witness size / max_popular_size: avg={avg(witness_fracs):.3f}")
    print()


# ── Main ────────────────────────────────────────────────────────────────────

def main():
    t0 = time.time()

    # Task 1: argmax analysis N=10..200
    N_t1 = list(range(10, 201, 10))
    t1 = task1_argmax_analysis(N_t1, trials=200, restarts=3)

    # Task 2: C2 N=350..500
    N_t2 = [350, 400, 450, 500]
    t2 = task2_c2_n500(N_t2, trials=50, restarts=3)

    # Task 3: threshold search
    N_dense  = list(range(51, 71))       # N=51,52,...,70
    N_border = [25,28,30,32,35,38,40,42,45,48,50]
    t3 = task3_threshold(N_dense, N_border, trials=500, restarts=5)

    # Task 4: witness analysis
    task4_witness_analysis(N_list=[30, 40, 50], max_trials_each=2000)

    elapsed = time.time() - t0

    print("=" * 72)
    print("SUMMARY")
    print("=" * 72)

    # Task 1
    low_N  = [r for r in t1 if r['N'] <= 50]
    high_N = [r for r in t1 if r['N'] >= 100]
    def avg(lst, key): return sum(r[key] for r in lst) / len(lst) if lst else 0
    print(f"Task 1 — argmax vs argmin T3=0 rate:")
    if low_N:
        print(f"  N≤50:  argmax={avg(low_N,'pct_max'):.1f}%, "
              f"argmin={avg(low_N,'pct_min'):.1f}%, rnd={avg(low_N,'pct_rnd'):.1f}%")
    if high_N:
        print(f"  N≥100: argmax={avg(high_N,'pct_max'):.1f}%, "
              f"argmin={avg(high_N,'pct_min'):.1f}%, rnd={avg(high_N,'pct_rnd'):.1f}%")

    # Task 2
    total_ce2 = sum(r['n_ce'] for r in t2)
    max_bf2 = max(r['worst_bf'] for r in t2) if t2 else 0
    print(f"\nTask 2 — C2 N≤500: {total_ce2} CEs, max bad_frac={max_bf2:.4f}")

    # Task 3
    t3_border = [r for r in t3 if r['N'] in set(N_border)]
    t3_dense  = [r for r in t3 if r['N'] in set(N_dense)]
    last_p9rev_fail = max((r['N'] for r in t3 if r['p9_rev'] > 0), default='none')
    first_p9rev_clean = min((r['N'] for r in t3_dense if r['p9_rev'] == 0), default='none')
    print(f"\nTask 3 — P9-rev threshold:")
    print(f"  Last N with P9-rev CE (N≤70): {last_p9rev_fail}")
    print(f"  First N (51-70) with 0 P9-rev CEs (500 trials): {first_p9rev_clean}")

    print(f"\nTotal elapsed: {elapsed:.1f}s")
    return t1, t2, t3


if __name__ == '__main__':
    main()
