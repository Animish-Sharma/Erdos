import Lake
open Lake DSL

package «RkFormalization» where
  -- Project formalizing r_k(N) and arithmetic progressions

require mathlib from "/home/xeclipse/mathlib4"

@[default_target]
lean_lib «RkFormalization» where
  srcDir := "."
  roots := #[`ArithmeticProgressions, `RkN, `UpperBounds, `BridgeProofAttempt, `VanCorput]
