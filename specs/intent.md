# Intent

> **Status:** Reverse-engineered from the existing repository (2026).
> **Artifact chain:** **Intent** → [Spec](spec.md) → [Plan](plan.md)
>
> This document states *why* the project exists and *why* the repository was
> reorganized. The intent of the original work is reconstructed from evidence
> and labeled **Confirmed / Inferred / Unknown**. It was not written when the
> code was created.

## 1. Original Project Intent

### Problem

Estimate the values of a function known only at a few discrete points by building
the unique polynomial that passes through all of them. *(Confirmed: header
comments of each `metInterpolacion*` script.)*

### Why it was built

- **Inferred:** to implement and compare the three classical constructions of the
  interpolating polynomial (Lagrange, Newton divided differences, Vandermonde
  matrix) on the same data, and to look at the results graphically.
- **Inferred:** to observe the limits of polynomial interpolation, namely
  extrapolation outside the data range and Runge's function `1/(1+x²)` on
  equally spaced nodes.
- **Unknown:** whether it was a course assignment, self-study, or personal
  experiment. The repository has no documents that settle this. See
  [`docs/project-context.md`](../docs/project-context.md).

### Intended users

The author, as a learning or exploration tool. *(Inferred.)*

### Desired outcome

For a given dataset, get the polynomial coefficients and a plot showing the data
points together with the interpolating curve. *(Confirmed from the code
behavior.)*

## 2. Repository Modernization Intent

### Problem

The repository had four loosely named MATLAB scripts at its root, no README, no
explanation of what the scripts do or how they relate, and no statement about
their origin. A reader had to open and decode Spanish-commented, Latin-1-encoded
files to understand anything.

### Goal

Make the repository **clear, navigable, and presentable as a historical portfolio
piece**. The **original implementation must stay exactly as written.**

> *Modernize the repository, not the project.*

### Principles (non-negotiable)

1. **Preservation over cleanup.** The code in `src/` is byte-for-byte identical to
   the 2021 upload: same logic, names, comments, formatting, defects, encoding
   (ISO-8859-1), and line endings (CRLF).
2. **No invented history.** Every claim is Confirmed, Inferred, or Unknown.
   Inferences are never presented as facts.
3. **No over-engineering.** No build systems, CI, containers, package managers,
   linters, or test frameworks. The structure fits a four-script project.
4. **Separation of old and new.** Documentation added later is clearly separate
   from the original implementation. Suggested improvements are documented only.
5. **Verifiability.** The integrity of the originals can be checked mechanically
   (`src/SHA256SUMS`).

### Success looks like

- A newcomer understands what the project does, how each script works, and what
  is and isn't known about its origin, without opening the `.m` files.
- `sha256sum -c src/SHA256SUMS` passes.
- The git history shows only renames for the original files.

### Out of scope

- Fixing bugs, refactoring, reformatting, or re-encoding the MATLAB code.
- Adding new features or a modern reimplementation.
- Claiming a specific university, course, or assignment.
