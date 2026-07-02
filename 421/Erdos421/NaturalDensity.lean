namespace Erdos421

noncomputable abbrev countSetUpTo (S : Nat -> Prop) (N : Nat) : Nat := by
  classical
  exact ((List.range (N + 1)).filter (fun n => S n)).length

noncomputable abbrev countIccOneUpTo (S : Nat -> Prop) (N : Nat) : Nat := by
  classical
  exact (((List.range N).map Nat.succ).filter (fun n => S n)).length

theorem range_eq_zero_cons_map_succ (N : Nat) :
    List.range (N + 1) = 0 :: (List.range N).map Nat.succ := by
  induction N with
  | zero =>
      simp
  | succ N ih =>
      rw [show N.succ + 1 = (N + 1).succ by omega]
      rw [List.range_succ]
      rw [ih]
      have h := congrArg (List.map Nat.succ) ih
      simpa [List.range_succ, List.map_append, Function.comp_def] using h

theorem countSetUpTo_le_countIccOneUpTo_add_one (S : Nat -> Prop) (N : Nat) :
    countSetUpTo S N ≤ countIccOneUpTo S N + 1 := by
  classical
  simp [countSetUpTo, countIccOneUpTo, range_eq_zero_cons_map_succ]
  by_cases h0 : S 0 <;> simp [h0]

def DensityZeroSet (S : Nat -> Prop) : Prop :=
  ∀ k : Nat,
    0 < k ->
      ∃ N0 : Nat,
        ∀ N : Nat,
          N0 ≤ N ->
            k * countIccOneUpTo S N ≤ N

noncomputable abbrev countList (S : Nat -> Prop) (xs : List Nat) : Nat := by
  classical
  exact (xs.filter (fun n => S n)).length

theorem countList_subset {A B : Nat -> Prop} (hAB : ∀ n : Nat, A n -> B n) :
    ∀ xs : List Nat, countList A xs ≤ countList B xs := by
  classical
  intro xs
  induction xs with
  | nil =>
      simp [countList]
  | cons x xs ih =>
      dsimp [countList] at ih ⊢
      by_cases hA : A x <;> by_cases hB : B x <;> simp [hA, hB] at ih ⊢
      · exact ih
      · exact False.elim (hB (hAB x hA))
      · exact Nat.le_succ_of_le ih
      · exact ih

theorem countSetUpTo_subset {A B : Nat -> Prop} (hAB : ∀ n : Nat, A n -> B n)
    (N : Nat) :
    countSetUpTo A N ≤ countSetUpTo B N := by
  simpa [countSetUpTo, countList] using
    (countList_subset hAB (List.range (N + 1)))

theorem countIccOneUpTo_subset {A B : Nat -> Prop} (hAB : ∀ n : Nat, A n -> B n)
    (N : Nat) :
    countIccOneUpTo A N ≤ countIccOneUpTo B N := by
  simpa [countIccOneUpTo, countList] using
    (countList_subset hAB ((List.range N).map Nat.succ))

theorem countList_compl_ge (A : Nat -> Prop) :
    ∀ xs : List Nat, xs.length - countList A xs ≤ countList (fun n => ¬ A n) xs := by
  classical
  intro xs
  induction xs with
  | nil =>
      simp [countList]
  | cons x xs ih =>
      dsimp [countList] at ih ⊢
      by_cases hA : A x <;> simp [hA] at ih ⊢ <;> omega

theorem countList_union4 (A B C D : Nat -> Prop) :
    ∀ xs : List Nat,
      countList (fun n => A n ∨ B n ∨ C n ∨ D n) xs ≤
        countList A xs + countList B xs + countList C xs + countList D xs := by
  classical
  intro xs
  induction xs with
  | nil =>
      simp [countList]
  | cons x xs ih =>
      dsimp [countList] at ih ⊢
      by_cases hA : A x <;> by_cases hB : B x <;>
        by_cases hC : C x <;> by_cases hD : D x <;>
          simp [hA, hB, hC, hD, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] at ih ⊢ <;>
            omega

