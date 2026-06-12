---
paths:
  - "Slides/**/*.tex"
  - "Quarto/**/*.qmd"
  - "Quarto/**/*.scss"
  - "Preambles/header.tex"
  - "scripts/R/**/*.R"
  - "paper/**/*.tex"
---

# Content Invariants (INV-1 through INV-16)

Numbered non-negotiable rules for content produced in this repository. Critic agents, reviewers, and audit agents should cite invariants by number (e.g., "violates INV-3") when flagging issues. Adapted from clo-author's enforcement pattern.

> **Project status (ESG Risk paper).** This is a paper+R project; the slide deck is
> dormant. **INV-1…INV-8 are DORMANT** (they govern Beamer/Quarto slides not in active
> use) and reactivate only if the teaching path is revived. **INV-9…INV-12 (R scripts)
> and INV-13…INV-16 (empirical paper) are ACTIVE.**

## Slide invariants (DORMANT — slides not in active use)

- **INV-1: Palette sync.** Color names in `Preambles/header.tex` must match SCSS variables in `Quarto/theme-template.scss`. Verify with `./scripts/check-palette-sync.sh`. Any new color added to one must be added to the other.
- **INV-2: Beamer↔Quarto notation parity.** Every math symbol, variable name, and subscript in a Beamer `.tex` slide must appear identically in its Quarto `.qmd` mirror. Notation drift between the two is a critical bug.
- **INV-3: Quarto CSS override contract.** Styles that must override Bootstrap defaults (e.g., inline code color, code block background) go in `include-in-header` as a raw `<style>` tag, never in the SCSS file. SCSS is only for styles that do not need to beat Bootstrap's cascade — Bootstrap's own selectors win specificity wars otherwise.
- **INV-4: TikZ as SVG.** Browsers cannot render PDF images inline. All TikZ diagrams in Quarto/HTML must be SVG, produced via `/extract-tikz`. Never embed a `.pdf` in a `.qmd` slide.
- **INV-5: Single bibliography.** `Bibliography_base.bib` is the canonical bibliography. No per-lecture `.bib` files. All citations must resolve against this one file.

## Slide design invariants

- **INV-6: No `\pause` or overlays.** Beamer `\pause`, `\only`, `\visible`, `\onslide` commands are forbidden. See `.claude/rules/no-pause-beamer.md` for rationale.
- **INV-7: Max 2 colored boxes per slide.** Overusing `keybox`, `definitionbox`, or callout environments creates "box fatigue." Two per slide maximum.
- **INV-8: Motivation before formalism.** Every definition must be preceded by a motivating example, intuition, or real-world question. No unmotivated math.

## R script invariants

- **INV-9: `set.seed()` once at top.** Every R script that uses randomness must call `set.seed(N)` exactly once, at the top of the script, before any stochastic code. Never inside loops or functions.
- **INV-10: Relative paths only.** No absolute paths (`/Users/...`, `C:\...`, `~` expansion). All paths relative to the repository root. Use `file.path()` for cross-platform compatibility.
- **INV-11: Transparent backgrounds for Beamer figures.** All `ggsave()` calls producing figures for Beamer slides must include `bg = "transparent"`.
- **INV-12: Project theme on all plots.** Every ggplot figure must use the project's custom theme (`theme_paper()`). No default ggplot2 gray backgrounds should appear in any committed figure. Paper figures use white backgrounds and LaTeX column dimensions (see `r-code-conventions.md` §4).

## Empirical-paper invariants (ACTIVE — ESG Risk project)

- **INV-13: Every number traces to code.** Each coefficient, standard error, sample size, and percentage in `paper/` is produced by a `scripts/R/` script, written to `scripts/R/_outputs/`, and logged in the claims passport (`quality_reports/passports/esg-risk.yaml`). No number is hand-typed into the manuscript. Enforced by `/audit-reproducibility`.
- **INV-14: Instrument provenance.** The IV exposure map (industry → enhancement exposure) and the E/S/G pillar tagging derived from the Sustainalytics 2024 rating-enhancement catalog are versioned in code, documented, and never edited silently. Any change to the exposure mapping is recorded in a session log + a decision record (`quality_reports/decisions/`), because it changes the instruments `Z_E`, `Z_S`, `Z_G`.
- **INV-15: Weak-IV reporting.** Every IV estimate ships with its first-stage robust (HC1) excluded-instrument F statistic and the standard weak-IV diagnostic. F < 10 (rule of thumb) is reported, never hidden. Just-identified and over-identified specifications both report first-stage strength per endogenous regressor.
- **INV-16: First-difference discipline.** Δ outcomes and Δ regressors are firm-level 2025 − 2024. The estimation sample is the **balanced** two-year panel (firms present in both March 2024 and March 2025); firms appearing in only one year are dropped before differencing, and the drop count is reported.
