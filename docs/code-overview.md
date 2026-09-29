# Code Overview

← [Back to README](../README.md)

A walkthrough of each original script. Line numbers refer to the files in
[`src/`](../src/) exactly as they are stored. Quoted comments are translated from
Spanish where it helps.

## General Characteristics (all scripts)

| Aspect | Observation |
|---|---|
| Type | MATLAB **scripts**, not functions. They run top to bottom in the base workspace. |
| Header comments | The `metInterpolacion*` files say "Función para…" ("function to…") but they are scripts. |
| Data | Hard-coded in each file |
| Dependencies between files | **None.** Each script is standalone. |
| Encoding / line endings | ISO-8859-1, CRLF |
| Workspace side effects | The `metInterpolacion*` scripts start with `clear all; clc;` |
| Output | One figure; coefficient variables left in the workspace |

There is no shared module, entry point, or call graph, so the project has **no
architecture** beyond four independent scripts. For that reason no
`architecture.md` is provided.

---

## `metInterpolacionLagrange.m`

**Header:** `%MÉTODO DE INTERPOLACIÓN DE LAGRANGE` ("Lagrange interpolation method")

| Lines | What happens |
|---|---|
| 1–4 | Header comments describing inputs `x` and `fx` |
| 5–6 | `clear all; clc;` |
| 7–10 | Commented-out "original function" `xo`, `fxo = (xo.^2).*exp(-xo)` |
| 13–16 | Data: `x = [0;10;20;30;40;50]`, `fx = [0.013;…;0.07]` (an analytic `fx` is commented out) |
| 20 | `N = length(x)` |
| 23–33 | Double loop that fills `FN` (numerator roots) and `FD` (denominator factors), using `ind` to skip `m == k` |
| 35–37 | `CN(k,:) = poly(FN(k,:))`: expands each numerator into monomial coefficients |
| 38 | `Fac = prod(FD,2)`: product of each denominator row |
| 40–42 | `Multi(k,:) = CN(k,:)*fx(k)/Fac(k)`: scales each basis polynomial |
| 43 | `Coef = sum(Multi)`: final coefficients, highest degree first |
| 46–48 | Evaluates on `xp = -20:0.01:100` with `polyval` |
| 51–54 | Plots points (`*`) and polynomial (red). Two-entry legend. `axis([-20,100,-.2,.2])` |
| 57–65 | Comment on the coefficient order and the commented Runge error-check snippet |

**Key variables:** `FN`, `FD`, `CN`, `Fac`, `Multi`, `Coef`, `xp`, `Fxp`.

---

## `metInterpolacionNewton.m`

**Header:** `%MÉTODO DE NEWTON EN DIFERENCIAS` ("Newton divided-difference method")

| Lines | What happens |
|---|---|
| 1–5 | Header comments |
| 6–7 | `clear all; clc;` |
| 8–11 | Commented-out original function on `[-3/2, 7/2]` |
| 14–17 | Same hard-coded dataset as Lagrange |
| 20–26 | `N`, `P = N-1`, table `Tb = [x fx zeros(N,P)]` |
| 28–34 | Divided-difference table filled column by column |
| 36 | `Newton = Tb(1,2:P+2)`: Newton coefficients |
| 40–46 | For each `k`, `Newton(k)*poly(x(1:k-1))` placed right-aligned in `Coef` |
| 53 | `Pol = sum(Coef)`: final coefficients, highest degree first |
| 55–58 | Evaluates on `xp = -10:0.01:60` |
| 61–65 | Plots points and polynomial. **Three**-entry legend for two plotted series. `axis([-20,100,-.2,.2])` |
| 67–77 | Comment on coefficient order and the commented Runge error-check snippet |

**Key variables:** `Tb`, `Newton`, `Coef`, `Pol`, `xp`, `Fxp`.

Note: the name `Pol` is used twice. Inside the loop (line 43) it holds one
expanded term. At line 53 it is overwritten with the final polynomial.

---

## `metInterpolacionVandermonde.m`

**Header:** `%MÉTODO DE MATRIZ DE VANDERMONDE` ("Vandermonde matrix method")

| Lines | What happens |
|---|---|
| 1–3 | Header comments |
| 4–5 | `clear all; clc;` |
| 7–10 | Commented-out original function |
| 13–16 | Same hard-coded dataset |
| 19 | `N = length(x)` |
| 22–25 | Builds the Vandermonde matrix `V` by appending columns `x.^(k-1)` |
| 26 | `A = inv(V)*fx`: coefficients, ascending order |
| 27–28 | `A = A.'` then `fliplr(A)`: row vector in descending order for `polyval` |
| 30–31 | Evaluates on `xp = -1000:0.01:1000` (200,001 points) |
| 35–39 | Plots points and polynomial. Three-entry legend. `axis([-20,100,-.2,.2])` |
| 41–49 | Comment on coefficient order and a generic version of the error-check snippet ("PUNTOS de interopolacion", "Coeficientes") |

**Key variables:** `V`, `A`, `xp`, `Fxp`.

---

## `Vandermonde.m`

Has no header comment and does **not** clear the workspace.

| Lines | What happens |
|---|---|
| 1–4 | Interval `a = -2`, `b = 2`; `k = 9` (number of nodes) |
| 5 | `xn = linspace(a,b,9)`: nodes (`9` is repeated as a literal rather than using `k`) |
| 6 | `x = linspace(-5,5,1000)`: evaluation grid |
| 8–9 | Runge's function `1./(1+x.^2)` on the grid (`y`) and at the nodes (`yn`) |
| 10 | Commented preliminary plot |
| 11–14 | Builds the 9×9 Vandermonde matrix `A` from `ones(k,1)` and powers of `xn'` |
| 15 | `C = inv(A)*yn'`: coefficients, **ascending** order |
| 16–19 | Reuses `A` for a 1000×9 evaluation matrix of powers of `x'` |
| 20 | `PK = A*C`: polynomial values on the grid |
| 21–22 | Plots true function (blue), nodes (red `*`), polynomial (red). `axis([-5,5,0,1.5])` |

**Key variables:** `xn`, `yn`, `A`, `C`, `PK`.

Relationship to the other scripts: the commented error-check block at the end of
the three `metInterpolacion*` files contains the polynomial this script computes,
rounded to four decimals (see [project-context.md](project-context.md#traces-of-experimentation-in-the-code)).

---

## Comparison

| | Lagrange | Newton | Vandermonde (`met…`) | Vandermonde (Runge) |
|---|---|---|---|---|
| Coefficient build | `poly` + scaling | Divided differences + `poly` | `inv(V)*fx` | `inv(A)*yn'` |
| Evaluation | `polyval` | `polyval` | `polyval` | Matrix product |
| Result variable | `Coef` | `Pol` | `A` | `C` (ascending) |
| Grid | `-20:0.01:100` | `-10:0.01:60` | `-1000:0.01:1000` | 1000 pts on `[-5,5]` |
| `clear all` | yes | yes | yes | no |
| Legend entries / series | 2 / 2 | 3 / 2 | 3 / 2 | none |