theorem densityZeroSet_union4
    (A B C D : Nat -> Prop)
    (hA : DensityZeroSet A) (hB : DensityZeroSet B)
    (hC : DensityZeroSet C) (hD : DensityZeroSet D) :
    DensityZeroSet (fun n => A n ∨ B n ∨ C n ∨ D n) := by
  intro k hk
  have hfourk : 0 < 4 * k := by omega
  rcases hA (4 * k) hfourk with ⟨NA, hNA⟩
  rcases hB (4 * k) hfourk with ⟨NB, hNB⟩
  rcases hC (4 * k) hfourk with ⟨NC, hNC⟩
  rcases hD (4 * k) hfourk with ⟨ND, hND⟩
  refine ⟨max (max NA NB) (max NC ND), ?_⟩
  intro N hN
  have hNAle : NA ≤ N := by omega
  have hNBle : NB ≤ N := by omega
  have hNCle : NC ≤ N := by omega
  have hNDle : ND ≤ N := by omega
  have hAc := hNA N hNAle
  have hBc := hNB N hNBle
  have hCc := hNC N hNCle
  have hDc := hND N hNDle
  have hAc' : 4 * (k * countIccOneUpTo A N) ≤ N := by
    simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using hAc
  have hBc' : 4 * (k * countIccOneUpTo B N) ≤ N := by
    simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using hBc
  have hCc' : 4 * (k * countIccOneUpTo C N) ≤ N := by
    simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using hCc
  have hDc' : 4 * (k * countIccOneUpTo D N) ≤ N := by
    simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using hDc
  have hcount :
      countIccOneUpTo (fun n => A n ∨ B n ∨ C n ∨ D n) N ≤
        countIccOneUpTo A N + countIccOneUpTo B N +
          countIccOneUpTo C N + countIccOneUpTo D N := by
    simpa [countIccOneUpTo, countList] using
      (countList_union4 A B C D ((List.range N).map Nat.succ))
  have hmul := Nat.mul_le_mul_left k hcount
  have hcount' :
      k * countIccOneUpTo (fun n => A n ∨ B n ∨ C n ∨ D n) N ≤
        k * countIccOneUpTo A N + k * countIccOneUpTo B N +
          k * countIccOneUpTo C N + k * countIccOneUpTo D N := by
    simpa [Nat.mul_add, Nat.add_assoc] using hmul
  omega

theorem densityZeroSet_of_subset {A B : Nat -> Prop}
    (hAB : ∀ n : Nat, A n -> B n) (hB : DensityZeroSet B) :
    DensityZeroSet A := by
  intro k hk
  rcases hB k hk with ⟨N0, hN0⟩
  refine ⟨N0, ?_⟩
  intro N hN
  have hcount := countIccOneUpTo_subset hAB N
  exact Nat.le_trans (Nat.mul_le_mul_left k hcount) (hN0 N hN)

theorem densityZeroSet_union (A B : Nat -> Prop)
    (hA : DensityZeroSet A) (hB : DensityZeroSet B) :
    DensityZeroSet (fun n => A n ∨ B n) := by
  have hFalse : DensityZeroSet (fun _ => False) :=
    densityZeroSet_of_subset (fun n h => False.elim h) hA
  refine densityZeroSet_of_subset
    (A := fun n => A n ∨ B n)
    (B := fun n => A n ∨ B n ∨ False ∨ False)
    ?_ ?_
  · intro n hn
    rcases hn with h | h
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
  · exact densityZeroSet_union4 A B (fun _ => False) (fun _ => False)
      hA hB hFalse hFalse

theorem countIccOneUpTo_le_countSetUpTo (S : Nat -> Prop) (N : Nat) :
    countIccOneUpTo S N ≤ countSetUpTo S N := by
  classical
  simp [countSetUpTo, countIccOneUpTo, range_eq_zero_cons_map_succ]
  by_cases h0 : S 0 <;> simp [h0]

theorem countSetUpTo_eq_countIccOneUpTo_of_not_zero
    {S : Nat -> Prop} (h0 : ¬ S 0) (N : Nat) :
    countSetUpTo S N = countIccOneUpTo S N := by
  classical
  simp [countSetUpTo, countIccOneUpTo, range_eq_zero_cons_map_succ, h0]

