/-
Generic, self-contained support lemmas for the sparse-old-block-products
estimate (Lemma 3.5 of `main.tex`).  Everything here is pure Lean core:
no Mathlib, no `Nat.sqrt`/`Nat.log2` (rebuilt as existence lemmas), and the
polynomial-vs-exponential asymptotic that drives the density bound.
-/
namespace Erdos421
namespace SparseSupport

/-! ### Polynomial-beats-exponential arithmetic core -/

theorem le_two_pow (L : Nat) : L + 1 ≤ 2 ^ L := by
  induction L with
  | zero => decide
  | succ n ih =>
    have : (1:Nat) ≤ 2 ^ n := Nat.one_le_two_pow
    have h2 : 2 ^ (n+1) = 2^n + 2^n := by rw [Nat.pow_succ]; omega
    omega

theorem quartic_step (a : Nat) (h : 6 ≤ a) :
    (a+1)*(a+1)*(a+1)*(a+1) ≤ 2*(a*a*a*a) := by
  have h4 : 6*(a*a*a) ≤ a*(a*a*a) := Nat.mul_le_mul_right _ h
  have h3 : 6*(a*a) ≤ a*(a*a) := Nat.mul_le_mul_right _ h
  have h2 : 6*a ≤ a*a := Nat.mul_le_mul_right _ h
  simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul, Nat.mul_assoc] at *
  omega

theorem quartic_le_exp : ∀ L, 20 ≤ L → (L+1)*(L+1)*(L+1)*(L+1) ≤ 2 ^ L := by
  intro L
  induction L with
  | zero => intro h; omega
  | succ n ih =>
    intro hL
    by_cases hn : 20 ≤ n
    · have ihn := ih hn
      have hstep : (n+1+1)*(n+1+1)*(n+1+1)*(n+1+1) ≤ 2*((n+1)*(n+1)*(n+1)*(n+1)) :=
        quartic_step (n+1) (by omega)
      have hmul : 2*((n+1)*(n+1)*(n+1)*(n+1)) ≤ 2 * 2^n := Nat.mul_le_mul_left 2 ihn
      have hpow : 2 * 2^n = 2^(n+1) := by rw [Nat.pow_succ]; omega
      omega
    · have : n = 19 := by omega
      subst this; decide

theorem crux (k : Nat) : ∀ L, max 20 k ≤ L → (k*L+1)*(k*L+2) ≤ 2 ^ L := by
  intro L hL
  have h20 : 20 ≤ L := Nat.le_trans (Nat.le_max_left _ _) hL
  have hk : k ≤ L := Nat.le_trans (Nat.le_max_right _ _) hL
  have hquart : (L+1)*(L+1)*(L+1)*(L+1) ≤ 2 ^ L := quartic_le_exp L h20
  have hexp : (k+1)*(L+1) = k*L + k + L + 1 := by
    simp only [Nat.add_mul, Nat.mul_add, Nat.one_mul, Nat.mul_one]; omega
  have hb1 : k*L+1 ≤ (k+1)*(L+1) := by rw [hexp]; omega
  have hb2 : k*L+2 ≤ (k+1)*(L+1) := by rw [hexp]; omega
  have hprod : (k*L+1)*(k*L+2) ≤ ((k+1)*(L+1)) * ((k+1)*(L+1)) := Nat.mul_le_mul hb1 hb2
  have hkL : k+1 ≤ L+1 := by omega
  have hsq : ((k+1)*(L+1)) * ((k+1)*(L+1)) ≤ ((L+1)*(L+1))*((L+1)*(L+1)) :=
    Nat.mul_le_mul (Nat.mul_le_mul hkL (Nat.le_refl _)) (Nat.mul_le_mul hkL (Nat.le_refl _))
  have hchain : ((L+1)*(L+1))*((L+1)*(L+1)) = (L+1)*(L+1)*(L+1)*(L+1) := by
    simp only [Nat.mul_assoc]
  exact Nat.le_trans hprod (Nat.le_trans hsq (Nat.le_trans (Nat.le_of_eq hchain) hquart))

/-- The asymptotic heart: with `A*A ≤ N` (an integer square root) and `L` the
integer `log₂ N`, eventually `k·A·L ≤ N`. -/
theorem asymp (k : Nat) :
    ∃ N0, ∀ N A L, N0 ≤ N → A*A ≤ N → 2^L ≤ N → N < 2^(L+1) →
      (∀ t, (t+1)*(t+2) ≤ N → t ≤ A) → k*(A*L) ≤ N := by
  refine ⟨2 ^ (max 20 k), ?_⟩
  intro N A L hN0 hAA hL2 hLup hlb
  have hL0L : max 20 k ≤ L := by
    rcases Nat.lt_or_ge L (max 20 k) with hlt | hge
    · exfalso
      have hle : L + 1 ≤ max 20 k := hlt
      have hpow : 2 ^ (L+1) ≤ 2 ^ (max 20 k) := Nat.pow_le_pow_right (by omega) hle
      omega
    · exact hge
  have hcrux : (k*L+1)*(k*L+2) ≤ 2 ^ L := crux k L hL0L
  have hkLN : (k*L+1)*(k*L+2) ≤ N := Nat.le_trans hcrux hL2
  have hkLA : k*L ≤ A := hlb (k*L) hkLN
  have hmul : A * (k*L) ≤ A * A := Nat.mul_le_mul_left A hkLA
  have heq : k*(A*L) = A*(k*L) := by
    rw [← Nat.mul_assoc, Nat.mul_comm k A, Nat.mul_assoc]
  rw [heq]; exact Nat.le_trans hmul hAA

/-! ### Integer square root / logarithm as existence lemmas -/

