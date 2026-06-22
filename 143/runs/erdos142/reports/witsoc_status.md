# Witsoc Status — Erdős Problem 142 (v2 — Lovász Review Complete)

- Target status: OPEN (GAP1, GAP2, GAP3) / PARTIAL (GAP5 — 4/12 sorry steps closed) / NEW RESULT (GAP3-VanCorput — confirmed)
- Current gap (top priority): **GAP2 — L¹ Density Increment** for exponent 1/3; and **KL2 — Tripartite Grid Norm** (3-7 yr) for exponent 1/2
- Pipeline stage: **Explorer → [Lovász COMPLETE] → Generator**
- Next action: **generator** (GAP2 — two tracks; GAP3-VanCorput proposition; GAP5 WIT steps 6,8,5)
- Evaluator: For GAP2-A: L¹ density increment argument for 3-APs; For GAP2-B: clean proposition r_4(N) ≤ N·exp(-c/2(logN)^{1/6}); For GAP5: 3+ new sorry-free Lean 4 steps
- Success condition: Generator (a) proves L¹ DI lemma or identifies sub-obstacle; (b) writes van Corput proposition as clean new result; (c) closes WIT steps 6,8,5

**Key corrections from v1**:
- KL ceiling **1/3** (not 1/2); exponent 1/2 requires KL2 Tripartite Grid Norm (new open conjecture)
- Van Corput exponent **1/6** (not 1/12 — Explorer error RETRACTED); constant halves to c/2
- ℓ¹ spectrum gives L¹-AP but NOT L² AP — density increment needs L²-AP (Lovász BL1 confirmed)
- EHPS: improved **constant** (not exponent) in Behrend lower bound

## Explorer Artifacts (v2)

| Artifact | Path | Version |
|----------|------|---------|
| Full gap analysis (JSON) | runs/erdos142/explorer_target_model.json | v1 (unchanged — v2 info in handoff.json) |
| Lovász handoff | runs/erdos142/handoff.json | **v2** — GAP2 top, KL2 added |
| Barrier packet | runs/erdos142/barrier_packet.json | **v2** — B0-L1DI added as top barrier |
| Human-readable analysis | runs/erdos142/gap_analysis.md | **v2** — KL/EHPS corrected, van Corput added |
| Explorer review | runs/erdos142/explorer_review.md | NEW — Lovász BL1+BL3 review (Tasks A-D) |
| SOC (working memory) | runs/erdos142/proofs/erdos142.soc | updated |
| Status report | runs/erdos142/reports/witsoc_status.md | **v2** (this file) |

## Top Barrier Lemmas (v2)

**B0-L1DI (GAP2 — TOP)**: L¹ Density Increment for 3-APs on rank O(α^{-1}) Bohr sets — "if A has 3-APs and Spec_{ℓ¹}(A) has size O(α^{-1}), does there exist a translate with density ≥ α+Ω(α^{C+1})?" Standard CS says NO directly (needs L²-AP). New argument needed. **OPEN — Generator authorized.**

**B1-REVISED (GAP1/KL)**: Kelley-Lyu ceiling for 3-APs is 1/3 (not 1/2). L¹ spectrum has rank O(α^{-1}) but L¹-AP ≠ L²-AP. KL2 tripartite grid norm conjecture gives 1/2 (3-7 yr). **Partially resolved by Lovász BL1.**

**B2 (GAP3-full)**: Quadratic Croot–Sisask Lemma for U³ — ‖f‖_{U³} ≥ δ → U²-almost-periodic on nil-Bohr set of rank O((log 1/δ)^C). **OPEN — 3-10 year problem.**

**B3-VanCorput (GAP3-quick)**: r_4(N) ≤ C·√(N·r_3(N)) + Raghavan → r_4(N) ≤ N·exp(-c/2(logN)^{1/6}). **CONFIRMED by Lovász BL3 — write as proposition.**

**B4 (GAP5)**: hasKAP_three_iff_not_threeAPFree — HasKAP A 3 ↔ ¬ThreeAPFree A in Lean 4. **TRACTABLE — Generator authorized.**
