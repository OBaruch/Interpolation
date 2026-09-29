# Numerical Methods

← [Back to README](../README.md)

This page covers the mathematics behind the scripts in [`src/`](../src/). It is
background written for this documentation. The original code has no such
explanation beyond its short Spanish comments.

## The Interpolation Problem

Given `N` distinct nodes `x₁, …, x_N` and values `f₁, …, f_N`, there is exactly one
polynomial `P` of degree `≤ N-1` with

```
P(xᵢ) = fᵢ     for i = 1, …, N
```

All three methods in this repository build **that same polynomial**. They differ
only in how they get there. Each script ends by turning the result into a vector
of monomial coefficients so it can be evaluated with `polyval`.

---

## 1. Vandermonde Matrix

**Scripts:** [`metInterpolacionVandermonde.m`](../src/metInterpolacionVandermonde.m),
[`Vandermonde.m`](../src/Vandermonde.m)

Write `P(x) = a₀ + a₁x + … + a_{N-1}x^{N-1}` and apply the conditions
`P(xᵢ) = fᵢ`. This gives a linear system `V·a = f`:

```
┌ 1  x₁   x₁²  …  x₁^{N-1} ┐ ┌ a₀      ┐   ┌ f₁  ┐
│ 1  x₂   x₂²  …  x₂^{N-1} │ │ a₁      │   │ f₂  │
│ ⋮                    ⋮   │ │ ⋮       │ = │ ⋮   │
└ 1  x_N  x_N² …  x_N^{N-1}┘ └ a_{N-1} ┘   └ f_N ┘
```

How the code does it:

- Builds `V` column by column (`V = [V x.^(k-1)]`).
- Solves with `inv(V)*fx`.
- Reverses the coefficients (`fliplr`) to get the descending order that `polyval`
  expects.
- `Vandermonde.m` builds the same matrix with `ones` plus a loop. For evaluation,
  it builds a second 1000-row Vandermonde matrix and computes `A*C` instead of
  calling `polyval`.

Known property: Vandermonde matrices become **ill-conditioned** as `N` grows or
as the nodes spread far from 0. With nodes `0…50` and degree 5 the entries reach
`50⁵ ≈ 3·10⁸`.

## 2. Lagrange Form

**Script:** [`metInterpolacionLagrange.m`](../src/metInterpolacionLagrange.m)

```
P(x) = Σₖ fₖ · Lₖ(x),      Lₖ(x) = Π_{m≠k} (x − x_m) / (x_k − x_m)
```

How the code does it:

1. For each `k`, it collects the nodes `x_m` (`m ≠ k`) into row `k` of `FN`
   (numerator roots) and the differences `x_k − x_m` into row `k` of `FD`
   (denominator factors). A flag `ind` shifts the column index to skip `m = k`.
2. `poly(FN(k,:))` expands `Π (x − x_m)` into monomial coefficients (`CN`).
3. `prod(FD,2)` gives each denominator.
4. Each row is scaled by `fₖ / denominator` (`Multi`), and the rows are summed
   (`Coef`).

## 3. Newton Divided Differences

**Script:** [`metInterpolacionNewton.m`](../src/metInterpolacionNewton.m)

```
P(x) = f[x₁] + f[x₁,x₂](x−x₁) + f[x₁,x₂,x₃](x−x₁)(x−x₂) + …

f[xᵢ,…,x_{i+k}] = ( f[x_{i+1},…,x_{i+k}] − f[xᵢ,…,x_{i+k-1}] ) / ( x_{i+k} − xᵢ )
```

How the code does it:

1. Allocates a table `Tb = [x fx zeros(N,N-1)]`.
2. Fills column `k+2` from column `k+1`. When done, row 1, columns `2…N+1`, holds
   the Newton coefficients (`Newton`).
3. For each `k`, `poly(x(1:k-1))` expands `(x−x₁)…(x−x_{k-1})`. The result is
   scaled by the `k`-th coefficient and placed, right-aligned, into row `k` of
   `Coef`.
4. `sum(Coef)` gives the monomial coefficients (`Pol`).

---

## Runge's Function (`Vandermonde.m`)

`Vandermonde.m` interpolates `f(x) = 1/(1+x²)` at 9 equally spaced nodes on
`[-2, 2]` (degree 8) and plots the result on `[-5, 5]`, far outside the node
interval. The resulting polynomial is:

```
P(x) ≈ 1 − 0.9446x² + 0.6292x⁴ − 0.2092x⁶ + 0.0246x⁸
```

*(This matches the commented check block at the end of the other scripts; see
[project-context.md](project-context.md#traces-of-experimentation-in-the-code).)*

Runge's function is the textbook example where high-degree interpolation on
equally spaced nodes oscillates near the ends of the interval. Outside `[-2, 2]`,
the `x⁸` term takes over and the polynomial moves quickly away from `f`. The
figure is clipped to `y ∈ [0, 1.5]`, which makes this divergence visible.
Whether the script was meant to show Runge's phenomenon, extrapolation error, or
both is **not stated** in the code (inferred).

## The Shared Dataset

The three `metInterpolacion*` scripts use:

| x | 0 | 10 | 20 | 30 | 40 | 50 |
|---|---|---|---|---|---|---|
| f(x) | 0.013 | 0.025 | 0.032 | 0.044 | 0.052 | 0.070 |

The degree-5 interpolant (computed independently, exact arithmetic):

```
P(x) = 0.013 + 3.098333e-3·x − 3.370833e-4·x² + 1.866667e-5·x³ − 4.291667e-7·x⁴ + 3.5e-9·x⁵
```

Sample values that help explain the plots (independent computation):
`P(-20) ≈ −0.413`, `P(-10) ≈ −0.075`, `P(60) ≈ 0.177`, `P(100) ≈ 7.70`.
The fixed axis window `[-20, 100] × [-0.2, 0.2]` therefore shows the data region
and the start of the divergence on both sides.

The physical meaning of the dataset is **unknown**.
