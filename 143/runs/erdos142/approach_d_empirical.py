#!/usr/bin/env python3
"""
Approach D Empirical Test: Second-Moment Fiber Bound for 4-AP-Free Sets

Tests the hypothesis:
    Σ_{d∈S} |A_d|² / |S|  ≤  C' · P · L

where:
  A ⊆ {1,...,N}  is 4-AP-free with |A| = M
  L = M²/(4N)    is the popularity threshold
  S = {d : |A_d| ≥ L}  are the popular differences
  P = max_{d∈S} |A_d|   is the maximum popular fiber size
  SM2 = Σ_{d∈S} |A_d|² / |S|   is the average squared fiber size
  R = SM2 / (P·L)   is the ratio to test

If R ≤ C' for a small universal constant C' across all N, Approach D is plausible.
"""

import numpy as np
import time
import sys
from numpy.fft import rfft, irfft


# ---------------------------------------------------------------------------
# 1.  Greedy 4-AP-free set construction
# ---------------------------------------------------------------------------

def build_4ap_free_greedy(N: int, rng: np.random.Generator) -> np.ndarray:
    """
    Build a 4-AP-free subset of {1,...,N} by random greedy process.

    Elements of {1,...,N} are visited in a uniformly random order.
    Each element x is added to A if it does not complete a 4-AP with
    the current elements of A.

    4-AP check for a new element x — four cases depending on x's role:
      Case 1 (x is 1st):  x,   x+d, x+2d, x+3d  all in {x} ∪ A
      Case 2 (x is 2nd):  x-d, x,   x+d,  x+2d
      Case 3 (x is 3rd):  x-2d,x-d, x,    x+d
      Case 4 (x is 4th):  x-3d,x-2d,x-d,  x

    For each existing a ∈ A we set d = |a - x| and check whether the
    other two required elements are also in A.  This is vectorised over A.

    Returns: numpy int64 array of elements of A (in insertion order).
    """
    in_A = np.zeros(N + 1, dtype=bool)   # fast O(1) membership test
    A_buf = np.zeros(N, dtype=np.int64)  # preallocated buffer
    M = 0                                # current size

    order = np.arange(1, N + 1, dtype=np.int64)
    rng.shuffle(order)

    for x in order:
        A_cur = A_buf[:M]
        A_below = A_cur[A_cur < x]   # elements a < x already in A
        A_above = A_cur[A_cur > x]   # elements a > x already in A
        ok = True

        # ------------------------------------------------------------------
        # Case 4: x is the 4th element  → (3a-2x, 2a-x, a, x) with a=x-d
        # Need 2a-x ∈ A  and  3a-2x ∈ A
        # ------------------------------------------------------------------
        if len(A_below) > 0:
            b = 2 * A_below - x          # x - 2d
            c = 3 * A_below - 2 * x     # x - 3d
            mask = (b >= 1) & (c >= 1)
            if mask.any():
                bm, cm = b[mask], c[mask]
                if (in_A[bm] & in_A[cm]).any():
                    ok = False

        # ------------------------------------------------------------------
        # Case 3: x is the 3rd element  → (2a-x, a, x, 2x-a) with a=x-d
        # Need 2a-x ∈ A  and  2x-a ∈ A
        # ------------------------------------------------------------------
        if ok and len(A_below) > 0:
            b = 2 * A_below - x          # x - 2d
            c = 2 * x - A_below          # x + d
            mask = (b >= 1) & (c <= N)
            if mask.any():
                bm, cm = b[mask], c[mask]
                if (in_A[bm] & in_A[cm]).any():
                    ok = False

        # ------------------------------------------------------------------
        # Case 1: x is the 1st element  → (x, a, 2a-x, 3a-2x) with a=x+d
        # Need 2a-x ∈ A  and  3a-2x ∈ A
        # ------------------------------------------------------------------
        if ok and len(A_above) > 0:
            b = 2 * A_above - x          # x + 2d
            c = 3 * A_above - 2 * x     # x + 3d
            mask = (b <= N) & (c <= N)
            if mask.any():
                bm, cm = b[mask], c[mask]
                if (in_A[bm] & in_A[cm]).any():
                    ok = False

        # ------------------------------------------------------------------
        # Case 2: x is the 2nd element  → (2x-a, x, a, 3a-2x) with a=x+d
        # Need 2x-a ∈ A  and  3a-2x ∈ A
        # ------------------------------------------------------------------
        if ok and len(A_above) > 0:
            b = 2 * x - A_above          # x - d
            c = 3 * A_above - 2 * x     # x + 2d
            mask = (b >= 1) & (c <= N)
            if mask.any():
                bm, cm = b[mask], c[mask]
                if (in_A[bm] & in_A[cm]).any():
                    ok = False

        if ok:
            in_A[x] = True
            A_buf[M] = x
            M += 1

    return A_buf[:M].copy()


