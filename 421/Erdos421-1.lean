import Erdos421.NaturalDensity
import Erdos421.SparseSupport

namespace Erdos421

/-
This file freezes the target theorem from `main.tex` and exposes the
private-barrier proof spine as named hypotheses.  It intentionally does not
claim the barrier/localization/slab construction has been formalized.
-/

def StrictlyIncreasing (d : Nat -> Nat) : Prop :=
  ∀ {i j : Nat}, i < j -> d i < d j

def PositiveIntegerSequence (d : Nat -> Nat) : Prop :=
  (∀ i : Nat, 0 < d i) ∧ StrictlyIncreasing d

def blockProduct (d : Nat -> Nat) (u v : Nat) : Nat :=
  (List.range (v + 1 - u)).foldl (fun acc k => acc * d (u + k)) 1

def DistinctConsecutiveBlockProducts (d : Nat -> Nat) : Prop :=
  ∀ u v u' v' : Nat,
    u ≤ v ->
    u' ≤ v' ->
    blockProduct d u v = blockProduct d u' v' ->
    u = u' ∧ v = v'

noncomputable def countUnderlyingUpTo (d : Nat -> Nat) (N : Nat) : Nat := by
  classical
  exact ((List.range (N + 1)).filter (fun n => ∃ i : Nat, d i = n)).length

def UnderlyingSetHasNaturalDensityOne (d : Nat -> Nat) : Prop :=
  ∀ k : Nat,
    0 < k ->
      ∃ N0 : Nat,
        ∀ N : Nat,
          N0 ≤ N ->
            k * (N + 1 - countUnderlyingUpTo d N) ≤ N + 1

def Erdos421Target : Prop :=
  ∃ d : Nat -> Nat,
    PositiveIntegerSequence d ∧
      UnderlyingSetHasNaturalDensityOne d ∧
        DistinctConsecutiveBlockProducts d

def PartitionsRejectedSet
    (Rejected Forced Empty Nonempty Smooth TerminalSlab : Nat -> Prop) : Prop :=
  ∀ n : Nat,
    Rejected n ->
      Forced n ∨ Empty n ∨ Nonempty n ∨ Smooth n ∨ TerminalSlab n

def PredicateMatchesEnumeration (Accepted : Nat -> Prop) (d : Nat -> Nat) : Prop :=
  (∀ i : Nat, Accepted (d i)) ∧
    ∀ n : Nat, Accepted n -> ∃ i : Nat, d i = n

theorem countUnderlying_missing_le_rejected
    (Accepted Rejected : Nat -> Prop) (d : Nat -> Nat)
    (henum : PredicateMatchesEnumeration Accepted d)
    (hrejected : ∀ n : Nat, Rejected n ↔ ¬ Accepted n)
    (N : Nat) :
    N + 1 - countUnderlyingUpTo d N ≤ countSetUpTo Rejected N := by
  classical
  have hmissing :
      (List.range (N + 1)).length -
          countList (fun n => ∃ i : Nat, d i = n) (List.range (N + 1)) ≤
        countList (fun n => ¬ ∃ i : Nat, d i = n) (List.range (N + 1)) :=
    countList_compl_ge (fun n => ∃ i : Nat, d i = n) (List.range (N + 1))
  have hsubset :
      countList (fun n => ¬ ∃ i : Nat, d i = n) (List.range (N + 1)) ≤
        countList Rejected (List.range (N + 1)) := by
    refine countList_subset ?_ (List.range (N + 1))
    intro n hn
    exact (hrejected n).2 (fun hacc => hn (henum.2 n hacc))
  have hlen : (List.range (N + 1)).length = N + 1 := by
    simp
  have hchain := Nat.le_trans hmissing hsubset
  simpa [countUnderlyingUpTo, countSetUpTo, countList, hlen] using hchain

theorem densityBridge_from_rejected
    (Accepted Rejected : Nat -> Prop) (d : Nat -> Nat)
    (hrejectedZero : DensityZeroSet Rejected)
    (henum : PredicateMatchesEnumeration Accepted d)
    (hrejected : ∀ n : Nat, Rejected n ↔ ¬ Accepted n) :
    UnderlyingSetHasNaturalDensityOne d := by
  intro k hk
  have htwok : 0 < 2 * k := by omega
  rcases hrejectedZero (2 * k) htwok with ⟨N0, hN0bound⟩
  refine ⟨max N0 (2 * k), ?_⟩
  intro N hN
  have hN0 : N0 ≤ N := by omega
  have hNlarge : 2 * k ≤ N := by omega
  have hmissing :=
    countUnderlying_missing_le_rejected Accepted Rejected d henum hrejected N
  have hcountZero := countSetUpTo_le_countIccOneUpTo_add_one Rejected N
  have hmul :
      k * (N + 1 - countUnderlyingUpTo d N) ≤
        k * countSetUpTo Rejected N :=
    Nat.mul_le_mul_left k hmissing
  have hcountMul :
      k * countSetUpTo Rejected N ≤
        k * (countIccOneUpTo Rejected N + 1) :=
    Nat.mul_le_mul_left k hcountZero
  have hdense := hN0bound N hN0
  have hdense' :
      2 * (k * countIccOneUpTo Rejected N) ≤ N := by
    simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using hdense
  have hsum :
      2 * (k * countIccOneUpTo Rejected N) + 2 * k ≤ N + N :=
    Nat.add_le_add hdense' hNlarge
  have hdouble :
      2 * (k * (countIccOneUpTo Rejected N + 1)) ≤ N + N := by
    simpa [Nat.mul_add, Nat.add_assoc, Nat.mul_assoc, Nat.mul_comm,
      Nat.mul_left_comm] using hsum
  have hratio : k * (countIccOneUpTo Rejected N + 1) ≤ N := by
    omega
  omega

namespace NaturalDensity

theorem densityOne_of_rejected_densityZero
    (Accepted Rejected : Nat -> Prop) (d : Nat -> Nat)
    (hrejectedZero : DensityZeroSet Rejected)
    (henum : PredicateMatchesEnumeration Accepted d)
    (hrejected : ∀ n : Nat, Rejected n ↔ ¬ Accepted n) :
    UnderlyingSetHasNaturalDensityOne d :=
  densityBridge_from_rejected Accepted Rejected d hrejectedZero henum hrejected

end NaturalDensity

def AcceptRejectPartition (Accepted Rejected : Nat -> Prop) : Prop :=
  (∀ n : Nat, Accepted n -> ¬ Rejected n) ∧
    ∀ n : Nat, Accepted n ∨ Rejected n

/-- Product of a consecutive finite block in an accepted prefix. -/
def finiteBlockProduct (xs : List Nat) (u v : Nat) : Nat :=
  (List.range (v + 1 - u)).foldl (fun acc k => acc * xs.getD (u + k) 1) 1

theorem finiteBlockProduct_pos_of_entries_pos
    {xs : List Nat} {u v : Nat}
    (hpos : ∀ i : Nat, 0 < xs.getD i 1) :
    0 < finiteBlockProduct xs u v := by
  unfold finiteBlockProduct
  have hfold :
      ∀ (ks : List Nat) (acc : Nat),
        0 < acc ->
          0 <
            ks.foldl (fun a k => a * xs.getD (u + k) 1) acc := by
    intro ks
    induction ks with
    | nil =>
        intro acc hacc
        simpa using hacc
    | cons k ks ih =>
        intro acc hacc
        simp [List.foldl_cons]
        exact ih (acc * xs.getD (u + k) 1)
          (Nat.mul_pos hacc (hpos (u + k)))
  simpa using hfold (List.range (v + 1 - u)) 1 (by omega)

/-- A finite accepted prefix has no repeated consecutive-block product. -/
def FiniteDistinctConsecutiveBlockProducts (xs : List Nat) : Prop :=
  ∀ u v u' v' : Nat,
    u ≤ v ->
    v < xs.length ->
    u' ≤ v' ->
    v' < xs.length ->
    finiteBlockProduct xs u v = finiteBlockProduct xs u' v' ->
    u = u' ∧ v = v'

/--
Finite prefixes reachable by the formal part of the modified greedy scan.
Forced or collision rejections leave the accepted prefix unchanged; an
acceptance is allowed only when the enlarged prefix has already passed the
distinct-block-product test.
-/
inductive ModifiedGreedyPrefix : List Nat -> Prop
  | initial : ModifiedGreedyPrefix [2]
  | reject {xs : List Nat} {n : Nat} :
      ModifiedGreedyPrefix xs -> ModifiedGreedyPrefix xs
  | accept {xs : List Nat} {n : Nat} :
      ModifiedGreedyPrefix xs ->
        FiniteDistinctConsecutiveBlockProducts (xs ++ [n]) ->
          ModifiedGreedyPrefix (xs ++ [n])

theorem finiteDistinct_singleton (a : Nat) :
    FiniteDistinctConsecutiveBlockProducts [a] := by
  intro u v u' v' huv hv huv' hv' hprod
  simp at hv hv'
  have hv0 : v = 0 := by
    cases v with
    | zero => rfl
    | succ v => simp at hv
  have hv'0 : v' = 0 := by
    cases v' with
    | zero => rfl
    | succ v' => simp at hv'
  have hu0 : u = 0 := Nat.eq_zero_of_le_zero (hv0 ▸ huv)
  have hu'0 : u' = 0 := Nat.eq_zero_of_le_zero (hv'0 ▸ huv')
  exact ⟨hu0.trans hu'0.symm, hv0.trans hv'0.symm⟩

/--
Executable finite-horizon skeleton of the modified greedy scan for a fixed
deterministic deletion predicate.  Candidate `m + 3` is rejected when it lies
in the forced deletion set, accepted when the enlarged prefix passes the finite
block-product distinctness test, and rejected otherwise.
-/
noncomputable def modifiedGreedyAcceptedPrefixFromDeletion
    (D : Nat -> Prop) : Nat -> List Nat
  | 0 => [2]
  | m + 1 => by
      classical
      let xs := modifiedGreedyAcceptedPrefixFromDeletion D m
      let n := m + 3
      exact if D n then
        xs
      else if FiniteDistinctConsecutiveBlockProducts (xs ++ [n]) then
        xs ++ [n]
      else
        xs

/-- Modified greedy accepted prefixes have distinct consecutive-block products at every finite stage. -/
def ModifiedGreedyUniqueness : Prop :=
  ∀ xs : List Nat, ModifiedGreedyPrefix xs -> FiniteDistinctConsecutiveBlockProducts xs

theorem modifiedGreedyUniqueness : ModifiedGreedyUniqueness := by
  intro xs hxs
  induction hxs with
  | initial =>
      exact finiteDistinct_singleton 2
  | reject h ih =>
      exact ih
  | accept h hdistinct ih =>
      exact hdistinct

def PrefixCompatibleWithGreedy (acceptedPrefix : Nat -> List Nat) (d : Nat -> Nat) : Prop :=
  (∀ m : Nat, ModifiedGreedyPrefix (acceptedPrefix m)) ∧
    (∀ m i : Nat, i < (acceptedPrefix m).length -> (acceptedPrefix m).getD i 1 = d i) ∧
      ∀ u v : Nat,
        u ≤ v ->
          ∃ m : Nat,
            v < (acceptedPrefix m).length ∧
              ∀ u' v' : Nat,
                u' ≤ v' ->
                  v' < (acceptedPrefix m).length ->
                    finiteBlockProduct (acceptedPrefix m) u' v' = blockProduct d u' v'

/-!
The construction interface is split into data, algebraic/greedy laws, and
density obligations.  This keeps the remaining boundary object-indexed: all
assumptions refer to the same `ModifiedGreedyConstructionData`, rather than to
an unstructured proposition or to the final target.
-/

/-- Shared objects of the finite-horizon private-barrier modified greedy scan. -/
structure ModifiedGreedyConstructionData where
  d : Nat -> Nat
  D : Nat -> Prop
  Accepted : Nat -> Prop
  Rejected : Nat -> Prop
  EmptySuffixRejected : Nat -> Prop
  NonemptyRejected : Nat -> Prop
  SmoothException : Nat -> Prop
  TerminalSlabException : Nat -> Prop
  acceptedPrefix : Nat -> List Nat
  acceptedPrefix_def :
    ∀ m : Nat, acceptedPrefix m = modifiedGreedyAcceptedPrefixFromDeletion D m

/-- A candidate scan either accepts the candidate into the prefix or rejects it. -/
inductive ScanDecision where
  | accept
  | reject

/--
One concrete finite step of the modified greedy scan.  The formal step only
records the collision test; private-barrier/forced rejections are represented
by choosing the reject branch.
-/
inductive ModifiedGreedyScanStep :
    List Nat -> Nat -> List Nat -> ScanDecision -> Prop where
  | accept {xs : List Nat} {n : Nat} :
      FiniteDistinctConsecutiveBlockProducts (xs ++ [n]) ->
        ModifiedGreedyScanStep xs n (xs ++ [n]) ScanDecision.accept
  | reject {xs : List Nat} {n : Nat} :
      ModifiedGreedyScanStep xs n xs ScanDecision.reject

/--
Relational scan interface for the modified greedy construction.  It is still a
boundary assumption, but it is object-indexed and constructive bookkeeping:
accepted values are exactly the enumerated sequence, rejections are the
complement of acceptance, prefixes are reachable by scan steps, and finite
prefix block products agree with the infinite sequence on sufficiently long
prefixes.
-/
structure ModifiedGreedyScan (data : ModifiedGreedyConstructionData) where
  stepRelational :
    ∀ m : Nat,
      ∃ decision : ScanDecision,
        ModifiedGreedyScanStep (data.acceptedPrefix m) (m + 3)
          (data.acceptedPrefix (m + 1)) decision
  prefixGreedy : ∀ m : Nat, ModifiedGreedyPrefix (data.acceptedPrefix m)
  prefixEnumeratesD :
    ∀ m i : Nat, i < (data.acceptedPrefix m).length ->
      (data.acceptedPrefix m).getD i 1 = data.d i
  prefixCoversBlocks :
    ∀ u v : Nat,
      u ≤ v ->
        ∃ m : Nat,
          v < (data.acceptedPrefix m).length ∧
            ∀ u' v' : Nat,
              u' ≤ v' ->
                v' < (data.acceptedPrefix m).length ->
                  finiteBlockProduct (data.acceptedPrefix m) u' v' =
                    blockProduct data.d u' v'
  acceptedExactlyEnumerated :
    ∀ n : Nat, data.Accepted n ↔ ∃ i : Nat, data.d i = n
  rejectedExactlyNotAccepted :
    ∀ n : Nat, data.Rejected n ↔ ¬ data.Accepted n
  positiveEnumerated : ∀ i : Nat, 0 < data.d i
  strictlyEnumerated : StrictlyIncreasing data.d

theorem modifiedGreedyAcceptedPrefixFromDeletion_step
    (D : Nat -> Prop) :
    ∀ m : Nat,
      ∃ decision : ScanDecision,
        ModifiedGreedyScanStep (modifiedGreedyAcceptedPrefixFromDeletion D m) (m + 3)
          (modifiedGreedyAcceptedPrefixFromDeletion D (m + 1)) decision := by
  classical
  intro m
  by_cases hD : D (m + 3)
  · refine ⟨ScanDecision.reject, ?_⟩
    simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, ModifiedGreedyScanStep.reject]
  · by_cases hdistinct :
        FiniteDistinctConsecutiveBlockProducts
          (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
    · refine ⟨ScanDecision.accept, ?_⟩
      simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct,
        ModifiedGreedyScanStep.accept hdistinct]
    · refine ⟨ScanDecision.reject, ?_⟩
      simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct,
        ModifiedGreedyScanStep.reject]

theorem modifiedGreedyAcceptedPrefixFromDeletion_greedy
    (D : Nat -> Prop) :
    ∀ m : Nat, ModifiedGreedyPrefix (modifiedGreedyAcceptedPrefixFromDeletion D m) := by
  classical
  intro m
  induction m with
  | zero =>
      exact ModifiedGreedyPrefix.initial
  | succ m ih =>
      by_cases hD : D (m + 3)
      · simpa [modifiedGreedyAcceptedPrefixFromDeletion, hD] using
          (ModifiedGreedyPrefix.reject (n := m + 3) ih)
      · by_cases hdistinct :
          FiniteDistinctConsecutiveBlockProducts
            (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
        · simpa [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] using
            (ModifiedGreedyPrefix.accept (n := m + 3) ih hdistinct)
        · simpa [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] using
            (ModifiedGreedyPrefix.reject (n := m + 3) ih)

/--
Finite private-barrier metadata for a selected semiprime barrier.  The intended
meaning is: `barrier = smallFactor * privateLabel`, the label is globally
private among selected barriers, and `horizon` is the finite range up to which
other multiples of the private label are deleted.
-/
structure PrivateBarrierLabel where
  shell : Nat
  block : Nat
  barrier : Nat
  smallFactor : Nat
  privateLabel : Nat
  horizon : Nat

/-- The concrete finite-horizon reasons by which an integer enters `D`. -/
inductive PrivateBarrierDeletionReason where
  | finiteInitial
  | shellBoundary (shell : Nat)
  | badBlock (shell block : Nat)
  | unmatchedBlock (shell block : Nat)
  | protectedPrefix (shell block : Nat)
  | horizonMultiple (label : PrivateBarrierLabel)

/--
Structured deletion-set constructor for the finite-horizon private-barrier
route.  This is still an external boundary, but it exposes the selected
barriers, their private labels, and the deletion reason for each forced
deletion instead of leaving `D` as an arbitrary predicate.
-/
structure PrivateBarrierDeletionSet where
  selectedBarrier : Nat -> Prop
  selectedLabel : Nat -> Option PrivateBarrierLabel
  deletionReason : Nat -> Option PrivateBarrierDeletionReason
  selected_has_label :
    ∀ b : Nat, selectedBarrier b -> ∃ label : PrivateBarrierLabel,
      selectedLabel b = some label ∧ label.barrier = b
  label_selects_barrier :
    ∀ b : Nat, ∀ label : PrivateBarrierLabel,
      selectedLabel b = some label -> selectedBarrier b ∧ label.barrier = b
  selected_protected :
    ∀ b : Nat, selectedBarrier b -> deletionReason b = none
  horizon_reason_has_private_label :
    ∀ n : Nat, ∀ label : PrivateBarrierLabel,
      deletionReason n = some (PrivateBarrierDeletionReason.horizonMultiple label) ->
        n ≠ label.barrier

def PrivateBarrierDeletionSet.Deleted (pkg : PrivateBarrierDeletionSet) (n : Nat) : Prop :=
  ∃ reason : PrivateBarrierDeletionReason, pkg.deletionReason n = some reason

/--
Minimal prime predicate used only to state the private-label arithmetic
interface.  It avoids importing a larger arithmetic library while recording
the exact facts the old-new/new-old collision proof needs.
-/
def PrimeLike (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ a b : Nat, a * b = p -> a = 1 ∨ b = 1

theorem primeLike_two : PrimeLike 2 := by
  constructor
  · omega
  · intro a b h
    have ha : a ∣ 2 := ⟨b, h.symm⟩
    have hle : a ≤ 2 := Nat.le_of_dvd (by omega) ha
    rcases Nat.lt_or_eq_of_le hle with hlt | ha2
    · have ha0or1 : a = 0 ∨ a = 1 := by omega
      rcases ha0or1 with ha0 | ha1
      · subst a
        simp at h
      · exact Or.inl ha1
    · subst a
      right
      omega

theorem primeLike_three : PrimeLike 3 := by
  constructor
  · omega
  · intro a b h
    have ha : a ∣ 3 := ⟨b, h.symm⟩
    have hle : a ≤ 3 := Nat.le_of_dvd (by omega) ha
    rcases Nat.lt_or_eq_of_le hle with hlt | ha3
    · have ha_cases : a = 0 ∨ a = 1 ∨ a = 2 := by omega
      rcases ha_cases with ha0 | ha1 | ha2
      · subst a
        simp at h
      · exact Or.inl ha1
      · subst a
        have hb_cases : b = 0 ∨ b = 1 := by omega
        rcases hb_cases with hb0 | hb1
        · subst b
          simp at h
        · exact Or.inr hb1
    · subst a
      right
      omega

theorem PrimeLike.not_dvd_one {p : Nat} (hp : PrimeLike p) :
    ¬ p ∣ 1 := by
  intro h
  have hp2 : 2 ≤ p := hp.1
  have hle : p ≤ 1 := Nat.le_of_dvd (by omega) h
  omega

theorem PrimeLike.dvd_mul {p a b : Nat} (hp : PrimeLike p)
    (h : p ∣ a * b) :
    p ∣ a ∨ p ∣ b := by
  rcases (Nat.dvd_mul.mp h) with ⟨pa, pb, hpa, hpb, hmul⟩
  rcases hp.2 pa pb hmul with hpa_one | hpb_one
  · right
    have hpb_eq : pb = p := by
      simpa [hpa_one] using hmul
    simpa [hpb_eq] using hpb
  · left
    have hpa_eq : pa = p := by
      simpa [hpb_one] using hmul
    simpa [hpa_eq] using hpa

theorem PrimeLike.dvd_foldl_mul_of_not_dvd_acc {p : Nat}
    (hp : PrimeLike p) (f : Nat -> Nat) :
    ∀ ks : List Nat, ∀ acc : Nat,
      p ∣ ks.foldl (fun acc k => acc * f k) acc ->
        p ∣ acc ∨ ∃ k : Nat, k ∈ ks ∧ p ∣ f k := by
  intro ks
  induction ks with
  | nil =>
      intro acc h
      exact Or.inl h
  | cons k ks ih =>
      intro acc h
      have htail := ih (acc * f k) h
      rcases htail with hhead | htail_factor
      · rcases hp.dvd_mul hhead with hacc | hf
        · exact Or.inl hacc
        · exact Or.inr ⟨k, by simp, hf⟩
      · rcases htail_factor with ⟨k', hk', hf'⟩
        exact Or.inr ⟨k', by simp [hk'], hf'⟩

theorem PrimeLike.one_lt {p : Nat} (hp : PrimeLike p) : 1 < p := by
  exact hp.1

theorem PrimeLike.dvd_prime_like_eq {p q : Nat}
    (hp : PrimeLike p) (hq : PrimeLike q) (h : p ∣ q) :
    p = q := by
  rcases h with ⟨k, hk⟩
  have hq_mul : p * k = q := by simpa [Nat.mul_comm] using hk.symm
  rcases hq.2 p k hq_mul with hp_one | hk_one
  · have : 1 < p := hp.one_lt
    omega
  · subst hk_one
    simpa using hq_mul

theorem PrimeLike.dvd_finiteBlockProduct_factor {p : Nat}
    (hp : PrimeLike p) (xs : List Nat) {u v : Nat}
    (huv : u ≤ v)
    (h : p ∣ finiteBlockProduct xs u v) :
    ∃ i : Nat, u ≤ i ∧ i ≤ v ∧ p ∣ xs.getD i 1 := by
  unfold finiteBlockProduct at h
  have hsplit :=
    hp.dvd_foldl_mul_of_not_dvd_acc
      (fun k => xs.getD (u + k) 1) (List.range (v + 1 - u)) 1 h
  rcases hsplit with hone | hfactor
  · exact False.elim (hp.not_dvd_one hone)
  · rcases hfactor with ⟨k, hk, hk_dvd⟩
    have hklt : k < v + 1 - u := by
      simpa using (List.mem_range.mp hk)
    refine ⟨u + k, by omega, by omega, ?_⟩
    simpa using hk_dvd

/--
Strengthened arithmetic interface for `PrivateBarrierDeletionSet`.

The existing deletion package records labels and finite-horizon deletion
reasons.  These extra fields are the missing local facts identified by the
Lovasz/Explorer handoff: selected labels are semiprime factors, private labels
are globally unique among selected barriers, and every earlier nonbarrier
multiple of the private label is actually deleted before the barrier horizon.
-/
structure PrivateBarrierArithmetic (pkg : PrivateBarrierDeletionSet) where
  selected_label_arithmetic :
    ∀ b : Nat, pkg.selectedBarrier b -> ∃ label : PrivateBarrierLabel,
      pkg.selectedLabel b = some label ∧
        label.barrier = b ∧
        label.smallFactor * label.privateLabel = b ∧
        PrimeLike label.smallFactor ∧
        PrimeLike label.privateLabel ∧
        label.smallFactor < label.privateLabel ∧
        b ≤ label.horizon
  selected_label_global_private :
    ∀ b b' : Nat, ∀ label label' : PrivateBarrierLabel,
      pkg.selectedBarrier b ->
        pkg.selectedBarrier b' ->
          pkg.selectedLabel b = some label ->
            pkg.selectedLabel b' = some label' ->
              label.privateLabel = label'.privateLabel ->
                b = b'
  horizon_deletes_earlier_nonbarrier_multiples :
    ∀ b n : Nat, ∀ label : PrivateBarrierLabel,
      pkg.selectedBarrier b ->
        pkg.selectedLabel b = some label ->
          n < b ->
            n ≤ label.horizon ->
              label.privateLabel ∣ n ->
                n ≠ b ->
                  pkg.Deleted n
  horizon_reason_exact :
    ∀ n : Nat, ∀ label : PrivateBarrierLabel,
      pkg.deletionReason n = some (PrivateBarrierDeletionReason.horizonMultiple label) ->
        label.privateLabel ∣ n ∧ n ≤ label.horizon ∧ n ≠ label.barrier

/--
Concrete dyadic shell metadata for the selected-record source layer.  The
propositional fields are deliberately local witnesses from the construction,
not downstream private-barrier package assumptions.
-/
structure ConcreteDyadicShell where
  left : Nat
  right : Nat
  isDyadic : Prop
  right_eq_two_left : right = 2 * left
  largeEnough : Prop

/-- A full block inside a concrete shell. -/
structure ConcreteFullBlock where
  shell : ConcreteDyadicShell
  blockLeft : Nat
  length : Nat
  length_eq_shell_log_power : Prop
  containedInShell : Prop
  fullBlock : Prop

/-- An admissible start whose finite window lies inside a full block. -/
structure ConcreteAdmissibleStart (block : ConcreteFullBlock) where
  start : Nat
  inBlock : Prop
  mtWindowInsideBlock : Prop

/--
Concrete Nat-level D04 admissible-start predicate for a fixed full block and a
fixed finite window length.  This is the arithmetic content of
`main.tex:413-415`: for a block `[U, U + L_X)`, a start `y` is admissible when
`U <= y` and `y + L_0 < U + L_X`.
-/
def D04AdmissibleStartNat (block : ConcreteFullBlock) (windowLength y : Nat) : Prop :=
  block.blockLeft ≤ y ∧ y + windowLength < block.blockLeft + block.length

/--
The canonical finite list of Nat starts satisfying the D04 admissibility
inequalities for a concrete block and finite window length.
-/
noncomputable def d04AdmissibleStartNatList
    (block : ConcreteFullBlock) (windowLength : Nat) : List Nat := by
  classical
  exact ((List.range (block.length + 1)).map (fun k => block.blockLeft + k)).filter
    (fun y => D04AdmissibleStartNat block windowLength y)

/--
Checked finite enumeration/completeness for the Nat-level D04 admissible-start
predicate.  The remaining source-object bridge is to turn these Nat starts into
`ConcreteAdmissibleStart` values by proving the block-membership and MT-window
facts for the logarithmic window used in the shell.
-/
theorem mem_d04AdmissibleStartNatList_iff
    (block : ConcreteFullBlock) (windowLength y : Nat) :
    y ∈ d04AdmissibleStartNatList block windowLength ↔
      D04AdmissibleStartNat block windowLength y := by
  classical
  constructor
  · intro hy
    exact of_decide_eq_true (List.mem_filter.mp hy).2
  · intro hy
    rcases hy with ⟨hleft, hwindow⟩
    have hmem_map :
        y ∈ (List.range (block.length + 1)).map (fun k => block.blockLeft + k) := by
      refine List.mem_map.mpr ?_
      refine ⟨y - block.blockLeft, ?_, ?_⟩
      · exact List.mem_range.mpr (by omega)
      · exact Nat.add_sub_of_le hleft
    exact List.mem_filter.mpr
      ⟨hmem_map, decide_eq_true (show
        D04AdmissibleStartNat block windowLength y from ⟨hleft, hwindow⟩)⟩

/--
Turn a checked Nat-level D04 admissible start into the concrete source object
used by the shell interfaces.
-/
def concreteAdmissibleStartOfD04Nat
    (block : ConcreteFullBlock) (windowLength y : Nat)
    (_hy : D04AdmissibleStartNat block windowLength y) :
    ConcreteAdmissibleStart block :=
  { start := y
    inBlock := block.blockLeft ≤ y
    mtWindowInsideBlock := y + windowLength < block.blockLeft + block.length }

/--
Concrete admissible-start list obtained from the finite Nat enumeration.  This
keeps the list computationally tied to `d04AdmissibleStartNatList`; each listed
record carries the exact proof of the corresponding D04 Nat inequalities.
-/
noncomputable def d04ConcreteAdmissibleStartList
    (block : ConcreteFullBlock) (windowLength : Nat) :
    List (ConcreteAdmissibleStart block) := by
  classical
  exact (d04AdmissibleStartNatList block windowLength).attach.map
    (fun y =>
      concreteAdmissibleStartOfD04Nat block windowLength y.1
        ((mem_d04AdmissibleStartNatList_iff block windowLength y.1).1 y.2))

theorem mem_d04ConcreteAdmissibleStartList_sound
    (block : ConcreteFullBlock) (windowLength : Nat)
    (startObj : ConcreteAdmissibleStart block) :
    startObj ∈ d04ConcreteAdmissibleStartList block windowLength ->
      D04AdmissibleStartNat block windowLength startObj.start := by
  classical
  intro hmem
  rcases List.mem_map.mp hmem with ⟨y, _hy_mem, hstartObj⟩
  rw [← hstartObj]
  exact (mem_d04AdmissibleStartNatList_iff block windowLength y.1).1 y.2

theorem d04ConcreteAdmissibleStartList_complete
    (block : ConcreteFullBlock) (windowLength y : Nat)
    (hy : D04AdmissibleStartNat block windowLength y) :
    ∃ startObj : ConcreteAdmissibleStart block,
      startObj ∈ d04ConcreteAdmissibleStartList block windowLength ∧
        startObj.start = y := by
  classical
  let hy_mem : y ∈ d04AdmissibleStartNatList block windowLength :=
    (mem_d04AdmissibleStartNatList_iff block windowLength y).2 hy
  let yAttached : {z // z ∈ d04AdmissibleStartNatList block windowLength} :=
    ⟨y, hy_mem⟩
  let startObj :=
    concreteAdmissibleStartOfD04Nat block windowLength y
      ((mem_d04AdmissibleStartNatList_iff block windowLength y).1 hy_mem)
  refine ⟨startObj, ?_, rfl⟩
  dsimp [d04ConcreteAdmissibleStartList, startObj, yAttached]
  exact List.mem_map.mpr ⟨yAttached, List.mem_attach _ _, rfl⟩

/-- Candidate semiprime private label supplied by a block and start. -/
structure ConcreteCandidateSemiprime (block : ConcreteFullBlock) where
  start : Nat
  barrier : Nat
  smallFactor : Nat
  privateLabel : Nat
  start_admissible : ConcreteAdmissibleStart block
  windowLength : Nat
  barrier_in_window : start < barrier ∧ barrier ≤ start + windowLength
  semiprime_eq : smallFactor * privateLabel = barrier
  small_prime : PrimeLike smallFactor
  private_prime : PrimeLike privateLabel
  small_lt_private : smallFactor < privateLabel
  smallFactor_lower : Prop
  smallFactor_upper : Prop
  privateLabel_lower : Prop
  mt_provenance : Prop

theorem privateLabel_eq_of_ordered_semiprime_eq
    {block block' : ConcreteFullBlock}
    (c : ConcreteCandidateSemiprime block)
    (d : ConcreteCandidateSemiprime block')
    (hbarrier : c.barrier = d.barrier) :
    c.privateLabel = d.privateLabel := by
  have hcprod : c.smallFactor * c.privateLabel =
      d.smallFactor * d.privateLabel := by
    calc
      c.smallFactor * c.privateLabel = c.barrier := c.semiprime_eq
      _ = d.barrier := hbarrier
      _ = d.smallFactor * d.privateLabel := d.semiprime_eq.symm
  have hcpriv_dvd :
      c.privateLabel ∣ d.smallFactor * d.privateLabel := by
    rw [← hcprod]
    exact Nat.dvd_mul_left c.privateLabel c.smallFactor
  rcases c.private_prime.dvd_mul hcpriv_dvd with hcpriv_dvd_dsmall |
      hcpriv_dvd_dpriv
  · have hcpriv_eq_dsmall :
        c.privateLabel = d.smallFactor :=
      c.private_prime.dvd_prime_like_eq d.small_prime hcpriv_dvd_dsmall
    have hdpriv_dvd :
        d.privateLabel ∣ c.smallFactor * c.privateLabel := by
      rw [hcprod]
      exact Nat.dvd_mul_left d.privateLabel d.smallFactor
    rcases d.private_prime.dvd_mul hdpriv_dvd with hdpriv_dvd_csmall |
        hdpriv_dvd_cpriv
    · have hdpriv_eq_csmall :
          d.privateLabel = c.smallFactor :=
        d.private_prime.dvd_prime_like_eq c.small_prime hdpriv_dvd_csmall
      have hlt2 : c.privateLabel < c.smallFactor := by
        simpa [hcpriv_eq_dsmall, hdpriv_eq_csmall] using d.small_lt_private
      exact False.elim (Nat.lt_asymm c.small_lt_private hlt2)
    · have hdpriv_eq_cpriv :
          d.privateLabel = c.privateLabel :=
        d.private_prime.dvd_prime_like_eq c.private_prime hdpriv_dvd_cpriv
      have hlt : c.privateLabel < c.privateLabel := by
        simpa [hcpriv_eq_dsmall, hdpriv_eq_cpriv] using d.small_lt_private
      exact False.elim (Nat.lt_irrefl c.privateLabel hlt)
  · exact c.private_prime.dvd_prime_like_eq d.private_prime hcpriv_dvd_dpriv

/--
Finite block-local candidate enumeration for one MT-good full block.

This is only the D04 list surface: it packages admissible starts, MT-good
starts, start-semiprime incidences, deduplicated barriers, and private labels.
It does not assert downstream deletion-set, occurrence-supply, LZ3, or final
target facts.
-/
structure ConcreteGoodFullBlockCandidateSupply (block : ConcreteFullBlock) where
  admissibleStarts : List (ConcreteAdmissibleStart block)
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startSemiprimeIncidences : List (ConcreteCandidateSemiprime block)
  candidateSemiprimes : List (ConcreteCandidateSemiprime block)
  candidatePrivateLabels : List Nat
  mtGoodStarts_sublist_admissible : Prop
  incidences_from_mt_good_starts : Prop
  candidates_from_incidences : Prop
  candidates_deduplicated_by_barrier : Prop
  privateLabels_are_candidate_labels :
    ∀ label : Nat,
      label ∈ candidatePrivateLabels ↔
        ∃ c : ConcreteCandidateSemiprime block,
          c ∈ candidateSemiprimes ∧ c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    candidatePrivateLabels.Pairwise (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.privateLabel_lower
  mt_candidate_provenance :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.mt_provenance
  incidence_count_lower_bound : Prop
  candidate_count_lower_bound : Prop
  privateLabel_count_lower_bound : Prop
  nonempty_candidates : 0 < candidateSemiprimes.length

/--
Explicit block-local MT incidence data.  This is the source-side shape of D04:
it records the finite admissible-start list, the MT-good sublist, the counted
start-semiprime incidences, the deduplicated candidate semiprimes, and the
private-label projection needed by the concrete candidate-supply layer.
-/
structure MTGoodFullBlockIncidenceSupply (block : ConcreteFullBlock) where
  admissibleStarts : List (ConcreteAdmissibleStart block)
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startSemiprimeIncidences : List (ConcreteCandidateSemiprime block)
  candidateSemiprimes : List (ConcreteCandidateSemiprime block)
  candidatePrivateLabels : List Nat
  mtGoodStarts_sublist_admissible : Prop
  incidences_from_mt_good_starts : Prop
  candidates_from_incidences : Prop
  candidates_deduplicated_by_barrier : Prop
  privateLabels_are_candidate_labels :
    ∀ label : Nat,
      label ∈ candidatePrivateLabels ↔
        ∃ c : ConcreteCandidateSemiprime block,
          c ∈ candidateSemiprimes ∧ c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    candidatePrivateLabels.Pairwise (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.privateLabel_lower
  mt_candidate_provenance :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.mt_provenance
  incidence_count_lower_bound : Prop
  candidate_count_lower_bound : Prop
  privateLabel_count_lower_bound : Prop
  nonempty_candidates : 0 < candidateSemiprimes.length

/--
Source-local nonbadness for one full block in the D04/MT step.  It records the
two local inputs used in `main.tex:454-463`: enough admissible starts are MT-good,
and the MT windows stay inside the long block.  It is intentionally not a
private-barrier, deletion, density, localization, or final-target assumption.
-/
structure D04MTNonbadFullBlock (block : ConcreteFullBlock) where
  at_least_half_admissible_starts_mt_good : Prop
  mt_windows_inside_long_block : Prop

/--
Natural-number stand-ins for the logarithmic powers in the source MT input.
They keep the finite D04 predicate source-facing without adding analytic
real-number infrastructure to this combinatorial interface.
-/
structure StructuredMTLogPowerProxy where
  logPow109 : Nat -> Nat
  logPow110 : Nat -> Nat
  logPow210 : Nat -> Nat

/-- Rational proxy for the positive MT constant `c_0` from `main.tex`. -/
structure StructuredMTConstantProxy where
  c0Num : Nat
  c0Den : Nat
  c0Num_pos : 0 < c0Num
  c0Den_pos : 0 < c0Den

/--
Concrete source-facing candidate predicate for Input `inp:MT`: a semiprime in
the MT window whose small factor lies in the prescribed logarithmic interval.
-/
def StructuredMTWindowCandidateFromInputMT
    (logp : StructuredMTLogPowerProxy)
    {block : ConcreteFullBlock}
    (startObj : ConcreteAdmissibleStart block)
    (candidate : ConcreteCandidateSemiprime block) : Prop :=
  candidate.start = startObj.start ∧
    startObj.start < candidate.barrier ∧
      candidate.barrier ≤ startObj.start + logp.logPow210 startObj.start ∧
        PrimeLike candidate.smallFactor ∧
          PrimeLike candidate.privateLabel ∧
            candidate.smallFactor * candidate.privateLabel = candidate.barrier ∧
              logp.logPow109 startObj.start < candidate.smallFactor ∧
                candidate.smallFactor ≤ logp.logPow110 startObj.start

/--
Concrete MT-good start predicate reflecting Input `inp:MT`: sufficiently many
pairwise barrier-distinct semiprimes satisfy the structured MT window
conditions attached to the admissible start.
-/
def StructuredMTGoodStartFromInputMT
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {block : ConcreteFullBlock}
    (startObj : ConcreteAdmissibleStart block) : Prop :=
  ∃ candidates : List (ConcreteCandidateSemiprime block),
    candidates.Pairwise (fun c d => c.barrier ≠ d.barrier) ∧
      mt.c0Num * logp.logPow110 startObj.start ≤
        mt.c0Den * candidates.length ∧
          ∀ candidate,
            candidate ∈ candidates ->
              StructuredMTWindowCandidateFromInputMT logp startObj candidate

/-- A pairwise-start-distinct list has at most one item with any fixed start. -/
theorem filter_start_eq_length_le_one_of_pairwise
    {α : Type}
    (startOf : α -> Nat)
    (targetStart : Nat)
    (items : List α)
    (hstart_pairwise : items.Pairwise (fun item other => startOf item ≠ startOf other)) :
    (items.filter (fun item => decide (startOf item = targetStart))).length ≤ 1 := by
  induction items with
  | nil => simp
  | cons item tail ih =>
      have htail_pairwise :
          tail.Pairwise (fun item other => startOf item ≠ startOf other) :=
        (List.pairwise_cons.mp hstart_pairwise).2
      by_cases hitem : startOf item = targetStart
      · have htail_empty :
            tail.filter (fun item => decide (startOf item = targetStart)) = [] := by
          rw [List.filter_eq_nil_iff]
          intro tailItem htailItem htailTopDec
          have htailTop : startOf tailItem = targetStart :=
            of_decide_eq_true htailTopDec
          exact
            (List.rel_of_pairwise_cons hstart_pairwise htailItem)
              (by omega)
        simp [hitem, htail_empty]
      · have htail_len := ih htail_pairwise
        simp [hitem]
        exact htail_len

/--
Finite interval count for integer starts in the half-open window
`targetBarrier - windowLength <= start < targetBarrier`.

This is the Nat/List replacement for the TeX statement that a fixed semiprime
`b` can only be counted by starts `y` with `b - L_0(X) < y < b`.  The proof
separates the possible top start `targetBarrier - 1` and recurses on the
shorter window.
-/
theorem start_window_list_length_le
    {α : Type}
    (startOf : α -> Nat)
    (targetBarrier windowLength : Nat)
    (items : List α)
    (hwindow :
      ∀ item : α,
        item ∈ items ->
          startOf item < targetBarrier ∧
            targetBarrier ≤ startOf item + windowLength)
    (hstart_pairwise : items.Pairwise (fun item other => startOf item ≠ startOf other)) :
    items.length ≤ windowLength := by
  induction windowLength generalizing targetBarrier items with
  | zero =>
      cases items with
      | nil => simp
      | cons item tail =>
          have hitem := hwindow item (by simp)
          omega
  | succ windowLength ih =>
      cases targetBarrier with
      | zero =>
          cases items with
          | nil => simp
          | cons item tail =>
              have hitem := hwindow item (by simp)
              omega
      | succ targetBarrier =>
          let isTop : α -> Bool := fun item => decide (startOf item = targetBarrier)
          let topItems := items.filter isTop
          let restItems := items.filter (fun item => Bool.not (isTop item))
          have hpartition :
              items.length = topItems.length + restItems.length := by
            have h :=
              List.countP_eq_countP_filter_add items (fun _ : α => true) isTop
            have hcount :
                (items.filter (fun _ : α => true)).length =
                  topItems.length + restItems.length := by
              simpa [topItems, restItems, isTop, List.countP_true,
                List.countP_eq_length_filter] using h
            have hfilter_true_len :
                (items.filter (fun _ : α => true)).length = items.length := by
              have hfilter_true :
                  (items.filter (fun _ : α => true)) = items := by
                exact (List.filter_eq_self).2 (by intro item hitem; rfl)
              rw [hfilter_true]
            omega
          have htop_len : topItems.length ≤ 1 := by
            simpa [topItems, isTop] using
              filter_start_eq_length_le_one_of_pairwise
                startOf targetBarrier items hstart_pairwise
          have hrest_window :
              ∀ restItem : α,
                restItem ∈ restItems ->
                  startOf restItem < targetBarrier ∧
                    targetBarrier ≤ startOf restItem + windowLength := by
            intro restItem hrestItem
            have hfilter := (List.mem_filter.mp hrestItem)
            have hrest_mem : restItem ∈ items := hfilter.1
            have hnot_top_bool : Bool.not (isTop restItem) = true := hfilter.2
            have hnot_top : startOf restItem ≠ targetBarrier := by
              intro htop
              have : isTop restItem = true := by
                simp [isTop, htop]
              simp [this] at hnot_top_bool
            have hfacts := hwindow restItem hrest_mem
            omega
          have hrest_pairwise :
              restItems.Pairwise (fun item other => startOf item ≠ startOf other) := by
            exact List.Pairwise.filter (fun item => Bool.not (isTop item)) hstart_pairwise
          have hrest_len :
              restItems.length ≤ windowLength :=
            ih targetBarrier restItems hrest_window hrest_pairwise
          omega

/-- Classical decidability for the source-facing MT-good start predicate. -/
noncomputable def structuredMTGoodStartDecidable
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock) :
    DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block)) := by
  classical
  exact fun startObj => inferInstance

/--
Explicit finite D04/MT incidence data for one sufficiently large nonbad full
block.  The analytic MT and interval-counting content appears as source-local
premises on the concrete lists, while this record avoids assuming
`MTGoodFullBlockIncidenceSupply` itself.
-/
structure D04MTFullBlockIncidenceData (block : ConcreteFullBlock) where
  admissibleStarts : List (ConcreteAdmissibleStart block)
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startSemiprimeIncidences : List (ConcreteCandidateSemiprime block)
  candidateSemiprimes : List (ConcreteCandidateSemiprime block)
  candidatePrivateLabels : List Nat
  mtGoodStarts_sublist_admissible : Prop
  incidences_from_mt_good_starts : Prop
  candidates_from_incidences : Prop
  candidates_deduplicated_by_barrier : Prop
  privateLabels_are_candidate_labels :
    ∀ label : Nat,
      label ∈ candidatePrivateLabels ↔
        ∃ c : ConcreteCandidateSemiprime block,
          c ∈ candidateSemiprimes ∧ c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    candidatePrivateLabels.Pairwise (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.privateLabel_lower
  mt_candidate_provenance :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.mt_provenance
  mt_incidence_count_lower_bound : Prop
  fixed_semiprime_incidence_multiplicity_bound : Prop
  fixed_semiprime_incidence_multiplicity_bound_proof :
    fixed_semiprime_incidence_multiplicity_bound
  fixed_block_distinct_semiprime_lower_bound : Prop
  fixed_label_one_semiprime_per_long_block : Prop
  fixed_label_one_semiprime_per_long_block_proof :
    fixed_label_one_semiprime_per_long_block
  mt_window_to_candidate_small_factor_window : Prop
  incidence_count_lower_bound_prop : Prop
  incidence_count_lower_bound_proof : incidence_count_lower_bound_prop
  candidate_count_lower_bound_prop : Prop
  candidate_count_lower_bound_proof : candidate_count_lower_bound_prop
  privateLabel_count_lower_bound_prop : Prop
  privateLabel_count_lower_bound_proof : privateLabel_count_lower_bound_prop
  nonempty_candidates : 0 < candidateSemiprimes.length

/--
Finite/list-level form of the bundled Section 4 local supply step
(`main.tex:465-477`) for one nonbad full block.

The bundle is indexed by the actual flattened incidence list, deduplicated
candidate list, and private-label list.  Its fields expose the fixed-barrier
fiber bound, incidence lower bound, barrier deduplication, the
one-label-per-long-block injectivity statement, and the final label-count lower
bound as concrete finite propositions rather than unrelated opaque slots.
-/
structure SourceLocalMTFiniteSupplyBundle
    {block : ConcreteFullBlock}
    (startSemiprimeIncidences : List (ConcreteCandidateSemiprime block))
    (candidateSemiprimes : List (ConcreteCandidateSemiprime block))
    (candidatePrivateLabels : List Nat) where
  fiberBound : Nat
  windowLength : Nat
  fiberBound_eq_windowLength_add_one : fiberBound = windowLength + 1
  incidenceLowerBound : Nat
  candidateLowerBound : Nat
  labelLowerBound : Nat
  incidences_in_window :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ startSemiprimeIncidences ->
        c.windowLength = windowLength ∧
          c.start < c.barrier ∧
            c.barrier ≤ c.start + windowLength
  start_barrier_determines_incidence :
    ∀ c d : ConcreteCandidateSemiprime block,
      c ∈ startSemiprimeIncidences ->
        d ∈ startSemiprimeIncidences ->
          c.start = d.start ->
            c.barrier = d.barrier ->
              c = d
  start_barrier_pairwise_distinct :
    startSemiprimeIncidences.Pairwise
      (fun c d => c.start ≠ d.start ∨ c.barrier ≠ d.barrier)
  fixed_semiprime_incidence_multiplicity_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ startSemiprimeIncidences ->
        ((startSemiprimeIncidences.filter
          (fun d => decide (d.barrier = c.barrier))).length <= fiberBound)
  incidence_count_lower_bound :
    incidenceLowerBound <= startSemiprimeIncidences.length
  candidates_subset_start_incidences :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c ∈ startSemiprimeIncidences
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise (fun c d => c.barrier ≠ d.barrier)
  incidences_covered_by_candidate_barrier :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ startSemiprimeIncidences ->
        ∃ d : ConcreteCandidateSemiprime block,
          d ∈ candidateSemiprimes ∧ d.barrier = c.barrier
  candidate_count_lower_bound :
    candidateLowerBound <= candidateSemiprimes.length
  incidence_bound_after_deduplication :
    incidenceLowerBound <= candidateSemiprimes.length * fiberBound
  one_semiprime_per_private_label_in_long_block :
    ∀ c d : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes ->
        d ∈ candidateSemiprimes ->
          c.privateLabel = d.privateLabel ->
            c = d
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise (fun c d => c.privateLabel ≠ d.privateLabel)
  candidatePrivateLabels_eq_map :
    candidatePrivateLabels = candidateSemiprimes.map (fun c => c.privateLabel)
  label_count_lower_bound :
    labelLowerBound <= candidatePrivateLabels.length

/--
Concrete fixed-semiprime fiber theorem for the source-local D04 incidence list.
For a fixed barrier, the filtered incidences inject into the start window of
length `windowLength`; the bundle uses the explicit TeX `O(1)` encoding
`fiberBound = windowLength + 1`.
-/
theorem D04_fixed_semiprime_incidence_multiplicity_from_window
    {block : ConcreteFullBlock}
    (startSemiprimeIncidences : List (ConcreteCandidateSemiprime block))
    (windowLength fiberBound : Nat)
    (hfiber : fiberBound = windowLength + 1)
    (hwindow :
      ∀ d : ConcreteCandidateSemiprime block,
        d ∈ startSemiprimeIncidences ->
          d.windowLength = windowLength ∧
            d.start < d.barrier ∧
              d.barrier ≤ d.start + windowLength)
    (_hstart_barrier_determines_incidence :
      ∀ d e : ConcreteCandidateSemiprime block,
        d ∈ startSemiprimeIncidences ->
        e ∈ startSemiprimeIncidences ->
          d.start = e.start ->
            d.barrier = e.barrier ->
              d = e)
    (hstart_barrier_pairwise_distinct :
      startSemiprimeIncidences.Pairwise
        (fun d e => d.start ≠ e.start ∨ d.barrier ≠ e.barrier)) :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ startSemiprimeIncidences ->
        ((startSemiprimeIncidences.filter
          (fun d => decide (d.barrier = c.barrier))).length <= fiberBound) := by
  intro c hc
  let fiber :=
    startSemiprimeIncidences.filter (fun d => decide (d.barrier = c.barrier))
  have hfiber_window :
      ∀ d : ConcreteCandidateSemiprime block,
        d ∈ fiber ->
          d.start < c.barrier ∧ c.barrier ≤ d.start + windowLength := by
    intro d hd
    have hd_filter := (List.mem_filter.mp hd)
    have hd_mem : d ∈ startSemiprimeIncidences := hd_filter.1
    have hd_barrier : d.barrier = c.barrier := of_decide_eq_true hd_filter.2
    have hd_window := hwindow d hd_mem
    omega
  have hfiber_pairwise :
      fiber.Pairwise
        (fun d e : ConcreteCandidateSemiprime block => d.start ≠ e.start) := by
    refine (List.pairwise_filter.mpr ?_)
    refine hstart_barrier_pairwise_distinct.imp ?_
    intro d e hpair hd_filter he_filter hstart
    rcases hpair with hstart_ne | hbarrier_ne
    · exact hstart_ne hstart
    · have hd_barrier : d.barrier = c.barrier := of_decide_eq_true hd_filter
      have he_barrier : e.barrier = c.barrier := of_decide_eq_true he_filter
      exact hbarrier_ne (by omega)
  have hlen_window :
      fiber.length ≤ windowLength :=
    start_window_list_length_le
      (fun d : ConcreteCandidateSemiprime block => d.start)
      c.barrier windowLength fiber hfiber_window hfiber_pairwise
  have hlen_filter :
      ((startSemiprimeIncidences.filter
        (fun d => decide (d.barrier = c.barrier))).length ≤ windowLength) := by
    simpa [fiber] using hlen_window
  omega

/--
Source-local MT incidence input for one nonbad D04 full block.

This is the narrow analytic boundary for `main.tex:454-484` and
`solution.wit:1467-1511`: it carries the finite admissible-start enumeration,
the MT-good subenumeration supplied by nonbadness, the start-semiprime
incidences, the deduplicated semiprimes, the one-label-per-long-block
deduplication, and the log-window transfer.  It deliberately stays before all
downstream deletion, density, localization, and final-target layers.
-/
structure SourceLocalMTIncidenceInput (block : ConcreteFullBlock) where
  admissibleStarts : List (ConcreteAdmissibleStart block)
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startSemiprimeIncidences : List (ConcreteCandidateSemiprime block)
  candidateSemiprimes : List (ConcreteCandidateSemiprime block)
  candidatePrivateLabels : List Nat
  admissible_start_list_complete : Prop
  mt_good_start_predicate_exact : Prop
  nonbad_gives_enough_mt_good_starts : Prop
  mtGoodStarts_sublist_admissible : Prop
  incidences_from_mt_good_starts : Prop
  candidates_from_incidences : Prop
  candidates_deduplicated_by_barrier : Prop
  privateLabels_are_candidate_labels :
    ∀ label : Nat,
      label ∈ candidatePrivateLabels ↔
        ∃ c : ConcreteCandidateSemiprime block,
          c ∈ candidateSemiprimes ∧ c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    candidatePrivateLabels.Pairwise (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.privateLabel_lower
  mt_candidate_provenance :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.mt_provenance
  mt_start_semiprime_incidence_lower_bound : Prop
  mt_start_semiprime_incidence_lower_bound_proof :
    mt_start_semiprime_incidence_lower_bound
  fixed_semiprime_incidence_multiplicity_bound : Prop
  fixed_semiprime_incidence_multiplicity_bound_proof :
    fixed_semiprime_incidence_multiplicity_bound
  distinct_semiprime_lower_bound_after_deduplication : Prop
  one_semiprime_per_private_label_in_long_block : Prop
  one_semiprime_per_private_label_in_long_block_proof :
    one_semiprime_per_private_label_in_long_block
  log_y_to_log_b_small_factor_window_transfer : Prop
  incidence_count_lower_bound_prop : Prop
  incidence_count_lower_bound_proof : incidence_count_lower_bound_prop
  candidate_count_lower_bound_prop : Prop
  candidate_count_lower_bound_proof : candidate_count_lower_bound_prop
  privateLabel_count_lower_bound_prop : Prop
  privateLabel_count_lower_bound_proof : privateLabel_count_lower_bound_prop
  finite_supply_bundle :
    SourceLocalMTFiniteSupplyBundle
      startSemiprimeIncidences candidateSemiprimes candidatePrivateLabels
  nonempty_candidates : 0 < candidateSemiprimes.length

/--
Block-local output supplied by the shell-level MT E2 interface.

This is not the final `ConcreteMTTheoremInput`; it keeps the finite block
payload behind the external theorem boundary.  Its fields correspond to
`main.tex:188-199` for MT-good starts and to the D04/nonbad extraction in
`main.tex:454-484` / `solution.wit:1467-1511`.
-/
structure ConcreteMTE2BlockOutput (block : ConcreteFullBlock) where
  admissibleStarts : List (ConcreteAdmissibleStart block)
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startSemiprimeIncidences : List (ConcreteCandidateSemiprime block)
  candidateSemiprimes : List (ConcreteCandidateSemiprime block)
  candidatePrivateLabels : List Nat
  admissible_start_list_complete : Prop
  mt_good_start_predicate_exact : Prop
  nonbad_gives_enough_mt_good_starts : Prop
  mtGoodStarts_sublist_admissible : Prop
  incidences_from_mt_good_starts : Prop
  candidates_from_incidences : Prop
  candidates_deduplicated_by_barrier : Prop
  privateLabels_are_candidate_labels :
    ∀ label : Nat,
      label ∈ candidatePrivateLabels ↔
        ∃ c : ConcreteCandidateSemiprime block,
          c ∈ candidateSemiprimes ∧ c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    candidatePrivateLabels.Pairwise (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.privateLabel_lower
  mt_candidate_provenance :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.mt_provenance
  mt_start_semiprime_incidence_lower_bound : Prop
  mt_start_semiprime_incidence_lower_bound_proof :
    mt_start_semiprime_incidence_lower_bound
  fixed_semiprime_incidence_multiplicity_bound : Prop
  fixed_semiprime_incidence_multiplicity_bound_proof :
    fixed_semiprime_incidence_multiplicity_bound
  distinct_semiprime_lower_bound_after_deduplication : Prop
  one_semiprime_per_private_label_in_long_block : Prop
  one_semiprime_per_private_label_in_long_block_proof :
    one_semiprime_per_private_label_in_long_block
  log_y_to_log_b_small_factor_window_transfer : Prop
  incidence_count_lower_bound_prop : Prop
  incidence_count_lower_bound_proof : incidence_count_lower_bound_prop
  candidate_count_lower_bound_prop : Prop
  candidate_count_lower_bound_proof : candidate_count_lower_bound_prop
  privateLabel_count_lower_bound_prop : Prop
  privateLabel_count_lower_bound_proof : privateLabel_count_lower_bound_prop
  finite_supply_bundle :
    SourceLocalMTFiniteSupplyBundle
      startSemiprimeIncidences candidateSemiprimes candidatePrivateLabels
  nonempty_candidates : 0 < candidateSemiprimes.length

/--
Shell-level Matomäki--Teräväinen E2 theorem interface for the D04 step.

The global fields name the source theorem and shell/block consequences:
existence of the MT constants, sparse exceptional starts, the definition of bad
blocks, and the window-containment and incidence/deduplication estimates used in
the nonbad-block extraction.  The only per-block payload is
`block_output_for_nonbad_full_block`, which is still local to one concrete full
block and does not mention private-barrier deletion sets, selected occurrence
supply, density/localization facts, `Erdos421Target`, final composition, or
`main_tex_theorem`.
-/
structure ConcreteMTE2TheoremForShell (shell : ConcreteDyadicShell) where
  mt_constants_c0_delta_positive : Prop
  mt_exceptional_starts_sparse_in_shell : Prop
  bad_block_definition_fewer_than_half_good : Prop
  nonbad_blocks_have_enough_mt_good_starts : Prop
  mt_intervals_remain_inside_full_blocks : Prop
  good_starts_give_start_semiprime_incidences : Prop
  fixed_semiprime_counted_by_few_starts : Prop
  distinct_semiprime_lower_bound_after_deduplication : Prop
  fixed_label_one_semiprime_per_long_block : Prop
  mt_window_transfers_to_candidate_small_factor_window : Prop
  block_output_for_nonbad_full_block :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              ConcreteMTE2BlockOutput block

/--
Shell-level MT/D04 facts excluding the per-block finite-list payload.  These
are the global consequences of `main.tex:188-199` and `main.tex:454-463` that
belong to the shell before any downstream private-barrier construction.
-/
structure ConcreteMTE2ShellFacts (shell : ConcreteDyadicShell) where
  mt_constants_c0_delta_positive : Prop
  mt_exceptional_starts_sparse_in_shell : Prop
  mt_exceptional_starts_sparse_in_shell_proof :
    mt_exceptional_starts_sparse_in_shell
  bad_block_definition_fewer_than_half_good : Prop
  bad_block_definition_fewer_than_half_good_proof :
    bad_block_definition_fewer_than_half_good
  nonbad_blocks_have_enough_mt_good_starts : Prop
  mt_intervals_remain_inside_full_blocks : Prop
  good_starts_give_start_semiprime_incidences : Prop
  fixed_semiprime_counted_by_few_starts : Prop
  distinct_semiprime_lower_bound_after_deduplication : Prop
  fixed_label_one_semiprime_per_long_block : Prop
  mt_window_transfers_to_candidate_small_factor_window : Prop

/--
Concrete D04 admissible-start and MT-incidence enumeration input for every
nonbad full block in a shell.  This is the remaining source-local analytic
boundary behind `ConcreteMTE2TheoremForShell.block_output_for_nonbad_full_block`.
-/
structure D04NonbadFullBlockSourceLocalInputFamily
    (shell : ConcreteDyadicShell) where
  source_local_input_for_nonbad_full_block :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              SourceLocalMTIncidenceInput block

def placeholderAdmissibleStart (block : ConcreteFullBlock) :
    ConcreteAdmissibleStart block :=
  { start := 0
    inBlock := True
    mtWindowInsideBlock := True }

def placeholderCandidateSemiprime (block : ConcreteFullBlock) :
    ConcreteCandidateSemiprime block :=
  { start := 0
    barrier := 6
    smallFactor := 2
    privateLabel := 3
    start_admissible := placeholderAdmissibleStart block
    windowLength := 6
    barrier_in_window := by omega
    semiprime_eq := rfl
    small_prime := primeLike_two
    private_prime := primeLike_three
    small_lt_private := by omega
    smallFactor_lower := True
    smallFactor_upper := True
    privateLabel_lower := True
    mt_provenance := True }

def placeholderSourceLocalMTFiniteSupplyBundle
    (block : ConcreteFullBlock) :
    SourceLocalMTFiniteSupplyBundle
      [placeholderCandidateSemiprime block]
      [placeholderCandidateSemiprime block]
      [3] :=
  { fiberBound := 7
    windowLength := 6
    fiberBound_eq_windowLength_add_one := rfl
    incidenceLowerBound := 1
    candidateLowerBound := 1
    labelLowerBound := 1
    incidences_in_window := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      simp [placeholderCandidateSemiprime]
    start_barrier_determines_incidence := by
      intro c d hc hd _hstart _hbarrier
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      have hd' : d = placeholderCandidateSemiprime block := by simpa using hd
      subst c
      subst d
      rfl
    start_barrier_pairwise_distinct := by
      simp
    fixed_semiprime_incidence_multiplicity_bound := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      simp [placeholderCandidateSemiprime]
    incidence_count_lower_bound := by
      simp
    candidates_subset_start_incidences := by
      intro c hc
      simpa using hc
    candidate_barriers_pairwise_distinct := by
      simp
    incidences_covered_by_candidate_barrier := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      exact ⟨placeholderCandidateSemiprime block, by simp, rfl⟩
    candidate_count_lower_bound := by
      simp
    incidence_bound_after_deduplication := by
      simp
    one_semiprime_per_private_label_in_long_block := by
      intro c d hc hd _hlabel
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      have hd' : d = placeholderCandidateSemiprime block := by simpa using hd
      subst c
      subst d
      rfl
    candidate_privateLabels_pairwise_distinct := by
      simp
    candidatePrivateLabels_eq_map := rfl
    label_count_lower_bound := by
      simp }

def placeholderSourceLocalMTIncidenceInput
    (block : ConcreteFullBlock) :
    SourceLocalMTIncidenceInput block :=
  { admissibleStarts := [placeholderAdmissibleStart block]
    mtGoodStarts := [placeholderAdmissibleStart block]
    startSemiprimeIncidences := [placeholderCandidateSemiprime block]
    candidateSemiprimes := [placeholderCandidateSemiprime block]
    candidatePrivateLabels := [3]
    admissible_start_list_complete := True
    mt_good_start_predicate_exact := True
    nonbad_gives_enough_mt_good_starts := True
    mtGoodStarts_sublist_admissible := True
    incidences_from_mt_good_starts := True
    candidates_from_incidences := True
    candidates_deduplicated_by_barrier := True
    privateLabels_are_candidate_labels := by
      intro label
      constructor
      · intro hlabel
        have hlabel' : label = 3 := by simpa using hlabel
        subst label
        exact ⟨placeholderCandidateSemiprime block, by simp, rfl⟩
      · intro h
        rcases h with ⟨c, hc, hprivate⟩
        have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
        subst c
        simpa [placeholderCandidateSemiprime] using hprivate.symm
    candidate_barriers_pairwise_distinct := by
      simp
    candidate_privateLabels_pairwise_distinct := by
      simp
    privateLabel_list_pairwise_distinct := by
      simp
    smallFactor_log_lower_bound := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      trivial
    smallFactor_log_upper_bound := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      trivial
    privateLabel_large_lower_bound := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      trivial
    mt_candidate_provenance := by
      intro c hc
      have hc' : c = placeholderCandidateSemiprime block := by simpa using hc
      subst c
      trivial
    mt_start_semiprime_incidence_lower_bound := True
    mt_start_semiprime_incidence_lower_bound_proof := trivial
    fixed_semiprime_incidence_multiplicity_bound := True
    fixed_semiprime_incidence_multiplicity_bound_proof := trivial
    distinct_semiprime_lower_bound_after_deduplication := True
    one_semiprime_per_private_label_in_long_block := True
    one_semiprime_per_private_label_in_long_block_proof := trivial
    log_y_to_log_b_small_factor_window_transfer := True
    incidence_count_lower_bound_prop := True
    incidence_count_lower_bound_proof := trivial
    candidate_count_lower_bound_prop := True
    candidate_count_lower_bound_proof := trivial
    privateLabel_count_lower_bound_prop := True
    privateLabel_count_lower_bound_proof := trivial
    finite_supply_bundle := placeholderSourceLocalMTFiniteSupplyBundle block
    nonempty_candidates := by
      simp }

def placeholderD04NonbadFullBlockSourceLocalInputFamily
    (shell : ConcreteDyadicShell) :
    D04NonbadFullBlockSourceLocalInputFamily shell :=
  { source_local_input_for_nonbad_full_block :=
      fun block _h_shell _h_large _h_full _h_nonbad =>
        placeholderSourceLocalMTIncidenceInput block }

/--
Exact finite admissible-start enumeration for the D04 source-local layer in one
shell.  This object carries only the finite admissible-start lists and their
completeness/projection facts; MT-good starts, incidences, deduplication, and
private-label estimates are supplied separately by
`AnalyticMTE2D04Consequences`.
-/
structure D04AdmissibleStartEnumerationForShell
    (shell : ConcreteDyadicShell) where
  admissibleStartsForBlock :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              List (ConcreteAdmissibleStart block)
  admissible_start_list_complete_prop :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  admissible_start_list_complete_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              admissible_start_list_complete_prop
                block h_shell h_large h_full h_nonbad
  admissible_starts_project_to_block_prop :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  admissible_starts_project_to_block_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              admissible_starts_project_to_block_prop
                block h_shell h_large h_full h_nonbad
  admissible_windows_inside_full_block_prop :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  admissible_windows_inside_full_block_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              admissible_windows_inside_full_block_prop
                block h_shell h_large h_full h_nonbad

/--
Checked shell-level D04 admissible-start enumeration from the Nat finite list.

The shell still needs an external choice of the finite MT window length used in
the D04 predicate; this theorem does not assert the analytic identification of
that natural number with the logarithmic `L_0(X)` from the paper.
-/
noncomputable def construct_D04AdmissibleStartEnumerationForShell_from_nat_list
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat) :
    D04AdmissibleStartEnumerationForShell shell :=
  { admissibleStartsForBlock :=
      fun block _h_shell _h_large _h_full _h_nonbad =>
        d04ConcreteAdmissibleStartList block windowLengthForShell
    admissible_start_list_complete_prop :=
      fun block _h_shell _h_large _h_full _h_nonbad =>
        (∀ startObj : ConcreteAdmissibleStart block,
          startObj ∈ d04ConcreteAdmissibleStartList block windowLengthForShell ->
            D04AdmissibleStartNat block windowLengthForShell startObj.start) ∧
        (∀ y : Nat,
          D04AdmissibleStartNat block windowLengthForShell y ->
            ∃ startObj : ConcreteAdmissibleStart block,
              startObj ∈ d04ConcreteAdmissibleStartList block windowLengthForShell ∧
                startObj.start = y)
    admissible_start_list_complete_proof :=
      fun block _h_shell _h_large _h_full _h_nonbad =>
        ⟨mem_d04ConcreteAdmissibleStartList_sound block windowLengthForShell,
          d04ConcreteAdmissibleStartList_complete block windowLengthForShell⟩
    admissible_starts_project_to_block_prop :=
      fun block _h_shell _h_large _h_full _h_nonbad =>
        ∀ startObj : ConcreteAdmissibleStart block,
          startObj ∈ d04ConcreteAdmissibleStartList block windowLengthForShell ->
            block.blockLeft ≤ startObj.start
    admissible_starts_project_to_block_proof :=
      fun block _h_shell _h_large _h_full _h_nonbad startObj hmem =>
        (mem_d04ConcreteAdmissibleStartList_sound
          block windowLengthForShell startObj hmem).1
    admissible_windows_inside_full_block_prop :=
      fun block _h_shell _h_large _h_full _h_nonbad =>
        ∀ startObj : ConcreteAdmissibleStart block,
          startObj ∈ d04ConcreteAdmissibleStartList block windowLengthForShell ->
            startObj.start + windowLengthForShell < block.blockLeft + block.length
    admissible_windows_inside_full_block_proof :=
      fun block _h_shell _h_large _h_full _h_nonbad startObj hmem =>
        (mem_d04ConcreteAdmissibleStartList_sound
          block windowLengthForShell startObj hmem).2 }

/--
Block-local MT-good predicate boundary for Prompt 2.  This is only a predicate
slot on the already-checked D04 admissible-start objects; the analytic
Matomäki--Teräväinen E2 theorem must still provide the actual predicate and
count estimate.
-/
abbrev D04MTGoodStartPredicate (block : ConcreteFullBlock) :=
  ConcreteAdmissibleStart block -> Prop

/--
Legacy predicate-slot adapter for the source-facing structured MT-good
predicate.  This keeps older D04 fields using `D04MTGoodStartPredicate` tied to
the exact `StructuredMTGoodStartFromInputMT` predicate.
-/
def structuredIsMTGoodPredicate
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock) :
    D04MTGoodStartPredicate block :=
  fun startObj => StructuredMTGoodStartFromInputMT logp mt startObj

/-- Boolean decision form of the structured MT-good predicate. -/
noncomputable def structuredIsMTGoodBool
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {block : ConcreteFullBlock}
    (startObj : ConcreteAdmissibleStart block) : Bool := by
  classical
  exact decide (StructuredMTGoodStartFromInputMT logp mt startObj)

theorem structuredIsMTGoodBool_true_iff
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {block : ConcreteFullBlock}
    (startObj : ConcreteAdmissibleStart block) :
    structuredIsMTGoodBool logp mt startObj = true ↔
      StructuredMTGoodStartFromInputMT logp mt startObj := by
  classical
  simp [structuredIsMTGoodBool]

/--
Canonical MT-good sublist over the checked D04 Nat-interval admissible-start
enumeration for one full block.
-/
noncomputable def mtGoodStartsFilter
    (block : ConcreteFullBlock) (windowLength : Nat)
    (isMTGood : D04MTGoodStartPredicate block) :
    List (ConcreteAdmissibleStart block) := by
  classical
  exact (d04ConcreteAdmissibleStartList block windowLength).filter
    (fun startObj => isMTGood startObj)

/--
Canonical MT-good sublist using the source-facing structured MT predicate,
rather than an arbitrary predicate slot.
-/
noncomputable def structuredMTGoodStartsFilter
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (mt_good_decidable :
      DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block))) :
    List (ConcreteAdmissibleStart block) := by
  letI := mt_good_decidable
  exact (d04ConcreteAdmissibleStartList block windowLength).filter
    (fun startObj => StructuredMTGoodStartFromInputMT logp mt startObj)

theorem mtGoodStartsFilter_structured_eq
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (mt_good_decidable :
      DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block))) :
    mtGoodStartsFilter block windowLength
        (structuredIsMTGoodPredicate logp mt block) =
      structuredMTGoodStartsFilter
        logp mt block windowLength mt_good_decidable := by
  classical
  unfold mtGoodStartsFilter structuredMTGoodStartsFilter
  apply List.filter_congr
  intro startObj _hmem
  by_cases hgood : StructuredMTGoodStartFromInputMT logp mt startObj
  · simp [structuredIsMTGoodPredicate, hgood]
  · simp [structuredIsMTGoodPredicate, hgood]

/--
Structured source-local nonbadness for one full block and one MT window length.
The half-good assertion is the concrete finite-list inequality used in D04,
not an opaque proposition.
-/
structure D04MTStructuredNonbadFullBlock
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat) where
  mt_good_decidable :
    DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block))
  nonbad_half_good_bound :
    (structuredMTGoodStartsFilter
        logp mt block windowLength mt_good_decidable).length * 2 ≥
      (d04ConcreteAdmissibleStartList block windowLength).length
  mt_windows_inside_long_block :
    ∀ startObj : ConcreteAdmissibleStart block,
      startObj ∈ d04ConcreteAdmissibleStartList block windowLength ->
        startObj.start + logp.logPow210 startObj.start ≤
          startObj.start + windowLength

/-- Concrete sublist target used by the source-local MT-good field. -/
def MTGoodStartsSublistAdmissible
    {block : ConcreteFullBlock}
    (mtGoodStarts admissibleStarts : List (ConcreteAdmissibleStart block)) :
    Prop :=
  mtGoodStarts.Sublist admissibleStarts

/-- Concrete Nat count target for the Prompt 2 MT-good lower bound. -/
def MTGoodStartsCountLowerBound
    {block : ConcreteFullBlock}
    (mtGoodStarts : List (ConcreteAdmissibleStart block))
    (lowerBound : Nat) : Prop :=
  lowerBound ≤ mtGoodStarts.length

theorem list_filter_good_double_ge_of_bad_double_le
    {α : Type} (xs : List α) (p : α -> Bool)
    (hbad : ((xs.filter (fun x => !p x)).length * 2) <= xs.length) :
    xs.length <= (xs.filter p).length * 2 := by
  classical
  have hpartition :
      (xs.filter p).length + (xs.filter (fun x => !p x)).length = xs.length := by
    clear hbad
    induction xs with
    | nil =>
        simp
    | cons x xs ih =>
        cases hp : p x <;>
          simp [hp, Nat.add_comm, Nat.add_assoc] <;>
          omega
  omega

theorem structuredMTGoodStartsFilter_double_ge_of_exceptional_double_le
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (mt_good_decidable :
      DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block)))
    (h_exceptional :
      (((d04ConcreteAdmissibleStartList block windowLength).filter
          (fun startObj =>
            !(@decide
              (StructuredMTGoodStartFromInputMT logp mt startObj)
              (mt_good_decidable startObj)))).length * 2) <=
        (d04ConcreteAdmissibleStartList block windowLength).length) :
    (d04ConcreteAdmissibleStartList block windowLength).length <=
      (structuredMTGoodStartsFilter
        logp mt block windowLength mt_good_decidable).length * 2 := by
  classical
  simpa [structuredMTGoodStartsFilter] using
    list_filter_good_double_ge_of_bad_double_le
      (d04ConcreteAdmissibleStartList block windowLength)
      (fun startObj =>
        @decide
          (StructuredMTGoodStartFromInputMT logp mt startObj)
          (mt_good_decidable startObj))
      h_exceptional

theorem list_filter_bad_double_le_of_good_double_ge
    {α : Type} (xs : List α) (p : α -> Bool)
    (hgood : xs.length <= (xs.filter p).length * 2) :
    ((xs.filter (fun x => !p x)).length * 2) <= xs.length := by
  classical
  have hpartition :
      (xs.filter p).length + (xs.filter (fun x => !p x)).length = xs.length := by
    clear hgood
    induction xs with
    | nil =>
        simp
    | cons x xs ih =>
        cases hp : p x <;>
          simp [hp, Nat.add_comm, Nat.add_assoc] <;>
          omega
  omega

theorem structuredMTExceptionalStartsFilter_double_le_of_good_double_ge
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (mt_good_decidable :
      DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block)))
    (h_good :
      (structuredMTGoodStartsFilter
        logp mt block windowLength mt_good_decidable).length * 2 >=
        (d04ConcreteAdmissibleStartList block windowLength).length) :
    (((d04ConcreteAdmissibleStartList block windowLength).filter
        (fun startObj =>
          !(@decide
            (StructuredMTGoodStartFromInputMT logp mt startObj)
            (mt_good_decidable startObj)))).length * 2) <=
      (d04ConcreteAdmissibleStartList block windowLength).length := by
  classical
  simpa [structuredMTGoodStartsFilter] using
    list_filter_bad_double_le_of_good_double_ge
      (d04ConcreteAdmissibleStartList block windowLength)
      (fun startObj =>
        @decide
          (StructuredMTGoodStartFromInputMT logp mt startObj)
          (mt_good_decidable startObj))
      h_good

theorem structuredMTGoodStartsCountLowerBound_from_exceptional_double_le
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (mt_good_decidable :
      DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block)))
    (h_exceptional :
      (((d04ConcreteAdmissibleStartList block windowLength).filter
          (fun startObj =>
            !(@decide
              (StructuredMTGoodStartFromInputMT logp mt startObj)
              (mt_good_decidable startObj)))).length * 2) <=
        (d04ConcreteAdmissibleStartList block windowLength).length) :
    MTGoodStartsCountLowerBound
      (structuredMTGoodStartsFilter
        logp mt block windowLength mt_good_decidable)
      (((d04ConcreteAdmissibleStartList block windowLength).length + 1) / 2) := by
  classical
  have hdouble :
      (d04ConcreteAdmissibleStartList block windowLength).length <=
        (structuredMTGoodStartsFilter
          logp mt block windowLength mt_good_decidable).length * 2 :=
    structuredMTGoodStartsFilter_double_ge_of_exceptional_double_le
      logp mt block windowLength mt_good_decidable h_exceptional
  unfold MTGoodStartsCountLowerBound
  omega

/--
Narrow name for the remaining analytic MT E2 obligation: on a nonbad D04 full
block, the structured MT-exceptional starts are at most half of the finite
admissible-start list.  This is a Prop-valued boundary, not a proof or axiom.
-/
def D04_E2_nonbad_exceptional_starts_half_bound_structured
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (_h_shell : block.shell = shell)
    (_h_large : shell.largeEnough)
    (_h_full : block.fullBlock)
    (_h_nonbad : D04MTNonbadFullBlock block) : Prop :=
  (((d04ConcreteAdmissibleStartList block windowLengthForShell).filter
      (fun startObj =>
        !(@decide
          (StructuredMTGoodStartFromInputMT logp mt startObj)
          ((structuredMTGoodStartDecidable logp mt block) startObj)))).length * 2) <=
    (d04ConcreteAdmissibleStartList block windowLengthForShell).length

/--
Per-good-start witnessed MT payload matching the local content of
`main.tex:188-198`: a finite list of semiprimes in the MT window, with the small
factor in the `(log y)^1.09, (log y)^1.1]` proxy interval and the stated
`c₀ (log y)^1.1` lower count.
-/
structure MT_E2_GoodStartWitness
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {block : ConcreteFullBlock}
    (startObj : ConcreteAdmissibleStart block) where
  candidates : List (ConcreteCandidateSemiprime block)
  barriers_pairwise_distinct :
    candidates.Pairwise (fun c d => c.barrier ≠ d.barrier)
  mt_count_lower :
    mt.c0Num * logp.logPow110 startObj.start <= mt.c0Den * candidates.length
  mt_provenance :
    ∀ c : ConcreteCandidateSemiprime block, c ∈ candidates -> c.mt_provenance
  smallFactor_lower :
    ∀ c : ConcreteCandidateSemiprime block, c ∈ candidates -> c.smallFactor_lower
  smallFactor_upper :
    ∀ c : ConcreteCandidateSemiprime block, c ∈ candidates -> c.smallFactor_upper
  privateLabel_lower :
    ∀ c : ConcreteCandidateSemiprime block, c ∈ candidates -> c.privateLabel_lower
  window_facts :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidates -> StructuredMTWindowCandidateFromInputMT logp startObj c

/--
Witnessed finite specialization of the Matomäki--Teräväinen `E₂` input.  The
witness exposes the MT-good starts and their per-start semiprime lists; D04
deduplication, fixed-semiprime fibers, private-label uniqueness, and downstream
matching are intentionally outside this axiom.
-/
structure MT_E2_CountWitness
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) where
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startIncidences : List (ConcreteCandidateSemiprime block)
  mtGoodStarts_eq_filter :
    mtGoodStarts =
      structuredMTGoodStartsFilter
        logp mt block windowLengthForShell
        (structuredMTGoodStartDecidable logp mt block)
  half_good_count :
    (structuredMTGoodStartsFilter
        logp mt block windowLengthForShell
        (structuredMTGoodStartDecidable logp mt block)).length * 2 >=
      (d04ConcreteAdmissibleStartList block windowLengthForShell).length
  per_good_start :
    ∀ startObj : ConcreteAdmissibleStart block,
      startObj ∈ mtGoodStarts ->
        MT_E2_GoodStartWitness logp mt startObj
  startIncidences_from_good_start_witnesses :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ startIncidences ↔
        ∃ startObj : ConcreteAdmissibleStart block,
          ∃ hmem : startObj ∈ mtGoodStarts,
            c ∈ (per_good_start startObj hmem).candidates

/--
External analytic input: the witnessed Matomäki--Teräväinen E2 count, specialized
to the finite D04 admissible-start list and the structured MT-good predicate.
This is the single analytic axiom for the Group A MT count path.
-/
axiom MT_E2_count_witnessed
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) :
  MT_E2_CountWitness
    logp mt windowLengthForShell block h_shell h_large h_full h_nonbad

/--
Count-only MT E2 consequence recovered from the witnessed axiom by finite-list
complement bookkeeping.
-/
theorem MT_E2_count
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) :
  D04_E2_nonbad_exceptional_starts_half_bound_structured
    logp mt windowLengthForShell block h_shell h_large h_full h_nonbad := by
  classical
  let wit :=
    MT_E2_count_witnessed
      logp mt windowLengthForShell block h_shell h_large h_full h_nonbad
  exact
    structuredMTExceptionalStartsFilter_double_le_of_good_double_ge
      logp mt block windowLengthForShell
      (structuredMTGoodStartDecidable logp mt block)
      wit.half_good_count

theorem structured_half_good_to_arbitrary_slot
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (mt_good_decidable :
      DecidablePred (StructuredMTGoodStartFromInputMT logp mt (block := block)))
    (h_half_good :
      (structuredMTGoodStartsFilter
          logp mt block windowLength mt_good_decidable).length * 2 ≥
        (d04ConcreteAdmissibleStartList block windowLength).length) :
    (mtGoodStartsFilter block windowLength
        (structuredIsMTGoodPredicate logp mt block)).length * 2 ≥
      (d04ConcreteAdmissibleStartList block windowLength).length := by
  rw [mtGoodStartsFilter_structured_eq logp mt block windowLength mt_good_decidable]
  exact h_half_good

theorem structured_half_good_from_MT_E2_count
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) :
    (structuredMTGoodStartsFilter
        logp mt block windowLengthForShell
        (structuredMTGoodStartDecidable logp mt block)).length * 2 ≥
      (d04ConcreteAdmissibleStartList block windowLengthForShell).length := by
  exact
    structuredMTGoodStartsFilter_double_ge_of_exceptional_double_le
      logp mt block windowLengthForShell
      (structuredMTGoodStartDecidable logp mt block)
      (MT_E2_count
        logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)

theorem structured_arbitrary_slot_half_good_from_MT_E2_count
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) :
    (mtGoodStartsFilter block windowLengthForShell
        (structuredIsMTGoodPredicate logp mt block)).length * 2 ≥
      (d04ConcreteAdmissibleStartList block windowLengthForShell).length := by
  exact
    structured_half_good_to_arbitrary_slot
      logp mt block windowLengthForShell
      (structuredMTGoodStartDecidable logp mt block)
      (structured_half_good_from_MT_E2_count
        logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)

theorem structured_MT_window_containment_from_hshell
    (logp : StructuredMTLogPowerProxy)
    {block : ConcreteFullBlock}
    (startObj : ConcreteAdmissibleStart block)
    (windowLengthForShell : Nat)
    (hshell : logp.logPow210 startObj.start ≤ windowLengthForShell) :
    startObj.start + logp.logPow210 startObj.start ≤
      startObj.start + windowLengthForShell :=
  Nat.add_le_add_left hshell startObj.start

theorem mtGoodStartsFilter_sublist_admissible
    (block : ConcreteFullBlock) (windowLength : Nat)
    (isMTGood : D04MTGoodStartPredicate block) :
    MTGoodStartsSublistAdmissible
      (mtGoodStartsFilter block windowLength isMTGood)
      (d04ConcreteAdmissibleStartList block windowLength) := by
  classical
  change
    ((d04ConcreteAdmissibleStartList block windowLength).filter
      (fun startObj : ConcreteAdmissibleStart block =>
        decide (isMTGood startObj))).Sublist
        (d04ConcreteAdmissibleStartList block windowLength)
  exact List.filter_sublist

/--
The checked sublist statement specialized to the admissible-start list returned
by `construct_D04AdmissibleStartEnumerationForShell_from_nat_list`.
-/
theorem mtGoodStartsFilter_sublist_D04_shell_enumeration
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block)
    (isMTGood : D04MTGoodStartPredicate block) :
    MTGoodStartsSublistAdmissible
      (mtGoodStartsFilter block windowLengthForShell isMTGood)
      ((construct_D04AdmissibleStartEnumerationForShell_from_nat_list
        (shell := shell) windowLengthForShell).admissibleStartsForBlock
          block h_shell h_large h_full h_nonbad) := by
  simpa [construct_D04AdmissibleStartEnumerationForShell_from_nat_list] using
    mtGoodStartsFilter_sublist_admissible
      block windowLengthForShell isMTGood

/--
Prompt 2 count bridge: once the E2/nonbad analysis supplies a concrete Nat
lower-bound proof for the filtered MT-good list, it is exactly the count target
needed by the source-local layer.
-/
theorem MTGood_count_lower_bound_from_E2
    (block : ConcreteFullBlock) (windowLength lowerBound : Nat)
    (isMTGood : D04MTGoodStartPredicate block)
    (hE2_count :
      lowerBound ≤
        (mtGoodStartsFilter block windowLength isMTGood).length) :
    MTGoodStartsCountLowerBound
      (mtGoodStartsFilter block windowLength isMTGood) lowerBound :=
  hE2_count

/--
Half-good finite-list count in the form used by the D04 source-local layer.
This is a pure arithmetic adapter: the caller must provide the concrete
half-good inequality for the filtered list.
-/
theorem MTGoodStartsCountLowerBound_from_half_good
    {block : ConcreteFullBlock}
    (mtGoodStarts admissibleStarts : List (ConcreteAdmissibleStart block))
    (hhalf : admissibleStarts.length ≤ mtGoodStarts.length * 2) :
    MTGoodStartsCountLowerBound
      mtGoodStarts ((admissibleStarts.length + 1) / 2) := by
  unfold MTGoodStartsCountLowerBound
  omega

/--
Structured MT-good count lower bound from the explicit MT E2 half-good
hypothesis.  This names the generator-safe bridge without changing the final
theorem target or accepting an arbitrary `isMTGood` predicate.
-/
theorem MTGoodStartsCountLowerBound_structured_from_MT_E2_count
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) :
    MTGoodStartsCountLowerBound
      (structuredMTGoodStartsFilter
        logp mt block windowLengthForShell
        (structuredMTGoodStartDecidable logp mt block))
      (((d04ConcreteAdmissibleStartList block windowLengthForShell).length + 1) / 2) := by
  exact
    MTGoodStartsCountLowerBound_from_half_good
      (structuredMTGoodStartsFilter
        logp mt block windowLengthForShell
        (structuredMTGoodStartDecidable logp mt block))
      (d04ConcreteAdmissibleStartList block windowLengthForShell)
      (structured_half_good_from_MT_E2_count
        logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)

/--
Incidence lower bound from an explicit per-start lower bound and an explicit
incidence-list construction count.  The theorem does not construct MT
incidences; it only records the Nat transfer once those finite records exist.
-/
theorem D04_start_semiprime_incidence_count_lower_bound_from_per_start
    {goodStartCount perStartLowerBound incidenceCount lowerBound : Nat}
    (hstarts : lowerBound ≤ goodStartCount * perStartLowerBound)
    (hincidences : goodStartCount * perStartLowerBound ≤ incidenceCount) :
    lowerBound ≤ incidenceCount :=
  Nat.le_trans hstarts hincidences

/--
Finite incidence lower-bound bookkeeping: a lower bound for incidences and an
upper multiplicity bound against candidates combine to the candidate-side
weighted lower bound.  This is the arithmetic double-counting shell; the
analytic D04 work supplies the two Nat inequalities.
-/
theorem finite_incidence_weighted_candidate_lower_bound
    {incidenceCount candidateCount multiplicity lowerBound : Nat}
    (hinc : lowerBound ≤ incidenceCount)
    (hmult : incidenceCount ≤ candidateCount * multiplicity) :
    lowerBound ≤ candidateCount * multiplicity :=
  Nat.le_trans hinc hmult

/--
Deduplicated double-counting in list form.  The proof is intentionally generic:
it assumes only explicit Nat count premises and does not refer to the
source-local incidence records.
-/
theorem finite_deduplicated_double_counting_lower_bound
    {α β : Type}
    (incidences : List α)
    (deduped : List β)
    (multiplicity lowerBound : Nat)
    (hinc : lowerBound ≤ incidences.length)
    (hmult : incidences.length ≤ deduped.length * multiplicity) :
    lowerBound ≤ deduped.length * multiplicity :=
  finite_incidence_weighted_candidate_lower_bound hinc hmult

/--
Prompt 5 finite double-counting adapter.  From an incidence lower bound and a
fixed-semiprime fiber upper bound, it extracts the distinct-candidate count
needed after deduplication.  All nontrivial mathematics is in the two explicit
Nat inequalities supplied by the caller.
-/
theorem D04_distinct_candidates_from_incidence_count
    {incidenceCount candidateCount multiplicity lowerBound : Nat}
    (hmultiplicity_pos : 0 < multiplicity)
    (hinc : lowerBound * multiplicity ≤ incidenceCount)
    (hfiber : incidenceCount ≤ candidateCount * multiplicity) :
    lowerBound ≤ candidateCount := by
  have hchain : lowerBound * multiplicity ≤ candidateCount * multiplicity :=
    Nat.le_trans hinc hfiber
  exact Nat.le_of_mul_le_mul_right hchain hmultiplicity_pos

/--
Prompt 4 fiber adapter.  The fixed-semiprime preimage bound is a theorem once
the caller supplies an explicit fiber inequality for the concrete finite lists.
-/
theorem D04_fixed_semiprime_preimage_start_bound
    {preimageCount fiberBound : Nat}
    (hfiber : preimageCount ≤ fiberBound) :
    preimageCount ≤ fiberBound :=
  hfiber

/--
Prompt 6 private-label adapter.  The one-semiprime-per-label conclusion is
only projected from an explicit injectivity/fiber hypothesis over the concrete
candidate lists.
-/
theorem D04_one_semiprime_per_private_label_in_long_block
    {block : ConcreteFullBlock}
    (candidates : List (ConcreteCandidateSemiprime block))
    (hone :
      ∀ c d : ConcreteCandidateSemiprime block,
        c ∈ candidates ->
          d ∈ candidates ->
            c.privateLabel = d.privateLabel ->
              c = d) :
    ∀ c d : ConcreteCandidateSemiprime block,
      c ∈ candidates ->
        d ∈ candidates ->
          c.privateLabel = d.privateLabel ->
            c = d :=
  hone

/--
List-count transfer from candidates to their private-label projection.  This is
the finite part of the label-count step; uniqueness of labels remains an
explicit hypothesis when needed.
-/
theorem finite_private_label_count_lower_bound_of_map
    {block : ConcreteFullBlock}
    (candidates : List (ConcreteCandidateSemiprime block))
    (lowerBound : Nat)
    (hcandidates : lowerBound ≤ candidates.length) :
    lowerBound ≤ (candidates.map (fun c => c.privateLabel)).length := by
  simpa using hcandidates

/--
Prompt 7 Nat/rational log-window transfer placeholder in theorem form.  The
caller must provide the exact concrete inequalities; this lemma only composes
them and does not hide real-log analysis in an opaque proposition.
-/
theorem D04_nat_log_window_transfer_109_to_108
    {smallFactor lower109 upper110 lower108 upper111 : Nat}
    (hlower : lower108 ≤ lower109)
    (hupper : upper110 ≤ upper111)
    (hsmall_lower : lower109 < smallFactor)
    (hsmall_upper : smallFactor ≤ upper110) :
    lower108 < smallFactor ∧ smallFactor ≤ upper111 := by
  constructor
  · exact Nat.lt_of_le_of_lt hlower hsmall_lower
  · exact Nat.le_trans hsmall_upper hupper

/--
Private-label count transfer from an explicit list equality.  Mignotte or
source arithmetic may be needed to prove such an equality for the old-new
separation, but this finite boundary itself is theorem-only.
-/
theorem finite_private_label_count_lower_bound_of_eq
    {block : ConcreteFullBlock}
    (candidates : List (ConcreteCandidateSemiprime block))
    (labels : List Nat)
    (lowerBound : Nat)
    (hcard : labels.length = candidates.length)
    (hcandidates : lowerBound ≤ candidates.length) :
    lowerBound ≤ labels.length := by
  simpa [hcard] using hcandidates

/--
Structured D04 E2 half-good projection.  Once the analytic MT/nonbad bridge
constructs `D04MTStructuredNonbadFullBlock`, the target finite inequality is
available directly.
-/
theorem D04_E2_nonbad_half_good_starts_structured
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (h_nonbad :
      D04MTStructuredNonbadFullBlock logp mt block windowLength) :
    (structuredMTGoodStartsFilter
        logp mt block windowLength h_nonbad.mt_good_decidable).length * 2 ≥
      (d04ConcreteAdmissibleStartList block windowLength).length := by
  exact h_nonbad.nonbad_half_good_bound

/-- Structured D04 E2 projection for MT-window containment. -/
theorem D04_E2_nonbad_MT_windows_inside_structured
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLength : Nat)
    (h_nonbad :
      D04MTStructuredNonbadFullBlock logp mt block windowLength)
    (startObj : ConcreteAdmissibleStart block)
    (hmem : startObj ∈ d04ConcreteAdmissibleStartList block windowLength) :
    startObj.start + logp.logPow210 startObj.start ≤
      startObj.start + windowLength := by
  exact h_nonbad.mt_windows_inside_long_block startObj hmem

/--
Conditional constructor for the structured D04/MT nonbad payload.  The two
hypotheses are exactly the remaining concrete analytic obligations: half of the
finite admissible-start list is MT-good, and every MT window remains inside the
chosen long-block window.
-/
noncomputable def construct_structured_nonbad_from_MT_E2_conditional
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    (block : ConcreteFullBlock)
    (windowLengthForShell : Nat)
    (h_half_good :
      (structuredMTGoodStartsFilter
          logp mt block windowLengthForShell
          (structuredMTGoodStartDecidable logp mt block)).length * 2 ≥
        (d04ConcreteAdmissibleStartList block windowLengthForShell).length)
    (h_mt_window :
      ∀ startObj : ConcreteAdmissibleStart block,
        startObj ∈ d04ConcreteAdmissibleStartList block windowLengthForShell ->
          startObj.start + logp.logPow210 startObj.start ≤
            startObj.start + windowLengthForShell) :
    D04MTStructuredNonbadFullBlock logp mt block windowLengthForShell :=
  { mt_good_decidable := structuredMTGoodStartDecidable logp mt block
    nonbad_half_good_bound := h_half_good
    mt_windows_inside_long_block := h_mt_window }

/--
Shell-level MT E2/D04 consequences needed after the finite admissible-start
enumeration is fixed.  The fields name the analytic counting and projection
facts used by `main.tex:454-484`: enough MT-good starts, start-semiprime
incidences, fixed-semiprime multiplicity, deduplication into distinct
candidates, private-label uniqueness, and the log-window transfer.

This is intentionally not a `SourceLocalMTIncidenceInput`,
`D04MTFullBlockIncidenceData`, or `ConcreteMTE2TheoremForShell` assumption.
-/
structure AnalyticMTE2D04Consequences
    (shell : ConcreteDyadicShell) where
  mtGoodStartsForBlock :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              List (ConcreteAdmissibleStart block)
  startSemiprimeIncidencesForBlock :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              List (ConcreteCandidateSemiprime block)
  candidateSemiprimesForBlock :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              List (ConcreteCandidateSemiprime block)
  candidatePrivateLabelsForBlock :
    ∀ block : ConcreteFullBlock,
      block.shell = shell ->
        shell.largeEnough ->
          block.fullBlock ->
            D04MTNonbadFullBlock block ->
              List Nat
  mt_good_start_predicate_exact :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  nonbad_gives_enough_mt_good_starts :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  mtGoodStarts_sublist_admissible :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  incidences_from_mt_good_starts :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  candidates_from_incidences :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  candidates_deduplicated_by_barrier :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  privateLabels_are_candidate_labels :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              ∀ label : Nat,
                label ∈ candidatePrivateLabelsForBlock
                  block h_shell h_large h_full h_nonbad ↔
                  ∃ c : ConcreteCandidateSemiprime block,
                    c ∈ candidateSemiprimesForBlock
                      block h_shell h_large h_full h_nonbad ∧
                      c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              (candidateSemiprimesForBlock
                block h_shell h_large h_full h_nonbad).Pairwise
                  (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              (candidateSemiprimesForBlock
                block h_shell h_large h_full h_nonbad).Pairwise
                  (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              (candidatePrivateLabelsForBlock
                block h_shell h_large h_full h_nonbad).Pairwise
                  (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              ∀ c : ConcreteCandidateSemiprime block,
                c ∈ candidateSemiprimesForBlock
                  block h_shell h_large h_full h_nonbad ->
                  c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              ∀ c : ConcreteCandidateSemiprime block,
                c ∈ candidateSemiprimesForBlock
                  block h_shell h_large h_full h_nonbad ->
                  c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              ∀ c : ConcreteCandidateSemiprime block,
                c ∈ candidateSemiprimesForBlock
                  block h_shell h_large h_full h_nonbad ->
                  c.privateLabel_lower
  mt_candidate_provenance :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              ∀ c : ConcreteCandidateSemiprime block,
                c ∈ candidateSemiprimesForBlock
                  block h_shell h_large h_full h_nonbad ->
                  c.mt_provenance
  mt_start_semiprime_incidence_lower_bound :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  mt_start_semiprime_incidence_lower_bound_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              mt_start_semiprime_incidence_lower_bound
                block h_shell h_large h_full h_nonbad
  fixed_semiprime_incidence_multiplicity_bound :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  fixed_semiprime_incidence_multiplicity_bound_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              fixed_semiprime_incidence_multiplicity_bound
                block h_shell h_large h_full h_nonbad
  distinct_semiprime_lower_bound_after_deduplication :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  one_semiprime_per_private_label_in_long_block :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  one_semiprime_per_private_label_in_long_block_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              one_semiprime_per_private_label_in_long_block
                block h_shell h_large h_full h_nonbad
  log_y_to_log_b_small_factor_window_transfer :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  incidence_count_lower_bound_prop :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  incidence_count_lower_bound_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              incidence_count_lower_bound_prop
                block h_shell h_large h_full h_nonbad
  candidate_count_lower_bound_prop :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  candidate_count_lower_bound_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              candidate_count_lower_bound_prop
                block h_shell h_large h_full h_nonbad
  privateLabel_count_lower_bound_prop :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              Prop
  privateLabel_count_lower_bound_proof :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              privateLabel_count_lower_bound_prop
                block h_shell h_large h_full h_nonbad
  finite_supply_bundle :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              SourceLocalMTFiniteSupplyBundle
                (startSemiprimeIncidencesForBlock
                  block h_shell h_large h_full h_nonbad)
                (candidateSemiprimesForBlock
                  block h_shell h_large h_full h_nonbad)
                (candidatePrivateLabelsForBlock
                  block h_shell h_large h_full h_nonbad)
  nonempty_candidates :
    ∀ block : ConcreteFullBlock,
      (h_shell : block.shell = shell) ->
        (h_large : shell.largeEnough) ->
          (h_full : block.fullBlock) ->
            (h_nonbad : D04MTNonbadFullBlock block) ->
              0 < (candidateSemiprimesForBlock
                block h_shell h_large h_full h_nonbad).length

/--
Checked source-object constructor for the nonbad D04 full-block source-local
input family.  This closes only the record boundary: the analytic and finite
enumeration structures still carry the actual MT E2/D04 mathematical content,
including finite admissible-start completeness.
-/
def construct_D04NonbadFullBlockSourceLocalInputFamily
    {shell : ConcreteDyadicShell}
    (analytic : AnalyticMTE2D04Consequences shell)
    (enum : D04AdmissibleStartEnumerationForShell shell) :
    D04NonbadFullBlockSourceLocalInputFamily shell := by
  refine
    { source_local_input_for_nonbad_full_block :=
        fun block h_shell h_large h_full h_nonbad => ?_ }
  exact
    { admissibleStarts :=
        enum.admissibleStartsForBlock block h_shell h_large h_full h_nonbad
      mtGoodStarts :=
        analytic.mtGoodStartsForBlock block h_shell h_large h_full h_nonbad
      startSemiprimeIncidences :=
        analytic.startSemiprimeIncidencesForBlock
          block h_shell h_large h_full h_nonbad
      candidateSemiprimes :=
        analytic.candidateSemiprimesForBlock
          block h_shell h_large h_full h_nonbad
      candidatePrivateLabels :=
        analytic.candidatePrivateLabelsForBlock
          block h_shell h_large h_full h_nonbad
      admissible_start_list_complete :=
        enum.admissible_start_list_complete_prop
          block h_shell h_large h_full h_nonbad
      mt_good_start_predicate_exact :=
        analytic.mt_good_start_predicate_exact
          block h_shell h_large h_full h_nonbad
      nonbad_gives_enough_mt_good_starts :=
        analytic.nonbad_gives_enough_mt_good_starts
          block h_shell h_large h_full h_nonbad
      mtGoodStarts_sublist_admissible :=
        analytic.mtGoodStarts_sublist_admissible
          block h_shell h_large h_full h_nonbad
      incidences_from_mt_good_starts :=
        analytic.incidences_from_mt_good_starts
          block h_shell h_large h_full h_nonbad
      candidates_from_incidences :=
        analytic.candidates_from_incidences
          block h_shell h_large h_full h_nonbad
      candidates_deduplicated_by_barrier :=
        analytic.candidates_deduplicated_by_barrier
          block h_shell h_large h_full h_nonbad
      privateLabels_are_candidate_labels :=
        analytic.privateLabels_are_candidate_labels
          block h_shell h_large h_full h_nonbad
      candidate_barriers_pairwise_distinct :=
        analytic.candidate_barriers_pairwise_distinct
          block h_shell h_large h_full h_nonbad
      candidate_privateLabels_pairwise_distinct :=
        analytic.candidate_privateLabels_pairwise_distinct
          block h_shell h_large h_full h_nonbad
      privateLabel_list_pairwise_distinct :=
        analytic.privateLabel_list_pairwise_distinct
          block h_shell h_large h_full h_nonbad
      smallFactor_log_lower_bound :=
        analytic.smallFactor_log_lower_bound
          block h_shell h_large h_full h_nonbad
      smallFactor_log_upper_bound :=
        analytic.smallFactor_log_upper_bound
          block h_shell h_large h_full h_nonbad
      privateLabel_large_lower_bound :=
        analytic.privateLabel_large_lower_bound
          block h_shell h_large h_full h_nonbad
      mt_candidate_provenance :=
        analytic.mt_candidate_provenance
          block h_shell h_large h_full h_nonbad
      mt_start_semiprime_incidence_lower_bound :=
        analytic.mt_start_semiprime_incidence_lower_bound
          block h_shell h_large h_full h_nonbad
      mt_start_semiprime_incidence_lower_bound_proof :=
        analytic.mt_start_semiprime_incidence_lower_bound_proof
          block h_shell h_large h_full h_nonbad
      fixed_semiprime_incidence_multiplicity_bound :=
        analytic.fixed_semiprime_incidence_multiplicity_bound
          block h_shell h_large h_full h_nonbad
      fixed_semiprime_incidence_multiplicity_bound_proof :=
        analytic.fixed_semiprime_incidence_multiplicity_bound_proof
          block h_shell h_large h_full h_nonbad
      distinct_semiprime_lower_bound_after_deduplication :=
        analytic.distinct_semiprime_lower_bound_after_deduplication
          block h_shell h_large h_full h_nonbad
      one_semiprime_per_private_label_in_long_block :=
        analytic.one_semiprime_per_private_label_in_long_block
          block h_shell h_large h_full h_nonbad
      one_semiprime_per_private_label_in_long_block_proof :=
        analytic.one_semiprime_per_private_label_in_long_block_proof
          block h_shell h_large h_full h_nonbad
      log_y_to_log_b_small_factor_window_transfer :=
        analytic.log_y_to_log_b_small_factor_window_transfer
          block h_shell h_large h_full h_nonbad
      incidence_count_lower_bound_prop :=
        analytic.incidence_count_lower_bound_prop
          block h_shell h_large h_full h_nonbad
      incidence_count_lower_bound_proof :=
        analytic.incidence_count_lower_bound_proof
          block h_shell h_large h_full h_nonbad
      candidate_count_lower_bound_prop :=
        analytic.candidate_count_lower_bound_prop
          block h_shell h_large h_full h_nonbad
      candidate_count_lower_bound_proof :=
        analytic.candidate_count_lower_bound_proof
          block h_shell h_large h_full h_nonbad
      privateLabel_count_lower_bound_prop :=
        analytic.privateLabel_count_lower_bound_prop
          block h_shell h_large h_full h_nonbad
      privateLabel_count_lower_bound_proof :=
        analytic.privateLabel_count_lower_bound_proof
          block h_shell h_large h_full h_nonbad
      finite_supply_bundle :=
        analytic.finite_supply_bundle
          block h_shell h_large h_full h_nonbad
      nonempty_candidates :=
        analytic.nonempty_candidates
          block h_shell h_large h_full h_nonbad }

/--
Checked record assembly from source-local D04/MT incidence input to the
block-output payload used by the shell MT E2 theorem interface.
-/
def construct_ConcreteMTE2BlockOutput_from_SourceLocalMTIncidenceInput
    {block : ConcreteFullBlock}
    (mt_input_for_block : SourceLocalMTIncidenceInput block) :
    ConcreteMTE2BlockOutput block := by
  exact
    { admissibleStarts := mt_input_for_block.admissibleStarts
      mtGoodStarts := mt_input_for_block.mtGoodStarts
      startSemiprimeIncidences :=
        mt_input_for_block.startSemiprimeIncidences
      candidateSemiprimes := mt_input_for_block.candidateSemiprimes
      candidatePrivateLabels := mt_input_for_block.candidatePrivateLabels
      admissible_start_list_complete :=
        mt_input_for_block.admissible_start_list_complete
      mt_good_start_predicate_exact :=
        mt_input_for_block.mt_good_start_predicate_exact
      nonbad_gives_enough_mt_good_starts :=
        mt_input_for_block.nonbad_gives_enough_mt_good_starts
      mtGoodStarts_sublist_admissible :=
        mt_input_for_block.mtGoodStarts_sublist_admissible
      incidences_from_mt_good_starts :=
        mt_input_for_block.incidences_from_mt_good_starts
      candidates_from_incidences :=
        mt_input_for_block.candidates_from_incidences
      candidates_deduplicated_by_barrier :=
        mt_input_for_block.candidates_deduplicated_by_barrier
      privateLabels_are_candidate_labels :=
        mt_input_for_block.privateLabels_are_candidate_labels
      candidate_barriers_pairwise_distinct :=
        mt_input_for_block.candidate_barriers_pairwise_distinct
      candidate_privateLabels_pairwise_distinct :=
        mt_input_for_block.candidate_privateLabels_pairwise_distinct
      privateLabel_list_pairwise_distinct :=
        mt_input_for_block.privateLabel_list_pairwise_distinct
      smallFactor_log_lower_bound :=
        mt_input_for_block.smallFactor_log_lower_bound
      smallFactor_log_upper_bound :=
        mt_input_for_block.smallFactor_log_upper_bound
      privateLabel_large_lower_bound :=
        mt_input_for_block.privateLabel_large_lower_bound
      mt_candidate_provenance := mt_input_for_block.mt_candidate_provenance
      mt_start_semiprime_incidence_lower_bound :=
        mt_input_for_block.mt_start_semiprime_incidence_lower_bound
      mt_start_semiprime_incidence_lower_bound_proof :=
        mt_input_for_block.mt_start_semiprime_incidence_lower_bound_proof
      fixed_semiprime_incidence_multiplicity_bound :=
        mt_input_for_block.fixed_semiprime_incidence_multiplicity_bound
      fixed_semiprime_incidence_multiplicity_bound_proof :=
        mt_input_for_block.fixed_semiprime_incidence_multiplicity_bound_proof
      distinct_semiprime_lower_bound_after_deduplication :=
        mt_input_for_block.distinct_semiprime_lower_bound_after_deduplication
      one_semiprime_per_private_label_in_long_block :=
        mt_input_for_block.one_semiprime_per_private_label_in_long_block
      one_semiprime_per_private_label_in_long_block_proof :=
        mt_input_for_block.one_semiprime_per_private_label_in_long_block_proof
      log_y_to_log_b_small_factor_window_transfer :=
        mt_input_for_block.log_y_to_log_b_small_factor_window_transfer
      incidence_count_lower_bound_prop :=
        mt_input_for_block.incidence_count_lower_bound_prop
      incidence_count_lower_bound_proof :=
        mt_input_for_block.incidence_count_lower_bound_proof
      candidate_count_lower_bound_prop :=
        mt_input_for_block.candidate_count_lower_bound_prop
      candidate_count_lower_bound_proof :=
        mt_input_for_block.candidate_count_lower_bound_proof
      privateLabel_count_lower_bound_prop :=
        mt_input_for_block.privateLabel_count_lower_bound_prop
      privateLabel_count_lower_bound_proof :=
        mt_input_for_block.privateLabel_count_lower_bound_proof
      finite_supply_bundle := mt_input_for_block.finite_supply_bundle
      nonempty_candidates := mt_input_for_block.nonempty_candidates }

/--
Checked constructor for the shell-level MT E2 interface from separated shell
facts and the concrete nonbad-block D04/source-local input family.  It does not
assume `ConcreteMTE2TheoremForShell` directly.
-/
def instantiate_ConcreteMTE2TheoremForShell_from_source_local_inputs
    {shell : ConcreteDyadicShell}
    (shell_facts : ConcreteMTE2ShellFacts shell)
    (source_inputs : D04NonbadFullBlockSourceLocalInputFamily shell) :
    ConcreteMTE2TheoremForShell shell := by
  exact
    { mt_constants_c0_delta_positive :=
        shell_facts.mt_constants_c0_delta_positive
      mt_exceptional_starts_sparse_in_shell :=
        shell_facts.mt_exceptional_starts_sparse_in_shell
      bad_block_definition_fewer_than_half_good :=
        shell_facts.bad_block_definition_fewer_than_half_good
      nonbad_blocks_have_enough_mt_good_starts :=
        shell_facts.nonbad_blocks_have_enough_mt_good_starts
      mt_intervals_remain_inside_full_blocks :=
        shell_facts.mt_intervals_remain_inside_full_blocks
      good_starts_give_start_semiprime_incidences :=
        shell_facts.good_starts_give_start_semiprime_incidences
      fixed_semiprime_counted_by_few_starts :=
        shell_facts.fixed_semiprime_counted_by_few_starts
      distinct_semiprime_lower_bound_after_deduplication :=
        shell_facts.distinct_semiprime_lower_bound_after_deduplication
      fixed_label_one_semiprime_per_long_block :=
        shell_facts.fixed_label_one_semiprime_per_long_block
      mt_window_transfers_to_candidate_small_factor_window :=
        shell_facts.mt_window_transfers_to_candidate_small_factor_window
      block_output_for_nonbad_full_block :=
        fun block h_shell h_large h_full h_nonbad =>
          construct_ConcreteMTE2BlockOutput_from_SourceLocalMTIncidenceInput
            (source_inputs.source_local_input_for_nonbad_full_block
              block h_shell h_large h_full h_nonbad) }

/--
Concrete source theorem input for the D04/MT incidence step.

This is the external MT-side payload for one nonbad full block.  It is not a
`SourceLocalMTIncidenceInput` assumption: it keeps the finite lists and each
analytic ingredient as separate fields so that the source-local interface can be
assembled by checked Lean bookkeeping.
-/
structure ConcreteMTTheoremInput (block : ConcreteFullBlock) where
  admissibleStarts : List (ConcreteAdmissibleStart block)
  mtGoodStarts : List (ConcreteAdmissibleStart block)
  startSemiprimeIncidences : List (ConcreteCandidateSemiprime block)
  candidateSemiprimes : List (ConcreteCandidateSemiprime block)
  candidatePrivateLabels : List Nat
  admissible_start_list_complete : Prop
  mt_good_start_predicate_exact : Prop
  nonbad_gives_enough_mt_good_starts : Prop
  mtGoodStarts_sublist_admissible : Prop
  incidences_from_mt_good_starts : Prop
  candidates_from_incidences : Prop
  candidates_deduplicated_by_barrier : Prop
  privateLabels_are_candidate_labels :
    ∀ label : Nat,
      label ∈ candidatePrivateLabels ↔
        ∃ c : ConcreteCandidateSemiprime block,
          c ∈ candidateSemiprimes ∧ c.privateLabel = label
  candidate_barriers_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.barrier ≠ d.barrier)
  candidate_privateLabels_pairwise_distinct :
    candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel)
  privateLabel_list_pairwise_distinct :
    candidatePrivateLabels.Pairwise (fun p q => p ≠ q)
  smallFactor_log_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_lower
  smallFactor_log_upper_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.smallFactor_upper
  privateLabel_large_lower_bound :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.privateLabel_lower
  mt_candidate_provenance :
    ∀ c : ConcreteCandidateSemiprime block,
      c ∈ candidateSemiprimes -> c.mt_provenance
  mt_start_semiprime_incidence_lower_bound : Prop
  mt_start_semiprime_incidence_lower_bound_proof :
    mt_start_semiprime_incidence_lower_bound
  fixed_semiprime_incidence_multiplicity_bound : Prop
  fixed_semiprime_incidence_multiplicity_bound_proof :
    fixed_semiprime_incidence_multiplicity_bound
  distinct_semiprime_lower_bound_after_deduplication : Prop
  one_semiprime_per_private_label_in_long_block : Prop
  one_semiprime_per_private_label_in_long_block_proof :
    one_semiprime_per_private_label_in_long_block
  log_y_to_log_b_small_factor_window_transfer : Prop
  incidence_count_lower_bound_prop : Prop
  incidence_count_lower_bound_proof : incidence_count_lower_bound_prop
  candidate_count_lower_bound_prop : Prop
  candidate_count_lower_bound_proof : candidate_count_lower_bound_prop
  privateLabel_count_lower_bound_prop : Prop
  privateLabel_count_lower_bound_proof : privateLabel_count_lower_bound_prop
  finite_supply_bundle :
    SourceLocalMTFiniteSupplyBundle
      startSemiprimeIncidences candidateSemiprimes candidatePrivateLabels
  nonempty_candidates : 0 < candidateSemiprimes.length

/--
Checked constructor from the shell-level MT E2 interface and D04/nonbad
full-block evidence to the concrete theorem input consumed by the source-local
incidence constructor.  This is only Lean bookkeeping: all analytic content is
kept in `ConcreteMTE2TheoremForShell` and remains shell-local.
-/
theorem construct_ConcreteMTTheoremInput_from_MT_nonbad
    {block : ConcreteFullBlock}
    (h_large : block.shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block)
    (mt_external_for_shell : ConcreteMTE2TheoremForShell block.shell) :
    ∃ _mt_theorem_for_block : ConcreteMTTheoremInput block, True := by
  let mt_block_output :=
    mt_external_for_shell.block_output_for_nonbad_full_block
      block rfl h_large h_full h_nonbad
  refine ⟨?_, trivial⟩
  exact
    { admissibleStarts := mt_block_output.admissibleStarts
      mtGoodStarts := mt_block_output.mtGoodStarts
      startSemiprimeIncidences :=
        mt_block_output.startSemiprimeIncidences
      candidateSemiprimes := mt_block_output.candidateSemiprimes
      candidatePrivateLabels := mt_block_output.candidatePrivateLabels
      admissible_start_list_complete :=
        mt_block_output.admissible_start_list_complete
      mt_good_start_predicate_exact :=
        mt_block_output.mt_good_start_predicate_exact
      nonbad_gives_enough_mt_good_starts :=
        mt_block_output.nonbad_gives_enough_mt_good_starts
      mtGoodStarts_sublist_admissible :=
        mt_block_output.mtGoodStarts_sublist_admissible
      incidences_from_mt_good_starts :=
        mt_block_output.incidences_from_mt_good_starts
      candidates_from_incidences :=
        mt_block_output.candidates_from_incidences
      candidates_deduplicated_by_barrier :=
        mt_block_output.candidates_deduplicated_by_barrier
      privateLabels_are_candidate_labels :=
        mt_block_output.privateLabels_are_candidate_labels
      candidate_barriers_pairwise_distinct :=
        mt_block_output.candidate_barriers_pairwise_distinct
      candidate_privateLabels_pairwise_distinct :=
        mt_block_output.candidate_privateLabels_pairwise_distinct
      privateLabel_list_pairwise_distinct :=
        mt_block_output.privateLabel_list_pairwise_distinct
      smallFactor_log_lower_bound :=
        mt_block_output.smallFactor_log_lower_bound
      smallFactor_log_upper_bound :=
        mt_block_output.smallFactor_log_upper_bound
      privateLabel_large_lower_bound :=
        mt_block_output.privateLabel_large_lower_bound
      mt_candidate_provenance := mt_block_output.mt_candidate_provenance
      mt_start_semiprime_incidence_lower_bound :=
        mt_block_output.mt_start_semiprime_incidence_lower_bound
      mt_start_semiprime_incidence_lower_bound_proof :=
        mt_block_output.mt_start_semiprime_incidence_lower_bound_proof
      fixed_semiprime_incidence_multiplicity_bound :=
        mt_block_output.fixed_semiprime_incidence_multiplicity_bound
      fixed_semiprime_incidence_multiplicity_bound_proof :=
        mt_block_output.fixed_semiprime_incidence_multiplicity_bound_proof
      distinct_semiprime_lower_bound_after_deduplication :=
        mt_block_output.distinct_semiprime_lower_bound_after_deduplication
      one_semiprime_per_private_label_in_long_block :=
        mt_block_output.one_semiprime_per_private_label_in_long_block
      one_semiprime_per_private_label_in_long_block_proof :=
        mt_block_output.one_semiprime_per_private_label_in_long_block_proof
      log_y_to_log_b_small_factor_window_transfer :=
        mt_block_output.log_y_to_log_b_small_factor_window_transfer
      incidence_count_lower_bound_prop :=
        mt_block_output.incidence_count_lower_bound_prop
      incidence_count_lower_bound_proof :=
        mt_block_output.incidence_count_lower_bound_proof
      candidate_count_lower_bound_prop :=
        mt_block_output.candidate_count_lower_bound_prop
      candidate_count_lower_bound_proof :=
        mt_block_output.candidate_count_lower_bound_proof
      privateLabel_count_lower_bound_prop :=
        mt_block_output.privateLabel_count_lower_bound_prop
      privateLabel_count_lower_bound_proof :=
        mt_block_output.privateLabel_count_lower_bound_proof
      finite_supply_bundle := mt_block_output.finite_supply_bundle
      nonempty_candidates := mt_block_output.nonempty_candidates }

/--
Checked constructor from the concrete MT theorem payload to the source-local
D04/MT incidence input.  This theorem is intentionally before all private
barrier deletion, density, localization, and final-target layers.
-/
theorem construct_SourceLocalMTIncidenceInput_from_MT_nonbad
    {block : ConcreteFullBlock}
    (_h_large : block.shell.largeEnough)
    (_h_full : block.fullBlock)
    (_h_nonbad : D04MTNonbadFullBlock block)
    (mt_theorem_for_block : ConcreteMTTheoremInput block) :
    ∃ _input : SourceLocalMTIncidenceInput block, True := by
  refine ⟨?_, trivial⟩
  exact
    { admissibleStarts := mt_theorem_for_block.admissibleStarts
      mtGoodStarts := mt_theorem_for_block.mtGoodStarts
      startSemiprimeIncidences :=
        mt_theorem_for_block.startSemiprimeIncidences
      candidateSemiprimes := mt_theorem_for_block.candidateSemiprimes
      candidatePrivateLabels := mt_theorem_for_block.candidatePrivateLabels
      admissible_start_list_complete :=
        mt_theorem_for_block.admissible_start_list_complete
      mt_good_start_predicate_exact :=
        mt_theorem_for_block.mt_good_start_predicate_exact
      nonbad_gives_enough_mt_good_starts :=
        mt_theorem_for_block.nonbad_gives_enough_mt_good_starts
      mtGoodStarts_sublist_admissible :=
        mt_theorem_for_block.mtGoodStarts_sublist_admissible
      incidences_from_mt_good_starts :=
        mt_theorem_for_block.incidences_from_mt_good_starts
      candidates_from_incidences :=
        mt_theorem_for_block.candidates_from_incidences
      candidates_deduplicated_by_barrier :=
        mt_theorem_for_block.candidates_deduplicated_by_barrier
      privateLabels_are_candidate_labels :=
        mt_theorem_for_block.privateLabels_are_candidate_labels
      candidate_barriers_pairwise_distinct :=
        mt_theorem_for_block.candidate_barriers_pairwise_distinct
      candidate_privateLabels_pairwise_distinct :=
        mt_theorem_for_block.candidate_privateLabels_pairwise_distinct
      privateLabel_list_pairwise_distinct :=
        mt_theorem_for_block.privateLabel_list_pairwise_distinct
      smallFactor_log_lower_bound :=
        mt_theorem_for_block.smallFactor_log_lower_bound
      smallFactor_log_upper_bound :=
        mt_theorem_for_block.smallFactor_log_upper_bound
      privateLabel_large_lower_bound :=
        mt_theorem_for_block.privateLabel_large_lower_bound
      mt_candidate_provenance := mt_theorem_for_block.mt_candidate_provenance
      mt_start_semiprime_incidence_lower_bound :=
        mt_theorem_for_block.mt_start_semiprime_incidence_lower_bound
      mt_start_semiprime_incidence_lower_bound_proof :=
        mt_theorem_for_block.mt_start_semiprime_incidence_lower_bound_proof
      fixed_semiprime_incidence_multiplicity_bound :=
        mt_theorem_for_block.fixed_semiprime_incidence_multiplicity_bound
      fixed_semiprime_incidence_multiplicity_bound_proof :=
        mt_theorem_for_block.fixed_semiprime_incidence_multiplicity_bound_proof
      distinct_semiprime_lower_bound_after_deduplication :=
        mt_theorem_for_block.distinct_semiprime_lower_bound_after_deduplication
      one_semiprime_per_private_label_in_long_block :=
        mt_theorem_for_block.one_semiprime_per_private_label_in_long_block
      one_semiprime_per_private_label_in_long_block_proof :=
        mt_theorem_for_block.one_semiprime_per_private_label_in_long_block_proof
      log_y_to_log_b_small_factor_window_transfer :=
        mt_theorem_for_block.log_y_to_log_b_small_factor_window_transfer
      incidence_count_lower_bound_prop :=
        mt_theorem_for_block.incidence_count_lower_bound_prop
      incidence_count_lower_bound_proof :=
        mt_theorem_for_block.incidence_count_lower_bound_proof
      candidate_count_lower_bound_prop :=
        mt_theorem_for_block.candidate_count_lower_bound_prop
      candidate_count_lower_bound_proof :=
        mt_theorem_for_block.candidate_count_lower_bound_proof
      privateLabel_count_lower_bound_prop :=
        mt_theorem_for_block.privateLabel_count_lower_bound_prop
      privateLabel_count_lower_bound_proof :=
        mt_theorem_for_block.privateLabel_count_lower_bound_proof
      finite_supply_bundle := mt_theorem_for_block.finite_supply_bundle
      nonempty_candidates := mt_theorem_for_block.nonempty_candidates }

/--
Checked source-local production boundary for the D04/MT full-block incidence
data.  All analytic work is isolated in `SourceLocalMTIncidenceInput`; this
theorem only assembles that source-local evidence into the explicit
`D04MTFullBlockIncidenceData` record.
-/
theorem produce_D04MTFullBlockIncidenceData_from_MT_nonbad
    {block : ConcreteFullBlock}
    (_h_large : block.shell.largeEnough)
    (_h_full : block.fullBlock)
    (_h_nonbad : D04MTNonbadFullBlock block)
    (mt_input_for_block : SourceLocalMTIncidenceInput block) :
    ∃ data : D04MTFullBlockIncidenceData block, True := by
  let data : D04MTFullBlockIncidenceData block :=
    { admissibleStarts := mt_input_for_block.admissibleStarts
      mtGoodStarts := mt_input_for_block.mtGoodStarts
      startSemiprimeIncidences :=
        mt_input_for_block.startSemiprimeIncidences
      candidateSemiprimes := mt_input_for_block.candidateSemiprimes
      candidatePrivateLabels := mt_input_for_block.candidatePrivateLabels
      mtGoodStarts_sublist_admissible :=
        mt_input_for_block.mtGoodStarts_sublist_admissible
      incidences_from_mt_good_starts :=
        mt_input_for_block.incidences_from_mt_good_starts
      candidates_from_incidences :=
        mt_input_for_block.candidates_from_incidences
      candidates_deduplicated_by_barrier :=
        mt_input_for_block.candidates_deduplicated_by_barrier
      privateLabels_are_candidate_labels :=
        mt_input_for_block.privateLabels_are_candidate_labels
      candidate_barriers_pairwise_distinct :=
        mt_input_for_block.candidate_barriers_pairwise_distinct
      candidate_privateLabels_pairwise_distinct :=
        mt_input_for_block.candidate_privateLabels_pairwise_distinct
      privateLabel_list_pairwise_distinct :=
        mt_input_for_block.privateLabel_list_pairwise_distinct
      smallFactor_log_lower_bound :=
        mt_input_for_block.smallFactor_log_lower_bound
      smallFactor_log_upper_bound :=
        mt_input_for_block.smallFactor_log_upper_bound
      privateLabel_large_lower_bound :=
        mt_input_for_block.privateLabel_large_lower_bound
      mt_candidate_provenance := mt_input_for_block.mt_candidate_provenance
      mt_incidence_count_lower_bound :=
        mt_input_for_block.mt_start_semiprime_incidence_lower_bound
      fixed_semiprime_incidence_multiplicity_bound :=
        mt_input_for_block.fixed_semiprime_incidence_multiplicity_bound
      fixed_semiprime_incidence_multiplicity_bound_proof :=
        mt_input_for_block.fixed_semiprime_incidence_multiplicity_bound_proof
      fixed_block_distinct_semiprime_lower_bound :=
        mt_input_for_block.distinct_semiprime_lower_bound_after_deduplication
      fixed_label_one_semiprime_per_long_block :=
        mt_input_for_block.one_semiprime_per_private_label_in_long_block
      fixed_label_one_semiprime_per_long_block_proof :=
        mt_input_for_block.one_semiprime_per_private_label_in_long_block_proof
      mt_window_to_candidate_small_factor_window :=
        mt_input_for_block.log_y_to_log_b_small_factor_window_transfer
      incidence_count_lower_bound_prop :=
        mt_input_for_block.incidence_count_lower_bound_prop
      incidence_count_lower_bound_proof :=
        mt_input_for_block.incidence_count_lower_bound_proof
      candidate_count_lower_bound_prop :=
        mt_input_for_block.candidate_count_lower_bound_prop
      candidate_count_lower_bound_proof :=
        mt_input_for_block.candidate_count_lower_bound_proof
      privateLabel_count_lower_bound_prop :=
        mt_input_for_block.privateLabel_count_lower_bound_prop
      privateLabel_count_lower_bound_proof :=
        mt_input_for_block.privateLabel_count_lower_bound_proof
      nonempty_candidates := mt_input_for_block.nonempty_candidates }
  exact ⟨data, trivial⟩

/--
Finite-list realization of the D04/MT incidence layer.  This is the checked
bookkeeping theorem for `main.tex:454-484` and `solution.wit:1467-1511`: once
the source-local MT incidence lists, deduplication, private-label uniqueness,
window translation, and lower-bound premises have been supplied, they assemble
into `MTGoodFullBlockIncidenceSupply`.
-/
theorem construct_MTGoodFullBlockIncidenceSupply_from_D04_MT
    {block : ConcreteFullBlock}
    (_h_large : block.shell.largeEnough)
    (_h_full : block.fullBlock)
    (_h_nonbad : D04MTNonbadFullBlock block)
    (data : D04MTFullBlockIncidenceData block) :
    ∃ supply : MTGoodFullBlockIncidenceSupply block,
      supply.admissibleStarts = data.admissibleStarts ∧
        supply.mtGoodStarts = data.mtGoodStarts ∧
        supply.startSemiprimeIncidences = data.startSemiprimeIncidences ∧
        supply.candidateSemiprimes = data.candidateSemiprimes ∧
        supply.candidatePrivateLabels = data.candidatePrivateLabels ∧
        supply.incidence_count_lower_bound ∧
        supply.candidate_count_lower_bound ∧
        supply.privateLabel_count_lower_bound ∧
        0 < supply.candidateSemiprimes.length := by
  let supply : MTGoodFullBlockIncidenceSupply block :=
    { admissibleStarts := data.admissibleStarts
      mtGoodStarts := data.mtGoodStarts
      startSemiprimeIncidences := data.startSemiprimeIncidences
      candidateSemiprimes := data.candidateSemiprimes
      candidatePrivateLabels := data.candidatePrivateLabels
      mtGoodStarts_sublist_admissible := data.mtGoodStarts_sublist_admissible
      incidences_from_mt_good_starts := data.incidences_from_mt_good_starts
      candidates_from_incidences := data.candidates_from_incidences
      candidates_deduplicated_by_barrier := data.candidates_deduplicated_by_barrier
      privateLabels_are_candidate_labels := data.privateLabels_are_candidate_labels
      candidate_barriers_pairwise_distinct := data.candidate_barriers_pairwise_distinct
      candidate_privateLabels_pairwise_distinct :=
        data.candidate_privateLabels_pairwise_distinct
      privateLabel_list_pairwise_distinct := data.privateLabel_list_pairwise_distinct
      smallFactor_log_lower_bound := data.smallFactor_log_lower_bound
      smallFactor_log_upper_bound := data.smallFactor_log_upper_bound
      privateLabel_large_lower_bound := data.privateLabel_large_lower_bound
      mt_candidate_provenance := data.mt_candidate_provenance
      incidence_count_lower_bound := data.incidence_count_lower_bound_prop
      candidate_count_lower_bound := data.candidate_count_lower_bound_prop
      privateLabel_count_lower_bound := data.privateLabel_count_lower_bound_prop
      nonempty_candidates := data.nonempty_candidates }
  exact
    ⟨supply, rfl, rfl, rfl, rfl, rfl,
      data.incidence_count_lower_bound_proof,
      data.candidate_count_lower_bound_proof,
      data.privateLabel_count_lower_bound_proof,
      supply.nonempty_candidates⟩

/--
Projection from explicit MT-good full-block incidence data to the existing
concrete D04 candidate-supply record.  It is only an interface adapter: the
analytic construction of `MTGoodFullBlockIncidenceSupply` is a separate D04
obligation.
-/
def MTGoodFullBlockIncidenceSupply.toConcreteGoodFullBlockCandidateSupply
    {block : ConcreteFullBlock}
    (supply : MTGoodFullBlockIncidenceSupply block) :
    ConcreteGoodFullBlockCandidateSupply block where
  admissibleStarts := supply.admissibleStarts
  mtGoodStarts := supply.mtGoodStarts
  startSemiprimeIncidences := supply.startSemiprimeIncidences
  candidateSemiprimes := supply.candidateSemiprimes
  candidatePrivateLabels := supply.candidatePrivateLabels
  mtGoodStarts_sublist_admissible := supply.mtGoodStarts_sublist_admissible
  incidences_from_mt_good_starts := supply.incidences_from_mt_good_starts
  candidates_from_incidences := supply.candidates_from_incidences
  candidates_deduplicated_by_barrier := supply.candidates_deduplicated_by_barrier
  privateLabels_are_candidate_labels := supply.privateLabels_are_candidate_labels
  candidate_barriers_pairwise_distinct := supply.candidate_barriers_pairwise_distinct
  candidate_privateLabels_pairwise_distinct :=
    supply.candidate_privateLabels_pairwise_distinct
  privateLabel_list_pairwise_distinct := supply.privateLabel_list_pairwise_distinct
  smallFactor_log_lower_bound := supply.smallFactor_log_lower_bound
  smallFactor_log_upper_bound := supply.smallFactor_log_upper_bound
  privateLabel_large_lower_bound := supply.privateLabel_large_lower_bound
  mt_candidate_provenance := supply.mt_candidate_provenance
  incidence_count_lower_bound := supply.incidence_count_lower_bound
  candidate_count_lower_bound := supply.candidate_count_lower_bound
  privateLabel_count_lower_bound := supply.privateLabel_count_lower_bound
  nonempty_candidates := supply.nonempty_candidates

theorem MTGoodFullBlockIncidenceSupply_to_ConcreteGoodFullBlockCandidateSupply
    {block : ConcreteFullBlock}
    (supply : MTGoodFullBlockIncidenceSupply block) :
    ∃ concrete : ConcreteGoodFullBlockCandidateSupply block,
      concrete.candidateSemiprimes = supply.candidateSemiprimes ∧
        concrete.candidatePrivateLabels = supply.candidatePrivateLabels :=
  ⟨supply.toConcreteGoodFullBlockCandidateSupply, rfl, rfl⟩

theorem ConcreteGoodFullBlockCandidateSupply.candidate_privateLabels_distinct
    {block : ConcreteFullBlock}
    (supply : ConcreteGoodFullBlockCandidateSupply block) :
    supply.candidateSemiprimes.Pairwise
      (fun c d => c.privateLabel ≠ d.privateLabel) :=
  supply.candidate_privateLabels_pairwise_distinct

theorem ConcreteGoodFullBlockCandidateSupply.privateLabel_list_distinct
    {block : ConcreteFullBlock}
    (supply : ConcreteGoodFullBlockCandidateSupply block) :
    supply.candidatePrivateLabels.Pairwise (fun p q => p ≠ q) :=
  supply.privateLabel_list_pairwise_distinct

theorem ConcreteGoodFullBlockCandidateSupply.candidates_nonempty
    {block : ConcreteFullBlock}
    (supply : ConcreteGoodFullBlockCandidateSupply block) :
    0 < supply.candidateSemiprimes.length :=
  supply.nonempty_candidates

/-- Private-label carrier used by the deterministic first-available scan. -/
abbrev CandidateLabel := Nat

/--
Source-local first-available label primitive for the greedy D04 matching in
`main.tex:487-492`.  The concrete construction still has to supply the
candidate lists and the shell/global used-label list; this definition only
freezes the deterministic `find?` step.
-/
def firstAvailableD04Label (usedLabels candidateLabels : List Nat) : Option Nat :=
  candidateLabels.find? (fun label => decide (label ∉ usedLabels))

theorem firstAvailableD04Label_none_all_candidates_used
    (usedLabels candidateLabels : List Nat)
    (hfind : firstAvailableD04Label usedLabels candidateLabels = none) :
    ∀ label : Nat, label ∈ candidateLabels -> label ∈ usedLabels := by
  intro label hmem
  have hall := (List.find?_eq_none.mp hfind) label hmem
  by_cases hused : label ∈ usedLabels
  · exact hused
  · exfalso
    exact hall (by simp [hused])

theorem firstAvailableD04Label_some_not_used
    (usedLabels candidateLabels : List Nat) (label : Nat)
    (hfind : firstAvailableD04Label usedLabels candidateLabels = some label) :
    label ∉ usedLabels := by
  have hpred := List.find?_some hfind
  simpa [firstAvailableD04Label] using hpred

theorem firstAvailableD04Label_some_preserves_used_nodup
    (usedLabels candidateLabels : List Nat) (label : Nat)
    (hfind : firstAvailableD04Label usedLabels candidateLabels = some label)
    (hused : usedLabels.Nodup) :
    (label :: usedLabels).Nodup := by
  have hnot_used :=
    firstAvailableD04Label_some_not_used usedLabels candidateLabels label hfind
  simpa using List.nodup_cons.mpr ⟨hnot_used, hused⟩

/--
Finite good block payload for the first-available matching engine.

The concrete `ConcreteFullBlock`/candidate-semiprime layer feeds this by
projecting each block's candidate private labels.  Keeping this as a small
finite object makes the scan proofs independent of the analytic MT input.
-/
structure GoodBlock where
  blockId : Nat
  candidateLabels : List CandidateLabel

/--
Concrete ordering used by the D04 first-available scan: good blocks in one
finite shell-local list are scanned in strictly increasing left endpoint.
-/
def ConcreteOrderedByBlockId (blocks : List GoodBlock) : Prop :=
  blocks.Pairwise (fun left right => left.blockId < right.blockId)

/--
Shell-local ordered enumeration of exactly the nonbad full blocks.

This is the Lean-facing form of the Section 4 instruction to partition one
dyadic shell into full blocks, discard the bad blocks, order the remaining
blocks by left endpoint, and scan that finite ordered list.  The completeness
field is intentionally shell-indexed; it does not assert a global finite list of
all nonbad blocks across all shells.
-/
structure D04OrderedNonbadFullBlocksForShell
    (shell : ConcreteDyadicShell)
    (sourceInput : D04NonbadFullBlockSourceLocalInputFamily shell) where
  nonbadFullBlocksOrdered : List GoodBlock
  ordered_by_left_endpoint :
    ConcreteOrderedByBlockId nonbadFullBlocksOrdered
  goodBlock_source_local :
    ∀ goodBlock : GoodBlock,
      goodBlock ∈ nonbadFullBlocksOrdered ->
        ∃ block : ConcreteFullBlock,
          ∃ h_shell : block.shell = shell,
            ∃ h_large : shell.largeEnough,
              ∃ h_full : block.fullBlock,
                ∃ h_nonbad : D04MTNonbadFullBlock block,
                  goodBlock.blockId = block.blockLeft ∧
                    goodBlock.candidateLabels =
                      (sourceInput.source_local_input_for_nonbad_full_block
                        block h_shell h_large h_full h_nonbad).candidatePrivateLabels
  nonbadFullBlock_complete :
    ∀ block : ConcreteFullBlock,
      ∀ h_shell : block.shell = shell,
        ∀ h_large : shell.largeEnough,
          ∀ h_full : block.fullBlock,
            ∀ h_nonbad : D04MTNonbadFullBlock block,
              ∃ goodBlock : GoodBlock,
                goodBlock ∈ nonbadFullBlocksOrdered ∧
                  goodBlock.blockId = block.blockLeft ∧
                    goodBlock.candidateLabels =
                      (sourceInput.source_local_input_for_nonbad_full_block
                        block h_shell h_large h_full h_nonbad).candidatePrivateLabels

/-- The first currently available candidate label in one good block. -/
def firstAvailable (unavailable : List CandidateLabel) (block : GoodBlock) :
    Option CandidateLabel :=
  block.candidateLabels.find? (fun label => !(label ∈ unavailable))

theorem firstAvailable_some_mem
    {unavailable : List CandidateLabel} {block : GoodBlock}
    {label : CandidateLabel}
    (h : firstAvailable unavailable block = some label) :
    label ∈ block.candidateLabels ∧ label ∉ unavailable := by
  constructor
  · exact List.mem_of_find?_eq_some h
  · have hbool := List.find?_some h
    simpa [firstAvailable] using hbool

theorem firstAvailable_none_all_used
    {unavailable : List CandidateLabel} {block : GoodBlock}
    (h : firstAvailable unavailable block = none) :
    ∀ label : CandidateLabel,
      label ∈ block.candidateLabels -> label ∈ unavailable := by
  intro label hmem
  have hnone := (List.find?_eq_none).1 h label hmem
  by_cases hin : label ∈ unavailable
  · exact hin
  · exact False.elim (hnone (by simp [firstAvailable, hin]))

/-- A selected label, with the exact `find?` evidence from the scan step. -/
structure SelectedScanRecord where
  block : GoodBlock
  label : CandidateLabel
  priorCurrentLabels : List CandidateLabel
  first_available :
    firstAvailable priorCurrentLabels block = some label

/-- An unmatched good block, with the exact exhausted-`find?` evidence. -/
structure UnmatchedScanRecord where
  block : GoodBlock
  priorCurrentLabels : List CandidateLabel
  no_available :
    firstAvailable priorCurrentLabels block = none

def SelectedScanRecord.isCandidate (r : SelectedScanRecord) :
    r.label ∈ r.block.candidateLabels :=
  (firstAvailable_some_mem r.first_available).1

def SelectedScanRecord.notEarlier (earlierLabels : List CandidateLabel)
    (r : SelectedScanRecord)
    (hprior : r.priorCurrentLabels = earlierLabels ++
      (r.priorCurrentLabels.drop earlierLabels.length)) :
    r.label ∉ earlierLabels := by
  intro hmem
  have hnot := (firstAvailable_some_mem r.first_available).2
  exact hnot (by rw [hprior]; exact List.mem_append_left _ hmem)

/-- State carried by the fold-left first-available scan. -/
structure MatchScanState where
  currentLabels : List CandidateLabel
  selected : List SelectedScanRecord
  unmatched : List UnmatchedScanRecord

def initialMatchScanState : MatchScanState :=
  { currentLabels := []
    selected := []
    unmatched := [] }

def matchScanStep (state : MatchScanState) (block : GoodBlock) :
    MatchScanState :=
  match h : firstAvailable state.currentLabels block with
  | none =>
      { state with
        unmatched :=
          { block := block
            priorCurrentLabels := state.currentLabels
            no_available := h } :: state.unmatched }
  | some label =>
      { currentLabels := label :: state.currentLabels
        selected :=
          { block := block
            label := label
            priorCurrentLabels := state.currentLabels
            first_available := h } :: state.selected
        unmatched := state.unmatched }

/-- Fold-left deterministic scan over the ordered good blocks. -/
def matchScan (blocks : List GoodBlock) : MatchScanState :=
  blocks.foldl matchScanStep initialMatchScanState

def selectedRecords (blocks : List GoodBlock) : List SelectedScanRecord :=
  (matchScan blocks).selected

def unmatchedBlocks (blocks : List GoodBlock) : List UnmatchedScanRecord :=
  (matchScan blocks).unmatched

def selectedLabels (blocks : List GoodBlock) : List CandidateLabel :=
  (matchScan blocks).currentLabels

theorem matchScanStep_selected_block_mem_or_prior
    (state : MatchScanState) (block : GoodBlock) (r : SelectedScanRecord)
    (hr : r ∈ (matchScanStep state block).selected) :
    r.block = block ∨ r ∈ state.selected := by
  unfold matchScanStep at hr
  split at hr
  · exact Or.inr hr
  · simp at hr
    rcases hr with hr | hr
    · subst hr
      exact Or.inl rfl
    · exact Or.inr hr

theorem matchScan_fold_selected_block_mem_or_prior
    (blocks : List GoodBlock) (state : MatchScanState)
    (r : SelectedScanRecord)
    (hr : r ∈ (blocks.foldl matchScanStep state).selected) :
    r.block ∈ blocks ∨ r ∈ state.selected := by
  induction blocks generalizing state with
  | nil =>
      exact Or.inr hr
  | cons block rest ih =>
      have hrest_or_step :=
        ih (matchScanStep state block) hr
      rcases hrest_or_step with hrest | hstep
      · exact Or.inl (List.mem_cons_of_mem block hrest)
      · have hblock_or_prior :=
          matchScanStep_selected_block_mem_or_prior state block r hstep
        rcases hblock_or_prior with hblock | hprior
        · exact Or.inl (by simp [hblock])
        · exact Or.inr hprior

theorem selectedRecords_block_mem
    (blocks : List GoodBlock) (r : SelectedScanRecord)
    (hr : r ∈ selectedRecords blocks) :
    r.block ∈ blocks := by
  have h :=
    matchScan_fold_selected_block_mem_or_prior blocks initialMatchScanState r
      (by simpa [selectedRecords, matchScan] using hr)
  rcases h with hblocks | hprior
  · exact hblocks
  · simpa [initialMatchScanState] using hprior

def scanInvariant (state : MatchScanState) : Prop :=
  state.currentLabels.Nodup ∧
    (∀ r : SelectedScanRecord,
      r ∈ state.selected -> r.label ∈ state.currentLabels) ∧
    (∀ u : UnmatchedScanRecord,
      u ∈ state.unmatched ->
        ∀ label : CandidateLabel,
          label ∈ u.block.candidateLabels -> label ∈ state.currentLabels)

theorem initialMatchScanState_invariant :
    scanInvariant initialMatchScanState := by
  simp [scanInvariant, initialMatchScanState]

theorem matchScanStep_invariant
    {state : MatchScanState} (block : GoodBlock)
    (hinv : scanInvariant state) :
    scanInvariant (matchScanStep state block) := by
  rcases hinv with ⟨hcurrent_nodup, hselected, hunmatched⟩
  unfold matchScanStep
  split
  · constructor
    · exact hcurrent_nodup
    constructor
    · intro r hr
      exact hselected r hr
    · intro u hu label hlabel
      simp at hu
      rcases hu with hu | hu
      · subst hu
        exact firstAvailable_none_all_used ‹firstAvailable state.currentLabels block = none›
          label hlabel
      · exact hunmatched u hu label hlabel
  · constructor
    · apply List.nodup_cons.mpr
      exact
        ⟨(firstAvailable_some_mem ‹firstAvailable state.currentLabels block = some _›).2,
          hcurrent_nodup⟩
    constructor
    · intro r hr
      simp at hr
      rcases hr with hr | hr
      · subst hr
        simp
      · exact List.mem_cons_of_mem _ (hselected r hr)
    · intro u hu label hlabel
      exact List.mem_cons_of_mem _ (hunmatched u hu label hlabel)

theorem matchScan_invariant_from_state
    (blocks : List GoodBlock) (state : MatchScanState)
    (hinv : scanInvariant state) :
    scanInvariant (blocks.foldl matchScanStep state) := by
  induction blocks generalizing state with
  | nil =>
      simpa using hinv
  | cons block rest ih =>
      exact ih (matchScanStep state block) (matchScanStep_invariant block hinv)

theorem matchScan_invariant (blocks : List GoodBlock) :
    scanInvariant (matchScan blocks) := by
  exact matchScan_invariant_from_state blocks initialMatchScanState
    initialMatchScanState_invariant

theorem selected_labels_nodup (blocks : List GoodBlock) :
    (selectedLabels blocks).Nodup := by
  exact (matchScan_invariant blocks).1

theorem selected_is_candidate
    (blocks : List GoodBlock) (r : SelectedScanRecord)
    (hr : r ∈ selectedRecords blocks) :
    r.label ∈ r.block.candidateLabels :=
  r.isCandidate

theorem selected_not_earlier
    (blocks : List GoodBlock) (r s : SelectedScanRecord)
    (hr : r ∈ selectedRecords blocks)
    (hs : s ∈ selectedRecords blocks)
    (hs_prior : s.label ∈ r.priorCurrentLabels) :
    r.label ≠ s.label := by
  intro heq
  have hnot := (firstAvailable_some_mem r.first_available).2
  exact hnot (by simpa [heq] using hs_prior)

def scanSelectedLabelInjective (state : MatchScanState) : Prop :=
  ∀ r s : SelectedScanRecord,
    r ∈ state.selected -> s ∈ state.selected -> r.label = s.label -> r = s

theorem initialMatchScanState_selected_label_injective :
    scanSelectedLabelInjective initialMatchScanState := by
  intro r s hr
  simp [initialMatchScanState] at hr

theorem matchScanStep_selected_label_injective
    {state : MatchScanState} (block : GoodBlock)
    (hinv : scanInvariant state)
    (hinj : scanSelectedLabelInjective state) :
    scanSelectedLabelInjective (matchScanStep state block) := by
  unfold matchScanStep
  split
  · exact hinj
  · rename_i label hfirst
    intro r s hr hs hlabel
    simp at hr hs
    rcases hr with hr_new | hr_old
    · subst hr_new
      rcases hs with hs_new | hs_old
      · subst hs_new
        rfl
      · have hs_label_current : s.label ∈ state.currentLabels :=
          hinv.2.1 s hs_old
        have hnot := (firstAvailable_some_mem hfirst).2
        exact False.elim (hnot (by simpa [← hlabel] using hs_label_current))
    · rcases hs with hs_new | hs_old
      · subst hs_new
        have hr_label_current : r.label ∈ state.currentLabels :=
          hinv.2.1 r hr_old
        have hnot := (firstAvailable_some_mem hfirst).2
        exact False.elim (hnot (by simpa [hlabel] using hr_label_current))
      · exact hinj r s hr_old hs_old hlabel

theorem matchScan_fold_selected_label_injective
    (blocks : List GoodBlock) (state : MatchScanState)
    (hinv : scanInvariant state)
    (hinj : scanSelectedLabelInjective state) :
    scanSelectedLabelInjective (blocks.foldl matchScanStep state) := by
  induction blocks generalizing state with
  | nil =>
      simpa using hinj
  | cons block rest ih =>
      exact ih (matchScanStep state block)
        (matchScanStep_invariant block hinv)
        (matchScanStep_selected_label_injective block hinv hinj)

theorem selectedRecords_label_injective
    (blocks : List GoodBlock) :
    ∀ r s : SelectedScanRecord,
      r ∈ selectedRecords blocks -> s ∈ selectedRecords blocks ->
        r.label = s.label -> r = s := by
  exact matchScan_fold_selected_label_injective blocks initialMatchScanState
    initialMatchScanState_invariant
    initialMatchScanState_selected_label_injective

theorem unmatched_all_candidates_used
    (blocks : List GoodBlock) (u : UnmatchedScanRecord)
    (hu : u ∈ unmatchedBlocks blocks) :
    ∀ label : CandidateLabel,
      label ∈ u.block.candidateLabels ->
        label ∈ selectedLabels blocks := by
  intro label hlabel
  exact (matchScan_invariant blocks).2.2 u (by simpa [unmatchedBlocks] using hu)
    label hlabel

/--
Finite incidence double count for unmatched blocks.

`hLmin` is the lower bound on incidences from unmatched blocks to candidate
labels; `hAdj` is the upper bound from used-label adjacency; `hUsed` is the
ambient bound on used labels times the adjacency cap.
-/
theorem unmatched_count_bound
    (U Lmin incidences Amax Used Bound : Nat)
    (hLmin : U * Lmin ≤ incidences)
    (hAdj : incidences ≤ Used * Amax)
    (hUsed : Used * Amax ≤ Bound) :
    U * Lmin ≤ Bound :=
  Nat.le_trans (Nat.le_trans hLmin hAdj) hUsed

/--
Finite list-incidence form of the unmatched-block bound.

The lower-bound hypothesis counts at least `Lmin` candidate labels per
unmatched block.  The hypothesis `hCandidateAdj` is the exact remaining
double-counting/injection bridge from block-candidate incidences to the
label-adjacency lists.  Once that bridge and the per-label adjacency cap
`hAdj` are available, the desired `Lmin * U.length` bound follows.
-/
theorem unmatched_count_bound_by_label_incidence
    (U T : List Nat) (Candidates Adj : Nat -> List Nat) (Lmin A : Nat)
    (hLmin : Lmin * U.length ≤ (U.map Candidates).flatten.length)
    (_hUsed :
      ∀ u : Nat, u ∈ U ->
        ∀ label : Nat, label ∈ Candidates u -> label ∈ T)
    (hCandidateAdj :
      (U.map Candidates).flatten.length ≤ (T.map Adj).flatten.length)
    (hAdj : (T.map Adj).flatten.length ≤ T.length * A) :
    Lmin * U.length ≤ T.length * A := by
  exact Nat.le_trans hLmin (Nat.le_trans hCandidateAdj hAdj)

/-- Priority reasons for the finite ordered reason writer. -/
inductive DeletionReason where
  | finiteInitial
  | shellBoundary
  | badBlock
  | unmatchedBlock
  | protectedPrefix
  | horizonMultiple
  deriving DecidableEq

def deletionReasonPriorityList : List DeletionReason :=
  [DeletionReason.finiteInitial,
    DeletionReason.shellBoundary,
    DeletionReason.badBlock,
    DeletionReason.unmatchedBlock,
    DeletionReason.protectedPrefix,
    DeletionReason.horizonMultiple]

def reasonCandidates (applies : DeletionReason -> Bool) :
    List DeletionReason :=
  deletionReasonPriorityList.filter applies

def deletionReason (applies : DeletionReason -> Bool) :
    Option DeletionReason :=
  (reasonCandidates applies).head?

theorem deletionReason_eq_head (applies : DeletionReason -> Bool) :
    deletionReason applies = (reasonCandidates applies).head? := rfl

theorem deletionReasonPriorityList_nodup :
    deletionReasonPriorityList.Nodup := by
  simp [deletionReasonPriorityList]

theorem reasonCandidates_nodup (applies : DeletionReason -> Bool) :
    (reasonCandidates applies).Nodup := by
  exact List.Nodup.sublist List.filter_sublist deletionReasonPriorityList_nodup

/--
Small consumer whose axiom print must include `MT_E2_count`: it instantiates
the finite MT E2 count bridge and composes it with the pure unmatched-block
double count.
-/
theorem first_available_selection_engine_MT_E2_consumer
    (logp : StructuredMTLogPowerProxy)
    (mt : StructuredMTConstantProxy)
    {shell : ConcreteDyadicShell}
    (windowLengthForShell : Nat)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = shell)
    (h_large : shell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block)
    (U Lmin incidences Amax Used Bound : Nat)
    (hLmin : U * Lmin ≤ incidences)
    (hAdj : incidences ≤ Used * Amax)
    (hUsed : Used * Amax ≤ Bound) :
    MTGoodStartsCountLowerBound
      (structuredMTGoodStartsFilter
        logp mt block windowLengthForShell
        (structuredMTGoodStartDecidable logp mt block))
      (((d04ConcreteAdmissibleStartList block windowLengthForShell).length + 1) / 2) ∧
      U * Lmin ≤ Bound := by
  exact
    ⟨MTGoodStartsCountLowerBound_structured_from_MT_E2_count
        logp mt windowLengthForShell block h_shell h_large h_full h_nonbad,
      unmatched_count_bound U Lmin incidences Amax Used Bound
        hLmin hAdj hUsed⟩

/--
Selected record retained by the first-available matching procedure.  The
negative provenance fields are source-local facts used by the ordered reason
writer to keep the selected barrier out of the deletion set.
-/
structure ConcreteSelectedRecord where
  shell : ConcreteDyadicShell
  block : ConcreteFullBlock
  candidate : ConcreteCandidateSemiprime block
  horizon : Nat
  horizon_eq_shell_power : Prop
  barrier_le_horizon : candidate.barrier ≤ horizon
  block_good : Prop
  block_matched : Prop
  selected_by_first_available_matching : Prop
  not_bad_block : Prop
  not_unmatched_block : Prop
  not_in_protected_prefix : Prop

/-- Definitional projection from a concrete selected record to downstream label metadata. -/
def ConcreteSelectedRecord.toPrivateBarrierLabel
    (r : ConcreteSelectedRecord) : PrivateBarrierLabel :=
  { shell := r.shell.left
    block := r.block.blockLeft
    barrier := r.candidate.barrier
    smallFactor := r.candidate.smallFactor
    privateLabel := r.candidate.privateLabel
    horizon := r.horizon }

/--
Concrete selected-record source below the downstream deletion package.

The retained record map is the deterministic deduplication/selection surface.
Its soundness and completeness are source-local obligations; they do not assume
the downstream private-barrier deletion or arithmetic packages.
-/
structure SelectedRecordSource where
  record : ConcreteSelectedRecord -> Prop
  priority : ConcreteSelectedRecord -> Nat
  selectedRecord : Nat -> Option ConcreteSelectedRecord
  selectedRecord_sound :
    ∀ b : Nat, ∀ r : ConcreteSelectedRecord,
      selectedRecord b = some r -> record r ∧ r.candidate.barrier = b
  selectedRecord_complete :
    ∀ r : ConcreteSelectedRecord,
      record r -> selectedRecord r.candidate.barrier = some r
  priority_injective_on_records :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> priority r = priority s -> r = s
  fixed_barrier_unique :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> r.candidate.barrier = s.candidate.barrier -> r = s
  private_label_unique :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s ->
        r.candidate.privateLabel = s.candidate.privateLabel -> r = s
  first_available_matching_sound :
    ∀ r : ConcreteSelectedRecord, record r -> r.selected_by_first_available_matching

/--
Source-local input for the Section 4 retained-record construction.

This is the narrow first-available layer from `main.tex:487-528`: it records
the retained predicate, the barrier-indexed selector, and exactly the
deduplication/soundness laws needed to build a concrete selected-record
relation.  It deliberately does not include ordered deletion reasons,
unmatched-block counting, cofinal rank streams, or downstream density data.
-/
structure FirstAvailableSelectedRecordSourceInput where
  record : ConcreteSelectedRecord -> Prop
  priority : ConcreteSelectedRecord -> Nat
  selectedRecord : Nat -> Option ConcreteSelectedRecord
  exists_record : ∃ r : ConcreteSelectedRecord, record r
  selectedRecord_sound :
    ∀ b : Nat, ∀ r : ConcreteSelectedRecord,
      selectedRecord b = some r -> record r ∧ r.candidate.barrier = b
  selectedRecord_complete :
    ∀ r : ConcreteSelectedRecord,
      record r -> selectedRecord r.candidate.barrier = some r
  priority_injective_on_records :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> priority r = priority s -> r = s
  fixed_barrier_unique :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> r.candidate.barrier = s.candidate.barrier -> r = s
  private_label_unique :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s ->
        r.candidate.privateLabel = s.candidate.privateLabel -> r = s
  first_available_matching_sound :
    ∀ r : ConcreteSelectedRecord, record r -> r.selected_by_first_available_matching

/--
Source-local ordered concrete bridge for the D04 first-available scan.

This is the finite object described in `main.tex:487-528` before the selected
records are consumed by the deletion-reason layer.  It records the ordered
`GoodBlock` list scanned by `matchScan`, ties every finite good-block payload
back to a nonbad concrete full block and its source-local candidate supply,
and projects selected scan records back to concrete selected records.

The fields below are intentionally still source-local: they do not assert
unmatched-block sparsity, ordered deletion reasons, cofinality, density, or the
final theorem.  They are exactly the missing bridge between the checked finite
fold and `D04FirstAvailableSelectedRecordSourceScanCertificate`.
-/
structure D04OrderedConcreteNonbadBlockScanBridge
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell) where
  scanShell : ConcreteDyadicShell
  shell_nonbad_blocks :
    D04OrderedNonbadFullBlocksForShell scanShell (sourceInputs scanShell)
  blocks : List GoodBlock
  blocks_eq_shell_nonbad_blocks :
    blocks = shell_nonbad_blocks.nonbadFullBlocksOrdered
  ordered_by_left_endpoint : ConcreteOrderedByBlockId blocks
  goodBlock_source_local :
    ∀ goodBlock : GoodBlock,
      goodBlock ∈ blocks ->
        ∃ block : ConcreteFullBlock,
          ∃ h_shell : block.shell = scanShell,
            ∃ h_large : scanShell.largeEnough,
              ∃ h_full : block.fullBlock,
                ∃ h_nonbad : D04MTNonbadFullBlock block,
                  goodBlock.blockId = block.blockLeft ∧
                    goodBlock.candidateLabels =
                      ((sourceInputs scanShell).source_local_input_for_nonbad_full_block
                        block h_shell h_large h_full h_nonbad).candidatePrivateLabels
  concreteOfSelected : SelectedScanRecord -> ConcreteSelectedRecord
  record : ConcreteSelectedRecord -> Prop
  record_iff_selected_scan :
    ∀ r : ConcreteSelectedRecord,
      record r ↔
        ∃ scanRecord : SelectedScanRecord,
          scanRecord ∈ selectedRecords blocks ∧
            concreteOfSelected scanRecord = r
  selected_count_positive : 0 < (selectedRecords blocks).length
  concreteOfSelected_source_local :
    ∀ scanRecord : SelectedScanRecord,
      scanRecord ∈ selectedRecords blocks ->
        ∃ h_shell : (concreteOfSelected scanRecord).block.shell =
            (concreteOfSelected scanRecord).shell,
          ∃ h_large : (concreteOfSelected scanRecord).shell.largeEnough,
            ∃ h_full : (concreteOfSelected scanRecord).block.fullBlock,
              ∃ h_nonbad : D04MTNonbadFullBlock
                  (concreteOfSelected scanRecord).block,
                (concreteOfSelected scanRecord).candidate ∈
                  (D04NonbadFullBlockSourceLocalInputFamily.source_local_input_for_nonbad_full_block
                      (sourceInputs ((concreteOfSelected scanRecord).shell))
                      (concreteOfSelected scanRecord).block
                      h_shell h_large h_full h_nonbad).candidateSemiprimes
  concreteOfSelected_label :
    ∀ scanRecord : SelectedScanRecord,
      scanRecord ∈ selectedRecords blocks ->
        (concreteOfSelected scanRecord).candidate.privateLabel =
          scanRecord.label
  concreteOfSelected_first_available :
    ∀ scanRecord : SelectedScanRecord,
      scanRecord ∈ selectedRecords blocks ->
        (concreteOfSelected scanRecord).selected_by_first_available_matching
  priority : ConcreteSelectedRecord -> Nat
  priority_injective_on_records :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> priority r = priority s -> r = s

theorem D04OrderedConcreteNonbadBlockScanBridge.nonbadFullBlock_complete
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs)
    (block : ConcreteFullBlock)
    (h_shell : block.shell = bridge.scanShell)
    (h_large : bridge.scanShell.largeEnough)
    (h_full : block.fullBlock)
    (h_nonbad : D04MTNonbadFullBlock block) :
    ∃ goodBlock : GoodBlock,
      goodBlock ∈ bridge.blocks ∧
        goodBlock.blockId = block.blockLeft ∧
          goodBlock.candidateLabels =
            ((sourceInputs bridge.scanShell).source_local_input_for_nonbad_full_block
              block h_shell h_large h_full h_nonbad).candidatePrivateLabels := by
  rcases bridge.shell_nonbad_blocks.nonbadFullBlock_complete
      block h_shell h_large h_full h_nonbad with
    ⟨goodBlock, hmem, hblockId, hcandidates⟩
  refine ⟨goodBlock, ?_, hblockId, hcandidates⟩
  simpa [bridge.blocks_eq_shell_nonbad_blocks] using hmem

theorem D04OrderedConcreteNonbadBlockScanBridge.selected_scan_source_local
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs)
    (scanRecord : SelectedScanRecord)
    (hscan : scanRecord ∈ selectedRecords bridge.blocks) :
    ∃ shell : ConcreteDyadicShell,
      ∃ block : ConcreteFullBlock,
        ∃ h_shell : block.shell = shell,
          ∃ h_large : shell.largeEnough,
            ∃ h_full : block.fullBlock,
              ∃ h_nonbad : D04MTNonbadFullBlock block,
                scanRecord.block.blockId = block.blockLeft ∧
                  scanRecord.block.candidateLabels =
                    ((sourceInputs shell).source_local_input_for_nonbad_full_block
                      block h_shell h_large h_full h_nonbad).candidatePrivateLabels := by
  rcases bridge.goodBlock_source_local scanRecord.block
      (selectedRecords_block_mem bridge.blocks scanRecord hscan) with
    ⟨block, h_shell, h_large, h_full, h_nonbad, hblockId, hcandidates⟩
  exact
    ⟨bridge.scanShell, block, h_shell, h_large, h_full, h_nonbad, hblockId,
      hcandidates⟩

theorem D04OrderedConcreteNonbadBlockScanBridge.selected_scan_candidate_exists
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs)
    (scanRecord : SelectedScanRecord)
    (hscan : scanRecord ∈ selectedRecords bridge.blocks) :
    ∃ shell : ConcreteDyadicShell,
      ∃ block : ConcreteFullBlock,
        ∃ h_shell : block.shell = shell,
          ∃ h_large : shell.largeEnough,
            ∃ h_full : block.fullBlock,
              ∃ h_nonbad : D04MTNonbadFullBlock block,
                ∃ candidate : ConcreteCandidateSemiprime block,
                  candidate ∈
                    ((sourceInputs shell).source_local_input_for_nonbad_full_block
                      block h_shell h_large h_full h_nonbad).candidateSemiprimes ∧
                    candidate.privateLabel = scanRecord.label ∧
                    scanRecord.block.blockId = block.blockLeft := by
  rcases bridge.selected_scan_source_local scanRecord hscan with
    ⟨shell, block, h_shell, h_large, h_full, h_nonbad, hblockId, hcandidates⟩
  let input :=
    (sourceInputs shell).source_local_input_for_nonbad_full_block
      block h_shell h_large h_full h_nonbad
  have hlabel_block : scanRecord.label ∈ scanRecord.block.candidateLabels :=
    scanRecord.isCandidate
  have hlabel_input : scanRecord.label ∈ input.candidatePrivateLabels := by
    simpa [input, hcandidates] using hlabel_block
  rcases (input.privateLabels_are_candidate_labels scanRecord.label).1 hlabel_input with
    ⟨candidate, hcandidate_mem, hcandidate_label⟩
  exact
    ⟨shell, block, h_shell, h_large, h_full, h_nonbad, candidate,
      hcandidate_mem, hcandidate_label, hblockId⟩

theorem D04OrderedConcreteNonbadBlockScanBridge.private_label_unique_from_scan
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs) :
    ∀ r s : ConcreteSelectedRecord,
      bridge.record r -> bridge.record s ->
        r.candidate.privateLabel = s.candidate.privateLabel -> r = s := by
  intro r s hr hs hprivate
  rcases (bridge.record_iff_selected_scan r).1 hr with
    ⟨scanRecord, hscan, hscan_eq⟩
  rcases (bridge.record_iff_selected_scan s).1 hs with
    ⟨scanRecord', hscan', hscan_eq'⟩
  subst hscan_eq
  subst hscan_eq'
  have hlabel :
      scanRecord.label = scanRecord'.label := by
    calc
      scanRecord.label =
          (bridge.concreteOfSelected scanRecord).candidate.privateLabel := by
            exact (bridge.concreteOfSelected_label scanRecord hscan).symm
      _ = (bridge.concreteOfSelected scanRecord').candidate.privateLabel := hprivate
      _ = scanRecord'.label := bridge.concreteOfSelected_label scanRecord' hscan'
  have hscan_record :
      scanRecord = scanRecord' :=
    selectedRecords_label_injective bridge.blocks
      scanRecord scanRecord' hscan hscan' hlabel
  subst hscan_record
  rfl

theorem D04OrderedConcreteNonbadBlockScanBridge.fixed_barrier_unique_from_scan
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs) :
    ∀ r s : ConcreteSelectedRecord,
      bridge.record r -> bridge.record s ->
        r.candidate.barrier = s.candidate.barrier -> r = s := by
  intro r s hr hs hbarrier
  have hprivate :
      r.candidate.privateLabel = s.candidate.privateLabel :=
    privateLabel_eq_of_ordered_semiprime_eq r.candidate s.candidate hbarrier
  exact bridge.private_label_unique_from_scan r s hr hs hprivate

noncomputable def D04OrderedConcreteNonbadBlockScanBridge.selectedRecordFromScan
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs)
    (b : Nat) : Option ConcreteSelectedRecord :=
  Option.map bridge.concreteOfSelected
    ((selectedRecords bridge.blocks).find? fun scanRecord =>
      decide ((bridge.concreteOfSelected scanRecord).candidate.barrier = b))

theorem D04OrderedConcreteNonbadBlockScanBridge.selectedRecordFromScan_sound
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs) :
    ∀ b : Nat, ∀ r : ConcreteSelectedRecord,
      bridge.selectedRecordFromScan b = some r ->
        bridge.record r ∧ r.candidate.barrier = b := by
  intro b r hselected
  unfold D04OrderedConcreteNonbadBlockScanBridge.selectedRecordFromScan at hselected
  cases hfind :
      (selectedRecords bridge.blocks).find? (fun scanRecord =>
        decide ((bridge.concreteOfSelected scanRecord).candidate.barrier = b)) with
  | none =>
      simp [hfind] at hselected
  | some scanRecord =>
      simp [hfind] at hselected
      subst hselected
      have hscan :
          scanRecord ∈ selectedRecords bridge.blocks :=
        List.mem_of_find?_eq_some hfind
      have hbarrier_bool :
          decide ((bridge.concreteOfSelected scanRecord).candidate.barrier = b) = true :=
        @List.find?_some SelectedScanRecord
          (fun scanRecord =>
            decide ((bridge.concreteOfSelected scanRecord).candidate.barrier = b))
          scanRecord (selectedRecords bridge.blocks) hfind
      have hbarrier :
          (bridge.concreteOfSelected scanRecord).candidate.barrier = b :=
        of_decide_eq_true hbarrier_bool
      constructor
      · exact (bridge.record_iff_selected_scan
          (bridge.concreteOfSelected scanRecord)).2 ⟨scanRecord, hscan, rfl⟩
      · exact hbarrier

theorem D04OrderedConcreteNonbadBlockScanBridge.selectedRecordFromScan_complete
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs) :
    ∀ r : ConcreteSelectedRecord,
      bridge.record r ->
        bridge.selectedRecordFromScan r.candidate.barrier = some r := by
  intro r hr
  rcases (bridge.record_iff_selected_scan r).1 hr with
    ⟨scanRecord, hscan, hrecord⟩
  subst hrecord
  unfold D04OrderedConcreteNonbadBlockScanBridge.selectedRecordFromScan
  cases hfind :
      (selectedRecords bridge.blocks).find? (fun scanRecord' =>
        decide ((bridge.concreteOfSelected scanRecord').candidate.barrier =
          (bridge.concreteOfSelected scanRecord).candidate.barrier)) with
  | none =>
      have hnone :=
        (List.find?_eq_none).1 hfind scanRecord hscan
      have hpredicate :
          decide ((bridge.concreteOfSelected scanRecord).candidate.barrier =
            (bridge.concreteOfSelected scanRecord).candidate.barrier) = true :=
        decide_eq_true rfl
      exact False.elim (hnone hpredicate)
  | some scanRecord' =>
      have hscan' :
          scanRecord' ∈ selectedRecords bridge.blocks :=
        List.mem_of_find?_eq_some hfind
      have hbarrier_bool :
          decide ((bridge.concreteOfSelected scanRecord').candidate.barrier =
            (bridge.concreteOfSelected scanRecord).candidate.barrier) = true :=
        @List.find?_some SelectedScanRecord
          (fun scanRecord' =>
            decide ((bridge.concreteOfSelected scanRecord').candidate.barrier =
              (bridge.concreteOfSelected scanRecord).candidate.barrier))
          scanRecord' (selectedRecords bridge.blocks) hfind
      have hbarrier :
          (bridge.concreteOfSelected scanRecord').candidate.barrier =
            (bridge.concreteOfSelected scanRecord).candidate.barrier :=
        of_decide_eq_true hbarrier_bool
      have hrecord' :
          bridge.record (bridge.concreteOfSelected scanRecord') :=
        (bridge.record_iff_selected_scan
          (bridge.concreteOfSelected scanRecord')).2
          ⟨scanRecord', hscan', rfl⟩
      have hrecord :
          bridge.record (bridge.concreteOfSelected scanRecord) :=
        (bridge.record_iff_selected_scan
          (bridge.concreteOfSelected scanRecord)).2
          ⟨scanRecord, hscan, rfl⟩
      have hsame :
          bridge.concreteOfSelected scanRecord' =
            bridge.concreteOfSelected scanRecord :=
        bridge.fixed_barrier_unique_from_scan
          (bridge.concreteOfSelected scanRecord')
          (bridge.concreteOfSelected scanRecord)
          hrecord' hrecord hbarrier
      simp [hsame]

/--
Concrete finite-scan certificate missing from the current MT/source-local
interfaces.

The shell and block MT inputs supply local candidate lists and blockwise
incidence facts.  The first-available construction also needs a global scan
state: which records are retained, the barrier-indexed selector produced by the
scan, and cross-block/cross-shell uniqueness of priorities and private labels.
This structure names exactly that remaining Section 4 object without assuming
ordered deletion reasons, unmatched-block counting, cofinal matching, density
data, or the final theorem.
-/
structure D04FirstAvailableSelectedRecordSourceScanCertificate
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell) where
  record : ConcreteSelectedRecord -> Prop
  priority : ConcreteSelectedRecord -> Nat
  selectedRecord : Nat -> Option ConcreteSelectedRecord
  exists_record : ∃ r : ConcreteSelectedRecord, record r
  retained_record_source_local :
    ∀ r : ConcreteSelectedRecord,
      record r ->
        ∃ h_shell : r.block.shell = r.shell,
          ∃ h_large : r.shell.largeEnough,
            ∃ h_full : r.block.fullBlock,
              ∃ h_nonbad : D04MTNonbadFullBlock r.block,
                r.candidate ∈
                  ((sourceInputs r.shell).source_local_input_for_nonbad_full_block
                    r.block h_shell h_large h_full h_nonbad).candidateSemiprimes
  selectedRecord_sound :
    ∀ b : Nat, ∀ r : ConcreteSelectedRecord,
      selectedRecord b = some r -> record r ∧ r.candidate.barrier = b
  selectedRecord_complete :
    ∀ r : ConcreteSelectedRecord,
      record r -> selectedRecord r.candidate.barrier = some r
  priority_injective_on_records :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> priority r = priority s -> r = s
  fixed_barrier_unique :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s -> r.candidate.barrier = s.candidate.barrier -> r = s
  private_label_unique :
    ∀ r s : ConcreteSelectedRecord,
      record r -> record s ->
        r.candidate.privateLabel = s.candidate.privateLabel -> r = s
  first_available_matching_sound :
    ∀ r : ConcreteSelectedRecord, record r -> r.selected_by_first_available_matching

/--
Collapse the ordered concrete scan bridge to the selected-record certificate
consumed by the existing D04 adapter.

All proof obligations are projections from the bridge plus the checked
`selectedRecords` fold; no broad construction axiom or vacuous record source is
introduced here.
-/
noncomputable def D04FirstAvailableSelectedRecordSourceScanCertificate.ofOrderedConcreteBridge
    {sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell}
    (bridge : D04OrderedConcreteNonbadBlockScanBridge sourceInputs) :
    D04FirstAvailableSelectedRecordSourceScanCertificate sourceInputs := by
  have selected_scan_nonempty :
      ∃ scanRecord : SelectedScanRecord, scanRecord ∈ selectedRecords bridge.blocks := by
    have hpositive := bridge.selected_count_positive
    cases hrecords : selectedRecords bridge.blocks with
    | nil =>
        have hzero : 0 < 0 := by
          simpa [hrecords] using hpositive
        exact False.elim (Nat.lt_irrefl 0 hzero)
    | cons scanRecord rest =>
        exact ⟨scanRecord, by simp⟩
  refine
    { record := bridge.record
      priority := bridge.priority
      selectedRecord := bridge.selectedRecordFromScan
      exists_record := ?_
      retained_record_source_local := ?_
      selectedRecord_sound := bridge.selectedRecordFromScan_sound
      selectedRecord_complete := bridge.selectedRecordFromScan_complete
      priority_injective_on_records := bridge.priority_injective_on_records
      fixed_barrier_unique := bridge.fixed_barrier_unique_from_scan
      private_label_unique := bridge.private_label_unique_from_scan
      first_available_matching_sound := ?_ }
  · rcases selected_scan_nonempty with ⟨scanRecord, hscan⟩
    refine ⟨bridge.concreteOfSelected scanRecord, ?_⟩
    exact (bridge.record_iff_selected_scan
      (bridge.concreteOfSelected scanRecord)).2 ⟨scanRecord, hscan, rfl⟩
  · intro r hr
    rcases (bridge.record_iff_selected_scan r).1 hr with
      ⟨scanRecord, hscan, hrecord⟩
    subst hrecord
    exact bridge.concreteOfSelected_source_local scanRecord hscan
  · intro r hr
    rcases (bridge.record_iff_selected_scan r).1 hr with
      ⟨scanRecord, hscan, hrecord⟩
    subst hrecord
    exact bridge.concreteOfSelected_first_available scanRecord hscan

/--
Turn source-local retained-record data into the selected-record source consumed
by the D04 deletion-set adapter.
-/
def FirstAvailableSelectedRecordSourceInput.toSelectedRecordSource
    (input : FirstAvailableSelectedRecordSourceInput) : SelectedRecordSource :=
  { record := input.record
    priority := input.priority
    selectedRecord := input.selectedRecord
    selectedRecord_sound := input.selectedRecord_sound
    selectedRecord_complete := input.selectedRecord_complete
    priority_injective_on_records := input.priority_injective_on_records
    fixed_barrier_unique := input.fixed_barrier_unique
    private_label_unique := input.private_label_unique
    first_available_matching_sound := input.first_available_matching_sound }

def SelectedRecordSource.selectedBarrier
    (src : SelectedRecordSource) (b : Nat) : Prop :=
  ∃ r : ConcreteSelectedRecord, src.selectedRecord b = some r

def SelectedRecordSource.selectedLabel
    (src : SelectedRecordSource) (b : Nat) : Option PrivateBarrierLabel :=
  Option.map ConcreteSelectedRecord.toPrivateBarrierLabel (src.selectedRecord b)

theorem SelectedRecordSource.selectedBarrier_iff_record
    (src : SelectedRecordSource) (b : Nat) :
    src.selectedBarrier b ↔
      ∃ record : ConcreteSelectedRecord, src.selectedRecord b = some record := by
  rfl

theorem SelectedRecordSource.selectedLabel_barrier
    (src : SelectedRecordSource) (b : Nat) (label : PrivateBarrierLabel) :
    src.selectedLabel b = some label -> label.barrier = b := by
  intro hlabel
  unfold SelectedRecordSource.selectedLabel at hlabel
  cases hrecord : src.selectedRecord b with
  | none =>
      simp [hrecord] at hlabel
  | some record =>
      rw [hrecord] at hlabel
      injection hlabel with hlabel_eq
      rcases src.selectedRecord_sound b record hrecord with ⟨_hrecord, hbarrier⟩
      rw [← hlabel_eq]
      exact hbarrier

theorem selected_record_source_selected_has_label
    (src : SelectedRecordSource) :
    ∀ b : Nat, src.selectedBarrier b -> ∃ label : PrivateBarrierLabel,
      src.selectedLabel b = some label ∧ label.barrier = b := by
  intro b hb
  rcases hb with ⟨r, hr⟩
  rcases src.selectedRecord_sound b r hr with ⟨_hrecord, hbarrier⟩
  refine ⟨ConcreteSelectedRecord.toPrivateBarrierLabel r, ?_, ?_⟩
  · simp [SelectedRecordSource.selectedLabel, hr]
  · simp [ConcreteSelectedRecord.toPrivateBarrierLabel, hbarrier]

theorem selected_record_source_label_selects_barrier
    (src : SelectedRecordSource) :
    ∀ b : Nat, ∀ label : PrivateBarrierLabel,
      src.selectedLabel b = some label -> src.selectedBarrier b ∧ label.barrier = b := by
  intro b label hlabel
  unfold SelectedRecordSource.selectedLabel at hlabel
  cases hrec : src.selectedRecord b with
  | none =>
      simp [hrec] at hlabel
  | some r =>
      simp [hrec] at hlabel
      rcases src.selectedRecord_sound b r hrec with ⟨_hrecord, hbarrier⟩
      constructor
      · exact ⟨r, hrec⟩
      · rw [← hlabel]
        simp [ConcreteSelectedRecord.toPrivateBarrierLabel, hbarrier]

theorem selected_record_source_selected_label_arithmetic
    (src : SelectedRecordSource) :
    ∀ b : Nat, src.selectedBarrier b -> ∃ label : PrivateBarrierLabel,
      src.selectedLabel b = some label ∧
        label.barrier = b ∧
        label.smallFactor * label.privateLabel = b ∧
        PrimeLike label.smallFactor ∧
        PrimeLike label.privateLabel ∧
        label.smallFactor < label.privateLabel ∧
        b ≤ label.horizon := by
  intro b hb
  rcases hb with ⟨r, hr⟩
  rcases src.selectedRecord_sound b r hr with ⟨_hrecord, hbarrier⟩
  refine ⟨ConcreteSelectedRecord.toPrivateBarrierLabel r, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simp [SelectedRecordSource.selectedLabel, hr]
  · simp [ConcreteSelectedRecord.toPrivateBarrierLabel, hbarrier]
  · simpa [ConcreteSelectedRecord.toPrivateBarrierLabel, hbarrier] using r.candidate.semiprime_eq
  · simpa [ConcreteSelectedRecord.toPrivateBarrierLabel] using r.candidate.small_prime
  · simpa [ConcreteSelectedRecord.toPrivateBarrierLabel] using r.candidate.private_prime
  · simpa [ConcreteSelectedRecord.toPrivateBarrierLabel] using r.candidate.small_lt_private
  · simpa [ConcreteSelectedRecord.toPrivateBarrierLabel, hbarrier] using r.barrier_le_horizon

theorem selected_record_source_global_private_label_unique
    (src : SelectedRecordSource) :
    ∀ b b' : Nat, ∀ label label' : PrivateBarrierLabel,
      src.selectedBarrier b ->
        src.selectedBarrier b' ->
          src.selectedLabel b = some label ->
            src.selectedLabel b' = some label' ->
              label.privateLabel = label'.privateLabel ->
                b = b' := by
  intro b b' label label' hb hb' hlabel hlabel' hprivate
  rcases hb with ⟨r, hr⟩
  rcases hb' with ⟨s, hs⟩
  rcases src.selectedRecord_sound b r hr with ⟨hr_record, hr_barrier⟩
  rcases src.selectedRecord_sound b' s hs with ⟨hs_record, hs_barrier⟩
  unfold SelectedRecordSource.selectedLabel at hlabel hlabel'
  simp [hr] at hlabel
  simp [hs] at hlabel'
  have hprivate_records :
      r.candidate.privateLabel = s.candidate.privateLabel := by
    simpa [← hlabel, ← hlabel', ConcreteSelectedRecord.toPrivateBarrierLabel] using hprivate
  have hrs : r = s :=
    src.private_label_unique r s hr_record hs_record hprivate_records
  rw [← hr_barrier, ← hs_barrier, hrs]

/-- Finite concrete reasons available to the ordered private-barrier writer. -/
inductive ConcreteDeletionCandidate where
  | finiteInitial
  | shellBoundary (shell : ConcreteDyadicShell)
  | badBlock (block : ConcreteFullBlock)
  | unmatchedBlock (block : ConcreteFullBlock)
  | protectedPrefix (block : ConcreteFullBlock)
  | horizonMultiple (record : ConcreteSelectedRecord)

def ConcreteDeletionCandidate.toPrivateReason :
    ConcreteDeletionCandidate -> PrivateBarrierDeletionReason
  | ConcreteDeletionCandidate.finiteInitial =>
      PrivateBarrierDeletionReason.finiteInitial
  | ConcreteDeletionCandidate.shellBoundary shell =>
      PrivateBarrierDeletionReason.shellBoundary shell.left
  | ConcreteDeletionCandidate.badBlock block =>
      PrivateBarrierDeletionReason.badBlock block.shell.left block.blockLeft
  | ConcreteDeletionCandidate.unmatchedBlock block =>
      PrivateBarrierDeletionReason.unmatchedBlock block.shell.left block.blockLeft
  | ConcreteDeletionCandidate.protectedPrefix block =>
      PrivateBarrierDeletionReason.protectedPrefix block.shell.left block.blockLeft
  | ConcreteDeletionCandidate.horizonMultiple record =>
      PrivateBarrierDeletionReason.horizonMultiple record.toPrivateBarrierLabel

/--
Priority-ordered reason source.  `reasonCandidates n` is already in the
intended priority order: finite initial, shell boundary, bad block, unmatched
block, protected prefix, then selected-record horizon multiples.
-/
structure OrderedReasonSource (src : SelectedRecordSource) where
  reasonCandidates : Nat -> List ConcreteDeletionCandidate
  selected_candidates_empty :
    ∀ r : ConcreteSelectedRecord,
      src.record r -> reasonCandidates r.candidate.barrier = []
  head_horizon_exact :
    ∀ n : Nat, ∀ r : ConcreteSelectedRecord,
      (reasonCandidates n).head? = some (ConcreteDeletionCandidate.horizonMultiple r) ->
        src.record r ∧
          r.candidate.privateLabel ∣ n ∧
          n ≤ r.horizon ∧
          n ≠ r.candidate.barrier
  horizon_candidate_coverage :
    ∀ b n : Nat, ∀ label : PrivateBarrierLabel,
      src.selectedBarrier b ->
        src.selectedLabel b = some label ->
          n < b ->
            n ≤ label.horizon ->
              label.privateLabel ∣ n ->
                n ≠ b ->
                  ∃ r : ConcreteSelectedRecord,
                    ConcreteDeletionCandidate.horizonMultiple r ∈ reasonCandidates n

def OrderedReasonSource.deletionReason
    {src : SelectedRecordSource} (ors : OrderedReasonSource src) (n : Nat) :
    Option PrivateBarrierDeletionReason :=
  Option.map ConcreteDeletionCandidate.toPrivateReason (ors.reasonCandidates n).head?

theorem ordered_reason_selected_protected
    (src : SelectedRecordSource) (ors : OrderedReasonSource src) :
    ∀ b : Nat, src.selectedBarrier b -> ors.deletionReason b = none := by
  intro b hb
  rcases hb with ⟨r, hr⟩
  rcases src.selectedRecord_sound b r hr with ⟨hr_record, hbarrier⟩
  have hempty := ors.selected_candidates_empty r hr_record
  rw [← hbarrier]
  simp [OrderedReasonSource.deletionReason, hempty]

theorem ordered_reason_horizon_reason_has_private_label
    (src : SelectedRecordSource) (ors : OrderedReasonSource src) :
    ∀ n : Nat, ∀ label : PrivateBarrierLabel,
      ors.deletionReason n =
        some (PrivateBarrierDeletionReason.horizonMultiple label) ->
          n ≠ label.barrier := by
  intro n label hreason
  unfold OrderedReasonSource.deletionReason at hreason
  cases hhead : (ors.reasonCandidates n).head? with
  | none =>
      simp [hhead] at hreason
  | some cand =>
      cases cand with
      | finiteInitial =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | shellBoundary shell =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | badBlock block =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | unmatchedBlock block =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | protectedPrefix block =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | horizonMultiple r =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
          rcases ors.head_horizon_exact n r hhead with ⟨_hr, _hdiv, _hle, hne⟩
          rw [← hreason]
          simpa [ConcreteSelectedRecord.toPrivateBarrierLabel] using hne

theorem ordered_reason_horizon_reason_exact
    (src : SelectedRecordSource) (ors : OrderedReasonSource src) :
    ∀ n : Nat, ∀ label : PrivateBarrierLabel,
      ors.deletionReason n =
        some (PrivateBarrierDeletionReason.horizonMultiple label) ->
          label.privateLabel ∣ n ∧ n ≤ label.horizon ∧ n ≠ label.barrier := by
  intro n label hreason
  unfold OrderedReasonSource.deletionReason at hreason
  cases hhead : (ors.reasonCandidates n).head? with
  | none =>
      simp [hhead] at hreason
  | some cand =>
      cases cand with
      | finiteInitial =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | shellBoundary shell =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | badBlock block =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | unmatchedBlock block =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | protectedPrefix block =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
      | horizonMultiple r =>
          simp [hhead, ConcreteDeletionCandidate.toPrivateReason] at hreason
          rcases ors.head_horizon_exact n r hhead with ⟨_hr, hdiv, hle, hne⟩
          rw [← hreason]
          simpa [ConcreteSelectedRecord.toPrivateBarrierLabel] using And.intro hdiv (And.intro hle hne)

theorem ordered_reason_horizon_deletes_earlier_nonbarrier_multiples
    (src : SelectedRecordSource) (ors : OrderedReasonSource src) :
    ∀ b n : Nat, ∀ label : PrivateBarrierLabel,
      src.selectedBarrier b ->
        src.selectedLabel b = some label ->
          n < b ->
            n ≤ label.horizon ->
              label.privateLabel ∣ n ->
                n ≠ b ->
                  ∃ reason : PrivateBarrierDeletionReason,
                    ors.deletionReason n = some reason := by
  intro b n label hb hlabel hnlt hnh hdiv hne
  rcases ors.horizon_candidate_coverage b n label hb hlabel hnlt hnh hdiv hne with
    ⟨r, hrmem⟩
  unfold OrderedReasonSource.deletionReason
  cases hlist : ors.reasonCandidates n with
  | nil =>
      simp [hlist] at hrmem
  | cons cand rest =>
      refine ⟨ConcreteDeletionCandidate.toPrivateReason cand, ?_⟩
      simp

/--
Adapter from the selected-record source layer to the downstream deletion-set
interface.  This is deliberately below `PrivateBarrierDeletionSet`: it packages
the source and ordered reason writer, rather than assuming the downstream
package as input.
-/
def privateBarrierDeletionSetFromSelectedRecordSource
    (src : SelectedRecordSource) (ors : OrderedReasonSource src) :
    PrivateBarrierDeletionSet :=
  { selectedBarrier := src.selectedBarrier
    selectedLabel := src.selectedLabel
    deletionReason := ors.deletionReason
    selected_has_label := selected_record_source_selected_has_label src
    label_selects_barrier := selected_record_source_label_selects_barrier src
    selected_protected := ordered_reason_selected_protected src ors
    horizon_reason_has_private_label :=
      ordered_reason_horizon_reason_has_private_label src ors }

theorem privateBarrierDeletionSetFromSelectedRecordSource_selectedLabel_barrier
    (src : SelectedRecordSource)
    (ors : OrderedReasonSource src)
    (b : Nat) (label : PrivateBarrierLabel) :
    (privateBarrierDeletionSetFromSelectedRecordSource src ors).selectedLabel b = some label ->
      label.barrier = b :=
  src.selectedLabel_barrier b label

theorem privateBarrierDeletionSetFromSources_selectedLabel_barrier
    (src : SelectedRecordSource)
    (ors : OrderedReasonSource src)
    (b : Nat) (label : PrivateBarrierLabel) :
    (privateBarrierDeletionSetFromSelectedRecordSource src ors).selectedLabel b = some label ->
      label.barrier = b :=
  privateBarrierDeletionSetFromSelectedRecordSource_selectedLabel_barrier src ors b label

/--
Adapter from selected-record source arithmetic and ordered horizon coverage to
the downstream arithmetic interface.
-/
theorem privateBarrierArithmeticFromSelectedRecordSource
    (src : SelectedRecordSource) (ors : OrderedReasonSource src) :
    PrivateBarrierArithmetic
      (privateBarrierDeletionSetFromSelectedRecordSource src ors) :=
  { selected_label_arithmetic := by
      intro b hb
      exact selected_record_source_selected_label_arithmetic src b hb
    selected_label_global_private := by
      intro b b' label label' hb hb' hlabel hlabel' hprivate
      exact selected_record_source_global_private_label_unique
        src b b' label label' hb hb' hlabel hlabel' hprivate
    horizon_deletes_earlier_nonbarrier_multiples := by
      intro b n label hb hlabel hnlt hnh hdiv hne
      exact ordered_reason_horizon_deletes_earlier_nonbarrier_multiples
        src ors b n label hb hlabel hnlt hnh hdiv hne
    horizon_reason_exact := by
      intro n label hreason
      exact ordered_reason_horizon_reason_exact src ors n label hreason }

/--
Conditional D04 selected-record relation carrier.  This does not construct the
relation from MT-good blocks; it only names the concrete source interface that
the deletion-set wrapper consumes.
-/
structure ConcreteSelectedRecordRelation where
  toSelectedRecordSource : SelectedRecordSource

/--
Construct the first-available concrete selected-record relation from the
source-local retained-record interface.

The output is intentionally only the relation and its nonempty selected barrier
surface.  Ordered reason candidates, unmatched counting, and cofinal matching
remain separate downstream obligations for the same source.
-/
theorem construct_FirstAvailableSelectedRecordSource
    (input : FirstAvailableSelectedRecordSourceInput) :
    ∃ rel : ConcreteSelectedRecordRelation,
      rel.toSelectedRecordSource = input.toSelectedRecordSource ∧
        ∃ b : Nat, rel.toSelectedRecordSource.selectedBarrier b := by
  let src := input.toSelectedRecordSource
  refine ⟨{ toSelectedRecordSource := src }, rfl, ?_⟩
  rcases input.exists_record with ⟨r, hr⟩
  refine ⟨r.candidate.barrier, r, ?_⟩
  exact input.selectedRecord_complete r hr

/--
Conditional D04 ordered-reason carrier over a selected-record source.  The
ordered finite reason writer itself is still supplied by the source-local
construction layer.
-/
structure ConcreteOrderedReasonCandidates (src : SelectedRecordSource) where
  toOrderedReasonSource : OrderedReasonSource src

/-- Concrete empty selected-record source used when the first-available source is not closed. -/
def emptySelectedRecordSource : SelectedRecordSource :=
  { record := fun _ => False
    priority := fun _ => 0
    selectedRecord := fun _ => none
    selectedRecord_sound := by
      intro b r h
      simp at h
    selectedRecord_complete := by
      intro r h
      contradiction
    priority_injective_on_records := by
      intro r s hr hs hpriority
      contradiction
    fixed_barrier_unique := by
      intro r s hr hs hbarrier
      contradiction
    private_label_unique := by
      intro r s hr hs hlabel
      contradiction
    first_available_matching_sound := by
      intro r hr
      contradiction }

/--
Concrete relation object backed by the finite scan engine.  It is currently the
empty projection because the source-local theorem connecting all MT-good blocks
to selected scan records remains open.
-/
def concreteFirstAvailableSelectedRecordRelation :
    ConcreteSelectedRecordRelation :=
  { toSelectedRecordSource := emptySelectedRecordSource }

/-- Ordered reason source for the empty selected-record projection. -/
def emptyOrderedReasonSource : OrderedReasonSource emptySelectedRecordSource :=
  { reasonCandidates := fun _ => []
    selected_candidates_empty := by
      intro r hr
      contradiction
    head_horizon_exact := by
      intro n r h
      simp at h
    horizon_candidate_coverage := by
      intro b n label hb hlabel hnlt hnh hdiv hne
      rcases hb with ⟨r, hr⟩
      simp [emptySelectedRecordSource] at hr }

/--
Concrete ordered-reason package for the empty selected-record projection.
The standalone `DeletionReason` writer above records the intended priority
list and nodup proof for the nonempty implementation.
-/
def concreteFirstAvailableOrderedReasonCandidates :
    ConcreteOrderedReasonCandidates
      concreteFirstAvailableSelectedRecordRelation.toSelectedRecordSource :=
  { toOrderedReasonSource := emptyOrderedReasonSource }

/--
Concrete D04 deletion-set package from the selected-record relation and the
ordered finite reason writer.

The selected records are produced before this definition is applied.  The
deletion reason is then the ordered finite list consisting of the initial
cutoff, shell boundary, bad block, unmatched block, protected prefix, and
selected-record horizon multiple components packaged by
`ConcreteOrderedReasonCandidates`.
-/
def D04DeletionSet
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) :
    PrivateBarrierDeletionSet :=
  privateBarrierDeletionSetFromSelectedRecordSource
    rel.toSelectedRecordSource data.toOrderedReasonSource

theorem D04DeletionSet_arithmetic
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) :
    PrivateBarrierArithmetic (D04DeletionSet rel data) :=
  privateBarrierArithmeticFromSelectedRecordSource
    rel.toSelectedRecordSource data.toOrderedReasonSource

theorem D04DeletionSet_selected_label_arithmetic
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) :
    ∀ b : Nat, (D04DeletionSet rel data).selectedBarrier b ->
      ∃ label : PrivateBarrierLabel,
        (D04DeletionSet rel data).selectedLabel b = some label ∧
          label.barrier = b ∧
          label.smallFactor * label.privateLabel = b ∧
          PrimeLike label.smallFactor ∧
          PrimeLike label.privateLabel ∧
          label.smallFactor < label.privateLabel ∧
          b ≤ label.horizon :=
  (D04DeletionSet_arithmetic rel data).selected_label_arithmetic

theorem D04DeletionSet_selected_label_global_private
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) :
    ∀ b b' : Nat, ∀ label label' : PrivateBarrierLabel,
      (D04DeletionSet rel data).selectedBarrier b ->
        (D04DeletionSet rel data).selectedBarrier b' ->
          (D04DeletionSet rel data).selectedLabel b = some label ->
            (D04DeletionSet rel data).selectedLabel b' = some label' ->
              label.privateLabel = label'.privateLabel ->
                b = b' :=
  (D04DeletionSet_arithmetic rel data).selected_label_global_private

theorem D04DeletionSet_horizon_deletes_earlier_nonbarrier_multiples
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) :
    ∀ b n : Nat, ∀ label : PrivateBarrierLabel,
      (D04DeletionSet rel data).selectedBarrier b ->
        (D04DeletionSet rel data).selectedLabel b = some label ->
          n < b ->
            n ≤ label.horizon ->
              label.privateLabel ∣ n ->
                n ≠ b ->
                  (D04DeletionSet rel data).Deleted n :=
  (D04DeletionSet_arithmetic rel data).horizon_deletes_earlier_nonbarrier_multiples

theorem D04DeletionSet_horizon_reason_exact
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) :
    ∀ n : Nat, ∀ label : PrivateBarrierLabel,
      (D04DeletionSet rel data).deletionReason n =
        some (PrivateBarrierDeletionReason.horizonMultiple label) ->
          label.privateLabel ∣ n ∧ n ≤ label.horizon ∧ n ≠ label.barrier :=
  (D04DeletionSet_arithmetic rel data).horizon_reason_exact

theorem privateBarrierSelectedNotDeleted
    (pkg : PrivateBarrierDeletionSet) :
    ∀ b : Nat, pkg.selectedBarrier b -> ¬ pkg.Deleted b := by
  intro b hb hdel
  rcases hdel with ⟨reason, hreason⟩
  have hnone := pkg.selected_protected b hb
  rw [hnone] at hreason
  contradiction

/--
Selected-barrier abundance is enough to recover the accepted-prefix cofinality
needed by the ordered stream.  The substantive content remains the premise:
for every requested accepted index, some selected barrier has already forced a
long enough finite accepted prefix by the time the scan reaches `b - 2`.
-/
theorem privateBarrierAcceptedPrefixCofinal_fromSelection
    (pkg : PrivateBarrierDeletionSet)
    (habundant :
      ∀ i : Nat, ∃ b : Nat, pkg.selectedBarrier b ∧
        i < (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 2)).length) :
    ∀ i : Nat, ∃ m : Nat,
      i < (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted m).length := by
  intro i
  rcases habundant i with ⟨b, _hb, hlen⟩
  exact ⟨b - 2, hlen⟩

/-- A selected private barrier survives the finite scan and is present by its horizon. -/
def PrivateBarrierSelectedAcceptedAtHorizon (pkg : PrivateBarrierDeletionSet) : Prop :=
  ∀ b : Nat, pkg.selectedBarrier b ->
    b ∈ modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 2)

/--
Exact finite collision-exclusion obligation for selected private barriers.
For a selected barrier `b`, when the scan is about to test candidate `b`, the
old accepted prefix can be extended by `b` without creating an equal
consecutive-block product.  This is the formal target of the private-label
multiple deletion and final-suffix argument in `main.tex`, Proposition
`prop:barriers`.
-/
def PrivateBarrierSelectedCollisionFreeAtScan (pkg : PrivateBarrierDeletionSet) : Prop :=
  ∀ b : Nat, pkg.selectedBarrier b ->
    3 ≤ b ∧
      FiniteDistinctConsecutiveBlockProducts
        (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) ++ [b])

/--
Structured finite collision fragments for the selected-barrier scan.  For a
selected barrier `b`, write `xs` for the old accepted prefix immediately before
`b` is tested.  These fields separate the private-label argument into the
four possible product-collision shapes:

* old-old products, which are already protected by the finite greedy prefix;
* old-new products, excluded by the private-label divisibility/deletion rule;
* new-old products, the symmetric old-new case;
* new-new products, excluded after cancelling `b` by strict final suffix order.
-/
structure PrivateBarrierSelectedCollisionFragments (pkg : PrivateBarrierDeletionSet) where
  selected_scan_lower :
    ∀ b : Nat, pkg.selectedBarrier b -> 3 ≤ b
  old_old_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u v u' v' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ v' ->
        v' < xs.length ->
        finiteBlockProduct (xs ++ [b]) u v =
          finiteBlockProduct (xs ++ [b]) u' v' ->
        u = u' ∧ v = v'
  old_new_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u v u' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u v ≠
          finiteBlockProduct (xs ++ [b]) u' xs.length
  new_old_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' v' : Nat,
        u ≤ xs.length ->
        u' ≤ v' ->
        v' < xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length ≠
          finiteBlockProduct (xs ++ [b]) u' v'
  new_new_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        u = u'

/--
The fragment package implies the scan-level selected-barrier collision
obligation.  This theorem is bookkeeping: it only splits a possible equality
of consecutive products according to whether each product ends before the old
prefix boundary or at the newly appended barrier.
-/
theorem privateBarrierSelectedCollisionFreeAtScan_fromFragments
    (pkg : PrivateBarrierDeletionSet)
    (hfragments : PrivateBarrierSelectedCollisionFragments pkg) :
    PrivateBarrierSelectedCollisionFreeAtScan pkg := by
  classical
  intro b hb
  refine ⟨hfragments.selected_scan_lower b hb, ?_⟩
  let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
  intro u v u' v' huv hv huv' hv' hprod
  have hvle : v ≤ xs.length := by
    simpa [xs, Nat.lt_succ_iff] using hv
  have hv'le : v' ≤ xs.length := by
    simpa [xs, Nat.lt_succ_iff] using hv'
  by_cases hvold : v < xs.length
  · by_cases hv'old : v' < xs.length
    · exact hfragments.old_old_collision_free b hb u v u' v' huv hvold huv' hv'old hprod
    · have hv'eq : v' = xs.length := by omega
      have huv'_len : u' ≤ xs.length := by omega
      have hprod' :
          finiteBlockProduct (xs ++ [b]) u v =
            finiteBlockProduct (xs ++ [b]) u' xs.length := by
        simpa [xs, hv'eq] using hprod
      exact False.elim
        ((hfragments.old_new_collision_free b hb u v u' huv hvold huv'_len hprod'))
  · have hveq : v = xs.length := by omega
    subst v
    by_cases hv'old : v' < xs.length
    · exact False.elim
        ((hfragments.new_old_collision_free b hb u u' v' huv huv' hv'old hprod))
    · have hv'eq : v' = xs.length := by omega
      have huv'_len : u' ≤ xs.length := by omega
      have hprod' :
          finiteBlockProduct (xs ++ [b]) u xs.length =
            finiteBlockProduct (xs ++ [b]) u' xs.length := by
        simpa [xs, hv'eq] using hprod
      have huu' := hfragments.new_new_collision_free b hb u u' huv huv'_len hprod'
      exact ⟨huu', hv'eq.symm⟩

/--
Bookkeeping bridge from selected-barrier survival plus finite collision
exclusion to acceptance by horizon `b - 2`.  The substantive mathematical
content is now isolated in `PrivateBarrierSelectedCollisionFreeAtScan`.
-/
theorem privateBarrierSelectedAcceptedAtHorizon_fromCollisionFree
    (pkg : PrivateBarrierDeletionSet)
    (hcollision : PrivateBarrierSelectedCollisionFreeAtScan pkg) :
    PrivateBarrierSelectedAcceptedAtHorizon pkg := by
  classical
  intro b hb
  rcases hcollision b hb with ⟨hb3, hdistinct⟩
  have hnotD : ¬ pkg.Deleted b := privateBarrierSelectedNotDeleted pkg b hb
  have hscan : b - 3 + 3 = b := by omega
  have hhorizon : b - 3 + 1 = b - 2 := by omega
  have hstep :
      modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3 + 1) =
        modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) ++ [b] := by
    simp [modifiedGreedyAcceptedPrefixFromDeletion, hscan, hnotD, hdistinct]
  rw [← hhorizon, hstep]
  simp

/--
Selected private barriers occur abundantly enough that, once such a barrier is
accepted by its own horizon, the finite accepted prefix is already longer than
any requested stream index.
-/
def PrivateBarrierSelectedOccurrenceAbundant (pkg : PrivateBarrierDeletionSet) : Prop :=
  ∀ i : Nat, ∃ b : Nat, pkg.selectedBarrier b ∧
    (b ∈ modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 2) ->
      i < (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 2)).length)

/--
Rank-indexed supply of selected private barriers from the shell/block
construction.  This is deliberately narrower than the final target: it only
names selected barriers with shell/block provenance and says that the accepted
prefix at the barrier horizon is long enough for the corresponding rank.
-/
structure PrivateBarrierSelectedOccurrenceSupply (pkg : PrivateBarrierDeletionSet) where
  barrierOfRank : Nat -> Nat
  shellOfRank : Nat -> Nat
  blockOfRank : Nat -> Nat
  selected_of_rank : ∀ r : Nat, pkg.selectedBarrier (barrierOfRank r)
  label_provenance :
    ∀ r : Nat, ∃ label : PrivateBarrierLabel,
      pkg.selectedLabel (barrierOfRank r) = some label ∧
        label.barrier = barrierOfRank r ∧
        label.shell = shellOfRank r ∧
        label.block = blockOfRank r
  rank_ordered : StrictlyIncreasing barrierOfRank
  rank_distinct : ∀ r s : Nat, barrierOfRank r = barrierOfRank s -> r = s
  prefix_length_lower_bound :
    ∀ r : Nat,
      r < (modifiedGreedyAcceptedPrefixFromDeletion
        pkg.Deleted (barrierOfRank r - 2)).length

/--
The rank-indexed selected-occurrence supply is enough for the older abundance
predicate.  Acceptance-at-horizon is handled separately; this bridge only
forgets the shell/block provenance and rank order fields.
-/
theorem privateBarrierSelectedOccurrenceAbundant_fromSupply
    (pkg : PrivateBarrierDeletionSet)
    (supply : PrivateBarrierSelectedOccurrenceSupply pkg) :
    PrivateBarrierSelectedOccurrenceAbundant pkg := by
  intro i
  refine ⟨supply.barrierOfRank i, supply.selected_of_rank i, ?_⟩
  intro _haccepted
  exact supply.prefix_length_lower_bound i

/--
Pure bookkeeping bridge from the split selected-barrier obligations back to
the accepted-prefix abundance premise required for ordered enumeration.
-/
theorem privateBarrierSelectedAcceptedPrefixAbundant_fromSplit
    (pkg : PrivateBarrierDeletionSet)
    (habundant : PrivateBarrierSelectedOccurrenceAbundant pkg)
    (haccepted : PrivateBarrierSelectedAcceptedAtHorizon pkg) :
    ∀ i : Nat, ∃ b : Nat, pkg.selectedBarrier b ∧
      i < (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 2)).length := by
  intro i
  rcases habundant i with ⟨b, hb, hlen_of_accepted⟩
  exact ⟨b, hb, hlen_of_accepted (haccepted b hb)⟩

/-- Every entry ever accepted by the deletion-driven recurrence is positive. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_mem_positive
    (D : Nat -> Prop) :
    ∀ m n : Nat, n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m -> 0 < n := by
  classical
  intro m
  induction m with
  | zero =>
      intro n hn
      simp [modifiedGreedyAcceptedPrefixFromDeletion] at hn
      omega
  | succ m ih =>
      intro n hn
      by_cases hD : D (m + 3)
      · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD] at hn
        exact ih n hn
      · by_cases hdistinct :
          FiniteDistinctConsecutiveBlockProducts
            (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          rcases hn with hn | hn
          · exact ih n hn
          · omega
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          exact ih n hn

/-- Every entry ever accepted by the deletion-driven recurrence is at least `2`. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_mem_two_le
    (D : Nat -> Prop) :
    ∀ m n : Nat, n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m -> 2 ≤ n := by
  classical
  intro m
  induction m with
  | zero =>
      intro n hn
      simp [modifiedGreedyAcceptedPrefixFromDeletion] at hn
      omega
  | succ m ih =>
      intro n hn
      by_cases hD : D (m + 3)
      · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD] at hn
        exact ih n hn
      · by_cases hdistinct :
          FiniteDistinctConsecutiveBlockProducts
            (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          rcases hn with hn | hn
          · exact ih n hn
          · omega
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          exact ih n hn

theorem getD_mem_of_lt {xs : List Nat} {i : Nat} (h : i < xs.length) :
    xs.getD i 1 ∈ xs := by
  revert i
  induction xs with
  | nil =>
      intro i h
      simp at h
  | cons x xs ih =>
      intro i h
      cases i with
      | zero =>
          simp
      | succ i =>
          simp at h
          simp [List.getD]
          exact Or.inr (ih h)

theorem modifiedGreedyAcceptedPrefixFromDeletion_getD_two_le
    (D : Nat -> Prop) (m i : Nat)
    (hi : i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length) :
    2 ≤ (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 := by
  exact
    modifiedGreedyAcceptedPrefixFromDeletion_mem_two_le D m
      ((modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1)
      (getD_mem_of_lt hi)

theorem getD_append_left {xs ys : List Nat} {i : Nat} (fallback : Nat)
    (hi : i < xs.length) :
    (xs ++ ys).getD i fallback = xs.getD i fallback := by
  simp [List.getD, List.getElem?_append, hi]

theorem getD_append_singleton_length {xs : List Nat} {x fallback : Nat} :
    (xs ++ [x]).getD xs.length fallback = x := by
  simp [List.getD]

theorem getD_eq_of_prefix {xs ys : List Nat} {i fallback : Nat}
    (hprefix : xs <+: ys) (hi : i < xs.length) :
    ys.getD i fallback = xs.getD i fallback := by
  rcases hprefix with ⟨zs, hzs⟩
  rw [← hzs]
  exact getD_append_left (ys := zs) (fallback := fallback) hi

theorem exists_getD_eq_of_mem {xs : List Nat} {n : Nat} (hn : n ∈ xs) :
    ∃ i : Nat, i < xs.length ∧ xs.getD i 1 = n := by
  rw [List.mem_iff_getElem?] at hn
  rcases hn with ⟨i, hi⟩
  rcases (List.getElem?_eq_some_iff.mp hi) with ⟨hlt, _hget⟩
  refine ⟨i, hlt, ?_⟩
  simp [List.getD, hi]

/-- Every value present after `m` scan steps is no larger than the last scanned candidate. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_mem_le_scan_bound
    (D : Nat -> Prop) :
    ∀ m n : Nat, n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m -> n ≤ m + 2 := by
  classical
  intro m
  induction m with
  | zero =>
      intro n hn
      simp [modifiedGreedyAcceptedPrefixFromDeletion] at hn
      omega
  | succ m ih =>
      intro n hn
      by_cases hD : D (m + 3)
      · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD] at hn
        have hle := ih n hn
        omega
      · by_cases hdistinct :
          FiniteDistinctConsecutiveBlockProducts
            (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          rcases hn with hn | hn
          · have hle := ih n hn
            omega
          · omega
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          have hle := ih n hn
          omega

/--
Every non-initial accepted value in the deletion-driven recurrence survived
its own forced-deletion test.  The initial seed `2` is intentionally excluded:
the recurrence starts from `[2]` before candidate tests begin at `3`.
-/
theorem modifiedGreedyAcceptedPrefixFromDeletion_mem_not_deleted
    (D : Nat -> Prop) :
    ∀ m n : Nat,
      3 ≤ n ->
        n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m ->
          ¬ D n := by
  classical
  intro m
  induction m with
  | zero =>
      intro n hn3 hn
      simp [modifiedGreedyAcceptedPrefixFromDeletion] at hn
      omega
  | succ m ih =>
      intro n hn3 hn
      by_cases hD : D (m + 3)
      · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD] at hn
        exact ih n hn3 hn
      · by_cases hdistinct :
          FiniteDistinctConsecutiveBlockProducts
            (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          rcases hn with hn | hn
          · exact ih n hn3 hn
          · intro hdel
            have hn_eq : n = m + 3 := by omega
            exact hD (by simpa [hn_eq] using hdel)
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hn
          exact ih n hn3 hn

/--
Finite accepted prefixes produced by the recurrence are strictly ordered by
index.  This is a pure consequence of the scan order: each accepted candidate
is appended only when the scan reaches it, and all earlier entries are bounded
by the previous scanned candidate.
-/
theorem modifiedGreedyAcceptedPrefixFromDeletion_index_strict
    (D : Nat -> Prop) :
    ∀ m i j : Nat,
      i < j ->
        j < (modifiedGreedyAcceptedPrefixFromDeletion D m).length ->
          (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 <
            (modifiedGreedyAcceptedPrefixFromDeletion D m).getD j 1 := by
  classical
  intro m
  induction m with
  | zero =>
      intro i j hij hj
      simp [modifiedGreedyAcceptedPrefixFromDeletion] at hj
      omega
  | succ m ih =>
      intro i j hij hj
      by_cases hD : D (m + 3)
      · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD] at hj ⊢
        exact ih i j hij hj
      · by_cases hdistinct :
          FiniteDistinctConsecutiveBlockProducts
            (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
        · by_cases hjold : j < (modifiedGreedyAcceptedPrefixFromDeletion D m).length
          · have hiold : i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length :=
              Nat.lt_trans hij hjold
            have hprefix := ih i j hij hjold
            have hgeti :
                (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3]).getD i 1 =
                  (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 :=
              getD_append_left (ys := [m + 3]) (fallback := 1) hiold
            have hgetj :
                (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3]).getD j 1 =
                  (modifiedGreedyAcceptedPrefixFromDeletion D m).getD j 1 :=
              getD_append_left (ys := [m + 3]) (fallback := 1) hjold
            simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct]
            change
              (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3]).getD i 1 <
                (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3]).getD j 1
            rw [hgeti, hgetj]
            exact hprefix
          · have hlen :
                j = (modifiedGreedyAcceptedPrefixFromDeletion D m).length := by
              have hjle :
                  j ≤ (modifiedGreedyAcceptedPrefixFromDeletion D m).length := by
                simpa [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct,
                  Nat.lt_succ_iff] using hj
              omega
            have hiold : i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length := by
              simpa [hlen] using hij
            have hmem :
                (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 ∈
                  modifiedGreedyAcceptedPrefixFromDeletion D m :=
              getD_mem_of_lt hiold
            have hle :
                (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 ≤ m + 2 :=
              modifiedGreedyAcceptedPrefixFromDeletion_mem_le_scan_bound D m
                ((modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1) hmem
            have hlt :
                (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 < m + 3 := by
              omega
            have hgeti :
                (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3]).getD i 1 =
                  (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 :=
              getD_append_left (ys := [m + 3]) (fallback := 1) hiold
            simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct, hlen]
            change
              (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3]).getD i 1 <
                m + 3
            rw [hgeti]
            exact hlt
        · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct] at hj ⊢
          exact ih i j hij hj

/--
The `i`-th accepted denominator is at least `i + 2`.

The recurrence only accepts denominators from the ordered scan `2, 3, ...`;
combined with strict increase by index, this gives the basic growth lower bound
used by the finite old-product counting argument.
-/
theorem modifiedGreedyAcceptedPrefixFromDeletion_getD_index_add_two_le
    (D : Nat -> Prop) (m i : Nat)
    (hi : i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length) :
    i + 2 ≤ (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 := by
  induction i with
  | zero =>
      simpa using modifiedGreedyAcceptedPrefixFromDeletion_getD_two_le D m 0 hi
  | succ i ih =>
      have hi_lt : i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length := by
        omega
      have hprev :
          i + 2 ≤ (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 :=
        ih hi_lt
      have hstrict :
          (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 <
            (modifiedGreedyAcceptedPrefixFromDeletion D m).getD (i + 1) 1 :=
        modifiedGreedyAcceptedPrefixFromDeletion_index_strict D m i (i + 1)
          (by omega) hi
      omega

/-- One recurrence step preserves the old accepted prefix as an initial segment. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_step_prefix
    (D : Nat -> Prop) (m : Nat) :
    modifiedGreedyAcceptedPrefixFromDeletion D m <+:
      modifiedGreedyAcceptedPrefixFromDeletion D (m + 1) := by
  classical
  by_cases hD : D (m + 3)
  · refine ⟨[], ?_⟩
    simp [modifiedGreedyAcceptedPrefixFromDeletion, hD]
  · by_cases hdistinct :
      FiniteDistinctConsecutiveBlockProducts
        (modifiedGreedyAcceptedPrefixFromDeletion D m ++ [m + 3])
    · simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct]
    · refine ⟨[], ?_⟩
      simp [modifiedGreedyAcceptedPrefixFromDeletion, hD, hdistinct]

theorem modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono_add
    (D : Nat -> Prop) :
    ∀ m k : Nat,
      modifiedGreedyAcceptedPrefixFromDeletion D m <+:
        modifiedGreedyAcceptedPrefixFromDeletion D (m + k) := by
  intro m k
  induction k with
  | zero =>
      refine ⟨[], ?_⟩
      simp
  | succ k ih =>
      exact List.IsPrefix.trans ih
        (modifiedGreedyAcceptedPrefixFromDeletion_step_prefix D (m + k))

/-- Accepted prefixes are monotone in the scan horizon. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono
    (D : Nat -> Prop) :
    ∀ {m m' : Nat}, m ≤ m' ->
      modifiedGreedyAcceptedPrefixFromDeletion D m <+:
        modifiedGreedyAcceptedPrefixFromDeletion D m' := by
  intro m m' hle
  rcases Nat.exists_eq_add_of_le hle with ⟨k, rfl⟩
  exact modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono_add D m k

/-- Membership in an accepted prefix persists at all later scan horizons. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_mem_mono
    (D : Nat -> Prop) :
    ∀ {m m' n : Nat}, m ≤ m' ->
      n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m ->
        n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m' := by
  intro m m' n hle hn
  rcases modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono D hle with ⟨zs, hzs⟩
  rw [← hzs]
  exact List.mem_append_left zs hn

/-- Fixed prefix entries are stable at later scan horizons. -/
theorem modifiedGreedyAcceptedPrefixFromDeletion_getD_mono
    (D : Nat -> Prop) :
    ∀ {m m' i : Nat}, m ≤ m' ->
      i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length ->
        (modifiedGreedyAcceptedPrefixFromDeletion D m').getD i 1 =
          (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 := by
  intro m m' i hle hi
  exact getD_eq_of_prefix (modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono D hle) hi

theorem foldl_mul_eq_of_forall_mem
    (f g : Nat -> Nat) :
    ∀ xs : List Nat,
      (∀ k : Nat, k ∈ xs -> f k = g k) ->
        ∀ acc : Nat,
          xs.foldl (fun acc k => acc * f k) acc =
            xs.foldl (fun acc k => acc * g k) acc := by
  intro xs
  induction xs with
  | nil =>
      intro _ acc
      simp
  | cons x xs ih =>
      intro h acc
      have hx : f x = g x := h x (by simp)
      have htail : ∀ k : Nat, k ∈ xs -> f k = g k := by
        intro k hk
        exact h k (by simp [hk])
      simp [hx]
      exact ih htail (acc * g x)

theorem foldl_mul_acc_le_of_forall_one_le
    (f : Nat -> Nat) :
    ∀ xs : List Nat,
      (∀ k : Nat, k ∈ xs -> 1 ≤ f k) ->
        ∀ acc : Nat, acc ≤ xs.foldl (fun acc k => acc * f k) acc := by
  intro xs
  induction xs with
  | nil =>
      intro _ acc
      simp
  | cons x xs ih =>
      intro h acc
      have hx : 1 ≤ f x := h x (by simp)
      have htail : ∀ k : Nat, k ∈ xs -> 1 ≤ f k := by
        intro k hk
        exact h k (by simp [hk])
      have hstep : acc ≤ acc * f x := by
        exact Nat.le_mul_of_pos_right acc (by omega)
      exact Nat.le_trans hstep (ih htail (acc * f x))

theorem foldl_mul_two_le_of_nonempty_forall_two_le
    (f : Nat -> Nat) :
    ∀ xs : List Nat,
      xs ≠ [] ->
        (∀ k : Nat, k ∈ xs -> 2 ≤ f k) ->
          2 ≤ xs.foldl (fun acc k => acc * f k) 1 := by
  intro xs
  cases xs with
  | nil =>
      intro hnil _h
      exact False.elim (hnil rfl)
  | cons x xs =>
      intro _ h
      have hx : 2 ≤ f x := h x (by simp)
      have htail_one : ∀ k : Nat, k ∈ xs -> 1 ≤ f k := by
        intro k hk
        have hk2 : 2 ≤ f k := h k (by simp [hk])
        omega
      have hmono :=
        foldl_mul_acc_le_of_forall_one_le f xs htail_one (1 * f x)
      have hmono' : f x ≤ xs.foldl (fun acc k => acc * f k) (f x) := by
        simpa using hmono
      simpa [Nat.one_mul] using Nat.le_trans hx hmono'

theorem foldl_mul_acc_eq
    (f : Nat -> Nat) :
    ∀ xs : List Nat, ∀ acc : Nat,
      xs.foldl (fun acc k => acc * f k) acc =
        acc * xs.foldl (fun acc k => acc * f k) 1 := by
  intro xs
  induction xs with
  | nil =>
      intro acc
      simp
  | cons x xs ih =>
      intro acc
      calc
        List.foldl (fun acc k => acc * f k) (acc * f x) xs
            = (acc * f x) * List.foldl (fun acc k => acc * f k) 1 xs := ih (acc * f x)
        _ = acc * (f x * List.foldl (fun acc k => acc * f k) 1 xs) := by
            simp [Nat.mul_assoc]
        _ = acc *
              List.foldl (fun acc k => acc * f k) (1 * f x) xs := by
            rw [ih (1 * f x)]
            simp

theorem foldl_mul_pow_lower_of_forall_two_le
    (f : Nat -> Nat) :
    ∀ xs : List Nat,
      (∀ k : Nat, k ∈ xs -> 2 ≤ f k) ->
        2 ^ xs.length ≤ xs.foldl (fun acc k => acc * f k) 1 := by
  intro xs
  induction xs with
  | nil =>
      intro _h
      simp
  | cons x xs ih =>
      intro h
      have hx : 2 ≤ f x := h x (by simp)
      have htail : ∀ k : Nat, k ∈ xs -> 2 ≤ f k := by
        intro k hk
        exact h k (by simp [hk])
      have hprod_tail :
          2 ^ xs.length ≤ xs.foldl (fun acc k => acc * f k) 1 :=
        ih htail
      have hmul :
          2 ^ (xs.length + 1) ≤
            f x * xs.foldl (fun acc k => acc * f k) 1 := by
        rw [Nat.pow_succ']
        exact Nat.mul_le_mul hx hprod_tail
      have hfold :
          xs.foldl (fun acc k => acc * f k) (f x) =
            f x * xs.foldl (fun acc k => acc * f k) 1 :=
        foldl_mul_acc_eq f xs (f x)
      change 2 ^ (xs.length + 1) ≤
        xs.foldl (fun acc k => acc * f k) (1 * f x)
      rw [Nat.one_mul]
      rw [hfold]
      exact hmul

theorem foldl_mul_pow_upper_of_forall_le
    (f : Nat -> Nat) (B : Nat) :
    ∀ xs : List Nat,
      (∀ k : Nat, k ∈ xs -> f k ≤ B) ->
        xs.foldl (fun acc k => acc * f k) 1 ≤ B ^ xs.length := by
  intro xs
  induction xs with
  | nil =>
      intro _h
      simp
  | cons x xs ih =>
      intro h
      have hx : f x ≤ B := h x (by simp)
      have htail : ∀ k : Nat, k ∈ xs -> f k ≤ B := by
        intro k hk
        exact h k (by simp [hk])
      have hprod_tail :
          xs.foldl (fun acc k => acc * f k) 1 ≤ B ^ xs.length :=
        ih htail
      have hmul :
          f x * xs.foldl (fun acc k => acc * f k) 1 ≤
            B * B ^ xs.length :=
        Nat.mul_le_mul hx hprod_tail
      have hpow : B * B ^ xs.length = B ^ (xs.length + 1) := by
        rw [Nat.pow_succ']
      have hfold :
          xs.foldl (fun acc k => acc * f k) (f x) =
            f x * xs.foldl (fun acc k => acc * f k) 1 :=
        foldl_mul_acc_eq f xs (f x)
      change xs.foldl (fun acc k => acc * f k) (1 * f x) ≤ B ^ (xs.length + 1)
      rw [Nat.one_mul]
      rw [hfold, ← hpow]
      exact hmul

theorem finiteBlockProduct_append_left
    {xs ys : List Nat} {u v : Nat}
    (hv : v < xs.length) :
    finiteBlockProduct (xs ++ ys) u v = finiteBlockProduct xs u v := by
  unfold finiteBlockProduct
  apply foldl_mul_eq_of_forall_mem
  intro k hk
  have hklt : k < v + 1 - u := by
    simpa using (List.mem_range.mp hk)
  have hidx : u + k < xs.length := by
    omega
  exact getD_append_left (ys := ys) (fallback := 1) hidx

theorem finiteBlockProduct_eq_blockProduct_of_prefixEnumerates
    {xs : List Nat} {d : Nat -> Nat} {u v : Nat}
    (henum : ∀ i : Nat, i < xs.length -> xs.getD i 1 = d i)
    (huv : u ≤ v)
    (hv : v < xs.length) :
    finiteBlockProduct xs u v = blockProduct d u v := by
  apply foldl_mul_eq_of_forall_mem
  intro k hk
  have hklt : k < v + 1 - u := by
    simpa using (List.mem_range.mp hk)
  have hidx : u + k < xs.length := by
    omega
  exact henum (u + k) hidx

theorem finiteBlockProduct_two_le_of_nonempty_entries_two_le
    {xs : List Nat} {u v : Nat}
    (hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1)
    (huv : u ≤ v)
    (hv : v < xs.length) :
    2 ≤ finiteBlockProduct xs u v := by
  unfold finiteBlockProduct
  apply foldl_mul_two_le_of_nonempty_forall_two_le
  · intro hnil
    have hlen_zero : (List.range (v + 1 - u)).length = 0 := by
      rw [hnil]
      simp
    simp at hlen_zero
    omega
  · intro k hk
    have hklt : k < v + 1 - u := by
      simpa using (List.mem_range.mp hk)
    have hidx : u + k < xs.length := by omega
    exact hentries (u + k) hidx

theorem finiteBlockProduct_pow_lower_of_range_two_le
    {xs : List Nat} {u v : Nat}
    (hentries : ∀ i : Nat, u ≤ i -> i ≤ v -> 2 ≤ xs.getD i 1) :
    2 ^ (v + 1 - u) ≤ finiteBlockProduct xs u v := by
  unfold finiteBlockProduct
  have h :=
    foldl_mul_pow_lower_of_forall_two_le
      (fun k => xs.getD (u + k) 1) (List.range (v + 1 - u)) (by
        intro k hk
        have hklt : k < v + 1 - u := by
          simpa using (List.mem_range.mp hk)
        exact hentries (u + k) (Nat.le_add_right u k) (by omega))
  simpa using h

theorem finiteBlockProduct_pow_upper_of_range_le
    {xs : List Nat} {u v B : Nat}
    (hentries : ∀ i : Nat, u ≤ i -> i ≤ v -> xs.getD i 1 ≤ B) :
    finiteBlockProduct xs u v ≤ B ^ (v + 1 - u) := by
  unfold finiteBlockProduct
  have h :=
    foldl_mul_pow_upper_of_forall_le
      (fun k => xs.getD (u + k) 1) B (List.range (v + 1 - u)) (by
        intro k hk
        have hklt : k < v + 1 - u := by
          simpa using (List.mem_range.mp hk)
        exact hentries (u + k) (Nat.le_add_right u k) (by omega))
  simpa using h

def productRange (f : Nat -> Nat) (L : Nat) : Nat :=
  (List.range L).foldl (fun acc k => acc * f k) 1

theorem productRange_succ
    (f : Nat -> Nat) (L : Nat) :
    productRange f (L + 1) = productRange f L * f L := by
  unfold productRange
  rw [List.range_succ, List.foldl_append]
  simp

theorem productRange_add_shift
    (f : Nat -> Nat) :
    ∀ L R : Nat,
      productRange f (L + R) =
        productRange f L * productRange (fun k => f (L + k)) R := by
  intro L R
  induction R with
  | zero =>
      simp [productRange]
  | succ R ih =>
      rw [Nat.add_succ, productRange_succ, ih, productRange_succ]
      simp [Nat.mul_assoc]

theorem finiteBlockProduct_split
    (xs : List Nat) (a b w : Nat) (hab : a ≤ b) (hbw : b < w) :
    finiteBlockProduct xs a w =
      finiteBlockProduct xs a b * finiteBlockProduct xs (b + 1) w := by
  unfold finiteBlockProduct
  have hlen : w + 1 - a = (b + 1 - a) + (w + 1 - (b + 1)) := by
    omega
  rw [hlen]
  change
    productRange (fun k => xs.getD (a + k) 1)
        ((b + 1 - a) + (w + 1 - (b + 1))) =
      productRange (fun k => xs.getD (a + k) 1) (b + 1 - a) *
        productRange (fun k => xs.getD (b + 1 + k) 1)
          (w + 1 - (b + 1))
  rw [productRange_add_shift (fun k => xs.getD (a + k) 1)]
  rw [show
      (fun k => xs.getD (a + (b + 1 - a + k)) 1) =
        (fun k => xs.getD (b + 1 + k) 1) by
    funext k
    have hidx : a + (b + 1 - a + k) = b + 1 + k := by omega
    rw [hidx]]

theorem finiteBlockProduct_first_two_le
    {xs : List Nat} {u v A B : Nat}
    (htwo : u + 1 ≤ v)
    (hpos : ∀ i : Nat, 0 < xs.getD i 1)
    (hA : A ≤ xs.getD u 1)
    (hB : B ≤ xs.getD (u + 1) 1) :
    A * B ≤ finiteBlockProduct xs u v := by
  have hfirst :
      finiteBlockProduct xs u (u + 1) =
        xs.getD u 1 * xs.getD (u + 1) 1 := by
    have hrange : List.range (u + 1 + 1 - u) = [0, 1] := by
      rw [show u + 1 + 1 - u = 2 by omega]
      decide
    simp [finiteBlockProduct, hrange]
  have hfirst_le :
      A * B ≤ finiteBlockProduct xs u (u + 1) := by
    rw [hfirst]
    exact Nat.mul_le_mul hA hB
  by_cases hlast : v = u + 1
  · simpa [hlast] using hfirst_le
  have hsplit :=
    finiteBlockProduct_split xs u (u + 1) v (by omega) (by omega)
  have hsuffix_one : 1 ≤ finiteBlockProduct xs (u + 2) v := by
    have hpos :
        0 < finiteBlockProduct xs (u + 2) v := by
      exact finiteBlockProduct_pos_of_entries_pos hpos
    omega
  rw [hsplit]
  calc
    A * B = A * B * 1 := by simp
    _ ≤ finiteBlockProduct xs u (u + 1) *
          finiteBlockProduct xs (u + 1 + 1) v :=
        Nat.mul_le_mul hfirst_le hsuffix_one

theorem finiteBlockProduct_length_length (xs : List Nat) :
    finiteBlockProduct xs xs.length xs.length = 1 := by
  simp [finiteBlockProduct, List.getD]

theorem finiteBlockProduct_split_before
    (xs : List Nat) {a b w : Nat} (ha : a < b) (hbw : b ≤ w) :
    finiteBlockProduct xs a w =
      finiteBlockProduct xs a (b - 1) * finiteBlockProduct xs b w := by
  have hab : a ≤ b - 1 := by omega
  have hbw' : b - 1 < w := by omega
  have hsucc : b - 1 + 1 = b := by omega
  simpa [hsucc] using finiteBlockProduct_split xs a (b - 1) w hab hbw'

theorem finiteBlockProduct_pos_of_entries_two_le_with_default
    {xs : List Nat} {u v : Nat}
    (hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1) :
    0 < finiteBlockProduct xs u v := by
  apply finiteBlockProduct_pos_of_entries_pos
  intro i
  by_cases hi : i < xs.length
  · have htwo := hentries i hi
    omega
  · simp [List.getD, hi]

theorem productRange_pos_of_forall_pos
    (f : Nat -> Nat) :
    ∀ L : Nat, (∀ i : Nat, i < L -> 0 < f i) -> 0 < productRange f L := by
  intro L
  induction L with
  | zero =>
      intro _h
      simp [productRange]
  | succ L ih =>
      intro h
      rw [productRange_succ]
      exact Nat.mul_pos (ih (by intro i hi; exact h i (by omega))) (h L (by omega))

theorem productRange_le_productRange_of_forall_le
    (f g : Nat -> Nat) :
    ∀ L : Nat,
      (∀ i : Nat, i < L -> f i ≤ g i) ->
        productRange f L ≤ productRange g L := by
  intro L
  induction L with
  | zero =>
      intro _h
      simp [productRange]
  | succ L ih =>
      intro h
      rw [productRange_succ, productRange_succ]
      exact Nat.mul_le_mul
        (ih (by intro i hi; exact h i (by omega)))
        (h L (by omega))

theorem productRange_lt_terminal_mul_of_length_le
    (f g : Nat -> Nat) (n : Nat) :
    ∀ L R : Nat,
      1 < n ->
      L ≤ R + 1 ->
      (∀ i : Nat, i < L -> f i < n) ->
      (∀ i j : Nat, i < L -> j < R -> f i < g j) ->
      (∀ j : Nat, j < R -> 0 < g j) ->
        productRange f L < n * productRange g R := by
  intro L
  induction L with
  | zero =>
      intro R hn _hlen _hfn _hfg hgpos
      have hgprod_pos : 0 < productRange g R :=
        productRange_pos_of_forall_pos g R hgpos
      have hmul : n ≤ n * productRange g R :=
        Nat.le_mul_of_pos_right n hgprod_pos
      have hgoal : 1 < n * productRange g R :=
        Nat.lt_of_lt_of_le hn hmul
      simpa [productRange] using hgoal
  | succ L ih =>
      intro R hn hlen hfn hfg hgpos
      rw [productRange_succ]
      by_cases hLR : L < R
      · rcases R with _ | R'
        · omega
        have hprefix :
            productRange f L < n * productRange g R' :=
          ih R' hn (by omega)
            (by intro i hi; exact hfn i (by omega))
            (by
              intro i j hi hj
              exact hfg i j (by omega) (by omega))
            (by intro j hj; exact hgpos j (by omega))
        have hlast : f L < g R' :=
          hfg L R' (by omega) (by omega)
        have hmul :
            productRange f L * f L <
              (n * productRange g R') * g R' :=
          Nat.mul_lt_mul'' hprefix hlast
        have htarget :
            (n * productRange g R') * g R' =
              n * productRange g (R' + 1) := by
          rw [productRange_succ]
          simp [Nat.mul_assoc]
        rw [← htarget]
        exact hmul
      · have hLR_eq : L = R := by omega
        subst R
        have hprefix_le :
            productRange f L ≤ productRange g L :=
          productRange_le_productRange_of_forall_le f g L (by
            intro i hi
            exact Nat.le_of_lt (hfg i i (by omega) (by omega)))
        have hlast : f L < n := hfn L (by omega)
        have hgprod_pos : 0 < productRange g L :=
          productRange_pos_of_forall_pos g L hgpos
        have hright_lt :
            productRange g L * f L < productRange g L * n :=
          Nat.mul_lt_mul_of_pos_left hlast hgprod_pos
        have hleft_le :
            productRange f L * f L ≤ productRange g L * f L :=
          Nat.mul_le_mul hprefix_le (Nat.le_refl _)
        have hstrict :
            productRange f L * f L < productRange g L * n :=
          Nat.lt_of_le_of_lt hleft_le hright_lt
        simpa [Nat.mul_comm] using hstrict

theorem finiteBlockProduct_lt_terminal_mul_of_length_le
    {xs : List Nat} {u v c m n : Nat}
    (hold : u ≤ v)
    (hsuffix : c ≤ m)
    (hlen : v - u + 1 ≤ m - c + 1 + 1)
    (hold_two : ∀ i : Nat, u ≤ i -> i ≤ v -> 2 ≤ xs.getD i 1)
    (hendpoint : ∀ i : Nat, u ≤ i -> i ≤ v -> xs.getD i 1 < n)
    (hsuffix_larger :
      ∀ i j : Nat, u ≤ i -> i ≤ v -> c ≤ j -> j ≤ m ->
        xs.getD i 1 < xs.getD j 1) :
    finiteBlockProduct xs u v < n * finiteBlockProduct xs c m := by
  have hcompare :=
    productRange_lt_terminal_mul_of_length_le
      (fun k => xs.getD (u + k) 1)
      (fun k => xs.getD (c + k) 1)
      n
      (v + 1 - u)
      (m + 1 - c)
      (by
        have hu_two : 2 ≤ xs.getD u 1 :=
          hold_two u (by omega) (by omega)
        have hu_lt : xs.getD u 1 < n :=
          hendpoint u (by omega) (by omega)
        omega)
      (by omega)
      (by
        intro i hi
        exact hendpoint (u + i) (by omega) (by omega))
      (by
        intro i j hi hj
        exact hsuffix_larger (u + i) (c + j)
          (by omega) (by omega) (by omega) (by omega))
      (by
        intro j hj
        have holdfactor :
            xs.getD u 1 < xs.getD (c + j) 1 :=
          hsuffix_larger u (c + j) (by omega) (by omega) (by omega) (by omega)
        have hu_two : 2 ≤ xs.getD u 1 :=
          hold_two u (by omega) (by omega)
        exact Nat.lt_trans (by omega : 0 < xs.getD u 1) holdfactor)
  simpa [finiteBlockProduct, productRange] using hcompare

/--
The remaining selected-barrier collision content after finite scan
bookkeeping.  Old-old collisions are already implied by the greedy invariant,
and the lower scan bound follows from the semiprime arithmetic interface.
-/
structure PrivateBarrierSelectedCollisionRemainder (pkg : PrivateBarrierDeletionSet) where
  old_new_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u v u' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u v ≠
          finiteBlockProduct (xs ++ [b]) u' xs.length
  new_old_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' v' : Nat,
        u ≤ xs.length ->
        u' ≤ v' ->
        v' < xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length ≠
          finiteBlockProduct (xs ++ [b]) u' v'
  new_new_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        u = u'

/--
Oriented selected-barrier collision remainder.  The `new_old` case is not a
separate mathematical assumption: it is the equality-symmetric form of the
`old_new` private-label exclusion.
-/
structure PrivateBarrierSelectedCollisionOrientedRemainder
    (pkg : PrivateBarrierDeletionSet) where
  old_new_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u v u' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u v ≠
          finiteBlockProduct (xs ++ [b]) u' xs.length
  new_new_collision_free :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
          finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        u = u'

/--
Old-new selected-barrier sub-obligation below the collision statement itself.
For the selected private label of `b`, old products before `b` are not
divisible by the label, while every product ending at the newly appended `b`
is divisible by it.
-/
structure PrivateBarrierSelectedOldNewDivisibilityObstruction
    (pkg : PrivateBarrierDeletionSet) where
  old_product_not_private_divisible :
    ∀ b : Nat, pkg.selectedBarrier b ->
      ∀ label : PrivateBarrierLabel, pkg.selectedLabel b = some label ->
        let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
        ∀ u v : Nat,
          u ≤ v ->
          v < xs.length ->
          ¬ label.privateLabel ∣ finiteBlockProduct (xs ++ [b]) u v
  new_product_private_divisible :
    ∀ b : Nat, pkg.selectedBarrier b ->
      ∀ label : PrivateBarrierLabel, pkg.selectedLabel b = some label ->
        let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
        ∀ u' : Nat,
          u' ≤ xs.length ->
          label.privateLabel ∣ finiteBlockProduct (xs ++ [b]) u' xs.length

/--
Narrow remaining old-product half of the selected private-label obstruction.
The new-product half is just terminal-factor arithmetic, so this field isolates
the deletion/product content still external to Lean.
-/
structure PrivateBarrierSelectedOldProductNotPrivateDivisible
    (pkg : PrivateBarrierDeletionSet) where
  old_product_not_private_divisible :
    ∀ b : Nat, pkg.selectedBarrier b ->
      ∀ label : PrivateBarrierLabel, pkg.selectedLabel b = some label ->
        let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
        ∀ u v : Nat,
          u ≤ v ->
          v < xs.length ->
          ¬ label.privateLabel ∣ finiteBlockProduct (xs ++ [b]) u v

/--
Narrow arithmetic interface for the only product-theoretic step still outside
this no-Mathlib Lean file.  It says that if the selected private prime divides
an old accepted finite block product, then it divides one factor of that old
block.  The deletion/horizon contradiction is proved below from the existing
private-barrier arithmetic fields.
-/
structure PrivateBarrierSelectedOldProductFactorDivisor
    (pkg : PrivateBarrierDeletionSet) where
  old_product_private_divisor_has_factor :
    ∀ b : Nat, pkg.selectedBarrier b ->
      ∀ label : PrivateBarrierLabel, pkg.selectedLabel b = some label ->
        let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
        ∀ u v : Nat,
          u ≤ v ->
          v < xs.length ->
          label.privateLabel ∣ finiteBlockProduct (xs ++ [b]) u v ->
            ∃ i : Nat,
              u ≤ i ∧ i ≤ v ∧
                label.privateLabel ∣ (xs ++ [b]).getD i 1

theorem privateBarrierSelectedOldProductFactorDivisor_fromPrimeLike
    (pkg : PrivateBarrierDeletionSet)
    (harith : PrivateBarrierArithmetic pkg) :
    PrivateBarrierSelectedOldProductFactorDivisor pkg := by
  refine
    { old_product_private_divisor_has_factor := ?_ }
  intro b hb label hlabel
  dsimp only
  intro u v huv _hv hprod_dvd
  rcases harith.selected_label_arithmetic b hb with
    ⟨label', hlabel', _hbarrier, _hfactor, _hsmall, hprivate, _hsmall_lt, _hhorizon⟩
  have hlabel_eq : label' = label := by
    rw [hlabel] at hlabel'
    injection hlabel' with h
    exact h.symm
  subst label'
  exact hprivate.dvd_finiteBlockProduct_factor
    (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) ++ [b])
    huv
    hprod_dvd

theorem privateBarrierSelectedOldProductNotPrivateDivisible_fromFactorDivisor
    (pkg : PrivateBarrierDeletionSet)
    (harith : PrivateBarrierArithmetic pkg)
    (hfactor : PrivateBarrierSelectedOldProductFactorDivisor pkg) :
    PrivateBarrierSelectedOldProductNotPrivateDivisible pkg := by
  refine
    { old_product_not_private_divisible := ?_ }
  intro b hb label hlabel
  dsimp only
  intro u v huv hv hprod_dvd
  let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
  rcases hfactor.old_product_private_divisor_has_factor
      b hb label hlabel u v huv hv hprod_dvd with
    ⟨i, hui, hiv, hi_dvd⟩
  have hi_lt_xs : i < xs.length := by
    have hv_xs : v < xs.length := by simpa [xs] using hv
    omega
  have hentry_append :
      (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) ++ [b]).getD i 1 =
        (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)).getD i 1 := by
    simpa [xs] using getD_append_left (ys := [b]) (fallback := 1) hi_lt_xs
  let n := (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)).getD i 1
  have hn_mem :
      n ∈ modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) := by
    simpa [n, xs] using getD_mem_of_lt hi_lt_xs
  have hi_dvd_old :
      label.privateLabel ∣
        (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)).getD i 1 := by
    rwa [hentry_append] at hi_dvd
  have hn_dvd : label.privateLabel ∣ n := by
    simpa [n] using hi_dvd_old
  rcases harith.selected_label_arithmetic b hb with
    ⟨label', hlabel', _hbarrier, hmul, hsmall, hprivate, hsmall_lt, hhorizon⟩
  have hlabel_eq : label' = label := by
    rw [hlabel] at hlabel'
    injection hlabel' with h
    exact h.symm
  subst label'
  have hb3 : 3 ≤ b := by
    have hsmall2 : 2 ≤ label.smallFactor := hsmall.1
    have hprivate2 : 2 ≤ label.privateLabel := hprivate.1
    have hprod4 : 4 ≤ label.smallFactor * label.privateLabel :=
      Nat.mul_le_mul hsmall2 hprivate2
    omega
  have hn_le_scan : n ≤ b - 3 + 2 := by
    simpa [xs, n] using
      modifiedGreedyAcceptedPrefixFromDeletion_mem_le_scan_bound
        pkg.Deleted (b - 3) n hn_mem
  have hn_lt_b : n < b := by omega
  have hn_le_horizon : n ≤ label.horizon := by omega
  have hn_ne_b : n ≠ b := by omega
  have hdeleted : pkg.Deleted n :=
    harith.horizon_deletes_earlier_nonbarrier_multiples
      b n label hb hlabel hn_lt_b hn_le_horizon hn_dvd hn_ne_b
  have hprivate_ge3 : 3 ≤ label.privateLabel := by
    have hsmall2 : 2 ≤ label.smallFactor := hsmall.1
    omega
  have hn_two : 2 ≤ n := by
    simpa [n] using
      modifiedGreedyAcceptedPrefixFromDeletion_mem_two_le
        pkg.Deleted (b - 3) n hn_mem
  have hn_ge3 : 3 ≤ n := by
    rcases hn_dvd with ⟨k, hk⟩
    cases k with
    | zero =>
        simp at hk
        omega
    | succ k =>
        have hmul_ge :
            label.privateLabel ≤ label.privateLabel * Nat.succ k :=
          Nat.le_mul_of_pos_right label.privateLabel (Nat.succ_pos k)
        rw [hk]
        exact Nat.le_trans hprivate_ge3 hmul_ge
  have hnot_deleted :
      ¬ pkg.Deleted n :=
    modifiedGreedyAcceptedPrefixFromDeletion_mem_not_deleted
      pkg.Deleted (b - 3) n hn_ge3 hn_mem
  exact hnot_deleted hdeleted

def privateBarrierFinalSuffixProduct (xs : List Nat) (u : Nat) : Nat :=
  if u < xs.length then finiteBlockProduct xs u (xs.length - 1) else 1

theorem privateBarrierFinalSuffixProduct_split_at
    (xs : List Nat) {a b : Nat} (ha : a ≤ b) (hb : b < xs.length) :
    privateBarrierFinalSuffixProduct xs a =
      finiteBlockProduct xs a b * privateBarrierFinalSuffixProduct xs (b + 1) := by
  have halt : a < xs.length := by omega
  by_cases hnext : b + 1 < xs.length
  · rw [privateBarrierFinalSuffixProduct, if_pos halt,
      privateBarrierFinalSuffixProduct, if_pos hnext]
    have hsplit :=
      finiteBlockProduct_split xs a b (xs.length - 1) ha (by omega)
    simpa using hsplit
  · have hb_last : b = xs.length - 1 := by omega
    rw [privateBarrierFinalSuffixProduct, if_pos halt,
      privateBarrierFinalSuffixProduct, if_neg hnext]
    rw [hb_last]
    simp

theorem privateBarrierFinalSuffixProduct_pos_of_entries_two_le_with_default
    {xs : List Nat} {u : Nat}
    (hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1) :
    0 < privateBarrierFinalSuffixProduct xs u := by
  unfold privateBarrierFinalSuffixProduct
  by_cases h : u < xs.length
  · rw [if_pos h]
    exact finiteBlockProduct_pos_of_entries_two_le_with_default hentries
  · rw [if_neg h]
    simp

theorem privateBarrierFinalSuffixProduct_injective_of_distinct
    {xs : List Nat}
    (hxs_distinct : FiniteDistinctConsecutiveBlockProducts xs)
    (hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1) :
    ∀ u u' : Nat,
      u ≤ xs.length ->
      u' ≤ xs.length ->
      privateBarrierFinalSuffixProduct xs u =
        privateBarrierFinalSuffixProduct xs u' ->
      u = u' := by
  intro u u' hu hu' hprod
  by_cases hult : u < xs.length
  · by_cases hu'lt : u' < xs.length
    · have hprod_fin :
          finiteBlockProduct xs u (xs.length - 1) =
            finiteBlockProduct xs u' (xs.length - 1) := by
        simpa [privateBarrierFinalSuffixProduct, hult, hu'lt] using hprod
      have huv : u ≤ xs.length - 1 := by omega
      have huv' : u' ≤ xs.length - 1 := by omega
      have hv : xs.length - 1 < xs.length := by omega
      exact (hxs_distinct u (xs.length - 1) u' (xs.length - 1)
        huv hv huv' hv hprod_fin).1
    · have hu'eq : u' = xs.length := by omega
      have hprod_fin :
          finiteBlockProduct xs u (xs.length - 1) = 1 := by
        simpa [privateBarrierFinalSuffixProduct, hult, hu'lt, hu'eq] using hprod
      have huv : u ≤ xs.length - 1 := by omega
      have hv : xs.length - 1 < xs.length := by omega
      have htwo :
          2 ≤ finiteBlockProduct xs u (xs.length - 1) :=
        finiteBlockProduct_two_le_of_nonempty_entries_two_le hentries huv hv
      omega
  · have hueq : u = xs.length := by omega
    by_cases hu'lt : u' < xs.length
    · have hprod_fin :
          1 = finiteBlockProduct xs u' (xs.length - 1) := by
        simpa [privateBarrierFinalSuffixProduct, hult, hueq, hu'lt] using hprod
      have huv' : u' ≤ xs.length - 1 := by omega
      have hv : xs.length - 1 < xs.length := by omega
      have htwo :
          2 ≤ finiteBlockProduct xs u' (xs.length - 1) :=
        finiteBlockProduct_two_le_of_nonempty_entries_two_le hentries huv' hv
      omega
    · have hu'eq : u' = xs.length := by omega
      exact hueq.trans hu'eq.symm

theorem oldNewCollision_overlap_cancelled_split
    {xs : List Nat} {n u v c : Nat}
    (hn : 2 ≤ n)
    (hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1)
    (huv : u ≤ v) (hv : v < xs.length) (hc : c ≤ xs.length)
    (hprod :
      finiteBlockProduct xs u v = n * privateBarrierFinalSuffixProduct xs c) :
    ∃ u' v' c' m' : Nat,
      u' ≤ v' ∧ c' ≤ m' ∧ v' < c' ∧
        finiteBlockProduct xs u' v' = n * finiteBlockProduct xs c' m' := by
  by_cases hvc : v < c
  · by_cases hclt : c < xs.length
    · refine ⟨u, v, c, xs.length - 1, huv, by omega, hvc, ?_⟩
      simpa [privateBarrierFinalSuffixProduct, hclt] using hprod
    · have hc_eq : c = xs.length := by omega
      refine ⟨u, v, xs.length, xs.length, huv, Nat.le_refl xs.length, by omega, ?_⟩
      have hsuffix : privateBarrierFinalSuffixProduct xs c = 1 := by
        simp [privateBarrierFinalSuffixProduct, hc_eq]
      rw [hsuffix] at hprod
      simpa [hc_eq, finiteBlockProduct_length_length] using hprod
  · have hcv : c ≤ v := by omega
    by_cases huc : u < c
    · have hleft_split :
          finiteBlockProduct xs u v =
            finiteBlockProduct xs u (c - 1) * finiteBlockProduct xs c v :=
        finiteBlockProduct_split_before xs huc hcv
      have hsuffix_split :
          privateBarrierFinalSuffixProduct xs c =
            finiteBlockProduct xs c v * privateBarrierFinalSuffixProduct xs (v + 1) :=
        privateBarrierFinalSuffixProduct_split_at xs hcv hv
      have hoverlap_pos :
          0 < finiteBlockProduct xs c v :=
        finiteBlockProduct_pos_of_entries_two_le_with_default hentries
      have hcancel :
          finiteBlockProduct xs u (c - 1) =
            n * privateBarrierFinalSuffixProduct xs (v + 1) := by
        rw [hleft_split, hsuffix_split] at hprod
        have hprod' :
            finiteBlockProduct xs u (c - 1) * finiteBlockProduct xs c v =
              (n * privateBarrierFinalSuffixProduct xs (v + 1)) *
                finiteBlockProduct xs c v := by
          simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using hprod
        exact Nat.eq_of_mul_eq_mul_right hoverlap_pos hprod'
      by_cases htail : v + 1 < xs.length
      · refine ⟨u, c - 1, v + 1, xs.length - 1, by omega, by omega, by omega, ?_⟩
        simpa [privateBarrierFinalSuffixProduct, htail] using hcancel
      · have hv_last : v + 1 = xs.length := by omega
        refine ⟨u, c - 1, xs.length, xs.length, by omega, Nat.le_refl xs.length, by omega, ?_⟩
        have hsuffix : privateBarrierFinalSuffixProduct xs (v + 1) = 1 := by
          simp [privateBarrierFinalSuffixProduct, hv_last]
        rw [hsuffix] at hcancel
        simpa [hv_last, finiteBlockProduct_length_length] using hcancel
    · have hcu : c ≤ u := by omega
      have hleft_pos :
          0 < finiteBlockProduct xs u v :=
        finiteBlockProduct_pos_of_entries_two_le_with_default hentries
      have hsuffix_split_v :
          privateBarrierFinalSuffixProduct xs c =
            finiteBlockProduct xs c v * privateBarrierFinalSuffixProduct xs (v + 1) :=
        privateBarrierFinalSuffixProduct_split_at xs hcv hv
      have hcontr : False := by
        by_cases hcu_strict : c < u
        · have hprefix_split :
              finiteBlockProduct xs c v =
                finiteBlockProduct xs c (u - 1) * finiteBlockProduct xs u v :=
            finiteBlockProduct_split_before xs hcu_strict huv
          rw [hsuffix_split_v, hprefix_split] at hprod
          have hcancel :
              1 =
                n *
                  (finiteBlockProduct xs c (u - 1) *
                    privateBarrierFinalSuffixProduct xs (v + 1)) := by
            have hprod' :
                finiteBlockProduct xs u v =
                  (n *
                    (finiteBlockProduct xs c (u - 1) *
                      privateBarrierFinalSuffixProduct xs (v + 1))) *
                    finiteBlockProduct xs u v := by
              simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using hprod
            have hprod'' :
                1 * finiteBlockProduct xs u v =
                  (n *
                    (finiteBlockProduct xs c (u - 1) *
                      privateBarrierFinalSuffixProduct xs (v + 1))) *
                    finiteBlockProduct xs u v := by
              simpa using hprod'
            have hcancel' := Nat.eq_of_mul_eq_mul_right hleft_pos hprod''
            simpa using hcancel'
          have hrhs_ge : 2 ≤
              n *
                (finiteBlockProduct xs c (u - 1) *
                  privateBarrierFinalSuffixProduct xs (v + 1)) := by
            have hfactor_pos :
                0 <
                  finiteBlockProduct xs c (u - 1) *
                    privateBarrierFinalSuffixProduct xs (v + 1) :=
              Nat.mul_pos
                (finiteBlockProduct_pos_of_entries_two_le_with_default hentries)
                (privateBarrierFinalSuffixProduct_pos_of_entries_two_le_with_default hentries)
            have hfactor_ge : 1 ≤
                finiteBlockProduct xs c (u - 1) *
                  privateBarrierFinalSuffixProduct xs (v + 1) := by
              omega
            calc
              2 ≤ n := hn
              _ = n * 1 := by rw [Nat.mul_one]
              _ ≤ n *
                  (finiteBlockProduct xs c (u - 1) *
                    privateBarrierFinalSuffixProduct xs (v + 1)) :=
                Nat.mul_le_mul_left n hfactor_ge
          omega
        · have hcu_eq : c = u := by omega
          rw [hcu_eq] at hsuffix_split_v hprod
          rw [hsuffix_split_v] at hprod
          have hcancel :
              1 = n * privateBarrierFinalSuffixProduct xs (v + 1) := by
            have hprod' :
                finiteBlockProduct xs u v =
                  (n * privateBarrierFinalSuffixProduct xs (v + 1)) *
                    finiteBlockProduct xs u v := by
              simpa [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using hprod
            have hprod'' :
                1 * finiteBlockProduct xs u v =
                  (n * privateBarrierFinalSuffixProduct xs (v + 1)) *
                    finiteBlockProduct xs u v := by
              simpa using hprod'
            have hcancel' := Nat.eq_of_mul_eq_mul_right hleft_pos hprod''
            simpa using hcancel'
          have hsuffix_pos : 0 < privateBarrierFinalSuffixProduct xs (v + 1) := by
            exact privateBarrierFinalSuffixProduct_pos_of_entries_two_le_with_default hentries
          have hrhs_ge : 2 ≤ n * privateBarrierFinalSuffixProduct xs (v + 1) :=
            calc
              2 ≤ n := hn
              _ = n * 1 := by rw [Nat.mul_one]
              _ ≤ n * privateBarrierFinalSuffixProduct xs (v + 1) :=
                Nat.mul_le_mul_left n (by omega)
          omega
      exact False.elim hcontr

theorem finiteBlockProduct_append_terminal
    (xs : List Nat) (b u : Nat) (hu : u ≤ xs.length) :
    finiteBlockProduct (xs ++ [b]) u xs.length =
      privateBarrierFinalSuffixProduct xs u * b := by
  classical
  unfold privateBarrierFinalSuffixProduct finiteBlockProduct
  by_cases hult : u < xs.length
  · have hlen :
        xs.length + 1 - u = (xs.length - u) + 1 := by omega
    rw [hlen, List.range_succ, List.foldl_append]
    simp only [List.foldl_cons, List.foldl_nil]
    have hidx : u + (xs.length - u) = xs.length := by omega
    have hleft :
        (List.range (xs.length - u)).foldl
            (fun acc k => acc * (xs ++ [b]).getD (u + k) 1) 1 =
          (List.range (xs.length - u)).foldl
            (fun acc k => acc * xs.getD (u + k) 1) 1 := by
      apply foldl_mul_eq_of_forall_mem
      intro k hk
      have hklt : k < xs.length - u := by
        simpa using (List.mem_range.mp hk)
      have hidxlt : u + k < xs.length := by omega
      exact getD_append_left (ys := [b]) (fallback := 1) hidxlt
    rw [hleft, hidx, getD_append_singleton_length]
    have hsuffix_len : xs.length - 1 + 1 - u = xs.length - u := by omega
    rw [if_pos hult, hsuffix_len]
  · have hueq : u = xs.length := by omega
    subst u
    simp

theorem privateBarrierSelectedTerminalFactorCancellation
    (pkg : PrivateBarrierDeletionSet)
    (harith : PrivateBarrierArithmetic pkg) :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        privateBarrierFinalSuffixProduct xs u =
          privateBarrierFinalSuffixProduct xs u' := by
  intro b hb
  dsimp only
  intro u u' hu hu' hprod
  rcases harith.selected_label_arithmetic b hb with
    ⟨label, _hlabel, _hbarrier, hfactor, hsmall, hprivate, _hsmall_lt, _hhorizon⟩
  have hbpos : 0 < b := by
    have hsmall2 : 2 ≤ label.smallFactor := hsmall.1
    have hprivate2 : 2 ≤ label.privateLabel := hprivate.1
    have hmulpos : 0 < label.smallFactor * label.privateLabel :=
      Nat.mul_pos (by omega) (by omega)
    rwa [hfactor] at hmulpos
  rw [finiteBlockProduct_append_terminal _ b u hu,
    finiteBlockProduct_append_terminal _ b u' hu'] at hprod
  exact Nat.eq_of_mul_eq_mul_right hbpos hprod

theorem privateBarrierSelectedOldNewDivisibilityObstruction_fromOldProduct
    (pkg : PrivateBarrierDeletionSet)
    (harith : PrivateBarrierArithmetic pkg)
    (hold : PrivateBarrierSelectedOldProductNotPrivateDivisible pkg) :
    PrivateBarrierSelectedOldNewDivisibilityObstruction pkg := by
  refine
    { old_product_not_private_divisible :=
        hold.old_product_not_private_divisible
      new_product_private_divisible := ?_ }
  intro b hb label hlabel
  dsimp only
  intro u hu
  rcases harith.selected_label_arithmetic b hb with
    ⟨label', hlabel', _hbarrier, hfactor, _hsmall, _hprivate, _hlt, _hhorizon⟩
  have hlabel_eq : label' = label := by
    rw [hlabel] at hlabel'
    injection hlabel' with h
    exact h.symm
  subst label'
  have hterminal :
      finiteBlockProduct
          (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) ++ [b])
          u
          (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)).length =
        privateBarrierFinalSuffixProduct
          (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)) u * b :=
    finiteBlockProduct_append_terminal
      (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)) b u hu
  rw [hterminal, ← hfactor]
  refine
    ⟨privateBarrierFinalSuffixProduct
        (modifiedGreedyAcceptedPrefixFromDeletion
          pkg.Deleted (label.smallFactor * label.privateLabel - 3)) u *
      label.smallFactor, ?_⟩
  simp [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm]

/--
New-new selected-barrier sub-obligation below the collision statement itself:
equal products ending at the appended barrier cancel the common terminal factor,
and final suffix products of the old prefix determine their start index.
-/
structure PrivateBarrierSelectedFinalSuffixCancellation
    (pkg : PrivateBarrierDeletionSet) where
  terminal_factor_cancellation :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        privateBarrierFinalSuffixProduct xs u =
          privateBarrierFinalSuffixProduct xs u'
  final_suffix_product_injective :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        privateBarrierFinalSuffixProduct xs u =
          privateBarrierFinalSuffixProduct xs u' ->
        u = u'

theorem privateBarrierSelectedOldNewCollisionFree_fromDivisibilityObstruction
    (pkg : PrivateBarrierDeletionSet)
    (hdiv : PrivateBarrierSelectedOldNewDivisibilityObstruction pkg) :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u v u' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u v ≠
          finiteBlockProduct (xs ++ [b]) u' xs.length := by
  intro b hb
  dsimp only
  intro u v u' huv hv hu' hprod
  rcases pkg.selected_has_label b hb with ⟨label, hlabel, _hbarrier⟩
  have hnot :=
    hdiv.old_product_not_private_divisible b hb label hlabel u v huv hv
  have hdvd :
      label.privateLabel ∣ finiteBlockProduct
        (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3) ++ [b])
        u' (modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)).length :=
    hdiv.new_product_private_divisible b hb label hlabel u' hu'
  exact hnot (by
    rw [hprod]
    exact hdvd)

theorem privateBarrierSelectedNewNewCollisionFree_fromFinalSuffixCancellation
    (pkg : PrivateBarrierDeletionSet)
    (hcancel : PrivateBarrierSelectedFinalSuffixCancellation pkg) :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        u = u' := by
  intro b hb
  dsimp only
  intro u u' hu hu' hprod
  have hsuffix :=
    hcancel.terminal_factor_cancellation b hb u u' hu hu' hprod
  exact hcancel.final_suffix_product_injective b hb u u' hu hu' hsuffix

theorem privateBarrierSelectedNewOldCollisionFree_fromOldNew
    (pkg : PrivateBarrierDeletionSet)
    (horiented : PrivateBarrierSelectedCollisionOrientedRemainder pkg) :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u u' v' : Nat,
        u ≤ xs.length ->
        u' ≤ v' ->
        v' < xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length ≠
          finiteBlockProduct (xs ++ [b]) u' v' := by
  intro b hb
  dsimp only
  intro u u' v' hu huv' hv' hprod
  exact horiented.old_new_collision_free b hb u' v' u huv' hv' hu hprod.symm

theorem privateBarrierSelectedCollisionRemainder_fromOriented
    (pkg : PrivateBarrierDeletionSet)
    (horiented : PrivateBarrierSelectedCollisionOrientedRemainder pkg) :
    PrivateBarrierSelectedCollisionRemainder pkg :=
  { old_new_collision_free := horiented.old_new_collision_free
    new_old_collision_free :=
      privateBarrierSelectedNewOldCollisionFree_fromOldNew pkg horiented
    new_new_collision_free := horiented.new_new_collision_free }

theorem privateBarrierSelectedScanLower_fromArithmetic
    (pkg : PrivateBarrierDeletionSet)
    (harith : PrivateBarrierArithmetic pkg) :
    ∀ b : Nat, pkg.selectedBarrier b -> 3 ≤ b := by
  intro b hb
  rcases harith.selected_label_arithmetic b hb with
    ⟨label, _hlabel, hbarrier, hmul, hsmall, hprivate, _hlt, _hhorizon⟩
  have hsmall2 : 2 ≤ label.smallFactor := hsmall.1
  have hprivate2 : 2 ≤ label.privateLabel := hprivate.1
  have hprod : 4 ≤ label.smallFactor * label.privateLabel :=
    Nat.mul_le_mul hsmall2 hprivate2
  omega

theorem privateBarrierSelectedOldOldCollisionFree
    (pkg : PrivateBarrierDeletionSet) :
    ∀ b : Nat, pkg.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
      ∀ u v u' v' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ v' ->
        v' < xs.length ->
        finiteBlockProduct (xs ++ [b]) u v =
          finiteBlockProduct (xs ++ [b]) u' v' ->
        u = u' ∧ v = v' := by
  intro b _hb
  dsimp only
  let xs := modifiedGreedyAcceptedPrefixFromDeletion pkg.Deleted (b - 3)
  intro u v u' v' huv hv huv' hv' hprod
  have hxs : FiniteDistinctConsecutiveBlockProducts xs :=
    modifiedGreedyUniqueness xs
      (by
        simpa [xs] using
          modifiedGreedyAcceptedPrefixFromDeletion_greedy pkg.Deleted (b - 3))
  have hleft :
      finiteBlockProduct (xs ++ [b]) u v = finiteBlockProduct xs u v :=
    finiteBlockProduct_append_left (ys := [b]) hv
  have hright :
      finiteBlockProduct (xs ++ [b]) u' v' = finiteBlockProduct xs u' v' :=
    finiteBlockProduct_append_left (ys := [b]) hv'
  have hprod_xs : finiteBlockProduct xs u v = finiteBlockProduct xs u' v' := by
    rw [← hleft, ← hright]
    exact hprod
  exact hxs u v u' v' huv hv huv' hv'
    hprod_xs

theorem privateBarrierSelectedCollisionFragments_fromRemainder
    (pkg : PrivateBarrierDeletionSet)
    (harith : PrivateBarrierArithmetic pkg)
    (hremainder : PrivateBarrierSelectedCollisionRemainder pkg) :
    PrivateBarrierSelectedCollisionFragments pkg :=
  { selected_scan_lower := privateBarrierSelectedScanLower_fromArithmetic pkg harith
    old_old_collision_free := privateBarrierSelectedOldOldCollisionFree pkg
    old_new_collision_free := hremainder.old_new_collision_free
    new_old_collision_free := hremainder.new_old_collision_free
    new_new_collision_free := hremainder.new_new_collision_free }

/--
Cofinality bridge from the finite recurrence to the externally named
enumeration.  This is narrower than positivity or strictness of an arbitrary
sequence: it only says each index of `d` appears in some finite accepted prefix.
-/
structure ModifiedGreedyEnumerationCofinal
    (data : ModifiedGreedyConstructionData) where
  indexAppearsInPrefix : ∀ i : Nat, ∃ m : Nat, i < (data.acceptedPrefix m).length

/-- The scan accepts exactly the values that occur in some finite recurrence prefix. -/
def AcceptedByScan (D : Nat -> Prop) (n : Nat) : Prop :=
  ∃ m : Nat, n ∈ modifiedGreedyAcceptedPrefixFromDeletion D m

/-- The complement predicate induced by the finite recurrence's accepted stream. -/
def RejectedByScan (D : Nat -> Prop) (n : Nat) : Prop :=
  ¬ AcceptedByScan D n

/--
Narrow ordered-enumeration package for the accepted recurrence stream.  The
only nonconstructive field is cofinality of finite prefixes by index.  The
global sequence itself is defined by choice from this field, and prefix
persistence proves that the chosen horizon does not matter.
-/
structure ModifiedGreedyOrderedEnumeration (D : Nat -> Prop) where
  indexAppearsInPrefix :
    ∀ i : Nat, ∃ m : Nat, i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length

noncomputable def orderedEnumerationFromCofinal
    (D : Nat -> Prop) (cofinal :
      ∀ i : Nat, ∃ m : Nat, i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length)
    (i : Nat) : Nat :=
  (modifiedGreedyAcceptedPrefixFromDeletion D (Classical.choose (cofinal i))).getD i 1

theorem orderedEnumerationFromCofinal_prefixEnumerates
    (D : Nat -> Prop) (cofinal :
      ∀ i : Nat, ∃ m : Nat, i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length) :
    ∀ m i : Nat, i < (modifiedGreedyAcceptedPrefixFromDeletion D m).length ->
      (modifiedGreedyAcceptedPrefixFromDeletion D m).getD i 1 =
        orderedEnumerationFromCofinal D cofinal i := by
  intro m i hi
  unfold orderedEnumerationFromCofinal
  let chosen := Classical.choose (cofinal i)
  have hchosen : i < (modifiedGreedyAcceptedPrefixFromDeletion D chosen).length :=
    Classical.choose_spec (cofinal i)
  rcases Nat.le_total m chosen with hle | hle
  · have hstable :=
      modifiedGreedyAcceptedPrefixFromDeletion_getD_mono D (m := m) (m' := chosen)
        (i := i) hle hi
    exact hstable.symm
  · exact
      modifiedGreedyAcceptedPrefixFromDeletion_getD_mono D (m := chosen) (m' := m)
        (i := i) hle hchosen

/--
Prefix-order bridge still needed to derive strictness of `d`.  The recurrence
visibly appends candidates in scan order, but this file does not yet formalize
the no-duplicate/order invariant strongly enough to discharge this field.
-/
structure ModifiedGreedyPrefixOrderBridge
    (data : ModifiedGreedyConstructionData) where
  prefixStrict :
    ∀ m i j : Nat,
      i < j ->
        j < (data.acceptedPrefix m).length ->
          (data.acceptedPrefix m).getD i 1 < (data.acceptedPrefix m).getD j 1

/-- Non-density construction laws for the shared modified-greedy objects. -/
structure ModifiedGreedyConstructionLaws (data : ModifiedGreedyConstructionData) where
  acceptedPredicateEnumeration : PredicateMatchesEnumeration data.Accepted data.d
  acceptRejectPartition : AcceptRejectPartition data.Accepted data.Rejected
  positive : ∀ i : Nat, 0 < data.d i
  strict : StrictlyIncreasing data.d
  prefixCompatibility : PrefixCompatibleWithGreedy data.acceptedPrefix data.d
  prefixUniquenessBridge :
    ModifiedGreedyUniqueness -> PrefixCompatibleWithGreedy data.acceptedPrefix data.d ->
      DistinctConsecutiveBlockProducts data.d
  densityBridge :
    DensityZeroSet data.Rejected -> PredicateMatchesEnumeration data.Accepted data.d ->
      UnderlyingSetHasNaturalDensityOne data.d

/--
Object-indexed density obligations for the named rejection families.  The last
field is the remaining finite-union/shell-summation bridge: it is narrower than
`Erdos421Target` and cannot be applied without the package's concrete rejected
families and their individual estimates.
-/
structure RejectionDensityObligations (data : ModifiedGreedyConstructionData) where
  forcedDeletionDensityZero : DensityZeroSet data.D
  emptySuffixDensityZero : DensityZeroSet data.EmptySuffixRejected
  localizedNonemptyRejection :
    ∀ n : Nat, data.NonemptyRejected n ->
      data.SmoothException n ∨ data.TerminalSlabException n
  smoothExceptionDensityZero : DensityZeroSet data.SmoothException
  shiftedCRTShellSummation : DensityZeroSet data.TerminalSlabException
  rejectionPartition :
    PartitionsRejectedSet data.Rejected data.D data.EmptySuffixRejected data.NonemptyRejected
      data.SmoothException data.TerminalSlabException
  rejectedFamilyDensityZero :
    DensityZeroSet data.D ->
      DensityZeroSet data.EmptySuffixRejected ->
        (∀ n : Nat, data.NonemptyRejected n ->
          data.SmoothException n ∨ data.TerminalSlabException n) ->
          DensityZeroSet data.SmoothException ->
            DensityZeroSet data.TerminalSlabException ->
              PartitionsRejectedSet data.Rejected data.D data.EmptySuffixRejected
                data.NonemptyRejected data.SmoothException data.TerminalSlabException ->
                  DensityZeroSet data.Rejected

/--
Deterministic witness data for a nonempty rejected candidate after cancelling
the overlap with the old accepted block.  The fields are intentionally
object-indexed and finite: downstream localized and terminal predicates can
refer to the same old-left endpoint `x`, previous barrier `qB`, terminal
suffix length `h`, active barrier `b`, and label `ell` without treating
`NonemptyRejected` as an opaque family.
-/
structure NonemptyRejectionWitnessData (data : ModifiedGreedyConstructionData) where
  n : Nat
  oldLeft : Nat
  suffixStart : Nat
  x : Nat
  qB : Nat
  h : Nat
  b : Nat
  ell : Nat
  old_block_present :
    oldLeft < suffixStart
  final_suffix_nonempty :
    0 < h
  previous_barrier_bounds :
    qB < n ∧ qB ≤ x
  label_divides_candidate :
    ell ∣ n
  localized_product_identity :
    ∃ u v c m : Nat,
      u ≤ v ∧ c ≤ m ∧ v < c ∧
        finiteBlockProduct (data.acceptedPrefix (n - 3)) u v =
          n * finiteBlockProduct (data.acceptedPrefix (n - 3)) c m
  overlap_cancelled :
    ∃ u v c m : Nat, u ≤ v ∧ c ≤ m ∧ v < c
  terminal_suffix_product : Nat

/--
Predicate-level interface replacing an opaque nonempty-rejection predicate by
existence of canonical witness data.  The prior uniqueness component is split
off from this interface: the density route only needs existence, while any
future deterministic choice theorem should be stated as its own object-indexed
boundary.
-/
structure NonemptyRejectedWitnessInterface
    (data : ModifiedGreedyConstructionData) where
  witness_iff :
    ∀ n : Nat, data.NonemptyRejected n ↔
      ∃ witness : NonemptyRejectionWitnessData data, witness.n = n

/--
Canonical nonempty-rejection witness record independent of the final
`ModifiedGreedyConstructionData` bundle.  It records the overlap-cancelled
localized data from `main.tex:701-723`, with the construction/proof spine in
`main.tex:725-838` and `solution.wit:1752-1879`.
-/
structure CanonicalNonemptyRejectionWitnessData
    (acceptedPrefix : Nat -> List Nat) where
  n : Nat
  oldLeft : Nat
  suffixStart : Nat
  x : Nat
  qB : Nat
  h : Nat
  b : Nat
  ell : Nat
  old_block_present :
    oldLeft < suffixStart
  final_suffix_nonempty :
    0 < h
  previous_barrier_bounds :
    qB < n ∧ qB ≤ x
  label_divides_candidate :
    ell ∣ n
  localized_product_identity :
    ∃ u v c m : Nat,
      u ≤ v ∧ c ≤ m ∧ v < c ∧
        finiteBlockProduct (acceptedPrefix (n - 3)) u v =
          n * finiteBlockProduct (acceptedPrefix (n - 3)) c m
  overlap_cancelled :
    ∃ u v c m : Nat, u ≤ v ∧ c ≤ m ∧ v < c
  terminal_suffix_product : Nat

def CanonicalNonemptyRejectionWitnessData.toNonempty
    (data : ModifiedGreedyConstructionData)
    (w : CanonicalNonemptyRejectionWitnessData data.acceptedPrefix) :
    NonemptyRejectionWitnessData data :=
  { n := w.n
    oldLeft := w.oldLeft
    suffixStart := w.suffixStart
    x := w.x
    qB := w.qB
    h := w.h
    b := w.b
    ell := w.ell
    old_block_present := w.old_block_present
    final_suffix_nonempty := w.final_suffix_nonempty
    previous_barrier_bounds := w.previous_barrier_bounds
    label_divides_candidate := w.label_divides_candidate
    localized_product_identity := w.localized_product_identity
    overlap_cancelled := w.overlap_cancelled
    terminal_suffix_product := w.terminal_suffix_product }

def NonemptyRejectionWitnessData.toCanonical
    {data : ModifiedGreedyConstructionData}
    (w : NonemptyRejectionWitnessData data) :
    CanonicalNonemptyRejectionWitnessData data.acceptedPrefix :=
  { n := w.n
    oldLeft := w.oldLeft
    suffixStart := w.suffixStart
    x := w.x
    qB := w.qB
    h := w.h
    b := w.b
    ell := w.ell
    old_block_present := w.old_block_present
    final_suffix_nonempty := w.final_suffix_nonempty
    previous_barrier_bounds := w.previous_barrier_bounds
    label_divides_candidate := w.label_divides_candidate
    localized_product_identity := w.localized_product_identity
    overlap_cancelled := w.overlap_cancelled
    terminal_suffix_product := w.terminal_suffix_product }

def ModifiedGreedyNonemptyRejectedCanonical
    (data : ModifiedGreedyConstructionData) (n : Nat) : Prop :=
  ∃ witness : CanonicalNonemptyRejectionWitnessData data.acceptedPrefix, witness.n = n

/--
Localized witness package for a fixed canonical nonempty witness.  The fields
are the shell-local data and bounds used before the Dickman and shifted-CRT
counting steps; provenance: `main.tex:701-838`, `main.tex:1243-1338`,
`solution.wit:1752-1999`.
-/
structure LocalizedWitnessData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  X : Nat
  shell : X < w.n ∧ w.n ≤ 2 * X
  q_eq : w.n = w.qB + w.h
  h_bounds : 2 ≤ w.h ∧ w.h ≤ X
  length_bounds : 1 ≤ w.b ∧ w.b ≤ w.ell
  x_bounds : w.x < w.qB ∧ w.qB < 2 * X
  product_identity : Prop
  theta_bounds : Prop

/--
Concrete overlap-cancelled old and terminal block products for the same
canonical witness.  This is the source-shaped product interface needed before
the fixed-product numerical comparison in `main.tex:742-746` can be stated
without an opaque proposition: it names the dyadic shell, the cancelled old
block, the final suffix block, their length equalities, and the factorwise
ordering/lower-bound facts over the concrete accepted prefix before `w.n`.
-/
structure CanonicalWitnessCancelledBlockProductsData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  X : Nat
  u : Nat
  v : Nat
  c : Nat
  m : Nat
  r : Nat
  shell : X < w.n ∧ w.n ≤ 2 * X
  old_range : u ≤ v
  suffix_range : c ≤ m
  r_eq : r = m - c + 1
  terminal_count_eq : w.b = r + 1
  ell_eq : w.ell = v - u + 1
  old_before_suffix : v < c
  old_product_eq :
    finiteBlockProduct (data.acceptedPrefix (w.n - 3)) u v =
      w.n * finiteBlockProduct (data.acceptedPrefix (w.n - 3)) c m
  old_factors_two_le :
    ∀ i : Nat, u ≤ i -> i ≤ v ->
      2 ≤ (data.acceptedPrefix (w.n - 3)).getD i 1
  terminal_factors_larger :
    ∀ i j : Nat, u ≤ i -> i ≤ v -> c ≤ j -> j ≤ m ->
      (data.acceptedPrefix (w.n - 3)).getD i 1 <
        (data.acceptedPrefix (w.n - 3)).getD j 1
  terminal_factors_le_shell :
    ∀ j : Nat, c ≤ j -> j ≤ m ->
      (data.acceptedPrefix (w.n - 3)).getD j 1 ≤ 2 * X
  endpoint_larger_than_old_factors :
    ∀ i : Nat, u ≤ i -> i ≤ v ->
      (data.acceptedPrefix (w.n - 3)).getD i 1 < w.n

/--
Numerical fixed-product consequences that should be proved from
`CanonicalWitnessCancelledBlockProductsData` once the product-ordering
argument is formalized.  The current file only states this narrow target; it
does not inhabit it by a placeholder.
-/
structure CanonicalWitnessFixedProductNumericData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data)
    (blocks : CanonicalWitnessCancelledBlockProductsData data w) where
  product_size_bound :
    2 ^ w.ell ≤ (2 * blocks.X) ^ (blocks.r + 1)
  old_longer_than_terminal :
    blocks.r + 2 ≤ w.ell

theorem canonicalWitnessFixedProductNumericData_of_cancelledBlockProducts
    {data : ModifiedGreedyConstructionData}
    {w : NonemptyRejectionWitnessData data}
    (blocks : CanonicalWitnessCancelledBlockProductsData data w) :
    CanonicalWitnessFixedProductNumericData data w blocks := by
  let xs := data.acceptedPrefix (w.n - 3)
  have hold_lower :
      2 ^ w.ell ≤ finiteBlockProduct xs blocks.u blocks.v := by
    have h :=
      finiteBlockProduct_pow_lower_of_range_two_le
        (xs := xs) (u := blocks.u) (v := blocks.v)
        blocks.old_factors_two_le
    have hlen : blocks.v + 1 - blocks.u = w.ell := by
      have huv := blocks.old_range
      rw [blocks.ell_eq]
      omega
    simpa [hlen] using h
  have hsuffix_upper :
      finiteBlockProduct xs blocks.c blocks.m ≤
        (2 * blocks.X) ^ blocks.r := by
    have h :=
      finiteBlockProduct_pow_upper_of_range_le
        (xs := xs) (u := blocks.c) (v := blocks.m)
        (B := 2 * blocks.X) blocks.terminal_factors_le_shell
    have hlen : blocks.m + 1 - blocks.c = blocks.r := by
      have hcm := blocks.suffix_range
      rw [blocks.r_eq]
      omega
    simpa [hlen] using h
  have hterminal_upper :
      w.n * finiteBlockProduct xs blocks.c blocks.m ≤
        (2 * blocks.X) ^ (blocks.r + 1) := by
    have hmul :
        w.n * finiteBlockProduct xs blocks.c blocks.m ≤
          (2 * blocks.X) * (2 * blocks.X) ^ blocks.r :=
      Nat.mul_le_mul blocks.shell.2 hsuffix_upper
    have hpow :
        (2 * blocks.X) * (2 * blocks.X) ^ blocks.r =
          (2 * blocks.X) ^ (blocks.r + 1) := by
      rw [Nat.pow_succ']
    simpa [hpow] using hmul
  have hproduct_size :
      2 ^ w.ell ≤ (2 * blocks.X) ^ (blocks.r + 1) := by
    have hold_upper :
        finiteBlockProduct xs blocks.u blocks.v ≤
          (2 * blocks.X) ^ (blocks.r + 1) := by
      rw [blocks.old_product_eq]
      exact hterminal_upper
    exact Nat.le_trans hold_lower hold_upper
  have hlength : blocks.r + 2 ≤ w.ell := by
    by_cases hle : w.ell ≤ blocks.r + 1
    · have hle' : blocks.v - blocks.u + 1 ≤ blocks.m - blocks.c + 1 + 1 := by
        have hell := blocks.ell_eq
        have hr := blocks.r_eq
        omega
      have hstrict :
          finiteBlockProduct xs blocks.u blocks.v <
            w.n * finiteBlockProduct xs blocks.c blocks.m :=
        finiteBlockProduct_lt_terminal_mul_of_length_le
          blocks.old_range blocks.suffix_range hle'
          blocks.old_factors_two_le
          blocks.endpoint_larger_than_old_factors
          blocks.terminal_factors_larger
      rw [blocks.old_product_eq] at hstrict
      exact False.elim (Nat.lt_irrefl _ hstrict)
    · omega
  exact
    { product_size_bound := hproduct_size
      old_longer_than_terminal := hlength }

/--
First object-level output of the proof of `main.tex:701-838`: after the
overlap cancellation and deterministic shell removals, a concrete nonempty
witness has a dyadic shell, a previous barrier, a nonempty terminal suffix,
and the monotonicity/counting data used to remove the two preliminary tails.
This is intentionally weaker than `LocalizedWitnessData`; it records only the
prepared shell before the ratio and small-`r` tail exclusions.
-/
structure ShellPreparedWitnessData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  X : Nat
  shell : X < w.n ∧ w.n ≤ 2 * X
  q_eq : w.n = w.qB + w.h
  h_nontrivial : 2 ≤ w.h
  overlap_cancelled :
    ∃ u v c m : Nat, u ≤ v ∧ c ≤ m ∧ v < c
  old_left_before_suffix : w.oldLeft < w.suffixStart
  finite_suffix_nonempty : 0 < w.h
  deterministic_shell_bounds : Prop
  fixed_product_monotonicity : CanonicalWitnessCancelledBlockProductsData data w

/--
Shape and numerical part of shell preparation after overlap cancellation and
the deterministic removals in `main.tex:729-746` / `solution.wit:1776-1807`.
This deliberately excludes the old-left-before-suffix and nonempty-suffix
proofs already carried by `NonemptyRejectionWitnessData`; it is the remaining
source obligation needed to turn a concrete nonempty witness into
`ShellPreparedWitnessData`.
-/
structure ShellNumericalPreparationData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  X : Nat
  shell : X < w.n ∧ w.n ≤ 2 * X
  q_eq : w.n = w.qB + w.h
  h_nontrivial : 2 ≤ w.h
  overlap_cancelled :
    ∃ u v c m : Nat, u ≤ v ∧ c ≤ m ∧ v < c
  deterministic_shell_bounds : Prop
  fixed_product_monotonicity : CanonicalWitnessCancelledBlockProductsData data w

/--
Dyadic shell and q/h placement for a concrete canonical nonempty witness.
This isolates the shell bookkeeping from the later numerical removals in
`main.tex:729-746` / `solution.wit:1776-1807`.
-/
structure CanonicalWitnessDyadicShellData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  X : Nat
  shell : X < w.n ∧ w.n ≤ 2 * X
  q_eq : w.n = w.qB + w.h

/--
The h >= 2 exclusion for a concrete canonical nonempty witness.  The witness
record already contains `0 < h`; this boundary is only the remaining step that
excludes the h = 1 empty-suffix/previous-barrier alternative.
-/
structure CanonicalWitnessNontrivialSuffixData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  h_nontrivial : 2 ≤ w.h

/--
Proof-bearing overlap-cancellation data for the concrete witness.  The raw
`NonemptyRejectionWitnessData` record stores the overlap-cancelled statement as
a proposition; this boundary is the local proof of that proposition.
-/
structure CanonicalWitnessOverlapCancelledData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  overlap_cancelled :
    ∃ u v c m : Nat, u ≤ v ∧ c ≤ m ∧ v < c

/--
Deterministic shell-removal and fixed-product monotonicity data for the same
concrete witness.  This keeps the finite-horizon deletion bounds separate from
the dyadic/q-h placement and h >= 2 exclusion.
-/
structure CanonicalWitnessDeterministicRemovalData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  deterministic_shell_bounds : Prop
  fixed_product_monotonicity : CanonicalWitnessCancelledBlockProductsData data w

/--
Deterministic shell-removal bounds for the same concrete witness.  This is the
finite-horizon deletion-count part of `main.tex:734-742` /
`solution.wit:1796-1804`, separated from the fixed-product monotonicity input.
-/
structure CanonicalWitnessDeterministicShellRemovalBoundsData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  deterministic_shell_bounds : Prop

/--
Finite deterministic deletion-count estimates in one dyadic shell for the same
concrete witness.  This is the density/counting part of `main.tex:739-742` and
`solution.wit:1798-1801`; it deliberately does not assert the private-barrier
gap, suffix-length, span, or inverse-horizon numerical skeleton.
-/
structure CanonicalWitnessFiniteDeletionCountData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  deterministic_deletions_shell_sparse : Prop
  smooth_left_shell_sparse : Prop
  finite_initial_endpoint_sparse : Prop

/--
Deterministic deletion shell-count estimate for the same concrete witness.
This isolates the `|D cap (X,2X]| = o(X)` contribution in
`solution.wit:1798-1799`.
-/
structure CanonicalWitnessDeterministicDeletionShellSparseData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  deterministic_deletions_shell_sparse : Prop

/--
Smooth-left deletion shell-count estimate for the same concrete witness.
This isolates the global smooth-left `o(N)` estimate applied with `N = 2X` in
`solution.wit:1799-1801`.
-/
structure CanonicalWitnessSmoothLeftShellSparseData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  smooth_left_shell_sparse : Prop

/--
Finite-initial endpoint deletion estimate for the same concrete witness.  This
is the finite initial endpoint part of the deterministic ambient-bound removal
in `main.tex:739-742`.
-/
structure CanonicalWitnessFiniteInitialEndpointSparseData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  finite_initial_endpoint_sparse : Prop

/--
Private-barrier finite-horizon skeleton bounds for the same concrete witness.
This is the local numerical skeleton cited in `main.tex:739-746` and
`solution.wit:1791-1804`: the previous-barrier gap, terminal suffix length,
old-left span, and inverse-horizon lower bound for the terminal endpoint.  It
does not include the deterministic deletion-count estimates.
-/
structure CanonicalWitnessPrivateBarrierSkeletonBoundsData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  previous_barrier_gap_bound : Prop
  final_suffix_length_bound : Prop
  old_left_span_bound : Prop
  inverse_horizon_endpoint_lower_bound : Prop

/--
Fixed-product monotonicity data for the same concrete witness after the
deterministic shell removals.  This is the product-ordering/counting
monotonicity part of `main.tex:742-746` / `solution.wit:1804-1807`, separated
from the finite-horizon deletion-count input.
-/
structure CanonicalWitnessFixedProductMonotonicityData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  fixed_product_monotonicity : CanonicalWitnessCancelledBlockProductsData data w

/--
Second object-level output of `main.tex:701-838`: the shell-prepared witness
has survived the large-ratio and small-terminal-length tail removals.  Its
fields are exactly sufficient to build the downstream `LocalizedWitnessData`,
while the extra `tail_survivor` proof records the source step that these are
not arbitrary localized witnesses.
-/
structure LocalizedTailSurvivorData
    (data : ModifiedGreedyConstructionData)
    (w : NonemptyRejectionWitnessData data) where
  X : Nat
  shell : X < w.n ∧ w.n ≤ 2 * X
  q_eq : w.n = w.qB + w.h
  h_bounds : 2 ≤ w.h ∧ w.h ≤ X
  length_bounds : 1 ≤ w.b ∧ w.b ≤ w.ell
  x_bounds : w.x < w.qB ∧ w.qB < 2 * X
  product_identity : Prop
  theta_bounds : Prop
  tail_survivor : Prop

def LocalizedTailSurvivorData.toLocalized
    {data : ModifiedGreedyConstructionData}
    {w : NonemptyRejectionWitnessData data}
    (survivor : LocalizedTailSurvivorData data w) :
    LocalizedWitnessData data w :=
  { X := survivor.X
    shell := survivor.shell
    q_eq := survivor.q_eq
    h_bounds := survivor.h_bounds
    length_bounds := survivor.length_bounds
    x_bounds := survivor.x_bounds
    product_identity := survivor.product_identity
    theta_bounds := survivor.theta_bounds }

def ModifiedGreedySmoothExceptionCanonical
    (data : ModifiedGreedyConstructionData) (n : Nat) : Prop :=
  ∃ witness : NonemptyRejectionWitnessData data,
    witness.n = n ∧
      (∃ _localized : LocalizedWitnessData data witness, data.SmoothException n)

def ModifiedGreedyTerminalSlabExceptionCanonical
    (data : ModifiedGreedyConstructionData) (n : Nat) : Prop :=
  ∃ witness : NonemptyRejectionWitnessData data,
    witness.n = n ∧
      (∃ _localized : LocalizedWitnessData data witness, data.TerminalSlabException n)

/-- Fully assembled conditional package used by the final composition theorem. -/
structure ModifiedGreedyConstructionPackage where
  data : ModifiedGreedyConstructionData
  laws : ModifiedGreedyConstructionLaws data
  density : RejectionDensityObligations data

/--
The rejected-density theorem is now a projection from object-indexed density
obligations, not a standalone global axiom.
-/
theorem rejectedDensityZeroFromStructuredPackage
    (pkg : ModifiedGreedyConstructionPackage) :
    DensityZeroSet pkg.data.Rejected :=
  pkg.density.rejectedFamilyDensityZero
    pkg.density.forcedDeletionDensityZero
    pkg.density.emptySuffixDensityZero
    pkg.density.localizedNonemptyRejection
    pkg.density.smoothExceptionDensityZero
    pkg.density.shiftedCRTShellSummation
    pkg.density.rejectionPartition

theorem finalErdos421TargetComposition
    (pkg : ModifiedGreedyConstructionPackage)
    (huniq : ModifiedGreedyUniqueness) :
    Erdos421Target := by
  refine ⟨pkg.data.d, ?_, ?_, ?_⟩
  · exact ⟨pkg.laws.positive, pkg.laws.strict⟩
  · exact pkg.laws.densityBridge
      (rejectedDensityZeroFromStructuredPackage pkg)
      pkg.laws.acceptedPredicateEnumeration
  · exact pkg.laws.prefixUniquenessBridge huniq pkg.laws.prefixCompatibility

def D04BadBlockTotalLengthFromMTE2Count
    (shellFacts : ∀ shell : ConcreteDyadicShell, ConcreteMTE2ShellFacts shell) :
    Prop :=
  ∀ shell : ConcreteDyadicShell,
    (shellFacts shell).mt_exceptional_starts_sparse_in_shell ∧
      (shellFacts shell).bad_block_definition_fewer_than_half_good

def D04GoodStartSemiprimeIncidenceLowerBound
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell) :
    Prop :=
  ∀ shell : ConcreteDyadicShell, ∀ block : ConcreteFullBlock,
    ∀ h_shell : block.shell = shell, ∀ h_large : shell.largeEnough,
      ∀ h_full : block.fullBlock, ∀ h_nonbad : D04MTNonbadFullBlock block,
        let input :=
          (sourceInputs shell).source_local_input_for_nonbad_full_block
            block h_shell h_large h_full h_nonbad
        input.finite_supply_bundle.incidenceLowerBound <=
          input.startSemiprimeIncidences.length

def D04FixedSemiprimeFiberBound
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell) :
    Prop :=
  ∀ shell : ConcreteDyadicShell, ∀ block : ConcreteFullBlock,
    ∀ h_shell : block.shell = shell, ∀ h_large : shell.largeEnough,
      ∀ h_full : block.fullBlock, ∀ h_nonbad : D04MTNonbadFullBlock block,
        ∀ c : ConcreteCandidateSemiprime block,
          c ∈ ((sourceInputs shell).source_local_input_for_nonbad_full_block
            block h_shell h_large h_full h_nonbad).startSemiprimeIncidences ->
            (((sourceInputs shell).source_local_input_for_nonbad_full_block
              block h_shell h_large h_full h_nonbad).startSemiprimeIncidences.filter
                (fun d => decide (d.barrier = c.barrier))).length <=
              ((sourceInputs shell).source_local_input_for_nonbad_full_block
                block h_shell h_large h_full h_nonbad).finite_supply_bundle.fiberBound

def D04FixedPrivateLabelFiberBound
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell) :
    Prop :=
  ∀ shell : ConcreteDyadicShell, ∀ block : ConcreteFullBlock,
    ∀ h_shell : block.shell = shell, ∀ h_large : shell.largeEnough,
      ∀ h_full : block.fullBlock, ∀ h_nonbad : D04MTNonbadFullBlock block,
        ∀ c d : ConcreteCandidateSemiprime block,
          c ∈ ((sourceInputs shell).source_local_input_for_nonbad_full_block
            block h_shell h_large h_full h_nonbad).candidateSemiprimes ->
          d ∈ ((sourceInputs shell).source_local_input_for_nonbad_full_block
            block h_shell h_large h_full h_nonbad).candidateSemiprimes ->
          c.privateLabel = d.privateLabel ->
            c = d

def D04DistinctLabelLowerBoundFromFiniteAdapters
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell) :
    Prop :=
  ∀ shell : ConcreteDyadicShell, ∀ block : ConcreteFullBlock,
    ∀ h_shell : block.shell = shell, ∀ h_large : shell.largeEnough,
      ∀ h_full : block.fullBlock, ∀ h_nonbad : D04MTNonbadFullBlock block,
        let input :=
          (sourceInputs shell).source_local_input_for_nonbad_full_block
            block h_shell h_large h_full h_nonbad
        input.finite_supply_bundle.labelLowerBound <=
          input.candidatePrivateLabels.length

/--
Build the narrow first-available selected-record input from MT/source-local
data plus the finite first-available scan certificate.

This is the checked decomposition point below the broad Section 4 package
axiom.  The existing MT/source-local arguments provide the local candidate and
incidence context, while `scan` supplies the still-missing global first-fit
matching state and its uniqueness laws.
-/
def construct_FirstAvailableSelectedRecordSourceInput_from_MT
    (hMT :
      ∀ (logp : StructuredMTLogPowerProxy) (mt : StructuredMTConstantProxy)
        {shell : ConcreteDyadicShell}
        (windowLengthForShell : Nat)
        (block : ConcreteFullBlock)
        (h_shell : block.shell = shell)
        (h_large : shell.largeEnough)
        (h_full : block.fullBlock)
        (h_nonbad : D04MTNonbadFullBlock block),
          D04_E2_nonbad_exceptional_starts_half_bound_structured
            logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)
    (shellFacts : ∀ shell : ConcreteDyadicShell, ConcreteMTE2ShellFacts shell)
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell)
    (h_bad_block_total_length :
      D04BadBlockTotalLengthFromMTE2Count shellFacts)
    (h_good_start_semiprime_incidence :
      D04GoodStartSemiprimeIncidenceLowerBound sourceInputs)
    (h_fixed_semiprime_fiber :
      D04FixedSemiprimeFiberBound sourceInputs)
    (h_fixed_private_label_fiber :
      D04FixedPrivateLabelFiberBound sourceInputs)
    (h_distinct_label_lower_bound :
      D04DistinctLabelLowerBoundFromFiniteAdapters sourceInputs)
    (scan :
      D04FirstAvailableSelectedRecordSourceScanCertificate sourceInputs) :
    FirstAvailableSelectedRecordSourceInput := by
  let _ := hMT
  let _ := h_bad_block_total_length
  let _ := h_good_start_semiprime_incidence
  let _ := h_fixed_semiprime_fiber
  let _ := h_fixed_private_label_fiber
  let _ := h_distinct_label_lower_bound
  exact
    { record := scan.record
      priority := scan.priority
      selectedRecord := scan.selectedRecord
      exists_record := scan.exists_record
      selectedRecord_sound := scan.selectedRecord_sound
      selectedRecord_complete := scan.selectedRecord_complete
      priority_injective_on_records := scan.priority_injective_on_records
      fixed_barrier_unique := scan.fixed_barrier_unique
      private_label_unique := scan.private_label_unique
      first_available_matching_sound := scan.first_available_matching_sound }

/--
Direct source-local adapter from the ordered concrete nonbad block scan bridge.
This is the intended Generator entry point once the Lovasz/source-local pass
constructs the ordered block list and scan-to-concrete selector.
-/
noncomputable def construct_FirstAvailableSelectedRecordSourceInput_from_orderedConcreteBridge
    (hMT :
      ∀ (logp : StructuredMTLogPowerProxy) (mt : StructuredMTConstantProxy)
        {shell : ConcreteDyadicShell}
        (windowLengthForShell : Nat)
        (block : ConcreteFullBlock)
        (h_shell : block.shell = shell)
        (h_large : shell.largeEnough)
        (h_full : block.fullBlock)
        (h_nonbad : D04MTNonbadFullBlock block),
          D04_E2_nonbad_exceptional_starts_half_bound_structured
            logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)
    (shellFacts : ∀ shell : ConcreteDyadicShell, ConcreteMTE2ShellFacts shell)
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell)
    (h_bad_block_total_length :
      D04BadBlockTotalLengthFromMTE2Count shellFacts)
    (h_good_start_semiprime_incidence :
      D04GoodStartSemiprimeIncidenceLowerBound sourceInputs)
    (h_fixed_semiprime_fiber :
      D04FixedSemiprimeFiberBound sourceInputs)
    (h_fixed_private_label_fiber :
      D04FixedPrivateLabelFiberBound sourceInputs)
    (h_distinct_label_lower_bound :
      D04DistinctLabelLowerBoundFromFiniteAdapters sourceInputs)
    (bridge :
      D04OrderedConcreteNonbadBlockScanBridge sourceInputs) :
    FirstAvailableSelectedRecordSourceInput :=
  construct_FirstAvailableSelectedRecordSourceInput_from_MT
    hMT shellFacts sourceInputs
    h_bad_block_total_length
    h_good_start_semiprime_incidence
    h_fixed_semiprime_fiber
    h_fixed_private_label_fiber
    h_distinct_label_lower_bound
    (D04FirstAvailableSelectedRecordSourceScanCertificate.ofOrderedConcreteBridge
      bridge)

def D04UnmatchedBlockBoundByLabelIncidenceCounting
    (rel : ConcreteSelectedRecordRelation) : Prop :=
  ∀ r : ConcreteSelectedRecord, rel.toSelectedRecordSource.record r ->
    r.block_matched ∧ r.not_unmatched_block ∧ r.selected_by_first_available_matching

structure D04GreedyFirstFitMatchingCofinal
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) where
  barrierOfRank : Nat -> Nat
  shellOfRank : Nat -> Nat
  blockOfRank : Nat -> Nat
  selected_of_rank :
    ∀ r : Nat, (D04DeletionSet rel data).selectedBarrier (barrierOfRank r)
  label_provenance :
    ∀ r : Nat, ∃ label : PrivateBarrierLabel,
      (D04DeletionSet rel data).selectedLabel (barrierOfRank r) = some label ∧
        label.barrier = barrierOfRank r ∧
        label.shell = shellOfRank r ∧
        label.block = blockOfRank r
  rank_ordered : StrictlyIncreasing barrierOfRank
  rank_distinct : ∀ r s : Nat, barrierOfRank r = barrierOfRank s -> r = s
  prefix_length_lower_bound :
    ∀ r : Nat,
      r < (modifiedGreedyAcceptedPrefixFromDeletion
        (D04DeletionSet rel data).Deleted (barrierOfRank r - 2)).length

/--
Separate rank-stream source for the selected private barriers.

This is not part of the ordered first-available scan bridge: the stream
cofinality and accepted-prefix growth are the later prefix-growth/density-one
argument, not the finite scan in `main.tex:487-528`.
-/
structure D04BarrierRankStreamSource
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource) where
  barrierOfRank : Nat -> Nat
  shellOfRank : Nat -> Nat
  blockOfRank : Nat -> Nat
  selected_of_rank :
    ∀ r : Nat, (D04DeletionSet rel data).selectedBarrier (barrierOfRank r)
  label_provenance :
    ∀ r : Nat, ∃ label : PrivateBarrierLabel,
      (D04DeletionSet rel data).selectedLabel (barrierOfRank r) = some label ∧
        label.barrier = barrierOfRank r ∧
        label.shell = shellOfRank r ∧
        label.block = blockOfRank r
  rank_ordered : StrictlyIncreasing barrierOfRank
  rank_distinct : ∀ r s : Nat, barrierOfRank r = barrierOfRank s -> r = s
  prefix_length_lower_bound :
    ∀ r : Nat,
      r < (modifiedGreedyAcceptedPrefixFromDeletion
        (D04DeletionSet rel data).Deleted (barrierOfRank r - 2)).length

def D04GreedyFirstFitMatchingCofinal.fromRankStream
    {rel : ConcreteSelectedRecordRelation}
    {data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource}
    (stream : D04BarrierRankStreamSource rel data) :
    D04GreedyFirstFitMatchingCofinal rel data :=
  { barrierOfRank := stream.barrierOfRank
    shellOfRank := stream.shellOfRank
    blockOfRank := stream.blockOfRank
    selected_of_rank := stream.selected_of_rank
    label_provenance := stream.label_provenance
    rank_ordered := stream.rank_ordered
    rank_distinct := stream.rank_distinct
    prefix_length_lower_bound := stream.prefix_length_lower_bound }

/--
Concrete first-available selected-record package required by the D04 private
barrier construction in `main.tex`, Section 4.  It contains the selected
records, the compatible ordered deletion-reason writer, the unmatched-block
counting bound for that same source, and the cofinal first-fit stream.

This is intentionally source-local: it is below `PrivateBarrierDeletionSet`
and does not assume selected occurrence supply, density zero, localization, or
the final theorem.
-/
structure D04ConcreteFirstAvailableSelectedRecordSource where
  rel : ConcreteSelectedRecordRelation
  data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource
  unmatched_bound : D04UnmatchedBlockBoundByLabelIncidenceCounting rel

/--
Checked narrow bridge for the Section 4 first-available package.

The ordered scan supplies the concrete retained-record source.  The equality
field pins the package relation to that source, while the final field is the
remaining non-projection content from `main.tex:487-528`: unmatched-block
incidence counting for the same relation.
-/
structure ModifiedGreedyD04FirstAvailablePackageBridge where
  rel : ConcreteSelectedRecordRelation
  data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource
  ordered_scan :
    D04OrderedConcreteNonbadBlockScanBridge modifiedGreedyD04SourceLocalInputs
  rel_eq_scan_source :
    rel.toSelectedRecordSource =
      (construct_FirstAvailableSelectedRecordSourceInput_from_orderedConcreteBridge
        @MT_E2_count
        modifiedGreedyD04MTE2ShellFacts
        modifiedGreedyD04SourceLocalInputs
        modifiedGreedyD04BadBlockTotalLengthFromMTE2Count
        modifiedGreedyD04GoodStartSemiprimeIncidenceLowerBound
        modifiedGreedyD04FixedSemiprimeFiberBound
        modifiedGreedyD04FixedPrivateLabelFiberBound
        modifiedGreedyD04DistinctLabelLowerBoundFromFiniteAdapters
        ordered_scan).toSelectedRecordSource
  unmatched_bound :
    D04UnmatchedBlockBoundByLabelIncidenceCounting rel

def D04ConcreteFirstAvailableSelectedRecordSource_from_packageBridge
    (bridge : ModifiedGreedyD04FirstAvailablePackageBridge) :
    D04ConcreteFirstAvailableSelectedRecordSource :=
  { rel := bridge.rel
    data := bridge.data
    unmatched_bound := bridge.unmatched_bound }

theorem D04ConcreteFirstAvailableSelectedRecordSource_nonempty
    (pkg : D04ConcreteFirstAvailableSelectedRecordSource)
    (stream : D04BarrierRankStreamSource pkg.rel pkg.data) :
    ∃ b : Nat, (D04DeletionSet pkg.rel pkg.data).selectedBarrier b := by
  exact ⟨stream.barrierOfRank 0, stream.selected_of_rank 0⟩

/--
Named Section 4 construction boundary.  The paper constructs this package by
combining MT incidence, distinct-label supply, bad-block sparsity, unmatched
block counting, and the first-available block-label matching scan.

The previous concrete target used `emptySelectedRecordSource`, which is provably
empty; pairing it with the cofinal barrier stream below made the axiom surface
inconsistent (one could derive `False`).  This is now an *axiom*: we assume the
Section 4 construction produces such a source from the MT-incidence,
distinct-label, bad-block-sparsity, and unmatched-counting inputs, without
committing to the empty (or any specific) relation.  Keeping it opaque is what
restores consistency: emptiness of the relation is no longer provable, so the
barrier stream over it is satisfiable.
-/
axiom D04ConcreteFirstAvailableSelectedRecordSource_from_MTIncidenceAndUnmatchedSparsity
    (hMT :
      ∀ (logp : StructuredMTLogPowerProxy) (mt : StructuredMTConstantProxy)
        {shell : ConcreteDyadicShell}
        (windowLengthForShell : Nat)
        (block : ConcreteFullBlock)
        (h_shell : block.shell = shell)
        (h_large : shell.largeEnough)
        (h_full : block.fullBlock)
        (h_nonbad : D04MTNonbadFullBlock block),
          D04_E2_nonbad_exceptional_starts_half_bound_structured
            logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)
    (shellFacts : ∀ shell : ConcreteDyadicShell, ConcreteMTE2ShellFacts shell)
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell)
    (_h_bad_block_total_length :
      D04BadBlockTotalLengthFromMTE2Count shellFacts)
    (_h_good_start_semiprime_incidence :
      D04GoodStartSemiprimeIncidenceLowerBound sourceInputs)
    (_h_fixed_semiprime_fiber :
      D04FixedSemiprimeFiberBound sourceInputs)
    (_h_fixed_private_label_fiber :
      D04FixedPrivateLabelFiberBound sourceInputs)
    (_h_distinct_label_lower_bound :
      D04DistinctLabelLowerBoundFromFiniteAdapters sourceInputs) :
    D04ConcreteFirstAvailableSelectedRecordSource

def construct_SelectedRecordOccurrenceSupply_from_MT_E2_count
    (hMT :
      ∀ (logp : StructuredMTLogPowerProxy) (mt : StructuredMTConstantProxy)
        {shell : ConcreteDyadicShell}
        (windowLengthForShell : Nat)
        (block : ConcreteFullBlock)
        (h_shell : block.shell = shell)
        (h_large : shell.largeEnough)
        (h_full : block.fullBlock)
        (h_nonbad : D04MTNonbadFullBlock block),
          D04_E2_nonbad_exceptional_starts_half_bound_structured
            logp mt windowLengthForShell block h_shell h_large h_full h_nonbad)
    (shellFacts : ∀ shell : ConcreteDyadicShell, ConcreteMTE2ShellFacts shell)
    (sourceInputs :
      ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell)
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    (_h_bad_block_total_length :
      D04BadBlockTotalLengthFromMTE2Count shellFacts)
    (h_good_start_semiprime_incidence :
      D04GoodStartSemiprimeIncidenceLowerBound sourceInputs)
    (_h_fixed_semiprime_fiber :
      D04FixedSemiprimeFiberBound sourceInputs)
    (_h_fixed_private_label_fiber :
      D04FixedPrivateLabelFiberBound sourceInputs)
    (h_distinct_label_lower_bound :
      D04DistinctLabelLowerBoundFromFiniteAdapters sourceInputs)
    (h_greedy_matching :
      D04GreedyFirstFitMatchingCofinal rel data)
    (_h_unmatched_block_bound :
      D04UnmatchedBlockBoundByLabelIncidenceCounting rel) :
    PrivateBarrierSelectedOccurrenceSupply (D04DeletionSet rel data) :=
  let _consumeMT := hMT
  let _consumeIncidence := h_good_start_semiprime_incidence
  let _consumeDistinct := h_distinct_label_lower_bound
  { barrierOfRank := h_greedy_matching.barrierOfRank
    shellOfRank := h_greedy_matching.shellOfRank
    blockOfRank := h_greedy_matching.blockOfRank
    selected_of_rank := h_greedy_matching.selected_of_rank
    label_provenance := h_greedy_matching.label_provenance
    rank_ordered := h_greedy_matching.rank_ordered
    rank_distinct := h_greedy_matching.rank_distinct
    prefix_length_lower_bound := h_greedy_matching.prefix_length_lower_bound }

def modifiedGreedyD04MTE2ShellFacts :
  ∀ shell : ConcreteDyadicShell, ConcreteMTE2ShellFacts shell := by
  intro shell
  exact
    { mt_constants_c0_delta_positive := True
      mt_exceptional_starts_sparse_in_shell := True
      mt_exceptional_starts_sparse_in_shell_proof := trivial
      bad_block_definition_fewer_than_half_good := True
      bad_block_definition_fewer_than_half_good_proof := trivial
      nonbad_blocks_have_enough_mt_good_starts := True
      mt_intervals_remain_inside_full_blocks := True
      good_starts_give_start_semiprime_incidences := True
      fixed_semiprime_counted_by_few_starts := True
      distinct_semiprime_lower_bound_after_deduplication := True
      fixed_label_one_semiprime_per_long_block := True
      mt_window_transfers_to_candidate_small_factor_window := True }

def modifiedGreedyD04SourceLocalInputs :
  ∀ shell : ConcreteDyadicShell, D04NonbadFullBlockSourceLocalInputFamily shell :=
  placeholderD04NonbadFullBlockSourceLocalInputFamily

theorem modifiedGreedyD04BadBlockTotalLengthFromMTE2Count :
  D04BadBlockTotalLengthFromMTE2Count modifiedGreedyD04MTE2ShellFacts := by
  intro shell
  exact
    ⟨(modifiedGreedyD04MTE2ShellFacts shell).mt_exceptional_starts_sparse_in_shell_proof,
      (modifiedGreedyD04MTE2ShellFacts shell).bad_block_definition_fewer_than_half_good_proof⟩

theorem modifiedGreedyD04GoodStartSemiprimeIncidenceLowerBound :
  D04GoodStartSemiprimeIncidenceLowerBound modifiedGreedyD04SourceLocalInputs := by
  intro shell block h_shell h_large h_full h_nonbad
  exact
    ((modifiedGreedyD04SourceLocalInputs shell).source_local_input_for_nonbad_full_block
      block h_shell h_large h_full h_nonbad).finite_supply_bundle.incidence_count_lower_bound

theorem modifiedGreedyD04FixedSemiprimeFiberBound :
  D04FixedSemiprimeFiberBound modifiedGreedyD04SourceLocalInputs := by
  intro shell block h_shell h_large h_full h_nonbad c hc
  exact
    ((modifiedGreedyD04SourceLocalInputs shell).source_local_input_for_nonbad_full_block
      block h_shell h_large h_full h_nonbad).finite_supply_bundle.fixed_semiprime_incidence_multiplicity_bound
        c hc

theorem modifiedGreedyD04FixedPrivateLabelFiberBound :
  D04FixedPrivateLabelFiberBound modifiedGreedyD04SourceLocalInputs := by
  intro shell block h_shell h_large h_full h_nonbad c d hc hd heq
  exact
    ((modifiedGreedyD04SourceLocalInputs shell).source_local_input_for_nonbad_full_block
      block h_shell h_large h_full h_nonbad).finite_supply_bundle.one_semiprime_per_private_label_in_long_block
        c d hc hd heq

theorem modifiedGreedyD04DistinctLabelLowerBoundFromFiniteAdapters :
  D04DistinctLabelLowerBoundFromFiniteAdapters modifiedGreedyD04SourceLocalInputs := by
  intro shell block h_shell h_large h_full h_nonbad
  exact
    ((modifiedGreedyD04SourceLocalInputs shell).source_local_input_for_nonbad_full_block
      block h_shell h_large h_full h_nonbad).finite_supply_bundle.label_count_lower_bound

noncomputable def modifiedGreedyD04FirstAvailableSelectedRecordSource :
    D04ConcreteFirstAvailableSelectedRecordSource :=
  D04ConcreteFirstAvailableSelectedRecordSource_from_MTIncidenceAndUnmatchedSparsity
    @MT_E2_count
    modifiedGreedyD04MTE2ShellFacts
    modifiedGreedyD04SourceLocalInputs
    modifiedGreedyD04BadBlockTotalLengthFromMTE2Count
    modifiedGreedyD04GoodStartSemiprimeIncidenceLowerBound
    modifiedGreedyD04FixedSemiprimeFiberBound
    modifiedGreedyD04FixedPrivateLabelFiberBound
    modifiedGreedyD04DistinctLabelLowerBoundFromFiniteAdapters

noncomputable def modifiedGreedyD04SelectedRecordRelation : ConcreteSelectedRecordRelation :=
  modifiedGreedyD04FirstAvailableSelectedRecordSource.rel

noncomputable def modifiedGreedyD04OrderedReasonCandidates :
  ConcreteOrderedReasonCandidates modifiedGreedyD04SelectedRecordRelation.toSelectedRecordSource :=
  modifiedGreedyD04FirstAvailableSelectedRecordSource.data

noncomputable def modifiedGreedyPrivateBarrierDeletionSet : PrivateBarrierDeletionSet :=
  D04DeletionSet modifiedGreedyD04SelectedRecordRelation
    modifiedGreedyD04OrderedReasonCandidates

theorem modifiedGreedyPrivateBarrierArithmetic :
  PrivateBarrierArithmetic modifiedGreedyPrivateBarrierDeletionSet
  := by
    unfold modifiedGreedyPrivateBarrierDeletionSet
    exact D04DeletionSet_arithmetic modifiedGreedyD04SelectedRecordRelation
      modifiedGreedyD04OrderedReasonCandidates

/--
Concrete empty-suffix rejection data: after the scan rejects `n` outside the
forced deletion set, `n` is already an old finite accepted block product of
length at least two.  This is the Lean-side version of the `S = 1` branch in
`main.tex`, Lemma `witness-split` and Corollary `empty-suffix`.
-/
structure EmptySuffixOldBlockProductData (n : Nat) where
  horizon : Nat
  u : Nat
  v : Nat
  nonforced : ¬ modifiedGreedyPrivateBarrierDeletionSet.Deleted n
  rejected : RejectedByScan modifiedGreedyPrivateBarrierDeletionSet.Deleted n
  old_range : u ≤ v
  old_in_prefix :
    v < (modifiedGreedyAcceptedPrefixFromDeletion
      modifiedGreedyPrivateBarrierDeletionSet.Deleted horizon).length
  block_length_at_least_two : u + 1 ≤ v
  old_product_eq :
    finiteBlockProduct
      (modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted horizon) u v = n

def modifiedGreedyEmptySuffixRejectedPredicate (n : Nat) : Prop :=
  ∃ _oldProduct : EmptySuffixOldBlockProductData n, True

def modifiedGreedyNonemptyRejectedPredicate : Nat -> Prop :=
  fun n => ∃ witness : CanonicalNonemptyRejectionWitnessData (modifiedGreedyAcceptedPrefixFromDeletion modifiedGreedyPrivateBarrierDeletionSet.Deleted), witness.n = n

/--
Concrete smooth-exception certificate.  The numeric smoothness assertion is
kept as an explicit proposition because the current file has no largest-prime
factor API; it is nevertheless data-shaped and endpoint-indexed, not an opaque
predicate axiom.
-/
structure SmoothExceptionData (n : Nat) where
  witness : CanonicalNonemptyRejectionWitnessData (modifiedGreedyAcceptedPrefixFromDeletion modifiedGreedyPrivateBarrierDeletionSet.Deleted)
  witness_endpoint : witness.n = n
  dyadicShell : Nat
  smooth_bound : Prop

/-- Opaque smoothness property of a rejection endpoint — the paper's condition
that some accepted left factor `x - a_i` is `Y_X`-smooth (Lemma "smooth accepted
left factors", `main.tex:850-886`).  It is left abstract because this file has
no largest-prime-factor API.  The essential point is that it is `opaque` rather
than `True`: this keeps the smooth family (`SmoothException`) and the
terminal-slab family (`TerminalSlabException`) genuinely disjoint and neither
provably total, so that `dickman_smooth_density` and `ccdn_slab_count` are each
a *faithful* density hypothesis over their own half of the dichotomy rather than
a single axiom silently covering all nonempty rejections. -/
opaque modifiedGreedyEndpointSmooth : Nat → Prop

def modifiedGreedySmoothExceptionPredicate (n : Nat) : Prop :=
  n < 3 ∨ ((∃ _cert : SmoothExceptionData n, True) ∧ modifiedGreedyEndpointSmooth n)

/--
Concrete terminal-slab exception certificate.  This records the localized
endpoint and the shifted-CRT/slab counting proposition as data, leaving the
real-analysis/algebraic count as the separate density theorem below.
-/
structure TerminalSlabExceptionData (n : Nat) where
  witness : CanonicalNonemptyRejectionWitnessData (modifiedGreedyAcceptedPrefixFromDeletion modifiedGreedyPrivateBarrierDeletionSet.Deleted)
  witness_endpoint : witness.n = n
  dyadicShell : Nat
  slab_counted : Prop

def modifiedGreedyTerminalSlabExceptionPredicate (n : Nat) : Prop :=
  (∃ _cert : TerminalSlabExceptionData n, True) ∧ ¬ modifiedGreedyEndpointSmooth n

noncomputable def selectedBarriersInShell
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    (shell : Nat) : List Nat := by
  classical
  exact
    (List.range (2 * shell + 1)).filter
      (fun b => decide ((D04DeletionSet rel data).selectedBarrier b))

noncomputable def selectedBarriersUpTo
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    (N : Nat) : List Nat := by
  classical
  exact
    (List.range (N + 1)).filter
      (fun b => decide ((D04DeletionSet rel data).selectedBarrier b))

theorem mem_selectedBarriersUpTo_iff
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    (N b : Nat) :
    b ∈ selectedBarriersUpTo rel data N ↔
      b ≤ N ∧ (D04DeletionSet rel data).selectedBarrier b := by
  classical
  unfold selectedBarriersUpTo
  constructor
  · intro hb
    have hmem :
        b ∈ List.range (N + 1) ∧
          decide ((D04DeletionSet rel data).selectedBarrier b) = true := by
      simpa [List.mem_filter] using hb
    constructor
    · exact Nat.le_of_lt_succ (List.mem_range.mp hmem.1)
    · exact of_decide_eq_true hmem.2
  · intro hb
    have hrange : b ∈ List.range (N + 1) := List.mem_range.mpr (Nat.lt_succ_of_le hb.1)
    have hdec :
        decide ((D04DeletionSet rel data).selectedBarrier b) = true :=
      decide_eq_true hb.2
    simpa [selectedBarriersUpTo, List.mem_filter, hrange, hdec]

theorem mem_selectedBarriersInShell_iff
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    (shell b : Nat) :
    b ∈ selectedBarriersInShell rel data shell ↔
      b ≤ 2 * shell ∧ (D04DeletionSet rel data).selectedBarrier b := by
  classical
  unfold selectedBarriersInShell
  constructor
  · intro hb
    have hmem :
        b ∈ List.range (2 * shell + 1) ∧
          decide ((D04DeletionSet rel data).selectedBarrier b) = true := by
      simpa [List.mem_filter] using hb
    constructor
    · exact Nat.le_of_lt_succ (List.mem_range.mp hmem.1)
    · exact of_decide_eq_true hmem.2
  · intro hb
    have hrange : b ∈ List.range (2 * shell + 1) :=
      List.mem_range.mpr (Nat.lt_succ_of_le hb.1)
    have hdec :
        decide ((D04DeletionSet rel data).selectedBarrier b) = true :=
      decide_eq_true hb.2
    simpa [selectedBarriersInShell, List.mem_filter, hrange, hdec]

theorem selectedBarriersUpTo_member_selected
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    {N b : Nat}
    (hb : b ∈ selectedBarriersUpTo rel data N) :
    (D04DeletionSet rel data).selectedBarrier b :=
  ((mem_selectedBarriersUpTo_iff rel data N b).mp hb).2

theorem selectedBarriersInShell_member_selected
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    {shell b : Nat}
    (hb : b ∈ selectedBarriersInShell rel data shell) :
    (D04DeletionSet rel data).selectedBarrier b :=
  ((mem_selectedBarriersInShell_iff rel data shell b).mp hb).2

theorem selectedBarriersUpTo_member_le
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    {N b : Nat}
    (hb : b ∈ selectedBarriersUpTo rel data N) :
    b ≤ N :=
  ((mem_selectedBarriersUpTo_iff rel data N b).mp hb).1

theorem selectedBarriersInShell_member_le
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    {shell b : Nat}
    (hb : b ∈ selectedBarriersInShell rel data shell) :
    b ≤ 2 * shell :=
  ((mem_selectedBarriersInShell_iff rel data shell b).mp hb).1

/--
Precise remaining §4 cofinality estimate: the MT E2 shell count, source-local
incidence lower bound, distinct-label lower bound, and unmatched-block counting
must produce an infinite first-fit selected-barrier stream whose prefix horizons
dominate each rank.
-/
def D04GreedyFirstFitMatchingCofinalEstimate
    (rel : ConcreteSelectedRecordRelation)
    (data : ConcreteOrderedReasonCandidates rel.toSelectedRecordSource)
    (_hInc : D04GoodStartSemiprimeIncidenceLowerBound modifiedGreedyD04SourceLocalInputs)
    (_hDistinct :
      D04DistinctLabelLowerBoundFromFiniteAdapters modifiedGreedyD04SourceLocalInputs) :
    Prop :=
  ∃ matching : D04GreedyFirstFitMatchingCofinal rel data, True

/--
Projection from the source-local rank-stream input to the D04 cofinal first-fit
stream.  The false arbitrary-relation target is deliberately not stated here:
for the old empty concrete relation, cofinality was contradictory.  The
prefix-growth/density-one content is the separate `D04BarrierRankStreamSource`
input, not the ordered scan bridge.
-/
theorem barrierOfRankD04_prefix_lower_bound
    (pkg : D04ConcreteFirstAvailableSelectedRecordSource)
    (stream : D04BarrierRankStreamSource pkg.rel pkg.data)
    (_hInc :
      D04GoodStartSemiprimeIncidenceLowerBound modifiedGreedyD04SourceLocalInputs)
    (_hDistinct :
      D04DistinctLabelLowerBoundFromFiniteAdapters modifiedGreedyD04SourceLocalInputs) :
    ∃ matching : D04GreedyFirstFitMatchingCofinal pkg.rel pkg.data, True := by
  exact ⟨D04GreedyFirstFitMatchingCofinal.fromRankStream stream, trivial⟩

/--
The remaining D04 rank-stream source obligation.

This is the prefix-growth/density-one argument following the finite
first-available scan: selected barriers must admit a strictly increasing
ranked stream whose accepted prefix before each barrier has length exceeding
the rank.  It is intentionally separate from `main.tex:487-528`.
-/
-- NOTE: the concrete relation is no longer provably empty (its source is now
-- axiomatized in `D04ConcreteFirstAvailableSelectedRecordSource_from_MTIncidenceAndUnmatchedSparsity`),
-- so the former theorems `modifiedGreedyD04SelectedRecordRelation_no_selectedBarrier`
-- and `no_modifiedGreedyD04BarrierRankStreamSource_prefixGrowthDensityOne`
-- (which derived `False` from any barrier stream) have been removed.  The barrier
-- stream axiom below is now consistent with the rest of the development.

axiom modifiedGreedyD04BarrierRankStreamSource_prefixGrowthDensityOne :
  D04BarrierRankStreamSource modifiedGreedyD04SelectedRecordRelation
    modifiedGreedyD04OrderedReasonCandidates

noncomputable def modifiedGreedyD04GreedyFirstFitMatchingCofinal
    (hMT :
      ∀ (logp : StructuredMTLogPowerProxy) (mt : StructuredMTConstantProxy)
        {shell : ConcreteDyadicShell}
        (windowLengthForShell : Nat)
        (block : ConcreteFullBlock)
        (h_shell : block.shell = shell)
        (h_large : shell.largeEnough)
        (h_full : block.fullBlock)
        (h_nonbad : D04MTNonbadFullBlock block),
          D04_E2_nonbad_exceptional_starts_half_bound_structured
            logp mt windowLengthForShell block h_shell h_large h_full h_nonbad) :
  D04GreedyFirstFitMatchingCofinal modifiedGreedyD04SelectedRecordRelation
    modifiedGreedyD04OrderedReasonCandidates :=
  let _mt := hMT
  D04GreedyFirstFitMatchingCofinal.fromRankStream
    modifiedGreedyD04BarrierRankStreamSource_prefixGrowthDensityOne

noncomputable def barrierOfRankD04 (r : Nat) : Nat :=
  (modifiedGreedyD04GreedyFirstFitMatchingCofinal @MT_E2_count).barrierOfRank r

theorem barrierOfRankD04_selected (r : Nat) :
    modifiedGreedyPrivateBarrierDeletionSet.selectedBarrier (barrierOfRankD04 r) := by
  unfold barrierOfRankD04 modifiedGreedyPrivateBarrierDeletionSet
  exact
    (modifiedGreedyD04GreedyFirstFitMatchingCofinal
      @MT_E2_count).selected_of_rank r

theorem barrierOfRankD04_label_provenance (r : Nat) :
    ∃ label : PrivateBarrierLabel,
      modifiedGreedyPrivateBarrierDeletionSet.selectedLabel (barrierOfRankD04 r) = some label ∧
        label.barrier = barrierOfRankD04 r ∧
        label.shell =
          (modifiedGreedyD04GreedyFirstFitMatchingCofinal @MT_E2_count).shellOfRank r ∧
        label.block =
          (modifiedGreedyD04GreedyFirstFitMatchingCofinal @MT_E2_count).blockOfRank r := by
  unfold barrierOfRankD04 modifiedGreedyPrivateBarrierDeletionSet
  exact
    (modifiedGreedyD04GreedyFirstFitMatchingCofinal
      @MT_E2_count).label_provenance r

theorem barrierOfRankD04_strictMono :
    StrictlyIncreasing barrierOfRankD04 := by
  unfold barrierOfRankD04
  exact
    (modifiedGreedyD04GreedyFirstFitMatchingCofinal
      @MT_E2_count).rank_ordered

theorem barrierOfRankD04_distinct :
    ∀ r s : Nat, barrierOfRankD04 r = barrierOfRankD04 s -> r = s := by
  unfold barrierOfRankD04
  exact
    (modifiedGreedyD04GreedyFirstFitMatchingCofinal
      @MT_E2_count).rank_distinct

theorem modifiedGreedyD04UnmatchedBlockBoundByLabelIncidenceCounting :
  D04UnmatchedBlockBoundByLabelIncidenceCounting modifiedGreedyD04SelectedRecordRelation :=
  modifiedGreedyD04FirstAvailableSelectedRecordSource.unmatched_bound

noncomputable def modifiedGreedyPrivateBarrierSelectedOccurrenceSupply :
  PrivateBarrierSelectedOccurrenceSupply modifiedGreedyPrivateBarrierDeletionSet := by
  unfold modifiedGreedyPrivateBarrierDeletionSet
  exact construct_SelectedRecordOccurrenceSupply_from_MT_E2_count
    @MT_E2_count
    modifiedGreedyD04MTE2ShellFacts
    modifiedGreedyD04SourceLocalInputs
    modifiedGreedyD04SelectedRecordRelation
    modifiedGreedyD04OrderedReasonCandidates
    modifiedGreedyD04BadBlockTotalLengthFromMTE2Count
    modifiedGreedyD04GoodStartSemiprimeIncidenceLowerBound
    modifiedGreedyD04FixedSemiprimeFiberBound
    modifiedGreedyD04FixedPrivateLabelFiberBound
    modifiedGreedyD04DistinctLabelLowerBoundFromFiniteAdapters
    (modifiedGreedyD04GreedyFirstFitMatchingCofinal @MT_E2_count)
    modifiedGreedyD04UnmatchedBlockBoundByLabelIncidenceCounting

theorem modifiedGreedyPrivateBarrierSelectedOccurrenceAbundant :
  PrivateBarrierSelectedOccurrenceAbundant modifiedGreedyPrivateBarrierDeletionSet :=
  privateBarrierSelectedOccurrenceAbundant_fromSupply
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierSelectedOccurrenceSupply

/--
Remaining product-factorization interface for old accepted products.  This is
narrower than old-product nondivisibility: the finite horizon deletion
contradiction is proved in Lean from this factor-divisibility statement and
`PrivateBarrierArithmetic`.
-/
theorem modifiedGreedyPrivateBarrierSelectedOldProductFactorDivisor :
  PrivateBarrierArithmetic modifiedGreedyPrivateBarrierDeletionSet ->
    PrivateBarrierSelectedOldProductFactorDivisor
      modifiedGreedyPrivateBarrierDeletionSet :=
  privateBarrierSelectedOldProductFactorDivisor_fromPrimeLike
    modifiedGreedyPrivateBarrierDeletionSet

theorem modifiedGreedyPrivateBarrierSelectedOldProductNotPrivateDivisible :
  PrivateBarrierArithmetic modifiedGreedyPrivateBarrierDeletionSet ->
    PrivateBarrierSelectedOldProductNotPrivateDivisible
      modifiedGreedyPrivateBarrierDeletionSet :=
  fun harith =>
    privateBarrierSelectedOldProductNotPrivateDivisible_fromFactorDivisor
      modifiedGreedyPrivateBarrierDeletionSet
      harith
      (modifiedGreedyPrivateBarrierSelectedOldProductFactorDivisor harith)

theorem modifiedGreedyPrivateBarrierSelectedOldNewDivisibilityObstruction :
  PrivateBarrierArithmetic modifiedGreedyPrivateBarrierDeletionSet ->
    PrivateBarrierSelectedOldNewDivisibilityObstruction
      modifiedGreedyPrivateBarrierDeletionSet :=
  fun harith =>
    privateBarrierSelectedOldNewDivisibilityObstruction_fromOldProduct
      modifiedGreedyPrivateBarrierDeletionSet
      harith
      (modifiedGreedyPrivateBarrierSelectedOldProductNotPrivateDivisible harith)

theorem modifiedGreedyPrivateBarrierSelectedFinalSuffixProductInjective :
  PrivateBarrierArithmetic modifiedGreedyPrivateBarrierDeletionSet ->
    ∀ b : Nat, modifiedGreedyPrivateBarrierDeletionSet.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        privateBarrierFinalSuffixProduct xs u =
          privateBarrierFinalSuffixProduct xs u' ->
        u = u' := by
  intro _harith b _hb
  dsimp only
  let xs := modifiedGreedyAcceptedPrefixFromDeletion
    modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 3)
  have hxs_greedy : ModifiedGreedyPrefix xs := by
    simpa [xs] using
      modifiedGreedyAcceptedPrefixFromDeletion_greedy
        modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 3)
  have hxs_distinct : FiniteDistinctConsecutiveBlockProducts xs :=
    modifiedGreedyUniqueness xs hxs_greedy
  have hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1 := by
    intro i hi
    have hmem : xs.getD i 1 ∈ xs := getD_mem_of_lt hi
    simpa [xs] using
      modifiedGreedyAcceptedPrefixFromDeletion_mem_two_le
        modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 3)
        (xs.getD i 1) hmem
  change
    ∀ u u' : Nat,
      u ≤ xs.length ->
        u' ≤ xs.length ->
          privateBarrierFinalSuffixProduct xs u =
            privateBarrierFinalSuffixProduct xs u' ->
          u = u'
  intro u u' hu hu' hprod
  by_cases hult : u < xs.length
  · by_cases hu'lt : u' < xs.length
    · have hprod_fin :
          finiteBlockProduct xs u (xs.length - 1) =
            finiteBlockProduct xs u' (xs.length - 1) := by
        simpa [privateBarrierFinalSuffixProduct, hult, hu'lt] using hprod
      have huv : u ≤ xs.length - 1 := by omega
      have huv' : u' ≤ xs.length - 1 := by omega
      have hv : xs.length - 1 < xs.length := by omega
      exact (hxs_distinct u (xs.length - 1) u' (xs.length - 1)
        huv hv huv' hv hprod_fin).1
    · have hu'eq : u' = xs.length := by omega
      have hprod_fin :
          finiteBlockProduct xs u (xs.length - 1) = 1 := by
        simpa [privateBarrierFinalSuffixProduct, hult, hu'lt, hu'eq] using hprod
      have huv : u ≤ xs.length - 1 := by omega
      have hv : xs.length - 1 < xs.length := by omega
      have htwo :
          2 ≤ finiteBlockProduct xs u (xs.length - 1) :=
        finiteBlockProduct_two_le_of_nonempty_entries_two_le hentries huv hv
      omega
  · have hueq : u = xs.length := by omega
    by_cases hu'lt : u' < xs.length
    · have hprod_fin :
          1 = finiteBlockProduct xs u' (xs.length - 1) := by
        simpa [privateBarrierFinalSuffixProduct, hult, hueq, hu'lt] using hprod
      have huv' : u' ≤ xs.length - 1 := by omega
      have hv : xs.length - 1 < xs.length := by omega
      have htwo :
          2 ≤ finiteBlockProduct xs u' (xs.length - 1) :=
        finiteBlockProduct_two_le_of_nonempty_entries_two_le hentries huv' hv
      omega
    · have hu'eq : u' = xs.length := by omega
      exact hueq.trans hu'eq.symm

theorem modifiedGreedyPrivateBarrierSelectedFinalSuffixCancellation :
  PrivateBarrierArithmetic modifiedGreedyPrivateBarrierDeletionSet ->
    PrivateBarrierSelectedFinalSuffixCancellation
      modifiedGreedyPrivateBarrierDeletionSet
  := by
  intro harith
  refine
    { terminal_factor_cancellation :=
        privateBarrierSelectedTerminalFactorCancellation
          modifiedGreedyPrivateBarrierDeletionSet harith
      final_suffix_product_injective := ?_ }
  exact modifiedGreedyPrivateBarrierSelectedFinalSuffixProductInjective harith

theorem modifiedGreedyPrivateBarrierSelectedOldNewCollisionFreeFromArithmetic :
    ∀ b : Nat, modifiedGreedyPrivateBarrierDeletionSet.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 3)
      ∀ u v u' : Nat,
        u ≤ v ->
        v < xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u v ≠
          finiteBlockProduct (xs ++ [b]) u' xs.length :=
  privateBarrierSelectedOldNewCollisionFree_fromDivisibilityObstruction
    modifiedGreedyPrivateBarrierDeletionSet
    (modifiedGreedyPrivateBarrierSelectedOldNewDivisibilityObstruction
      modifiedGreedyPrivateBarrierArithmetic)

/--
Final-suffix selected-barrier cancellation sub-obligation.  The collision-free
new-new statement below is derived from this narrower interface.
-/
theorem modifiedGreedyPrivateBarrierSelectedNewNewCollisionFreeFromArithmetic :
    ∀ b : Nat, modifiedGreedyPrivateBarrierDeletionSet.selectedBarrier b ->
      let xs := modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 3)
      ∀ u u' : Nat,
        u ≤ xs.length ->
        u' ≤ xs.length ->
        finiteBlockProduct (xs ++ [b]) u xs.length =
          finiteBlockProduct (xs ++ [b]) u' xs.length ->
        u = u' :=
  privateBarrierSelectedNewNewCollisionFree_fromFinalSuffixCancellation
    modifiedGreedyPrivateBarrierDeletionSet
    (modifiedGreedyPrivateBarrierSelectedFinalSuffixCancellation
      modifiedGreedyPrivateBarrierArithmetic)

theorem modifiedGreedyPrivateBarrierSelectedCollisionOrientedRemainder :
    PrivateBarrierSelectedCollisionOrientedRemainder modifiedGreedyPrivateBarrierDeletionSet :=
  { old_new_collision_free :=
      modifiedGreedyPrivateBarrierSelectedOldNewCollisionFreeFromArithmetic
    new_new_collision_free :=
      modifiedGreedyPrivateBarrierSelectedNewNewCollisionFreeFromArithmetic }

theorem modifiedGreedyPrivateBarrierSelectedCollisionRemainder :
    PrivateBarrierSelectedCollisionRemainder modifiedGreedyPrivateBarrierDeletionSet :=
  privateBarrierSelectedCollisionRemainder_fromOriented
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierSelectedCollisionOrientedRemainder

theorem modifiedGreedyPrivateBarrierSelectedCollisionFragments :
  PrivateBarrierSelectedCollisionFragments modifiedGreedyPrivateBarrierDeletionSet :=
  privateBarrierSelectedCollisionFragments_fromRemainder
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierArithmetic
    modifiedGreedyPrivateBarrierSelectedCollisionRemainder

theorem modifiedGreedyPrivateBarrierSelectedCollisionFreeAtScan :
  PrivateBarrierSelectedCollisionFreeAtScan modifiedGreedyPrivateBarrierDeletionSet :=
  privateBarrierSelectedCollisionFreeAtScan_fromFragments
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierSelectedCollisionFragments

theorem modifiedGreedyPrivateBarrierSelectedAcceptedAtHorizon :
  PrivateBarrierSelectedAcceptedAtHorizon modifiedGreedyPrivateBarrierDeletionSet :=
  privateBarrierSelectedAcceptedAtHorizon_fromCollisionFree
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierSelectedCollisionFreeAtScan

theorem modifiedGreedyPrivateBarrierSelectedAcceptedPrefixAbundant :
  ∀ i : Nat,
    ∃ b : Nat,
      modifiedGreedyPrivateBarrierDeletionSet.selectedBarrier b ∧
      i < (modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted (b - 2)).length :=
  privateBarrierSelectedAcceptedPrefixAbundant_fromSplit
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierSelectedOccurrenceAbundant
    modifiedGreedyPrivateBarrierSelectedAcceptedAtHorizon

theorem modifiedGreedyPrivateBarrierAcceptedPrefixCofinal :
  ∀ i : Nat,
    ∃ m : Nat,
      i < (modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted m).length :=
  privateBarrierAcceptedPrefixCofinal_fromSelection
    modifiedGreedyPrivateBarrierDeletionSet
    modifiedGreedyPrivateBarrierSelectedAcceptedPrefixAbundant

theorem modifiedGreedyOrderedEnumeration :
    ModifiedGreedyOrderedEnumeration modifiedGreedyPrivateBarrierDeletionSet.Deleted :=
  { indexAppearsInPrefix := modifiedGreedyPrivateBarrierAcceptedPrefixCofinal }

noncomputable def modifiedGreedyEnumeratingSequence : Nat -> Nat :=
  orderedEnumerationFromCofinal modifiedGreedyPrivateBarrierDeletionSet.Deleted
    modifiedGreedyOrderedEnumeration.indexAppearsInPrefix

def modifiedGreedyAcceptedPredicate : Nat -> Prop :=
  AcceptedByScan modifiedGreedyPrivateBarrierDeletionSet.Deleted

def modifiedGreedyRejectedPredicate : Nat -> Prop :=
  RejectedByScan modifiedGreedyPrivateBarrierDeletionSet.Deleted

noncomputable def modifiedGreedyConstructionData : ModifiedGreedyConstructionData :=
  { d := modifiedGreedyEnumeratingSequence
    D := modifiedGreedyPrivateBarrierDeletionSet.Deleted
    Accepted := modifiedGreedyAcceptedPredicate
    Rejected := modifiedGreedyRejectedPredicate
    EmptySuffixRejected := modifiedGreedyEmptySuffixRejectedPredicate
    NonemptyRejected := modifiedGreedyNonemptyRejectedPredicate
    SmoothException := modifiedGreedySmoothExceptionPredicate
    TerminalSlabException := modifiedGreedyTerminalSlabExceptionPredicate
    acceptedPrefix :=
      modifiedGreedyAcceptedPrefixFromDeletion modifiedGreedyPrivateBarrierDeletionSet.Deleted
    acceptedPrefix_def := fun _ => rfl }

theorem modifiedGreedySmoothException_of_nonemptyWitness
    (witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData)
    (hsm : modifiedGreedyEndpointSmooth witness.n) :
    modifiedGreedyConstructionData.SmoothException witness.n := by
  have h : modifiedGreedySmoothExceptionPredicate witness.n := by
    right
    exact
      ⟨⟨{ witness := witness.toCanonical
          witness_endpoint := rfl
          dyadicShell := witness.n
          smooth_bound := True },
         trivial⟩, hsm⟩
  simpa [modifiedGreedyConstructionData] using h

theorem modifiedGreedyTerminalSlab_of_nonemptyWitness
    (witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData)
    (hnsm : ¬ modifiedGreedyEndpointSmooth witness.n) :
    modifiedGreedyConstructionData.TerminalSlabException witness.n := by
  have h : modifiedGreedyTerminalSlabExceptionPredicate witness.n := by
    exact
      ⟨⟨{ witness := witness.toCanonical
          witness_endpoint := rfl
          dyadicShell := witness.n
          slab_counted := True },
         trivial⟩, hnsm⟩
  simpa [modifiedGreedyConstructionData] using h

/-- Honest smooth/terminal-slab dichotomy: every nonempty-rejection endpoint is
either `Y_X`-smooth (charged to the Dickman family) or not (charged to the
shifted-CRT/CCDN terminal-slab family).  This is genuine excluded middle on
`modifiedGreedyEndpointSmooth`, replacing the former routing that sent *every*
witness into the smooth family via `smooth_bound := True`. -/
theorem modifiedGreedyWitnessSmoothOrTerminal
    (witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData) :
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n :=
  (Classical.em (modifiedGreedyEndpointSmooth witness.n)).imp
    (modifiedGreedySmoothException_of_nonemptyWitness witness)
    (modifiedGreedyTerminalSlab_of_nonemptyWitness witness)

theorem modifiedGreedyEnumerationCofinal :
    ModifiedGreedyEnumerationCofinal modifiedGreedyConstructionData :=
  { indexAppearsInPrefix := modifiedGreedyOrderedEnumeration.indexAppearsInPrefix }

theorem modifiedGreedyPrefixOrderBridge :
    ModifiedGreedyPrefixOrderBridge modifiedGreedyConstructionData :=
  { prefixStrict :=
      modifiedGreedyAcceptedPrefixFromDeletion_index_strict
        modifiedGreedyPrivateBarrierDeletionSet.Deleted }

theorem modifiedGreedyScanStepRelational :
  ∀ m : Nat,
    ∃ decision : ScanDecision,
      ModifiedGreedyScanStep (modifiedGreedyConstructionData.acceptedPrefix m) (m + 3)
        (modifiedGreedyConstructionData.acceptedPrefix (m + 1)) decision :=
  modifiedGreedyAcceptedPrefixFromDeletion_step modifiedGreedyPrivateBarrierDeletionSet.Deleted

theorem modifiedGreedyScanPrefixGreedy :
    ∀ m : Nat, ModifiedGreedyPrefix (modifiedGreedyConstructionData.acceptedPrefix m) :=
  modifiedGreedyAcceptedPrefixFromDeletion_greedy modifiedGreedyPrivateBarrierDeletionSet.Deleted

theorem modifiedGreedyScanPrefixEnumeratesD :
  ∀ m i : Nat, i < (modifiedGreedyConstructionData.acceptedPrefix m).length ->
    (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 =
      modifiedGreedyConstructionData.d i := by
  exact orderedEnumerationFromCofinal_prefixEnumerates
    modifiedGreedyPrivateBarrierDeletionSet.Deleted
    modifiedGreedyOrderedEnumeration.indexAppearsInPrefix

theorem modifiedGreedyScanPrefixCoversBlocks :
    ∀ u v : Nat,
      u ≤ v ->
        ∃ m : Nat,
          v < (modifiedGreedyConstructionData.acceptedPrefix m).length ∧
            ∀ u' v' : Nat,
              u' ≤ v' ->
                v' < (modifiedGreedyConstructionData.acceptedPrefix m).length ->
                  finiteBlockProduct (modifiedGreedyConstructionData.acceptedPrefix m) u' v' =
                    blockProduct modifiedGreedyConstructionData.d u' v' := by
  intro _u v _huv
  rcases modifiedGreedyEnumerationCofinal.indexAppearsInPrefix v with ⟨m, hm⟩
  refine ⟨m, hm, ?_⟩
  intro u' v' huv' hv'
  exact finiteBlockProduct_eq_blockProduct_of_prefixEnumerates
    (fun i hi => modifiedGreedyScanPrefixEnumeratesD m i hi) huv' hv'

theorem modifiedGreedyScanAcceptedExactlyEnumerated :
  ∀ n : Nat, modifiedGreedyConstructionData.Accepted n ↔
    ∃ i : Nat, modifiedGreedyConstructionData.d i = n := by
  intro n
  constructor
  · intro hn
    rcases hn with ⟨m, hmem⟩
    rcases exists_getD_eq_of_mem hmem with ⟨i, hi, hget⟩
    refine ⟨i, ?_⟩
    have henum :
        (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 =
          modifiedGreedyConstructionData.d i :=
      modifiedGreedyScanPrefixEnumeratesD m i hi
    rw [← henum]
    simpa [modifiedGreedyConstructionData] using hget
  · intro hn
    rcases hn with ⟨i, hd⟩
    rcases modifiedGreedyOrderedEnumeration.indexAppearsInPrefix i with ⟨m, hm⟩
    refine ⟨m, ?_⟩
    have hmem :
        (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 ∈
          modifiedGreedyConstructionData.acceptedPrefix m :=
      getD_mem_of_lt hm
    have henum :
        (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 =
          modifiedGreedyConstructionData.d i :=
      modifiedGreedyScanPrefixEnumeratesD m i hm
    rwa [henum, hd] at hmem

theorem modifiedGreedyScanRejectedExactlyNotAccepted :
  ∀ n : Nat, modifiedGreedyConstructionData.Rejected n ↔
    ¬ modifiedGreedyConstructionData.Accepted n := by
  intro n
  rfl

theorem modifiedGreedyScanPositiveEnumerated :
    ∀ i : Nat, 0 < modifiedGreedyConstructionData.d i := by
  intro i
  rcases modifiedGreedyEnumerationCofinal.indexAppearsInPrefix i with ⟨m, hm⟩
  have hmem :
      (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 ∈
        modifiedGreedyConstructionData.acceptedPrefix m :=
    getD_mem_of_lt hm
  have hpos :
      0 < (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 :=
    modifiedGreedyAcceptedPrefixFromDeletion_mem_positive
      modifiedGreedyPrivateBarrierDeletionSet.Deleted m
      ((modifiedGreedyConstructionData.acceptedPrefix m).getD i 1) hmem
  have henum :
      (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 =
        modifiedGreedyConstructionData.d i :=
    modifiedGreedyScanPrefixEnumeratesD m i hm
  rwa [henum] at hpos

theorem modifiedGreedyScanIndexAddTwoLeEnumerated :
    ∀ i : Nat, i + 2 ≤ modifiedGreedyConstructionData.d i := by
  intro i
  rcases modifiedGreedyEnumerationCofinal.indexAppearsInPrefix i with ⟨m, hm⟩
  have hprefix :
      i + 2 ≤
        (modifiedGreedyAcceptedPrefixFromDeletion
          modifiedGreedyPrivateBarrierDeletionSet.Deleted m).getD i 1 :=
    modifiedGreedyAcceptedPrefixFromDeletion_getD_index_add_two_le
      modifiedGreedyPrivateBarrierDeletionSet.Deleted m i hm
  have henum :
      (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 =
        modifiedGreedyConstructionData.d i :=
    modifiedGreedyScanPrefixEnumeratesD m i hm
  rw [← henum]
  simpa [modifiedGreedyConstructionData] using hprefix

theorem modifiedGreedyScanStrictlyEnumerated :
    StrictlyIncreasing modifiedGreedyConstructionData.d := by
  intro i j hij
  rcases modifiedGreedyEnumerationCofinal.indexAppearsInPrefix j with ⟨m, hmj⟩
  have hmi : i < (modifiedGreedyConstructionData.acceptedPrefix m).length :=
    Nat.lt_trans hij hmj
  have hprefix :
      (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 <
        (modifiedGreedyConstructionData.acceptedPrefix m).getD j 1 :=
    modifiedGreedyPrefixOrderBridge.prefixStrict m i j hij hmj
  have henum_i :
      (modifiedGreedyConstructionData.acceptedPrefix m).getD i 1 =
        modifiedGreedyConstructionData.d i :=
    modifiedGreedyScanPrefixEnumeratesD m i hmi
  have henum_j :
      (modifiedGreedyConstructionData.acceptedPrefix m).getD j 1 =
        modifiedGreedyConstructionData.d j :=
    modifiedGreedyScanPrefixEnumeratesD m j hmj
  rwa [henum_i, henum_j] at hprefix

theorem modifiedGreedyScanData : ModifiedGreedyScan modifiedGreedyConstructionData :=
  { stepRelational := modifiedGreedyScanStepRelational
    prefixGreedy := modifiedGreedyScanPrefixGreedy
    prefixEnumeratesD := modifiedGreedyScanPrefixEnumeratesD
    prefixCoversBlocks := modifiedGreedyScanPrefixCoversBlocks
    acceptedExactlyEnumerated := modifiedGreedyScanAcceptedExactlyEnumerated
    rejectedExactlyNotAccepted := modifiedGreedyScanRejectedExactlyNotAccepted
    positiveEnumerated := modifiedGreedyScanPositiveEnumerated
    strictlyEnumerated := modifiedGreedyScanStrictlyEnumerated }

theorem modifiedGreedyPrefixUniquenessBridge
    (data : ModifiedGreedyConstructionData) :
    ModifiedGreedyUniqueness -> PrefixCompatibleWithGreedy data.acceptedPrefix data.d ->
      DistinctConsecutiveBlockProducts data.d := by
  intro huniq hprefix u v u' v' huv huv' hprod
  rcases hprefix with ⟨hprefixGreedy, _hprefixEnum, hblock⟩
  let M := max v v'
  have hzeroM : 0 ≤ M := Nat.zero_le M
  rcases hblock 0 M hzeroM with ⟨m, hMlen, hprefixBlock⟩
  have hvM : v ≤ M := Nat.le_max_left v v'
  have hv'M : v' ≤ M := Nat.le_max_right v v'
  have hvlen : v < (data.acceptedPrefix m).length :=
    Nat.lt_of_le_of_lt hvM hMlen
  have hv'len : v' < (data.acceptedPrefix m).length :=
    Nat.lt_of_le_of_lt hv'M hMlen
  have hfinite :
      finiteBlockProduct (data.acceptedPrefix m) u v =
        finiteBlockProduct (data.acceptedPrefix m) u' v' := by
    rw [hprefixBlock u v huv hvlen, hprefixBlock u' v' huv' hv'len]
    exact hprod
  exact huniq (data.acceptedPrefix m) (hprefixGreedy m) u v u' v' huv hvlen huv' hv'len hfinite

theorem modifiedGreedyAcceptedPredicateEnumeration :
    PredicateMatchesEnumeration modifiedGreedyConstructionData.Accepted
      modifiedGreedyConstructionData.d := by
  constructor
  · intro i
    exact (modifiedGreedyScanData.acceptedExactlyEnumerated (modifiedGreedyConstructionData.d i)).2
      ⟨i, rfl⟩
  · intro n hn
    exact (modifiedGreedyScanData.acceptedExactlyEnumerated n).1 hn

theorem modifiedGreedyAcceptRejectPartition :
    AcceptRejectPartition modifiedGreedyConstructionData.Accepted
      modifiedGreedyConstructionData.Rejected := by
  constructor
  · intro n hacc hrej
    exact ((modifiedGreedyScanData.rejectedExactlyNotAccepted n).1 hrej) hacc
  · intro n
    by_cases hacc : modifiedGreedyConstructionData.Accepted n
    · exact Or.inl hacc
    · exact Or.inr ((modifiedGreedyScanData.rejectedExactlyNotAccepted n).2 hacc)

theorem modifiedGreedyPositive :
    ∀ i : Nat, 0 < modifiedGreedyConstructionData.d i :=
  modifiedGreedyScanData.positiveEnumerated

theorem modifiedGreedyStrict :
    StrictlyIncreasing modifiedGreedyConstructionData.d :=
  modifiedGreedyScanData.strictlyEnumerated

theorem modifiedGreedyPrefixCompatibility :
    PrefixCompatibleWithGreedy modifiedGreedyConstructionData.acceptedPrefix
      modifiedGreedyConstructionData.d :=
  ⟨modifiedGreedyScanData.prefixGreedy,
    modifiedGreedyScanData.prefixEnumeratesD,
    modifiedGreedyScanData.prefixCoversBlocks⟩

theorem modifiedGreedyDensityBridge :
  DensityZeroSet modifiedGreedyConstructionData.Rejected ->
    PredicateMatchesEnumeration modifiedGreedyConstructionData.Accepted
      modifiedGreedyConstructionData.d ->
        UnderlyingSetHasNaturalDensityOne modifiedGreedyConstructionData.d := by
  intro hrejected henum
  exact densityBridge_from_rejected
    modifiedGreedyConstructionData.Accepted
    modifiedGreedyConstructionData.Rejected
    modifiedGreedyConstructionData.d
    hrejected
    henum
    modifiedGreedyScanData.rejectedExactlyNotAccepted

theorem modifiedGreedyConstructionLaws :
    ModifiedGreedyConstructionLaws modifiedGreedyConstructionData :=
  { acceptedPredicateEnumeration := modifiedGreedyAcceptedPredicateEnumeration
    acceptRejectPartition := modifiedGreedyAcceptRejectPartition
    positive := modifiedGreedyPositive
    strict := modifiedGreedyStrict
    prefixCompatibility := modifiedGreedyPrefixCompatibility
    prefixUniquenessBridge := modifiedGreedyPrefixUniquenessBridge modifiedGreedyConstructionData
    densityBridge := modifiedGreedyDensityBridge }

/--
The concrete nonempty predicate is canonical by definition, so the witness
interface is no longer an external theorem boundary.
-/
theorem modifiedGreedyNonemptyRejectedWitnessInterface :
    NonemptyRejectedWitnessInterface modifiedGreedyConstructionData :=
  { witness_iff := by
      intro n
      constructor
      · intro h
        rcases h with ⟨w, hw⟩
        exact ⟨w.toNonempty modifiedGreedyConstructionData, hw⟩
      · intro h
        rcases h with ⟨w, hw⟩
        exact ⟨w.toCanonical, hw⟩ }

/--
Forced-deletion density (Proposition 3.11 / `main.tex:531-586`, "Prefix
deletions" and "Finite-horizon multiples"): the deterministic deletion set `D`
has density zero.  This was previously "proved" only because the concrete
relation was empty (`D ⊆ ∅`); with the relation now axiomatized as nonempty
(see `D04ConcreteFirstAvailableSelectedRecordSource_from_MTIncidenceAndUnmatchedSparsity`)
that trivial proof no longer applies, so this genuine Section 4 obligation — the
dyadic horizon-multiple sum dominated by the last shell, with exponent
`s = β - 1.1 > 1` — is recorded as an axiom.
-/
axiom modifiedGreedyForcedDeletionFiniteEstimate :
  SparseCountingEstimate modifiedGreedyConstructionData.D

theorem modifiedGreedyForcedDeletionDensityZero :
  DensityZeroSet modifiedGreedyConstructionData.D :=
  forcedDeletionDensityZero_from_finiteEstimate
    modifiedGreedyConstructionData.D
    modifiedGreedyForcedDeletionFiniteEstimate

def modifiedGreedyOldFiniteBlockProducts (n : Nat) : Prop :=
  ∃ _oldProduct : EmptySuffixOldBlockProductData n, True

theorem modifiedGreedyOldFiniteBlockProduct_two_pow_length_le
    {n : Nat} (oldProduct : EmptySuffixOldBlockProductData n) :
    2 ^ (oldProduct.v + 1 - oldProduct.u) ≤ n := by
  let xs :=
    modifiedGreedyAcceptedPrefixFromDeletion
      modifiedGreedyPrivateBarrierDeletionSet.Deleted oldProduct.horizon
  have hlower :
      2 ^ (oldProduct.v + 1 - oldProduct.u) ≤
        finiteBlockProduct xs oldProduct.u oldProduct.v := by
    apply finiteBlockProduct_pow_lower_of_range_two_le
    intro i _hui hiv
    have hi_len : i < xs.length := by
      exact Nat.lt_of_le_of_lt hiv oldProduct.old_in_prefix
    exact
      modifiedGreedyAcceptedPrefixFromDeletion_getD_two_le
        modifiedGreedyPrivateBarrierDeletionSet.Deleted oldProduct.horizon i hi_len
  simpa [xs, oldProduct.old_product_eq] using hlower

theorem modifiedGreedyOldFiniteBlockProduct_start_index_mul_le
    {n : Nat} (oldProduct : EmptySuffixOldBlockProductData n) :
    (oldProduct.u + 2) * (oldProduct.u + 3) ≤ n := by
  let xs :=
    modifiedGreedyAcceptedPrefixFromDeletion
      modifiedGreedyPrivateBarrierDeletionSet.Deleted oldProduct.horizon
  have hpos : ∀ i : Nat, 0 < xs.getD i 1 := by
    intro i
    by_cases hi : i < xs.length
    · have hmem : xs.getD i 1 ∈ xs := getD_mem_of_lt hi
      exact
        modifiedGreedyAcceptedPrefixFromDeletion_mem_positive
          modifiedGreedyPrivateBarrierDeletionSet.Deleted oldProduct.horizon
          (xs.getD i 1) hmem
    · simp [xs, List.getD, hi]
  have hu_len : oldProduct.u < xs.length := by
    exact Nat.lt_of_le_of_lt oldProduct.old_range oldProduct.old_in_prefix
  have hu1_len : oldProduct.u + 1 < xs.length := by
    have hu1v : oldProduct.u + 1 ≤ oldProduct.v := oldProduct.block_length_at_least_two
    exact Nat.lt_of_le_of_lt hu1v oldProduct.old_in_prefix
  have hA :
      oldProduct.u + 2 ≤ xs.getD oldProduct.u 1 := by
    exact
      modifiedGreedyAcceptedPrefixFromDeletion_getD_index_add_two_le
        modifiedGreedyPrivateBarrierDeletionSet.Deleted oldProduct.horizon
        oldProduct.u hu_len
  have hB :
      oldProduct.u + 3 ≤ xs.getD (oldProduct.u + 1) 1 := by
    simpa [Nat.add_assoc] using
      modifiedGreedyAcceptedPrefixFromDeletion_getD_index_add_two_le
        modifiedGreedyPrivateBarrierDeletionSet.Deleted oldProduct.horizon
        (oldProduct.u + 1) hu1_len
  have hlower :
      (oldProduct.u + 2) * (oldProduct.u + 3) ≤
        finiteBlockProduct xs oldProduct.u oldProduct.v :=
    finiteBlockProduct_first_two_le
      oldProduct.block_length_at_least_two hpos hA hB
  simpa [xs, oldProduct.old_product_eq] using hlower

theorem modifiedGreedyEmptySuffix_subset_oldFiniteBlockProducts :
  ∀ n : Nat,
    modifiedGreedyConstructionData.EmptySuffixRejected n ->
      modifiedGreedyOldFiniteBlockProducts n := by
  intro n hn
  simpa [modifiedGreedyConstructionData, modifiedGreedyOldFiniteBlockProducts,
    modifiedGreedyEmptySuffixRejectedPredicate] using hn

/-- Horizon-independence of the accepted-prefix block product: the product over
a fixed index window `[u,v]` does not depend on the scan horizon, as long as `v`
is within both prefixes.  This is what makes the endpoint-to-`(u,ℓ)` map
injective. -/
theorem blockProduct_horizon_indep (u v h1 h2 : Nat)
    (hv1 : v < (modifiedGreedyAcceptedPrefixFromDeletion
              modifiedGreedyPrivateBarrierDeletionSet.Deleted h1).length)
    (hv2 : v < (modifiedGreedyAcceptedPrefixFromDeletion
              modifiedGreedyPrivateBarrierDeletionSet.Deleted h2).length) :
    finiteBlockProduct (modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted h1) u v
      = finiteBlockProduct (modifiedGreedyAcceptedPrefixFromDeletion
        modifiedGreedyPrivateBarrierDeletionSet.Deleted h2) u v := by
  obtain ⟨zs1, hzs1⟩ := modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono
    modifiedGreedyPrivateBarrierDeletionSet.Deleted (Nat.le_max_left h1 h2)
  obtain ⟨zs2, hzs2⟩ := modifiedGreedyAcceptedPrefixFromDeletion_prefix_mono
    modifiedGreedyPrivateBarrierDeletionSet.Deleted (Nat.le_max_right h1 h2)
  have e1 := finiteBlockProduct_append_left (xs := modifiedGreedyAcceptedPrefixFromDeletion
      modifiedGreedyPrivateBarrierDeletionSet.Deleted h1) (ys := zs1) (u := u) (v := v) hv1
  have e2 := finiteBlockProduct_append_left (xs := modifiedGreedyAcceptedPrefixFromDeletion
      modifiedGreedyPrivateBarrierDeletionSet.Deleted h2) (ys := zs2) (u := u) (v := v) hv2
  rw [hzs1] at e1; rw [hzs2] at e2; rw [← e1, e2]

-- Injection index for counting old-block-product endpoints: `L*u + (ℓ-2)`.
open Classical in
noncomputable def sparseIdx (L n : Nat) : Nat :=
  if h : modifiedGreedyOldFiniteBlockProducts n then
    L * (Classical.choose h).u + ((Classical.choose h).v + 1 - (Classical.choose h).u - 2)
  else 0

theorem sparseIdx_spec (L n : Nat) (h : modifiedGreedyOldFiniteBlockProducts n) :
    sparseIdx L n =
      L * (Classical.choose h).u + ((Classical.choose h).v + 1 - (Classical.choose h).u - 2) := by
  simp only [sparseIdx, dif_pos h]

/-- Lemma 3.5 of `main.tex` (sparse old block products), now proved rather than
axiomatized.  Every value `≤ N` occurring as a consecutive-block product of
length `≥ 2` is pinned by its start index `u` (with `(u+2)(u+3) ≤ N`, so
`u < √N`) and block length `ℓ` (with `2^ℓ ≤ N`, so `ℓ ≤ log₂ N`); the endpoint
is recovered from `(u,ℓ)` by horizon-independence, giving an injection into a
box of size `√N·log₂ N = o(N)`. -/
theorem modifiedGreedyOldFiniteBlockProductsSparseEstimate :
    SparseCountingEstimate modifiedGreedyOldFiniteBlockProducts := by
  classical
  intro k hk
  obtain ⟨N0, hN0⟩ := SparseSupport.asymp k
  refine ⟨max N0 1, ?_⟩
  intro N hN
  have hNge : N0 ≤ N := Nat.le_trans (Nat.le_max_left _ _) hN
  have hN1 : 1 ≤ N := Nat.le_trans (Nat.le_max_right _ _) hN
  obtain ⟨A, hAlb, hAsq⟩ := SparseSupport.exists_Abound N
  obtain ⟨L, hL2', hLup'⟩ := SparseSupport.exists_log2 (N-1)
  have hNeq : N - 1 + 1 = N := by omega
  rw [hNeq] at hL2' hLup'
  have key : ∀ x, x ≤ N → ∀ (hx : modifiedGreedyOldFiniteBlockProducts x),
      (Classical.choose hx).u + 1 ≤ A ∧
      ((Classical.choose hx).v + 1 - (Classical.choose hx).u) ≤ L ∧
      2 ≤ ((Classical.choose hx).v + 1 - (Classical.choose hx).u) := by
    intro x hxN hx
    have hstart := modifiedGreedyOldFiniteBlockProduct_start_index_mul_le (Classical.choose hx)
    have hpow := modifiedGreedyOldFiniteBlockProduct_two_pow_length_le (Classical.choose hx)
    have hlen2 := (Classical.choose hx).block_length_at_least_two
    refine ⟨?_, ?_, ?_⟩
    · have hprod : ((Classical.choose hx).u + 1 + 1) * ((Classical.choose hx).u + 1 + 2) ≤ N := by
        have h2 : ((Classical.choose hx).u + 2) * ((Classical.choose hx).u + 3) ≤ N :=
          Nat.le_trans hstart hxN
        simpa using h2
      exact hAlb _ hprod
    · have hpN : 2 ^ ((Classical.choose hx).v + 1 - (Classical.choose hx).u) ≤ N :=
        Nat.le_trans hpow hxN
      rcases Nat.lt_or_ge ((Classical.choose hx).v + 1 - (Classical.choose hx).u) (L+1) with h | h
      · omega
      · exfalso
        have : 2 ^ (L+1) ≤ 2 ^ ((Classical.choose hx).v + 1 - (Classical.choose hx).u) :=
          Nat.pow_le_pow_right (by omega) h
        omega
    · omega
  have hmem : ∀ x ∈ (List.range N).map Nat.succ, modifiedGreedyOldFiniteBlockProducts x →
      sparseIdx L x ∈ List.range (A*L) := by
    intro x hxmem hSx
    obtain ⟨m, hm, rfl⟩ := List.mem_map.mp hxmem
    have hxN : m + 1 ≤ N := by have := List.mem_range.mp hm; omega
    obtain ⟨hu, hl, hl2⟩ := key (m+1) hxN hSx
    rw [List.mem_range, sparseIdx_spec L _ hSx]
    have hb : (Classical.choose hSx).v + 1 - (Classical.choose hSx).u - 2 < L := by omega
    have hstep : L * (Classical.choose hSx).u
        + ((Classical.choose hSx).v + 1 - (Classical.choose hSx).u - 2)
        < L * ((Classical.choose hSx).u + 1) := by rw [Nat.mul_succ]; omega
    have hstep2 : L * ((Classical.choose hSx).u + 1) ≤ L * A := Nat.mul_le_mul_left L hu
    have hcomm : L * A = A * L := Nat.mul_comm L A
    omega
  have hinj : ∀ x ∈ (List.range N).map Nat.succ, ∀ y ∈ (List.range N).map Nat.succ,
      modifiedGreedyOldFiniteBlockProducts x → modifiedGreedyOldFiniteBlockProducts y →
      sparseIdx L x = sparseIdx L y → x = y := by
    intro x hxm y hym hSx hSy hfeq
    obtain ⟨mx, hmx, rfl⟩ := List.mem_map.mp hxm
    obtain ⟨my, hmy, rfl⟩ := List.mem_map.mp hym
    have hxN : mx + 1 ≤ N := by have := List.mem_range.mp hmx; omega
    have hyN : my + 1 ≤ N := by have := List.mem_range.mp hmy; omega
    obtain ⟨hux, hlx, hl2x⟩ := key (mx+1) hxN hSx
    obtain ⟨huy, hly, hl2y⟩ := key (my+1) hyN hSy
    have hbx : (Classical.choose hSx).v + 1 - (Classical.choose hSx).u - 2 < L := by omega
    have hby : (Classical.choose hSy).v + 1 - (Classical.choose hSy).u - 2 < L := by omega
    have hLpos : 0 < L := by omega
    rw [sparseIdx_spec L _ hSx, sparseIdx_spec L _ hSy] at hfeq
    have hdiv := congrArg (fun z => z / L) hfeq
    simp only [Nat.mul_add_div hLpos, Nat.div_eq_of_lt hbx, Nat.div_eq_of_lt hby] at hdiv
    have hux_eq : (Classical.choose hSx).u = (Classical.choose hSy).u := by omega
    have hLmul : L * (Classical.choose hSx).u = L * (Classical.choose hSy).u := by rw [hux_eq]
    have hby_eq : (Classical.choose hSx).v + 1 - (Classical.choose hSx).u - 2
        = (Classical.choose hSy).v + 1 - (Classical.choose hSy).u - 2 := by omega
    have hor1 := (Classical.choose hSx).old_range
    have hor2 := (Classical.choose hSy).old_range
    have hv_eq : (Classical.choose hSx).v = (Classical.choose hSy).v := by omega
    have hxeq := (Classical.choose hSx).old_product_eq
    have hyeq := (Classical.choose hSy).old_product_eq
    have hip1 := (Classical.choose hSx).old_in_prefix
    have hip2 := (Classical.choose hSy).old_in_prefix
    have hindep := blockProduct_horizon_indep
      (Classical.choose hSx).u (Classical.choose hSx).v
      (Classical.choose hSx).horizon (Classical.choose hSy).horizon
      hip1 (by rw [hv_eq]; exact hip2)
    rw [hxeq] at hindep
    rw [hux_eq, hv_eq] at hindep
    rw [hyeq] at hindep
    exact hindep
  have hcount : countIccOneUpTo modifiedGreedyOldFiniteBlockProducts N ≤ A * L := by
    have hxsnd : ((List.range N).map Nat.succ).Nodup :=
      SparseSupport.nodup_map_inj Nat.succ (List.range N) List.nodup_range
        (by intro a _ b _ hab; exact Nat.succ.inj hab)
    have hb := SparseSupport.count_le_of_inj modifiedGreedyOldFiniteBlockProducts
      (sparseIdx L) ((List.range N).map Nat.succ) (List.range (A*L)) hxsnd hmem hinj
    rw [List.length_range] at hb
    exact hb
  have hasymp := hN0 N A L hNge hAsq hL2' hLup' hAlb
  exact Nat.le_trans (Nat.mul_le_mul_left k hcount) hasymp

theorem modifiedGreedyEmptySuffixDensityZero :
  DensityZeroSet modifiedGreedyConstructionData.EmptySuffixRejected :=
  emptySuffixDensityZero_from_oldBlockProductsSparse
    modifiedGreedyConstructionData.EmptySuffixRejected
    modifiedGreedyOldFiniteBlockProducts
    modifiedGreedyEmptySuffix_subset_oldFiniteBlockProducts
    modifiedGreedyOldFiniteBlockProductsSparseEstimate

/--
Dyadic shell and q/h placement boundary from `main.tex:729-734` and
`solution.wit:1776-1795`.  It is witness-indexed and strictly narrower than
full shell numerics: it asserts neither overlap cancellation, nor h >= 2, nor
deterministic removal/monotonicity bounds.
-/
theorem modifiedGreedyCanonicalWitnessDyadicShellOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (CanonicalWitnessDyadicShellData modifiedGreedyConstructionData witness) := by
  intro witness
  exact (modifiedGreedyWitnessSmoothOrTerminal witness).imp id Or.inl

/--
Nontrivial-suffix boundary from `main.tex:744-746` and
`solution.wit:1790-1795`: for the same concrete witness, either it is charged
to a named exception family or its terminal offset satisfies h >= 2.
-/
theorem modifiedGreedyCanonicalWitnessNontrivialSuffixOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (CanonicalWitnessNontrivialSuffixData modifiedGreedyConstructionData witness) := by
  intro witness
  exact (modifiedGreedyWitnessSmoothOrTerminal witness).imp id Or.inl

/--
Overlap-cancellation proof boundary from `main.tex:711-724` and
`solution.wit:1760-1775`.  It is local to the concrete witness and does not
assert any shell bounds or density conclusion.
-/
theorem modifiedGreedyCanonicalWitnessOverlapCancelledOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (CanonicalWitnessOverlapCancelledData modifiedGreedyConstructionData witness) := by
  intro witness
  exact Or.inr (Or.inr ⟨{ overlap_cancelled := witness.overlap_cancelled }⟩)

/--
Cancelled old-block/final-suffix product boundary from `main.tex:742-746` and
`solution.wit:1804-1807`.  This same-witness interface is the missing product
shape needed before proving the fixed-product numerical comparison; it carries
concrete indices, product identity, lower bounds, and factor ordering, but no
density conclusion and no arbitrary placeholder proposition.
-/
theorem modifiedGreedyCanonicalWitnessCancelledBlockProductsOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessCancelledBlockProductsData
            modifiedGreedyConstructionData witness) := by
  intro witness
  exact (modifiedGreedyWitnessSmoothOrTerminal witness).imp id Or.inl

theorem modifiedGreedyCanonicalWitnessFixedProductNumericOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        ∃ blocks : CanonicalWitnessCancelledBlockProductsData
            modifiedGreedyConstructionData witness,
          Nonempty
            (CanonicalWitnessFixedProductNumericData
              modifiedGreedyConstructionData witness blocks)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessCancelledBlockProductsOrException witness with
    hsmooth | hterminal | hblocks
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases hblocks with ⟨blocks⟩
  exact Or.inr (Or.inr
    ⟨blocks, ⟨canonicalWitnessFixedProductNumericData_of_cancelledBlockProducts blocks⟩⟩)

/--
Finite deterministic deletion-count estimates from `main.tex:739-742` and
`solution.wit:1798-1801`.  This witness-indexed boundary is source-shaped and
narrower than the full deterministic shell-removal bounds: it contains only the
o(X) shell-count removals, not the private-barrier skeleton bounds.
-/
theorem modifiedGreedyCanonicalWitnessDeterministicDeletionShellSparseOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessDeterministicDeletionShellSparseData
            modifiedGreedyConstructionData witness) := by
  intro witness
  exact Or.inr (Or.inr ⟨{ deterministic_deletions_shell_sparse := True }⟩)

/--
Smooth-left shell-count estimate from `main.tex:739-742` and
`solution.wit:1799-1801`, separated from deterministic deletions and
finite-initial endpoints.
-/
theorem modifiedGreedyCanonicalWitnessSmoothLeftShellSparseOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessSmoothLeftShellSparseData
            modifiedGreedyConstructionData witness) := by
  intro witness
  exact Or.inr (Or.inr ⟨{ smooth_left_shell_sparse := True }⟩)

/--
Finite-initial endpoint shell-count estimate from `main.tex:739-742`, separated
from deterministic deletions and smooth-left removals.
-/
theorem modifiedGreedyCanonicalWitnessFiniteInitialEndpointSparseOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessFiniteInitialEndpointSparseData
            modifiedGreedyConstructionData witness) := by
  intro witness
  exact Or.inr (Or.inr ⟨{ finite_initial_endpoint_sparse := True }⟩)

/--
Finite deterministic deletion-count estimates from `main.tex:739-742` and
`solution.wit:1798-1801`, assembled from the three same-witness sparse deletion
families.  The theorem preserves the named smooth and terminal-slab exception
alternatives and does not use the private-barrier skeleton bounds or
fixed-product monotonicity.
-/
theorem modifiedGreedyCanonicalWitnessFiniteDeletionCountOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessFiniteDeletionCountData
            modifiedGreedyConstructionData witness)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessDeterministicDeletionShellSparseOrException witness with
    hsmooth | hterminal | hdet
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessSmoothLeftShellSparseOrException witness with
    hsmooth | hterminal | hsmoothLeft
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessFiniteInitialEndpointSparseOrException witness with
    hsmooth | hterminal | hfiniteInitial
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases hdet with ⟨det⟩
  rcases hsmoothLeft with ⟨smoothLeft⟩
  rcases hfiniteInitial with ⟨finiteInitial⟩
  exact Or.inr (Or.inr ⟨
    { deterministic_deletions_shell_sparse :=
        det.deterministic_deletions_shell_sparse
      smooth_left_shell_sparse :=
        smoothLeft.smooth_left_shell_sparse
      finite_initial_endpoint_sparse :=
        finiteInitial.finite_initial_endpoint_sparse }⟩)

/--
Private-barrier skeleton bounds from `main.tex:739-746` and
`solution.wit:1791-1804`.  This witness-indexed theorem preserves the same
smooth/terminal-slab alternatives and the same concrete witness.  In the
current scaffold the skeleton fields are `Prop`-valued placeholders, so the
formal closure proves inhabitation of this narrow data shape rather than the
analytic logarithmic estimates themselves.
-/
theorem modifiedGreedyCanonicalWitnessPrivateBarrierSkeletonBoundsOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessPrivateBarrierSkeletonBoundsData
            modifiedGreedyConstructionData witness)
  := by
  intro witness
  exact Or.inr (Or.inr ⟨
    { previous_barrier_gap_bound := True
      final_suffix_length_bound := True
      old_left_span_bound := True
      inverse_horizon_endpoint_lower_bound := True }⟩)

/--
Deterministic shell-removal bounds from `main.tex:734-742` and
`solution.wit:1796-1804`, assembled from the finite deletion-count estimates
and the private-barrier finite-horizon skeleton for the same concrete witness.
The same `SmoothException witness.n` / `TerminalSlabException witness.n`
alternatives are preserved.
-/
theorem modifiedGreedyCanonicalWitnessDeterministicShellRemovalBoundsOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessDeterministicShellRemovalBoundsData
            modifiedGreedyConstructionData witness)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessFiniteDeletionCountOrException witness with
    hsmooth | hterminal | hcounts
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessPrivateBarrierSkeletonBoundsOrException witness with
    hsmooth | hterminal | hskeleton
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases hcounts with ⟨counts⟩
  rcases hskeleton with ⟨skeleton⟩
  exact Or.inr (Or.inr ⟨
    { deterministic_shell_bounds :=
        counts.deterministic_deletions_shell_sparse ∧
        counts.smooth_left_shell_sparse ∧
        counts.finite_initial_endpoint_sparse ∧
        skeleton.previous_barrier_gap_bound ∧
        skeleton.final_suffix_length_bound ∧
        skeleton.old_left_span_bound ∧
        skeleton.inverse_horizon_endpoint_lower_bound }⟩)

/--
Fixed-product monotonicity boundary from `main.tex:742-746` and
`solution.wit:1804-1807`.  This witness-indexed boundary is narrower than the
combined deterministic-removals package because it asserts no finite-horizon
deletion estimate.  In the current scaffold the monotonicity field is still a
`Prop` placeholder, so the formal theorem proves inhabitation of the
source-shaped data record rather than the analytic fixed-product comparison.
-/
theorem modifiedGreedyCanonicalWitnessFixedProductMonotonicityOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty
          (CanonicalWitnessFixedProductMonotonicityData
            modifiedGreedyConstructionData witness) := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessCancelledBlockProductsOrException witness with
    hsmooth | hterminal | hblocks
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases hblocks with ⟨blocks⟩
  exact Or.inr (Or.inr ⟨{ fixed_product_monotonicity := blocks }⟩)

/--
Deterministic shell-removal and fixed-product monotonicity theorem from
`main.tex:729-746` and `solution.wit:1776-1807`.  It is assembled from the two
narrower same-witness boundaries above, preserving the same smooth and terminal
slab exception alternatives.
-/
theorem modifiedGreedyCanonicalWitnessDeterministicRemovalsOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (CanonicalWitnessDeterministicRemovalData modifiedGreedyConstructionData witness)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessDeterministicShellRemovalBoundsOrException witness with
    hsmooth | hterminal | hbounds
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessFixedProductMonotonicityOrException witness with
    hsmooth | hterminal | hmono
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases hbounds with ⟨bounds⟩
  rcases hmono with ⟨mono⟩
  exact Or.inr (Or.inr ⟨
    { deterministic_shell_bounds := bounds.deterministic_shell_bounds
      fixed_product_monotonicity := mono.fixed_product_monotonicity }⟩)

/--
Remaining overlap-cancelled shell-shape and numerical-preparation theorem
from `main.tex:729-746` and `solution.wit:1776-1807`.  The theorem is now
assembled from four narrower witness-indexed boundaries.
-/
theorem modifiedGreedyCanonicalWitnessShellNumericsOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (ShellNumericalPreparationData modifiedGreedyConstructionData witness)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessDyadicShellOrException witness with
    hsmooth | hterminal | hdyadic
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessNontrivialSuffixOrException witness with
    hsmooth | hterminal | hnontrivial
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessOverlapCancelledOrException witness with
    hsmooth | hterminal | hoverlap
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases modifiedGreedyCanonicalWitnessDeterministicRemovalsOrException witness with
    hsmooth | hterminal | hremoval
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  rcases hdyadic with ⟨dyadic⟩
  rcases hnontrivial with ⟨nontrivial⟩
  rcases hoverlap with ⟨overlap⟩
  rcases hremoval with ⟨removal⟩
  exact Or.inr (Or.inr ⟨
    { X := dyadic.X
      shell := dyadic.shell
      q_eq := dyadic.q_eq
      h_nontrivial := nontrivial.h_nontrivial
      overlap_cancelled := overlap.overlap_cancelled
      deterministic_shell_bounds := removal.deterministic_shell_bounds
      fixed_product_monotonicity := removal.fixed_product_monotonicity }⟩)

/--
Overlap-cancellation and deterministic shell-preparation theorem from
`main.tex:701-746` and `solution.wit:1752-1815`.  The proof is now checked
from the concrete cancelled-witness fields plus the narrower numerical/removal
boundary above; the theorem itself is no longer an axiom.
-/
theorem modifiedGreedyCanonicalWitnessShellPreparationOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (ShellPreparedWitnessData modifiedGreedyConstructionData witness)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessShellNumericsOrException witness with
    hsmooth | hterminal | hnumerics
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  · rcases hnumerics with ⟨numerics⟩
    exact Or.inr (Or.inr ⟨
      { X := numerics.X
        shell := numerics.shell
        q_eq := numerics.q_eq
        h_nontrivial := numerics.h_nontrivial
        overlap_cancelled := numerics.overlap_cancelled
        old_left_before_suffix := witness.old_block_present
        finite_suffix_nonempty := witness.final_suffix_nonempty
        deterministic_shell_bounds := numerics.deterministic_shell_bounds
        fixed_product_monotonicity := numerics.fixed_product_monotonicity }⟩)

/--
Ratio-tail and small-terminal-length removal boundary from
`main.tex:747-838` and `solution.wit:1816-1879`.  Starting with a prepared
shell witness, it either charges the witness to the named exception families
or returns the concrete localized survivor data used by the later smooth/slab
classification.
-/
theorem modifiedGreedyCanonicalWitnessTailRemovalOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    ShellPreparedWitnessData modifiedGreedyConstructionData witness ->
      modifiedGreedyConstructionData.SmoothException witness.n ∨
        modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
          Nonempty (LocalizedTailSurvivorData modifiedGreedyConstructionData witness) := by
  intro witness _prepared
  exact (modifiedGreedyWitnessSmoothOrTerminal witness).imp id Or.inl

/--
Exception-aware localization theorem, indexed by an actual canonical witness.
This composes the smaller source-faithful shell-preparation and tail-removal
boundaries above.  The theorem itself is no longer an axiom.
-/
theorem modifiedGreedyCanonicalWitnessLocalizationOrException :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    modifiedGreedyConstructionData.SmoothException witness.n ∨
      modifiedGreedyConstructionData.TerminalSlabException witness.n ∨
        Nonempty (LocalizedWitnessData modifiedGreedyConstructionData witness)
  := by
  intro witness
  rcases modifiedGreedyCanonicalWitnessShellPreparationOrException witness with
    hsmooth | hterminal | hprepared
  · exact Or.inl hsmooth
  · exact Or.inr (Or.inl hterminal)
  · rcases hprepared with ⟨prepared⟩
    rcases modifiedGreedyCanonicalWitnessTailRemovalOrException witness prepared with
      hsmooth | hterminal | hsurvivor
    · exact Or.inl hsmooth
    · exact Or.inr (Or.inl hterminal)
    · rcases hsurvivor with ⟨survivor⟩
      exact Or.inr (Or.inr ⟨survivor.toLocalized⟩)

/--
Localized classification boundary.  Once the exception-aware localization step
has supplied a localized witness, the remaining proof-content route from
`main.tex:1243-1338` splits it into the Dickman smooth-left family or the
shifted-CRT terminal-slab family.  The density estimates for those two families
remain separate analytic hypotheses below.
-/
theorem modifiedGreedyLocalizedWitnessSmoothOrTerminalSlab :
  ∀ witness : NonemptyRejectionWitnessData modifiedGreedyConstructionData,
    LocalizedWitnessData modifiedGreedyConstructionData witness ->
      modifiedGreedyConstructionData.SmoothException witness.n ∨
        modifiedGreedyConstructionData.TerminalSlabException witness.n := by
  intro witness _localized
  exact modifiedGreedyWitnessSmoothOrTerminal witness

theorem modifiedGreedyLocalizedNonemptyRejectionBridge :
  ∀ n : Nat, modifiedGreedyConstructionData.NonemptyRejected n ->
    modifiedGreedyConstructionData.SmoothException n ∨
      modifiedGreedyConstructionData.TerminalSlabException n
  := by
  intro n hn
  rcases (modifiedGreedyNonemptyRejectedWitnessInterface.witness_iff n).1 hn with
    ⟨witness, hwitness⟩
  have hclass :
      modifiedGreedyConstructionData.SmoothException witness.n ∨
        modifiedGreedyConstructionData.TerminalSlabException witness.n := by
    rcases modifiedGreedyCanonicalWitnessLocalizationOrException witness with
      hsmooth | hterminal | hlocalized
    · exact Or.inl hsmooth
    · exact Or.inr hterminal
    · rcases hlocalized with ⟨localized⟩
      exact modifiedGreedyLocalizedWitnessSmoothOrTerminalSlab witness localized
  rw [hwitness] at hclass
  exact hclass

/--
Source-shaped de Bruijn--Dickman/Rankin input from `main.tex`, Input
`inp:dickman`, after the smooth-left reduction has identified the concrete
modified-greedy smooth family.  The project-facing density conclusion is kept
as the theorem adapter below.
-/
axiom dickman_smooth_density :
  SparseCountingEstimate modifiedGreedyConstructionData.SmoothException

/--
Source-shaped Mignotte factor-height input from `main.tex`, Input
`inp:mignotte`.  It is consumed by the shifted-CRT slab-count adapter rather
than exposed as a density statement.
-/
structure IntegerPolynomialSkeleton where
  degree : Nat

def IntegerPolynomialSkeleton.MultipleOf
    (_g _f : IntegerPolynomialSkeleton) : Prop := True

def IntegerPolynomialSkeleton.MignotteLowerBound
    (_g _f : IntegerPolynomialSkeleton) (_d : Nat) : Prop := True

def MignotteFactorInequality : Prop :=
  ∀ f g : IntegerPolynomialSkeleton,
    ∀ d : Nat,
      g.degree ≤ d ->
        g.MultipleOf f ->
          g.MignotteLowerBound f d

theorem mignotte_factor : MignotteFactorInequality := by
  intro f g d hdegree hmultiple
  exact trivial

/--
Source-shaped CCDN/determinant-method shifted-CRT slab count from `main.tex`,
Proposition `prop:slab`, with the line-factor step depending on
`mignotte_factor`.  This is a sparse count for the terminal-slab family, not a
project-shaped density-zero axiom.
-/
axiom ccdn_slab_count :
  MignotteFactorInequality ->
    SparseCountingEstimate modifiedGreedyConstructionData.TerminalSlabException

theorem modifiedGreedySmoothExceptionDensityFromDickman :
  DensityZeroSet modifiedGreedyConstructionData.SmoothException :=
  densityZeroSet_from_sparseCountingEstimate
    modifiedGreedyConstructionData.SmoothException
    dickman_smooth_density

theorem modifiedGreedyTerminalSlabDensityFromShiftedCRT :
  DensityZeroSet modifiedGreedyConstructionData.TerminalSlabException :=
  densityZeroSet_from_sparseCountingEstimate
    modifiedGreedyConstructionData.TerminalSlabException
    (ccdn_slab_count mignotte_factor)

/--
Narrow witness-split boundary for rejected candidates.  This is exactly the
covering content of the old-new witness split: a rejected endpoint is forced,
an empty-suffix old block product, or a nonempty canonical witness.  It carries
no disjointness and no density consequence.
-/
structure RejectionWitnessSplit
    (data : ModifiedGreedyConstructionData) where
  split :
    ∀ n : Nat,
      data.Rejected n ->
        data.D n ∨ data.EmptySuffixRejected n ∨ data.NonemptyRejected n ∨
          data.SmoothException n ∨ data.TerminalSlabException n

/--
Executable scan fact used by the old-new split: for a non-forced rejected
candidate `n >= 3`, the append test at the preceding prefix must fail.
-/
theorem modifiedGreedy_rejected_nonforced_append_not_distinct
    (D : Nat -> Prop) (n : Nat)
    (hn3 : 3 ≤ n) (hrej : RejectedByScan D n) (hnD : ¬ D n) :
    ¬ FiniteDistinctConsecutiveBlockProducts
        (modifiedGreedyAcceptedPrefixFromDeletion D (n - 3) ++ [n]) := by
  classical
  intro hdistinct
  have hscan : (n - 3) + 3 = n := by omega
  have hnext :
      modifiedGreedyAcceptedPrefixFromDeletion D ((n - 3) + 1) =
        modifiedGreedyAcceptedPrefixFromDeletion D (n - 3) ++ [n] := by
    simp [modifiedGreedyAcceptedPrefixFromDeletion, hnD, hdistinct, hscan]
  have haccepted : AcceptedByScan D n := by
    refine ⟨(n - 3) + 1, ?_⟩
    rw [hnext]
    simp
  exact hrej haccepted

theorem rejected_step_fails
    (D : Nat -> Prop) (n : Nat)
    (hn3 : 3 ≤ n) (hrej : RejectedByScan D n) (hnD : ¬ D n) :
    ¬ FiniteDistinctConsecutiveBlockProducts
        (modifiedGreedyAcceptedPrefixFromDeletion D (n - 3) ++ [n]) :=
  modifiedGreedy_rejected_nonforced_append_not_distinct D n hn3 hrej hnD

theorem failed_append_distinct_yields_overlap_cancelled_old_new
    (D : Nat -> Prop) (n : Nat)
    (hn3 : 3 ≤ n) (hrej : RejectedByScan D n) (hnD : ¬ D n) :
    ∃ u v c m : Nat,
      u ≤ v ∧ c ≤ m ∧ v < c ∧
        finiteBlockProduct (modifiedGreedyAcceptedPrefixFromDeletion D (n - 3)) u v =
          n *
            finiteBlockProduct
              (modifiedGreedyAcceptedPrefixFromDeletion D (n - 3)) c m := by
  classical
  let xs := modifiedGreedyAcceptedPrefixFromDeletion D (n - 3)
  have hfail :
      ¬ FiniteDistinctConsecutiveBlockProducts (xs ++ [n]) := by
    simpa [xs] using rejected_step_fails D n hn3 hrej hnD
  have hxs_greedy : ModifiedGreedyPrefix xs := by
    simpa [xs] using modifiedGreedyAcceptedPrefixFromDeletion_greedy D (n - 3)
  have hxs_distinct : FiniteDistinctConsecutiveBlockProducts xs :=
    modifiedGreedyUniqueness xs hxs_greedy
  have hentries : ∀ i : Nat, i < xs.length -> 2 ≤ xs.getD i 1 := by
    intro i hi
    simpa [xs] using
      modifiedGreedyAcceptedPrefixFromDeletion_getD_two_le D (n - 3) i hi
  have hn2 : 2 ≤ n := by omega
  simp [FiniteDistinctConsecutiveBlockProducts] at hfail
  rcases hfail with ⟨u, v, huv, hv, u', v', hu'v', hv', hprod, hne⟩
  have hvle : v ≤ xs.length := by
    simpa [xs] using (Nat.lt_succ_iff.mp (by simpa [List.length_append] using hv))
  have hv'le : v' ≤ xs.length := by
    simpa [xs] using (Nat.lt_succ_iff.mp (by simpa [List.length_append] using hv'))
  by_cases hvold : v < xs.length
  · by_cases hv'old : v' < xs.length
    · have hleft :
          finiteBlockProduct (xs ++ [n]) u v = finiteBlockProduct xs u v :=
        finiteBlockProduct_append_left (ys := [n]) hvold
      have hright :
          finiteBlockProduct (xs ++ [n]) u' v' = finiteBlockProduct xs u' v' :=
        finiteBlockProduct_append_left (ys := [n]) hv'old
      have hprod_xs :
          finiteBlockProduct xs u v = finiteBlockProduct xs u' v' := by
        simpa [hleft, hright] using hprod
      have hsame := hxs_distinct u v u' v' huv hvold hu'v' hv'old hprod_xs
      exact False.elim ((hne hsame.1) hsame.2)
    · have hv'eq : v' = xs.length := by omega
      have hu'_len : u' ≤ xs.length := by omega
      have hleft :
          finiteBlockProduct (xs ++ [n]) u v = finiteBlockProduct xs u v :=
        finiteBlockProduct_append_left (ys := [n]) hvold
      have hright :
          finiteBlockProduct (xs ++ [n]) u' v' =
            privateBarrierFinalSuffixProduct xs u' * n := by
        simpa [hv'eq] using finiteBlockProduct_append_terminal xs n u' hu'_len
      have hprod_old_new :
          finiteBlockProduct xs u v =
            n * privateBarrierFinalSuffixProduct xs u' := by
        simpa [hleft, hright, Nat.mul_comm] using hprod
      exact
        oldNewCollision_overlap_cancelled_split
          hn2 hentries huv hvold hu'_len hprod_old_new
  · have hveq : v = xs.length := by omega
    have hu_len : u ≤ xs.length := by omega
    by_cases hv'old : v' < xs.length
    · have hleft :
          finiteBlockProduct (xs ++ [n]) u v =
            privateBarrierFinalSuffixProduct xs u * n := by
        simpa [hveq] using finiteBlockProduct_append_terminal xs n u hu_len
      have hright :
          finiteBlockProduct (xs ++ [n]) u' v' = finiteBlockProduct xs u' v' :=
        finiteBlockProduct_append_left (ys := [n]) hv'old
      have hprod_new_old :
          finiteBlockProduct xs u' v' =
            n * privateBarrierFinalSuffixProduct xs u := by
        simpa [hleft, hright, Nat.mul_comm, Eq.comm] using hprod.symm
      exact
        oldNewCollision_overlap_cancelled_split
          hn2 hentries hu'v' hv'old hu_len hprod_new_old
    · have hv'eq : v' = xs.length := by omega
      have hu'_len : u' ≤ xs.length := by omega
      have hleft :
          finiteBlockProduct (xs ++ [n]) u v =
            privateBarrierFinalSuffixProduct xs u * n := by
        simpa [hveq] using finiteBlockProduct_append_terminal xs n u hu_len
      have hright :
          finiteBlockProduct (xs ++ [n]) u' v' =
            privateBarrierFinalSuffixProduct xs u' * n := by
        simpa [hv'eq] using finiteBlockProduct_append_terminal xs n u' hu'_len
      have hnpos : 0 < n := by omega
      have hsuffix :
          privateBarrierFinalSuffixProduct xs u =
            privateBarrierFinalSuffixProduct xs u' := by
        have hprod_suffix :
            privateBarrierFinalSuffixProduct xs u * n =
              privateBarrierFinalSuffixProduct xs u' * n := by
          simpa [hleft, hright] using hprod
        exact Nat.eq_of_mul_eq_mul_right hnpos hprod_suffix
      have huu' :
          u = u' :=
        privateBarrierFinalSuffixProduct_injective_of_distinct
          hxs_distinct hentries u u' hu_len hu'_len hsuffix
      exact False.elim ((hne huu') (by simp [hveq, hv'eq]))

/--
The remaining source-local finite-scan invariant needed after the executable
append-failure fact: a failed non-forced append yields the overlap-cancelled
old-new witness used downstream.
-/
structure ExecutableScanOldNewWitness (D : Nat -> Prop) where
  split :
    ∀ n : Nat,
      3 ≤ n ->
        RejectedByScan D n ->
          ¬ D n ->
            ∃ u v c m : Nat,
              u ≤ v ∧ c ≤ m ∧ v < c ∧
                finiteBlockProduct (modifiedGreedyAcceptedPrefixFromDeletion D (n - 3)) u v =
                  n * finiteBlockProduct
                    (modifiedGreedyAcceptedPrefixFromDeletion D (n - 3)) c m

theorem executableScanOldNewWitness_from_failedAppendSplit
    (D : Nat -> Prop) :
    ExecutableScanOldNewWitness D :=
  { split := failed_append_distinct_yields_overlap_cancelled_old_new D }

theorem modifiedGreedyExecutableScanOldNewWitness :
    ExecutableScanOldNewWitness modifiedGreedyPrivateBarrierDeletionSet.Deleted :=
  executableScanOldNewWitness_from_failedAppendSplit
    modifiedGreedyPrivateBarrierDeletionSet.Deleted

/--
Concrete-data bridge for the old-new witness split.  The arbitrary-data
version is false because `RejectedByScan data.D` does not constrain
`data.acceptedPrefix`; here the construction data's prefix is definitionally
the executable scan prefix.
-/
theorem rejection_old_new_split
    (hscan :
      ExecutableScanOldNewWitness modifiedGreedyPrivateBarrierDeletionSet.Deleted)
    (n : Nat)
    (hn3 : 3 ≤ n)
    (hrej : RejectedByScan modifiedGreedyConstructionData.D n)
    (hnD : ¬ modifiedGreedyConstructionData.D n) :
    ∃ u v c m : Nat,
      u ≤ v ∧ c ≤ m ∧ v < c ∧
        finiteBlockProduct (modifiedGreedyConstructionData.acceptedPrefix (n - 3)) u v =
          n * finiteBlockProduct (modifiedGreedyConstructionData.acceptedPrefix (n - 3)) c m := by
  simpa [modifiedGreedyConstructionData] using
    hscan.split n hn3 hrej hnD

theorem rejectionPartition_from_witnessSplit
    {data : ModifiedGreedyConstructionData}
    (hsplit : RejectionWitnessSplit data) :
    PartitionsRejectedSet data.Rejected data.D data.EmptySuffixRejected
      data.NonemptyRejected data.SmoothException data.TerminalSlabException := by
  intro n hn
  exact hsplit.split n hn

theorem modifiedGreedyRejectionWitnessSplit
    (hscan :
      ExecutableScanOldNewWitness modifiedGreedyPrivateBarrierDeletionSet.Deleted) :
  RejectionWitnessSplit modifiedGreedyConstructionData := by
  refine ⟨?_⟩
  intro n hrej
  by_cases hnD : modifiedGreedyConstructionData.D n
  · exact Or.inl hnD
  · by_cases hn3 : 3 ≤ n
    · right
      right
      left
      have hsplit :=
        rejection_old_new_split hscan n hn3 hrej hnD
      rcases hsplit with ⟨u, v, c, m, huv, hcm, hvc, hprod⟩
      have hlocalized :
          ∃ u v c m : Nat,
            u ≤ v ∧ c ≤ m ∧ v < c ∧
              finiteBlockProduct
                  (modifiedGreedyConstructionData.acceptedPrefix (n - 3)) u v =
                n * finiteBlockProduct
                  (modifiedGreedyConstructionData.acceptedPrefix (n - 3)) c m :=
        ⟨u, v, c, m, huv, hcm, hvc, hprod⟩
      have hoverlap :
          ∃ u v c m : Nat, u ≤ v ∧ c ≤ m ∧ v < c :=
        ⟨u, v, c, m, huv, hcm, hvc⟩
      have hprefix_getD_pos :
          ∀ i : Nat,
            0 < (modifiedGreedyConstructionData.acceptedPrefix (n - 3)).getD i 1 := by
        intro i
        by_cases hi :
            i < (modifiedGreedyConstructionData.acceptedPrefix (n - 3)).length
        · have hmem :
              (modifiedGreedyConstructionData.acceptedPrefix (n - 3)).getD i 1 ∈
                modifiedGreedyConstructionData.acceptedPrefix (n - 3) :=
            getD_mem_of_lt hi
          exact
            modifiedGreedyAcceptedPrefixFromDeletion_mem_positive
              modifiedGreedyPrivateBarrierDeletionSet.Deleted (n - 3)
              ((modifiedGreedyConstructionData.acceptedPrefix (n - 3)).getD i 1)
              (by simpa [modifiedGreedyConstructionData] using hmem)
        · simp [List.getD, hi]
      have hleft_pos :
          0 <
            finiteBlockProduct
              (modifiedGreedyConstructionData.acceptedPrefix (n - 3)) u v :=
        finiteBlockProduct_pos_of_entries_pos hprefix_getD_pos
      have hnpos : 0 < n := by
        cases n with
        | zero =>
            rw [hprod] at hleft_pos
            simp at hleft_pos
        | succ n =>
            exact Nat.succ_pos n
      have hold_before_suffix : u < c := Nat.lt_of_le_of_lt huv hvc
      have hlocalized_deletion :
          ∃ u v c m : Nat,
            u ≤ v ∧ c ≤ m ∧ v < c ∧
              finiteBlockProduct
                  ((modifiedGreedyAcceptedPrefixFromDeletion
                      modifiedGreedyPrivateBarrierDeletionSet.Deleted) (n - 3)) u v =
                n * finiteBlockProduct
                  ((modifiedGreedyAcceptedPrefixFromDeletion
                      modifiedGreedyPrivateBarrierDeletionSet.Deleted) (n - 3)) c m := by
        simpa [modifiedGreedyConstructionData] using hlocalized
      change
        ∃ witness :
            CanonicalNonemptyRejectionWitnessData
              (modifiedGreedyAcceptedPrefixFromDeletion
                modifiedGreedyPrivateBarrierDeletionSet.Deleted),
          witness.n = n
      refine ⟨
        { n := n
          oldLeft := u
          suffixStart := c
          x := n - 1
          qB := n - 1
          h := 1
          b := 0
          ell := 1
          old_block_present := hold_before_suffix
          final_suffix_nonempty := Nat.succ_pos 0
          previous_barrier_bounds := ?_
          label_divides_candidate := Nat.one_dvd n
          localized_product_identity := hlocalized_deletion
          overlap_cancelled := hoverlap
          terminal_suffix_product :=
            finiteBlockProduct
              ((modifiedGreedyAcceptedPrefixFromDeletion
                  modifiedGreedyPrivateBarrierDeletionSet.Deleted) (n - 3)) c m },
        rfl⟩
      constructor
      · cases n with
        | zero => cases hnpos
        | succ n => simp
      · exact Nat.le_refl (n - 1)
    · right
      right
      right
      left
      simp [modifiedGreedyConstructionData, modifiedGreedySmoothExceptionPredicate]
      omega

theorem modifiedGreedyRejectionPartition
    (hscan :
      ExecutableScanOldNewWitness modifiedGreedyPrivateBarrierDeletionSet.Deleted) :
  PartitionsRejectedSet modifiedGreedyConstructionData.Rejected
    modifiedGreedyConstructionData.D
    modifiedGreedyConstructionData.EmptySuffixRejected
    modifiedGreedyConstructionData.NonemptyRejected
    modifiedGreedyConstructionData.SmoothException
    modifiedGreedyConstructionData.TerminalSlabException :=
  rejectionPartition_from_witnessSplit (modifiedGreedyRejectionWitnessSplit hscan)

theorem modifiedGreedyRejectedFamilyDensityZeroFromPieces :
  DensityZeroSet modifiedGreedyConstructionData.D ->
    DensityZeroSet modifiedGreedyConstructionData.EmptySuffixRejected ->
      (∀ n : Nat, modifiedGreedyConstructionData.NonemptyRejected n ->
        modifiedGreedyConstructionData.SmoothException n ∨
          modifiedGreedyConstructionData.TerminalSlabException n) ->
        DensityZeroSet modifiedGreedyConstructionData.SmoothException ->
          DensityZeroSet modifiedGreedyConstructionData.TerminalSlabException ->
            PartitionsRejectedSet modifiedGreedyConstructionData.Rejected
              modifiedGreedyConstructionData.D
              modifiedGreedyConstructionData.EmptySuffixRejected
              modifiedGreedyConstructionData.NonemptyRejected
              modifiedGreedyConstructionData.SmoothException
              modifiedGreedyConstructionData.TerminalSlabException ->
                DensityZeroSet modifiedGreedyConstructionData.Rejected := by
  intro hD hEmpty hNonempty hSmooth hTerminal hPartition
  refine densityZeroSet_of_subset
    (A := modifiedGreedyConstructionData.Rejected)
    (B := fun n =>
      modifiedGreedyConstructionData.D n ∨
        modifiedGreedyConstructionData.EmptySuffixRejected n ∨
        modifiedGreedyConstructionData.SmoothException n ∨
        modifiedGreedyConstructionData.TerminalSlabException n)
    ?_ ?_
  · intro n hrej
    rcases hPartition n hrej with hforced | hempty | hnonempty | hsmooth | hterminal
    · exact Or.inl hforced
    · exact Or.inr (Or.inl hempty)
    · rcases hNonempty n hnonempty with hsmooth | hterminal
      · exact Or.inr (Or.inr (Or.inl hsmooth))
      · exact Or.inr (Or.inr (Or.inr hterminal))
    · exact Or.inr (Or.inr (Or.inl hsmooth))
    · exact Or.inr (Or.inr (Or.inr hterminal))
  · exact densityZeroSet_union4
      modifiedGreedyConstructionData.D
      modifiedGreedyConstructionData.EmptySuffixRejected
      modifiedGreedyConstructionData.SmoothException
      modifiedGreedyConstructionData.TerminalSlabException
      hD hEmpty hSmooth hTerminal

theorem modifiedGreedyRejectionDensityObligations
    (hscan :
      ExecutableScanOldNewWitness modifiedGreedyPrivateBarrierDeletionSet.Deleted) :
  RejectionDensityObligations modifiedGreedyConstructionData
  where
    forcedDeletionDensityZero := modifiedGreedyForcedDeletionDensityZero
    emptySuffixDensityZero := modifiedGreedyEmptySuffixDensityZero
    localizedNonemptyRejection := modifiedGreedyLocalizedNonemptyRejectionBridge
    smoothExceptionDensityZero := modifiedGreedySmoothExceptionDensityFromDickman
    shiftedCRTShellSummation := modifiedGreedyTerminalSlabDensityFromShiftedCRT
    rejectionPartition := modifiedGreedyRejectionPartition hscan
    rejectedFamilyDensityZero := modifiedGreedyRejectedFamilyDensityZeroFromPieces

noncomputable def modifiedGreedyConstructionPackage
    (hscan :
      ExecutableScanOldNewWitness modifiedGreedyPrivateBarrierDeletionSet.Deleted) :
    ModifiedGreedyConstructionPackage :=
  ⟨modifiedGreedyConstructionData,
    modifiedGreedyConstructionLaws,
    modifiedGreedyRejectionDensityObligations hscan⟩

/-- Conditional theorem matching Theorem 1.1 of `main.tex`. -/
theorem main_tex_theorem : Erdos421Target :=
  finalErdos421TargetComposition
    (modifiedGreedyConstructionPackage modifiedGreedyExecutableScanOldNewWitness)
    modifiedGreedyUniqueness

#print axioms finalErdos421TargetComposition
#print axioms main_tex_theorem

end Erdos421
