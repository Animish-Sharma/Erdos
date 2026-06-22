// Lean compiler output
// Module: VanCorput
// Imports: public import Init public meta import Init public import Mathlib public import ArithmeticProgressions public import RkN public import UpperBounds
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* l_instDecidableEqNat___boxed(lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
uint8_t lp_mathlib_Multiset_decidableMem___aux__1___redArg(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Multiset_filter___redArg(lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_RkFormalization_fiberAtDiff___lam__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_RkFormalization_fiberAtDiff___lam__0___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_RkFormalization_fiberAtDiff(lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_RkFormalization_fiberAtDiff___lam__0(lean_object* v_d_1_, lean_object* v_A_2_, lean_object* v_a_3_){
_start:
{
lean_object* v___x_4_; lean_object* v___x_5_; uint8_t v___x_6_; 
v___x_4_ = lean_alloc_closure((void*)(l_instDecidableEqNat___boxed), 2, 0);
v___x_5_ = lean_nat_add(v_a_3_, v_d_1_);
v___x_6_ = lp_mathlib_Multiset_decidableMem___aux__1___redArg(v___x_4_, v___x_5_, v_A_2_);
return v___x_6_;
}
}
LEAN_EXPORT lean_object* lp_RkFormalization_fiberAtDiff___lam__0___boxed(lean_object* v_d_7_, lean_object* v_A_8_, lean_object* v_a_9_){
_start:
{
uint8_t v_res_10_; lean_object* v_r_11_; 
v_res_10_ = lp_RkFormalization_fiberAtDiff___lam__0(v_d_7_, v_A_8_, v_a_9_);
lean_dec(v_a_9_);
lean_dec(v_d_7_);
v_r_11_ = lean_box(v_res_10_);
return v_r_11_;
}
}
LEAN_EXPORT lean_object* lp_RkFormalization_fiberAtDiff(lean_object* v_A_12_, lean_object* v_d_13_){
_start:
{
lean_object* v___f_14_; lean_object* v___x_15_; 
lean_inc(v_A_12_);
v___f_14_ = lean_alloc_closure((void*)(lp_RkFormalization_fiberAtDiff___lam__0___boxed), 3, 2);
lean_closure_set(v___f_14_, 0, v_d_13_);
lean_closure_set(v___f_14_, 1, v_A_12_);
v___x_15_ = lp_mathlib_Multiset_filter___redArg(v___f_14_, v_A_12_);
return v___x_15_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib(uint8_t builtin);
lean_object* initialize_RkFormalization_ArithmeticProgressions(uint8_t builtin);
lean_object* initialize_RkFormalization_RkN(uint8_t builtin);
lean_object* initialize_RkFormalization_UpperBounds(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RkFormalization_VanCorput(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RkFormalization_ArithmeticProgressions(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RkFormalization_RkN(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RkFormalization_UpperBounds(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
