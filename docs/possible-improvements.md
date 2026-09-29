# Possible Improvements

← [Back to README](../README.md)

> **None of these changes have been applied.** This page lists observations about
> the original code so that a reader knows its limitations. The files in
> [`src/`](../src/) are deliberately left exactly as written, to preserve the
> original implementation. Any modernized version should live in a separate
> location (for example a new `modern/` folder or a separate repository), never
> in place of the originals.

## Observed Defects

| # | File | Observation | Effect |
|---|---|---|---|
| D1 | `metInterpolacionNewton.m` (l. 62–63), `metInterpolacionVandermonde.m` (l. 36–37) | `legend` has three labels (`'Gráfica original'`, `'Puntos iniciales'`, `'Polinomio interpolador'`) but only two series are plotted, because the plot of the original function is commented out. | MATLAB ignores the extra entry (with a warning). The data points get the label "Gráfica original" and the polynomial gets "Puntos iniciales", so the legend is wrong. |
| D2 | `metInterpolacionNewton.m` (l. 55, 65) | The evaluation grid is `-10:0.01:60` but the axis window is `[-20, 100]`. | Part of the plot window has no curve. |
| D3 | `metInterpolacionVandermonde.m` (l. 30) | The grid `-1000:0.01:1000` (200,001 points) is evaluated, but only `[-20, 100]` is shown. | Unneeded computation. Harmless. |
| D4 | `Vandermonde.m` (l. 4–5) | `k = 9` is defined, but `linspace(a,b,9)` repeats the literal `9`. | Changing `k` alone gives a matrix size mismatch. |
| D5 | `metInterpolacion*.m` (header) | The comments describe each file as a "Función" (function), but they are scripts. | Misleading. Inputs cannot be passed as arguments. |
| D6 | `metInterpolacionVandermonde.m` (l. 26–28) | Inline comments contain a stray `%` (e.g. `…de la matriz de % Vandermonde.`), probably from text copied out of wrapped lines. | Cosmetic. |
| D7 | Commented block, `metInterpolacionVandermonde.m` (l. 10) | The commented `fxo` expression uses `/` and `*` where element-wise `./` and `.*` would be needed. | None today (the line is commented out). It would fail or give wrong results if re-enabled. |

## Numerical Practice

- **`inv(V)*fx` → `V\fx`.** Solving with backslash is faster and numerically more
  stable than forming the explicit inverse. MATLAB's own documentation discourages
  `inv` for solving systems.
- **Conditioning.** With nodes `0…50`, the Vandermonde matrix has entries up to
  `50⁵`. Centering and scaling the nodes (for example mapping them to `[-1, 1]`),
  or skipping the monomial basis, would improve accuracy.
- **Evaluate in Newton / barycentric form.** Expanding into monomial coefficients
  with `poly` loses the numerical advantages of the Lagrange and Newton forms.
  Nested (Horner-like) evaluation of the Newton form, or barycentric Lagrange
  interpolation, would be more stable.
- **Runge's phenomenon.** Chebyshev nodes, or piecewise interpolation (`spline`,
  `pchip`), avoid the oscillation that equally spaced nodes produce for
  `1/(1+x²)`.

## Code Structure

- Convert each script into a function, e.g. `coef = lagrangeInterp(x, fx)`, so it
  can be reused and tested.
- Remove `clear all`. It wipes the caller's workspace and clears cached compiled
  functions (a performance cost).
- Preallocate `FN`, `FD`, `CN`, `Multi`, `Coef`, and `V` instead of growing them
  inside loops.
- Remove the `ind` flag in the Lagrange loop by indexing with
  `x([1:k-1, k+1:N])`.
- Move the shared dataset to one place (a data file or a shared function) instead
  of copying it into three scripts.
- Avoid reusing the name `Pol` for two different things in the Newton script.

## Repository / Tooling

- Convert source files to UTF-8 for modern MATLAB releases. This would change the
  original bytes, so it is **not** recommended for the files in `src/`.
- Add a small test that checks all three methods produce the same coefficients
  within a tolerance, and that `P(xᵢ) = fᵢ`.
- Verify and document compatibility with GNU Octave.