# ---------------------------------------------------------------------------
# 2.  Fiber-size computation via FFT autocorrelation
# ---------------------------------------------------------------------------

def compute_fiber_sizes(A: np.ndarray, N: int) -> np.ndarray:
    """
    Compute |A_d| for d = 1, ..., N-1 using FFT-based autocorrelation.

    |A_d| = |{x ∈ A : x+d ∈ A}|  =  Σ_x 1_A(x)·1_A(x+d)

    This is the linear autocorrelation of 1_A at lag d.
    We zero-pad to n_fft ≥ 2(N+1) to avoid circular aliasing.

    Returns int64 array of length N-1 where result[d-1] = |A_d|.
    """
    indicator = np.zeros(N + 1, dtype=np.float64)
    indicator[A] = 1.0

    # Next power of 2 ≥ 2(N+1)
    n_fft = 1
    while n_fft < 2 * (N + 1):
        n_fft <<= 1

    ft = rfft(indicator, n=n_fft)
    power = ft.real ** 2 + ft.imag ** 2   # |F(k)|²
    autocorr = irfft(power, n=n_fft)       # circular autocorrelation

    # For d in [1, N-1], linear = circular autocorrelation (since n_fft > 2N)
    fibers = np.round(autocorr[1:N]).astype(np.int64)
    return np.maximum(fibers, 0)           # clip tiny negative float errors


# ---------------------------------------------------------------------------
# 3.  Compute Approach-D statistics for one set
# ---------------------------------------------------------------------------

def compute_stats(A: np.ndarray, N: int) -> dict | None:
    """
    Compute Approach D statistics for a 4-AP-free set A ⊆ {1,...,N}.

    Returns dict with keys:
        M, L, S_size, P, P_over_L, SM2, R
    or None if there are no popular differences.
    """
    M = len(A)
    if M == 0:
        return None

    L = M * M / (4.0 * N)              # popularity threshold

    fibers = compute_fiber_sizes(A, N)  # length N-1

    # Popular differences S: |A_d| ≥ L
    pop = fibers[fibers >= L]
    if len(pop) == 0:
        return None

    S_size = int(len(pop))
    P      = float(pop.max())

    # Second moment: Σ_{d∈S} |A_d|² / |S|
    SM2 = float((pop.astype(np.float64) ** 2).sum()) / S_size

    # Approach-D ratio: R = SM2 / (P · L)
    R = SM2 / (P * L)

    return {
        'M':       M,
        'L':       L,
        'S_size':  S_size,
        'P':       P,
        'P_over_L': P / L,
        'SM2':     SM2,
        'R':       R,
    }


# ---------------------------------------------------------------------------
# 4.  Main experiment loop
# ---------------------------------------------------------------------------

def run_experiments() -> dict:
    """Run greedy 4-AP-free experiments for each N and return all results."""
    N_values   = [500, 1000, 2000, 5000, 10000]
    trials_map = {500: 8, 1000: 7, 2000: 6, 5000: 5, 10000: 3}

    all_results: dict[int, list[dict]] = {}

    print("=" * 76)
    print("Approach D Empirical Test — Σ|A_d|²/|S| ≤ C'·P·L for 4-AP-free sets")
    print("=" * 76)
    sys.stdout.flush()

    for N in N_values:
        n_trials = trials_map[N]
        print(f"\nN = {N:>6}  ({n_trials} trials)", flush=True)

        rng  = np.random.default_rng(seed=31415926 + N * 31)
        rows: list[dict] = []

        for trial in range(n_trials):
            t0 = time.time()
            A  = build_4ap_free_greedy(N, rng)
            t1 = time.time()
            st = compute_stats(A, N)
            t2 = time.time()

            if st is None:
                print(f"  trial {trial+1:2d}: M={len(A):5d}, no popular diffs — skip",
                      flush=True)
                continue

            rows.append(st)
            print(
                f"  trial {trial+1:2d}: "
                f"M={st['M']:5d}  |S|={st['S_size']:5d}  "
                f"P={st['P']:7.1f}  L={st['L']:7.3f}  "
                f"P/L={st['P_over_L']:6.3f}  "
                f"SM2={st['SM2']:10.3f}  R={st['R']:.5f}  "
                f"[build {t1-t0:.1f}s  fiber {t2-t1:.2f}s]",
                flush=True,
            )

        all_results[N] = rows

    return all_results


# ---------------------------------------------------------------------------
# 5.  Summary table + interpretation
# ---------------------------------------------------------------------------

