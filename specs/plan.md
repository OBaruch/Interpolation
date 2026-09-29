# Plan

> **Status:** Executed (2026).
> **Artifact chain:** [Intent](intent.md) → [Spec](spec.md) → **Plan**
>
> The implementation plan for the repository modernization, kept as a record of
> what was done and how it was verified. It changes the **repository**, not the
> **code**.

## 0. Constraints

- **C1:** Do not modify any byte of the original `.m` files. Moves must be pure
  git renames.
- **C2:** Keep the original `LICENSE` and the git history.
- **C3:** Do not add infrastructure that the project did not have (CI, Docker,
  package managers, linters, test frameworks, Makefiles).
- **C4:** Do not invent context. Label each claim Confirmed / Inferred / Unknown.
- **C5:** All documentation in English.

## 1. Discovery

| Step | Action | Result |
|---|---|---|
| 1.1 | Inventory all tracked files | 4 `.m` scripts plus `LICENSE`. No PDFs, Word files, images, data files, or outputs. |
| 1.2 | Inspect encoding and line endings | ISO-8859-1, CRLF on all `.m` files |
| 1.3 | Read every script and its comments (decoded from Latin-1) | Lagrange, Newton, Vandermonde interpolation on a shared 6-point dataset, plus a Runge-function demo |
| 1.4 | Inspect git metadata | 2 commits by Baruch Lopez on 2021-02-20, uploaded through the GitHub web UI |
| 1.5 | Cross-check the commented error-check snippet | The degree-8 polynomial in the snippet matches the interpolant of `1/(1+x²)` at `linspace(-2,2,9)` (exact arithmetic), which links it to `Vandermonde.m` |
| 1.6 | Classify origin | **Unknown.** Coursework is suspected but not confirmed. |

## 2. Target Structure

```
.
├── README.md
├── LICENSE
├── AGENTS.md
├── .gitattributes
├── .gitignore
├── src/            # original scripts + SHA256SUMS
├── docs/           # project-context, numerical-methods, code-overview, possible-improvements
└── specs/          # intent, spec, plan
```

Folders considered and rejected:

- `data/`: the data is hard-coded, and extracting it would require editing code.
- `assets/`: there were no original images.
- `docs/original/`: there were no original documents.
- `archive/`: there were no duplicates or old versions.
- `docs/architecture.md`: four independent scripts have no meaningful
  architecture.

## 3. Tasks

- [x] **T1** Create the working branch `docs/repository-modernization`.
- [x] **T2** `git mv` the four scripts into `src/` (C1).
- [x] **T3** Generate `src/SHA256SUMS` from the original files.
- [x] **T4** Add `.gitattributes` (`src/*.m -text`) so line endings are never normalized.
- [x] **T5** Add a minimal MATLAB/Octave `.gitignore`.
- [x] **T6** Write `README.md`.
- [x] **T7** Write `docs/project-context.md` (evidence table, classification, timeline).
- [x] **T8** Write `docs/numerical-methods.md` (the math behind each script).
- [x] **T9** Write `docs/code-overview.md` (line-referenced walkthrough).
- [x] **T10** Write `docs/possible-improvements.md`, explicitly marked as not applied.
- [x] **T11** Write `specs/intent.md`, `specs/spec.md`, and `specs/plan.md`.
- [x] **T12** Add `AGENTS.md` with guardrails for future automated contributors.
- [x] **T13** Verify (section 4) and open a pull request.

## 4. Verification

| Check | Command / method | Expected |
|---|---|---|
| V1: originals unchanged | `cd src && sha256sum -c SHA256SUMS` | All `OK` |
| V2: pure renames | `git diff --stat -M 21bbed0 HEAD -- '*.m'` | Four renames, 0 lines changed |
| V3: no infra added | Inspect the tree | No CI/Docker/build files |
| V4: links resolve | Check every relative link in `*.md` | Every target exists |
| V5: numbers in docs | Independent exact-arithmetic computation of both interpolants | Matches the coefficients stated in the docs and in the spec (AC-1, AC-3) |

## 5. Risks and Mitigations

| Risk | Mitigation |
|---|---|
| An editor or git setting rewrites CRLF or re-encodes the Latin-1 files | `.gitattributes` `-text`, plus checksums to detect drift |
| A future contributor "fixes" the code in place | `AGENTS.md` guardrails, the README notice, and a separate improvements document |
| An inference is later read as fact | Confirmed/Inferred/Unknown labels throughout |

## 6. Future Work (not scheduled)

- If the original assignment brief or report is found, add it under
  `docs/original/`, summarize it in `docs/assignment.md`, and update the
  classification in `docs/project-context.md`.
- Optionally build a modern reimplementation in a **separate** folder or
  repository, using [possible-improvements.md](../docs/possible-improvements.md)
  and the acceptance criteria in [spec.md](spec.md#4-acceptance-criteria-observable-behavior).
