# Contributor & Agent Guidelines

Rules for anyone, human or automated, who changes this repository.

## Hard rules

1. **`src/` is read-only.** Never edit, reformat, re-encode, rename, or "fix" the
   original MATLAB files. They are preserved on purpose, including their defects,
   ISO-8859-1 encoding, and CRLF line endings.
2. After any change, verify integrity:
   ```bash
   cd src && sha256sum -c SHA256SUMS
   ```
3. Do not add infrastructure the project never had (CI, containers, package
   managers, linters, test frameworks, build files) unless the owner asks.
4. Do not invent history. Label contextual claims **Confirmed**, **Inferred**,
   or **Unknown**, following [`docs/project-context.md`](docs/project-context.md).
5. Write documentation in English.

## Where things go

| Change | Location |
|---|---|
| Explanations of the original code | `docs/` |
| Observed issues / modernization ideas | `docs/possible-improvements.md` (document only) |
| Newly found original documents (PDF, Word, …) | `docs/original/` (unaltered) |
| Intent, requirements, plans for repository work | `specs/` |
| A modern reimplementation, if ever wanted | A new top-level folder (e.g. `modern/`) or a separate repository, never `src/` |

## Workflow

Follow the spec-driven chain in `specs/`: update [intent](specs/intent.md) if
the goal changes, [spec](specs/spec.md) if the documented behavior or repository
requirements change, and [plan](specs/plan.md) with the tasks and verification
for the change.