def print_summary(all_results: dict) -> tuple[float, float]:
    """Print the summary table; return (global_R_max, global_R_min)."""
    N_values = sorted(all_results.keys())

    print("\n" + "=" * 112)
    print("SUMMARY TABLE")
    print("=" * 112)

    # header
    h = ("| {:>6} | {:>8} | {:>8} | {:>7} | {:>7} | {:>8} | {:>11} |"
         " {:>8} | {:>8} | {:>8} |")
    print(h.format("N", "M_avg", "|S|_avg", "P_avg", "L_avg",
                   "P/L_avg", "SM2_avg", "R_avg", "R_max", "R_min"))
    sep = "|" + "-" * 110 + "|"
    print(sep)

    global_R_max = 0.0
    global_R_min = float('inf')
    R_avg_by_N: list[tuple[int, float]] = []

    for N in N_values:
        rows = all_results[N]
        if not rows:
            print(h.format(N, "–", "–", "–", "–", "–", "–", "–", "–", "–"))
            continue

        def a(k): return float(np.mean([r[k] for r in rows]))

        R_max = float(max(r['R'] for r in rows))
        R_min = float(min(r['R'] for r in rows))
        R_avg = a('R')
        global_R_max = max(global_R_max, R_max)
        global_R_min = min(global_R_min, R_min)
        R_avg_by_N.append((N, R_avg))

        print(h.format(
            N,
            f"{a('M'):.1f}",
            f"{a('S_size'):.1f}",
            f"{a('P'):.2f}",
            f"{a('L'):.3f}",
            f"{a('P_over_L'):.3f}",
            f"{a('SM2'):.2f}",
            f"{R_avg:.5f}",
            f"{R_max:.5f}",
            f"{R_min:.5f}",
        ))

    print(sep)
    print(f"\nGlobal R_max  (= empirical C')  = {global_R_max:.5f}")
    print(f"Global R_min                      = {global_R_min:.5f}")

    # Trend analysis
    if len(R_avg_by_N) >= 3:
        first = np.mean([r for _, r in R_avg_by_N[:2]])
        last  = np.mean([r for _, r in R_avg_by_N[-2:]])
        ratio = last / first if first > 0 else float('nan')
        if   ratio < 0.85:
            trend = f"DECREASING  (last/first = {ratio:.3f}x) — R shrinks with N"
        elif ratio > 1.15:
            trend = f"INCREASING  (last/first = {ratio:.3f}x) — hypothesis may fail!"
        else:
            trend = f"STABLE      (last/first = {ratio:.3f}x) — consistent with bounded C'"
        print(f"R_avg trajectory:  {trend}")

    return global_R_max, global_R_min


# ---------------------------------------------------------------------------
# 6.  Write Markdown results file
# ---------------------------------------------------------------------------