theorem exists_log2 : ∀ N, ∃ L, 2^L ≤ N+1 ∧ N+1 < 2^(L+1) := by
  intro N
  induction N with
  | zero => exact ⟨0, by decide⟩
  | succ n ih =>
    obtain ⟨L, hlo, hhi⟩ := ih
    have e1 : 2^(L+1) = 2*2^L := by rw [Nat.pow_succ]; omega
    have e2 : 2^(L+2) = 2*2^(L+1) := by rw [Nat.pow_succ]; omega
    rcases Nat.lt_or_ge (n+1+1) (2^(L+1)) with hlt | hge
    · exact ⟨L, by omega, by omega⟩
    · exact ⟨L+1, by omega, by omega⟩

theorem exists_Ainv : ∀ N, ∃ A, A*A ≤ N ∧ N < (A+1)*(A+2) := by
  intro N
  induction N with
  | zero => exact ⟨0, by decide⟩
  | succ n ih =>
    obtain ⟨A, hlo, hhi⟩ := ih
    have d1 : (A+1)*(A+2) = A*A + 3*A + 2 := by
      simp only [Nat.mul_add, Nat.add_mul]; omega
    have d2 : (A+1)*(A+1) = A*A + 2*A + 1 := by
      simp only [Nat.mul_add, Nat.add_mul]; omega
    rcases Nat.lt_or_ge (n+1) ((A+1)*(A+2)) with hlt | hge
    · exact ⟨A, by omega, by omega⟩
    · refine ⟨A+1, by omega, ?_⟩
      have : (A+1+1)*(A+1+2) = A*A + 5*A + 6 := by
        simp only [Nat.mul_add, Nat.add_mul]; omega
      omega

theorem exists_Abound (N : Nat) :
    ∃ A, (∀ t, (t+1)*(t+2) ≤ N → t ≤ A) ∧ A*A ≤ N := by
  obtain ⟨A, hlo, hhi⟩ := exists_Ainv N
  refine ⟨A, ?_, hlo⟩
  intro t ht
  rcases Nat.lt_or_ge t (A+1) with h | h
  · omega
  · exfalso
    have hmono : (A+2)*(A+3) ≤ (t+1)*(t+2) := Nat.mul_le_mul (by omega) (by omega)
    have da : (A+1)*(A+2) = A*A+3*A+2 := by
      simp only [Nat.mul_add, Nat.add_mul]; omega
    have db : (A+2)*(A+3) = A*A+5*A+6 := by
      simp only [Nat.mul_add, Nat.add_mul]; omega
    omega

/-! ### Injective counting bound -/

theorem nodup_subset_length_le {α : Type} [DecidableEq α] :
    ∀ {l1 l2 : List α}, l1.Nodup → l1 ⊆ l2 → l1.length ≤ l2.length := by
  intro l1
  induction l1 with
  | nil => intro l2 _ _; simp
  | cons a l1' ih =>
    intro l2 hnd hsub
    rw [List.nodup_cons] at hnd
    obtain ⟨hanl, hnd'⟩ := hnd
    rw [List.cons_subset] at hsub
    obtain ⟨hal2, hsub'⟩ := hsub
    have hsuberase : l1' ⊆ l2.erase a := by
      intro x hx
      have hxne : x ≠ a := by intro h; subst h; exact hanl hx
      exact (List.mem_erase_of_ne hxne).mpr (hsub' hx)
    have hlen := ih hnd' hsuberase
    have herase : (l2.erase a).length = l2.length - 1 := List.length_erase_of_mem hal2
    have hpos : 1 ≤ l2.length := by
      rcases l2 with _ | ⟨b, l2'⟩
      · simp at hal2
      · simp
    simp only [List.length_cons]; omega

theorem nodup_map_inj {α β : Type} (f : α → β) (l : List α) (h : l.Nodup)
    (hinj : ∀ x ∈ l, ∀ y ∈ l, f x = f y → x = y) : (l.map f).Nodup := by
  rw [List.Nodup, List.pairwise_map]; rw [List.Nodup] at h
  refine h.imp_of_mem ?_
  intro a b ha hb hab heq; exact hab (hinj a ha b hb heq)

theorem count_le_of_inj {α β : Type} [DecidableEq β]
    (P : α → Prop) [DecidablePred P] (f : α → β)
    (xs : List α) (bound : List β)
    (hnd : xs.Nodup)
    (hmem : ∀ x ∈ xs, P x → f x ∈ bound)
    (hinj : ∀ x ∈ xs, ∀ y ∈ xs, P x → P y → f x = f y → x = y) :
    (xs.filter (fun x => decide (P x))).length ≤ bound.length := by
  have hflnd : (xs.filter (fun x => decide (P x))).Nodup :=
    List.Nodup.sublist List.filter_sublist hnd
  have hflmem : ∀ x ∈ xs.filter (fun x => decide (P x)), x ∈ xs ∧ P x := by
    intro x hx; rw [List.mem_filter] at hx
    exact ⟨hx.1, by have := hx.2; simpa using this⟩
  have hmapnd : ((xs.filter (fun x => decide (P x))).map f).Nodup := by
    refine nodup_map_inj f _ hflnd ?_
    intro x hx y hy heq
    obtain ⟨hxxs, hxP⟩ := hflmem x hx
    obtain ⟨hyxs, hyP⟩ := hflmem y hy
    exact hinj x hxxs y hyxs hxP hyP heq
  have hmapsub : ((xs.filter (fun x => decide (P x))).map f) ⊆ bound := by
    intro z hz; rw [List.mem_map] at hz
    obtain ⟨x, hx, rfl⟩ := hz
    obtain ⟨hxxs, hxP⟩ := hflmem x hx
    exact hmem x hxxs hxP
  have hle := nodup_subset_length_le hmapnd hmapsub
  rwa [List.length_map] at hle

end SparseSupport
end Erdos421
