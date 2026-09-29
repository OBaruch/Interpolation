# Polynomial Interpolation in MATLAB

Four MATLAB scripts that build an interpolating polynomial from a set of discrete
points using three classical numerical methods: **Lagrange**, **Newton divided
differences**, and the **Vandermonde matrix**. A fourth script uses the Vandermonde
approach on Runge's function, `f(x) = 1 / (1 + x²)`.

> **Original implementation.** This repository keeps the original implementation
> of the project. The source code has deliberately not been refactored or
> modernized, so the historical context and the original development approach
> stay intact. Every file in [`src/`](src/) is byte-identical to the version
> uploaded in February 2021 (see [`src/SHA256SUMS`](src/SHA256SUMS)).

---

## Project Overview

| | |
|---|---|
| **Language** | MATLAB (`.m` scripts) |
| **Domain** | Numerical methods: polynomial interpolation |
| **Author** | Baruch Lopez |
| **Originally published** | 2021-02-20 (git history) |
| **Source language of comments** | Spanish |
| **License** | [MIT](LICENSE) |

Each script hard-codes a small dataset, computes the coefficients of the unique
polynomial of degree `N-1` that passes through the `N` points, evaluates it on a
dense grid, and plots the original points next to the interpolating polynomial.

## Project Context

**Project origin: Unknown.**

The repository has no assignment brief, report, course name, or institution, so
its origin cannot be confirmed. Some **inferred** signs point to numerical-methods
coursework: the scope is a textbook topic, the same method is implemented three
ways on one dataset, and the scripts contain commented-out test functions and
error-check snippets. None of this is confirmed. See
[`docs/project-context.md`](docs/project-context.md) for the evidence.

## Problem Statement

Given `N` samples `(xᵢ, f(xᵢ))` of an unknown or expensive function, find a
polynomial `P(x)` of degree `≤ N-1` with `P(xᵢ) = f(xᵢ)` for every sample. Then use
it to estimate the function between (and outside) the samples.

## Objective

*(Inferred from the code and comments)*: implement and compare three classical
ways to build the same interpolating polynomial, and see how it behaves visually,
including extrapolation away from the data and the behavior on Runge's function.

## Repository Structure

```
.
├── README.md                  # This file
├── LICENSE                    # MIT License (original, 2021)
├── AGENTS.md                  # Guardrails for automated contributors (src/ is read-only)
├── .gitattributes             # Keeps original CRLF / Latin-1 bytes untouched
├── .gitignore
├── src/                       # ORIGINAL implementation, unmodified
│   ├── metInterpolacionLagrange.m
│   ├── metInterpolacionNewton.m
│   ├── metInterpolacionVandermonde.m
│   ├── Vandermonde.m
│   └── SHA256SUMS             # Integrity checksums of the original files
├── docs/                      # Documentation added later
│   ├── project-context.md
│   ├── numerical-methods.md
│   ├── code-overview.md
│   └── possible-improvements.md
└── specs/                     # Intent → Spec → Plan (reverse-engineered)
    ├── intent.md
    ├── spec.md
    └── plan.md
```

There is no `data/` or `assets/` folder. The datasets are hard-coded inside the
scripts, and the original repository had no images, generated outputs, or
documents.

## Original Implementation

The files in `src/` are the original implementation, kept as-is:

- The logic, variable names, comments, formatting and known defects were not changed.
- The files keep their original **ISO-8859-1 (Latin-1)** encoding and **CRLF** line
  endings. `.gitattributes` turns off line-ending normalization for them.
- The only change is **location**: they moved from the repository root to `src/`
  with a pure rename (identical git blobs).

Observed defects and modernization ideas are listed separately in
[`docs/possible-improvements.md`](docs/possible-improvements.md). **None of them
have been applied.**

## Technologies

Confirmed from the code:

- **MATLAB** scripting language
- Built-in functions: `linspace`, `inv`, `poly`, `polyval`, `prod`, `sum`, `fliplr`,
  `ones`, `zeros`, `length`, `plot`, `legend`, `axis`, `clear`, `clc`

No toolboxes, external libraries, or configuration files are used. The MATLAB
version used originally is **unknown**.

## How It Works

| Script | Method | Data | Evaluation grid |
|---|---|---|---|
| [`metInterpolacionLagrange.m`](src/metInterpolacionLagrange.m) | Lagrange basis polynomials, expanded into monomial coefficients | 6 points, `x = 0:10:50` | `-20:0.01:100` |
| [`metInterpolacionNewton.m`](src/metInterpolacionNewton.m) | Newton divided-difference table, expanded into monomial coefficients | same 6 points | `-10:0.01:60` |
| [`metInterpolacionVandermonde.m`](src/metInterpolacionVandermonde.m) | Solves the Vandermonde system `V·a = f` | same 6 points | `-1000:0.01:1000` |
| [`Vandermonde.m`](src/Vandermonde.m) | Vandermonde system on Runge's function | 9 nodes on `[-2, 2]` | 1000 points on `[-5, 5]` |

All four scripts follow the same flow:

```
hard-coded samples ─► build coefficients ─► polyval / matrix product on dense grid ─► plot
```

The three `metInterpolacion*` scripts use the same dataset, so they produce the
**same polynomial** (up to floating-point error) by different routes:

```
P(x) ≈ 0.013 + 3.0983e-3·x − 3.3708e-4·x² + 1.8667e-5·x³ − 4.2917e-7·x⁴ + 3.5e-9·x⁵
```

*(Coefficients computed independently in exact rational arithmetic while writing
this documentation. They were not produced by the original scripts.)*

For more detail see [`docs/numerical-methods.md`](docs/numerical-methods.md) (the
math) and [`docs/code-overview.md`](docs/code-overview.md) (walkthrough of each
script).

## Inputs and Outputs

- **Inputs:** none from outside. The data points are hard-coded in each script
  (`x`, `fx` or `xn`, `yn`).
- **Outputs:**
  - A MATLAB figure with the sample points (`*`) and the interpolating polynomial
    (red line).
  - Workspace variables holding the coefficients in descending order, ready for
    `polyval` (`Coef` for Lagrange, `Pol` for Newton, `A` for Vandermonde). In
    `Vandermonde.m`, `C` holds them in ascending order.
- No files are read or written.

## Running the Project

Requirements, based on the code: a MATLAB installation with core functions only.
The exact MATLAB version is unknown.

```matlab
cd src
metInterpolacionLagrange      % or metInterpolacionNewton, metInterpolacionVandermonde, Vandermonde
```

Notes:

- The three `metInterpolacion*` scripts run `clear all; clc;`, which **clears the
  current workspace**.
- Accented characters in comments and legend labels are stored in Latin-1. MATLAB
  releases that expect UTF-8 may show them garbled. This is cosmetic.
- The scripts might also run in GNU Octave, since they only use core functions.
  This has **not been verified**.

## Verifying the Original Files

```bash
cd src && sha256sum -c SHA256SUMS
```

## Documentation

- [Project context](docs/project-context.md): origin, evidence, confirmed / inferred / unknown facts
- [Numerical methods](docs/numerical-methods.md): the math behind each script
- [Code overview](docs/code-overview.md): script-by-script walkthrough
- [Possible improvements](docs/possible-improvements.md): observed issues, **not applied**
- [Intent](specs/intent.md) · [Spec](specs/spec.md) · [Plan](specs/plan.md): spec-driven record of the project and of this reorganization

## Historical Note

This repository was reorganized and documented later to make it easier to read
and to preserve the historical context of the original project. The original
source code is unchanged. The original commits (`Initial commit`,
`Add files via upload`, 2021-02-20) are kept in the git history.