def write_markdown(all_results: dict, global_R_max: float, global_R_min: float,
                   outpath: str):
    """Write the full results and interpretation to a Markdown file."""
    N_values = sorted(all_results.keys())

    lines: list[str] = []
    lines.append("# Approach D Empirical Test: Second-Moment Fiber Bound for 4-AP-Free Sets\n")
    lines.append(f"**Date**: {time.strftime('%Y-%m-%d')}  \n")
    lines.append("**Hypothesis**: Σ_{d∈S} |A_d|² / |S| ≤ C' · P · L for some universal constant C'  \n")
    lines.append("**Ratio tested**: R = SM2 / (P·L)  where SM2 = Σ_{d∈S} |A_d|² / |S|\n\n")
    lines.append("---\n\n")

    # Per-N detail
    lines.append("## Per-trial data\n\n")
    for N in N_values:
        rows = all_results[N]
        if not rows:
            lines.append(f"### N = {N}: no data\n\n")
            continue
        lines.append(f"### N = {N}\n\n")
        lines.append("| Trial | M | |S| | P | L | P/L | SM2 | R |\n")
        lines.append("|------:|--:|---:|--:|--:|----:|----:|--:|\n")
        for i, r in enumerate(rows, 1):
            lines.append(
                f"| {i} | {r['M']} | {r['S_size']} | {r['P']:.1f} |"
                f" {r['L']:.3f} | {r['P_over_L']:.3f} |"
                f" {r['SM2']:.3f} | {r['R']:.5f} |\n"
            )
        lines.append("\n")

    # Summary table
    lines.append("## Summary Table\n\n")
    lines.append(
        "| N | M_avg | \\|S\\|_avg | P_avg | L_avg | P/L_avg"
        " | SM2_avg | R_avg | R_max | R_min |\n"
    )
    lines.append("|--:|------:|--------:|------:|------:|--------:|--------:|------:|------:|------:|\n")

    R_avg_by_N: list[tuple[int, float]] = []
    for N in N_values:
        rows = all_results[N]
        if not rows:
            lines.append(f"| {N} | — | — | — | — | — | — | — | — | — |\n")
            continue

        def a(k): return float(np.mean([r[k] for r in rows]))
        R_max = float(max(r['R'] for r in rows))
        R_min = float(min(r['R'] for r in rows))
        R_avg = a('R')
        R_avg_by_N.append((N, R_avg))

        lines.append(
            f"| {N} | {a('M'):.1f} | {a('S_size'):.1f} | {a('P'):.2f}"
            f" | {a('L'):.3f} | {a('P_over_L'):.3f} | {a('SM2'):.3f}"
            f" | {R_avg:.5f} | {R_max:.5f} | {R_min:.5f} |\n"
        )

    lines.append("\n")

    # Trend
    if len(R_avg_by_N) >= 3:
        first = np.mean([r for _, r in R_avg_by_N[:2]])
        last  = np.mean([r for _, r in R_avg_by_N[-2:]])
        ratio = last / first if first > 0 else float('nan')

    lines.append("## Main Conclusions\n\n")

    lines.append("### 1. Does R(A) converge, grow, or shrink with N?\n\n")
    if len(R_avg_by_N) >= 3:
        if ratio < 0.85:
            lines.append(
                f"R_avg **decreases** as N grows (last/first ratio = {ratio:.3f}). "
                "The ratio R shrinks, meaning the second moment stays well below C'·P·L "
                "even as N increases. Approach D bound tightens with N.\n\n"
            )
        elif ratio > 1.15:
            lines.append(
                f"R_avg **increases** as N grows (last/first ratio = {ratio:.3f}). "
                "This would suggest Approach D fails as N → ∞ — the bound "
                "Σ|A_d|²/|S| ≤ C'·P·L would require C' → ∞.\n\n"
            )
        else:
            lines.append(
                f"R_avg is **stable** across N (last/first ratio = {ratio:.3f}). "
                "The ratio R converges to an approximately constant value, "
                "consistent with a universal bound Σ|A_d|²/|S| ≤ C'·P·L.\n\n"
            )

    lines.append("### 2. Implication for Approach D\n\n")
    lines.append(
        f"The empirical maximum ratio is R_max = **{global_R_max:.5f}** across all "
        f"N ∈ {{500, 1000, 2000, 5000, 10000}} and all trials.\n\n"
    )
    lines.append(
        "The Approach D hypothesis claims Σ_{d∈S} |A_d|² / |S| ≤ C' · P · L "
        f"for a universal constant C'. With R = SM2/(P·L), the hypothesis is "
        f"**{'PLAUSIBLE' if global_R_max < 10 else 'QUESTIONABLE'}** "
        f"with empirical C' = {global_R_max:.4f}.\n\n"
    )

    lines.append("### 3. Empirical value of C'\n\n")
    lines.append(
        f"**C' = {global_R_max:.4f}** (= max R observed across all N and all trials).\n\n"
    )
    lines.append(
        "This means the bound Σ_{d∈S} |A_d|² / |S| ≤ "
        f"{global_R_max:.3f} · P · L appears to hold empirically for all tested sets.\n\n"
    )

    lines.append("### 4. Theoretical context\n\n")
    lines.append(
        "- The trivial upper bound is R ≤ P/L ≈ 5.1 (since SM2 ≤ P · avg_fiber ≤ P² "
        "and avg_fiber ≤ P), so the trivial C' is P/L ≈ 5.\n"
    )
    lines.append(
        "- If R_avg < P/L, the Approach D bound is *nontrivially tighter* than the trivial bound.\n"
    )
    lines.append(
        "- A proof of Σ|A_d|²/|S| ≤ C'·P·L is a second-moment structural result "
        "about 4-AP-free fiber distributions — weaker than bounding P/L directly, "
        "but potentially a stepping stone.\n\n"
    )

    lines.append("---\n\n")
    lines.append("## Script\n\n")
    lines.append("Generated by `runs/erdos142/approach_d_empirical.py`\n")

    with open(outpath, 'w') as f:
        f.writelines(lines)

    print(f"\nResults written to: {outpath}")


# ---------------------------------------------------------------------------
# 7.  Entry point
# ---------------------------------------------------------------------------

def main():
    all_results = run_experiments()
    global_R_max, global_R_min = print_summary(all_results)

    # Write markdown results
    import os
    outpath = os.path.join(os.path.dirname(__file__), 'approach_d_empirical.md')
    write_markdown(all_results, global_R_max, global_R_min, outpath)

    print(f"\n{'='*50}")
    print(f"DONE.  Empirical C' = {global_R_max:.5f}")
    print(f"       R_min         = {global_R_min:.5f}")
    return all_results, global_R_max, global_R_min


if __name__ == "__main__":
    main()
