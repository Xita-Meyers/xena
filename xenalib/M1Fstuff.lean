import analysis.real init.classical
instance coe_rat_real : has_coe rat real := ⟨of_rat⟩
instance coe_int_real : has_coe int real := ⟨of_rat ∘ rat.of_int⟩
instance coe_nat_real : has_coe nat real := ⟨of_rat ∘ rat.of_int ∘ int.of_nat⟩ 

lemma of_rat_lt_of_rat {q₁ q₂ : ℚ} : of_rat q₁ < of_rat q₂ ↔ q₁ < q₂ := 
begin
simp [lt_iff_le_and_ne, of_rat_le_of_rat]
end
#check classical.indefinite_description 

#check of_rat_inj
#check exists.elim
#check classical.some
-- #check non_empty
#print nonempty
-- set_option pp.all true
-- #print classical.choice,

 -- set_option pp.notation false
-- set_option pp.all true
-- I want a floor function.
#check exists_lt_of_rat_of_rat_gt
-- exists_lt_of_rat_of_rat_gt : ?M_1 < ?M_2 → (∃ (q : ℚ), ?M_1 < of_rat q ∧ of_rat q < ?M_2)
#check @exists_lt_of_rat_of_rat_gt
-- exists_lt_of_rat_of_rat_gt : ∀ {r p : ℝ}, r < p → (∃ (q : ℚ), r < of_rat q ∧ of_rat q < p)

variable α : Type

-- example : set α = (α → Prop) := rfl

