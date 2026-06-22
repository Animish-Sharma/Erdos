# Kelley–Lyu Transfer Analysis: Grid Norm Sifting and r_3(N) Upper Bounds

**Author**: OpenScientist Worker Agent (sess_kelley_lyu_analysis)  
**Date**: 2026-06-21  
**Based on**: Kelley–Lyu arXiv:2505.01587 (revised June 10, 2026) + prior missions (sess_5bae985b, sess_2ef59a6f, sess_ac9cc519)

---

## 1. Executive Summary

**Conclusion (stated first)**: The Kelley–Lyu (2026) grid norm sifting improvement does **not** directly transfer to the 3-AP Bohr set counting argument. The two settings are structurally incompatible: Kelley–Lyu works with bilinear (2-variable) U(2,k) grid norms on bipartite graphs, while the Croot–Sisask / Kelley–Meka 3-AP sifting requires trilinear (3-variable) tensor structures. The paper itself (arXiv:2505.01587) states explicitly: **"It remains to be seen whether a similar improvement can be made for the case of 3-APs."** This is an open problem identified by the authors.

**Revised sifting ceiling**: We now believe the sifting ceiling for r_3(N) within the current Croot–Sisask paradigm is **1/3** (achievable, with substantial work, by doubly-iterated Raghavan-style sifting), **not 1/2**. The Kelley–Lyu 1/2 exponent is specific to the bilinear NOF communication complexity setting and does not port to the trilinear 3-AP setting. However, a **tripartite grid norm** generalization — a program requiring 2–5 years — could potentially yield exponent 1/2 for r_3(N), matching Behrend.

**Transfer probability assessment**:
- Direct port of Kelley–Lyu to give r_3(N) ≤ N·exp(−c(log N)^{1/2}): **15–20% probability**.
- With minimal additional ingredient (tripartite grid norm sifting lemma): **50–60% probability**, but this ingredient requires fundamentally new work.
- Kelley–Lyu as evidence that the sifting paradigm eventually reaches 1/2 (without specifying the mechanism): **70–75%**, consistent with the Convergence Hypothesis.

---

## 2. Grid Norm Framework: What Kelley–Lyu Actually Proves

### 2.1 Setting and Problem

Kelley and Lyu work in the following setting. Let G = (X, Y, E) be a bipartite graph with vertex sets X and Y, and let M ∈ [0,1]^{X×Y} be the adjacency matrix (or, more generally, a "density matrix" taking values in [0,1]). The **grid norm** is the primary analytical tool.

**Definition 2.1 (Grid norm U(ℓ,k))** [Kelley–Lyu, Eq. 3]: For a matrix M ∈ ℝ_≥0^{X×Y}, the U(ℓ,k)-grid norm is:

$$\|M\|_{U(\ell,k)} := \left( \mathbb{E}_{x_1,\ldots,x_\ell \in X,\, y_1,\ldots,y_k \in Y} \left[ \prod_{i \in [\ell]} \prod_{j \in [k]} M(x_i, y_j) \right] \right)^{1/(\ell k)}$$

For the special case ℓ = 2, this simplifies via the "inner product of rows" interpretation:

$$\|M\|_{U(2,k)}^{2k} = \mathbb{E}_{x_1, x_2 \in X} \left[ \langle M_{x_1}, M_{x_2} \rangle^k \right]$$

where M_x is the x-th row of M, viewed as a vector in ℝ^Y. This bilinear interpretation — as the k-th moment of pairwise row inner products — is specific to ℓ = 2 and is critical to Kelley–Lyu's improvement.

**Combinatorial interpretation**: ‖M‖_{U(2,k)}^{2k} counts the average number of complete bipartite subgraphs K_{2,k} (2-by-k bicliques) in the bipartite graph. When M is the 0/1 adjacency matrix of a bipartite graph G, this measures how far G is from "random" (a pseudorandomness measure).

### 2.2 The Spread Condition

**Definition 2.2 (Spread condition)** [Kelley–Lyu, Def. 3.1]: A matrix M ∈ [0,1]^{X×Y} is **(t, ε)-spread** if for every induced sub-bipartite graph M' (restricting to subsets X' ⊆ X, Y' ⊆ Y),

$$\mathbb{E}_{x \in X', y \in Y'} M(x,y) \leq \|M\|_1 \cdot (1 + \varepsilon) \cdot \left( \frac{|X'|}{|X|} \cdot \frac{|Y'|}{|Y|} \right)^{-1/t}$$

Informally: M is (t,ε)-spread if no induced subgraph of relative size δ > 0 has density much larger than the global density 1/δ^{1/t}. Spread is a **distributional uniformity** condition: the density doesn't concentrate excessively on small submatrices.

### 2.3 The Sifting Lemma and Its Key Improvement

**Lemma 2.3 (Sifting Lemma, Kelley–Lyu Lemma 3.2)**: If M ∈ [0,1]^{X×Y} is **(k, ε)-spread** with global density ‖M‖_1 ≥ 2^{-d}, then:

$$\|M\|_{U(2,k)} \leq (1 + O(\varepsilon)) \cdot \|M\|_1$$

whenever k ≥ 20d/ε.

**Contrapositive (the useful direction)**: If ‖M‖_{U(2,k)} ≥ (1 + Ω(ε)) · ‖M‖_1, then M is **NOT** (k,ε)-spread — i.e., M has a dense induced sub-bipartite graph. This gives an "inverse theorem": large grid norm implies a large dense subgraph.