theorem countIccOneUpTo_insert_zero_eq (S : Nat -> Prop) (N : Nat) :
    countIccOneUpTo (fun n => n = 0 ∨ S n) N = countIccOneUpTo S N := by
  classical
  induction N with
  | zero =>
      simp [countIccOneUpTo]
  | succ N ih =>
      have ih' := ih
      simp [countIccOneUpTo] at ih'
      simp [countIccOneUpTo, List.range_succ, List.map_append, ih']
      by_cases hSN : S (N + 1) <;> simp [hSN]

theorem densityZeroSet_insert_zero_iff (S : Nat -> Prop) :
    DensityZeroSet (fun n => n = 0 ∨ S n) ↔ DensityZeroSet S := by
  constructor
  · intro h k hk
    rcases h k hk with ⟨N0, hN0⟩
    refine ⟨N0, ?_⟩
    intro N hN
    simpa [countIccOneUpTo_insert_zero_eq S N] using hN0 N hN
  · intro h k hk
    rcases h k hk with ⟨N0, hN0⟩
    refine ⟨N0, ?_⟩
    intro N hN
    simpa [countIccOneUpTo_insert_zero_eq S N] using hN0 N hN

namespace NaturalDensity

noncomputable abbrev countIccZeroUpTo (S : Nat -> Prop) (N : Nat) : Nat :=
  Erdos421.countSetUpTo S N

noncomputable abbrev countIccOneUpTo (S : Nat -> Prop) (N : Nat) : Nat :=
  Erdos421.countIccOneUpTo S N

abbrev DensityZero (S : Nat -> Prop) : Prop :=
  Erdos421.DensityZeroSet S

theorem countIccOneUpTo_le_countIccZeroUpTo (S : Nat -> Prop) (N : Nat) :
    countIccOneUpTo S N ≤ countIccZeroUpTo S N :=
  Erdos421.countIccOneUpTo_le_countSetUpTo S N

theorem countIccZeroUpTo_eq_countIccOneUpTo_of_not_zero
    {S : Nat -> Prop} (h0 : ¬ S 0) (N : Nat) :
    countIccZeroUpTo S N = countIccOneUpTo S N :=
  Erdos421.countSetUpTo_eq_countIccOneUpTo_of_not_zero h0 N

theorem densityZero_of_subset {A B : Nat -> Prop}
    (hAB : ∀ n : Nat, A n -> B n) (hB : DensityZero B) :
    DensityZero A :=
  Erdos421.densityZeroSet_of_subset hAB hB

theorem densityZero_union (A B : Nat -> Prop)
    (hA : DensityZero A) (hB : DensityZero B) :
    DensityZero (fun n => A n ∨ B n) :=
  Erdos421.densityZeroSet_union A B hA hB

theorem densityZero_union4
    (A B C D : Nat -> Prop)
    (hA : DensityZero A) (hB : DensityZero B)
    (hC : DensityZero C) (hD : DensityZero D) :
    DensityZero (fun n => A n ∨ B n ∨ C n ∨ D n) :=
  Erdos421.densityZeroSet_union4 A B C D hA hB hC hD

theorem densityZero_insert_zero_iff (S : Nat -> Prop) :
    DensityZero (fun n => n = 0 ∨ S n) ↔ DensityZero S :=
  Erdos421.densityZeroSet_insert_zero_iff S

theorem densityZero_of_eventual_count_bound
    (S : Nat -> Prop)
    (hS : ∀ k : Nat, 0 < k ->
      ∃ N0 : Nat, ∀ N : Nat, N0 ≤ N -> k * countIccOneUpTo S N ≤ N) :
    DensityZero S :=
  hS

end NaturalDensity

/--
Finite count estimate in exactly the form needed for natural-density-zero
sets.  This adapter keeps analytic or finite shell estimates theorem-local:
the estimate itself is explicit, and the density conclusion is just unfolding.
-/
def SparseCountingEstimate (S : Nat -> Prop) : Prop :=
  ∀ k : Nat,
    0 < k ->
      ∃ N0 : Nat,
        ∀ N : Nat,
          N0 ≤ N ->
            k * countIccOneUpTo S N ≤ N

theorem densityZeroSet_from_sparseCountingEstimate
    (S : Nat -> Prop) (hS : SparseCountingEstimate S) :
    DensityZeroSet S :=
  hS

/--
Adapter for forced deletion estimates proved by concrete finite shell counts.
It deliberately has no private-barrier package argument and no final-density
consequence beyond the named set.
-/
theorem forcedDeletionDensityZero_from_finiteEstimate
    (D : Nat -> Prop) (hD : SparseCountingEstimate D) :
    DensityZeroSet D :=
  densityZeroSet_from_sparseCountingEstimate D hD

/--
Adapter for empty-suffix estimates once the finite old-block-product family has
been counted sparsely.
-/
theorem emptySuffixDensityZero_from_oldBlockProductsSparse
    (Empty OldBlockProducts : Nat -> Prop)
    (hEmptyOld : ∀ n : Nat, Empty n -> OldBlockProducts n)
    (hOldSparse : SparseCountingEstimate OldBlockProducts) :
    DensityZeroSet Empty :=
  densityZeroSet_of_subset hEmptyOld
    (densityZeroSet_from_sparseCountingEstimate OldBlockProducts hOldSparse)

/--
Exact real-analysis theorem shape still missing for the finite-horizon
dyadic-tail/log-log summation in the barrier construction.  A future proof
should instantiate this with the concrete deletion predicate and shell count
bound, then use `forcedDeletionDensityZero_from_finiteEstimate`.
-/
def HorizonDyadicTailLogLogEstimate (D : Nat -> Prop) : Prop :=
  SparseCountingEstimate D

end Erdos421