#print nonempty 
-- set_option pp.all true
noncomputable def floor_with_proof : ℝ → ℤ  := λ x, 
begin
--  have H2 : 0+x < 1+x, by 
--    apply add_lt_add_of_lt_of_le (zero_lt_one) (le_of_eq (rfl)),
--  have H3 : x < x+1, by simp [H2],
  let rat_in_interval := {q // x < of_rat q ∧ of_rat q < x + 1},
  have H : ∃ (q : ℚ), x < of_rat q ∧ of_rat q < x + 1,
  exact @exists_lt_of_rat_of_rat_gt x (x+1) (by simp [zero_lt_one]),
  have H2 : ∃ (s : rat_in_interval), true,
  simp [H],
  have H3 : nonempty rat_in_interval,
    apply exists.elim H2,
    intro a,
    intro Pa,
    constructor,
    exact a,
  have qHq : rat_in_interval := classical.choice (H3),
  cases qHq with q Hq,
  exact (if (x < rat.floor q) then rat.floor q - 1  else rat.floor q ),
end

-- theorems need classical logic
-- should it be 
-- theorem floor_le : ∀ x, floor x ≤ x
-- or
-- theorem floor_ge : ∀ x, x ≥ floor x
-- or any other combination of these ideas?
-- How many? One? Four?
noncomputable theorem floor_le (x : ℝ) : ↑(floor x) ≤ x :=
begin
unfold floor,
simp,

have n : ℤ := floor x,

admit,
end

-- should I prove floor + 1 or 1 + floor?
theorem lt_floor_add_one (x : ℝ) : x < 1 + floor x := sorry

-- set_option pp.notation false
variables x y : ℝ 
#check x ≤ y
let H : (x≤ y)

constant C : (x ≤ y)
#check C x y
example (H : C x y) : C x y := sorry,



namespace M1F


lemma rat.zero_eq_int_zero (z : int) : ↑ z = (0:rat) → z = 0 :=
begin
simp [rat.mk_eq_zero,nat.one_pos,rat.coe_int_eq_mk]
end 

lemma rat.of_int_inj (z₁ z₂ : int) : (z₁ : rat) = (z₂ : rat) → z₁ = z₂ :=
begin
intro H12,
have H2 : ↑(z₁ - z₂) = (0:rat),
exact calc
↑(z₁ - z₂) = (↑z₁ - ↑z₂ : ℚ)  : (rat.coe_int_sub z₁ z₂)
...               = (↑ z₂ - ↑ z₂:ℚ)  : by rw H12
... = (0 : rat) : by simp,
have H3 : z₁ - z₂ = 0,
exact rat.zero_eq_int_zero (z₁ -z₂) H2,
clear H12 H2,
exact sub_eq_zero.mp H3
end

lemma rational_half_not_an_integer : ¬ (∃ y : ℤ, 1/2 = (y:rat)) :=
begin
simp,
assume x:ℤ,
intro H,
unfold has_inv.inv at H, -- why does this become such an effort?
unfold division_ring.inv at H,
unfold field.inv at H,
unfold linear_ordered_field.inv at H,
unfold discrete_linear_ordered_field.inv at H,
unfold discrete_field.inv at H,
have H2 : ((2:rat)*rat.inv 2) = (2:rat)*x,
simp [H],
have H21 : (2:rat)≠ 0 := dec_trivial,
have H3 : (2:rat)*rat.inv 2 = (1:rat),
exact rat.mul_inv_cancel 2 H21,
have H4 : (1:rat) = (2:rat)*(x:rat),
exact H3 ▸ H2,
have H5 : ((((2:int)*x):int):rat)=((2:int):rat)*(x:rat),
simp [rat.coe_int_mul],
have H6 : ↑ ((2:int)*x) = (↑1:rat),
exact eq.trans H5 (eq.symm H4),
clear H H2 H21 H3 H4 H5,
have H7 : 2*x=1,
exact rat.of_int_inj (2*x) 1 H6,
clear H6,
have H8 : (2*x) % 2 = 0,
simp [@int.add_mul_mod_self 0],
have H9 : (1:int) % 2 = 0,
apply @eq.subst ℤ  (λ t, t%2 =0) _ _ H7 H8,
have H10 : (1:int) % 2 ≠ 0,
exact dec_trivial,
contradiction,
end

lemma real_half_not_an_integer : ¬ (∃ y : ℤ, of_rat (1/2) = of_rat(y)) :=
begin
assume H : (∃ y : ℤ, of_rat (1/2) = of_rat(y)),
have H2 : (∃ y : ℤ , (1:rat)/2 = (y:rat)),
apply exists.elim H,
intro a,
intro H3,
existsi a,
exact (@of_rat_inj (1/2) (a:rat)).mp H3,
exact rational_half_not_an_integer H2,
end

#check @of_rat_inj

run_cmd mk_simp_attr `real_simps
attribute [real_simps] of_rat_zero of_rat_one of_rat_neg of_rat_add of_rat_sub of_rat_mul
attribute [real_simps] of_rat_inv of_rat_le_of_rat of_rat_lt_of_rat
@[real_simps] lemma of_rat_bit0 (a : ℚ) : bit0 (of_rat a) = of_rat (bit0 a) := of_rat_add
@[real_simps] lemma of_rat_bit1 (a : ℚ) : bit1 (of_rat a) = of_rat (bit1 a) :=
by simp [bit1, bit0, of_rat_add,of_rat_one]
@[real_simps] lemma of_rat_div {r₁ r₂ : ℚ} : of_rat r₁ / of_rat r₂ = of_rat (r₁ / r₂) :=
by simp [has_div.div, algebra.div] with real_simps
end M1F

namespace tactic
meta def eval_num_tac : tactic unit :=
do t ← target,
   (lhs, rhs) ← match_eq t,
   (new_lhs, pr1) ← norm_num lhs,
   (new_rhs, pr2) ← norm_num rhs,
   is_def_eq new_lhs new_rhs,
   `[exact eq.trans %%pr1 (eq.symm %%pr2)]
end tactic


example : (((3:real)/4)-12)<6 := by simp with real_simps;exact dec_trivial
example : (6:real) + 9 = 15 := by tactic.eval_num_tac
example : (2:real) * 2 + 3 = 7 := by tactic.eval_num_tac
example : (5:real) ≠ 8 := by simp with real_simps;exact dec_trivial
example : (6:real) < 10 := by simp with real_simps;exact dec_trivial 