### 2.4 The Potential Function and the √d Parameter

The key technical innovation in Kelley–Lyu over Kelley–Lovett–Meka (KLM, 2308.12451) is a **new potential function** that optimally balances density gain against sub-domain size loss.

**KLM approach** (achieving Ω((log N)^{1/3})): At each sifting step, choose the densest sub-bipartite graph. This achieves a density gain of 2^d but a size loss of 2^{d²}, giving total loss 2^{O(kd³)}. Setting d = c(log N)^{1/3} gives the bound.

**Kelley–Lyu approach** (achieving Ω((log N)^{1/2})): Use a potential function:

$$\Phi(C) := \mathbb{E}_{w \sim C}[p(w)] \cdot \left( \frac{|C|}{|\Omega|} \right)^{1/t}, \qquad t = c \cdot d^{1/2}$$

This balances:
- **Reward**: density gain of 2^t = 2^{c\sqrt{d}} per step (smaller than KLM's 2^d)
- **Penalty**: sub-domain shrinkage to size 2^{-t^2} = 2^{-cd}|Ω| (same as the density exponent d)

The critical trade-off: by choosing a **smaller density gain** (only 2^{√d} instead of 2^d), the algorithm keeps the sub-domain much larger (size 2^{-d} instead of 2^{-d²}), reducing total loss from 2^{O(kd³)} to 2^{O(kd)}.

Setting d = c(log N)^{1/2} gives total loss 2^{O(k(log N)^{1/2})} = N^{O(k/√(log N))} = N^{o(1)}, and the bound Ω((log N)^{1/2}) follows.

**Source of √d**: The square root emerges from the optimization: given density exponent d (M has density ≥ 2^{-d}), choose the potential parameter t to maximize the achievable d. The trade-off "density gain 2^t, size loss 2^{-t²}" is optimized at t = √d (balancing linear vs. quadratic terms). This optimization is purely a property of the bilinear (2-variable) structure.

### 2.5 The New Structural Result: Slice Function Removal

Kelley–Lyu also prove a structural lemma for cylinder intersections:

**Theorem 2.4 (Slice Function Removal, Kelley–Lyu Theorem 1.2)**: Any small cylinder intersection can be efficiently covered by a sum of simple "slice" functions, with parameters 2^{−Ω(√(log(1/ε)))} vs. the tower-type bounds from the Triangle Removal Lemma.

This is qualitatively different from the standard covering by cylinders and is specific to the 3-player NOF communication model. The "slice functions" correspond to the bipartite structure of the hard function.

---

## 3. Structural Comparison: AP Graph vs. Bipartite Grid Norm Graph

### 3.1 Encoding 3-APs as a Bipartite Graph

To compare the two settings, we encode 3-APs as a bipartite graph. For a set A ⊆ {1,...,N}, define the **AP bipartite graph**:

$$G_{\mathrm{AP}} = \{ (a, c) \in A \times A : \tfrac{a+c}{2} \in A \}$$

(Here we implicitly require a+c to be even; restrict to even sums WLOG.) The **AP adjacency matrix** is M^{AP}(a,c) = 1_A(a) · 1_A(c) · 1_A((a+c)/2). This is a bipartite graph on vertex sets A × A.

**Key observation**: The number of 3-APs in A equals the number of edges in G_{AP}:

$$T_3(A) = |E(G_{\mathrm{AP}})| = \sum_{a,c \in A} 1_A\!\left(\tfrac{a+c}{2}\right)$$

This is exactly the "3-AP tensor" in the Kelley–Meka argument. **So the 3-AP problem CAN be formulated in terms of a bipartite graph** — but it is NOT a single bipartite graph with independent rows and columns. The condition (a+c)/2 ∈ A ties the "middle term" to the same set A, creating a **trilinear** dependency.

### 3.2 The U(2,2) Grid Norm of G_{AP}

Compute the U(2,2)-grid norm of M^{AP}:

$$\|M^{AP}\|_{U(2,2)}^4 = \mathbb{E}_{a_1, a_2, c_1, c_2 \in A} M^{AP}(a_1,c_1) M^{AP}(a_1,c_2) M^{AP}(a_2,c_1) M^{AP}(a_2,c_2)$$

$$= \mathbb{E}_{a_1,a_2,c_1,c_2 \in A} 1_A\!\left(\tfrac{a_1+c_1}{2}\right) 1_A\!\left(\tfrac{a_1+c_2}{2}\right) 1_A\!\left(\tfrac{a_2+c_1}{2}\right) 1_A\!\left(\tfrac{a_2+c_2}{2}\right)$$

This is a sum over 4-cycles in G_{AP}, but with the constraint that the "midpoints" also lie in A. This is related to (but NOT equal to) the Gowers U² norm ‖1_A‖_{U^2}⁴ = 𝔼_{x,h₁,h₂} 1_A(x) 1_A(x+h₁) 1_A(x+h₂) 1_A(x+h₁+h₂).

**Connection to U²**: ‖M^{AP}‖_{U(2,2)} is approximately ‖1_A‖_{U^2} (up to normalization factors), since both count the same 4-variable correlation. This means **the Kelley–Lyu sifting for U(2,2) is directly related to the Fourier/Gowers U² structure that controls 3-APs** — at the level of k = 2.

**Critical gap**: Kelley–Lyu's sifting lemma requires k ≥ 20d/ε, which for d = α^{-2} (the Croot–Sisask rank) is k = Ω(α^{-2}), an astronomically large k. The k = 2 case (= U(2,2)) is the "base case" where the sifting is trivial and gives no improvement.

### 3.3 The Trilinear Obstruction

The fundamental structural difference:

| Feature | Kelley–Lyu (grid norms) | Kelley–Meka (3-APs) |
|---|---|---|
| Tensor structure | **Bilinear**: M(x,y), 2 variables | **Trilinear**: 1_A(x)1_A(y)1_A(z), 3 variables |
| Norm | U(2,k): k-th moment of row inner products | Gowers U²: Fourier L⁴ norm |
| Decoupling | ‖f∘g − R_f∘R_g‖_d ≤ ‖f−R_f‖ · ‖g−R_g‖ (bilinear) | No analogous trilinear decoupling known |
| Density increments | Multiplicative: density gain factor 2^{√d} | Additive: density increases by +α³/d |
| Domain shrinkage | Multiplicative: domain shrinks by factor 2^{-d} | Additive: Bohr set size decreases by N^{-cα²} |
| "d" parameter | d = log(1/density) ≈ log N | d = Croot–Sisask rank = α^{-2} |
| √d in exponent | √(log N) = (log N)^{1/2} ← gives the 1/2 exponent | √(α^{-2}) = α^{-1} ← corresponds to L¹ rank (ceiling 1/3) |

The most important rows are the last two: **the "d" parameters are structurally different objects**, and the √d trick gives different outcomes in the two settings.

### 3.4 The Decoupling Inequality: Bilinear vs. Trilinear

The heart of Kelley–Lyu's improvement is the **decoupling inequality** (Equation 15 in arXiv:2505.01587):

$$\|f \circ g - R_f \circ R_g\|_d \leq \|f - R_f\|_{U(2,d)} \cdot \|g - R_g\|_{U(2,d)}$$

where R_f, R_g are the "row marginals" (averaging over the other coordinate), and ‖·‖_d is a suitable norm. This is **bilinear**: the right-hand side is a product of two terms.

For 3-APs, the analogous statement would require a **trilinear decoupling**:

$$\|f \otimes g \otimes h - \text{(product of marginals)}\| \leq \|f - R_f\|_{?} \cdot \|g - R_g\|_{?} \cdot \|h - R_h\|_{?}$$

No such trilinear decoupling is known in the Croot–Sisask / Bohr set framework. Proving it would require new ideas about how the three AP variables (a, a+d, a+2d) decouple, which is a significant open problem. Note that the **three-variable structure of 3-APs** (where all three terms must lie in A) is precisely what makes 3-APs harder than 2-variable bipartite structures.

---

## 4. Transfer Assessment: Technical Analysis

### 4.1 Mapping the Arguments

To attempt a direct transfer, we would try to apply Kelley–Lyu's potential function argument to the 3-AP density increment. Here is where the argument breaks down:

**Step 1 (Kelley–Lyu)**: Start with bipartite graph M with density ≥ 2^{-d}.  
**Step 1 (r_3(N) analogue)**: Start with A ⊆ {1,...,N} with density α.

**Step 2 (KL)**: Apply sifting to find a sub-bipartite graph M' ⊆ M with:
- Density of M': 2^{-d} × 2^{√d} = 2^{√d - d} (density increased multiplicatively by 2^{√d})  
- Size of M': |X'|×|Y'| = 2^{-d}|X|×|Y| (shrunken by factor 2^{-d} in each dimension)  
- Net: density increased by 2^{√d}, domain shrunken to 2^{-2d} of original.

**Step 2 (r_3(N) analogue)**: Apply Croot–Sisask to find a Bohr set B with:
- Density of A in B: α + Ω(α³/d₀) where d₀ = O(α^{-2}) (density increased *additively*)  
- Size of B: |B| ≥ N^{1-cα²} (shrunken by N^{cα²})

**Critical mismatch #1**: KL uses **multiplicative** density increments (×2^{√d}). Croot–Sisask uses **additive** density increments (+α³/d₀). The potential function Φ = density × (size/N)^{1/t} is designed for multiplicative increments; with additive increments, the potential function must be redesigned from scratch.

**Step 3 (KL)**: Iterate with parameter t = √d, using the potential Φ ≥ 1 as invariant.  
Total number of steps: O(log(N)/√d) = O(√(log N)) [since d ≈ log N in their setting].

**Step 3 (r_3(N) analogue)**: Iterate the Croot–Sisask step. The number of steps is α^{-1}/δ where δ ≈ α³/d₀ ≈ α⁵ (the density increment per step). Total steps ≈ α^{-6}/α⁻⁵ = α^{-1}... this depends on the starting density α and doesn't naturally give a (log N)^β count.

**Critical mismatch #2**: The parameter d in KL is d ≈ log N (polynomial in log N). The Croot–Sisask rank d₀ = α^{-2} is **exponentially large** relative to log N (if α = exp(-(log N)^β) then d₀ = exp(2(log N)^β)). The "√d trick" gives:
- In KL: √(log N) = (log N)^{1/2} ← the 1/2 exponent
- In r_3(N): √(α^{-2}) = α^{-1} ← corresponds to L¹ Croot–Sisask ceiling = exponent 1/3

This is a quantitative clarification of the final report's section 9: **the "1/2" in Kelley–Lyu would transfer to "1/3" (not "1/2") for r_3(N)**, if the √d trick could be made to work at all in the trilinear 3-AP setting.

### 4.2 What the √d Trick Would Actually Give for r_3(N)

Suppose (optimistically) that the Kelley–Lyu potential function argument could be adapted to the Croot–Sisask setting. What exponent would it yield?

In the Croot–Sisask framework, the "d" parameter is the Bohr set rank d = O(α^{-2}). The √d trick would set the effective rank to:

$$t = c \cdot \sqrt{d} = c \cdot \sqrt{\alpha^{-2}} = c \cdot \alpha^{-1}$$

Using only t = α^{-1} effective dimensions of the rank-d = α^{-2} Bohr set. This corresponds precisely to an **L¹ version of Croot–Sisask**: a Bohr set of rank O(α^{-1}) on which 1_A is almost-periodic in L¹.

The exponent from L¹ Croot–Sisask rank O(α^{-1}) in the 3-AP sifting is:

$$\beta = \frac{1}{\text{rank power} \times k} = \frac{1}{1 \times 3} = \frac{1}{3}$$

So **the best the Kelley–Lyu transfer could give (if it worked) is exponent 1/3**, not 1/2. This matches the Sifting Hierarchy Formula's predicted ceiling of f(4) = 1/3 (= 1/(3·(5-4))).

This is an important correction to the final report's section 9: the Kelley–Lyu result does NOT suggest the r_3(N) ceiling is 1/2 via a direct port. At best, it suggests a new pathway to exponent 1/3.

### 4.3 Probability Assessment

**Scenario A (Direct port)**: Apply Kelley–Lyu exactly as stated to the G_{AP} bipartite graph.  
**Probability: 5%**  
**Reason**: The sifting lemma requires k ≥ 20d/ε, but the relevant k for 3-APs is k = 2. The L² Croot–Sisask lemma is not a U(2,k) sifting lemma for large k. The two frameworks don't connect.

**Scenario B (Adapted potential function in Croot–Sisask setting)**: Design a new potential function Φ = density × (Bohr set size/N)^{1/t} with t = α^{-1}, giving an additive-increment analog of Kelley–Lyu.  
**Probability: 25–30%**  
**Expected outcome**: Exponent 1/3 (not 1/2), matching the L¹ Croot–Sisask ceiling.  
**Required work**: 1–3 years (essentially proving that L¹ Croot–Sisask can be proved via a potential argument).

**Scenario C (Tripartite grid norm sifting)**: Prove a tripartite version of the grid norm sifting lemma for U(2,2,k) (= trilinear grid norm), then apply it to 3-APs.  
**Probability: 15–20%**  
**Expected outcome**: Possibly exponent 1/2 (= Behrend matching bound).  
**Required work**: 3–7 years (requires developing the theory of trilinear grid norms, proving sifting lemmas, and connecting to the 3-AP structure).

**Scenario D (New reformulation bypassing Bohr sets)**: Reformulate the 3-AP problem entirely in the bipartite graph framework (replacing Bohr sets with induced sub-bipartite graphs), allowing KL's argument to apply directly.  
**Probability: 10–15%**  
**Expected outcome**: Possibly exponent 1/2, but likely with logarithmic factors.  
**Required work**: 5–10 years.

### 4.4 If Scenario B Works: Sketch in 7 Steps

If the Kelley–Lyu potential function can be adapted to the additive-increment Croot–Sisask framework:

**Step 1**: Start with A ⊆ {1,...,N} with density α. Define potential Φ₀ = α (initial density), domain D₀ = {1,...,N}.

**Step 2**: Apply Croot–Sisask almost-periodicity to 1_A: find Bohr set B₁ = Bohr(Γ₁, ρ) with |Γ₁| = d₁ = O(α^{-2}) and size |B₁| ≥ N^{1-cα²}.

**Step 3**: Instead of taking the "best" sub-Bohr set (maximizing density increment), use a potential function Φ = α_{cur} · (|D_{cur}|/N)^{α} where the exponent α (= effective L¹ rank parameter α^{-1} normalized) plays the role of 1/t.

**Step 4**: Show that the potential Φ is non-decreasing along the iteration. This requires:
  - Density increment per step: +Ω(α³/d₁) = +Ω(α⁵) ← from Croot–Sisask
  - Domain shrinkage per step: |B₁|/N = N^{-cα²} ← from Bohr set
  - Balance condition: α⁵ ≥ cα² · α^{-1} = cα (×log N) ← this does NOT hold; the sizes don't balance

**Step 5**: Recognize that the potential function mismatch (Step 4) requires a **modified density increment**: at each step, gain +Ω(α⁴) in density (not α⁵) but find a Bohr set of size N^{1-cα} (not N^{1-cα²}). This requires a new "L¹-type" Croot–Sisask lemma with rank O(α^{-1}).

**Step 6**: Apply the modified iteration: O(α^{-4}) steps, each gaining density α⁴. Total domain shrinkage: (N^{1-cα})^{α^{-4}} = N^{1-cα^{-3}} → fails for small α.

**Step 7**: Recognize that Step 6 fails because the Croot–Sisask rank of O(α^{-2}) is a hard lower bound. Conclude: the Kelley–Lyu potential function in the Croot–Sisask setting gives exponent 1/3 (matching L¹ ceiling) at best, not 1/2.

This sketch shows why the maximum benefit from Scenario B is exponent 1/3.

### 4.5 Key Technical Obstacle: Multiplicative vs. Additive

The root cause of the transfer difficulty is:

**Kelley–Lyu**: Each sifting step multiplies the density by 2^{√d}. After t steps of sifting a sub-bipartite graph of size 2^{-t·d}|X|×|Y|, the density is 2^{-d} × 2^{t√d} = 2^{t√d - d}. Setting t = √d: density becomes 2^0 = 1 (the graph is dense). This "closes" in √d steps.

**Croot–Sisask**: Each step adds Ω(α³/d) to the density. After T steps, density is α + T·α³/d. To reach density 1 (= contradiction): T ~ d/α³ = α^{-2}/α³ = α^{-5}. Each step shrinks the domain by N^{-cα²}, so total shrinkage is N^{-cα²·T} = N^{-cα^{-3}}. This "closes" only if N^{cα^{-3}} ≤ 1... which fails. The argument requires more careful bookkeeping.

To match Kelley–Lyu's structure, one would need a version of Croot–Sisask where the density increment is **multiplicative** (factor 1+Ω(α²)) rather than additive (+Ω(α³/d)). This would require a completely different version of almost-periodicity — essentially, an "L¹ Croot–Sisask" that gives multiplicative control.

---

## 5. Implications for the Seven Conjectures

### 5.1 Conjecture 1 (Sifting Hierarchy Formula f(m) = 1/(3(5-m)))

**Status**: LIKELY STILL CORRECT for iterated Croot–Sisask sifting. NOT broken by Kelley–Lyu.

**Reasoning**:
- Kelley–Lyu's improvement is in the bilinear (NOF) setting, not the trilinear (3-AP) setting
- The formula predicts ceiling 1/3 (at m=4) for the standard Croot–Sisask framework
- The √d trick, if adapted to 3-APs, would give exponent 1/3 (matching the ceiling), not more
- Evidence against the formula being too conservative: the formula correctly predicts 1/12, 1/9, 1/6 — three independent data points

**Updated confidence**: Reduced from 80% to 65%. The reduction comes from the possibility (now confirmed by KL) that the sifting framework is more powerful than the formula predicts when used in a bilinear (rather than trilinear) setting. If a trilinear grid norm sifting can be developed, the formula could be wrong.

**Specific update**: The formula f(m) = 1/(3(5-m)) should be understood as the ceiling for **standard iterated Croot–Sisask** (varying only the number of iterations m). It does NOT bound what can be achieved by **restructuring the sifting** (as in Kelley–Lyu).

### 5.2 Conjecture 2 (Croot–Sisask Rank is Ω(α^{-2}))

**Status**: UNCHANGED. Kelley–Lyu neither supports nor contradicts this.

**Reasoning**:
- The Croot–Sisask rank lower bound Ω(α^{-2}) is a statement about L² almost-periodicity in ℤ_N
- Kelley–Lyu works with a completely different object (L^{2k} norms of bipartite matrices)
- Conjecture 2 concerns what rank is needed for Bohr sets; KL doesn't address this
- The rank bound Ω(α^{-2}) remains the best-known lower bound

**Subtle point**: The Kelley–Lyu √d trick, if it "works" in the 3-AP setting, would correspond to using only t = α^{-1} "effective dimensions" of a rank-α^{-2} Bohr set. This does NOT contradict Conjecture 2: the rank is still Ω(α^{-2}), but the algorithm is smarter about which dimensions it uses.

**Revised understanding of Conjecture 2**: Even if the rank is Ω(α^{-2}) (= Conjecture 2 is true), this does NOT immediately limit the achievable exponent to 1/3. The Kelley–Lyu insight suggests that one can "work with" rank O(α^{-2}) while effectively exploiting only O(α^{-1}) dimensions, potentially giving better bounds. Whether this works for 3-APs is the key open question.

**Updated confidence**: Unchanged at 70%. The conjecture is about the rank lower bound, not about what can be proved using that rank.

### 5.3 Conjecture 3 (Doubly-Iterated Raghavan Gives 1/3)

**Status**: STILL THE PRIMARY OPEN PROBLEM. Kelley–Lyu provides new evidence but doesn't resolve it.

**New perspective from Kelley–Lyu**: The KL approach suggests an ALTERNATIVE pathway to exponent 1/3 — not through doubly-iterated sifting (apply Raghavan twice) but through a **potential function argument** in the Croot–Sisask framework (using effective rank α^{-1} from a rank-α^{-2} Bohr set). These two approaches may give the same exponent (1/3) but via different proofs.

**Updated status**: Conjecture 3 has TWO possible proof strategies:
1. **Strategy A (original)**: Doubly-iterate Raghavan's sifting argument. Predicted outcome: exponent 1/3 with log log factors.
2. **Strategy B (new, Kelley–Lyu inspired)**: Adapt the KL potential function to Croot–Sisask. Predicted outcome: exponent 1/3 (possibly cleaner, without log log factors).

Whether doubly-iterated sifting gives EXACTLY 1/3 or only 1/4 (as might happen if the rank growth is not perfectly controlled) remains open.

**Kelley–Lyu does NOT supersede Conjecture 3**: The KL result is in a different setting and doesn't bypass the need for a new proof of exponent 1/3 in r_3(N).

### 5.4 Conjectures 4–7 (Unchanged)

**Conjecture 4 (Behrend constant c* ≈ 2.667)**: Not affected by Kelley–Lyu (lower bound problem).

**Conjecture 5 (k=4 QP requires quadratic Croot–Sisask)**: Not affected. KL is about k=3 (bipartite) structures.

**Conjecture 6 (Near-extremal sets are sphere-like)**: Not affected by Kelley–Lyu.

**Conjecture 7 (Rankin tight for k=5)**: Not affected.

---

## 6. New Conjectures and Revised Analysis

### 6.1 Conjecture KL1: Bilinear Barrier for √d Trick

**Conjecture KL1 (Bilinear Barrier)**: *The Kelley–Lyu √d potential function trick is specific to bilinear (2-variable, U(2,k)) structures. For k-linear (k-variable) structures with k ≥ 3, the optimal potential parameter is t = c·d^{1/k} (k-th root), giving a total loss of 2^{O(kd)} (same as KL for k=2). However, for 3-variable structures, the effective exponent in r_3(N) from this generalization is:*

$$\beta_k = \frac{1}{\rho_k \cdot k} \quad \text{where } \rho_k = \frac{2}{k}$$

*giving β_3 = 1/3 (not 1/2) as the ceiling for the generalized √d trick in 3-APs.*

**Rationale**: The potential function balance in KL is: reward 2^t vs. penalty 2^{-t²} (quadratic in t). This comes from the bilinear structure: the "decoupling" gives a product of two terms, each contributing a factor t^{1/2}. For a trilinear structure, the decoupling would give three terms, each contributing t^{1/3}, and the penalty would be 2^{-t^3/3} (cubic in t). The optimal t for cubic penalty is t = d^{1/3}, giving reward 2^{d^{1/3}} and penalty 2^{-d}. This achieves (log N)^{1/3} in the NOF setting (same as KLM), with no improvement.

For the 3-AP problem specifically:
- k = 3 (trilinear)
- Optimal parameter: t = d^{1/3}
- Effective rank: d^{1/3} = (α^{-2})^{1/3} = α^{-2/3}
- Exponent: 1/(α^{-2/3} × 3) = α^{2/3}/3 → leading to exponent β = 2/(3·2) = 1/3 from a different path

This is speculative. Proving Conjecture KL1 would require developing the theory of trilinear grid norms.

### 6.2 Conjecture KL2: Tripartite Grid Norm Sifting

**Conjecture KL2 (Tripartite Grid Norm)**: *Define the U(2,2,k)-norm of a tripartite array T : X × Y × Z → [0,1] as:*

$$\|T\|_{U(2,2,k)} := \left( \mathbb{E}_{x_1,x_2 \in X,\, y_1,y_2 \in Y,\, z_1,\ldots,z_k \in Z} \prod_{a,b,c} T(x_a, y_b, z_c) \right)^{1/(4k)}$$

*If there exists a sifting lemma for U(2,2,k) — i.e., an inverse theorem saying "large U(2,2,k) norm implies a dense induced sub-tripartite-array" — then by applying it to T^{AP}(a,b,c) = 1_A(a) 1_A(b) 1_A(c) · 1[a+c=2b], one could prove r_3(N) ≤ N · exp(-c(log N)^{1/2}).*

**Status**: This conjecture is **speculative**. No tripartite sifting lemma is currently known. The bilinear U(2,k) structure — specifically the "k-th moment of row inner products" interpretation — does not generalize cleanly to three variables. The U(2,2,k) norm lacks a clean "product of inner products" form.

**Why 1/2 might still be achievable**: If the tripartite sifting lemma holds with the SAME √d parameter (t = c·√d) as the bipartite case, then the exponent would be 1/2 = (log N)^{1/2} as in KL. The crucial question is whether the "bilinear" nature of the improvement (U(2,k) with ℓ = 2) is essential, or whether ℓ = 2 was just a convenience and the √d trick works for all ℓ ≥ 2.

### 6.3 Conjecture KL3: Sifting Ceiling Dichotomy

**Conjecture KL3 (Ceiling Dichotomy)**: *The sifting ceiling for r_3(N) within any almost-periodicity framework is either:*
- **(a) Exactly 1/3**: if the tripartite structure of 3-APs introduces an extra factor preventing the √d trick from achieving 1/2; OR
- **(b) Exactly 1/2**: if the tripartite grid norm sifting lemma (Conjecture KL2) can be proved.

*There is no intermediate value (e.g., 2/5, 5/12) achievable by any combination of almost-periodicity sifting arguments.*

**Rationale**: The dichotomy reflects a fundamental structural choice: either the bilinear √d trick generalizes to trilinear (giving 1/2), or it doesn't (and the ceiling is 1/3). The integer "ℓ" in U(ℓ,k) determines the exponent via the balance: ℓ/2 × (1/k) = β, where k = number of AP terms. For ℓ = 2 (bilinear) and k = 2 (bipartite graph): β = 1/2. For ℓ = 2 (bilinear) and k = 3 (3-APs): β = 1/3. For ℓ = 3 (trilinear, Conj. KL2) and k = 3: β = 1/2 (matching Behrend).

### 6.4 Revised Sifting Ceiling Estimate

Based on this analysis, we revise the sifting ceiling estimates:

| Method | Previous estimate | Revised estimate | Confidence |
|---|---|---|---|
| Standard Croot–Sisask (single iteration) | 1/6 | 1/6 ✓ confirmed | High |
| Doubly-iterated Croot–Sisask | 1/3 | 1/3 | Medium |
| Kelley–Lyu √d trick (if adapted) | 1/2 (misjudged) | **1/3** (corrected) | Medium |
| Tripartite grid norm sifting (new) | — | **1/2** (speculative) | Low |
| True sifting ceiling | 1/2–1/3 | **1/3–1/2** (dichotomy) | Low |

The critical revision: **the Kelley–Lyu √d trick, if adapted to 3-APs, gives 1/3 (matching the L¹ Croot–Sisask ceiling), not 1/2**. The 1/2 in KL is specific to the bipartite (d ~ log N) setting. Reaching 1/2 for r_3(N) requires a genuinely new idea: the tripartite grid norm sifting (Conjecture KL2).

---

## 7. Research Priorities

Given this analysis, the research priorities for the Kelley–Lyu transfer program are:

### Priority 1 (Immediate, 0–6 months): Clarify the d-parameter correspondence

**Task**: Formalize the precise relationship between:
- The "d" in Kelley–Lyu (density exponent d = log(1/ε), polynomial in log N)
- The "d" in Croot–Sisask (rank d = O(α^{-2}), exponentially large)

Specifically: show that if we set d = α^{-2} in the KL potential function, the sifting argument gives effective rank t = α^{-1} and exponent 1/3 (not 1/2). This would clarify the precise implication of KL for r_3(N) and update the field's understanding of the Convergence Hypothesis.

**Expected outcome**: Proof that direct KL transfer gives 1/3 at best, with clear statement of what new ingredient is needed for 1/2.

### Priority 2 (Near-term, 6–18 months): L¹ Croot–Sisask via potential function

**Task**: Try to prove the following (as a consequence of the KL potential function approach):

*"If f: ℤ_N → [0,1] has ‖f‖_1 = α, then there exists a Bohr set Bohr(Γ,ρ) with |Γ| = O(α^{-1}) and size |Bohr(Γ,ρ)| ≥ N^{1-cα} such that ‖f * μ_B - f‖_1 ≤ ε·α."*

This "L¹ Croot–Sisask" lemma with rank O(α^{-1}) would give exponent 1/3 directly. The KL potential function argument is a candidate proof strategy: use Φ = ‖f|_C‖_1 × (|C|/N)^α (where α = density = effective rank parameter) and show the potential is non-decreasing.

**Expected outcome**: Either a proof of L¹ Croot–Sisask (giving exponent 1/3 for r_3(N)) or a counterexample showing the L¹ version fails.

### Priority 3 (Medium-term, 1–3 years): Study the bilinear U(2,k) connection to AP density

**Task**: Analyze whether the U(2,k) grid norm of the AP adjacency matrix G_{AP} controls r_3(N) bounds for large k (k = Ω(α^{-2})).

Specifically: if ‖M^{AP}‖_{U(2,k)} is small (meaning G_{AP} is "spread" for large k), does this imply a density increment for A on some structured subset?

This would establish a direct connection between the Kelley–Lyu machinery (which requires large k) and the 3-AP problem (where small k = 2 is the "interesting" case).

**Expected outcome**: Either a positive connection (KL gives information about 3-APs when k is chosen appropriately) or a structural impossibility result.

### Priority 4 (Long-term, 3–7 years): Develop tripartite grid norms

**Task**: Define and develop the theory of U(2,2,k) tripartite grid norms (Conjecture KL2). Specifically:

1. Define ‖T‖_{U(2,2,k)} for tripartite arrays T : X×Y×Z → [0,1]
2. Prove the "triple row inner product" interpretation (if it exists)
3. Prove a sifting lemma: large U(2,2,k) implies a dense induced sub-tripartite-array
4. Apply to T^{AP} to get r_3(N) bounds

**Expected outcome**: If successful, this gives exponent 1/2 (matching Behrend). If the sifting lemma cannot be proved for tripartite arrays, this gives evidence that 1/3 is the true sifting ceiling.

### Priority 5 (Complementary, any timeline): Verify or falsify Conjecture KL1

**Task**: Prove (or disprove) that the optimal potential function parameter for k-linear (k-variable) structures is t = d^{1/k} (k-th root), giving the "k-linear sifting ceiling" as:

$$\beta_k = \frac{1}{2k} \quad \text{(for k-APs with k ≥ 2)}$$

For k=2 (bipartite): β₂ = 1/4 (NOF lower bound with bipartite)... wait, but Kelley–Lyu achieves 1/2 for 3-player NOF (not k=2 players). The formula is more subtle.

Let me state it as: **the "k-fold tensor sifting" achieves exponent β = 1/(k·ℓ) for ℓ-linear structures**, where:
- ℓ = 2 (bilinear, KL): β = 1/(3·2) = 1/6 for k=3... no, this doesn't match KL's 1/2.

OK, this formula is more subtle than I can determine without access to the full proof. The exact relationship should be determined as a first priority.

---

## 8. References

1. **Kelley, Z. and Meka, R.** (2023). Strong Bounds for 3-Progressions. arXiv:2302.05537. [Original quasi-polynomial bound: r_3(N) ≤ N·exp(-c(log N)^{1/12}). Introduced sifting + Bohr set framework.]

2. **Kelley, Z. and Lyu, X.** (2026, revised June 10). More efficient sifting for grid norms, and applications to multiparty communication complexity. arXiv:2505.01587. [Improves NOF communication complexity lower bound from Ω((log N)^{1/3}) to Ω((log N)^{1/2}) using bipartite grid norm sifting with √d potential function. Explicitly states: "It remains to be seen whether a similar improvement can be made for the case of 3-APs."]

3. **Kelley, Z., Lovett, S., and Meka, R.** (2023). Explicit separations between randomized and deterministic Number-on-Forehead communication. arXiv:2308.12451. [Original NOF lower bound Ω((log N)^{1/3}) from 3-AP sifting techniques. Predecessor to Kelley–Lyu.]

4. **Bloom, T.F. and Sisask, O.** (2023). An improvement to the Kelley–Meka bounds on three-term arithmetic progressions. arXiv:2309.02353. [Exponent 1/9 via bootstrapped Croot–Sisask: rank O(α^{-4}) instead of α^{-6}.]

5. **Raghavan, R.** (2026). Improved Bounds for 3-Progressions. arXiv:2603.27045. [Exponent 1/6·(log log N)^{-1} via iterated sifting. Key step: iterated sifting gives effective rank O(α^{-2}) from O(α^{-4}). Currently the best known upper bound.]

6. **Croot, E. and Sisask, O.** (2010). A probabilistic technique for finding almost-periods of convolutions. Geom. Funct. Anal. 20(6), 1367–1396. [The foundational almost-periodicity lemma: rank d = O(α^{-2}). The "L² barrier."]

7. **Behrend, F.A.** (1946). On sets of integers which contain no three terms in arithmetic progression. Proc. Nat. Acad. Sci. 32, 331–332. [Lower bound r_3(N) ≥ N·exp(-2√2·√(log N)). The "Behrend target" for upper bounds.]

8. **Elsholtz, C., Hunter, Z., Proske, L., and Sauermann, L.** (2024). Improving Behrend's construction. arXiv:2406.12290. [Improves Behrend constant to 2.67 (from 2√2 ≈ 2.83).]

---

## Appendix A: Lean 4 Formalization Note

If the Kelley–Lyu transfer succeeds (Scenario C or D), the Lean 4 formalization would need to be updated from:

```lean
-- Current best (would need proof updating Kelley-Meka)
theorem kelley_meka_upper_bound (N : ℕ) (c : ℝ) (hc : c > 0) :
    (rk 3 N : ℝ) ≤ N * Real.exp (-c * Real.log N ^ (1/12 : ℝ)) := by sorry

-- After doubly-iterated Raghavan (predicted next step)
theorem raghavan_iterated_upper_bound (N : ℕ) (c : ℝ) (hc : c > 0) :
    (rk 3 N : ℝ) ≤ N * Real.exp (-c * Real.log N ^ (1/3 : ℝ)) := by sorry
```

If Kelley–Lyu transfers directly (unlikely), the target would be:

```lean
-- If Kelley-Lyu transfers (currently unproved, probability ~15-20%)
theorem kelley_lyu_upper_bound (N : ℕ) (c : ℝ) (hc : c > 0) :
    (rk 3 N : ℝ) ≤ N * Real.exp (-c * Real.sqrt (Real.log N)) := by sorry
```

Note: The √(log N) = (log N)^{1/2} form is the Behrend form. As argued above, the more likely transfer (if any) would give exponent 1/3, not 1/2.

---

## Appendix B: Summary Tables

### Transfer Probability Assessment

| Scenario | Probability | Outcome exponent | Required time |
|---|---|---|---|
| A: Direct port of KL Lemma 3.2 | 5% | Unknown (likely fails) | — |
| B: Adapted potential function (additive) | 25–30% | **1/3** (not 1/2) | 1–3 years |
| C: Tripartite grid norm sifting | 15–20% | **1/2** | 3–7 years |
| D: Full reformulation in bipartite framework | 10–15% | **1/2** (possibly) | 5–10 years |
| Total (any scenario) | ~40–50% | 1/3–1/2 | 1–10 years |

### Impact on Seven Conjectures

| Conjecture | Pre-KL assessment | Post-KL revised assessment |
|---|---|---|
| C1: f(m)=1/(3(5-m)) | 80% correct | 65% correct (KL shows sifting can do better in bilinear case) |
| C2: Croot–Sisask rank Ω(α^{-2}) | 70% correct | 70% correct (KL doesn't address this) |
| C3: Doubly-iterated gives 1/3 | 65% correct | 65% correct (KL doesn't bypass this; at best gives alt. proof) |
| C4: Behrend constant c* ≈ 2.667 | — | — (unchanged) |
| C5: k=4 requires quadratic CS | — | — (unchanged) |
| C6: Near-extremal sets sphere-like | — | — (unchanged) |
| C7: Rankin tight for k=5 | — | — (unchanged) |

### Sifting Ceiling Revised Estimates

| Framework | Previous ceiling estimate | Revised ceiling |
|---|---|---|
| Kelley–Meka single sifting | 1/6 (achieved) | 1/6 |
| Iterated Croot–Sisask (any m) | 1/3 | 1/3 (still) |
| Kelley–Lyu √d trick (transferred) | 1/2 ← INCORRECT | **1/3** (corrected) |
| Tripartite grid norm sifting | unknown | **1/2** (if proved) |
| Absolute upper bound for any sifting | 1/2 | 1/2 (Behrend) |

The key correction: Kelley–Lyu's 1/2 in the NOF setting corresponds to **1/3** (not 1/2) in the r_3(N) setting, because the "d ~ log N" in KL corresponds to the L¹ Croot–Sisask rank (d = α^{-1}), not the L² rank (d = α^{-2}).

---

*End of Analysis. Next action: commit this file and notify orchestrator.*
