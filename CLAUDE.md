# CLAUDE.MD -- ESG Risk and Regulatory Uncertainty

**Project:** ESG Risk and Regulatory Uncertainty: Evidence from U.S. Climate-Disclosure Shocks
**Author:** Byeong-Hak Choe (single-authored)
**Institution:** SUNY Geneseo
**Type:** Empirical paper + R workflow
**Branch:** main

> This repo is a working *research project* built on a fork of the
> `claude-code-my-workflow` template. The template ships slide/lecture
> infrastructure (`Slides/`, `Quarto/`, TikZ rules, palette sync). For THIS
> project that scaffolding is **dormant** — kept in place for a possible future
> teaching path (`/teach-from-paper`), not used for the paper. Active work is
> **R data prep → IV estimation → LaTeX tables → LaTeX manuscript.**

---

## Research Summary

A two-period (March 2024, March 2025) firm-year panel of U.S. companies that asks
whether *within-firm* changes in ESG risk ratings causally affect corporate and
capital-market outcomes — moving beyond the cross-sectional ESG correlations that
dominate the literature.

**Identification.** First differences (2025 − 2024) instrumented by Sustainalytics'
**2024 rating-system change**: the methodology update mechanically shifted measured
E/S/G risk for firms exposed to specific enhancements (water, cyber/data-privacy,
stakeholder-governance), giving a source of quasi-exogenous variation in ΔE, ΔS, ΔG.
Industry-level exposure to each enhancement × the rating change → instruments
`Z_E`, `Z_S`, `Z_G`.

**Candidate outcomes.** Cost of capital, investor response, firm risk, liquidity,
controversy, and real corporate behavior (investment, financing).

---

## Core Principles

- **Plan first** — enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`.
- **Verify after** — run the R pipeline / compile the paper and confirm outputs at the end of every task.
- **Single source of truth** — the **R pipeline produces every number**; the LaTeX manuscript is authoritative for prose. Each coefficient, SE, N, and percentage in `paper/` traces to a file in `scripts/R/_outputs/` and is logged in the claims passport.
- **Reproducibility is non-negotiable** — `set.seed()` once, relative paths, `00_run_all.R` reruns clean end-to-end (see `.claude/rules/r-code-conventions.md`).
- **Publication-ready visuals** — every figure is print-quality on the first pass (`theme_paper()`, LaTeX column dimensions). No default-ggplot gray.
- **Quality gates** — nothing ships below 80/100.
- **[LEARN] tags** — when corrected, save `[LEARN:category] wrong → right` to [MEMORY.md](MEMORY.md) so decisions are not re-litigated.

Cross-session context lives in [MEMORY.md](MEMORY.md); plans, specs, session logs, and the claims passport are in [quality_reports/](quality_reports/).

---

## Folder Structure

```
esg-risk-santanna/
├── CLAUDE.MD                    # This file
├── .claude/                     # Rules, skills, agents, hooks
├── data/
│   ├── raw/                     # PROPRIETARY — gitignored (Sustainalytics + Yahoo Finance)
│   └── cleaned/                 # Derived, model-ready data (gitignored)
├── scripts/R/                   # Analysis pipeline (00→05) + esg-messy.R (exploratory)
│   └── _outputs/                # Tables, figures, RDS — generated, gitignored
├── paper/                       # LaTeX manuscript (main.tex); tables/figures from _outputs/
├── Bibliography_base.bib        # Centralized bibliography
├── quality_reports/             # Plans, specs, session logs, passports, decision records
├── explorations/                # Research sandbox (see rules)
├── templates/                   # Session log, spec, passport, decision-record templates
└── Slides/, Quarto/, Figures/   # DORMANT — template teaching path, not used for the paper
```

**Data is proprietary.** Sustainalytics ESG ratings are licensed; the remote is public.
`data/raw/` and `data/cleaned/` are gitignored — commit *code* and disclosure-cleared
*derived outputs* only. See [`.claude/rules/confidential-data.md`](.claude/rules/confidential-data.md).

---

## Commands

```bash
# Run the full R pipeline (seeded, end-to-end) — run this, not individual scripts
Rscript scripts/R/00_run_all.R

