import Erdos421

namespace Erdos421
namespace SmoothRankin

/--
Project-local statement form for a Rankin/Dickman smooth-counting estimate.
It is deliberately just the counting estimate needed by the existing
natural-density infrastructure; the analytic proof is external.
-/
def SmoothCountingEstimate (Smooth : Nat -> Prop) : Prop :=
  SparseCountingEstimate Smooth

/--
Named external input corresponding to the de Bruijn--Dickman smooth-number
estimate and Rankin decay step in `main.tex`.

This is a data-shaped hypothesis, not a project axiom: users of the adapter
must provide the smooth-counting estimate for the particular family under
discussion.
-/
structure DickmanSmoothDensityInput (Smooth : Nat -> Prop) where
  estimate : SmoothCountingEstimate Smooth

theorem densityZero_from_dickmanInput
    {Smooth : Nat -> Prop} (hSmooth : DickmanSmoothDensityInput Smooth) :
    DensityZeroSet Smooth :=
  densityZeroSet_from_sparseCountingEstimate Smooth hSmooth.estimate

/--
Adapter for smooth subfamilies.  This is the shape used by smooth-left
reductions: after reducing a rejected family to a named smooth family, the
only remaining input is the external Dickman/Rankin estimate for that smooth
family.
-/
theorem densityZero_of_subset_dickmanInput
    {SmoothFamily Smooth : Nat -> Prop}
    (hsubset : ∀ n : Nat, SmoothFamily n -> Smooth n)
    (hSmooth : DickmanSmoothDensityInput Smooth) :
    DensityZeroSet SmoothFamily :=
  densityZeroSet_of_subset hsubset (densityZero_from_dickmanInput hSmooth)

/--
Concrete adapter target for the current modified-greedy smooth exception
family.  This names exactly the still-external smooth-density input needed by
`modifiedGreedyConstructionData.SmoothException`, without assembling the final
theorem or hiding the input inside a broader construction axiom.
-/
abbrev ModifiedGreedySmoothDensityInput : Prop :=
  DickmanSmoothDensityInput modifiedGreedyConstructionData.SmoothException

theorem modifiedGreedySmoothExceptionDensity_from_dickmanInput
    (hSmooth : ModifiedGreedySmoothDensityInput) :
    DensityZeroSet modifiedGreedyConstructionData.SmoothException :=
  densityZero_from_dickmanInput hSmooth

end SmoothRankin
end Erdos421
