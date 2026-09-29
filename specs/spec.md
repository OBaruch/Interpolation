# Specification

> **Status:** As-built. Reverse-engineered from `src/` (2026).
> **Artifact chain:** [Intent](intent.md) → **Spec** → [Plan](plan.md)
>
> This spec describes what the **existing** code does, including its defects. It
> is not a to-do list for changing the code. Requirement IDs let the
> documentation, plan, and future work refer to specific behaviors. Where the
> code and its comments disagree, the **code** is treated as the source of truth
> and the difference is noted.

## 1. System Overview

| Item | Value |
|---|---|
| Language / runtime | MATLAB (version unknown) |
| Components | 4 standalone scripts, no shared code |
| External dependencies | None (core MATLAB functions only) |
| I/O | Hard-coded data in, one figure plus workspace variables out |

## 2. Shared Definitions

- **Dataset D₆** (used by all `metInterpolacion*` scripts):
  `x = [0;10;20;30;40;50]`, `fx = [0.013;0.025;0.032;0.044;0.052;0.07]` (column vectors).
- **Runge setup R₉** (used by `Vandermonde.m`): 9 nodes `linspace(-2,2,9)`,
  `f(x) = 1./(1+x.^2)`.
- **Descending coefficients:** a row vector `[c_{n}, …, c_1, c_0]` compatible
  with `polyval`.

## 3. Functional Requirements (as built)

### FR-L: Lagrange interpolation (`src/metInterpolacionLagrange.m`)

| ID | Requirement |
|---|---|
| FR-L1 | Clears the workspace and command window (`clear all; clc;`). |
| FR-L2 | Loads dataset D₆. |
| FR-L3 | For each node `k`, builds the numerator roots `{x_m : m≠k}` and the denominator factors `{x_k − x_m : m≠k}`. |
| FR-L4 | Expands each numerator with `poly`, scales it by `fx(k)/Π(x_k − x_m)`, and sums the rows to produce `Coef` (descending, length `N`). |
| FR-L5 | Evaluates `Coef` on `xp = -20:0.01:100` with `polyval`. |
| FR-L6 | Plots the points (`*`) and the polynomial (red), with legend `{'Puntos iniciales','Polinomio interpolador'}` and axis `[-20 100 -0.2 0.2]`. |

### FR-N: Newton divided differences (`src/metInterpolacionNewton.m`)

| ID | Requirement |
|---|---|
| FR-N1 | Clears the workspace and command window. |
| FR-N2 | Loads dataset D₆. |
| FR-N3 | Builds the divided-difference table `Tb` (`N × (N+1)`: column 1 = `x`, column 2 = `fx`, columns 3…N+1 = differences of order 1…N−1). |
| FR-N4 | Takes the Newton coefficients from `Tb(1, 2:N+1)`. |
| FR-N5 | Expands `Newton(k)·Π_{j<k}(x − x_j)` with `poly`, right-aligns each result into `Coef`, and sums to produce `Pol` (descending). |
| FR-N6 | Evaluates on `xp = -10:0.01:60`. |
| FR-N7 | Plots the points and the polynomial with a **three-entry** legend `{'Gráfica original','Puntos iniciales','Polinomio interpolador'}` (only two series exist) and axis `[-20 100 -0.2 0.2]`. |

### FR-V: Vandermonde interpolation (`src/metInterpolacionVandermonde.m`)

| ID | Requirement |
|---|---|
| FR-V1 | Clears the workspace and command window. |
| FR-V2 | Loads dataset D₆. |
| FR-V3 | Builds `V = [x.^0, x.^1, …, x.^(N-1)]`. |
| FR-V4 | Computes `A = inv(V)*fx`, transposes it, and applies `fliplr` to get descending order. |
| FR-V5 | Evaluates on `xp = -1000:0.01:1000`. |
| FR-V6 | Plots as in FR-N7 (three-entry legend, same axis window). |

### FR-R: Runge / Vandermonde demo (`src/Vandermonde.m`)

| ID | Requirement |
|---|---|
| FR-R1 | Does **not** clear the workspace. |
| FR-R2 | Uses setup R₉ and a 1000-point evaluation grid on `[-5, 5]`. |
| FR-R3 | Builds a 9×9 Vandermonde matrix from `xn` and computes `C = inv(A)*yn'` (**ascending** order). |
| FR-R4 | Evaluates by building a 1000×9 power matrix of the grid and computing `PK = A*C`. |
| FR-R5 | Plots the true function (blue), the nodes (red `*`), and the polynomial (red), with axis `[-5 5 0 1.5]`. No legend. |

## 4. Acceptance Criteria (observable behavior)

These describe what a correct run of the **original** code produces. They were
derived analytically (exact rational arithmetic) during documentation. They have
**not** been confirmed by running MATLAB in this environment.

| ID | Criterion |
|---|---|
| AC-1 | `Coef` (FR-L), `Pol` (FR-N), and `A` (FR-V) are equal within floating-point tolerance to `[3.5e-9, -4.291667e-7, 1.866667e-5, -3.370833e-4, 3.098333e-3, 0.013]`. |
| AC-2 | For each of those vectors, `polyval(c, x)` reproduces `fx` at all 6 nodes (tolerance ≈ 1e-10). |
| AC-3 | `C` from FR-R, rounded to 4 decimals, equals `[1; 0; -0.9446; 0; 0.6292; 0; -0.2092; 0; 0.0246]`, which is the polynomial in the commented check block of the `metInterpolacion*` scripts. |
| AC-4 | FR-N and FR-V give a MATLAB legend warning about extra entries, and their legend labels are shifted (known defect D1). |
| AC-5 | No files are created or modified by any script. |

## 5. Non-Functional Characteristics (as built)

| ID | Characteristic |
|---|---|
| NFR-1 | Source encoding ISO-8859-1, line endings CRLF. |
| NFR-2 | No input validation. Duplicate `x` values would cause a division by zero (Lagrange/Newton) or a singular matrix (Vandermonde). |
| NFR-3 | Numerical stability is limited by the explicit inverse and the monomial basis (see [possible-improvements.md](../docs/possible-improvements.md)). |
| NFR-4 | The scripts are independent. Any of them can run on its own. |

## 6. Repository Specification (post-modernization)

| ID | Requirement |
|---|---|
| RS-1 | Original scripts are in `src/` and byte-identical to commit `21bbed0`. |
| RS-2 | `src/SHA256SUMS` lists the SHA-256 of each original script, and `sha256sum -c` passes. |
| RS-3 | `.gitattributes` disables EOL normalization for `src/*.m`. |
| RS-4 | `README.md` covers overview, context, structure, original-implementation note, technologies, behavior, I/O, running, docs index, and historical note. |
| RS-5 | `docs/` holds context, methods, code overview, and improvements. The improvements are explicitly marked as not applied. |
| RS-6 | No CI, containers, package managers, build tools, or test frameworks are added. |
| RS-7 | Every contextual claim in the documentation is labeled or clearly worded as Confirmed, Inferred, or Unknown. |

## 7. Open Questions

- What is the origin of the project (course, institution, assignment)? Unknown.
- What does dataset D₆ represent (units, physical quantity)? Unknown.
- Which MATLAB version was used? Unknown.
- Do the scripts run unmodified in GNU Octave? Not verified.
