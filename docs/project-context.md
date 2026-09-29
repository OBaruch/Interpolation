# Project Context

← [Back to README](../README.md)

This document collects what can and cannot be established about where this
project came from. Each statement is tagged:

- **Confirmed**: backed directly by a file, the code, or the git history.
- **Inferred**: a reasonable conclusion from the repository, not proven.
- **Unknown**: the repository does not contain enough information.

## Sources Examined

The original repository had only six tracked files:

| File | Type | Content |
|---|---|---|
| `LICENSE` | Text | MIT License, "Copyright (c) 2021 Baruch Lopez" |
| `metInterpolacionLagrange.m` | MATLAB script | Lagrange interpolation |
| `metInterpolacionNewton.m` | MATLAB script | Newton divided-difference interpolation |
| `metInterpolacionVandermonde.m` | MATLAB script | Vandermonde-matrix interpolation |
| `Vandermonde.m` | MATLAB script | Vandermonde interpolation of Runge's function |
| *(git history)* | Metadata | 2 commits by Baruch Lopez on 2021-02-20 |

The repository had **no** PDF, Word, PowerPoint, image, diagram, notebook,
dataset file, generated output, or README. All context below comes from the code,
its comments, file names, the license, and the git metadata.

## Project Origin

**Classification: Unknown.**

| Signal | Status | Notes |
|---|---|---|
| Author is Baruch Lopez | Confirmed | `LICENSE` and both commits |
| Published on 2021-02-20 | Confirmed | Commit timestamps (UTC-06:00) |
| Code was written before or on that date | Confirmed | Upload date. The actual writing date is unknown. |
| Topic is polynomial interpolation | Confirmed | Code and header comments |
| Comments written in Spanish | Confirmed | e.g. `%MÉTODO DE INTERPOLACIÓN DE LAGRANGE` |
| Written on Windows | Inferred | CRLF line endings and ISO-8859-1 encoding are typical of the MATLAB editor on Windows with a Spanish locale |
| Part of numerical-methods coursework | Inferred | Textbook topic; the same problem solved with three standard methods; one shared test dataset; commented-out test functions and error-check snippets typical of exercises |
| University, course, assignment, grade | Unknown | No documents or references in the repository |
| Meaning of the dataset | Unknown | `x = [0;10;20;30;40;50]` and `fx = [0.013; …; 0.07]` have no units or description |

Because no document confirms an academic origin, the project is **not**
presented here as a university assignment. If you have other material (for
example, the original assignment brief), add it under `docs/original/` and update
this classification.

## Purpose

- **Confirmed:** each `metInterpolacion*` script builds an interpolating polynomial
  from discrete data and plots it. The Spanish header comments say so directly.
  For example, the Lagrange script says it is a *"Función para crear un
  interpolador de Lagrange a partir de los siguientes datos"* ("function to
  create a Lagrange interpolator from the following data").
- **Inferred:** the goal was to learn or show the three classical construction
  methods and to observe the results, including:
  - extrapolation outside the data range (evaluation grids reach far beyond the
    `[0, 50]` data interval);
  - interpolation of Runge's function `1/(1+x²)` in `Vandermonde.m`, a standard
    example of polynomial interpolation's limits.

## Traces of Experimentation in the Code

The scripts contain commented-out code that shows how they were exercised. These
are **observations**. Their exact purpose is inferred.

1. **Alternative test functions.** Each script has a commented "original function"
   block (`xo`, `fxo`) and a commented analytic `fx`, for example
   `cos(x.^2)+x.^3-3*x.^2+exp(-2*x)`. This suggests the same scripts were first
   run on synthetic functions and later on the hard-coded tabular data.
2. **Legend labels left over from those runs.** The Newton and Vandermonde scripts
   still have a three-entry legend (`'Gráfica original'`, …) although the plot of
   the original function is commented out.
3. **Error-check snippet for Runge's function.** All three `metInterpolacion*`
   scripts end with the same commented block:

   ```matlab
   % f=@(x)(1./(1+x.^2));
   % x=[-2; -1.5; -1; -0.5; 0; 0.5; 1; 1.5; 2];
   % P=@(x)(0.0246*x.^8-0.2092*x.^6+0.6292*x.^4-0.9446*x.^2+1);
   % [f(x),P(x),abs(f(x)-P(x))]
   ```

   While writing this documentation, the degree-8 interpolant of `1/(1+x²)` at the
   nine nodes `-2:0.5:2` was computed independently in exact arithmetic. Its
   coefficients, rounded to 4 decimals, are exactly
   `1, 0, −0.9446, 0, 0.6292, 0, −0.2092, 0, 0.0246`. These are the coefficients
   of `P` above, and the nine nodes are the same ones that `Vandermonde.m` builds
   with `linspace(-2,2,9)`. **Confirmed (numerically):** this snippet checks the
   polynomial that `Vandermonde.m` produces against the true function.

## Scope

- Univariate polynomial interpolation only (no splines, least squares, or
  piecewise methods).
- Hard-coded data. No user input, file I/O, or reusable functions.
- Visual output only. The scripts do not report errors or print results.

## Historical Timeline

| Date | Event | Source |
|---|---|---|
| ≤ 2021-02-20 | Scripts written | Inferred (upload date is an upper bound) |
| 2021-02-20 | `Initial commit` (LICENSE) | Git history |
| 2021-02-20 | `Add files via upload` (4 `.m` files) | Git history. The message indicates the GitHub web uploader. |
| 2026 | Repository reorganized and documented, code left unchanged | This documentation; see [`specs/plan.md`](../specs/plan.md) |