# Quality score an R script
python scripts/quality_score.py scripts/R/02_clean.R

# Audit every numeric claim in the paper against scripts/R/_outputs/
# (via the /audit-reproducibility skill)

# Compile the manuscript (from paper/)
cd paper && latexmk -pdf main.tex      # or: xelatex -interaction=nonstopmode main.tex
```

---

## Quality Thresholds (advisory)

| Score | Checkpoint | Meaning |
|-------|------|---------|
| 80 | Commit | Good enough to save |
| 90 | PR | Ready for deployment |
| 95 | Excellence | Aspirational |

Enforced by `/commit` (halts + asks for override) **and** — once you run `./scripts/install-hooks.sh` — by a git pre-commit hook (`.githooks/pre-commit`). Bypass sparingly with `SKIP_QUALITY_GATE=1` or `--no-verify`.

---

## Active Rules (this project)

These load when relevant and govern the work:

- **`r-code-conventions`** — R standards, the project palette, `theme_paper()`, numerical discipline.
- **`replication-protocol`** + claims **passport** (`quality_reports/passports/esg-risk.yaml`) — every paper number traces to code.
- **`inference-robustness`** — multiple testing across E/S/G × outcomes; weak-IV reporting (first-stage robust F).
- **`cross-artifact-review`** — `/review-paper` also reviews the R scripts that produced the tables.
- **`confidential-data`** — proprietary-data handling (the gitignore + disclosure contract above).
- **`writing-style-choe`** — the manuscript's voice (single-authored "I").
- **`plan-first-workflow`**, **`session-logging`**, **`quality-gates`** — process.
- `did-conventions` is **reference-only** — the design is IV / first-differences, not staggered DiD.

**Dormant** (slides not in active use): `beamer-quarto-sync`, `no-pause-beamer`, `tikz-*`,
`single-source-of-truth` (slide-framed), `content-invariants` INV-1…INV-8, palette sync.
Empirical invariants INV-9…INV-16 (in `content-invariants.md`) are **active**.

---

## Skills Quick Reference (most-used for this project)

- **Data / reproducibility:** `/data-analysis` `/audit-reproducibility` `/diagnose` `/replication-package` `/capture-environment` `/power-analysis` `/disclosure-check`
- **Papers / review:** `/review-paper` (`--peer`) `/seven-pass-review` `/respond-to-referees` `/verify-claims` `/proofread` `/humanize`
- **Research / writing:** `/interview-me` `/lit-review` `/research-ideation` `/preregister`
- **R review:** `/review-r` `/r-package-check`
- **Meta / workflow:** `/commit` `/learn` `/checkpoint` `/context-status` `/deep-audit`

Full index in [README.md](README.md#skills-claudeskills).

---

## Current Project State

| Milestone | Status | Artifact |
| --- | --- | --- |
| Workflow config adapted | ✅ done | `CLAUDE.md`, rules, `.gitignore` |
| Data prep (esg-messy.R → 01_load/02_clean) | 🔜 next | model-ready `data.frame` |
| IV construction (exposure map → Z_E/Z_S/Z_G) | ⏳ | `03_analyze.R` |
| First-stage / weak-IV diagnostics | ⏳ | first-stage robust F (F > 10) |
| Outcome models (cost of capital, risk, liquidity, …) | ⏳ | `03_analyze.R`, `04_tables.R` |
| Publication figures | ⏳ | `05_figures.R` → `_outputs/` |
| Manuscript draft | ⏳ | `paper/main.tex` |

**Data sources.** Sustainalytics ESG risk/pillar/controversy (`esg_proj_2024.csv`,
`esg_proj_2025.csv`) + the rating-enhancement overview (`ds_standard_esg-risk-…csv`);
Yahoo Finance income / balance-sheet / cash-flow (annual + quarterly) for controls and outcomes.

**Note.** `esg-messy.R` is exploratory scratch (and reads from `data/` not `data/raw/` — a
known path bug). It is the *input* to the data-prep task, not a deliverable; it gets refactored
into the numbered `01_load.R` → `05_figures.R` pipeline.
